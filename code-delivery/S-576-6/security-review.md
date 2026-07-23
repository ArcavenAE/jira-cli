---
story: S-576-6
pr_type: test-only
total_findings: 3
critical: 0
high: 0
medium: 1
low: 2
files_reviewed: 1
reviewer: security-reviewer
date: 2026-07-23
verdict: APPROVE (no CRITICAL or HIGH findings; one MEDIUM test-reliability concern)
---

# Security Review — S-576-6 (Attachment E2E Tests)

**Verdict: APPROVE** — No CRITICAL or HIGH findings. One MEDIUM concern (test reliability / double-panic risk in AttachmentDropGuard); two LOW findings (orphan risk asymmetry and fixed filename accumulation). Zero src/ delta reviewed.

---

## Scope

This is a test-only PR. The delta is confined to:

- `tests/e2e_live.rs` — four new `#[ignore]`-gated live-Jira E2E tests:
  - `test_e2e_attachment_platform_roundtrip` (AC-001)
  - `test_e2e_jsm_attachment_public_echo_shape` (AC-002)
  - `test_e2e_jsm_attachment_internal_echo_shape` (AC-003)
  - `test_e2e_jsm_attachment_upload_no_flag` (AC-004)
- A new `AttachmentDropGuard` struct used by AC-002
- Documentation updates

Zero changes to `src/`.

---

## Focus Area Verdicts (per task brief)

| Focus Area | Verdict | Notes |
|---|---|---|
| 1. Secret / credential handling | CLEAN | `JR_AUTH_HEADER` flows to subprocess env only; never appears in assert messages or eprintln output |
| 2. File cleanup / AttachmentDropGuard | MEDIUM concern | Drop can panic if env vars were removed mid-test (see SEC-S576-6-001); AC-003 and AC-004 do not use the guard |
| 3. Test isolation | LOW concern | Filenames are fixed, not run-labeled (see SEC-S576-6-003); mitigated because each test seeds a fresh issue |
| 4. Hardcoded data | CLEAN | No hardcoded Jira keys, org IDs, or instance URLs in new test code |
| 5. Gating correctness | CLEAN | All 4 tests have `#[ignore]` + `if !e2e_enabled() { return; }` dual-gate; covered by the always-run `test_every_ignored_test_has_gate_guard` meta-test |

---

## Findings

### SEC-S576-6-001: AttachmentDropGuard::drop() can panic inside Drop during stack unwind

- **Severity:** MEDIUM
- **CWE:** CWE-703 (Improper Check or Handling of Exceptional Conditions)
- **OWASP:** N/A (test code only)
- **Attack Vector:** Not externally exploitable; internal test reliability concern only.
- **Impact:** If `AttachmentDropGuard::drop()` is invoked during panic unwinding (because a test assertion fired), it creates a new `E2eHarness` which calls `env::var("JR_E2E_BASE_URL").expect(...)` and `env::var("JR_AUTH_HEADER").expect(...)`. In Rust, a panic inside a `Drop` implementation while already unwinding causes process abort rather than recoverable error. On the current test setup (`--test-threads=1`, all env vars pre-set) the practical risk is very low because the env vars are set for the entire test run. However, if a future test runner or CI change causes partial env setup, or if a test intentionally removes an env var (e.g., the bad-auth test at line 8728 overrides `JR_AUTH_HEADER`), a subsequent panic could double-panic and abort the entire test binary.
- **Evidence:**
  ```rust
  // tests/e2e_live.rs line 10934
  impl Drop for AttachmentDropGuard {
      fn drop(&mut self) {
          if let Some(ref aid) = self.aid {
              let h = E2eHarness::new();      // TempDir::new().expect(...)
              match h                          // cmd() calls env::var(...).expect(...)
                  .cmd()
  ```
  `E2eHarness::cmd()` calls `.expect()` on env var reads (lines 110–112), which will panic if the vars are unset.
- **Proposed Mitigation:** Replace `.expect()` calls in `E2eHarness::cmd()` with `.ok()` + early return for the Drop-guard path, OR extract a `try_cmd()` variant that returns `Option<Command>` and use it in `Drop`. Alternatively, store a clone of `base_url` and `auth_header` in `AttachmentDropGuard` at construction time so `Drop` doesn't re-read env vars. Example:
  ```rust
  struct AttachmentDropGuard {
      aid: Option<String>,
      key: Option<String>,
      base_url: String,   // captured at construction
      auth_header: String,
  }
  ```

---

### SEC-S576-6-002: AC-003 and AC-004 lack drop-guard; orphan attachment on assert-panic

- **Severity:** LOW
- **CWE:** CWE-459 (Incomplete Cleanup)
- **OWASP:** N/A (test code only)
- **Attack Vector:** Not exploitable; internal test hygiene concern.
- **Impact:** `test_e2e_jsm_attachment_internal_echo_shape` (AC-003) and `test_e2e_jsm_attachment_upload_no_flag` (AC-004) use the collect-results-then-assert teardown pattern instead of `AttachmentDropGuard`. If a panic occurs between the issue creation and the explicit teardown block (e.g., a `TempDir::new().expect(...)` on line 11565 failing, or `h.cmd().output().expect()` on line 11584 failing), both the JSM issue and the uploaded attachment would be orphaned on the live Jira instance. Contrast with AC-002 which uses `AttachmentDropGuard` and correctly cleans up even on panic.

  The only code paths that could panic between issue creation and teardown in AC-003 are:
  - `TempDir::new().expect("failed to create upload temp dir")` (line 11565)
  - `std::fs::write(...).expect("write test file")` (line 11567)
  - `h.cmd()...output().expect("failed to spawn jr attachment upload")` (line 11584)

  All three are environment-level failures (full filesystem, spawn error) rather than assertion failures, so the practical risk is low. The CI sweeper (label-based) does not work for EJ JSM issues per the CLAUDE.md gotcha, so orphaned EJ tickets would persist.
- **Evidence:** Lines 11450–11682 (AC-003), lines 11694–11908 (AC-004) — no `AttachmentDropGuard` constructed, no `defer` / RAII cleanup wrapper.
- **Proposed Mitigation:** Extend `AttachmentDropGuard` to include a `key` field for JSM issues (already done for AC-002) and use it in AC-003 and AC-004. This would make cleanup behavior consistent across all four JSM attachment tests.

---

### SEC-S576-6-003: Fixed attachment filenames not run-labeled; potential accumulation on reused issues

- **Severity:** LOW
- **CWE:** CWE-362 (Race Condition Through TOCTOU) — minimal; more accurately a test isolation design gap
- **OWASP:** N/A (test code only)
- **Attack Vector:** Not exploitable; test design concern.
- **Impact:** The four new tests upload files with fixed names:
  - AC-001: `"attachment-e2e-test.txt"` (line 10991)
  - AC-002: `"attachment-e2e-public.txt"` (line 11342)
  - AC-003: `"attachment-e2e-internal.txt"` (line 11566)
  - AC-004: `"attachment-e2e-noflag.txt"` (line 11804)

  Since each test seeds a fresh issue (AC-001 via `seed_issue`; AC-002/003/004 via `issue create --request-type`), the fixed filename does not cause collision between concurrent test runs, and JRACLOUD-96384 (same-filename coexistence) does not apply across different issues.

  However, the file *content* in AC-001 does include the run label (`format!("jr e2e attachment round-trip {}", rl)` at line 10993), while AC-002/003/004 embed a fixed S-576-6 story tag (`b"S-576-6 e2e public attachment echo shape"`) in the content. This means if the same issue key were ever reused (which it is not, since each run seeds a fresh issue), identical attachments could accumulate.

  The more significant observation is that existing pre-S-576-6 tests (`test_e2e_jsm_attachment_upload_public`, `test_e2e_jsm_attachment_upload_internal`) also use fixed filenames (`attachment-e2e-public.txt` is reused). If AC-002 and the existing S-576-5 test happened to execute on the same issue (they don't — they each create fresh issues), they would produce duplicate attachments. As designed today, no collision is possible.
- **Proposed Mitigation:** For defense-in-depth, embed the `run_id` in the filename (e.g., `format!("attachment-e2e-{run_id}-public.txt")`). This makes attachment origin traceable in test failures and eliminates any future confusion if the test structure changes. Not blocking.

---

## Negative Results (no finding)

### Focus Area 1 — Credential handling

`JR_AUTH_HEADER` is read in `E2eHarness::cmd()` (line 112) and passed directly to the subprocess environment (line 116). It is never:
- Embedded in an assert message or format string
- Printed to stdout or stderr by the test harness
- Asserted on or compared in test logic

The assertion messages in the new tests include `upload_stdout`, `upload_stderr`, `del_stdout`, `del_stderr`, `list_stdout`, etc. — these are outputs from the `jr` binary, which uses `--no-input` and no `--verbose`/`--verbose-bodies` flags in any of the new test commands. No credential leakage path is present.

### Focus Area 5 — Gating correctness

All four new tests carry both required gate layers:
1. `#[ignore = "set JR_RUN_E2E=1 and ... use --include-ignored to run"]` attribute
2. `if !e2e_enabled() { return; }` as the first statement in the function body

The always-run `test_every_ignored_test_has_gate_guard` meta-test (line 1184) mechanically validates this invariant by scanning the source text for violations. All four new tests comply.

### Focus Area 4 — Hardcoded data

No hardcoded Jira issue keys, org IDs, cloudIds, instance URLs, or real email addresses were found in lines 10904–11908 (the S-576-6 section). All project/instance references are read from env vars (`JR_E2E_PROJECT`, `JR_E2E_JSM_PROJECT`, `JR_E2E_BASE_URL`).

---

## Risk Register Dispositions

No security-category R-NNN entries in the S-576-6 domain spec were identified as unmitigated by this PR. The PR contains zero src/ changes, so no new attack surface is introduced. The existing security controls for attachment operations (CWE-22 sanitization via `sanitize_attachment_filename`, CWE-116 display sanitization, SEC-576-003 XSRF token, SEC-576-004 CRLF/NUL guard) are unchanged and untouched by this PR.
