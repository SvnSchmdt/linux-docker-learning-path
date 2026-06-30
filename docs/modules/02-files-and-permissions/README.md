# Module 02 – Files & Permissions

## Module Goal

Create, move, and delete files; understand and set Unix file permissions.

## Why does this matter?

File permissions are the primary security model in Linux. They control who can read, write, or execute every file and directory on the system. Understanding them is essential for both security and for avoiding "permission denied" errors.

## Core Concepts

### File Operations

```bash
touch file.txt          # create empty file
mkdir -p dir/sub        # create directory (and parents with -p)
cp src dst              # copy file
mv src dst              # move/rename file
rm file.txt             # delete file
rm -r dir/              # delete directory recursively
```

### Permission Model (rwx)

Every file has permissions for three groups:

```
-rwxr-xr--  1  alice  staff  1234  Jun 30 10:00  script.sh
 ^^^ ^^^ ^^^
 |   |   └── other (everyone else): r-- = read only
 |   └────── group: r-x = read and execute
 └────────── user (owner): rwx = read, write, execute
```

| Symbol | Meaning for files | Meaning for directories |
|--------|-------------------|------------------------|
| `r` | Read file content | List directory contents |
| `w` | Write/modify file | Create/delete files in dir |
| `x` | Execute as program | Enter the directory (`cd`) |

### Octal Notation

Permissions can be expressed as a three-digit octal number:

| Octal | Binary | Meaning |
|-------|--------|---------|
| 7 | 111 | rwx |
| 6 | 110 | rw- |
| 5 | 101 | r-x |
| 4 | 100 | r-- |
| 0 | 000 | --- |

Common permissions:
- `755` — owner: rwx, group: r-x, other: r-x (typical for executables)
- `644` — owner: rw-, group: r--, other: r-- (typical for files)
- `700` — owner: rwx, group: ---, other: --- (private directory)

### Symbolic Links

```bash
ln -s /path/to/original linkname    # create symlink
ls -la                               # symlinks shown with ->
```

## Hands-on Task

1. Create a file `~/demo/script.sh` and add `#!/bin/bash` to it
2. Make it executable: `chmod +x ~/demo/script.sh`
3. Set permissions explicitly to `755` and verify with `ls -l`
4. Create a symlink `~/script` pointing to `~/demo/script.sh`

## Example Commands

```bash
# Create a file
touch notes.txt

# Create nested directories
mkdir -p projects/demo/src

# Copy a file
cp notes.txt notes.backup.txt

# Move/rename a file
mv notes.backup.txt archive/notes-2026.txt

# Delete a file
rm notes.txt

# Set permissions (symbolic)
chmod +x script.sh        # add execute for all
chmod u+w,g-w file.txt    # add write for user, remove for group

# Set permissions (octal)
chmod 755 script.sh
chmod 644 config.txt

# Change owner
chown alice:staff file.txt

# Create symlink
ln -s /usr/local/bin/python3 ~/bin/python

# Inspect permissions
ls -la
stat file.txt
```

## Common Mistakes

- **`chmod 777` is almost always wrong** — it gives everyone full access; use `755` or `644` instead
- **Confusing `-R` (recursive) with `-r`** — for `chmod` and `chown`, use `-R` (uppercase)
- **Forgetting that directories need execute (`x`) to be entered** — even if you have read permission on a directory, you can't `cd` into it without `x`

> [!WARNING]
> Never use `chmod 777` on sensitive files. Use the minimum permissions required.

## Checkpoint

- [ ] I can create, copy, move, and delete files and directories
- [ ] I can read permission strings like `rwxr-xr--`
- [ ] I can set permissions with both symbolic (`chmod +x`) and octal (`chmod 755`) notation
- [ ] I understand the difference between `chown` and `chmod`

## Definition of Done

You can set file permissions correctly for common scenarios (web server files, scripts, configuration) and explain why each permission level is appropriate.

## Further Reading

- `man chmod`
- `man chown`
- `man ln`
