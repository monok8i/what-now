"""Database session management helpers.

This module provides the async session dependency used by the API layer.
"""

from sqlalchemy.ext.asyncio import (
    AsyncEngine,
    AsyncSession,
    async_sessionmaker,
)


async def get_async_session(database_engine: AsyncEngine):
    """Yield a transactional async SQLAlchemy session.

    Args:
        database_engine: Async SQLAlchemy engine used to create the session.

    Yields:
        Active async SQLAlchemy session.

    Raises:
        Exception: Re-raises any error after rolling back the transaction.

    The session is committed after successful work and rolled back on any
    exception. The session is also explicitly closed when the dependency exits.
    """

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
