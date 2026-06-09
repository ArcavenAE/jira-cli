# F6 Targeted Hardening Report — Issue #474 (Markdown subsup + heading-attribute → ADF)

- **Phase:** VSDD Feature Mode F6 (Targeted Hardening)
- **Scope:** DELTA = uncommitted working-tree changes to `src/adf.rs` (issue #474). Regression + security on the FULL tree.
- **Date:** 2026-06-09
- **Delta:** `git diff src/adf.rs` = +378/-4 lines. New behavioral code: `markdown_to_adf` Options additions (`ENABLE_SUPERSCRIPT|SUBSCRIPT|HEADING_ATTRIBUTES`), `Tag::Superscript`/`Tag::Subscript` start arms, `dedup_marks_by_type` (free fn), `apply_marks` `subsup` reverse arm, dedup calls in `push_text`/`push_code`. 13 new inline tests (105 → 106 adf lib tests incl. proptest).
- **Constraint honored:** No `src/` modifications made by this phase. Gaps are reported for orchestrator routing to test-writer.

---

## 1. Mutation Testing (scoped to the #474 adf delta)

Command (adf.rs is NOT in `.cargo/mutants.toml::examine_globs`, so explicitly targeted; `--in-diff` narrows to #474-changed lines; `-- --lib` scopes the per-mutant test run to inline lib tests, which contain all 106 adf tests):

```
cargo mutants -f src/adf.rs --in-diff /tmp/m474.diff -j4 --timeout 120 -- --lib
```

### Results

| Metric  | Count |
|---------|-------|
| Total mutants | 24 |
| Caught  | 19 |
| **Missed (surviving)** | **5** |
| Timeout | 0 |
| Unviable | 0 |
| Raw kill rate | 19/24 = **79.2%** |
| **Effective kill rate (excluding equivalent mutants)** | **19/19 = 100%** |

### Surviving mutants (all 5)

All five survivors are the identical mutation class — `replace | with ^` on the `Options::ENABLE_*` bitflag union in `markdown_to_adf`:

| Location | Mutation |
|----------|----------|
| `src/adf.rs:23:9` | replace `\|` with `^` (ENABLE_STRIKETHROUGH join) |
| `src/adf.rs:24:9` | replace `\|` with `^` (ENABLE_FOOTNOTES join) |
| `src/adf.rs:27:9` | replace `\|` with `^` (ENABLE_SUPERSCRIPT join) |
| `src/adf.rs:28:9` | replace `\|` with `^` (ENABLE_SUBSCRIPT join) |
| `src/adf.rs:31:9` | replace `\|` with `^` (ENABLE_HEADING_ATTRIBUTES join) |

### Why they survive — PROVABLY EQUIVALENT MUTANTS (not a test gap)

`pulldown_cmark::Options` is a `bitflags` type. The relevant flags are distinct, non-overlapping single bits (verified from the pulldown-cmark source):

```
ENABLE_TABLES            = 1 << 1
ENABLE_FOOTNOTES         = 1 << 2
ENABLE_STRIKETHROUGH     = 1 << 3
ENABLE_HEADING_ATTRIBUTES= 1 << 6
ENABLE_SUPERSCRIPT       = 1 << 13
ENABLE_SUBSCRIPT         = 1 << 14
```

For a set of values with **no shared bits**, `a | b` and `a ^ b` produce byte-identical results (XOR only differs from OR where bits overlap; none do here). Empirically confirmed with a standalone Rust program: the OR-chain and the XOR-chain (and every partial swap) yield identical flag sets. Therefore swapping any `|` → `^` produces an `Options` value **identical at runtime** to the original — no test can ever observe a difference. This is the textbook *equivalent mutant* problem, which the cargo-mutants policy (`docs/specs/cargo-mutants-policy.md` §Whitelist Convention) explicitly recognizes as legitimately unkillable.

**Corroborating fingerprint:** the SAME five lines also receive a `replace | with &` mutation — and all five of those ARE caught (lines 23/24/27/28/31 appear in `caught.txt`). `&` zeroes out flags (a real behavior change → tests fail). Only the behaviorally-inert `^` variant survives. A genuine assertion gap would let BOTH the `&` and `^` variants survive; here only the equivalent one does. This is conclusive evidence the survivors are equivalent, not under-tested.

### Behavioral coverage of the caught 19 (assertion strength is strong)

Every behaviorally-meaningful mutant in the new code is killed:
- `dedup_marks_by_type`: body→`vec![]`, body→`vec![Default::default()]`, and `delete !` on the `!seen.contains(&ty)` dedup guard — all CAUGHT.
- `apply_marks` subsup reverse arm: `delete match arm "subsup"` and `replace == with !=` (the sub/sup discriminator at `:966`) — CAUGHT.
- `Tag::Superscript` / `Tag::Subscript` start arms: arm deletion — CAUGHT.
- `push_text` / `push_code`: body→`()` and `delete !` — CAUGHT.
- `markdown_to_adf` body→`Default::default()` — CAUGHT.

### Verdict (Task 1)

**No behavioral test gap.** The 5 survivors are mathematically equivalent mutants and are unkillable by any test. Effective kill rate on killable mutants = **100%**, comfortably above the 90% policy threshold.

**Reported follow-up (do NOT implement here — routes to test-writer):** Per `docs/specs/cargo-mutants-policy.md` §Whitelist Convention, the canonical way to make the metric self-documenting is a single annotation on `markdown_to_adf`:

```rust
// mutants::skip: Options is a bitflags type with distinct single-bit flags;
// `|` vs `^` are equivalent (no overlapping bits) so the `^` mutants are unkillable.
#[mutants::skip]
pub fn markdown_to_adf(markdown: &str) -> Value { ... }
```

This is OPTIONAL for F6 pass (adf.rs is outside the CI `examine_globs`, so these mutants are never scored by CI). It only matters if adf.rs is later added to the mutants scope. Recommendation: defer unless the orchestrator wants the annotation now for documentation. If added, it must carry the justification comment (bare `#[mutants::skip]` is policy-forbidden).

---

## 2. Full Regression (`cargo test`, entire tree, all targets)

```
cargo test
```

**Result: GREEN.** Every target reports `test result: ok` with `0 failed`. Lib lead line:

```
test result: ok. 796 passed; 0 failed; 10 ignored; 0 measured; 0 filtered out
```

All integration/snapshot/proptest targets also `ok; 0 failed` (76 result lines, every one `ok`). The 106 adf lib tests (13 new for #474) pass.

**Verdict: PASS.**

---

## 3. Lint / Format Gate

```
cargo clippy --all-targets -- -D warnings   → exit 0 (no warnings)
cargo fmt --all -- --check                  → exit 0 (no diffs)
```

**Verdict: PASS.**

---

## 4. Supply-Chain / Security (`cargo deny check`, full tree)

```
cargo deny check  → advisories ok, bans ok, licenses ok, sources ok  (exit 0)
```

Only output beyond the OK summary: three pre-existing `license-not-encountered` *warnings* for unmatched allowances in `deny.toml` (`BSD-2-Clause`, `OpenSSL`, `Unicode-DFS-2016`). These are dormant allow-list entries unrelated to #474 and predate this change. **No advisories. No new advisories.** As predicted, the #474 change adds zero dependencies — confirmed: the dependency graph is unchanged (subsup/heading-attrs use pulldown-cmark Options flags already vendored; no new crate).

**Verdict: PASS (no delta).**

---

## 5. Property-Test Assessment (subsup round-trip)

The adf functions are pure and total (`markdown → ADF → text`), making them ideal proptest candidates in principle. Assessment of a round-trip property such as:

> for arbitrary "safe" text `s` (no `^`, `~`, `*`, backtick, brackets, newlines), `adf_to_text(markdown_to_adf(format!("^{s}^"))) == format!("^{s}^")` (and the `~{s}~` sub case).

**Recommendation: OPTIONAL — low marginal value; do NOT block F6 on it.**

Rationale:
- The 13 example tests already pin both directions including the load-bearing asymmetries: forward (`^x^`→sup, `~x~`→sub), reverse (`apply_marks` subsup arm), full round-trip (`test_subsup_markdown_to_text_roundtrip`), composition with `strong`, strike/sub/sup coexistence, nested-dedup first-wins, double-tilde-stays-strike, intra-word literal, and no-mark-leak-to-trailing-text. Mutation testing already proves these assertions are strong (100% effective kill rate on the subsup logic).
- A generic proptest over "safe" text mostly re-exercises the pass-through `push_text` path; the interesting behavior lives at the metacharacter boundaries (which pulldown's tokenizer handles, not this code) and is already example-pinned. The corpus that would actually stress new code (adjacent/nested marks, metacharacter collisions) is hard to express as a free generator and is exactly what the targeted examples cover.
- Marginal defect-detection gain over the existing examples + mutation coverage is small.

If a proptest is desired later for defense-in-depth, the highest-value shape is the **composition** property (random subset of `{strong, em, strike}` wrapped around `^x^`/`~x~`, asserting the subsup mark survives a markdown→ADF→text→ADF round-trip and never duplicates), since that targets `dedup_marks_by_type`'s invariant directly. Note this would be authored by test-writer, not in F6.

---

## Overall F6 Verdict

| Gate | Result |
|------|--------|
| Mutation (delta) | 19/24 caught; 5 survivors all PROVABLY EQUIVALENT (`\|`→`^` on distinct-bit flags); effective kill rate 100% |
| Full regression | PASS (796 lib + all integration targets, 0 failed) |
| clippy `-D warnings` | PASS (exit 0) |
| fmt `--check` | PASS (exit 0) |
| cargo deny | PASS (no advisories, no dep delta) |
| Proptest assessment | Complete — recommend OPTIONAL only |

### **VERDICT: F6 PASS**

The 5 surviving mutants are equivalent mutants (mathematically unkillable), not weak/tautological tests — the same lines' killable `&` variants are all caught, proving assertion strength. No behavioral gap exists. No `src/` changes were required or made. The only follow-up is an OPTIONAL documentation-only `#[mutants::skip]` annotation on `markdown_to_adf` (routes to test-writer if the orchestrator wants the metric self-documenting; not required since adf.rs is outside the CI mutants scope).
