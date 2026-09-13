---
document_type: adr
adr_id: ADR-0024
status: proposed
date: 2026-09-13
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

We will introduce a private `is_adf_schema` allowlist core (in
`src/cli/issue/field_resolve.rs`) as the single shared detection predicate —
`is_adf_field` and `is_adf_field_value` are delegating entry points over this core.
`is_adf_schema` returns `true` IFF the field's inner schema object satisfies:

```
schema.system.as_deref() == Some("description")
    OR schema.system.as_deref() == Some("environment")
    OR schema.custom.as_deref().map_or(false, |c| c.ends_with(":textarea"))
```

This predicate will be called from three platform dispatch sites (plus the JSM
resolution-layer site described below under `is_adf_field_value`):

1. `dispatch_field_value` (platform edit + create path (shared `dispatch_field_value`), `src/cli/issue/field_resolve.rs`) —
   when the predicate fires on a non-empty value, the wire value is
   `text_to_adf(&value)` (plain-text conversion, NOT markdown).
2. `resolve_against_editmeta` (platform edit empty-value pre-check) — when the
   predicate fires on an empty/whitespace value, inject
   `{"type":"doc","version":1,"content":[]}` directly and skip `dispatch_field_value`.
3. `resolve_against_createmeta` (platform create empty-value pre-check) — when the
   predicate fires on an empty/whitespace value, skip the field entirely (omit from
   POST body).

The fourth call site is the JSM resolution layer (`src/cli/issue/jsm_create.rs`), which
calls `is_adf_field_value` — the `serde_json::Value`-level delegating entry point over
`is_adf_schema` — directly on `&rt_field.jira_schema` for each bare `--field` extra
field on the JSM create path. `is_adf_field_value` is NOT one of the three platform
sites above; it bypasses `dispatch_field_value` entirely and performs its own
conversion and `isAdfRequest` accumulation in `jsm_create.rs` (see VP-FIELD-ADF-004).

An `is_adf_field_value(schema: &serde_json::Value) -> bool` delegating entry point
over the shared `is_adf_schema` core will be introduced in
`src/cli/issue/field_resolve.rs`, alongside `is_adf_field` and the private `is_adf_schema`
core. Placing all three functions in one module keeps every
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

**Createmeta → `EditMetaFieldSchema` adaptation contract — `system`/`custom` must be
preserved end-to-end (MEDIUM-3).** For `is_adf_field` to fire correctly on the
platform create path, the `EditMetaFieldSchema` populated from `get_createmeta_fields`
(the `GET .../createmeta/{proj}/issuetypes/{itid}` response) MUST preserve
`schema.system` and `schema.custom` without lossy transformation through JSON
deserialization. Concretely:
- A createmeta response with `"schema": {"type": "string", "system": "description"}`
  must yield `EditMetaFieldSchema { system: Some("description"), custom: None, … }`.
- A createmeta response with `"schema": {"type": "string", "custom":
  "com.atlassian.jira.plugin.system.customfieldtypes:textarea"}` must yield
  `EditMetaFieldSchema { custom: Some("com.…:textarea"), system: None, … }`.
A deserialization that replaces absent keys with empty strings rather than `None`, or
silently drops the `system`/`custom` fields, causes `is_adf_field` to return `false`
for ADF-backed fields and silently sends plain strings, producing a guaranteed 400. This
contract must be stated as a precondition in BOTH BC-3.3.013 (`:textarea` custom-field
create path) AND BC-3.3.014 (`description`/`environment` system-field create path) by the
product-owner — `schema.system` fidelity is especially critical for BC-3.3.014, which
depends on `system` surviving deserialization as `Some(...)` not `""` (see cycle-012
verification delta §5 item 10 for the required test that verifies end-to-end adaptation
fidelity from API response through `is_adf_field` to ADF output for BOTH paths).

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
delta analysis). Gate B blocks only the `--description` + `--field description=` combination,
never `--field description=` alone (which is the load-bearing M3 path);
this matches the create-path D2 guard's treatment of the `description` key. The ADF conversion must fire on this path or
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
  existing path, making discovery self-evident. Conversely, the over-selectivity
  direction also exists: a non-Atlassian custom field type whose plugin key happens
  to end `:textarea` but is NOT ADF-backed would be falsely converted, flipping a
  previously-working plain-string write to a 400; the mitigation, if ever reported,
  is to tighten the suffix match to the exact Atlassian plugin key
  `com.atlassian.jira.plugin.system.customfieldtypes:textarea`. Low probability;
  documentation-only.
- Plain-text-only conversion (`text_to_adf`) means `--field environment=**bold**`
  writes literal asterisks, not bold text. Users who want formatted content must
  use `--description --markdown` (only applicable to `description`), not `--field`.
  The markdown-via-hint (`:markdown`) form is not available this cycle.
- The empty ADF doc (`{"type":"doc","version":1,"content":[]}`) is the CLEAR
  semantic on edit, not an error. Users who accidentally pass an empty `--field
  NAME=` to an ADF-backed field will now silently clear the field rather than
  receive a 400. This could be surprising; the BC documents this behavior.
- **The JSM create path gains a new `GET .../requesttype/{id}/field` round-trip when
  ≥1 BARE (`kind.is_none()`) `--field` pair is present (H-1 — JSM metadata fetch obligation).** Before this
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
  calls add one GET before the create POST. This fetch is gated on ≥1 BARE
  (`kind.is_none()`) `--field` pair being present — a no-`--field` JSM create and a
  hinted-only invocation (every pair has a non-`None` kind) are both unchanged. The failure taxonomy for the fields-fetch
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
- **`--description` + `--field description=VALUE` simultaneous use on the JSM path —
  `self.description` deterministically supersedes (assembly-order), no guard, no dedicated diagnostic (MEDIUM-2 ruling — Option b).**
  No JSM-side dedicated-flag × `--field` collision guard is introduced for the
  `description` wire-key overlap (no D2 `detect_flag_field_overlap` equivalent on the
  JSM path). Introducing such a guard is outside F1-approved scope. The actual behavior
  when both `--description X` and `--field description=Y` are supplied on the same
  `jr issue create --request-type` invocation: `JsmRequestBuilder::build()` unconditionally
  writes an ADF object for `self.description` (the `--description` flag's channel via
  BC-3.8.006); the resolution layer in `jsm_create.rs` also writes `requestFieldValues
  ["description"]` from the `--field description=Y` path (ADF when metadata is available;
  `Value::String(Y)` under the EC-3.8.019-2 fail-open fallback when the fetch failed).
  `self.description` deterministically supersedes the `requestFieldValues["description"]`
  entry from the resolution layer per the assembly-order rule (EC-3.8.019-4 pass-13
  MEDIUM-3): `JsmRequestBuilder::build()` writes `self.description`'s ADF AFTER ALL
  resolution-layer writes to `requestFieldValues["description"]`, regardless of the
  DQ-6 option chosen — so `self.description` always wins the key when both are present. No dedicated diagnostic is emitted for this combination. The EC-3.8.019-2 fetch-failed warning fires
  ONLY when the metadata fetch itself failed — it is NOT a general mitigation for the
  `--description` + `--field description=` overwrite interaction. EC-3.8.019-4 MUST be
  rewritten by the product-owner to name this overwrite consequence explicitly and to
  remove any language implying the warning mitigates it (see cycle-012 verification delta
  §5 item 12 for the required EC text).
- **JSM create success output is key-only, marker-free — no `(adf)` per-field echo (H-1 echo-surface ruling, adversarial pass 12).** The JSM create path (`jr issue create --request-type RT --field NAME=VALUE`) always emits `Created request <KEY>` (table) or `{"key":…}` (JSON) as its success output, with no per-field ADF marker — consistent with BC-3.8.001. The `(adf)` and `(adf-clear)` markers (implemented via the `field_markers` side-channel in `src/cli/issue/field_resolve.rs`) are PLATFORM PATHS ONLY: they are populated by `dispatch_field_value` (platform edit/create) and `resolve_against_editmeta` (platform edit), neither of which is called from the `jsm_create.rs` resolution layer. A prior pass-11 MEDIUM-1 ruling to emit `(adf)` on the JSM create path for parity was REVERSED in adversarial pass 12 as unimplementable without a net-new echo surface outside F1-approved scope. The BC-3.8.019 and BC-3.8.020 "Table output (MEDIUM-1)" postconditions must be REMOVED by the product-owner; see cycle-012 verification delta §7 for the retraction notice and product-owner instruction. The F4 AC test `test_bc_3_8_019_jsm_create_table_shows_adf_marker` is retracted.

- **`--dry-run` sentinel rendering uses `field_markers` as single source of truth — not `planned_preview` inspection (M-3 ruling, adversarial pass 12).** The `(adf)` and `(adf-clear)` sentinels in the dry-run table output are derived from the `field_markers` side-channel (§5 item 9 of the cycle-012 verification delta), not from inspecting whether `planned_preview[human_name]["content"]` is empty or non-empty. Both `field_markers` population sites fire on the dry-run code path (same `dispatch_field_value` and `resolve_against_editmeta` calls execute). The `edit.rs` dry-run table-emit loop consults `field_markers` exactly as the live path does. An implementation that infers the sentinel from `planned_preview` content shape is explicitly rejected: it is fragile to future ADF docs with empty `content` for non-clear reasons and duplicates logic already captured in `field_markers`.

- **VP-FIELD-ADF-003 Axis D context-vs-pin ruling for BC-3.4.033 and BC-3.8.019 (M-2 option-ii, adversarial pass 12).** BC-3.4.033 and BC-3.8.019 are cited in VP-FIELD-ADF-003 Axis D as CONTEXT (their `kind.is_none()` precondition is the basis for the axis) rather than as full bidirectional Pins. These BCs are fully owned by VP-FIELD-ADF-001/002/004. No BC edit is required; the §2 VP-003 registration table is unchanged. Bidirectional consistency is achieved by the CONTEXT label in the Axis D heading rather than by adding a VP-FIELD-ADF-003 citation to the BC bodies.

- **Platform vs JSM failure-mode asymmetry — intentional, do not harmonize (LOW-3).**
  The platform create path exits 64 on `createmeta`/`editmeta` fetch failure: ADF
  detection requires field metadata, and a schema gap is a correctness risk that warrants
  aborting the operation. The JSM create path is fail-open (warn once + plain-string
  fallback + continue) on `requesttype/field` fetch failure (VP-FIELD-ADF-004 Axis e).
  This asymmetry is intentional: the platform path treats metadata unavailability as a
  hard correctness error; the JSM path treats it as an acceptable degradation, preferring
  to attempt the create and let the server surface a 400 if the value was wrong over
  aborting. A future maintainer MUST NOT harmonize these two paths to both be fail-open
  or both exit-64 without revisiting the BC postconditions for both paths.

- **`--markdown` + `--field description=VALUE` — UNIFORM exit-64 across all three write paths, consistent message (F2-gate human design decision; supersedes prior DQ-1 Option A silent-ignore framing; amended LOW-1, 2026-09-13).** The human's F2-gate decision mandates UNIFORM exit-64 across all three write paths (`issue create` platform, `issue edit` platform, `issue create --request-type` JSM) when `--markdown` is combined with `--field description=VALUE`. The prior framing (platform paths: silent-ignore / DQ-1 Option A; JSM: exit-64) is superseded. EC-3.3.014-5 and EC-3.4.035-3 must be REWRITTEN accordingly (verbatim text: see F2-gate decision report); BC-3.8.017 gains a cross-reference noting it is one of three uniform paths (no JSM behavior change).

  **Trigger (identical on all three paths):** `--markdown` set AND at least one `--field` token whose raw key (substring before the first `=`, NO trimming, NO case-folding) is EXACTLY `"description"` — case-SENSITIVE, no-trim match, identical to BC-3.8.017's existing detection. `--field Description=X` (key `Description`) does NOT trigger the guard.

  **Message (consistent, pinned substring — NOT full verbatim equality):** All three paths MUST emit a message containing the pinned substring `` cannot be combined with `--markdown` `` and the remediation phrase "Pass `--description` with `--markdown`, or omit `--markdown`." The alignment requirement is scoped to this pinned substring + remediation phrase — NOT byte-for-byte full-message equality with BC-3.8.017's existing verbatim message. Create and edit guard messages MUST contain the pinned substring and remediation phrase; the middle-clause framing (describing WHY the combination is rejected) may differ from BC-3.8.017's verbatim. Do NOT alter BC-3.8.017's existing verbatim message. **Pre-existing spec-vs-code drift (out of scope for this F2-gate amendment):** BC-3.8.017's declared canonical verbatim at `bc-3-issue-write.md` ~BC-3.8.017-Behavior (intent-mismatch "plain-text ADF" framing, updated at F2) may differ from the middle clause of the shipped `src/cli/issue/jsm_create.rs::handle_jsm_create` guard message's `--markdown`+`--field description=` branch (old "desyncing isAdfRequest" framing). This middle-clause drift is a PRE-EXISTING spec-vs-code doc drift; the F2-gate amendment mandates NO JSM behavior change, so the JSM code framing is not updated here. Flagged as a candidate follow-up for a future spec-cleanup cycle; do not fix the JSM code message as part of this amendment. **Product-owner BC instruction (BC-3.8.017 [AMENDED 2026-09-13] block):** The sentence "BC-3.8.017's existing verbatim message is the canonical source; create and edit align TO it" in the [AMENDED 2026-09-13 cycle-012 F2-gate — uniform-exit-64] block should be reworded to: "BC-3.8.017's message is the canonical source for the pinned substring `` cannot be combined with \`--markdown\` `` and the remediation phrase 'Pass `--description` with `--markdown`, or omit `--markdown`.'; create and edit guards MUST emit messages CONTAINING this pinned substring and remediation — full verbatim equality with BC-3.8.017's message text is NOT required."

  **Guard ordering — platform edit (`src/cli/issue/edit.rs::handle_edit`):**
  1. Gate B (BC-3.4.017): `--description` + `--field description=` → exit 64 (existing, unchanged).
  2. **NEW GUARD (F4 obligation — edit guard extension):** `--markdown` + `--field description=` raw key exactly `"description"` → exit 64 with consistent `` cannot be combined with `--markdown` `` message. This guard MUST fire BEFORE the existing `--markdown`-requires-description guard in `handle_edit` (the guard that tests `description.is_none() && !description_stdin`). Without this ordering, `--field description=X --markdown` (no `--description`) would fall through to the existing guard — which fires because `description` is absent — and produce the wrong message.
  3. Existing `--markdown`-requires-description guard (`src/cli/issue/edit.rs::handle_edit § "--markdown requires --description guard"`): fires when `--markdown` + `description.is_none()` + `!description_stdin` + NO `--field description=` → exit 64 with existing message "`--markdown requires --description or --description-stdin`". Unchanged; still fires for `--markdown` with no description source at all.

  **Guard ordering — platform create (`src/cli/issue/create.rs::handle_create`):**
  1. Step 2: `--on-behalf-of` guard (unchanged).
  2. Step 2a: `parse_field_kv` hint-syntax parse (unchanged).
  3. Step 2b: D2 collision guard (`detect_flag_field_overlap`, unchanged).
  4. **NEW GUARD step 2c (F4 obligation — NET-NEW for create):** `--markdown` + `--field description=` raw key exactly `"description"` → exit 64 with consistent message. Fires AFTER step 2b and BEFORE step 4b (createmeta resolution — which would issue HTTP calls). Zero HTTP calls on this exit path.
  5. Step 4b: createmeta resolution (unchanged).

  **Guard ordering — JSM create (`src/cli/issue/jsm_create.rs::handle_jsm_create`, BC-3.8.017):** Existing guard at step 2 (after project-key resolution, before `require_service_desk`). No change required.

  **F4 obligations:** (1) `src/cli/issue/create.rs::handle_create` — add NET-NEW step 2c guard. (2) `src/cli/issue/edit.rs::handle_edit` — add NEW GUARD (item 2 above) before the existing `--markdown`-requires-description guard. See VP-FIELD-ADF-004 Axis (h) below.

  A future maintainer MUST NOT weaken any of these three paths back to silent-ignore without revisiting BC-3.8.017, EC-3.4.035-3, and EC-3.3.014-5 as a set.

- **BC-3.8.017 pass-12 amendment — JSM resolution-layer mis-anchor corrected (HIGH-1, adversarial pass 13, 2026-09-13).** The [AMENDED 2026-09-12 cycle-012] block in BC-3.8.017's Rationale stated that, after cycle-012, ADF detection and conversion for `--field description=` occur in the resolution layer `field_resolve.rs::dispatch_field_value`. This is incorrect: `dispatch_field_value` is PLATFORM-PATH ONLY and is never called from the JSM create path (DQ-6 layer constraint, this ADR's Decision section). On the JSM path, ADF detection and conversion for `--field` extra fields are performed in the RESOLUTION LAYER in `src/cli/issue/jsm_create.rs` via `is_adf_field_value` (the `serde_json::Value`-level detection wrapper in `src/cli/issue/field_resolve.rs`, called from `jsm_create.rs`) + `text_to_adf` (plain-text conversion, in the `jsm_create.rs` resolution layer). The corrected parenthetical for the BC-3.8.017 pass-12 amendment: "the JSM resolution layer is `src/cli/issue/jsm_create.rs` via `is_adf_field_value` + `text_to_adf`, NOT `field_resolve.rs::dispatch_field_value`." Product-owner corrects the BC-3.8.017 [AMENDED] block accordingly.

- **BC-3.8.017 Rationale — stale pre-cycle-012 mechanism description superseded (MEDIUM-2, adversarial pass 13, 2026-09-13).** The original Rationale paragraph described `build()` computing `is_adf_request = true` and iterating `extra_fields` such that a `description`-keyed entry in `extra_fields` overwrites the ADF value with a plain string. Post-cycle-012, this mechanism no longer exists. `build()` is now a pure assembler that reflects a pre-computed `isAdfRequest` flag passed from the resolution layer (BC-3.8.022); ADF-backed `--field` extra values are converted to ADF objects by the resolution layer in `jsm_create.rs` BEFORE `build()` is called — `build()` never receives a plain string from the `--field description=` path. The surviving rationale for the BC-3.8.017 guard is an intent-mismatch warning: the `--field` path always uses plain-text `text_to_adf` conversion regardless of any `--markdown` flag, so a user who supplies `--markdown` together with `--field description=` will receive plain-text conversion rather than Markdown-to-ADF. The guard communicates this intent-mismatch as a user-actionable exit-64 error, not a wire-desync prevention. Product-owner replaces BC-3.8.017's Rationale paragraph with the following superseding text (consistent with the corrected HIGH-1 amendment and the reflect-only `build()` model): "The `--field` path always uses plain-text `text_to_adf` conversion for `--field description=` values, regardless of the `--markdown` flag — `--field` never invokes `markdown_to_adf`. A user who supplies `--markdown` with `--field description=VALUE` would receive plain-text conversion, not the Markdown-to-ADF conversion they intend. After cycle-012, the JSM resolution layer in `src/cli/issue/jsm_create.rs` handles ADF detection and conversion for `--field` extra fields (via `is_adf_field_value` + `text_to_adf`) before `build()` assembles the POST body; `build()` reflects the pre-computed `isAdfRequest` flag and never string-wraps extra fields (BC-3.8.022). The guard communicates the intent-mismatch so the user can supply `--description VALUE --markdown` (the Markdown-to-ADF channel) instead."

- **`--description` + `--field description=` + EC-3.8.019-2 fail-open desync — assembly-order rule (MEDIUM-3, adversarial pass 13, option i, 2026-09-13).** Without `--markdown`, supplying both `--description X` and `--field description=Y` on `jr issue create --request-type` is permitted (no guard; BC-3.8.017's guard only fires when `--markdown` is also present). Under the EC-3.8.019-2 fail-open fallback (requesttype-fields fetch itself failed), the resolution layer degrades `--field description=Y` to `Value::String(Y)`. Meanwhile `self.description = Some(X)` causes `build()` to set `isAdfRequest: true` (BC-3.8.022, which fires whenever ANY ADF value is present including `self.description`). If `build()` writes the extra-fields loop AFTER `self.description`'s ADF write, `Value::String(Y)` overwrites the ADF value, producing `isAdfRequest: true` + plain-string description — the same class of desync BC-3.8.017 exists to prevent, now reachable without `--markdown` via the fail-open path. RULING (option i — preferred as a small within-scope deterministic assembly-order constraint): `JsmRequestBuilder::build()` MUST write `self.description`'s ADF value (the BC-3.8.006 channel) AFTER ALL resolution-layer writes to `requestFieldValues["description"]`, regardless of the DQ-6 option chosen. This ensures `self.description` always wins the `requestFieldValues["description"]` key when both are present, regardless of whether the resolution layer produced ADF or a fail-open plain string. This is a pure implementation ordering constraint on `build()` — no guard, no new validation logic, no new diagnostic. Option (ii) (document as accepted degradation with server-400 expectation) was rejected because option (i) is achievable within F1-approved scope. Product-owner adds the assembly-order rule to EC-3.8.019-4 (the [AMENDED 2026-09-13] block that was specified in verification delta §5 item 12): append the following clause: "**Assembly-order rule (pass-13 MEDIUM-3):** `JsmRequestBuilder::build()` MUST write `self.description`'s ADF value (BC-3.8.006 channel) AFTER all resolution-layer writes to `requestFieldValues['description']`, regardless of the DQ-6 option chosen — so that `self.description` always supersedes any `requestFieldValues['description']` entry produced by the resolution layer, including a fail-open `Value::String(Y)` under EC-3.8.019-2. Under the fail-open fallback, `requestFieldValues['description']` will therefore carry `self.description`'s ADF object (not `Value::String(Y)`), maintaining consistency with `isAdfRequest: true`. This is a pure assembly-order constraint on `build()`'s implementation; no guard or diagnostic is added for the no-`--markdown` case."

- **Canonical negative `isAdfRequest` wire form — ABSENT, not explicit `false` (LOW-1, adversarial pass 13, 2026-09-13).** BC-3.8.001 described `isAdfRequest (bool)` as an always-present field in the JSM POST body. BC-3.8.006 and BC-3.8.022 use language "may be omitted or set to false" and "NOT set when no ADF value is present" for the negative case. These are in tension. Ruling: the canonical negative wire form is **ABSENT** — the `isAdfRequest` key is NOT emitted in the POST body when no `requestFieldValues` entry is ADF-converted and `self.description` is `None`. "NOT set" in BC-3.8.022 means the key is omitted, not written as `false`. BC-3.8.001's "always-present" claim is incorrect for the negative case and is reconciled by the addition below. Product-owner adds one sentence to BC-3.8.022's regression-pin postcondition: "When no `requestFieldValues` entry is ADF-converted and `self.description` is `None`, the `isAdfRequest` key is ABSENT from the POST body — it is NOT emitted as explicit `false`."

- **Pass-14 adversarial review rulings (2026-09-13) — VP propagation, `build()` description qualification, and assembly-order VP.** Six findings converge on two seams: the `build()` reflect-only boundary vs the EXEMPT `self.description` ADF channel, and the negative/ordering wire-form details that no VP pins.

  **(M-1) VP-FIELD-ADF-004 Axis (c) narrowed to ABSENT; three sibling BC/EC texts corrected.** The LOW-1 pass-13 ABSENT ruling is propagated to VP-FIELD-ADF-004 Axis (c) in the verification delta (narrowed from "NOT `true`" to "key ABSENT — NOT emitted as explicit `false`") and to three sibling locations the product-owner must correct: (a) BC-3.8.022 Behavior item 3 ("flag absent or `false`" → "key ABSENT, NOT emitted as explicit `false`"); (b) EC-3.8.022-1 ("`isAdfRequest` absent or `false`" → "`isAdfRequest` ABSENT (key not emitted, NOT explicit `false`)"); (c) BC-3.8.006 negative-case clause ("`isAdfRequest` may be omitted or set to false" → "`isAdfRequest` is ABSENT (key not emitted — NOT explicit `false`)"). A `body.insert("isAdfRequest", false)` mutant is killed by Axis (c). **ABSENT propagation complete (pass-15 comprehensive sweep, extended pass-17):** the ABSENT ruling has been fully propagated to BC-3.8.001 (parenthetical added), BC-3.8.006 (Behavior clause AND its [AMENDED] block), BC-3.8.017 (stale `false`/omitted language corrected), BC-3.8.022 (item 3, EC-3.8.022-1, and postcondition), and VP-FIELD-ADF-004 Axis (c) — swept in pass-15. Extended in pass-17: BC-3.8.022 section title ("NOT set when no ADF value is present" → "NOT set when no ADF value is present (key ABSENT — NOT explicit `false`)") and EC-3.8.020-2 ("the flag must not be set" → "the flag must not be set (key ABSENT — NOT explicit `false`)"). No further siblings remain after pass-17.

  **(M-2) New VP-FIELD-ADF-004 Axis (g): assembly-order pure `build()` unit test, authorable NOW, NOT DQ-6-gated.** EC-3.8.019-4's assembly-order constraint (MEDIUM-3 above: `build()` MUST write `self.description`'s ADF AFTER ALL resolution-layer writes to `requestFieldValues["description"]`) has no VP pinning it. Axis (g) is added to VP-FIELD-ADF-004 in the verification delta. It targets `JsmRequestBuilder::build` (in `src/api/jsm/requests.rs`) directly — pure, network-free, no `RequestTypeField` metadata — and is authorable immediately. The current implementation in `JsmRequestBuilder::build` writes the `self.description` ADF block BEFORE the extra-fields assembly loop (opposite of the required order), so Axis (g) is currently RED. Test name: `test_bc_3_8_019_build_description_supersedes_extra_field_description_entry`. VP count remains 86 (axis extension, not a new VP).

  **(H-1 + L-1) `build()`'s "does NOT call" and "sole responsibility" claims qualified to extra-field scope; `self.description` EXEMPT.** The unqualified "does NOT call `is_adf_field_value`, does NOT call `text_to_adf`, and does NOT emit `warning:` lines" and "sole responsibility for ADF is to reflect the already-computed `is_adf_request` boolean" in BC-3.8.019/BC-3.8.020 Description are false for `build()` as a whole: `JsmRequestBuilder::build` retains `text_to_adf`/`markdown_to_adf_*` for `self.description` (BC-3.8.006 channel, `src/api/jsm/requests.rs::JsmRequestBuilder::build § self.description ADF-conversion block`). Product-owner must qualify both phrases to "for `--field` extra-field values" and add an explicit EXEMPT clause noting `build()` retains the `self.description` ADF channel (BC-3.8.006) unchanged.

  **(L-2) EC-3.8.019-1 "last-writer-wins" replaced with deterministic assembly-order language.** "Last-writer-wins in the final JSON merge" implies nondeterminism. EC-3.8.019-4's assembly-order rule (MEDIUM-3 above) makes the outcome deterministic: `self.description` always supersedes. Product-owner replaces that phrase with "`self.description` supersedes (deterministic per EC-3.8.019-4's assembly-order rule)."

  **(L-3) Assembly-order behavioral change enumerated in BC-3.4.034 CHANGELOG.** The assembly-order fix changes `jr issue create --request-type RT --description X --field description=Y` (no `--markdown`) from a Y-wins-plain-string desync (likely 400 under the EC-3.8.019-2 fail-open fallback) to X-wins-coherent-ADF. Ruling: enumerate in BC-3.4.034 item 4's combined `### Fixed` CHANGELOG entry. Product-owner CHANGELOG line: "Fixed (JSM, assembly-order): `jr issue create --request-type RT --description X --field description=Y` (without `--markdown`) now consistently uses `--description`'s ADF value — `self.description` supersedes the `--field description=Y` extra-field entry, eliminating a potential `400` under the metadata-unavailable fail-open fallback (EC-3.8.019-4 assembly-order rule, ADR-0024)."

  **(L-4) VP-FIELD-ADF-001 citation scoped to schema-typed path; JSM Value-extraction coverage attributed to VP-004 Axis (a).** BC-3.8.019/BC-3.8.020 cite VP-FIELD-ADF-001 as "covers the JSM `jira_schema` case." VP-001's proptest targets typed `EditMetaFieldSchema`; it is transitively effective via `is_adf_schema` but does NOT directly exercise the `serde_json::Value` extraction step (`value["system"].as_str()` / `value["custom"].as_str()`) in `is_adf_field_value`. That extraction is exercised by VP-004 Axis (a)'s example test. No coverage gap exists — only a misleading citation. Product-owner corrects the VP-001 citation in BC-3.8.019/BC-3.8.020 to say "covers the `is_adf_schema` allowlist predicate transitively (proptest targets typed `EditMetaFieldSchema`; both `is_adf_field` and `is_adf_field_value` call `is_adf_schema`)" and ensures VP-004 Axis (a) is cited for the JSM Value-extraction path specifically.

- **`(adf)`/`(adf-clear)` sentinel cross-subdomain coupling — accepted as-is (LOW-2, adversarial pass 13, 2026-09-13).** The `(adf)` and `(adf-clear)` sentinels are defined within the edit-path BC-3.4.036 sentinel registry and cross-referenced from create-path BCs (BC-3.3.013/BC-3.3.014 postconditions note "Mirrors the edit-path sentinel convention (BC-3.4.036 dry-run sentinel registry)"). A pass-12 clarifier in verification delta §5 item 9 notes "PLATFORM PATHS ONLY" and documents both `field_markers` population sites. Decision: ACCEPT AS-IS. The existing cross-reference convention is clear and durable; promoting the sentinels to a path-neutral shared sentinel definition (new standalone BC or glossary entry) would add spec surface area without improving coverage. No product-owner change required for this finding.

- **VP-FIELD-ADF-004 Axis (h) — Uniform exit-64 for `--markdown + --field description=` on PLATFORM paths (F2-gate, 2026-09-13; VP count stays at 86, axis extension).** The JSM guard is already covered by BC-3.8.017's existing test (`tests/issue_create_jsm.rs::test_jsm_create_markdown_field_description_conflict_exits_64`). Two new sub-axes pin the platform paths — both are F4 obligations and MUST be RED until the guards are implemented:

  **(h1) Platform create NET-NEW guard:** `jr issue create --project P --type T --summary S --field description=X --markdown` (no `--description`) → exit 64; `stderr.contains("cannot be combined with \`--markdown\`")` asserts true; stdout empty; zero HTTP mocks (guard fires before createmeta resolution). Test name: `test_bc_3_3_014_5_markdown_field_description_conflict_exits_64_create`. F4 obligation — `src/cli/issue/create.rs::handle_create` currently lacks this guard entirely (EC-3.3.014-5 NET-NEW guard).

  **(h2) Platform edit guard extension:** `jr issue edit KEY --field description=X --markdown` (no `--description`) → exit 64; `stderr.contains("cannot be combined with \`--markdown\`")` asserts true (NOT the pre-existing "`--markdown requires --description or --description-stdin`" substring — the test must assert the correct message from the NEW guard, not the existing guard's message); stdout empty; zero HTTP mocks (guard fires before editmeta). Test name: `test_bc_3_4_035_3_markdown_field_description_conflict_exits_64_edit`. F4 obligation — `src/cli/issue/edit.rs::handle_edit` guard must be EXTENDED per guard ordering above.

  Both axes use mechanism: CLI-level subprocess test, `assert!(stderr.contains("cannot be combined with \`--markdown\`"))` + `assert_eq!(exit_code, 64)` + `assert!(stdout.trim().is_empty())`. VP count remains 86 (axis extension within VP-FIELD-ADF-004, not a new VP).

### Status as of 2026-09-13

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
