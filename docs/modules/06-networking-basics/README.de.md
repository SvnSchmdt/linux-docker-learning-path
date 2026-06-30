# Modul 06 – Netzwerk-Grundlagen

## Ziel des Moduls

Netzwerkverbindungen testen, HTTP-Anfragen stellen und SSH von der Kommandozeile verwenden.

## Warum ist das wichtig?

Moderne Systeme kommunizieren ständig über Netzwerke. Ob du einen Web-Service debuggst, dich mit einem Remote-Server verbindest oder prüfst, ob ein Container das Internet erreichen kann — du brauchst ein kleines Set von Netzwerk-Werkzeugen. Diese sind auch essenziell für das spätere Verständnis von Docker-Netzwerken.

## Kernkonzepte

### HTTP-Anfragen mit curl

```bash
curl https://example.com                    # GET-Anfrage
curl -I https://example.com                 # nur Header
curl -o ausgabe.html https://example.com    # in Datei speichern
curl -X POST -d '{"key":"val"}' -H 'Content-Type: application/json' https://api.example.com/
curl -v https://example.com                 # ausführlich (zeigt Anfrage + Antwort-Header)
```

### Dateien herunterladen

```bash
wget https://example.com/datei.tar.gz        # Datei herunterladen
curl -L -O https://example.com/datei.tar.gz  # curl-Äquivalent (-L folgt Weiterleitungen)
```

### Verbindung testen

```bash
ping google.com         # Verbindung testen (Ctrl+C zum Stoppen)
ping -c 4 google.com    # genau 4 Pakete senden
```

### Port- und Socket-Informationen

```bash
ss -tlnp            # lauschende TCP-Ports und welcher Prozess sie besitzt
ss -tunp            # alle TCP/UDP-Verbindungen
netstat -tlnp       # älteres Äquivalent (möglicherweise nicht installiert)
```

### DNS-Abfrage

```bash
nslookup google.com         # DNS abfragen
dig google.com              # detaillierte DNS-Abfrage
dig google.com A            # nur A-Records (IPv4)
cat /etc/hosts              # lokale Hostnamen-Überschreibungen
```

### SSH — Secure Shell

```bash
ssh benutzer@hostname                   # mit Remote-Host verbinden
ssh -p 2222 benutzer@hostname           # nicht-standardmäßiger Port
ssh -i ~/.ssh/id_rsa benutzer@hostname  # bestimmte Schlüsseldatei
scp datei.txt benutzer@host:/remote/pfad # Datei auf Remote kopieren
scp benutzer@host:/remote/datei.txt .   # Datei von Remote kopieren
```

### Ports und Protokolle verstehen

Wichtige Ports:

| Port | Protokoll |
|------|-----------|
| 22 | SSH |
| 80 | HTTP |
| 443 | HTTPS |
| 3306 | MySQL |
| 5432 | PostgreSQL |
| 6379 | Redis |
| 8080 | Häufige HTTP-Alternative |

## Praxisaufgabe

1. HTTP-Header von `https://example.com` mit `curl -I` abrufen
2. Herausfinden, welche Ports auf dem eigenen Rechner lauschen: `ss -tlnp`
3. Den A-Record für `docs.docker.com` mit `dig` nachschlagen
4. Die `/etc/hosts`-Datei prüfen

## Beispiel-Kommandos

```bash
# Prüfen, ob ein Web-Server antwortet
curl -I https://example.com
# Erwartete Ausgabe (gekürzt):
# HTTP/2 200
# content-type: text/html; charset=UTF-8
# ...

# DNS-Abfrage
dig google.com +short
# Erwartete Ausgabe:
# 142.250.185.46

# Was lauscht auf Port 8080?
ss -tlnp | grep 8080

# /etc/hosts anzeigen
cat /etc/hosts
# Erwartete Ausgabe (macOS):
# 127.0.0.1       localhost
# 255.255.255.255 broadcasthost
# ::1             localhost
```

## Typische Fehler

- **`ping` durch Firewalls blockiert** — ping wird oft blockiert; stattdessen `curl` oder `nc` zum Testen der Verbindung verwenden
- **`curl` vs `wget`** — beide laden Dateien herunter, aber `curl` ist vielseitiger für API-Tests
- **SSH-Schlüssel-Berechtigungen** — der private Schlüssel muss `chmod 600` sein, sonst verweigert SSH die Verwendung

> [!TIP]
> `curl -v` ist dein bester Freund beim Debuggen von HTTP — es zeigt jeden gesendeten und empfangenen Header.

## Checkpoint

- [ ] Ich kann HTTP-Anfragen mit `curl` stellen und Header prüfen
- [ ] Ich kann mit `ss` prüfen, welche Ports in Verwendung sind
- [ ] Ich kann DNS-Records mit `dig` oder `nslookup` abfragen
- [ ] Ich kann mich mit SSH mit einem Remote-Server verbinden

## Definition of Done

Du kannst grundlegende Netzwerk-Verbindungsprobleme debuggen: testen, ob ein Host erreichbar ist, auf welchem Port er lauscht, und was DNS für einen Hostnamen zurückgibt.

## Weiterführende Links

- `man curl`
- `man ssh`
- `man dig`
- `man ss`
