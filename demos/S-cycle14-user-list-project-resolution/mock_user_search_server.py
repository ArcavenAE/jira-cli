#!/usr/bin/env python3
"""Minimal mock Jira server for S-cycle14-user-list-project-resolution demo
evidence recording (issue #862).

Serves just enough of
`GET /rest/api/3/user/assignable/multiProjectSearch` (the endpoint
`src/api/jira/users.rs::search_assignable_users_by_project[_all]` calls) for
`jr user list` to be demonstrated end-to-end without a real Jira instance.

No real Jira org, account IDs, or emails are used anywhere below -- all
account IDs and display names are synthetic ("fake-acct-...", "Alice
Example", "Bob Example").

Behavior:
- Echoes the resolved `projectKeys` value into each fake user's display
  name (e.g. "Alice Example [project=FOO]") so a viewer of the recording
  can visually confirm which project key `jr` actually resolved and sent,
  without needing to inspect the request itself.
- When the request carries `startAt` (the `--all` pagination path,
  `search_assignable_users_by_project_page`), page `startAt=0` returns two
  users and every later page (`startAt>=100`, i.e. one `USER_PAGE_SIZE`
  window later) returns an empty array -- the empty-page end-of-data signal
  `search_assignable_users_by_project_all` relies on (JRACLOUD-71293 fixed-
  window advance, see CLAUDE.md). This keeps the `--all` demo to exactly
  two HTTP requests instead of needing 100+ fake users to fill a page.
- When `startAt` is absent (the default, non-`--all` path), always returns
  the same two-user fixed list regardless of pagination.
"""
import http.server
import json
import sys
import urllib.parse

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8791


def users_for(project: str, page_suffix: str = "") -> list:
    label = f"[project={project}{page_suffix}]"
    return [
        {
            "accountId": "fake-acct-0000000000000001",
            "displayName": f"Alice Example {label}",
            "active": True,
        },
        {
            "accountId": "fake-acct-0000000000000002",
            "displayName": f"Bob Example {label}",
            "active": True,
        },
    ]


class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        pass  # keep VHS recording quiet; no request logging to stdout/stderr

    def _json(self, obj, status=200):
        body = json.dumps(obj).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        parsed = urllib.parse.urlparse(self.path)
        if parsed.path != "/rest/api/3/user/assignable/multiProjectSearch":
            self._json({"errorMessages": [f"mock: no route for {parsed.path}"]}, status=404)
            return

        qs = urllib.parse.parse_qs(parsed.query)
        project = qs.get("projectKeys", [""])[0]
        start_at_vals = qs.get("startAt")

        if start_at_vals is not None:
            start_at = int(start_at_vals[0])
            if start_at == 0:
                self._json(users_for(project, " page1"))
            else:
                self._json([])
            return

        self._json(users_for(project))


if __name__ == "__main__":
    server = http.server.HTTPServer(("127.0.0.1", PORT), Handler)
    server.serve_forever()
