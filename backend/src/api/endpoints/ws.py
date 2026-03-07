"""
WebSocket endpoint for real-time chat communication with AI assistant.

This module implements the main chat logic of the application. It receives messages from users
via WebSocket, searches for relevant information in the database and on the internet,
and generates responses using AI models with conversation memory.

Message processing flow:
1. Receive message from user via WebSocket
2. Optimize query using smaller AI model (Gemini Flash)
3. Search relevant documents in vector database
4. Supplement with current information from the internet (DuckDuckGo)
5. Generate response using main AI model with context and history
6. Send response back to client
"""

import contextlib

from fastapi import APIRouter, WebSocket

from src.infra.ai.prompt import additional_context_from_md
from src.api.schemas import MatchingBenefitsResponse
from src.infra.ai.request import call_openrouter_chat

# Router for WebSocket endpoints with /ws prefix
router = APIRouter(prefix="/ws")

# System prompt for main assistant
# Defines AI behavior, response style and source formatting
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
    WebSocket endpoint for interactive chat with AI assistant.

    This endpoint maintains a persistent connection with the client and processes
    messages in real-time. Each WebSocket connection maintains a separate
    conversation history that enables contextual responses.

    Main functions:
    - Receive and process messages from user
    - Optimize queries for better search
    - Combine data from database and internet
    - Generate responses with conversation memory
    - Automatic history trimming for memory efficiency

    Args:
        websocket: WebSocket connection with client

    Raises:
        Exception: Any error during processing is caught,
                   logged and sent to the client

    Note:
        - History is limited to last 20 messages (10 exchanges)
        - Gemini Flash is used for optimization (fast and cheap)
        - Main model from config is used for responses
        - Always combines data from DB and web for better coverage
    """
    # Accept WebSocket connection
    await websocket.accept()

    # Conversation history specific to this WebSocket connection
    # Each connection has its own history to separate different users
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

            # STEP 1: Optimize search query
            # Use fast Gemini Flash model to reformulate the query
            # This gives us better keywords for vector search
            # We don't need the full history - just the current query

            metadata: MatchingBenefitsResponse = websocket.app.state.chat_metadata
            additional_context = additional_context_from_md()
            try:
                answer = await call_openrouter_chat(
                    f"{metadata.model_dump()}\n{user_message}",
                    conversation_history=conversation_history,  # Pass history for context
                    # system_prompt=MAIN_ASSISTANT_PROMPT,  # Defines AI behavior
                    max_tokens=2048,  # Reasonable limit for response
                    additional_context=additional_context,
                )
                print(f"✅ Got answer from AI: {answer[:100]}...")
            except Exception as e:
                print(f"❌ Error calling AI model: {e}")
                answer = (
                    f"Sorry, an error occurred while processing the query: {str(e)}"
                )

            # STEP 5: Save to conversation history
            # Save ORIGINAL messages, not messages with context
            # This ensures the history remains readable and relevant
            conversation_history.append({"role": "user", "content": user_message})
            conversation_history.append({"role": "assistant", "content": answer})

            print(
                f"💾 Saved to history. New history size: {len(conversation_history)} messages"
            )

            # STEP 6: Limit history size
            # Keep only last 20 messages (10 exchanges) to avoid context overflow
            # Most AI models have a limit on the number of tokens in context
            if len(conversation_history) > 20:
                conversation_history = conversation_history[-20:]
                print("✂️ Trimmed history to 20 messages")

            websocket.app.state.chat_conversaion_history = conversation_history

            # STEP 7: Send response to client
            print("📤 Sending response via WebSocket...")
            try:
                await websocket.send_json({"message": answer, "typing": False})
            except Exception as e:
                print(f"❌ Error sending WebSocket response: {e}")
                raise

    except Exception as e:
        # Global exception handler for WebSocket
        import traceback

        print(f"❌ WebSocket error: {e}")
        print(f"📋 Traceback:\n{traceback.format_exc()}")

        with contextlib.suppress():
            await websocket.send_json(
                {
                    "message": f"An error occurred: {str(e)}",
                    "typing": False,
                    "error": True,
                }
            )

        # Close connection with error code
        with contextlib.suppress():
            await websocket.close(code=1011)  # 1011 = Internal error
