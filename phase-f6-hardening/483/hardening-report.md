# F6 Targeted Hardening Report — Issue #483 (GFM alerts → ADF panel)

**Cycle:** feat/adf-gfm-alerts-panel · **PR:** #487 · **Date:** 2026-06-09
**Scope:** the `src/adf.rs` delta (GFM-alerts→panel + content-model normalization
+ reverse render).

---

## 1. Mutation Testing — adf.rs is OUT of mutation scope by policy

Per `docs/specs/cargo-mutants-policy.md` and `.cargo/mutants.toml`, mutation
testing is deliberately scoped (`examine_globs`) to the bulk / create / JSM
modules where weak-assertion risk was identified:

```
src/api/jira/bulk.rs, src/types/jira/bulk.rs, src/cli/issue/create.rs,
src/api/jsm/requests.rs, src/api/jsm/request_types.rs, src/cli/requesttype.rs
```

`src/adf.rs` is **not** in scope. Consequently:

- The **CI mutation job** (`cargo mutants --in-diff <PR diff>`, which honors the
  config scope) generates **no mutants for the #483 diff** — verified locally:
  `cargo mutants --in-diff <diff>` → `INFO No mutants to filter`. The CI
  Mutation-testing check therefore passes trivially for this PR.
- A **supplementary out-of-scope targeted pass** (`cargo mutants --in-diff <diff>
  -f src/adf.rs`) was initiated as extra diligence (mirroring #474), but
  cargo-mutants runs the full integration test suite per mutant and this repo's
  suite is slow (~15 min baseline alone), making a complete adf pass
  impractical-to-prohibitive in this cycle. It was stopped after baseline.
  **Not a gate failure** — adf.rs mutation is non-required by policy.

**Mutation verdict:** N/A by policy (adf.rs excluded). Kill-rate confidence for
this delta rests instead on the unit-test assertion strength below.

### Compensating assertion strength (why this is safe)
The 18 new unit tests assert **output shape**, not call structure, and several
are strong against the exact mutations cargo-mutants would generate here:
- `panel_type_for` / `gfm_label_for_panel_type` arms: each of the 5 kinds and
  each reverse label is asserted by a distinct test, so a swapped/replaced match
  arm would be caught (forward ×5 tests, reverse round-trip ×5, plus unknown/tip
  fallbacks).
- `normalize_panel_content` recursion: `test_panel_content_only_permitted_node_types`
  is a transitive invariant scan over `[panel, table, blockquote]` on a combined
  nested-alert + nested-table fixture — a mutation that skipped any unwrap/flatten
  branch would surface a forbidden node and fail.
- Empty-prune branch: `test_markdown_empty_alert_pruned` positively asserts no
  panel node survives (a mutation that kept the panel would fail).
- Reverse line-prefixing: `test_render_panel_multiline_body_quotes_every_line`
  asserts per-line `> ` (a mutation dropping the prefix loop would fail).

---

## 2. Full Regression (`cargo test`, entire tree, all targets)

- **Lib:** 818 passed, 0 failed, 10 ignored (adf module: 132 passed, 18 new).
- **Integration (`--test '*'`):** all binaries pass, 0 failed.
- No regressions introduced; the change is additive (only the new
  `BlockQuote(Some(kind))` event takes the new path).

**Verdict:** PASS.

---

## 3. Lint / Format Gate

- `cargo clippy --all-targets -- -D warnings` → clean (no warnings, no `#[allow]`).
- `cargo fmt --all -- --check` → clean.

**Verdict:** PASS.

---

## 4. Supply-Chain / Security (`cargo deny check`, full tree)

- `advisories ok, bans ok, licenses ok, sources ok`.
- One pre-existing benign warning (`license-not-encountered` for the
  `Unicode-DFS-2016` allowance in `deny.toml`) — unrelated to #483, no new
  dependencies added by this change (pulldown-cmark already a dependency;
  `ENABLE_GFM` is a runtime bitflag, not a new crate/feature).

**Verdict:** PASS.

---

## 5. Property-Test Assessment

No new proptest added. The round-trip property (markdown alert → ADF → text →
alert marker) is covered by the table-driven `test_alert_markdown_to_text_roundtrip_all_kinds`
over all five kinds. A full proptest generator for arbitrary alert bodies was
considered unnecessary: the normalization paths (nested/table/marks) are
deterministic transforms already pinned by targeted tests + the invariant scan,
and the parser-leniency surface is upstream (pulldown-cmark) and pinned by
explicit cases. Documented as acceptable, consistent with prior ADF cycles.

---

## Overall F6 Verdict

| Gate | Result |
|------|--------|
| Mutation (in-scope CI) | PASS (no #483 mutants — adf.rs out of scope by policy) |
| Mutation (adf targeted) | N/A (non-required; impractical full-suite-per-mutant) |
| Full regression | PASS (lib 818/0, integration 0 failed) |
| Lint / format | PASS |
| Supply-chain (`cargo deny`) | PASS |
| Property-test assessment | PASS (round-trip covered) |

### **VERDICT: F6 PASS**

Coverage of the #483 delta is sound: 18 strong output-shape assertions + a
transitive forbidden-node invariant scan + clean full regression/lint/deny.
Mutation testing is appropriately governed by the existing policy (adf.rs
excluded); no new gap is introduced.
