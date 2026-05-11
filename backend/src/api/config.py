"""API server configuration settings."""

from src.core.config.env import BaseEnvConfig


class Config(BaseEnvConfig):
    """Host and port used by the API server.

    Attributes:
        API_HOST: Host interface the API server listens on.
        API_PORT: TCP port the API server listens on.
    """

    API_HOST: str = "0.0.0.0"
    API_PORT: int = 8000
