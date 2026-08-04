---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-04T00:30:00Z
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
input-hash: "6f405be"
traces_to: .factory/stories/S-626-1.md
story: S-626-1
cycle: cycle-001
pass: 19
agent: adversary
basis: TRUE ADVERSARY AGENT
date: 2026-08-03
feature_head: a247a343
pr: 667
verdict: "NOT CLEAN — 2 HIGH + 6 MEDIUM + 1 LOW + 1 INFO; zero code defects in src/; four CI-as-code defects in orchestrator-shipped POL-11 guard"
previous_review: .factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-18.md
isolation: CLEAN
---

# Adversarial Review — S-626-1 (SOH-DX-1), Pass 19

## Provenance

This artifact is a **DIRECT CAPTURE** of adversary reviewer output relayed by the orchestrator, recorded same-session. The reviewer's findings were relayed verbatim immediately after the pass completed. Pass-19 is the second pass of the 18/19/20 window authorized by DEC-212. Product head at time of review: `9312f11f` (defects) and `a247a343` (fixes applied in fix round 7).

**Policy rubric:** `.factory/policies.yaml` does not exist. Baseline applied (POL-11 positive-coverage, S-7.01 partial-fix discipline, semantic-anchoring severity ladder, six mandated axes).

**RECORD PROMINENTLY:** Pass-19 found **FOUR REAL CODE DEFECTS** in a required `ci-gate` dependency — the POL-11 zero-test floor the orchestrator had authorized and shipped as `9312f11f` one round earlier. `src/` remains 0-defect (twelfth consecutive pass). All four defects closed by product commit `a247a343`.

---

## Isolation

**CLEAN.** No banned-path file read. No prior adversary pass artifacts accessed. Incidental exposure: banned-path filenames appeared as quoted text INSIDE in-perimeter files; no content read. Self-disclosed.

---

## Finding ID Convention

Finding IDs for this pass use the format `ADV-P19-[SEV]-NNN`. Consistent with prior passes in this series.

---

## Part A — Fix Verification

Pass-19 verified all 10 findings from pass-18 (the most recent executed pass; passes 16/17 were NOT RUN). Fix rounds 6 and 7 applied between passes.

| ID | Previous Finding | Status | Notes |
|----|-----------------|--------|-------|
| ADV-P18-MED-001 | S-MAINT-576-HYG-1 AC-4 still mandates total_stories re-increment; Task 4 re-scoped to VERIFY | OPEN — not addressed in fix round 7 | Normative surface conflict persists |
| ADV-P18-MED-002 | BC-5.3.003 Source field omits board-view test; AC-9 heading trace omits BC-5.3.003 | OPEN — not addressed in fix round 7 | Sweep-to-class miss persists |
| ADV-P18-MED-003 | STORY-INDEX S-626-1 row left at v1.10; no BC-5.3.003 anchor recorded | FIXED — fix round 6 (STORY-INDEX v1.5.56; S-626-1 v1.12 backfilled; BC-5.3.003 anchor) ✓ | Confirmed fixed; v1.13 continues correct |
| ADV-P18-MED-004 | Round-5 edits to S-641-1 not version-bumped; two disjoint change-sets at v0.7 | FIXED — fix round 7 (S-641-1 v0.7→v0.8; see ADV-P19-MED-005 which caught this) ✓ | Also triggered ADV-P19-MED-005 (STORY-INDEX row stale by TWO revisions) |
| ADV-P18-MED-005 | Demo clippy/fmt justification "test-only delta, no src/ changes" — false | FIXED — fix round 6 (demos/ re-stamped at 9312f11f; false justification deleted) ✓ | Confirmed fixed; demos/ re-stamped again at a247a343 in fix round 7 |
| ADV-P18-MED-006 | S-641-1 files_modified omits Cargo.toml; AC-3+ArchMap+FSR all reference it | OPEN — not addressed in fix round 7 (survived five rounds) | Persistent: passed through rounds 3/4/5/6/7 |
| ADV-P18-MED-007 | ci.yml test job exits 0 when zero tests discovered — no floor asserted (FIXED IN-CYCLE) | CONFIRMED FIXED — 9312f11f ✓ | Floor added; a247a343 further hardened (ADV-P19-HIGH-001 through MED-003) |
| ADV-P18-LOW-001 | BC-5.3.003 scope row in S-626-1 claims AC-9 "rewrote" — byte-identical except rustfmt re-indentation | OPEN — not addressed in fix round 7 | Prose defect persists |
| ADV-P18-LOW-002 | S-641-1 AC-2 README-badge carve-out unanchored on right — admits MSRV-1.85.3 | OPEN — not addressed in fix round 7 | Prose defect persists |
| ADV-P18-LOW-003 | INDEX.md Per-AC row for AC-9 states "2 new tests" — three other sites say three | OPEN — not addressed in fix round 7 | Transcript fidelity gap persists |

---

## Part B — New Findings

### HIGH

#### ADV-P19-HIGH-001: POL-11 floor `> 0` is INERT — inline `src/` tests keep total above 0 even when all `tests/` binaries are orphaned [process-gap]
- **Severity:** HIGH
- **Category:** CI-integrity / PROCESS-GAP · product-defect · [process-gap]
- **Location:** `.github/workflows/ci.yml` `test` job (POL-11 floor script); `tests/ci_gate_completeness.rs`
- **Description:** The `9312f11f` POL-11 floor asserts `> 0` total tests discovered. Inline `src/` unit tests (approximately 1,112 tests across ~54 `src/` files) are compiled and run by `cargo test --all-features` regardless of whether any `tests/` integration-test binary is registered. A `Cargo.toml` change (`autotests = false`, `[[test]]` rename, harness misconfiguration) would orphan every `tests/*.rs` binary — the ci-gate guard pinned in `tests/ci_gate_completeness.rs` — while `cargo test` still reports ~1,112 tests from inline `#[cfg(test)]` modules. The floor would not fire. The guard cannot detect its own orphaning: the pin lives in `tests/`, which is precisely the binary class the floor fails to protect. Both legs of the rationale in `tests/ci_gate_completeness.rs::test_verify_test_job_has_zero_test_floor` are false: the "cannot orphan unit tests" premise ignores `--lib-only` paths; the `> 0` bound is satisfied by inline units alone. **ORCHESTRATOR CAUSED:** the orchestrator authorized and shipped `9312f11f` with this defect one round earlier (DEC-211).
- **Evidence:** `cargo test --all-features -- __NO_SUCH_TEST__` → 0 tests across 103 binaries (pass-18 empirical proof). `cargo test --all-features --lib` → ~1,112 tests from inline modules. Floor `> 0` satisfied by inline modules alone. `tests/ci_gate_completeness.rs` pin lives in the class the floor cannot protect.
- **Proposed Fix:** Two-instrument floor: (1) binary-count floor — assert `cargo test --all-features -- --list` output contains ≥ 90 test binaries (catches mass orphaning of `tests/` without inline-test interference); (2) named canary — assert `ci_gate_completeness` appears in `--list` output (named guard; orphaning that specific binary would signal CI-completeness regression). Both instruments independently detectable via negative proofs.
- **Status:** FIXED — fix round 7 (product commit `a247a343`: binary-count floor `-lt 90` + named canary `ci_gate_completeness`; `CARGO_TERM_COLOR: never`; all diagnostics now reachable; three proofs executed).

---

#### ADV-P19-HIGH-002: `tests/ci_gate_completeness.rs` and `tests/cli_handler.rs` appear in PR diff but absent from `files_modified`, `test_files`, File Structure Requirements, and STORY-INDEX row enumeration — ORCHESTRATOR-CAUSED SCOPE BREACH
- **Severity:** HIGH
- **Category:** spec-fidelity / scope-breach · orchestrator-authored
- **Location:** `.factory/stories/S-626-1.md` `files_modified`, `test_files`, File Structure Requirements, STORY-INDEX row; the diff for PR #667
- **Description:** S-626-1's `MUST NOT change: tests/` fence was amended in v1.5 to explicitly authorize `tests/team_column_parity.rs` only. The PR diff includes `tests/ci_gate_completeness.rs` (added by `9312f11f` — the POL-11 guard test) and `tests/cli_handler.rs` (added by an earlier commit `c88374b4`). Neither file appears in: (1) `files_modified` frontmatter, (2) `test_files` frontmatter, (3) File Structure Requirements table, (4) STORY-INDEX S-626-1 row enumeration. S-626-1's own `MUST NOT change` clause forbade them. The orchestrator shipped both without declaring them, creating a silent scope breach that adversary isolation cannot detect. This is not a test-coverage addition — these are CI-as-code and test-structure deliverables that must be declared in the story's scope surfaces.
- **Evidence:** `git diff develop...HEAD -- tests/ci_gate_completeness.rs tests/cli_handler.rs` (both present in diff); S-626-1.md `files_modified` (neither listed); S-626-1.md MUST NOT change list (no exception for either file); STORY-INDEX S-626-1 row (neither enumerated).
- **Proposed Fix:** Update all four surfaces of S-626-1: add `tests/ci_gate_completeness.rs` and `tests/cli_handler.rs` to `files_modified`, `test_files`, File Structure Requirements (new rows), and STORY-INDEX S-626-1 row; add exception entries to MUST NOT change list with justifications (`tests/ci_gate_completeness.rs` — authorized by `9312f11f`+`a247a343` POL-11 guard; `tests/cli_handler.rs` — authorized by `c88374b4`).
- **Status:** FIXED — fix round 7 (S-626-1 v1.13: all four surfaces updated; exception list entries added with justifications; DEC-214).

---

### MEDIUM

#### ADV-P19-MED-001: `FAIL (POL-11)` diagnostic was UNREACHABLE under `set -o pipefail` + `set -e`
- **Severity:** MEDIUM
- **Category:** CI-integrity / product-defect
- **Location:** `.github/workflows/ci.yml` `test` job POL-11 floor script (`9312f11f` form)
- **Description:** The `9312f11f` floor script includes `binaries=$(grep -c 'test result:' cargo_test_output.txt || echo 0)`. Under the workflow's implicit `set -o pipefail` and `set -e`, a failing `grep -c` (no match → exit 1) causes the entire assignment to abort before `|| echo 0` can execute; the script exits immediately without reaching the `FAIL (POL-11)` diagnostic. The `|| echo 0` fallback is unreachable under the actual execution environment. The `binaries` variable would also contain the two-line value `"0\n0"` (one from grep-c per-file, one from echo) if the fallback did execute, making the subsequent `-lt` comparison unreliable. **LATENT defect in the 9312f11f form:** CI ran SUCCESS for 9312f11f because the guard's positive path (≥ 90 binaries found) never triggered this branch.
- **Evidence:** `9312f11f` ci.yml floor script `grep -c ... || echo 0` form; workflow default `set -e` behavior; bash `|| echo 0` semantics under set -e.
- **Proposed Fix:** Restructure the floor script: run `cargo test --all-features -- --list` separately; capture output to a file; use `grep -c` without `|| echo 0`; protect with explicit `|| true` only where appropriate; ensure the `FAIL (POL-11)` diagnostic fires on stdout before exit 1.
- **Status:** FIXED — fix round 7 (product commit `a247a343`: floor script restructured; `CARGO_TERM_COLOR: never`; `FAIL (POL-11)` diagnostic is now reachable; canary assertion added; three proofs executed).

---

#### ADV-P19-MED-002: Unhardened text parse under workflow's own `CARGO_TERM_COLOR: always` — ANSI codes would silently zero anchored regex [LATENT — NOT a live break]
- **Severity:** MEDIUM
- **Category:** CI-integrity / fragility
- **Location:** `.github/workflows/ci.yml` `test` job + `msrv` job file-scoped env `CARGO_TERM_COLOR: always`
- **Description:** The `9312f11f` POL-11 floor script parses `cargo test` output by grepping for `'test result:'` using an anchored regex. The workflow file sets `CARGO_TERM_COLOR: always` at file scope (applies to all jobs). With `CARGO_TERM_COLOR: always`, `cargo test` emits ANSI escape codes around "test result:" (e.g., `\x1b[32mtest result:\x1b[0m`). The anchored grep `'test result:'` would match zero lines in a colorized run. **Speculation refuted:** The orchestrator asserted this "would have matched zero lines in CI and aborted the step." CI runs for `9312f11f` completed SUCCESS (positive path; the guard's floor assertion passed). The defect was LATENT — the positive path worked because ANSI codes wrap but do not replace the ASCII text pattern; however, the negative path (zero tests) was never reached in CI, so the "zero lines" hypothesis was never proven. The fragility is real; the claim of confirmed CI breakage was not verified.
- **Evidence:** `ci.yml` file-scope `CARGO_TERM_COLOR: always`; `cargo test` colorized output format; `9312f11f` CI run results (SUCCESS — confirming the positive path was unaffected); ANSI-contaminated grep sensitivity.
- **Proposed Fix:** Add `CARGO_TERM_COLOR: never` to the POL-11 floor step, overriding the file-scope setting. This ensures grep operates on clean ASCII regardless of file-scope color config.
- **Status:** FIXED — fix round 7 (product commit `a247a343`: `CARGO_TERM_COLOR: never` added to the floor step; color fragility eliminated).

---

#### ADV-P19-MED-003: Pin asserted only `contains("FAIL (POL-11)")` — not `-eq 0`, not `exit 1`, not the `Check passed:` positive-coverage line
- **Severity:** MEDIUM
- **Category:** CI-integrity / under-specified-pin
- **Location:** `tests/ci_gate_completeness.rs::test_verify_test_job_has_zero_test_floor`
- **Description:** The `9312f11f` guard test (`test_verify_test_job_has_zero_test_floor`) asserts only that the script's output `contains("FAIL (POL-11)")` on the negative path. It does not assert: (1) the script exits with status code 1 (exit code contract); (2) the total test count is exactly 0 in the failure message; (3) the positive path emits `"Check passed:"`. A partial-match test on one line of output is insufficient to pin the full behavioral contract of the guard. An implementation that prints "FAIL (POL-11)" but exits 0, or one that changes the positive-coverage emission without changing the failure emission, would pass this pin while breaking the behavioral contract.
- **Evidence:** `tests/ci_gate_completeness.rs` `test_verify_test_job_has_zero_test_floor` assertion coverage.
- **Proposed Fix:** Extend the pin: assert floor, canary, `exit 1`, and `Check passed:` positive-coverage line. Cover both proof directions (negative path → exit 1 + FAIL message; positive path → exit 0 + Check passed message).
- **Status:** FIXED — fix round 7 (product commit `a247a343`: pin extended to assert floor, canary, `exit 1`, `Check passed:` positive-coverage line; all four assertion surfaces now covered).

---

#### ADV-P19-MED-004: Round-6 citation sweep corrected seven sites in `S-MUTANTS-EXAMINE-GLOBS-1.md` but missed one site at line 82 [process-gap]
- **Severity:** MEDIUM
- **Category:** spec-process / PROCESS-GAP · sweep-to-class miss
- **Location:** `.factory/stories/S-MUTANTS-EXAMINE-GLOBS-1.md` line ~82
- **Description:** Fix round 6 swept `S-MUTANTS-EXAMINE-GLOBS-1.md` for stale `ci.yml` line-number citations and corrected seven sites. One site at approximately line 82 (citing the `mutants` job step range `~:259`) was not corrected by round 6's sweep. The correct anchor-form citation is `ci.yml :: mutants / Run mutation tests on PR diff`. The sweep was grep-derived and reached this file (FIRST EVIDENCE OF IMPROVEMENT noted in pass-18), but the instance at line 82 was missed while the seven sibling instances in the same file were corrected.
- **Evidence:** `S-MUTANTS-EXAMINE-GLOBS-1.md` line ~82 retaining stale `~:259` cite; sibling instances in same file corrected; round-6 sweep records.
- **Proposed Fix:** Correct line ~82: `~:259` → `ci.yml :: mutants / Run mutation tests on PR diff`. Version-bump the file.
- **Status:** PARTIALLY CLOSED — fix round 7: one site corrected before template-compliance hook blocked further edits; 4 remaining sites (body lines ~235/257/348/424) blocked by pre-existing template drift (`cycle`/`epic_id` frontmatter missing; `Purity Classification` and `Library & Framework Requirements` sections absent). File NOT version-bumped. Needs `conform-to-template` pass to unblock. Gap reported, not fought (DEC-215 routing context).

---

#### ADV-P19-MED-005: STORY-INDEX S-641-1 row reads version chain `v0.2→v0.6` while S-641-1 body documented v0.7 and the file was at v0.7 — stale by TWO revisions
- **Severity:** MEDIUM
- **Category:** spec-fidelity / GAP · version-staleness
- **Location:** `.factory/stories/STORY-INDEX.md` S-641-1 row; `.factory/stories/S-641-1.md`
- **Description:** The STORY-INDEX S-641-1 row's version chain read `v0.2→v0.6` at time of pass-19 dispatch. The S-641-1 file body documented v0.7 (per CORRECTIONS history). The STORY-INDEX row was therefore stale by TWO revisions: it showed v0.6 as the latest version when the file was already at v0.7 (from fix round 4; both round-4 and round-5 edits landed under the v0.7 label per ADV-P18-MED-004). This represents a double-skip: the row failed to advance when S-641-1 was bumped v0.6→v0.7, and then remained stale through a subsequent round of edits.
- **Evidence:** STORY-INDEX S-641-1 row version chain; S-641-1.md CORRECTIONS section; STORY-INDEX v1.5.56 changelog entries for rounds 4 and 5.
- **Proposed Fix:** Update STORY-INDEX S-641-1 row to reflect v0.7→v0.8 transition (combining the round-5 edits now under v0.8 via ADV-P18-MED-004 fix); record v0.8 bump.
- **Status:** FIXED — fix round 7 (STORY-INDEX v1.5.57: S-641-1 row corrected; v0.7→v0.8 transition recorded; DEC-214 closed F-07).

---

#### ADV-P19-MED-006: `fmt` and `clippy` jobs share identical orphaning exposure as `test` job; neither emits runtime-computed count of what it checked [process-gap] — ROUTED
- **Severity:** MEDIUM
- **Category:** CI-integrity / PROCESS-GAP · [process-gap]
- **Location:** `.github/workflows/ci.yml` `fmt` and `clippy` jobs
- **Description:** The `test` job's orphaning exposure (guarded by the POL-11 floor) has a direct parallel in the `fmt` and `clippy` jobs. Both `cargo fmt --all -- --check` and `cargo clippy --all-targets -- -D warnings` exit 0 when invoked on a project with no source files and produce no runtime-computed count of files or modules checked. A malformed `Cargo.toml` that excludes `src/` from compilation could cause both to exit 0 on zero inputs without any diagnostic. Neither job has a floor assertion equivalent to POL-11. This is a systemic CI-as-code pattern: the POL-11 fix addresses the symptom in the `test` job but leaves two sibling jobs with the same exposure class.
- **Evidence:** `ci.yml` `fmt` and `clippy` job definitions; absence of runtime-computed coverage count in either; structural parallel with the pre-fix `test` job.
- **Proposed Fix:** Add runtime-computed positive-coverage assertions to `fmt` and `clippy` jobs analogous to the POL-11 floor. (Routed per DEC-215 — would be a fourth product-CI change; not authorized this round.)
- **Status:** ROUTED per DEC-215 — real parallel gap; not fixed in fix round 7 (scope: would be a fourth product-CI change in the same PR cycle; orchestrator did not authorize this round). Tracked as drift item FMT-CLIPPY-NO-POSITIVE-COVERAGE.

---

### LOW

#### ADV-P19-LOW-001: S-640-1 cited `RUSTUP_TOOLCHAIN` at approximately line 179 in the `msrv` job; actual location is approximately line 163 — off by 16 lines
- **Severity:** LOW
- **Category:** spec-fidelity / stale-line-cite
- **Location:** `.factory/stories/S-640-1.md` Architecture Mapping and Task 2 `RUSTUP_TOOLCHAIN` citation
- **Description:** S-640-1 (at v0.5, the pre-round-7 version) cited `RUSTUP_TOOLCHAIN` at approximately `ci.yml:179` in the `msrv` job. After the ci.yml +54 line shift introduced by `9312f11f`, the `RUSTUP_TOOLCHAIN` line migrated from approximately `ci.yml:125` to `ci.yml:179`. However, S-640-1's citation was already at `~:179` — which corresponds to the post-9312f11f position. Further checking: the RUSTUP_TOOLCHAIN line is a distinct step from the msrv job name/toolchain setup; the citation conflated two distinct steps into one `~:179` reference. The actual span is split across `ci.yml :: msrv / Set MSRV toolchain` and `ci.yml :: msrv / Check RUSTUP_TOOLCHAIN`, which S-640-1 cited as a single undifferentiated line reference 16 lines away from either.
- **Evidence:** S-640-1.md Architecture Mapping and Task 2 RUSTUP_TOOLCHAIN cite vs actual `ci.yml :: msrv` job step positions; +54-line shift from `9312f11f`; distinct step anchors.
- **Proposed Fix:** Migrate `~:179` → `ci.yml :: msrv / Set MSRV toolchain` and `ci.yml :: msrv / Check RUSTUP_TOOLCHAIN` as separate anchor-form citations for the two distinct steps.
- **Status:** FIXED — fix round 7 (S-640-1 v0.5→v0.6: anchor-form migration; two distinct steps now cited separately; DEC-213 anchor-form convention authorized).

---

### INFO

#### ADV-P19-INFO-001: Floor's negative path (zero-test scenario) had no evidence in the demo pack at time of pass-19 dispatch
- **Severity:** INFO
- **Category:** evidence-completeness / informational
- **Location:** `.factory/demos/S-626-1/` demo pack
- **Description:** The demo pack at time of pass-19 dispatch (based on `9312f11f`) included positive-path evidence for the POL-11 floor (`Check passed: 2345 tests executed across 103 test binaries`). The negative-path proof (floor fires on zero tests → `FAIL (POL-11)` + `exit 1`) was described in the story AC but not captured as a demo artifact. Local replication was omitted from the demo pack, and the INFO-01 note additionally omits `CARGO_TERM_COLOR: always` from the replication environment. The negative-path replication was performed during pass-18 dispatch (empirical confirmation) but not persisted as a demo artifact.
- **Evidence:** `demos/S-626-1/full-suite.txt` (positive path only); absence of negative-path demo artifact; AC-9 evidence section.
- **Proposed Fix:** Capture the negative-path shell session (command, output, exit code) as a demo artifact or inline evidence block. Include `CARGO_TERM_COLOR: never` in the replication environment.
- **Status:** NOTED — demo pack updated in fix round 7 to include the hardened `a247a343` floor script with negative-path proof documented in `full-suite.txt`. Accepted.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 2 |
| MEDIUM | 6 |
| LOW | 1 |
| INFO | 1 |

**Overall Assessment:** NOT CLEAN — 2 HIGH + 6 MEDIUM + 1 LOW + 1 INFO; zero code defects in `src/`; **FOUR REAL CI-AS-CODE DEFECTS** in orchestrator-shipped POL-11 guard (`9312f11f`). All four product defects (ADV-P19-HIGH-001, ADV-P19-MED-001, ADV-P19-MED-002, ADV-P19-MED-003) closed by product commit `a247a343`. ADV-P19-HIGH-002 (scope breach) closed by S-626-1 v1.13 (fix round 7). Policy rubric ABSENT (`.factory/policies.yaml` does not exist) — baseline applied.

**Window status:** NOT CLEAN; window 0/2 of 18/19/20 (ELIGIBLE — isolation CLEAN). TWELFTH consecutive pass with zero `src/` code defects. **Pass-19 is the most consequential finding round of this cycle: four real product-CI defects in a guard the orchestrator authorized and shipped, all caught by adversary one round later.** Anchor-form migration (DEC-213) structurally ends the recurring ci.yml line-citation ripple class. Pass-20 pending.

**META-PATTERN SIXTH TIME:** Pass-19 independently re-verified that fix round 6 executed its mechanical mandate essentially perfectly but failed sweep-to-class (ADV-P19-MED-004: one site missed in S-MUTANTS-EXAMINE-GLOBS-1.md while seven siblings were corrected). However, **round-7's anchor migration is CLASS-ELIMINATING**: the first structural fix rather than another sweep. `ci.yml :: <job-id>` notation does not drift on line shifts. This ends the recurring citation-ripple pattern that generated 3 measured sweep rounds.

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 19 (WINDOW-ELIGIBLE — isolation CLEAN; window 0/2 of 18/19/20) |
| **New findings** | 10 (2 HIGH + 6 MEDIUM + 1 LOW + 1 INFO) |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 1.00 (10/10 — all findings novel; no carryover duplicates) |
| **Median severity** | 3.0 (MEDIUM; sorted: 4,4,3,3,3,3,3,3,2,1 → midpoint index 5/6 both = 3) |
| **Source of HIGH findings** | Both from orchestrator-shipped POL-11 guard (`9312f11f`): one CI-as-code defect (HIGH-001: inert floor), one scope-breach in story spec (HIGH-002); HIGH-001 and MED-001/002/003 are all in the same `ci.yml` floor script shipped as `9312f11f` |
| **Code defects in src/** | 0 (twelfth consecutive pass) |
| **Product defects total** | 4 (HIGH-001, MED-001, MED-002, MED-003 — all in `ci.yml` floor script from `9312f11f`); all closed by `a247a343` |
| **Trajectory** | P6=10, P7=13, P8=5, P9=15, P10=18, P11=13, P12=10, P13=10, P14=9, P15=15, P18=10, P19=10 |
| **Verdict** | FINDINGS_REMAIN — NOT CLEAN; 2 HIGH + 6 MEDIUM + 1 LOW + 1 INFO; zero src/ code defects; FOUR REAL CI-AS-CODE DEFECTS in orchestrator-shipped POL-11 guard; all closed by a247a343; window 0/2 of 18/19/20 |
| **Reviewer recommendation** | Round-7's anchor-form migration (`ci.yml :: <job-id>`) is the first CLASS-ELIMINATING structural fix in six rounds. The three prior citation-ripple sweeps (+39, +54, cumulative +93 lines from original) will not recur for the migrated surfaces. Codify DEC-213 anchor-form convention in all future story templates. Separately: the orchestrator-caused defect pattern (shipping `9312f11f` with an inert floor, unreachable diagnostic, and under-specified pin) warrants a HIGH drift item tracking orchestrator guard-verification discipline. |
