---
document_type: f7-delta-convergence-report
feature: windows-build (x86_64-pc-windows-msvc)
cycle: cycle-001
activation_head: "587206e"
develop_head: "fac555f"
delta_range: "587206e..fac555f"
date: 2026-06-14
human_authorized: true
producer: state-manager
---

# F7 Delta Convergence Report — Windows Build

**Date:** 2026-06-14
**Develop HEAD:** fac555f
**Delta range:** 587206e..fac555f
**Human authorization:** GRANTED 2026-06-14
**Verdict:** CONVERGED — READY FOR RELEASE

---

## Artifact Counts (unchanged through feature cycle)

| Artifact | Count |
|----------|-------|
| Behavioral Contracts (BCs) | 597 |
| Non-Functional Requirements (NFRs) | 42 |
| Architecture Decision Records (ADRs) | 16 |
| Stories | 74 (authoritative) |

---

## Dimension 1 — Spec

**Result: PASS**

- F5 adversarial spec review: 14 passes (R1–R14, excluding VOID R11 checkout-race), 3 consecutive clean passes at R12/R13/R14.
- Novelty reached 0 after R12; no new spec-level findings in R13 or R14.
- ADR-0016 authored and merged: documents all 6 Windows-build architectural decisions including cross-compile approach, XDG→JR seam migration, stack-size override, deny.toml skip set topology, OAuth verification scope, and runtime environment assumptions.
- PRD updated: NFR-P-W1 (Windows path correctness) recorded.
- CHANGELOG [Unreleased] block current through fac555f; all 7 fix PRs (#504–#510 story deliveries + #511–#516 fix PRs) reflected.
- FINDING-001 (factory ADR-0016 copy out-of-sync with source ADR) fixed at ba1fc1a; consistency-validation clean post-fix.
- Input-drift check clean for all delta artifacts: no stale spec references detected.

---

## Dimension 2 — Tests

**Result: PASS**

- **Delta mutation testing (F6):** 9/9 mutants CAUGHT (100% kill rate).
  - config.rs: 5/5 caught (all security-critical `delete !` mutants killed).
  - cache.rs: 4/4 caught.
  - All 4 empty-string-filter security mutants killed — demonstrates test suite detects removal of the
    `is_empty()` guard that prevents path injection via JR_CONFIG_DIR/JR_CACHE_DIR.
- **Property-based testing (F6, R5-001 / R8-001 hardening):** 9 proptest properties in
  `tests/win_path_fallback_props.rs`, 2048 cases each (~18,000+ generated inputs total).
  Properties verify BC-6.1.014 EC-1/EC-3 (config path fallback purity) and BC-6.2.016 EC-1/EC-4
  (cache path fallback purity) invariants on the pure path-fallback helpers.
  All 9 PASS (FIX-F6-001, PR #516, squash-merged → fac555f).
- **Guard tests hardened:** R5-001 (`test_global_config_struct_has_no_path_override_field`) and
  R8-001 (figment re-entry invariant) added/strengthened during F5 fix PRs #514/#515.
- **Regression suite:** 1808 tests, 0 failures on develop fac555f (cargo test --all-features).
- **CI matrix:** 13/13 CI checks GREEN on fac555f, including:
  - Test (ubuntu-latest), Test (macos-latest), Test (windows-latest)
  - Clippy (ubuntu-latest), Clippy (windows-latest)
  - Format, MSRV (1.85.0), Deny (licenses + vulnerabilities)
- **Test-only PRs:** FIX-F6-001 (#516) is test-only; no production code changed in F6.

---

## Dimension 3 — Implementation

**Result: PASS**

- **Severity distribution:** 0 CRIT / 0 HIGH findings since R2 (F5 adversary). All R1 CRIT/HIGH
  resolved before F5 R2 re-run. Final passes R12/R13/R14 produced zero CRIT/HIGH/MEDIUM.
- **All findings were real:** High adversary verification rate — every CRIT/HIGH finding in R1–R5
  pointed to genuine gaps (stack overflow prod crash, XDG seam incomplete migration, CRLF line
  endings, missing windows-latest matrix, branch-protection drift). Not hallucinated.
- **Fix PRs merged:**
  - #504 — S-WIN-2: cross-compile + deny.toml initial
  - #505 — S-WIN-3: deny.toml 17-entry windows-sys 0.60 skip set
  - #506 — S-WIN-1: AppData path fallback (config.rs/cache.rs)
  - #507 — S-WIN-4: release.yml Compress-Archive + zip artifact
  - #508 — S-WIN-6: documentation fallout (WIN-O-3/WIN-O-4/SEC-WCM-DOC)
  - #509 — S-WIN-6 squash-merge
  - #510 — S-WIN-5: XDG→JR seam migration + ci.yml windows matrix + stack fix
  - #511 — FIX-F5-001: CHANGELOG.md Windows section (from R1)
  - #512 — FIX-F5-002: ci.yml MSRV job (from R1)
  - #513 — FIX-F5-003: ADR-0016 minor prose (from R1/R2)
  - #514 — FIX-F5-004: figment guard test (from R6, security perimeter)
  - #515 — FIX-F5-005: OAuth guard alignment (from R8)
  - #516 — FIX-F6-001: proptest property suite (test-only)
- 7 fix PRs total in the F5/F6 remediation phase.
- Post-F5: zero doc/test-only findings remain outstanding at CRIT/HIGH/MEDIUM severity.
- Residual LOWs accepted per ADR-0016 and DEC-098: WIN-RUNTIME-OAUTH-PROBE (scope: OAuth
  runtime probe not ported to Windows; documented ADR-0016 Decision 5c amendment) and
  WIN-AC004-DIRECTIONAL (directional blind spot in subprocess env check; narrow, documented).

---

## Dimension 4 — Verification

**Result: PASS**

- **Proptest:** 9 properties × 2048 cases PASS (BC-6.1.014, BC-6.2.016 invariants).
- **Kani formal verification:** JUSTIFIED SKIP. Kani (CBMC-based) hits OOM on PathBuf equality
  comparison due to symbolic explosion; proptest (statistical) substituted. Tractability probe
  recorded in F6 adversarial review materials.
- **Fuzz testing:** JUSTIFIED SKIP. No new untrusted-input parsers introduced by Windows delta;
  all Windows-specific code paths are pure path-computation helpers or CI/release config.
- **cargo audit:** 0 vulnerabilities on fac555f.
- **cargo deny:** PASS (licenses + vulnerabilities). deny.toml updated with 17-entry windows-sys
  0.60 skip set (S-WIN-3, PR #505); topology documented with fragility note WIN-DENY-FRAGILITY.
- **Purity boundaries intact:** `config_dir_fallback()` and `cache_dir_fallback()` remain pure
  functions (no I/O side effects). Verified by proptest properties EC-1/EC-3 and EC-1/EC-4.
- **Security review (F6):** APPROVED — 0 CRIT/HIGH/MEDIUM/LOW from security lens.
- **AI review (F6):** APPROVED cycle 1.

---

## Dimension 5 — Holdout

**Result: PASS-on-automatable (H-WIN-6 = post-release)**

- **Automatable scenarios (PASS):**
  - H-WIN-1 through H-WIN-5: windows-latest CI green across all 13 checks on all story PRs and fix PRs.
  - release.yml Windows matrix smoke steps present and verified in PR diff.
  - OAuth-verify step in release.yml: constants-file check present (documented scope in ADR-0016 Decision 5c).
  - /STACK:8388608 production crash fix verified: `.cargo/config.toml` contains the linker flag;
    CI Test (windows-latest) passes without stack overflow.
- **Live release-page holdout (H-WIN-6 — deferred to post-release):**
  - Requires: push a release tag, GitHub Actions release.yml executes Windows job,
    jr-&lt;version&gt;-x86_64-pc-windows-msvc.zip artifact appears on the GitHub Release page,
    artifact runs on a real Windows machine without stack overflow.
  - Status: NOT YET EXECUTED — pending version bump + release tag. Human authorized to proceed.
  - Recommended approach: v0.6.0-dev.2 dev release via branch+PR (first-time-validate the never-yet-
    executed release.yml Windows matrix before a stable release). Finalize CHANGELOG [Unreleased]→
    version, tag, GitHub Release triggers release.yml.

---

## Regression

**Result: CLEAN**

- `cargo test --all-features` on develop fac555f: 1808/0 (all pass, zero failures).
- fmt/clippy clean on both ubuntu-latest and windows-latest.
- No pre-existing tests broken by any Windows delta PR.

---

## Consistency

**Result: CONSISTENT**

- FINDING-001 (factory ADR-0016 copy out-of-sync with canonical source): FIXED at ba1fc1a
  (factory-artifacts branch). Source ADR at `docs/adr/ADR-0016-windows-build.md` and factory copy
  at `.factory/specs/architecture/ADR-0016.md` (or equivalent) are now in sync.
- Input-drift check: all delta artifacts (ci.yml, release.yml, deny.toml, .cargo/config.toml,
  src/config.rs, src/cache.rs) read on fresh checkout of fac555f; no stale spec references detected.
- Count consistency: BC 597 / NFR 42 / ADR 16 / Stories 74 unchanged through all Windows-build
  phases. No count-propagation drift detected.

---

## Cost-Benefit Assessment

- Findings decayed to LOW/cosmetic/doc-sync across the last 6 adversary passes (R9–R14).
- Maximum viable refinement effectively reached: 14 adversary passes, 3 consecutive clean.
- No further adversarial passes are expected to surface CRIT/HIGH findings.
- Remaining LOWs are tracked in Drift Items (STATE.md) with appropriate deferral rationale.
- F6 proptest suite provides ongoing regression protection for the security-critical path invariants.

---

## Recommendation

**READY FOR RELEASE.**

Human authorized 2026-06-14.

Next action: create a branch+PR for version bump (v0.6.0-dev.2 dev release recommended),
finalize CHANGELOG [Unreleased]→version, tag, trigger GitHub Release → H-WIN-6 live holdout.
