---
story_id: S-CMDB-OBJTYPE-WARM-HIT-COVERAGE-1
title: "Warm-hit / zero-HTTP wiremock coverage for cmdb_fields (Family 5) and object_type_attrs (Family 7)"
intent: enhancement
feature_type: infrastructure
scope: trivial
regression_risk: LOW
bc_anchor: BC-6.2.018
date: 2026-06-27
author: architect
---

# F1 Delta Analysis — S-CMDB-OBJTYPE-WARM-HIT-COVERAGE-1

## 1. Context

PR #565 (DEC-142) shipped warm-hit / zero-HTTP wiremock coverage for three cache families (teams, resolutions, project_meta) into `tests/cache_warm_hit.rs`. The PR header explicitly deferred two families, each with a distinct stated reason:

- **cmdb_fields (#5)** — "requires assets-enriched `issue list` with CMDB schema detection; needs workspace + CMDB field + AQL search mocks all active. Pre-populate approach: feasible but fragile without knowing which issue responses trigger cmdb-field reading."
- **object_type_attrs (#7)** — "requires full `assets search` subprocess flow (workspace ID + AQL search + object-type-attrs); in-process vs subprocess env var conflict makes it fragile."

This cycle resolves DEC-142 by determining whether clean `expect(1)` wiremock tests are actually achievable for each family, and writing the analysis.

---

## 2. Impact Boundary

**Files touched:** `tests/cache_warm_hit.rs` only (add two new `#[tokio::test]` functions to the existing file).

**No `src/` change is needed.** The warm-hit behavior is fully implemented:
- `src/cache.rs::read_cmdb_fields_cache` delegates to the generic `read_cache<T: Expiring>` (lines 16–34). On warm hit it reads the file, deserializes, passes TTL check, and returns `Ok(Some(CmdbFieldsCache))` — no network call.
- `src/cache.rs::read_object_type_attr_cache` is a bespoke keyed reader (lines 389–413). On warm hit it reads `object_type_attrs.json`, deserializes `ObjectTypeAttrCache`, passes the per-file TTL check, and returns `Ok(Some(Vec<CachedObjectTypeAttr>))` for the requested `object_type_id` — no network call.

Both implementations exist and are correct. This cycle adds regression pins that would catch any future breakage.

**No architecture change.** No new BCs needed. No new modules.

---

## 3. Endpoint Sequence Per Command

### Family 5 — cmdb_fields via `jr issue list --project PROJ --assets`

The `cmdb_fields` cache is populated by `get_or_fetch_cmdb_fields` in `src/api/assets/linked.rs:27–38`. That function calls `client.find_cmdb_fields()` on a cache miss, which delegates to `client.list_fields()` in `src/api/jira/fields.rs` — a single `GET /rest/api/3/field` call.

**Cold run HTTP sequence** (ordered):

| Step | Method | Endpoint | Purpose | Cache-backed? |
|------|--------|----------|---------|---------------|
| 1 | GET | `/rest/api/3/project/PROJ` | project existence check (`project_exists`) | no |
| 2 | GET | `/rest/api/3/field` | CMDB field discovery (all Jira fields; filtered to CMDB schema type) | **YES — this is the pin target** |
| 3 | POST | `/jsm/assets/workspace/<wid>/v1/object/aql` | AQL search for issues with CMDB asset key (if `--asset-key` used) | no |
| 4 | GET | `/rest/api/3/search/jql` (or `/rest/api/3/issue/search`) | JQL issue search | no |
| 5 | GET | `/jsm/assets/workspace/<wid>/v1/object/<oid>` | Per-asset enrichment (if objectId-only) | no |

**Important:** `jr issue list` with the `--assets` flag but without `--asset-key` also calls `get_or_fetch_cmdb_fields` at line 366 of `src/cli/issue/list.rs`. Both call sites funnel through the same `get_or_fetch_cmdb_fields` cache gate.

**Warm run (second invocation):**
- Step 2 (`GET /rest/api/3/field`) is completely skipped — `read_cmdb_fields_cache` returns `Ok(Some(...))`, `get_or_fetch_cmdb_fields` returns immediately without calling `find_cmdb_fields`.
- Steps 1, 3, 4, 5 fire as normal on every invocation (not cached by `cmdb_fields`).

**Pin target for `expect(1)`:** `GET /rest/api/3/field`

**Mock design note:** Steps 3–5 vary by test design. For the simplest warm-hit test, use a pre-populated `cmdb_fields.json` cache (write it directly to the TempDir before invocation 1) and skip asset-enrichment entirely (no `--assets` flag, mock `GET /rest/api/3/field` with `expect(1)`, confirm invocation 2 does not fire it again). Alternatively, run two full `jr issue list --output json --project PROJ` invocations and mount the supporting mocks without `expect()`.

### Family 7 — object_type_attrs via `jr assets search --attributes`

The `object_type_attrs` cache is populated by `enrich_search_attributes` in `src/api/assets/objects.rs:153–207`. That function iterates unique `objectType.id` values from the search results and calls `get_object_type_attributes` on a cache miss — `GET /jsm/assets/workspace/<wid>/v1/objecttype/<type_id>/attributes`.

**Cold run HTTP sequence** (ordered):

| Step | Method | Endpoint | Purpose | Cache-backed? |
|------|--------|----------|---------|---------------|
| 1 | GET | `/rest/servicedeskapi/assets/workspace` | workspace ID discovery | via workspace cache (Family 3) |
| 2 | POST | `/jsm/assets/workspace/<wid>/v1/object/aql` | AQL search (returns objects with `objectType.id`) | no |
| 3 | GET | `/jsm/assets/workspace/<wid>/v1/objecttype/<type_id>/attributes` | object-type attribute definitions | **YES — this is the pin target** |

**Warm run (second invocation):**
- Step 1 (`workspace` discovery) — skipped if the workspace cache is also populated. For test simplicity, pre-populate the workspace cache in the TempDir, or pre-seed it on invocation 1 and the workspace endpoint also fires `expect(1)`.
- Step 2 (AQL search) fires on every invocation — not cached.
- Step 3 (`objecttype/.../attributes`) is completely skipped on warm hit — `read_object_type_attr_cache` returns `Ok(Some(...))` for the type ID returned by step 2.

**Pin target for `expect(1)`:** `GET /jsm/assets/workspace/<wid>/v1/objecttype/<type_id>/attributes`

**The "in-process vs subprocess env var conflict" concern, resolved:**

The PR #565 header flagged this as "fragile." The concern was: `JR_CACHE_DIR` and `XDG_CACHE_HOME` are env vars set in the test harness, and the subprocess (`Command::cargo_bin("jr")`) may not inherit them correctly or there may be a conflict with in-process env mutation. This concern is **not a real blocker**. The existing warm-hit tests in `tests/cache_warm_hit.rs` (teams, resolutions, project_meta) ALL use `jr_cmd_isolated()` which passes `JR_CACHE_DIR` and `XDG_CACHE_HOME` explicitly to the subprocess via `.env(...)`. These are subprocess env vars, not in-process; `std::env::set_var` is not involved. The workspace warm-hit holdout H-037 also uses the same subprocess technique successfully. The conflict referenced in PR #565 would only arise if an in-process test mutated env vars concurrently with a subprocess test — neither case applies here because `cache_warm_hit.rs` is a pure subprocess test file. **Verdict: the concern is a false alarm; the same `jr_cmd_isolated` pattern is directly applicable.**

---

## 4. Wiremock Feasibility Verdict

### Family 5 — cmdb_fields: FEASIBLE

**Technique:** `expect(1)` call-count pin on `GET /rest/api/3/field`.

**Concrete mock setup sketch:**

```
MockServer::start()
// CRITICAL: expect(1) — field-discovery endpoint fires EXACTLY ONCE across BOTH invocations
Mock::given(method("GET"))
    .and(path("/rest/api/3/field"))
    .respond_with(ResponseTemplate::new(200).set_body_json(fields_with_cmdb()))
    .expect(1)
    .mount(&server)

// Supporting mocks without expect() (fire on both invocations):
Mock::given(method("GET"))
    .and(path("/rest/api/3/project/PROJ"))
    .respond_with(...)
    .mount(&server)
Mock::given(method("GET"))
    .and(path_regex("/rest/api/3/search"))
    ...
    .mount(&server)

// Invocation 1: cold miss — fetches /rest/api/3/field, writes cmdb_fields.json
jr_cmd_isolated(&server.uri(), cache_dir.path(), config_dir.path())
    .args(["issue", "list", "--project", "PROJ", "--no-input", "--output", "json"])
    .output()

// Invocation 2: warm hit — must NOT call /rest/api/3/field again
jr_cmd_isolated(&server.uri(), cache_dir.path(), config_dir.path())
    .args(["issue", "list", "--project", "PROJ", "--no-input", "--output", "json"])
    .output()

// MockServer drop enforces expect(1)
```

**What makes this clean:**
- The `cmdb_fields.json` cache uses the generic `read_cache<T>` path (whole-file, not keyed), so there is no per-entry TTL complexity.
- `GET /rest/api/3/field` is a well-defined, single-shot endpoint. Mounting it with `expect(1)` and letting wiremock enforce the count on drop is the exact same technique used by `test_team_list_warm_cache_skips_http` and `test_resolutions_warm_cache_skips_http`.
- The `issue list` command does need some supporting mocks (project, JQL search), but these are standard — `tests/issue_list_assets.rs` already demonstrates the full mock set for an asset-enriched issue list.

**Simpler alternative (absence-of-mount technique):** Pre-populate `cmdb_fields.json` in the TempDir before any invocation, then run ONE invocation of `issue list` with the field endpoint NOT mounted. If the warm path fires, wiremock returns 404 and the command fails — absence of failure proves the cache was hit. This mirrors the technique used in `tests/issue_edit_field.rs::test_bc_3_4_015_warm_fields_cache_skips_field_list_http` for Family 6. **Either technique is valid; `expect(1)` across two binary invocations is the pattern in `cache_warm_hit.rs` and is preferred for consistency.**

### Family 7 — object_type_attrs: FEASIBLE

**Technique:** `expect(1)` call-count pin on `GET /jsm/assets/workspace/<wid>/v1/objecttype/<type_id>/attributes`.

**Concrete mock setup sketch:**

```
MockServer::start()

// Workspace discovery — either pre-populate workspace cache in TempDir,
// or mount with expect(1) (both invocations need the workspace ID if not cached).
// Simplest: pre-populate workspace.json so workspace endpoint is never needed.

// AQL search — fires on BOTH invocations (no cache). Mount without expect().
Mock::given(method("POST"))
    .and(path_regex("/jsm/assets/workspace/.*/v1/object/aql"))
    .respond_with(ResponseTemplate::new(200).set_body_json(aql_results_with_type_id("42")))
    .mount(&server)

// CRITICAL: expect(1) — objecttype attributes endpoint fires EXACTLY ONCE
Mock::given(method("GET"))
    .and(path_regex("/jsm/assets/workspace/.*/v1/objecttype/42/attributes"))
    .respond_with(ResponseTemplate::new(200).set_body_json(type_attrs_response()))
    .expect(1)
    .mount(&server)

// Invocation 1: cold miss on object_type_attrs
jr_cmd_isolated(&server.uri(), cache_dir.path(), config_dir.path())
    .args(["assets", "search", "objectType = Server", "--attributes", "--no-input"])
    .output()

// Invocation 2: warm hit — must NOT call objecttype/attributes again
jr_cmd_isolated(&server.uri(), cache_dir.path(), config_dir.path())
    .args(["assets", "search", "objectType = Server", "--attributes", "--no-input"])
    .output()

// MockServer drop enforces expect(1)
```

**What makes this clean:**
- `object_type_attrs` is keyed by `(profile, object_type_id)` within a single `object_type_attrs.json` file. The file-level TTL is set on `write_object_type_attr_cache` at write time (`cache.fetched_at = Utc::now()`). The warm-hit path in `read_object_type_attr_cache` checks the file-level TTL (not per-key), then returns `types.get(object_type_id).cloned()`. For a single object type ID in the test, this is straightforward.
- The `enrich_search_attributes` loop in `objects.rs` iterates unique type IDs from search results. If the test uses a search result with a single object type (type_id = "42"), there is exactly one potential call to `objecttype/.../attributes` per cold invocation. With `expect(1)` across two invocations, the assertion cleanly pins the warm-hit bypass.
- The AQL search endpoint (`POST .../object/aql`) fires on every invocation — it is not cached. Mount it without `expect()`. The workspace ID can be pre-seeded in the TempDir (write a `workspace.json` directly) to remove the workspace discovery mock from the setup entirely.
- The "subprocess env var conflict" concern is resolved (see Section 3 above). `jr_cmd_isolated` passes env vars via `.env()` on the `Command`, not via in-process `set_var`.

**One caveat to note:** `object_type_attrs.json` is a shared-file, keyed cache (unlike `teams.json` or `cmdb_fields.json` which are whole-file caches). The warm-hit TTL check is per-file (`cache.fetched_at`), not per-key. This is consistent and correct — the test just needs to ensure both invocations happen within 7 days of each other (trivially guaranteed in CI). No special handling needed.

---

## 5. Regression Risk

**Risk level: LOW.**

This cycle is test-only. No production code changes. The regression suite (all existing `cargo test`) continues to serve as the full safety net.

**CI flake risk from multi-endpoint mocks:**

For Family 5, the AQL search / JQL search mocks are standard; `tests/issue_list_assets.rs` already exercises these without flake. For Family 7, the AQL search mock responds to any matching POST — no ordering constraints. Multi-endpoint wiremock tests in this codebase have a clean track record (see `test_project_meta_warm_cache_skips_http` which uses three mocks concurrently).

**Only known CI risk:** If `jr issue list` without `--assets` does not call `GET /rest/api/3/field` on the cold path, the warm-hit test would fail vacuously (no cold-miss write → no warm hit to test). Mitigation: confirm invocation 1 produces output that references the CMDB field (assert the response includes a field entry that came from the mock), before relying on invocation 2's warm hit. This is the same non-tautology check used in `test_resolutions_warm_cache_skips_http` (checks the response array is non-empty).

---

## 6. BC Anchor Adequacy

**BC-6.2.018 already covers both families.** The BC explicitly names Family 4 (CMDB fields) and Family 5 (object-type attrs) in its "Coverage honesty note":

> **INVARIANT-HOLDS-BY-SHARED-MECHANISM (not yet individually pinned)**: Families 1 (teams), 2 (project-meta), 4 (CMDB fields), 5 (object-type-attrs), 7 (resolutions) — the warm-hit no-HTTP property holds by the shared `read_cache<T>` / bespoke inline path mechanism described in Behavior, but no dedicated per-family test currently exists for these families.

(Note: the BC's numbering uses "Family 4" for cmdb_fields and "Family 5" for object_type_attrs, consistent with the coverage matrix in `cache-coverage-audit-2026-06-27.md` where they are labeled #5 and #7 respectively — there is a numbering discrepancy in BC-6.2.018's Behavior section vs the audit's enumeration table. The audit table is the authoritative enumeration; the BC text refers to them correctly by name.)

**No sub-clause addition is needed.** BC-6.2.018's EC-1/EC-2/EC-3 cover the warm-hit boundary conditions. The "Coverage honesty note" already explicitly identifies these two families as "not yet individually pinned" — the new tests close exactly the gap described there.

**Verification technique alignment:** BC-6.2.018 D2 paragraph endorses both the `expect(1)` call-count pin technique and the absence-of-mount technique, and states "`expect(1)` is preferred when the test spans two binary invocations." Both proposed tests use two binary invocations via `jr_cmd_isolated`, so `expect(1)` is the correct technique per the BC itself.

---

## 7. Summary

| Family | Name | Command | Cache-backed endpoint | Pin target | Technique | Verdict |
|--------|------|---------|----------------------|------------|-----------|---------|
| 5 (audit #5) | cmdb_fields | `jr issue list --project PROJ` | `GET /rest/api/3/field` | `expect(1)` across 2 subprocess invocations | call-count pin | **FEASIBLE** |
| 7 (audit #7) | object_type_attrs | `jr assets search ... --attributes` | `GET /jsm/assets/workspace/<wid>/v1/objecttype/<type_id>/attributes` | `expect(1)` across 2 subprocess invocations | call-count pin | **FEASIBLE** |

**The "fragility" concern from PR #565 is resolved:** The subprocess env-var isolation conflict is not a real blocker — `jr_cmd_isolated` passes env vars via subprocess `.env()`, not in-process `set_var`. The multi-endpoint mock complexity is manageable and mirrors patterns already in the codebase.

**Recommended deliverable:** Add two new `#[tokio::test]` functions to `tests/cache_warm_hit.rs`:
1. `test_cmdb_fields_warm_cache_skips_http` — pins Family 5, `expect(1)` on `GET /rest/api/3/field`.
2. `test_object_type_attrs_warm_cache_skips_http` — pins Family 7, `expect(1)` on `GET /jsm/assets/workspace/.../v1/objecttype/.../attributes`.

No new BC. No `src/` changes. No new test file (add to existing `tests/cache_warm_hit.rs`).
