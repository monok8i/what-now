"""
Complete RPSS data synchronization script.

This script performs the full workflow:
1. Downloads the RPSS JSON file from MPSV data portal
2. Extracts relevant fields (addresses, contacts, phones, persons, organizations, websites)
3. Fetches coordinates for addresses via RUIAN API
4. Loads the processed data into PostgreSQL database

Can be run manually or scheduled via cron/scheduler.
"""

import asyncio
import json
import sys
import time
import traceback
from pathlib import Path
from typing import Any, Dict, List, Set, Tuple

import requests
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine

# Add backend path to sys.path
backend_dir = Path(__file__).parent.parent.parent.parent.parent
sys.path.insert(0, str(backend_dir))

from src.infra.db.config import config as db_config  # noqa: E402
from src.infra.db.models import ExtractedService  # noqa: E402

# Configuration
RPSS_URL = "https://data.mpsv.cz/od/soubory/rpss/rpss.json"
RUIAN_API_URL = (
    "https://ags.cuzk.cz/arcgis/rest/services/RUIAN/"
    "Vyhledavaci_sluzba_nad_daty_RUIAN/MapServer/1/query"
)
BATCH_SIZE = 100
WORK_DIR = Path(__file__).parent / "temp"


# ============================================================================
# Step 1: Download RPSS JSON
# ============================================================================


def download_rpss_json(output_path: Path) -> None:
    """Download the RPSS JSON file from MPSV."""
    print("=" * 60)
    print("STEP 1: Downloading RPSS JSON")
    print("=" * 60)
    print(f"Source: {RPSS_URL}")
    print(f"Target: {output_path}")

    response = requests.get(RPSS_URL, timeout=300)
    response.raise_for_status()

    output_path.parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, "wb") as f:
        f.write(response.content)

    size_mb = len(response.content) / (1024 * 1024)
    print(f"✅ Downloaded {size_mb:.2f} MB")


# ============================================================================
# Step 2: Extract and Process Data
# ============================================================================


def fetch_coordinates_batch(codes: List[int]) -> Dict[int, Tuple[float, float]]:
    """Fetch coordinates (lon, lat) for address codes via RUIAN API."""
    result: Dict[int, Tuple[float, float]] = {}
    codes_str = ",".join(str(c) for c in codes)
    params = {
        "where": f"Kod IN ({codes_str})",
        "outFields": "Kod",
        "outSR": "4326",
        "f": "json",
    }
    try:
        response = requests.get(RUIAN_API_URL, params=params, timeout=30)
        response.raise_for_status()
        data = response.json()
        for feature in data.get("features", []):
            kod = feature["attributes"]["kod"]
            geom = feature["geometry"]
            result[kod] = (geom["x"], geom["y"])
    except Exception as e:
        print(f"⚠️  Error fetching coordinates batch: {e}")
    return result


def fetch_all_coordinates(codes: Set[int]) -> Dict[int, Tuple[float, float]]:
    """Fetch coordinates for all unique address codes in batches."""
    all_coords: Dict[int, Tuple[float, float]] = {}
    code_list = list(codes)
    total = len(code_list)

    if total == 0:
        return all_coords

    print(f"Fetching coordinates for {total} addresses...")
    for i in range(0, total, BATCH_SIZE):
        batch = code_list[i : i + BATCH_SIZE]
        coords = fetch_coordinates_batch(batch)
        all_coords.update(coords)
        if i + BATCH_SIZE < total:
            print(f"  Progress: {i + len(batch)}/{total}")
            time.sleep(0.3)

    print(f"✅ Fetched coordinates for {len(all_coords)}/{total} addresses")
    return all_coords


def collect_all_address_codes(data: Any) -> Set[int]:
    """Recursively collect all unique kodAdresnihoMista from data."""
    codes: Set[int] = set()

    def _walk(obj: Any) -> None:
        if isinstance(obj, dict):
            if "kodAdresnihoMista" in obj and obj["kodAdresnihoMista"]:
                codes.add(int(obj["kodAdresnihoMista"]))
            for v in obj.values():
                _walk(v)
        elif isinstance(obj, list):
            for item in obj:
                _walk(item)

    _walk(data)
    return codes


def extract_from_nested(obj: Any, key: str, results: Set[Any]) -> None:
    """Recursively find all values by key at any nesting level."""
    if isinstance(obj, dict):
        if key in obj and obj[key] is not None:
            value = obj[key]
            if isinstance(value, dict):
                if "id" in value:
                    results.add(value["id"])
                elif "nazev" in value:
                    results.add(value["nazev"])
                else:
                    results.add(json.dumps(value, ensure_ascii=False))
            else:
                results.add(str(value))

        for v in obj.values():
            extract_from_nested(v, key, results)
    elif isinstance(obj, list):
        for item in obj:
            extract_from_nested(item, key, results)


def extract_addresses(
    data: Dict[str, Any],
    coord_cache: Dict[int, Tuple[float, float]],
) -> List[Dict[str, Any]]:
    """Extract all addresses with coordinates."""
    addresses: List[Dict[str, Any]] = []

    def find_addresses(obj: Any) -> None:
        if isinstance(obj, dict):
            if "psc" in obj or "obec" in obj:
                addr: Dict[str, Any] = {}
                if "psc" in obj and obj["psc"]:
                    addr["psc"] = obj["psc"]

                if "obec" in obj and obj["obec"]:
                    obec = obj["obec"]
                    if isinstance(obec, dict):
                        if "nazev" in obec:
                            addr["city"] = obec["nazev"]
                        elif "id" in obec:
                            addr["city_id"] = obec["id"]
                    elif isinstance(obec, str):
                        addr["city"] = obec

                if "ulice" in obj and obj["ulice"]:
                    ulice = obj["ulice"]
                    if isinstance(ulice, dict) and "nazev" in ulice:
                        addr["street"] = ulice["nazev"]
                    elif isinstance(ulice, str):
                        addr["street"] = ulice

                if "cisloDomovni" in obj and obj["cisloDomovni"]:
                    addr["house_number"] = str(obj["cisloDomovni"])

                if "cisloOrientacni" in obj and obj["cisloOrientacni"]:
                    addr["orientation_number"] = str(obj["cisloOrientacni"])

                kod = obj.get("kodAdresnihoMista")
                if kod and int(kod) in coord_cache:
                    lon, lat = coord_cache[int(kod)]
                    addr["longitude"] = lon
                    addr["latitude"] = lat
                else:
                    addr["longitude"] = None
                    addr["latitude"] = None

                if addr:
                    addresses.append(addr)

            for v in obj.values():
                find_addresses(v)
        elif isinstance(obj, list):
            for item in obj:
                find_addresses(item)

    find_addresses(data)
    return addresses


def extract_contacts(data: Dict[str, Any]) -> List[str]:
    """Extract email contacts."""
    emails: Set[str] = set()
    extract_from_nested(data, "email", emails)

    def find_emails(obj: Any) -> None:
        if isinstance(obj, dict):
            if "emaily" in obj and isinstance(obj["emaily"], list):
                for email_obj in obj["emaily"]:
                    if isinstance(email_obj, dict) and "email" in email_obj:
                        emails.add(email_obj["email"])
            for v in obj.values():
                find_emails(v)
        elif isinstance(obj, list):
            for item in obj:
                find_emails(item)

    find_emails(data)
    return list(emails)


def extract_phones(data: Dict[str, Any]) -> List[str]:
    """Extract phone numbers."""
    phones: Set[str] = set()
    extract_from_nested(data, "telefon", phones)
    extract_from_nested(data, "telefonniCislo", phones)

    def find_phones(obj: Any) -> None:
        if isinstance(obj, dict):
            if "telefony" in obj and isinstance(obj["telefony"], list):
                for phone_obj in obj["telefony"]:
                    if isinstance(phone_obj, dict):
                        if "telefonniCislo" in phone_obj:
                            phones.add(phone_obj["telefonniCislo"])
            for v in obj.values():
                find_phones(v)
        elif isinstance(obj, list):
            for item in obj:
                find_phones(item)

    find_phones(data)
    return list(phones)


def extract_persons(data: Dict[str, Any]) -> List[Dict[str, str]]:
    """Extract person names (vedouci, statutory bodies)."""
    persons: List[Dict[str, str]] = []

    def find_persons(obj: Any) -> None:
        if isinstance(obj, dict):
            if "vedouci" in obj and isinstance(obj["vedouci"], dict):
                vedouci = obj["vedouci"]
                person: Dict[str, str] = {}
                if "jmeno" in vedouci:
                    person["first_name"] = vedouci["jmeno"]
                if "prijmeni" in vedouci:
                    person["last_name"] = vedouci["prijmeni"]
                if "titulPred" in vedouci:
                    person["title_before"] = vedouci["titulPred"]
                if "titulZa" in vedouci:
                    person["title_after"] = vedouci["titulZa"]
                if person:
                    persons.append(person)

            if "statutarniOrgany" in obj and isinstance(obj["statutarniOrgany"], list):
                for organ in obj["statutarniOrgany"]:
                    if isinstance(organ, dict) and "clen" in organ:
                        clen = organ["clen"]
                        if isinstance(clen, dict):
                            person = {}
                            if "jmeno" in clen:
                                person["first_name"] = clen["jmeno"]
                            if "prijmeni" in clen:
                                person["last_name"] = clen["prijmeni"]
                            if person:
                                persons.append(person)

            for v in obj.values():
                find_persons(v)
        elif isinstance(obj, list):
            for item in obj:
                find_persons(item)

    find_persons(data)
    return persons


def extract_organizations(data: Dict[str, Any]) -> List[str]:
    """Extract organization names."""
    orgs: Set[str] = set()

    def find_orgs(obj: Any) -> None:
        if isinstance(obj, dict):
            if "nazev" in obj and isinstance(obj["nazev"], str):
                orgs.add(obj["nazev"])
            for v in obj.values():
                find_orgs(v)
        elif isinstance(obj, list):
            for item in obj:
                find_orgs(item)

    find_orgs(data)
    return list(orgs)


def extract_websites(data: Dict[str, Any]) -> List[str]:
    """Extract website URLs."""
    websites: Set[str] = set()
    extract_from_nested(data, "www", websites)

    def find_webs(obj: Any) -> None:
        if isinstance(obj, dict):
            if "weby" in obj and isinstance(obj["weby"], list):
                for web_obj in obj["weby"]:
                    if isinstance(web_obj, dict) and "www" in web_obj:
                        websites.add(web_obj["www"])
            for v in obj.values():
                find_webs(v)
        elif isinstance(obj, list):
            for item in obj:
                find_webs(item)

    find_webs(data)
    return list(websites)


def remove_duplicates(items: List[Any]) -> List[Any]:
    """Remove duplicates from list, preserving order."""
    seen: Set[str] = set()
    unique: List[Any] = []
    for item in items:
        if isinstance(item, dict):
            key = json.dumps(item, sort_keys=True, ensure_ascii=False)
        else:
            key = str(item)

        if key not in seen:
            seen.add(key)
            unique.append(item)

    return unique


def extract_record(
    record: Dict[str, Any],
    coord_cache: Dict[int, Tuple[float, float]],
) -> Dict[str, Any]:
    """Extract all necessary fields from one record."""
    extracted = {
        "addresses": remove_duplicates(extract_addresses(record, coord_cache)),
        "contacts": remove_duplicates(extract_contacts(record)),
        "phones": remove_duplicates(extract_phones(record)),
        "persons": remove_duplicates(extract_persons(record)),
        "organizations": remove_duplicates(extract_organizations(record)),
        "websites": remove_duplicates(extract_websites(record)),
    }

    if "portalId" in record:
        extracted["portal_id"] = record["portalId"]
    if "identifikator" in record:
        extracted["identifier"] = record["identifikator"]

    return extracted


def process_rpss_data(input_path: Path, output_path: Path) -> None:
    """Process RPSS JSON and extract relevant data."""
    print("\n" + "=" * 60)
    print("STEP 2: Processing RPSS Data")
    print("=" * 60)
    print(f"Input: {input_path}")
    print(f"Output: {output_path}")

    with open(input_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    # Extract records
    records: List[Any]
    if isinstance(data, dict) and "polozky" in data:
        records = data["polozky"]
    elif isinstance(data, list):
        records = data
    else:
        raise ValueError("Unknown JSON structure")

    print(f"Found {len(records)} records")

    # Collect address codes and fetch coordinates
    print("Collecting address codes...")
    all_codes = collect_all_address_codes(records)
    print(f"Unique address codes: {len(all_codes)}")
    coord_cache = fetch_all_coordinates(all_codes)

    # Process records
    print("Processing records...")
    extracted_records: List[Dict[str, Any]] = []
    for i, record in enumerate(records, 1):
        if i % 100 == 0:
            print(f"  Progress: {i}/{len(records)}")

        extracted = extract_record(record, coord_cache)
        extracted_records.append(extracted)

    # Save result
    print(f"Saving to: {output_path}")
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(
            {"total_records": len(extracted_records), "records": extracted_records},
            f,
            ensure_ascii=False,
            indent=2,
        )

    print(f"✅ Processed {len(extracted_records)} records")


# ============================================================================
# Step 3: Load Data into Database
# ============================================================================


async def load_data_to_db(json_path: Path, db_url: str) -> None:
    """Load processed data into PostgreSQL database."""
    print("\n" + "=" * 60)
    print("STEP 3: Loading Data to Database")
    print("=" * 60)
    print(f"Source: {json_path}")
    print(f"Database: {db_url}")

    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    records = data.get("records", [])
    total = len(records)
    print(f"Records to load: {total}\n")

    # Create engine and session
    engine = create_async_engine(db_url, echo=False)
    async_session = async_sessionmaker(
        engine, class_=AsyncSession, expire_on_commit=False
    )

    # Load data
    async with async_session() as session:
        added = 0
        updated = 0
        errors = 0

        for i, record in enumerate(records, 1):
            try:
                portal_id = record.get("portal_id")
                if not portal_id:
                    print(f"⚠️  Record {i}: no portal_id, skipping")
                    errors += 1
                    continue

                # Check if exists
                stmt = select(ExtractedService).where(
                    ExtractedService.portal_id == portal_id
                )
                result = await session.execute(stmt)
                existing = result.scalar_one_or_none()

                if existing:
                    # Update existing record
                    existing.identifier = record.get("identifier", "")
                    existing.addresses = record.get("addresses", [])
                    existing.contacts = record.get("contacts", [])
                    existing.phones = record.get("phones", [])
                    existing.persons = record.get("persons", [])
                    existing.organizations = record.get("organizations", [])
                    existing.websites = record.get("websites", [])
                    updated += 1
                else:
                    # Create new record
                    service = ExtractedService(
                        portal_id=portal_id,
                        identifier=record.get("identifier", ""),
                        addresses=record.get("addresses", []),
                        contacts=record.get("contacts", []),
                        phones=record.get("phones", []),
                        persons=record.get("persons", []),
                        organizations=record.get("organizations", []),
                        websites=record.get("websites", []),
                    )
                    session.add(service)
                    added += 1

                # Commit every 100 records
                if i % 100 == 0:
                    await session.commit()
                    print(
                        f"  Progress: {i}/{total} (added: {added}, updated: {updated}, errors: {errors})"
                    )

            except Exception as e:
                print(f"❌ Error processing record {i}: {e}")
                errors += 1
                await session.rollback()

        # Final commit
        await session.commit()

    print("\n✅ Database loading completed!")
    print(f"   New records added: {added}")
    print(f"   Updated: {updated}")
    print(f"   Errors: {errors}")
    print(f"   Total processed: {total}")

    await engine.dispose()


# ============================================================================
# Main Workflow
# ============================================================================


async def run_full_sync(cleanup: bool = True) -> None:
    """Run the complete RPSS synchronization workflow."""
    print("🔄 RPSS Data Synchronization")
    print("=" * 60)

    # Create work directory
    WORK_DIR.mkdir(parents=True, exist_ok=True)

    raw_json_path = WORK_DIR / "rpss_raw.json"
    processed_json_path = WORK_DIR / "rpss_processed.json"

    try:
        # Step 1: Download
        download_rpss_json(raw_json_path)

        # Step 2: Process
        process_rpss_data(raw_json_path, processed_json_path)

        # Step 3: Load to DB
        db_url = db_config.POSTGRES_DATABASE_URI
        if not db_url:
            raise ValueError("Database URL not configured. Check your .env file.")
        await load_data_to_db(processed_json_path, db_url)

        print("\n" + "=" * 60)
        print("✅ RPSS Synchronization Completed Successfully!")
        print("=" * 60)

        # Cleanup temporary files
        if cleanup:
            print("\nCleaning up temporary files...")
            if raw_json_path.exists():
                raw_json_path.unlink()
            if processed_json_path.exists():
                processed_json_path.unlink()
            print("✅ Cleanup completed")

    except Exception as e:
        print("\n" + "=" * 60)
        print(f"❌ Error during synchronization: {e}")
        print("=" * 60)
        traceback.print_exc()
        sys.exit(1)


def main():
    """Main entry point."""
    import argparse

    parser = argparse.ArgumentParser(
        description="RPSS Data Synchronization - Download, Process, and Load"
    )
    parser.add_argument(
        "--no-cleanup",
        action="store_true",
        help="Keep temporary files after processing",
    )

    args = parser.parse_args()

    asyncio.run(run_full_sync(cleanup=not args.no_cleanup))


if __name__ == "__main__":
    main()
