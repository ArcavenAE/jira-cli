---
story_id: S-392
cycle: cycle-001
red_gate_date: 2026-05-19
verified_by: orchestrator (independent re-run of fixture harness in worktree after test-writer commit 3344974)
verdict: PASSED
---

# S-392 Red Gate Log

## Context

S-392 implements GitHub issue #392 — a new CI guard `scripts/check-bc-cumulative-counts.sh` (DRIFT-002) that validates cumulative `total_bcs` + BC-INDEX section-header counts across the spec tree. Infrastructure/tooling story — bash + fixtures + CI YAML, no Rust, no behavioral contracts. ACs trace to the issue #392 design doc (`.factory/phase-f1-delta-analysis/issue-392/design.md`, Q1-Q6).

## Test deliverable (Step 3, commit 3344974)

The test-writer built a fixture-based test harness at `tests/spec-count-fixtures/`:
- `run-tests.sh` — harness; invokes the guard against each fixture, asserts exact exit code
- 4 hermetic fixture mini-trees:
  - `known-good/` — all count surfaces agree → guard expected exit 0. ALSO contains an intentionally-mismatched L2-vs-L3 `PENDING` row, so this fixture doubles as the PENDING carve-out test (AC-2).
  - `bc-drift-total/` — BC-INDEX Section header disagrees with bc-N `total_bcs` → expected exit 1
  - `bc-drift-prose/` — bc-N body-preamble prose count disagrees with frontmatter → expected exit 1
  - `bc-drift-grandtotal/` — grand-total Sum disagrees → expected exit 1
- `README.md` — fixture documentation
- `.gitignore` modified: added `!tests/spec-count-fixtures/*/.factory/` negation so fixture `.factory/` trees are not swallowed by the top-level `.factory/` ignore rule.

## Red Gate verification

Command: `cd /Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-392 && bash tests/spec-count-fixtures/run-tests.sh`

Result:
```
ERROR: guard script not found at scripts/check-bc-cumulative-counts.sh
       This is the expected Red Gate state — the guard has not been implemented yet.
Results: 0 passed, 4 failed (guard absent)
exit=1
```

Independently confirmed: `scripts/check-bc-cumulative-counts.sh` does not exist (`ls` → No such file or directory).

## Red Gate Outcome: PASSED

- The fixture harness is structurally complete: it discovers 4 fixture trees, attempts to invoke the guard, and asserts exit codes.
- It fails because the implementation (`check-bc-cumulative-counts.sh`) is absent — the correct red state for a TDD bash-tooling story.
- The harness deliberately distinguishes "guard absent" (this Red Gate state) from "guard present but produces wrong exit code" (real assertion failures it will perform once the guard exists). This separation means the SAME harness cleanly transitions to green after Step 4.

## Red Gate adaptation note (bash story, not Rust)

The deliver-story workflow's Red Gate is Rust-centric ("tests fail with assertion errors, not build errors"). For a bash CI-guard story there is no compile step; the analogous red state is "the test harness exists and is structurally sound, but the script-under-test is absent so no fixture can pass." Step 2 (cargo-check stubs) is N/A and was skipped. This is the documented adaptation, consistent with how S-383 (a pure-addition story) skipped Step 2.

Step 4 (implementation) authorized: implementer writes `scripts/check-bc-cumulative-counts.sh` to make all 4 fixtures pass, fixes the live `bc-2-issue-read.md` 92→93 prose drift (AC-5), wires CI (AC-6), and confirms the guard exits 0 against the real repo (AC-7).

## Compliance Notes

- IRON LAW satisfied: implementation authorized only after the Red Gate harness was verified failing.
- Step 2 (stubs) N/A for a bash story — documented above.
- No `||` accept-either logic in the harness assertions (exact exit-code equality) — L-288-pr2-02 spirit.
- Fixtures are hermetic (no network, no real-repo dependency).
