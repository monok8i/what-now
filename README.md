# Hackujstat 2026 - Podpora pečujících osob

> **Nejste v tom sami. Péče o blízké s lehkostí.**

Platforma vytvořená během HackujStát 2026, která pomáhá pečujícím osobám orientovat se v systému sociálních dávek a najít podporu ve svém okolí.

## 📋 O projektu

Když člověk náhle musí začít pečovat o nemohoucího blízkého, často neví, kde začít. Naše aplikace poskytuje:

- 🤖 **AI asistenta** pro odpovědi na otázky o sociálních dávkách
- 📝 **Interaktivní dotazník** pro identifikaci nároků na benefity
- 🗺️ **Mapu služeb** - vizualizace dostupných zařízení v okolí
- 📊 **Databázi benefitů** - automaticky aktualizované informace z úředních zdrojů
- 💬 **Real-time chat** - konverzace s AI přes WebSocket

## 🚀 Funkce

### Pro uživatele
- **Dotazník v 4 krocích**: Jednoduchý proces zjištění nároků na dávky a služby
- **AI chat asistent**: Specializovaný na sociální dávky v ČR, region Teplice
- **Mapa poskytovatelů služeb**: Zobrazení nejbližších zařízení sociální péče
- **Personalizované výsledky**: Doporučení založená na konkrétní situaci

### Technické
- **Automatická synchronizace dat**: Denní stahování z ČSSZ, NKOD a RPSS
- **Vector search**: Vyhledávání relevantních benefitů pomocí AI
- **Real-time komunikace**: WebSocket připojení pro okamžité odpovědi
- **Geocoding**: Automatické získávání souřadnic pomocí RUIAN API

## 🛠️ Technologie

### Frontend
- **Next.js 16** - React framework
- **React 19** - UI knihovna
- **TypeScript** - typová bezpečnost
- **Tailwind CSS 4** - styling
- **Leaflet** - interaktivní mapy
- **react-markdown** - rendering Markdown odpovědí

### Backend
- **FastAPI** - async Python framework
- **SQLAlchemy 2.0** - ORM s async support
- **PostgreSQL 16** - relační databáze
- **Alembic** - database migrations
- **APScheduler** - plánování úloh
- **OpenRouter** - AI API integrace (Gemini)

### Infrastructure
- **Docker Compose** - orchestrace kontejnerů
- **asyncpg** - async PostgreSQL driver
- **Uvicorn** - ASGI server

## 📁 Struktura projektu

```
hackujstat-2026/
├── frontend/                 # Next.js aplikace
│   ├── app/                 # App router pages
│   │   ├── page.tsx        # Hlavní stránka
│   │   └── pomoc/          # Dotazník
│   ├── components/          # React komponenty
│   │   ├── steps/          # Kroky dotazníku
│   │   ├── ui/             # UI komponenty (chat, karty)
│   │   └── layout/         # Layout komponenty
│   └── types/              # TypeScript typy
│
├── backend/                 # FastAPI aplikace
│   ├── main.py             # Entry point
│   ├── scheduler.py        # Task scheduler (denní synchronizace)
│   ├── migrations/         # Alembic migrations
│   ├── src/
│   │   ├── api/           # API endpoints
│   │   │   ├── endpoints/
│   │   │   │   ├── ws.py      # WebSocket chat
│   │   │   │   └── data.py    # REST API
│   │   │   └── schemas.py     # Pydantic modely
│   │   ├── config/        # Konfigurace
│   │   └── infra/
│   │       ├── ai/        # OpenRouter client
│   │       ├── db/        # Database modely
│   │       ├── services/  # Business logika
│   │       └── external_api/parse/   # Data parsery
│   │           ├── cssz.py          # ČSSZ downloader
│   │           ├── nkod.py          # NKOD downloader
│   │           └── rpss_sync.py     # RPSS synchronizace
│   └── hackujstat/        # Data processing scripts
│
└── docker-compose.yml      # Docker orchestrace
```

## 📦 Prerekvizity

- **Docker** a **Docker Compose**
- **Git**
- **OpenRouter API key** (pro AI funkce)

## ⚙️ Instalace a spuštění

### 1. Klonování repozitáře

```bash
git clone https://github.com/Apollyus/hackujstat-2026.git
cd hackujstat-2026
```

### 2. Konfigurace backendu

Vytvořte `.env` soubor v `backend/` složce:

```bash
# Database
POSTGRES_USER=backend
POSTGRES_PASSWORD=secret
POSTGRES_HOST=backend-db
POSTGRES_PORT=5432
POSTGRES_DB=hackujstat

# AI (Povinné)
OPENROUTER_API_KEY=sk-or-v1-your-api-key-here
OPENROUTER_AI_MODEL=google/gemini-2.5-flash-lite-preview-09-2025
```

**Získání OpenRouter API klíče:**
1. Zaregistrujte se na [openrouter.ai](https://openrouter.ai)
2. Vytvořte nový API klíč v nastavení
3. Vložte klíč do `.env` souboru

### 3. Build a spuštění

```bash
# Build všech služeb
docker compose build

# Spuštění aplikace
docker compose up frontend backend backend-db scheduler
```

**Dostupné služby:**
- Frontend: http://localhost:3000
- Backend API: http://localhost:8001
- Backend API docs: http://localhost:8001/docs

### 4. Inicializace databáze

Migrace se spustí automaticky při startu backendu. Pro manuální spuštění:

```bash
docker compose exec backend alembic upgrade head
```

### 5. Synchronizace dat (volitelné)

Scheduler automaticky stahuje data denně v 3:00. Pro manuální spuštění:

```bash
# Spustit všechny downloady
docker compose up scheduler

# Nebo jednotlivé scripty
docker compose exec backend python -m src.infra.external_api.parse.rpss_sync
```

## 🔗 API Endpointy

### REST API

```
GET  /data/health              - Health check
POST /data/                    - Vyhledávání benefitů dle dotazníku
GET  /data/services/map        - Data pro mapu služeb
```

### WebSocket

```
WS   /ws/chat                  - Real-time AI chat
```

**Příklad použití WebSocket:**

```javascript
const ws = new WebSocket('ws://localhost:8001/ws/chat');

ws.onopen = () => {
  ws.send(JSON.stringify({
    message: 'Jaký mám nárok na příspěvek na péči?'
  }));
};

ws.onmessage = (event) => {
  const response = JSON.parse(event.data);
  console.log(response);
};
```

## 🗄️ Databázové modely

### BenefitService
Ukládá informace o sociálních dávkách a službách:
- ID, kategorie, instituce, název
- Textový obsah (popis benefitu)
- JSONB podmínky pro matching (věk, závislost, region, atd.)

### ExtractedService
Data z RPSS (Register poskytovatelů sociálních služeb):
- Portal ID, identifikátor
- Adresy s GPS souřadnicemi
- Kontakty, telefony, weby
- Osoby (vedoucí, statutární orgány)
- Organizace

## 🤖 AI Chat asistent

### Funkce asistenta:
- Odpovídá česky na otázky o sociálních dávkách
- Vyhledává v databázi relevantní benefity
- Klade upřesňující otázky
- Formátuje odpovědi v Markdownu
- Pamatuje si kontext konverzace

### Technické detaily:
- Model: Google Gemini 2.5 Flash Lite (přes OpenRouter)
- Optimalizace dotazů pomocí menšího modelu
- Kombinace databázových výsledků a webových zdrojů
- Automatické omezení historie na 20 zpráv

## 📅 Automatická synchronizace dat

Scheduler (`scheduler.py`) spouští denně v 3:00:

1. **ČSSZ download** - data z České správy sociálního zabezpečení
2. **NKOD download** - data z Národního katalogu otevřených dat
3. **RPSS sync** - kompletní synchronizace registru sociálních služeb:
   - Stažení JSON z MPSV portálu
   - Extrakce adres, kontaktů, osob
   - Geocoding přes RUIAN API
   - Upsert do PostgreSQL

## 🧪 Vývoj

### Lokální development bez Dockeru

**Backend:**
```bash
cd backend

# Instalace závislostí (s uv)
uv sync

# Aktivace virtual environment
source .venv/bin/activate

# Spuštění dev serveru
uvicorn main:app --reload --host 0.0.0.0 --port 8001
```

**Frontend:**
```bash
cd frontend

# Instalace závislostí
npm install

# Dev server
npm run dev
```

### Database migrations

```bash
# Vytvořit novou migraci
docker compose exec backend alembic revision --autogenerate -m "popis zmeny"

# Spustit migrace
docker compose exec backend alembic upgrade head

# Rollback
docker compose exec backend alembic downgrade -1
```

## 🐛 Debugging

### Zobrazit logy

```bash
# Všechny služby
docker compose logs -f

# Konkrétní služba
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f scheduler
```

### Restart služby

```bash
docker compose restart backend
```

### Připojení k databázi

```bash
docker compose exec backend-db psql -U backend -d hackujstat
```

## 📝 Poznámky

### Datové zdroje
- **RPSS**: https://data.mpsv.cz/od/soubory/rpss/rpss.json
- **RUIAN API**: Geocoding přes CUZK ArcGIS REST API
- **ČSSZ**: CSV export z portálu ČSSZ
- **NKOD**: SPARQL endpoint národního katalogu

### Omezení
- AI asistent je optimalizován pro region Teplice
- Geocoding omezen na české adresy
- OpenRouter API vyžaduje platný klíč

## 📄 Licence

Projekt vytvořený během HackujStát 2026.

## 👥 Autoři

Tým hackathonu HackujStát 2026

---

**Potřebujete pomoc?** Otevřete issue v repozitáři nebo kontaktujte autory.
