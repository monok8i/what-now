"""Database infrastructure module."""

from src.infra.db.base import Base
from src.infra.db.models import BenefitService

__all__ = ["Base", "BenefitService"]
