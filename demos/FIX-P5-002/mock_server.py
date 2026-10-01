#!/usr/bin/env python3
"""Minimal mock Jira server for FIX-P5-002 demo evidence recording
(BC-7.1.006 v2.5.6, EC-17, CR-1/CR-2 -- single-line sanitization +
structural color gate, D-396).

Serves fake, hand-authored fixture JSON for exactly the endpoints the demo
scenarios exercise (verified against src/api/jira/*.rs,
src/cli/issue/{interactions,workflow,helpers}.rs, src/cli/user.rs):

  - GET  /rest/api/3/issue/FOO-1                       (jr issue assign idempotency check, scenario 2)
  - GET  /rest/api/3/issue/FOO-1/comment/9001           (jr issue comment view, scenario 1)
  - GET  /rest/api/3/user/assignable/search             (jr issue assign --to, scenarios 2 + 3,
                                                           keyed on issueKey=FOO-1 vs FOO-9)
  - PUT  /rest/api/3/issue/FOO-1/assignee                (jr issue assign --to, scenario 2)
  - GET  /rest/api/3/user/assignable/multiProjectSearch  (jr user list --project FOO, scenario 4)

No real Jira org, account ID, instance URL, or credential is used anywhere
below. Every hostile payload is a synthetic newline-injection probe (EC-17),
not data from any real system. Modeled on the FIX-P5-001 precedent's
mock_server.py.

Hostile payload design:

  COMMENT_9001 (scenario 1, EC-17a):
    author.displayName = "Eve\nRestricted: None" -- no "visibility" key, so
    the REAL Restricted field renders "Restricted: None" in its correct
    spot. Before FIX-P5-002 (sanitize_terminal_text preserves \n), the
    Author line's embedded \n fabricates a FAKE "Restricted: None" line
    immediately after "Author: Eve". After FIX-P5-002
    (sanitize_terminal_line), the \n becomes a single space:
    "Author: Eve Restricted: None" -- one line, and the real Restricted:
    line two lines later is unaffected.

  Scenario 2 (single-match assign, EC-17b precursor):
    GET .../assignable/search?issueKey=FOO-1 returns exactly ONE user,
    display_name "Mallory\nEve" -- disambiguate_user's `users.len() == 1`
    short-circuit returns it directly (no partial_match involved). Before
    the fix, "Assigned FOO-1 to Mallory\nEve" renders as two lines; after,
    one line: "Assigned FOO-1 to Mallory Eve".

  Scenario 3 (ExactMultiple duplicates, EC-17):
    GET .../assignable/search?issueKey=FOO-9 returns TWO users, both with
    the IDENTICAL display_name "Mallory\nEve" (a hostile duplicate-name
    collision) but different emails/account IDs. Querying --to with the
    literal string "Mallory\nEve" (typed via bash $'...' ANSI-C quoting)
    exact-matches both (case-insensitive), triggering
    MatchResult::ExactMultiple. The --no-input error lists each duplicate
    on its own line ("  <name> (<email>, account: <id>)"); before the fix
    each duplicate's embedded \n split that single line into two,
    indistinguishable from a separate duplicate's line.

  Scenario 4 (CR-2, structural color gate):
    GET .../multiProjectSearch?projectKeys=FOO returns three ordinary
    (non-hostile) users with active true/false/null, exercising all three
    Active-column glyphs (check/cross/em-dash) so the structural
    comfy_table::Cell::fg() color (gated on colored::control::
    SHOULD_COLORIZE) can be shown present under a real pty and absent
    under NO_COLOR=1 / --no-color.
"""
import http.server
import json
import sys
from urllib.parse import urlparse, parse_qs

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8794
LOG_PATH = sys.argv[2] if len(sys.argv) > 2 else "/tmp/jr-demo-fixp5-002-requests.log"

COMMENT_9001 = {
    "id": "9001",
    "author": {"displayName": "Eve\nRestricted: None"},
    "created": "2026-09-01T10:00:00.000+0000",
    "updated": "2026-09-01T10:00:00.000+0000",
    "body": {
        "type": "doc",
        "version": 1,
        "content": [
            {
                "type": "paragraph",
                "content": [{"type": "text", "text": "Demo comment body, unaffected by the fix."}],
            }
        ],
    },
}

ISSUE_FOO_1_UNASSIGNED = {
    "key": "FOO-1",
    "fields": {
        "summary": "Demo issue for assign sanitization",
        "status": {"name": "To Do", "statusCategory": {"name": "To Do", "key": "new"}},
        "issuetype": {"name": "Task", "subtask": False},
        "priority": {"name": "Medium"},
        "assignee": None,
        "reporter": None,
        "project": {"key": "FOO", "name": "Demo Project"},
        "description": None,
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
}

# Scenario 2: single assignable match on FOO-1 -- disambiguate_user's
# `users.len() == 1` short-circuit, no ambiguity logic involved.
ASSIGNABLE_FOO_1 = [
    {
        "accountId": "acc-mallory",
        "displayName": "Mallory\nEve",
        "emailAddress": "mallory@example.invalid",
        "active": True,
    }
]

# Scenario 3: two users with the IDENTICAL hostile display_name on FOO-9 --
# triggers MatchResult::ExactMultiple when queried with the exact literal
# "Mallory\nEve".
ASSIGNABLE_FOO_9 = [
    {
        "accountId": "acc-mallory-1",
        "displayName": "Mallory\nEve",
        "emailAddress": "mallory1@example.invalid",
        "active": True,
    },
    {
        "accountId": "acc-mallory-2",
        "displayName": "Mallory\nEve",
        "emailAddress": "mallory2@example.invalid",
        "active": True,
    },
]

# Scenario 4: ordinary (non-hostile) users exercising all three Active
# glyphs for the CR-2 structural color-gate demo.
USERS_PROJECT_FOO = [
    {
        "accountId": "acc-1",
        "displayName": "Alice Normal",
        "emailAddress": "alice@example.invalid",
        "active": True,
    },
    {
        "accountId": "acc-2",
        "displayName": "Bob Inactive",
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

        if path == "/rest/api/3/issue/FOO-1":
            self._send_json(ISSUE_FOO_1_UNASSIGNED)
            return

        if path == "/rest/api/3/issue/FOO-1/comment/9001":
            self._send_json(COMMENT_9001)
            return

        if path == "/rest/api/3/user/assignable/search":
            issue_key = qs.get("issueKey", [None])[0]
            if issue_key == "FOO-1":
                self._send_json(ASSIGNABLE_FOO_1)
                return
            if issue_key == "FOO-9":
                self._send_json(ASSIGNABLE_FOO_9)
                return
            self._send_json([])
            return

        if path == "/rest/api/3/user/assignable/multiProjectSearch":
            self._send_json(USERS_PROJECT_FOO)
            return

        # Unmapped path -- fail loudly and visibly rather than silently
        # 404ing without a trace, so a wiring mistake is obvious in the log.
        self._send_json({"errorMessages": [f"mock: unmapped GET path {path}"]}, status=404)

    def do_PUT(self):
        self._log_request("PUT")
        length = int(self.headers.get("Content-Length", 0))
        if length:
            self.rfile.read(length)
        path = self.path.split("?", 1)[0]

        if path == "/rest/api/3/issue/FOO-1/assignee":
            self.send_response(204)
            self.send_header("Content-Length", "0")
            self.end_headers()
            return

        self._send_json({"errorMessages": [f"mock: unmapped PUT path {path}"]}, status=404)

    def do_POST(self):
        self._log_request("POST")
        length = int(self.headers.get("Content-Length", 0))
        if length:
            self.rfile.read(length)
        path = self.path.split("?", 1)[0]
        self._send_json({"errorMessages": [f"mock: unmapped POST path {path}"]}, status=404)


if __name__ == "__main__":
    server = http.server.HTTPServer(("127.0.0.1", PORT), Handler)
    server.serve_forever()
