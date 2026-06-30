# Checkpoints

Selbsteinschätzungstests, um zu bestätigen, dass du für die nächste Phase bereit bist.

## Checkpoint 1 – Linux-Grundlagen

Diese Aufgaben solltest du ohne Hilfe lösen können:

- [ ] Zu `/etc` navigieren, alle Dateien auflisten und eine Datei finden, die das Wort "hosts" enthält
- [ ] Das Verzeichnis `~/projects/demo` erstellen, darin eine `notes.txt` anlegen und eine Zeile mit `echo` und Umleitung hineinschreiben
- [ ] Berechtigungen auf `notes.txt` auf `644` setzen und erklären, was das bedeutet
- [ ] Alle `.conf`-Dateien unter `/etc` (nicht rekursiv) finden und zählen, wie viele es gibt
- [ ] Einen Hintergrundprozess starten (`sleep 60 &`) und ihn per PID beenden
- [ ] Ein Script schreiben, das von 1 bis 5 zählt und jede Zahl ausgibt

## Checkpoint 2 – Container-Grundlagen

- [ ] Den Unterschied zwischen einem Image und einem Container in einem Satz erklären
- [ ] Das `nginx:alpine`-Image pullen und einen Container auf Port 8080 starten
- [ ] Ein Dockerfile für eine einfache Python-App schreiben, die "Hello" ausgibt
- [ ] Das Image als `myapp:v1` bauen und taggen
- [ ] Die Logs eines laufenden Containers lesen
- [ ] Einen Befehl in einem laufenden Container mit `docker exec` ausführen

## Checkpoint 3 – Produktionsreif

- [ ] Eine `docker-compose.yml` mit einer Web-App und einem Redis-Service schreiben, verbunden über ein benanntes Netzwerk
- [ ] Ein benanntes Volume für Redis-Persistenz hinzufügen
- [ ] Ein getaggtes Image zu Docker Hub (oder GHCR) pushen
- [ ] Ein Multi-Stage Dockerfile schreiben und Image-Größen vergleichen
- [ ] Einen Non-Root-User in ein Dockerfile hinzufügen
- [ ] Eine `HEALTHCHECK`-Anweisung in ein Dockerfile einfügen

> [!TIP]
> Wenn du alle Aufgaben eines Checkpoints erledigen kannst, bist du wirklich für die nächste Phase bereit — nicht nur "ich hab's gelesen" bereit.
