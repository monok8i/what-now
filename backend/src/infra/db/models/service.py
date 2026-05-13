"""SQLAlchemy models for social services, locations, and target groups."""

from __future__ import annotations

from datetime import date
from decimal import Decimal

from sqlalchemy import Boolean, Date, ForeignKey, Index, Integer, Numeric, String, Text
from sqlalchemy.orm import Mapped, declared_attr, mapped_column, relationship
from pgvector.sqlalchemy import Vector  # type: ignore

from src.infra.db.mixins import IdIntegerMixin
from src.infra.db.models.base import Base


class SocialService(Base, IdIntegerMixin):
    """Top-level social service metadata."""

    source_service_id: Mapped[int] = mapped_column(
        Integer, nullable=False, unique=True, index=True
    )
    identifier: Mapped[str] = mapped_column(String(32), nullable=False, index=True)

    provider_id: Mapped[int] = mapped_column(Integer, nullable=False, index=True)
    provider_name: Mapped[str] = mapped_column(String(255), nullable=False)
    provider_ico: Mapped[str | None] = mapped_column(String(32), nullable=True)

    service_type_id: Mapped[int] = mapped_column(Integer, nullable=False, index=True)
    active_from: Mapped[date] = mapped_column(Date, nullable=False)
    active_to: Mapped[date | None] = mapped_column(Date, nullable=True)

    region_scope_by_address: Mapped[bool] = mapped_column(
        Boolean, nullable=False, default=False
    )

    locations: Mapped[list["ServiceLocation"]] = relationship(
        back_populates="service",
        cascade="all, delete-orphan",
        passive_deletes=True,
    )
    target_groups: Mapped[list["ServiceTargetGroup"]] = relationship(
        back_populates="service",
        cascade="all, delete-orphan",
        passive_deletes=True,
    )

    def __repr__(self) -> str:
        return (
            f"<SocialService(id={self.id}, source_service_id={self.source_service_id}, "
            f"identifier='{self.identifier}')>"
        )


class ServiceLocation(Base, IdIntegerMixin):
    """Location of a social service."""

    @declared_attr.directive
    def __tablename__(cls) -> str:
        return "service_locations"

    __table_args__ = (
        Index("ix_service_locations_service_name", "service_name"),
        Index("ix_service_locations_provider_id", "provider_id"),
        Index("ix_service_locations_municipality", "municipality"),
        Index("ix_service_locations_region", "region"),
    )

    service_id: Mapped[int] = mapped_column(
        ForeignKey("socialservice.source_service_id", ondelete="CASCADE"),
        nullable=False,
    )
    provider_id: Mapped[int] = mapped_column(Integer, nullable=False)

    street: Mapped[str | None] = mapped_column(String(255), nullable=True)
    number: Mapped[str | None] = mapped_column(String(64), nullable=True)
    district: Mapped[str | None] = mapped_column(String(255), nullable=True)
    municipality: Mapped[str | None] = mapped_column(String(255), nullable=True)
    postal_code: Mapped[str | None] = mapped_column(String(16), nullable=True)
    region: Mapped[str | None] = mapped_column(String(255), nullable=True)
    service_name: Mapped[str | None] = mapped_column(String(255), nullable=True)

    lat: Mapped[Decimal | None] = mapped_column(Numeric(10, 7), nullable=True)
    lon: Mapped[Decimal | None] = mapped_column(Numeric(10, 7), nullable=True)

    service: Mapped["SocialService"] = relationship(back_populates="locations")

    def __repr__(self) -> str:
        return (
            f"<ServiceLocation(id={self.id}, service_id={self.service_id}, "
            f"municipality='{self.municipality}', region='{self.region}')>"
        )


class ServiceTargetGroup(Base, IdIntegerMixin):
    """Context-specific target group description for a service."""

    __table_args__ = (
        Index("ix_service_target_groups_service_id", "service_id"),
        Index("ix_service_target_groups_source_group_id", "source_group_id"),
    )

    service_id: Mapped[int] = mapped_column(
        ForeignKey("socialservice.source_service_id", ondelete="CASCADE"),
        nullable=False,
    )

    source_group_id: Mapped[int] = mapped_column(Integer, nullable=False)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    embedding: Mapped[list[float] | None] = mapped_column(Vector(768), nullable=True)

    service: Mapped["SocialService"] = relationship(back_populates="target_groups")

    def __repr__(self) -> str:
        return (
            f"<ServiceTargetGroup(id={self.id}, service_id={self.service_id}, "
            f"source_group_id={self.source_group_id})>"
        )
