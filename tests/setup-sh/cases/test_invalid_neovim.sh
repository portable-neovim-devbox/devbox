#!/bin/bash
# Test: invalid Neovim version triggers re-prompt, valid value is accepted

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

# "latest" is invalid → re-prompt → "v0.9.5" is valid
printf "latest\nv0.9.5\n\n\n\n\n\nn\n" | bash "${REPO_ROOT}/setup.sh"

ENV_FILE="${REPO_ROOT}/.env"

actual=$(grep "^NEOVIM_VERSION=" "${ENV_FILE}" | cut -d= -f2-)
if [ "$actual" != "v0.9.5" ]; then
    echo "FAIL [test_invalid_neovim] NEOVIM_VERSION: expected 'v0.9.5', got '${actual}'"
    exit 1
fi

echo "PASS test_invalid_neovim"
