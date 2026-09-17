# S-cycle8-assets-workspace-oauth-routing Demo Evidence

Story: Assets workspace-ID discovery OAuth gateway routing — 1-site `get_from_instance` ->
`get` swap (repairs `jr assets *` under OAuth 3LO)
Branch: `fix/cycle8-assets-workspace-routing`
Head: `f69d6effdd33f60efe5f4136695c318c9751d901`
Binary: n/a (no CLI binary invocation — evidence is wiremock-backed integration test output)
Captured: 2026-09-17

## Why this is a test-evidence demo, not a live CLI demo

This story fixes an OAuth-3LO gateway-routing 401 in `get_or_fetch_workspace_id`
(`src/api/assets/workspace.rs`): the pre-fix code called `client.get_from_instance(...)`,
which routes to `instance_url` (the real `*.atlassian.net` site host); under OAuth 3LO the
site host rejects the gateway bearer token, while `base_url` (the API gateway) accepts it.
This divergence is only observable under a LIVE OAuth-authenticated Jira session, which this
project does not exercise for demo purposes (no live mutations; read-only OAuth testing is
what originally surfaced the bug, per ADR-0026). The honest, reproducible, and CI-equivalent
evidence is a captured run of the two wiremock-backed tests that directly assert the fixed
routing behavior, following the same per-story evidence convention as `S-576-5`, `S-577-*`,
etc. (one subdirectory per story ID, plain-text `cargo test -- --nocapture` captures +
this INDEX).

VHS (`/opt/homebrew/bin/vhs`) IS available in this environment, but was not used: recording a
VHS terminal session of `cargo test` output would add no information over a direct text
capture (there is no interactive CLI flow to demonstrate — the fix is entirely inside an
HTTP-routing decision that only a wiremock dual-host negative-control test can observe), and
would deviate from this repo's established demo-evidence format for test-proof stories.

## Summary

Both acceptance criteria that require live verification (AC-001, AC-002) are proven by
2 wiremock-backed integration tests in `tests/assets.rs`. The two regression-only ACs
(AC-003, AC-004) are proven by the full `tests/assets.rs` + `tests/assets_errors.rs` suite
going green (52 + 29 = 81 tests, 0 failures) with zero test-file edits beyond what AC-001/
AC-002 added. AC-005 (CHANGELOG entry) is a doc artifact, verified present in `CHANGELOG.md`
on the feature branch under `[Unreleased] > Fixed`.

## Per-AC Evidence

| AC | Demo File | Test Function(s) | Result |
|----|-----------|-------------------|--------|
| AC-001 (BC-4.2.001 fix-table row 7 — targets `base_url` under OAuth, negative control on `instance_url`) | `ac-001-oauth-gateway-routing.txt` | `test_bc_4_2_001_get_or_fetch_workspace_id_targets_base_url_under_oauth` | ok |
| AC-002 (cache-hit path issues no HTTP call) | `ac-002-cache-hit-no-http.txt` | `test_get_or_fetch_workspace_id_cache_hit_issues_no_http_call` | ok |
| AC-001 + AC-002 combined | `ac-001-ac-002-combined.txt` | both of the above, single `cargo test` invocation | ok (2 passed) |
| AC-003 (downstream Assets calls unchanged — `objects.rs`/`linked.rs`/`schemas.rs`/`tickets.rs`/`client.rs`'s `get_assets`/`post_assets` byte-for-byte unchanged) + AC-004 (all pre-existing `base_url == instance_url` wiremock tests pass unmodified — no-op for API-token profiles) | `full-suite.txt` | full `tests/assets.rs` + `tests/assets_errors.rs` suite | ok (52 + 29 passed, 0 failed) |
| AC-005 (CHANGELOG `[Unreleased] > Fixed` entry) | N/A — doc artifact | n/a | present on `fix/cycle8-assets-workspace-routing`, verified via `grep` against `CHANGELOG.md` (see below) |

## AC-005 verification (doc artifact, no test)

```
$ grep -B2 -A8 "S-cycle8-assets-workspace-oauth-routing" CHANGELOG.md
```
(run against `fix/cycle8-assets-workspace-routing`) confirms a `[Unreleased] > Fixed` entry
describing that `jr assets search/view/schemas/tickets`, `issue list --component`, and
`issue create/edit --field :asset` now work under OAuth (3LO) profiles, with no behavior
change for API-token profiles.

## Diff scope confirmation (AC-003 "byte-for-byte unchanged" claim)

```
$ git diff develop...HEAD --stat   # run against fix/cycle8-assets-workspace-routing
 CHANGELOG.md                |  14 ++++
 src/api/assets/workspace.rs |   2 +-
 tests/assets.rs             | 157 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 172 insertions(+), 1 deletion(-)
```

`src/api/assets/objects.rs`, `linked.rs`, `schemas.rs`, `tickets.rs`, and `client.rs` do not
appear in the diff at all — zero lines changed, confirming they were already gateway-correct
per F1 §1 item 2 / §2.3. The only functional line changed in `workspace.rs` is the single
`get_from_instance(...)` -> `get(...)` call-site swap (AC-001); everything else in the
function (path string, response deserialization, cache read/write logic) is untouched:

```diff
-    let page: ServiceDeskPage<WorkspaceEntry> = client
-        .get_from_instance("/rest/servicedeskapi/assets/workspace")
+    let page: ServiceDeskPage<WorkspaceEntry> = client
+        .get("/rest/servicedeskapi/assets/workspace")
```

## Convention Note

Pattern established by `S-577-3/INDEX.md` and reused by `S-576-5/INDEX.md`: one subdirectory
per story ID under `.factory/demos/` (committed to the `factory-artifacts` branch, per this
repo's `.gitignore` comment: "Demo evidence lives in the factory-artifacts branch
(`.factory/demos/`), not the product repo" — `docs/demo-evidence/` is gitignored in the
product repo for this reason). An `INDEX.md` plus per-AC `.txt` capture files, each prefixed
with a caption block explaining what the test proves before the raw `cargo test` output. This
story follows that exact convention rather than introducing a new demo-evidence location,
since the fix under test has no interactive CLI surface to record.

**Deviation from generic demo-recorder instructions:** the generic demo-recorder contract
calls for output at `docs/demo-evidence/<STORY-ID>/` committed to the feature branch. This
repo has an explicit, established, and git-enforced (via `.gitignore` + a branch-guard hook
on `.factory/`) convention that supersedes the generic default: demo evidence lives on the
`factory-artifacts` branch under `.factory/demos/<STORY-ID>/`, not on the feature branch.
Attempting to write demo evidence into a story worktree's `.factory/` directory is actively
blocked by a `factory-branch-guard` hook (`.factory/` there is not mounted as a worktree on
`factory-artifacts`); the correct target is the root checkout's `.factory/` directory, which
*is* mounted as a `factory-artifacts` worktree (see `git worktree list`).
