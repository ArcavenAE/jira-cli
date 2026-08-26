#!/usr/bin/env python3
"""Minimal mock Jira/JSM server for demo evidence recording (S-578-1).

Serves just enough of the Jira platform + JSM API for
`get_or_fetch_project_meta` / `require_service_desk` to succeed, so the
S-578-1 interim `:kind`-hint guard on the JSM create path can be reached
and demonstrated without a real Jira instance. No mutation endpoints are
served (POST /rest/servicedeskapi/request is intentionally absent) --
the guard fires and returns exit 64 before any such call would happen.
"""
import http.server
import json
import sys

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 18765
PROJECT_KEY = "DEMO"


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
        if self.path.startswith(f"/rest/api/3/project/{PROJECT_KEY}"):
            self._json({
                "id": "10001",
                "key": PROJECT_KEY,
                "projectTypeKey": "service_desk",
                "simplified": False,
            })
        elif self.path.startswith("/rest/servicedeskapi/servicedesk/1/requesttype"):
            self._json({
                "size": 1,
                "start": 0,
                "limit": 50,
                "isLastPage": True,
                "values": [
                    {"id": "10", "name": "Get IT Help", "serviceDeskId": "1"}
                ],
            })
        elif self.path.startswith("/rest/servicedeskapi/servicedesk"):
            self._json({
                "size": 1,
                "start": 0,
                "limit": 50,
                "isLastPage": True,
                "values": [
                    {"id": "1", "projectId": "10001", "projectKey": PROJECT_KEY, "projectName": "Demo"}
                ],
            })
        else:
            self._json({"errorMessages": [f"mock: no route for {self.path}"]}, status=404)

    def do_POST(self):
        # This mock intentionally does not implement request creation --
        # it exists only to let GET-based JSM discovery (project meta,
        # service desk lookup, request-type lookup) succeed so the parser
        # guard can be reached. A bare (unhinted) --field pair is expected
        # to get this far and fail here, demonstrating it was NOT rejected
        # by the S-578-1 interim hint guard.
        self._json(
            {"errorMessages": ["mock server: request creation not implemented (demo mock, not a real Jira instance)"]},
            status=501,
        )


if __name__ == "__main__":
    server = http.server.HTTPServer(("127.0.0.1", PORT), Handler)
    server.serve_forever()
