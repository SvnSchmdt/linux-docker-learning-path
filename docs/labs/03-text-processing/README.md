# Lab 03 – Text Processing

## What you're building

You'll generate a realistic log file and then analyze it using a pipeline of `grep`, `sort`, `uniq`, `wc`, and `find`. The goal is to extract meaningful information from raw text data using only command-line tools.

**Concepts used:** `cat`, `grep`, `sort`, `uniq`, `wc`, `find`, pipes `|`, redirects `>`.

```
access.log (raw)
    │
    ├─ grep (filter by status)
    ├─ sort (alphabetically)
    ├─ uniq -c (count duplicates)
    ├─ sort -rn (sort by count)
    └─ head -10 (top 10)
         │
         └→ report.txt
```

## Goal

Build a multi-step pipeline that extracts the top 10 most frequent IP addresses from an access log.

## Prerequisites

- Module 03 completed

## Step by Step

### Step 1: Generate a sample log file

```bash
mkdir -p ~/lab-textprocessing
cat > ~/lab-textprocessing/access.log << 'EOF'
192.168.1.10 - - [30/Jun/2026:10:00:01 +0000] "GET /index.html HTTP/1.1" 200 1234
10.0.0.5 - - [30/Jun/2026:10:00:02 +0000] "POST /api/login HTTP/1.1" 401 89
192.168.1.10 - - [30/Jun/2026:10:00:03 +0000] "GET /about.html HTTP/1.1" 200 567
172.16.0.3 - - [30/Jun/2026:10:00:04 +0000] "GET /index.html HTTP/1.1" 200 1234
10.0.0.5 - - [30/Jun/2026:10:00:05 +0000] "POST /api/login HTTP/1.1" 401 89
192.168.1.10 - - [30/Jun/2026:10:00:06 +0000] "GET /contact.html HTTP/1.1" 200 890
10.0.0.7 - - [30/Jun/2026:10:00:07 +0000] "GET /index.html HTTP/1.1" 200 1234
10.0.0.5 - - [30/Jun/2026:10:00:08 +0000] "POST /api/login HTTP/1.1" 200 45
192.168.1.10 - - [30/Jun/2026:10:00:09 +0000] "GET /index.html HTTP/1.1" 304 0
172.16.0.3 - - [30/Jun/2026:10:00:10 +0000] "GET /api/data HTTP/1.1" 500 23
EOF
```

### Step 2: Count total lines

```bash
wc -l ~/lab-textprocessing/access.log
# Expected output:
# 10 /home/alice/lab-textprocessing/access.log
```

### Step 3: Find all 4xx and 5xx errors

```bash
grep -E '" [45][0-9][0-9] ' ~/lab-textprocessing/access.log
# Expected output:
# 10.0.0.5 ... "POST /api/login HTTP/1.1" 401 89
# 10.0.0.5 ... "POST /api/login HTTP/1.1" 401 89
# 172.16.0.3 ... "GET /api/data HTTP/1.1" 500 23
```

### Step 4: Count errors by status code

```bash
grep -oE '" [45][0-9][0-9] ' ~/lab-textprocessing/access.log | \
  tr -d '" ' | sort | uniq -c | sort -rn
# Expected output:
#       2 401
#       1 500
```

### Step 5: Find top IPs by request count

```bash
grep -oE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' ~/lab-textprocessing/access.log | \
  sort | uniq -c | sort -rn | head -5
# Expected output:
#       4 192.168.1.10
#       3 10.0.0.5
#       2 172.16.0.3
#       1 10.0.0.7
```

### Step 6: Save report to file

```bash
{
  echo "=== Access Log Report ==="
  echo "Total requests: $(wc -l < ~/lab-textprocessing/access.log)"
  echo ""
  echo "Top IPs:"
  grep -oE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' ~/lab-textprocessing/access.log | \
    sort | uniq -c | sort -rn
  echo ""
  echo "Error responses:"
  grep -E '" [45][0-9][0-9] ' ~/lab-textprocessing/access.log | wc -l
} > ~/lab-textprocessing/report.txt

cat ~/lab-textprocessing/report.txt
```

## Validation

```bash
test -f ~/lab-textprocessing/report.txt && echo "Report file OK"
grep -q "192.168.1.10" ~/lab-textprocessing/report.txt && echo "Top IP found in report"
```

## Cleanup

```bash
rm -rf ~/lab-textprocessing
```

## Extension Task

Find all unique URLs requested in the log and count them:

```bash
grep -oE '"(GET|POST|PUT|DELETE) [^ ]+' ~/lab-textprocessing/access.log | \
  sort | uniq -c | sort -rn
```
