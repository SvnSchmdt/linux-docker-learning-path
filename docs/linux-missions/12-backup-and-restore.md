# Mission 12 – Backup and Restore

## Scenario

You've been asked to create a backup procedure for an application's data directory, test it, and then simulate a disaster recovery scenario — delete the originals, restore from backup, and verify everything came back intact.

## Goal

Use `tar` to create, inspect, and restore backups. Automate with a script. Verify the restore produces an identical directory tree.

## What you will practice

- `tar -czf` — create compressed archives
- `tar -tzf` — list archive contents without extracting
- `tar -xzf` — extract archives
- `diff` and `md5sum` for verification
- Backup naming conventions with timestamps

## Setup

```bash
mkdir -p ~/linux-missions/mission-12/app-data/{config,logs,uploads}

# Create realistic application data
cat > ~/linux-missions/mission-12/app-data/config/app.conf << 'EOF'
port=8080
database_url=postgres://db:5432/myapp
log_level=info
max_connections=100
EOF

cat > ~/linux-missions/mission-12/app-data/config/secrets.env << 'EOF'
# DUMMY VALUES — NOT REAL CREDENTIALS
DB_PASSWORD=dummy-value-replace-in-prod
API_KEY=dummy-value-replace-in-prod
EOF

for i in 1 2 3; do
  echo "Log entry $i from $(date)" > ~/linux-missions/mission-12/app-data/logs/app.$i.log
done

echo "user-uploaded-content" > ~/linux-missions/mission-12/app-data/uploads/file1.txt
echo "another-uploaded-file" > ~/linux-missions/mission-12/app-data/uploads/file2.txt

mkdir -p ~/linux-missions/mission-12/backups

echo "Mission 12 setup complete."
echo "App data: ~/linux-missions/mission-12/app-data/"
echo "Backup target: ~/linux-missions/mission-12/backups/"
```

## Mission

**Part 1 — Inspect what you're backing up**

```bash
find ~/linux-missions/mission-12/app-data -type f | sort
```

Questions:

1. How many files are there?
2. What directories exist under `app-data/`?
3. Why does `secrets.env` need to be in the backup even if it contains sensitive data?

**Part 2 — Create a backup**

```bash
TIMESTAMP=$(date +%Y-%m-%d_%H%M%S)
BACKUP_FILE=~/linux-missions/mission-12/backups/app-data-$TIMESTAMP.tar.gz

tar -czf "$BACKUP_FILE" -C ~/linux-missions/mission-12 app-data/
echo "Backup created: $BACKUP_FILE"
ls -lh "$BACKUP_FILE"
```

Flags explained:

| Flag | Meaning |
|------|---------|
| `-c` | Create archive |
| `-z` | Compress with gzip |
| `-f` | Archive file follows |
| `-C dir` | Change to this directory before archiving |

**Part 3 — Verify the backup without extracting**

```bash
tar -tzf "$BACKUP_FILE" | sort
```

Questions:

4. Are all files present in the archive listing?
5. Do the paths inside the archive start with `app-data/` or absolute paths?

**Part 4 — Disaster simulation**

```bash
# The server had a catastrophic failure — data directory is gone
rm -rf ~/linux-missions/mission-12/app-data/

# Confirm it's gone
ls ~/linux-missions/mission-12/
# Expected: only backups/ remains
```

**Part 5 — Restore from backup**

```bash
# Restore to original location
tar -xzf "$BACKUP_FILE" -C ~/linux-missions/mission-12/

# Verify the directory came back
ls -la ~/linux-missions/mission-12/app-data/
find ~/linux-missions/mission-12/app-data -type f | sort
```

**Part 6 — Verify integrity**

```bash
# Check specific file contents
cat ~/linux-missions/mission-12/app-data/config/app.conf
# Expected: original config content

# Verify using checksums (if you saved them before)
find ~/linux-missions/mission-12/app-data -type f -exec md5sum {} \; | sort
```

**Part 7 — Automate with a script**

```bash
cat > ~/linux-missions/mission-12/backup.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR=~/linux-missions/mission-12/app-data
BACKUP_DIR=~/linux-missions/mission-12/backups
KEEP_DAYS=7

TIMESTAMP=$(date +%Y-%m-%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/app-data-$TIMESTAMP.tar.gz"

mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")/"
echo "[$(date)] Backup created: $BACKUP_FILE ($(du -sh "$BACKUP_FILE" | cut -f1))"

# Remove backups older than KEEP_DAYS days
find "$BACKUP_DIR" -name "app-data-*.tar.gz" -mtime +"$KEEP_DAYS" -delete
echo "[$(date)] Old backups removed (kept last $KEEP_DAYS days)"
EOF

chmod +x ~/linux-missions/mission-12/backup.sh
bash ~/linux-missions/mission-12/backup.sh
```

**Bonus:** What is the `3-2-1` backup rule? Does this mission's setup satisfy it?

## Hints

??? hint "Hint 1 – tar with relative paths"
    ```bash
    # WRONG — absolute path creates messy archives
    tar -czf backup.tar.gz ~/linux-missions/mission-12/app-data/

    # RIGHT — -C changes directory first; archive paths are relative
    tar -czf backup.tar.gz -C ~/linux-missions/mission-12 app-data/
    # Extract cleanly: tar -xzf backup.tar.gz -C /restore/target/
    ```

??? hint "Hint 2 – Verifying with checksums before disaster"
    ```bash
    # Before backup — save checksums
    find ~/linux-missions/mission-12/app-data -type f -exec md5sum {} \; > /tmp/before.md5

    # After restore — compare
    find ~/linux-missions/mission-12/app-data -type f -exec md5sum {} \; > /tmp/after.md5
    diff /tmp/before.md5 /tmp/after.md5
    # No output = identical
    ```

??? hint "Hint 3 – The 3-2-1 rule"
    ```
    3 copies of the data
    2 different storage types (e.g., local disk + cloud)
    1 copy offsite (different geographic location)
    This mission creates only 1 local backup — not 3-2-1 compliant.
    ```

## Validation

```bash
# Backup file exists
ls ~/linux-missions/mission-12/backups/app-data-*.tar.gz
# Expected: at least one file

# Archive contains all original files
tar -tzf ~/linux-missions/mission-12/backups/app-data-*.tar.gz | grep "config/app.conf"
# Expected: app-data/config/app.conf

# Restore works (re-delete and restore)
rm -rf ~/linux-missions/mission-12/app-data/
tar -xzf ~/linux-missions/mission-12/backups/app-data-*.tar.gz -C ~/linux-missions/mission-12/
cat ~/linux-missions/mission-12/app-data/config/app.conf | grep "port"
# Expected: port=8080
```

## Cleanup

```bash
rm -rf ~/linux-missions/mission-12
```

## What you should have learned

- `tar -czf` creates; `tar -tzf` lists; `tar -xzf` extracts — the three operations you use every day
- Always use `-C <dir> <relative-path>` to create archives with portable relative paths
- Restore testing is as important as backup creation — an untested backup is not a backup
- `find ... -mtime +7 -delete` is the pattern for rotating old backups
- In Docker: `docker run --rm -v myvolume:/data -v $(pwd):/backup alpine tar -czf /backup/vol.tar.gz /data` is the volume backup pattern

## Next mission

[Mission 13 – Network Sleuth →](13-network-sleuth.md)
