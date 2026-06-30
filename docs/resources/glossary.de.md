# Glossar

| Begriff | Definition |
|---------|-----------|
| **Alpine** | Eine minimale Linux-Distribution (~5 MB), die häufig als Docker-Basis-Image verwendet wird |
| **Bind Mount** | Ein Host-Verzeichnis in einen Container einbinden (`-v /host/pfad:/container/pfad`) |
| **cgroups** | Linux-Kernel-Feature, das die Ressourcennutzung (CPU, Arbeitsspeicher) für eine Gruppe von Prozessen begrenzt |
| **CMD** | Dockerfile-Anweisung: der Standard-Befehl, der beim Start eines Containers ausgeführt wird |
| **Container** | Ein isolierter Prozess, der auf dem Host-Kernel mit Namespaces und cgroups läuft |
| **Kontext (Build-Kontext)** | Das Verzeichnis, das beim Bauen eines Images an den Docker-Daemon gesendet wird |
| **distroless** | Docker-Basis-Images ohne Shell, Paketmanager oder Betriebssystem-Utilities — minimale Angriffsfläche |
| **ENTRYPOINT** | Dockerfile-Anweisung: die feste ausführbare Datei; CMD wird zu ihren Argumenten |
| **Ephemer** | Temporär; Container sind ephemer — wenn entfernt, sind Daten darin verloren |
| **FROM** | Erste Dockerfile-Anweisung; gibt das Basis-Image an |
| **Healthcheck** | Ein Befehl, den Docker ausführt, um zu testen, ob ein Container korrekt funktioniert |
| **Image** | Eine Read-only-Vorlage zum Erstellen von Containern |
| **Layer** | Jede Dockerfile-Anweisung erstellt einen neuen Layer; Layer werden unabhängig gecacht |
| **Namespace** | Linux-Kernel-Feature, das Isolation bietet (PID, Netzwerk, Dateisystem usw.) |
| **Named Volume** | Ein von Docker verwaltetes Volume, das durch einen Namen statt einem Host-Pfad identifiziert wird |
| **OCI** | Open Container Initiative; definiert Standards für Container-Images und -Laufzeiten |
| **Pipe (`\|`)** | Verbindet stdout eines Befehls mit stdin des nächsten |
| **Redirect (`>`)** | Sendet stdout in eine Datei (überschreibt); `>>` hängt an |
| **Registry** | Ein Server, der Docker-Images speichert und verteilt (Docker Hub, GHCR) |
| **RUN** | Dockerfile-Anweisung; führt einen Befehl während des Image-Builds aus |
| **Service** | Eine benannte Komponente in einer `docker-compose.yml`-Datei |
| **Shell** | Ein Kommandozeilen-Interpreter (bash, zsh) |
| **Symlink** | Eine Datei, die auf eine andere Datei oder ein Verzeichnis zeigt (`ln -s`) |
| **Tag** | Ein Label auf einem Docker-Image, das seine Version angibt (z.B. `nginx:alpine`) |
| **Volume** | Ein Mechanismus zum Persistieren von Daten, die von Docker-Containern erzeugt und verwendet werden |
| **WORKDIR** | Dockerfile-Anweisung; setzt das Arbeitsverzeichnis für folgende Anweisungen |
