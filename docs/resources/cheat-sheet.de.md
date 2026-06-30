# Cheat Sheet

## Linux – Navigation & Dateien

```bash
pwd                         # aktuelles Verzeichnis
ls -lah                     # Liste mit Details, versteckt, lesbare Größen
cd -                        # zum vorherigen Verzeichnis
mkdir -p dir/sub            # verschachtelte Verzeichnisse erstellen
cp -r src/ ziel/            # rekursiv kopieren
mv alt neu                  # verschieben / umbenennen
rm -rf dir/                 # rekursiv löschen (VORSICHT)
find . -name "*.py"         # nach Name suchen
find . -type f -size +1M    # Dateien > 1 MB finden
```

## Linux – Berechtigungen

```bash
chmod 755 script.sh         # rwxr-xr-x
chmod 644 datei.txt         # rw-r--r--
chmod 600 geheim            # rw------- (nur Eigentümer)
chmod +x script.sh          # execute hinzufügen
chown benutzer:gruppe datei # Eigentümer ändern
ln -s ziel linkname         # Symlink erstellen
```

## Linux – Textverarbeitung

```bash
grep -rn "muster" .         # rekursive Suche mit Zeilennummern
grep -i "error" app.log     # Groß-/Kleinschreibung ignorieren
grep -v "DEBUG" app.log     # Zeilen ausschließen
sort datei.txt | uniq -c | sort -rn  # Vorkommen zählen
wc -l datei.txt             # Zeilen zählen
tail -f app.log             # Log-Datei folgen
find . | xargs grep "TODO"  # grep in gefundenen Dateien
```

## Linux – Prozesse

```bash
ps aux | grep name          # Prozess finden
kill PID                    # ordentlich beenden
kill -9 PID                 # erzwungen beenden
pkill prozessname           # nach Name beenden
jobs                        # Hintergrundprozesse auflisten
befehl &                    # im Hintergrund starten
df -h                       # Festplattennutzung
free -h                     # Arbeitsspeichernutzung
```

## Docker – Images

```bash
docker images               # lokale Images auflisten
docker pull nginx:alpine    # Image pullen
docker build -t name:tag .  # aus Dockerfile bauen
docker tag src:tag ziel:tag # Tag hinzufügen
docker push user/image:tag  # in Registry pushen
docker rmi image:tag        # Image entfernen
docker image prune          # verwaiste Images entfernen
```

## Docker – Container

```bash
docker run -d --name web -p 8080:80 nginx  # detached starten
docker run -it ubuntu bash              # interaktive Shell
docker run --rm myapp                   # nach Beenden entfernen
docker ps                               # laufende Container
docker ps -a                            # alle Container
docker logs -f container                # Logs folgen
docker exec -it container bash          # Shell im Container
docker stop container                   # ordentlich stoppen
docker rm container                     # gestoppten entfernen
docker rm -f container                  # laufenden erzwungen entfernen
docker container prune                  # alle gestoppten entfernen
```

## Docker – Volumes & Netzwerke

```bash
docker volume create meinedaten   # Volume erstellen
docker volume ls                  # Volumes auflisten
docker volume rm meinedaten       # Volume entfernen
docker volume prune               # alle ungenutzten entfernen
docker network create meinnetz    # Netzwerk erstellen
docker network ls                 # Netzwerke auflisten
docker network rm meinnetz        # Netzwerk entfernen
```

## Docker Compose

```bash
docker compose up -d            # alle starten (detached)
docker compose down             # stoppen und entfernen
docker compose down -v          # auch Volumes entfernen
docker compose ps               # Service-Status
docker compose logs -f app      # Service-Logs folgen
docker compose exec app bash    # Shell im Service
docker compose build            # Images neu bauen
docker compose pull             # neueste Images pullen
docker compose restart app      # einen Service neu starten
```
