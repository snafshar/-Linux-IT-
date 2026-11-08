import { once } from 'node:events';
import { chmodSync, mkdirSync, rmSync } from 'node:fs';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';
import {
  apiRoute, CONTROL_SOCKET, DEFAULT_SUBNET, httpServer, HttpError, MTU,
  parseEndpoint, parseNetwork, PROBE_PORT, readJson, sendJson,
} from './common.mjs';
import { peerName, PeerStore } from './store.mjs';
import { WireGuard } from './wireguard.mjs';

const stateDir = '/var/lib/vpn';

function clientProfile(peer, privateKey, serverKey, endpoint, subnet) {
  return [
    '[Interface]',
    `PrivateKey = ${privateKey}`,
    `Address = ${peer.address}/32`,
    `MTU = ${MTU}`,
    '',
    '[Peer]',
    `PublicKey = ${serverKey}`,
    `Endpoint = ${endpoint}`,
    `AllowedIPs = ${subnet}`,
    'PersistentKeepalive = 25',
    '',
  ].join('\n');
}

export function createGatewayServer({ store, wireguard, endpoint, network, failClosed }) {
  const testUrl = `http://${network.gateway}:${PROBE_PORT}/`;
  const sync = (peers) => wireguard.sync(peers);

  return httpServer(async (req, res) => {
    const route = apiRoute(req.method, req.url);
    if (route.action === 'network') {
      const stats = wireguard.peerStats();
      const peers = store.list().map((peer) => ({
        ...peer,
        lastHandshakeAt: null,
        receivedBytes: '0',
        sentBytes: '0',
        ...stats.get(peer.publicKey),
      }));
      sendJson(res, 200, {
        subnet: network.cidr,
        gateway: network.gateway,
        endpoint,
        testUrl,
        peerCapacity: network.addresses.length,
        peers,
      });
    } else if (route.action === 'enroll') {
      const name = peerName(await readJson(req));
      const keys = wireguard.generatePeerKeys();
      const peer = store.change(() => store.enroll(name, keys.publicKey), sync, failClosed);
      const profile = clientProfile(peer, keys.privateKey, wireguard.publicKey, endpoint, network.cidr);
      sendJson(res, 201, { peer, profile });
    } else {
      store.change(() => store.revoke(route.id), sync, failClosed);
      sendJson(res, 204);
    }
  });
}

async function start() {
  process.umask(0o077);
  const endpoint = parseEndpoint(process.env.VPN_ENDPOINT);
  const network = parseNetwork(process.env.VPN_SUBNET || DEFAULT_SUBNET);
  mkdirSync(stateDir, { recursive: true, mode: 0o700 });
  chmodSync(stateDir, 0o700);
  const store = new PeerStore(join(stateDir, 'peers.sqlite'), network);
  const wireguard = new WireGuard(stateDir, network);
  wireguard.start(store.list());

  const probe = httpServer((req, res) => {
    if (req.method !== 'GET' || req.url !== '/') throw new HttpError(404, 'Route not found.');
    sendJson(res, 200, { tunnel: 'wireguard', gateway: network.gateway });
  });
  probe.listen(PROBE_PORT, network.gateway);
  await once(probe, 'listening');

  const shutdown = (code) => {
    try {
      wireguard.stop();
    } catch (error) {
      console.error('Gateway interface cleanup:', error.message);
    }
    process.exit(code);
  };
  const gateway = createGatewayServer({
    store, wireguard, endpoint, network,
    failClosed() {
      console.error('Peer recovery failed. Restarting the tunnel from saved state.');
      shutdown(1);
    },
  });
  rmSync(CONTROL_SOCKET, { force: true });
  gateway.listen(CONTROL_SOCKET);
  await once(gateway, 'listening');
  chmodSync(CONTROL_SOCKET, 0o660);
  process.once('SIGTERM', () => shutdown(0));
  process.once('SIGINT', () => shutdown(0));
  console.log(`WireGuard gateway ready at ${network.gateway} for ${network.cidr}.`);
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  start().catch((error) => {
    console.error('Gateway startup failed:', error.message);
    process.exit(1);
  });
}
