# Research: ADF auto-conversion for `jr issue edit/create --field NAME=VALUE` (cycle-012-field-adf-autoconvert)

**Date:** 2026-09-12
**Type:** general (technology / REST API behavior + prior-art)
**Feature under design:** cycle-012-field-adf-autoconvert — make the generic `--field NAME=VALUE`
path on `jr issue edit` and `jr issue create` auto-convert the value to Atlassian Document Format
(ADF) for rich-text / ADF-backed fields, so setting `Environment`, `Description`, and
`...:textarea` custom fields via `--field` succeeds instead of returning
`API error (400): ... Operation value must be an Atlassian Document`.
**Builds on (does not duplicate):** `.factory/research/e2e-environment-adf-field-2026-09-11.md`
(established: v3 `environment`/`description` + `...:textarea` require ADF despite
`schema.type=="string"`, JRACLOUD-75814 Won't-Fix; `...:textfield` = plain string; no generic
machine-readable ADF discriminator).

---

## Executive summary

The prior research's core finding holds and is now extended into a **complete, buildable detection
predicate**. There is still no generic `richText:true`/`format:adf` metadata flag, but the set of
ADF-backed fields reachable through the issue `fields{}`/`update{}` write path is **small, closed,
and reliably identifiable** from `schema.system` + `schema.custom`:

> **`requires_adf(field)` ⇔**
> `schema.system == "description"` **OR** `schema.system == "environment"`
> **OR** `schema.custom == "com.atlassian.jira.plugin.system.customfieldtypes:textarea"`

Everything else settable via `--field` is NOT ADF. No other built-in system field and no other
built-in custom-field type key takes ADF on this path (confidence HIGH). The single unclosable gap
is **third-party Connect `rich_text` / Forge `object` app fields**, which can independently expect
ADF but are NOT inferable from metadata — the safe behavior there is to leave them as plain-string
(status quo: they already 400 today, and mis-wrapping them is no worse).

This predicate is **usable identically on both paths**: the `schema` block is the same
`JsonTypeBean` model in `createmeta` (`FieldCreateMetadata`) and `editmeta` (`FieldMetadata`); only
the outer envelope differs (array vs field-id map), which `jr` already normalizes.

Two implementation landmines surfaced:
1. **`adf::text_to_adf("")` currently emits `{"type":"text","text":""}`** (an empty text node) —
   which is a **documented 400 `INVALID_INPUT`** case (JRACLOUD-79318, closed "Not a bug"). Auto-wrap
   MUST NOT feed an empty string through the existing `text_to_adf` empty branch into a live write.
2. **The JSM create path (`--request-type`) uses a completely different wire mechanism** —
   `isAdfRequest:true` + `requestFieldValues.<id>` as an ADF object, already handled in
   `src/api/jsm/requests.rs` — so it needs separate treatment (see design Q b).

---

## Q1 — Complete ADF-backed custom-field taxonomy (built-in `...:customfieldtypes:*`)

**Confirmed (HIGH):** `...:textarea` requires an ADF doc object on v3 write; `...:textfield` takes a
plain string. Both report `schema.type=="string"` — do NOT branch on `schema.type`. The v3
introduction names `textarea` custom fields specifically as ADF, and `textfield` explicitly as
string-and-does-not-handle-ADF.

Full built-in type-key taxonomy and their v3 write wire-types (union of Atlassian's Jira 9.2
`CustomFieldTypes` enum + Cloud-migration KB + field-creation KB; 21 keys):

| `schema.custom` key (prefix `com.atlassian.jira.plugin.system.customfieldtypes:`) | v3 write value | ADF? |
|---|---|---|
| `textfield` | plain string | No |
| **`textarea`** | **ADF doc object** | **YES** |
| `select` / `radiobuttons` | option object `{"id":…}` or `{"value":…}` | No |
| `multiselect` / `multicheckboxes` | array of option objects | No |
| `cascadingselect` | `{"id":…,"child":{"id":…}}` | No |
| `userpicker` | `{"accountId":…}` | No |
| `multiuserpicker` | array of user objects | No |
| `grouppicker` / `multigrouppicker` | group object(s) `{"name":…}` (or `allowedValues` form) | No |
| `project` | `{"id":…}` or `{"key":…}` | No |
| `version` / `multiversion` | version object(s) `{"id":…}` | No |
| `labels` | array of strings | No |
| `url` | plain string | No |
| `datepicker` | `"YYYY-MM-DD"` string | No |
| `datetime` | ISO-8601 datetime string | No |
| `float` | JSON number | No |
| `importid` | plain scalar (special/deprecated; verify via metadata) | No |
| `readonlyfield` | plain string (writability screen/context-dependent) | No |

**Are there OTHER built-in rich-text/ADF custom types besides `:textarea`?** **No** (HIGH). No other
key in the built-in namespace is documented as ADF-backed.

**Is there a `:paragraph` type key?** **No** (HIGH). "Paragraph" is the newer UI label for the
multi-line text field; its `schema.custom` remains `...:textarea` (confirmed by a Cloud bug report
showing a field named PARAGRAPH with `schema.custom == ...:textarea`, JRACLOUD-82245).

**`:readonlyfield`?** Read-only **text** (string, not ADF). Writability via issue PUT/POST is
screen/operation-dependent and historically contested — check for a `"set"` op in metadata; do NOT
ADF-wrap it. It will never match the predicate (no `schema.custom == ...:textarea`, no ADF system
name), which is the safe outcome.

**Forge/Connect app rich-text fields (`schema.custom` under a vendor namespace):**
- **Connect** has a genuine `rich_text` issue-field descriptor type whose saves typically send ADF —
  BUT this is only visible in the app's own module descriptor, **not** surfaced as any rich-text flag
  in `editmeta`/`createmeta`; `schema.custom` only identifies the owning module (MEDIUM-HIGH: docs
  confirm `rich_text` exists and uses ADF; confirmed there is no metadata read-back flag).
- **Forge** custom fields have **no first-class rich-text/ADF base type** — declared types are
  `string`/`number`/`user`/`group`/`date`/`datetime`/`object`; an `object` may *happen* to contain an
  ADF-shaped value but that is a private app convention, not discoverable (HIGH).
- **Verdict:** app-provided ADF fields are **NOT detectable** from metadata. `jr` cannot safely
  auto-wrap them. Recommended: predicate matches only the built-in `:textarea` key + the two ADF
  system fields; app fields fall through to plain-string (unchanged behavior — they 400 today; this
  cycle does not regress them and must not wrongly wrap them).

Sources (accessed 2026-09-12): Atlassian v3 intro (pub 2023-01-18, upd 2026-08-26)
https://developer.atlassian.com/cloud/jira/platform/rest/v3/intro/ ·
v3 Issues (Create/Edit) https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/ ·
Jira 9.2 `CustomFieldTypes` enum
https://docs.atlassian.com/software/jira/docs/api/9.2.0/com/atlassian/jira/issue/customfields/CustomFieldTypes.html ·
"Single line text or reach text?" (opened 2023-09-10, upd 2026-02-13)
https://community.developer.atlassian.com/t/single-line-text-or-reach-text/72737 ·
PARAGRAPH bug https://jira.atlassian.com/browse/JRACLOUD-82245 ·
Forge custom field manifest (upd 2026-07-08)
https://developer.atlassian.com/platform/forge/manifest-reference/modules/jira-custom-field/ ·
Connect issue-field module (upd 2026-05-13)
https://developer.atlassian.com/cloud/jira/platform/modules/issue-field/ ·
Connect→Forge issue-field migration (upd 2026-05-11)
https://developer.atlassian.com/platform/adopting-forge-from-connect/migrate-jira-issue-fields/

---

## Q2 — Complete ADF-backed SYSTEM field set on the `fields{}` write path

**Answer (HIGH): exactly `description` and `environment`.** No other issue system field settable via
the generic `fields{}`/`update{}` mechanism is documented to require ADF. The v3 intro enumerates ADF
in exactly four places: comment `body`, worklog `comment`, issue `description`/`environment`, and
`textarea` custom fields. Comment and worklog bodies are **not** reachable via the issue `fields{}`
path (per the task, explicitly excluded — they have dedicated endpoints; `jr` already routes comments
through its own ADF path).

- Detection: `schema.system == "description"` or `schema.system == "environment"`.
- `summary` is a plain string (NOT ADF) — must remain excluded.
- On the platform `--field` path in `jr`, `description` is already routed through the dedicated
  `--description`/`adf.rs` path; the generic `--field` string path is realistically only exposed to
  `environment` (system) and `...:textarea` custom fields. But the predicate should include
  `description` for completeness/robustness in case it is reached via `--field "Description"=...`.

Sources: v3 intro + v3 Issues (as above); JRACLOUD-75814 (Won't-Fix; `schema.type:"string"` for
Description is misleading; v2 plain-string is the documented workaround)
https://jira.atlassian.com/browse/JRACLOUD-75814

---

## Q3 — createmeta vs editmeta signal parity

**Answer (HIGH for the schema block; MEDIUM caveat on exhaustive prose guarantee): the same
detection predicate works on both paths.**

- Both endpoints carry a per-field `schema` object of the same published model, `JsonTypeBean`, whose
  properties are `type` (required), `system`, `custom`, `customId`, `items`, `configuration`. So
  `schema.system` appears on system fields and `schema.custom` on custom fields in BOTH responses.
- **Envelope differs (must normalize first):**
  - `GET /rest/api/3/issue/createmeta/{proj}/issuetypes/{itid}` → **paginated array** of
    `FieldCreateMetadata` (each has `fieldId`, `key`, `name`, `required`, `operations`, `schema`);
    values under `values`/`fields`/`results`.
  - `GET /rest/api/3/issue/{key}/editmeta` → **object map** `fields.<field-id>` → `FieldMetadata`
    (field id is the map key, no separate `fieldId`).
  - `jr` already consumes both shapes (`get_createmeta_fields` in `src/api/jira/issues.rs` for the
    create path per S-580-1; editmeta in `field_resolve.rs`). Apply the predicate against
    `field.schema` after the existing normalization.
- **Semantic (not structural) differences to respect:** create metadata reflects the create screen /
  pre-issue context; edit metadata reflects a specific issue's edit screen + workflow-step editability
  + permissions. The two can return **different field sets, `operations`, `required` flags, and
  `allowedValues`** for the "same" field. This does NOT affect the ADF discriminator (which is a
  static property of the field type), but any consumer must still verify the field is present with a
  `"set"` op in the relevant metadata before writing.
- **Could NOT confirm (LOW-impact):** Atlassian publishes no prose promising byte-identical `schema`
  objects across the two endpoints; the conclusion rests on both response models referencing the same
  `JsonTypeBean`. The scoped-createmeta example response in the docs happens to omit the `schema`
  block for its sample (Assignee) field, so a live-response spot-check that `schema.custom`/
  `schema.system` are actually populated on createmeta for a `:textarea`/`environment` field is a
  cheap de-risking step before F1 sign-off. This matches `jr`'s existing S-578-4 assumption that
  createmeta and editmeta share the `dispatch_field_value` resolution.

Sources: v3 Issues (Create/Edit/createmeta/editmeta)
https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/ ·
`JsonTypeBean` model (upd 2026-08-21) https://apis.io/schemas/atlassian/atlassian-jsontypebean/ ·
`FieldCreateMetadata` (upd 2026-09-04) https://apis.io/schemas/atlassian/atlassian-fieldcreatemetadata/ ·
`IssueUpdateMetadata` (upd 2026-08-19) https://apis.io/schemas/atlassian/atlassian-issueupdatemetadata/ ·
createmeta deprecation thread https://community.developer.atlassian.com/t/create-issue-meta-endpoint-deprecation/75413

---

## Q4 — Minimal valid ADF, empty-value, multi-line, and known 400s

**Minimal valid document (HIGH):** `{"type":"doc","version":1,"content":[]}` is valid — root
`content` may be empty; a paragraph is NOT required. The normal non-empty minimal form is a single
paragraph with one text node:
```json
{"type":"doc","version":1,"content":[{"type":"paragraph","content":[{"type":"text","text":"hi"}]}]}
```

**Empty string / clearing (HIGH on the do-nots, MEDIUM on the preferred clear form):**
- **Do NOT emit an empty text node `{"type":"text","text":""}`** — documented 400
  `{"errorMessages":["INVALID_INPUT"]}` (JRACLOUD-79318, "Not a bug"; text nodes must be non-empty).
  **This is exactly what `adf::text_to_adf("")` produces today** (`src/adf.rs` ~line 196–209
  fast-path and the all-blank branch). Auto-wrap must special-case empty/blank input rather than
  route it through `text_to_adf`.
- **To clear a rich-text field:** the ADF-native empty document
  `{"type":"doc","version":1,"content":[]}` is the safest portable representation (documented by
  Atlassian as "the simplest document in ADF"; Jira Cloud tooling — ScriptRunner docs, upd
  2026-09-07 — uses exactly this to clear Description). `null` is the conventional field-clear
  sentinel and is likely accepted on the Edit Issue field-set path, but is NOT explicitly documented
  for these rich-text fields — prefer the empty doc for portability.
- On **create**, simply omit the field when the value is empty (omission = unset). On **edit**,
  omission = leave-unchanged (not clear).
- A single empty paragraph `{"type":"paragraph"}` / `{"type":"paragraph","content":[]}` is valid ADF
  and should be accepted (Jira may normalize it), but is unnecessary.

**Multi-line (HIGH that REST accepts both forms):** two valid encodings — (a) multiple `paragraph`
nodes (paragraph boundaries; what Enter produces in the editor), or (b) one paragraph with
`{"type":"hardBreak"}` nodes between text (line breaks; Shift+Enter). `jr`'s existing
`text_to_adf` already implements a sensible hybrid: split on blank lines (`\n\n`) → paragraphs, and
single `\n` within a block → `hardBreak`, with CRLF normalization and INV-1 (no raw `\r`/`\n` in text
nodes) already enforced. This is well-aligned with what Jira expects and is directly reusable for
auto-wrap of non-empty values.

**Known malformed-but-plausible 400s (HIGH for the specific reproductions, MEDIUM on exact wording
per fault):** empty text node → 400 INVALID_INPUT (JRACLOUD-79318); a `hardBreak` carrying an extra
top-level `text` property → 400 INVALID_INPUT (use bare `{"type":"hardBreak"}`); trailing comma /
literal unescaped newline in JSON source → parser 400; missing root `version`/`content` or
`version != 1` → schema-invalid 400 (exact message not consistently documented). `jr`'s builder
avoids all of these by construction.

Sources: ADF structure (upd 2023-02-02)
https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/ ·
doc node https://developer.atlassian.com/cloud/jira/platform/apis/document/nodes/doc/ ·
text node (must be non-empty)
https://developer.atlassian.com/cloud/jira/platform/apis/document/nodes/text/ ·
hardBreak https://developer.atlassian.com/cloud/jira/platform/apis/document/nodes/hardBreak/ ·
JRACLOUD-79318 (empty text 400) https://jira.atlassian.com/browse/JRACLOUD-79318 ·
ScriptRunner clear-Description-with-empty-doc (upd 2026-09-07)
https://docs.adaptavist.com/sr4jc/latest/features/behaviours/troubleshoot-behaviours ·
"400 INVALID_INPUT" comment thread
https://community.developer.atlassian.com/t/creating-comment-gives-me-400-invalid-input/71646 ·
`@atlaskit/adf-schema` full JSON schema (no `minItems` on root content)
https://app.unpkg.com/@atlaskit/adf-schema@56.0.2/files/json-schema/v1/full.json

---

## Q5 — Strictness re-confirm

**Confirmed (HIGH for the supported contract; MEDIUM-HIGH for "every instance"):** the v3 issue
field-set path strictly requires ADF objects for `description`, `environment`, and `...:textarea`
custom fields; a raw JSON string yields the exact 400 "Operation value must be an Atlassian
Document". There is no documented v3 leniency mode. The requirement is defined by **API version +
field type**, NOT by the field's visual renderer (Wiki vs Default-text) — the v3 Issues docs state it
unconditionally and never branch on renderer config. (Renderer-sensitivity exists in a *different*
surface — Forge UI-modifications `FieldAPI` — which is not this endpoint.) Atlassian publishes no
cross-tenant conformance guarantee, so "universal" is an argument from the categorical documentation
plus the absence of any documented exception; treat apparent plain-string successes as a different
endpoint/version/field-type, not v3 leniency.

Sources: v3 Issues https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/ ·
JRACLOUD-75814 (Won't-Fix) https://jira.atlassian.com/browse/JRACLOUD-75814 ·
JSDCLOUD-10275 (string rejected, v2 works) https://jira.atlassian.com/browse/JSDCLOUD-10275 ·
Forge UI-mods renderer variance (separate surface)
https://developer.atlassian.com/platform/forge/apis-reference/jira-api-bridge/uiModifications/

---

## Q6 — Prior art

**Bottom line (HIGH): none of the four comparable tools does schema-aware automatic plain-text→ADF
wrapping through a generic field setter.** They either sidestep the problem via REST v2 (plain
strings) or require the caller to hand-build an ADF object. **This means `jr`'s planned auto-convert
would be a differentiator, not a catch-up.**

| Tool | Version/date | v3? | Generic field UX | Auto-wraps text→ADF? |
|---|---|---|---|---|
| **ankitpokhrel/jira-cli** (Go) | repo snapshot 2026-09-07; v1.7.0 seen Sep 2026 | Issue ops use **REST v2** (`/rest/api/2/issue/...`) | repeatable `--custom slug=value`; strings + comma-arrays; only configured fields | **No.** v2 avoids ADF; `--custom` treats schema `string` as a plain string. PR #717 (2024-03-12) proposed *manual* JSON custom-field values — i.e. no auto-wrap. Issue #549 (2023-01-12): edit sends Markdown without conversion. |
| **andygrunwald/go-jira** (Go) | stable v1.17.x (REST v2); `main` = v2.0 dev (Cloud client claims v3) | stable v2; dev branch v3 | `IssueFields.Description` is a `string`; custom fields via `Unknowns` map | **No.** Caller must place a hand-built ADF map under the custom-field id. No metadata inference. Issues #738/#741 show v2→v3 migration pain. |
| **pycontribs/jira** (Python) | docs 3.10.6.dev24 (2026-06-19) | **v2 by default**; must override to v3 for ADF (issue #1841, 2024-03-22) | `create_issue(fields=…)` / `issue.update(fields=…)`; values are plain Python objects | **No.** On v3, docs teach users to pass an ADF dict `{"type":"doc","version":1,...}` themselves. |
| **MrRefactoring/jira.js** (TS) | v5.1.0 (2025-05-03) | explicit v2 AND v3 clients | `Version3Client.issues.createIssue({fields})`; ADF modeled as TS types (`document.ts`, `richText.ts`) | **No.** Provides ADF *types* (typed transport) but no `fromPlainText()`/markdown→ADF helper for generic fields. Plain-string convenience exists only for **comments**, endpoint-specific. |

Key distinction: **typed transport vs conversion.** jira.js and Python(v3) can *transport* an ADF
object; go-jira can transport one via a generic map — but none *inspects field metadata and wraps a
supplied string* based on whether the target is `textfield` vs `textarea`. No repo issue containing
the exact "Operation value must be an Atlassian Document" string was located, though closely related
failures are tracked (jira-cli #753, go-jira #741, pycontribs #1841).

Sources: https://github.com/ankitpokhrel/jira-cli (README, discussions/346, issues/549, issues/753,
pull/717) · https://github.com/andygrunwald/go-jira (README, MIGRATE.md, issues/738, issues/741) ·
https://github.com/pycontribs/jira (issues/1841, docs/examples.rst) ·
https://github.com/MrRefactoring/jira.js (README, CHANGELOG.md, v5.1.0 release). All accessed
2026-09-12; library versions per GitHub release pages (not independently re-verified against a
registry beyond the GitHub release/tag pages themselves — flagged MEDIUM on exact latest version).

---

## Recommended detection predicate (for F1)

```
fn requires_adf(schema: &Value) -> bool {
    matches!(schema.get("system").and_then(Value::as_str), Some("description") | Some("environment"))
    || schema.get("custom").and_then(Value::as_str)
        == Some("com.atlassian.jira.plugin.system.customfieldtypes:textarea")
}
```

- Applied against `field.schema` from BOTH createmeta (`FieldCreateMetadata`) and editmeta
  (`FieldMetadata`) after `jr`'s existing envelope normalization.
- Deliberately does NOT key on `schema.type` (the JRACLOUD-75814 trap).
- Deliberately does NOT attempt to match app/vendor `schema.custom` keys — those are not inferable;
  they fall through to plain-string (status quo, safe).
- Belt-and-suspenders: since `jr` routes `--description` through its own ADF path, the generic
  `--field` auto-wrap realistically fires for `environment` + `:textarea` custom fields; keeping
  `description` in the predicate costs nothing and guards `--field "Description"=…`.

**Risk symmetry check (the two failure modes the task flagged):**
- *Miss an ADF field* → predicate would have to fail to match `:textarea`/`environment`/`description`.
  Not possible for built-ins given the categorical docs. Only app rich-text fields are missed — and
  they are undetectable by anyone, so this is the accepted, documented boundary, not a regression.
- *Wrongly wrap a plain-text field* → predicate would have to match a `textfield`/`url`/etc. It keys
  on the exact `:textarea` literal and two exact system names, so a plain built-in cannot match. Only
  hazard: a hypothetical app field that reuses the literal `:textarea` key (not possible — app fields
  use vendor namespaces). LOW risk.

---

## Answers to the 3 pending design questions

**(a) Plain-text vs Markdown conversion this cycle — RECOMMEND: plain-text (`text_to_adf`) this
cycle; do NOT invoke `markdown_to_adf` on the auto-wrap path.**
Rationale: (1) the `--field` value is a single `NAME=VALUE` token, typically short/literal, and a
user setting `Environment=Ubuntu 22.04 / prod` does not expect `*`/`_`/`#`/`-` to be reinterpreted as
Markdown — silent Markdown parsing would be a surprising, hard-to-escape transform (and `jr` already
carries `allow_hyphen_values` foot-guns on free-text args). (2) Correctness scope is minimal and
provable with `text_to_adf` (which already handles CRLF/newline/hardBreak/paragraph structuring and
enforces INV-1). (3) `--description`/`--description-stdin` remain the Markdown-aware channel for rich
authoring; keeping `--field` plain-text preserves a clean separation. If a Markdown-on-`--field`
opt-in is ever wanted, add it later as an explicit hint (e.g. `NAME:markdown=...`) consistent with the
existing `:option`/`:id`/`:name`/`:asset` hint-kind grammar in `field_resolve.rs` — but that is out of
scope for this cycle. Confidence: HIGH (design judgment grounded in Q4 + repo conventions).

**(b) Does the JSM create path (`--request-type`) need different handling — YES, and it is largely
already handled.**
The JSM request path does NOT use the issue `fields{}` ADF contract. `src/api/jsm/requests.rs`
(`JsmRequestBuilder::build`) sends `requestFieldValues.<id>` as an ADF object together with a
top-level `isAdfRequest:true` flag (BC-3.8.006), and already converts `description` via
`text_to_adf`/`markdown_to_adf_*`. Consequently:
- For the JSM create path, an auto-wrapped `--field` value destined for a rich-text field must be
  placed in `requestFieldValues` as an ADF object AND the request must set `isAdfRequest:true`
  whenever any ADF value is present — matching the existing description handling, NOT the platform
  `fields{}` shape.
- Detection differs too: JSM request-type fields are discovered via the requesttype-fields endpoint
  (`src/api/jsm/request_types.rs`), not createmeta/editmeta, so the `schema.custom`/`schema.system`
  predicate may not be uniformly available on that metadata. Recommend: for the JSM path this cycle,
  scope auto-wrap conservatively (mirror the existing description ADF handling; treat other
  rich-text RT fields as a documented follow-up if the requesttype-fields metadata does not expose a
  reliable ADF discriminator). Flag this explicitly in F1 as a path-divergence with its own AC.
Confidence: HIGH that the mechanism differs (verified in-repo + BC-3.8.006); MEDIUM on whether JSM
requesttype-fields metadata carries the same discriminator — worth a live probe before committing JSM
scope.

**(c) Recommended empty-value semantics — RECOMMEND:**
- **`--field NAME=` (empty value) on EDIT of a rich-text field → clear via the empty ADF document**
  `{"type":"doc","version":1,"content":[]}`. Do NOT route empty through `text_to_adf` (it emits an
  empty text node → 400 INVALID_INPUT, JRACLOUD-79318). Special-case empty/whitespace-only input in
  the auto-wrap function.
- **On CREATE**, an empty `--field` value for a rich-text field should omit the field (or, if the
  user explicitly wants it set-empty, use the empty doc). Prefer omission to avoid meaningless writes.
- Optionally reserve `null`-clear semantics for a future explicit "unset" affordance; do not rely on
  `null` for rich-text fields this cycle (not explicitly documented for them).
- Add a regression test asserting the auto-wrap function never emits `{"type":"text","text":""}`.
Confidence: HIGH on the do-not (empty text node is a documented 400); MEDIUM-HIGH on empty-doc as the
preferred clear form (documented by Atlassian + third-party tooling, not by the issue endpoint page
verbatim).

---

## Inconclusive / to de-risk before F1 sign-off (cheap live probes)

1. **createmeta actually populates `schema.custom`/`schema.system`** for a `:textarea`/`environment`
   field (docs sample omits the schema block). One `GET createmeta/{proj}/issuetypes/{itid}` against
   the live test site confirms it. (LOW risk — `jr`'s S-578-4 already assumes parity.)
2. **JSM requesttype-fields metadata ADF discriminator** availability (design Q b). One
   requesttype-fields fetch confirms whether the same predicate is usable there.
3. **`null` vs empty-doc clear** on the live Edit Issue path for `environment` (design Q c) — pick the
   form that the live site accepts; default to empty-doc.

None of these blocks the detection-predicate decision (Q1/Q2/Q3), which is the highest-priority and is
HIGH-confidence.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 4 | Q1 built-in custom-field taxonomy + Forge/Connect detectability; Q2 ADF system-field set + Q3 createmeta/editmeta schema parity; Q4/Q5 minimal ADF + empty/multiline/malformed 400s + strictness/renderer-independence; Q6 prior-art across jira-cli/go-jira/pycontribs-jira/jira.js |
| Read / Grep | 4 | Read prior research file; grounded `adf::text_to_adf` empty-string behavior (`src/adf.rs`), the JSM `isAdfRequest` mechanism (`src/api/jsm/requests.rs`), and confirmed helper signatures |
| Training data | 1 area | Design-judgment framing for Q(a) plain-text-vs-Markdown; corroborated by Q4 findings and in-repo conventions, not relied on for any factual API claim |

**Total MCP tool calls:** 4 (all `perplexity_research`, high depth)
**Training data reliance:** low — every factual claim about Jira v3 behavior, metadata models, ADF
structure, and prior-art tool behavior is sourced to official Atlassian docs, Atlassian issue-tracker
tickets, published API schema models, or the tools' own GitHub repos, each dated; training data used
only for the plain-text-vs-Markdown design-judgment paragraph.
