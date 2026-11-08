FROM node:24-bookworm-slim AS gateway
WORKDIR /app
RUN apt-get update \
    && apt-get install -y --no-install-recommends iproute2 nftables wireguard-tools \
    && rm -rf /var/lib/apt/lists/* \
    && install -d -m 0700 /var/lib/vpn \
    && install -d -m 0755 /run/vpn
COPY src/common.mjs src/gateway.mjs src/store.mjs src/wireguard.mjs ./src/
CMD ["node", "src/gateway.mjs"]

FROM node:24-bookworm-slim AS admin
WORKDIR /app
COPY src/common.mjs src/admin.mjs ./src/
COPY public/ ./public/
USER 1000:1000
CMD ["node", "src/admin.mjs"]
