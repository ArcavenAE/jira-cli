# Refactor Proposal — `src/cli/issue/` Shard Candidates

**Date:** 2026-06-25
**Author:** Architect agent (READ-ONLY analysis; no source modified)
**Based on:** `structural-analysis.md` (same directory) + source validation
**ADR reference:** ADR-0012 (src/cli/ shard threshold ≥1,000 LOC)
**Scope:** `create.rs` (2,880 LOC) and `workflow.rs` (1,341 LOC); `list.rs` is DOCUMENT-AS-IS per `docs/specs/list-rs-split.md`

---

## 1. Recommendation: DO-PARTIAL

**Verdict: DO-PARTIAL — execute Seam A (JSM extraction) now; stage Seam B (edit extraction) for the next active churn window; defer Seam C indefinitely.**

### Reasoning

**Against DEFER entirely:**
ADR-0012 exists precisely to prevent cognitive overload from large files. create.rs at 2,880 total LOC is nearly 3× the threshold, and even at ~1,568 prod LOC it is the largest handler file in the codebase. The JSM dispatch fork (ADR-0014) is conceptually orthogonal to platform create — it is already structurally isolated behind `JsmCreateArgs` and a single tail-call. That seam is free money: zero test breakage, ~370 prod LOC reduction, maximal conceptual cohesion.

**Against full DO (all three seams immediately):**
Seam B carries real test migration cost (~1,250 test LOC, two `include_str!` retargets, four proptest block moves). That work is non-trivial and introduces a non-zero risk of a test silently not running (the primary failure mode for inline test moves). Doing it speculatively — when there is no active issue-edit feature churn on `develop` — creates risk without near-term payoff. The file is large but not actively causing bugs; the test corpus is healthy.

Seam C (workflow.rs at 1,341 LOC / ~1,200 prod) has lower urgency. The MOVE cluster is internally dense but self-contained; the only mechanical pain is its density, not its coupling. Workflow.rs sits exactly 341 LOC over the ADR threshold — the structural analysis shows the standalone handlers (C2) add very little, and C1 carries a cross-crate public API migration cost that is disproportionate to the 1,341 LOC starting point.

**Conditions under which DEFER flips to DO for Seam B:**
- Any story that modifies `handle_edit` itself (e.g., a new `--field` type, a new bulk path, `--description` ADF changes) — pay the migration cost as part of that story's PR.
- File crosses 3,500 total LOC (the proptest corpus grows with new edit features).
- A new contributor cites create.rs size as an onboarding friction point.

**Conditions under which Seam C should be revisited:**
- A new move-related feature (new resolution strategy, bulk idempotency, multi-hop transitions) requires modifying `handle_move` — extract MOVE (C1) in that PR.
- workflow.rs crosses 1,600 total LOC.

---

## 2. Recommended Sequencing and Scope

### Story 1 — Seam A: Extract JSM-CREATE into `jsm_create.rs` (LOW risk, ~0.5 days)

**Scope:** Extract `handle_jsm_create`, `resolve_jsm_request_type_id`, and `JsmCreateArgs` into a new `src/cli/issue/jsm_create.rs`. The dispatch fork and `parse_field_kv` remain in `create.rs`.

This is a standalone story/PR. It can be delivered immediately without any preconditions.

### Story 2 — Seam B: Extract EDIT into `edit.rs` (MEDIUM risk, ~1.5 days)

**Scope:** Extract `handle_edit`, `handle_edit_bulk_fields`, `handle_edit_bulk_labels`, `build_labels_edited_fields`, `render_bulk_edit_results`, `project_key_from_issue_key`, `is_subtask_parent_error`, `is_cross_hierarchy_type_error`, `Classification`, the three hint consts (`NO_PARENT_CONTEXT_SENTENCE`, `CROSS_HIERARCHY_HINT`, `TYPO_HINT`), and `JQL_CONFIRM_THRESHOLD` into `src/cli/issue/edit.rs`. Inline test blocks travel with them.

**Sequencing constraint:** Story 2 should NOT be combined with Story 1 in a single PR. Doing them separately gives each a clean, reviewable diff and reduces the risk of a merge conflict on `create.rs` itself.

**Staged delivery: do Story 2 only if one of the flip conditions above is met, or on deliberate maintainability sprint.**

### Seam C: DEFER

Do not schedule workflow.rs sharding as a standalone story. Tie it to a future MOVE-touching feature story if one arises. Seam C2 (extract standalone handlers) is too low-value to justify a PR on its own.

---

## 3. Target Module Layout

### After Story 1 (Seam A)

```
src/cli/issue/
├── mod.rs                  (dispatch; add: pub(super) use jsm_create;  no other changes)
├── create.rs               (~2,510 LOC: handle_create + parse_field_kv + handle_edit + LABEL-HANDLING + EDIT-BULK + EDIT-BULK-HINTS + all inline tests)
├── jsm_create.rs           (NEW, ~370 prod LOC)
│   ├── handle_jsm_create   (pub(super) — called only from create.rs dispatch fork)
│   ├── resolve_jsm_request_type_id  (private)
│   └── JsmCreateArgs       (pub(super) — constructed in create.rs handle_create)
├── edit.rs                 (does not exist yet)
├── workflow.rs             (unchanged)
└── ... (all other siblings unchanged)
```

`create.rs` change: remove the three moved items; add at top:
```rust
use super::jsm_create::{JsmCreateArgs, handle_jsm_create};
```
(or declare jsm_create as a submodule of create if that visibility is preferred — see note below)

**Module declaration placement:** `jsm_create.rs` should be declared in `mod.rs` (not inside `create.rs`) because `create.rs` is not a directory-module. Add `mod jsm_create;` to `src/cli/issue/mod.rs` with `pub(super)` visibility on the module.

**Visibility on moved items:**
- `handle_jsm_create`: `pub(super)` — only `create.rs` calls it via the dispatch fork.
- `JsmCreateArgs`: `pub(super)` — constructed in `create.rs` and passed cross-module within the `issue` supermodule.
- `resolve_jsm_request_type_id`: `pub(self)` (private to jsm_create.rs) — only called by `handle_jsm_create`.

**What stays in create.rs:**
- `handle_create` (the dispatch fork remains exactly as-is; the call site `handle_jsm_create(... JsmCreateArgs {...})` is mechanically unchanged in behavior)
- `parse_field_kv` (stays pub(crate); used by both create.rs and jsm_create.rs)
- Everything in EDIT-ORCHESTRATOR, EDIT-BULK, LABEL-HANDLING, EDIT-ERROR-HINTS clusters
- All five inline test blocks

### After Story 2 (Seam B, if executed)

```
src/cli/issue/
├── mod.rs                  (add: mod edit; pub(super) use edit::handle_edit; no other changes)
├── create.rs               (~340 prod LOC: handle_create + parse_field_kv + parse_field_kv_proptests)
├── jsm_create.rs           (~370 prod LOC, from Story 1)
├── edit.rs                 (NEW, ~1,150 prod LOC + ~1,250 test LOC)
│   ├── handle_edit         (pub(super))
│   ├── handle_edit_bulk_fields  (private)
│   ├── handle_edit_bulk_labels  (private)
│   ├── build_labels_edited_fields  (private)
│   ├── render_bulk_edit_results    (private)
│   ├── project_key_from_issue_key  (private)
│   ├── is_subtask_parent_error     (private)
│   ├── is_cross_hierarchy_type_error  (private)
│   ├── Classification (enum)          (private)
│   ├── NO_PARENT_CONTEXT_SENTENCE, CROSS_HIERARCHY_HINT, TYPO_HINT  (private consts)
│   ├── JQL_CONFIRM_THRESHOLD          (private const)
│   └── [all moved inline test blocks]
├── workflow.rs             (unchanged)
└── ... (all other siblings unchanged)
```

**Imports edit.rs needs:**
```rust
use super::helpers;
use super::json_output;
use super::create::parse_field_kv;  // parse_field_kv stays in create.rs
use crate::adf;
use crate::api::assets::linked::get_or_fetch_cmdb_fields;
use crate::api::client::JiraClient;
use crate::api::jira::bulk::{BULK_MAX_KEYS, resolve_bulk_await_timeout};
use crate::api::jsm::servicedesks;          // for --field desc-conflict JSM guard only; re-check if used
use crate::cli::{IssueCommand, OutputFormat};
use crate::config::Config;
use crate::error::JrError;
use crate::output;
use crate::partial_match::{self, MatchResult};
```

**Note on `parse_field_kv` visibility after Seam B:** it must remain `pub(crate)` in `create.rs` so that `edit.rs` and `jsm_create.rs` can use it. If both edit.rs and jsm_create.rs need it, `pub(crate)` (already its current visibility) is the correct level — no change needed.

### workflow.rs — No Layout Change (Seam C deferred)

workflow.rs stays as-is. Its 1,341 LOC / ~1,200 prod is above the ADR threshold but the MOVE cluster is the dominant mass and extracting it costs the cross-crate pub API migration (I-17). Document this explicitly in `docs/adr/ADR-0012.md` as an acknowledged exception if desired (same pattern as list.rs DOCUMENT-AS-IS).

---

## 4. Invariant-Preservation Checklist

Each of the 18 load-bearing invariants from the structural analysis is assessed against the proposed splits.

| # | Invariant | Seam A touches? | Seam B touches? | How it stays intact |
|---|-----------|-----------------|-----------------|---------------------|
| **I-1** | JSM `--request-type` dispatch fork (sole gate: `request_type.is_some()`) | YES — fork stays in `handle_create` in `create.rs`; `handle_jsm_create` moves to `jsm_create.rs` but remains called identically | no | The fork condition, the `JsmCreateArgs` construction, and the call site are all unchanged. Only the call target moves to a different file. Verified: dispatch fork is lines 63–90 of `handle_create`; the moved fn signature is unchanged. |
| **I-2** | JSM 9-step canonical guard ordering | YES — moves with `handle_jsm_create` to `jsm_create.rs` | no | The entire function body moves intact. Step ordering is internal to the function; no reordering occurs. |
| **I-3** | JSM 401 auth-scheme-gated error rewrite | YES — moves with `handle_jsm_create` | no | Same as I-2: whole function body moves. |
| **I-4** | `parse_field_kv` first-`=` split + last-wins dedup | YES — `parse_field_kv` stays in `create.rs` and is called from `jsm_create.rs` via `use super::create::parse_field_kv` (or re-export) | YES — edit.rs calls it via `use super::create::parse_field_kv` | Function body does not change. The proptests at 2213 remain with the function in `create.rs`. |
| **I-5** | `--label` single-vs-bulk endpoint fork (payload asymmetry) | no | YES — `handle_edit_bulk_labels` and `build_labels_edited_fields` move to `edit.rs` together; the asymmetry is internal to those two functions | Body is moved verbatim. The comment `// Bare strings apply only to PUT /rest/api/3/issue single-key path` travels with the function. |
| **I-6** | `--type` bulk camelCase/lowercase asymmetry | no | YES — `handle_edit_bulk_fields` moves to `edit.rs` | Function body moves verbatim; camelCase/lowercase literals are internal to the function body. |
| **I-7** | Cross-project guard for bulk `--type` (exit 64) | no | YES — `handle_edit` (614–633) and `project_key_from_issue_key` both move to `edit.rs` | Both functions move together. The guard in `handle_edit` calls `project_key_from_issue_key`; since both are in the same new file the `super::` reference becomes an intra-file call. |
| **I-8** | `--field` + `--label` mutual-exclusion → exit 64 (the `conflicting` block) | no | YES — `handle_edit` moves; the `conflicting` variable and the comment (lines 445–449) move with it | **Critical:** the two meta-tests (`test_label_conflict_block_lists_every_relevant_flag` and `test_label_conflict_block_extractor_pin_12_members`) must retarget `include_str!("create.rs")` → `include_str!("edit.rs")`. These tests move to `edit.rs` and their string literal changes. See Section 5. |
| **I-9** | C-1 multi-key bulk rejection (runs before dry-run) | no | YES — lives inside `handle_edit` (569–603); moves with function | Behavior is internal to `handle_edit`; no callsite changes. |
| **I-10** | #398 description echo asymmetry (table marker vs JSON raw input) | no | YES — both the table-marker emission (1108–1114) and the raw-input JSON path (923–935) are inside `handle_edit`; `json_output::edit_response` is in `json_output.rs` (unchanged) | The asymmetry is enforced by the two separate code paths inside `handle_edit`; moving the function preserves this. `json_output.rs` does not move. |
| **I-11** | Dry-run resolves `--field` inside dry-run block (not suppressed); simplified preview shapes differ from wire shapes | no | YES — dry-run block is inside `handle_edit` (636–828); moves with function | Invariant is internal to `handle_edit`. No behavior changes. |
| **I-12** | `--type` 400 dual-gate enrichment (classifier + hint consts) | no | YES — `handle_edit` (1016–1091), `is_cross_hierarchy_type_error`, `is_subtask_parent_error`, hint consts all move to `edit.rs` together | All four items move as a group; the call graph is intra-file after the move. The proptests at 2301 travel with `is_cross_hierarchy_type_error` to `edit.rs`. |
| **I-13** | BC-3.2.013 proactive resolution gate (single-key only; `--no-resolution` opt-out) | no | no | Lives in `handle_move` in `workflow.rs`; untouched by either seam. |
| **I-14** | BC-3.2.009 reactive backstop in `finish_transition` | no | no | Lives in `workflow.rs`; untouched. |
| **I-15** | Bulk move is NOT idempotent; single-key move IS | no | no | Lives in `workflow.rs`; untouched. |
| **I-16** | `handle_move` uses `get_transitions_with_fields`; `handle_transitions` uses `get_transitions` | no | no | Lives in `workflow.rs`; untouched. |
| **I-17** | Six `pub` resolution helpers are a stable cross-crate test API (`jr::cli::issue::workflow::*`) | no | no | `workflow.rs` does not move. The integration test import paths (`tests/issue_move_resolution_enforce.rs:1225,1271,1343,1388,1433`) remain valid. This invariant is the primary reason Seam C is deferred. |
| **I-18** | JSON render invariant (#526): every `--output json` path routes through `output::render_json` | YES (check `handle_jsm_create`) | YES (check `handle_edit` emit sites) | All emit sites in both moved functions currently comply. The move does not change the call sites; `output::render_json` is at crate level and is unaffected by module relocation. **Verification step in each PR:** grep for `serde_json::to_string_pretty` and `serde_json::json!` in the new file to confirm no direct JSON printing was introduced. |

---

## 5. Test-Migration Plan

### Seam A — jsm_create.rs

**Inline tests:** None. No `#[cfg(test)]` block in create.rs references `handle_jsm_create` or `resolve_jsm_request_type_id` directly. The `parse_field_kv_proptests` block stays with `parse_field_kv` in `create.rs`.

**Integration tests:** `tests/issue_create_jsm.rs` and `tests/jsm_request_api.rs` invoke the binary end-to-end (`jr issue create --request-type …`). They have no import dependency on `handle_jsm_create` directly. No changes needed.

**Action required for Seam A:**
- None on tests. Zero test breakage, confirmed by structural analysis.

### Seam B — edit.rs

**Inline test blocks that move (from create.rs to edit.rs):**

| Block | Line range in create.rs | References `super::` items | Destination |
|-------|------------------------|---------------------------|-------------|
| `mod tests` (label conflict meta-tests + #343) | 1569–2095 | `handle_edit` (indirectly, via source scan); `BTreeSet` | Moves to `edit.rs`; the `use super::*` import block must be verified |
| `build_labels_proptests` | 2097–2212 | `super::build_labels_edited_fields` | Moves to `edit.rs` |
| `is_cross_hierarchy_type_error_proptests` | 2301–2357 | `super::{Classification, is_cross_hierarchy_type_error}` | Moves to `edit.rs` |
| `test_project_key_extraction` | 2813–2879 | `super::project_key_from_issue_key` | Moves to `edit.rs` |

**Block that stays in create.rs:**
- `parse_field_kv_proptests` (2213–2299): references `super::parse_field_kv`, which stays in `create.rs`.

**Critical `include_str!` retargets (two lines, each a separate literal):**
1. `test_label_conflict_block_lists_every_relevant_flag` (line 1967 of create.rs as it exists today):
   `include_str!("create.rs")` → `include_str!("edit.rs")`
2. `test_label_conflict_block_extractor_pin_12_members` (line 2042):
   `include_str!("create.rs")` → `include_str!("edit.rs")`

These two literal changes are required because `handle_edit` and the `conflicting` variable move to `edit.rs`. The `conflicting.push(...)` lines that the extractor scans will exist in `edit.rs`, not `create.rs`, after the move.

The guard comment at `handle_edit` lines 445–449 (which says "the variable name 'conflicting' is reserved for this block — test_label_conflict_block_lists_every_relevant_flag uses a global scan of conflicting.push(...) in create.rs") must be updated to read "in edit.rs". This comment is the documentation of the coupling and must stay accurate.

**Integration tests — no import changes required for Seam B.** All integration tests in `tests/` invoke the CLI binary. `issue_edit_echo.rs`, `issue_edit_field.rs`, `issue_edit_labels.rs`, `issue_edit_no_parent.rs`, `issue_edit_type_errors.rs`, `issue_bulk.rs`, `issue_bulk_pr2.rs` are all binary-driven. No source import paths reference `create::handle_edit` or any EDIT cluster fn directly.

**Re-export strategy for `parse_field_kv`:**
After Seam B, `parse_field_kv` remains in `create.rs` with `pub(crate)`. Both `edit.rs` and `jsm_create.rs` import it via:
```rust
use crate::cli::issue::create::parse_field_kv;
```
This is the simplest approach and avoids creating a new shared-utilities file. Alternatively, move `parse_field_kv` to `helpers.rs` (already `pub(super)`) — but that changes a currently stable shared-file, which is additional scope for this refactor. Keep it in `create.rs`.

---

## 6. Risk Map and Effort Estimate

### Seam A — Extract JSM-CREATE into `jsm_create.rs`

| Dimension | Assessment |
|-----------|-----------|
| Risk level | **LOW** |
| Effort | **0.5 days** (2–3 story points): file creation, move three items, update imports in create.rs, add module declaration in mod.rs, verify `cargo test` passes |
| Specific failure modes | (1) `pub(super)` on `handle_jsm_create` and `JsmCreateArgs` may need to be adjusted if mod.rs dispatch path is not through the `issue` module hierarchy — verify the call chain. (2) `parse_field_kv` must be reachable from `jsm_create.rs`; since it is `pub(crate)` in `create.rs` and both are in the same crate, the import `use crate::cli::issue::create::parse_field_kv;` is valid — no visibility change needed. (3) `API_TOKEN_EXPIRY_HINT` from `crate::error` is already `pub(crate)`; no issue. |
| Test risk | Essentially zero. No inline tests migrate. The five integration test files for JSM are binary-driven. |
| Regression surface | `cargo test --lib` (all inline tests pass; zero moves) + `cargo test --test issue_create_jsm` + `cargo test --test jsm_request_api` |

### Seam B — Extract EDIT into `edit.rs`

| Dimension | Assessment |
|-----------|-----------|
| Risk level | **MEDIUM** |
| Effort | **1.5 days** (5–7 story points): file creation, move ~1,150 prod LOC + ~1,250 test LOC, four test block moves, two `include_str!` retargets, import updates in `edit.rs`, update the guard comment, verify `cargo test` passes, verify no silent non-running test |
| Specific failure modes | (1) **Silent non-running test risk** (highest concern): an inline `#[cfg(test)]` block that fails to compile silently (e.g., a missing `use` import in the moved block) will not run but will not fail the build if the error is suppressed by a conditional. Mitigation: run `cargo test --lib 2>&1 | grep -i "test"` and verify counts match pre-refactor counts. (2) `include_str!` retarget: if the developer forgets to update one of the two literals, the meta-test will scan `edit.rs` for patterns that will still exist there (same file), so it will pass — but if they update neither, the test continues scanning `create.rs` where `conflicting.push` no longer exists, and will find zero entries, causing a hard failure. Mitigation: the test itself provides the safety net, but the developer must update both literals. (3) `JQL_CONFIRM_THRESHOLD` const is private; if a test outside of `edit.rs` references it (check with `grep -r JQL_CONFIRM_THRESHOLD tests/`), it may break — current evidence is that no integration test references this const directly. (4) Any new `--field` or `--edit` story in flight when Seam B lands creates a merge conflict on create.rs. Keep the story short and merge quickly. |
| Test risk | MEDIUM: four test block moves + two `include_str!` literal changes + risk of import drift inside moved test blocks. |
| Regression surface | `cargo test --lib` (full inline suite), `cargo test --test issue_edit_*`, `cargo test --test issue_bulk*` |

### Seam C — Deferred

Not scheduled. If the decision reverses, effort for C1 (extract MOVE) is estimated at **2 days** (7–8 story points) due to the cross-crate pub API migration: updating five import lines in `tests/issue_move_resolution_enforce.rs` or adding re-exports to `workflow.rs` mod-level re-export stubs. The re-export approach (preferred) keeps I-17 intact without touching integration test files.

---

## 7. VSDD Framing

This refactor is **behavior-preserving**. No new behavioral tests are needed. The safety net is the full existing regression suite.

### What "behavior-preserving" means in verification terms

- CLI exit codes for all 18 load-bearing invariants are unchanged.
- JSON output shapes are unchanged (I-18; `output::render_json` call sites do not move).
- No public API surface changes (`jr::cli::issue::workflow::*` pub helpers stay; `parse_field_kv` pub(crate) stays).
- The regression suite is the complete proof: byte-identical CLI behavior is asserted by the existing integration tests that invoke the binary end-to-end.

### Per-story VSDD delivery

Each seam should be its own GitHub story/PR through the standard worktree → review → gated-merge pipeline:

- **Story 1 (Seam A):** Branch `refactor/issue-jsm-create-extract`. CI gate: `ci-gate` passes. Merge to `develop`. PR description: "Extract handle_jsm_create to jsm_create.rs (ADR-0012 shard, behavior-preserving). No behavioral changes."
- **Story 2 (Seam B, conditional):** Branch `refactor/issue-edit-extract`. CI gate: `ci-gate` passes. PR description: "Extract handle_edit to edit.rs (ADR-0012 shard, behavior-preserving). Test LOC migrated; include_str! retargeted."

### Assertion: byte-identical CLI behavior

To give the human confidence during review, include in each PR description the output of:
```
cargo test --lib 2>&1 | tail -1        # confirm test count matches pre-refactor
cargo test --test issue_create_jsm -- --nocapture 2>&1 | grep -E "^test .* (ok|FAILED)"
cargo test --test issue_edit_echo -- --nocapture 2>&1 | grep -E "^test .* (ok|FAILED)"
```
These outputs should be identical before and after the move.

### No new behavioral tests

The refactor deliberately introduces no new test coverage gaps and requires no new behavioral tests. The existing VP/BC coverage (BC-3.4.*, BC-3.8.*, BC-3.2.*) is unchanged — all are tested at the binary level, not at the per-module fn level (except the pure helper proptests that travel with their functions).

---

## Summary for Orchestrator

| | Seam A | Seam B | Seam C |
|---|--------|--------|--------|
| Verdict | DO (now) | DO (on churn trigger) | DEFER |
| New file | `jsm_create.rs` | `edit.rs` | — |
| Prod LOC moved | ~370 | ~1,150 | — |
| Test LOC moved | 0 | ~1,250 | — |
| include_str! retargets | 0 | 2 | — |
| Cross-crate API impact | None | None | Significant (I-17) |
| Risk | LOW | MEDIUM | MEDIUM-HIGH |
| Effort | 0.5 days | 1.5 days | 2 days (if reversed) |

**Total effort for the recommended scope (A now + B on trigger): ~2 days.**
**Effort for DO-ALL (A + B + C): ~4 days.** Not recommended.
