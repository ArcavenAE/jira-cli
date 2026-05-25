# PR #401 Copilot Finding F2 — `av.id == *value` deref idiom

**Date:** 2026-05-23
**File under review:** `src/cli/issue/field_resolve.rs:319`
**Branch:** S-396 worktree (PR #401)

## Code under review

```rust
// src/cli/issue/field_resolve.rs:319 (inside option-field id-bypass block)
let id_match = if !value.is_empty() && value.chars().all(|c| c.is_ascii_digit()) {
    allowed.iter().find(|av| av.id == *value)
} else {
    None
};
```

## Type analysis (corrected)

The user's prompt described `value: &String`. The actual surrounding code at
`field_resolve.rs:235` is:

```rust
for (field_id, human_name, value) in resolved {  // resolved: Vec<(String, String, String)>
    ...
}
```

So `value: String` (owned), **not** `&String`. Inside the
`|av| av.id == *value` closure:

- `av: &AllowedValue` (from `allowed.iter()` on `&[AllowedValue]`)
- `av.id: String` (a place expression; field access auto-derefs through `&AllowedValue`)
- The closure captures `value` by shared reference (only reads it), so inside the
  closure body the identifier `value` is a place expression of type `String`
  (the deref of the captured `&String` is performed transparently by closure
  desugaring per RFC 2229 / edition 2021 disjoint captures).
- `*value` therefore explicitly derefs an already-implicitly-dereffed capture —
  it is a redundant explicit dereference.

Both `av.id == value` and `av.id == *value` compile and produce identical
generated code (resolve to the same `<String as PartialEq<String>>::eq` call).

## Verdict: **PARTIAL** (style preference, no correctness impact)

Copilot is **half right**:

- ✅ Correct that the `*value` deref is unusual / redundant / can be removed.
- ✅ Correct that this is easy to misread.
- ❌ Wrong about the recommended fix.
  - `value.as_str()` works (via `String: PartialEq<&str>`) but is more verbose
    than necessary and inconsistent with the rest of the codebase.
  - `&av.id == value` does **not** compile — `&String` does not implement
    `PartialEq<String>` (see Rust issue #44695). You would need `&av.id == &value`
    or `&av.id == &*value`, which is strictly worse.
  - The minimal, idiomatic fix is to drop the `*`: `av.id == value`.

No correctness, borrow-check, or refactor-safety risk. No extra clone/move:
`==` only needs `&Self`, the closure already holds `&String`, and `String::eq`
is called on borrows on both sides. The asm is identical.

## Recommended replacement

```rust
// Before
allowed.iter().find(|av| av.id == *value)

// After
allowed.iter().find(|av| av.id == value)
```

This matches the in-house style used at four other sites:

| Site | Pattern | RHS type |
|------|---------|----------|
| `src/cli/assets/schemas.rs:17` | `s.id == input` | `&str` |
| `src/api/auth.rs:725` | `r.id == override_id` | `&str` |
| `src/api/auth.rs:805` | `r.id == resource_id` | `String` (owned, closure-captured by ref) |
| `src/cli/issue/view.rs:259` | `t.id == team_uuid` | `String` (owned, closure-captured by ref) |

The current `*value` form is the lone outlier — convergence on the bare form
is consistent with the codebase, idiomatic Rust, and what
`clippy::explicit_auto_deref` would flag in the textbook case.

## Severity

**Low** — pure style nit. Not blocking. Drive-by cleanup if PR #401 is touching
adjacent lines anyway; otherwise defer to a follow-up "consistency sweep" PR
that also fixes any other `== *foo` patterns in newly-added code.

## Risk of the change

**Zero.** Identical generated code. Existing tests that exercise the
id-bypass path (`field_resolve.rs` Step 4a — `EC-3.4.016-4`) will pass
unchanged. No behavior change. No test change required.

## Sources

### Trait-level facts
- [`std::string::String` `PartialEq` impls](https://doc.rust-lang.org/std/string/struct.String.html) — confirms `String: PartialEq<String>` and `String: PartialEq<&str>` but NO `String: PartialEq<&String>`.
- [rust-lang/rust#44695 — Ergonomics: `&String` does not implement `PartialEq<str>`](https://github.com/rust-lang/rust/issues/44695) — documents the same missing-impl pattern that breaks the `&av.id == value` shape.

### Closure / capture semantics
- [Rust Reference — Closure types](https://doc.rust-lang.org/reference/types/closure.html) — disjoint-capture / shared-reference capture rules.
- [RFC 2229 — capture disjoint fields](https://rust-lang.github.io/rfcs/2229-capture-disjoint-fields.html) — edition 2021 capture path truncation at the rightmost shared-ref deref; explains why bare `value` inside the closure resolves to a `String` place.

### Clippy
- [`clippy::explicit_auto_deref`](https://rust-lang.github.io/rust-clippy/master/index.html) — "Checks for dereferencing expressions which would be covered by auto-deref. This unnecessarily complicates the code." The textbook positive case (extra `*` on a place where auto-deref would already fire) is exactly the pattern in `field_resolve.rs:319`.
- [`clippy::op_ref`](https://github.com/rust-lang/rust-clippy/blob/master/tests/ui/op_ref.stderr) — adjacent lint; sibling examples show clippy actively pushes the codebase toward the minimal-deref form on `==`.

### In-house convention (codebase-internal)
- `src/cli/assets/schemas.rs:17`, `src/api/auth.rs:725`, `src/api/auth.rs:805`, `src/cli/issue/view.rs:259` — four pre-existing `field.id == X` sites with no explicit `*` on owned/borrowed `String` RHS. Establishes the dominant in-house style.

## Caveats / inconclusive areas

- I did NOT run `cargo clippy -- -D warnings -W clippy::explicit_auto_deref`
  against this exact line to confirm clippy emits a diagnostic here. The lint
  is in the default `complexity` group and is documented to fire on this
  pattern, but clippy has known false positives around closure captures
  (rust-clippy issues #9101, #9109, #9143, #9165, #9309, #9383, #9841). The
  recommendation stands regardless: the bare form is shorter, idiomatic, and
  matches the rest of the codebase, with or without clippy enforcement.
- The redundant `*` may have been a leftover from an earlier iteration of the
  surrounding code where `value` had a different type (e.g., `&String` from a
  function parameter rather than a destructured tuple). Worth a quick `git blame`
  on the line if you want the historical context; not required for the fix.

---

**Bottom line:** Drop the `*`. Replace `av.id == *value` with `av.id == value`.
Pure style. No risk. Matches house style.
