---
document_type: phase-f1-delta-analysis
title: "BC Sub-Clause Pass — Blocked Targets Scoping Plan"
date: 2026-06-30
parent_plan: holdout-coverage-gaps-2026-06-30-delta.md
blocked_targets: 3
proposed_new_bcs: 3
proposed_new_ecs: 21
current_total_bcs: 605
proposed_total_bcs: 608
author: product-owner
status: SCOPING-ONLY
---

# BC Sub-Clause Pass — Blocked Targets Scoping Plan

**Date**: 2026-06-30
**Parent plan**: `holdout-coverage-gaps-2026-06-30-delta.md`
**Pipeline state**: IDLE at Phase 3
**Current total BCs**: 605
**Proposed total after this pass**: 608 (+3 new individually-bodied BCs)

---

## Background

Three targets were declared BLOCKED in the parent F1 plan because their anchor BCs lack
individually-bodied sub-clauses that make behavior observable from the public CLI surface.
The holdout evaluator cannot construct wiremock scenarios and assert results without source-
internal knowledge. This plan scopes exactly what must be authored, grounded in source
(`src/cli/issue/edit.rs`, `src/cli/board.rs`, `src/api/jira/issues.rs`) and CLAUDE.md,
to unblock those holdouts.

No spec files are modified by this plan document. Authoring happens in the F2 burst.

---

## Target 1: `jr issue edit --label` Single-vs-Bulk Payload-Schema Fork

### Source of truth

`src/cli/issue/edit.rs::handle_edit_bulk_labels` (lines ~935-1021) and
`src/api/jira/issues.rs::JiraClient::update_issue_labels` (~lines 468-492).

CLAUDE.md Gotcha BUG-LABEL-400 is the primary specification note. Live E2E run 26730687481
confirmed the bulk-payload shape returns HTTP 400 on real Jira Cloud when applied to a
single key.

### Gap in BC-3.4.006

BC-3.4.006 (`bc-3-issue-write.md` line 565) pins the `build_labels_edited_fields`
function shape (multi-key POST `labelsFields` array with `{"name":...}` objects). It does
NOT document the routing decision: `handle_edit_bulk_labels` switches on `keys.len() == 1`
and uses two entirely different API endpoints with mutually incompatible payload shapes.
There is no EC in BC-3.4.006 asserting either path's endpoint or payload.

### Proposed BC: BC-3.4.020

**ID**: BC-3.4.020
**Title**: `issue edit --label` routes single-key through PUT `/rest/api/3/issue/{key}` with bare-string labels, multi-key through bulk POST `/rest/api/3/bulk/issues/fields` with `{"name":...}` objects
**Location**: `bc-3-issue-write.md`, after BC-3.4.019 (last existing entry in section 3.4)

**Preconditions**:
1. `jr issue edit --label <spec>` is invoked with 1 to N positional keys (or --jql resolving to 1..N keys).
2. At least one `--label` value is supplied.
3. The `--field` flag is absent (mutual-exclusion gate BC-3.4.017 Gate B bars `--field + --label`).

**Postconditions — Path A (single key, keys.len() == 1)**:
1. `PUT /rest/api/3/issue/{key}` is called exactly once with Content-Type `application/json`.
2. Request body is `{"update": {"labels": [{"add": "foo"}, {"remove": "bar"}]}}` where
   label values are **bare strings** (not `{"name":...}` objects).
3. `add:` prefix entries produce `{"add": "name"}` operations; `remove:` prefix entries
   produce `{"remove": "name"}`; bare entries (no prefix) produce `{"add": "name"}`.
4. Returns HTTP 204 → exit 0.
5. `POST /rest/api/3/bulk/issues/fields` is NOT called.
6. `GET .../editmeta` is NOT called (label edits do not use editmeta).
7. JSON mode: stdout is `{"key":"<KEY>","changed_fields":{"labels":"add:foo, remove:bar"}}`.
   Table mode: stdout is "Updated <KEY>"; stderr is "  labels → add:foo, remove:bar".

**Postconditions — Path B (multi-key, keys.len() >= 2)**:
1. `POST /rest/api/3/bulk/issues/fields` is called exactly once (both ADD and REMOVE
   coalesce into a single POST — they do not generate two requests).
2. Request body `selectedActions` array is `["labels"]`.
3. Request body `editedFieldsInput` is:
   ```json
   {
     "labelsFields": [
       {"fieldId":"labels","bulkEditMultiSelectFieldOption":"ADD","labels":[{"name":"foo"}]},
       {"fieldId":"labels","bulkEditMultiSelectFieldOption":"REMOVE","labels":[{"name":"bar"}]}
     ]
   }
   ```
   where label items are `{"name":"..."}` **objects** (NOT bare strings).
   If only ADD entries: `labelsFields` has one element. If only REMOVE: one element.
   If both: two elements, ADD first, REMOVE second.
4. `PUT /rest/api/3/issue/{key}` is NOT called.
5. Async bulk task is polled; exit 0 if task completes successfully.

**Invariants**:
1. The same `--label` spec (e.g., `--label add:foo`) produces different wire payloads
   depending on key count. This asymmetry is LOAD-BEARING and must NOT be unified.
2. `keys.len() == 1` is determined AFTER `--jql` resolution — a `--jql` query matching
   exactly one issue takes Path A, not Path B.
3. The routing check is `keys.len() == 1`, not "was --jql used?".

**Edge cases**:
- EC-3.4.020-1: One positional key → PUT, bare-string labels, no bulk POST
- EC-3.4.020-2: `--jql "project = FOO AND key = FOO-1"` (matches one issue) → PUT path (not bulk)
- EC-3.4.020-3: Two positional keys → POST bulk, `{"name":...}` objects in `labelsFields`
- EC-3.4.020-4: `--jql "project = FOO"` matching two issues → bulk path, same `labelsFields` shape
- EC-3.4.020-5: Bare label (no prefix, e.g., `--label feature`) → treated as ADD; produces `{"add":"feature"}` on PUT path, `{"name":"feature"}` under `bulkEditMultiSelectFieldOption:"ADD"` on bulk path
- EC-3.4.020-6: Only REMOVE entries for a single key → `{"update":{"labels":[{"remove":"x"}]}}` (no ADD element)
- EC-3.4.020-7: Only ADD entries for multiple keys → `labelsFields` has exactly one element (ADD only)

**Canonical test vectors**:

| Scenario | Keys | Input | Expected endpoint | Expected payload fragment |
|----------|------|-------|------------------|--------------------------|
| Single-key ADD | `FOO-1` | `--label add:bug` | `PUT /rest/api/3/issue/FOO-1` | `{"update":{"labels":[{"add":"bug"}]}}` |
| Single-key REMOVE | `FOO-1` | `--label remove:bug` | `PUT /rest/api/3/issue/FOO-1` | `{"update":{"labels":[{"remove":"bug"}]}}` |
| Multi-key ADD | `FOO-1 FOO-2` | `--label add:bug` | `POST .../bulk/issues/fields` | `labelsFields[0].bulkEditMultiSelectFieldOption = "ADD"`, `labels[0].name = "bug"` |

**Source**: `src/cli/issue/edit.rs::handle_edit_bulk_labels` line 961-1001 (Path A) and
lines 1004-1020 (Path B); `src/api/jira/issues.rs::update_issue_labels` lines 468-492
(bare-string PUT payload). CLAUDE.md Gotcha BUG-LABEL-400.

### Relation to BC-3.4.006

BC-3.4.006 remains as-is. It pins the `build_labels_edited_fields` pure-function shape
(the multi-key payload builder). BC-3.4.020 pins the routing decision and the observable
endpoint + payload shape for each path. The two BCs are complementary: BC-3.4.006 is the
shape invariant, BC-3.4.020 is the routing + wire invariant.

### Holdout this BC will unblock

**H-LABEL-FORK-001 (provisional)**: Two-call scenario asserting path asymmetry.
- Call A: `jr issue edit FOO-1 --label add:bug --no-input` → PUT captured; body contains
  `{"add":"bug"}` (bare string); no bulk POST called (`.expect(0)`).
- Call B: `jr issue edit FOO-1 FOO-2 --label add:bug --no-input` → bulk POST captured;
  body's `labelsFields[0].labels[0].name == "bug"` (object form); no PUT called.
- Why hidden: a mock server that accepts either payload shape would mask a regression
  that sends the wrong shape (e.g., bare strings to the bulk endpoint → HTTP 400 on
  real Jira, but mock returns 200).

---

## Target 2: `jr board view` Truncation, Scrum vs Kanban Path, `--all`

### Source of truth

`src/cli/board.rs::handle_view` (lines ~173-306). No external Atlassian documentation
is authoritative for this behavior — it is entirely a `jr` client-side implementation
decision: which API endpoint to call based on board type, and how to emit the truncation
hint. The Agile REST API spec (`GET /rest/agile/1.0/board/{id}/configuration`) is
referenced only to confirm what `board_type` the `board_config.board_type` field returns.

### Gap in existing BCs

Existing BC-5.1.001..004:
- BC-5.1.001: GETs `agile/1.0/board` list endpoint. No body.
- BC-5.1.002: `--limit + --all` clap conflict. No body.
- BC-5.1.003: Auto-resolve board. No body.
- BC-5.1.004: `get_sprint_issues` with limit. No body.

None of these individually body the runtime behavior of `handle_view`. Key behaviors
with no BC coverage:
1. Scrum path uses `list_sprints` + `get_sprint_issues`; kanban path uses JQL search.
   These are different endpoints — observably distinct from a mock server perspective.
2. Truncation hint format differs between scrum (`"Showing N results. Use --limit or --all
   to see more."`) and kanban with count (`"Showing N of ~M results. Use --limit or --all
   to see more."`) and kanban without count (same as scrum format).
3. All hint text goes to stderr, not stdout.
4. `--all` suppresses the hint entirely.
5. Scrum board with no active sprint → exit 1 "No active sprint found for board N."

### Proposed BC: BC-5.1.005

**ID**: BC-5.1.005
**Title**: `jr board view` dispatches to sprint API for scrum boards, JQL search for kanban boards; truncation hint emits to stderr; `--all` suppresses hint
**Location**: `bc-5-boards-sprints.md`, after BC-5.1.004 (last entry in section 5.1)

**Preconditions**:
1. `jr board view [--board N] [--limit N] [--all]` is invoked.
2. Board ID is resolved (via `--board` flag, config `board_id`, or auto-resolve).
3. `GET /rest/agile/1.0/board/{id}/configuration` returns a valid board config with a
   `board_type` field (either `"scrum"` or anything else, i.e., kanban).

**Postconditions — Scrum path (board_type == "scrum" case-insensitively)**:
1. `GET /rest/agile/1.0/board/{id}/sprint?state=active` is called to find the active sprint.
2. If no active sprint → exit 1 with message `"No active sprint found for board <id>."` to
   stderr. No issue-fetch endpoint is called after this failure.
3. `GET /rest/agile/1.0/sprint/{sprintId}/issue` (or equivalent `get_sprint_issues` call)
   is called with `effective_limit` (resolved from `--limit` / `--all`).
4. `POST /rest/api/3/search` (JQL search) is NOT called.
5. If `has_more && !all`: `eprintln!("Showing {} results. Use --limit or --all to see more.", issues.len())` to stderr. No approximate count endpoint is called on the scrum path.
6. If `!has_more || all`: no truncation hint emitted.

**Postconditions — Kanban path (board_type != "scrum")**:
1. `GET /rest/agile/1.0/board/{id}/sprint` is NOT called.
2. JQL `<project-clause> AND statusCategory != Done ORDER BY rank ASC` is sent to
   `POST /rest/api/3/search` (or equivalent `search_issues` call). If no project is
   configured, the `project = <key>` clause is omitted and a warning is emitted to stderr:
   `"warning: no project configured for board. Showing issues across all projects. Set project in .jr.toml to scope results."`.
3. If `has_more && !all`: attempts `approximate_count` via a second search call to get
   total count.
   - If total > 0: `eprintln!("Showing {} of ~{} results. Use --limit or --all to see more.", issues.len(), total)` to stderr.
   - If total == 0 or count call fails: `eprintln!("Showing {} results. Use --limit or --all to see more.", issues.len())` to stderr.
4. If `!has_more || all`: no truncation hint emitted.

**Common postconditions (both paths)**:
- All truncation hint text is emitted to **stderr**, not stdout.
- `--all` flag sets `effective_limit = None` (no cap), which causes the underlying API
  call to fetch all pages; `has_more` is then false, so no hint is emitted.
- `--limit` + `--all` is a clap-level conflict (BC-5.1.002): exit 2 before any HTTP.
- Table output: issues in the order returned by the API (no client-side reorder).
- JSON output: `--output json` emits the issues array on stdout; no truncation hint in
  JSON mode (the hint fires regardless of output format, but hits stderr).

**Invariants**:
1. The routing decision is `board_type.to_lowercase() == "scrum"` (case-insensitive comparison on the API-returned string).
2. Sprint and JQL endpoints are mutually exclusive per invocation — exactly one is used.
3. Hint text is on stderr in all cases (CLAUDE.md: "truncation hint emitted to stderr").
4. `--all` is the only mechanism to suppress the hint — there is no auto-suppress based on result count.

**Edge cases**:
- EC-5.1.005-1: Scrum board, active sprint exists, results ≤ limit → exit 0, no hint
- EC-5.1.005-2: Scrum board, active sprint exists, results > limit → exit 0, stderr hint
  `"Showing N results. Use --limit or --all to see more."` (scrum, no ~M)
- EC-5.1.005-3: Scrum board, no active sprint → exit 1, stderr `"No active sprint found for board <id>."`; no issue-fetch call
- EC-5.1.005-4: Kanban board, results > limit, count available → stderr `"Showing N of ~M results. Use --limit or --all to see more."`
- EC-5.1.005-5: Kanban board, results > limit, count call fails → stderr `"Showing N results. Use --limit or --all to see more."` (graceful fallback)
- EC-5.1.005-6: `--all` on scrum board → no truncation hint regardless of issue count; sprint endpoint called with no limit cap
- EC-5.1.005-7: Kanban, no project configured → stderr warning before JQL is sent; JQL omits `project =` clause
- EC-5.1.005-8: Scrum path: board_config is fetched first (`GET /board/{id}/configuration`); this call fires on BOTH scrum and kanban (board_type is determined from the config, not from caller-supplied metadata)

**Canonical test vectors**:

| Scenario | Board type | API mocks | Expected hint |
|----------|-----------|-----------|---------------|
| Scrum, under limit | scrum | sprint→2 issues, has_more=false | none |
| Scrum, over limit | scrum | sprint→30 issues, has_more=true | stderr: "Showing 30 results. Use --limit or --all to see more." |
| Scrum, no sprint | scrum | sprint→empty | exit 1, stderr: "No active sprint found for board 5." |
| Kanban, over limit with count | kanban | search→30 issues has_more=true; count=87 | stderr: "Showing 30 of ~87 results. Use --limit or --all to see more." |
| Kanban, --all | kanban | search→all issues, has_more=false | no hint |

**Source**: `src/cli/board.rs::handle_view` lines 196-303. Confirmed by reading the full
function body. No external Atlassian API spec is authoritative for the hint text or the
routing logic — this is implementation-defined client behavior.

### Holdout this BC will unblock

**H-BOARD-VIEW-001 (provisional)**: Scrum vs kanban path distinction.
- Call A: `jr board view --board 1 --no-input` where board config returns `board_type: "scrum"`,
  active sprint mock exists. Assert: sprint issue endpoint called; JQL search endpoint NOT called.
- Call B: `jr board view --board 2 --no-input` where board config returns `board_type: "kanban"`.
  Assert: JQL search endpoint called; sprint endpoint NOT called.
  With `has_more=true` and count=50: stderr contains "Showing 30 of ~50 results."
- Why hidden: a mock that returns issues regardless of endpoint would not catch a
  regression that sends all boards down the kanban path (skipping sprint context).

---

## Target 3: `jr issue edit --dry-run` `plannedChanges` Output Structure

### Source of truth

`src/cli/issue/edit.rs::handle_edit` dry-run block (lines ~366-558). This is a PURE
`jr` client construct with NO Atlassian API analogue. There is no Jira Cloud endpoint
or doc that defines this behavior. The spec MUST be derived from the implementation.

CLAUDE.md states: "`--dry-run` is implemented on `issue edit` (multi-key positional +
`--jql`-resolved sets) with `--output json` support." It does not define the output schema.
That schema is documented only in code comments and the implementation body.

### Gap in existing BCs

EC-3.4.012-9 (`bc-3-issue-write.md` line 875): states `"--dry-run set → handle_edit emits
planned-changes preview and exits; this contract does not fire"`. This is a carve-out, not
a contract body. The same carve-out appears in EC-3.4.013-7 (line 975). BC-3.4.015 EC-18
covers `--field --dry-run` exit code and HTTP count but NOT the JSON output shape.

No BC documents:
1. The top-level JSON schema: `{"dryRun": true, "issues": [...], "plannedChanges": {...}}`
2. The `plannedChanges` field keys and value types per flag
3. The intentional simplified shapes (labels as `[{"action":"ADD","name":"foo"}]` flat array,
   issueType as bare string) that differ from the live-edit wire shapes
4. The `--output table` stdout format
5. That `--description-stdin` produces a literal placeholder string in dry-run
6. That `--no-parent` / `--no-points` produce `null` (not absent) in `plannedChanges`

### Proposed BC: BC-3.4.021

**ID**: BC-3.4.021
**Title**: `jr issue edit --dry-run` emits `plannedChanges` JSON or table preview on stdout without issuing any mutation HTTP call; `--output json` schema is `{dryRun, issues, plannedChanges}`
**Location**: `bc-3-issue-write.md`, after BC-3.4.020

**Preconditions**:
1. `jr issue edit KEY(s) --dry-run [flags]` is invoked.
2. At least one field flag is supplied (BC-3.4.015 invariant: zero-flag guard fires
   pre-HTTP and pre-dry-run, so the guard still exits 64 if no flags are given).
3. `--dry-run` is set (explicit CLI flag; not inferred from any other condition).
4. The command may have multiple keys (positional or via `--jql`).

**Postconditions — Common (regardless of --output)**:
1. No mutation HTTP call is issued: `PUT /rest/api/3/issue/{key}`, `POST /bulk/issues/fields`,
   and `POST /bulk/issues/transition` are all NOT called.
2. `--jql` resolution fires (search endpoint is called) — JQL resolution is read-only.
3. If `--field NAME=VALUE` is supplied: `GET /rest/api/3/issue/{key}/editmeta` fires (read-
   only field validation); `PUT` does NOT fire. A resolution failure (field absent from
   editmeta, unknown option value) still exits 64 — `--dry-run` does NOT suppress exit-64
   resolution errors (EC-3.4.015-19 is preserved).
4. Exit code is 0 on successful dry-run (unless a resolution error exits 64 as noted above).
5. Output is written to **stdout** (not stderr).

**Postconditions — `--output json`**:
1. stdout is a single pretty-printed JSON object with exactly three top-level keys:
   ```json
   {
     "dryRun": true,
     "issues": ["FOO-1", "FOO-2"],
     "plannedChanges": { ... }
   }
   ```
2. `plannedChanges` is a JSON object containing ONLY the field keys the user explicitly
   requested. Keys absent from the invocation do NOT appear in `plannedChanges`.
3. `plannedChanges` key names and value types per flag:
   - `--summary "X"` → `"summary": "X"` (bare string)
   - `--priority "High"` → `"priority": "High"` (bare string; NOT `{"priorityId":"..."}`)
   - `--type "Bug"` → `"issueType": "Bug"` (bare string; NOT id-resolved)
   - `--parent "FOO-0"` → `"parent": "FOO-0"` (bare string)
   - `--no-parent` → `"parent": null` (JSON null, NOT absent key)
   - `--points 3` → `"points": 3.0` (number)
   - `--no-points` → `"points": null` (JSON null, NOT absent key)
   - `--team "Backend"` → `"team": "Backend"` (bare string)
   - `--description "X"` → `"description": "X"` (bare string; raw input, not ADF)
   - `--description-stdin` → `"description": "<from stdin — not yet read in dry-run>"` (literal placeholder string; stdin is NOT read)
   - `--markdown` → `"markdown": true` (boolean)
   - `--label add:foo` → `"labels": [{"action": "ADD", "name": "foo"}]` (flat array; NOT the live-edit `labelsFields` bulk schema)
   - `--field NAME=VALUE` (resolved) → `"<resolved-field-key>": "<resolved-value>"` merged into `plannedChanges` as string key/value pairs
4. `plannedChanges` key ordering is deterministic: alphabetical (BTreeMap insertion order
   by key string; `--field` resolved entries are merged in the same BTreeMap order).
   Note: the source comment at `edit.rs line 402` shows a fixed insertion order; in practice
   the keys come from `serde_json::Map` which preserves insertion order, and `BTreeMap`
   (for `dr_changed` from `--field`) is alphabetically ordered.
5. `dryRun: true` is always present as a boolean.
6. `issues` is always present as a string array of the resolved keys.
7. Output is produced via `output::render_json(&payload)` (JSON render invariant, BC-7.3.010).

**Postconditions — `--output table` (default)**:
1. stdout lines in exact order:
   ```
   DRY RUN — no changes will be made.
   Issues affected (N):
     <KEY-1>
     <KEY-2>
   Planned changes:
     summary → <value>
     priority → <value>
     labels → add:foo, remove:bar
     type → <value>
     parent → <value> | (clear)
     points → <value> | (clear)
     team → <value>
     description → <preview>
     markdown rendering: enabled
     <field-name> → <value>
   ```
   Only lines for flags that were supplied are emitted. The order matches the source code
   insertion order (summary, priority, labels, type, parent/no-parent, points/no-points,
   team, description/description-stdin, markdown, then --field entries).
2. `--description "..."` longer than 60 Unicode codepoints → truncated to 60 codepoints
   with `"..."` suffix (e.g., `"  description → The quick brown fox jumps over the la..."`).
   Truncation uses `chars().count()` and `chars().take(60)` (codepoint-aware, not byte-slice).
3. `--description-stdin` → `"  description → (read from stdin — not yet read in dry-run)"`.
4. `--no-parent` → `"  parent → (clear)"`.
5. `--no-points` → `"  points → (clear)"`.
6. `--label add:foo --label remove:bar` → `"  labels → add:foo, remove:bar"` (comma-joined, prefix preserved).
7. `--field` resolved entries → `"  <field-name> → <value>"` (arrow is Unicode U+2192).
8. Output channel: all output is on stdout (profile-1 for dry-run per source comment).

**Invariants**:
1. The `plannedChanges` field shapes are INTENTIONALLY SIMPLIFIED previews — they do NOT
   match the live-edit wire payloads. Specifically:
   - `labels`: dry-run emits `[{"action":"ADD","name":"foo"}]`; live bulk POST sends `labelsFields` array with `bulkEditMultiSelectFieldOption` (see BC-3.4.006 / BC-3.4.020).
   - `priority`: dry-run emits a bare string; live POST wraps as `{"priorityId":"<id>"}`.
   - `issueType`: dry-run emits the type name; live POST uses `{"issueTypeId":"<id>"}`.
   These differences are documented and intentional (source comment `edit.rs lines 410-430`).
2. `--dry-run` does NOT suppress exit-64 resolution errors. Only PUT/POST mutation is suppressed.
3. `--dry-run` does NOT read stdin for `--description-stdin` — the placeholder literal is the
   correct behavior, not a bug.
4. This BC applies to `handle_edit`'s single-key path only. The `--label` path
   (`handle_edit_bulk_labels`) and the multi-key bulk-fields path (`handle_edit_bulk_fields`)
   have their own dry-run handling embedded in BC-3.4.018 EC-3.4.018-5 and are NOT
   re-described here. BC-3.4.021 covers the `handle_edit` dry-run block directly.
5. Exit code 0 is unconditional after the dry-run block returns `Ok(())` (source:
   `edit.rs` `return Ok(());` at the end of the dry-run block, ~line 559).

**Edge cases**:
- EC-3.4.021-1: `--output json --summary "X"` → `{"dryRun":true,"issues":["FOO-1"],"plannedChanges":{"summary":"X"}}`; PUT not called
- EC-3.4.021-2: `--output json --label add:foo --label remove:bar` → `plannedChanges.labels = [{"action":"ADD","name":"foo"},{"action":"REMOVE","name":"bar"}]` (flat array, NOT `labelsFields`)
- EC-3.4.021-3: `--output json --type "Bug"` → `plannedChanges.issueType = "Bug"` (bare string, no id resolution HTTP)
- EC-3.4.021-4: `--output json --no-parent` → `plannedChanges.parent = null` (JSON null, not absent)
- EC-3.4.021-5: `--output json --no-points` → `plannedChanges.points = null` (JSON null, not absent)
- EC-3.4.021-6: `--output json --description-stdin --dry-run` → `plannedChanges.description = "<from stdin — not yet read in dry-run>"` (literal placeholder); stdin not read
- EC-3.4.021-7: `--output table --description "X"` > 60 codepoints → truncated with "..." suffix
- EC-3.4.021-8: `--output json FOO-1 FOO-2 --summary "X"` → `issues: ["FOO-1","FOO-2"]`, bulk POST NOT called; JSON mode: both keys in `issues` array
- EC-3.4.021-9: `--field NAME=VALUE --dry-run` → editmeta GET fires; resolved key+value appear in `plannedChanges`; PUT NOT called; exit 0 (happy path). Exit 64 if resolution fails (BC-3.4.015 EC-3.4.015-19 preserved).
- EC-3.4.021-10: Zero field flags + `--dry-run` → exit 64 before dry-run block (pre-HTTP guard fires; this BC does not apply — prerequisite precondition 2 fails)
- EC-3.4.021-11: `--output table --no-parent` → stdout contains `"  parent → (clear)"` (not `"null"` or absent line)

**Canonical test vectors**:

| Scenario | Flags | --output | Expected stdout fragment | PUT called? |
|----------|-------|----------|--------------------------|-------------|
| Summary dry-run JSON | `FOO-1 --summary "Fix bug" --dry-run` | json | `{"dryRun":true,"issues":["FOO-1"],"plannedChanges":{"summary":"Fix bug"}}` | No |
| Label dry-run JSON | `FOO-1 --label add:bug --dry-run` | json | `plannedChanges.labels[0] = {"action":"ADD","name":"bug"}` | No |
| Multi-key dry-run | `FOO-1 FOO-2 --summary "X" --dry-run` | json | `issues: ["FOO-1","FOO-2"]` | No |
| Table dry-run | `FOO-1 --summary "X" --dry-run` | table | stdout has "DRY RUN — no changes will be made." | No |
| null parent | `FOO-1 --no-parent --dry-run` | json | `plannedChanges.parent = null` | No |

**Source**: `src/cli/issue/edit.rs::handle_edit` dry-run block lines 366-558. Source is
implementation-defined (no external spec). Behavior is pinned from direct code reading.

### Holdout this BC will unblock

**H-DRY-RUN-001 (provisional)**: `jr issue edit --dry-run --output json` output shape.
- Given: wiremock mounts `PUT /rest/api/3/issue/FOO-1` with `.expect(0)`.
- When: `jr issue edit FOO-1 --summary "Fixed bug" --priority High --dry-run --output json`.
- Then: exit 0; PUT not called; stdout parses as valid JSON with top-level keys `dryRun`,
  `issues`, `plannedChanges`; `plannedChanges.summary == "Fixed bug"` (bare string);
  `plannedChanges.priority == "High"` (bare string); `plannedChanges` has no unexpected keys.
- Why hidden: without a BC pinning the `plannedChanges` shape, a regression that inverts
  the simplified preview shape (e.g., wrapping priority as `{"priorityId":"..."}`) would
  be invisible to an evaluator asserting only exit code.

---

## Summary

### New BCs proposed

| BC ID | Title (abbreviated) | File | New individually-bodied | New ECs |
|-------|---------------------|------|------------------------|---------|
| BC-3.4.020 | `--label` routing fork: single-key PUT bare-string vs multi-key POST object schema | `bc-3-issue-write.md` | +1 | 7 (EC-3.4.020-1..7) |
| BC-5.1.005 | `board view` scrum/kanban dispatch + truncation hint | `bc-5-boards-sprints.md` | +1 | 8 (EC-5.1.005-1..8) |
| BC-3.4.021 | `--dry-run` `plannedChanges` output structure + `--output json` schema | `bc-3-issue-write.md` | +1 | 11 (EC-3.4.021-1..11) |
| **Total** | | | **+3** | **26** |

### Count impact

**Pre-pass totals:**
- Grand total: 605
- `bc-3-issue-write.md`: total_bcs = 107, definitional_count = 78
- `bc-5-boards-sprints.md`: total_bcs = 35, definitional_count = 17

**Post-pass totals:**
- Grand total: **608** (+3)
- `bc-3-issue-write.md`: total_bcs = **109** (+2), definitional_count = **80** (+2)
- `bc-5-boards-sprints.md`: total_bcs = **36** (+1), definitional_count = **18** (+1)

Note: BC-3.4.020 and BC-3.4.021 both land in `bc-3-issue-write.md` — that file takes
+2 both to total_bcs and definitional_count.

### Surfaces requiring update (count-frontmatter update checklist)

1. `bc-3-issue-write.md` frontmatter: `total_bcs: 107 → 109`, `definitional_count: 78 → 80`
2. `bc-3-issue-write.md` body preamble prose (line 70): `"107 behavioral contracts"` → `"109 behavioral contracts"`
3. `bc-5-boards-sprints.md` frontmatter: `total_bcs: 35 → 36`, `definitional_count: 17 → 18`
4. `bc-5-boards-sprints.md` body preamble prose (line 16): `"35 behavioral contracts"` → `"36 behavioral contracts"`
5. `BC-INDEX.md` frontmatter: `total_bcs: 605 → 608`
6. `BC-INDEX.md` section 3.4 header (line 265): `"19 BCs: BC-3.4.001..019"` → `"21 BCs: BC-3.4.001..021"`
7. `BC-INDEX.md` section 5.1 header (line 386): `"4 BCs: BC-5.1.001..004"` → `"5 BCs: BC-5.1.001..005"`
8. `BC-INDEX.md` Coverage Statistics table (line ~729 area): update bc-3 and bc-5 rows
9. `BC-INDEX.md` grand-total prose (line ~729): `"605"` → `"608"`
10. `CANONICAL-COUNTS.md` per-file table: bc-3-issue-write.md row `107 → 109`, bc-5-boards-sprints.md row `35 → 36`, Sum row `605 → 608`
11. `CANONICAL-COUNTS.md` grand total prose: `"605"` → `"608"`
12. `CANONICAL-COUNTS.md` `last_verified` note: add entry for this pass
13. L2 domain-spec `bc-03-issue-write.md` frontmatter: `bc_count: 107 → 109`
14. L2 domain-spec `bc-05-boards-sprints.md` frontmatter: `bc_count: 35 → 36`

Scripts to run after authoring to verify consistency:
- `scripts/check-bc-cumulative-counts.sh` (guards 8 surfaces; must exit 0)
- `scripts/check-spec-counts.sh` (guards frontmatter vs body counts)

### Holdouts unblocked

| Provisional holdout ID | BC anchor | Target behavior |
|------------------------|-----------|-----------------|
| H-LABEL-FORK-001 | BC-3.4.020 | Single-key PUT bare-string vs multi-key POST `{"name":...}` objects; payload asymmetry invisible from exit codes |
| H-BOARD-VIEW-001 | BC-5.1.005 | Scrum uses sprint endpoint, kanban uses JQL; truncation hint format; `--all` suppresses hint |
| H-DRY-RUN-001 | BC-3.4.021 | `--dry-run --output json` schema: `{dryRun, issues, plannedChanges}` with intentionally simplified field shapes |

### Risk

1. **BC-3.4.020 range-collapse question**: BC-3.4.006 covers the `build_labels_edited_fields`
   shape and is ALREADY individually bodied (a full `#### BC-` heading with body text in
   bc-3-issue-write.md). BC-3.4.020 is a separate new BC. There is NO risk of renumbering
   existing BCs (append-only rule). The existing BC-3.4.006 body is not modified.

2. **BC-3.4.021 scope boundary**: BC-3.4.021 covers `handle_edit` dry-run block ONLY. The
   `handle_edit_bulk_labels` and `handle_edit_bulk_fields` dry-run paths are already covered
   by EC-3.4.018-5 (bulk `--type` dry-run) and are NOT re-described. There is no overlap.

3. **BC-5.1.005 external-API reliance**: The scrum path (sprint endpoint) and kanban path
   (JQL search) are routing decisions implemented in `jr`. No external Atlassian spec is
   needed because the routing logic is in `src/cli/board.rs` lines 196-216. The observation
   (which endpoint fires) is fully verifiable from a mock server.

4. **No retiring or re-anchoring of existing BCs**: This pass ADDS three new BCs only. No
   existing BC is modified, retired, or renumbered. The existing BC-3.4.006 body is not
   changed; BC-3.4.020 is an additive companion.

5. **Holdout author note**: H-LABEL-FORK-001 requires the mock server to distinguish between
   PUT `/issue/{key}` and POST `/bulk/issues/fields` calls, asserting that the correct one
   fires and the other does NOT. The `.expect(0)` wiremock pattern is established by prior
   holdouts (H-NEW-EDIT-TYPE-001, H-NEW-EDIT-FIELD-002).

---

_Document authored: 2026-06-30 by product-owner agent as Phase F1 scoping output._
_SCOPING ONLY — no spec files were modified._
