---
document_type: story
story_id: "S-CMDB-OBJTYPE-WARM-HIT-COVERAGE-1"
title: "Retroactive warm-hit / zero-HTTP wiremock coverage for cmdb_fields (Family 4) and object_type_attrs (Family 5)"
wave: feature-followup
status: ready
intent: test-hardening-backfill
feature_type: test-only
mode: feature
scope: trivial
severity: LOW
trivial_scope: true
points: 3
priority: P1
tdd_mode: strict
estimated_effort: xsmall
estimated_days: 0.5
target_module: "tests/cache_warm_hit.rs"
subsystems: []
depends_on: []
blocks: []
bc_anchors:
  - BC-6.2.018
bcs:
  - BC-6.2.018
behavioral_contracts:
  - BC-6.2.018
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-story-decomposition
spec_source: ".factory/phase-f1-delta-analysis/S-CMDB-OBJTYPE-WARM-HIT-COVERAGE-1-delta-analysis.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 3
assumption_validations: []
risk_mitigations: []
created: "2026-06-27"
last_updated: "2026-06-27"
breaking_change: false
retroactive: false
origin: >
  Deferred from PR #565 (S-CACHE-WARM-HIT-COVERAGE-1). F1 delta analysis confirmed
  both families are feasible via `expect(1)` call-count pin using the same
  `jr_cmd_isolated` subprocess pattern already used in `tests/cache_warm_hit.rs`.
  The "fragility" concern from PR #565 was resolved: the subprocess env-var isolation
  conflict is not a real blocker.
changelog:
  - date: "2026-06-27"
    phase: F3-story-decomposition
    author: story-writer
    summary: >
      F3 story decomposition for S-CMDB-OBJTYPE-WARM-HIT-COVERAGE-1. Adds two
      wiremock warm-hit integration tests to tests/cache_warm_hit.rs: Family 4
      (cmdb_fields, BC-6.2.018) and Family 5 (object_type_attrs, BC-6.2.018).
      No src/ changes. F1 delta analysis confirmed both tests are feasible via
      expect(1) call-count pin.
---

# S-CMDB-OBJTYPE-WARM-HIT-COVERAGE-1 — Warm-Hit / Zero-HTTP Coverage for cmdb_fields and object_type_attrs

## Story Narrative

As a developer maintaining the `jr` codebase,
I want regression tests that pin the warm-hit no-HTTP behavioral guarantee for the
`cmdb_fields` (Family 4) and `object_type_attrs` (Family 5) cache families,
so that future refactors of `src/cache.rs` or the assets enrichment path immediately
surface regressions against BC-6.2.018 before they reach CI or affect users.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~1,800 |
| tests/cache_warm_hit.rs (existing ~100 LOC + new ~120 LOC) | ~1,200 |
| src/cache.rs (relevant sections: read_cmdb_fields_cache, read_object_type_attr_cache) | ~600 |
| BC-6.2.018 section in bc-6-config-cache.md | ~600 |
| F1 delta analysis (mock setup sketches) | ~400 |
| **Total** | **~4,600** |

Well within a 20% agent context window budget. No splitting required.

## Tasks

- [ ] Read `tests/cache_warm_hit.rs` in full to understand `jr_cmd_isolated`, `write_minimal_config_with_org`, and the existing warm-hit test pattern (especially `test_resolutions_warm_cache_skips_http` as the closest structural match)
- [ ] Read `src/cache.rs::read_cmdb_fields_cache` and `read_object_type_attr_cache` to confirm the exact cache file names (`cmdb_fields.json`, `object_type_attrs.json`) and key types
- [ ] Read `tests/issue_list_assets.rs` to understand what supporting mocks are needed for `jr issue list --project PROJ` with CMDB field discovery
- [ ] Write `test_cmdb_fields_warm_cache_skips_http`: cold run (`jr issue list --project PROJ --output json`) with supporting mocks + `GET /rest/api/3/field` mounted `.expect(1)`; warm run with same mocks; let MockServer drop to enforce count
- [ ] Write `test_object_type_attrs_warm_cache_skips_http`: pre-populate `workspace.json` in TempDir to skip workspace discovery; cold run (`jr assets search "objectType = Server" --attributes`) with AQL mock + `GET .../objecttype/<id>/attributes` mounted `.expect(1)`; warm run; let MockServer drop
- [ ] Run `cargo test --test cache_warm_hit` to confirm both new tests pass
- [ ] Confirm non-tautology: verify invocation 1 produces meaningful output (non-empty) before relying on invocation 2's warm hit
- [ ] Confirm no `src/` files were modified (test-only constraint)

## Previous Story Intelligence

**Predecessor (S-CACHE-WARM-HIT-COVERAGE-1, PR #565, develop @ 788bc0f):**

S-CACHE-WARM-HIT-COVERAGE-1 established the `tests/cache_warm_hit.rs` file and the
`jr_cmd_isolated` helper that passes `JR_CACHE_DIR`, `JR_BASE_URL`, `JR_AUTH_HEADER`,
`XDG_CACHE_HOME`, `XDG_CONFIG_HOME`, and `JR_CONFIG_DIR` to each subprocess invocation.
The three tests in that file (teams, resolutions, project_meta) are the direct structural
model for the two tests in this story.

**Key lessons from S-CACHE-WARM-HIT-COVERAGE-1:**
- Always confirm invocation 1 produces non-empty output (non-tautology guard). See
  `test_resolutions_warm_cache_skips_http` — it asserts `!output.is_empty()` on invocation 1.
- ENV_MUTEX concern was a false alarm for subprocess tests. `jr_cmd_isolated` uses subprocess
  `.env()` calls, not in-process `std::env::set_var`, so no mutex is needed.
- `write_minimal_config_with_org` must write the config to `<config_dir>/jr/config.toml`
  (not `<config_dir>/config.toml`) because `JR_CONFIG_DIR` is the fully-resolved directory
  path, not the XDG root (BC-6.2.017 seam asymmetry).

**Additional predecessor context (S-D4-TEST-HARDENING-BACKFILL-1, PR #561):**
PR #561 pinned cross-profile cache isolation and `fields.json` format-drift self-heal.
PR #565 built on that to add warm-hit no-HTTP pins. This story closes the remaining
gap from PR #565's intentional deferral of cmdb_fields and object_type_attrs.

**F1 delta analysis resolved the "fragility" concern** from PR #565's header: the
subprocess env-var isolation conflict is not a real blocker; the same `jr_cmd_isolated`
pattern applies directly. The F1 analysis also provides concrete mock-setup sketches
(see `.factory/phase-f1-delta-analysis/S-CMDB-OBJTYPE-WARM-HIT-COVERAGE-1-delta-analysis.md`).

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Test-only scope | F1 delta analysis | No production source file modified; `tests/cache_warm_hit.rs` (two new functions added to existing file) only. No CLI flags, API methods, config paths, or keychain entries changed. |
| `JR_CACHE_DIR` isolation seam | BC-6.2.017, S-WIN-2 | All warm-hit integration tests use `JR_CACHE_DIR` set to a per-test `TempDir` via `jr_cmd_isolated()` to prevent on-disk side effects and cross-test cache leakage. |
| `expect(1)` call-count pin | BC-6.2.018 D2 | Warm-hit tests mount the backing endpoint with `.expect(1)`. Any second HTTP call on the warm path causes wiremock to panic on `MockServer` drop, immediately surfacing the regression in the test log. This is the preferred technique per BC-6.2.018 D2 for tests spanning two binary invocations. |
| Supporting mocks without `expect()` | BC-6.2.018 D2 | Supporting endpoints (auth, JQL search, AQL, workspace) are mounted WITHOUT `expect()`. Only the cache-backed endpoint gets `expect(1)`. This mirrors the pattern in `test_team_list_warm_cache_skips_http` and `test_resolutions_warm_cache_skips_http`. |
| Subprocess env-var isolation (no in-process set_var) | S-CACHE-WARM-HIT-COVERAGE-1 lesson | Use `jr_cmd_isolated` which passes env vars via subprocess `.env()`. Do NOT use `std::env::set_var` in these tests. The ENV_MUTEX pattern from `src/cache.rs` unit tests does NOT apply to subprocess tests. |
| Non-tautology check | F1 delta analysis §5 regression risk | Invocation 1 must produce verifiable output (assert non-empty or check for field/asset data) before relying on invocation 2's expect(1) enforcement. Without this check, a test that never writes the cache would produce a false pass. |

## Library and Framework Requirements

| Library | Version | Constraint |
|---------|---------|-----------|
| wiremock | 0.6 (from Cargo.toml) | `MockServer::start()`, `Mock::given(…).expect(1)`, `ResponseTemplate`, `method`, `path`, `path_regex` matchers. No version change. |
| tempfile | 3 (from Cargo.toml) | `TempDir` for per-test `JR_CACHE_DIR` isolation. No version change. |
| tokio | 1 (full features, from Cargo.toml) | `#[tokio::test]` for async test harness. No version change. |
| assert_cmd | current (from Cargo.toml) | `Command::cargo_bin("jr")` for subprocess invocation. No version change. |
| serde_json | current (from Cargo.toml) | `json!()` macro for mock response bodies. No version change. |

No new crate dependencies to add.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `tests/cache_warm_hit.rs` | MODIFY — add two functions | Add `test_cmdb_fields_warm_cache_skips_http` and `test_object_type_attrs_warm_cache_skips_http` as `#[tokio::test]` async functions. The existing file header comment ("Families NOT pinned here") should be updated to remove the cmdb_fields and object_type_attrs entries, or note that they are now covered. |

No new files to create. No `src/` files to modify.

---

## Behavioral Contracts

| BC | Title | Role in this story |
|----|-------|-------------------|
| BC-6.2.018 | Warm cache hit (within TTL) returns cached value and issues ZERO HTTP calls to backing endpoint; invariant holds for all nine cache families | PRIMARY: 2 warm-hit integration tests using wiremock `expect(1)` call-count pin — cmdb_fields (Family 4, `GET /rest/api/3/field`) and object_type_attrs (Family 5, `GET .../objecttype/<id>/attributes`) |

---

## Acceptance Criteria

Warm-hit technique: wiremock `expect(1)` call-count pin. Each backing endpoint is mounted
with `.expect(1)`. The command is run twice sharing the same `JR_CACHE_DIR` temp dir.
When `MockServer` drops, wiremock automatically asserts the mount was called exactly once —
a second HTTP call on the warm path would panic on drop.

---

### AC-001 — `jr issue list` warm cache hit skips `GET /rest/api/3/field` (cmdb_fields Family 4)
(traces to BC-6.2.018 behavioral invariant: warm hit within TTL issues ZERO HTTP calls to the backing endpoint; `read_cmdb_fields_cache` delegates to generic `read_cache<T>` which returns `Ok(Some(CmdbFieldsCache))` on warm hit without any network call)

When `test_cmdb_fields_warm_cache_skips_http` runs with `GET /rest/api/3/field` mounted
`.expect(1)`:
- First invocation (`jr issue list --project PROJ --output json`): cold miss — `GET /rest/api/3/field` fires once; `cmdb_fields.json` is written to the shared `JR_CACHE_DIR`.
- Second invocation (warm hit within TTL): `read_cmdb_fields_cache` returns `Ok(Some(...))` from the cached file; `GET /rest/api/3/field` is NOT called a second time.
- `MockServer` drop enforces `expect(1)` — wiremock panics if the endpoint was called more than once.

Test function name: `tests/cache_warm_hit.rs::test_cmdb_fields_warm_cache_skips_http`

---

### AC-002 — `jr assets search` warm cache hit skips `GET .../objecttype/<id>/attributes` (object_type_attrs Family 5)
(traces to BC-6.2.018 behavioral invariant: warm hit within TTL issues ZERO HTTP calls to the backing endpoint; `read_object_type_attr_cache` is a bespoke per-file keyed reader that returns `Ok(Some(Vec<CachedObjectTypeAttr>))` for the requested `object_type_id` on warm hit without any network call)

When `test_object_type_attrs_warm_cache_skips_http` runs with `GET /jsm/assets/workspace/<wid>/v1/objecttype/<type_id>/attributes` mounted `.expect(1)`:
- First invocation (`jr assets search "objectType = Server" --attributes`): cold miss — the objecttype attributes endpoint fires once; `object_type_attrs.json` is written to the shared `JR_CACHE_DIR`.
- Second invocation (warm hit within TTL): `read_object_type_attr_cache` returns `Ok(Some(...))` from the cached file; the objecttype attributes endpoint is NOT called a second time.
- `MockServer` drop enforces `expect(1)` — wiremock panics if the endpoint was called more than once.

Test function name: `tests/cache_warm_hit.rs::test_object_type_attrs_warm_cache_skips_http`

---

### AC-003 — Both test functions exist in `tests/cache_warm_hit.rs` and pass `cargo test`
(traces to BC-6.2.018 behavioral invariant: the warm-hit no-HTTP property holds for all nine cache families; this AC closes the dedicated per-family test gap for Families 4 and 5 identified in BC-6.2.018 coverage note version 1.2.0)

`cargo test --test cache_warm_hit` exits 0 with all tests passing (including the three
pre-existing tests from PR #565 and the two new tests from this story). No `src/` files
are modified. The `tests/cache_warm_hit.rs` file header is updated to remove the
cmdb_fields and object_type_attrs entries from the "Families NOT pinned here" comment,
reflecting that all five tested families are now covered.

---

## Out of Scope (explicit)

**No production source changes.** This story is test-only. No CLI flag, API method, config
path, keychain entry, or observable user-facing behavior is changed.

**Per-AC demo recording.** These are pure regression pins with no observable user-facing
surface. Skip Log: `per-AC demo recording N/A — test-only / no user-facing surface`.

**Remaining cache families without dedicated warm-hit tests.** After this story, all nine
families have dedicated warm-hit pins. Family 3 (workspace ID) is covered by holdout H-037;
Family 6 (Jira fields) by absence-of-mount in `tests/issue_edit_field.rs`; Families 8+9
by `tests/requesttype_commands.rs`; Families 1, 2, 7 by `tests/cache_warm_hit.rs` (PR
#565); Families 4 and 5 by this story.

---

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `test_cmdb_fields_warm_cache_skips_http` | `tests/cache_warm_hit.rs` | Effectful (subprocess + wiremock + temp fs) | Spawns `jr issue list` twice via `Command::cargo_bin("jr")`; wiremock `MockServer` with `expect(1)` enforces zero-follow-on-HTTP on `GET /rest/api/3/field`; per-test `TempDir` via `JR_CACHE_DIR` |
| `test_object_type_attrs_warm_cache_skips_http` | `tests/cache_warm_hit.rs` | Effectful (subprocess + wiremock + temp fs) | Spawns `jr assets search` twice; `expect(1)` on objecttype attributes endpoint; pre-populated `workspace.json` removes workspace discovery mock complexity |
| `read_cmdb_fields_cache` | `src/cache.rs` | Effectful (filesystem read) | Delegates to generic `read_cache<T>` (lines 16–34); warm-hit path returns `Ok(Some(CmdbFieldsCache))` without HTTP; no code change — tests pin existing behavior |
| `read_object_type_attr_cache` | `src/cache.rs` | Effectful (filesystem read) | Bespoke per-file keyed reader (lines 389–413); per-file `fetched_at` TTL; `types.get(object_type_id).cloned()` warm-hit return; no code change — tests pin existing behavior |

**Subsystem anchor justification:** No ARCH-INDEX subsystem applies — `tests/cache_warm_hit.rs`
is a single-purpose integration test file with no cross-subsystem interaction.

**Dependency anchor justification:** `depends_on: []` — all prerequisite production code
for Family 4 (cmdb_fields: `src/cache.rs::read_cmdb_fields_cache`, `src/api/assets/linked.rs`)
and Family 5 (object_type_attrs: `src/cache.rs::read_object_type_attr_cache`,
`src/api/assets/objects.rs::enrich_search_attributes`) was already merged before this
story. `blocks: []` — no story depends on these test pins.

---

## Edge Cases

| ID | Source | Description | Expected Behavior | AC |
|----|--------|-------------|-------------------|----|
| EC-001 | BC-6.2.018 EC-1 | Cache expires after 7 days | `read_cache<T>` returns `Ok(None)` on 7th day; cold miss triggers HTTP | Not tested here (expiry covered by TTL unit tests; within-CI-run timing is trivially within TTL) |
| EC-002 | BC-6.2.018 EC-2 | Corrupt `cmdb_fields.json` or `object_type_attrs.json` | Both readers return `Ok(None)` + stderr warning; caller re-fetches (self-heal) | Not tested here (covered by existing corruption unit tests in `src/cache.rs`) |
| EC-003 | BC-6.2.018 D2 / F1 §5 | Invocation 1 fails to write cache (e.g., mock returns empty field list) | Cold miss not confirmed → warm-hit test is vacuously non-tautological | Mitigated by non-tautology check: assert invocation 1 output is non-empty before relying on expect(1) for invocation 2 |
| EC-004 | F1 delta analysis §3 | AQL search fires on BOTH invocations (not cache-backed) | AQL mock mounted without `expect()` — fires as many times as needed; does not affect the expect(1) assertion on the attribute endpoint | AC-002 |
| EC-005 | F1 delta analysis §3 | `object_type_attrs.json` is keyed by `object_type_id`; TTL is per-file, not per-key | For a single object type in the test, one cold miss writes the file; warm hit checks per-file TTL and returns the keyed value — clean | AC-002 |

---

## Test Coverage Summary

| Test name | BC | AC |
|-----------|----|----|
| `test_cmdb_fields_warm_cache_skips_http` | BC-6.2.018 | AC-001, AC-003 |
| `test_object_type_attrs_warm_cache_skips_http` | BC-6.2.018 | AC-002, AC-003 |

**Total new tests: 2.** Both are `#[tokio::test]` async functions in `tests/cache_warm_hit.rs`.

### Mock Setup Overview

**`test_cmdb_fields_warm_cache_skips_http`:**

| Mock endpoint | Method | `expect()` | Purpose |
|---|---|---|---|
| `/rest/api/3/myself` | GET | none | Auth check |
| `/rest/api/3/project/PROJ` | GET | none | Project existence (fires both invocations) |
| `/rest/api/3/search/jql` | GET | none | JQL issue search (fires both invocations) |
| `/rest/api/3/field` | GET | **1** | CMDB field discovery — PIN TARGET |

**`test_object_type_attrs_warm_cache_skips_http`:**

| Mock endpoint | Method | `expect()` | Purpose |
|---|---|---|---|
| `workspace.json` pre-seeded in TempDir | — | — | Workspace ID — bypasses HTTP entirely |
| `/jsm/assets/workspace/<wid>/v1/object/aql` | POST | none | AQL search (fires both invocations) |
| `/jsm/assets/workspace/<wid>/v1/objecttype/<id>/attributes` | GET | **1** | Object-type attrs — PIN TARGET |

---

## Dependency Analysis

**No dependency cycle introduced.** This story has `depends_on: []` and `blocks: []`.
It is a leaf node in the dependency graph.

Wave placement: feature-followup (fills the deferred gap from S-CACHE-WARM-HIT-COVERAGE-1).
No wave gate impact.

---

## Story Points and Effort

**3 story points** (two new integration tests, pre-existing behavior, non-trivial mock chains).

Breakdown:
- F3 story authoring + F1 delta analysis (already done): 0.5 SP
- Test authoring (`test_cmdb_fields_warm_cache_skips_http` + supporting mocks): 1 SP
- Test authoring (`test_object_type_attrs_warm_cache_skips_http` + workspace pre-seed + AQL mock): 1 SP
- F5 adversarial gate + PR delivery: 0.5 SP

From-scratch estimate for a completely novel test infrastructure would be ~5 SP. Reduction
reflects that `jr_cmd_isolated`, `write_minimal_config_with_org`, and the `expect(1)`
pattern are already established in `tests/cache_warm_hit.rs`, and the F1 delta analysis
provides concrete mock-setup sketches.

**Note to state-manager:** Story count in `STORY-INDEX.md` goes from 95 to 96 with this addition. Please update the index to include this story entry.
