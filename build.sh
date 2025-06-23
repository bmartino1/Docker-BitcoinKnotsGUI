#!/bin/bash
set -e

export HOME=/config
BTC_DIR="/config/bitcoin"
BTC_BIN="${BTC_DIR}/bin"
BTC_VERSION_FILE="${BTC_DIR}/.btc_version"

mkdir -p "$BTC_BIN"
mkdir -p "$(dirname "$BTC_VERSION_FILE")"

echo "[build.sh] Ensuring Bitcoin Knots is installed via PPA..."

# Optionally upgrade to latest available version on each boot
apt-get update -qq
apt-get install --only-upgrade -y bitcoinknots-qt

# Symlink system-installed binaries into /config/bin (if needed)
QT_BIN=$(command -v bitcoin-qt)
DAEMON_BIN=$(command -v bitcoind)

if [[ -x "$QT_BIN" && -x "$DAEMON_BIN" ]]; then
    ln -sf "$QT_BIN" "$BTC_BIN/bitcoin-qt"
    ln -sf "$DAEMON_BIN" "$BTC_BIN/bitcoind"
else
    echo "[build.sh] ERROR: bitcoin-qt or bitcoind not found in PATH!"
    exit 1
fi

# Record installed version
VERSION=$("$QT_BIN" --version | head -n1 | awk '{print $3}')
echo "$VERSION" > "$BTC_VERSION_FILE"

echo "[build.sh] Bitcoin Knots version $VERSION ready."
