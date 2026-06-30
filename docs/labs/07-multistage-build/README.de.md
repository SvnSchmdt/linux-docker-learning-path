# Lab 07 – Multi-Stage Build

## Was du baust

Du nimmst die App aus Lab 05 und baust eine produktionsgehärtete Version: Multi-Stage Build, Alpine-Basis-Image, Non-Root-User und einen Healthcheck. Dann vergleichst du die Image-Größen.

**Verwendete Konzepte:** Multi-Stage Dockerfile, `python:3.12-alpine`, Non-Root-User, `HEALTHCHECK`, `--from=builder`, `docker scout`.

```
Stage 1: builder           Stage 2: runtime
──────────────────         ──────────────────────
python:3.12-slim     →     python:3.12-alpine
  Abhängigkeiten            nur das Nötige kopieren
  installieren              Non-Root-User: appuser
  (mit pip + gcc)           HEALTHCHECK
                            kleiner + sicherer
```

## Ziel

Ein Multi-Stage Docker-Image bauen, das deutlich kleiner und sicherer als die Single-Stage-Version ist.

## Voraussetzungen

- Lab 05 abgeschlossen (Single-Stage-Builds verstehen)
- Modul 15 abgeschlossen

## Schritt-für-Schritt

### Schritt 1: Ins Lab-Verzeichnis wechseln

```bash
cd docs/labs/07-multistage-build
ls app/
# Erwartete Ausgabe:
# app.py
```

### Schritt 2: Multi-Stage Dockerfile schreiben

```bash
cat > Dockerfile << 'EOF'
# Stage 1: Builder (installiert Abhängigkeiten)
FROM python:3.12-slim AS builder
WORKDIR /build
COPY app/requirements.txt* ./
RUN pip install --no-cache-dir --target /build/packages -r requirements.txt 2>/dev/null || true

# Stage 2: Runtime (minimal, sicher)
FROM python:3.12-alpine AS runtime
WORKDIR /app

# Non-Root-User erstellen
RUN adduser --disabled-password --no-create-home appuser

# App kopieren (keine Build-Werkzeuge, kein pip-Cache)
COPY --chown=appuser:appuser app/app.py .
# Installierte Pakete aus Builder-Stage kopieren (falls vorhanden)
COPY --from=builder --chown=appuser:appuser /build/packages /usr/local/lib/python3.12/site-packages/

# Healthcheck mit wget (in alpine verfügbar)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:8080/health || exit 1

USER appuser
ENV PORT=8080
EXPOSE 8080
CMD ["python", "app.py"]
EOF
```

### Schritt 3: Produktions-Image bauen

```bash
docker build -t myapp:v2-prod .
# Erwartete Ausgabe:
# [+] Building 18.4s (10/10) FINISHED
#  => [builder 1/3] FROM python:3.12-slim
#  => [runtime 1/4] FROM python:3.12-alpine
#  => [builder 2/3] WORKDIR /build
#  => [runtime 2/4] RUN adduser ...
#  => [runtime 3/4] COPY --chown=appuser:appuser app/app.py .
```

### Schritt 4: Image-Größen vergleichen

```bash
docker images | grep myapp
# Erwartete Ausgabe:
# myapp   v2-prod   ...   ~50MB
# myapp   v1        ...   ~151MB
```

### Schritt 5: Starten und prüfen

```bash
docker run -d --name myapp-prod -p 8080:8080 myapp:v2-prod

curl http://localhost:8080
# Erwartete Ausgabe:
# Hello from a production-ready container!

curl http://localhost:8080/health
# Erwartete Ausgabe:
# {"status": "ok"}
```

### Schritt 6: Non-Root-User prüfen

```bash
docker exec myapp-prod whoami
# Erwartete Ausgabe:
# appuser

docker exec myapp-prod id
# Erwartete Ausgabe:
# uid=1000(appuser) gid=1000(appuser) groups=1000(appuser)
```

### Schritt 7: Healthcheck-Status prüfen

```bash
# 30 Sekunden warten, damit der Healthcheck läuft
sleep 35
docker ps --filter "name=myapp-prod" --format "{{.Status}}"
# Erwartete Ausgabe:
# Up About a minute (healthy)
```

## Validierung

```bash
# Image kleiner als 100 MB
SIZE=$(docker inspect myapp:v2-prod --format='{{.Size}}')
echo "Image-Größe: $((SIZE / 1024 / 1024)) MB"

# Läuft als Non-Root
docker exec myapp-prod whoami | grep -q "appuser" && echo "Non-Root-User OK"

# Health-Endpoint funktioniert
curl -s http://localhost:8080/health | grep -q "ok" && echo "Health Check OK"
```

## Cleanup

```bash
docker stop myapp-prod && docker rm myapp-prod
docker rmi myapp:v2-prod myapp:v1 2>/dev/null || true
```

## Erweiterungsaufgabe

Ein Read-Only-Filesystem hinzufügen:

```bash
docker stop myapp-prod && docker rm myapp-prod
docker run -d --name myapp-ro --read-only -p 8080:8080 myapp:v2-prod
curl http://localhost:8080/health
# Sollte noch funktionieren — die App schreibt nicht auf die Festplatte
```
