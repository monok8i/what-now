"""This file contains mixins for database models."""

from sqlalchemy.orm import Mapped, declarative_mixin, mapped_column


@declarative_mixin
class IdIntegerMixin:
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
