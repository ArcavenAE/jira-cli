---
phase: f6-targeted-hardening
dimension: fuzz-testing
bundle: ADF-CODE-MARK-EXCLUSIVITY
head_sha: d7875e6
pre_bundle_base: 0d8a8a5
tool: none (justified skip — precedent) + proptest as high-case-count substitute
date: 2026-07-08
verdict: PASS (justified skip)
---

# F6 Dimension 2 — Fuzz Testing

## No cargo-fuzz setup exists in this repo

```
$ ls fuzz/ 2>/dev/null || echo "no fuzz dir"
no fuzz dir
```

There is no `fuzz/` directory, no `cargo fuzz` target, and no cargo-fuzz
setup anywhere in the repo. This matches the established precedent for
every prior F6 cycle on this project (issue-407, issue-483, issue-474,
S-FORK-OPS-BACKFILL) — the project uses proptest at elevated case counts
as its substitute for fuzz testing on the ADF parser, and this F6 follows
suit rather than introducing a new toolchain mid-cycle.

## Substitute — proptest at elevated case count on `markdown_to_adf`

The VP-571-001 property (BC-7.2.015 universal invariant) is itself a
fuzz-equivalent harness against `markdown_to_adf`:

- **Target function under exercise**: `markdown_to_adf`, the parser
  entrypoint for markdown → ADF. Same target a cargo-fuzz target would
  attack.
- **Input space**: markdown strings composed from a 9-wrapper × N-inline-template product with wrapper depth ≤ 3. Covers the same inputs a
  structured fuzzer would generate — arbitrary shapes of typographic
  wrapping around inline-code events, nested list / blockquote / panel /
  table / footnote-definition containers.
- **Assertion**: universal invariant on emitted ADF (BC-7.2.015). A
  parse crash, panic, or invariant violation would surface as a test
  failure.

Command (per Dimension 1):

```
PROPTEST_CASES=2000 cargo test --lib \
  prop_bc_7_2_015_no_code_marked_text_node_carries_typographic_marks
```

Result: **1 test, 0 failures, 0 crashes** at 2,000 generator cases
(10× default). Result echoed in `kani-results.md`.

## Existing ADF proptest coverage (broader adf fuzz-equivalent surface)

`src/adf.rs::tests` already carries multiple property tests over
`markdown_to_adf` / `adf_to_text` / `text_to_adf` that exercise the parser
under randomized input during every F6 regression run:

- `prop_bc_7_2_015_no_code_marked_text_node_carries_typographic_marks` (F5 landing) — VP-571-001 primary
- Existing task-list `GenNode` recursive strategy — property tested
  against markdown_to_adf across arbitrary nested-list / task-list shapes
- Existing ADF round-trip / CR-LF-normalization proptests (per
  BC-7.2.011 INV-1 and BC-7.2.012 depth-guard)

All the above ran green in the F6 full-regression pass (2007/0/93).
This constitutes a fuzz-equivalent coverage surface on the same target
symbol.

## No crash / panic surface added by the delta

Reviewed the delta (`git diff 0d8a8a5..d7875e6 -- src/`):

- **New code paths**: allowlist-filter branch inside `push_code`
  (immutable clone + filter + append). Non-recursive, non-branching on
  input, no I/O. Cannot introduce a new panic surface beyond the
  existing `serde_json::Value` clone/append operations, which are
  infallible on the shapes produced upstream.
- **No new unsafe blocks**: `grep -nE '^unsafe |^ *unsafe ' src/adf.rs` →
  0 uses (single hit is inside a comment on `sanitized for cell-unsafe
  characters`). Non-test-code `.unwrap()`/`.expect()` count in
  `src/adf.rs` outside the `#[cfg(test)] mod tests` block is unchanged
  from pre-bundle baseline (4).
- **No new external I/O**: `push_code` remains pure. All effects stay
  behind the `handle_create`/`handle_jsm_create` call sites, which are
  already covered by wiremock integration tests (H-NEW-ADF-010 Calls
  A–E).

## Verdict

**PASS (justified skip)** — no cargo-fuzz setup exists (project precedent);
proptest at `PROPTEST_CASES=2000` on `markdown_to_adf` acts as the
substitute; delta introduces no new panic / I/O surface that a fuzz
target would additionally cover.
