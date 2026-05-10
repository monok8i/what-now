"""AI-related exception types."""


class AIError(Exception):
    """Base exception for AI integration failures.

    This exception groups all errors raised by the AI integration layer so
    callers can catch a single root type when desired.
    """


class EmbeddingError(AIError):
    """Error raised when embedding generation fails.

    This error is raised when an embedding model cannot be loaded or when
    text cannot be converted into embedding vectors.
    """
