# Command: generate-lab

Creates a new lab with both language versions (EN + DE) using the mandatory structure.

## Usage

```
/generate-lab <number> <name-slug> "<Title EN>" "<Titel DE>"
```

Example:
```
/generate-lab 08 ci-pipeline "CI Pipeline with Docker" "CI Pipeline mit Docker"
```

## What this does

1. Creates `docs/labs/<number>-<name-slug>/README.md` (English)
2. Creates `docs/labs/<number>-<name-slug>/README.de.md` (German)
3. Both files follow the mandatory lab structure
4. Reminds you to add the entry to `mkdocs.yml` nav

## Mandatory structure

Both files must contain all of these sections:

- `## Was du baust` / `## What you're building`
  - 2–4 sentence description
  - List of concepts used
  - Optional ASCII diagram
- `## Ziel` / `## Goal`
- `## Voraussetzungen` / `## Prerequisites`
- `## Schritt-für-Schritt` / `## Step by Step`
  - "Erwartete Ausgabe:" / "Expected output:" after important commands
- `## Validierung` / `## Validation`
- `## Cleanup`
- `## Erweiterungsaufgabe` / `## Extension Task`

## After creating

```bash
mkdocs build --strict  # verify build passes
```
