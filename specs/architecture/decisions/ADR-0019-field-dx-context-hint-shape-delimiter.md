---
document_type: adr
adr_id: ADR-0019
status: Accepted
date: 2026-08-25
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

> **NOTE — factory-artifact placement, not yet an F4 code artifact:** This ADR governs
> `src/cli/field.rs` (new), an extension to `src/api/jira/issues.rs`, and the `parse_field_kv`
> signature in `src/cli/issue/create.rs` — none of which exist in this shape in `src/` as of
> this writing (F2). The corresponding product-repo ADR file under `docs/adr/` is an **F4 story
> deliverable**, created in a worktree via PR when Wave 1/2 implementation lands — it is NOT
> created here. This factory artifact at
> `.factory/specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md` is
> the sole ADR-0019 record until F4 promotes it into `docs/adr/`.

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
- **`has_project` note for the M2 arity check:** where implementation or test code refers to a
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

## Source / Origin

- F1 delta analysis: `.factory/phase-f1-delta-analysis/delta-analysis-field-dx.md` (§3
  Architecture Verdict, §5 Recommended Scope — the three open-question list this ADR resolves).
- F2 PRD delta (product-owner): `.factory/phase-f2-spec-evolution/prd-delta-field-dx.md`
  ("Decisions made to resolve F1's open design questions" §1, §3; "Open design questions — NOT
  resolved here" §1, §3).
- Research: `.factory/research/field-dx-context-mechanism-2026-08-25.md` (ranked recommendation,
  per-mechanism verdict table, Q-A/Q-B graceful-degradation findings).
- Behavioral contracts: `bc-3-issue-write.md` (BC-3.3.010/011, BC-3.4.026-031, BC-3.8.008
  amendment, BC-3.8.012 reversal — governance-flagged separately as DEC-307, not an architecture
  decision this ADR covers); `cross-cutting.md` §X.14 (BC-X.14.001-004).
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
