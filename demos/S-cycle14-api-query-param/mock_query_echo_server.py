#!/usr/bin/env python3
"""Minimal mock Jira server for S-cycle14-api-query-param demo evidence
recording (`jr api --query-param`/`-q`, issue #583).

Serves ANY path/method jr's `jr api` passthrough command might hit and
echoes back exactly what it received — the raw request line's path and
RAW (still percent-encoded) query string, the parsed query as a
multi-value dict (so repeated `-q NAME=...` occurrences are visibly
distinct), the HTTP method, and the request body (if any) — as pretty
JSON. This lets a viewer of the recording see the EXACT bytes `jr`
assembled and sent on the wire, without needing to inspect `jr`'s
internals or a packet capture.

No real Jira org, account IDs, instance URL, or credentials are used
anywhere below — this server never validates or reads the `Authorization`
header at all.

Every request received is also appended as one line to a log file (path
given as argv[2]) so a recording can prove a pre-flight error (exit 64
from `parse_query_param`, BEFORE any HTTP call) never reached this
server: `wc -l` on that log file stays 0 across a malformed-`-q` demo.
"""
import http.server
import json
import sys
import urllib.parse

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8792
LOG_PATH = sys.argv[2] if len(sys.argv) > 2 else "/tmp/jr-demo-mock-requests.log"


class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        pass  # keep VHS recording quiet; no request logging to stdout/stderr

    def _log_request(self, method):
        with open(LOG_PATH, "a") as f:
            f.write(f"{method} {self.path}\n")

    def _echo(self, method):
        self._log_request(method)

        parsed = urllib.parse.urlsplit(self.path)
        content_length = int(self.headers.get("Content-Length", 0) or 0)
        raw_body = self.rfile.read(content_length) if content_length else b""

        payload = {
            "method": method,
            "path": parsed.path,
            # Raw, still percent-encoded query string exactly as received
            # on the wire — the primary evidence field for this story.
            "query_raw": parsed.query,
            # Parsed multi-value form, decoded, for readability — proves
            # repeated same-name params all arrive, in order.
            "query_parsed": urllib.parse.parse_qsl(parsed.query, keep_blank_values=True),
            "fragment_received_by_server": parsed.fragment,  # should always be "" (RFC 9112 §3.2)
        }
        if raw_body:
            try:
                payload["body"] = json.loads(raw_body.decode("utf-8"))
            except (ValueError, UnicodeDecodeError):
                payload["body"] = raw_body.decode("utf-8", errors="replace")

        body = json.dumps(payload, indent=2).encode() + b"\n"
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        self._echo("GET")

    def do_POST(self):
        self._echo("POST")

    def do_PUT(self):
        self._echo("PUT")

    def do_PATCH(self):
        self._echo("PATCH")

    def do_DELETE(self):
        self._echo("DELETE")


if __name__ == "__main__":
    server = http.server.HTTPServer(("127.0.0.1", PORT), Handler)
    server.serve_forever()
