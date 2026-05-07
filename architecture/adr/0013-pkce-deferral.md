---
document_type: architecture-decision-record
adr_number: "0013"
status: Accepted
date: 2026-05-04
supersedes: []
superseded_by: []
related: ["ADR-0006", "SD-001", "BC-1.5.036", "NFR-S-A", "NEW-INV-178", "R-M1"]
---

# ADR-0013: PKCE Deferral for OAuth 2.0 Authorization Code Flow

## Status

**Accepted** (2026-05-04). Reactivation trigger: Atlassian announces public PKCE support for 3LO Jira Cloud.

## Context

`jr` uses Atlassian OAuth 2.0 (3LO) authorization code flow with an embedded `client_secret` (per ADR-0006). RFC 8252 §8.1 recommends PKCE (RFC 7636) for native applications regardless of confidential-client status, providing defense-in-depth against authorization code interception attacks.

At Phase 1 → 2 gate (2026-05-04), the project evaluated three PKCE adoption options under SD-001:
- **Option A:** Add PKCE alongside existing `client_secret` (PKCE + secret simultaneously)
- **Option B:** Migrate to public-client flow (PKCE only, no secret)
- **Option C:** Defer with documented mitigation

Research conducted at gate approval (perplexity deep_research, 2026-05-06) determined that **Atlassian Jira Cloud OAuth 2.0 (3LO) does NOT publicly support PKCE**:

1. Atlassian Developer Console exposes no PKCE configuration controls (no `code_challenge_method` registration, no public-client option)
2. Official Jira Cloud OAuth 2.0 (3LO) documentation makes no mention of `code_challenge`, `code_challenge_method`, or `code_verifier` parameters
3. Community evidence (Atlassian Community discussions) indicates internal feature-flag PKCE capability exists but is "not exposed on the dev console"
4. Jira Server/Data Center OAuth provider has documented PKCE support but with known issue OAUTH20-2491 (rejects PKCE flows without `client_secret`, violating RFC 7636)
5. Bitbucket Cloud explicitly does not support PKCE

This makes Options A and B technically infeasible, not merely suboptimal:
- Option A requires Atlassian's `/oauth/token` to accept `code_verifier` + `client_secret` simultaneously — undocumented and unverified; likely silently ignored
- Option B requires public-client registration in Atlassian Developer Console — does not exist as a registration option

## Decision

**Defer PKCE adoption for jr v0.5/v0.6 with documented threat-model mitigation.**

The OAuth 2.0 authorization code flow without PKCE will continue to be used for both BYO OAuth (user-provided client) and embedded jr OAuth (per ADR-0006). The `client_secret` is XOR-obfuscated per ADR-0006 for the embedded variant.

## Consequences

### Threat Model

The primary threat PKCE protects against is **authorization code interception**. For jr, this attack requires:
1. A malicious application running on the same host as `jr`
2. Binding to the fixed callback port `127.0.0.1:53682` (registered in Atlassian Developer Console for jr's embedded OAuth app)
3. Winning the OS first-listener race for the browser's callback delivery
4. Exchanging the intercepted code for a token using the embedded `client_secret` (which the attacker would also need to extract from the jr binary)

### Mitigations Already in Place

1. **`jr` binds the listener BEFORE launching the browser** (per BC-1.5.x flow). Per macOS/Linux first-listener-wins semantics, a malicious app starting after `jr` cannot displace `jr`'s listener.
2. **Fixed callback port `127.0.0.1:53682`** — explicitly bound to IPv4 (not `localhost`, which can resolve to IPv6 via `::1` on macOS/Chrome and miss the listener). Reduces attack surface vs. dynamic ports.
3. **XOR-obfuscated `client_secret`** in embedded OAuth (per ADR-0006). Not a strong secret, but adds friction to extraction. An attacker must reverse-engineer the binary AND intercept the code AND win the listener race.
4. **BYO OAuth** path allows users to register their own Atlassian OAuth app and provide `client_id`/`client_secret` via keychain. This eliminates the embedded-secret extraction concern for security-conscious users.

### Residual Risk

A sufficiently capable attacker with persistent same-host code execution could:
- Reverse-engineer the XOR obfuscation and extract embedded `client_secret`
- Pre-position a callback listener that competes with jr's first-listener-wins (e.g., via daemon)
- Phish a user into running a poisoned `jr`-alike that captures the auth code and performs token exchange

**Risk classification:** R-M1 in risk-register.md (MEDIUM). Acceptable for v0.5 hardening goals; not acceptable indefinitely.

### Reactivation Trigger

This ADR will be re-opened when ANY of the following occurs:
1. Atlassian announces public PKCE support for 3LO Jira Cloud (monitor developer.atlassian.com changelog, Atlassian Community announcements)
2. Atlassian Developer Console adds PKCE configuration controls
3. Atlassian publishes guidance on PKCE for native applications using 3LO
4. OAuth 2.1 enforcement begins on Atlassian endpoints (OAuth 2.1 mandates PKCE for all authorization code flows)

When reactivated, re-evaluate Options A and B from SD-001 against the new evidence.

### Impact on Codebase

- `BC-1.5.036` retains its "no PKCE" body content with reference to this ADR
- `NEW-INV-178` ("OAuth flow does not implement PKCE") is now backed by ADR-0013 rather than being an undocumented gap
- `NFR-S-A` (HIGH severity, PKCE recommendation) is reclassified to DOCUMENTED-AS-IS with reactivation trigger
- `R-M1` retains MEDIUM severity with this ADR as the documented mitigation

## References

- ADR-0006 (Embedded OAuth app with XOR obfuscation)
- SD-001 (PKCE Adoption Decision)
- BC-1.5.036 (OAuth authorization code flow body)
- NFR-S-A (PKCE recommendation, now DOCUMENTED-AS-IS)
- NEW-INV-178 (OAuth no-PKCE invariant)
- R-M1 (PKCE absence risk)
- RFC 7636 (Proof Key for Code Exchange)
- RFC 8252 (OAuth 2.0 for Native Apps)
- Perplexity research artifact at gate approval (2026-05-06)
