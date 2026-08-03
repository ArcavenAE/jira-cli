---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-03T06:00:00Z
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
pass: 12
agent: adversary
basis: TRUE ADVERSARY AGENT
date: 2026-08-03
feature_head: c88374b41ee4ea30bc2406e1def90cedf3686275
pr: 667
verdict: "NOT CLEAN — 0 HIGH + 5 MEDIUM + 5 LOW; zero code defects"
previous_review: .factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-11.md
isolation: CLEAN
---

# Adversarial Review — S-626-1 (SOH-DX-1), Pass 12

## Provenance

This artifact is a **DIRECT CAPTURE** of adversary reviewer output relayed by the orchestrator, recorded same-session. The reviewer's findings were relayed verbatim immediately after the pass completed.

**Policy rubric:** `.factory/policies.yaml` does not exist. Baseline applied (POL-11 positive-coverage, S-7.01 partial-fix discipline, semantic-anchoring severity ladder, six mandated axes).

---

## Isolation

**CLEAN.** No banned-path file read. No prior adversary pass artifacts accessed. No `.factory/`-root greps issued — all searches scoped to named in-perimeter subdirectories (`src/`, `tests/`, `.github/workflows/`, `.factory/stories/`, `.factory/specs/`, `.factory/demos/S-626-1/`). Incidental exposure: banned-path filenames (`demos/S-626-1/AC-001.txt` et al., `ci.yml:212-214`) appeared as quoted text INSIDE in-perimeter files; no content read. Self-disclosed.

**Grep-hygiene self-correction:** reviewer detected a broken ampersand-escaped grep pattern (`&&`) on the initial test for let-chain residue, corrected the pattern before trusting the zero result, then cross-validated against `develop`. Zero let-chains confirmed non-vacuously.

---

## Finding ID Convention

Finding IDs for this pass use the format `ADV-P12-[SEV]-NNN`. Consistent with prior passes in this series.

---

## Part A — Fix Verification

| ID | Previous Finding | Status | Notes |
|----|-----------------|--------|-------|
| ADV-P11-HIGH-001 | S-640-1 Task 0 circular gate | RESOLVED | Task 0 scope corrected; S-641-1 prose normalized ✓ |
| ADV-P11-HIGH-002 | S-576-5 SS-03/SS-09 retained as false anchors | RESOLVED | SS-03/SS-09 removed; SS-02/SS-04 retained ✓ |
| ADV-P11-MED-001 | S-640-1 ARCH-INDEX task listed but no entry exists | RESOLVED | SS-11 ARCH-INDEX gap tracked as drift item ✓ |
| ADV-P11-MED-002 | BC-5.3.003 body title not swept after BC-INDEX row update | RESOLVED | bc-5 section heading updated ✓ |
| ADV-P11-MED-003 | BC-INDEX §5.3 prose carries old BC-5.3.003 title | RESOLVED | BC-INDEX prose swept ✓ |
| ADV-P11-MED-004 | INV-READ-009 re-anchor additive; origin site in BC-5.3.002 not cleaned | RESOLVED | BC-5.3.002 Source cleaned ✓ |
| ADV-P11-MED-005 | S-641-1 blocks: missing reverse edge to S-640-1 | RESOLVED | blocks: ["S-640-1"] added ✓ |
| ADV-P11-MED-006 | BC-5.3.001 positive-coverage gap (POL-11) | PARTIAL — new no-suffix test added; outer positive-path open | fix round 4 product commit c88374b4 |
| ADV-P11-MED-007 | ARCH-INDEX SS-09 scope mismatch | TRACKED | drift item ARCH-INDEX-REGISTRY-COVERAGE-GAP ✓ |
| ADV-P11-MED-008 | S-627-1 STORY-INDEX row lacks SS-09 best-fit disclosure | RESOLVED | disclosure note added ✓ |
| ADV-P11-LOW-001 | release.yml MUST-NOT clause at two sites not updated | RESOLVED | blockquote + STORY-INDEX updated ✓ |
| ADV-P11-LOW-002 | full-suite.txt/AC-009.txt pre-date fix-round-3 | RESOLVED — NEW: see Part B below | Regenerated at c88374b4 per fix round 4 |
| ADV-P11-LOW-003 | STORY-INDEX last_updated dates stale | RESOLVED | both rows refreshed ✓ |

---

## Part B — New Findings

### HIGH

*None.*

### MEDIUM

#### ADV-P12-MED-001: BC-5.3.001 Behavior restatement claims "all three call sites use the identical three-level nested-if gate" — FALSE for `sprint.rs::handle_current`
- **Severity:** MEDIUM
- **Category:** spec-fidelity / GAP · fix-introduced
- **Location:** `.factory/specs/prd/bc-5-boards-sprints.md` BC-5.3.001 Behavior section
- **Description:** Fix round 3 retitled and restated BC-5.3.001's Behavior as a conjunctive gate shared across "all three call sites." The body now reads to the effect that all three sites — `board.rs`, `list.rs`, and `sprint.rs::handle_current` — use the same "identical three-level nested-if gate." This claim is VERIFIABLY FALSE for `sprint.rs::handle_current`. The actual control structure in `sprint.rs::handle_current` is: (1) a `match` arm on `output_format` at approximately line 265, plus (2) TWO nested `if` checks at approximately lines 291 and 296 inside the match arm body. There is no `if matches!(output_format, OutputFormat::Table)` wrapper in `sprint.rs`; the Table-mode gate is the match arm itself. The `board.rs` and `list.rs` sites do use a three-level nested `if` structure; `sprint.rs` is structurally distinct.

  Additionally, the fix-round Behavior text named three sites while previously only two files (`board.rs`, `list.rs`) appeared in the Source field. The third file (`sprint.rs`) was asserted in the Behavior without being cited in the Source. A story-coverage check would pass, but the structural claim introduced is materially inaccurate.

  **Consequence:** If S-640-1's `collapsible_if` sweep at MSRV 1.88 attempted a `board.rs`-shaped three-level-if transformation on the `sprint.rs` match-arm site, it would fail at compile time OR silently change semantics — the `match`-arm gate is not a nested `if`, and a naive collapsible-if lint would not fire on it.

- **Evidence:** `src/cli/sprint.rs::handle_current` control flow; `bc-5-boards-sprints.md` BC-5.3.001 Behavior clause; `src/cli/board.rs` ~:228-237 three-level nested if.
- **Proposed Fix:** Restate Behavior to describe each site accurately: `board.rs`/`list.rs` use `if A { if let Some(x) = B { ... } }` three-level form; `sprint.rs::handle_current` uses a `match` arm on output format plus two nested `if` checks inside. Assert the LOGICAL conjunction (all three sites gate on table mode AND configured field) without claiming structural identity.
- **Status:** FIXED in fix round 4 — BC-5.3.001 Behavior RESTATED.

---

#### ADV-P12-MED-002: S-641-1 AC-2 item 8 specifies three mutually incompatible verification patterns in a single acceptance criterion
- **Severity:** MEDIUM
- **Category:** spec-fidelity / GAP · spec artifact
- **Location:** `.factory/stories/S-641-1.md` AC-2 item 8
- **Description:** AC-2 item 8 specifies the exact string match for the MSRV compiler-version assertion. As written, it contains three mutually incompatible forms:
  1. A regex template `'^rustc {version}\.'` where `{version}` is a placeholder.
  2. An inline concrete example `'^rustc 1\.85\.0 '` (space-terminated, not dot-terminated).
  3. A normalization rule stating `^rustc 1\.85` as a two-component shorthand for computing what the expected version looks like.

  These three forms cannot simultaneously be correct. Substituting canonical version `1.85` into the template yields `^rustc 1.85\.` — note the UNESCAPED first dot, which is a regex wildcard. The inline example uses `1\.85\.0 ` (space after patch) not `1\.85\.0\.` (dot after patch). The normalization rule `^rustc 1\.85` is a two-component prefix that does not pin the patch level.

  A test writer implementing AC-2 item 8 would have to choose one of three forms, and two of them would produce either a false-RED (template with unescaped dot) or a false-GREEN (normalization shortcut matching `rustc 1x85y0`) depending on which they pick.

- **Evidence:** `S-641-1.md` AC-2 item 8; `src/cli/sprint.rs` compiled under `RUSTUP_TOOLCHAIN=1.85.0` → `rustc 1.85.0 (4d91de4e4 2025-02-17)`; three pattern forms do not reduce to a single unambiguous match string.
- **Proposed Fix:** Collapse AC-2 item 8 to a SINGLE pattern: `'^rustc 1\.85\.0 '` — verified character-by-character identical to the actual output of `rustc --version` under the 1.85.0 toolchain. Remove the template form and the two-component normalization rule shortcut.
- **Status:** FIXED in fix round 4 — S-641-1 v0.7, AC-2 item 8 collapsed to single form.

---

#### ADV-P12-MED-003: Transcript AC-009 BEFORE — sed range `'228,244p'` displays 10 lines but evidence declares 17
- **Severity:** MEDIUM
- **Category:** evidence-integrity / transcript-fidelity
- **Location:** `.factory/demos/S-626-1/AC-009.txt` BEFORE block
- **Description:** The BEFORE section of `AC-009.txt` uses `sed -n '228,244p'` to extract lines 228 through 244 from `tests/team_column_parity.rs`. Range size = 244 − 228 + 1 = 17 lines. The displayed output shows only 10 lines. The 7-line shortfall corresponds to lines 238-244, which contain the test function body continuation that was truncated. The declared and displayed counts disagree: if a verifier runs `sed -n '228,244p' tests/team_column_parity.rs` they will see 17 lines and immediately identify a discrepancy with the 10-line transcript.

  This is a load-bearing accuracy defect: AC-009's BEFORE evidence is the only machine-reproducible transcript for the pre-fix test state. A shortfall of 7 lines could hide a test assertion, a function boundary, or a doc comment that materially affects the fix-round assessment.

- **Evidence:** Range `'228,244p'` = 17 lines by arithmetic; AC-009.txt BEFORE block = 10 lines; gap = 7 (lines 238-244 absent).
- **Proposed Fix:** Re-run `sed -n '228,244p' tests/team_column_parity.rs` at HEAD c88374b4 and replace BEFORE block with the full 17-line output. Verify B − A + 1 = displayed line count for ALL sed blocks in all 11 demo artifacts.
- **Status:** FIXED in fix round 4 — full 17-line block restored to AC-009.txt BEFORE.

---

#### ADV-P12-MED-004: Transcript AC-009 AFTER — sed range `'228,248p'` declared 21 lines but displays 22 (one line past boundary)
- **Severity:** MEDIUM
- **Category:** evidence-integrity / transcript-fidelity
- **Location:** `.factory/demos/S-626-1/AC-009.txt` AFTER block
- **Description:** The AFTER section of `AC-009.txt` uses `sed -n '228,248p'` to extract lines 228–248. Range size = 248 − 228 + 1 = 21 lines. The displayed output shows 22 lines — one line past the declared range boundary. The extra line (`:249`) is not part of the mandated range and its presence would cause `B − A + 1 ≠ displayed_count`. A verifier byte-comparing the transcript against a fresh `sed` invocation would see a mismatch and correctly reject the evidence as unverifiable.

  The AFTER block also includes output from an adjacent test boundary. This means the transcript captures source state beyond what the range intends, potentially misleading reviewers about which lines constitute the post-fix test.

- **Evidence:** Range `'228,248p'` = 21 lines; AC-009.txt AFTER block = 22 lines; line `:249` present when it should not be.
- **Proposed Fix:** Remove line `:249` from the AFTER block so it contains exactly 21 lines matching the `sed -n '228,248p'` boundary.
- **Status:** FIXED in fix round 4 — extra line `:249` removed from AC-009.txt AFTER.

---

#### ADV-P12-MED-005: S-576-5 File Structure Requirements table has no row for `src/api/jira/issues.rs` — declared SS-04 scope is unsupported
- **Severity:** MEDIUM
- **Category:** spec-fidelity / GAP · spec artifact
- **Location:** `.factory/stories/S-576-5.md` File Structure Requirements table
- **Description:** S-576-5's `subsystems:` field (corrected in fix round 3) now includes `SS-04` (`api/jira/issues.rs`, `api/jira/sprints.rs`, `api/jira/projects.rs`). The SS-04 anchor was added specifically because `src/api/jira/issues.rs` houses `get_issue_project_key`, which is an S-576-5 deliverable per SS-04's scope. However, the File Structure Requirements table in S-576-5.md does not contain a row for `src/api/jira/issues.rs`. The declared subsystem scope and the table-level file list are inconsistent: the story claims SS-04 scope but does not list the SS-04 file that triggered the inclusion.

  A story is only as verifiable as its stated file list. Without the `src/api/jira/issues.rs | MODIFY` row, there is no traceability from the story to the `get_issue_project_key` implementation, and a completeness check scanning `files_modified` would miss this deliverable entirely.

- **Evidence:** `S-576-5.md:31-32` subsystems includes "SS-04"; `S-576-5.md` File Structure Requirements table; `src/api/jira/issues.rs:444` `get_issue_project_key` function.
- **Proposed Fix:** Add `src/api/jira/issues.rs | MODIFY | get_issue_project_key — P1-004 issue existence validation` row to S-576-5's File Structure Requirements table.
- **Status:** FIXED in fix round 4 — `src/api/jira/issues.rs | MODIFY` row added.

---

### LOW

#### ADV-P12-LOW-001: Transcript AC-005 — `sed '57,68p'` sed block drops blank separator lines (12 declared, 11 displayed)
- **Severity:** LOW
- **Category:** evidence-integrity / transcript-fidelity
- **Location:** `.factory/demos/S-626-1/AC-005.txt` first sed block
- **Description:** The first sed command in AC-005.txt uses range `'57,68p'`, which covers 68 − 57 + 1 = 12 lines. The displayed output contains only 11 lines — one blank separator line was silently dropped during transcript capture. The dropped blank line sits between two logical sections in the source (between the end of one CI job step and the start of the next). While the content is recoverable, a verifier byte-comparing the transcript against a fresh `sed` run would detect a one-line discrepancy and correctly question the transcript's integrity.
- **Evidence:** Range `'57,68p'` = 12 lines; AC-005.txt first block = 11 lines; one blank separator absent.
- **Proposed Fix:** Re-run `sed -n '57,68p'` at HEAD c88374b4 and verify the 12-line block including the blank separator appears verbatim. Apply B − A + 1 check to all sed blocks before finalizing.
- **Status:** FIXED in fix round 4 — blank separator restored.

---

#### ADV-P12-LOW-002: Transcript AC-005 — `sed '72,83p'` sed block drops blank separator lines (12 declared, 11 displayed)
- **Severity:** LOW
- **Category:** evidence-integrity / transcript-fidelity
- **Location:** `.factory/demos/S-626-1/AC-005.txt` second sed block
- **Description:** Same class as LOW-001. The second sed block uses range `'72,83p'` covering 83 − 72 + 1 = 12 lines. The displayed output contains 11 lines; one blank separator line was dropped. These two instances in the same file confirm the omission is systematic rather than a one-off.
- **Evidence:** Range `'72,83p'` = 12 lines; AC-005.txt second block = 11 lines.
- **Proposed Fix:** Re-run `sed -n '72,83p'` at HEAD c88374b4 and verify 12-line block. Apply same check to all ranges in the file.
- **Status:** FIXED in fix round 4 — blank separator restored.

---

#### ADV-P12-LOW-003: Transcript AC-008 — Unicode `≥` (U+2265) transcribed as ASCII `>=`; sibling AC-003 preserves correct character
- **Severity:** LOW
- **Category:** evidence-integrity / transcript-fidelity
- **Location:** `.factory/demos/S-626-1/AC-008.txt`
- **Description:** AC-008.txt transcribes the MSRV floor assertion from `CLAUDE.md` as `>= 1.85` using ASCII `>=`. The actual character in `CLAUDE.md` is `≥` (U+2265 GREATER-THAN OR EQUAL TO). The sibling artifact AC-003.txt, which covers the same CLAUDE.md gotcha section, correctly preserves `≥`. The inconsistency means a byte-diff of AC-008.txt against the source file would produce a false mismatch at the `≥` character, making the transcript non-byte-identical even when the semantic content is correct.
- **Evidence:** `AC-008.txt` contains `>= 1.85`; `AC-003.txt` contains `≥ 1.85`; `CLAUDE.md` source contains `≥`.
- **Proposed Fix:** Replace `>=` with `≥` (U+2265) in AC-008.txt at all affected locations.
- **Status:** FIXED in fix round 4 — `>=` → `≥` corrected.

---

#### ADV-P12-LOW-004: `full-suite.txt` header attributional note reads "Task 7d"; correct attribution is "story v1.3 scope note"
- **Severity:** LOW
- **Category:** evidence-integrity / transcript-fidelity
- **Location:** `.factory/demos/S-626-1/full-suite.txt` line ~3 (header section)
- **Description:** The `full-suite.txt` header attribution reads something to the effect of "count target established in Task 7d." The test-count target of 2343 was established in the S-626-1 story body as a scope note (introduced at v1.3), not in "Task 7d." Task 7d was a discrete delivery step, not the normative source of the test-count assertion. A reader tracing the attribution to "Task 7d" would look in the wrong place for provenance of the 2343 target.
- **Evidence:** `full-suite.txt` header text; `S-626-1.md` v1.3 scope note establishing test count.
- **Proposed Fix:** Replace "Task 7d" with "story v1.3 scope note" in the attribution.
- **Status:** FIXED in fix round 4 — attribution corrected.

---

#### ADV-P12-LOW-005: `INDEX.md` AC-5 evidence summary states "both files" for release.yml; AC-5 mandated three files
- **Severity:** LOW
- **Category:** evidence-integrity / transcript-fidelity
- **Location:** `.factory/demos/S-626-1/INDEX.md` AC-5 evidence row
- **Description:** The `INDEX.md` AC-5 evidence summary reads to the effect of "evidence for both files: ci.yml and sign-and-publish.yml." AC-5 of S-626-1 mandates verification of THREE files: `ci.yml`, `sign-and-publish.yml`, AND `release.yml`. The "both files" phrasing omits `release.yml`, suggesting the evidence covers only two of the three required sites. A completeness check using the INDEX.md summary (without reading AC-005.txt) would incorrectly conclude that only 2/3 mandated sites were covered.
- **Evidence:** `INDEX.md` AC-5 row; `S-626-1.md` AC-5 mandated files list (ci.yml, sign-and-publish.yml, release.yml).
- **Proposed Fix:** Update "both files" to "all three files" and enumerate: `ci.yml`, `sign-and-publish.yml`, `release.yml`.
- **Status:** FIXED in fix round 4 — "both files" → "all three files" corrected.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 5 |
| LOW | 5 |
| INFO | 0 |

**Overall Assessment:** NOT CLEAN — 0 HIGH + 5 MEDIUM + 5 LOW; zero code defects. Policy rubric ABSENT (`.factory/policies.yaml` does not exist) — baseline applied.

**Window status:** ELIGIBLE (isolation CLEAN). NOT CLEAN. Window count: 1 of 3 required NOT CLEAN.

**Severity pattern:** Window 9/10/11 carried 4 HIGH each; this window (pass 12) carries ZERO HIGH. Code remains 0-defect across nine consecutive independent passes (6-14). Severity decay confirmed. All findings are spec-artifact quality issues, not implementation gaps.

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 12 (WINDOW-ELIGIBLE — isolation CLEAN) |
| **New findings** | 5 independent derivations (MED-001 BC-5.3.001 structural claim; MED-002 AC-2 item 8; MED-003/004 AC-009 transcript ranges; MED-005 SS-04 file gap) |
| **Duplicate/variant findings** | 5 (LOW-001/002 AC-005 separators; LOW-003 AC-008 Unicode; LOW-004 full-suite attribution; LOW-005 INDEX "both files") |
| **Novelty score** | 5 / (5 + 5) = 0.50 |
| **Median severity** | MEDIUM |
| **Code defects** | 0 |
| **Trajectory** | 10→13→5→15→18→13→10 (findings per pass: P6=10, P7=13, P8=5, P9=15, P10=18, P11=13, P12=10) |
| **Verdict** | FINDINGS_REMAIN — NOT CLEAN; 0 HIGH + 5 MEDIUM + 5 LOW; zero code defects; ZERO HIGH (severity decay from window 9/10/11) |
