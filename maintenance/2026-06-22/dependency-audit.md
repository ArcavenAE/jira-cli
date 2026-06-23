# Dependency Audit — 2026-06-22

**Project:** jr (jira-cli) v0.6.0-dev.6
**Branch:** develop
**Scanned:** 346 crate dependencies (Cargo.lock)

---

## Tool Versions

| Tool | Version | Status |
|---|---|---|
| cargo-audit | 0.22.1 | Run — OK |
| cargo-deny | 0.19.6 | Run — OK |
| cargo-outdated | n/a | NOT INSTALLED — skipped |

Advisory database: RustSec advisory-db, 1137 advisories loaded (fetched 2026-06-22).

---

## Security Advisories

### cargo audit

| ID | Crate | Version | Severity | CVSS | Summary | Fixed In | Dependency Path |
|---|---|---|---|---|---|---|---|
| RUSTSEC-2026-0185 | quinn-proto | 0.11.14 | **HIGH** | 7.5 | Remote memory exhaustion from unbounded out-of-order stream reassembly | >= 0.11.15 | `jr` → `reqwest 0.13.4` → `quinn 0.11.9` → `quinn-proto 0.11.14` |

**Advisory detail:** An attacker can send out-of-order QUIC stream data that quinn-proto buffers without bound, causing the server or client process to exhaust memory. Published 2026-06-22 (same day as this audit). URL: https://rustsec.org/advisories/RUSTSEC-2026-0185

### cargo deny advisories

Result: `advisories ok` — no additional findings beyond what cargo-audit reported.

---

## License Check

`cargo deny check licenses` result: **PASS** (`licenses ok`)

Three unmatched allowances in `deny.toml` (licenses listed as allowed but not encountered in the current dependency tree):

| License | Status |
|---|---|
| BSD-2-Clause | Allowed but not used by any current dep |
| OpenSSL | Allowed but not used by any current dep |
| Unicode-DFS-2016 | Allowed but not used by any current dep |

These are warnings only — they do not indicate a violation. They represent defensive allowances for licenses that may appear in future deps or on different platforms. No action required.

---

## Bans Check

`cargo deny check bans` result: **PASS** (`bans ok`)

No banned crates detected.

---

## Sources Check

`cargo deny check sources` result: **PASS** (`sources ok`)

All crates sourced from crates.io or expected locations.

---

## Duplicate Versions (cargo tree --duplicates)

The following crates have multiple versions in the dependency tree. All duplicates are benign — they arise from dev-dependency version divergence (proptest vs production deps) and figment's older toml dependency chain.

| Crate | Versions Present | Root Cause |
|---|---|---|
| getrandom | 0.3.4, 0.4.2 | proptest (dev) pins rand 0.9 which needs getrandom 0.3; production rand 0.10 needs getrandom 0.4 |
| rand | 0.9.4, 0.10.1 | proptest (dev) pulls rand 0.9; jr production deps use rand 0.10 |
| rand_core | 0.9.5, 0.10.1 | Same rand version split above |
| serde_spanned | 0.6.9, 1.1.1 | figment pulls toml 0.8 (which needs serde_spanned 0.6); jr directly uses toml 1.1 |
| toml | 0.8.23, 1.1.2 | figment requires toml 0.8; jr uses toml 1.1 |
| toml_datetime | 0.6.11, 1.1.1 | Same toml version split above |
| winnow | 0.7.15, 1.0.0 | toml 0.8 uses winnow 0.7; toml 1.1 uses winnow 1.0 |

**Assessment:** All duplicates are across dev-dependency / production-dependency boundaries or from transitive figment constraints. No security concern. The rand 0.9/0.10 split is dev-only (proptest). No cargo deny ban violations triggered.

---

## Findings Summary

**FINDINGS: 1 (0 critical, 1 high, 0 medium, 0 low)**

| # | ID | Crate | Severity | Action Required |
|---|---|---|---|---|
| 1 | RUSTSEC-2026-0185 | quinn-proto 0.11.14 | HIGH (CVSS 7.5) | Upgrade quinn-proto to >= 0.11.15 via reqwest bump |

**Remediation path:** quinn-proto is a transitive dep via `reqwest 0.13.4` -> `quinn 0.11.9` -> `quinn-proto 0.11.14`. The fix is to update reqwest to a version that pulls quinn-proto >= 0.11.15, or to add a `[patch.crates-io]` or direct `quinn-proto` dependency override in Cargo.toml if reqwest 0.13.x already supports the newer quinn-proto. Check whether a reqwest 0.13.x patch release has updated this transitive dep before taking action.

**Raw log:** `.factory/maintenance/2026-06-22/dependency-audit-raw.log`

---

## Sweep 1b — Security Triage

**Analyst:** security-reviewer
**Date:** 2026-06-22
**Advisory:** RUSTSEC-2026-0185 / quinn-proto 0.11.14

---

### SEC-001: RUSTSEC-2026-0185 — Remote Memory Exhaustion via QUIC Stream Reassembly

- **Severity:** HIGH (upstream CVSS 7.5); **NON-REACHABLE** in jr's compiled binary (see reachability analysis below)
- **CWE:** CWE-400 (Uncontrolled Resource Consumption)
- **OWASP:** A05:2021 — Security Misconfiguration (dependency with known vulnerability included in build artifact)
- **Attack Vector:** A remote attacker sends a stream of out-of-order QUIC stream data segments. quinn-proto buffers these without bound in its reassembly queue, causing the receiving process to exhaust heap memory and crash (OOM / SIGKILL). No authentication required; exploitable from any network position that can send QUIC packets to the affected process.
- **Impact (upstream):** Remote-triggered process crash / denial of service. In a server context, all in-flight connections are terminated. In a client context (jr's usage model), the CLI process itself would be OOM-killed mid-command.
- **Evidence:** See reachability analysis below — the exploitable code path is not compiled into the `jr` binary under its declared feature set.

---

### Reachability Analysis

**Cargo.toml declaration (jr):**

```toml
reqwest = { version = "0.13", default-features = false, features = ["json", "rustls"] }
```

`http3` is **not** listed. `default-features = false` explicitly opts out of reqwest's default feature set (which would otherwise include `http2` and `charset`, but not `http3`).

**reqwest 0.13 feature graph (from `cargo metadata`):**

The `http3` feature in reqwest 0.13 is defined as:

```
http3: ['rustls', 'dep:h3', 'dep:h3-quinn', 'dep:quinn', 'tokio/macros']
```

`dep:quinn` is gated behind the `http3` feature. The `quinn` dependency in reqwest's manifest is declared `optional = true`. The `__rustls-aws-lc-rs` feature (which IS activated) includes `quinn?/rustls-aws-lc-rs`, where the `?` operator means "if quinn is already activated, enable this feature on it" — it does NOT activate quinn itself.

**Resolved feature set for reqwest in this build:**

```
['__rustls', '__rustls-aws-lc-rs', '__tls', 'json', 'rustls']
```

`http3` is absent. Confirmed by `cargo metadata --format-version 1` resolve graph.

**cargo tree evidence:**

`cargo tree -f "{p} {f}"` shows reqwest built with `__rustls,__rustls-aws-lc-rs,__tls,json,rustls`. Quinn does NOT appear anywhere in the transitive `cargo tree` output for the jr binary. It appears in `Cargo.lock` because the lockfile records all crates that could be needed across all feature combinations of all dependencies — it is not a compilation manifest.

**JiraClient construction (src/api/client.rs):**

```rust
let client = Client::builder().timeout(Duration::from_secs(30)).build()?;
```

No `.http3_prior_knowledge()`, no `.http3()` builder call, no ALPN negotiation for h3. The client is a plain TLS/HTTP1.1+HTTP2 client. All API calls go to `https://api.atlassian.com` and `https://*.atlassian.net` over HTTPS/TCP, not QUIC.

**No source-level references to QUIC/HTTP3:** `grep -rn "http3|h3|Http3|quic|quinn" src/` returns zero matches.

**Conclusion:** quinn-proto 0.11.14 is present in Cargo.lock as a feature-gated transitive dependency that is never compiled into the `jr` binary under the declared feature set. The vulnerable QUIC stream reassembly code is dead — no QUIC transport is initialized, no QUIC connections are made, and no attacker-controlled QUIC stream data can reach quinn-proto's reassembly logic.

**Exploitability in context:** NON-REACHABLE. An attacker cannot trigger the OOM path in a jr process because jr never opens a QUIC socket.

---

### Remediation Options Evaluated

**Option A: `cargo update -p quinn-proto` (lockfile-only bump)**

Tested: `cargo update -p quinn-proto --dry-run` confirms quinn-proto 0.11.15 is available and semver-compatible within the 0.11.x range. Running `cargo update -p quinn-proto` successfully updates the lockfile to 0.11.15, and a subsequent `cargo audit --no-fetch` would show zero vulnerabilities (lockfile reverted after testing per instructions).

This option requires no Cargo.toml change and no reqwest version bump. It updates only the lockfile.

**Option B: `[patch.crates-io]` override in Cargo.toml**

Would work but is unnecessarily heavy for a non-reachable dep. Patch overrides persist and add maintenance burden.

**Option C: Wait for reqwest 0.13.x to pin quinn-proto >= 0.11.15**

Acceptable for a non-reachable dep but leaves the audit warning unresolved until reqwest releases. cargo audit scans the lockfile — it cannot distinguish reachable from non-reachable features — so the advisory will continue to fire on every CI run until the lockfile is updated.

**Preferred remediation:** Option A (`cargo update -p quinn-proto`). One-line lockfile update, no Cargo.toml change, resolves the audit finding cleanly, zero risk of behavioral regression (the code is dead and never executed).

---

### Risk Register Disposition

No `.factory/specs/` security R-NNN entries exist in this maintenance-sweep context. This advisory is the sole security finding.

---

### Recommendation

**DEFER-WITH-JUSTIFICATION (downgrade from HIGH to LOW effective severity)**

The upstream CVSS 7.5 / HIGH classification is appropriate for applications that use QUIC. For `jr` specifically:

- The vulnerable code is **not compiled** into the `jr` binary (feature-gated, dead transitive)
- There is **no QUIC socket**, no UDP listener, and no path for attacker-controlled QUIC stream data to reach quinn-proto
- The exploit requires an attacker to send crafted QUIC stream segments to a listening process — jr is a CLI that initiates outbound HTTPS/TCP connections only

**Effective severity for jr: LOW** (lockfile noise, not a reachable vulnerability)

**Recommended action:** Include `cargo update -p quinn-proto` in the next routine maintenance commit (not a blocking emergency fix). This resolves the cargo-audit finding before the next CI run and keeps the lockfile tidy. No VSDD Feature Mode pipeline entry is required — this is a one-line lockfile update with no source changes.

Do NOT classify this as a CRITICAL or HIGH blocker for the current development cycle. The finding does not require a hotfix release.

**Note for cargo-deny / CI:** Consider adding `RUSTSEC-2026-0185` to the `deny.toml` `[advisories]` ignore list as a temporary measure if the lockfile update is not merged before the next CI run, to prevent false-positive CI failures on a non-reachable advisory. Remove the ignore entry once the lockfile is updated.
