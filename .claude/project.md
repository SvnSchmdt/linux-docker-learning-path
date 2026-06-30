# Project: Linux & Docker Learning Path

## Overview

A bilingual (German/English) practical learning path for Linux fundamentals and Docker, targeting beginners to junior DevOps engineers.

## Key facts

- **Language**: German content, English UI/navigation
- **MkDocs plugin**: `mkdocs-static-i18n` with `docs_structure: suffix`
- **File naming**: `README.md` (EN), `README.de.md` (DE)
- **Build command**: `mkdocs build --strict`
- **GitHub Pages**: deploys via `.github/workflows/deploy-docs.yml` on push to `main`

## Module count

16 modules (00–15), 8 labs (00–07)

## Critical quality rules

1. All shell commands must be valid — test before writing
2. All Dockerfiles must be buildable with real base images
3. Every module needs EN + DE version
4. No secrets in the repository
5. `mkdocs build --strict` must pass after every change
