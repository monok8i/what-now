# Backend - Hackujstat 2026

Backend pro systém párování pečovatelských potřeb se sociálními dávkami a službami.

## Architektura

Systém používá přístup s **metadaty a tagováním** (jak bylo navrženo v Gemini chatu):

1. **Databáze** obsahuje záznamy o dávkách/službách s podmínkami v JSONB
2. **Dotazník** od uživatele se parsuje do vyhledávacích kritérií
3. **Matcher** najde relevantní záznamy pomocí PostgreSQL JSONB operátorů

### Struktura projektu

```
backend/
├── src/
│   ├── api/
│   │   ├── endpoints/
│   │   │   └── data.py          # API endpointy
│   │   └── schemas.py            # Pydantic modely
│   ├── infra/
│   │   ├── db/
│   │   │   ├── base.py           # SQLAlchemy Base
│   │   │   ├── models.py         # DB modely
│   │   │   └── session.py        # DB session
│   │   └── services/
│   │       └── questionnaire_service.py  # Business logika
├── init_db.py                     # Inicializace DB + ukázková data
└── main.py                        # FastAPI app
```

## Jak to funguje

### 1. Struktura záznamu v DB

Každý záznam (dávka/služba) má:
- `id`: Unikátní identifikátor
- `category`: Kategorie (`financni_podpora`, `pece_sluzby`, `poradenstvi`, `pracovni_prava`)
- `name`: Název dávky/služby
- `content_text`: Popis
- `conditions`: **JSONB** s podmínkami pro shodu

Příklad `conditions`:
```json
{
  "vek_max": 17,
  "vek_min": 0,
  "stupen_zavislosti": 3,
  "status_zamestnani": "plny_uvazek"
}
```

### 2. Zpracování dotazníku

`QuestionnaireProcessor.parse_questionnaire()` převede JSON z frontendu na vyhledávací kritéria:

**Input** (z dotazníku):
```json
{
  "care_recipient_age": 75,
  "self_sufficiency": "potrebuje_kazdodenne",
  "employment_status": "plny_uvazek",
  "main_concerns": ["prispevky", "skloubeni"]
}
```

**Output** (kritéria pro vyhledávání):
```json
{
  "vek": 75,
  "stupen_zavislosti": 2,
  "status_zamestnani": "plny_uvazek",
  "kategorie_zajmu": ["financni_podpora", "poradenstvi"]
}
```

### 3. Vyhledávání v DB

`BenefitMatcher.find_matching_benefits()` používá PostgreSQL JSONB operátory:

```sql
-- Příklad: Najdi dávky pro 75letou osobu
SELECT * FROM benefit_services
WHERE
  (conditions->>'vek_max' IS NULL OR 75 <= (conditions->>'vek_max')::int)
  AND (conditions->>'vek_min' IS NULL OR 75 >= (conditions->>'vek_min')::int)
  AND (conditions->>'stupen_zavislosti' IS NULL OR '2' = conditions->>'stupen_zavislosti')
```

## Instalace a spuštění

### 1. Nastavení prostředí

```bash
# Vytvoř .env soubor
echo 'DATABASE_URL=postgresql://user:password@localhost:5432/hackujstat' > .env
```

### 2. Instalace závislostí

Pro PostgreSQL support přidej do `pyproject.toml`:

```toml
dependencies = [
    "fastapi[standard]>=0.135.1",
    "uvicorn>=0.41.0",
    "sqlalchemy>=2.0.0",
    "psycopg2-binary>=2.9.9",  # PostgreSQL driver
]
```

Pak:
```bash
uv sync
```

### 3. Inicializace databáze

```bash
# Vytvoř tabulky a přidej ukázková data
python init_db.py
```

### 4. Spuštění serveru

```bash
uvicorn main:create_app --factory --host 0.0.0.0 --port 8001 --reload
```

## API Endpointy

### 1. Analýza dotazníku (bez vyhledávání)

```bash
POST /data/questionnaire/analyze
```

Vrátí extrahovaná kritéria - užitečné pro debugging.

**Response:**
```json
{
  "criteria": {
    "vek": 75,
    "stupen_zavislosti": 2,
    "kategorie_zajmu": ["financni_podpora"]
  },
  "explanation": "Věk pečované osoby: 75 let; Stupeň závislosti: 2; ..."
}
```

### 2. Vyhledání relevantních dávek

```bash
POST /data/questionnaire/search
```

Najde a vrátí relevantní dávky z databáze.

**Response:**
```json
{
  "message": "Nalezeno 3 relevantních dávek a služeb.",
  "submission_id": "uuid...",
  "total_matches": 3,
  "search_criteria": { ... },
  "matching_benefits": [
    {
      "id": "pnp_stupen_3_dospeli",
      "name": "Příspěvek na péči - III. stupeň",
      "category": "financni_podpora",
      "institution": "Úřad práce ČR",
      "content": "Ve III. stupni...",
      "conditions": { ... },
      "relevance_reason": "Věk 75 odpovídá věkovým podmínkám"
    }
  ]
}
```

## Mapování dat

### Stupeň soběstačnosti → Stupeň závislosti

| Frontend value         | Popis                     | DB value (stupen_zavislosti) |
| ---------------------- | ------------------------- | ---------------------------- |
| `zvlada_vetsinu`       | Zvládá většinu věcí sám   | `1`                          |
| `potrebuje_kazdodenne` | Potřebuje pomoc každý den | `2`                          |
| `plne_zavisly`         | Je plně závislý           | `3`                          |

### Hlavní obavy → Kategorie

| Frontend value    | DB kategorie       |
| ----------------- | ------------------ |
| `prispevky`       | `financni_podpora` |
| `prakticka_pomoc` | `pece_sluzby`      |
| `finance`         | `financni_podpora` |
| `volno_z_prace`   | `pracovni_prava`   |
| `komunikace`      | `poradenstvi`      |
| `skloubeni`       | `poradenstvi`      |

## Rozšiřování databáze

Pro přidání nové dávky:

```python
from src.infra.db.session import SessionLocal
from src.infra.db.models import BenefitService

db = SessionLocal()

nova_davka = BenefitService(
    id="unikatni_id",
    category="financni_podpora",
    institution="Ministerstvo práce",
    name="Nová dávka",
    content_text="Popis dávky...",
    conditions={
        "vek_max": 65,
        "stupen_zavislosti": 2,
        # ... další podmínky
    },
    next_steps=["krok1", "krok2"]
)

db.add(nova_davka)
db.commit()
```
