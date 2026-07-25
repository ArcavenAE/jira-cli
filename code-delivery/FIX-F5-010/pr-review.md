# Fresh-Eyes PR Review — PR #649 (FIX-F5-010)

**Branch:** `fix/f5-r5-disk-error-taxonomy` → `develop`
**Title:** fix(issue): classify disk-write errors per BC-2.7.012 v1.3.102 — hybrid ErrorKind taxonomy + tmp-path leak fix (FIX-F5-010, F5 round for #576)

## Verdict: APPROVE

The implementation is correct, well-scoped, and properly test-driven. No blocking issues. Three non-blocking notes (two PR-description accuracy, one optional completeness improvement).

## What I verified (no rubber-stamp)

- **Classifier branches & strings — exact match.** `classify_write_error` matches `StorageFull | QuotaExceeded` → disk-full message, `PermissionDenied | ReadOnlyFilesystem` → permission message, `_` → generic fallback. All three format strings are byte-for-byte identical to the PR taxonomy table. The `_` arm is a genuine catch-all (required — `io::ErrorKind` is `#[non_exhaustive]`).
- **All three I/O sites wired.** `File::create`, `write_all`, and `rename` each call `classify_write_error(e.kind(), &final_dest_display, &final_dir_display, &e.to_string())`, reading `e.kind()`/`e.to_string()` before any anyhow conversion. The chunk-stream error is correctly left unclassified (network, not disk).
- **`display_sanitize_filename` applied.** `final_fname` is sanitized (CWE-116) before appearing in `final_dest_display`; operator-controlled parent dir rendered verbatim.
- **tmp-path leak genuinely closed.** No `tmp_path` reference remains in any user-visible error. Surviving uses are the internal `parent.join(...)` and the discarded cleanup `let _ = tokio::fs::remove_file(&tmp_path)`. The integration assertion `!stderr.contains("tmp_")` is non-vacuous: `TempDir` paths use the `.tmp<alnum>` prefix (no underscore), so only the internal `tmp_<hex>` handle can produce `tmp_`.
- **Batch fail-soft inherits classification.** Batch caller does `Err(e) => eprintln!("warning: failed to download attachment {}: {e}", att.id)` — `{e}` is the classified message, no re-wrap, no tmp path. Single-mode propagates via `?`.
- **Test quality.** 5 unit tests exercise 5 distinct `ErrorKind` values with correct prefix + OS-string + remediation-hint assertions; fallback test negative-asserts absence of both discriminated hints. EACCES integration test creates a real `0o555` dir, has a sound root-skip probe guard, and asserts exit code + prefix + dir path + hint + no-`tmp_`.
- **MSRV safe.** `io_error_more` stabilized in Rust 1.83; project MSRV is 1.85 and the MSRV CI job passed.

## Findings

| # | Severity | Category | Finding | Suggestion |
|---|----------|----------|---------|------------|
| 1 | ADVISORY | description | PR "Test Evidence" bullet claims the EACCES test asserts exit 64, but the test asserts `Some(1)` and the code confirms it: the classifier returns a bare `anyhow::anyhow!` (not a `JrError`), so `main.rs`'s `downcast_ref::<JrError>()…unwrap_or(1)` yields exit 1. Code/test correct and consistent; only the PR prose is wrong. | Fix the PR body bullet to say exit 1. |
| 2 | ADVISORY | coverage | `file.flush().await?` and the implicit `drop(file)` at close are not routed through `classify_write_error`. On filesystems that surface ENOSPC/EDQUOT at flush/close rather than `write_all`, the user gets a generic un-taxonomized io error (no "Disk full:" hint). No `tmp_` leak. Low impact: the `tokio::fs::File` here is unbuffered so ENOSPC realistically surfaces at `write_all` (covered). | Optional: wrap `flush().await` with `classify_write_error` for exhaustive coverage. |
| 3 | COSMETIC | description | PR body says the test writes to a "chmod-000 directory"; test actually uses `0o555`. | Say `0o555` / "non-writable dir". |

## Rationale

The fix does exactly what BC-2.7.012 v1.3.102 specifies: a pure, unit-tested classifier fed by a single chokepoint that both single-mode (propagate → exit 1) and batch-mode (fail-soft warning) inherit. The tmp-path leak — the concrete user-facing defect — is closed at all three sites, the cleanup path, and the batch warning, pinned by a non-vacuous integration test with a correct root-skip guard. Message strings match spec exactly, `display_sanitize_filename` is correctly applied, and the RED-gate design is sound. CI: Clippy/Format/MSRV/Deny/Spec-Guards/Secret-Scan green; Test/Coverage/Mutation pending at review time — merge should wait for them. All three findings are non-blocking.

---

# Delta Review — commit c71b83be (mutation-survivor fix)

**Verdict: APPROVE** — no blocking findings.

Scope: single new commit `c71b83be` addressing the CI mutation-testing failure on run
30119740440 (2 survivors in `stream_to_file` display-string block). Behavior-preserving
refactor + two mutation-killing unit tests in `src/cli/issue/attachments.rs`.

## What I verified

1. **Extraction is behavior-preserving (PASS).** The new pure helper
   `write_error_display_strings(final_path: &Path) -> (String, String)` is byte-for-byte
   identical to the inlined block it replaces; only the tuple return and destructuring
   call site are added. No control-flow, ordering, or type change.

2. **Both CI survivors are killed (PASS).** Confirmed logically and empirically
   (`cargo test --lib write_error_display_strings` → 2 passed):
   - Mutant 1 (`delete !` in `.filter(|d| !d.as_os_str().is_empty())`): normal path
     `out/dir/file.txt` → mutated filter rejects the non-empty parent → `dir` falls to
     `"."`; `test_..._normal_path_kills_mutant1` asserts `dir == "out/dir"` → killed.
   - Mutant 2 (match guard → `true`): bare `file.txt` (`parent() == Some("")`) → mutated
     guard matches first arm → `dest == "/file.txt"`; `test_..._bare_filename_kills_both_mutants`
     asserts `dest == "file.txt"` → killed.
   The `Path::new("file.txt").parent() == Some("")` premise is correct Rust semantics;
   normal-path assertions are Windows-safe.

3. **Rustdoc contract (PASS).** Accurately documents the return tuple, `"."` fallback,
   no-leading-separator bare-filename behavior, CWE-116 sanitization split, and the
   explicit mutant-killing contract.

4. **No new issues (PASS).** `cargo clippy --lib -- -D warnings` clean; no `unsafe`, no
   lint suppression; private helper with one live call site (no dead code); test naming
   consistent with the file's conventions.

## Delta Findings
None (BLOCKING / WARNING / NIT): all clear. The commit does exactly what it claims — a
clean pure-function extraction plus two targeted regression pins closing both mutation
survivors.
