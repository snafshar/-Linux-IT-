import { createServer } from 'node:http';
import { isIP } from 'node:net';

export const CONTROL_SOCKET = '/run/vpn/control.sock';
export const ADMIN_PORT = 8787;
export const WIREGUARD_PORT = 51820;
export const PROBE_PORT = 8080;
export const MTU = 1380;
export const DEFAULT_SUBNET = '10.71.0.0/24';
export const MAX_REQUEST_BYTES = 2048;

const peerPath = /^\/api\/peers\/([0-9a-f]{8}(?:-[0-9a-f]{4}){3}-[0-9a-f]{12})$/;
const dnsLabel = /^[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?$/i;

export class HttpError extends Error {
  constructor(status, message) {
    super(message);
    this.status = status;
  }
}

export function parseEndpoint(value) {
  const [host, port, ...rest] = (value ?? '').split(':');
  const validHost = isIP(host) === 4
    || (host.length <= 253 && /[a-z]/i.test(host) && host.split('.').every((label) => dnsLabel.test(label)));
  if (!validHost || host === '0.0.0.0' || rest.length || !/^[1-9]\d{0,4}$/.test(port ?? '') || Number(port) > 65535) {
    throw new Error('VPN_ENDPOINT must be an IPv4 address or DNS name followed by a UDP port.');
  }
  return value;
}

export function parseNetwork(cidr) {
  const [address, prefix, ...rest] = cidr.split('/');
  if (isIP(address) !== 4 || prefix !== '24' || rest.length) {
    throw new Error('VPN_SUBNET must be a private IPv4 /24 network, for example 10.71.0.0/24.');
  }

  const [first, second, third, host] = address.split('.').map(Number);
  const privateAddress = first === 10 || (first === 172 && second >= 16 && second <= 31)
    || (first === 192 && second === 168);
  if (!privateAddress || host !== 0) {
    throw new Error('VPN_SUBNET must be a private IPv4 /24 network with a .0 network address.');
  }
  const base = [first, second, third].join('.');
  return { cidr, gateway: `${base}.1`, addresses: Array.from({ length: 253 }, (_, i) => `${base}.${i + 2}`) };
}

export function apiRoute(method, url) {
  if (method === 'GET' && url === '/api/network') return { action: 'network' };
  if (method === 'POST' && url === '/api/peers') return { action: 'enroll' };
  const match = method === 'DELETE' && peerPath.exec(url);
  if (match) return { action: 'revoke', id: match[1] };
  throw new HttpError(404, 'Route not found.');
}

export async function readBytes(stream, limit) {
  const chunks = [];
  let size = 0;
  for await (const chunk of stream.iterator({ destroyOnReturn: false })) {
    size += chunk.length;
    if (size > limit) throw new HttpError(413, 'Message is too large.');
    chunks.push(chunk);
  }
  return Buffer.concat(chunks, size);
}

export async function readJson(req) {
  if (req.headers['content-type']?.split(';', 1)[0].trim().toLowerCase() !== 'application/json') {
    throw new HttpError(415, 'Use application/json for the request body.');
  }
  const body = await readBytes(req, MAX_REQUEST_BYTES);
  try {
    return JSON.parse(body.toString('utf8'));
  } catch {
    throw new HttpError(400, 'The request body is invalid JSON.');
  }
}

export function sendJson(res, status, value) {
  res.statusCode = status;
  res.setHeader('Cache-Control', 'no-store');
  if (status === 204) {
    res.end();
    return;
  }
  res.setHeader('Content-Type', 'application/json; charset=utf-8');
  res.end(JSON.stringify(value));
}

export function httpServer(handler) {
  return createServer({
    headersTimeout: 5000,
    requestTimeout: 8000,
    connectionsCheckingInterval: 1000,
    maxHeaderSize: 8192,
  }, async (req, res) => {
    try {
      await handler(req, res);
    } catch (error) {
      if (res.headersSent) {
        res.destroy();
        return;
      }
      const status = error instanceof HttpError ? error.status : 500;
      if (status === 500) console.error('Request failed:', error.message);
      if (!req.complete) res.setHeader('Connection', 'close');
      sendJson(res, status, { error: status === 500 ? 'Internal server error.' : error.message });
    }
  });
}
