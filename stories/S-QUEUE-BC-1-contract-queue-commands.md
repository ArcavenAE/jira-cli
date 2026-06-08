---
document_type: story
story_id: "S-QUEUE-BC-1"
title: "Author document-as-is behavioral contracts for jr queue list / queue view (section X.8)"
wave: feature-followup
status: converged-merge-pending
intent: documentation
feature_type: spec
scope: small
severity: small
trivial_scope: false
issue: TBD
points: 2
priority: P3
tdd_mode: strict
estimated_effort: small
mode: feature
depends_on: []
blocks: []
bc_anchors:
  - BC-X.8.008
  - BC-X.8.009
bcs:
  - BC-X.8.008
  - BC-X.8.009
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: follow-up
spec_source: "docs/specs/jsm-e2e-coverage.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 4
assumption_validations: []
risk_mitigations: []
created: "2026-06-02"
last_updated: "2026-06-08"
traceability_note: >
  This story resolves the explicitly-logged traceability orphan in S-JSM-E2E-1 (AC-001
  and AC-003 — queue list / queue view E2E tests with no behavioral contract). It authors
  document-as-is BCs in the existing spec corpus section X.8 "Projects & Queues", in
  parity with how requesttype commands got BC-X.12.001-008. After BCs are authored and
  anchored, S-JSM-E2E-1 AC-001 and AC-003 can be re-anchored to the new BCs.
files_modified:
  - .factory/specs/prd/bc-x-cross-cutting.md       # ADD BC-X.8.008, BC-X.8.009 in section X.8
  - .factory/specs/prd/BC-INDEX.md                  # ADD BC-X.8.008, BC-X.8.009 rows + increment total_bcs
  - .factory/specs/prd/CANONICAL-COUNTS.md          # UPDATE bc-x-cross-cutting.md row + Sum/grand-total
  - .factory/stories/S-JSM-E2E-1-jsm-e2e-coverage-expansion.md  # RE-ANCHOR AC-001/003 to new BCs
  - .worktrees/S-JSM-E2E-1/docs/specs/jsm-e2e-coverage.md       # RE-ANCHOR §2.2, §5 Sc.1/3, §8 VER-JSM-E2E-1/3
  - docs/specs/jsm-e2e-coverage.md                              # SYNC root copy
breaking_change: false
changelog:
  - date: "2026-06-02"
    phase: follow-up
    author: story-writer
    summary: >
      Follow-up story created to resolve S-JSM-E2E-1 queue-BC orphan (AC-001 / AC-003).
      Queue commands shipped without behavioral contracts — this story authors them
      document-as-is. Status: draft (BC authorship required before ready transition).
---

# S-QUEUE-BC-1 — Author Document-As-Is Behavioral Contracts for `jr queue list` / `jr queue view`

## Source of Truth

This story resolves the explicitly-logged traceability orphan identified in:
- Story S-JSM-E2E-1 AC-001 and AC-003 (queue E2E tests with no behavioral contract anchor)
- Research doc: `.factory/research/jsm-e2e-queue-bc-anchoring-validation.md`
- Feature spec: `docs/specs/jsm-e2e-coverage.md §2.2` (orphan note)

## Context and Motivation

`jr queue list` and `jr queue view` shipped in an earlier delivery cycle (issue-288-pr2-cli,
PR #380) as part of JSM support. Unlike the `requesttype` commands, which received explicit
behavioral contracts (BC-X.12.001–008), the queue commands shipped with no BCs. This gap
was surfaced during S-JSM-E2E-1 when the live E2E tests for queue commands could not be
correctly anchored to any behavioral contract.

The research validation (`jsm-e2e-queue-bc-anchoring-validation.md`) concluded:

1. Reusing BC-X.12.001 (a `requesttype` contract) for queue behavior is a "false coverage"
   anti-pattern (traceability pollution) — rejected (Option C).
2. The correct resolution is: author document-as-is BCs for queue commands in a dedicated
   follow-up, then re-anchor the S-JSM-E2E-1 queue tests. This story is that follow-up.
3. The queue behavior has not changed; this is brownfield spec formalization — no src/ change.

## Story Narrative

As a jr maintainer,
I want document-as-is behavioral contracts for `jr queue list` and `jr queue view` in the
existing BC corpus section X.8 "Projects & Queues",
so that the live E2E tests for these commands in S-JSM-E2E-1 (AC-001, AC-003) have correct,
semantically-valid BC anchors — closing the explicitly-logged traceability orphan — in parity
with how `requesttype` commands have BC-X.12.001-008.

## Acceptance Criteria

### AC-001 — BC-X.8.008: `jr queue list` output shape and exit behavior
Author BC-X.8.008 in `.factory/specs/prd/bc-x-cross-cutting.md` section X.8, documenting
the as-is behavior of `jr queue list`:
- Exit 0 on success; JSON array output via `--output json`
- Each item in the array has `"id"` (non-null) and `"name"` (non-null, non-empty string) fields
- Requires a JSM service desk project (re-uses `require_service_desk` guard, covered by BC-X.8.004)
- Implementation: `src/cli/queue.rs::handle_list` + `src/api/jsm/queues.rs`

### AC-002 — BC-X.8.009: `jr queue view` output shape and routing branches
Author BC-X.8.009 in `.factory/specs/prd/bc-x-cross-cutting.md` section X.8, documenting
the as-is behavior of `jr queue view`:
- By-name path: resolves queue by name substring via `partial_match`; exits 64 on ambiguity
- By-id path: `--id <numeric_id>` bypasses name resolution
- Output (both paths): JSON array of issue objects (`"key"` + `"fields"` per element) via `--output json`
- Empty array is a valid success state (queue exists but has zero issues)
- Requires a JSM service desk project
- Implementation: `src/cli/queue.rs::handle_view`

### AC-003 — BC-INDEX.md and CANONICAL-COUNTS.md updated
After authoring BC-X.8.008 and BC-X.8.009:
- BC-INDEX.md has two new rows for BC-X.8.008 and BC-X.8.009 in section X.8
- `total_bcs` frontmatter in BC-INDEX.md and CANONICAL-COUNTS.md grand-total are incremented by 2
- `bash scripts/check-bc-cumulative-counts.sh` exits 0

### AC-004 — S-JSM-E2E-1 re-anchored
After BCs are authored:
- S-JSM-E2E-1 `bc_anchors` / `bcs` frontmatter updated to include BC-X.8.008 and BC-X.8.009
- AC-001 and AC-003 in S-JSM-E2E-1 updated from "un-contracted orphan" trace to
  `(traces to BC-X.8.008)` and `(traces to BC-X.8.009)` respectively
- `docs/specs/jsm-e2e-coverage.md` §2.2 orphan note updated to note resolution
- Root spec copy synced from worktree

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|---------------|
| queue list output shape | `src/cli/queue.rs::handle_list` | Effectful (HTTP + stdout) |
| queue view routing | `src/cli/queue.rs::handle_view` | Effectful (HTTP + stdout) |
| queue API calls | `src/api/jsm/queues.rs` | Effectful (HTTP) |
| JSM guard | `src/api/jsm/servicedesks.rs::require_service_desk` | Effectful (HTTP) |

Zero `src/` changes. This is a spec/documentation-only story.

## Behavioral Contracts to Author

The BCs do not yet exist — they will be authored in this story. Proposed IDs:

| Proposed BC ID | Command | Section |
|---------------|---------|---------|
| BC-X.8.008 | `jr queue list` — output shape + exit behavior | X.8 Projects & Queues |
| BC-X.8.009 | `jr queue view` — output shape + routing branches (name vs --id) | X.8 Projects & Queues |

These IDs must be verified against the next available slot in section X.8 at the time of
authorship — consult `.factory/specs/prd/BC-INDEX.md` section X.8 for the current last BC
number and increment accordingly.

## Cross-References

- **Orphan source:** S-JSM-E2E-1 AC-001 (queue list), AC-003 (queue view)
- **Research justification:** `.factory/research/jsm-e2e-queue-bc-anchoring-validation.md`
- **Feature spec orphan note:** `docs/specs/jsm-e2e-coverage.md §2.2`
- **Requesttype parity model:** BC-X.12.001-008 in `.factory/specs/prd/bc-x-cross-cutting.md`
  section X.12 — same brownfield formalization pattern used for `requesttype` commands

## Implementation Strategy

**Spec-only, no src/ delta.** Order:

1. Read `.factory/specs/prd/bc-x-cross-cutting.md` section X.8 to establish the last BC
   number in that section and understand the existing BC format.
2. Read `src/cli/queue.rs` (handle_list, handle_view) and `src/api/jsm/queues.rs` to
   characterize the exact as-is behavior — no interpretation, document what the code does.
3. Author BC-X.8.008 (queue list) and BC-X.8.009 (queue view) in bc-x-cross-cutting.md.
4. Update BC-INDEX.md: add two rows; increment `total_bcs` by 2.
5. Update CANONICAL-COUNTS.md: increment bc-x-cross-cutting.md row count by 2; update Sum and grand-total.
6. Run `bash scripts/check-bc-cumulative-counts.sh` — must exit 0.
7. Run `bash scripts/check-spec-counts.sh` — must exit 0.
8. Re-anchor S-JSM-E2E-1 story file and feature spec (both copies).
9. Run `bash scripts/check-bc-no-numeric-test-counts.sh` — must exit 0.

## Out of Scope

- Any `src/` change (queue behavior is document-as-is; no bug fixes in scope)
- BC-X.8.008/009 edge cases beyond the documented as-is behavior (pagination, 403, etc.
  can be added as EC-NNN within each BC if the behavior is clearly implemented)
- New E2E tests (the existing S-JSM-E2E-1 tests cover this once re-anchored)
- Extending the queue command feature set

## Token Budget Estimate

| Item | Tokens (approx) |
|------|----------------|
| This story file | ~4 k |
| `bc-x-cross-cutting.md` section X.8 (read before editing) | ~3 k |
| `src/cli/queue.rs` (characterization read) | ~3 k |
| `src/api/jsm/queues.rs` (characterization read) | ~2 k |
| `BC-INDEX.md` section X.8 rows + total (read before editing) | ~2 k |
| `CANONICAL-COUNTS.md` (read before editing) | ~1 k |
| S-JSM-E2E-1 story file (re-anchoring edits) | ~2 k |
| Feature spec (re-anchoring edits) | ~2 k |
| Script outputs (3 check scripts) | ~1 k |
| **Total** | **~20 k** |

Well within a single-agent context window. No split required.

## Tasks

- [ ] Read `.factory/specs/prd/bc-x-cross-cutting.md` section X.8 — identify last BC number and existing format
- [ ] Read `src/cli/queue.rs` (handle_list, handle_view) and `src/api/jsm/queues.rs` — characterize as-is behavior
- [ ] Author BC-X.8.008 (`jr queue list`) in bc-x-cross-cutting.md section X.8
- [ ] Author BC-X.8.009 (`jr queue view`) in bc-x-cross-cutting.md section X.8
- [ ] Update BC-INDEX.md: add rows for BC-X.8.008 and BC-X.8.009; increment total_bcs by 2
- [ ] Update CANONICAL-COUNTS.md: increment bc-x-cross-cutting.md count by 2; update Sum + grand-total
- [ ] Run `bash scripts/check-bc-cumulative-counts.sh` — must exit 0
- [ ] Run `bash scripts/check-spec-counts.sh` — must exit 0
- [ ] Run `bash scripts/check-bc-no-numeric-test-counts.sh` — must exit 0
- [ ] Update S-JSM-E2E-1 story: add BC-X.8.008/009 to bc_anchors/bcs frontmatter; re-anchor AC-001/003 traces
- [ ] Update worktree feature spec `docs/specs/jsm-e2e-coverage.md` §2.2 orphan note + §5 Sc.1/3 + §8 VER-1/3
- [ ] Sync root spec copy from worktree
- [ ] Commit: `docs(spec): add BC-X.8.008/009 for jr queue list/view (closes S-QUEUE-BC-1 orphan)`

## Previous Story Intelligence

**Predecessor:** S-JSM-E2E-1 (this is a direct follow-up to close that story's orphan).

**Requesttype parity model:** BC-X.12.001-008 were authored in issue-288-pr2-cli
(PR #380). The format, section structure, and CANONICAL-COUNTS update pattern for
requesttype BCs is the exact template to follow for queue BCs.

**DRIFT-001/002 machinery:** After any edit to bc-*.md or BC-INDEX.md / CANONICAL-COUNTS.md,
run both check scripts. The scripts exit 1 with specific mismatch details if any of the
8 count surfaces disagree — this is the primary correctness gate for spec corpus edits.

## Architecture Compliance Rules

1. **Zero src/ changes.** This story is spec-only. If any `src/` file is in the diff, stop.
2. **Document as-is only.** BC postconditions must reflect actual current behavior of
   `src/cli/queue.rs` and `src/api/jsm/queues.rs` — not desired future behavior.
3. **All 8 count surfaces must agree after BC authorship** — run check-bc-cumulative-counts.sh.
4. **BC IDs must be sequential** — verify against BC-INDEX.md section X.8 before assigning IDs.

## Library & Framework Requirements

No new Cargo dependencies. Spec-only delivery.

## File Structure Requirements

| File | Action | Notes |
|------|--------|-------|
| `.factory/specs/prd/bc-x-cross-cutting.md` | MODIFY | Add BC-X.8.008 + BC-X.8.009 in section X.8 |
| `.factory/specs/prd/BC-INDEX.md` | MODIFY | Add 2 rows; increment total_bcs |
| `.factory/specs/prd/CANONICAL-COUNTS.md` | MODIFY | Increment bc-x-cross-cutting row; update Sum + grand-total |
| `.factory/stories/S-JSM-E2E-1-jsm-e2e-coverage-expansion.md` | MODIFY | Re-anchor AC-001/003 |
| `.worktrees/S-JSM-E2E-1/docs/specs/jsm-e2e-coverage.md` | MODIFY | Re-anchor §2.2/§5/§8 |
| `docs/specs/jsm-e2e-coverage.md` | MODIFY | Sync (cp from worktree) |
