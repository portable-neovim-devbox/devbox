#!/bin/bash

set -e

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
# Initialization starts here...

log_output "========================================"
log_info "Started initialization script."
log_output ""

################################################################################
# Install basic development tools

log_status "Installing basic development tools..."

if ! apt-get update \
|| ! apt-get install -y \
    build-essential \
    curl \
    fontconfig \
    htop \
    jq \
    less \
    locales \
    nano \
    tree \
    unzip \
    vim \
    wget \
    xclip \
    zip \
|| ! apt-get autoremove -y \
|| ! rm -rf /var/lib/apt/lists/*; then
    log_error "Failed to install basic development tools"
    exit 1
fi

log_status "Completed."
log_output ""

################################################################################
# Backup and configure /bash.bashrc

log_status "Started to create backup of /etc/bash.bashrc..."

cp /etc/bash.bashrc /etc/bash.bashrc.backup_$(date +%Y%m%d_%H%M%S)

log_status "Completed."
log_output ""

################################################################################
# Install additional tools

log_output "========================================"
log_info "Started sub initialization scripts..."
log_output ""

# Loop through all subdirectories in lexicographical order
for dir in $(find "$SCRIPT_DIR" -mindepth 1 -maxdepth 1 -type d | sort); do
    if [ -f "$dir/init.sh" ]; then
        dir_name=$(basename "$dir")

        log_output "=============================="
        log_info "Executing $dir_name/init.sh..."
        log_output ""

        cd "$dir"

        # Source the init.sh script
        if source ./init.sh; then
            log_info "Completed $dir_name/init.sh"
            log_output ""
        else
            log_error "Failed to execute $dir_name/init.sh"
            log_output ""
        fi

        log_info "End of $dir_name/init.sh..."
        log_output "=============================="
        log_output ""

        cd "$SCRIPT_DIR"
    fi
done

log_info "All sub initialization scripts completed."
log_output "========================================"
log_output ""

################################################################################

log_output "========================================"
log_info "Completed initialization script."
log_output "========================================"
