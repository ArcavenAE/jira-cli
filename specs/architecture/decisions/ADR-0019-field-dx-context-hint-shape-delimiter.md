---
document_type: adr
adr_id: ADR-0019
status: Accepted
date: 2026-08-25
amended: 2026-08-26
subsystems_affected: ["SS-02", "SS-04", "SS-05"]
supersedes: null
superseded_by: null
related: ["ADR-0012", "ADR-0014", "ADR-0018"]
---

# ADR-0019: Field DX — option-enumeration context strategy, hint-kind value-spec shape, and cascading-select delimiter

## Status

**Accepted** (2026-08-25). Gate: F2 spec evolution for the Field DX bundle (Feature Mode cycle
`field-dx`; issues #580, #578). Ratifies, at the architecture layer, the context-mechanism
research verdict (`.factory/research/field-dx-context-mechanism-2026-08-25.md`) already baked
into BC-X.14.001 by the product-owner, and resolves two additional open design questions the
product-owner explicitly deferred to architecture (F2 PRD delta, "Open design questions — NOT
resolved here" §1 and §3).
**Amended** (2026-08-26): F2 mandatory adversarial spec-convergence loop resolved three further
defects surfaced by fresh-context adversary passes — M2 default-project resolution parity (D1),
create-path `--field`/dedicated-flag collision precedence (D2), and cascading `>`-split multibyte
safety (D3). See § Amendment (2026-08-26) below.

> **NOTE — factory-artifact placement, not yet an F4 code artifact:** This ADR governs
> `src/cli/field.rs` (new), an extension to `src/api/jira/issues.rs`, and the `parse_field_kv`
> signature in `src/cli/issue/create.rs` — none of which exist in this shape in `src/` as of
> this writing (F2). The corresponding product-repo ADR file under `docs/adr/` is an **F4 story
> deliverable**, created in a worktree via PR when Wave 1/2 implementation lands — it is NOT
> created here. This factory artifact at
> `.factory/specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md` is
> the sole ADR-0019 record until F4 promotes it into `docs/adr/`.

**Amended** (2026-08-26): F2's mandatory adversarial spec-convergence loop (three fresh-context
adversary passes against the frozen F2 deltas) surfaced three additional defects in this ADR's
own text — a default-project resolution asymmetry (§1), an underspecified create-path collision
outcome (§2), and a missing multibyte-safety obligation on a new split site this ADR itself
introduced (§3). All three are resolved below in **§ Amendment (2026-08-26) — F2 Adversary
Convergence: D1, D2, D3**, which supersedes the specific passages it calls out; the rest of this
ADR (§1's context-mechanism strategy, §2's `FieldValueSpec` shape, §3's `>` delimiter choice) is
unchanged.

## Context

Two issues land together as one Feature Mode cycle: #580 (`jr field options <field>` —
enumerate a custom field's allowed options before creating/editing an issue) and #578
(value-kind hints on `--field`: `:option`/`:id`/`:name`/`:asset`, plus extending `--field` to
platform `issue create`). The F1 architect verdict found no new subsystem and no structural
redesign — everything fits SS-02 (CLI Layer) and SS-04 (Jira API Resources) — but flagged three
genuinely architectural forks the business-analyst's F2 PRD delta explicitly left open for this
ADR:

1. **Which HTTP context supplies option enumeration for #580?** The `field options` command's
   whole motivation is "get an option's id before creating a ticket" — a fundamentally
   pre-creation need. `jr` already owns editmeta (`GET /issue/{key}/editmeta`, consumed by
   `resolve_edit_fields`, BC-3.4.015/016) but that mechanism structurally requires an
   **existing** issue — a chicken-and-egg mismatch for #580's stated use case. A dedicated
   research pass (`field-dx-context-mechanism-2026-08-25.md`) evaluated three context suppliers
   (issue editmeta, project+issue-type createmeta, JSM request-type fields) against whether each
   returns the option **id** (not just display text), is reachable by jr's ordinary OAuth-3LO
   non-admin user, and requires a pre-existing issue.
2. **What return-type shape does `parse_field_kv` need once it must also carry a hint kind?**
   `parse_field_kv` (`src/cli/issue/create.rs`) is a single function feeding three independent,
   structurally different consumers: `resolve_edit_fields` (`field_resolve.rs`,
   editmeta-type-dispatch), the new platform-create path (BC-3.3.010, createmeta-type-dispatch,
   structurally parallel to edit), and `JsmRequestBuilder::build()` (`api/jsm/requests.rs`,
   currently a naive unconditional string-wrap). The product-owner proposed
   `HashMap<String, FieldValueSpec>` as a "concrete implementation-shape decision... not merely
   an open question" but explicitly flagged it as overridable by architecture (F2 PRD delta §3).
3. **What delimiter separates parent/child in the new `:option` cascading-select composition
   (BC-3.4.027)?** The product-owner chose `>` (`--field cf:option=Parent>Child`) but marked it
   PROVISIONAL, citing an unvalidated (low-probability) collision risk with option display
   values that themselves contain a literal `>` character, and asked architecture to confirm or
   propose an alternative before F3 story authoring locks the parser.

These three forks are treated as one ADR, not three, for the same reason ADR-0018 treated four
component-management facets as one decision: they are inseparable in practice. The
context-mechanism choice (§1) determines which typed response shapes reach the normalization
layer; the `FieldValueSpec` shape (§2) is the single carrier both `field.rs`'s consumers and
`--field`'s three call sites share; and the cascading delimiter (§3) is only meaningful once
`FieldValueSpec`'s `:option` value is defined as an *uninterpreted raw string* that a call site
parses — a direct consequence of §2's shape decision.

## Decision

We resolve all three forks as follows.

### 1. Context-mechanism strategy for `jr field options` (BC-X.14.001) — exactly-one-mode-selector, `--project` is a companion not a selector

**Correction (adversary pass-20, M1):** the arity model below supersedes an earlier
under-specified "exactly one of `--project`/`--type` | `--request-type` | `--issue`" framing
that treated `--project` as a co-equal member of the mode-selecting set. That framing made
`--project --request-type` a pairing error, leaving M3-with-an-explicit-project reachable only
via profile/config default — inconsistent with the sibling `jr requesttype fields`, which
happily accepts an ambient `--project` alongside a request-type lookup. The corrected model
below is the binding one; treat any BC or VP text still describing `--project` as a mode
selector as stale.

**The enumeration MODE is selected by exactly one of three MODE-SELECTOR flags:
`--type`, `--request-type`, `--issue`.** `--project` is never a mode selector — it is a
*companion* flag whose role (required, optional, or forbidden) is determined by which mode
selector is present:

- **`--issue <KEY>` → M1, editmeta.** Reuses `JiraClient::get_editmeta` verbatim (already
  called by `resolve_edit_fields`). No new API-layer code. `--type` and `--request-type` MUST
  be absent (mode-selector exclusivity, below); `--project` alongside `--issue` is NOT
  CONSULTED (the issue key alone supplies project context; a stray `--project` is harmlessly
  ignored, not rejected).
- **`--type <T>` → M2, createmeta.** REQUIRES `--project <P>` as its companion (needed for
  name→issueTypeId resolution, per the pass-16 fix): `GET
  /rest/api/3/issue/createmeta/{projectIdOrKey}/issuetypes/{issueTypeId}` (the current,
  non-deprecated form — CHANGE-1304 deprecated the old `createmeta?expand=` shape). New method
  `JiraClient::get_createmeta_fields(project_key, issue_type_id)` in `src/api/jira/issues.rs`,
  offset-paginated (`startAt`/`maxResults`/`total`; prefer the `fields` key, tolerate the
  OpenAPI-synonymous `results` key; no `values`, no `nextPageToken` — same pagination family as
  the existing sibling `get_issue_types_for_project`, which already establishes the
  createmeta-family precedent of defining its response types *inline in `issues.rs`*, not under
  `types::jira::`). Only documented project permission: **Create issues** — no admin, no
  existing issue. `--type` present without its `--project` companion → the **incomplete-M2
  error**. (A bare `--project` with NO mode selector present is NOT the incomplete-M2 case — it
  fails the zero-mode-selector arity check first, per error case (2); `--project` selects no mode
  on its own.)
- **`--request-type <RT> [--project <P>]` → M3, JSM requesttype fields.** Reuses `jr`'s
  existing `jr requesttype fields` plumbing (`api::jsm::request_types`,
  `{read,write}_request_type_fields_cache`, 7-day TTL) verbatim. No new API-layer code.
  `--project` is an **optional** companion naming the service-desk project explicitly; when
  absent, the ambient project (global `--project` — same flag, so this is simply "supplied or
  not" — or profile/config default) is used, resolved via `require_service_desk` /
  `get_or_fetch_project_meta` exactly as `jr requesttype fields` already does. **`--project
  --request-type` together is VALID** (M3 with an explicit project override), not a pairing
  error — this is the concrete fix that makes M3 fully reachable without relying solely on a
  profile default.
- **Mode-selector exclusivity:** exactly one of `{--type, --request-type, --issue}` must be
  present, enforced before any HTTP call (BC-X.14.001, mirrors `jr`'s existing
  context-resolution error style — exit 64, same pattern as `issue create --request-type`'s
  dispatch-fork guard, ADR-0014). Two-or-more mode selectors and zero mode selectors are both
  errors under this same exclusivity check.
- **Error cases, enumerated:**
  1. Two or more of `{--type, --request-type, --issue}` present → exit 64, "specify exactly
     one of `--type`, `--request-type`, `--issue`".
  2. Zero of `{--type, --request-type, --issue}` present → exit 64, same message as (1). This is
     the case that owns a bare `--project` supplied alone (with no mode selector) — `--project`
     is never itself a mode selector (per the arity model above), so "only `--project`" is
     zero-mode-selectors, not incomplete-M2; case (3) below does NOT also claim this input, since
     it requires `--type` to be present.
  3. `--type` present without `--project` → exit 64, incomplete-M2 error ("`--type` requires
     `--project`").
  4. `--request-type` present with no resolvable ambient project (no `--project`, no
     profile/config default) → the existing `require_service_desk` "project required" error,
     unchanged from `jr requesttype fields`'s own behavior.
- **`has_project` note for the M2 arity check** **[superseded 2026-08-26 — see Amendment D1]:** where implementation or test code refers to a
  boolean `has_project` in the context of the M2 (createmeta) arity check specifically, it means
  "`--project` is present *as M2's companion*, i.e. accompanying `--type`" — not "`--project` is
  present at all" (which is also true, harmlessly, in the M3-with-explicit-project case, but
  that case is evaluated under M3's own optional-companion rule, not M2's required-companion
  rule).

**Rationale:** M1 (editmeta) is what `jr` already calls for `issue edit --field`, but it is
structurally the *wrong primary* for #580 — it requires an issue that does not yet exist for the
command's stated motivating use case ("what id do I pass before I create the ticket"). M2
(createmeta) closes exactly that gap: same `allowedValues[].id` shape as M1 (both reuse
`types::jira::editmeta::AllowedValue` and `EditMetaFieldSchema` directly — see the type-reuse
note below), reachable by an ordinary OAuth-3LO user under the Create-issues permission, no
admin gate, no pre-existing issue. M3 is the natural JSM-side equivalent and dovetails with
plumbing `jr` already owns. M1 remains valuable as a low-friction fallback for a user who
already has a reference issue to copy an option id from. This is the exact ranked
recommendation of the dedicated research pass; ADR-0019 formalizes it as the binding decision
rather than leaving it as a research recommendation a future contributor could second-guess.

**Type reuse (architectural consequence, not incidental):** M2's new response types are defined
**inline in `src/api/jira/issues.rs`**, next to `get_createmeta_fields`, following the exact
precedent `IssueTypeEntry`/`CreatemetaIssueTypesResponse` already established for the sibling
createmeta-issuetypes call (that precedent's own in-code comment explicitly documents *why* it
is a separate type rather than a shared one — the field sets differ). The new `CreateMetaField`
struct **reuses** `types::jira::editmeta::{AllowedValue, EditMetaFieldSchema}` for its
`schema`/`allowed_values` fields rather than redefining them — both endpoints' `allowedValues[].id`
shape is the same *observed-not-typed* structure per the research doc's own Q-A finding. This is
a deliberate type-reuse decision this ADR records: it avoids a second copy of the "Jira's v3
OpenAPI leaves `allowedValues.items` untyped" defensive-parsing burden, and keeps the M1/M2
normalization path (see §2) able to share one function.

### 2. `parse_field_kv` return-type shape — `HashMap<String, FieldValueSpec>`, bare-name key, last-wins

We **confirm** the product-owner's proposed shape with one load-bearing refinement made explicit:

```rust
pub(crate) enum FieldValueKind { Option, Id, Name, Asset }  // BC-3.4.026 hint tags

pub(crate) struct FieldValueSpec {
    pub kind: Option<FieldValueKind>,  // None = bare form (BC-3.4.015/016, permanent, unchanged)
    pub value: String,                  // raw, uninterpreted — cascading `>` split is a CALLER concern (§3)
}

pub(crate) fn parse_field_kv(pairs: &[String]) -> Result<HashMap<String, FieldValueSpec>, JrError>
```

- **`HashMap`, not an ordered `Vec`.** Order preservation is not needed: fields are applied as
  an unordered *set* onto the wire (`fields`/`requestFieldValues` are themselves JSON objects,
  not ordered operation lists — unlike, say, the `add:`/`remove:` label-edit grammar, which
  genuinely is sequential). Switching to `Vec<(String, FieldValueSpec)>` would only add ordering
  the three consumers do not use, at the cost of relitigating the existing
  `parse_field_kv_proptests` HashMap-shaped properties (BC-3.4.026 Invariant, F1 §5 item 3) for
  no behavioral gain.
- **The map key is always the bare field name** — the portion before a `:kind` suffix, if
  present, never `"name:kind"` as a composite key. This is the one refinement this ADR adds
  beyond the product-owner's proposal, because it is not obvious from
  "`HashMap<String, FieldValueSpec>`" alone and gets it wrong if unspecified:
  `--field cf:option=A --field cf:id=B` must produce **one** map entry (last-wins overwrites the
  whole `FieldValueSpec`, including its kind), never two entries that could both reach a
  wire-serialization step and silently double-apply the field with conflicting kinds. This
  generalizes BC-3.8.008's existing last-wins rule (previously stated for the bare form only) to
  the hinted form without introducing new key-collision semantics — the field-identity concept
  ("which Jira field is this pair about") is unchanged by adding a kind tag.
- **Value-kind hint parsing happens once, in `parse_field_kv` itself** (BC-3.4.026) — it splits
  `NAME:kind=VALUE` into `(bare_name, FieldValueKind, raw_value)` and constructs
  `FieldValueSpec`; it does **not** parse `:option`'s `Parent>Child` cascading syntax (§3) or
  `:asset`'s `WORKSPACE:OBJECTID` compact form — those remain call-site concerns, because only
  the platform edit/create paths implement cascading composition this cycle (BC-3.8.008's
  amendment explicitly does NOT extend cascading to JSM), and Assets composition needs the
  cached workspace id (`get_or_fetch_workspace_id`, SS-06) that `parse_field_kv` — a pure,
  `HashMap`/`String`-only function per BC-3.4.026 — has no access to and must not gain access
  to (staying pure is precisely what keeps it property-testable via
  `parse_field_kv_proptests`).
- **`:asset` composition ownership: L2 resolves, `build()` only wraps.** The
  `[{"workspaceId","id","objectId"}]` array Jira's Assets custom-field wire format requires
  (BC-3.8.008) is composed by the **L2 handler** — `field_resolve.rs` (edit path), `create.rs`
  (platform create path), or `jsm_create.rs` (JSM path) — never by
  `JsmRequestBuilder::build()`. For the bare `:asset=<objectId>` form (no workspace segment),
  each L2 handler calls `get_or_fetch_workspace_id` (cached; HTTP only on a cold cache) to
  resolve the workspace id *before* calling `build()`/the wire-serialization step, then either
  composes the full `{"workspaceId","id","objectId"}` object itself or pre-qualifies the raw
  value to the explicit `WORKSPACE:OBJECTID` form. `build()`'s `Some(Asset)` match arm receives
  this already-resolved, ready-to-serialize value and performs **pure wrapping only** — it never
  calls `get_or_fetch_workspace_id`, never reaches SS-06, and stays "not a new I/O boundary"
  (§4 purity table, `architecture-delta-field-dx.md`). This resolves the apparent
  contradiction between BC-3.8.008 assigning array composition to `build()` (SS-05/L4) and §2's
  own pure-`parse_field_kv` constraint (no L4→L4 Assets edge, no I/O in `build()`): "the composer
  function is shared across platform+JSM" refers to this pure array/object-wrapping half only —
  workspace-id resolution is owned by L2 on all three paths (platform edit, platform create, JSM
  create), which is exactly what the `→ api::assets::workspace` dependency-graph edges
  originating at `field_resolve`/`create`/`jsm_create` (never at `api::jsm::requests`) already
  encode (`architecture-delta-field-dx.md §3/§5`). This preserves both the no-L4→L4-Assets-edge
  invariant and `build()`'s existing purity classification.
- **Consumption at the three call sites is unchanged in shape, only in richness:**
  `resolve_edit_fields` (`field_resolve.rs`) gains a hinted-bypass branch that reads
  `spec.kind` before falling into its existing editmeta type-dispatch on `spec.kind == None`;
  the new platform-create path (BC-3.3.010) mirrors this against createmeta instead of editmeta;
  `JsmRequestBuilder::build()` (`api/jsm/requests.rs`) replaces its current unconditional
  `serde_json::Value::String(v.clone())` wrap with a match on `spec.kind` (BC-3.8.008
  amendment). None of the three needs a different `FieldValueSpec` shape — this is exactly why a
  single shared type across three consumers was the right call to confirm rather than override.

**Does this require sharding `edit.rs`?** **No, not as part of this cycle.** `edit.rs` is
already ~3,187 LOC (≈3× the ADR-0012 threshold, DOCUMENT-AS-IS exception, PF-016). This
bundle's actual footprint inside `edit.rs` is narrow: the dispatch/type-matching logic this ADR
describes lives in `field_resolve.rs` (a separate, already-extracted 914-LOC file, well under
threshold) and in `create.rs` (394 LOC, ≈530 projected post-F4) — `edit.rs` itself only needs (a) to thread
`FieldValueSpec` instead of `String` through its existing `parse_field_kv` call site, and (b)
per the F1 regression table, possible small awareness additions in the dry-run JSON preview
assembly and the BC-3.4.017 Gate B mutual-exclusion list. F1 characterizes this as "narrow,
well-isolated," not a new dense cluster. Forcing a shard onto an already-DOCUMENT-AS-IS file to
accommodate an estimated double-digit-LOC change is disproportionate and not recommended.
**Revisit this recommendation if F4's actual `edit.rs` diff exceeds roughly 100 LOC** — that
would indicate the dry-run/Gate-B touches grew beyond what F1/this ADR anticipated, at which
point a mid-cycle shard proposal should go back to the architect, not be decided unilaterally by
the implementer.

**Note on `subsystems_affected` and SS-05 (JSM API Resources):** SS-05 is included in this ADR's
`subsystems_affected` frontmatter (`["SS-02", "SS-04", "SS-05"]`) because
`src/api/jsm/requests.rs::JsmRequestBuilder::build` — SS-05's own code — is genuinely
**modified** by this bundle: its `extra_fields` parameter's type changes
(`&HashMap<String, String>` → `&HashMap<String, FieldValueSpec>`) and its body gains the
kind-aware match on `spec.kind` described above (BC-3.8.008 amendment). This is a real signature
and logic change to SS-05-owned code, not a read-only call into it — contrast the SS-06 (Assets)
carve-out immediately below, where SS-05/SS-02/SS-04 call into existing SS-06 infrastructure but
nothing inside SS-06 itself changes.

**Note on `subsystems_affected` and SS-06 (Assets):** the `:asset` hint's resolution path
(`cli::issue::field_resolve`/`create`/`jsm_create` → `api::assets::workspace`, §"Assets
composition" above) calls into SS-06 (Assets API Resources, `src/api/assets/`) by reusing
`get_or_fetch_workspace_id` — the same cached-workspace-id lookup BC-4.2.001 already
established for `assets search`. This is **read-only reuse, not a modification**: no function,
type, or cache-write path inside SS-06 changes shape, signature, or behavior as a result of this
bundle (see §3's dependency-graph delta and §4's purity table — SS-06 has zero entries in
either). SS-06 is therefore intentionally omitted from this ADR's `subsystems_affected`
frontmatter (`["SS-02", "SS-04", "SS-05"]`), which tracks subsystems whose own code this ADR
governs or changes, not every subsystem a governed module happens to call into read-only.

### 3. Cascading-select delimiter (BC-3.4.027) — confirm `>`, split on first occurrence, document the `:id` escape hatch

We **confirm** `>` as specified, with two refinements that resolve the PROVISIONAL flag to a
firm answer:

- **Split on the first literal `>` only.** Jira's cascading-select wire model has exactly two
  levels — a parent option and an optional single child (`allowedValues[].children[]`, itself a
  flat list with no further nesting, per both M1 and M2's confirmed response shape) — so there
  is no cascading grandchild to represent, and no ambiguity from choosing first-vs-last split
  point matters for correctness. `--field cf:option=Parent>Child` →
  `{"value":"Parent","child":{"value":"Child"}}` (BC-3.4.027); a value with a second `>` (e.g.,
  `Parent>Child>trailing`) treats everything after the first delimiter as the (verbatim) child
  value, never attempts a third level.
- **Documented escape hatch for a legitimate `>` in a display value:** `:id=` bypasses
  `allowedValues` lookup and cascading parsing entirely (BC-3.4.028, sends `{"id":"<VALUE>"}`
  verbatim) — a user whose parent or child option's own display text contains a literal `>`
  character can always fall back to `:id=<numeric-id>` once they've discovered the id via
  `jr field options`. This closes the collision risk the product-owner flagged (F2 PRD delta,
  open question 1) without inventing a fifth hint kind or a different delimiter, and without
  blocking the (low-probability, per research) case entirely — the user is never stuck, only
  redirected to the id-exact path, which is already the more precise instrument for interacting
  with a specific enumerated option.

**Why not a different separator (`::`, `->`, `/`, `,`, or a repeated-flag pattern)?** All were
considered and rejected: `/` and `,` collide with more common real-world option text (paths,
dates, fractions; comma-delimited display values are ordinary); `::`/`->` are marginally safer
than `>` but not categorically so, and switching away from the product-owner's `>` choice for a
marginal collision-probability improvement is not worth relitigating an already-shipped-in-the-
PRD-delta acceptance-criteria example. A repeated-`--field` pattern (e.g., a second flag
carrying the child) was rejected because it reintroduces positional/ordering fragility across
two independent `--field` occurrences for what is conceptually one field assignment — exactly
the kind of cross-flag state-threading `jr`'s existing single-flag-per-field-value convention
avoids everywhere else. A dedicated fifth hint kind (e.g., `:option-child=`) was rejected per
the product-owner's own stated constraint (F2 PRD delta open question 1: "keep the four-kind
hint surface... intact").

## Rationale

**Why one ADR for three forks instead of three?** Per the same reasoning ADR-0018 established as
precedent for this codebase: the forks are facets of a single feature bundle's design surface,
not independent decisions. The context-mechanism choice (§1) determines the typed shapes
`field.rs`'s normalization layer consumes; the `FieldValueSpec` shape (§2) is the single carrier
`field.rs`'s own hint-kind vocabulary and `--field`'s three call sites both depend on; the
cascading delimiter (§3) is only well-defined given §2's decision that `FieldValueSpec.value` is
an uninterpreted raw string. Reviewing them separately would fragment a decision that needs to
be read as a whole.

**Why does the normalization component belong in `cli/field.rs`, not `types::jira::`?** The
`{id, label, children}` internal model (`FieldOption`) does not mirror any single external API
response — it is a jr-synthesized display shape that reconciles three different wire shapes
(M1/M2's typed `AllowedValue.id`, M3's untyped `serde_json::Value` keyed by `.value`) into one.
`types::jira::`/`types::jsm::` are reserved for typed mirrors of actual Jira/JSM API responses
(per the existing product-namespaced convention CLAUDE.md documents); a synthesized cross-context
display type does not fit that convention and instead follows the precedent of CLI-local
output-shaping structs (e.g., `cli/issue/json_output.rs`'s scoped-to-display types) — kept
`pub(crate)` inside the new `cli/field.rs` module. The two normalization functions
(`normalize_from_allowed_values(&[AllowedValue]) -> Vec<FieldOption>` for M1/M2,
`normalize_from_valid_values(&[serde_json::Value]) -> Vec<FieldOption>` for M3) are themselves
**pure** — no I/O — despite living inside the otherwise-effectful `cli::field` module, exactly
the same function-level purity carve-out `system-overview.md §Purity Boundary` already documents
for `cli::resolve_effective_limit` and `config::validate_profile_name`.

**Why reuse `AllowedValue`/`EditMetaFieldSchema` for the new createmeta types instead of
defining parallel ones?** The research doc's Q-A section independently confirms M1 and M2 share
the identical `{id, value, name, children}` shape (both are "observed-not-typed" per Jira's own
v3 OpenAPI, which leaves `allowedValues.items` untyped) — defining a second, structurally
identical type would only be defensive-parsing duplication with no behavioral benefit, and would
require the normalization layer to special-case two nominally-different-but-structurally-identical
types instead of one shared `normalize_from_allowed_values`.

## Consequences

### Positive

- `jr field options` gets its option ids without requiring a pre-existing issue for the common
  (platform, non-JSM) case — directly serving #580's stated motivation, rather than inheriting
  M1's chicken-and-egg limitation by default.
- `FieldValueSpec`'s bare-key/last-wins refinement prevents a specific, easy-to-miss double-
  application bug (conflicting kind hints on repeated `--field NAME` occurrences) that the
  product-owner's proposal did not by itself rule out.
- The cascading delimiter question is closed with a concrete parsing rule (first-`>`-only) and a
  documented escape hatch, unblocking F3 story authoring and giving the adversary (F5) a firm
  target to test against instead of a PROVISIONAL marker.
- No new external dependency, no new crate — the createmeta fields-by-issue-type call is a new
  endpoint on infrastructure (`JiraClient`) `jr` already has, following an established
  in-file-type precedent (`get_issue_types_for_project`'s sibling).

### Negative / Trade-offs

- Four flags now exist on one command (`--type`, `--request-type`, `--issue` as mode selectors
  under mutual-exclusion, plus `--project` as a mode-dependent companion — required for
  `--type`, optional for `--request-type`, ignored for `--issue` (unconstrained companion; not
  rejected)) — a small but real increase in `jr field options`'s own surface-area/error-taxonomy
  complexity (BC-X.14.004), consistent with (not novel relative to) `jr issue create
  --request-type`'s existing dispatch-fork pattern.
- `parse_field_kv`'s signature change ripples to three call sites (`edit.rs`, `create.rs`
  platform path, `jsm_create.rs`) even though the shape itself does not need to differ per call
  site — this is accepted fan-out cost, not avoidable without either duplicating parsing logic
  or accepting a weaker shared type.
- The cascading-select `>` delimiter still carries a nonzero (research-confirmed-as-low-
  probability, not eliminated) collision risk with option display text containing a literal `>`;
  the `:id=` escape hatch mitigates but does not structurally prevent user confusion on first
  encounter — accepted as the least-bad option among those considered.

## Alternatives Considered

- **Option (§1): keep `--issue <KEY>` (M1/editmeta) as the sole context for `jr field options`,
  matching `issue edit --field`'s existing mechanism exactly.** Rejected — defeats #580's stated
  pre-creation motivation; would force every first-time user to create a throwaway issue just to
  discover an option id.
- **Option (§1): use the admin-gated `GET /field/{id}/context/{ctx}/option` endpoint the issue
  literally names.** Rejected in the prior research pass (cited in the F1 delta analysis) —
  fails for jr's ordinary non-admin OAuth-3LO user, `manage:jira-configuration` +
  Administer-Jira gated.
- **Option (§2): `Vec<(String, Option<FieldValueKind>, String)>` to preserve strict argv-order
  semantics.** Rejected — no consumer needs order; would only relitigate the existing
  HashMap-shaped proptests for no behavioral gain, per Rationale.
- **Option (§2): a composite map key (`"name:kind"`) instead of bare-name.** Rejected — this is
  the exact double-application bug this ADR's refinement exists to prevent; two entries for one
  logical field is a correctness hazard, not a feature.
- **Option (§3): a fifth `:option-child=` hint kind.** Rejected per the product-owner's explicit
  constraint to keep the hint surface at four kinds (F2 PRD delta open question 1).
- **Option (§3): defer the cascading-select delimiter decision entirely, ship BC-3.4.027 without
  it this cycle.** Rejected — the product-owner already committed the `>` example into
  BC-3.4.027's own acceptance-criteria text; deferring now would mean re-opening an
  already-drafted BC rather than confirming/refining it, a strictly worse outcome for F3 story
  authoring than resolving it here.

## Amendment (2026-08-26) — F2 Adversary Convergence: D1, D2, D3, D4, F-B

Fresh-context adversary passes against the frozen `architecture-delta-field-dx.md`,
`prd-delta-field-dx.md`, and `verification-delta-field-dx.md` surfaced defects this ADR owns the
architecture-decision half of. Per the F2 adversarial spec-convergence loop's division of labor,
this amendment resolves only the architectural fork in each finding; the corresponding BC-body
and VP text changes are flagged below for the product-owner and verifier passes that follow, not
made here. D1/D2/D3 (below) are the first (round-1) convergence pass; **F-B** is a second-round
adversary *completeness* pass finding, and **D4** is a third-round adversary
*completeness+correctness* pass finding (adversary tag `F-2`) — both added in this same amendment
section per this repo's convention that one ADR amendment section accumulates all rounds against
the same frozen delta rather than spawning a new amendment header per round.

### D1 (adversary MEDIUM-1) — M2 default-project resolution parity

**Defect.** §1's arity model evaluates `resolve_field_context(has_type, has_request_type,
has_issue, has_project)` as one pure function, pinning `has_project` to the literal `--project`
CLI flag and requiring `ok = selectors==1 && (!has_type || has_project)`. Consequence: `jr field
options FOO --type Bug` exits 64 even when the active profile has a default project configured —
contradicting BC-3.3.010 (`issue create --field` resolves project as "flag OR profile default")
and M3 (`--request-type`'s optional `--project` companion already falls back to the ambient
profile/config default). M2 alone silently refuses the same default every sibling context accepts.

**Decision: restore parity.** The "is a project resolvable at all?" question is moved OUT of the
pure arity function into a distinct, post-arity resolution step, executed only on the M2 branch:

1. **Step 1 — pure arity check (`resolve_field_context`), NARROWED.** Signature changes to
   `resolve_field_context(has_type: bool, has_request_type: bool, has_issue: bool) -> Result<Mode,
   ArityError>`. `has_project` is dropped from this function's signature entirely — the pure arity
   check is now solely about mode-selector COMBINATION validity (exactly one of `{--type,
   --request-type, --issue}`), exactly as D1's own framing requires. This function no longer knows
   `--project` exists.
2. **Step 2 — M2 project resolution, new function, runs only after Step 1 selects M2.** Resolves
   the project as: the explicit `--project` flag value, OR the active profile/config default
   project (the identical source `Config`/`ProfileConfig` accessor BC-3.3.010's create-path
   project resolution and M3's optional-companion fallback already read — no new resolution
   mechanism is introduced, this reuses the existing one). If neither is available, M2 fails with
   the same exit-64 "incomplete-M2" error case (3) already documents — only the TRIGGER CONDITION
   changes (now: no flag AND no default, not merely no flag). This step reads only already-loaded
   in-process `Config` state — no HTTP call — so it stays inside the existing "arity guard
   evaluated before any HTTP call" contract for BC-X.14.001; it is simply not part of the *pure*
   arity function itself.
   - Purity: `resolve_field_context` (Step 1) remains pure core, now with a narrower 3-bool
     signature. The Step 2 resolver (e.g. `resolve_m2_project(cli_project: Option<&str>, config:
     &Config) -> Option<String>`) is ALSO pure core (deterministic given its explicit arguments, no
     I/O) — same purity class as the already-documented `config::validate_profile_name` carve-out —
     it is a distinct function from Step 1, not a widened Step 1.
3. **`has_project` semantics note — SUPERSEDED.** §1's "`has_project` note for the M2 arity
   check" paragraph no longer applies: there is no `has_project` parameter left to disambiguate.
   "Is `--project` present at all" (useful for M3's optional-companion UX, e.g. deciding whether to
   log which project was used) remains a legitimate question elsewhere in the command, but it plays
   no role in M2's arity validity — only in Step 2's resolution outcome.

**Why parity, not divergence.** There is no functional reason M2's createmeta call needs a project
id/key sourced differently than BC-3.3.010's createmeta call for `issue create --field`, or than
M3's requesttype-fields call — all three ultimately need "some project," and `jr` already has one
resolution rule for that (flag, else profile/config default). Requiring M2 alone to bypass the
default is an unmotivated inconsistency the adversary correctly flagged as a parity gap, not a
deliberate design choice worth preserving.

**Downstream implication for VP-580-006 (flagged for the verifier, not resolved here):**
VP-580-006's `resolve_field_context` proptest must be updated for the narrowed 3-bool pure
signature (drop the `has_project` axis entirely from that proptest's input space). A new,
separate verification target is needed for Step 2 — project resolution for M2 specifically,
covering `{--project flag present, profile default present, neither present} × M2-only`,
structurally mirroring whatever existing VP already covers BC-3.3.010's flag-or-default project
resolution on the create path (reuse that VP's shape/fixture pattern rather than inventing a new
one). This is a verifier-owned addition; not authored in this ADR.

### D2 (adversary B-F3) — create-path collision precedence

**Defect.** The create path (`jr issue create`) has no Gate B — BC-3.4.017's mutual-exclusion
guard is edit-only. `jr issue create --priority Medium --field priority:name=Medium` therefore
writes `fields.priority` via two independent, unordered sources: `--priority` and `--field` are
distinct clap arguments (clap preserves no relative argv order between two different flags), and
`parse_field_kv` returns an unordered `HashMap`. The current text ("LAST-WINS at the fields JSON
merge step... standard 'later flag wins' `jr` convention," BC-3.4.029 EC-3.4.029-2) describes an
outcome with no defined "later" — the actual behavior depends on unwritten merge-order code, and
two implementers could pick opposite orders while both satisfying the existing spec text.

**Decision: extend Gate B to the create path (option (a)), not a pinned precedence rule.**

Rejected the precedence-rule alternative (option (b) — e.g. "dedicated typed flag always wins,
`--field` silently ignored for that key," or vice versa) for two reasons: (1) it only relocates
the arbitrariness from "which merge order wins" to "which flag class is more authoritative" — still
a rule a user must discover and memorize, and jr has no existing convention of one flag class
silently overriding another for the same wire key; (2) for a state-changing command (issue
creation), silently discarding one of the user's two explicitly-supplied values for the same field
is a worse failure mode than rejecting the ambiguous invocation outright and telling the user which
flags conflicted — exactly the judgment `jr` already made for the identical collision class on
`issue edit` via Gate B. Mirroring Gate B on create removes the ambiguity structurally (there is no
"winner" to compute) rather than resolving it more cheaply but less safely.

**Concrete decision, mirroring BC-3.4.017's Gate B:**

- A new create-path guard, structurally identical in mechanism to `edit.rs`'s Gate B, runs on `jr
  issue create` BEFORE any HTTP call (same pre-HTTP convention Gate B and §1's mode-selector arity
  checks already follow).
- **Governed field set:** the same field set BC-3.4.017 governs at any given time (currently
  summary, description, issuetype/`--type`, priority, components), restricted to whichever of
  those exist as a dedicated flag on `issue create` — this is the SAME governing set, not a
  parallel list that could drift from Gate B's; if Gate B's field set grows, the create-path guard
  grows with it by construction. Exact enumeration against `issue create`'s current flag surface is
  confirmed by the product-owner/verifier at BC-propagation time, not hardcoded in this ADR.
- **Matching rule:** identical to Gate B's — a hint-tagged `--field NAME:kind=VALUE` pair is
  matched on its BARE NAME (BC-3.4.026's bare-key rule), so `--priority Medium --field
  priority:name=Medium` is caught exactly like the bare `--field priority=Medium` case,
  irrespective of which flag appears first on the command line — this is a set-intersection check
  over parsed inputs, not an ordered merge, so it is inherently argv-order-independent (closing the
  defect at its root, rather than picking a merge order).
- **Error convention:** exit 64, no HTTP call issued, same overlap-error message *shape* as Gate
  B's existing "cannot be combined with `--field`" text (the exact BC-body wording is the
  product-owner's call, not dictated here).
- **Architectural placement — shared logic, not a duplicate copy.** Extract Gate B's
  overlap-detection logic into one shared pure function (e.g.
  `field_resolve::detect_flag_field_overlap`, taking the already-parsed
  `HashMap<String, FieldValueSpec>` plus the set of dedicated-flag wire-keys the caller actually
  supplied, returning the overlapping key set) reused by both `edit.rs`'s Gate B and the new
  create-path guard — consistent with this ADR's existing reuse bias (§1's `AllowedValue`/
  `EditMetaFieldSchema` reuse; §2's single shared `FieldValueSpec`). This function is pure (a
  set-intersection over already-parsed data, no I/O) — same purity class as
  `cli::resolve_effective_limit`/`config::validate_profile_name` — and is an addition to the
  purity-boundary table in `architecture-delta-field-dx.md §4`.
- **Precise, deterministic, testable outcome (for the verifier's VP):** for `jr issue create` with
  any argv ordering of `--priority Medium` and `--field priority:name=Medium` (or any hint kind on
  the `--field` side, or any other governed-field pair) → exit 64; stderr overlap error naming the
  colliding field (e.g. `priority`); zero HTTP calls issued. Symmetric with EC-3.4.017-16's
  edit-path assertion — create and edit now share one behavior for this collision class instead of
  two.

**Downstream implication (flagged for the product-owner, not made here):** BC-3.4.029
EC-3.4.029-2 currently states the create-path counterpart is "no Gate B exists there — last-wins
applies" — this becomes false under this decision and must be rewritten to describe the new
create-path guard (exit 64, symmetric with edit), with a fresh EC number for the create-path case
and a corrected cross-reference from BC-3.4.017's own EC-3.4.017-16 note (which currently points to
EC-3.4.029-2 as "the create-path counterpart, no Gate B exists there"). BC-3.4.014's
precondition/error-taxonomy text ("no Gate B mutual-exclusion guard exists on create") needs the
same correction. The product-owner should reconcile `bc-3-issue-write.md`'s BC-3.4.014,
BC-3.4.017, and BC-3.4.029 together in one pass to avoid reintroducing the same contradiction this
finding closes.

### D3 (adversary B-F2) — cascading `>`-split multibyte safety

**Defect.** §3's confirmed `>` cascading split (`Parent>Child` → parent/child) is performed at the
CALL SITE (`field_resolve.rs` per §2, and the analogous point in `create.rs`'s platform-create
path), never inside `parse_field_kv`. BC-3.4.026's Unicode-scalar-safety MUST is explicitly scoped
to `parse_field_kv` steps 1-2 only — this new split site inherited neither that obligation nor a
no-panic proptest, reopening the FIX-F6-LRE-1 class of bug (`validate_duration` panicking on
multibyte input, fixed in #734): a naive implementation that locates the delimiter via a
char-iterator index (e.g. `value.chars().position(|c| c == '>')`) and then uses that index directly
as a byte offset for slicing (`&value[..idx]`) panics whenever a multibyte scalar precedes the
`>` in the parent segment (e.g. `--field 'cf:option=Pré>Bñ'`) — the same class of byte/char-index
conflation FIX-F6-LRE-1 remediated, via a different specific mechanism (there, a fixed
`len() - 1` byte offset from the string's end; here, a char-count used as a byte index).

**Decision: add an explicit, mandatory architectural obligation — use `str::split_once`, never
hand-rolled index arithmetic.**

- Every call site that performs the `>` cascading split MUST use `str::split_once('>')` (or,
  equivalently, `str::find('>')` followed by slicing exactly at the returned byte index — never
  `str::chars().position(...)` combined with direct slicing, and never a fixed-byte-offset
  computation of any kind). `split_once` is the specifically recommended idiom: it is the single
  standard-library call that both locates the delimiter and returns two guaranteed-valid `&str`
  slices, eliminating the entire char/byte-index-conflation bug class **by construction** rather
  than by an added runtime check — the general principle FIX-F6-LRE-1's own remediation established
  (`chars().next_back()` + exact UTF-8 byte-length slicing, letting a char-aware primitive own the
  boundary arithmetic instead of hand-rolling it).
- **Scope:** this obligation applies to every call site performing the `Parent>Child` split —
  currently `field_resolve.rs` (edit path) and the analogous point in `create.rs`'s platform-create
  path (BC-3.3.010) — per §2's existing "cascading composition is only implemented on the platform
  edit/create paths this cycle" framing. It does **not** apply to `parse_field_kv` itself
  (unchanged; already covered by BC-3.4.026's own MUST) and does **not** apply to JSM (`:option`
  cascading is not extended to JSM this cycle, per BC-3.8.008's amendment — there is no JSM call
  site to cover).
- **No-panic property test required.** A proptest over arbitrary UTF-8 input asserting the
  cascading split never panics, for every call site above — mirroring `validate_duration`'s
  FIX-F6-LRE-1 proptest and the existing `parse_field_kv_proptests` precedent. Flagged for the
  verifier to add (extending or sibling to VP-578-008); not authored in this ADR.
- **Why name one specific idiom instead of a looser "must be Unicode-scalar-safe" instruction:**
  discretion over exactly how to implement boundary-safe splitting is the precise axis on which
  FIX-F6-LRE-1 was introduced in the first place. Naming `split_once` removes that discretion
  rather than trusting each future call site to independently rediscover the same safe pattern.

### F-B (adversary completeness pass) — degenerate option entry: `FieldOption.id`/`.label` become `Option<String>`, entries are never dropped

**Defect.** §1's normalizer contract (`normalize_from_allowed_values` for M1/M2,
`normalize_from_valid_values` for M3) and VP-580-005 §2 both require the normalizer to "tolerate
arbitrary `serde_json::Value` items without panicking … never unwrap a missing field," but neither
this ADR nor any BC/VP text specifies what `id`/`label` a source entry with a genuinely **missing**
`id` or `label`/`value` receives once normalized into `FieldOption { id: String, label: String,
children: Vec<FieldOption> }` (both currently non-optional, §"Why does the normalization component
belong in `cli/field.rs`" above). This is a real, not hypothetical, input: a GDPR-restricted
user-picker option or a config-broken option can arrive in `allowedValues`/`validValues` lacking
`id` or `label` — the input type itself already models this
(`types::jira::editmeta::AllowedValue.id: Option<String>`, `.value: Option<String>`,
`src/types/jira/editmeta.rs`). The **write** path already has a defined answer for a missing `id`
on a *matched* entry (BC-3.4.016 EC / BC-3.3.011 EC: "no machine-readable id" → exit 64) — but the
**read**/enumeration path, whose entire purpose (#580) is *discoverability*, has none. Three
equally spec-conformant implementations are possible today: render `id: ""`, silently DROP the
entry (the opposite of discoverability), or substitute the label text as the id. This ADR decides
among them.

**Decision 1 — model shape: `Option<String>`, not `String` + sentinel.**

`FieldOption.id` and `FieldOption.label` both become `Option<String>`:

```rust
pub(crate) struct FieldOption {
    pub id: Option<String>,
    pub label: Option<String>,
    pub children: Vec<FieldOption>,   // unchanged — always present, possibly empty (EC-X.14.001-4)
}
```

- **Faithful translation of an already-optional input, not a new sentinel invented at this layer.**
  `AllowedValue.id`/`.value` are already `Option<String>` one layer below `FieldOption` — the
  normalizer's job is to carry that same absence through, not to invent a lossy encoding of it. A
  `""`-sentinel would be a SECOND representation of "absent" this codebase does not otherwise use
  for this exact "wire says the field is missing" concept.
- **Scripted-consumer correctness is the deciding weight.** #580's stated purpose is a caller
  piping `--output json` into `jq` to grab an id before `--field NAME:id=<id>`. A `.id`-keyed
  script MUST be able to distinguish "this option genuinely has no id" from "id happens to be an
  empty string" — Jira does not guarantee the latter never occurs legitimately, so an empty-string
  sentinel is ambiguous by construction; `null` (via `Option::None`) is the unambiguous, standard
  JSON/Rust idiom for absence and needs no second, out-of-band convention documented alongside it.
- **Churn is not a real cost here, unlike the general case the model-shape question warns about.**
  `src/cli/field.rs` does not exist in `src/` yet (F2 stage, per this ADR's own placement note) —
  there are no existing VP-580 rendering assertions to retrofit. VP-580-005's proptest and
  VP-580-008's rendering unit tests are written against this shape from their first draft, not
  migrated onto it later. The "touches every VP-580 rendering assertion" cost is real in general
  but zero in this specific case, which is why `Option<String>` — the objectively cleaner contract
  — is not merely preferred but essentially free to adopt now.
- **Rejected: `String` + pinned `""` sentinel.** Lower textual diff today, but (a) ambiguous to a
  `.id`-keyed scripted consumer without an additional documented rule, and once shipped as a public
  JSON contract that rule cannot be walked back without a breaking change — this is the cheapest
  point in the project's lifecycle (pre-F4, no code written) to make the stricter call; (b) it
  would require this codebase to newly document and test a sentinel convention it does not use
  elsewhere for "wire says absent" (contrast `AllowedValue.id` itself, and the existing
  `Option<String>` idiom used throughout `types::jira::`).

**Exact JSON shape.** No `#[serde(skip_serializing_if = "Option::is_none")]` on either field — the
key stays present with a JSON `null` value, exactly mirroring `children`'s own existing "always
present, never dropped/absent" contract (EC-X.14.001-4: "a non-cascading field always has
`children: []`, never `null`/absent" — the same *presence* discipline, applied to a different
per-field *value* state). A source entry missing `id` renders:
```json
{"id": null, "label": "Some Label", "children": []}
```
A source entry missing `label`/`value` renders:
```json
{"id": "10042", "label": null, "children": []}
```
A source entry missing both (the GDPR-restricted worst case) renders `{"id": null, "label": null,
"children": []}` — see the never-drop invariant immediately below for why this entry still appears
in the array at all rather than being silently absent from it.

**Decision 2 — never-drop invariant, and table-mode rendering.**

**Invariant (new, extends VP-580-005 §2's "never unwrap a missing field"):** both normalizers MUST
emit exactly one `FieldOption` for every source item they are given, regardless of which fields
that source item carries. A missing `id` and/or missing `label`/`value` degrades that entry's own
`id`/`label` field to `None` — it MUST NEVER cause the entry to be omitted from the returned
`Vec<FieldOption>`. Discoverability (#580's whole reason for existing) requires every enumerable
option to be shown, even one `jr` cannot fully identify; silently dropping it is strictly worse
than showing an entry the user can visually recognize as degenerate and follow up on (e.g. via `jr
field options --output json` cross-referenced against the resolved request-type/issue-type screen
directly in the Jira UI).

**Table-mode rendering** (reuses existing, not newly invented, glyphs/placeholders):
- **Missing `id`** → the ID column renders `NULL_GLYPH` (`"—"`) — the exact glyph and convention
  already established by `src/cli/issue/changelog.rs::NULL_GLYPH` and reused by `src/cli/user.rs`
  and `src/cli/requesttype.rs` for "this field is genuinely absent from the source data," not a new
  glyph invented for this command.
- **Missing `label`** → the Label column renders the literal string `"(unnamed)"`, deliberately
  distinct from `"—"` and from the sibling id's own rendering: an absent id is inert (nothing
  actionable for the user), but an absent label still names a real, selectable option — a
  distinguishing placeholder keeps the row visibly present and signals "resolve this one via its
  id," rather than reading as blank/nothing-there.
- **Rejected: fall back to `id` for a missing label.** Rejected because `id` may ALSO be missing on
  the same degenerate entry (the GDPR-restricted case) — a conditional fallback would then have
  nothing to fall back to, forcing a second-level fallback rule anyway. An unconditional, literal
  `"(unnamed)"` is simpler to specify and test (never depends on the sibling field's state) and
  never produces a confusing "label equals a bare numeric id" row.
- **JSON mode performs no substitution** — `null` stays `null`; the entire point of the
  `Option<String>` model shape is that a scripted consumer receives the real absence signal, not a
  human-rendered string standing in for it. The `"—"`/`"(unnamed)"` substitutions are a table-mode
  rendering concern only, applied at the point the `Vec<FieldOption>` is formatted for a terminal.

**Downstream implications (flagged for the product-owner and verifier, not made here):**
- **Product-owner, BC-X.14.001** (`FieldOption` contract, currently `id: String, label: String`):
  update to `id: Option<String>, label: Option<String>`; add the never-drop invariant as a new
  Invariant or a new Edge Case (e.g. EC-X.14.001-7, sibling to EC-X.14.001-4's "`children` always
  present" contract) documenting the degenerate-entry case explicitly.
- **Product-owner, BC-X.14.003** (table/JSON rendering): add the pinned `"—"` (missing id) /
  `"(unnamed)"` (missing label) rendering strings to Behavior/Postconditions; VP-580-008 needs a
  companion assertion for these two cases (currently VP-580-008 only covers the happy-path
  two-column shape and cascading-indentation rendering).
- **Product-owner, BC-X.14.004**: consider a worked edge case citing the GDPR-restricted /
  config-broken option scenario as the motivating example, cross-referencing this decision.
- **Verifier, VP-580-005 §2**: currently asserts only "no panic … tolerates arbitrary
  `serde_json::Value` … never unwraps a missing field." This must be strengthened to also assert
  (a) **entry presence** — a source item missing `id` and/or `label`/`value` still yields exactly
  one `FieldOption` in the output `Vec` (never fewer entries than source items), not merely "does
  not panic"; (b) the exact `Option::None` → JSON `null` shape (not `""`, not an omitted key); and
  (c) as an integration-level companion, the pinned table-rendering strings (`"—"`, `"(unnamed)"`)
  for a fixture item missing id/label respectively. "No panic" alone, as currently worded, is
  satisfied by an implementation that silently filters the degenerate entry out of the `Vec` before
  returning it — that must be closed off explicitly, not left implied.

### D4 (adversary F-2) — cascading `>`-split × field-schema-type matrix: non-cascading-field collision, and bare-form `>`-literal asymmetry

**Defect.** §3/D3 confirm the `Parent>Child` split is performed unconditionally at each `:option`
call site (`field_resolve.rs` edit path; `create.rs` platform-create path) via `str::split_once('>')`,
but two cells of the split × field-schema-type matrix are undefined:

- **(a) `--field cf:option=A>B` where `cf` is a PLAIN (non-cascading) single-select `option` field**
  (`schema.type == "option"`, never `"option-with-child"`). If the split is unconditional (as D3
  requires), parent segment `"A"` may legitimately resolve against that field's
  `allowedValues[].value` — but a non-cascading entry has no children to resolve `"B"` against.
  EC-3.4.027-3's existing "resolvable parent, unresolvable child → exit 64 listing that parent's
  allowed child values" shape degenerates into a confusing empty-list message here (there are no
  "allowed child values" to list — the field isn't cascading at all), and neither this ADR nor
  BC-3.4.027 names a distinct error for this cell.
- **(b) bare `--field cf=Parent>Child` on a CASCADING field.** BC-3.4.015/BC-3.4.016 (bare-form
  dispatch) predate cascading and are pinned UNCHANGED by BC-3.4.016's own text — implying the bare
  form cannot set a cascading child. But whether `>` is literal in the bare form (vs. silently
  split the same way `:option` does) is nowhere stated. This asymmetry (only `:option` splits `>`)
  is real either way; the defect is that it is undocumented, not that either answer is wrong.

**Decision for (a): the split stays UNCONDITIONAL (confirms D3); the non-cascading case is detected
during `allowedValues` resolution, not by the parser inspecting `schema.type`.**

- The call site (`field_resolve.rs`, `create.rs`) does not change: it still performs
  `str::split_once('>')` on the raw `VALUE` with no awareness of the field's schema type — D3's
  "the split is call-site/composer-level" framing is preserved exactly. The parser/composer layer
  remains schema-agnostic by construction; it never needs to know `schema.type` at all.
- The distinguishing signal is **structural, not a schema.type lookup**: whether the matched
  parent's `children` collection is empty. This is read at the SAME point EC-3.4.027-3's existing
  "unresolvable child" check already inspects `children` — a new branch inserted alongside that
  check, not a second resolution pass or a new dependency on `EditMetaField.schema.field_type`.
- **Type-level prerequisite (implicit in §3 already, made explicit here):** resolving a cascading
  child at all requires the write-path `AllowedValue` type
  (`src/types/jira/editmeta.rs::AllowedValue`, currently `{id, value, name}` only — verified against
  the as-built struct, no `children` field exists there yet) to gain a `children` field. This ADR
  pins its shape: `#[serde(default)] pub children: Vec<AllowedValue>` — **`Vec`, not
  `Option<Vec<AllowedValue>>`.** This deliberately differs from F-B's `Option<String>` choice for
  `FieldOption.id`/`.label`: there, wire-absence was a MEANINGFUL distinct state from
  wire-present-but-empty (a genuinely missing identifier vs. an empty string), so `Option` carried
  real information. Here, Jira omitting the `children` key entirely vs. sending `"children": []`
  carry the IDENTICAL semantic — "this option has no cascading children" — so collapsing both into
  an empty `Vec` via `#[serde(default)]` loses no information and avoids inventing a meaningless
  `None`-vs-`Some(vec![])` distinction no caller would ever need to branch on. This mirrors
  `FieldOption.children: Vec<FieldOption>`'s own "always present, possibly empty" contract
  (EC-X.14.001-4) on the read-path sibling type — same presence discipline, applied to the
  write-path type that already implicitly needed it for BC-3.4.027's happy path to be resolvable at
  all.
- **Error condition:** child segment present (non-empty, per EC-3.4.027-6's existing empty-segment
  handling) AND parent segment resolves successfully AND the matched parent's `children` is empty →
  exit 64 with a NEW, distinct message — sibling to, not a reuse or widening of, EC-3.4.027-2
  (unresolvable parent) or EC-3.4.027-3 (resolvable parent, unresolvable child on an ACTUALLY
  cascading field).
- **Exact message shape (VP-assertable, mirrors EC-3.4.016-8's pinned-substring precedent):**
  ```
  field '<NAME>' is not a cascading select — remove the '>Child' segment from the value.
  ```
  Load-bearing substrings for a VP to assert (not the full literal, per this project's existing
  pinned-substring convention): `"is not a cascading select"` and `"remove the"`. `<NAME>` is the
  same resolved field name/label already used in this call site's other error messages (consistent
  with EC-3.4.016-2/3/8's existing `<NAME>`-in-message convention).
- **Why not reuse EC-3.4.027-3's shape with an empty list:** an exit-64 message that says "allowed
  child values: " with nothing after the colon names the wrong problem — it implies the user chose
  an invalid child value, when the actual problem is that the field cannot take a child value at
  all. Naming the real problem (not a cascading select) gives the user the correct next action
  (drop the `>Child` segment, or discover the field's real values via `jr field options`) instead of
  an empty enumeration that looks like a bug.

**Decision for (b): the bare form does NOT split on `>` — `>` is a literal character in the bare
value. This is now a STATED contract, not an accident.**

- Scope confirmation: D3's own "Scope" bullet already restricts the `str::split_once('>')`
  obligation to the two named `:option`-hint call sites and explicitly excludes `parse_field_kv`
  (the bare-form parser) — this decision does not change that scope, it removes the remaining
  ambiguity about what happens INSTEAD at the bare-form dispatch point (BC-3.4.016's existing,
  unmodified resolution path).
- **Consequence, not a new code path:** because the bare form never splits, a bare
  `--field cf=Parent>Child` against a cascading field is resolved exactly as BC-3.4.016 already
  resolves any bare value — the ENTIRE string `"Parent>Child"` is matched as one opaque candidate
  against `allowedValues[].value`. Since a cascading parent's own `.value` never itself contains a
  literal `>` in ordinary use, this whole-string match fails and falls through to the EXISTING
  EC-3.4.016-2 "unresolvable value, list allowed values" error — no new error path is introduced for
  cell (b); it is the ordinary bare-form mismatch case, reached because the bare form treats `>` as
  just another character in the candidate string.
- **Consequence for setting a cascading child:** a cascading field's child value can ONLY be set via
  the explicit `--field cf:option=Parent>Child` form (BC-3.4.027) — this closes the open question
  BC-3.4.016's "predates cascading, unchanged" framing left implicit. There is no bare-form path to
  a cascading child, by design, not by oversight.
- **Why this is the right default (not merely the cheaper one):** the bare form's whole-contract is
  "one opaque display-value candidate, whatever it contains" — BC-3.4.016 Invariant coverage
  (case-insensitive exact/substring match) never special-cases any character in `VALUE` today. Making
  the bare form `>`-aware would be a silent, hint-independent behavior change to a dispatch path this
  bundle's own scoping (§2, §3) deliberately keeps untouched; asymmetry between "explicit hint splits,
  bare form doesn't" is the same shape as `:id`/`:name` bypassing lookup entirely while the bare form
  performs it (BC-3.4.028/029 Invariant 1 vs. BC-3.4.016) — `jr`'s hint syntax already establishes
  the convention that opting into a hint changes parsing behavior the bare form does not share.

**Downstream implications (flagged for the product-owner and verifier, not made here):**

- **Product-owner, BC-3.4.027:** add a new Edge Case (e.g. EC-3.4.027-7, sibling to EC-3.4.027-2/3,
  NOT a widening of either) documenting cell (a)'s trigger condition and the exact pinned message
  substrings above; update Postconditions/Invariants to reference the `children`-empty structural
  detection rule (no `schema.type` inspection required) and the `AllowedValue.children:
  Vec<AllowedValue>` (`#[serde(default)]`) type extension this decision pins.
- **Product-owner, BC-3.4.015:** add a note near the bare-form dispatch text (or as a new Edge Case
  sibling to EC-3.4.015-9/10/11) stating explicitly that `>` is a literal character in the bare
  form — no split is ever attempted — cross-referencing BC-3.4.027 EC-3.4.027-7 and this ADR's D4 so
  the platform bare-vs-`:option` asymmetry is a stated contract at the bare-form BC's own site, not
  discoverable only from BC-3.4.027's text.
- **Verifier:** a new/extended VP (sibling to VP-578-008) asserting (i) cell (a)'s exact error
  message substrings (`"is not a cascading select"`, `"remove the"`) on a plain (non-cascading)
  `option` field whose `VALUE` contains a `>` where the parent segment resolves successfully; (ii)
  cell (b)'s bare-form-treats-`>`-as-literal behavior — a wiremock/fixture assertion that bare
  `--field cf=Parent>Child` against a cascading field never attempts a split and instead falls
  through to the existing EC-3.4.016-2 unresolvable-value error shape.

## Source / Origin

- F1 delta analysis: `.factory/phase-f1-delta-analysis/delta-analysis-field-dx.md` (§3
  Architecture Verdict, §5 Recommended Scope — the three open-question list this ADR resolves).
- F2 PRD delta (product-owner): `.factory/phase-f2-spec-evolution/prd-delta-field-dx.md`
  ("Decisions made to resolve F1's open design questions" §1, §3; "Open design questions — NOT
  resolved here" §1, §3).
- Research: `.factory/research/field-dx-context-mechanism-2026-08-25.md` (ranked recommendation,
  per-mechanism verdict table, Q-A/Q-B graceful-degradation findings).
- Behavioral contracts: `bc-3-issue-write.md` (BC-3.3.010/011, BC-3.4.026-031, BC-3.8.008
  amendment, BC-3.8.012 reversal — governance-flagged separately as DEC-310 (renumbered from the
  initially-proposed DEC-307, which was already cycle-001's), not an architecture decision this
  ADR covers); `cross-cutting.md` §X.14 (BC-X.14.001-004).
- Structural precedent code (as-built, cited for pattern only — not yet extended by this
  bundle): `src/api/jira/issues.rs::get_issue_types_for_project` + its inline
  `IssueTypeEntry`/`CreatemetaIssueTypesResponse` types (createmeta-family, in-file-type
  precedent); `src/types/jira/editmeta.rs::{AllowedValue, EditMetaFieldSchema}` (reused, not
  duplicated); `src/cli/issue/create.rs::parse_field_kv` (function being extended);
  `src/cli/issue/field_resolve.rs::resolve_edit_fields` (BC-3.4.015/016 dispatch, gains
  hinted-bypass branch); `src/api/jsm/requests.rs::JsmRequestBuilder::build` (`extra_fields`
  loop, gains kind-aware dispatch); `src/cli/requesttype.rs` (structural mirror for the new
  `field.rs` module, per F1 §3).
- Related ADRs: ADR-0012 (module shard rule — governs the edit.rs no-shard-this-cycle
  recommendation); ADR-0014 (JSM request-type dispatch fork — direct structural precedent for
  `jr field options`'s exactly-one-context-flag pattern); ADR-0018 (component resolution/caching/
  mutation strategy — sibling precedent for one ADR covering a multi-facet feature bundle).
- **Amendment (2026-08-26) sources:** F2 mandatory adversarial spec-convergence loop, three
  fresh-context adversary passes against the frozen `architecture-delta-field-dx.md`/
  `prd-delta-field-dx.md`/`verification-delta-field-dx.md` (findings cited as adversary MEDIUM-1,
  B-F3, B-F2 in the orchestrator's task brief to this ADR's amendment burst; no separate
  adversary-pass artifact file exists on disk for this round at time of writing — findings were
  relayed directly, not read from a `.factory/phase-f2-spec-evolution/adversarial-*field-dx*`
  file). FIX-F6-LRE-1 precedent (D3): commit `37850b26` (#734), `src/jql.rs::validate_duration`,
  documented in the project root `CLAUDE.md` "Gotchas"-adjacent commit history line. Existing
  contradiction closed by D2: `bc-3-issue-write.md` BC-3.4.017 EC-3.4.017-16 / BC-3.4.029
  EC-3.4.029-2 (the "adversary pass-13 F-1" cross-reference already present in both ECs, which
  this amendment's D2 further corrects by removing the create-path asymmetry those ECs currently
  describe).
- **F-B (adversary completeness pass) source:** the `.factory/phase-f2-spec-evolution/
  verification-delta-field-dx.md`-declared **VP-580-005** §2 text ("tolerate arbitrary
  `serde_json::Value` items without panicking … never unwrap a missing field") and this ADR's own
  §1 Rationale (the `{id, label, children}` normalized model) — the finding was relayed directly by
  the orchestrator's task brief for this amendment burst, labeled `F-B`; no separate adversary-pass
  artifact file exists on disk for it at time of writing, same disclosure as D1/D2/D3 above.
  Write-path precedent cited: BC-3.4.016 EC / BC-3.3.011 EC ("no machine-readable id" → exit 64 on
  a matched entry with `id: None`). Input-type precedent cited: `types::jira::editmeta::AllowedValue
  { id: Option<String>, value: Option<String>, name: Option<String> }` (`src/types/jira/editmeta.rs`).
- **D4 (adversary completeness+correctness pass) source:** relayed directly by the orchestrator's
  task brief for this amendment burst, labeled `F-2`; no separate adversary-pass artifact file
  exists on disk for it at time of writing, same disclosure as D1/D2/D3/F-B above. Defect surface
  cited: §3's confirmed cascading split (D3's `str::split_once('>')` MUST) crossed against
  BC-3.4.016's Preconditions ("`schema.type == \"option\"`" — plain, non-cascading — is an equally
  valid dispatch target for `:option` per BC-3.4.027's own Preconditions, "Same as BC-3.4.016...
  `schema.type == \"option\"` or `\"option-with-child\"`"). EC-3.4.027-3 precedent cited for the
  shape D4 deliberately does NOT reuse for cell (a). `types::jira::editmeta::AllowedValue`
  (`src/types/jira/editmeta.rs`, verified as-built to currently carry no `children` field) is the
  type D4 pins the `#[serde(default)] Vec<AllowedValue>` extension on. FIX-F6-LRE-1 precedent
  (same as D3): commit `37850b26` (#734), `src/jql.rs::validate_duration`.
  Table-rendering precedent cited: `src/cli/issue/changelog.rs::NULL_GLYPH` (`"—"`), reused by
  `src/cli/user.rs` and `src/cli/requesttype.rs`.
