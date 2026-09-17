# S-cycle8-jsm-servicedeskapi-oauth-routing Demo Evidence

Story: JSM servicedeskapi OAuth gateway routing — 6-site `get_from_instance`/
`post_to_instance` -> `get`/`post` swap (closes #831)
Branch: `fix/cycle8-jsm-oauth-routing`
Head: `722d5182781f4c01b7549c067c8d37a48c7facea`
Binary: n/a (no CLI binary invocation — evidence is wiremock-backed integration test output)
Captured: 2026-09-17

## Why this is a test-evidence demo, not a live CLI demo

This story fixes an OAuth-3LO gateway-routing 401 across 6 JSM `servicedeskapi` call sites
in `src/api/jsm/servicedesks.rs`, `request_types.rs`, `queues.rs`, and `requests.rs`: the
pre-fix code called `client.get_from_instance(...)` / `client.post_to_instance(...)`, which
route to `instance_url` (the real `*.atlassian.net` site host); under OAuth 3LO the site host
rejects the gateway bearer token, while `base_url` (the API gateway) accepts it. This
divergence is only observable under a LIVE OAuth-authenticated Jira session, which this
project does not exercise for demo purposes (no live mutations, per repo policy). The honest,
reproducible, and CI-equivalent evidence is a captured run of the 6 wiremock-backed tests that
directly assert the fixed routing behavior, following the same per-story evidence convention
as `S-cycle8-assets-workspace-oauth-routing` (this cycle's sibling story, sharing the same
BC-4.2.001 anchor), `S-576-5`, `S-577-*`, etc. (one subdirectory per story ID, plain-text
`cargo test -- --nocapture` captures + this INDEX).

VHS (`/opt/homebrew/bin/vhs`) IS available in this environment and was attempted first per
the generic demo-recorder protocol — it launched cleanly but produced only a blank recording
(no keystroke ever reached the terminal; confirmed by inspecting a rendered frame), the same
known input-delivery failure already documented for a prior story in this repo
(`cycles/cycle-003/code-delivery/S-cycle3-percred-storage/demos/README.md`). This is moot for
this story regardless: recording a VHS terminal session of `cargo test` output would add no
information over a direct text capture — there is no interactive CLI flow to demonstrate, since
the fix is entirely inside an HTTP-routing decision that only a wiremock dual-host
negative-control test can observe.

## Summary

All 6 code-fix acceptance criteria (AC-001 through AC-006) are proven by 6 wiremock-backed
integration tests in `tests/jsm_request_api.rs`, each with a built-in positive assertion
(request lands on the `base_url` mock) and negative control (the `instance_url` mock receives
ZERO requests) — the negative control is what would catch a regression back to the
401-under-OAuth behavior, serving as this story's error-path proof. The two regression-only
ACs (AC-007, AC-008) are proven by the full `tests/jsm_request_api.rs` suite going green
(13 tests: 7 pre-existing + 6 new, 0 failures, 0 test-file edits required beyond what AC-001..006
added) plus a diff-scope review confirming exactly 6 functional lines changed across the 4
source files. AC-009 (CHANGELOG entry + ADR-0026 doc backlinks) is a doc artifact, verified
present in `CHANGELOG.md` and `docs/adr/000{6,9},0013-*.md` on the feature branch.

## Per-AC Evidence

| AC | Demo File | Test Function(s) | Result |
|----|-----------|-------------------|--------|
| AC-001 (BC-4.2.001 fix-table row 1 — `list_service_desks` targets `base_url` under OAuth, negative control on `instance_url`) | `ac-001-list-service-desks.txt` | `test_bc_4_2_001_list_service_desks_targets_base_url_under_oauth` | ok |
| AC-002 (fix-table row 2 — `list_request_types`) | `ac-002-list-request-types.txt` | `test_bc_4_2_001_list_request_types_targets_base_url_under_oauth` | ok |
| AC-003 (fix-table row 3 — `get_request_type_fields`) | `ac-003-get-request-type-fields.txt` | `test_bc_4_2_001_get_request_type_fields_targets_base_url_under_oauth` | ok |
| AC-004 (fix-table row 4 — `list_queues`) | `ac-004-list-queues.txt` | `test_bc_4_2_001_list_queues_targets_base_url_under_oauth` | ok |
| AC-005 (fix-table row 5 — `get_queue_issue_keys`) | `ac-005-get-queue-issue-keys.txt` | `test_bc_4_2_001_get_queue_issue_keys_targets_base_url_under_oauth` | ok |
| AC-006 (fix-table row 6 — `create_jsm_request`, POST variant, payload byte-for-byte unchanged) | `ac-006-create-jsm-request.txt` | `test_bc_4_2_001_create_jsm_request_targets_base_url_under_oauth` | ok |
| AC-001..006 combined | `ac-001-006-combined.txt` | all 6 of the above, single `cargo test` invocation | ok (6 passed) |
| AC-007 (full pre-existing suite unmodified + green — no-op for API-token profiles) + AC-008 (no other line in `servicedesks.rs`/`request_types.rs`/`queues.rs`/`requests.rs` changed) | `full-suite.txt` | full `tests/jsm_request_api.rs` suite | ok (13 passed) |
| AC-009 (CHANGELOG `[Unreleased] > Fixed` entry + 3 ADR-0026 backlinks in `docs/adr/`) | N/A — doc artifact | n/a | present on `fix/cycle8-jsm-oauth-routing`, verified via `grep` against `CHANGELOG.md` (see below) |

## AC-009 verification (doc artifact, no test)

```
$ grep -B2 -A8 "cycle8-jsm-servicedeskapi-oauth-routing" CHANGELOG.md
```
(run against `fix/cycle8-jsm-oauth-routing`) confirms a `[Unreleased] > Fixed` entry describing
that `jr queue`, `jr requesttype`, and `jr issue create --request-type` now work under OAuth
(3LO) profiles, with no behavior change for API-token profiles. The three `docs/adr/`
forward-reference backlinks to ADR-0026 are present per the story's own commit,
`722d5182781f4c01b7549c067c8d37a48c7facea` ("docs(S-cycle8-jsm-servicedeskapi-oauth-routing):
CHANGELOG Fixed entry + ADR-0026 backlinks (AC-009, closes #831)").

## Diff scope confirmation (AC-008 "no other line changed" claim)

```
$ git diff develop...HEAD --stat   # run against fix/cycle8-jsm-oauth-routing
 CHANGELOG.md                              |  12 +
 docs/adr/0006-embedded-jr-oauth-app.md    |   7 +
 docs/adr/0009-handle-open-instance-url.md |   6 +
 docs/adr/0013-pkce-deferral.md            |   5 +
 src/api/jsm/queues.rs                     |   4 +-
 src/api/jsm/request_types.rs              |   4 +-
 src/api/jsm/requests.rs                   |   3 +-
 src/api/jsm/servicedesks.rs               |   2 +-
 tests/jsm_request_api.rs                  | 449 ++++++++++++++++++++++++++++++
 9 files changed, 485 insertions(+), 7 deletions(-)
```

Exactly 6 functional swaps across the 4 source files (one per AC-001..006), confirmed by
grepping the diff for `get_from_instance`/`post_to_instance`/`.get(`/`.post(`:

```diff
-            let page: ServiceDeskPage<Queue> = self.get_from_instance(&path).await?;
+            let page: ServiceDeskPage<Queue> = self.get(&path).await?;
-            let page: ServiceDeskPage<QueueIssueKey> = self.get_from_instance(&path).await?;
+            let page: ServiceDeskPage<QueueIssueKey> = self.get(&path).await?;
-            let page: ServiceDeskPage<RequestType> = self.get_from_instance(&path).await?;
+            let page: ServiceDeskPage<RequestType> = self.get(&path).await?;
-        self.get_from_instance(&path).await
+        self.get(&path).await
-        self.post_to_instance("/rest/servicedeskapi/request", &body)
+        self.post("/rest/servicedeskapi/request", &body).await
-            let page: ServiceDeskPage<ServiceDesk> = self.get_from_instance(&path).await?;
+            let page: ServiceDeskPage<ServiceDesk> = self.get(&path).await?;
```

No other line in `servicedesks.rs`, `request_types.rs`, `queues.rs`, or `requests.rs` changed —
`get_or_fetch_project_meta`, `require_service_desk`, and `resolve_service_desk_id` (all
downstream of `list_service_desks` in `servicedesks.rs`) are byte-for-byte untouched, confirmed
by the diff above (each file's `+`/`-` line count matches exactly one swapped call site plus
its surrounding unchanged context).

## Convention Note

Pattern established by `S-577-3/INDEX.md`, reused by `S-576-5/INDEX.md` and this cycle's
sibling story `S-cycle8-assets-workspace-oauth-routing/INDEX.md`: one subdirectory per story ID
under `.factory/demos/` (committed to the `factory-artifacts` branch, per this repo's
`.gitignore` comment: "Demo evidence lives in the factory-artifacts branch (`.factory/demos/`),
not the product repo" — `docs/demo-evidence/` is gitignored in the product repo for this
reason, added in #708). An `INDEX.md` plus per-AC `.txt` capture files, each prefixed with a
caption block explaining what the test proves before the raw `cargo test` output. This story
follows that exact convention rather than introducing a new demo-evidence location, since the
fix under test has no interactive CLI surface to record.

**Deviation from generic demo-recorder instructions:** the generic demo-recorder contract calls
for output at `docs/demo-evidence/<STORY-ID>/` committed to the feature branch, with a VHS
`.tape`/`.gif`/`.webm` per AC. This repo has an explicit, established, git-enforced (via
`.gitignore`) convention that supersedes the generic default: demo evidence for internal/
routing-only fixes with no CLI surface lives on the `factory-artifacts` branch under
`.factory/demos/<STORY-ID>/` as plain-text test transcripts, not on the feature branch as VHS
recordings. A VHS `.tape`/`.txt` pair was additionally produced and left in the story worktree's
scratch area during investigation (documenting the same sandbox input-delivery failure as
`S-cycle3-percred-storage`) before this convention was confirmed via the sibling story's
same-day commit (`49050916`); it was discarded in favor of this directory, which is the
actual committed, canonical evidence location.
