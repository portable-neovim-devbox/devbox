#!/bin/bash
# Smoke tests: verify devbox image is correctly built
# Usage: run_smoke_tests.sh <neovim_version> <user_name>
# Runs inside the container with --entrypoint bash

set -euo pipefail

EXPECTED_NEOVIM="${1:-stable}"
EXPECTED_USER="${2:-user}"
EXPECTED_LANG="${3:-}"

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

# ── Locale passthrough ───────────────────────────────────────────────────────
if [ -n "${EXPECTED_LANG}" ]; then
    [ "${LANG}" = "${EXPECTED_LANG}" ] \
        || fail "LANG mismatch (expected ${EXPECTED_LANG}, got: ${LANG})"
    pass "LANG=${LANG}"
fi

echo ""
echo "All smoke tests passed."
