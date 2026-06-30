# Mission 10 – Cron Did Not Run

## Scenario

The nightly database backup job didn't run last night. The on-call message says "backup missing for 2026-06-29". You check — there's a cron job configured. But nothing happened.

## Goal

Debug a cron job that silently failed: inspect the cron syntax, find the output (or lack thereof), and validate that a cron expression does what you think it does.

## What you will practice

- `crontab -l` and `crontab -e`
- Cron expression syntax (`m h dom mon dow`)
- Where cron logs go
- Environment differences between cron and interactive shell
- Testing cron jobs manually

## Setup

```bash
mkdir -p ~/linux-missions/mission-10/backups
mkdir -p ~/linux-missions/mission-10/logs

cat > ~/linux-missions/mission-10/backup.sh << 'EOF'
#!/usr/bin/env bash
BACKUP_DIR=~/linux-missions/mission-10/backups
TIMESTAMP=$(date +%Y-%m-%d_%H%M%S)
echo "[$(date)] Backup started" >> ~/linux-missions/mission-10/logs/backup.log
tar -czf "$BACKUP_DIR/backup-$TIMESTAMP.tar.gz" ~/.ssh/config 2>/dev/null \
  || tar -czf "$BACKUP_DIR/backup-$TIMESTAMP.tar.gz" /etc/hostname 2>/dev/null
echo "[$(date)] Backup complete: backup-$TIMESTAMP.tar.gz" >> ~/linux-missions/mission-10/logs/backup.log
EOF
chmod +x ~/linux-missions/mission-10/backup.sh
echo "Mission 10 setup complete."
echo "Lab directory: ~/linux-missions/mission-10"
```

## Mission

**Part 1 — Read the broken cron config**

The cron job was configured as:

```
0 2 30 * * /home/alice/backup.sh
```

Questions before you change anything:

1. What time was this supposed to run?
2. What does the `30` in the third field mean?
3. How often would this actually run?
4. What is wrong with it for a "nightly" backup?

**Part 2 — Understand cron field order**

```
┌──────── minute (0-59)
│ ┌────── hour (0-23)
│ │ ┌──── day of month (1-31)
│ │ │ ┌── month (1-12)
│ │ │ │ ┌ day of week (0-6, 0=Sunday)
│ │ │ │ │
* * * * * command
```

Translate these expressions:

| Expression | Meaning |
|------------|---------|
| `0 2 * * *` | ? |
| `*/15 * * * *` | ? |
| `0 9 * * 1` | ? |
| `0 0 1 * *` | ? |
| `0 2 30 * *` | ? (the broken one) |

**Part 3 — Check cron logs**

On Linux, cron logs go to syslog:

```bash
grep -i cron /var/log/syslog 2>/dev/null | tail -20
# or
journalctl -u cron --no-pager -n 30 2>/dev/null
journalctl -u crond --no-pager -n 30 2>/dev/null
```

Things to look for:

- `(user) CMD (command)` — job ran
- No entry at expected time — job didn't run
- Errors like `No MTA installed` — cron tried to email output, failed

**Part 4 — The environment trap**

Cron runs with a minimal environment — no `~`, no `$HOME` set correctly, no PATH beyond `/usr/bin:/bin`. Scripts that work interactively often fail in cron because of this.

```bash
# What's in your interactive PATH?
echo $PATH

# What cron gets (approximate)
env -i PATH=/usr/bin:/bin HOME=/home/alice /home/alice/backup.sh
```

Fix: always use absolute paths in cron jobs, or source a profile:

```bash
# Good cron job:
0 2 * * * /usr/bin/env bash /home/alice/linux-missions/mission-10/backup.sh >> /home/alice/linux-missions/mission-10/logs/cron-output.log 2>&1
```

The `>> ... 2>&1` at the end is critical — without it, cron swallows all output and you can never debug failures.

**Part 5 — Fix the broken cron entry**

```bash
# View current crontab
crontab -l

# Edit it (this opens your $EDITOR)
crontab -e
```

Change:

```
0 2 30 * * ~/linux-missions/mission-10/backup.sh
```

To:

```
0 2 * * * ~/linux-missions/mission-10/backup.sh >> ~/linux-missions/mission-10/logs/cron-output.log 2>&1
```

**Part 6 — Test manually right now**

Don't wait for 2 AM. Test the job immediately:

```bash
bash ~/linux-missions/mission-10/backup.sh
cat ~/linux-missions/mission-10/logs/backup.log
ls ~/linux-missions/mission-10/backups/
```

**Bonus:** What is the difference between `cron` and `at`? What is `anacron` for?

## Hints

??? hint "Hint 1 – Why day-of-month 30 is a bad nightly schedule"
    ```
    "0 2 30 * *" runs at 2 AM on the 30th of each month.
    February never has a 30th. So in February and March, the job would be skipped.
    For nightly: "0 2 * * *" (every day, any month).
    ```

??? hint "Hint 2 – Testing without waiting"
    ```bash
    # Run the exact command from crontab right now
    /usr/bin/env bash ~/linux-missions/mission-10/backup.sh
    # If it works manually, it should work in cron
    # If it fails manually, fix it before adding to crontab
    ```

??? hint "Hint 3 – Capturing all output from cron"
    ```bash
    # Redirect stdout and stderr to a log file
    0 2 * * * /path/to/script.sh >> /var/log/myjob.log 2>&1
    # 2>&1 sends stderr to the same place as stdout
    # Without this, errors vanish silently
    ```

## Validation

```bash
# Manually run the script
bash ~/linux-missions/mission-10/backup.sh

# Verify the log was written
cat ~/linux-missions/mission-10/logs/backup.log
# Expected: two lines — "Backup started" and "Backup complete"

# Verify a backup file was created
ls ~/linux-missions/mission-10/backups/
# Expected: at least one .tar.gz file

# Correct cron expressions
# "0 2 * * *" = daily at 2 AM (not monthly!)
```

## Cleanup

```bash
# Remove the cron entry if you added one
crontab -l | grep -v "mission-10" | crontab -

# Remove lab files
rm -rf ~/linux-missions/mission-10
```

## What you should have learned

- Cron field order: minute, hour, day-of-month, month, day-of-week
- `0 2 30 * *` runs once a month (on the 30th), not nightly — a common mistake
- Always redirect cron output to a log file: `>> /path/to/log 2>&1`
- Cron's environment is minimal — use absolute paths for commands and scripts
- Test cron scripts manually before relying on them running unattended overnight

## Next mission

[Mission 11 – Poor Man's Monitoring →](11-poor-mans-monitoring.md)
