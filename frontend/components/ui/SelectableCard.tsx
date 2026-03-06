import React from "react";

export function SelectableCard({
    label,
    description,
    selected,
    onClick,
    className = "",
}: {
    label: string;
    description?: string;
    selected: boolean;
    onClick: () => void;
    className?: string;
}) {
    return (
        <button
            type="button"
            onClick={onClick}
            className={`relative w-full flex items-center justify-center p-3 rounded-xl border-2 transition-all duration-200 outline-none
        ${selected
                    ? "border-indigo-600 bg-indigo-50/50 text-indigo-900"
                    : "border-slate-200 bg-white text-slate-700 hover:border-indigo-300 hover:bg-slate-50"
                } ${className}`}
        >
            <div className="font-semibold">{label}</div>
            {description && (
                <div
                    className={`text-sm mt-1 ${selected ? "text-indigo-700" : "text-slate-500"
                        }`}
                >
                    {description}
                </div>
            )}
            {selected && (
                <div className="absolute right-4 top-1/2 -translate-y-1/2 w-4 h-4 rounded-full bg-indigo-600 outline outline-2 outline-white flex items-center justify-center">
                    <div className="w-1.5 h-1.5 bg-white rounded-full" />
                </div>
            )}
        </button>
    );
}
