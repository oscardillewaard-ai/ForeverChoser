// Service worker: bewaart de app offline. Verhoog VERSION bij elke release
// zodat telefoons de nieuwe bestanden ophalen.
const VERSION = 'v2';
const CACHE = `foreverchoser-${VERSION}`;
const ASSETS = [
  './',
  'index.html',
  'manifest.webmanifest',
  'css/style.css',
  'js/app.js',
  'js/data.js',
  'js/games-data.js',
  'js/scoring.js',
  'js/store.js',
  'js/ui.js',
  'js/views/home.js',
  'js/views/quiz.js',
  'js/views/duel.js',
  'js/views/trial.js',
  'js/views/race.js',
  'js/views/wheel.js',
  'js/views/names.js',
  'js/views/guide.js',
  'js/views/results.js',
  'icons/icon.svg',
  'icons/icon-192.png',
  'icons/icon-512.png',
  'icons/maskable-512.png',
  'icons/apple-touch-icon.png',
];

self.addEventListener('install', (event) => {
  // cache: 'reload' haalt verse bestanden op, niet de kopie uit de HTTP-cache van de browser.
  event.waitUntil(
    caches
      .open(CACHE)
      .then((cache) => cache.addAll(ASSETS.map((url) => new Request(url, { cache: 'reload' }))))
      .then(() => self.skipWaiting()),
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches
      .keys()
      .then((keys) => Promise.all(keys.filter((k) => k.startsWith('foreverchoser-') && k !== CACHE).map((k) => caches.delete(k))))
      .then(() => self.clients.claim()),
  );
});

// Eerst de cache (snel en offline), op de achtergrond verversen.
self.addEventListener('fetch', (event) => {
  const { request } = event;
  if (request.method !== 'GET' || new URL(request.url).origin !== self.location.origin) return;
  event.respondWith(
    caches.open(CACHE).then(async (cache) => {
      const cached = await cache.match(request, { ignoreSearch: true });
      // no-cache: altijd bij de server navragen of er een nieuwere versie is.
      const network = fetch(request, { cache: 'no-cache' })
        .then((res) => {
          if (res.ok) {
            // Opslaan zonder query (?fbclid=…), zodat de lookup met ignoreSearch altijd dezelfde entry vindt.
            const key = new URL(request.url);
            key.search = '';
            cache.put(key.href, res.clone());
          }
          return res;
        })
        .catch(() => null);
      if (cached) {
        event.waitUntil(network);
        return cached;
      }
      const res = await network;
      if (res) return res;
      if (request.mode === 'navigate') return cache.match('index.html');
      return Response.error();
    }),
  );
});
