# Linux & Docker Learning Path

A practical, hands-on learning path for Linux fundamentals and Docker — from your first terminal command to production-ready container workflows.

**German primary content · English UI · Dual-language documentation**

🌐 **[svnschmdt.github.io/linux-docker-learning-path](https://svnschmdt.github.io/linux-docker-learning-path/)** · [Deutsch](https://svnschmdt.github.io/linux-docker-learning-path/de/)

---

## Who this is for

This learning path is for absolute beginners to junior developers and DevOps engineers who want to learn Linux and container technology systematically and hands-on — as preparation for Kubernetes or cloud work in general.

## Structure

| Section | Content |
|---------|---------|
| [Modules](docs/modules/) | 16 structured modules from prerequisites to production patterns |
| [Labs](docs/labs/) | 8 hands-on labs with step-by-step instructions |
| [Exercises](docs/exercises/) | Practice tasks for different skill levels |
| [Resources](docs/resources/) | Cheat sheets, glossary, official documentation links |
| [Examples](docs/examples/) | Ready-to-use Dockerfile and Compose examples |

## Quickstart

```bash
# Clone
git clone https://github.com/svnschmdt/linux-docker-learning-path
cd linux-docker-learning-path

# Install MkDocs dependencies
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt

# Serve locally
mkdocs serve
# → http://localhost:8000
```

## Learning Path

```
Linux Basics                     Docker / Containers
─────────────────────────────    ──────────────────────────────
Module 00 – Prerequisites    →   Module 09 – Container Basics
Module 01 – Linux Navigation →   Module 10 – Dockerfile & Build
Module 02 – Files & Perms    →   Module 11 – Running Containers
Module 03 – Text Processing  →   Module 12 – Volumes & Networking
Module 04 – Users & sudo     →   Module 13 – Docker Compose
Module 05 – Processes        →   Module 14 – Registry & Distribution
Module 06 – Networking       →   Module 15 – Production Patterns
Module 07 – Package Mgmt
Module 08 – Shell Scripting
```

## Local Development

```bash
mkdocs serve          # Live preview with hot reload
mkdocs build --strict # Production build, fail on warnings
```

The site is published to GitHub Pages via the `deploy-docs.yml` workflow on every push to `main`.

**Enable GitHub Pages** in repository Settings → Pages → Source: **GitHub Actions**.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on adding content.

## License

MIT — see [LICENSE](LICENSE).
