# PR #848 Review — MAINT-20260919-01

**Repo:** Zious11/jira-cli
**Branch:** `docs/maint-20260919-claude-md-accuracy` → `develop`
**Type:** Documentation-only maintenance (no `src/` changes, no behavior change, no test changes)
**Files touched:** `CLAUDE.md`, `docs/specs/oauth-scopes-configurable.md`

## Verdict: APPROVE

Every technical claim in the new/changed text was verified against the actual source at the PR head (not just the PR summary). All accurate, consistent, and citations resolve. No inline comments required.

## Verification detail

### 1. LOC bump — `cli/auth/tests/mod.rs` → ~2,570
`wc -l src/cli/auth/tests/mod.rs` = **2570** exactly. Growth attribution to `5f718d13` (OAuth scope expansion + pinning-test rewrite) is plausible. ACCURATE.

### 2. saphyr-parser `=0.0.11` → `=0.0.12`
PR-head `Cargo.toml:86` shows `saphyr-parser = "=0.0.12"`. Cited commit `ba522b2d` (#841, "chore(deps): bump saphyr-parser from 0.0.11 to 0.0.12") is real and confirmed an ancestor of the PR head. Citation ACCURATE. (Local `develop` snapshot was behind at 0.0.11 — not a PR defect.)

### 3. ADR-0026 OAuth 3LO gateway-routing bullet (new)
- ADR file exists: `.factory/specs/architecture/decisions/ADR-0026-oauth-3lo-gateway-routing-invariant-and-granular-jira-software-scopes.md`.
- All 7 named call sites exist: `list_service_desks`, `list_request_types`, `get_request_type_fields`, `list_queues`, `get_queue_issue_keys`, `create_jsm_request`, `get_or_fetch_workspace_id`.
- `grep` for `get_from_instance`/`post_to_instance` across `src/api/jsm/` + `src/api/assets/` returns **NONE** — confirming the call sites now use `get`/`post` as claimed.
- "Invisible under wiremock" rationale confirmed: `JiraClient::new_for_test` (client.rs:147) sets `instance_url: base_url.clone()`.
- ADR-0009 independently confirms the `base_url()`=gateway / `instance_url()`=browser-facing split and even back-references ADR-0026 (bidirectional link intact).
ACCURATE.

### 4. `classify_401_body` / `rewrite_agile_scope_error` bullet (new)
- `classify_401_body` (client.rs:1540) matches "scope does not match" case-insensitively → `InsufficientScope`, else `NotAuthenticated`.
- Both post-refresh retries (client.rs:858, 920) route through it; code comments literally reference "double fault" / "F-WAVE-1: same double-fault classification fix".
- `is_insufficient_scope_error` scans the full anyhow chain via `err.chain().find_map(downcast_ref::<JrError>())`.
- Four call sites confirmed: `board.rs`, `sprint.rs`, `init.rs`, `issue/list.rs`.
- Quoted `get_board_config` hint `"read:board-scope.admin:jira-software and read:project:jira"` matches `board.rs:276` byte-for-byte.
ACCURATE.

### 5. DEFAULT_OAUTH_SCOPES = 16 scopes
`auth.rs:108-116` lists exactly 16 scopes. "8→16 in cycle-008" and the spec addendum's "4→8 then 8→16" are consistent. The spec's pinned literal really is the 4-scope classic string (`read:jira-work write:jira-work read:jira-user offline_access`), so "4-scope literal … superseded" is ACCURATE.

### 6. Citation integrity
All backtick file-path citations in the new text resolve. The `.factory/` ADR path is excluded from the CLAUDE.md dead-citation CI guard but was confirmed to exist manually.

## Consistency
New bullets fit surrounding Gotchas style. The ADR-0026 bullet is correctly placed adjacent to the existing expired-token 401 bullet, with a forward-pointer added to the latter.

## Non-blocking note (informational)
CLAUDE.md labels the second post-refresh retry "the AC-010 post-reconcile retry" while the code comment at that site (client.rs:920) labels it "F-WAVE-1". Different naming layers; the substance (both retries classify via the same function) is correct. No change required.
