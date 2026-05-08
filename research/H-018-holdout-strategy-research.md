---
document_type: research-decision
story_id: S-2.06
holdout_id: H-018
producer: research-agent
date: 2026-05-08
tools_used: [perplexity, read]
recommendation: "4 (other) — REPLACE H-018 (option 2) AND in a follow-up story replace the format_duration round-trip proptest with a regex/structural property so the deprecated parse_duration calculator can be deleted entirely. Option 2 is the immediately correct holdout edit; option 4 is the broader cleanup that resolves the root cause."
confidence: HIGH
---

# H-018 Holdout Strategy — Research Decision

## Recommendation

Pick Option 2 (REPLACE) now, queue Option 4 (rewrite proptest, delete calculator) as a follow-up.

H-018's current Expected clause asserts the *internal arithmetic* of a function with **zero production callers**. The `parse_duration(s, h, d) -> u64` calculator is a pure implementation artifact preserved only because one proptest (`format_roundtrip`) re-uses it as a convenient inverse. The user-observable contract that S-2.06 v2.0.0 actually shipped is: (a) syntax validation `parse_duration_validate("1w2d3h30m") -> Ok(())`; (b) the string `"1w2d3h30m"` is forwarded verbatim into the worklog POST body's `timeSpent` field; Jira's server computes the seconds total against its own configured working-hours-per-day.

H-018 in its current form pins behavior the **user can no longer observe** and is wired to a hardcoded `(8, 5)` assumption that S-2.06 explicitly removed because it was wrong on Jira sites configured with non-default working-hours. Per Liz Keogh's BDD/regression-test principle ("test observable outcomes, not internal logic") and Martin Fowler's GivenWhenThen guidance, holding H-018 frozen on the old arithmetic is a textbook obsolete test in Meszaros's sense.

Option 1 (SPLIT) is the wrong call: it doubles the holdout count and explicitly re-affirms that we want to pin internal arithmetic on a function with no callers — encoding the anti-pattern as policy.

Option 3 (DEFER) is acceptable as a stopgap if v2.0.0 is hot, but it deliberately maintains a known-stale acceptance test in the catalog, which corrodes the holdout suite's signal value.

The 4th option emerges from the proptest sub-question: if `format_duration` correctness is re-expressed without reusing the calculator (regex + structural assertions), then `parse_duration` (3-arg, hardcoded 8/5) has zero callers anywhere — production OR test — and is pure dead code. At that point H-018 is not just stale but pointing at code that should be deleted. Doing this cleanup in a follow-up story is the cleanest end state.

**Confidence: HIGH that Option 2 is correct now; HIGH that Option 4 should follow.**

## Industry Guidance Summary

The literature is partial but converging on this scenario. No single canonical book chapter addresses "regression-pin acceptance test for now-deprecated function with only a proptest caller" verbatim, but four threads triangulate cleanly:

- **Gerard Meszaros, *xUnit Test Patterns* (Addison-Wesley, 2007)** — catalogues "Obsolete Test" as a named test smell. The defining condition is that the test exercises behavior that is no longer required of the system. Recommended remediation is to either delete the test or refactor it to test the new contract. A test pinning arithmetic that is no longer in any production code path falls squarely under this smell.
- **Michael Feathers, *Working Effectively with Legacy Code* (2004)** — Feathers' characterization-test concept is explicitly in service of *active refactoring of code that has callers*. Feathers does not advocate retaining characterization tests on dead code.
- **Liz Keogh (BDD)** — "BDD regression tests should describe scenarios that matter to the user; they should die when the scenarios stop mattering."
- **Martin Fowler, "GivenWhenThen"** — acceptance tests should target observable outcomes, not implementation choices. The seconds-total of `parse_duration` is no longer an observable outcome of the `jr` binary post-S-2.06.

What the literature is silent on: there is no published guidance specifically saying "if a deprecated function has a proptest caller, retain the holdout." That case is novel enough that I won't claim a citation exists. I am reasoning by composition: Meszaros says the test is obsolete; Keogh/Fowler say acceptance tests track user behavior; Feathers says characterization tests retire with their target.

## Concrete Examples from Major Projects

**(a) Kubernetes — kubernetes/kubernetes#78891 (E2E tests for deprecated APIs).** Project policy: "If they are explicitly testing a deprecated feature, then we still need to do that until the deprecation period is over, after which the tests can be removed." This applies during a public deprecation window with users still calling the API. It does NOT advocate retaining E2E tests on internal helpers with zero callers.

**(b) Rust standard library — `#[deprecated]` attribute behavior (RFC 1270).** When std deprecates a function, regression tests for the deprecation attribute itself are retained, but tests for the value the deprecated function returns are typically deleted alongside the function in the eventual removal PR.

**(c) Property-based test suites (proptest's own examples + Hypothesis test corpus)** — both proptest's documentation and Hypothesis's test-the-untestable patterns advocate constructing properties that do not require an inverse function when one isn't needed for production. The standard refactor when a round-trip's inverse becomes dead code is to rewrite the property to use a structural assertion (regex match, parser invariants, or hand-rolled expected outputs) rather than retain the inverse for the test's sake.

## The Proptest-Coupling Sub-Question

Direct read of `src/duration.rs:226-233` shows:

```rust
#[test]
fn format_roundtrip(seconds in (1u64..86400).prop_filter("divisible by 60", |s| s % 60 == 0)) {
    let formatted = format_duration(seconds);
    let reparsed = parse_duration(&formatted, 8, 5).unwrap();
    if seconds < 28800 {
        prop_assert_eq!(reparsed, seconds, ...);
    }
}
```

Observations:
1. The proptest is heavily guarded — `if seconds < 28800` skips any value that would hit the day/week branches of `parse_duration`. So the property only round-trips through h/m units. The (8, 5) arguments are **never actually exercised** because the test bails before any value can produce a `d` or `w` token.
2. Preserving production code only because a single proptest uses it as an inverse is a recognized anti-pattern (Enterprise Craftsmanship "code pollution").
3. The alternative property is essentially trivial. Three options, increasing rigor:
   - **Regex assertion**: `format_duration(n)` must match `^(0m|[1-9]\d*m|[1-9]\d*h|[1-9]\d*h[1-9]\d*m)$`
   - **Structural assertion**: parse the formatted output yourself in the test (10 lines), split on `h`, sum `hours*3600 + minutes*60`, compare to input
   - **Tabled examples**: hand-constructed `(seconds, expected_string)` pairs for the 3-branch match

   Recommendation: structural assertion (smallest diff; keeps proptest generation).

## VSDD-Internal Alignment

The holdout-scenarios.md preamble (lines 1-30) does NOT contain an explicit policy paragraph about deprecated-behavior holdouts, but its framing implicitly favors Option 2:

- Line 20: "evaluator gets binary + fixture data, NOT source code or this document. Expected outputs are precise."
- Line 22-26: setup framing assumes the evaluator runs the binary against a wiremock and asserts on stdout/stderr/exit code shapes.

H-018 is already an outlier in this catalog because it tests a Rust function call directly rather than binary observable behavior. The preamble's "binary + fixture data" framing argues that *all* holdouts should ideally pin user-observable behavior, and library-level holdouts only earn their place when the helper is the ground truth for a user-observable contract. `parse_duration` no longer is.

**Recommendation:** add an explicit "holdouts pin user-observable behavior; if the target becomes an internal helper with no production caller, retire or rewrite the holdout in the same story" sentence to the preamble in the follow-up story.

## Decision Tree

| Condition | Action |
|---|---|
| Behavior is user-observable AND production callers exist AND contract unchanged | No change. Holdout stands. |
| Behavior is user-observable AND production contract changed in this story | Option 2 (REPLACE). Rewrite Expected to match the new contract; same H-ID. |
| Behavior is no longer user-observable AND target function has zero production callers AND target retains test-only callers | Option 2 now + Option 4 follow-up. Replace the holdout with the new user-observable contract; in a follow-up story, refactor the test-only caller to remove the dependency, then delete the dead function. |
| Behavior is no longer user-observable AND target function has zero callers anywhere (incl. tests) | Option 4 directly. Delete the holdout and the dead function in one PR. |
| Public deprecation window in effect (external consumers still call the API) | Option 1 (SPLIT) or DEFER. Keep a holdout pinning the deprecated behavior until the removal release. |
| Replacement requires non-trivial design thought AND release pressure is high | Option 3 (DEFER) as a stopgap only. Log in drift-items with explicit "obsolete per Meszaros; rewrite scheduled for next iteration." Do not let DEFER calcify. |

## Citations

- Meszaros, *xUnit Test Patterns*: https://martinfowler.com/books/meszaros.html
- Meszaros, "Obsolete Test" smell: http://xunitpatterns.com (search "Obsolete Test")
- Feathers, *Working Effectively with Legacy Code*: https://www.oreilly.com/library/view/working-effectively-with/0131177052/
- Liz Keogh on BDD regression tests: https://lizkeogh.com/2007/10/25/bdd-regression-testing-and-some-feature-requests/
- Martin Fowler, "GivenWhenThen": https://martinfowler.com/bliki/GivenWhenThen.html
- Kubernetes E2E + deprecated APIs (kubernetes#78891): https://github.com/kubernetes/kubernetes/issues/78891
- Kubernetes deprecation policy: https://kubernetes.io/blog/2023/11/16/kubernetes-1-29-upcoming-changes/
- Rust deprecation RFC 1270: https://rust-lang.github.io/rfcs/1270-deprecation.html
- Rust rustdoc deprecation rendering (rust#79304): https://github.com/rust-lang/rust/issues/79304
- proptest book: https://altsysrq.github.io/proptest-book/print.html
- Enterprise Craftsmanship, "code pollution": https://enterprisecraftsmanship.com/posts/code-pollution/
