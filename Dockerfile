# ---- Stage 1: Build geth ----
FROM golang:1.21 AS builder

# install build deps
RUN apt-get update && apt-get install -y make gcc g++ git

# clone specific version (avoid latest breakage)
ARG GETH_VERSION=v1.13.14
RUN git clone --branch $GETH_VERSION --depth 1 https://github.com/ethereum/go-ethereum.git /go-ethereum

WORKDIR /go-ethereum

# pre-download go modules so go.mod error won't happen
RUN go mod download

# build only geth binary
RUN make geth

# ---- Stage 2: Runtime ----
FROM debian:stable-slim

RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# copy geth binary
COPY --from=builder /go-ethereum/build/bin/geth /usr/local/bin/geth

# copy configs
WORKDIR /app
COPY genesis.json /app/genesis.json
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 9636 30303 30303/udp

ENTRYPOINT ["/app/entrypoint.sh"]
