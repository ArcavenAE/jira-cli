# PR Review — PR #832 (S-cycle8-assets-workspace-oauth-routing)

- **PR:** https://github.com/Zious11/jira-cli/pull/832
- **Branch:** `fix/cycle8-assets-workspace-routing` → `develop`
- **Reviewer:** pr-reviewer (fresh-eyes, diff + description + test evidence only)
- **Date:** 2026-09-17
- **Verdict:** **APPROVE** — 0 blocking, 2 non-blocking (suggestion), 1 nit
- **Posted reviews (both formal reviews — `gh pr comment` was never used):**
  1. https://github.com/Zious11/jira-cli/pull/832#pullrequestreview-5241799242 — review id
     `5241799242`, submitted 21:47:36Z via `POST repos/Zious11/jira-cli/pulls/832/reviews`
     (the endpoint `gh pr review` wraps). Carries the full analysis + 2 inline comments at
     `CHANGELOG.md:19` and `tests/assets.rs:1837`.
  2. https://github.com/Zious11/jira-cli/pull/832#pullrequestreview-5241849797 — review id
     `5241849797`, submitted 21:55:23Z via
     `gh pr review 832 --comment --body-file .../pr-review-verdict.md` (exit 0). Carries the
     verdict + findings table.

## Posting note — formal APPROVE state is blocked twice over

A review in `APPROVED` state could not be produced from this account. Two independent blocks:

1. **GitHub API:** `event: "APPROVE"` is rejected with

   ```
   422 Unprocessable Entity
   "Review Can not approve your own pull request"
   ```

   The PR author and the authenticated `gh` account are the same identity (`Zious11`).

2. **Claude Code permission system:** running
   `gh pr review 832 --approve --body-file .../pr-review-verdict.md` was denied with reason
   `[Self-Approval]` — the command never executed.

Because block 2 is a denial in the reviewing session, the command was NOT re-routed through
`github-ops` (that would be routing a denied action through a peer); `github-ops` was told to
stand down. The verdict was NOT flipped to `--request-changes` to force a gate pass, because
the findings are genuinely non-blocking and that would misrepresent the review.

Both reviews therefore carry state `COMMENTED` with the APPROVE verdict stated in the body.
This is an account-identity constraint, not a review outcome, and it is **structural** — the
factory authors and reviews under one GitHub identity, so every PR in this repo will hit it.

Resolution requires one of:
- a second GitHub account/bot posting the formal APPROVE (body ready at
  `.factory/code-delivery/S-cycle8-assets-workspace-oauth-routing/pr-review-verdict.md`), or
- a `validate-pr-review-posted` hook exception for self-authored PRs, treating a `COMMENTED`
  review whose body states the verdict as the gate artifact.

## Scope reviewed

3 files, +172 / −1:

| File | Change |
|------|--------|
| `src/api/assets/workspace.rs` | +1 / −1 — `client.get_from_instance(...)` → `client.get(...)` |
| `tests/assets.rs` | +157 — 2 new tests (AC-001 dual-mock routing, AC-002 cache-hit no-HTTP) |
| `CHANGELOG.md` | +14 — `[Unreleased] > Fixed` entry |

## Verification performed (independent, not taken from the PR description)

1. **No side effect on cache logic or error mapping.** `JiraClient::get` (`src/api/client.rs:284`)
   and `get_from_instance` (`:1071`) are structurally identical apart from which host field is
   interpolated — both call the same `self.send(request)` (same `Authorization` header, same
   429/Retry-After handling, same 401 auto-refresh guard), the same `collect_response_body`, and
   the same `serde_json::from_slice`. In `get_or_fetch_workspace_id` the `map_err` 404/403 →
   `JrError::UserError` branch, the empty-`values` `ok_or_else`, and both
   `read_workspace_cache`/`write_workspace_cache` calls are untouched lines. Claim CONFIRMED.
2. **API-token no-op claim holds.** `Config::base_url()` (`src/config.rs:393`) returns the
   gateway form only when `cloud_id.is_some() && auth_method == "oauth"`; otherwise it returns
   `profile.url.trim_end_matches('/')` — exactly what `JiraClient::from_config` assigns to
   `instance_url`. Also a no-op for an OAuth profile lacking `cloud_id`. Under the `JR_BASE_URL`
   test override both fields receive the override, which is why every pre-existing wiremock test
   is unaffected. Claim CONFIRMED.
3. **Red gate reproduced locally.** Line 26 was temporarily reverted to `get_from_instance` and
   the suite re-run: `test_bc_4_2_001_get_or_fetch_workspace_id_targets_base_url_under_oauth`
   fails with `left: 0, right: 1` on the gateway-request assertion; passes on the fixed code.
   File restored immediately; `git status --porcelain` clean, nothing committed. The test is
   genuinely red-on-old-code, not tautological.
4. **Negative control is enforced, not implied.** It is an executed
   `assert!(site_requests.is_empty())` against wiremock's request log, not a `Mock::expect(0)`.
   The dual-mock construction is what makes the test non-tautological — an identical mock on
   both hosts means a wrongly-routed call still returns 200 with the correct workspace id, so
   the only way to pass is to actually observe routing. The `assert_ne!(base_url, instance_url)`
   pre-assert guards against silent degradation to a same-host no-op.
5. **AC-002 is non-vacuous.** No mock is mounted, so a regressed HTTP call receives wiremock's
   default 404 → mapped by this function's own `map_err` to `UserError` → the `.expect()`
   panics. The seeded profile (`Profile::from("default")`) matches `new_for_test`'s
   `profile_name`, so the cache key lines up. `CacheDirGuard` holds `ENV_MUTEX` for the whole
   test, consistent with the file's established isolation pattern.
6. **Suites green locally.** `assets` 52, `assets_errors` 29, `asset_holdouts` 29 (matches the
   PR's claimed 52+29=81), plus every other suite touching
   `/rest/servicedeskapi/assets/workspace`: `issue_list_assets` 28, `cmdb_fields` 31,
   `cache_warm_hit` 31, `issue_create_field` 63, `issue_create_jsm` 113,
   `issue_field_hint_kinds` 64, `cli_handler` 83. Zero failures.
7. **External URL/scope correctness (Perplexity-validated per repo citation convention).**
   Atlassian documents `https://api.atlassian.com/ex/jira/{cloudId}/rest/servicedeskapi/...` as
   the OAuth 2.0 (3LO) form, and the Assets Workspace ID operation requires
   `read:servicedesk-request` — already present in `DEFAULT_OAUTH_SCOPES`
   (`src/api/auth.rs:83`). No scope follow-up is needed; the routing fix alone is sufficient.
8. **Scope/diff hygiene.** `objects.rs`/`linked.rs`/`schemas.rs`/`tickets.rs`/`client.rs`
   untouched as claimed; the PR body's diff-stat figures (14 / 1−1 / 157) are exact.
   `get_from_instance`/`post_to_instance` remain in use by `api/jsm/*` and `api/jira/teams.rs`,
   so the swap creates no dead-code fallout. Branch is 0 commits behind `origin/develop`, so
   CLAUDE.md's `strict: false` stale-base merge concern does not apply to this PR.

## Findings

### Finding 1 — CHANGELOG/PR body credit the wrong command

| Field | Value |
|-------|-------|
| Severity | non-blocking (suggestion) |
| Category | description / docs accuracy |
| Location | `CHANGELOG.md:19`; PR description What/Why sections |
| Finding | The user-facing entry claims the fix repairs `issue list --component`. That command never reaches this code path. All callers of `get_or_fetch_workspace_id` in `src/cli/issue/list.rs` are the `--asset` filter (~line 295 → `helpers::resolve_asset`, `helpers.rs:520`) and the `--assets` column enrichment (~line 657, `fallback_wid`). `--component` resolves through `client.list_components(pk)` in `resolve_component_clauses` (~line 899) — a plain Jira components API call with no Assets involvement. The entry therefore names a command that was never broken under OAuth and omits the two that were. |
| Suggestion | Replace `issue list --component` with `issue list --asset` / `--assets` in both the CHANGELOG entry and the PR description. One-token edit inside `[Unreleased]`; recommended before merge since the claim ships to users and is disprovable in one command. |

### Finding 2 — stale routing documentation

| Field | Value |
|-------|-------|
| Severity | non-blocking (suggestion) |
| Category | docs drift |
| Location | `docs/superpowers/specs/2026-03-24-assets-cmdb-design.md` — §"Workspace ID Discovery + Cache" step 1, and the URL-construction table's JSM row |
| Finding | The design doc still documents this exact call as `GET {instance_url}/rest/servicedeskapi/assets/workspace` … "Uses `get_from_instance()` (same pattern as JSM endpoints)", now contradicted by the code. Not covered by any CI guard — `check-bc-citation-symbols.sh` and `tests/claude_md_citations.rs` validate path/symbol existence, not routing prose — so it will rot silently. |
| Suggestion | Update the step-1 prose and the table row to the gateway form, or add a superseded-by note referencing ADR-0026 Decision 1. |

### Finding 3 — commit granularity vs. `tdd_mode: strict`

| Field | Value |
|-------|-------|
| Severity | nit |
| Category | commit quality |
| Location | commit `922881a3` |
| Finding | `922881a3` bundles the implementation, the AC-001 test, and the CHANGELOG in one commit, while the PR body labels it "impl — AC-001 swap". Under `tdd_mode: strict` the red test would normally land as its own commit, as `f69d6eff` correctly does for AC-002. |
| Suggestion | Cosmetic only — no action required. The red gate was verified manually (item 3 above), so the test genuinely is red on pre-fix code; only the commit boundary and its PR-body label are imprecise. |

## Checklist coverage

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence — all changes relate to this story | PASS |
| 2 | Description accuracy | PARTIAL — Finding 1 |
| 3 | Test coverage of changed lines | PASS — red gate independently reproduced |
| 4 | Demo evidence | NOT VERIFIABLE — lives behind the information wall; the PR documents it as captured wiremock output, the honest ceiling absent a live OAuth session |
| 5 | Commit quality — conventional format, story ID, clear messages | PASS with nit 3 |
| 6 | Diff size | PASS — 172/1, well under the 500-line flag |
| 7 | Missing changes vs. story spec | PASS |
| 8 | Dependency status | PASS — no `depends_on`; branch current with `develop` |

## Merge preconditions outstanding at review time (observed, not findings)

CI rollup showed `Test (ubuntu-latest / macos-latest / windows-latest)` and `Coverage` still
`IN_PROGRESS`. All other checks SUCCESS: Clippy (ubuntu + windows), Format, MSRV (1.88.0), Deny,
Spec Guards, Secret Scan (gitleaks), Mutation Testing shards 0–7 + Aggregate, Mutation Test Plan,
Signing Workflow Injection Guard, dependency-review. `ci-gate` must report green before merge.
