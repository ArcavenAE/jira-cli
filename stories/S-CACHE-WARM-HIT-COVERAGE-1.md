---
document_type: story
story_id: "S-CACHE-WARM-HIT-COVERAGE-1"
title: "Retroactive F3 traceability — cache warm-hit no-HTTP coverage + request-type writer swallow pins (#565)"
wave: feature-followup
status: done
intent: test-hardening-backfill
feature_type: test-only
mode: feature
scope: small
severity: LOW
trivial_scope: false
issue: ~565
points: 2
priority: P2
tdd_mode: strict
estimated_effort: xsmall
estimated_days: 0
target_module: cache
subsystems: []
depends_on: []
blocks: []
bc_anchors:
  - BC-6.2.018
  - BC-X.12.008
bcs:
  - BC-6.2.018
  - BC-X.12.008
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-story-decomposition
spec_source: ".factory/research/cache-coverage-audit-2026-06-27.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 5
assumption_validations: []
risk_mitigations: []
created: "2026-06-27"
last_updated: "2026-06-27"
breaking_change: false
retroactive: true
retroactive_reason: >
  PR #565 was delivered via a lighter flow (direct F3+merge without a pre-delivery story
  file). This story provides the missing F3 traceability and closes the process deviation.
  No production source change is involved; all 5 ACs are characterization pins — each was
  verified PASS at the time of merge. Origin: cache-coverage audit drift items
  CACHE-COVERAGE-GAPS-2026-06-27, proposals P3 (warm-hit no-HTTP) and D2 (swallow pins).
predecessor_cycles: >
  PR #565 (test(cache): warm-hit no-HTTP coverage (teams/resolutions/project_meta) +
  request-type writer swallow pins, develop @ 788bc0f).
origin: >
  Cache-coverage audit (CACHE-COVERAGE-GAPS-2026-06-27). Proposals P3 (warm-hit no-HTTP
  pinning for teams/resolutions/project_meta via wiremock expect(1)) and D2 (request-type
  writer swallow+warn behavioral pins). All behaviors confirmed already-implemented;
  PR #565 is regression-hardening, not a bug fix.
f5_review_outcome: >
  Pre-PR code review + adversary gate run clean before merge: CLEAN (0 CRIT, 0 HIGH,
  1 MED + 3 LOW — all resolved before merge; post-resolution CLEAN). 1 MED finding
  (ENV_MUTEX + catch_unwind interaction) resolved by correct unlock ordering before
  catch_unwind. This story records the clean post-resolution gate signal as the
  authoritative F5 outcome for this delivery.
delivering_prs:
  - "PR #565 — develop @ 788bc0f"
skip_log:
  - reason: "Per-AC demo recording N/A — test-only story; no user-facing surface added or changed."
changelog:
  - date: "2026-06-27"
    phase: F3-story-decomposition
    author: story-writer
    summary: >
      Retroactive F3 traceability backfill for PR #565. 5 characterization pins
      documented across BC-6.2.018 (3 warm-hit wiremock tests) and BC-X.12.008
      (2 request-type writer swallow unit tests). Adversary gate: CLEAN post-resolution.
files_modified:
  - tests/cache_warm_hit.rs   # new file — 3 warm-hit integration tests (BC-6.2.018 D2)
  - src/cache.rs              # test module only — 2 unit tests (BC-X.12.008 D5 swallow)
---

# S-CACHE-WARM-HIT-COVERAGE-1 — Retroactive F3 Traceability: Cache Warm-Hit + Writer Swallow Pins

## Status

**DONE — already delivered.**

This story is a RETROACTIVE TRACEABILITY BACKFILL. PR #565 was merged to `develop`
before a story file was written (process deviation from the standard F3-first flow). This
document provides the missing F3 artifact and closes the deviation. No production code is
or was changed by the delivering PR; all acceptance criteria are characterization pins.

**Pre-PR code review + adversary gate** was run before merge and returned **CLEAN** (after
resolving 1 MED finding on ENV_MUTEX + catch_unwind unlock ordering and 3 LOW nits). The
CLEAN post-resolution signal is recorded in `f5_review_outcome` frontmatter above.

**Intentional residual (tracked):** `cmdb_fields` (Family 4) and `object_type_attrs`
(Family 5) warm-hit coverage is intentionally skipped in PR #565. These require fragile
multi-endpoint assets mock chains that are not feasible in the current test setup without
dedicated assets-search integration infrastructure. Both are documented in the
`tests/cache_warm_hit.rs` file header as a tracked residual. The shared `read_cache<T>`
warm path is already pinned by the existing Jira-fields test
`test_bc_3_4_015_warm_fields_cache_skips_field_list_http` in `tests/issue_edit_field.rs`.

## Source of Truth

| Artifact | Location |
|----------|----------|
| Cache coverage audit | `.factory/research/cache-coverage-audit-2026-06-27.md` |
| BC-6.2.018 body | `.factory/specs/prd/bc-6-config-cache.md §6.2.018` |
| BC-X.12.008 body | `.factory/specs/prd/cross-cutting.md §BC-X.12.008` |
| PR #565 commit | `develop @ 788bc0f` |

## Behavioral Contracts

| BC | Title | Role in this story |
|----|-------|-------------------|
| BC-6.2.018 | Warm cache hit (within TTL) returns cached value and issues ZERO HTTP calls to backing endpoint; invariant holds for all nine cache families | PRIMARY: 3 warm-hit integration tests using wiremock `expect(1)` call-count pin — teams (Family 1), resolutions (Family 7), and project_meta (Family 2 bespoke inline reader) |
| BC-X.12.008 | Request types cached per `(profile, serviceDeskId)` with 7-day TTL; cache miss self-heals; model-b writer swallows disk-write error + warns + returns `Ok(())` | PRIMARY: 2 unit tests pinning model-b swallow behavior of `write_request_type_cache` and `write_request_type_fields_cache` (disk-write error ENOTDIR → Ok, no panic, no propagation) |

## Story Narrative

As a developer maintaining the `jr` codebase,
I want regression tests that pin the warm-hit no-HTTP behavioral guarantee across the
teams, resolutions, and project_meta cache families, and the model-b swallow+warn
behavior of the request-type writer functions,
so that future refactors immediately surface regressions against these cache behavioral
contracts before they reach CI and before they affect users.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~1,800 |
| tests/cache_warm_hit.rs (~486 LOC) | ~2,200 |
| src/cache.rs test module additions (~80 LOC) | ~400 |
| BC files (BC-6.2.018 section + BC-X.12.008 section) | ~700 |
| **Total** | **~5,100** |

Well within a 20% agent context window budget. No splitting required.

## Previous Story Intelligence

**Predecessor context (S-D4-TEST-HARDENING-BACKFILL-1, PR #561):**
PR #561 pinned the cache cross-profile isolation and `fields.json` format-drift self-heal
paths in `src/cache.rs`. PR #565 builds on that audit to pin the warm-hit no-HTTP path
(BC-6.2.018) — a property that output alone cannot verify, requiring either wiremock
`expect(1)` call-count pinning or absence-of-mount. The BC-6.2.018 contract was authored
at the same time as PR #565 (2026-06-27).

**BC-X.12.008 swallow context (issue-288-pr2-cli):**
`write_request_type_cache` and `write_request_type_fields_cache` were introduced in
S-288-pr2-cli as model-b writers. The model-b pattern (swallow disk-write error + warn +
return `Ok(())`) was already established by `write_cmdb_fields_cache` (CR-007, S-525),
but the request-type writers had no dedicated pin. PR #565 closes that gap.

**N/A — no successor stories blocked by this backfill.**

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Test-only scope | PR #565 | No production source file modified; `tests/cache_warm_hit.rs` (new) and `src/cache.rs` test module only. No CLI flags, API methods, config paths, or keychain entries changed. |
| `JR_CACHE_DIR` isolation seam | BC-6.2.017, S-WIN-2 | All warm-hit integration tests use `JR_CACHE_DIR` set to a per-test `TempDir` (via `jr_cmd_with_xdg` or equivalent) to prevent on-disk side effects and cross-test cache leakage. |
| `expect(1)` call-count pin | BC-6.2.018 D2 | Warm-hit tests mount the backing endpoint with `.expect(1)` — not `.expect(0..=99)` or unbounded. Any second HTTP call causes wiremock to panic on `MockServer` drop, immediately surfacing the regression in the test log. |
| ENOTDIR swallow technique | BC-X.12.008 D5 | Swallow tests force `ENOTDIR` by pointing `JR_CACHE_DIR` at a file (not a directory) so `create_dir_all` inside `write_cache` fails. Non-tautological: would fail if the writer were changed to propagate via `?`. |
| ENV_MUTEX usage | tests/cache_warm_hit.rs | Warm-hit tests that set `JR_CACHE_DIR` env var use `ENV_MUTEX` (or equivalent test-wide mutex) serialized before `catch_unwind`. The MED finding resolved pre-merge confirmed correct unlock ordering: mutex unlock BEFORE `catch_unwind` scope to avoid panic-poison deadlock on test failure. |

## Library and Framework Requirements

| Library | Version | Constraint |
|---------|---------|-----------|
| wiremock | current (from Cargo.toml) | `MockServer::start()`, `Mock::given(…).expect(1)`, response builders. No version change. |
| tempfile | current (from Cargo.toml) | `TempDir` for per-test `JR_CACHE_DIR` isolation. No version change. |
| tokio | current (from Cargo.toml) | `#[tokio::test]` for async test harness. No version change. |

No new crate dependencies were added by PR #565.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `tests/cache_warm_hit.rs` | CREATED (PR #565) | New integration test file — 3 warm-hit tests: `test_team_list_warm_cache_skips_http`, `test_resolutions_warm_cache_skips_http`, `test_project_meta_warm_cache_skips_http`. Header documents intentional cmdb_fields / object_type_attrs skips. |
| `src/cache.rs` | MODIFIED (PR #565) | 2 unit tests added to inline test module: `test_write_request_type_cache_swallows_disk_error` and `test_write_request_type_fields_cache_swallows_disk_error`. |

---

## Acceptance Criteria

All ACs below are **characterization pins** — each was verified PASS at the time the
delivering PR merged (develop @ 788bc0f). No production change is required. Each AC
includes the test function name that satisfies it.

---

### Category A — BC-X.12.008: Request-Type Writer Swallow Pins (src/cache.rs)

#### AC-001 — `write_request_type_cache` swallows disk-write error and returns Ok(())
(traces to BC-X.12.008 postcondition — model-b writer: disk-write error is non-fatal, logged to stderr as warning, does not propagate; Families 8+9 model-b contract)

When `JR_CACHE_DIR` is set to point at a regular file (causing `create_dir_all` to fail
with ENOTDIR), calling `write_request_type_cache("default", "1", &[])` returns `Ok(())` —
it does NOT return `Err`, does NOT panic, and does NOT propagate the I/O error to the
caller. This confirms the model-b swallow path: the disk-write error is silently absorbed
and the command flow continues uninterrupted.

Verified PASS (develop @ 788bc0f).
Pinned by: `src/cache.rs::tests::test_write_request_type_cache_swallows_disk_error`

---

#### AC-002 — `write_request_type_fields_cache` swallows disk-write error and returns Ok(())
(traces to BC-X.12.008 postcondition — model-b writer: sibling RT-fields cache writer; same swallow+warn contract as `write_request_type_cache`)

When `JR_CACHE_DIR` is set to point at a regular file (ENOTDIR), calling
`write_request_type_fields_cache("default", "1", "42", &[])` returns `Ok(())` — no `Err`,
no panic, no propagation. Symmetrically confirms that BOTH request-type cache writers
(list and fields) implement the model-b contract: a failed write never breaks a successful
API call.

Verified PASS (develop @ 788bc0f).
Pinned by: `src/cache.rs::tests::test_write_request_type_fields_cache_swallows_disk_error`

---

### Category B — BC-6.2.018: Warm-Hit Zero-HTTP Coverage (tests/cache_warm_hit.rs)

Warm-hit technique: wiremock `expect(1)` call-count pin. The backing endpoint is mounted
with `.expect(1)`. The command is run twice sharing the same `JR_CACHE_DIR` temp dir.
When `MockServer` drops, wiremock automatically asserts the mount was called exactly once —
a second HTTP call on the warm path would panic on drop.

#### AC-003 — `jr team list` warm cache hit skips HTTP (teams Family 1)
(traces to BC-6.2.018 postcondition — warm hit returns cached value and issues ZERO HTTP calls; Family 1 (teams) routes through generic `read_cache<T>` warm-hit path)

Two successive `jr team list` invocations sharing the same `JR_CACHE_DIR`:
- First invocation (cold miss): mocked GraphQL org endpoint fires once, teams are fetched
  and cached.
- Second invocation (warm hit within TTL): no HTTP call is issued; wiremock `expect(1)`
  pin confirms the endpoint was called exactly once across both invocations.

Verified PASS (develop @ 788bc0f).
Pinned by: `tests/cache_warm_hit.rs::test_team_list_warm_cache_skips_http`

---

#### AC-004 — `jr issue resolutions` warm cache hit skips HTTP (resolutions Family 7)
(traces to BC-6.2.018 postcondition — warm hit returns cached value and issues ZERO HTTP calls; Family 7 (resolutions) routes through generic `read_cache<T>` warm-hit path)

Two successive `jr issue resolutions` invocations sharing the same `JR_CACHE_DIR`:
- First invocation (cold miss): mocked `/rest/api/3/resolution` endpoint fires once,
  resolutions are fetched and written to `resolutions.json`.
- Second invocation (warm hit within TTL): no HTTP call is issued; wiremock `expect(1)`
  pin confirms the endpoint was called exactly once across both invocations.

Verified PASS (develop @ 788bc0f).
Pinned by: `tests/cache_warm_hit.rs::test_resolutions_warm_cache_skips_http`

---

#### AC-005 — `jr sprint list` warm cache hit skips HTTP for project_meta (project_meta Family 2)
(traces to BC-6.2.018 postcondition — warm hit returns cached value and issues ZERO HTTP calls; Family 2 (project_meta) implements a bespoke inline warm path at `src/cache.rs::read_project_meta`, NOT the generic `read_cache<T>` path)

Two successive `jr sprint list --project <KEY>` invocations sharing the same
`JR_CACHE_DIR`:
- First invocation (cold miss): mocked JSM service-desks endpoint fires once, project
  metadata is fetched and written to `project_meta.json`.
- Second invocation (warm hit within TTL): no HTTP call to the project-meta endpoint is
  issued; wiremock `expect(1)` pin confirms the endpoint was called exactly once across
  both invocations. This test specifically exercises the bespoke per-entry inline warm path
  in `read_project_meta`, not the generic `read_cache<T>` warm-hit path.

Verified PASS (develop @ 788bc0f).
Pinned by: `tests/cache_warm_hit.rs::test_project_meta_warm_cache_skips_http`

---

## Out of Scope (explicit)

**No production source changes.** PR #565 is test-only. No CLI flag, API method, config
path, keychain entry, or observable user-facing behavior was changed.

**Per-AC demo recording.** These are pure regression pins with no observable user-facing
surface. Skip Log: `per-AC demo recording N/A — test-only / no user-facing surface`.

**`cmdb_fields` warm-hit (Family 4) and `object_type_attrs` warm-hit (Family 5)** are
intentionally excluded from this story. Both require fragile multi-endpoint assets mock
chains (workspace discovery + CMDB field reads + AQL search all active simultaneously).
Documented in `tests/cache_warm_hit.rs` header as a tracked residual. The shared
`read_cache<T>` generic warm path is already pinned via the Jira-fields test
`test_bc_3_4_015_warm_fields_cache_skips_field_list_http` (`tests/issue_edit_field.rs`),
which exercises the same code path. Dedicated assets-search warm-hit coverage is a
future deliverable.

---

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `test_write_request_type_cache_swallows_disk_error` | `src/cache.rs::tests` | Effectful (disk I/O side channel via ENOTDIR) | Forces file-creation failure by pointing JR_CACHE_DIR at a file; asserts Ok(()) return without panic |
| `test_write_request_type_fields_cache_swallows_disk_error` | `src/cache.rs::tests` | Effectful (disk I/O side channel via ENOTDIR) | Same ENOTDIR technique for sibling RT-fields writer; symmetric model-b contract assertion |
| `test_team_list_warm_cache_skips_http` | `tests/cache_warm_hit.rs` | Effectful (subprocess + wiremock + temp fs) | Spawns `jr team list` twice via `Command`; wiremock `MockServer` with `expect(1)` enforces zero-follow-on-HTTP; per-test `TempDir` via `JR_CACHE_DIR` |
| `test_resolutions_warm_cache_skips_http` | `tests/cache_warm_hit.rs` | Effectful (subprocess + wiremock + temp fs) | Spawns `jr issue resolutions` twice; same expect(1) technique; exercises `read_resolutions_cache` / `write_resolutions_cache` |
| `test_project_meta_warm_cache_skips_http` | `tests/cache_warm_hit.rs` | Effectful (subprocess + wiremock + temp fs) | Spawns `jr sprint list` twice; exercises `read_project_meta` bespoke inline warm path (NOT generic `read_cache<T>`); confirms bespoke path holds same invariant |

**Subsystem anchor justification:** No ARCH-INDEX subsystem applies — both modified files
are single-purpose modules (`src/cache.rs` XDG cache layer; `tests/cache_warm_hit.rs`
integration test file) with no cross-subsystem interaction in these test additions.

**Dependency anchor justification:** `depends_on: []` — all prerequisite production code
for cache Family 1 (teams: `src/cli/team.rs`, `src/api/jira/teams.rs`), Family 7
(resolutions: `src/api/jira/resolutions.rs`), Family 2 (project meta: `src/cache.rs::
read_project_meta`), and Families 8+9 (request-type writers: `src/cache.rs::
write_request_type_cache`, `write_request_type_fields_cache`) was already merged before
PR #565. `blocks: []` — no story depends on these test pins.

---

## Edge Cases

| ID | Source | Description | Expected Behavior | AC |
|----|--------|-------------|-------------------|----|
| EC-001 | BC-6.2.018 EC-1 | Cache expires after 7 days | `read_cache<T>` returns `Ok(None)` on 7th day; cold miss triggers HTTP | Not tested in this PR (expiry behavior covered by TTL unit tests elsewhere) |
| EC-002 | BC-X.12.008 | ENOTDIR on `create_dir_all` — `JR_CACHE_DIR` points at a file | `write_request_type_cache` / `write_request_type_fields_cache` return `Ok(())`, no panic | AC-001, AC-002 |
| EC-003 | BC-6.2.018 / D2 | Second HTTP call on warm path — wiremock `expect(1)` panics on MockServer drop | Regression-detection mechanism: if production code is changed to re-fetch on warm hit, the test would fail with a wiremock expectation violation before any assertion in the test body | AC-003, AC-004, AC-005 |
| EC-004 | BC-6.2.018 D2 | `project_meta` bespoke inline warm path (not generic `read_cache<T>`) | `read_project_meta` per-entry TTL check returns `Ok(Some(meta))` on warm hit — distinct code path from generic `read_cache<T>` but same invariant | AC-005 |
| EC-005 | BC-X.12.008 | `write_request_type_cache` called concurrently from a panic (ENV_MUTEX unlock ordering) | ENV_MUTEX unlocked BEFORE `catch_unwind` scope to avoid panic-poison deadlock; MED finding resolved pre-merge | AC-001, AC-002 |

---

## Test Coverage Summary

All 5 tests pass at delivering commit (develop @ 788bc0f). `cargo test` green.
No test renames; no test deletions; no production source changes.

### PR #565 — Swallow pins in src/cache.rs (2 unit tests)

| Test name | BC | AC |
|-----------|----|----|
| `test_write_request_type_cache_swallows_disk_error` | BC-X.12.008 | AC-001 |
| `test_write_request_type_fields_cache_swallows_disk_error` | BC-X.12.008 | AC-002 |

### PR #565 — Warm-hit integration tests in tests/cache_warm_hit.rs (3 tests)

| Test name | BC | AC |
|-----------|----|----|
| `test_team_list_warm_cache_skips_http` | BC-6.2.018 | AC-003 |
| `test_resolutions_warm_cache_skips_http` | BC-6.2.018 | AC-004 |
| `test_project_meta_warm_cache_skips_http` | BC-6.2.018 | AC-005 |

**Total new tests: 5.** All pass at develop @ 788bc0f.

### Residual Skips (documented)

| Cache Family | Why Skipped | Residual Tracking |
|---|---|---|
| Family 4 — cmdb_fields | Requires fragile multi-endpoint assets mock chains (workspace + CMDB + AQL); pre-populate approach feasible but brittle | Documented in `tests/cache_warm_hit.rs` header; `read_cache<T>` warm path covered via Jira-fields test |
| Family 5 — object_type_attrs | Requires full `assets search` subprocess flow (workspace ID + AQL + object-type-attrs); in-process vs subprocess env-var conflict | Documented in `tests/cache_warm_hit.rs` header |

---

## Dependency Analysis

**No dependency cycle introduced.** This story has `depends_on: []` and `blocks: []`.
It is a leaf node in the dependency graph.

Wave placement: feature-followup (retroactive backfill of delivered test-only changes).
No wave gate impact — story is already `done`.

---

## Story Points and Effort

**2 story points** (retroactive F3 traceability document only; implementation already merged).

Breakdown:
- F3 story authoring: 1 SP
- Pre-PR code review + adversary gate: already run before merge (CLEAN post-resolution);
  no separate dispatch needed: 1 SP

From-scratch TDD estimate would be ~3 SP. Reduction reflects that all tests are already
written, merged, and passing.
