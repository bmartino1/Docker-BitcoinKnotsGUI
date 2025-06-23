#!/bin/bash
set -e

export HOME=/config
BTC_DIR="/config/bitcoin"
BTC_BIN="${BTC_DIR}/bin"
BTC_VERSION_FILE="${BTC_DIR}/.btc_version"
BASE_URL="https://bitcoinknots.org/files"
TMP_DIR="/tmp/knots-download"

mkdir -p "$BTC_BIN"
mkdir -p "$(dirname "$BTC_VERSION_FILE")"
mkdir -p "$TMP_DIR"

echo "[build.sh] Finding latest Bitcoin Knots release from $BASE_URL..."

# Get latest subdir from 28.x (could be made dynamic)
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

cd "$TMP_DIR"
FILE="bitcoin-${LATEST_VERSION}-x86_64-linux-gnu.tar.gz"
URL="${BASE_URL}/28.x/${LATEST_VERSION}/${FILE}"

# Download and extract
if ! curl -LO "$URL"; then
    echo "[build.sh] ERROR: Failed to download $URL"
    exit 1
fi

if ! tar -xf "$FILE"; then
    echo "[build.sh] ERROR: Failed to extract $FILE"
    exit 1
fi

EXTRACTED_DIR="bitcoin-${LATEST_VERSION}"

# Copy binaries one by one and allow permission issues to be non-fatal
echo "[build.sh] Installing binaries to $BTC_BIN..."
for bin in "$EXTRACTED_DIR/bin/"*; do
    basebin=$(basename "$bin")
    dest="$BTC_BIN/$basebin"
    if cp "$bin" "$dest" 2>/dev/null; then
        chmod +x "$dest" 2>/dev/null || echo "[build.sh] WARNING: Cannot chmod $dest"
        echo "[build.sh] Installed $basebin"
    else
        echo "[build.sh] WARNING: Failed to copy $basebin (permissions?)"
    fi
done

# Write the version file if at least one binary succeeded
if [[ -x "$BTC_BIN/bitcoin-qt" || -x "$BTC_BIN/bitcoind" ]]; then
    echo "$LATEST_VERSION" > "$BTC_VERSION_FILE" 2>/dev/null || \
        echo "[build.sh] WARNING: Cannot write version file"
    echo "[build.sh] Bitcoin Knots $LATEST_VERSION installed successfully."
else
    echo "[build.sh] ERROR: No binaries were installed. Check permissions or user privileges."
    exit 1
fi
