# Troubleshooting-Übungen

Kaputte Szenarien zum Diagnostizieren und Beheben. Jedes hat ein Symptom — Ursache und Lösung herausfinden.

## Linux-Troubleshooting

**Szenario 1: Permission Denied**

Du hast ein Script `deploy.sh` und versuchst es auszuführen:
```
./deploy.sh: Permission denied
```
Was prüfst du zuerst? Was ist die Lösung?

<details>
<summary>Lösung</summary>

Berechtigungen prüfen: `ls -la deploy.sh`
Wenn die Ausgabe `-rw-r--r--` zeigt, ist die Datei nicht ausführbar.
Lösung: `chmod +x deploy.sh`
</details>

---

**Szenario 2: Festplatte voll**

Deine Anwendung hört auf, Logs zu schreiben mit dem Fehler "No space left on device".

Welche Befehle führst du zur Diagnose aus? Wie findest du, welches Verzeichnis den meisten Platz verbraucht?

<details>
<summary>Lösung</summary>

```bash
df -h          # Welches Dateisystem ist voll?
du -sh /*      # Speichernutzung auf oberster Ebene
du -sh /var/*  # In /var hineinbohren
# Meistens: /var/log ist voll von alten Logs
# Große Log-Dateien finden:
find /var/log -name "*.log" -size +100M
# Drehen oder abschneiden: > /var/log/grosse.log (auf null abschneiden)
```
</details>

---

## Docker-Troubleshooting

**Szenario 3: Container beendet sich sofort**

```bash
docker run myapp
# Container-ID ausgegeben, dann nichts
docker ps
# myapp wird nicht aufgeführt
```
Wie findest du heraus, warum?

<details>
<summary>Lösung</summary>

```bash
docker ps -a           # zeigt gestoppte Container
docker logs <id>       # zeigt, was der Prozess vor dem Beenden ausgegeben hat
# Häufige Ursachen:
# - CMD zeigt auf eine nicht existierende Datei
# - Anwendung ist abgestürzt (Stack-Trace in Logs prüfen)
# - Fehlende Umgebungsvariable
```
</details>

---

**Szenario 4: Port bereits in Verwendung**

```bash
docker run -p 8080:80 nginx
# Fehler: ... bind: address already in use
```

Wie findest du heraus, was Port 8080 verwendet, und behebst es?

<details>
<summary>Lösung</summary>

```bash
ss -tlnp | grep 8080   # Prozess finden, der Port 8080 verwendet
# oder
lsof -i :8080           # macOS-Alternative

# Optionen:
# 1. Den konfliktierenden Prozess stoppen
# 2. Einen anderen Host-Port verwenden: docker run -p 8081:80 nginx
```
</details>

---

**Szenario 5: Container kann Datenbank nicht erreichen**

Die Logs deines App-Containers zeigen:
```
Connection refused: db:5432
```

Beide Container laufen. Was ist falsch?

<details>
<summary>Lösung</summary>

Die Container sind wahrscheinlich NICHT im selben Docker-Netzwerk, oder der Container-Name stimmt nicht überein.

```bash
docker inspect app_container | grep Networks
docker inspect db_container | grep Networks
# Wenn unterschiedliche Netzwerke: gemeinsames Netzwerk erstellen und beide verbinden
docker network create appnet
docker network connect appnet app_container
docker network connect appnet db_container
```

Auch den Datenbank-Container-Namen prüfen, ob er mit dem übereinstimmt, was die App erwartet (`db` in diesem Fall).
</details>

---

**Szenario 6: Image-Build schlägt fehl**

```
ERROR [3/5] RUN pip install -r requirements.txt
...
ERROR: Could not find a version that satisfies the requirement flask==99.0.0
```

Was ist schiefgegangen? Wie behebst du es?

<details>
<summary>Lösung</summary>

Die `requirements.txt` gibt eine nicht existierende Version an (`flask==99.0.0`).
Lösung: Die Version in `requirements.txt` korrigieren (z.B. `flask==3.0.3`).

Um die richtige Version zu finden:
```bash
pip index versions flask  # zeigt verfügbare Versionen
```
</details>
