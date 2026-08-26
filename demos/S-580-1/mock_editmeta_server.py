#!/usr/bin/env python3
"""Minimal mock Jira server for S-580-1 demo evidence recording.

Serves just enough of `GET /rest/api/3/issue/{key}/editmeta` for `jr field
options <field> --issue <key>` (M1 mode) to be demonstrated end-to-end
without a real Jira instance. `jr field options` is strictly read-only
(BC-X.14.001 Invariant 2) so no mutation endpoint is served at all.

Two fields are exposed on the fixed issue key DEMO-1:

- `customfield_10084` ("Client Tier") -- an option field with a normal
  entry, a cascading entry with one child, and a fully degenerate entry
  (id=None, value=None) to demonstrate the BC-X.14.003 never-drop /
  degenerate-entry rendering rules (NULL_GLYPH "-"/"(unnamed)" in table
  mode, raw JSON `null` in --output json mode).
- `customfield_20000` ("Internal Notes") -- a free-text field with no
  `allowedValues` at all, to demonstrate the BC-X.14.004 graceful-degrade
  path (exit 0, stderr hint, empty result).
"""
import http.server
import json
import sys

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 18766
ISSUE_KEY = "DEMO-1"

EDITMETA = {
    "fields": {
        "customfield_10084": {
            "name": "Client Tier",
            "schema": {"type": "option", "system": None, "custom": None},
            "allowedValues": [
                {"id": "10001", "value": "Gold", "name": None, "children": []},
                {
                    "id": "10002",
                    "value": "Silver",
                    "name": None,
                    "children": [
                        {
                            "id": "10002-1",
                            "value": "Silver Plus",
                            "name": None,
                            "children": [],
                        }
                    ],
                },
                # Degenerate entry (EC-X.14.001-7): missing id AND label.
                # Must never be dropped -- normalizer emits it as
                # {id: None, label: None, children: []}.
                {"id": None, "value": None, "name": None, "children": []},
            ],
            "operations": ["set"],
            "required": False,
            "autoCompleteUrl": None,
        },
        "customfield_20000": {
            "name": "Internal Notes",
            "schema": {"type": "string", "system": None, "custom": None},
            "allowedValues": None,
            "operations": ["set"],
            "required": False,
            "autoCompleteUrl": None,
        },
    }
}


class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        pass  # keep VHS recording quiet

    def _json(self, obj, status=200):
        body = json.dumps(obj).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        if self.path == f"/rest/api/3/issue/{ISSUE_KEY}/editmeta":
            self._json(EDITMETA)
        else:
            self._json({"errorMessages": [f"mock: no route for {self.path}"]}, status=404)


if __name__ == "__main__":
    server = http.server.HTTPServer(("127.0.0.1", PORT), Handler)
    server.serve_forever()
