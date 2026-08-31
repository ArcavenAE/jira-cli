---
document_type: red-gate-log
level: ops
version: "1.0"
status: complete
producer: state-manager
timestamp: 2026-08-30T00:00:00Z
phase: F4
inputs: []
input-hash: "[live-state]"
traces_to: ""
stub_architect_agent: "[stub-architect, S-578-4-stubs]"
stub_compile_verified: true
test_writer_agent: "[test-writer, S-578-4-red-gate]"
red_gate_verified: true
story: S-578-4
cycle: cycle-002
feature_mode_bundle: field-dx
feature_branch: feature/S-578-4-create-field-support
develop_base_sha: 41763ff0
---

# Red Gate Log: S-578-4 (`issue create --field` platform-path createmeta resolution + DEC-188 reversal)

## Summary

| Story | Tests Written | All Fail (Red)? | Gate |
|-------|----------------|------------------|------|
| S-578-4 (`issue create --field` platform-path createmeta resolution + DEC-188 reversal (DEC-310), 13pts, 19 ACs) | New `tests/issue_create_field.rs` (2207 lines) + inverted `tests/issue_create_jsm.rs` (461 lines changed) | 23/23 FAIL in `issue_create_field.rs` + 10/10 FAIL in `issue_create_jsm.rs` on real assertion mismatches, 0 build errors, 0 panics; 30 legitimately PASS in `issue_create_field.rs` and 97 legitimately PASS in `issue_create_jsm.rs` | **VERIFIED** |

## Stubs Created

### S-578-4: `issue create --field` platform-path createmeta resolution + DEC-188 reversal (DEC-310)

Stub commit (`c479220a`): `cargo check --all-targets` CLEAN (zero errors).
`detect_flag_field_overlap` and the `resolve_edit_fields::Create` arm were
confirmed genuine `todo!()` stubs (no smuggled logic). The DEC-188
`--field`-without-`--request-type` pre-flight guard was removed per the
DEC-310 reversal; the BC-3.8.013 `--on-behalf-of`-without-`--request-type`
guard was preserved unchanged.

- `fn detect_flag_field_overlap(...) -> ...` -- `todo!()` stub (D2
  collision detection between `--field` hint pairs and legacy flag-based
  fields on the platform `issue create` path)
- `resolve_edit_fields` `Create` arm -- `todo!()` stub (createmeta-backed
  field resolution for the platform `issue create --field` path, mirroring
  the existing edit-path resolver)
- DEC-188 `--field`-without-`--request-type` exit-64 guard -- **removed**
  (DEC-310 reversal). BC-3.8.013 `--on-behalf-of`-without-`--request-type`
  guard -- **preserved**, unchanged.

**Compile verification:** `cargo check --all-targets` clean, zero errors.

## Red Gate Verification

### S-578-4

Test-writer commit (`8b379e68`) added `tests/issue_create_field.rs`
(2207 lines, new file) covering the 19 originally-scoped acceptance
criteria for platform-path `--field` createmeta resolution, and inverted
the DEC-188-era assertions in `tests/issue_create_jsm.rs` (461 lines
changed) to assert the post-reversal (DEC-310) behavior. Zero `src/`
changes in the test commit (`git diff --stat c479220a HEAD -- src/` is
empty).

- `tests/issue_create_field.rs`: **23 FAIL** (expected; real assertion
  mismatches against the behavior under test -- e.g.
  `test_bc_3_8_012_field_alone_no_longer_exits_64`: "AC-002 / VP-578-017:
  expected exit 0; got Some(101)", because the `todo!()` D2
  collision-detection stub panics rather than resolving) / **30 pass**
  (4 legitimate pre-existing BC-3.8.013 `--on-behalf-of` guard regression
  pins, unaffected by the DEC-188 reversal, + 26 unrelated `common::wf`
  tests pulled in via `mod common;`).
- `tests/issue_create_jsm.rs`: **10 FAIL** (expected; the 10 tests
  inverted from their DEC-188-era form now assert the DEC-310
  post-reversal behavior, which the `todo!()` stub does not yet provide)
  / **97 pass** (pre-existing JSM dispatch-fork tests, including
  AC-2/6/16/20/21, unaffected by the platform-path change).
- Both test binaries compile cleanly. Every failure is assertion-based
  against the intended new behavior, never a bare build error, and every
  panic traces to a known, expected `todo!()` collision point (not an
  unexpected panic elsewhere).

## Regression Check

| Existing Tests | Status |
|---------------|--------|
| `tests/issue_create_field.rs` (new suite) at Red Gate | 23/23 red (expected) |
| `tests/issue_create_field.rs` pre-existing-in-file baseline (BC-3.8.013 pins + `common::wf`) | 30/30 pass, 0 regressions |
| `tests/issue_create_jsm.rs` inverted DEC-188-era tests | 10/10 red (expected) |
| `tests/issue_create_jsm.rs` pre-existing baseline | 97/97 pass, 0 regressions |
| `cargo check --all-targets` | clean, 0 errors |

## Hand-Off to Implementer

- Stories ready for implementation: S-578-4.
- Implementation guidance: implement `detect_flag_field_overlap`'s D2
  collision-detection logic and the `resolve_edit_fields` `Create` arm's
  createmeta-backed field resolution for the platform `issue create
  --field` path; drive all 23 new `tests/issue_create_field.rs` assertions
  and all 10 inverted `tests/issue_create_jsm.rs` assertions green across
  the 19 scoped ACs; preserve the BC-3.8.013 `--on-behalf-of` guard
  byte-for-byte (do not touch its call site or message strings).
- Stub commit: `c479220a`. Test commit: `8b379e68`.
- Feature branch: `feature/S-578-4-create-field-support`, base `develop`
  @ `41763ff0`.
- Story size: 13 pts, 19 ACs.
