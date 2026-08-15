---
document_type: delta-analysis
cycle: component-mgmt
mode: brownfield-feature
producer: state-manager
timestamp: 2026-08-15
status: complete
feature: component-management bundle (issues #604, #605, #606, #608)
intent: feature
feature_type: backend (no UI surface -- UX/a11y/e2e-browser dimensions N/A)
scope: non-trivial (full F1-F7)
trivial: false
route: Full F1-F7 bundle, 4-wave sequence
inputs:
  - .factory/phase-f1-delta-analysis/impact-boundary-components.md
  - .factory/phase-f1-delta-analysis/business-analyst-input-components.md
input-hash: "e8af148"
---

# Phase F1 Delta Analysis: Component Management Bundle (#604, #605, #606, #608)

**Consolidates** the architect's impact-boundary analysis and the business-analyst's
spec-placement/BC-mapping analysis into one F1 gate artifact. Neither input file is
modified by this document -- both remain the source of full detail; this report is the
synthesis + decision record for the human F1 gate.

- Architect input: `.factory/phase-f1-delta-analysis/impact-boundary-components.md`
- Business-analyst input: `.factory/phase-f1-delta-analysis/business-analyst-input-components.md`
- Research: `.factory/research/component-delete-and-bulk-wire-2026-08-15.md` (referenced
  below, not inlined -- see that file for full source citations and verdicts)
- Machine-readable affected-file list: `.factory/phase-f1-delta-analysis/affected-files-components.txt`
  (already exists, left as-is)

---

## 1. Feature Summary

| # | Issue | One-line description | Disposition |
|---|---|---|---|
| 1 | #604 | `jr component` command family: `list`/`create`/`edit`/`delete` | **IN SCOPE — Wave 1 (foundation)** |
| 2 | #605 | `jr issue create/edit --component add:/remove:` | **IN SCOPE — Wave 2** |
| 3 | #606 | `--component` filter on `jr issue list` (OR/`not:`/`none`/`all:`) | **IN SCOPE — Wave 3** |
| 4 | #608 | `jr component rename` (`--project`/`--all-projects`/`--dry-run`) | **IN SCOPE — Wave 4** |
| 5 | #607 | Shared multi-valued/negatable filter grammar retrofit | **DEFERRED** — subsystem-level retrofit; #606 lands via a pre-composed clause (mirrors `asset_clause`/`team_clause`) specifically to avoid needing this. Per-issue rationale posted in the GitHub comment on #607. |
| 6 | #609 | Cross-issue component impact scan | **DEFERRED** — subsystem-level scope, partly infeasible as originally framed. Per-issue rationale posted in the GitHub comment on #609. |

Intent: **feature** (net-new command group + net-new flags on existing commands).
Feature type: **backend** — `jr` is a CLI with no GUI; UX/accessibility/e2e-browser
convergence dimensions are N/A for this bundle, same disposition as every prior `jr`
feature cycle. Scope: **non-trivial** — new files, new cache family, new BC file, cross-file
wire-shape work — routes through the full F1-F7 Feature Mode pipeline, not quick-dev.

---

## 2. Architecture Verdict (architect)

**No structural/interface redesign, no new subsystem, no new ADR-mandated pattern
shift.** Internal changes to existing modules plus net-new peer modules that mirror
existing structural conventions (`team.rs` / `api/jira/teams.rs` / `resolve_team_field` /
`TeamCache` is the load-bearing precedent quadruple this bundle repeats for Components).
`Command`/`IssueCommand`/new `ComponentCommand` are additive `clap` extensions, matching
the `AttachmentSubcommand` "additive-only coordination" precedent already documented in
`src/cli/mod.rs`. The one place this bundle brushes a structural limit -- `FilterOptions`/
`build_filter_clauses` in `list.rs` being flat/AND-only today -- is resolved by
pre-composing the `--component` clause the way `asset_clause`/`team_clause` already do,
not by extending the options-bag shape itself; the genuinely structural retrofit (#607) is
correctly deferred.

### Impact table

| File | Class | Notes |
|---|---|---|
| `src/cli/component.rs` | **NEW** | `jr component list/create/edit/delete` handlers; structural mirror of `src/cli/team.rs` |
| `src/api/jira/components.rs` | **NEW** | list/get/create/update/delete + relatedIssueCounts; mirrors `boards.rs`/`teams.rs` |
| `src/types/jira/component.rs` | **NEW** | Full component-resource shape (id, name, description, lead, assigneeType, project) -- distinct from the existing embedded `issue.rs::Component` (name-only) |
| `src/cli/mod.rs` | MODIFIED | `Command::Component`, `ComponentCommand` enum, `--component` args on `IssueCommand::{List,Create,Edit}` -- purely additive |
| `src/cache.rs` | MODIFIED | New components cache family, keyed-map-per-project pattern (`ProjectMeta`/`ObjectTypeAttrCache` precedent), model-b swallow+warn writer |
| `src/cli/issue/helpers.rs` | MODIFIED | New `resolve_component(...)` -- structural clone of `resolve_team_field`, NOT a shared/generic implementation |
| `src/cli/issue/edit.rs` | MODIFIED | **HIGH regression-risk file** -- see §5 |
| `src/cli/issue/create.rs` | MODIFIED | LOW risk -- additive `--component` on platform create path only; JSM dispatch fork and DEC-188 pre-flight guard ordering must stay byte-for-byte unchanged on the non-`--component` path |
| `src/cli/issue/list.rs`, `src/jql.rs` | MODIFIED | **MEDIUM-HIGH regression-risk files** -- see §5 |
| `src/api/jira/issues.rs` | MODIFIED | New `update_issue_components` (single-issue `update`-verb path) |
| `src/types/jira/mod.rs`, `src/api/jira/mod.rs`, `src/types/jira/editmeta.rs`, `src/partial_match.rs` | DEPENDENT | Re-export wiring / read-only contract consumption, no logic change |

**BC placement (business-analyst):** NEW `bc-8-components.md` for #604 CRUD/delete-safety
(§8.1/§8.2) and #608 rename (§8.3) -- sized/shaped like `bc-5-boards-sprints.md`, not the
smaller cross-cutting `X.6 Teams` subsection (estimate ~20-28 BCs). MODIFIED sub-BCs in
`bc-3-issue-write.md §3.4` for #605 (directly symmetric with the existing label
add/remove `BC-3.4.006`/`BC-3.4.020` pair) and `bc-2-issue-read.md §2.1` for #606
(symmetric with the asset/status resolution-then-filter pattern, `BC-2.1.011`-`015`). The
`Component` struct in `src/types/jira/issue.rs` currently lacks an `id` field -- every one
of the four issues needs it; amending that struct in place (mirroring the 2026-08-13
`duedate` precedent, BC-2.2.028/BC-2.3.036) is the single shared prerequisite all four
issues' BCs implicitly depend on.

---

## 3. Regression Risk

| Zone | Risk | Why |
|---|---|---|
| `src/cli/issue/edit.rs` | **HIGH** | Dense existing logic (`handle_edit_bulk_labels`, C-1 single-key-only guards, the `--field`+`--label` mutual-exclusion block, dry-run preview assembly). Components diverge from labels at the **wire layer**: single-issue native `update` verb wraps names as `{"add":{"name":X}}` objects (not labels' bare-string `{"add":"foo"}`) -- confirmed by research. The dry-run JSON preview must gain a `components` entry using the same "simplified preview, not wire-identical" convention documented at `edit.rs` (BC-3.4.021 precedent); `components` is also a real Jira system-field name reachable via the generic `--field` escape hatch, so `BC-3.4.017` Gate B's four-field mutual-exclusion list is a strong candidate for amendment to five. |
| `src/cli/issue/list.rs` + `src/jql.rs` | **MEDIUM-HIGH** | `build_filter_clauses`/`FilterOptions` and `build_jql_base_parts` are exercised by ~15 existing unit tests asserting **exact clause order** (positional `Vec<String>` equality, not membership). Inserting a pre-composed `component_clause: Option<&str>` field in the wrong struct-literal position, or the wrong push-order, breaks passing tests even though the underlying JQL would still be correct. `jql.rs`'s `escape_value`/`build_asset_clause` quote-then-backslash escaping conventions must be followed exactly for free-text component names. |
| `src/cli/mod.rs`, `src/cli/issue/create.rs`, `src/cache.rs`, `src/cli/issue/helpers.rs` | LOW-MEDIUM | Additive-only surfaces; Rust exhaustiveness checking is the safety net on `mod.rs`; `create.rs`'s DEC-188 pre-flight guard ordering must stay intact; `cache.rs`'s profile-scoping invariant (`profile: &str` first arg) is a hard convention per CLAUDE.md's "Multi-profile boundary" gotcha. |

**Files explicitly NOT touched (regression baseline):** `src/api/client.rs`,
`src/api/auth*.rs`, `src/api/pagination.rs`, `src/api/rate_limit.rs`,
`src/api/refresh_coordinator.rs`, `src/adf.rs`, `src/config.rs`, `src/output.rs`,
`src/error.rs`, `src/duration.rs`, `src/partial_match.rs` (used, not modified),
`src/observability.rs`, all of `src/cli/{auth,assets,board,init,project,queue,requesttype,
sprint,user,worklog}.rs`, all of `src/api/jsm/`, `src/api/assets/`,
`src/cli/issue/{workflow,interactions,links,assets,changelog,field_resolve,attachments,
format,view,comments,json_output}.rs`.

Regression-risk **stories** flagged by the business-analyst as needing full re-run:
`S-396-issue-edit-field-flag.md`, `S-407-label-conflict-block-coverage-and-meta-test.md`
(its `test_label_conflict_block_lists_every_relevant_flag` meta-test will fail if
`--component` isn't slotted into the flag partition), `S-398-issue-edit-create-changed-
fields-echo.md`, `S-639-1.md` (DEC-188 ordering), `S-692-1-dry-run-stdin-adf-preview.md`,
`S-388-...` (400-classification style check), plus `build_filter_clauses`/`list.rs`
coverage in `tests/issue_list_errors.rs`/`tests/issue_list_assets.rs`. Full test-file
inventory: business-analyst input §4.

---

## 4. Approved Wave Sequence

**Wave 1 -- #604 (foundation: resolver + cache + API + CLI).** Self-contained,
independently shippable even if #605/#606/#608 slip. Delivers `src/types/jira/component.rs`,
`src/api/jira/components.rs` (all 5 endpoints), `src/cache.rs` components cache family,
`src/cli/issue/helpers.rs::resolve_component`, `src/cli/component.rs` + `mod.rs` wiring
(list/create/edit/delete, including the `--move-to`/`--orphan` delete-safety guard).

**Wave 2 -- #605 (depends on Wave 1).** `issue create/edit --component`. Single-key
`update`-verb path first (`src/cli/issue/create.rs`, `src/cli/issue/edit.rs`). Multi-key
bulk path per the GATE-RESOLVED research decision below.

**Wave 3 -- #606 (depends on Wave 1, parallelizable with Wave 2).** `src/jql.rs::
build_component_clause` (OR/`not:`/`none`/`all:`), `src/cli/issue/list.rs` `FilterOptions`
gains `component_clause`. No shared files with Wave 2 (`create.rs`/`edit.rs` vs.
`list.rs`/`jql.rs`), so it can run in parallel with Wave 2 if capacity allows.

**Wave 4 -- #608 (depends on Wave 1, last).** `jr component rename`, thin wrapper over
`update_component` (PUT-keeps-id, confirmed) with name-collision `--dry-run` preview.
Lightweight relative to the others; sequenced last since it's the smallest, lowest-risk
piece and benefits from Wave 1 having stabilized under real use.

**Cross-wave shared risk:** the F2-recommended ADR (component resolution/caching/
delete-safety/wire-shape-asymmetry, one ADR not several) should land before Wave 1
implementation starts -- every subsequent wave inherits whatever Wave 1 decides there.

---

## 5. GATE-RESOLVED Decisions (research-backed)

### (1) Delete-safety policy for `jr component delete` (#604)

Research (`.factory/research/component-delete-and-bulk-wire-2026-08-15.md` Q1) confirms:
`DELETE /rest/api/3/component/{id}` with `moveIssuesTo` omitted **permanently** removes
the component association from affected issues with **no Jira-side recovery** (no
component trash, no archive/restore/undelete endpoint) and **no API-level confirmation
step** (single unguarded destructive call, Q1.4). Whether the delete cascade writes a
per-issue changelog entry is **INCONCLUSIVE** (leans yes, not contractually guaranteed --
Q1.3), so `jr` must not rely on Jira's own history as an undo mechanism.

**Adopted: layered guardrails**, mirroring the ADR-0015 `--resolution`/`--no-resolution`
proactive-guard shape and the existing comment-delete `--yes` convention:
- `component delete` **refuses** (exit 64) without EITHER `--move-to <id>` OR explicit
  `--orphan` -- no silent default either way.
- The irreversible `--orphan` path **additionally requires** `--yes`, or an interactive
  confirm when stdin is a TTY (honoring `--no-input`).
- **Snapshot affected issue keys before deleting** (client-side safety net, since Jira's
  own changelog guarantee is inconclusive) -- `jr` can report what was orphaned even if
  Jira's history doesn't reliably surface it.

### (2) Bulk multi-key component edit wire shape (#605 Wave 2)

Research (Q2) **CONFIRMS** the wire shape from primary Atlassian docs, triple-corroborated
(doc example + swagger OpenAPI + apidog mirror):

```
selectedActions: ["components"]
editedFieldsInput.multiselectComponents: {
  fieldId: "components",
  components: [{"componentId": <integer>}, ...],
  bulkEditMultiSelectFieldOption: "ADD" | "REMOVE" | "REPLACE" | "REMOVE_ALL"
}
```

**NEW asymmetry vs. `jr`'s existing single-issue `update`-verb path**: bulk requires an
**integer `componentId`**; single-issue uses `{"name": ...}`/`{"id": ...}` objects. This is
the same class of per-path wire divergence already documented in CLAUDE.md for
`labelsFields`/`"labels"` and `issueType`/`"issuetype"` -- pin it in writing (F2 ADR) before
implementation, not discovered via a live 400 (per BUG-LABEL-400 precedent).

**Disposition:** implement the multi-key bulk path in **Wave 2** against the documented
shape (do NOT default to single-key-only out of doc-uncertainty -- unlike the bulk-transition
case, this doc example is correct-looking and triple-corroborated) but **GATE it behind a
live-Jira smoke test before shipping**, per the `FIX-BULK-TRANSITION-001`/#446 discipline:
one live ADD, one REMOVE, one REPLACE against >=2 issues in one project, asserting the
async task reports success and components land as expected. Reuse the existing bulk poll/
timeout machinery (`JR_BULK_AWAIT_TIMEOUT_SECS`, unknown-status grace). Resolve component
names -> numeric ids client-side (via Wave 1's resolver) before building the bulk payload,
since bulk rejects name/id-string objects. If the live smoke test contradicts the
documented shape, fall back to single-key-only for this cycle and record the true shape,
exactly as `FIX-BULK-TRANSITION-001` did for bulk transitions.

---

## 6. F2 Obligations (not resolved here)

(a) **Recommended ADR** covering component resolution/caching/delete-safety/wire-shape-
asymmetry as **one** decision (not several) -- F2 (spec evolution) owns ADR authorship.
Should cover: cache layout (keyed-map-per-project vs. per-project cache file --
recommend keyed-map, matching `ProjectMeta`/`ObjectTypeAttrCache`), cross-project name
resolution strategy when `--project` is omitted and a name is ambiguous across projects,
the delete-safety policy recorded in §5(1) above (and why -- Jira's own delete silently
orphans associations when `moveIssuesTo` is omitted; the "no changelog" claim is
explicitly UNVERIFIED per research, do not assert it), and the `update`-verb wire-shape
asymmetry recorded in §5(2) above.

(b) **New `bc-8-components.md` triggers the 8-surface count-propagation guard**
(`scripts/check-bc-cumulative-counts.sh` per CLAUDE.md): (A) per-file frontmatter
`total_bcs`, (B) `BC-INDEX.md` section headers, (C) `BC-INDEX.md` `sections:` list lines,
(D) `CANONICAL-COUNTS.md` per-file table, (E) `CANONICAL-COUNTS.md` body preamble prose,
(F) `BC-INDEX.md` frontmatter `total_bcs`, (G) `CANONICAL-COUNTS.md` Sum row, plus the
grand-total prose -- and additionally a new row in `README.md`'s Document Map (currently
"7 bounded contexts + 1 cross-cutting"). Must propagate in the **same F2 burst** that adds
the new BCs (CLAUDE.md's documented failure mode for this class of change is a same-commit
doc-fallout miss).

**Open F2 design point (flagged, not decided):** full component resource type in new
`src/types/jira/component.rs` vs. extending the embedded name-only
`src/types/jira/issue.rs::Component` (the business-analyst notes it currently lacks an
`id` field, which all four issues need). Architect's recommendation is a new file
(precedent: `types/jira/team.rs`, `types/jira/board.rs` already separate per-resource
files from leaner embedded shapes elsewhere) -- F2/architecture makes the final call.

---

## Summary

Greenfield core (#604): 3 new files (CLI, API, types) + 2 modified cross-cutting files
(`mod.rs` wiring, `cache.rs` new family) -- mirrors `team.rs` exactly. Consumption (#605,
#606, #608): all MODIFIED, no new files beyond what #604 adds; risk concentrates in
`edit.rs` (wire-shape asymmetry vs. labels) and `list.rs`/`jql.rs` (AND-only
`FilterOptions` today, resolved via a pre-composed clause). No new subsystem, no
interface redesign. One ADR recommended for F2. Both GATE-RESOLVED research decisions
(delete-safety layered guardrails; bulk wire shape implement-with-smoke-test-gate) are
recorded above and unblock F2/F3 spec and story authoring for Waves 1-4.

**Human F1 gate: APPROVED 2026-08-15.**
