# Lab 00 – Terminal Setup

## Was du baust

Du konfigurierst deine Shell-Umgebung für produktives Arbeiten in der Kommandozeile: eine `.bashrc`/`.zshrc` mit nützlichen Aliases, ein korrekt gesetzter `PATH` und überprüfter Zugang zu `man`-Pages und Tab-Completion.

**Verwendete Konzepte:** Shell-Konfiguration, PATH, Aliases, man-Pages, Tab-Completion.

```
┌─────────────────────────────────────┐
│ Terminal (iTerm2 / Terminal.app)    │
│  ┌───────────────────────────────┐  │
│  │ Shell (bash / zsh)            │  │
│  │  ~/.bashrc oder ~/.zshrc      │  │
│  │  • Aliases                    │  │
│  │  • PATH-Einträge              │  │
│  │  • Prompt-Einstellungen       │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

## Ziel

Eine produktive Shell-Umgebung konfigurieren, die du während des gesamten Lernpfads verwenden wirst.

## Voraussetzungen

- Ein macOS- oder Linux-Rechner mit Terminal
- bash oder zsh als Shell (mit `echo $SHELL` prüfen)

## Schritt-für-Schritt

### Schritt 1: Config-Datei der Shell identifizieren

```bash
echo $SHELL
# Erwartete Ausgabe:
# /bin/zsh   (macOS Standard)
# /bin/bash  (viele Linux-Systeme)
```

- zsh-Benutzer: `~/.zshrc` bearbeiten
- bash-Benutzer: `~/.bashrc` bearbeiten

### Schritt 2: Nützliche Aliases hinzufügen

Die Config-Datei öffnen und folgendes hinzufügen:

```bash
# Navigations-Shortcuts
alias ll='ls -lah'
alias la='ls -lah'
alias ..='cd ..'
alias ...='cd ../..'

# Sicherheitsnetze
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Git-Shortcuts (später nützlich)
alias gs='git status'
alias gl='git log --oneline -10'
```

### Schritt 3: PATH prüfen

```bash
echo $PATH
# Erwartete Ausgabe (macOS mit Homebrew):
# /opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

Homebrew-Binaries sollten vor `/usr/bin` erscheinen. Falls nicht, zur Config hinzufügen:

```bash
# macOS mit Apple Silicon
export PATH="/opt/homebrew/bin:$PATH"
# macOS mit Intel
export PATH="/usr/local/bin:$PATH"
```

### Schritt 4: Config neu laden

```bash
source ~/.zshrc   # oder source ~/.bashrc
```

### Schritt 5: Aliases prüfen

```bash
ll
# Erwartete Ausgabe: Langauflistung des aktuellen Verzeichnisses mit versteckten Dateien
# drwxr-xr-x  ...  .
# drwxr-xr-x  ...  ..
# ...
```

### Schritt 6: man-Pages prüfen

```bash
man ls | head -5
# Erwartete Ausgabe:
# LS(1)             General Commands Manual
#
# NAME
#      ls – list directory contents
```

## Validierung

```bash
# Alle diese sollten funktionieren:
ll                          # Alias für ls -lah
echo $PATH | grep -q bin && echo "PATH OK"
man ls > /dev/null && echo "man-Pages OK"
type ll                     # sollte zeigen: ll is an alias for ls -lah
```

## Cleanup

Kein Cleanup nötig — das sind dauerhafte Shell-Konfigurationsänderungen, die du behalten möchtest.

## Erweiterungsaufgabe

Einen leistungsfähigeren Prompt installieren und konfigurieren:
- **starship** (`brew install starship`) — Shell-übergreifend, zeigt Git-Status und mehr
- Der [Quickstart](https://starship.rs/guide/) erklärt, wie man es zur Config hinzufügt
