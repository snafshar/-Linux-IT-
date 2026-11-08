import { timingSafeEqual } from 'node:crypto';
import { readFileSync } from 'node:fs';
import { request } from 'node:http';
import { pathToFileURL } from 'node:url';
import {
  ADMIN_PORT, apiRoute, CONTROL_SOCKET, httpServer, HttpError, readBytes, readJson, sendJson,
} from './common.mjs';

const assets = new Map([
  ['/', ['index.html', 'text/html; charset=utf-8']],
  ['/app.js', ['app.js', 'text/javascript; charset=utf-8']],
  ['/styles.css', ['styles.css', 'text/css; charset=utf-8']],
]);

function gatewayRequest(transport, method, path, payload) {
  return new Promise((resolve, reject) => {
    const body = payload === undefined ? undefined : JSON.stringify(payload);
    const req = request({
      ...transport, method, path, agent: false,
      headers: body && { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(body) },
    }, async (res) => {
      try {
        const data = await readBytes(res, 256 * 1024);
        resolve({ status: res.statusCode, value: data.length ? JSON.parse(data.toString('utf8')) : undefined });
      } catch (error) {
        res.destroy();
        reject(error);
      }
    });
    req.once('error', reject);
    req.setTimeout(8000, () => req.destroy(new Error('Gateway request timed out.')));
    req.end(body);
  });
}

export function createAdminServer({ token, transport = { socketPath: CONTROL_SOCKET } }) {
  if (!/^[a-f0-9]{64}$/.test(token ?? '')) {
    throw new Error('VPN_ADMIN_TOKEN must be 64 lowercase hexadecimal characters.');
  }
  const expected = Buffer.from(`Bearer ${token}`);
  const staticFiles = new Map([...assets].map(([route, [file, type]]) => [
    route, { type, data: readFileSync(new URL(`../public/${file}`, import.meta.url)) },
  ]));
  return httpServer(async (req, res) => {
    res.setHeader('Cache-Control', 'no-store');
    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader('Referrer-Policy', 'no-referrer');
    res.setHeader('Content-Security-Policy', "default-src 'none'; script-src 'self'; style-src 'self'; connect-src 'self'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'");
    if (!/^(localhost|127\.0\.0\.1)(:\d{1,5})?$/i.test(req.headers.host ?? '')) {
      throw new HttpError(421, 'Use the local dashboard address.');
    }

    const file = req.method === 'GET' && staticFiles.get(req.url);
    if (file) {
      res.setHeader('Content-Type', file.type);
      res.end(file.data);
      return;
    }

    const provided = Buffer.from(req.headers.authorization ?? '');
    if (provided.length !== expected.length || !timingSafeEqual(provided, expected)) {
      res.setHeader('WWW-Authenticate', 'Bearer');
      throw new HttpError(401, 'An admin token is required.');
    }
    const { action } = apiRoute(req.method, req.url);
    const payload = action === 'enroll' ? await readJson(req) : undefined;

    let response;
    try {
      response = await gatewayRequest(transport, req.method, req.url, payload);
    } catch {
      throw new HttpError(503, 'The gateway is unavailable. Refresh before retrying a change.');
    }
    sendJson(res, response.status, response.value);
  });
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    const server = createAdminServer({ token: process.env.VPN_ADMIN_TOKEN });
    server.listen(ADMIN_PORT, '0.0.0.0', () => console.log(`VPN dashboard listening on port ${ADMIN_PORT}.`));
  } catch (error) {
    console.error('Dashboard startup failed:', error.message);
    process.exitCode = 1;
  }
}
