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
C_MAGENTA='\033[1;35m'

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

generate_default_dotfiles() {
    local d="${SCRIPT_DIR}/dotfiles"

    info "Generating default dotfiles..."

    # ── git ──────────────────────────────────────────────────────────────────
    mkdir -p "${d}/git"
    touch "${d}/git/.gitconfig"
    touch "${d}/git/.gitattributes"

    # ── nvim ─────────────────────────────────────────────────────────────────
    mkdir -p "${d}/nvim/lsp"
    mkdir -p "${d}/nvim/lua/config/plugins/define"
    touch "${d}/nvim/init.lua"
    touch "${d}/nvim/lazy-lock.json"
    touch "${d}/nvim/lsp/lua-ls.lua"
    touch "${d}/nvim/lua/config/clipboard.lua"
    touch "${d}/nvim/lua/config/keymaps.lua"
    touch "${d}/nvim/lua/config/lazy.lua"
    touch "${d}/nvim/lua/myluamodule.lua"
    touch "${d}/nvim/lua/config/plugins/define/catppuccin.lua"
    touch "${d}/nvim/lua/config/plugins/define/lsp-config.lua"
    touch "${d}/nvim/lua/config/plugins/define/lualine.lua"
    touch "${d}/nvim/lua/config/plugins/define/neotree.lua"
    touch "${d}/nvim/lua/config/plugins/define/telescope.lua"
    touch "${d}/nvim/lua/config/plugins/define/treesitter.lua"

    # ── starship ─────────────────────────────────────────────────────────────
    mkdir -p "${d}/starship"
    touch "${d}/starship/starship.toml"

    # ── tmux ─────────────────────────────────────────────────────────────────
    mkdir -p "${d}/tmux"

    cat > "${d}/tmux/.tmux.conf" <<'EOF'
set-option -g default-command bash
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"
EOF

    success "✓ Default dotfiles generated."
}


# ── clear screen ─────────────────────────────────────────────────────────────────
clear 2>/dev/null || true

# ── banner ────────────────────────────────────────────────────────────────────
echo
sleep 0.05
echo -e "  ${C_CYAN}██████╗ ███████╗██╗   ██╗${C_MAGENTA}██████╗  ██████╗ ██╗  ██╗${C_RESET}"
sleep 0.05
echo -e "  ${C_CYAN}██╔══██╗██╔════╝██║   ██║${C_MAGENTA}██╔══██╗██╔═══██╗╚██╗██╔╝${C_RESET}"
sleep 0.05
echo -e "  ${C_CYAN}██║  ██║█████╗  ██║   ██║${C_MAGENTA}██████╔╝██║   ██║ ╚███╔╝ ${C_RESET}"
sleep 0.05
echo -e "  ${C_CYAN}██║  ██║██╔══╝  ╚██╗ ██╔╝${C_MAGENTA}██╔══██╗██║   ██║ ██╔██╗ ${C_RESET}"
sleep 0.05
echo -e "  ${C_CYAN}██████╔╝███████╗ ╚████╔╝ ${C_MAGENTA}██████╔╝╚██████╔╝██╔╝ ██╗${C_RESET}"
sleep 0.05
echo -e "  ${C_CYAN}╚═════╝ ╚══════╝  ╚═══╝  ${C_MAGENTA}╚═════╝  ╚═════╝ ╚═╝  ╚═╝${C_RESET}"
sleep 0.05
echo -e "  ${C_BOLD}Portable Neovim Development Environment${C_RESET}"
echo
sleep 1
info "Press Enter to accept the default shown in [brackets]."
echo
sleep 0.5

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
LANG_VAL=$(prompt_default "LANG" "")
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

    # ── Dotfiles source ───────────────────────────────────────────────────────
    echo -e "${C_BOLD}── Dotfiles ───────────────────────────${C_RESET}"
    if prompt_bool "Fetch dotfiles from GitHub? (portable-neovim-devbox/devbox-dotfiles)" "y"; then
        echo
        info "  Cloning dotfiles... (SSH passphrase may be required)"
        rm -rf "${SCRIPT_DIR}/dotfiles"
        if git clone git@github.com:portable-neovim-devbox/devbox-dotfiles.git "${SCRIPT_DIR}/dotfiles"; then
            success "✓ Dotfiles fetched."
        else
            err "  Failed to clone dotfiles. Falling back to defaults."
            generate_default_dotfiles
        fi
    else
        generate_default_dotfiles
    fi
    echo

    info "Cleaning up existing devbox containers, volumes, and images..."
    docker container stop $(docker ps -a -q --filter "name=devbox" 2>/dev/null) 2>/dev/null || true
    docker container rm $(docker ps -a -q --filter "name=devbox" 2>/dev/null) 2>/dev/null || true
    docker volume rm $(docker volume ls -q --filter "name=devbox_" 2>/dev/null) 2>/dev/null || true
    docker image rm $(docker images --filter "reference=*devbox*" --format "{{.ID}}" 2>/dev/null) 2>/dev/null || true

    info "Running: docker compose build"
    (cd "$SCRIPT_DIR" && docker compose build)
    success "✓ Build complete."
fi

echo

# ── bashrc setup ──────────────────────────────────────────────────────────
BASHRC_FILE="${HOME}/.bashrc"

ALIAS_BEGIN="# >>> devbox alias begin <<<"
ALIAS_END="# >>> devbox alias end <<<"
ALIAS_BLOCK="${ALIAS_BEGIN}
export DEVBOX_PATH=\"${SCRIPT_DIR}\"
alias devbox='bash \"\$DEVBOX_PATH/run-devbox.sh\"'
${ALIAS_END}"

if [ -f "$BASHRC_FILE" ]; then
    if grep -qF "$ALIAS_BEGIN" "$BASHRC_FILE"; then
        # Remove existing block (begin line through end line, inclusive)
        sed -i "/$(printf '%s' "$ALIAS_BEGIN" | sed 's/[^^]/[&]/g; s/\^/\\^/g')/,/$(printf '%s' "$ALIAS_END" | sed 's/[^^]/[&]/g; s/\^/\\^/g')/d" "$BASHRC_FILE"
        info "Removed existing devbox alias from ${BASHRC_FILE}."
    fi
fi

printf '\n%s\n' "$ALIAS_BLOCK" >> "$BASHRC_FILE"
success "✓ devbox alias added to ${BASHRC_FILE}."
# shellcheck source=/dev/null
source "$BASHRC_FILE"
success "✓ Sourced ${BASHRC_FILE}."

echo
success "Setup done!"
