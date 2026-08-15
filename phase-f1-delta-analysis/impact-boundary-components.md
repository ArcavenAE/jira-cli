# Impact Boundary — Component Management Bundle (#604, #605, #606, #608)

**Phase:** F1 (Feature Mode delta analysis) — architect deliverable
**Scope:** `jr component` command family (#604), `issue create/edit --component` (#605),
`--component` filter on `issue list` (#606), `jr component rename` (#608).
**Deferred:** #607 (shared filter grammar — subsystem-level retrofit), #609 (impact scan —
subsystem-level + partly infeasible). Neither is touched by this analysis.
**Grounding:** `.factory/specs/architecture/ARCH-INDEX.md`, `src/cli/mod.rs`,
`src/cli/team.rs`, `src/api/jira/teams.rs`, `src/api/jira/boards.rs`, `src/cache.rs`,
`src/cli/issue/{list,edit,create,helpers}.rs`, `src/jql.rs`, `src/types/jira/issue.rs`,
`src/api/jira/issues.rs`, `src/types/jira/editmeta.rs`.

---

## 1. Subsystem mapping (per ARCH-INDEX.md Subsystem Registry)

| SS-ID | Name | Touched by this bundle |
|-------|------|-------------------------|
| SS-02 | CLI Layer (`src/cli/`) | Yes — new `component.rs` + edits to `mod.rs`, `issue/{edit,create,list,helpers}.rs` |
| SS-04 | Jira API Resources (`src/api/jira/`) | Yes — new `components.rs`; `issues.rs` gains `update`-verb component support |
| SS-07 | Type Layer (`src/types/`) | Yes — new `types/jira/component.rs` (or extend `issue.rs`'s existing `Component`) |
| SS-08 | Cross-cutting Utilities (`cache.rs`, `jql.rs`, `partial_match.rs`) | Yes — `cache.rs` gains a components cache family; `jql.rs` gains a component-clause builder |
| SS-03, SS-05, SS-06, SS-09 | HTTP core, JSM, Assets, Build | No — component endpoints are plain platform REST v3, reuse `JiraClient` as-is |

Module belongs to SS-02 because `src/cli/component.rs` "Manage issue components" is
squarely CLI-layer command-handling scope per the Subsystem Registry's `src/cli/`
primary-source-file mapping — same justification `team.rs`/`project.rs` already establish
for sibling resource-management commands. Component API calls belong to SS-04 because
`src/api/jira/` is explicitly "Jira API Resources," and component endpoints
(`project/{KEY}/components`, `component/{id}`, `component/{id}/relatedIssueCounts`) are
platform Jira REST v3, the same family as `boards.rs`/`teams.rs`/`issues.rs` already in
that directory.

---

## 2. Component classification table

| File | Class | Reason |
|------|-------|--------|
| `src/cli/component.rs` (new) | **NEW** | `jr component list/create/edit/delete` handlers. Direct structural mirror of `src/cli/team.rs` (dispatch fn + per-subcommand handler fns taking `(command, output_format, config, client)`) — no existing file owns component command logic. |
| `src/cli/component/` (module dir, conditional) | **NEW (maybe)** | If `list`/`create`/`edit`/`delete`/`rename` handlers exceed the ~250-300 LOC that keeps `team.rs` a flat file, shard per ADR-0012's 1,000-LOC-file threshold *before* hitting it — this bundle is unlikely to individually cross that threshold (4 handlers, each simple CRUD), so a flat `component.rs` is the default recommendation; only split if `rename`'s dry-run/cross-project logic (#608) pushes it over. |
| `src/api/jira/components.rs` (new) | **NEW** | `list_components(project_key)`, `get_component(id)`, `create_component(...)`, `update_component(id, ...)` (used by both edit and rename — PUT keeps the id per the validated findings), `delete_component(id, move_to)`, `get_related_issue_counts(id)`. Structural mirror of `boards.rs`/`teams.rs` — one file per Jira resource family, consistent with SS-04's existing one-file-per-resource convention. |
| `src/types/jira/component.rs` (new) OR extend `src/types/jira/issue.rs` | **NEW** | A read/write `Component` struct family (`id`, `name`, `description`, `lead: Option<User>`/`leadAccountId`, `assigneeType`, `project`, `projectId`) is needed for `list`/`create`/`edit`/`delete` responses. **Recommendation: new file**, not an extension of `issue.rs`'s existing `Component { name }` (line 191) — that struct is the read-only *embedded* shape returned inside `IssueFields.components` (name-only, matches what Jira embeds on an issue). The full component-resource shape (id, description, lead, assigneeType, project) is a different, richer type used by the `jr component` command family and would either bloat `issue.rs` or force an awkward `#[serde(flatten)]`/duplicate-field relationship. Precedent: `types/jira/team.rs`, `types/jira/board.rs` are already separate per-resource files sitting alongside the leaner embedded shapes used elsewhere. |
| `src/cli/mod.rs` | **MODIFIED** | Add `pub mod component;` (or module dir); add `Command::Component { command: ComponentCommand }` variant; add `ComponentCommand` enum (`List`, `Create`, `Edit`, `Delete`, `Rename` — same enum, since `rename` is a `component` subcommand per #608's stated CLI shape `jr component rename OLD NEW`); add `--component` args to `IssueCommand::List`, `IssueCommand::Create`, `IssueCommand::Edit` (parallel to existing `--label`/`--team` args). Purely additive to existing enums (same pattern `AttachmentSubcommand`'s "additive-only coordination" note documents at `mod.rs:733-739` for stories layered onto one enum over time). |
| `src/cache.rs` | **MODIFIED** | Add a components cache family. Recommend the **keyed-map-per-project** pattern (`ProjectMeta`/`ObjectTypeAttrCache` precedent, not the whole-file `TeamCache` pattern) — components are project-scoped, so `components_<PROFILE>.json` holding `HashMap<project_key, ComponentsCacheEntry>` (mirroring `project_meta.json`'s `HashMap<String, ProjectMeta>` merge-on-write shape) is the right fit, not a single global list like `teams.json`. Needs `CachedComponent { id: String, name: String }` (the minimal name↔id shape resolvers need, mirroring `CachedTeam`) plus a per-entry `fetched_at` for TTL. Best-effort (model-b, swallow+warn) writer, matching `write_cmdb_fields_cache`/`write_object_type_attr_cache` — a missed cache write should never break a successful component create/edit/list call. |
| `src/cli/issue/helpers.rs` | **MODIFIED** | Add `resolve_component(config, client, project_key, name_or_id, no_input) -> Result<(String /*id*/, String /*resolved name*/)>`. **Direct structural clone of `resolve_team_field`** (`helpers.rs:36-` — same 5-step shape: numeric/ID pass-through short-circuit → cache read-or-fetch → `partial_match::partial_match` → auto-refresh-on-cache-miss retry bounded to one attempt via a `cache_was_fresh` flag → `Exact`/`ExactMultiple`/`Ambiguous`/`None` match-result handling with the same error taxonomy). Because component names are validated to be unique **within a project** by Jira, but `--component` may need to resolve across a project boundary (e.g. `issue edit` bulk across keys in different projects, or `rename --all-projects`), this helper's project-scoping is a real design decision — see §3. |
| `src/cli/issue/edit.rs` | **MODIFIED** | Add `--component` (`Vec<String>`, `add:`/`remove:` prefix, mirrors `--label` exactly) to `IssueCommand::Edit`. New `handle_edit_bulk_components` fn structurally cloning `handle_edit_bulk_labels` (`edit.rs:984-`): same add/remove prefix parse loop, same single-key vs multi-key fork. **Diverges from labels at the wire layer** (see §3/§4) — components' native `update` verb wraps names in `{"add":{"name":X}}`/`{"remove":{"name":X}}` objects (per the validated findings), not labels' bare-string `{"add":"foo"}` shape, so `update_issue_labels`'s body-building logic cannot be reused verbatim; a parallel `update_issue_components` fn in `api/jira/issues.rs` (or the new `components.rs`) is needed. Also needs an editmeta gate: check `EditMeta.fields["components"].operations` contains `"add"`/`"remove"` (mirrors the existing `--field` editmeta-driven gate at `edit.rs:774`+ and the `EditMetaField.operations` contract already modeled in `types/jira/editmeta.rs`) before using the native verb; fall back to read-modify-write only if the operations array lacks them. Multi-key bulk path needs `build_components_edited_fields` (clone of `build_labels_edited_fields`, `edit.rs:928-952`) targeting `componentsFields`/`selectedActions: ["components"]` — **this bulk wire shape is UNCONFIRMED** by the validated findings (only the single-issue `update` verb was validated); flag as a research gap before F4 implementation (see §3). |
| `src/cli/issue/create.rs` | **MODIFIED** | Add `--component` (`Vec<String>`, no add:/remove: prefix needed on create — bare names only, same as `--label` on create) to `IssueCommand::Create`; resolve via `resolve_component` per name, build the `fields.components` array (`[{"name": X}]` or `[{"id": X}]`) in the create POST body. Small, additive change — the JSM dispatch fork (`request_type.is_some()`) is untouched; components are not currently modeled as a JSM request-type field distinctly from platform create, so this flows through the platform path only unless research later shows JSM request forms also expose components (out of scope for this bundle; not claimed here). |
| `src/cli/issue/list.rs` + `src/jql.rs` | **MODIFIED** | This is the one genuinely non-trivial regression-risk surface. `FilterOptions` (`list.rs:637-649`) and `build_filter_clauses` (`list.rs:652-688`) are a **flat, single-valued, AND-only** struct/fn today — every existing flag becomes at most one clause. `--component`'s required semantics (repeated=OR, `not:`, `none`, `all:` AND-within-dimension) do NOT fit as one more `Option<&str>` field; it needs its own pre-built, already-composed clause string (produced by a new `jql::build_component_clause(specs: &[ComponentFilterSpec], resolved_ids: &[...]) -> String`, mirroring `build_asset_clause`'s pattern of doing the OR/parenthesization work *before* handing a single finished string to `build_filter_clauses`) that then plugs into `FilterOptions` as one more `Option<&str>` — exactly how `asset_clause`/`team_clause` are already pre-composed strings threaded through the same options bag. This keeps `--component` from requiring the full shared-grammar retrofit (#607, deferred) while still landing a real filter. `jql.rs` needs the `not:` → `(component not in (...) OR component is EMPTY)` expansion the validated findings flag (JQL `not in`/`!=` exclude EMPTY) and a `none` → `component is EMPTY` clause. |

---

## 3. Architecture change assessment

**Verdict: internal changes to existing modules + net-new peer modules that mirror
existing structural conventions. No structural/interface redesign, no new subsystem,
no new ADR-mandated pattern shift.** This is squarely in-pattern with how `team.rs` /
`api/jira/teams.rs` / `resolve_team_field` / `TeamCache` already established the
CLI-command → API-resource → cache → resolver quadruple for a comparable Jira concept.
The bundle is additive at every layer touched; nothing requires renaming, moving, or
reshaping an existing public interface. `Command`/`IssueCommand`/`ComponentCommand`
are all additive `clap::Subcommand`/`Vec<String>`-field extensions, matching the
`AttachmentSubcommand` "additive-only coordination" precedent already documented in
`mod.rs`.

The one place this bundle brushes against a structural limit is `FilterOptions`/
`build_filter_clauses` in `list.rs` — but as reasoned in §2, `--component` fits by
pre-composing its clause the way `asset_clause`/`team_clause` already do, not by
extending the options-bag shape itself. The genuinely structural retrofit (a shared
filter grammar reusable by future multi-valued/negatable filters) is correctly scoped
to the deferred #607, not this bundle.

### Recommended ADR(s) for F2

Recommend **one ADR**, not several — the three sub-questions below are facets of a
single decision (how `jr` resolves and caches Jira Components), and splitting them
would fragment a decision that needs to be read as a whole:

- **ADR: Component resolution, caching, and mutation strategy.** Should cover:
  1. **Cache layout** — keyed-map-per-project (`components_<profile>.json` as
     `HashMap<project_key, Vec<CachedComponent>>` + per-entry `fetched_at`) vs. one
     cache file per project (`components_<PROJECT>.json`, mirroring the request-type
     cache's `request_types_<sid>.json` per-entity-file pattern). Recommend the
     keyed-map form (matches `ProjectMeta`/`ObjectTypeAttrCache`, avoids an
     unbounded number of cache files for orgs with many projects).
  2. **Cross-project name resolution strategy** — `--project` disambiguates per the
     issue spec, but what's the default when `--project` is omitted and the name is
     ambiguous across projects the profile has touched? (Team/label resolution today
     is org-global, not project-scoped, so `resolve_team_field` is not a perfect
     template here — this is a genuine new fork in the resolver contract worth
     writing down explicitly, not silently improvising in code.)
  3. **Delete-safety policy** — the CLI spec already encodes the core policy (refuse
     without `--move-to` or explicit `--orphan`), but the ADR should record *why*
     (Jira's own `DELETE component/{id}` silently orphans issue associations when
     `moveIssuesTo` is omitted — the "no changelog" claim is explicitly UNVERIFIED
     per the validated findings, so the ADR must not assert it, only that jr's CLI
     defaults toward the safer explicit choice) and confirm `--orphan` maps to
     omitting `moveIssuesTo` entirely (not e.g. `moveIssuesTo=""`).
  4. **`update` verb wire-shape asymmetry** — record explicitly (same documentation
     pattern CLAUDE.md already uses for the `labelsFields`/`"labels"` and
     `issueType`/`"issuetype"` bulk asymmetries) that components' single-issue
     `update` verb wraps names as `{"add":{"name":X}}` objects while labels use bare
     strings — this is exactly the kind of asymmetry that has bitten this codebase
     before (BUG-LABEL-400) and should be pinned in writing before implementation,
     not discovered via a live 400.

  Do **not** write this ADR now — F2 (spec evolution) owns ADR authorship; this is a
  recommendation for F2 to act on.

### Flagged research gap (pre-F4)

The validated findings confirm the **single-issue** `update` verb shape for components
but do **not** confirm the **bulk multi-key** wire shape (`componentsFields`/
`selectedActions` analogous to labels' `labelsFields`). Given this codebase's history
with `labelsFields` vs `"labels"` and `issueType` vs `"issuetype"` asymmetries — each
only discovered via a live 400 — recommend a live-Jira verification pass (or a fresh
Perplexity/Atlassian-community check) for the bulk components shape before F4
implements the multi-key path, rather than assuming naive symmetry with labels.

---

## 4. Regression-risk zone

| Modified module | Existing behavior at risk | Why |
|---|---|---|
| `src/cli/mod.rs` | None functionally — purely additive enum variants/fields. Risk is compile-surface only (every existing `match` on `Command`/`IssueCommand` must gain arms; missing one is a compile error, not a silent regression — Rust's exhaustiveness check is the safety net here). | Additive-only pattern already proven safe across `AttachmentSubcommand`'s staged rollout (S-576-1..5). |
| `src/cli/issue/edit.rs` | **HIGH regression risk zone.** `handle_edit_bulk_labels`, the C-1 single-key-only guards, the `--field` + `--label` mutual-exclusion block (`edit.rs` §"FIX-F5-001"), and the dry-run preview's `planned` map assembly are all dense, precedent-setting logic that a careless `--component` addition could destabilize if copy-pasted without matching every guard. | (a) The dry-run JSON preview block must gain a `components` entry using the SAME "simplified preview shape, not wire-identical" convention as labels/priority/issueType (§ comment at `edit.rs:449-469`) — inconsistency here would be a real regression in a documented invariant. (b) If `--component` interacts with `--field` (an admin could expose a components-like field via the generic `--field` custom-field path), the mutual-exclusion policy needs an explicit decision, not silent overlap — Jira's built-in `components` field could theoretically also be reachable via `--field components=...`, which would bypass `resolve_component`'s name-to-id resolution entirely and needs a guard analogous to the existing `--field`/`--label` exclusion. |
| `src/cli/issue/create.rs` | LOW — `handle_create`'s JSM dispatch fork (`request_type.is_some()`) must remain byte-for-byte unchanged on the non-`--component` path; a naive change risks accidentally threading `--component` into `JsmCreateArgs` (it currently is NOT a JSM request-type field per the DTU-adjacent scope note above) or disturbing the DEC-188 pre-flight guard ordering (`--field`/`--on-behalf-of` exit-64 checks must still fire before ANY new component resolution HTTP call, to preserve their documented "before any HTTP call" contract). | `create.rs`'s pre-flight guard block is order-sensitive; component resolution (which requires an HTTP/cache round-trip) must be sequenced correctly relative to it, or `jr issue create --field x=y --component foo` (invalid combo on platform path) could burn an HTTP call before erroring, which the current guards explicitly avoid for `--field`/`--on-behalf-of`. |
| `src/cli/issue/list.rs`, `src/jql.rs` | **MEDIUM-HIGH regression risk zone.** `build_filter_clauses`/`FilterOptions` and `build_jql_base_parts` are exercised by ~15 existing unit tests (`list.rs:690-1070`+) asserting exact clause composition and ordering. | Any refactor to `FilterOptions` to accommodate a pre-composed `component_clause: Option<&str>` field must preserve the existing clause ORDER (tests assert positional equality of the `Vec<String>` output, not just membership) — inserting the new field in the wrong struct-literal position across call sites, or the wrong push-order inside `build_filter_clauses`, breaks assertions like `build_jql_parts_all_filters`/`build_jql_parts_all_filters_with_open` even though the underlying JQL semantics would still be correct. `jql.rs`'s `escape_value`/`build_asset_clause` conventions must be followed exactly (same quote-then-backslash escaping order) for component names, which are free-text and can legally contain quotes/backslashes. |
| `src/cache.rs` | LOW-MEDIUM — new cache family is purely additive (new struct + new `read_*`/`write_*` fns). | The **profile-scoping convention is a hard invariant** (`profile: &str` first arg on every reader/writer, per CLAUDE.md's "Multi-profile boundary" gotcha) — cross-profile leakage here would be a correctness bug of the same class CLAUDE.md explicitly calls out for CMDB/story-points fields (sandbox vs. prod component IDs legitimately differ). Any new writer must decide swallow-vs-propagate (model a vs b) and document the choice in rustdoc, per the established convention. |
| `src/cli/issue/helpers.rs` | LOW — `resolve_component` is a new function. | The only regression surface is if it's implemented as a modification to `resolve_team_field` itself (e.g. via ill-advised generics) rather than a parallel clone — that would risk destabilizing team resolution, which has its own dense ambiguity-handling logic and test coverage. Recommend a structurally parallel, NOT shared/generic, implementation. |

**Files explicitly NOT touched (regression baseline):** `src/api/client.rs`,
`src/api/auth*.rs`, `src/api/pagination.rs`, `src/api/rate_limit.rs`,
`src/api/refresh_coordinator.rs`, `src/adf.rs`, `src/config.rs`, `src/output.rs`,
`src/error.rs`, `src/duration.rs`, `src/partial_match.rs` (used, not modified —
`partial_match::partial_match` is a stable, reusable pure fn), `src/observability.rs`,
all of `src/cli/{auth,assets,board,init,project,queue,requesttype,sprint,user,worklog}.rs`,
all of `src/api/jsm/`, `src/api/assets/`, `src/cli/issue/{workflow,interactions,links,
assets,changelog,field_resolve,attachments,format,view,comments,json_output}.rs`. None
of these have any structural or semantic reason to change for this bundle.

---

## 5. Dependency ordering / story-wave sequence

The four issues share one foundation: **name↔ID resolution + caching (born in #604)**.
#605, #606, and #608 all consume `resolve_component`, the components cache, and
`src/api/jira/components.rs`'s read endpoints. Recommended wave sequence:

**Wave 1 — Foundation (#604, `jr component list/create/edit/delete`)**
- `src/types/jira/component.rs` (new types)
- `src/api/jira/components.rs` (all 5 endpoints: list, get, create, update, delete + relatedIssueCounts)
- `src/cache.rs` components cache family
- `src/cli/issue/helpers.rs::resolve_component`
- `src/cli/component.rs` + `mod.rs` wiring (`list`, `create`, `edit`, `delete` subcommands, including the `--move-to`/`--orphan` delete-safety guard)
- This wave is self-contained and independently shippable — it delivers standalone
  value (`jr component list/create/edit/delete`) even if #605/#606/#608 slip.

**Wave 2 — Issue-side consumption (#605, `issue create/edit --component`)**
- Depends on Wave 1's `resolve_component` + `components.rs` + editmeta gate contract.
- `src/cli/issue/create.rs` (`--component`, bare names, additive to create POST body)
- `src/cli/issue/edit.rs` (`--component` add:/remove:, single-key `update`-verb path
  first; multi-key bulk path gated behind the flagged research gap in §3 — if the
  bulk wire shape is unconfirmed by wave start, ship single-key first and stub/defer
  multi-key, or spend a research spike before this wave starts).

**Wave 3 — List filtering (#606, `--component` filter)**
- Depends on Wave 1's `resolve_component`/cache (name→ID resolution is explicitly
  client-side per the issue spec) but is otherwise independent of Wave 2 — can run in
  parallel with Wave 2 if capacity allows, since `list.rs`/`jql.rs` don't touch
  `create.rs`/`edit.rs`.
- `src/jql.rs::build_component_clause` (OR/not:/none/all: semantics)
- `src/cli/issue/list.rs` (`FilterOptions` gains `component_clause`, `IssueCommand::List` gains `--component`)

**Wave 4 — Rename (#608, `jr component rename`)**
- Depends on Wave 1's `update_component`/PUT-keeps-id contract (confirmed by the
  validated findings) and, for `--all-projects`, on Wave 1's `list_components`
  iterating every accessible project.
- Lightweight relative to the others — mostly a thin CLI wrapper over
  `update_component` with a name-collision dry-run preview.
- Could technically run in parallel with Wave 2/3 (no shared files with either), but
  sequencing it last is still recommended since it is the smallest, lowest-risk piece
  and benefits from Wave 1 having stabilized first under real use.

**Cross-wave shared risk:** the ADR recommended in §3 (cache layout, cross-project
resolution, delete-safety policy, wire-shape asymmetry) should land *before* Wave 1
implementation starts, not be improvised mid-wave — every subsequent wave inherits
whatever Wave 1 decides here.

---

## 6. Machine-readable affected-file list

See `.factory/phase-f1-delta-analysis/affected-files-components.txt` (also embedded
below for convenience).

```
NEW   src/cli/component.rs
NEW   src/api/jira/components.rs
NEW   src/types/jira/component.rs
MODIFIED src/cli/mod.rs
MODIFIED src/cache.rs
MODIFIED src/cli/issue/helpers.rs
MODIFIED src/cli/issue/edit.rs
MODIFIED src/cli/issue/create.rs
MODIFIED src/cli/issue/list.rs
MODIFIED src/jql.rs
MODIFIED src/api/jira/issues.rs
DEPENDENT src/types/jira/mod.rs
DEPENDENT src/api/jira/mod.rs
DEPENDENT src/types/jira/editmeta.rs
DEPENDENT src/partial_match.rs
```

`src/types/jira/mod.rs` and `src/api/jira/mod.rs` are DEPENDENT (re-export wiring only,
one line each, no logic change) — mirrors how every existing per-resource file
(`teams.rs`, `boards.rs`) is wired into those `mod.rs` files today.
`src/types/jira/editmeta.rs` is DEPENDENT — its existing `EditMetaField.operations`
contract is *read*, not modified, by the components `update`-verb gate.
`src/partial_match.rs` is DEPENDENT — `resolve_component` calls its existing public
`partial_match` fn unmodified.

---

## Summary for human review

- **Greenfield core (#604):** 3 new files (CLI, API, types), 2 modified cross-cutting
  files (`mod.rs` wiring, `cache.rs` new family) — mirrors `team.rs` exactly.
- **Consumption (#605, #606, #608):** all MODIFIED, no new files beyond what #604 adds;
  risk concentrates in `edit.rs` (dense existing logic, wire-shape asymmetry vs. labels)
  and `list.rs`/`jql.rs` (`FilterOptions` is AND-only today; `--component` fits via a
  pre-composed clause, avoiding the #607 shared-grammar retrofit).
- **No new subsystem, no interface redesign.** One ADR recommended for F2 (resolution/
  cache/delete-safety/wire-shape), not written here.
- **One confirmed research gap:** bulk multi-key `update`-verb wire shape for
  components is unconfirmed by the validated findings — recommend closing before Wave 2's
  multi-key bulk-edit path, given this codebase's prior history with silent
  label/issueType bulk-shape asymmetries (BUG-LABEL-400).
- **Regression risk is concentrated, not diffuse:** `edit.rs` and `list.rs`/`jql.rs` are
  the only genuinely HIGH/MEDIUM-risk existing files; everything else touched is either
  new or trivially additive.
