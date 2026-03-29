#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
cd $SCRIPT_DIR

################################################################################
# Log functions

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_output() {
    echo -e "${NC}$1"
}

log_status() {
    echo -e "${NC}[STATUS]${NC} $1"
}

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

################################################################################
# Functions definitions

# Add a path to $PATH if not already present
add_path_of() {
    if ! grep -q "$1" /etc/bash.bashrc; then
        if grep -q "^export PATH=" /etc/bash.bashrc; then
            sed -i "s/^export PATH=.*$/export PATH=$PATH:$1/g" /etc/bash.bashrc
        else
            echo "export PATH=$PATH:$1" >> /etc/bash.bashrc
        fi
        log_info "Added '$1' to PATH in /etc/bash.bashrc"
    fi
}

# Add an alias to /etc/bash.bashrc if not already present
add_alias() {
    if ! grep -q "alias $1=" /etc/bash.bashrc; then
        echo "alias $1='$2'" >> /etc/bash.bashrc
        log_info "Added alias '$1' to /etc/bash.bashrc"
    fi
}

# Set group ownership and permissions for a target directory and its contents
set_group_permissions() {
    local target_dir="$1"
    chown -R :"${GROUP_NAME}" "${target_dir}" \
        && chmod -R g+X "${target_dir}" \
        && chmod -R g+rw "${target_dir}"
}

# Set symlink with error handling
set_symlink() {
    local target="$1"
    local link_path="$2"
    if ! ln -sf "$target" "$link_path"; then
        log_error "Failed to create symlink from $link_path to $target"
        exit 1
    fi
}

################################################################################
# Entrypoint script starts here...

log_output "========================================"
log_info "Started entrypoint script."
log_output ""

################################################################################
# User settings

log_output "========================================"
log_info "Started user setup..."
log_output ""

if [ -n "$USER_ID" ]; then
    usermod -u "$USER_ID" "$USER_NAME"
    log_info "Set UID for user $USER_NAME to $USER_ID"
fi
if [ -n "$GROUP_ID" ]; then
    groupmod -g "$GROUP_ID" "$GROUP_NAME"
    log_info "Set GID for group $GROUP_NAME to $GROUP_ID"
fi

log_info "Completed user setup for user: ${USER_NAME} (UID: ${USER_ID}, GID: ${GROUP_ID})"
log_output ""

################################################################################
# Backup and symlink /etc/bash.bashrc

log_status "Started backing up and symlinking /etc/bash.bashrc..."

set_group_permissions /etc/devbox/dotfiles/

if [ ! -f /etc/devbox/dotfiles/bash.bashrc ]; then
    if [ ! -e /etc/bash.bashrc ]; then
        ls -t /etc/bash.bashrc.backup*.bak | head -n 1 | xargs -I{} cp {} /etc/devbox/dotfiles/bash.bashrc
    elif [ -f /etc/bash.bashrc ]; then
        cp /etc/bash.bashrc /etc/bash.bashrc.backup_$(date +%Y%m%d_%H%M%S)
        mv /etc/bash.bashrc /etc/devbox/dotfiles/bash.bashrc
    elif [ -L /etc/bash.bashrc ]; then
        rm /etc/bash.bashrc
        ls -t /etc/bash.bashrc.backup*.bak | head -n 1 | xargs -I{} cp {} /etc/devbox/dotfiles/bash.bashrc
    fi
elif [ -f /etc/bash.bashrc ]; then
    cp /etc/bash.bashrc /etc/bash.bashrc.backup_$(date +%Y%m%d_%H%M%S)
fi

set_symlink /etc/devbox/dotfiles/bash.bashrc /etc/bash.bashrc
set_symlink /etc/devbox/dotfiles/bash.bashrc /root/.bashrc
set_symlink /etc/devbox/dotfiles/bash.bashrc /home/$USER_NAME/.bashrc

log_status "Completed."
log_output ""

################################################################################
# Add environment variables to /etc/bash.bashrc

log_status "Started adding environment variables to /etc/bash.bashrc..."

if ! grep -q "export LANG=" /etc/bash.bashrc; then
    echo "export LANG=${LANG:-en_US.UTF-8}" >> /etc/bash.bashrc
    log_info "Added 'export LANG=${LANG:-en_US.UTF-8}' to /etc/bash.bashrc"
fi

log_status "Completed."
log_output ""

################################################################################
# Loop through all subdirectories in lexicographical order

log_output "========================================"
log_info "Started executing subentry scripts in subdirectories..."
log_output ""

for dir in $(find "$SCRIPT_DIR" -mindepth 1 -maxdepth 1 -type d | sort); do
    if [ -f "$dir/subentry.sh" ]; then
        dir_name=$(basename "$dir")

        log_output "=============================="
        log_info "Started executing $dir_name/subentry.sh..."
        log_output ""

        cd "$dir"

        # Source the subentry.sh script
        if source ./subentry.sh; then
            log_info "Completed $dir_name/subentry.sh"
            log_output ""
        else
            log_error "Failed to execute $dir_name/subentry.sh"
            log_output ""
        fi

        log_info "End of $dir_name/subentry.sh..."
        log_output "=============================="
        log_output ""

        cd "$SCRIPT_DIR"
    fi
done

log_info "All subentry scripts completed."
log_output "========================================"
log_output ""

################################################################################
# Add basic aliases

log_status "Started adding aliases to /etc/bash.bashrc..."

# ls aliases
add_alias ll 'ls -alF'
add_alias la 'ls -A'
add_alias l 'ls -CF'

# cd aliases
add_alias .. 'cd ..'
add_alias ... 'cd ../..'

# git aliases
add_alias gs 'git status'
add_alias gp 'git pull'
add_alias gc 'git commit'

log_status "Completed."
log_output ""

################################################################################
# Set ownership for home directory

log_status "Started setting ownership for /home/${USER_NAME}/..."

chown "${USER_NAME}" /home/${USER_NAME}/
find /home/${USER_NAME}/ -maxdepth 1 -mindepth 1 ! -name "project" \
    -exec chown -R "${USER_NAME}" {} \;

log_status "Completed."
log_output ""

################################################################################

log_output "========================================"
log_info "Completed entrypoint script."
log_output "========================================"

################################################################################
# Final execution

cd /home/$USER_NAME/project/
exec gosu $USER_NAME "$@"
