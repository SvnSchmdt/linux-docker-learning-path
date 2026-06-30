# Mission 02 – Permission Denied

## Scenario

You need to deploy a new version of the application. The deploy script is right there in the directory. But when you try to run it, you get:

```
bash: ./deploy.sh: Permission denied
```

Someone set up the server in a hurry and didn't configure permissions correctly. There are three scripts in the directory — all broken in different ways.

## Goal

Diagnose and fix file permission issues so all three scripts can be executed correctly.

## What you will practice

- `ls -l` — reading permission strings
- `chmod` — symbolic and octal notation
- Understanding user/group/other permissions
- Why permission issues matter for Docker bind mounts

## Setup

```bash
bash ~/path/to/docs/linux-missions/scripts/setup-02-permission-denied.sh
```

When done:

```
Mission 02 setup complete.
Lab directory: ~/linux-missions/mission-02
```

## Mission

Navigate to `~/linux-missions/mission-02` and investigate.

**Part 1 — Identify what's broken**

Run each script and note the exact error:

```bash
./deploy.sh
./healthcheck.sh
./backup.sh
```

For each script, inspect its current permissions:

```bash
ls -la ~/linux-missions/mission-02/
```

Answer these questions before fixing anything:

1. What are the current permissions of `deploy.sh` in octal notation?
2. Which script is set to read-only for the owner?
3. There's a directory named `configs` — try `ls configs/`. What happens?

**Part 2 — Fix the permissions**

Requirements:
- `deploy.sh` — owner: read/write/execute · group: read/execute · others: read/execute
- `healthcheck.sh` — owner: read/execute · group: read/execute · others: no access
- `backup.sh` — owner: read/write/execute · group: no access · others: no access
- `configs/` — owner: read/write/execute · group: read/execute · others: no access

Set these using `chmod`. Use octal notation.

**Part 3 — Run and verify**

After fixing, all three scripts should run without errors. Run them.

**Bonus question:** Why does Docker care about file permissions on bind-mounted files? What happens if you mount a script with `chmod 644` into a container that tries to execute it?

## Hints

??? hint "Hint 1 – Reading permissions"
    ```
    -rwxr-xr-x
     ^^^ ^^^ ^^^
     |   |   └── others: r-x = 5
     |   └────── group:  r-x = 5
     └────────── user:   rwx = 7
    → octal: 755
    ```

??? hint "Hint 2 – Setting permissions"
    ```bash
    chmod 755 deploy.sh      # rwxr-xr-x
    chmod 550 healthcheck.sh # r-xr-x---
    chmod 700 backup.sh      # rwx------
    chmod 750 configs/       # rwxr-x---
    ```

??? hint "Hint 3 – Checking the configs directory"
    ```bash
    ls -la ~/linux-missions/mission-02/
    # Look at configs — it shows d--------- (chmod 000)
    # That means even the owner can't list it
    chmod 750 ~/linux-missions/mission-02/configs
    ```

## Validation

```bash
# Check all permissions
stat -c "%a %n" ~/linux-missions/mission-02/deploy.sh
# Expected: 755

stat -c "%a %n" ~/linux-missions/mission-02/healthcheck.sh
# Expected: 550

stat -c "%a %n" ~/linux-missions/mission-02/backup.sh
# Expected: 700

# Run all three — should produce output, not "Permission denied"
~/linux-missions/mission-02/deploy.sh
~/linux-missions/mission-02/healthcheck.sh
~/linux-missions/mission-02/backup.sh
```

> [!NOTE]
> On macOS, `stat` uses `-f "%Mp%Lp"` instead of `-c "%a"`. Use `ls -l` to read permissions visually.

## Cleanup

```bash
rm -rf ~/linux-missions/mission-02
```

## What you should have learned

- How to read `rwxr-xr-x` style permission strings
- What octal permission numbers mean (4=read, 2=write, 1=execute)
- The difference between user, group, and other permission sets
- Why `chmod +x` is the first step when a script says "Permission denied"
- That Docker bind mounts inherit host permissions — a non-executable script stays non-executable inside a container

## Next mission

[Mission 03 – Process Detective →](03-process-detective.md)
