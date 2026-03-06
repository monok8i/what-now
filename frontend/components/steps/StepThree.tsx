import { FormData } from "@/types/form";
import { SelectableCard } from "@/components/ui/SelectableCard";
import { CheckboxCard } from "@/components/ui/CheckboxCard";

export function StepThree({
    data,
    updateData,
}: {
    data: FormData;
    updateData: (d: Partial<FormData>) => void;
}) {
    const togglePomoc = (val: string) => {
        if (data.pomoc.includes(val)) {
            updateData({ pomoc: data.pomoc.filter((item) => item !== val) });
        } else {
            updateData({ pomoc: [...data.pomoc, val] });
        }
    };

    const bydleniOpts = [
        "U mě doma",
        "Sama – jsme ve stejném městě",
        "Sama – jsme daleko",
    ];
    const pomocOpts = [
        "Sourozenec nebo jiný příbuzný",
        "Partner/ka",
        "Nikdo zatím nepomáhá",
        "Již využíváme pečovatelskou službu",
    ];

    return (
        <div className="space-y-8 slide-in">
            <div className="space-y-3">
                <label className="block font-semibold text-slate-900">
                    Kde pečovaná osoba bydlí?
                </label>
                <div className="flex flex-col gap-3">
                    {bydleniOpts.map((opt) => (
                        <SelectableCard
                            key={opt}
                            label={opt}
                            selected={data.bydleni === opt}
                            onClick={() => updateData({ bydleni: opt })}
                            className="justify-start px-5"
                        />
                    ))}
                </div>
            </div>

            <div className="space-y-3">
                <label className="block font-semibold text-slate-900">
                    PSČ bydliště pečované osoby
                </label>
                <input
                    type="text"
                    value={data.psc}
                    onChange={(e) => updateData({ psc: e.target.value })}
                    placeholder="např. 110 00"
                    className="w-full max-w-[200px] px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 outline-none transition-all placeholder:text-slate-400"
                />
                <p className="text-sm text-slate-500 mt-2">
                    Použijeme pro nalezení služeb ve vašem okolí
                </p>
            </div>

            <div className="space-y-3">
                <label className="block font-semibold text-slate-900 mb-1">
                    Pomáhá ti někdo další? (vyberte všechny platné)
                </label>
                <div className="flex flex-col gap-3">
                    {pomocOpts.map((opt) => (
                        <CheckboxCard
                            key={opt}
                            label={opt}
                            checked={data.pomoc.includes(opt)}
                            onChange={() => togglePomoc(opt)}
                        />
                    ))}
                </div>
            </div>
        </div>
    );
}
