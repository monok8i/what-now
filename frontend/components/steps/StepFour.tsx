import { FormData } from "@/types/form";
import { SelectableCard } from "@/components/ui/SelectableCard";
import { CheckboxCard } from "@/components/ui/CheckboxCard";

export function StepFour({
    data,
    updateData,
}: {
    data: FormData;
    updateData: (d: Partial<FormData>) => void;
}) {
    const toggleTrapi = (val: string) => {
        if (data.trapi.includes(val)) {
            updateData({ trapi: data.trapi.filter((item) => item !== val) });
        } else {
            if (data.trapi.length < 2) {
                updateData({ trapi: [...data.trapi, val] });
            }
        }
    };

    const praceOpts = ["Plný úvazek", "Částečný úvazek", "OSVČ", "Nepracuji"];
    const trapiOpts = [
        "Nevím jaké příspěvky nám náleží",
        "Nevím koho zavolat pro praktickou pomoc",
        "Nevím jak to finančně zvládneme",
        "Nevím jak si zařídit volno z práce",
        "Nevím jak o tom mluvit s blízkým",
        "Nevím jak to skloubit se svým životem",
    ];

    return (
        <div className="space-y-8 slide-in">
            <div className="space-y-3">
                <label className="block font-semibold text-slate-900">Pracuješ?</label>
                <div className="grid grid-cols-2 gap-3">
                    {praceOpts.map((opt) => (
                        <SelectableCard
                            key={opt}
                            label={opt}
                            selected={data.prace === opt}
                            onClick={() => updateData({ prace: opt })}
                        />
                    ))}
                </div>
            </div>

            <div className="space-y-3">
                <div className="flex justify-between items-end mb-1">
                    <label className="block font-semibold text-slate-900">
                        Co tě teď nejvíc trápí?
                    </label>
                    <span className="text-sm font-medium text-slate-500">
                        {data.trapi.length}/2
                    </span>
                </div>
                <p className="text-sm text-slate-500 mb-4">Vyberte maximálně 2 možnosti</p>

                <div className="flex flex-col gap-3">
                    {trapiOpts.map((opt) => {
                        const isChecked = data.trapi.includes(opt);
                        const isDisabled = !isChecked && data.trapi.length >= 2;
                        return (
                            <CheckboxCard
                                key={opt}
                                label={opt}
                                checked={isChecked}
                                onChange={() => toggleTrapi(opt)}
                                disabled={isDisabled}
                            />
                        );
                    })}
                </div>
            </div>
        </div>
    );
}
