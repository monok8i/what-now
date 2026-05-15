import { useEffect, useState } from 'react';
import { RefreshCcw, CheckCircle2, Loader2, Bot, MapPin, X } from 'lucide-react';
import type { ReactElement } from 'react';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import MapWrapper from '@/src/components/MapWrapper';

const LOADING_MESSAGES = [
    "Analyzujeme vaši situaci...",
    "Počítáme vaše přesčasové hodiny nad péčí...",
    "Hledáme jehlu v kupce formulářů...",
    "Luštíme státní byrokracii a zákony...",
    "Zjišťujeme, na co všechno máte nárok...",
    "Ještě chvilinku, státní úřady mají polední pauzu...",
    "Zpracováváme všechny dostupné možnosti..."
];

export interface ApiResponse {
    total_chunks: number;
    message: string;
    map_services: MapServiceResponse[];
}

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

export type MapServiceResponse = {
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

export type UserLocation = {
    lat: number;
    lon: number;
} | null;

interface ResponseChatProps {
    data: ApiResponse | null;
    isLoading?: boolean;
    onReset: () => void;
    userLocation?: UserLocation;
}

const MapWrapperWithUserLocation = MapWrapper as unknown as (props: {
    services?: MapServiceResponse[];
    userLocation?: UserLocation;
}) => ReactElement;

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

export function ResponseChat({ data, isLoading = false, onReset, userLocation = null }: ResponseChatProps) {
    const [loadingMsgIdx, setLoadingMsgIdx] = useState(0);
    const [isMapOpen, setIsMapOpen] = useState(false);

    useEffect(() => {
        if (!isLoading) return;
        const interval = setInterval(() => {
            setLoadingMsgIdx(prev => (prev + 1) % LOADING_MESSAGES.length);
        }, 3000);
        return () => clearInterval(interval);
    }, [isLoading]);

    useEffect(() => {
        if (!isMapOpen) return;

        const handleKeyDown = (event: KeyboardEvent) => {
            if (event.key === 'Escape') {
                setIsMapOpen(false);
            }
        };

        window.addEventListener('keydown', handleKeyDown);
        document.body.style.overflow = 'hidden';

        return () => {
            window.removeEventListener('keydown', handleKeyDown);
            document.body.style.overflow = '';
        };
    }, [isMapOpen]);

    const normalizedMapServices = (data?.map_services ?? []).filter(
        (service): service is MapServiceResponse => Boolean(service?.location)
    );

    const hasMapServices = normalizedMapServices.length > 0;

    const getServiceName = (service: MapServiceResponse) =>
        service.location.service_name || service.provider_name || 'Služba';

    const getServiceAddress = (service: MapServiceResponse) =>
        [service.location.street, service.location.number, service.location.municipality, service.location.postal_code].filter(Boolean).join(' ');

    const formatDistance = (distance: number | null) =>
        typeof distance === 'number' && Number.isFinite(distance) ? `${distance.toFixed(1)} km` : '—';

    const getDistance = (service: MapServiceResponse) => {
        if (typeof service.distance_km === 'number' && Number.isFinite(service.distance_km)) {
            return service.distance_km;
        }

        if (
            userLocation &&
            typeof service.location.lat === 'number' &&
            Number.isFinite(service.location.lat) &&
            typeof service.location.lon === 'number' &&
            Number.isFinite(service.location.lon)
        ) {
            return calculateDistanceKm(userLocation, {
                lat: service.location.lat,
                lon: service.location.lon,
            });
        }

        return null;
    };

    const formatCoordinate = (coordinate: number | null) =>
        typeof coordinate === 'number' && Number.isFinite(coordinate) ? coordinate.toFixed(4) : '—';

    if (!data && !isLoading) return null;

    return (
        <div className="bg-white rounded-3xl shadow-sm border border-slate-200/60 w-full flex flex-col overflow-hidden h-[calc(100vh-160px)]" style={{ minHeight: '600px' }}>
            {/* Header */}
            <div className="flex items-center justify-between px-6 py-4 border-b border-slate-100 bg-slate-50/80 backdrop-blur-md z-10 shrink-0">
                <div className="flex items-center gap-4">
                    <div className="p-2.5 rounded-2xl bg-indigo-100 text-indigo-600">
                        {isLoading ? <Loader2 className="w-6 h-6 animate-spin" /> : <CheckCircle2 className="w-6 h-6" />}
                    </div>
                    <div>
                        <h2 className="text-xl font-bold text-slate-900">Vyhodnocení</h2>
                        <div className="flex items-center gap-2">
                            <p className="text-sm font-medium text-slate-500">
                                {isLoading ? 'Zpracováváme vaše údaje...' : `Najdeno ${data?.total_chunks || 0} relevantních zdrojů`}
                            </p>
                        </div>
                    </div>
                </div>
                <button
                    onClick={onReset}
                    className="p-2 text-slate-400 hover:text-slate-700 hover:bg-slate-200/60 rounded-full transition-colors flex items-center justify-center focus:outline-none focus:ring-2 focus:ring-slate-300"
                    title="Začít znovu / Vyplnit znovu formulář"
                    aria-label="Začít znovu"
                >
                    <RefreshCcw className="w-5 h-5" />
                </button>
            </div>

            {/* Content - Result Message */}
            <div className="flex-1 overflow-y-auto w-full bg-slate-50/50 p-6 md:p-8 space-y-6">
                {isLoading ? (
                    <div className="flex-1 w-full h-full flex flex-col justify-center items-center text-center space-y-8 animate-in fade-in duration-500 py-10">
                        <div className="relative flex justify-center items-center h-28 w-28 mb-4">
                            <div className="absolute inset-x-0 inset-y-0 rounded-full bg-indigo-100 animate-ping opacity-25"></div>
                            <div className="relative flex justify-center items-center h-20 w-20 bg-indigo-50 rounded-full border border-indigo-100 shadow-sm">
                                <Bot className="w-10 h-10 text-indigo-600 animate-pulse" />
                            </div>
                        </div>

                        <div className="h-10 px-4">
                            <h3 className="text-xl md:text-2xl font-medium text-slate-800 animate-pulse transition-all duration-300" key={loadingMsgIdx}>
                                {LOADING_MESSAGES[loadingMsgIdx]}
                            </h3>
                        </div>

                        {/* Skelet pro zprávy */}
                        <div className="w-full max-w-2xl space-y-6 mt-12 opacity-50 px-4">
                            <div className="flex gap-4">
                                <div className="w-10 h-10 rounded-full bg-slate-200 animate-pulse shrink-0"></div>
                                <div className="bg-slate-200 h-24 w-3/4 rounded-2xl rounded-tl-sm animate-pulse"></div>
                            </div>
                            <div className="flex gap-4 flex-row-reverse">
                                <div className="w-10 h-10 rounded-full bg-indigo-100 animate-pulse shrink-0"></div>
                                <div className="bg-indigo-100 h-16 w-1/2 rounded-2xl rounded-tr-sm animate-pulse"></div>
                            </div>
                            <div className="flex gap-4">
                                <div className="w-10 h-10 rounded-full bg-slate-200 animate-pulse shrink-0"></div>
                                <div className="space-y-3 w-3/4">
                                    <div className="bg-slate-200 h-8 w-full rounded-lg animate-pulse"></div>
                                    <div className="bg-slate-200 h-8 w-5/6 rounded-lg animate-pulse"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                ) : (
                    <div className="bg-white rounded-2xl p-6 md:p-8 border border-slate-100 shadow-sm">
                        <div className="flex items-start gap-4">
                            <div className="w-10 h-10 rounded-full bg-slate-200 text-slate-600 flex items-center justify-center shrink-0">
                                <Bot className="w-5 h-5" />
                            </div>
                            <div className="flex-1 prose prose-sm dark:prose-invert max-w-none">
                                <ReactMarkdown
                                    remarkPlugins={[remarkGfm]}
                                    components={{
                                        p: ({ node, ...props }: any) => <p className="text-base md:text-lg leading-relaxed text-slate-700 mb-4" {...props} />,
                                        h1: ({ node, ...props }: any) => <h1 className="text-2xl font-bold text-slate-900 mt-6 mb-3" {...props} />,
                                        h2: ({ node, ...props }: any) => <h2 className="text-xl font-bold text-slate-900 mt-5 mb-3" {...props} />,
                                        h3: ({ node, ...props }: any) => <h3 className="text-lg font-semibold text-slate-900 mt-4 mb-2" {...props} />,
                                        ul: ({ node, ...props }: any) => <ul className="list-disc list-inside text-slate-700 mb-4 space-y-2" {...props} />,
                                        ol: ({ node, ...props }: any) => <ol className="list-decimal list-inside text-slate-700 mb-4 space-y-2" {...props} />,
                                        li: ({ node, ...props }: any) => <li className="text-base md:text-lg text-slate-700" {...props} />,
                                        blockquote: ({ node, ...props }: any) => <blockquote className="border-l-4 border-indigo-300 bg-indigo-50 pl-4 py-2 my-4 text-slate-700" {...props} />,
                                        code: ({ node, className, children, ...props }: any) => {
                                            const isBlockCode = typeof className === 'string' && className.includes('language-');

                                            return isBlockCode ? (
                                                <code className="bg-slate-100 p-3 rounded block my-4 overflow-x-auto text-sm text-slate-700" {...props}>
                                                    {children}
                                                </code>
                                            ) : (
                                                <code className="bg-slate-100 px-2 py-1 rounded text-red-600 font-mono text-sm" {...props}>
                                                    {children}
                                                </code>
                                            );
                                        },
                                        a: ({ node, ...props }: any) => <a className="text-indigo-600 hover:underline" {...props} />,
                                        strong: ({ node, ...props }: any) => <strong className="font-bold text-slate-900" {...props} />,
                                        em: ({ node, ...props }: any) => <em className="italic text-slate-700" {...props} />,
                                    }}
                                >
                                    {data?.message || 'Zde je vaše odpověď od backendu.'}
                                </ReactMarkdown>
                            </div>
                        </div>

                        {hasMapServices && (
                            <div className="mt-6 border-t border-slate-100 pt-5 flex items-center justify-end">
                                <button
                                    type="button"
                                    onClick={() => setIsMapOpen(true)}
                                    className="inline-flex items-center justify-center gap-2 rounded-xl bg-indigo-600 px-4 py-3 text-sm font-semibold text-white transition-all hover:bg-indigo-700 hover:shadow-md hover:shadow-indigo-200 focus:outline-none focus:ring-2 focus:ring-indigo-300"
                                >
                                    <MapPin className="h-4 w-4" />
                                    Zobrazit nejbližší služby
                                </button>
                            </div>
                        )}
                    </div>
                )}
            </div>

            {isMapOpen && hasMapServices && (
                <div
                    className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/55 px-4 py-6 backdrop-blur-sm"
                    onClick={() => setIsMapOpen(false)}
                    role="dialog"
                    aria-modal="true"
                    aria-label="Mapa blízkých služeb"
                >
                    <div
                        className="flex h-[88vh] w-full max-w-7xl flex-col overflow-hidden rounded-3xl bg-white shadow-2xl"
                        onClick={(event) => event.stopPropagation()}
                    >
                        <div className="flex items-center justify-between border-b border-slate-100 px-6 py-4">
                            <div>
                                <h3 className="text-lg font-bold text-slate-900">
                                    Nalezeno {normalizedMapServices.length} služeb do 100 kilometrů
                                </h3>
                                <p className="text-sm text-slate-500">Kliknutím na bod na mapě zobrazíte detail služby.</p>
                            </div>
                            <button
                                type="button"
                                onClick={() => setIsMapOpen(false)}
                                className="inline-flex h-10 w-10 items-center justify-center rounded-full text-slate-500 transition-colors hover:bg-slate-100 hover:text-slate-900"
                                aria-label="Zavřít mapu"
                            >
                                <X className="h-5 w-5" />
                            </button>
                        </div>
                        <div className="grid flex-1 grid-cols-1 gap-4 overflow-hidden bg-slate-50 p-4 md:grid-cols-[minmax(0,1.7fr)_minmax(320px,0.9fr)] md:p-6">
                            <div className="min-h-0 overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
                                <MapWrapperWithUserLocation services={normalizedMapServices} userLocation={userLocation} />
                            </div>
                            <div className="min-h-0 overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
                                <div className="flex h-full flex-col">
                                    <div className="border-b border-slate-100 px-5 py-4">
                                        <h4 className="text-base font-semibold text-slate-900">Seznam služeb</h4>
                                        <p className="text-sm text-slate-500">{normalizedMapServices.length} dostupných výsledků</p>
                                    </div>
                                    <div className="flex-1 overflow-y-auto p-4">
                                        <div className="space-y-3">
                                            {normalizedMapServices.map((service) => (
                                                <div
                                                    key={`${service.source_service_id}-${service.location.id}`}
                                                    className="rounded-2xl border border-slate-200 bg-slate-50 p-3.5 transition-colors hover:border-indigo-300 hover:bg-indigo-50/60"
                                                >
                                                    <div className="flex items-start justify-between gap-2.5">
                                                        <div>
                                                            <h5 className="text-sm font-semibold leading-tight text-slate-900">
                                                                {getServiceName(service)}
                                                            </h5>
                                                            <p className="mt-1 text-xs text-slate-500">
                                                                {service.location.region || service.location.district || 'Bez regionu'}
                                                            </p>
                                                            {getServiceAddress(service) && (
                                                                <p className="mt-1 text-sm text-slate-600 leading-snug">
                                                                    {getServiceAddress(service)}
                                                                </p>
                                                            )}
                                                        </div>
                                                        <span className="shrink-0 rounded-full bg-white px-2 py-1 text-xs font-medium text-slate-500 shadow-sm">
                                                            {formatCoordinate(service.location.lat)}, {formatCoordinate(service.location.lon)}
                                                        </span>
                                                    </div>

                                                    <div className="mt-2.5 flex flex-wrap gap-x-4 gap-y-1 text-sm text-slate-600">
                                                        <p>
                                                            <span className="font-medium text-slate-700">Vzdálenost:</span>{' '}
                                                            {formatDistance(getDistance(service))}
                                                        </p>
                                                        <p>
                                                            <span className="font-medium text-slate-700">Poboček:</span>{' '}
                                                            {service.locations_count}
                                                        </p>
                                                        <p>
                                                            <span className="font-medium text-slate-700">Cílové skupiny:</span>{' '}
                                                            {service.target_groups_count}
                                                        </p>
                                                    </div>
                                                </div>
                                            ))}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
