# Lab 06 – Docker Compose App

## Was du baust

Eine Drei-Service-Anwendung: nginx als Reverse Proxy, ein Python-App-Backend und Redis für persistentes Besucher-Zählen. Alle Services kommunizieren über ein benanntes Docker-Netzwerk.

**Verwendete Konzepte:** `docker-compose.yml`, Services, `depends_on`, `healthcheck`, Named Volumes, Named Networks, nginx-Reverse-Proxy.

```
Internet
    │
    ▼
[nginx:8080]  ←── Reverse Proxy
    │
    ▼
[app:5000]   ←── Python-Backend (zählt Besuche)
    │
    ▼
[redis:6379] ←── persistenter Zähler (Volume: redisdata)
```

## Ziel

Alle drei Services mit einem Befehl starten, Inter-Service-Kommunikation prüfen und sauber herunterfahren.

## Voraussetzungen

- Docker Desktop läuft
- Modul 13 abgeschlossen

## Schritt-für-Schritt

### Schritt 1: Ins Lab-Verzeichnis wechseln

```bash
cd docs/labs/06-docker-compose-app/compose
ls
# Erwartete Ausgabe:
# app.py  docker-compose.yml  nginx.conf
```

### Schritt 2: Redis-Abhängigkeit für den App-Service installieren

Die App benötigt das `redis` Python-Paket. Eine requirements.txt hinzufügen:

```bash
echo "redis==5.0.8" > requirements.txt
```

`docker-compose.yml` aktualisieren — den `app`-Service-Befehl ändern, um zuerst zu installieren:

```yaml
  app:
    image: python:3.12-slim
    working_dir: /app
    volumes:
      - ./app.py:/app/app.py:ro
      - ./requirements.txt:/app/requirements.txt:ro
    command: sh -c "pip install -q -r requirements.txt && python app.py"
```

### Schritt 3: Alle Services starten

```bash
docker compose up -d
# Erwartete Ausgabe:
# [+] Running 4/4
#  ✔ Network lab06-network       Created
#  ✔ Container compose-cache-1   Started
#  ✔ Container compose-app-1     Started
#  ✔ Container compose-web-1     Started
```

### Schritt 4: Service-Status prüfen

```bash
docker compose ps
# Erwartete Ausgabe:
# NAME               IMAGE             STATUS          PORTS
# compose-app-1      python:3.12-slim  Up            
# compose-cache-1    redis:7-alpine    Up (healthy)  
# compose-web-1      nginx:alpine      Up            0.0.0.0:8080->80/tcp
```

### Schritt 5: App testen

```bash
curl http://localhost:8080
# Erwartete Ausgabe:
# Hello from the app service!

curl http://localhost:8080/health
# Erwartete Ausgabe:
# {"status": "ok"}

curl http://localhost:8080/count
# Erwartete Ausgabe:
# {"visits": 1}

curl http://localhost:8080/count
# Erwartete Ausgabe:
# {"visits": 2}
```

### Schritt 6: Logs beobachten

```bash
docker compose logs -f
# Ctrl+C zum Stoppen
```

### Schritt 7: Redis-Persistenz testen

```bash
# Stoppen und neu starten — Besucherzähler sollte erhalten bleiben
docker compose restart cache
curl http://localhost:8080/count
# Erwartete Ausgabe: visits > 2 (Zähler im Volume erhalten)
```

## Validierung

```bash
curl -s http://localhost:8080/health | grep -q '"ok"' && echo "App gesund"
docker compose ps --format "{{.Service}}: {{.Status}}" | grep -v "Exit"
```

## Cleanup

```bash
docker compose down -v
# -v entfernt auch das redisdata-Volume
```

## Erweiterungsaufgabe

Einen vierten Service hinzufügen — einen `adminer`-Container (Datenbank-Admin-UI) auf Port 8081, verbunden mit demselben Netzwerk. Adminer ist eine leichtgewichtige Datenbank-Admin-Oberfläche (`image: adminer`).
