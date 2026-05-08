---
document_type: security-review
wave: 2
pass: 01
producer: security-reviewer
date: 2026-05-08
diff_range: ab19783..ca22be0
verdict: LOW-RISK
findings_count: 5
critical: 0
high: 0
medium: 1
low: 2
info: 2
files_reviewed: 8
---

# Security Review — Wave 2 Gate Pass 01

## Scope

Wave 2 squash-merged PRs #303–#309 (S-2.01 through S-2.07).
Diff range: `ab19783..ca22be0`. 72 files, 5,889 insertions, 17 deletions.

High-leverage areas reviewed in priority order:
1. `src/cli/auth.rs` (+205 lines) — S-2.07 JSON output branches for 4 auth subcommands
2. `src/main.rs` (+12 lines) — call-site threading of `&cli.output`
3. `src/api/jira/worklogs.rs` (+8/-4 lines) — `timeSpent` string passthrough
4. `src/duration.rs` (+76 lines) — `parse_duration_validate` input validator
5. `tests/auth_output_json.rs` (363 lines, new) — process-spawn integration tests
6. `src/api/jira/issues.rs`, `src/api/jira/users.rs` — comment-only pagination fixes

Files reviewed: `src/cli/auth.rs`, `src/main.rs`, `src/api/jira/worklogs.rs`,
`src/duration.rs`, `src/cli/worklog.rs`, `tests/auth_output_json.rs`,
`src/api/jira/issues.rs`, `src/api/jira/users.rs`

---

## Verdict: LOW-RISK

No CRITICAL or HIGH findings. The wave's credential handling and JSON output
paths are safe to merge. The single MEDIUM finding (error message input
reflection without a size cap) is a DoS concern in extremely adversarial
scenarios but has no memory-safety impact and is not reachable remotely. Two
LOW findings document pre-existing behaviors that this wave did not change.
Two INFO observations round out the review.

---

## Findings

### WV2-SEC-01: `parse_duration_validate` reflects unbounded user input into error messages without a length cap

- **Severity:** MEDIUM
- **CWE:** CWE-400 (Uncontrolled Resource Consumption), CWE-209 (Generation of Error Message Containing Sensitive Information — minor aspect)
- **OWASP:** A05:2021 Security Misconfiguration (excess error verbosity); A07:2021 Identification and Authentication Failures is not applicable here.
- **Category:** injection / input-validation
- **Attack Vector:** A user passes an arbitrarily long string as the `duration` positional argument to `jr worklog add PROJ-1 <DURATION>`. The validator at `src/duration.rs:parse_duration_validate` strips whitespace (`chars().filter(|c| !c.is_whitespace()).collect()`) and then allocates a second owned `String` of the same length (`input_lower = normalised.to_lowercase()`). On rejection, the full original input (up to OS argv limit, typically 2 MB) is interpolated into an error message via `format!("Invalid duration \"{input}\": ...")` and rendered to stderr via the anyhow error chain.
- **Impact:** Memory allocation of approximately 3x the input length during validation, plus the allocation for the formatted error string. No remote exposure (this is a CLI tool); no silent data exfiltration. The risk is localized to adversarial local execution (e.g., shell injection feeding an enormous string). No stack overflow — Rust string operations are heap-allocated. No null-byte or CR/LF injection into the error message itself because the format string embeds the raw input surrounded by quotes, and the output is stderr text; no structured log is populated.
- **Evidence:**
  ```
  // src/duration.rs:23-25
  let normalised: String = trimmed.chars().filter(|c| !c.is_whitespace()).collect();
  let input_lower = normalised.to_lowercase();
  // ... later on error:
  // src/duration.rs:35-37
  return Err(JrError::UserError(format!(
      "Invalid duration \"{input}\": a unit letter appeared before any number. ..."
  ```
  No length guard before line 23. The original `input` variable (up to argv limit) is embedded verbatim in every error path.
- **Proposed Mitigation:** Add a length guard before the whitespace-strip:
  ```rust
  const MAX_DURATION_INPUT_LEN: usize = 64;
  if trimmed.len() > MAX_DURATION_INPUT_LEN {
      return Err(JrError::UserError(format!(
          "Duration string too long ({} chars, max {}). Use format: Nw Nd Nh Nm",
          trimmed.len(), MAX_DURATION_INPUT_LEN
      )).into());
  }
  ```
  A valid duration like `999w999d23h59m` is 15 chars; 64 is generous. The truncated error message avoids reflecting the full attack payload.
- **Wave-2 Change:** This code was introduced in this wave (S-2.06). Not a pre-existing issue.

---

### WV2-SEC-02: `login_oauth` always writes a human-readable success message to stderr in JSON mode (UX noise, not a credential leak)

- **Severity:** LOW
- **CWE:** CWE-209 (Generation of Error Message Containing Sensitive Information) — not triggered here, but the behavioral asymmetry warrants documentation.
- **OWASP:** Not applicable.
- **Category:** other (output-consistency)
- **Attack Vector:** N/A — not exploitable.
- **Impact:** When `jr auth login --oauth --output json` is invoked, `login_oauth` calls `output::print_success("Authenticated with {site_name}")` before returning. Because `print_success` uses `eprintln!`, the message goes to stderr. `handle_login` then emits the clean `{"profile":..., "action": "login", "ok": true}` JSON to stdout. No credential is present in either output. However, a caller that treats stderr as an error signal (e.g., `if [ -n "$(jr auth login --oauth --output json 2>&1 1>/dev/null)" ]; then ...`) will see unexpected output. The API-token path (`login_token`) only emits `"Credentials stored in keychain."` on stderr, which is the same noise.
- **Evidence:**
  ```
  // src/cli/auth.rs:529
  output::print_success(&format!("Authenticated with {}", result.site_name));
  // output::print_success uses eprintln! (src/output.rs:45-47)
  ```
  After `login_oauth` returns `Ok(())`, `handle_login` checks `args.output == Json` and prints JSON to stdout. The stderr message from `login_oauth` is not suppressed in JSON mode.
- **Proposed Mitigation:** Pass `output_format` into `login_oauth` and `login_token`, or suppress their human messages when the caller is in JSON mode. Low priority; not a security issue per se. Document as a known UX asymmetry in `docs/specs/json-output-shapes.md`.

---

### WV2-SEC-03: `JR_AUTH_HEADER` env var bypass is correctly gated to `#[cfg(debug_assertions)]` — confirming existing control (pre-existing, unchanged by this wave)

- **Severity:** LOW
- **CWE:** CWE-295 (Improper Certificate Validation) is not applicable; most relevant: CWE-798 (Use of Hard-coded Credentials) — informational note on the test-bypass pattern.
- **OWASP:** A07:2021 Identification and Authentication Failures.
- **Category:** authz / config
- **Attack Vector:** Not applicable in release builds.
- **Impact:** `src/api/client.rs` accepts `JR_AUTH_HEADER` as a credential override only when compiled with `debug_assertions` (i.e., `cargo build`, not `cargo build --release`). This wave's integration tests in `tests/auth_output_json.rs` correctly remove `JR_AUTH_HEADER` from the environment via `cmd.env_remove("JR_AUTH_HEADER")` in the `jr_isolated` helper (line ~89). No change to this gate was introduced in Wave 2. Reviewed here for completeness.
- **Evidence:**
  ```
  // src/api/client.rs:70-79
  #[cfg(debug_assertions)]
  let auth_header = if let Ok(header) = std::env::var("JR_AUTH_HEADER") { ... };
  #[cfg(not(debug_assertions))]
  let auth_header = Self::load_auth_from_keychain(auth_method, &config.active_profile_name)?;
  ```
  And in tests:
  ```
  // tests/auth_output_json.rs:~89
  .env_remove("JR_AUTH_HEADER")
  ```
- **Proposed Mitigation:** None required. The `#[cfg(debug_assertions)]` gate is correct. Consider adding a CI policy note that `cargo build --release` must be used for all distribution artifacts (already stated in CLAUDE.md).

---

### WV2-SEC-04: `timeSpent` string is passed to `serde_json::json!()` macro, which provides proper JSON escaping (no injection risk)

- **Severity:** INFO
- **CWE:** CWE-74 (Improper Neutralization of Special Elements — injection) — not triggered; included for audit completeness.
- **OWASP:** A03:2021 Injection.
- **Category:** injection
- **Attack Vector:** A user passes a duration string containing JSON-special characters (e.g., `1d"injected": "value`) to `jr worklog add`.
- **Impact:** None. The duration validator (`parse_duration_validate`) rejects any character that is not an ASCII digit or one of `w`, `d`, `h`, `m` (after whitespace stripping). The regex-equivalent character set accepted is `[0-9wdhm ]+`. A double-quote, comma, colon, or backslash would be caught as an unknown unit and return a `JrError::UserError` before `add_worklog` is called. Even if somehow bypassed, the value is passed to `serde_json::json!({ "timeSpent": time_spent })` which serializes the string with proper escaping.
- **Evidence:**
  ```
  // src/cli/worklog.rs:32
  duration::parse_duration_validate(dur)?;   // rejects non-[0-9wdhm ] chars
  // src/api/jira/worklogs.rs:21-24
  let mut body = serde_json::json!({
      "timeSpent": time_spent,   // serde_json escapes the value
  });
  ```
- **Proposed Mitigation:** No action required. Defense-in-depth is present: validator rejects injection chars; `serde_json` escapes the remainder. The explicit comment on `add_worklog` ("caller is responsible for validating via `parse_duration_validate`") is appropriate contract documentation.

---

### WV2-SEC-05: Test file `auth_output_json.rs` uses clearly fake credentials and correct XDG isolation

- **Severity:** INFO
- **CWE:** CWE-798 (Use of Hard-coded Credentials) — not triggered; included to document clean bill of health.
- **OWASP:** Not applicable.
- **Category:** credential-exposure / config
- **Attack Vector:** N/A.
- **Impact:** No real credentials or instance URLs appear in the new test file. All URL values are `https://test.atlassian.net` / `https://staging.atlassian.net` (clearly fictional). The email is `test@example.com`. The token literal is `TEST-TOKEN`. The keychain is scoped to `JR_SERVICE_NAME=jr-jira-cli-test` to avoid touching developer entries. All production `JR_*` env vars are removed via `env_remove()` calls in the `jr_isolated` helper. XDG directories are isolated via `tempfile::TempDir`.
- **Evidence:**
  ```
  // tests/auth_output_json.rs:~75-90
  .env("JR_SERVICE_NAME", "jr-jira-cli-test")
  .env_remove("JR_PROFILE")
  .env_remove("JR_BASE_URL")
  .env_remove("JR_AUTH_HEADER")
  .env_remove("JR_EMAIL")
  .env_remove("JR_API_TOKEN")
  .env_remove("JR_OAUTH_CLIENT_ID")
  .env_remove("JR_OAUTH_CLIENT_SECRET")
  // ...
  "--token", "TEST-TOKEN"  // tests/auth_output_json.rs:339
  ```
- **Proposed Mitigation:** No action required. The test infrastructure is correctly hardened.

---

## JSON Output Credential Exposure Assessment

The core concern for this wave's `--output json` auth branches is: **do any JSON output paths leak credentials, tokens, or session identifiers?**

**Finding: CLEAN.**

All four new auth JSON responses (`login`, `switch`, `logout`, `remove`) emit only:
```json
{"profile": "<name>", "action": "<verb>", "ok": true}
```
No token values, no hashed credentials, no cloud IDs, no org IDs. Profile names are user-chosen non-secret identifiers.

The pre-existing `auth refresh` JSON payload (`refresh_success_payload`) emits:
```json
{"status": "refreshed", "auth_method": "api_token|oauth", "next_step": "<hint string>"}
```
The `next_step` is a hardcoded string constant (`REFRESH_HELP_LINE`) about keychain prompts — no credential values.

The `auth list` JSON output (`render_list_json`) emits per-profile objects with fields `name`, `url`, `auth_method`, `status`, `active`. No keychain-stored credentials (tokens, passwords, OAuth tokens) are serialized — only the configuration metadata from `config.toml`.

The `auth status` command still uses `println!` directly (Table mode only, unchanged by this wave). It prints "Credentials: stored in keychain" / "Credentials: not found" — a boolean probe, not the credential value itself.

---

## Risk Register Dispositions

No L2 Domain Spec with a security-category Risk Register was provided for this project in the factory artifacts directory. The review was conducted against the adversarial findings file (`wave-2-gate-pass-01.md`) and direct source analysis. No security-specific R-NNN entries were identified in scope; this section is acknowledged as not applicable for this wave.

---

## Formal-Verifier Scan Triage

No `security-scan-report.md` was present for Wave 2. Cargo audit / Semgrep results were not produced as a Wave 2 artifact. No triage required.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0     |
| HIGH     | 0     |
| MEDIUM   | 1     |
| LOW      | 2     |
| INFO     | 2     |
| **Total**| **5** |

### Merge Recommendation

**APPROVED with LOW-RISK classification.** The wave's auth/credential handling is safe to merge. The single MEDIUM finding (WV2-SEC-01 — unbounded input in duration error messages) is a local-execution DoS nuisance with no remote attack surface, no credential exposure, and no memory-safety impact. It should be addressed as a follow-up hardening task before v1.0. There are no CRITICAL or HIGH findings that block integration.

The two LOW findings document pre-existing controls (WV2-SEC-03) and a behavioral asymmetry in OAuth login output mode (WV2-SEC-02), neither of which represents a credential exposure risk.

The key security invariants for this wave are confirmed:
- JSON output paths emit zero credential material
- Error paths do not print credentials to stdout or stderr
- `refresh_success_payload` is unchanged and contains no token values
- Test fixtures use clearly fake tokens isolated via XDG sandboxing
- Duration injection is fully blocked by character-allowlist validation before JSON serialization
- `JR_AUTH_HEADER` bypass is correctly restricted to debug builds (unchanged)
