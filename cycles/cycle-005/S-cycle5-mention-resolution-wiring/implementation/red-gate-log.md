---
document_type: red-gate-log
level: ops
version: "1.0"
status: complete
producer: state-manager
timestamp: 2026-09-09T20:09:46Z
phase: 3
inputs: []
input-hash: "[live-state]"
traces_to: ""
stub_architect_agent: "[stub-architect, S-cycle5-mention-resolution-wiring-stubs]"
stub_compile_verified: true
test_writer_agent: "[test-writer, S-cycle5-mention-resolution-wiring-red-gate]"
red_gate_verified: true
story: S-cycle5-mention-resolution-wiring
cycle: cycle-005
wave: 2
feature_branch: feat/cycle5-mention-resolution-wiring
---

# Red Gate Log: cycle-005 Wave 2 -- S-cycle5-mention-resolution-wiring

## Summary
| Story | Tests Written | All Fail (Red)? | Gate |
|-------|-------------|-----------------|------|
| S-cycle5-mention-resolution-wiring | 34 (`tests/mention_resolution.rs`, AC-001..017, AC-020) | 33/34 FAIL (genuine assertion failures); 1/34 legitimately PASSES (pre-existing no-op regression pin, discriminating) | PASSED (correctly red) |

## Stubs Created
### S-cycle5-mention-resolution-wiring: Mention Resolution Wiring
- Commit `6799444c` -- stub commit. `cargo check --all-targets` PASS with only 2 expected `dead_code` warnings, both on the not-yet-wired `todo!()` bodies:
  - `fn resolve_mentions(...) -> ...` -- `todo!()` stub, no call site wires it in yet
  - `fn filter_by_name_match(...) -> ...` -- `todo!()` stub, no call site wires it in yet

## Red Gate Verification
### S-cycle5-mention-resolution-wiring
- Test commits:
  - `50080c63` -- wiremock suite, AC-001..015
  - `63e4aeb1` -- gated E2E + surface guard, AC-017/AC-020
- `tests/mention_resolution.rs` -- 34 test fns total.
  - 33 FAIL with genuine assertion failures: wrong exit codes, missing `mention` ADF nodes / missing `attrs.text`, unmet wiremock `.expect(n)` call-count expectations, POST/PUT body-shape mismatches. None are build errors and none are `todo!()` panics -- confirmed no call site currently invokes `resolve_mentions`/`filter_by_name_match`, so the failures are pre-wiring assertion failures on real (absent) behavior, not stub panics.
  - 1 legitimately PASSES: `test_ec_3_3_012_2_no_mentions_without_markdown_is_silent_noop` -- pre-existing no-op regression pin. The zero-HTTP `--no-mentions` tests fail discriminatingly on body-shape assertions (not tautologically green), confirming the suite is discriminating rather than vacuously satisfied.

## Regression Check
| Existing Tests | Status |
|---------------|--------|
| `tests/duplicate_user_disambiguation.rs` | 31/31 pass, byte-for-byte green (no regression) |

Note: the 26 `common::wf::tests::*` passes observed in the aggregated test binary output are the shared `tests/common/wf.rs` self-tests (CI-gate YAML tooling), unrelated to this story -- not counted toward either the 34 mention-resolution tests or the regression check above.

## Hand-Off to Implementer
- Stories ready for implementation: S-cycle5-mention-resolution-wiring
- Implementation guidance: Red Gate correctly red -- implementation authorized. Implementer dispatched to wire `resolve_mentions`/`filter_by_name_match` call sites so the 33 failing assertions turn green without disturbing the 1 pre-existing pass or the 31/31 `duplicate_user_disambiguation.rs` regression baseline.
