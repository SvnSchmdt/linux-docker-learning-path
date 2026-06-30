# Module 00 – Prerequisites

## Module Goal

Set up your terminal environment and learn the foundational tools you'll use throughout this entire learning path.

## Why does this matter?

Everything in Linux and Docker happens in a terminal. Before you can learn commands, you need to know how to use the tool you'll type them into. A well-configured terminal with tab completion and access to man pages makes the rest of the path dramatically faster.

## Core Concepts

### The Shell

A **shell** is a program that reads commands you type and executes them. The most common shells are:

- **bash** (Bourne Again Shell) — default on most Linux systems
- **zsh** (Z Shell) — default on macOS since Catalina

Both behave identically for everything in this learning path.

### Terminal vs. Shell

The **terminal** is the window/application you open. The **shell** is the program running inside it. When you open "Terminal.app" on macOS, you're opening a terminal that runs zsh.

### man — The Manual

`man` gives you the built-in documentation for any command:

```bash
man ls
man chmod
man bash
```

Navigate with arrow keys, search with `/`, quit with `q`.

### --help Flag

Most commands have a `--help` flag that shows a quick usage summary:

```bash
ls --help
curl --help
```

### Tab Completion

Press `Tab` to auto-complete command names and file paths:

```bash
ls /etc/hos<Tab>    # completes to /etc/hosts
```

Press `Tab` twice to see all options when there are multiple matches.

## Hands-on Task

1. Open your terminal
2. Find out which shell you're using: `echo $SHELL`
3. Open the man page for `ls` and find the flag for showing hidden files
4. Use tab completion to navigate to `/etc/` and list its contents

## Example Commands

```bash
# Which shell am I using?
echo $SHELL

# Expected output (macOS):
# /bin/zsh

# Open the man page for ls
man ls

# Quick help for a command
ls --help

# Find your home directory
echo $HOME

# Show command history
history | tail -20
```

## Common Mistakes

- **Reading man pages is hard at first** — use `/keyword` to search within the page, `n` for next match
- **Tab completion not working** — make sure you have a space after the command before trying to complete a path
- **Shell vs terminal confusion** — they're different things, but in practice "terminal" is used loosely to mean both

## Checkpoint

- [ ] I can open a terminal on my machine
- [ ] I know which shell I'm using (`echo $SHELL`)
- [ ] I can open and navigate a man page
- [ ] Tab completion works for file paths

## Definition of Done

You're done with this module when you can open a man page, search within it, and close it — and tab completion works reliably on your system.

## Further Reading

- `man bash` — the complete bash reference
- `man zshall` — the complete zsh reference
- [Homebrew](https://brew.sh/) — macOS package manager used in later modules
