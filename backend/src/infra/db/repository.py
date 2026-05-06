from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from src.infra.db.models import LawChunk
from src.infra.db.types import LawChunkType


class LawChunkRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def save_chunks(self, chunks: list[LawChunkType]) -> int:
        """Save law chunks to the database."""

        db_chunks = [LawChunk(**chunk) for chunk in chunks]
        self.session.add_all(db_chunks)

        await self.session.flush()

        # Expunge objects to free memory (important for large batches)
        for chunk in db_chunks:
            self.session.expunge(chunk)

        return len(db_chunks)

    async def find_relevant_chunks(
        self,
        query_embedding: list[float],
        *,
        limit: int | None = None,
    ) -> list[tuple[LawChunk, float]]:
        """Find chunks ordered by cosine distance to the query embedding."""

        distance = LawChunk.embedding.cosine_distance(query_embedding).label("distance")

        stmt = (
            select(LawChunk, distance)
            .where(LawChunk.embedding.is_not(None))
            .order_by(distance)
        )

        if limit is not None:
            stmt = stmt.limit(limit)

        result = await self.session.execute(stmt)
        return [(chunk, distance_value) for chunk, distance_value in result.all()]
