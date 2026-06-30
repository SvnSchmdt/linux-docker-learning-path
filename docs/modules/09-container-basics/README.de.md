# Modul 09 – Container-Grundlagen

## Ziel des Moduls

Verstehen, was Container sind, wie sie sich von virtuellen Maschinen unterscheiden und warum sie existieren.

## Warum ist das wichtig?

Container sind die Grundlage moderner Software-Deployments. Bevor du einen einzigen `docker`-Befehl ausführst, musst du verstehen, womit du *eigentlich* arbeitest — sonst lernst du Befehle auswendig, ohne sie zu verstehen. Dieses konzeptuelle Fundament verhindert viele häufige Fehler.

## Kernkonzepte

### Container vs. Virtuelle Maschine

| | Virtuelle Maschine | Container |
|---|---|---|
| Isolation | Vollständiges OS + Hardware-Virtualisierung | Prozessebene (gemeinsamer Kernel) |
| Startzeit | Minuten | Millisekunden |
| Größe | Gigabytes | Megabytes |
| Overhead | Hoch | Niedrig |
| Anwendungsfall | Vollständige OS-Isolation | Anwendungsisolation |

Ein Container ist **keine** VM. Es ist ein isolierter Prozess, der auf dem Host-Kernel läuft und Linux-Kernel-Features nutzt, um isoliert zu erscheinen.

### Wie Container funktionieren

Zwei Kernel-Features machen Container möglich:

**Namespaces** — bieten Isolation:
- `pid` — Prozess-IDs (Container kann Host-Prozesse nicht sehen)
- `net` — Netzwerkinterfaces (Container hat eigene IP)
- `mnt` — Dateisystem-Mount-Points
- `uts` — Hostname
- `user` — Benutzer-IDs

**cgroups (control groups)** — begrenzen Ressourcen:
- CPU-Nutzung
- Arbeitsspeicher-Nutzung
- I/O-Bandbreite

Zusammen: Ein Container-Prozess denkt, er sei allein auf dem System, und hat sein eigenes Netzwerk, Dateisystem und PIDs.

### Image vs. Container

| Image | Container |
|-------|----------|
| Read-only-Vorlage | Laufende Instanz eines Images |
| Wie eine Klassendefinition | Wie ein Objekt/eine Instanz |
| Auf Festplatte gespeichert | Lebt während des Laufens im Arbeitsspeicher |
| Mit `docker build` erstellt | Mit `docker run` erstellt |

### OCI-Standard

Die **Open Container Initiative (OCI)** definiert:
- **Image Spec** — wie Container-Images strukturiert und gespeichert werden
- **Runtime Spec** — wie sich Container-Laufzeiten verhalten müssen

Deshalb funktionieren Docker-Images mit Podman, containerd und Kubernetes — alle implementieren die OCI-Spec.

### Docker vs. Podman

| | Docker | Podman |
|---|---|---|
| Architektur | Daemon-basiert | Daemonlos |
| Root erforderlich | Historisch ja | Nein (rootless) |
| Kompatibilität | OCI-konform | OCI-konform |
| Compose | Docker Compose | Podman Compose |

Für diesen Lernpfad verwenden wir Docker. Die Konzepte lassen sich direkt auf Podman übertragen.

### Container-Lebenszyklus

```
Image (auf Festplatte)
    ↓ docker run
Container (erstellt)
    ↓ Prozess startet
Container (laufend)
    ↓ Prozess beendet / docker stop
Container (gestoppt)
    ↓ docker rm
Container (gelöscht)
```

## Praxisaufgabe

1. `docker info` ausführen und den Storage Driver und die Anzahl laufender Container finden
2. Das `hello-world`-Image pullen: `docker pull hello-world`
3. Ausführen: `docker run hello-world`
4. Anschauen, was passiert ist: `docker ps -a`

## Beispiel-Kommandos

```bash
# Prüfen, ob Docker funktioniert
docker info

# Image pullen
docker pull hello-world

# Container aus diesem Image starten
docker run hello-world

# Erwartete Ausgabe (gekürzt):
# Hello from Docker!
# This message shows that your installation appears to be working correctly.

# Alle Container anzeigen (inkl. gestoppter)
docker ps -a
# Erwartete Ausgabe:
# CONTAINER ID   IMAGE         COMMAND    CREATED        STATUS                    NAMES
# a1b2c3d4e5f6   hello-world   "/hello"   5 Sek. ago    Exited (0) 5 Sek. ago     friendly_newton

# Lokale Images auflisten
docker images
```

## Typische Fehler

- **Container mit VMs verwechseln** — Container teilen sich den Host-Kernel; sie führen kein vollständiges OS aus
- **Image und Container verwechseln** — Container werden FROM Images gestartet; das Image ändert sich nicht
- **Denken, ein gestoppter Container ist weg** — `docker ps -a` zeigt gestoppte Container; sie existieren bis `docker rm`

## Checkpoint

- [ ] Ich kann den Unterschied zwischen Container und VM erklären
- [ ] Ich kann den Unterschied zwischen Image und Container erklären
- [ ] Ich weiß, was Namespaces und cgroups tun (konzeptuell)
- [ ] Ich verstehe den OCI-Standard und warum er wichtig ist

## Definition of Done

Du kannst jemandem erklären, was ein Container ist — ohne zu sagen "es ist wie eine VM, aber leichter."

## Weiterführende Links

- [Docker-Dokumentation: Was ist ein Container?](https://docs.docker.com/get-started/overview/)
- [OCI Image Spec](https://github.com/opencontainers/image-spec)
