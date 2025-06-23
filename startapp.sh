#!/bin/bash
set -ex

export HOME=/config

# Ensure app user owns config
chown -R app:users /config || true
chmod -R u+rwX /config || true

# Run update
sudo /build.sh

# Start Bitcoin Knots GUI
exec /config/bitcoin/bin/bitcoin-qt -datadir=/config/.bitcoin
