"""Core exceptions used across the project."""


class SearchServiceError(RuntimeError):
    """Raised when the search pipeline fails."""


class DocumentIngestionError(RuntimeError):
    """Raised when a document cannot be ingested."""


class InvalidJsonDocumentError(DocumentIngestionError):
    """Raised when uploaded JSON cannot be parsed."""


class InvalidPdfDocumentError(DocumentIngestionError):
    """Raised when uploaded PDF cannot be parsed."""


class EncryptedPdfDocumentError(DocumentIngestionError):
    """Raised when uploaded PDF is encrypted and cannot be opened."""


class PdfMetadataExtractionError(DocumentIngestionError):
    """Raised when PDF metadata cannot be derived for ingestion."""
