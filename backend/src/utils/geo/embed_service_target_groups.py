#!/usr/bin/env python3
"""Backfill embeddings for service target-group descriptions."""

from __future__ import annotations

import argparse
import asyncio
from pathlib import Path
import sys

if __package__ in {None, ""}:
    sys.path.insert(0, str(Path(__file__).resolve().parents[3]))

from sqlalchemy import select

from src.core.config._global import config
from src.infra.db.models import ServiceTargetGroup
from src.infra.db.session import get_async_session
from src.infra.embeddings.client import SentenceTransformerEmbeddingClient


def build_parser() -> argparse.ArgumentParser:
    """Build the CLI parser for the embedding backfill script."""

    parser = argparse.ArgumentParser(
        description="Generate and store embeddings for ServiceTargetGroup.description."
    )
    parser.add_argument(
        "--batch-size",
        type=int,
        default=config.embeddings.EMBEDDING_BATCH_SIZE,
        help="How many descriptions to embed in one batch.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Fetch descriptions and generate embeddings without writing them.",
    )
    return parser


async def backfill_embeddings(batch_size: int, dry_run: bool) -> None:
    """Load descriptions, generate embeddings, and persist them back."""

    engine = config.db.ENGINE
    if engine is None:
        raise RuntimeError("Database engine is not configured.")

    embedding_client = SentenceTransformerEmbeddingClient(
        model_name=config.embeddings.EMBEDDING_MODEL_NAME,
        device=config.embeddings.EMBEDDING_DEVICE,
        normalize_embeddings=config.embeddings.EMBEDDING_NORMALIZE,
        batch_size=batch_size,
    )

    async for session in get_async_session(engine):
        result = await session.execute(
            select(ServiceTargetGroup)
            .where(ServiceTargetGroup.description.is_not(None))
            .order_by(ServiceTargetGroup.id)
        )
        target_groups = list(result.scalars().all())

        if not target_groups:
            print("No ServiceTargetGroup rows with descriptions were found.")
            return

        groups_with_description = [
            group for group in target_groups if group.description
        ]

        updated = 0
        for index in range(0, len(groups_with_description), batch_size):
            batch_groups = groups_with_description[index : index + batch_size]
            batch_texts = [
                group.description.strip() for group in batch_groups if group.description
            ]
            if not batch_texts:
                continue

            embeddings = await embedding_client.generate_embeddings(batch_texts)
            if len(embeddings) != len(batch_groups):
                raise RuntimeError(
                    "Embedding count mismatch: "
                    f"got {len(embeddings)} vectors for {len(batch_groups)} target groups."
                )

            for group, embedding in zip(batch_groups, embeddings):
                group.embedding = embedding
                updated += 1

        if dry_run:
            await session.rollback()
            print(
                f"Dry run: would update {updated} target groups out of {len(target_groups)} rows."
            )
            return

        await session.flush()
        print(f"Updated embeddings for {updated} target groups.")


async def main() -> None:
    """Run the embedding backfill from the command line."""

    args = build_parser().parse_args()
    await backfill_embeddings(batch_size=args.batch_size, dry_run=args.dry_run)


if __name__ == "__main__":
    asyncio.run(main())
