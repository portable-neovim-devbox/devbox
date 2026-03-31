#!/bin/bash
# Test: invalid Host OS triggers re-prompt, valid value is accepted

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

# "ubuntu" is invalid → re-prompt → "Linux" is valid
printf "\n\n\nubuntu\nLinux\n\n\n\nn\n" | bash "${REPO_ROOT}/setup.sh"

ENV_FILE="${REPO_ROOT}/.env"

actual=$(grep "^HOST_OS=" "${ENV_FILE}" | cut -d= -f2-)
if [ "$actual" != "Linux" ]; then
    echo "FAIL [test_invalid_host_os] HOST_OS: expected 'Linux', got '${actual}'"
    exit 1
fi

echo "PASS test_invalid_host_os"
