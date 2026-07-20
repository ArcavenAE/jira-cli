# PR Review — #631 (S-576-2) — Cycle 3

**Verdict: APPROVE**

**Covered SHA:** `ffbd4e1f9a2a24dbf7813732bb5f8b328e9a09a9`

Targeted review of a single cross-platform test fix. Commit `ffbd4e1f` touches
exactly one file — `tests/attachment_download.rs` (26 insertions, 19 deletions).
No production (`src/`) code changed (verified via `git show --stat`).

## What changed

Two tests updated:
- `test_bc_2_7_007_success_hint_display_sanitizes_filename`
- `test_bc_2_7_007_rename_failure_error_display_sanitizes_filename`

Poison literal `"evil\u{202E}\rname.txt"` → `"evil\u{202E}name.txt"`;
expected `display_safe` `"evil??name.txt"` → `"evil?name.txt"`. Only string
literals and comments/docstrings changed — no control-flow or test-logic changes.

## Checklist verification

1. **Diff Coherence** — All changes relate to S-576-2 cross-platform test hardening. PASS.
2. **Description Accuracy** — Commit message and change match the diff. PASS.
3. **No assertion weakened** — The load-bearing sanitization proof is fully intact
   in both tests: `assert!(!stderr.contains('\u{202E}'))` (raw BiDi override never
   leaks) and `assert!(stderr.contains(display_safe))` (now `evil?name.txt`,
   correctly one `?`). The `!stderr.contains('\r')` assertion is retained (not
   removed), reframed as defensive — still guards against regression. PASS.
4. **U+202E is a legitimate poison** — `src/cli/issue/attachments.rs::display_sanitize_filename`
   explicitly maps `(0x202A..=0x202E).contains(&cp)` → `?`. U+202E is the top of that
   inclusive range, exercising the sanitizer exactly as before. PASS.
5. **Rationale sound** — CR (0x0D) is illegal in NTFS filenames (Windows OS error 123 /
   InvalidFilename), breaking the on-disk fixture (`create_dir`/`rename` to a path with
   `\r`) on Windows CI. U+202E is valid on NTFS and ext4, so it works cross-platform
   while still triggering display-sanitization. Correct diagnosis, minimal fix. PASS.
6. **Diff Size** — 45 lines, single file. PASS.

## Findings

| Severity | Category | Finding | Suggestion |
|----------|----------|---------|------------|
| nit | coherence | The RED-state docstring in test 2 still reads "error message emits raw U+202E and raw `\r`" — slightly stale since the poison no longer contains `\r`. | Optional: drop the `\r` mention. Describes the historical impl-bug class accurately enough; not worth a fix cycle. |

No blocking or suggestion-level findings. The change is coherent, well-documented,
preserves all test intent, and fixes a real cross-platform CI failure.

## Prior cycles
- Cycle 1: 3 blocking fixed (clippy, Windows colon, CI description)
- Cycle 2: APPROVE for SHA 575e065d
- Cycle 3: APPROVE for SHA ffbd4e1f

---

# PR Review — #631 (S-576-2) — Cycle 4

**Verdict: APPROVE**

**Covered SHA:** `bc8ff260f0a0e8162810addfcdfaa3253bbb89c2`

Targeted review of a single cross-platform test fix. Commit `bc8ff260` touches
exactly one file — `tests/attachment_download.rs` (30 insertions, 37 deletions).
No production (`src/`) code changed (verified via `git show --stat`).

## What changed

Poison character in the two P8/P9 display-sanitize tests changed from U+202E
(BiDi RLO) to U+007F (DEL, 0x7F):
- `test_bc_2_7_007_success_hint_display_sanitizes_filename`
- `test_bc_2_7_007_rename_failure_error_display_sanitizes_filename`

Fixture `poisoned_filename` `"evil\u{202E}name.txt"` → `"evil\u{7f}name.txt"`;
assertions `!stderr.contains('\u{202E}')` → `!stderr.contains('\u{7f}')`; the
vacuous `!stderr.contains('\r')` assertion removed (the poison never contained
`\r`, so it always passed regardless of impl); docstrings/comments updated.
`display_safe` remains `"evil?name.txt"`.

## Why cycle 4 was needed (corrects cycle-3 rationale)

Cycle 3 assumed U+202E is valid on NTFS. That assumption was wrong — the
GitHub Actions Windows runner rejects both U+202E and CR with OS error 123
(ERROR_INVALID_NAME) when the on-disk fixture (`create_dir` / `rename`)
constructs a path containing them. U+007F (127) is genuinely outside the
Windows forbidden control range (chars 1–31) and passes NTFS validation, so it
is a correct cross-platform poison. Right diagnosis, minimal fix.

## Checklist verification

1. **U+007F exercises `display_sanitize_filename` correctly** — verified against
   `src/cli/issue/attachments.rs::display_sanitize_filename`: line has an explicit
   `cp == 0x7F` arm that maps DEL → `?`. Distinct, dedicated branch. PASS.
2. **Assertions sound** — `!stderr.contains('\u{7f}')` (raw DEL never leaks) plus
   `stderr.contains("evil?name.txt")` (exactly one `?`, all other bytes pass
   through). Correct character under test. PASS.
3. **On-disk fixture holds** — `sanitize_attachment_filename` (disk variant) scrubs
   only `/`, `\`, `:` and rejects NUL; U+007F is untouched, so the on-disk name is
   `evil\u{7f}name.txt` verbatim. P8 `disk_file.exists()` and P9 pre-created
   directory (EISDIR trigger) both align with the raw poison path. PASS.
4. **Removed `\r` assertion** — genuinely vacuous (poison never carried `\r`);
   removal loses no coverage. The load-bearing proof (raw poison absent +
   display-safe present) is fully intact. PASS.
5. **Diff Coherence / Size** — single test file, 67 lines, all related to the
   cross-platform poison swap. No unrelated changes, no src changes. PASS.

## Findings

No blocking, suggestion, or nit findings. The prior cycle-3 nit (stale `\r`
mention in the RED docstring) is resolved by this diff. Clean.

---

# PR Review — #631 (S-576-2) — Cycle 5 (scoped delta)

**Verdict: APPROVE**

**Covered SHA:** `6d6ea1a9d4390fcbeaa366c7e83978e6fd1d0b09`

**Reviewed range:** `bc8ff260..6d6ea1a9` (delta since the cycle-4 APPROVE).
Three commits, four files touched: `.github/workflows/ci.yml`, `Cargo.toml`,
`src/cli/issue/attachments.rs`, `tests/attachment_download.rs`. All changes are
test-only or ci-only; no production logic changed.

## Verification

### 1. ci.yml mutation timeout (a61367f5) — SAFE
Single-line change `timeout-minutes: 120 → 240` on the `mutants` job. No security
or bypass implication: the job remains PR-only
(`if: github.event_name == 'pull_request'`) and `--in-diff`-scoped. Extending the
wall-clock ceiling only lets the existing gate finish; it does not weaken or skip any
check. Consistent with the confirmed 94% kill rate on the 240-minute run.

### 2. Test additions (3aabc92f + 6d6ea1a9) — CORRECT, no coverage weakening
- The `src/cli/issue/attachments.rs` changes are entirely inside the inline
  `#[cfg(test)] mod tests` block (~line 1561). Filtering the diff for non-test
  production lines yields only closing `}` braces — no production logic changed. All
  three unit-tested symbols (`is_windows_device_name_basename`,
  `floor_char_boundary_at`, `sanitize_attachment_filename`) exist as module functions
  and are in scope.
- Integration tests in `tests/attachment_download.rs` are precise mutation-kill tests
  (400≠403 not "Permission denied"; parent-dir path in collision/rename-failure errors;
  bare-`--out` success hint has no leading separator; `stream_to_file` failure
  increments `fail_count` → exit 1). Each documents the exact mutant it kills and
  asserts a discriminating outcome. They strengthen, not weaken, coverage.

### 3. No platform-specific fragility introduced
- New `stderr.contains(cwd_dir.path().to_str().unwrap())` parent-dir assertions are
  robust on macOS despite `std::env::current_dir()` returning the symlink-resolved
  `/private/var/folders/...`: `/var/folders/...` is a substring of
  `/private/var/folders/...`, so the `.contains()` check still passes. The
  `!stderr.contains("/doc.txt")` assertion targets the ubuntu mutation platform
  (`MAIN_SEPARATOR == '/'`) and passes harmlessly on Windows original code.
- Commit 6d6ea1a9 REDUCES fragility: it correctly `#[cfg(not(windows))]` /
  `#[cfg(windows)]`-gates the pure-backslash expectation (`Some("__")` on Unix where
  `\` is an ordinary char; `None` on Windows where `\\` is a path separator and
  `Path::file_name()` returns `None`). Reasoning is sound and mirrors the prior B5
  resolution philosophy.

### 4. No accidental production code
`git diff --name-only` confirms exactly the 4 expected files; the `src/` diff excluding
`attachments.rs` is empty; the `attachments.rs` diff outside `mod tests` is zero logic.

## Findings

| Severity | Category | Finding | Suggestion |
|----------|----------|---------|------------|
| nit | coherence | `sha1` was added to `[dev-dependencies]` (Cargo.toml) in 3aabc92f, but it is already a runtime `[dependencies]` entry used by production `sha1_hex` / `compute_default_output_path`. Integration tests inherit `[dependencies]` crates, so the dev-dep entry is redundant. Harmless — cargo permits the same crate in both sections; no build/clippy error. | Optionally drop the `[dev-dependencies]` `sha1` line; the test's `use sha1::Digest` already resolves via the runtime dependency. Not merge-blocking. |

No blocking or suggestion-level findings. The delta is test-only + ci-only, coverage is
strengthened via targeted mutation-kill tests, the platform-gate is correct, and the CI
timeout bump is safe. **APPROVE.**
