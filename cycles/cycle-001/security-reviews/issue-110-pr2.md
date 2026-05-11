---
document_type: security-review
feature: issue-110-pr2
phase: F6-targeted-hardening
verdict: PASS
date: 2026-05-10
commit_range: "7704955..1ab056e"
---

# F6 Security Review — issue-110-pr2

**Date:** 2026-05-10
**Phase:** F6 Targeted Hardening
**Verdict:** F6 SECURITY PASS

---

## Pre-Checks

| Check | Result |
|-------|--------|
| `cargo deny check` | PASS — 0 advisories, 0 license violations |
| Full regression suite | 1169 passed / 0 failed / 17 ignored |
| `unsafe` blocks in PR2 delta | 0 |
| New dependencies | 0 |

---

## Security Scan Results

### SEC-PR2-001 [SUGGESTION] — CWE-117: Log Injection on `failureReason`

**Location:** `src/api/jira/bulk.rs` — `await_bulk_task` error path  
**Claim:** The `failureReason` field from the Atlassian bulk task response is included
directly in the error message returned to the caller (and ultimately printed to stderr). If
`failureReason` contains newlines, ANSI codes, or log-formatting characters, an attacker
controlling the Jira backend response could inject spurious log lines or terminal control
sequences.  
**Severity:** SUGGESTION (low exploitability — requires attacker control of Jira response)  
**Resolution:** Folded into existing issue #334 (`errorMessages CWE-117`), which already
tracks the same concern for other `errorMessages` fields. No fix required for this PR; the
existing issue covers the remediation approach (strip/sanitize before display).  
**Status:** Filed to #334, not blocking.

---

### SEC-PR2-002 [PASS] — Input Validation: `task_id` URL encoding

**Location:** `src/api/jira/bulk.rs` — `poll_bulk_task`  
**Claim:** `task_id` is URL-encoded via `urlencoding::encode` before insertion into the GET
path, preventing path traversal.  
**Verdict:** PASS — correct mitigation in place from PR1.

---

### SEC-PR2-003 [PASS] — Injection: JQL as query parameter

**Location:** `src/api/jira/issues.rs` — JQL search call  
**Claim:** JQL from `--jql` flag is passed as a URL query parameter via `reqwest`'s
`.query(&[("jql", jql)])` method, which handles URL encoding. JQL is not string-interpolated
into the URL path.  
**Verdict:** PASS — no injection risk. User-supplied JQL is limited to Jira's own query
engine; SSRF not applicable (endpoint is the configured Jira instance).

---

### SEC-PR2-004 [PASS] — DoS: Polling loop timeout

**Location:** `src/api/jira/bulk.rs` — `await_bulk_task`  
**Claim:** Bulk task poll loop has 5-minute hard cap (`MAX_WAIT = 300s`) and exponential
backoff (1s → 10s). Ctrl-C exits cleanly via the existing tokio Ctrl-C handler.  
**Verdict:** PASS — preserved from PR1. No regression.

---

### SEC-PR2-005 [PASS] — Access control: auth delegation

**Location:** All new HTTP call sites  
**Claim:** All new API calls (JQL search, bulk submit, bulk poll) go through
`JiraClient::send`, which handles 401 auto-refresh (via S-3.03 v2 refresh coordinator) and
429 rate-limit retry. No auth bypass surface introduced.  
**Verdict:** PASS.

---

### SEC-PR2-006 [PASS] — Input: JQL match cap before mutation

**Location:** `src/cli/issue/create.rs` — `handle_edit_with_jql`  
**Claim:** The JQL result set is capped by `--max` before the bulk edit call. Exceeding the
cap returns an error with no mutation. This prevents accidental bulk operations on unbounded
result sets.  
**Verdict:** PASS — `--max` default is 50; hard ceiling is 1000 (= Atlassian per-call limit).

---

## OWASP Top 10 Assessment

| Category | Status |
|----------|--------|
| A01 Broken Access Control | N/A — auth delegated to JiraClient::send; no new auth surface |
| A02 Cryptographic Failures | N/A — no new crypto surface |
| A03 Injection | PASS — JQL via query param; task_id URL-encoded; no string interpolation |
| A05 Security Misconfiguration | N/A — no new config paths |
| A09 Security Logging Failures | SUGGESTION — CWE-117 on failureReason → filed #334 |
| A10 SSRF | N/A — no new URL construction beyond configured Jira instance |

---

## Verdict

**F6 SECURITY PASS.** One non-blocking suggestion (SEC-PR2-001 / CWE-117) folded into
existing tracking issue #334. No changes required before merge. Proceeding to F7.
