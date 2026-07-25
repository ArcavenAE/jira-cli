---
phase: f6-targeted-hardening
dimension: security-scans
bundle: SOH-ATTACHMENTS-1
head_sha: db207b81
pre_bundle_base: 9da03d5b
tools: cargo-audit, cargo-deny (semgrep unavailable)
date: 2026-07-24
verdict: PASS
---

# F6 Dimension 4 — Security Scans

Scans run on the FULL dependency tree / repo (not diff-scoped), per F6 policy.

## Tool availability

| Tool | Status |
|---|---|
| cargo-audit | present (`~/.cargo/bin/cargo-audit`) — run |
| cargo-deny | present — run |
| semgrep | **NOT installed** (`semgrep not found`) — SKIPPED, documented |

## cargo audit

```
Loaded 1169 security advisories
Scanning Cargo.lock for vulnerabilities (356 crate dependencies)
```
Exit code **0**. **Zero vulnerabilities**, zero warnings across 356
dependencies.

## cargo deny check

Exit code **0**. Summary line: `advisories ok, bans ok, licenses ok, sources ok`.

Only 3 non-blocking `license-not-encountered` warnings (allowlisted licenses
present in `deny.toml` but not matched by any current dep):
`BSD-2-Clause`, `OpenSSL`, `Unicode-DFS-2016`. Benign — over-broad allowlist,
not a policy violation.

### Documented sha1/cpufeatures exception (DEC-185)

Present in `deny.toml` as a `[[bans.skip]]` (around line 282), NOT surfaced as a
finding:

> `name = "cpufeatures"`, `version = "0.2"` — "sha1 v0.10.7 (ADR-0017 S-576-2
> dependency for BC-2.7.010 batch-download SHA-1 path prefix) requires
> cpufeatures 0.2.17; chacha20 v0.10.0 (via rand v0.10.1) requires cpufeatures
> 0.3.0. Unavoidable until sha1 0.11 or rand's chacha20 unify... Authorized
> DEC-185."

This is the attachment-bundle's own dependency (sha1 for the batch-download
SHA-1 path prefix). The duplicate-`cpufeatures` ban is explicitly authorized and
does not represent a vulnerability — `cargo audit` (advisory DB) reports zero
issues for sha1/cpufeatures. `bans ok` confirms the skip is respected.

## CRITICAL / HIGH findings

**NONE.**

## Verdict

**PASS** — cargo audit clean (0 vulns), cargo deny clean (advisories/bans/
licenses/sources all ok), no CRITICAL/HIGH findings. semgrep unavailable
(documented skip; substituted by the always-run Rust security tooling).
