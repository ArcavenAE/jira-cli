---
document_type: red-gate-log
level: ops
version: "1.0"
status: complete
producer: state-manager
timestamp: 2026-08-27T00:00:00Z
phase: F4
inputs: []
input-hash: "[live-state]"
traces_to: ""
stub_architect_agent: "[stub-architect, S-578-3-stubs]"
stub_compile_verified: true
test_writer_agent: "[test-writer, S-578-3-red-gate]"
red_gate_verified: true
story: S-578-3
cycle: cycle-002
feature_mode_bundle: field-dx
feature_branch: feature/S-578-3-jsm-create-field-dispatch
develop_base_sha: a3739763
pr: 742
merge_sha: 41763ff0cbbd64ca325fb56e14f1d55ed5b79837
---

# Red Gate Log: S-578-3 (JSM `issue create --field` hint-kind dispatch)

## Summary

| Story | Tests Written | All Fail (Red)? | Gate |
|-------|----------------|------------------|------|
| S-578-3 (JSM `issue create --field` hint-kind dispatch, 8pts) | 11 new integration tests covering BC-3.8.008 kind-aware `requestFieldValues` composers | 11/11 FAIL on real assertion mismatches, 0 build errors, 0 panics; 102-test pre-existing baseline green | **VERIFIED** |

## Stubs Created

### S-578-3: JSM `issue create --field` kind-aware dispatch

Module stubs commit (`feat(S-578-3): add JSM kind-aware serialization
stubs`): threaded `FieldValueSpec` through `JsmRequestBuilder.extra_fields`
(was `HashMap<String, String>`) and stubbed the kind-aware
`requestFieldValues` composers (`:id`/`:name`/`:asset`) plus the
`jsm_create.rs` `:asset` L2 workspace-resolution helper as `todo!()`-body
signatures. The bare/`:option` string-wrap arm stayed real (unchanged,
AC-002/AC-008 — VP-578-015 byte-identity regression pin depends on this arm
never moving). The interim `reject_unsupported_hint_kinds` guard (S-578-1)
was left **intact**, so hinted `--field` pairs on the JSM create path still
exited 64 at the stub step, keeping the Red Gate meaningfully red pending
test-writer + implement.

- `fn build(...) -> Result<Value, JrError>` (`src/api/jsm/requests.rs`) --
  `extra_fields` loop signature changed to iterate `FieldValueSpec`; kind
  match arms for `Id`/`Name`/`Asset` stubbed `todo!()`; bare/`Option` arm
  unchanged (string-wrap, real)
- `fn resolve_asset_field_l2(...) -> Result<String>` (`src/cli/issue/jsm_create.rs`)
  -- `todo!()` stub (mirrors S-578-2's `field_resolve.rs::compose_asset_hint`
  split: L2 resolves, `build()` only wraps)

**Compile verification:** `cargo check` clean, guard intact, no warnings, no
errors.

## Red Gate Verification

### S-578-3

Test-writer commit (`test(S-578-3): add failing tests for BC-3.8.008 JSM
kind-aware requestFieldValues`) added the Red Gate test suite to
`tests/issue_create_jsm.rs` covering the 10 originally-scoped acceptance
criteria for `:id`/`:name`/`:asset` hint-kind dispatch, the `:asset` 4-row
cold-cache failure taxonomy, layer-isolation assertions (`build()` never
calls `get_or_fetch_workspace_id`), and the VP-578-015 bare/`:option`
byte-identity pin.

- 11 new integration tests -- 11/11 FAIL (expected; real assertion
  mismatches, never panics or build errors) -- every hinted `--field` pair
  was still intercepted by S-578-1's interim `reject_unsupported_hint_kinds`
  guard before the real dispatch (still a `todo!()` stub) was ever reached.
- Pre-existing `tests/issue_create_jsm.rs` baseline (61 tests at Red Gate
  start, later renumbered by the P1 fix-burst and PR-review strengthening
  pass): 102 tests green, unaffected by the stub step.

**Fix-burst Red Gate (`:asset` L2 validation gap, adversary Pass 1):**
Adversary Pass 1 (ADV-S578-3-P1-001 HIGH + 2 MEDIUM) found the JSM `:asset`
L2 resolver (`jsm_create.rs::resolve_asset_field_l2`) dropped the platform
sibling's (`field_resolve.rs::compose_asset_hint`) 4-check value-shape
validation -- a malformed `:asset` value (missing `:`, empty workspace
segment, empty/non-numeric object-id segment) was not rejected before the
workspace-discovery GET, diverging from DEC-188's pre-flight-guard
convention. Test-writer commit added negative-path tests for all four
malformed shapes, each asserting exit 64 + exact message + `.expect(0)` on
both the workspace GET and the POST mock. All four RED (validation absent)
then GREEN after the implementation fix-burst commit ported the 4-check
validation into `resolve_asset_field_l2` (same checks, same precedence,
same message strings as the platform sibling -- tracked as duplicated debt,
`S-578-3-SHARED-ASSET-VALIDATOR`).

## Regression Check

| Existing Tests | Status |
|-----------------|--------|
| `tests/issue_create_jsm.rs` pre-existing suite | All pass at Red Gate (S-578-1's interim guard + bare-form dispatch untouched by the stub step) |
| `tests/issue_create_jsm.rs` at final GREEN (post-merge) | **107/107 PASS** in-binary (81 in-file tests + 26 `common::wf::tests` pulled in via `mod common;`, unrelated to this story -- report the 81 in-file delta, not the 107 binary total, per pr-reviewer B1) |
| `tests/jsm_request_api.rs` (untouched-key wire-shape assertions) | 0 regressions |
| `cargo clippy --all-targets -- -D warnings` | clean |
| `cargo fmt --all -- --check` | clean |

Independently re-confirmed by pr-reviewer at PR #742 HEAD `29300a3b`
(`cargo test --test issue_create_jsm`: 107/107 passed, 0 failed).

## Hand-Off to Implementer

- Stories ready for implementation: S-578-3 (COMPLETE — see below).
- Implementation guidance: replace the `:id`/`:name`/`:asset` `todo!()`
  composer stubs in `src/api/jsm/requests.rs::build()` with real kind-aware
  dispatch (BC-3.8.008); implement `jsm_create.rs::resolve_asset_field_l2`'s
  L2 workspace-id resolution + 4-check value-shape validation; remove the
  `reject_unsupported_hint_kinds` call site from `jsm_create.rs` AND delete
  the now-unused helper function itself (S-578-3 is its last caller, per
  the guard-replacement Red-Gate strategy documented in the prior Session
  Resume Checkpoint).
- Feature branch: `feature/S-578-3-jsm-create-field-dispatch`, base `a3739763`.
- PR #742 squash-merged to `develop` @ `41763ff0cbbd64ca325fb56e14f1d55ed5b79837`
  (2026-08-27). 4-pass adversary convergence (Pass 1 BLOCKING HIGH + 2
  MEDIUM, Passes 2/3 NITPICK_ONLY, Pass 4 CLEAN — see
  `adversary-convergence-state.json` in this directory), pr-reviewer
  APPROVE after fix commit `29300a3b` resolved 2 BLOCKING findings (B1
  test-count body correction, B2 byte-identity full-map pin). WAVE 2
  COMPLETE (S-578-2 + S-578-3 both merged).
