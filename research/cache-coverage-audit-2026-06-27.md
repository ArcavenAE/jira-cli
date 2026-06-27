# Cache-Layer Test-Coverage Audit — `jr` CLI

**Date:** 2026-06-27
**Scope:** `src/cache.rs` cache families × 6 behavior dimensions × 4 test tiers (unit / wiremock-integration / Phase-4 holdout / E2E).
**Method:** Derived from source — `src/cache.rs`, all `cache::read_*`/`write_*` call sites in `src/`, `tests/*.rs`, and `.factory/specs/prd/holdout-scenarios.md`. No assumptions.
**Constraint:** Read-only. No source/test/spec was modified. Tests are proposed, not authored.

---

## 1. Cache Family Enumeration (10 families)

All families live under `~/.cache/jr/v1/<profile>/` (Unix) / `%LOCALAPPDATA%\jr\v1\<profile>\` (Windows). All carry a 7-day TTL (`CACHE_TTL_DAYS = 7`, checked `>= 7` days). All readers/writers take `profile: &str` as the scoping argument. Two distinct read implementations exist: the generic `read_cache<T: Expiring>` (whole-file, self-heals on parse error via `eprintln! + Ok(None)`), and three bespoke keyed readers (`read_project_meta`, `read_object_type_attr_cache`, plus the per-(sid,rtId) request-type readers which still route through `read_cache`).

| # | Family | Read fn | Write fn | File pattern | Serialized type | Write-error model | Profile-scoped | API call site |
|---|--------|---------|----------|--------------|-----------------|-------------------|----------------|---------------|
| 1 | Team list | `read_team_cache` | `write_team_cache` | `teams.json` | `TeamCache` | **a** (propagate `?`) | yes | `cli/team.rs`, `cli/issue/helpers.rs`, `cli/issue/view.rs`, `cli/board.rs`, `cli/sprint.rs`, `cli/issue/list.rs`, `cli/init.rs` |
| 2 | Project meta | `read_project_meta(profile, project_key)` | `write_project_meta(profile, project_key, meta)` | `project_meta.json` (map keyed by project key, **per-entry** TTL) | `HashMap<String, ProjectMeta>` | **a** for `write` (`?`); **b**-style call site (`let _ =`) in `api/jsm/servicedesks.rs:96` | yes | `api/jsm/servicedesks.rs` |
| 3 | Workspace ID | `read_workspace_cache` | `write_workspace_cache` | `workspace.json` | `WorkspaceCache` | **a** (propagate `?`); call site `api/assets/workspace.rs:55` uses `let _ =` | yes | `api/assets/workspace.rs` |
| 4 | Resolutions | `read_resolutions_cache` | `write_resolutions_cache` | `resolutions.json` | `ResolutionsCache` | **a** (propagate `?`) | yes | `cli/issue/workflow.rs` (`load_resolutions`) |
| 5 | CMDB fields | `read_cmdb_fields_cache` | `write_cmdb_fields_cache` | `cmdb_fields.json` | `CmdbFieldsCache` (`Vec<(String,String)>`) | **b** (swallow + `eprintln!` + `Ok`) | yes | `api/assets/linked.rs:36` (`.ok()`) |
| 6 | Jira fields (story-points discovery) | `read_fields_cache` | `write_fields_cache` | `fields.json` | `FieldsCache` (`Vec<(String,String)>`) | **b** (swallow + `eprintln!` + `Ok`) | yes | `cli/issue/edit.rs` via `resolve_edit_fields` (GET `/rest/api/3/field`) |
| 7 | Object-type attrs | `read_object_type_attr_cache(profile, type_id)` | `write_object_type_attr_cache(profile, type_id, attrs)` | `object_type_attrs.json` (map keyed by object-type id, **whole-file** TTL) | `ObjectTypeAttrCache` | **b** (swallow + `eprintln!` + `Ok`) | yes | `api/assets/objects.rs:190` (`.ok()`) |
| 8 | Request types | `read_request_type_cache(profile, sid)` | `write_request_type_cache(profile, sid, types)` | `request_types_<sid>.json` | `RequestTypeCache` | **b** (swallow + `eprintln!` + `Ok`) | yes | `cli/requesttype.rs`, `cli/issue/jsm_create.rs:391` (`let _ =`) |
| 9 | Request-type fields | `read_request_type_fields_cache(profile, sid, rtId)` | `write_request_type_fields_cache(profile, sid, rtId, resp)` | `request_type_fields_<sid>_<rtId>.json` | `RequestTypeFieldsCache` | **b** (swallow + `eprintln!` + `Ok`) | yes | `cli/requesttype.rs` |
| — | (infra) `clear_profile_cache(profile)` | n/a | n/a | removes `v1/<profile>/` | — | propagate `?` | yes | profile clearing |

**Family count: 9 caches** (+1 clear-profile infra fn). Note: families 5 and 6 share an identical `(id,name)` tuple struct layout — the documented `cmdb_fields` tuple-migration risk applies to both `cmdb_fields.json` and `fields.json`.

Write-error model split confirmed from source: **model-a (propagate):** families 1, 2(writer), 3(writer), 4. **model-b (swallow+warn+Ok):** families 5, 6, 7, 8, 9. (Families 2 and 3's writers technically propagate via `?` but their production call sites discard the result with `let _ =`, making them effectively best-effort at the boundary — a hybrid noted below.)

---

## 2. Behavior Dimensions (D1–D6)

- **D1 — Cold MISS → fetch + write:** no cache file → reader returns `Ok(None)` → call site fetches via HTTP → writes cache.
- **D2 — Warm HIT → no HTTP:** valid in-TTL file present → reader returns `Ok(Some)` → second invocation fires **zero** HTTP to the backing endpoint. Requires wiremock `expect(N)` to observe; invisible from output.
- **D3 — TTL expiry (>=7d) → refetch:** stale `fetched_at` → reader returns `Ok(None)` → refetch.
- **D4 — Format-drift self-heal:** garbage/old-shape file → serde fails → `eprintln! warning` + `Ok(None)` (miss) → refetch, no crash.
- **D5 — Write-error handling:** model-a propagates `Err`; model-b swallows → `Ok(())` + stderr warning; command still succeeds.
- **D6 — Profile isolation:** profile A's file is never read for profile B (distinct on-disk paths).

---

## 3. Coverage Matrix

Tier legend: **U** = unit (`src/cache.rs#[cfg(test)]`); **I** = wiremock integration (`tests/*.rs`); **H** = Phase-4 holdout; **E** = E2E. Each covered cell names the real test fn.

| Family | D1 cold-miss | D2 warm-hit/no-HTTP | D3 TTL-expiry | D4 format-drift | D5 write-error | D6 profile-iso |
|--------|------|------|------|------|------|------|
| **1 Team** | U `write_then_read_returns_data`; I `team_list_*` | **GAP** (no `expect(1)` two-call test; warm-hit not pinned) | U `expired_cache_returns_none` + `valid_cache_within_ttl` | U `corrupt_team_cache_returns_none`; H `H-009`/`H-025` (`issue_view_errors.rs`) | U (model-a implicit via `write_then_read`) — no forced-IO-error test | U `cross_profile_isolation_team_cache`, `clear_profile_cache_removes_only_that_profile` |
| **2 Project meta** | I `project_meta_cache_miss_fetches_from_api`; U `write_then_read_project_meta` | **GAP** (no two-call `expect`; `cache_miss` test does not assert a warm second call) | U `expired_project_meta_returns_none` | U `corrupt_project_meta_returns_none` | **GAP** (writer propagates but call-site `let _=`; no test) | U `project_meta_multiple_projects` (multi-key, **not** multi-profile) → **GAP for cross-profile** |
| **3 Workspace ID** | U `write_then_read_workspace_cache`; H `H-037` cold path | H `H-037` `test_s_2_03_h_037_bc_4_2_001_workspace_id_cached_after_first_call` (`expect(1)` across two spawns) | U `expired_workspace_cache_returns_none` | U `corrupt_workspace_cache_returns_none` | **GAP** (no forced-IO-error test; call site `let _=`) | **GAP** (no cross-profile workspace test) |
| **4 Resolutions** | U `resolution_cache_round_trip`; I (`issue_move_resolution_enforce.rs` exercises `load_resolutions`) | **GAP** (no `expect(1)` two-call no-HTTP test) | **GAP** (no expired-resolutions test) | **GAP** (no corrupt-resolutions test) | U (model-a implicit) — no forced-error test | U `resolution_cache_missing_returns_none` (miss only) → **GAP for cross-profile** |
| **5 CMDB fields** | U `write_then_read_cmdb_fields_cache`; I (`issue_list_assets.rs`) | **GAP** (multi-wid tests mount workspace discovery `expect(0)` but do not pin a two-call `cmdb_fields` HTTP-skip) | U `expired_cmdb_fields_cache_returns_none` | I `test_s_2_06_ac_005_*` legacy ID-only format → `Ok(None)` (`worklog_duration_holdouts.rs`); H `H-NEW (BC-6.2.013)` | U `test_write_cmdb_fields_cache_swallow_io_error_returns_ok` | **GAP** (no cross-profile cmdb-fields test) |
| **6 Jira fields** | I `test_bc_3_4_015_cold_cache_fetches_and_populates_fields_cache` | I `test_bc_3_4_015_warm_fields_cache_skips_field_list_http` (GET `/field` not mounted; cache-hit pinned) | **GAP** (no expired-fields test) | **GAP** (no corrupt/old-format fields test; struct identical to cmdb_fields but untested) | U `test_write_fields_cache_swallow_io_error_returns_ok`; I `test_bc_3_4_015_cache_write_failure_warns_and_exits_0` | **GAP** (no cross-profile fields test) |
| **7 Object-type attrs** | U `write_then_read_object_type_attr_cache` | **GAP** (no two-call `expect` no-HTTP test; only H-024 short-circuits BEFORE fetch, unrelated) | U `expired_object_type_attr_cache_returns_none` | U `object_type_attr_cache_corrupt_returns_none` | U `test_write_object_type_attr_cache_swallow_io_error_returns_ok` | **GAP** (only `object_type_attr_cache_multiple_types` = multi-key, **not** multi-profile) |
| **8 Request types** | U (`request_type_cache_tests`); I `test_requesttype_list_returns_types_table` | I `test_requesttype_list_cache_hit_no_second_http` (`expect(1)` across two spawns) | **GAP** (no expired-RT test at any tier) | U `test_corrupt_request_type_cache_returns_none_self_heals` | **GAP** (no forced-IO-error test for `write_request_type_cache`) | U `test_request_type_cache_cross_profile_isolation` |
| **9 RT fields** | U (helper round-trip); I `test_requesttype_fields_resolves_name_and_returns_table` | I `test_requesttype_fields_cache_hit_no_second_http`; H `H-NEW-JSM-RT-005` | **GAP** (no expired-RT-fields test) | U `test_corrupt_request_type_fields_cache_returns_none_self_heals` | **GAP** (no forced-IO-error test for `write_request_type_fields_cache`) | U `test_request_type_fields_cache_cross_profile_isolation` |

### E2E tier (confirmation)
`tests/e2e_live.rs` isolates the cache via a fresh `TempDir` (`cache_dir: TempDir::new()`, wired through `XDG_CACHE_HOME` at line 118) **but contains ZERO cache-behavior assertions** — grep for `cache (hit|miss)`, `no http`, `second call`, `expect(0|1)`, `cached` returns nothing. Confirmed as stated in the prompt: cache is isolated, never asserted. (Correct: E2E hits live Jira and cannot count requests; no-HTTP assertions are structurally impossible there.)

### GAP summary (cells)
- **D2 (warm-hit/no-HTTP) GAPs:** families 1, 2, 4, 5, 7 (5 of 9). Covered: 3, 6, 8, 9.
- **D3 (TTL-expiry) GAPs:** families 4, 6, 8, 9 (4 of 9). Covered (unit): 1, 2, 3, 5, 7.
- **D4 (format-drift) GAPs:** families 4, 6 (2 of 9). Covered: 1, 2, 3, 5, 7, 8, 9.
- **D5 (write-error) GAPs:** families 2, 3, 4, 8, 9 (5 of 9). Covered: 5, 6, 7 (the three documented model-b writers) + implicit for model-a (1).
- **D6 (profile-isolation) GAPs:** families 2, 3, 4, 5, 6, 7 (6 of 9). Covered: 1, 8, 9 (the three families that got explicit `cross_profile_isolation_*` tests).

---

## 4. Prioritized Gaps

### HIGH

- **D6 profile-isolation untested on 6 of 9 families (workspace, resolutions, cmdb_fields, fields, project_meta, object_type_attrs).** CLAUDE.md states cross-profile cache leakage is a **correctness bug** (sandbox vs prod custom-field IDs differ). Families 5 (`cmdb_fields`) and 6 (`fields`) are the highest sub-risk because they store custom-field IDs that genuinely differ between a sandbox and a prod instance — a leak silently writes the wrong `customfield_NNNNN` into a JSM/issue payload. Families 1, 8, 9 have explicit cross-profile unit tests; the other six rely only on the shared `cache_dir(profile)` path-construction (transitively correct, but **unpinned** — a refactor that drops the `profile` segment for any one family would not be caught for these six). `multi_profile_fields.rs` tests config-level field-ID selection, **not** on-disk cache-file isolation, so it does not close this gap.

- **D4 format-drift untested on family 6 (`fields.json`).** `FieldsCache` has the **exact same `Vec<(String,String)>` tuple layout** as `CmdbFieldsCache`, and CLAUDE.md documents the cmdb_fields `(id,name)` tuple migration as a real historical format change. `cmdb_fields` has a self-heal test (`test_s_2_06_ac_005_*`); the structurally-identical `fields.json` has **none**. A legacy ID-only `fields.json` (or any old shape) hitting a non-self-healing path would be a hard error on a write command (`issue edit --field`). Elevated to HIGH because the sibling family proved this format-drift class is real, not hypothetical.

### MEDIUM

- **D5 write-error untested on family 8 & 9 (`write_request_type_cache`, `write_request_type_fields_cache`).** These are explicitly documented model-b best-effort writers whose entire reason for existing is "a write failure must never break `jr requesttype ... --output json | jq`." The three asset/fields model-b writers (5,6,7) have forced-ENOTDIR swallow tests; the two request-type writers — the ones the CLAUDE.md gotcha specifically calls out as the *first* swallow+warn writers — have **no** forced-IO-error test. Regression risk: a refactor to `?` would re-introduce the exit-code-leak-into-pipeline bug the model was designed to prevent.

- **D2 warm-hit/no-HTTP untested on family 3's sibling expensive-discovery families (resolutions #4, cmdb_fields #5).** Workspace (#3) and request-types (#8,#9) have `expect(1)`-across-two-calls pins; the equally-cacheable discovery families do not. `cmdb_fields` discovery (GET `/rest/api/3/field`, all-fields fetch) is expensive and fires on every asset-enriched `issue list`; a regression that stops reading the cache would silently double that fetch. Resolutions (#4) fires per done-category `issue move`.

- **D5 write-error untested on families 2 & 3 (project_meta, workspace) call-site hybrid.** Writers propagate `?` (model-a) but production call sites use `let _ =` / `.ok()` — effectively model-b at the boundary, but undocumented as such and untested either way. Worth a single integration assertion that a write failure does not break `issue create --request-type` (project_meta) or `assets search` (workspace).

### LOW

- **D3 TTL-expiry untested on families 4, 6, 8, 9.** Lower risk because TTL is enforced centrally in the shared `read_cache<T>` (`>= CACHE_TTL_DAYS`) for families 4 (resolutions), 6 (fields), 8 (RT), 9 (RT-fields) — they all route through the same generic reader that families 1/3/5 already pin via `expired_*_returns_none`. The branch is exercised; only the per-family instantiation is unpinned. Cheap to add, but the shared code path makes a silent regression unlikely.

- **D2 warm-hit on team (#1) and project_meta (#2).** Team list warm-hit is partly observable via existing `team list` flows; project_meta warm-hit matters less (cheap project lookup). Worth pinning for completeness, not correctness-critical.

---

## 5. Proposed Test Additions

For each, the appropriate tier, exact assertion, family, and a suggested name. "No-HTTP" assertions **require wiremock** (request-counted) and cannot live in E2E.

### HIGH-priority proposals

**P1 — Cross-profile isolation, unit tier, families 3/4/5/6/7 (one test each).**
- Tier: **U** (`src/cache.rs`, mirror existing `cross_profile_isolation_team_cache` + `request_type_cache_tests`).
- Assertion: under `with_temp_cache`, `write_*("prod", …prodVal)` then `write_*("sandbox", …sandboxVal)`; assert `read_*("prod") == prodVal`, `read_*("sandbox") == sandboxVal`, and the two `cache_dir("prod")/<file>` vs `cache_dir("sandbox")/<file>` paths differ and both exist.
- Names: `test_workspace_cache_cross_profile_isolation`, `test_resolutions_cache_cross_profile_isolation`, `test_cmdb_fields_cache_cross_profile_isolation`, `test_fields_cache_cross_profile_isolation`, `test_object_type_attr_cache_cross_profile_isolation`. (project_meta #2 already has multi-key but should add `test_project_meta_cross_profile_isolation`.)
- BC anchor: BC-6.3.001 (multi-profile fields) is the closest existing BC and explicitly covers the prod/sandbox custom-field divergence — these unit tests extend its "POLICY multi-profile-cache (CRITICAL)" coverage cited in `src/cache.rs` line ~1589. Anchor to BC-6.3.001; no new BC required.

**P2 — Format-drift self-heal for `fields.json`, unit tier, family 6.**
- Tier: **U** (mirror `read_missing_cmdb_fields_cache_returns_none` + the legacy-format library test in `worklog_duration_holdouts.rs`).
- Assertion: write a legacy ID-only `["customfield_10001"]` array AND a garbage `"not json"` string to `fields.json`; assert `read_fields_cache("default")` returns `Ok(None)` (not `Err`, no panic) in both cases.
- Name: `test_fields_cache_legacy_id_only_format_self_heals` + `corrupt_fields_cache_returns_none`.
- BC anchor: BC-6.2.013 (the existing cmdb format-drift BC) — `fields.json` shares the tuple layout; extend BC-6.2.013's scope note to enumerate `fields.json` alongside `cmdb_fields.json`. BC exists.

### MEDIUM-priority proposals

**P3 — Request-type writer swallow-on-IO-error, unit tier, families 8 & 9.**
- Tier: **U** (mirror `test_write_cmdb_fields_cache_swallow_io_error_returns_ok` exactly — point `JR_CACHE_DIR`/`XDG_CACHE_HOME` at a file, forcing ENOTDIR in `create_dir_all`).
- Assertion: `write_request_type_cache("p","10",&types)` and `write_request_type_fields_cache("p","10","200",&resp)` each return `Ok(())` and do not panic when the cache dir is unwritable.
- Names: `test_write_request_type_cache_swallow_io_error_returns_ok`, `test_write_request_type_fields_cache_swallow_io_error_returns_ok`.
- BC anchor: BC-X.12.005 / BC-X.12.008 (request-type caching BCs already cited by H-NEW-JSM-RT-005). The swallow behavior is documented in the writers' rustdoc; pin it. BC exists.

**P4 — Warm-hit no-HTTP for cmdb_fields discovery, integration tier, family 5.**
- Tier: **I** (wiremock; `tests/cmdb_fields.rs` or `tests/issue_list_assets.rs`). **Must be wiremock — not E2E.**
- Assertion: mount `GET /rest/api/3/field` (CMDB-field discovery) with `.expect(1)`; run an asset-enriched `jr issue list` (or `assets search`) twice with the same `XDG_CACHE_HOME`/`JR_CACHE_DIR` TempDir; assert the field endpoint fires exactly once across both invocations and the second exits 0.
- Name: `test_cmdb_fields_cache_hit_no_second_http`.
- BC anchor: BC-4.2.001 (workspace cache-hit BC, the sibling H-037 anchor). A cmdb_fields-specific clause may need adding; flag as **MED — BC may need a sub-clause** under the assets-caching BC family (BC-4.x). Confirm whether BC-4.3.001/BC-4.2.001 covers cmdb-field discovery caching; if not, this is a candidate new holdout (H-NEW-CMDB-CACHE-001) anchored to a new/extended BC.

**P5 — Warm-hit no-HTTP for resolutions, integration tier, family 4.**
- Tier: **I** (wiremock; `tests/issue_resolution.rs` or `issue_move_resolution_enforce.rs`).
- Assertion: mount the resolutions endpoint (`GET /rest/api/3/resolution`) with `.expect(1)`; invoke `jr issue resolutions` (or a done-category `jr issue move` that loads resolutions) twice with a shared cache dir; assert the resolution endpoint fires once.
- Name: `test_resolutions_cache_hit_no_second_http`.
- BC anchor: BC-3.2.011/BC-3.2.013 (resolution enforcement) reference `load_resolutions` but do not pin its caching. Flag as **MED — anchor to a resolutions-caching clause** (extend BC-3.2.x or add a small caching BC). BC may need extension.

**P6 — Write-failure does not break command, integration tier, families 2 & 3 (hybrid call sites).**
- Tier: **I** (wiremock; point cache dir at an unwritable path / read-only dir).
- Assertion: with an unwritable cache dir, run `jr assets search` (workspace #3) and `jr issue create --request-type` (project_meta #2); assert exit 0 (command succeeds) and a `warning:` line appears on stderr — proving the `let _=`/`.ok()` boundary absorbs the write error.
- Names: `test_workspace_cache_write_failure_does_not_break_search`, `test_project_meta_write_failure_does_not_break_jsm_create`.
- BC anchor: BC-6.2.014 (cache-write atomicity / non-atomic write contract, the H-025 anchor) — extend to cover the model-b call-site boundary for these two families. BC exists (BC-6.2.014).

### LOW-priority proposals

**P7 — Per-family TTL-expiry pins for resolutions/fields/RT/RT-fields, unit tier, families 4/6/8/9.**
- Tier: **U** (mirror `expired_cmdb_fields_cache_returns_none`: write a file with `fetched_at = now - 8d`, assert `read_* == Ok(None)`).
- Names: `expired_resolutions_cache_returns_none`, `expired_fields_cache_returns_none`, `test_expired_request_type_cache_returns_none`, `test_expired_request_type_fields_cache_returns_none`.
- BC anchor: BC-6.2.x cache-TTL family; no new BC. Low value (shared `read_cache<T>` path already pinned by families 1/3/5).

**P8 — Warm-hit for team and project_meta, integration tier, families 1 & 2.**
- Tier: **I** (wiremock `expect(1)` across two `jr team list` / two `jr issue create --request-type` invocations sharing a cache dir).
- Names: `test_team_cache_hit_no_second_http`, `test_project_meta_cache_hit_no_second_http`.
- BC anchor: existing team-cache / project-meta BCs; no new BC. Completeness, not correctness-critical.

---

## 6. Notes on BC anchoring

- Existing BCs that cleanly cover proposed work: **BC-6.3.001** (multi-profile fields → P1), **BC-6.2.013** (cmdb format-drift → P2), **BC-X.12.005/008** (RT caching → P3), **BC-6.2.014** (non-atomic write contract → P6).
- BCs that likely need a small caching sub-clause (flag before authoring holdouts): the **assets-discovery caching** path for cmdb_fields (P4) and the **resolutions caching** path (P5). Neither has a dedicated "second call fires no HTTP" BC today; H-037 covers workspace only, H-NEW-JSM-RT-005 covers RT-fields only.
- Any "no-HTTP / fires-once" proposal (P4, P5, P8) **must** be a wiremock integration test or a Phase-4 holdout backed by wiremock — never E2E, which cannot count requests against live Jira.

---

## 7. Summary

- **9 cache families** enumerated from `src/cache.rs` (team, project_meta, workspace, resolutions, cmdb_fields, fields, object_type_attrs, request_types, request_type_fields), plus the `clear_profile_cache` infra fn. Write-error split: **model-a** = {team, project_meta-writer, workspace-writer, resolutions}; **model-b** = {cmdb_fields, fields, object_type_attrs, request_types, request_type_fields}; project_meta + workspace are hybrids (model-a writer, `let _=`/`.ok()` call site).
- **Matrix GAP tally:** D2 = 5 gaps, D3 = 4 gaps, D4 = 2 gaps, D5 = 5 gaps, D6 = 6 gaps (of 9 families each).
- **E2E confirmed clean:** `e2e_live.rs` isolates cache via TempDir but has zero cache-behavior assertions (correct — request counting is impossible against live Jira).
- **HIGH gaps:** (1) D6 profile-isolation on 6 families — especially cmdb_fields & fields (custom-field-ID leak = stated correctness bug); (2) D4 format-drift on `fields.json` (identical tuple layout to the proven-real cmdb_fields migration, zero self-heal test).
- **MED gaps:** request-type writers' swallow behavior (D5), warm-hit no-HTTP on cmdb_fields & resolutions (D2), write-failure resilience at project_meta/workspace call sites (D5).
- **LOW gaps:** per-family TTL-expiry pins (shared `read_cache<T>` path already covered), team/project_meta warm-hit.
- **8 concrete proposals** (P1–P8), each tier-correct, with exact assertions, suggested names, and BC anchors (existing where possible; P4/P5 flagged as needing a caching sub-clause before becoming holdouts).

**Report written to:** `/Users/zious/Documents/GITHUB/jira-cli/.factory/research/cache-coverage-audit-2026-06-27.md`
