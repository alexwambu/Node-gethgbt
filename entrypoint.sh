#!/bin/bash
set -e

echo "🚀 Starting Geth Node..."

DATADIR=/app/datadir

if [ ! -d "$DATADIR/geth" ]; then
    echo "⏳ Initializing Geth datadir..."
    mkdir -p $DATADIR
    geth --datadir $DATADIR init /app/genesis.json
fi

echo "✅ Launching Geth node..."
geth \
  --datadir $DATADIR \
  --networkid 999 \
  --http \
  --http.addr 0.0.0.0 \
  --http.port 9636 \
  --http.api eth,net,web3,personal,miner \
  --http.corsdomain="*" \
  --port 30303 \
  --nodiscover \
  --allow-insecure-unlock
