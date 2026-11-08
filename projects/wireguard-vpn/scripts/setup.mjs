import { randomBytes } from 'node:crypto';
import { writeFileSync } from 'node:fs';
import { DEFAULT_SUBNET, parseEndpoint, WIREGUARD_PORT } from '../src/common.mjs';

const target = new URL('../.env', import.meta.url);
const host = process.argv[2];

try {
  if (process.argv.length !== 3) throw new Error('Usage: npm run setup -- <server-hostname-or-ip>[:public-udp-port]');
  const endpoint = parseEndpoint(host.includes(':') ? host : `${host}:${WIREGUARD_PORT}`);
  const env = [
    `VPN_ENDPOINT=${endpoint}`,
    `VPN_SUBNET=${DEFAULT_SUBNET}`,
    `VPN_ADMIN_TOKEN=${randomBytes(32).toString('hex')}`,
    '',
  ].join('\n');
  writeFileSync(target, env, { flag: 'wx', mode: 0o600 });
  console.log(`Created .env for ${endpoint}. Start the VPN with docker compose up -d --build --wait.`);
} catch (error) {
  console.error(error.code === 'EEXIST' ? '.env already exists. Edit it to update your settings.' : error.message);
  process.exitCode = 1;
}
