# Structural Analysis — `src/cli/issue/create.rs` & `src/cli/issue/workflow.rs`

READ-ONLY analysis to inform a refactor/sharding decision. No source modified.
Checkout: `/Users/zious/Documents/GITHUB/jira-cli` (branch `develop`), 2026-06-25.

ADR-0012 (module shard rule): `src/cli/` files at ≥1,000 LOC are shard candidates;
exceptions are `adf.rs` and `api/auth.rs`. Both targets exceed the threshold.

---

## 0. Production-vs-Test LOC

LOC measured by `wc -l`; the prod/test split is taken at the first `#[cfg(test)]` line.

| File | Total LOC | Prod LOC | Test LOC | Test % | First `#[cfg(test)]` |
|------|-----------|----------|----------|--------|----------------------|
| `create.rs` | 2,880 | ~1,568 | ~1,312 | 46% | line 1569 |
| `workflow.rs` | 1,341 | ~1,200 | ~141 | 11% | line 1201 |

Sibling files (for seam context):

| File | Total LOC | Role |
|------|-----------|------|
| `helpers.rs` | 840 | team/points/user/asset resolution + prompts; `pub(super)` shared by create & list & view |
| `field_resolve.rs` | 877 | `resolve_edit_fields` (`--field` engine) + number-wire helpers; `pub(crate)` |
| `json_output.rs` | 182 | pure `Value`-builders for move/assign/edit/link responses; `pub(crate)` |
| `links.rs` | 289 | link/unlink/remote-link/link-types handlers |
| `format.rs` | 225 | row formatting / headers / points display |

Key structural fact: **create.rs is 46% test code**. Five `#[cfg(test)]` blocks
(lines 1569, 2097, 2213, 2301, 2813) hold the meta-tests and proptests. workflow.rs
is only 11% test — one inline `resolution_resolver_tests` block (line 1201).

---

## 1. Function Inventory

### 1.1 `create.rs`

`use super::helpers;` and `use super::json_output;`. Imports `field_resolve` indirectly
via `helpers::resolve_edit_fields` (re-export at `helpers.rs:605`).

| Fn | Vis | Async | ~LOC | Cluster |
|----|-----|-------|------|---------|
| `handle_create` | `pub(super)` | yes | 265 (31–295) | **PLATFORM-CREATE** + dispatch fork |
| `handle_edit` | `pub(super)` | yes | 824 (297–1120) | **EDIT-ORCHESTRATOR** (validation + dry-run + routing + single-key) |
| `build_labels_edited_fields` | private | no | 25 (1148–1172) | **LABEL-HANDLING** (pure) |
| `handle_edit_bulk_labels` | private | yes | 87 (1204–1290) | **LABEL-HANDLING** (single + bulk fork) |
| `project_key_from_issue_key` | private | no | 6 (1301–1306) | **EDIT-BULK** helper (pure) |
| `handle_edit_bulk_fields` | private | yes | 86 (1328–1413) | **EDIT-BULK** (summary/priority/type) |
| `render_bulk_edit_results` | private | no | 86 (1420–1506) | **EDIT-BULK** output (shared w/ labels-bulk) |
| `is_subtask_parent_error` | private | no | 4 (1516–1519) | **EDIT-ERROR-HINTS** (pure) |
| `is_cross_hierarchy_type_error` | private | no | 11 (1557–1567) | **EDIT-ERROR-HINTS** (pure classifier) |
| `parse_field_kv` | `pub(crate)` | no | 16 (2359–2374) | **FIELD-PARSE** (pure) |
| `handle_jsm_create` | private | yes | 281 (2452–2732) | **JSM-CREATE** dispatch |
| `resolve_jsm_request_type_id` | private | yes | 68 (2737–2804) | **JSM-CREATE** name→id |
| `Classification` (enum) | private | – | 10 (1537–1546) | **EDIT-ERROR-HINTS** types |
| `JsmCreateArgs` (struct) | private | – | 21 (2405–2425) | **JSM-CREATE** arg bundle |
| consts `NO_PARENT_CONTEXT_SENTENCE`, `CROSS_HIERARCHY_HINT`, `TYPO_HINT` | private | – | 3 | **EDIT-ERROR-HINTS** strings |
| const `JQL_CONFIRM_THRESHOLD` | private | – | 1 | **EDIT-ORCHESTRATOR** |

Responsibility clusters in `create.rs`:

- **PLATFORM-CREATE** (`handle_create`, ~265): resolves project/type/summary/desc,
  builds `fields` + `create_echo`, POSTs `create_issue`, JSON follow-up GET. Owns the
  `request_type.is_some()` dispatch fork at the top (lines 63–90).
- **JSM-CREATE** (`handle_jsm_create`, `resolve_jsm_request_type_id`, `JsmCreateArgs`, ~370):
  9-step canonical guard ordering, `require_service_desk`, request-type resolution,
  `JsmRequestBuilder`, 401 auth-scheme-gated error rewriting. Self-contained except for
  `parse_field_kv` and `helpers::prompt_input`.
- **EDIT-ORCHESTRATOR** (`handle_edit`, ~824 — the single largest fn in the codebase):
  selector validation, Gate B flag-overlap, `--label` mutual-exclusion block, C-1
  multi-key rejection, BC-3.4.019 cross-project guard, dry-run rendering (JSON + table),
  JQL confirmation, routing to label-bulk / field-bulk / single-key, single-key field
  building + `--type` 400 enrichment + echo.
- **EDIT-BULK** (`handle_edit_bulk_fields`, `render_bulk_edit_results`,
  `project_key_from_issue_key`, ~178): 2+ key path; priority/type name→id resolution;
  bulk task poll.
- **LABEL-HANDLING** (`handle_edit_bulk_labels`, `build_labels_edited_fields`, ~112):
  single-key PUT (bare strings) vs multi-key bulk POST (`{"name":…}` objects).
- **EDIT-ERROR-HINTS** (`is_cross_hierarchy_type_error`, `is_subtask_parent_error`,
  `Classification`, three hint consts, ~30): pure classifiers + verbatim hint strings.
- **FIELD-PARSE** (`parse_field_kv`, 16): pure NAME=VALUE parser, `pub(crate)`. Shared by
  both `handle_edit` and `handle_jsm_create`.

### 1.2 `workflow.rs`

`use super::helpers;` and `use super::json_output;`. Self-contained otherwise.

| Fn | Vis | Async | ~LOC | Cluster |
|----|-----|-------|------|---------|
| `resolve_resolution_by_name` | private | no | 53 (30–82) | **RESOLUTION** (pure) |
| `load_resolutions` | private | yes | 37 (101–137) | **RESOLUTION** (cache-backed) |
| `resolve_interactive_choice` | **`pub`** | no | 10 (154–163) | **RESOLUTION-PURE-HELPERS** |
| `build_resolution_prompt` | **`pub`** | no | 9 (178–186) | **RESOLUTION-PURE-HELPERS** |
| `NONE_LABEL` (const) | **`pub`** | – | 1 (192) | **RESOLUTION-PURE-HELPERS** |
| `refuse_noninteractive` | **`pub`** | no | 3 (207–209) | **RESOLUTION-PURE-HELPERS** |
| `select_prompt_base_names` | **`pub`** | no | 10 (224–233) | **RESOLUTION-PURE-HELPERS** |
| `optional_prompt_default_index` | **`pub`** | no | 3 (246–248) | **RESOLUTION-PURE-HELPERS** |
| `finish_transition` | private | yes | 48 (255–302) | **MOVE** (shared POST + BC-3.2.009 backstop) |
| `handle_move` | `pub(super)` | yes | 488 (306–793) | **MOVE** single-key + BC-3.2.013 gate |
| `handle_move_bulk` | private | yes | 152 (800–951) | **MOVE** multi-key bulk transition |
| `handle_transitions` | `pub(super)` | yes | 32 (955–986) | **TRANSITIONS** (read) |
| `handle_resolutions` | `pub(super)` | yes | 16 (990–1005) | **RESOLUTIONS** (read) |
| `handle_assign` | `pub(super)` | yes | 107 (1009–1115) | **ASSIGN** |
| `handle_comment` | `pub(super)` | yes | 62 (1119–1180) | **COMMENT** |
| `handle_open` | `pub(super)` | yes | 16 (1184–1199) | **OPEN** |

Responsibility clusters in `workflow.rs`:

- **MOVE** (`handle_move`, `handle_move_bulk`, `finish_transition`, ~688): the dominant
  cluster. `handle_move` is 488 LOC and carries the entire BC-3.2.013 proactive-resolution
  gate (REQUIRED/OPTIONAL branches, allowedValues validation, interactive prompts).
- **RESOLUTION** (`resolve_resolution_by_name`, `load_resolutions`, ~90): name resolver +
  7-day-cache loader. Consumed only by MOVE and RESOLUTIONS.
- **RESOLUTION-PURE-HELPERS** (6 `pub` items, ~36): extracted for mutation-testability;
  **referenced cross-crate by `tests/issue_move_resolution_enforce.rs`**.
- **TRANSITIONS / RESOLUTIONS / ASSIGN / COMMENT / OPEN** (~233 combined): independent,
  small, low-coupling read/interaction handlers. ASSIGN and COMMENT each have a clean
  single-command body; OPEN and TRANSITIONS are trivial.

---

## 2. Coupling Map

### 2.1 `create.rs` internal call graph

```
handle_create ──(request_type.is_some())──> handle_jsm_create ──> resolve_jsm_request_type_id
      │                                            └─> parse_field_kv, JsmRequestBuilder, require_service_desk
      └─> helpers::{resolve_team_field, resolve_story_points_field_id, resolve_assignee_by_project,
                    compose_extra_fields, prompt_input}

handle_edit ──> parse_field_kv
            ├──(labels)──> handle_edit_bulk_labels ──> build_labels_edited_fields
            │                                       └─> render_bulk_edit_results
            ├──(2+ keys)─> handle_edit_bulk_fields ──> project_key_from_issue_key
            │                                       └─> render_bulk_edit_results
            ├──(dry-run, single)──> helpers::resolve_edit_fields  [field_resolve.rs]
            └──(single-key live)──> helpers::resolve_edit_fields, helpers::{resolve_team_field,
                    resolve_story_points_field_id}, json_output::edit_response,
                    is_cross_hierarchy_type_error / is_subtask_parent_error (+ hint consts)
```

Shared-helper dependence by cluster:

| Cluster | helpers.rs | field_resolve.rs | json_output.rs | other |
|---------|-----------|------------------|----------------|-------|
| PLATFORM-CREATE | resolve_team_field, resolve_story_points_field_id, resolve_assignee_by_project, compose_extra_fields, prompt_input | – | – | adf, get_or_fetch_cmdb_fields |
| JSM-CREATE | prompt_input | – | – | parse_field_kv (same file), JsmRequestBuilder, servicedesks |
| EDIT (single) | resolve_team_field, resolve_story_points_field_id, resolve_edit_fields (re-export) | resolve_edit_fields | edit_response | adf |
| EDIT-BULK | – | – | – | bulk client, BULK_MAX_KEYS |
| LABEL-HANDLING | – | – | edit_response | bulk client |

### 2.2 create ↔ edit entanglement (the hard part)

create and edit share **no private functions** and **no structs**. The coupling is
indirect (both depend on `helpers::*` and `parse_field_kv`) plus *pattern duplication*:

- Both resolve description via the same `spawn_blocking` stdin idiom (lines 149–159 and
  911–921) — duplicated, not shared.
- Both build a `BTreeMap<String,String>` echo map and a `serde_json::Value` `fields`
  object in parallel — same shape, separate code.
- `parse_field_kv` (`pub(crate)`) is the only function called by **both** `handle_edit`
  and `handle_jsm_create`. It is the single shared private-ish surface.
- The dispatch fork lives *inside* `handle_create` (lines 63–90): it constructs
  `JsmCreateArgs` and tail-calls `handle_jsm_create`. So create→jsm is a one-way edge with
  a struct boundary already in place (`JsmCreateArgs`). **This is a pre-cut seam.**

Entanglement points that resist extraction:

1. **The five `#[cfg(test)]` meta-tests are tightly coupled to *file* layout.**
   - `test_label_conflict_block_lists_every_relevant_flag` and
     `test_label_conflict_block_extractor_pin_12_members` do `include_str!("create.rs")`
     and globally scan for `conflicting.push("--…")` literals (lines 1966–2094). The guard
     comment at `handle_edit` (lines 445–449) explicitly reserves the variable name
     `conflicting` *for this file*. **If `handle_edit` moves to a new file, both meta-tests
     break** unless their `include_str!` target moves too.
   - `test_343_every_edit_field_is_categorized` does `include_str!("../mod.rs")` — that one
     is robust to create.rs sharding (targets cli/mod.rs).
2. **`parse_field_kv_proptests` and `is_cross_hierarchy_type_error_proptests`** (lines
   2213, 2301) reference `super::parse_field_kv` / `super::{Classification,
   is_cross_hierarchy_type_error}` — they must travel with whatever file owns those fns.
3. **`build_labels_proptests`** (line 2097) references `super::build_labels_edited_fields`
   — must travel with LABEL-HANDLING.

### 2.3 `workflow.rs` internal call graph

```
handle_move ──> finish_transition (also called from 3 gate branches)
            ├──> load_resolutions ──> resolve_resolution_by_name
            ├──> select_prompt_base_names, build_resolution_prompt,
            │     optional_prompt_default_index, resolve_interactive_choice, refuse_noninteractive
            ├──> helpers::prompt_input
            └──> json_output::move_response (via finish_transition)
handle_move_bulk ──> partial_match, resolve_bulk_await_timeout, render-results (inline, NOT shared
                     with create's render_bulk_edit_results — duplicated)
handle_resolutions ──> load_resolutions
handle_assign ──> helpers::resolve_assignee, json_output::{assign_*,unassign_response}
handle_comment ──> adf
```

Cross-file coupling for workflow.rs is light: `helpers::{prompt_input, resolve_assignee}`,
`json_output::*`, `adf`, `partial_match`, bulk client. The MOVE cluster is internally
dense (gate ↔ finish_transition ↔ load_resolutions ↔ 6 pure helpers) but the other five
handlers are nearly standalone.

Note: `handle_move_bulk` (workflow) and `render_bulk_edit_results` (create) both
hand-roll the same per-key success/error/inaccessible result rendering — duplicated
across the two files. A future shared `bulk_results.rs` could absorb both, but that is
out of scope for a pure size-sharding pass.

---

## 3. Load-Bearing Invariants a Split MUST Preserve

Each invariant is tagged with the owning function so a refactor can verify it survives.

| # | Invariant | Owner | Evidence |
|---|-----------|-------|----------|
| I-1 | **JSM `--request-type` dispatch fork.** `handle_create` short-circuits to `handle_jsm_create` gated *solely* on `request_type.is_some()`; absent → platform path byte-for-byte unchanged. | `handle_create` (create.rs:63–90) | ADR-0014; CLAUDE.md gotcha |
| I-2 | **JSM 9-step canonical guard ordering** (project → empty-RT → md+field-desc conflict → md-requires-desc → `require_service_desk` (first HTTP) → step-5 warnings AFTER Ok → RT resolve → build → POST). Warnings for `--type/--team/--points/--parent/--to/--account-id` fire only AFTER `require_service_desk` succeeds (suppressed on non-JSM). | `handle_jsm_create` (2452–2732) | BC-3.8.001..017 |
| I-3 | **JSM 401 auth-scheme-gated error rewrite.** Basic-auth → NotAuthenticated + API-token-expiry hint; OAuth → `write:servicedesk-request` scope hint. | `handle_jsm_create` (2667–2715) | BC-3.8.014/015 |
| I-4 | **`--field NAME=VALUE` first-`=` split + last-wins dedup.** | `parse_field_kv` (2359–2374) | BC-3.8.008; proptests at 2213 |
| I-5 | **`issue edit --label` single-vs-bulk endpoint fork.** ONE key → `PUT /issue/{key}` bare-string labels via `update_issue_labels`; TWO+ keys → `POST /bulk/issues/fields` with `{"name":…}` objects via `build_labels_edited_fields`. Payload shapes are asymmetric — do NOT unify. | `handle_edit_bulk_labels` (1204–1290) + `build_labels_edited_fields` (1148–1172) | BUG-LABEL-400; #446; proptests at 2097 |
| I-6 | **`issue edit --type` bulk camelCase/lowercase asymmetry.** `selectedActions` uses lowercase `"issuetype"`; `editedFieldsInput` uses camelCase `"issueType"`. | `handle_edit_bulk_fields` (1365–1395) | BC-3.4.018; #331 |
| I-7 | **Cross-project guard for bulk `--type`** (exit 64 before any HTTP when keys span >1 project). | `handle_edit` (614–633) + `project_key_from_issue_key` (1301–1306) | BC-3.4.019 |
| I-8 | **`--field` + `--label` mutual-exclusion → exit 64** (the `conflicting` block; without it, label→bulk routing silently drops `--field`). | `handle_edit` (450–497) | FIX-F5-001; meta-tests at 1966/2040 |
| I-9 | **C-1 multi-key bulk rejection** of single-key-only flags (parent/team/points/desc/markdown/field) → exit 64; runs BEFORE dry-run. | `handle_edit` (569–603) | issue #110 pt2; meta-test #343 |
| I-10 | **#398 description echo asymmetry.** Table mode echoes `description → (updated)` marker; JSON `changed_fields.description` carries the RAW user input string. Do NOT make them match. | `handle_edit` (single-key: 923–935 sets raw; 1108–1114 emits marker) + `json_output::edit_response` | BC-3.4.012/013; CLAUDE.md gotcha; VP-398-002/003 |
| I-11 | **Dry-run resolves `--field` INSIDE the dry-run block** (resolution errors exit 64, not suppressed) and emits simplified preview shapes that intentionally differ from wire shapes (labels/priority/issueType). `--field` echo on stdout (println), not stderr. | `handle_edit` dry-run block (636–828) | BC-3.4.015 inv 10; H-3(a)/(b) |
| I-12 | **`--type` 400 dual-gate enrichment** (get_issue → get_project_issue_types → classify; first-hint-wins; `--type` arm before `--no-parent` arm). | `handle_edit` (1016–1091) + `is_cross_hierarchy_type_error` (1557) + hint consts | BC-3.4.010/011 |
| I-13 | **BC-3.2.013 proactive resolution gate, single-key ONLY** (bulk move excluded; idempotency check fires first; REQUIRED vs OPTIONAL `(none)` sentinel; `--no-resolution` opt-out; `--resolution` validated against allowedValues). | `handle_move` (544–768) + 6 pure helpers | ADR-0015; CLAUDE.md gotcha |
| I-14 | **BC-3.2.009 reactive backstop** ("resolution required" 400 → exit 64 hint) preserved as fallback. | `finish_transition` (266–282) | ADR-0015 |
| I-15 | **Bulk move is NOT idempotent; single-key move IS** (already-in-target → exit 0). | `handle_move` (404–430) idempotent; `handle_move_bulk` unconditional | CLAUDE.md gotcha |
| I-16 | **`handle_move` uses `get_transitions_with_fields`; `handle_transitions` uses `get_transitions`** — distinct methods; `Transition.fields`/`is_conditional` carry `#[serde(skip_serializing)]` so `transitions --output json` is byte-identical. | `handle_move` (386) vs `handle_transitions` (964) | ADR-0015 §4 |
| I-17 | **Five `pub` resolution helpers are a stable cross-crate test API** — `jr::cli::issue::workflow::{resolve_interactive_choice, build_resolution_prompt, NONE_LABEL, refuse_noninteractive, select_prompt_base_names, optional_prompt_default_index}`. | workflow.rs (154–248) | `tests/issue_move_resolution_enforce.rs:1225,1271,1343,1388,…` |
| I-18 | **JSON render invariant (#526):** every `--output json` path routes through `output::render_json`. All emit sites in both files comply. | all handlers | CLAUDE.md convention |

---

## 4. Test Coupling

### 4.1 Where the tests live

- **create.rs inline (`#[cfg(test)]`, ~1,312 LOC, 46% of file):** five blocks —
  `mod tests` (#343 categorization meta-test + `--label` conflict meta-tests + extractors,
  1569–2095), `build_labels_proptests` (2097), `parse_field_kv_proptests` (2213),
  `is_cross_hierarchy_type_error_proptests` (2301), `test_project_key_extraction` (2813).
- **workflow.rs inline (`#[cfg(test)]`, ~141 LOC, 11%):** single
  `resolution_resolver_tests` block testing `resolve_resolution_by_name` (1201–1341).
- **Integration (tests/):** behavior is driven end-to-end through the CLI binary via
  wiremock (`JR_BASE_URL`). Relevant files: `issue_create_echo.rs`, `issue_create_jsm.rs`,
  `issue_create_json.rs`, `issue_edit_echo.rs`, `issue_edit_field.rs`,
  `issue_edit_labels.rs`, `issue_edit_no_parent.rs`, `issue_edit_type_errors.rs`,
  `issue_bulk.rs`, `issue_bulk_pr2.rs`, `issue_move_resolution_enforce.rs`,
  `issue_resolution.rs`, `comments.rs`, `jsm_request_api.rs`.

### 4.2 Private-fn test coupling (constrains the split)

- **create.rs:** all four proptest/unit blocks reference `super::*` private fns
  (`parse_field_kv`, `build_labels_edited_fields`, `Classification`,
  `is_cross_hierarchy_type_error`, `project_key_from_issue_key`). They must **move with
  their target functions**. This is mechanical (same-PR move), not a blocker.
- **create.rs source-scanning meta-tests** are the real constraint: the two `--label`
  conflict tests `include_str!("create.rs")` and scan for `conflicting.push(...)` literals.
  **If `handle_edit` is extracted to `edit.rs`, those two tests must change their
  `include_str!` target to the new file** (the guard comment at handle_edit:445 even
  warns about re-scoping). The #343 test reads `../mod.rs` and is unaffected.
- **workflow.rs:** `resolution_resolver_tests` references `super::resolve_resolution_by_name`
  (private) — moves with the RESOLUTION cluster. The six `pub` helpers are tested
  **cross-crate** in `tests/issue_move_resolution_enforce.rs` via the
  `jr::cli::issue::workflow::*` path. **If those helpers move out of the `workflow` module,
  the integration test imports break** (I-17). Either keep them in a module still reachable
  at `jr::cli::issue::workflow::…` or update the test imports in the same PR.

### 4.3 Would a split require moving tests?

Yes, but only inline tests, and only mechanically: each inline `#[cfg(test)]` block moves
to the file that ends up owning its `super::` target. The two `include_str!("create.rs")`
meta-tests additionally need their string-literal path retargeted. No integration test
needs to move for a size-shard (they invoke the binary), **except** that any change to the
`jr::cli::issue::workflow::*` public path forces import edits in
`issue_move_resolution_enforce.rs`.

---

## 5. Natural Seams (candidate extraction boundaries)

Entanglement cost = how much shared private state/struct/test plumbing must move or break.

### Seam A — Extract JSM-CREATE into `create/jsm.rs` (or `issue/jsm_create.rs`)
- **Moves:** `handle_jsm_create`, `resolve_jsm_request_type_id`, `JsmCreateArgs`. ~370 prod LOC.
- **Stays:** `handle_create` (keeps the dispatch fork + `JsmCreateArgs` construction),
  `parse_field_kv` (shared; make the new module `use super::parse_field_kv`).
- **Test fallout:** none direct — `parse_field_kv_proptests` stays with `parse_field_kv`.
  Integration `issue_create_jsm.rs` is binary-driven (no import change).
- **Pre-cut boundary already exists:** `JsmCreateArgs` is the param struct; the call is a
  single tail-call edge. The new module needs `parse_field_kv`, `helpers::prompt_input`,
  `JsmRequestBuilder`, `servicedesks`, `API_TOKEN_EXPIRY_HINT` — all already `pub`/importable.
- **Entanglement cost: LOW.** Cleanest cut in either file. Preserves I-1, I-2, I-3, I-4.

### Seam B — Extract EDIT into `create/edit.rs` (handle_edit + bulk + labels + hints)
- **Moves:** `handle_edit`, `handle_edit_bulk_fields`, `handle_edit_bulk_labels`,
  `build_labels_edited_fields`, `render_bulk_edit_results`, `project_key_from_issue_key`,
  `is_subtask_parent_error`, `is_cross_hierarchy_type_error`, `Classification`, the three
  hint consts, `JQL_CONFIRM_THRESHOLD`. ~1,150 prod LOC + ~1,250 test LOC.
- **Stays in create.rs:** `handle_create`, `parse_field_kv` (shared — edit.rs would
  `use super::parse_field_kv`), and the JSM cluster (unless Seam A also taken).
- **Test fallout (the cost driver):**
  - `build_labels_proptests`, `is_cross_hierarchy_type_error_proptests`,
    `test_project_key_extraction`, and `mod tests` (#343 + `--label` conflict tests) all
    move to edit.rs.
  - The two `--label` conflict meta-tests must retarget `include_str!("create.rs")` →
    `include_str!("edit.rs")` (the `conflicting` variable now lives in edit.rs). The
    `parse_field_kv_proptests` block stays with `parse_field_kv` in create.rs.
- **Entanglement cost: MEDIUM.** No shared structs to break, but the source-scanning
  meta-tests and four proptest blocks must move and one `include_str!` path must change.
  Preserves I-5 through I-12.

### Seam C — Extract MOVE into `workflow/move.rs` (or split workflow into read vs write)
- **Variant C1 (extract MOVE cluster):** move `handle_move`, `handle_move_bulk`,
  `finish_transition`, the RESOLUTION fns (`resolve_resolution_by_name`,
  `load_resolutions`), and the six `pub` helpers + `resolution_resolver_tests`. ~830 prod LOC.
  - **Test fallout: the six `pub` helpers are imported cross-crate as
    `jr::cli::issue::workflow::*` (I-17).** Moving them out of `workflow` breaks
    `issue_move_resolution_enforce.rs` imports unless (a) re-export them from `workflow`,
    or (b) update the test imports. This is the principal cost.
  - **Entanglement cost: MEDIUM** (only because of the public-API path; the code itself is
    a dense but self-contained cluster).
- **Variant C2 (extract the small standalone handlers instead):** move
  `handle_assign`, `handle_comment`, `handle_open`, `handle_transitions`,
  `handle_resolutions` into `workflow/interactions.rs` (or `assign.rs` + `comment.rs`).
  ~233 prod LOC, near-zero shared state (only `helpers::resolve_assignee`,
  `json_output::*`, `adf`, and `load_resolutions` for `handle_resolutions`).
  - `handle_resolutions` calls `load_resolutions` (stays in MOVE/RESOLUTION file) — would
    need `load_resolutions` to be `pub(super)` reachable, a 1-line visibility bump.
  - No inline tests attach to these five handlers; no test moves.
  - **Entanglement cost: LOW.** But it only removes ~233 LOC — leaves `handle_move`'s
    488-LOC bulk in place, so workflow.rs stays ~1,100 LOC (still over the 1,000 threshold).

### Highest-value / lowest-risk extraction

**Seam A (extract JSM-CREATE).** It is the only candidate that is simultaneously LOW
entanglement, has a pre-existing struct boundary (`JsmCreateArgs`), moves ~370 self-contained
prod LOC, breaks **zero** tests (inline or integration), and removes a cohesive concern
(JSM service-desk creation, ADR-0014) that is conceptually distinct from platform create.
After Seam A, create.rs drops to ~2,510 LOC; pairing it with **Seam B** in the same effort
takes create.rs to a ~340-LOC `create.rs` (platform create + dispatch + parse_field_kv),
a ~370-LOC `jsm.rs`, and a ~1,150-LOC `edit.rs` (still large but a single coherent command
with its own test corpus). Seam B alone carries the meta-test `include_str!` retarget cost,
so doing A first banks a clean win, and B second is where the bulk of the LOC reduction is.

For workflow.rs, the lowest-risk move is **C2** (extract the five standalone handlers, zero
test breakage) but it is low-value for the size goal; **C1** (extract MOVE) is the
high-value move but carries the `jr::cli::issue::workflow::*` public-API cost (I-17) — the
safest execution is to keep the six pure helpers re-exported from the `workflow` module so
the integration-test import path is preserved.
