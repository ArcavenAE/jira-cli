---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: consistency-validator
timestamp: "2026-07-30T00:00:00"
phase: 4.5
inputs:
  - ".factory/stories/S-626-1.md"
  - ".factory/phase-f1-delta/SOH-DX-1/delta-analysis.md"
  - ".factory/stories/S-640-1.md"
input-hash: "32a7666"
traces_to: ".factory/stories/S-626-1.md"
pass: "C"
story: S-626-1
aperture: story-implementation alignment
basis: DEC-190 substitute (consistency-validator, not adversary agent)
isolation: sibling reviews not read
previous_review: null
---

# Adversarial Review: S-626-1 Step 4.5 Pass C — Story-Implementation Alignment

**Branch:** `ci/fix-toolchain-sha-msrv` (worktree `/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-626-1`)
**Base:** `origin/develop` @ `acdad174`
**Story version:** v1.3 (9 ACs)
**Commits reviewed:** 6 commits over base (`217c1f01` through `cc7f6da5`)

---

## Files Reviewed

| File | Role |
|------|------|
| `.factory/stories/S-626-1.md` | Story specification (v1.3, 9 ACs) |
| `.factory/phase-f1-delta/SOH-DX-1/delta-analysis.md` | Source-of-truth SHA discharge record |
| `.factory/stories/S-640-1.md` | Deferred-work handoff story |
| `.github/workflows/ci.yml` | AC-2, AC-3, AC-4 |
| `.github/workflows/backfill-release.yml` | AC-2, AC-5, AC-7 |
| `.github/workflows/e2e-sweeper.yml` | AC-2, AC-7 |
| `.github/workflows/e2e.yml` | AC-2, AC-7 |
| `.github/workflows/release.yml` | AC-2, AC-7 |
| `.github/workflows/sign-and-publish.yml` | AC-2, AC-5, AC-7 |
| `CLAUDE.md` | AC-6 |
| `Cargo.toml` | AC-8 |
| `Cargo.lock` | AC-8 (auto-updated) |
| `CHANGELOG.md` | Delivery checklist item 2 |
| `src/cli/board.rs` | AC-9 |
| `src/cli/issue/list.rs` | AC-9 |
| `src/cli/auth/keychain.rs` | AC-9 |

---

## Item 1: Per-AC Satisfaction Table (9 ACs)

| AC | Title | Status | Evidence |
|----|-------|--------|----------|
| AC-1 | Pre-implementation SHA verification (BLOCKING) | SATISFIED | `delta-analysis.md` section 5e records full 40-char SHA `fa04a1451ff1842e2626ccb99004d0195b455a88`, date 2026-06-30, title "Add 1.96.1 patch release", status "confirmed ancestor of master (behind_by: 0)" — discharge P71-001. The correct SHA — not the old `c93f4f9c`, not shortened — appears verbatim in all 6 workflow files, confirming the record was used. |
| AC-2 | All 6 workflow files: verified SHA + explicit toolchain input | SATISFIED | All 6 files contain `fa04a1451ff1842e2626ccb99004d0195b455a88`. Non-msrv steps carry `toolchain: stable`; msrv step carries `toolchain: "1.85.0"`. 7 total SHA replacements (ci.yml has 2 uses). Old SHA `c93f4f9c` absent from all 6 files. |
| AC-3 | MSRV job validates 1.85.0 | SATISFIED | `ci.yml` line 72: `toolchain: "1.85.0"`; line 76: `RUSTUP_TOOLCHAIN: "1.85.0"` on the `cargo check` step. Both load-bearing elements present. |
| AC-4 | MSRV comment accuracy | SATISFIED | `ci.yml` line 70 comment `# 1.85.0`; job name line 60 `MSRV (1.85.0)`. Toolchain input and comment agree. |
| AC-5 | rustup target add steps preserved | SATISFIED | `sign-and-publish.yml` line 61: E0463 comment; line 65: `rustup target add`. `backfill-release.yml` line 75: E0463 comment; line 80: `rustup target add`. Both intact and unchanged. |
| AC-6 | CLAUDE.md gotcha for toolchain resolution precedence | SATISFIED | New gotcha at top of Gotchas section. Covers: `rust-toolchain.toml` overrides `toolchain` input at shell level; `RUSTUP_TOOLCHAIN` is process-level override; both `with:` AND env are load-bearing; omitting env → false-green. All version references read `"1.85.0"`. |
| AC-7 | Old SHA c93f4f9c absent from all 6 workflow files | SATISFIED | `grep -n "c93f4f9c" .github/workflows/*.yml` returns zero output. |
| AC-8 | comfy-table pinned to 7.2.1 in Cargo.toml | SATISFIED | `Cargo.toml` line 24: `comfy-table = "=7.2.1"` with inline comment citing `.factory/research/msrv-let-chains-comfy-table-2026-07-30.md`. `Cargo.lock` resolves to comfy-table 7.2.1 (checksum `b03b7db8...`). Note: implementation uses `"=7.2.1"` (exact-version operator) which is stricter than the story Task 7a example's `"7.2.1"` (caret-range equivalent); the implementation is correct. |
| AC-9 | In-tree let-chain occurrences rewritten | SATISFIED | `src/cli/board.rs`: `if matches!(...) && let Some(field_id) = team_field_id` → nested `if matches!(...) { if let Some(field_id) = ... }`. `src/cli/issue/list.rs`: identical pattern. `src/cli/auth/keychain.rs`: `if let Ok(v) = ... && !v.is_empty()` → `if let Ok(v) = ... { if !v.is_empty() { ... } }`. Grep for ` && let ` across all of `src/` returns zero hits. |

---

## Item 2: Diff Inventory — Each Change Traced to an AC

| File | Change | AC(s) | Authorized |
|------|--------|-------|-----------|
| `.github/workflows/ci.yml` | SHA replaced (2 sites), `toolchain: "1.85.0"` + `RUSTUP_TOOLCHAIN` + job name update | AC-2, AC-3, AC-4, AC-7 | Yes |
| `.github/workflows/ci.yml` | `toolchain: stable` added to stable job | AC-2 | Yes |
| `.github/workflows/backfill-release.yml` | SHA replaced + `toolchain: stable` | AC-2, AC-7 | Yes |
| `.github/workflows/e2e-sweeper.yml` | SHA replaced + `toolchain: stable` | AC-2, AC-7 | Yes |
| `.github/workflows/e2e.yml` | SHA replaced + `toolchain: stable` | AC-2, AC-7 | Yes |
| `.github/workflows/release.yml` | SHA replaced + `toolchain: stable` | AC-2, AC-7 | Yes |
| `.github/workflows/sign-and-publish.yml` | SHA replaced + `toolchain: stable` (rustup target add preserved) | AC-2, AC-5, AC-7 | Yes |
| `CLAUDE.md` | Gotcha entry added at top of Gotchas section | AC-6 | Yes |
| `Cargo.toml` | `comfy-table = "7"` → `"=7.2.1"` with inline comment | AC-8 | Yes |
| `Cargo.lock` | Resolves to comfy-table 7.2.1 | AC-8 (auto) | Yes |
| `CHANGELOG.md` | Unreleased entry for comfy-table pin | Delivery checklist item 2 | Yes |
| `src/cli/board.rs` | Let-chain → nested `if let` rewrite | AC-9 | Yes |
| `src/cli/issue/list.rs` | Let-chain → nested `if let` rewrite | AC-9 | Yes |
| `src/cli/auth/keychain.rs` | Let-chain → nested `if` rewrite | AC-9 | Yes |

All 14 change groups trace to a named AC or delivery checklist. No unauthorized scope detected.

---

## Checklist Coverage (Items 3–10)

### Item 3: Revert Pair Net-Zero Verification

Commits `829f766b` (MSRV raise 1.85→1.88) and `03c2f5aa` (revert) leave zero net effect at all declaration sites. Verified: `Cargo.toml` `rust-version = "1.85"`, README.md `MSRV-1.85` badge (file not changed at all per `git diff --name-only`), `ci.yml` job name `MSRV (1.85.0)`, `ci.yml` toolchain/env `"1.85.0"`, `CLAUDE.md` gotcha references `"1.85.0"`. Two 1.88 references in `Cargo.toml` comment lines 19-22 are informational (explaining comfy-table 7.2.2 requirement and deferred raise); they are not declaration sites and are correct.

### Item 4: Version-Reference Consistency

All declaration sites say 1.85. No erroneous 1.88 declaration-site survivors. Informational 1.88 references in `Cargo.toml` comments are deliberate and correct. `docs/superpowers/`, `docs/specs/2026-05-14-search-issue-keys-dedupe.md` excluded per scope.

### Item 5: AC-8/AC-9 Joint-Dependency Claim

**AC-8 necessity:** `comfy-table 7.2.2` uses let-chains (edition 2024, Rust ≥1.88.0) and removed its `rust-version` manifest field. A caret range resolves to 7.2.2 at `cargo update`; `cargo check` at 1.85.0 fails with E0658 on comfy-table internals. AC-8 is load-bearing for the dependency.

**AC-9 necessity:** All three rewritten patterns are let-chain syntax (`&&` combining a `let` binding with a boolean condition). These produce E0658 under rustc 1.85.0 independently of comfy-table. Even with AC-8 in place, `jr`'s own source fails at 1.85.0 without AC-9.

**Claim verified correct.** Both are independently required.

### Item 6: feature_type/intent Accuracy

Frontmatter: `feature_type: infrastructure`, `intent: maintenance`, `target_module: src/cli/`. The scope discrepancy is explicitly documented in `risk_mitigations[1]`, AC-9 SCOPE CHANGE NOTE, and Previous Story Intelligence. The note is genuinely present and adequate for its stated auditability purpose. No finding.

### Item 7: Story-Internal Consistency

No 1.88 target presented as current. README.md correctly absent from `files_modified` (confirmed not changed in diff). No delivery checklist items describing the abandoned MSRV-raise approach as active work. AC bodies and checklist are consistent with v1.3 scope. `CHANGELOG.md` is missing from `files_modified` YAML — filed as R-001.

### Item 8: Traceability

`behavioral_contracts: []`, `bcs: []` are defensible: AC-9 rewrites are semantically equivalent syntax transformations (same execution traces, same branch conditions, same return types). No new behavior introduced. Existing BCs for board view, issue list, and auth cover the code paths; no new BCs warranted.

### Item 9: Guard Scripts

| Script | Exit Code | Output |
|--------|-----------|--------|
| `scripts/check-spec-counts.sh` | 0 | 7 bc files validated |
| `scripts/check-bc-cumulative-counts.sh` | 0 | 657 total BCs, 8 files |
| `scripts/check-bc-citation-symbols.sh` | 0 | 357 citations checked |
| `scripts/check-bc-no-numeric-test-counts.sh` | 0 | no numeric test counts |

All four exit 0.

### Item 10: Deferred-Work Handoff to S-640-1

S-640-1 records: 49 collapsible_if errors across 27 files (title + AC-2) ✓; jr's own let-chains already removed by `cc7f6da5` with all 3 files named ✓; unpin obligation in AC-3 ✓; raise + clippy fixes must land together in Architecture Compliance Rules ✓; `depends_on: ["S-626-1"]` prerequisite ✓; explicit inversion-pattern note (S-640-1 re-introduces let-chains at the 3 sites S-626-1 removed them) ✓. Handoff complete and accurate.

---

## Finding ID Convention

Finding IDs use the format: `ADV-<CYCLE>-P<PASS>-<SEV>-<SEQ>`

- `ADV`: Fixed prefix
- `<CYCLE>`: `C1CONV` (cycle-001 convergence)
- `<PASS>`: `PC` (pass C)
- `<SEV>`: `LOW`, `INFO`
- `<SEQ>`: Three-digit sequence

---

## Part B — New Findings (or all findings for pass 1)

### LOW

#### ADV-C1CONV-PC-LOW-001: CHANGELOG.md absent from story's files_modified list

- **Severity:** LOW
- **Category:** spec-fidelity
- **Location:** `S-626-1.md` → `files_modified` YAML field
- **Description:** `CHANGELOG.md` was modified in the delivered diff (delivery checklist item 2 explicitly required the addition) but is absent from the `files_modified` YAML prediction list. The actual CHANGELOG addition is correctly present and well-formed.
- **Evidence:** `git diff --name-only` includes `CHANGELOG.md`. The story `files_modified` list contains 12 entries, none of which is `CHANGELOG.md`.
- **Proposed Fix:** Add `CHANGELOG.md` to `files_modified` when the story is closed or during any post-delivery story housekeeping. No code change required.

### INFO

#### ADV-C1CONV-PC-INFO-001: Task 7a example shows non-exact pin syntax

- **Severity:** INFO
- **Category:** spec-fidelity
- **Location:** `S-626-1.md` → Task 7a inline example
- **Description:** Task 7a shows `comfy-table = "7.2.1"` (no `=` prefix). Without `=`, cargo interprets this as `"^7.2.1"` (caret range permitting upgrades within the same major version). The implementation correctly uses `"=7.2.1"`. The implementation is more correct than the example; the spec example is misleading.
- **Evidence:** Cargo.toml line 24: `comfy-table = "=7.2.1"`. Task 7a example: `comfy-table = "7.2.1"  # pinned: ...`.
- **Proposed Fix:** Update Task 7a example to `comfy-table = "=7.2.1"` for accuracy. Informational only — delivered code is correct.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 0 |
| LOW | 1 |
| INFO | 1 |

**Overall Assessment:** pass-with-findings
**Convergence:** CONVERGENCE_REACHED — both findings are REFINEMENT-class (metadata omission and spec-example accuracy); neither is a GAP against delivered behavior.
**Readiness:** ready for next phase

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | C |
| **New findings** | 2 (LOW metadata omission + INFO spec-example) |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 2 / (2 + 0) = 1.0 (first pass in this aperture) |
| **Median severity** | 1.5 (LOW/INFO band) |
| **Trajectory** | C: 2 findings (both REFINEMENT) |
| **Verdict** | CONVERGENCE_REACHED — no GAPs; both findings are non-blocking metadata refinements |
