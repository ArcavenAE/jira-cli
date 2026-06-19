# Dependency Audit — 2026-06-19

**Repo:** `jira-cli` (`jr`), branch `develop`, commit `71f33c6` (v0.6.0-dev.5)
**Rust toolchain target:** `1.85`
**Total Cargo.lock entries:** 346 crates (unchanged from 2026-06-17)
**Tools used:** cargo-audit 0.22.1, cargo-deny 0.19.6, `cargo update --dry-run`
**cargo-outdated:** NOT installed (not in PATH); root-dep analysis performed via dry-run + manual Cargo.toml review

**Prior run:** `.factory/maintenance/2026-06-17/dependency-audit.md`, commit `3ba8ea2`

---

## Executive Summary

| Category | Count | Blocking? |
|----------|-------|-----------|
| RUSTSEC CVEs (cargo audit) | **0** | No |
| Yanked crates (cargo audit --deny yanked) | **0** | No |
| cargo-deny violations | **0** | No |
| cargo-deny warnings (stale allow-list entries) | 3 | No |
| Outdated: major/minor transitive bumps available | 3 major paths | No |
| Outdated: minor/patch transitive bumps available | ~87 packages | No |
| deny.toml skips that become stale after `cargo update` | 11–13 entries | No (post-update cleanup) |

**Pipeline status: GREEN. No RUSTSEC advisories. No blocking issues.**

**Security-reviewer triage required: NO** — zero CVEs, zero RUSTSEC advisories, zero yanked crates.

---

## Change Delta Since 2026-06-17 (commit 3ba8ea2 → 71f33c6)

No new RUSTSEC advisories or security regressions were introduced between the two commits. The dry-run output is more comprehensive than the prior run (87 vs ~60 packages), primarily because `jni 0.21→0.22` and `rustls-platform-verifier 0.6→0.7` are now both confirmed available, and their cascade removes the older windows-sys/thiserror lineages (which the June 17 report predicted). Key differences:

| Change | Prior (2026-06-17) | Current (2026-06-19) |
|--------|--------------------|----------------------|
| RUSTSEC vulns | 0 | 0 (no change) |
| Advisory DB entries | 1134 | 1134 (no change) |
| Yanked crates | not checked | 0 |
| cargo-deny exit code | 0 | 0 (no change) |
| jni upgrade available | 0.21→0.22 predicted | Confirmed in dry-run |
| rustls-platform-verifier | 0.6→0.7 predicted | Confirmed in dry-run |
| windows-sys 0.45 removal | predicted if jni bumps | Confirmed in dry-run |
| thiserror 1.x removal | predicted if jni bumps | Confirmed in dry-run |
| wit-bindgen 0.51 removal | predicted if getrandom topology changes | Confirmed in dry-run |
| hashbrown topology | unknown | 0.15.5/0.16.1 → 0.17.1 (consolidated) |
| New crates added | — | `jni-macros 0.22.4`, `simd_cesu8 1.1.1`, `simdutf8 0.1.5`, `rustc_version 0.4.1` |
| Dry-run package count | ~60 | 87 updated + 29 removed |

---

## 1. RUSTSEC Advisory Scan (`cargo audit`)

**Result: 0 vulnerabilities, 0 warnings, exit code 0**

```
Fetching advisory database from https://github.com/RustSec/advisory-db.git
  Loaded 1134 security advisories (from advisory database)
  Updating crates.io index
  Scanning Cargo.lock for vulnerabilities (346 crate dependencies)
```

Advisory database was fresh (fetched at scan time). Exit code 0. No RUSTSEC advisories affect any of the 346 locked crates.

**Yanked crate check (`cargo audit --deny yanked`):** Exit code 0. No yanked crates detected in Cargo.lock.

**Disposition:** No action required.

---

## 2. `cargo deny check`

**Result: advisories ok, bans ok, licenses ok, sources ok — exit code 0**

Zero errors. Same three non-blocking warnings as the prior run for license entries in `[licenses].allow` not encountered in the current dependency graph:

| Warning | License | Classification |
|---------|---------|---------------|
| `license-not-encountered` | `BSD-2-Clause` | Stale allowlist entry — no current dep uses this |
| `license-not-encountered` | `OpenSSL` | Stale allowlist entry — no current dep uses this |
| `license-not-encountered` | `Unicode-DFS-2016` | Stale allowlist entry — no current dep uses this |

No new warnings introduced since 2026-06-17.

**Disposition:** LOW. Defensive allowlist entries; safe to leave as-is. No action required.

---

## 3. Outdated Dependencies (`cargo update --dry-run`)

`cargo-outdated` is not installed. The dry-run provides equivalent information for what a `cargo update` would apply. Direct deps were assessed manually — none have a newer major available requiring action.

### 3a. Major-Version / Significant Transitive Bumps

These remain transitive and upstream-gated. All three were identified in the prior audit and are now further confirmed:

| Crate | Current | Available | Status vs 2026-06-17 |
|-------|---------|-----------|----------------------|
| `jni` | 0.21.1 | **0.22.4** | Confirmed available. Upgrade also introduces `jni-macros 0.22.4` and `simd_cesu8 1.1.1` / `simdutf8 0.1.5`, and removes `jni-sys 0.3.1`. Blocked by upstream `rustls-platform-verifier`. |
| `rustls-platform-verifier` | 0.6.2 | **0.7.0** | Confirmed available. A bump here cascades jni 0.22, resolves windows-sys 0.45 and thiserror 1.x from the graph. Blocked by reqwest not yet declaring 0.7.x. |
| `shlex` | 1.3.0 | **2.0.1** | Confirmed available. Build-dep only (cc → cmake → aws-lc-sys build script). Not in runtime binary. Security-hardened rewrite; bump is upstream-gated on cc/aws-lc-sys. |

**Additional notable structural change in dry-run (new vs 2026-06-17):**

| Change | Details |
|--------|---------|
| `hashbrown` consolidation | `0.15.5` + `0.16.1` removed; replaced by `0.17.1`. Net reduction in duplicate versions. |
| `wit-bindgen 0.51.0` removal | Confirmed: getrandom WASI backend topology change removes `wasip3 0.4.0` and `wit-bindgen 0.51.0`. The deny.toml skip for `wit-bindgen version = "0.51"` becomes stale after a `cargo update`. |
| WASM ecosystem update | `js-sys`, `web-sys`, `wasm-bindgen*` all bump 0.2.114→0.2.125 (11 minor versions). |
| `unicode-segmentation` | 1.12.0→1.13.3. Patch bump. |

**Severity: LOW.** All significant bumps remain transitive and upstream-gated. No direct dep has a newer major requiring action.

### 3b. Minor/Patch Transitive Bumps (~87 packages in dry-run)

A `cargo update` would apply these automatically. Key packages of note (security/cryptography layer and direct deps highlighted):

| Crate | Current | Available | Notes |
|-------|---------|-----------|-------|
| `aws-lc-rs` | 1.16.2 | 1.17.0 | Cryptography backend for rustls. Minor bump — compatible. |
| `aws-lc-sys` | 0.39.0 | 0.41.0 | C-bindings companion — two minor steps. |
| `hyper` | 1.8.1 | 1.10.1 | HTTP core — minor bump, two steps. Compatible. |
| `rustls` | 0.23.37 | 0.23.40 | TLS — patch. Compatible. |
| `rustls-native-certs` | 0.8.3 | 0.8.4 | Patch. |
| `h2` | 0.4.13 | 0.4.15 | HTTP/2 — patch. |
| `hyper-rustls` | 0.27.7 | 0.27.9 | TLS bridge — patch. |
| `pulldown-cmark` | 0.13.3 | 0.13.4 | Direct dep. Patch — compatible. |
| `insta` | 1.47.2 | 1.48.0 | Snapshot testing — minor. Compatible. |
| `winnow` | 1.0.0 | 1.0.3 | TOML parser dep — patch. |
| `zerocopy` | 0.8.47 | 0.8.52 | Minor bump. |
| `bitflags` | 2.11.0 | 2.13.0 | Minor — compatible. |
| `bytes` | 1.11.1 | 1.12.0 | Minor — compatible. |
| `zeroize` | 1.8.2 | 1.9.0 | Cryptography zeroing — minor. |
| `getrandom` | 0.4.2 | 0.4.3 | Patch. |
| `libc` | 0.2.183 | 0.2.186 | Patch. |
| `log` | 0.4.29 | 0.4.32 | Patch. |
| `regex` | 1.12.3 | 1.12.4 | Patch. |
| `tower-http` | 0.6.8 | 0.6.11 | Minor — compatible. |
| `webpki-root-certs` | 1.0.6 | 1.0.8 | TLS roots — patch. |
| `indexmap` | 2.13.0 | 2.14.0 | Minor — compatible. |

**Disposition:** LOW. A routine `cargo update` would apply all minor/patch bumps safely. Recommended as a periodic maintenance commit (not blocking).

### 3c. Direct Dependency Assessment (unchanged from prior audit)

All direct dependencies in `Cargo.toml` are at or near current latest within their specified major:

| Dep | Specified | Notes |
|-----|-----------|-------|
| `clap` | `"4"` | clap 4.x current, no major 5 yet |
| `reqwest` | `"0.13"` | current major |
| `tokio` | `"1"` | current major |
| `serde` | `"1"` | current major |
| `pulldown-cmark` | `"0.13"` | current minor series (0.13.4 patch available) |
| `keyring` | `"3"` | current major |
| `figment` | `"0.10"` | no 1.0 released |
| `thiserror` | `"2"` | current major |
| `rand` | `"0.10"` | current major |
| `dirs` | `"6"` | current major |

**No direct dep has a newer major available that requires action.**

---

## 4. deny.toml Skip Set — Stale Entry Analysis

The deny.toml currently contains **40 `[[bans.skip]]` entries** — unchanged from the prior audit. `cargo deny check` passes cleanly (0 errors, 0 warnings on bans). The current skip set correctly matches the locked topology.

### Entries that become stale after `cargo update` (confirmed from dry-run)

The dry-run confirms the June 17 prediction: `jni 0.22.4` and `rustls-platform-verifier 0.7.0` together remove the `thiserror 1.x` and `windows-sys 0.45` lineages from the graph. The `wit-bindgen 0.51` skip also becomes stale.

| Skip entry | Reason it becomes stale after `cargo update` |
|------------|----------------------------------------------|
| `thiserror version = "1"` | jni 0.22 removes thiserror 1.x dependency |
| `thiserror-impl version = "1"` | proc-macro companion; removed with thiserror 1.x |
| `thiserror version = "2"` | Becomes unnecessary (single version remaining) |
| `thiserror-impl version = "2"` | Same — unnecessary skip when only one version |
| `windows-sys version = "0.45"` | jni 0.22 removes this dependency |
| `windows-targets version = "0.42"` | transitive sub-dep of windows-sys 0.45; removed with it |
| `windows_aarch64_gnullvm version = "0.42"` | arch crate for windows-targets 0.42 |
| `windows_aarch64_msvc version = "0.42"` | arch crate for windows-targets 0.42 |
| `windows_i686_gnu version = "0.42"` | arch crate for windows-targets 0.42 |
| `windows_i686_msvc version = "0.42"` | arch crate for windows-targets 0.42 |
| `windows_x86_64_gnu version = "0.42"` | arch crate for windows-targets 0.42 |
| `windows_x86_64_gnullvm version = "0.42"` | arch crate for windows-targets 0.42 |
| `windows_x86_64_msvc version = "0.42"` | arch crate for windows-targets 0.42 |
| `wit-bindgen version = "0.51"` | wasip3 0.4.0 removed; getrandom WASI backend changed |

**Count: 14 entries become stale** (confirmed, up from "10–14 estimated" in prior audit).

Note on `windows-sys 0.45` skip in deny.toml: after jni bumps to 0.22, `windows-sys 0.45` is gone from the graph. The remaining windows-sys versions would be 0.52 (ring), 0.60 (keyring), 0.61 (broad graph). The `0.45` skip entry must be removed, and the canonical un-skipped version commentary in deny.toml should be updated accordingly.

**Current state:** `cargo deny check` passes cleanly today (0 errors, 0 warnings on bans). No action required now.

**Action on next `cargo update`:** After running `cargo update`, re-run `cargo deny check` and remove all 14 stale entries listed above. Verify the `windows-sys` skip commentary is updated to reflect the new 3-version topology (0.52/0.60/0.61).

---

## 5. Findings Table

| ID | Severity | Crate | Advisory/Issue | Recommended Action | Fix Type |
|----|----------|-------|----------------|--------------------|----------|
| AUD-001 | NONE | all (346) | No RUSTSEC advisories | No action required | — |
| AUD-002 | NONE | all (346) | No yanked crates | No action required | — |
| DENY-001 | LOW | deny.toml | 3 stale license allow-list entries (BSD-2-Clause, OpenSSL, Unicode-DFS-2016) | Leave as-is (defensive pre-approvals) | Manual (cosmetic) |
| DENY-002 | LOW | deny.toml | 14 skip entries become stale after `cargo update` | Remove stale entries post-update | Manual (~15 min) |
| UPD-001 | LOW | `jni` | 0.21.1→0.22.4 (upstream-gated by rustls-platform-verifier) | No action; track via reqwest update | Automated (upstream) |
| UPD-002 | LOW | `rustls-platform-verifier` | 0.6.2→0.7.0 (upstream-gated by reqwest) | No action; track via reqwest release | Automated (upstream) |
| UPD-003 | LOW | `shlex` | 1.3.0→2.0.1 (build-dep only, upstream-gated) | No action; runtime unaffected | Automated (upstream) |
| UPD-004 | LOW | ~84 crates | Minor/patch updates available | Run `cargo update` + CI | Automated |

---

## 6. Verdict

**GREEN. No RUSTSEC vulnerabilities, no yanked crates, no cargo-deny violations.**

**Security-reviewer triage required: NO.**

Zero CVEs and zero RUSTSEC advisories are present. All findings are LOW severity maintenance items (routine dependency updates and deny.toml housekeeping).

---

## 7. Recommended Actions

| Priority | Action | Effort | Trigger |
|----------|--------|--------|---------|
| LOW | Run `cargo update` to apply ~84 minor/patch bumps | 1 command + CI green | Periodic maintenance |
| LOW | After `cargo update`, prune 14 stale `[[bans.skip]]` entries from deny.toml | ~15 min manual | Post-update |
| LOW | Update deny.toml `windows-sys` commentary when 0.45 skip is removed | ~5 min | Post-update |
| DEFERRED | Track jni 0.21→0.22 upgrade via rustls-platform-verifier/reqwest bump | Upstream-gated | Watch reqwest releases |
| COSMETIC | Remove stale BSD-2-Clause, OpenSSL, Unicode-DFS-2016 from deny.toml license allow-list | Optional | Next maintenance pass |

---

## Appendix: Tool Versions

| Tool | Version |
|------|---------|
| cargo-audit | 0.22.1 |
| cargo-deny | 0.19.6 |
| cargo-outdated | NOT INSTALLED |
| Advisory DB entries | 1134 |
| Scan date | 2026-06-19 |
| Prior scan date | 2026-06-17 |
