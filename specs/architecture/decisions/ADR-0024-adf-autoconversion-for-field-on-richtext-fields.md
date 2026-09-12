---
document_type: adr
adr_id: ADR-0024
status: proposed
date: 2026-09-12
subsystems_affected: ["SS-02", "SS-04", "SS-05", "SS-08"]
supersedes: null
superseded_by: null
related: ["ADR-0014", "ADR-0019", "ADR-0023"]
---

# ADR-0024: ADF Auto-Conversion for `--field` on Rich-Text Fields — Allowlist Predicate, Shared Helper, and Empty-Value Semantics

## Context

`jr issue edit --field NAME=VALUE`, `jr issue create --field NAME=VALUE`, and
`jr issue create --request-type RT --field NAME=VALUE` (JSM create path) all send
the field value as a plain JSON string for `schema.type == "string"` fields. Jira
Cloud REST API v3 requires an Atlassian Document Format (ADF) object on write for
`environment`, `description` (when accessed via `--field`, not `--description`), and
any custom field whose plugin type ends with `:textarea`. Sending a plain string to
these fields results in a guaranteed `400 API error: Operation value must be an
Atlassian Document Format`. This error was pre-existing and confirmed on both the
platform edit path and the JSM create path (see JRACLOUD-75814 for the underlying
API constraint; `.factory/research/e2e-environment-adf-field-2026-09-11.md` for the
live evidence; cycle-012 F1 delta analysis v4 §O5 for the behavior-flip impact).

A critical question — "is there a generic `schema.type`-level discriminator that
distinguishes ADF-backed string fields from plain-string fields?" — was investigated
in detail across two live probes (`.factory/research/createmeta-schema-probe-2026-09-12.md`;
`.factory/research/jsm-requesttype-fields-adf-probe-2026-09-12.md`). The answer is
**no**: both `environment` (ADF-backed) and `summary` (plain string) report
`type == "string"` in both `createmeta` and `editmeta` responses, and both
`description` (ADF-backed) and `summary` (plain string) report `type == "string"` in
JSM's `requesttype/field` response. There is no `isADF`, `renderedType`, or
`jsonType` discriminator field — the only reliable signal is the `schema.system`
and `schema.custom` (plugin type) keys, which form an explicit allowlist (see
JRACLOUD-75814 — Atlassian's documentation enumerates the ADF-required fields by
name, not by a generic capability flag). The architecture must therefore hardcode
an allowlist predicate.

The JSM create path uses a wrapper key `jiraSchema` instead of `schema` for the
field metadata, but the inner sub-keys (`type`, `system`, `custom`, `customId`,
`items`) are structurally identical (confirmed by live JSM probe). This architectural
symmetry enables a shared inner predicate.

There is an open interaction between this feature and the empty-value case: calling
`text_to_adf("")` produces an empty `text` node (`{"type":"text","text":""}`) which
Jira rejects with a 400 (JRACLOUD-79318). Empty values must be handled before
reaching `text_to_adf`, and the correct behavior differs by operation type:
`PUT` (edit) should CLEAR the field using the empty ADF doc
(`{"type":"doc","version":1,"content":[]}`), while `POST` (create, including JSM
create) should OMIT the field entirely.

There is also an interaction with the `--markdown` flag: `--description --markdown`
is the existing markdown-to-ADF channel (ADR-0023). This cycle deliberately
restricts `--field ADF_FIELD=VALUE` to plain-text conversion only; the `:markdown`
hint form is out of scope and deferred.

Finally, the JSM path's `JsmRequestBuilder::build()` currently sets
`isAdfRequest: true` only when `self.description` is `Some`. After this feature, any
ADF value in `requestFieldValues` (including extra fields) requires `isAdfRequest:
true`. The RESOLUTION LAYER (`jsm_create.rs`) must accumulate this flag for each
converted extra field and pass it to `build()`; `build()` reflects the flag rather
than recomputing it from value types.

## Decision

We will introduce a single shared `is_adf_field` predicate (in
`src/cli/issue/field_resolve.rs`) that returns `true` IFF the field's inner schema
object satisfies:

```
schema.system.as_deref() == Some("description")
    OR schema.system.as_deref() == Some("environment")
    OR schema.custom.as_deref().map_or(false, |c| c.ends_with(":textarea"))
```

This predicate will be called from three dispatch sites:

1. `dispatch_field_value` (platform edit + create path (shared `dispatch_field_value`), `src/cli/issue/field_resolve.rs`) —
   when the predicate fires on a non-empty value, the wire value is
   `text_to_adf(&value)` (plain-text conversion, NOT markdown).
2. `resolve_against_editmeta` (platform edit empty-value pre-check) — when the
   predicate fires on an empty/whitespace value, inject
   `{"type":"doc","version":1,"content":[]}` directly and skip `dispatch_field_value`.
3. `resolve_against_createmeta` (platform create empty-value pre-check) — when the
   predicate fires on an empty/whitespace value, skip the field entirely (omit from
   POST body).

A thin `is_adf_field_value(schema: &serde_json::Value) -> bool` wrapper will be
introduced in `src/cli/issue/field_resolve.rs`, alongside `is_adf_field` and the
private `is_adf_schema` core. Placing all three functions in one module keeps every
allowlist caller co-located: `is_adf_schema` remains a module-private `fn` (no
`pub(crate)` needed) since both `is_adf_field` and `is_adf_field_value` live in the
same file and no caller outside `field_resolve.rs` calls `is_adf_schema` directly.
`is_adf_field`, likewise, is only called from within `field_resolve.rs` and can remain
module-private. `is_adf_field_value`, by contrast, IS called from
`src/cli/issue/jsm_create.rs` (a sibling file in the `cli/issue/` module) and MUST be
declared at least `pub(super)` (or `pub(crate)`); it cannot remain `fn`-private (OBS-3).
`is_adf_field_value` receives `&RequestTypeField.jira_schema` DIRECTLY and delegates
to `is_adf_schema`, enforcing AC-008 (shared detection, route-specific empty-value
handling).

**Canonical jiraSchema contract:** `RequestTypeField.jira_schema` (Rust serde field
`jira_schema`, deserialized from JSON key `jiraSchema` via `rename_all = "camelCase"`)
IS already the inner schema block — its value is a `serde_json::Value` whose
top-level keys are `type`, `system`, `custom`, `customId`, `items`, etc. There is NO
additional `["jiraSchema"]` extraction step. `is_adf_field_value` receives
`&rt_field.jira_schema` as-is; `rt_field.jira_schema["custom"]` accesses the `custom`
key directly. The call `&rt_field.jira_schema["jiraSchema"]` would be a phantom
double-nesting that always resolves to `Value::Null`, silently breaking detection and
reintroducing the 400. Implementations MUST NOT add this extra extraction level.

The JSM path's empty-value case uses create-omit semantics (same as platform create:
field omitted from `requestFieldValues`).

The JSM path will additionally accumulate `is_adf_request |= true` whenever any
extra field is ADF-converted, ensuring `isAdfRequest: true` appears in the POST
body regardless of whether `self.description` is `Some`.

**Plain-text conversion only this cycle.** `text_to_adf` (the same function used by
`--description` without `--markdown`) is the conversion mechanism. The `:markdown`
hint form for `--field` (which would invoke `markdown_to_adf`) is explicitly
out-of-scope for cycle-012 and deferred to a future cycle.

**DQ-6 (deferred F4 decision — type/signature shape only).** ADF detection,
`text_to_adf` conversion, and the metadata-unavailable `warning:` emission are
RESOLUTION-LAYER concerns — they belong in the effectful layer that has access to
`RequestTypeField` metadata (`jsm_create.rs`), not in the pure `build()` assembler.

**The layer question is SETTLED.** `isAdfRequest` (for the `--field` extra-field
contribution) is ALWAYS a pre-computed boolean produced in `jsm_create.rs` (the
resolution layer) and passed to `build()` as an explicit bool input. `build()` NEVER
receives `rt_fields: &[RequestTypeField]` and NEVER derives the flag by inspecting
the types of `requestFieldValues` entries.

**INVARIANT (scoped to the `--field` EXTRA-FIELD path introduced by cycle-012):**
ADF DETECTION, CONVERSION, EMPTY-OMIT, AND `warning:` EMISSION for `--field` extra
fields are ALWAYS `jsm_create.rs` (resolution-layer) responsibilities; `build()`
is a pure assembler that reflects the pre-computed `isAdfRequest` flag it receives
and assembles the POST body. EXEMPT from this invariant: the pre-existing
`self.description` ADF conversion via `adf::text_to_adf` /
`adf::markdown_to_adf_*` in `src/api/jsm/requests.rs::JsmRequestBuilder::build`
§ the `self.description` ADF-conversion block (BC-3.8.006) remains in `build()`
and is NOT touched by cycle-012 — cycle-012 leaves that channel unchanged.

The SOLE remaining DQ-6 open question is the TYPE/SIGNATURE shape for carrying the
already-converted ADF `serde_json::Value` for an extra field into `build()`'s
`requestFieldValues`:
(a) widen `FieldValueSpec.value` from `String` to `serde_json::Value`; or
(b) a parallel resolved-ADF-values map alongside the existing spec vector.
Either option requires a TYPE/SIGNATURE change. This plumbing decision is deferred
to F4. The observable postconditions (detection, conversion, flag accumulation,
empty-omit, warning) are fixed by the BCs and VP-FIELD-ADF-004; only the internal
plumbing shape differs between options (a) and (b).

**Hint kinds opt out of ADF on both platform and JSM paths — no platform/JSM
divergence.** The ADF auto-conversion branch fires ONLY when `spec.kind.is_none()`
(the bare `NAME=VALUE` form). A hinted value — `NAME:option=VALUE`, `NAME:id=VALUE`,
`NAME:name=VALUE`, `NAME:asset=VALUE` — routes to its hint composer and bypasses the
ADF branch entirely on both the platform edit/create path and the JSM create path.
Hinted kinds are an explicit type-override by the caller, opting into a specific wire
format; ADF auto-conversion must not interfere with that choice. The empty-value
pre-check inherits this gate: it fires only when `spec.kind.is_none()` (an empty
hinted value is the hint composer's responsibility, not the ADF guard's). The
product-owner must state the `kind.is_none()` precondition explicitly in
BC-3.8.019/BC-3.8.020 (JSM ADF detection) and in the empty-guard BCs
(BC-3.4.036, BC-3.3.015, BC-3.8.021).

## Rationale

**Allowlist over structural discriminator — required by API design (JRACLOUD-75814).**
Jira Cloud's field metadata does not expose an "is ADF required" flag. Both ADF-backed
(`description`, `environment`) and plain-string (`summary`) fields report
`schema.type == "string"`. The only way to distinguish them is the allowlist approach:
`schema.system` names the two system-level ADF fields explicitly, and
`schema.custom` names the plugin type (`:textarea` vs `:textfield`). Any approach
keyed on `schema.type` alone would produce false positives (converting `summary` to
ADF, guaranteed 400) or false negatives (missing a `:textarea` field, leaving the
400 unfixed). The allowlist is therefore not a "soft heuristic" but the API-enforced
discrimination boundary, as confirmed by both live probes and Atlassian documentation.

**Shared helper — AC-008 compliance.** The core predicate logic must not be
duplicated across the platform and JSM paths. The platform path uses `schema` typed
as `EditMetaFieldSchema` (a Rust struct). The JSM path uses `RequestTypeField.jira_schema`,
a `serde_json::Value` that IS already the inner schema block (see canonical contract
above — the JSON key `jiraSchema` is consumed by serde deserialization into the
`jira_schema` field; no sub-extraction is needed).

The solution is a named shared core predicate defined in
`src/cli/issue/field_resolve.rs`:

```rust
fn is_adf_schema(system: Option<&str>, custom: Option<&str>) -> bool
```

This function contains the three-arm allowlist exclusively. Two typed entry points
delegate to it:

- `is_adf_field(&EditMetaFieldSchema)` — extracts `schema.system.as_deref()` and
  `schema.custom.as_deref()` from the typed struct, then calls `is_adf_schema`.
- `is_adf_field_value(&serde_json::Value)` in `src/cli/issue/field_resolve.rs` —
  extracts `value["system"].as_str()` and `value["custom"].as_str()` from the untyped
  Value, then calls `is_adf_schema`.

Neither entry point contains the allowlist logic itself. A future allowlist extension
is a one-line change inside `is_adf_schema` only, and VP-FIELD-ADF-001's proptest is
transitively effective for both entry points because both call `is_adf_schema` for the
actual allowlist decision.

**Why a "thin wrapper" over `is_adf_field` is not literally realizable here:**
`is_adf_field` accepts `&EditMetaFieldSchema`, whose `field_type` is a non-Option
`String`. The JSM `jira_schema` `serde_json::Value` may lack a `type` key entirely.
A delegation via deserialization would silently treat absent keys as empty strings
rather than `None`, diverging from the typed path's semantics. The named shared core
`is_adf_schema(Option<&str>, Option<&str>)` is the only shape that both entry points
can delegate to faithfully. This preserves the single-point-of-truth invariant.

**Empty-value semantics asymmetry — required by Jira API contract.** The edit
(`PUT`) and create (`POST`) paths have different empty-value contracts:
- On edit, an absent field value in the payload means "do not change this field"
  — to actively CLEAR a rich-text field, the correct wire form is the empty ADF
  doc `{"type":"doc","version":1,"content":[]}`, not an absent field.
- On create (platform and JSM), an absent field means "use the default or leave
  unset" — the correct wire form for "I don't want to set this field" is to omit
  it from the body entirely. An empty ADF doc in a create body may produce a
  validation error or an empty-doc stored unnecessarily.
- In both cases, sending `text_to_adf("")` (which produces an empty `text` node) is
  wrong and produces a 400 (JRACLOUD-79318). The pre-check must intercept before
  `text_to_adf` is called.
The asymmetry is encoded at the route-specific call sites (`resolve_against_editmeta`
and `resolve_against_createmeta`) rather than inside `dispatch_field_value`, because
`dispatch_field_value` has no create-vs-edit context.

**`--field description=X` is load-bearing.** Using `--field description=VALUE`
without the `--description` flag is a reachable and legitimate path (M3 in the F1
delta analysis). Gate B in `handle_edit` excludes `description` from the `--field`
collision check (it only blocks `--description` + `--field description=` together,
not `--field description=` alone). The ADF conversion must fire on this path or
the 400 persists. The same applies on the JSM create path.

**`--field environment=X` behavior flip.** Before this change, `--field
environment=VALUE` always returns a 400 ("Operation value must be an Atlassian
Document"). After this change, the same command succeeds with an ADF payload. This
is the correct behavior — the 400 was the bug. The CHANGELOG must note this
behavioral change as it flips a previously-failing path to success (cycle-012 O5,
F1 delta analysis v4).

**Confirmed vs inferred residuals from the probes.** The probes confirmed:
- `description` system field: ADF-required, confirmed on both platform
  `editmeta`/`createmeta` and JSM `requesttype/field`.
- `environment` system field: ADF-required on platform; confirmed absent from JSM
  request types in the test instance (inferred: same ADF requirement if present,
  following the same `schema.system` predicate logic).
- `:textarea` custom field: ADF-required on platform edit/create; no such field
  exists in the test instance's JSM request types (inferred from platform
  cross-path parity, HIGH confidence). Story 2 F4 live confirmation (AC-13 /
  JSM-AC-7) will resolve the residual.

**`isAdfRequest` accumulation rule.** The JSM API requires `isAdfRequest: true` in
the POST body whenever ANY value in `requestFieldValues` is an ADF object. The
existing code sets this flag only when `self.description is Some`. That was correct
before this feature (extra fields were never ADF). After this feature, the RESOLUTION
LAYER in `jsm_create.rs` accumulates the flag: for each ADF-backed non-empty extra
field it processes, it sets `is_adf_request |= true`, then passes the flag (alongside
the converted values) to `build()`. `build()` receives the flag as an explicit input
and reflects it in the POST body — it never inspects the type of `requestFieldValues`
entries to determine if `isAdfRequest` should be set. This reflect-only model keeps
`build()` a pure assembler and avoids the collision where hinted `:id`/`:name` extra
fields (which produce JSON objects) or `:asset` extra fields (which produce arrays)
would be falsely treated as ADF by a naive `is_object()` check on the assembled
values (finding I-2).

## Consequences

### Positive

- `jr issue edit --field environment=VALUE`, `--field description=VALUE` (via
  `--field` alone), and `--field TEXTAREA_FIELD=VALUE` succeed with ADF payloads
  where they previously returned a guaranteed 400. This unblocks the
  `test_e2e_issue_edit_custom_field` test that currently fails on `develop`.
- `jr issue create --request-type RT --field description=VALUE` via the generic
  `--field` path now sends ADF, matching the semantics of `--description`.
- The ADF detection predicate is centralized in one helper; a future extension
  to cover additional system fields requires a one-line allowlist edit.
- Empty-value behavior is now defined and safe on all three paths (edit clear-doc;
  create omit; JSM create omit), preventing the JRACLOUD-79318 class of 400s.
- The existing `--description` (with or without `--markdown`) path is unaffected.
  AC-008 is preserved: the same detection logic serves both platform and JSM paths.

### Negative / Trade-offs

- The allowlist must be maintained as Atlassian adds or removes ADF-required
  fields. The risk is LOW — Atlassian's field schema has been stable for years,
  and the `schema.system`/`schema.custom` distinction is foundational to their
  API design. A future ADF-required field will announce itself via a 400 on the
  existing path, making discovery self-evident.
- Plain-text-only conversion (`text_to_adf`) means `--field environment=**bold**`
  writes literal asterisks, not bold text. Users who want formatted content must
  use `--description --markdown` (only applicable to `description`), not `--field`.
  The markdown-via-hint (`:markdown`) form is not available this cycle.
- The empty ADF doc (`{"type":"doc","version":1,"content":[]}`) is the CLEAR
  semantic on edit, not an error. Users who accidentally pass an empty `--field
  NAME=` to an ADF-backed field will now silently clear the field rather than
  receive a 400. This could be surprising; the BC documents this behavior.
- **The JSM create path gains a new `GET .../requesttype/{id}/field` round-trip when
  `--field` pairs are present (H-1 — JSM metadata fetch obligation).** Before this
  feature, `handle_jsm_create` never called the request-type field metadata endpoint
  — it had no `RequestTypeField` metadata in hand. The ADF detection and the
  metadata-unavailable fallback both require this metadata at the resolution layer.
  F4 Story 2 must add this acquisition step: call
  `JiraClient::get_request_type_fields` (a `JiraClient` async method in
  `src/api/jsm/request_types.rs`, returns `RequestTypeFieldsResponse`). The
  resolution layer must unwrap `.request_type_fields: Vec<RequestTypeField>` from
  the response before passing fields to the ADF detection step. The call must be
  wrapped by explicit cache free-function calls — `read_request_type_fields_cache`
  BEFORE the HTTP call when a warm entry exists, `write_request_type_fields_cache`
  AFTER a successful fetch — keyed on `(profile, sid, rtId)`, 7-day TTL.
  `JiraClient::get_request_type_fields` itself is cacheless; the caller in
  `jsm_create.rs` owns the cache read/write calls. Warm-cache calls add no network latency; cold-cache
  calls add one GET before the create POST. This fetch is gated on `--field` presence
  — a no-`--field` JSM create is unchanged. The failure taxonomy for the fields-fetch
  GET is FAIL-OPEN (PASS-7 F-1 resolution): ANY failure — network error,
  cache-miss-with-no-network, or ANY non-200 response including 401, 403, 404, and
  500 — results in the same outcome: emit ONE global stderr `warning:` line ONCE per
  create invocation (no field name in the text), fall back to `Value::String` for all
  BARE (`kind.is_none()`) `--field` values per EC-3.8.019-2 / EC-3.8.020-5 (hinted
  values bypass ADF conversion regardless of metadata availability), and CONTINUE the
  create (NEVER exit 64). The `write:servicedesk-request` write-scope hint is NOT
  appropriate here
  — the request-type fields endpoint is a READ endpoint (finding I-5). A 401 MAY
  append a brief informational read-auth note to the same single warning line; this
  is cosmetic context only. 403 and 500 follow the same fail-open rule with no
  special casing. 404 is treated identically to a network error. Alternative A
  (HTTP-cost retry-on-400) was rejected in Alternatives Considered as speculative
  and failure-mode-masking — this explicit ahead-of-time fetch is the
  design-approved approach.
- **DQ-6 (JSM resolution-layer plumbing) is a REQUIRED F4 resolution,
  not an optional quality improvement.** ADF detection, `text_to_adf` conversion,
  and the metadata-unavailable `warning:` emission are RESOLUTION-LAYER concerns —
  they belong in the effectful layer (`jsm_create.rs` or equivalent), not in the
  pure `build()` assembler, which has no HTTP/client access and no stderr side-effect
  path. The layer question is SETTLED (see Decision §DQ-6 above): `isAdfRequest` for
  the `--field` extra-field contribution is a pre-computed boolean from the resolution
  layer; `build()` never receives `rt_fields` and never inspects value types. When
  `RequestTypeField` metadata IS available (the normal path), ADF conversion MUST fire
  for every ADF-backed extra field at the resolution layer. The `Value::String(value)`
  fallback is only correct for the genuinely-metadata-unavailable case — i.e., the
  requesttype-fields FETCH ITSELF FAILED (network error / non-200 including
  401/403/404/500 / cache-miss-with-no-network — `jr` has NO field list at all for
  this RT). A `--field NAME=VALUE`
  where NAME is simply absent from a SUCCESSFULLY-fetched RT field list is NOT a
  metadata-unavailable case — it falls through to BC-3.8.008 verbatim behavior per
  the I-1 rule (field_id addressing only) with no warning emitted. The fallback MUST
  be observable (logged to stderr at `warning:` level by the resolution layer, ONCE
  per create invocation when the fetch failed — not once per `--field` pair — as a
  SINGLE GLOBAL warning with NO field name in the text), not silent — a silent
  fallback produces a 400 that is indistinguishable from a malformed value, providing
  no actionable error to the user.
  F4 Story 2 MUST decide the type/signature shape for carrying the resolved ADF object
  (e.g., widening `FieldValueSpec.value` from `String` to `serde_json::Value`, or a
  parallel ADF-values map). The story's AC must confirm that the silent-fallback path
  is eliminated for the normal (metadata-available) case. The F5 adversarial review
  will verify that no silent `Value::String` path remains when metadata is available.
  Additionally, VP-FIELD-ADF-004 (the JSM resolution-layer unit tests covering
  detection, conversion, flag accumulation, empty-omit, and observability) cannot be
  authored as runnable tests until the DQ-6 resolution lands — the test module,
  constructor shape, and assertion target for axes (b)–(e) require concrete knowledge
  of the chosen type/signature shape. Axis (e)'s `warning:` assertion targets the
  RESOLUTION LAYER — not `build()`, which is pure and has no stderr access. F4 Story
  2's acceptance criteria MUST explicitly gate VP-FIELD-ADF-004 test authoring on this
  DQ-6 resolution so the VP is not silently skipped. The VP is fully allocated at F2;
  gating is on execution, not definition.
- **JSM `environment` field (F-7 note — intentional uniform coverage).** The JSM
  `environment` system field is covered by the shared `is_adf_schema` predicate via
  `system == "environment"` — the same allowlist arm as the platform path. The probe
  found no `environment` field in the test-instance JSM request types, so there is no
  dedicated JSM pin; uniform allowlist treatment is intentional.

### Status as of 2026-09-12

Proposed. F2 spec evolution for cycle-012 (`field-adf-autoconvert`). Implementation
assigned to Stories 1 (platform path, `src/cli/issue/field_resolve.rs`) and 2 (JSM
path, `src/api/jsm/requests.rs`). F4 TDD delivery pending. No `src/` code has been
written as of this ADR's creation. This ADR will be set to `Accepted` when Story 1's
PR merges.

## Alternatives Considered

- **Option A — Schema-type-based heuristic with fallback.** Attempt ADF conversion
  for all `schema.type == "string"` fields and catch the 400 to retry as a plain
  string. Rejected: this would require a speculative POST and a retry, doubling the
  HTTP cost for every plain-string field write, and would mask legitimate 400s
  (malformed values, permission errors). It would also fail deterministically when
  `text_to_adf` produces valid ADF but Jira rejects it for a different reason.

- **Option B — Per-field hint syntax (`:adf` hint kind).** Let users specify
  `:adf` as a hint (`--field env:adf=VALUE`) to manually elect ADF conversion.
  Rejected: this puts the burden of knowing Jira's API internals on the user. The
  400 error is not user-actionable — `jr` should detect the API constraint and
  apply the correct wire form automatically. Additionally, the hint syntax is
  already used for option-type semantics (ADR-0019); introducing a new hint kind
  for ADF would expand the hint grammar's surface area without adding
  user-visible value.

- **Option C — Markdown conversion for all ADF-backed `--field` writes.** Use
  `markdown_to_adf` instead of `text_to_adf` for the ADF conversion, making
  `--field` work like `--description --markdown` by default. Rejected: `--field`
  values are typically short, structured strings (component names, single-line
  descriptions, environment IDs). Routing them through the full markdown parser
  would cause unexpected formatting on values like `Fix typo in "Description"
  field` (misinterpreted quotes) or `- item` (interpreted as a list). Plain-text
  conversion matches user intent for the `--field` surface; the markdown channel
  (`--description --markdown`) is already available for description writes.

- **Option D — Separate `--field-adf NAME=VALUE` flag.** Add a parallel flag
  specifically for ADF-backed fields. Rejected: requiring users to know whether a
  field is ADF-backed is the same UX problem as Option B. The API does not document
  this distinction at the user level, so the CLI must handle it transparently.

## Source / Origin

- **F1 delta analysis (operative):** `.factory/phase-f1-delta-analysis/e2e-edit-field-adf-heuristic-delta-analysis-v4.md` — §JSM-DISC (shared predicate design), §ADF Detection Set (allowlist), §C1 (empty-value semantics), §H1 (route-specific pre-check), §M3 (`description` via `--field` load-bearing path), §O5 (behavior flip), §JSM-DISC (`isAdfRequest` accumulation).
- **Live probes:** `.factory/research/createmeta-schema-probe-2026-09-12.md` (platform create-path schema parity, H2 CONFIRMED); `.factory/research/jsm-requesttype-fields-adf-probe-2026-09-12.md` (JSM discriminator, CONFIRMED).
- **Behavioral contracts (F2):** BC-3.3.013/014/015 (platform create path), BC-3.4.033/034/035/036/037 (platform edit path), BC-3.8.019/020/021/022 (JSM create path) — all in `.factory/specs/prd/bc-3-issue-write.md`.
- **Related ADRs:** ADR-0019 (field hint-kind value-spec shape — the `:markdown` hint form deliberately NOT introduced here); ADR-0023 (markdown mention seam — `--description --markdown` remains the markdown channel); ADR-0014 (JSM dispatch fork — the JSM create path that gains ADF extra-field support).
- **JRACLOUD references:** JRACLOUD-75814 (field schema discriminator absence); JRACLOUD-79318 (empty text-node 400 landmine).
- **External API doc:** Atlassian REST API v3 field schema documentation; Atlassian Document Format specification.
