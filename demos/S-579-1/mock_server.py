#!/usr/bin/env python3
"""Tiny local mock Jira HTTP server for S-579-1 demo recording.

Serves a fixed, fake, empty search result (no real Jira keys/org/URLs) for
POST /rest/api/3/search/jql -- the only endpoint `jr issue list` needs to
demonstrate the `--updated-recent` clause composition. Reached only via the
debug-only JR_BASE_URL/JR_AUTH_HEADER test seam documented in CLAUDE.md
"AI Agent Notes" (inert in release builds).

The point of these recordings is the OUTGOING JQL (visible via
`--verbose --verbose-bodies` on stderr as `[verbose] body: {"jql": "..."}`),
not the returned issue data, so the search response is intentionally empty.
"""
import json
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse

PORT = 8935

SEARCH_RESPONSE = {"issues": [], "nextPageToken": None}

# Minimal fake project summary so `jr issue list --project DEMO` passes its
# pre-search project-existence check. "DEMO" is a synthetic project key --
# not a real Jira project.
PROJECT_DEMO = {
    "key": "DEMO",
    "name": "Demo Project",
    "projectTypeKey": "software",
    "lead": {"displayName": "Alex Rivera", "accountId": "demo-acc-1"},
}


class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        pass  # keep VHS recording output clean

    def _send_json(self, obj, status=200):
        body = json.dumps(obj).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_POST(self):
        path = urlparse(self.path).path
        if path == "/rest/api/3/search/jql":
            self._send_json(SEARCH_RESPONSE)
            return
        self._send_json({"errorMessages": ["Not found (demo mock)"]}, status=404)

    def do_GET(self):
        path = urlparse(self.path).path
        if path == "/rest/api/3/project/DEMO":
            self._send_json(PROJECT_DEMO)
            return
        self._send_json({"errorMessages": ["Not found (demo mock)"]}, status=404)


if __name__ == "__main__":
    server = HTTPServer(("127.0.0.1", PORT), Handler)
    print(f"mock jira server listening on http://127.0.0.1:{PORT}")
    server.serve_forever()
