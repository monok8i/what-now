"""SQLAlchemy models for benefits and services database."""

from sqlalchemy import JSON, Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from infra.db.models.base import Base


class LawChunk(Base): ...
