# CLAUDE.md – Linux & Docker Learning Path

## Projektkontext

Dieses Repository ist ein **praxisorientierter Linux & Docker Learning Path** für Einsteiger bis Junior DevOps Engineers. Ziel ist systematisches, hands-on Lernen von Linux-Grundlagen und Container-Technologie als Vorbereitung auf Kubernetes und Cloud-Arbeit.

## Sprache & Stil

- **Primärsprache der Inhalte:** Deutsch
- **Website-UI und Navigation:** Englisch
- **Technische Begriffe** (Container, Image, Volume, chmod, etc.) werden NICHT übersetzt — sie sind Fachbegriffe und werden erklärt
- Verständlich, aber technisch korrekt
- Zielgruppe: Einsteiger, die ernst genommen werden wollen

## Primärquellen

- [Linux man-pages](https://man7.org/linux/man-pages/)
- [Docker Documentation](https://docs.docker.com/)
- [OCI Image Spec](https://github.com/opencontainers/image-spec)
- Offizielle Distro-Dokumentationen (Ubuntu, Debian, Fedora)

**Im Zweifel: `man <command>` zitieren. Keine erfundenen Flags oder Kommandos.**

## Qualitätsregeln

- **Shell-Befehle müssen valide sein** — alle Kommandos vor dem Schreiben auf Korrektheit prüfen
- **Dockerfiles müssen buildbar sein** — syntaktisch korrekte Dockerfiles, existierende Base-Images
- **Labs lokal auf macOS und Linux nachvollziehbar** — keine Cloud-Voraussetzungen
- **Keine erfundenen Flags** — wenn unsicher, leer lassen und kommentieren
- **Expected Output nach wichtigen Befehlen** — Lernende müssen wissen, ob ihr Befehl korrekt war
- **Definition of Done am Ende jedes Moduls**
- **Keine Secrets, Tokens oder Passwörter committen**
- **`secret.example.env` nur mit Dummy-Werten und explizitem Hinweis**

## Callout-System

Sparsam einsetzen (max. 1–2 pro Dokument):

```markdown
> [!NOTE]
> Zusätzliche hilfreiche Information.

> [!TIP]
> Praktischer Tipp für die tägliche Arbeit.

> [!IMPORTANT]
> Wichtig für das Verständnis oder die Funktion.

> [!WARNING]
> Häufige Fehlerquelle oder bekanntes Risiko.

> [!CAUTION]
> Potenziell gefährliche Aktion (z. B. Datenverlust, root-Befehle).
```

## Modulstruktur (verpflichtend)

```markdown
# Modul XX – Titel

## Ziel des Moduls
## Warum ist das wichtig?
## Kernkonzepte
## Praxisaufgabe
## Beispiel-Kommandos
## Typische Fehler
## Checkpoint
## Definition of Done
## Weiterführende Links
```

## Lab-Struktur (verpflichtend)

```markdown
# Lab XX – Titel

## Was du baust
Kurze Beschreibung (2–4 Sätze) + verwendete Konzepte + optionales ASCII-Diagramm.

## Ziel
## Voraussetzungen
## Schritt-für-Schritt
# Nach wichtigen Befehlen: "Erwartete Ausgabe:" mit realistischem Beispiel

## Validierung
## Cleanup
## Erweiterungsaufgabe
```

## MkDocs-Hinweise

- Alle Docs liegen unter `docs/`
- Englische Dateien: `README.md` / `index.md`
- Deutsche Dateien: `README.de.md` / `index.de.md`
- Navigation wird in `mkdocs.yml` unter `nav:` gepflegt
- Nach Änderungen immer `mkdocs build --strict` ausführen
- Plugin: `mkdocs-static-i18n` mit `docs_structure: suffix`

## Arbeitsregeln für Claude Code

- Neue Module/Labs immer in **beide** Sprachversionen schreiben (EN + DE)
- Wenn ein Befehl unklar ist: `man <command>` nachschlagen, nicht erfinden
- Dockerfiles immer mit echten, existierenden Base-Images (z.B. `python:3.12-slim`, `node:20-alpine`)
- Bei Labs: immer Cleanup-Abschnitt mit `docker rm`, `docker volume rm` etc.
- `docs/examples/secret.example.env` enthält IMMER nur Dummy-Werte + Warnung

## Git-Regeln (STRIKT)

- **NIEMALS** `--author="Claude ..."` verwenden
- **NIEMALS** `Co-Authored-By: Claude ...` in Commit-Messages
- **NIEMALS** `Generated with Claude Code` oder ähnliches einfügen
- **NIEMALS** `--no-verify` verwenden
- `.venv/` und `site/` **nicht committen** (sind in .gitignore)
- Commit-Messages: normaler, beschreibender englischer Text
