"""Environment settings for AI integrations."""

from src.config.env import BaseEnvConfig


class Config(BaseEnvConfig):
    """Keys and model names used by the AI clients.

    Attributes:
        OPENROUTER_API_KEY: API key for OpenRouter requests.
        OPENROUTER_AI_MODEL: Default OpenRouter chat model identifier.
        OPENAI_API_KEY: API key for OpenAI-compatible clients.
        OPENAI_EMBEDDING_MODEL: Default OpenAI embedding model identifier.
        OPENROUTER_EMBEDDING_API_URL: URL of the OpenRouter embedding endpoint.
    """

    OPENROUTER_API_KEY: str
    OPENROUTER_AI_MODEL: str
    OPENAI_API_KEY: str
    OPENAI_EMBEDDING_MODEL: str = "text-embedding-3-small"
    OPENROUTER_EMBEDDING_API_URL: str
