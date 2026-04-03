#!/bin/bash
# Smoke tests: verify devbox image is correctly built
# Usage: run_smoke_tests.sh <neovim_version> <user_name>
# Runs inside the container via the default entrypoint

set -euo pipefail

EXPECTED_NEOVIM="${1:-stable}"
EXPECTED_USER="${2:-user}"
EXPECTED_LANG="${3:-}"
EXPECTED_USER_ID="${4:-}"

fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "PASS: $*"; }

# ── Tool existence ────────────────────────────────────────────────────────────
nvim --version > /dev/null 2>&1     || fail "nvim not found"
pass "nvim installed"

tmux -V > /dev/null 2>&1            || fail "tmux not found"
pass "tmux installed"

git --version > /dev/null 2>&1      || fail "git not found"
pass "git installed"

starship --version > /dev/null 2>&1 || fail "starship not found"
pass "starship installed"

ssh -V 2>&1 | grep -qi openssh      || fail "openssh not found"
pass "openssh installed"

# ── Neovim version ───────────────────────────────────────────────────────────
if [ "${EXPECTED_NEOVIM}" != "stable" ]; then
    nvim --version | head -1 | grep -qF "${EXPECTED_NEOVIM}" \
        || fail "neovim version mismatch (expected ${EXPECTED_NEOVIM}, got: $(nvim --version | head -1))"
    pass "neovim version matches ${EXPECTED_NEOVIM}"
fi

# ── User home directory ──────────────────────────────────────────────────────
[ -d "/home/${EXPECTED_USER}" ] || fail "/home/${EXPECTED_USER} not found"
pass "home directory /home/${EXPECTED_USER} exists"

# ── Username ──────────────────────────────────────────────────────────────────
actual_user=$(whoami)
[ "${actual_user}" = "${EXPECTED_USER}" ] \
    || fail "username mismatch (expected ${EXPECTED_USER}, got: ${actual_user})"
pass "whoami = ${EXPECTED_USER}"

# ── sudo ──────────────────────────────────────────────────────────────────────
sudo -n true 2>/dev/null || fail "sudo not available for ${EXPECTED_USER}"
pass "sudo works for ${EXPECTED_USER}"

# ── HOME ──────────────────────────────────────────────────────────────────────
[ "${HOME}" = "/home/${EXPECTED_USER}" ] \
    || fail "HOME mismatch (expected /home/${EXPECTED_USER}, got: ${HOME})"
pass "HOME=/home/${EXPECTED_USER}"

# ── Locale passthrough ───────────────────────────────────────────────────────
if [ -n "${EXPECTED_LANG}" ]; then
    [ "${LANG}" = "${EXPECTED_LANG}" ] \
        || fail "LANG mismatch (expected ${EXPECTED_LANG}, got: ${LANG})"
    pass "LANG=${LANG}"
fi

# ── UID matching ──────────────────────────────────────────────────────────────
if [ -n "${EXPECTED_USER_ID}" ]; then
    actual_uid=$(id -u)
    [ "${actual_uid}" = "${EXPECTED_USER_ID}" ] \
        || fail "UID mismatch (expected ${EXPECTED_USER_ID}, got: ${actual_uid})"
    pass "UID matches ${EXPECTED_USER_ID}"
fi

# ── Project directory ownership ───────────────────────────────────────────────
if [ -d "/home/${EXPECTED_USER}/project" ]; then
    owner=$(stat -c '%U' "/home/${EXPECTED_USER}/project")
    [ "${owner}" = "${EXPECTED_USER}" ] \
        || fail "project ownership mismatch (expected ${EXPECTED_USER}, got: ${owner})"
    pass "project directory owned by ${EXPECTED_USER}"
fi

echo ""
echo "All smoke tests passed."
