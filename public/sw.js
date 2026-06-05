/* CycleBed service worker — conservative, content-safe caching.
   Strategy:
   - HTML navigations: network-first (always try fresh content, fall back to
     cache only when offline). This keeps pages and ads up to date.
   - Same-origin static assets (css, icons, manifest): stale-while-revalidate.
   - Never touches cross-origin requests (e.g. AdSense), so ads are unaffected.
*/
const VERSION = 'cyclebed-v1';
const STATIC_CACHE = VERSION + '-static';
const PAGE_CACHE = VERSION + '-pages';

const PRECACHE = [
  '/',
  '/style.css',
  '/cyclebed.js',
  '/icon-192.png',
  '/icon-512.png',
  '/offline.html'
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(STATIC_CACHE).then((cache) => cache.addAll(PRECACHE)).then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => !k.startsWith(VERSION)).map((k) => caches.delete(k)))
    ).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  const req = event.request;
  if (req.method !== 'GET') return;

  const url = new URL(req.url);
  // Only handle our own origin; leave AdSense and other third parties alone.
  if (url.origin !== self.location.origin) return;

  // HTML navigations: network-first.
  if (req.mode === 'navigate' || (req.headers.get('accept') || '').includes('text/html')) {
    event.respondWith(
      fetch(req)
        .then((res) => {
          const copy = res.clone();
          caches.open(PAGE_CACHE).then((c) => c.put(req, copy));
          return res;
        })
        .catch(() => caches.match(req).then((hit) => hit || caches.match('/offline.html')))
    );
    return;
  }

  // Static assets: stale-while-revalidate.
  event.respondWith(
    caches.match(req).then((cached) => {
      const network = fetch(req)
        .then((res) => {
          const copy = res.clone();
          caches.open(STATIC_CACHE).then((c) => c.put(req, copy));
          return res;
        })
        .catch(() => cached);
      return cached || network;
    })
  );
});
