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
stub_architect_agent: "[stub-architect, S-578-2-stubs]"
stub_compile_verified: true
test_writer_agent: "[test-writer, S-578-2-red-gate]"
red_gate_verified: true
story: S-578-2
cycle: cycle-002
feature_mode_bundle: field-dx
feature_branch: feature/S-578-2-edit-field-dispatch
develop_base_sha: 74221bbc
pr: 741
merge_sha: a3739763cb1cc3d52bdb0340085113bc5afb2adb
---

# Red Gate Log: S-578-2 (`issue edit --field` hint-kind dispatch)

## Summary

| Story | Tests Written | All Fail (Red)? | Gate |
|-------|----------------|------------------|------|
| S-578-2 (`issue edit --field` hint-kind dispatch, 13pts) | 29 (26 integration + 2 proptests) covering 18 ACs, + 1 inline serde round-trip test | 28/29 FAIL on real assertion mismatches, 0 build errors, 0 panics; 1 legitimately GREEN | **VERIFIED** |

## Stubs Created

### S-578-2: `issue edit --field` hint-kind dispatch

Module stubs commit (`feat(S-578-2): add module stubs`): threaded
`FieldValueSpec` (S-578-1's shared type) through `resolve_edit_fields`'s
signature and both `edit.rs` call sites (dry-run + live path); added a
compilable `todo!()`-body hinted-bypass dispatch branch plus four composer
stubs (`:option` cascading, `:id`, `:name`, `:asset`) in `field_resolve.rs`.
The S-578-1 interim `reject_unsupported_hint_kinds` guard and its `edit.rs`
call site were left **intact** so the branch is exercised structurally (no
dead code) without implementing real dispatch — this is what makes the Red
Gate meaningfully red without a fully-dispatched implementation (documented
guard-replacement strategy). `AllowedValue.children` (AC-011) already
existed from S-580-1 — no change needed there.

- `fn resolve_edit_fields(...) -> Result<...>` -- signature extended with
  `FieldValueSpec`-typed input + `planned_preview` output param; body
  unchanged except for the new `todo!()`-stub hinted-bypass branch
- `fn compose_option_hint(...) -> Result<Value>` -- `todo!()` stub (cascading
  + non-cascading `:option`)
- `fn compose_id_hint(...) -> Result<Value>` -- `todo!()` stub
- `fn compose_name_hint(...) -> Result<Value>` -- `todo!()` stub
- `fn compose_asset_hint(...) -> Result<Value>` -- `todo!()` stub

**Compile verification:** `cargo check` clean, guard intact, no warnings, no
errors.

## Red Gate Verification

### S-578-2

Test-writer commit (`test(S-578-2): add failing tests for
BC-3.4.015/016/021/027-031 hint-kind dispatch`) added
`tests/issue_field_hint_kinds.rs` (29 tests: 26 integration tests + 2
proptests) covering all 18 originally-scoped acceptance criteria for
`:option`/`:id`/`:name`/`:asset` hint-kind dispatch, cascading `Parent>Child`
composition, the non-cascading-field D4 collision guard, the `:asset`
`WORKSPACE:OBJECTID` composer and its cold-cache workspace-discovery error
taxonomy, and the dry-run `plannedChanges` per-hint-kind preview.

- AC-001..AC-018 (BC-3.4.015/016/021/027/028/029/030/031): 26 integration
  tests + 2 proptests -- 28/29 FAIL (expected; real assertion mismatches,
  never panics or build errors) -- every hinted `--field` was still
  intercepted by S-578-1's interim `reject_unsupported_hint_kinds` guard
  before the real dispatch (still a `todo!()` stub) was ever reached.
- AC-005 (bare-form `>` literal): legitimately PASS at Red Gate -- exercises
  pre-existing, unmodified BC-3.4.015/016 code the interim guard never
  intercepts.
- AC-011 (`AllowedValue.children` serde round-trip, inline in
  `src/types/jira/editmeta.rs`): legitimately PASS at Red Gate -- the field
  was added by S-580-1, prior to this story; pins the type-level
  prerequisite BC-3.4.027's composer depends on.

**Fix-burst Red Gate (EC-3.4.027-1 entry-point gate, adversary Pass 1):**
Adversary Pass 1 (ADV-S578-2-P1-001..007) found the entry-point
`schema.type` gate for `:option` (EC-3.4.027-1) was unimplemented — a
non-option field with empty `allowedValues` fell through to BC-3.4.016's "no
configured option values" message instead of failing at the entry point.
Test-writer commit (`test(S-578-2): add EC-3.4.027-1 gate + cascading-error +
multi-asset coverage (adv P1 fix)`) added 3 gate-specific tests asserting the
two distinct exit-64 message sub-cases (array/any reuse of BC-3.4.015's exact
message; other scalar types get a distinct "is not an option field"
message). All 3 RED (compose_option_hint had no gate — fell through to the
wrong existing message) then GREEN after implementation commit
(`feat(S-578-2): enforce EC-3.4.027-1 :option entry-point type gate (adv P1
fix)`), which gates on `meta_field.schema.field_type` before any
`allowedValues`/`children` inspection.

## Regression Check

| Existing Tests | Status |
|-----------------|--------|
| `tests/issue_edit_field.rs` (64-test suite; 90 with shared `common::` helpers) | All pass at Red Gate (S-578-1's interim guard + bare-form dispatch untouched by the stub step) |
| `tests/issue_edit_field.rs` at final GREEN (post-merge) | **90/90 PASS** -- 0 regressions |
| `tests/issue_field_hint_kinds.rs` (new) at final GREEN | **64/64 PASS** (grew from 29 at Red Gate to 64 via the adv-P1 gate tests + PR-review test strengthening) |
| `cargo clippy --all-targets -- -D warnings` | clean |
| `cargo fmt --all -- --check` | clean |

Independently re-confirmed by pr-reviewer at PR #741 HEAD `4d0d54af`
(`cargo test --test issue_field_hint_kinds`: 64 passed, 0 failed).

## Hand-Off to Implementer

- Stories ready for implementation: S-578-2 (COMPLETE — see below).
- Implementation guidance: replace the four `todo!()` composer stubs in
  `field_resolve.rs` with real dispatch logic (BC-3.4.027/028/029/030);
  remove the `reject_unsupported_hint_kinds` call site from `edit.rs` only
  (the helper itself stays defined in `create.rs`, still called from
  `jsm_create.rs` — S-578-3 removes it as the last caller).
- Implementation commits: `feat(S-578-2): implement :option/:id/:name/:asset
  hinted-bypass composers` + `feat(S-578-2): remove S-578-1 interim guard,
  wire real hinted dispatch` + fix-burst commits (EC-3.4.027-1 gate,
  empty-child EC-3.4.027-3 conformance, EC-8/9 wire-body + proptest
  strengthening, `field_resolve.rs` CLAUDE.md size-doc entry) -- drove all
  64 behavioral tests green; 90/90 regression baseline green; clippy/fmt
  clean.
- Feature branch: `feature/S-578-2-edit-field-dispatch`, base `74221bbc`.
- PR #741 squash-merged to `develop` @ `a3739763cb1cc3d52bdb0340085113bc5afb2adb`
  (2026-08-27). 4-pass adversary convergence (Pass 1 BLOCKING, Passes 2/3/4
  NITPICK_ONLY — see `adversary-convergence-state.json` in this directory),
  security-reviewer APPROVE, pr-reviewer APPROVE (0 blocking, 11
  non-blocking, 4 fixed in-PR).
