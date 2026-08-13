#!/usr/bin/env python3
"""Tiny local mock Jira HTTP server for S-668-1 demo recording.

Serves fixed, fake JSON fixtures (no real Jira keys/org/URLs) for the two
endpoints `jr issue view`/`jr issue list` hit: GET /rest/api/3/issue/<KEY>
and POST /rest/api/3/search/jql. Intended to be pointed at via the
debug-only JR_BASE_URL test seam (see CLAUDE.md "AI Agent Notes").
"""
import json
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse

PORT = 8934

def issue_fields(summary, status, duedate):
    return {
        "summary": summary,
        "status": {"name": status},
        "issuetype": {"name": "Story"},
        "priority": {"name": "Medium"},
        "assignee": {"accountId": "demo-acc-1", "displayName": "Alex Rivera"},
        "reporter": {"accountId": "demo-acc-2", "displayName": "Sam Okafor"},
        "project": {"key": "PROJ", "name": "Demo Project"},
        "created": "2027-06-01T10:00:00.000+0000",
        "updated": "2027-07-15T09:30:00.000+0000",
        "duedate": duedate,
        "labels": [],
    }

ISSUES = {
    "PROJ-1": {"key": "PROJ-1", "fields": issue_fields("Ship the widget", "To Do", "2027-07-30")},
    "PROJ-2": {"key": "PROJ-2", "fields": issue_fields("No due date set yet", "To Do", None)},
}

SEARCH_RESPONSE = {
    "issues": [ISSUES["PROJ-1"], ISSUES["PROJ-2"]],
    "nextPageToken": None,
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

    def do_GET(self):
        path = urlparse(self.path).path
        for key, issue in ISSUES.items():
            if path == f"/rest/api/3/issue/{key}":
                self._send_json(issue)
                return
        self._send_json({"errorMessages": ["Not found (demo mock)"]}, status=404)

    def do_POST(self):
        path = urlparse(self.path).path
        if path == "/rest/api/3/search/jql":
            self._send_json(SEARCH_RESPONSE)
            return
        self._send_json({"errorMessages": ["Not found (demo mock)"]}, status=404)

if __name__ == "__main__":
    server = HTTPServer(("127.0.0.1", PORT), Handler)
    print(f"mock jira server listening on http://127.0.0.1:{PORT}")
    server.serve_forever()
