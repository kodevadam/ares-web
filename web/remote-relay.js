#!/usr/bin/env node
/**
 * web/remote-relay.js — Node.js WebSocket relay for ares N64 remote testing
 *
 * Acts as a bridge between automated test scripts (Python, shell, CI runners)
 * and the browser tab running the emulator.
 *
 * Architecture:
 *
 *   Test script ──(TCP/HTTP)──► relay server ──(WebSocket)──► browser tab
 *                                                             (remote-api.js)
 *
 * The relay exposes two interfaces:
 *   1. WebSocket on --ws-port (default 9001) — browser connects here.
 *   2. HTTP POST on --http-port (default 9002) — test scripts send commands here.
 *
 * HTTP API (test script side):
 *
 *   POST /command        Content-Type: application/json
 *   Body: { cmd: "screenshot" }
 *   Response: { ok: true, result: { width, height, data: "base64..." } }
 *
 *   GET /status          → { connected: bool, frame: N, fps: N }
 *
 * The relay multiplexes multiple simultaneous HTTP callers onto the single
 * WebSocket connection to the browser, matching responses by generated ID.
 *
 * Usage:
 *   node remote-relay.js [--ws-port 9001] [--http-port 9002]
 *
 * Dependencies: none (uses Node.js built-in http + ws — install ws with npm).
 *   npm install ws
 */

'use strict';

const http = require('http');
const { WebSocketServer, WebSocket } = require('ws');
const crypto = require('crypto');

// ── Parse CLI args ─────────────────────────────────────────────────────────
let wsPort   = 9001;
let httpPort = 9002;

for (let i = 2; i < process.argv.length; i++) {
  if (process.argv[i] === '--ws-port'   && process.argv[i+1]) { wsPort   = +process.argv[++i]; }
  if (process.argv[i] === '--http-port' && process.argv[i+1]) { httpPort = +process.argv[++i]; }
}

// ── State ──────────────────────────────────────────────────────────────────
let browserWs = null;                // active browser connection
const pending = new Map();           // id → { resolve, reject, timer }
let lastStatus = { connected: false, frame: 0, fps: 0 };

const REQUEST_TIMEOUT_MS = 30_000;

// ── WebSocket server (browser connects here) ───────────────────────────────
const wss = new WebSocketServer({ port: wsPort });

wss.on('connection', (ws, req) => {
  console.log(`[relay] Browser connected from ${req.socket.remoteAddress}`);
  browserWs = ws;
  lastStatus.connected = true;

  ws.on('message', (data) => {
    let msg;
    try { msg = JSON.parse(data); } catch { return; }

    // Route response back to waiting HTTP caller.
    const p = pending.get(msg.id);
    if (p) {
      clearTimeout(p.timer);
      pending.delete(msg.id);
      if (msg.ok) p.resolve(msg.result);
      else        p.reject(new Error(msg.error ?? 'remote error'));
    }

    // Cache status updates.
    if (msg.result?.frame !== undefined) {
      lastStatus.frame = msg.result.frame;
      lastStatus.fps   = msg.result.fps ?? lastStatus.fps;
    }
  });

  ws.on('close', () => {
    console.log('[relay] Browser disconnected');
    browserWs = null;
    lastStatus.connected = false;
    // Reject all pending requests.
    for (const [id, p] of pending) {
      clearTimeout(p.timer);
      p.reject(new Error('Browser disconnected'));
    }
    pending.clear();
  });
});

console.log(`[relay] WebSocket server listening on ws://0.0.0.0:${wsPort}`);
console.log(`[relay]   → Open index.html#remote=ws://localhost:${wsPort} in the browser`);

// ── Send a command to the browser and await the response ──────────────────
function sendCommand(cmd) {
  return new Promise((resolve, reject) => {
    if (!browserWs || browserWs.readyState !== WebSocket.OPEN) {
      return reject(new Error('Browser not connected'));
    }

    const id = crypto.randomUUID();
    const timer = setTimeout(() => {
      pending.delete(id);
      reject(new Error(`Timeout waiting for response to '${cmd.cmd}'`));
    }, REQUEST_TIMEOUT_MS);

    pending.set(id, { resolve, reject, timer });
    browserWs.send(JSON.stringify({ id, ...cmd }));
  });
}

// ── HTTP server (test scripts POST here) ──────────────────────────────────
const httpServer = http.createServer((req, res) => {
  const cors = {
    'Access-Control-Allow-Origin':  '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
  };

  if (req.method === 'OPTIONS') {
    res.writeHead(204, cors); res.end(); return;
  }

  if (req.method === 'GET' && req.url === '/status') {
    res.writeHead(200, { ...cors, 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ ...lastStatus, pendingRequests: pending.size }));
    return;
  }

  if (req.method === 'GET' && req.url === '/health') {
    res.writeHead(200, cors); res.end('ok'); return;
  }

  if (req.method === 'POST' && req.url === '/command') {
    let body = '';
    req.on('data', (chunk) => { body += chunk; });
    req.on('end', async () => {
      let cmd;
      try { cmd = JSON.parse(body); } catch {
        res.writeHead(400, cors); res.end(JSON.stringify({ ok: false, error: 'Invalid JSON' })); return;
      }

      try {
        const result = await sendCommand(cmd);
        res.writeHead(200, { ...cors, 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ ok: true, result }));
      } catch (err) {
        res.writeHead(502, { ...cors, 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ ok: false, error: err.message }));
      }
    });
    return;
  }

  res.writeHead(404, cors); res.end('Not found');
});

httpServer.listen(httpPort, () => {
  console.log(`[relay] HTTP server listening on http://0.0.0.0:${httpPort}`);
  console.log(`[relay]   POST /command  { cmd: "screenshot" } etc.`);
  console.log(`[relay]   GET  /status`);
  console.log('');
  console.log('[relay] Example test:');
  console.log(`  curl -s -X POST http://localhost:${httpPort}/command \\`);
  console.log(`    -H 'Content-Type: application/json' \\`);
  console.log(`    -d '{"cmd":"get_status"}' | jq .`);
});

// ── Graceful shutdown ──────────────────────────────────────────────────────
process.on('SIGINT',  () => { wss.close(); httpServer.close(); process.exit(0); });
process.on('SIGTERM', () => { wss.close(); httpServer.close(); process.exit(0); });
