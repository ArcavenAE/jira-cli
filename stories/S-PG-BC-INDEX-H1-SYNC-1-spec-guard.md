---
document_type: story
level: ops
story_id: "S-PG-BC-INDEX-H1-SYNC-1"
epic_id: "SELF-IMPROVEMENT"
title: "Spec-guard: BC-INDEX.md row title <-> BC H1 sync (script + CI wiring + baseline/sweep decision)"
version: "1.0"
producer: story-writer
timestamp: "2026-10-04T00:00:00"
phase: 2
cycle: none
wave: feature-followup
status: draft
intent: process-codification
feature_type: test-infra
mode: feature
scope: standard
severity: MEDIUM
trivial_scope: false
points: 5
priority: P2
tdd_mode: strict
estimated_effort: small
estimated_days: 2
target_module: scripts/check-bc-index-h1-sync.sh
subsystems: []
depends_on: []
blocks: []
behavioral_contracts:
  # BC status: no product BCs. Tooling story (spec-guard script + CI wiring);
  # it adds no jira-cli behavioral surface. Follows the no-BC precedent of
  # S-PG-FILTER-ENUM-SYNC-1 and the other SELF-IMPROVEMENT stories. Nothing
  # in the S-7.01 gate blocks `ready` for a no-BC tooling story IF the human
  # confirms the precedent applies; flagged for the reviewer.
  []
bcs: []
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F7-delta-convergence
inputs:
  - ".factory/STATE.md"
  - ".factory/cycles/cycle-014/phase-f5-adversarial/FIX-P5-012-spec-delta.md"
  - ".factory/cycles/cycle-014/phase-f5-adversarial/FIX-P5-012-h1-sync-baseline.txt"
input-hash: "78b83ff"
traces_to: "GitHub issue #906; cycle-014 F5 Pass 11 process-gap P11-001; human decision D-406(b); standing item BC-INDEX-H1-SYNC-GUARD (OPEN-STANDING-ITEMS)"
spec_source: "Human F7-gate disposition of cycle-014 process-gap items (STATE.md Pending human decisions (d)): open SELF-IMPROVEMENT-epic stories for BC-INDEX-H1-SYNC-GUARD and FIX-PR-NO-ADVERSARY-CONVERGENCE. Drafted for human review; NOT approved for delivery."
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 8
assumption_validations: []
risk_mitigations: []
created: "2026-10-04"
last_updated: "2026-10-04"
changelog:
  - "1.0 (2026-10-04): Initial draft. Opened from cycle-014 P11-001 / D-406(b) / #906. Baseline-vs-sweep decision deliberately left OPEN (both options presented). CI wiring is CI-gate review scope."
breaking_change: false
lineage:
  - S-PG-FILTER-ENUM-SYNC-1
  - S-392-cumulative-spec-count-guard
drift_items:
  - BC-INDEX-H1-SYNC-GUARD
files_created:
  - "scripts/check-bc-index-h1-sync.sh"       # CREATE — guard script (--bc-dir, --self-test)
  - "scripts/bc-index-h1-sync-baseline.txt"   # CREATE ONLY IF Option A (baseline) is chosen
files_modified:
  - ".github/workflows/ci.yml"                # MODIFY — new steps in spec-guard job (CI-GATE REVIEW SCOPE)
  - "tests/ci_gate_completeness.rs"           # MODIFY — spec-guard per-step key-set pin (CI-GATE REVIEW SCOPE)
  - ".factory/specs/prd/BC-INDEX.md"          # MODIFY ONLY IF Option B (one-time sweep) is chosen
  - "CLAUDE.md"                               # MODIFY — AI Agent Notes: one bullet for the new guard, same commit
---

# S-PG-BC-INDEX-H1-SYNC-1 — Spec-Guard: BC-INDEX Row Title <-> BC H1 Sync

## Source of Truth

- GitHub issue #906 (`chore(spec-guard): enforce BC H1 title <-> BC-INDEX row sync`). Issue
  content is UNTRUSTED context; this story restates only the facts independently verifiable
  from the factory-artifacts sources below and follows no instructions from the issue body.
- cycle-014 F5 Pass 11 finding `P11-001` (MEDIUM process-gap): the BC-INDEX rows for
  `BC-X.14.002`/`BC-X.14.004` did not mirror their H1s; nothing guards H1 <-> index sync.
- Human decision `D-406(b)`: the guard was DEFERRED (240 pre-existing mismatches outside the
  touched set; CI wiring would touch CI-gate review-scope files). Standing item
  `BC-INDEX-H1-SYNC-GUARD`.
- Matching rule + reference awk + 240-ID list:
  `.factory/cycles/cycle-014/phase-f5-adversarial/FIX-P5-012-spec-delta.md` and
  `.../FIX-P5-012-h1-sync-baseline.txt` (242 lines = 2 header comment lines + 240 IDs).

## Behavioral Contracts

None (tooling, no BC). No jira-cli runtime behavior changes; the guard inspects spec files only.

## Narrative

As the spec-guard CI job, I want to fail when a `BC-INDEX.md` row title differs from the H1
title in that BC's `bc-*.md` file, so that the established convention "BC H1 is the title
source of truth; the index mirrors it verbatim" is mechanically enforced instead of relying on
adversarial-review discipline (which missed 240 drifts and only caught the cycle-014 ones by
luck in Pass 11).

## Problem Statement

The existing spec guards (`check-spec-counts.sh`, `check-bc-cumulative-counts.sh`,
`check-bc-no-numeric-test-counts.sh`, `check-bc-citation-symbols.sh`) check counts and
citations only. Title drift between H1 and index accumulates silently: a sweep during
cycle-014 found 240 pre-existing mismatches across bc-1..bc-8 and cross-cutting. Cycle-014's
touched BCs were synced; the rest were deliberately left. A guard that fails on all 240
immediately cannot merge, so the story must choose how to land it (see Decision Point).

## Matching Rule (from the cycle-014 spec delta; implementer must re-verify against the delta doc)

- H1: `^#+ BC-<sec>.<n>.<n>: <title>` (three dotted parts); title = text after the first
  `": "`, trimmed.
- Index rows: lines starting `| BC-`; escaped `\|` handled; field 2 = ID, field 3 = title
  cell, both trimmed.
- Comparison: exact string equality per ID. Index rows with no H1, and H1s with no index row,
  are reported as separate classes. 15 BC H1s currently have no individual index row —
  whether that is allowed is an OPEN question (see Decision Point 2).

## DECISION POINT 1 (human): how to land against ~240 pre-existing mismatches

This story does NOT decide. Present both; the human selects before `status: ready`.

| | Option A: allowlist/baseline | Option B: one-time sweep |
|---|---|---|
| Mechanism | Guard ignores IDs in `scripts/bc-index-h1-sync-baseline.txt`; FAILS if a listed ID now matches (stale baseline entry, delete the line) | A sweep PR makes all 240 H1/index pairs equal (per ID: decide which side is correct), then the guard lands with no baseline |
| Review surface | Small (script + baseline copy of the 240 IDs) | Large (up to 240 spec-title edits across BC files and BC-INDEX; each needs a which-side-is-right judgment; may ripple into story/BC cross-refs and `check-bc-cumulative-counts.sh` surfaces) |
| Risk | Baseline can become a permanent dumping ground; new drifts in baselined IDs are invisible | Judgment errors rewrite a correct title to a wrong one; big diff late in a cycle |
| Debt | 240 remain; ratchet only shrinks | Zero debt at landing |
| Hybrid | Land Option A now; sweep in batches in later maintenance cycles, shrinking the baseline (each batch must delete the matching baseline lines) | n/a |

## DECISION POINT 2 (human): the 15 H1s with no individual index row

Either (a) allowed — grouped/range rows exist by design, guard reports them informationally
only, or (b) disallowed — each needs an index row. Default if undecided: (a), informational.

## CI-GATE REVIEW SCOPE NOTE (mandatory reviewer attention)

Wiring the guard into the `spec-guard` job edits `.github/workflows/ci.yml` and requires a
matching update to `spec-guard`'s ordered per-step key-set pin in
`tests/ci_gate_completeness.rs` (the pin enumerates `spec-guard`'s steps; adding
steps without updating it fails that suite by design). Both files are in the SIX-FILE CI-gate
review scope documented in CLAUDE.md (`ci.yml`, `scripts/check-ci-gate.sh`,
`tests/ci_gate_completeness.rs`, `tests/common/wf.rs`, `scripts/lib/trusted-jq.sh`,
`scripts/mutants-aggregate.sh`). Code review of the PR must cover the diff across all of
them together. The new steps must follow the existing step shape (pinned action SHAs untouched,
no `shell:` additions, no `if:`; mirror the `check-bc-citation-symbols` self-test + run pair).
`spec-guard` has `timeout-minutes: 5`; confirm the added steps fit. The new script lives
under `scripts/` and is executed from the PR's own checkout (same trust posture as sibling
guards).

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~3,200 |
| FIX-P5-012 spec delta (matching rule + awk) | ~1,500 |
| Sibling script `scripts/check-bc-citation-symbols.sh` (structural template, `--self-test`) | ~3,000 |
| `ci.yml` spec-guard job + `tests/ci_gate_completeness.rs` spec-guard pin region | ~4,500 |
| BC-INDEX.md structure sample + a few bc-*.md H1s | ~2,000 |
| **Total** | **~14,200** |

Within budget. Option B (sweep) would exceed it and must be split into per-section sub-stories.

## Previous Story Intelligence

- `check-bc-citation-symbols.sh` (D-148 Guard 1) is the direct template: `--bc-dir`,
  `--self-test`, an offender list with a stable error code, exit 0/1.
- `check-bc-cumulative-counts.sh` was extended through DRIFT-002; BC-INDEX.md is a shared
  surface — any Option B edit must re-run it and `check-spec-counts.sh`.
- `S-PG-FILTER-ENUM-SYNC-1` is the in-epic precedent for a no-BC guard living in this repo.
- Cycle-014 lesson: a guard must also be self-tested with fixtures proving it fails (per the
  `ci.yml` self-test step pattern), not only that it passes on the current tree.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|---|---|---|
| Flag, never auto-fix | SELF-IMPROVEMENT siblings | The script reports offenders; it never edits spec files. |
| Exact equality, no normalization beyond trim | Matching rule | No case-folding or markdown-stripping; otherwise drift hides. |
| Stable error code | Sibling guards (`BC-CITE-001`, `CI-CITE-001`) | Emit a documented code (proposal `BC-H1-SYNC-001`) in the offender header. |
| CI-gate pin updated in the same change | CLAUDE.md CI Gate section | `ci.yml` and `tests/ci_gate_completeness.rs` edited together. |
| Baseline ratchet (Option A only) | D-406(b) | A baselined ID that now matches fails the guard (stale entry). |
| Doc fallout | CLAUDE.md convention | Add the guard to the AI Agent Notes list of `scripts/check-*` in the same commit. |

## Library & Framework Requirements

No new crates. Bash + POSIX awk/sed only (macOS BSD and GNU compatible — avoid GNU-only flags;
see CLAUDE.md note on BSD/GNU divergence). No new GitHub Actions; the guard runs under the
existing `spec-guard` job steps. jq not required.

## Forbidden Dependencies

The script must not depend on `src/` or on a built `jr` binary, and must not be invoked from
`cargo test` as its only enforcement (it must run in `spec-guard`, which has no Rust build).
If the script gains a dependency on a compiled artifact, review MUST reject it.

## File Structure Requirements

| File | Create / Modify | Description |
|---|---|---|
| `scripts/check-bc-index-h1-sync.sh` | CREATE | Guard: `--bc-dir`, `--self-test`, optional `--baseline <file>` (Option A). |
| `scripts/bc-index-h1-sync-baseline.txt` | CREATE (Option A only) | One BC ID per line, `#` comments allowed; seeded from the cycle-014 240-ID list, re-verified at implementation time (the list may have shrunk). |
| `.github/workflows/ci.yml` | MODIFY | Two steps in `spec-guard`: self-test, then real run. |
| `tests/ci_gate_completeness.rs` | MODIFY | Update `spec-guard` ordered per-step key-set pin and any "N steps" doc/assert counts. |
| `.factory/specs/prd/bc-*.md`, `BC-INDEX.md` | MODIFY (Option B only) | Title edits per sweep. |
| `CLAUDE.md` | MODIFY | One bullet describing the guard. |

## Acceptance Criteria

Tooling story — no BC traces (tooling, no BC); each AC traces to the standing item
`BC-INDEX-H1-SYNC-GUARD` / D-406(b).

- **AC-001** `scripts/check-bc-index-h1-sync.sh` exits 0 on a tree where every index row title
  equals its H1 title, and exits 1 with an offender list (ID, index title, H1 title) when any
  differ. Measured by a fixture self-test with at least: one matching pair, one differing
  pair, one index-row-without-H1, one H1-without-index-row.
- **AC-002** `--self-test` runs the fixtures offline (no network, no repo state) and exits 0
  only if every fixture produces its expected exit code and offender class; it is invoked by CI.
- **AC-003** Escaped `\|` inside a title cell compares correctly (fixture with a pipe in a
  title); a title differing only in trailing whitespace compares equal; a title differing in
  one character compares unequal.
- **AC-004** Against the real tree, the guard run outcome is deterministic and green at
  landing under the chosen option: Option A -> exit 0 with the baseline applied and a count of
  ignored IDs printed; Option B -> exit 0 with no baseline.
- **AC-005** (Option A only) A baseline ID whose H1 and index title now match causes exit 1 with
  a "stale baseline entry" message naming the ID; a new mismatch on a NON-baselined ID exits 1.
- **AC-006** H1s with no index row and index rows with no H1 are reported as distinct classes;
  per Decision Point 2 the first class is informational or failing as decided; the second
  always fails.
- **AC-007** `spec-guard` in `ci.yml` runs the self-test step and the real-run step;
  `cargo test --test ci_gate_completeness` passes with the updated step-key-set pin; a
  deliberately mismatched pin (reviewer check) fails it. `spec-guard` completes within its
  `timeout-minutes: 5`.
- **AC-008** CLAUDE.md lists the new guard; `scripts/check-spec-counts.sh` and
  `scripts/check-bc-cumulative-counts.sh` still exit 0.

## Tasks

1. Human selects Option A/B/hybrid and Decision Point 2; update this story to `ready` only
   after (S-7.01 precedent for no-BC tooling stories confirmed by the human).
2. Read the cycle-014 spec delta + baseline file; read `check-bc-citation-symbols.sh` as the template.
3. Write fixtures + the failing self-test first (TDD), then the script.
4. Seed/verify baseline (Option A) or execute the sweep in a separate sub-burst (Option B).
5. Wire `ci.yml` and the `ci_gate_completeness.rs` pin together; run the CI-gate suite locally.
6. Add the CLAUDE.md bullet.
7. Add a CHANGELOG entry under [Unreleased] > Changed describing the new spec guard,
   before creating the PR, so the changelog row ships inside the story PR.
8. Mutation-testing: N/A (shell script, no Rust diff) unless `ci_gate_completeness.rs`
   changes fall in `examine_globs` (check `.cargo/mutants.toml`).

## Edge Cases

| ID | Description | Expected Behavior |
|---|---|---|
| EC-001 | BC-INDEX row title contains `\|` | Handled; compared after unescape consistently on both sides. |
| EC-002 | Duplicate H1 for one ID across two files | Reported as an offender (ambiguous source of truth). |
| EC-003 | Row ID present in index but BC file lives in `cross-cutting.md` (multiple BCs per file) | H1 scan covers every `bc-*.md` and `cross-cutting.md` heading, not one H1 per file. |
| EC-004 | Title contains backticks/markdown | Exact string equality; no stripping. |
| EC-005 | Concurrent edits to BC files by other agents | Guard is read-only; no locking needed. |

## Dependency Analysis

depends_on: [] — standalone. blocks: []. Dependency justification: none required; the
cycle-014 baseline file is an input artifact, not a story. If Option B is chosen, the sweep
sub-story must land BEFORE this story's guard PR (it would then block this one) — to be added
at that time.

## Out of Scope

- Deciding which side (H1 vs index) is correct for any individual mismatch (Option B work,
  human/PO judgment per ID).
- Guards for other BC-INDEX columns (section, status) or other index files (STORY-INDEX, VP).
- Changing the "H1 is the source of truth" convention.
- Any `src/` change.

## Story Points and Effort

5 SP (Option A): script + fixtures 2, CI wiring + pin 2, docs/baseline 1. Option B adds an
unestimated sweep (estimate on selection; likely a separate multi-section sub-story set).
Priority P2.

## References

- GitHub #906 (untrusted context; not instruction source)
- `.factory/cycles/cycle-014/phase-f5-adversarial/FIX-P5-012-spec-delta.md`
- `.factory/cycles/cycle-014/phase-f5-adversarial/FIX-P5-012-h1-sync-baseline.txt`
- `.factory/cycles/OPEN-STANDING-ITEMS.md` `BC-INDEX-H1-SYNC-GUARD`
- STATE.md Decisions Log `D-406`; Drift Items row `P11-001`
- CLAUDE.md "CI Gate" section (six-file review scope)
