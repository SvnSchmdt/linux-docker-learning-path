# Lab 03 – Textverarbeitung

## Was du baust

Du wirst eine realistische Log-Datei generieren und sie dann mit einer Pipeline aus `grep`, `sort`, `uniq`, `wc` und `find` analysieren. Das Ziel ist es, aus rohen Textdaten mit ausschließlich Kommandozeilen-Werkzeugen sinnvolle Informationen zu extrahieren.

**Verwendete Konzepte:** `cat`, `grep`, `sort`, `uniq`, `wc`, `find`, Pipes `|`, Redirects `>`.

```
access.log (roh)
    │
    ├─ grep (nach Status filtern)
    ├─ sort (alphabetisch)
    ├─ uniq -c (Duplikate zählen)
    ├─ sort -rn (nach Anzahl sortieren)
    └─ head -10 (Top 10)
         │
         └→ report.txt
```

## Ziel

Eine mehrstufige Pipeline bauen, die die 10 häufigsten IP-Adressen aus einem Access-Log extrahiert.

## Voraussetzungen

- Modul 03 abgeschlossen

## Schritt-für-Schritt

### Schritt 1: Beispiel-Log-Datei generieren

```bash
mkdir -p ~/lab-textprocessing
cat > ~/lab-textprocessing/access.log << 'EOF'
192.168.1.10 - - [30/Jun/2026:10:00:01 +0000] "GET /index.html HTTP/1.1" 200 1234
10.0.0.5 - - [30/Jun/2026:10:00:02 +0000] "POST /api/login HTTP/1.1" 401 89
192.168.1.10 - - [30/Jun/2026:10:00:03 +0000] "GET /about.html HTTP/1.1" 200 567
172.16.0.3 - - [30/Jun/2026:10:00:04 +0000] "GET /index.html HTTP/1.1" 200 1234
10.0.0.5 - - [30/Jun/2026:10:00:05 +0000] "POST /api/login HTTP/1.1" 401 89
192.168.1.10 - - [30/Jun/2026:10:00:06 +0000] "GET /contact.html HTTP/1.1" 200 890
10.0.0.7 - - [30/Jun/2026:10:00:07 +0000] "GET /index.html HTTP/1.1" 200 1234
10.0.0.5 - - [30/Jun/2026:10:00:08 +0000] "POST /api/login HTTP/1.1" 200 45
192.168.1.10 - - [30/Jun/2026:10:00:09 +0000] "GET /index.html HTTP/1.1" 304 0
172.16.0.3 - - [30/Jun/2026:10:00:10 +0000] "GET /api/data HTTP/1.1" 500 23
EOF
```

### Schritt 2: Gesamtzeilen zählen

```bash
wc -l ~/lab-textprocessing/access.log
# Erwartete Ausgabe:
# 10 /home/alice/lab-textprocessing/access.log
```

### Schritt 3: Alle 4xx- und 5xx-Fehler finden

```bash
grep -E '" [45][0-9][0-9] ' ~/lab-textprocessing/access.log
# Erwartete Ausgabe:
# 10.0.0.5 ... "POST /api/login HTTP/1.1" 401 89
# 10.0.0.5 ... "POST /api/login HTTP/1.1" 401 89
# 172.16.0.3 ... "GET /api/data HTTP/1.1" 500 23
```

### Schritt 4: Fehler nach Status-Code zählen

```bash
grep -oE '" [45][0-9][0-9] ' ~/lab-textprocessing/access.log | \
  tr -d '" ' | sort | uniq -c | sort -rn
# Erwartete Ausgabe:
#       2 401
#       1 500
```

### Schritt 5: Top-IPs nach Anfragezahl finden

```bash
grep -oE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' ~/lab-textprocessing/access.log | \
  sort | uniq -c | sort -rn | head -5
# Erwartete Ausgabe:
#       4 192.168.1.10
#       3 10.0.0.5
#       2 172.16.0.3
#       1 10.0.0.7
```

### Schritt 6: Bericht in Datei speichern

```bash
{
  echo "=== Access Log Bericht ==="
  echo "Gesamtanfragen: $(wc -l < ~/lab-textprocessing/access.log)"
  echo ""
  echo "Top-IPs:"
  grep -oE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' ~/lab-textprocessing/access.log | \
    sort | uniq -c | sort -rn
  echo ""
  echo "Fehler-Antworten:"
  grep -E '" [45][0-9][0-9] ' ~/lab-textprocessing/access.log | wc -l
} > ~/lab-textprocessing/report.txt

cat ~/lab-textprocessing/report.txt
```

## Validierung

```bash
test -f ~/lab-textprocessing/report.txt && echo "Bericht-Datei OK"
grep -q "192.168.1.10" ~/lab-textprocessing/report.txt && echo "Top-IP im Bericht gefunden"
```

## Cleanup

```bash
rm -rf ~/lab-textprocessing
```

## Erweiterungsaufgabe

Alle eindeutigen angefragten URLs im Log finden und zählen:

```bash
grep -oE '"(GET|POST|PUT|DELETE) [^ ]+' ~/lab-textprocessing/access.log | \
  sort | uniq -c | sort -rn
```
