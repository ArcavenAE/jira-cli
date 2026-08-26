---
document_type: delta-analysis
cycle: field-dx
mode: brownfield-feature
producer: architect
timestamp: 2026-08-25
status: complete
feature: Field DX bundle (issues #580, #578)
intent: feature
feature_type: backend (no UI surface — UX/a11y/e2e-browser dimensions N/A, jr is a CLI)
scope: standard (non-trivial — new command + new BCs + extends --field across 3 call sites)
trivial: false
route: Full F1-F7, recommend 2-wave sequence (foundation then dependent)
inputs:
  - .factory/research/field-dx-feasibility-2026-08-25.md
source_issues: GitHub #580, #578
affected-files: .factory/phase-f1-delta-analysis/affected-files-field-dx.txt
input-hash: "a90775e"
---

# Phase F1 Delta Analysis: Field DX Bundle (#580, #578)

This report covers architecture/impact/regression analysis (architect scope).
BC-S.SS.NNN mapping and PRD/story placement are authored separately by the
business-analyst agent running in parallel and are referenced, not duplicated,
here.

## 1. Feature Summary

| # | Issue | One-line description | Disposition |
|---|---|---|---|
| 1 | #580 | `jr field options <field>` — enumerate a custom select field's allowed options; `--value` filter; resolve by human name (nice-to-have) | **IN SCOPE — foundation (build first)** |
| 2 | #578 | Value-kind hints on `--field` (`:option=`/`:id=`/`:name=`/`:asset=`); extend `--field` to non-JSM `issue create`; Assets-ref JSON ergonomics | **IN SCOPE — depends on #580's foundation types** |
| 3 | #578 BUG-1 (#589) | `issue edit --dry-run` fails on JSM tickets | **OUT OF SCOPE — already closed, verify closure holds, do not reopen** |

Intent: **feature** (net-new command + net-new hint syntax on an existing
flag). Feature type: **backend** — no GUI, UX/accessibility/e2e-browser
convergence dimensions are N/A, consistent with every prior `jr` feature
cycle (see `delta-analysis-components.md` for precedent). Scope: **standard,
non-trivial** — a new top-level command family, a shared-helper signature
change with 3-call-site fan-out, and (per business-analyst) new BC content —
routes through the full F1-F7 Feature Mode pipeline.

## 2. Critical Research Finding (headline — see full detail in the research doc)

**#580 pivots away from the endpoint it literally proposes.**
`GET /field/{id}/context/{ctx}/option` requires `manage:jira-configuration` +
Administer-Jira permission and fails for `jr`'s typical (non-admin, 3LO OAuth)
user. **Pivot: enumerate via `GET /issue/{key}/editmeta`'s `allowedValues`**
(`read:jira-work`, no admin gate) — `jr` already owns this exact call and its
typed response shape (`EditMeta`/`EditMetaField`/`AllowedValue`,
`src/types/jira/editmeta.rs`; `JiraClient::get_editmeta`,
`src/api/jira/issues.rs`; consumed today by
`resolve_edit_fields`, `src/cli/issue/field_resolve.rs`, BC-3.4.015/016). The
admin-gated context-options endpoint may remain as a documented fallback for
admin users with a clear "requires admin scope" error, not the primary path.

**#578 is fully feasible as specified, no pivot required** — all four hint
kinds and the non-JSM `--field` extension are reachable under scopes `jr`
already requests (`read:jira-work`/`write:jira-work`).

**Key synergy:** with the pivot, both stories center on the **same
editmeta/`allowedValues` foundation `jr` already owns**. #580 is a read-only,
thinner consumer of that data; #578's hint kinds are, by contrast, a **pure
client-side syntactic transform** on `--field`'s value that needs no
editmeta/createmeta HTTP call at all (the user declares the wire shape
explicitly, bypassing the fuzzy-match heuristics `resolve_edit_fields` already
uses for the unhinted case). Full verdict table, sources, and three open F2
design questions (editmeta-vs-createmeta pivot for `field options`; cascading-
select scope; hint-syntax parsing owner) are in
`.factory/research/field-dx-feasibility-2026-08-25.md`.

## 3. Architecture Verdict

**No structural/interface redesign, no new subsystem (SS-02 CLI Layer,
SS-04 Jira API Resources absorb everything), no new ADR-mandated pattern
shift.** One net-new peer CLI module (`src/cli/field.rs`) that structurally
mirrors an existing single-file command precedent (`src/cli/requesttype.rs`,
259 LOC — not a directory, per ADR-0012's ≥1,000 LOC shard threshold). The
one genuinely fan-out-heavy change is internal: `parse_field_kv`'s signature
(currently `fn parse_field_kv(pairs: &[String]) -> Result<HashMap<String,
String>, JrError>`, `src/cli/issue/create.rs`) must grow kind-awareness to
carry `:option`/`:id`/`:name`/`:asset` tags, and it is the single shared
entry point for **three** independent call sites (`edit.rs` line 77,
`jsm_create.rs` line 282, and indirectly `create.rs`'s own platform path once
#578 pt.2 lands) — this is additive-shape work (extend the return type),
not a rewrite, but touches every consumer of that map.

### Impact table

| File | Class | Notes |
|---|---|---|
| `src/cli/field.rs` | **NEW** | `jr field options <field>` handler; structural mirror of `src/cli/requesttype.rs`. Est. ~150–250 LOC — well under the 1,000 LOC shard threshold. |
| `src/cli/mod.rs` | MODIFIED | New `Command::Field { command: FieldCommand }` variant + `FieldCommand` enum (additive, mirrors `RequestTypeCommand`); `--field` clap arg docs need the new `NAME:kind=VALUE` syntax noted; Rust exhaustiveness checking is the safety net, matching the `components` bundle's precedent. |
| `src/main.rs` | MODIFIED | New dispatch arm `cli::Command::Field { command } => field::handle(...)`, structurally identical to the existing `RequestType` arm (`src/main.rs:449`). |
| `src/cli/issue/field_resolve.rs` | **MODIFIED — HIGH regression-risk file** | See §4. `resolve_edit_fields`'s "option" branch (`field_resolve.rs` Phase 3 dispatch) must add a hinted bypass path that skips the existing id-bypass/exact-match/substring fuzzy-match heuristics when the caller supplies an explicit kind. 914 LOC, dense, BC-3.4.015/016-anchored. |
| `src/cli/issue/create.rs` | MODIFIED | `parse_field_kv` (defined here, `pub(crate)`) gains kind-tag parsing — return-type change ripples to all 3 call sites. DEC-188 pre-flight guard (S-639-1, BC-3.8.012/013) must be **split**: drop the `--field`-only guard on the platform path per #578 pt.2, but **keep** the `--on-behalf-of` guard (a JSM-only concept — raising a request "on behalf of" a portal customer has no platform-issue analog). New custom-field wire-insertion block at the `fields = json!({...})` assembly site (~line 195–273) mirrors the existing additive per-flag pattern already used for `--component`/`--team`/`--points`/`--parent`/`--assignee` — this is a **low-risk, well-precedented insertion shape**, not novel design. |
| `src/cli/issue/edit.rs` | **MODIFIED — HIGH regression-risk file (pre-existing classification)** | Consumes `parse_field_kv` at both the single-key path (line 77) and bulk paths. Dry-run JSON preview assembly and the BC-3.4.017 Gate B mutual-exclusion list may need field-hint awareness. Already ~3,187 LOC, ~3x the ADR-0012 threshold, DOCUMENT-AS-IS exception (PF-016) — the single densest file this bundle touches. |
| `src/cli/issue/jsm_create.rs` | MODIFIED | Consumes `parse_field_kv` (line 282). **Currently the only call site with zero type dispatch** — `extra_fields` is merged as a raw `HashMap<String,String>` with no editmeta/valid_values lookup at all. Direct target of #578 pt.1's "dropdown value semantics are ambiguous" complaint. |
| `src/api/jsm/requests.rs` | MODIFIED | `JsmRequestBuilder.extra_fields: &'a HashMap<String, String>` and its `build()` loop (`for (k, v) in self.extra_fields { rfv.insert(k.clone(), serde_json::Value::String(v.clone())); }`) unconditionally wire-serialize every value as a **string**. Must gain kind-aware dispatch (`{"value":...}` / `{"id":...}` / `{"name":...}` / Assets array) — this is the concrete fix for #578 pt.1 and pt.4. |
| `src/api/jira/fields.rs` / `src/api/jira/issues.rs` | MODIFIED | Field enumeration call for #580 — exact shape depends on the open editmeta-vs-createmeta design fork (research doc, open question 1). `get_editmeta` already exists and needs zero new API-layer code if the editmeta-with-`--issue` path is chosen; a new `?expand=fields` createmeta call is new API-layer code if the issue-less path is chosen. |
| `src/types/jira/editmeta.rs`, `src/api/assets/workspace.rs`, `src/types/assets/linked.rs`, `src/types/jsm/request_type.rs`, `src/partial_match.rs` | DEPENDENT | Read-only reuse — `AllowedValue`/`EditMeta` shapes, cached `get_or_fetch_workspace_id`, `LinkedAsset`'s `"{workspaceId}:{objectId}"` composite-id convention (reference for the new Assets object-ref composer), `RequestTypeField.valid_values` (JSM's structurally separate allowedValues-equivalent, referenced for context only), duplicate-name disambiguation for #580's name-resolution nice-to-have. No shape changes expected in any of these. |

**No new external dependency.** No new cache family identified for this
bundle (field enumeration is not proposed as cached in either issue —
revisit in F2 only if editmeta/createmeta call volume becomes a UX concern on
repeated invocations).

**BC placement (deferred to business-analyst, architecture observation
only):** #580 is a net-new top-level command family with no natural home in
the existing 8 numbered BC section files (`bc-1`..`bc-8`) or `cross-cutting.md`
— it reads like a `bc-9-field-discovery.md` candidate, structurally sized like
`bc-8-components.md` was for the component bundle, not a cross-cutting
subsection. #578's hint-syntax and non-JSM `--field` extension are natural
**amendments** to existing `bc-3-issue-write.md §3.4` (issue edit `--field`,
BC-3.4.015/016 neighborhood) and `§3.8` (JSM create `--field`, BC-3.8.008
neighborhood), plus possibly a new platform-create subsection for the
dropped DEC-188 guard (BC-3.8.012/013 amendment or a new BC-3.4.02x/BC-3.3.0xx
sibling — business-analyst's call).

## 4. Regression Risk

| Zone | Risk | Why | Existing tests in the risk zone |
|---|---|---|---|
| `src/cli/issue/field_resolve.rs` | **HIGH** | Dense editmeta type-dispatch logic (string/number/date/user/option, 5 field-type arms, id-bypass + exact + substring option-resolution heuristics per BC-3.4.016). The hinted bypass path must not perturb the *unhinted* fuzzy-match behavior for any existing input — the two paths share the same "option" match arm and the same `AllowedValue` data. | `tests/issue_edit_field.rs` — 64 test functions, 3,960 LOC. Largest single-file test investment in the risk zone. |
| `src/cli/issue/edit.rs` | **HIGH (pre-existing classification, CLAUDE.md "Known Size Deviations")** | ~3,187 LOC, ~3x the ADR-0012 1,000-LOC threshold, already flagged DOCUMENT-AS-IS. `parse_field_kv` consumer at both single-key and bulk edit paths; dry-run preview assembly (BC-3.4.021 "simplified preview, not wire-identical" convention) and the BC-3.4.017 Gate B mutual-exclusion list (`--field`+`--label` guard) are both candidates for hint-syntax-aware amendment. | `tests/issue_edit_field.rs` (shared with field_resolve.rs); dry-run-specific coverage likely in a separate dry-run test file (not enumerated here — business-analyst/test-writer to confirm exact file in F3). |
| `src/api/jsm/requests.rs` + `src/cli/issue/jsm_create.rs` | **MEDIUM-HIGH** | `JsmRequestBuilder::build()`'s `extra_fields` loop is the direct fix target for #578 pt.1/pt.4 — going from unconditional string-wrap to kind-aware dispatch is a real behavior change for every existing JSM-create `--field` caller, not purely additive. Must preserve exact byte-for-byte wire shape for `summary`/`description`/`priority`/`labels` (BC-3.8.005..007), which sit in the same `rfv` map construction and are untouched by this bundle. | `tests/issue_create_jsm.rs` — 59 test functions. Wire-shape assertions here are the regression backstop for the `rfv` map's non-`extra_fields` keys. |
| `src/cli/issue/create.rs` | **LOW-MEDIUM** | The DEC-188 guard split (drop `--field`-only, keep `--on-behalf-of`) is a narrow, well-isolated change to a pre-flight block that already has an explicit ordering contract documented in CLAUDE.md and in-code comments (BC-3.8.012/013, S-639-1). The new custom-field wire-insertion block follows an already-precedented additive shape (6 sibling blocks exist for `--component`/`--team`/`--points`/`--parent`/`--assignee`/`--label`). Primary risk is guard-ordering regression, not wire-shape correctness. | `tests/issue_create_echo.rs`, `tests/issue_create_json.rs`, and the DEC-188 guard's own pinned tests (grep `field_pairs.is_empty()` / `on_behalf_of.is_some()` combined-check tests) — not individually enumerated here; F3/F4 must locate and re-run the exact DEC-188 guard-ordering test(s) before splitting the check. |
| `src/cli/field.rs` (new) | **LOW** | New module, no existing code to break. Only risk is choosing the wrong metadata source (editmeta vs. createmeta) per the open F2 design question — a design-correctness risk, not a regression risk. | N/A (new file). |
| `src/api/jira/fields.rs` | **LOW** | Currently pure, well-tested (story-points/CMDB filter functions have dedicated unit tests inline). Any addition for #580 should follow the same pure-function-plus-thin-`JiraClient`-wrapper shape already established here. | Inline `#[cfg(test)] mod tests` in `fields.rs` itself (9 tests observed: `filter_finds_classic_story_points`, `filter_finds_jsw_story_point_estimate`, `filter_finds_both_variants`, `filter_ignores_non_custom_fields`, `filter_ignores_non_number_fields`, `filter_case_insensitive_name_match`, `filter_cmdb_fields_finds_assets_type`, `filter_cmdb_fields_ignores_non_cmdb`, `filter_cmdb_fields_empty_when_no_cmdb`, `filter_cmdb_fields_multiple`). |

**Files explicitly NOT touched (regression baseline)** — see
`affected-files-field-dx.txt` for the full enumerated list. In summary:
`src/api/client.rs`, `src/api/auth*.rs`, `src/api/pagination.rs`,
`src/api/rate_limit.rs`, `src/api/refresh_coordinator.rs`, `src/adf.rs`,
`src/config.rs`, `src/cache.rs`, `src/jql.rs`, `src/duration.rs`,
`src/observability.rs`, all of `src/cli/issue/{list,view,comments,
interactions,workflow,links,helpers,assets,changelog,attachments,
json_output,format}.rs`, `src/cli/{component,requesttype,board,sprint,
worklog,team,user,init,project,queue,api}.rs`, `src/cli/auth/`,
`src/cli/assets/`, `src/api/jsm/{servicedesks,queues,request_types}.rs`,
`src/api/assets/{linked,objects,schemas,tickets}.rs`, and all
non-fields-related `src/api/jira/*.rs` files (boards, sprints, statuses,
links, resolutions, teams, worklogs, projects, attachments, components,
users, bulk).

Regression-risk **stories/test files** flagged for full re-run in F4/F6:
`S-396-issue-edit-field-flag.md` (the foundational `--field` story this
bundle amends), `tests/issue_edit_field.rs` (full 64-test suite),
`tests/issue_create_jsm.rs` (full 59-test suite), `tests/issue_create_echo.rs`,
`tests/issue_create_json.rs`, `tests/cmdb_fields.rs` (Assets-adjacent,
0 direct tests found but exercises the CMDB field-discovery pattern this
bundle's Assets-ref work borrows conventions from), `tests/multi_profile_fields.rs`
(profile-scoping invariant — any new cache or field-resolution call must
respect the `profile: &str`-first-arg convention per CLAUDE.md's
"Multi-profile boundary" gotcha, even though no new cache is currently
identified for this bundle).

## 5. Recommended Scope for F2–F7

**Two-wave sequence**, mirroring the components-bundle precedent
(`delta-analysis-components.md`) but smaller:

- **Wave 1 — #580 foundation.** New `jr field options <field>` command:
  editmeta-based (or createmeta-based, pending the F2 design-fork resolution)
  option enumeration, `--value` filter, name-resolution nice-to-have via
  `partial_match`. Zero touches to `edit.rs`/`create.rs`/`jsm_create.rs` wire
  logic — purely additive new module + new `Command`/`FieldCommand` variants.
  Lowest risk, ships independently, and its output (confirmed `allowedValues`
  parsing/display idioms) directly informs Wave 2's hint-kind implementation.
- **Wave 2 — #578, depends on Wave 1.** `parse_field_kv` kind-tag extension;
  `resolve_edit_fields` hinted-bypass dispatch; `JsmRequestBuilder` kind-aware
  `extra_fields` serialization; DEC-188 guard split for non-JSM `--field` on
  platform create; Assets object-ref composer (`:asset=` hint, reusing cached
  `get_or_fetch_workspace_id`). This wave is the fan-out-heavy one (3 call
  sites + 1 shared helper + 1 builder) and should not start until Wave 1's
  editmeta/createmeta pivot decision is locked, since both waves consume the
  same `allowedValues`/field-metadata foundation.

F2 must resolve, before story decomposition: (1) the editmeta-vs-createmeta
design fork for `jr field options` (does it require `--issue <KEY>`?); (2)
whether cascading-select composition (`{"value":parent,"child":{...}}`) is in
#578's scope or deferred — it is not one of the four explicit hint kinds in
the issue's acceptance criteria; (3) the exact new-type shape for
`parse_field_kv`'s return value (a `HashMap<String, FieldValueSpec>`-shaped
struct, or a `Vec<(String, Option<ValueKind>, String)>` to preserve the
existing last-wins-on-duplicate-key semantics — `parse_field_kv`'s own
proptests, `create.rs::parse_field_kv_proptests`, currently assert HashMap
semantics and will need updating in lockstep).

F5 (scoped adversarial) should specifically probe: guard-ordering regressions
in the split DEC-188 check; wire-shape byte-for-byte preservation for
`JsmRequestBuilder`'s non-`extra_fields` keys; and the hinted-vs-unhinted
option-resolution boundary in `resolve_edit_fields` (a value that matches
both a fuzzy heuristic AND is passed with an explicit conflicting hind should
have one, unambiguous, documented precedence rule).

F6 (targeted hardening) full-tree regression + security scan is standard;
no new external dependency, no new attack surface beyond existing HTTP calls
with existing scopes — no elevated security-review need beyond the standard
gate.
