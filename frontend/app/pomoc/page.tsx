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
        const apiUrl = process.env.NODE_ENV === 'production'
            ? 'https://tvuj-produkcni-zapisovy-endpoint.cz/api/data'
            : 'http://localhost:8001/api/data';

        try {
            const response = await fetch(apiUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(payload),
            });

            if (!response.ok) {
                throw new Error('Nepodařilo se odeslat data.');
            }

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

    return (
        <div className="min-h-screen bg-slate-50 flex flex-col font-sans text-slate-800 selection:bg-indigo-100 selection:text-indigo-900">
            {/* Header */}
            <Header showStep={true} step={step} isSubmitted={isSubmitted} />

            {/* Main Content */}
            <main className="flex-1 flex flex-col overflow-y-auto px-4 py-8 md:py-12">
                <div className="max-w-xl mx-auto w-full">
                    {!isSubmitted ? (
                        <div className="bg-white rounded-3xl shadow-sm border border-slate-200/60 overflow-hidden break-words">
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
                        /* Success State */
                        <div className="bg-white rounded-3xl shadow-sm border border-slate-200 p-8 md:p-12 text-center">
                            <div className="w-20 h-20 bg-green-50 rounded-full flex items-center justify-center mx-auto mb-6">
                                <CheckCircle2 className="w-10 h-10 text-green-500" />
                            </div>
                            <h2 className="text-3xl font-bold text-slate-900 mb-4">
                                Děkujeme za informace
                            </h2>
                            <p className="text-slate-600 text-lg mb-8 max-w-sm mx-auto">
                                Hledáme pro vás personalizovaný plán pomoci. Na základě vašich
                                odpovědí připravujeme návrh dalších kroků.
                            </p>
                            <button
                                onClick={() => {
                                    setData(initialData);
                                    setStep(1);
                                    setIsSubmitted(false);
                                }}
                                className="inline-flex items-center justify-center px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl font-medium transition-colors shadow-sm"
                            >
                                Vyplnit znovu
                            </button>
                        </div>
                    )}
                </div>
            </main >
        </div >
    );
}
