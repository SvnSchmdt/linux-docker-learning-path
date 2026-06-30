# Lab 02 – Files & Permissions

## What you're building

You'll create a small project structure, set appropriate permissions on different file types, make a script executable, and create a symlink. You'll verify each step with `ls -la` and `stat`.

**Concepts used:** `touch`, `mkdir`, `cp`, `mv`, `rm`, `chmod`, `chown`, `ln -s`, octal permissions.

```
~/lab-permissions/
├── scripts/
│   └── deploy.sh        (chmod 755)
├── config/
│   └── settings.conf    (chmod 644)
├── private/
│   └── secret.key       (chmod 600)
└── deploy -> scripts/deploy.sh   (symlink)
```

## Goal

Set correct permissions for each file type and verify them.

## Prerequisites

- Module 02 completed

## Step by Step

### Step 1: Create the directory structure

```bash
mkdir -p ~/lab-permissions/{scripts,config,private}
cd ~/lab-permissions
```

### Step 2: Create files

```bash
# Create a deploy script
cat > scripts/deploy.sh << 'EOF'
#!/usr/bin/env bash
echo "Deploying..."
EOF

# Create a config file
echo "debug=false" > config/settings.conf

# Create a "private" key file
echo "SUPER_SECRET_KEY=dummy" > private/secret.key

ls -la scripts/ config/ private/
# Expected output: all files with -rw-r--r-- (644) by default
```

### Step 3: Set appropriate permissions

```bash
# Script: owner can read/write/execute, others can read/execute
chmod 755 scripts/deploy.sh

# Config: owner read/write, others read-only
chmod 644 config/settings.conf

# Secret: owner only (read/write), no access for others
chmod 600 private/secret.key
```

### Step 4: Verify permissions

```bash
ls -la scripts/deploy.sh config/settings.conf private/secret.key
# Expected output:
# -rwxr-xr-x  1 alice alice  32 Jun 30 10:00 scripts/deploy.sh
# -rw-r--r--  1 alice alice  13 Jun 30 10:00 config/settings.conf
# -rw-------  1 alice alice  24 Jun 30 10:00 private/secret.key
```

### Step 5: Run the script

```bash
./scripts/deploy.sh
# Expected output:
# Deploying...
```

### Step 6: Create a symlink

```bash
ln -s scripts/deploy.sh deploy
ls -la deploy
# Expected output:
# lrwxrwxrwx  1 alice alice  18 Jun 30 10:00 deploy -> scripts/deploy.sh

./deploy
# Expected output:
# Deploying...
```

### Step 7: Try removing execute permission

```bash
chmod -x scripts/deploy.sh
./scripts/deploy.sh
# Expected output:
# bash: ./scripts/deploy.sh: Permission denied

# Restore it
chmod +x scripts/deploy.sh
```

## Validation

```bash
stat -c "%a %n" scripts/deploy.sh
# Expected output: 755 scripts/deploy.sh

stat -c "%a %n" private/secret.key
# Expected output: 600 private/secret.key

test -L deploy && echo "symlink OK"
# Expected output: symlink OK
```

> [!NOTE]
> On macOS, `stat` uses different flags: `stat -f "%Mp%Lp %N" filename`

## Cleanup

```bash
cd ~
rm -rf ~/lab-permissions
```

## Extension Task

Create a directory `~/lab-permissions/shared/` where:
- The owner has full access (rwx)
- The group can read and execute (r-x)
- Others have no access (---)

Hint: `chmod 750 shared/`
