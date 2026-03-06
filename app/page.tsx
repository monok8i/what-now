import Link from "next/link";
import { HeartPulse, ArrowRight } from "lucide-react";
import { Header } from "@/components/layout/Header";

export default function Home() {
  return (
    <div className="min-h-screen bg-slate-50 flex flex-col font-sans text-slate-800 selection:bg-indigo-100 selection:text-indigo-900">
      <Header />

      <main className="flex-1 flex flex-col items-center justify-center p-4 md:p-8">
        <div className="max-w-xl mx-auto text-center space-y-6">
          <div className="w-20 h-20 bg-indigo-50 rounded-full flex items-center justify-center mx-auto mb-6">
            <HeartPulse className="w-10 h-10 text-indigo-600" />
          </div>
          <h1 className="text-4xl md:text-5xl font-bold text-slate-900 tracking-tight">
            Potřebujete se postarat o blízkého?
          </h1>
          <p className="text-lg md:text-xl text-slate-600">
            Platforma, která vám pomůže s navigací v obtížné životní situaci. Zjistěte, jaké máte možnosti a na koho se obrátit.
          </p>
          <div className="pt-8 flex flex-col sm:flex-row items-center justify-center gap-4">
            <Link
              href="/pomoc"
              className="inline-flex items-center justify-center px-8 py-4 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl font-medium text-lg transition-all shadow-md shadow-indigo-200 w-full sm:w-auto"
            >
              Potřebuji poradit
              <ArrowRight className="w-5 h-5 ml-2" />
            </Link>
          </div>
        </div>
      </main>
    </div>
  );
}
