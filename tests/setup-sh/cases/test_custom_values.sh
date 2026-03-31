#!/bin/bash
# Test: all custom values provided explicitly

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

printf "v0.10.4\ndevuser\nja_JP.UTF-8\nMacOS\nhttp://proxy.example.com:8080\nhttps://proxy.example.com:8080\nlocalhost,127.0.0.1\nn\n" \
    | bash "${REPO_ROOT}/setup.sh"

ENV_FILE="${REPO_ROOT}/.env"

check() {
    local key="$1"
    local expected="$2"
    local actual
    actual=$(grep "^${key}=" "${ENV_FILE}" | cut -d= -f2-)
    if [ "$actual" != "$expected" ]; then
        echo "FAIL [test_custom_values] ${key}: expected '${expected}', got '${actual}'"
        exit 1
    fi
}

check "NEOVIM_VERSION" "v0.10.4"
check "USER_NAME"      "devuser"
check "LANG"           "ja_JP.UTF-8"
check "HOST_OS"        "MacOS"
check "HTTP_PROXY"     "http://proxy.example.com:8080"
check "HTTPS_PROXY"    "https://proxy.example.com:8080"
check "NO_PROXY"       "localhost,127.0.0.1"

echo "PASS test_custom_values"
