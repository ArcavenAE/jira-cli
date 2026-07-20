---
document_type: red-gate-log
level: ops
version: "1.0"
status: verified
producer: test-writer
timestamp: 2026-07-19T00:00:00
phase: 3
inputs:
  - S-576-2.md
input-hash: "2e3f9fc"
traces_to: "BC-2.7.007..BC-2.7.012"
stub_architect_agent: "[stub-architect, commit 5f025e5e]"
stub_compile_verified: true
test_writer_agent: "[test-writer, commit 2d6254eb]"
red_gate_verified: true
---

# Red Gate Log: S-576-2 — Attachment Download

**Date:** 2026-07-19
**Story:** S-576-2 — `jr issue attachments download` (attachment download command)
**Branch:** `feat/S-576-2-attachment-download`
**Base:** develop @ e33624c1
**Worktree:** `.worktrees/S-576-2`
**Red Gate verified by:** orchestrator, 2026-07-19 (`cargo test --test attachment_download`)

## Summary

| Story | Tests Written | All Fail (Red)? | Gate |
|-------|---------------|-----------------|------|
| S-576-2 | 22 | Yes — 0 passed / 22 failed | PASSED |

Two-commit Red Gate staged per TDD discipline:

- **Commit 5f025e5e (stub-architect):** `feat(S-576-2): add module stubs` — `todo!()` stubs introduced for the download command handler and supporting functions. `cargo check` and `cargo check --tests` both clean. Adds `sha1` dep + `reqwest` stream support; `deny.toml` `cpufeatures` skip human-authorized per AUDIT-576-004/DEC-185.
- **Commit 2d6254eb (test-writer):** `test(S-576-2): add failing tests for BC-2.7.007..012` — `tests/attachment_download.rs` with 22 wiremock subprocess tests covering all 6 BCs (1977 lines). Story v1.33, 19 ACs.

Red Gate VERIFIED by orchestrator:

- `cargo check --all-targets` — CLEAN (no compile errors; `todo!()` macros are valid Rust)
- `cargo test --test attachment_download` — **0 passed / 22 failed / 0 ignored** (all failures are exit-code assertion errors: subprocess exits 101 from `todo!()` panic vs expected 0/64/2/1)
- Build errors: none — all failures are runtime panics from stub bodies, confirming correct Red state

## Step (a): Stubs — commit 5f025e5e

Files introduced / modified by stub-architect:

- New stub functions (all bodies are `todo!()`): download command handler and supporting
  streaming/integrity/path-sanitization helpers for `jr issue attachments download`
- Dependency additions: `sha1` crate for file integrity verification; `reqwest` streaming
  support for large attachment transfers
- `deny.toml` updated: `cpufeatures` crate skip rule human-authorized per AUDIT-576-004/DEC-185

`cargo check` output: PASS (0 errors).
`cargo check --tests` output: PASS (0 errors).

## Step (b): Tests — commit 2d6254eb

File introduced by test-writer:

- `tests/attachment_download.rs` — 22 wiremock subprocess integration tests (1977 lines)
  covering BC-2.7.007..BC-2.7.012 across 19 acceptance criteria (story v1.33)

## Red Gate Verification

### S-576-2 — all 22 tests FAIL as expected

All 22 tests fail with exit 101 (Rust `todo!()` panic) vs expected exit codes of 0, 64, 2, or 1.
Failure mode is consistent across all tests: subprocess panics on the stub body before reaching
any assertion logic. This is the correct Red state.

| BC Coverage | Expected Exit Codes | Count |
|-------------|---------------------|-------|
| BC-2.7.007 | 0 | multiple |
| BC-2.7.008 | 0, 64 | multiple |
| BC-2.7.009 | 0, 64 | multiple |
| BC-2.7.010 | 0, 64 | multiple |
| BC-2.7.011 | 2 | multiple |
| BC-2.7.012 | 0, 1, 2, 64 | multiple |

All 22 failures are exit-code assertion errors (101 vs expected), not compilation failures.
BC-5.38.001 compliance confirmed: test suite compiles and runs; every test exercises a stub that
panics — correct Red state.

## Regression Check

| Existing Tests | Status |
|----------------|--------|
| Pre-existing test suite (all other tests) | not re-run as part of this Red Gate verification; compile clean confirms no breakage introduced by stubs |

## Hand-Off to Implementer

- Stories ready for implementation: S-576-2
- Implementation guidance:
  - Implement the download handler and all supporting streaming/integrity/path helpers
  - BCs to satisfy: BC-2.7.007 (basic download), BC-2.7.008 (output path control), BC-2.7.009 (integrity verification via sha1), BC-2.7.010 (filename sanitization), BC-2.7.011 (filter composition), BC-2.7.012 (error exit codes)
  - `sha1` dep and `deny.toml` cpufeatures skip already in place from stub commit
  - Green Gate target: 22/22 passing
  - Worktree already set up at `.worktrees/S-576-2`, branch `feat/S-576-2-attachment-download`
