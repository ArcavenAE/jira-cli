# JSM requesttype-fields ADF discriminator probe

**Date:** 2026-09-12
**Author:** DX Engineer (read-only live probe)
**Question:** In the JSM `/rest/servicedeskapi/servicedesk/<ID>/requesttype/<RTID>/field`
response, what metadata distinguishes a rich-text (ADF-backed) field from a plain single-line
text field? Is there a reliable discriminator for "this field needs ADF on write"?

**Verdict: NO generic structural discriminator exists. The reliable approach is a known-field
allowlist keyed on `jiraSchema.system` and `jiraSchema.custom`.**

---

## Method

Live read-only probe against the E2E Jira Cloud instance (URL redacted as `<INSTANCE>`).
Profile: `e2e-api` (api_token auth). All calls GET-only via `jr api`.

Service desk found: 1 service desk (`<PROJ-JSM>`, project key `EJ`).
Request types discovered: 9 total (service request + incident types).
All 9 request types probed for field metadata.

Endpoints hit:
- `GET /rest/servicedeskapi/servicedesk`
- `GET /rest/servicedeskapi/servicedesk/1/requesttype`
- `GET /rest/servicedeskapi/servicedesk/1/requesttype/<N>/field` (all 9 request types)
- `jr requesttype fields <NAME> --project EJ --output json` (cross-check)

---

## Field metadata shape

The JSM requesttype-fields API wraps the Jira schema under a `jiraSchema` key (not `schema`
as in createmeta/editmeta). The inner content is structurally identical: same
`type`/`system`/`custom`/`customId`/`items` sub-keys, same values. Example full field object:

```json
{
  "fieldId": "description",
  "name": "Describe what happened and how it occurred",
  "description": "",
  "required": true,
  "defaultValues": [],
  "validValues": [],
  "autoCompleteUrl": null,
  "jiraSchema": {
    "type": "string",
    "system": "description"
  },
  "visible": true
}
```

Top-level keys per field: `fieldId`, `name`, `description`, `required`, `defaultValues`,
`validValues`, `autoCompleteUrl`, `jiraSchema`, `visible`. No additional metadata keys
observed. No `isADF`, `renderedType`, `jsonType`, or similar flag is present.

---

## Side-by-side comparison: ADF vs plain-text fields

### `description` field — ADF-backed (rich text)

```json
{
  "fieldId": "description",
  "jiraSchema": {
    "type": "string",
    "system": "description"
  }
}
```

### `summary` field — plain single-line text

```json
{
  "fieldId": "summary",
  "jiraSchema": {
    "type": "string",
    "system": "summary"
  }
}
```

**Critical observation:** Both `description` (ADF) and `summary` (plain text) have exactly
the same `jiraSchema.type` value (`"string"`). There is NO structural difference in type.
The ONLY difference is the `system` value: `"description"` vs `"summary"`.

### `customfield_10044` (Affected hardware) — plain single-line custom text field

```json
{
  "fieldId": "customfield_10044",
  "jiraSchema": {
    "type": "string",
    "custom": "com.atlassian.jira.plugin.system.customfieldtypes:textfield",
    "customId": 10044
  }
}
```

Same `type: "string"` as `description`. Discriminated only by `custom` key presence and its
value (`:textfield` not `:textarea`).

### Additional field types observed for completeness

| fieldId | `jiraSchema.type` | `jiraSchema.system` | `jiraSchema.custom` |
|---|---|---|---|
| `summary` | `string` | `summary` | — |
| `description` | `string` | `description` | — |
| `attachment` | `array` | `attachment` | — |
| `components` | `array` | `components` | — |
| `duedate` | `date` | `duedate` | — |
| `customfield_10044` | `string` | — | `...textfield` |
| `customfield_10050` | `option` | — | `...select` |
| `customfield_10004` | `option` | — | `...select` |
| `customfield_10045` | `array` | — | `...service-entity-field-cftype` |

---

## What the discriminator IS

Since no generic type-level flag exists, the ADF discriminator must be a **known-field
allowlist** keyed on `jiraSchema.system` and `jiraSchema.custom`:

| Condition | ADF needed? | Rationale |
|---|:---:|---|
| `jiraSchema.system == "description"` | **YES** | System description field, always ADF |
| `jiraSchema.system == "environment"` | **YES** | System environment field, always ADF (not observed in JSM RTs in this instance, but confirmed ADF on platform editmeta/createmeta in prior probe) |
| `jiraSchema.custom` ends with `:textarea` | **YES** | Custom rich-text field type — not present in this test instance but follows from the platform pattern |
| `jiraSchema.system == "summary"` | NO | Plain single-line text |
| `jiraSchema.custom` ends with `:textfield` | NO | Custom single-line text |
| Any other `type: "option"`, `type: "date"`, `type: "array"` | NO | Not string, not ADF |

**No textarea custom field was available in this test instance.** The `:textarea` entry in the
table above is inferred from:
1. The platform probe (prior report) which confirmed `schema.custom = "...textarea"` on
   createmeta/editmeta for textarea fields.
2. The finding from this probe that `jiraSchema` inner content is structurally identical to
   `schema` inner content — so the same custom-type key would appear there too.

---

## Implementation note: `schema` vs `jiraSchema` key name

| Path | Schema wrapper key | Inner structure |
|---|---|---|
| Platform `createmeta` | `schema` | `{type, system?, custom?, customId?, items?, configuration?}` |
| Platform `editmeta` | `schema` | same |
| JSM requesttype-fields | `jiraSchema` | same inner keys/values |

The ADF-detection predicate itself can be identical across both paths; only the wrapper key
name differs. A shared helper that accepts the inner schema object (extracted from either
`field.schema` or `field.jiraSchema`) and applies the allowlist check will work for both.

---

## Conclusion

**There is no structural/generic metadata discriminator** for ADF vs plain-string fields in
the JSM requesttype-fields API. `description` (ADF) and `summary` (plain text) are both
`type: "string"` with a `system` key — indistinguishable by type alone.

The reliable implementation is a **known-field allowlist** based on:
1. `jiraSchema.system == "description"` or `"environment"` → ADF
2. `jiraSchema.custom` suffix `:textarea` → ADF
3. Everything else → not ADF

This is the same predicate logic as the platform path; only the wrapper key (`jiraSchema` vs
`schema`) differs between the two code paths.

---

## Privacy note

All real instance hostnames, cloud IDs, request-type names (beyond generic descriptions),
project names beyond `EJ`, accountIds, and customer data have been redacted or replaced with
placeholders. Only field schema shapes and type-key values are recorded here.
