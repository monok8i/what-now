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
