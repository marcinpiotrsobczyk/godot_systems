# brotli_gzip_server.py
import http.server
import os
import mimetypes
from functools import partial

# Ensure correct MIME types
mimetypes.add_type('application/wasm', '.wasm')

class BrotliGzipHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        # Handle Brotli (.br)
        if self.path.endswith('.br'):
            self.send_header("Content-Encoding", "br")
            orig_file = self.path[:-3]
            mime, _ = mimetypes.guess_type(orig_file)
            if mime:
                self.send_header("Content-Type", mime)

        # Handle Gzip (.gz)
        elif self.path.endswith('.gz'):
            self.send_header("Content-Encoding", "gzip")
            orig_file = self.path[:-3]
            mime, _ = mimetypes.guess_type(orig_file)
            if mime:
                self.send_header("Content-Type", mime)

        # Always vary by encoding
        self.send_header("Vary", "Accept-Encoding")

        super().end_headers()

if __name__ == "__main__":
    import sys

    port = 8000
    if len(sys.argv) > 1:
        port = int(sys.argv[1])

    handler = partial(BrotliGzipHTTPRequestHandler, directory=os.getcwd())
    print(f"Serving on http://localhost:{port}")
    print("Supports serving .br and .gz files with proper Content-Encoding headers.")
    http.server.ThreadingHTTPServer(("", port), handler).serve_forever()

