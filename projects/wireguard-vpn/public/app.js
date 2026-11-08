const byId = (id) => document.getElementById(id);
const login = byId('login');
const dashboard = byId('dashboard');
const lock = byId('lock');
const rows = byId('peer-rows');
const dialog = byId('profile-dialog');
const dateFormat = new Intl.DateTimeFormat(undefined, { dateStyle: 'medium', timeStyle: 'short' });
let token = '';
let profile;
let busy = false;

function message(id, text, error = false) {
  const target = byId(id);
  target.textContent = text;
  target.classList.toggle('error', error);
}

async function api(path, { method = 'GET', payload, accessToken = token } = {}) {
  const headers = { Authorization: `Bearer ${accessToken}` };
  if (payload) headers['Content-Type'] = 'application/json';
  const response = await fetch(path, {
    method, headers, body: payload ? JSON.stringify(payload) : undefined, cache: 'no-store',
    signal: AbortSignal.timeout(12000),
  });
  if (response.status === 204) return;
  const data = await response.json();
  if (!response.ok) {
    const error = new Error(data.error || 'Request failed.');
    error.status = response.status;
    throw error;
  }
  return data;
}

function size(bytes) {
  const value = Number(bytes);
  if (value < 1024) return `${bytes} B`;
  const units = ['KiB', 'MiB', 'GiB', 'TiB'];
  const power = Math.min(Math.floor(Math.log(value) / Math.log(1024)), units.length);
  return `${(value / 1024 ** power).toFixed(1)} ${units[power - 1]}`;
}

function renderPeer(peer) {
  const row = byId('peer-template').content.cloneNode(true);
  const field = (name) => row.querySelector(`[data-${name}]`);
  field('name').textContent = peer.name;
  field('address').textContent = peer.address;
  const handshake = peer.lastHandshakeAt && new Date(peer.lastHandshakeAt);
  const recent = handshake && Date.now() - handshake.getTime() < 180_000;
  field('badge').textContent = handshake ? (recent ? 'Recent' : 'Older') : 'No handshake';
  field('badge').classList.toggle('recent', Boolean(recent));
  if (handshake) {
    field('time').dateTime = peer.lastHandshakeAt;
    field('time').textContent = dateFormat.format(handshake);
  }
  field('received').textContent = `↓ ${size(peer.receivedBytes)} received`;
  field('sent').textContent = `↑ ${size(peer.sentBytes)} sent`;
  const revoke = row.querySelector('button');
  revoke.setAttribute('aria-label', `Revoke ${peer.name}`);
  revoke.disabled = busy;
  revoke.addEventListener('click', () => {
    if (!window.confirm(`Revoke VPN access for ${peer.name}? Its current profile will stop working.`)) return;
    run(async () => {
      await api(`/api/peers/${peer.id}`, { method: 'DELETE' });
      message('dashboard-message', `Revoked ${peer.name}.`);
      renderNetwork(await api('/api/network'));
    });
  });
  return row;
}

function renderNetwork(network) {
  byId('subnet').textContent = network.subnet;
  byId('endpoint').textContent = network.endpoint;
  byId('count').textContent = `${network.peers.length} / ${network.peerCapacity}`;
  byId('test-url').href = network.testUrl;
  byId('empty').hidden = network.peers.length > 0;
  byId('peers').hidden = network.peers.length === 0;
  rows.replaceChildren(...network.peers.map(renderPeer));
}

function lockDashboard(reason = '') {
  token = '';
  if (dialog.open) dialog.close();
  profile = undefined;
  byId('profile-info').textContent = '';
  rows.replaceChildren();
  byId('device-name').value = '';
  message('dashboard-message', '');
  dashboard.hidden = true;
  lock.hidden = true;
  login.hidden = false;
  message('login-message', reason, Boolean(reason));
  byId('token').focus();
}

function setBusy(value) {
  busy = value;
  for (const button of [lock, byId('refresh'), byId('enroll'), ...rows.querySelectorAll('button')]) {
    button.disabled = busy;
  }
}

async function run(action) {
  if (busy) return;
  setBusy(true);
  message('dashboard-message', '');
  try {
    await action();
  } catch (error) {
    if (error.status === 401) lockDashboard('Enter the current admin token.');
    else message('dashboard-message', error.message, true);
  } finally {
    setBusy(false);
  }
}

byId('login-form').addEventListener('submit', async (event) => {
  event.preventDefault();
  const input = byId('token');
  const candidate = input.value.trim();
  byId('unlock').disabled = true;
  message('login-message', '');
  try {
    const network = await api('/api/network', { accessToken: candidate });
    token = candidate;
    input.value = '';
    renderNetwork(network);
    login.hidden = true;
    dashboard.hidden = false;
    lock.hidden = false;
    byId('dashboard-title').focus();
  } catch (error) {
    message('login-message', error.status === 401 ? 'The admin token is incorrect.' : error.message, true);
  } finally {
    byId('unlock').disabled = false;
  }
});

lock.addEventListener('click', () => lockDashboard());
byId('refresh').addEventListener('click', () => run(async () => {
  renderNetwork(await api('/api/network'));
  message('dashboard-message', 'Network status refreshed.');
}));

byId('enroll-form').addEventListener('submit', (event) => {
  event.preventDefault();
  run(async () => {
    const input = byId('device-name');
    const { peer, profile: config } = await api('/api/peers', { method: 'POST', payload: { name: input.value } });
    input.value = '';
    profile = { config, file: `vpn-${peer.id.slice(0, 8)}.conf` };
    byId('profile-info').textContent = `${peer.name} · ${peer.address}`;
    dialog.showModal();
    renderNetwork(await api('/api/network'));
  });
});

byId('download').addEventListener('click', () => {
  if (!profile) return;
  const url = URL.createObjectURL(new Blob([profile.config], { type: 'text/plain' }));
  const link = document.createElement('a');
  link.href = url;
  link.download = profile.file;
  link.click();
  setTimeout(() => URL.revokeObjectURL(url), 30_000);
});
byId('close-profile').addEventListener('click', () => dialog.close());
dialog.addEventListener('close', () => {
  profile = undefined;
  byId('profile-info').textContent = '';
});
