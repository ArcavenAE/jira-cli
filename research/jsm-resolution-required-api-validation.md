# JSM/Jira Cloud Resolution-Required API Validation

**Research date:** 2026-06-03
**Researcher:** research agent (Perplexity deep research + official Atlassian docs + OpenAPI schema)
**Purpose:** Validate the Atlassian Jira Cloud REST API facts underpinning the planned `jr issue move` feature — proactively requiring a resolution when transitioning to a resolution-offering Done status.
**Context:** User observed on their JSM project (EJ) that the API let a Done-transition through with `resolution=null` even though the UI requires it.

---

## TL;DR — Verdicts

| # | Claim | Verdict |
|---|-------|---------|
| 1 | `transitions[].fields.resolution.required` exists; `fields` is a map keyed by field ID; resolution shape = `{required, name, schema, allowedValues}` | **CONFIRMED** |
| 2 | `statusCategory.key == "done"` is the stable, instance-independent, lowercase machine ID for the green Done category; full set = `new`/`indeterminate`/`done`/`undefined` | **CONFIRMED** |
| 3 | Jira Cloud transition API ALLOWS transitioning to a Done status without supplying `resolution` (silent success, `resolution=null`) — UI-enforces-but-API-bypasses | **CONFIRMED — and it is OFFICIALLY DOCUMENTED Atlassian behavior, NOT instance-specific.** The bypass premise HOLDS. |
| 4 | Detection heuristic: `transition offers resolution field in transitions.fields AND target statusCategory=="done"` | **CONFIRMED as sound — with REQUIRED REFINEMENTS** (see Claim 4) |

**The F1 premise is SAFE.** Claim 3 — the load-bearing one — is not refuted and not instance-specific. Atlassian's own KB states the transition API "is not expected to respect the screens" and that it "is still possible to transition the issue to Resolve without any resolution using Jira Cloud API directly." The user's EJ observation is canonical, documented behavior. The feature has a real gap to close.

---

## Claim 1 — Transition Fields Expand: `transitions[].fields.resolution.required`

**VERDICT: CONFIRMED**

`GET /rest/api/3/issue/{issueIdOrKey}/transitions?expand=transitions.fields` returns, per transition object, a `fields` map keyed by **field ID**, where each value is a `FieldMetadata` object. When the transition's screen includes the Resolution field, the map contains a `"resolution"` key.

**Authoritative schema (official Jira Cloud OpenAPI spec, generated bindings):**

`IssueTransition`:
```rust
pub struct IssueTransition {
    pub fields: Option<HashMap<String, FieldMetadata>>,  // keyed by field ID
    pub has_screen: Option<bool>,
    pub id: Option<String>,
    pub is_available: Option<bool>,
    pub is_conditional: Option<bool>,
    pub to: Option<StatusDetails>,
    // ...
}
```
> `fields`: "Details of the fields associated with the issue transition screen. Use this information to populate `fields` and `update` in a transition request." [src 8]

`FieldMetadata` (the value type):
```rust
pub struct FieldMetadata {
    pub allowed_values: Option<Vec<Value>>,  // "The list of values allowed in the field."
    pub name: String,
    pub required: bool,                       // "Whether the field is required."
    pub schema: Box<JsonTypeBean>,
}
```
[src 9]

**Confirmed JSON path:** `transitions[].fields.resolution.required` is valid and correct. `required` is a non-optional `bool` in the schema. A community report explicitly confirms: *"only the resolution field is marked as required: true for the transition (e.g 'close' status)."* [src 7]

**Important caveat (carries into Claim 4):** `fields` reflects **screen configuration only**, NOT workflow validators. If Resolution is enforced by a *validator* but is NOT on the transition *screen*, the `resolution` key is **absent** from `fields` even though the transition still requires resolution server-side. The expansion is screen-derived, not validator-derived. [src 3, 6]

---

## Claim 2 — Status Category Key: `"done"`

**VERDICT: CONFIRMED**

`statusCategory.key == "done"` is the stable, instance-independent, **lowercase** machine identifier for the green Done category across all Jira Cloud instances.

**Full canonical set (4 hardcoded values, immutable, lowercase, English regardless of locale):**

| key | id | colorName | name |
|-----|----|-----------|----|
| `undefined` | 1 | medium-gray | No Category |
| `new` | 2 | blue-gray | To Do |
| `done` | 3 | green | Done |
| `indeterminate` | 4 | yellow | In Progress |

[src 5, plus live response in src 6/community thread]

- Atlassian closed discussion on adding categories "a decade ago"; users cannot modify them. [src 5]
- Keys remain in English/lowercase even when the UI is localized — safe as a hardcoded identifier. [src 5]
- A live `Get transitions` response in the developer forum shows verbatim: `"statusCategory": { "id": 3, "key": "done", "colorName": "green", "name": "Done" }`. [src 6 — the same thread that demonstrates the bypass]

**Note** the keys differ slightly from the question's hypothesis ("new"/"undefined"/"to-do"): the actual three non-undefined keys are `new`, `indeterminate`, `done` — there is no `to-do` key (the *name* of `new` is "To Do", but the key is `new`). This matches the CLAUDE.md gotcha "green = Done, yellow = In Progress, blue-gray = To Do" which describes the **colorName/name** mapping, not the key.

---

## Claim 3 — THE API-BYPASS PREMISE (most important)

**VERDICT: CONFIRMED. The premise HOLDS. This is documented, instance-independent Atlassian behavior — NOT an EJ-specific quirk.**

> **READ THIS LOUDLY:** The bypass is REAL and OFFICIAL. The feature design rationale is sound. Nothing here forces a redesign — but Claim 4 refines *how* to detect.

### Official Atlassian KB (verbatim quotes)

From **support.atlassian.com — "Best practices on using the Resolution field in Jira Cloud"** [src 3]:

> "It is still possible to transition the issue to Resolve without any resolution using Jira Cloud API directly."

> "Issue transition API is not expected to respect the screens."

> "If your team is dependent on Jira Cloud API, then please consider implementing a solution to send the 'Resolution' detail along with the transition issue endpoint while resolving the issue... Also, it is advised to use the Workflow Validator or Condition to ensure that resolution is set even when the issue is transitioned from API."

This is the single most decisive citation. Atlassian explicitly documents that the transition API bypasses screen-level field requirements, leaving `resolution` unset.

### Live reproduction (developer.atlassian.com forum) [src 6]

A developer ran `Get transitions`, got a Done transition with `"hasScreen": false`, `statusCategory.key: "done"`, then POSTed:
```json
{ "transition": { "id": "41" } }
```
and reports: *"I was able to successfully transition an issue to `Done`."* No resolution supplied; transition succeeded.

### Decomposing the three sub-conditions

The behavior depends on **which enforcement mechanism** the workflow uses:

**(a) Workflow VALIDATOR ("Resolution required" / Field Required Validator):**
The API **enforces** this. A transition missing a validator-required resolution returns **400 Bad Request**. Validators operate at the business-logic layer and the API respects them. [src 3, 7, 13]

**(b) Resolution merely on the transition SCREEN (no validator):**
The API **does NOT enforce** this. The transition succeeds silently with `resolution=null`. Screens are a presentation-layer construct; "Issue transition API is not expected to respect the screens." **This is the user's EJ case.** [src 3, 6]

**(c) Field config required-vs-optional on the screen:**
Irrelevant to the API. Screen-level "required" markers (reflected as `fields.resolution.required:true`) are UI hints; the transition API ignores them unless a validator backs them. Even `required:true` in `transitions.fields` does NOT mean the API will reject a missing resolution — it only means the *screen* marks it required. [src 3]

### Why the UI enforces but the API bypasses

The Resolution field is special: in the Jira Cloud **UI**, whenever Resolution appears on a screen it is effectively mandatory (you cannot pick "None"/empty), so the UI always sets *something*. The **API** has no screen, so unless a validator intervenes, nothing forces a value. This UI-vs-API asymmetry is the documented gap. [src 3, src "Why resolution field is required" video transcript, src 2]

### Verdict statement for the design

The user's EJ observation (Done-transition via API leaves `resolution=null`) is **expected, documented behavior** for a workflow that puts Resolution on the screen but lacks a "Resolution required" validator. The `jr issue move` feature's premise — that there is a real gap worth closing client-side — is **VALID**.

---

## Claim 4 — Detection Best Practice

**VERDICT: CONFIRMED as a sound foundation — but the bare heuristic needs refinement to avoid false negatives and false positives.**

Base heuristic: *"transition offers a resolution field (present in `transitions.fields`) AND target `statusCategory.key == "done"`"*.

This is directionally correct and aligns with Atlassian's own recommended JQL hygiene check: `statusCategory = Done AND resolution is EMPTY` should yield zero results. [src 3] But each gotcha below matters:

### (a) `transitions.fields.resolution` present but marked OPTIONAL (`required:false`)
Some Done transitions intentionally allow closure without resolution (e.g., a "Won't Do" path). If `jr` hard-blocks whenever the resolution key is merely *present*, it will over-block legitimate flows. **Recommendation:** treat presence-of-key as the *trigger to prompt/offer* a resolution, not an absolute block. Use `fields.resolution.required` to decide block-vs-warn severity. Better still, key the proactive prompt on `statusCategory.key=="done"` + resolution-key-present, and let `--resolution` / `--no-input` govern enforcement.

### (b) Resolution settable via `fields` body even when NOT on the transition screen — FALSE NEGATIVE risk
**This is the biggest blind spot.** If Resolution is enforced by a *validator* but is absent from the transition *screen*, `transitions.fields` will NOT contain a `resolution` key — yet the transition genuinely requires resolution. The bare heuristic would *fail to detect* and the POST would 400. Conversely, you can often still SET resolution via the `fields` body even when it's not on screen (the field is editable even if not presented). **Recommendation:**
- Do not rely solely on `fields.resolution` presence. Also inspect `isConditional` (true ⇒ hidden validator/condition requirements may exist that the expand cannot enumerate).
- For the `jr issue move --resolution X` path, always allow the user to pass `fields: {"resolution": {...}}` even when the key is absent from the expand — Jira accepts it if the field is editable. (Caveat: if the field is truly not editable, Jira returns *"Field 'resolution' cannot be set. It is not on the appropriate screen, or unknown."* — surface that error with a clear hint.) [src 6]
- Resolution value must be an **object** (`{"id":"..."}` or `{"name":"..."}`), never a bare string. [src 7]

### (c) JSM (service desk) requests vs standard issues
JSM projects frequently use post-functions/automation to set resolution, and the same transition endpoints behave per the underlying workflow. There is **no JSM-specific transition API exception** — JSM requests are Jira issues and go through `/rest/api/3/issue/{key}/transitions` like any other. However:
- JSM workflows often auto-set resolution via **post functions** (resolution gets set *after* the transition with no value in the request and no `resolution` key in `fields`). In that case the gap the user saw may already be closed server-side for some transitions but not others.
- The user's EJ case proves *their* JSM workflow lacks both a validator and a post-function for that transition. The behavior is workflow-config-dependent, not project-type-dependent. **Recommendation:** detection must be per-transition/per-issue at runtime (which it already is via `Get transitions`), not assumed from project type. Do NOT special-case JSM vs platform for resolution detection. [src 11, src 3]

### (d) Does `expand=transitions.fields` add meaningful latency / caveats?
- It adds payload size and modest latency (community estimates ~40-60% larger transitions response; not authoritative, treat as rough). For a single interactive `move`, negligible. [deep-research synthesis, community — flagged as non-authoritative]
- **Real caveat:** the expand reflects *screen* fields only (see b). It is necessary but not sufficient.
- **Permission caveat:** transition list requires *Browse projects*; setting resolution may need *Edit issues* — a transition can appear available yet a resolution write fails on permissions. [src 1]
- `jr` already does a `Get transitions` round-trip for `move` (to resolve transition ID), so adding `expand=transitions.fields` to that *existing* call is essentially free — no extra request. This is the recommended integration point.

### Recommended F1 detection design (adjusted)

1. On `jr issue move`, call `Get transitions?expand=transitions.fields` (reuse the existing transition-ID-resolution call — no extra round-trip).
2. Identify the chosen transition's target `to.statusCategory.key`.
3. **Trigger condition:** `to.statusCategory.key == "done"` AND (`fields` contains `"resolution"` OR `isConditional == true`).
   - The `isConditional` OR-clause catches the validator-only / not-on-screen false-negative case (b).
4. **Action:**
   - If `--resolution <name|id>` supplied → include `fields: {"resolution": {"id"|"name": ...}}` in the POST. Validate against `fields.resolution.allowedValues` when present (use IDs, not localized names). [src 7]
   - If interactive and no `--resolution` → prompt, listing `allowedValues` if available.
   - If `--no-input` and resolution required-but-missing → exit non-zero with a clear hint (mirrors `jr`'s "always suggest next step" convention), rather than letting a `resolution=null` close slip through.
5. **Severity:** use `fields.resolution.required` to distinguish hard-block (required:true or isConditional) from soft-warn (required:false). Don't over-block optional-resolution Done transitions (gotcha a).
6. **Idempotency:** per CLAUDE.md, single-key `move` exits 0 if already in target status — keep that; the resolution check only applies when an actual transition will occur.

---

## Citations

| # | Source | Type | Used for |
|---|--------|------|----------|
| 1 | https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/ | Official API ref | Permissions, fields param, expand |
| 3 | https://support.atlassian.com/jira/kb/best-practices-on-using-the-resolution-field-in-jira-cloud/ | **Official Atlassian KB** | **Claim 3 — API bypasses screens (verbatim)**; JQL hygiene check |
| 5 | https://community.developer.atlassian.com/t/bad-documentation-for-rest-api-3-statuscategory/78565 | Atlassian dev forum | Claim 2 — 4 hardcoded statusCategory keys, immutable, lowercase |
| 6 | https://community.developer.atlassian.com/t/jira-rest-api-v3-can-i-update-a-resolution-via-transition-that-has-no-screen/62675 | Atlassian dev forum | **Claim 3 — live reproduction** of Done transition w/ no resolution; live `statusCategory.key:"done"` payload; "field not on screen" error |
| 7 | community.developer.atlassian.com/t/requirement-fields-for-transition-issue/92014 + Cannot-resolve-issue-via-REST-API | Atlassian forum | Claim 1 — resolution `required:true` in expand; resolution must be object not string |
| 8 | https://docs.rs/jira_v3_openapi/.../IssueTransition | OpenAPI-generated (from official Jira spec) | Claim 1 — `fields: HashMap<String, FieldMetadata>`, `is_conditional`, `has_screen` |
| 9 | https://docs.rs/jira_v3_openapi/.../FieldMetadata | OpenAPI-generated (from official Jira spec) | Claim 1 — `required: bool`, `name`, `schema`, `allowed_values` |
| 2 | community.atlassian.com — "Resolution field missing from Field Required Validator" | Atlassian forum | Resolution always mandatory when on a screen (UI); validator nuance |
| — | community.atlassian.com — "Why resolution field is required?" (video transcript) | Community | UI-vs-API asymmetry; Resolution not controlled by field config/validator |
| 13 | community.atlassian.com — "JIRA REST API transitioning... Kanban" | Community | `isConditional`/`isAvailable` semantics (non-authoritative on latency) |

**Source-tier note:** Claims 1, 2, 3 rest on **official Atlassian** (KB + OpenAPI-derived schema + dev-forum live payloads). Claim 4 refinements blend official docs (a, b, c, permission/error caveats) with community estimates (latency only — flagged non-authoritative).

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Deep multi-source synthesis across all 4 claims (reasoning_effort=high); surfaced the official KB and OpenAPI sources |
| Perplexity perplexity_search | 2 | Raw URL ranking — resolution/validator behavior; transitions.fields schema (found OpenAPI struct + live payload) |
| WebFetch | 4 | Verbatim extraction: official KB (Claim 3), statusCategory thread (Claim 2), IssueTransition struct, FieldMetadata struct (Claim 1) |

**Total MCP tool calls:** 3 (1 research + 2 search) + 4 WebFetch = 7 evidence-gathering calls.
**Training data reliance:** low — every verdict is anchored to a cited official Atlassian source or the official OpenAPI-derived schema. The only non-authoritative element (expand latency %) is explicitly flagged.
