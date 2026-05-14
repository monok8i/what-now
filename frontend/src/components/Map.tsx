"use client";

import { useEffect, useState } from "react";
import { MapContainer, TileLayer, Marker, Popup, useMap } from "react-leaflet";
import MarkerClusterGroup from "react-leaflet-cluster";
import L from "leaflet";
import { CircleMarker } from "react-leaflet";
// @ts-ignore: CSS import from node_modules
import "leaflet/dist/leaflet.css";

type MapServiceLocation = {
    id: number;
    service_id: number;
    provider_id: number;
    street: string;
    number: string;
    district: string;
    municipality: string;
    postal_code: string;
    region: string;
    service_name: string;
    lat: number | null;
    lon: number | null;
    distance_km: number | null;
};

type UserLocation = {
    lat: number;
    lon: number;
} | null;

type MapService = {
    source_service_id: number;
    identifier: string;
    provider_id: number;
    provider_name: string;
    provider_ico: string;
    service_type_id: number;
    active_from: string;
    active_to: string;
    region_scope_by_address: boolean;
    locations_count: number;
    target_groups_count: number;
    distance_km: number | null;
    location: MapServiceLocation;
};

interface MapProps {
    services?: MapService[];
    userLocation?: UserLocation;
}

// Define custom icon directly to avoid Next.js import path issues
const customMarkerIcon = typeof window !== "undefined" ?
    new L.Icon({
        iconUrl: "/marker-icon.png",
        iconRetinaUrl: "/marker-icon-2x.png",
        shadowUrl: "/marker-shadow.png",
        iconSize: [25, 41],
        iconAnchor: [12, 41],
        popupAnchor: [1, -34],
        shadowSize: [41, 41]
    }) : undefined;

const DEFAULT_CENTER: [number, number] = [49.8, 15.5];

const formatDistance = (distance: number | null) =>
    typeof distance === "number" && Number.isFinite(distance) ? `${distance.toFixed(1)} km` : "—";

const formatCoordinate = (coordinate: number | null) =>
    typeof coordinate === "number" && Number.isFinite(coordinate) ? coordinate.toFixed(4) : "—";

const toNumber = (value: unknown) => {
    const parsed = typeof value === "string" ? Number(value) : value;
    return typeof parsed === "number" && Number.isFinite(parsed) ? parsed : null;
};

const calculateDistanceKm = (from: { lat: number; lon: number }, to: { lat: number; lon: number }) => {
    const earthRadiusKm = 6371;
    const latDelta = ((to.lat - from.lat) * Math.PI) / 180;
    const lonDelta = ((to.lon - from.lon) * Math.PI) / 180;
    const startLat = (from.lat * Math.PI) / 180;
    const endLat = (to.lat * Math.PI) / 180;

    const a =
        Math.sin(latDelta / 2) * Math.sin(latDelta / 2) +
        Math.sin(lonDelta / 2) * Math.sin(lonDelta / 2) * Math.cos(startLat) * Math.cos(endLat);
    return 2 * earthRadiusKm * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
};

type NormalizedMapService = MapService & {
    id: string | number;
    lat: number;
    lon: number;
    computedDistanceKm: number | null;
};

const normalizeServices = (services?: MapService[], userLocation: UserLocation = null) =>
    (services ?? [])
        .filter((service) => toNumber(service.location?.lat) !== null && toNumber(service.location?.lon) !== null)
        .map((service, index): NormalizedMapService => ({
            ...service,
            id: service.source_service_id ?? service.location.id ?? `${index}-${service.location.lat}-${service.location.lon}`,
            lat: toNumber(service.location.lat) as number,
            lon: toNumber(service.location.lon) as number,
            computedDistanceKm:
                typeof service.distance_km === "number" && Number.isFinite(service.distance_km)
                    ? service.distance_km
                    : userLocation && toNumber(service.location.lat) !== null && toNumber(service.location.lon) !== null
                        ? calculateDistanceKm(userLocation, {
                            lat: toNumber(service.location.lat) as number,
                            lon: toNumber(service.location.lon) as number,
                        })
                        : null,
        }));

const FitMapBounds = ({
    services,
    userLocation,
}: {
    services: NormalizedMapService[];
    userLocation: UserLocation;
}) => {
    const map = useMap();

    useEffect(() => {
        const points = services.map((service) => [service.lat, service.lon] as [number, number]);

        if (userLocation) {
            points.push([userLocation.lat, userLocation.lon]);
        }

        if (points.length === 0) {
            return;
        }

        if (points.length === 1) {
            map.setView(points[0], 13);
            return;
        }

        map.fitBounds(L.latLngBounds(points), {
            padding: [48, 48],
            maxZoom: 13,
        });
    }, [map, services, userLocation]);

    return null;
};

export default function Map({ services, userLocation }: MapProps) {
    const [mounted, setMounted] = useState(false);
    const normalizedServices = normalizeServices(services, userLocation);

    useEffect(() => {
        const timeout = setTimeout(() => setMounted(true), 0);
        return () => clearTimeout(timeout);
    }, []);

    if (!mounted) {
        // Return empty div with same dimensions while mounting to avoid layout shifts
        return <div className="h-full w-full bg-gray-100 rounded-lg animate-pulse" />;
    }

    const center: [number, number] = normalizedServices.length > 0
        ? [
            normalizedServices.reduce((sum, service) => sum + service.lat, 0) / normalizedServices.length,
            normalizedServices.reduce((sum, service) => sum + service.lon, 0) / normalizedServices.length,
        ]
        : DEFAULT_CENTER;

    const hasUserLocation = Boolean(userLocation && Number.isFinite(userLocation.lat) && Number.isFinite(userLocation.lon));

    const mapCenter: [number, number] = hasUserLocation && userLocation
        ? [
            (center[0] + userLocation.lat) / 2,
            (center[1] + userLocation.lon) / 2,
        ]
        : center;

    const zoom = normalizedServices.length > 0 ? 11 : 7;

    return (
        <MapContainer
            center={mapCenter}
            zoom={zoom}
            scrollWheelZoom={true}
            className="h-full w-full rounded-lg z-0"
        >
            <FitMapBounds services={normalizedServices} userLocation={userLocation ?? null} />
            <TileLayer
                attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
            />

            <MarkerClusterGroup chunkedLoading>
                {normalizedServices.map((record) => (
                    <Marker
                        key={record.id}
                        position={[record.lat, record.lon]}
                        icon={customMarkerIcon}
                    >
                        <Popup>
                            <div className="flex w-full max-w-60 flex-col gap-1">
                                <h3 className="text-sm font-bold leading-tight text-slate-900">{record.location.service_name || record.provider_name || 'Služba'}</h3>

                                <p className="text-xs leading-tight text-slate-600">
                                    <span className="font-semibold text-slate-800">Poskytovatel:</span> {record.provider_name}
                                </p>

                                <p className="text-xs leading-tight text-slate-600">
                                    <span className="font-semibold text-slate-800">Adresa:</span> {record.location.street} {record.location.number}, {record.location.municipality} {record.location.postal_code}
                                </p>

                                <p className="text-xs leading-tight text-slate-600">
                                    <span className="font-semibold text-slate-800">Město:</span> {record.location.municipality || record.location.district || '—'}
                                </p>

                                <p className="text-xs leading-tight text-slate-600">
                                    <span className="font-semibold text-slate-800">Vzdálenost:</span> {formatDistance(record.computedDistanceKm)}
                                </p>

                                <p className="text-xs leading-tight text-slate-600">
                                    <span className="font-semibold text-slate-800">Region:</span> {record.location.region || record.location.district || '—'}
                                </p>
                            </div>
                        </Popup>
                    </Marker>
                ))}
            </MarkerClusterGroup>

            {hasUserLocation && userLocation && (
                <CircleMarker
                    center={[userLocation.lat, userLocation.lon]}
                    radius={9}
                    pathOptions={{
                        color: "#2563eb",
                        fillColor: "#3b82f6",
                        fillOpacity: 0.9,
                        weight: 3,
                    }}
                >
                    <Popup>
                        <div className="flex flex-col gap-1">
                            <h3 className="text-sm font-bold leading-tight text-slate-900">Vaše poloha</h3>
                            <p className="text-xs leading-tight text-slate-600">
                                <span className="font-semibold text-slate-800">Souřadnice:</span> {formatCoordinate(userLocation.lat)}, {formatCoordinate(userLocation.lon)}
                            </p>
                        </div>
                    </Popup>
                </CircleMarker>
            )}
        </MapContainer>
    );
}
