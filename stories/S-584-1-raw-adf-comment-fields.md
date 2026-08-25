---
document_type: story
level: ops
epic_id: "none"
story_id: "S-584-1"
title: "Preserve raw ADF for --fields comment"
wave: 1
feature_mode_bundle: list-read-ergonomics
status: ready
intent: feature
feature_type: backend
mode: feature
scope: standard
severity: N/A
trivial_scope: false
issue: 584
points: 2
priority: P4
tdd_mode: strict
estimated_effort: xsmall
producer: story-writer
timestamp: "2026-08-21T00:00:00"
phase: 2
cycle: cycle-list-read-ergonomics
inputs:
  - ".factory/phase-f1-delta-analysis/list-read-ergonomics/delta-analysis.md"
  - ".factory/specs/prd/bc-2-issue-read.md"
traces_to: ".factory/specs/prd/bc-2-issue-read.md"
estimated_days: 1
target_module: src/types/jira/issue.rs
subsystems: ["SS-02"]
depends_on: ["S-575-1"]
blocks: []
behavioral_contracts:
  - "BC-2.2.034"
  - "BC-2.3.042"
bcs:
  - "BC-2.2.034"
  - "BC-2.3.042"
verification_properties: ["VP-FIELDS-004", "VP-FIELDS-005"]
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/bc-2-issue-read.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 5
assumption_validations: []
risk_mitigations: []
created: "2026-08-21"
version: "1.2"
last_updated: "2026-08-24"
breaking_change: false
retroactive: false
origin: >
  GitHub issue #584, bundle `list-read-ergonomics` (F1 delta-analysis Story S-2). Wave-2
  story, blocks on S-575-1 merging first: needs `--fields` to exist to even reach the
  `comment` field, and needs S-575-1's REPLACE-vs-UNION request semantics settled first
  since that determines whether `comment` reaches the wire at all. Confirmatory, not
  implementation-heavy — `IssueFields.extra: HashMap<String, Value>` is `#[serde(flatten)]`
  and no code path calls `adf::adf_to_text` on `issue list`/`issue view`'s JSON output, so
  requesting `comment` via S-575-1's `--fields` mechanism already returns Jira's raw ADF
  untouched. No src/ *logic* changes anticipated unless S-575-1's implementation needs an
  `extra`-cleanup pass for some other field (unlikely per Decision 2 in the F1 delta
  analysis) — superseded in scope only by AC-005's mandated defensive code comment at the
  `--fields` wiring site in `list.rs`/`view.rs` (comment-only, not a logic change; see
  `files_modified`).
files_modified:
  - "src/cli/issue/list.rs"  # AC-005: defensive comment only, no logic change
  - "src/cli/issue/view.rs"  # AC-005: defensive comment only, no logic change
test_files:
  - tests/issue_commands.rs
input-hash: "11b8082"
---

> **tdd_mode:** `strict`.

# S-584-1: Preserve raw ADF for `--fields comment`

## Narrative

As a `jr` user who requests `comment` via `--fields`, I want the raw ADF comment body
returned untouched (not flattened to plain text), so that I can round-trip or programmatically
process comment content without lossy conversion, and so that this new read path never
silently regresses the existing `issue comments` command's plain-text rendering.

## Source of Truth

Read **BC-2.2.034** and **BC-2.3.042** in `bc-2-issue-read.md` §2.2/§2.3 in full. Also read
BC-2.2.033/BC-2.3.041 (S-575-1 — the `--fields` REPLACE-semantics mechanism this story is
confirmatory of) before implementing.

## Behavioral Contracts

| BC ID | Title |
|-------|-------|
| BC-2.2.034 | `issue list --fields comment --output json` returns `.fields.comment.comments[].body` as raw ADF via the pre-existing `extra` flatten — zero incremental transformation code |
| BC-2.3.042 | `issue view --fields comment --output json` returns `.fields.comment.comments[].body` as raw ADF via `IssueFields.extra` — same mechanism as BC-2.2.034 |

## Behavior Summary (verbatim per BC — do not deviate)

- **Zero incremental transformation code (BC-2.2.034 Postcondition 3 / BC-2.3.042
  Postcondition 3)**: this is an INVARIANT-style BC — it documents a guarantee about an
  EXISTING code path (BC-2.2.033's `extra` flatten), not new transformation logic. `comment`
  is not a named field on `IssueFields`; requesting it via `--fields` routes Jira's response
  through `IssueFields.extra` (`#[serde(flatten)]`, untyped `serde_json::Value`), which
  performs NO transformation. Jira's wire response for `fields.comment.comments[].body` is
  ALREADY raw ADF — `extra` passes it through byte-for-byte.
- **Independence from `issue comments` (BC-2.2.034 Postcondition 2 / BC-2.3.042
  Postcondition 2)**: the pre-existing `issue comments <KEY>` command
  (`src/cli/issue/comments.rs`), which DOES flatten comment bodies via `adf_to_text`, is
  UNAFFECTED — the two code paths remain fully independent. No call site of
  `adf::adf_to_text` (used by `comments.rs`, `interactions.rs`, and `view.rs`'s table-mode
  description row) runs on `issue list`/`issue view --output json`'s output path.
- **Defensive comment obligation (BC-2.2.034 Edge Case EC-2.2.034-3)**: a future
  maintainer's attempt to "helpfully" post-process `extra` for consistency with `issue
  comments`'s flattened rendering is explicitly OUT OF SCOPE and would violate Postcondition
  1 — this story adds a defensive code comment at the `--fields` wiring site (S-575-1's
  `list.rs`/`view.rs` changes) warning against this.

## Acceptance Criteria

### AC-001 (traces to BC-2.2.034 postcondition 1 — raw ADF, list)
`jr issue list --jql "..." --fields "summary,comment" --output json` returns
`.fields.comment.comments[].body` as a raw ADF object (`{"type":"doc","version":1,
"content":[...]}`), never a flattened plain-text string. Wiremock fixture with a
non-trivial ADF comment body asserts deep-equality with the fixture's raw ADF object.
**Test:** `test_bc_2_2_034_issue_list_fields_comment_returns_raw_adf()`

### AC-002 (traces to BC-2.3.042 postcondition 1 — raw ADF, view)
`jr issue view <KEY> --fields "summary,comment" --output json` returns
`.fields.comment.comments[].body` as the same raw ADF object, via the same fixture.
**Test:** `test_bc_2_3_042_issue_view_fields_comment_returns_raw_adf()`

### AC-003 (traces to BC-2.2.034 postcondition 2 — issue comments unaffected)
`jr issue comments <KEY>` run against the SAME fixture issue still renders plain text via
`adf_to_text`, confirming the two paths do not regress each other.
**Test:** `test_bc_2_2_034_issue_comments_command_unaffected_by_fields_comment_path()`

### AC-004 (traces to BC-2.3.042 Edge Case EC-2.3.042-2 — view table mode unaffected)
`issue view`'s table-mode description row (the one existing `adf_to_text` call site inside
`view.rs::handle_view`) is unaffected — `--fields` is JSON-only (BC-2.3.041 Precondition 2),
so this table-mode code path is never reached when `--fields comment` is combined with JSON
output.
**Test:** `test_bc_2_3_042_view_table_mode_description_render_unaffected()`

### AC-005 (traces to BC-2.2.034 Edge Case EC-2.2.034-3 — defensive comment obligation)
A code comment exists at the S-575-1 `--fields` wiring site in `list.rs`/`view.rs` warning
future maintainers not to post-process `extra` for consistency with `issue comments`'s
flattened rendering.
**Test:** structural/code-review check (grep for the comment at the wiring site); no
dedicated test function — verified via `git grep` in CI review, not `cargo test`.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `IssueFields.extra` flatten (pre-existing, no change) | `src/types/jira/issue.rs` | N/A (serde derive) |
| Confirmatory tests + fixture | `tests/issue_commands.rs` | N/A (test-only) |

## Edge Cases

Covered by dedicated ACs: EC-2.2.034-1, EC-2.2.034-2, EC-2.2.034-3, EC-2.3.042-1, EC-2.3.042-2.

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `types/jira/issue.rs::IssueFields.extra` (unchanged) | Pure (data passthrough) | `#[serde(flatten)]` untyped catch-all, no transformation |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|--------------------|
| This story spec | ~4k |
| BC-2.2.034/BC-2.3.042 bodies (read in full) | ~4k |
| BC-2.2.033/BC-2.3.041 (S-575-1 mechanism context) | ~3k |
| `src/types/jira/issue.rs`, 4 `adf_to_text` call sites (existing windows) | ~4k |
| Test files + fixtures | ~5k |
| Tool outputs | ~3k |
| **Total** | **~23k** |
| Agent context window | 200K |
| **Budget usage** | **~12%** |

## Tasks (MANDATORY)

1. [ ] Write failing test: `--fields comment --output json` on `issue list` returns raw ADF
2. [ ] Write failing test: same, on `issue view`
3. [ ] Write failing test: `issue comments <KEY>` unaffected (negative regression test)
4. [ ] Write failing test: view table-mode description row unaffected
5. [ ] Verify Red Gate
6. [ ] Add wiremock fixture with a non-trivial ADF comment body
7. [ ] Add the defensive code comment at the `--fields` wiring site (list.rs/view.rs, from S-575-1)
8. [ ] Refactor; full suite green — confirm zero `src/` logic changes beyond the comment

## Previous Story Intelligence (MANDATORY)

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|----------------|------------------------|-----------------------|
| S-575-1 | `--fields` REPLACE semantics; new `get_issue_with_fields`/`search_issues_with_fields`-shaped client methods | `IssueFields.extra` is the flatten catch-all any unnamed `--fields` request lands in | This story's `comment` request MUST route through S-575-1's mechanism unmodified — do NOT add `comment`-specific transformation code; the whole point of this story is that zero incremental code is needed |

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|--------------|
| No new ADF transformation code — `extra` passthrough only | BC-2.2.034 Postcondition 3 | AC-001, AC-002 |
| `issue comments <KEY>`'s `adf_to_text` rendering MUST NOT be touched | BC-2.2.034 Postcondition 2 | AC-003 |
| `view.rs`'s table-mode `adf_to_text` call site MUST NOT be touched | BC-2.3.042 Edge Case EC-2.3.042-2 | AC-004 |
| Defensive comment required at the `--fields` wiring site, not new logic | BC-2.2.034 Edge Case EC-2.2.034-3 | AC-005 |

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|----------|
| wiremock (existing) | as in `Cargo.lock` | Integration test fixture |
| serde_json (existing) | as in `Cargo.lock` | Raw ADF deep-equality assertion |

No new crate dependencies.

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|----------|
| `tests/issue_commands.rs` | MODIFY | New fixture + confirmatory/negative tests (AC-001 through AC-004) |
| `src/cli/issue/list.rs`, `src/cli/issue/view.rs` (S-575-1 wiring sites) | MODIFY (comment only) | Defensive code comment; no logic change |

**MUST NOT change**: `src/adf.rs` (no new ADF logic needed); `src/cli/issue/comments.rs`,
`src/cli/issue/interactions.rs` (the two OTHER `adf_to_text` call sites, unrelated to this
story); `src/types/jira/issue.rs` (the `extra` field itself is unchanged — this story only
confirms its existing behavior).

**Traceability note (adjudicated, Step-4.5 pass 1, ADV-S584-P1-LOW-001):** the original
decomposition also listed `tests/all_flag_behavior.rs` as a MODIFY target for a
cross-check against the existing `--fields` flag-behavior suite. A fresh-context
adversarial review confirmed the delivered suite — all 4 confirmatory tests
(AC-001–AC-004) plus the wiremock fixture, entirely in `tests/issue_commands.rs` — has
COMPLETE coverage mapping to every postcondition and edge case of BC-2.2.034 and
BC-2.3.042; no AC, BC, or VP referenced an `all_flag_behavior.rs` assertion, making that
entry redundant rather than a gap. The orchestrator adjudicated this as
aspirational/redundant and corrected the story rather than adding a redundant test —
same pattern as drift item S-579-1-TEST-FILES-FRONTMATTER-STALE (frontmatter over-listed
test files) recorded earlier in this cycle. `tests/all_flag_behavior.rs` is removed from
this story's file inventory; no `src/` or test coverage changed as a result of this
correction.
