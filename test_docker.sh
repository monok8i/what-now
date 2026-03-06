#!/bin/bash

# Zastavení skriptu při chybě
set -e

echo "=== Začíná testování Docker Compose setupu ==="

echo "[1/4] Kontrola syntaxe docker-compose.yml..."
docker compose --env-file backend/.env config > /dev/null
echo "✅ Syntax v pořádku."

echo "[2/4] Zastavování a mazání existujících kontejnerů pro čistý start..."
docker compose --env-file backend/.env down -v || true

echo "[3/4] Sestavování obrazů a spouštění kontejnerů na pozadí..."
# Sestavíme obrazy pro případné změny v Dockerfiles a spustíme
docker compose --env-file backend/.env up -d --build

echo "[4/4] Čekám na náběh služeb..."
sleep 10
docker compose --env-file backend/.env ps

echo "=== Služby by měly běžet ==="
echo "Frontend: http://localhost:3000"
echo "Backend:  http://localhost:8001/docs"
echo ""
echo "Pokud se vyskytnou potíže, prozkoumejte logy pomocí:"
echo "  docker compose logs -f"
echo ""
echo "Pro zastavení prostředí spusťte:"
echo "  docker compose down"
