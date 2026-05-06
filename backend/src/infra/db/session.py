"""Database session management."""

from sqlalchemy.ext.asyncio import (
    AsyncEngine,
    AsyncSession,
    async_sessionmaker,
)


async def get_async_session(database_engine: AsyncEngine):
    """Get async database session."""

    _local_session = async_sessionmaker(
        database_engine, class_=AsyncSession, expire_on_commit=False
    )

    async with _local_session() as session:
        try:
            yield session
            await session.commit()
        except Exception as e:
            await session.rollback()
            raise e
        finally:
            await session.close()
