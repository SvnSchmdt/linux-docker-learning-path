# Lab 05 – Custom Image bauen

## Was du baust

Du wirst ein Dockerfile für den mitgelieferten Python-Web-Server schreiben, das Image bauen, starten und mit `curl` testen. Dann wirst du das Image für eine Registry taggen.

**Verwendete Konzepte:** Dockerfile, `docker build`, `docker run`, `docker tag`, Layer-Caching, `.dockerignore`.

```
docs/labs/05-custom-image/
├── app/
│   └── app.py        ← Python-Web-Server (mitgeliefert)
└── Dockerfile        ← das schreibst du
```

```
Build                       Run
──────────────────────     ──────────────────────
app.py + Dockerfile  →     Image → Container
                                 ↓
                           curl :8080      → "Hello from Docker!"
                           curl :8080/health → {"status": "ok"}
```

## Ziel

Ein Docker-Image aus einer Python-App bauen, starten und prüfen, ob es auf HTTP-Anfragen antwortet.

## Voraussetzungen

- Docker Desktop läuft
- Modul 10 abgeschlossen

## Schritt-für-Schritt

### Schritt 1: Ins Lab-Verzeichnis wechseln

```bash
cd docs/labs/05-custom-image
ls app/
# Erwartete Ausgabe:
# app.py
```

### Schritt 2: .dockerignore erstellen

```bash
cat > .dockerignore << 'EOF'
__pycache__/
*.pyc
.env
.DS_Store
EOF
```

### Schritt 3: Dockerfile schreiben

```bash
cat > Dockerfile << 'EOF'
FROM python:3.12-slim
WORKDIR /app
COPY app/app.py .
ENV PORT=8080
EXPOSE 8080
CMD ["python", "app.py"]
EOF
```

### Schritt 4: Image bauen

```bash
docker build -t myapp:v1 .
# Erwartete Ausgabe:
# [+] Building 8.2s (7/7) FINISHED
#  => [internal] load build definition from Dockerfile
#  => [1/3] FROM python:3.12-slim
#  => [2/3] WORKDIR /app
#  => [3/3] COPY app/app.py .
#  => exporting to image
```

### Schritt 5: Image-Größe prüfen

```bash
docker images myapp:v1
# Erwartete Ausgabe:
# REPOSITORY   TAG   IMAGE ID       CREATED        SIZE
# myapp        v1    a1b2c3d4e5f6   5 Sek. ago    151MB
```

### Schritt 6: Container starten

```bash
docker run -d --name myapp -p 8080:8080 myapp:v1
```

### Schritt 7: App testen

```bash
curl http://localhost:8080
# Erwartete Ausgabe:
# Hello from Docker!

curl http://localhost:8080/health
# Erwartete Ausgabe:
# {"status": "ok"}
```

### Schritt 8: Logs prüfen

```bash
docker logs myapp
# Erwartete Ausgabe:
# Listening on port 8080
# 172.17.0.1 - GET / 200
# 172.17.0.1 - GET /health 200
```

### Schritt 9: Für Registry taggen

```bash
docker tag myapp:v1 myapp:latest
# Falls du ein Docker-Hub-Konto hast:
# docker tag myapp:v1 DEIN_USER/myapp:v1
```

## Validierung

```bash
curl -s http://localhost:8080/health | grep -q "ok" && echo "Health Check OK"
docker ps --filter "name=myapp" --format "{{.Status}}" | grep -q "Up" && echo "Container läuft"
```

## Cleanup

```bash
docker stop myapp && docker rm myapp
docker rmi myapp:v1 myapp:latest
```

## Erweiterungsaufgabe

Mit `python:3.12-alpine` als Basis-Image neu bauen und Größen vergleichen:

```bash
# Dockerfile bearbeiten: python:3.12-slim → python:3.12-alpine ändern
docker build -t myapp:v2-alpine .
docker images | grep myapp
```
