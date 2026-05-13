"""API related exceptions."""

from fastapi import HTTPException, status


class NotImplementedError(HTTPException):
    def __init__(self, detail: str = "Feature is not implemented yet.") -> None:
        super().__init__(
            status_code=status.HTTP_501_NOT_IMPLEMENTED,
            detail=detail,
        )


class DocumentProcessingError(HTTPException):
    def __init__(self, detail: str = "Failed to process document.") -> None:
        super().__init__(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=detail,
        )


class SearchError(HTTPException):
    def __init__(self, detail: str = "Failed to search documents.") -> None:
        super().__init__(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=detail,
        )


class MapServiceError(HTTPException):
    def __init__(self, detail: str = "Failed to load services.") -> None:
        super().__init__(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=detail,
        )


class MapServiceNotFoundError(HTTPException):
    def __init__(self, detail: str = "Service not found.") -> None:
        super().__init__(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=detail,
        )


class UnsupportedMediaTypeError(HTTPException):
    def __init__(self, detail: str = "Unsupported media type.") -> None:
        super().__init__(
            status_code=status.HTTP_415_UNSUPPORTED_MEDIA_TYPE,
            detail=detail,
        )
