# SD-003: --verbose PII Redaction

**Status:** RESOLVED
**Owner:** Phase 3 SECURITY-DECIDE
**Deadline:** Resolved at Phase 1 → 2 gate (2026-05-04)
**References:** NFR-S-C (nfr-catalog.md), R-M0 (risk-register.md; previously tracked as R-H3 — see Pass 6 reclassification), `src/api/client.rs:200-203,274-278`

---

## Context

When `--verbose` is set, `client.rs` prints the full HTTP request body to stderr via `String::from_utf8_lossy`. This body includes:

- ADF comment text and issue descriptions (user-authored content)
- Issue summaries
- Account IDs and email addresses
- Any field value passed as JSON to the Jira API

The `Authorization` header is NOT logged (only the request method and URL), but the body is fully exposed.

**Risk scenarios:**
1. Developer pipes `jr ... 2>debug.log` for debugging — log file now contains PII and potentially sensitive content.
2. AI-agent harnesses (e.g., this Claude session) may capture `--verbose` stderr in transcripts — leaking payload bytes into AI training or logging pipelines.
3. Incident response engineers running `jr` with verbose logging in a shared terminal session expose colleague data.

---

## Options

### Option A: Add `redact_body()` helper (default on)

- Add `fn redact_body(body: &str) -> String` in `src/api/client.rs` or `src/observability.rs`.
- Replace field values matching patterns: `accountId`, `emailAddress`, and ADF `text` node content with `[REDACTED]`.
- Complex to implement correctly for arbitrary JSON; risk of over-redaction hiding useful debug signal.

### Option B: Header-only verbose by default; opt-in body logging

- Default `--verbose` shows: `[verbose] {METHOD} {URL}` + response status only.
- New flag `--verbose-bodies` enables body logging (explicit opt-in with PII awareness warning).
- Breaking change: developers who relied on `--verbose` for body inspection must migrate to `--verbose-bodies`.
- Clear UX contract; no regex-based redaction complexity.

### Option C: Document and defer (accepted risk)

- Add a warning to CLAUDE.md and `--help` text: "`--verbose` logs full request bodies. Do not use in shared terminals or AI-agent contexts where PII must not be captured."
- No code change.
- Acceptable only if the security review concludes the risk is LOW given current user base.

---

## Decision Log

| Date | Decision | Rationale |
|------|----------|-----------|
| TBD  | PENDING  | Awaiting Phase 3 security review |
| **Decide-by** | **Phase 1 → 2 gate** | Required before Phase 2 story decomposition begins (ADV-P2-009) |
| 2026-05-04 | Option B — header-only `--verbose` default + opt-in `--verbose-bodies` | Strongest security posture; eliminates AI-agent PII context capture by default; OWASP-aligned (DEBUG headers vs TRACE bodies); GDPR Article 32 compliant by data minimization. Single-conditional implementation. Breaking change with bounded migration. |

---

## Resolution

**Chosen option:** B (header-only default; `--verbose-bodies` opt-in)

**Rationale:** Research conducted at gate approval (perplexity deep_research, 2026-05-06) showed Option B is the strongest default security posture among the three options, with an order-of-magnitude smaller implementation surface than Option A (allowlist redaction). Critical context: jr is explicitly used in AI-agent contexts (per CLAUDE.md "AI Agent Notes" section), and the EDPB April 2025 AI Privacy Risks guidance flags AI-agent ingestion of unredacted CLI verbose output as a known PII exfiltration vector. Option B fully mitigates this by requiring an explicit opt-in for body logging — an action the AI agent or its operator must consciously take. Option A's JSON-aware redaction is still complex (ADF tree walker required) and carries false-positive risk that hides debug signal. Option C is explicitly disfavored by EDPB + OWASP guidance.

**Phase 3 implementation requirements:**
1. Add `--verbose-bodies` clap flag (false by default)
2. Modify `src/api/client.rs:200-203,274-278` to gate body printing on `verbose_bodies`:
   ```rust
   if cli.verbose_bodies {
       eprintln!("[verbose] body: {}", String::from_utf8_lossy(&body));
   } else if cli.verbose {
       eprintln!("[verbose] body suppressed (use --verbose-bodies to inspect, will print PII)");
   }
   ```
3. Add stderr warning when `--verbose-bodies` is set:
   ```rust
   if cli.verbose_bodies {
       eprintln!("[jr] WARNING: --verbose-bodies prints request/response bodies to stderr.");
       eprintln!("[jr] These bodies contain PII (accountId, emailAddress, ADF text content).");
       eprintln!("[jr] Do not pipe to AI-agent contexts or shared logs without consent.");
   }
   ```
4. Update `src/cli/mod.rs` `--verbose` help text: "verbose mode (headers + status + URL only; use --verbose-bodies for full body inspection)"
5. Update CLAUDE.md and `--help` to document the breaking change
6. Add holdout post-Phase-3:
   - **MUST-PASS**: `--verbose-bodies` MUST emit the PII warning to stderr
   - **MUST-PASS**: `--verbose` alone MUST NOT print body content
   - **MUST-FAIL** (regression check): if a future change inadvertently prints bodies under `--verbose` only, holdout fails

**Breaking change release notes (for v0.6 or next minor):**
> BREAKING: `--verbose` no longer prints HTTP request/response bodies by default. Use `--verbose-bodies` for full body inspection. The new flag emits a PII warning. Rationale: prevents accidental PII leakage in shared terminals, debug log files, and AI-agent context windows. See SD-003 for details.

## Resolution Requirement

Before closing this SD, the Phase 3 implementer must:
1. Choose Option A, B, or C.
2. If A or B: implement and add a test that verifies account IDs are not present in `--verbose` stderr output for a mock create-issue call.
3. Record the outcome in this document.
4. Update `cross-cutting.md §2` (`--verbose` mode documentation) to reflect the resolved behavior.
