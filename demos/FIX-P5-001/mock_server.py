#!/usr/bin/env python3
"""Minimal mock Jira server for FIX-P5-001 demo evidence recording
(BC-7.1.006, SEC-001-RENDER-TABLE-ANSI-SANITIZE — table-mode ANSI/control
sequence sanitization in output::render_table / render_table_with_styles).

Serves fake, hand-authored fixture JSON for exactly the endpoints the demo
scenarios exercise (verified against src/api/jira/*.rs):

  - GET  /rest/api/3/field                                  (field list / CMDB discovery, issue view)
  - GET  /rest/api/3/issue/FOO-1/editmeta                    (jr field options --issue, M1)
  - GET  /rest/api/3/issue/FOO-2*                            (jr issue view)
  - POST /rest/api/3/search/jql                              (jr issue list)
  - GET  /rest/api/3/user/assignable/multiProjectSearch*     (jr user list)
  - GET  /rest/api/3/user*accountId=*                        (jr user view)

No real Jira org, account ID, instance URL, or credential is used anywhere
below. Every hostile payload is a synthetic ANSI/control-sequence probe, not
data from any real system. Every request received is appended as one line
to a log file (path given as argv[2]).

Hostile payload design (see evidence-report.md for the full character-by-
character rationale):

  SUMMARY_HOSTILE (jr issue list):
    "Before " + SGR red-on + "FAKE-CRITICAL" + SGR reset + " "
    + OSC-0 title-set "pwned" (BEL-terminated) + "mid "
    + C1 CSI introducer (U+009B) + "31mInject bidi"
    + bidi-override (U+202E) + "override" + bidi-override (U+202E)
    + " end" + CRLF + "SecondLine"
    Expected AFTER sanitize_table_cell:
    "Before FAKE-CRITICAL mid 31mInject bidioverride end\nSecondLine"

  customfield_10300 "Severity" (jr field options, M1 editmeta):
    id 1 -> value carries an SGR-colored label
    id 2 -> value is "a\tb" (tab-to-space demo, EC-10)
    id 3 -> plain "Plain" (contrast/no-op control)

  FOO-2 description (jr issue view):
    ADF paragraph + hardBreak + paragraph carrying an SGR sequence and a
    bidi-override pair, proving the multi-line cell still renders across
    lines (the hardBreak-emitted \n survives sanitize_table_cell) while the
    hostile bytes are stripped.

  user list / user view (jr user list, jr user view):
    one hostile displayName ("Bob <SGR-red>Hostile<SGR-reset> Name"),
    active true/false/null to exercise all three Active-column glyphs.
"""
import http.server
import json
import re
import sys
from urllib.parse import urlparse, parse_qs

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8793
LOG_PATH = sys.argv[2] if len(sys.argv) > 2 else "/tmp/jr-demo-fix-p5-001-requests.log"

ESC = "\x1b"
BEL = "\x07"
C1_CSI = "\u009b"
BIDI_RLO = "‮"

SUMMARY_HOSTILE = (
    "Before "
    + ESC + "[31mFAKE-CRITICAL" + ESC + "[0m"
    + " "
    + ESC + "]0;pwned" + BEL
    + "mid "
    + C1_CSI + "31mInject bidi"
    + BIDI_RLO + "override" + BIDI_RLO
    + " end"
    + "\r\n"
    + "SecondLine"
)

SEVERITY_HOSTILE_LABEL = "Before " + ESC + "[35mSev-Hostile" + ESC + "[0m" + " After"

DESC_ADF_FOO_2 = {
    "type": "doc",
    "version": 1,
    "content": [
        {
            "type": "paragraph",
            "content": [
                {"type": "text", "text": "Line one " + ESC + "[31mRED" + ESC + "[0m" + " end"},
                {"type": "hardBreak"},
                {
                    "type": "text",
                    "text": "Line two with bidi " + BIDI_RLO + "override" + BIDI_RLO + " done",
                },
            ],
        }
    ],
}

FIELD_LIST = [
    {"id": "priority", "name": "Priority", "custom": False, "schema": {"type": "priority", "custom": None}},
    {"id": "summary", "name": "Summary", "custom": False, "schema": {"type": "string", "custom": None}},
    {
        "id": "customfield_10300",
        "name": "Severity",
        "custom": True,
        "schema": {"type": "option", "custom": "com.atlassian.jira.plugin.system.customfieldtypes:select"},
    },
]

EDITMETA_FOO_1 = {
    "fields": {
        "customfield_10300": {
            "name": "Severity",
            "schema": {
                "type": "option",
                "system": None,
                "custom": "com.atlassian.jira.plugin.system.customfieldtypes:select",
            },
            "allowedValues": [
                {"id": "1", "value": SEVERITY_HOSTILE_LABEL, "name": None, "children": []},
                {"id": "2", "value": "a\tb", "name": None, "children": []},
                {"id": "3", "value": "Plain", "name": None, "children": []},
            ],
            "operations": ["set"],
            "required": False,
            "autoCompleteUrl": None,
        }
    }
}

ISSUE_FOO_2 = {
    "key": "FOO-2",
    "fields": {
        "summary": "Demo issue for multi-line description sanitization",
        "status": {"name": "In Progress", "statusCategory": {"name": "In Progress", "key": "indeterminate"}},
        "issuetype": {"name": "Task", "subtask": False},
        "priority": {"name": "Medium"},
        "assignee": None,
        "reporter": None,
        "project": {"key": "FOO", "name": "Demo Project"},
        "created": None,
        "updated": None,
        "duedate": None,
        "resolution": None,
        "components": [],
        "fixVersions": [],
        "labels": [],
        "parent": None,
        "issuelinks": [],
        "description": DESC_ADF_FOO_2,
    },
}

SEARCH_JQL_RESULT = {
    "issues": [
        {
            "key": "FOO-10",
            "fields": {
                "summary": SUMMARY_HOSTILE,
                "status": {"name": "To Do", "statusCategory": {"name": "To Do", "key": "new"}},
                "issuetype": {"name": "Bug", "subtask": False},
                "priority": {"name": "High"},
                "assignee": {
                    "accountId": "acc-1",
                    "displayName": "Alice Normal",
                    "emailAddress": "alice@example.invalid",
                    "active": True,
                },
                "reporter": None,
                "project": {"key": "FOO", "name": "Demo Project"},
                "created": None,
                "updated": None,
                "duedate": None,
                "resolution": None,
                "components": [],
                "fixVersions": [],
                "labels": [],
                "parent": None,
                "issuelinks": [],
            },
        },
        {
            "key": "FOO-11",
            "fields": {
                "summary": "Ordinary clean summary, unaffected",
                "status": {"name": "Done", "statusCategory": {"name": "Done", "key": "done"}},
                "issuetype": {"name": "Task", "subtask": False},
                "priority": {"name": "Low"},
                "assignee": None,
                "reporter": None,
                "project": {"key": "FOO", "name": "Demo Project"},
                "created": None,
                "updated": None,
                "duedate": None,
                "resolution": None,
                "components": [],
                "fixVersions": [],
                "labels": [],
                "parent": None,
                "issuelinks": [],
            },
        },
    ],
    "nextPageToken": None,
}

USERS_ASSIGNABLE = [
    {
        "accountId": "acc-1",
        "displayName": "Alice Normal",
        "emailAddress": "alice@example.invalid",
        "active": True,
    },
    {
        "accountId": "acc-2",
        "displayName": "Bob " + ESC + "[31mHostile" + ESC + "[0m" + " Name",
        "emailAddress": "bob@example.invalid",
        "active": False,
    },
    {
        "accountId": "acc-3",
        "displayName": "Carol Unknown",
        "emailAddress": None,
        "active": None,
    },
]

USERS_BY_ACCOUNT_ID = {u["accountId"]: u for u in USERS_ASSIGNABLE}


class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        pass  # keep the VHS recording quiet

    def _log_request(self, method):
        with open(LOG_PATH, "a") as f:
            f.write(f"{method} {self.path}\n")

    def _send_json(self, payload, status=200):
        body = json.dumps(payload, indent=2, ensure_ascii=False).encode("utf-8") + b"\n"
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        self._log_request("GET")
        parsed = urlparse(self.path)
        path = parsed.path
        qs = parse_qs(parsed.query)

        if path == "/rest/api/3/field":
            self._send_json(FIELD_LIST)
            return

        if path == "/rest/api/3/project/FOO":
            self._send_json({"key": "FOO", "name": "Demo Project", "id": "10005"})
            return

        if path == "/rest/api/3/issue/FOO-1/editmeta":
            self._send_json(EDITMETA_FOO_1)
            return

        if path == "/rest/api/3/issue/FOO-2":
            self._send_json(ISSUE_FOO_2)
            return

        if path == "/rest/api/3/user/assignable/multiProjectSearch":
            self._send_json(USERS_ASSIGNABLE)
            return

        if path == "/rest/api/3/user":
            account_id = qs.get("accountId", [None])[0]
            user = USERS_BY_ACCOUNT_ID.get(account_id)
            if user is None:
                self._send_json({"errorMessages": [f"mock: unknown accountId {account_id}"]}, status=404)
                return
            self._send_json(user)
            return

        # Unmapped path (e.g. a stray editmeta/CMDB probe outside this
        # scenario set) -- fail loudly and visibly rather than silently
        # 404ing without a trace, so a wiring mistake is obvious in the log.
        self._send_json({"errorMessages": [f"mock: unmapped GET path {path}"]}, status=404)

    def do_POST(self):
        self._log_request("POST")
        # Always drain the request body so keep-alive connections stay in
        # sync, even though these fixtures don't branch on the JQL sent.
        length = int(self.headers.get("Content-Length", 0))
        if length:
            self.rfile.read(length)
        path = self.path.split("?", 1)[0]

        if path == "/rest/api/3/search/jql":
            self._send_json(SEARCH_JQL_RESULT)
            return

        self._send_json({"errorMessages": [f"mock: unmapped POST path {path}"]}, status=404)


if __name__ == "__main__":
    server = http.server.HTTPServer(("127.0.0.1", PORT), Handler)
    server.serve_forever()
