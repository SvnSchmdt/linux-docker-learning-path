# Modul 01 – Linux Navigation

## Ziel des Moduls

Das Linux-Dateisystem sicher über die Kommandozeile navigieren.

## Warum ist das wichtig?

Das Linux-Dateisystem ist die Grundlage für alles andere. Jede Konfigurationsdatei, jedes Log, jede Binary und jedes Home-Verzeichnis hat einen bestimmten Ort in dieser Hierarchie. Zu wissen, wo Dinge liegen — und wie man effizient zwischen ihnen wechselt — ist die erste echte Fähigkeit eines Linux-Benutzers.

## Kernkonzepte

### Der Filesystem Hierarchy Standard (FHS)

Linux organisiert Dateien in einem einzigen Baum, der bei `/` (Root) beginnt:

| Verzeichnis | Zweck |
|-------------|-------|
| `/` | Wurzel des gesamten Dateisystems |
| `/home` | Benutzer-Home-Verzeichnisse (`/home/alice`) |
| `/etc` | System-Konfigurationsdateien |
| `/var` | Variable Daten: Logs, Datenbanken, Caches |
| `/tmp` | Temporäre Dateien (werden beim Neustart gelöscht) |
| `/usr` | User-Space-Programme und Bibliotheken |
| `/bin`, `/sbin` | Wichtige System-Binaries |
| `/opt` | Optionale/Drittanbieter-Software |
| `/proc`, `/sys` | Virtuelle Dateisysteme (Kernel-Daten, Hardware-Info) |

### Absolute vs. relative Pfade

- **Absoluter Pfad**: beginnt mit `/`, verweist immer auf denselben Ort: `/home/alice/projects`
- **Relativer Pfad**: beginnt vom aktuellen Verzeichnis: `projects/demo` (relativ zu `/home/alice`)

### Versteckte Dateien

Dateien, die mit `.` beginnen, sind standardmäßig versteckt:

```bash
ls -a    # zeigt versteckte Dateien
ls -la   # Langformat + versteckte Dateien
```

## Praxisaufgabe

1. Herausfinden, wo du bist: `pwd`
2. Das Root-Verzeichnis auflisten: `ls /`
3. Zu `/etc` navigieren und zurück nach Hause: `cd /etc && cd ~`
4. Alle versteckten Dateien im Home-Verzeichnis finden: `ls -la ~`
5. `tree` zum Visualisieren eines Verzeichnisses verwenden (auf macOS mit `brew install tree` installieren)

## Beispiel-Kommandos

```bash
# Wo bin ich?
pwd
# Erwartete Ausgabe:
# /home/alice

# Aktuelles Verzeichnis auflisten (Langformat, lesbare Größen, versteckte Dateien)
ls -lah

# Zum Home-Verzeichnis navigieren (drei gleichwertige Wege)
cd ~
cd $HOME
cd

# Eine Ebene nach oben navigieren
cd ..

# Zum vorherigen Verzeichnis navigieren
cd -

# Verzeichnisbaum anzeigen (3 Ebenen tief)
tree -L 3 /etc

# Versteckte Dateien im Home finden
ls -la ~ | grep '^\.'
```

## Typische Fehler

- **`/` (Root-Verzeichnis) mit dem Home des Root-Benutzers verwechseln** — das Home des Root-Benutzers ist `/root`, nicht `/`
- **Vergessen, dass Pfade Groß-/Kleinschreibung beachten** — `/etc/Hosts` und `/etc/hosts` sind verschiedene Dateien
- **`cd` ohne Pfad verwenden** — das bringt dich nach Hause, nicht zum vorherigen Verzeichnis (`cd -` macht das)

## Checkpoint

- [ ] Ich kann zu jedem absoluten Pfad navigieren, ohne mich zu verirren
- [ ] Ich verstehe den Unterschied zwischen absoluten und relativen Pfaden
- [ ] Ich weiß, was in `/etc`, `/var`, `/tmp` und `/home` zu finden ist
- [ ] Ich kann versteckte Dateien mit `ls -a` finden

## Definition of Done

Du kannst das Linux-Dateisystem ohne Zögern navigieren, erklären, wo häufige Verzeichnisse liegen, und Dateien mit absoluten wie relativen Pfaden finden.

## Weiterführende Links

- `man hier` — Beschreibung der Dateisystem-Hierarchie
- `man ls` — alle ls-Flags
- [Filesystem Hierarchy Standard](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)
