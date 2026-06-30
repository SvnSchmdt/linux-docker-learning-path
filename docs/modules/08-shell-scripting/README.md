# Module 08 – Shell Scripting

## Module Goal

Write practical shell scripts using variables, conditionals, loops, and functions.

## Why does this matter?

Shell scripts automate repetitive tasks. Instead of typing the same 5 commands every time you deploy, you write a script. Understanding shell scripting also makes you much better at reading and maintaining existing scripts — which exist everywhere in production systems.

## Core Concepts

### Shebang

The first line of a shell script tells the OS which interpreter to use:

```bash
#!/bin/bash
#!/usr/bin/env bash    # preferred: finds bash in PATH
```

### Variables

```bash
name="Alice"           # no spaces around =
echo "Hello, $name"    # use with $
echo "Hello, ${name}"  # explicit variable boundary

# Command substitution
today=$(date +%Y-%m-%d)
files=$(ls *.txt)
```

### Conditionals

```bash
if [ -f "file.txt" ]; then
    echo "File exists"
elif [ -d "dir/" ]; then
    echo "Directory exists"
else
    echo "Neither found"
fi

# Common test operators
[ -f file ]    # file exists and is a regular file
[ -d dir ]     # directory exists
[ -z "$var" ]  # string is empty
[ -n "$var" ]  # string is not empty
[ "$a" = "$b" ] # strings are equal
[ $n -eq 42 ]  # numbers are equal
```

### Loops

```bash
# for loop
for i in 1 2 3 4 5; do
    echo "Step $i"
done

# for loop over files
for file in *.txt; do
    echo "Processing $file"
done

# while loop
count=0
while [ $count -lt 5 ]; do
    echo "Count: $count"
    count=$((count + 1))
done
```

### Functions

```bash
greet() {
    local name="$1"    # $1 is first argument
    echo "Hello, $name!"
}

greet "World"    # call the function
```

### Exit Codes and Error Handling

```bash
# Check the exit code of the last command
ls file.txt
echo "Exit code: $?"    # 0 = success, non-zero = error

# set -e: exit immediately on error
# set -u: treat unset variables as errors
set -e
set -u

# Make script executable
chmod +x script.sh
./script.sh
```

## Hands-on Task

Write a script `backup.sh` that:
1. Takes a directory name as argument `$1`
2. Checks if the directory exists (if not, exit with error message)
3. Creates a tarball: `backup-YYYY-MM-DD.tar.gz`
4. Prints a success message with the backup filename

## Example Script

```bash
#!/usr/bin/env bash
set -e
set -u

SOURCE_DIR="${1:-}"

if [ -z "$SOURCE_DIR" ]; then
    echo "Usage: $0 <directory>" >&2
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: '$SOURCE_DIR' is not a directory" >&2
    exit 1
fi

DATE=$(date +%Y-%m-%d)
BACKUP_FILE="backup-${DATE}.tar.gz"

tar -czf "$BACKUP_FILE" "$SOURCE_DIR"
echo "Backup created: $BACKUP_FILE"
```

```bash
# Run the script
chmod +x backup.sh
./backup.sh ~/projects

# Expected output:
# Backup created: backup-2026-06-30.tar.gz
```

## Common Mistakes

- **Spaces around `=` in variable assignment** — `name = "Alice"` fails; use `name="Alice"`
- **Missing quotes around variables** — `rm $file` breaks if `$file` contains spaces; use `rm "$file"`
- **Forgetting `chmod +x`** — the script won't execute without it
- **Not using `set -e`** — the script silently continues after a failed command

> [!WARNING]
> Always quote variables: `"$var"` not `$var`. Unquoted variables with spaces will split into multiple arguments.

## Checkpoint

- [ ] I can write a script with shebang, variables, and an if-condition
- [ ] I can loop over a list and over files
- [ ] I can use `$1`, `$2` for script arguments
- [ ] I know what `$?` contains and how to use `set -e`

## Definition of Done

You can write a script that takes arguments, validates them, does something useful with a loop, and handles errors correctly.

## Further Reading

- `man bash` — sections on variables, conditionals, and loops
- [Bash Pitfalls](https://mywiki.wooledge.org/BashPitfalls) — common mistakes and how to avoid them
