---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: consistency-validator
timestamp: 2026-07-29T00:00:00
phase: F2
inputs: []
input-hash: "[pending-recompute]"
traces_to: ""
pass: 80
previous_review: null
cycle: cycle-001
bundle: SOH-DX-1
aperture: reality-check
spec_version: v1.3.165
date: 2026-07-29
basis: DEC-190 substitute (consistency-validator, not adversary agent)
isolation: sibling reviews not read
---

# Adversarial Review — SOH-DX-1 F2, Pass 80

## Aperture

Reality-check: verify factual claims about third-party crate APIs, version numbers, actual `src/` behavior at HEAD (acdad174), and CI workflow contents. Does NOT evaluate internal spec consistency, story decomposition quality, or UX acceptability.

## Perimeter

Bundle SOH-DX-1 covers three issues:

- **#639** (HIGH, BREAKING): `--field` / `--on-behalf-of` on `jr issue create` without `--request-type` — warn-and-proceed (exit 0) → pre-flight exit-64 (BC-3.8.012/013 superseded)
- **#627** (LOW): `check-bc-no-numeric-test-counts.sh` guard-regex fix + factory-artifacts hyphenation revert
- **#626** (LOW/MED): MSRV false-green fix — `RUSTUP_TOOLCHAIN` outranks `rust-toolchain.toml` — plus `dtolnay/rust-toolchain` SHA pin to `fa04a1451ff1842e2626ccb99004d0195b455a88`

Spec range reviewed: v1.3.161–v1.3.165 (spec-changelog.md).

## Checklist Coverage

| # | Item | Verdict |
|---|------|---------|
| 1 | wiremock 0.6 `.expect(0)` / `.expect(1)` API validity; Group 20 holdout wiremock patterns | PASS |
| 2 | Crate version citations match Cargo.toml / Cargo.lock | PASS |
| 3 | `src/cli/issue/create.rs` actual behavior at acdad174 vs. spec "[CURRENT BEHAVIOR]" label | PASS (intentional F2/F4 VSDD convention) |
| 4 | PR #661 CLAUDE.md description staleness | FINDING P80-001 (REFINEMENT, OUT-OF-DELTA) |
| 5 | [1.3.162] replacement test symbols exist in `src/adf.rs` | PASS |
| 6 | CI/workflow claims: msrv job existence, ci-gate needs, `rustup target add` defensive steps, checkout version | PASS |
| 7 | MSRV three-way disagreement (Cargo.toml=1.85, rust-toolchain.toml=stable, ci.yml msrv=c93f4f9c no toolchain input) | PASS (correctly diagnosed in spec) |
| 8 | SHA-pin `fa04a1451ff1842e2626ccb99004d0195b455a88` plausibility; current pin c93f4f9c confirmed across 6 workflow files | PASS (prior delta-analysis §5e DISCHARGED accepted; no new network calls per task constraint) |
| 9 | Error strings mutually identical: error-taxonomy.md §6, BC-3.8.012/013, Group 20 holdouts; H-NEW-PREFLIGHT-006 JSON envelope | PASS |
| 10 | Atlassian API claims in v1.3.161–v1.3.165 | PASS (no new Atlassian API claims in this range) |
| 11 | v1.3.161–165 spec-changelog correctness: ADR locations, RS-001 BC-INDEX prose, [1.3.162] replacements, Group 20 holdout formation, H-NEW-PREFLIGHT-004 "stdout contains" tightening | PASS — all applied and confirmed |

Additionally verified: BC-3.8.012/013 phantom test citations (F4 delivery targets) — FINDING P80-002 (REFINEMENT, IN-DELTA).

## Finding ID Convention

Finding IDs in this pass use the format `P80-NNN` (pass-scoped sequential) per the task brief for SOH-DX-1 F2 consistency-validator passes. Standard `ADV-<CYCLE>-P<PASS>-<SEV>-<SEQ>` format would be `ADV-CYCLE001-P80-LOW-001` / `ADV-CYCLE001-P80-LOW-002`.

## Part B — New Findings (or all findings for pass 1)

### LOW

#### P80-001 — CLAUDE.md stale descriptions after PR #661

- **Severity:** LOW
- **Category:** spec-fidelity
- **Classification:** REFINEMENT (does not mislead F4 implementer; affects only documentation readers)
- **Provenance:** OUT-OF-DELTA. PR #661 commit message explicitly labels these "PRE-EXISTING and OUT-OF-DELTA relative to the active SOH-DX-1 cycle."
- **Location:** `CLAUDE.md` lines ~367 and ~385

**Evidence:**

`scripts/check-spec-counts.sh` lines 33–39 contain a POL-11 coverage floor (exit 2 when no bc files found) and a changed success message: `"Check passed: $BC_FILES_PROCESSED bc files validated"`.

CLAUDE.md documents this script as: "Exits 0 if frontmatter counts match body counts. Exits 1 with specific mismatch details if drift is detected." — missing the exit 2 path and the changed success message wording.

`tests/claude_md_citations.rs` contains `CITATION_FLOOR: usize = 74` and a `citations.len() >= CITATION_FLOOR` assertion (PR #661 addition). CLAUDE.md's description does not mention this floor constant.

**Proposed Fix:** Update CLAUDE.md to add "Exits 2 if no bc files are found (POL-11)." to the `check-spec-counts.sh` entry, and note `CITATION_FLOOR = 74` in the `claude_md_citations.rs` entry. These are polish items with no F4 impact.

---

#### P80-002 — BC-3.8.012/013 cites future test names (F4 delivery targets)

- **Severity:** LOW
- **Category:** spec-fidelity
- **Classification:** REFINEMENT (spec correctly labels these as F4 obligations; no incorrect factual claim)
- **Provenance:** IN-DELTA. Introduced v1.3.107 SOH-DX-1 DEC-188 F2 amendment; test names are delivery targets for F4 phase.
- **Location:** `.factory/specs/prd/bc-3-issue-write.md` BC-3.8.012/013 Trace/AC; `tests/issue_create_jsm.rs`; `tests/common/fixtures.rs`

**Evidence:**

Spec cites test names not yet existing at `acdad174`:
- `test_platform_create_field_flag_exits_64_without_request_type`
- `test_platform_create_both_inverse_flags_exit_64`
- `test_platform_create_field_idempotent_one_error_per_logical_flag`
- `test_platform_create_malformed_field_without_request_type_exits_64`
- `write_profile_config` helper in `tests/common/fixtures.rs`

Current names in `tests/issue_create_jsm.rs` (warn-and-proceed era):
- `test_platform_create_field_flag_emits_warning_without_request_type` (line 2420)
- `test_platform_create_on_behalf_of_flag_emits_warning_without_request_type` (line 2493)
- `test_platform_create_both_inverse_flags_emit_independent_warnings` (line 2564)
- `test_platform_create_field_idempotent_one_warning_per_logical_flag` (line 2687)
- `test_platform_create_malformed_field_one_warning_no_exit_64` (line 2812)

The spec uses inline `(renamed from X)` notation, signaling these are F4 rename obligations.

**Proposed Fix:** No spec change needed. F4 implementer must rename the five test functions per spec parentheticals, add `write_profile_config` to `tests/common/fixtures.rs`, and update assertions from warn-check to exit-64-check. Finding is informational.

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 0 |
| LOW | 2 |

**Overall Assessment:** pass-with-findings
**Convergence:** CONVERGENCE_REACHED (both findings are REFINEMENT; zero in-delta GAPs)
**Readiness:** ready for next phase

VERDICT: CLEAN (no in-delta GAPs)

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 80 |
| **New findings** | 2 |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 1.0 (2 / (2 + 0)) |
| **Median severity** | 1.0 (both LOW) |
| **Trajectory** | pass 80: 2 findings (both REFINEMENT, 0 GAPs) |
| **Verdict** | CONVERGENCE_REACHED |
