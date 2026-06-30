# Modul 08 – Shell Scripting

## Ziel des Moduls

Praktische Shell-Scripts mit Variablen, Bedingungen, Schleifen und Funktionen schreiben.

## Warum ist das wichtig?

Shell-Scripts automatisieren wiederholende Aufgaben. Statt bei jedem Deployment dieselben 5 Befehle einzutippen, schreibt man ein Script. Das Verständnis von Shell-Scripting macht dich auch viel besser darin, bestehende Scripts zu lesen und zu pflegen — die es überall in Produktionssystemen gibt.

## Kernkonzepte

### Shebang

Die erste Zeile eines Shell-Scripts sagt dem Betriebssystem, welchen Interpreter es verwenden soll:

```bash
#!/bin/bash
#!/usr/bin/env bash    # bevorzugt: findet bash in PATH
```

### Variablen

```bash
name="Alice"           # keine Leerzeichen um =
echo "Hallo, $name"    # mit $ verwenden
echo "Hallo, ${name}"  # explizite Variablengrenze

# Befehlssubstitution
heute=$(date +%Y-%m-%d)
dateien=$(ls *.txt)
```

### Bedingungen

```bash
if [ -f "datei.txt" ]; then
    echo "Datei existiert"
elif [ -d "verz/" ]; then
    echo "Verzeichnis existiert"
else
    echo "Keines gefunden"
fi

# Häufige Test-Operatoren
[ -f datei ]    # Datei existiert und ist eine reguläre Datei
[ -d verz ]     # Verzeichnis existiert
[ -z "$var" ]   # String ist leer
[ -n "$var" ]   # String ist nicht leer
[ "$a" = "$b" ] # Strings sind gleich
[ $n -eq 42 ]   # Zahlen sind gleich
```

### Schleifen

```bash
# for-Schleife
for i in 1 2 3 4 5; do
    echo "Schritt $i"
done

# for-Schleife über Dateien
for datei in *.txt; do
    echo "Verarbeite $datei"
done

# while-Schleife
zaehler=0
while [ $zaehler -lt 5 ]; do
    echo "Zähler: $zaehler"
    zaehler=$((zaehler + 1))
done
```

### Funktionen

```bash
begruessung() {
    local name="$1"    # $1 ist das erste Argument
    echo "Hallo, $name!"
}

begruessung "Welt"    # Funktion aufrufen
```

### Exit-Codes und Fehlerbehandlung

```bash
# Exit-Code des letzten Befehls prüfen
ls datei.txt
echo "Exit-Code: $?"    # 0 = Erfolg, ungleich null = Fehler

# set -e: sofort bei Fehler beenden
# set -u: nicht gesetzte Variablen als Fehler behandeln
set -e
set -u

# Script ausführbar machen
chmod +x script.sh
./script.sh
```

## Praxisaufgabe

Ein Script `backup.sh` schreiben, das:
1. Einen Verzeichnisnamen als Argument `$1` entgegennimmt
2. Prüft, ob das Verzeichnis existiert (wenn nicht, mit Fehlermeldung beenden)
3. Ein Tarball erstellt: `backup-YYYY-MM-DD.tar.gz`
4. Eine Erfolgsmeldung mit dem Backup-Dateinamen ausgibt

## Beispiel-Script

```bash
#!/usr/bin/env bash
set -e
set -u

QUELL_VERZ="${1:-}"

if [ -z "$QUELL_VERZ" ]; then
    echo "Verwendung: $0 <verzeichnis>" >&2
    exit 1
fi

if [ ! -d "$QUELL_VERZ" ]; then
    echo "Fehler: '$QUELL_VERZ' ist kein Verzeichnis" >&2
    exit 1
fi

DATUM=$(date +%Y-%m-%d)
BACKUP_DATEI="backup-${DATUM}.tar.gz"

tar -czf "$BACKUP_DATEI" "$QUELL_VERZ"
echo "Backup erstellt: $BACKUP_DATEI"
```

```bash
# Script ausführen
chmod +x backup.sh
./backup.sh ~/projekte

# Erwartete Ausgabe:
# Backup erstellt: backup-2026-06-30.tar.gz
```

## Typische Fehler

- **Leerzeichen um `=` bei Variablenzuweisung** — `name = "Alice"` schlägt fehl; `name="Alice"` verwenden
- **Fehlende Anführungszeichen um Variablen** — `rm $datei` bricht ab, wenn `$datei` Leerzeichen enthält; `rm "$datei"` verwenden
- **`chmod +x` vergessen** — das Script wird ohne es nicht ausgeführt
- **`set -e` nicht verwenden** — das Script läuft nach einem fehlgeschlagenen Befehl still weiter

> [!WARNING]
> Variablen immer in Anführungszeichen setzen: `"$var"` nicht `$var`. Nicht in Anführungszeichen gesetzte Variablen mit Leerzeichen werden in mehrere Argumente aufgeteilt.

## Checkpoint

- [ ] Ich kann ein Script mit Shebang, Variablen und einer if-Bedingung schreiben
- [ ] Ich kann über eine Liste und über Dateien schleifen
- [ ] Ich kann `$1`, `$2` für Script-Argumente verwenden
- [ ] Ich weiß, was `$?` enthält und wie man `set -e` verwendet

## Definition of Done

Du kannst ein Script schreiben, das Argumente entgegennimmt, sie validiert, etwas Nützliches mit einer Schleife macht und Fehler korrekt behandelt.

## Weiterführende Links

- `man bash` — Abschnitte zu Variablen, Bedingungen und Schleifen
- [Bash Pitfalls](https://mywiki.wooledge.org/BashPitfalls) — häufige Fehler und wie man sie vermeidet
