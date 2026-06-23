# Pattern Consistency Findings — Maintenance Sweep 3
**Date:** 2026-06-22
**Scope:** `src/` — grep/rg-based scan only. No cargo build, no cargo test.

---

## Toolchain Health

| Check | Status |
|-------|--------|
| `cargo clippy` | CLEAN (confirmed by prior sweep; not re-run per efficiency constraint) |
| `cargo fmt --all -- --check` | PASS (exit 0) |

---

## Finding Table

| ID | Finding | File(s) | Auto-fixable? | Severity |
|----|---------|---------|---------------|----------|
| PF-001 | `#[allow(dead_code)]` on `#[cfg(test)]` function in `refresh_coordinator.rs` has a justification comment but is technically unnecessary — `#[cfg(test)]` already gates out the dead_code warning in release builds; the `allow` is a belt-and-suspenders addition that is harmless but inconsistent with the "no lint suppression without refactoring" policy | `src/api/refresh_coordinator.rs:56` | Yes (remove the `allow`) | LOW |
| PF-002 | `#[allow(clippy::too_many_lines)]` in `adf.rs` has an adjacent justification comment explaining combinatorial coverage guarantee — suppression is justified per spirit of policy but the comment should be on the line immediately above the attribute (it currently appears 3 lines above, inside the comment block body) | `src/adf.rs:8488` | No (style judgment) | LOW |
| PF-003 | `extract_job_block` helper function body is duplicated verbatim across three test files; test helpers cannot share via `tests/common/` easily for non-`#[cfg(test)]` free functions, but the duplication creates a shotgun-surgery risk when the YAML-parsing logic changes | `tests/backfill_matrix_parity.rs:158`, `tests/ci_gate_completeness.rs:66`, `tests/ci_yml_windows_matrix.rs:68` | Yes (extract to `tests/common/ci_yaml.rs`) | MEDIUM |
| PF-004 | Two keyring guard idioms coexist: `is_err()` (accepts any non-"1" value including `"0"`) used in `tests/auth_profiles.rs` and `src/api/auth.rs`; `!= Ok("1")` (strict exact match) used in `tests/multi_cloudid_disambiguation.rs`, `tests/oauth_refresh_integration.rs`, `tests/auth_output_json.rs`. CLAUDE.md cites `as_deref() != Ok("1")` as the canonical form. The `is_err()` idiom would silently skip tests when `JR_RUN_KEYRING_TESTS` is set to `"0"`, masking false passes | `tests/auth_profiles.rs:210,322,372`, `src/api/auth.rs:1349` | Yes (align to `!= Ok("1")`) | MEDIUM |
| PF-005 | Production `unwrap()` on `assets[idx].id` in `src/api/assets/linked.rs:225` — the field is `Option<String>` and no prior guard establishes it is `Some` at that point. The adjacent `expect(…)` on `workspace_id` has an explicit justification string; `oid` has none. If a CMDB object returns without an `id`, this panics in production | `src/api/assets/linked.rs:225` | Yes (use `ok_or(JrError…)?`) | HIGH |
| PF-006 | `println!("{}", output::render_json(&data)?)` in `src/cli/sprint.rs:147` and `src/cli/sprint.rs:263` routes through `render_json` (correct invariant), but uses `println!` on the return value rather than `print_output`. This is not a violation (render_json IS called), but it deviates from the pattern used everywhere else (`print_output` or the `render_json` + immediate return). Minor pattern drift; `sprint_remove_response` at line 147 uses `println!` while `sprint_add_response` at line 122 uses the clean form (`output::render_json(&…)?`) without println! wrapping — two subtly different idioms in the same file | `src/cli/sprint.rs:122,147` | Yes (normalize to `print_output` or consistent render_json call) | LOW |

---

## Known Drift Items — Status

### DRIFT-331-PAGINATION
**Status: REFUTED (already addressed)**
`get_issue_types_for_project` (`src/api/jira/issues.rs:705`) uses inline manual offset pagination rather than the `OffsetPage<T>` abstraction. This is INTENTIONAL and documented in rustdoc: the `PageOfCreateMetaIssueTypes` response uses a different JSON shape (`issueTypes`, not `values`; no `isLast`) that is incompatible with the generic `OffsetPage<T>` struct. The manual loop is the correct solution. Not a drift item.

### KEYRING-GUARD-IDIOM-DRIFT
**Status: CONFIRMED — two idioms coexist**
- Strict form (`as_deref() != Ok("1")`): `tests/multi_cloudid_disambiguation.rs`, `tests/oauth_refresh_integration.rs`, `tests/auth_output_json.rs`
- Loose form (`is_err()`): `tests/auth_profiles.rs` (lines 210, 322, 372), `src/api/auth.rs` (line 1349)

CLAUDE.md lists tests using the strict form as canonical. The `is_err()` idiom lets `JR_RUN_KEYRING_TESTS=0` (or any non-"1" value) cause tests to skip silently instead of erroring, which is technically more lenient but inconsistent with stated policy. Recorded as PF-004.

### DRIFT-CR-008 (extract_job_block)
**Status: CONFIRMED — three copies**
Identical or near-identical function bodies in `tests/backfill_matrix_parity.rs:158`, `tests/ci_gate_completeness.rs:66`, `tests/ci_yml_windows_matrix.rs:68`. The `backfill_matrix_parity.rs` copy uses `yaml` as the parameter name while the other two use `ci_yml`; the logic is otherwise the same. Recorded as PF-003.

---

## JSON Render Invariant (#526) — Detailed Assessment

All `serde_json::json!` usages in `src/cli/` fall into two categories:

1. **Building API request payloads** (sent to Jira, not printed) — `src/cli/issue/workflow.rs`, `src/cli/issue/field_resolve.rs`, `src/cli/assets/search.rs`. Not a violation.
2. **Building JSON output values that are then passed to `output::render_json` or `output::print_output`** — `src/cli/auth/mod.rs`, `src/cli/auth/list.rs`, `src/cli/auth/refresh.rs`, `src/cli/requesttype.rs`, `src/cli/project.rs`, `src/cli/sprint.rs`. Correct — all route through `render_json`.

No direct `to_string_pretty` violations found in `src/cli/`. Invariant is CLEAN.

---

## Test Naming Convention Assessment

The convention (`test_<verb>_<subject>_<outcome>`) applies to new tests from S-2.07 v2.0.0 onward. Legacy tests in `tests/auth_profiles.rs` (no-prefix style: `auth_switch_unknown_profile_exits_64`, etc.) were created before the convention and are exempt from renaming per spec. New test functions observed in recent additions follow the canonical form. No violation found for new tests.

The 826 canonical-prefix tests (`fn test_`) vs 198 legacy no-prefix test functions in integration tests is consistent with the spec's intentional coexistence policy.

---

## FINDINGS: 6 (1 HIGH, 2 MEDIUM, 3 LOW)
