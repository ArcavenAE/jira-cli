---
document_type: delta-analysis-report
feature_name: "Surface Jira duedate field in issue view/list (JSON + human)"
created: 2026-08-13
spec_version_at_analysis: "1.3.163 (BC-INDEX v6.75, total_bcs 658)"
status: draft
intent: "enhancement"
feature_type: "backend"
scope: "standard"
severity: "N/A"
---

# Delta Analysis Report: Surface `duedate` in `issue view`/`issue list`

## Feature Request

- **Brief:** GitHub issue #668 — `jr issue view --output json` omits `duedate` from
  `.fields`, so `jq .fields.duedate` on an issue with a set due date renders `null`,
  indistinguishable from "unset." Scope was widened by the human beyond the reported
  bug: `duedate` must also be surfaced in the **human** table/detail output of
  `issue view` (and `issue list` where a column fits), not only the JSON scripting
  surface.
- **Requested by:** GitHub issue #668 (human-confirmed scope in this session)
- **Date:** 2026-08-13

## Classifications

### Intent Classification

**Classified intent:** `enhancement`
**Rationale:** The GitHub issue itself reads as a bug report ("omits", "reads as
unset"), which in isolation would route as `bug-fix` (skip F2/F3). But the human
explicitly widened scope in this session to include a **new** human-readable
rendering (a Due Date row in `issue view`'s table, and a possible Due Date column
in `issue list`) — that is new design surface requiring BC amendments/additions and
at least one design decision (column visibility policy, ordering, empty-value
rendering), not a pure defect fix. Full F1-F7 applies; do not take the bug-fix
skip-F2/F3 shortcut. Per `feedback_vsdd_process.md`, this still goes through the
full pipeline regardless of how small it looks.

### Feature Type Classification

**Classified type:** `backend`
**Rationale:** No web/GUI screens involved — `jr` is a CLI. All work is in the
Rust CLI/API layers (field-list constant, struct deserialization, table
rendering). "Backend" is the correct bucket for a `ui`/`backend`/`full-stack`/
`infrastructure` split in this codebase; the "human table" scope is CLI
presentation, not a UI subsystem with its own a11y/e2e machinery.

### Trivial Scope Classification

- [x] Impact boundary: single module, single file, or documentation only — **FALSE**,
  spans `src/api/jira/issues.rs`, `src/types/jira/issue.rs`, `src/cli/issue/view.rs`,
  `src/cli/issue/format.rs`, `src/cli/issue/list.rs`, plus their test files.
- [x] No new BCs needed — **FALSE**, see BC list below (amendments to BC-2.2.028 and
  BC-2.3.036 are content-breaking; the human-render half needs new BC(s)).
- [x] No architecture change — **TRUE**, no new module/interface.
- [x] No new external dependencies — **TRUE**.
- [x] Regression risk: LOW — **PARTIAL**, see Risk Assessment (one test does need an
  update, but the mechanism is well-precedented and low-risk).

**Classified scope:** `standard`
**Rationale:** Not all five trivial criteria hold (multi-file impact, BC amendments
required). Routes through the full F1-F7 Feature Mode pipeline, not quick dev.

### Severity Classification

**Classified severity:** `N/A` (intent is `enhancement`, not `bug-fix`).

## Impact Assessment

| Dimension | Affected | Details |
|-----------|----------|---------|
| PRD Requirements | 0 new BCs allocated yet, 2 amended, ~2 new BCs to allocate in F2 | Amended: BC-2.2.028 (search fields list, 16→17), BC-2.3.036 (`get_issue` field enumeration). New (IDs pending F2 allocation): `issue view` Due Date row BC (subdomain 2.3), `issue list` Due Date column BC (subdomain 2.2, possibly alongside a column-set backfill BC — see Open Questions #7). |
| Architecture | 0 components added, 0 modified | No new module, no new interface, no purity-boundary change — see Risk Assessment. |
| UX Screens | N/A | `jr` is a CLI; no GUI screens. Table/detail rendering changes are covered under Files Changed, not a separate UX artifact. |
| Stories | 1 new story estimated | Single cohesive story covering the JSON field-list fix and the human-render additions (see Scope Recommendation). |
| Existing Tests | ~90+ tests in the regression risk zone (all `issue view`/`issue list` output paths); 1 test requires a MANDATORY update | See Regression Baseline for the full risk-zone file list; `tests/issue_commands.rs::test_search_issues_includes_labels_parent_issuelinks` will fail without an update (exact-array `body_partial_json` assertion). |
| Verification Properties | 0 new VPs strictly required, 1 recommended | No new invariant/property class is introduced (this is additive field surfacing, not a new mechanism); recommend extending the existing `get_issue_includes_standard_fields`/`get_issue_null_standard_fields` present/absent pair (issue #59 pattern) to cover `duedate`, which is ordinary test coverage rather than a new VP-NNN. |

## Impact Boundary

### JSON path (mechanically trivial, one-line root cause)

- `src/api/jira/issues.rs::BASE_ISSUE_FIELDS` (const, ~line 13) — add the literal
  `"duedate"` to the 16-element array. This constant is the single shared REST
  `fields=` request list consumed by BOTH `get_issue` (~line 163, `issue view`) and
  `search_issues` (~line 427, `issue list`), so one edit fixes both surfaces
  simultaneously — this is the intended shared chokepoint (rustdoc: "Both
  `search_issues` and `get_issue` use this list so they stay in sync").
- `src/types/jira/issue.rs::IssueFields` — currently has NO named `duedate` field.
  Two options for F2/F3 to decide between (see Open Questions): (a) rely on the
  existing `#[serde(flatten)] pub extra: HashMap<String, Value>` catch-all — zero
  struct change, `duedate` appears in JSON automatically once requested; or (b) add
  a named `pub duedate: Option<String>,` field alongside `created`/`updated`
  (precedent: issue #59 added `created`, `updated`, `reporter` as named fields for
  the same reason). Option (b) is what the human-render path needs regardless
  (`issue.fields.duedate.as_deref()`, mirroring the existing
  `issue.fields.created.as_deref()` pattern in `view.rs`), so (b) is the natural
  choice and makes (a) moot in practice — a named field is a strict superset of the
  flatten behavior for read purposes.

### Human-render path (new design surface, NOT mechanically trivial)

- `src/cli/issue/view.rs::handle_view` (Table arm, ~lines 91-176) — needs a new row
  in the `rows` vec, inserted near `Created`/`Updated` (both already exist at this
  exact spot, ~lines 139-156) using the SAME formatter,
  `format::format_comment_date` (aliased `format_comment_date` at the top of the
  file), for date-format consistency. Unset due date should render `"-"` — this is
  the existing convention for `Created`/`Updated`
  (`.unwrap_or_else(|| "-".into())`), NOT the `"(none)"` convention used elsewhere
  in the same table for `Reporter`/`Labels`/`Parent`/`Links` — the two conventions
  already coexist in this exact function and the choice for Due Date needs to be
  made explicitly in F2 (see Open Questions; `format_comment_date` expects a
  datetime string, not a date-only string — `duedate` is `YYYY-MM-DD`, no time
  component, so the formatter call needs verifying/adapting, not blindly reused).
- `src/cli/issue/format.rs::format_issue_row` / `issue_table_headers` — the `issue
  list` table row-builder and header-builder. Currently a FIXED 4-6 column table
  (Key, Type, Status, Priority, [Points], Assignee, [Team], [Assets], Summary) with
  `col_count` computed from three `Option`-gated booleans (`sp_field_id`, `assets`,
  `team`). Adding a Due Date column means extending this same pattern: a new
  `Option<&str>`-shaped parameter threaded through `format_issue_row`,
  `issue_table_headers`, and every call site.
- `src/cli/issue/list.rs::handle_list` (~line 56 onward, 1,259 LOC total — already a
  documented size deviation per CLAUDE.md "Known Size Deviations") — the call site
  that assembles `sp_field_id`/`assets`/`team` and calls
  `format::format_issue_row`/`format::issue_table_headers` (~lines 556-576) would
  gain a fourth conditional column wire-up, following the existing `show_points` /
  `show_assets` / `show_team_col` pattern.

### Explicitly UNCHANGED (regression baseline)

- `src/output.rs` (render_json / render_table) — no change; both `issue view
  --output json` and `issue list --output json` already route through
  `output::render_json` per JSON render invariant #526 (BC-7.3.010 /
  BC-7.1.001), and a HashMap-flattened or newly-named struct field serializes
  through the existing machinery with zero renderer change.
- `src/adf.rs` — untouched; `duedate` is a plain date string, not ADF content.
  `description` handling is unrelated.
  cache.rs, config.rs, api/client.rs, auth.rs — untouched; no new endpoint, no new
  cache family, no new config field.
- `src/cli/issue/comments.rs`, `interactions.rs`, `workflow.rs`, `links.rs`,
  `assets.rs`, `changelog.rs`, `attachments.rs`, `edit.rs`, `create.rs`,
  `jsm_create.rs` — none of these touch `BASE_ISSUE_FIELDS`, `get_issue`'s render
  path, or `search_issues`'s render path. `issue edit --field duedate=...` is a
  SEPARATE, already-working write path (existing generic `--field` mechanism per
  BC-3.4.015-017 / S-396) — this feature is read-side only; no write-path change is
  in scope.
- All non-issue subsystems (`board.rs`, `sprint.rs`, `worklog.rs`, `team.rs`,
  `user.rs`, `assets/*`, `auth/*`, `jsm/*`) — no dependency on `IssueFields` field
  set beyond what they already consume.

## Affected Specs / BCs

| BC | Current text (paraphrased) | Disposition |
|----|----|----|
| **BC-2.2.028** | `search_issues` default fields list: 16 fields in EXACT order (enumerates `summary…issuelinks`) | **AMEND** — becomes 17 fields; the field-count claim and the enumerated list both change. Source test: `tests/issue_commands.rs::test_search_issues_includes_labels_parent_issuelinks` (see Affected Tests). |
| **BC-2.3.036** | `get_issue` deserializes: created, updated, reporter, resolution, components, fix_versions (all nullable) | **AMEND** — extend the enumerated field list to include `duedate` (nullable, string). Source tests: `tests/issue_commands.rs::get_issue_includes_standard_fields` / `get_issue_null_standard_fields` (see Affected Tests) — these are the DIRECT structural precedent from issue #59 to replicate for `duedate`. |
| **BC-2.3.032** | `issue view <key>` GETs `/rest/api/3/issue/<key>` with `--output json` returning raw JSON | **NO CHANGE NEEDED** — this BC governs the GET-and-pass-through mechanism, not the field enumeration; it already covers "raw JSON," which now includes `duedate` once BASE_ISSUE_FIELDS is amended. No amendment required, but its Trace/Source citations are worth a cross-check in F2. |
| **BC-7.1.001 / BC-7.3.010** (JSON render invariant #526) | `--output json` routes through `render_json`/`print_output`; pretty-printed | **NO CHANGE NEEDED** — `duedate` flows through the existing invariant with zero renderer change. Cited here only to confirm the JSON side needs no new BC. |
| *(none yet — to be allocated in F2)* | — | **NEW BC(s) needed** for the human-render half: (1) `issue view` table gains a Due Date row (subdomain 2.3, next available slot after BC-2.3.038); (2) `issue list` table gains an optional/conditional Due Date column and the column-visibility/ordering policy decided in F2 (subdomain 2.2, next available slot after BC-2.2.031, OR a new subdomain-2.2 BC amending the existing implicit table-shape description — note: **no BC today explicitly enumerates the `issue list` table's column set** (Key/Type/Status/Priority/[Points]/Assignee/[Team]/[Assets]/Summary) as its own contract; F2 should decide whether to backfill that as a prerequisite BC or fold Due Date's column policy directly into a new BC). |

BC-INDEX.md `total_bcs` and section-level counts (bc-2-issue-read.md: currently 106
BCs cumulative / 64 individually-bodied) will need the standard
`scripts/check-bc-cumulative-counts.sh` / `scripts/check-spec-counts.sh` reconciliation
pass in F2 once new BC IDs are allocated — this is routine spec-steward housekeeping,
flagged here only so F2 doesn't skip it.

## Files Changed

### New Files

None. This feature is additive within existing files; no new module is warranted.

### Modified Files

| File Path | Change Type | Risk |
|-----------|------------|------|
| `src/api/jira/issues.rs` (`BASE_ISSUE_FIELDS`) | Add one string literal to a shared const array | LOW — additive, affects every `get_issue`/`search_issues` call, but server behavior for an added `fields=` entry is additive-only (more data returned, never less) |
| `src/types/jira/issue.rs` (`IssueFields`) | Likely add one named `Option<String>` field (`duedate`) | LOW — additive struct field, `#[serde(default)]`-safe via `Option`, no rename needed (Jira's wire field is already lowercase `duedate`, matching Rust's own naming, same as `created`/`updated`) |
| `src/cli/issue/view.rs` (`handle_view`, Table arm) | Add one row to the detail table | LOW-MEDIUM — human-render addition; needs a date-vs-datetime formatting decision (see Open Questions) |
| `src/cli/issue/format.rs` (`format_issue_row`, `issue_table_headers`) | Extend row-builder/header-builder signatures with a new optional column | MEDIUM — every call site of both functions must be updated in lockstep (currently 2 call sites: `format_issue_rows_public` and `list.rs`'s `handle_list`); a missed call site is a compile error, not a silent bug, so risk is really about churn/design, not correctness |
| `src/cli/issue/list.rs` (`handle_list`) | Wire a new conditional/column flag through to `format::format_issue_row`/`issue_table_headers`, following the existing `show_points`/`show_assets`/`show_team` pattern | MEDIUM — this file is already a documented size deviation (1,256 LOC, over the 750 target per CLAUDE.md); adding a fourth conditional column increases branching, though the pattern is well-established |

### Dependent Files (unchanged but depend on modified files)

| File Path | Depends On | Regression Risk |
|-----------|-----------|----------------|
| `tests/issue_commands.rs` | `BASE_ISSUE_FIELDS`, `IssueFields` | HIGH for one specific test (see Affected Tests — `test_search_issues_includes_labels_parent_issuelinks` WILL fail once `duedate` is appended, because it asserts the fields array via `body_partial_json` which requires exact-array match) |
| `tests/issue_read_holdouts.rs`, `tests/issue_view_errors.rs` | `get_issue` response shape | LOW — exercise error/edge paths, not the full-fixture field enumeration; unlikely to assert on the absence of `duedate` |
| `tests/team_column_parity.rs`, `tests/issue_list_assets.rs`, `tests/cache_warm_hit.rs`, `tests/all_flag_behavior.rs` | `format_issue_row`/`issue_table_headers` (indirectly, via `issue list` CLI invocation) | LOW-MEDIUM — these exercise the points/assets/team conditional-column machinery `issue list` already has; if F3 decides Due Date is a new *always-shown* column (not flag-gated), these tests' `stdout.contains(...)` substring checks are unaffected by an extra unrelated column, but any test asserting table WIDTH or exact header ordering would need re-verification — none were found via static grep to assert exact header arrays (only `format.rs`'s own inline `#[cfg(test)] mod tests` and `list.rs`'s own inline tests reference `issue_table_headers`/`format_issue_row` internals directly), so risk is assessed LOW-MEDIUM pending an actual F4 test run rather than HIGH |
| `src/cli/issue/mod.rs` | re-exports `format_issue_row`, `format_issue_rows_public`, `format_points`, `issue_table_headers` | LOW — pure re-export, signature changes propagate as compile errors at call sites, not silent breakage |

## Files NOT Changed (Regression Baseline)

- `src/output.rs` — JSON/table renderer machinery; rationale: `duedate` is scalar
  data flowing through existing generic serialization, no renderer-level change.
- `src/adf.rs` — rationale: no ADF content involved.
- `src/cache.rs`, `src/config.rs` — rationale: no new cache family, no new config
  field; `duedate` is neither cached nor configurable.
- `src/api/client.rs`, `src/api/auth.rs`, `src/api/auth_embedded.rs`,
  `src/api/refresh_coordinator.rs`, `src/api/rate_limit.rs`, `src/api/pagination.rs`
  — rationale: no new endpoint, no new pagination shape, no auth change.
- `src/cli/issue/{comments,interactions,workflow,links,assets,changelog,
  field_resolve,attachments,json_output}.rs` — rationale: none of these render or
  fetch the base issue field set touched by this feature.
- `src/cli/issue/create.rs`, `edit.rs`, `jsm_create.rs` — rationale: this is a
  READ-side feature only. `issue edit --field duedate=...` already works today via
  the generic `--field` mechanism (BC-3.4.015-017) and is unaffected; no write-path
  change is in scope for #668.
- `src/cli/{board,sprint,worklog,team,user,project,queue,requesttype,api}.rs`,
  `src/cli/assets/*`, `src/cli/auth/*`, `src/api/assets/*`, `src/api/jsm/*`,
  `src/types/{assets,jsm}/*` — rationale: entirely outside the issue-read surface.
- `.github/workflows/ci.yml` — rationale: no CI-gate-relevant change; this is a pure
  application-code change, not a workflow/tooling change.

## Risk Assessment

| Risk Type | Level | Rationale |
|-----------|-------|-----------|
| Regression | LOW-MEDIUM | `BASE_ISSUE_FIELDS` is a hot, shared chokepoint touching EVERY `get_issue`/`search_issues` call — but the change is purely additive to the requested field set (Jira returns more data, never less, and never errors on a valid recognized field name). Confirmed via static search: no wiremock test in the suite constrains the `fields=` query-string value for `get_issue`/`search_issues` mocks (mocks match on `path()` only) EXCEPT one: `tests/issue_commands.rs::test_search_issues_includes_labels_parent_issuelinks`, which uses `body_partial_json` to assert the EXACT 16-element `fields` array in the outgoing search request body — this WILL fail once `duedate` is appended (array length mismatch) and MUST be updated in F4 alongside the source change (this is exactly BC-2.2.028's own documented source, so the fix is mechanical: add `"duedate"` to the expected array literal). No insta snapshots exist for `issue view`/`issue list` table or JSON output (checked `src/cli/issue/snapshots/*.snap` and `tests/snapshots/*.snap` — only move/assign/link/unlink/edit/changelog snapshots exist, none touch the base field set), so snapshot churn is NOT a factor here, contrary to what the human's framing anticipated. |
| Architecture | LOW | No new module, no new interface, no purity-boundary change. `get_issue`/`search_issues` remain effectful-shell HTTP calls returning the same `Issue`/`IssueFields` types; adding one field/one const-array entry does not change the shell/core boundary anywhere in the codebase. |
| Security | LOW | `duedate` is a plain ISO date string already readable via `jr api /rest/api/3/issue/KEY?fields=duedate` (per the issue's own repro) and already writable via `jr issue edit --field`. No new trust boundary, no new untrusted input surface, no filename/path/injection vector. |
| Performance | LOW | One additional field in the `fields=` query string on already-existing GET/POST calls; negligible payload growth (a `YYYY-MM-DD` string or `null` per issue), no new HTTP round-trip, no new pagination behavior. |

## Regression Baseline

- **Total existing tests:** `cargo test` across `tests/*.rs` + inline `#[cfg(test)]`
  modules — not re-counted here (see F4 for the exact baseline count via `cargo
  test` before/after diff); the point is the full suite runs unscoped per Rule 1
  of the scoping rules, not just the files below.
- **Tests in risk zone (touch `get_issue`/`search_issues`/`issue view`/`issue
  list` output):** `tests/issue_commands.rs` (54 `async fn test_*`, includes the
  BC-2.2.028/BC-2.3.036 source tests), `tests/issue_read_holdouts.rs`,
  `tests/issue_view_errors.rs`, `tests/boards_sprints_holdouts.rs` (9 tests, list
  path via board/sprint JQL), `tests/issue_list_assets.rs`,
  `tests/team_column_parity.rs`, `tests/cache_warm_hit.rs`,
  `tests/all_flag_behavior.rs`, `tests/multi_profile_fields.rs`,
  `tests/rate_limit_cap_tests.rs` (5 tests, search-path rate-limit retry),
  `tests/search_issue_keys.rs` (16 tests — NOTE: this exercises the SEPARATE
  keys-only search path, `fields: ["key"]`, NOT `BASE_ISSUE_FIELDS`; almost
  certainly unaffected, listed here only for completeness since it lives in the
  same "search" family), `tests/e2e_live.rs` (gated, `#[ignore]`, not run in CI by
  default).
- **Known test requiring a mandatory update (not merely at risk):**
  `tests/issue_commands.rs::test_search_issues_includes_labels_parent_issuelinks`
  (see Risk Assessment above).
- **Known tests to EXTEND by direct precedent (issue #59 pattern), not required
  but strongly recommended in F4:** `tests/issue_commands.rs::
  get_issue_includes_standard_fields` and `::get_issue_null_standard_fields` —
  these are literally the tests issue #59 added for `created`/`updated`/
  `reporter`; the same present/absent pair should gain `duedate` assertions.
  `tests/common/fixtures.rs::issue_response_with_standard_fields` is the shared
  fixture backing both — adding a `"duedate"` key there is the natural extension
  point.

## Scope Recommendation

- **Mode:** Feature Mode (F1-F7), standard scope — NOT quick dev, NOT bug-fix
  shortcut (see Trivial/Intent classifications above).
- **Estimated new stories:** 1 (single cohesive story covering both the JSON
  one-liner and the human-render additions — they share one root-cause fix and
  splitting them would create a needless dependency between two stories touching
  overlapping files).
- **Estimated effort:** Small (few hours of implementation + tests); the design
  decisions in Open Questions below are the actual effort driver, not the code.
- **Can parallelize:** N/A — single story, sequential within it (fields-list change
  first, since both JSON and human paths depend on the server actually returning
  the field).

## Open Questions

1. **`issue list` Due Date column: always-on or flag-gated?** Existing precedent
   has two patterns: `Created`/`Updated`/`Reporter` are unconditional in `issue
   view`'s detail table (single-issue, no width pressure), while `Points`/`Team`/
   `Assets` in `issue list` are opt-in via `--points`/config/`--assets` (multi-row
   table, width-constrained, and — per `BC-2.1.016`/`BC-2.1.017` — `--assets` is
   even auto-enabled contextually). Which precedent does Due Date follow? A
   plausible default: always-on in `issue view` (mirrors `created`/`updated`), but
   `issue list` needs an explicit decision — always-on (simple, but adds width to
   every list call) vs. a new `--due-date` flag (consistent with the opt-in
   precedent, but adds another CLI flag for a field many teams never set) vs.
   auto-shown-when-any-row-has-a-value (a new, currently-unprecedented pattern in
   this codebase — `--assets` auto-enable is triggered by an unrelated filter flag,
   not by data sparsity).
2. **Column ordering in `issue list` (if added):** where does Due Date sit relative
   to the existing Key/Type/Status/Priority/[Points]/Assignee/[Team]/[Assets]/
   Summary sequence? Adjacent to Priority (both are triage-relevant)? Just before
   Summary (last non-terminal column, matching where `Assets` sits today)?
3. **Unset due date rendering:** `"-"` (the `Created`/`Updated`/`Points` convention
   in this exact table) or `"(none)"` (the `Reporter`/`Labels`/`Parent`/`Links`
   convention, also in this exact table)? Both conventions coexist today in
   `handle_view`'s `rows` vec with no single documented rule distinguishing them —
   F2 should either pick one for Due Date with explicit rationale or use this as
   the trigger to document the existing split.
4. **Date-only vs datetime formatting:** `format_comment_date` (the shared
   formatter reused by `Created`/`Updated`) parses RFC3339/Jira-offset
   **datetime** strings and outputs `"%Y-%m-%d %H:%M"`. Jira's `duedate` field is
   **date-only** (`YYYY-MM-DD`, confirmed by the issue's own repro:
   `"duedate":"2027-07-30"`), with no time component to parse or display. Reusing
   `format_comment_date` verbatim would either fail to parse (falls through to the
   raw-string fallback path, which is at least safe but ugly) or need a sibling
   date-only formatter. This needs its own small function/test, not a blind reuse
   — flag explicitly for F3/F4 so it isn't assumed away.
5. **Named struct field vs. `extra` HashMap:** confirm in F2 whether the team wants
   a named `pub duedate: Option<String>` field on `IssueFields` (matches
   `created`/`updated` precedent, needed anyway for the human-render path's
   `issue.fields.duedate` access) or whether to lean on `#[serde(flatten)] extra`
   and access it via `issue.fields.extra.get("duedate")` in `view.rs`/`format.rs`.
   Recommendation leans toward the named field (consistency + ergonomics), but
   this is a design call, not dictated by this analysis.
6. **Relationship to the `--fields <CSV>` proposal (issue #575):** the GitHub issue
   author flagged that a future `--fields` escape hatch (issue #575, not yet
   built) would let users request arbitrary fields, potentially reducing the need
   to special-case `duedate` in `BASE_ISSUE_FIELDS`. #575 is explicitly out of
   scope here (not requested by the human, no existing spec artifact for it found
   in `.factory/`) — noted only so F2 doesn't accidentally conflate the two.
7. **BC backfill gap:** no existing BC enumerates `issue list`'s table column set
   as a contract in its own right (only the row-builder/header-builder code
   defines it implicitly). Should F2 write that BC now (as a foundation the new
   Due Date column BC amends), or treat this as pre-existing spec debt tracked
   separately? Recommend: write it now, since the new Due Date BC needs to
   reference *something* as the base column list it's extending.
