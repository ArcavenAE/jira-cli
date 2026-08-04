---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-04T05:30:00Z
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
input-hash: "9e39b3c"
traces_to: .factory/stories/S-626-1.md
story: S-626-1
cycle: cycle-001
pass: 21
agent: adversary
basis: TRUE ADVERSARY AGENT
date: 2026-08-04
feature_head: a247a343
pr: 667
verdict: "NOT CLEAN — 3 MEDIUM + 3 LOW + 1 INFO; zero code defects in src/; thirteenth consecutive pass"
previous_review: .factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-19.md
isolation: CLEAN
---

# Adversarial Review — S-626-1 (SOH-DX-1), Pass 21

## Provenance

This artifact is a **DIRECT CAPTURE** of adversary reviewer output relayed by the orchestrator, recorded same-session. The reviewer's findings were relayed verbatim immediately after the pass completed. Pass-21 is the first pass of the 21/22/23 STRICT window authorized by DEC-216. Product head at time of review: `a247a343` (fix round 7 product commit; fix round 8 then produced `84ab32ac` closing all findings except F-06).

**Policy rubric:** `.factory/policies.yaml` does not exist. Baseline applied (POL-11 positive-coverage, S-7.01 partial-fix discipline, semantic-anchoring severity ladder, six mandated axes).

---

## RECORD PROMINENTLY — CI FLOOR AUDITED SOUND

Pass-21 gave a dedicated verdict of **SOUND on all four audited dimensions** for the corrected floor (`a247a343`):

**(a) Orphaning detectability:** The binary-count instrument gates on `^test result:` line count, not the passed count, and the reviewer independently enumerated 100 integration targets + lib + bin + doc-tests = 103, so `autotests=false` collapses it to 3 and `-lt 90` fires.

**(b) Diagnostic reachability:** Traced every exit status; confirmed `awk`'s `sum+0` and `wc -l` cannot produce an empty variable, and that `[ ]`/`if !` conditions are exempt from `set -e`.

**(c) Colour robustness:** Step-level `env:` beats workflow-level in Actions precedence, AND libtest colourises only the `ok` token and only on a TTY (stdout here is a pipe), so the anchor is doubly safe.

**(d) Pin specificity:** Four operative assertions to one literal. Two-instrument choice endorsed as non-redundant. Windows leg noted: fails CLOSED under pipefail — loud red, never silent green.

---

## Isolation

**CLEAN.** No banned-path file read. No prior adversary pass artifacts accessed. Incidental exposure: banned-path filenames appeared as quoted text INSIDE in-perimeter files; no content read. Self-disclosed.

---

## Finding ID Convention

Finding IDs for this pass use the format `ADV-P21-[SEV]-NNN`. Consistent with prior passes in this series.

---

## Part A — Fix Verification

Pass-21 verified all 10 findings from pass-19 (the most recent executed pass; pass-20 was SUPERSEDED per DEC-216). Fix rounds 7 and PRE-WINDOW-PREP applied between passes.

| ID | Previous Finding | Status | Notes |
|----|-----------------|--------|-------|
| ADV-P19-HIGH-001 | POL-11 floor `> 0` inert — inline src/ tests bypass check | FIXED — fix round 7 (a247a343: binary-count floor `-lt 90` + named canary) ✓ | All four CI-as-code defects in 9312f11f closed |
| ADV-P19-HIGH-002 | tests/ci_gate_completeness.rs + tests/cli_handler.rs absent from four spec surfaces | FIXED — fix round 7 (S-626-1 v1.13; DEC-214) ✓ | |
| ADV-P19-MED-001 | `FAIL (POL-11)` diagnostic unreachable under pipefail + set -e | FIXED — fix round 7 (a247a343: script restructured; diagnostic reachable) ✓ | |
| ADV-P19-MED-002 | ANSI codes from file-scope CARGO_TERM_COLOR would zero anchored regex | FIXED — fix round 7 (a247a343: CARGO_TERM_COLOR: never at step level) ✓ | CI ran SUCCESS for 9312f11f; speculation of confirmed break refuted |
| ADV-P19-MED-003 | Pin asserts only contains("FAIL (POL-11)") — not exit 1, floor count, positive-coverage | FIXED — fix round 7 (a247a343: pin extended to four surfaces) ✓ | |
| ADV-P19-MED-004 | Round-6 sweep missed one site in S-MUTANTS-EXAMINE-GLOBS-1.md while correcting seven siblings | CLOSED — PRE-WINDOW-PREP burst: conform-to-template pass (S-MUTANTS v1.2→v1.3); all 5 anchor sites now corrected ✓ | Template-compliance hook was the blocker; fully resolved |
| ADV-P19-MED-005 | STORY-INDEX S-641-1 row stale by TWO revisions (v0.6 in row; file at v0.7) | FIXED — fix round 7 (STORY-INDEX v1.5.57; S-641-1 v0.8) ✓ | |
| ADV-P19-MED-006 | fmt and clippy positive-coverage gap (ROUTED per DEC-215) | OPEN — ROUTED per DEC-215; not actioned before this window | Tracked as FMT-CLIPPY-NO-POSITIVE-COVERAGE drift item |
| ADV-P19-LOW-001 | S-640-1 cited RUSTUP_TOOLCHAIN ~16 lines from actual location | FIXED — fix round 7 (S-640-1 v0.6; DEC-213 anchor form) ✓ | |
| ADV-P19-INFO-001 | Demo pack lacked negative-path proof at dispatch | FIXED — PRE-WINDOW-PREP burst: negative-path evidence added to full-suite.txt ✓ | Closed in PRE-WINDOW-PREP burst |

---

## Part B — New Findings

### MEDIUM

#### ADV-P21-MED-001: `tests/ci_gate_completeness.rs` File Structure row carries TWO false claims introduced by fix-round-7's own scope-declaration fix [process-gap]
- **Severity:** MEDIUM
- **Category:** spec-fidelity / process-gap · fix-introduced
- **Location:** `tests/ci_gate_completeness.rs` File Structure Requirements row / story S-626-1.md v1.13 FSR table
- **Description:** The File Structure Requirements row added by fix round 7 (S-626-1 v1.13) to declare `tests/ci_gate_completeness.rs` contained two false claims: (1) The cited test name `test_ci_gate_named_canary_check` **does not exist** anywhere in the worktree. The canary assertion lives inside `test_verify_test_job_has_zero_test_floor` — there is no separate `test_ci_gate_named_canary_check` function. (2) The scope annotation states "9-job needs list" while `ci-gate.needs` has **EIGHT** entries, as the guard's own docstring correctly states. This is the same dead-symbol class pass 15 (F-03) had closed (`handle_board_view`→`handle_view`), re-instantiated by a later round's own fix prose.
- **Evidence:** `grep -r "test_ci_gate_named_canary_check" tests/` → zero results. `ci-gate.needs:` list in ci.yml (8 entries: test, fmt, clippy, msrv, deny, mutants, security, docs). Guard docstring in `tests/ci_gate_completeness.rs` correctly says "8-job needs list."
- **Proposed Fix:** S-626-1 FSR row: `test_ci_gate_named_canary_check` → `test_verify_test_job_has_zero_test_floor`; "9-job" → "8-job" (verify count against ci.yml).
- **Status:** FIXED — fix round 8 (S-626-1 v1.13→v1.14: test name corrected to `test_verify_test_job_has_zero_test_floor`; "8-job" verified against ci.yml eight-element `needs:` list; DEC-217).

---

#### ADV-P21-MED-002: `ci.yml` threshold comment "~103 binaries (1 lib + ~54 integration + ~1 doc)" sums to 56 — false justification for a gate constant
- **Severity:** MEDIUM
- **Category:** spec-fidelity / false-justification
- **Location:** `.github/workflows/ci.yml` POL-11 floor script comment justifying `-lt 90` threshold
- **Description:** The `a247a343` comment reads "~103 binaries (1 lib + ~54 integration + ~1 doc)". These three summands add to 56, not 103. The comment contradicts the demo pack's own correct decomposition in the same story (which correctly derives 103 = 1+1+100+1). The total (`-lt 90`) and the threshold itself are correct; only the in-code justification is false. That comment is the **sole in-repo rationale for a constant on a required gate**, explicitly inviting maintainers to retune it. A maintainer reading "56" would compute the wrong margin.
- **Evidence:** 1 + 54 + 1 = 56 ≠ 103. Demo pack `full-suite.txt` correctly says "103 test binaries." ci.yml comment text.
- **Proposed Fix:** Correct threshold comment to state actual decomposition: "1 lib + 1 bin + ~100 integration + ~1 doc = ~103; tolerance 103−90=13". Derive 100 = total tests/ files minus common/ module files (not cargo targets).
- **Status:** FIXED — fix round 8 (ci.yml comment corrected to "1 lib + 1 bin + ~100 integration + ~1 doc"; derivation stated — 100 = 104 files in `tests/**/*.rs` minus the 4 `tests/common/` module files that are not cargo targets; arithmetic verified 1+1+100+1=103; composition independently re-derived).

---

#### ADV-P21-MED-003: Pin docstring claimed assertions "pin all operative parts including the `set +o pipefail` scoping" — no pipefail assertion existed
- **Severity:** MEDIUM
- **Category:** spec-fidelity / over-claimed-coverage
- **Location:** `tests/ci_gate_completeness.rs::test_verify_test_job_has_zero_test_floor` docstring
- **Description:** The `a247a343` pin docstring stated the test assertions "pin all operative parts" and explicitly named `set +o pipefail` scoping as one of the pinned elements. No such assertion existed in the test. Deleting `set -o pipefail` from the floor script — which would silently resurrect the unreachable-diagnostic defect the test was authored to fix — would not be caught by the named test. A docstring that over-claims its own coverage gives false assurance to maintainers doing later edits.
- **Evidence:** `test_verify_test_job_has_zero_test_floor` assertions in `a247a343`: contains `"FAIL (POL-11)"`, exit code 1, `"Check passed:"`, canary assertion. No assertion for `set +o pipefail` or `set -o pipefail`. Docstring explicitly names pipefail scoping as pinned.
- **Proposed Fix:** Add two assertions: one that the script contains `set +o pipefail` and one that it contains `set -o pipefail` as standalone command lines (trailing-newline match, not a comment or variable name). Correct docstring to name both explicitly.
- **Status:** FIXED — fix round 8 (two assertions ADDED pinning `set +o pipefail` and `set -o pipefail` as standalone command lines — trailing-newline match load-bearing, distinguishing commands from comments; docstring corrected. Non-vacuity PROVEN: breaking `set -o pipefail` → `set -o XBROKENX` made the test FAIL; reverted; confirmed green 8 tests).

---

### LOW

#### ADV-P21-LOW-001: BC-5.3.003's Source field omits `test_board_view_falls_back_to_uuid_when_team_not_cached` — the test added specifically to pin its board render site
- **Severity:** LOW
- **Category:** spec-fidelity / source-miss
- **Location:** `.factory/specs/prd/bc-5-boards-sprints.md` BC-5.3.003 Source field
- **Description:** BC-5.3.003 traces the board-view UUID fallback behavior added by product commit `6d73b3ef`. The Source field lists some integration test coverage but omits `test_board_view_falls_back_to_uuid_when_team_not_cached` — the test added by `6d73b3ef` specifically to pin the board render site documented in this BC. This test was recorded in the story comment and in S-626-1 v1.11, but the BC Source field was not updated in tandem.
- **Evidence:** `tests/team_column_parity.rs::test_board_view_falls_back_to_uuid_when_team_not_cached` exists; BC-5.3.003 Source field does not cite it. Story changelog for v1.11 records the test addition. Fix round 5 updated BC-5.3.002 Source but missed BC-5.3.003.
- **Proposed Fix:** Add `test_board_view_falls_back_to_uuid_when_team_not_cached` to BC-5.3.003 Source field. Sweep BC-5.3.001 and BC-5.3.004 for similar gaps.
- **Status:** FIXED — fix round 8 (bc-5-boards-sprints.md: BC-5.3.003 Source now cites `tests/team_column_parity.rs::test_board_view_falls_back_to_uuid_when_team_not_cached` verified at `:543`; class sweep found ADDITIONAL genuine gap: BC-5.3.002 Source was also missing the list-site + no-team-UUID combination; now citing `tests/cli_handler.rs::test_list_omits_team_column_when_no_issue_has_team`; BC-5.3.001 and BC-5.3.004 checked — no gap).

---

#### ADV-P21-LOW-002: AC-9's heading enumerated two BCs while its own footer traced three
- **Severity:** LOW
- **Category:** spec-fidelity / internal-inconsistency
- **Location:** `.factory/stories/S-626-1.md` AC-9 heading line vs AC-9 footer trace block
- **Description:** AC-9's heading line enumerated two BCs ("BC-5.3.001, BC-5.3.002"). Its own footer's `behavioral_contracts:` trace block listed three: BC-5.3.001, BC-5.3.002, and BC-5.3.003 (added by DEC-210, v1.11). The heading was not updated when v1.11 extended the footer. A reviewer scanning the heading alone would miss BC-5.3.003 coverage.
- **Evidence:** S-626-1.md v1.13 AC-9 heading vs `behavioral_contracts:` trace in the same AC. STORY-INDEX S-626-1 row correctly lists three BCs; heading was the sole surface lagging behind.
- **Proposed Fix:** Update AC-9 heading to enumerate all three BCs: "BC-5.3.001, BC-5.3.002, BC-5.3.003". No other AC has a heading trace, so AC-9 is the only mismatch.
- **Status:** FIXED — fix round 8 (S-626-1 v1.14: AC-9 heading now enumerates all three BCs; verified no other AC has a heading trace, so AC-9 was the only mismatch).

---

#### ADV-P21-LOW-003: Two citations in `S-BC-CITATION-GUARD-1.md` assert "verified against **live** ci.yml line 111" while line 111 now holds unrelated POL-11 text — DEFERRED
- **Severity:** LOW
- **Category:** spec-fidelity / stale-liveness-claim
- **Location:** `.factory/stories/S-BC-CITATION-GUARD-1.md` — two citations approximately at lines 700 and 721
- **Description:** Two citations assert "verified against **live** ci.yml line 111." The word "live" asserts the line number is current. Line 111 of ci.yml now holds unrelated POL-11 text inserted by `9312f11f`. The line numbers are legitimately historical (they point to the state at time of delivery), but "live" asserts the opposite — that they are current. A maintainer following the citation would reach the wrong line. Changing "live" to "as-of-delivery" or "historical" would be accurate.
- **Evidence:** ci.yml line 111 content post-`9312f11f`: unrelated POL-11 script text. S-BC-CITATION-GUARD-1.md citations asserting "live ci.yml line 111." The line number was correct at delivery; "live" asserted incorrectly.
- **Proposed Fix:** Change "verified against **live** ci.yml line 111" → "verified against ci.yml line 111 as-of delivery commit" at both citation sites. Version-bump the file.
- **Status:** DEFERRED — `S-BC-CITATION-GUARD-1.md` is `status: delivered` and carries pre-existing template drift (9 missing frontmatter keys; missing `## Architecture Mapping` and `## Purity Classification`; `## Library and Framework Requirements` under a variant name). A compliance hook blocks every edit. Agent proposed adding `[TODO: populated retroactively]` placeholder sections to unblock; **orchestrator DECLINED** — inserting placeholder sections into a delivered artifact creates false completeness (the exact defect class this cycle has spent eight rounds removing), disproportionate trade for a two-word annotation. Partial edit at line 721 was **REVERTED** to restore file consistency. Both citations remain unannotated. Route F-06 with its blocking dependency. (DEC-217 rationale recorded.)

---

### INFO

#### ADV-P21-INFO-001: `bc-02-issue-read.md` frontmatter `bc_count: 94` vs body prose "92 BCs" — both surfaces stale against CANONICAL-COUNTS.md 106
- **Severity:** INFO
- **Category:** spec-integrity / stale-count
- **Location:** `.factory/specs/domain-spec/bc-02-issue-read.md` frontmatter and body preamble
- **Description:** `bc-02-issue-read.md` carries `bc_count: 94` in frontmatter and "92 BCs" in body prose. Both surfaces are stale. CANONICAL-COUNTS.md carries **106** as the correct total for this domain (SOH-ATTACHMENTS-1 added BC-2.7.001..012). Root cause: SOH-ATTACHMENTS-1 added the 12 attachment BCs to the PRD without updating the domain-spec file. Drift persisted across six adversary passes unflagged.
- **Evidence:** `bc-02-issue-read.md` frontmatter `bc_count: 94`; body preamble "92 BCs"; CANONICAL-COUNTS.md bc-02 row = 106. Delta: 94→106 = +12 (SOH-ATTACHMENTS-1 attachment BCs).
- **Proposed Fix:** Update both frontmatter (`bc_count: 94` → `bc_count: 106`) and body preamble ("92 BCs" → "106 BCs"). Class sweep: check all domain-spec files for the same drift pattern.
- **Status:** FIXED — fix round 8 (bc-02-issue-read.md: both surfaces corrected to 106. CLASS SWEEP COMPLETED: all 10 files under `specs/domain-spec/` enumerated; only ONE further drift found: `bc-03-issue-write.md` `bc_count: 120` → `140` (same root cause); bc-01/04/05/06/07 all already correct; cross-cutting.md/README.md/state-machines.md carry no BC-count claim. bc-02's "Largest BC" superlative DROPPED — relative ranking is perpetual drift debt). DEC-218 directed the class sweep.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 3 |
| LOW | 3 |
| INFO | 1 |

**Overall Assessment:** NOT CLEAN — 0 HIGH + 3 MEDIUM + 3 LOW + 1 INFO; zero code defects in `src/`; **THIRTEENTH consecutive zero-src/-defect pass**. CI floor (`a247a343`) audited SOUND on all four dimensions. No finding challenges the delivered behaviour, the guard's soundness, or the demo pack's fidelity.

**RECURRING PATTERN IDENTIFIED — NAMED PRECISELY BY REVIEWER:** *"a correct change landed alongside a false claim about it."* MED-001 (false test name + false job count in scope-declaration fix), MED-002 (false sum in threshold justification), MED-003 (over-claimed docstring coverage) all fit this exact shape.

**Reviewer judgment (verbatim):** *"NOT converged, but narrowly and non-structurally… no finding challenges the delivered behaviour, the guard's soundness, or the demo pack's fidelity… I would expect a single tight fix round to close all seven, after which this artifact set should converge."*

**Window status:** NOT CLEAN; window 0/1 of 21/22/23 (ELIGIBLE — isolation CLEAN). Passes 22/23 NOT DISPATCHED (superseded when pass-21 returned NOT CLEAN, since running against known-defective state would waste them). Fresh STRICT window = passes 22/23/24 (DEC-219).

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 21 (WINDOW-ELIGIBLE — isolation CLEAN; window 0/1 of 21/22/23; STRICT) |
| **New findings** | 7 (0 HIGH + 3 MEDIUM + 3 LOW + 1 INFO) |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 1.00 (7/7 — all findings novel; no carryover duplicates) |
| **Median severity** | 2.5 (LOW-MEDIUM boundary; sorted: 3,3,3,2,2,2,1 → midpoint index 4 = 2 [LOW]) |
| **Source of MEDIUM findings** | All three from documentation/citation-accuracy defects in round-7's own fix prose (same class as round 5's injection but lighter) |
| **Code defects in src/** | 0 (thirteenth consecutive pass) |
| **Product defects total** | 0 |
| **Trajectory** | P6=10, P7=13, P8=5, P9=15, P10=18, P11=13, P12=10, P13=10, P14=9, P15=15, P18=10, P19=10, P21=7 |
| **Verdict** | FINDINGS_REMAIN — NOT CLEAN; 0 HIGH + 3 MEDIUM + 3 LOW + 1 INFO; zero src/ code defects; CI floor SOUND on all four dimensions; window 0/1 of 21/22/23 (passes 22/23 NOT DISPATCHED) |
| **Reviewer recommendation** | Fix round 8 should close all seven findings. Instruct the agent to verify every number and symbol it writes and to quote what it verified against. The symbol-corpus sweep is particularly load-bearing: an exhaustive sweep of all `::` citations in `.factory/stories/` would bound whether the false-claim-alongside-correct-change pattern has further instances. F-06 requires routing with its template-conformance blocking dependency rather than a placeholder-section workaround. |
