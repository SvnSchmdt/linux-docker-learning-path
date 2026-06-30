# Beitragen zum Linux & Docker Learning Path

Danke, dass du zum Linux & Docker Learning Path beitragen möchtest! Diese Anleitung erklärt, wie du neue Inhalte beisteuern, Fehler beheben oder Verbesserungen vorschlagen kannst.

## Was du beitragen kannst

- **Neue Inhalte**: Module, Labs, Exercises, Ressourcen
- **Korrekturen**: Fehler in Befehlen, falsche Ausgaben, veraltete Informationen
- **Übersetzungen**: Fehlende oder unvollständige deutsche/englische Inhalte
- **Verbesserungen**: Klarere Erklärungen, bessere Beispiele, fehlende `Expected Output`-Abschnitte

## Qualitätsregeln

Vor jedem Beitrag sicherstellen:

1. **Shell-Befehle sind valide** — jeden Befehl lokal getestet
2. **Dockerfiles sind buildbar** — syntaktisch korrekt, existierende Base-Images
3. **Expected Output vorhanden** — nach wichtigen Befehlen muss eine realistische Ausgabe stehen
4. **Keine Secrets** — keine echten Tokens, Passwörter oder API-Keys committen
5. **`mkdocs build --strict` läuft durch** — kein Beitrag bricht den Build

## Schritt-für-Schritt

```bash
# 1. Repository forken (auf GitHub)

# 2. Lokal klonen
git clone https://github.com/DEIN-USERNAME/linux-docker-learning-path
cd linux-docker-learning-path

# 3. Virtuelle Umgebung und Abhängigkeiten
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# 4. Feature-Branch erstellen
git checkout -b add/modul-16-advanced-networking

# 5. Änderungen vornehmen
# Neue Inhalte immer in BEIDEN Sprachen erstellen:
# - docs/modules/XX-name/README.md    (Englisch)
# - docs/modules/XX-name/README.de.md (Deutsch)

# 6. Build testen
mkdocs build --strict

# 7. Lokal vorschauen
mkdocs serve

# 8. Commit erstellen
git add docs/modules/XX-name/
git commit -m "add: Module 16 – Advanced Networking"

# 9. Push und Pull Request
git push origin add/modul-16-advanced-networking
# → Pull Request auf GitHub öffnen
```

## PR-Checkliste

Vor dem Öffnen eines Pull Requests:

- [ ] Alle Befehle lokal getestet
- [ ] `mkdocs build --strict` läuft ohne Fehler
- [ ] Beide Sprachversionen erstellt (EN + DE)
- [ ] Expected Output nach wichtigen Befehlen vorhanden
- [ ] Keine echten Secrets/Tokens/Passwörter im Code
- [ ] Modulstruktur eingehalten (alle Pflichtabschnitte vorhanden)
- [ ] Lab-Struktur eingehalten (inkl. Cleanup und Erweiterungsaufgabe)

## Commit-Message-Konventionen

```
add:    Neuer Inhalt (Modul, Lab, Exercise)
fix:    Korrektur eines Fehlers (falscher Befehl, falsche Ausgabe)
update: Aktualisierung bestehender Inhalte
docs:   Dokumentation (README, CONTRIBUTING, CLAUDE.md)
```

Beispiele:
```
add: Module 09 – Container Basics (EN + DE)
fix: correct chmod example in Module 02
update: Lab 05 – use python:3.12-slim instead of python:3.11
docs: add troubleshooting section to exercises
```

## Zweisprachigkeit

**Jeder neue Inhalt braucht IMMER beide Sprachversionen:**

| Englisch | Deutsch |
|----------|---------|
| `README.md` | `README.de.md` |
| `index.md` | `index.de.md` |
| `beginner.md` | `beginner.de.md` |

Technische Begriffe (Container, Image, Volume, chmod, etc.) werden in der deutschen Version **nicht übersetzt** — sie werden als Fachbegriffe erklärt.

## Lokale Vorschau

```bash
mkdocs serve
# → http://localhost:8000
# Sprachumschalter oben rechts: English / Deutsch
```

## Fragen?

Öffne ein Issue auf GitHub. Wir helfen gerne!
