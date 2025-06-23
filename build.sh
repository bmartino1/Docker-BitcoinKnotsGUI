#!/bin/bash
set -e

export HOME=/config
BTC_DIR="/config/bitcoin"
BTC_BIN="${BTC_DIR}/bin"
BTC_VERSION_FILE="${BTC_DIR}/.btc_version"
DOWNLOAD_BASE="https://github.com/bitcoinknots/bitcoin/releases"

mkdir -p "$BTC_BIN"
mkdir -p "$(dirname "$BTC_VERSION_FILE")"
mkdir -p /tmp/knots-download

echo "[build.sh] Checking for latest Bitcoin Knots release..."

# Use GitHub API to get latest tag
LATEST_VERSION=$(curl -s https://api.github.com/repos/bitcoinknots/bitcoin/releases/latest | \
    jq -r .tag_name)

if [[ "$LATEST_VERSION" == "null" || -z "$LATEST_VERSION" ]]; then
    echo "[build.sh] Failed to retrieve latest release tag from GitHub."
    exit 1
fi

echo "[build.sh] Latest release tag: $LATEST_VERSION"

CURRENT_VERSION=""
[ -f "$BTC_VERSION_FILE" ] && CURRENT_VERSION=$(cat "$BTC_VERSION_FILE")

if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
    echo "[build.sh] Already running the latest version: $CURRENT_VERSION"
    exit 0
fi

echo "[build.sh] New version detected: $LATEST_VERSION, updating..."

cd /tmp/knots-download
FILE="bitcoin-${LATEST_VERSION}-x86_64-linux-gnu.tar.gz"
URL="${DOWNLOAD_BASE}/download/${LATEST_VERSION}/${FILE}"

# Download and extract
curl -LO "$URL"
tar -xf "$FILE"

# Copy binaries
cp -a "bitcoin-${LATEST_VERSION}/bin/"* "$BTC_BIN/"
chmod +x "$BTC_BIN/"*

# Record version
echo "$LATEST_VERSION" > "$BTC_VERSION_FILE"

echo "[build.sh] Bitcoin Knots $LATEST_VERSION installed successfully."
