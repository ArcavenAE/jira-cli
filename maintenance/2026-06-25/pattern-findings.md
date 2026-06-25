# Pattern Consistency Findings — Maintenance Sweep 4
**Date:** 2026-06-25
**Scope:** `src/` — codebase-wide grep/read scan + cargo clippy/fmt. Delta vs prior sweep 2026-06-22.
**Prior sweep:** `/Users/zious/Documents/GITHUB/jira-cli/.factory/maintenance/2026-06-22/pattern-findings.md`

---

## Toolchain Health

| Check | Status |
|-------|--------|
| `cargo clippy --all --all-features --tests -- -D warnings` | CLEAN (exit 0) |
| `cargo fmt --all -- --check` | PASS (exit 0) |

---

## Part A — Fix Verification (Prior Sweep Findings)

| ID | Prior Severity | Status | Notes |
|----|----------------|--------|-------|
| PF-001 | LOW | UNRESOLVED | `#[allow(dead_code)]` on `reset_for_test` in `src/api/refresh_coordinator.rs:56` remains. The `#[cfg(test)]` attribute already excludes the dead_code warning in release builds; the belt-and-suspenders `allow` is still present with the same justification comment. Not fixed by any commit since 2026-06-22. |
| PF-002 | LOW | UNRESOLVED | `#[allow(clippy::too_many_lines)]` in `src/adf.rs:8578` for `test_adf_structural_validity_comprehensive_corpus`. Comment is 3 lines above the `#[allow]` attribute, not immediately preceding it. Style judgment issue — unchanged. |
| PF-003 | MEDIUM | RESOLVED | `extract_job_block` deduplicated into `tests/common/yaml.rs` by commit 61a969b (Bundle D). All three caller files now use `mod common; use common::yaml::extract_job_block;`. Verified: `tests/common/yaml.rs` exists. |
| PF-004 | MEDIUM | RESOLVED | Keyring guard idiom unified to canonical `as_deref() != Ok("1")` form by commit 61a969b (Bundle D). `tests/auth_profiles.rs` lines 210, 420, 471 now use the strict form. Verified by grep. |
| PF-005 | HIGH | RESOLVED (with note) | `src/api/assets/linked.rs:228` — `.id.clone().expect("id present — needs_enrichment filter guarantees id.is_some()")` now has an explicit justification string. The prior finding was that the expect had NO justification message; it now does. The underlying risk (panic if CMDB API omits `id` despite filter invariant) remains as a documented `expect` rather than a proper `Result` propagation — severity downgraded to LOW. See PF-008 below. |
| PF-006 | LOW | PARTIALLY_RESOLVED | `src/cli/sprint.rs` — the sprint_add path (line 120-122) still uses `println!(..., render_json(...))`. The pattern is intentional for "no-log facade" state-changing commands. Broader assessment (see JSON Render Invariant section) confirms the pattern is codebase-wide and not a violation of the #526 invariant, which only forbids `to_string_pretty` bypassing `render_json`. Re-classified as non-finding. |

---

## Part B — New Findings

### PF-007: `adf_to_text` signature changed to fallible (`Result<String, JrError>`) — `src/cli/issue/view.rs` JSON path still uses old infallible idiom
- **Severity:** LOW
- **Category:** pattern-consistency
- **Location:** `src/cli/issue/view.rs:87`
- **Description:** `adf_to_text` was changed from `-> String` to `-> Result<String, JrError>` by commit 35e20c9 (ADF recursion-depth guard). All call sites were updated to use `.map(adf::adf_to_text).transpose()?`. `view.rs:87` uses `.map(adf::adf_to_text)` — this is correct (the `.transpose()?` follows on line 88). The grep shows the pattern spans two lines. Not a bug — verified by reading lines 86-89. No action required.
- **Evidence:** Lines 86-89 in view.rs form the correct two-line chain: `.map(adf::adf_to_text)` then `.transpose()?`.
- **Proposed Fix:** No fix needed. Document as verified.
- **VERDICT:** FALSE POSITIVE — correctly handled. Closed.

### PF-008: `expect()` on `assets[idx].id` still present in `src/api/assets/linked.rs` without Result propagation
- **Severity:** LOW (downgraded from HIGH — now has justification string)
- **Category:** code-quality
- **Location:** `src/api/assets/linked.rs:228`
- **Description:** `.id.clone().expect("id present — needs_enrichment filter guarantees id.is_some()")` documents the caller invariant but does not propagate as `Result`. The filter at line 408 of `src/cli/issue/list.rs` also uses `.unwrap()` on `asset.id` after the same `.is_some()` check (line 408-410). Both sites panic instead of returning `JrError` if the CMDB API omits `id`. The invariant is structural (only entries where `id.is_some()` are placed in `needs_enrichment`), making the panic reachable only on a CMDB API contract violation. Low risk but diverges from the project pattern of `JrError` for all non-test panics.
- **Evidence:** `src/api/assets/linked.rs:225-228`, `src/cli/issue/list.rs:408-411`
- **Proposed Fix:** Replace with `ok_or_else(|| JrError::UserError("CMDB object missing id field".to_string()))?` at both sites.

### PF-009: `src/cli/issue/field_resolve.rs` — two bare `.unwrap()` calls on f64 parse in test helper function
- **Severity:** LOW
- **Category:** code-quality
- **Location:** `src/cli/issue/field_resolve.rs:711,715`
- **Description:** `parse_number_wire` (a `#[cfg(test)]` helper at lines 704-718) uses `.parse::<f64>().unwrap()` twice. This is a test helper function — in `#[cfg(test)]` scope — so it is test-only code and the unwrap panic is acceptable in test context. Not a production risk.
- **Evidence:** Lines 711 and 715 are inside `fn parse_number_wire` which appears inside `#[cfg(test)]` block.
- **Proposed Fix:** No action required — test helper, panic on unexpected input is acceptable.
- **VERDICT:** FALSE POSITIVE for production concern. Test-only code.

### PF-010: `src/cli/assets/schemas.rs:23` — bare `.unwrap()` on `MatchResult::Exact` lookup
- **Severity:** MEDIUM
- **Category:** code-quality
- **Location:** `src/cli/assets/schemas.rs:23`
- **Description:** After `partial_match` returns `MatchResult::Exact(name)`, the code calls `schemas.iter().find(|s| s.name == name).unwrap()`. The partial_match logic returned a name that was originally drawn from `schemas.iter().map(|s| s.name.clone())`, so the find should always succeed — but the panic is uncatchable if partial_match ever returns a name not in the current slice (e.g., if the slices diverged). No justification comment.
- **Evidence:** `src/cli/assets/schemas.rs:21-23`:
```rust
let names: Vec<String> = schemas.iter().map(|s| s.name.clone()).collect();
match partial_match::partial_match(input, &names) {
    MatchResult::Exact(name) => Ok(schemas.iter().find(|s| s.name == name).unwrap()),
```
- **Proposed Fix:** Add a justification comment: `// INVARIANT: name came from schemas — find always succeeds`. Or use `.ok_or_else(|| JrError::Internal(...))` for defensiveness.

### PF-011: `src/cli/assets/schemas.rs:266` — bare `.unwrap()` on `same_name.first()`
- **Severity:** MEDIUM
- **Category:** code-quality
- **Location:** `src/cli/assets/schemas.rs:266`
- **Description:** `.first().unwrap()` is called on `same_name` after filtering. The surrounding code accumulates `same_name` only when `same_name.len() > 1` fails (i.e., the code reaches line 266 because it fell through from an earlier check), but there is no comment establishing this invariant. The code path is: if `same_name.is_empty()` leads to an error return, so at line 266 `same_name` has at least one element — but this is not documented.
- **Evidence:** `src/cli/assets/schemas.rs:263-266`:
```rust
));
    }

    let (matched_type, schema_name) = same_name.first().unwrap();
```
- **Proposed Fix:** Add comment `// INVARIANT: same_name is non-empty (empty case returned Err above)` immediately above the unwrap.

### PF-012: `src/cli/auth/keychain.rs:169,198` — `.unwrap()` on known-Some values without comments
- **Severity:** LOW
- **Category:** maintainability
- **Location:** `src/cli/auth/keychain.rs:169,198`
- **Description:** `flag_id.unwrap()` and `env_id.unwrap()` are called after `flag_id_present`/`env_id_present` booleans confirm the `Option` is `Some`, but there is no comment or use of `expect()` to document the invariant. The code is correct — the bool guard establishes non-None before unwrap — but deviates from the project pattern of explicit justification.
- **Evidence:** Lines 162-169 and 191-198 of `src/cli/auth/keychain.rs`.
- **Proposed Fix:** Replace with `.expect("checked non-empty above")` or add an inline comment.

### PF-013: `src/cli/issue/list.rs:410` — bare `.unwrap()` on `asset.id` after `is_some()` guard
- **Severity:** LOW
- **Category:** code-quality
- **Location:** `src/cli/issue/list.rs:410`
- **Description:** `asset.id.clone().unwrap()` follows `if asset.id.is_some() …` check 2 lines above, but uses `.unwrap()` without a comment. Structurally safe — the `is_some()` guard on line 408 ensures this — but lacks a justification comment matching the project pattern.
- **Evidence:**
```rust
if asset.id.is_some() && asset.key.is_none() && asset.name.is_none() {
    let wid = asset.workspace_id.clone().unwrap_or_default();
    let oid = asset.id.clone().unwrap();
```
- **Proposed Fix:** Replace with `.expect("id.is_some() checked above")`.

### PF-014: `src/cli/issue/helpers.rs:506` — `.unwrap()` on `next()` after `len == 1` check
- **Severity:** LOW
- **Category:** maintainability
- **Location:** `src/cli/issue/helpers.rs:506`
- **Description:** `results.into_iter().next().unwrap()` follows `if results.len() == 1` check above. Structurally safe — len == 1 guarantees `next()` returns `Some` — but no justification comment.
- **Evidence:** Lines 505-506:
```rust
if results.len() == 1 {
    return Ok(results.into_iter().next().unwrap().object_key);
```
- **Proposed Fix:** Replace with `.expect("len == 1 checked above")`.

### PF-015: `src/adf.rs` — file size grew from ~10,531 to 11,215 LOC (+684 LOC for SEC-001 recursion guard)
- **Severity:** LOW
- **Category:** maintainability
- **Location:** `src/adf.rs`
- **Description:** `adf.rs` is ADR-0012 exempt, so this is not a policy violation. However, the file now stands at 11,215 LOC — an 8% increase from the prior sweep. The majority of new lines (684 LOC) are test functions for the BC-7.2.012 recursion guard. The production code growth is bounded. No action required at this threshold, but the trend warrants tracking. ADR-0012 explicitly exempts `adf.rs` from the shard rule.
- **Evidence:** `wc -l src/adf.rs` → 11215.
- **Proposed Fix:** No action required. Document as known growth. If file reaches ~15,000 LOC, reconsider the ADR-0012 exemption.

### PF-016: `src/cli/issue/create.rs` — 2,880 LOC, undocumented shard candidate
- **Severity:** MEDIUM
- **Category:** maintainability
- **Location:** `src/cli/issue/create.rs`
- **Description:** `create.rs` is the largest `src/cli/` file at 2,880 LOC — nearly 3× the ADR-0012 shard threshold of 1,000 LOC. The file handles both `issue create` and `issue edit`, plus JSM create, bulk edit paths, dry-run logic, field resolution, label handling, and comment formatting. CLAUDE.md documents `list.rs` (1,256 LOC) as a known deviation, but `create.rs` at 2,880 LOC is not documented. This was also 2,880 LOC at the prior sweep — not a new regression — but it was not raised as a finding then.
- **Evidence:** `wc -l src/cli/issue/create.rs` → 2880. The file contains at least 4 separable concerns: create, edit, JSM create, bulk-edit field handling.
- **Proposed Fix:** Candidate split: extract `handle_edit` bulk path into `src/cli/issue/edit.rs` (per `docs/specs/` sharding pattern). Add to CLAUDE.md Known Size Deviations until addressed. `auto_pr: FALSE` — manual review required.

### PF-017: `src/cli/issue/workflow.rs` — 1,341 LOC, undocumented shard candidate
- **Severity:** LOW
- **Category:** maintainability
- **Location:** `src/cli/issue/workflow.rs`
- **Description:** `workflow.rs` is 1,341 LOC — 34% above the ADR-0012 shard threshold. The file covers `move`, `transitions`, `assign`, `comment`, `open`, and `remote-link`. Unlike `list.rs`, this is not documented in CLAUDE.md Known Size Deviations. Also stable at 1,341 LOC since prior sweep — not a new regression.
- **Evidence:** `wc -l src/cli/issue/workflow.rs` → 1341.
- **Proposed Fix:** Document in CLAUDE.md Known Size Deviations or plan shard: candidate extraction is `handle_remote_link` + `handle_comment` into a `interactions.rs` shard. `auto_pr: FALSE`.

---

## Prior Findings Still Open (not re-reported, tracked for delta)

| ID | Status | Notes |
|----|--------|-------|
| PF-001 | OPEN | `#[allow(dead_code)]` on `refresh_coordinator.rs::reset_for_test` — harmless, technically belt-and-suspenders |
| PF-002 | OPEN | `#[allow(clippy::too_many_lines)]` justification comment placement style |
| PF-008 | OPEN (downgraded) | `expect()` without Result propagation in assets/linked.rs — documented invariant, low risk |

---

## JSON Render Invariant (#526) — Assessment

`println!("{}", output::render_json(...)?)` is used in 19 places across `src/cli/`. This is NOT a violation: `render_json` is still called, which delegates to `serde_json::to_string_pretty`. The invariant forbids **bypassing** `render_json`; wrapping the result in `println!` instead of using `print_output` is a stylistic difference appropriate for "no-log facade" commands (output-channel profile 5). Direct `to_string_pretty` calls: ZERO found in `src/cli/`.

**Invariant status: CLEAN.**

---

## Multi-Profile Boundary — Assessment

All 12 public cache functions take `profile: &str` as first argument. Verified for all functions in `src/cache.rs`. No new cache functions were added since the prior sweep.

**Boundary status: CLEAN.**

---

## Module Shard Rule (ADR-0012) — Assessment

Files in `src/cli/` at or above 1,000 LOC:

| File | LOC | Status |
|------|-----|--------|
| `src/cli/issue/create.rs` | 2,880 | Shard candidate — undocumented (PF-016) |
| `src/cli/issue/workflow.rs` | 1,341 | Shard candidate — undocumented (PF-017) |
| `src/cli/issue/list.rs` | 1,256 | Documented in CLAUDE.md Known Size Deviations |
| `src/cli/auth/tests/mod.rs` | 1,018 | Test-only module — shard rule applies to handler code; test modules are not shard candidates per ADR-0012 spirit |

ADR-0012 exceptions (adf.rs, api/auth.rs) confirmed exempt.

---

## Unsafe Blocks — Assessment

All `unsafe` blocks in `src/cache.rs` are within `#[cfg(debug_assertions)]` or `#[cfg(test)]` test helper functions (`with_temp_cache`, `with_env_var`). Each carries a `// SAFETY:` comment explaining the mutex serialization invariant. No production `unsafe` blocks found.

**Unsafe status: CLEAN.**

---

## Test Naming Convention — Assessment

New tests added by commit 35e20c9 (ADF recursion guard) follow the canonical `test_<verb>_<subject>_<outcome>` form:
- `test_max_adf_depth_constant_is_256` ✓
- `test_markdown_to_adf_depth_255_blockquote_is_ok` ✓
- `test_adf_to_text_depth_256_is_err` ✓
- `test_normalize_list_item_content_depth_increment_kills_mutant` ✓

Short pre-convention names in `src/cli/issue/json_output.rs` (`test_edit`, `test_link`, `test_unassign`) are legacy (file last touched by commits before 2025 v0.5 era) — exempt per convention policy.

**Convention status: CLEAN for new tests.**

---

## FINDINGS SUMMARY

| ID | Severity | Category | File | Auto-fixable? | Delta |
|----|----------|----------|------|---------------|-------|
| PF-007 | — | — | view.rs:87 | — | FALSE POSITIVE (closed) |
| PF-008 | LOW | code-quality | assets/linked.rs:228 | Yes | Downgraded from HIGH (PF-005) |
| PF-009 | — | — | field_resolve.rs:711,715 | — | FALSE POSITIVE — test-only |
| PF-010 | MEDIUM | code-quality | assets/schemas.rs:23 | Yes (comment) | NEW |
| PF-011 | MEDIUM | code-quality | assets/schemas.rs:266 | Yes (comment) | NEW |
| PF-012 | LOW | maintainability | auth/keychain.rs:169,198 | Yes (expect) | NEW |
| PF-013 | LOW | code-quality | issue/list.rs:410 | Yes (expect) | NEW |
| PF-014 | LOW | maintainability | issue/helpers.rs:506 | Yes (expect) | NEW |
| PF-015 | LOW | maintainability | src/adf.rs | No (ADR exempt) | NEW — informational |
| PF-016 | MEDIUM | maintainability | issue/create.rs | No (manual) | NEW (pre-existing, untracked) |
| PF-017 | LOW | maintainability | issue/workflow.rs | No (manual) | NEW (pre-existing, untracked) |

**TOTAL NEW:** 9 findings (2 MEDIUM, 5 LOW, 2 FALSE POSITIVE closed)
**RESOLVED FROM PRIOR:** PF-003, PF-004 fully resolved; PF-005 downgraded to LOW (PF-008); PF-006 re-classified as non-finding.
**STILL OPEN FROM PRIOR:** PF-001, PF-002 (both LOW).

---

## VERDICT

`CONVERGENCE_REACHED` for HIGH/CRITICAL class — no HIGH or CRITICAL findings remain open. Two MEDIUM findings remain (PF-010, PF-011, PF-016): all are missing-comment or undocumented-size-deviation issues, not correctness bugs. The codebase is consistent with its own patterns. `auto_pr: FALSE` for all remaining items.
