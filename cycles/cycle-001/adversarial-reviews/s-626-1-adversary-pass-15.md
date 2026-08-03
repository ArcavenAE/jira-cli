---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-03T21:00:00Z
phase: 5
inputs:
  - .factory/stories/S-626-1.md
  - .factory/stories/S-640-1.md
  - .factory/stories/S-641-1.md
  - .factory/stories/S-MAINT-576-HYG-1.md
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
input-hash: "9a1a68e"
traces_to: .factory/stories/S-626-1.md
story: S-626-1
cycle: cycle-001
pass: 15
agent: adversary
basis: TRUE ADVERSARY AGENT
date: 2026-08-03
feature_head: c88374b41ee4ea30bc2406e1def90cedf3686275
pr: 667
verdict: "NOT CLEAN — 0 HIGH + 6 MEDIUM + 9 LOW; zero code defects"
previous_review: .factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-14.md
isolation: CLEAN
---

# Adversarial Review — S-626-1 (SOH-DX-1), Pass 15

## Provenance

This artifact is a **DIRECT CAPTURE** of adversary reviewer output relayed by the orchestrator, recorded same-session. The reviewer's findings were relayed verbatim immediately after the pass completed.

**Policy rubric:** `.factory/policies.yaml` does not exist. Baseline applied (POL-11 positive-coverage, S-7.01 partial-fix discipline, semantic-anchoring severity ladder, six mandated axes).

---

## Isolation

**CLEAN.** No banned-path file read. No prior adversary pass artifacts accessed. Incidental exposure: banned-path filenames (`ci.yml:212-214`, `demos/S-626-1/AC-001.txt:7-8`) appeared as quoted text INSIDE in-perimeter files; no content read. Self-disclosed.

---

## Finding ID Convention

Finding IDs for this pass use the format `ADV-P15-[SEV]-NNN`. Consistent with prior passes in this series.

---

## Part A — Fix Verification

| ID | Previous Finding | Status | Notes |
|----|-----------------|--------|-------|
| ADV-P14-MED-001 | BC-5.3.001 Behavior claims sprint.rs and board.rs gates "identical" | FIXED — Behavior restated per-site | BC-5.3.001 now describes board.rs/list.rs (if-gate) vs sprint.rs (match-arm) separately ✓ |
| ADV-P14-MED-002 | BC-5.3.003 Source field missing no-suffix tests | PARTIALLY FIXED — new F-15 found | Source updated; but test comment coverage claim incomplete (F-15: board.rs no-suffix pin absent) |
| ADV-P14-MED-003 | AC-005 release.yml third-site format (ACCEPTED) | ACCEPTED — confirmed | Acceptance carried forward ✓ |
| ADV-P14-MED-004 | S-641-1 AC-2 item 6 two-component predicate | FIXED — three-component predicate applied | AC-2 item 6 now `^=\d+\.\d+\.\d+` ✓; but new F-13 found (AC-2 step-count mismatch) |
| ADV-P14-LOW-001 | BC-5.3.001 Source board.rs confirmation | CONFIRMED — no action required | |
| ADV-P14-LOW-002 | S-626-1 line citations stale | FIXED — citations updated | S-626-1 v1.10 updated ✓; but F-02 found new instance at blockquote range (4 remaining sites) |
| ADV-P14-LOW-003 | BC-5.3.001/003 Source symbols partially absent | PARTIALLY FIXED — F-14 found | BC-table Title column carries enrichment absent from BC-INDEX row (new shape of same class) |
| ADV-P14-LOW-004 | S-576 drift routing DEC-208 confirmed | CONFIRMED | S-MAINT-576-HYG-1 created; but F-10/11/12 found new issues in that new story |
| ADV-P14-LOW-005 | Cargo.lock phrasing ambiguity (ACCEPTED) | ACCEPTED — confirmed | |

**Round-4 mechanical sweep re-verified:** Pass-15 byte-diffed all six `sed` transcripts, all four grep transcripts, and every cited line number from fix round 4. ZERO fidelity defects. Round 4 executed its mechanical mandate essentially perfectly but failed its class-sweep mandate for the fourth consecutive round: 8 of 15 new findings are attributable to newly-written prose in fix round 4.

---

## Part B — New Findings

### HIGH

*None.*

### MEDIUM

#### ADV-P15-MED-001: S-626-1 AC-3 states omitting EITHER the `with:` block OR the env override is the silent failure vector — contradicts all sibling authorities
- **Severity:** MEDIUM
- **Category:** spec-fidelity / GAP · fix-introduced
- **Location:** `.factory/stories/S-626-1.md` AC-3 (~:278)
- **Description:** Fix round 4 restated AC-3 to say that omitting EITHER the `with:` block OR the env override produces silent success. The delivered `CLAUDE.md:~219` and the story's own `EC-3` both say only the env override omission is the silent vector; the `with:` block omission causes a hard build failure (toolchain not pinned). AC-3 is the outlier in its own document.
- **Evidence:** `S-626-1.md` AC-3 ~:278; `CLAUDE.md` ~:219 env-override-only clause; `EC-3` env-override-only description.
- **Proposed Fix:** Restate AC-3: the silent failure vector is env-override omission only; `with:` block omission is a hard build failure (distinct failure mode). Cite the CLAUDE.md line.
- **Status:** FIXED in fix round 5 — AC-3 corrected (env-override omission = silent; with: omission = hard failure, routed-unverified against pinned action.yml).

---

#### ADV-P15-MED-002: BLOCKING do-not-remove blockquote cites `backfill-release.yml (~:73-79)` — excludes line 80, the `run: rustup target add` statement the constraint protects
- **Severity:** MEDIUM
- **Category:** spec-fidelity / GAP · partial-propagation
- **Location:** 6 sites across two stories
- **Description:** The BLOCKING do-not-remove blockquote in multiple story sections reads `backfill-release.yml (~:73-79)`. Line 80 is the `run: rustup target add aarch64-apple-darwin` statement — the exact line the constraint is protecting. The range `~:73-79` excludes the protected line; lines 72 (blank), 73-76 (comments), 77 (name:), 78 (if:), 79 (shell:), and 80 (run:). Fix round 4 corrected 2 of 6 sites and left 4 incorrect. Additionally, two `release.yml ~:43-45` citations remain stale (correct is `~:46`); and one site mentions "fourth rustup target add site" where the canonical count is three.
- **Evidence:** `backfill-release.yml` lines 72-80 verified; 4 remaining blockquote sites across S-626-1.md and S-641-1.md.
- **Proposed Fix:** Update all 4 remaining `~:73-79` → `~:73-80`; update `~:43-45` → `~:46` at 2 sites; change "fourth" → "third" at 3 sites.
- **Status:** FIXED in fix round 5 — all 4 range sites + 2 release.yml + 3 "fourth"→"third" sites corrected.

---

#### ADV-P15-MED-003 (mis-anchor, blocks by rule): AC-9 anchor `handle_board_view` — symbol does not exist in `src/cli/board.rs`
- **Severity:** MEDIUM
- **Category:** spec-fidelity / MIS-ANCHOR
- **Location:** `.factory/stories/S-626-1.md` AC-9
- **Description:** AC-9 anchors the board rewrite to `src/cli/board.rs::handle_board_view`. This symbol does not exist. The correct symbol is `handle_view` (`board.rs:~173`). The file also declares `handle_list:~125` — a proximity-resolving reader lands on the wrong function. Fix round 4 wrote `handle_view` correctly in the new BC-5.3.003 prose and left the story AC-9 site wrong.
- **Evidence:** `grep -n 'fn handle' src/cli/board.rs` → `handle_list:~125`, `handle_view:~173`; `S-626-1.md` AC-9 cites `handle_board_view`; no such symbol in the file.
- **Proposed Fix:** Replace `handle_board_view` → `handle_view` in S-626-1 AC-9.
- **Status:** FIXED in fix round 5 — `handle_board_view` → `handle_view` in S-626-1 AC-9.

---

#### ADV-P15-MED-004: STORY-INDEX arithmetic self-contradictory — frontmatter `total_stories: 123` vs body "Final totals: 122 stories (authoritative count — see `total_stories` frontmatter)"
- **Severity:** MEDIUM
- **Category:** spec-fidelity / GAP · fix-introduced
- **Location:** `.factory/stories/STORY-INDEX.md`
- **Description:** STORY-INDEX frontmatter declares `total_stories: 123` (set by fix round 4 for the S-MAINT-576-HYG-1 addition). Three body surfaces still read "122": the "Final totals" prose line (which includes a self-refuting note "authoritative count — see `total_stories` frontmatter"), the Wave Plan feature-followup column total (87 not updated to 88), and the sum formula `7+8+7+10+3+87 = 122`. Additionally, the changelog records no v1.5.53→v1.5.54 delta; and the new row carries wave label "maintenance" while the file documents the "feature-followup" wave.
- **Evidence:** `STORY-INDEX.md` frontmatter `total_stories: 123`; body "Final totals: 122"; Wave Plan feature-followup = 87; sum formula missing S-MAINT-576-HYG-1; changelog gap.
- **Proposed Fix:** Update all three "122" → "123" body surfaces; sum formula `87` → `88` and total `122` → `123`; add v1.5.53→v1.5.54 and v1.5.54→v1.5.55 changelog entries; correct wave label "maintenance" → "feature-followup".
- **Status:** FIXED in fix round 5 — STORY-INDEX v1.5.55; all surfaces corrected; both changelog entries added; wave label corrected.

---

#### ADV-P15-MED-005: S-641-1 AC-2 item 2 normalization rule mandates three-component form "exclusively" but delivered README badge is two-component `MSRV-1.85`
- **Severity:** MEDIUM
- **Category:** spec-fidelity / GAP · spec artifact
- **Location:** `.factory/stories/S-641-1.md` AC-2 item 2
- **Description:** AC-2 item 2 adds a normalization rule beside the MSRV assertion that requires "three-component form exclusively (e.g., `1.85.0`)." The delivered README badge uses the Shields.io convention `MSRV-1.85` — a two-component form. A guard implemented from AC-2 item 2 as written would fail on a correct, delivered tree.
- **Evidence:** `S-641-1.md` AC-2 item 2 normalization rule; README.md badge `MSRV-1.85`; Shields.io MSRV badge convention is two-component.
- **Proposed Fix:** Add a carve-out to the normalization rule: the three-component requirement applies to CI-context assertions (compiler version output, job names, scope comments); the README badge follows Shields.io two-component convention and is excluded from the rule.
- **Status:** FIXED in fix round 5 — README badge carve-out added to AC-2 item 2.

---

#### ADV-P15-MED-006 (mis-anchor, blocks by rule): AC-9 traces to "BC-5.3.001 postcondition 1" and "BC-5.3.002 postcondition 1" — neither BC has a `Postconditions` block; BC-5.3.002 has no `Behavior` field at all
- **Severity:** MEDIUM
- **Category:** spec-fidelity / MIS-ANCHOR · trace-unfalsifiable
- **Location:** `.factory/stories/S-626-1.md` AC-9; `.factory/specs/prd/bc-5-boards-sprints.md` BC-5.3.001, BC-5.3.002
- **Description:** S-626-1 AC-9 traces two test comment lines to "BC-5.3.001 postcondition 1" and "BC-5.3.002 postcondition 1", and a third to "BC-5.3.003 postcondition." None of the three BCs carried a `Postconditions` block at the time of pass-15. Furthermore, BC-5.3.002 had no `Behavior` field while the story claimed "Full" coverage of it — a BC with no normative body cannot be "fully covered." `Postconditions` is a live idiom (~43 uses in `bc-3-issue-write.md`), making its absence conspicuous. A `check-bc-citation-symbols.sh` guard would pass (the script scopes `src/` only) while the story traces to phantom sub-elements.
- **Evidence:** `bc-5-boards-sprints.md` BC-5.3.001, BC-5.3.002, BC-5.3.003 — no `Postconditions` section; BC-5.3.002 no `Behavior` field; `S-626-1.md` AC-9 "postcondition" citations; `bc-3-issue-write.md` ~43 live `Postconditions` uses.
- **Proposed Fix:** Add numbered `**Postconditions**` blocks to BC-5.3.001, BC-5.3.002, BC-5.3.003; add `**Behavior**` field to BC-5.3.002 with normative body derived from delivered source lines. Existing "postcondition 1" citations then resolve to defined conditions.
- **Status:** FIXED in fix round 5 — `Postconditions` blocks ADDED to BC-5.3.001/002/003; `Behavior` field ADDED to BC-5.3.002.

---

### LOW

#### ADV-P15-LOW-001: STORY-INDEX S-576-5 row version mismatch — says "story v1.47" while file is v1.48; sibling S-576-3 similarly v1.45 vs v1.46
- **Severity:** LOW
- **Category:** spec-fidelity / REFINEMENT · propagation-miss
- **Location:** `.factory/stories/STORY-INDEX.md` S-576-5 and S-576-3 rows
- **Description:** STORY-INDEX lists S-576-5 at "story v1.47" while the S-576-5.md file carries version v1.48 (bumped in fix round 3/4). Sibling S-576-3 shows v1.45 while the file is v1.46.
- **Evidence:** `STORY-INDEX.md` S-576-5 row; `S-576-5.md` frontmatter `version: "1.48"`; STORY-INDEX S-576-3 row; `S-576-3.md` frontmatter `version: "1.46"`.
- **Proposed Fix:** Update STORY-INDEX S-576-5 row to v1.48; S-576-3 row to v1.46.
- **Status:** FIXED in fix round 5 — S-MAINT-576-HYG-1 Task 4 re-scoped to verify the already-applied increment (and these row corrections applied).

---

#### ADV-P15-LOW-002 (round-4-introduced): AC-005.txt claimed "All three E0463 comments" — only two exist; `release.yml` has the step at `:46` but no comment
- **Severity:** LOW
- **Category:** evidence-integrity / transcript-fidelity
- **Location:** `.factory/demos/S-626-1/AC-005.txt`
- **Description:** AC-005.txt BEFORE block annotation reads "All three E0463 comments" — a count that fix round 4 itself introduced. Only two E0463 comments exist in the codebase: one in `ci.yml` and one in `sign-and-publish.yml`. The `release.yml` step at `:46` runs `rustup target add` but carries no E0463 comment. The annotation is false, counting an absent comment as present.
- **Evidence:** `grep -n 'E0463' .github/workflows/ci.yml sign-and-publish.yml release.yml` → ci.yml + sign-and-publish.yml only; `release.yml:46` — bare step, no comment.
- **Proposed Fix:** Change "All three E0463 comments" to "Two E0463 comments (release.yml has the step at :46 but no comment)" or equivalent accurate phrasing.
- **Status:** FIXED in fix round 5 — count corrected to two-with-asymmetry.

---

#### ADV-P15-LOW-003 (round-4-introduced): INDEX.md Regeneration Log entry for release.yml evidence logged `sed -n '40,52p'` while artifact executes `'38,52p'`
- **Severity:** LOW
- **Category:** evidence-integrity / transcript-fidelity
- **Location:** `.factory/demos/S-626-1/INDEX.md` Regeneration Log
- **Description:** The Regeneration Log entry for AC-005 (release.yml evidence) records the sed command as `sed -n '40,52p'`. The AC-005.txt artifact itself executes `sed -n '38,52p'`. Range size mismatch: `40,52` = 13 lines vs `38,52` = 15 lines. A verifier cross-checking the log against the artifact detects the discrepancy immediately.
- **Evidence:** `INDEX.md` Regeneration Log AC-005 release.yml row; `AC-005.txt` BEFORE block sed command `'38,52p'`.
- **Proposed Fix:** Update the Regeneration Log entry to `sed -n '38,52p'`.
- **Status:** FIXED in fix round 5 — sed range corrected in INDEX.md.

---

#### ADV-P15-LOW-004 (round-4-introduced, new story): S-MAINT-576-HYG-1 misstated ARCH-INDEX coverage — claimed `tests/` covered; it is not; omitted `Cargo.toml`/`build.rs`/`deny.toml`
- **Severity:** LOW
- **Category:** spec-fidelity / GAP · fix-introduced
- **Location:** `.factory/stories/S-MAINT-576-HYG-1.md`
- **Description:** S-MAINT-576-HYG-1 (created by fix round 4) states that ARCH-INDEX coverage includes `tests/` — this is wrong; ARCH-INDEX does not register `tests/`. The story omits `Cargo.toml`, `build.rs`, and `deny.toml` from its ARCH-INDEX scope description, all of which ARE covered.
- **Evidence:** `ARCH-INDEX.md` scope declaration; S-MAINT-576-HYG-1 ARCH-INDEX coverage claim.
- **Proposed Fix:** Restate ARCH-INDEX coverage correctly: covers `src/`, `Cargo.toml`, `build.rs`, `deny.toml`, `.github/workflows/`; explicitly exclude `tests/`, `.factory/`, `docs/`.
- **Status:** FIXED in fix round 5 — ARCH-INDEX coverage restated correctly.

---

#### ADV-P15-LOW-005 (round-4-introduced, new story): S-MAINT-576-HYG-1 declares SS-03 has 8 files; ARCH-INDEX and the story's own AC-3 enumerate 6
- **Severity:** LOW
- **Category:** spec-fidelity / GAP · fix-introduced
- **Location:** `.factory/stories/S-MAINT-576-HYG-1.md`
- **Description:** S-MAINT-576-HYG-1 states "SS-03 has 8 files" in one section while the story's own AC-3 correctly enumerates 6 (matching ARCH-INDEX). Two surfaces of the same story disagree.
- **Evidence:** S-MAINT-576-HYG-1 SS-03 section "8 files"; AC-3 enumeration 6 files; ARCH-INDEX SS-03 declaration.
- **Proposed Fix:** Correct "8 files" → "6 files" (closed list per AC-3 enumeration).
- **Status:** FIXED in fix round 5 — "8 files" → closed six-file list.

---

#### ADV-P15-LOW-006 (round-4-introduced, new story): S-MAINT-576-HYG-1 `tdd_mode: strict` with `test_files: []` and a MUST-NOT forbidding `tests/` edits — documentation-only story, constraint is unsatisfiable
- **Severity:** LOW
- **Category:** spec-fidelity / GAP · fix-introduced
- **Location:** `.factory/stories/S-MAINT-576-HYG-1.md`
- **Description:** S-MAINT-576-HYG-1 declares `tdd_mode: strict` alongside `test_files: []` (empty) and a MUST-NOT constraint forbidding any `tests/` edits. TDD strict mode requires test-first delivery; an empty test_files list with a prohibition on creating tests is internally contradictory. A documentation-only or maintenance story should declare `tdd_mode: standard` (or equivalent) and note that no new tests are added.
- **Evidence:** S-MAINT-576-HYG-1 frontmatter `tdd_mode: strict`, `test_files: []`; MUST-NOT constraint on `tests/`; story scope (metadata corrections only — no executable behavior).
- **Proposed Fix:** Change `tdd_mode: strict` → `tdd_mode: standard`; remove the unsatisfiable MUST-NOT `tests/` constraint.
- **Status:** FIXED in fix round 5 — `tdd_mode: standard`; MUST-NOT removed.

---

#### ADV-P15-LOW-007 (round-4-introduced, new story): S-MAINT-576-HYG-1 Task 4 instructed STORY-INDEX work that fix round 4 had already done
- **Severity:** LOW
- **Category:** spec-fidelity / GAP · fix-introduced
- **Location:** `.factory/stories/S-MAINT-576-HYG-1.md` Task 4
- **Description:** Task 4 instructs: "Apply the 122→123 increment to STORY-INDEX.md." Fix round 4 already applied this increment when writing STORY-INDEX v1.5.54. The task as written would cause a second application (double-increment to 124). The task should be a VERIFY step, not a DO step.
- **Evidence:** S-MAINT-576-HYG-1 Task 4; STORY-INDEX.md v1.5.54 frontmatter `total_stories: 123` (already applied).
- **Proposed Fix:** Re-scope Task 4 to VERIFY rather than APPLY: "Verify STORY-INDEX.md total_stories is 123 (applied in fix round 4); confirm no further increment needed."
- **Status:** FIXED in fix round 5 — Task 4 re-scoped to VERIFY.

---

#### ADV-P15-LOW-008 (round-4-introduced): S-641-1 AC-2 algorithm described as "three-step" but the body enumerates four steps; step 4 assembles the pattern without the surrounding quotes cited in the prose
- **Severity:** LOW
- **Category:** spec-fidelity / GAP · fix-introduced
- **Location:** `.factory/stories/S-641-1.md` AC-2 item 8 algorithm
- **Description:** AC-2 item 8 calls its MSRV assertion algorithm "three-step" and then lists four numbered steps. Additionally, step 4 assembles the regex pattern as bare characters without the surrounding single-quotes the prose says are checked — the prose says `grep ... '^rustc ...'` while step 4 shows the pattern without the quote chars.
- **Evidence:** S-641-1.md AC-2 item 8: "three-step" followed by 4 numbered items; step 4 regex missing surrounding quotes.
- **Proposed Fix:** Change "three-step" → "four-step"; add quotes around pattern in step 4.
- **Status:** FIXED in fix round 5 — "four-step" and quotes aligned to `'^rustc 1\.85\.0 '`.

---

#### ADV-P15-LOW-009: S-626-1 BC-table row Title column carries an enrichment absent from the canonical BC-INDEX row and BC H1
- **Severity:** LOW
- **Category:** spec-fidelity / REFINEMENT · drift
- **Location:** `.factory/stories/S-626-1.md` BC behavioral contracts table
- **Description:** The BC-table row for at least one BC carries a Title column value with additional contextual enrichment (e.g., parenthetical or qualifier) not present in the canonical BC-INDEX row or the BC's own H1 heading. This creates an inconsistency where the story's table and the canonical registry describe the same BC differently.
- **Evidence:** S-626-1.md BC-table Title column; BC-INDEX row for the same BC; bc-5-boards-sprints.md H1 for the same BC — the three do not match verbatim.
- **Proposed Fix:** Move the Title column content to the Scope column so the Title field mirrors the BC-INDEX verbatim.
- **Status:** FIXED in fix round 5 — BC-table enrichment moved Title → Scope.

---

#### ADV-P15-LOW-010: `c88374b4` test comment claimed `.not()` assertion guards board.rs/list.rs/sprint.rs; the assertion observes only sprint.rs; board.rs had NO no-suffix pin anywhere
- **Severity:** LOW
- **Category:** spec-fidelity / GAP · test-coverage-claim
- **Location:** `tests/team_column_parity.rs` test comment at commit `c88374b4`; AC-9 trace
- **Description:** The test comment for the no-suffix pin asserted that the `.not()` assertion covers all three render sites (board.rs, list.rs, sprint.rs). The assertion in the test body observes only sprint.rs output. More critically, no test anywhere pins board.rs's `handle_view` fallback render site (BC-5.3.003 implementation) with a no-suffix negative assertion — the coverage claim was false in both directions.
- **Evidence:** `tests/team_column_parity.rs` test body (sprint.rs observation only); `grep -n 'board' tests/team_column_parity.rs` → zero no-suffix pins at `c88374b4`; AC-9 trace "all three render sites."
- **Proposed Fix:** Add a `board.rs`-scoped no-suffix negative assertion to `team_column_parity.rs`; correct test comment to describe only the observed site. Non-vacuity proven in both directions.
- **Status:** FIXED in fix round 5 — product commit `6d73b3ef` adds `test_board_view_falls_back_to_uuid_when_team_not_cached` (BC-5.3.003 positive-path pin; `.not()` guards board.rs render site; non-vacuity verified both directions). BC-5.3.003 added to S-626-1 bcs:/behavioral_contracts:/AC-9 trace. Test count 2343→2344.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 6 |
| LOW | 9 |
| INFO | 0 |

**Overall Assessment:** NOT CLEAN — 0 HIGH + 6 MEDIUM + 9 LOW; zero code defects. Policy rubric ABSENT (`.factory/policies.yaml` does not exist) — baseline applied.

**Window status:** ELIGIBLE (isolation CLEAN). NOT CLEAN. Window count: 1 of 1 evaluated (new window opened; passes 16/17 NOT RUN per orchestrator ruling — superseded by round-5; next window targeted at passes 18/19/20).

**TREND REVERSAL RECORDED:** Findings rose from 10/10/9 (window 12/13/14) to **15**. **8 of 15 are round-4-attributable**: 6 defects in prose round 4 newly wrote (F-01, F-04, F-08, F-09, F-10/11/12, F-13), plus 2 propagation misses (F-02 partial fix, F-07 version mismatch). This reverses the earlier severity-decay trend. Mechanical checks work; editorial sweeps do not: round 4 executed its mechanical mandate essentially perfectly (zero fidelity defects in byte-diff of all transcripts) but failed its class-sweep mandate for the fourth consecutive round.

**Severity pattern:** ZERO HIGH — tenth consecutive pass with no HIGH findings (code remains 0-defect). All findings are spec-artifact quality issues, not implementation gaps.

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 15 (WINDOW-ELIGIBLE — isolation CLEAN) |
| **New findings** | 6 MEDIUM (MED-001 AC-3 contradiction; MED-002 blockquote range partial; MED-003 mis-anchor handle_board_view; MED-004 STORY-INDEX arithmetic; MED-005 badge normalization; MED-006 missing Postconditions/Behavior) + 9 LOW |
| **Round-4-attributable** | 8 of 15 (6 in new prose + 2 propagation misses) |
| **Code defects** | 0 |
| **Trajectory** | P6=10, P7=13, P8=5, P9=15, P10=18, P11=13, P12=10, P13=10, P14=9, **P15=15** |
| **Verdict** | FINDINGS_REMAIN — NOT CLEAN; 0 HIGH + 6 MEDIUM + 9 LOW; zero code defects; TREND REVERSAL from 9→15 |
| **Reviewer recommendation** | A STORY-INDEX coherence guard and a BC sub-element citation guard would have caught F-03, F-04, F-06, F-07, and F-11 without a human in the loop; a fifth manual sweep is likely to close the flagged sites and open a comparable number of new ones. |
