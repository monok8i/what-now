"""
WebSocket endpoint pro real-time chat komunikaci s AI asistentem.

Tento modul implementuje hlavní chat logiku aplikace. Přijímá zprávy od uživatele
přes WebSocket, vyhledává relevantní informace v databázi i na internetu,
a generuje odpovědi pomocí AI modelů s pamětí konverzace.

Tok zpracování zprávy:
1. Přijetí zprávy od uživatele přes WebSocket
2. Optimalizace dotazu pomocí menšího AI modelu (Gemini Flash)
3. Vyhledání relevantních dokumentů ve vektorové databázi
4. Doplnění aktuálních informací z internetu (DuckDuckGo)
5. Generování odpovědi pomocí hlavního AI modelu s kontextem a historií
6. Odeslání odpovědi zpět klientovi
"""

import contextlib

from fastapi import APIRouter, WebSocket

from src.api.schemas import MatchingBenefitsResponse
from src.infra.ai.request import call_openrouter_chat

# Router pro WebSocket endpointy s prefixem /ws
router = APIRouter(prefix="/ws")

# System prompt pro hlavního asistenta
# Definuje chování AI, styl odpovědí a formátování zdrojů
MAIN_ASSISTANT_PROMPT = """Jsi užitečný AI asistent pro vyhledávání a analýzu úředních dokumentů několika měst a obecných informací z internetu.

Tvoje úkoly:
- Odpovídat na dotazy uživatelů na základě poskytnutého kontextu z databáze nebo z internetu
- Být přesný a faktický - vždy vycházet z poskytnutých dokumentů nebo informací
- Pokud používáš informace z databáze, upřímně to přiznat a uvést zdroje
- Pokud používáš informace z internetu, také to přiznat a odkázat na zdroje
- Odpovídat česky, jasně a srozumitelně
- **DŮLEŽITÉ: Vždy uvádět zdroje informací!** Když odpovídáš na dotaz, na konci odpovědi přidej sekci "📚 Zdroje:" a vypiš všechny relevantní dokumenty s jejich URL odkazy, názvy a ID
- Pokud jsou k dispozici URL odkazy na dokumenty, uvádět je v formátu: [Název dokumentu](URL)
- Odkazovat na konkrétní dokumenty podle jejich ID nebo názvu
- Pokud používáš informace z internetového vyhledávání, uvádět zdroje ve formátu: [Název stránky](URL)

Formát odpovědi:
1. Nejprve odpověz na dotaz uživatele
2. Na konci přidej oddíl se zdroji ve formátu:

📚 Zdroje:
- [Název dokumentu 1](URL) - ID: xxx
- [Název dokumentu 2](URL) - ID: yyy

nebo pro internetové zdroje:

🌐 Internetové zdroje:
- [Název stránky 1](URL)
- [Název stránky 2](URL)

Pamatuj si kontext celé konverzace a navazuj na předchozí zprávy."""

# System prompt pro optimalizaci vyhledávacího dotazu
# Tento menší model přetvoří uživatelovu zprávu na efektivní vyhledávací dotaz
QUERY_OPTIMIZATION_PROMPT = """Jsi expert na optimalizaci vyhledávacích dotazů pro vektorovou databázi.
Uživatel ti pošle svůj dotaz a ty z něj vytvoříš co nejlepší, jednoduchý a přesný vyhledávací dotaz.

Pravidla:
- Extrahuj klíčová slova a hlavní téma
- Odstraň zbytečná slova
- Zachovej důležité kontextové informace
- Výstup musí být krátký a výstižný (max 1-2 věty)
- Piš česky, pokud je vstup česky

Uživatelův dotaz: """


@router.websocket("/chat")
async def chat_endpoint(websocket: WebSocket):
    """
    WebSocket endpoint pro interaktivní chat s AI asistentem.

    Tento endpoint udržuje perzistentní spojení s klientem a zpracovává
    zprávy v reálném čase. Pro každé WebSocket spojení se udržuje samostatná
    historie konverzace, která umožňuje kontextové odpovědi.

    Hlavní funkce:
    - Příjem a zpracování zpráv od uživatele
    - Optimalizace dotazů pro lepší vyhledávání
    - Kombinace dat z databáze a internetu
    - Generování odpovědí s pamětí konverzace
    - Automatické trimování historie pro úsporu paměti

    Args:
        websocket: WebSocket spojení s klientem

    Raises:
        Exception: Jakákoli chyba během zpracování je zachycena,
                   zalogována a odeslaná klientovi

    Note:
        - Historie je omezena na posledních 20 zpráv (10 výměn)
        - Pro optimalizaci se používá Gemini Flash (rychlý a levný)
        - Pro odpovědi se používá hlavní model z konfigurace
        - Vždy se kombinují data z DB a z webu pro lepší pokrytí
    """
    # Přijmout WebSocket spojení
    await websocket.accept()

    # Historie konverzace specifická pro toto WebSocket spojení
    # Každé spojení má svou vlastní historii pro oddělení různých uživatelů
    conversation_history: list[dict[str, str]] = (
        websocket.app.state.chat_conversaion_history
    )

    print(
        f"🔌 New WebSocket connection established. History size: {len(conversation_history)}"
    )

    try:
        while True:
            message_data = await websocket.receive_json()
            user_message = message_data.get("message", "")

            if not user_message:
                continue

            print(f"📨 Received message: {user_message[:50]}...")
            print(f"📚 Current history size: {len(conversation_history)} messages")

            # KROK 1: Optimalizace vyhledávacího dotazu
            # Použijeme rychlý Gemini Flash model pro přeformulování dotazu
            # Tím získáme lepší klíčová slova pro vektorové vyhledávání
            # Nepotřebujeme celou historii - jen aktuální dotaz

            metadata: MatchingBenefitsResponse = websocket.app.state.chat_metadata

            try:
                answer = await call_openrouter_chat(
                    f"{metadata.model_dump()}\n{user_message}",
                    conversation_history=conversation_history,  # Předáme historii pro kontext
                    # system_prompt=MAIN_ASSISTANT_PROMPT,  # Definuje chování AI
                    max_tokens=2048,  # Rozumný limit pro odpověď
                )
                print(f"✅ Got answer from AI: {answer[:100]}...")
            except Exception as e:
                print(f"❌ Error calling AI model: {e}")
                answer = f"Omlouvám se, došlo k chybě při zpracování dotazu: {str(e)}"

            # KROK 5: Uložení do historie konverzace
            # Ukládáme PŮVODNÍ zprávy, ne zprávy s kontextem
            # To zajišťuje, že historie zůstává čitelná a relevantní
            conversation_history.append({"role": "user", "content": user_message})
            conversation_history.append({"role": "assistant", "content": answer})

            print(
                f"💾 Saved to history. New history size: {len(conversation_history)} messages"
            )

            # KROK 6: Omezení velikosti historie
            # Ponecháme pouze posledních 20 zpráv (10 výměn) aby nepřetekl kontext
            # Většina AI modelů má limit na počet tokenů v kontextu
            if len(conversation_history) > 20:
                conversation_history = conversation_history[-20:]
                print("✂️ Trimmed history to 20 messages")

            websocket.app.state.chat_conversaion_history = conversation_history

            # KROK 7: Odeslání odpovědi klientovi
            print("📤 Sending response via WebSocket...")
            try:
                await websocket.send_json({"message": answer, "typing": False})
            except Exception as e:
                print(f"❌ Error sending WebSocket response: {e}")
                raise

    except Exception as e:
        # Globální exception handler pro WebSocket
        import traceback

        print(f"❌ WebSocket error: {e}")
        print(f"📋 Traceback:\n{traceback.format_exc()}")

        with contextlib.suppress():
            await websocket.send_json(
                {"message": f"Došlo k chybě: {str(e)}", "typing": False, "error": True}
            )

        # Uzavřeme spojení s error kódem
        with contextlib.suppress():
            await websocket.close(code=1011)  # 1011 = Internal error
