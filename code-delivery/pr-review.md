## Independent fresh-eyes review — PR #836 (cycle-008 double-fault + agile scope-error mapping)

**Verdict: READY / APPROVE — no blocking issues.**
**covered_sha: `edad1b0eecca5a5f8aae1d03df464c0a672d4139`** (verified == PR HEAD `headRefOid` at assessment time).

Full-diff review at current HEAD covering all three change sets: F-WAVE-1 (double-fault 401 classification), F-WAVE-4 (`get_board_config` hint consistency), F-WG-1 (OAuth agile scope-error wiring into `issue/list.rs` + `init.rs`).

### F-WAVE-1 — double-fault 401 classification (`src/api/client.rs`)
- `classify_401_body(message, not_authenticated_hint)` extracted as a **pure, sync, no-I/O** helper — the single decision point turning a 401 body into `InsufficientScope` (on case-insensitive `"scope does not match"`) vs `NotAuthenticated` (caller-supplied hint). Correct.
- Wired into all 4 sites: pre-refresh 401, the two post-refresh retry-401 handlers, and `parse_error`. The two post-refresh handlers are the real bug fix — previously they hardcoded `NotAuthenticated` **without reading the retry body**; now they read `retry_response.bytes().await` and classify, so a refreshed-but-under-scoped token ("double fault") surfaces as `InsufficientScope` rather than a misleading "run `jr auth refresh`" hint (refresh cannot add scopes). No use-after-move — `retry_response` is consumed in the immediate `return`.
- Test coverage is strong and mutation-hardened: exact-match, real wire message (`contains` not `==`), case-insensitivity, verbatim hint parameterization for both production hints, empty-message, and near-miss substrings (`"scope does not"`, `"does not match"`, `"scope mismatch"`). These close the mutation-coverage gap the impl-only commit left.

### F-WAVE-4 — `get_board_config` hint consistency (`board.rs`, `sprint.rs`)
- `handle_view` and `resolve_scrum_board` hints widened from `read:board-scope.admin:jira-software` to `read:board-scope.admin:jira-software and read:project:jira`, matching each other and the F-WG-1 `list.rs` site. Integration tests updated accordingly. No drift.

### F-WG-1 — agile scope-error wiring (`issue/list.rs`, `init.rs`)
- `list.rs` `get_board_config` Err arm: `is_scope_mismatch` guard (`is_oauth_auth() && InsufficientScope`) checked **before** the 404 branch and the `.context()` wrap; diverts via standalone `return Err(rewrite_agile_scope_error(...))` so `main.rs`'s top-`Display` render shows the hint. Non-scope errors fall through unchanged.
- `list.rs` `list_sprints` Err arm: same guard before the `.context()` wrap; grouped sprint-scope hint matching the `sprint.rs` sibling.
- `init.rs` `list_boards`: unconditional `map_err(rewrite_agile_scope_error)` is safe — the helper no-ops for non-OAuth and passes through non-`InsufficientScope` errors; `init.rs` had only `?` before, so behavior is preserved for all non-scope errors.
- All three reused hint strings match their `board.rs`/`sprint.rs` siblings exactly — no typos, no drift.

### OBS-1 status — RESOLVED by this PR
The prior self-reviews flagged the third `get_board_config` call site (in `issue/list.rs`) as not covered by the F-WAVE-4 hint sweep. F-WG-1 (`edad1b0e`) wires exactly that site with the identical combined hint, so OBS-1 is **closed by this PR**, not deferred.

### Non-blocking notes
- Cosmetic duplicate `### Fixed` CHANGELOG header — cosmetic only, non-blocking (known).
- The explicit `is_oauth_auth()` in each `list.rs` guard is **not** redundant with the helper's internal check: unlike `board.rs`'s unconditional wrap, `list.rs` must fall through to its 404/context branches for non-scope errors, so the guard is the correct divert-vs-fallthrough decision.

### Checks
- `tests/issue_list_oauth_scope.rs` verified GREEN locally (28 passed). `init_oauth_scope.rs` justifiably `#[ignore]`d (real keychain + TCP). CI Gate reported green. `src/error.rs` untouched.
