---
document_type: delta-analysis-report
feature_name: "E2E test-infra ADF heuristic fix (discover_safe_edit_field)"
created: 2026-09-12
spec_version_at_analysis: "2.3.0"
status: SUPERSEDED
superseded_by: "e2e-edit-field-adf-heuristic-delta-analysis-v2.md"
superseded_reason: "Human selected Route B (full product fix). Product auto-ADF conversion for --field is now in scope. The test-infra-only analysis is retained for record but is no longer the operative scope."
intent: "bug-fix"
feature_type: "infrastructure"
scope: "trivial"
severity: "LOW"
cycle_proposed: "cycle-012-e2e-test-infra-adf-heuristic-fix (PROPOSED — state-manager must formalize number)"
standing_item_ref: "E2E-EDIT-FIELD-ADF-HEURISTIC"
---

# Delta Analysis Report: E2E `discover_safe_edit_field` ADF Heuristic Fix

## Feature Request

- **Brief:** Standing item `E2E-EDIT-FIELD-ADF-HEURISTIC` (recorded in `.factory/STATE.md` Drift/Standing Items and
  `cycles/OPEN-STANDING-ITEMS.md`). The nightly live-Jira E2E test
  `test_e2e_issue_edit_custom_field` (`tests/e2e_live.rs:5276`) panics with
  `API error (400): environment: Operation value must be an Atlassian Document (see the Atlassian Document Format)`
  because `discover_safe_edit_field` prefers Jira's `Environment` system field, which requires ADF
  on REST v3 writes despite `editmeta` reporting `schema.type == "string"`. Prescriptive fix
  established by completed research artifact
  `.factory/research/e2e-environment-adf-field-2026-09-11.md`.
- **Requested by:** Human (explicit scope statement 2026-09-12; research pre-completed).
- **Date:** 2026-09-12.
- **Pre-existing failure:** Confirmed on `develop` tip `14e695ae` (E2E run 34588420715, 2026-09-11)
  and every prior SHA in cycle-007's merge train. NOT a cycle-007 regression.

## Classifications

### Intent Classification

| Intent | Detection Signals | Route |
|--------|------------------|-------|
| `feature` | Human says "add", "build", "new" | Full F1-F7 |
| `enhancement` | Human says "improve", "update", "change" | Full F1-F7 (may be quick dev if trivial) |
| `bug-fix` | Human says "fix", "bug", "broken", "regression" | Bug fix route (skip F2, F3) |

**Classified intent:** `bug-fix`

**Rationale:** The E2E test helper `discover_safe_edit_field` contains a defective field-selection
heuristic that causes `test_e2e_issue_edit_custom_field` to fail deterministically on the live Jira
site. The human framing uses "fix". Root cause is a behavioral defect in test infrastructure code,
not a product regression.

### Feature Type Classification

**Classified type:** `infrastructure`

**Rationale:** The change touches only `tests/e2e_live.rs` — a test helper function and its doc
comments. Zero `src/` files are modified. The product command `jr issue edit --field` is explicitly
out of scope (auto-ADF conversion of rich-text custom fields is a deferred product enhancement, not
part of this fix). This is pure test-infrastructure maintenance.

### Trivial Scope Classification

- [x] Impact boundary: single file (`tests/e2e_live.rs`), one function (`discover_safe_edit_field`) + its
  callers' doc comments
- [x] No new BCs needed — test-infra fix; no behavioral contract changes to the product
- [x] No architecture change — `tests/` has no architecture impact; `ARCH-INDEX.md` unchanged
- [x] No new external dependencies — no new crates; `discover_safe_edit_field` already calls
  `fetch_raw` and iterates the existing `serde_json::Value`
- [x] Regression risk: LOW — change restricts the field-selection predicate (fewer fields
  selected); can only cause more tests to clean-skip (safe outcome), never introduce false passes

**Classified scope:** `trivial`

**Rationale:** All five trivial-scope conditions hold. Quick dev routing applies:
F1 (this analysis) → F4 (single story, worktree → implement → PR → review → merge) →
regression-suite verification → F7 lite (convergence check) → no product release (test-infra only).
Phases F2 (no spec change), F3 (no new stories from spec), F5, and F6 are all skipped.

### Severity Classification

**Classified severity:** `LOW`

**Rationale:**
- E2E (`e2e.yml`) is a **non-blocking** CI workflow — it is explicitly NOT in `ci-gate.needs`.
  No PR, no merge, no release has been or will be blocked by this failure.
- The failure is nightly only and affects 1 of 107 E2E tests. 106/107 continue to pass.
- A full workaround exists: setting `JR_E2E_EDIT_FIELD=<NAME>=<VALUE>` in the `jira-e2e`
  GitHub Environment bypasses dynamic discovery entirely.
- Product behavior and user-facing correctness are unaffected.

## Root Cause Summary

On Jira Cloud REST API v3, the `environment` system field (and `description`) requires an ADF
`{"type":"doc","version":1,"content":[...]}` object on write. The `editmeta` endpoint
reports `schema.type == "string"` for both, providing no machine-readable ADF discriminator —
this is JRACLOUD-75814, closed Won't Fix by Atlassian. The fallback predicate `is_string_field`
(accepts any `schema.type == "string"` field excluding `summary`/`description`) also admits
arbitrary system fields and `...:textarea` custom fields, both of which may require ADF.

**Root cause BC:** None — no product behavioral contract is violated. This is a test helper
defect with no BC traceability.

**Prescribed fix** (per `.factory/research/e2e-environment-adf-field-2026-09-11.md` §RECOMMENDED FIX):

1. Remove the `Environment` preference block entirely from `discover_safe_edit_field`.
2. Replace the `is_string_field` predicate with a stricter `is_plain_text_custom_field` that
   accepts a field only when `schema.type == "string"` AND
   `schema.custom == "com.atlassian.jira.plugin.system.customfieldtypes:textfield"`.
   These fields are always `customfield_NNNNN` IDs, so the returned `cli_ref` uses the
   literal-bypass form (BC-3.4.015 Step 1) — no display-name resolution needed.
3. Add a defensive denylist (secondary belt-and-suspenders): explicitly skip `environment` and
   `description` even if the predicate were ever loosened. Continue skipping `summary`.
4. Update the function's doc comment to describe the new rule and drop the "prefers `Environment`"
   language. Update the file-header doc comment at line 51–53 to remove `(e.g. `Environment`)`.
5. Clean-skip semantics unchanged: return `None` when no `...:textfield` custom field exists on
   the issue's edit screen — the test already treats `None` as a valid clean-skip.

## Impact Assessment

| Dimension | Affected | Details |
|-----------|----------|---------|
| PRD Requirements | 0 new, 0 modified | No BC changes; test-infra fix only |
| Architecture | 0 new, 0 modified | No architecture change; `tests/` is outside the architecture boundary |
| UX Screens | 0 new, 0 modified | `jr` is CLI-only; no UI surface |
| Stories | 1 new story (trivial) | Single story: fix `discover_safe_edit_field` + doc comments |
| Existing Tests | 1 test function directly affected | `test_e2e_issue_edit_custom_field` (the failing test); no other test calls `discover_safe_edit_field` |
| Verification Properties | 0 new proofs | No new VPs; test-infra only |

## Files Changed

### New Files

None.

### Modified Files

| File Path | Change Type | Risk | Symbols Affected |
|-----------|-------------|------|-----------------|
| `tests/e2e_live.rs` | Internal logic (test helper + doc comments) | LOW | `discover_safe_edit_field` (fn body + doc comment); file-header doc comment (line 51–53) |

### Dependent Files (unchanged but depend on modified code)

| File Path | Depends On | Regression Risk |
|-----------|-----------|----------------|
| `tests/e2e_live.rs::test_e2e_issue_edit_custom_field` | `discover_safe_edit_field` | LOW — caller already handles `None` (clean-skip path); the change narrows the selection; a site with no `...:textfield` custom fields will clean-skip instead of fail |

## Files NOT Changed (Regression Baseline)

The following must not be touched during implementation. All their tests must continue to pass:

- `src/` (all product source files) — auto-ADF conversion of rich-text custom fields is **explicitly
  out of scope**; no `src/cli/issue/`, `src/api/`, `src/adf.rs`, or any other product file changes
- `tests/e2e_live.rs` (all functions except `discover_safe_edit_field` and its doc comment callers)
- `tests/` (all other test files — `ci_gate_completeness.rs`, `attachment_download.rs`, `e2e_cli_surface_guard.rs`, etc.)
- `.factory/specs/prd.md` and all BC files — no spec changes
- `.factory/specs/architecture/` — no architecture changes
- `.factory/specs/verification-properties/` — no VP changes
- `.cargo/mutants.toml` — no mutation scope changes
- `.github/workflows/` — no CI workflow changes (the E2E failure is pre-existing; fixing the
  test does not require any CI config changes)
- `CLAUDE.md` — the `JR_E2E_EDIT_FIELD` entry in the AI Agent Notes table documents the
  env-var contract, not the heuristic implementation detail; if the doc comment language in the
  test file changes, CLAUDE.md may need a minor update to remove the `(e.g. `Environment`)`
  parenthetical — but this is optional cleanup, not a correctness obligation

## Risk Assessment

| Risk Type | Level | Rationale |
|-----------|-------|-----------|
| Regression | LOW | Change is in `tests/e2e_live.rs` only; no product code touched. The new predicate is strictly narrower — it selects fewer fields. The worst observable outcome is more clean-skips on sites without `...:textfield` custom fields, which is safe and explicit. No existing test can be made to fail by narrowing field discovery. |
| Architecture | NONE | `tests/e2e_live.rs` is outside the architecture boundary. ARCH-INDEX.md and all architecture section files are unchanged. |
| Security | NONE | Test-infrastructure change only; no credential handling, no network path changes, no `src/` modifications. |
| Performance | NONE | `discover_safe_edit_field` runs once per nightly E2E invocation; the predicate change adds one `schema.custom` field lookup within an already-existing `editmeta` parse. Immaterial. |

## Regression Baseline

- **Total E2E tests:** 107 (`tests/e2e_live.rs`; source: standing item `E2E-EDIT-FIELD-ADF-HEURISTIC`)
- **Tests currently passing:** 106/107 (100% except the failing target test)
- **Tests in regression risk zone:** 1 — `test_e2e_issue_edit_custom_field` (the test being fixed)
- **Default CI suite:** Unaffected. E2E tests are `#[ignore]` and not in `ci-gate.needs`. The
  default `cargo test` and `ci-gate` jobs are completely isolated from this change.
- **Tests calling `discover_safe_edit_field`:** 1 (only `test_e2e_issue_edit_custom_field`)
- **Risk zone test files:** `tests/e2e_live.rs` only

## Scope Recommendation

- **Mode:** Feature Mode, **Quick Dev Routing** (trivial scope, bug-fix intent, LOW severity)
- **Pipeline:** F1 → F4 (single story) → regression-suite verification → F7 lite → no product release
- **Estimated new stories:** 1
- **Estimated effort:** 1–2 points (single function body rewrite + doc comment updates)
- **Can parallelize:** N/A (single story)

### Compressed Pipeline (Quick Dev Routing)

| Phase | Status | Notes |
|-------|--------|-------|
| F1 Delta Analysis | **THIS DOCUMENT** | Human gate required |
| F2 Spec Evolution | SKIP | No BC changes; no spec version bump |
| F3 Story Decomposition | SKIP | Single trivial story; no formal F3 needed |
| F4 Implementation | Required | Single story; worktree → implement → PR → pr-reviewer → merge |
| F5 Scoped Adversarial | SKIP | Test-infra only; no adversarial review warranted |
| F6 Targeted Hardening | SKIP | No formal proofs, no fuzzing, no mutation changes |
| F7 Convergence | Required (lite) | Confirm: E2E passes on live site (nightly), default CI unaffected, no regressions |
| Release | NONE | Test-infra change; no version bump; ships on `develop` |

## Proposed Story Decomposition (Sketch)

**STORY-E12-001: Fix `discover_safe_edit_field` to use `...:textfield` allowlist**

- Scope: `tests/e2e_live.rs` only
- AC-1: `discover_safe_edit_field` no longer returns `environment` (or any non-`...:textfield`
  field) as the selected field
- AC-2: The function accepts a field only when `schema.type == "string"` AND
  `schema.custom == "com.atlassian.jira.plugin.system.customfieldtypes:textfield"`
- AC-3: `environment` and `description` appear in the defensive denylist
- AC-4: Clean-skip semantics unchanged (`None` returned when no `...:textfield` field found)
- AC-5: Doc comment updated to describe the new rule; file-header `JR_E2E_EDIT_FIELD` note
  no longer claims `Environment` as the default
- AC-6: `test_e2e_issue_edit_custom_field` passes on the live Jira site (ES project, nightly
  E2E run) — or clean-skips if no `...:textfield` custom field is on the ES-project edit screen
  (acceptable; `JR_E2E_EDIT_FIELD` override covers deliberate coverage)
- AC-7: No `src/` file is modified

## Proposed Cycle Identity

**Name:** `e2e-test-infra-adf-heuristic-fix`
**Proposed number:** `cycle-012`
**Flag for state-manager:** The parked bundles occupy cycle-008 (issue-io-quickwins), cycle-009
(bulk-by-jql), cycle-010 (read-index-lag), and cycle-011 (filter-grammar). `cycle-012` is the
next available number and does not collide with any known parked bundle. **State-manager must
formalize the cycle number** when opening the cycle record (this analysis uses the proposed
number for artifact naming only; the human's approval gate is the authority).

## Out-of-Scope Statement (Explicit)

The following is **explicitly OUT OF SCOPE** for this fix cycle and must not be implemented:

1. **Auto-ADF conversion of rich-text custom fields in `jr issue edit --field`** — the product
   command's generic plain-string path for `schema.type == "string"` fields is intentionally
   correct for the thin-client design (research conclusion Q4). Converting `environment` /
   `...:textarea` fields to ADF automatically would be a product enhancement touching `src/`,
   requiring BC additions, spec versioning, adversarial review, and formal hardening. Deferred
   to a future product cycle.

2. **Any `src/` change of any kind** — no product code is modified.

3. **BC additions or modifications** — spec version stays at 2.3.0.

4. **Architecture changes** — ARCH-INDEX.md and all architecture section files are unchanged.

5. **`CLAUDE.md` `JR_E2E_EDIT_FIELD` doc table** — the doc entry describes the env-var's
   existence and purpose, not the heuristic implementation. No behavioral change to the env-var
   contract; CLAUDE.md update is optional cleanup only.

## Open Questions for Human Gate

None blocking. The research is complete and prescribes the fix unambiguously. One optional item
for human confirmation:

1. **Clean-skip acceptability on the ES project:** If the live `ES` project's edit screen exposes
   no `...:textfield` custom fields (possible — the project may have only system fields and
   `...:textarea` fields), the test will permanently clean-skip after this fix rather than
   exercising the write path. The `JR_E2E_EDIT_FIELD` env-var override in the `jira-e2e`
   GitHub Environment provides a manual escape hatch. Is a permanent clean-skip an acceptable
   outcome, or should the `jira-e2e` environment be pre-configured with a `JR_E2E_EDIT_FIELD`
   override to guarantee coverage?

   *Recommendation: accept the clean-skip; the test was previously failing, so clean-skip is a
   strict improvement. Configuring `JR_E2E_EDIT_FIELD` can be done independently at any time.*
