#!/bin/bash

log_info "Started Starship setup..."
log_output ""

################################################################################
# Set permissions for starship configuration

log_status "Started setting permissions for Starship configuration..."

mkdir -p /etc/devbox/dotfiles/starship/
set_group_permissions /etc/devbox/dotfiles/starship/

log_status "Completed."
log_output ""

################################################################################
# Export starship execution command in bashrc

log_status "Started setting up Starship prompt in bashrc..."

if ! grep -q "eval \"\$(starship init bash)\"" /etc/bash.bashrc; then
    echo "eval \"\$(starship init bash)\"" >> /etc/bash.bashrc
    log_info "Created alias 'eval \"\$(starship init bash)\"' for Starship prompt"
fi

log_status "Completed."
log_output ""

################################################################################
# Set starship configuration file path in bashrc

log_status "Started setting Starship configuration file path in bashrc..."

if ! grep -q "export STARSHIP_CONFIG=/etc/devbox/dotfiles/starship/starship.toml" /etc/bash.bashrc; then
    echo "export STARSHIP_CONFIG=/etc/devbox/dotfiles/starship/starship.toml" >> /etc/bash.bashrc
    log_info "Created alias 'export STARSHIP_CONFIG=/etc/devbox/dotfiles/starship/starship.toml' for Starship prompt"
fi

log_status "Completed."
log_output ""

################################################################################
# Set some environment variables for starship prompt

log_status "Started setting environment variables for Starship prompt..."

if ! grep -q "export TERM=xterm-256color" /etc/bash.bashrc; then
    echo "export TERM=xterm-256color" >> /etc/bash.bashrc
    log_info "Created alias 'export TERM=xterm-256color' for Starship prompt on 'tmux'"
fi

if ! grep -q "export LC_COLLATE=C" /etc/bash.bashrc; then
    echo "export LC_COLLATE=C" >> /etc/bash.bashrc
    log_info "Created alias 'export LC_COLLATE=C' for Starship prompt on 'tmux'"
fi

log_status "Completed."
log_output ""

################################################################################
log_info "All Starship setup completed successfully!"
log_output ""
