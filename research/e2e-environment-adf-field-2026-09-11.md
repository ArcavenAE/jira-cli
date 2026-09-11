# Research: Jira Cloud v3 ADF "string" fields vs plain-string fields (E2E `discover_safe_edit_field`)

**Date:** 2026-09-11
**Type:** general (technology / REST API behavior)
**Context:** Live E2E test `test_e2e_issue_edit_custom_field` in `tests/e2e_live.rs` fails on the live
site with `API error (400): environment: Operation value must be an Atlassian Document (see the
Atlassian Document Format)`. Its helper `discover_safe_edit_field` picks a field whose
`editmeta` `schema.type == "string"` and prefers the `Environment` system field — but `environment`
requires an ADF object on write, so the CLI's plain-string `--field NAME=VALUE` path is rejected.

---

## Summary

On Jira Cloud REST API **v3**, `description` and `environment` are ADF (Atlassian Document Format)
rich-text fields that require a `{"type":"doc","version":1,"content":[...]}` object on write —
even though `editmeta`/`createmeta`/`/field` all report `schema.type == "string"`. This is a
known, acknowledged metadata "abstraction leak": Atlassian's own suggestion to fix the misleading
schema was closed **Won't Fix** (JRACLOUD-75814). **There is no generic, reliable, documented
machine-readable signal in `editmeta` that distinguishes an ADF-backed "string" field from a
genuinely plain-text one.** The only reliable discriminators are (a) recognizing known system
field IDs (`description`, `environment`) and (b) the built-in custom-field type key
`schema.custom` (`...:textfield` = plain string, `...:textarea` = ADF). The correct fix for the
E2E heuristic is to stop preferring `environment` and restrict discovery to Jira's built-in
single-line text custom fields (`schema.custom == "...:textfield"`), with a denylist of known ADF
system fields as a secondary guard.

---

## Q1 — Are `environment`/`description` ADF fields requiring ADF on write in v3, despite `schema.type == "string"`? Universal or instance-dependent?

**Answer: Yes, both require ADF on write in REST v3, and for these two system fields the requirement
is universal in the documented v3 contract — not documented as renderer/instance-dependent.**

- The v3 Edit/Create issue docs explicitly state that `description`, `environment`, and `textarea`
  custom fields take Atlassian Document Format content, while single-line `textfield` custom fields
  take strings.
- v3 uses ADF for rich-text fields; v2 accepts wiki-markup/plain strings for the same fields
  (Atlassian marked this v2-vs-v3 difference intentional in JRACLOUD-72071). Sending a plain string
  to `description`/`environment` on v3 yields exactly the observed 400 "Operation value must be an
  Atlassian Document".
- There IS a genuine renderer concept elsewhere in Jira (Wiki renderer vs Default text renderer),
  and a *different* API surface (Forge UI-modifications `FieldAPI`) does vary its `description` type
  by renderer. But no official source documents `PUT /rest/api/3/issue/{key}` changing its payload
  type by renderer config — the v3 REST rule is stated categorically. So for the purpose of this
  test, treat it as universal on v3.

**Confidence: HIGH** for "requires ADF on v3" (explicit official docs + the exact 400 message).
**MEDIUM-HIGH** for "universal, not instance-dependent": absence of any documented renderer-based
exception is strong but is partly an argument from silence; a non-standard field configuration
*theoretically* could differ, but nothing documents it.

Sources:
- https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/ (Edit/Create issue — description & environment take ADF)
- https://developer.atlassian.com/cloud/jira/platform/rest/v3/intro/ (v3 provides ADF for description/environment)
- https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/ (ADF = JSON object rooted at type:"doc")
- https://jira.atlassian.com/browse/JRACLOUD-72071 (v2 wiki markup vs v3 ADF — intentional)
- https://community.developer.atlassian.com/t/jira-cloud-new-issue-view-editor-changes/29993

---

## Q2 (KEY) — Does editmeta/createmeta expose a RELIABLE machine-readable signal for "this string field needs ADF"?

**Answer: NO. There is no generic, documented signal.** This is the finding.

Investigated candidates and their verdicts:

| Candidate | What it actually is | Reliable ADF discriminator? |
|-----------|--------------------|------------------------------|
| `schema.type` | Broad JSON type; `description`, `environment`, `summary`, `textarea`, `textfield` are all `"string"` | **No** — this is the central defect (JRACLOUD-75814, Won't Fix) |
| `schema.system` | Identifies system field by name (e.g. `"description"`, `"environment"`) | **Only via a hard-coded ID table** — no semantic `richText`/`adf` attribute |
| `schema.custom` | Built-in custom-field impl key | **Yes, but only for Jira's known keys:** `...:textarea` = ADF, `...:textfield` = string. Not universal for Connect/Forge/app fields |
| `schema.items` | Array member type | No |
| `schema.configuration` / `configuration` | App-specific config; may carry `customRenderer` for app fields | **No** — no standardized/documented `adf`/`richText`/renderer contract |
| `operations` (`set`/`add`/`remove`) | Permitted update verbs | No — describes operations, not value wire format |
| `autoCompleteUrl` | Picker candidate-values URL | No |
| `renderer` / `rendererType` | Not returned by `/rest/api/3/field` or `editmeta`. Field-config `PUT` accepts a *write-only* `text-renderer`/`wiki-renderer`; not readable back. JRACLOUD-75913 (add rendererType to GET) **Timed out** | **No public read API** |
| current value via `GET issue` | Populated rich text is `{type:"doc",...}`, plain is a string | Heuristic only; useless for null/empty fields; not metadata |

Known Jira Cloud **system** content requiring ADF on v3: `description`, `environment`, issue
**comment body**, **worklog comment**. Plus built-in `...:textarea` custom fields.

**Confidence: HIGH.** Multiple official docs + two Atlassian issue-tracker tickets (75814 Won't Fix,
75913 Timed out) confirm the absence of a read-side signal. Caveat: third-party/Connect/Forge app
fields are not generically inferable from metadata at all.

Sources:
- https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/ (textarea→ADF, textfield→string)
- https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-fields/ (`/field` has no renderer/ADF flag)
- https://jira.atlassian.com/browse/JRACLOUD-75814 (description reported schema.type "string" — Won't Fix)
- https://jira.atlassian.com/browse/JRACLOUD-75913 (add rendererType to field-config GET — Timed out)
- https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-field-configurations/ (renderer is write-only, not read-back; deprecated)
- https://community.developer.atlassian.com/t/single-line-text-or-reach-text/72737 (textarea vs textfield type keys)

---

## Q3 — How should a client pick a field guaranteed to accept a PLAIN-STRING write?

**Most robust option:** Restrict to Jira's built-in single-line text custom field type:

```
schema.type == "string"  AND  schema.custom == "com.atlassian.jira.plugin.system.customfieldtypes:textfield"
```

This is the *only* metadata-derivable class documented to accept a plain string. It inherently
excludes `description`/`environment` (system fields, no `schema.custom`) and `...:textarea` (ADF).

**Simple fallback / secondary guard:** Maintain a denylist of known ADF system fields and skip them,
plus skip the ADF custom type:
- Deny system fields: `description`, `environment` (and, if ever writable via `--field`: comment/worklog bodies).
- Skip `schema.custom == "...:textarea"`.
- Only then accept a `schema.type == "string"` field.

The denylist alone is less safe than the `textfield` allowlist because an unknown app-defined
`"string"` field could still expect a non-string shape. Prefer the allowlist; use the denylist only
as a defensive backstop.

**Confidence: HIGH** that the `textfield` allowlist is correct and safe for Jira built-in fields.
**MEDIUM** for total coverage across arbitrary third-party app fields (not generically inferable —
but the allowlist simply won't select them, which is the safe outcome for a test).

---

## Q4 — Is the CLI's generic plain-string `--field NAME=VALUE` for `schema.type == "string"` correct, or should it ADF-wrap?

Sending a plain string for a nominal `schema.type == "string"` field is a **reasonable, idiomatic
default** for a thin client — the metadata genuinely says "string", and the ADF requirement for
`description`/`environment`/`textarea` is an undocumented-from-metadata special case that even
Atlassian declined to expose. The CLI is not "wrong" here; this is an edge case, and the `jr`
architecture already routes `description` through its own ADF path (`adf.rs`), so the generic
`--field` string path is only exposed to `environment` and `...:textarea` custom fields. A
"maximally well-behaved" client *could* detect the known ADF classes (system `description`/
`environment` + `schema.custom == "...:textarea"`) and ADF-wrap them, and that would be a genuine
product improvement — but it is not required for correctness of the generic path, and it is out of
scope for a *test* whose job is to exercise a plain-string write. The bug here is in the **test's
field-selection heuristic**, not in the CLI's `--field` string behavior.

**Confidence: HIGH** (this is a design-judgment call grounded in the Q1–Q3 findings).

---

## RECOMMENDED FIX — `discover_safe_edit_field` in `tests/e2e_live.rs`

Root cause: the helper (a) *prefers* `environment`, an ADF field, and (b) its fallback accepts any
`schema.type == "string"` field excluding only `summary`/`description` — which is not a safe
plain-string guarantee.

Change the heuristic to select **only Jira built-in single-line text custom fields**:

1. **Remove the `Environment` preference block entirely.** `environment` is ADF-backed and must
   never be chosen for a plain-string write.
2. **Replace the `is_string_field` predicate** with a stricter `is_plain_text_custom_field`:
   accept a field only when
   `schema.type == "string"` AND
   `schema.custom == "com.atlassian.jira.plugin.system.customfieldtypes:textfield"`.
   These will always be `customfield_NNNNN` ids, so the returned `cli_ref` uses the
   `customfield_NNNNN` literal-bypass form (BC-3.4.015 Step 1) — no display-name resolution needed.
3. **Defensive denylist (secondary):** explicitly skip `description` and `environment` even if the
   predicate were ever loosened. Continue skipping `summary`.
4. **Clean-skip semantics unchanged:** return `None` when no `...:textfield` custom field exists on
   the issue's edit screen (the test already treats `None` as a clean skip).

Sketch (illustrative — not to be applied by this agent):

```rust
const PLAIN_TEXTFIELD: &str =
    "com.atlassian.jira.plugin.system.customfieldtypes:textfield";

fn discover_safe_edit_field(h: &E2eHarness, key: &str) -> Option<(String, String)> {
    let v = fetch_raw(h, &format!("/rest/api/3/issue/{key}/editmeta"))?;
    let fields = v.get("fields")?.as_object()?;

    let is_plain_text_custom = |meta: &Value| {
        let schema = match meta.get("schema") { Some(s) => s, None => return false };
        schema.get("type").and_then(Value::as_str) == Some("string")
            && schema.get("custom").and_then(Value::as_str) == Some(PLAIN_TEXTFIELD)
    };

    fields.iter().find_map(|(id, meta)| {
        // Defensive denylist for known ADF/system fields (belt-and-suspenders).
        if matches!(id.as_str(), "summary" | "description" | "environment") {
            return None;
        }
        if !is_plain_text_custom(meta) {
            return None;
        }
        // Built-in textfield => always customfield_NNNNN; use the literal-bypass form.
        Some((id.clone(), id.clone()))
    })
}
```

Doc-comment updates: drop the "prefers `Environment`" language (lines ~5215, ~5224-5228 and the
env-var table at ~51-53) and describe the new rule ("first built-in single-line text custom field,
`schema.custom == ...:textfield`; clean-skip if none"). If a project commonly has no such custom
field, note that `JR_E2E_EDIT_FIELD` override remains the escape hatch.

**Fix confidence: HIGH.** The `...:textfield` allowlist is the documented plain-string class and
directly eliminates the observed 400. Residual risk: a project/issue-type with no single-line text
custom field on its edit screen will now clean-skip instead of testing — acceptable, and the
`JR_E2E_EDIT_FIELD` override covers deliberate coverage on such sites.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 2 | Q1 (environment/description ADF-on-write in v3, universal vs renderer-dependent); Q2 (editmeta/createmeta machine-readable ADF signal, renderer exposure, exhaustive ADF system-field list) |
| Grep / Read | 3 | Located and read `discover_safe_edit_field` + `is_string_field` in `tests/e2e_live.rs` to ground the concrete fix |
| Training data | 1 area | General framing of thin-client design idiom (Q4) — corroborated by the sourced Q1–Q3 findings, not relied on for any factual claim |

**Total MCP tool calls:** 2 (both `perplexity_research`, high depth)
**Training data reliance:** low — every factual claim about Jira v3 behavior and metadata is
sourced to official Atlassian docs or Atlassian issue-tracker tickets; training data used only for
the design-judgment paragraph (Q4).
