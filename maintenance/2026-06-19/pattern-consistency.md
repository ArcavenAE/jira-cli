# Pattern Consistency & Lint Health — Maintenance Sweep 3 (Pass 2)

**Date:** 2026-06-19
**Branch:** develop @ 71f33c6 (v0.6.0-dev.5)
**Prior review:** `.factory/maintenance/2026-06-17/pattern-consistency.md`
**Scope:** Read-only scan. No code changes. Covers commits 3ba8ea2..71f33c6.

---

## 1. Lint Health

### 1.1 `cargo clippy --all-targets -- -D warnings`

**Result: PASS (exit 0, zero warnings)**

The zero-warning policy is in force. No regressions introduced in the seven commits since the prior review.

### 1.2 `cargo fmt --all -- --check`

**Result: PASS (exit 0, no diffs)**

Format is consistent throughout the codebase.

### 1.3 `#[allow(...)]` inventory

Three occurrences in source (same count as prior pass):

| Location | Attribute | Verdict |
|---|---|---|
| `src/adf.rs:8488` | `#[allow(clippy::too_many_lines)]` | **NOW HAS JUSTIFICATION COMMENT** (ca24200 / CR-004 fix). 5-line comment immediately above the attribute. Complies with policy. |
| `src/api/refresh_coordinator.rs:56` | `#[allow(dead_code)]` | On `reset_for_test` inside `#[cfg(test)]` — acceptable; dead_code fires because the fn is not called from within the same cfg block. |
| `src/types/jira/editmeta.rs:23,62` | Comments *warning* future editors about `#[allow(dead_code)]` — not actual `#[allow]` attributes | Clean |

No new unsuppressed lint suppressions introduced since the prior pass.

---

## 2. Part A — Fix Verification Table

Findings from the 2026-06-17 pass and their resolution status:

| ID | Prior Severity | Status | Evidence |
|----|----------------|--------|----------|
| CR-001 | LOW | **RESOLVED** | `list_comments` anti-stall guard added in 6f24748 (`src/api/jira/issues.rs::list_comments` lines 671–681). Guard returns `Err(anyhow!("Jira comment pagination did not advance…"))` when `next <= start_at`. Three new tests in `tests/comments.rs` anchor the behavior. |
| CR-002 | LOW | **RESOLVED** | d56dcfc unified all `--output json` paths through `output::render_json`. Verified: no `println!("{}", serde_json::to_string_pretty(…))` pattern remains in `src/cli/`. All auth, issue, sprint, worklog, assets, and project JSON paths now route through `render_json` or `print_output`. |
| CR-003 | LOW | **RESOLVED** | ca24200 updated `CLAUDE.md` Known Size Deviations entry to `1,256 LOC`. `list.rs` LOC unchanged at 1,256 — documentation now accurate. |
| CR-004 | LOW | **RESOLVED** | ca24200 added a 5-line justification comment at `src/adf.rs:8483–8487` immediately above `#[allow(clippy::too_many_lines)]`. Policy is satisfied. |
| CR-005 | LOW | **OPEN** | `OffsetPage::items()` accessor still underused in 5 of 6 pagination loops. `boards.rs`, `issues.rs` (get_changelog + list_comments), `sprints.rs` (2 sites), `projects.rs` still use `.values.unwrap_or_default()` / `.issues.unwrap_or_default()` etc. No change since prior pass. |
| CR-006 | LOW | **PARTIALLY RESOLVED** | `src/cli/project.rs` JSON path now uses `output::render_json` (d56dcfc fixed the inline `serde_json::json!` display path). The Table branch still uses bare `println!` — which is structurally necessary (multi-section prose). The JSON invariant is now satisfied; the Table divergence is the accepted structural deviation. |
| CR-007 | LOW | **RESOLVED** | 6f24748 converted both `write_cmdb_fields_cache` and `write_object_type_attr_cache` to model-b best-effort writers with `eprintln!` on error and `Ok(())` return. Call sites now use `.ok()` (not `let _ =`). Rustdoc updated. Two new unit tests (`test_write_cmdb_fields_cache_swallow_io_error_returns_ok`, `test_write_object_type_attr_cache_swallow_io_error_returns_ok`) anchor the behavior. CLAUDE.md gotcha entry added. |

**Resolution summary:** 5 of 7 findings RESOLVED, 1 PARTIALLY RESOLVED (CR-006 JSON path fixed; Table deviation accepted), 1 OPEN (CR-005 low-priority style).

---

## 3. Module Size / Structure

| File | Actual LOC | Change Since Prior | Status |
|---|---|---|---|
| `src/cli/issue/list.rs` | 1,256 | Unchanged | CLAUDE.md updated to reflect 1,256 LOC. |
| `src/cli/issue/create.rs` | 2,880 | Unchanged | No formal target. |
| `src/cli/issue/workflow.rs` | 1,341 | -4 LOC | Cosmetic; no structural change. |
| `src/cli/issue/helpers.rs` | 836 | Unchanged | — |
| `src/adf.rs` | 10,531 | +5 LOC | CR/LF normalization and test additions (53f6d98/ca24200). |
| `src/cache.rs` | 1,781 | +91 LOC | Two new unit tests anchoring model-b cache writers. |

No new size deviations. The `list.rs` split opportunity identified in §2.1 of the prior report remains open as a future refactor.

---

## 4. Part B — New Findings (not in prior pass)

### CR-008 — `extract_job_block` duplicated across three integration-test files

- **Severity:** LOW
- **Category:** code-quality
- **Location:** `tests/ci_yml_windows_matrix.rs::extract_job_block` / `tests/ci_gate_completeness.rs::extract_job_block` / `tests/backfill_matrix_parity.rs::extract_job_block`
- **Description:** The same YAML job-block extraction helper (`extract_job_block<'a>(yaml: &'a str, job_name: &str) -> Option<&'a str>`) is implemented three times with slightly divergent implementations. The `backfill_matrix_parity.rs` version (added in commit 2756050) has a minor algorithmic difference in its inner loop termination path (adds a `find("\n  ")` inner fallback absent from the other two). This makes the three implementations semantically close but not identical, which is a future maintenance hazard: a bug discovered in one copy requires auditing the others. The `tests/common/` directory already exists for shared test infrastructure (`fixtures.rs`, `mock_server.rs`) and is the natural home for a shared `ci_test_helpers.rs` or similar module.
- **Evidence:** `grep -n 'fn extract_job_block'` → three independent definitions across `ci_yml_windows_matrix.rs:68`, `ci_gate_completeness.rs:66`, `backfill_matrix_parity.rs:158`. Body comparison via diff confirms semantic near-identity with one diverging loop exit path.
- **Proposed Fix:** Extract `extract_job_block` into `tests/common/ci_helpers.rs` (or inline in `tests/common/mod.rs`). Callers import via `mod common; common::extract_job_block(…)`. One-time medium-effort migration; future CI test files inherit the shared helper. Low urgency — no correctness defect today, but each new workflow test file risks introducing a fourth copy.
- **Refactor effort:** Medium (test-only, no behavioral change). Automated-fix: yes (mechanical copy-then-replace).

---

### CR-009 — Three keyring-gate guard idioms remain without canonical form or meta-test

- **Severity:** LOW
- **Category:** pattern-consistency
- **Location:** Multiple test files (see below)
- **Description:** This was tracked as KEYRING-GUARD-IDIOM-DRIFT in STATE.md. Three distinct patterns for gating keyring tests coexist:
  - **Idiom A** (`is_err()` early return): `tests/auth_profiles.rs:210,322` — exits silently when `JR_RUN_KEYRING_TESTS` is unset regardless of value.
  - **Idiom B** (`as_deref() != Ok("1")` early return): `tests/multi_cloudid_disambiguation.rs` (5 sites), `tests/oauth_refresh_integration.rs` (5 sites) — exits silently when value is absent or not exactly `"1"`.
  - **Idiom C** (`match + panic`): `tests/auth_output_json.rs:337` — panics with a detailed error message when the env var is unset or not `"1"` (most defensive, hardest to ignore).

  Behavioral difference: Idiom A passes when `JR_RUN_KEYRING_TESTS=anything` (including `"0"`) but only exits when unset. Idioms B and C require value `"1"` exactly. A developer who sets `JR_RUN_KEYRING_TESTS=yes` will silently skip tests in Idioms B/C but will run them under Idiom A — producing inconsistent opt-in behavior. No meta-test enforces canonical form. This is the same status as the prior pass (DEFERRED in STATE.md).
- **Evidence:** Idiom count: A→3, B→17, C→1. Total 17 keyring-gated `#[ignore]` test functions. None of the CLAUDE.md or `tests/common/` documentation defines a canonical gate idiom.
- **Proposed Fix:** Adopt Idiom B as canonical (majority, stricter, consistent with Idiom C). Migrate the 3 Idiom-A occurrences in `auth_profiles.rs` to `as_deref() != Ok("1")`. Optionally extract a `fn keyring_tests_enabled() -> bool` helper into `tests/common/mod.rs` and call it from all 17 sites. No behavioral regression for CI (tests are `#[ignore]` and only run with `--include-ignored`). Medium batch effort.
- **Refactor effort:** Medium (test-only, no behavioral change in CI). Automated-fix: yes (mechanical substitution).

---

### CR-010 — `FORK-OPS-BACKFILL-TIMEOUT-PARITY`: `backfill-release.yml` build job missing `timeout-minutes`

- **Severity:** LOW
- **Category:** maintainability
- **Location:** `.github/workflows/backfill-release.yml::build` (job at line 38)
- **Description:** `release.yml` sets `timeout-minutes: 60` on its build job (line 14). `backfill-release.yml`'s build job has no `timeout-minutes` at either the workflow or job level, meaning GitHub Actions will apply its 6-hour default. This was tracked as a carry-forward in the S-FORK-OPS-BACKFILL F7 convergence. A runaway build (e.g., a Windows cross-compilation hang or network stall) in the backfill workflow would be allowed to consume 6 hours of CI runner time vs 60 minutes for the equivalent release.yml job.
- **Evidence:** `grep -n 'timeout-minutes' .github/workflows/backfill-release.yml` → no output (zero hits). `grep -n 'timeout-minutes' .github/workflows/release.yml` → line 14: `timeout-minutes: 60`.
- **Proposed Fix:** Add `timeout-minutes: 60` to the `build` job in `backfill-release.yml`. One-line change. No behavioral impact in the successful path.
- **Refactor effort:** Trivial (1-line YAML addition). Automated-fix: yes.

---

## 5. Carry-Forward Drift Items (from STATE.md, not yet actionable)

These items are tracked in `.factory/STATE.md` and confirmed OPEN but unchanged since the prior review:

| Drift ID | Location | Summary | Severity | Status |
|---|---|---|---|---|
| DRIFT-331-PAGINATION | `src/api/jira/issues.rs::get_issue_types_for_project` | Inline pagination reimplementation; justified by Jira API schema divergence. | LOW | OPEN — accepted, not actionable |
| SEC-001 / CWE-674 | `src/adf.rs::normalize_panel_content`, `::autolink_bare_urls`, `::assign_local_ids_walk` | Uncontrolled recursion depth. ADF tree depth is bounded by pulldown-cmark's parse depth (practical stack budget: 64+ frames), not by an explicit guard. Worst-case: deeply nested user Markdown causes stack overflow. | LOW | OPEN — no explicit depth guard; practical risk is low given pulldown-cmark input constraints |
| KEYRING-GUARD-IDIOM-DRIFT | `tests/` | Three co-existing keyring-gate idioms; now documented as CR-009 above. | LOW | DEFERRED → captured as CR-009 |
| CITATION-FORM-DISCIPLINE | `CLAUDE.md` | Bare `file:NN` line citations vs symbol-form (`::fn`) per #408 convention. No bare `src/*.rs:NNN` pattern found in current CLAUDE.md scan. | LOW | IMPROVED — 0 bare line citations detected in current CLAUDE.md |
| FORK-OPS-BACKFILL-ZIP-GLOB-COUPLING | `backfill-release.yml` | `gh release upload jr-*.zip` fails loud on zero-match glob (accepted; guarded by needs:build + matrix-parity test). | LOW | OPEN — accepted |
| FORK-OPS-F5-SELFTEST-CHECKLIST | Process gap | F5 checklist conflates `--self-test` inline fixture with real-file scan; wording could mislead. | LOW | OPEN |
| FORK-OPS-BACKFILL-TIMEOUT-PARITY | `backfill-release.yml` | Build job lacks `timeout-minutes`. | LOW | OPEN → captured as CR-010 above |

**SEC-001 depth detail:** `normalize_panel_content` recurses through `panel`/`blockquote` nodes without a depth counter. `autolink_bare_urls` recurses via the `_ =>` catch-all arm into `content`. `assign_local_ids_walk` recurses into all `content` arrays. None has an explicit depth guard (contrast with `yaml_contains_secrets` in `check-signing-workflow-injection.sh` which guards `depth > 20`). The practical risk is constrained because pulldown-cmark emits a flat-ish event stream and the ADF builder's stack-based emit limits nesting depth indirectly, but this is an implicit rather than enforced bound.

---

## 6. Duplicate Logic / Batch-Refactor Candidates (Updated)

### 6.1 `extract_job_block` — three independent copies in CI test files

Described in CR-008 above. New finding this pass (adds `backfill_matrix_parity.rs` to the two prior files).

### 6.2 Date validation pattern — unchanged

`src/cli/issue/list.rs::handle_list` (lines 97–113) still has four near-identical `if let Some(ref d) = … { Some(validate_date(d)?) } else { None }` blocks. Refactor candidate identified in prior pass §5.1; not yet acted upon.

### 6.3 JSM write-error escalation block — unchanged

`src/cli/issue/create.rs` lines ~2670–2715 contain a `downcast-JrError` escalation pattern noted in prior pass §5.2.

---

## 7. Pattern Audit: `--output json` Render-Path (CR-002 follow-up)

After d56dcfc, all `--output json` paths in `src/cli/` route through `output::render_json` or `output::print_output`. Verified by scan:

- `println!("{}", serde_json::to_string_pretty(…))` in `src/cli/`: **0 occurrences**
- Remaining `serde_json::to_string_pretty` in `src/`: only in `src/cache.rs` (serialization to disk, not output), `src/output.rs` (the implementation of `render_json`), and `src/adf.rs` (test assertions)
- Remaining `serde_json::json!` in `src/cli/`: used as data-construction intermediates before passing to `render_json` or `print_output` — correct pattern

The JSON render invariant (CLAUDE.md `#526`) is now fully enforced across all handlers.

---

## 8. Summary

| Area | Status |
|---|---|
| `cargo clippy -D warnings` | **PASS (exit 0)** |
| `cargo fmt --check` | **PASS (exit 0)** |
| `#[allow]` without justification | **0 instances** (CR-004 fixed in ca24200) |
| Prior findings resolved | 5 RESOLVED, 1 PARTIALLY RESOLVED, 1 OPEN (CR-005, low-priority) |
| New findings this pass | **3 (all LOW severity)** |
| Critical/High findings | **0** |

### Findings table (new findings this pass)

| ID | Severity | Category | Location (symbol-form) | Summary | Effort | Fix type |
|----|----------|----------|------------------------|---------|--------|----------|
| CR-008 | LOW | code-quality | `tests/ci_yml_windows_matrix.rs::extract_job_block` / `tests/ci_gate_completeness.rs::extract_job_block` / `tests/backfill_matrix_parity.rs::extract_job_block` | `extract_job_block` copy-pasted across 3 CI test files with divergent implementations | Medium | Automated |
| CR-009 | LOW | pattern-consistency | `tests/auth_profiles.rs`, `tests/multi_cloudid_disambiguation.rs`, `tests/oauth_refresh_integration.rs`, `tests/auth_output_json.rs` | Three distinct keyring-gate guard idioms; Idiom A accepts any value including `"0"`, Idioms B/C require `"1"` exactly | Medium | Automated |
| CR-010 | LOW | maintainability | `.github/workflows/backfill-release.yml` job `build` | Build job missing `timeout-minutes: 60`; inherits GitHub's 6-hour default (release.yml parity target) | Trivial | Automated |

### Top items by effort/impact

1. **CR-010** (1-line YAML) — Add `timeout-minutes: 60` to `backfill-release.yml` build job. Zero risk.
2. **CR-008** (medium, test-only) — Extract `extract_job_block` to `tests/common/`. Prevents a fourth copy on next CI test file addition.
3. **CR-009** (medium, test-only) — Canonicalize keyring guard to Idiom B; optionally extract `fn keyring_tests_enabled()`.
4. **CR-005** (still open, low priority) — Uniform `page.items()` use in pagination loops.

CONVERGENCE_REACHED — no CRITICAL or HIGH findings across either pass; all findings are LOW severity maintenance improvements.
