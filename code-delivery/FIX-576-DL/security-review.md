---
document_type: security-review
level: ops
version: "1.0"
status: approved
producer: security-reviewer
timestamp: 2026-07-23T00:00:00
phase: per-story-pr
inputs:
  - src/api/jira/attachments.rs
  - tests/attachment_download.rs
input-hash: "18d8b72"
traces_to: "FIX-576-DL"
total_findings: 2
critical: 0
high: 0
medium: 0
low: 2
files_reviewed: 2
---

# Security Review: FIX-576-DL — AttachmentMetadata Integer-ID Deserializer

**VERDICT: APPROVE — no CRITICAL or HIGH findings.**

## Executive Summary

The fix adds a custom serde `Visitor` on `AttachmentMetadata.id` that accepts both JSON
string and integer representations, coercing both to `String`. The change is narrowly
scoped: the visitor is applied only to `AttachmentMetadata.id` (the metadata-endpoint
response type); `AttachmentObject.id` (the list-endpoint response type) remains
string-only. Critically, the deserialized `metadata.id` value is never used for URL
construction — both the step-1 metadata GET and the step-2 content GET use the
CLI-validated `id_str` argument, not the deserialized field. No injection, overflow, or
SSRF risks are present. Two LOW findings are noted: a `visit_f64` gap that could cause
a functional error if Jira ever sends a float ID, and missing unit-level edge-case tests
for the visitor function itself.

---

## Findings

### SEC-001: `visit_f64` not handled — float ID would cause deserialization error
- **Severity:** LOW
- **CWE:** CWE-228 (Improper Handling of Syntactically Invalid Structure)
- **OWASP:** N/A
- **Attack Vector:** If Jira Cloud ever returns `"id": 10008.0` (a JSON float) from
  `GET /rest/api/3/attachment/{id}`, serde dispatches `visit_f64`. The visitor does not
  implement `visit_f64`, so the default `Visitor::visit_f64` returns an error via the
  `expecting()` message ("a string or integer attachment id"). The download fails with a
  deserialization error. This cannot be triggered by user input (the `--id` CLI value
  is user-controlled but validated as all-digits before reaching the deserializer; the
  float would have to originate from Jira's response).
- **Impact:** Operational failure — `jr issue attachment download --id <AID>` exits 1
  with a serde error message. No security impact; no memory safety issue. A float ID
  from Jira would be a server-side protocol violation (IDs are always integers).
- **Evidence:** `src/api/jira/attachments.rs` lines 39–71 — the `StringOrIntVisitor`
  implements `visit_str`, `visit_string`, `visit_u64`, `visit_i64`, `visit_u128`,
  `visit_i128` but not `visit_f64`. With `deserialize_any`, serde_json dispatches
  float tokens to `visit_f64`. The default implementation returns `Err(E::invalid_type(Unexpected::Float(v), &self))`.
- **Proposed Mitigation:** Add a `visit_f64` arm that rounds to the nearest integer and
  converts to string, or accepts float-shaped integers (where the fractional part is
  zero) and rejects otherwise. Given that Jira attachment IDs are always integral, a
  simple `visit_f64(self, v: f64) -> Result<String, E> { Ok((v as u64).to_string()) }`
  (with a guard `if v.fract() != 0.0 { return Err(...) }`) is sufficient. This is
  a resilience improvement, not a security requirement; acceptable to defer.

---

### SEC-002: Missing edge-case unit tests for `deserialize_string_or_int_as_string`
- **Severity:** LOW
- **CWE:** CWE-1048 (Insufficient Coverage of Code)
- **OWASP:** N/A (test coverage gap)
- **Attack Vector:** Not directly exploitable. The gap means that if future code changes
  alter the visitor's behaviour for unusual inputs (negative integers, i128/u128 boundary
  values, or the float gap), no unit-level regression fires. The two integration tests
  (`test_download_integer_id_in_metadata_succeeds`, `test_download_string_id_in_metadata_still_succeeds`)
  exercise only a single representative positive integer (`10008`) and a typical string
  (`"10009"`).
- **Impact:** Silent regression risk. If the visitor is modified and the change breaks
  negative-integer or large-integer handling, the integration tests would not catch it
  unless a future live Jira response happened to exercise those code paths.
- **Evidence:** The visitor handles `i64` and `i128` (negative integers are accepted and
  converted to strings such as `"-12345"`). This is safe because `metadata.id` is never
  used for URL construction (see Positive Findings below), but the behaviour for negative
  integers is unspecified in the design doc and untested. Similarly, `u128::MAX` is
  accepted and produces a 39-character decimal string; this is also untested.
- **Proposed Mitigation:** Add inline unit tests (in the `#[cfg(test)] mod tests` block
  of `src/api/jira/attachments.rs`) covering: (a) a negative i64 value, (b) `u64::MAX`,
  (c) a zero value, (d) the float-rejection case. These tests can use
  `serde_json::from_value::<AttachmentMetadata>(...)` to exercise the full path.

---

## Summary Table

| ID      | Severity | CWE       | Location                                  | Status         |
|---------|----------|-----------|-------------------------------------------|----------------|
| SEC-001 | LOW      | CWE-228   | `src/api/jira/attachments.rs` lines 39–71 | open (defer)   |
| SEC-002 | LOW      | CWE-1048  | `tests/attachment_download.rs` lines 3242–3353 | open (defer) |

---

## Positive Findings (Defensive Measures Present)

1. **Scope containment verified.** `AttachmentObject.id` (line 85 in
   `src/api/jira/attachments.rs`) uses plain `String` with no `deserialize_with`
   attribute. The new visitor is applied exclusively to `AttachmentMetadata.id` via
   `#[serde(deserialize_with = "deserialize_string_or_int_as_string")]` at line 143.
   There is no risk of the integer-accepting behaviour spreading to the list path.

2. **No URL injection from deserialized ID.** `handle_single_download` constructs
   both the step-1 and step-2 URLs from `id_str` (the CLI argument, validated as
   all-ASCII-digits at lines 1028–1033 of `src/cli/issue/attachments.rs`), not from
   `metadata.id`. The deserialized `metadata.id` value is stored but never passed to
   any HTTP call. Path construction is therefore immune to any attacker-influenced
   integer value in the JSON response.

3. **No integer overflow or truncation.** Rust's integer-to-string conversion (`u64::to_string()`,
   `i64::to_string()`, etc.) is infallible and lossless across all integer types. The
   largest possible value (`u128::MAX` = 340282366920938463463374607431768211455, 39 chars)
   is represented exactly in the output string. No truncation, no panic, no undefined
   behaviour.

4. **No SSRF risk.** The `get_attachment_content` function (line 482) constructs the
   content URL as `/rest/api/3/attachment/content/{id}` where `id` is the CLI-validated
   `id_str`. Integer output from the visitor (digits only, possibly with a leading `-`)
   cannot contain path separators (`/`), null bytes, or scheme indicators. Even if the
   deserialized value were used, the URL template constrains the format to a Jira API
   sub-path on the already-authenticated client.

5. **Negative integers cannot produce path traversal.** Even if a server-supplied `i64`
   produces a string like `"-12345"`, the `-` character is not a path separator in URL
   paths, and the value is never used for local filesystem path construction.

6. **Redirect credential-stripping correct.** reqwest strips `Authorization` headers on
   cross-host redirect (GHSA-9857-6MW7-FQ2M), confirmed by
   `test_bc_2_7_007_auth_absent_on_redirect_target`. This is correct CDN behaviour and
   is independent of the FIX-576-DL change.

---

## Risk Register Dispositions

No L2 Domain Spec security-category R-NNN entries were loaded (this is a targeted
bug-fix review, not a wave-level review). The CLAUDE.md documents the relevant security
controls: SEC-576-001/002 (CWE-22 disk path), SEC-576-003 (CWE-93 CRLF), SEC-576-004
(Content-Disposition NUL/CRLF guard). None of these are affected by the FIX-576-DL
change.

---

## Recommendations Priority

### Immediate (before merge)
None. No CRITICAL or HIGH findings.

### Before Release
- SEC-001: Add `visit_f64` to `StringOrIntVisitor` for resilience against a hypothetical
  Jira protocol drift where float IDs appear. Low urgency — Jira IDs are always integral.

### Post-Release
- SEC-002: Add inline unit tests exercising negative integers, zero, and `u64::MAX`
  through `deserialize_string_or_int_as_string` to prevent silent regression if the
  visitor is later modified.
