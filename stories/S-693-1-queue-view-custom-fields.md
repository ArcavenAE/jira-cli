---
document_type: story
level: ops
epic_id: "BUCKET1-DEFECTS"
story_id: "S-693-1"
title: "queue view threads queue-declared customfield_* columns into search_issues extra_fields (closes #693)"
wave: feature-followup
status: draft
intent: enhancement
feature_type: backend
mode: feature
scope: standard
severity: LOW
trivial_scope: false
issue: 693
points: 5
priority: MEDIUM
tdd_mode: strict
estimated_effort: medium
producer: story-writer
timestamp: "2026-08-13T00:00:00"
phase: 3
cycle: cycle-bucket1-defects
inputs:
  - ".factory/phase-f1-delta-analysis/bucket1-impact-boundary.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-bucket1-defects.md"
  - ".factory/research/bucket1-693-queue-view-fields-2026-08-13.md"
  - ".factory/specs/prd/cross-cutting.md"
input-hash: "843a8fd"
traces_to: ".factory/specs/prd/cross-cutting.md"
estimated_days: 1
target_module: src/cli/queue.rs
subsystems: ["SS-08"]
depends_on: []
blocks: []
behavioral_contracts:
  - "BC-X.8.009"
bcs:
  - "BC-X.8.009"
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/cross-cutting.md"
implementation_strategy: tdd
module_criticality: "informal (no module-criticality.md exists in this repo; target_module src/cli/queue.rs is a read-path JSM integration — treat as MEDIUM by convention pending a formal criticality doc)"
acceptance_criteria_count: 8
assumption_validations: []
risk_mitigations: []
created: "2026-08-13"
version: "1.0"
last_updated: "2026-08-13"
breaking_change: false
retroactive: false
origin: >
  BUCKET1-DEFECTS bundle. `jr queue view` discards the JSM queue endpoint's
  configured `fields` and re-fetches a fixed BASE_ISSUE_FIELDS set via
  search_issues with an empty extra_fields slice, so queue-configured custom
  fields never surface in --output json. BC-X.8.009 (AMENDED, additive) fixes
  this by threading the resolved Queue's declared fields[] (allow-list filtered
  to ^customfield_\d+$) into extra_fields. Additive, non-breaking: table output
  unchanged, JSON gains only new customfield_* keys via IssueFields's existing
  #[serde(flatten)] extra mechanism.
files_modified:
  - src/cli/queue.rs
test_files:
  - tests/queue.rs
---

> **Execute:** `/vsdd-factory:deliver-story S-693-1`

# S-693-1 — `queue view` Surfaces Queue-Configured Custom Fields

## Narrative

- **As a** `jr queue view` caller whose JSM queue is configured with custom
  field columns (e.g., `customfield_10050`)
- **I want to** see those custom fields in `--output json`
- **So that** I don't have to re-derive them from a separate `jr issue view`
  call per key — the queue endpoint already returns them, and `jr` was
  silently discarding them before re-fetching a fixed field set.

Not a breaking change: table output is unchanged (no new column — render-side
work for custom-field columns is tracked separately as issue #575); JSON output
is purely additive (new `customfield_*` keys, existing keys unaffected).

## Source of Truth

- F2 spec evolution (authoritative): `.factory/specs/prd/cross-cutting.md`
  BC-X.8.009 (`STATUS: UPDATED (2026-08-13, issue #693)`, additive amendment;
  ALLOW-LIST design pinned at adversary pass-2/-3, not the DROP-LIST first
  proposed).
- Research brief: `.factory/research/bucket1-693-queue-view-fields-2026-08-13.md`
  (Atlassian API confirmation that `values[].fields` is the queue's configured
  columns; rejection of Option 1 — render directly from queue fields — as a
  real rendering regression risk since Atlassian's own example queue config
  omits `status`/`priority`/`assignee`).

## Problem Statement

`src/api/jsm/queues.rs::get_queue_issue_keys` deserializes each queue-issue
page into `ServiceDeskPage<QueueIssueKey>` and immediately maps every entry to
`ik.key`, discarding the `fields` object the queue endpoint already returned
(`QueueIssueKey { key }`-only shape — by design, to establish queue-order key
sequence, not to source field data). `src/cli/queue.rs::handle_view` then calls
`client.search_issues(&jql, Some(keys.len() as u32), &[])` with an EMPTY
`extra_fields` slice, so only `BASE_ISSUE_FIELDS` (17 fixed fields, no custom
fields) is ever requested. The `Queue` metadata struct already carries the
column config (`src/types/jsm/queue.rs::Queue.fields: Option<Vec<String>>`,
the same array `jr queue list --output json` surfaces) but it is never used by
`queue view`.

## Behavioral Contracts

| BC ID | Title | Clause |
|-------|-------|--------|
| BC-X.8.009 | `jr queue view` resolves queue, fetches keys, batch-fetches issues with queue-declared custom fields threaded through as `extra_fields` | AMENDED — Queue ID resolution item 1 (`--id` path aux `list_queues` cost), Issue fetch pipeline step 3 (allow-list `extra_fields` construction), EC-X.8.009-1/-2, Output/JSON-output clause, Errors clause scope |

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `--id` path aux `list_queues` lookup (obtain `queue.fields`) | `src/cli/queue.rs::handle_view` | effectful-shell (HTTP) |
| `<name>` path: `Queue` retained from `resolve_queue_by_name`'s existing `list_queues` call (zero extra HTTP) | `src/cli/queue.rs::resolve_queue_by_name` | effectful-shell (HTTP, pre-existing call, no new cost) |
| `extra_fields` allow-list filter (`^customfield_\d+$`) | new pure helper in `src/cli/queue.rs` | pure-core |
| `search_issues(&jql, Some(n), &extra_fields)` | `src/api/jira/issues.rs::search_issues` (pre-existing signature, new non-empty caller value) | effectful-shell (HTTP) |
| JSON `customfield_*` round-trip | `src/types/jira/issue.rs::IssueFields` `#[serde(flatten)] extra` (pre-existing, unmodified) | pure-core (serde) |

## Implementation Pattern

1. **Name path** (`resolve_queue_by_name`): the matched `Queue` object
   (including its `fields[]`) is retained alongside the resolved id — no
   additional HTTP call beyond the `list_queues` this path already makes.
2. **`--id` path**: bypasses `resolve_queue_by_name` entirely, so obtaining
   `queue.fields` costs one additional `client.list_queues(service_desk_id)`
   call, matched by id. This is a documented, accepted cost asymmetry — do NOT
   attempt to eliminate it by threading id-lookup through the name-path
   machinery.
3. **Allow-list filter (NOT a drop-list)**: only tokens matching the anchored,
   case-sensitive pattern `^customfield_\d+$` (full-string match, one or more
   ASCII digits, no upper bound) are kept in `extra_fields`. Every other
   token — `issuekey`, any `BASE_ISSUE_FIELDS` member, any other
   unknown/display-only token, INCLUDING a token that merely starts with
   `customfield_` without matching the full anchored pattern (e.g.
   `customfield_` with zero digits, or `customfield_10050_x` with trailing
   non-digit content) — is DROPPED. This eliminates, by construction, the risk
   of a non-requestable queue column reaching the PRIMARY `search_issues` call
   and 400ing it (a risk the fail-open auxiliary-lookup guard does NOT cover).
4. **`--id` path fail-open degrade**: if the auxiliary `list_queues` lookup
   errors (5xx/401/network) or finds no matching id, degrade to
   `extra_fields = &[]` (pre-#693 behavior) and emit a terse stderr warning
   BEFORE proceeding — do NOT hard-fail the command. Warning format:
   `warning: could not fetch queue field configuration for --id <id> (<cause>);
   showing base fields only.` where `<cause>` is terse (e.g. `API error (500)`,
   `not authenticated`, `no matching queue`), not a raw HTTP body dump — same
   model-b convention as `write_cmdb_fields_cache`/`write_object_type_attr_cache`.

## Acceptance Criteria

### AC-1 (traces to BC-X.8.009 Issue fetch pipeline step 3, happy path): name-path custom fields surface in JSON
- `jr queue view <queue-name> --output json` where the resolved queue's
  `fields[]` includes `customfield_10050` → the array of returned `Issue`
  objects' `fields` carries `customfield_10050` with Jira's raw value
  (via `IssueFields`'s `#[serde(flatten)] extra`). No additional
  `list_queues` call beyond the one `resolve_queue_by_name` already makes.
- **Test:** `test_BC_X_8_009_queue_view_name_path_surfaces_declared_customfield_in_json`

### AC-2 (traces to BC-X.8.009 Queue ID resolution item 1, cost asymmetry): `--id` path costs one additional `list_queues` call
- `jr queue view --id <id> --output json` where the queue is configured with
  `customfield_10050` → the same custom field surfaces in JSON, but the
  `--id` path issues exactly one MORE `list_queues` call than the `<name>`
  path for the same queue (assert via mock call-count, not wall-clock).
- **Test:** `test_BC_X_8_009_queue_view_id_path_incurs_one_additional_list_queues_call`

### AC-3 (traces to BC-X.8.009 EC-X.8.009-1, MEDIUM-3/LOW-1 fail-open degrade): `--id` path auxiliary lookup failure degrades, does not hard-fail
- `jr queue view --id 999 --output json` where the auxiliary `list_queues`
  call for `queue.fields` either errors (5xx/401/network) or succeeds with no
  matching id → command proceeds with `extra_fields = &[]`, exit 0, base
  fields only. A terse stderr `warning: could not fetch queue field
  configuration for --id 999 (<cause>); showing base fields only.` is emitted
  BEFORE proceeding, in both `--output json` and `--output table` modes. Exit
  code and stdout content are unaffected (JSON stdout carries no warning
  field).
- **Test:** `test_BC_X_8_009_queue_view_id_path_aux_lookup_failure_degrades_with_warning_exit_0`

### AC-4 (traces to BC-X.8.009 Issue fetch pipeline step 3, allow-list pin): allow-list rejects non-customfield and malformed tokens
- A queue declaring `fields: ["issuekey", "summary", "status",
  "customfield_10050", "customfield_", "customfield_10050_x",
  "Customfield_99"]` → ONLY `customfield_10050` is kept in `extra_fields`;
  `issuekey`/`summary`/`status` (base/pseudo tokens), `customfield_` (zero
  digits), `customfield_10050_x` (trailing non-digit content), and
  `Customfield_99` (wrong case) are all dropped.
- **Test:** `test_BC_X_8_009_extra_fields_allow_list_rejects_non_matching_tokens`

### AC-5 (traces to BC-X.8.009 EC-X.8.009-2): empty/non-matching `fields[]` → `extra_fields = &[]`, byte-identical to pre-#693
- A queue with `fields: ["issuekey", "summary", "status"]` (none match the
  allow-list) → `extra_fields` is empty, and the resulting `search_issues`
  call and JSON output are byte-identical to a queue with `fields: null`.
- **Test:** `test_BC_X_8_009_extra_fields_all_filtered_out_yields_empty_slice_no_regression`

### AC-6 (traces to BC-X.8.009 Output/Table-output clause, regression pin): table output unchanged, no new column
- `jr queue view <queue-name>` (default table mode) for a queue configured
  with `customfield_10050` → table headers and row content are BYTE-IDENTICAL
  to pre-#693 output (Key, Type, Status, Priority, Assignee, Summary — 6
  columns, no custom-field column added).
- **Test:** `test_BC_X_8_009_queue_view_table_output_unaffected_by_custom_field_extra_fields`

### AC-7 (traces to BC-X.8.009 Issue fetch pipeline item 2, regression pin): zero-issue queue short-circuit unaffected
- A queue with zero issues → `handle_view` exits 0 with `No results found.`
  (table) / `[]` (JSON) immediately; NEITHER `search_issues` NOR any
  `list_queues` call for `extra_fields` purposes is made (nothing to fetch
  fields for) — unaffected by this story.
- **Test:** `test_BC_X_8_009_queue_view_zero_issues_short_circuits_no_extra_fields_lookup`

### AC-8 (traces to BC-X.8.009 Errors clause, MEDIUM-3 scope note): primary-pipeline error taxonomy unaffected by auxiliary-lookup scope
- A REAL failure of the primary pipeline (`get_queue_issue_keys` or
  `search_issues` itself returning 401/5xx) is NOT degraded — it surfaces via
  the ordinary Errors clause exactly as before #693 (exit 1/2/64 as
  applicable), and DOES affect the exit code. Contrast with AC-3's auxiliary
  `--id`-path lookup failure, which never produces these exit codes.
- **Test:** `test_BC_X_8_009_primary_pipeline_failure_still_hard_fails_unaffected_by_aux_lookup_scope`

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-1 | Name path, queue declares `customfield_10050` | Surfaces in JSON, zero extra HTTP cost (AC-1) |
| EC-2 | `--id` path, same queue | Surfaces in JSON, one extra `list_queues` call (AC-2) |
| EC-3 | `--id` path, aux lookup 500s | Degrade to `extra_fields=&[]`, stderr warning, exit 0 (AC-3) |
| EC-4 | `--id` path, aux lookup 200s but no id match | Same degrade as EC-3 (AC-3) |
| EC-5 | `fields: ["customfield_"]` (zero digits) | Dropped — not kept (AC-4) |
| EC-6 | `fields: ["customfield_10050_x"]` (trailing content) | Dropped — not kept (AC-4) |
| EC-7 | `fields: ["Customfield_99"]` (wrong case) | Dropped — not kept (AC-4) |
| EC-8 | `fields: null` or `fields: []` | `extra_fields = &[]`, byte-identical to pre-#693 (AC-5) |
| EC-9 | Zero-issue queue | No `search_issues`/aux `list_queues` call at all (AC-7) |
| EC-10 | `search_issues` itself 401s | Ordinary exit-2 error path, not degraded (AC-8) |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|----------------|
| `extra_fields` allow-list filter | pure-core | Pure string-pattern filter, no I/O — new helper function, unit-testable in isolation |
| `src/cli/queue.rs::handle_view` | effectful-shell | HTTP calls (queue resolution, key fetch, search, optional aux lookup) |

## Token Budget Estimate

| Item | Tokens (approx) |
|------|-------------------|
| This story file | ~4 k |
| BC-X.8.009 full body | ~5 k |
| Research brief `bucket1-693-queue-view-fields-2026-08-13.md` | ~3 k |
| `src/cli/queue.rs` (handle_view, resolve_queue_by_name) | ~2 k |
| `src/api/jsm/queues.rs`, `src/types/jsm/queue.rs`, `src/api/jira/issues.rs` (signatures only) | ~2 k |
| `tests/queue.rs` (existing tests to extend) | ~5 k |
| Tool outputs + `cargo test` output | ~4 k |
| **Total** | **~25 k** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~13%** |

## Tasks

1. [ ] Read BC-X.8.009 (amended) in full, including the allow-list design
   rationale (adversary pass-2 MEDIUM-1) — do NOT implement a drop-list.
2. [ ] Write failing tests for AC-1 through AC-8 (Red Gate).
3. [ ] Add the pure allow-list filter helper (`^customfield_\d+$`).
4. [ ] Thread `Queue` retention through `resolve_queue_by_name` (name path,
   zero extra cost) and add the auxiliary `list_queues` lookup for the `--id`
   path (with fail-open degrade + stderr warning).
5. [ ] Wire the filtered `extra_fields` into the existing `search_issues` call
   in `handle_view`.
6. [ ] Verify AC-1 through AC-8 GREEN.
7. [ ] Full suite: `cargo test`, `cargo clippy -- -D warnings`, `cargo fmt --all
   -- --check`, `cargo deny check`.
8. [ ] Per-story adversarial review (project convention — 3/3 CLEAN before
   push).

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|-----------------|-------------------------|------------------------|
| S-QUEUE-BC-1 | `jr queue view` originally document-as-is (no dedicated BC) | Established `resolve_queue_by_name`/`get_queue_issue_keys`/`search_issues` pipeline shape | N/A — this is the first behavior-changing amendment to that pipeline |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| Allow-list, not drop-list, for `extra_fields` construction | BC-X.8.009 step 3 (adversary pass-2 MEDIUM-1 design decision) | AC-4/AC-5 |
| `--id` path aux lookup fails OPEN with a stderr warning, never hard-fails | BC-X.8.009 EC-X.8.009-1 | AC-3 |
| Table output unaffected — no new column | BC-X.8.009 Output/Table-output clause | AC-6 |
| Primary-pipeline errors (get_queue_issue_keys/search_issues) unaffected by aux-lookup scope | BC-X.8.009 Errors clause | AC-8 |

## Library & Framework Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| regex or manual byte-scan (implementer's choice — no new crate required for `^customfield_\d+$`) | n/a | Allow-list pattern match; prefer a manual `strip_prefix("customfield_")` + `.chars().all(is_ascii_digit)` check over pulling in the `regex` crate for one pattern, unless `regex` is already a dependency (verify `Cargo.toml` before adding) |

No new crate dependencies expected; verify before implementing.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/cli/queue.rs` | MODIFY | Retain `Queue` from `resolve_queue_by_name`; add `--id`-path aux lookup; add allow-list filter helper; thread `extra_fields` into `search_issues` call |
| `tests/queue.rs` | MODIFY | Add tests for AC-1..AC-8 |

**MUST NOT change**: `src/api/jsm/queues.rs::get_queue_issue_keys` (still
discards `fields` — by design, unaffected); `src/types/jira/issue.rs::IssueFields`
(`#[serde(flatten)] extra` mechanism reused verbatim, unmodified); BC files in
`.factory/specs/prd/` (F2 sealed — escalate discrepancies to orchestrator).

## Branch / PR Plan

- Bundle: `BUCKET1-DEFECTS`
- Branch: `feat/693-queue-view-custom-fields`
- Target: `develop`
- Commit style: `feat(queue): surface queue-declared custom fields in queue view JSON (#693)`
- PR closes #693
