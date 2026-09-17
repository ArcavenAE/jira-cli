# S-cycle8-agile-scope-mismatch-error-mapping Demo Evidence

Story: `jr board`/`jr sprint` 401 call-site rewrite: disambiguate scope-mismatch
vs expired-token vs wrong-host (BC-X.15.001, v1.2, cycle-008 F4 Wave 1)
Branch: `fix/cycle8-agile-scope-error-mapping`
Head: `6262f07bc153052c6e0250792af1a88e909c4bc1`
Binary: n/a (no CLI binary invocation — evidence is wiremock-backed integration/unit tests)
Captured: 2026-09-17

## Why this is a test-evidence demo, not a live CLI demo

This story's behavior is only observable on a real OAuth 401 with a granular
scope mismatch — reproducing that live would require an actual under-scoped
OAuth grant against a real Jira Cloud site, which this project's policy
prohibits for demo purposes (no live mutations/OAuth flows without explicit
approval). The honest, reproducible, CI-equivalent evidence is the story's own
wiremock-backed test suite, which mounts each 401 body shape directly and
asserts the exact stderr hint text — the same convention used by this cycle's
siblings `S-cycle8-jsm-servicedeskapi-oauth-routing`,
`S-cycle8-assets-workspace-oauth-routing`, and
`S-cycle8-agile-oauth-scope-gap` (one subdirectory per story ID, plain-text
`cargo test -- --nocapture` captures + this INDEX).

VHS (`/opt/homebrew/bin/vhs`) is available in this environment but was not
attempted: this cycle's sibling stories already documented, same day, that VHS
launches cleanly here but produces only a blank recording (no keystroke ever
reaches the terminal — a known sandbox input-delivery failure). That finding
is moot for this story regardless — there is no interactive CLI flow to
demonstrate; the change is a 401-response-handling branch inside command
handlers, observable only via test assertions on stderr content, not a
terminal session a human would watch.

## Summary

All 12 acceptance criteria are covered:

- **AC-001** (genuine scope-mismatch rewrite, the 4 originally-named command
  families: `board list`, `board view`, `sprint list`/`current`, `sprint
  add`/`remove`) — 5 individual test captures, one per command-family variant.
- **AC-002** (expired-token fall-through, no rewrite) — captured for both
  `board` and `sprint`, run with `JR_RUN_KEYRING_TESTS=1` since both tests are
  gated behind the repo's keyring-test seam (no real OS keychain is touched by
  either test; the gate only affects an unrelated shared-harness code path).
- **AC-003** (wrong-host regression-guard) — documentation-only clause per the
  story; no test exists because no wrong-host-401 branch exists at these call
  sites (`jr board`/`jr sprint` were never among ADR-0026 Decision 1's routing
  call sites). No demo file — nothing to run.
- **AC-004** (Basic/API-token short-circuit) — captured for both `board` and
  `sprint`, proving the OLD generic `InsufficientScope` (#185) path still fires
  unchanged under Basic auth.
- **AC-005** (composite-body precedence, EC-X.15.001-1) — scope-mismatch wins
  over a co-occurring expired-token substring.
- **AC-006** (unrecognized-body fall-through, EC-X.15.001-3) — neither
  substring present, rewrite does not fire.
- **AC-007** (regression guard on `src/error.rs`/`client.rs`/BC-3.8.015) —
  captured via the pre-existing JSM OAuth-scope tests (unmodified, still
  green) plus a direct `git diff`/`git log` confirming zero lines changed in
  `src/error.rs` and `src/api/client.rs` across this story's commit range.
- **AC-008** (CHANGELOG entry) — doc artifact, verified present below.
- **AC-009** (`resolve_board_id`'s internal `list_boards` call, shared by
  `board view` auto-discovery and `sprint list` transitively) — 2 tests, one
  per reaching command.
- **AC-010** (`board view`'s unconditional `get_board_config` call) — same
  transcript as AC-001's `board view` test (one test proves both).
- **AC-011** (`board view`'s scrum-branch `list_sprints`/`get_sprint_issues`
  calls) — 2 tests, one per call, in a single combined transcript.
- **AC-012(a)/(b)** (`sprint.rs`'s `resolve_scrum_board` `get_board_config`
  call and `SprintCommand::Add{current:true}`'s separate `list_sprints` call)
  — 2 tests, distinct hints confirmed for the same command invocation's two
  sequential calls.

Plus the **F2 pass-through unit tests** (inline in `src/cli/board.rs`) proving
the shared `rewrite_agile_scope_error` helper leaves any non-target error
completely untouched, and a **full regression pass** of both
`tests/board_commands.rs` and `tests/sprint_commands.rs` (Task 7) plus the
complete `cargo test --lib` suite (Task 10) as the broader safety net.

## Per-AC Evidence

| AC | Demo File | Test Function(s) | Result |
|----|-----------|-------------------|--------|
| AC-001 (`jr board list`) | `AC-001-board-list-scope-hint.txt` | `test_bc_x_15_001_board_list_401_scope_mismatch_names_missing_scopes` | ok |
| AC-001 (`jr board view`) + AC-010 | `AC-001-AC-010-board-view-scope-hint.txt` | `test_bc_x_15_001_board_view_401_scope_mismatch_names_admin_scope` | ok |
| AC-001 (`jr sprint list`) | `AC-001-sprint-list-scope-hint.txt` | `test_bc_x_15_001_sprint_list_401_scope_mismatch_names_missing_scopes` | ok |
| AC-001 (`jr sprint remove`) | `AC-001-sprint-remove-scope-hint.txt` | `test_bc_x_15_001_sprint_remove_401_scope_mismatch_names_missing_scope` | ok |
| AC-001 (`jr sprint add`) | `AC-001-sprint-add-scope-hint.txt` | `test_bc_x_15_001_sprint_add_401_scope_mismatch_names_missing_scope` | ok |
| AC-002 (expired-token fall-through, board + sprint) | `AC-002-expired-token-fallthrough-board-and-sprint.txt` | `test_bc_x_15_001_board_401_without_scope_substring_falls_through_to_refresh`, `test_bc_x_15_001_sprint_401_without_scope_substring_falls_through_to_refresh` | ok (both) |
| AC-003 (wrong-host regression-guard) | N/A — documentation-only, no branch exists to test | n/a | confirmed by code audit (story text), no test file |
| AC-004 (Basic-auth short-circuit, board + sprint) | `AC-004-basic-auth-guard-board-and-sprint.txt` | `test_bc_x_15_001_board_401_under_api_token_unaffected`, `test_bc_x_15_001_sprint_401_under_api_token_unaffected` | ok (both) |
| AC-005 (composite-body precedence) | `AC-005-composite-body-precedence.txt` | `test_bc_x_15_001_board_401_composite_body_scope_mismatch_wins` | ok |
| AC-006 (unrecognized-body fall-through) | `AC-006-unrecognized-body-fallthrough.txt` | `test_bc_x_15_001_board_401_unrecognized_body_falls_through_unchanged` | ok |
| AC-007 (regression guard: `InsufficientScope`/BC-3.8.015 unchanged) | `AC-007-jsm-create-and-require-service-desk-unchanged.txt` | `test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint`, `test_jsm_create_basic_auth_scope_mismatch_401_rewrites_to_api_token_hint`, `test_require_service_desk_oauth_401_surfaces_read_scope_hint` + `git diff`/`git log` on `src/error.rs`/`src/api/client.rs` | ok (all 3) + confirmed zero-diff |
| AC-008 (CHANGELOG entry) | N/A — doc artifact | n/a | present, see verification below |
| AC-009 (`resolve_board_id` shared `list_boards` call, board + sprint reach) | `AC-009-resolve-board-id-both-commands.txt` | `test_bc_x_15_001_resolve_board_id_401_scope_mismatch_rewrite`, `test_bc_x_15_001_sprint_resolve_board_id_401_scope_mismatch_rewrite` | ok (both) |
| AC-011 (`board view` scrum branch: `list_sprints` + `get_sprint_issues`) | `AC-011-board-view-scrum-branch.txt` | `test_bc_x_15_001_board_view_scrum_list_sprints_401_scope_mismatch_rewrite`, `test_bc_x_15_001_board_view_scrum_get_sprint_issues_401_scope_mismatch_rewrite` | ok (both) |
| AC-012(a) (`resolve_scrum_board`'s `get_board_config`) | `AC-012a-resolve-scrum-board-get-board-config.txt` | `test_bc_x_15_001_resolve_scrum_board_get_board_config_401_scope_mismatch_rewrite` | ok |
| AC-012(b) (`sprint add --current`'s second, separate `list_sprints` call) | `AC-012b-sprint-add-current-list-sprints.txt` | `test_bc_x_15_001_sprint_add_current_list_sprints_401_scope_mismatch_rewrite` | ok |
| F2 (pass-through unit tests — helper touches only its target error) | `F2-passthrough-unit-tests.txt` | `test_rewrite_agile_scope_error_passes_through_non_insufficient_scope_jrerror_unchanged`, `test_rewrite_agile_scope_error_passes_through_non_jrerror_unchanged` | ok (both) |
| Full regression (Task 7: `board_commands.rs`) | `full-suite-board-commands.txt` | full suite | ok (49 passed, 1 ignored — the AC-002 keyring-gated test, captured separately above with the seam enabled) |
| Full regression (Task 7: `sprint_commands.rs`) | `full-suite-sprint-commands.txt` | full suite | ok (46 passed, 1 ignored — same AC-002 pattern) |
| Full regression safety net (Task 10: `cargo test --lib`) | `full-suite-lib-tail.txt` (tail of full run) | full unit-test suite | ok (1489 passed, 0 failed, 48 ignored — same ignored count as this cycle's other stories captured the same day) |

## AC-008 verification (CHANGELOG doc artifact, no test)

```
$ grep -B2 -A12 "cycle8-agile-scope-mismatch-error-mapping\|jr board.*jr sprint.*scope" CHANGELOG.md
```
(run against `fix/cycle8-agile-scope-error-mapping`) confirms a
`[Unreleased] > Fixed` entry describing: `jr board`/`jr sprint` now surface an
actionable, scope-specific hint on an OAuth granular-scope-mismatch 401
instead of the generic POST-framed `InsufficientScope` message; no change to
Basic-auth (API-token) error behavior or to any other command family's 401
handling.

## Diff-scope confirmation (AC-007 "zero change to error.rs/client.rs" claim)

```
$ git diff a0fffb16^..HEAD -- src/error.rs src/api/client.rs
(no output)

$ git log --oneline a0fffb16^..HEAD -- src/error.rs src/api/client.rs
(no output)
```
Both commands against `fix/cycle8-agile-scope-error-mapping` (head
`6262f07b`) confirm neither file was touched by any commit in this story's
range — the full transcript is embedded in
`AC-007-jsm-create-and-require-service-desk-unchanged.txt`.

## Diff scope of this story (for reviewer context)

```
$ git diff --stat a0fffb16^..HEAD
 CHANGELOG.md             |  26 ++
 src/cli/board.rs         | 140 +++++++++-
 src/cli/sprint.rs        |  51 +++-
 tests/board_commands.rs  | 663 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/sprint_commands.rs | 601 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 1469 insertions(+), 12 deletions(-)
```

## Security note

Every transcript in this directory was grepped before commit for:
`ATATT`, `eyJ`, `-----BEGIN`, `refresh_token`, `client_secret`,
`Bearer [A-Za-z0-9._-]{20,}`, `[a-z0-9-]+\.atlassian\.net`, and email
addresses. Zero matches. All test fixtures use synthetic wiremock credentials
(`Bearer test-oauth-access-token`-style tokens, `127.0.0.1` mock hosts) —
none of that appears in the captured stderr hint text itself, since the
assertions only inspect the rewritten error message, not raw request/response
bodies.
