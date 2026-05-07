from src.core.settings import BaseEnvConfig


class CeleryConfig(BaseEnvConfig):
    CELERY_BROKER_URL: str
