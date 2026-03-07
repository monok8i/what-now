import Link from "next/link";
import dynamic from "next/dynamic";
import {
  ArrowRight,
  ClipboardCheck,
  MessageCircleQuestion,
  MapPin,
  ShieldCheck,
  HandHeart,
  Clock
} from "lucide-react";
import { Header } from "@/components/layout/Header";

import MapWrapper from "../src/components/MapWrapper";

export default function Home() {
  return (
    <div className="min-h-screen bg-slate-50 flex flex-col font-sans text-slate-800 selection:bg-indigo-100 selection:text-indigo-900">
      <Header />

      <main className="flex-1 flex flex-col items-center">
        {/* Hero Section */}
        <section id="uvod" className="w-full relative overflow-hidden bg-white border-b border-slate-200 scroll-mt-20">
          <div className="absolute inset-0 bg-indigo-50/50 mask-[linear-gradient(to_bottom,white,transparent)]" />

          <div className="max-w-5xl mx-auto px-4 py-20 md:py-32 relative flex flex-col items-center text-center">
            <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-indigo-100/80 text-indigo-800 text-sm font-medium mb-8">
              <span className="relative flex h-2 w-2">
                <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-indigo-400 opacity-75"></span>
                <span className="relative inline-flex rounded-full h-2 w-2 bg-indigo-500"></span>
              </span>
              Vytvořeno na HackujStát 2026
            </div>

            <h1 className="text-4xl md:text-6xl font-extrabold text-slate-900 tracking-tight leading-tight max-w-4xl mb-6">
              Nejste v tom sami.<br />
              <span className="text-transparent bg-clip-text bg-linear-to-r from-indigo-600 to-purple-600">
                Péče o blízké s lehkostí.
              </span>
            </h1>

            <p className="text-lg md:text-xl text-slate-600 max-w-2xl mb-10 leading-relaxed">
              Když člověk náhle musí začít pečovat o nemohoucího blízkého, často neví, kde začít.
              Naše platforma vás provede labyrintem úřadů, možností podpory a praktické pomoci ve vašem okolí.
            </p>

            <div className="flex flex-col sm:flex-row items-center justify-center gap-4 w-full sm:w-auto">
              <Link
                href="/pomoc"
                className="group w-full sm:w-auto inline-flex items-center justify-center px-8 py-4 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl font-medium text-lg transition-all shadow-lg shadow-indigo-200 hover:shadow-xl hover:shadow-indigo-300 hover:-translate-y-0.5"
              >
                Zjistit možnosti pomoci
                <ArrowRight className="w-5 h-5 ml-2 transition-transform group-hover:translate-x-1" />
              </Link>
              <a
                href="#jak-to-funguje"
                className="w-full sm:w-auto inline-flex items-center justify-center px-8 py-4 bg-white border-2 border-slate-200 hover:border-indigo-300 hover:bg-slate-50 text-slate-700 rounded-xl font-medium text-lg transition-all"
              >
                Jak to funguje?
              </a>
            </div>
          </div>
        </section>

        {/* How it works */}
        <section id="jak-to-funguje" className="w-full bg-slate-50 py-20 px-4 scroll-mt-20">
          <div className="max-w-5xl mx-auto">
            <div className="text-center mb-16">
              <h2 className="text-3xl font-bold text-slate-900 mb-4">Náročné začátky uděláme snazší</h2>
              <p className="text-lg text-slate-600 max-w-2xl mx-auto">
                Stačí tři jednoduché kroky k tomu, abyste získali kompletní plán pro vaši konkrétní životní situaci.
              </p>
            </div>

            <div className="grid md:grid-cols-3 gap-8">
              {/* Step 1 */}
              <div className="bg-white rounded-3xl p-8 border border-slate-200 shadow-sm relative overflow-hidden group hover:shadow-md transition-shadow">
                <div className="w-14 h-14 bg-indigo-100 text-indigo-600 rounded-2xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                  <ClipboardCheck className="w-7 h-7" />
                </div>
                <h3 className="text-xl font-bold text-slate-900 mb-3">1. Zodpovíte pár otázek</h3>
                <p className="text-slate-600 leading-relaxed">
                  Skrze interaktivní dotazník zmapujeme vaši situaci: koho se péče týká, jak je na tom dotyčný zdravotně a co nejvíc trápí vás.
                </p>
                <div className="absolute top-8 right-8 text-8xl font-black text-slate-50/50 select-none pointer-events-none z-0">1</div>
              </div>

              {/* Step 2 */}
              <div className="bg-white rounded-3xl p-8 border border-slate-200 shadow-sm relative overflow-hidden group hover:shadow-md transition-shadow">
                <div className="w-14 h-14 bg-purple-100 text-purple-600 rounded-2xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                  <MessageCircleQuestion className="w-7 h-7" />
                </div>
                <h3 className="text-xl font-bold text-slate-900 mb-3">2. Náš AI asistent poradí</h3>
                <p className="text-slate-600 leading-relaxed">
                  Aplikace vyhodnotí data a v případě potřeby se vás asistent doptá na detaily. Umí to empaticky, s ohledem na vaši náladu.
                </p>
                <div className="absolute top-8 right-8 text-8xl font-black text-slate-50/50 select-none pointer-events-none z-0">2</div>
              </div>

              {/* Step 3 */}
              <div className="bg-white rounded-3xl p-8 border border-slate-200 shadow-sm relative overflow-hidden group hover:shadow-md transition-shadow">
                <div className="w-14 h-14 bg-green-100 text-green-600 rounded-2xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                  <MapPin className="w-7 h-7" />
                </div>
                <h3 className="text-xl font-bold text-slate-900 mb-3">3. Získáte konkrétní plán</h3>
                <p className="text-slate-600 leading-relaxed">
                  Roztřídíme informace a vygenerujeme na míru šitý manuál: státní příspěvky, seznam pečovatelských služeb v okolí i rady na doma.
                </p>
                <div className="absolute top-8 right-8 text-8xl font-black text-slate-50/50 select-none pointer-events-none z-0">3</div>
              </div>
            </div>
          </div>
        </section>

        {/* Benefits/Features */}
        <section id="co-ziskate" className="w-full bg-white py-24 px-4 border-t border-slate-200 scroll-mt-20">
          <div className="max-w-5xl mx-auto flex flex-col md:flex-row gap-16 items-center">
            <div className="w-full md:w-1/2 space-y-6">
              <h2 className="text-3xl font-bold text-slate-900">Co získáte na konci dotazníku?</h2>

              <ul className="space-y-5">
                <li className="flex gap-4">
                  <div className="shrink-0 w-8 h-8 rounded-full bg-green-100 flex items-center justify-center mt-1">
                    <ShieldCheck className="w-5 h-5 text-green-600" />
                  </div>
                  <div>
                    <h4 className="font-bold text-slate-900 text-lg">Finanční kompas</h4>
                    <p className="text-slate-600">Přehled, na jaké příspěvky (např. na péči nebo hmotnou nouzi) má váš blízký nárok a kde o ně žádat.</p>
                  </div>
                </li>
                <li className="flex gap-4">
                  <div className="shrink-0 w-8 h-8 rounded-full bg-amber-100 flex items-center justify-center mt-1">
                    <Clock className="w-5 h-5 text-amber-600" />
                  </div>
                  <div>
                    <h4 className="font-bold text-slate-900 text-lg">Pracovní flexibilita</h4>
                    <p className="text-slate-600">Návod jak řešit zaměstnání – legislativa ohledně volna (dlouhodobé ošetřovné) a úpravy úvazků.</p>
                  </div>
                </li>
                <li className="flex gap-4">
                  <div className="shrink-0 w-8 h-8 rounded-full bg-rose-100 flex items-center justify-center mt-1">
                    <HandHeart className="w-5 h-5 text-rose-600" />
                  </div>
                  <div>
                    <h4 className="font-bold text-slate-900 text-lg">Místní podpora</h4>
                    <p className="text-slate-600">Výpis ověřených pečovatelských služeb, domácí zdravotní péče a odlehčovacích sužeb přímo z vašeho okolí (dle PSČ).</p>
                  </div>
                </li>
              </ul>
            </div>

            <div className="w-full md:w-1/2 bg-slate-50 rounded-3xl p-8 border border-slate-200 relative">
              <div className="absolute -top-6 -left-6 bg-indigo-600 text-white w-24 h-24 rounded-full flex flex-col items-center justify-center shadow-lg -rotate-12">
                <span className="font-bold text-xl">100%</span>
                <span className="text-xs uppercase font-medium tracking-wider">Zdarma</span>
              </div>

              <div className="bg-white rounded-2xl shadow-sm border border-slate-200 p-6 space-y-4">
                <div className="h-4 bg-slate-100 rounded-full w-3/4"></div>
                <div className="h-4 bg-slate-100 rounded-full w-full"></div>
                <div className="h-4 bg-slate-100 rounded-full w-5/6"></div>
                <div className="my-6 py-6 border-y border-slate-100 flex items-center gap-4">
                  <div className="w-12 h-12 bg-indigo-100 rounded-full flex items-center justify-center shrink-0">
                    <MessageCircleQuestion className="w-6 h-6 text-indigo-600" />
                  </div>
                  <div>
                    <div className="font-medium text-slate-900 text-sm">Průvodce Péčí AI</div>
                    <div className="text-slate-500 text-sm">&quot;Zdá se, že řešíte spíše administrativu, mohu rovnou připravit formuláře?&quot;</div>
                  </div>
                </div>
                <div className="h-4 bg-slate-100 rounded-full w-2/3"></div>
                <div className="h-4 bg-slate-100 rounded-full w-4/5"></div>
              </div>
            </div>
          </div>
        </section>

        {/* Map Section */}
        <section id="mapa" className="w-full bg-slate-50 py-24 px-4 border-t border-slate-200 scroll-mt-20">
          <div className="max-w-6xl mx-auto flex flex-col items-center">
            <div className="text-center mb-12">
              <h2 className="text-3xl font-bold text-slate-900 mb-4">Síť pomoci ve vašem okolí</h2>
              <p className="text-lg text-slate-600 max-w-2xl mx-auto">
                Máme rozsáhlou databázi tisíců ověřených poskytovatelů sociálních a zdravotních služeb po celé České republice. Zde je malá ukázka (testovací data).
              </p>
            </div>
            <div className="w-full h-[600px] md:h-[700px] rounded-2xl overflow-hidden shadow-xl border border-slate-200 bg-white relative z-0">
              <div style={{ height: "100%", width: "100%" }}>
                <MapWrapper />
              </div>
            </div>
          </div>
        </section>

        {/* Bottom CTA */}
        <section id="cta" className="w-full bg-slate-900 py-20 px-4 scroll-mt-20">
          <div className="max-w-4xl mx-auto text-center">
            <h2 className="text-3xl font-bold text-white mb-6">Ušetřete si hodiny hledání na internetu</h2>
            <p className="text-slate-300 text-lg mb-10 max-w-2xl mx-auto">
              Získejte jasnou představu o tom, jaké máte možnosti v oblasti sociálních služeb a finančních příspěvků. Odpovězte na pár základních otázek.
            </p>
            <Link
              href="/pomoc"
              className="inline-flex items-center justify-center px-10 py-5 bg-indigo-500 hover:bg-indigo-400 text-white rounded-2xl font-bold text-lg transition-all shadow-lg hover:-translate-y-1"
            >
              Spustit průvodce
              <ArrowRight className="w-6 h-6 ml-2" />
            </Link>
          </div>
        </section>
      </main>

      {/* Basic Footer */}
      <footer className="w-full bg-slate-950 py-8 px-4 text-center text-slate-500 text-sm border-t border-slate-800">
        <div className="max-w-5xl mx-auto flex flex-col md:flex-row justify-between items-center gap-4">
          <div>© 2026 Tým HackujStát. Všechna práva vyhrazena.</div>
          <div className="flex gap-6">
            <a href="#" className="hover:text-slate-300 transition-colors">O projektu</a>
            <a href="#" className="hover:text-slate-300 transition-colors">Ochrana soukromí</a>
            <a href="#" className="hover:text-slate-300 transition-colors">Podmínky použití</a>
          </div>
        </div>
      </footer>
    </div>
  );
}
