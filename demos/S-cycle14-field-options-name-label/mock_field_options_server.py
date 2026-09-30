#!/usr/bin/env python3
"""Minimal mock Jira/JSM server for S-cycle14-field-options-name-label demo
evidence recording (`jr field options`, issue #861).

Serves fake, hand-authored fixture JSON for exactly the endpoints
`jr field options` calls (verified against `src/cli/field.rs` and
`src/api/jira/issues.rs`/`src/api/jsm/*.rs`):

  - GET /rest/api/3/field                                            (field list)
  - GET /rest/api/3/issue/{key}/editmeta                              (M1)
  - GET /rest/api/3/issue/createmeta/{proj}/issuetypes                (M2 issue types)
  - GET /rest/api/3/issue/createmeta/{proj}/issuetypes/{issueTypeId}  (M2 fields)
  - GET /rest/api/3/project/{key}                                     (JSM project meta)
  - GET /rest/servicedeskapi/servicedesk                              (JSM service desk list)
  - GET /rest/servicedeskapi/servicedesk/{id}/requesttype/{rtId}/field (M3)

No real Jira org, account ID, instance URL, or credential is used anywhere
below. Every request received is appended as one line to a log file (path
given as argv[2]) so a recording can prove a pre-flight guard (e.g. the
empty-`<field>` exit-64 case) makes ZERO HTTP calls: `wc -l` on that log
file is unchanged across such a recording.

Fixture design notes (see evidence-report.md for the full rationale):
  - "Priority" (system field, id `priority`) carries `allowedValues` shaped
    like REAL Jira: `{id, name, iconUrl}` with NO `value` key at all — the
    exact #861 defect shape.
  - "Components" (system field, id `components`) is exposed only via the
    M2 createmeta path, same `{id, name, iconUrl}`-shaped `allowedValues`.
  - "Fix versions" (system field, id `fixVersions`) is listed in
    `/rest/api/3/field` only (per the task's checklist) — no dedicated
    demo calls it directly.
  - "Environment" (custom select, `customfield_10100`) carries ordinary
    `{id, value}` entries — proves custom-field labels are byte-for-byte
    unchanged by this fix.
  - "Category" (custom CASCADING select, `customfield_10200`) has a
    top-level entry with `value` and two children: one `{id, value}`
    (unchanged) and one `{id, name}` only (exercises the fallback
    recursing into cascading children, EC-X.14.001-11).
  - "Severity Probe" (custom select, `customfield_10300`) carries the two
    EC-X.14.001-12 presence-semantics fixtures: `{"value": "", "name":
    "Blank But Named"}` (value wins, even though empty) and `{"value":
    null, "name": "Falls Through"}` (null is truly absent, falls through
    to name).
  - "Legacy Probe" (custom select, `customfield_10400`) carries an entry
    with NEITHER `value` NOR `name` — the pre-existing degenerate case,
    proving the entry still renders (never dropped) as "(unnamed)"/null.
"""
import http.server
import json
import re
import sys

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8793
LOG_PATH = sys.argv[2] if len(sys.argv) > 2 else "/tmp/jr-demo-field-options-requests.log"

FIELD_LIST = [
    {"id": "priority", "name": "Priority", "custom": False},
    {"id": "components", "name": "Components", "custom": False},
    {"id": "fixVersions", "name": "Fix versions", "custom": False},
    {"id": "customfield_10100", "name": "Environment", "custom": True},
    {"id": "customfield_10200", "name": "Category", "custom": True},
    {"id": "customfield_10300", "name": "Severity Probe", "custom": True},
    {"id": "customfield_10400", "name": "Legacy Probe", "custom": True},
]

EDITMETA_FOO_1 = {
    "fields": {
        "priority": {
            "name": "Priority",
            "schema": {"type": "priority"},
            # Real-Jira shape: {id, name, iconUrl} -- NO "value" key.
            "allowedValues": [
                {"id": "1", "name": "Highest", "iconUrl": "https://example.invalid/icons/highest.svg"},
                {"id": "2", "name": "High", "iconUrl": "https://example.invalid/icons/high.svg"},
                {"id": "3", "name": "Medium", "iconUrl": "https://example.invalid/icons/medium.svg"},
            ],
            "operations": ["set"],
            "required": False,
        },
        "customfield_10100": {
            "name": "Environment",
            "schema": {"type": "option", "custom": "com.atlassian.jira.plugin.system.customfieldtypes:select"},
            "allowedValues": [
                {"id": "100", "value": "Production"},
                {"id": "101", "value": "Staging"},
            ],
            "operations": ["set"],
            "required": False,
        },
        "customfield_10200": {
            "name": "Category",
            "schema": {"type": "option-with-child", "custom": "com.atlassian.jira.plugin.system.customfieldtypes:cascadingselect"},
            "allowedValues": [
                {
                    "id": "200",
                    "value": "Infra",
                    "children": [
                        {"id": "200-1", "value": "Network"},
                        {"id": "200-2", "name": "Storage Only"},
                    ],
                },
            ],
            "operations": ["set"],
            "required": False,
        },
        "customfield_10300": {
            "name": "Severity Probe",
            "schema": {"type": "option", "custom": "com.atlassian.jira.plugin.system.customfieldtypes:select"},
            "allowedValues": [
                {"id": "300", "value": "", "name": "Blank But Named"},
                {"id": "301", "value": None, "name": "Falls Through"},
            ],
            "operations": ["set"],
            "required": False,
        },
        "customfield_10400": {
            "name": "Legacy Probe",
            "schema": {"type": "option", "custom": "com.atlassian.jira.plugin.system.customfieldtypes:select"},
            # Neither "value" nor "name" -- the pre-existing degenerate case.
            "allowedValues": [
                {"id": "99"},
            ],
            "operations": ["set"],
            "required": False,
        },
    }
}

CREATEMETA_ISSUETYPES_FOO = {
    "issueTypes": [{"id": "10001", "name": "Task"}],
    "startAt": 0,
    "maxResults": 200,
    "total": 1,
}

CREATEMETA_FIELDS_FOO_10001 = {
    "fields": [
        {
            "fieldId": "components",
            "name": "Components",
            "schema": {"type": "array", "system": "components"},
            "allowedValues": [
                {"id": "10", "name": "Backend"},
                {"id": "11", "name": "Frontend"},
            ],
        },
    ],
    "startAt": 0,
    "maxResults": 200,
    "total": 1,
}

PROJECT_EJ = {"projectTypeKey": "service_desk", "simplified": False, "id": "10005"}

SERVICEDESK_LIST = {
    "size": 1,
    "start": 0,
    "limit": 50,
    "isLastPage": True,
    "values": [{"id": "1", "projectId": "10005", "projectName": "EJ"}],
}

REQUESTTYPE_10_FIELDS = {
    "canRaiseOnBehalfOf": False,
    "canAddRequestParticipants": False,
    "requestTypeFields": [
        {
            "fieldId": "priority",
            "name": "Priority",
            "description": None,
            "required": False,
            "visible": True,
            "defaultValues": None,
            # M3's OWN wire shape: id-from-".value", label-from-".label" --
            # already correct before this story, unchanged by it.
            "validValues": [
                {"value": "1", "label": "Highest"},
                {"value": "2", "label": "High"},
            ],
            "jiraSchema": {"type": "priority"},
        },
    ],
}


class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        pass  # keep the VHS recording quiet

    def _log_request(self):
        with open(LOG_PATH, "a") as f:
            f.write(f"GET {self.path}\n")

    def _send_json(self, payload, status=200):
        body = json.dumps(payload, indent=2).encode() + b"\n"
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        self._log_request()
        path = self.path.split("?", 1)[0]

        if path == "/rest/api/3/field":
            self._send_json(FIELD_LIST)
            return

        if path == "/rest/api/3/issue/FOO-1/editmeta":
            self._send_json(EDITMETA_FOO_1)
            return

        if path == "/rest/api/3/issue/createmeta/FOO/issuetypes":
            self._send_json(CREATEMETA_ISSUETYPES_FOO)
            return

        if path == "/rest/api/3/issue/createmeta/FOO/issuetypes/10001":
            self._send_json(CREATEMETA_FIELDS_FOO_10001)
            return

        # Any OTHER project's createmeta issuetypes call -> 404, to
        # demonstrate the M2 "project not found" error path.
        m = re.match(r"^/rest/api/3/issue/createmeta/([^/]+)/issuetypes$", path)
        if m:
            self._send_json({"errorMessages": ["The project could not be found."]}, status=404)
            return

        if path == "/rest/api/3/project/EJ":
            self._send_json(PROJECT_EJ)
            return

        if path == "/rest/servicedeskapi/servicedesk":
            self._send_json(SERVICEDESK_LIST)
            return

        if path == "/rest/servicedeskapi/servicedesk/1/requesttype/10/field":
            self._send_json(REQUESTTYPE_10_FIELDS)
            return

        # Unmapped path -- fail loudly and visibly rather than silently
        # 404ing, so a wiring mistake in a recording is obvious.
        self._send_json({"errorMessages": [f"mock: unmapped path {path}"]}, status=404)


if __name__ == "__main__":
    server = http.server.HTTPServer(("127.0.0.1", PORT), Handler)
    server.serve_forever()
