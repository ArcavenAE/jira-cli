## PR Review — FIX-F6-LRE-1 (`fix(jql): validate_duration` multibyte panic)

**Verdict: APPROVE** — clean, well-scoped hardening fix. No blocking or warning findings.

### Summary
`validate_duration` extracted the trailing unit via `s.split_at(s.len() - 1)`. Because
`s.len()` is a **byte** count, a multibyte final character (e.g. `--updated-recent "7é"`)
placed the split at a non-char-boundary and panicked. The fix uses char-safe extraction —
`s.chars().next_back()` for the unit and `&s[..s.len() - unit.len_utf8()]` for the digits —
so the slice always lands on a valid UTF-8 boundary, returning the pre-existing graceful
`Err` for invalid/non-ASCII input. Diff confined to `src/jql.rs`.

### What was verified
- **Panic eliminated.** Reproduced the original defect standalone: `"7é".split_at(s.len()-1)`
  panics (`end byte index 2 is not a char boundary; it is inside 'é'`). The new code slices
  off exactly the last char's UTF-8 byte length — a valid boundary by construction. No
  remaining byte-index arithmetic on non-boundary offsets.
- **Contract preserved.** Valid ASCII `<digits><unit>` still validates (`"7d"` → Ok). All
  three `Err` branches use the identical format string — error message unchanged. `matches!`
  correctly switched from `&str` to `char` patterns to match the new `unit: char` type.
- **Reachability.** Both call sites (`cli/issue/list.rs` `--recent` and `--updated-recent`)
  pass raw user input through `validate_duration(...).map_err(JrError::UserError)?`, so the
  panic was user-reachable; both are fixed via the single shared function.
- **Tests.** Multibyte assert-`Err` unit test asserts message content (not just `is_err()`)
  across 2/3-byte chars in both `<digit><multibyte>` and bare-`<multibyte>` shapes; a
  never-panics proptest over `.*` covers the invariant for this class. Full `jql` suite green
  (45 passed, 0 failed); `cargo clippy --lib -- -D warnings` exit 0.
- **Conventions.** Conventional-commit `fix(jql):` with story tag; test names follow
  `test_<subject>_<outcome>`; let-else is MSRV-1.85-safe; no `#[allow]`, no unsafe.

### Findings
| Severity | Category | Finding | Suggestion |
|----------|----------|---------|------------|
| nit | coverage | The `let Some(unit) = s.chars().next_back() else { ... }` fallback is effectively unreachable — the `s.len() < 2` gate already returns `Err` for the only input (`""`) that yields `None`. Harmless defensive code returning the correct `Err`. | No change required on a converged diff; noted for awareness only. |

### Checklist (all pass)
1. Diff coherence — single-file, on-topic. 2. Description accurate. 3. Changed lines covered
by new + existing tests. 4. N/A (library hardening, no AC demo surface). 5. Commit quality —
conventional + story ID. 6. Diff size ~30 lines. 7. No missing changes. 8. No upstream deps.
