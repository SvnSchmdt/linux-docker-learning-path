# Lab 02 – Dateien & Berechtigungen

## Was du baust

Du wirst eine kleine Projektstruktur erstellen, angemessene Berechtigungen für verschiedene Dateitypen setzen, ein Script ausführbar machen und einen Symlink erstellen. Jeden Schritt mit `ls -la` und `stat` überprüfen.

**Verwendete Konzepte:** `touch`, `mkdir`, `cp`, `mv`, `rm`, `chmod`, `chown`, `ln -s`, oktale Berechtigungen.

```
~/lab-permissions/
├── scripts/
│   └── deploy.sh        (chmod 755)
├── config/
│   └── settings.conf    (chmod 644)
├── private/
│   └── secret.key       (chmod 600)
└── deploy -> scripts/deploy.sh   (Symlink)
```

## Ziel

Korrekte Berechtigungen für jeden Dateityp setzen und überprüfen.

## Voraussetzungen

- Modul 02 abgeschlossen

## Schritt-für-Schritt

### Schritt 1: Verzeichnisstruktur erstellen

```bash
mkdir -p ~/lab-permissions/{scripts,config,private}
cd ~/lab-permissions
```

### Schritt 2: Dateien erstellen

```bash
# Deploy-Script erstellen
cat > scripts/deploy.sh << 'EOF'
#!/usr/bin/env bash
echo "Deploying..."
EOF

# Config-Datei erstellen
echo "debug=false" > config/settings.conf

# "Private" Schlüsseldatei erstellen
echo "SUPER_SECRET_KEY=dummy" > private/secret.key

ls -la scripts/ config/ private/
# Erwartete Ausgabe: alle Dateien mit -rw-r--r-- (644) standardmäßig
```

### Schritt 3: Angemessene Berechtigungen setzen

```bash
# Script: Eigentümer kann lesen/schreiben/ausführen, andere können lesen/ausführen
chmod 755 scripts/deploy.sh

# Config: Eigentümer lesen/schreiben, andere nur lesen
chmod 644 config/settings.conf

# Secret: Nur Eigentümer (lesen/schreiben), kein Zugriff für andere
chmod 600 private/secret.key
```

### Schritt 4: Berechtigungen überprüfen

```bash
ls -la scripts/deploy.sh config/settings.conf private/secret.key
# Erwartete Ausgabe:
# -rwxr-xr-x  1 alice alice  32 Jun 30 10:00 scripts/deploy.sh
# -rw-r--r--  1 alice alice  13 Jun 30 10:00 config/settings.conf
# -rw-------  1 alice alice  24 Jun 30 10:00 private/secret.key
```

### Schritt 5: Script ausführen

```bash
./scripts/deploy.sh
# Erwartete Ausgabe:
# Deploying...
```

### Schritt 6: Symlink erstellen

```bash
ln -s scripts/deploy.sh deploy
ls -la deploy
# Erwartete Ausgabe:
# lrwxrwxrwx  1 alice alice  18 Jun 30 10:00 deploy -> scripts/deploy.sh

./deploy
# Erwartete Ausgabe:
# Deploying...
```

### Schritt 7: Execute-Berechtigung entfernen (testen)

```bash
chmod -x scripts/deploy.sh
./scripts/deploy.sh
# Erwartete Ausgabe:
# bash: ./scripts/deploy.sh: Permission denied

# Wiederherstellen
chmod +x scripts/deploy.sh
```

## Validierung

```bash
stat -c "%a %n" scripts/deploy.sh
# Erwartete Ausgabe: 755 scripts/deploy.sh

stat -c "%a %n" private/secret.key
# Erwartete Ausgabe: 600 private/secret.key

test -L deploy && echo "Symlink OK"
# Erwartete Ausgabe: Symlink OK
```

> [!NOTE]
> Auf macOS verwendet `stat` andere Flags: `stat -f "%Mp%Lp %N" dateiname`

## Cleanup

```bash
cd ~
rm -rf ~/lab-permissions
```

## Erweiterungsaufgabe

Ein Verzeichnis `~/lab-permissions/shared/` erstellen, bei dem:
- Der Eigentümer vollen Zugriff hat (rwx)
- Die Gruppe lesen und ausführen kann (r-x)
- Andere keinen Zugriff haben (---)

Hinweis: `chmod 750 shared/`
