---
document_type: story
story_id: "S-421"
title: "Fix f64→i64 boundary precision bug in parsed_number_to_wire_value (two-stage parsing, refs #421)"
wave: feature-followup
status: ready
intent: bug-fix
feature_type: backend
scope: standard
severity: low
trivial_scope: false
issue: 421
points: 2
priority: low
tdd_mode: strict
estimated_effort: small
depends_on: []
bc_anchors:
  - BC-3.4.015   # EC-3.4.015-4b (new, added by F2 burst) + invariant 5 (wording updated by F2 burst)
# BC status: ready — BC-3.4.015 is the canonical anchor; EC-3.4.015-4b and invariant 5
# update land via the parallel F2 product-owner burst. The implementer verifies those landed
# (AC-008) but does NOT author them. Behavioral contract coverage is non-empty.
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-story-decomposition
spec_source: "github.com/Zious11/jira-cli/issues/421"
implementation_strategy: tdd
module_criticality: LOW
files_modified:
  - src/cli/issue/field_resolve.rs   # MODIFIED — Stage 1 i64-first parse added at call site (~lines 294-312); helper predicate tightened to strict inequalities; 7 new inline unit tests added
files_created: []
files_unchanged:
  - tests/issue_edit_field.rs        # UNCHANGED — tests 26/27 must continue to pass without modification
  - .factory/specs/prd/bc-3-issue-write.md  # MODIFIED by F2 burst (NOT the implementer)
breaking_change: false
assumption_validations: []
risk_mitigations: []
---

# S-421 — Fix f64→i64 Boundary Precision Bug in `parsed_number_to_wire_value`

## Source of Truth

GitHub issue: https://github.com/Zious11/jira-cli/issues/421
F1 delta analysis: `/Users/zious/Documents/GITHUB/jira-cli/.factory/phase-f1-delta-analysis/issue-421/delta-analysis.md`
Immediate predecessor: S-409 (same module — extract number wire helper)

## Goal

Fix the silent saturation bug in `parsed_number_to_wire_value` where integer-string inputs
at the i64 boundary (e.g., `"9223372036854775808"` = i64::MAX + 1, or `"-9223372036854775809"`
= i64::MIN - 1) are silently truncated to the nearest i64 instead of being emitted as their
correct f64 wire form. Adopt a two-stage parsing strategy (Option C per F1 analysis): i64-first
parse for exact integers, f64 fallback with strict-inequality predicate for everything else.

## Problem Statement

The predicate in `parsed_number_to_wire_value` (introduced in S-409) uses `>=` and `<=` for
both i64 bounds:

```rust
if parsed.fract() == 0.0 && parsed >= i64::MIN as f64 && parsed <= i64::MAX as f64 {
    serde_json::Value::Number(serde_json::Number::from(parsed as i64))
```

The defect: `i64::MAX as f64` does NOT equal `9223372036854775807.0`. Because f64 cannot
represent integers above 2^53 exactly, `i64::MAX` (2^63 - 1) rounds UP when cast to f64,
yielding `9223372036854775808.0` (exactly 2^63). Therefore `"9223372036854775808"` passes
the `<=` check, the `as i64` cast saturates to `9223372036854775807`, and the wire carries
the wrong value silently. The symmetric bug exists at the lower bound for inputs below
`i64::MIN`.

This was surfaced by Copilot review on PR #418 (S-409) and confirmed correct in the F1
delta analysis with step-by-step traces for both the upper and lower boundary inputs.

## Behavioral Contracts

BC-3.4.015 (invariant 5 + EC-3.4.015-4b) anchors this story. The F2 product-owner burst
running in parallel will:
- Update invariant 5 wording to describe the two-stage strategy (i64-first, f64 fallback).
- Add EC-3.4.015-4b: integer inputs outside i64 range MUST emit f64 wire form, never
  a silently-saturated i64.

The implementer verifies these landed (AC-008) but does NOT modify the BC file.

## Acceptance Criteria

### AC-001 — Two-stage call site restructure

The number-field branch in `src/cli/issue/field_resolve.rs` (currently around lines 294-312)
is restructured as a two-stage parser:

- **Stage 1:** `value.parse::<i64>()`. On success, emit
  `serde_json::Value::Number(serde_json::Number::from(n))` directly (no f64 involved).
- **Stage 2:** f64 parse + NaN/Inf rejection + call to `parsed_number_to_wire_value(parsed)`.

The `display_value = value.clone()` assignment is preserved regardless of which stage fires.

Code sketch:

```rust
"number" => {
    if let Ok(n) = value.parse::<i64>() {
        wire_value = serde_json::Value::Number(serde_json::Number::from(n));
    } else {
        let parsed: f64 = value.parse().map_err(|_| { ... })?;
        if !parsed.is_finite() { return Err(...); }
        wire_value = parsed_number_to_wire_value(parsed);
    }
    display_value = value.clone();
}
```

Verification: `grep -n "parse::<i64>()" src/cli/issue/field_resolve.rs` returns at least
one match in the `"number"` arm.

### AC-002 — Helper predicate tightened to strict inequalities

`parsed_number_to_wire_value` uses STRICT inequalities on both bounds:

```rust
if parsed.fract() == 0.0
    && parsed > (i64::MIN as f64)   // strict — see rationale
    && parsed < (i64::MAX as f64)   // strict — i64::MAX as f64 == 2^63, not 2^63-1
```

**Upper bound rationale:** `i64::MAX as f64 == 9223372036854775808.0` (2^63, not 2^63-1).
Strict `<` excludes 2^63 from i64-cast, routing it to f64 wire form.

**Lower bound rationale:** In Stage-2 context, any value equal to `i64::MIN as f64`
(-2^63) arrived from a string that underflowed i64 parse (e.g., `"-9223372036854775809"`
rounds to -2^63 in f64). Stage 1 would have handled exact i64::MIN — so if Stage 2
sees -2^63, it is from an out-of-range string and must NOT be cast to i64::MIN. Strict
`>` correctly routes it to f64 wire form.

The `debug_assert!(parsed.is_finite())` contract is unchanged.

Verification: `grep -A3 "fn parsed_number_to_wire_value" src/cli/issue/field_resolve.rs`
shows both `>` (not `>=`) for the MIN bound and `<` (not `<=`) for the MAX bound.

### AC-003 — 7 new boundary unit tests in `field_resolve.rs::tests`

The `#[cfg(test)]` module in `src/cli/issue/field_resolve.rs` gains 7 new unit tests
exercising the two-stage parse path end-to-end (not just the helper in isolation):

| Test name | Input str | Expected wire form | Stage |
|-----------|-----------|-------------------|-------|
| `test_parse_number_i64_max_boundary` | `"9223372036854775807"` | i64 value `9223372036854775807` | Stage 1 |
| `test_parse_number_i64_max_plus_one_is_f64` | `"9223372036854775808"` | f64 (NOT i64 `9223372036854775807`) | Stage 2 |
| `test_parse_number_i64_min_boundary` | `"-9223372036854775808"` | i64 value `-9223372036854775808` | Stage 1 |
| `test_parse_number_i64_min_minus_one_is_f64` | `"-9223372036854775809"` | f64 (NOT i64 `-9223372036854775808`) | Stage 2 |
| `test_parse_number_2_to_53_exact_f64` | `"9007199254740992"` | i64 value `9007199254740992` | Stage 1 |
| `test_parse_number_2_to_53_plus_one_exact_i64` | `"9007199254740993"` | i64 value `9007199254740993` (bonus precision win) | Stage 1 |
| `test_parse_number_scientific_1e10_is_i64` | `"1e10"` | i64 value `10000000000` | Stage 2 (i64 parse fails on `"1e10"`; f64 predicate passes) |

All tests call the two-stage logic, not a re-implementation of the predicate. The test
for `"9007199254740993"` demonstrates the precision improvement: the old f64-only path
would have rounded this to `9007199254740992`; the new i64-first path preserves exact value.

Verification: all 7 test names are present in `field_resolve.rs`; none contain predicate
re-implementations using `fract()`, `i64::MIN`, or `i64::MAX` directly.

### AC-004 — S-409 helper unit tests continue to pass unchanged

The 6 unit tests added by S-409 (`test_parsed_number_to_wire_value_whole_integer`,
`test_parsed_number_to_wire_value_scientific_notation_whole`,
`test_parsed_number_to_wire_value_fractional`,
`test_parsed_number_to_wire_value_zero`,
`test_parsed_number_to_wire_value_negative_whole`,
`test_parsed_number_to_wire_value_out_of_i64_range`) continue to pass without modification.

Note: `test_parsed_number_to_wire_value_out_of_i64_range` uses input `1e19` (> i64::MAX).
Under the tightened predicate, `1e19 < (i64::MAX as f64)` evaluates as `1e19 < 9.22e18` —
FALSE — so f64 wire form is returned. This is unchanged behavior, still correct.

Verification: `cargo test parsed_number_to_wire_value` exits 0 with exactly 6 matches
(unchanged S-409 tests); no deletions or modifications to these tests.

### AC-005 — Integration tests 26/27 continue to pass unchanged

`test_bc_3_4_015_number_field_integer_wire_form` (test 26, `tests/issue_edit_field.rs`
line ~1661) and `test_bc_3_4_015_number_field_scientific_notation_wire_form` (test 27,
line ~1723) pass without modification.

Under the new two-stage path:
- Test 26 input `"5"`: Stage 1 `"5".parse::<i64>()` = `Ok(5)` → JSON integer `5`. Mock
  asserts `{ "customfield_20001": 5 }`. **PASSES.**
- Test 27 input `"5e3"`: Stage 1 `"5e3".parse::<i64>()` = `Err`. Stage 2 `5000.0`, strict
  predicate (`5000.0 > i64::MIN as f64 && 5000.0 < i64::MAX as f64`) passes → JSON integer
  `5000`. Mock asserts `{ "customfield_20001": 5000 }`. **PASSES.**

Verification: Both test names exist and are unmodified after S-421 changes.

### AC-006 — `cargo test` exits 0; full-suite count up by ~7

`cargo test` exits 0. Full-suite test count increases by approximately +7 (7 new unit
tests; no tests removed).

Verification: `cargo test 2>&1 | tail -5` shows `test result: ok`.

### AC-007 — Lint and format clean

`cargo fmt --all -- --check` exits 0.
`cargo clippy --all-targets -- -D warnings` exits 0.

No `#[allow(...)]` attributes added. If clippy warns on comparison involving cast
(e.g., `clippy::cast_precision_loss` or similar), the expression is refactored to
preserve identical semantics — not suppressed.

### AC-008 — F2 spec changes verified landed (DO NOT modify BC file)

The implementer verifies (READ ONLY) that `.factory/specs/prd/bc-3-issue-write.md`
contains:
- EC-3.4.015-4b (new edge case for i64-boundary class).
- Updated invariant 5 wording referencing the two-stage strategy.

If these are NOT present when the implementer begins work, stop and flag to the
orchestrator — the F2 burst may not have completed. Do not proceed to modify the BC
file; it is owned by the product-owner burst.

Verification: `grep -n "EC-3.4.015-4b" .factory/specs/prd/bc-3-issue-write.md` returns
at least one match.

## Implementation Strategy

This is a small, self-contained bug fix. No new dependencies, no public API change, no
CLI surface change.

**Ordered sequence:**

1. **Create branch** `fix/S-421-parsed-number-i64-bounds` from `develop`.

2. **Verify F2 burst landed** (AC-008): read `.factory/specs/prd/bc-3-issue-write.md`
   and confirm EC-3.4.015-4b and updated invariant 5 are present. If not, stop and
   report to orchestrator.

3. **Read `src/cli/issue/field_resolve.rs`** around lines 290-320 to confirm the exact
   current text of the `"number"` arm and the `parsed_number_to_wire_value` helper body.
   Do NOT use line numbers from this story as ground truth — verify against the actual
   file at the time of implementation.

4. **Restructure the `"number"` arm** (AC-001): add Stage 1 `value.parse::<i64>()` check
   before the existing f64 parse. Preserve `display_value = value.clone()` in both branches.

5. **Tighten the helper predicate** (AC-002): change `>=` to `>` for MIN bound and `<=`
   to `<` for MAX bound. Update the helper's rustdoc to document:
   - It is ONLY called from Stage 2 (f64-fallback path; never for i64-representable inputs).
   - Both bounds are strict for Stage-2 correctness (see AC-002 rationale).
   - `debug_assert!(parsed.is_finite())` contract unchanged.

6. **Add 7 unit tests** in the existing `#[cfg(test)] mod tests` block at the bottom of
   `field_resolve.rs` (AC-003). Tests must call the two-stage path, not re-implement
   the predicate.

7. **Verify S-409 unit tests unmodified** (AC-004): `grep` for all 6 S-409 test names.

8. **Run `cargo test`** — must exit 0; verify tests 26/27 pass (AC-005, AC-006).

9. **Run `cargo fmt --all -- --check`** — must exit 0 (AC-007).

10. **Run `cargo clippy --all-targets -- -D warnings`** — must exit 0 (AC-007).

11. **Run `bash scripts/check-spec-counts.sh`** — must exit 0 (no BC frontmatter touched
    by the implementer).

12. **Run `bash scripts/check-bc-cumulative-counts.sh`** — must exit 0.

13. **Run `bash scripts/check-bc-no-numeric-test-counts.sh`** — must exit 0.

14. **Commit** with:
    `fix(field_resolve): two-stage i64-first parse + strict bounds in parsed_number_to_wire_value (closes #421)`

15. **Open PR** targeting `develop`; body includes `Closes #421`.

## Out of Scope

- **Adding integration test coverage** of boundary inputs via wiremock. Unit tests in
  `field_resolve.rs::tests` are sufficient regression pins. Wiremock setup for f64 wire
  forms with `NumericMode::Strict` would add significant boilerplate for marginal value.
- **Renaming the helper** to `f64_fallback_to_wire_value`. The Stage-2 semantics are
  documented in rustdoc; a rename would require updating S-409 AC references and is
  cosmetic.
- **Changing the helper signature** (`parsed: f64` remains). Only the call site adds the
  i64-first attempt before invoking the helper. Keeping the signature stable avoids
  cascading changes to S-409 unit tests.
- **Performance optimization.** The i64-first parse adds one parse attempt for non-integer
  inputs (e.g., `"5.5"`) — microseconds, irrelevant for a CLI tool.
- **Handling `--field` for request-type JSM fields** — separate concern, already
  documented in CLAUDE.md.

## Test Coverage Strategy

| Test type | Count | Location | What it tests |
|-----------|-------|----------|---------------|
| Unit tests — boundary regression pins (NEW) | 7 | `field_resolve.rs::tests` | Two-stage path end-to-end: i64::MAX, i64::MAX+1, i64::MIN, i64::MIN-1, 2^53, 2^53+1, 1e10 |
| Unit tests — S-409 helper coverage (UNCHANGED) | 6 | `field_resolve.rs::tests` | Helper for: whole int, scientific-notation whole, fractional, zero, negative whole, out-of-range |
| Integration tests (UNCHANGED) | 2 | `tests/issue_edit_field.rs` (tests 26, 27) | End-to-end wire form via wiremock NumericMode::Strict |

Net suite delta: +7 (7 new tests, none removed).

## Quality Gate Self-Check

| Criterion | Required | Notes |
|-----------|----------|-------|
| `cargo test` exits 0 | MUST | Full suite green; ~7 new passes |
| `cargo fmt --all -- --check` exits 0 | MUST | AC-007 |
| `cargo clippy --all-targets -- -D warnings` exits 0 | MUST | AC-007; no `#[allow]` additions |
| AC-003 — 7 new boundary tests present | MUST | Grep for test names |
| AC-004 — S-409 unit tests unmodified | MUST | 6 names present, not modified |
| AC-005 — integration tests 26/27 still present and passing | MUST | Regression pin |
| AC-008 — F2 BC changes verified landed (read-only) | MUST | `grep "EC-3.4.015-4b"` in BC file |
| `bash scripts/check-spec-counts.sh` exits 0 | invariant | No BC frontmatter touched by implementer |
| `bash scripts/check-bc-cumulative-counts.sh` exits 0 | invariant | No count surfaces touched |
| `bash scripts/check-bc-no-numeric-test-counts.sh` exits 0 | invariant | No BC bodies with numeric test counts changed |

## Token Budget Estimate

| Item | Tokens (approx) |
|------|----------------|
| This story file | ~4 k |
| `src/cli/issue/field_resolve.rs` (full file, ~430-450 LOC post-S-409) | ~6 k |
| `tests/issue_edit_field.rs` (targeted scan: tests 26/27, ~100 LOC each) | ~3 k |
| `.factory/specs/prd/bc-3-issue-write.md` (read-only verification of EC-3.4.015-4b) | ~2 k |
| F1 delta analysis (reference for Option C rationale) | ~4 k |
| Tool outputs (cargo test, fmt, clippy, script exits) | ~2 k |
| **Total** | **~21 k** |

Well within a single-agent context window. No split required.
LOC delta: `field_resolve.rs` +~40 LOC net (Stage 1 branch ~5 LOC, updated helper doc ~5 LOC,
7 unit tests ~35 LOC; predicate change is 2 chars — `>= → >` and `<= → <`).

## Tasks

- [ ] Create branch `fix/S-421-parsed-number-i64-bounds` from `develop`
- [ ] Verify F2 burst landed: `grep "EC-3.4.015-4b" /Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/bc-3-issue-write.md` — exits with match; if not, stop and report
- [ ] Read `src/cli/issue/field_resolve.rs` lines ~285-325 — confirm exact text of `"number"` arm and `parsed_number_to_wire_value` helper
- [ ] Add Stage 1 `value.parse::<i64>()` arm before f64 parse in the `"number"` branch (AC-001)
- [ ] Tighten helper predicate: `>= → >` for MIN bound, `<= → <` for MAX bound (AC-002)
- [ ] Update helper rustdoc: Stage-2-only semantics, strict bound rationale, `debug_assert` unchanged
- [ ] Add 7 boundary unit tests in `field_resolve.rs::tests` (AC-003)
- [ ] Grep for S-409 test names — confirm all 6 present and unmodified (AC-004)
- [ ] Run `cargo test` — exits 0; net count +7 (AC-006)
- [ ] Run `cargo test test_bc_3_4_015_number_field_integer_wire_form test_bc_3_4_015_number_field_scientific_notation_wire_form` — both pass (AC-005)
- [ ] Run `cargo fmt --all -- --check` — exits 0 (AC-007)
- [ ] Run `cargo clippy --all-targets -- -D warnings` — exits 0 (AC-007)
- [ ] Run `bash scripts/check-spec-counts.sh` — exits 0
- [ ] Run `bash scripts/check-bc-cumulative-counts.sh` — exits 0
- [ ] Run `bash scripts/check-bc-no-numeric-test-counts.sh` — exits 0
- [ ] Commit: `fix(field_resolve): two-stage i64-first parse + strict bounds in parsed_number_to_wire_value (closes #421)`
- [ ] Open PR targeting `develop`; body: `Closes #421`

## Previous Story Intelligence

**Direct predecessor: S-409** (same module — extract `parsed_number_to_wire_value` helper).
S-409 introduced the helper with the broken predicate verbatim from S-396. Copilot review
on PR #418 (S-409) surfaced the boundary defect; issue #421 was filed immediately. This
story is the natural follow-on to S-409.

**Key lesson from S-409:** when extracting a helper, copy the predicate verbatim — but
flag any correctness concerns before closing the issue. The tautological test 38 that S-409
removed was masking this bug: because test 38 re-implemented the predicate from scratch,
it was passing even with the broken `<=` — it validated the test's own copy, not the
production code.

**Key lesson for this story:** The fix must be Option C (i64-first + tightened predicate),
not Option B (i64-first only). Option B retains the broken predicate in the f64 fallback
and does NOT fix the `"9223372036854775808"` case — the F1 delta analysis confirms this
with a full step-trace. Any implementation that only adds Stage 1 without tightening the
predicate is incomplete.

**Key lesson from S-396/S-407 lineage:** strict inequality at both bounds is the correct
design when the cast target cannot represent the cast source's full range. The `>=`/`<=`
form is a natural mistake; the strict form requires reasoning about f64 representation of
boundary integers.

## Architecture Compliance Rules

1. **`pub(crate)` visibility retained.** `parsed_number_to_wire_value` remains `pub(crate)`.
   No new public exports.

2. **No new module files.** All changes are within `field_resolve.rs`. Do not create a
   `number_wire.rs` or similar split.

3. **No behavior change for inputs within i64 range.** For any input that
   `value.parse::<i64>()` accepts (integers in `[i64::MIN, i64::MAX]`), the wire form is
   still JSON integer. For inputs Stage 1 rejects (decimals, scientific notation, out-of-range
   integers), the observable wire form is unchanged EXCEPT for the buggy boundary class
   (`"9223372036854775808"` and `"-9223372036854775809"` and their out-of-range siblings),
   which now correctly emit f64.

4. **Unit tests must call the two-stage logic path.** Tests that directly call
   `parsed_number_to_wire_value(f64)` are acceptable for the S-409 coverage continuation,
   but the 7 new boundary tests should exercise the full `value: &str → wire value` path
   (i.e., the full two-stage dispatch), not just the helper in isolation. This ensures the
   routing logic is covered, not just the helper predicate.

5. **No `#[allow]` lint suppressions.** If clippy warns on the comparison expression
   (e.g., casting concerns), refactor to satisfy the lint with identical semantics.

6. **`display_value = value.clone()` placement.** This must be set regardless of which
   stage fires (Stage 1 or Stage 2). Do not accidentally scope it inside only one branch.

## Library & Framework Requirements

No new dependencies. No version changes. All code uses only:
- `serde_json` (existing direct dependency, pinned in `Cargo.toml`)
- Rust standard library `str::parse::<i64>()` and `str::parse::<f64>()` (no crate needed)

## File Structure Requirements

| File | Action | Notes |
|------|--------|-------|
| `/Users/zious/Documents/GITHUB/jira-cli/src/cli/issue/field_resolve.rs` | Modify | Stage 1 branch + tightened predicate + updated rustdoc + 7 unit tests |
| `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/bc-3-issue-write.md` | READ ONLY (verify) | Modified by F2 product-owner burst, NOT the implementer |
| `/Users/zious/Documents/GITHUB/jira-cli/tests/issue_edit_field.rs` | UNCHANGED | Tests 26/27 must pass; no edits permitted |

**Files NOT to create:** No new source files, no new spec files, no new test files.

**Files NOT to touch:** All other `src/` files, `Cargo.toml`, `deny.toml`,
`STORY-INDEX.md` (state-manager updates that), all BC count surfaces (frontmatter,
BC-INDEX.md, CANONICAL-COUNTS.md), `.factory/specs/prd/bc-3-issue-write.md`
(product-owner only).

## Branch / PR Plan

- Branch: `fix/S-421-parsed-number-i64-bounds`
- Target: `develop`
- Commit style: `fix(field_resolve): two-stage i64-first parse + strict bounds in parsed_number_to_wire_value (closes #421)`
- PR closes: `Closes #421`
- CHANGELOG entry: Yes — user-visible behavior change for boundary inputs. Add under
  `### Fixed`: "Number field values at the i64 boundary (e.g., `9223372036854775808`)
  now emit the correct f64 wire form instead of being silently saturated to i64::MAX."
