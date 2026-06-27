# E2E Edge-Case Coverage Audit — Part 2: WRITE / State-Changing Surface

**Date:** 2026-06-27
**Scope:** Write-path / state-changing commands of `jr` (`issue create`, `issue edit`, `issue move`, bulk ops, `worklog add`, `issue link/unlink/remote-link`, JSM `issue create --request-type`, `issue comment`, `issue assign`).
**Type:** STATIC coverage audit. No live E2E run performed; no live mutations proposed for execution. Proposals are classified by tier (live-E2E / wiremock-integration / holdout).
**Ground truth read:** `tests/e2e_live.rs` (write-flow fns), `docs/specs/jsm-e2e-coverage.md`, `docs/specs/e2e-live-jira-testing.md`, `src/cli/issue/{create,edit,workflow,jsm_create,links}.rs`, `src/api/jira/bulk.rs`, CLAUDE.md Gotchas, `.factory/STATE.md` drift items, `tests/adf_recursion_depth.rs`.

> Companion to Part 1 (read-path audit). This part covers only mutating commands and their edges.

---

## A. Command × flag enumeration (write surface)

| Command | Flags / dimensions in scope |
|---|---|
| `issue create` (platform) | `--project --type --summary --description --description-stdin --markdown --label --points/--no-points --parent --field K=V --priority --team --assignee --output`; empty/whitespace inputs; leading-dash free text (`allow_hyphen_values`) |
| `issue create --markdown` (ADF wave) | heading, bold/em, bare-URL autolink, task list (`- [ ]`), ordered task list (`1. [ ]`), subsup (`^x^`/`~x~`), GFM alert panel (`> [!NOTE]`), block HTML (`<div>`), footnotes (`[^1]`), nested list/blockquote normalization, recursion-guard (≥256 → exit 64) |
| `issue create --request-type` (JSM fork) | servicedeskapi dispatch, numeric-bypass, `--type` ignored warning, `--field`, scope 401 hint, non-JSM guard, `--on-behalf-of` |
| `issue edit` (single) | `--summary --description(-stdin) --priority --points/--no-points --type --label add:/remove: --field K=V --parent/--no-parent --dry-run --output`; #398 echo asymmetry |
| `issue edit` (bulk / multi-key) | `--type` (camelCase/lowercase, cross-project exit-64 guard), `--label` (POST objects), `--priority` (priorityId), C-1 guard (`--field` on bulk → exit 64), `--field`+`--label` → exit 64, `--jql` set + `--dry-run` |
| `issue move` (single) | idempotency (changed:false), proactive resolution enforcement (BC-3.2.013: exit 64 + hint), `--resolution`, `--no-resolution`, ambiguous resolution exit 64, reactive 400 backstop |
| `issue move` (bulk) | nested wire schema (FIX-BULK-TRANSITION-001), per-key non-idempotent 400s, `inaccessible`/`error`/`success` result shape, async poll timeout/grace |
| `worklog add` | duration parsing (`5m`,`1h`,`1h30m`,`1d`,`1w`), invalid duration, `--message`, `--output` |
| `issue link / unlink` | default "Relates", `--type` typed, direction-agnostic |
| `issue remote-link` | `--url --title`, scheme allowlist (http/https only), invalid URL, no read-back |
| `issue comment` | positional message, `--file`, `--stdin`, `--markdown`, `--internal` (JSM) |
| `issue assign` | self-assign, `--unassign`, by-query |

---

## B. Coverage matrix — COVERED vs GAP

Legend: ✅ COVERED (cite live test fn) · ⚠️ PARTIAL · ❌ GAP. Tier of proposed fix in §D.

### B.1 issue create (platform + ADF wave)

| Edge case | Status | Evidence / Gap note |
|---|---|---|
| create happy path + key/url shape | ✅ | `test_e2e_write_flow_create_edit_comment_worklog_close` |
| create `--description` non-null | ✅ | `test_e2e_issue_description_create_edit_stdin_roundtrip` |
| create `--description-stdin` | ✅ | `test_e2e_issue_description_create_edit_stdin_roundtrip` (edit path); also `test_e2e_adf_read_path_human_output` (create path) |
| create `--markdown` heading node | ✅ | `test_e2e_markdown_description_produces_heading_node` |
| markdown bare-URL → link mark (stored) | ✅ | `test_e2e_markdown_bare_url_produces_link_mark` |
| markdown task list → taskItem/taskList | ✅ | `test_e2e_markdown_task_list_produces_task_items` |
| markdown ordered task list → taskList (not orderedList) | ✅ | `test_e2e_markdown_ordered_task_list_produces_task_items` |
| markdown subsup marks | ✅ | `test_e2e_markdown_subsup_produces_subsup_marks` |
| markdown GFM alert → panel (info, warning) | ✅ | `test_e2e_markdown_gfm_alert_produces_panel` |
| markdown block HTML preserved | ✅ | `test_e2e_markdown_block_html_preserved` |
| markdown nested blockquote-in-listItem normalization | ✅ | `test_e2e_adf_read_path_human_output` (AC-2) |
| markdown **footnotes** (`[^1]`) → marker + appended section | ❌ | No E2E and no dedicated holdout. ADF wave covers tasklist/panel/subsup/block-HTML/bare-url but NOT footnotes (#472). |
| markdown **footnote empty-container pruning** (`> [^1]: x` → no empty blockquote) | ❌ | Not exercised; this is the Jira-400-avoidance invariant. |
| markdown **panel content-model normalization** (nested panel/table/blockquote unwrap) — accept-by-Jira | ⚠️ | Only Note/Warning *presence* asserted; nested-panel/table-in-panel normalization (BC-7.2.009) never submitted live. |
| markdown other 3 alert kinds (Tip→success, Important→note, Caution→error) | ❌ | Only info + warning asserted live; success/note/error panelTypes unverified against Jira. |
| markdown **recursion-guard ≥256 → exit 64** | ⚠️ | `tests/adf_recursion_depth.rs::test_issue_create_deep_markdown_description_exits_64` (wiremock). NOT in e2e_live.rs (correct — must be wiremock; live would need no server). Covered at correct tier. |
| markdown CR/LF in inline HTML → space (no raw `\n` in text node, INV-1) | ❌ | BC-7.2.011 INV-1: multi-line inline HTML must not emit raw `\n`. Not asserted anywhere observable. Body-capture needed. |
| create `--points` round-trip | ✅ | `test_e2e_issue_points_roundtrip` |
| create `--parent` round-trip | ✅ | `test_e2e_issue_parent_roundtrip` (instance-gated) |
| create `--field K=V` on create (platform) | ❌ | Only `edit --field` is covered (`test_e2e_issue_edit_custom_field`). `create --field` path untested. |
| create leading-dash free text (`allow_hyphen_values`) | ❌ | No test passes a `--summary "- dash start"` or `--description "- [ ] x"` via flag form to prove clap does not treat it as an unknown flag. The ADF read-path test uses `--description-stdin` *specifically to avoid* the leading-dash flag path — so the flag path is unverified. |
| create empty `--summary` (`--summary ""`) | ❌ | No test. Behavior (400 vs client guard) unverified. |
| create whitespace-only summary/description | ❌ | No test. |
| create `--type` invalid name → exit code | ❌ | No negative create-type test. |
| create `--priority` on create | ❌ | Only `edit --priority` covered. |
| create JSON output shape on write (`{key,url,fields}`) | ✅ | `test_e2e_write_flow_...` asserts `key` + `url`. |

### B.2 issue edit (single + bulk)

| Edge case | Status | Evidence / Gap note |
|---|---|---|
| edit `--summary` round-trip + `updated:true` | ✅ | `test_e2e_write_flow_...` (step 2a) |
| edit `--description` #398 JSON raw-echo (BC-3.4.013) | ✅ | `test_e2e_write_flow_...` (2b-i) + `test_e2e_issue_description_create_edit_stdin_roundtrip` |
| edit `--description` table `(updated)` marker (BC-3.4.012) | ✅ | `test_e2e_write_flow_...` (2b-ii) |
| edit `--description-stdin` raw-echo | ✅ | `test_e2e_issue_description_create_edit_stdin_roundtrip` |
| edit `--points` / `--no-points` echo | ✅ | `test_e2e_issue_points_roundtrip` |
| edit `--field K=V` single-key (editmeta validation) | ✅ | `test_e2e_issue_edit_custom_field` (instance-gated) |
| edit `--field` **C-1 guard: bulk → exit 64** | ❌ | No live or holdout exercises `jr issue edit K1 K2 --field X=Y` → exit 64. Pure CLI guard, observable offline. |
| edit `--field` + `--label` same call → **exit 64** (mutual-exclusion) | ❌ | No test. [FIX-F5-001] Pure CLI guard. |
| edit `--field` JSM Request-Type rejection (`sd-customerrequesttype`, JSDCLOUD-4609) | ❌ | No test (requires JSM issue; PUT 500). Out-of-scope sub-clause, but exit-path is jr-side. |
| edit `--type` single-key | ⚠️ | Single-key type change not directly asserted; only bulk `--type` covered. |
| edit `--type` multi-key bulk (camelCase/lowercase asymmetry) | ✅ | `test_e2e_issue_edit_issuetype_multikey_bulk_roundtrip` (instance-gated on `JR_E2E_ISSUE_TYPE_ALT`) |
| edit `--type` bulk **cross-project exit-64 guard** (BC-3.4.019) | ❌ | No test fires `edit K1 K2 --type T` with keys in two different projects → exit 64. Observable offline (guard) or live. |
| edit `--type` bulk **unknown type name → exit 64** (createmeta lookup) | ❌ | No negative test. |
| edit `--label add:/remove:` single-key (bare-string PUT) | ✅ | `test_e2e_issue_edit_label_add_remove_roundtrip` |
| edit `--label` multi-key bulk (`{"name":…}` objects, #446) | ✅ | `test_e2e_issue_edit_label_multikey_bulk_roundtrip` |
| edit `--label` single vs bulk **payload-shape asymmetry assertion** | ❌ | Observable outcome covered, but the *wire-shape divergence* (bare-string PUT vs `{name}` POST) is never asserted on the request body — a unify-regression would pass live if both still produce the labels. Needs wiremock body capture. |
| edit `--priority` single-key | ✅ | `test_e2e_issue_edit_priority_roundtrip` |
| edit `--priority` multi-key bulk (`priorityId`, #331) | ✅ | `test_e2e_issue_edit_priority_multikey_bulk_roundtrip` |
| edit `--dry-run` no mutation (`--summary`) | ✅ | `test_e2e_issue_edit_dry_run_no_mutation` |
| edit `--dry-run` with **`--jql`-resolved set** | ❌ | Dry-run is covered only for a single positional key with `--summary`. The `--jql` selection path + dry-run JSON shape is untested. |
| edit `--parent` / `--no-parent` | ❌ | Create `--parent` covered; edit re-parent / clear-parent untested. |
| edit no-fields-specified → exit 64 ("No fields specified") | ❌ | No test. Pure CLI guard. |

### B.3 issue move (single + bulk + resolution)

| Edge case | Status | Evidence / Gap note |
|---|---|---|
| move to In Progress + status-category assert | ✅ | `test_e2e_write_flow_...` (step 5) |
| move single-key idempotency (changed:false) | ✅ | `test_e2e_write_flow_...` (step 5 re-issue) |
| move to Done (done category) | ⚠️ | `test_e2e_write_flow_...` (step 6) — but ES "Done" transition has NO mandatory resolution, so this does NOT exercise BC-3.2.013 enforcement. |
| move done-category **proactive resolution enforcement → exit 64 + `--resolution` hint** (non-interactive) | ✅ | `test_e2e_jsm_resolution_enforcement` (enforcement path; JSM EJ project; gated on `JR_E2E_JSM_PROJECT`) |
| move `--resolution R` atomic set | ✅ | `test_e2e_jsm_resolution_enforcement` (positive path) |
| move `--no-resolution` explicit opt-out (done-category, sends without resolution) | ❌ | No test exercises `--no-resolution` skipping enforcement. |
| move `--resolution` **ambiguous name → exit 64 + candidate list** | ❌ | No test (resolve_resolution_by_name disambiguation). |
| move `--resolution` + `--no-resolution` mutually exclusive (clap → exit 2) | ❌ | No test. Pure CLI guard. |
| move bulk multi-key nested wire schema (`bulkTransitionInputs`) | ✅ | `test_e2e_issue_move_multikey_bulk` (FIX-BULK-TRANSITION-001 — observable via `results[]`) |
| move bulk per-key **non-idempotent same-status 400** (per-key error in results) | ❌ | The bulk test moves *fresh* issues; it never re-fires a same-status bulk move to observe a per-key 400/`error` status. Bulk non-idempotency (CLAUDE.md) is asserted only by tolerating `error`, not by forcing it. |
| move bulk async poll **timeout/grace** (`JR_BULK_AWAIT_TIMEOUT_SECS`, `JR_BULK_UNKNOWN_GRACE_SECS`) | ❌ | Unobservable in live E2E (cannot force a hung task). Must be wiremock. No wiremock test cited. |
| move reactive BC-3.2.009 400 "resolution required" backstop | ⚠️ | Preserved in code; not independently asserted (proactive gate fires first on EJ). Forced 400 needs wiremock. |

### B.4 worklog add

| Edge case | Status | Evidence / Gap note |
|---|---|---|
| worklog add `5m` (300s) round-trip | ✅ | `test_e2e_write_flow_...` (step 4) |
| worklog add `1h` (3600s) round-trip | ✅ | `test_e2e_worklog_add_roundtrip` |
| worklog add `1h30m` (5400s) compound duration | ❌ | Only single-unit durations exercised. |
| worklog add `1d` / `1w` (Jira workday/workweek semantics) | ❌ | Untested — `1d`=8h, `1w`=5d are Jira-config-dependent semantics worth a holdout/unit pin. |
| worklog add **invalid duration → exit 64** | ❌ | No negative test (e.g. `jr worklog add KEY "banana"`). Parser is offline-testable. |
| worklog add `--message` | ❌ | Message body (ADF) on worklog untested. |

### B.5 links

| Edge case | Status | Evidence / Gap note |
|---|---|---|
| link default "Relates" + read-back | ✅ | `test_e2e_issue_link_and_unlink` |
| link `--type` typed + unlink `--type` | ✅ | `test_e2e_issue_link_with_type_and_unlink_with_type` |
| link-types list | ✅ | `test_e2e_issue_link_types_returns_array` |
| remote-link create smoke (http/https) | ✅ | `test_e2e_issue_remote_link_smoke` |
| remote-link **scheme allowlist: reject non-http(s) → exit 64** (`ftp://`, `javascript:`) | ❌ | `links.rs:250` rejects non-http/https with a UserError, but no test asserts it. Pure offline CLI guard. |
| remote-link **invalid URL → exit 64** | ❌ | `links.rs:247` rejects unparseable URL; untested. |
| remote-link read-back | ❌ | Tracked: **E2E-PG-4 (OPEN, LOW)** — jr exposes no remote-link read. Do not double-count. |
| unlink non-existent link → idempotency/error | ❌ | No negative unlink test. |

### B.6 JSM (issue create --request-type fork)

| Edge case | Status | Evidence / Gap note |
|---|---|---|
| create `--request-type` servicedeskapi round-trip | ✅ | `test_e2e_jsm_create_request_roundtrip` (gated) |
| numeric-bypass RT id | ✅ | covered implicitly (all-digit id) |
| `--type` ignored warning when `--request-type` set | ❌ | `jsm_create.rs:197` emits stderr warning; no test asserts the warning string. |
| scope-mismatch **401 → `write:servicedesk-request` hint** | ❌ | Deferred in jsm-e2e-coverage.md §7 (needs scope-stripped token). Must be wiremock. No wiremock test cited. |
| non-JSM project guard (`require_service_desk`) | ✅ | `test_e2e_jsm_non_jsm_guard` (queue list on ES) — but this is the *queue* path, NOT `create --request-type` on a non-JSM project. |
| `create --request-type` against a **non-JSM project** guard | ❌ | The guard is exercised via `queue list`, not via the create fork. The create dispatch fork's own failure mode on a platform project is untested. |
| RT name resolution (non-numeric `--request-type "Name"`) | ❌ | Only numeric-bypass path tested; the partial_match name-resolution branch in the create fork is untested live. |
| internal/external comment visibility (`sd.public.comment`) | ✅ | `test_e2e_jsm_comment_visibility` (gated) |
| RT cache no-HTTP warm-hit | ❌ | Unobservable live; wiremock/holdout. Related to CACHE-COVERAGE-GAPS (do not double-count cache families). |

### B.7 Cross-cutting (idempotency / exit codes / JSON shape / --no-input)

| Edge case | Status | Evidence / Gap note |
|---|---|---|
| 404 write/read → exit 1 or 64, empty stdout | ✅ | `test_e2e_issue_view_404_exits_nonzero` (read; pattern applies) |
| bad JQL → exit 1/64 | ✅ | `test_e2e_issue_list_bad_jql_exits_nonzero` |
| bad auth on write → non-zero, no key | ✅ | `test_e2e_bad_auth_exits_2` |
| exit 2 (NotAuthenticated) explicit | ⚠️ | `test_e2e_bad_auth_exits_2` accepts 1 OR 2 (instance-dependent). Pure exit-2 path needs wiremock 401. |
| exit 78 (config error) on write | ❌ | No write-path exit-78 test (e.g. missing required config). |
| `--no-input` non-interactive equivalents | ⚠️ | Used implicitly (stdin not TTY in CI); no test asserts a prompt-requiring path errors cleanly with `--no-input`. |
| JSON result shape on writes (`{key}` / `{updated}` / `{changed}` / `{results}`) | ✅ | create/edit/move JSON shapes asserted across write-flow tests. |

---

## C. Prioritized gap list

Weighting per instructions: ADF wave, bulk schema, and resolution enforcement weighted highly (recent + complex).

### HIGH

1. **G-ADF-FOOTNOTE** — markdown footnotes (#472) have zero coverage: no live ADF-structure assertion, no holdout, AND the **empty-container pruning** invariant (prevents Jira 400 on `> [^1]: x`) is unverified. Footnotes are part of the same `markdown_to_adf` wave as the covered constructs; a regression that re-emits an empty blockquote would ship a hard Jira-400. (Recent/complex weighting.)
2. **G-ADF-INV1-INLINE-HTML** — BC-7.2.011 INV-1: multi-line inline HTML (`foo <span\nx>bar`) must map interior `\n`→space, never emit a raw `\n` in a text node. CLAUDE.md flags this as a previously-reachable HIGH bug (#522 CR-01 → Jira 400). No test (live or wiremock) captures the submitted body to prove no raw `\n`. Body-capture needed.
3. **G-EDIT-FIELD-LABEL-GUARD** — `edit --field` + `--label` in one call must exit 64 (silent label→bulk fork would drop the `--field` write). [FIX-F5-001]. Pure CLI guard, cheap, regression-prone, currently unverified.
4. **G-EDIT-FIELD-C1-BULK** — `edit K1 K2 --field X=Y` must exit 64 (C-1 guard). Bulk `--field` is explicitly unsupported; a routing regression could silently no-op or mis-route. Cheap offline guard.
5. **G-MOVE-BULK-NONIDEMPOTENT** — bulk move per-key same-status 400 (CLAUDE.md: bulk transitions are NOT idempotent) is only *tolerated*, never *forced*. A wiremock test should assert the per-key `error` result shape on a same-status bulk move; the nested `bulkTransitionInputs` schema (FIX-BULK-TRANSITION-001) error path is high-value.

### MEDIUM

6. **G-MOVE-NO-RESOLUTION** — `move <done> --no-resolution` opt-out path (skips BC-3.2.013 enforcement, sends without resolution) is untested. Live-observable on EJ.
7. **G-MOVE-RESOLUTION-AMBIGUOUS** — ambiguous `--resolution` substring → exit 64 + candidate list. Untested.
8. **G-MOVE-RESOLUTION-CLAP-CONFLICT** — `--resolution` + `--no-resolution` → exit 2 (clap conflict). Cheap offline guard.
9. **G-EDIT-TYPE-CROSSPROJECT** — bulk `--type` cross-project → exit 64 (BC-3.4.019). Endpoint takes a single issueTypeId; guard is load-bearing. Offline or live.
10. **G-EDIT-TYPE-UNKNOWN** — bulk/single `--type "Bogus"` → exit 64 with valid-types list (createmeta lookup). Untested.
11. **G-ADF-PANEL-KINDS** — only Note(info)+Warning(warning) panels asserted live; Tip(success)/Important(note)/Caution(error) panelTypes unverified against Jira acceptance. Same `panel_type_for` dispatch; a Jira-rejection on an untested panelType would surface only here.
12. **G-ADF-PANEL-NORMALIZE** — panel content-model normalization (nested panel/table/blockquote unwrap, BC-7.2.009) — the Jira-400-avoidance path is never submitted live nor body-captured.
13. **G-WORKLOG-COMPOUND** — compound `1h30m` and `1d`/`1w` durations untested; Jira workday/workweek semantics are config-dependent.
14. **G-WORKLOG-INVALID** — invalid duration → exit 64. Offline parser pin.
15. **G-CREATE-FIELD** — `create --field K=V` (platform create custom field) untested; only `edit --field` covered.
16. **G-CREATE-LEADING-DASH** — leading-dash free text via flag form (`--summary "- x"`, `--description "- [ ] todo"`) — the `allow_hyphen_values` behavior is never exercised through the flag path (read-path test deliberately uses stdin to avoid it).
17. **G-MOVE-BULK-GRACE-TIMEOUT** — bulk async poll timeout/grace (`JR_BULK_AWAIT_TIMEOUT_SECS` / `JR_BULK_UNKNOWN_GRACE_SECS`). Unobservable live; wiremock only. No wiremock test cited.
18. **G-JSM-SCOPE-401** — `create --request-type` 401 → `write:servicedesk-request` hint (BC-3.8.015). Deferred (needs scope-stripped token); a wiremock 401-body test could cover it without a real stripped token.

### LOW

19. **G-JSM-TYPE-IGNORED** — `--type` ignored warning string when `--request-type` set. Offline/live stderr assertion.
20. **G-JSM-CREATE-NONJSM** — `create --request-type` against a non-JSM project (guard fires on the create fork, not just queue list).
21. **G-JSM-RT-NAME-RESOLVE** — non-numeric `--request-type "Name"` resolution branch.
22. **G-EDIT-DRYRUN-JQL** — `edit --jql <set> --dry-run` (selection + dry-run JSON shape).
23. **G-EDIT-PARENT** — `edit --parent` / `--no-parent` re-parent/clear.
24. **G-EDIT-NOFIELDS** — `edit <key>` with no field flags → exit 64.
25. **G-CREATE-EMPTY-WS** — empty/whitespace `--summary`/`--description`.
26. **G-CREATE-TYPE-INVALID / G-CREATE-PRIORITY** — invalid `--type`; `create --priority`.
27. **G-REMOTE-LINK-SCHEME / G-REMOTE-LINK-BADURL** — non-http(s) scheme → exit 64; unparseable URL → exit 64 (offline guards).
28. **G-LABEL-SHAPE-ASYMMETRY** — assert the bare-string-PUT vs `{name}`-POST wire divergence (unify-regression guard). Wiremock body capture.
29. **G-EXIT-78-WRITE / G-NO-INPUT** — write-path config-error exit 78; `--no-input` prompt-suppression on a prompt-requiring write.

---

## D. Concrete test proposals (with tier)

Tier key: **LIVE** = `tests/e2e_live.rs` (`#[ignore]`, `JR_RUN_E2E`); **WIREMOCK** = integration test under `tests/` using `JR_BASE_URL` + wiremock (error injection / body capture / forced 4xx / poll); **HOLDOUT** = `.factory/.../holdout-scenarios.md` behavioral scenario (needs a BC anchor); **OFFLINE-CLI** = always-run integration test asserting clap/guard exit codes with no network (subset of WIREMOCK tier, no server).

### HIGH

- **G-ADF-FOOTNOTE → WIREMOCK (body capture) + HOLDOUT.**
  - WIREMOCK: `create --markdown --description "ref[^1]\n\n[^1]: def"`, capture POST body, assert (a) a plain unmarked `[1]` text marker exists, (b) an appended `rule` + `[1] def` paragraph exists, (c) **no empty `blockquote`/`listItem` container** remains (pruning ran). Live cannot assert node structure of an *unobserved-by-user* construct reliably and footnotes have no user-visible Jira render guarantee → wiremock is the right tier.
  - HOLDOUT: footnote forward-mapping scenario. **BC anchor gap:** ADF markdown→ADF currently LACKS a dedicated footnote BC sub-clause (the wave BCs are BC-7.2.009/010/011/012; footnotes #472 have no enumerated BC). A holdout needs a new BC sub-clause first — flag as prerequisite (parallels the cache-no-HTTP BC-prereq noted in CACHE-COVERAGE-GAPS).
- **G-ADF-INV1-INLINE-HTML → WIREMOCK (body capture).** `create --markdown --description $'foo <span\nx>bar'`; capture body; assert NO `text` node contains `\n` and the interior break became a space. **UNOBSERVABLE in live E2E** (Jira may normalize on storage; the invariant is about the *submitted* body, not the stored one). BC anchor exists: BC-7.2.011 INV-1.
- **G-EDIT-FIELD-LABEL-GUARD → OFFLINE-CLI.** `jr issue edit KEY --field X=Y --label add:z` → assert exit 64, stderr contains the mutual-exclusion message. No server needed (guard fires before any HTTP). BC anchor: [FIX-F5-001] / edit.rs:220.
- **G-EDIT-FIELD-C1-BULK → OFFLINE-CLI.** `jr issue edit K1 K2 --field X=Y` → exit 64 (C-1 guard, edit.rs:291). No network.
- **G-MOVE-BULK-NONIDEMPOTENT → WIREMOCK.** Mock `POST /bulk/issues/transition` returning a task whose result reports one key `success` and one key `error` (same-status reject); assert `jr` surfaces both in `results[]` with correct per-key status and exits non-zero appropriately. Also assert the **nested `bulkTransitionInputs`** request shape (FIX-BULK-TRANSITION-001) via body capture. **UNOBSERVABLE deterministically live** (can't force a per-key reject reliably).

### MEDIUM

- **G-MOVE-NO-RESOLUTION → LIVE.** On EJ: `move <done> --no-resolution` → exit 0, resolution stays null/unset. Add to `test_e2e_jsm_resolution_enforcement` as a third path (it already self-closes EJ tickets).
- **G-MOVE-RESOLUTION-AMBIGUOUS → WIREMOCK or LIVE.** Prefer WIREMOCK: mock `resolutions` returning two names sharing a substring, `move --resolution <ambiguous>` → exit 64 + candidate list. (Live is fragile — depends on the instance's resolution set.)
- **G-MOVE-RESOLUTION-CLAP-CONFLICT → OFFLINE-CLI.** `move KEY done --resolution X --no-resolution` → exit 2.
- **G-EDIT-TYPE-CROSSPROJECT → OFFLINE-CLI (if guard fires pre-HTTP) or WIREMOCK.** Verify edit.rs guard: `edit PROJA-1 PROJB-1 --type T` → exit 64. Confirm whether the guard reads keys before any network call (it should — same-project check is on the key strings) → OFFLINE-CLI.
- **G-EDIT-TYPE-UNKNOWN → WIREMOCK.** Mock createmeta returning a known type set; `edit --type "Bogus"` → exit 64 listing valid types.
- **G-ADF-PANEL-KINDS → LIVE.** Extend `test_e2e_markdown_gfm_alert_produces_panel` to also submit `> [!TIP]`, `> [!IMPORTANT]`, `> [!CAUTION]` and assert panelType success/note/error survive Jira storage. Low marginal cost (one extra create).
- **G-ADF-PANEL-NORMALIZE → WIREMOCK (body capture).** `create --markdown` with a panel containing a nested table/blockquote; assert the submitted `panel.content` has no nested panel/table/blockquote and no node-level marks (BC-7.2.009). UNOBSERVABLE live (the normalization is pre-submission). BC anchor exists: BC-7.2.009.
- **G-WORKLOG-COMPOUND / G-WORKLOG-INVALID → OFFLINE (unit, `src/duration.rs`) + LIVE for `1h30m`.** Compound parsing is already unit-testable in `duration.rs`; verify a `1h30m` (5400s) live round-trip in `test_e2e_worklog_add_roundtrip`. Invalid duration → exit 64 is an offline parser pin.
- **G-CREATE-FIELD → LIVE (instance-gated).** Mirror `test_e2e_issue_edit_custom_field` for the create path: `create --field NAME=VALUE`, gated on `JR_E2E_EDIT_FIELD` (reuse the var, or add `JR_E2E_CREATE_FIELD`).
- **G-CREATE-LEADING-DASH → LIVE + OFFLINE-CLI.** OFFLINE-CLI: `create --summary "- dash"` parses without "unknown flag" error (assert clap accepted it). LIVE: round-trip a `--description "- [ ] task"` via flag form (not stdin) to prove `allow_hyphen_values` + ADF conversion together.
- **G-MOVE-BULK-GRACE-TIMEOUT → WIREMOCK.** Mock a bulk task that never completes; set `JR_BULK_AWAIT_TIMEOUT_SECS=1`; assert clean timeout error (not hang/panic). Also unknown-status grace via `JR_BULK_UNKNOWN_GRACE_SECS`. **UNOBSERVABLE live.** Debug-only seams already exist for exactly this.
- **G-JSM-SCOPE-401 → WIREMOCK.** Mock `POST /servicedeskapi/request` → 401 with a scope-mismatch body; assert stderr carries `write:servicedesk-request`. Avoids needing a real scope-stripped token (jsm-e2e §7 deferral reason).

### LOW

- **G-JSM-TYPE-IGNORED → LIVE or WIREMOCK.** Assert `--type X --request-type N` emits the stderr warning (jsm_create.rs:197). Cheap to fold into `test_e2e_jsm_create_request_roundtrip`.
- **G-JSM-CREATE-NONJSM → WIREMOCK.** `create --request-type N --project <platform>` → guard error path.
- **G-JSM-RT-NAME-RESOLVE → LIVE (gated).** Use `rts[0]["name"]` instead of id to exercise partial_match resolution.
- **G-EDIT-DRYRUN-JQL → WIREMOCK or LIVE.** `edit --jql "<set>" --dry-run --output json` asserts selection + no mutation + JSON shape.
- **G-EDIT-PARENT → LIVE (instance-gated).** Reuse `JR_E2E_PARENT_KEY`; `edit --parent` then `--no-parent`.
- **G-EDIT-NOFIELDS → OFFLINE-CLI.** `edit KEY` (no field flags) → exit 64, "No fields specified" (edit.rs:120/742).
- **G-CREATE-EMPTY-WS → WIREMOCK or LIVE.** `create --summary ""` / whitespace — assert defined behavior (likely 400/exit 64).
- **G-CREATE-TYPE-INVALID → WIREMOCK; G-CREATE-PRIORITY → LIVE.**
- **G-REMOTE-LINK-SCHEME / G-REMOTE-LINK-BADURL → OFFLINE-CLI.** `remote-link KEY --url ftp://x --title t` → exit 64 (links.rs:250); `--url "not a url"` → exit 64 (links.rs:247). No network (validation is client-side before POST).
- **G-LABEL-SHAPE-ASYMMETRY → WIREMOCK (body capture).** Capture single-key PUT (bare-string labels) vs bulk POST (`{name}` objects); pin the divergence so a unify-regression fails. **UNOBSERVABLE live** (both shapes yield the same stored labels).
- **G-EXIT-78-WRITE → WIREMOCK/OFFLINE; G-NO-INPUT → OFFLINE-CLI.**

---

## E. Tier-placement notes — edges that CANNOT live at the live-E2E tier

These must be wiremock or holdout because the observable signal is pre-submission body shape, a forced server error, or a poll-timeout that live Jira will not produce on demand:

- ADF node-structure of *submitted* body (footnote pruning, INV-1 no-`\n`, panel content-model normalization, label PUT-vs-POST shape) → **WIREMOCK body capture** (live Jira normalizes on storage, masking the pre-submission shape).
- Forced 401 scope-mismatch (JSM), forced 400 reactive resolution backstop, bulk per-key 400, bulk poll timeout/grace → **WIREMOCK error injection** (cannot reliably force on a live free-tier site without extra mutation risk).
- ADF recursion-guard exit-64 → already correctly at WIREMOCK (`tests/adf_recursion_depth.rs`), not live.
- Pure CLI guards (field+label exclusion, C-1 bulk, clap conflicts, no-fields, remote-link scheme/URL, cross-project type) → **OFFLINE-CLI** (no server, always-run; strongest regression value per CPU-second).

## F. BC-anchor prerequisites for proposed holdouts

- **Footnotes (#472):** ADF markdown→ADF has BCs for panel (BC-7.2.009), tasklist (BC-7.2.010), block-HTML/INV-1 (BC-7.2.011), recursion (BC-7.2.012) — but **NO dedicated footnote sub-clause**. A footnote holdout requires authoring a new BC first. (Mirrors the cache-no-HTTP BC-prereq pattern in CACHE-COVERAGE-GAPS-2026-06-27.)
- **markdown→ADF "cache-no-HTTP" class:** out of write scope, but noted in CLAUDE.md/STATE as lacking BC sub-clauses — any wiremock no-HTTP warm-hit holdout (e.g. RT cache) needs a BC sub-clause first.
- INV-1 (BC-7.2.011), panel normalization (BC-7.2.009), resolution enforcement (BC-3.2.013/011/009), bulk schema (FIX-BULK-TRANSITION-001 / #446 / #331), scope hint (BC-3.8.015) all have existing anchors — holdouts/tests for those need no new BC.

## G. Do-not-double-count (already-tracked items)

- **E2E-PG-4** (remote-link round-back) — OPEN/LOW. Not re-counted; G-REMOTE-LINK-SCHEME/BADURL are *new* (validation guards, distinct from read-back).
- **HOLDOUT-COVERAGE-GAPS-2026-06-25** already tracks (MED/LOW, tracked-deferred): `issue edit --field/--type/--label/--dry-run`, bulk nested schema, worklog add, link/queue/board. Several MEDIUM/LOW items above (G-EDIT-*, G-WORKLOG-*, G-MOVE-BULK-*) overlap this holdout-deferral — they are surfaced here as **E2E/wiremock-tier** proposals (a different tier than the deferred holdouts), and the offline-CLI guards (G-EDIT-FIELD-LABEL-GUARD, G-EDIT-FIELD-C1-BULK) are *not* covered by that holdout deferral.
- **CACHE-COVERAGE-GAPS-2026-06-27** owns cache warm-hit/no-HTTP — G-JSM-RT-cache is left to that item, not re-proposed.
- ADF wave HIGH gaps were closed at the *holdout* tier by D4 (H-NEW-ADF-001..008) — but D4 covered the markdown→ADF *unit/holdout* behavior, NOT the **live Jira-acceptance** of every panel kind / footnote / INV-1 submitted-body shape. G-ADF-FOOTNOTE, G-ADF-INV1-INLINE-HTML, G-ADF-PANEL-KINDS, G-ADF-PANEL-NORMALIZE are genuinely uncovered at the live/wiremock-body tier.

---

## Summary counts

- Write-surface edges enumerated: ~70 across 7 command groups.
- COVERED (live): 28 · PARTIAL: 7 · GAP: ~35.
- Prioritized gaps: **5 HIGH**, **13 MEDIUM**, **11 LOW**.
- Tier split of proposals: OFFLINE-CLI ~9, WIREMOCK ~12 (incl. 5 body-capture / 4 error-injection that are UNOBSERVABLE live), LIVE ~8, HOLDOUT 1 (footnotes — **blocked on new BC**).
- Highest-leverage cheap wins: the four OFFLINE-CLI guard tests (field+label, C-1 bulk, clap conflict, remote-link scheme) — no network, always-run, high regression value.
