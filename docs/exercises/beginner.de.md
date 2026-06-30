# Beginner-Übungen

Nach den Modulen 00–04 abschließen. Jede Aufgabe ohne Blick in die Modul-Notizen lösen.

## Linux Navigation

**Übung 1:** Alle Verzeichnisse in `/etc` finden, die mit dem Buchstaben `s` beginnen. Wie viele gibt es?

**Übung 2:** Zu `/var/log` navigieren und die drei größten Dateien dort finden.

**Übung 3:** Die folgende Verzeichnisstruktur mit einem Befehl erstellen:
```
~/practice/
├── web/
├── api/
└── data/
    ├── raw/
    └── processed/
```

## Dateien & Berechtigungen

**Übung 4:** Eine Datei `~/practice/web/index.html` mit dem Inhalt `<h1>Hallo</h1>` erstellen. Berechtigungen auf `644` setzen.

**Übung 5:** Ein Script `~/practice/api/start.sh` mit Inhalt `echo "API startet"` erstellen. Ausführbar machen. Mit `ls -la` verifizieren.

**Übung 6:** Einen Symlink `~/practice/current` erstellen, der auf `~/practice/web` zeigt. Dann `ls -la ~/practice/current/` ausführen.

## Textverarbeitung

**Übung 7:** Zählen, wie viele Dateien (keine Verzeichnisse) in `/etc` vorhanden sind. `find` und `wc` verwenden.

**Übung 8:** Alle Zeilen in `/etc/hosts` finden, die NICHT mit `#` beginnen. (Hinweis: `grep -v`)

**Übung 9:** Eine Datei `~/practice/data/raw/zahlen.txt` mit den Zahlen 5, 3, 8, 1, 9, 2, 7, 4, 6 erstellen (eine pro Zeile). Numerisch sortieren und in `~/practice/data/processed/sortiert.txt` speichern.

## Benutzer & sudo

**Übung 10:** Den eigenen Benutzernamen, die UID und alle Gruppen, zu denen man gehört, mit einem Befehl anzeigen.

**Übung 11:** `sudo whoami` ausführen und erklären, was die Ausgabe bedeutet.

**Übung 12:** Den eigenen Eintrag in `/etc/passwd` finden und identifizieren: das Home-Verzeichnis und die Standard-Shell.

---

**Cleanup:**
```bash
rm -rf ~/practice
```
