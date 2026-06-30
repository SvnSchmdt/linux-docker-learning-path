# Modul 05 – Prozesse & System

## Ziel des Moduls

Laufende Prozesse überwachen, System-Services verwalten und Systemressourcen prüfen.

## Warum ist das wichtig?

Produktionssysteme verhalten sich manchmal unerwartet. Prozesse stürzen ab, Arbeitsspeicher füllt sich, Festplatten laufen voll, Services starten nicht. Du musst wissen, wie du herausfindest, was passiert, und eingreifen kannst. Diese Werkzeuge sind die Grundlage der Betriebsarbeit auf jedem Linux-System.

## Kernkonzepte

### Prozesse anzeigen

```bash
ps aux              # alle laufenden Prozesse
ps aux | grep nginx # einen bestimmten Prozess finden
top                 # interaktiver Prozess-Viewer
htop                # verbesserte Version von top (separat installieren)
```

`ps aux`-Spalten:
- `PID` — Prozess-ID
- `%CPU` — CPU-Nutzung
- `%MEM` — Arbeitsspeicher-Nutzung
- `VSZ` — Virtueller Arbeitsspeicher
- `RSS` — Resident Memory (physischer RAM in Nutzung)
- `STAT` — Prozesszustand (R=laufend, S=schlafend, Z=zombie)
- `COMMAND` — Befehlsname

### Prozesse beenden

```bash
kill 1234             # SIGTERM (graceful shutdown) an PID 1234 senden
kill -9 1234          # SIGKILL (erzwungenes Beenden) — letztes Mittel
pkill nginx           # nach Prozessname beenden
killall nginx         # alle Prozesse mit diesem Namen beenden
```

### Hintergrundprozesse

```bash
befehl &              # im Hintergrund starten
jobs                  # Hintergrundprozesse auflisten
fg %1                 # Job 1 in den Vordergrund holen
bg %1                 # Job 1 im Hintergrund fortsetzen
nohup befehl &        # auch nach Abmelden weiterlaufen lassen
```

### systemctl — Service-Verwaltung

```bash
systemctl status nginx          # Service-Status prüfen
systemctl start nginx           # Service starten
systemctl stop nginx            # Service stoppen
systemctl restart nginx         # Service neu starten
systemctl enable nginx          # beim Booten starten
systemctl disable nginx         # nicht beim Booten starten
```

### Systemressourcen

```bash
df -h               # Festplattennutzung (menschenlesbar)
du -sh ~/           # Größe des Home-Verzeichnisses
free -h             # RAM- und Swap-Nutzung
uptime              # System-Uptime und Load Average
```

### Journal-Logs

```bash
journalctl -u nginx             # Logs für den nginx-Service
journalctl -f                   # neuen Log-Einträgen folgen
journalctl --since "1 hour ago" # Logs der letzten Stunde
```

## Praxisaufgabe

1. PID der eigenen Shell finden: `echo $$`
2. `sleep 300 &` im Hintergrund starten, dann mit `ps aux | grep sleep` finden
3. Den sleep-Prozess per PID beenden
4. Festplattennutzung des Home-Verzeichnisses mit `du -sh ~` prüfen

## Beispiel-Kommandos

```bash
# PID der eigenen Shell finden
echo $$
# Erwartete Ausgabe (Beispiel):
# 12345

# Alle Prozesse des eigenen Benutzers
ps aux | grep $USER

# Interaktiver Prozess-Viewer
top
# 'q' zum Beenden, 'k' zum Beenden eines Prozesses, '1' für CPU-Statistiken pro Kern

# Festplattenspeicher prüfen
df -h
# Erwartete Ausgabe (Beispiel):
# Filesystem      Size  Used Avail Use% Mounted on
# /dev/sda1        50G   15G   33G  32% /

# RAM-Nutzung
free -h
# Erwartete Ausgabe (Beispiel):
#               total        used        free      shared  buff/cache   available
# Mem:           15Gi       3.2Gi       9.8Gi       234Mi       2.1Gi        11Gi
```

## Typische Fehler

- **Sofort `kill -9` verwenden** — zuerst immer `kill` (SIGTERM) versuchen; `-9` erlaubt keine Aufräumarbeiten
- **`nohup` vergessen** — Hintergrundprozesse sterben ohne `nohup` beim Abmelden
- **`systemctl` vs service** — `systemctl` ist der moderne Weg; `service` ist der Legacy-Befehl auf älteren Systemen

## Checkpoint

- [ ] Ich kann einen laufenden Prozess nach Name und PID finden
- [ ] Ich kann einen Prozess ordentlich und erzwungen beenden
- [ ] Ich kann Festplatten-, Arbeitsspeicher- und CPU-Nutzung prüfen
- [ ] Ich kann einen System-Service starten, stoppen und seinen Status prüfen

## Definition of Done

Du kannst einen fehlverhaltenden Server debuggen: den Prozess finden, der zu viel CPU/Speicher verbraucht, ihn beenden, den Festplattenspeicher prüfen und Service-Logs einsehen.

## Weiterführende Links

- `man ps`
- `man systemctl`
- `man journalctl`
- `man df`
