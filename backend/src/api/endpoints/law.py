"""Laws endpoints for the API."""

from fastapi import APIRouter, Depends, File, UploadFile

from src.api.schemas import (
    LawChunkSearchResult,
    LawSearchRequest,
    LawSearchResponse,
    LawUploadResponse,
)
from src.api.depends import (
    DocumentProcessorServiceDependency,
    get_embedding_client,
    get_law_chunk_repository,
)
from src.infra.db.repository import LawChunkRepository
from src.infra.ai.embedding.client import OpenRouterEmbeddingClient


router = APIRouter(prefix="/laws", tags=["laws"])


@router.get("/health")
async def health_check():
    """Return a lightweight health status for the laws API slice.

    Returns:
        A small JSON payload indicating that the laws service is healthy.
    """
    return {"status": "healthy", "service": "laws"}


@router.post("/", response_model=LawUploadResponse)
async def upload_law(
    processor: DocumentProcessorServiceDependency,
    file: UploadFile = File(...),
):
    """Parse an uploaded law document, store chunks, and report the count.

    Args:
        processor: Document ingestion service used to parse and persist chunks.
        file: Uploaded JSON file containing the law document.

    Returns:
        Upload response containing the total number of stored chunks.
    """

    file_content = await file.read()

    total_document = await processor.process_document(file_content)

    return LawUploadResponse(success=True, total_chunks=total_document)


@router.post("/search", response_model=LawSearchResponse)
async def search_laws(
    payload: LawSearchRequest,
    embedding_client: OpenRouterEmbeddingClient = Depends(get_embedding_client),
    repository: LawChunkRepository = Depends(get_law_chunk_repository),
):
    """Search law chunks by semantic similarity to the supplied prompt.

    Args:
        payload: Semantic search request containing the prompt and filters.
        embedding_client: Embedding client used to encode the query text.
        repository: Repository used to query law chunks from the database.

    Returns:
        Search response containing counts and ordered semantic matches.
    """

    total_chunks = await repository.count_chunks()
    searchable_chunks = await repository.count_chunks(indexed_only=True)

    query_embedding = await embedding_client.generate_embeddings([payload.prompt])
    if not query_embedding:
        return LawSearchResponse(
            query=payload.prompt,
            total_results=0,
            total_chunks=total_chunks,
            searchable_chunks=searchable_chunks,
            results=[],
        )

    chunks = await repository.find_relevant_chunks(
        query_embedding[0],
        limit=payload.limit,
        max_distance=payload.max_distance,
    )

    results = [
        LawChunkSearchResult(
            document_number=chunk.document_number,
            year=chunk.year,
            fragment_id=chunk.fragment_id,
            depth=chunk.depth,
            fragment_type=chunk.fragment_type,
            clean_text=chunk.clean_text,
            distance=distance,
        )
        for chunk, distance in chunks
    ]

    return LawSearchResponse(
        query=payload.prompt,
        total_results=len(results),
        total_chunks=total_chunks,
        searchable_chunks=searchable_chunks,
        results=results,
    )
