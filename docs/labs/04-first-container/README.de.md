# Lab 04 – Erster Container

## Was du baust

Du wirst ein nginx-Image pullen, es mit Port-Mapping starten, Logs inspizieren, Befehle innerhalb des Containers ausführen und ihn sauber entfernen. Das ist der grundlegende Docker-Workflow, den du ständig verwenden wirst.

**Verwendete Konzepte:** `docker pull`, `docker run`, `docker ps`, `docker logs`, `docker exec`, `docker stop`, `docker rm`.

```
Dein Rechner
┌─────────────────────────────────────┐
│  localhost:8080                     │
│      │                              │
│  ┌───▼───────────────────────────┐  │
│  │  Container: web               │  │
│  │  Image: nginx:alpine          │  │
│  │  Port: 80 (innen)             │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
        curl http://localhost:8080
```

## Ziel

nginx in einem Docker-Container betreiben und prüfen, ob er HTTP-Traffic bedient.

## Voraussetzungen

- Docker Desktop installiert und laufend
- Modul 10 abgeschlossen (Konzepte)

## Schritt-für-Schritt

### Schritt 1: nginx-Image pullen

```bash
docker pull nginx:alpine
# Erwartete Ausgabe:
# alpine: Pulling from library/nginx
# ...
# Status: Downloaded newer image for nginx:alpine
# docker.io/library/nginx:alpine
```

### Schritt 2: Container starten

```bash
docker run -d --name web -p 8080:80 nginx:alpine
# Erwartete Ausgabe:
# 3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b (Container-ID)
```

### Schritt 3: Laufenden Container prüfen

```bash
docker ps
# Erwartete Ausgabe:
# CONTAINER ID   IMAGE          COMMAND                  PORTS                  NAMES
# 3a4b5c6d7e8f   nginx:alpine   "/docker-entrypoint.…"   0.0.0.0:8080->80/tcp   web
```

### Schritt 4: Web-Server testen

```bash
curl http://localhost:8080
# Erwartete Ausgabe (gekürzt):
# <!DOCTYPE html>
# <html>
# <head>
# <title>Welcome to nginx!</title>
# ...
```

### Schritt 5: Access-Logs lesen

```bash
docker logs web
# Erwartete Ausgabe (nach dem curl oben):
# /docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
# /docker-entrypoint.sh: Configuration complete; ready for start up
# 172.17.0.1 - - [30/Jun/2026:10:00:01 +0000] "GET / HTTP/1.1" 200 615 "-" "curl/8.4.0" "-"
```

### Schritt 6: Befehl im Container ausführen

```bash
docker exec web ls /etc/nginx/conf.d/
# Erwartete Ausgabe:
# default.conf

docker exec -it web sh
# Du bist jetzt im Container:
# / # whoami
# root
# / # cat /etc/nginx/conf.d/default.conf
# / # exit
```

### Schritt 7: Container inspizieren

```bash
docker inspect web | grep -A 5 '"IPAddress"'
# Erwartete Ausgabe (gekürzt):
# "IPAddress": "172.17.0.2",
```

### Schritt 8: Stoppen und entfernen

```bash
docker stop web
# Erwartete Ausgabe: web

docker rm web
# Erwartete Ausgabe: web

docker ps -a | grep web
# Erwartete Ausgabe: (leer — Container ist weg)
```

## Validierung

```bash
# Nach Cleanup: kein 'web'-Container sollte existieren
docker ps -a --filter "name=web" --format "{{.Names}}"
# Erwartete Ausgabe: (leer)

# Das Image sollte noch lokal gecacht sein
docker images nginx:alpine
# Erwartete Ausgabe:
# REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
# nginx        alpine    ...            ...           ...
```

## Cleanup

```bash
# Image entfernen, wenn du einen Clean Slate möchtest
docker rmi nginx:alpine
```

## Erweiterungsaufgabe

Zwei nginx-Container gleichzeitig auf verschiedenen Ports starten:

```bash
docker run -d --name web1 -p 8080:80 nginx:alpine
docker run -d --name web2 -p 8081:80 nginx:alpine
curl http://localhost:8080
curl http://localhost:8081
docker stop web1 web2 && docker rm web1 web2
```
