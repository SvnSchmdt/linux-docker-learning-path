# Intermediate-Übungen

Nach den Modulen 05–13 abschließen.

## Prozesse & System

**Übung 1:** Drei `sleep`-Prozesse im Hintergrund starten (z.B. `sleep 300`). Mit `ps aux | grep sleep` auflisten. Alle mit einem einzigen `pkill`-Befehl beenden.

**Übung 2:** Herausfinden, welcher Prozess (falls vorhanden) auf Port 8080 lauscht. `ss` oder `lsof` verwenden.

**Übung 3:** Ein Script schreiben, das die Festplattennutzung von `/tmp` alle 5 Sekunden überwacht und beendet, wenn sie 80% übersteigt (`df` und eine `while`-Schleife verwenden).

## Shell Scripting

**Übung 4:** Ein Script `check-ports.sh` schreiben, das einen Hostnamen als Argument nimmt und prüft, ob die Ports 80 und 443 erreichbar sind (`curl --connect-timeout 3` verwenden).

**Übung 5:** Ein Script schreiben, das alle `.log`-Dateien in einem gegebenen Verzeichnis findet, ihre Namen und Größen ausgibt und Dateien löscht, die älter als 7 Tage sind.

## Docker

**Übung 6:** Das `alpine:3.19`-Image pullen. Einen Container starten, der `Hallo von Alpine` ausgibt und dann beendet. Container-Status mit `docker ps -a` prüfen.

**Übung 7:** Ein Dockerfile für eine Node.js-App schreiben, das:
- `node:20-alpine` als Basis verwendet
- WORKDIR auf `/app` setzt
- Einen Non-Root-User erstellt
- CMD `["node", "-e", "console.log('Hallo Node')"]` hat

Bauen, ausführen, Ausgabe prüfen.

**Übung 8:** Einen PostgreSQL-Container starten mit:
- Name: `mydb`
- Port: `5432:5432`
- Umgebung: `POSTGRES_PASSWORD=testpass`, `POSTGRES_DB=myapp`
- Benanntem Volume: `pgdata:/var/lib/postgresql/data`

Mit `docker exec -it mydb psql -U postgres myapp` verbinden und eine Tabelle erstellen.

## Docker Compose

**Übung 9:** Eine `docker-compose.yml` schreiben, die startet:
- `wordpress:6` auf Port 8080
- `mysql:8` mit Passwort und Datenbank
- Ein benanntes Volume für MySQL-Daten

Prüfen, ob WordPress unter `http://localhost:8080` erreichbar ist.

**Übung 10:** Einen Healthcheck zum MySQL-Service hinzufügen (`mysqladmin ping` verwenden). WordPress von MySQL mit `condition: service_healthy` abhängig machen.

---

**Cleanup:** `docker compose down -v` und `docker rm -f mydb`
