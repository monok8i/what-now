import { FormData } from "@/types/form";
import { SelectableCard } from "@/components/ui/SelectableCard";

export function StepTwo({
    data,
    updateData,
}: {
    data: FormData;
    updateData: (d: Partial<FormData>) => void;
}) {
    const sobestacnostOpts = [
        {
            title: "Zvládá většinu věcí sám",
            desc: "potřebuje jen občasnou pomoc",
        },
        {
            title: "Potřebuje pomoc každý den",
            desc: "s jídlem, hygienou nebo pohybem",
        },
        {
            title: "Je plně závislý",
            desc: "nezvládne nic bez cizí pomoci",
        },
    ];

    return (
        <div className="space-y-8 slide-in">
            <div className="space-y-3">
                <label className="block font-semibold text-slate-900 mb-1">
                    Míra soběstačnosti
                </label>
                <div className="flex flex-col gap-3">
                    {sobestacnostOpts.map((opt) => (
                        <SelectableCard
                            key={opt.title}
                            label={opt.title}
                            description={opt.desc}
                            selected={data.sobestacnost === opt.title}
                            onClick={() => updateData({ sobestacnost: opt.title })}
                            className="flex-col items-start text-left p-4"
                        />
                    ))}
                </div>
            </div>

            <div className="space-y-3">
                <label className="block font-semibold text-slate-900">
                    Má přiznán Příspěvek na péči?
                </label>
                <div className="flex gap-3">
                    {["Ano", "Ne", "Nevím"].map((opt) => (
                        <SelectableCard
                            key={opt}
                            label={opt}
                            selected={data.prispevek === opt}
                            onClick={() => updateData({ prispevek: opt })}
                            className="flex-1"
                        />
                    ))}
                </div>
            </div>

            <div className="space-y-3">
                <label className="block font-semibold text-slate-900">
                    Jak dlouho situace trvá?
                </label>
                <div className="flex flex-col gap-3">
                    {["Stalo se to náhle (nemoc, úraz)", "Zhoršuje se postupně", "Nevím"].map(
                        (opt) => (
                            <SelectableCard
                                key={opt}
                                label={opt}
                                selected={data.trvani === opt}
                                onClick={() => updateData({ trvani: opt })}
                                className="justify-start px-5"
                            />
                        )
                    )}
                </div>
            </div>
        </div>
    );
}
