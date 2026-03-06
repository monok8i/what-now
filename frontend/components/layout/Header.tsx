import { HeartPulse } from "lucide-react";
import Link from "next/link";

export function Header({
    showStep = false,
    step = 1,
    isSubmitted = false,
}: {
    showStep?: boolean;
    step?: number;
    isSubmitted?: boolean;
}) {
    return (
        <header className="bg-white border-b border-slate-200 py-6 px-4 md:px-8 shrink-0">
            <div className="max-w-3xl mx-auto flex items-center justify-between">
                <div className="flex items-center gap-6">
                    <div className="flex items-center gap-2">
                        <HeartPulse className="w-6 h-6 text-indigo-600" />
                        <Link href="/" className="font-semibold text-xl tracking-tight text-slate-900">
                            Co teď?
                        </Link>
                    </div>

                    {!showStep && (
                        <nav className="hidden md:flex items-center gap-6">
                            <a href="#jak-to-funguje" className="text-sm font-medium text-slate-600 hover:text-indigo-600 transition-colors">
                                Jak to funguje
                            </a>
                            <a href="#co-ziskate" className="text-sm font-medium text-slate-600 hover:text-indigo-600 transition-colors">
                                Co získáte
                            </a>
                        </nav>
                    )}
                </div>
                {showStep && (
                    <span className="text-sm font-medium text-slate-500">
                        Krok {isSubmitted ? 4 : step} z 4
                    </span>
                )}
            </div>
        </header>
    );
}
