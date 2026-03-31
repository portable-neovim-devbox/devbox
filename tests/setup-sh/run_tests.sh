#!/bin/bash
# Test runner for setup.sh — runs all cases, restores .env on exit

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
ENV_FILE="${REPO_ROOT}/.env"
ENV_BACKUP="${REPO_ROOT}/.env.bak"

restore_env() {
    if [ -f "${ENV_BACKUP}" ]; then
        mv "${ENV_BACKUP}" "${ENV_FILE}"
    else
        rm -f "${ENV_FILE}"
    fi
}

trap restore_env EXIT

[ -f "${ENV_FILE}" ] && cp "${ENV_FILE}" "${ENV_BACKUP}"

CASES_DIR="${SCRIPT_DIR}/cases"
PASS=0
FAIL=0

for case_file in "${CASES_DIR}"/test_*.sh; do
    bash "${case_file}"
    status=$?
    if [ $status -eq 0 ]; then
        PASS=$((PASS + 1))
    else
        FAIL=$((FAIL + 1))
    fi
    rm -f "${ENV_FILE}"
done

echo ""
echo "Results: ${PASS} passed, ${FAIL} failed"

[ $FAIL -eq 0 ]
