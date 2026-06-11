---
document_type: story
story_id: "S-475"
title: "ADF E2E read-path coverage: adf_to_text live test + listItem normalization live assert + comment read path + test rename"
wave: feature-followup
status: draft
intent: enhancement
feature_type: test-infrastructure
mode: feature
scope: small
severity: LOW
trivial_scope: false
issue: 475
points: 3
priority: P1
tdd_mode: strict
estimated_effort: small
estimated_days: 1
target_module: e2e
subsystems: []
depends_on: []
blocks: []
bc_anchors:
  - BC-7.2.003
  - BC-7.2.004
  - BC-7.2.006
bcs:
  - BC-7.2.003
  - BC-7.2.004
  - BC-7.2.006
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-story-decomposition
spec_source: ".factory/phase-f2-spec-evolution/475-adf-e2e-readpath/e2e-coverage-spec.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 4
assumption_validations: []
risk_mitigations: []
created: "2026-06-11"
last_updated: "2026-06-11"
breaking_change: false
retroactive: false
predecessor_cycles: "PR #495 (issue #475 partial — 5 gated live E2E tests for taskList, subsup, GFM alerts, block HTML, ordered task lists)"
# BC status: BCs present (BC-7.2.003, BC-7.2.004, BC-7.2.006 — existing BCs exercised, no new BCs authored)
---

# S-475 — ADF E2E Read-Path Coverage

## Source of Truth

E2E coverage spec (authoritative AC source): `.factory/phase-f2-spec-evolution/475-adf-e2e-readpath/e2e-coverage-spec.md`
PRD delta: `.factory/phase-f2-spec-evolution/475-adf-e2e-readpath/prd-delta.md`
F1 delta analysis: `.factory/phase-f1-delta-analysis/475-adf-e2e-readpath/delta-analysis.md`
Research — external API assumptions: `.factory/research/issue-475-adf-e2e-external-validation.md`

BC source file: `.factory/specs/prd/bc-7-output-render.md`

## Summary

Test-only story. No production code changes. No new BCs. No count-surface changes.

Closes two coverage gaps identified in issue #475 (after PR #495 partial delivery):

**Gap 1 — `adf_to_text` read path never exercised live.** All existing live E2E tests assert
against the serialized ADF JSON (via `--output json` + `poll_view`). The `adf_to_text`
function — called by `cli/issue/view.rs` (human/table mode) and `cli/issue/comments.rs`
(human/table mode) — is never called through the live path. AC-1 and AC-3 close this gap.

**Gap 2 — `normalize_list_item_content` (#470) never exercised against Jira Cloud.** No
live E2E test submits a markdown description containing a blockquote inside a list item and
asserts that the created issue returns HTTP 2xx and that the normalized ADF has no
`blockquote` node inside any `listItem`. AC-2 closes this gap as a sub-case within the
AC-1 test lifecycle.

**AC-4** corrects a misleading test name (`roundtrip` implies a full read-back; the test
only verifies the forward markdown→ADF direction).

## Behavioral Contracts

| BC | Statement |
|----|-----------|
| BC-7.2.003 | ADF markdown round-trip covers: headings, lists, code blocks, blockquotes, tables, links — exercised live for the first time in human output mode (AC-1, AC-4). |
| BC-7.2.004 | `adf_to_text` rendering: table render, code, headings preserved — directly targeted by Gap 1 (AC-1 via `jr issue view` human mode; AC-3 via `jr issue comments` human mode). |
| BC-7.2.006 | `markdown_to_adf` produces only permitted child node types inside any `listItem` — first live E2E exercise of `normalize_list_item_content` against Jira Cloud (AC-2). |

## Story Narrative

As a contributor maintaining the jira-cli E2E test suite,
I want live E2E tests that exercise `adf_to_text` via `jr issue view` and `jr issue comments`
in human/table mode (not just `--output json`), and that exercise `normalize_list_item_content`
against a real Jira Cloud instance,
so that regressions in the ADF read path and in ADF content-model normalization are caught
before they reach production.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~2,800 |
| `tests/e2e_live.rs` (relevant sections; full file ~9,200 LOC) | ~3,500 |
| E2E coverage spec (`.factory/phase-f2-spec-evolution/475-adf-e2e-readpath/e2e-coverage-spec.md`) | ~2,200 |
| BC file excerpts (BC-7.2.003, BC-7.2.004, BC-7.2.006 from `bc-7-output-render.md`) | ~600 |
| `docs/specs/e2e-live-jira-testing.md` (~123 line for rename touch-point) | ~400 |
| **Total** | **~9,500** |

Well within a 20% agent context window budget. No splitting required.

## Previous Story Intelligence

**Predecessor: PR #495 (issue #475 partial delivery)**
Added 5 gated live E2E tests: `test_e2e_markdown_task_list_*`, `test_e2e_markdown_subsup_*`,
`test_e2e_markdown_gfm_alert_*`, `test_e2e_markdown_block_html_*`. All 5 assert against
serialized ADF JSON shape (via `poll_view` + `adf_has_node_type` / `adf_has_task_item`).
None exercise `adf_to_text` via human-mode `jr issue view` or `jr issue comments`. This
story adds the missing human-mode read path.

**Pattern for human-mode assertion (new in this story):**
Prior E2E tests all use `jr issue view <key> --output json` or read JSON via `poll_view`.
This story introduces the first `jr issue view <key>` WITHOUT `--output json`, capturing
stdout as a text string and asserting content-word substrings. This is a new assertion
pattern in `tests/e2e_live.rs`. The implementer should follow the pattern at `e2e_live.rs:~481-485`
for spawning and capturing the command output.

**Predecessor: issue #470 (BC-7.2.006, PR #477)**
Introduced `normalize_list_item_content`. AC-2 of this story exercises that function
end-to-end against a live Jira Cloud instance for the first time. The comment block at
`tests/e2e_live.rs:8898-8900` explicitly says "normalization-correctness assertions are
deferred as a follow-up" — this story closes that deferral.

**`adf_has_blockquote_in_list_item` helper — NEW in this story (author in F4):**
Modelled on `adf_has_task_item` (line 8912). Walks the ADF JSON recursively; returns
`true` if any `listItem` node has a direct child whose `type == "blockquote"`. The "direct
child" requirement means checking `listItem["content"]` array entries, not arbitrary
descendants. See AC-2 assertion design for the exact semantic.

**Server-side ADF mutation guardrail (from research, Claim 3 CONFIRMED):**
Jira Cloud silently normalizes submitted ADF at store time: injecting `localId`, reordering
marks, coalescing adjacent paragraphs, and dropping schema-invalid nodes (rather than
returning HTTP 400). Atlassian publishes no exhaustive list of store-time transforms.
MANDATORY CONSTRAINT: ALL assertions in this story MUST be structural invariants (node-type
presence/absence) or `adf_to_text` rendered-text substrings. NEVER assert raw returned-ADF-tree
equality or use JSON snapshots of the full ADF tree. This constraint is coded into each AC
below.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Test-only scope | F1 delta analysis §Impact Boundary | All changes confined to `tests/e2e_live.rs` and `docs/specs/e2e-live-jira-testing.md`. No `src/` changes. No new production modules. |
| E2E gate mandatory | S-410; CLAUDE.md | Every new test function must carry `#[ignore]` + `if !e2e_enabled() { return; }` as the first statement in the body. Tested by the gate guard in `tests/e2e_live.rs:~1222`. |
| Label required for sweeper teardown | e2e-coverage-spec.md §Teardown; Adversary F1 fix | The issue created in `test_e2e_adf_read_path_human_output` MUST be labeled with `run_label()` so the CI sweeper can reap it. Without the label the issue becomes a permanent orphan on the live Jira site. |
| No `@mentions` in fixtures | research Claim 5 (GDPR) | Fixtures must not contain user-mention nodes. GDPR/privacy processing makes user-mention rendering non-deterministic across accounts. |
| No exact-ADF-tree equality | research Claim 3 (server-side mutations) | Never use `assert_eq!(description_json, expected_adf)`. Node-type presence/absence and rendered-text content-word substring assertions are the correct granularity. |
| No `expand=renderedFields` / `expand=renderedBody` | research Claims 1 and 4 | `get_issue` and `list_comments` already use raw ADF paths (no expand). Do not add expand parameters. The research confirms the code is correct as-is. |
| Assertion strategy: content-word substrings | e2e-coverage-spec.md §Server-Side ADF Mutation Guardrail | Human-mode assertions must match on content words from the original markdown (e.g. "Section Header"), NOT on ADF structural terms (`paragraph`, `heading`, `blockquote`, `listItem`). |
| SURFACE guard: no new rows needed | e2e-coverage-spec.md §AC-4; F1 delta analysis | The three CLI paths used by the new test (`issue view`, `issue comment`, `issue comments`) are already registered in `tests/e2e_cli_surface_guard.rs`. The rename does not affect the SURFACE table (it is keyed on CLI command paths, not test function names). |

## Library and Framework Requirements

| Library | Version | Constraint |
|---------|---------|-----------|
| `serde_json` | current (from `Cargo.toml`) | Used by `poll_view` return type (`Value`). No version change. |
| `tokio` | current (from `Cargo.toml`) | `#[tokio::test]` attribute on new test. No version change. |

No new crate dependencies. No `Cargo.toml` changes.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `tests/e2e_live.rs` | MODIFY | (1) Add `test_e2e_adf_read_path_human_output` — new gated test function containing AC-1, AC-2, AC-3 assertion sub-sequences; (2) Add `adf_has_blockquote_in_list_item` helper (new, modelled on `adf_has_task_item` at line 8912); (3) Rename `test_e2e_issue_markdown_description_roundtrip` → `test_e2e_markdown_description_produces_heading_node` (AC-4); add a clarifying comment in the renamed function body noting it verifies only the forward markdown→ADF direction. |
| `docs/specs/e2e-live-jira-testing.md` | MODIFY | Update the bullet at ~line 123 from `test_e2e_issue_markdown_description_roundtrip` to `test_e2e_markdown_description_produces_heading_node` (AC-4 touch-point). |
| `tests/e2e_cli_surface_guard.rs` | UNCHANGED | SURFACE table is keyed on CLI command paths, not test function names. Rename in AC-4 requires no SURFACE row update. Verify `test_parser_paths_are_subset_of_surface_table` still passes after the rename. |

## Acceptance Criteria

### AC-1 — New gated live E2E test: `adf_to_text` rendered output via `jr issue view` human mode
(traces to BC-7.2.003 postcondition — "ADF markdown round-trip covers: headings, lists, code blocks, blockquotes, links";
 traces to BC-7.2.004 postcondition — "`adf_to_text` rendering … code, headings preserved")

Test function: `test_e2e_adf_read_path_human_output` (contains AC-1, AC-2, AC-3 sub-sequences).

**Setup:**
1. Build a markdown description string containing:
   - A level-2 heading: `## Section Header`
   - An unordered list item with a nested blockquote: `- > nested blockquote text`
     (this is the AC-2 normalization sub-case; the blockquote is inside a list item)
   - A fenced code block: `` ```\ncode snippet\n``` ``
   - A hyperlink: `[link text](https://example.com)`
   - A short paragraph of plain prose

2. Create a Jira issue via `jr issue create --project <project()> --summary "ADF read path E2E" --description-stdin --markdown --label <run_label()> --output json`.
   The `--label <run_label()>` flag is REQUIRED for the CI sweeper to clean up the issue.
   Capture the returned JSON key.

3. Assert the create command exits 0. If not, early-return (AC-2 and AC-3 reuse this key).

4. Wait for GET-consistency via the existing `poll_view(key, &harness)` helper (line ~474).
   The poll gates on the presence of `listItem` nodes before any absence assertion runs (see AC-2).

**Assertion — AC-1:**
```
// Human-mode invocation — NO --output json
let output = harness.cmd().args(["issue", "view", &key]).output()
    .expect("jr issue view failed");
let stdout = String::from_utf8_lossy(&output.stdout);

// Use SINGLE-TOKEN content words — not multi-word phrases.
// comfy-table (src/output.rs ContentArrangement::Dynamic) may word-wrap the
// description cell and insert a newline between adjacent words, which would
// cause `contains("Section Header")` to fail even though both words appear.
// Single tokens are never split by the cell-wrap algorithm.
assert!(stdout.contains("Header"),
    "heading word 'Header' must appear in human-mode view output");
assert!(stdout.contains("snippet"),
    "code-block word 'snippet' must appear in human-mode view output");
assert!(stdout.contains("blockquote"),
    "blockquote prose word 'blockquote' must appear in human-mode view output after normalization");
// "link" is the anchor text set in the fixture ("[link text](...)").
// It is short enough to never be wrapped by comfy-table.
assert!(stdout.contains("link"),
    "hyperlink anchor word 'link' must appear in human-mode view output");
```

**Wrap-resilience rationale:** `jr issue view` renders the ADF description via `adf_to_text`
into a single comfy-table cell (`view.rs:87`, `ContentArrangement::Dynamic`). When a TTY or
`COLUMNS` env var is present, comfy-table may word-wrap long lines by inserting newlines
between words, silently breaking `contains("two words")`. The single-token assertion strategy
avoids this failure mode. Choose fixture prose words that are long enough to be distinctive
(not "text", "item") but are contained within a single whitespace-delimited token.

**AC-3 is already wrap-resilient:** `**body**` (8 chars) and `*emphasis*` (10 chars) and
`_emphasis_` (10 chars) are single whitespace-delimited tokens. comfy-table only breaks at
whitespace boundaries, never mid-token. No change needed for AC-3.

Assertion strategy: single-token content words from the original markdown prose — NOT ADF
structural terms. Robust to `localId` injection, mark reordering, paragraph coalescing, AND
comfy-table cell-wrap. See Server-Side ADF Mutation Guardrail (Architecture Compliance Rules above).

---

### AC-2 — listItem normalization sub-case: `normalize_list_item_content` exercised against Jira Cloud
(traces to BC-7.2.006 postcondition — "`markdown_to_adf` produces only permitted child node types inside any `listItem`")

Sub-sequence within `test_e2e_adf_read_path_human_output`, after AC-1 assertions.
Reuses the issue key and `poll_view` result from AC-1.

**Primary assertion:** Create exits 0 (no Jira HTTP 400). A 400 would indicate the
`blockquote`-inside-`listItem` was not normalized before submission — i.e. invalid ADF
was sent. The create assertion from AC-1 setup covers this.

**Structural inspection via `jr issue view <key> --output json`:**

Step 1 — positive gate (presence): confirm `listItem` nodes exist in the returned ADF.
This prevents vacuous absence assertions on stale or empty ADF.

```
let json_output = poll_view(&key, &harness);
let description_json = &json_output["fields"]["description"];

let has_list_item = adf_has_node_type(description_json, "listItem");
assert!(has_list_item,
    "ADF must contain listItem nodes (positive gate before absence assertion)");
```

Step 2 — content sanity check: confirm the blockquote's text content was not silently dropped.

```
assert!(
    adf_contains_text(description_json, "nested blockquote text"),
    "blockquote text content must appear somewhere in the ADF (sanity check: content not dropped)"
);
```

Step 3 — absence assertion (the definitive normalization check): no `blockquote` node appears
as a direct child of any `listItem` in the returned ADF tree.

```
assert!(
    !adf_has_blockquote_in_list_item(description_json),
    "listItem.content must not contain a blockquote node after normalize_list_item_content"
);
```

`adf_has_blockquote_in_list_item` is a NEW helper to be authored in F4 (see File Structure
Requirements). It walks `listItem` nodes and returns `true` if any `listItem["content"]`
array entry has `type == "blockquote"`. The "direct child" check is intentional — it does
not flag a `blockquote` deeper in the tree (e.g. inside a paragraph), only one that is an
immediate child of a `listItem` content slot.

The negative assertion (`!adf_has_blockquote_in_list_item`) is robust to server-side mutations:
`localId` injection or paragraph coalescing inside the list do not affect whether a
`blockquote` node is or is not a direct child of a `listItem`.

---

### AC-3 — Comments human-mode read path: `adf_to_text` via `jr issue comments`
(traces to BC-7.2.004 postcondition — "`adf_to_text` rendering … code, headings preserved"; comment body path)

Sub-sequence within `test_e2e_adf_read_path_human_output`, after AC-2 assertions.
Reuses the issue key from AC-1.

**Steps:**
1. Seed a comment: `jr issue comment <key> "Comment **body** with _emphasis_" --markdown`
   The `--markdown` flag converts the comment body through `markdown_to_adf` before submission.
   Assert the comment command exits 0.

2. Read comments in human/table mode: `jr issue comments <key>` (NO `--output json`).
   Capture stdout.

**Assertions:**
```
assert!(stdout_comments.contains("**body**"),
    "strong text must render as **body** in comments human-mode output");
assert!(stdout_comments.contains("*emphasis*"),
    "em text must render as *emphasis* (single asterisk) in comments human-mode output");
assert!(!stdout_comments.contains("_emphasis_"),
    "underscore em syntax must not appear — adf_to_text re-emits em as *x*, not _x_");
```

**Why `_emphasis_` must NOT appear:** The input uses `_emphasis_` (underscore form).
`markdown_to_adf` parses this into an `em` mark. When `adf_to_text` renders the stored ADF
back, it emits `*emphasis*` (single-asterisk form), NOT `_emphasis_`. A raw passthrough
(no `adf_to_text` call) would contain `_emphasis_`. The negative assertion on `_emphasis_`
therefore distinguishes the live `adf_to_text` round-trip from a passthrough — it is the
key differentiator that confirms the read path is actually exercised.

The `**body**` positive assertion confirms strong rendering is intact and the output is
non-empty, and that marks are applied correctly.

---

### AC-4 — Rename `test_e2e_issue_markdown_description_roundtrip` → `test_e2e_markdown_description_produces_heading_node`
(traces to BC-7.2.003 postcondition — "ADF markdown round-trip covers: headings" — name now accurately reflects the forward-only assertion)

**Mechanical rename.** No behavioral change. Old name implied a full read-path round-trip;
the test only asserts that the submitted ADF document contains a `heading` node (forward
direction only — `markdown_to_adf`). The new name follows the project's
`test_<verb>_<subject>_<expected_outcome>` convention (`docs/specs/test-naming-convention.md`):
`test_e2e_markdown_description_produces_heading_node`.

**Touch-points (all must be updated in F4):**
1. `tests/e2e_live.rs` — rename the function definition (line ~4591 per F1/F2 analysis).
   Add a clarifying comment in the function body: `// Verifies the forward markdown→ADF
   direction only: asserts a heading node appears in the submitted ADF. Read-path
   (adf_to_text) coverage is in test_e2e_adf_read_path_human_output.`
2. `docs/specs/e2e-live-jira-testing.md:~123` — update the bullet that lists the old
   test name `test_e2e_issue_markdown_description_roundtrip` to use the new name.
3. `tests/e2e_cli_surface_guard.rs` — NO change required. SURFACE table is keyed on
   CLI command paths (`("issue", "view")` etc.), not test function names.
4. `bc-7-output-render.md` BC-7.2.003 Trace field — already updated in F2 to reference
   the new name. No further update needed.

**Gate retention:** The renamed function retains both `#[ignore]` and `if !e2e_enabled() { return; }` unchanged.

---

## Implementation Notes

### Overall test structure

All four ACs are implemented in two test additions to `tests/e2e_live.rs`:

1. **New function `test_e2e_adf_read_path_human_output`** — contains AC-1, AC-2, AC-3 in
   linear sequence within one gated test. Issue lifecycle: create → poll_view → AC-1 view
   human-mode asserts → AC-2 JSON structural asserts → comment seed → AC-3 comment read
   asserts → teardown (label-based sweeper handles cleanup; `best_effort_close` is optional
   as a belt-and-suspenders measure for standard issues). No `jsm_self_close` needed — this
   is a standard issue in the E2E project (not JSM).

2. **Renamed function `test_e2e_markdown_description_produces_heading_node`** — AC-4 is a
   pure rename, no assertion changes.

3. **New helper `adf_has_blockquote_in_list_item`** — added near the other ADF helpers
   (lines ~8912-8964). Implementation:
   ```rust
   /// Returns `true` if any `listItem` node in `node` has a direct child
   /// whose `type` field equals `"blockquote"`.  Used to assert that
   /// `normalize_list_item_content` stripped blockquotes from listItem content.
   fn adf_has_blockquote_in_list_item(node: &Value) -> bool {
       if node.get("type").and_then(Value::as_str) == Some("listItem") {
           if let Some(content) = node.get("content").and_then(Value::as_array) {
               if content.iter().any(|child| {
                   child.get("type").and_then(Value::as_str) == Some("blockquote")
               }) {
                   return true;
               }
           }
       }
       match node {
           Value::Array(items) => items.iter().any(adf_has_blockquote_in_list_item),
           Value::Object(map) => map.values().any(adf_has_blockquote_in_list_item),
           _ => false,
       }
   }
   ```

### Server-Side ADF Mutation Guardrail (mandatory — do not relax)

Jira Cloud silently normalizes submitted ADF at store time. The exact transform set is
undocumented and version-drifting (research Claim 3, CONFIRMED). The following constraints
are non-negotiable:

- **AC-1:** Assert on `adf_to_text` rendered text via content-word substrings from the
  original markdown. Do NOT snapshot `fields.description` JSON for equality.
- **AC-2:** Assert (a) create exited 0, and (b) the negative structural invariant
  (`!adf_has_blockquote_in_list_item`). Do NOT equality-check the list subtree.
- **AC-3:** Assert on `adf_to_text` rendered text of the comment body. Do NOT snapshot raw
  comment ADF JSON.

**Warning for future maintainers:** do NOT tighten these assertions into exact-ADF snapshot
comparisons (e.g. `assert_eq!(description_json, expected_adf)`). That would introduce
flakiness against server normalization — tests would fail on any Jira-side `localId` schema
update or mark-ordering change without any `jr` code change.

**Fixture constraints:**
- No `@mentions` or user-identity nodes in any fixture (GDPR/privacy processing makes
  user-mention rendering non-deterministic across accounts — research Claim 5).
- Tolerate: injected `localId` attributes, reordered/coalesced marks, coalesced adjacent
  paragraphs. The assertion strategies above already provide this tolerance.

### The `_emphasis_` discriminator (AC-3)

The negative assertion `!stdout_comments.contains("_emphasis_")` is the live discriminator
between the `adf_to_text` path and a raw passthrough. This assertion MUST be included — if
omitted, AC-3 does not actually confirm `adf_to_text` was exercised (the strong assertion
alone could pass even if the comment body was echoed verbatim). Do not weaken this assertion
under adversarial review.

### ADF read path: no `expand` parameters (research-confirmed)

`get_issue` (`src/api/jira/issues.rs:~426`): URL is `/rest/api/3/issue/{key}?fields={}` —
no `expand=renderedFields`. `list_comments` (line ~654): URL is
`/rest/api/3/issue/{key}/comment?startAt=N&maxResults=N&expand=properties` — NOT
`expand=renderedBody`. Both return raw ADF JSON. Do not modify these paths. This is a
regression-gate concern for the future: if either function gains an `expand=renderedFields`
or `expand=renderedBody` parameter, the human-mode tests here would stop exercising
`adf_to_text` (they would inspect HTML instead). Research confirms the current paths are
correct.

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `test_e2e_adf_read_path_human_output` | `tests/e2e_live.rs` | Effectful (spawns real `jr` processes against Jira Cloud) | Live integration test; calls `jr issue create`, `jr issue view`, `jr issue comment`, `jr issue comments` |
| `adf_has_blockquote_in_list_item` | `tests/e2e_live.rs` | Pure (walks serde_json Value; no I/O) | Helper function; recursive JSON tree walk |
| `test_e2e_markdown_description_produces_heading_node` (renamed) | `tests/e2e_live.rs` | Effectful (spawns `jr`) | Rename only; no behavioral change |

**Dependency anchor justification:** `depends_on: []` — this story is test-only with no
dependencies on other in-flight stories. All predecessor code (PR #477 for
`normalize_list_item_content`, PR #487 for GFM alerts/panel, PR #495 for prior E2E batch)
is fully merged on `develop`. `blocks: []` — no story depends on this test coverage.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-001 | `poll_view` returns stale/empty description before `listItem` nodes appear | The positive gate assertion `adf_has_node_type(description_json, "listItem")` must succeed before the absence assertion runs. `poll_view` already retries; the positive gate is a belt-and-suspenders guard. |
| EC-002 | Jira injects `localId` attributes into `listItem` or `paragraph` nodes | The `adf_has_blockquote_in_list_item` walk is unaffected by `localId` injection — it only checks `type` fields. The `adf_to_text` rendered-text assertions are unaffected. |
| EC-003 | Jira coalesces adjacent paragraphs within the list item | The absence assertion (`!adf_has_blockquote_in_list_item`) remains valid: coalescing adjacent paragraphs does not produce a `blockquote` node inside a `listItem`. The `adf_contains_text` sanity check is also unaffected (text content is preserved). |
| EC-004 | `adf_to_text` renders heading with a `##` prefix rather than plain text | The AC-1 assertion uses content words (`"Section Header"`) not the `##` prefix. This is intentional: if `adf_to_text` produces `## Section Header`, the assertion passes. If it produces `Section Header` (without the prefix), the assertion also passes. The test is agnostic to the exact heading marker format. |
| EC-005 | The comment `--markdown` flag is not passed | Without `--markdown`, `jr issue comment` sends the raw string as plain text, not ADF. The `adf_to_text` round-trip assertion in AC-3 would not hold. The `--markdown` flag is mandatory in the test. |
| EC-006 | Test label uses `run_label()` whose value is non-deterministic (timestamp or GITHUB_RUN_ID) | This is the project convention. The CI sweeper finds issues by label prefix `e2e-`. The test must call `run_label()` to get the label value and pass it to `--label`. |

## Test Coverage Summary

All new tests are in `tests/e2e_live.rs`. All are gated behind `JR_RUN_E2E=1` + `#[ignore]`
+ `if !e2e_enabled() { return; }`. Inert in `cargo test` / `ci.yml`; executed in `e2e.yml`
(nightly nightly, non-blocking).

| Test name | AC | BC anchors | Coverage added |
|-----------|-----|------------|---------------|
| `test_e2e_adf_read_path_human_output` | AC-1 | BC-7.2.003, BC-7.2.004 | First live exercise of `adf_to_text` via `jr issue view` human mode |
| `test_e2e_adf_read_path_human_output` | AC-2 | BC-7.2.006 | First live exercise of `normalize_list_item_content` vs Jira Cloud; blockquote-in-listItem accepted (no 400); structural invariant confirmed |
| `test_e2e_adf_read_path_human_output` | AC-3 | BC-7.2.004 | First live exercise of `adf_to_text` via `jr issue comments` human mode; `_emphasis_` → `*emphasis*` discriminator |
| `test_e2e_markdown_description_produces_heading_node` (renamed) | AC-4 | BC-7.2.003 | Formerly `test_e2e_issue_markdown_description_roundtrip`; forward markdown→ADF only; name now accurate |

No new integration test files. No hermetic test additions (no `tests/*.rs` except `e2e_live.rs`).

## Dependency Analysis

No dependency cycle introduced. This story has `depends_on: []` and `blocks: []`.
It is a leaf node in the feature-followup dependency graph.

Topological sort validation:
- S-475 has no incoming edges (depends_on: []).
- S-475 has no outgoing edges that cycle back.
- The dependency graph remains acyclic.

No conflict with in-progress work: all referenced production code is on `develop`. No other
in-progress story modifies `tests/e2e_live.rs` (the only file this story changes) at the
time of authoring.

## Out of Scope (explicit)

- Coverage of every markdown construct (`subsup`, `panel`, `taskList`, etc.) in the E2E
  read path. AC-1 verifies the path is exercised; comprehensive construct coverage is
  deferred.
- `--output json` view shape: already covered by existing E2E tests.
- The `adf_to_text` JSON round-trip (reading ADF back and re-encoding to JSON): separate concern.
- `table`-in-`listItem` normalization live test: deferred (blockquote sub-case in AC-2 is
  sufficient for the first live normalization coverage).

## Definition of Done

- [ ] `test_e2e_adf_read_path_human_output` added to `tests/e2e_live.rs` with all four
      AC-1/AC-2/AC-3 sub-sequences and correct gating (`#[ignore]` + `if !e2e_enabled()` first).
- [ ] `adf_has_blockquote_in_list_item` helper added near line 8960 in `tests/e2e_live.rs`.
- [ ] `test_e2e_issue_markdown_description_roundtrip` RENAMED to
      `test_e2e_markdown_description_produces_heading_node` with clarifying comment in body.
- [ ] `docs/specs/e2e-live-jira-testing.md:~123` bullet updated to new test name.
- [ ] `tests/e2e_cli_surface_guard.rs::test_parser_paths_are_subset_of_surface_table` still passes
      (SURFACE table is unchanged — verify no new rows needed).
- [ ] `cargo test --lib` green (hermetic suite unaffected — no `src/` changes).
- [ ] `cargo test --test '*'` green (all integration + E2E guard tests; the new gated test is
      excluded from `cargo test` but the guard test must still pass).
- [ ] `cargo clippy -- -D warnings` clean.
- [ ] `cargo fmt --all -- --check` clean.
- [ ] BC count unchanged at 594 (`check-bc-cumulative-counts.sh` exits 0).
- [ ] NFR count unchanged at 41 (`check-spec-counts.sh` exits 0).
- [ ] Story count updated to 68 in STORY-INDEX.md `total_stories` frontmatter.
- [ ] Fresh-context adversarial review → clean (F5 pass).
- [ ] PR → develop; CI green.
- [ ] Live E2E nightly run confirms `test_e2e_adf_read_path_human_output` passes
      (`JR_RUN_E2E=1`, nightly e2e.yml, or local run with full E2E env).

## Story Points and Effort

**3 story points** (same as S-483 and S-474 — equivalent test complexity class).

Breakdown:
- F3 story authoring: 0.5 SP
- F4 implementation (author test + helper + rename + doc update): 1.5 SP
- F5/F7 adversarial review + PR: 1 SP
