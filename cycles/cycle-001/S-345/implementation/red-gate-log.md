# Red Gate Log — S-345

## Story
S-345: Extract label-coalesce JSON builder into pure function + proptest

## Pattern
Standard Red Gate (assertion-error fail before implementation). The proptest
references the stub function `build_labels_edited_fields` which returns
`{"STUB_INTENTIONALLY_WRONG": true}`. The proptest's first invariant assertion
(top-level "labels" key MUST be present) fires immediately.

## Outcome
- Step A.1 first run: PROPTEST FAILED with assertion error referencing BC-3.4.006
  (CORRECT — discriminates the contract). Compile succeeded.
- Implementer (next dispatch) will replace the stub body; proptest expected to
  go green on first run after that.

## Evidence
- Stub function: src/cli/issue/create.rs (just above handle_edit_bulk_labels, gated #[cfg(test)] during stub phase)
- Proptest module: src/cli/issue/create.rs #[cfg(test)] mod build_labels_proptests
- Worktree commit (Red Gate): 195dc3a

## Pass 1 Adversary Fixes — Applied 2026-05-15

All four findings applied to `src/cli/issue/create.rs` in worktree commit `2cf3930`.

### F1 (CONCERN) — Verbatim schema-note restored
Replaced the paraphrased "Schema note: this pins the CURRENT shape..." paragraph with
the 4-line verbatim block from develop baseline (lines 869-872):
```
/// Shape is best-guess (unverified against live Atlassian API; tracked at #331).
/// PR2 test asserts .expect(1) on bulk POST to ensure ADD+REMOVE coalesce into ONE call,
/// but the exact JSON nesting matches a loose `body_string_contains` matcher — schema
/// accuracy is the work being deferred to #331.
```

### F2 (NIT) — Proptest tightened: sole top-level key assertion
Added `obj.len() == 1` assertion immediately after `prop_assume!`, before the `labels`
extraction. Catches schema-drift regressions like `{"labels": [...], "extra": "drift"}`.
Verified: proptest passes (1 passed, 256 cases).

### F3 (NIT) — debug_assert! for misuse precondition
Added `debug_assert!(!adds.is_empty() || !removes.is_empty(), ...)` at function entry.
Zero cost in release builds; surfaces misuse in debug/test builds.

### F5 (NIT) — Coalesce rationale comment at call site
Added two comment lines immediately above `let edited_fields = build_labels_edited_fields(...)`:
```rust
// Coalesce ADD and REMOVE into a single bulk POST when both are present.
// Both operations submitted in one request as an array of label-action objects.
```

### Deferred
- F4 (NIT): proptest block naming convention exemption — filed as future process-gap issue.
- F6 (NIT): broader proptest string strategy — [a-z]{1,10} kept per story spec suggestion.

### Verification Results
- `cargo test --lib build_labels_proptests`: 1 passed (256 cases, no shrink)
- `cargo test --test issue_bulk_pr2`: 40 passed, 0 failed
- `cargo test --test issue_bulk`: 9 passed, 0 failed
- `cargo fmt --check`: clean
- `cargo clippy --all-targets -- -D warnings`: clean (no warnings)

Worktree commit: `2cf3930`

---

## Verbatim Red Gate proof

```
running 1 test
test cli::issue::create::build_labels_proptests::build_labels_edited_fields_invariants ... FAILED

---- cli::issue::create::build_labels_proptests::build_labels_edited_fields_invariants stdout ----

thread '...' panicked at src/cli/issue/create.rs:1509:47:
BC-3.4.006: top-level 'labels' key MUST be present

Test failed: BC-3.4.006: top-level 'labels' key MUST be present.
minimal failing input: adds = ["a"], removes = []
    successes: 0
    local rejects: 0
    global rejects: 0

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 701 filtered out
```
