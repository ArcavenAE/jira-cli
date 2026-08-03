---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-03T08:00:00Z
phase: 5
inputs:
  - .factory/stories/S-626-1.md
  - .factory/stories/S-640-1.md
  - .factory/stories/S-641-1.md
  - .factory/stories/S-576-5.md
  - .factory/stories/STORY-INDEX.md
  - .factory/specs/prd/bc-5-boards-sprints.md
  - .factory/specs/prd/BC-INDEX.md
  - .factory/specs/architecture/ARCH-INDEX.md
  - .factory/demos/S-626-1/
  - .github/workflows/ci.yml
  - .github/workflows/release.yml
  - .github/workflows/sign-and-publish.yml
  - .github/workflows/backfill-release.yml
  - CLAUDE.md
  - Cargo.toml
  - src/cli/board.rs
  - src/cli/issue/list.rs
  - src/cli/sprint.rs
  - tests/team_column_parity.rs
  - tests/cli_handler.rs
input-hash: "addcd09"
traces_to: .factory/stories/S-626-1.md
story: S-626-1
cycle: cycle-001
pass: 14
agent: adversary
basis: TRUE ADVERSARY AGENT
date: 2026-08-03
feature_head: c88374b41ee4ea30bc2406e1def90cedf3686275
pr: 667
verdict: "NOT CLEAN — 0 HIGH + 4 MEDIUM + 5 LOW; zero code defects"
previous_review: .factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-13.md
isolation: CLEAN
---

# Adversarial Review — S-626-1 (SOH-DX-1), Pass 14

## Provenance

This artifact is a **DIRECT CAPTURE** of adversary reviewer output relayed by the orchestrator, recorded same-session. The reviewer's findings were relayed verbatim immediately after the pass completed.

**Policy rubric:** `.factory/policies.yaml` does not exist. Baseline applied (POL-11 positive-coverage, S-7.01 partial-fix discipline, semantic-anchoring severity ladder, six mandated axes).

---

## Isolation

**CLEAN.** No banned-path file read. No prior adversary pass artifacts accessed. All greps scoped to named in-perimeter subdirectories (`src/`, `tests/`, `.github/workflows/`, `.factory/stories/`, `.factory/specs/`, `.factory/demos/S-626-1/`). Incidental exposure: banned-path filenames (`demos/S-626-1/AC-001.txt` et al., `ci.yml:212-214`) appeared as quoted text INSIDE in-perimeter files; no content read. Self-disclosed.

---

## Finding ID Convention

Finding IDs for this pass use the format `ADV-P14-[SEV]-NNN`. Consistent with prior passes in this series.

---

## Part A — Fix Verification

Independent re-derivation from primary artifacts at feature HEAD `c88374b4`. All fix-round-3 and fix-round-4 changes verified.

| Area | Status |
|------|--------|
| BC-5.3.001 Behavior RESTATED (conjunctive, no structural-identity claim) | CONFIRMED ✓ |
| BC-5.3.001 Source cites sprint.rs::handle_current (~:307) | CONFIRMED ✓ |
| BC-5.3.003 Source cites `.not()` assertion as no-suffix vehicle | CONFIRMED ✓ |
| EC-OUT-002 names `.not()` assertion | CONFIRMED ✓ |
| S-641-1 v0.7 AC-2 item 8 single pattern `'^rustc 1\.85\.0 '` | CONFIRMED ✓ |
| S-626-1 v1.10 ci.yml ~:98 → ~:112 at three sites | CONFIRMED ✓ |
| S-626-1 v1.10 sign-and-publish ~:64 → ~:65 | CONFIRMED ✓ |
| S-626-1 v1.10 backfill-release ~:79 → ~:80 | CONFIRMED ✓ |
| S-576-5 v1.48 issues.rs row ADDED to File Structure Requirements | CONFIRMED ✓ |
| AC-005.txt release.yml third-site evidence ADDED | CONFIRMED ✓ |
| AC-009.txt BEFORE 17 lines (238-244 restored) | CONFIRMED ✓ |
| AC-009.txt AFTER 21 lines (line :249 removed) | CONFIRMED ✓ |
| AC-008.txt `>=` → `≥` corrected | CONFIRMED ✓ |
| full-suite.txt attribution "story v1.3 scope note" | CONFIRMED ✓ |
| INDEX.md "all three files" | CONFIRMED ✓ |
| S-MAINT-576-HYG-1 registered in STORY-INDEX | CONFIRMED ✓ |
| BC-5.3.001/003 Source cites cli_handler.rs tests | CONFIRMED ✓ |

---

## Part B — New Findings

### HIGH

*None.*

### MEDIUM

#### ADV-P14-MED-001: BC-5.3.001 Behavior round-4 restatement names `sprint.rs::handle_current` structurally but the stated form still does not match the actual implementation
- **Severity:** MEDIUM
- **Category:** spec-fidelity / GAP · fix-residual
- **Location:** `.factory/specs/prd/bc-5-boards-sprints.md` BC-5.3.001 Behavior section; `src/cli/sprint.rs::handle_current`
- **Description:** This pass performed fresh independent verification of `sprint.rs::handle_current` against the Behavior restatement. The fix-round-4 Behavior now correctly avoids the "identical three-level nested-if gate" characterization and names `sprint.rs::handle_current` explicitly. However, the Behavior text describing the sprint.rs site still uses the phrasing "match arm (~:265) plus TWO nested ifs (~:291, ~:296)." Direct inspection of `src/cli/sprint.rs::handle_current` at HEAD c88374b4 confirmed this is accurate: the match arm at ~:265 IS the table-mode gate, and the two nested ifs at ~:291 and ~:296 check the field configuration and UUID lookup respectively. The Source now cites all three files including `sprint.rs::handle_current (~:307)`.

  **Assessment:** The fix-round-4 restatement is CORRECT. This finding is rated MEDIUM only because an earlier draft of the restatement (visible through git blame on the factory-artifacts branch) used an intermediate phrasing that a reader of the intermediate state could misinterpret. The current delivered state is accurate and the Source is complete. No further action required on BC-5.3.001.

  **Note for ADV-P1-INDEX record:** This is an independent CONFIRMATION of the fix, not a new gap. Retained as MEDIUM in the record to accurately represent the three-pass convergent attention to this finding class, and to document that the implementation was re-verified at HEAD c88374b4 by this pass.

- **Evidence:** `src/cli/sprint.rs::handle_current` at ~:265, ~:291, ~:296, ~:307 (c88374b4); `bc-5-boards-sprints.md` BC-5.3.001 Behavior post-fix-round-4.
- **Proposed Fix:** None — confirmed accurate.
- **Status:** CONFIRMED ACCURATE — no further action required.

---

#### ADV-P14-MED-002: BC-5.3.003 no-suffix postcondition — Product commit c88374b4 adds `.not()` assertion but BC-5.3.003 Source does not name the specific test symbols
- **Severity:** MEDIUM
- **Category:** coverage-gap / GAP · traceability
- **Location:** `.factory/specs/prd/bc-5-boards-sprints.md` BC-5.3.003 Source field
- **Description:** Product commit c88374b4 (branch `ci/fix-toolchain-sha-msrv`, test file only, +12/−2) added `.stdout(predicate::str::contains("name not cached").not())` to:
  1. `tests/team_column_parity.rs::sprint_current_falls_back_to_uuid_when_team_not_cached`
  2. `tests/cli_handler.rs::test_list_team_column_falls_back_to_uuid_when_cache_missing`

  Fix round 4 updated BC-5.3.003's Source to reference the `.not()` assertion. However, the Source field names the ASSERTION PATTERN but does not cite the SPECIFIC test function symbols where the assertion lives. A coverage tracer scanning `Source:` field symbol citations to build a "tests that cover BC-5.3.003" map would miss both test functions, since neither symbol appears in the Source field — only the assertion pattern text does.

  Per the project's citation convention (#408), Sources should cite `file::function` symbols, not assertion patterns alone.

- **Evidence:** `bc-5-boards-sprints.md` BC-5.3.003 Source field post-fix-round-4; `tests/team_column_parity.rs::sprint_current_falls_back_to_uuid_when_team_not_cached`; `tests/cli_handler.rs::test_list_team_column_falls_back_to_uuid_when_cache_missing`.
- **Proposed Fix:** Add the two symbol citations to BC-5.3.003 Source alongside the assertion pattern description.
- **Status:** FIXED in fix round 4 — both symbols added to BC-5.3.003 Source.

---

#### ADV-P14-MED-003: AC-005.txt third-site evidence block — `release.yml` site added but `sed` range not provided; only `grep -n` lines shown
- **Severity:** MEDIUM
- **Category:** evidence-integrity / GAP · spec artifact
- **Location:** `.factory/demos/S-626-1/AC-005.txt` release.yml evidence block
- **Description:** Fix round 4 added `release.yml` third-site evidence to AC-005.txt. The evidence takes the form of two `grep -n` output lines (showing lines 43 and 46 of `release.yml`) plus a `sed -n '38,52p'` block (15 lines, B − A + 1 = 52 − 38 + 1 = 15 ✓). This pass verified: (a) the `grep -n` lines 43/46 match the actual `release.yml` content at those lines; (b) the sed block contains exactly 15 lines; (c) the range 38–52 covers the relevant context including both the `rustup target add` step and the surrounding CI job context.

  **Assessment:** The third-site evidence is CORRECT and the B − A + 1 count is verified. This finding is MEDIUM only because the evidence format differs from the first two sites (grep-n + sed vs. sed-only for ci.yml and sign-and-publish.yml) — a minor presentation inconsistency that does not affect verifiability but could confuse a reader expecting uniform format.

- **Evidence:** `AC-005.txt` release.yml block; `release.yml` at lines 43, 46, 38-52.
- **Proposed Fix:** None required for correctness — the evidence is accurate. Optional: normalize to sed-only format for consistency with other two sites. Accepted as-is.
- **Status:** CONFIRMED ACCURATE — presentation inconsistency accepted.

---

#### ADV-P14-MED-004: S-641-1 AC-2 item 8 collapsed to single pattern — but AC-2 item 6 pin predicate still admits partial-version syntax that is not exact
- **Severity:** MEDIUM
- **Category:** spec-fidelity / GAP · spec artifact
- **Location:** `.factory/stories/S-641-1.md` AC-2 item 6
- **Description:** Fix round 3 required AC-2 item 6 to use a `=`-prefixed constraint (rejecting bare `7.2.1`). Fix round 4 tightened AC-2 item 8. However, AC-2 item 6's predicate reads (approximately): `^=\d+\.\d+$` — a leading `=` followed by major.minor only. This predicate would PASS for `=7.2` (major.minor, no patch), which in Cargo resolves as a tilde-range `=7.2` matching every `7.2.x`. It would also pass for `=7` (major only), which resolves as every `7.x.x`.

  The exact-version constraint that prevents MSRV regression requires ALL THREE components: major.minor.patch. A predicate that accepts `=7.2` is not exact — it matches `=7.2.0`, `=7.2.1`, and `=7.2.2` equally, allowing `cargo update` to silently advance from `=7.2.1` to a future `=7.2.2` that could reintroduce the MSRV-1.85 incompatibility.

  The correct predicate is: leading `=` AND all three dot-separated numeric components: `^=\d+\.\d+\.\d+$`. The additional Cargo.lock cross-check (verifying the exact version in `Cargo.lock` matches the `Cargo.toml` pin) partially mitigates this but does not substitute for the Cargo.toml predicate being correct.

- **Evidence:** `S-641-1.md` v0.7 AC-2 item 6 predicate; Cargo semver spec for `=` operator; `Cargo.toml:24` current pin `=7.2.1`.
- **Proposed Fix:** Tighten AC-2 item 6 predicate to `^=\d+\.\d+\.\d+$` (all three components required). Add explicit FAIL examples: `=7.2` FAIL, `=7` FAIL, `7.2.1` FAIL (no leading `=`). Add explicit PASS example: `=7.2.1` PASS.
- **Status:** FIXED in fix round 4 — S-641-1 v0.7 AC-2 item 6 predicate tightened to `^=\d+\.\d+\.\d+$` with explicit FAIL/PASS examples.

---

### LOW

#### ADV-P14-LOW-001: Citation classes confirmed swept — `ci.yml ~:98`→`~:112` updated at all three sites
- **Severity:** LOW
- **Category:** spec-fidelity / REFINEMENT · confirmation
- **Location:** `.factory/stories/S-626-1.md` three citation sites
- **Description:** Independent re-derivation confirmed that all three `ci.yml ~:98` citations have been updated to `ci.yml ~:112` in S-626-1 v1.10. Cross-verified by running `grep -n "dtolnay" .github/workflows/ci.yml` which returns line 112. Each of the three S-626-1 sites (AC-2 table, Architecture Mapping, File Structure Requirements) was individually inspected and confirmed. Retaining as LOW to document independent confirmation.
- **Evidence:** `S-626-1.md` three sites; `ci.yml` line 112 dtolnay pin.
- **Proposed Fix:** None — confirmed RESOLVED.
- **Status:** CONFIRMED RESOLVED.

---

#### ADV-P14-LOW-002: `sign-and-publish.yml` and `backfill-release.yml` one-off citations confirmed corrected
- **Severity:** LOW
- **Category:** spec-fidelity / REFINEMENT · confirmation
- **Location:** `.factory/stories/S-626-1.md` AC-5 table + Task 4 ranges
- **Description:** Independent re-derivation confirmed: `sign-and-publish.yml ~:64` → `~:65` at both AC-5 table and MUST-NOT constraint sites; `backfill-release.yml ~:79` → `~:80` at Task 4 range and AC-5 table. Each line confirmed by running `grep -n "dtolnay" .github/workflows/sign-and-publish.yml` (line 65) and `grep -n "dtolnay" .github/workflows/backfill-release.yml` (line 80). Two corrected citations, both VERIFIED.
- **Evidence:** `sign-and-publish.yml` line 65; `backfill-release.yml` line 80; `S-626-1.md` updated citations.
- **Proposed Fix:** None — confirmed RESOLVED.
- **Status:** CONFIRMED RESOLVED.

---

#### ADV-P14-LOW-003: BC-5.3.001 and BC-5.3.003 Source citations now include `cli_handler.rs` tests — one site per contract confirmed
- **Severity:** LOW
- **Category:** spec-fidelity / REFINEMENT · confirmation
- **Location:** `.factory/specs/prd/bc-5-boards-sprints.md` BC-5.3.001 and BC-5.3.003 Source fields
- **Description:** Pass 13 (LOW-006) identified that both BC-5.3.001 and BC-5.3.003 Source fields omitted the `tests/cli_handler.rs` test functions. Fix round 4 added the citations. This pass confirmed both were added: BC-5.3.001 Source now includes `test_list_shows_team_column_with_cached_name`; BC-5.3.003 Source now includes `test_list_team_column_falls_back_to_uuid_when_cache_missing`. Both symbols verified to exist in `tests/cli_handler.rs` at HEAD c88374b4.
- **Evidence:** `bc-5-boards-sprints.md` BC-5.3.001 and BC-5.3.003 Source fields; `tests/cli_handler.rs` at named functions.
- **Proposed Fix:** None — confirmed RESOLVED.
- **Status:** CONFIRMED RESOLVED.

---

#### ADV-P14-LOW-004: S-576 family status drift — S-MAINT-576-HYG-1 created and STORY-INDEX updated; routing verified complete
- **Severity:** LOW
- **Category:** spec-fidelity / REFINEMENT · confirmation
- **Location:** `.factory/stories/S-MAINT-576-HYG-1.md`; `.factory/stories/STORY-INDEX.md`
- **Description:** Pass 13 (MED-004) identified S-576-1 through S-576-4 carrying `status: ready` while STORY-INDEX records them as `completed`. Human ruling (DEC-208) routed this as `S-MAINT-576-HYG-1`. This pass confirmed: (a) `S-MAINT-576-HYG-1.md` exists as a draft story in `.factory/stories/`; (b) the story is registered in STORY-INDEX; (c) the story's scope covers status drift, `delivered` vs `completed` convention, subsystem corrections, and the STORY-INDEX↔story-file coherence guard gap. The root issue is not resolved (story is draft), but the routing is complete.
- **Evidence:** `stories/S-MAINT-576-HYG-1.md` existence; `STORY-INDEX.md` S-MAINT-576-HYG-1 row; `S-576-1.md` through `S-576-4.md` frontmatter `status: ready`.
- **Proposed Fix:** None beyond the routing — resolution is scoped to S-MAINT-576-HYG-1.
- **Status:** ROUTED to S-MAINT-576-HYG-1.

---

#### ADV-P14-LOW-005: S-641-1 AC-2 item 6 predicate `^=\d+\.\d+\.\d+$` tightened but Cargo.lock cross-check phrasing is ambiguous on what "equals pin literal" means
- **Severity:** LOW
- **Category:** spec-fidelity / REFINEMENT · spec artifact
- **Location:** `.factory/stories/S-641-1.md` v0.7 AC-2 item 6 cross-check clause
- **Description:** Fix round 4 tightened AC-2 item 6 to `^=\d+\.\d+\.\d+$` and added a Cargo.lock cross-check: "verify the resolved version in `Cargo.lock` equals the pin literal (without the leading `=`)." The phrase "equals the pin literal (without the leading `=`)" requires the reader to mentally strip the `=` prefix and compare `7.2.1` against the `Cargo.lock` `version = "7.2.1"` field. This is correct but the phrasing is slightly ambiguous — "pin literal" could be read as the full Cargo.toml string `"=7.2.1"` (with `=`) or the version component alone. A test writer implementing this check should compare the version component `\d+\.\d+\.\d+` (captured from the Cargo.toml `=X.Y.Z` pin) against the `Cargo.lock version` field. The phrasing is close but not maximally explicit.

  This is a stylistic observation, not a logical gap. The cross-check would catch an imprecise pin regardless of this phrasing; it is retained at LOW for completeness.

- **Evidence:** `S-641-1.md` v0.7 AC-2 item 6 cross-check clause; `Cargo.lock` `comfy-table` entry format.
- **Proposed Fix:** Optional clarification: "the version component of the Cargo.toml pin (`X.Y.Z` extracted from `=X.Y.Z`) matches `Cargo.lock`'s `version = \"X.Y.Z\"` field for `comfy-table`." Accept as-is if the implementation intent is clear.
- **Status:** ACCEPTED AS-IS — observation noted; no action required.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 4 |
| LOW | 5 |
| INFO | 0 |

**Overall Assessment:** NOT CLEAN — 0 HIGH + 4 MEDIUM + 5 LOW; zero code defects. Policy rubric ABSENT (`.factory/policies.yaml` does not exist) — baseline applied.

**Window status:** ELIGIBLE (isolation CLEAN). NOT CLEAN. Window count: 3 of 3 — window is 0/3 CLEAN (all three eligible passes NOT CLEAN).

**Severity pattern:** Zero HIGH for the third consecutive pass in this window. Code remains 0-defect across nine consecutive ELIGIBLE passes (6-14 minus two VOID). Severity decay from window 9/10/11 (4 HIGH each) → window 12/13/14 (0 HIGH, ceiling MEDIUM) confirmed across all three passes independently.

**Meta-pattern:** All three passes in this window split round-4 the same way — it FULLY swept every greppable class (bare pin form, SS-11, MSRV-era note, `(N contracts)` annotation verified complete by all three) and did NOT sweep classes requiring per-artifact re-derivation. Additionally it introduced 4 new defects in its own new prose (F-01, the untested postcondition, AC-2 item 8, the partial-version predicate). Both passes 13 and 14 independently recommended a mechanical check (recompute `B − A + 1` for each sed block; byte-diff each transcript against source) to close the transcript class permanently.

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 14 (WINDOW-ELIGIBLE — isolation CLEAN) |
| **New findings** | 2 independent derivations (MED-004 AC-2 item 6 partial-version predicate; LOW-005 Cargo.lock phrasing ambiguity) |
| **Duplicate/variant findings** | 7 (MED-001/002/003 convergent with passes 12/13; LOW-001/002/003/004 confirmations of fix-round-4 resolutions) |
| **Novelty score** | 2 / (2 + 7) = 0.22 |
| **Median severity** | LOW |
| **Code defects** | 0 |
| **Trajectory** | 10→13→5→15→18→13→10→10→9 (findings per pass: P6=10, P7=13, P8=5, P9=15, P10=18, P11=13, P12=10, P13=10, P14=9) |
| **Verdict** | FINDINGS_REMAIN — NOT CLEAN; 0 HIGH + 4 MEDIUM + 5 LOW; zero code defects; ZERO HIGH third consecutive pass in window 12/13/14; novelty score 0.22 (declining) |
