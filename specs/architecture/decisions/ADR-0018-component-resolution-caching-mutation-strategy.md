---
document_type: adr
adr_id: ADR-0018
status: Accepted
date: 2026-08-15
subsystems_affected: ["SS-02", "SS-04", "SS-07", "SS-08"]
supersedes: null
superseded_by: null
related: ["ADR-0007", "ADR-0012", "ADR-0014", "ADR-0015"]
---

# ADR-0018: Component resolution, caching, delete-safety, and mutation-wire-shape strategy

## Status

**Accepted** (2026-08-15). Gate: F2 spec evolution for the component-management bundle
(Feature Mode cycle `component-mgmt`, DEC-278/DEC-279/DEC-280; issues #604/#605/#606/#608).
Formalizes, at the architecture layer, decisions already recorded in
`.factory/spec-changelog.md` (DEC-278/279/280) and `bc-8-components.md` /
`bc-2-issue-read.md` §2.1 / `bc-3-issue-write.md` §3.4. This ADR does not introduce new
product behavior — it is the architectural record of WHY the PRD-level decisions took the
shape they did, and binds them to concrete module/cache/wire-format choices for F4
implementation.

> **NOTE — factory-artifact placement, not yet an F4 code artifact:** This ADR governs a
> subsystem (`src/cli/component.rs`, `src/api/jira/components.rs`, `src/types/jira/component.rs`,
> the `cache.rs` components family) that does not exist in `src/` as of this writing (F2). The
> corresponding product-repo file `docs/adr/0018-component-resolution-caching-mutation.md` is
> an **F4 STORY deliverable**, created in a worktree via PR when Wave 1 implementation lands —
> it is NOT created here. This factory artifact at
> `.factory/specs/architecture/decisions/ADR-0018-component-resolution-caching-mutation-strategy.md`
> is the sole ADR-0018 record until F4 promotes it into `docs/adr/`.

## Context

Four GitHub issues (#604 `jr component list/create/edit/delete`, #605
`issue create/edit --component`, #606 `issue list --component` filter, #608
`jr component rename`) add a new Jira resource — classic Jira Software/Core **Components**
(`/rest/api/3/component`, the `fields.components` array on an issue) — to `jr`. The F1 delta
analysis (`.factory/phase-f1-delta-analysis/impact-boundary-components.md` §3) found this
bundle to be structurally in-pattern with the existing `team.rs` /
`api/jira/teams.rs` / `resolve_team_field` / `TeamCache` quadruple, but flagged four
sub-questions that needed a single, explicit decision before Wave 1 implementation could
start, because getting any of them wrong would either (a) reproduce a class of bug this
codebase has already been bitten by twice (`BUG-LABEL-400`, `FIX-BULK-TRANSITION-001` — wire
shapes asserted from documentation alone, without a live-run check, turned out wrong), or
(b) violate the "no silent destructive default" precedent ADR-0015 established for `issue
move` resolution:

1. Components are **project-scoped** (unlike Teams, which are org-global) — the existing
   `resolve_team_field` resolver is not a safe template to copy verbatim, because a
   same-named component in a different project must NEVER be silently considered a match
   (F1 delta analysis §6 edge-case item 1 — "the corrected core value of the #606/#608
   bundle").
2. Component `DELETE` is permanent, undoable, and its audit trail (issue-changelog cascade)
   is not contractually guaranteed by Atlassian
   (`.factory/research/component-delete-and-bulk-wire-2026-08-15.md` §Q1.2, §Q1.3).
3. Jira exposes **two structurally different wire shapes** for writing a component onto an
   issue depending on whether the edit targets one issue or many — a single-issue `update`
   verb using `{"name": X}`/`{"id": X}` objects, versus a bulk endpoint requiring a resolved
   **integer** `componentId` (research §Q2) — a stronger asymmetry than the `labelsFields`/
   `"labels"` or `issueType`/`"issuetype"` asymmetries CLAUDE.md already documents for this
   codebase.

The PRD-level decisions (DEC-278 umbrella, DEC-279 delete safety, DEC-280 wire-shape) are
already recorded in `bc-8-components.md`, `bc-2-issue-read.md` §2.1 (BC-2.1.018..022,
BC-2.3.040), and `bc-3-issue-write.md` §3.4 (BC-3.4.022..025). This ADR is the architecture
layer's record of the underlying module/cache/wire-format rationale — one decision, not four,
because the four facets are inseparable: the cache layout shape is dictated by the
project-scoping rule; the delete-safety snapshot mechanism reuses the same resolver; and the
wire-shape asymmetry is a direct architectural consequence of Jira exposing genuinely
different endpoints for the two edit cardinalities, not an independent implementation choice.

## Decision

We will implement Jira Component support as four coordinated architectural choices, treated
as one decision:

1. **Resolution: client-side, project-scoped, via the existing `partial_match` primitive with
   a numeric-ID bypass — never a cross-project search.** `src/cli/issue/helpers.rs::
   resolve_component(input, project, candidates)` is a structural clone (not a generic
   abstraction over) `resolve_team_field`: all-ASCII-digit input short-circuits directly to a
   component id (no name-list GET fired for resolution — mirrors the `jr requesttype fields
   <NAME|ID>` numeric-bypass convention, including its documented escape-hatch gap); non-digit
   input resolves via a project-scoped `partial_match(input, &names)` call. The resolver is
   ALWAYS invoked with exactly one project's candidate list — cross-project fan-out (only
   `component rename --all-projects`, BC-8.3.002) calls this resolver once per project it
   iterates; the resolver itself never unions candidate lists across projects. This is the
   corrected core value of the bundle (BC-8.4.004): a same-named component in a different
   project is never silently matched, never causes a false ambiguity, and is never
   accidentally selected — enforced entirely by which candidate list the caller passes in, not
   by any project-awareness inside `partial_match` itself. **Scoped exception to the numeric
   bypass — confirming GET to derive/validate project:** on four numeric-ID mutation paths, the
   "no GET fired for resolution" rule above is narrowed by a *single-object* confirming
   `GET /rest/api/3/component/{id}` (never a name-list GET) that derives or validates the
   component's project for a downstream check:
   - `jr component delete` fires this confirming GET for a numeric-ID SOURCE component under
     EITHER chosen disposition — `--move-to` and `--orphan` alike (broadened from a
     `--move-to`-only check; see BC-8.2.006 Precondition 4) — and, when `--move-to` also
     resolves to a numeric TARGET id, for that id too — validating each against the operative
     project before the DELETE proceeds.
   - `jr component edit` with a numeric id fires the same confirming GET to derive the
     component's project, used to scope `--lead` assignable-user resolution to that project, to
     supply `project_key` to `invalidate_components_cache` (Decision §2), and for a `--project`
     mismatch → exit 64 check symmetric with delete's.
   - `jr component rename` with a numeric `OLD` fires the same confirming GET for the identical
     reasons (project-scoped cache invalidation and `--project` mismatch → exit 64).

   This is narrower than it sounds: it never reintroduces a name-list GET for resolution (the
   numeric bypass still fires none of those on any of these four paths); it only adds a
   single-object project-membership/derivation check — for delete, given the strictly larger
   blast radius Decision §3 describes; for edit/rename, given the `--lead`-scoping,
   cache-invalidation, and `--project`-mismatch needs Decision §2 and the corresponding
   `bc-8-components.md` §8.1 (edit) / §8.3 (rename) BCs describe (numbers finalized by the
   product-owner in the same cycle as this ADR revision). See BC-8.2.002 (M1) and BC-8.2.006
   (Precondition 4).

   **Exit-code divergence on a nonexistent numeric id [2026-08-19, feature-level F5, O-CS-2,
   human-approved to document]**: a nonexistent NUMERIC component id exits 64 on
   `jr component edit`/`delete`/`rename` (the confirming `GET /rest/api/3/component/{id}`
   described immediately above 404s, which is treated as the ordinary not-found path,
   BC-8.1.008) but exits 1 on `jr issue create --component`/`jr issue edit --component` (no
   confirming GET fires on those two commands — the numeric id is a plain field value, passed
   through unresolved, and is validated server-side only when the POST/PUT itself is sent,
   surfacing Jira's own 4xx as an ordinary `ApiError`). This is INTENTIONAL, not an
   inconsistency to reconcile: the numeric bypass's whole rationale (Decision §1 above) is to
   avoid an extra round-trip, and the issue-write commands deliberately do not pay for a
   confirming GET the way the four `jr component` mutation paths do — the two families accept
   different exit-code outcomes for the identical "id doesn't exist" input as the direct,
   accepted cost of that asymmetric round-trip decision.

2. **Caching: a new keyed-map-per-project cache family in `cache.rs`, structurally identical
   to `ProjectMeta`/`ObjectTypeAttrCache`, not the whole-file `TeamCache` shape.** Components
   are stored as `components_<profile>.json` holding `HashMap<project_key,
   ComponentsCacheEntry>` (`ComponentsCacheEntry { components: Vec<CachedComponent>,
   fetched_at: DateTime<Utc> }`, `CachedComponent { id: String, name: String }`) — the same
   per-entry-TTL merge-on-write shape `cache::read_project_meta`/`cache::write_project_meta`/
   `cache::invalidate_project_meta_cache` already establish (`src/cache.rs`, `ProjectMeta`
   struct and its readers/writers), not a single global list like `teams.json`. `profile:
   &str` is the first argument on every reader/writer (the hard multi-profile invariant
   CLAUDE.md's "Multi-profile boundary" gotcha documents). 7-day TTL, matching every other
   `jr` cache family. **Invalidation is explicit, not time-only:** every mutating command
   (`component create`, `component edit`, `component rename` — both `--project` and
   per-iteration under `--all-projects`, `component delete`) calls an
   `invalidate_components_cache(profile, project_key)` after a successful mutating HTTP call,
   mirroring `cache::invalidate_project_meta_cache`'s pattern — so a `component list`
   immediately after a `component create` in the same session does not need to wait out the
   TTL to see the new component. **Every numeric-id mutation has a `project_key` to invalidate
   with — none is derived from a fresh name-list lookup.** For `component edit`/`component
   rename` invoked with a numeric id, `project_key` is not looked up separately for cache
   purposes; it is the same value Decision §1's scoped exception already derives via the
   single-object confirming GET (used there for `--lead` scoping and `--project`-mismatch
   validation), reused here as the `invalidate_components_cache(profile, project_key)` argument.
   `component create` and non-numeric-id `edit`/`rename`/`delete` already have `project_key`
   from `--project`/config or from `partial_match` resolution against a project-scoped candidate
   list, so this reuse only matters for the four numeric-id paths Decision §1 names. The writer
   is **model-b (swallow + warn)**, matching `cache::write_cmdb_fields_cache`/
   `cache::write_object_type_attr_cache`: a failed cache write must never break a successful
   component command.

3. **Delete safety (DEC-279): refuse to run without an explicit disposition; gate only the
   irreversible path behind confirmation; snapshot before mutating.** `jr component delete`
   REQUIRES exactly one of `--move-to <NAME|ID>` (maps to the `moveIssuesTo` query parameter —
   the safe, non-destructive-to-issue-data path) or `--orphan` (the `moveIssuesTo`-absent
   path — issues lose the component tag with no replacement). Neither supplied → exit 64
   before any HTTP call, naming both flags (mirrors ADR-0015's `--resolution`/`--no-resolution`
   requirement on `issue move` done-category transitions — the same "never guess a destructive
   disposition" precedent, applied to a strictly larger blast radius: a component delete
   silently mutates every issue carrying the component, comparable in scope to `gh repo
   delete` per the CLI-convention scan in research §Q1.5). Only `--orphan` carries an
   additional confirmation gate (interactive `dialoguer` confirm naming the affected-issue
   count, or `--yes` non-interactively) — `--move-to` does not, because issues keep a
   component either way under `--move-to` and the resolve-before-mutate guards (target must
   resolve, must not equal the source, must be in-project) are considered sufficient safety
   there (research §Q1.6 explicit recommendation: "gate only the irreversible path"). Because
   the delete-cascade's own changelog guarantee is INCONCLUSIVE (research §Q1.3 — not
   contractually promised by Atlassian, "leans yes" but unconfirmed), `jr` snapshots the
   affected issue keys via a read-only JQL search using the resolved **numeric component id**
   — `component = <resolvedId> ORDER BY key ASC` — BEFORE the DELETE, for both dispositions,
   and surfaces the full key list in `--output json`'s success payload — a client-side
   reconstruction record independent of whether Jira's own changelog captures the cascade. The
   `ORDER BY key ASC` clause is mandatory, not illustrative styling: it is the JRACLOUD-95368
   pagination-stability ordering this codebase already requires of every paginated JQL search
   (see the "`/rest/api/3/search/jql` repeated-`nextPageToken`" gotcha in CLAUDE.md), and a
   snapshot pagination that does not run to completion — the anti-loop guard aborts, or the
   walk is otherwise non-completed — is treated **fail-closed**: the delete is aborted rather
   than proceeding against a partial/unreliable affected-issue set. See BC-8.2.007
   (Postconditions 4 and 5).
   **The bare-name form `component = "<name>"` is explicitly rejected for this snapshot**,
   not merely a stylistic preference: a bare-name JQL `component` clause is not project-scoped
   by Jira and can match same-named components in other projects, which would silently inflate
   the affected-issue count, the confirmation-prompt count, and the affectedIssues
   reconstruction record with issues from projects the delete never touches — precisely the
   cross-project collision BC-8.4.004's resolver-scoping invariant exists to prevent. The
   component is always resolved to its numeric id first (via the same project-scoped resolver
   described in Decision §1); the snapshot JQL is built from that id, never from the raw
   name input. See BC-8.2.007 (Postcondition 4) and DEC-279.

4. **Wire-shape asymmetry (DEC-280): the single-issue `update` verb and the bulk endpoint are
   two genuinely different shapes — implement both explicitly, never assume one from the
   other.** Single-key `issue edit --component` (BC-3.4.022) sends the native Jira `update`
   verb, editmeta-gated (checking `fields.components.operations` for `add`/`remove`
   availability, mirroring the existing `--field` editmeta gate) with `{"add":{"name":X}}`/
   `{"remove":{"name":Y}}` **object** operations — falling back to a read-modify-write `set`
   verb only when editmeta does not advertise `add`/`remove` support. Multi-key/`--jql` bulk
   `--component` (BC-3.4.023) routes through `POST /rest/api/3/bulk/issues/fields` with
   `editedFieldsInput.multiselectComponents` — a single object, NOT `componentsFields`,
   NOT an array — containing `{"componentId": <integer>}` entries, requiring names resolved to
   numeric ids client-side BEFORE the POST is built (the bulk endpoint rejects name/id-string
   objects). `issue create --component` (BC-3.4.024) uses a third, simpler shape: additive
   `{"name": X}` objects on the initial `fields.components` array, no add:/remove: prefix
   grammar. These three shapes are never unified or assumed interchangeable — this ADR
   explicitly pins them apart, the same documentation discipline CLAUDE.md already applies to
   the `labelsFields`/`"labels"` and `issueType`/`"issuetype"` asymmetries, specifically
   because this asymmetry is *stronger* than either of those (research §Q2.3).

## Rationale

**Why not extend `resolve_team_field` generically instead of cloning it?** Teams are
org-global; components are project-scoped. A generic resolver parameterized over "is this
scope global or project-scoped" would either leak project-scoping bugs into team resolution
(which has its own dense, already-tested ambiguity-handling logic) or force an awkward
trait/generic split for a two-caller abstraction that saves little code. The F1 delta analysis
(§4, Wave-1 regression-risk table) explicitly recommends "a structurally parallel, NOT
shared/generic, implementation" for exactly this reason — this ADR ratifies that
recommendation.

**Why `ProjectMeta`'s keyed-map shape over `TeamCache`'s whole-file shape or a
`request_types_<sid>.json`-style per-entity-file shape?** Components are naturally
project-keyed (like `ProjectMeta`, unlike the org-global `TeamCache`), and a keyed-map-per-
profile file avoids an unbounded number of small cache files for orgs with many projects (the
per-entity-file alternative, modeled on `request_types_<sid>.json`, does not have this
drawback capped — request types are scoped per-service-desk, a small, bounded set per org,
whereas component-bearing projects can number in the hundreds on a large Jira instance).

**Why gate only `--orphan`, not `--move-to`, behind confirmation?** Research §Q1.6 states this
explicitly and the codebase's own `--yes`/interactive-confirm convention (comment delete,
DEC-168 family) already establishes the precedent of gating the *irreversible* action, not
every mutating action, to avoid friction accumulating on the safe path. Gating both would be a
defensible stricter choice but was rejected as unnecessary friction, consistent with research's
explicit recommendation.

**Why implement the bulk wire shape now, despite no live-run confirmation existing yet
(research §Q2.4)?** Unlike the bulk-transition case (`FIX-BULK-TRANSITION-001`), where the
Atlassian OpenAPI JSON itself was flat and wrong, the `multiselectComponents` shape is
triple-corroborated (Atlassian doc's own populated example, an independent apidog mirror, and
the swagger/OpenAPI schema) — a materially stronger evidentiary basis than the bulk-transition
case had. BC-3.4.023 pins a live-smoke-test gate before this path ships — scoped to the
operations `jr` actually emits: one ADD and one REMOVE against ≥2 issues in one project (per
BC-3.4.023 Postcondition 3, a bare `--component X` emits ADD; mixed `add:`/`remove:` input
emits two sequential POSTs, ADD then REMOVE — `jr` has no `set:`/`replace:`/clear CLI grammar
and never emits a third operation) — mirroring the `FIX-BULK-TRANSITION-001`/#446 precedent
exactly; if the live run contradicts the documented shape, the BC (and this ADR, transitively)
must be corrected to the observed truth, not silently patched around. `REPLACE`/`REMOVE_ALL`
are wire-schema-completeness values the `bulkEditMultiSelectFieldOption` enum accepts per the
endpoint's documented shape, but since `jr` never generates them, they are out of scope for
this jr-gated smoke test — a future `set:`/`replace:` grammar on `issue edit --component` would
be #607 scope, not this bundle.

**Why editmeta-gate the single-key `update` verb instead of always using it?** Community
reports (research file, Cross-cutting section) note the `add`/`remove` verbs have historically
been flakier than `set` (full-array replace) on some Jira instances. `jr` already has a
precedent for checking `editmeta` before committing to a specific PUT shape (`--field`'s
editmeta-gated pattern, BC-3.4.015) — reusing that pattern here, rather than either
unconditionally trusting `add`/`remove` or unconditionally paying the extra `GET` cost of
read-modify-write, keeps the common case cheap while providing a documented fallback for
atypical instance configurations.

## Consequences

### Positive

- Cross-project component-name collisions can never produce an incorrect resolution — the
  single architectural invariant (BC-8.4.004) this whole bundle is built to guarantee is
  enforced structurally (candidate-list scoping), not by a runtime check that could be
  bypassed by a future caller.
- `jr component delete` cannot silently discard issue-component associations with no
  disposition and no record — the combination of the `--move-to`/`--orphan` requirement, the
  `--orphan`-only confirmation gate, and the pre-delete JQL snapshot closes the exact gap
  research §Q1.3/§Q1.4 identified (no server-side confirm/undo, changelog not guaranteed).
- The three component wire shapes (single-issue `update`, bulk `multiselectComponents`,
  create-time additive) are each implemented against their actual documented/confirmed shape,
  not assumed from a sibling shape — avoiding a repeat of `BUG-LABEL-400`.
- The cache family reuses a proven, tested pattern (`ProjectMeta`) rather than inventing a new
  cache shape, minimizing implementation and review risk for Wave 1.

### Negative / Trade-offs

- Three distinct wire shapes for "put a component on an issue" (single-key `update` verb,
  bulk `multiselectComponents`, create-time additive array) is genuine implementation
  complexity that a naive "components are just like labels" assumption would have missed —
  Wave 2 (issue-side consumption) carries more branching logic than a simpler resource would.
- The bulk shape (BC-3.4.023) ships with a documented-but-not-yet-live-verified wire format;
  Wave 2's multi-key path cannot be marked done until the live smoke test passes, which is an
  explicit sequencing dependency this ADR does not resolve on its own.
- `component rename --all-projects` (BC-8.3.002) is O(N) HTTP calls (N = accessible project
  count) with no documented bulk-rename-across-projects endpoint — accepted as a scale caveat,
  not re-litigated here (F1 delta analysis §6 item 6).
- The resolver's numeric-ID bypass inherits the same escape-hatch gap `jr requesttype fields`
  already has: a component literally named `"100"` is unreachable by name through the
  `NAME|ID` positional (must be looked up by id via `--output json | jq`). Accepted as
  consistent, not novel, per BC-8.1.008.

### Status as of 2026-08-15

Accepted at the F2 gate for the component-management bundle. PRD-level decisions DEC-278/
279/280 are already recorded (`bc-8-components.md`, `bc-2-issue-read.md` §2.1,
`bc-3-issue-write.md` §3.4). This ADR is the architecture-layer ratification; no code exists
yet (`src/cli/component.rs`, `src/api/jira/components.rs`, `src/types/jira/component.rs`, and
the `cache.rs` components family are all `[PLANNED]` — see
`.factory/phase-f2-spec-evolution/architecture-delta-components.md` for the module-by-module
delta). Implementation is scoped to F4, Wave 1-4 per the F1 delta analysis's dependency
ordering (§5).

## Alternatives Considered

- **Option: generic `resolve_scoped_field` abstraction shared by teams and components.**
  Rejected — teams are org-global, components are project-scoped; forcing a shared generic
  would either leak project-scoping into team resolution or require an awkward trait split for
  a two-caller abstraction. See Rationale.

- **Option: one cache file per project (`components_<PROJECT>.json`, mirroring
  `request_types_<sid>.json`).** Rejected — unbounded file count on large orgs (many
  component-bearing projects) versus request types' small, bounded per-service-desk set. The
  keyed-map-per-profile shape (`ProjectMeta` precedent) scales better and matches an existing,
  tested pattern.

- **Option: gate BOTH `--move-to` and `--orphan` behind `--yes`/confirmation for
  non-interactive safety symmetry.** Rejected — `--move-to` is not destructive to issue data
  (issues keep a component either way); gating it too adds friction on the safe path with no
  corresponding safety benefit, and diverges from research §Q1.6's explicit "gate only the
  irreversible path" recommendation.

- **Option: defer the bulk multi-key `--component` wire shape entirely (ship single-key only
  this cycle), treating it as unconfirmed the way bulk transitions were initially treated.**
  Rejected — the bulk-transition precedent deferred because the *documented* shape was
  actually wrong (flat OpenAPI vs. the true nested `bulkTransitionInputs` shape, discovered
  only via a live run); here the documented shape is triple-corroborated and internally
  consistent. A live-smoke-test gate (BC-3.4.023's delivery note) is a lighter-weight
  safeguard than deferring the whole path, and avoids shipping Wave 2 without bulk support for
  no evidentiary reason.

- **Option: assume the single-issue and bulk component wire shapes are symmetric (both use
  `{"name": X}`/`{"id": X}` objects) to reduce implementation surface.** Rejected outright by
  research §Q2 — the bulk endpoint's `multiselectComponents.components[]` entries are
  documented, triple-corroborated integers (`{"componentId": <int>}`), not name/id objects.
  Assuming symmetry here would reproduce `BUG-LABEL-400` in a new form.

## Source / Origin

- F1 delta analysis: `.factory/phase-f1-delta-analysis/impact-boundary-components.md`
  (§2 component classification table, §3 architecture change assessment and recommended-ADR
  scoping, §5 dependency ordering).
- Research: `.factory/research/component-delete-and-bulk-wire-2026-08-15.md` (Q1 delete
  safety — moveIssuesTo semantics, recoverability, changelog inconclusiveness, confirmation
  norms; Q2 bulk wire shape — allowlist confirmation, exact JSON shape, asymmetry
  classification, live-run caveat).
- Behavioral contracts: `bc-8-components.md` (BC-8.1.001..008 CRUD, BC-8.2.001..008 delete
  safety/DEC-279, BC-8.3.001..007 rename, BC-8.4.001..005 resolver contracts);
  `bc-2-issue-read.md` §2.1 (BC-2.1.018..022 filter, BC-2.3.040 `Component.id` field);
  `bc-3-issue-write.md` §3.4 (BC-3.4.022..025 wire shapes/DEC-280).
- Decision log: `.factory/spec-changelog.md` (DEC-278/279/280 entries, component-mgmt cycle);
  `.factory/STATE.md`.
- Structural precedent code (as-built, cited for pattern only — not yet extended by this
  bundle): `src/cli/team.rs`, `src/api/jira/teams.rs`,
  `src/cli/issue/helpers.rs::resolve_team_field`, `src/cache.rs`'s `ProjectMeta` struct and its
  `read_project_meta`/`write_project_meta`/`invalidate_project_meta_cache` functions,
  `src/cache.rs::write_cmdb_fields_cache`/`write_object_type_attr_cache` (model-b swallow+warn
  writer convention), `src/cli/issue/edit.rs` `--field` editmeta gate (BC-3.4.015 pattern).
- Related ADRs: ADR-0007 (multi-profile fields — `profile: &str` first-arg invariant), ADR-0012
  (module shard rule — governs whether `component.rs` becomes a module directory), ADR-0014
  (JSM request-type dispatch fork — sibling precedent for a single-decision ADR covering a
  multi-facet feature bundle), ADR-0015 (proactive resolution enforcement — direct structural
  precedent for the delete-safety disposition-required pattern).
