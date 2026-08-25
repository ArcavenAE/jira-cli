---
document_type: story
level: ops
story_id: "S-PG-FILTER-ENUM-SYNC-1"
epic_id: "SELF-IMPROVEMENT"
title: "Mechanical guard: filter-source enumeration <-> build_filter_clauses sync"
version: "1.0"
producer: story-writer
timestamp: "2026-08-24T00:00:00"
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
points: 3
priority: P2
tdd_mode: strict
estimated_effort: small
estimated_days: 1
target_module: src/cli/issue/list.rs
subsystems: []
depends_on: []
blocks: []
behavioral_contracts:
  # BC status: no product BCs. This is a test-infrastructure/mechanical-guard
  # change (a `tests/` guard that keeps a human-facing message string in sync
  # with the filter-clause code it describes) with no jira-cli behavioral
  # surface of its own — the guard verifies an existing invariant, it does not
  # add new observable behavior. Follows the no-BC precedent set by
  # S-PG-MERGE-AUTH-BYPASS and its 8 SELF-IMPROVEMENT sibling stories.
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
  - ".factory/phase-f7-delta-convergence/list-read-ergonomics/delta-convergence-report.md"
input-hash: "6949e71"
traces_to: ".factory/phase-f7-delta-convergence/list-read-ergonomics/delta-convergence-report.md §4 Keep-Deferred Disposition (S-7.02), row FILTER-SOURCE-ENUMERATION-NO-MECHANICAL-ENFORCEMENT"
spec_source: "F7 list-read-ergonomics delta-convergence report §4 (producer: orchestrator F7 delta-convergence synthesis, timestamp 2026-08-24), human-granted F7 final-authorization gate directing follow-up stories be opened for the S-7.02 deferred process-gaps, anchored to the SELF-IMPROVEMENT epic per the human's explicit instruction."
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 4
assumption_validations: []
risk_mitigations: []
created: "2026-08-24"
last_updated: "2026-08-24"
changelog:
  - "1.0 (2026-08-24): Initial draft — opened from the F7 list-read-ergonomics delta-convergence report §4 Keep-Deferred Disposition, item FILTER-SOURCE-ENUMERATION-NO-MECHANICAL-ENFORCEMENT (process-gap, pre-existing, predates this cycle; human F7 final-authorization gate; human directed follow-up stories be opened for the S-7.02 deferred process-gaps). Self-improvement / review-discipline scope, anchored to the SELF-IMPROVEMENT epic (precedent: S-PG-MERGE-AUTH-BYPASS and its 8 sibling stories). Unlike those 8 siblings, this story's implementation lives in the jira-cli product repo itself (a `tests/` guard), not the Dark Factory engine — see Scope Note below. No BCs yet — PO authorship required before status=ready (S-7.01 gate)."
breaking_change: false
lineage:
  - S-PG-MERGE-AUTH-BYPASS
  - S-PG-DELTA-DOC-RESYNC-1
  - S-PG-VERBATIM-PIN-1
drift_items:
  - FILTER-SOURCE-ENUMERATION-NO-MECHANICAL-ENFORCEMENT
files_created:
  - "tests/filter_source_enumeration_sync.rs"  # CREATE — guard test enumerating filter sources and cross-checking against NO_FILTERS_SPECIFIED_MSG
files_modified:
  - "src/cli/mod.rs"            # POSSIBLE MODIFY — NO_FILTERS_SPECIFIED_MSG lives here (~line 66); may need a shared, testable source-of-truth list extracted (implementer's design call, see Tasks)
  - "src/cli/issue/list.rs"     # POSSIBLE MODIFY — build_filter_clauses / FilterOptions is the enumeration this guard cross-checks against
---

# S-PG-FILTER-ENUM-SYNC-1 — Mechanical Guard: Filter-Source Enumeration <-> `build_filter_clauses` Sync

## Source of Truth

`.factory/phase-f7-delta-convergence/list-read-ergonomics/delta-convergence-report.md` §4
Keep-Deferred Disposition (S-7.02), row `FILTER-SOURCE-ENUMERATION-NO-MECHANICAL-ENFORCEMENT`
(process-gap, **pre-existing** — predates the list-read-ergonomics cycle). Verbatim description:
"No mechanical (CI-enforced) check that `NO_FILTERS_SPECIFIED_MSG`'s 15-source enumeration
(`src/cli/mod.rs:66`) stays in sync with `build_filter_clauses`'s actual filter sources —
currently relies on human/adversarial-review discipline each time a filter source is added (as
happened for `--component` in #606 and `--updated-recent` in this cycle)." Recommended
disposition: "Open a self-improvement follow-up story (e.g. a `tests/` guard that enumerates
`FilterOptions` fields and cross-checks against the message string) — low effort, closes a
recurring review burden. Not blocking this cycle's merge since both cycle-relevant enumerations
(`--component`, `--updated-recent`) were manually verified correct."

## Scope Note (divergence from the 8 SELF-IMPROVEMENT sibling stories)

The 8 prior SELF-IMPROVEMENT-epic stories (and their precedent, `S-PG-MERGE-AUTH-BYPASS`) all
target Dark Factory **engine** files (`[engine]/skills/...`, `[engine]/agents/...`) — the
process gaps they close live in the pipeline's own workflow definitions. This story is
different: the process gap it closes (a human-facing message string drifting out of sync with
the code it enumerates) lives entirely inside the **jira-cli product repo**, and the fix is a
mechanical CI guard added to *this* repo's own `tests/` suite — closer in shape to the
`DEAD-CITATION-CI` precedent (also epic-adjacent self-improvement, also a guard added to this
repo's own CI) than to the 8 engine-workflow stories. `scope: standard` (not
`dark-factory-engine`) reflects this. It remains anchored to the `SELF-IMPROVEMENT` epic per
the human's explicit direction, since the underlying gap is the same shape as its siblings: a
downstream artifact (here, a user-facing error message) silently outliving the upstream source
of truth it was derived from, currently caught only by review discipline.

## Behavioral Contracts

No BCs have been authored yet. Status must remain `draft` until a product-owner authors
BC-S.SS.NNN contracts for this story (S-7.01 gate). When BCs are authored they should cover:

- **Precondition:** a filter source is added to, removed from, or renamed in
  `build_filter_clauses` (or the `FilterOptions` struct it consumes) in `src/cli/issue/list.rs`.
- **Postcondition:** if `NO_FILTERS_SPECIFIED_MSG`'s enumeration in `src/cli/mod.rs` no longer
  lists the same set of filter sources as `build_filter_clauses` actually emits, the guard test
  fails at `cargo test` time, naming the specific mismatch (source added but not documented in
  the message, or vice versa).
- **Invariant:** the guard never edits the message string or the filter-clause code itself — it
  only detects and reports drift; a human resolves the mismatch.

## Narrative

As the jira-cli CI test suite, I want a mechanical guard that fails when
`NO_FILTERS_SPECIFIED_MSG`'s filter-source enumeration falls out of sync with what
`build_filter_clauses` actually implements, so that adding, removing, or renaming a filter
source (as happened for `--component` in #606 and `--updated-recent` in the list-read-ergonomics
cycle) can no longer silently produce a stale help/error message — closing a recurring review
burden that has already required manual verification twice in this repo's history.

## Problem Statement

`src/cli/mod.rs`'s `NO_FILTERS_SPECIFIED_MSG` constant enumerates the (currently 15) filter
sources `jr issue list` recognizes, shown to the user when no filter is specified. Nothing
mechanically ties this string to `build_filter_clauses`'s actual match arms in
`src/cli/issue/list.rs` — the two must be kept in sync by hand every time a filter source is
added or removed. This has already happened twice: `--component` (issue #606) and
`--updated-recent` (this cycle, BC-2.1.006/BC-2.1.007 amendments). Both times the sync was
verified manually during adversarial review, which worked, but is not guaranteed to keep
working — a future addition under review-fatigue conditions, or made outside the standard VSDD
pipeline review gates, could land with a stale message and go undetected. A `tests/` guard makes
this a compile/test-time failure instead of a review-discipline dependency.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~2,600 |
| F7 list-read-ergonomics delta-convergence report §4 (relevant row) | ~900 |
| `src/cli/mod.rs` (NO_FILTERS_SPECIFIED_MSG + surrounding context) | ~1,200 |
| `src/cli/issue/list.rs` (`build_filter_clauses` + `FilterOptions`) | ~4,000 |
| **Total** | **~8,700** |

Well within budget. No split required.

## Previous Story Intelligence

No prior story in this repo has built a source-text-vs-message-string sync guard specifically.
The closest analogues are `S-PG-VERBATIM-PIN-1` (verbatim-pin test convention for BC-specified
exact strings — same "downstream artifact silently drifts from upstream source of truth" shape,
applied to test assertions instead of a CLI message) and `tests/claude_md_citations.rs`
(CLAUDE.md dead-citation CI guard — a working, in-repo precedent for a mechanical text-drift
guard riding the existing `test` CI job with no new CI YAML required). The implementer should
read `tests/claude_md_citations.rs` first as a structural template: it demonstrates the
`include_str!` + parse + assert pattern this guard is expected to follow, and confirms this
class of guard can ride the existing `cargo test` job without new CI wiring.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Flag, never auto-fix | Behavioral Contracts invariant | The guard fails the test and names the mismatch; it does not rewrite `NO_FILTERS_SPECIFIED_MSG` or `build_filter_clauses`. Mirrors the same rule in every SELF-IMPROVEMENT sibling story. |
| No new CI YAML | Previous Story Intelligence | Follow the `tests/claude_md_citations.rs` / `tests/mutants_glob_existence.rs` precedent — an always-run `#[test]` fn riding the existing `test` CI job, not a new `ci.yml` job. |
| No product behavior change | Scope boundary | This story adds a test-time guard only. `NO_FILTERS_SPECIFIED_MSG`'s text and `build_filter_clauses`'s logic must be byte-for-byte/behaviorally unchanged unless the guard's own initial run surfaces a real, pre-existing mismatch (none is currently known — both cycle-relevant enumerations were manually verified correct per the F7 report). |
| Source of truth is the code, not the message | Problem Statement | The enumeration in `build_filter_clauses` (or a shared const/array extracted from it, if the implementer chooses that design) is authoritative; the guard checks the message against the code, not the reverse. |

## Library & Framework Requirements

No new dependencies. Plain `#[test]` fn using `include_str!` and/or existing parsing helpers
already used by `tests/claude_md_citations.rs` and `tests/mutants_glob_existence.rs` — no new
crate required.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `tests/filter_source_enumeration_sync.rs` | CREATE | Guard test: extracts the filter-source list from both `NO_FILTERS_SPECIFIED_MSG` and `build_filter_clauses`/`FilterOptions`, asserts set-equality, fails naming any one-sided mismatch. |
| `src/cli/mod.rs` | POSSIBLE MODIFY | Only if the implementer's chosen design extracts a shared, testable filter-source list (e.g. a `const FILTER_SOURCES: &[&str]`) rather than parsing the message string directly — implementer's call, see Tasks. |
| `src/cli/issue/list.rs` | POSSIBLE MODIFY | Same as above — only if a shared source-of-truth extraction is the chosen design. |

## Acceptance Criteria

### AC-001 — Guard enumerates both sides of the sync

A test extracts (a) the set of filter-source names implied by `NO_FILTERS_SPECIFIED_MSG` and
(b) the set of filter sources `build_filter_clauses`/`FilterOptions` actually implements.
(traces to drift item FILTER-SOURCE-ENUMERATION-NO-MECHANICAL-ENFORCEMENT — pending BC
authorship)

### AC-002 — Guard fails loudly on a one-sided mismatch

A fixture (temporarily adding a filter source to one side only, in a scratch/test-only context,
not committed to `src/`) proves the guard test fails and names the specific mismatched source.
(traces to drift item FILTER-SOURCE-ENUMERATION-NO-MECHANICAL-ENFORCEMENT — pending BC
authorship)

### AC-003 — Guard passes against the current (correct) state

Run against the current `src/cli/mod.rs` / `src/cli/issue/list.rs` (both enumerations already
manually verified correct per the F7 report), the guard passes with zero findings, confirming it
is not a false-positive-prone check. (traces to drift item
FILTER-SOURCE-ENUMERATION-NO-MECHANICAL-ENFORCEMENT — pending BC authorship)

### AC-004 — Guard rides the existing CI `test` job, no new CI YAML

The guard is an always-run `#[test]` fn requiring no `ci.yml` changes, consistent with the
`tests/claude_md_citations.rs` precedent. (traces to drift item
FILTER-SOURCE-ENUMERATION-NO-MECHANICAL-ENFORCEMENT — pending BC authorship)

## Tasks

1. Read `tests/claude_md_citations.rs` and `tests/mutants_glob_existence.rs` as structural
   templates (Previous Story Intelligence).
2. Design the extraction mechanism for both sides of the comparison — either (a) parse
   `NO_FILTERS_SPECIFIED_MSG`'s string content directly plus `build_filter_clauses`'s source
   text via `include_str!`, or (b) refactor to a shared, testable const/array both the message
   and the clause-building logic derive from. Document the chosen approach and rationale
   (implementer's judgment call — left open by design, per this story's draft status).
3. Build and fixture-test the guard (AC-001, AC-002, AC-003).
4. Confirm the guard passes against current `HEAD` with zero findings (AC-003) and requires no
   CI YAML change (AC-004).

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|--------------------|
| EC-001 | A filter source's *name* in the message differs cosmetically from its internal identifier (e.g. `--updated-recent` flag vs. an internal `updated_recent` field name) | The guard's matching should tolerate a documented, stable naming convention between the two representations rather than demanding literal string identity — implementer documents the mapping rule used. |
| EC-002 | A filter source is intentionally internal/undocumented (not meant to appear in the user-facing message) | Out of scope unless such a case currently exists — as of this story's authoring, all 15 enumerated sources are user-facing; if a future internal-only source is added, it should be explicitly excluded from the guard's expected set with a comment, not silently ignored. |
| EC-003 | The guard's own fixture (AC-002) accidentally leaks a real, uncommitted mismatch into `src/` | Fixture must be constructed as an in-test scratch value (e.g. a local string literal), never by editing `src/cli/mod.rs` or `src/cli/issue/list.rs` as part of the test. |

## Dependency Analysis

**depends_on: []** — standalone; does not require any other story to land first.

**blocks: []** — no story currently declares a dependency on this one.

## Out of Scope

- Retroactively re-verifying the two already-manually-verified enumerations (`--component`,
  `--updated-recent`) beyond confirming the new guard passes against them (AC-003) — no defect
  is expected or being chased here.
- Extending the guard to any other message-string-vs-code-enumeration pair in this repo (e.g.
  `jr project fields`, `jr requesttype fields`) — scoped to `NO_FILTERS_SPECIFIED_MSG` /
  `build_filter_clauses` only, per the originating drift item.
- Any `ci.yml` workflow change.

## Story Points and Effort

**3 story points (small, per the F7 disposition's "low effort" characterization).** Breakdown:
template review + design decision (1 SP), guard implementation + fixtures (1.5 SP), CI/no-new-YAML
confirmation + doc fallout (0.5 SP). **Priority P2.**
