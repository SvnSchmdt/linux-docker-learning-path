# Modul 14 – Registry & Distribution

## Ziel des Moduls

Docker-Images in Container-Registries taggen, pushen und pullen.

## Warum ist das wichtig?

Ein auf deinem Laptop gebautes Image ist nutzlos, wenn du es nicht auf einen Server, zu einem Kollegen oder in eine CI/CD-Pipeline bringen kannst. Registries sind der Distributionsmechanismus für Container-Images — wie npm für Node-Pakete oder PyPI für Python-Pakete, aber für Docker-Images.

## Kernkonzepte

### Image-Namens-Konvention

```
registry/user/image:tag
│         │    │      └── Version oder Label (Standard: latest)
│         │    └───────── Image-Name
│         └────────────── Benutzername oder Organisation
└──────────────────────── Registry-Hostname (Standard: docker.io)
```

Beispiele:
```
nginx:alpine                          → docker.io/library/nginx:alpine
alice/myapp:v1.2.3                    → docker.io/alice/myapp:v1.2.3
ghcr.io/alice/myapp:sha-a1b2c3d       → GitHub Container Registry
registry.example.com/team/app:latest  → Private Registry
```

### Images taggen

```bash
# Vorhandenes Image taggen
docker tag myapp:v1 alice/myapp:v1
docker tag myapp:v1 alice/myapp:latest
docker tag myapp:v1 ghcr.io/alice/myapp:v1
```

### Zu Docker Hub pushen

```bash
# Anmelden
docker login

# Pushen
docker push alice/myapp:v1
docker push alice/myapp:latest
```

### GitHub Container Registry (GHCR)

```bash
# Personal Access Token mit 'write:packages'-Scope erstellen
# Dann anmelden:
echo $GITHUB_TOKEN | docker login ghcr.io -u BENUTZERNAME --password-stdin

# Taggen und pushen
docker tag myapp:v1 ghcr.io/alice/myapp:v1
docker push ghcr.io/alice/myapp:v1
```

### Images pullen

```bash
docker pull nginx:alpine                    # bestimmten Tag pullen
docker pull nginx                           # pullt :latest
docker pull ghcr.io/alice/myapp:v1          # von GHCR
```

### docker scout (Einführung)

Docker Scout analysiert Images auf bekannte Schwachstellen:

```bash
docker scout cves nginx:alpine              # auf CVEs prüfen
docker scout recommendations nginx:alpine   # besseres Basis-Image vorschlagen
```

## Praxisaufgabe

1. Ein einfaches Image aus dem Modul-10-Beispiel bauen
2. Mit dem eigenen Docker-Hub-Benutzernamen taggen: `docker tag hello-python:v1 DEIN_USER/hello-python:v1`
3. Pushen: `docker push DEIN_USER/hello-python:v1`
4. Auf einem frischen Rechner pullen (oder lokales Image zuerst entfernen): `docker pull DEIN_USER/hello-python:v1`

## Beispiel-Kommandos

```bash
# Prüfen, welche Images lokal vorhanden sind
docker images
# Erwartete Ausgabe:
# REPOSITORY      TAG    IMAGE ID       CREATED       SIZE
# hello-python    v1     a1b2c3d4e5f6   2 Std. ago   151MB

# Für Docker Hub taggen
docker tag hello-python:v1 alice/hello-python:v1

# Anmelden (fragt nach Passwort)
docker login

# Pushen
docker push alice/hello-python:v1
# Erwartete Ausgabe:
# The push refers to repository [docker.io/alice/hello-python]
# v1: digest: sha256:abc123... size: 1234

# Lokales Image entfernen und neu pullen zur Überprüfung
docker rmi alice/hello-python:v1
docker pull alice/hello-python:v1
```

## Typische Fehler

- **`latest` ohne versionierten Tag pushen** — immer mit Version UND latest taggen; niemals nur latest allein
- **Vergessen, sich vor dem Push anzumelden** — `docker push` schlägt mit "access denied" fehl
- **Keine Registry angeben** — ohne Präfix nimmt Docker Docker Hub an

> [!TIP]
> Semantic Versioning für Image-Tags verwenden: `v1.0.0`, `v1.0.1`, etc. Nur `latest` zu verwenden macht es unmöglich, auf eine bestimmte Version zurückzurollen.

## Checkpoint

- [ ] Ich verstehe die Image-Namens-Konvention (registry/user/image:tag)
- [ ] Ich kann ein Image für Docker Hub oder GHCR taggen
- [ ] Ich kann Images pushen und pullen
- [ ] Ich verstehe, warum `latest` allein nicht ausreicht

## Definition of Done

Du kannst ein Image bauen, korrekt taggen, in eine Registry pushen und wieder pullen — und damit den vollständigen Distributions-Workflow demonstrieren.

## Weiterführende Links

- [Docker Hub](https://hub.docker.com/)
- [GitHub Container Registry Dokumentation](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [docker scout Dokumentation](https://docs.docker.com/scout/)
