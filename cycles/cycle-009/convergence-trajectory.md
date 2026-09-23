---
document_type: convergence-trajectory
level: ops
version: "1.0"
status: complete
producer: state-manager
timestamp: 2026-09-23T02:27:03Z
cycle: "cycle-009-jql-relative-date-units"
inputs: ["cycles/cycle-009/burst-log.md"]
input-hash: "[live-state]"
traces_to: STATE.md
---

# Convergence Trajectory — cycle-009 (jql-relative-date-units), Phase F5

This is cycle-009's first implementation-level adversarial pass set (F5 scoped adversarial
refinement on the merged delta, diff `bcec4c78..1847ce38`). cycle-008's prior trajectory
(`→4→0→0→0`) was carried in STATE.md as a placeholder before cycle-009 reached its own F5;
it is historical/closed and unrelated to the rows below.

## Finding Progression

| Pass | Date | Dimension | Total | CRIT | HIGH | MED | LOW | Novelty | Counter | Verdict |
|------|------|-----------|-------|------|------|-----|-----|---------|---------|---------|
| 1 | 2026-09-22 | correctness / edge-cases | 0 | 0 | 0 | 0 | 0 | LOW | 1/3 | CLEAN |
| 2 | 2026-09-22 | test-quality / coverage | 0 | 0 | 0 | 0 | 0 | LOW | 2/3 | CLEAN |
| 3 | 2026-09-22 | spec-doc-changelog drift | 0 | 0 | 0 | 0 | 0 | LOW | 3/3 | CLEAN — CONVERGED |

## Trajectory Shorthand

`0→0→0`

## Per-Pass Details

### Pass 1 (2026-09-22)

**Dimension:** correctness / edge-cases, on the merged delta diff `bcec4c78..1847ce38`.
**Findings:** 0 (0 CRIT, 0 HIGH, 0 MED, 0 LOW).
**Novelty:** LOW.
**Convergence counter:** 1 of 3.

Fresh-context adversary reviewed `src/jql.rs::validate_duration`'s M/y rejection logic, the
4-site canonical error string, and the CR-005 hint wiring against the F2 spec delta
(`BC-2.1.008`, `BC-2.1.023`/`EC-2.1.023-1`/`EC-2.1.023-5`). No correctness or edge-case gaps
found. (Two LOW doc/hygiene items surfaced separately this cycle and were cleared via PR `#869`
before this pass ran — see "Pre-Convergence Hygiene Cleanup" below; they are not counted here.)

---

### Pass 2 (2026-09-22)

**Dimension:** test-quality / coverage, on the merged delta diff `bcec4c78..1847ce38` (plus PR
`#870`'s test-hygiene follow-up once landed).
**Findings:** 0 (0 CRIT, 0 HIGH, 0 MED, 0 LOW).
**Novelty:** LOW.
**Convergence counter:** 2 of 3.

Fresh-context adversary reviewed the new integration tests (`tests/issue_commands.rs`) against
the F7 Delta-Convergence Acceptance Gate's 5 CR-004 assertions (2×2 rejection matrix
`{2M,1y}×{--recent,--updated-recent}` + 1 case-boundary assertion) plus the Red Gate log. No
coverage gaps found. (PR `#870`'s DRY/stale-comment/uppercase-unit test-hygiene items were
identified and fixed same-cycle, prior to this pass returning clean — see below.)

---

### Pass 3 (2026-09-22)

**Dimension:** spec-doc-changelog drift, on the merged delta diff `bcec4c78..1847ce38` plus
follow-up PRs `#869`/`#870`.
**Findings:** 0 (0 CRIT, 0 HIGH, 0 MED, 0 LOW).
**Novelty:** LOW.
**Convergence counter:** 3 of 3 — **CONVERGED**.

Fresh-context adversary cross-checked `CHANGELOG.md`, `spec-changelog.md` (2.3.2), the CR-002
docs stragglers, and `BC-2.1.008`/`BC-2.1.023` citation text against the shipped code and the
two follow-up PRs. Zero drift found. Both `scripts/check-spec-counts.sh` and
`scripts/check-bc-cumulative-counts.sh` exit 0 (count-neutral, no BC/VP change this phase).

## Pre-Convergence Hygiene Cleanup (not counted against the 3-clean-pass tally above)

Before the 3 fresh-context passes above returned fully clean, F5 also cleared two rounds of
LOW-severity doc/hygiene findings via follow-up fix PRs (both human-approved, CI-green,
squash-merged to `develop`):

- **PR `#869`** (docs-only, finding `F-A-001`): completed the CR-002 supersession markers on
  the superseded design doc's y/M reference tables + appendix + inline comment
  (`docs/superpowers/plans/2026-03-25-common-filter-flags.md` /
  `docs/superpowers/specs/2026-03-24-common-filter-flags-design.md` family). Merged `74abc573`.
  Also folded in finding `F-A-002` (spec-quote alignment), committed to `factory-artifacts` at
  `40e9945a`.
- **PR `#870`** (F5 LOW test-hygiene, behavior-preserving): DRY'd the
  `validate_duration` canonical error string into a single helper (all 4 call sites,
  byte-identical output, new non-M/y exact-pin regression test), fixed a stale test-rename
  comment, and added uppercase-unit (`W`/`D`/`H`/`1Y`) rejection test coverage. Clean local
  review APPROVE; full regression 5,370 passed / 0 failed / 188 ignored; `cargo fmt` clean;
  `cargo clippy --all --all-features --tests -- -D warnings` clean; CI Gate green. Merged
  `805ca0e0`. Squash-merged directly by the orchestrator (human-authorized) after the
  `github-ops` merge relay repeatedly failed to execute the merge — see
  `CYCLE-009-GITHUB-OPS-MERGE-RELAY-LAG` in `cycles/OPEN-STANDING-ITEMS.md`.

Both rounds resolved same-cycle before the tabulated 3-pass convergence run; neither reset the
convergence counter (both are LOW-severity hygiene fixes, not CRITICAL/HIGH/MEDIUM findings).

## Outcome

**CONVERGED** — 3/3 consecutive clean passes, zero CRITICAL/HIGH/MEDIUM findings across all
three dimensions, novelty decayed to LOW. `develop` tip `1847ce38` → `74abc573` (PR `#869`) →
`805ca0e0` (PR `#870`) this phase. `activation_head`/`activation_version` unchanged at
`8b4c797a`/`v0.7.0-dev.8` (no release cut). Counts unchanged: 770 BCs / 89 VPs / 118 holdout /
191 stories. **NEXT:** Phase F6 (light targeted hardening — `cargo mutants --in-diff` on PR
scope; existing panic proptest + security posture suffice per F1/F2 scope).

## Frontmatter Fields (extracted from STATE.md)

<!-- No adversary_pass_N_* frontmatter fields were carried in STATE.md for this cycle —
     F5's 3-pass trajectory was recorded directly to this file rather than staged in
     STATE.md frontmatter first. The Finding Progression table above is the source of
     record. -->

