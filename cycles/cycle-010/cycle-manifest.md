---
document_type: cycle-manifest
cycle_id: cycle-010-big-function-extraction
cycle_type: refactor
version: TBD — proposed roll-into-next-dev-prerelease, no immediate tag (D-373 precedent) — confirm at F1 gate
status: draft-awaiting-f1-gate
started: 2026-09-24
completed: null
producer: architect (F1 delta analysis)
---

# Cycle Manifest: cycle-010 (big-function-extraction)

## Delivered

Not yet started. This manifest is created alongside the F1 delta-analysis
report to hold the cycle's slot and record the pre-approval framing; it will
be updated with real delivery data once the human approves scope at the F1
gate and F4 implementation begins.

## Summary

Source: completed tech-debt assessment
(`.factory/maintenance/tech-debt-assessment-2026-09-24.md`), TD-01 and TD-02
(both HIGH severity):

- **TD-01:** `src/cli/issue/edit.rs::handle_edit` — single ~1,314-LOC function
  (L45–1358).
- **TD-02:** `src/cli/issue/list.rs::handle_list` — single ~775-LOC function
  (L152–926).

**Critical framing:** behavior-preserving refactor. `jr issue edit` / `jr
issue list` external behavior (stdout, stderr, exit codes, JSON shapes, flag
handling, error text) must be byte-for-byte identical before and after.
Zero BC amendments — all existing BC-3.4.001..037 / BC-2.1.001..025 are the
contract to PRESERVE. Green-to-green: incremental extraction, full suite
green at every step.

Feature Mode, brownfield, refactor route (intent recorded as `enhancement`
per template — no clean bucket exists for "internal-quality refactor" in the
F1 template's `feature|enhancement|bug-fix` taxonomy, flagged as an open
question). Feature type: backend. Scope: standard (fails trivial criteria on
impact-boundary breadth and HIGH regression risk). Severity: N/A (not a
bug-fix).

## Spec Changes

None proposed. F2 (spec evolution) is recommended NULL/skipped for this
cycle — zero BC/VP changes. See `phase-f1-delta-analysis/delta-analysis.md`
Scope Recommendation and Open Questions #1/#6 for the conditions under which
a minimal `module-decomposition.md` touch-up might still be warranted
(only if a submodule split, rather than same-file private functions, is
chosen).

## Living Spec Snapshot

Not applicable yet — no spec change proposed.

## Deprecations (if any)

None.

## Tech Debt Created

None expected — this cycle exists specifically to RETIRE tech debt (TD-01,
TD-02) from `.factory/maintenance/tech-debt-assessment-2026-09-24.md`.

## Governance Policies Adopted

None.

## Notes

**Phase F1 (delta analysis): DRAFT, AWAITING HUMAN GATE.** F1 artifacts:
`phase-f1-delta-analysis/delta-analysis.md`,
`phase-f1-delta-analysis/affected-files.txt`. Human decisions needed at the
F1 gate (full list in the delta-analysis report's Open Questions section):

1. Approve adding characterization tests (list.rs table snapshot gap-closer +
   targeted edit.rs golden-output tests) as a mandatory first F4 step —
   recommended YES.
2. Confirm sequencing: one cycle (cycle-010) covering both edit.rs and
   list.rs, serialized (edit.rs fully green before list.rs starts) — vs. two
   separate cycles.
3. Confirm structure: same-file private functions (recommended default) vs.
   new `edit/`/`list/` submodule directories.
4. Confirm F3 (stories) SKIPPED (recommended, tracked via commits/burst-log
   per cycle-009's precedent) vs. run with ~6-10 micro-stories (one per
   extracted sub-function/seam).
5. Confirm versioning/release treatment at close — recommended roll into next
   dev prerelease, no immediate tag (cycle-009 `D-373` precedent).
6. Confirm architecture-doc treatment if a submodule split is chosen
   (lightweight architect note vs. full F2).
7. Note: exact BC-3.4.* ↔ `handle_edit`-vs-`handle_open`/`handle_move`
   mapping needs a fast trace pass before/during F4 (the "3.4 Edit and Open"
   PRD section may include BCs outside `edit.rs`'s scope).

**Proposed phase sequence:** F1 (this) → F2 NULL → F3 SKIPPED (default,
pending decision 4) → F4 (delta implementation, two serialized extraction
waves: edit.rs then list.rs, each with characterization tests first, then
incremental extraction commits, full suite green after every commit) → F5
(scoped adversarial on the diff) → F6 (targeted `cargo mutants --in-diff`
hardening on the diff scope) → F7 (delta convergence + human close gate).

Next: awaiting human F1-gate approval before any `src/` code is written (per
task instructions — this F1 pass is analysis-only, zero code changes made).
