# Modul 00 – Voraussetzungen

## Ziel des Moduls

Deine Terminal-Umgebung einrichten und die grundlegenden Werkzeuge kennenlernen, die du im gesamten Lernpfad verwenden wirst.

## Warum ist das wichtig?

Alles in Linux und Docker passiert im Terminal. Bevor du Befehle lernst, musst du das Werkzeug bedienen können, mit dem du sie eingibst. Ein gut konfiguriertes Terminal mit Tab-Completion und Zugang zu man-Pages macht den Rest des Lernpfads deutlich schneller.

## Kernkonzepte

### Die Shell

Eine **Shell** ist ein Programm, das deine eingegebenen Befehle liest und ausführt. Die häufigsten Shells sind:

- **bash** (Bourne Again Shell) — Standard auf den meisten Linux-Systemen
- **zsh** (Z Shell) — Standard auf macOS seit Catalina

Beide verhalten sich für alles in diesem Lernpfad identisch.

### Terminal vs. Shell

Das **Terminal** ist das Fenster/die Anwendung, die du öffnest. Die **Shell** ist das Programm, das darin läuft. Wenn du "Terminal.app" auf macOS öffnest, öffnest du ein Terminal, das zsh ausführt.

### man — Das Handbuch

`man` zeigt dir die eingebaute Dokumentation für jeden Befehl:

```bash
man ls
man chmod
man bash
```

Mit Pfeiltasten navigieren, mit `/` suchen, mit `q` beenden.

### --help-Flag

Die meisten Befehle haben ein `--help`-Flag, das eine kurze Nutzungsübersicht anzeigt:

```bash
ls --help
curl --help
```

### Tab-Completion

`Tab` drücken, um Befehlsnamen und Dateipfade automatisch zu vervollständigen:

```bash
ls /etc/hos<Tab>    # vervollständigt zu /etc/hosts
```

`Tab` zweimal drücken, um alle Optionen zu sehen, wenn es mehrere Treffer gibt.

## Praxisaufgabe

1. Terminal öffnen
2. Herausfinden, welche Shell du verwendest: `echo $SHELL`
3. Die man-Page für `ls` öffnen und das Flag zum Anzeigen versteckter Dateien finden
4. Tab-Completion nutzen, um zu `/etc/` zu navigieren und den Inhalt aufzulisten

## Beispiel-Kommandos

```bash
# Welche Shell verwende ich?
echo $SHELL

# Erwartete Ausgabe (macOS):
# /bin/zsh

# Die man-Page für ls öffnen
man ls

# Schnelle Hilfe für einen Befehl
ls --help

# Home-Verzeichnis finden
echo $HOME

# Befehlsverlauf anzeigen
history | tail -20
```

## Typische Fehler

- **Man-Pages sind anfangs schwer zu lesen** — `/Stichwort` zum Suchen in der Seite verwenden, `n` für den nächsten Treffer
- **Tab-Completion funktioniert nicht** — sicherstellen, dass nach dem Befehl ein Leerzeichen steht, bevor du einen Pfad vervollständigst
- **Shell vs. Terminal verwechseln** — das sind verschiedene Dinge, aber in der Praxis wird "Terminal" oft für beides verwendet

## Checkpoint

- [ ] Ich kann ein Terminal auf meinem Rechner öffnen
- [ ] Ich weiß, welche Shell ich verwende (`echo $SHELL`)
- [ ] Ich kann eine man-Page öffnen und darin navigieren
- [ ] Tab-Completion funktioniert für Dateipfade

## Definition of Done

Du bist mit diesem Modul fertig, wenn du eine man-Page öffnen, darin suchen und sie schließen kannst — und Tab-Completion auf deinem System zuverlässig funktioniert.

## Weiterführende Links

- `man bash` — die vollständige bash-Referenz
- `man zshall` — die vollständige zsh-Referenz
- [Homebrew](https://brew.sh/) — macOS-Paketmanager, der in späteren Modulen verwendet wird
