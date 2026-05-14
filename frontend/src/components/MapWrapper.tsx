"use client";

import dynamic from "next/dynamic";
import type { ComponentType } from "react";

type UserLocation = {
    lat: number;
    lon: number;
} | null;

const Map = dynamic(() => import("./Map"), { ssr: false }) as ComponentType<{ services?: unknown[]; userLocation?: UserLocation }>;

interface MapWrapperProps {
    services?: unknown[];
    userLocation?: UserLocation;
}

export default function MapWrapper({ services, userLocation }: MapWrapperProps) {
    return <Map services={services} userLocation={userLocation} />;
}
