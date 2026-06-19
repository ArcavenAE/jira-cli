# Spec Review — DEAD-CITATION-CI (Phase F2 Spec Evolution)

**Reviewer:** Spec Reviewer (constructive second opinion, third cognitive perspective)
**Pass:** 1 (first review — all findings new)
**Date:** 2026-06-19
**Scope reviewed:**
- `.factory/specs/prd/cross-cutting.md` §X.13 (BC-X.13.001/002/003) + Canonical Test Vectors + Edge Cases
- `.factory/specs/prd/error-taxonomy.md` §8 (CI-CITE-001)
- `.factory/phase-f2-spec-evolution/prd-delta-DEAD-CITATION-CI.md`
- `.factory/phase-f2-spec-evolution/arch-delta-DEAD-CITATION-CI.md`
- `.factory/phase-f2-spec-evolution/verification-delta-DEAD-CITATION-CI.md` (VP-CITE-001/002)
- Cross-checked against `.factory/phase-f1-delta-analysis/DEAD-CITATION-CI-delta-analysis.md`
- Ground-truthed against the actual `CLAUDE.md` backtick-citation corpus

**Information wall:** This review is constructive (post-remediation third opinion). It does
not re-report adversary findings (those live in `adversarial-spec-delta-review*.md`, which
were not read). Findings below are framed as improvements to make F4 TDD smoother.

---

## Part B — Findings

### SR-001: Tokenizer's two-context model is under-specified — "tokenize backtick contents by whitespace" silently relies on a non-obvious invariant
- **Severity:** MEDIUM
- **Category:** ambiguity
- **Location:** BC-X.13.002 Behavior rule 4 + EC-CITE-009; arch-delta §2 step 1 ("Tokenizes backtick-quoted content by whitespace"); F1 §5a
- **Description:** The grammar is described as "tokenize backtick contents by whitespace,"
  but the spec never states the *outer* tokenization step: how a single backtick span is
  isolated from surrounding prose, and what happens when one backtick span contains **multiple
  whitespace-separated tokens**. Ground truth confirms this matters: in real `CLAUDE.md`,
  section refs live **inside** the backtick span —
  `` `docs/specs/e2e-fork-safe-ci-enablement.md §2.3` `` (one span, two whitespace tokens) —
  AND **outside** it — `` `docs/specs/e2e-live-jira-testing.md` §9.`` (path-only span, then bare
  `§9.`). The current design happens to handle both, but only because the inner whitespace
  split runs *within* span content. The spec's own EC-CITE-009 describes the path and `§9` as
  if `§9` were a sibling token; it does not say whether that split happens before or after the
  span is extracted from the markdown line. An implementer could reasonably read "tokenize
  backtick-quoted content by whitespace" as "split the *whole line* on whitespace and keep
  backtick-wrapped tokens" — which would FAIL on `` `...md §2.3` `` because the closing
  backtick is glued to `§2.3`, not to `...md`.
- **Suggestion:** Add one explicit two-step statement to BC-X.13.002 Behavior:
  *(0a) Extract each maximal `` `...` `` span from the document (regex `` `([^`]*)` `` or a
  manual backtick-pair scan). (0b) Split each span's interior on ASCII whitespace into
  candidate tokens. Steps 1–5 then apply per token.* This makes both the inside-span and
  outside-span `§` forms fall out for free and removes the only place where "whitespace
  tokenization" is doing ambiguous work. It also pre-answers the F4 question "do I split the
  line or the span?" — the answer is *the span interior*.

### SR-002: Brace-glob citation form `{a,b,c}` is present in CLAUDE.md but not in the exclusion grammar
- **Severity:** MEDIUM
- **Category:** completeness / domain-gap
- **Location:** BC-X.13.002 exclusion rules; F1 §5b/§6 risk table
- **Description:** The glob exclusion (Rule 1) skips tokens containing `*`. But CLAUDE.md also
  uses **brace-expansion globs** that do *not* contain `*`, e.g.
  `` `adf::tests::test_markdown_{superscript,subscript,heading_attributes}*` `` and
  `` `.factory/research/issue-361-*.md` ``. The first is saved by the dir-prefix filter
  (`adf::` has no known prefix) AND by the trailing `*`. But consider a *hypothetical/future*
  citation of the shape `` `docs/specs/adf-{block,task}-list.md` `` — it has a known prefix
  (`docs/`), a recognized extension (`.md`), and **no `*`** — so it would survive every
  current exclusion rule and then fail `Path::exists()`, producing a false positive. The F1
  risk enumeration claims to be "exhaustive" (9 categories) but brace-globs are not among
  them. This is a latent false-positive vector for the *guard's own evolution*, exactly the
  class of regression the BCs were created to prevent.
- **Suggestion:** Extend Rule 1 to: *skip any token containing `*` **or** `{` **or** `}`*
  (any shell-glob metacharacter). One-line change to BC-X.13.002 Behavior rule 1 and its
  EC/test-vector table. Cheap insurance; keeps the guard from regressing as new brace-glob
  doc patterns are added. Add a canonical vector `` `docs/specs/adf-{block,task}-list.md` `` →
  skipped.

### SR-003: Symbol-form function names containing literal dots (`::test_..._emits...`) are unaddressed
- **Severity:** LOW
- **Category:** completeness
- **Location:** BC-X.13.002 Rule 2 (symbol-form strip); EC-CITE-006
- **Description:** Ground truth includes
  `` `tests/search_issue_keys.rs::test_..._emits_jracloud_95368_literal` `` — a symbol-form
  citation whose function-name portion contains a literal `...` ellipsis. Rule 2 ("strip from
  `::` onward") handles this correctly (everything after the first `::` is dropped, yielding
  `tests/search_issue_keys.rs`), so there is **no bug** — but the spec's worked examples
  (EC-CITE-006, the vector table) only show clean `::fn` and `::mod::fn` cases. An implementer
  writing the strip with a too-clever regex (e.g. `(?P<path>[\w./]+\.rs)::`) rather than
  "find first `::`, truncate" could mis-handle the dotted ellipsis. The spec's stated invariant
  ("`::` cannot appear in a file path… stripping `::.*` is unambiguous") is the right
  implementation; it just isn't pinned by a test vector matching the real corpus.
- **Suggestion:** Add one canonical vector to BC-X.13.002:
  `` `tests/search_issue_keys.rs::test_..._emits_jracloud_95368_literal` `` →
  `tests/search_issue_keys.rs` → checked. This converts an implicit "trust the prose" into an
  explicit red test, nudging F4 toward the "first `::`, truncate" implementation over a regex.

### SR-004: Suffix-strip ordering vs. extension-filter ordering is stated two different ways across documents
- **Severity:** MEDIUM
- **Category:** coherence
- **Location:** arch-delta §2 (steps 1–6) vs. BC-X.13.002 Behavior (rules 1–5) vs. BC-X.13.001 Behavior prose
- **Description:** The three documents specify the pipeline step order differently:
  - **arch-delta §2** lists: (1) tokenize, (2) prefix filter, (3) **extension filter**,
    (4) glob skip, (5) symbol strip, (6) line-ref strip. Here the extension filter runs
    *before* the suffix strips.
  - **BC-X.13.002 Behavior** lists: (1) glob skip, (2) symbol strip, (3) line-ref strip,
    (4) section-ref, (5) **extension filter** "after suffix stripping."
  - **BC-X.13.001 Behavior** says extension is checked as part of in-scope detection
    *before* "strips disambiguation suffixes per BC-X.13.002."
  Order is *outcome-relevant*: `` `src/config.rs:~42` `` has extension `.rs` only AFTER the
  `:~42` strip is removed (otherwise the "extension" is `.rs:~42` — depends on how the
  extension check is written). If the extension filter runs first (arch-delta order) and is
  implemented as "ends with one of `.rs/.md/...`", then `src/config.rs:~42` fails the
  extension check and is wrongly dropped. If it runs last (BC-X.13.002 order), it passes.
  The two normative documents disagree on which is correct, and the disagreement changes the
  result for the line-ref case the guard explicitly must support (EC-CITE-007).
- **Suggestion:** Pick ONE canonical order and make all three documents match. The
  BC-X.13.002 order (strip suffixes → THEN extension filter) is the correct one and should win;
  update arch-delta §2 to move "extension filter" to the last step, and soften BC-X.13.001's
  "has a recognized file extension" to "has a recognized file extension after suffix
  normalization (per BC-X.13.002)." This is the single highest-value coherence fix for F4 —
  it removes a real correctness fork.

### SR-005: VP-CITE-001 proptest regex domain can generate inputs that the proptest's own assertion mishandles
- **Severity:** LOW
- **Category:** feasibility
- **Location:** verification-delta §VP-CITE-001 proptest `test_non_prefix_tokens_are_never_extracted` (regex `"[A-Za-z0-9_:~./]{1,50}"`)
- **Description:** The proptest generates strings over `[A-Za-z0-9_:~./]` and asserts that any
  extracted path starts with a known prefix. But this character class **can produce a string
  that itself starts with a known prefix** — e.g. proptest could generate `src/a.rs` (all
  chars are in the class). The test name and intent are "non-prefix tokens are never
  extracted," but the generator does not guarantee the input is non-prefix. The assertion is
  written defensively ("any returned path starts with a known prefix") so it won't *false-fail*
  — but it then no longer tests what its name claims, and a generated `src/x.md` that gets
  extracted is a *pass*, masking the property. This is a feasibility/clarity gap, not a
  correctness bug.
- **Suggestion:** Either (a) rename the property to
  `test_extracted_paths_always_start_with_known_prefix` (which is what the assertion actually
  proves and is a perfectly good invariant), or (b) add a `prop_assume!` filtering out inputs
  that start with a known prefix if the original "non-prefix" framing is wanted. Option (a) is
  simpler and stronger — keep the assertion, fix the name. Worth a one-line note in the
  verification delta so the test-writer doesn't ship a misleadingly-named property.

### SR-006: "All 9 exclusion rules" is asserted but the enumerated rule sets don't total 9 consistently
- **Severity:** LOW
- **Category:** coherence
- **Location:** BC-X.13.001/002 ("all 9 exclusion rules"); verification-delta VP-CITE-001 table (rows numbered 1–9 but with sub-rows "2"/"2 — no dir prefix" and "3"/"3 bare"); arch-delta §2 (6 steps)
- **Description:** Three documents reference the rule set with three different cardinalities.
  BC-X.13.002 Behavior enumerates **5** numbered rules. arch-delta §2 enumerates **6** steps.
  The verification-delta VP-CITE-001 table has **9 rows** but two of them are sub-variants of
  rule 2 and rule 3 (symbol-with-prefix vs symbol-without-prefix; tilde line-ref vs bare
  line-ref). The phrase "all 9 exclusion rules" appears verbatim in both BCs and the VP. A
  reader counting rules in BC-X.13.002 finds 5, not 9, and cannot reconcile. This is a cosmetic
  traceability snag, but it undercuts the "each rule independently exercisable" claim in the
  F6 handoff checklist (a mutation-testing reviewer will ask "which 9?").
- **Suggestion:** Define the canonical "9" once — the cleanest is the 9-row VP-CITE-001 table
  (it enumerates 9 *testable cases*, which is the unit of mutation coverage that matters).
  Add a sentence to BC-X.13.002: *"The 5 normalization/exclusion rules above expand to 9
  independently-testable cases enumerated in VP-CITE-001."* Then "all 9" is anchored. No
  semantic change.

### SR-007: Allowlist is a static prefix list with no runtime guard against the "file actually present" contradiction
- **Severity:** LOW
- **Category:** feasibility / domain-gap
- **Location:** BC-X.13.003 (`is_off_working_branch_allowlisted`); Preconditions ("`.factory/specs/` … NOT present in the working tree")
- **Description:** The allowlist's correctness rests on a *precondition* that
  `.factory/specs/`, `.factory/holdout-scenarios/`, `.factory/cycles/` are absent from the
  working tree. But in this very repository the developer/agent often runs with the
  `factory-artifacts` worktree mounted (the factory uses `.factory/` worktrees per the
  factory-health skills), so those directories **can** be present at test time. When present,
  the allowlist *silently skips a path that does exist and is correct* — harmless today, but
  it means the allowlist permanently blinds the guard to an entire subtree even on machines
  where that subtree is checked out and citable. The spec treats "off-working-branch" as a
  static fact; it is actually environment-dependent. There is no contradiction-detection
  (e.g., "allowlisted path exists on disk → maybe it shouldn't be allowlisted").
- **Suggestion:** This is acceptable for v1 (the guard's job is to catch *dead* citations;
  skipping a *live* one is a false-negative, not a false-positive, and false-negatives here are
  low-harm). But document the tradeoff explicitly in BC-X.13.003 Invariants: *"Allowlisted
  prefixes are skipped unconditionally, even when present in the working tree (e.g. under a
  mounted `factory-artifacts` worktree). This is a deliberate false-negative: a dead
  `.factory/specs/` citation will not be caught. Accepted because these paths are
  branch-portable and their primary failure mode is absence, not rot."* Optionally add a
  *second*, weaker test that warns (not fails) if an allowlisted path is present-and-dead.
  The doc note alone closes the gap for F4.

### SR-008: `include_str!` vs `Path::exists()` root-resolution timing is consistent but worth one explicit invariant
- **Severity:** LOW
- **Category:** ambiguity
- **Location:** BC-X.13.001 Preconditions/Invariants; arch-delta §4
- **Description:** The design loads CLAUDE.md at **compile time** (`include_str!`) but checks
  files at **run time** (`Path::exists()` against `CARGO_MANIFEST_DIR`). These are two
  different moments. In the normal CI flow they're the same checkout so it's fine. But the
  spec never states the invariant that *the CLAUDE.md compiled into the binary and the
  filesystem checked at runtime must be the same checkout* — if a test binary is built on one
  commit and the working tree is later mutated (rebase, file deletion) before the binary runs,
  the guard checks stale citations against a fresh tree (or vice versa). This is a
  theoretical-only concern in CI (build and run are atomic), but it's exactly the kind of
  unstated assumption a fresh-eyes reviewer should surface.
- **Suggestion:** Add one invariant to BC-X.13.001: *"The guard assumes the `CLAUDE.md`
  embedded via `include_str!` and the working tree resolved via `CARGO_MANIFEST_DIR` belong
  to the same checkout. This holds under `cargo test` (compile + run are atomic per invocation)
  and is the only supported invocation mode."* Purely documentary; prevents a future
  "why did the guard pass on stale CLAUDE.md?" investigation.

---

## Constructive answers to the reviewer's specific questions

### Are the contracts clear, testable, and implementable as written?
**Mostly yes.** The three BCs are well-bounded, each has Preconditions/Postconditions/
Invariants/Edge-Cases/Canonical-Vectors, and the canonical vectors are concrete enough to
drive red tests directly. The two blocking clarity issues before F4 are **SR-004** (the
step-ordering fork between arch-delta and BC-X.13.002 is a genuine correctness fork for the
line-ref case) and **SR-001** (the outer/inner tokenization step is implicit). Both are
fixable with one-sentence edits. Everything else is LOW polish.

### Is the pure/effectful boundary the right design for VP-CITE-001 unit-testability?
**Yes — this is the strongest part of the spec.** Splitting `extract_path_citations` (pure,
`&str -> Vec<String>`) from the `Path::exists()` effect at the outermost layer is exactly
right and is the correct enabler for proptest. The arch-delta §2 boundary-enforcement note and
the VP-CITE-001 "purity boundary" callout both correctly flag that inlining the grammar into
the test body would force filesystem mocking. The convention citation (mirrors `src/adf.rs`
and `src/partial_match.rs` pure-core/effectful-shell split) is apt and grounds the design in
existing project idiom. The F4 handoff checklist correctly makes "standalone pure function" a
gate. No change recommended — this boundary should be preserved verbatim.

One refinement: `is_off_working_branch_allowlisted` is *also* pure (prefix match) and should
be explicitly grouped with `extract_path_citations` on the pure side of the boundary — the
arch-delta lists it under the effectful test (§2 step 4) where it's only *called*, which
slightly muddies the "the filesystem check is the only effectful operation" statement. Minor.

### Is anything over- or under-specified?
- **Over-specified:** The Canonical Test Vector tables partially duplicate the VP-CITE-001
  table and the EC list — three near-identical enumerations of the same cases across
  cross-cutting.md and verification-delta.md. Not harmful (and arguably good redundancy for a
  correctness guard), but if any one is edited the others drift. Consider designating the
  VP-CITE-001 table as source-of-truth and having the BC vector tables cite it. (Ties to
  SR-006.)
- **Under-specified:** Outer tokenization (SR-001), brace-globs (SR-002), pipeline ordering
  (SR-004). All three are the *grammar's* under-specification, which is precisely the
  make-or-break surface the F1 analysis itself flagged as "the make-or-break design risk."

### Are the exclusion rules expressible as deterministic code?
**Yes, all of them.** Every rule is a pure string predicate: prefix-`starts_with`,
extension-`ends_with` (after strip), `contains('*')`, `find("::")` truncate,
trailing-`:~?[0-9]+` strip, whitespace split. No regex backtracking hazards, no locale
dependence, no ordering nondeterminism *once SR-004 fixes the canonical step order*. The only
determinism caveat is SR-004: the extension filter's result depends on whether suffix-strip
ran first. Fix the order and the whole grammar is a deterministic, total function over
`&str` — which the `test_extract_never_panics` proptest already asserts.

### Suggestions to make F4 TDD smoother
1. Land **SR-004** (canonical pipeline order) and **SR-001** (explicit two-step tokenization)
   *before* F4 — these remove the two real ambiguities a test-writer would otherwise have to
   guess at, and a wrong guess produces a guard that's green-but-wrong (the worst outcome for a
   correctness gate).
2. Add the **SR-002** brace-glob vector and **SR-003** dotted-ellipsis vector to the canonical
   tables so the red tests cover the real CLAUDE.md corpus, not just the clean textbook cases.
3. Designate VP-CITE-001's 9-row table as the single source of truth for the rule set
   (SR-006) so mutation testing in F6 has an unambiguous "9 cases" target.

---

## Summary

| Finding | Severity | Category | Blocking F4? |
|---------|----------|----------|--------------|
| SR-001 outer/inner tokenization implicit | MEDIUM | ambiguity | Recommended pre-F4 |
| SR-002 brace-glob `{a,b}` not excluded | MEDIUM | completeness | Recommended pre-F4 |
| SR-003 dotted-ellipsis symbol-form vector missing | LOW | completeness | No |
| SR-004 pipeline step-order fork across docs | MEDIUM | coherence | **Yes — fix pre-F4** |
| SR-005 proptest name vs generator domain | LOW | feasibility | No |
| SR-006 "9 rules" cardinality mismatch | LOW | coherence | No |
| SR-007 allowlist false-negative undocumented | LOW | feasibility | No (doc-only) |
| SR-008 include_str! vs runtime checkout invariant | LOW | ambiguity | No (doc-only) |

**Overall assessment: STRONG spec, ready for F4 after two one-sentence fixes.** The
pure/effectful boundary is correct and is the right enabler for VP-CITE-001. The BCs are
well-structured with concrete vectors. The single must-fix is **SR-004** (the documents
disagree on whether the extension filter runs before or after suffix-stripping, and the
disagreement changes the result for the line-ref case the guard must support). The
nice-to-have-pre-F4 items are **SR-001** (make the two-step tokenization explicit) and
**SR-002** (exclude brace-globs `{a,b}`, not just `*`). Everything else is LOW polish that can
ride along or be deferred without risk to the guard's correctness.

No adversary findings were re-reported (information wall respected). No CRITICAL or HIGH
findings. The feature is appropriately scoped, the regression surface is genuinely LOW, and
the "green from day 1 on develop" self-verifying structure is sound.
