# Modul 12 – Volumes & Netzwerke

## Ziel des Moduls

Daten mit Docker-Volumes persistieren und Container über Docker-Netzwerke verbinden.

## Warum ist das wichtig?

Container sind ephemer — wenn du einen entfernst, sind alle Daten darin weg. Volumes lösen dieses Problem. Netzwerke ermöglichen es Containern, miteinander zu kommunizieren, ohne Ports an den Host freizugeben. Beides ist essenziell für den Betrieb von Multi-Service-Anwendungen.

## Kernkonzepte

### Bind Mounts vs. Named Volumes

| | Bind Mount | Named Volume |
|---|---|---|
| Pfad auf Host | Du kontrollierst (absoluter Pfad) | Docker verwaltet (`/var/lib/docker/volumes/`) |
| Syntax | `-v /host/pfad:/container/pfad` | `-v meinvolume:/container/pfad` |
| Anwendungsfall | Dev: Quellcode teilen | Prod: Datenbankdaten persistieren |
| Portabilität | Host-spezifisch | Portabel über Umgebungen |

### Bind Mounts

Ein Host-Verzeichnis in den Container einbinden:

```bash
# Aktuelles Verzeichnis als /app im Container einbinden
docker run -v $(pwd):/app node:20-alpine node /app/server.js

# Bestimmtes Verzeichnis einbinden (schreibgeschützt)
docker run -v /host/config:/etc/app:ro myapp
```

### Named Volumes

```bash
# Volume erstellen
docker volume create meinedaten

# In einem Container verwenden
docker run -v meinedaten:/var/lib/postgresql/data postgres:16

# Volumes auflisten
docker volume ls

# Volume inspizieren
docker volume inspect meinedaten

# Nicht verwendete Volumes entfernen
docker volume prune
```

### Docker-Netzwerke

Container im selben Netzwerk können sich gegenseitig per **Container-Name** erreichen:

```bash
# Netzwerk erstellen
docker network create meinnetz

# Zwei Container im selben Netzwerk starten
docker run -d --name db --network meinnetz postgres:16
docker run -d --name app --network meinnetz myapp

# Innerhalb von 'app' kann 'db' per Name erreicht werden:
# psql -h db -U user mydb
```

### Netzwerk-Typen

| Typ | Beschreibung |
|-----|-------------|
| `bridge` (Standard) | Isoliertes privates Netzwerk; Container kommunizieren per Name |
| `host` | Teilt den Netzwerk-Stack des Hosts (keine Isolation) |
| `none` | Kein Netzwerk |

```bash
docker network ls           # alle Netzwerke auflisten
docker network inspect meinnetz  # detaillierte Infos
docker network rm meinnetz  # Netzwerk entfernen
```

## Praxisaufgabe

1. Benanntes Volume `pgdata` erstellen
2. PostgreSQL-Container mit diesem Volume starten
3. Eigenes Netzwerk `appnet` erstellen
4. Zweiten Container im selben Netzwerk starten
5. Prüfen, ob die Container sich gegenseitig erreichen können

## Beispiel-Kommandos

```bash
# Benanntes Volume erstellen
docker volume create pgdata

# Postgres mit benanntem Volume starten
docker run -d \
  --name postgres \
  --network appnet \
  -e POSTGRES_PASSWORD=secret \
  -v pgdata:/var/lib/postgresql/data \
  postgres:16-alpine

# Erwartete Ausgabe: lange Container-ID

# Volumes auflisten
docker volume ls
# Erwartete Ausgabe:
# DRIVER    VOLUME NAME
# local     pgdata

# Netzwerk inspizieren
docker network inspect appnet

# Container-zu-Container-Konnektivität testen
docker run --rm --network appnet alpine ping -c 1 postgres
# Erwartete Ausgabe:
# PING postgres (172.18.0.2): 56 data bytes
# 64 bytes from 172.18.0.2: seq=0 ttl=64 time=0.123 ms
```

## Typische Fehler

- **Bind Mounts für Datenbankdaten verwenden** — Berechtigungs- und Leistungsprobleme; Named Volumes für Datenbanken verwenden
- **Kein eigenes Netzwerk erstellen** — Container im Standard-Bridge-Netzwerk können sich nicht per Name erreichen (nur per IP)
- **`docker volume prune` löscht alle ungenutzten Volumes** — einschließlich solcher mit wichtigen Daten; mit Vorsicht verwenden

> [!WARNING]
> `docker volume prune` löscht permanent alle Volumes, die an keinen laufenden Container angehängt sind. Das schließt Datenbankdaten ein. Mit Vorsicht verwenden.

## Checkpoint

- [ ] Ich verstehe den Unterschied zwischen Bind Mounts und Named Volumes
- [ ] Ich kann Named Volumes erstellen und verwenden
- [ ] Ich kann ein Docker-Netzwerk erstellen und Container damit verbinden
- [ ] Container im selben Netzwerk können sich per Name erreichen

## Definition of Done

Du kannst einen Datenbank-Container mit persistenten Daten betreiben, und ein zweiter Container kann sich per Name über ein Docker-Netzwerk damit verbinden.

## Weiterführende Links

- [docker volume Dokumentation](https://docs.docker.com/storage/volumes/)
- [docker network Dokumentation](https://docs.docker.com/network/)
