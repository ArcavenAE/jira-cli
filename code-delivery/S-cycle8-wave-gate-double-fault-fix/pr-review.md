# PR Review — #836 (cycle-008 wave-gate fix)

**PR:** https://github.com/Zious11/jira-cli/pull/836
**Title:** fix(auth,board,sprint): classify post-refresh 401 double-fault as scope error + widen get_board_config hint
**Head SHA reviewed:** `edad1b0eecca5a5f8aae1d03df464c0a672d4139`
**Base:** develop
**Reviewer:** pr-reviewer (fresh-eyes, cognitive-diversity model)
**Verdict:** READY / APPROVE — no blocking findings

> Posting note: this PR is on the BC-5.42.001 PC1 merge-gate path, which parses a
> PR **comment** carrying `covered_sha`. Verdict was delivered via `gh pr comment`
> (comment URL: https://github.com/Zious11/jira-cli/pull/836#issuecomment-5724816036).
> `gh pr review --approve` was intentionally NOT used — it returns HTTP 422 on an
> own-authored PR and the gate does not read review objects. This is a deliberate,
> caller-directed deviation from the default pr-reviewer posting mechanism.

## Verdict line (machine-parseable, as posted)

```
READY: F-WAVE-1 classify_401_body + its 4 wiring sites, safe single-consume post-refresh retry-body read, unchanged refresh semantics, F-WAVE-4 combined board/sprint hint, and F-WG-1 issue-list/init scope wraps all verified correct with CI-running + keyring-gated tests; both variants exit 2, src/error.rs untouched, CI 24/24 green / covered_sha: edad1b0eecca5a5f8aae1d03df464c0a672d4139
```

## Checklist

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence (all changes relate to the fix) | PASS |
| 2 | Description accuracy (CHANGELOG/PR body match diff) | PASS |
| 3 | Test coverage (changed lines covered) | PASS |
| 4 | Demo evidence | N/A (internal error-classification fix; wiremock + unit tests are the evidence) |
| 5 | Commit quality | PASS (conventional format, scoped) |
| 6 | Diff size (~892 LOC, mostly tests + CHANGELOG) | PASS — reasonable for scope |
| 7 | Missing changes | None |
| 8 | Dependency status | N/A |

## Findings

### `classify_401_body` (src/api/client.rs) — correct
Pure, sync, no I/O. Case-insensitive `.to_ascii_lowercase().contains("scope does not match")`
→ `InsufficientScope { required_scope: None }`; otherwise `NotAuthenticated` with the
caller-supplied `not_authenticated_hint`. The parameterized hint is the load-bearing seam
that lets the post-refresh site pass the *refresh* hint while pre-refresh/parse_error pass
the *login* hint.

### All 4 wiring sites — correct
1. Pre-refresh check (~L768): short-circuits **only** on `matches!(.., InsufficientScope { .. })`,
   so a plain expired-token 401 still falls through to auto-refresh. Behavior preserved.
2. Primary post-refresh 401 handler (~L845): reads retry body, classifies with refresh hint.
3. Secondary post-refresh handler (~L913): same fix.
4. `parse_error` 401 branch (~L1049): collapsed into the shared helper with the login hint;
   semantics identical to the prior inline branch.

### Double-fault retry-body read — safe
`retry_response.bytes().await.unwrap_or_default()` — single consume, immediate return
afterward (no double-consume), graceful on read failure (empty → `NotAuthenticated`, the
safe default). Prior code never consumed the retry body; consuming it here is sound since
the response is discarded either way.

### Refresh semantics — unchanged
Single-flight coordination, single-use refresh tokens, one-attempt cap, and `invalid_grant`
handling untouched — only the terminal 401 classification changed.

### F-WAVE-4 hint widening — correct
`board.rs::handle_view` and `sprint.rs::resolve_scrum_board` both hint
`read:board-scope.admin:jira-software and read:project:jira` on a `get_board_config`
scope-mismatch 401 (oauth-scope-matrix #53). Test assertions updated accordingly.

### F-WG-1 scope expansion — correct
`issue/list.rs::handle_list` wraps `get_board_config` (admin+project hint, checked **before**
the 404 branch) and `list_sprints` (grouped `read:sprint:jira-software, read:issue-details:jira,
and read:jql:jira`), both gated on `is_oauth_auth() && InsufficientScope`, surfaced standalone
(top-level) so `main.rs`'s `Error: {e}` render shows the hint. Non-scope-mismatch failures
keep their existing `.context(...)` messages. `init.rs::handle` wraps `list_boards` with the
correct **list**-scope pair (`read:board-scope:jira-software and read:project:jira`, no
`.admin` — the right distinction from `get_board_config`).

### Invariants
- `src/error.rs` untouched (not in diff).
- Exit codes preserved: `error.rs::exit_code()` maps both `NotAuthenticated` and
  `InsufficientScope` → 2.

### Test coverage
- 7 CI-running, mutation-covered `classify_401_body` unit tests (exact-match, real Atlassian
  wire message, case-insensitivity, login-hint verbatim, refresh-hint verbatim, empty-message,
  near-miss substrings).
- `tests/issue_list_oauth_scope.rs`: 2 **runnable** (non-`#[ignore]`, `JR_BASE_URL` wiremock)
  tests asserting exit 2 + correct per-site grouped hints + absence of the generic issue-185
  template for both list call sites.
- Keyring-gated integration tests: full double-fault auto-refresh path
  (`oauth_refresh_integration.rs`) and the init `list_boards` site (`init_oauth_scope.rs`),
  with clear RED-gate reasoning for the keychain gating.
- Updated board/sprint assertions in `board_commands.rs` / `sprint_commands.rs`.

### Corroboration (not the basis of the verdict)
CI 24/24 green — CI Gate SUCCESS; Test on ubuntu/macos/windows; Clippy; Format; MSRV 1.88;
all 8 mutation shards + aggregate.

## Non-blocking notes
- The previously OBS-1-class third scope-mismatch site (`jr issue list` board path) is now
  **COVERED** by F-WG-1 — no residual.
- CHANGELOG double `### Fixed` heading: cosmetic, deferred — no functional impact.
- Micro-nit (fine as-is): the pre-refresh `classify_401_body` call constructs a
  `NotAuthenticated` hint string that is discarded on the non-scope path via the `matches!`
  guard. Trivial allocation; buys single-source classification.
