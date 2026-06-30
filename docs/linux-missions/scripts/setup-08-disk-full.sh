#!/usr/bin/env bash
# Setup script for Mission 08 – Disk Full
# Creates a directory with fake large files to investigate.
# Safe: only writes to ~/linux-missions/mission-08/
# Does NOT fill the real filesystem — creates sparse dummy files.

set -e
TARGET=~/linux-missions/mission-08
rm -rf "$TARGET"
mkdir -p "$TARGET"/{logs,uploads,cache,backups}

# Create "large" dummy files using dd with sparse writes (actual disk use is minimal)
# We fake the reported size using truncate on Linux / mkfile on macOS
create_dummy() {
    local file="$1"
    local size="$2"  # size in bytes
    if command -v truncate &>/dev/null; then
        truncate -s "$size" "$file"
    else
        # macOS fallback: mkfile
        mkfile "$size" "$file" 2>/dev/null || dd if=/dev/zero of="$file" bs=1 count=0 seek="$size" 2>/dev/null
    fi
}

# Fake application logs (small, realistic)
cat > "$TARGET/logs/app.log" << 'EOF'
2026-06-30 09:00:01 INFO  Application started
2026-06-30 09:01:45 ERROR Disk write failed: no space left on device
2026-06-30 09:01:46 ERROR Disk write failed: no space left on device
EOF

# Create "large" upload files the learner must find
create_dummy "$TARGET/uploads/video-export-2026-06-01.mp4" $((200 * 1024 * 1024))  # 200MB
create_dummy "$TARGET/uploads/raw-dump-2026-05-15.bin"    $((350 * 1024 * 1024))  # 350MB
create_dummy "$TARGET/cache/render-cache-v3.dat"          $((180 * 1024 * 1024))  # 180MB

# Create fake old backups
create_dummy "$TARGET/backups/backup-2026-03-01.tar.gz"   $((120 * 1024 * 1024))  # 120MB
create_dummy "$TARGET/backups/backup-2026-04-01.tar.gz"   $((125 * 1024 * 1024))  # 125MB
create_dummy "$TARGET/backups/backup-2026-05-01.tar.gz"   $((130 * 1024 * 1024))  # 130MB

# Small important files that should NOT be deleted
echo "production database credentials" > "$TARGET/backups/db-credentials.txt"
echo '{"version": "3.2.1", "deployed": "2026-06-30"}' > "$TARGET/cache/version.json"

echo ""
echo "Mission 08 setup complete."
echo "Lab directory: $TARGET"
echo "Start with: du -sh $TARGET/* | sort -rh"
