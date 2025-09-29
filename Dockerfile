FROM golang:1.21 as builder

# Install dependencies
RUN apt-get update && apt-get install -y wget tar curl jq

# Pin Geth version
ENV GETH_VERSION=1.13.14

RUN set -ex \
    && API_URL="https://api.github.com/repos/ethereum/go-ethereum/releases/tags/v${GETH_VERSION}" \
    && DOWNLOAD_URL=$(curl -sSL $API_URL | jq -r '.assets[] | select(.name | test("linux-amd64.*tar.gz$")) | .browser_download_url' | head -n1) \
    && echo "Downloading Geth from: $DOWNLOAD_URL" \
    && wget -q $DOWNLOAD_URL -O geth.tar.gz \
    && tar -xzf geth.tar.gz \
    && mv geth-linux-amd64-${GETH_VERSION}-*/geth /usr/local/bin/geth \
    && rm -rf geth.tar.gz geth-linux-amd64-${GETH_VERSION}-*

WORKDIR /app
COPY entrypoint.sh /app/entrypoint.sh
COPY genesis.json /app/genesis.json
COPY static-nodes.json /app/static-nodes.json

RUN chmod +x /app/entrypoint.sh

EXPOSE 9636 30303

ENTRYPOINT ["/app/entrypoint.sh"]
