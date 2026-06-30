# Modul 10 – Dockerfile & Build

## Ziel des Moduls

Ein Dockerfile schreiben und ein Container-Image mit `docker build` bauen.

## Warum ist das wichtig?

Ein Dockerfile ist das Rezept für die Laufzeitumgebung deiner Anwendung. Statt "installiere diese 7 Pakete und führe dann diese 3 Befehle aus" zu dokumentieren, schreibst du ein Dockerfile. Das resultierende Image kann auf jeder Maschine mit Docker identisch ausgeführt werden — Entwickler-Laptops, CI-Server, Produktions-Hosts.

## Kernkonzepte

### Dockerfile-Anweisungen

```dockerfile
FROM python:3.12-slim           # Basis-Image — immer zuerst
WORKDIR /app                    # Arbeitsverzeichnis setzen
COPY requirements.txt .         # Dateien aus Build-Kontext kopieren
RUN pip install -r requirements.txt  # Befehle beim Build ausführen
COPY . .                        # Rest der App kopieren
ENV PORT=8080                   # Umgebungsvariable setzen
EXPOSE 8080                     # Dokumentieren, welchen Port die App verwendet
CMD ["python", "app.py"]        # Standard-Befehl beim Starten
```

**Wichtige Anweisungen erklärt:**

| Anweisung | Zweck |
|-----------|-------|
| `FROM` | Basis-Image — muss zuerst stehen |
| `WORKDIR` | Setzt das Arbeitsverzeichnis für folgende Anweisungen |
| `COPY` | Dateien aus dem Build-Kontext ins Image kopieren |
| `ADD` | Wie COPY, aber auch URLs und .tar-Dateien (COPY bevorzugen) |
| `RUN` | Befehle in einem neuen Layer ausführen |
| `ENV` | Umgebungsvariable setzen (bleibt im Container erhalten) |
| `EXPOSE` | Dokumentiert, auf welchem Port der Container lauscht |
| `CMD` | Standard-Befehl beim Container-Start (überschreibbar) |
| `ENTRYPOINT` | Fester Befehl; CMD wird zu Argumenten (schwerer zu überschreiben) |

### Layer-Caching

Jede Anweisung erstellt einen neuen **Layer**. Docker cached Layer — wenn sich nichts geändert hat, wird der gecachte Layer wiederverwendet:

```dockerfile
FROM python:3.12-slim
WORKDIR /app

# requirements ZUERST kopieren — dieser Layer ändert sich selten
COPY requirements.txt .
RUN pip install -r requirements.txt

# Quellcode ZULETZT kopieren — dieser ändert sich oft
COPY . .

CMD ["python", "app.py"]
```

Wenn man zuerst den gesamten Quellcode kopiert (`COPY . .`) und dann Abhängigkeiten installiert, invalidiert jede Code-Änderung den pip-install-Cache.

### .dockerignore

Wie `.gitignore` — sagt Docker, was NICHT in den Build-Kontext aufgenommen werden soll:

```
.git
.venv
__pycache__
*.pyc
.env
node_modules
```

### Images bauen

```bash
docker build -t myapp:v1 .              # mit Tag bauen, aktuelles Verzeichnis
docker build -t myapp:v1 -f Dockerfile.prod .  # bestimmtes Dockerfile verwenden
docker build --no-cache -t myapp:v1 .   # Cache ignorieren
```

## Praxisaufgabe

Eine einfache App erstellen und ein Docker-Image bauen:

1. `app.py` erstellen:
```python
print("Hallo aus Docker!")
```

2. `Dockerfile` erstellen:
```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY app.py .
CMD ["python", "app.py"]
```

3. Bauen und ausführen:
```bash
docker build -t hello-python:v1 .
docker run hello-python:v1
```

## Beispiel-Kommandos

```bash
# Image mit Tag myapp:v1 aus aktuellem Verzeichnis bauen
docker build -t myapp:v1 .

# Erwartete Ausgabe (gekürzt):
# [+] Building 12.3s (8/8) FINISHED
#  => [internal] load build definition from Dockerfile
#  => [1/4] FROM python:3.12-slim
#  => [2/4] WORKDIR /app
#  => [3/4] COPY app.py .
#  => [4/4] CMD ["python", "app.py"]

# Images auflisten, um das neue Image zu sehen
docker images
# Erwartete Ausgabe:
# REPOSITORY      TAG    IMAGE ID       CREATED        SIZE
# hello-python    v1     a1b2c3d4e5f6   2 Sek. ago    151MB
```

## Typische Fehler

- **Falsche Anweisungsreihenfolge** — selten ändernde Anweisungen zuerst platzieren, um Cache-Treffer zu maximieren
- **`COPY . .` vor `pip install`** — invalidiert den Install-Cache bei jeder Code-Änderung
- **Kein `.dockerignore`** — sendet `.git`, `node_modules` oder virtuelle Umgebungen an den Build-Daemon
- **`ADD` verwenden, wenn `COPY` ausreicht** — `ADD` hat überraschende Verhaltensweisen; `COPY` für einfaches Kopieren bevorzugen

## Checkpoint

- [ ] Ich kann ein Dockerfile mit FROM, WORKDIR, COPY, RUN und CMD schreiben
- [ ] Ich verstehe, wie Layer-Caching funktioniert und wie man dafür optimiert
- [ ] Ich kann ein Image mit einem Tag mit `docker build -t` bauen
- [ ] Ich habe eine `.dockerignore`-Datei

## Definition of Done

Du kannst ein Dockerfile für eine einfache Anwendung schreiben, es bauen und erklären, warum die Reihenfolge der Anweisungen für das Caching wichtig ist.

## Weiterführende Links

- [Dockerfile-Referenz](https://docs.docker.com/engine/reference/builder/)
- [Best Practices für das Schreiben von Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
