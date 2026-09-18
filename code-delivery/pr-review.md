## Fresh-eyes review — F-WG-1 scope expansion (commits `2ef2cc56`, `edad1b0e`)

**Verdict: APPROVE** (posted as a plain comment; GitHub blocks self-approval and the review-action path was unavailable)

Focused review of the two new F-WG-1 commits and their interaction with the prior (already-3x-reviewed) F-WAVE-1/F-WAVE-4 base. All six requested checks pass.

### 1. `is_scope_mismatch` guard placement in `list.rs` — CORRECT
- `get_board_config` `Err(e)` arm (~L512): the `is_scope_mismatch` check runs **before** the `404` branch (~L535) and the trailing `.context("Failed to fetch config...")` wrap (~L546). A scope-mismatch 401 can no longer be misread as board-not-found.
- `list_sprints` `Err(e)` arm (~L471): the check runs **before** the `.context("Failed to list sprints...")` wrap (~L495).
- Both divert via `return Err(rewrite_agile_scope_error(e, client, ...))` — standalone, **not** wrapped in `.context()`, so `main.rs`'s top-`Display`-only `Error: {e}` render shows the granular hint. Correct.

### 2. `init.rs` unconditional `map_err` wiring — SAFE
`rewrite_agile_scope_error` (`board.rs:130-144`) no-ops correctly for the non-target cases: `!is_oauth_auth()` returns `err` verbatim; `Ok(other)` (non-`InsufficientScope` `JrError`) re-wraps unchanged; `Err(other)` (non-`JrError`) passes through. Since `init.rs`'s `list_boards` had only a bare `?` before, wrapping it is behavior-preserving for every non-scope error and only rewrites the genuine OAuth scope-mismatch. `client` is owned (`init.rs:171`), so `&client` is correct.

### 3. Scope-hint strings — EXACT MATCH, no drift
- `list.rs` `get_board_config` → `read:board-scope.admin:jira-software and read:project:jira` == `board.rs::handle_view` (L253) == `sprint.rs::resolve_scrum_board` (L90). ✓
- `list.rs` `list_sprints` → `read:sprint:jira-software, read:issue-details:jira, and read:jql:jira` == `sprint.rs` L51 == `board.rs` sprint_scope_hint (L267); the `\`-continuation collapses to the identical single-line string. ✓
- `init.rs` `list_boards` → `read:board-scope:jira-software and read:project:jira` == `board.rs::handle_list` (L49). ✓

### 4. Test coverage — ADEQUATE
- `tests/issue_list_oauth_scope.rs`: both call sites, runnable, verified **green** locally (`cargo test --test issue_list_oauth_scope` → 28 passed). Asserts granular hint substrings, `jr auth login` guidance, exit code 2, and absence of the generic #185 template + panic.
- Negative path (AC-002, non-scope errors keep their `.context()` wrap) is covered by the pre-existing `issue_list_errors.rs` tests, which would fail if the guard broke fall-through.
- `tests/init_oauth_scope.rs`: `#[ignore]`d (real keychain + TCP bind). The module doc thoroughly justifies this and notes the fix is a mechanical repeat of a 15x-proven one-liner. Acceptable — no automated CI regression for the `init.rs` line, but the risk is minimal for this pattern.

### 5. No regression to F-WAVE-1/F-WAVE-4 — CONFIRMED
The two new commits touch only `tests/{init,issue_list}_oauth_scope.rs`, `CHANGELOG.md`, `src/cli/init.rs`, `src/cli/issue/list.rs`. `client.rs`, `board.rs`, `sprint.rs` are untouched by them.

### 6. `src/error.rs` — UNTOUCHED
Confirmed absent from the full `origin/develop...HEAD` diff.

### Non-blocking observation
The explicit `client.is_oauth_auth()` in each `list.rs` guard duplicates the check inside the helper, but this is **not** redundant: unlike `board.rs`/`sprint.rs`'s unconditional wrap, `list.rs` must fall through to its 404/context branches for non-scope errors, so the guard is precisely the divert-vs-fallthrough decision. Correct as written.
