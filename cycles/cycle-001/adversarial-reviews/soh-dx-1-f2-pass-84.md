---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: consistency-validator
timestamp: 2026-07-29T00:00:00
phase: F2
inputs:
  - .factory/phase-f1-delta/SOH-DX-1/delta-analysis.md
  - .factory/specs/prd/bc-3-issue-write.md
  - .factory/specs/prd/holdout-scenarios.md
  - .factory/spec-changelog.md
  - .factory/stories/S-383-platform-inverse-warnings.md
  - src/cli/issue/create.rs
  - src/main.rs
  - tests/issue_create_jsm.rs
input-hash: "add2c56"
traces_to: .factory/specs/prd/bc-3-issue-write.md
pass: 84
previous_review: null
cycle: cycle-001
bundle: SOH-DX-1
aperture: AC-falsification-against-build + delta-completeness
spec_version: v1.3.166
date: 2026-07-29
basis: DEC-190 substitute (consistency-validator, not adversary agent)
isolation: sibling reviews not read
---

# Adversarial Review — Pass 84 (SOH-DX-1 F2)

## Aperture

AC-FALSIFICATION-AGAINST-BUILD + DELTA-COMPLETENESS at spec v1.3.166.

Two-dimensional audit:

- **Dimension A**: For each of AC-1..AC-21, does the AC fail against the current binary (still warn-and-proceed)? Can it ever pass against a correct implementation? Are stream citations correct? Are non-event ACs grounded by would-otherwise-succeed contexts? Are negative substrings specific enough?
- **Dimension B**: Exhaustive enumeration of every obligation in `delta-analysis.md`, with discharge disposition.

## Perimeter

- `/Users/zious/Documents/GITHUB/jira-cli/.factory/phase-f1-delta/SOH-DX-1/delta-analysis.md` — F1 analysis (PRIMARY for Dimension B)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/bc-3-issue-write.md` — AC-1..AC-21 (PRIMARY for Dimension A), §3.8, S-639-1 F4 obligations
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/holdout-scenarios.md` — Group 20 (H-NEW-PREFLIGHT-001..006)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/spec-changelog.md` — [1.3.161]..[1.3.166]
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/stories/S-383-platform-inverse-warnings.md`
- `src/cli/issue/create.rs`, `src/main.rs`, `src/output.rs`, `src/error.rs`, `tests/issue_create_jsm.rs`

## Current Binary State

`src/cli/issue/create.rs` lines 78–90 contain the pre-DEC-188 warn-and-proceed behavior:

```rust
if !field_pairs.is_empty() {
    eprintln!("warning: --field is ignored on the platform create path; ...");
}
if on_behalf_of.is_some() {
    eprintln!("warning: --on-behalf-of is ignored on the platform create path; ...");
}
```

This is the OLD S-383 behavior. The spec (BC-3.8.012/013 amended 2026-07-25 at v1.3.107) requires `JrError::UserError` exit-64 pre-flight with three distinct error strings (single-flag `--field`, single-flag `--on-behalf-of`, combined both). The implementation delta is NOT yet applied. All 7 renamed/inverted tests in `tests/issue_create_jsm.rs` still carry OLD names and OLD assertions.

## Critical Stream Facts

- **Human-mode errors**: `src/main.rs:143` → `eprintln!("Error: {e}")` → **stderr**. Human-mode errors ALWAYS go to stderr.
- **JSON-mode errors**: `src/main.rs:134–140` → `eprintln!("{}", serde_json::json!({...}))` → **stderr**. No "Error: " prefix in JSON mode; compact; key order alphabetical by serde_json default.
- **Table-mode success** (`print_success`): `src/output.rs::print_success` → `eprintln!` → **stderr**; stdout empty. Confirmed by `tests/issue_create_echo.rs` four-site assertion; corrected for H-NEW-PREFLIGHT-004 at v1.3.166.

## Dimension A — AC Falsification Table

| AC | Would FAIL against current binary? | Could ever PASS? | Spec label | Verdict |
|----|-----------------------------------|-----------------|-----------|---------|
| AC-1 | YES — exits 0 not 64; emits old warning not new error | YES | DISCRIMINATING | SOUND |
| AC-2 | YES — exits 0; JSON success to stdout not error envelope to stderr | YES | DISCRIMINATING | SOUND |
| AC-3 | YES — two independent warnings, exits 0; no combined error | YES | DISCRIMINATING | SOUND |
| AC-4 | NO — regression pin (no flags → no guard → exit 0) | YES | FALSIFIABLE-COARSE | SOUND |
| AC-5 | YES — exits 0; ONE warning fires but not exit 64 | YES | DISCRIMINATING | SOUND |
| AC-6 | NO — JSM dispatch at `create.rs:49` fires before guard; exit 0 | YES | FALSIFIABLE-COARSE | SOUND |
| AC-7 | YES — exits 0 with old warning, not exit 64 (old name contradicted new behavior) | YES | DISCRIMINATING | SOUND |
| AC-8 | YES — helper HTTP fires (guard absent); `received_requests().is_empty()` violated | YES | DISCRIMINATING (normative zero-HTTP) | SOUND |
| AC-9 | YES — proceeds to project lookup; exits 64 with "Project key is required" not guard string | YES | DISCRIMINATING (ordering proof via `!stderr.contains`) | SOUND |
| AC-10 | YES — exits 0; JSON success to stdout; error envelope never emitted | YES | DISCRIMINATING | SOUND |
| AC-11 | YES — proceeds to interactive prompt (TTY mode); no exit 64 before prompt | YES | DISCRIMINATING | SOUND |
| AC-12 | YES — `src/cli/mod.rs` help text not yet updated; count == 0 not 2 | YES | HYGIENE | SOUND |
| AC-13 | YES — two independent warnings fire, no combined error, no exit 64 | YES | DISCRIMINATING | SOUND |
| AC-14 | NO — `--request-type ""` is `Some("")`; routes JSM; BC-3.8.016 fires (empty RT); BC-3.8.012 absent | YES | FALSIFIABLE-COARSE | SOUND |
| AC-15 | NO — clap `conflicts_with` fires pre-handler; exits 2; guard unreachable | YES | HYGIENE | SOUND |
| AC-16 | YES — `--on-behalf-of ""` fires old warning, proceeds; no exit 64; `!stderr.contains("is ignored")` fails | YES | DISCRIMINATING | SOUND |
| AC-17 | YES — warns and proceeds; no exit 64 | YES | DISCRIMINATING | SOUND |
| AC-18 | YES — warns, proceeds; stdin IS consumed by spawn_blocking; no exit 64 | YES | DISCRIMINATING | SOUND |
| AC-19 | YES — `--field a=` parses to non-empty vec; warns, proceeds; no exit 64 | YES | DISCRIMINATING | SOUND |
| AC-20 | NO — JSM dispatch routes before guard; exit 0; no guard strings | YES | FALSIFIABLE-COARSE | SOUND |
| AC-21 | NO — JSM dispatch routes before guard; exit 0; no combined guard string | YES | FALSIFIABLE-COARSE | SOUND |

**Summary**: 14 of 21 ACs would FAIL against the current warn-and-proceed binary. 7 of 21 pass (all legitimate regression gates). No AC is permanently unsatisfiable at spec v1.3.166.

**CRITICAL correction at v1.3.166**: v1.3.165 introduced a permanently unsatisfiable assertion in H-NEW-PREFLIGHT-004 ("stdout contains PROJ-42" — wrong because `print_success` uses `eprintln!` → stderr). v1.3.166 corrected to "stderr contains Created issue PROJ-42" + "stdout.trim().is_empty()". All 21 ACs reflect the corrected spec.

## Dimension B — Obligation Enumeration

All obligations from `delta-analysis.md` with disposition: DISCHARGED, DEFERRED, or NON-GOAL.

### Item 1 — S-639-1 (warn-to-error promotion)

| # | Obligation | Disposition |
|---|-----------|-------------|
| 1 | `src/cli/issue/create.rs` lines 81–90: replace two eprintln! guards with `JrError::UserError` pre-flight exit-64 | DEFERRED — F3/F4 implementation, S-639-1 |
| 2 | `tests/issue_create_jsm.rs` AC-1/2/3/5 inversions (exit-0 to exit-64, warning to error) | DEFERRED — F3 |
| 3 | `tests/issue_create_jsm.rs` AC-7 rename and body inversion | DEFERRED — F3 |
| 4 | `tests/issue_create_jsm.rs` AC-4 body update (remove vacuous negatives; add new-error-string negatives) | DEFERRED — F3 |
| 5 | `tests/issue_create_jsm.rs` AC-6 body update (remove old-warn negative; add three new-error-string negatives) | DEFERRED — F3 |
| 6 | `Cargo.toml` version bump to 0.7.0-dev.1 (DEC-188 clause (d)) | DEFERRED — F4 |
| 7 | `CHANGELOG.md` Breaking Changes entry for v0.7.0 citing DEC-188, BC-3.8.012/013 | DEFERRED — F4 |
| 8 | `CLAUDE.md:~248` dispatch-fork gotcha amendment (deliverable (b)) | DEFERRED — F4 |
| 9 | `docs/adr/0014-jsm-request-type-dispatch.md` amendment at four sites (deliverable (a)) | DEFERRED — F4 |
| 10 | `bc-3-issue-write.md` BC-3.8.012 body supersession | DISCHARGED — v1.3.107 2026-07-25; `[AMENDED 2026-07-25 SOH-DX-1 DEC-188 #639]` block confirmed |
| 11 | `bc-3-issue-write.md` BC-3.8.013 body supersession | DISCHARGED — v1.3.107 2026-07-25 |
| 12 | BC-3.3.001 amendment note updated to reflect exit-64 | DISCHARGED — BC-INDEX row 274 confirmed |
| 13 | `BC-INDEX.md` rows BC-3.8.012 and BC-3.8.013 updated | DISCHARGED — BC-INDEX lines 361–362 with `[AMENDED DEC-188 2026-07-25]` confirmed |
| 14 | AC-5 idempotency: ONE error regardless of `--field` count | DISCHARGED — BC-3.8.012 `[CURRENT BEHAVIOR]` block explicit |
| 15 | BC-3.3.001 amendment note wording drafted | DISCHARGED — BC-INDEX row 274 and bc-3 trace confirm |
| 16 | E2E blast radius audit: zero `issue create --field` without `--request-type` in e2e_live.rs | DISCHARGED — §5 confirms zero blast radius; BC-3.8.012 Trace deliverable (g) reconfirms |
| 17 | SEMVER: breaking change rides 0.6→0.7 bump (DEC-188 clause (d)) | DISCHARGED — §7 Q1 resolved; 0.7.0-dev.1 encoded in spec |
| 18 | AC-3 combined-error semantics: ONE combined error when both flags present | DISCHARGED — BC-3.8.012 combined-error path specified; three distinct verbatim strings defined |

### Item 2 — S-627-1 (PG-365-1 guard regex)

| # | Obligation | Disposition |
|---|-----------|-------------|
| 19 | `scripts/check-bc-no-numeric-test-counts.sh`: left-boundary regex fix and seams | DEFERRED — F3 S-627-1 Wave 1 |
| 20 | `bc-2-issue-read.md` revert hyphenation workaround (post-script-fix) | DEFERRED — F3 S-627-1 Wave 1b |
| 21 | `bc-3-issue-write.md` revert hyphenation workaround | DEFERRED — F3 S-627-1 Wave 1b |
| 22 | Sequencing: script fix MUST merge on develop before factory-artifacts revert | DEFERRED — enforced at S-627-1 delivery time |

### Item 3 — S-626-1 (rust-toolchain SHA pins and MSRV)

| # | Obligation | Disposition |
|---|-----------|-------------|
| 23 | `ci.yml` stable (line 98) and msrv (line 70) SHA replacement and explicit inputs | DEFERRED — F3 S-626-1 Wave 1 |
| 24 | `backfill-release.yml` SHA replacement and toolchain input | DEFERRED — F3 |
| 25 | `e2e-sweeper.yml` SHA replacement and toolchain input | DEFERRED — F3 |
| 26 | `e2e.yml` SHA replacement and toolchain input | DEFERRED — F3 |
| 27 | `release.yml` SHA replacement and toolchain input | DEFERRED — F3 |
| 28 | `sign-and-publish.yml` SHA replacement and toolchain input | DEFERRED — F3 |
| 29 | `CLAUDE.md` toolchain masking gotcha note | DEFERRED — F3 |

### Risks and Constraints

| # | Obligation | Disposition |
|---|-----------|-------------|
| 30 | `sign-and-publish.yml` and `backfill-release.yml` defensive `rustup target add` (§5d): assess at F4; do NOT remove now | NON-GOAL — cross-compilation build requirement, not fix artifact |
| 31 | S-626-1: verify full 40-char SHA `fa04a1451ff1842e2626ccb99004d0195b455a88` before F4 embeds it | DISCHARGED — §5e confirms discharge; SHA dated 2026-06-30, master ancestor confirmed |
| 32 | S-626-1 F3 blocking pre-implementation AC pinning the verified SHA (§5e downstream obligation) | DEFERRED — STATE.md-only per §5e; to become S-626-1 story content at F3 |

**Obligation totals**: 32 obligations; 7 DISCHARGED, 20 DEFERRED, 1 NON-GOAL, 0 ABSENT, 0 SPEC-ABSENT.

## Checklist Coverage

**Item 1 (per-AC falsification)**: Completed. See Dimension A table — 14 fail, 7 pass (legitimate regression gates).

**Item 2 (per-AC satisfiability)**: Completed. All 21 ACs satisfiable with correct implementation. No permanently unsatisfiable ACs at v1.3.166 (v1.3.165 defect corrected).

**Item 3 (stream/observable correctness)**: Completed. Human error → `src/main.rs:143` `eprintln!` → stderr. JSON error → `src/main.rs:134–140` `eprintln!` → stderr. Table success → `src/output.rs::print_success` `eprintln!` → stderr. All stream citations correct.

**Item 4 (non-event / zero-HTTP audit)**: Completed. AC-4, AC-6, AC-8, AC-14, AC-15, AC-20, AC-21 all have would-otherwise-succeed contexts established. AC-8 zero-HTTP proof via `received_requests().await.unwrap().is_empty()` on isolated MockServer — robust.

**Item 5 (negative-assertion substring specificity)**: Completed. AC-17's negative narrowed at v1.3.152 to exact BC-3.8.017 literal. AC-3's single-flag absence assertions non-overlapping with combined string. All negative substrings specific enough.

**Item 6 (label accuracy)**: Completed. DISCRIMINATING labels on genuine guarded-invocation assertions. FALSIFIABLE-COARSE on absence-of-error assertions in regression gates. HYGIENE on clap-precedence and help-text ACs. No overstatement found.

**Item 7 (obligation enumeration)**: Completed. 32 obligations enumerated across Items 1, 2, 3 and risks/constraints.

**Item 8 (disposition marking)**: Completed. 7 DISCHARGED, 20 DEFERRED, 1 NON-GOAL. BC-3.8.012 Trace deliverables (a)–(f) extend F1 impact scope — spec-authority extension, not GAP; see ADV-P84-LOW-001.

**Item 9 (§5e scrutiny)**: Completed. SHA `fa04a1451ff1842e2626ccb99004d0195b455a88` dated 2026-06-30, master ancestor confirmed. Non-master-ancestry of currently-pinned `c93f4f9c` correctly characterized as version-branch commit. §5e adequately evidences discharge and preserves downstream F3 obligation.

**Item 10 (holdout ruling discharge)**: Completed. Human ruling overturned F51-001 non-goal. 6 MUST-PASS scenarios H-NEW-PREFLIGHT-001..006 authored. BC-3.8.012 Trace cites H-001/003/004/005/006; BC-3.8.013 Trace cites H-002/003/004/005 — appropriate distribution. All behavioral cases covered.

**Item 11 (counts)**: Completed. `grep -c "^### H-"` = 106 matches `total_holdouts: 106`. BC-3.8 range = 17 BCs (001..017). BC-3 `total_bcs: 140` / `definitional_count: 111`. Total `total_bcs: 657`. Both scripts EXIT 0.

**Item 12 (range-terminus verification)**: Completed. AC-1..21 enumerated by grep = 21 exact. H-NEW-PREFLIGHT-001..006 confirmed at holdout-scenarios.md lines 2575–2756. H-018 legitimately absent. BC-3.8 range: 001..017 full enumeration, no gaps.

**Item 13 (S-383 staleness)**: Completed. `contract_superseded_by: "SOH-DX-1 (DEC-188) / S-639-1"` correct. Banner names S-639-1 as implementing successor. SOUND.

## Finding ID Convention

Finding IDs for this pass use the format: `ADV-P84-<SEV>-<SEQ>` (no cycle prefix; no `.factory/current-cycle` file present in this project).

## Part A — Fix Verification (pass >= 2 only)

N/A — first adversarial pass on SOH-DX-1 F2 AC-verification aperture. No prior pass findings to verify.

## Part B — New Findings (or all findings for pass 1)

### CRITICAL

(none)

### HIGH

(none)

### MEDIUM

(none)

### LOW

#### ADV-P84-LOW-001: delta-analysis.md underscopes doc-fallout delivery files

- **Severity:** LOW
- **Category:** spec-fidelity
- **Location:** `.factory/phase-f1-delta/SOH-DX-1/delta-analysis.md` §6 affected-files-summary; BC-3.8.012 Trace deliverables (a)–(f)
- **Description:** `delta-analysis.md` §6 lists develop-branch change files as `src/cli/issue/create.rs`, `tests/issue_create_jsm.rs`, `Cargo.toml`, `CHANGELOG.md`, `bc-3-issue-write.md`, `BC-INDEX.md`, `CLAUDE.md`, `docs/adr/0014-jsm-request-type-dispatch.md`. BC-3.8.012 Trace deliverables (a)–(f), authored during F2 adversary passes post-dating the F1 delta-analysis, add four additional required delivery files: `src/cli/mod.rs` (help-string update, deliverable (d), pinned by AC-12), `src/cli/issue/jsm_create.rs` (comment correction, deliverable (e)), comment corrections in `tests/issue_create_jsm.rs` beyond the 5 test inversions (deliverable (e)), and `docs/specs/issue-create-preflight-guards.md` new feature spec (deliverable (f), per ADR-0004 convention).
- **Evidence:** BC-3.8.012 Trace at spec line 3137 enumerates deliverables (a)–(f) explicitly. Delta-analysis.md §6 does not list `src/cli/mod.rs` or `docs/specs/issue-create-preflight-guards.md`. Delta-analysis ratified 2026-07-25; deliverables specified during F2 passes (v1.3.107–v1.3.166).
- **Classification:** IN-DELTA (spec evolution within SOH-DX-1 F2 window); REFINEMENT not GAP (BC-3.8.012 Trace is authoritative; no behavioral specification is incorrect).
- **Proposed Fix:** Update delta-analysis.md §6 to add `src/cli/mod.rs`, `src/cli/issue/jsm_create.rs`, and `docs/specs/issue-create-preflight-guards.md` under develop-branch changes; or add a footnote citing BC-3.8.012 Trace deliverables (a)–(f) as the authoritative extended scope.

#### ADV-P84-LOW-002: README.md holdout enumeration description stale

- **Severity:** LOW
- **Category:** spec-fidelity
- **Location:** `.factory/specs/prd/README.md` row 108 holdout enumeration description
- **Description:** README.md holdout row says "106 holdout scenarios (H-001..H-047 + H-NEW-MP-001 + H-NEW-VERBOSE-001/002 + H-NEW-AUTH-002 + H-NEW-JSM-RT-001..007)". The file now contains scenarios across many additional groups not listed: H-NEW-ADF-001..009, H-NEW-SEC-001..002, H-NEW-EDIT-FIELD, H-NEW-ATTACHMENT-001..012, H-NEW-COMMENT-001..005, H-NEW-PREFLIGHT-001..006, and others. The count (106) is correct; the row says "informational; canonical count is `total_holdouts:` frontmatter."
- **Evidence:** `grep -c "^### H-"` = 106 (count correct). README.md enumeration predates H-NEW-ATTACHMENT and H-NEW-COMMENT groups (prior deltas); H-NEW-PREFLIGHT compounds pre-existing staleness.
- **Classification:** OUT-OF-DELTA (staleness predates this delta; compounded not originated here); REFINEMENT/INFO. Guard coverage unaffected.
- **Proposed Fix:** Update README.md holdout row to list all current H-NEW-* groups; or simplify to "106 holdout scenarios across H-001..H-047 and multiple H-NEW-* groups (informational; canonical count is `total_holdouts:` frontmatter)."

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 0 |
| LOW | 2 |

**Overall Assessment:** pass  
**Convergence:** CONVERGENCE_REACHED — no GAPs found; 2 LOW REFINEMENT findings, one IN-DELTA documentation gap, one OUT-OF-DELTA pre-existing staleness; spec is satisfiable and all obligations are accounted for  
**Readiness:** ready for next phase (F3 implementation)

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 84 |
| **New findings** | 2 |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 1.0 (2 / (2 + 0)) |
| **Median severity** | 1.0 (both LOW REFINEMENT) |
| **Trajectory** | first pass on this aperture |
| **Verdict** | CONVERGENCE_REACHED |
