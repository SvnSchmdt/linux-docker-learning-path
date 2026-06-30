# Modul 13 – Docker Compose

## Ziel des Moduls

Multi-Service-Anwendungen mit Docker Compose definieren und betreiben.

## Warum ist das wichtig?

Echte Anwendungen laufen selten als einzelner Container. Eine typische Web-App hat ein Backend, eine Datenbank, vielleicht einen Cache und einen Reverse Proxy. Docker Compose ermöglicht es dir, all das als Code in einer einzigen `docker-compose.yml`-Datei zu definieren — reproduzierbar, versioniert und mit einem Befehl startbar.

## Kernkonzepte

### docker-compose.yml Struktur

```yaml
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    depends_on:
      - app

  app:
    build: .
    environment:
      - DATABASE_URL=postgres://user:pass@db:5432/mydb
    depends_on:
      - db

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: mydb
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:

networks:
  default:
    name: myapp-network
```

### image vs. build

```yaml
services:
  web:
    image: nginx:alpine      # aus Registry pullen

  app:
    build: .                 # aus Dockerfile im aktuellen Verzeichnis bauen
    build:
      context: ./app
      dockerfile: Dockerfile.prod  # Dockerfile angeben
```

### Wichtige Befehle

```bash
docker compose up           # alle Services starten (Vordergrund)
docker compose up -d        # im Hintergrund starten
docker compose down         # Container + Netzwerke stoppen und entfernen
docker compose down -v      # auch Volumes entfernen
docker compose ps           # Service-Status auflisten
docker compose logs         # alle Service-Logs
docker compose logs -f app  # Logs eines Services folgen
docker compose restart app  # einen Service neu starten
docker compose exec app bash # Shell in laufenden Service
docker compose build        # Images neu bauen
docker compose pull         # neueste Images pullen
```

### .env-Dateien

Docker Compose lädt automatisch `.env` aus dem Projektverzeichnis:

```bash
# .env
POSTGRES_PASSWORD=meingeheimespasswort
APP_PORT=8080
```

```yaml
# docker-compose.yml
services:
  db:
    environment:
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
  web:
    ports:
      - "${APP_PORT}:80"
```

> [!IMPORTANT]
> Niemals `.env`-Dateien mit echten Zugangsdaten committen. `.env` zu `.gitignore` hinzufügen und eine `.env.example` mit Dummy-Werten bereitstellen.

### depends_on

`depends_on` steuert die Startreihenfolge, wartet aber **nicht** darauf, dass der Service bereit ist (nur darauf, dass er gestartet wurde):

```yaml
services:
  app:
    depends_on:
      db:
        condition: service_healthy  # wartet darauf, dass HEALTHCHECK erfolgreich ist
```

## Praxisaufgabe

Eine `docker-compose.yml` erstellen mit:
1. Einem nginx-Service auf Port 8080
2. Einem Redis-Service
3. Einem eigenen Netzwerk, das beide verbindet

Dann `docker compose up -d` ausführen, prüfen, ob beide Services laufen, und die nginx-Antwort überprüfen.

## Beispiel

```yaml
# docker-compose.yml
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    networks:
      - appnet

  cache:
    image: redis:7-alpine
    networks:
      - appnet

networks:
  appnet:
```

```bash
docker compose up -d

# Erwartete Ausgabe:
# [+] Running 3/3
#  ✔ Network demo_appnet    Created
#  ✔ Container demo-cache-1 Started
#  ✔ Container demo-web-1   Started

docker compose ps
# Erwartete Ausgabe:
# NAME            IMAGE          STATUS    PORTS
# demo-cache-1    redis:7-alpine Running
# demo-web-1      nginx:alpine   Running   0.0.0.0:8080->80/tcp

docker compose down
```

## Typische Fehler

- **`.env` mit echten Secrets committen** — `.env.example` für Vorlagen verwenden
- **`depends_on` bedeutet nicht "bereit"** — der abhängige Service nimmt möglicherweise noch keine Verbindungen an; Healthchecks verwenden
- **`docker compose down -v` löscht Volumes** — Datenbankdaten sind weg; `-v` weglassen, außer du willst einen Clean Reset

## Checkpoint

- [ ] Ich kann eine `docker-compose.yml` mit mehreren Services schreiben
- [ ] Ich kann `docker compose up -d` und `docker compose down` verwenden
- [ ] Ich verstehe, wie `.env`-Dateien mit Compose funktionieren
- [ ] Ich kenne den Unterschied zwischen `depends_on` und einem echten Healthcheck

## Definition of Done

Du kannst eine Multi-Service-Anwendung mit einem einzigen `docker compose up -d` starten und sauber mit `docker compose down` herunterfahren.

## Weiterführende Links

- [Compose-Datei-Referenz](https://docs.docker.com/compose/compose-file/)
- [docker compose CLI-Referenz](https://docs.docker.com/compose/reference/)
