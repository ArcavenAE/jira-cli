---
document_type: story
level: ops
epic_id: "none"
story_id: "S-575-1"
title: "--fields <CSV> on issue list / issue view"
wave: 1
feature_mode_bundle: list-read-ergonomics
status: ready
intent: feature
feature_type: backend
mode: feature
scope: standard
severity: N/A
trivial_scope: false
issue: 575
points: 8
priority: P1
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
estimated_days: 3
target_module: src/cli/issue/list.rs
subsystems: ["SS-02", "SS-04"]
depends_on: []
blocks: ["S-584-1"]
behavioral_contracts:
  - "BC-2.2.033"
  - "BC-2.3.041"
  - "BC-2.6.052"
bcs:
  - "BC-2.2.033"
  - "BC-2.3.041"
  - "BC-2.6.052"
verification_properties: ["VP-FIELDS-001", "VP-FIELDS-002", "VP-FIELDS-003"]
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/bc-2-issue-read.md"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 12
assumption_validations: []
risk_mitigations: []
created: "2026-08-21"
version: "1.0"
last_updated: "2026-08-21"
breaking_change: false
retroactive: false
origin: >
  GitHub issue #575, bundle `list-read-ergonomics` (F1 delta-analysis Story S-1). First
  story of the bundle's sequential Wave-1 delivery order (S-575-1 -> S-579-1 -> S-588-1,
  then Wave-2 S-584-1). Central plumbing change: new client methods, two CLI arg structs,
  two handler wiring sites, output-format gate, pre-HTTP CSV validation. S-584-1 blocks on
  this story landing first because it needs `--fields` to exist and needs the REPLACE (not
  UNION) request semantics settled before it can even reach the `comment` field.
files_modified:
  - src/cli/mod.rs
  - src/cli/issue/list.rs
  - src/cli/issue/view.rs
  - src/api/jira/issues.rs
test_files:
  - tests/issue_commands.rs
  - tests/all_flag_behavior.rs
  - tests/issue_list_errors.rs
  - tests/issue_view_errors.rs
  - tests/cli_smoke.rs
input-hash: "676bf41"
---

> **tdd_mode:** `strict`.

# S-575-1: `--fields <CSV>` on `jr issue list` / `jr issue view`

## Narrative

As a `jr` user who only needs a handful of fields from a large result set, I want
`--fields <CSV>` on both `jr issue list` and `jr issue view` so that I can request exactly
the fields I need from Jira's `fields=` parameter — reducing wire cost and eliminating
workaround `jr api` calls — without changing the shape of the JSON output I already parse.

## Source of Truth

Read **BC-2.2.033**, **BC-2.3.041**, and **BC-2.6.052** in `bc-2-issue-read.md` §2.2/§2.3/§2.6
in full before implementing. Also read BC-2.2.028 (`BASE_ISSUE_FIELDS` default path this
story bypasses only when `--fields` is present) and BC-2.2.030/BC-2.3.032 (`render_json`
typed-struct serialization mechanism, reused unchanged).

## Behavioral Contracts

| BC ID | Title |
|-------|-------|
| BC-2.2.033 | `issue list --fields <CSV>` replaces the requested `fields=` set; requires `--output json` (exit 64 otherwise); pre-HTTP CSV validation |
| BC-2.3.041 | `issue view --fields <CSV>` — same semantics as BC-2.2.033, via a new `get_issue`-family client method |
| BC-2.6.052 | `JiraClient` gains field-override client methods (additive; existing `get_issue`/`search_issues` signatures and their 10 other call sites (8 `get_issue` + 2 `search_issues`) unchanged) |

## Behavior Summary (verbatim per BC — do not deviate)

- **REPLACE, not UNION (BC-2.2.033/BC-2.3.041, human-locked DEC-298)**: when `--fields <CSV>`
  is present it FULLY REPLACES `BASE_ISSUE_FIELDS` plus any config-driven extras
  (`--points`'s `customfield_NNNNN`, `--assets`'s CMDB field ids, the team field id) in the
  `fields=` request parameter. It does not union with them.
- **JSON-only (Precondition 2)**: `--fields` requires `--output json`. Table mode (default,
  or explicit `--output table`) combined with `--fields` -> exit 64 PRE-HTTP, stderr:
  `--fields requires --output json.`
- **Pre-HTTP CSV validation (Precondition 3)**: each comma-separated segment is
  whitespace-trimmed; at least one non-empty segment is required. `--fields ""`,
  `--fields ","`, and `--fields "summary,,status"` (empty embedded segment) all exit 64
  pre-HTTP — an empty segment is REJECTED, not silently dropped.
- **Output shape unchanged (Postcondition 2)**: output stays the typed `Issue`/`IssueFields`
  struct via `render_json` — NOT a bespoke raw-JSON shape. Named `IssueFields` fields not
  covered by the request deserialize as `None` / serialize as JSON `null` (standard serde
  missing-key behavior, no `#[serde(default)]` needed — no field in `IssueFields` carries
  `#[serde(skip_serializing_if)]`). Unnamed fields requested (`comment`, `customfield_NNNNN`,
  `attachment`) flow through `IssueFields.extra: HashMap<String, Value>`
  (`#[serde(flatten)]`) verbatim.
- **`key` always present (Postcondition 3)**: Jira always returns `key` top-level regardless
  of whether `key` appears in the `--fields` CSV — no new code needed, confirm via test.
- **`--points`/`--assets`/`--duedate` become silent no-ops (Postcondition 4)** when combined
  with `--fields` — their extra-field request injection and column-rendering logic never
  executes. No warning, no error.
- **Additive client methods only (BC-2.6.052)**: new sibling methods (e.g.
  `get_issue_with_fields`, `search_issues_with_fields` — exact names/shapes at implementer
  discretion) accept an explicit field list and send it VERBATIM, comma-joined, as `fields=`.
  The EXISTING `get_issue`/`search_issues` signatures are UNCHANGED. The 10 existing call
  sites (8 `get_issue` + 2 `search_issues`) outside `list.rs`/`view.rs` (`edit.rs` x2,
  `links.rs`, `create.rs`, `assets.rs`, `workflow.rs` x3, `board.rs`, `queue.rs`) compile and
  behave IDENTICALLY — zero code change at any of these sites.
- **Empty field slice at the client layer (BC-2.6.052 EC-1)**: an empty field slice reaching
  the new method(s) is NOT a client-layer error — the CLI-layer pre-HTTP validation
  (Precondition 3 above) is the sole enforcement point; the client method is a thin,
  unvalidated pass-through.

## Acceptance Criteria

### AC-001 (traces to BC-2.2.033 postcondition 1 — replace semantics, list)
`jr issue list --jql "..." --fields "summary,status,comment" --output json` requests exactly
`fields=summary,status,comment` (no `BASE_ISSUE_FIELDS` union, no config-driven extras).
**Test:** `test_bc_2_2_033_issue_list_fields_replaces_requested_field_set()`

### AC-002 (traces to BC-2.3.041 postcondition 1 — replace semantics, view)
`jr issue view <KEY> --fields "summary,comment" --output json` requests exactly
`fields=summary,comment` via a new `get_issue`-family client method (BC-2.6.052).
**Test:** `test_bc_2_3_041_issue_view_fields_replaces_requested_field_set()`

### AC-003 (traces to BC-2.2.033 postcondition 2 — typed output, null placeholders)
Named `IssueFields` fields not covered by a `--fields` request serialize as JSON `null`;
unnamed fields requested (e.g. `comment`) flow through `extra` verbatim as raw JSON values.
**Test:** `test_bc_2_2_033_issue_list_fields_unrequested_named_fields_are_null()`

### AC-004 (traces to BC-2.2.033 Edge Case EC-2.2.033-3 / BC-2.3.041 Edge Case EC-2.3.041-2 — table-mode rejection)
`--fields "summary,status"` without `--output json` (table mode, default or explicit
`--output table`) on both `list` and `view` -> exit 64, stderr `--fields requires --output
json.`; zero HTTP calls.
**Test:** `test_bc_2_2_033_issue_list_fields_table_mode_exits_64()`,
`test_bc_2_3_041_issue_view_fields_table_mode_exits_64()`

### AC-005 (traces to BC-2.2.033 Edge Case EC-2.2.033-4/EC-2.2.033-5 — empty/malformed CSV)
`--fields ""`, `--fields ","`, and `--fields "summary,,status"` (empty embedded segment) all
exit 64 PRE-HTTP on both `list` and `view`; zero HTTP calls.
**Test:** `test_bc_2_2_033_issue_list_fields_empty_csv_exits_64_pre_http()`

### AC-006 (traces to BC-2.2.033 Edge Case EC-2.2.033-6 — extra-flag no-op)
`--fields "summary,status" --points --output json` -> `--points`'s `customfield_NNNNN` is NOT
added to the request (REPLACE semantics wins); no warning emitted.
**Test:** `test_bc_2_2_033_issue_list_fields_points_flag_becomes_silent_noop()`

### AC-007 (traces to BC-2.2.033 postcondition 3 — key always present)
`key` is present in output regardless of whether `key` appears in `--fields`.
**Test:** `test_bc_2_2_033_issue_list_fields_key_always_present_regardless_of_csv()`

### AC-008 (traces to BC-2.2.033 Edge Case EC-2.2.033-2 — whitespace trimming)
`--fields "summary, status"` (embedded whitespace) behaves identically to
`--fields "summary,status"`.
**Test:** `test_bc_2_2_033_issue_list_fields_csv_segments_are_trimmed()`

### AC-009 (traces to BC-2.6.052 postcondition 1 — additive, zero regression)
The 10 existing `get_issue`/`search_issues` call sites (8 `get_issue` + 2 `search_issues`)
outside `list.rs`/`view.rs` (`edit.rs` x2, `links.rs`, `create.rs`, `assets.rs`,
`workflow.rs` x3, `board.rs`, `queue.rs`) compile and behave identically — existing test
suites for those files pass unmodified.
**Test:** full regression suite green (no new test; verified via `cargo test`).

### AC-010 (traces to BC-2.6.052 postcondition 2 / EC-2.6.052-1 — thin pass-through)
The new client method(s) send the caller-supplied field list exactly, comma-joined, as
`fields=`; an empty field slice is NOT rejected at the client layer (thin pass-through,
CLI-layer validation is the sole enforcement point).
**Test:** `test_bc_2_6_052_field_override_methods_send_verbatim_field_list()`

### AC-011 (traces to BC-2.3.041 Edge Case EC-2.3.041-3 — empty CSV on view)
`jr issue view <KEY> --fields ""` -> exit 64 pre-HTTP, zero HTTP calls.
**Test:** `test_bc_2_3_041_issue_view_fields_empty_csv_exits_64_pre_http()`

### AC-012 (traces to BC-2.3.041 postcondition 3 — key always present, view)
`jr issue view <KEY> --fields "summary"` -> `key` present in output regardless of CSV
contents (same Jira guarantee as AC-007, verified independently on the view path).
**Test:** `test_bc_2_3_041_issue_view_fields_key_always_present()`

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `--fields <CSV>` CLI flags (List + View) | `src/cli/mod.rs` (additive) | N/A (clap derive) |
| Pre-HTTP CSV validation + output-format gate | `src/cli/issue/list.rs::handle_list`, `src/cli/issue/view.rs::handle_view` | Pure (string validation) |
| `get_issue_with_fields`/`search_issues_with_fields`-shaped methods | `src/api/jira/issues.rs` (additive) | Effectful (HTTP) |

## Edge Cases

Covered by dedicated ACs: EC-2.2.033-1..6, EC-2.3.041-1..3, EC-2.6.052-1.

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `cli/issue/list.rs`/`cli/issue/view.rs` (CSV validation + gate) | Pure | String/CSV parsing, no I/O |
| `api/jira/issues.rs` (new field-override methods) | Effectful | HTTP request construction + dispatch |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|--------------------|
| This story spec | ~7k |
| BC-2.2.033/BC-2.3.041/BC-2.6.052 bodies (read in full) | ~6k |
| `src/api/jira/issues.rs` (existing `get_issue`/`search_issues` window) | ~5k |
| `src/cli/issue/list.rs`/`view.rs` (existing handler windows) | ~6k |
| Test files + fixtures | ~8k |
| Tool outputs | ~5k |
| **Total** | **~37k** |
| Agent context window | 200K |
| **Budget usage** | **~19%** |

## Tasks (MANDATORY)

1. [ ] Write failing tests for `--fields` replace-semantics request composition (list + view)
2. [ ] Write failing tests for table-mode rejection (exit 64, both commands)
3. [ ] Write failing tests for empty/malformed CSV pre-HTTP rejection
4. [ ] Write failing tests for `--points`/`--assets`/`--duedate` silent-no-op interaction
5. [ ] Write failing tests for `key`-always-present and CSV whitespace-trimming
6. [ ] Write failing tests for the 10-call-site additive-method regression guarantee
7. [ ] Verify Red Gate
8. [ ] Add `get_issue_with_fields`/`search_issues_with_fields`-shaped methods to `src/api/jira/issues.rs`
9. [ ] Wire `--fields` CLI flag into `cli/mod.rs` (List + View)
10. [ ] Wire pre-HTTP validation + output-format gate into `handle_list`/`handle_view`
11. [ ] Refactor; full suite green

## Previous Story Intelligence (MANDATORY)

N/A — first story in this bundle (list-read-ergonomics). Nearest sibling precedent:
S-606-1 (`--component` filter) established the pattern of additive `src/cli/issue/list.rs`
flags with pre-HTTP validation in the same hot region this story touches; S-CACHE/S-CMDB
warm-hit coverage stories established the "additive method, zero regression at existing
call sites" discipline this story's AC-009/AC-010 mirror.

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|--------------|
| `--fields` REPLACES, never UNIONs, the requested field set | BC-2.2.033 Behavior, human-locked DEC-298 | AC-001, AC-006 |
| `--fields` requires `--output json`; table mode -> exit 64 pre-HTTP | BC-2.2.033 Precondition 2 | AC-004 |
| New client methods are additive siblings — `get_issue`/`search_issues` signatures MUST NOT change | BC-2.6.052 Precondition 1/Postcondition 1 | AC-009, AC-010 |
| Empty CSV segments are rejected, never silently dropped | BC-2.2.033 Edge Case EC-2.2.033-5 | AC-005 |
| Output stays typed `IssueFields` struct serialization — no bespoke raw-JSON shape | BC-2.2.033 Postcondition 2 | AC-003 |

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|----------|
| reqwest / serde (existing) | as in `Cargo.lock` | HTTP |
| wiremock (existing) | as in `Cargo.lock` | Integration tests |

No new crate dependencies.

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|----------|
| `src/cli/mod.rs` | MODIFY | `--fields <CSV>` flag on `IssueCommand::List` and `IssueCommand::View` |
| `src/cli/issue/list.rs` | MODIFY | `handle_list` wiring, output-format gate, pre-HTTP CSV validation |
| `src/cli/issue/view.rs` | MODIFY | `handle_view` wiring, same gate |
| `src/api/jira/issues.rs` | MODIFY (additive) | New `get_issue_with_fields`/`search_issues_with_fields`-shaped methods |
| `tests/issue_commands.rs`, `tests/all_flag_behavior.rs`, `tests/issue_list_errors.rs`, `tests/issue_view_errors.rs`, `tests/cli_smoke.rs` | MODIFY | New test cases (12 ACs) |

**MUST NOT change**: `src/cli/issue/format.rs` (row formatting — `--fields` is JSON-only, no
column-rendering code changes); `src/cli/issue/json_output.rs` (write-command JSON helpers,
unrelated); `src/adf.rs` (no new ADF logic — see S-584-1 Decision 2); the EXISTING
`get_issue`/`search_issues` signatures (additive-only per BC-2.6.052).
