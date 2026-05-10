"""Laws endpoints for the API."""

from fastapi import APIRouter, Depends, File, UploadFile, status

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
from src.api.exceptions import UnsupportedMediaTypeError, DocumentProcessingError
from src.infra.db.repository import LawChunkRepository
from src.infra.embeddings.client import SentenceTransformerEmbeddingClient
from src.utils.file import extract_file_type


router = APIRouter(prefix="/laws", tags=["laws"])


@router.get("/health", status_code=status.HTTP_200_OK)
async def health_check():
    """Return a lightweight health status for the laws API slice.

    Returns:
        A small JSON payload indicating that the laws service is healthy.
    """
    return {"status": "healthy", "service": "laws"}


@router.post("/", response_model=LawUploadResponse, status_code=status.HTTP_201_CREATED)
async def upload_law(
    processor: DocumentProcessorServiceDependency,
    file: UploadFile = File(...),
):
    """Parse an uploaded law document, store chunks, and report the count.

    Args:
        processor: Document ingestion service used to parse and persist chunks.
        file: Uploaded JSON/PDF file containing the law document.

    Returns:
        Upload response containing the total number of stored chunks.
    """

    file_type = extract_file_type(file.filename)

    match file_type:
        case "json":
            try:
                file_content = await file.read()
                total_document = await processor.process_json_document(
                    file_content,
                    filename=file.filename,
                )
            except Exception as e:
                raise DocumentProcessingError(detail=str(e))

        case "pdf":
            try:
                file_content = await file.read()
                total_document = await processor.process_pdf_document(
                    file_content,
                    filename=file.filename,
                )
            except Exception as e:
                raise DocumentProcessingError(detail=str(e))

        case _:
            raise UnsupportedMediaTypeError(
                detail=f"Unsupported file type: {file_type or 'unknown'}"
            )

    return LawUploadResponse(success=True, total_chunks=total_document)


@router.post(
    "/search", response_model=LawSearchResponse, status_code=status.HTTP_200_OK
)
async def search_laws(
    payload: LawSearchRequest,
    embedding_client: SentenceTransformerEmbeddingClient = Depends(
        get_embedding_client
    ),
    repository: LawChunkRepository = Depends(get_law_chunk_repository),
):
    """Search law chunks by semantic similarity to the supplied prompt.

    Args:
        payload: Semantic search request containing the prompt and filters.
        embedding_client: Shared sentence embedding client used to encode the query text.
        repository: Repository used to query law chunks from the database.

    Returns:
        Search response containing counts and ordered semantic matches.
    """

    total_chunks = await repository.count_chunks(source_kind=payload.source_kind)
    searchable_chunks = await repository.count_chunks(
        indexed_only=True,
        source_kind=payload.source_kind,
    )

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
        source_kind=payload.source_kind,
    )

    results = [
        LawChunkSearchResult(
            document_number=chunk.document_number,
            year=chunk.year,
            source_kind=chunk.source_kind,
            fragment_id=chunk.fragment_id,
            depth=chunk.depth,
            fragment_type=chunk.fragment_type,
            page_start=chunk.page_start,
            page_end=chunk.page_end,
            chunk_index=chunk.chunk_index,
            section_title=chunk.section_title,
            source_filename=chunk.source_filename,
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
