"""Database related exceptions."""


class AIError(Exception):
    """Base AI error."""


class EmbeddingError(AIError):
    """Error related to embedding generation."""
