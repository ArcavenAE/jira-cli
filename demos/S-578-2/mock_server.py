#!/usr/bin/env python3
"""Standalone canned-response mock server used ONLY for VHS demo recording
of S-578-2 (`jr issue edit --field NAME:kind=VALUE` hint-kind dispatch).

This is recording infrastructure, not product code or a test file — it is
never imported by `cargo test` and lives entirely under
docs/demo-evidence/S-578-2/. It mirrors the shapes asserted by the real
wiremock-based integration tests in tests/issue_field_hint_kinds.rs (see
that file for the authoritative wire contracts) so the recorded terminal
sessions show real, spec-accurate request/response behavior rather than
invented output.

Usage: python3 mock_server.py <scenario> <port>

Uses only the Python 3 standard library (http.server) — no extra deps.
"""
import http.server
import json
import sys
import threading

FIELD_BLOCKER = {
    "name": "Blocker",
    "schema": {"type": "option", "system": None, "custom": None},
    "operations": ["set"],
    "required": False,
    "allowedValues": [],
}

FIELD_URGENCY = {
    "name": "Urgency",
    "schema": {"type": "option", "system": None, "custom": None},
    "operations": ["set"],
    "required": False,
    "allowedValues": [
        {"id": "10286", "value": "High"},
        {"id": "10287", "value": "Medium"},
    ],
}

FIELD_CASCADE = {
    "name": "Cascade Field",
    "schema": {"type": "option-with-child", "system": None, "custom": None},
    "operations": ["set"],
    "required": False,
    "allowedValues": [
        {
            "id": "1",
            "value": "Parent",
            "children": [{"id": "2", "value": "Child"}],
        }
    ],
}

FIELD_PLAIN_OPTION_NO_CHILDREN = {
    "name": "Severity",
    "schema": {"type": "option", "system": None, "custom": None},
    "operations": ["set"],
    "required": False,
    "allowedValues": [{"id": "5", "value": "A"}],
}

FIELD_MULTISELECT_ARRAY = {
    "name": "Multi Select",
    "schema": {"type": "array", "system": None, "custom": None},
    "operations": ["set"],
    "required": False,
    "allowedValues": [{"id": "1", "value": "High"}],
}

FIELD_PLAIN_TEXT = {
    "name": "Plain Text Field",
    "schema": {"type": "string", "system": None, "custom": None},
    "operations": ["set"],
    "required": False,
    "allowedValues": None,
}

FIELD_PRIORITY = {
    "name": "Priority",
    "schema": {"type": "priority", "system": None, "custom": None},
    "operations": ["set"],
    "required": False,
    "allowedValues": None,
}

FIELD_ASSET = {
    "name": "Asset Field",
    "schema": {"type": "any", "system": None, "custom": None},
    "operations": ["set"],
    "required": False,
    "allowedValues": None,
}


def workspace_ok(ws_id="ws-777"):
    return (200, {"size": 1, "start": 0, "limit": 25, "isLastPage": True,
                   "values": [{"workspaceId": ws_id}]})


def workspace_403():
    return (403, {"errorMessages": ["Forbidden"], "errors": {}})


def workspace_empty():
    return (200, {"size": 0, "start": 0, "limit": 25, "isLastPage": True, "values": []})


SCENARIOS = {
    # AC-002: :option non-cascading, byte-identical to bare form.
    "option_noncascading": {
        "fields": [("customfield_10176", "Urgency")],
        "editmeta": {"customfield_10176": FIELD_URGENCY},
    },
    # AC-003: :option cascading, str::split_once('>').
    "option_cascading": {
        "fields": [],
        "editmeta": {"customfield_20002": FIELD_CASCADE},
    },
    # AC-004 (EC-3.4.027-7): non-cascading-field '>' collision.
    "option_collision": {
        "fields": [],
        "editmeta": {"customfield_30001": FIELD_PLAIN_OPTION_NO_CHILDREN},
    },
    # AC-019(a): entry-point gate, array type reuses EC-3.4.015-5 message.
    "option_gate_array": {
        "fields": [],
        "editmeta": {"customfield_40001": FIELD_MULTISELECT_ARRAY},
    },
    # AC-019(b): entry-point gate, scalar type distinct message.
    "option_gate_scalar": {
        "fields": [],
        "editmeta": {"customfield_40002": FIELD_PLAIN_TEXT},
    },
    # AC-006: :id bypasses allowedValues lookup entirely.
    "id_hint": {
        "fields": [],
        "editmeta": {"customfield_10286": FIELD_BLOCKER},
    },
    # AC-007: :name verbatim, priority:name=Medium.
    "name_hint_priority": {
        "fields": [("priority", "Priority")],
        "editmeta": {"priority": FIELD_PRIORITY},
    },
    # AC-008: :asset explicit WORKSPACE:OBJECTID form, zero workspace-discovery HTTP.
    "asset_explicit_workspace": {
        "fields": [],
        "editmeta": {"customfield_10002": FIELD_ASSET},
    },
    # AC-009: :asset malformed-shape client-side rejections (EC-2a/2c/2d/EC-3).
    "asset_malformed": {
        "fields": [],
        "editmeta": {"customfield_10001": FIELD_ASSET},
    },
    # AC-010 + AC-013: cold-cache workspace-discovery 403 (+ under --dry-run for AC-013).
    "asset_cold_403": {
        "fields": [],
        "editmeta": {"customfield_10001": FIELD_ASSET},
        "workspace": workspace_403(),
    },
    # AC-010: cold-cache workspace-discovery, zero entries.
    "asset_cold_empty": {
        "fields": [],
        "editmeta": {"customfield_10001": FIELD_ASSET},
        "workspace": workspace_empty(),
    },
}


def make_handler(scenario):
    class Handler(http.server.BaseHTTPRequestHandler):
        def _send_json(self, status, body):
            payload = json.dumps(body).encode("utf-8")
            self.send_response(status)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(payload)))
            self.end_headers()
            self.wfile.write(payload)

        def do_GET(self):
            if self.path == "/rest/api/3/field":
                fields = [
                    {"id": fid, "name": name, "custom": True}
                    for fid, name in scenario.get("fields", [])
                ]
                self._send_json(200, fields)
                return
            if self.path.endswith("/editmeta"):
                em = scenario.get("editmeta", {})
                self._send_json(200, {"fields": em})
                return
            if self.path.startswith("/rest/servicedeskapi/assets/workspace"):
                status, body = scenario.get("workspace", workspace_ok())
                self._send_json(status, body)
                return
            self._send_json(404, {"errorMessages": [f"unmocked GET {self.path}"]})

        def do_PUT(self):
            # None of the recorded demos should ever reach a live PUT (all
            # success demos use --dry-run; all error demos exit 64 first).
            # Respond 204 defensively rather than hanging, in case a demo
            # command is ever run without --dry-run by mistake.
            self.send_response(204)
            self.send_header("Content-Length", "0")
            self.end_headers()

        def do_POST(self):
            self.send_response(204)
            self.send_header("Content-Length", "0")
            self.end_headers()

        def log_message(self, fmt, *args):
            pass  # silence — keep the recorded terminal clean

    return Handler


def main():
    if len(sys.argv) != 3:
        print("usage: mock_server.py <scenario> <port>", file=sys.stderr)
        sys.exit(2)
    scenario_name, port = sys.argv[1], int(sys.argv[2])
    if scenario_name not in SCENARIOS:
        print(f"unknown scenario: {scenario_name}", file=sys.stderr)
        sys.exit(2)
    scenario = SCENARIOS[scenario_name]
    server = http.server.HTTPServer(("127.0.0.1", port), make_handler(scenario))
    server.serve_forever()


if __name__ == "__main__":
    main()
