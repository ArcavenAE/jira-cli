---
document_type: verification-delta
cycle: cycle-009
feature_slug: jql-relative-date-units
created: 2026-09-22
status: draft
new_vps: []
---

# Verification Delta: jql-relative-date-units (cycle-009)

## Question

Does the `jql-relative-date-units` delta (narrowing `src/jql.rs::validate_duration`'s
accepted relative-date unit set from `{y, M, w, d, h, m}` to `{w, d, h, m}`, per
BC-2.1.008/BC-2.1.023 amendments in `prd-delta.md`) warrant a new VP-NNN?

## Decision

**NO new VP-NNN is introduced by this delta.**

## Reasoning

1. **Panic-safety property already covers the narrowed input space.**
   `src/jql.rs`'s existing `validate_duration_never_panics` proptest (arbitrary-string
   input, `s in ".*"`, per the FIX-F6-LRE-1/#734 multibyte-panic-safety lineage) asserts
   `validate_duration` never panics for ANY input string. Narrowing the accepted unit set
   from 6 chars to 4 does not change the function's control-flow shape in a way that could
   introduce a new panic path — it is a `matches!` arm-set reduction plus a `format!`
   string-literal change, both of which the existing property already generalizes over
   (the property is defined over "any string", not "any string containing one of the
   previously-accepted units"). No gap here.

2. **Rejection-behavior (exit 64, zero HTTP) is a behavioral/integration property, not a
   formal-verification property**, and is properly owned by F4's new CR-004 test, not a
   VP-NNN. VP-NNN in this codebase's convention (see VP-UPDATED-RECENT-001/002 in
   `bc-2-issue-read.md`) are used for structural/compositional properties of clause-building
   and pre-HTTP validation gating — properties that are stable across the specific unit set
   accepted. VP-UPDATED-RECENT-001 already states: "combined-unit durations are rejected
   pre-HTTP with zero `POST /rest/api/3/search/jql` calls ... via the identical
   `jql::validate_duration` error shape BC-2.1.008 already pins for `--recent`." This
   property's *shape* (validator rejects invalid input pre-HTTP, zero HTTP calls follow) is
   unchanged by narrowing which specific inputs are "invalid" — `M` and `y` simply join the
   set of inputs this already-proven property applies to. I amended VP-UPDATED-RECENT-001
   in `bc-2-issue-read.md` with a dated clarifying note recording this extension explicitly,
   rather than minting a new VP-NNN for what is a parametric extension of an existing
   property, not a new property.

3. **No new formal/mathematical property is introduced.** `validate_duration` remains a
   pure function; the change is a data-set narrowing (accepted chars) plus a string-literal
   update. There is no new invariant, no new state machine, no new concurrency property, no
   new security boundary — the classes of things this codebase mints VP-NNNs for (see
   `.factory/specs/verification-architecture/ARCH-INDEX.md` conventions: VPs back proptest
   strategies, Kani proofs, fuzz targets, or structural compositional assertions, not every
   individual edge-case behavior — individual edge cases live as EC-NNN entries in the BC
   body and get integration-test coverage, which is what EC-2.1.023-5 plus F4's CR-004 test
   provide here).

4. **Coverage after this delta, concretely:**
   - Panic-safety across the narrowed unit set: `validate_duration_never_panics` (existing,
     `src/jql.rs`, unaffected by this delta, still exercises the changed function).
   - Rejection behavior + error-string correctness for `M`/`y` specifically: two existing
     unit tests currently assert ACCEPTANCE (`validate_duration_valid_months_uppercase`,
     `validate_duration_valid_years`) — F1 flagged these MUST FLIP to
     `validate_duration_rejects_months`/`validate_duration_rejects_years` in F4. This is a
     test-suite change, not a VP change (no VP currently cites these two tests by name).
   - End-to-end (`jr issue list --recent 2M`/`1y` → exit 64, zero HTTP): **confirmed gap at
     F1 (CR-004, HIGH)** — no existing integration test proves this. F4 must add it. This is
     new *test* coverage, still not a new *VP*, since VP-UPDATED-RECENT-001's existing
     structural claim ("rejected pre-HTTP, zero HTTP calls") already covers the property
     the new test will assert against a wider input set.

## F7 Delta-Convergence Acceptance Gate [ADDED 2026-09-22, F2-ADV-M1]

The no-new-VP decision above is backed by F4's new CR-004 integration test, not by a formal
VP-NNN. To make that reliance enforceable rather than aspirational, F7 (delta convergence)
MUST verify the following concrete gate before this delta can be considered converged:

1. **CR-004 rejection assertions (4 total).** The F4 CR-004 integration test MUST assert
   exit-64 + zero-HTTP-calls (`.expect(0)` on the mocked search endpoint) for BOTH of:
   - `2M` (uppercase months, the silent-mis-parse footgun case)
   - `1y` (lowercase years, the pre-fix HTTP-400 case)

   ...on BOTH of:
   - `jr issue list --recent <value>`
   - `jr issue list --updated-recent <value>`

   i.e. the 2×2 matrix `{2M, 1y} × {--recent, --updated-recent}` = 4 required assertions,
   each independently verifying exit code 64 and zero HTTP calls to the search endpoint.

2. **Case-boundary assertion (1 additional).** CR-004 MUST additionally assert the
   case-sensitivity boundary documented in BC-2.1.023 EC-2.1.023-5's "Client
   case-sensitivity rule": `1M` (uppercase months) is REJECTED, while a lowercase minutes
   value in the same shape (e.g. `30m`) is ACCEPTED-shape (i.e. does not error at the
   `validate_duration` stage — proceeds to composing the JQL clause). This is the test-level
   enforcement of the case-sensitivity clarification added in response to F2-ADV-H1: it
   proves the narrowed arm set is exactly `{w, d, h, m}` lowercase, not a case-insensitive
   widening or narrowing in disguise.

3. **F7 gate criterion.** F7's delta-convergence check for this cycle MUST fail closed if
   `tests/issue_commands.rs` (or wherever F4 lands CR-004) does not contain all 5 assertions
   above (4 rejection + 1 case-boundary) by name or clearly attributable test-body coverage.
   This is recorded here as the F7 acceptance criterion for EC-2.1.023-5 coverage — F7 should
   cite this section directly rather than re-deriving the coverage requirement from scratch.

## What Would Change This Decision

If a future delta introduced a *new* validation grammar (e.g., a general-purpose date-range
DSL replacing the current `{w,d,h,m}` single-char-suffix scheme) rather than narrowing the
existing one, that would warrant a new VP-NNN (new state space, new proptest strategy). This
delta is a pure narrowing of an existing, already-proven-total function's accepted-input
predicate — it does not meet that bar.

## Architecture / VP-INDEX Impact

No VP citations changed. No dispatch to `architect` for VP-INDEX/verification-architecture
propagation is required under `vp_index_is_vp_catalog_source_of_truth` — this delta adds no
new VP-NNN and modifies no existing VP-NNN's citation targets (only its prose gains a
clarifying note; the VP ID, its proof strategy, and what it covers are unchanged).

## Recommendation to Orchestrator

No `formal-verifier` dispatch is warranted for a dedicated VP-authoring burst on this delta.
If the human disagrees with this reasoning (e.g., wants a dedicated VP-NNN asserting the
narrowed unit-rejection property as a first-class formal property rather than an EC + test),
flag back and `formal-verifier` can be dispatched to mint one.
