#!/usr/bin/env python3
"""Minimal mock Jira server for S-578-4 demo recording.

Serves just enough of the platform createmeta + create-issue endpoints to
demonstrate `jr issue create --field` resolving via createmeta (AC-002/005/011/013),
driven by env-configurable scenario JSON files. NOT a general-purpose Jira mock.
"""
import http.server
import json
import os
import re
import sys
import urllib.parse

PROJECT = os.environ.get("MOCK_PROJECT", "DEMO")
ISSUE_TYPE_ID = "10001"
ISSUE_TYPE_NAME = "Task"
CREATED_KEY = os.environ.get("MOCK_CREATED_KEY", "DEMO-42")

# Fields served by the createmeta issuetypes/{id} endpoint. Overridable via
# MOCK_FIELDS_JSON env var (a JSON array of createmeta field descriptors).
DEFAULT_FIELDS = [
    {
        "fieldId": "customfield_10050",
        "name": "Vendor Reference",
        "schema": {"type": "string"},
        "allowedValues": None,
    }
]
FIELDS = json.loads(os.environ.get("MOCK_FIELDS_JSON", json.dumps(DEFAULT_FIELDS)))

# /rest/api/3/field global field list (used for cache-first NAME resolution).
LIST_FIELDS = json.loads(os.environ.get("MOCK_LIST_FIELDS_JSON", "[]"))


class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        pass  # keep VHS output clean

    def _json(self, code, obj):
        body = json.dumps(obj).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        parsed = urllib.parse.urlparse(self.path)
        p = parsed.path
        if p == f"/rest/api/3/issue/createmeta/{PROJECT}/issuetypes":
            self._json(200, {
                "issueTypes": [{"id": ISSUE_TYPE_ID, "name": ISSUE_TYPE_NAME}],
                "startAt": 0, "maxResults": 200, "total": 1,
            })
            return
        if p == f"/rest/api/3/issue/createmeta/{PROJECT}/issuetypes/{ISSUE_TYPE_ID}":
            self._json(200, {
                "fields": FIELDS,
                "startAt": 0, "maxResults": 200, "total": len(FIELDS),
            })
            return
        if p == "/rest/api/3/field":
            self._json(200, LIST_FIELDS)
            return
        self._json(404, {"errorMessages": [f"mock: no GET route for {p}"]})

    def do_POST(self):
        if self.path.startswith("/rest/api/3/issue"):
            length = int(self.headers.get("Content-Length", 0))
            self.rfile.read(length)
            self._json(201, {
                "id": "10001",
                "key": CREATED_KEY,
                "self": f"http://127.0.0.1:0/rest/api/3/issue/10001",
            })
            return
        self._json(404, {"errorMessages": [f"mock: no POST route for {self.path}"]})


if __name__ == "__main__":
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8765
    server = http.server.HTTPServer(("127.0.0.1", port), Handler)
    server.serve_forever()
