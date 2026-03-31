#!/bin/bash
# Set up a dummy HTTP forward proxy using tinyproxy
# Writes PROXY_ADDR to GITHUB_ENV for use in subsequent steps

set -euo pipefail

PROXY_PORT=8888

sudo apt-get install -y --quiet tinyproxy

sudo tee /etc/tinyproxy/tinyproxy.conf > /dev/null << 'EOF'
Port 8888
Listen 0.0.0.0
Timeout 600
Allow 127.0.0.1
Allow 172.16.0.0/12
DisableViaHeader Yes
LogLevel Critical
LogFile "/tmp/tinyproxy.log"
PidFile "/run/tinyproxy/tinyproxy.pid"
EOF

sudo mkdir -p /run/tinyproxy
sudo chown tinyproxy:tinyproxy /run/tinyproxy
sudo systemctl restart tinyproxy
sleep 2

DOCKER_GATEWAY=$(docker network inspect bridge --format='{{range .IPAM.Config}}{{.Gateway}}{{end}}')

echo "PROXY_ADDR=http://${DOCKER_GATEWAY}:${PROXY_PORT}" >> "${GITHUB_ENV}"

echo "Dummy proxy started on port ${PROXY_PORT} (reachable from Docker at ${DOCKER_GATEWAY}:${PROXY_PORT})"
