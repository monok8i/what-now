"""Map-related API endpoints for social services."""

from fastapi import APIRouter, Depends

from src.api.depends import EmbeddingClientDependency, ServiceRepositoryDependency
from src.api.exceptions import MapServiceError, MapServiceNotFoundError
from src.api.schemas import (
    MapServiceBaseResponse,
    MapServiceDetailResponse,
    MapServiceListRequest,
    MapServiceListResponse,
    MapServiceSearchRequest,
    MapTargetGroupResponse,
)

from src.api.utils import build_list_item_payload, build_location_payload

router = APIRouter(prefix="/map", tags=["map"])


@router.get("/services", response_model=MapServiceListResponse)
async def list_services(
    service_repository: ServiceRepositoryDependency,
    payload: MapServiceListRequest = Depends(),
):
    """Return a paginated list of services, optionally filtered by geo data."""

    try:
        result = await service_repository.list_services(
            limit=payload.limit,
            offset=payload.offset,
            source_service_id=payload.source_service_id,
            provider_id=payload.provider_id,
            service_type_id=payload.service_type_id,
            identifier=payload.identifier,
            q=payload.q,
            municipality=payload.municipality,
            region=payload.region,
            active_only=payload.active_only,
            lat=payload.lat,
            lon=payload.lon,
            radius_km=payload.radius_km,
        )
    except Exception as exc:
        raise MapServiceError(detail=str(exc)) from exc

    items = [build_list_item_payload(record) for record in result.items]

    return MapServiceListResponse(
        limit=payload.limit,
        offset=payload.offset,
        total=result.total,
        items=items,
    )


@router.get("/services/{source_service_id}", response_model=MapServiceDetailResponse)
async def get_service(
    source_service_id: int,
    service_repository: ServiceRepositoryDependency,
):
    """Return one service with all of its locations and target groups."""

    try:
        service = await service_repository.get_by_source_service_id(source_service_id)
    except Exception as exc:
        raise MapServiceError(detail=str(exc)) from exc

    if service is None:
        raise MapServiceNotFoundError(
            detail=f"Service with source_service_id={source_service_id} was not found."
        )

    locations = [
        build_location_payload(location)
        for location in sorted(service.locations, key=lambda item: item.id)
    ]
    target_groups = [
        MapTargetGroupResponse.model_validate(group, from_attributes=True)
        for group in sorted(service.target_groups, key=lambda item: item.id)
    ]

    base_payload = MapServiceBaseResponse.model_validate(
        service, from_attributes=True
    ).model_dump()

    return MapServiceDetailResponse(
        **base_payload,
        locations_count=len(locations),
        target_groups_count=len(target_groups),
        locations=locations,
        target_groups=target_groups,
    )


@router.post("/services/search", response_model=MapServiceListResponse)
async def search_services(
    service_repository: ServiceRepositoryDependency,
    embedding_client: EmbeddingClientDependency,
    payload: MapServiceSearchRequest,
):
    """Search services by prompt-derived embedding and geo radius."""

    try:
        embedding = await embedding_client.generate_embeddings([payload.prompt])
        if not embedding:
            raise MapServiceError(detail="Failed to generate search embedding.")

        result = await service_repository.search_services_by_embedding(
            embedding=embedding[0],
            limit=payload.limit,
            offset=payload.offset,
            lat=payload.lat,
            lon=payload.lon,
            radius_km=payload.radius_km,
        )

    except Exception as exc:
        raise MapServiceError(detail=str(exc)) from exc

    items = [build_list_item_payload(record) for record in result.items]

    return MapServiceListResponse(
        limit=payload.limit,
        offset=payload.offset,
        total=result.total,
        items=items,
    )
