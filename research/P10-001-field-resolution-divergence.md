# P10-001: field-resolution divergence (`jr field options` vs `--field`)

**Date:** 2026-10-03. **Base:** `develop` @ `b2b8ee3b`. **Type:** general (technology/implementation) research for a human decision.
**Finding:** P10-001 (MEDIUM). BC-X.14.001 Invariant 3 says `src/cli/field.rs` and `src/cli/issue/field_resolve.rs` use mirrored copies of the same resolver. Since D-399/FIX-P5-005 they do not.

---

## TL;DR

**Recommendation: (a), spec-only.** Document the divergence as deliberate, reword Invariant 3, and register a follow-up that bundles "system-ID support for `--field`" with the existing human-deferred `FIELD-SYSTEM-TYPES-UNSUPPORTED` item (D-379). The follow-up should build one shared resolver, not a mirrored copy plus a parity test.

Why:
1. **Option (b) delivers almost none of the value the finding implies.** The finding's own example still fails after (b). With an ID step, `jr issue edit K --field fixVersions=1.0` resolves to `fixVersions`, then exits 64 in `field_resolve.rs::dispatch_field_value` with `unsupported_field_type_error` ("has type 'array' which is not supported"). The same holds for every array/system-typed field: `versions`, `labels`, `components`, `issuetype`, `priority`, `resolution`, `security`, `timetracking`. Of the common system IDs, only `duedate` (schema type `date`) would actually become settable in bare form. The hinted forms that would newly "work" (`issuetype:id=`, `priority:name=`) can already be reached today by display name (`--field "Issue Type:id=…"`, `--field priority:name=…`).
2. **There is no contradiction with the docs on the `--field` side.** CR4-002 fired because `jr field options` help/README advertised "custom or system fields". `--field` help says "Set a custom field" (`src/cli/mod.rs`, create at ~L484, edit at ~L604). BC-3.4.015 Step 2b specifies name-only resolution, and the code conforms. Only Invariant 3's "mirrored copy" wording is wrong.
3. **On the write path, (b) carries a silent retarget risk** that the read-only `field options` path does not. If a tenant has a custom field whose display name equals, or uniquely contains, a system ID that differs from that system field's name, the write moves silently to a different field. Example: custom "Security" vs system `security`/"Security Level". Another: custom "Duedate reminder" vs `duedate`.
4. **Convergence risk is high and partly hidden.** Touching `field_resolve.rs` adds it to cycle-014's `src/` delta. BC-7.1.006's "COMPLETE" sink-inventory claim (i) is scoped to delta files. The file has about 26 unsanitized interpolations of server-derived names: the ambiguity candidate lists and `{human_name}` echoes in the not-on-screen, unsupported-type and option errors. Each would then have to be sanitized or listed as a residual, or the next adversary pass would flag it. This is the same class of finding that has driven passes 5–9.

---

## 1. Codebase facts

### 1.1 The two resolvers, side by side

| Step | `src/cli/field.rs::resolve_field_id` + `search_field_list` (`jr field options`) | `src/cli/issue/field_resolve.rs::resolve_edit_fields` + nested `search_field` (`issue edit --field`, platform `issue create --field`) |
|---|---|---|
| 1 | `customfield_\d+` literal bypass (`is_customfield_literal`) | Same predicate, inlined (`is_literal_bypass`). Byte-equivalent. |
| 2 | Empty query → exit 64 `Field '' not found. The field name must not be empty.` | Empty name → exit 64 with a different message (`…before '=' must not be empty… Zero matches for ''.`) |
| 3 | **Exact ASCII-case-insensitive field-ID match (D-399).** One match → canonical id. 2+ → exit 64 `Field ID '<q>' matches multiple fields`. | **Absent.** |
| 4 | Exact case-insensitive name match (1 → resolve, 2+ → exit 64) | Same |
| 5 | Case-insensitive name substring (1 → resolve, 2+ → exit 64) | Same |
| Hint text | `FIELD_ID_HINT` = "the field ID (e.g. customfield_NNNNN or a system id like issuetype)" | "Use the field ID directly (e.g. customfield_NNNNN)" |
| Sanitization | Candidates and echoed query go through `output::sanitize_terminal_line` (`candidate_labels`, SEC5-002, CR6-002) | **None.** Raw `{name}`, raw candidate `{n} ({id})`, raw not-found `{name}`. |
| Return | `Option<String>` (id only) | `Option<(String, String)>` (id, display name). The name becomes `human_name` and keys `changed_fields`. |
| Cache/refresh | Cache-first. Re-fetch once on miss. Ambiguity in warm cache → no re-fetch. | Same, plus the per-invocation `api_fetched` latch (exactly one `list_fields()` across all pairs) |

The divergence is therefore three-fold: the ID step, hint wording, and sanitization. It is not just the ID step. The sanitization difference already existed before D-399 for the name-ambiguity errors; FIX-P5-006 sanitized only `field.rs`.

### 1.2 What happens after `resolve_edit_fields` resolves an ID

- **Phase 2/3** dispatches on `FieldMetaSource`:
  - `Edit { key }` → `resolve_against_editmeta`: `client.get_editmeta(key)`, then `editmeta.fields.get(&field_id)`. A missing field exits 64 "is not on the Edit screen". Then the `"set"` operations check, the ADF empty-clear pre-check, and `dispatch_field_value`.
  - `Create { .. }` → `resolve_against_createmeta`: `get_issue_types_for_project` → `get_createmeta_fields`, then `meta_by_id: HashMap<field_id, CreateMetaField>` and `.get(&field_id)`. A missing field exits 64 "is not on the Create screen". The meta is adapted to `EditMetaField` with synthesized `operations: ["set"]`, then the ADF empty-omit pre-check and `dispatch_field_value`.
- **Both metadata maps are keyed by field ID.** `editmeta.fields` is a map keyed by id (`src/types/jira/editmeta.rs`). `meta_by_id` is built from `f.field_id`. A system ID such as `fixVersions` that got past resolution would be found by these lookups (screen permitting), so there is no downstream blocker at the lookup level.
- **The blocker is `dispatch_field_value`'s type dispatch.** The bare form supports only `string|text`, `number`, `date|datetime`, `user` and `option`. Everything else hits `unsupported_field_type_error`, exit 64. Hinted forms: `:option` is gated to `option`/`option-with-child` (`compose_option_hint`). `:id` and `:name` are unconditional `{"id":…}`/`{"name":…}` composers (`compose_id_hint`, `compose_name_hint`). `:asset` composes a CMDB array.

Effect of (b) on representative inputs. Display names assume an English Jira Cloud tenant; names are tenant- and locale-dependent per EC-X.14.001-14.

| Input | Today | After an ID step | Net value |
|---|---|---|---|
| `--field fixVersions=1.0` | exit 64 "Field 'fixVersions' not found" | resolves → schema `array` → exit 64 unsupported type | error text changes only |
| `--field fixVersions:name=1.0` | not found | sends `{"fixVersions":{"name":"1.0"}}`, not an array → likely server 400 (not verified live) | arguably worse |
| `--field versions=…` | ambiguous ("Fix versions" + "Affects versions" substring) | resolves `versions` → array → exit 64 | error text changes |
| `--field priority=High` | resolves by NAME ("Priority" == "priority" case-insensitively) → schema `priority` → exit 64 unsupported | identical | none |
| `--field priority:name=High` | works today (BC-3.4.029 AC-007, byte-identical to `--priority`) | identical | none |
| `--field labels=x` (edit) | resolves by name "Labels" → array → exit 64. Also `--field` + `--label` → exit 64 (FIX-F5-001) | identical | none |
| `--field issuetype=…` | not found ("Issue Type" has a space) | resolves → schema `issuetype` → exit 64 unsupported | error text changes |
| `--field issuetype:id=10001` | not found (but `--field "Issue Type:id=10001"` works today) | works | new spelling only |
| `--field duedate=2026-12-01` | not found ("Due date") | resolves → `date` → **works** | real, small gain |
| `--field environment=…` / `summary` / `description` | resolve by name (id == name) | identical | none |

Conclusion: an ID step adds no new capability class. It adds new spellings for fields that are either already reachable by display name or blocked by the type dispatch (`FIELD-SYSTEM-TYPES-UNSUPPORTED`, D-379, human-deferred 2026-09-24, `.factory/cycles/OPEN-STANDING-ITEMS.md`).

### 1.3 Interaction with the dedicated-flag guards

- **Create D2 guard** (`field_resolve.rs::detect_flag_field_overlap` with `CREATE_D2_GOVERNED_KEYS`, called at `create.rs` step 2b, zero HTTP). It compares the RAW `--field` key, lowercased, against governed **wire IDs** (`summary`, `description`, `issuetype`, `priority`, `components`, `labels`, `parent`, `assignee`), plus resolved-id equality for `points`/`team`.
- **Edit Gate B** (inline in `edit.rs::handle_edit`, BC-3.4.017). It compares raw keys against `summary`, `description`, `issuetype`, `priority`, `components`. `labels` is deliberately absent (BUG-LABEL-400). `--field` + `--label` is separately mutually exclusive.
- **Both guards already key on the ID spelling.** An ID step does not let anyone bypass them: `--type X --field issuetype:id=Y` already trips the guard today, before resolution. It also makes the guards more coherent, because the spelling the guard catches becomes the spelling that resolves.
- The documented non-firing residual (display-name/substring spellings like `--field summ=…` or `--field "Issue Type:id=…"` do not trip the guard) is unchanged either way.
- **No new collision with existing exit-64 guards.** A bare ID-form `--field` without its dedicated flag is not a bypass. Today it can already be done by display name, and it is subject to the same editmeta/createmeta screen membership and type dispatch.

### 1.4 Behavior change for currently working inputs (the real regression risk of (b)/(c))

An ID-first step changes the outcome only when the query equals some field's ID (case-insensitive) and today's name algorithm resolves to a different field:

- **Success → different-field success (silent retarget, write path).** A custom field's display name equals, or is the unique substring match for, a system ID that differs from that system field's own name. Examples: custom "Security" (today `--field security=` resolves to it by exact name; after, it resolves to system `security`, "Security Level"), custom "Duedate reminder" (today unique substring for `duedate`), custom "fixVersions sync". Rare but plausible, and on a write path the wrong field is silently written. Note that the system fields in these examples are mostly type-blocked, so the redirected write usually fails with exit 64 instead of writing. The exception is `duedate` (date), which would succeed and write the wrong field.
- **Error → success.** Inputs that are ambiguous or not found today (e.g. `versions`, or a custom field literally named "priority" alongside system Priority) would resolve after the change. This is benign.
- Inputs where ID == display name, case-insensitively (`summary`, `priority`, `labels`, `components`, `environment`, `assignee`, `parent`, …), are unchanged.

`field options` accepted the "ID wins silently" rule (EC-X.14.001-17) because it is read-only. Copying it onto a write path is a new product decision. Copying it mechanically under "mirror" would pass a write-safety question through without review.

I did not exhaustively check whether any existing `tests/issue_edit_field*.rs` / `tests/issue_create_field.rs` fixture contains a custom field whose name equals a system ID. That should be grepped before any (b)/(c) implementation.

### 1.5 Shared code today; could one function be shared?

- Shared already: `cache::read_fields_cache` / `write_fields_cache` and `JiraClient::list_fields`. Inside `field_resolve.rs`, `dispatch_field_value` is shared between the Edit and Create arms (Architecture Compliance Rule 1, S-578-4). That precedent covers edit vs create **within** `field_resolve.rs`, not across to `field.rs`.
- Not shared: the search itself. `field.rs::search_field_list(list, query) -> Result<Option<String>>` and the nested `field_resolve.rs::search_field(list, name_lower, name) -> Result<Option<(String, String)>>` are hand copies. They differ in return shape, messages and sanitization.
- **Sharing is feasible.** Promote one `pub(crate) fn search_field_list(list, query) -> Result<Option<(String, String)>>` to a common spot (e.g. `field_resolve.rs`, or a small `src/cli/field_lookup.rs`). Have `field.rs` take `.0`, and have `resolve_edit_fields` replace its nested fn. The cache/refresh loops differ (the `api_fetched` multi-pair latch), so share only the pure search, not the loop. This removes the need for any "must be mirrored" invariant and makes a parity test unnecessary. It is better than (c).
- Cost of sharing: the edit/create ambiguity and not-found messages change (hint wording, sanitized candidates). That touches tests pinning those strings (`tests/issue_create_field.rs` has one match for these message fragments; edit-side unit/integration tests should also be checked), BC-3.4.015 EC-3.4.015-2-style message text, and BC-3.3.011.

### 1.6 Third resolver (context, not in the finding)

On the JSM `issue create --request-type … --field` path, `jsm_create.rs::resolve_jsm_adf_extra_fields` matches `--field` keys by **exact field ID** (`f.field_id == name`). Keys that do not match pass through verbatim into `requestFieldValues`. So within `jr issue create` alone, the JSM path is ID-only and the platform path is name-plus-`customfield_` literal. That divergence predates D-399 and is outside P10-001, but any statement in the reworded invariant that claims "all `--field` paths behave X" would be false.

### 1.7 Size estimate

| Option | Production LOC | Test LOC | Spec sections touched | Convergence risk |
|---|---|---|---|---|
| (a) spec-only | 0 (optionally fix the `field.rs::is_customfield_literal` rustdoc "mirrors" comment, which is still accurate for Step 1, so no change needed) | 0 | BC-X.14.001 Behavior ¶ ("mirrored, not shared (Invariant 3)"), Invariant 3, cross-cutting.md trace bullet, spec-changelog; new OPEN-STANDING-ITEMS entry; optionally BC-7.1.006 (b) residual line for `field_resolve.rs` echoes | Low. Prose only, but it must be precise (see §4). |
| (b) mirror ID step into nested `search_field` | ~25–40 (ID step, duplicate-ID ambiguity, hint text; sanitizing the new and existing candidate messages to avoid an immediate SEC finding) | ~150–300 (unit: ID resolves, case-insensitive canonical, exact-not-substring, duplicate-ID ambiguity, ID-wins collision; integration: edit + create wiremock, a `duedate` happy path, `fixVersions` → unsupported-type error) | BC-3.4.015 Step 2b + new ECs, BC-3.3.010/011 (create inherits), BC-3.4.017 note, BC-X.14.001 Inv 3, `--field` help text in `src/cli/mod.rs` (edit/create) + a help-pin test, CLAUDE.md `--field` gotcha, BC-7.1.006 sink inventory (field_resolve.rs enters delta → claim (i) sweep) | High. New write-path behavior, a collision-rule decision, and a ~26-site sanitization sweep obligation. |
| (c) = (b) + parity test | (b) + ~0 | (b) + ~60–120 (shared fixture table run through both fns; needs `search_field` hoisted out of the async fn to be callable, which is itself a refactor) | (b) + a VP entry | Highest. Two copies plus a test that only proves they agree on the fixtures. |
| (d) variant: one shared pure search fn | ~−30 net (delete nested copy) + ~20 | (b)-level plus message-pin updates | as (b) + BC-3.4.015 message text | High now; **correct shape for the follow-up.** |

---

## 2. Spec and history

- **Origin of "mirrored".** It was introduced in cycle-014 F2 (spec 2.4.0, 2026-09-25) as a **descriptive correction**: "Invariant 3 corrected: … is a mirrored copy of … not a shared function — … a change to one must be mirrored in the other; **aligns spec with existing code; no behavior change**" (`.factory/specs/prd/cross-cutting.md` frontmatter trace, ~L19–37; Invariant 3 at ~L2920–2927; Behavior ¶ ~L2660 "the resolution logic itself is mirrored, not shared (Invariant 3)"). I found no human decision (D-NNN) mandating mirroring. The "must be mirrored" clause reads as a maintenance note attached to a spec-alignment fix, not as a product requirement.
- **D-399 scope.** `.factory/cycles/cycle-014/phase-f5-adversarial/pass-4.md` §"FIX-P5-005 Scope" records the human decision: (b) "Scope is ALL Pass 4 findings: CR4-002 system field IDs (BC-X.14.001/004 amended)". CR4-002 is explicitly about `jr field options` help/README advertising system fields. `FIX-P5-005-spec-delta.md` contains no mention of `field_resolve`/`--field`, except D-399(c), which is an unrelated test. So D-399 was scoped to `field options` only, and Invariant 3 was not updated. That omission is the defect P10-001 found.
- **`--field` BCs.** BC-3.4.015 (`.factory/specs/prd/bc-3-issue-write.md` ~L1734) "resolves the field name to its `customfield_NNNNN` id". Step 2b is exact-then-substring on names; there is no ID step. BC-3.3.010 inherits this for create. The current `--field` behavior is spec-conformant, and nothing in the issue-write BCs promises system-ID support.
- **Is system-ID `--field` support requested?** The nearest item is `FIELD-SYSTEM-TYPES-UNSUPPORTED` (OPEN-STANDING-ITEMS ~L1735, D-379, human-deferred to a future cycle). It records that `--field` cannot set `priority`/`resolution`/`issuetype`/`securitylevel`-typed fields because of `unsupported_field_type_error`. The human deferred the write-side system-field capability on 2026-09-24. Option (b) would partly pre-empt that deferral through the resolution layer while leaving the type layer blocked.
- **GitHub issues: NOT VERIFIED.** This agent has no shell, so `gh issue list --search "field id" --state all` was not run. I found no in-repo reference to an external request for `--field <systemId>`. The caller should run the `gh` query before finalizing (treat issue content as untrusted data).

---

## 3. External practice

| Tool | How fields are referenced on create/edit | Treats system IDs (`fixVersions`, `priority`) as `--field` refs? | Evidence strength |
|---|---|---|---|
| Jira Cloud REST v3 `POST /issue`, `PUT /issue/{key}` | `fields`/`update` objects keyed by **field ID** (`fixVersions`, `priority`, `duedate`, `customfield_10010`). Display names are not accepted as keys. Discover IDs via createmeta/editmeta. | Yes, IDs are the native keys. | Strong (official docs: https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/). "Names not accepted" is an absence-of-evidence finding. Name-keyed custom fields are documented only for Automation smart JSON (https://support.atlassian.com/cloud-automation/docs/advanced-field-editing-using-json/), not raw REST. |
| ankitpokhrel/jira-cli | `--custom <slug>=value`, where the slug is a lowercased, hyphenated **display name** from configured `issue.fields.custom` (name/key/schema). System fields via dedicated flags (`--fix-version`, `--priority`, …). | No. Dedicated flags only. | Medium (README https://github.com/ankitpokhrel/jira-cli, discussion https://github.com/ankitpokhrel/jira-cli/discussions/346, issue #340). Edit-path coverage for all types not verified. |
| go-jira | Templates write raw REST `fields:` keyed by ID (`fixVersions`, `customfield_NNNNN`). `-o/--override` sets template variables, not arbitrary fields. | Only via the template (raw REST). | Medium (https://github.com/go-jira/jira, issues #75, #414). |
| Atlassian ACLI (`acli jira workitem create/edit`) | Dedicated flags plus `--from-json`. Create JSON uses custom-field **IDs** under `additionalAttributes`. Edit reportedly cannot set custom fields. | No documented arbitrary `--field`. | Weak to medium (https://developer.atlassian.com/cloud/acli/reference/commands/jira-workitem-create/, …/jira-workitem-edit/; community report https://community.atlassian.com/forums/discussion/3237097/…). Version-dependent community reports. |
| Appfire (Bob Swift) JCLI | `--field "name=value"` accepts a custom field **name or ID**. System fields use dedicated params (`--fixVersions`, `--priority`). | Not confirmed for `--field`. Dedicated params are the documented route. | Weak to medium (https://appfire.atlassian.net/wiki/spaces/JCLI/pages/70784837/--field; a direct fetch returned only a TOC, so the wording comes via Perplexity synthesis). |

**Takeaway.** The REST API is ID-native. Most CLIs expose a name-oriented custom-field flag and route system fields through dedicated flags. None of the surveyed CLIs clearly documents a name-or-system-ID `--field` with an ID-wins collision rule. `jr`'s current split (read-side `field options` accepts IDs; write-side `--field` is name-plus-`customfield_` for custom fields, with dedicated flags for system fields) is consistent with the prevailing CLI pattern. There is no external pressure to mirror the ID step now. The REST-native argument (IDs are stable and locale-independent) does support it as a future feature, implemented together with system-type support.

---

## 4. Recommendation

**Choose (a), with a defined follow-up of shape (d) (shared resolver, bundled with `FIELD-SYSTEM-TYPES-UNSUPPORTED`).**

| Criterion | (a) | (b) | (c) |
|---|---|---|---|
| User value now | none lost (help never promised IDs) | small: `duedate` and new spellings; motivating `fixVersions` case still exits 64 | same as (b) |
| Correctness/consistency | spec made true; divergence explicit | resolution consistent, but messages and sanitization stay divergent unless also fixed | proves consistency only on fixtures |
| Regression risk to edit/create | zero | silent write retarget on name/ID collision; message changes | same as (b) |
| F5 convergence risk | low | high (new write behavior, collision decision, BC-7.1.006 claim (i) sweep of field_resolve.rs) | highest |

### Exact rewording proposed for BC-X.14.001 Invariant 3

> 3. The `customfield_NNNNN` bypass and the `fields.json` cache-first load/fetch contract use the SAME cache file and functions (`read_fields_cache`/`write_fields_cache`/`list_fields`) as `src/cli/issue/field_resolve.rs::resolve_edit_fields` (BC-3.4.015 Steps 1–2), with the same profile-scoped isolation. The Step 1 `customfield_NNNNN` predicate is equivalent in both (`src/cli/field.rs::is_customfield_literal` and `resolve_edit_fields`'s literal-bypass check). The two **search** algorithms are separate implementations, not a shared function, and **deliberately diverge** as of D-399/FIX-P5-005: `src/cli/field.rs::search_field_list` tries an exact ASCII-case-insensitive field-ID match before name matching (system IDs such as `issuetype`/`fixVersions` resolve; ID wins on collision, EC-X.14.001-16..21), uses the `FIELD_ID_HINT` ambiguity wording (BC-X.14.004), and sanitizes echoed candidates and queries (EC-X.14.004-9/-10). `resolve_edit_fields`'s nested `search_field` (used by `jr issue edit --field` and platform `jr issue create --field`, BC-3.4.015 Step 2b / BC-3.3.010) has NO field-ID step: a system field ID whose display name differs (e.g. `fixVersions` vs `Fix versions`) is "not found" there, and must be addressed by display name. Its ambiguity hint names only `customfield_NNNNN`, and its messages are not sanitized. This divergence is intentional for cycle-014: on the write path an ID-first rule can silently retarget a write when a custom field's display name equals a system ID, and most system-ID-addressable fields are blocked by `dispatch_field_value`'s type dispatch anyway (`FIELD-SYSTEM-TYPES-UNSUPPORTED`, D-379). System-ID support for `--field` is tracked as follow-up `FIELD-ID-RESOLUTION-UNIFY` (§follow-up below). A change to the shared contract (customfield bypass, cache-first load/fetch, refresh-once rule) must still be applied to both; a change to the search step need not be, unless that follow-up lands.

Also update:
- BC-X.14.001 Behavior ¶ (~L2660): "the resolution logic itself is mirrored, not shared (Invariant 3)" → "the cache/bypass contract is shared; the search step diverges deliberately (Invariant 3)".
- cross-cutting.md frontmatter trace: add a FIX-P5-0NN bullet (COUNT-NEUTRAL, spec-only).
- `.factory/spec-changelog.md` entry.
- Optionally, pre-empt the next adversary pass with one appended BC-7.1.006 (b) residual line: "`src/cli/issue/field_resolve.rs::resolve_edit_fields` nested `search_field` and the not-on-screen/unsupported-type/option error messages echo raw server field names (pre-existing, outside the cycle-014 delta; same class as covered (a)5)". This is spec-only and keeps claim (i) honest without code changes.

### Follow-up item `FIELD-ID-RESOLUTION-UNIFY` (for a future cycle, alongside D-379)

If and when it is built, the spec should state:
1. **One shared pure function** (e.g. `pub(crate) fn search_field_list(list, query) -> Result<Option<(String, String)>>`), used by both `field.rs` and `resolve_edit_fields`. Delete the nested copy and drop the "must be mirrored" language. No parity test is needed because there is one implementation.
2. **Precedence:** `customfield_` literal → empty guard → exact ASCII-case-insensitive ID → exact name → name substring. The ID match is exact only.
3. **Collision rule on the write path (a decision is needed):** either keep "ID wins silently" for consistency with EC-X.14.001-17, or (safer for writes) make an ID-match that also exact-name-matches or uniquely substring-matches a *different* field an exit-64 ambiguity naming both, with the `customfield_NNNNN` escape hatch. Recommendation: ID wins silently on read, exit-64 ambiguity on write; or ID wins on both, plus a CHANGELOG breaking-change note.
4. **Guards:** unchanged. D2 (`CREATE_D2_GOVERNED_KEYS`) and Gate B already key on wire IDs before resolution. Add tests that `--type X --field issuetype:id=…` and `--priority X --field priority:name=…` still exit 64 pre-HTTP, and that `--field labels=…` on edit is still blocked by the `--label` mutual exclusion/type dispatch.
5. **Hint text:** reuse `FIELD_ID_HINT` in both paths. Update the `--field` help on create and edit (`src/cli/mod.rs`) to state that IDs are accepted, with a help-pin test.
6. **Sanitization:** apply `sanitize_terminal_line` to every echoed candidate and query in the shared function (inherits EC-X.14.004-9).
7. **Tests:** unit tests (ID resolves; canonical casing; exact-not-substring; duplicate-ID ambiguity; collision rule per item 3) and integration tests (edit + create wiremock: `duedate` happy path; `fixVersions` → unsupported-type message, not "not found"; exactly one `GET /field` on a cold cache).
8. **Bundle with D-379** so that `fixVersions`/`priority`/`issuetype` become genuinely settable, not just resolvable.

---

## Uncertainties

- Whether `{"fixVersions":{"name":…}}` (non-array) yields a 400 from live Jira was not verified live.
- Not exhaustively checked: existing edit/create test fixtures containing a custom field named like a system ID.
- `gh issue list` was not run (no shell available). External demand for system-ID `--field` is unverified.
- Appfire `--field` wording is second-hand (Perplexity synthesis; direct fetch returned only a TOC).
- The ~26-site count is a regex count of `{human_name}`/`{name}`/`{n} ({id})` interpolations in `field_resolve.rs`, not a classified SERVER/USER sweep.

## Research Methods

| Tool | Queries | Purpose |
|---|---|---|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Jira REST field keying; ankitpokhrel/jira-cli, go-jira, ACLI, Appfire field-reference conventions |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 1 | Appfire `--field` name/ID wording (after a direct fetch failed) |
| Context7 | 0 | Not applicable (no library API question) |
| Tavily | 0 | Not available in this session |
| WebFetch | 1 | Appfire `--field` page (returned TOC only; inconclusive) |
| WebSearch | 0 | — |
| Local code/spec reads (Read/Grep) | ~25 | `src/cli/field.rs`, `src/cli/issue/field_resolve.rs`, `edit.rs`, `create.rs`, `jsm_create.rs`, `src/cli/mod.rs`, cross-cutting.md, bc-3-issue-write.md, bc-7-output-render.md, pass-4.md, FIX-P5-005-spec-delta.md, OPEN-STANDING-ITEMS.md |
| Training data | 2 areas | Typical Jira Cloud system-field display names/schema types (`Fix versions`/array, `Due date`/date, `Security Level`/securitylevel). Flagged as tenant-dependent; partly corroborated by cross-cutting.md EC-X.14.001-14. |

**Total MCP tool calls:** 2
**Training data reliance:** low to medium. Code facts come from direct reads. Schema-type mapping for system fields comes from model knowledge (consistent with the in-repo D-379 analysis). External CLI conventions are web-sourced with the stated strength.
