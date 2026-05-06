"""Laws endpoints for the API."""

from fastapi import APIRouter, File, UploadFile

from src.api.schemas import LawUploadResponse
from src.api.depends import DocumentProcessorServiceDependency


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
