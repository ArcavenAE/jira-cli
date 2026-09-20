# PR #848 — Fresh-Eyes PR Review

**PR:** docs(maint-20260919-01): document ADR-0026 OAuth gateway-routing invariant + 401 scope reclassification, refresh stale doc refs
**Branch:** `docs/maint-20260919-claude-md-accuracy` @ 672c37f4 → `develop`
**Size:** 7 insertions / 3 deletions, 2 files (`CLAUDE.md`, `docs/specs/oauth-scopes-configurable.md`)
**Mergeable:** UNKNOWN (GitHub had not computed at review time)
**Author:** Zious11 (self-authored — formal `gh pr review --approve` is blocked by GitHub)
**Reviewer:** pr-reviewer (fresh-eyes, diff + source spot-check)

## Verdict: APPROVE

Clean, accurate, low-risk documentation-only change. Merge-ready pending explicit human go-ahead.

> Note: The PR is self-authored (author == the operator's GitHub account), so
> `gh pr review --approve` cannot be posted — GitHub blocks self-approval. The
> caller's brief also stated "you do not need to post PR comments unless you find
> actual issues worth flagging inline" (none found). This artifact records the
> verdict; the human retains manual control of the GitHub review/merge action.
> (Same abstention pattern as `S-MAINT-DOC-SWEEP-2026-09-16/pr-review.md`.)

## Findings

None. No BLOCKING, no WARNING, no NIT.

| Severity | Category | Finding | Suggestion |
|----------|----------|---------|------------|
| — | — | No issues found | — |

## What was verified (no rubber-stamping)

Every technical claim in the diff was checked against source in the branch worktree.

### New Gotchas bullet — ADR-0026 OAuth 3LO gateway-routing invariant (Decision 1)
- ADR-0026 file exists on `origin/factory-artifacts` at the exact cited filename
  (`specs/architecture/decisions/ADR-0026-oauth-3lo-gateway-routing-invariant-and-granular-jira-software-scopes.md`).
- All SEVEN call sites listed in the bullet match ADR-0026's table byte-for-byte and are
  confirmed to now call `self.get`/`self.post` (not `get_from_instance`/`post_to_instance`):
  `list_service_desks` (jsm/servicedesks.rs), `list_request_types` + `get_request_type_fields`
  (jsm/request_types.rs), `list_queues` + `get_queue_issue_keys` (jsm/queues.rs),
  `create_jsm_request` (jsm/requests.rs), `get_or_fetch_workspace_id` (assets/workspace.rs L26).
- "mirror image of ADR-0009" framing is consistent with the existing ADR-0009 Key-Decisions note.

### New Gotchas bullet — classify_401_body / rewrite_agile_scope_error
- `classify_401_body` exists in `src/api/client.rs` (fn @ ~L1540) with docstring matching the
  described contract; pre-refresh scope short-circuit (~L770-771) + two post-refresh
  classification sites (one-attempt-cap ~L858, AC-010 post-reconcile ~L920) all present.
- `rewrite_agile_scope_error`/`is_insufficient_scope_error` exist in `src/cli/board.rs`.
- Four call sites confirmed: `board.rs`, `sprint.rs`, `init.rs`, `issue/list.rs`.
- `get_board_config` hint literal `"read:board-scope.admin:jira-software and read:project:jira"`
  matches byte-for-byte (board.rs:276). Attribution to PR #836 (commit 578a7848) correct.

### Addendum to existing expired-token 401 bullet
- Cross-reference "see the next bullet" is correctly ordered (classify_401_body bullet follows)
  and non-contradictory: trigger = blanket-401; resulting variant classification = substring-matched.

### oauth-scopes-configurable.md "historical/superseded" marker
- `DEFAULT_OAUTH_SCOPES` (src/api/auth.rs:108) contains exactly 16 scopes — confirms 8→16 claim.
- ADR-0026 pointer valid (same file verified above).

### LOC bump — cli/auth/tests/mod.rs 2,484 → 2,570
- `wc -l` = exactly 2570.
- Sole intervening commit touching the file since the 2,484 baseline is `5f718d13`
  ("fix(auth): expand OAuth scopes for Agile API parity …", #834); its stat shows a 104-line
  change (net ~86). Attribution accurate.

### Bonus fix — saphyr-parser 0.0.11 → 0.0.12
- `Cargo.toml` pins `saphyr-parser = "=0.0.12"`.
- Commit `ba522b2d` ("chore(deps): bump saphyr-parser from 0.0.11 to 0.0.12", #841, 2026-09-19) confirmed.

### Citation integrity
- All backtick file paths and function symbols in new text resolve to real files/symbols.
- The `.factory/` ADR-0026 citation lives on the factory-artifacts orphan branch (not the PR
  worktree) — expected, and auto-excluded from the CLAUDE.md dead-citation CI guard
  (`tests/claude_md_citations.rs`), consistent with existing `.factory/` citations.

## Checklist coverage
1. Diff coherence — PASS (all changes are doc reconciliation, on-topic).
2. Description accuracy — PASS (PR title/body match the diff).
3. Test coverage — N/A (doc-only); citation guard unaffected.
4. Demo evidence — N/A (doc-only maintenance PR).
5. Commit quality — `docs:` conventional prefix, appropriate.
6. Diff size — PASS (10 lines total, well under 500).
7. Missing changes — none detected.
8. Dependency status — none (no upstream PRs).
