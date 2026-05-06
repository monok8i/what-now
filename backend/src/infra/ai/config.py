"""AI infrastructure module config."""

from src.config.env import BaseEnvConfig


class Config(BaseEnvConfig):
    OPENROUTER_API_KEY: str
    OPENROUTER_AI_MODEL: str
    OPENAI_API_KEY: str
