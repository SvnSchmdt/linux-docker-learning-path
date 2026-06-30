#!/usr/bin/env bash
# Setup script for Mission 02 – Permission Denied
# Creates scripts with broken permissions for the learner to fix.
# Safe: only writes to ~/linux-missions/mission-02/

set -e
TARGET=~/linux-missions/mission-02
rm -rf "$TARGET"
mkdir -p "$TARGET"

cat > "$TARGET/deploy.sh" << 'EOF'
#!/usr/bin/env bash
echo "Deploying application..."
echo "Copying files..."
echo "Restarting service..."
echo "Deploy complete."
EOF

cat > "$TARGET/healthcheck.sh" << 'EOF'
#!/usr/bin/env bash
echo "Running health check..."
echo "HTTP: OK"
echo "DB: OK"
echo "Cache: OK"
EOF

cat > "$TARGET/backup.sh" << 'EOF'
#!/usr/bin/env bash
echo "Starting backup..."
tar -czf /tmp/backup-$(date +%Y%m%d).tar.gz . 2>/dev/null && echo "Backup done."
EOF

# Strip all execute bits — learner must fix this
chmod 644 "$TARGET/deploy.sh"
chmod 444 "$TARGET/healthcheck.sh"   # read-only
chmod 600 "$TARGET/backup.sh"        # owner read/write only

# Create a directory with wrong permissions
mkdir -p "$TARGET/configs"
chmod 000 "$TARGET/configs"

cat > "$TARGET/README.txt" << 'EOF'
You need to run deploy.sh to deploy the application.
Good luck.
EOF

echo ""
echo "Mission 02 setup complete."
echo "Lab directory: $TARGET"
echo "Try running: $TARGET/deploy.sh"
