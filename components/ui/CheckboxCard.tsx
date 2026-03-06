import React from "react";
import { CheckCircle2 } from "lucide-react";

export function CheckboxCard({
    label,
    checked,
    onChange,
    disabled = false,
}: {
    label: string;
    checked: boolean;
    onChange: () => void;
    disabled?: boolean;
}) {
    return (
        <button
            type="button"
            onClick={onChange}
            disabled={disabled}
            className={`relative w-full flex items-center justify-start px-5 py-4 rounded-xl border-2 transition-all duration-200 outline-none text-left
        ${checked
                    ? "border-indigo-600 bg-indigo-50/50 text-indigo-900"
                    : disabled
                        ? "border-slate-100 bg-slate-50 text-slate-400 opacity-60 cursor-not-allowed"
                        : "border-slate-200 bg-white text-slate-700 hover:border-indigo-300 hover:bg-slate-50"
                }`}
        >
            <div className="font-semibold pr-8">{label}</div>
            <div
                className={`absolute right-5 top-1/2 -translate-y-1/2 w-5 h-5 rounded border flex items-center justify-center ${checked ? "bg-indigo-600 border-indigo-600" : "border-slate-300"
                    }`}
            >
                {checked && <CheckCircle2 className="w-4 h-4 text-white" />}
            </div>
        </button>
    );
}
