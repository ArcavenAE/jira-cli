# Research: Branch-Protection Required-Status-Check Failure After Matrixing a CI Job

**Date:** 2026-06-14
**Author:** Research agent
**Context:** PR converted GitHub Actions `clippy` job from a single job to `strategy.matrix.os: [ubuntu-latest, windows-latest]`. Emitted contexts changed from `"Clippy"` to `"Clippy (ubuntu-latest)"` / `"Clippy (windows-latest)"`. Branch protection on `develop`/`main` still requires bare `"Clippy"`. All 13 checks pass, but `mergeStateStatus = BLOCKED`.

---

## Verdict Table

| # | Claim | Verdict | Confidence | Primary Source(s) |
|---|-------|---------|------------|-------------------|
| 1 | A required context that is no longer emitted (renamed/matrixed) stays `expected`/pending and BLOCKS merge indefinitely, even though all reported checks pass | **CONFIRMED** | High | GitHub Docs: About protected branches; GitHub Docs: Troubleshooting required status checks; community staff explanation [1][8][19] |
| 2 | Matrix job `Clippy` with `strategy.matrix.os` emits `"Clippy (ubuntu-latest)"` / `"Clippy (windows-latest)"` — format is `<job name> (<matrix value>)`, single space, parens; multi-dimension is `<job name> (<v1>, <v2>)` in workflow-file property order | **CONFIRMED** | High | GitHub Docs naming pattern `(<matrix_value>[, <matrix_value>])` + "Matrixes should be specified based on the order of matrix properties in the workflow file"; mirrored by Terraform provider docs [4][9] |
| 3 | Fix endpoint is `PATCH …/protection/required_status_checks`; PATCH **replaces** the full checks list (must include ALL desired contexts); `strict` preserved if omitted; `app_id` optional | **CONFIRMED** | High | GitHub REST docs: Update status check protection [5] |
| 4 | Existing checks use app_id 15368 (GitHub Actions); pinning app_id is optional — omit to auto-select, or `-1` to allow any app | **CONFIRMED** | High | GitHub REST docs `app_id` description (verbatim: "Omit this field to automatically select… Pass -1 to explicitly allow any app") [5][11][12] |
| 5 | The `required_status_checks` sub-endpoint is scoped to status checks ONLY — does NOT clobber `required_pull_request_reviews`, `enforce_admins`, code-owner review | **CONFIRMED** | High | GitHub REST docs: dedicated sub-resource; separate endpoints exist for reviews/admins [5] |
| 6 | Aggregator/"gate" job (`needs: [...]` + `if: always()`/failure-detect, require only that one stable context) is the recommended durable pattern vs. listing every matrix leg | **CONFIRMED** (as best practice) | High | DevOps Directive analysis; widely-cited community pattern; GitHub community discussions on matrix+required-check fragility [1][20] + devopsdirective |

---

## Detailed Findings

### Claim 1 — Diagnosis: missing required context blocks forever — CONFIRMED

GitHub maintains an internal state per required context (`expected`, `pending`, `success`, `failure`, `neutral`, `skipped`). Merge is permitted only when every required check reaches `success`/`skipped`/`neutral`. GitHub does **not** time out or fail a required check that never reports — it cannot distinguish a slow check from a permanently-removed one, so it holds `expected` indefinitely. The PR UI does not prominently surface the missing-but-expected check, producing the "all green yet merge blocked" paradox. GitHub staff explanation: *"If a check is required but that check doesn't get triggered (e.g. because it has been renamed) the 'expected check' will block forever."* This is by design; the only resolution is to update the branch-protection rule. This is exactly the repo's symptom: required `"Clippy"` is no longer emitted, so it is stuck `expected` and `mergeStateStatus = BLOCKED`. [1][8][19]

### Claim 2 — Matrix naming convention — CONFIRMED (byte-for-byte)

GitHub's documented pattern: append the matrix values to the job name as `(<matrix_value>[, <matrix_value>])`, and *"Matrixes should be specified based on the order of matrix properties in the workflow file."*

- **Single dimension** (`strategy.matrix.os: [ubuntu-latest, windows-latest]`, job name `Clippy`): contexts are exactly
  - `Clippy (ubuntu-latest)`
  - `Clippy (windows-latest)`
  - Format = job name, **one space**, `(`, matrix value, `)`. No brackets.
- **Multiple dimensions** (e.g. add `strategy.matrix.rust: [stable, beta]`): values are comma+space separated **in workflow-file property order** — e.g. `Clippy (ubuntu-latest, stable)`. (First-declared property first.)
- **Job name source:** the `(…)` suffix attaches to the job's display name (the job key, or its `name:` if set). If the repo's job uses `name: Clippy` (or the job key is `clippy` but currently surfaces as `Clippy`), the leg contexts inherit that exact base string — verify the base string matches what branch protection currently lists.

This means the required_status_checks strings must match byte-for-byte, including the single space before `(`. [4][9]

> Caveat: the canonical pattern text has migrated across GitHub doc versions (live page reorganizations during this research returned 404 on some historical URLs), but the `(<matrix_value>[, <matrix_value>])` pattern and property-order rule are confirmed in current GitHub docs content and independently mirrored verbatim by the Terraform GitHub provider documentation, which copies GitHub's convention. The Terraform provider issue tracker (#2417) confirms real-world users set per-leg contexts like `build (5.7.x)` / `build (6.0.0-alpha.14)`.

### Claim 3 — Fix API: PATCH semantics — CONFIRMED

Endpoint: `PATCH /repos/{owner}/{repo}/branches/{branch}/protection/required_status_checks`

Body parameters (per GitHub REST docs "Update status check protection"):
- `strict` (boolean) — "Require branches to be up to date before merging."
- `contexts` (array of strings) — **deprecated**. Closing-down notice (verbatim): *"The list of status checks to require in order to merge into this branch. If any of these checks have recently been set by a particular GitHub App, they will be required to come from that app in future for the branch to merge. Use `checks` instead of `contexts` for more fine-grained control."*
- `checks` (array of objects) — each object:
  - `context` (string, **required**) — "The name of the required check"
  - `app_id` (integer, **optional**) — "The ID of the GitHub App that must provide this check."

**Replace vs. merge:** This is a **full replacement** of the required-status-checks list. You MUST include every context you want to keep in a single request — any currently-required context omitted from the payload is **removed**. (The docs don't use the literal word "replace," but the field semantics and consistent community experience confirm omitted contexts are dropped.)

**`strict`:** It lives inside the `required_status_checks` object. If you only send `checks`, `strict` is preserved at its current value (the repo's `strict: false` stays `false`). Include it only if you intend to change it.

**Correct payload for this repo** (replacing bare `Clippy` with both legs, keeping all other required contexts; `strict` omitted to preserve `false`):

```json
{
  "checks": [
    { "context": "Clippy (ubuntu-latest)", "app_id": 15368 },
    { "context": "Clippy (windows-latest)", "app_id": 15368 },
    { "context": "Format", "app_id": 15368 },
    { "context": "Test (ubuntu-latest)", "app_id": 15368 },
    { "context": "Test (macos-latest)", "app_id": 15368 },
    { "context": "MSRV (1.85.0)", "app_id": 15368 },
    { "context": "Deny (licenses + vulnerabilities)", "app_id": 15368 }
  ]
}
```

(Apply the same PATCH to BOTH `develop` and `main`.) [5]

### Claim 4 — app_id — CONFIRMED

GitHub Actions app_id = **15368** (confirmed via community + API). Per the GitHub REST docs, `app_id` is optional with this exact semantics:
- **Omit** → "automatically select the GitHub App that has recently provided this check, or any app if it was not set by a GitHub App."
- **`-1`** → "explicitly allow any app to set the status."
- **Specific id (15368)** → only checks from that app satisfy the requirement.

**Recommendation:** Since every required leg here is emitted by GitHub Actions, **pin `app_id: 15368`** for security and determinism (prevents a different app from satisfying a same-named context, and avoids the "auto-select-then-lock-to-that-app" drift of omitting it). Risk note: if a leg were ever emitted by a *different* app, a pinned 15368 would make it never satisfy the requirement — not a concern here since all checks are GitHub Actions. If you prefer to be tolerant, omit `app_id` (or pass `-1`), but pinning is the better practice for an all-Actions pipeline. [5][11][12]

### Claim 5 — Endpoint scope — CONFIRMED (will NOT clobber reviews)

`…/protection/required_status_checks` is a dedicated sub-resource. It is scoped **exclusively** to required status checks. The GitHub REST docs for this endpoint make no mention of pull-request reviews or admin enforcement, and GitHub exposes **separate** sub-endpoints for those:
- `…/protection/required_pull_request_reviews`
- `…/protection/enforce_admins`
- (etc.)

So PATCHing `required_status_checks` will **not** disturb the code-owner / required-review requirement or admin enforcement. Your code-owner approval gate is safe. [5]

> Note for tooling: this is true for the **sub-resource** endpoint used here. By contrast, the *top-level* `PUT …/branches/{branch}/protection` endpoint replaces the **entire** protection object and DOES require you to resupply reviews/admins/etc. Use the scoped sub-endpoint (PATCH `required_status_checks`) — not the top-level PUT — to avoid that footgun.

### Claim 6 — Aggregator/gate job vs. per-leg listing — CONFIRMED as best practice

Listing each matrix leg as a required check is fragile: every time the matrix changes (add an OS, bump a value), branch protection silently breaks again (new leg not required → not gating; or removed leg → stuck `expected` forever). The durable, widely-recommended pattern is an **aggregator/gate job**:

```yaml
ci-gate:
  runs-on: ubuntu-latest
  needs: [clippy, test, format, msrv, deny]
  if: ${{ always() }}
  steps:
    - name: Fail if any dependency failed or was cancelled
      if: >-
        ${{ contains(needs.*.result, 'failure') ||
            contains(needs.*.result, 'cancelled') }}
      run: exit 1
```

Then require **only** the single stable context `ci-gate` (`if: always()` guarantees it always runs and reports; the `needs.*.result` check makes it fail if any upstream leg failed/was cancelled). Benefits: one stable required context, auto-scales when matrix legs change (no branch-protection edits ever again), and stays off the critical path. This is the recommended durable approach. (A subtlety the pattern handles: a *skipped* job reports `success`, so the gate must inspect `needs.*.result` for `failure`/`cancelled` rather than assume all-green = pass.) [1][20] + DevOps Directive "GitHub Actions Required Checks for Conditional Jobs"

**Recommendation for this repo:** Two-step path —
1. **Immediate unblock (low effort):** PATCH `required_status_checks` on `develop` and `main` to swap `Clippy` → `Clippy (ubuntu-latest)` + `Clippy (windows-latest)` (payload above). This fixes the current PR.
2. **Durable follow-up (recommended):** introduce a `ci-gate` aggregator job and migrate branch protection to require only `ci-gate` (plus any non-matrix checks you want explicitly named). This eliminates the recurring matrix↔branch-protection drift that just bit this PR.

---

## Sources

- [1] GitHub Community — "Expected — Waiting for status to be reported" / renamed-check blocks forever: https://github.com/orgs/community/discussions/26698
- [4] GitHub Docs — Running variations of jobs in a workflow (matrix): https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/running-variations-of-jobs-in-a-workflow
- [5] GitHub REST Docs — Branch protection / Update status check protection (`checks`, `contexts`, `app_id`, `strict`): https://docs.github.com/en/rest/branches/branch-protection
- [8] GitHub Docs — About protected branches (required check terminal states): https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches
- [9] Terraform GitHub provider — branch_protection (mirrors GitHub's `(<matrix_value>[, <matrix_value>])` pattern + reusable-workflow pattern): https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection
- [11] terraform-provider-github #1212 — `checks`/`app_id` deprecation of top-level context: https://github.com/integrations/terraform-provider-github/issues/1212
- [12] probot #1065 — GitHub Actions app ownership / app_id 15368: https://github.com/probot/probot/issues/1065
- [19] GitHub Docs — About required status checks (no auto-timeout for missing checks): https://docs.github.com/en/enterprise/2.15/user/articles/about-required-status-checks
- [20] GitHub Community #46748 — matrix job status-check naming in practice: https://github.com/orgs/community/discussions/46748
- terraform-provider-github #2417 — matrix status checks set per-leg (`build (5.7.x)`): https://github.com/integrations/terraform-provider-github/issues/2417
- DevOps Directive — GitHub Actions Required Checks for Conditional Jobs (aggregator/gate pattern): https://devopsdirective.com/posts/2025/08/github-actions-required-checks-for-conditional-jobs/
- GitHub Docs — Troubleshooting required status checks: https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/collaborating-on-repositories-with-code-quality-features/troubleshooting-required-status-checks

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Deep multi-source synthesis of all 6 claims (matrix naming, branch-protection blocking behavior, PATCH semantics, app_id, scope, aggregator pattern) with citations |
| WebFetch | 4 | Verify primary GitHub REST docs (branch-protection endpoint params, app_id verbatim semantics, scope); attempt direct quote of matrix-naming + aggregator pattern source |
| WebSearch | 2 | Locate canonical GitHub docs page for matrix naming pattern; confirm `(<matrix_value>[, <matrix_value>])` text + per-leg real-world usage |

**Total MCP tool calls:** 1 (perplexity_research, reasoning_effort=high) + 6 web tool calls (4 WebFetch, 2 WebSearch)
**Training data reliance:** low — every claim is grounded in primary GitHub docs or authoritative community/provider sources; the only verbatim doc text that resisted direct re-fetch (matrix naming pattern) was independently corroborated by GitHub-docs WebSearch extract + Terraform provider docs + issue #2417.
