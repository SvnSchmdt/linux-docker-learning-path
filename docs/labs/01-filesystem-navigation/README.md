# Lab 01 – Filesystem Navigation

## What you're building

You'll explore the Linux filesystem structure, create a project directory tree, find hidden files, and use `find` with filters to locate specific files.

**Concepts used:** Filesystem hierarchy, absolute/relative paths, `ls`, `cd`, `tree`, `find`, hidden files.

```
/
├── etc/          ← system config
├── var/
│   └── log/      ← system logs
├── tmp/          ← temp files
└── home/
    └── you/      ← your home
        └── projects/
            └── demo/    ← you'll create this
```

## Goal

Navigate the Linux filesystem with confidence and find files using `find` with multiple filters.

## Prerequisites

- Module 01 completed
- `tree` installed (`brew install tree` on macOS / `sudo apt install tree` on Linux)

## Step by Step

### Step 1: Explore the filesystem root

```bash
ls /
# Expected output:
# bin   dev  home  lib    media  opt   root  sbin  sys  usr
# boot  etc  host  lib64  mnt    proc  run   srv   tmp  var
```

### Step 2: Find your bearings

```bash
pwd
# Expected output (example):
# /home/alice

echo "Home: $HOME"
# Expected output:
# Home: /home/alice
```

### Step 3: Create a project directory tree

```bash
mkdir -p ~/projects/demo/{src,tests,docs}
ls -la ~/projects/demo/
# Expected output:
# drwxr-xr-x  5 alice alice 4096 Jun 30 10:00 .
# drwxr-xr-x  3 alice alice 4096 Jun 30 10:00 ..
# drwxr-xr-x  2 alice alice 4096 Jun 30 10:00 docs
# drwxr-xr-x  2 alice alice 4096 Jun 30 10:00 src
# drwxr-xr-x  2 alice alice 4096 Jun 30 10:00 tests
```

### Step 4: Create some files

```bash
touch ~/projects/demo/src/main.py
touch ~/projects/demo/src/.env
touch ~/projects/demo/tests/test_main.py
echo "# Demo Project" > ~/projects/demo/README.md
```

### Step 5: Find hidden files

```bash
ls -la ~/projects/demo/src/
# Expected output (notice .env is shown with -a):
# drwxr-xr-x  2 alice alice 4096 Jun 30 10:00 .
# drwxr-xr-x  5 alice alice 4096 Jun 30 10:00 ..
# -rw-r--r--  1 alice alice    0 Jun 30 10:00 .env
# -rw-r--r--  1 alice alice    0 Jun 30 10:00 main.py
```

### Step 6: Use tree

```bash
tree ~/projects/demo
# Expected output:
# /home/alice/projects/demo
# ├── README.md
# ├── docs
# ├── src
# │   ├── .env
# │   └── main.py
# └── tests
#     └── test_main.py
```

### Step 7: Use find with filters

```bash
# Find all Python files
find ~/projects -name "*.py"
# Expected output:
# /home/alice/projects/demo/src/main.py
# /home/alice/projects/demo/tests/test_main.py

# Find hidden files
find ~/projects -name ".*" -type f
# Expected output:
# /home/alice/projects/demo/src/.env

# Find directories only
find ~/projects -type d
```

## Validation

```bash
# Verify your directory tree exists
test -d ~/projects/demo/src && echo "OK: src exists"
test -d ~/projects/demo/tests && echo "OK: tests exists"
test -f ~/projects/demo/README.md && echo "OK: README exists"
test -f ~/projects/demo/src/.env && echo "OK: .env hidden file exists"

find ~/projects -name "*.py" | wc -l
# Expected output: 2
```

## Cleanup

```bash
rm -rf ~/projects/demo
```

## Extension Task

Find all files in `/etc` that are:
- Regular files (not directories or symlinks)
- Readable by your user
- Smaller than 1KB

Hint: `find /etc -type f -readable -size -1k 2>/dev/null | head -20`
