import { FormData } from "@/types/form";
import { SelectableCard } from "@/components/ui/SelectableCard";

export function StepOne({
    data,
    updateData,
}: {
    data: FormData;
    updateData: (d: Partial<FormData>) => void;
}) {
    return (
        <div className="space-y-6 slide-in">
            <div className="space-y-3">
                <label className="block font-semibold text-slate-900">
                    Vztah k pečované osobě
                </label>
                <div className="grid grid-cols-2 gap-3">
                    {["Rodič", "Partner/ka", "Prarodič", "Jiný"].map((opt) => (
                        <SelectableCard
                            key={opt}
                            label={opt}
                            selected={data.vztah === opt}
                            onClick={() => updateData({ vztah: opt })}
                        />
                    ))}
                </div>
            </div>

            <div className="space-y-3">
                <label className="block font-semibold text-slate-900">
                    Věk pečované osoby
                </label>
                <div className="relative max-w-[200px]">
                    <input
                        type="number"
                        value={data.vek}
                        onChange={(e) => updateData({ vek: e.target.value })}
                        placeholder="např. 75"
                        className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 outline-none transition-all placeholder:text-slate-400"
                    />
                    <span className="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 font-medium">
                        let
                    </span>
                </div>
            </div>

            <div className="space-y-3">
                <label className="block font-semibold text-slate-900">
                    Pohlaví pečované osoby
                </label>
                <div className="flex gap-4 max-w-[300px]">
                    {["Muž", "Žena"].map((opt) => (
                        <SelectableCard
                            key={opt}
                            label={opt}
                            selected={data.pohlavi === opt}
                            onClick={() => updateData({ pohlavi: opt })}
                            className="flex-1"
                        />
                    ))}
                </div>
            </div>
        </div>
    );
}
