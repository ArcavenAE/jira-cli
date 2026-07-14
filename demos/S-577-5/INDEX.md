# S-577-5 Demo Evidence

Story: `comment edit` visibility flags + public confirmation + e2e probe  
Branch: `feat/comment-visibility`  
Head: `fbf1a1e`  
Test file: `tests/comment_edit.rs` (26 subprocess tests total; 13 from S-577-4, 13 from S-577-5)  
Captured: 2026-07-14

## Full Suite

| File | Command | Result |
|------|---------|--------|
| `full-suite.txt` | `cargo test --test comment_edit` | 26/26 green |

## E2E Gate Evidence

| File | Guards Run | Result |
|------|-----------|--------|
| `e2e-guard-evidence.txt` | `test_every_ignored_test_has_gate_guard` + `test_no_test_function_exceeds_line_budget` + full surface guard (10 tests) | 12/12 green |

The gated e2e test `test_e2e_comment_edit_visibility_merge_semantics` runs in the
nightly `e2e.yml` workflow (DEC-175 restored scenarios). It exercises 3 scenarios
(5-step MERGE probe, PRESERVED base, compound cell). Live run not captured here;
offline gate machinery confirmed passing by the three always-run guards above.

## Per-AC Evidence

AC-010 has two variants (VP-577-028 v1 + v2) in one capture file.
AC-011 (pre-satisfied by S-577-1) and AC-010 (pre-satisfied by S-577-4) are
regression guards — they appear in the test suite unchanged and pass as expected.

| AC | BC Anchor | Demo File | Test Function | Tier | Status | Result |
|----|-----------|-----------|--------------|------|--------|--------|
| AC-001 | BC-3.5.006 / VP-577-002 | `AC-001.txt` | `test_bc_3_5_006_internal_puts_properties_true` | subprocess | new | PASS |
| AC-002 | BC-3.5.006 / VP-577-026 v1 | `AC-002.txt` | `test_bc_3_5_006_changed_fields_jsm_internal_true` | subprocess | new | PASS |
| AC-003 | BC-3.5.007 / VP-577-003 | `AC-003.txt` | `test_bc_3_5_007_public_puts_properties_false` | subprocess | new | PASS |
| AC-004 | BC-3.5.007 / VP-577-026 v2 | `AC-004.txt` | `test_bc_3_5_007_changed_fields_jsm_internal_false` | subprocess | new | PASS |
| AC-005 | BC-3.5.006 / VP-577-025 v1 | `AC-005.txt` | `test_bc_3_5_006_jsdcloud_hint_appears_on_internal` | subprocess | new | PASS |
| AC-006 | BC-3.5.007 / VP-577-025 v2 | `AC-006.txt` | `test_bc_3_5_007_jsdcloud_hint_appears_on_public_yes` | subprocess | new | PASS |
| AC-007 | BC-3.5.008 / VP-577-006 | `AC-007.txt` | `test_bc_3_5_008_public_no_input_without_yes_exits_64` | subprocess | new | PASS |
| AC-008 | BC-3.5.008 / VP-577-029 | `AC-008.txt` | `test_bc_3_5_008_public_interactive_cancel_json_key_set` | subprocess | new | PASS |
| AC-009 | BC-3.5.008 / VP-577-017 | `AC-009.txt` | `test_bc_3_5_008_ec3_stdin_without_yes_public_exits_64` | subprocess | new | PASS |
| AC-010 (v1+v2) | BC-3.5.008 / VP-577-028 | `AC-010.txt` | `test_bc_3_5_008_ec4_yes_without_public_is_silent_noop` + `test_bc_3_5_008_ec4_yes_without_public_runtime_probe_exit64` | subprocess | pre-satisfied (regression guard) | PASS |
| AC-011 | BC-3.5.011 / VP-577-010 | `AC-011.txt` | `test_bc_3_5_011_internal_and_public_clap_exit_2` | subprocess | pre-satisfied (regression guard) | PASS |
| AC-012 | BC-3.5.008 / VP-577-030 v2 | `AC-012.txt` | `test_bc_3_5_008_ec5_public_prompt_eof_exits_130` | subprocess | new | PASS |

**Total: 12/12 ACs captured. 13/13 new test functions green. 26/26 full-suite functions green.**

## Key Implementation Notes

- AC-001/AC-003 are wire-level: `server.received_requests()` parses the PUT body as JSON
  and asserts the exact `properties` array shape. This kills mutants that pass a wrong
  visibility flag value or omit properties entirely.
- AC-002/AC-004 are response-level: `changed_fields.jsm_internal` carries the boolean that
  was actually sent (not inferred from flags). Key-set assertion ensures no extra fields leak.
- AC-005/AC-006 pin JSDCLOUD-6050 hint timing: fires on --internal BEFORE PUT (EC-3.5.006-1),
  fires on --public AFTER confirmation (EC-3.5.007-1). Both substrings ("JSDCLOUD-6050"
  and the human echo marker) must appear in stderr.
- AC-007 dual-pin design (VP-577-006): "visibility to public" + "--yes" both required in
  stderr; non-empty body "body" used to isolate the step-3 --public gate from the step-2
  body-empty guard.
- AC-008 cancelled envelope exact key-set (VP-577-029): {"cancelled":true,"updated":false}
  with exactly 2 keys. "updated" is boolean false — NOT a timestamp or empty string.
- AC-009 two variants: one with plain pipe stdin, one with JR_STDIN_IS_TTY=1. Variant 2
  proves EC-3.5.008-3 fires on the --stdin flag directly, independent of TTY state.
- AC-010 variant 2 uses exit-64-vs-2 discrimination to prove clap requires("public") is
  absent on --yes. The test exercises "" (empty body) + --yes to reach the handler-level
  empty-body guard, which exits 64, not 2. If requires("public") were present, clap
  would reject with exit 2 before reaching the guard.
- AC-012 EOFof from read_line → exit 130. DEC-174 mechanism (eprint! + read_line) is
  unconditional; Ok(0) (EOF) MUST NOT map to cancel path (exit 0); must be Interrupted (130).
- AC-011 (pre-satisfied) uses clap conflicts_with. "cannot be used with" in stderr is
  VP-577-010's discriminator that distinguishes a clap-level exit 2 from a handler exit 2.
