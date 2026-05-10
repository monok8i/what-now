"""API related exceptions."""

from fastapi import HTTPException, status


class NotImplementedError(HTTPException):
    def __init__(self, detail: str = "Feature is not implemented yet.") -> None:
        super().__init__(
            status_code=status.HTTP_501_NOT_IMPLEMENTED,
            detail=detail,
        )


class UnsupportedMediaTypeError(HTTPException):
    def __init__(self, detail: str = "Unsupported media type.") -> None:
        super().__init__(
            status_code=status.HTTP_415_UNSUPPORTED_MEDIA_TYPE,
            detail=detail,
        )
