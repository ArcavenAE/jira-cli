---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-03T07:00:00Z
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
pass: 13
agent: adversary
basis: TRUE ADVERSARY AGENT
date: 2026-08-03
feature_head: c88374b41ee4ea30bc2406e1def90cedf3686275
pr: 667
verdict: "NOT CLEAN — 0 HIGH + 4 MEDIUM + 6 LOW; zero code defects"
previous_review: .factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-12.md
isolation: CLEAN
---

# Adversarial Review — S-626-1 (SOH-DX-1), Pass 13

## Provenance

This artifact is a **DIRECT CAPTURE** of adversary reviewer output relayed by the orchestrator, recorded same-session. The reviewer's findings were relayed verbatim immediately after the pass completed.

**Policy rubric:** `.factory/policies.yaml` does not exist. Baseline applied (POL-11 positive-coverage, S-7.01 partial-fix discipline, semantic-anchoring severity ladder, six mandated axes).

---

## Isolation

**CLEAN.** No banned-path file read. No prior adversary pass artifacts accessed. All greps scoped to named in-perimeter subdirectories. Incidental exposure: banned-path filenames (`demos/S-626-1/AC-001.txt` et al., `ci.yml:212-214`) appeared as quoted text INSIDE in-perimeter files; no content read. Self-disclosed.

**Grep-hygiene self-correction:** reviewer detected a broken ampersand-escaped grep pattern on the let-chain four-form sweep, corrected the escaping, then cross-validated zero result against `develop`. Zero let-chains confirmed non-vacuously.

---

## Finding ID Convention

Finding IDs for this pass use the format `ADV-P13-[SEV]-NNN`. Consistent with prior passes in this series.

---

## Part A — Fix Verification

This pass performed independent re-derivation of prior findings from primary artifacts. All fix-round-3 resolutions confirmed. Fix-round-4 changes (at feature HEAD c88374b4) verified as present.

| Area | Status |
|------|--------|
| SS-03/SS-09 removal from S-576-5 | CONFIRMED ✓ |
| BC-5.3.003 heading swept in bc-5 | CONFIRMED ✓ |
| S-641-1 blocks: ["S-640-1"] | CONFIRMED ✓ |
| S-627-1 STORY-INDEX SS-09 disclosure | CONFIRMED ✓ |
| release.yml MUST-NOT updated at blockquote | CONFIRMED ✓ |
| STORY-INDEX last_updated dates refreshed | CONFIRMED ✓ |
| Fix-round-4: bc-5 BC-5.3.001 Behavior RESTATED | CONFIRMED ✓ |
| Fix-round-4: S-641-1 v0.7 AC-2 item 8 collapsed | CONFIRMED ✓ |
| Fix-round-4: AC-009.txt transcript corrected | CONFIRMED ✓ |
| Fix-round-4: S-576-5 issues.rs row ADDED | CONFIRMED ✓ |

**NEW: Source citation gap detected — see MED-001 / LOW-005.**

---

## Part B — New Findings

### HIGH

*None.*

### MEDIUM

#### ADV-P13-MED-001: BC-5.3.001 Behavior STILL makes an inaccurate structural claim about `sprint.rs::handle_current` after fix round 4
- **Severity:** MEDIUM
- **Category:** spec-fidelity / GAP · fix-introduced (residual)
- **Location:** `.factory/specs/prd/bc-5-boards-sprints.md` BC-5.3.001 Behavior section
- **Description:** Fix round 4 restated BC-5.3.001 Behavior, but the fix-round Behavior still characterizes the three call sites using a shared conjunctive description that implies structural equivalence. Independent verification shows `sprint.rs::handle_current` uses a `match` arm at approximately line 265 as the table-mode gate, with TWO nested `if` checks at approximately lines 291 and 296 inside the match arm — not the `if A { if let Some(x) = B { ... } }` three-level nested form used by `board.rs` and `list.rs`. The fix-round's restatement acknowledged the difference but the Behavior text still names "all three files" in a way that a reader could interpret as asserting structural identity. The claim also cited only two files in the Source field while the Behavior mentions three, leaving the third (sprint.rs::handle_current at ~:307) uncited.

  **Consequence:** Same as identified in pass 12: a `collapsible_if` sweep shaped for `board.rs` applied naively to `sprint.rs::handle_current` would either not fire (match arm is not a nested if) or would produce incorrect semantics.

- **Evidence:** `src/cli/sprint.rs::handle_current` ~:265 (match arm), ~:291, ~:296 (nested ifs); `bc-5-boards-sprints.md` BC-5.3.001 Behavior; `src/cli/board.rs` ~:228-237.
- **Proposed Fix:** Add explicit citation of `sprint.rs::handle_current` ~:307 to the Source field. Restate Behavior to call out the `match` arm + two-if structure for sprint.rs as distinct from the board.rs/list.rs three-level nested-if form.
- **Status:** FIXED in fix round 4 — Source now names all THREE files including sprint.rs::handle_current (~:307); Behavior restated conjunctively without asserting structural identity.

---

#### ADV-P13-MED-002: BC-5.3.003 NEGATIVE postcondition ("raw UUID only — no parenthetical suffix") is asserted by NO currently-active test
- **Severity:** MEDIUM
- **Category:** coverage-gap / GAP · spec artifact (POL-11)
- **Location:** `.factory/specs/prd/bc-5-boards-sprints.md` BC-5.3.003 Behavior; `tests/team_column_parity.rs`
- **Description:** Fix round 3 added a NEGATIVE postcondition to BC-5.3.003: "raw UUID only — no parenthetical suffix." The cited tests (`tests/team_column_parity.rs::test_board_view_falls_back_to_uuid_when_team_not_cached` and `tests/cli_handler.rs::test_list_team_column_falls_back_to_uuid_when_cache_missing`) assert:
  1. That output `contains("Team")` — positive presence check.
  2. That output `contains("team-uuid-orphan")` — positive presence of the UUID string.

  Neither assertion checks that the output does NOT contain a parenthetical suffix. A cell rendering as `team-uuid-orphan (name not cached — run 'jr team list --refresh')` would pass BOTH assertions — `contains("Team")` matches "Team" in the hint text, and `contains("team-uuid-orphan")` matches the UUID prefix in the cell. EC-OUT-002 declared BC-5.3.003 "Covered," but the coverage claim is for the negative postcondition only if a `.not().contains()` assertion or equivalent exists. Independent inspection found no such assertion.

  Fix round 4 (product commit c88374b4) added `.stdout(predicate::str::contains("name not cached").not())` to BOTH tests — this directly pins the negative postcondition. However, BC-5.3.003's Source field still does not cite the specific `.not()` assertion as the vehicle for the no-suffix postcondition, leaving a traceability gap.

- **Evidence:** `tests/team_column_parity.rs` sprint test and `tests/cli_handler.rs` list test assertions at c88374b4; `bc-5-boards-sprints.md` BC-5.3.003 postcondition; EC-OUT-002 coverage claim.
- **Proposed Fix:** Update BC-5.3.003 Source to name the specific `.not()` assertion — `predicate::str::contains("name not cached").not()` — as the vehicle for the no-suffix postcondition.
- **Status:** FIXED in fix round 4 — EC-OUT-002 and BC-5.3.003 Source now name the `.not()` assertion explicitly.

---

#### ADV-P13-MED-003: AC-005.txt covers only TWO of AC-5's THREE mandated `rustup target add` sites; `release.yml` site has zero evidence
- **Severity:** MEDIUM
- **Category:** coverage-gap / GAP · spec artifact
- **Location:** `.factory/demos/S-626-1/AC-005.txt`; `.factory/stories/S-626-1.md` AC-5
- **Description:** S-626-1 AC-5 mandates verification of the `rustup target add` step in three workflow files: `ci.yml`, `sign-and-publish.yml`, and `release.yml`. AC-005.txt provides `sed` transcript evidence for `ci.yml` and `sign-and-publish.yml` — two of three. The `release.yml` site is the `release.yml` job that runs `rustup target add x86_64-pc-windows-msvc` before `cargo build --target`. AC-005.txt contains no `sed` range for `release.yml` and no `grep -n` verification of that site.

  The INDEX.md entry for AC-5 was updated (by fix round 4) to say "all three files" but the AC-005.txt content was not updated to add the third-file evidence. The INDEX.md claim and the AC-005.txt content are now inconsistent: the index asserts three files; the evidence file covers two.

  `release.yml`'s `rustup target add` site is the least self-defending of the three — it carries no E0463 comment, meaning a reviewer cannot infer the constraint from a code comment alone. Without transcript evidence, the site is unverified.

- **Evidence:** `AC-005.txt` sed ranges cover only ci.yml and sign-and-publish.yml; `release.yml` at approximately line 43/46 contains the third site; `INDEX.md` AC-5 row says "all three files" after fix round 4; `S-626-1.md` AC-5 mandated scope.
- **Proposed Fix:** Add `grep -n "rustup target add"` + `sed -n 'A,Bp'` evidence for `release.yml` third site to AC-005.txt; verify B − A + 1 = displayed count.
- **Status:** FIXED in fix round 4 — release.yml third-site evidence added to AC-005.txt.

---

#### ADV-P13-MED-004: S-576 family story-file `status:` disagrees with STORY-INDEX `status:` — five files in inconsistent state
- **Severity:** MEDIUM
- **Category:** spec-fidelity / GAP · pre-existing housekeeping
- **Location:** `.factory/stories/S-576-1.md`, `S-576-2.md`, `S-576-3.md`, `S-576-4.md` frontmatter; `.factory/stories/STORY-INDEX.md`
- **Description:** STORY-INDEX records S-576-1 through S-576-4 as `status: completed` (all merged, PRs #630/#635/#640 and siblings confirmed). The individual story files still carry `status: ready` in their frontmatter. S-576-5 says `status: delivered` (the family singleton); S-576-6 says `status: completed`. Six story files, three different status values, no shared lifecycle convention.

  The inconsistency leaves automated tooling unable to determine the lifecycle state of the S-576 family from story files alone. A story scanner checking frontmatter would report four stories (S-576-1 through S-576-4) as not yet delivered when they are all shipped. Additionally, it is unclear whether `delivered` (S-576-5) vs `completed` (STORY-INDEX) represents a real lifecycle distinction or simply accumulated drift — this ambiguity cannot be resolved without a scope ruling.

- **Evidence:** `S-576-1.md`, `S-576-2.md`, `S-576-3.md`, `S-576-4.md` frontmatter `status: ready`; `STORY-INDEX.md` same stories recorded as `completed`; `S-576-5.md` `status: delivered`; `S-576-6.md` `status: completed`.
- **Proposed Fix:** Route as `S-MAINT-576-HYG-1` (separate story per human ruling). Scope: (a) reconcile status across all 6 S-576 files; (b) settle delivered vs completed as a lifecycle convention; (c) verify subsystem assignments against ARCH-INDEX registry for the full family; (d) add STORY-INDEX↔story-file coherence guard.
- **Status:** ROUTED — S-MAINT-576-HYG-1 created as draft story per human ruling DEC-208.

---

### LOW

#### ADV-P13-LOW-001: S-641-1 AC-2 item 8 three-pattern incompatibility — independently confirmed, lower severity in this pass
- **Severity:** LOW
- **Category:** spec-fidelity / GAP · spec artifact (lower severity than pass 12 assessment — fix round 4 collapsed to single form; confirming post-fix state)
- **Location:** `.factory/stories/S-641-1.md` AC-2 item 8 (v0.7 state)
- **Description:** Fix round 4 collapsed AC-2 item 8 to a single pattern `'^rustc 1\.85\.0 '`. This pass independently confirmed that (a) the template and normalization-rule forms were removed, and (b) the remaining single form `'^rustc 1\.85\.0 '` is character-for-character identical to the actual `rustc --version` output under `RUSTUP_TOOLCHAIN=1.85.0`. The fix is verified effective. However, the Novelty Assessment for this finding class is retained at LOW because the fix-round's consolidation removed two of three forms — a reader auditing the history of AC-2 item 8 changes needs the record. No residual defect.

  **Note:** The related AC-2 item 6 partial-version predicate is a distinct finding (see LOW-002).

- **Evidence:** `S-641-1.md` v0.7 AC-2 item 8; `rustc 1.85.0 (4d91de4e4 2025-02-17)` actual output.
- **Proposed Fix:** None — RESOLVED by fix round 4.
- **Status:** RESOLVED in fix round 4.

---

#### ADV-P13-LOW-002: S-576-5 SS-04 row added but `src/api/jira/issues.rs` row NOT present at the time of independent re-derivation
- **Severity:** LOW
- **Category:** spec-fidelity / GAP · fix-residual
- **Location:** `.factory/stories/S-576-5.md` File Structure Requirements
- **Description:** Pass 12 (MED-005) identified that S-576-5 File Structure Requirements had no row for `src/api/jira/issues.rs`. Fix round 4 added the missing row. This pass re-derived from ground truth and confirmed: (a) `src/api/jira/issues.rs:444` does contain `get_issue_project_key`; (b) the story's File Structure Requirements table now includes the `src/api/jira/issues.rs | MODIFY` row at fix-round-4 state. Confirming as RESOLVED; retaining the finding at LOW in this pass's record for audit completeness.

- **Evidence:** `S-576-5.md` File Structure Requirements post-fix-round-4; `src/api/jira/issues.rs` at line 444.
- **Proposed Fix:** None — RESOLVED by fix round 4.
- **Status:** RESOLVED in fix round 4.

---

#### ADV-P13-LOW-003: `ci.yml` line citation `~:98` appears at 3 sites in S-626-1.md but actual line is now `~:112`
- **Severity:** LOW
- **Category:** spec-fidelity / REFINEMENT · spec artifact
- **Location:** `.factory/stories/S-626-1.md` at 3 sites (AC-2 table, Architecture Mapping, File Structure Requirements)
- **Description:** S-626-1.md cites `ci.yml ~:98` at three distinct locations: the AC-2 evidence table, the Architecture Mapping section, and the File Structure Requirements table. The actual `dtolnay/rust-toolchain` pin line in the delivered `ci.yml` is at approximately line 112 (the line moved from ~:85 in an earlier commit to ~:112 after the msrv job was restructured). Line ~:98 now points into the `deny` job, not the msrv job. A verifier running `sed -n '98p' .github/workflows/ci.yml` would see a deny-job line, not the toolchain pin.

- **Evidence:** `ci.yml` at line 112 (dtolnay pin); `S-626-1.md` three citation sites reading ~:98.
- **Proposed Fix:** Update all three `ci.yml ~:98` citations to `ci.yml ~:112`.
- **Status:** FIXED in fix round 4 — all three sites updated to `~:112`.

---

#### ADV-P13-LOW-004: `sign-and-publish.yml` citation reads `~:64`; actual dtolnay pin line is `~:65`
- **Severity:** LOW
- **Category:** spec-fidelity / REFINEMENT · spec artifact
- **Location:** `.factory/stories/S-626-1.md` AC-5 table and MUST-NOT section
- **Description:** S-626-1.md cites the `sign-and-publish.yml` dtolnay pin at `~:64`. The MUST-NOT protection list in AC-5 also references this line. The actual line in the delivered `sign-and-publish.yml` containing the dtolnay/rust-toolchain pin is at approximately line 65. A one-line discrepancy means a verifier running `sed -n '64p' sign-and-publish.yml` would see the line before the pin (a job step's `uses:` prefix or a surrounding step key), not the pin line itself.

- **Evidence:** `sign-and-publish.yml` at line 65 (dtolnay pin); `S-626-1.md` AC-5 table/MUST-NOT citing `~:64`.
- **Proposed Fix:** Update both citation sites from `~:64` to `~:65`.
- **Status:** FIXED in fix round 4 — `~:64` → `~:65` at both sites.

---

#### ADV-P13-LOW-005: `backfill-release.yml` citation reads `~:79`; actual dtolnay pin line is `~:80`
- **Severity:** LOW
- **Category:** spec-fidelity / REFINEMENT · spec artifact
- **Location:** `.factory/stories/S-626-1.md` AC-5 table and Task 4 ranges
- **Description:** S-626-1.md cites the `backfill-release.yml` dtolnay pin at `~:79`. The delivered `backfill-release.yml` has the dtolnay/rust-toolchain pin at approximately line 80. The one-line off-by-one means the MUST-NOT protection range in the story cites an adjacent line rather than the pin itself.

- **Evidence:** `backfill-release.yml` at line 80 (dtolnay pin); `S-626-1.md` citing `~:79`.
- **Proposed Fix:** Update citation from `~:79` to `~:80`.
- **Status:** FIXED in fix round 4 — `~:79` → `~:80` corrected.

---

#### ADV-P13-LOW-006: BC-5.3.001 and BC-5.3.003 `Source:` fields do not cite the `jr issue list` tests that exist in `tests/cli_handler.rs`
- **Severity:** LOW
- **Category:** spec-fidelity / GAP · spec artifact
- **Location:** `.factory/specs/prd/bc-5-boards-sprints.md` BC-5.3.001 Source, BC-5.3.003 Source
- **Description:** Fix round 3 extended BC-5.3.001's scope to include `jr issue list` behavior. Fix round 4 added the no-suffix `.not()` assertion to `tests/cli_handler.rs::test_list_team_column_falls_back_to_uuid_when_cache_missing`. However, both BC-5.3.001 and BC-5.3.003 `Source:` fields cite only `tests/team_column_parity.rs` tests — the `tests/cli_handler.rs` test functions that cover the issue-list code path are not cited. A coverage audit of BC-5.3.001 from the Source field alone would miss the issue-list coverage entirely.

  The uncited tests are:
  - `tests/cli_handler.rs::test_list_shows_team_column_with_cached_name` (positive path, BC-5.3.001)
  - `tests/cli_handler.rs::test_list_team_column_falls_back_to_uuid_when_cache_missing` (no-suffix path, BC-5.3.003)

- **Evidence:** `bc-5-boards-sprints.md` BC-5.3.001 and BC-5.3.003 Source fields; `tests/cli_handler.rs` at named test functions.
- **Proposed Fix:** Add `tests/cli_handler.rs::test_list_shows_team_column_with_cached_name` to BC-5.3.001 Source and `tests/cli_handler.rs::test_list_team_column_falls_back_to_uuid_when_cache_missing` to BC-5.3.003 Source.
- **Status:** FIXED in fix round 4 — both Source fields now cite the cli_handler.rs tests.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 4 |
| LOW | 6 |
| INFO | 0 |

**Overall Assessment:** NOT CLEAN — 0 HIGH + 4 MEDIUM + 6 LOW; zero code defects. Policy rubric ABSENT (`.factory/policies.yaml` does not exist) — baseline applied.

**Window status:** ELIGIBLE (isolation CLEAN). NOT CLEAN. Window count: 2 of 3 required NOT CLEAN.

**Severity pattern:** Zero HIGH in this pass — confirming severity decay from window 9/10/11 (4 HIGH each). Code remains 0-defect across ten consecutive independent passes (6-14 ELIGIBLE + VOID). All findings are spec-artifact quality issues.

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 13 (WINDOW-ELIGIBLE — isolation CLEAN) |
| **New findings** | 4 independent derivations (MED-001 BC-5.3.001 sprint.rs Source gap; MED-002 BC-5.3.003 no-suffix uncovered; MED-003 AC-005 third site; MED-004 S-576 family status drift) |
| **Duplicate/variant findings** | 6 (LOW-001 AC-2 item 8 residual; LOW-002 SS-04 confirmation; LOW-003/004/005 citation drift; LOW-006 Source coverage gap) |
| **Novelty score** | 4 / (4 + 6) = 0.40 |
| **Median severity** | LOW |
| **Code defects** | 0 |
| **Trajectory** | 10→13→5→15→18→13→10→10 (findings per pass: P6=10, P7=13, P8=5, P9=15, P10=18, P11=13, P12=10, P13=10) |
| **Verdict** | FINDINGS_REMAIN — NOT CLEAN; 0 HIGH + 4 MEDIUM + 6 LOW; zero code defects; ZERO HIGH second consecutive pass in this window |
