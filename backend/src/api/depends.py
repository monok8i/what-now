"""Dependency providers for the API."""

from typing import TYPE_CHECKING, Annotated

from fastapi import Depends, Request

if TYPE_CHECKING:
    from sqlalchemy.ext.asyncio import AsyncSession
    from src.config._global import Config as ProjectConfig

from src.infra.db.session import get_async_session
from src.infra.db.repository import LawChunkRepository
from src.infra.ai.embedding.client import OpenRouterEmbeddingClient

from src.service.document import DocumentProcessorService


def get_config(request: Request):
    """Get application config from app.state."""

    return request.app.state.project_config


def get_embedding_client(
    request: Request, config: "ProjectConfig" = Depends(get_config)
) -> "OpenRouterEmbeddingClient":
    """Get OpenRouter embedding client."""

    return OpenRouterEmbeddingClient(config.ai.OPENROUTER_API_KEY)


async def get_db(request: Request, config: "ProjectConfig" = Depends(get_config)):
    """Get async database session."""
    async for session in get_async_session(request.app.state.project_config.db.ENGINE):
        yield session


def get_law_chunk_repository(
    session: "AsyncSession" = Depends(get_db),
) -> LawChunkRepository:
    """Provide an instance of the LawChunkRepository."""

    return LawChunkRepository(session=session)


def document_processor_service(
    request: Request,
    embedding_client: "OpenRouterEmbeddingClient" = Depends(get_embedding_client),
    repository: LawChunkRepository = Depends(get_law_chunk_repository),
):
    """Provide an instance of DocumentProcessorService."""

    return DocumentProcessorService(
        embedding_client=embedding_client, repository=repository
    )


DocumentProcessorServiceDependency = Annotated[
    DocumentProcessorService, Depends(document_processor_service)
]
