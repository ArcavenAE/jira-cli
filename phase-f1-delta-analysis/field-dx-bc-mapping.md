---
document_type: f1-delta-analysis
artifact: bc-mapping
cycle: field-dx
source_issues: [580, 578]
producer: business-analyst
timestamp: "2026-08-25T00:00:00"
phase: F1
step: 4
scope_note: "#578's #589 sub-item (issue edit --dry-run fails on JSM tickets) is ALREADY CLOSED — out of scope for this cycle."
---

# Field DX — BC Mapping (F1 Step 4 / 4b / 4c)

## Anchoring research finding (restated for traceability)

`jr field options <field>` (#580) MUST enumerate via `GET /issue/{key}/editmeta`
`allowedValues` (OAuth-3LO-accessible, jr already uses editmeta in
`field_resolve.rs`) — NOT the admin-gated `/field/{id}/context/{ctx}/option`
endpoint the issue literally proposes. #578 is fully feasible as specified via
standard issue PUT/POST. Both center on the shared editmeta/createmeta
`allowedValues` foundation already established by BC-3.4.015/016.

**Open design question flagged for the architect (not resolved here):** the
issue's proposed CLI surface (`jr field options customfield_10084`, no issue
key) is instance-agnostic, but `editmeta` is issue-scoped
(`/issue/{key}/editmeta`) — a field's `allowedValues` can vary by issue type
and even by workflow status. `createmeta`
(`/issue/createmeta/{project}/issuetypes/{id}`) is project+issuetype-scoped
and closer to instance-agnostic, but still requires a `--project` (and
implicitly an issue type) the issue's examples never supply. Someone must
decide: (a) require `--project`/`--type` flags not in the issue's examples,
(b) require a representative `<KEY>` positional/flag, or (c) pick a
project/issue-type from config defaults silently (fragile — could return a
different `allowedValues` set than the user's actual target ticket). This is
an F2 product-owner decision, not a BC-slot question.

---

## 1. BC mapping

### 1.1 UNCHANGED (verify no incidental collateral, but no BC text changes)

| BC | Why unchanged |
|---|---|
| BC-3.4.017 | C-1 multi-key/`--jql` `--field` rejection guard — orthogonal to value-kind hint syntax and to the non-JSM-create extension; both land inside the existing single-key/bulk dispatch this BC already gates. |
| BC-3.8.002, 3.8.005–3.8.007, 3.8.009, 3.8.010, 3.8.011, 3.8.014–3.8.017 | JSM create body composition unrelated to `--field` semantics. |
| BC-X.10.001..003 (Partial-Match) | `partial_match` primitive itself is reused as-is by `jr field options <name>` resolve-by-name (#580 item 3) and by any field-name resolution `:name` hint needs (#578) — no change to the primitive's contract. |
| BC-4.1.001 (workspace ID discovery + cache) | Reused read-only by the `:asset` hint (#578 item 4) to resolve `workspaceId` — no change to the workspace-discovery contract itself, only a new caller. |
| BC-6.3.001 (Multi-Profile Fields) | Any new field-list/cache read for `jr field options` must respect existing per-profile field-cache isolation; contract itself unchanged. |

### 1.2 MODIFY (existing BC needs amendment)

| BC | Current contract | Required modification |
|---|---|---|
| **BC-3.3.001** | `issue create` POSTs `/rest/api/3/issue`; amended 2026-07-25 DEC-188 to note `--field`/`--on-behalf-of` without `--request-type` exit 64 | Must be re-amended: `--field` is no longer blocked on the platform path once #578 item 2 lands. `--on-behalf-of` guard is untouched (issue #578 does not propose extending `--on-behalf-of` to platform create). |
| **BC-3.8.012** | `--field` on platform path without `--request-type` exits 64 pre-flight (DEC-188, BC-3.8.012/013 AMENDED, breaking change, v0.6.0-dev.12) | **Repealed/narrowed, not deleted outright** — this BC's exit-64 behavior for `--field` is reversed by #578 item 2. BC-3.8.013 (`--on-behalf-of` guard) is explicitly NOT touched — the two BCs must be split apart (currently co-documented as a pair; #578 breaks that symmetry). This is a breaking-change *reversal* of a deliberate breaking change shipped only ~1 month prior (2026-07-25) — flag prominently for the architect/PO; likely needs its own DEC entry documenting why the reversal is safe (semver/CHANGELOG note, since DEC-188 migration guidance told users to add `--request-type` — that guidance becomes optional again for `--field` specifically). |
| **BC-3.4.015** | `issue edit --field NAME=VALUE` single-key path resolves via editmeta, dispatches on `schema.type` (string/number/date/datetime/user) | Needs an amendment documenting how the new `NAME:kind=VALUE` hint syntax interacts with the existing bare `NAME=VALUE` (no hint) form — bare form must stay backward-compatible (auto-detect from `schema.type` as today) when no `:kind` suffix is present. |
| **BC-3.4.016** | `issue edit --field NAME=VALUE` option field resolves human value to `allowedValues[].id`, sends `{"id":"<id>"}` | Needs amendment: today's *implicit* auto-resolution (label → id lookup) becomes one of three explicit modes once hints exist (`:option` = today's behavior by display value, `:id` = bypass lookup entirely and send the literal id, `:name` = send `{"name":"<value>"}` verbatim for named-field refs like `priority`). Must specify precedence/compat when no hint is given (bare `NAME=VALUE` on an option-schema field — does it keep BC-3.4.016's current auto-detect, or now require a hint?). This is the single highest-ambiguity item for F2. |
| **BC-3.8.008** | `--field NAME=VALUE` (repeatable) on JSM create maps NAME → `requestFieldValues`, no id/option resolution today | Open question to raise in F2, not answered here: does the new `:option`/`:id`/`:name`/`:asset` hint syntax also apply on the JSM create `--field` path (same flag, different wire target `requestFieldValues` vs `fields`), or is hint-syntax scoped to `issue edit` + the new non-JSM `issue create` path only? The issue's own examples (#578) only show `jr issue edit`. Recommend: apply hints uniformly since it's the same flag name and users will expect consistency — but this must be an explicit PO decision, not inferred. |

### 1.3 NEW BC slots (one-line intent each — text authored in F2)

**Section 3.3 (Create) — extends BC-3.3.001..009, next available: BC-3.3.010+**
- BC-3.3.010 (new): `issue create --field NAME=VALUE` (repeatable) on the platform (non-JSM) path merges resolved fields into the create POST body, using the same editmeta-driven resolution machinery as `issue edit --field` (via `createmeta` instead of `editmeta`, since the issue doesn't exist yet at create time).
- BC-3.3.011 (new): Error taxonomy for `issue create --field` on the platform path (field not on the create screen, ambiguous option value, etc.) — parallels BC-3.4.015/016's edit-path taxonomy but sourced from `createmeta` rather than `editmeta`.

**Section 3.4 (Edit and Open) — extends BC-3.4.001..025, next available: BC-3.4.026+**
- BC-3.4.026 (new): `--field NAME:kind=VALUE` hint-syntax parser — splits on the first unescaped `:` before the `=`, validates `kind ∈ {option, id, name, asset}`, exits 64 on unknown kind with a hint listing valid kinds.
- BC-3.4.027 (new): `:option` hint explicit semantics — same wire shape as today's BC-3.4.016 (`{"value":"<display-value>"}` or resolved `{"id":...}` depending on tenant), now opt-in rather than the only path.
- BC-3.4.028 (new): `:id` hint semantics — bypasses `allowedValues` display-value lookup entirely, sends `{"id":"<literal>"}` as-is (no editmeta validation round-trip needed for the value itself, though the field-existence/editmeta-gate check from BC-3.4.015 Step 3 still applies).
- BC-3.4.029 (new): `:name` hint semantics — sends `{"name":"<value>"}` verbatim (for named-field refs like `priority`/`resolution`-shaped fields addressable by name rather than id).
- BC-3.4.030 (new): `:asset` hint semantics — composes an Assets object-reference array value (`[{"workspaceId":..., "id":"<wsId>:<objectId>", "objectId":"<objectId>"}]`) from a compact `WORKSPACE:OBJECTID`-shaped input, resolving `workspaceId` via the existing BC-4.1.001 workspace-discovery cache. This is the one new BC that spans bc-3 and bc-4 — flag for cross-file consistency review in F2.
- BC-3.4.031 (new, EC catalog companion): malformed hint values — empty `:kind`, unknown `:kind`, `:asset` input not matching `WORKSPACE:OBJECTID` shape, `:id` value that fails editmeta's own numeric-id sanity check — each needs an exit-64 message + hint.

**New command family — precedent: `jr requesttype` (BC-X.12.001..008) was filed as a new Cross-Cutting subsection rather than its own file, sized similarly (~8 BCs) to what #580 needs. Section 8 (Components) got its own file because it was a 28-BC bundle; #580 is not that large. Recommend: new `cross-cutting.md` subsection X.14 "Field Option Discovery" (X.13 is currently the last subsection), not a new file — but this sizing call belongs to product-owner/architect in F2, not locked here.**
- BC-X.14.001 (new): `jr field options <field>` resolves `<field>` (customfield_NNNNN literal bypasses lookup; human name resolves via `list_fields()` + `partial_match`) and enumerates `allowedValues` for that field — **mechanism TBD pending the open design question above** (editmeta needs an issue-scope or project+issuetype-scope not present in the issue's proposed CLI surface).
- BC-X.14.002 (new): `--value <substring>` client-side filter narrows the enumerated option list to matching id/label(s).
- BC-X.14.003 (new): Table output columns (id, value/label) + `--output json` shape.
- BC-X.14.004 (new): Error taxonomy — field not found (hint: `jr project fields` — reuse existing hint convention per BC-3.4.015 Step 3/EC-3.4.015-1/3), field found but has no `allowedValues` (not a select-type field), ambiguous name match (reuse `partial_match` Ambiguous/ExactMultiple message conventions per BC-X.10.001/X.12.006).
- BC-X.14.005 (new, nice-to-have per issue text, may be deferred to a follow-up): `jr requesttype fields <RT> --enumerate-options` auto-expands dropdown field values in place — explicitly called "nice-to-have" in #580; recommend flagging as OPTIONAL/deferred in F2 rather than committing a BC slot this cycle, since it touches a third file (`src/cli/requesttype.rs`) beyond the two issues' stated priority (#580 is P2, this sub-item is a stretch goal within it).

---

## 2. Regression-risk zone

**Files this cycle will modify or sit directly adjacent to:**
- `src/cli/issue/field_resolve.rs` (914 LOC) — `resolve_edit_fields`, the `"option"` schema-type dispatch (BC-3.4.016) — this is the core file both #580 (option enumeration) and #578 (hint-kind dispatch) extend.
- `src/api/jira/fields.rs` — `list_fields`, `filter_cmdb_fields`, `filter_story_points_fields` — #580 needs a new function here (or a new sibling) to fetch/derive `allowedValues`; must not disturb the existing CMDB/story-points filter helpers or their caches.
- `src/cli/issue/create.rs` — `parse_field_kv` helper (shared by platform + JSM create paths) — the hint-syntax parser (BC-3.4.026) most naturally extends this shared helper, meaning a change here affects BOTH JSM create's existing `--field` behavior (BC-3.8.008) and the new platform-create `--field` path (BC-3.3.010) simultaneously. High blast radius.
- `src/cli/issue/edit.rs` (~3,187 LOC, already 3× the ADR-0012 threshold per Known Size Deviations) — the DEC-188 exit-64 guard removal (BC-3.8.012 repeal) and hint-kind dispatch wiring both land here; this file already has S-605-1/S-605-2 component-edit code sharing it — coordinate to avoid merge conflicts with any in-flight work on that file.
- `src/api/assets/workspace.rs` — workspace ID discovery/cache, reused read-only by the `:asset` hint; do not duplicate the cache-read logic.

**Existing stories to review for pattern precedent / non-regression before implementing:**
- `S-396-issue-edit-field-flag.md` — origin story for BC-3.4.015..017 (the editmeta-driven `--field` machinery this cycle extends).
- `S-383-platform-inverse-warnings.md` — origin story for BC-3.8.010/011 (platform-path flag-ignore warnings), predecessor to the guard being reversed.
- `S-639-1.md` — DEC-188 origin story (the `--field`/`--on-behalf-of` exit-64 pre-flight guard). This story's acceptance criteria and migration notes are exactly what #578 item 2 reverses for `--field`; read it before writing the F2 delta so the reversal is deliberate and not an accidental regression of its intent.
- `S-605-1-issue-component-single-key.md` / `S-605-2-issue-component-bulk-edit.md` — most recent prior work in `edit.rs`'s single-key field-write path (BC-3.4.022/023); useful as the most recent precedent for how a new `--field`-adjacent write path was landed in this oversized file without making the size-deviation worse than documented.

**Existing tests to run/extend as regression safety net:**
- `tests/issue_edit_field.rs` — single-key `--field` editmeta resolution + option-field id resolution (BC-3.4.015/016 direct coverage; will need new cases per hint kind).
- `tests/issue_edit_type_errors.rs` — editmeta-gate type-error enrichment, adjacent to `field_resolve.rs`.
- `tests/issue_edit_echo.rs` — `changed_fields` echo (BC-3.4.012/013); hint-kind writes must still populate `changed_fields` correctly per field type.
- `tests/issue_create_jsm.rs` — JSM `--field` → `requestFieldValues` mapping (BC-3.8.008); must stay green if hint-syntax parsing is centralized in the shared `parse_field_kv`.
- `tests/jsm_request_api.rs` — `requestFieldValues` wire-shape coverage, same shared-parser blast radius as above.
- `tests/multi_profile_fields.rs` — ADR-0007 per-profile field-id cache isolation; #580's new field/allowedValues lookups must not leak across profiles.
- `tests/cmdb_fields.rs` — CMDB field discovery in the same `api/jira/fields.rs` file #580 extends; run to confirm no incidental collateral.
- `tests/issue_edit_labels.rs`, `tests/issue_edit_no_parent.rs` — same `edit.rs` file, lower direct risk but share the single-key dispatch fork; worth a smoke pass.
- `tests/e2e_cli_surface_guard.rs` — will need a new SURFACE table entry once `jr field options` and non-JSM `issue create --field` exist, or it will flag them as undocumented CLI surface drift.

---

## 3. Verification-property extension

This repo has **no standalone VP-NNN registry** (`.factory/stories/S-PG-VP-REGISTRY-1-l4-verification-registry.md` documents this as an open, not-yet-built follow-up — "ARCH-INDEX-equivalent for VPs" doesn't exist yet). Property-style guarantees live as inline `proptest!` blocks per module (`src/duration.rs`, `src/jql.rs`, `src/adf.rs`, `src/partial_match.rs`, `src/cli/issue/{edit,helpers,create,attachments}.rs`, `src/api/jsm/requests.rs`). Recommended new property tests for this cycle, following that existing convention:

1. **Hint-syntax splitter** (`field_resolve.rs` or wherever BC-3.4.026's parser lands): a `prop_field_hint_split_no_panic`-style test — the parser must not panic on multibyte/UTF-8 field names or values, mirroring the exact class of bug fixed by `FIX-F6-LRE-1` (`jql::validate_duration` returning `Err` instead of panicking on multibyte input, #734). Any `str` byte-slicing in the new `NAME:kind=VALUE` splitter is a direct repeat of that bug class if not careful.
2. **Assets `:asset` composer**: a property test for malformed `WORKSPACE:OBJECTID`-shaped input (missing colon, empty segments, non-numeric object id) — parallels the existing `prop_sanitize_attachment_filename_no_path_traversal` precedent (VP-576-001) cited in CLAUDE.md: never panic, always either compose a valid JSON value or exit 64 cleanly.
3. **`jr field options` allowedValues enumeration**: not obviously property-testable (it's I/O-shaped, not a pure parser) — standard wiremock integration coverage is the right tool here, not a proptest.

Flag for F6 (formal hardening): whichever new pure-function parser results from BC-3.4.026 should be added to `.cargo/mutants.toml` `examine_globs` (mirrors the `prop_sanitize_attachment_filename_no_path_traversal` mutation-coverage precedent).

---

## 4. Classification

| Axis | Value | Rationale |
|---|---|---|
| **Intent** | feature (#580) + enhancement (#578), cycle-level: **feature** | #580 adds a wholly new command (`jr field options`), which is feature-shaped even though it's small; #578 is a pure enhancement of the existing `--field` flag. When bundled as one cycle, the presence of a new top-level command surface makes "feature" the more accurate cycle-level label — not a bug fix (nothing here is broken today; #578's "papercuts" are DX gaps, not defects). |
| **Feature type** | backend | No UI surface; pure CLI/REST-API-client work (clap parsing, `editmeta`/`createmeta` HTTP calls, JSON body composition). |
| **Scope** | standard (not trivial) | Touches ≥5 existing BC subsections across two files (bc-3-issue-write.md, cross-cutting.md, with an incidental bc-4 cross-reference), reverses a deliberate breaking-change guard shipped one cycle prior (DEC-188/BC-3.8.012), lands in two files already flagged as oversized in Known Size Deviations (`create.rs`'s shared `parse_field_kv`, `edit.rs` at ~3,187 LOC), and carries one genuinely unresolved design question (`jr field options`' editmeta-scoping mismatch with the issue's proposed CLI surface) that blocks BC authorship until F2 resolves it. |

---

## 5. Open questions to carry into F2 (not decided here)

1. Does `jr field options <field>` require an issue key / `--project` + `--type`, or does it silently pick a project/issue-type — given editmeta/createmeta are both scoped, unlike the admin-only context/option endpoint the issue proposed?
2. Does the bare (no `:kind` hint) `--field NAME=VALUE` form keep today's BC-3.4.016 auto-detect behavior forever (back-compat), or does auto-detect become deprecated in favor of always requiring a hint on option-schema fields?
3. Does the new hint-kind syntax (`:option`/`:id`/`:name`/`:asset`) apply to JSM create's existing `--field` path (BC-3.8.008), or is it edit-path + new-platform-create-path only?
4. Is the BC-3.8.012 repeal a full removal or does it need a superseding DEC entry (parallel to how ADR-0002 was "superseded" rather than deleted) given it was a documented breaking change with its own migration guidance?
