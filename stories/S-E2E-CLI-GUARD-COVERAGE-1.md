---
document_type: story
story_id: "S-E2E-CLI-GUARD-COVERAGE-1"
title: "Retroactive F3 traceability — E2E offline-CLI guard + JSON error-shape test coverage (PR #563)"
wave: feature-followup
status: done
intent: test-hardening-backfill
feature_type: test-only
mode: feature
scope: small
severity: LOW
trivial_scope: false
issue: ~563
points: 2
priority: P2
tdd_mode: strict
estimated_effort: xsmall
estimated_days: 0
target_module: issue_edit_field,json_error_shape
subsystems: []
depends_on: []
blocks: []
bc_anchors:
  - BC-3.4.017
  - BC-7.3.010
bcs:
  - BC-3.4.017
  - BC-7.3.010
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-story-decomposition
spec_source: "E2E edge-case audit 2026-06-27 (offline-CLI-guard tier, drift item E2E-EDGE-CASE-GAPS-2026-06-27)"
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
  PR #563 was delivered then storied (lighter flow, no pre-delivery story file).
  This story provides the missing F3 traceability and closes the process deviation.
  No production source change is involved; all 5 ACs are regression pins —
  the guards were confirmed ALREADY IMPLEMENTED and PASSING before PR #563 was
  raised.  The audit's key finding: these were regression-hardening tests, NOT
  bug fixes.
predecessor_cycles: >
  PR #563 (test: E2E offline-CLI guard + JSON error-shape pins, develop @ 894cc9d).
origin: >
  E2E edge-case audit (offline-CLI-guard tier, drift item E2E-EDGE-CASE-GAPS-2026-06-27).
  Audit confirmed: --field+--label mutual-exclusion guard (FIX-F5-001), C-1 multi-key
  bulk guard (BC-3.4.017 Gate A), and JSON error-envelope discipline (BC-7.3.010) were
  all already implemented and passing.  PR #563 adds regression pins so these confirmed
  behaviors survive future refactors.
f5_review_outcome: >
  F5 fresh-context adversarial review run pre-merge (PR #563): 1 MED + 4 LOW findings,
  all fixed before merge.  Post-merge signal: CLEAN.  This story records that outcome
  as the authoritative F5 gate for this delivery.
delivering_prs:
  - "PR #563 — develop @ 894cc9d"
skip_log:
  - reason: "Per-AC demo recording N/A — test-only story; no user-facing surface added or changed."
changelog:
  - date: "2026-06-27"
    phase: F3-story-decomposition
    author: story-writer
    summary: >
      Retroactive F3 traceability backfill for PR #563.  5 regression pins documented
      across BC-3.4.017 (2 tests in tests/issue_edit_field.rs) and BC-7.3.010
      (3 tests in tests/json_error_shape.rs).  F5 review pre-merge: 1 MED + 4 LOW
      (all fixed).  Post-merge: CLEAN.  Story #93 (92 → 93).
files_modified:
  - tests/issue_edit_field.rs  # 2 new tests: test_edit_field_and_label_combined_exits_64_with_guard_message, test_edit_field_multi_key_bulk_exits_64_with_c1_message
  - tests/json_error_shape.rs  # 3 new tests: test_issue_changelog_output_json_api_error_emits_json_envelope, test_queue_view_output_json_non_jsm_project_emits_json_envelope, test_requesttype_list_output_json_project_404_emits_json_envelope
---

# S-E2E-CLI-GUARD-COVERAGE-1 — Retroactive F3 Traceability: E2E Offline-CLI Guard + JSON Error-Shape Pins

## Status

**DONE — already delivered.**

This story is a RETROACTIVE TRACEABILITY BACKFILL. PR #563 was merged to `develop`
before a story file was written (process deviation from the standard F3-first flow).
This document provides the missing F3 artifact and closes the deviation.  No
production code was changed; all five acceptance criteria are regression pins against
guards that were confirmed ALREADY IMPLEMENTED and PASSING before the PR was raised.

**Origin:** E2E edge-case audit (offline-CLI-guard tier, drift item
E2E-EDGE-CASE-GAPS-2026-06-27).  The audit's key finding was that the guards were
already implemented — the tests PASS without a production change.  This is
regression-hardening, not a bug fix.

**F5 fresh-context adversarial review** was run pre-merge and found 1 MED + 4 LOW
findings, all fixed before merge.  Post-merge signal is CLEAN and recorded in
`f5_review_outcome` frontmatter above.

## Source of Truth

| Artifact | Location |
|----------|----------|
| BC-3.4.017 body | `.factory/specs/prd/bc-3-issue-write.md §3.4.017` |
| BC-7.3.010 body | `.factory/specs/prd/bc-7-output-render.md §7.3.010` |
| PR #563 commit | `develop @ 894cc9d` |
| E2E audit drift item | `E2E-EDGE-CASE-GAPS-2026-06-27` (offline-CLI-guard tier) |

## Behavioral Contracts

| BC | Title | Role in this story |
|----|-------|-------------------|
| BC-3.4.017 | `--field` multi-key/`--jql` multi-issue rejection (C-1 guard) + flag-overlap hard error | PRIMARY: two regression pins — (1) `--field`+`--label` mutual-exclusion guard (FIX-F5-001 Gate B); (2) `--field` on multi-key bulk (C-1 Gate A). Both guards fire pre-HTTP; exit 64. |
| BC-7.3.010 | `--output json` error envelope `{"error","code"}` on stderr + empty stdout invariant | PRIMARY: three regression pins confirming the error-envelope discipline across `issue changelog` (404→exit 1), `queue view` non-JSM guard (→exit 64; pins "Jira Service Management project" guard message), and `requesttype list` project 404 (→exit 1). |

## Story Narrative

As a developer maintaining the `jr` codebase,
I want regression tests that pin the behavioral guarantees of the `--field`+`--label`
mutual-exclusion guard, the C-1 multi-key bulk rejection, and the `--output json`
error-envelope discipline for `issue changelog`, `queue view`, and `requesttype list`,
so that future refactors immediately surface regressions against these behavioral
contracts before they reach CI and before they affect users.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~1,400 |
| tests/issue_edit_field.rs (2 test fns, ~120 LOC) | ~550 |
| tests/json_error_shape.rs (3 test fns + helper, ~220 LOC) | ~900 |
| BC files (2 BC sections, bc-3 + bc-7) | ~600 |
| **Total** | **~3,450** |

Well within a 20% agent context window budget. No splitting required.

## Previous Story Intelligence

**BC-3.4.017 context (S-396, S-407):**
S-396 delivered `issue edit --field` (BC-3.4.015/016/017) including the FIX-F5-001
mutual-exclusion block and C-1 guard.  S-407 added 10 positive regression tests for the
`--label` conflict block.  PR #563 adds the two previously missing negative-path
integration tests: the combined `--field`+`--label` exit-64 guard and the C-1 multi-key
bulk exit-64 guard.

**BC-7.3.010 context (S-526, S-JSM-E2E-1):**
S-526 unified the JSON render chokepoint and established BC-7.3.010 (issue #526).
S-JSM-E2E-1 pinned the `queue view` non-JSM guard at the E2E (live) tier.  PR #563
adds the three missing wiremock-tier regression tests that pin the error-envelope shape
for `issue changelog`, `queue view`, and `requesttype list` — commands that had no
`--output json` error-path coverage at the offline-integration tier.

**N/A — no successor stories blocked by this backfill.**

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Test-only scope | PR #563 | No production source file modified.  Two integration test files (`tests/issue_edit_field.rs`, `tests/json_error_shape.rs`) only.  No CLI flags, API methods, config paths, or keychain changes. |
| Guards fire pre-HTTP | BC-3.4.017 Gate A + Gate B | Both `--field`+`--label` and multi-key C-1 tests mount ZERO mocks.  Assertions verify exit 64 AND empty stdout AND non-empty stderr.  If a test unexpectedly reaches an HTTP call, WireMock returns 404 and the test catches it at the exit-code assertion. |
| Error envelope on stderr, empty stdout | BC-7.3.010 | All three json_error_shape tests assert: (1) exit code matches expected; (2) stderr is valid JSON of shape `{"error": <string>, "code": <int>}`; (3) stdout is empty.  The `assert_json_error_envelope` helper enforces all three invariants. |
| No numeric test-count citations in BC bodies | scripts/check-bc-no-numeric-test-counts.sh | This story does not modify BC bodies.  It documents tests already satisfying existing BC Source/Trace fields. |

## Library and Framework Requirements

| Library | Version | Constraint |
|---------|---------|-----------|
| wiremock | current (from Cargo.toml) | All integration tests use WireMock for HTTP isolation.  No version change. |
| tokio | current (from Cargo.toml) | `#[tokio::test(flavor = "multi_thread", worker_threads = 2)]` on all 5 new tests.  No version change. |
| serde_json | current (from Cargo.toml) | `assert_json_error_envelope` helper parses stderr as JSON and asserts shape.  No version change. |

No new crate dependencies were added by PR #563.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `tests/issue_edit_field.rs` | MODIFIED (PR #563) | 2 new integration tests appended: `test_edit_field_and_label_combined_exits_64_with_guard_message` (FIX-F5-001 / BC-3.4.017 Gate B) and `test_edit_field_multi_key_bulk_exits_64_with_c1_message` (BC-3.4.017 Gate A) |
| `tests/json_error_shape.rs` | MODIFIED (PR #563) | 3 new integration tests: `test_issue_changelog_output_json_api_error_emits_json_envelope`, `test_queue_view_output_json_non_jsm_project_emits_json_envelope`, `test_requesttype_list_output_json_project_404_emits_json_envelope` |

No new files were created.  No production source files were added or modified.

---

## Acceptance Criteria

All ACs below are **regression pins** — each was verified PASS at the time the
delivering PR merged (develop @ 894cc9d).  No production change was required;
the guards being pinned were confirmed already implemented.  Each AC includes the
test function name that satisfies it.

---

### tests/issue_edit_field.rs — BC-3.4.017 Guards

#### AC-001 — `--field` + `--label` combined invocation exits 64 with guard message
(traces to BC-3.4.017 Gate B postcondition — flag-overlap hard error; FIX-F5-001;
`--label`/`--field` mutual-exclusion block in `edit.rs::handle_edit`)

`jr issue edit FOO-1 --field Severity=Critical --label add:foo --no-input` exits 64.
Stderr contains `"--label cannot be combined with"` and `"--field"`.
Stdout is empty (no partial data emitted before the guard fires).
No mocks are mounted; the mutual-exclusion guard fires before any HTTP call.

This pin closes the audit gap: S-396 delivered the guard (FIX-F5-001); S-407 added
positive `--label` regression tests; no test previously exercised the combined
`--field`+`--label` exit-64 path at the integration tier.

Verified PASS (develop @ 894cc9d).
Pinned by: `tests/issue_edit_field.rs::test_edit_field_and_label_combined_exits_64_with_guard_message`

---

#### AC-002 — `--field` on multi-key bulk edit exits 64 with C-1 guard message
(traces to BC-3.4.017 Gate A postcondition — C-1 guard; `--field` is REJECTED_IN_BULK;
`edit.rs::handle_edit` unsupported-flags block fires on 2+ positional keys)

`jr issue edit FOO-1 FOO-2 --field Severity=Critical --no-input` exits 64.
Stderr contains `"--field"` and the bulk-rejection pattern (C-1 guard message).
No mocks are mounted; the C-1 guard fires from argument count before any HTTP call.

Without the guard, `--field` on the bulk path would reach `handle_edit_bulk_fields`
which ignores `field_pairs` entirely, producing silent data loss with exit 0.

Verified PASS (develop @ 894cc9d).
Pinned by: `tests/issue_edit_field.rs::test_edit_field_multi_key_bulk_exits_64_with_c1_message`

---

### tests/json_error_shape.rs — BC-7.3.010 Error-Envelope Shape

#### AC-003 — `issue changelog` 404 → compact JSON envelope on stderr, empty stdout, exit 1
(traces to BC-7.3.010 postcondition / EC-1 — error on read command; `{"error":"…","code":1}`
on stderr; stdout empty; envelope emitted by `src/main.rs::main` via compact `serde_json::json!`)

`jr issue changelog FOO-1 --output json` when `GET /rest/api/3/issue/FOO-1/changelog`
returns 404 → exit 1; stderr is parseable as `{"error": <string>, "code": 1}`; stdout
is empty.  The `assert_json_error_envelope` helper validates all three invariants.

Verified PASS (develop @ 894cc9d).
Pinned by: `tests/json_error_shape.rs::test_issue_changelog_output_json_api_error_emits_json_envelope`

---

#### AC-004 — `queue view` non-JSM project → compact JSON envelope on stderr, guard message pinned, exit 64
(traces to BC-7.3.010 postcondition / EC-1 — error on read command; also pins
`require_service_desk` guard message "Jira Service Management project" at the
integration tier; BC-X.8.004 guard message invariant)

`jr queue view --id 99 --output json --project HELP` when project HELP is a software
project (not service_desk) → exit 64; stderr is parseable JSON with `"code": 64` and
`"error"` containing `"Jira Service Management project"` (the exact phrase from
`src/api/jsm/servicedesks.rs::require_service_desk`); stdout is empty.

The guard-message substring pin distinguishes this from other exit-64 UserErrors:
a different guard firing at the same code would not contain this substring, and the
test would correctly fail.

Verified PASS (develop @ 894cc9d).
Pinned by: `tests/json_error_shape.rs::test_queue_view_output_json_non_jsm_project_emits_json_envelope`

---

#### AC-005 — `requesttype list` project 404 → compact JSON envelope on stderr, empty stdout, exit 1
(traces to BC-7.3.010 postcondition / EC-1 — error on read command; `{"error":"…","code":1}`
on stderr; stdout empty; propagated from `require_service_desk` via `?`)

`jr requesttype list --output json --project HELP` when `GET /rest/api/3/project/HELP`
returns 404 → exit 1; stderr is parseable as `{"error": <string>, "code": 1}`; stdout
is empty.  The `assert_json_error_envelope` helper validates all three invariants.

Verified PASS (develop @ 894cc9d).
Pinned by: `tests/json_error_shape.rs::test_requesttype_list_output_json_project_404_emits_json_envelope`

---

## Out of Scope (explicit)

**No production source changes.** PR #563 is test-only.  No CLI flag, API method,
config path, keychain entry, or observable user-facing behavior was changed.

**Per-AC demo recording.** These are pure regression pins with no observable
user-facing surface.  Skip Log: `per-AC demo recording N/A — test-only / no user-facing
surface`.

**E2E (live) tier coverage for these guards.** The `queue view` non-JSM guard is
exercised at the live E2E tier by S-JSM-E2E-1 (PR #460).  The `--field`+`--label` and
C-1 guards have no live-E2E tests by design — they are guard conditions that short-
circuit before any Jira API call, so wiremock-tier testing is the appropriate tier.

---

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `test_edit_field_and_label_combined_exits_64_with_guard_message` | `tests/issue_edit_field.rs` | Effectful (subprocess + WireMock) | Spawns `jr` subprocess; asserts exit code, stderr content, stdout emptiness; no mocks needed (guard fires pre-HTTP) |
| `test_edit_field_multi_key_bulk_exits_64_with_c1_message` | `tests/issue_edit_field.rs` | Effectful (subprocess + WireMock) | Spawns `jr` subprocess; asserts exit code, stderr content; no mocks needed (C-1 guard fires pre-HTTP) |
| `test_issue_changelog_output_json_api_error_emits_json_envelope` | `tests/json_error_shape.rs` | Effectful (subprocess + WireMock) | Mounts 404 on changelog endpoint; asserts error-envelope shape, exit 1, empty stdout |
| `test_queue_view_output_json_non_jsm_project_emits_json_envelope` | `tests/json_error_shape.rs` | Effectful (subprocess + WireMock) | Mounts software-project response; asserts guard message substring, exit 64, empty stdout |
| `test_requesttype_list_output_json_project_404_emits_json_envelope` | `tests/json_error_shape.rs` | Effectful (subprocess + WireMock) | Mounts 404 on project endpoint; asserts error-envelope shape, exit 1, empty stdout |

**Subsystem anchor justification:** No ARCH-INDEX subsystem applies — both modified
files are integration test files (`tests/`) with no cross-subsystem interaction in
these additions.

**Dependency anchor justification:** `depends_on: []` — all prerequisite production
code (FIX-F5-001 / BC-3.4.017 guard in S-396/S-407; BC-7.3.010 json-render invariant
in S-526; `require_service_desk` in the JSM API layer from S-JSM-E2E-1 context) was
already merged before PR #563.  `blocks: []` — no story depends on these test pins.

---

## Edge Cases

| ID | Source | Description | Expected Behavior | AC |
|----|--------|-------------|-------------------|----|
| EC-001 | BC-3.4.017 Gate B / FIX-F5-001 | `--field` and `--label` on the same single-key invocation | FIX-F5-001 mutual-exclusion block fires; exit 64; stderr names both flags; NO HTTP call (zero mocks mounted) | AC-001 |
| EC-002 | BC-3.4.017 Gate A (C-1 guard) | `--field` with 2+ positional keys (bulk path) | C-1 guard fires from argument count; exit 64; `--field` named in stderr; no `editmeta`, no PUT | AC-002 |
| EC-003 | BC-7.3.010 EC-1 | API 404 on a read command (`issue changelog`) under `--output json` | Error propagates via `?`; `src/main.rs::main` emits compact `{"error":"…","code":1}` to stderr; stdout empty | AC-003 |
| EC-004 | BC-7.3.010 EC-1 + BC-X.8.004 | `queue view` on a non-JSM project under `--output json` | `require_service_desk` fires exit 64 UserError; envelope contains "Jira Service Management project" substring; stdout empty | AC-004 |
| EC-005 | BC-7.3.010 EC-1 | Project 404 on `requesttype list` under `--output json` | Error propagates via `?`; `{"error":"…","code":1}` on stderr; stdout empty | AC-005 |

---

## Test Coverage Summary

All tests are integration tests (subprocess + WireMock).  No new inline unit tests.
No new E2E (live) tests.

### PR #563 — tests/issue_edit_field.rs (2 new tests)

| Test name | BC | AC |
|-----------|----|----|
| `test_edit_field_and_label_combined_exits_64_with_guard_message` | BC-3.4.017 Gate B / FIX-F5-001 | AC-001 |
| `test_edit_field_multi_key_bulk_exits_64_with_c1_message` | BC-3.4.017 Gate A | AC-002 |

### PR #563 — tests/json_error_shape.rs (3 new tests)

| Test name | BC | AC |
|-----------|----|----|
| `test_issue_changelog_output_json_api_error_emits_json_envelope` | BC-7.3.010 | AC-003 |
| `test_queue_view_output_json_non_jsm_project_emits_json_envelope` | BC-7.3.010 | AC-004 |
| `test_requesttype_list_output_json_project_404_emits_json_envelope` | BC-7.3.010 | AC-005 |

**Total new tests: 5.**  All pass at delivering commit (develop @ 894cc9d).
`cargo test` green.  No test renames; no test deletions.

**F5 review outcome (pre-merge):** 1 MED + 4 LOW findings, all fixed before merge.
Post-merge: CLEAN.

---

## Dependency Analysis

**No dependency cycle introduced.**  This story has `depends_on: []` and `blocks: []`.
It is a leaf node in the dependency graph.

Wave placement: feature-followup (retroactive backfill of delivered test-only changes).
No wave gate impact — story is already `done`.

---

## Story Points and Effort

**2 story points** (retroactive F3 traceability document only; implementation already
merged).

Breakdown:
- F3 story authoring: 1 SP
- F5 review: already run pre-merge (1 MED + 4 LOW, all fixed); no separate dispatch
  needed: 1 SP

From-scratch TDD estimate would be ~3 SP.  Reduction reflects that all tests are
already written, merged, and passing.
