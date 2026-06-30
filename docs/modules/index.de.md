# Module

16 strukturierte Module zu Linux-Grundlagen und Docker — von den Voraussetzungen bis zu produktionsreifen Container-Patterns.

## Linux-Grundlagen (Module 00–08)

| Modul | Thema |
|-------|-------|
| [00 – Voraussetzungen](00-prerequisites/README.md) | Terminal, Shell, man-Pages, Tab-Completion |
| [01 – Linux Navigation](01-linux-navigation/README.md) | Dateisystem-Hierarchie, pwd, ls, cd, tree |
| [02 – Dateien & Berechtigungen](02-files-and-permissions/README.md) | chmod, chown, rwx, Symlinks |
| [03 – Textverarbeitung](03-text-processing/README.md) | grep, Pipes, Redirects, find |
| [04 – Benutzer & sudo](04-users-and-sudo/README.md) | Benutzerverwaltung, sudo, Principle of Least Privilege |
| [05 – Prozesse & System](05-processes-and-system/README.md) | ps, kill, systemctl, df, free |
| [06 – Netzwerk-Grundlagen](06-networking-basics/README.md) | curl, ssh, Ports, DNS |
| [07 – Paketverwaltung](07-package-management/README.md) | apt, dnf, Homebrew |
| [08 – Shell Scripting](08-shell-scripting/README.md) | Variablen, Schleifen, Funktionen, Exit-Codes |

## Docker & Container (Module 09–15)

| Modul | Thema |
|-------|-------|
| [09 – Container-Grundlagen](09-container-basics/README.md) | Container vs. VMs, Namespaces, OCI |
| [10 – Dockerfile & Build](10-dockerfile-and-build/README.md) | FROM, RUN, COPY, Layer-Caching |
| [11 – Container betreiben](11-running-containers/README.md) | docker run Flags, Logs, exec |
| [12 – Volumes & Netzwerke](12-volumes-and-networking/README.md) | Bind Mounts, Named Volumes, Bridge-Netzwerke |
| [13 – Docker Compose](13-docker-compose/README.md) | docker-compose.yml, Services, .env-Dateien |
| [14 – Registry & Distribution](14-registry-and-distribution/README.md) | docker push, Docker Hub, GHCR, Tagging |
| [15 – Production Patterns](15-production-patterns/README.md) | Multi-Stage, Non-Root-User, HEALTHCHECK |
