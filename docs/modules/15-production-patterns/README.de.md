# Modul 15 – Production Patterns

## Ziel des Moduls

Sicherheits- und Effizienz-Patterns für produktionsreife Docker-Images anwenden.

## Warum ist das wichtig?

Ein Dockerfile, das lokal funktioniert, ist nicht unbedingt produktionsreif. Produktions-Images müssen klein sein (schnelleres Pullen, kleinere Angriffsfläche), sicher (kein Root, keine unnötigen Pakete) und beobachtbar (Healthchecks) sein. Diese Patterns sind Standard in professionellen Container-Workflows.

## Kernkonzepte

### Multi-Stage Builds

In einer Stage bauen, nur das Ergebnis in das finale Image kopieren:

```dockerfile
# Stage 1: Builder
FROM node:20-alpine AS builder
WORKDIR /build
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Runtime (keine Build-Werkzeuge, kein Quellcode)
FROM node:20-alpine AS runtime
WORKDIR /app
COPY --from=builder /build/dist ./dist
COPY --from=builder /build/node_modules ./node_modules
EXPOSE 3000
CMD ["node", "dist/server.js"]
```

Das Runtime-Image enthält keine Build-Werkzeuge, keinen Quellcode, keine Dev-Abhängigkeiten — viel kleiner und sicherer.

### Minimale Basis-Images

| Basis-Image | Typische Größe | Anwendungsfall |
|-------------|----------------|----------------|
| `ubuntu:24.04` | ~78 MB | Allgemein |
| `debian:bookworm-slim` | ~75 MB | Debian-basierte Apps |
| `python:3.12-slim` | ~130 MB | Python-Apps |
| `python:3.12-alpine` | ~23 MB | Python (ohne glibc) |
| `node:20-alpine` | ~140 MB | Node.js-Apps |
| `gcr.io/distroless/python3` | ~50 MB | Python (ohne Shell) |
| `scratch` | 0 MB | Nur statische Binaries |

Alpine-basierte Images verwenden musl libc statt glibc — mit den meisten Apps kompatibel, aber bei nativen Erweiterungen prüfen.

### Non-Root User

Anwendungsprozesse niemals als Root innerhalb eines Containers ausführen:

```dockerfile
FROM python:3.12-slim
WORKDIR /app

# Non-Root-User erstellen
RUN useradd --create-home --no-log-init appuser

COPY --chown=appuser:appuser . .
RUN pip install --no-cache-dir -r requirements.txt

USER appuser
CMD ["python", "app.py"]
```

### HEALTHCHECK

Teilt Docker (und Orchestratoren) mit, wie geprüft werden soll, ob die App gesund ist:

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
```

```bash
# Healthcheck-Status sehen
docker ps
# CONTAINER ID  ...  STATUS
# abc123        ...  Up 2 Minuten (healthy)
```

### Read-Only Filesystem

```bash
docker run --read-only myapp
# Wenn die App schreiben muss, tmpfs für /tmp verwenden:
docker run --read-only --tmpfs /tmp myapp
```

### .dockerignore ist wichtig

```
.git/
.github/
.venv/
node_modules/
*.md
.env
.DS_Store
__pycache__/
*.pyc
tests/
docs/
```

## Praxisaufgabe

Das Image aus Modul 10 nehmen und verbessern:
1. Non-Root-User hinzufügen
2. Zu `python:3.12-alpine` als Basis-Image wechseln
3. Einen `HEALTHCHECK` hinzufügen
4. Image-Größen vorher und nachher vergleichen

## Beispiel

```dockerfile
FROM python:3.12-alpine
WORKDIR /app

RUN adduser --disabled-password --no-create-home appuser

COPY --chown=appuser:appuser requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=appuser:appuser . .

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -qO- http://localhost:8080/health || exit 1

USER appuser
EXPOSE 8080
CMD ["python", "app.py"]
```

```bash
# Größen vergleichen
docker images | grep myapp
# Erwartete Ausgabe:
# myapp    v1-vorher   ...   151MB
# myapp    v2-nachher  ...    58MB
```

## Typische Fehler

- **Als Root ausführen** — wenn die App kompromittiert wird, hat der Angreifer Root im Container
- **Basis-Image-Versionen nicht pinnen** — `FROM python:3.12-slim` ist reproduzierbar; `FROM python:latest` nicht
- **`RUN apt-get install` ohne Aufräumen** — immer mit `rm -rf /var/lib/apt/lists/*` verketten, um den Layer klein zu halten

> [!IMPORTANT]
> Immer die Basis-Image-Version pinnen. `FROM nginx:1.25-alpine` gibt bei jedem Build dasselbe Image. `FROM nginx:latest` möglicherweise nicht.

## Checkpoint

- [ ] Ich kann ein Multi-Stage Dockerfile schreiben
- [ ] Ich kann einem Dockerfile einen Non-Root-User hinzufügen
- [ ] Ich kann eine `HEALTHCHECK`-Anweisung hinzufügen
- [ ] Ich verstehe, warum minimale Basis-Images wichtig sind

## Definition of Done

Du kannst ein einfaches Dockerfile für die Produktion verbessern: kleineres Basis-Image, Multi-Stage Build, Non-Root-User und Healthcheck.

## Weiterführende Links

- [Docker Security Best Practices](https://docs.docker.com/develop/security-best-practices/)
- [Distroless Images](https://github.com/GoogleContainerTools/distroless)
- [docker scout](https://docs.docker.com/scout/)
