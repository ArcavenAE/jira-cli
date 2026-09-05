# PR #768 — Scoped Re-Review of Follow-Up Commit `389da3b8`

**Verdict: APPROVE (READY to merge at `389da3b8`)**

This is a **scoped, targeted re-review** of one follow-up commit, not a full re-review of
PR #768. A prior full review returned APPROVE against `2134f74a`. Since then exactly one
commit landed — `389da3b8e9ee9a201f929be75a98c96514c04b49`, now the PR HEAD. The question
answered here is narrow: does this commit invalidate the prior APPROVE? It does not.

**Diff scope:** `src/api/auth_windows_store.rs` only, +41 / −8, one file.

---

## Findings

**No findings.** Zero blocking, zero suggestion, zero nit. Per the no-rubber-stamp rule,
what was actually verified is itemized below.

---

## What was verified

### 1. `mut` removal on the `input` binding — correct, behavior-identical

`clippy::unnecessary_mut_passed` fix in both `protect()` and `unprotect()`.

- `input` is a `CRYPT_INTEGER_BLOB` constructed once from `plaintext.as_ptr()` /
  `blob.as_ptr()` and is **never** reassigned, nor is any field mutated, between
  construction and the FFI call. Confirmed by reading the full body of both functions,
  not just the diff hunks.
- `windows-sys` declares `pDataIn` as `*const CRYPT_INTEGER_BLOB`. Passing `&input`
  instead of `&mut input` yields the same address with stricter (and correct) Rust-side
  provenance. No semantic change.
- The out-parameter is unaffected: `output` correctly remains `let mut output` and is
  still passed as `&mut output` in both functions. The diff did not touch it, verified
  by re-reading the call sites rather than trusting the hunk boundaries.
- The rustdoc safety justification already stated that `CryptProtectData` "never mutates"
  the input and "only writes through `pDataOut`" — the code now matches the documented
  contract more precisely than it did before.

### 2. `#[cfg(not(windows))]` on the design-conformance test — correctly scoped, no coverage loss

- The attribute is on **exactly one item**: `test_design_conformance_std_path_would_
  wrongly_accept_windows_vectors_on_this_host` (`src/api/auth_windows_store.rs:1190`).
  No other test, and no non-test code path, is gated by this change.
- That test is a **fixture**, not a guard test: it asserts a property of
  `std::path::Path`, and its own doc comment states it "does not call
  `reject_unsafe_profile_component` at all". Its premise (a Windows-shaped string parses
  as one opaque `Component::Normal`) is true only off Windows; on a real Windows host
  `std::path` correctly splits `C:\evil` into `Prefix` + `RootDir` + `Normal`. Gating it
  is the right fix, not a weakening.
- **Security coverage on Windows is not reduced.** Every real
  `reject_unsafe_profile_component` test in that section remains ungated and still runs
  on the Windows runner: separators (both `/` and `\`, incl. UNC), colon (covering
  `C:`, `C:\evil`, `secret:$DATA`, `name:`, `:name` — i.e. drive-letter and NTFS ADS
  vectors), embedded NUL, dot-segments, `..` substring, trailing dot/space, and the full
  30-name reserved Windows device-name set. AC-017 / VP-AUTHDX-016(a)(b)(c) coverage is
  intact on all three platforms.
- The section's own comment ("HOST-PURE, NO `#[cfg(windows)]` gate anywhere in this
  section") is not contradicted: the added gate is `#[cfg(not(windows))]` on a fixture
  that is explicitly not part of the recognizer's test set, and the section's intent —
  that the recognizer, not the host OS, does the rejecting — is preserved.

### 3. New `is_null()` guards on the DPAPI output blob — correct, no leak

Added to both `protect()` and `unprotect()` (this reviewer's own prior non-blocking
suggestion #4).

- **Ordering is correct in both functions:** the guard sits *after* the
  `if ok == 0 { return Err(std::io::Error::last_os_error()); }` error check and *before*
  the `std::slice::from_raw_parts(output.pbData, ...)` call. Verified at both sites.
- **Error type is sensible:** `std::io::Error::other(...)` with a distinct,
  function-specific message ("CryptProtectData returned success with a null output blob"
  / "CryptUnprotectData …"), matching the `std::io::Result` signature of both functions.
  `io::Error::other` is stable since Rust 1.74, well under this repo's MSRV of 1.85.
- **No resource leak on the bail-out path.** The only allocation these functions free is
  `output.pbData` via `LocalFree`. In the guard's branch `pbData` *is* null, so there is
  nothing allocated to free; `cbData` is a plain `u32`, not a separate allocation. (Even
  if reached, `LocalFree(NULL)` is a documented no-op.) Bailing out before `LocalFree`
  is therefore leak-free by construction.
- Correctly characterized in-comment as defense-in-depth: under a conforming Win32
  implementation this branch is unreachable, but `slice::from_raw_parts` on a null
  pointer is UB regardless of contract, so guarding rather than trusting is right.

### 4. CI on this exact commit

Spot-checked via `gh pr checks 768` (primary ask was source-level review, not CI
re-verification). All **15/15 checks pass** on `389da3b8`, including the two that
originally failed and motivated this commit: `Clippy (windows-latest)` (2m18s) and
`Test (windows-latest)` (9m46s). `CI Gate` — the single required status check — passes.
PR HEAD confirmed as `389da3b8e9ee9a201f929be75a98c96514c04b49`.

---

## Checklist disposition (scoped review)

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence | PASS — single file, all three changes trace to the stated windows-latest CI failures or to a prior review suggestion |
| 2 | Description accuracy | PASS — commit message matches the diff exactly, including the honest note that the two Windows defects could not be reproduced on the macOS dev host |
| 3 | Test coverage | PASS — no new logic requiring new tests; the guards are unreachable-under-contract defense-in-depth, and Windows guard-test coverage is verified intact |
| 4 | Demo evidence | N/A for this scoped re-review — assessed in the prior full review at `2134f74a` |
| 5 | Commit quality | PASS — conventional format (`fix(auth):`), PR reference, clear rationale |
| 6 | Diff size | PASS — 49 lines changed, one file |
| 7 | Missing changes | PASS — nothing implied by the commit message is absent from the diff |
| 8 | Dependency status | N/A — no upstream PR dependency for this follow-up commit |

---

**The prior APPROVE at `2134f74a` is not invalidated. PR #768 is READY to merge at
`389da3b8`.**

covered_sha: 389da3b8e9ee9a201f929be75a98c96514c04b49
