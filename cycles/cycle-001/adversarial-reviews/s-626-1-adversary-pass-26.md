---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-04T20:00:00Z
phase: 5
inputs:
  - .factory/stories/S-626-1.md
  - .factory/stories/S-640-1.md
  - .factory/stories/S-641-1.md
  - .factory/stories/S-MUTANTS-EXAMINE-GLOBS-1.md
  - .factory/stories/STORY-INDEX.md
  - .factory/demos/S-626-1/
  - .github/workflows/ci.yml
  - tests/ci_gate_completeness.rs
  - tests/cli_handler.rs
  - CLAUDE.md
  - Cargo.toml
input-hash: "6b4d0aa"
traces_to: .factory/stories/S-626-1.md
story: S-626-1
cycle: cycle-001
pass: 26
agent: adversary
basis: TRUE ADVERSARY AGENT
date: 2026-08-04
feature_head: 14416fd9
pr: 667
verdict: "NOT CLEAN — 2 substantive findings (1 MEDIUM + 1 LOW); 2 INFO concurrences; 1 LOW pre-existing ROUTED; ELIGIBLE; window 24/25/26 BROKEN 2/3"
previous_review: .factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-25.md
isolation: ELIGIBLE (one self-disclosed deviation — repo-root grep with exclusion pattern returned zero results; no content read)
---

# Adversarial Review — S-626-1 (SOH-DX-1), Pass 26

## Provenance

This artifact is a **DIRECT CAPTURE** of adversary reviewer output relayed by the orchestrator, recorded same-session. Pass-26 ran against feature HEAD `14416fd9` (the DEC-223 fresh STRICT window). This is the third pass in the fresh STRICT window (passes 24/25/26) mandated by DEC-223. **Pass-26 broke the window at 2/3.**

**Policy rubric:** `.factory/policies.yaml` does not exist. Baseline applied (POL-11 positive-coverage, S-7.01 partial-fix discipline, semantic-anchoring severity ladder, six mandated axes).

---

## RECORD PROMINENTLY — WINDOW BROKEN AT 2/3

**Window 24/25/26 CLOSED — 2/3.** Passes 24 and 25 were CLEAN (the first CLEAN verdicts in the cycle). Pass-26 returned NOT CLEAN, breaking the window. Per DEC-199 and DEC-223, a strict 3/3 CLEAN window is required. The fresh STRICT window is **passes 27/28/29**.

**Pass-26 forecast:** *"Expect the next pass to be clean."* The two substantive findings (F-01 and F-02) are both closed by fix round 11 (`e49230a7`). The pre-existing finding (F-04) is routed, not a blocker. F-03 and F-05 are INFO concurrences already closed by round 11.

---

## RECORD PROMINENTLY — CI FLOOR AUDITED SOUND (SIXTH CONSECUTIVE INDEPENDENT CONFIRMATION)

Pass-26 is the sixth consecutive independent reviewer to audit all eight POL-11 pin assertions and find **none satisfiable by comment or unrelated line**. Each of passes 21/22/23/24/25/26 produced its own per-assertion evidence table. The reviewer noted:

- `contains("exit 1")` survives three nearby `exits 1` comment near-misses **by a single character**. Selected near-miss: comment at `:79` reads `"exits 1 on empty match"` vs asserted `"exit 1"` — the trailing ` on` prevents the match.
- All three passes (24/25/26) independently re-derived the 103-binary inventory and all three agree.

---

## Isolation

**ELIGIBLE.** The reviewer disclosed one self-disclosure: a repo-root grep was issued with an exclusion pattern (`--exclude-dir=.factory` or equivalent). The grep returned **"No matches found"** — zero results, no content read. Zero banned content surfaced.

Per the ISOLATION ELIGIBILITY PRINCIPLE (DEC-224): ELIGIBLE, as nothing surfaced. The deviation was self-disclosed unprompted and returned no output.

---

## Finding ID Convention

Finding IDs for this pass use the format `ADV-P26-[SEV]-NNN`. Consistent with prior passes in this series.

---

## Part A — Fix Verification

Pass-26 verified all findings from passes 24 and 25 (both CLEAN, both the preceding executed passes).

| ID | Previous Finding | Status | Notes |
|----|-----------------|--------|-------|
| ADV-P24-LOW-001 | INDEX.md Round-12 positional description error | FIXED — `e49230a7` ✓ | Verified |
| ADV-P25-LOW-001 | "17-entry" examine_globs count | FIXED — `e49230a7` (numeral removed) ✓ | **F-01 below independently confirms** |
| ADV-P25-LOW-002 | ci_gate_completeness.rs stale ~124/~137 citations | FIXED — `e49230a7` (structural form) ✓ | **F-03 below concurs** |
| ADV-P25-LOW-003 | BC-5.3.001 Postcondition 1 — two vs three cell states | FIXED — bc-5-boards-sprints.md update ✓ | Postcondition 1 now enumerates all three states |
| ADV-P25-INFO-001 | Stale line-delta annotation | FIXED — `e49230a7` ✓ | |
| ADV-P25-INFO-002 | STORY-INDEX embedded present-tense bracket | FIXED — STORY-INDEX v1.5.61 ✓ | **F-05 below concurs** |

---

## Part B — New Findings

### MEDIUM

#### ADV-P26-MED-001: `tests/team_column_parity.rs` authorization trail names only 1 of 3 commits; line-delta stale (108 → actual 168) [spec-fidelity / incomplete-audit]

- **Severity:** MEDIUM
- **Category:** spec-fidelity / incomplete-audit / partial-propagation
- **Location:** `stories/S-626-1.md` — AC-9 authorization block + File Structure Requirements row; `stories/STORY-INDEX.md` — S-626-1 row
- **Description:** The AC-9 authorization block and the File Structure Requirements table row for `tests/team_column_parity.rs` claimed *"file existed on origin/develop at 487 lines; this PR appends **108**"* (487 + 108 = 595). However, the current HEAD of the branch is 655 lines, meaning the actual append is **168 lines** (655 − 487 = 168). The stated delta of 108 was correct at commit `b51fc26a` (487 + 108 = 595) but went stale when two further commits landed.

  Additionally, the MUST-NOT-change exception list and the AC-9 block named only `b51fc26a` as the authorizing commit. The file was modified by **three** commits on this branch: `b51fc26a`, `c88374b4`, and `6d73b3ef`. The authorization trail is the audit mechanism for the MUST-NOT fence — an incomplete trail means a reviewer reconciling the diff finds two unrecorded commits touching an authorized test file.

  **Systemic context:** Fix rounds v1.15 (pass-22 F-03) and v1.13 (pass-21 F-05) completed this exact trail for the other two exception-list entries (`tests/ci_gate_completeness.rs` and `tests/cli_handler.rs`). The third file in the same exception list did not receive the same completeness pass. This is a textbook instance of the FIX-ROUND-PARTIAL-PROPAGATION pattern: the fix was applied to two of three siblings but not the third.

  **Orchestrator correction applied in fix round 11:** The orchestrator's fix brief wrongly listed `148a9489` among the authoring commits. The story-writer verified via `git show --name-only` that `148a9489` does NOT touch `tests/team_column_parity.rs`, and corrected the orchestrator. This is evidence that the "verify, don't trust the brief" instruction works as intended.

- **Evidence:** `git log -- tests/team_column_parity.rs` on branch `ci/fix-toolchain-sha-msrv` shows commits `b51fc26a` (487→595, +108), `c88374b4` (595→601, +6), `6d73b3ef` (601→655, +54). HEAD is 655 lines. Total delta: 168 lines. S-626-1 AC-9 block and File Structure Requirements row stated 108.
- **Proposed Fix:** (a) Correct the delta to 168 at both body sites (AC-9 block + File Structure Requirements row). (b) Extend the trail to all three commits at both body sites and the STORY-INDEX row. (c) Verify intermediate counts: b51fc26a→595, c88374b4→601, 6d73b3ef→655.
- **Status:** FIXED — fix round 11 (`e49230a7`): S-626-1 v1.15→v1.16 (delta corrected to 168; trail extended to all three commits at both body sites; STORY-INDEX v1.5.60→v1.5.61: S-626-1 row updated). Intermediate counts verified by story-writer. Exception-list trail completeness confirmed for all three `tests/` files.

---

### LOW

#### ADV-P26-LOW-001: "17-entry" examine_globs count confirmed stale — independently confirming pass-25 [count-in-prose-drift]

- **Severity:** LOW
- **Category:** count-in-prose-drift / independent-confirmation
- **Location:** `ci.yml :: mutants / "Check kill rate"` comment; `tests/mutants_glob_existence.rs` comment
- **Description:** Pass-26 independently confirmed pass-25's ADV-P25-LOW-001 finding: two live sites claim "17-entry" examine_globs whitelist while the actual count is 16. Two of three passes in the window caught this finding, providing two-pass confirmation.
- **Status:** FIXED — fix round 11 (`e49230a7`: numeral removed from both live sites; confirmed by pass-25 fix).

---

#### ADV-P26-LOW-002: Wrong-file mis-anchors in `tests/issue_view_errors.rs` and `tests/team_object_shape.rs` [citation-hygiene / pre-existing]

- **Severity:** LOW
- **Category:** citation-hygiene / wrong-file-mis-anchor / pre-existing
- **Location:** `tests/issue_view_errors.rs:142`; `tests/team_object_shape.rs`
- **Description:** `tests/issue_view_errors.rs:142` cites `src/cli/issue/list.rs:947` for the `(name not cached` string. This string exists ONLY at `src/cli/issue/view.rs:264/269` — a wrong-**file** mis-anchor, not merely a drifted line. Similarly, `tests/team_object_shape.rs` cites `list.rs:983` for a call that is actually at `list.rs:~528`.

  Notably, the **spec layer** (BC files) correctly cites `view.rs` for these strings — the test comments are the unswept siblings. The citation guard (check-bc-citation-symbols.sh) covers `src/` files cited in BC bodies but does NOT cover test-file comment citations. This is the concrete instance the `CITATION-GUARD-SRC-ONLY` drift item and the routed `tests/`-scope citation-guard gap permits.

- **Pre-existing:** These defects are on `develop` and outside the S-626-1 diff. They are not in scope for S-626-1 fix round 11.
- **Proposed Fix:** ROUTE — add to WRONG-FILE-MIS-ANCHORS-IN-TESTS drift item; schedule for a citation-hygiene story.
- **Status:** ROUTED (pre-existing, not in S-626-1 scope). DEC-224 isolation principle notes this as outside diff. Tracked as WRONG-FILE-MIS-ANCHORS-IN-TESTS drift item.

---

### INFO

#### ADV-P26-INFO-001: ci_gate_completeness.rs docstring `ci.yml:~124`/`ci.yml:~137` citations still stale — concurring with pass-25 [stale-line-citation]

- **Severity:** INFO
- **Category:** stale-line-citation / concurrence-with-pass-25
- **Location:** `tests/ci_gate_completeness.rs` docstring
- **Description:** Pass-26 independently concurred with pass-25's ADV-P25-LOW-002 finding. The citations `ci.yml:~124` and `ci.yml:~137` in the test docstring were still present at the reviewed head (14416fd9), with `~137` inverted onto the wrong command. Two of three passes caught this.
- **Status:** FIXED — fix round 11 (`e49230a7`: structural form applied to all four `ci.yml:~NN` citations; confirmed by pass-25 fix).

---

#### ADV-P26-INFO-002: STORY-INDEX embedded stale count — concurring with pass-25 [minor-count-drift]

- **Severity:** INFO
- **Category:** minor-count-drift / concurrence-with-pass-25
- **Location:** `stories/STORY-INDEX.md`
- **Description:** Pass-26 independently concurred with pass-25's ADV-P25-INFO-002 finding. Two of three passes confirmed the STORY-INDEX embedded present-tense bracket contradicted authoritative count surfaces.
- **Status:** FIXED — fix round 11 (STORY-INDEX v1.5.61: embedded present-tense bracket removed).

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 1 |
| LOW | 2 |
| INFO | 2 |

**Overall Assessment:** NOT CLEAN — 1 MEDIUM + 2 LOW; ELIGIBLE (isolation: one deviation returned zero results; no banned content); **EIGHTEENTH consecutive zero-src/-defect pass**. Window 24/25/26 BROKEN 2/3 (pass-26 NOT CLEAN).

**All three passes independently audited the CI floor SOUND:** passes 24/25/26 each produced their own per-assertion evidence table, all finding none of the 8 pin assertions comment-satisfiable. Six consecutive independent confirmations total.

**F-02 is the substantive finding:** Incomplete authorization trail for `tests/team_column_parity.rs` — third file in the MUST-NOT exception list; rounds v1.15 and v1.13 did the same fix for the other two files but not this one. Textbook FIX-ROUND-PARTIAL-PROPAGATION instance; closed by fix round 11.

**F-04 is pre-existing and ROUTED:** Wrong-file mis-anchors in test comments. Outside S-626-1 diff. Tracked as WRONG-FILE-MIS-ANCHORS-IN-TESTS drift item.

**Forecast:** *"Expect the next pass to be clean."* Both substantive findings closed by `e49230a7`. Fresh STRICT window = passes 27/28/29.

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 26 (NOT CLEAN; ELIGIBLE; window BROKEN 2/3) |
| **New findings** | 2 (F-02 MED: authorization trail; F-04 LOW pre-existing: wrong-file mis-anchor) |
| **Duplicate/variant findings** | 3 (F-01 confirms P25-LOW-001; F-03 concurs P25-LOW-002; F-05 concurs P25-INFO-002) |
| **Novelty score** | 0.40 (2/5 — two novel; three are concurrences with pass-25) |
| **Median severity** | LOW |
| **Source of MEDIUM finding** | Incomplete authorization trail for tests/team_column_parity.rs (third exception-list file; partial-propagation of the same fix that completed for the other two files in v1.15/v1.13) |
| **Code defects in src/** | 0 (EIGHTEENTH consecutive pass) |
| **Product defects total** | 0 |
| **Trajectory** | P23=2→P24=1→P25=5→P26=5 |
| **Verdict** | FINDINGS_REMAIN |
| **Reviewer recommendation** | Fix round 11 closes F-01/F-02/F-03/F-05; F-04 is routed as pre-existing. Dispatch passes 27/28/29 against `e49230a7` for the fresh STRICT window. Expect CLEAN. |
