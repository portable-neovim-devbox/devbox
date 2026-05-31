#!/bin/bash
# Test: cleanup path removes existing devbox containers, volumes, and images

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
MOCK_DIR=$(mktemp -d)
CALL_LOG=$(mktemp)

trap 'rm -rf "$MOCK_DIR" "$CALL_LOG"' EXIT

cat > "$MOCK_DIR/docker" << MOCK
#!/bin/bash
echo "\$*" >> "$CALL_LOG"
case "\$1" in
    "ps")     echo "fake-cid" ;;
    "images") echo "fake-iid" ;;
    "volume")
        [ "\$2" = "ls" ] && echo "devbox_fake-vol"
        exit 0 ;;
    *)        exit 0 ;;
esac
MOCK
chmod +x "$MOCK_DIR/docker"

# build=y, dotfiles=n (generate defaults)
printf "stable\nuser\n\n\n\ny\nn\n" \
    | PATH="$MOCK_DIR:$PATH" bash "${REPO_ROOT}/setup.sh"

grep -q "container stop fake-cid"    "$CALL_LOG" || { echo "FAIL [test_cleanup_with_devbox] container stop not called with fake-cid"; exit 1; }
grep -q "container rm fake-cid"      "$CALL_LOG" || { echo "FAIL [test_cleanup_with_devbox] container rm not called with fake-cid"; exit 1; }
grep -q "volume rm devbox_fake-vol"  "$CALL_LOG" || { echo "FAIL [test_cleanup_with_devbox] volume rm not called"; exit 1; }
grep -q "image rm fake-iid"          "$CALL_LOG" || { echo "FAIL [test_cleanup_with_devbox] image rm not called"; exit 1; }

echo "PASS test_cleanup_with_devbox"
