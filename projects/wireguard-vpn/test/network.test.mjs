import assert from 'node:assert/strict';
import { randomBytes } from 'node:crypto';
import { once } from 'node:events';
import { mkdtempSync, readFileSync, rmSync } from 'node:fs';
import { request } from 'node:http';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { test } from 'node:test';
import { createAdminServer } from '../src/admin.mjs';
import { parseEndpoint, parseNetwork } from '../src/common.mjs';
import { createGatewayServer } from '../src/gateway.mjs';
import { PeerStore } from '../src/store.mjs';

const network = parseNetwork('10.71.0.0/24');
const endpoint = 'vpn.example.test:51820';
const key = () => randomBytes(32).toString('base64');

async function start(t) {
  const dir = mkdtempSync(join(tmpdir(), 'vpn-test-'));
  const path = join(dir, 'peers.sqlite');
  const socketPath = join(dir, 'control.sock');
  const token = randomBytes(32).toString('hex');
  const store = new PeerStore(path, network);
  const wireguard = {
    peers: [],
    publicKey: key(),
    generatePeerKeys: () => ({ publicKey: key(), privateKey: key() }),
    peerStats: () => new Map(),
    sync(peers) { this.peers = peers; },
  };
  const gateway = createGatewayServer({
    store, wireguard, endpoint, network,
    failClosed: () => assert.fail('Gateway could not restore the saved peer state'),
  });
  // Restricted test sandboxes can use a loopback transport instead of a Unix socket.
  const useTcp = process.env.VPN_TEST_TCP === '1';
  await once(useTcp ? gateway.listen(0, '127.0.0.1') : gateway.listen(socketPath), 'listening');
  const transport = useTcp ? { host: '127.0.0.1', port: gateway.address().port } : { socketPath };
  const admin = createAdminServer({ token, transport });
  t.after(async () => {
    await Promise.all([gateway, admin].map((server) => new Promise((resolve) => server.close(resolve))));
    store.close();
    rmSync(dir, { recursive: true, force: true });
  });
  await once(admin.listen(0, '127.0.0.1'), 'listening');
  const base = `http://127.0.0.1:${admin.address().port}`;
  const headers = { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' };
  const api = (url = '/api/network', options) => fetch(base + url, { headers, ...options });
  const enroll = (name) => api('/api/peers', { method: 'POST', body: JSON.stringify({ name }) });
  return { api, enroll, base, path, store, wireguard };
}

test('validates endpoint and split tunnel address pool', () => {
  assert.equal(parseEndpoint('192.168.1.50:51820'), '192.168.1.50:51820');
  assert.equal(parseEndpoint('vpn.example.net:1'), 'vpn.example.net:1');
  for (const value of ['0.0.0.0:51820', 'vpn.example.net:65536', 'vpn.example.net\n:51820',
    'vpn.example.net:51820\n', 'a#b:51820', '192.168.1.256:51820', 'vpn.example.net']) {
    assert.throws(() => parseEndpoint(value), /VPN_ENDPOINT/);
  }
  for (const value of ['203.0.113.0/24', '10.71.0.1/24', '10.71.0.0/16', '10.71.0.0/24/24']) {
    assert.throws(() => parseNetwork(value), /VPN_SUBNET/);
  }
  assert.equal(network.gateway, '10.71.0.1');
  assert.equal(network.addresses.length, 253);
  assert.equal(network.addresses.at(-1), '10.71.0.254');
});

test('serves the dashboard locally and gates API requests', async (t) => {
  const { api, base } = await start(t);
  const html = await fetch(base);
  assert.equal(html.status, 200);
  assert.match(html.headers.get('content-security-policy'), /frame-ancestors 'none'/);
  assert.match(await html.text(), /WireGuard Lab/);
  assert.equal((await fetch(base + '/app.js')).status, 200);

  const remote = await new Promise((resolve, reject) => {
    const req = request(base, { headers: { Host: 'rebind.example.test' } }, (res) => {
      res.resume();
      resolve(res.statusCode);
    });
    req.on('error', reject);
    req.end();
  });
  assert.equal(remote, 421);

  const denied = await fetch(base + '/api/network');
  assert.equal(denied.status, 401);
  assert.equal(denied.headers.get('www-authenticate'), 'Bearer');
  assert.equal((await fetch(base + '/api/network', { headers: { Authorization: 'Bearer wrong' } })).status, 401);
  assert.equal((await api()).status, 200);
});

test('enrolls, lists, and revokes peers without saving client private keys', async (t) => {
  const { api, enroll, path, wireguard } = await start(t);
  const result = await enroll('MacBook');
  assert.equal(result.status, 201);
  assert.equal(result.headers.get('cache-control'), 'no-store');
  const { peer, profile } = await result.json();
  const clientKey = profile.match(/^PrivateKey = (.+)$/m)[1];
  assert.match(profile, /\[Interface\]\nPrivateKey = /);
  assert.match(profile, /Address = 10\.71\.0\.2\/32/);
  assert.match(profile, /AllowedIPs = 10\.71\.0\.0\/24/);
  assert.match(profile, /Endpoint = vpn\.example\.test:51820/);
  assert.ok(profile.includes(`PublicKey = ${wireguard.publicKey}`));
  assert.equal(wireguard.peers.length, 1);
  assert.equal(readFileSync(path).includes(clientKey), false);

  const listed = await (await api()).json();
  assert.equal(listed.peers[0].lastHandshakeAt, null);
  assert.equal(listed.peers[0].receivedBytes, '0');
  assert.equal(listed.testUrl, 'http://10.71.0.1:8080/');
  assert.ok(!JSON.stringify(listed).includes(clientKey));
  assert.equal((await enroll('macbook')).status, 409);
  assert.equal((await enroll('[Peer]')).status, 400);

  const revoke = () => api(`/api/peers/${peer.id}`, { method: 'DELETE' });
  assert.equal((await revoke()).status, 204);
  assert.equal((await revoke()).status, 404);
  assert.deepEqual(wireguard.peers, []);
  const replacement = (await (await enroll('iPhone')).json()).peer;
  assert.equal(replacement.address, peer.address);
  assert.notEqual(replacement.publicKey, peer.publicKey);
});

test('serializes concurrent enrollments and rejects malformed requests', async (t) => {
  const { api, enroll, base } = await start(t);
  const responses = await Promise.all([enroll('Phone'), enroll('Tablet'), enroll('phone')]);
  assert.deepEqual(responses.map((response) => response.status).sort(), [201, 201, 409]);
  const snapshot = await (await api()).json();
  assert.equal(new Set(snapshot.peers.map((peer) => peer.address)).size, 2);
  assert.equal((await api('/api/peers', { method: 'POST', body: '{' })).status, 400);
  assert.equal((await enroll('a'.repeat(2200))).status, 413);

  const unauthenticated = await fetch(base + '/api/peers', {
    method: 'POST', body: 'name=test', headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
  });
  assert.equal(unauthenticated.status, 401);
  assert.equal((await (await api()).json()).peers.length, 2);
});

test('restores durable and live peers after a partially applied failure', () => {
  const dir = mkdtempSync(join(tmpdir(), 'vpn-store-'));
  const path = join(dir, 'peers.sqlite');
  const store = new PeerStore(path, network);
  try {
    let live = [];
    const failClosed = () => assert.fail('Rollback should have restored the live peer set');
    const peer = store.change(() => store.enroll('existing', key()), (peers) => { live = peers; }, failClosed);
    let first = true;
    assert.throws(() => store.change(() => store.revoke(peer.id), (peers) => {
      live = peers;
      if (first) {
        first = false;
        throw new Error('simulated kernel failure');
      }
    }, failClosed), /simulated kernel failure/);
    assert.equal(live[0].id, peer.id);
    const reopened = new PeerStore(path, network);
    try {
      assert.equal(reopened.list()[0].id, peer.id);
      assert.throws(() => new PeerStore(path, parseNetwork('10.72.0.0/24')), /saved network/);
    } finally {
      reopened.close();
    }
  } finally {
    store.close();
    rmSync(dir, { recursive: true, force: true });
  }
});
