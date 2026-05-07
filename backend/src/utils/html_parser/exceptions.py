"""Exceptions raised by the HTML parsing helpers."""


class HTMLParsingError(Exception):
    """Base exception for HTML parsing failures.

    This exception groups all parser-related errors so callers can handle HTML
    extraction issues in one place.
    """


class InvalidHTMLContentError(HTMLParsingError):
    """Raised when the provided HTML content is invalid or cannot be parsed.

    The parser raises this error when the HTML input cannot be decoded or
    traversed into plain text safely.
    """
