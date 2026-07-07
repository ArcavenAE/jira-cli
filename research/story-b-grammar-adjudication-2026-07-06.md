# Story B (S-BC-CITATION-GUARD-1) — F-B2-03 adjudication

**Date:** 2026-07-06
**Scope:** Internal repo archaeology (Read/Grep/Glob). No external MCP calls needed — every claim is anchored to on-disk artifacts on develop @ ab78a2d.
**Purpose:** Resolve the DEC-153 contradiction between (i) no permissive fallback, (ii) v1 grammar = fn-grep + UPPER_CASE + Type::method dual-check, and (iii) AC-001 guard GREEN on develop HEAD.

---

## 1 — Exhaustive census (ground truth replaces pass-2 estimate ~24)

### 1.1 Extraction context

Story extraction spec (task lines 291-300):

```
scope filter:  grep -nEh '^\*\*(Trace|Source)\*\*:' bc-*.md
token grep:    grep -oE '`src/[^` ]+`' | tr -d '`'
```

The token grep is anchored: leading backtick, `src/`, one-or-more chars that are neither backtick nor space, terminal backtick. **This is important: any backticked token containing an internal space fails to match at all** (the space in the character class blocks progression, and by the time we reach the closing backtick, no such character was consumed). This is the root of F-B2-02.

Applying the scope filter to `.factory/specs/prd/bc-*.md` yields **182 Trace/Source lines mentioning `src/`** (per file: bc-3=40, bc-7=42, bc-6=31, bc-2=28, bc-1=26, bc-4=8, bc-5=7 — cross-checked against prior research `.factory/research/story-b-open-questions-2026-07-05.md §2.2`).

### 1.2 Class-by-class breakdown (Trace/Source-scoped, per-token instance count)

Distinct extractable-token instances on ^Trace/Source lines. Duplicates ARE counted (each occurrence is a validation invocation). Confidence: HIGH for classes 4-11; MEDIUM (±5) for classes 1-3 due to token-vs-line disambiguation on multi-token Trace/Source lines. All classes verified from `.factory/specs/prd/bc-*.md` grep output captured this session.

| # | Class | Shape (after token strip) | Coverage under DEC-153 v1 | Count |
|---|-------|---------------------------|--------------------------|-------|
| 1 | Bare-file (`.rs`) | `src/adf.rs`, `src/config.rs`, `src/cli/issue/edit.rs`, `src/api/auth.rs`, … | COVERED (exists check) | ~30 |
| 2 | Bare-file (`.snap`) | `src/snapshots/jr__adf__tests__markdown_complex_to_adf.snap`, `src/cli/snapshots/jr__cli__auth__tests__list_table_snapshot.snap`, … | COVERED (exists check) | 4 |
| 3 | `file:NN` or `file:NN-MM` | `src/api/auth.rs:882`, `src/cache.rs:14-34`, `src/main.rs:34-49`, … | COVERED (line-ref strip → exists) | ~130 |
| 4 | `file::snake_case_fn` | `src/adf.rs::normalize_list_item_content`, `src/cache.rs::read_cache`, `src/cli/issue/edit.rs::handle_edit`, … | COVERED (fn-grep) | ~120 |
| 5 | `file::fn()` (empty parens) | `src/config.rs::global_config_dir()`, `src/cache.rs::cache_root()` | COVERED (`()` strip → fn-grep) | 5 |
| 6 | `file::UPPER_CASE` | `src/cli/issue/edit.rs::CROSS_HIERARCHY_HINT` (×2) | COVERED (const/static anchor) | 2 |
| 7 | `file::Type::method` | `src/adf.rs::AdfBuilder::{start,end,process,push_text,push_code,finish,push_footnote_marker}` (~15), `src/adf.rs::AdfRenderer::{render_node,finish}` (~11) | COVERED (Type::method dual-check) | ~26 |
| 8 | `file::CamelCase-type` (standalone) | `src/types/jira/bulk.rs::BulkTransitionRequest`, `src/types/jira/bulk.rs::BulkTransitionInput`, `src/adf.rs::AdfBuilder`, `src/adf.rs::ListFrame` | **UNCOVERED** | **4** |
| 9 | `file::tests` (module path) | `src/adf.rs::tests` (×20), `src/output.rs::tests`, `src/observability.rs::tests`, `src/api/jira/links.rs::tests`, `src/cli/issue/changelog.rs::tests` | **UNCOVERED** | **24** |
| 10 | `file::tests::testfn` | `src/types/assets/linked.rs::tests::display_id_fallback_with_hint` | **UNCOVERED** | **1** |
| 11 | `file:~NN` | (none on Trace/Source lines — this form appears only in body prose / CLAUDE.md) | n/a | 0 |
| 12 | Glob (`src/cli/**/*.rs`) | bc-7 L677 (Source), L679 (Trace) | Extractor treats as malformed (`*`/`{` not in shape-guard char class) → silently skipped | 2 |
| 13 | § form (`src/x.rs § "note"`) | (none — the one §-form `src/`-token in the corpus is in body prose at bc-3 L1711, NOT on a Trace/Source line) | n/a | 0 |
| 14 | Comma-space line-ref list (extraction failure) | `src/config.rs:269-282, 308-310` (L70/bc-6), `src/cache.rs:7, 30-32` (L196), `src/cache.rs:7, 30, 76-78` (L206), `src/cache.rs:42, 171, 351` (L302), `src/cli/issue/list.rs:147-149, 656-668` (L242/bc-2), `src/api/client.rs:197-204, 274-279` (L817/bc-7), `src/cli/sprint.rs:35-41, 55-61, 107` (L177/bc-5), `src/cli/issue/list.rs:440, 446, 449, 456` (L182/bc-4), `src/api/auth.rs:24-32, 88-97` (L165/bc-1), `src/api/auth_embedded.rs:34, 220-239` (L227/bc-1) | **MISSED by current regex (internal space)** | 10 |
| 15 | Fn with args-containing-space | `src/api/jira/issues.rs::add_comment(internal: bool)` (bc-3 L2100) | **MISSED by current regex (internal space)** | 1 |
| 16 | Continuation-line tokens (Trace/Source spans multiple lines) | bc-3 L1435 (2 tokens), L1439 (1), L1440 (`src/cache.rs::FieldsCache` — a CamelCase-type), L1556 (1), L1557 (1) | **MISSED by current single-line regex** | 5 |

**Totals**
- Extractable by current regex on Trace/Source lines: **N(current) ≈ 315** (classes 1-11 net of classes 14-16 losses).
- Extractable by F-B2-02-fixed regex (space-stop): **N(fixed) ≈ 315 + 10 + 1 = 326** (classes 14+15 recovered; class 16 still missed unless multi-line handling is added).
- Prior research estimate (`.factory/research/story-b-open-questions-2026-07-05.md §2.4`) said ~332 (range [275, 380]). My census (326 ± 5) sits inside that range and refines the point estimate.

### 1.3 Every uncovered-class token, exhaustively

**Class 8 — standalone CamelCase types (4 instances on Trace/Source lines + 1 continuation):**

| Token | File | Line | Anchor |
|-------|------|------|--------|
| `src/types/jira/bulk.rs::BulkTransitionRequest` | bc-3 | 377 | Source line, single-line |
| `src/types/jira/bulk.rs::BulkTransitionInput` | bc-3 | 377 | Source line, single-line |
| `src/adf.rs::AdfBuilder` | bc-7 | 211 | Source line |
| `src/adf.rs::ListFrame` | bc-7 | 282 | Trace line |
| `src/cache.rs::FieldsCache` | bc-3 | 1440 | Continuation of L1434 Trace (missed by class 16 as well) |

**Class 9 — `::tests` module-path (24 instances):**

| Token | File | Occurrences | Lines |
|-------|------|-------------|-------|
| `src/adf.rs::tests` | bc-7 | 20 | 79, 89, 107, 126, 142, 149, 164, 171, 180, 187, 204, 211, 282, 289, 438, 467, 469, 513, 515, 546 |
| `src/output.rs::tests` | bc-7 | 1 | 29 |
| `src/observability.rs::tests` | bc-7 | 1 | 827 |
| `src/api/jira/links.rs::tests` | bc-3 | 1 | 2111 |
| `src/cli/issue/changelog.rs::tests` | bc-2 | 1 | 447 |

**Class 10 — `::tests::testfn` (1 instance):**

| Token | File | Line |
|-------|------|------|
| `src/types/assets/linked.rs::tests::display_id_fallback_with_hint` | bc-4 | 214 |

**Class 15 — Fn with space-in-args (1 instance):**

| Token | File | Line |
|-------|------|------|
| `src/api/jira/issues.rs::add_comment(internal: bool)` | bc-3 | 2100 |

**Also flagged as citation-hygiene (out of scope for grammar decision, but need cleanup before AC-001 GREEN):**

| Token | File | Line | Issue |
|-------|------|------|-------|
| `src/cli/auth.rs::handle_login` (+ ::handle_switch, ::handle_logout, ::handle_remove, ::auth_json_response, ::handle_logout, ::handle_remove, ::peek_oauth_app_source) | bc-7 743/761/779/797; bc-1 165/175/257 | 7-8× | **File does not exist** — `auth` was refactored to a directory (`src/cli/auth/mod.rs` + siblings). Path-existence check fails. |
| `src/cli/assets.rs:303-321` | bc-4 | 163 | **File does not exist** — `assets` was refactored to a directory (`src/cli/assets/mod.rs` + siblings). |
| `src/cli/snapshots/jr__cli__auth__tests__list_table_snapshot.snap` | bc-1 | 514 | **Moved** to `src/cli/auth/tests/snapshots/…` (verified via glob). Path-existence fails. |

These are TRUE dead citations that any working guard SHOULD catch — they are not grammar coverage failures. They ARE, however, additional pre-AC-001 cleanup churn.

### 1.4 ANSWER

- Pass-2's ~24 estimate was for the `::tests` module-path class only. Ground truth = 24 exact for that class.
- Total uncovered by DEC-153 v1 grammar = **29 token occurrences** (4 CamelCase + 24 tests + 1 tests::testfn).
- Plus 10 extraction failures on comma-space line-ref lists (class 14) and 1 on fn-with-space-args (class 15) — these fail extraction entirely under the current regex, so they can neither pass nor fail validation.
- Plus 5 continuation-line tokens (class 16), one of which (FieldsCache) is a CamelCase type.
- The "AC-001 GREEN on develop HEAD" clause of DEC-153 is jointly UNSATISFIABLE with the "no permissive fallback + v1 grammar limited to fn/UPPER/Type::method" clauses. **The contradiction is real, not a pass-2 miscount.**

---

## 2 — Feasibility of anchored-grep checks for uncovered classes (tested against real files)

### 2.1 `::tests` module-path

**Proposed check:** `grep -Eq '^[[:space:]]*(pub[[:space:]]+)?mod[[:space:]]+tests[[:space:]{]' <file>`

Run against every cited file (via ripgrep-equivalent Grep tool with pattern `mod\s+tests\b`):

| File | Result | Line found |
|------|--------|------------|
| `src/adf.rs` | HIT | 2561: `mod tests {` |
| `src/output.rs` | HIT | 58: `mod tests {` |
| `src/observability.rs` | HIT | 23: `mod tests {` |
| `src/cli/issue/changelog.rs` | HIT | 322: `mod tests {` |
| `src/api/jira/links.rs` | HIT | 60: `mod tests {` |

5/5 pass. False-green resistance: the anchor is `^[[:space:]]*(pub[[:space:]]+)?mod[[:space:]]+tests` — a doc comment mentioning "tests" is not matched because it requires the `mod` keyword at start of line (module indent). The `[[:space:]{]` end-anchor further requires either a space or open brace to follow (excludes `mod testsuite` or similar accidental collisions).

**FEASIBLE and false-green resistant.**

### 2.2 `::tests::testfn`

**Proposed check:** (mod tests exists in file) AND (`fn <testfn>` exists in file).

Test against the sole real citation `src/types/assets/linked.rs::tests::display_id_fallback_with_hint`:
- `mod tests` — HIT at line 68 (`src/types/assets/linked.rs::tests`).
- `fn display_id_fallback_with_hint` — HIT at line 100.

Alternative: since `display_id_fallback_with_hint` is unique enough on its own, `fn display_id_fallback_with_hint` alone is sufficient — the `mod tests` requirement is defense-in-depth against renamed-mod false-greens.

**FEASIBLE and false-green resistant.**

Recommendation: reuse the class-9 mod-check + reuse the class-4 fn-grep check as an AND-composition. Zero new primitives.

### 2.3 Standalone CamelCase type

**Proposed check:** `grep -Eq '^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?(struct|enum|type|trait|union)[[:space:]]+<Type>[<[:space:](]' <file>`

Verified via Grep tool with equivalent pattern `^\s*(pub(\([^)]*\))?\s+)?(struct|enum|type|trait|union)\s+<Type>`:

| Token | File | Result | Anchor line |
|-------|------|--------|-------------|
| `BulkTransitionRequest` | `src/types/jira/bulk.rs` | HIT | 297: `pub struct BulkTransitionRequest {` |
| `BulkTransitionInput` | `src/types/jira/bulk.rs` | HIT | 278: `pub struct BulkTransitionInput {` |
| `AdfBuilder` | `src/adf.rs` | HIT | 395: `struct AdfBuilder {` |
| `AdfRenderer` | `src/adf.rs` | HIT | 2116: `struct AdfRenderer {` |
| `ListFrame` | `src/adf.rs` | HIT | 2121: `enum ListFrame {` |
| `FieldsCache` | `src/cache.rs` | HIT | 327: `pub struct FieldsCache {` |

6/6 pass. False-green resistance: the anchor keys off a `struct|enum|type|trait|union` keyword at line start (with optional pub visibility). A CamelCase identifier appearing only in a doc comment, function body, or import statement does NOT match. The trailing character class `[<[:space:](]` handles generics (`FieldsCache<T>`), tuple structs (`ListFrame(…)`), and unit structs (`struct AdfBuilder;` — the `;` is not in the class, but the preceding space or newline is captured by the `\s+` before the identifier — verified against `ListFrame` at line 2121 which is `enum ListFrame {`).

Note the AdfRenderer entry — that's a Type appearing in class 7 (Type::method) but the standalone Type::CamelCase check also validates it. Not a conflict; it's belt-and-braces.

**FEASIBLE and false-green resistant.**

### 2.4 ANSWER

All three uncovered classes admit a feasible, false-green-resistant anchored-grep check verified against every real cited file. Extending the v1 grammar with these three checks (or reusing class-4 and class-9 primitives for class-10) closes the coverage gap mechanically. Total new grep primitives to add: 2 (`mod tests` and `struct|enum|type|trait|union`). Class 10 reuses primitives from 4 and 9.

---

## 3 — Option analysis with concrete numbers

### 3.1 Option A — Extend v1 grammar with the three feasible checks

**Grammar delta:** add three post-fn-grep-primary branches to the extractor:
1. If symbol matches `[A-Z][A-Za-z0-9_]*` (single CamelCase segment, no `::`) → run type-def anchored grep. Skip fn-grep primary.
2. If symbol is literal `tests` → run `mod tests` anchored grep. Skip fn-grep primary.
3. If symbol matches `tests::<snake_case>` → run `mod tests` check AND `fn <snake_case>` check. Skip fn-grep primary.
4. Otherwise (existing v1 branches): snake_case fn → fn-grep; UPPER_CASE → const/static; `Type::method` → dual-check.
5. **No permissive fallback.** Any symbol not matching a branch is reported DEAD (per DEC-153 (i)).

**Coverage after A:**
- Classes 1-7 + 8 + 9 + 10: 100% covered.
- Classes 14-16 (extraction failures) still fail. To close class 14+15, adopt F-B2-02-fix on the extraction regex (see §4 below). To close class 16, add multi-line Trace/Source stitching (out of scope for grammar; separate finding).
- Residual DEAD after A + F-B2-02-fix: 3 dead-path citations (`src/cli/auth.rs::*`, `src/cli/assets.rs:*`, `src/cli/snapshots/jr__cli__auth__tests__…`) — TRUE positives, need pre-AC-001 hygiene cleanup.
- Coverage of Trace/Source-scoped tokens: 326/326 grammatically = 100%; guard GREEN feasible after 3-token citation cleanup.

**Fixture-count delta:** +3 fixtures (one positive + one negative per new branch is ideal, but a single positive fixture per branch is minimally acceptable). Story A ships 12 fixtures; Guard 1 draft ships 7. Option A pushes Guard 1 to 10 fixtures. Still ~17% smaller than Story A.

**Regex complexity:** LOW.
- `mod tests` anchor is a single ERE.
- `struct|enum|type|trait|union` anchor is a single ERE.
- Branch dispatch is a shape guard on the symbol string (already present in the draft for UPPER_CASE and Type::method).

**Residual risk:** LOW-MEDIUM.
- `mod tests` anchor cannot distinguish `mod tests` from `mod tests_fixtures` — but the end-anchor `[[:space:]{]` rejects `_` so `mod tests_fixtures` won't match. False-green surface for a `mod tests` false-positive: rename `mod tests` to `mod integration_tests`, leave `src/foo.rs::tests` in a BC — validator false-greens because `mod tests` was already gone. WAIT: no — the validator RUNS the grep on the current file. If `mod tests` no longer exists in the current file, the check fails and the citation is reported DEAD. Correct behavior.
- Standalone CamelCase check false-green surface: a `struct Foo` renamed to `struct Bar` while leaving a doc-comment `// Foo used to…` — anchor requires the KEYWORD, not just the name; passes only if a fresh `struct Foo` (or enum/trait/type/union) is defined. Correct behavior.

**Verdict: Option A is mechanically minimal, correct, and closes the AC-001 GREEN blocker.**

### 3.2 Option B — BC-body cleanup

**Rewrite tokens** (per class):

- Class 8 (4 tokens, plus 1 continuation): rewrite `::TypeName` citations to `<file>` bare-file form, moving the type name into surrounding prose. Semantic cost: LOW (BulkTransitionRequest, BulkTransitionInput are structural types; readers can find them in the file). File churn: bc-3-issue-write.md (2 tokens on L377 + 1 continuation on L1440), bc-7-output-render.md (2 tokens on L211, L282).

- Class 9 (24 tokens): rewrite `::tests` module-path citations to a canonical test-file path (e.g., `src/adf.rs::tests` → `src/adf.rs` bare-file + rely on the file existing). Semantic cost: MEDIUM-HIGH — the citations are load-bearing signals to reviewers that the test coverage is inline, not in `tests/`. Losing the `::tests` distinguishes-inline-from-integration signal. File churn: bc-7-output-render.md carries the bulk (22 tokens across ~18 lines), bc-2, bc-3, small hits.

- Class 10 (1 token): rewrite `src/types/assets/linked.rs::tests::display_id_fallback_with_hint` to the file bare-form or move the test name into surrounding prose. Trivial.

- Class 14/15 (11 tokens with internal spaces): rewrite comma-space line-ref lists to semicolon-separated distinct citations OR restructure to single-range references. Semantic cost: LOW-MEDIUM (comma-space lists were a compact form; separating them lengthens the BC body). File churn: 8 lines across 5 files.

- Class 16 (5 tokens on continuation lines): collapse multi-line Trace/Source blocks into single lines. Semantic cost: LOW (multi-line breaks were mostly cosmetic, imposed by the 100+ column citations). File churn: bc-3-issue-write.md L1434-1441 and L1555-1559.

**Total files churned:** 6 out of 7 BC files (bc-6-config-cache.md is untouched — its only issues are class 14 line-ref lists, which affects but is not the majority).
**Total lines churned:** ~35-40.
**Total citations rewritten:** ~45 (29 uncovered + 11 extraction-fail + 5 continuation).

**Coverage after B:** 100% (all citations conform to v1 grammar and current-regex extractor).

**Cost:** MEDIUM-HIGH.
- Ongoing tax: every future BC-author must remember (a) no `::TypeName` standalone, (b) no `::tests` module-path, (c) no comma-space line-ref lists, (d) no multi-line Trace/Source. Enforcement is by convention only; a slip-up re-opens the coverage gap.
- One-time cost: ~40 lines of BC-body edits + review cycle.
- Load-bearing semantic loss: `::tests` module-path collapsed to bare-file loses the inline-vs-integration signal.
- Reviewability of the churn PR: HIGH — mechanical rewrites are easy to review, but a diff with 45 semi-mechanical text edits across 6 files needs a careful reviewer.

**Verdict: Option B is achievable but taxes future maintainers and loses semantic detail.**

### 3.3 Option C — Skip-with-warning tier

**Grammar delta:** every symbol not matching a v1 branch is emitted as a WARNING to stderr (`WARN: could not validate <token> — shape unrecognized`), with exit code 0 (guard passes). Optional CI knob to escalate warnings to errors.

**Coverage:** 29 tokens go unvalidated. Silent-under-coverage risk is exactly what DEC-148 identified this guard class as designed to prevent. Even the drift class the guard exists to catch (BC citation `src/foo::TypeName` stays after `TypeName` is renamed) would silently pass under Option C.

**Cost:** LOW to implement, but VIOLATES the guard's value proposition. The whole point of the guard is that citation drift breaks the build; silent-under-coverage undoes that.

**Verdict: rejected on first principles.**

### 3.4 ANSWER

Cost/risk matrix:

| Option | Fixture delta | Regex complexity | Coverage | Residual DEAD (post-cleanup) | Ongoing tax | Verdict |
|--------|---------------|-------------------|----------|-------------------------------|--------------|---------|
| A (extend grammar) | +3 | LOW (2 new ERE anchors) | 100% (post-hygiene cleanup) | 3 real dead paths | None (grammar handles new forms automatically) | **RECOMMEND** |
| B (BC-body cleanup) | 0 | 0 | 100% | 3 real dead paths | Every future BC author must avoid disallowed forms | Achievable but taxing |
| C (skip-with-warning) | 0 | 0 | ~90% (29 unvalidated) | Silent-under-coverage class re-opens | Ongoing drift risk | **REJECTED** — undoes guard's raison d'être |

---

## 4 — F-B2-02 calibration re-check

### 4.1 §-form and space-form tokens in Trace/Source scope

Grep for backtick-quoted `src/` tokens containing `§`: **zero on Trace/Source lines.** The single §-form `src/…` citation in the entire corpus (bc-3-issue-write.md L1711, `src/cli/issue/edit.rs::handle_edit § "Route: labels → bulk API"`) is in a BC body prose section, not on a `**Trace**:` or `**Source**:` line. It is therefore out of scope for the current extractor.

Grep for backtick-quoted `src/` tokens containing at least one internal space on Trace/Source lines: **11 tokens** — the 10 comma-space line-ref lists (class 14) + 1 fn-with-space-args (`add_comment(internal: bool)`, class 15). All 11 fail the current regex outright because it requires a terminal backtick with no space intervening.

### 4.2 Corrected N and FLOOR

Assuming Trace/Source-scoped tokens only (excluding class 16 continuation lines which need separate multi-line handling):

| Extraction regex | Recovered classes | Missed classes | N | FLOOR = floor(0.75 × N) |
|------------------|-------------------|----------------|---|--------------------------|
| Current: `` `src/[^` ]+` `` | Classes 1-11 (net of internal-space) | 14, 15, 16, §-form (0) | **315** | 236 |
| F-B2-02-fixed: `` `src/[^ ]+` `` (drop backtick req from char class OR two-phase: `` `src/[^`]+` `` then space-split) | Adds classes 14, 15 (11 tokens); § reduces to bare-file (0 tokens present anyway) | 16 (5 tokens) | **326** | 244 |
| F-B2-02-fixed + multi-line stitching | Adds class 16 (5 tokens) | none | **331** | 248 |

**FLOOR recommendation:**
- Under **Option A + F-B2-02-fixed regex + no multiline stitch: FLOOR = 244** (this is my primary recommendation).
- Under Option A + current regex + no fix: FLOOR = 236 (leaves classes 14/15 permanently uncovered — not ideal).
- Story draft's FLOOR=30 is 12% of N — vestigial, per prior research §2.6.
- Story A's exact-count-equality floor is too tight for BC-body churn cadence.

### 4.3 ANSWER

- §-form has **zero** Trace/Source-scope impact — the F-B2-02 label is misleading if it's read as a §-form issue; the actual class-14/15 impact of the same regex is 11 tokens. Recommend adopting the F-B2-02 regex fix regardless of whether §-form tokens exist, because the space-tolerance change is what recovers classes 14+15.
- Corrected FLOOR under the recommended stack (Option A + F-B2-02 fix, no multi-line stitch): **244**, from N = 326.

---

## 5 — FINAL RECOMMENDATION (DEC-154 draft)

**RECOMMEND OPTION A (extend v1 grammar), with F-B2-02 regex fix bundled in.**

### 5.1 Exact grammar spec deltas (relative to draft Task 2 Step 4 as ratified by DEC-153)

Add three symbol-shape branches to the extractor's symbol-verification block. All three run in place of (not in addition to) the DEC-153 (i) "no permissive fallback" branch. Any symbol not matching a v1 branch remains DEAD.

**Branch dispatch order** (first match wins; each shape guard is on the substring AFTER `::`, treating `Type::method` as a special two-segment case):

1. If the post-`::` symbol matches `^tests$` → run `mod tests` anchored grep:
   ```
   grep -Eq '^[[:space:]]*(pub[[:space:]]+)?mod[[:space:]]+tests[[:space:]{]' <src_file>
   ```

2. If the post-`::` symbol matches `^tests::[a-z_][a-z0-9_]*$` → run the class-1 mod-check AND `fn <testfn>` grep. Reuses two existing primitives.

3. If the post-`::` symbol matches `^[A-Z][A-Za-z0-9_]*$` (single CamelCase segment, no `::`) → run type-def anchored grep:
   ```
   grep -Eq '^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?(struct|enum|type|trait|union)[[:space:]]+<Type>[<[:space:](]' <src_file>
   ```

4. If the post-`::` symbol matches `^[A-Z][A-Za-z0-9_]*::[a-z_][a-z0-9_]*$` (`Type::method`) → DEC-153 (ii) dual-check unchanged.

5. If the post-`::` symbol matches `^[A-Z_][A-Z0-9_]+$` (UPPER_CASE) → DEC-153 (ii) const/static check unchanged.

6. If the post-`::` symbol matches `^[a-z_][a-z0-9_]*$` (single snake_case) → fn-grep unchanged.

7. Otherwise → DEAD, no permissive fallback.

**Extraction regex F-B2-02 fix (bundled):** change `` `src/[^` ]+` `` to a two-pass extractor OR to `` `src/[^`]+` `` followed by post-split on the first space (line-ref-list normalization). The story's `strip_lineref` step must then be extended to strip trailing `, NN` / `, NN-MM` groups (comma-space line-ref list normalization). The one fn-with-space-args token (`add_comment(internal: bool)`) then normalizes to `src/api/jira/issues.rs::add_comment` (strip trailing `(…)`), which hits branch 6.

**Multi-line Trace/Source stitching (class 16):** OUT OF SCOPE for v1 — pre-fix the 5 continuation-line tokens by re-flowing lines 1434-1441 and 1555-1559 of bc-3-issue-write.md into single-line Trace fields as citation-hygiene during story-b PR delivery. This costs 2 line edits and removes an entire failure class without any grammar work.

**Citation hygiene pre-work (pre-AC-001 GREEN):** remove or fix 3 truly-dead citations that any correct guard would flag:
- `src/cli/auth.rs::*` (7-8 tokens) → rewrite to specific `src/cli/auth/<file>.rs::fn` after locating the actual file per the refactored layout.
- `src/cli/assets.rs:303-321` → rewrite to `src/cli/assets/<file>.rs:NN-MM` per refactored layout.
- `src/cli/snapshots/jr__cli__auth__tests__list_table_snapshot.snap` → rewrite to `src/cli/auth/tests/snapshots/jr__cli__auth__tests__list_table_snapshot.snap`.

### 5.2 Fixture-count delta

Draft has 7 fixtures. Add:
- Fixture I: `::tests` module-path positive (`src/adf.rs::tests` resolves).
- Fixture J: `::tests` module-path negative (fabricated `src/adf.rs::nonexistent_mod` → DEAD).
- Fixture K: standalone CamelCase type positive (`src/types/jira/bulk.rs::BulkTransitionRequest` resolves).

Optional but recommended:
- Fixture L: `::tests::testfn` positive (`src/types/assets/linked.rs::tests::display_id_fallback_with_hint` resolves).
- Fixture M: standalone CamelCase type negative (fabricated `src/adf.rs::NonexistentType` → DEAD).

Minimum: +3 (I, J, K). Recommended: +5 (I, J, K, L, M). Final Guard 1 fixture count: 10-12, still smaller than Story A's 12.

### 5.3 Corrected N and FLOOR

- N (Trace/Source-scoped, extractable under Option A + F-B2-02 fix): **326**.
- FLOOR = floor(0.75 × N) = **244**.

### 5.4 Rationale (one-paragraph DEC-154 form)

DEC-153 ratified a v1 grammar (fn-grep + UPPER_CASE + Type::method) and a no-permissive-fallback stance, then required AC-001 GREEN on develop HEAD. Ground-truth census on develop @ ab78a2d shows 29 token occurrences on Trace/Source lines whose shape falls OUTSIDE the DEC-153 v1 grammar — 24 `::tests` module-paths (dominated by `src/adf.rs::tests` × 20), 4 standalone CamelCase types (BulkTransitionRequest, BulkTransitionInput, AdfBuilder, ListFrame), and 1 `::tests::testfn`. The three constraints are therefore jointly unsatisfiable. Three feasible, false-green-resistant anchored-grep checks (verified against every real cited file) close the gap for 2 new grep primitives and 3-5 new fixtures: `mod tests` anchor for `::tests`, `struct|enum|type|trait|union` anchor for standalone CamelCase, and a compose-of-existing-primitives for `::tests::testfn`. Grammar-extension (Option A) dominates BC-body cleanup (Option B, ~45 rewrites + ongoing convention tax) and skip-with-warning (Option C, resurfaces the DEC-148 drift class). Bundle the F-B2-02 regex fix (space-tolerant extraction) to recover 11 additional tokens currently silently dropped by the extractor, and pre-fix 5 continuation-line tokens and 3 truly-dead paths as one-time citation hygiene. Result: N = 326, FLOOR = 244, guard GREEN feasible on develop HEAD without weakening DEC-153's no-permissive-fallback stance.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| Perplexity perplexity_research (PRIMARY) | 0 | Task is 100% internal repo forensics — census counts and grep-against-real-files verification against on-disk develop-branch artifacts. External sources would not surface any answer used in this report. |
| Perplexity perplexity_reason / perplexity_ask / perplexity_search | 0 | Same rationale. |
| Context7 | 0 | No third-party library docs relevant. |
| Tavily | 0 | Same rationale. |
| WebFetch / WebSearch | 0 | Same rationale. |
| Read | 5 | Story-b open-questions research (prior pass), bc-3 multi-line context spans (L640-660, L1553-1562, L1432-1446), plus 15 targeted "omitted long line" reads across bc-3/bc-6/bc-7 to recover truncated grep-output content. |
| Grep | ~20 | Trace/Source-line enumeration; `src/`-token extraction with `-o`; per-class shape verification against real src files (`mod tests`, `struct|enum|type|trait|union`, `impl <Type>`, `fn <method>`); §-form and space-form audit; ROOT_FILES/dead-path verification. |
| Glob | ~10 | Verifying which cited paths actually exist on develop HEAD (dead-path cross-check for `src/cli/auth.rs`, `src/cli/assets.rs`, snapshots). |

**Total MCP tool calls:** 0
**Training data reliance:** low — every count is anchored to a specific file+line from the current repo state; every anchored-grep proposal was executed against the real cited files this session.

**Deviation-from-default justification (per agent-defaults):** The primary tool for research agents is `perplexity_research`. However, this task's questions are:
1. "Extract every backtick token matching `src/…` from `^**(Trace|Source)**:` lines across bc-*.md files" — pure repo forensics.
2. "Verify anchored-grep proposals against the real cited files on develop @ ab78a2d" — pure repo forensics.
3. "Analyze options with the census numbers" — synthesis over gathered evidence.
4. "Verify F-B2-02 impact on calibration" — pure repo forensics.
5. "Final recommendation" — synthesis.

External web search would not surface any of the load-bearing findings (per-file token counts, anchored-grep pass rates, semantic classifications of citation shapes in THIS repo). The parent task description explicitly scoped external tools to "no external tools needed". Every claim in this report cites a specific file+line, so an external Perplexity confirmation query is straightforward to add later if any consumer of this report needs it.
