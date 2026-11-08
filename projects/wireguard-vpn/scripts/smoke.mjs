import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { randomBytes } from 'node:crypto';
import { setTimeout as delay } from 'node:timers/promises';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('..', import.meta.url));
const project = `vpn-smoke-${randomBytes(4).toString('hex')}`;
const token = randomBytes(32).toString('hex');
const clients = [`${project}-a`, `${project}-b`];
const env = {
  ...process.env,
  VPN_ENDPOINT: 'gateway:51820',
  VPN_SUBNET: '10.71.0.0/24',
  VPN_ADMIN_TOKEN: token,
};
function docker(args, input) {
  const result = spawnSync('docker', args, { cwd: root, env, input, encoding: 'utf8', timeout: 300_000 });
  if (result.status !== 0) {
    throw new Error(`Docker ${args.slice(0, 2).join(' ')} failed.\n${result.stderr || result.error?.message || ''}`);
  }
  return result.stdout.trim();
}

const compose = (...args) => docker(['compose', '--project-name', project, '--env-file', '/dev/null', ...args]);
const exec = (client, ...args) => docker(['exec', client, ...args]);

async function api(path, expected, method = 'GET', body) {
  const response = await fetch(`http://127.0.0.1:8787${path}`, {
    method,
    headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' },
    body: body && JSON.stringify(body),
    signal: AbortSignal.timeout(10_000),
  });
  assert.equal(response.status, expected, `${method} ${path}`);
  return expected === 204 ? undefined : response.json();
}

const probe = (client, url) => exec(client, 'node', '--input-type=module', '-e', `
  const response = await fetch(process.argv[1], { signal: AbortSignal.timeout(10000) });
  if (!response.ok) process.exit(1);
  console.log(await response.text());
`, url);

function connect(client, profile, file, image) {
  docker([
    'run', '-d', '--name', client, '--network', `${project}_transport`,
    '--cap-drop', 'ALL', '--cap-add', 'NET_ADMIN', '--security-opt', 'no-new-privileges:true',
    image, 'sleep', 'infinity',
  ]);
  const path = `/tmp/${file}`;
  docker(['exec', '-i', client, 'sh', '-c', 'umask 077 && cat > "$1"', 'sh', path], profile);
  exec(client, 'wg-quick', 'up', path);
}

async function waitForGateway() {
  for (let attempt = 0; attempt < 20; attempt += 1) {
    const response = await fetch('http://127.0.0.1:8787/api/network', {
      headers: { Authorization: `Bearer ${token}` },
      signal: AbortSignal.timeout(3000),
    }).catch(() => null);
    await response?.body?.cancel();
    if (response?.ok) return;
    await delay(1000);
  }
  throw new Error('The dashboard could not reach the restarted gateway.');
}

let started = false;
try {
  docker(['compose', 'version']);
  started = true;
  compose('up', '--build', '-d', '--wait', '--wait-timeout', '60');
  const image = compose('images', '-q', 'gateway');
  const { testUrl } = await api('/api/network', 200);
  const first = await api('/api/peers', 201, 'POST', { name: 'Smoke client A' });
  const second = await api('/api/peers', 201, 'POST', { name: 'Smoke client B' });
  connect(clients[0], first.profile, 'vpn-a.conf', image);
  connect(clients[1], second.profile, 'vpn-b.conf', image);
  for (const client of clients) {
    assert.equal(JSON.parse(probe(client, testUrl)).tunnel, 'wireguard');
  }

  docker(['exec', '-d', clients[1], 'node', '-e', `
    require('node:http').createServer((req, res) => res.end('peer B')).listen(9090, process.argv[1]);
  `, second.peer.address]);
  await delay(500);
  assert.equal(probe(clients[0], `http://${second.peer.address}:9090/`), 'peer B');
  const { peers } = await api('/api/network', 200);
  assert.ok(peers.every((peer) => peer.lastHandshakeAt && BigInt(peer.receivedBytes) > 0n));
  console.log('Encrypted traffic reached the gateway and another enrolled peer.');

  compose('restart', 'gateway');
  await waitForGateway();
  exec(clients[0], 'wg-quick', 'down', '/tmp/vpn-a.conf');
  exec(clients[0], 'wg-quick', 'up', '/tmp/vpn-a.conf');
  assert.equal(JSON.parse(probe(clients[0], testUrl)).tunnel, 'wireguard');
  console.log('An existing profile reconnected after the gateway restarted.');

  await api(`/api/peers/${first.peer.id}`, 204, 'DELETE');
  assert.equal(compose('exec', '-T', 'gateway', 'wg', 'show', 'wg0', 'peers'), second.peer.publicKey);
  exec(clients[0], 'node', '--input-type=module', '-e', `
    let blocked = false;
    try {
      await fetch(process.argv[1], { signal: AbortSignal.timeout(3000) });
    } catch {
      blocked = true;
    }
    if (!blocked) process.exit(1);
  `, testUrl);
  exec(clients[1], 'wg-quick', 'down', '/tmp/vpn-b.conf');
  exec(clients[1], 'wg-quick', 'up', '/tmp/vpn-b.conf');
  assert.equal(JSON.parse(probe(clients[1], testUrl)).tunnel, 'wireguard');
  console.log('The revoked profile lost access. The other peer still works.');
} catch (error) {
  console.error(error.message);
  process.exitCode = 1;
  if (started) {
    try { console.error(compose('logs', '--no-color')); } catch { /* Preserve the original failure. */ }
  }
} finally {
  if (started) {
    for (const client of clients) {
      try { docker(['rm', '-f', client]); } catch { /* Client may have failed to start. */ }
    }
    try {
      compose('down', '-v');
    } catch (error) {
      console.error(error.message);
      process.exitCode = 1;
    }
  }
}
