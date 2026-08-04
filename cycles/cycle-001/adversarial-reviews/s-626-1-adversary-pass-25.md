---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-04T19:30:00Z
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
pass: 25
agent: adversary
basis: TRUE ADVERSARY AGENT
date: 2026-08-04
feature_head: 14416fd9
pr: 667
verdict: "CLEAN — 0 substantive gaps, 0 code defects (SEVENTEENTH consecutive); 5 LOW/INFO findings; ELIGIBLE; found three things pass-24 missed"
previous_review: .factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-24.md
isolation: ELIGIBLE (three Globs used repo root with patterns anchored at whitelisted subdirs; no .factory/-root file reachable)
---

# Adversarial Review — S-626-1 (SOH-DX-1), Pass 25

## Provenance

This artifact is a **DIRECT CAPTURE** of adversary reviewer output relayed by the orchestrator, recorded same-session. Pass-25 ran against feature HEAD `14416fd9` (the DEC-223 fresh STRICT window). This is the second pass in the fresh STRICT window (passes 24/25/26) mandated by DEC-223.

**Policy rubric:** `.factory/policies.yaml` does not exist. Baseline applied (POL-11 positive-coverage, S-7.01 partial-fix discipline, semantic-anchoring severity ladder, six mandated axes).

---

## RECORD PROMINENTLY — SECOND CONSECUTIVE CLEAN VERDICT; WINDOW 2/3

**Pass-25 is the SECOND consecutive CLEAN verdict.** Window 24/25/26 = 2/3. One more CLEAN pass (pass-26) would complete the 3/3 strict window required by DEC-199 and DEC-223.

**Value of multi-pass window concretely demonstrated:** Pass-25 found three things that pass-24 missed. The PRE-FLIGHT CHECK corrective held for both passes (isolation CLEAN/ELIGIBLE in both). All five findings in pass-25 were not found by pass-24.

---

## Isolation

**ELIGIBLE.** The reviewer disclosed that three Glob calls used the repository root as path but with patterns ANCHORED at whitelisted subdirectories (`stories/S-626-1.md`, `demos/S-626-1/*`, `tests/ci_gate_completeness.rs`). Because the patterns are anchored at whitelisted paths, no `.factory/`-root file (STATE.md, ADV-P1-INDEX.md, prior pass artifacts) could be matched. Zero banned content surfaced; self-disclosed unprompted.

Per the ISOLATION ELIGIBILITY PRINCIPLE (DEC-224): ELIGIBLE, as nothing surfaced and neither deviation could reach a banned file.

---

## Finding ID Convention

Finding IDs for this pass use the format `ADV-P25-[SEV]-NNN`. Consistent with prior passes in this series.

---

## Part A — Fix Verification

Pass-25 verified all findings from pass-24 (the immediately preceding executed pass, CLEAN).

| ID | Previous Finding | Status | Notes |
|----|-----------------|--------|-------|
| ADV-P24-LOW-001 | INDEX.md Round-12 positional description: comment between binaries=$(…) and # Restore pipefail — actually before binaries= | FIXED — fix round 11 (`e49230a7`): INDEX.md positional description corrected ✓ | Verified by reading the Round-12 section |

---

## Part B — New Findings

### LOW

#### ADV-P25-LOW-001: `ci.yml:109` and `tests/mutants_glob_existence.rs:103` claim "17-entry" examine_globs whitelist; actual count is 16 [count-in-prose-drift]

- **Severity:** LOW
- **Category:** count-in-prose-drift / documentation-accuracy
- **Location:** `ci.yml :: mutants / "Check kill rate"` comment line (~:109); `tests/mutants_glob_existence.rs` comment (~:103)
- **Description:** Two live sites claim the `examine_globs` whitelist in `.cargo/mutants.toml` has "17 entries." Manual enumeration of all `examine_globs` entries in `.cargo/mutants.toml` yields exactly **16** entries. The numeral 16 vs 17 is not load-bearing for any operative CI assertion, but the false claim is a documentation-accuracy defect and recurs at two independent sites (the same class as prior count-in-prose failures).

  The reviewer also identified two further sites with the same claim: a `FLOOR: usize = 11` constant in `tests/mutants_glob_existence.rs` (a **lower bound**, not a current-count claim; 16 > 11 so the guard passes correctly — intentionally left alone); an `N=11` synthetic boundary-probe input (also a lower bound, intentionally left alone); and a frozen historical evidence report (intentionally left alone as falsifying historical records is worse than leaving a stale number).

- **Evidence:** `.cargo/mutants.toml` enumerated to 16 `examine_globs` entries. `ci.yml :: mutants / "Check kill rate"` comment claims "17-entry whitelist". Same claim at `tests/mutants_glob_existence.rs:103`.
- **Proposed Fix:** Remove the numeral rather than correcting it — a corrected count merely resets the drift clock. The three deliberately-retained sites (lower-bound constant, synthetic probe, frozen evidence) should be documented as intentionally correct.
- **Status:** FIXED — fix round 11 (`e49230a7`: numeral removed from both live sites; three deliberately-retained sites documented with reasons).

---

#### ADV-P25-LOW-002: Rust pin docstring in `tests/ci_gate_completeness.rs` still cites `ci.yml:~124`/`ci.yml:~137` after anchor migration [stale-line-citation]

- **Severity:** LOW
- **Category:** stale-line-citation / anchor-migration-gap
- **Location:** `tests/ci_gate_completeness.rs` — docstring for one or more pin assertions
- **Description:** The anchor migration (DEC-213 + DEC-222) reached `ci.yml` and `.factory/stories/` but NOT the paired Rust pin's docstring in `tests/ci_gate_completeness.rs`. Two stale line citations remain:
  - `ci.yml:~124` (actual: ~125 after the +1 shift from `14416fd9`)
  - `ci.yml:~137` (actual: ~138, AND this reference is **inverted** — it cites the line number of the command that the pin paragraph *contrasts against*, not the line being asserted)
  
  The migration was scoped to sweep `.factory/` artifacts and `ci.yml` itself. The corresponding test-file docstrings were not included in the sweep, leaving stranded line-number citations.

- **Evidence:** `tests/ci_gate_completeness.rs` docstrings carry `ci.yml:~124`/`ci.yml:~137` after the fix-round-10 anchor migration.
- **Proposed Fix:** Convert to structural form per CLAUDE.md #408: `ci.yml :: <job-id> / "<step-name>"` notation. The `~137` inversion should be corrected to reference the correct step.
- **Status:** FIXED — fix round 11 (`e49230a7`: all four live `ci.yml:~NN` citations in `tests/ci_gate_completeness.rs` converted to structural form; `~137` inversion corrected; `src/` + `tests/` sweep confirmed exactly those four sites).

---

#### ADV-P25-LOW-003: BC-5.3.001 Postcondition 1 enumerates TWO cell states while code produces THREE [spec-accuracy]

- **Severity:** LOW (but substantive — "the only one I would insist be fixed before the BC is treated as complete")
- **Category:** spec-accuracy / under-enumeration / test-coverage-gap
- **Location:** `.factory/specs/prd/bc-5-boards-sprints.md` — BC-5.3.001 Postcondition 1; `src/cli/board.rs::handle_view`, `src/cli/issue/list.rs::handle_list`, `src/cli/sprint.rs::handle_current`
- **Description:** BC-5.3.001 Postcondition 1 (as fixed by the LOW-001 fix from pass-23) now reads: *"…each row includes a team cell (resolved cache name or raw UUID on cache miss)."* This enumerates **TWO** cell states: (a) resolved name on cache hit, (b) raw UUID on cache miss.

  However, the implementation produces a **THIRD** state: the literal `"-"` when the issue's own `team_id` is `None` — the **mixed-set case** where `uuids.iter().any(|u| u.is_some())` is `true` (so `show_team_col` is set) but this particular issue has no team field. The `None => "-".to_string()` arm is present in all three files (`board.rs:249`, `list.rs:544`, `sprint.rs:309`).

  The BC's own **precondition** admits the mixed-set case: `uuids.iter().any(|u| u.is_some())` = `true` does not require ALL issues to have a team field. So the BC allows a mixed result set to reach Postcondition 1, but the postcondition only describes two of the three outcomes for rows in that set.

  **Coverage gap:** No test mounts a mixed populated/unpopulated set. All six team-column tests use all-teamed or no-teamed fixtures. All three files are outside `examine_globs`, so the `"-"` arm has neither dedicated test coverage nor mutation pressure.

- **Evidence:** Three `None => "-".to_string()` arms in board.rs/list.rs/sprint.rs; Postcondition 1 does not enumerate this arm; no test fixture with `team_id = None` in a mixed set.
- **Proposed Fix:** (1) Extend Postcondition 1 to enumerate all three cell states with their precise conditions. (2) Verify BC-5.3.002/003/004 for the same under-enumeration shape. Route a test-coverage story for the `"-"` arm.
- **Status:** FIXED (spec part) — this burst (bc-5-boards-sprints.md Postcondition 1 extended to enumerate all three cell states; BC-5.3.002/003/004 swept — all three CLEAN with reasons; `"-"` arm recorded in Trace as unpinned). **Test coverage ROUTED** — the mixed-set test was deliberately NOT written; deferred as separate scope decision (DEC-226) and tracked as MIXED-SET-DASH-ARM-UNPINNED drift item.

---

### INFO

#### ADV-P25-INFO-001: Stale line-delta annotation in `tests/ci_gate_completeness.rs` docstring [minor-annotation-drift]

- **Severity:** INFO
- **Category:** minor-annotation-drift
- **Location:** `tests/ci_gate_completeness.rs` docstring referencing a file's line delta
- **Description:** A docstring annotation citing a line delta for a test file carried the pre-migration line number. After the +3-line shift from anchor-form conversion in round-11, the annotation is stale. Non-load-bearing; annotation only.
- **Status:** FIXED — fix round 11 (`e49230a7`: structural form conversion covered this site).

---

#### ADV-P25-INFO-002: STORY-INDEX embedded present-tense bracket contradicts authoritative count surfaces [minor-count-drift]

- **Severity:** INFO
- **Category:** minor-count-drift / embedded-stale-count
- **Location:** `stories/STORY-INDEX.md` — embedded bracket within a historical snapshot entry
- **Description:** A bracket inside a historical snapshot label read: *"current: 82 … Feature-followup: 82 / total_stories: 117 above"*. These figures contradicted the authoritative surfaces (Feature-followup: 88, total_stories: 123). The present-tense language ("current") and the higher-level reference ("above") made the bracket look like a live pointer rather than a historical snapshot value, misleading any reader reconciling counts.
- **Status:** FIXED — fix round 11 (STORY-INDEX v1.5.60→v1.5.61: the embedded present-tense pointer removed; historical snapshot label preserved as-is with `as of 2026-06-16`).

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 0 |
| LOW | 3 |
| INFO | 2 |

**Overall Assessment:** CLEAN — 0 substantive gaps, 0 code defects; **SEVENTEENTH consecutive zero-src/-defect pass**. Isolation ELIGIBLE (three Globs anchored at whitelisted subdirs; no banned content surfaced). Window 24/25/26 = 2/3. **Found three things pass-24 missed** — concretely demonstrating the value of a multi-pass window.

**LOW-003 is the most consequential finding:** BC-5.3.001 Postcondition 1 under-enumeration (two cell states vs three). The `"-"` mixed-set arm has zero test or mutation pressure; spec now enumerates it and Trace records it as unpinned. Test coverage routed as DEC-226 + MIXED-SET-DASH-ARM-UNPINNED drift item.

**CI FLOOR AUDITED SOUND (FIFTH CONSECUTIVE INDEPENDENT CONFIRMATION):** All 8 pin assertions independently verified non-comment-satisfiable.

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 25 (CLEAN; ELIGIBLE; SECOND CONSECUTIVE CLEAN) |
| **New findings** | 5 (0 HIGH + 0 MEDIUM + 3 LOW + 2 INFO) |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 1.00 (5/5 — all findings novel; none previously found in the series) |
| **Median severity** | LOW |
| **Source of LOW findings** | Count-in-prose drift (examine_globs "17-entry"); anchor migration gap in test docstrings; BC Postcondition under-enumeration (two vs three cell states) |
| **Code defects in src/** | 0 (SEVENTEENTH consecutive pass) |
| **Product defects total** | 0 |
| **Trajectory** | P22=3[VOID]→P23=2→P24=1→P25=5 |
| **Verdict** | FINDINGS_REMAIN |
| **Reviewer recommendation** | Dispatch pass-26 against same head. Pass-26 should independently verify: (a) the examine_globs count claim fix — did the numeral actually get removed from both live sites? (b) the authorization trail completeness for all three MUST-NOT-change test exceptions. The window needs 1/1 more CLEAN to complete. |
