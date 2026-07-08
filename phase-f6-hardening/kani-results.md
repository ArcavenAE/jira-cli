---
phase: f6-targeted-hardening
dimension: formal-proofs-kani
bundle: ADF-CODE-MARK-EXCLUSIVITY
head_sha: d7875e6
pre_bundle_base: 0d8a8a5
tool: proptest (Kani substitute — see justification)
date: 2026-07-08
verdict: PASS
---

# F6 Dimension 1 — Formal Verification (Kani substitute: proptest)

## Toolchain substitution justification

This project has **never introduced Kani** for `src/adf.rs` or any other
module. The F2 verification delta explicitly names the substitute:

> "Verification toolchain in scope for this cycle: proptest + example-based
> unit tests inside `src/adf.rs::tests` + `cargo-mutants`. This project has
> never used Kani or any other formal-methods toolchain for `adf.rs` — no
> new toolchain is introduced." —
> `.factory/phase-f2-spec-evolution/verification-delta-571.md`

Precedent for the same substitution decision was established in every prior
F6 cycle on this repo (issue-407 / issue-483 / issue-474 /
S-FORK-OPS-BACKFILL). The substitute pins the BC-7.2.015 universal
invariant with property-based tests at elevated case counts, plus
deterministic EC anchors, plus mutation testing. No new toolchain
provisioning is executed by this F6.

## Elevated proptest run (VP-571-001 primary property)

Command:

```
PROPTEST_CASES=2000 cargo test --lib \
  prop_bc_7_2_015_no_code_marked_text_node_carries_typographic_marks -- --nocapture
```

Result (verbatim tail):

```
test adf::tests::prop_bc_7_2_015_no_code_marked_text_node_carries_typographic_marks ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 1002 filtered out; finished in 1.17s
```

At `PROPTEST_CASES=2000` the harness exercised the VP-571-001 generator
2,000 times (~10× the ~256-case default budget stipulated by VP-571-001).
No counterexample was produced; the property held across all generated
inputs.

The generator (`gen_mark_composition_markdown`) is authored per VP-571-001
scope — 9 container wrappers (none / blockquote / bullet list / ordered
list / GFM task list / GFM alert (outermost-only) / heading / GFM table
cell / footnote-definition body) × inline templates (plain code /
strong+code / em+code / strike+code / subsup sup+code / subsup sub+code /
link+code / mixed-range shapes / nested combinations), wrapper-nesting
budget ≤ 3.

The property invariant — `assert_code_mark_exclusivity` (free fn,
`src/adf.rs::tests`) — recursively descends every ADF container `content`
array and asserts that no `text` node carrying `{"type":"code"}` in its
`marks` also carries any mark outside `{"code","link","annotation"}`.
This is the BC-7.2.015 positive invariant expressed as a universal
quantifier over emitted ADF.

## Per-VP coverage assessment

| VP | Property / anchor | Coverage strength | Notes |
|----|-------------------|-------------------|-------|
| **VP-571-001** (proptest universal invariant) | `prop_bc_7_2_015_no_code_marked_text_node_carries_typographic_marks` | **Proof-strength (property-based)** | 2,000 cases at F6 (~10× default). All 9 container wrappers × all inline templates × ≤3 wrapper-nesting depth. Held. |
| **VP-571-002** (EC anchors — deterministic regressions) | `test_bc_7_2_015_{plain_code_baseline, strong_stripped_from_code_node, em_stripped_from_code_node, strike_stripped_from_code_node, subsup_stripped_from_code_node, link_preserved_on_code_node, mixed_range_surrounding_marks_retained, multi_mark_wrapper_only_code_node_stripped, alert_wrapper_strong_code_stripped}` + rewritten `test_markdown_inline_code_mark_and_composition` | Deterministic — 8 EC anchors + control + PANEL-ANCHOR + rewritten legacy anchor, all GREEN post-fix | Empirical Red-Gate pre-fix evidence captured during F4 (per S-ADF-CODE-MARK-1 delivery log, PR #593) |
| **VP-571-003** (node-scoped stripping — surrounding text retains marks) | `test_bc_7_2_015_mixed_range_surrounding_marks_retained` + `test_bc_7_2_015_multi_mark_wrapper_only_code_node_stripped` | Deterministic + covered under VP-571-001 mixed-range templates | Mutation-catcher for a "filter `self.active_marks` in-place" refactor mistake |
| **VP-571-004** (reverse-path read-tolerance retained) | `test_render_marks_code_and_strong` + `test_render_strong_with_code_applies_code_innermost` | MUST-STAY-GREEN existing reverse-path tests | Both GREEN in F6 regression (2007/0/93); write-strict/read-lenient asymmetry preserved |
| **VP-571-005** (JSM path parity) | `tests/adf_code_mark_exclusivity.rs` (Calls A–D, platform path) + `tests/issue_create_jsm.rs` Call E (JSM path) with `.expect(1)` on `POST /rest/servicedeskapi/request` and `.expect(0)` dispatch-fork regression guard on `POST /rest/api/3/issue` | Integration-strength (wiremock) | H-NEW-ADF-010 Calls A–E — enforced end-to-end via wiremock POST body assertions |

Every VP-571-* is covered by at least one proof-strength (proptest) or
integration-strength (wiremock) artifact. No VP is deferred, silently
omitted, or verified only through inspection.

## Kani applicability audit

Kani (bounded model checking via CBMC) is not applicable to the delta:

- The `push_code` allowlist filter is a **serde_json-driven set operation**
  over a `Vec<serde_json::Value>` mark list. Kani cannot bound-check
  unbounded `serde_json::Value` structural recursion tractably; the input
  space is the markdown-string × pulldown-cmark event sequence, which is
  state-space-wise identical to a fuzz target and better addressed by
  proptest.
- The universal invariant (BC-7.2.015 mark-set exclusivity) is a
  **structural predicate on emitted ADF**, not an arithmetic /
  pointer-safety property. Kani's strengths (integer overflow, bounds,
  pointer safety) do not apply here.
- `MAX_ADF_DEPTH = 256` guard (BC-7.2.012, SEC-001) prevents unbounded
  recursion in the emitter and reverse path; that depth guard is already
  regression-pinned by `tests/adf_recursion_depth.rs` + inline unit tests
  in `src/adf.rs::tests` (`test_max_adf_depth_constant_is_256`,
  `test_markdown_to_adf_depth_256_blockquote_is_err`,
  `test_adf_to_text_depth_256_is_err`).

## Verdict

**PASS** — VP-571-001 universal-quantifier property held at 10× the
default proptest budget. All five VPs covered by proof-strength or
integration-strength artifacts. No missing formal-verification
obligation.
