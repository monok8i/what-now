"""Import social-service data from the poskytovatele JSON and CSV exports."""

from __future__ import annotations

import argparse
import asyncio
import csv
import json
from datetime import date
from pathlib import Path
import sys
from collections.abc import Iterable
from typing import Any, cast

if __package__ in {None, ""}:
    sys.path.insert(0, str(Path(__file__).resolve().parents[3]))

from sqlalchemy import delete

from src.core.config._global import config
from src.infra.db.models import ServiceLocation, ServiceTargetGroup, SocialService
from src.infra.db.session import get_async_session
from src.infra.embeddings.client import SentenceTransformerEmbeddingClient
from src.utils.coords import normalize_optional_text, parse_optional_decimal


DEFAULT_DATA_DIR = Path(__file__).with_name("poskytovatele")


def parse_iso_date(value: str) -> date:
    """Parse a date in ISO format (YYYY-MM-DD)."""

    return date.fromisoformat(value)


def parse_optional_date(value: str | None) -> date | None:
    """Parse an optional ISO date value."""

    normalized_value = normalize_optional_text(value)
    if normalized_value is None:
        return None

    return date.fromisoformat(normalized_value)


def bool_from_int(value: Any) -> bool:
    """Convert integer-style flags from the JSON export into booleans."""

    return bool(value)


def build_parser() -> argparse.ArgumentParser:
    """Build the CLI parser for the import script."""

    parser = argparse.ArgumentParser(
        description="Import social services, locations, and target groups from poskytovatele exports."
    )
    parser.add_argument(
        "--data-dir",
        type=Path,
        default=DEFAULT_DATA_DIR,
        help="Directory that contains matching JSON and CSV exports.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Parse the CSV files and print counts without writing to the database.",
    )
    parser.add_argument(
        "--embedding-batch-size",
        type=int,
        default=config.embeddings.EMBEDDING_BATCH_SIZE,
        help="Batch size used when generating ServiceTargetGroup embeddings.",
    )
    return parser


def load_json_exports(data_dir: Path) -> list[dict[str, Any]]:
    """Load all service export records from matching JSON files."""

    if not data_dir.exists():
        raise FileNotFoundError(f"Data directory does not exist: {data_dir}")

    records: list[dict[str, object]] = []
    for json_path in sorted(data_dir.glob("*.json")):
        payload: Any = json.loads(json_path.read_text(encoding="utf-8"))
        if not isinstance(payload, dict):
            raise ValueError(f"Unexpected JSON structure in {json_path}")
        payload = cast(dict[str, Any], payload)

        entries: Any = payload.get("list", [])
        if not isinstance(entries, list):
            raise ValueError(f"Unexpected 'list' value in {json_path}")
        entries = cast(list[Any], entries)

        for entry in entries:
            if not isinstance(entry, dict):
                raise ValueError(f"Unexpected service entry in {json_path}")
            records.append({"json_path": json_path, **cast(dict[str, Any], entry)})

    return records


def load_csv_rows(data_dir: Path) -> dict[int, dict[str, str]]:
    """Load the CSV address rows keyed by service id."""

    rows_by_service_id: dict[int, dict[str, str]] = {}
    for csv_path in sorted(data_dir.glob("*_adresy.csv")):
        with csv_path.open(encoding="utf-8", newline="") as csv_file:
            reader = csv.DictReader(csv_file)
            for row in reader:
                service_id = int(row["sluzba"])
                rows_by_service_id[service_id] = row

    return rows_by_service_id


def get_json_service_ids(service_records: list[dict[str, Any]]) -> set[int]:
    """Extract the service ids present in the JSON exports."""

    service_ids: set[int] = set()
    for record in service_records:
        service = record.get("sluzba")
        if not isinstance(service, dict):
            continue
        service = cast(dict[str, Any], service)

        service_id = service.get("id")
        if isinstance(service_id, int):
            service_ids.add(service_id)

    return service_ids


def choose_service_location_name(service: dict[str, Any]) -> str | None:
    """Pick the most useful location name from the service payload."""

    raw_locations = service.get("sluzbyVZarizeni", [])
    if not isinstance(raw_locations, list):
        return None
    raw_locations = cast(list[Any], raw_locations)

    def iter_locations() -> Iterable[dict[str, Any]]:
        for item in raw_locations:
            if isinstance(item, dict):
                yield cast(dict[str, Any], item)

    contact_locations = [
        location
        for location in iter_locations()
        if bool_from_int(location.get("kontaktniAdresa"))
        and not bool_from_int(location.get("utajenaAdresa"))
    ]
    chosen_location = (
        contact_locations[0]
        if contact_locations
        else next(iter(iter_locations()), None)
    )
    if chosen_location is None:
        return None

    return normalize_optional_text(
        chosen_location.get("nazevZarizeni")
        if isinstance(chosen_location.get("nazevZarizeni"), str)
        else None
    )


async def backfill_target_group_embeddings(
    target_groups: list[ServiceTargetGroup],
    *,
    batch_size: int,
) -> int:
    """Generate embeddings for imported target-group descriptions."""

    groups_with_description = [
        target_group for target_group in target_groups if target_group.description
    ]
    if not groups_with_description:
        return 0

    embedding_client = SentenceTransformerEmbeddingClient(
        model_name=config.embeddings.EMBEDDING_MODEL_NAME,
        device=config.embeddings.EMBEDDING_DEVICE,
        normalize_embeddings=config.embeddings.EMBEDDING_NORMALIZE,
        batch_size=batch_size,
    )

    updated = 0
    for index in range(0, len(groups_with_description), batch_size):
        batch_groups = groups_with_description[index : index + batch_size]
        batch_texts = [
            target_group.description.strip()
            for target_group in batch_groups
            if target_group.description
        ]
        if not batch_texts:
            continue

        embeddings = await embedding_client.generate_embeddings(batch_texts)
        if len(embeddings) != len(batch_groups):
            raise RuntimeError(
                "Embedding count mismatch: "
                f"got {len(embeddings)} vectors for {len(batch_groups)} target groups."
            )

        for target_group, embedding in zip(batch_groups, embeddings):
            target_group.embedding = embedding
            updated += 1

    return updated


def build_models(
    service_records: list[dict[str, Any]],
    address_rows: dict[int, dict[str, str]],
) -> tuple[list[SocialService], list[ServiceLocation], list[ServiceTargetGroup]]:
    """Convert JSON and CSV records into ORM model instances."""

    services: list[SocialService] = []
    locations: list[ServiceLocation] = []
    target_groups: list[ServiceTargetGroup] = []

    for record in service_records:
        service = record.get("sluzba")
        provider = record.get("poskytovatel")
        if not isinstance(service, dict) or not isinstance(provider, dict):
            raise ValueError(f"Invalid service record in {record.get('json_path')}")

        service = cast(dict[str, Any], service)
        provider = cast(dict[str, Any], provider)

        service_id = int(service["id"])
        csv_row = address_rows.get(service_id)
        if csv_row is None:
            raise KeyError(f"Missing CSV address row for service id {service_id}")

        service_identifier = str(service["identifikator"])
        provider_data = provider.get("osobaPoskytovatele", {})
        if not isinstance(provider_data, dict):
            provider_data = {}
        provider_data = cast(dict[str, Any], provider_data)

        provider_ico = provider_data.get("ico")
        if not isinstance(provider_ico, str):
            provider_ico = None

        active_to_value = service.get("datumPoskytovaniDo")
        if not isinstance(active_to_value, str):
            active_to_value = None

        target_groups_raw = service.get("ciloveSkupinySocialniSluzby", [])
        if not isinstance(target_groups_raw, list):
            target_groups_raw = []
        target_groups_raw = cast(list[Any], target_groups_raw)

        services.append(
            SocialService(
                source_service_id=service_id,
                identifier=service_identifier,
                provider_id=int(provider["id"]),
                provider_name=str(provider["nazevPoskytovatele"]),
                provider_ico=normalize_optional_text(provider_ico),
                service_type_id=int(service["druhSocialniSluzbyId"]),
                active_from=parse_iso_date(str(service["datumPoskytovaniOd"])),
                active_to=parse_optional_date(active_to_value),
                region_scope_by_address=bool_from_int(
                    service.get("pusobnostVKrajiDleAdresy")
                ),
            )
        )

        locations.append(
            ServiceLocation(
                service_id=service_id,
                provider_id=int(provider["id"]),
                street=normalize_optional_text(csv_row.get("ulice")),
                number=normalize_optional_text(csv_row.get("cislo")),
                district=normalize_optional_text(csv_row.get("cast")),
                municipality=normalize_optional_text(csv_row.get("obec")),
                postal_code=normalize_optional_text(csv_row.get("psc")),
                region=normalize_optional_text(csv_row.get("kraj")),
                service_name=choose_service_location_name(service),
                lat=parse_optional_decimal(csv_row.get("lat")),
                lon=parse_optional_decimal(csv_row.get("lon")),
            )
        )

        for target_group in target_groups_raw:
            if not isinstance(target_group, dict):
                continue

            target_group = cast(dict[str, Any], target_group)
            additional_information = target_group.get("doplnujiciInformace")
            if not isinstance(additional_information, str):
                additional_information = None

            target_groups.append(
                ServiceTargetGroup(
                    service_id=service_id,
                    source_group_id=int(target_group["cilovaSkupinaOsobyId"]),
                    description=normalize_optional_text(additional_information),
                )
            )

    return services, locations, target_groups


def get_unmatched_csv_service_ids(
    service_records: list[dict[str, Any]], address_rows: dict[int, dict[str, str]]
) -> set[int]:
    """Return CSV service ids that do not have a JSON service record."""

    return set(address_rows) - get_json_service_ids(service_records)


async def import_rows(
    service_records: list[dict[str, Any]],
    address_rows: dict[int, dict[str, str]],
    embedding_batch_size: int,
) -> None:
    """Replace existing rows for the imported services and write fresh ones."""

    if not service_records:
        print("No JSON service records found. Nothing to import.")
        return

    services, locations, target_groups = build_models(service_records, address_rows)
    service_ids = [service.source_service_id for service in services]

    engine = config.db.ENGINE
    if engine is None:
        raise RuntimeError("Database engine is not configured.")

    embeddings_updated = 0
    async for session in get_async_session(engine):
        await session.execute(
            delete(ServiceTargetGroup).where(
                ServiceTargetGroup.service_id.in_(service_ids)
            )
        )
        await session.execute(
            delete(ServiceLocation).where(ServiceLocation.service_id.in_(service_ids))
        )
        await session.execute(
            delete(SocialService).where(
                SocialService.source_service_id.in_(service_ids)
            )
        )
        session.add_all(services)
        session.add_all(locations)
        session.add_all(target_groups)
        embeddings_updated = await backfill_target_group_embeddings(
            target_groups,
            batch_size=embedding_batch_size,
        )
        await session.flush()

    print(
        f"Imported {len(services)} services, {len(locations)} locations, and {len(target_groups)} target groups from {len(set(service_ids))} service IDs."
    )
    print(f"Generated embeddings for {embeddings_updated} target groups.")


async def main() -> None:
    """Run the CSV import from the command line."""

    args = build_parser().parse_args()
    service_records = load_json_exports(args.data_dir)
    address_rows = load_csv_rows(args.data_dir)
    unmatched_csv_service_ids = get_unmatched_csv_service_ids(
        service_records, address_rows
    )

    if args.dry_run:
        print(
            f"Dry run: {len(service_records)} services, {len(address_rows)} address rows from {args.data_dir}."
        )
        if unmatched_csv_service_ids:
            print(
                f"Warning: {len(unmatched_csv_service_ids)} CSV address rows have no matching JSON service record."
            )
        return

    await import_rows(
        service_records,
        address_rows,
        embedding_batch_size=args.embedding_batch_size,
    )


if __name__ == "__main__":
    asyncio.run(main())
