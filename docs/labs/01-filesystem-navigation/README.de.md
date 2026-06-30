# Lab 01 – Filesystem Navigation

## Was du baust

Du wirst die Linux-Dateisystemstruktur erkunden, einen Projektverzeichnisbaum erstellen, versteckte Dateien finden und `find` mit Filtern verwenden, um bestimmte Dateien zu lokalisieren.

**Verwendete Konzepte:** Dateisystem-Hierarchie, absolute/relative Pfade, `ls`, `cd`, `tree`, `find`, versteckte Dateien.

```
/
├── etc/          ← System-Konfiguration
├── var/
│   └── log/      ← System-Logs
├── tmp/          ← Temporäre Dateien
└── home/
    └── du/       ← dein Home
        └── projects/
            └── demo/    ← das wirst du erstellen
```

## Ziel

Das Linux-Dateisystem sicher navigieren und Dateien mit `find` und mehreren Filtern finden.

## Voraussetzungen

- Modul 01 abgeschlossen
- `tree` installiert (`brew install tree` auf macOS / `sudo apt install tree` auf Linux)

## Schritt-für-Schritt

### Schritt 1: Das Dateisystem-Root erkunden

```bash
ls /
# Erwartete Ausgabe:
# bin   dev  home  lib    media  opt   root  sbin  sys  usr
# boot  etc  host  lib64  mnt    proc  run   srv   tmp  var
```

### Schritt 2: Orientierung

```bash
pwd
# Erwartete Ausgabe (Beispiel):
# /home/alice

echo "Home: $HOME"
# Erwartete Ausgabe:
# Home: /home/alice
```

### Schritt 3: Projektverzeichnisbaum erstellen

```bash
mkdir -p ~/projects/demo/{src,tests,docs}
ls -la ~/projects/demo/
# Erwartete Ausgabe:
# drwxr-xr-x  5 alice alice 4096 Jun 30 10:00 .
# drwxr-xr-x  3 alice alice 4096 Jun 30 10:00 ..
# drwxr-xr-x  2 alice alice 4096 Jun 30 10:00 docs
# drwxr-xr-x  2 alice alice 4096 Jun 30 10:00 src
# drwxr-xr-x  2 alice alice 4096 Jun 30 10:00 tests
```

### Schritt 4: Einige Dateien erstellen

```bash
touch ~/projects/demo/src/main.py
touch ~/projects/demo/src/.env
touch ~/projects/demo/tests/test_main.py
echo "# Demo-Projekt" > ~/projects/demo/README.md
```

### Schritt 5: Versteckte Dateien finden

```bash
ls -la ~/projects/demo/src/
# Erwartete Ausgabe (.env wird mit -a angezeigt):
# drwxr-xr-x  2 alice alice 4096 Jun 30 10:00 .
# drwxr-xr-x  5 alice alice 4096 Jun 30 10:00 ..
# -rw-r--r--  1 alice alice    0 Jun 30 10:00 .env
# -rw-r--r--  1 alice alice    0 Jun 30 10:00 main.py
```

### Schritt 6: tree verwenden

```bash
tree ~/projects/demo
# Erwartete Ausgabe:
# /home/alice/projects/demo
# ├── README.md
# ├── docs
# ├── src
# │   ├── .env
# │   └── main.py
# └── tests
#     └── test_main.py
```

### Schritt 7: find mit Filtern verwenden

```bash
# Alle Python-Dateien finden
find ~/projects -name "*.py"
# Erwartete Ausgabe:
# /home/alice/projects/demo/src/main.py
# /home/alice/projects/demo/tests/test_main.py

# Versteckte Dateien finden
find ~/projects -name ".*" -type f
# Erwartete Ausgabe:
# /home/alice/projects/demo/src/.env

# Nur Verzeichnisse finden
find ~/projects -type d
```

## Validierung

```bash
# Verzeichnisbaum prüfen
test -d ~/projects/demo/src && echo "OK: src existiert"
test -d ~/projects/demo/tests && echo "OK: tests existiert"
test -f ~/projects/demo/README.md && echo "OK: README existiert"
test -f ~/projects/demo/src/.env && echo "OK: .env versteckte Datei existiert"

find ~/projects -name "*.py" | wc -l
# Erwartete Ausgabe: 2
```

## Cleanup

```bash
rm -rf ~/projects/demo
```

## Erweiterungsaufgabe

Alle Dateien in `/etc` finden, die:
- Reguläre Dateien sind (keine Verzeichnisse oder Symlinks)
- Von deinem Benutzer lesbar sind
- Kleiner als 1 KB sind

Hinweis: `find /etc -type f -readable -size -1k 2>/dev/null | head -20`
