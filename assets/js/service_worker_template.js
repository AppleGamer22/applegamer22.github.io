const CACHE_NAME = `{{now.Format "2006-01-02 03:04:05PM"}}`;
const STATIC_FILES = [
	"/android-chrome-192x192.png",
	"/android-chrome-512x512.png",
	"/apple-touch-icon.png",
	"/downunderctf/2022.pdf",
	"/favicon-16x16.png",
	"/favicon-32x32.png",
	"/favicon.ico",
	"/keybase.txt"
];

/**
 * @param {ExtendableEvent} event
 */
function installEvent(event) {
	event.waitUntil(async () => {
		const cache = await caches.open(CACHE_NAME);
		await cache.addAll(STATIC_FILES)
	});
}

/**
 * @param {ExtendableEvent} event
*/
function fetchEvent(event) {
	event.respondWith(caches.match(event.request).then(response => response || fetch(event.request)));
}

/**
 * @param {ExtendableEvent} event
 */
function activateEvent(event) {
	
}

self.addEventListener("install", installEvent);
self.addEventListener("fetch", fetchEvent);
self.addEventListener("activate", event => {
	event.waitUntil(caches.keys().then(keys => Promise.all(keys.map((key) => {
		if (!expectedCaches.includes(key)) {
			return caches.delete(key);
		}
	}))).then(() => {
		console.log(`${CACHE_NAME} now ready to handle fetches!`);
		return clients.claim();
	}));
});