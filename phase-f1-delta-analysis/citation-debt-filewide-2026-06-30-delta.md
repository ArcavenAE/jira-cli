# F1 Delta Analysis — Citation-Debt Cleanup (ADR-0012 Seam A/B extraction fallout)

**Date:** 2026-06-30
**Mode:** Feature-Mode Phase F1 (delta analysis) — SPEC-ONLY citation-correction cycle
**Primary target:** `.factory/specs/prd/bc-3-issue-write.md`
**Deliverable:** verified citation-correction map (this document). No BC spec files are edited in F1.

---

## 0. Ground-Truth Source Tree (verified 2026-06-30)

Symbol locations established by `grep` against the live `src/cli/issue/` tree (post ADR-0012 Seam A/B split):

| Symbol | Ground-truth location | Verified by |
|---|---|---|
| `handle_create` | `src/cli/issue/create.rs:17` | `pub(super) async fn handle_create(` |
| `parse_field_kv` | `src/cli/issue/create.rs:293` | `pub(crate) fn parse_field_kv(pairs: &[String])` |
| `handle_jsm_create` | **`src/cli/issue/jsm_create.rs:92`** | `pub(super) async fn handle_jsm_create(` |
| `resolve_jsm_request_type_id` | **`src/cli/issue/jsm_create.rs:377`** | `async fn resolve_jsm_request_type_id(` |
| JSM 401 `map_err` auth-rewrite (`write:servicedesk-request` / API-token hint) | **`src/cli/issue/jsm_create.rs:307–350`** | `is_oauth = client.is_oauth_auth()` + `.map_err(|e| match e.downcast::<JrError>()` |
| JSM project-key resolution (`"Project key is required for JSM request creation"`) | **`src/cli/issue/jsm_create.rs:130–143`** | `helpers::prompt_input("Project key")` + JSM-specific error string |
| `handle_edit` | `src/cli/issue/edit.rs:27` | `pub(super) async fn handle_edit(` |
| `has_any_field_change` | `src/cli/issue/edit.rs:106` | `let has_any_field_change = summary.is_some()` |
| `has_updates` | `src/cli/issue/edit.rs:634` | `let mut has_updates = false;` |
| `CROSS_HIERARCHY_HINT` | `src/cli/issue/edit.rs:1259` | `const CROSS_HIERARCHY_HINT: &str =` |
| `NO_PARENT_CONTEXT_SENTENCE` | `src/cli/issue/edit.rs:1254` | `const NO_PARENT_CONTEXT_SENTENCE: &str =` |
| `is_cross_hierarchy_type_error` | `src/cli/issue/edit.rs:1288` | `fn is_cross_hierarchy_type_error(` |
| `is_subtask_parent_error` | `src/cli/issue/edit.rs:1247` | `fn is_subtask_parent_error(err: &anyhow::Error)` |
| `--no-parent` 400 path (`no_parent && is_subtask_parent_error`) | `src/cli/issue/edit.rs:817–819` | `if no_parent && is_subtask_parent_error(e)` |
| `build_labels_edited_fields` | `src/cli/issue/edit.rs:879` | `fn build_labels_edited_fields(` |
| `handle_edit_bulk_labels` | `src/cli/issue/edit.rs:935` | `async fn handle_edit_bulk_labels(` |
| `handle_edit_bulk_fields` | `src/cli/issue/edit.rs:1059` | `async fn handle_edit_bulk_fields(` |
| `effective_keys` | `src/cli/issue/edit.rs` (only) | `grep -rln effective_keys → edit.rs` |
| `resolve_edit_fields` | **`src/cli/issue/field_resolve.rs:182`** | `pub(crate) async fn resolve_edit_fields(` |
| `is_team_uuid` | `src/cli/issue/helpers.rs:14` | `fn is_team_uuid(s: &str) -> bool` |
| `is_team_uuid_rejects_wrong_length` (test) | `src/cli/issue/helpers.rs:629` | `fn is_team_uuid_rejects_wrong_length()` |
| `resolve_team_field` | `src/cli/issue/helpers.rs:36` | `pub(super) async fn resolve_team_field(` |
| `compose_extra_fields` | `src/cli/issue/helpers.rs:194` | `pub(super) fn compose_extra_fields(` |
| `resolve_story_points_field_id` | `src/cli/issue/helpers.rs:212` | `pub(super) fn resolve_story_points_field_id(` |
| `get_project_issue_types` | `src/api/jira/projects.rs:37` | `pub async fn get_project_issue_types(` |
| `get_issue_types_for_project` | `src/api/jira/issues.rs:705` | `pub(crate) async fn get_issue_types_for_project(` |
| `get_editmeta` | `src/api/jira/issues.rs:505` | `pub async fn get_editmeta(` |
| `update_issue_labels` | `src/api/jira/issues.rs:468` | `pub async fn update_issue_labels(` |
| `bulk_edit_fields` | `src/api/jira/bulk.rs:260` | `pub async fn bulk_edit_fields(` |
| `bulk_transition` | `src/api/jira/bulk.rs:287` | `pub async fn bulk_transition(` |
| `await_bulk_task_inner` | `src/api/jira/bulk.rs:380` | `async fn await_bulk_task_inner(` |
| `parse_error` | `src/api/client.rs:973` | `async fn parse_error(response: Response)` |

**`create.rs` is now 394 LOC** (`wc -l cli/issue/create.rs → 394`). Therefore ANY `create.rs:NNNN` citation with `NNNN ≥ 395` is a **dead line number pointing past EOF**. The stale JSM citations (`create.rs:1882-1891`, `create.rs:1988-1995`, `create.rs:830-837`, `create.rs:834`, `create.rs:2005`, `create.rs:2017`) are all pre-split line numbers from the 2,447-LOC monolith.

---

## 1. Hypothesis Verdicts (explicitly requested)

### Hypothesis A — `handle_jsm_create` / NotAuthenticated-rewrite citations cite `create.rs` but symbol moved to `jsm_create.rs`
**CONFIRMED.** `handle_jsm_create` is at `jsm_create.rs:92`. The `write:servicedesk-request` OAuth hint and the Basic-auth API-token rewrite `map_err` block is at `jsm_create.rs:307–350` (found via `grep write:servicedesk-request → jsm_create.rs:317/335/339`). Every BC-3.8.x citation to `create.rs:1988-1995` and `create.rs::handle_jsm_create` is STALE → correct file is `jsm_create.rs`. The JSM project-key resolution cited as `create.rs:1882-1891` is at `jsm_create.rs:130–143`.

### Hypothesis B — `resolve_edit_fields` cited to `helpers.rs` but actually in `field_resolve.rs`
**CONFIRMED.** `resolve_edit_fields` is at `field_resolve.rs:182`. There is NO `resolve_edit_fields` in `helpers.rs`. BC-3.4.015 **Source** (line 1118) and **Trace** (line 1435) both cite `helpers.rs::resolve_edit_fields` → STALE → `field_resolve.rs::resolve_edit_fields`. NOTE: BC-3.4.021 (line 2016) and BC-3.4.015 body Steps (lines 1166, 1289) ALREADY correctly cite `field_resolve.rs` — the debt is only in BC-3.4.015's Source/Trace headers.

### Hypothesis C — dead `create.rs` line numbers (1882-1891 / 1988-1995 / 2005 / 2017 …) point past current 394-LOC file
**CONFIRMED.** `create.rs` is 394 LOC. All of `1882-1891`, `1988-1995`, `2005`, `2017`, `830-837`, `834` exceed EOF. They are all pre-split monolith line numbers and are dead. (Note: `create.rs:341` in the frontmatter change-log — for `has_any_field_change` — is *in range* numerically but points at the WRONG symbol location; that guard is at `edit.rs:106`. See §4.)

**No hypothesis was accepted on faith — each was grep-verified against the live tree.**

---

## 2. Correction Map — `bc-3-issue-write.md`

Change types: **RELOCATE** (wrong file, symbol moved) · **LINE→SYMBOL** (bare/dead line → `<file>::<fn>`) · **NO-CHANGE-CORRECT** (verified accurate, do not touch).

### 2A. RELOCATE + LINE→SYMBOL — `create.rs` → `jsm_create.rs` (JSM handler cluster)

| BC-ID | Field / line | Current (stale) citation | Verified correct symbol-form citation | Evidence | Change type |
|---|---|---|---|---|---|
| BC-3.8.002 | body (line 2223) | `` `create.rs:1882-1891` `` (project-key resolution) | `` `src/cli/issue/jsm_create.rs::handle_jsm_create` `` (project-key resolution block, step 0) | `jsm_create.rs:130-143` — `prompt_input("Project key")` + `"Project key is required for JSM request creation"` | RELOCATE + LINE→SYMBOL |
| BC-3.8.003 | note (line 2244) | "Wave 3 `cli/issue/create.rs` dispatch fork (lines 2005, 2017)" | `` `src/cli/issue/jsm_create.rs` `` (RT-resolution hint site) — drop dead lines 2005/2017 | `resolve_jsm_request_type_id` at `jsm_create.rs:377`; dispatch fork decision remains in `create.rs::handle_create` but the "Run …" hint text now lives on the JSM path in `jsm_create.rs` | RELOCATE + LINE→SYMBOL |
| BC-3.8.009 | Trace (line 2333) | `` `src/cli/issue/create.rs` `` (generic — `raiseOnBehalfOf` injection) | `` `src/cli/issue/jsm_create.rs::handle_jsm_create` `` | `raiseOnBehalfOf` handling is in the JSM builder path reached from `jsm_create.rs:92` | RELOCATE |
| BC-3.8.009 | UPDATED note (line 2337) | `` `src/cli/issue/create.rs:1988-1995` `` (`NotAuthenticated` map_err rewrite) | `` `src/cli/issue/jsm_create.rs::handle_jsm_create` §"map_err auth-rewrite" `` | `jsm_create.rs:312-350` `.map_err(... NotAuthenticated ... write:servicedesk-request)` | RELOCATE + LINE→SYMBOL |
| BC-3.8.009 | REVISED note (line 2339) | `` `src/cli/issue/create.rs:1988-1995` `` | same as above → `jsm_create.rs::handle_jsm_create` map_err | `jsm_create.rs:307-350` | RELOCATE + LINE→SYMBOL |
| BC-3.8.015 | body (line 2562) | `` `src/cli/issue/create.rs:1988-1995` `` (`NotAuthenticated` arm rewrite) | `` `src/cli/issue/jsm_create.rs::handle_jsm_create` §"NotAuthenticated arm" `` | `jsm_create.rs:313-327` (`Ok(JrError::NotAuthenticated { .. }) =>`) | RELOCATE + LINE→SYMBOL |
| BC-3.8.016 | Trace (line 2623) | `` `src/cli/issue/create.rs::handle_jsm_create` `` (guard at very top) | `` `src/cli/issue/jsm_create.rs::handle_jsm_create` `` | `handle_jsm_create` at `jsm_create.rs:92`; empty-RT guard at `jsm_create.rs:143` region | RELOCATE (wrong file, symbol correct) |
| BC-3.8.017 | Trace (line 2657) | `` `src/cli/issue/create.rs::handle_jsm_create` `` (guard at top) | `` `src/cli/issue/jsm_create.rs::handle_jsm_create` `` | `handle_jsm_create` at `jsm_create.rs:92`; markdown+field guard at `jsm_create.rs:150` region | RELOCATE (wrong file, symbol correct) |
| Canonical Guard Ordering | step 0 (line 2601) | `` `create.rs:1882-1891` `` (project-key resolution) | `` `src/cli/issue/jsm_create.rs::handle_jsm_create` `` (step 0) | `jsm_create.rs:130-143` | RELOCATE + LINE→SYMBOL |

### 2B. RELOCATE + LINE→SYMBOL — `create.rs` → `edit.rs` (historical `--no-parent`/convert-hint narrative)

| BC-ID | Field / line | Current (stale) citation | Verified correct symbol-form citation | Evidence | Change type |
|---|---|---|---|---|---|
| BC-3.4.010 | postcondition (line 695) | removed fake-convert-hint "at `` `src/cli/issue/create.rs:834` ``" | `` `src/cli/issue/edit.rs::handle_edit` §"--no-parent 400 path" `` (historical: hint removed) | `--no-parent` path now at `edit.rs:817-819`; `NO_PARENT_CONTEXT_SENTENCE` at `edit.rs:1254`; `create.rs:834` is past EOF (394 LOC) | RELOCATE + LINE→SYMBOL (historical/removed-code note) |
| BC-3.4.010 | replacement-scope (line 713) | "prior `--no-parent` hint block at `` `src/cli/issue/create.rs:830-837` ``" | `` `src/cli/issue/edit.rs::handle_edit` `` (block relocated + already replaced) | `no_parent` handling in `edit.rs` (`edit.rs:817`); `create.rs:830-837` past EOF | RELOCATE + LINE→SYMBOL (historical narrative) |

> Note: 2B citations describe *removed* pre-refactor code as part of a regression-pin narrative. They are not runtime contracts, but they carry dead `create.rs` line numbers pointing past EOF and name the wrong file. F2 should either (a) repoint to `edit.rs::handle_edit`, or (b) reframe as "the removed hint (formerly in `create.rs`, now `edit.rs`)" without a line number. The load-bearing part — the negative substring pin `jr api /rest/api/3/issue` — is unaffected.

### 2C. RELOCATE — `helpers.rs` → `field_resolve.rs` (Hypothesis B)

| BC-ID | Field / line | Current (stale) citation | Verified correct symbol-form citation | Evidence | Change type |
|---|---|---|---|---|---|
| BC-3.4.015 | Source (line 1118) | `` `src/cli/issue/helpers.rs::resolve_edit_fields` `` | `` `src/cli/issue/field_resolve.rs::resolve_edit_fields` `` | `resolve_edit_fields` at `field_resolve.rs:182`; absent from `helpers.rs` | RELOCATE |
| BC-3.4.015 | Trace (line 1435) | `` `src/cli/issue/helpers.rs::resolve_edit_fields` `` | `` `src/cli/issue/field_resolve.rs::resolve_edit_fields` `` | same | RELOCATE |

---

## 3. Verified-Correct Perimeter (do NOT touch — inspected and confirmed accurate)

These citations were inspected and are ground-truth accurate; F2 must leave them unchanged:

- **BC-3.4.015 (line 1133)** & **EC-3.4.017-10 (line 1686)**: `` `src/cli/issue/create.rs::parse_field_kv` `` → CORRECT (`create.rs:293`). `parse_field_kv` genuinely stayed in `create.rs`.
- **BC-3.4.014 Source (line 1008) + Trace (line 1100)**: `` `create.rs::handle_create` `` → CORRECT (`create.rs:17`); `` `helpers.rs::resolve_team_field` `` → CORRECT (`helpers.rs:36`).
- **BC-3.4.012 Trace (line 889)**: `` `helpers.rs::resolve_team_field` `` → CORRECT.
- **BC-3.8.001 Trace (line 2208)**: `` `src/cli/issue/create.rs` `` (conditional dispatch branch) → CORRECT — the `--request-type`→`handle_jsm_create` *fork decision* lives in `create.rs::handle_create`. (Optional precision improvement only: `create.rs::handle_create` dispatch fork.)
- **BC-3.4.021 (line 2016)**: `` `src/cli/issue/field_resolve.rs::resolve_edit_fields` step 6 `` → ALREADY CORRECT.
- **BC-3.4.015 body (lines 1166, 1289)**: `` `src/cli/issue/field_resolve.rs` `` Step 3 error → ALREADY CORRECT.
- **BC-3.4.010 / BC-3.4.011 Trace + body**: `edit.rs::is_cross_hierarchy_type_error`, `edit.rs::CROSS_HIERARCHY_HINT`, `edit.rs::handle_edit`, the `is_cross_hierarchy_type_error_proptests` module → ALL CORRECT (`edit.rs:1288/1259/27`).
- **BC-3.4.006, BC-3.4.018, BC-3.4.020**: `edit.rs::build_labels_edited_fields`, `edit.rs::handle_edit_bulk_fields`, `edit.rs::handle_edit_bulk_labels` → ALL CORRECT (`edit.rs:879/1059/935`).
- **BC-3.4.018 Trace**: `src/api/jira/issues.rs::get_issue_types_for_project` → CORRECT (`issues.rs:705`).
- **BC-3.4.012/013/014 VP-398-001 (lines 885, 984, 1096)**: `is_team_uuid` unit test in `src/cli/issue/helpers.rs` → CORRECT FILE (`helpers.rs`), test `is_team_uuid_rejects_wrong_length` genuinely there. Minor: cited "`~line 617`" but actual is `helpers.rs:629` (off by ~12). Since it names the symbol and uses `~`, it is #408-compliant; a courtesy nudge to `~629` is optional, not required.

---

## 4. Bare-Line Citations Flagged for #408 Symbol-Form Conversion

Per the #408 convention (prefer symbol-form; never bare `file:NN-MM` for new citations), the following are **correct-file but bare-line** and drift-prone. These are NOT relocation-stale — they did not move due to the ADR-0012 split — so they are **lower priority** than §2. Recorded for completeness; F2 may convert opportunistically.

**src/ bare-line citations (correct file, drift risk):**
- BC-3.4.001 (line 511/636): `` `src/cli/issue/workflow.rs:636` `` → `workflow.rs::handle_open` (MUST-FIX bug site; single-line ref).
- BC-3.4.009 (lines 632, 656): `` `src/api/jira/bulk.rs:408-418` `` → `bulk.rs::await_bulk_task_inner` (`bulk.rs:380`); `` `src/api/client.rs:585-600` `` → `client.rs::send_inner`.
- BC-3.4.010/011: `` `src/api/jira/projects.rs:47-51` `` → `projects.rs::get_project_issue_types` (`:37`); `` `src/types/jira/issue.rs:62` `` → `issue.rs` `Issue.fields.issuetype` field. (`parse_error ~lines 973-997` is already `~`+symbol → acceptable; `parse_error` at `client.rs:973`.)
- BC-3.4.020: `` `src/api/jira/bulk.rs` lines 271-273 / 317 `` → `bulk.rs::bulk_edit_fields` (`:260`); `update_issue_labels (lines 478-484)` is symbol+in-range (`:468`) → acceptable.
- BC-3.4.021: numerous `edit.rs` line refs (`~431-559`, `480-482`, `675`, `681`, `712`, `454`, `457`, `537`, `407`, `603`, `618`, `559`) — mostly `~`-prefixed; `edit.rs` is 2,067 LOC so in-range but drift-prone.
- BC-3.8.014/015: `` `src/api/client.rs:696-704 / :718 / :727+` `` → `client.rs` 401-handler; `` `src/error.rs:5 / :8-16` `` → `error.rs` `API_TOKEN_EXPIRY_HINT` / render prefixes.

**Frontmatter historical change-log (lines 49-50):** `` `create.rs:341` `` for `has_any_field_change` — WRONG symbol location (guard is `edit.rs::has_any_field_change`, `edit.rs:106`). Body text (EC-3.4.012-16 line 882, line 901) is ALREADY corrected to `edit.rs::has_any_field_change ~line 106`. The `create.rs:341` refs survive only in dated round-12 change-log lines. Low priority — historical record; recommend leaving OR annotating, not rewriting a dated log entry.

**tests/ bare-line citations (pre-existing, unrelated to split):** ~40+ `tests/…rs:NN-MM` refs across BC-3.1.x–3.7.x (e.g. `tests/issue_commands.rs:1646-1703`). These predate and are unaffected by the ADR-0012 extraction. **Recommend scoping OUT of this cycle** (DEFERRAL-PERIMETER-SCOPING) — converting them is a broad test-citation-hygiene effort, not create.rs-extraction debt.

---

## 5. Ambiguous / Unresolvable (escalations)

**NONE.** Every cited symbol was located unambiguously in exactly one file. No symbol was missing from the tree. No escalation required.

---

## 6. Cross-File Perimeter Scan (record-only — DEFERRAL-PERIMETER-SCOPING)

`grep` for `create.rs` / `issue/helpers.rs` citations across the other 6 PRD BC files:

| File | `create.rs` | `helpers.rs` | Verdict |
|---|---|---|---|
| `bc-1-auth-identity.md` | 0 | 0 | clean |
| `bc-2-issue-read.md` | **1** | 0 | **1 STALE relocation** |
| `bc-4-assets-cmdb.md` | 0 | 0 | clean |
| `bc-5-boards-sprints.md` | 0 | 0 | clean |
| `bc-6-config-cache.md` | 3 | 5 | correct-file bare-line only (NOT relocation-stale) |
| `bc-7-output-render.md` | 0 | 0 | clean |

**Detail:**
- **bc-2-issue-read.md line 512** — `` `src/cli/issue/create.rs::handle_edit::effective_keys` (caller) `` is **STALE (relocation)**: `handle_edit` and `effective_keys` are BOTH in `edit.rs` (`edit.rs:27`; `effective_keys` grep → only `edit.rs`). Correct: `` `src/cli/issue/edit.rs::handle_edit` (effective_keys caller) ``. **The debt extends to bc-2 — this citation should be added to the F2 correction scope.**
- **bc-6-config-cache.md** — the 3 `create.rs` refs (`:128 story_points_field_id`, `:277 team_field_id`, `:283 story_points_field_id`) point at the create-body field-injection which genuinely stayed in `create.rs` (394 LOC → all in range); the 5 `helpers.rs` refs (`:43 resolve_team_field`, `:194 compose_extra_fields`, `:200 compose_extra_fields`, `:209 resolve_story_points_field_id`, plus a generic `helpers.rs`) name symbols that ARE in `helpers.rs` (`resolve_team_field:36`, `compose_extra_fields:194`, `resolve_story_points_field_id:212`). These are **correct-file with minor bare-line drift** (e.g. cited `:43`/`:209` vs actual `:36`/`:212`) — **NOT relocation-stale**. Record-only; convert to symbol-form opportunistically, out of this cycle's core scope.

**Perimeter conclusion:** Citation debt from the ADR-0012 split extends **beyond bc-3-issue-write.md to bc-2-issue-read.md (1 stale relocation)**. bc-6 has only bare-line drift (correct file). Recommend the F2 correction scope = **bc-3-issue-write.md (13 relocation/dead-line items) + bc-2-issue-read.md (1 item)**; treat bc-6 line-drift and all tests/ line citations as a separate deferred hygiene pass.

---

## 7. Summary (requested metrics)

- **Total src/-referencing citations examined (bc-3):** ~50 (plus the whole-file read for context).
- **STALE — needs RELOCATE (wrong file, ADR-0012 fallout):** **13** in bc-3
  - 9 × `create.rs` → `jsm_create.rs` (BC-3.8.002, .003, .009×3, .015, .016, .017, Canonical Guard Ordering)
  - 2 × `create.rs` → `edit.rs` historical `--no-parent`/convert-hint (BC-3.4.010 ×2)
  - 2 × `helpers.rs` → `field_resolve.rs` (BC-3.4.015 Source + Trace)
  - **+1 in bc-2** (`create.rs::handle_edit` → `edit.rs::handle_edit`) = **14 relocations cycle-wide**
- **Bare-line — needs LINE→SYMBOL (#408), correct file:** ~15 src/ citations in bc-3 (lower priority) + ~40 tests/ line citations (recommend defer) + bc-6 bare-line drift (record-only).
- **Already-correct (verified perimeter, do not touch):** ~20+ (parse_field_kv, handle_create, resolve_team_field, is_team_uuid, all edit.rs classifier/label symbols, field_resolve.rs in BC-3.4.021 & BC-3.4.015 body, get_issue_types_for_project, BC-3.8.001 dispatch-branch).
- **Ambiguous / unresolvable (escalation):** **0**.
- **Debt extends beyond bc-3-issue-write.md?** **YES** — bc-2-issue-read.md has 1 relocation-stale citation (`create.rs::handle_edit` → `edit.rs`). bc-6 has correct-file bare-line drift only. Other 4 files clean.

All three F1 hypotheses (A, B, C) are **CONFIRMED** with concrete grep evidence.
