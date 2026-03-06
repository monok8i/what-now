"use client";

import { useEffect, useState } from "react";
import { MapContainer, TileLayer, Marker, Popup } from "react-leaflet";
import MarkerClusterGroup from "react-leaflet-cluster";
import L from "leaflet";
import "leaflet/dist/leaflet.css";

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

// Dummy data using the API structure provided
const DUMMY_DATA = [
    {
        portal_id: 4951,
        identifier: "1288849",
        addresses: [{ psc: "35201", city: "Aš" }],
        contacts: ["info@example.cz"],
        phones: ["+420 123 456 789"],
        persons: [
            {
                first_name: "Václav",
                last_name: "Hlaváč",
                title_before: "Ing.",
            },
        ],
        organizations: ["CARVAC s. r. o."],
        websites: ["www.example.cz"],
        // Obohaceno o mock GPS pro ucely zobrazeni v mape!
        lat: 50.2222,
        lon: 12.1888,
    },
    {
        portal_id: 4952,
        identifier: "1234567",
        addresses: [{ psc: "11000", city: "Praha" }],
        contacts: ["kontakt@praha.cz"],
        phones: ["+420 987 654 321"],
        persons: [
            {
                first_name: "Jan",
                last_name: "Novák",
                title_before: "Mgr.",
            },
        ],
        organizations: ["Pražská firma s.r.o."],
        websites: ["www.prazskafirma.cz"],
        lat: 50.088,
        lon: 14.42,
    },
    {
        portal_id: 4953,
        identifier: "7654321",
        addresses: [{ psc: "60200", city: "Brno" }],
        contacts: ["info@brno.cz"],
        phones: ["+420 111 222 333"],
        persons: [
            {
                first_name: "Karel",
                last_name: "Svoboda",
                title_before: "",
            },
        ],
        organizations: ["Brněnský startup"],
        websites: ["www.brnostartup.cz"],
        lat: 49.195,
        lon: 16.606,
    },
];

export default function Map() {
    const [mounted, setMounted] = useState(false);

    useEffect(() => {
        const timeout = setTimeout(() => setMounted(true), 0);
        return () => clearTimeout(timeout);
    }, []);

    if (!mounted) {
        // Return empty div with same dimensions while mounting to avoid layout shifts
        return <div className="h-full w-full bg-gray-100 rounded-lg animate-pulse" />;
    }

    return (
        <MapContainer
            center={[49.8, 15.5]} // Střed ČR
            zoom={7}
            scrollWheelZoom={true}
            className="h-full w-full rounded-lg z-0"
        >
            <TileLayer
                attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
            />

            <MarkerClusterGroup chunkedLoading>
                {DUMMY_DATA.map((record) => (
                    <Marker
                        key={record.portal_id}
                        position={[record.lat, record.lon]}
                        icon={customMarkerIcon}
                    >
                        <Popup>
                            <div className="flex flex-col gap-1 min-w-[200px]">
                                <h3 className="font-bold text-lg mb-1">{record.organizations[0]}</h3>

                                <p className="text-sm m-0">
                                    <strong>Adresa:</strong> {record.addresses[0]?.city}, {record.addresses[0]?.psc}
                                </p>

                                {record.persons && record.persons.length > 0 && (
                                    <p className="text-sm m-0">
                                        <strong>Zástupce:</strong> {record.persons[0].title_before} {record.persons[0].first_name} {record.persons[0].last_name}
                                    </p>
                                )}

                                {record.phones && record.phones.length > 0 && (
                                    <p className="text-sm m-0">
                                        <strong>Tel:</strong> <a href={`tel:${record.phones[0]}`} className="text-blue-600">{record.phones[0]}</a>
                                    </p>
                                )}

                                {record.websites && record.websites.length > 0 && (
                                    <p className="text-sm m-0 mt-2">
                                        <a
                                            href={record.websites[0].startsWith('http') ? record.websites[0] : `https://${record.websites[0]}`}
                                            target="_blank"
                                            rel="noopener noreferrer"
                                            className="text-blue-600 underline"
                                        >
                                            Webové stránky
                                        </a>
                                    </p>
                                )}
                            </div>
                        </Popup>
                    </Marker>
                ))}
            </MarkerClusterGroup>
        </MapContainer>
    );
}
