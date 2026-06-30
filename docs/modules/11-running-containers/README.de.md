# Modul 11 – Container betreiben

## Ziel des Moduls

Laufende Container starten, inspizieren, verwalten und debuggen.

## Warum ist das wichtig?

Ein Image zu bauen ist nur die halbe Arbeit. Du musst wissen, wie Container korrekt gestartet werden — mit den richtigen Flags für Netzwerk, Umgebungsvariablen und Ressourcenkontrolle — und wie man sie beim Auftreten von Problemen inspiziert und debuggt.

## Kernkonzepte

### docker run Flags

```bash
docker run nginx                          # Vordergrund, blockiert Terminal
docker run -d nginx                       # detached (Hintergrund)
docker run -it ubuntu bash                # interaktives Terminal
docker run --rm nginx                     # Container beim Beenden entfernen
docker run -p 8080:80 nginx              # Port-Mapping: host:container
docker run -e PORT=8080 myapp            # Umgebungsvariable übergeben
docker run --name my-nginx nginx         # Namen zuweisen
docker run -d --name web -p 8080:80 nginx  # mehrere Flags kombinieren
```

### Auflisten und Inspizieren

```bash
docker ps                    # laufende Container
docker ps -a                 # alle Container (inkl. gestoppter)
docker inspect container-id  # vollständige JSON-Details
docker inspect -f '{{ .NetworkSettings.IPAddress }}' container-id  # Ausgabe formatieren
```

### Logs

```bash
docker logs container-id           # alle Logs
docker logs -f container-id        # folgen (wie tail -f)
docker logs --tail 50 container-id # letzte 50 Zeilen
docker logs --since 5m container-id # Logs der letzten 5 Minuten
```

### Befehle im Container ausführen

```bash
docker exec container-id ls /app          # einzelnen Befehl ausführen
docker exec -it container-id bash         # interaktive Shell
docker exec -it container-id sh           # wenn bash nicht verfügbar
docker exec -it -e DEBUG=1 container-id bash  # mit Umgebungsvariable
```

### Stoppen und Entfernen

```bash
docker stop container-id        # SIGTERM + 10s warten + SIGKILL
docker stop -t 30 container-id  # 30s warten vor erzwungenem Beenden
docker kill container-id        # sofortiges SIGKILL
docker rm container-id          # gestoppten Container entfernen
docker rm -f container-id       # laufenden Container erzwungen entfernen
docker container prune          # ALLE gestoppten Container entfernen
```

## Praxisaufgabe

1. Nginx-Container im Hintergrund auf Port 8080 starten: `docker run -d --name web -p 8080:80 nginx`
2. Prüfen, ob er läuft: `curl http://localhost:8080`
3. Logs lesen: `docker logs web`
4. Shell darin öffnen: `docker exec -it web bash`
5. Stoppen und entfernen: `docker stop web && docker rm web`

## Beispiel-Kommandos

```bash
# nginx im Hintergrund mit Port-Mapping starten
docker run -d --name web -p 8080:80 nginx

# Erwartete Ausgabe:
# 3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d

# Prüfen, ob er läuft
docker ps
# Erwartete Ausgabe:
# CONTAINER ID   IMAGE   COMMAND                  PORTS                  NAMES
# 3a4b5c6d7e8f   nginx   "/docker-entrypoint.…"   0.0.0.0:8080->80/tcp   web

# Web-Server testen
curl http://localhost:8080
# Erwartete Ausgabe:
# <!DOCTYPE html>
# <html>
# <head><title>Welcome to nginx!</title></head>
# ...

# Interaktive Shell öffnen
docker exec -it web bash
# Jetzt bist du im Container:
# root@3a4b5c6d7e8f:/#

# Stoppen und aufräumen
docker stop web && docker rm web
```

## Typische Fehler

- **`-d` vergessen** — der Container läuft im Vordergrund und blockiert das Terminal
- **Port bereits in Verwendung** — vorher mit `ss -tlnp | grep 8080` prüfen
- **Container beendet sich sofort** — oft weil der Hauptprozess fehlgeschlagen ist; `docker logs` prüfen
- **`docker rm` auf einem laufenden Container** — `docker rm -f` verwenden oder zuerst stoppen

> [!TIP]
> `--rm` beim Experimentieren verwenden: `docker run --rm -it ubuntu bash`. Der Container wird automatisch entfernt, wenn du beendest.

## Checkpoint

- [ ] Ich kann einen Container im detached Modus mit Port-Mapping starten
- [ ] Ich kann Container-Logs mit `docker logs` lesen
- [ ] Ich kann eine interaktive Shell in einem laufenden Container öffnen
- [ ] Ich kann Container stoppen und entfernen

## Definition of Done

Du kannst einen Web-Server in einem Docker-Container starten, prüfen, ob er funktioniert, seine Logs inspizieren, eine Debug-Shell darin öffnen und anschließend aufräumen.

## Weiterführende Links

- `docker run --help`
- [docker run Referenz](https://docs.docker.com/engine/reference/commandline/run/)
