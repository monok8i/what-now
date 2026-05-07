"""Database repository for law chunk storage and semantic search."""

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession
from src.infra.db.models import LawChunk
from src.infra.db.types import LawChunkType


class LawChunkRepository:
    """Encapsulate persistence and vector-search queries for law chunks.

    Attributes:
        session: Active async SQLAlchemy session used for all database work.
    """

    def __init__(self, session: AsyncSession):
        """Store the active async database session used by the repository.

        Args:
            session: Async SQLAlchemy session bound to the current request.
        """

        self.session = session

    async def save_chunks(self, chunks: list[LawChunkType]) -> int:
        """Insert a batch of law chunks and flush them to the database.

        Args:
            chunks: Normalized law chunk payloads ready for persistence.

        Returns:
            Number of inserted chunks.
        """

        db_chunks = [LawChunk(**chunk) for chunk in chunks]
        self.session.add_all(db_chunks)

        await self.session.flush()

        for chunk in db_chunks:
            self.session.expunge(chunk)

        return len(db_chunks)

    async def count_chunks(self, *, indexed_only: bool = False) -> int:
        """Count chunks in the database.

        Args:
            indexed_only: When ``True``, count only rows that already have an
                embedding stored.

        Returns:
            Number of rows matching the chosen filter.
        """

        stmt = select(func.count()).select_from(LawChunk)

        if indexed_only:
            stmt = stmt.where(LawChunk.embedding.is_not(None))

        result = await self.session.execute(stmt)
        return int(result.scalar_one())

    async def find_relevant_chunks(
        self,
        query_embedding: list[float],
        *,
        limit: int | None = None,
        max_distance: float | None = None,
    ) -> list[tuple[LawChunk, float]]:
        """Find chunks ordered by cosine distance to the query embedding.

        Args:
            query_embedding: Embedding vector generated from the user prompt.
            limit: Optional maximum number of rows to return.
            max_distance: Optional inclusive distance cutoff for accepted rows.

        Returns:
            Tuples of ``(LawChunk, distance)`` ordered from nearest to farthest.

        Results are filtered to rows with embeddings, ordered from nearest to
        farthest, and optionally limited by row count and maximum distance.
        """

        distance = LawChunk.embedding.cosine_distance(query_embedding).label("distance")

        stmt = (
            select(LawChunk, distance)
            .where(LawChunk.embedding.is_not(None))
            .order_by(distance)
        )

        if max_distance is not None:
            stmt = stmt.where(distance <= max_distance)

        if limit is not None:
            stmt = stmt.limit(limit)

        result = await self.session.execute(stmt)
        return [(chunk, distance_value) for chunk, distance_value in result.all()]
