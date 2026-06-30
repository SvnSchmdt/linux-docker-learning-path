#!/usr/bin/env bash
# Setup script for Mission 16 – Final Linux Bossfight
# Creates a broken local web app scenario the learner must diagnose and fix.
# Safe: only writes to ~/linux-missions/mission-16/

set -e
TARGET=~/linux-missions/mission-16
rm -rf "$TARGET"
mkdir -p "$TARGET"/{app,logs,config}

# The web app
cat > "$TARGET/app/server.py" << 'EOF'
#!/usr/bin/env python3
"""Simple web app. Reads config from ../config/app.conf"""
import json
import os
from http.server import HTTPServer, BaseHTTPRequestHandler

CONFIG_PATH = os.path.join(os.path.dirname(__file__), "../config/app.conf")


def load_config():
    config = {}
    with open(CONFIG_PATH) as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#"):
                key, _, value = line.partition("=")
                config[key.strip()] = value.strip()
    return config


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            body = json.dumps({"status": "ok", "port": PORT}).encode()
        else:
            body = b"Web app is running!\n"
        self.send_response(200)
        self.send_header("Content-Type", "application/json" if self.path == "/health" else "text/plain")
        self.send_header("Content-Length", len(body))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        with open(os.path.join(os.path.dirname(__file__), "../logs/access.log"), "a") as f:
            f.write(f"{self.address_string()} - {fmt % args}\n")


try:
    cfg = load_config()
    PORT = int(cfg.get("port", 8080))
except Exception as e:
    print(f"Config error: {e}", flush=True)
    raise SystemExit(1)

if __name__ == "__main__":
    print(f"Starting on port {PORT}", flush=True)
    HTTPServer(("0.0.0.0", PORT), Handler).serve_forever()
EOF

# The config — intentionally contains a bad port value
cat > "$TARGET/config/app.conf" << 'EOF'
# Web app configuration
port=808O
log_level=info
EOF
# Note: 808O has a capital letter O instead of zero — subtle!

# The start script — missing execute permission
cat > "$TARGET/start.sh" << 'EOF'
#!/usr/bin/env bash
cd "$(dirname "$0")/app"
python3 server.py
EOF
# Intentionally not executable
chmod 644 "$TARGET/start.sh"

# Fake stale log from a previous "running" state
cat > "$TARGET/logs/access.log" << 'EOF'
127.0.0.1 - GET /health 200
127.0.0.1 - GET / 200
EOF

echo ""
echo "Bossfight setup complete."
echo "Lab directory: $TARGET"
echo ""
echo "INCIDENT REPORT:"
echo "  The web app at localhost:8080 stopped responding."
echo "  On-call engineer says it was working yesterday."
echo "  Go investigate."
echo ""
echo "Start with: ls $TARGET"
