# Mission 08 – Disk Full

## Scenario

The application is returning 500 errors. The database won't write. A deployment just failed. Everything seems broken at once.

Then you check disk space.

The disk is at 98%.

## Goal

Identify what's consuming disk space, find the biggest offenders, and free enough space to restore service — without deleting anything important.

## What you will practice

- `df -h` — disk usage by filesystem
- `du -sh *` — directory sizes
- `du -ah | sort -rh | head -20` — largest files/dirs
- `find` with `-size` to locate large files
- Differentiating important files from safe-to-delete ones

## Setup

```bash
bash ~/path/to/docs/linux-missions/scripts/setup-08-disk-full.sh
```

When done:

```
Mission 08 setup complete.
Lab directory: ~/linux-missions/mission-08
```

> [!NOTE]
> The script creates large sparse files that report high size but don't actually consume that much disk space. `df` will not change — but `du` will show the files as large.

## Mission

**Part 1 — Check disk status**

```bash
df -h
```

Questions:

1. What filesystem has the highest usage percentage?
2. What is the mount point of that filesystem?
3. How much space is available?

**Part 2 — Find the large directories**

Navigate into the lab directory:

```bash
cd ~/linux-missions/mission-08
du -sh * | sort -rh
```

Questions:

4. Which subdirectory is largest?
5. What's the total size of the lab directory?

**Part 3 — Drill down**

```bash
du -sh ~/linux-missions/mission-08/*/* | sort -rh
```

Find the specific large files:

```bash
find ~/linux-missions/mission-08 -type f -size +100M | sort
```

Questions:

6. What are the 3 largest files, and where are they located?
7. What do their names tell you about what they are?

**Part 4 — Investigate before deleting**

Before you delete anything, categorize each large file:

| File | Size | Category | Safe to delete? |
|------|------|----------|-----------------|
| `dumps/db-backup-old.dump` | ~200M | Old database backup | Probably yes |
| `logs/archived/service.log.2` | ~350M | Old log archive | Yes if old enough |
| `cache/npm-cache.tgz` | ~180M | Build cache | Yes — rebuilds from source |
| `tmp/upload-*.tmp` | ~125M | Temp upload files | Yes |

**Part 5 — Free the space**

Delete the safe files:

```bash
rm ~/linux-missions/mission-08/logs/archived/*.log.*
rm ~/linux-missions/mission-08/cache/*.tgz
rm ~/linux-missions/mission-08/tmp/*.tmp
```

Check how much you freed:

```bash
du -sh ~/linux-missions/mission-08/
```

**Part 6 — Find hidden large files**

```bash
# Files not visible with ls (deleted but still open by a process)
lsof +L1 2>/dev/null | grep -i deleted | sort -k7 -rn | head -10
```

This shows files that have been deleted but are still held open by a running process — they don't free disk space until the process releases them. This is a common cause of "I deleted files but disk is still full."

**Bonus:** What is the difference between `du` and `df` reporting? When would they disagree?

## Hints

??? hint "Hint 1 – Fastest way to find large files"
    ```bash
    find ~/linux-missions/mission-08 -type f -size +50M \
      -exec ls -lh {} \; | sort -k5 -rh
    ```

??? hint "Hint 2 – du vs df discrepancy"
    ```
    df shows space used/available at the filesystem level.
    du shows space used by files the directory tree can see.
    They differ when: a file is deleted but still open by a process
    (df still counts it as used; du doesn't see it).
    ```

??? hint "Hint 3 – Safe categories to delete"
    ```
    Safe:   *.log.* (rotated logs), *.tmp, cache dirs, old *.dump backups
    Unsafe: *.log (current log), *.dump (latest backup), *.conf, source code
    When unsure: check the file's modification time with ls -lht
    ```

## Validation

```bash
# Before cleanup: count large files
find ~/linux-missions/mission-08 -type f -size +50M | wc -l
# Expected: 4 or more

# After cleanup: should be fewer or none
rm -f ~/linux-missions/mission-08/logs/archived/*.log.*
rm -f ~/linux-missions/mission-08/cache/*.tgz
rm -f ~/linux-missions/mission-08/tmp/*.tmp 2>/dev/null || true
find ~/linux-missions/mission-08 -type f -size +50M | wc -l
# Expected: fewer than before
```

## Cleanup

```bash
rm -rf ~/linux-missions/mission-08
```

## What you should have learned

- `df -h` shows filesystem-level usage; `du -sh` shows directory-level usage
- `du -ah | sort -rh | head -20` is your fastest path to finding the culprit
- Deleted files don't free space if a process still has them open — `lsof +L1` finds these
- Disk full causes cascading failures: writes fail → apps error → logs can't write → systems look broken
- In Docker: `docker system df` shows images, containers, volumes, build cache usage; `docker system prune` frees safely

## Next mission

[Mission 09 – SSH Key Trouble →](09-ssh-key-trouble.md)
