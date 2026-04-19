"""Zero-cache dev server for the Flutter web build.

Why this exists:
 - Python's default http.server caches aggressively via Last-Modified.
 - Flutter's PWA install leaves a flutter_service_worker.js registered in the
   browser that keeps serving the OLD shell forever even after rebuilds.

This server:
 1. Sends Cache-Control: no-store on every response so the browser never
    keeps anything across builds.
 2. Intercepts /flutter_service_worker.js and serves a tiny stub that tells
    any previously-installed SW to unregister itself on next page load.

Usage:
    python3 scripts/serve_nocache.py [port]

Defaults to port 3002, matching what we've been using in dev.
"""
from __future__ import annotations

import http.server
import os
import sys
from pathlib import Path

# Served bundle lives at build/web/ relative to the project root.
PROJECT_ROOT = Path(__file__).resolve().parent.parent
WEB_ROOT = PROJECT_ROOT / "build" / "web"

# When served, this stub intercepts a previously-registered Flutter service
# worker and tells it to self-destruct. After the first fetch the browser
# will never talk to a stale SW again.
SW_UNREGISTER_STUB = b"""// EvairSIM no-cache dev server: service-worker kill switch.
// Any previously-registered flutter_service_worker.js gets replaced by this
// stub which unregisters itself and clears all caches.
self.addEventListener('install', (event) => { self.skipWaiting(); });
self.addEventListener('activate', (event) => {
  event.waitUntil((async () => {
    try {
      const keys = await caches.keys();
      await Promise.all(keys.map((k) => caches.delete(k)));
    } catch (_) {}
    try { await self.registration.unregister(); } catch (_) {}
    const clientsList = await self.clients.matchAll({ type: 'window' });
    for (const client of clientsList) {
      try { client.navigate(client.url); } catch (_) {}
    }
  })());
});
"""


class NoCacheHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self) -> None:  # noqa: D401 — stdlib hook.
        self.send_header("Cache-Control", "no-store, max-age=0")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        super().end_headers()

    def _is_sw_path(self) -> bool:
        return self.path.split("?", 1)[0] == "/flutter_service_worker.js"

    def _send_sw_headers(self) -> None:
        self.send_response(200)
        self.send_header("Content-Type", "application/javascript")
        self.send_header("Service-Worker-Allowed", "/")
        self.send_header("Content-Length", str(len(SW_UNREGISTER_STUB)))
        self.end_headers()

    def do_GET(self) -> None:  # noqa: N802 — stdlib casing.
        if self._is_sw_path():
            self._send_sw_headers()
            self.wfile.write(SW_UNREGISTER_STUB)
            return
        super().do_GET()

    def do_HEAD(self) -> None:  # noqa: N802 — stdlib casing.
        if self._is_sw_path():
            self._send_sw_headers()
            return
        super().do_HEAD()


def main() -> None:
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 3002
    if not WEB_ROOT.exists():
        print(f"Build output not found at {WEB_ROOT}. Run `flutter build web` first.")
        sys.exit(1)
    os.chdir(WEB_ROOT)
    server = http.server.ThreadingHTTPServer(("", port), NoCacheHandler)
    print(f"Serving {WEB_ROOT} on http://localhost:{port} (no-cache + SW kill)")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        server.server_close()


if __name__ == "__main__":
    main()
