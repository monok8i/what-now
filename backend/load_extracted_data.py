#!/usr/bin/env python3
"""
Script for loading data from output_fixed.json into the database.
"""

import asyncio
import json
import sys
from pathlib import Path

from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker
from sqlalchemy import select

# Add backend path to sys.path
backend_dir = Path(__file__).parent
sys.path.insert(0, str(backend_dir))

from src.infra.db.config import config as db_config  # noqa: E402
from src.infra.db.models import ExtractedService  # noqa: E402


async def load_data_from_json(json_file_path: str, db_url: str) -> None:
    """
    Load data from JSON file into the database.

    Args:
        json_file_path: Path to JSON file with data
        db_url: Database connection URL
    """
    print(f"Loading data from: {json_file_path}")

    # Read JSON file
    with open(json_file_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    records = data.get("records", [])
    total = len(records)
    print(f"Found {total} records\n")

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

                # Check if it already exists
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
                        f"Processed: {i}/{total} (added: {added}, updated: {updated}, errors: {errors})"
                    )

            except Exception as e:
                print(
                    f"❌ Error processing record {i} (portal_id={record.get('portal_id')}): {e}"
                )
                errors += 1
                await session.rollback()

        # Final commit
        await session.commit()

    print("\n✅ Loading completed!")
    print(f"   New records added: {added}")
    print(f"   Updated: {updated}")
    print(f"   Errors: {errors}")
    print(f"   Total processed: {total}")

    await engine.dispose()


async def example_queries(db_url: str) -> None:
    """
    Example queries to loaded data.
    """
    engine = create_async_engine(db_url, echo=False)
    async_session = async_sessionmaker(engine, class_=AsyncSession)

    async with async_session() as session:
        # Total count
        stmt = select(ExtractedService)
        result = await session.execute(stmt)
        services = result.scalars().all()

        print("\n=== Example queries ===")
        print(f"Total records in DB: {len(services)}\n")

        # First 3 records
        print("First 3 records:")
        for service in services[:3]:
            print(f"  - ID: {service.portal_id}, Identifier: {service.identifier}")
            print(
                f"    Addresses: {len(service.addresses)}, Contacts: {len(service.contacts)}"
            )
            print(
                f"    Phones: {len(service.phones)}, Organizations: {len(service.organizations)}"
            )

        # Records with email contacts
        stmt = select(ExtractedService).where(ExtractedService.contacts != []).limit(5)
        result = await session.execute(stmt)
        services_with_contacts = result.scalars().all()

        print("\nRecords with email contacts (first 5):")
        for service in services_with_contacts:
            print(
                f"  - ID: {service.portal_id}, Email: {', '.join(service.contacts[:2])}"
            )

    await engine.dispose()


def main():
    """
    Main function.
    """
    # Default parameters
    json_file = str(Path(__file__).parent / "output_fixed.json")
    db_url = db_config.POSTGRES_DATABASE_URI

    if len(sys.argv) > 1:
        json_file = sys.argv[1]
    if len(sys.argv) > 2:
        db_url = sys.argv[2]

    print("=" * 60)
    print("Loading RPSS data into database")
    print("=" * 60)
    print(f"JSON file: {json_file}")
    print(f"Database: {db_url}")
    print("=" * 60 + "\n")

    try:
        # Load data
        asyncio.run(load_data_from_json(json_file, db_url))  # type: ignore

        # Show examples
        asyncio.run(example_queries(db_url))  # type: ignore

    except FileNotFoundError:
        print(f"❌ Error: file {json_file} not found")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback

        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
