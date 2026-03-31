#!/bin/bash
# Test: all defaults (Enter only for every prompt)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

printf "\n\n\n\n\n\nn\n" | bash "${REPO_ROOT}/setup.sh"

ENV_FILE="${REPO_ROOT}/.env"

check() {
    local key="$1"
    local expected="$2"
    local actual
    actual=$(grep "^${key}=" "${ENV_FILE}" | cut -d= -f2-)
    if [ "$actual" != "$expected" ]; then
        echo "FAIL [test_defaults] ${key}: expected '${expected}', got '${actual}'"
        exit 1
    fi
}

check "NEOVIM_VERSION" "stable"
check "USER_NAME"      "user"
check "LANG"           "en_US.UTF-8"
check "HTTP_PROXY"     ""
check "HTTPS_PROXY"    ""
check "NO_PROXY"       ""

echo "PASS test_defaults"
