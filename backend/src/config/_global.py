"""Global configuration for the application."""

from functools import cached_property

from src.infra.ai.config import Config as AIConfig
from src.infra.db.config import Config as DBConfig
from src.api.config import Config as APIConfig


class Config:
    """Global configuration class for the application."""

    @cached_property
    def api(self) -> APIConfig:
        """API-related configuration."""
        return APIConfig()  # type: ignore

    @cached_property
    def ai(self) -> AIConfig:
        """AI-related configuration."""
        return AIConfig()  # type: ignore

    @cached_property
    def db(self) -> DBConfig:
        """Database-related configuration."""
        return DBConfig()  # type: ignore


config = Config()
