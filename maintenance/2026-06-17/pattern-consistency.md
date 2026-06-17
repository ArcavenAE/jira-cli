# Pattern Consistency & Lint Health — Maintenance Sweep 3

**Date:** 2026-06-17
**Branch:** develop @ 3ba8ea2
**Scope:** Read-only scan. No code changes.

---

## 1. Lint Health

### 1.1 `cargo clippy --all-targets -- -D warnings`

**Result: PASS (exit 0, zero warnings)**

No clippy findings. The zero-warning policy is in force and upheld.

### 1.2 `cargo fmt --all -- --check`

**Result: PASS (exit 0, no diffs)**

Format is consistent throughout the codebase.

### 1.3 `#[allow(...)]` inventory

Three occurrences in source (excluding tests and comments):

| Location | Attribute | Verdict |
|---|---|---|
| `src/adf.rs:8483` | `#[allow(clippy::too_many_lines)]` | Undocumented suppression on a test function — policy says refactor or add justification comment |
| `src/api/refresh_coordinator.rs:56` | `#[allow(dead_code)]` | On `reset_for_test` inside `#[cfg(test)]` — acceptable; dead_code fires because the fn isn't called from within the same cfg block |
| `src/types/jira/editmeta.rs:23,62` | Comments warning future editors about `#[allow(dead_code)]` — not actual `#[allow]` attributes | Clean |

The `adf.rs:8483` suppression is the only one that may warrant a justification comment under the project policy.

---

## 2. Module Size / Structure Deviations

| File | Actual LOC | Status |
|---|---|---|
| `src/cli/issue/list.rs` | 1,256 | **Above target.** Target was ≤750 (docs/specs/list-rs-split.md). 173 LOC added since the 1,083 count in CLAUDE.md — likely from the date-filter expansion (issues #489, #474, etc.). |
| `src/cli/issue/create.rs` | 2,880 | No formal LOC target, but this is the largest single handler file. |
| `src/cli/issue/workflow.rs` | 1,345 | No formal LOC target. |
| `src/cli/issue/helpers.rs` | 836 | No formal LOC target. |
| `src/adf.rs` | 10,526 | Monolithic; internally well-structured with region comments. No target. |
| `src/cache.rs` | 1,690 | Well within reason. |

### 2.1 `src/cli/issue/list.rs` — remaining split candidates

`handle_list` itself spans lines 56–596 (540 lines), a monolithic async function. The non-`handle_list` helpers (`extract_unique_status_names`, `build_jql_base_parts`, `resolve_show_points`, `build_filter_clauses`, `FilterOptions`) total only ~100 lines; the bulk is the handler body.

**Extractable coherent chunks inside `handle_list`:**

1. **Status validation block** (lines ~205–260) — resolves `--status` via `partial_match`, produces `resolved_status: Option<String>`. Self-contained with no handler-local mutable state beyond its return value.
2. **Team resolution block** (lines ~160–172) — calls `resolve_team_field`, builds `team_clause`. Already uses `helpers::resolve_team_field`.
3. **CMDB/asset enrichment block** (lines ~360–435) — fetches CMDB fields, calls `enrich_assets`/`enrich_json_assets`. Currently inlined; this is also called from `view.rs` via different helpers, suggesting a shared enrichment helper could reduce duplication.
4. **Table row-building block** (lines ~460–570) — iterates issues, builds `rows: Vec<Vec<String>>`, applies team-column logic. Pure transform with no side effects.

Extracting (1) and (4) into private `async fn` / `fn` helpers inside `list.rs` would bring `handle_list` closer to 300–350 lines without crossing file boundaries. Extraction (3) touches both `list.rs` and `view.rs` and should be planned with both callers in view (medium-size refactor).

### 2.2 `src/cli/issue/create.rs` — split candidates

At 2,880 LOC the file mixes four distinct concerns:

- **`handle_create` / `handle_jsm_create`** (lines 31–295 + 2455–2736) — create path.
- **`handle_edit` single-key path** (lines 297–~1145) — ~850 lines.
- **`handle_edit` bulk label/field paths** (`handle_edit_bulk_labels`, `handle_edit_bulk_fields`, lines 1204–1520) — ~316 lines.
- **JSM request-type resolution** (`resolve_jsm_request_type_id`, lines 2737–2880) — ~143 lines.
- **`Classification` enum + `is_cross_hierarchy_type_error`** (lines 1519–1572) — pure function, good extraction candidate into a `type_error.rs` or back into `helpers.rs`.

A `bulk_edit.rs` split (extracting `handle_edit_bulk_labels`, `handle_edit_bulk_fields`, `build_labels_edited_fields`, `render_bulk_edit_results`) would reduce `create.rs` by ~400–450 lines and improve locality of the bulk-label asymmetry gotchas.

---

## 3. DRIFT-331-PAGINATION — Inline Pagination Reimplementations

### 3.1 Confirmed: `get_issue_types_for_project` reimplements pagination inline

`src/api/jira/issues.rs::get_issue_types_for_project` (lines 694–724) uses a hand-rolled `loop { … start_at += page_len; }` against a custom `CreatemetaIssueTypesResponse` struct. It CANNOT reuse `OffsetPage<T>` because `createmeta/{project}/issuetypes` uses a `PageOfCreateMetaIssueTypes` shape (`{issueTypes, startAt, maxResults, total}`) instead of the `OffsetPage` shapes (`values`, `issues`, `worklogs`, `comments`). This divergence is a Jira API schema quirk, not a code defect — the comment in the rustdoc explains it. The inline implementation is correct and the alternative (adding a fifth field to `OffsetPage`) would be worse.

**Verdict:** Justified deviation; not actionable without changing the abstraction.

### 3.2 Other inline pagination instances

| Location | Reuses `OffsetPage<T>`? | Anti-stall guard? | Notes |
|---|---|---|---|
| `src/api/jira/boards.rs::list_boards` | Yes (`OffsetPage<Board>`) | No | Benign — no production-reported stall scenarios for boards |
| `src/api/jira/sprints.rs::list_sprints` | Yes (`OffsetPage<Sprint>`) | No | Same |
| `src/api/jira/sprints.rs::get_sprint_issues` | Yes (`OffsetPage<Issue>`) | No | Same |
| `src/api/jira/worklogs.rs::list_worklogs` | Yes (`OffsetPage<Worklog>`) | No | Same |
| `src/api/jira/users.rs::search_users_all` | No (custom per-page fn) | Implicit (USER_PAGE_SIZE-fixed advance) | Documented JRACLOUD-71293 workaround; acceptable |
| `src/api/jira/users.rs::search_assignable_users_by_project_all` | No (custom per-page fn) | Implicit (USER_PAGE_SIZE-fixed advance) | Same |
| `src/api/jira/issues.rs::get_changelog` | Yes (`OffsetPage<ChangelogEntry>`) | **Yes** (`next <= start_at` guard) | Most defensive |
| `src/api/jira/issues.rs::list_comments` | Yes (`OffsetPage<Comment>`) | **No** | Pattern inconsistency — see CR-001 below |

The `items()` accessor on `OffsetPage` (`src/api/pagination.rs:37`) provides a unified extraction path that eliminates the `.values.unwrap_or_default()` / `.issues.unwrap_or_default()` pattern. Most callers use the specific field directly (e.g., `page.values.unwrap_or_default()`); only 4 of 8 pagination loops use `.items()`. This is a low-priority style inconsistency.

---

## 4. Pattern Inconsistencies

### CR-001 — Pagination anti-stall guard absent from `list_comments`
- **Severity:** LOW
- **Category:** pattern-consistency
- **Location:** `src/api/jira/issues.rs::list_comments` (line 636–674)
- **Description:** `get_changelog` has an explicit guard: if `next <= start_at`, it returns an error instead of looping forever. `list_comments` does not — a pathological Jira response that returns `has_more=true` but doesn't advance `start_at` would infinite-loop. The risk is low (comment endpoints are more stable), but the pattern diverges from the project's explicit guard in `get_changelog`.
- **Evidence:** `get_changelog` lines 618–628 vs `list_comments` lines 656–672 — no equivalent guard.
- **Proposed Fix:** Add `if next <= start_at { break; }` (or an `Err(...)` return matching `get_changelog`'s style) after `start_at = next;` in `list_comments`.

### CR-002 — Dual JSON serialization paths: `output::render_json` vs `serde_json::to_string_pretty`
- **Severity:** LOW
- **Category:** pattern-consistency
- **Location:** Multiple CLI files; 24 occurrences of `serde_json::to_string_pretty` vs 14 of `output::render_json` in `src/cli/`
- **Description:** `output::render_json` is a thin wrapper around `serde_json::to_string_pretty` that adds an `anyhow` error conversion. Callers are inconsistently split: state-changing command success paths (create, edit, move, link, comment) predominantly call `serde_json::to_string_pretty` directly inside `println!`, while read-command paths use `output::render_json`. The two paths are functionally identical but the inconsistency makes it harder to intercept JSON rendering globally (e.g., for future `--color` JSON syntax highlighting or a `_meta` envelope).
- **Affected files:** `src/cli/issue/create.rs` (4 sites), `src/cli/issue/workflow.rs` (2 sites), `src/cli/issue/links.rs` (4 sites), `src/cli/auth/{login,logout,remove,refresh,list}.rs`, `src/cli/sprint.rs`.
- **Proposed Fix:** Replace `println!("{}", serde_json::to_string_pretty(&x)?)` with `println!("{}", output::render_json(&x)?)` in all non-test callers. Mechanical change, zero behavioral difference. The `output::render_json` return type already maps to `anyhow::Result<String>` so no error-handling changes are needed.

### CR-003 — `src/cli/issue/list.rs` LOC drifted above the tracked deviation
- **Severity:** LOW
- **Category:** maintainability
- **Location:** `src/cli/issue/list.rs`
- **Description:** CLAUDE.md documents 1,083 LOC as the known deviation. The file is now 1,256 LOC — 173 lines of undocumented growth since the last check. The NFR-O-G annotation (`DOCUMENT-AS-IS-COMPLETE, S-3.08`) should be updated to reflect the current count, or the growth should trigger a partial split.
- **Evidence:** `wc -l src/cli/issue/list.rs` → 1,256.
- **Proposed Fix:** Either update the CLAUDE.md "Known Size Deviations" entry to 1,256 LOC and document the cause (date-filter expansion), or extract the status-validation block and table-row-building block into private helpers (~200 LOC reduction; see §2.1 above).

### CR-004 — `#[allow(clippy::too_many_lines)]` in `src/adf.rs` lacks a justification comment
- **Severity:** LOW
- **Category:** maintainability
- **Location:** `src/adf.rs:8483`
- **Description:** CLAUDE.md policy: "No lint suppression without refactoring. If refactoring is impractical, ask the user before suppressing and include a justification comment." The suppression exists on what appears to be a test function. There is no justification comment alongside the attribute.
- **Evidence:** `src/adf.rs:8483: #[allow(clippy::too_many_lines)]`
- **Proposed Fix:** Add a one-line justification comment immediately above: `// Too many lines: test function drives all GFM alert variants in one pass; splitting would obscure coverage intent.` (or similar). This is the minimum required to satisfy the policy; refactoring is not required if impractical.

### CR-005 — `OffsetPage::items()` accessor underused; callers access named fields directly
- **Severity:** LOW
- **Category:** pattern-consistency
- **Location:** `src/api/jira/{boards,sprints,worklogs,issues}.rs` (multiple pagination loops)
- **Description:** `OffsetPage<T>` provides an `items()` method that returns whichever field (`values`, `issues`, `worklogs`, `comments`) is populated. Most callers access the specific field directly (`page.values.unwrap_or_default()`, `page.issues.unwrap_or_default()`, etc.), requiring the caller to know the Jira API's field name. Only `src/api/jira/projects.rs` appears to use `items()`. Using `items()` uniformly would decouple callers from per-endpoint field naming.
- **Proposed Fix:** Replace `.values.unwrap_or_default()` / `.issues.unwrap_or_default()` / `.worklogs.unwrap_or_default()` calls in pagination loops with `page.items().to_vec()` or `all.extend(page.items().iter().cloned())`. Low priority — the current code is correct, only not uniform.

### CR-006 — `src/cli/project.rs` uses raw `println!` for both table and JSON output instead of `output::print_output`
- **Severity:** LOW
- **Category:** pattern-consistency
- **Location:** `src/cli/project.rs` lines 83–129
- **Description:** All other commands route through `output::print_output(format, headers, rows, json_data)`. `project fields` bypasses this: the Table branch hand-formats multi-section prose with raw `println!` calls, and the JSON branch calls `println!("{}", serde_json::json!(...))` directly. This is intentional (the output has a multi-section structure that doesn't fit `print_output`'s single-table model), but it creates a hard-to-grep outlier when auditing output-channel discipline. The inconsistency is structural, not a bug.
- **Proposed Fix (if desired):** Accept as documented deviation — `project fields` output is intentionally multi-section and cannot be reduced to a flat header+rows table without losing information. Add a comment at the top of the `OutputFormat::Table` branch: `// Multi-section prose — cannot use output::print_output (no flat rows model).`

### CR-007 — Cache write error model is undocumented for `write_object_type_attr_cache`
- **Severity:** LOW
- **Category:** maintainability
- **Location:** `src/api/assets/objects.rs:189` / `src/cache.rs::write_object_type_attr_cache`
- **Description:** CLAUDE.md documents two write-error models: (a) propagate via `?` (correctness-critical), (b) swallow + `eprintln!` (pure read-acceleration). `write_fields_cache` and the request-type writers have explicit rustdoc choosing (b). `write_team_cache`, `write_workspace_cache`, `write_resolutions_cache`, `write_cmdb_fields_cache` all propagate via `?` (model a). `write_object_type_attr_cache` uses `let _ = cache::write_object_type_attr_cache(...)` (silently ignoring the result) WITHOUT a corresponding rustdoc comment in the cache module choosing the model. This is inconsistent with the documented pattern.
- **Evidence:** `src/api/assets/objects.rs:189`: `let _ = cache::write_object_type_attr_cache(profile, type_id, &cached);` — discards error silently. The `write_object_type_attr_cache` function itself in `cache.rs` propagates via `?` (model a), yet its only caller silently discards the return value.
- **Proposed Fix:** Either (a) change `write_object_type_attr_cache` to a best-effort writer (model b, with rustdoc and an `eprintln!` on error), consistent with the calling convention, or (b) propagate the error at the call site in `objects.rs`. Add a CLAUDE.md gotcha note matching the request-type cache entry.

---

## 5. Duplicate Logic / Batch-Refactor Candidates

### 5.1 Date validation pattern repeated four times in `handle_list`

`src/cli/issue/list.rs` lines 97–128 validate `created_after`, `created_before`, `updated_after`, `updated_before` with four nearly-identical `if let Some(ref d) = ... { Some(validate_date(d)?) } else { None }` blocks. This could be a `validate_date_flag(opt: Option<&String>) -> Result<Option<NaiveDate>>` helper (3 lines) called four times, reducing the block from 32 lines to 8. Low complexity refactor.

### 5.2 JSM write-error escalation block duplicated in `create.rs`

`src/cli/issue/create.rs` lines ~2670–2715 contain a `match downcast-JrError { NotAuthenticated => …, InsufficientScope => … }` escalation block that rewrites the error message to include JSM scope hints. A similar pattern exists in `src/api/jsm/servicedesks.rs::require_service_desk`. Not identical, but the "downcast, classify, re-wrap" structure is repeated. Medium complexity to extract.

### 5.3 `unwrap_or_default` on `Option<Vec<T>>` in pagination loops

Seven pagination loops access a named field via `.field.unwrap_or_default()` instead of `page.items()`. As noted in CR-005, this is a mechanical batch replacement. One `sed`-equivalent pass could normalize all seven sites.

---

## 6. Summary

| Area | Status |
|---|---|
| `cargo clippy -D warnings` | **PASS** |
| `cargo fmt --check` | **PASS** |
| `#[allow]` without justification | 1 instance (`adf.rs:8483`) |
| Pattern findings | 7 (all LOW severity) |
| Critical/High findings | **0** |

**Top items by effort/impact:**

1. **CR-002** (batch, mechanical) — Replace 24 `serde_json::to_string_pretty` call sites with `output::render_json`. Zero behavioral impact; enables future centralized JSON transforms.
2. **CR-003** (doc update or small refactor) — Update CLAUDE.md Known Size Deviations for `list.rs` (now 1,256 LOC), or extract 2 private helpers to reduce it.
3. **CR-007** (1–2 line change) — Align `write_object_type_attr_cache` call-site error handling with the documented two-model policy.
4. **CR-001** (1–3 line change) — Add anti-stall guard to `list_comments` matching `get_changelog`.
5. **CR-004** (1 line comment) — Add justification to `adf.rs:8483` `#[allow]`.

CONVERGENCE_REACHED — no CRITICAL or HIGH findings; all findings are LOW severity maintenance improvements.
