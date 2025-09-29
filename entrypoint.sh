#!/bin/sh
set -e

DATA_DIR=/app/data

# Initialize chain if not already
if [ ! -d "$DATA_DIR/geth" ]; then
  echo "Initializing genesis..."
  geth --datadir $DATA_DIR init /app/genesis.json
fi

echo "Starting GBTNetwork Clique Node on :9636..."
exec geth \
  --datadir $DATA_DIR \
  --networkid 999 \
  --http \
  --http.addr "0.0.0.0" \
  --http.port 9636 \
  --http.api "eth,net,web3,personal,miner" \
  --allow-insecure-unlock \
  --unlock 0x8888888888888888888888888888888888888888 \
  --password /app/password.txt \
  --mine \
  --verbosity 3
