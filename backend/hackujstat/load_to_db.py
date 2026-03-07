#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script for loading data into PostgreSQL database using SQLAlchemy with asyncpg
"""

import asyncio
import json
import sys
from pathlib import Path
from typing import Any

from sqlalchemy import select
from sqlalchemy.ext.asyncio import (
    AsyncEngine,
    AsyncSession,
    create_async_engine,
    async_sessionmaker,
)
from sqlalchemy.dialects.postgresql import insert

# Add parent directory to path to import from src
sys.path.insert(0, str(Path(__file__).parent.parent))

from src.infra.db.models import BenefitService
from src.infra.db.base import Base


# Database configuration
POSTGRES_USER = "backend"
POSTGRES_PASSWORD = "secret"
POSTGRES_HOST = "localhost"
POSTGRES_PORT = 5432
POSTGRES_DB = "hackujstat"

DATABASE_URL = f"postgresql+asyncpg://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:{POSTGRES_PORT}/{POSTGRES_DB}"


def load_json_data(filepath: str) -> list[dict[str, Any]]:
    """Load data from JSON file."""
    with open(filepath, "r", encoding="utf-8") as f:
        return json.load(f)


async def create_tables(engine: AsyncEngine):
    """Create tables in the database."""
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)


async def load_data_to_db(data: list[dict[str, Any]], engine: AsyncEngine):
    """Load data into PostgreSQL database using SQLAlchemy."""

    # Create async session factory
    async_session = async_sessionmaker(
        engine, class_=AsyncSession, expire_on_commit=False
    )

    async with async_session() as session:
        try:
            # Insert data with upsert (ON CONFLICT DO UPDATE)
            for record in data:
                stmt = insert(BenefitService).values(
                    id=record["id"],
                    category=record["category"],
                    institution=record["institution"],
                    name=record["name"],
                    content_text=record["content_text"],
                    conditions=record[
                        "conditions"
                    ],  # SQLAlchemy handles JSONB automatically
                    source_id=record.get("source_id"),
                    next_steps=record.get("next_steps"),
                )

                # On conflict, update all fields
                stmt = stmt.on_conflict_do_update(
                    index_elements=["id"],
                    set_=dict(
                        category=stmt.excluded.category,
                        institution=stmt.excluded.institution,
                        name=stmt.excluded.name,
                        content_text=stmt.excluded.content_text,
                        conditions=stmt.excluded.conditions,
                        source_id=stmt.excluded.source_id,
                        next_steps=stmt.excluded.next_steps,
                    ),
                )

                await session.execute(stmt)

            await session.commit()
            print("✅ Data successfully loaded into PostgreSQL")
            print(f"   Loaded {len(data)} records")

            # Verify data count
            result = await session.execute(select(BenefitService))
            total_count = len(result.scalars().all())
            print(f"   Total records in database: {total_count}")

        except Exception as e:
            await session.rollback()
            print(f"❌ Error loading data: {e}")
            raise


async def main():
    """Main function for loading data."""
    import argparse

    parser = argparse.ArgumentParser(
        description="Load social benefits into PostgreSQL database"
    )
    parser.add_argument(
        "--json",
        default="output/social_benefits.json",
        help="Path to JSON file (default: output/social_benefits.json)",
    )
    parser.add_argument(
        "--create-tables",
        action="store_true",
        help="Create tables before loading data",
    )

    args = parser.parse_args()

    # Load data from JSON
    json_path = Path(__file__).parent / args.json
    if not json_path.exists():
        print(f"❌ JSON file not found: {json_path}")
        print(f"   Current directory: {Path.cwd()}")
        return

    data = load_json_data(str(json_path))
    print(f"📊 Loaded {len(data)} records from {json_path}")

    # Create database connection
    print(
        f"🔌 Connecting to PostgreSQL: {POSTGRES_HOST}:{POSTGRES_PORT}/{POSTGRES_DB}"
    )
    engine = create_async_engine(DATABASE_URL, echo=False)

    try:
        # Create tables if requested
        if args.create_tables:
            print("📋 Creating tables...")
            await create_tables(engine)

        # Load data
        await load_data_to_db(data, engine)

    except Exception as e:
        print(f"❌ Error: {e}")
        raise
    finally:
        await engine.dispose()

    print("\n✨ Completed!")


if __name__ == "__main__":
    asyncio.run(main())
