#!/bin/bash
set -e

export HOME=/config
BTC_DIR="/config/bitcoin"
BTC_BIN="${BTC_DIR}/bin"
BTC_VERSION_FILE="${BTC_DIR}/.btc_version"
BASE_URL="https://bitcoinknots.org/files"

mkdir -p "$BTC_BIN"
mkdir -p "$(dirname "$BTC_VERSION_FILE")"
mkdir -p /tmp/knots-download

echo "[build.sh] Finding latest Bitcoin Knots release from $BASE_URL..."

# Get the latest release directory (e.g. 28.x/28.1.knots20250305/)
LATEST_SUBDIR=$(curl -s "$BASE_URL/28.x/" | \
    grep -Eo 'href="28\.[0-9]+\.knots[0-9]+/' | \
    sed 's/href="//;s|/||' | sort -V | tail -1)

if [[ -z "$LATEST_SUBDIR" ]]; then
    echo "[build.sh] Failed to find latest version directory."
    exit 1
fi

LATEST_VERSION=$(basename "$LATEST_SUBDIR")
echo "[build.sh] Latest version: $LATEST_VERSION"

CURRENT_VERSION=""
[ -f "$BTC_VERSION_FILE" ] && CURRENT_VERSION=$(cat "$BTC_VERSION_FILE")

if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
    echo "[build.sh] Already running the latest version: $CURRENT_VERSION"
    exit 0
fi

echo "[build.sh] New version detected: $LATEST_VERSION, downloading..."

cd /tmp/knots-download

FILE="bitcoin-${LATEST_VERSION}-x86_64-linux-gnu.tar.gz"
URL="${BASE_URL}/28.x/${LATEST_VERSION}/${FILE}"

curl -LO "$URL"
tar -xf "$FILE"

cp -a "bitcoin-${LATEST_VERSION}/bin/"* "$BTC_BIN/"
chmod +x "$BTC_BIN/"*

echo "$LATEST_VERSION" > "$BTC_VERSION_FILE"

echo "[build.sh] Bitcoin Knots $LATEST_VERSION installed successfully."
