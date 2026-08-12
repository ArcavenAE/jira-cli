# PR Review — S-CIGATE-3 (PR #680) — REVIEW CYCLE 2

**Verdict: APPROVE**
**Covered SHA: `dc4909b2370284e5c88d517679f391fb2ec59c1f`**
**B-1 (cycle-1 sole BLOCKING finding): RESOLVED — independently verified.**

> Submitted as a COMMENT-state review, not a formal `APPROVE` review — GitHub rejects
> `gh pr review --approve` on a self-authored PR. The verdict is nonetheless **APPROVE**;
> treat the body as the approval.

This is an independent cycle-2 review (fresh verification, not a re-read of the cycle-1
agent's appended notes). Every experiment below was run against the tracked worktree and
restored byte-identically; `git status --short` is empty after all of it.

---

## 1. Is B-1 actually resolved for all 5 pins (incl. the `needs:` tag case)? — YES

**Fix mechanism (dc4909b2), confirmed by reading the actual diff:**
- `tests/common/wf.rs`: `Value::Scalar` gains `has_anchor: bool`; `resolve_value` now
  captures `anchor_id != 0` (previously destructured as `_anchor_id` and discarded).
- `job_level_value_span` return type changed `Option<Range<usize>>` → `Option<ValueSpanOutcome>`;
  when the composite (`MappingStart`/`SequenceStart`) value node carries a non-zero
  `anchor_id` or a `tag`, it returns `NodeProperty { has_anchor, tag }` **before** slicing
  a span (the old code sliced the span starting at `[`, after the node property, so the
  anchor/tag was dropped).
- All 4 scalar pins (`extract_and_normalize_if_expr`, `extract_and_normalize_sole_run_line`,
  `extract_and_normalize_step_run_line_by_name`, `extract_and_normalize_sole_needs_json_line`)
  gain an `if *has_anchor { Err }` branch placed alongside the existing `tag.is_some()` branch.
- The `needs:` pin (`extract_and_normalize_sole_needs_line`) matches on the new enum and
  returns `Err` on `NodeProperty` — this gives it **both** an anchor check and its
  first-ever **tag** check (its value is a flow sequence resolved via `Value::Other`, never
  through `resolve_value`'s scalar tag branch, so it previously had no tag guard at all).

**Signature-change safety:** `job_level_value_span` has exactly one non-doc caller
(the `needs:` pin at `ci_gate_completeness.rs:6240`), correctly updated. No other caller
broke — consistent with the clean compile and CI green.

**Value-side rejection genuinely fires** — I reproduced the RED proof independently.
I neutered *only* the fix (`has_anchor: *anchor_id != 0` → `false`, and stripped the
`NodeProperty` branch in `job_level_value_span`) and ran the six new tests:

```
test result: FAILED. 0 passed; 6 failed  (all six test_b1_* fail against neutered code)
  test_b1_if_expr_rejects_value_side_anchor
  test_b1_sole_run_line_rejects_value_side_anchor
  test_b1_step_run_line_by_name_rejects_value_side_anchor
  test_b1_needs_json_line_rejects_value_side_anchor
  test_b1_needs_line_rejects_value_side_anchor
  test_b1_needs_line_rejects_value_side_tag      <-- the needs: TAG case
```

Example failure surfaced the exact gap: `extract_and_normalize_sole_needs_line` returned
`Ok("[fmt, clippy]")` for `needs: &x [fmt, clippy]` when the anchor capture was removed.
With the fix restored, all six pass (part of 64/64 below). **These are real RED proofs,
not tautologies** — each also carries a passing positive control (the un-anchored fixture
still resolves `Ok`), so no pin became unconditionally rejecting. The `needs:` tag case is
caught by the dedicated new `NodeProperty` path (self-describing message printing the
resolved `tag:yaml.org,2002:seq`), not a coincidental downstream count mismatch.

## 2. New regression / false-positive? — NONE

- **Full binary green post-fix:** `cargo test --test ci_gate_completeness` → **64 passed / 0 failed**
  (32 prior guard + 6 new = 38 guard, + 26 `wf.rs`). `cargo fmt --all -- --check` clean;
  `cargo clippy --test ci_gate_completeness --all-features -- -D warnings` clean.
- **No false positive on the real tracked `ci.yml`:** `ci-gate`'s `needs:` is a plain flow
  sequence `[fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection, mutants]`
  and its `if:` is a plain `${{ always() }}` — neither carries an anchor or tag, so the new
  `NodeProperty`/`has_anchor` rejections do not fire on legitimate input. The 64/64 green run
  is against this real file.
- **No `&`-in-text false surface:** `has_anchor` is driven purely by the parser's
  `anchor_id`, never by text scanning. A YAML anchor indicator only binds at node-start;
  `&&` inside a `${{ … && … }}` expression or a `foo&bar` inside a string is ordinary scalar
  text and resolves `has_anchor == false`. (The file already contains `&&` in other jobs'
  `if:` expressions and stays green.)
- **No existing pin touched:** the change is purely additive — a new `Err` branch placed
  *before* each pin's pre-existing `tag.is_some()`/`ScalarStyle::Plain` checks, plus one enum
  widening on the `needs:` composite path. `.first()`-root-selection and all `PINNED_*`
  constants are unchanged.

## 3. Is AC-004 ("no byte pin deleted, weakened, or replaced") now literally satisfied? — YES

All five rows cycle-1 flagged as weaker-than-`develop` (`run: &x …`, `if: &a …`,
`NEEDS_JSON: &z …`, `needs: &n […]`, `needs: !!seq […]`) are now rejected loudly. The value
side is at least as strong as `develop` for the anchor case and **stronger** for the
`needs:` tag/anchor case (a dedicated, self-describing pin vs. a downstream side effect on
`develop`). Nothing was deleted or loosened; the migration's `ScalarStyle::Plain` strictness
is retained. AC-004 is met.

## 4. Other blocking issues in the diff? — NONE

Zero `src/` changes; the fix touches only `tests/ci_gate_completeness.rs` and
`tests/common/wf.rs`. Diff coherent, single-purpose, Conventional-Commit message with the
story ID. Dependency (S-CIGATE-2) already on `develop`. PR head `dc4909b2`,
`mergeStateStatus: CLEAN`, all 15 status checks + `CI Gate` SUCCESS (incl. both Windows legs
and Coverage).

---

## Non-blocking (carried from cycle 1, unchanged by this commit — follow-up, do not hold PR)

- **NIT (new, minor):** `test_b1_needs_line_rejects_value_side_tag` has no positive control of
  its own; the plain-`needs:` positive control lives in the sibling anchor test, so coverage
  is intact. Purely cosmetic.
- **S-3 (doc drift):** the fix commit did not update `CLAUDE.md`. The in-code doc comment on
  `find_key_node_properties` is now correctly updated to state the value-side gap is "now
  CLOSED … for the five pins that need it," but `CLAUDE.md`'s SCOPE SUMMARY still lacks the
  value-side caveat and retains the cycle-1 inaccuracies (the `130c634f` "last commit" claim
  and stale LOC figure). Non-blocking doc-only follow-up.
- **S-1 / S-2 / S-4** (latent-robustness / `.first()` root selection / stale panic text) and
  **N-1..N-4** are all pre-existing, unchanged-or-improved, non-blocking.

## Checklist

| Item | Result |
|---|---|
| Diff coherence | Pass — test-infra + docs only; zero `src/` changes |
| Description accuracy | Pass — AC-004 now genuinely satisfied |
| Test coverage | Pass — 64/64; 6 new tests RED-proven genuine |
| Demo evidence | N/A — no product BCs, no user-visible behaviour |
| Commit quality | Pass — Conventional Commit + story ID |
| Diff size | +327 / −28, justified and scoped to B-1 |
| Missing changes | Pass — B-1 fully closed incl. `needs:` tag case |
| Dependency status | Pass — S-CIGATE-2 on `develop` |

**Verdict: APPROVE. Covered SHA `dc4909b2`.** B-1 resolved; no new blocking findings.
