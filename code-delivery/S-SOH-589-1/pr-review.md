## PR Review: S-SOH-589-1 — id-absent editmeta allowedValues fix (PR #601)

**Verdict: APPROVE**

Fresh-eyes review from a different model family (Opus 4.7). No blocking findings.

### What I verified

**Correctness (7 call sites in `field_resolve.rs`):**

1. **id-bypass predicate** — uses `av.id.as_deref().map(...).unwrap_or(false)`; correctly excludes None entries from the numeric bypass. Correct.
2. **id-bypass wire emission** — `let-else` exit-64 guard; defensive (predicate already excludes None). Correct.
3. **Exact-match single wire emission** — `let-else` exit-64 guard. Correct.
4. **Exact-match multi-candidate display** — `av.id.as_deref().unwrap_or("<no-id>")`. Correct sentinel.
5. **Substring-miss `allowed_labels` display** — nested `unwrap_or_else` returning `"<no-id>"` inside the value fallback. Correct sentinel.
6. **Substring multi-candidate display** — `<no-id>` sentinel. Correct.
7. **Substring single-match wire emission** — `let-else` exit-64 guard. Correct.

All 7 call sites are handled correctly. 3 wire-emission sites use exit-64 guards; 3 display sites use the `<no-id>` sentinel; 1 predicate site uses safe `Option` combinators.

**Spec fidelity:** All 3 exit-64 messages (lines 501/527/602 on the PR branch) contain both load-bearing substrings: `"no machine-readable id"` AND `"--field"`. Verified via grep.

**Architecture constraints:** Files changed = `CHANGELOG.md`, `src/cli/issue/field_resolve.rs`, `src/types/jira/editmeta.rs`, `tests/issue_edit_field.rs`. No changes to `edit.rs`, `issues.rs`, or `mod.rs` — story constraint satisfied.

**Test coverage:**

- **AC-001** (non-targeted idless succeeds): `test_bc_3_4_015_editmeta_idless_allowed_values_on_non_targeted_field_succeeds` — verifies exit 0 + PUT dispatched + stderr echo `"Severity → Critical"`.
- **AC-002** (targeted idless exits 64): `test_bc_3_4_016_option_idless_allowed_value_exits_64_with_actionable_message` — verifies exit 64 + both load-bearing substrings; PUT mock deliberately absent.
- **AC-003** (dry-run idless exits 0): `test_bc_3_4_015_field_dry_run_idless_nontargeted_allowedvalues_exits_0` — verifies exit 0 + planned-changes preview + no PUT.
- **AC-004** (unit deser id=None): `test_allowed_value_without_id_deserializes_to_none` — explicit `id.is_none()` pin.
- **Substring-match arm** (adv-p2-F1): `test_bc_3_4_016_option_idless_substring_match_exits_64` — cleverly uses `"High-Priority"` fixture with input `"high"` to force exact-miss then substring-hit path.
- **EC-006** id-bypass exclusion (adv-p4): `test_bc_3_4_016_option_idless_numeric_value_falls_through_to_label_matching` — verifies the numeric-bypass predicate correctly excludes None-id entries so wire emission never emits an id-null payload.

**CHANGELOG:** Entry present under `[Unreleased] > Fixed`, cites #589.

**Type change safety:** Backward-compatible for all id-present cases (all 56 pre-existing `issue_edit_field` tests remain green per PR body). Serde reads `Option<T>` as `None` when the key is absent — exactly the desired semantics; an empty-string id would NOT be produced (the rejected alternative `#[serde(default)]` was correctly ruled out in the inline ADR).

**Adversarial trajectory:** 3→4→0→1→0→0→0 across 7 passes; STRICT CONVERGED with clean p5/p6/p7 window. Fix rounds are visibly reflected in the diff — p1 F1 defensive-guard annotation is on the id-bypass wire-emission site; p1 F2/F3 tightened AC-003 assertion (adjacency + `id.is_none()` pin) is present; p2 F1 substring test is present; p2 F2 count-free CHANGELOG phrasing is visible; p4 EC-006 test is present.

### Findings

**Finding 1 [MINOR / code-quality / simplification]**
- **File:** `src/cli/issue/field_resolve.rs` lines 501, 527, 602
- **Description:** The exit-64 error message is duplicated verbatim at three wire-emission sites. Silent divergence risk if the message is ever reworded — the two load-bearing substrings (`"no machine-readable id"`, `"--field"`) must stay together at every site.
- **Suggestion:** Extract to a `const IDLESS_OPTION_ERR_TEMPLATE: &str` or a helper `fn err_idless_option(value: &str) -> JrError`. Not a blocker — every path is covered by tests that check both substrings.

**Finding 2 [MINOR / test-quality]**
- **File:** `tests/issue_edit_field.rs` (`test_bc_3_4_016_option_idless_numeric_value_falls_through_to_label_matching`)
- **Description:** The test rustdoc honestly documents that the `unwrap_or(false)` to `unwrap_or(true)` mutation on the id-bypass predicate is NOT killed by the test — with that mutation, `id_match = Some(av)` for the idless entry, but this still hits the defensive guard on line ~501 with the same exit 64 and same message.
- **Suggestion:** A stricter mutation-kill would require a separate id-present-numeric fixture that exercises the id-bypass wire emission on a real id (verifies the id-wired payload is emitted). Non-blocking for this PR; consider for a future test-hardening pass.

**Finding 3 [COSMETIC / style / grammar]**
- **File:** `CHANGELOG.md` line 27
- **Description:** `"If the user targets such an option entry directly, exit 64 with an actionable message is emitted instead of a serde crash."` — slightly awkward passive construction.
- **Suggestion:** `"If the user targets such an option entry directly, jr exits 64 with an actionable message instead of a serde crash."`

**No BLOCKING findings.**

### Verdict Rationale

The fix is minimum-viable, correctly scoped, and defensively coded (predicate excludes None; wire-emission sites still assert with exit-64 for defense-in-depth). Tests are strong on branch coverage, load-bearing-substring pins, and the id-bypass exclusion edge case. Backward compatibility is preserved. CHANGELOG entry is present and cites the upstream issue. Architecture-constraint files were not touched. Adversarial refinement reached STRICT CONVERGED with 3 consecutive clean passes.

**APPROVE.**
