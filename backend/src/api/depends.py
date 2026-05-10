"""FastAPI dependency providers for application services and resources."""

from typing import TYPE_CHECKING, Annotated

from fastapi import Depends, Request

if TYPE_CHECKING:
    from sqlalchemy.ext.asyncio import AsyncSession
    from src.config._global import Config as ProjectConfig
    from src.infra.embeddings.client import SentenceTransformerEmbeddingClient

from src.infra.db.session import get_async_session
from src.infra.db.repository import LawChunkRepository

from src.service.document import DocumentProcessorService


def get_config(request: Request) -> "ProjectConfig":
    """Return the shared application configuration stored on app state.

    Args:
        request: Current FastAPI request object.

    Returns:
        The shared project configuration object stored on ``app.state``.
    """

    return request.app.state.project_config


def get_embedding_client(request: Request) -> "SentenceTransformerEmbeddingClient":
    """Return the shared embedding client stored on app state.

    Args:
        request: Current FastAPI request object.

    Returns:
        A sentence embedding client initialized during application startup.
    """

    return request.app.state.embedding_client


async def get_db(request: Request, config: "ProjectConfig" = Depends(get_config)):
    """Yield an async database session bound to the current engine.

    Args:
        request: Current FastAPI request object.
        config: Resolved project configuration.

    Yields:
        An active SQLAlchemy async session.
    """
    async for session in get_async_session(request.app.state.project_config.db.ENGINE):
        yield session


def get_law_chunk_repository(
    session: "AsyncSession" = Depends(get_db),
) -> LawChunkRepository:
    """Create the repository used for law chunk persistence and search.

    Args:
        session: Active SQLAlchemy async session.

    Returns:
        Repository instance bound to the provided session.
    """

    return LawChunkRepository(session=session)


def document_processor_service(
    embedding_client: "SentenceTransformerEmbeddingClient" = Depends(
        get_embedding_client
    ),
    repository: LawChunkRepository = Depends(get_law_chunk_repository),
):
    """Create the service responsible for document parsing and ingestion.

    Args:
        embedding_client: Shared sentence embedding client.
        repository: Repository used to persist processed chunks.

    Returns:
        Service instance that can parse and ingest uploaded documents.
    """

    return DocumentProcessorService(
        embedding_client=embedding_client, repository=repository
    )


DocumentProcessorServiceDependency = Annotated[
    DocumentProcessorService, Depends(document_processor_service)
]
