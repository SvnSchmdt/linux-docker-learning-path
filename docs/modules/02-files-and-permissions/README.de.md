# Modul 02 – Dateien & Berechtigungen

## Ziel des Moduls

Dateien erstellen, verschieben und löschen; Unix-Dateiberechtigungen verstehen und setzen.

## Warum ist das wichtig?

Dateiberechtigungen sind das primäre Sicherheitsmodell in Linux. Sie kontrollieren, wer jede Datei und jedes Verzeichnis auf dem System lesen, schreiben oder ausführen darf. Sie zu verstehen ist sowohl für die Sicherheit als auch zur Vermeidung von "Permission denied"-Fehlern unerlässlich.

## Kernkonzepte

### Dateioperationen

```bash
touch datei.txt         # leere Datei erstellen
mkdir -p dir/sub        # Verzeichnis erstellen (und übergeordnete mit -p)
cp quelle ziel          # Datei kopieren
mv quelle ziel          # Datei verschieben/umbenennen
rm datei.txt            # Datei löschen
rm -r dir/              # Verzeichnis rekursiv löschen
```

### Berechtigungsmodell (rwx)

Jede Datei hat Berechtigungen für drei Gruppen:

```
-rwxr-xr--  1  alice  staff  1234  Jun 30 10:00  script.sh
 ^^^ ^^^ ^^^
 |   |   └── other (alle anderen): r-- = nur lesen
 |   └────── group: r-x = lesen und ausführen
 └────────── user (Eigentümer): rwx = lesen, schreiben, ausführen
```

| Symbol | Bedeutung für Dateien | Bedeutung für Verzeichnisse |
|--------|----------------------|----------------------------|
| `r` | Dateiinhalt lesen | Verzeichnisinhalt auflisten |
| `w` | Datei schreiben/ändern | Dateien im Verzeichnis erstellen/löschen |
| `x` | Als Programm ausführen | In das Verzeichnis wechseln (`cd`) |

### Oktale Notation

Berechtigungen können als dreistellige Oktalzahl ausgedrückt werden:

| Oktal | Binär | Bedeutung |
|-------|-------|-----------|
| 7 | 111 | rwx |
| 6 | 110 | rw- |
| 5 | 101 | r-x |
| 4 | 100 | r-- |
| 0 | 000 | --- |

Häufige Berechtigungen:
- `755` — Eigentümer: rwx, Gruppe: r-x, Andere: r-x (typisch für ausführbare Dateien)
- `644` — Eigentümer: rw-, Gruppe: r--, Andere: r-- (typisch für Dateien)
- `700` — Eigentümer: rwx, Gruppe: ---, Andere: --- (privates Verzeichnis)

### Symbolische Links

```bash
ln -s /pfad/zum/original linkname   # Symlink erstellen
ls -la                               # Symlinks werden mit -> angezeigt
```

## Praxisaufgabe

1. Eine Datei `~/demo/script.sh` erstellen und `#!/bin/bash` hinzufügen
2. Ausführbar machen: `chmod +x ~/demo/script.sh`
3. Berechtigungen explizit auf `755` setzen und mit `ls -l` überprüfen
4. Einen Symlink `~/script` erstellen, der auf `~/demo/script.sh` zeigt

## Beispiel-Kommandos

```bash
# Datei erstellen
touch notizen.txt

# Verschachtelte Verzeichnisse erstellen
mkdir -p projekte/demo/src

# Datei kopieren
cp notizen.txt notizen.backup.txt

# Datei verschieben/umbenennen
mv notizen.backup.txt archiv/notizen-2026.txt

# Datei löschen
rm notizen.txt

# Berechtigungen setzen (symbolisch)
chmod +x script.sh        # execute für alle hinzufügen
chmod u+w,g-w datei.txt   # write für User hinzufügen, für Gruppe entfernen

# Berechtigungen setzen (oktal)
chmod 755 script.sh
chmod 644 config.txt

# Eigentümer ändern
chown alice:staff datei.txt

# Symlink erstellen
ln -s /usr/local/bin/python3 ~/bin/python

# Berechtigungen inspizieren
ls -la
stat datei.txt
```

## Typische Fehler

- **`chmod 777` ist fast immer falsch** — es gibt jedem vollen Zugriff; stattdessen `755` oder `644` verwenden
- **`-R` (rekursiv) mit `-r` verwechseln** — bei `chmod` und `chown` `-R` (Großbuchstabe) verwenden
- **Vergessen, dass Verzeichnisse execute (`x`) brauchen, um betreten zu werden** — auch wenn du Leseberechtigung auf ein Verzeichnis hast, kannst du ohne `x` nicht mit `cd` hineinwechseln

> [!WARNING]
> Niemals `chmod 777` auf sensiblen Dateien verwenden. Immer die minimal notwendigen Berechtigungen setzen.

## Checkpoint

- [ ] Ich kann Dateien und Verzeichnisse erstellen, kopieren, verschieben und löschen
- [ ] Ich kann Berechtigungs-Strings wie `rwxr-xr--` lesen
- [ ] Ich kann Berechtigungen mit symbolischer (`chmod +x`) und oktaler Notation (`chmod 755`) setzen
- [ ] Ich verstehe den Unterschied zwischen `chown` und `chmod`

## Definition of Done

Du kannst Dateiberechtigungen für häufige Szenarien (Webserver-Dateien, Scripts, Konfiguration) korrekt setzen und erklären, warum jede Berechtigungsstufe angemessen ist.

## Weiterführende Links

- `man chmod`
- `man chown`
- `man ln`
