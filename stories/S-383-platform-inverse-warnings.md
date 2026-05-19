---
document_type: story
story_id: "S-383"
title: "Emit stderr warnings when --field/--on-behalf-of used without --request-type on platform path (closes #383)"
wave: feature-followup
status: ready
intent: enhancement
feature_type: backend
scope: standard
issue: 383
points: 2
priority: low
tdd_mode: strict
estimated_effort: small
depends_on: []
bc_anchors:
  - BC-3.8.012
  - BC-3.8.013
  - BC-3.8.011
  - BC-3.3.001
holdout_anchors: []
nfr_anchors: []
adr_refs:
  - ADR-0014
sd_refs: []
parent_phase: F3-story-decomposition
spec_source: ".factory/phase-f1-delta-analysis/issue-383/delta-analysis.md"
implementation_strategy: tdd
module_criticality: HIGH  # src/cli/issue/create.rs — central dispatch for all issue create paths
files_modified:
  - src/cli/issue/create.rs
test_files:
  - tests/issue_create_jsm.rs
breaking_change: false
# BC status: BC-3.8.012 + BC-3.8.013 converged in F2 (2026-05-19, 9 passes + final confirmation).
# F3 story produced on human GO after F2 convergence log sealed.
---

# S-383 — Platform-Path Inverse Warnings: --field and --on-behalf-of

## Source of Truth

F1 delta analysis: `.factory/phase-f1-delta-analysis/issue-383/delta-analysis.md` (approved).
F2 adversary convergence log: `.factory/phase-f2-spec-evolution/issue-383/adversary-convergence-log.md` (CONVERGED, 9 passes).

Authoritative warning strings live in `bc-3-issue-write.md` BC-3.8.012 and BC-3.8.013 bodies.
Do NOT paraphrase — copy verbatim from the BC bodies into `eprintln!` calls.

## Problem Statement

After PR #381 (issue #288 dispatch fork), `--field` and `--on-behalf-of` are accepted as
CLI flags on `jr issue create` but silently discarded when `--request-type` is absent (the
platform path). No warning is emitted. This is the inverse of the BC-3.8.011 situation
(platform-only flags silently dropped on the JSM path), which was fixed in issue #288 pr4.

Issue #383 closes the symmetry gap: two `eprintln!` guards inserted at the top of the
platform branch in `handle_create`, one for `--field` (BC-3.8.012) and one for
`--on-behalf-of` (BC-3.8.013).

## Behavioral Contracts

| BC ID | Title | Clause |
|-------|-------|--------|
| BC-3.8.012 | `--field` on platform path emits stderr warning (idempotent per flag NAME) | postconditions 1–5 |
| BC-3.8.013 | `--on-behalf-of` on platform path emits stderr warning | postconditions 1–4 |
| BC-3.8.011 | Platform-only flags ignored on JSM path emit stderr warnings | (context/precedent — regression baseline) |
| BC-3.3.001 | Platform create path (no `--request-type`) proceeds to completion | (invariant — must not break) |

## Acceptance Criteria

- **AC-1** (traces to BC-3.8.012 postcondition 1 — field warning fires): When `jr issue create
  --field NAME=VALUE ...` is invoked WITHOUT `--request-type`, exactly ONE stderr line matching
  the verbatim BC-3.8.012 string fires:
  `"warning: --field is ignored on the platform create path; it only applies with --request-type (JSM service-desk requests). To pass custom fields to a JSM request type, also supply --request-type."`
  The platform POST to `/rest/api/3/issue` proceeds normally; stdout JSON (e.g., `{"key":"FOO-123"}`)
  is unchanged; exit code is 0 on success.

- **AC-2** (traces to BC-3.8.013 postcondition 1 — on-behalf-of warning fires): When
  `jr issue create --on-behalf-of <ACCOUNT_ID> ...` is invoked WITHOUT `--request-type`, exactly
  ONE stderr line matching the verbatim BC-3.8.013 string fires:
  `"warning: --on-behalf-of is ignored on the platform create path; it only applies with --request-type (JSM service-desk requests). To raise a request on behalf of another user, also supply --request-type."`
  The platform POST proceeds normally; stdout JSON unchanged; exit code 0 on success.

- **AC-3** (traces to BC-3.8.012 postcondition 3 + BC-3.8.013 postcondition 3 — both fire
  independently): When `jr issue create --field NAME=VALUE --on-behalf-of <ID> ...` is invoked
  WITHOUT `--request-type`, BOTH warnings fire independently on stderr. Each is present exactly
  once. Stderr order is not specified (either may appear first). Platform POST proceeds normally.

- **AC-4** (traces to BC-3.8.012 postcondition 4 + BC-3.8.013 postcondition 4 — negative case):
  `jr issue create --summary "Foo" --project BAR` WITHOUT `--field` AND WITHOUT `--on-behalf-of`
  AND WITHOUT `--request-type` → stderr is byte-identical to pre-issue-#383 behavior. The two
  new warnings do NOT appear.

- **AC-5** (traces to BC-3.8.012 postcondition 2 — idempotency per flag NAME): `jr issue create
  --field A=1 --field A=2 --field B=3 ...` WITHOUT `--request-type` → exactly ONE warning fires
  (the per-logical-flag-NAME rule: `--field` is one logical flag regardless of how many
  `NAME=VALUE` occurrences). The warning is not repeated per occurrence or per distinct NAME.

- **AC-6** (traces to BC-3.8.011 invariant — forward-path regression gate): `jr issue create
  --request-type X --field NAME=VALUE` (JSM path, both flags present) → BC-3.8.012 does NOT fire.
  The BC-3.8.011 forward-warning tests (lines 1587–1865 in `tests/issue_create_jsm.rs`) still
  pass unchanged; no new warnings appear on the JSM path from this change.

- **AC-7** (traces to BC-3.8.012 postcondition 5 — malformed --field edge case): `jr issue create
  --field bareflag-no-equals ...` WITHOUT `--request-type` → exactly ONE BC-3.8.012 warning fires
  on stderr; the command does NOT exit with code 64. The platform path does NOT parse
  `--field NAME=VALUE` strings (only detects flag presence); format validation (BC-3.8.008) applies
  only on the JSM path.

## Test File Decision

Keep new tests in `tests/issue_create_jsm.rs` to mirror the BC-3.8.011 forward-direction tests
already in that file. The file covers JSM-adjacent cross-flag interaction tests; the inverse-warning
tests are in the same behavioral cluster. A `tests/issue_create_platform_inverse_warning.rs` split
is deferred — the F2 BC bodies acknowledge this and explicitly defer the split decision to F3. Adding
to the existing file avoids a new test binary and keeps platform + JSM cross-flag tests co-located.
Document this decision in a comment at the top of the new test block.

## Files to Touch

| File | Change |
|------|--------|
| `src/cli/issue/create.rs` | Insert 2 `if` guard blocks after line ~119 (after `if request_type.is_some() { ... return ... }` block, before `let project_key = ...`) |
| `tests/issue_create_jsm.rs` | Append 7 new integration tests covering AC-1 through AC-7 |

Do NOT touch BC files (BCs are converged in F2). Do NOT touch `src/cli/mod.rs`
(no `requires` attribute needed per F1 impact-boundary.md).

## Token Budget Estimate

| Item | Tokens (approx) |
|------|----------------|
| This story file | ~2 k |
| delta-analysis.md (F1 scope) | ~5 k |
| BC-3.8.012 + BC-3.8.013 bodies (read for verbatim strings) | ~3 k |
| BC-3.8.011 body (regression context) | ~2 k |
| `src/cli/issue/create.rs` (read insertion site, ~30-line window) | ~3 k |
| `tests/issue_create_jsm.rs` (read existing BC-3.8.011 tests for pattern reference) | ~8 k |
| Tool outputs + `cargo test` output | ~4 k |
| **Total** | **~27 k** |

Well within single-agent context. No split required. LOC delta: ~10 lines in `create.rs`,
~120–160 lines in `tests/issue_create_jsm.rs` (7 test functions with wiremock scaffolding).

## Tasks

- [ ] Read `bc-3-issue-write.md` BC-3.8.012 and BC-3.8.013 bodies — capture verbatim warning strings
- [ ] Read `src/cli/issue/create.rs` around line 119 — identify exact insertion point (after JSM `return`, before `let project_key`)
- [ ] Read `tests/issue_create_jsm.rs` lines 1587–1865 — use BC-3.8.011 test structure as the pattern template
- [ ] Insert BC-3.8.012 guard in `handle_create`: `if !fields.is_empty() { eprintln!("<verbatim>"); }`
- [ ] Insert BC-3.8.013 guard in `handle_create`: `if on_behalf_of.is_some() { eprintln!("<verbatim>"); }`
- [ ] Confirm insertion order (BC-3.8.012 before BC-3.8.013 is natural; order does not affect correctness)
- [ ] Add `test_platform_create_field_flag_emits_warning_without_request_type` (AC-1)
- [ ] Add `test_platform_create_on_behalf_of_flag_emits_warning_without_request_type` (AC-2)
- [ ] Add `test_platform_create_field_and_on_behalf_of_both_warn_without_request_type` (AC-3)
- [ ] Add `test_platform_create_no_field_no_on_behalf_of_no_warnings` (AC-4)
- [ ] Add `test_platform_create_multiple_field_flags_emit_single_warning` (AC-5)
- [ ] Add `test_jsm_path_field_flag_no_inverse_warning_fires` (AC-6 regression gate)
- [ ] Add `test_platform_create_malformed_field_flag_emits_warning_no_exit64` (AC-7)
- [ ] Run `cargo test` — verify all 7 new tests pass + BC-3.8.011 suite (lines 1587–1865) unchanged
- [ ] Run `cargo clippy -- -D warnings` — zero warnings
- [ ] Verify `cargo build --release` succeeds
- [ ] Per-story adversary 3/3 CLEAN before push

## Previous Story Intelligence

This story is adjacent to the just-merged S-382 (JrError::InsufficientScope refactor) and
issue-288-pr4-dispatch (JSM dispatch fork). Key lessons from those deliveries:

- **From issue-288-pr4-dispatch**: The BC-3.8.011 suite (forward-direction warnings) at
  `tests/issue_create_jsm.rs` lines 1587–1865 is the direct structural template. The test
  pattern is: mount a wiremock stub for `POST /rest/api/3/issue` or `/rest/servicedeskapi/request`,
  run the binary with the relevant flags, assert `status.success()`, assert `stderr().contains(verbatim_warning)`,
  assert that the warning string does NOT appear in stdout.

- **Verbatim string discipline**: Issue #288 pr4 showed that deviating even one character from
  the BC-specified warning string causes adversarial failures. Copy the strings byte-for-byte
  from BC-3.8.012 and BC-3.8.013 bodies — do not paraphrase.

- **From S-382**: Small stories with a clear insertion point still need `cargo clippy -- -D warnings`
  after the edit, because rustc infers types from flag locals that may produce `dead_code` or
  `unused_variable` warnings if the `if` guard references a field that was previously unused.

- **Platform-path test setup**: The AC-4 negative test and AC-6 regression test require that the
  platform POST stub returns a valid response (e.g., `{"id":"10001","key":"FOO-123","self":"..."}`).
  Use the same fixture pattern as `test_jsm_create_without_request_type_uses_platform_path`.

## Architecture Compliance Rules

- Insertion point is BEFORE the `let project_key = ...` binding and AFTER the JSM dispatch `return`.
  This ensures the guards run only on the platform branch (BC-3.3.001 preserved; JSM path is
  already returned before the guards execute).
- No new module, type, trait, or dependency changes. Pure addition of 2 `if` guards.
- `eprintln!` is the correct output channel (stderr). Do NOT use `println!` or the tracing macros
  for this warning — it must mirror BC-3.8.010/011's `eprintln!` pattern.
- Do NOT gate the warning on `--output json` or `--no-input` mode. The BC bodies specify: "The
  warning fires regardless of `--no-input` or `--output json` settings."
- `fields` local is a `Vec<String>` (clap collect); use `.is_empty()` check, not `len() > 0`.
- `on_behalf_of` local is `Option<String>` (clap optional); use `.is_some()` check.
- No `#[allow]` suppressions. If clippy warns about an unused variable in a test, refactor the test.

## Library & Framework Requirements

- No new dependencies. `eprintln!` is stdlib.
- wiremock in `tests/issue_create_jsm.rs` is already a dev-dependency — use the same version
  and import pattern as the existing BC-3.8.011 tests.
- `assert_cmd` + `predicates` are already present in `tests/` — use them for test assertions.

## File Structure Requirements

| File | Action | Notes |
|------|--------|-------|
| `src/cli/issue/create.rs` | Modify | 2 `if` guard blocks, ~10 LOC net addition |
| `tests/issue_create_jsm.rs` | Modify | Append 7 new test functions, ~120–160 LOC net addition |
| `.factory/stories/STORY-INDEX.md` | Modify | Append S-383 row to Story Manifest + Feature Followup table |
| `.factory/sprint-state.yaml` | Modify | Append S-383 entry under cycle_3_feature_288 or new feature_followup block |

## Branch / PR Plan

- Branch: `feat/issue-383-platform-inverse-warnings`
- Target: `develop`
- Commit style: `feat(create): emit stderr warnings for --field/--on-behalf-of without --request-type (#383)`
- PR closes #383
- No CHANGELOG bump required for warning-only change (internal UX, not a contract change for
  existing callers — warnings go to stderr, not stdout).

## Per-Story Delivery Notes

- Demos (Step 5) are LOCAL-ONLY per `docs/demo-evidence/` gitignore convention.
- Per-story adversary 3/3 CLEAN required before push.
- F2 is CONVERGED (9 passes + final confirmation) — BC files are sealed. Do NOT re-edit
  `bc-3-issue-write.md` unless the adversary finds a discrepancy between the BC body and
  the implementation. If a discrepancy is found, escalate to orchestrator rather than self-amending.
- The test file decision (keep in `issue_create_jsm.rs`) is documented above. Adversary must
  confirm this decision is recorded in a comment at the top of the new test block.
