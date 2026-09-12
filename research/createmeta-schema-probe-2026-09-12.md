# createmeta vs editmeta schema parity probe

**Date:** 2026-09-12
**Author:** DX Engineer (read-only live probe)
**Question (H2):** Does `createmeta` populate `schema.custom` and `schema.system` for fields
the same way `editmeta` does — specifically for rich-text (`:textarea`) custom fields and for
the `environment`/`description` system fields?

**Verdict: YES (with one caveat noted below)**

---

## Method

Live read-only probe against the E2E Jira Cloud instance (instance URL redacted as `<INSTANCE>`).
Profile: `e2e-api`. All calls were GET-only via `jr api`.

Three projects available: `<PROJ-JSM>` (JSM/service_desk), `<PROJ-KANBAN>` (software/kanban),
`<PROJ-SCRUM>` (software/scrum).

Endpoints hit:
- `GET /rest/api/3/field` — enumerate custom field types present in the instance
- `GET /rest/api/3/issue/createmeta/<PROJECT>/issuetypes/<ITID>` — createmeta fields
- `GET /rest/api/3/issue/<KEY>/editmeta` — editmeta fields on existing issues
- `GET /rest/api/3/project/search` — project discovery (no content read)

---

## Findings

### 1. `description` (system field)

| Endpoint | Raw `schema` block |
|----------|-------------------|
| createmeta (Bug) | `{"type": "string", "system": "description"}` |
| editmeta (Bug) | `{"type": "string", "system": "description"}` |

**Identical.** `schema.system` is populated; `schema.custom` key is absent (not empty string).

---

### 2. `environment` (system field)

| Endpoint | Raw `schema` block |
|----------|-------------------|
| createmeta (Bug) | `{"type": "string", "system": "environment"}` |
| editmeta (Bug) | `{"type": "string", "system": "environment"}` |

**Identical.** `schema.system` is populated; `schema.custom` key is absent.

---

### 3. Custom field — `customfield_10044` (`textfield` type, string)

The instance has no `textarea` custom fields. The closest analog available is
`customfield_10044` ("Affected hardware"), custom type
`com.atlassian.jira.plugin.system.customfieldtypes:textfield`, which differs from `textarea`
only in the suffix (`:textfield` vs `:textarea`). Both are `type: string` with a single-line
vs multi-line distinction that the schema alone does not encode.

| Endpoint | Raw `schema` block |
|----------|-------------------|
| createmeta (Incident) | `{"type": "string", "custom": "com.atlassian.jira.plugin.system.customfieldtypes:textfield", "customId": 10044}` |
| editmeta | N/A — no Incident issues exist in the test project to check |

**Createmeta does populate `schema.custom` for this custom string field.** No Incident issue
existed to provide an editmeta counterpart. However (see §4 below), the pattern holds for
every other custom field type that could be cross-checked.

---

### 4. Custom field cross-check — `customfield_10001` (Team, confirmed on both endpoints)

This field appeared in BOTH createmeta (Bug) and editmeta (Bug issue), providing a direct
byte-for-byte comparison:

| Endpoint | Raw `schema` block |
|----------|-------------------|
| createmeta | `{"type": "team", "custom": "com.atlassian.jira.plugin.system.customfieldtypes:atlassian-team", "customId": 10001, "configuration": {"com.atlassian.jira.plugin.system.customfieldtypes:atlassian-team": true}}` |
| editmeta | `{"type": "team", "custom": "com.atlassian.jira.plugin.system.customfieldtypes:atlassian-team", "customId": 10001, "configuration": {"com.atlassian.jira.plugin.system.customfieldtypes:atlassian-team": true}}` |

**Byte-for-byte identical.** `schema.custom` and `customId` are present in both.

---

## Summary of schema key presence rules (observed)

| Field kind | `schema.type` | `schema.system` | `schema.custom` | `schema.customId` |
|-----------|:---:|:---:|:---:|:---:|
| System field (description, environment) | present | populated | absent | absent |
| Custom field (any) | present | absent | populated | populated |

These rules hold identically in **both** `createmeta` and `editmeta` responses.

---

## Implication for ADF-detection predicate on the `jr issue create --field` path

An ADF-detection predicate keyed on `schema.system` (for system fields) or `schema.custom`
(for custom fields) will work correctly on the `createmeta` path in the same way it works on
the `editmeta` path. Specifically:

- `schema.system == "description"` and `schema.system == "environment"` will fire as expected
  on the create path.
- A `textarea` custom field — if present in a project's create screen — will have
  `schema.custom == "com.atlassian.jira.plugin.system.customfieldtypes:textarea"` in
  `createmeta`, consistent with the `textfield` analog observed and consistent with the
  cross-endpoint parity confirmed for every other custom field type.

### Caveat

This instance has no `textarea` fields. The `:textarea` pattern is inferred from:
1. The `:textfield` field observed in createmeta (`schema.custom` populated, same structure).
2. Byte-for-byte createmeta/editmeta parity confirmed on every field type that could be
   cross-checked (`description`, `environment`, `customfield_10001`, `customfield_10015`).

Confidence is HIGH but not directly observed for the exact `:textarea` suffix. If a textarea
field needs to be confirmed empirically, it would require a test instance with such a field
configured on a project's create screen.

---

## Privacy note

All real instance hostnames, cloud IDs, issue keys, account IDs, user names, project names,
and org-specific data have been redacted or replaced with generic placeholders. Only field
schema shapes (type/custom/system values and field type keys) are recorded here.
