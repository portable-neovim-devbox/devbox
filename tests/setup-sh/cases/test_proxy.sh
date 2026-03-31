#!/bin/bash
# Test: proxy values are written correctly

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

printf "\n\n\n\nhttp://proxy.example.com:8080\nhttps://proxy.example.com:8080\nlocalhost,127.0.0.1\nn\n" \
    | bash "${REPO_ROOT}/setup.sh"

ENV_FILE="${REPO_ROOT}/.env"

check() {
    local key="$1"
    local expected="$2"
    local actual
    actual=$(grep "^${key}=" "${ENV_FILE}" | cut -d= -f2-)
    if [ "$actual" != "$expected" ]; then
        echo "FAIL [test_proxy] ${key}: expected '${expected}', got '${actual}'"
        exit 1
    fi
}

check "HTTP_PROXY"  "http://proxy.example.com:8080"
check "HTTPS_PROXY" "https://proxy.example.com:8080"
check "NO_PROXY"    "localhost,127.0.0.1"

echo "PASS test_proxy"
