#!/bin/bash
set -ex

export HOME=/config

# Run build script to ensure latest version via PPA
/build.sh

# Launch bitcoin-qt from symlinked location in persistent config
exec /config/bitcoin/bin/bitcoin-qt -datadir=/config/.bitcoin
