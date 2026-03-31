#!/bin/bash
# Interactive DevBox setup — writes .env and optionally builds the image.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${SCRIPT_DIR}/.env"

# ── colours ──────────────────────────────────────────────────────────────────
C_RESET='\033[0m'
C_BOLD='\033[1m'
C_CYAN='\033[0;36m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_RED='\033[0;31m'

# ── helpers ───────────────────────────────────────────────────────────────────
info()    { echo -e "${C_CYAN}${*}${C_RESET}"; }
success() { echo -e "${C_GREEN}${*}${C_RESET}"; }
warn()    { echo -e "${C_YELLOW}${*}${C_RESET}"; }
err()     { echo -e "${C_RED}${*}${C_RESET}" >&2; }

# prompt_default <display_text> <default_value>
# Prints "  display_text [default]: " and returns the entered value (or default).
prompt_default() {
    local text="$1"
    local default="$2"
    local value
    if [ -n "$default" ]; then
        read -rp "  ${text} [${default}]: " value
    else
        read -rp "  ${text} []: " value
    fi
    echo "${value:-$default}"
}

# prompt_bool <display_text> <default y|n> → exits 0 for yes, 1 for no
prompt_bool() {
    local text="$1"
    local default="${2:-n}"
    local hint
    if [ "$default" = "y" ]; then hint="Y/n"; else hint="y/N"; fi
    local answer
    read -rp "  ${text} [${hint}]: " answer
    answer="${answer:-$default}"
    [[ "${answer,,}" == "y" ]]
}

validate_neovim_version() {
    local v="$1"
    [[ "$v" == "stable" ]] || [[ "$v" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]
}

validate_host_os() {
    local os="$1"
    [[ "$os" == "Windows" || "$os" == "MacOS" || "$os" == "Linux" ]]
}

# ── auto-detect defaults ──────────────────────────────────────────────────────
case "$(uname -s)" in
    Darwin) DETECTED_OS="MacOS" ;;
    Linux)  DETECTED_OS="Linux" ;;
    *)      DETECTED_OS="Linux" ;;
esac

# ── banner ────────────────────────────────────────────────────────────────────
echo
echo -e "${C_BOLD}╔══════════════════════════════════════╗${C_RESET}"
echo -e "${C_BOLD}║        DevBox Interactive Setup      ║${C_RESET}"
echo -e "${C_BOLD}╚══════════════════════════════════════╝${C_RESET}"
echo
info "Press Enter to accept the default shown in [brackets]."
echo

# ── Neovim version ────────────────────────────────────────────────────────────
echo -e "${C_BOLD}── Neovim ─────────────────────────────${C_RESET}"
info "  Use \"stable\" or a specific tag, e.g. \"v0.10.4\"."
while true; do
    NEOVIM_VERSION=$(prompt_default "Neovim version" "stable")
    if validate_neovim_version "$NEOVIM_VERSION"; then break; fi
    err "  Invalid: must be \"stable\" or match vX.Y.Z"
done
echo

# ── Container user ────────────────────────────────────────────────────────────
echo -e "${C_BOLD}── Container User ─────────────────────${C_RESET}"
USER_NAME=$(prompt_default "Username inside container" "user")
echo

# ── Locale ────────────────────────────────────────────────────────────────────
echo -e "${C_BOLD}── Locale ─────────────────────────────${C_RESET}"
LANG_VAL=$(prompt_default "LANG" "en_US.UTF-8")
echo

# ── Host OS ───────────────────────────────────────────────────────────────────
echo -e "${C_BOLD}── Host OS ────────────────────────────${C_RESET}"
info "  Options: Windows, MacOS, Linux"
while true; do
    HOST_OS=$(prompt_default "Host OS" "$DETECTED_OS")
    if validate_host_os "$HOST_OS"; then break; fi
    err "  Must be one of: Windows, MacOS, Linux"
done
echo

# ── Proxy ─────────────────────────────────────────────────────────────────────
echo -e "${C_BOLD}── Proxy (leave empty to skip) ────────${C_RESET}"
HTTP_PROXY=$(prompt_default "HTTP_PROXY"  "")
HTTPS_PROXY=$(prompt_default "HTTPS_PROXY" "")
NO_PROXY=$(prompt_default "NO_PROXY"    "")
echo

# ── Write .env ────────────────────────────────────────────────────────────────
cat > "$ENV_FILE" <<EOF
# Neovim version to install: select from
# - "stable" (default)
# - specific version tag, e.g., "v0.9.8"
NEOVIM_VERSION=${NEOVIM_VERSION}

# Main user name inside the container
# Default: "user"
USER_NAME=${USER_NAME}

# Locale setting for the container
# Default: "en_US.UTF-8"
LANG=${LANG_VAL}

# Host OS: select from
# - "Windows" (default)
# - "MacOS"
# - "Linux"
HOST_OS=${HOST_OS}

# Proxy settings (leave empty if not needed)
HTTP_PROXY=${HTTP_PROXY}
HTTPS_PROXY=${HTTPS_PROXY}
NO_PROXY=${NO_PROXY}
EOF

success "✓ .env written to ${ENV_FILE}"
echo

# ── Optionally build ──────────────────────────────────────────────────────────
if prompt_bool "Build Docker image now?" "n"; then
    echo
    info "Running: docker compose build"
    (cd "$SCRIPT_DIR" && docker compose build)
    success "✓ Build complete."
fi

echo
success "Setup done!"
