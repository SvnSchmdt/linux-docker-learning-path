# Modul 04 – Benutzer & sudo

## Ziel des Moduls

Linux-Benutzerverwaltung verstehen und `sudo` sicher und korrekt verwenden.

## Warum ist das wichtig?

Linux ist ein Mehrbenutzersystem. Zu wissen, wer man ist, welche Berechtigungen man hat und wann/wie man Privilegien erhöht, ist grundlegend für das sichere Arbeiten auf jedem Linux-System. Als root alles auszuführen ist ein häufiger Anfängerfehler mit ernsthaften Sicherheitskonsequenzen.

## Kernkonzepte

### Wer bin ich?

```bash
whoami          # aktueller Benutzername
id              # Benutzer-ID, Gruppen-ID und Gruppenmitgliedschaften
id alice        # Informationen über einen anderen Benutzer
```

### Die Dateien /etc/passwd und /etc/group

```bash
cat /etc/passwd   # Benutzerkonten (Benutzername:x:UID:GID:Kommentar:Home:Shell)
cat /etc/group    # Gruppen (Gruppenname:x:GID:Mitglieder)
```

> [!NOTE]
> Auf modernen Systemen werden Passwörter in `/etc/shadow` gespeichert, nicht in `/etc/passwd`. Das `x` in `/etc/passwd` ist ein Platzhalter.

### sudo — Superuser Do

`sudo` erlaubt autorisierten Benutzern, Befehle als root (oder als ein anderer Benutzer) auszuführen:

```bash
sudo apt update             # als root ausführen
sudo -u postgres psql       # als postgres-Benutzer ausführen
sudo -i                     # Root-Shell öffnen (sparsam verwenden)
```

### su — Benutzer wechseln

```bash
su alice            # zu Benutzer alice wechseln (benötigt alices Passwort)
su -                # zu root mit roots Umgebung wechseln
```

### Benutzerverwaltung

```bash
sudo useradd -m -s /bin/bash neuerbenutzer    # Benutzer mit Home und bash erstellen
sudo passwd neuerbenutzer                      # Passwort setzen
sudo usermod -aG docker alice                  # alice zur docker-Gruppe hinzufügen
sudo userdel -r alterbenutzer                  # Benutzer und Home-Verzeichnis löschen
```

### Principle of Least Privilege

Benutzern nur die Berechtigungen geben, die sie brauchen — nicht mehr. Wichtige Praktiken:

1. Den root-Account nicht für die tägliche Arbeit verwenden
2. `sudo` nur für bestimmte Befehle verwenden, die es benötigen
3. Benutzer nicht zur `sudo`-Gruppe hinzufügen, wenn es nicht notwendig ist
4. Dedizierte Service-Accounts gegenüber der Ausführung als root bevorzugen

## Praxisaufgabe

1. Eigene Benutzer-ID und Gruppenmitgliedschaften mit `id` prüfen
2. Eigenen Eintrag in `/etc/passwd` nachschlagen
3. `sudo whoami` ausführen und die Ausgabe beobachten
4. Eigene sudo-Berechtigungen prüfen: `sudo -l`

## Beispiel-Kommandos

```bash
# Wer bin ich?
whoami
# Erwartete Ausgabe:
# alice

# Vollständige Identitätsinformationen
id
# Erwartete Ausgabe:
# uid=1000(alice) gid=1000(alice) groups=1000(alice),4(adm),27(sudo),999(docker)

# Eintrag des aktuellen Benutzers in passwd anzeigen
grep "^$(whoami):" /etc/passwd

# Einzelnen Befehl als root ausführen
sudo cat /etc/shadow

# Paketlisten aktualisieren (erfordert root auf Debian/Ubuntu)
sudo apt update

# Benutzer zur docker-Gruppe hinzufügen (erforderlich für Docker ohne sudo)
sudo usermod -aG docker $USER
# Hinweis: erfordert Aus- und Einloggen, um wirksam zu werden

# sudo-Berechtigungen prüfen
sudo -l
```

## Typische Fehler

- **`sudo su -` statt `sudo -i`** — beide öffnen eine Root-Shell, aber `sudo -i` ist sauberer
- **Root für alltägliche Aufgaben verwenden** — schafft Risiken; einen normalen Benutzeraccount verwenden
- **`sudo`-Passwort ist DEIN Passwort** — nicht das Root-Passwort (außer root hat ein separates Passwort)
- **Vergessen, sich nach dem Hinzufügen zu einer Gruppe abzumelden** — Gruppenänderungen erfordern eine neue Login-Sitzung

> [!CAUTION]
> `sudo rm -rf /` oder ähnliche destruktive Befehle als root auszuführen kann das System dauerhaft zerstören. Immer doppelt prüfen, was gelöscht wird.

## Checkpoint

- [ ] Ich kenne meine UID, GID und Gruppenmitgliedschaften
- [ ] Ich kann `sudo` für einzelne Befehle verwenden
- [ ] Ich verstehe den Unterschied zwischen `sudo` und `su`
- [ ] Ich weiß, warum die tägliche Arbeit als root eine schlechte Praxis ist

## Definition of Done

Du kannst das Principle of Least Privilege erklären, `sudo` korrekt verwenden und grundlegende Benutzerkonten verwalten.

## Weiterführende Links

- `man sudo`
- `man useradd`
- `man passwd`
- `man visudo` — die sudoers-Datei sicher bearbeiten
