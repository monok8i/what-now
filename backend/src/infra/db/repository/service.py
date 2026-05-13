"""Database repository for browsing social services and locations."""

from __future__ import annotations

from datetime import date
from typing import Any

from sqlalchemy import Float, and_, func, literal, or_, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import joinedload
from sqlalchemy.sql import Select, Subquery

from src.infra.db.models import ServiceLocation, ServiceTargetGroup, SocialService
from src.infra.db.types import (
    ServiceListRecord,
    ServiceLocationSummary,
    ServiceListResult,
)


EARTH_RADIUS_KM = 6371.0088


class ServiceRepository:
    """Encapsulate browsing queries for social services and locations."""

    def __init__(self, session: AsyncSession):
        self.session = session

    def _apply_service_filters(
        self,
        stmt: Select[Any],
        *,
        source_service_id: int | None = None,
        provider_id: int | None = None,
        service_type_id: int | None = None,
        identifier: str | None = None,
        q: str | None = None,
        active_only: bool = True,
    ) -> Select[Any]:
        filters: list[Any] = []

        if source_service_id is not None:
            filters.append(SocialService.source_service_id == source_service_id)
        if provider_id is not None:
            filters.append(SocialService.provider_id == provider_id)
        if service_type_id is not None:
            filters.append(SocialService.service_type_id == service_type_id)
        if identifier:
            filters.append(SocialService.identifier.ilike(f"%{identifier.strip()}%"))

        if q:
            pattern = f"%{q.strip()}%"
            filters.append(
                or_(
                    SocialService.identifier.ilike(pattern),
                    SocialService.provider_name.ilike(pattern),
                )
            )

        if active_only:
            today = date.today()
            filters.append(SocialService.active_from <= today)
            filters.append(
                or_(
                    SocialService.active_to.is_(None),
                    SocialService.active_to >= today,
                )
            )

        if filters:
            stmt = stmt.where(*filters)

        return stmt

    def _build_distance_expression(self, lat: float, lon: float):
        latitude = ServiceLocation.lat
        longitude = ServiceLocation.lon

        return EARTH_RADIUS_KM * func.acos(
            func.least(
                1.0,
                func.greatest(
                    -1.0,
                    func.sin(func.radians(lat)) * func.sin(func.radians(latitude))
                    + func.cos(func.radians(lat))
                    * func.cos(func.radians(latitude))
                    * func.cos(func.radians(longitude) - func.radians(lon)),
                ),
            )
        )

    def _build_location_rank_subquery(
        self,
        *,
        lat: float | None = None,
        lon: float | None = None,
        radius_km: float | None = None,
        municipality: str | None = None,
        region: str | None = None,
    ) -> Subquery:
        columns: list[Any] = [
            ServiceLocation.id.label("location_id"),
            ServiceLocation.service_id.label("service_id"),
            ServiceLocation.provider_id.label("provider_id"),
            ServiceLocation.street.label("street"),
            ServiceLocation.number.label("number"),
            ServiceLocation.district.label("district"),
            ServiceLocation.municipality.label("municipality"),
            ServiceLocation.postal_code.label("postal_code"),
            ServiceLocation.region.label("region"),
            ServiceLocation.service_name.label("service_name"),
            ServiceLocation.lat.label("lat"),
            ServiceLocation.lon.label("lon"),
        ]

        location_filters: list[Any] = []
        if municipality:
            location_filters.append(
                ServiceLocation.municipality.ilike(f"%{municipality.strip()}%")
            )
        if region:
            location_filters.append(ServiceLocation.region.ilike(f"%{region.strip()}%"))

        if lat is not None and lon is not None:
            effective_radius = radius_km if radius_km is not None else 10.0
            distance_expr = self._build_distance_expression(lat, lon)
            columns.append(distance_expr.label("distance_km"))
            order_by = (distance_expr, ServiceLocation.id)
        else:
            effective_radius = None
            distance_expr = None
            columns.append(literal(None, Float).label("distance_km"))
            order_by = (ServiceLocation.id,)

        columns.append(
            func.row_number()
            .over(partition_by=ServiceLocation.service_id, order_by=order_by)
            .label("row_number")
        )

        stmt = select(*columns).select_from(ServiceLocation)

        if location_filters:
            stmt = stmt.where(*location_filters)

        if lat is not None and lon is not None:
            stmt = stmt.where(
                ServiceLocation.lat.is_not(None), ServiceLocation.lon.is_not(None)
            )
            if effective_radius is not None:
                assert distance_expr is not None
                stmt = stmt.where(distance_expr <= effective_radius)

        return stmt.subquery()

    def _base_service_list_stmt(
        self,
        *,
        source_service_id: int | None = None,
        provider_id: int | None = None,
        service_type_id: int | None = None,
        identifier: str | None = None,
        q: str | None = None,
        municipality: str | None = None,
        region: str | None = None,
        active_only: bool = True,
        lat: float | None = None,
        lon: float | None = None,
        radius_km: float | None = None,
    ) -> Select[Any]:
        location_subquery = self._build_location_rank_subquery(
            lat=lat,
            lon=lon,
            radius_km=radius_km,
            municipality=municipality,
            region=region,
        )

        locations_count = (
            select(func.count(ServiceLocation.id))
            .where(ServiceLocation.service_id == SocialService.source_service_id)
            .correlate(SocialService)
            .scalar_subquery()
            .label("locations_count")
        )
        target_groups_count = (
            select(func.count(ServiceTargetGroup.id))
            .where(ServiceTargetGroup.service_id == SocialService.source_service_id)
            .correlate(SocialService)
            .scalar_subquery()
            .label("target_groups_count")
        )

        stmt: Select[Any] = select(
            SocialService,
            location_subquery.c.location_id,
            location_subquery.c.provider_id,
            location_subquery.c.street,
            location_subquery.c.number,
            location_subquery.c.district,
            location_subquery.c.municipality,
            location_subquery.c.postal_code,
            location_subquery.c.region,
            location_subquery.c.service_name,
            location_subquery.c.lat,
            location_subquery.c.lon,
            location_subquery.c.distance_km,
            locations_count,
            target_groups_count,
        ).select_from(SocialService)

        stmt = self._apply_service_filters(
            stmt,
            source_service_id=source_service_id,
            provider_id=provider_id,
            service_type_id=service_type_id,
            identifier=identifier,
            q=q,
            active_only=active_only,
        )

        join_condition = and_(
            location_subquery.c.service_id == SocialService.source_service_id,
            location_subquery.c.row_number == 1,
        )

        if lat is not None and lon is not None or municipality or region:
            stmt = stmt.join(location_subquery, join_condition)
        else:
            stmt = stmt.outerjoin(location_subquery, join_condition)

        order_columns: list[Any] = [
            SocialService.provider_name.asc(),
            SocialService.source_service_id.asc(),
        ]
        if lat is not None and lon is not None:
            order_columns.insert(0, location_subquery.c.distance_km.asc())

        return stmt.order_by(*order_columns)

    async def list_services(
        self,
        *,
        limit: int,
        offset: int,
        source_service_id: int | None = None,
        provider_id: int | None = None,
        service_type_id: int | None = None,
        identifier: str | None = None,
        q: str | None = None,
        municipality: str | None = None,
        region: str | None = None,
        active_only: bool = True,
        lat: float | None = None,
        lon: float | None = None,
        radius_km: float | None = None,
    ) -> ServiceListResult:
        base_stmt: Select[Any] = self._base_service_list_stmt(
            source_service_id=source_service_id,
            provider_id=provider_id,
            service_type_id=service_type_id,
            identifier=identifier,
            q=q,
            municipality=municipality,
            region=region,
            active_only=active_only,
            lat=lat,
            lon=lon,
            radius_km=radius_km,
        )

        total_stmt: Select[Any] = select(func.count()).select_from(
            base_stmt.order_by(None).subquery()
        )
        total = int((await self.session.execute(total_stmt)).scalar_one())

        query: Select[Any] = base_stmt.offset(offset).limit(limit)
        result = await self.session.execute(query)

        items: list[ServiceListRecord] = []
        rows: list[tuple[Any, ...]] = list(result.tuples().all())
        for row in rows:
            service = row[0]
            location_id = row[1]
            location = None

            if location_id is not None:
                location = ServiceLocationSummary(
                    id=int(location_id),
                    service_id=int(service.source_service_id),
                    provider_id=int(row[2]),
                    street=row[3],
                    number=row[4],
                    district=row[5],
                    municipality=row[6],
                    postal_code=row[7],
                    region=row[8],
                    service_name=row[9],
                    lat=float(row[10]) if row[10] is not None else None,
                    lon=float(row[11]) if row[11] is not None else None,
                    distance_km=float(row[12]) if row[12] is not None else None,
                )

            items.append(
                ServiceListRecord(
                    service=service,
                    location=location,
                    locations_count=int(row[13]),
                    target_groups_count=int(row[14]),
                    distance_km=float(row[12]) if row[12] is not None else None,
                )
            )

        return ServiceListResult(items=items, total=total)

    async def search_services_by_embedding(
        self,
        *,
        embedding: list[float],
        limit: int,
        offset: int,
        lat: float | None = None,
        lon: float | None = None,
        radius_km: float | None = None,
    ) -> ServiceListResult:
        location_subquery = self._build_location_rank_subquery(
            lat=lat,
            lon=lon,
            radius_km=radius_km,
        )

        semantic_distance = ServiceTargetGroup.embedding.cosine_distance(
            embedding
        ).label("semantic_distance")

        target_group_semantic = (
            select(
                ServiceTargetGroup.service_id.label("service_id"),
                func.min(semantic_distance).label("semantic_distance"),
            )
            .where(ServiceTargetGroup.embedding.is_not(None))
            .group_by(ServiceTargetGroup.service_id)
            .subquery()
        )

        locations_count = (
            select(func.count(ServiceLocation.id))
            .where(ServiceLocation.service_id == SocialService.source_service_id)
            .correlate(SocialService)
            .scalar_subquery()
            .label("locations_count")
        )
        target_groups_count = (
            select(func.count(ServiceTargetGroup.id))
            .where(ServiceTargetGroup.service_id == SocialService.source_service_id)
            .correlate(SocialService)
            .scalar_subquery()
            .label("target_groups_count")
        )

        stmt: Select[Any] = select(
            SocialService,
            location_subquery.c.location_id,
            location_subquery.c.provider_id,
            location_subquery.c.street,
            location_subquery.c.number,
            location_subquery.c.district,
            location_subquery.c.municipality,
            location_subquery.c.postal_code,
            location_subquery.c.region,
            location_subquery.c.service_name,
            location_subquery.c.lat,
            location_subquery.c.lon,
            location_subquery.c.distance_km,
            target_group_semantic.c.semantic_distance,
            locations_count,
            target_groups_count,
        ).select_from(SocialService)

        stmt = stmt.join(
            target_group_semantic,
            target_group_semantic.c.service_id == SocialService.source_service_id,
        )
        stmt = stmt.join(
            location_subquery,
            and_(
                location_subquery.c.service_id == SocialService.source_service_id,
                location_subquery.c.row_number == 1,
            ),
        )

        total_stmt: Select[Any] = select(func.count()).select_from(
            stmt.order_by(None).subquery()
        )
        total = int((await self.session.execute(total_stmt)).scalar_one())

        query: Select[Any] = (
            stmt.order_by(
                target_group_semantic.c.semantic_distance.asc(),
                location_subquery.c.distance_km.asc(),
                SocialService.provider_name.asc(),
                SocialService.source_service_id.asc(),
            )
            .offset(offset)
            .limit(limit)
        )
        result = await self.session.execute(query)

        items: list[ServiceListRecord] = []
        rows: list[tuple[Any, ...]] = list(result.tuples().all())
        for row in rows:
            service = row[0]
            location_id = row[1]
            location = None

            if location_id is not None:
                location = ServiceLocationSummary(
                    id=int(location_id),
                    service_id=int(service.source_service_id),
                    provider_id=int(row[2]),
                    street=row[3],
                    number=row[4],
                    district=row[5],
                    municipality=row[6],
                    postal_code=row[7],
                    region=row[8],
                    service_name=row[9],
                    lat=float(row[10]) if row[10] is not None else None,
                    lon=float(row[11]) if row[11] is not None else None,
                    distance_km=float(row[12]) if row[12] is not None else None,
                )

            items.append(
                ServiceListRecord(
                    service=service,
                    location=location,
                    locations_count=int(row[14]),
                    target_groups_count=int(row[15]),
                    distance_km=float(row[12]) if row[12] is not None else None,
                )
            )

        return ServiceListResult(items=items, total=total)

    async def get_by_source_service_id(
        self,
        source_service_id: int,
    ) -> SocialService | None:
        stmt = (
            select(SocialService)
            .options(
                joinedload(SocialService.locations),
                joinedload(SocialService.target_groups),
            )
            .where(SocialService.source_service_id == source_service_id)
        )

        result = await self.session.execute(stmt)
        return result.unique().scalar_one_or_none()
