# Module 07 – Package Management

## Module Goal

Install, update, and remove software packages on Debian/Ubuntu, Fedora/RHEL, and macOS.

## Why does this matter?

Every tool you use — git, curl, Docker, Python, Node.js — is installed via a package manager. Knowing how to use your system's package manager correctly (and why not to bypass it) is a basic operational skill.

## Core Concepts

### apt — Debian/Ubuntu

```bash
sudo apt update                   # update package lists (always run first!)
sudo apt upgrade                  # upgrade all installed packages
sudo apt install curl             # install a package
sudo apt install curl git vim     # install multiple packages
sudo apt remove curl              # remove package (keep config files)
sudo apt purge curl               # remove package + config files
sudo apt search nginx             # search for a package
apt show nginx                    # show package details
apt list --installed              # list all installed packages
```

> [!IMPORTANT]
> Always run `sudo apt update` before installing anything. Without it, apt uses a stale local cache and may install outdated versions or fail to find packages.

### dnf/yum — Fedora/RHEL/CentOS

```bash
sudo dnf update                   # update all packages
sudo dnf install curl             # install a package
sudo dnf remove curl              # remove a package
sudo dnf search nginx             # search
sudo dnf info nginx               # package details
```

`yum` is the older equivalent used on CentOS 7 and RHEL 7. On modern systems, prefer `dnf`.

### Homebrew — macOS

```bash
brew install curl                 # install a package
brew update                       # update Homebrew itself
brew upgrade                      # upgrade all installed packages
brew upgrade curl                 # upgrade specific package
brew uninstall curl               # remove a package
brew search nginx                 # search
brew info nginx                   # package details
brew list                         # list installed packages
brew doctor                       # diagnose problems
```

### Why NOT `sudo pip install` on System Python

Installing Python packages with `sudo pip install` modifies the system Python installation, which can:

- Break system tools that depend on specific package versions
- Conflict with packages installed by `apt`/`dnf`
- Be overwritten by system updates

**Instead, always use virtual environments:**

```bash
python3 -m venv .venv           # create virtual environment
source .venv/bin/activate        # activate it
pip install requests             # install inside venv (no sudo!)
deactivate                       # deactivate
```

## Hands-on Task

1. Update your package lists (use the right command for your OS)
2. Install `tree` and verify it's installed: `tree --version`
3. Search for the `htop` package without installing it
4. On macOS: install `jq` with Homebrew

## Example Commands

```bash
# Ubuntu: install tree and jq
sudo apt update && sudo apt install -y tree jq

# Verify installation
tree --version
# Expected output:
# tree v2.1.1 © 1996 - 2022 by Steve Baker, Thomas Moore, Francesc Robles Molina

# macOS: install using Homebrew
brew install tree jq

# Check installed packages (Ubuntu)
apt list --installed | grep tree

# Check installed packages (macOS)
brew list | grep tree
```

## Common Mistakes

- **`apt install` without `apt update` first** — you'll get stale package lists
- **Mixing package managers for the same tool** — don't install Python with both `apt` and `pyenv`; pick one
- **`sudo pip install`** — use virtual environments instead
- **Installing from source when a package exists** — check the package manager first

## Checkpoint

- [ ] I can install and remove packages using my system's package manager
- [ ] I always run `update` before `install`
- [ ] I know why `sudo pip install` is problematic
- [ ] I can search for packages without installing them

## Definition of Done

You can install any software tool via the package manager on your system and explain why bypassing the package manager is usually a bad idea.

## Further Reading

- `man apt`
- `man dnf`
- [Homebrew documentation](https://docs.brew.sh/)
