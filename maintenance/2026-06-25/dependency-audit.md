# Dependency Audit — 2026-06-25

**Project:** jr (jira-cli) v0.6.0-dev.6
**Branch:** develop
**Scanned:** 346 crate dependencies (Cargo.lock)

---

## Tool Versions

| Tool | Version | Status |
|---|---|---|
| cargo-audit | 0.22.1 | Run — OK |
| cargo-deny | 0.19.6 | Run — OK |
| cargo-outdated | n/a | NOT INSTALLED — fallback: `cargo update --dry-run` |

Advisory database: RustSec advisory-db, 1138 advisories loaded (fetched 2026-06-25).

---

## Summary Table

| Tool | Status | Findings |
|---|---|---|
| cargo audit | PASS (exit 0) | 0 advisories |
| cargo deny — advisories | PASS (`advisories ok`) | 0 findings |
| cargo deny — licenses | PASS (`licenses ok`) | 3 unmatched-allowance warnings (benign, same as prior sweep) |
| cargo deny — bans | PASS (`bans ok`) | 0 findings |
| cargo deny — sources | PASS (`sources ok`) | 0 findings |
| cargo update --dry-run | INFO | 65 updates + 5 new crates + 27 removals available (all patch/minor) |

---

## Security Advisories

### cargo audit

**CLEAN — zero advisories found.**

cargo audit exit code: 0. No vulnerabilities detected across all 346 lockfile dependencies.

### cargo deny advisories

**CLEAN — `advisories ok`.**

---

## DELTA vs 2026-06-22

### RESOLVED (1)

| ID | Crate | Prior Version | Current Version | How Resolved |
|---|---|---|---|---|
| RUSTSEC-2026-0185 | quinn-proto | 0.11.14 (VULNERABLE) | **0.11.15** (FIXED) | Lockfile update was applied between sweeps; the 2026-06-22 sweep recommended `cargo update -p quinn-proto` as the preferred remediation. That recommendation was actioned. The advisory no longer fires. |

### NEW (0)

No new advisories introduced since 2026-06-22.

### PERSISTING (0)

No open advisories carry over from the prior sweep.

---

## License Check

`cargo deny check licenses` result: **PASS** (`licenses ok`)

Three unmatched allowances in `deny.toml` (same as 2026-06-22 sweep — no change):

| License | Status |
|---|---|
| BSD-2-Clause | Allowed but not used by any current dep |
| OpenSSL | Allowed but not used by any current dep |
| Unicode-DFS-2016 | Allowed but not used by any current dep |

These are warnings only. No action required. Defensive allowances for licenses that may appear in future deps or on different platforms.

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

The following crates have multiple versions in the dependency tree. All duplicates are unchanged from the 2026-06-22 sweep and remain benign.

| Crate | Versions Present | Root Cause |
|---|---|---|
| getrandom | 0.3.4, 0.4.2 | proptest (dev) pins rand 0.9 which needs getrandom 0.3; production rand 0.10 needs getrandom 0.4 |
| rand | 0.9.4, 0.10.1 | proptest (dev) pulls rand 0.9; jr production deps use rand 0.10 |
| rand_core | 0.9.5, 0.10.1 | Same rand version split above |
| serde_spanned | 0.6.9, 1.1.1 | figment pulls toml 0.8 (which needs serde_spanned 0.6); jr directly uses toml 1.1 |
| toml | 0.8.23, 1.1.2 | figment requires toml 0.8; jr uses toml 1.1 |
| toml_datetime | 0.6.11, 1.1.1 | Same toml version split above |
| winnow | 0.7.15, 1.0.0 | toml 0.8 uses winnow 0.7; toml 1.1 uses winnow 1.0 |

**Assessment:** All duplicates are across dev-dependency / production-dependency boundaries or from transitive figment constraints. No security concern. No cargo deny ban violations.

---

## Available Updates (cargo update --dry-run)

65 patch/minor updates available in the current semver-compatible range. No CRITICAL or security-relevant updates in the list. Notable items:

| Crate | Current | Available | Note |
|---|---|---|---|
| rustls | 0.23.37 | 0.23.41 | Security-adjacent (TLS library); worth including in next routine lockfile update |
| aws-lc-rs | 1.16.2 | 1.17.0 | Crypto library; minor update, routine |
| hyper | 1.8.1 | 1.10.1 | HTTP library; minor update |
| pulldown-cmark | 0.13.3 | 0.13.4 | jr direct dependency; patch update |
| quinn | 0.11.9 | 0.11.11 | QUIC (non-reachable in jr builds); transitive only |
| h2 | 0.4.13 | 0.4.15 | HTTP/2 library; minor update |
| tower-http | 0.6.8 | 0.6.11 | Minor update |
| zerocopy | 0.8.47 | 0.8.52 | Safety-critical zero-copy library; patch update |
| wasm-bindgen | 0.2.114 | 0.2.126 | Large jump; JS/WASM only (non-reachable in native builds) |
| thiserror | 1.0.69 | (removed — new version reorganization) | Major refactor in thiserror ecosystem |

27 removals are dependency clean-ups by upstream crates (various wit-*, wasm tooling, windows-sys v0.45, etc.) — these reduce lockfile bloat.

**Security-adjacent note on `rustls 0.23.37 -> 0.23.41`:** The rustls project has an active security patch cadence. Upgrading to 0.23.41 is recommended in the next routine `cargo update` run. Check the rustls CHANGELOG for any CVE entries in this range before merging.

**Recommendation:** Schedule a routine `cargo update` (lockfile-only, no Cargo.toml changes) to pull all 65 semver-compatible updates. This is a LOW-priority maintenance task, not a blocking security fix.

---

## Findings Summary

**FINDINGS: 0 (0 critical, 0 high, 0 medium, 0 low)**

The advisory database was fully scanned (1138 advisories) and no vulnerabilities were detected.

---

## VERDICT

**0 reachable HIGH; 0 advisories tracked. RUSTSEC-2026-0185 (quinn-proto) RESOLVED in lockfile since 2026-06-22 sweep. Dependency tree is clean.**

---

**Raw log:** `/Users/zious/Documents/GITHUB/jira-cli/.factory/maintenance/2026-06-25/dependency-audit-raw.log`
