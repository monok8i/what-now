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
    """Health check endpoint."""
    return {"status": "healthy", "service": "laws"}


@router.post("/", response_model=LawUploadResponse)
async def upload_law(
    processor: DocumentProcessorServiceDependency,
    file: UploadFile = File(...),
):
    """Upload a file and return its filename."""

    file_content = await file.read()

    total_document = await processor.process_document(file_content)

    return LawUploadResponse(success=True, total_chunks=total_document)


@router.post("/search", response_model=LawSearchResponse)
async def search_laws(
    payload: LawSearchRequest,
    embedding_client: OpenRouterEmbeddingClient = Depends(get_embedding_client),
    repository: LawChunkRepository = Depends(get_law_chunk_repository),
):
    """Search for law chunks semantically similar to the supplied prompt."""

    query_embedding = await embedding_client.generate_embeddings([payload.prompt])
    if not query_embedding:
        return LawSearchResponse(query=payload.prompt, total_results=0, results=[])

    chunks = await repository.find_relevant_chunks(
        query_embedding[0],
        limit=payload.limit,
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
        results=results,
    )
