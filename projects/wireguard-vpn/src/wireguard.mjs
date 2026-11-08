import { spawnSync } from 'node:child_process';
import { randomUUID } from 'node:crypto';
import { existsSync, mkdtempSync, readFileSync, renameSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { MTU, PROBE_PORT, WIREGUARD_PORT } from './common.mjs';

const iface = 'wg0';
const firewall = 'vpn_lab';

function run(binary, args, input) {
  const result = spawnSync(binary, args, { input, encoding: 'utf8', timeout: 3000, maxBuffer: 256 * 1024 });
  if (result.status !== 0) {
    // WireGuard can include part of its configuration in diagnostic output.
    const detail = binary === 'ip' || binary === 'nft' ? result.stderr?.trim() : '';
    throw new Error([`${binary} ${args[0]} failed`, detail || result.error?.code].filter(Boolean).join('. '));
  }
  return result.stdout.trim();
}

function publicKey(privateKey) {
  return run('wg', ['pubkey'], `${privateKey}\n`);
}

function readKey(path, hasPeers) {
  if (!existsSync(path)) {
    if (hasPeers) throw new Error('The server key is missing from a state volume with enrolled peers.');
    const temp = `${path}.${randomUUID()}`;
    try {
      writeFileSync(temp, `${run('wg', ['genkey'])}\n`, { mode: 0o600, flag: 'wx', flush: true });
      renameSync(temp, path);
    } finally {
      rmSync(temp, { force: true });
    }
  }
  return readFileSync(path, 'utf8').trim();
}

function installFirewall(network) {
  const tables = run('nft', ['list', 'tables']).split('\n');
  const replace = tables.includes(`table inet ${firewall}`) ? `delete table inet ${firewall}\n` : '';
  run('nft', ['-f', '-'], `${replace}table inet ${firewall} {
    chain input {
      type filter hook input priority filter; policy drop;
      iifname "lo" accept
      ct state established,related accept
      iifname != "${iface}" udp dport ${WIREGUARD_PORT} accept
      iifname "${iface}" ip protocol icmp icmp type echo-request accept
      iifname "${iface}" ip daddr ${network.gateway} tcp dport ${PROBE_PORT} accept
    }
    chain forward {
      type filter hook forward priority filter; policy drop;
      iifname "${iface}" oifname "${iface}" ip saddr ${network.cidr} ip daddr ${network.cidr} accept
    }
  }\n`);
}

export class WireGuard {
  constructor(stateDir, network) {
    this.keyPath = join(stateDir, 'server.key');
    this.network = network;
  }

  start(peers) {
    this.privateKey = readKey(this.keyPath, peers.length > 0);
    this.publicKey = publicKey(this.privateKey);
    const interfaces = JSON.parse(run('ip', ['-j', 'link', 'show']));
    if (interfaces.some((link) => link.ifname === iface)) this.stop();
    run('ip', ['link', 'add', 'dev', iface, 'type', 'wireguard']);
    run('ip', ['-4', 'address', 'add', `${this.network.gateway}/24`, 'dev', iface]);
    run('ip', ['link', 'set', 'dev', iface, 'mtu', String(MTU)]);
    installFirewall(this.network);
    this.sync(peers);
    run('ip', ['link', 'set', 'dev', iface, 'up']);
  }

  stop() {
    run('ip', ['link', 'delete', 'dev', iface]);
  }

  generatePeerKeys() {
    const privateKey = run('wg', ['genkey']);
    return { privateKey, publicKey: publicKey(privateKey) };
  }

  sync(peers) {
    const dir = mkdtempSync(join(tmpdir(), 'vpn-'));
    const path = join(dir, 'wg.conf');
    const sections = [
      `[Interface]\nPrivateKey = ${this.privateKey}\nListenPort = ${WIREGUARD_PORT}`,
      ...peers.map((peer) => `[Peer]\nPublicKey = ${peer.publicKey}\nAllowedIPs = ${peer.address}/32`),
    ];
    try {
      writeFileSync(path, `${sections.join('\n\n')}\n`, { mode: 0o600, flag: 'wx' });
      run('wg', ['syncconf', iface, path]);
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  }

  peerStats() {
    const handshakes = run('wg', ['show', iface, 'latest-handshakes']);
    const transfer = run('wg', ['show', iface, 'transfer']);
    const stats = new Map();
    for (const line of handshakes.split('\n').filter(Boolean)) {
      const [key, seconds] = line.split(/\s+/);
      stats.set(key, { lastHandshakeAt: Number(seconds) ? new Date(Number(seconds) * 1000).toISOString() : null });
    }
    for (const line of transfer.split('\n').filter(Boolean)) {
      const [key, receivedBytes, sentBytes] = line.split(/\s+/);
      stats.set(key, { ...stats.get(key), receivedBytes, sentBytes });
    }
    return stats;
  }
}
