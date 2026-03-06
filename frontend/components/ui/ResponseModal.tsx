import React, { useEffect } from 'react';
import ReactMarkdown from 'react-markdown';
import { X, CheckCircle2, Info, AlertCircle, FileText } from 'lucide-react';
import remarkGfm from 'remark-gfm';

export interface ApiResponse {
    message: string;
    submission_id?: string;
    total_matches?: number;
    matching_benefits?: any[];
    ai_response?: string;
}

interface ResponseModalProps {
    isOpen: boolean;
    onClose: () => void;
    data: ApiResponse | null;
}

export function ResponseModal({ isOpen, onClose, data }: ResponseModalProps) {
    // Prevent scrolling on body when modal is open
    useEffect(() => {
        if (isOpen) {
            document.body.style.overflow = 'hidden';
        } else {
            document.body.style.overflow = 'unset';
        }
        return () => {
            document.body.style.overflow = 'unset';
        };
    }, [isOpen]);

    if (!isOpen || !data) return null;

    const hasMatches = (data.total_matches ?? 0) > 0;

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 sm:p-6 bg-slate-900/60 backdrop-blur-sm">
            <div
                className="bg-white rounded-3xl shadow-2xl w-full max-w-4xl max-h-[90vh] flex flex-col animate-in fade-in zoom-in-95 duration-200"
                onClick={(e) => e.stopPropagation()}
            >
                {/* Header */}
                <div className="flex items-center justify-between px-6 py-4 border-b border-slate-100 bg-slate-50/80 rounded-t-3xl backdrop-blur-md sticky top-0 z-10">
                    <div className="flex items-center gap-4">
                        <div className={`p-2.5 rounded-2xl ${hasMatches ? 'bg-green-100 text-green-600' : 'bg-indigo-100 text-indigo-600'}`}>
                            {hasMatches ? <CheckCircle2 className="w-6 h-6" /> : <Info className="w-6 h-6" />}
                        </div>
                        <div>
                            <h2 className="text-xl font-bold text-slate-900">Výsledek vyhodnocení</h2>
                            <p className="text-sm font-medium text-slate-500">{data.message || 'Zde jsou informace k vaší situaci.'}</p>
                        </div>
                    </div>
                    <button
                        onClick={onClose}
                        className="p-2 text-slate-400 hover:text-slate-700 hover:bg-slate-200/60 rounded-full transition-colors focus:outline-none focus:ring-2 focus:ring-slate-300"
                        aria-label="Zavřít"
                    >
                        <X className="w-6 h-6" />
                    </button>
                </div>

                {/* Content */}
                <div className="flex-1 overflow-y-auto w-full">
                    <div className="p-6 md:p-8">
                        {/* AI Response Section */}
                        {data.ai_response ? (
                            <div className="prose prose-slate prose-indigo max-w-none prose-headings:font-bold prose-h1:text-2xl prose-h2:text-xl prose-h2:mt-8 prose-h2:mb-4 prose-h3:text-lg prose-p:text-slate-600 prose-p:leading-relaxed prose-li:text-slate-600 prose-strong:text-slate-900 prose-a:text-indigo-600 prose-a:no-underline hover:prose-a:underline">
                                <ReactMarkdown remarkPlugins={[remarkGfm]}>
                                    {data.ai_response}
                                </ReactMarkdown>
                            </div>
                        ) : (
                            <div className="text-center py-12">
                                <FileText className="w-12 h-12 text-slate-300 mx-auto mb-4" />
                                <h3 className="text-lg font-medium text-slate-900">Žádná podrobnější analýza</h3>
                                <p className="text-slate-500 mt-2">K vašemu dotazu nebyly vygenerovány žádné podrobnější informace.</p>
                            </div>
                        )}

                        {/* Additional Structured Data Could Go Here */}
                        {hasMatches && data.matching_benefits && data.matching_benefits.length > 0 && (
                            <div className="mt-8 pt-6 border-t border-slate-100">
                                <h3 className="text-lg font-bold text-slate-900 mb-4 flex items-center gap-2">
                                    <CheckCircle2 className="w-5 h-5 text-green-500" />
                                    Nalezené konkrétní dávky
                                </h3>
                                <div className="grid gap-4 sm:grid-cols-2">
                                    {data.matching_benefits.map((benefit, idx) => (
                                        <div key={idx} className="bg-slate-50 rounded-xl p-4 border border-slate-100 flex items-start gap-3">
                                            <div className="w-2 h-2 rounded-full bg-indigo-500 mt-2 shrink-0" />
                                            <div>
                                                <p className="font-semibold text-slate-900">{typeof benefit === 'string' ? benefit : benefit.name || 'Dávka'}</p>
                                                {benefit.description && <p className="text-sm text-slate-500 mt-1 line-clamp-2">{benefit.description}</p>}
                                            </div>
                                        </div>
                                    ))}
                                </div>
                            </div>
                        )}
                    </div>
                </div>

                {/* Footer */}
                <div className="p-6 border-t border-slate-100 bg-slate-50 rounded-b-3xl">
                    <button
                        onClick={onClose}
                        className="w-full sm:w-auto px-8 py-3.5 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl font-semibold transition-all shadow-md shadow-indigo-200 flex items-center justify-center sm:ml-auto"
                    >
                        Rozumím a chci začít znovu
                    </button>
                </div>
            </div>
        </div>
    );
}
