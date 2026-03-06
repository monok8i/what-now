"use client";

import { useState } from "react";
import {
    ChevronRight,
    ChevronLeft,
    User,
    HeartPulse,
    Home,
    Briefcase,
    CheckCircle2,
    Loader2,
} from "lucide-react";
import { FormData, initialData } from "@/types/form";
import { StepOne } from "@/components/steps/StepOne";
import { StepTwo } from "@/components/steps/StepTwo";
import { StepThree } from "@/components/steps/StepThree";
import { StepFour } from "@/components/steps/StepFour";
import { Header } from "@/components/layout/Header";
import { ResponseChat, ApiResponse } from "@/components/ui/ResponseChat";

const STEPS = [
    { id: 1, title: "Kdo potřebuje péči?", icon: User },
    { id: 2, title: "Jak na tom je?", icon: HeartPulse },
    { id: 3, title: "Jak to máte zařízené?", icon: Home },
    { id: 4, title: "Tvoje situace", icon: Briefcase },
];

export default function CaregiverForm() {
    const [step, setStep] = useState(1);
    const [data, setData] = useState<FormData>(initialData);
    const [isSubmitted, setIsSubmitted] = useState(false);
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [submitError, setSubmitError] = useState<string | null>(null);
    const [responseData, setResponseData] = useState<ApiResponse | null>(null);

    const updateData = (fields: Partial<FormData>) => {
        setData((prev) => ({ ...prev, ...fields }));
    };

    const submitForm = async () => {
        setIsSubmitting(true);
        setSubmitError(null);

        // Map internal form state to the required API payload structure
        const payload = {
            relationship: data.vztah,
            care_recipient_age: parseInt(data.vek, 10) || 0,
            care_recipient_gender: data.pohlavi,
            self_sufficiency: data.sobestacnost,
            has_care_allowance: data.prispevek,
            situation_duration: data.trvani,
            living_arrangement: data.bydleni,
            postal_code: data.psc,
            additional_help: data.pomoc,
            employment_status: data.prace,
            main_concerns: data.trapi,
        };

        // Determine API URL based on environment
        // NOTE: Zde si změň URL adresy podle potřeby!
        let apiUrl = 'https://tvuj-produkcni-zapisovy-endpoint.cz/api/data';
        if (typeof window !== 'undefined') {
            const hostname = window.location.hostname;
            if (hostname === 'localhost' || hostname === '127.0.0.1' || hostname === '0.0.0.0' || hostname.startsWith('192.168.')) {
                apiUrl = `http://${hostname}:8001/api/data`;
            }
        }
        apiUrl = process.env.NEXT_PUBLIC_API_URL || apiUrl;

        try {
            const response = await fetch(apiUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(payload),
            });

            console.log('Response Status:', response.status);

            const responseData = await response.json().catch(() => null);
            console.log('Response Data:', responseData);

            if (!response.ok) {
                throw new Error(`Nepodařilo se odeslat data. Status: ${response.status}`);
            }

            setResponseData(responseData);
            setIsSubmitted(true);
        } catch (error) {
            console.error('Chyba při odesílání formuláře:', error);
            setSubmitError('Při odesílání formuláře došlo k chybě. Zkuste to prosím znovu.');
        } finally {
            setIsSubmitting(false);
        }
    };

    const nextStep = () => {
        if (step < STEPS.length) {
            setStep(step + 1);
            setSubmitError(null);
        } else {
            submitForm();
        }
    };

    const prevStep = () => {
        if (step > 1) setStep(step - 1);
    };

    const canProceed = () => {
        switch (step) {
            case 1:
                return data.vztah && data.vek && data.pohlavi;
            case 2:
                return data.sobestacnost && data.prispevek && data.trvani;
            case 3:
                return data.bydleni && data.psc;
            case 4:
                return data.prace && data.trapi.length > 0;
            default:
                return false;
        }
    };

    const handleReset = () => {
        setData(initialData);
        setStep(1);
        setIsSubmitted(false);
        setResponseData(null);
    };

    return (
        <div className="min-h-screen bg-slate-50 flex flex-col font-sans text-slate-800 selection:bg-indigo-100 selection:text-indigo-900">
            {/* Header */}
            <Header showStep={!isSubmitted} step={step} isSubmitted={isSubmitted} />

            {/* Main Content */}
            <main className="flex-1 flex flex-col overflow-y-auto px-4 py-8 md:py-12">
                <div className={`mx-auto w-full transition-all duration-500 ease-in-out ${isSubmitted ? 'max-w-4xl' : 'max-w-xl'}`}>
                    {!isSubmitted ? (
                        <div className="bg-white rounded-3xl shadow-sm border border-slate-200/60 overflow-hidden wrap-break-word">
                            {/* Progress Bar */}
                            <div className="w-full bg-slate-100 h-1.5 flex">
                                <div
                                    className="bg-indigo-600 h-1.5 transition-all duration-500 ease-in-out"
                                    style={{ width: `${(step / STEPS.length) * 100}%` }}
                                />
                            </div>

                            <div className="p-6 md:p-10">
                                {/* Step Title Header */}
                                <div className="flex items-start gap-4 mb-8">
                                    <div className="w-12 h-12 rounded-2xl bg-indigo-50 flex items-center justify-center shrink-0">
                                        {(() => {
                                            const Icon = STEPS[step - 1].icon;
                                            return <Icon className="w-6 h-6 text-indigo-600" />;
                                        })()}
                                    </div>
                                    <div>
                                        <h1 className="text-2xl md:text-3xl font-bold text-slate-900 mb-2">
                                            {STEPS[step - 1].title}
                                        </h1>
                                        <p className="text-slate-500">
                                            Vyplňte, abychom vám mohli doporučit nejlepší postup.
                                        </p>
                                    </div>
                                </div>

                                {/* Forms content rendering */}
                                <div className="space-y-8 min-h-[300px]">
                                    {step === 1 && (
                                        <StepOne data={data} updateData={updateData} />
                                    )}
                                    {step === 2 && (
                                        <StepTwo data={data} updateData={updateData} />
                                    )}
                                    {step === 3 && (
                                        <StepThree data={data} updateData={updateData} />
                                    )}
                                    {step === 4 && (
                                        <StepFour data={data} updateData={updateData} />
                                    )}
                                </div>

                                {/* Navigation Buttons */}
                                <div className="mt-10 pt-6 border-t border-slate-100 flex flex-col gap-4">
                                    {submitError && (
                                        <div className="text-red-500 text-sm bg-red-50 p-3 rounded-lg border border-red-100 mb-2">
                                            {submitError}
                                        </div>
                                    )}
                                    <div className="flex items-center justify-between">
                                        <button
                                            onClick={prevStep}
                                            disabled={isSubmitting}
                                            className={`flex items-center justify-center px-4 py-3 rounded-xl font-medium transition-colors ${step === 1 || isSubmitting
                                                ? "invisible"
                                                : "text-slate-600 hover:bg-slate-100"
                                                }`}
                                        >
                                            <ChevronLeft className="w-5 h-5 mr-1" />
                                            Zpět
                                        </button>

                                        <button
                                            onClick={nextStep}
                                            disabled={!canProceed() || isSubmitting}
                                            className={`flex items-center justify-center px-6 py-3 rounded-xl font-medium transition-all ${canProceed() && !isSubmitting
                                                ? "bg-indigo-600 hover:bg-indigo-700 text-white shadow-md shadow-indigo-200"
                                                : "bg-slate-100 text-slate-400 cursor-not-allowed"
                                                }`}
                                        >
                                            {isSubmitting ? (
                                                <>
                                                    <Loader2 className="w-5 h-5 mr-2 animate-spin" />
                                                    Odesílám...
                                                </>
                                            ) : (
                                                <>
                                                    {step === STEPS.length ? "Dokončit" : "Pokračovat"}
                                                    {step < STEPS.length && (
                                                        <ChevronRight className="w-5 h-5 ml-1" />
                                                    )}
                                                </>
                                            )}
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    ) : (
                        /* Submited State - Inline Chat */
                        <div className="animate-in fade-in slide-in-from-bottom-4 duration-500">
                            <ResponseChat data={responseData} onReset={handleReset} />
                        </div>
                    )}
                </div>
            </main>
        </div>
    );
}
