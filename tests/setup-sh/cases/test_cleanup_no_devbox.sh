#!/bin/bash
# Test: cleanup path succeeds cleanly when no devbox resources exist

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
MOCK_DIR=$(mktemp -d)

trap 'rm -rf "$MOCK_DIR"' EXIT

cat > "$MOCK_DIR/docker" << 'MOCK'
#!/bin/bash
case "$1" in
    "ps"|"images") echo "" ;;
    "volume")
        [ "$2" = "ls" ] && echo ""
        exit 0 ;;
    *) exit 0 ;;
esac
MOCK
chmod +x "$MOCK_DIR/docker"

# build=y, dotfiles=n (generate defaults)
printf "stable\nuser\n\n\n\ny\nn\n" \
    | PATH="$MOCK_DIR:$PATH" bash "${REPO_ROOT}/setup.sh"

echo "PASS test_cleanup_no_devbox"
