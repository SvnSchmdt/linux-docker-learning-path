# Lab 00 – Terminal Setup

## What you're building

You'll configure your shell environment for productive command-line work: a `.bashrc`/`.zshrc` with useful aliases, a correctly set `PATH`, and verified access to `man` pages and tab completion.

**Concepts used:** Shell configuration, PATH, aliases, man pages, tab completion.

```
┌─────────────────────────────────────┐
│ Terminal (iTerm2 / Terminal.app)    │
│  ┌───────────────────────────────┐  │
│  │ Shell (bash / zsh)            │  │
│  │  ~/.bashrc or ~/.zshrc        │  │
│  │  • aliases                    │  │
│  │  • PATH entries               │  │
│  │  • prompt settings            │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

## Goal

Configure a productive shell environment that you'll use throughout the entire learning path.

## Prerequisites

- A macOS or Linux machine with a terminal
- Either bash or zsh as your shell (check with `echo $SHELL`)

## Step by Step

### Step 1: Identify your shell config file

```bash
echo $SHELL
# Expected output:
# /bin/zsh   (macOS default)
# /bin/bash  (many Linux systems)
```

- zsh users: edit `~/.zshrc`
- bash users: edit `~/.bashrc`

### Step 2: Add useful aliases

Open your config file and add:

```bash
# Navigation shortcuts
alias ll='ls -lah'
alias la='ls -lah'
alias ..='cd ..'
alias ...='cd ../..'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Git shortcuts (useful later)
alias gs='git status'
alias gl='git log --oneline -10'
```

### Step 3: Verify PATH

```bash
echo $PATH
# Expected output (macOS with Homebrew):
# /opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

Homebrew binaries should appear before `/usr/bin`. If not, add to your config:

```bash
# macOS with Apple Silicon
export PATH="/opt/homebrew/bin:$PATH"
# macOS with Intel
export PATH="/usr/local/bin:$PATH"
```

### Step 4: Reload your config

```bash
source ~/.zshrc   # or source ~/.bashrc
```

### Step 5: Verify aliases work

```bash
ll
# Expected output: long listing of current directory with hidden files
# drwxr-xr-x  ...  .
# drwxr-xr-x  ...  ..
# ...
```

### Step 6: Verify man pages

```bash
man ls | head -5
# Expected output:
# LS(1)             General Commands Manual
#
# NAME
#      ls – list directory contents
```

## Validation

```bash
# All of these should work:
ll                          # alias for ls -lah
echo $PATH | grep -q bin && echo "PATH OK"
man ls > /dev/null && echo "man pages OK"
type ll                     # should show: ll is an alias for ls -lah
```

## Cleanup

No cleanup needed — these are permanent shell configuration changes you want to keep.

## Extension Task

Install and configure a more powerful prompt:
- **starship** (`brew install starship`) — cross-shell, shows git status and more
- Follow the [quickstart](https://starship.rs/guide/) to add it to your config
