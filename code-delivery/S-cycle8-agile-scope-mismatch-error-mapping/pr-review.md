# PR #835 — Fresh-eyes Review (cycle 1)

- **PR:** https://github.com/Zious11/jira-cli/pull/835
- **Branch:** fix/cycle8-agile-scope-error-mapping → develop
- **Story:** S-cycle8-agile-scope-mismatch-error-mapping (cycle-008, BC-X.15.001 v1.1, ADR-0026 Decision 3)
- **Commits:** a0fffb16, b52d84d4, 99549d21, 6262f07b
- **Reviewer:** pr-reviewer-cycle8-s4-r1 (fresh-eyes, cycle 1)
- **VERDICT: READY_FOR_MERGE** (1 informational note, non-blocking)
- **Posting note:** Posted to GitHub via `gh pr review 835 --comment` (a real review event, NOT `gh pr comment`). Per team-lead instruction, COMMENT event used rather than `--approve`: self-approval on the same account 422s, and a fresh-eyes review should not force-approve. Verdict maps to approve pending a non-self approver.

## Scope reviewed
Full `git diff origin/develop...HEAD` (5 files: `CHANGELOG.md`, `src/cli/board.rs`, `src/cli/sprint.rs`, `tests/board_commands.rs`, `tests/sprint_commands.rs`), plus `src/error.rs` exit-code mapping and full source of both handlers to hunt for missed Agile call sites.

## Findings

### 1. `src/error.rs` byte-for-byte unchanged — CONFIRMED
`git diff origin/develop...HEAD -- src/error.rs` is empty. The shared `InsufficientScope` template (BC-1.6.042, issue #185) is only *matched on* by the new helper, never modified. Both `NotAuthenticated` and `InsufficientScope` map to exit code 2 (`src/error.rs:109-110`), so the rewrite preserves exit-code behavior. `src/cli/issue/jsm_create.rs` (BC-3.8.015 OAuth rewrite) also confirmed empty in diff.

### 2. Single shared helper, zero duplication — CONFIRMED
`rewrite_agile_scope_error` (`src/cli/board.rs`, `pub(crate)`) is the only rewrite implementation. Every Agile call site routes through it via `.map_err(...)` — ~12 wrap points total (board.rs: `resolve_board_id` list_boards, `handle_list` list_boards, `handle_view` get_board_config + scrum list_sprints + scrum get_sprint_issues; sprint.rs: add-`--current` list_sprints, `resolve_scrum_board` get_board_config, `handle_add` add_issues_to_sprint, `handle_remove` move_issues_to_backlog, `handle_list` list_sprints, `handle_current` list_sprints + get_sprint_issues). The "8 call sites" framing is a simplification (some handlers wrap two calls); no logic divergence between sites.

### 3. Precise OAuth-vs-scope matching — CONFIRMED
Helper early-returns `err` when `!client.is_oauth_auth()` (Basic/API-token no-op). Only `Ok(JrError::InsufficientScope{..})` under OAuth is rewritten; `Ok(other) => anyhow!(other)` and `Err(other) => other` pass through unchanged. The non-scope-mismatch OAuth auto-refresh fall-through is never intercepted (a 401 without the substring surfaces upstream in `send_inner` as `NotAuthenticated`, not `InsufficientScope`).

### 4. No missed Agile call sites — CONFIRMED
`board view` kanban branch (`search_issues`, board.rs:285) and count path (`approximate_count`, board.rs:351) are deliberately NOT wrapped — they hit platform JQL endpoints (`read:jql:jira`), not Agile scopes, so the Agile-scope hint would be wrong there. Correct exclusion.

### 5. Scope-hint string consistency — CONFIRMED
board list/discovery → `read:board-scope:jira-software and read:project:jira`; board config → `read:board-scope.admin:jira-software`; sprint reads → grouped `read:sprint:jira-software, read:issue-details:jira, and read:jql:jira`; writes → `write:board-scope:jira-software`. Sibling call sites calling the same endpoint use identical hints.

### 6. Test coverage — CONFIRMED
Both `tests/board_commands.rs` and `tests/sprint_commands.rs` cover top-level handlers AND internal resolution paths (AC-009..012), with negative/boundary guards: Basic-auth-unaffected, unrecognized-body fall-through, composite-body precedence, and two unit-level pass-through guards (F2/OBS-1 mutation-coverage closure). Keyring-driven auto-refresh test correctly `#[ignore]`d behind `JR_RUN_KEYRING_TESTS=1`. The OBS-1 test lands a 401 directly on `add_issues_to_sprint` to pin that specific `map_err`.

### 7. Informational (LOW, no action required)
The kanban `board view` / count platform-JQL paths still surface a generic `InsufficientScope` for a missing `read:jql:jira` scope with no actionable hint. Out of scope for this Agile-scope-mapping story and correctly excluded — flagged only as a conscious boundary, not an oversight.

## Verification run (local, in worktree)
- `cargo fmt --all -- --check` — clean
- `cargo clippy --all-targets -- -D warnings` — clean (no new `#[allow]` except the pre-existing test-only `unsafe_code` env pattern)
- `cargo test --lib` — 1489 passed, 0 failed, 48 ignored
- `cargo test --test board_commands` — 49 passed, 0 failed, 1 ignored (keyring)
- `cargo test --test sprint_commands` — 46 passed, 0 failed, 1 ignored (keyring)

## Verdict
**READY_FOR_MERGE** — correctly scoped, single-helper Agile scope-hint rewrite; error.rs invariant held; Basic-auth and auto-refresh paths provably unaffected; comprehensive tests including negative/boundary/mutation-gap guards. No change requests. Final approve must come from a non-self reviewer (self-approval 422s).
