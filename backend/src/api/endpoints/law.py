"""Laws endpoints for the API."""

from fastapi import APIRouter, File, UploadFile


router = APIRouter(prefix="/laws", tags=["laws"])


@router.get("/health")
async def health_check():
    """Health check endpoint."""
    return {"status": "healthy", "service": "laws"}


@router.post("/")
async def upload_law(file: UploadFile = File(...)):
    """Upload a file and return its filename."""
    return {"filename": file.filename}
