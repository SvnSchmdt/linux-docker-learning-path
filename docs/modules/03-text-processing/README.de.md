# Modul 03 – Textverarbeitung

## Ziel des Moduls

Textdateien und Befehlsausgaben mit Standard-Linux-Werkzeugen verarbeiten, filtern und transformieren.

## Warum ist das wichtig?

Log-Dateien, Konfigurationsdateien, CSV-Exporte und Befehlsausgaben sind alle Text. Linux bietet ein leistungsstarkes Set von Werkzeugen, um Text in der Kommandozeile zu slicen, zu filtern, zu zählen und zu kombinieren — ohne GUI oder Script. Diese Werkzeuge können durch Pipes kombiniert werden und sind dadurch außerordentlich flexibel.

## Kernkonzepte

### Dateien anzeigen

```bash
cat datei.txt         # gesamte Datei ausgeben
less datei.txt        # seitenweise Ansicht (q zum Beenden, / zum Suchen)
head -n 20 datei.txt  # erste 20 Zeilen
tail -n 20 datei.txt  # letzte 20 Zeilen
tail -f app.log       # Log-Datei in Echtzeit verfolgen
```

### Suchen mit grep

```bash
grep "Muster" datei.txt         # nach Muster suchen
grep -i "error" app.log         # Groß-/Kleinschreibung ignorieren
grep -r "TODO" src/             # rekursive Suche
grep -n "func" main.go          # Zeilennummern anzeigen
grep -v "DEBUG" app.log         # invertierte Suche (DEBUG-Zeilen ausschließen)
```

### Zählen und Statistiken

```bash
wc -l datei.txt       # Zeilen zählen
wc -w datei.txt       # Wörter zählen
sort datei.txt        # Zeilen alphabetisch sortieren
sort -n zahlen.txt    # numerisch sortieren
uniq sortiert.txt     # aufeinanderfolgende Duplikate entfernen
sort datei.txt | uniq -c | sort -rn   # Vorkommen zählen, häufigste zuerst
```

### Pipes und Redirects

```bash
befehl1 | befehl2    # Pipe: stdout von Befehl1 → stdin von Befehl2
befehl > datei.txt   # stdout in Datei umleiten (überschreiben)
befehl >> datei.txt  # stdout in Datei umleiten (anhängen)
befehl 2>&1          # stderr in stdout umleiten
befehl 2>/dev/null   # stderr verwerfen
```

### Dateien finden

```bash
find . -name "*.log"              # nach Name finden
find /etc -name "*.conf" -type f  # nur Dateien
find . -newer referenz.txt        # Dateien neuer als Referenz
find . -size +1M                  # Dateien größer als 1 MB
```

## Praxisaufgabe

1. Alle Zeilen mit "error" (Groß-/Kleinschreibung egal) in `/var/log/system.log` (macOS) oder `/var/log/syslog` (Linux) finden
2. Zählen, wie viele einzigartige Fehlertypen vorkommen
3. Das Ergebnis in `~/fehler.txt` speichern
4. Alle `.txt`-Dateien im Home-Verzeichnis finden, die in den letzten 7 Tagen geändert wurden

## Beispiel-Kommandos

```bash
# Letzte 50 Zeilen einer Log-Datei anzeigen
tail -n 50 /var/log/system.log

# Alle Fehler-Zeilen finden und zählen
grep -i "error" /var/log/system.log | wc -l

# Eindeutige IPs aus einem Access-Log ermitteln
grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' access.log | sort | uniq -c | sort -rn

# Alle Python-Dateien mit TODO finden
find . -name "*.py" | xargs grep -l "TODO"

# Kette: Fehler finden, sortieren, eindeutige zählen, Top 10 anzeigen
grep -i "error" app.log | sort | uniq -c | sort -rn | head -10

# stderr in Datei umleiten
./script.sh 2> fehler.log

# Sowohl stdout als auch stderr umleiten
./script.sh > ausgabe.log 2>&1
```

## Typische Fehler

- **`grep` ohne `-r` auf einem Verzeichnis** — `grep -r` für rekursive Suche verwenden
- **Vergessen, dass `>` überschreibt** — `>>` verwenden, um an eine bestehende Datei anzuhängen
- **`sort | uniq`** — `uniq` entfernt nur *aufeinanderfolgende* Duplikate, daher muss vorher sortiert werden
- **Pipe vs. Redirect verwechseln** — `|` verbindet Befehle; `>` schreibt in eine Datei

## Checkpoint

- [ ] Ich kann Dateien mit `grep` und kombinierten Flags (`-i`, `-r`, `-n`, `-v`) durchsuchen
- [ ] Ich kann mehrstufige Pipelines mit `|` bauen
- [ ] Ich kann Ausgaben mit `>` und `>>` in Dateien umleiten
- [ ] Ich kann Dateien nach Name, Typ und Größe mit `find` suchen

## Definition of Done

Du kannst eine Log-Datei von der Kommandozeile analysieren: bestimmte Muster finden, Vorkommen zählen, Ergebnisse sortieren und in eine Datei speichern.

## Weiterführende Links

- `man grep`
- `man find`
- `man sort`
- `man uniq`
