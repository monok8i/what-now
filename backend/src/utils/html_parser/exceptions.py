"""HTML parsing exceptions."""


class HTMLParsingError(Exception):
    """Base exception for HTML parsing errors."""


class InvalidHTMLContentError(HTMLParsingError):
    """Raised when the provided HTML content is invalid or cannot be parsed."""
