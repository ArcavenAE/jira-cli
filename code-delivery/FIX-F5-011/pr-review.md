# PR #650 — Fresh-Eyes Review (FIX-F5-011)

**Branch:** `fix/f5-r7-doc-fallout` → `develop`
**Scope:** doc/comment/test-only sync of BC-2.7.012 classifier doc-fallout from PR #649. No production behavior change.
**Commit reviewed:** `4d7acbf3` (+23/-29 across `src/cli/issue/attachments.rs`, `tests/attachment_download.rs`)

## Verdict: PASS (1 NIT)

No `gh pr review --approve` posted: DEC-173 prohibits agent approval. No blocking findings, so `--request-changes` is not applicable either. This file records the verdict; the human retains the merge decision.

## Checklist verification

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence | PASS — all hunks relate to BC-2.7.012 classifier doc-fallout |
| 2 | Description accuracy | PASS — commit body matches the three findings + sweep |
| 3 | Test coverage | PASS — 6 tests (1 integration EACCES + 5 lib classifier) pass on macOS |
| 4 | Demo evidence | N/A — doc/test-only |
| 5 | Commit quality | PASS — conventional `docs(test):`, FIX-F5-011 id |
| 6 | Diff size | PASS — 52 lines |
| 7 | Missing changes | PASS — sweep verified zero remaining v1.3.102 cites |
| 8 | Dependency status | PASS — #649 (upstream impl) merged |

## Findings

### F5-R7-001 — classify_write_error rustdoc four-site enumeration + v1.3.104 cite — CONFIRMED CORRECT
Four I/O sites confirmed routing through `classify_write_error`: `File::create` (L701), `write_all` (L715), `flush` (L727), `rename` (L738). `flush` was previously missing from the enumeration; now present. v1.3.104 is the correct current-state cite (`write_error_display_strings` extracted at L649, post-mutation-kill state c71b83be).

### F5-R7-002 — classifier unit-test block banner — CONFIRMED CORRECT
Banner replaced with post-GREEN statement ("implemented in FIX-F5-010 / PR #649"); RED-gate/compile-fail narrative removed; shape annotations pin v1.3.103. All 5 classifier unit tests pass.

### F5-R7-003 — EACCES test docstring + assertion (f) — CONFIRMED CORRECT
Docstring updated to v1.3.103 `(writing <dest>)` shape; RED-state narrative + inline `// RED:` comments (b)–(e) removed. Assertion (f) is valid: fixture sets `filename: "eacces_test.bin"` and `out_path = restricted.join("eacces_test.bin")`; `write_error_display_strings` derives `dest_display` from `final_path`, and the PermissionDenied branch interpolates `(writing {dest_display})`, so the basename genuinely appears in stderr. Test passes on darwin.

### Sweep — CONFIRMED COMPLETE
Zero remaining `v1.3.102` cites in either file. `stream_to_file` rustdoc (L680), inline comment (L695), and EACCES section comment (test L3696) all at v1.3.104.

### NIT — adjacent version-cite mismatch (tests/attachment_download.rs:3696 vs :3699)
Section divider (L3696) cites `v1.3.104` while the docstring for the same test (L3699) cites `v1.3.103`. Both are individually defensible (divider = current-impl version; docstring = shape-origin version) but appear back-to-back for the same test. Consider aligning the divider to `v1.3.103` or adding a half-line note distinguishing current-impl from shape-origin. Cosmetic; not a merge blocker.

## Scope note
The many other `RED GATE`/`RED:` comments remaining in `tests/attachment_download.rs` and `attachments.rs:3242` are pre-existing S-576-2 TDD-history narrative on unrelated tests — correctly out of scope for this classifier-focused PR.

## Not reviewed
No security review (doc/test-only, as instructed). No full `cargo clippy`/`fmt` run — changes are comments plus one string-`contains` assertion with no clippy-visible surface; touched tests compile and pass.
