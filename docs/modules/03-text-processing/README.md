# Module 03 – Text Processing

## Module Goal

Process, filter, and transform text files and command output using standard Linux tools.

## Why does this matter?

Log files, configuration files, CSV exports, and command output are all text. Linux gives you a powerful set of tools to slice, filter, count, and combine text on the command line — without needing a GUI or a script. These tools compose together using pipes, making them extraordinarily flexible.

## Core Concepts

### Viewing Files

```bash
cat file.txt          # print entire file
less file.txt         # paginated view (q to quit, / to search)
head -n 20 file.txt   # first 20 lines
tail -n 20 file.txt   # last 20 lines
tail -f app.log       # follow log file in real time
```

### Searching with grep

```bash
grep "pattern" file.txt         # search for pattern
grep -i "error" app.log         # case-insensitive
grep -r "TODO" src/             # recursive search
grep -n "func" main.go          # show line numbers
grep -v "DEBUG" app.log         # invert match (exclude DEBUG lines)
```

### Counting and Statistics

```bash
wc -l file.txt        # count lines
wc -w file.txt        # count words
sort file.txt         # sort lines alphabetically
sort -n numbers.txt   # numeric sort
uniq sorted.txt       # remove consecutive duplicates
sort file.txt | uniq -c | sort -rn   # count occurrences, most frequent first
```

### Pipes and Redirects

```bash
command1 | command2    # pipe: stdout of cmd1 → stdin of cmd2
command > file.txt     # redirect stdout to file (overwrite)
command >> file.txt    # redirect stdout to file (append)
command 2>&1           # redirect stderr to stdout
command 2>/dev/null    # discard stderr
```

### Finding Files

```bash
find . -name "*.log"              # find by name
find /etc -name "*.conf" -type f  # files only
find . -newer reference.txt       # files newer than reference
find . -size +1M                  # files larger than 1MB
```

## Hands-on Task

1. Find all lines containing "error" (case-insensitive) in `/var/log/system.log` (macOS) or `/var/log/syslog` (Linux)
2. Count how many unique error types appear
3. Save the result to `~/errors.txt`
4. Find all `.txt` files under your home directory modified in the last 7 days

## Example Commands

```bash
# View the last 50 lines of a log file
tail -n 50 /var/log/system.log

# Find all error lines, count them
grep -i "error" /var/log/system.log | wc -l

# Get unique IPs from an access log
grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' access.log | sort | uniq -c | sort -rn

# Find all Python files containing TODO
find . -name "*.py" | xargs grep -l "TODO"

# Chain: find errors, sort, count unique, show top 10
grep -i "error" app.log | sort | uniq -c | sort -rn | head -10

# Redirect stderr to a file
./script.sh 2> errors.log

# Redirect both stdout and stderr
./script.sh > output.log 2>&1
```

## Common Mistakes

- **`grep` without `-r` on a directory** — use `grep -r` to search recursively
- **Forgetting that `>` overwrites** — use `>>` to append to an existing file
- **`sort | uniq`** — `uniq` only removes *consecutive* duplicates, so you must sort first
- **Pipe vs redirect confusion** — `|` connects commands; `>` writes to a file

## Checkpoint

- [ ] I can search files with `grep` and combine flags (`-i`, `-r`, `-n`, `-v`)
- [ ] I can build multi-step pipelines with `|`
- [ ] I can redirect output to files with `>` and `>>`
- [ ] I can find files by name, type, and size with `find`

## Definition of Done

You can analyze a log file from the command line: find specific patterns, count occurrences, sort results, and save the output to a file.

## Further Reading

- `man grep`
- `man find`
- `man sort`
- `man uniq`
