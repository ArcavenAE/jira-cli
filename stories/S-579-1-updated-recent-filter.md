---
document_type: story
level: ops
epic_id: "none"
story_id: "S-579-1"
title: "--updated-recent <duration> on issue list"
wave: 1
feature_mode_bundle: list-read-ergonomics
status: ready
intent: feature
feature_type: backend
mode: feature
scope: standard
severity: N/A
trivial_scope: false
issue: 579
points: 3
priority: P2
tdd_mode: strict
estimated_effort: small
producer: story-writer
timestamp: "2026-08-21T00:00:00"
phase: 2
cycle: cycle-list-read-ergonomics
inputs:
  - ".factory/phase-f1-delta-analysis/list-read-ergonomics/delta-analysis.md"
  - ".factory/specs/prd/bc-2-issue-read.md"
traces_to: ".factory/specs/prd/bc-2-issue-read.md"
estimated_days: 1
target_module: src/cli/issue/list.rs
subsystems: ["SS-02"]
depends_on: []
blocks: []
behavioral_contracts:
  - "BC-2.1.023"
  - "BC-2.1.006"
  - "BC-2.1.007"
bcs:
  - "BC-2.1.023"
  - "BC-2.1.006"
  - "BC-2.1.007"
verification_properties: ["VP-UPDATED-RECENT-001", "VP-UPDATED-RECENT-002"]
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/bc-2-issue-read.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 8
assumption_validations: []
risk_mitigations: []
created: "2026-08-21"
version: "1.1"
last_updated: "2026-08-24"
breaking_change: false
retroactive: false
origin: >
  GitHub issue #579, bundle `list-read-ergonomics` (F1 delta-analysis Story S-3). Second
  story in the bundle's sequential Wave-1 delivery order (S-575-1 -> S-579-1 -> S-588-1).
  Small, mechanical mirror of the existing, well-tested `--recent` pattern (BC-2.1.008):
  one new clap flag, one new clause in `build_filter_clauses`, one stderr-string update
  (BC-2.1.006's filter-source enumeration 14->15). `--resolved-recent` is explicitly OUT OF
  SCOPE for this story per F1 Decision 3 (deferred: RESOLUTIONDATE has different NULL
  semantics than created/updated and needs its own design conversation). Delivery-process
  note: S-575-1, S-579-1, and S-588-1 are semantically independent but all three edit
  `src/cli/mod.rs`'s `IssueCommand::List` variant and/or `src/cli/issue/list.rs`'s
  `build_filter_clauses`/`FilterOptions`/`order_by` region — deliver SEQUENTIALLY (one
  worktree at a time), not in parallel worktrees, to avoid a 3-way merge conflict on the
  same struct/function.
files_modified:
  - src/cli/mod.rs
  - src/cli/issue/list.rs
test_files:
  - tests/issue_commands.rs
  - tests/all_flag_behavior.rs
  - tests/issue_list_errors.rs
input-hash: "11b8082"
---

> **tdd_mode:** `strict`.

# S-579-1: `jr issue list --updated-recent <duration>`

## Narrative

As a `jr` user tracking closure hygiene, I want `--updated-recent <duration>` to filter
issues by their `updated` timestamp (mirroring the existing `--recent` filter on `created`),
so that I can find recently-touched issues without hand-writing a raw `--jql` clause.

## Source of Truth

Read **BC-2.1.023** in `bc-2-issue-read.md` §2.1 in full, plus the **BC-2.1.006** and
**BC-2.1.007** amendments (both landed at F2 alongside BC-2.1.023 — read the amended text,
not the pre-amendment "Previous version" blocks retained for audit trail only). Also read
BC-2.1.008 (`--recent`, the direct structural template this story mirrors field-swapped).

**DEC-306 reconciliation (2026-08-24, read this before implementing):** BC-2.1.023's
Behavior clause and its Postcondition 4 / EC-2.1.023-4 were AMENDED on 2026-08-24 (F5 finding
ADV-LRE-F5-A-MED-001, human-adjudicated). Read the **AMENDED** text — not the "Previous
version (superseded 2026-08-24, retained for audit trail)" block beneath EC-2.1.023-4. The
amendment removes an implementer-level exit-64 guard that this story's Step-4.5 had
introduced for `--updated-recent` used ALONE; that guard was never ratified by DEC-298 and
directly contradicted BC-2.1.023's own "mirrors `--recent` exactly" claim. See the
Traceability Note at the end of this story for what changed in this file as a result.

## Behavioral Contracts

| BC ID | Title |
|-------|-------|
| BC-2.1.023 | `--updated-recent <duration>` -> `updated >= -{d}` clause, validated via `jql::validate_duration`, positioned immediately after `--recent`'s slot; AMENDED 2026-08-24 (DEC-306) so its Behavior clause and new Postcondition 4 make the pre-existing "mirrors `--recent` exactly" claim explicit for the no-scope/alone case too |
| BC-2.1.006 | AMENDED: filter-source enumeration 14 -> 15 (`--updated-recent` added as source #15, immediately before `or --jql`) |
| BC-2.1.007 | AMENDED: stable clause order gains `updated-recent` (immediately after `recent`, before `asset`) |

## Behavior Summary (verbatim per BC — do not deviate)

- **Reuse `jql::validate_duration`, NOT `duration.rs` (Behavior)**: `--updated-recent`
  reuses `src/jql.rs::validate_duration` — the SAME validator `--recent` uses. It is NOT
  `src/duration.rs` (that parser is worklog-duration syntax, `1h30m`/`2d 3h 30m`, a
  different grammar entirely — F1 delta-analysis §1.1 correction).
- **Clause shape (Postcondition 1)**: composes `updated >= -{d}` — the direct field-swapped
  analogue of `--recent`'s `created >= -{d}` template.
- **Pre-HTTP validation (Precondition 2)**: validated via `jql::validate_duration` BEFORE any
  HTTP call — combined units (e.g. `4w2d`) are rejected, identically to BC-2.1.008's
  validation discipline.
- **Stable-order position (Postcondition 2 / BC-2.1.007 amendment)**: this clause occupies
  the stable-order slot immediately AFTER `--recent`'s clause and BEFORE `--asset`'s clause.
  Pinned by `Vec<String>` positional equality — the same exact-clause-order test discipline
  as every other member of this list.
- **Free composition (Postcondition 3)**: composes freely (AND-joined via
  `build_filter_clauses`' existing `parts.join(" AND ")`) with `--recent`,
  `--created-after/before`, `--updated-after/before`, `--status`, `--component`, and every
  other filter — no new conflicts beyond `conflicts_with = "updated_after"` (see EC below).
- **Asymmetric `conflicts_with` (Edge Case EC-2.1.023-2, human-locked DEC-298)**:
  `--updated-recent`'s `conflicts_with` covers `--updated-after` ONLY — it does NOT conflict
  with `--updated-before`, deliberately mirroring the pre-existing, asymmetric `--recent`
  x `--created-after` pattern (`--recent` conflicts with `--created-after` but not
  `--created-before`). This is a pre-existing codebase inconsistency this story does NOT
  silently "fix" as a side effect.
- **Filter-source enumeration (BC-2.1.006 amendment)**: `--updated-recent` joins the
  enumerated filter-source list as source #15 (14 -> 15), appended immediately before
  `or --jql` — the same mechanical shape as the 2026-08-15 `--component` addition.
- **`--updated-recent` alone mirrors `--recent` exactly and PROCEEDS (Postcondition 4 /
  Edge Case EC-2.1.023-4, REWRITTEN 2026-08-24 by DEC-306)**: used with no `--project`, no
  configured default `project`/`board_id`, and no other filter, `--updated-recent` exits 0
  and composes `updated >= -{d} ORDER BY updated DESC` (or the board/sprint-aware order-by
  branch when a `board_id` IS configured — BC-2.1.004/BC-2.1.005), with NO project/board
  restriction clause — an unbounded cross-project query, exactly mirroring `--recent`-alone's
  behavior (BC-2.1.008). It independently satisfies BC-2.1.006's "at least one filter"
  requirement as filter source #15, exactly as `--recent` and the other 13 filter sources do
  when used alone. It does **not** fall through to BC-2.1.006's "no filters specified"
  exit-64 guard. **This corrects this story's original text**, which asserted the opposite
  (that `--updated-recent` alone tripped the exit-64 guard "exactly as every other filter
  source does") — that claim was factually backwards: every OTHER filter source used alone
  already proceeds; `--updated-recent` was the sole exception, via an implementer-level guard
  added at this story's own Step-4.5 that was never ratified by DEC-298. That guard is REMOVED
  by this reconciliation (implementer task, tracked under the same DEC-306). See the
  Traceability Note at the end of this story.

## Acceptance Criteria

### AC-001 (traces to BC-2.1.023 postcondition 1 — clause composition)
`jr issue list --updated-recent 60d` -> clause `updated >= -60d`.
**Test:** `test_bc_2_1_023_issue_list_updated_recent_composes_clause()`

### AC-002 (traces to BC-2.1.023 precondition 2 — pre-HTTP validation, shared validator)
`--updated-recent` validated via `jql::validate_duration` before any HTTP call — combined
units (`4w2d`) rejected pre-HTTP with the same error shape BC-2.1.008 pins for `--recent`.
**Test:** `test_bc_2_1_023_issue_list_updated_recent_rejects_combined_units_pre_http()`

### AC-003 (traces to BC-2.1.023 Edge Case EC-2.1.023-2 — asymmetric conflicts_with)
`--updated-recent` + `--updated-after` -> clap `conflicts_with` rejection (exit 2). Does NOT
conflict with `--updated-before` — deliberate asymmetry, not a bug.
**Test:** `test_bc_2_1_023_issue_list_updated_recent_conflicts_with_updated_after_only()`

### AC-004 (traces to BC-2.1.023 postcondition 3 / Edge Case EC-2.1.023-3 — free composition)
`--updated-recent 30d --recent 30d` composes both clauses AND-joined, `recent` before
`updated-recent`: `... AND created >= -30d AND updated >= -30d ...`. No error.
**Test:** `test_bc_2_1_023_issue_list_updated_recent_composes_freely_with_recent()`

### AC-005 (traces to BC-2.1.007 amendment — stable-order position)
`jr issue list --project FOO --recent 7d --updated-recent 60d --asset CUST-5` composes
clauses with `updated-recent` positioned immediately AFTER `recent` and BEFORE `asset` —
verified via `Vec<String>` positional equality (substring-index comparison insufficient).
**Test:** `test_bc_2_1_007_issue_list_updated_recent_clause_ordering_after_recent_before_asset()`

### AC-006 (traces to BC-2.1.006 amendment — filter-source enumeration 14->15)
`jr issue list` with no project, no filters, no `--jql` -> exit 64, stderr literal ends
`"... --updated-recent, or --jql. ..."` (15 sources, `--updated-recent` appended immediately
before `or --jql`).
**Test:** `test_bc_2_1_006_issue_list_no_filters_stderr_enumerates_15_sources()`

### AC-007 (traces to BC-2.1.023 postcondition 4 / Edge Case EC-2.1.023-4, REWRITTEN
2026-08-24 by DEC-306 — alone-case mirrors `--recent` and proceeds)
`jr issue list --updated-recent 60d` with no `--project`, no configured default
`project`/`board_id`, and no other filter -> exit 0. Exactly ONE
`POST /rest/api/3/search/jql` call is issued, the request body contains `updated >= -60d`
and NO `project = ` clause, and results are ordered `updated DESC` (or the board/sprint-aware
order-by branch when a `board_id` IS configured, per BC-2.1.004/BC-2.1.005). This
independently satisfies BC-2.1.006's "at least one filter" requirement as filter source #15 —
`--updated-recent` alone does NOT trip the "no filters specified" exit-64 guard, mirroring
`--recent`-alone's existing behavior exactly. Also exercises VP-UPDATED-RECENT-002.
**Test:** `test_bc_2_1_023_issue_list_updated_recent_alone_proceeds_like_recent()`

### AC-008 (traces to BC-2.1.023 postcondition 1 — field-swap fidelity)
`--updated-recent 7d` produces `updated >= -7d` (NOT `created >= -7d`) — confirms the field
name is correctly swapped from `--recent`'s template, not copy-pasted verbatim.
**Test:** `test_bc_2_1_023_issue_list_updated_recent_uses_updated_field_not_created()`

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `--updated-recent <duration>` CLI flag | `src/cli/mod.rs` (additive on `List` variant) | N/A (clap derive) |
| Clause composition (`build_filter_clauses` extension) | `src/cli/issue/list.rs` (additive) | Pure (string/JQL composition; validation is pure, no I/O) |

## Edge Cases

Covered by dedicated ACs: EC-2.1.023-1, EC-2.1.023-2, EC-2.1.023-3, EC-2.1.023-4.

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `cli/issue/list.rs::build_filter_clauses` (updated-recent extension) | Pure | String/JQL composition + `jql::validate_duration` call, no I/O |
| `jql.rs::validate_duration` (reused unchanged) | Pure | Existing validator, no change |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|--------------------|
| This story spec | ~5k |
| BC-2.1.023 body + BC-2.1.006/007 amendments (read in full) | ~4k |
| BC-2.1.008 (`--recent` structural template) | ~2k |
| `src/cli/issue/list.rs::build_filter_clauses` (existing window) | ~4k |
| `src/jql.rs::validate_duration` (existing window) | ~1k |
| Test files + fixtures | ~5k |
| Tool outputs | ~4k |
| **Total** | **~25k** |
| Agent context window | 200K |
| **Budget usage** | **~13%** |

## Tasks (MANDATORY)

1. [ ] Write failing test for `updated >= -{d}` clause composition
2. [ ] Write failing test for combined-unit rejection (pre-HTTP, shared validator)
3. [ ] Write failing test for asymmetric `conflicts_with` (`--updated-after` only)
4. [ ] Write failing test for free composition with `--recent` and clause ordering
5. [ ] Write failing test for BC-2.1.006's 15-source stderr enumeration
6. [ ] Write failing test for `--updated-recent` alone PROCEEDING (exit 0, mirrors `--recent`)
   with no `--project`/configured `project`/`board_id` and no other filter — DEC-306; do NOT
   implement a dedicated `--updated-recent`-alone exit-64 guard
7. [ ] Verify Red Gate
8. [ ] Add `updated_recent: Option<String>` field + `conflicts_with = "updated_after"` to `cli/mod.rs`
9. [ ] Wire validation + `FilterOptions` field + `build_filter_clauses` insertion in `list.rs`
10. [ ] Update BC-2.1.006's stderr string (14->15 sources)
11. [ ] Refactor; full suite green

## Previous Story Intelligence (MANDATORY)

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|----------------|------------------------|-----------------------|
| S-606-1 (`--component` filter) | Extended `build_filter_clauses`/`FilterOptions` with a new clause at a pinned stable-order position | `Vec<String>` positional equality (not substring/membership) is the test discipline for clause ordering — 20+ existing unit tests pin this | A careless insertion point shifts every downstream clause's index; insert `updated-recent` EXACTLY between `recent` and `asset`, matching BC-2.1.007's amended order |
| S-575-1 (bundle predecessor, same wave) | Edits a disjoint region of `list.rs` (field-list/output-gate logic, not `build_filter_clauses`) | This story and S-575-1 touch different regions of the same file — low logical conflict risk, but deliver sequentially per the bundle's delivery-process note | N/A |

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|--------------|
| Reuse `jql::validate_duration`; do NOT introduce a new parser or reuse `duration.rs` | BC-2.1.023 Behavior, F1 delta-analysis §1.1 correction | AC-002 |
| `updated-recent` clause MUST slot in immediately after `recent`, before `asset` | BC-2.1.007 amendment | AC-005 |
| `conflicts_with` covers `--updated-after` only — do NOT add `--updated-before` (pre-existing asymmetric pattern, not this story's to fix) | BC-2.1.023 Edge Case EC-2.1.023-2, human-locked DEC-298 | AC-003 |
| `--sort` is explicitly NOT part of this story's scope and NOT added to BC-2.1.006's enumeration | BC-2.1.006 amendment Note | N/A — cross-reference guard for S-588-1 |
| `--resolved-recent` is OUT OF SCOPE — do not implement | F1 delta-analysis Decision 3 | Code review; no `resolutiondate` clause introduced |
| Do NOT implement a dedicated `--updated-recent`-alone exit-64 guard — used alone it PROCEEDS (exit 0), mirroring `--recent`-alone exactly | BC-2.1.023 postcondition 4 / EC-2.1.023-4, REWRITTEN 2026-08-24 by DEC-306 | AC-007 |

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|----------|
| reqwest / serde (existing) | as in `Cargo.lock` | HTTP |
| wiremock (existing) | as in `Cargo.lock` | Integration tests |

No new crate dependencies.

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|----------|
| `src/cli/mod.rs` | MODIFY | New `updated_recent: Option<String>` field + `conflicts_with` on `IssueCommand::List` |
| `src/cli/issue/list.rs` | MODIFY | Validation, `FilterOptions` field, `build_filter_clauses` insertion, BC-2.1.006 stderr string update |
| `tests/issue_commands.rs`, `tests/all_flag_behavior.rs`, `tests/issue_list_errors.rs` | MODIFY | New test cases (8 ACs) |

**MUST NOT change**: `src/duration.rs` (the worklog-duration parser — NOT what this flag
uses); `src/cli/issue/edit.rs`/`src/cli/issue/create.rs` (unrelated); the already-established
clause order for `assignee`/`reporter`/`status`/`open`/`team`/`recent`/`asset`/`component`
(only `updated-recent`'s slot is new, between `recent` and `asset`); `--sort`'s region of
`list.rs` (S-588-1, separate story, separate delivery slot).

## Traceability Note — DEC-306 F5-Reconciliation Propagation (2026-08-24)

This story was updated (v1.0 -> v1.1) to propagate the DEC-306 human ruling (F5 finding
ADV-LRE-F5-A-MED-001) into the story body, after the product-owner amended
`.factory/specs/prd/bc-2-issue-read.md` (BC-2.1.023 Behavior + new Postcondition 4;
EC-2.1.023-4 rewritten; BC-2.1.006 gained a clarifying Note; new VP-UPDATED-RECENT-002).
This story's original v1.0 text was itself the source of the contradiction the reconciliation
fixes: its Step-4.5 delivery had introduced an implementer-level `--updated-recent`-alone
exit-64 guard that was never ratified by DEC-298 and directly contradicted this same story's
own "mirrors `--recent` exactly" framing.

Changes made in this pass (story-body/AC propagation only — no BC files edited):

- **Behavior Summary** — the `--updated-recent`-alone bullet was rewritten from "falls through
  to the no-filters-specified exit-64 guard exactly as every other filter source does" to
  "PROCEEDS (exit 0), mirrors `--recent`-alone exactly, does NOT trip the exit-64 guard."
- **AC-007** — re-pointed from asserting the alone-case requires project scope (exit-64) to
  asserting the alone-case PROCEEDS (exit 0, exactly one search call, `updated >= -60d` in the
  body, no `project =` clause, `updated DESC` ordering); now also traces to BC-2.1.023
  postcondition 4 and exercises VP-UPDATED-RECENT-002. Test name changed from
  `test_bc_2_1_023_issue_list_updated_recent_alone_still_requires_project_scope()` to
  `test_bc_2_1_023_issue_list_updated_recent_alone_proceeds_like_recent()`.
- **Task 6** — rewritten to specify writing a failing test for the PROCEED behavior, with an
  explicit "do NOT implement a dedicated alone-guard" note.
- **Architecture Compliance Rules** — added a row codifying "do NOT implement a dedicated
  `--updated-recent`-alone exit-64 guard," sourced to the amended BC-2.1.023
  postcondition 4 / EC-2.1.023-4.
- **Behavioral Contracts table** — BC-2.1.023 row annotated with the 2026-08-24 DEC-306
  amendment pointer.
- **Source of Truth** — added a pointer instructing implementers to read the AMENDED
  BC-2.1.023 text (not the superseded "Previous version" block under EC-2.1.023-4).
- **Frontmatter** — `verification_properties` gained `VP-UPDATED-RECENT-002` (this story now
  owns/traces it, alongside the pre-existing VP-UPDATED-RECENT-001); `version` bumped
  `1.0 -> 1.1`; `last_updated` set to `2026-08-24`.

Everything else in this story (AC-001 through AC-006, AC-008, the `conflicts_with` asymmetry
in AC-003, the stable-order ACs, Architecture Mapping, Purity Classification, Token Budget,
Previous Story Intelligence, Library & Framework Requirements, and File Structure
Requirements) is unchanged — none of it asserted or implied the exit-64-alone behavior, so
none of it was touched by this propagation.
