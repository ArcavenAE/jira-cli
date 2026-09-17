## Review verdict: APPROVE — 0 blocking, 2 non-blocking (suggestion), 1 nit

Formal verdict for PR #832 (S-cycle8-assets-workspace-oauth-routing). The full review, with the
verification log and two inline comments, is posted at
https://github.com/Zious11/jira-cli/pull/832#pullrequestreview-5241799242 — this entry records
the verdict itself.

**Note:** GitHub rejects a formal `APPROVE` event from this account with
`422 Unprocessable Entity — "Review Can not approve your own pull request"`, because the PR author
and the authenticated `gh` account are the same identity. The APPROVE below is the review's
conclusion; a recorded formal approval requires a second GitHub account.

### Findings

| # | Severity | Category | Finding |
|---|---|---|---|
| 1 | non-blocking | description / docs accuracy | `CHANGELOG.md:19` and the PR body credit the fix to `issue list --component`, which never reaches this code path (it resolves via `client.list_components` in `resolve_component_clauses`). The affected list surfaces are `--asset` (`helpers::resolve_asset`) and `--assets` (enrichment `fallback_wid`). One-token edit inside `[Unreleased]` — recommended before merge. |
| 2 | non-blocking | docs drift | `docs/superpowers/specs/2026-03-24-assets-cmdb-design.md` still documents this call as `{instance_url}` + `get_from_instance()`; no CI guard covers routing prose. |
| 3 | nit | commit quality | `922881a3` bundles impl + AC-001 test + CHANGELOG while the PR body labels it impl-only; `tdd_mode: strict` would normally split the red test out. Cosmetic — red gate verified manually. |

### Why this is an approval

- `get` and `get_from_instance` differ only in which host field is interpolated — same `send()`,
  same auth header, same 429/401 handling — so the "error mapping and cache logic unchanged"
  claim holds.
- The API-token no-op claim holds via `Config::base_url()`: the gateway form is returned only for
  `cloud_id.is_some() && auth_method == "oauth"`.
- Red gate independently reproduced: reverting line 26 makes the AC-001 test fail
  `left: 0, right: 1`; the negative control is an executed assertion against wiremock's request
  log, not a `Mock::expect(0)`.
- All 10 affected test suites pass locally (assets 52, assets_errors 29, asset_holdouts 29, plus
  7 more).
- Gateway URL form and the required `read:servicedesk-request` scope externally validated; the
  scope is already in `DEFAULT_OAUTH_SCOPES`.

Merge precondition: `ci-gate` green (Test ×3 and Coverage were still in progress at review time).
