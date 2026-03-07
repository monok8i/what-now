"""Map data service."""

from collections.abc import Sequence

from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from src.infra.db.models import ExtractedService


class MapDataExtractedService:
    async def get_map_data(
        self, db_session: AsyncSession
    ) -> Sequence[ExtractedService]:
        """Fetch data for map visualization."""

        result = await db_session.execute(select(ExtractedService))
        return result.scalars().all()
