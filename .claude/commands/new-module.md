# Command: new-module

Creates a new module with both language versions (EN + DE) using the mandatory structure.

## Usage

```
/new-module <number> <name-slug> "<Title EN>" "<Titel DE>"
```

Example:
```
/new-module 16 advanced-networking "Advanced Networking" "Fortgeschrittenes Networking"
```

## What this does

1. Creates `docs/modules/<number>-<name-slug>/README.md` (English)
2. Creates `docs/modules/<number>-<name-slug>/README.de.md` (German)
3. Both files follow the mandatory module structure
4. Reminds you to add the entry to `mkdocs.yml` nav

## Mandatory structure

Both files must contain all of these sections:

- `## Ziel des Moduls` / `## Module Goal`
- `## Warum ist das wichtig?` / `## Why does this matter?`
- `## Kernkonzepte` / `## Core Concepts`
- `## Praxisaufgabe` / `## Hands-on Task`
- `## Beispiel-Kommandos` / `## Example Commands`
- `## Typische Fehler` / `## Common Mistakes`
- `## Checkpoint`
- `## Definition of Done`
- `## Weiterführende Links` / `## Further Reading`

## After creating

```bash
mkdocs build --strict  # verify build passes
```
