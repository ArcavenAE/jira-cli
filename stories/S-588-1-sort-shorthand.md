---
document_type: story
level: ops
epic_id: "none"
story_id: "S-588-1"
title: "--sort <field>:asc|desc shorthand on issue list"
wave: 1
feature_mode_bundle: list-read-ergonomics
status: ready
intent: feature
feature_type: backend
mode: feature
scope: standard
severity: N/A
trivial_scope: false
issue: 588
points: 5
priority: P5
tdd_mode: strict
estimated_effort: medium
producer: story-writer
timestamp: "2026-08-21T00:00:00"
phase: 2
cycle: cycle-list-read-ergonomics
inputs:
  - ".factory/phase-f1-delta-analysis/list-read-ergonomics/delta-analysis.md"
  - ".factory/specs/prd/bc-2-issue-read.md"
traces_to: ".factory/specs/prd/bc-2-issue-read.md"
estimated_days: 2
target_module: src/cli/issue/list.rs
subsystems: ["SS-02"]
depends_on: []
blocks: []
behavioral_contracts:
  - "BC-2.1.024"
  - "BC-2.1.025"
bcs:
  - "BC-2.1.024"
  - "BC-2.1.025"
verification_properties: ["VP-SORT-001"]
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/bc-2-issue-read.md"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 10
assumption_validations: []
risk_mitigations: []
created: "2026-08-21"
version: "1.0"
last_updated: "2026-08-21"
breaking_change: false
retroactive: false
origin: >
  GitHub issue #588, bundle `list-read-ergonomics` (F1 delta-analysis Story S-4). Third and
  final story in the bundle's sequential Wave-1 delivery order (S-575-1 -> S-579-1 ->
  S-588-1). Touches all 4 `order_by`-producing branches in `src/cli/issue/list.rs` (--jql,
  scrum-active-sprint, kanban, default-project); new parse/validate helper; secondary-sort
  interaction logic (`, key ASC` unless the field is `key`). Zero effect on default
  (absent-flag) behavior in every branch — protects BC-2.1.002/003/004/005's pinned exact
  JQL literals. Delivery-process note: this story and S-575-1/S-579-1 are semantically
  independent but all three edit the same `list.rs` hot region — deliver SEQUENTIALLY, not
  in parallel worktrees.
files_modified:
  - src/cli/mod.rs
  - src/cli/issue/list.rs
  - src/api/jira/issues.rs
test_files:
  - tests/issue_commands.rs
  - tests/all_flag_behavior.rs
  - tests/issue_list_errors.rs
input-hash: "c02d8a6"
---

> **tdd_mode:** `strict`.

# S-588-1: `jr issue list --sort <field>:asc|desc`

## Narrative

As a `jr` user who needs a specific result ordering, I want `--sort <field>:<direction>` on
`jr issue list` so that I can control JQL `ORDER BY` without hand-writing `--jql`, and so
that pagination stays stable via an automatic `key ASC` secondary sort (closing the
JRACLOUD-95368 advisory gap for this opt-in path).

## Source of Truth

Read **BC-2.1.024** and **BC-2.1.025** in `bc-2-issue-read.md` §2.1 in full. Also read
BC-2.1.002/003/004/005 (the 4 branches' pinned default `order_by` literals this story's
override must leave byte-for-byte unchanged when `--sort` is absent) and BC-2.1.006 (confirms
`--sort` is deliberately NOT a filter source — do not add it to that enumeration).

## Behavioral Contracts

| BC ID | Title |
|-------|-------|
| BC-2.1.024 | `--sort <field>:asc\|desc` syntax parse/validate: case-insensitive direction, exit 64 on malformed input, pre-HTTP, no field-name allowlist |
| BC-2.1.025 | `--sort` overrides `order_by` uniformly in all 4 composition branches; appends `, key ASC` secondary stable sort unless the field is `key`; field name passed through to Jira unvalidated |

## Behavior Summary (verbatim per BC — do not deviate)

- **Syntax-only local validation (BC-2.1.024 Behavior)**: split on the FIRST `:` into a field
  segment and a direction segment; direction matched case-insensitively against `asc`/`desc`.
  No local field-name allowlist — see BC-2.1.025 for the pass-through rationale.
- **Malformed-input error shape (BC-2.1.024 Postcondition 2)**: missing `:`, empty field
  segment, empty direction segment, or a direction segment that is not `asc`/`desc`
  case-insensitively (including a second embedded `:`) -> `JrError::UserError` exit 64,
  PRE-HTTP, stderr literal: `Invalid --sort "<value>". Use <field>:asc or <field>:desc
  (e.g., updated:desc).`
- **Field name preserved verbatim (BC-2.1.024 Postcondition 1)**: valid input parses to
  `(field: String, direction)` with `field` preserved VERBATIM (original casing, no trimming
  beyond the split); `direction` normalized to `ASC`/`DESC` for JQL composition.
- **Uniform override across all 4 branches (BC-2.1.025 Behavior, human-locked DEC-298
  "always wins")**: when present, `--sort` OVERRIDES the `order_by` value computed by ALL
  FOUR JQL-composition branches — `--jql`, scrum-active-sprint, kanban, default-project —
  applied UNIFORMLY, no board-specific exception. When ABSENT, every branch's `order_by`
  value is BYTE-FOR-BYTE UNCHANGED from BC-2.1.002/003/004/005's pinned literals.
- **No field-name allowlist (BC-2.1.025 Precondition 1)**: field name passed through to Jira
  UNVALIDATED — the same trust posture `--jql`'s free-form WHERE clause already receives.
  Whether the field is actually orderable is determined solely by Jira's own response.
- **Composition shape (BC-2.1.025 Postcondition 1/2)**: `order_by = "<FIELD> <DIR>, key
  ASC"` — EXCEPT when the field matches `key` case-insensitively, where the secondary sort
  is OMITTED (`order_by = "<FIELD> <DIR>"` only), avoiding a redundant `key DESC, key ASC`.
- **Replaces the `--jql` branch's hardcoded default too (BC-2.1.025 Postcondition 3)**:
  `--jql`'s own embedded `ORDER BY` is ALREADY unconditionally stripped/replaced
  (BC-2.1.002); when `--sort` is present, it becomes the new replacement value in place of
  the hardcoded `"updated DESC"`.
- **Overrides board-driven `rank ASC` too (BC-2.1.025 Postcondition 4)**: applies UNIFORMLY
  to scrum-active-sprint and kanban branches — `--sort`, when given, always wins over the
  board-driven `rank ASC` default. No silent exception, no additional opt-in flag.
- **Not a filter source (BC-2.1.025 Postcondition 5 / BC-2.1.006 Note)**: `--sort` does NOT
  push a clause via `build_filter_clauses` and is NOT added to BC-2.1.006's "no filters
  specified" exit-64 enumeration.

## Acceptance Criteria

### AC-001 (traces to BC-2.1.025 Edge Case EC-2.1.025-1 — override + secondary sort)
`--sort updated:desc` -> `order_by = "updated DESC, key ASC"`.
**Test:** `test_bc_2_1_025_issue_list_sort_composes_secondary_key_asc()`

### AC-002 (traces to BC-2.1.025 postcondition 2 / Edge Case EC-2.1.025-2 — key field omission)
`--sort key:asc` -> `order_by = "key ASC"` (no redundant secondary clause).
**Test:** `test_bc_2_1_025_issue_list_sort_key_field_omits_secondary_clause()`

### AC-003 (traces to BC-2.1.024 postcondition 1 — case-insensitive direction)
`--sort key:ASC`, `--sort key:AsC` both parse identically to `--sort key:asc`.
**Test:** `test_bc_2_1_024_issue_list_sort_direction_case_insensitive()`

### AC-004 (traces to BC-2.1.024 Edge Case EC-2.1.024-3..7 — malformed input rejection)
`--sort updated` (no `:`), `--sort :desc` (empty field), `--sort updated:` (empty
direction), `--sort updated:sideways` (invalid direction), and `--sort updated:desc:extra`
(second `:` in direction) all -> exit 64 pre-HTTP, exact stderr string `Invalid --sort
"<value>". Use <field>:asc or <field>:desc (e.g., updated:desc).`; zero HTTP calls.
**Test:** `test_bc_2_1_024_issue_list_sort_malformed_input_exits_64_pre_http()`

### AC-005 (traces to BC-2.1.025 postcondition 3 — overrides --jql branch default)
`jr issue list --jql "project = FOO" --sort updated:desc` -> `order_by` becomes `"updated
DESC, key ASC"`, replacing the hardcoded `"updated DESC"` default (BC-2.1.002).
**Test:** `test_bc_2_1_025_issue_list_sort_overrides_jql_branch_default()`

### AC-006 (traces to BC-2.1.025 postcondition 4 / Edge Case EC-2.1.025-4 — overrides board rank)
`--sort rank:asc` on a kanban board (default `order_by = "rank ASC"` when `--sort` absent)
-> `order_by = "rank ASC, key ASC"` — NOT collapsed to the board-default with no secondary
clause, since the `key`-omission rule is scoped to the literal field name `key` only.
**Test:** `test_bc_2_1_025_issue_list_sort_overrides_kanban_board_rank_default()`

### AC-007 (traces to BC-2.1.025 Behavior — absent-flag byte-for-byte unchanged)
With `--sort` ABSENT, all 4 branches' `order_by` values remain byte-for-byte identical to
BC-2.1.002/003/004/005's pinned literals (`"updated DESC"` x2, `"rank ASC"` x2) — full
regression suite green, no test modification to those 4 BCs' existing pinned-literal tests.
**Test:** existing `build_jql_parts_*`/`all_flag_behavior` regression suite (unmodified).

### AC-008 (traces to BC-2.1.025 Edge Case EC-2.1.025-5 — pass-through, no allowlist)
`--sort customfield_10099:desc` (unknown/unorderable field) -> zero local rejection; `POST
/rest/api/3/search/jql` IS called; Jira's 400 response propagates as `JrError::ApiError
{status: 400}` (exit 1) via the existing generic HTTP-error path.
**Test:** `test_bc_2_1_025_issue_list_sort_unknown_field_propagates_jira_400()`

### AC-009 (traces to BC-2.1.025 postcondition 5 / BC-2.1.006 Note — not a filter source)
`--sort` is NOT added to BC-2.1.006's "no filters specified" stderr enumeration; `jr issue
list --sort updated:desc` with no project/filters/`--jql` still exits 64 (the "no filters"
guard fires regardless of `--sort`'s presence, since `--sort` does not count as a filter).
**Test:** `test_bc_2_1_006_issue_list_sort_alone_does_not_satisfy_filter_requirement()`

### AC-010 (traces to BC-2.1.025 Edge Case EC-2.1.025-3 — key-omission is case-insensitive match, field casing preserved)
`--sort KEY:desc` (case-variant matching `key`) -> secondary-sort omission still applies
(case-insensitive match on the FIELD name for the omission check), but the field's OWN
casing is passed through verbatim: `order_by = "KEY DESC"`, not lowercased.
**Test:** `test_bc_2_1_025_issue_list_sort_key_omission_case_insensitive_field_casing_preserved()`

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `--sort <field>:<dir>` CLI flag | `src/cli/mod.rs` (additive on `List` variant) | N/A (clap derive) |
| Parse/validate helper (BC-2.1.024) | `src/cli/issue/list.rs` (new pure fn) | Pure |
| `order_by` override application (BC-2.1.025) | `src/cli/issue/list.rs` (applied after the 4-branch match/if block, before `all_parts.join`) | Pure (string composition) |
| Jira 400 propagation on unorderable field | `src/api/jira/issues.rs` / `src/api/client.rs` (existing generic error path, no change) | Effectful (HTTP) |

## Edge Cases

Covered by dedicated ACs: EC-2.1.024-1..7, EC-2.1.025-1..5.

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `cli/issue/list.rs` (`--sort` parse/validate helper) | Pure | String split/match, no I/O |
| `cli/issue/list.rs` (`order_by` override application) | Pure | String composition applied after the existing 4-branch match/if returns |
| `api/client.rs` (generic 4xx->`ApiError` mapping, unchanged) | Effectful | Existing HTTP error path, reused as-is |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|--------------------|
| This story spec | ~6k |
| BC-2.1.024/BC-2.1.025 bodies (read in full) | ~6k |
| BC-2.1.002/003/004/005 (pinned-literal context) | ~3k |
| `src/cli/issue/list.rs` (4-branch `order_by` match/if block, existing window) | ~5k |
| `src/api/jira/issues.rs:~277-303` (JRACLOUD-95368 advisory context) | ~2k |
| Test files + fixtures | ~6k |
| Tool outputs | ~5k |
| **Total** | **~33k** |
| Agent context window | 200K |
| **Budget usage** | **~17%** |

## Tasks (MANDATORY)

1. [ ] Write failing tests for `--sort` syntax parse/validate (valid cases, case-insensitive direction)
2. [ ] Write failing tests for all 5 malformed-input shapes (EC-2.1.024-3..7), exact stderr string
3. [ ] Write failing tests for `order_by` override in each of the 4 branches (`--jql`, scrum, kanban, default-project)
4. [ ] Write failing tests for the `key`-field secondary-sort omission (incl. case-variant field casing preservation)
5. [ ] Write failing test for absent-`--sort` byte-for-byte unchanged defaults (regression, no new assertions needed beyond existing suite)
6. [ ] Write failing test for unknown-field pass-through -> Jira 400 propagation
7. [ ] Write failing test confirming `--sort` is excluded from BC-2.1.006's filter enumeration
8. [ ] Verify Red Gate
9. [ ] Add `sort: Option<String>` field to `cli/mod.rs`'s `IssueCommand::List`
10. [ ] Implement parse/validate helper in `list.rs`
11. [ ] Apply `order_by` override after the existing 4-branch match/if block, before `all_parts.join`
12. [ ] Refactor; full suite green

## Previous Story Intelligence (MANDATORY)

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|----------------|------------------------|-----------------------|
| S-579-1 (bundle predecessor, same wave) | Extended `build_filter_clauses`/`FilterOptions`, NOT the `order_by` block | This story touches a DIFFERENT function region (`order_by` composition, ~list.rs:301-371) than S-579-1's `build_filter_clauses` region — low logical overlap, but same file: deliver sequentially per the bundle's delivery-process note | The 4-branch `order_by` match/if block currently returns 3 hardcoded literals (`"updated DESC"` x2, `"rank ASC"` x2) pinned by BC-2.1.002/003/004/005 as exact composed JQL strings in both unit tests AND `tests/all_flag_behavior.rs` — apply the override strictly AFTER this block returns, never inside it, to avoid touching those pinned literals when `--sort` is absent |

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|--------------|
| No local field-name allowlist — pass-through to Jira only | BC-2.1.025 Precondition 1 | AC-008 |
| Absent-`--sort` behavior in all 4 branches MUST stay byte-for-byte unchanged | BC-2.1.025 Behavior | AC-007 |
| `--sort` MUST NOT push a clause via `build_filter_clauses` or join BC-2.1.006's enumeration | BC-2.1.025 Postcondition 5 / BC-2.1.006 Note | AC-009 |
| `key`-field secondary-sort omission is scoped to the literal field name `key`, not to a branch's own default sort field | BC-2.1.025 Edge Case EC-2.1.025-4 | AC-006 |
| Malformed `--sort` input MUST fail PRE-HTTP with the exact pinned stderr string | BC-2.1.024 Postcondition 2 | AC-004 |

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|----------|
| reqwest / serde (existing) | as in `Cargo.lock` | HTTP |
| wiremock (existing) | as in `Cargo.lock` | Integration tests |

No new crate dependencies.

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|----------|
| `src/cli/mod.rs` | MODIFY | New `sort: Option<String>` field on `IssueCommand::List` |
| `src/cli/issue/list.rs` | MODIFY | Parse/validate helper; `order_by` override applied after the existing 4-branch block |
| `src/api/jira/issues.rs` | NO CHANGE anticipated (existing generic error path handles Jira 400 propagation) | — |
| `tests/issue_commands.rs`, `tests/all_flag_behavior.rs`, `tests/issue_list_errors.rs` | MODIFY | New test cases (10 ACs) |

**MUST NOT change**: BC-2.1.002/003/004/005's pinned default `order_by` literals when
`--sort` is absent; `src/cli/issue/list.rs`'s `build_filter_clauses`/`FilterOptions` region
(S-579-1's region, unrelated to this story); BC-2.1.006's filter-source enumeration (`--sort`
is explicitly excluded, not added).
