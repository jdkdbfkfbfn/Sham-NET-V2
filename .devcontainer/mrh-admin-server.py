#!/usr/bin/env python3
import base64, hmac, os, sys
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer

ADMIN_DIRECTORY = "/opt/mrh-admin"
DEFAULT_ADMIN_USERNAME = "admin"
DEFAULT_ADMIN_PASSWORD = "Sample@Sample"

class AdminAuthHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=ADMIN_DIRECTORY, **kwargs)
    def _is_authorized(self):
        auth = self.headers.get("Authorization", "")
        if not auth.startswith("Basic "): return False
        token = auth[6:].strip()
        user = os.getenv("MRH_ADMIN_USERNAME", DEFAULT_ADMIN_USERNAME)
        pw = os.getenv("MRH_ADMIN_PASSWORD", DEFAULT_ADMIN_PASSWORD)
        correct = base64.b64encode(f"{user}:{pw}".encode()).decode()
        return hmac.compare_digest(token, correct)
    def do_GET(self):
        if not self._is_authorized():
            self.send_response(401)
            self.send_header("WWW-Authenticate", 'Basic realm="Admin"')
            self.end_headers()
            return
        super().do_GET()

if __name__ == "__main__":
    port = int(os.getenv("MRH_ADMIN_PORT", 8080))
    print(f"Admin server on {port}")
    ThreadingHTTPServer(("0.0.0.0", port), AdminAuthHandler).serve_forever()
