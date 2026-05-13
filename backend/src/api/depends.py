"""FastAPI dependency providers for application services and resources."""

from typing import TYPE_CHECKING, Annotated

from fastapi import Depends
from starlette.requests import HTTPConnection

if TYPE_CHECKING:
    from sqlalchemy.ext.asyncio import AsyncSession
    from src.core.config._global import Config as ProjectConfig
    from src.infra.embeddings.client import SentenceTransformerEmbeddingClient

from src.infra.ai.client import GemmaChatClient
from src.infra.db.repository.lawchunk import LawChunkRepository
from src.infra.db.repository.service import ServiceRepository
from src.infra.db.session import get_async_session

from src.service.document import DocumentProcessorService
from src.service.chat import ChatService
from src.service.first_answer import FirstAnswerService
from src.service.search import SearchService


def get_config(connection: HTTPConnection) -> "ProjectConfig":
    """Return the shared application configuration stored on app state.

    Args:
        connection: Current HTTP or WebSocket connection object.

    Returns:
        The shared project configuration object stored on ``app.state``.
    """

    return connection.app.state.project_config


def get_embedding_client(
    connection: HTTPConnection,
) -> "SentenceTransformerEmbeddingClient":
    """Return the shared embedding client stored on app state.

    Args:
        connection: Current HTTP or WebSocket connection object.

    Returns:
        A sentence embedding client initialized during application startup.
    """

    return connection.app.state.embedding_client


def get_ai_client(
    config: "ProjectConfig" = Depends(get_config),
) -> GemmaChatClient:
    """
    Return a configured instance of the AI chat client.

    Args:
    Returns:
        The shared AI chat client stored on application state.
    """

    return GemmaChatClient(
        model_name=config.ai.AI_MODEL_NAME, server_url=config.ai.AI_SERVER_URL
    )


async def get_db(config: "ProjectConfig" = Depends(get_config)):
    """Yield an async database session bound to the current engine.

    Args:
        config: Resolved project configuration.

    Yields:
        An active SQLAlchemy async session.
    """
    engine = config.db.ENGINE
    if engine is None:
        raise RuntimeError("Database engine is not configured")

    async for session in get_async_session(engine):
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


def get_service_repository(
    session: "AsyncSession" = Depends(get_db),
) -> ServiceRepository:
    """Create the repository used for browsing social services."""

    return ServiceRepository(session=session)


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


def search_service(
    embedding_client: "SentenceTransformerEmbeddingClient" = Depends(
        get_embedding_client
    ),
    repository: LawChunkRepository = Depends(get_law_chunk_repository),
):
    """Create the search service used by law search endpoints."""

    return SearchService(embedding_client=embedding_client, repository=repository)


def first_answer_service(
    ai_client: GemmaChatClient = Depends(get_ai_client),
    search_service: SearchService = Depends(search_service),
    embedding_client: "SentenceTransformerEmbeddingClient" = Depends(
        get_embedding_client
    ),
    service_repository: ServiceRepository = Depends(get_service_repository),
):
    """Create the service that turns a form into the first assistant sentence."""

    return FirstAnswerService(
        ai_client=ai_client,
        search_service=search_service,
        embedding_client=embedding_client,
        service_repository=service_repository,
    )


def chat_service(
    ai_client: GemmaChatClient = Depends(get_ai_client),
    search_service: SearchService = Depends(search_service),
):
    """Create the service used by the websocket chat endpoint."""

    from src.service.chat import ChatService

    return ChatService(ai_client=ai_client, search_service=search_service)


DocumentProcessorServiceDependency = Annotated[
    DocumentProcessorService, Depends(document_processor_service)
]


AIClientDependency = Annotated["GemmaChatClient", Depends(get_ai_client)]


FirstAnswerServiceDependency = Annotated[
    FirstAnswerService, Depends(first_answer_service)
]

ChatServiceDependency = Annotated[ChatService, Depends(chat_service)]

EmbeddingClientDependency = Annotated[
    "SentenceTransformerEmbeddingClient", Depends(get_embedding_client)
]


SearchServiceDependency = Annotated[SearchService, Depends(search_service)]


ServiceRepositoryDependency = Annotated[
    ServiceRepository, Depends(get_service_repository)
]
