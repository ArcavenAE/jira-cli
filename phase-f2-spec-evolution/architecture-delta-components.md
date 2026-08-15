---
document_type: f2-architecture-delta
phase: phase-f2-spec-evolution
producer: architect
issue: "604,605,606,608"
status: complete
date: 2026-08-15
traces_to:
  - ".factory/phase-f1-delta-analysis/impact-boundary-components.md"
  - ".factory/specs/prd/bc-8-components.md"
  - ".factory/research/component-delete-and-bulk-wire-2026-08-15.md"
---

# F2 Architecture Delta — Component Management Bundle (Issues #604, #605, #606, #608)

## 1. Files Updated

| File | Action | What Was Added |
|------|--------|----------------|
| `.factory/specs/architecture/decisions/ADR-0018-component-resolution-caching-mutation-strategy.md` | NEW | Full ADR: resolution strategy, caching layout, delete-safety policy (DEC-279), wire-shape asymmetry (DEC-280) — one consolidated decision per F1's recommendation |
| `.factory/specs/architecture/ARCH-INDEX.md` | APPENDED | ADR-0018 row in the Architecture Decisions table |
| `.factory/architecture/adr-index.md` | APPENDED | ADR-0018 summary row (dual-tracking, mirrors the ADR-0017 precedent — a cross-reference row pointing at the VSDD-canonical `decisions/` file, consistent with this file's own note that ADR-0017+ live under `.factory/specs/architecture/decisions/`) |
| `.factory/architecture/component-graph.md` | APPENDED | `Component Management Delta — DAG Verification` section: 3 new module nodes (`cli::component`, `api::jira::components`, `types::jira::component`), all new/modified dependency edges, cycle check, purity-boundary cross-check — mirrors the existing `Issue #288 Delta — DAG Verification` section's structure exactly |
| `.factory/architecture/system-overview.md` | APPENDED | `§Purity Boundary` gains a `[PLANNED]`-tagged addition listing the bundle's pure and effectful-shell modules, cross-referencing `component-graph.md` |
| `.factory/phase-f2-spec-evolution/architecture-delta-components.md` | NEW (this file) | Delta record for this burst |

No files were rewritten. All updates are append-or-targeted-edit operations, consistent with
the `architecture-delta.md` (issue #288) precedent this delta follows structurally.

**Not touched by this burst (explicitly out of architect scope):** `src/`, `docs/adr/` (the
product-repo ADR file is an F4 story deliverable — see the ADR's own placement note), story
files, `.factory/specs/prd/*.md` BC files (product-owner scope — the PRD-side decisions
DEC-278/279/280 and the `cross-cutting.md` BC-X.10.001 caller-citation amendment were already
recorded by the product-owner in the prior F2 burst; see `.factory/spec-changelog.md` and
`.factory/phase-f2-spec-evolution/prd-delta-components.md`), `regression-state.json`,
`sidecar-learning.md`, `.claude/`. `module-criticality.md` and `risk-register.md` were also
left untouched: no HIGH-impact R-NNN risk items reference components (grep-verified), and
module criticality classification is deferred to Wave 1 story decomposition (F3), since no
implementation module exists yet to classify a kill-rate tier against.

**Known pre-existing structural gap (not introduced by this burst):** `component-graph.md`
and `system-overview.md` predate this project's `architecture-section-template.md` adoption
(they carry no `document_type`/`level`/`phase`/... frontmatter — a gap that already existed
before this burst, e.g. across the #288 delta and every prior edit to these two files). The
`validate-template-compliance` hook flags this as `template_drift` on every edit to either
file, including this burst's. This is a known, accepted characteristic of this repo's
`.factory/architecture/` legacy directory (distinct from the newer `.factory/specs/
architecture/` sharded convention this project also maintains in parallel per ARCH-INDEX.md's
own note) — not a regression introduced here, and out of this burst's scope to retrofit.

---

## 2. ADR Decision

**ADR-0018 was drafted.** Number: 0018 (allocated as `max(docs/adr/ = 0016,
.factory/specs/architecture/decisions/ = 0017) + 1`). Title: "Component resolution, caching,
delete-safety, and mutation-wire-shape strategy."

**One consolidated decision, per F1's explicit recommendation** (`impact-boundary-components.md`
§3: "Recommend one ADR, not several — the three sub-questions below are facets of a single
decision... splitting them would fragment a decision that needs to be read as a whole" — F1
enumerated 3 facets; this ADR covers 4, folding in the wire-shape asymmetry F1's §3 flagged as
a separate "research gap" that DEC-280 subsequently resolved):

1. **Resolution strategy** — client-side, per-project, via the existing `partial_match`
   primitive with a numeric-ID bypass (mirrors `jr requesttype fields <NAME|ID>`); resolver is
   ALWAYS invoked with exactly one project's candidate list, never a cross-project union. This
   is the corrected core value of the bundle (BC-8.4.004).
2. **Caching** — new keyed-map-per-project cache family in `cache.rs`
   (`components_<profile>.json` → `HashMap<project_key, ComponentsCacheEntry>`), structurally
   identical to `ProjectMeta`/`ObjectTypeAttrCache`, NOT the whole-file `TeamCache` shape.
   `profile: &str` first arg on every reader/writer. 7-day TTL + explicit invalidation on
   every mutating command (create/edit/rename/delete), mirroring
   `invalidate_project_meta_cache`. Model-b (swallow + warn) writer.
3. **Delete-safety policy (DEC-279)** — `component delete` refuses to run without exactly one
   of `--move-to`/`--orphan`; only `--orphan` requires `--yes`/interactive confirm; affected
   issues are snapshotted via read-only JQL BEFORE the DELETE, for both dispositions.
4. **Wire-shape asymmetry (DEC-280)** — three distinct, explicitly-pinned wire shapes: single-
   key `update`-verb object form (`{"add":{"name":X}}`, editmeta-gated), bulk
   `multiselectComponents` integer-`componentId` form (live-smoke-test-gated per
   `FIX-BULK-TRANSITION-001` precedent), and create-time additive `{"name":X}` array form.
   Never assumed interchangeable.

ADR-0018 is filed at
`.factory/specs/architecture/decisions/ADR-0018-component-resolution-caching-mutation-strategy.md`.

---

## 3. Dependency Graph Delta

Text form (all edges are additions; no edges removed; no existing edges modified — see
`component-graph.md §Component Management Delta` for the full annotated version with per-edge
rationale):

```
ADDED — new L4 module (api::jira subgraph expanded):
  api::jira::components  → api::client (L3)
  api::jira::components  → types::jira::component (L5)
  api::jira::components  → types::jira::issue (L5)        [Component embedded-shape gains `id` — BC-2.3.040]

ADDED — new L5 type:
  types::jira::component → serde, std                      [pure serde struct]

ADDED — new L2 handler (cli::component):
  cli::component → api::jira::components
  cli::component → cache (L6)
  cli::component → partial_match (L6)
  cli::component → jql (L6)                                 [BC-8.2.007 pre-delete snapshot — the one
                                                               edge NOT present in the cli::requesttype
                                                               precedent this module otherwise mirrors]

ADDED — modified L2 handlers (additive changes to existing files only):
  cli::issue::helpers → api::jira::components               [new fn resolve_component]
  cli::issue::helpers → cache (L6)                           [components cache reads]
  (cli::issue::edit, cli::issue::create, cli::issue::list already have edges to
   cli::issue::helpers / api::jira::issues / jql respectively — no NEW L2→L4/L6 edges,
   only new call patterns within existing edges)

ADDED — modified L6 utility (cache.rs, additive only):
  cache::{ComponentsCacheEntry, CachedComponent}             [new structs]
  cache::{read,write,invalidate}_components_cache            [new fns, ProjectMeta pattern]
```

**Cycle check: DAG remains acyclic.** All new/modified edges follow the existing layer
direction (L2 → L4 → L3 → L6; L4 → L5; L2 → L6 directly, matching the `cli::requesttype`
precedent). No upward edges (L4/L5/L6 → L2) are introduced. No new L6 → L3/L4 edges. The one
edge shape not already established by the `cli::requesttype` precedent is `cli::component →
jql (L6)` (for the delete-safety JQL snapshot) — this still follows the standard L2 → L6
direction and introduces no cycle (`jql.rs` already has zero outgoing edges into anything
above L6, confirmed by the existing "Layer Isolation Summary" table in `system-overview.md`).

---

## 4. Purity Boundary Classification

| Module (all `[PLANNED]` — no `src/` code yet) | Classification | Rationale |
|---|---|---|
| `types::jira::component` | **Pure core** | Serde struct family (id, name, description, lead, assigneeType, project). No I/O, no imports from L0-L4. Same class as `types::jira::team`/`types::jira::board`. |
| `api::jira::components` | **Effectful shell** | HTTP via `JiraClient` (5 endpoints + `relatedIssueCounts`). Same class as `api::jira::teams`/`api::jira::boards`. |
| `cli::component` (all handlers) | **Effectful shell** | HTTP + cache + stdin/stdout + JQL snapshot search. Same class as `cli::team`. |
| `cli::issue::helpers::resolve_component` | **Effectful shell** | Cache-or-fetch HTTP round-trip before delegating to the pure `partial_match::partial_match` primitive, which itself remains pure and is called unmodified — same shape as the existing `resolve_team_field`. The resolver wrapper is effectful; the matching primitive it calls is not. |
| `cache::{read,write,invalidate}_components_cache` | **Effectful shell** | Filesystem I/O. Same class as `cache::{read,write}_project_meta`. |
| `cli::issue::edit` / `cli::issue::create` / `cli::issue::list` (modified, `--component` additions) | **Effectful shell** (unchanged classification) | Already-classified effectful handlers; the `--component` additions are new call patterns within an already-effectful module, not a reclassification. |

**No existing module's purity classification changes as a result of this bundle.** The
Purity Boundary Map (`system-overview.md §Purity Boundary`) required only additive entries,
tagged `[PLANNED]` pending F4 implementation — no boundary redraw, no module moved between
pure/effectful categories.

---

## 5. Confirmation: Dependency graph stays acyclic after these additions

**Confirmed acyclic.** Verification method: every new/modified edge listed in §3 was checked
against the existing "Layer Isolation Summary" table in `system-overview.md` (L2 imports from
L3/L6 only; L4 imports from L3 client/L5 types/L6 cache/error only; L5 types import nothing
above serde/std; L6 utilities import nothing from L0-L4). All new edges satisfy these
constraints without exception. The bundle introduces exactly one edge SHAPE not already
present in the closest structural precedent (`cli::requesttype`'s L2→L4/L6 edge set): `cli::
component → jql (L6)` for the pre-delete snapshot search — this is still a downward L2→L6
edge and does not violate isolation. No new module imports from `cli::*` (L2) or from any
module above its own layer. See `component-graph.md §Component Management Delta` "Cycle
check" paragraph for the full annotated confirmation.

---

## 6. ARCH-INDEX.md version note

`.factory/specs/architecture/ARCH-INDEX.md` (this project's canonical VSDD-shard ARCH-INDEX)
carries no `version:` frontmatter field in its current form — unlike the generic
`architecture-index-template.md`, this project's actual ARCH-INDEX.md is a plain heading-first
document (Subsystem Registry + Architecture Decisions table only, no frontmatter block at
all). "Bump the ARCH-INDEX version" therefore has no literal field to increment in this repo;
the ADR-0018 row insertion (§1 above) is the version-equivalent change — the file's content
changed, tracked via git history / `spec-changelog.md` rather than an in-file version counter.
This is a pre-existing characteristic of the file, not something this burst altered or should
retrofit unprompted (adding a `version:` field where none existed risks surprising downstream
tooling that reads this file positionally).

---

## 7. Traceability

- F1 delta analysis this burst implements: `.factory/phase-f1-delta-analysis/
  impact-boundary-components.md`.
- PRD-side decisions this ADR formalizes (already recorded by product-owner, NOT re-authored
  here): `bc-8-components.md`, `bc-2-issue-read.md` §2.1, `bc-3-issue-write.md` §3.4;
  `.factory/spec-changelog.md` (DEC-278/279/280); `.factory/phase-f2-spec-evolution/
  prd-delta-components.md`.
- Research consumed: `.factory/research/component-delete-and-bulk-wire-2026-08-15.md`
  (Q1 delete safety, Q2 bulk wire shape).
- Structural precedent this delta mirrors: `.factory/phase-f2-spec-evolution/
  architecture-delta.md` (issue #288 — same delta-doc + append-to-living-docs pattern).
