"""Laws endpoints for the API."""

from typing import Annotated
from fastapi import APIRouter, Depends, File, UploadFile, status, Body

from src.api.schemas import (
    FirstAnswerResponse,
    LawChunkSearchResult,
    LawSearchRequest,
    LawSearchResponse,
    LawUploadResponse,
    UserFormRequest,
)
from src.api.depends import (
    DocumentProcessorServiceDependency,
    FirstAnswerServiceDependency,
    SearchServiceDependency,
)
from src.api.exceptions import (
    DocumentProcessingError,
    SearchError,
    UnsupportedMediaTypeError,
)
from src.utils.file import extract_file_type


router = APIRouter(prefix="/laws", tags=["laws"])


@router.get("/health", tags=["healthcheck"], status_code=status.HTTP_200_OK)
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


@router.get("/", response_model=LawSearchResponse, status_code=status.HTTP_200_OK)
async def search_laws(
    search_service: SearchServiceDependency,
    payload: LawSearchRequest = Depends(),
):
    """Search law chunks by semantic similarity to the supplied prompt.

    Args:
        payload: Semantic search request containing the prompt and filters.
        embedding_client: Shared sentence embedding client used to encode the query text.
        repository: Repository used to query law chunks from the database.

    Returns:
        Search response containing counts and ordered semantic matches.
    """

    try:
        result_set = await search_service.search(
            prompt=payload.prompt,
            limit=payload.limit,
            max_distance=payload.max_distance,
            source_kind=payload.source_kind,
        )
    except Exception as e:
        raise SearchError(detail=str(e)) from e

    return LawSearchResponse(
        query=result_set.query,
        total_results=len(result_set.results),
        total_chunks=result_set.total_chunks,
        searchable_chunks=result_set.searchable_chunks,
        results=[
            LawChunkSearchResult(
                **{
                    k: getattr(chunk, k)
                    for k in LawChunkSearchResult.model_fields
                    if k != "distance"
                },
                distance=chunk.distance,
            )
            for chunk in result_set.results
        ],
    )


@router.post(
    "/answer", response_model=FirstAnswerResponse, status_code=status.HTTP_200_OK
)
async def first_answer(
    user_form: Annotated[UserFormRequest, Body(...)],
    answer_service: FirstAnswerServiceDependency,
):
    """Generate the first AI answer from the submitted questionnaire.

    Args:
        user_form: Structured caregiver questionnaire used to build the query
            prompt for retrieval and answer generation.

    Returns:
        A single generated sentence based on the submitted form and retrieved sources.
    """

    try:
        result = await answer_service.first_answer(user_form)
    except Exception as e:
        raise SearchError(detail=str(e)) from e

    return FirstAnswerResponse(total_chunks=result.total_chunks, message=result.message)
