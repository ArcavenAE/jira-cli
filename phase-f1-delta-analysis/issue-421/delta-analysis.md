---
document_type: delta-analysis-report
feature_name: "Tighten i64 bounds check in parsed_number_to_wire_value (precision edge case)"
issue: 421
created: 2026-05-27
spec_version_at_analysis: "F2-post-S-409"
status: draft
intent: "bug-fix"
feature_type: "backend"
severity: "LOW"
trivial_scope: false
---

# Delta Analysis Report: Issue #421 — i64 bounds check in `parsed_number_to_wire_value`

## Feature Request

- **Brief:** Issue #421 — tighten i64 bounds check in `parsed_number_to_wire_value` (precision edge case)
- **Requested by:** Copilot review on PR #418 (S-409); filed by Zious11 (Jared Richards)
- **Date:** 2026-05-27

---

## Classifications

### Intent Classification

**Classified intent:** `bug-fix`

**Rationale:** This is a pre-existing correctness defect (silent wrong-value emission for inputs at the
i64 boundary) carried from S-396 and extracted byte-identically by S-409. The issue does not add
capability; it fixes a predicate that passes a value that should be rejected or routed to f64 emission.

### Feature Type Classification

**Classified type:** `backend`

**Rationale:** Entirely within `src/cli/issue/field_resolve.rs::parsed_number_to_wire_value`. No CLI
surface change, no protocol change, no new API calls, no UI involved. Pure numeric serialization logic.

### Trivial Scope Classification

**Classified scope:** `standard` (not trivial)

**Rationale:** Although the code change is small (estimated ~10–15 LOC), the fix changes the helper
signature or internal routing logic, requires new unit tests pinning the boundary inputs, and has a
subtle correctness dimension that demands careful reasoning. The `trivial_scope=false` designation is
correct:

- [ ] Impact boundary: single module (field_resolve.rs) — PASSES
- [ ] No new BCs needed — PASSES (existing BC-3.4.015 covers this; one EC clarification needed)
- [ ] No architecture change — PASSES
- [ ] No new external dependencies — PASSES
- [x] Regression risk: LOW — but the behavior change (f64 output instead of i64 for a boundary input)
      must be verified against existing tests 26 and 27

Not all trivial criteria are met without qualification; standard routing is appropriate.

---

## Bug Confirmation

### The Core Defect (lines 24–28, `field_resolve.rs`)

The predicate on line 24:

```rust
if parsed.fract() == 0.0 && parsed >= i64::MIN as f64 && parsed <= i64::MAX as f64 {
    serde_json::Value::Number(serde_json::Number::from(parsed as i64))
```

The defect: `i64::MAX as f64` does NOT equal `9223372036854775807.0`. Because f64 cannot exactly
represent integers above `2^53`, `i64::MAX` (`9223372036854775807 = 2^63 - 1`) rounds UP when cast
to f64, yielding `9223372036854775808.0` (exactly `2^63`). In Rust, `i64::MAX as f64 == 9.223372036854776e18`
and that literal is `2^63`.

### Step-Trace: Input `"9223372036854775808"` (i64::MAX + 1 = 2^63)

**Before any fix — current behavior (INCORRECT):**

1. `value.parse::<f64>()` — succeeds; `"9223372036854775808"` parses to `9223372036854775808.0`
   (f64 can represent `2^63` exactly).
2. `parsed.is_finite()` — true; passes the NaN/Inf guard.
3. `parsed_number_to_wire_value(9223372036854775808.0)` is called.
4. Inside the helper: `parsed.fract() == 0.0` — TRUE (whole number).
5. `parsed >= i64::MIN as f64` — TRUE (`i64::MIN as f64` = `-9223372036854775808.0`).
6. `parsed <= i64::MAX as f64` — TRUE because `i64::MAX as f64 == 9223372036854775808.0`,
   and `9223372036854775808.0 <= 9223372036854775808.0` is true.
7. Branch taken: `serde_json::Number::from(parsed as i64)`.
8. `9223372036854775808.0 as i64` — since Rust 1.45, f64→i64 cast saturates. `2^63` exceeds
   i64 range, so it saturates to `i64::MAX` = `9223372036854775807`.
9. Wire output: JSON integer `9223372036854775807`.

**User supplied `"9223372036854775808"`, wire carried `9223372036854775807`. Off by 1. Silent.**

---

### Does Option B Alone Fix the Bug?

**NO. Option B alone does NOT fix the bug for all boundary inputs.**

The issue prompt's analysis is CORRECT. Here is the step-trace for `"9223372036854775808"` under
Option B:

**Option B only (i64-first parse, f64 fallback with unchanged predicate):**

1. `value.parse::<i64>()` for `"9223372036854775808"` — FAILS (overflow; i64 max is `9223372036854775807`).
2. Fall back to `value.parse::<f64>()` — succeeds: `9223372036854775808.0`.
3. NaN/Inf guard passes.
4. `parsed_number_to_wire_value(9223372036854775808.0)` called (same broken predicate).
5–9. Identical to the current behavior trace above.

**Result under Option B alone: still emits `9223372036854775807` (wrong value). Bug NOT fixed.**

The f64 fallback path in Option B still inherits the same broken upper-bound predicate. Option B
only eliminates the bug for inputs that parse cleanly as i64 (i.e., `<= 9223372036854775807`). For
the specific boundary class `[9223372036854775808, 2^64)` (values that fail i64 parse but whose f64
representation equals or exceeds `2^63`), the bug persists.

---

## Symmetric Analysis: Lower Bound

For completeness: does the same issue exist at the lower bound?

`i64::MIN` = `-9223372036854775808` = exactly `-2^63`. f64 CAN represent `-2^63` exactly (it is a
power of two). So `i64::MIN as f64 == -9223372036854775808.0` is exact. For input `"-9223372036854775808"`:

- `value.parse::<f64>()` → `-9223372036854775808.0` (exact).
- `parsed >= i64::MIN as f64` → `-9223372036854775808.0 >= -9223372036854775808.0` → TRUE.
- `parsed as i64` → `-9223372036854775808` = `i64::MIN` (exact, no saturation needed).

**The lower bound is safe.** `-2^63` is exactly representable, so the `>=` comparison is correct and
the cast is lossless. Only the upper bound is broken.

For input `"-9223372036854775809"` (i64::MIN - 1):

- `value.parse::<f64>()` → `-9223372036854775808.0` (f64 rounds to the nearest representable value,
  which is `-2^63`). This is where a subtle SECONDARY BUG may exist (flagged below).

---

## FLAG: Secondary Precision Bug at i64::MIN - 1

**Input: `"-9223372036854775809"` (i64::MIN - 1)**

1. `value.parse::<f64>()` — f64 cannot represent `-(2^63 + 1)`; rounds to `-9223372036854775808.0` (`-2^63`).
2. `parsed.fract() == 0.0` — TRUE.
3. `parsed >= i64::MIN as f64` — `-9223372036854775808.0 >= -9223372036854775808.0` — TRUE.
4. `parsed <= i64::MAX as f64` — `-9223372036854775808.0 <= 9223372036854775808.0` — TRUE.
5. `parsed as i64` — `-9223372036854775808.0 as i64` = `i64::MIN` (exact).
6. Wire output: JSON integer `-9223372036854775808`.

**User supplied `"-9223372036854775809"`, wire carried `-9223372036854775808`. Off by 1. Silent.**

This is a mirror of the upper-bound bug. The fix design must address both ends.

Under Option B: `"-9223372036854775809".parse::<i64>()` FAILS (underflow), falls back to f64,
same broken predicate — bug persists at the lower bound too.

---

## Fix Design Recommendation

### Recommended: Option C (Combined — i64-first + tightened f64-fallback predicate)

**Rationale:** Option C is the correct, clean, minimal fix that addresses both bugs.

**Option C design:**

The helper `parsed_number_to_wire_value` currently takes `parsed: f64`. Under Option C, it is
restructured as follows — OR, alternatively, the call site in `resolve_edit_fields` (line 311)
is restructured to attempt i64 parse first and skip the helper entirely for i64-representable inputs.

The cleanest implementation is a two-stage approach at the call site (line 294–312 in
`field_resolve.rs`):

```rust
"number" => {
    // Stage 1: attempt i64 parse directly (exact, no precision loss).
    // If the string represents a valid i64, emit it as i64 without any f64 conversion.
    if let Ok(n) = value.parse::<i64>() {
        wire_value = serde_json::Value::Number(serde_json::Number::from(n));
    } else {
        // Stage 2: fall back to f64 for large integers, decimals, scientific notation.
        let parsed: f64 = value.parse().map_err(|_| { ... })?;
        if !parsed.is_finite() { return Err(...); }
        // Tightened predicate: use I64_MAX_AS_F64_SAFE to exclude the boundary.
        // In the f64 fallback, any value that would have required i64 precision
        // has already failed Stage 1 — but we still guard against f64 values
        // that happen to be whole and within a "safe" i64 range but were
        // expressed in scientific notation (e.g., "1e10").
        wire_value = parsed_number_to_wire_value(parsed);
    }
    display_value = value.clone();
}
```

And inside `parsed_number_to_wire_value`, the predicate is tightened:

```rust
// Safe upper bound: largest f64 strictly below 2^63.
// i64::MAX = 9_223_372_036_854_775_807 (2^63 - 1); i64::MAX as f64 rounds UP to 2^63.
// We use 9_223_372_036_854_774_784.0 (the largest f64 representable below 2^63).
// Equivalently: use `< (i64::MAX as f64)` which equals `< 9223372036854775808.0`.
const I64_SAFE_MAX_AS_F64: f64 = 9_223_372_036_854_774_784.0;  // largest f64 < 2^63
const I64_SAFE_MIN_AS_F64: f64 = -9_223_372_036_854_775_808.0; // -2^63 (exact)

pub(crate) fn parsed_number_to_wire_value(parsed: f64) -> serde_json::Value {
    debug_assert!(parsed.is_finite(), "...");
    // Use strict-less-than for upper bound to exclude 2^63 exactly.
    // Lower bound: -2^63 is exactly representable; use >= (no rounding).
    // Note: in the two-stage call site, i64-representable inputs never reach
    // this helper, so this predicate primarily handles scientific notation
    // like "1e10" that bypassed Stage 1.
    if parsed.fract() == 0.0
        && parsed >= I64_SAFE_MIN_AS_F64
        && parsed < (i64::MAX as f64)   // strict: excludes 2^63
    {
        serde_json::Value::Number(serde_json::Number::from(parsed as i64))
    } else {
        serde_json::json!(parsed)
    }
}
```

**Why not Option A alone?** Tightening the predicate alone (without i64-first parsing) still has
the f64 round-trip precision problem for large-but-valid i64 values in the range `(2^53, 2^63)`.
For example, `"9007199254740993"` (2^53 + 1) parses as f64 to `9007199254740992.0` (off by 1);
the tightened predicate would pass it and emit the wrong i64. Option A alone does not fix this
broader precision class.

**Why not Option D (always emit f64 in fallback)?** If Stage 1 (i64 parse) fails, the value is
either (a) a decimal (`5.5`), (b) out-of-i64 range, or (c) scientific notation that might still be
a whole number within i64 range (`"1e10"` = 10,000,000,000 — fits in i64). Emitting f64 for all
fallback cases would break the integer wire-form invariant for scientific notation inputs like
`"1e10"` or `"5e3"`. Tests 26 and 27 specifically pin `"5e3"` → integer wire `5000`, which Stage
2 with a tightened predicate handles correctly. Option D would break test 27.

**Why not Option E (abandon the helper, inline everything)?** The helper was extracted in S-409
precisely to make the invariant unit-testable without HTTP mocking. Abandoning it loses that
testability advantage. Option C preserves the helper and extends it.

**Summary: Option C is the correct design.** i64-first parse eliminates precision loss for the
entire exact-i64-representable range. The tightened predicate in the f64 fallback eliminates the
boundary collision. Both bugs (upper and lower) are fixed.

For the lower bound: with Option C, `"-9223372036854775809"` now hits Stage 1 (`parse::<i64>()`
fails → underflow), falls to Stage 2 (f64 parse → `-9223372036854775808.0`), and the tightened
predicate needs to handle this. Since `-2^63` is exactly representable as f64 and equals
`i64::MIN as f64`, and `parsed >= I64_SAFE_MIN_AS_F64` is `>= -2^63`, the value `-9223372036854775808.0`
still passes the lower bound. However, at Stage 1, `"-9223372036854775809".parse::<i64>()` FAILS,
so we are now in Stage 2 — and the predicate `>= I64_SAFE_MIN_AS_F64` admits it and casts to
`i64::MIN`. This is still wrong for `"-9223372036854775809"`.

The correct tightened lower bound requires strict treatment too:
- `i64::MIN as f64` = `-9223372036854775808.0` = `-2^63` (exact).
- `-9223372036854775809` rounds to the same f64 value.
- So `parsed > i64::MIN as f64 - 1.0`? No — f64 arithmetic here is imprecise too.

**Simpler: use `parsed > (i64::MIN as f64 - 1.0)` with awareness of f64 spacing.** The spacing
between consecutive f64 values near `-2^63` is `1024` (ULP at that magnitude). So any f64 in
`[-2^63 - 512, -2^63)` rounds to `-2^63`. The correct fix: require BOTH bounds to be strict:
`parsed > i64::MIN as f64 - 512.0` AND `parsed < i64::MAX as f64`. But this is getting
complicated.

**The elegant solution:** In Stage 2, after computing `parsed as f64`, never attempt i64-cast
at all for boundary-unsafe values. The cleanest correct predicate for the f64 fallback is:

```rust
// Only safe to cast if parsed is a whole number AND strictly within i64 bounds.
// Use strict comparison on BOTH ends because f64 rounding at the boundaries
// means values just outside i64 range round to boundary values.
// The constant 9223372036854774784.0 is the largest f64 strictly below 2^63.
// The constant -9223372036854774784.0 is the smallest f64 strictly above -2^63
// (i64::MIN itself). But since -2^63 IS exactly i64::MIN, >= is correct for MIN.
// Wait — -9223372036854775809 also maps to -2^63 in f64, so we must EXCLUDE -2^63
// too? No: -2^63 = i64::MIN is a valid i64. The issue is that -2^63 in f64 does
// not round-trip from strings larger than i64::MIN (underflow inputs from str→f64
// lose information BEFORE reaching this helper).
```

The key insight: by the time `parsed_number_to_wire_value` is called in Stage 2, any string that
exactly represented a valid i64 has ALREADY been handled in Stage 1. So in Stage 2, a value that
f64-rounds to `i64::MIN` (i.e., `-9223372036854775808.0`) may have come from a string that was
either (a) exactly `"-9223372036854775808"` — but that would have succeeded Stage 1 and never
reached Stage 2 — or (b) a value slightly below `i64::MIN` like `"-9223372036854775809"`. In
case (b), we must NOT cast to i64.

**Therefore: the lower bound must ALSO use strict inequality in Stage 2.** Use:

```rust
// In Stage 2 (f64 fallback only):
// - Upper: parsed < (i64::MAX as f64)  [strict: excludes 2^63]
// - Lower: parsed > (i64::MIN as f64)  [strict: excludes -2^63 = i64::MIN value in f64]
//           BUT this would wrongly exclude the valid i64::MIN input — except that
//           i64::MIN parses successfully at Stage 1 and never reaches Stage 2.
```

So using strict inequality at both ends for Stage 2 is correct:
- If `parsed > (i64::MIN as f64) && parsed < (i64::MAX as f64)` → safe to cast (the only
  way `parsed == i64::MIN as f64` in Stage 2 is from an underflowing string, and we correctly
  route it to f64).

**Final predicate for the Stage 2 helper:**

```rust
if parsed.fract() == 0.0
    && parsed > (i64::MIN as f64)   // strict: excludes -2^63 in Stage-2 context
    && parsed < (i64::MAX as f64)   // strict: excludes +2^63
{
    serde_json::Value::Number(serde_json::Number::from(parsed as i64))
} else {
    serde_json::json!(parsed)
}
```

This is the correct Option C implementation.

---

## BC Implications

### Does BC-3.4.015 need a new EC?

**Answer: Yes — a brief EC clarification is needed.** The existing EC-3.4.015-4a reads:

> Number field with `VALUE = "5"` (integer input) → parses to `f64(5.0)` → wire value is the
> JSON number `5` (NOT `5.0`). [...] Implementation: use `serde_json::Number::from_f64(v)`...

This EC describes the current implementation in terms of f64 round-tripping. The fix changes
the implementation to i64-first parsing. The observable behavior for inputs within i64 range is
unchanged (still emits integer wire form). But the EC implicitly describes the implementation
path (f64 parse → predicate → i64 cast) which will no longer be the only path.

Additionally, no existing EC covers the boundary inputs `"9223372036854775808"` and
`"-9223372036854775809"`.

**Recommended: add EC-3.4.015-4b** covering the i64-boundary class:

> EC-3.4.015-4b: Number field with `VALUE` representing an integer outside the i64 range
> (e.g., `"9223372036854775808"` = i64::MAX + 1, or `"-9223372036854775809"` = i64::MIN - 1):
> the wire value MUST be the JSON f64 form (NOT a silently-saturated i64). These inputs fail
> i64 parse and the f64 predicate must exclude them from i64-cast. Result: `9.223372036854776e18`
> or equivalent f64 JSON encoding on the wire.

**The existing wording of BC-3.4.015 invariant 5 also needs a minor update.** Currently:

> 5. The `number` type serialization reuses `f64` parsing. If `VALUE` parses successfully
>    as `f64`, the wire value is the JSON number.

This will no longer be accurate for i64-representable inputs (which bypass f64 entirely). Update to:

> 5. The `number` type serialization uses i64 parse first; falls back to f64 for decimals,
>    scientific notation, and out-of-i64-range integers. Wire value is i64 for exact integer
>    inputs, f64 otherwise. See EC-3.4.015-4a and EC-3.4.015-4b.

However, this BC change is a **documentation clarification of implementation strategy**, not a
behavioral change for any input that was previously correct. The observable contract is unchanged
for all inputs except the buggy boundary class.

---

## Test Surface

The implementer MUST add the following unit tests in `src/cli/issue/field_resolve.rs::tests`
(inline `#[cfg(test)]` block, not integration tests — these test the pure helper directly):

| Input | Expected Output | Rationale |
|-------|----------------|-----------|
| `"9223372036854775807"` (i64::MAX) | i64 wire, value `9223372036854775807` | Valid boundary; i64-first parse succeeds |
| `"9223372036854775808"` (i64::MAX + 1) | f64 wire (NOT i64 `9223372036854775807`) | Bugfix regression pin — primary case |
| `"-9223372036854775808"` (i64::MIN) | i64 wire, value `-9223372036854775808` | Valid boundary; i64-first parse succeeds |
| `"-9223372036854775809"` (i64::MIN - 1) | f64 wire (NOT i64 `-9223372036854775808`) | Bugfix regression pin — lower boundary |
| `"9007199254740992"` (2^53, exact f64) | i64 wire, value `9007199254740992` | Inside i64 range; i64-first parse correct |
| `"9007199254740993"` (2^53 + 1, not exact f64) | i64 wire, value `9007199254740993` | Stage 1 handles this exactly; f64 would be off |
| `"1e10"` (scientific notation, 10^10) | i64 wire, value `10000000000` | Stage 1 fails (`parse::<i64>()` fails on `"1e10"`); Stage 2 tightened predicate correctly emits i64 |
| `"5e3"` (existing test 27 input) | i64 wire, value `5000` | Must NOT regress |
| `"5.5"` (fractional) | f64 wire, value `5.5` | Must NOT regress |

Note on `"1e10"` and `"5e3"`: `str::parse::<i64>()` does NOT accept scientific notation —
`"1e10".parse::<i64>()` returns `Err`. So these fall to Stage 2. In Stage 2, `1e10_f64 =
10000000000.0`, `fract() == 0.0`, and `1e10 > i64::MIN as f64 && 1e10 < i64::MAX as f64` (both
strict), so the tightened predicate emits i64. This is correct and preserves test 27.

**Additional integration test** (optional, in `tests/issue_edit_field.rs`): one end-to-end test
covering `"9223372036854775808"` as a `--field` value with a wiremock asserting f64 wire form.
This is lower priority than the unit tests but provides belt-and-suspenders coverage.

---

## Regression-Test Risk for Existing Tests 26 and 27

### Test 26 (`test_bc_3_4_015_number_field_integer_wire_form`, line 1661)

**Input:** `"StoryPoints=5"` → field value `"5"`.

Under Option C:
- Stage 1: `"5".parse::<i64>()` → `Ok(5)`. i64 branch taken.
- Wire: `serde_json::Number::from(5i64)` → JSON integer `5`.
- Mock: `body_partial_json(json!({ "fields": { "customfield_20001": 5 } }))`.
- **PASSES.** Behavior unchanged.

### Test 27 (`test_bc_3_4_015_number_field_scientific_notation_wire_form`, line 1723)

**Input:** `"StoryPoints=5e3"` → field value `"5e3"`.

Under Option C:
- Stage 1: `"5e3".parse::<i64>()` → `Err` (Rust's i64 parser does not accept scientific notation).
- Stage 2: `"5e3".parse::<f64>()` → `Ok(5000.0)`.
- `is_finite()` → true.
- `parsed_number_to_wire_value(5000.0)`: `fract() == 0.0`, `5000.0 > i64::MIN as f64`, `5000.0 < i64::MAX as f64` → i64 branch.
- Wire: JSON integer `5000`.
- Mock: `body_partial_json(json!({ "fields": { "customfield_20001": 5000 } }))`.
- **PASSES.** Behavior unchanged.

**Both existing tests pass under Option C. No regressions.**

---

## Related Bug: `parsed_number_to_wire_value` helper signature under Option C

The current helper signature is `fn parsed_number_to_wire_value(parsed: f64) -> serde_json::Value`.
Under Option C, this helper remains but its semantics change: it is now only called from Stage 2
(the f64 fallback path). The helper's rustdoc must be updated to document:
1. It is ONLY called from the f64-fallback path (never for i64-representable inputs).
2. The predicate uses strict inequalities at both bounds for Stage-2 correctness.
3. The `debug_assert!(parsed.is_finite())` contract is unchanged.

Alternatively, the helper could be renamed to `f64_fallback_to_wire_value` to make the Stage-2
semantics explicit, but that is cosmetic.

---

## Files Affected

| File | Change Type | Reason |
|------|-------------|--------|
| `/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-421/src/cli/issue/field_resolve.rs` | MODIFY | Fix predicate; add Stage 1 i64-first parse at call site (line ~294–312); update helper doc |
| `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/bc-3-issue-write.md` | MODIFY | Add EC-3.4.015-4b; update invariant 5 wording |

No other files are affected. No new external dependencies.

---

## Production Code Change Scope

**Approximate LOC:** ~10–15 LOC changed/added in `field_resolve.rs`.

**Sketch of the change at the call site (lines ~294–312):**

```rust
// BEFORE (Stage 1 absent; everything goes through f64):
"number" => {
    let parsed: f64 = value.parse().map_err(...)?;
    if !parsed.is_finite() { return Err(...); }
    wire_value = parsed_number_to_wire_value(parsed);
    display_value = value.clone();
}

// AFTER (Option C — i64-first, tightened f64 fallback):
"number" => {
    // Stage 1: exact i64 parse — no precision loss for whole numbers in i64 range.
    if let Ok(n) = value.parse::<i64>() {
        wire_value = serde_json::Value::Number(serde_json::Number::from(n));
    } else {
        // Stage 2: f64 fallback for decimals, scientific notation, out-of-range integers.
        let parsed: f64 = value.parse().map_err(...)?;
        if !parsed.is_finite() { return Err(...); }
        wire_value = parsed_number_to_wire_value(parsed);
    }
    display_value = value.clone();
}
```

**Sketch of the updated helper (strict bounds):**

```rust
pub(crate) fn parsed_number_to_wire_value(parsed: f64) -> serde_json::Value {
    debug_assert!(parsed.is_finite(), "...");
    // Strict inequalities on both bounds — in Stage-2 context, any f64 equal to
    // i64::MIN as f64 (-2^63) arrived from an underflowing string (Stage 1 would
    // have handled exact i64::MIN), and any f64 equal to i64::MAX as f64 (2^63)
    // is out of i64 range. Both must emit f64.
    if parsed.fract() == 0.0
        && parsed > (i64::MIN as f64)
        && parsed < (i64::MAX as f64)
    {
        serde_json::Value::Number(serde_json::Number::from(parsed as i64))
    } else {
        serde_json::json!(parsed)
    }
}
```

**New unit tests:** ~8 new `#[test]` functions in `field_resolve.rs::tests`, each ~5–7 lines.
Total test LOC: ~50–60 lines.

**Optional integration test:** ~50–60 LOC in `tests/issue_edit_field.rs` (one test, following
pattern of tests 26/27).

---

## Affected Callers

`parsed_number_to_wire_value` is `pub(crate)`. Confirmed single caller:

- **`src/cli/issue/field_resolve.rs` line 311** — inside `resolve_edit_fields`, the `"number"`
  arm of the type dispatch. This is the ONLY production call site.

The unit tests in `field_resolve.rs::tests` also call the helper directly (lines ~456–498), but
these are `#[cfg(test)]` only — not a production caller.

Searched: `grep -rn "parsed_number_to_wire_value" src/` — found only one production call site and
the test block in the same file. No other consumers.

---

## Summary Table

| Question | Answer |
|----------|--------|
| Does Option B alone fix the bug? | NO — f64 fallback in Option B retains broken predicate; `"9223372036854775808"` still emits wrong i64 |
| Recommended fix | Option C: i64-first parse (Stage 1) + strict-inequality tightened predicate in helper (Stage 2) |
| BC impact — new EC needed? | YES — add EC-3.4.015-4b for i64-boundary behavior; update invariant 5 wording |
| Tests 26 and 27 under Option C | BOTH PASS — see step-traces above |
| Production code LOC change | ~10–15 LOC in field_resolve.rs |
| New unit tests | ~8 unit tests (~50–60 LOC); 1 optional integration test (~50–60 LOC) |
| Secondary bug found? | YES — `"-9223372036854775809"` has the same saturation bug at the lower bound; fix is symmetric |
| Files affected | `src/cli/issue/field_resolve.rs`, `.factory/specs/prd/bc-3-issue-write.md` |
