#!/bin/sh
# Generates xray config from env vars and runs xray.
# Required env: UUID. Optional: WS_PATH (default /ws), PORT (set by Railway).
set -e

if [ -z "${UUID}" ]; then
  echo "ERROR: UUID env var is not set" >&2
  exit 1
fi

WS_PATH="${WS_PATH:-/ws}"
PORT="${PORT:-8080}"

cat > /etc/xray.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [ { "id": "${UUID}" } ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "${WS_PATH}" }
      }
    }
  ],
  "outbounds": [ { "protocol": "freedom" } ]
}
EOF

echo "Starting xray on port ${PORT}, ws path ${WS_PATH}"
exec /usr/local/bin/xray run -c /etc/xray.json
