---
document_type: story
level: ops
epic_id: "none"
story_id: "S-668-1"
title: "Surface Jira duedate in issue view/list (JSON fields + issue view Due Date row + issue list --duedate column)"
wave: feature-followup
status: ready
intent: enhancement
feature_type: backend
mode: feature
scope: standard
severity: N/A
trivial_scope: false
issue: 668
points: 5
priority: MEDIUM
tdd_mode: strict
estimated_effort: small
producer: story-writer
timestamp: "2026-08-13T00:00:00"
phase: 3
cycle: cycle-668-duedate
inputs:
  - ".factory/feature-delta/668-duedate/delta-analysis.md"
  - ".factory/specs/prd/bc-2-issue-read.md"
input-hash: "b89a0f8"
traces_to: ".factory/specs/prd/bc-2-issue-read.md"
estimated_days: 1
target_module: src/cli/issue/
subsystems: ["SS-02", "SS-04", "SS-07"]
depends_on: []
blocks: []
behavioral_contracts:
  - "BC-2.2.028"
  - "BC-2.2.032"
  - "BC-2.3.036"
  - "BC-2.3.039"
bcs:
  - "BC-2.2.028"
  - "BC-2.2.032"
  - "BC-2.3.036"
  - "BC-2.3.039"
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/bc-2-issue-read.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 16
assumption_validations: []
risk_mitigations: []
created: "2026-08-13"
version: "1.1"
last_updated: "2026-08-13"
breaking_change: false
retroactive: false
origin: >
  GitHub issue #668. Reported as `jr issue view --output json` omitting `duedate`
  from `.fields` (indistinguishable null-vs-unset). Human widened scope in-session
  to also surface `duedate` in human-readable `issue view`/`issue list` output, not
  only the JSON scripting surface. Routed through full F1-F7 Feature Mode (not the
  bug-fix shortcut) because the human-render half is new design surface requiring
  BC amendments/additions. See `.factory/feature-delta/668-duedate/delta-analysis.md`.
files_modified:
  - src/api/jira/issues.rs
  - src/types/jira/issue.rs
  - src/cli/issue/view.rs
  - src/cli/issue/format.rs
  - src/cli/issue/list.rs
  - src/cli/mod.rs
  - tests/issue_commands.rs
  - tests/common/fixtures.rs
test_files:
  - tests/issue_commands.rs
  - tests/common/fixtures.rs
---

# S-668-1 — Surface `duedate` in `jr issue view`/`jr issue list`

> **v1.0→v1.1 (2026-08-13, state-manager registration burst):** `status: draft`→`ready`.
> Spec-First Gate (S-7.01) verified satisfied: `behavioral_contracts:`/`bcs:` non-empty
> with 4 canonical `BC-\d+\.\d{2}\.\d{3}`-form IDs (BC-2.2.028, BC-2.2.032, BC-2.3.036,
> BC-2.3.039), all final at spec v1.3.179 (`.factory/specs/prd/bc-2-issue-read.md`,
> `scripts/check-spec-counts.sh` + `scripts/check-bc-cumulative-counts.sh` both green);
> every AC (AC-1..AC-16) carries a `*Traces to*:` BC citation and all 4 BCs are each
> cited by at least one AC (bidirectional AC↔BC trace confirmed). No BC/AC content
> changed this burst. Registered in `STORY-INDEX.md` (127→128).

## Narrative

As a `jr` user who sets due dates on Jira issues, I want `duedate` available both
as a scripting field (`jr issue view --output json` / `jr issue list --output
json`) and as a human-readable row/column (`issue view`'s detail table always,
`issue list`'s table opt-in via `--duedate`), so that I can see and script against
due dates without falling back to `jr api /rest/api/3/issue/KEY?fields=duedate`.

## Source of Truth

- F1 delta analysis: `.factory/feature-delta/668-duedate/delta-analysis.md`
  (authoritative for impact boundary, files changed, regression baseline)
- F2 BCs (authoritative for verbatim behavior, field order, column position,
  rendering, empty-value convention): `bc-2-issue-read.md` BC-2.2.028 [AMENDED],
  BC-2.2.032 [NEW], BC-2.3.036 [AMENDED], BC-2.3.039 [NEW] — spec v1.3.179
  (post human-directed verbatim-rendering simplification; the earlier
  `chrono::NaiveDate` parse-then-reformat design with `--verbose`-gated parse
  warnings was REMOVED — do not implement it)

**Read all four BCs in full before implementing** (Task 0 below) — do not work
from this story's summaries alone; the BC bodies are the source of the exact
field order, row/column position, and empty-value string.

## Behavioral Contracts

| BC ID | Title | Clause |
|-------|-------|--------|
| BC-2.2.028 | `search_issues` default fields list: 17 fields in EXACT order | [AMENDED] `duedate` inserted after `updated`, before `resolution` |
| BC-2.2.032 | `issue list --duedate` opts in a Due Date column | [NEW] flag, column position, verbatim rendering, `-` empty, JSON no-op, other-call-site scope |
| BC-2.3.036 | `get_issue` deserializes: …duedate… (all nullable) | [AMENDED] named `Option<String>` field, not `extra` flatten |
| BC-2.3.039 | `issue view` always shows a "Due Date" detail row | [NEW] unconditional row, position, verbatim rendering, `-` empty, shared helper |

## Behavior Summary (verbatim per BC — do not deviate)

- **`BASE_ISSUE_FIELDS`** (`src/api/jira/issues.rs`): insert the string literal
  `"duedate"` immediately after `"updated"` and before `"resolution"`. This is
  the single shared field-request constant consumed by BOTH `get_issue` and
  `search_issues` — one edit satisfies BC-2.2.028 and (as a request-side
  consequence) BC-2.3.036 simultaneously.
- **`IssueFields`** (`src/types/jira/issue.rs`): add a NAMED field
  `pub duedate: Option<String>,` alongside `created`/`updated`. Do NOT route
  through `#[serde(flatten)] extra` — a named field is required for the
  human-render path's `issue.fields.duedate.as_deref()` access, matching the
  issue #59 `created`/`updated`/`reporter` precedent. No `#[serde(rename)]`
  needed — Jira's wire field is already lowercase `duedate`.
- **Rendering is VERBATIM — no parser, no formatter, no `--verbose` threading.**
  Jira returns `duedate` as date-only `YYYY-MM-DD`; a parse-then-reformat round
  trip would produce a byte-identical string, so it is not implemented. This is
  explicitly NOT `format_comment_date` (`src/cli/issue/format.rs:~117`) — that
  function parses RFC3339 **datetime** strings; `duedate` has no time component
  and gets no formatter at all.
- **Shared render-string-or-dash helper**: BC-2.2.032 and BC-2.3.039 both
  require ONE shared trivial function (not duplicated per call site) —
  `None` or `Some("")` → `"-"`, else the string verbatim. Add it to
  `src/cli/issue/format.rs` (co-located with `format_comment_date` and
  `format_points`, the two existing per-field formatters) and import it into
  `view.rs`. Suggested signature: `pub(super) fn render_due_date(duedate:
  Option<&str>) -> String`. The `Some("")` branch is defensive-only — Jira
  never emits an empty-string `duedate` — mirroring the EC-2.7.001-3 convention
  already used elsewhere in this codebase.
- **`issue view` (BC-2.3.039)**: ALWAYS renders a "Due Date" row (unconditional,
  like `Created`/`Updated` — no width pressure on a single-issue detail view).
  Row position: immediately after `Updated` and before `Project`
  (`src/cli/issue/view.rs:~148-157`, between the existing `Updated` block and
  the existing `Project` block) — groups the three date-bearing rows together.
- **`issue list` (BC-2.2.032)**: NEW boolean flag `--duedate` (default off) on
  the `List` variant in `src/cli/mod.rs` (~:325-330, alongside the existing
  `points`/`assets` flags). Column position: `Key, Type, Status, Priority,
  [Due Date], [Points], Assignee, [Team], [Assets], Summary` — inserted
  immediately after Priority and before Points. This is a NEW optional
  parameter on `format_issue_row`/`issue_table_headers`
  (`src/cli/issue/format.rs:~21-104`), following the exact same mechanism the
  Points column already uses (`sp_field_id: Option<&str>` gates both the
  row-builder branch and `col_count`).
- **JSON mode is unaffected by `--duedate`**: `duedate` is unconditionally
  present in JSON output (both `issue view --output json` and `issue list
  --output json`) once `BASE_ISSUE_FIELDS` is amended — the flag gates ONLY the
  human table column. `--duedate --output json` is a silent no-op on JSON shape
  (no warning, not an error — same treatment `--points`/`--assets`/`--team`
  already receive combined with `--output json`).
- **Scope — `issue list` only (BC-2.2.032 Scope clause)**: `format_issue_row`
  and `issue_table_headers` have OTHER call sites beyond
  `list.rs::handle_list` (~:556-576) — `board.rs::handle_view`,
  `queue.rs::handle_view` (twice), and `sprint.rs::handle_current`. These do
  NOT gain a `--duedate` flag or a Due Date column under this story; their call
  sites pass the new parameter as absent (`None`), matching how they already
  pass `None`/`false` for Points/Team/Assets today. A forgotten call site is a
  compile error (new required parameter on a shared function), not a silent
  bug — this is enforced structurally, not by convention.

## Architecture Mapping

| Component | File | Action |
|-----------|------|--------|
| Shared field-request const | `src/api/jira/issues.rs::BASE_ISSUE_FIELDS` (~:13-30) | Add `"duedate"` literal after `"updated"`, before `"resolution"` (16→17 elements) |
| Struct field | `src/types/jira/issue.rs::IssueFields` (~:57-68) | Add `pub duedate: Option<String>,` alongside `created`/`updated` (Pure — no purity-boundary change; typed data struct) |
| Detail view row | `src/cli/issue/view.rs::handle_view` Table arm (~:148-157) | Insert Due Date row between the existing `Updated` and `Project` row blocks; use shared `render_due_date` helper (effectful-shell — HTTP-fetched issue rendered to stdout) |
| Row-builder / header-builder | `src/cli/issue/format.rs::format_issue_row` (~:21-82) / `issue_table_headers` (~:86-104) | Add `duedate: Option<&str>` parameter to both; extend `col_count`; insert into row/headers immediately after Priority, before Points (Pure — string formatting, no I/O) |
| Shared helper | `src/cli/issue/format.rs` (new, co-located with `format_comment_date` ~:117 and `format_points` ~:106) | Add `pub(super) fn render_due_date(duedate: Option<&str>) -> String` (Pure) |
| List call site | `src/cli/issue/list.rs::handle_list` (~:556-576) | Wire new `--duedate` flag through to `format::format_issue_row`/`issue_table_headers`, following the existing `show_points`/`show_assets_col`/`show_team_col` conditional-column pattern (effectful-shell) |
| CLI flag | `src/cli/mod.rs::IssueCommand::List` (~:325-330, alongside `points`/`assets`) | Add `#[arg(long)] duedate: bool,` |
| Other call sites (pass `None`, no column) | `src/cli/board.rs::handle_view`, `src/cli/queue.rs::handle_view` (×2), `src/cli/sprint.rs::handle_current` | Update call sites for the new required parameter; pass `None` — compile-error-enforced, no behavior change |
| `format_issue_rows_public` | `src/cli/issue/format.rs::format_issue_rows_public` (~:7-12) | Update its internal `format_issue_row(issue, None, None, None)` call to the new 5-arg signature, passing `None` for `duedate` |

## Verbatim Field Order / Position Reference (do not deviate)

**`BASE_ISSUE_FIELDS` (17 elements, exact order):**
```
summary, status, issuetype, priority, assignee, reporter, project, description,
created, updated, duedate, resolution, components, fixVersions, labels, parent,
issuelinks
```

**`issue list` column order (Due Date opt-in):**
```
Key, Type, Status, Priority, [Due Date], [Points], Assignee, [Team], [Assets], Summary
```

**`issue view` detail-table row order (excerpt):**
```
… Reporter, Created, Updated, Due Date, Project, Labels, …
```

## Acceptance Criteria

### AC-1: `issue view --output json` includes `.fields.duedate` when set

**Invocation**: `jr issue view PROJ-1 --output json` against a fixture with
`"duedate":"2027-07-30"` in the mocked response.

**Assertions**:
- Exit 0
- Parsed JSON `.fields.duedate == "2027-07-30"`

*Traces to*: BC-2.3.036 postcondition (named field deserializes present value); BC-2.2.028 (field requested at all)

---

### AC-2: `issue view --output json` shows `.fields.duedate` as JSON `null` when unset

**Invocation**: `jr issue view PROJ-1 --output json` against a fixture with
`"duedate": null` (or the key absent) in the mocked response.

**Assertions**:
- Exit 0
- Parsed JSON `.fields.duedate == null` (not omitted — no
  `#[serde(skip_serializing_if)]` on the new field, matching `created`/`updated`)

*Traces to*: BC-2.3.036 postcondition (nullable field, `None` serializes as JSON `null`, never omitted)

---

### AC-3: `issue list --output json` includes `duedate` per row

**Invocation**: `jr issue list --project PROJ --output json` against a fixture
where at least one returned issue has `"duedate":"2027-07-30"` and at least one
has `null`.

**Assertions**:
- Exit 0
- Each element of the JSON array's `.fields.duedate` matches its fixture value
  (string for set, `null` for unset)
- No `--duedate` flag passed to this invocation (proves JSON shape is
  unconditional on the flag)

*Traces to*: BC-2.2.028 (search fields list amendment); BC-2.2.032 JSON-mode clause (duedate present in JSON regardless of `--duedate`)

---

### AC-4: `issue view` human output shows a "Due Date" row — set value

**Invocation**: `jr issue view PROJ-1` (human/table mode) against a fixture with
`"duedate":"2027-07-30"`.

**Assertions**:
- Exit 0
- stdout contains a row with `"Due Date"` in the first column and
  `"2027-07-30"` in the second column, VERBATIM (byte-identical to the fixture
  string — no reformatting)
- The row appears between the `Updated` row and the `Project` row (position
  check — e.g. by line-index comparison of the three labels in stdout)

*Traces to*: BC-2.3.039 postcondition (always-on row, verbatim value, position)

---

### AC-5: `issue view` human output shows `-` for an unset Due Date

**Invocation**: `jr issue view PROJ-1` (human/table mode) against a fixture with
`"duedate": null`.

**Assertions**:
- Exit 0
- stdout contains a row with `"Due Date"` in the first column and exactly
  `"-"` in the second column (NOT `"(none)"` — explicitly the `Created`/
  `Updated`/`Points` convention, not the `Reporter`/`Labels` convention)

*Traces to*: BC-2.3.039 empty-rendering clause

---

### AC-6: `issue list --duedate` shows the column at the correct position with a verbatim value

**Invocation**: `jr issue list --project PROJ --duedate` (human/table mode)
against a fixture where at least one issue has `"duedate":"2027-07-30"`.

**Assertions**:
- Exit 0
- Header row contains columns in the order `Key, Type, Status, Priority, Due
  Date, Assignee, Summary` (no `--points`/`--assets`/`--team` flags in this
  invocation, so those columns are absent — proves Due Date's position is fixed
  relative to Priority/Assignee, independent of the other opt-in columns)
- The data row's Due Date cell reads `"2027-07-30"` VERBATIM

*Traces to*: BC-2.2.032 column-position clause (Priority, [Due Date], [Points], Assignee)

---

### AC-7: `issue list --duedate` shows `-` for an unset Due Date

**Invocation**: `jr issue list --project PROJ --duedate` against a fixture with
one issue's `"duedate": null`.

**Assertions**:
- Exit 0
- That issue's Due Date cell reads exactly `"-"`

*Traces to*: BC-2.2.032 empty-rendering clause

---

### AC-8: `issue list` WITHOUT `--duedate` omits the column entirely

**Invocation**: `jr issue list --project PROJ` (no `--duedate`) against the
same fixture used in AC-6.

**Assertions**:
- Exit 0
- Header row does NOT contain `"Due Date"`
- No data row contains the fixture's due-date string `"2027-07-30"` as a
  distinct table cell (column absent, not merely hidden)

*Traces to*: BC-2.2.032 opt-in clause (Due Date is NOT always-on, contrast with `issue view`)

---

### AC-9: `issue list --duedate --output json` is a silent no-op on JSON shape

**Invocation**: run the same fixture/query twice — once with `--duedate
--output json`, once with `--output json` alone (no `--duedate`).

**Assertions**:
- Exit 0 both times
- Parsed JSON output is IDENTICAL between the two invocations (byte-for-byte
  equal after parsing, or structurally equal via `serde_json::Value`
  comparison) — `--duedate` has zero effect on JSON shape
- Neither invocation emits a warning/hint about `--duedate` to stderr (same
  non-error treatment as `--points`/`--assets`/`--team` combined with
  `--output json`)

*Traces to*: BC-2.2.032 JSON-mode clause (flag gates ONLY the human table column)

---

### AC-10: shared render helper is used by both `view.rs` and `format.rs` call sites

**Verification** (code-level, not a runtime assertion — verify at PR review and
via a unit test on the helper itself):
- A single function (e.g. `render_due_date`) lives in `src/cli/issue/format.rs`
- `view.rs`'s Due Date row and `format.rs`'s Due Date column both call this one
  function — no duplicated `None`/`Some("")` → `"-"` logic in either call site
- Unit test(s) directly on the helper: `render_due_date(None) == "-"`,
  `render_due_date(Some("")) == "-"`, `render_due_date(Some("2027-07-30")) ==
  "2027-07-30"`

*Traces to*: BC-2.2.032 / BC-2.3.039 shared-helper clause (one function, not duplicated per call site)

---

### AC-11 (MANDATORY test update): `test_search_issues_includes_labels_parent_issuelinks` updated to the 17-element field array

`tests/issue_commands.rs::test_search_issues_includes_labels_parent_issuelinks`
currently asserts the EXACT 16-element `fields` array via `body_partial_json`
and WILL fail (array-length mismatch) once `duedate` is appended to
`BASE_ISSUE_FIELDS`. This is a MANDATORY update, not merely at-risk.

**Required change**: add `"duedate"` to the expected array literal in this
test, positioned after `"updated"` and before `"resolution"`, matching
BC-2.2.028's amended enumeration exactly.

*Traces to*: BC-2.2.028 [AMENDED] postcondition (exact 17-element array, exact order)

---

### AC-12: `get_issue_includes_standard_fields` extended with `duedate` present assertion

Extend the existing test (issue #59 pattern) to additionally assert that when
the fixture includes `"duedate":"2027-07-30"`, the deserialized
`IssueFields.duedate == Some("2027-07-30".to_string())`. Extend
`tests/common/fixtures.rs::issue_response_with_standard_fields` with a
`"duedate"` key as the natural extension point.

*Traces to*: BC-2.3.036 [AMENDED] postcondition (named field deserializes present value)

---

### AC-13: `get_issue_null_standard_fields` extended with `duedate` absent assertion

Extend the existing test (issue #59 pattern) to additionally assert that when
the fixture omits `duedate` (or sets it `null`), the deserialized
`IssueFields.duedate == None` (no panic).

*Traces to*: BC-2.3.036 [AMENDED] postcondition (nullable field, absent-tolerant deserialization)

---

### AC-14: `IssueFields.duedate` is a named struct field, not routed through `extra`

**Verification** (code-level): `src/types/jira/issue.rs::IssueFields` declares
`pub duedate: Option<String>,` as an explicit named field. `issue.fields.extra`
(the `#[serde(flatten)]` catch-all) does NOT contain a `"duedate"` key once the
named field exists (serde's flatten semantics route a matched field to its
named slot, not into the flatten map) — covered implicitly by AC-1/AC-12
exercising `issue.fields.duedate` directly rather than
`issue.fields.extra.get("duedate")`.

*Traces to*: BC-2.3.036 named-field clause (not `#[serde(flatten)] extra`)

---

### AC-15: `BASE_ISSUE_FIELDS` positions `duedate` after `updated`, before `resolution`

**Verification** (code-level, also exercised end-to-end by AC-11): the array
literal in `src/api/jira/issues.rs` reads `…, "created", "updated", "duedate",
"resolution", "components", …` — exact adjacency to the other two date-bearing
fields (`created`, `updated`).

*Traces to*: BC-2.2.028 [AMENDED] position clause

---

### AC-16: other `format_issue_row`/`issue_table_headers` call sites are unaffected (no Due Date column leaks in)

**Invocation**: exercise `jr board view <id>`, `jr queue view <id>`, and `jr
sprint current --board <id>` (whichever of these already have wiremock
coverage in the existing suite) against a fixture where at least one issue has
a set `duedate`.

**Assertions**:
- None of these three commands' human-table output contains a `"Due Date"`
  header or column, regardless of the fixture's `duedate` value
- Their JSON output (if applicable) is unaffected by this story beyond the
  same `BASE_ISSUE_FIELDS`-driven `duedate` field presence already covered by
  AC-1/AC-3 (these commands share the same underlying `Issue`/`IssueFields`
  types, so `duedate` appears in their JSON the same way, but the flag/column
  mechanism does not apply to them)

*Traces to*: BC-2.2.032 Scope clause (`issue list` only; other call sites pass the new parameter as absent)

---

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|-------------------|
| EC-1 | `duedate` present and non-empty in fixture | Verbatim string rendered in both `view` row and `list --duedate` column |
| EC-2 | `duedate` absent (key missing) from JSON response | Deserializes to `None`; renders `-` in both surfaces; JSON output shows `null` |
| EC-3 | `duedate` explicitly `null` in JSON response | Same as EC-2 |
| EC-4 | `duedate` is `Some("")` (empty string — defensive-only, Jira never emits this) | Renders `-` (treated as absent by the shared helper) |
| EC-5 | `issue list --duedate` combined with `--points`/`--assets`/`--team` | All requested columns appear; Due Date sits at its fixed position (after Priority, before Points) regardless of which other optional columns are present |
| EC-6 | `issue list --duedate --output json` | JSON shape identical to `issue list --output json` without the flag (silent no-op) |
| EC-7 | `board view`/`queue view`/`sprint current` with a fixture containing `duedate` | No Due Date column appears (BC-2.2.032 Scope clause); `duedate` still flows through JSON output if those commands support `--output json` |

---

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|----------------|
| `src/cli/issue/format.rs::render_due_date` (new) | Pure | String-in, string-out; no I/O |
| `src/cli/issue/format.rs::format_issue_row` / `issue_table_headers` | Pure | Existing classification unchanged; new parameter is additive |
| `src/types/jira/issue.rs::IssueFields` | Pure (data) | Typed deserialization struct; no behavior change to purity boundary |
| `src/api/jira/issues.rs::BASE_ISSUE_FIELDS` | Pure (const) | Compile-time data |
| `src/cli/issue/view.rs::handle_view` | effectful-shell | Unchanged classification; new row inserted into existing effectful handler |
| `src/cli/issue/list.rs::handle_list` | effectful-shell | Unchanged classification; new flag wired into existing effectful handler |

---

## Token Budget Estimate

| Item | Tokens (approx) |
|------|----------------|
| This story file | ~5k |
| BC-2.2.028 + BC-2.2.032 + BC-2.3.036 + BC-2.3.039 bodies (read for verbatim order/position) | ~5k |
| delta-analysis.md (relevant sections) | ~3k |
| `src/api/jira/issues.rs` (BASE_ISSUE_FIELDS window) | ~1k |
| `src/types/jira/issue.rs` (IssueFields struct window) | ~1k |
| `src/cli/issue/view.rs` (rows vec window) | ~2k |
| `src/cli/issue/format.rs` (full file — small) | ~2k |
| `src/cli/issue/list.rs` (call-site window, ~550-580) | ~2k |
| `src/cli/mod.rs` (List variant window) | ~1k |
| `src/cli/board.rs`, `src/cli/queue.rs`, `src/cli/sprint.rs` (call-site windows) | ~2k |
| `tests/issue_commands.rs` (target test + surrounding fixture context) | ~4k |
| `tests/common/fixtures.rs` (issue_response_with_standard_fields) | ~1k |
| Tool outputs + `cargo test`/`cargo clippy` output | ~4k |
| **Total** | **~33k** |

Small enough for a single implementation session — no split required.

---

## Tasks (MANDATORY)

### Task 0: Read all four BCs in full

Read `bc-2-issue-read.md` BC-2.2.028, BC-2.2.032, BC-2.3.036, BC-2.3.039
completely (not summaries). Confirm the v1.3.179 verbatim-rendering
simplification is what's implemented — do NOT build a `chrono::NaiveDate`
parser or thread a `verbose: bool` parameter; that design was explicitly
removed by the human-directed fix-round.

### Task 1: Amend `BASE_ISSUE_FIELDS` and `IssueFields` (Red Gate first)

Update `tests/issue_commands.rs::test_search_issues_includes_labels_parent_issuelinks`
(AC-11) and extend `get_issue_includes_standard_fields`/
`get_issue_null_standard_fields` (AC-12/AC-13) plus
`tests/common/fixtures.rs::issue_response_with_standard_fields` FIRST — confirm
RED. Then add `"duedate"` to `BASE_ISSUE_FIELDS` (`src/api/jira/issues.rs`) and
`pub duedate: Option<String>,` to `IssueFields` (`src/types/jira/issue.rs`).
Confirm GREEN.

### Task 2: Add the shared `render_due_date` helper (AC-10)

Add `pub(super) fn render_due_date(duedate: Option<&str>) -> String` to
`src/cli/issue/format.rs`, co-located with `format_comment_date`/
`format_points`. Write direct unit tests for `None`, `Some("")`, and
`Some("2027-07-30")` inputs.

### Task 3: Wire the Due Date row into `issue view` (AC-4, AC-5)

Insert the new row into `handle_view`'s `rows` vec in `src/cli/issue/view.rs`,
between the existing `Updated` and `Project` blocks, using `render_due_date`.

### Task 4: Extend `format_issue_row`/`issue_table_headers` (AC-6, AC-7, AC-8, AC-10)

Add a `duedate: Option<&str>` parameter to both functions in
`src/cli/issue/format.rs`. Update `col_count` in `format_issue_row`. Insert
the row-push/header-push immediately after Priority, before Points, gated on
`Some`/`true`. Update `format_issue_rows_public`'s internal call to pass
`None`.

### Task 5: Wire `--duedate` CLI flag and call site (AC-6, AC-7, AC-8, AC-9)

Add `#[arg(long)] duedate: bool,` to the `List` variant in `src/cli/mod.rs`.
Thread it through `handle_list` in `src/cli/issue/list.rs` following the
`show_points`/`show_assets_col`/`show_team_col` pattern, and pass it to
`format::format_issue_row`/`issue_table_headers`.

### Task 6: Update the other call sites (AC-16)

Update `src/cli/board.rs::handle_view`, `src/cli/queue.rs::handle_view` (both
call sites), and `src/cli/sprint.rs::handle_current` to pass `None` for the
new parameter. These are compile-error-forced; verify with `cargo build`.

### Task 7: JSON-shape tests (AC-1, AC-2, AC-3, AC-9)

Add/extend integration tests asserting `.fields.duedate` presence in
`issue view --output json` and `issue list --output json`, and the
`--duedate --output json` no-op comparison.

### Task 8: Human-output tests (AC-4, AC-5, AC-6, AC-7, AC-8)

Add integration tests for the `issue view` row and `issue list --duedate`
column, both set and unset values, and the column-absent-without-flag case.

### Task 9: Full suite green

```
cargo test
cargo clippy -- -D warnings
cargo fmt --all -- --check
cargo deny check
```

### Task 10: Create PR

Commit style: `feat(issue): surface duedate in issue view/list (closes #668)`.
Not a breaking change — no version-bump/CHANGELOG breaking-change entry
required (ordinary feature entry in `CHANGELOG.md` under `### Added` is
appropriate, per repo convention — confirm against recent entries at PR time).

---

## Previous Story Intelligence (MANDATORY)

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|--------------|----------------------|---------------------|
| Issue #59 (no STORY-INDEX entry — predates this decomposition scheme) | Added `created`, `updated`, `reporter` as NAMED `IssueFields` fields (not `extra` flatten) specifically to support human-render access via `.as_deref()` | Named-field-over-flatten precedent this story follows for `duedate`; `get_issue_includes_standard_fields`/`get_issue_null_standard_fields` present/absent test pair this story extends | `format_comment_date` was built for RFC3339 **datetime** strings (`created`/`updated`) — do NOT reuse it for `duedate`, which is date-only `YYYY-MM-DD` with no time component (this was an explicit BC drafting error caught and corrected during F2 adversarial review; see BC-2.2.032/BC-2.3.039 rendering clauses) |
| `--points`/`--assets` opt-in column mechanism (BC-2.2.021/022, BC-2.1.016/017; no dedicated STORY-INDEX entry — long-shipped feature) | Established the `Option<&str>`/`bool`-gated optional-column pattern in `format_issue_row`/`issue_table_headers` that `--duedate` reuses | Config-gated (`--points`) vs pure-boolean-gated (`--assets`, and now `--duedate`) opt-in columns coexist in the same functions | `format_issue_row`/`issue_table_headers` have call sites OUTSIDE `list.rs` (`board.rs`, `queue.rs`, `sprint.rs`) — any signature change is a breaking compile-time change across four files, not just `list.rs`; this was the source of BC-2.2.032's explicit Scope clause after an F2 adversarial finding (F3) caught its initial omission |

---

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|--------------|
| `BASE_ISSUE_FIELDS` is the SINGLE shared field-request constant for both `get_issue` and `search_issues` — one edit fixes both | BC-2.2.028 amendment note; existing rustdoc on the const | AC-1 and AC-3 both pass from the same one-line change; no separate edit needed per command |
| `duedate` is a NAMED `IssueFields` field, never routed through `#[serde(flatten)] extra` | BC-2.3.036 named-field clause | AC-14; code review confirms no `extra.get("duedate")` access anywhere in the diff |
| Rendering is VERBATIM — no parser, no `chrono` dependency for this field, no `--verbose` gating | BC-2.2.032 / BC-2.3.039 Rendering clauses (human-directed simplification, v1.3.179) | AC-4/AC-6 assert byte-identical fixture-to-output; code review confirms no `NaiveDate::parse_from_str` or `log_parse_failure_once` call added for this field |
| Shared `render_due_date` helper used by BOTH `view.rs` and `format.rs` call sites — no duplicated empty-check logic | BC-2.2.032 / BC-2.3.039 shared-helper clause | AC-10; code review confirms a single function definition with two call sites |
| `--duedate` gates ONLY the human table column; JSON output is unconditional | BC-2.2.032 JSON-mode clause | AC-3, AC-9 |
| `issue list` column position: `…, Priority, [Due Date], [Points], Assignee, …` — Due Date is NOT adjacent to Summary/Assets | BC-2.2.032 column-position clause | AC-6 header-order assertion |
| `issue view` row position: immediately after `Updated`, before `Project` | BC-2.3.039 row-position clause | AC-4 position assertion |
| `format_issue_row`/`issue_table_headers` signature changes propagate to ALL call sites (`list.rs`, `board.rs`, `queue.rs`, `sprint.rs`, `format_issue_rows_public`) — a missed call site is a compile error | BC-2.2.032 Scope clause | AC-16; `cargo build` fails loudly on any missed site |
| Unset/empty `duedate` renders `-`, NOT `(none)` | BC-2.2.032 / BC-2.3.039 empty-rendering clauses | AC-5, AC-7 |

---

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|---------|
| serde / serde_json (existing) | as in `Cargo.lock` | `Option<String>` field deserialization; no new attribute beyond the existing pattern used by `created`/`updated` |
| comfy-table (existing) | as in `Cargo.lock` | Table rendering — unaffected; new column/row is ordinary `Vec<String>` data, no new comfy-table API surface |
| wiremock (existing) | as in `Cargo.lock` | Integration test HTTP mocking for the new/extended fixtures |
| assert_cmd (existing) | as in `Cargo.lock` | CLI integration test harness |

No new crate dependencies. This story adds nothing to `Cargo.toml`. Explicitly
NOT adding a `chrono` dependency for this field's rendering (verbatim display
only — see Rendering clause above).

---

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|---------|
| `src/api/jira/issues.rs` | MODIFY | Add `"duedate"` to `BASE_ISSUE_FIELDS` (AC-11, AC-15) |
| `src/types/jira/issue.rs` | MODIFY | Add `pub duedate: Option<String>,` to `IssueFields` (AC-1, AC-2, AC-12, AC-13, AC-14) |
| `src/cli/issue/view.rs` | MODIFY | Insert Due Date row in `handle_view`'s Table arm, between `Updated` and `Project` (AC-4, AC-5) |
| `src/cli/issue/format.rs` | MODIFY | Add `render_due_date` shared helper; add `duedate` parameter to `format_issue_row`/`issue_table_headers`; update `format_issue_rows_public`'s internal call (AC-6, AC-7, AC-8, AC-10) |
| `src/cli/issue/list.rs` | MODIFY | Wire `--duedate` flag through to `format::format_issue_row`/`issue_table_headers` (AC-6, AC-7, AC-8, AC-9) |
| `src/cli/mod.rs` | MODIFY | Add `#[arg(long)] duedate: bool,` to the `List` variant (AC-6, AC-7, AC-8, AC-9) |
| `src/cli/board.rs` | MODIFY | Update `handle_view`'s call to `format_issue_row`/`issue_table_headers` to pass `None` for the new parameter (AC-16) |
| `src/cli/queue.rs` | MODIFY | Update BOTH `handle_view` call sites similarly (AC-16) |
| `src/cli/sprint.rs` | MODIFY | Update `handle_current`'s call similarly (AC-16) |
| `tests/issue_commands.rs` | MODIFY | Update `test_search_issues_includes_labels_parent_issuelinks` (AC-11, MANDATORY); extend `get_issue_includes_standard_fields`/`get_issue_null_standard_fields` (AC-12, AC-13); add new JSON-shape and human-output tests (AC-1–AC-9, AC-16) |
| `tests/common/fixtures.rs` | MODIFY | Add `"duedate"` key to `issue_response_with_standard_fields` (AC-12, AC-13) |

**MUST NOT change**: `src/output.rs` (no renderer change — `duedate` flows
through existing generic JSON/table serialization); `src/adf.rs` (no ADF
content involved); `src/cache.rs`, `src/config.rs` (no new cache family, no new
config field); `src/cli/issue/{create,edit,jsm_create}.rs` (this is a read-side
feature only — `issue edit --field duedate=...` already works via the generic
`--field` mechanism and is unaffected); BC files in `.factory/specs/prd/` (F2
sealed for this feature at v1.3.179 — escalate any BC/code discrepancy found
during implementation to the orchestrator rather than re-editing the BC file).

## Per-Story Delivery Notes

- Per-story adversary 3/3 CLEAN required before push (standard convergence gate).
- No E2E impact expected — `tests/e2e_live.rs` was not scanned as part of this
  F3 story (no delivery-item obligation was flagged in the F1 delta analysis
  for E2E); confirm at F4 that no `issue view`/`issue list` E2E assertion
  hard-codes the exact JSON field count or table column count in a way that
  `duedate`'s addition would break.
- This story has NO upstream story dependencies (`depends_on: []`) — it is a
  leaf enhancement on existing, already-shipped read paths (`get_issue`,
  `search_issues`, `handle_view`, `handle_list`).
