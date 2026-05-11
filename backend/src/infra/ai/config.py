"""Environment settings for the AI chat client."""

from src.config.env import BaseEnvConfig


class Config(BaseEnvConfig):
    """Runtime settings for the chat model client.

    Attributes:
        AI_MODEL_NAME: Model identifier sent to the chat API.
        AI_SERVER_URL: HTTP endpoint of the chat server.
        AI_REQUEST_TIMEOUT: Timeout in seconds for one request.
    """

    AI_MODEL_NAME: str
    AI_SERVER_URL: str = "http://127.0.0.1:11434/api/chat"
    AI_REQUEST_TIMEOUT: float = 60.0
