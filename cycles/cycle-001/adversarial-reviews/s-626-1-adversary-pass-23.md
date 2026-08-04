---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-04T18:30:00Z
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
input-hash: "7006bed"
traces_to: .factory/stories/S-626-1.md
story: S-626-1
cycle: cycle-001
pass: 23
agent: adversary
basis: TRUE ADVERSARY AGENT
date: 2026-08-04
feature_head: 14416fd9
pr: 667
verdict: "NOT CLEAN — 1 MEDIUM + 1 LOW; WINDOW-ELIGIBLE; isolation CLEAN"
previous_review: .factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-22.md
isolation: CLEAN
---

# Adversarial Review — S-626-1 (SOH-DX-1), Pass 23

## Provenance

This artifact is a **DIRECT CAPTURE** of adversary reviewer output relayed by the orchestrator, recorded same-session. The reviewer's findings were relayed verbatim immediately after the pass completed. Pass-23 ran against feature HEAD `14416fd9` (fix-round-10 product commit). Both findings (F-01 MEDIUM + F-02 LOW) were closed in this burst: F-01 by product commit `14416fd9` itself (comment converted to structural form), F-02 by the `.factory/` spec update in this same burst (bc-5-boards-sprints.md "all three conditions").

**Policy rubric:** `.factory/policies.yaml` does not exist. Baseline applied (POL-11 positive-coverage, S-7.01 partial-fix discipline, semantic-anchoring severity ladder, six mandated axes).

---

## RECORD PROMINENTLY — ISOLATION CORRECTIVE VERIFIED EFFECTIVE

**Pass-23's dispatch replaced the general prohibition with a concrete PRE-FLIGHT CHECK plus an explicit whitelist of acceptable search roots.** Result: *"No call took `.factory` or `.factory/` as its path argument. No banned content surfaced; nothing to disclose."* The reviewer enumerated every search root it used.

The recurring breach mechanism (root-scoped `.factory/` grep) is closed. Three prior isolation breaches (passes 9, 11, 22) all used this exact mechanism. The behavioral corrective held for 10 consecutive passes (12–21) before the pass-22 recurrence. The PRE-FLIGHT CHECK + explicit whitelist is a more durable corrective: instead of relying on the reviewer to remember not to use `.factory/` as a root, it requires the reviewer to ENUMERATE its search roots before executing any grep. Pass-23 is the first pass under this revised corrective, and it produced isolation CLEAN with every search root explicitly stated.

---

## RECORD PROMINENTLY — CI FLOOR AUDITED SOUND, PIN EXHAUSTIVELY VERIFIED

Pass-23 produced a per-assertion comment-satisfiability table for **ALL EIGHT pin assertions** and found **NONE satisfiable by any comment, docstring, or unrelated line** in the extracted `test` job block — with per-assertion evidence. Selected entries:

- **Instrument 0 (`FAIL (POL-11)`):** Echo-satisfiable. Correctly classified as deliberate sentinel backstopped by Instruments 1 and 2. Not raised as a finding.
- **Instrument 1 (grep-q canary):** Comment `:124` carries the bare substring `ci_gate_completeness` but NOT the command form `grep -q "ci_gate_completeness"` — the assertion requires the command form. Non-satisfiable.
- **Instrument 2 (threshold):** Comment `:60` contains `CARGO_TERM_COLOR: always` (the opposite value). Non-satisfiable.
- **Instrument 3 (pipefail assertion `:79`):** Comment `:79` continues with ` the` so the trailing-`\n` form cannot match. Non-satisfiable.
- **Instruments 4–7:** All command-unique strings with no comment-satisfying counterpart in the block. Non-satisfiable.

The **two false-green vectors closed by `7798b1bf` are genuinely closed and there is no third.** The pass-23 reviewer also independently re-derived the threshold arithmetic from scratch:

- `tests/*.rs` at repo root: exactly 100 top-level test files
- `tests/common/` has no `main.rs`, so none of its 4 files are integration-test targets
- `Cargo.toml` has no `[[test]]` section and no `harness = false` entries
- Total: 1 lib + 1 bin + 100 integration + 1 doc = **103 test binaries**
- Floor: 90; headroom: 13 (103 − 90 = 13)
- `awk`'s `sum+0` and `wc -l` always exit 0; `if` conditions are exempt from `set -e` — every diagnostic is reachable
- Windows leg: platform-invariant (count is OS-independent)

This is the third independent reviewer to derive this arithmetic (joining passes 21 and 22). All three agree.

**Worth recording as a positive datapoint:** The reviewer CORRECTED its re-run justification rather than reusing a prior round's reasoning. It stated explicitly that the rounds 8–9 justification ("tests/ changed, so ci_gate_completeness.rs needed re-running") does NOT apply to the pass-23 target commit `14416fd9`, and gave the accurate justification instead: "`ci_gate_completeness.rs` reads `ci.yml` at test time, so even a comment-only edit to `ci.yml` is a lint input — the test must be re-run." This is the behaviour the "write no justification you have not verified" instruction was added to produce.

---

## Isolation

**CLEAN.** The reviewer enumerated every search root before executing any grep. No call took `.factory` or `.factory/` as its path argument. All searches were scoped to specific subdirectories (`.factory/stories/`, `.factory/demos/S-626-1/`, `.github/workflows/ci.yml`, `tests/`) or specific file paths. No banned content surfaced; nothing to disclose.

This is the first pass under the revised PRE-FLIGHT CHECK corrective (replacing the general prohibition). The corrective worked as intended: by requiring enumeration of search roots, it prevented the root-scoped `.factory/` grep that caused the three prior isolation breaches.

---

## Reviewer's Honest Non-Findings (Captured as Best Practice)

**1. S-626-1.md:57 point-in-time citation stale (`ci_gate_completeness.rs line 787` → line 800):**
The reviewer noted that the `risk_mitigations` section in `S-626-1.md` contains a point-in-time citation of `tests/ci_gate_completeness.rs line 787` which is now line 800 (the docstring grew by 13 lines). The reviewer declined to raise this as a finding because: (a) `risk_mitigations` is out of the defined perimeter; (b) a point-in-time verification record is inherently timestamped — citing the line at time of verification is not a defect. Correct reviewer discipline: non-perimeter artifact, inherently timestamped record.

**2. Pin Instrument 0 echo-satisfiable (deliberate sentinel):**
The reviewer noted that `FAIL (POL-11)` (Instrument 0) is echo-satisfiable — `echo "FAIL (POL-11)"` would satisfy `assert!(block.contains("FAIL (POL-11)"))`. However, it correctly classified this as a deliberate sentinel backstopped by Instruments 1 and 2: Instrument 0 tests that the FAIL diagnostic appears; Instruments 1 and 2 test that the gate logic is present. Even if a test deleted only the FAIL diagnostic while leaving the gate, Instruments 1 and 2 would still catch the absence of the operative commands. The reviewer did not raise this as a finding. Correct classification.

---

## Finding ID Convention

Finding IDs for this pass use the format `ADV-P23-[SEV]-NNN`. Consistent with prior passes in this series.

---

## Part A — Fix Verification

Pass-23 verified all 3 findings from pass-22 (the most recent executed pass, though VOID for window). Fix round 9 applied before this window.

| ID | Previous Finding | Status | Notes |
|----|-----------------|--------|-------|
| ADV-P22-MED-001 | POL-11 pin canary satisfiable by comment; threshold not bound to variable | FIXED — fix round 9 (`7798b1bf`): canary → `grep -q "ci_gate_completeness"` command form; threshold → `"${binaries}" -lt 90` ✓ | Verified via per-assertion table — 8/8 assertions non-comment-satisfiable |
| ADV-P22-LOW-002 | demos/S-626-1/INDEX.md two Round-9 residues (intro head stale; AC-003 command stale) | FIXED — fix round 9 (`7798b1bf`) ✓ | All 11 artifacts re-stamped to `7798b1bf` |
| ADV-P22-LOW-003 | S-626-1 FSR + MUST-NOT + STORY-INDEX authorization trail listed only 2 of 4 commits | FIXED — fix round 9 (`7798b1bf`) ✓ | 4-commit trail at both body sites + STORY-INDEX row |

---

## Part B — New Findings

### MEDIUM

#### ADV-P23-MED-001: Stale self-citation in `ci.yml:~93` comment — cites F2 range (~415-426) as "the mutants job F5 fix" [citation-hygiene]

- **Severity:** MEDIUM
- **Category:** citation-hygiene / stale-anchor · orchestrator-scoping-error
- **Location:** `ci.yml :: mutants / "Check kill rate"` else branch — comment preceding the `binaries=` assignment (approximately line 93 of `7798b1bf`, line 94 of `14416fd9`)
- **Description:** The comment at `ci.yml:~93` cited `ci.yml:~415-426` as "the location of the mutants job F5 fix." However, that range is the **F2** fix (the `jq empty` malformed-JSON guard at `ci.yml :: mutants / "Parse test output"`), not the F5 fix. The actual F5 fix (`grep -c` producing `"0\n0"` on empty match) is located at approximately `ci.yml:~471-484` — off by ~57 lines from the cited range.

  **Root cause:** The anchor-form citation migration (DEC-213) was scoped by the orchestrator to `.factory/stories/` and `.factory/specs/` and was never extended to `ci.yml` itself — the one file whose five commits caused every line shift. So `ci.yml`'s own internal self-citations were left in exactly the form the migration existed to eliminate. When fix rounds shifted ci.yml's line numbers, the self-citation went stale. Also violated CLAUDE.md #408 (`never a bare <file>:NN-MM for new citations`).

  **Impact:** MEDIUM (misleading internal comment; a maintainer reading the comment to locate the F5 fix would be directed to the F2 fix instead).

- **Evidence:** Comment text at `ci.yml:~93` (pre-fix): `# ... see ci.yml:~415-426 for the mutants job F5 fix`. Range `~415-426` is `ci.yml :: mutants / "Parse test output"` (the `jq empty` block, i.e., the F2 malformed-JSON guard). The F5 fix (`grep -c` exiting 1 on empty match) is at approximately `ci.yml:~471-484`.
- **Proposed Fix:** Convert to structural form per CLAUDE.md #408: `ci.yml :: mutants / "Check kill rate" else branch — "grep -c '' exits 1 on empty match"`. This form is drift-immune: it identifies the job, step, and code-unique string rather than a line number. A sweep of all 10 workflow files confirmed zero other line-number citations, so the class is closed at this site.
- **Status:** FIXED — fix round 10 (`14416fd9`: comment converted to `ci.yml :: mutants / "Check kill rate" else branch — "grep -c '' exits 1 on empty match"` structural form; one comment line became two, shifting everything below old line 93 by +1; **DEC-222: anchor-form convention extended to workflow files**). A sweep of ALL TEN workflow files found ZERO other line-number citations — class closed, not merely the site. **POL-11 pin still passes: all 8 assertions verified unaffected by the +1 shift.** Gates: full suite 2345/0/100, `ci_gate_completeness` 8 tests, clippy clean, fmt clean.

---

### LOW

#### ADV-P23-LOW-001: BC-5.3.001 Behavior reads "both conditions required" but enumerates three [spec-accuracy]

- **Severity:** LOW
- **Category:** spec-accuracy / internal-inconsistency
- **Location:** `.factory/specs/prd/bc-5-boards-sprints.md` — BC-5.3.001 `**Behavior**` field
- **Description:** The Behavior field opens with: *"Column gating is conjunctive — **both conditions** required (Table mode AND configured field AND ≥1 populated UUID)."* The parenthetical then enumerates **three** conditions (Table mode, configured field, populated UUID), directly contradicting the "both conditions" claim. The contract was apparently originally written when only two conditions existed (configured field AND populated UUID), and "Table mode" was added as a third conjunct later — but the count-word "both" was not updated. The Postcondition 1 also correctly lists all three conditions without using "both", making the Behavior's "both" the sole error site.

  **Carried-over context:** The class sweep directed by DEC-218 (pass-21 round) covered 7 count-word sites in `specs/`. Six were verified correct and left alone, including notably `edge-case-catalog.md:247` (EC-OUT-001) which uses "both conditions: configured AND populated" — correctly, because Table mode is presupposed in that edge case's boundary. Only this one site was wrong.

- **Evidence:** `bc-5-boards-sprints.md` BC-5.3.001 Behavior field: `"Column gating is conjunctive — both conditions required (Table mode AND configured field AND ≥1 populated UUID)."` Three conditions are enumerated but only "both" (two) is claimed.
- **Proposed Fix:** Change "both conditions" to "all three conditions" in the Behavior field. Verify BC-5.3.002's Behavior/Postcondition are internally consistent (¬A∨¬B∨¬C is correct OR-semantics on the negation of a three-part AND — Table mode is not separately enumerated in BC-5.3.002 because it's a boundary/edge variant, not because there are only two conditions).
- **Status:** FIXED — this burst (`.factory/` spec update: `"both conditions"` → `"all three conditions"` in BC-5.3.001 Behavior field; BC-5.3.002 verified consistent with explicit ¬A∨¬B∨¬C derivation — OR-semantics on negation of three-part AND is correct; EC-OUT-001 in edge-case-catalog.md correctly left alone — Table mode presupposed in that edge case's boundary).

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 1 |
| LOW | 1 |
| INFO | 0 |

**Overall Assessment:** NOT CLEAN — 1 MEDIUM + 1 LOW; WINDOW-ELIGIBLE (isolation CLEAN). Zero code defects in `src/`; **FIFTEENTH consecutive zero-src/-defect pass.** Isolation corrective (PRE-FLIGHT CHECK + explicit whitelist) verified effective: first pass under revised corrective; isolation CLEAN with all search roots enumerated. CI floor pin exhaustively verified 8/8 assertions non-comment-satisfiable.

**ISOLATION CORRECTIVE VERIFIED EFFECTIVE:** The recurring breach mechanism (root-scoped `.factory/` grep; three breaches in passes 9/11/22) is closed. Pass-23 is the first pass under the PRE-FLIGHT CHECK + explicit whitelist corrective, and it produced isolation CLEAN.

**CI FLOOR PIN EXHAUSTIVELY VERIFIED:** 8/8 assertions in the POL-11 pin are non-comment-satisfiable. Both false-green vectors closed by `7798b1bf` are confirmed closed. No third vector found.

**Window status:** NOT CLEAN — window 23/24/25 CLOSED 0/1 (pass-23 NOT CLEAN; passes 24/25 not dispatched). Fresh STRICT window = passes 24/25/26 (DEC-223).

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 23 (WINDOW-ELIGIBLE; isolation CLEAN; NOT CLEAN) |
| **New findings** | 2 (0 HIGH + 1 MEDIUM + 1 LOW) |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 1.00 (2/2 — all findings novel; no carryover duplicates) |
| **Median severity** | 1.5 (MEDIUM+LOW; sorted: 3,2 → midpoint = 2.5 → floor 2 [LOW]) |
| **Source of MEDIUM finding** | Stale anchor in ci.yml self-comment: orchestrator-scoped anchor migration stopped at .factory/ boundary, omitting ci.yml's own citations |
| **Code defects in src/** | 0 (FIFTEENTH consecutive pass) |
| **Product defects total** | 0 |
| **Trajectory** | P6=10, P7=13, P8=5, P9=15, P10=18, P11=13, P12=10, P13=10, P14=9, P15=15, P18=10, P19=10, P21=7, P22=3 [VOID], P23=2 |
| **Verdict** | NOT CLEAN — WINDOW-ELIGIBLE; isolation CLEAN; 1M+1L; both fixed (F-01 by product commit 14416fd9; F-02 by .factory/ spec update); isolation corrective PRE-FLIGHT CHECK verified effective; CI floor 8/8 non-comment-satisfiable |
| **Reviewer recommendation** | F-01: extend anchor-form convention to all workflow self-citations (a 10-workflow sweep at commit time bounds this class). F-02: BC-5.3.001 is the one fixable count-word site; EC-OUT-001 in edge-case-catalog.md is deliberately correct with "both". Fresh window: dispatching passes 24/25/26 against 14416fd9. |
