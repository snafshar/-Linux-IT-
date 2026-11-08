import { randomUUID } from 'node:crypto';
import { DatabaseSync } from 'node:sqlite';
import { HttpError } from './common.mjs';

export function peerName(body) {
  const name = typeof body?.name === 'string' ? body.name.trim() : '';
  if (!/^[A-Za-z0-9][A-Za-z0-9 _.-]{0,47}$/.test(name)) {
    throw new HttpError(400, 'Use 1–48 letters, numbers, spaces, dots, hyphens or underscores. Start with a letter or number.');
  }
  return name;
}

export class PeerStore {
  constructor(path, network) {
    this.addresses = network.addresses;
    this.db = new DatabaseSync(path);
    try {
      this.db.exec(`
        CREATE TABLE IF NOT EXISTS settings (
          key TEXT PRIMARY KEY,
          value TEXT NOT NULL
        ) STRICT;
        CREATE TABLE IF NOT EXISTS peers (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL UNIQUE COLLATE NOCASE,
          address TEXT NOT NULL UNIQUE,
          publicKey TEXT NOT NULL UNIQUE,
          createdAt TEXT NOT NULL
        ) STRICT;
      `);
      this.db.prepare('INSERT OR IGNORE INTO settings VALUES (?, ?)').run('subnet', network.cidr);
      const saved = this.db.prepare('SELECT value FROM settings WHERE key = ?').get('subnet').value;
      if (saved !== network.cidr) throw new Error(`VPN_SUBNET must match the saved network (${saved}).`);
    } catch (error) {
      this.db.close();
      throw error;
    }
  }

  list() {
    return this.db.prepare('SELECT * FROM peers ORDER BY createdAt DESC, id').all();
  }

  enroll(name, publicKey) {
    if (this.db.prepare('SELECT 1 FROM peers WHERE name = ?').get(name)) {
      throw new HttpError(409, 'A peer already uses that name.');
    }
    const inUse = new Set(this.db.prepare('SELECT address FROM peers').all().map((peer) => peer.address));
    const address = this.addresses.find((candidate) => !inUse.has(candidate));
    if (!address) throw new HttpError(409, 'The VPN subnet has no free peer addresses.');
    const peer = { id: randomUUID(), name, address, publicKey, createdAt: new Date().toISOString() };
    this.db.prepare('INSERT INTO peers VALUES (?, ?, ?, ?, ?)').run(
      peer.id, peer.name, peer.address, peer.publicKey, peer.createdAt,
    );
    return peer;
  }

  revoke(id) {
    if (!this.db.prepare('DELETE FROM peers WHERE id = ?').run(id).changes) {
      throw new HttpError(404, 'Peer not found.');
    }
  }

  change(operation, sync, failClosed) {
    this.db.exec('BEGIN IMMEDIATE');
    let touchedKernel = false;
    try {
      const result = operation();
      touchedKernel = true;
      sync(this.list());
      this.db.exec('COMMIT');
      return result;
    } catch (error) {
      try {
        this.db.exec('ROLLBACK');
        if (touchedKernel) sync(this.list());
      } catch {
        failClosed();
      }
      throw error;
    }
  }

  close() {
    this.db.close();
  }
}
