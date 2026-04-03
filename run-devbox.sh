#!/bin/bash

_input="${1:-$(pwd)}"
PATH_ARG="$(realpath "${_input/#\~/$HOME}")"

VOLUMES=(
    "devbox_devbox-data"
    "devbox_nvim-plugin-cache"
    "devbox_root-dotssh"
    "devbox_root-nvim-plugin"
    "devbox_user-dotssh"
    "devbox_user-nvim-plugin"
)

check_volumes() {
    local existing
    existing=$(docker volume ls -q)
    for vol in "${VOLUMES[@]}"; do
        if ! echo "$existing" | grep -qx "$vol"; then
            return 1
        fi
    done
    return 0
}

if ! check_volumes; then
    echo "Required docker volumes doesn't exist. Creating..."
    docker compose create devbox-storage
fi

if ! check_volumes; then
    echo "Error: Failed to create Docker volumes." >&2
    exit 1
fi

USER_NAME=$(docker run --rm \
    --entrypoint bash \
    --volumes-from devbox-storage-master \
    devbox:latest \
    -c "ls /home | head -1")
USER_NAME=$(echo "$USER_NAME" | tr -d '[:space:]')

if [ -z "$USER_NAME" ]; then
    USER_NAME="user"
fi

docker run --rm -it \
    -e LANG \
    -e USER_ID="$(id -u)" \
    --volumes-from devbox-storage-master \
    -v "${PATH_ARG}:/home/${USER_NAME}/project" \
    devbox:latest
