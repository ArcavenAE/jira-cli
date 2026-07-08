---
phase: f6-targeted-hardening
dimension: mutation-testing
bundle: ADF-CODE-MARK-EXCLUSIVITY
head_sha: d7875e6
pre_bundle_base: 0d8a8a5
tool: cargo-mutants (in-diff scope)
diff_file: /tmp/f6.diff (git diff 0d8a8a5..d7875e6 -- src/)
kill_rate: 100% (1/1)
target_threshold: 90%
date: 2026-07-08
verdict: PASS
---

# F6 Dimension 3 — Mutation Testing (scoped to bundle diff)

## Command

```
git diff 0d8a8a5..d7875e6 -- src/ > /tmp/f6.diff
cargo mutants --in-diff /tmp/f6.diff --jobs 4 --timeout 240
```

Scope binding: policy source is `docs/specs/cargo-mutants-policy.md`; scope
is further narrowed to the exact bundle diff via `--in-diff`.

## Result (verbatim)

```
Found 1 mutant to test
ok       Unmutated baseline in 67s build + 82s test
1 mutant tested in 3m: 1 caught
```

## Per-mutant outcomes

| Mutant | Location | Replacement | Outcome |
|--------|----------|-------------|---------|
| `src/adf.rs:1282:9: replace AdfBuilder::push_code with ()` | `push_code` function body (lines 1261–1324) | Function body replaced with `()` (no-op) | **CAUGHT** (test exit 101, 4.2 s) |

Source (`mutants.out/outcomes.json`):

- Baseline: build 68 s / test 83 s → Success
- Mutant `src/adf.rs:1282:9`: build 27 s / test 4.2 s → Failure 101
  (**caught**)
- `missed.txt`: empty
- `timeout.txt`: empty
- `unviable.txt`: empty

## Kill rate

**1 / 1 = 100.0%** — exceeds the 90% MEDIUM-criticality threshold and the
95% CRITICAL-criticality threshold. `src/adf.rs` is classified HIGH in
module-criticality; the 90% target applies. **PASS.**

## Interpretation

`--in-diff` generated exactly one mutant — the coarse-grained "replace
function body with `()`" mutant on the modified `push_code` function.
The mutant was killed within 4.2 s by the test suite, meaning at least
one of the following anchors observed the deletion of the entire filter
logic:

- The 9 EC anchors + control + PANEL-ANCHOR in `src/adf.rs::tests`
  (VP-571-002) — any of the strong/em/strike/subsup stripping anchors
  fails immediately when the whole `push_code` body is elided.
- The rewritten `test_markdown_inline_code_mark_and_composition` anchor
  (asserts `marks == [code]`).
- The proptest `prop_bc_7_2_015_no_code_marked_text_node_carries_typographic_marks` (VP-571-001).
- The 4 integration tests in `tests/adf_code_mark_exclusivity.rs` and
  the Call E test in `tests/issue_create_jsm.rs` (VP-571-005).

Sibling anchors (mark-order agnosticism, node-scoped stripping,
reverse-path read-tolerance) provide defense-in-depth against finer-grained
mutants (allowlist-set membership swaps, in-place mutation of
`self.active_marks`, etc.) that would appear if cargo-mutants were run at
a finer granularity in a future maintenance sweep. All such classes are
covered by test anchors that would kill them, per the F2 mutation-testing
note in `verification-delta-571.md`.

## Verdict

**PASS** — 100% kill rate (1/1), no missed / timeout / unviable mutants,
clean exceedance of the 90% policy threshold.
