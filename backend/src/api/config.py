"""API module config."""

from src.config.env import BaseEnvConfig


class Config(BaseEnvConfig):
    API_HOST: str = "0.0.0.0"
    API_PORT: int = 8000
