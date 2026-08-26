---
document_type: f2-architecture-delta
phase: phase-f2-spec-evolution
producer: architect
issue: "580,578"
status: complete
date: 2026-08-25
amended: 2026-08-26
traces_to:
  - ".factory/phase-f1-delta-analysis/delta-analysis-field-dx.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-field-dx.md"
  - ".factory/research/field-dx-context-mechanism-2026-08-25.md"
  - ".factory/specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md"
---

# F2 Architecture Delta — Field DX Bundle (Issues #580, #578)

## 1. Files Updated

| File | Action | What Was Added |
|------|--------|----------------|
| `.factory/specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md` | NEW | Full ADR: context-mechanism strategy for `jr field options` (M2 createmeta primary / M3 JSM primary / M1 editmeta fallback; mode is selected by exactly one of {`--type`, `--request-type`, `--issue`} — `--project` is a companion flag, not a fourth mode-selector option — per ADR-0019 §1), `parse_field_kv` → `HashMap<String, FieldValueSpec>` shape with the bare-key/last-wins refinement, and the cascading-select `>` delimiter confirmation — one consolidated decision covering all three open design questions the product-owner deferred to architecture |
| `.factory/specs/architecture/ARCH-INDEX.md` | APPENDED | ADR-0019 row in the Architecture Decisions table |
| `.factory/architecture/adr-index.md` | APPENDED | ADR-0019 summary row (dual-tracking, mirrors the ADR-0017/ADR-0018 precedent) |
| `.factory/architecture/component-graph.md` | APPENDED | `Field DX Delta — DAG Verification` section: 1 new module node (`cli::field`), one new L4 method + inline types on the existing `api::jira::issues` node, all new/modified dependency edges, cycle check, purity-boundary cross-check — mirrors the existing `Component Management Delta` section's structure |
| `.factory/architecture/system-overview.md` | APPENDED | `§Purity Boundary` gains a `[PLANNED]`-tagged addition listing the bundle's pure and effectful-shell modules, cross-referencing `component-graph.md` |
| `.factory/phase-f2-spec-evolution/architecture-delta-field-dx.md` | NEW (this file) | Delta record for this burst |

No files were rewritten. All updates are append-or-targeted-edit operations, consistent with the
`architecture-delta-components.md` (issues #604/605/606/608) precedent this delta follows
structurally.

**Not touched by this burst (explicitly out of architect scope):** `src/`, `docs/adr/` (the
product-repo ADR file is an F4 story deliverable — see ADR-0019's own placement note), story
files, `.factory/specs/prd/*.md` BC files (product-owner scope — BC-X.14.001-004,
BC-3.3.010/011, BC-3.4.026-031, the BC-3.8.008 amendment, and the BC-3.8.012 reversal were
already recorded by the product-owner in the prior F2 burst; see
`.factory/phase-f2-spec-evolution/prd-delta-field-dx.md`). `module-criticality.md` and
`risk-register.md` were left untouched: no HIGH-impact R-NNN risk item references field
enumeration or `--field` hint syntax (grep-verified against `risk-register.md`), and module
criticality classification is deferred to Wave 1/2 story decomposition (F3), since no
implementation module exists yet to classify a kill-rate tier against. The DEC-310 governance
flag (renumbered from the initially-proposed DEC-307, which was already cycle-001's;
BC-3.8.012's reversal of a deliberate breaking change, DEC-188) is the product-owner's/
orchestrator's registration responsibility, not an architecture decision — this ADR's Source/
Origin section cites it for context only and does not attempt to resolve it.

**Known pre-existing structural gap (not introduced by this burst, reconfirmed):**
`component-graph.md` and `system-overview.md` predate this project's
`architecture-section-template.md` adoption (no `document_type`/`level`/`phase`/...
frontmatter). The `validate-template-compliance` hook fired `block_intent=true`
(`template_drift`) on both edits made by this burst, exactly as it did on the
component-management burst's edits to the same two files — this is the same known, accepted
characteristic of this repo's `.factory/architecture/` legacy directory documented in
`architecture-delta-components.md §1`, not a regression introduced here. Both edits were
verified to have landed (the hook is a PostToolUse warning, not a write-blocking rollback).

---

## 2. ADR Decision — Resolving the Three Open Design Questions (Deliverable 2)

**ADR-0019 was drafted.** Number: 0019 (allocated as
`max(docs/adr/ = 0016, .factory/specs/architecture/decisions/ = 0018) + 1`, consistent with the
allocation rule ADR-0018's own delta doc used). Title: "Field DX: option-enumeration context
strategy, hint-kind value-spec shape, and cascading-select delimiter." Filed at
`.factory/specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md`.

**One consolidated decision, mirroring the ADR-0018 precedent** — the three questions are facets
of one design surface, not independent decisions (the context-mechanism choice determines the
typed shapes `field.rs`'s normalizer consumes; the `FieldValueSpec` shape is the single carrier
both `field.rs` and `--field`'s three call sites share; the cascading delimiter is only
well-defined given the `FieldValueSpec.value`-is-a-raw-string decision).

### (a) Context-mechanism ADR — CONFIRMED exactly as researched

- **PRIMARY (platform):** `--project <P> --type <T>` → **M2 createmeta**
  (`GET /rest/api/3/issue/createmeta/{projectIdOrKey}/issuetypes/{issueTypeId}`). New method
  `JiraClient::get_createmeta_fields` in `src/api/jira/issues.rs`.
- **PRIMARY (JSM):** `--request-type <NAME|ID>` → **M3**, reuses `jr requesttype fields`'s
  existing plumbing + 7-day cache verbatim.
- **FALLBACK:** `--issue <KEY>` → **M1 editmeta**, reuses `JiraClient::get_editmeta` verbatim.
- **Exactly one required**, enforced pre-HTTP (BC-X.14.001), mirroring the `issue create
  --request-type` dispatch-fork error style (ADR-0014). This arity applies to the **mode
  selector** — exactly one of {`--type`, `--request-type`, `--issue`} chooses M1/M2/M3.
  `--project` is a **companion** flag, not a fourth mode-selector option: required alongside
  `--type` for M2, optional alongside `--request-type` for M3 (so `--project --request-type` is
  a VALID M3 invocation), and ignored for M1. Per ADR-0019 §1 / adversary pass-20 M1
  correction.

Rationale grounded directly in the dedicated research artifact
(`field-dx-context-mechanism-2026-08-25.md`)'s ranked recommendation: M2/M3 both return the
option **id** without requiring a pre-existing issue (closing #580's stated chicken-and-egg
motivation), are reachable by jr's ordinary OAuth-3LO non-admin user, and M1 remains a valid
low-friction fallback. Cited in full in ADR-0019 §1. **Type-reuse consequence recorded as part
of the decision, not incidental:** the new M2 response types are defined inline in
`api/jira/issues.rs` (matching the existing `IssueTypeEntry`/`CreatemetaIssueTypesResponse`
precedent for the createmeta family) and reuse `types::jira::editmeta::{AllowedValue,
EditMetaFieldSchema}` rather than duplicating them — both endpoints share the identical
observed-not-typed `allowedValues[].id` shape per the research doc's own Q-A finding.

### (b) `parse_field_kv` return-type shape — CONFIRMED with one load-bearing refinement

**Confirmed:** `HashMap<String, FieldValueSpec>` (retaining `HashMap`, not switching to an
ordered `Vec` — no consumer needs argv order; fields land on the wire as an unordered JSON
object either way).

**Refined (this is the one place architecture overrides the PO's proposal, not merely ratifies
it):** the map key is always the **bare field name** (the portion before an optional `:kind`
suffix), never a composite `"name:kind"` key. Without this explicit rule, `--field cf:option=A
--field cf:id=B` could produce two map entries instead of one last-wins overwrite — silently
double-applying the field with conflicting kinds at the wire-serialization step. This generalizes
BC-3.8.008's existing last-wins rule (previously stated for the bare form only) rather than
introducing new collision semantics.

Shape:
```rust
pub(crate) enum FieldValueKind { Option, Id, Name, Asset }
pub(crate) struct FieldValueSpec { pub kind: Option<FieldValueKind>, pub value: String }
pub(crate) fn parse_field_kv(pairs: &[String]) -> Result<HashMap<String, FieldValueSpec>, JrError>
```

`FieldValueSpec.value` is deliberately **uninterpreted** — `parse_field_kv` does not pre-split
`:option`'s `Parent>Child` cascading syntax or `:asset`'s `WORKSPACE:OBJECTID` compact form;
those remain call-site concerns (cascading composition is only implemented on the platform edit/
create paths this cycle, and `:asset` composition needs the cached workspace id that a pure,
`HashMap`/`String`-only `parse_field_kv` must not gain access to — staying pure is what keeps it
property-testable via the existing `parse_field_kv_proptests`). Consumption at all three call
sites (`edit.rs`, `create.rs` platform path, `jsm_create.rs`) needs no different shape — each
already dispatches on field type today (editmeta/createmeta) or is being retrofitted to
(`JsmRequestBuilder::build`'s `extra_fields` loop, currently an unconditional string-wrap).

**Documented as an ADR** (ADR-0019 §2), per the task's "ADR or a firm arch-note" instruction —
folded into the same consolidated ADR as (a) and (c) rather than a separate document, per the
ADR-0018 one-decision precedent.

**edit.rs shard determination: NO shard needed this cycle.** `edit.rs` is already ~3,187 LOC
(ADR-0012 DOCUMENT-AS-IS exception, PF-016). This bundle's footprint inside `edit.rs` itself is
narrow — threading `FieldValueSpec` instead of `String` through the existing `parse_field_kv`
call site, plus (per F1's regression table) small hint-kind-awareness additions to the dry-run
JSON preview and the BC-3.4.017 Gate B mutual-exclusion list. The dense dispatch/type-matching
logic this bundle actually grows lives in `field_resolve.rs` (a separate, already-extracted
914-LOC file, well under threshold) and `create.rs` (394 LOC, ≈530 projected post-F4), not in
`edit.rs` itself. Recorded as a firm, but explicitly revisitable, recommendation in ADR-0019 §2:
**if F4's actual `edit.rs`
diff exceeds ~100 LOC, the shard question should be reopened with the architect** rather than
decided unilaterally by the implementer.

### (c) Cascading-select `>` delimiter — CONFIRMED (not deferred), PROVISIONAL flag resolved

**Confirmed** `>` as the product-owner specified, with two refinements that turn the PROVISIONAL
marker into a firm answer:
1. **Split on the first literal `>` only** — Jira's cascading-select wire model has exactly two
   levels (parent + one child; `allowedValues[].children[]` is itself a flat, non-nested list
   per both M1 and M2's confirmed shape), so there is no ambiguity from choosing first-vs-last
   split and no grandchild case to represent.
2. **Documented `:id=` escape hatch** for a display value that itself contains a literal `>` —
   `:id=<numeric-id>` bypasses `allowedValues` lookup and cascading parsing entirely, so a user
   is never structurally blocked, only redirected to the more precise id-exact instrument.

Alternative delimiters (`::`, `->`, `/`, `,`) and a repeated-`--field`/fifth-hint-kind pattern
were considered and rejected in ADR-0019 §3 (marginal collision-probability improvement not
worth relitigating an already-drafted BC acceptance-criteria example; the PO's own explicit
constraint to keep the hint surface at four kinds). VP-578-008 can move from PROVISIONAL to a
firm target for F3 story authoring and F5 adversarial review.

---

## 3. Dependency Graph Delta

Text form (all edges are additions; no edges removed; no existing edges modified — see
`component-graph.md §Field DX Delta` for the full annotated version):

```
ADDED — new L2 handler (cli::field):
  cli::field → api::jira::issues (L4)        [get_createmeta_fields NEW + get_editmeta REUSED +
                                                get_issue_types_for_project (REUSED, S-331 — M2
                                                --type name→issueTypeId resolution)]
  cli::field → api::jira::fields (L4)        [REUSED — list_fields field-name resolution,
                                                BC-X.14.001; fields.json cache-first]
  cli::field → api::jsm::request_types (L4)  [REUSED — M3]
  cli::field → cache (L6)                    [REUSED — request-type-fields cache, M3 path only]
  cli::field → partial_match (L6)            [<field> name resolution, mirrors cli::requesttype]
  cli::field → output (L6)                   [render_json invariant]

ADDED — modified L4 module (api::jira::issues, additive only):
  api::jira::issues → types::jira::editmeta (L5)  [NEW edge — reuses AllowedValue/
                                                     EditMetaFieldSchema for the new
                                                     CreateMetaField type]

ADDED — new L2→L4 edges for the :asset hint (uniform per BC-3.8.008 amendment):
  cli::issue::field_resolve → api::assets::workspace (L4)  [NEW, get_or_fetch_workspace_id
                                                              REUSED read-only — edit path,
                                                              BC-3.4.030 primary site]
  cli::issue::create        → api::assets::workspace (L4)  [NEW, same reuse — platform-create
                                                              path, BC-3.3.010]
  cli::issue::jsm_create    → api::assets::workspace (L4)  [NEW, same reuse — JSM path,
                                                              BC-3.8.008 amendment]

ADDED — modified L4 module (api::jsm::requests, additive/type-widening only):
  JsmRequestBuilder.extra_fields: &'a HashMap<String,String> → &'a HashMap<String,FieldValueSpec>
  build()'s extra_fields loop: unconditional String-wrap → kind-aware match (BC-3.8.008)
  build()'s Some(Asset) arm: PURE wrap of an already-L2-composed value
    ({workspaceId,id,objectId} object, or a pre-qualified WORKSPACE:OBJECTID string) — build()
    performs no Assets I/O and calls get_or_fetch_workspace_id nowhere; workspace-id resolution
    is owned by the calling L2 handler (field_resolve/create/jsm_create), per ADR-0019 §2's
    "L2 resolves, build() only wraps" split

ADDED — modified L2 handlers (create.rs/edit.rs/jsm_create.rs, additive only):
  parse_field_kv (defined in create.rs) return-type change — internal signature change, NOT a
  new dependency edge; FieldValueKind/FieldValueSpec types defined alongside it
  (already-existing L2→L4/L6 edges on all three files are unchanged — richer payload only)

ADDED — modified L1/L0 (cli::mod / main.rs, additive only):
  Command::Field { command: FieldCommand } variant; new dispatch arm in main.rs, structurally
  identical to the existing RequestType arm
```

**Cycle check: DAG remains acyclic.** All new/modified edges follow the existing layer direction
(L2 → L4 → L3 → L6; L4 → L5; L2 → L6 directly, matching the `cli::requesttype`/`cli::component`
precedent). No upward edges (L4/L5/L6 → L2). No new L6 → L3/L4 edges. **The one cross-layer
shortcut this bundle could have introduced — `api::jsm::requests` (L4) reaching directly into
`api::assets::workspace` (L4) for the `:asset` hint — is explicitly avoided** (ADR-0019 §2): a
sibling-L4-to-L4 call would violate the existing Layer Isolation Summary ("L4 resource impls"
import from L3 client/L5 types/L6 only, never a sibling L4 subsystem). Instead, the workspace-id
resolution edge is placed at L2 (whichever of `field_resolve`/`create`/`jsm_create` applies the
hint resolves the cached id and passes it in as a plain value), consistent with the existing
`cli_assets`/`cli_issue_assets` → `assets_workspace`/`assets_linked` edges already present in
this graph.

---

## 4. Purity Boundary Classification

| Module (all `[PLANNED]` — no `src/` code yet) | Classification | Rationale |
|---|---|---|
| `cli::field::FieldOption` | **Pure core (data type)** | Plain data carrier, no I/O. Not a wire mirror of any single API response (a jr-synthesized `{id,label,children}` normalization shape reconciling M1/M2/M3) — kept CLI-local rather than under `types::jira::`/`types::jsm::`, per ADR-0019 §1 Rationale. |
| `cli::issue::create::{FieldValueKind, FieldValueSpec}` | **Pure core (data types)** | Plain data carriers, no I/O. The hint-kind value-spec types for `--field`, defined alongside `parse_field_kv` in `create.rs` (§3 above; ADR-0019 §2) — not part of `cli::field`, which has no need to construct or consume them (`jr field options` does not parse `--field` hints). |
| `cli::field::{normalize_from_allowed_values, normalize_from_valid_values}` | **Pure core (functions)** | No I/O; pure transforms from typed/untyped API response fragments to `FieldOption`. Function-level purity carve-out inside an otherwise-effectful module — same class as the already-documented `cli::resolve_effective_limit`/`config::validate_profile_name`. |
| `api::jira::issues::{CreateMetaField, CreateMetaFieldsResponse}` | **Pure core (data types)** | Serde structs, no I/O; reuse `types::jira::editmeta::{AllowedValue, EditMetaFieldSchema}` rather than duplicating them. |
| `cli::field::handle*` | **Effectful shell** | HTTP (via `JiraClient`/JSM request-type calls) + cache reads (M3 path) + stdout. Same class as `cli::requesttype`. |
| `api::jira::issues::get_createmeta_fields` | **Effectful shell** | HTTP via `JiraClient`, offset-paginated. Same class as every other method on this `impl`, including the sibling `get_issue_types_for_project`. |
| `cli::issue::{edit, create, jsm_create}` (modified, `--field` hint-syntax additions) | **Effectful shell** (unchanged classification) | Already-classified effectful handlers; hint-syntax support is new call patterns within already-effectful modules, not a reclassification. |
| `api::jsm::requests::JsmRequestBuilder::build` (modified) | **Effectful shell** (unchanged classification) | Already a pure-JSON-assembly function called from an effectful path; the kind-aware dispatch is additive logic within the same function, not a new I/O boundary — including the `Some(Asset)` arm, which wraps an already-L2-resolved value (workspace id resolved via `get_or_fetch_workspace_id` by the calling L2 handler *before* `build()` is invoked, per ADR-0019 §2's "L2 resolves, `build()` only wraps" split) and never itself calls into SS-06. |

**No existing module's purity classification changes as a result of this bundle.** The Purity
Boundary Map (`system-overview.md §Purity Boundary`) required only additive entries, tagged
`[PLANNED]` pending F4 implementation.

---

## 5. Confirmation: Dependency Graph Stays Acyclic (Deliverable 1, explicit ask)

**Confirmed acyclic.** Verification method: every new/modified edge listed in §3 was checked
against the existing "Layer Isolation Summary" table in `system-overview.md` (L2 imports from
L3/L6 only; L4 imports from L3 client/L5 types/L6 cache/error only, never a sibling L4; L5 types
import nothing above serde/std; L6 utilities import nothing from L0-L4). All new edges satisfy
these constraints without exception. The one edge shape this bundle deliberately did NOT
introduce — a direct L4→L4 call (`api::jsm::requests` → `api::assets::workspace`) — was
identified as a tempting shortcut during this analysis and explicitly routed around via an L2
resolution point instead (§3 above), preserving the existing layer-isolation invariant rather
than creating a new precedent for cross-L4 calls. This applies identically to
`JsmRequestBuilder::build()`'s own `Some(Asset)` match arm (§3 above / ADR-0019 §2): it receives
an already-composed value from its L2 caller and performs pure wrapping only, never resolving
workspace ids or otherwise reaching SS-06 itself — confirming no L4→L4 edge is introduced by the
`:asset` hint on the JSM path either. No new module imports from `cli::*` (L2) or from any module
above its own layer. See `component-graph.md §Field DX Delta` "Cycle check" paragraph for the
full annotated confirmation.

---

## 6. DTU Re-Assessment: N/A (Deliverable 3)

**No new external dependency is introduced.** All endpoints this bundle calls are existing Jira
Cloud REST API v3 / Agile REST API / JSM Service Desk API surfaces `jr` already has an HTTP
client and auth model for:
- `GET /rest/api/3/issue/createmeta/{projectIdOrKey}/issuetypes/{issueTypeId}` — new *call*, not
  a new *service*; same host, same `JiraClient`, same OAuth scopes family (`read:jira-work`)
  `jr` already requests. Sibling endpoint `GET .../createmeta/{projectKey}/issuetypes` is already
  called today by `get_issue_types_for_project`.
- `GET /rest/api/3/issue/{key}/editmeta` — already called (`get_editmeta`).
- `GET /rest/servicedeskapi/servicedesk/{sd}/requesttype/{rt}/field` — already called (`jr
  requesttype fields`).
- Assets workspace-id resolution (`get_or_fetch_workspace_id`) — already called, reused
  read-only for the `:asset` hint.

**No new crate.** No new dependency in `Cargo.toml` is required — HTTP, JSON, caching, and
partial-match infrastructure are all pre-existing `jr` capabilities being extended, not new
third-party surfaces. **DTU re-assessment is therefore N/A** for this bundle, consistent with
the F1 architect verdict ("No structural/interface redesign, no new subsystem") and the original
DTU assessment's baseline (`DTU_REQUIRED: false` — `jr` is a pure local/OS-execution + outbound-
HTTPS-to-Atlassian-only tool; this bundle adds outbound calls to hosts already in that same
trust boundary, not a new host).

---

## 7. ARCH-INDEX.md Version Note

Same pre-existing characteristic documented in `architecture-delta-components.md §6`:
`.factory/specs/architecture/ARCH-INDEX.md` carries no `version:` frontmatter field — it is a
plain heading-first document (Subsystem Registry + Architecture Decisions table only). The
ADR-0019 row insertion (§1 above) is the version-equivalent change; not retrofitting a
`version:` field here for consistency with the prior burst's documented decision not to
introduce one unprompted.

---

## 8. Traceability

- F1 delta analysis this burst implements: `.factory/phase-f1-delta-analysis/
  delta-analysis-field-dx.md`.
- PRD-side decisions this ADR formalizes (already recorded by product-owner, NOT re-authored
  here): `bc-3-issue-write.md` (BC-3.3.010/011, BC-3.4.026-031, BC-3.8.008 amendment, BC-3.8.012
  reversal), `cross-cutting.md` §X.14 (BC-X.14.001-004); `.factory/phase-f2-spec-evolution/
  prd-delta-field-dx.md`.
- Research consumed: `.factory/research/field-dx-context-mechanism-2026-08-25.md` (context-
  mechanism ranked recommendation and per-mechanism verdict table — cited verbatim in ADR-0019
  §1); `.factory/research/field-dx-feasibility-2026-08-25.md` (cited by the F1 delta analysis,
  not independently re-read by this burst beyond what F1/the PRD delta already summarized).
- Structural precedent this delta mirrors: `.factory/phase-f2-spec-evolution/
  architecture-delta-components.md` (issues #604/605/606/608 — same delta-doc + append-to-
  living-docs pattern, same one-ADR-for-multiple-facets precedent).

---

## 9. Amendment (2026-08-26) — F2 Adversary Convergence: D1/D2/D3/D4/F-B

**Trigger:** F2's mandatory adversarial spec-convergence loop ran three round-1 fresh-context
adversary passes against the frozen deltas (§0-8 above, `prd-delta-field-dx.md`,
`verification-delta-field-dx.md`) and surfaced three defects this delta's own architecture
decisions own the resolution of (D1/D2/D3). A subsequent round-2 adversary *completeness* pass
found a fourth, independent gap (**F-B**, below) in the same frozen deltas. A round-3 adversary
*completeness+correctness* pass (tag `F-2`) then found a fifth, independent gap (**D4**, below):
two undefined cells in the cascading `>`-split × field-schema-type matrix D3 partially specified.
Full decision text and rationale for all five: ADR-0019 § Amendment (2026-08-26). This section is
the delta-doc-level record of the same five decisions, kept in sync per this repo's convention
that `architecture-delta-*.md` mirrors its governing ADR's decisions rather than merely
cross-referencing them.

**File updated:** `.factory/specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md`
(EDITED — amendment appended, frontmatter `amended: 2026-08-26` added; §1/§2/§3's original text
is unchanged, the superseded/extended passages are called out explicitly rather than rewritten in
place, consistent with this project's ADR-0017 amendment precedent). No other `.factory/architecture/`
living doc required a matching append for this amendment — see per-item notes below.

### D1 — M2 default-project resolution parity (§2(a) above, superseded in part)

**Decision:** `resolve_field_context`'s pure arity check is narrowed to
`(has_type, has_request_type, has_issue) -> Result<Mode, ArityError>` — `has_project` is removed
from the pure function entirely. A new, separate post-arity step (M2-only, e.g.
`resolve_m2_project(cli_project: Option<&str>, config: &Config) -> Option<String>`) resolves the
project as **flag OR profile/config default**, restoring parity with BC-3.3.010's create-path
project resolution and M3's optional-`--project`-companion fallback. `--type`-without-a-resolvable-
project (no flag, no default) is still the incomplete-M2 exit-64 error — only the trigger condition
widens (from "no flag" to "no flag AND no default").

**Dependency-graph / purity-table impact (§3/§4 above):** no new edge — `resolve_m2_project` reads
already-loaded `Config` state passed as an explicit argument (no new dependency on `SS-0x` or any
I/O module); it is pure core, same class as `config::validate_profile_name`, and is folded into
the existing `cli::field::handle*`-adjacent pure-function row set in §4's table (no new table row
needed beyond noting `resolve_m2_project` alongside `resolve_field_context` as a second, sibling
pure function — both `[PLANNED]`, `cli::field` module).

**Not touched:** `component-graph.md`, `system-overview.md` — this is a signature refinement
inside an already-`[PLANNED]` function, not a new module or dependency edge; nothing in either
living doc references `has_project` today (both predate this bundle's implementation).

### D2 — create-path collision precedence (new architectural element)

**Decision:** extend Gate B (BC-3.4.017's collision guard) to the create path via one shared,
pure, extracted function — recommended name `field_resolve::detect_flag_field_overlap` — reused
by both `edit.rs`'s existing Gate B and a new create-path guard in `create.rs`, rather than two
independently maintained set-intersection implementations. Outcome: `jr issue create --priority
Medium --field priority:name=Medium` (any argv order, any hint kind) → exit 64, no HTTP, symmetric
with the edit path's EC-3.4.017-16.

**Dependency-graph delta (extends §3 above):**
```
ADDED — new shared pure function (field_resolve.rs), reused by create.rs:
  cli::issue::create → cli::issue::field_resolve (L2→L2, same-layer, pure-function reuse)
    [NEW — detect_flag_field_overlap, extracted from edit.rs's existing Gate B logic;
     edit.rs's own Gate B call site is refactored to call the same shared function]
```
This is an L2→L2 edge (both `create.rs` and `field_resolve.rs` are CLI-layer modules), not a
layer violation — no change to the Layer Isolation Summary's constraints, and no new cross-layer
edge is introduced by this addition.

**Purity-table delta (extends §4 above):** add one row —

| Module | Classification | Rationale |
|---|---|---|
| `cli::issue::field_resolve::detect_flag_field_overlap` | **Pure core (function)** | Set-intersection over an already-parsed `HashMap<String, FieldValueSpec>` and a caller-supplied governed-field-key set; no I/O. Shared by both `edit.rs`'s Gate B and the new create-path guard — same function-level purity carve-out class as `cli::resolve_effective_limit`/`config::validate_profile_name`. |

**BC-body propagation flagged, not made here (product-owner scope):** BC-3.4.029 EC-3.4.029-2 and
BC-3.4.014's "no Gate B on create" text both require correction — see ADR-0019 § Amendment
(2026-08-26), D2, "Downstream implication" paragraph for the exact passages to rewrite.

### D3 — cascading `>`-split multibyte safety (new obligation on an existing, already-planned split site)

**Decision:** every call site performing the `Parent>Child` cascading split (`field_resolve.rs`
edit path; the analogous point in `create.rs`'s platform-create path, BC-3.3.010) MUST implement
it via `str::split_once('>')` (never a char-index-based or fixed-byte-offset scheme) — closing the
FIX-F6-LRE-1 panic class (commit `37850b26`, #734) at a new split site this bundle itself
introduces. No dependency-graph or purity-table change: this is an implementation-technique
obligation on functions §3/§4 above already classify (the `:option` cascading composition inside
`field_resolve.rs`/`create.rs`'s L2 handlers), not a new module, function, or edge.

**Verification propagation flagged, not made here (verifier scope):** a no-panic proptest over
arbitrary UTF-8 input, one per call site, mirroring `validate_duration`'s FIX-F6-LRE-1 proptest and
the existing `parse_field_kv_proptests` precedent — extending or sibling to VP-578-008.

### F-B — degenerate option entry (missing `id`/`label`) read-path normalization (new architectural element, second-round adversary completeness pass)

**Trigger:** a second-round adversary *completeness* pass (not one of the three round-1 D1/D2/D3
findings above) found that neither this delta, ADR-0019, nor VP-580-005 §2 specifies what
`id`/`label` a source `allowedValues`/`validValues` entry with a **missing** `id` or `label`/
`value` receives once normalized into `FieldOption`. This is reachable in practice (a
GDPR-restricted user-picker option, or a config-broken option, both lack one or both fields) and
was previously undefined — three equally spec-conformant implementations (`""` sentinel, silent
drop, or label-as-id substitution) were all possible under the existing text. Full decision text
and rationale: ADR-0019 § Amendment (2026-08-26), subsection **F-B**.

**Decision:** `FieldOption.id` and `FieldOption.label` (currently both non-optional `String` in
§2(b)'s type sketch above) become `Option<String>` — a faithful pass-through of the already-optional
input shape (`types::jira::editmeta::AllowedValue.id`/`.value` are already `Option<String>`), not a
new sentinel invented at the `FieldOption` layer. Both normalizers (`normalize_from_allowed_values`,
`normalize_from_valid_values`) MUST emit exactly one `FieldOption` per source item regardless of
which fields that item carries — a missing `id`/`label` degrades that entry's own fields to `None`,
it MUST NEVER cause the entry to be dropped from the returned `Vec<FieldOption>` (the never-drop
invariant this decision adds on top of VP-580-005 §2's existing "never unwrap a missing field").
Table-mode rendering reuses existing glyphs rather than inventing new ones: `NULL_GLYPH` (`"—"`,
already used by `changelog.rs`/`user.rs`/`requesttype.rs`) for a missing id, the literal
`"(unnamed)"` for a missing label (deliberately not a fallback-to-id, since id may also be absent on
the same degenerate entry). JSON mode performs no substitution — the field stays `null`.

**Dependency-graph / purity-table impact (§3/§4 above):** none. This is a field-type refinement on
an already-`[PLANNED]` pure data type (`cli::field::FieldOption`, §4's first table row) and a
behavioral refinement of two already-`[PLANNED]` pure functions
(`normalize_from_allowed_values`/`normalize_from_valid_values`, §4's third table row) — no new
module, function, or dependency edge. Both remain classified exactly as §4 already has them: pure
core, no I/O. The table-mode glyph substitution (`"—"`/`"(unnamed)"`) belongs to the render/output
layer (`cli::field::handle*` or wherever table formatting is composed, an already-`[PLANNED]`
effectful-shell row), not to the pure normalizers themselves, which only ever produce
`Option<String>` — no new purity classification is introduced by this split.

**Not touched:** `component-graph.md`, `system-overview.md`, `ARCH-INDEX.md`,
`.factory/architecture/adr-index.md`, `module-criticality.md`, `risk-register.md` — same reasoning
as D1/D3's "not touched" notes: this is a signature/behavior refinement inside an already-`[PLANNED]`
type and pair of functions, not a new module, dependency edge, or HIGH-impact risk surface.

**BC-body / VP propagation flagged, not made here (product-owner and verifier scope):**
- Product-owner: BC-X.14.001's `FieldOption` contract (`id: String, label: String` →
  `id: Option<String>, label: Option<String>`) plus a new edge case documenting the never-drop
  invariant (sibling to EC-X.14.001-4's "`children` always present" contract); BC-X.14.003's
  Behavior/Postconditions gain the pinned `"—"`/`"(unnamed)"` rendering strings.
- Verifier: VP-580-005 §2 is strengthened from "no panic" to also assert entry-count preservation
  (never fewer `FieldOption`s than source items), the exact `Option::None`→JSON-`null` shape, and
  (integration-level) the two pinned table-rendering strings for a fixture item missing id/label
  respectively.

### D4 — cascading `>`-split × field-schema-type matrix: non-cascading-field collision, and bare-form `>`-literal asymmetry (round-3 adversary completeness+correctness pass, tag `F-2`)

**Trigger:** a round-3 adversary *completeness+correctness* pass (tag `F-2`, distinct from D3's own
`B-F2` finding tag despite the similar label) found that §3/D3's confirmed unconditional
`str::split_once('>')` split left two cells of the split × field-schema-type matrix undefined: (a)
`--field cf:option=A>B` where `cf` is a PLAIN (non-cascading) `option` field — parent resolves,
child has no `children` container to resolve against; (b) whether the BARE form
(`--field cf=Parent>Child`, no hint) also splits on `>`, or treats it as a literal character. Full
decision text and rationale: ADR-0019 § Amendment (2026-08-26), subsection **D4**.

**Decision (a):** the split stays unconditional at the call site (confirms D3 — no `schema.type`
inspection is added to the parser/composer). The non-cascading case is detected structurally,
during `allowedValues` resolution, at the same point EC-3.4.027-3's existing "unresolvable child"
check already inspects the matched parent's `children`: if a child segment is present and the
matched parent's `children` is empty, this is a NEW, distinct exit-64 error — sibling to, not a
reuse of, EC-3.4.027-2/EC-3.4.027-3 — naming the real problem (message load-bearing substrings:
`"is not a cascading select"`, `"remove the"`) rather than degenerating into EC-3.4.027-3's
"allowed child values: (empty)" shape. This requires extending the write-path
`types::jira::editmeta::AllowedValue` type (`src/types/jira/editmeta.rs`, currently `{id, value,
name}` only, verified as-built) with `#[serde(default)] children: Vec<AllowedValue>` — `Vec`, not
`Option<Vec<..>>`, because wire-absent and wire-empty-array carry the identical "no cascading
children" semantic here (unlike F-B's `id`/`label`, where absence was independently meaningful).
This type extension was already an implicit prerequisite for BC-3.4.027's happy path (resolving a
cascading child at all requires reading `allowedValues[].children[]`) — D4 makes it explicit and
pins its exact shape.

**Decision (b):** the bare form does NOT split on `>` — `>` is a literal character in the bare
value, confirmed as a stated contract (not left implicit). D3's scope already excludes
`parse_field_kv`/the bare-form dispatch from the `str::split_once('>')` obligation; D4 confirms
what happens instead: a bare `--field cf=Parent>Child` against a cascading field is resolved
exactly as BC-3.4.016 already resolves any bare value (whole-string match against
`allowedValues[].value`), which fails and falls through to the EXISTING EC-3.4.016-2
"unresolvable value" error — no new error path, no new code. A cascading field's child value can
therefore ONLY be set via the explicit `:option=Parent>Child` form (BC-3.4.027).

**Dependency-graph / purity-table impact (§3/§4 above):** none beyond the `AllowedValue` type-shape
pin already implied by D3/§3 — no new module, function, or dependency edge. The new error branch is
inserted into the already-`[PLANNED]` `field_resolve.rs`/`create.rs` L2 handlers' existing
`allowedValues`-walk (§4's classification of those handlers as effectful shell is unchanged; the
comparison itself — "is `children` empty" — is pure, same class as the rest of that resolution
logic).

**Not touched:** `component-graph.md`, `system-overview.md`, `ARCH-INDEX.md`,
`.factory/architecture/adr-index.md`, `module-criticality.md`, `risk-register.md` — same reasoning
as D1/D3/F-B's "not touched" notes: a new error branch and a type-shape pin inside already-`[PLANNED]`
functions/types, not a new module, dependency edge, or HIGH-impact risk surface.

**BC-body / VP propagation flagged, not made here (product-owner and verifier scope):**
- Product-owner: BC-3.4.027 gains a new Edge Case (e.g. EC-3.4.027-7, sibling to EC-3.4.027-2/3)
  documenting cell (a)'s trigger condition and pinned message substrings, plus the
  `AllowedValue.children: Vec<AllowedValue>` (`#[serde(default)]`) type-shape note. BC-3.4.015
  gains a note (near its bare-form dispatch, sibling to EC-3.4.015-9/10/11) stating `>` is literal
  in the bare form, cross-referencing BC-3.4.027 EC-3.4.027-7 and ADR-0019 D4.
- Verifier: a new/extended VP (sibling to VP-578-008) asserting (i) cell (a)'s exact pinned error
  substrings on a plain `option` field whose value contains a resolvable-parent `>`-split; (ii)
  cell (b)'s bare-form-`>`-is-literal behavior — bare form against a cascading field falls through
  to the existing EC-3.4.016-2 shape, never attempts a split.

### Files NOT touched by this amendment burst

`ARCH-INDEX.md` (no new ADR row — this is an amendment to the existing ADR-0019 row, not a new
ADR), `.factory/architecture/adr-index.md` (same reasoning), `module-criticality.md` (still no
implementation module to classify — unchanged from §1 above), `risk-register.md` (no new
HIGH-impact R-NNN risk introduced by any of D1/D2/D3/D4/F-B — these are correctness/consistency
fixes to already-planned behavior, not new risk surface).
