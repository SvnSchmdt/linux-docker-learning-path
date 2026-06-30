# Mission 07 – Log Hunt

## Scenario

Something bad happened on the server in the last 72 hours. You don't know what. You have a multi-day application log. Your job is to find it.

This is not a tutorial — this is an investigation.

## Goal

Parse, filter, and extract meaningful signal from a large log file. Find the critical event and answer questions about it.

## What you will practice

- `grep` with `-i`, `-n`, `-A`, `-B`, `-C`
- `awk` for column extraction
- `sort` and `uniq -c` for frequency analysis
- `wc -l` for counting
- `tail` and `head` for time-bounded reads

## Setup

```bash
bash ~/path/to/docs/linux-missions/scripts/setup-07-log-hunt.sh
```

When done:

```
Mission 07 setup complete.
Lab file: ~/linux-missions/mission-07/app.log
```

## Mission

You have `~/linux-missions/mission-07/app.log` — three days of application logs. Something went wrong. Find it.

**Part 1 — Orient yourself**

```bash
wc -l ~/linux-missions/mission-07/app.log
head -5 ~/linux-missions/mission-07/app.log
tail -5 ~/linux-missions/mission-07/app.log
```

Answer:

1. How many log lines are there?
2. What date range does the log cover?
3. What log levels appear in the file?

**Part 2 — Find errors**

```bash
grep -i "error\|critical\|fatal" ~/linux-missions/mission-07/app.log
```

Questions:

4. How many ERROR lines are there?
5. Is there a CRITICAL event? What does it say?
6. What timestamp does the critical event appear at?

**Part 3 — Get context around the critical event**

```bash
grep -n "CRITICAL" ~/linux-missions/mission-07/app.log
```

Use the line number to get surrounding context:

```bash
grep -n "CRITICAL" ~/linux-missions/mission-07/app.log | head -1
# Note the line number, e.g. 87
sed -n '82,92p' ~/linux-missions/mission-07/app.log
```

Or use grep's context flags:

```bash
grep -B5 -A5 "CRITICAL" ~/linux-missions/mission-07/app.log
```

Questions:

7. What happened in the 3 lines before the CRITICAL event?
8. What happened in the 3 lines after?
9. What was the root cause?

**Part 4 — Frequency analysis**

```bash
# Count occurrences of each log level
grep -oP '\[(INFO|WARN|ERROR|CRITICAL)\]' ~/linux-missions/mission-07/app.log \
  | sort | uniq -c | sort -rn
```

**Part 5 — Extract specific fields with awk**

```bash
# Print only timestamps and log levels
awk '{print $1, $2, $3}' ~/linux-missions/mission-07/app.log | head -20

# Show all lines from a specific date
grep "^2026-06-29" ~/linux-missions/mission-07/app.log
```

**Bonus:** Write a one-liner that prints the number of ERROR lines per hour on the day of the incident.

## Hints

??? hint "Hint 1 – Counting errors"
    ```bash
    grep -c "ERROR" ~/linux-missions/mission-07/app.log
    # -c counts matching lines
    ```

??? hint "Hint 2 – Getting context lines"
    ```bash
    grep -B3 -A3 "CRITICAL" ~/linux-missions/mission-07/app.log
    # -B3 = 3 lines Before
    # -A3 = 3 lines After
    # -C3 = 3 lines both directions (Context)
    ```

??? hint "Hint 3 – Errors per hour"
    ```bash
    grep "2026-06-29" ~/linux-missions/mission-07/app.log \
      | grep "ERROR" \
      | awk '{print $2}' \
      | cut -d: -f1 \
      | sort | uniq -c
    ```

## Validation

```bash
# Find the critical event
grep "CRITICAL" ~/linux-missions/mission-07/app.log
# Expected: a line mentioning "disk" and "full" or "no space left"

# Count total log lines
wc -l ~/linux-missions/mission-07/app.log
# Expected: approximately 150 lines

# Confirm you can extract the timestamp
grep "CRITICAL" ~/linux-missions/mission-07/app.log | awk '{print $1, $2}'
# Expected: a date and time from 2026-06-29
```

## Cleanup

```bash
rm -rf ~/linux-missions/mission-07
```

## What you should have learned

- `grep -c` counts; `grep -n` shows line numbers; `grep -C3` shows surrounding context
- `uniq -c | sort -rn` is the pattern for frequency analysis of any text data
- Real log investigation starts with orientation (how big? what dates?) then narrows to signals
- `awk '{print $N}'` extracts specific space-delimited columns — columns 1–3 are usually timestamp + level
- This skill directly transfers to `docker logs`, `kubectl logs`, and cloud log viewers (CloudWatch, Stackdriver)

## Next mission

[Mission 08 – Disk Full →](08-disk-full.md)
