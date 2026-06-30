# Modul 07 – Paketverwaltung

## Ziel des Moduls

Software-Pakete auf Debian/Ubuntu, Fedora/RHEL und macOS installieren, aktualisieren und entfernen.

## Warum ist das wichtig?

Jedes Werkzeug, das du verwendest — git, curl, Docker, Python, Node.js — wird über einen Paketmanager installiert. Zu wissen, wie man den Paketmanager des Systems korrekt verwendet (und warum man ihn nicht umgehen sollte), ist eine grundlegende Betriebsfähigkeit.

## Kernkonzepte

### apt — Debian/Ubuntu

```bash
sudo apt update                   # Paketlisten aktualisieren (immer zuerst ausführen!)
sudo apt upgrade                  # alle installierten Pakete aktualisieren
sudo apt install curl             # Paket installieren
sudo apt install curl git vim     # mehrere Pakete installieren
sudo apt remove curl              # Paket entfernen (Konfigurationsdateien behalten)
sudo apt purge curl               # Paket + Konfigurationsdateien entfernen
sudo apt search nginx             # nach Paket suchen
apt show nginx                    # Paketdetails anzeigen
apt list --installed              # alle installierten Pakete auflisten
```

> [!IMPORTANT]
> Immer `sudo apt update` ausführen, bevor du etwas installierst. Ohne Update verwendet apt einen veralteten lokalen Cache und installiert möglicherweise veraltete Versionen oder findet Pakete nicht.

### dnf/yum — Fedora/RHEL/CentOS

```bash
sudo dnf update                   # alle Pakete aktualisieren
sudo dnf install curl             # Paket installieren
sudo dnf remove curl              # Paket entfernen
sudo dnf search nginx             # suchen
sudo dnf info nginx               # Paketdetails
```

`yum` ist das ältere Äquivalent auf CentOS 7 und RHEL 7. Auf modernen Systemen `dnf` bevorzugen.

### Homebrew — macOS

```bash
brew install curl                 # Paket installieren
brew update                       # Homebrew selbst aktualisieren
brew upgrade                      # alle installierten Pakete aktualisieren
brew upgrade curl                 # bestimmtes Paket aktualisieren
brew uninstall curl               # Paket entfernen
brew search nginx                 # suchen
brew info nginx                   # Paketdetails
brew list                         # installierte Pakete auflisten
brew doctor                       # Probleme diagnostizieren
```

### Warum NICHT `sudo pip install` auf dem System-Python

Python-Pakete mit `sudo pip install` zu installieren, verändert die System-Python-Installation, was:

- System-Werkzeuge beschädigen kann, die von bestimmten Paketversionen abhängen
- Mit von `apt`/`dnf` installierten Paketen in Konflikt geraten kann
- Bei System-Updates überschrieben werden kann

**Stattdessen immer virtuelle Umgebungen verwenden:**

```bash
python3 -m venv .venv           # virtuelle Umgebung erstellen
source .venv/bin/activate        # aktivieren
pip install requests             # im venv installieren (kein sudo!)
deactivate                       # deaktivieren
```

## Praxisaufgabe

1. Paketlisten aktualisieren (den richtigen Befehl für das eigene Betriebssystem verwenden)
2. `tree` installieren und prüfen, ob es installiert ist: `tree --version`
3. Nach dem Paket `htop` suchen, ohne es zu installieren
4. Auf macOS: `jq` mit Homebrew installieren

## Beispiel-Kommandos

```bash
# Ubuntu: tree und jq installieren
sudo apt update && sudo apt install -y tree jq

# Installation überprüfen
tree --version
# Erwartete Ausgabe:
# tree v2.1.1 © 1996 - 2022 by Steve Baker, Thomas Moore, Francesc Robles Molina

# macOS: mit Homebrew installieren
brew install tree jq

# Installierte Pakete prüfen (Ubuntu)
apt list --installed | grep tree

# Installierte Pakete prüfen (macOS)
brew list | grep tree
```

## Typische Fehler

- **`apt install` ohne vorheriges `apt update`** — veraltete Paketlisten werden verwendet
- **Paketmanager für dasselbe Werkzeug mischen** — Python nicht mit `apt` und `pyenv` installieren; einen wählen
- **`sudo pip install`** — stattdessen virtuelle Umgebungen verwenden
- **Aus Quellcode installieren, wenn ein Paket vorhanden ist** — zuerst den Paketmanager prüfen

## Checkpoint

- [ ] Ich kann Pakete mit dem Paketmanager meines Systems installieren und entfernen
- [ ] Ich führe immer `update` vor `install` aus
- [ ] Ich weiß, warum `sudo pip install` problematisch ist
- [ ] Ich kann nach Paketen suchen, ohne sie zu installieren

## Definition of Done

Du kannst jedes Software-Werkzeug über den Paketmanager deines Systems installieren und erklären, warum das Umgehen des Paketmanagers meist eine schlechte Idee ist.

## Weiterführende Links

- `man apt`
- `man dnf`
- [Homebrew Dokumentation](https://docs.brew.sh/)
