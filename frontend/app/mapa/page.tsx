"use client";

import dynamic from "next/dynamic";
import React from "react";

// We must dynamically import the Map component and disable SSR
// Leaflet uses the window object heavily, which causes errors during server-side rendering
const Map = dynamic(
    () => import("../../src/components/Map"),
    { ssr: false }
);

export default function MapaPage() {
    return (
        <main className="flex min-h-screen flex-col items-center justify-between p-4 md:p-8 bg-gray-50">
            <div className="z-10 w-full max-w-7xl items-center justify-between font-mono text-sm lg:flex mb-8">
                <h1 className="text-4xl font-bold Tracking-tight text-gray-900">Mapa Záznamů</h1>
                <p className="mt-2 text-gray-600">Interaktivní přehled lokací s ukázkovými daty z API</p>
            </div>

            <div className="w-full max-w-7xl h-[70vh] rounded-xl overflow-hidden shadow-xl border border-gray-200">
                {/* The map requires a specific height via its generic wrapper */}
                <div style={{ height: "100%", width: "100%" }}>
                    <Map />
                </div>
            </div>
        </main>
    );
}
