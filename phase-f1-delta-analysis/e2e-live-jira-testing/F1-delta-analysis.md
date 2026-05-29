---
document_type: delta-analysis-report
feature_name: "Live-Jira E2E testing in CI"
created: 2026-05-29
revised: 2026-05-29
revision: v1
spec_version_at_analysis: "post-v0.5.0-dev.11 (develop @ 15bf305)"
status: draft
intent: "feature"
feature_type: "infrastructure"
scope: "non-trivial"
regression_risk: "LOW"
issue: TBD
design_spec: "docs/specs/e2e-live-jira-testing.md"
research: ".factory/research/e2e-real-jira-ci.md"
---

# F1 Delta Analysis — Live-Jira E2E Testing in CI

## 1. Feature Summary

Add a gated Rust integration test file (`tests/e2e_live.rs`) and a companion GitHub
Actions workflow (`.github/workflows/e2e.yml`) that exercise the compiled `jr` binary
against a **real Jira Cloud instance**. Today all 64 integration test files are hermetic
(wiremock / `JR_BASE_URL` mocks); nothing verifies `jr` against real API response shapes,
pagination, eventual consistency, or error bodies. This feature closes that gap with a
small, high-value, read-heavy + minimal-write suite.

**Design spec:** `docs/specs/e2e-live-jira-testing.md` (status: Draft; authored 2026-05-28)

**Research anchor:** `.factory/research/e2e-real-jira-ci.md` (primary-source-anchored;
validation pass included)

**Tracking:** GitHub issue to be filed (TBD — spec §1).

---

## 2. Impact Boundary

### Explicit claim: ZERO src/ changes required for v1

The design spec §3 states the E2E suite reuses the existing `JR_AUTH_HEADER` + `JR_BASE_URL`
debug-only seams (already gated by `#[cfg(debug_assertions)]` at both read sites:
`Config::base_url()` in `src/config.rs` and `JiraClient::from_config()` in
`src/api/client.rs`). The E2E harness points these env vars at the real site rather than
wiremock. **No new seam, no new flag, no new `src/` code is needed for v1.**

Verification of this claim:

| Seam | Gate | Used by | E2E reuse path |
|------|------|---------|---------------|
| `JR_BASE_URL` | `#[cfg(debug_assertions)]` in `src/config.rs` + `src/api/client.rs` | All 64 existing integration tests | Set to real site URL — DIRECT REUSE |
| `JR_AUTH_HEADER` | `#[cfg(debug_assertions)]` in `src/api/client.rs` | All subprocess-style integration tests | Pre-composed `Basic <base64>` from workflow secrets — DIRECT REUSE |
| `--no-input` | Unconditional CLI flag | Existing tests | Pass in `e2e_cmd()` helper — DIRECT REUSE |
| `XDG_CACHE_HOME` / `XDG_CONFIG_HOME` | `tempfile::TempDir` per test | Existing `jr_cmd_with_xdg` tests | Same pattern in E2E harness — DIRECT REUSE |

**Conclusion: zero src/ changes are required for v1. The claim is verified.**

If a future v2 extends the suite to use `reconcileIssues` in JQL searches for
read-after-write consistency, that would require a one-parameter addition to
`src/api/jira/issues.rs::search_issues` — but that is explicitly out of scope for v1
(the spec uses GET-by-key polling via `poll_view` as the consistency strategy instead).

### New Files

| File | Type | Purpose |
|------|------|---------|
| `tests/e2e_live.rs` | NEW | Gated integration test suite (requires `JR_RUN_E2E=1` + `--include-ignored`) |
| `.github/workflows/e2e.yml` | NEW | CI workflow: push to develop/main + nightly + workflow_dispatch; non-blocking; `jira-e2e` Environment |
| `docs/specs/e2e-live-jira-testing.md` | NEW (already committed) | Design spec (present on branch `feat/e2e-live-jira-testing`) |

### Modified Files

| File | Type | Change |
|------|------|--------|
| `CLAUDE.md` | MODIFIED | Add `JR_RUN_E2E` env var entry in AI Agent Notes (parallel to existing `JR_RUN_KEYRING_TESTS`, `JR_RUN_OAUTH_INTEGRATION` entries). Annual API-token rotation runbook reference. |
| `docs/specs/e2e-live-jira-testing.md` | MODIFIED | Apply 3 spec corrections from research validation pass: (1) soften "Premium-only" → "paid plan (Standard+)" for Assets; (2) label GET-by-key consistency as a "reasonable assumption, not vendor-documented"; (3) strengthen keep-warm rationale to call out the 15–60-day post-deactivation deletion window. These are low-impact textual corrections to an already-committed spec. |

### Files NOT Changed (Regression Baseline)

All existing test files (`tests/*.rs`), all source files (`src/**/*.rs`), `Cargo.toml`,
`Cargo.lock`, `deny.toml`, `.github/workflows/ci.yml`, `.github/workflows/release.yml`,
`.github/workflows/dependency-review.yml`, `.github/workflows/scorecards.yml`,
`tests/common/`, all snapshot files (`tests/snapshots/`).

This is the **complete** regression baseline — none of the 64 existing integration test
files are touched, and `ci.yml` is not modified. The new `e2e.yml` is a separate workflow
file that does not interfere with the existing CI pipeline.

---

## 3. Affected Behavioral Contracts (BC Delta)

**BC delta: EMPTY.**

This feature introduces test infrastructure and a CI workflow. It does not add, remove, or
modify any behavioral contract on the `jr` binary surface. Specifically:

- No new CLI command is added (spec §2 Non-Goals explicitly excludes `jr issue delete`).
- No existing command's behavior changes.
- No new flag, output shape, or exit code is introduced.
- The `JR_RUN_E2E` env var is a test-harness gate operative only under
  `#[cfg(debug_assertions)]`; it is not a product behavior seam.

All 583 existing BCs remain unchanged and unaffected.

**No BC-S.SS.NNN identifiers are added, modified, or retired by this feature.**

---

## 4. NFR Impact

**Proposed: one new NFR (test-quality / infrastructure tier).**

The feature closes a testing coverage gap that has no corresponding NFR in the catalog
today. A single NFR is warranted to track the obligation that the live-E2E suite remains
runnable and is exercised on push to `develop`/`main`.

| ID | Description | Severity | Routing |
|----|-------------|----------|---------|
| NFR-T-E2E-1 | Live-Jira E2E suite (`tests/e2e_live.rs`) MUST remain runnable against a real Jira Cloud site and MUST be wired into CI via `.github/workflows/e2e.yml` (non-blocking). Suite MUST NOT run without `JR_RUN_E2E=1` in normal `cargo test` (local or `ci.yml`). Annual API-token rotation MUST be documented in a runbook. | MEDIUM | **NEW — Feature Mode** |

If the team prefers to track this as a process convention rather than an NFR, omit
NFR-T-E2E-1 and note the obligation in CLAUDE.md instead. This is a judgment call for
the human approval gate.

---

## 5. Affected Stories / Tests (Regression Surface)

### Existing stories touched

**None.** No wave story or feature-followup story is modified by this feature. The new
`tests/e2e_live.rs` file is a new test file, not a modification of any existing test.

### Existing tests in the risk zone

Because no `src/` files change and no existing test files change, the risk zone is empty.
However, for completeness, two categories of existing tests merit mention:

**Category 1 — Tests that verify the seams E2E reuses**

| Test file | What it covers | Risk |
|-----------|----------------|------|
| `tests/base_url_release_gate.rs` | Verifies `JR_BASE_URL` is ignored in release builds | NONE — not touched |
| `tests/auth_header_release_gate.rs` | Verifies `JR_AUTH_HEADER` is ignored in release builds | NONE — not touched |
| `tests/oauth_embedded_login.rs` | `JR_RUN_OAUTH_INTEGRATION=1` gating pattern (model for E2E gate) | NONE — not touched |

These tests remain green by construction because the E2E feature does not modify the
seams they test — it only adds a new consumer of those seams.

**Category 2 — `ci.yml` integration**

The existing `ci.yml` runs `cargo test` without `--include-ignored` and without
`JR_RUN_E2E=1`. The new `tests/e2e_live.rs` file will be compiled by `ci.yml` (all
`tests/*.rs` files are compiled), but every test in it will be skipped (they are all
`#[ignore]`). This is verified by the design spec's gate invariant: "A normal `cargo test`
(local or in the existing `ci.yml`) never touches Jira" (spec §4).

A non-gated assertion that the suite is a no-op when the flag is unset will be part of
the story's ACs (see §7 below), explicitly preventing `ci.yml` regression.

---

## 6. Regression Risk Assessment

**Overall regression risk: LOW**

| Dimension | Assessment | Justification |
|-----------|-----------|---------------|
| src/ changes | ZERO | No production code paths change; no src/ files modified |
| Existing test changes | NONE | 64 existing test files are untouched |
| ci.yml impact | NONE | New workflow is a separate file; `ci.yml` is unmodified |
| Gate correctness | LOW | `#[ignore]` + early-return on missing `JR_RUN_E2E` (same pattern as `JR_RUN_OAUTH_INTEGRATION`) prevents any live-Jira call from a normal `cargo test` run |
| Compilation risk | VERY LOW | New test file compiled in debug builds; any compile error surfaces immediately in `cargo test` |
| Secret safety | LOW (architectural) | `jira-e2e` Environment + deployment-branch policy to `develop`/`main`; GitHub withholds secrets from fork PRs; `if: github.event_name != 'pull_request'` guard; no `pull_request_target` |
| Jira site pollution risk | VERY LOW | Dedicated `E2E` project; run-scoped `e2e-<run_id>` labels; `if: always()` close-only teardown |

**No existing passing tests can become failing tests as a result of this feature.**

The only failure modes are:
1. Compile error in `tests/e2e_live.rs` (caught by `cargo test` in `ci.yml` immediately).
2. `e2e.yml` workflow failure against live Jira (separate, non-blocking workflow).
3. Token rotation missed — nightly job fails with 401, loud signal, no impact on `ci.yml`.

---

## 7. Recommended F2 Scope

**F2 (Spec Evolution) is near-empty for this feature.**

The design spec `docs/specs/e2e-live-jira-testing.md` is already comprehensive. F2 work
consists only of:

1. **Apply the 3 spec corrections** from the research validation pass (Claim 2, 7, 8 in
   `.factory/research/e2e-real-jira-ci.md` Perplexity Validation Pass section):
   - Soften "Premium-only" → "requires a paid plan (Standard+); not on Free" in §2 Non-Goals.
   - Add one-line caveat in §4/§7 that GET-by-key consistency is a "reasonable assumption,
     not vendor-documented" — bounded-retry poll is the real guarantee.
   - Strengthen §9 keep-warm rationale: "prevents idle deactivation; note the
     post-deactivation grace window is only 15–60 days before permanent data deletion."

2. **Record NFR-T-E2E-1** in `nfr-catalog.md` (if the human approves adding it; see §4).

3. **Add `JR_RUN_E2E` entry to CLAUDE.md** AI Agent Notes (per the documented
   "When adding a new `JR_*` test-seam env var" convention in CLAUDE.md).

No BC file changes. No architecture section changes. No STORY-INDEX restructuring.

**If NFR-T-E2E-1 is approved:** add one row to `nfr-catalog.md` and update
`total_nfrs: 40` → `41` in the frontmatter. That is the full extent of F2 spec changes.

---

## 8. Recommended F3 Story Decomposition

**Recommended: ONE story.**

The implementation is cohesive (one test file + one workflow file) and the work is
small-to-medium. Splitting into "test suite" vs "workflow" stories would create unnecessary
cross-story dependencies (the workflow runs the test suite). A single story is cleanest.

### Story S-E2E-1 — Live-Jira E2E test suite + CI workflow

**Proposed Story ID:** `S-E2E-1` (or the next sequential feature-followup number; STORY-INDEX
currently has 53 stories; next would be S-54 if following the sequential-feature convention
used for S-327, S-410, etc. — recommend `S-E2E-1` as a semantic label for clarity, mirroring
the naming style used for issue-NNN stories).

**Effort estimate:** MEDIUM (1–2 dev-days: write test file, write workflow, CLAUDE.md update,
spec corrections, gate-invariant no-op test).

**BC Anchors:** None (infrastructure; no product BCs added).

**NFR Anchors:** NFR-T-E2E-1 (if added in F2).

**Acceptance Criteria sketch (traceable to spec sections):**

| AC | Spec Reference | Description |
|----|---------------|-------------|
| AC-001 | §4 (Gating) | `cargo test --test e2e_live` without `JR_RUN_E2E=1` exits 0 and runs zero live tests (all `#[ignore]`). The suite compiles cleanly in `ci.yml`'s `cargo test` run. |
| AC-002 | §4 (Gating) | `cargo test --test e2e_live -- --include-ignored` without `JR_RUN_E2E=1` exits 0; all gated tests return early without contacting Jira. |
| AC-003 | §4 (Harness) | `e2e_cmd()` helper injects `JR_BASE_URL=env(JR_E2E_BASE_URL)`, `JR_AUTH_HEADER=env(JR_AUTH_HEADER)`, isolated `XDG_CACHE_HOME`/`XDG_CONFIG_HOME` per test, and `--no-input`. |
| AC-004 | §4 (Read coverage) | When `JR_RUN_E2E=1` and env vars are set: `auth status --output json` exits 0 with expected fields; `issue list --jql "project=<E2E>" --output json` returns a valid JSON array; `board list --output json` returns a valid JSON array. |
| AC-005 | §4 (Write flow) | When `JR_RUN_E2E=1`: `issue create` → `poll_view` → `issue edit` → `issue comment` → `worklog add` → `issue move Done` all exit 0 in sequence. |
| AC-006 | §4 (poll_view) | `poll_view(key)` uses bounded retry (e.g., 5 attempts with short backoff); exits with a clear error after exhaustion rather than hanging. |
| AC-007 | §5 (Workflow) | `.github/workflows/e2e.yml` triggers on push to `develop`/`main`, nightly cron, and `workflow_dispatch`. Job is bound to `jira-e2e` Environment. |
| AC-008 | §5 (Teardown) | Teardown step is `if: always()` and closes all issues labeled `e2e-<GITHUB_RUN_ID>` that are not already Done. |
| AC-009 | §6 (Secret safety) | Job has `if: github.event_name != 'pull_request'`. Workflow uses no `pull_request_target` trigger. |
| AC-010 | §5 (Non-blocking) | `e2e.yml` is NOT added to branch protection required checks in `ci.yml` or repository settings. |
| AC-011 | CLAUDE.md convention | `JR_RUN_E2E` is documented in CLAUDE.md AI Agent Notes alongside `JR_RUN_KEYRING_TESTS` and `JR_RUN_OAUTH_INTEGRATION`. |

**Holdout anchors:** None (no new holdout scenarios; gate correctness is verified by AC-001/002).

**Out of scope for S-E2E-1 (from spec §12 open items):**

- Exact per-command JSON shape assertions (finalized during implementation against
  the provisioned free site — see Open Item 1).
- Token-expiry early-warning step (optional; 401 failure is the baseline signal — see
  Open Item 4).
- JSM read coverage (gated behind `JR_E2E_JSM_PROJECT` variable; included if variable
  is set, skipped cleanly if not — see Open Item 3).
- Sprint mutation (`sprint add/remove`) — gated behind `JR_E2E_BOARD_ID`.

---

## 9. Open Questions / Risks (from spec §12)

These carry forward from the design spec and must be resolved during F4 implementation:

| # | Item | Spec ref | Risk level | Resolution path |
|---|------|----------|-----------|----------------|
| OQ-1 | **Exact read assertions** — minimal JSON-shape checks that are stable across a fresh free site (avoid over-fitting to seed data). | §12.1 | LOW | Finalize during provisioning; use presence-checks ("field exists") rather than value-equality where values depend on site state. |
| OQ-2 | **Transition names** — `move` targets depend on the workflow's status names (`In Progress`, `Done`); confirm against provisioned Scrum project, or make configurable via env vars. | §12.2 | MEDIUM | Make status names configurable via `JR_E2E_STATUS_DONE` / `JR_E2E_STATUS_IN_PROGRESS` env vars (fall back to `"Done"` / `"In Progress"` if unset). Prevents hard-coded names from failing if the site's workflow uses different casing. |
| OQ-3 | **JSM free-tier coverage** — confirm which JSM read commands work on free; keep behind `JR_E2E_JSM_PROJECT` flag. | §12.3 | LOW | Already gated; implement and test against a real free JSM project; skip cleanly if variable unset. |
| OQ-4 | **Token-expiry early warning** — optional scheduled step that warns ~30 days before expiry. | §12.4 | LOW | Defer to a follow-up; document the token mint date as a repo variable for future tooling. Loud 401 on expiry is the baseline. |

**Additional risk not in the spec:**

| # | Risk | Likelihood | Mitigation |
|---|------|-----------|-----------|
| R-NEW-1 | **Site provisioning never happens.** If no maintainer provisions the free Jira site and mints credentials, the `e2e.yml` workflow silently fails every run with "missing secret" / authentication failure. The code is correct but the feature is inert. | MEDIUM | AC-007 and AC-008 are verifiable locally in dry-run mode. The provisioning runbook (spec §10) is the output artifact; file a tracking issue. |
| R-NEW-2 | **Free-site idle deactivation data loss.** The nightly keep-warm job is effectively a data-retention guard (15–60 day deletion window post-deactivation, per research validation Claim 8). If the nightly schedule is suspended or the workflow is disabled for ~120 days, the site data is permanently lost. | LOW | Runbook explicitly notes the deletion window. The nightly cron is the primary mitigation. |
| R-NEW-3 | **Concurrent runs clobber each other.** Two pushes to develop within seconds could trigger two E2E runs against the same site. | LOW | `concurrency: group: jira-e2e, cancel-in-progress: false` in `e2e.yml` serializes runs. Run-scoped labels prevent cross-run artifact confusion. |

---

## 10. Intent, Scope, and Routing Summary

| Field | Value |
|-------|-------|
| **Intent** | `feature` — new capability (live-Jira E2E testing in CI) |
| **Feature type** | `infrastructure` — test harness + CI workflow; no product UI or API surface |
| **Scope** | `non-trivial` — new test file + new workflow; CLAUDE.md update; spec corrections |
| **Quick dev eligible** | NO — new gated test file + new CI workflow file; two files in different subsystems (tests/ and .github/workflows/) |
| **BC delta** | EMPTY — zero product BCs added, modified, or retired |
| **NFR delta** | ONE proposed (NFR-T-E2E-1, MEDIUM severity) — conditional on human approval |
| **src/ changes** | ZERO — verified against seam analysis in §2 |
| **Regression risk** | LOW — no src/ changes; no existing test changes; gate prevents normal cargo test from contacting Jira; non-blocking CI workflow |
| **Recommended F2** | Near-empty: apply 3 spec text corrections + record NFR-T-E2E-1 (if approved) + CLAUDE.md JR_RUN_E2E entry |
| **Recommended F3** | ONE story: `S-E2E-1` (11 ACs; MEDIUM effort; traceable to spec §4/§5/§6) |
| **Recommended F4** | Single worktree; TDD order: gate no-op test first (AC-001/002), then harness (AC-003), then read assertions (AC-004), then write flow (AC-005/006), then workflow file (AC-007..010), then CLAUDE.md (AC-011) |
