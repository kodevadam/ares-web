/**
 * web/sw.js — Service Worker for ares N64 PWA
 *
 * Strategy:
 *   - WASM + JS files: cache-first (large; only updated on new deploy)
 *   - HTML / CSS / JS glue: stale-while-revalidate
 *   - Audio worklet: cache-first
 *   - ROMs: never cached (user-supplied; often hundreds of MB)
 *
 * Install: pre-cache the app shell.
 * Activate: clear old caches.
 * Fetch: serve from cache, fall back to network.
 *
 * Cross-Origin Isolation headers required for SharedArrayBuffer:
 *   Cross-Origin-Opener-Policy: same-origin
 *   Cross-Origin-Embedder-Policy: require-corp
 * These are injected on every navigate response below.
 */

'use strict';

const CACHE_VERSION = 'ares-v2';

// Files to pre-cache on install.
const PRECACHE_URLS = [
  './',
  './index.html',
  './bridge.js',
  './emu-worker.js',
  './audio-worklet.js',
  './touch-controls.js',
  './styles.css',
  './ares-web.js',
  './ares-web.wasm',
];

// ---------------------------------------------------------------------------
// Install — pre-cache app shell
// ---------------------------------------------------------------------------
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_VERSION).then((cache) => {
      // Add what we can; if the WASM isn't built yet, skip gracefully.
      return cache.addAll(PRECACHE_URLS).catch((err) => {
        console.warn('[sw] Pre-cache partial failure (expected before first build):', err);
      });
    }).then(() => self.skipWaiting())
  );
});

// ---------------------------------------------------------------------------
// Activate — prune old caches
// ---------------------------------------------------------------------------
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys.filter((k) => k !== CACHE_VERSION).map((k) => caches.delete(k))
      )
    ).then(() => self.clients.claim())
  );
});

// ---------------------------------------------------------------------------
// Fetch — serve from cache + inject COOP/COEP headers on navigation
// ---------------------------------------------------------------------------
self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);

  // Never cache ROM files or external resources.
  if (url.pathname.match(/\.(z64|n64|v64|rom)$/i)) return;
  if (url.origin !== self.location.origin) return;

  event.respondWith(handleFetch(event.request));
});

async function handleFetch(request) {
  const url = new URL(request.url);
  const isNavigation = request.mode === 'navigate';
  const isWasm = url.pathname.endsWith('.wasm');
  const isJsOrWasm = url.pathname.match(/\.(js|wasm)$/);

  // Cache-first for WASM and heavy JS bundles.
  if (isWasm || isJsOrWasm) {
    const cached = await caches.match(request);
    if (cached) return addCOIHeaders(cached, isNavigation);
    try {
      const response = await fetch(request);
      if (response.ok) {
        const cache = await caches.open(CACHE_VERSION);
        cache.put(request, response.clone());
      }
      return addCOIHeaders(response, isNavigation);
    } catch (e) {
      return cached ?? new Response('Offline', { status: 503 });
    }
  }

  // Stale-while-revalidate for HTML/CSS/JS glue.
  const cached = await caches.match(request);
  const networkFetch = fetch(request).then((response) => {
    if (response.ok) {
      // Clone synchronously before any async work; addCOIHeaders below may
      // consume response.body, which would make a deferred clone() throw.
      const clone = response.clone();
      caches.open(CACHE_VERSION).then((c) => c.put(request, clone));
    }
    return addCOIHeaders(response, isNavigation);
  }).catch(() => null);

  return cached ? addCOIHeaders(cached, isNavigation) : (await networkFetch ?? new Response('Offline', { status: 503 }));
}

/**
 * Inject Cross-Origin-Opener-Policy and Cross-Origin-Embedder-Policy headers
 * so that SharedArrayBuffer (and thus AudioWorklet+WASM threads) is available.
 */
function addCOIHeaders(response, always = false) {
  // Only modify HTML documents (navigation requests) or when forced.
  if (!always && !response.headers.get('content-type')?.includes('text/html')) {
    return response;
  }
  const headers = new Headers(response.headers);
  headers.set('Cross-Origin-Opener-Policy', 'same-origin');
  headers.set('Cross-Origin-Embedder-Policy', 'require-corp');
  return new Response(response.body, {
    status:     response.status,
    statusText: response.statusText,
    headers,
  });
}
