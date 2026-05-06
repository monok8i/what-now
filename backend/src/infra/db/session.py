"""Database session management."""

from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker

from .config import config

engine = create_async_engine(config.POSTGRES_DATABASE_URI, echo=True)  # type: ignore

AsyncSessionLocal = async_sessionmaker(
    engine, class_=AsyncSession, expire_on_commit=False
)


async def get_db():
    """Get async database session."""
    async with AsyncSessionLocal() as session:
        try:
            yield session
        finally:
            await session.close()
