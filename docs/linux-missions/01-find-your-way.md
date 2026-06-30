# Mission 01 – Find Your Way

## Scenario

You have just SSHed onto an unfamiliar server. No documentation. No one to ask. The previous engineer left a directory somewhere under your home folder with log files, config files, and some data. Your job is to map the terrain and answer a few questions before you proceed.

## Goal

Navigate an unknown directory tree, locate specific files, and extract information from them — using only the command line.

## What you will practice

- `ls`, `ls -la`, `ls -lah`
- `cd`, `pwd`
- `find` with filters
- `grep` for searching inside files
- `cat` and `less` for reading files
- Hidden files and directories

## Setup

```bash
bash ~/path/to/docs/linux-missions/scripts/setup-01-find-your-way.sh
```

Or copy-paste the script content directly. When done, you'll see:

```
Mission 01 setup complete.
Lab directory: ~/linux-missions/mission-01
```

## Mission

You receive this message from the previous engineer:

> "The lab directory is at `~/linux-missions/mission-01`. There's a config file in there with a secret word. The result of the last processed job is somewhere under `data/`. The server version is in the source code. And I hid one more thing — you'll know it when you find it."

Answer these questions:

1. What is the `secret_word` value in the config file?
2. How many lines are in the application log (`logs/app.log`)?
3. What version of the server is defined in `src/server.py`?
4. What is the content of `data/processed/result.txt`?
5. There is a hidden directory. What file is inside it, and what does it say?
6. How many users have the role `developer` in `data/raw/users.csv`?

Write your answers down before checking them.

## Hints

??? hint "Hint 1 – Finding files by name"
    ```bash
    find ~/linux-missions/mission-01 -name "*.conf"
    find ~/linux-missions/mission-01 -type f -name "*.txt"
    ```

??? hint "Hint 2 – Searching inside files"
    ```bash
    grep "secret_word" ~/linux-missions/mission-01/config/app.conf
    grep "developer" ~/linux-missions/mission-01/data/raw/users.csv | wc -l
    ```

??? hint "Hint 3 – Finding hidden files"
    ```bash
    ls -la ~/linux-missions/mission-01/
    # Look for entries starting with .
    ```

## Validation

```bash
# 1. Secret word
grep "^secret_word" ~/linux-missions/mission-01/config/app.conf
# Expected: secret_word=archipelago

# 2. Log lines
wc -l ~/linux-missions/mission-01/logs/app.log
# Expected: 7

# 3. Server version
grep "Version" ~/linux-missions/mission-01/src/server.py
# Expected: # Version: 2.1.4

# 4. Result file
cat ~/linux-missions/mission-01/data/processed/result.txt
# Expected: the-answer-is-42

# 5. Hidden directory content
find ~/linux-missions/mission-01 -name ".*" -type f
cat ~/linux-missions/mission-01/.hidden/clue.txt

# 6. Developer count
grep "developer" ~/linux-missions/mission-01/data/raw/users.csv | wc -l
# Expected: 2
```

## Cleanup

```bash
rm -rf ~/linux-missions/mission-01
```

## What you should have learned

- The difference between `ls` and `ls -la` (hidden files matter)
- How to use `find` to locate files by name or extension
- How to use `grep` to search inside files without opening them
- That config files, version strings, and secrets live in predictable places — and a good engineer always knows where to look

## Next mission

[Mission 02 – Permission Denied →](02-permission-denied.md)
