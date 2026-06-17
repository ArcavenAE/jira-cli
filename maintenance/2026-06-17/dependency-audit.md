# Dependency Audit — 2026-06-17

**Repo:** `jira-cli` (`jr`), branch `develop`, commit `3ba8ea2`  
**Rust toolchain target:** `1.85`  
**Total Cargo.lock entries:** 346 crates  
**Tools used:** cargo-audit 0.22.1, cargo-deny 0.19.6, `cargo update --dry-run`  
**cargo-outdated:** NOT installed (not in PATH); root-dep analysis performed via dry-run + manual Cargo.toml review  

---

## Executive Summary

| Category | Count | Blocking? |
|----------|-------|-----------|
| RUSTSEC CVEs (cargo audit) | **0** | No |
| cargo-deny violations | **0** | No |
| cargo-deny warnings (stale allow-list entries) | 3 | No |
| Outdated: major-version transitive bumps available | 3 | No |
| Outdated: minor/patch transitive bumps available | ~60 | No |
| Outdated: direct deps with major update available | 0 | No |
| deny.toml skips potentially stale after lock update | 10–14 | No (requires lock update first) |
| PR #519 (codecov-action 6 → 7) | SAFE | No |

**Pipeline status: GREEN. No CRITICAL or HIGH advisories. No blocking issues.**

---

## 1. RUSTSEC Advisory Scan (`cargo audit`)

**Result: 0 vulnerabilities, 0 warnings**

```
Loaded 1134 security advisories (from advisory database)
Scanning Cargo.lock for vulnerabilities (346 crate dependencies)
Vulnerabilities: 0
Warnings: 0
```

Advisory database was fresh (fetched at scan time from `https://github.com/RustSec/advisory-db.git`). Exit code 0. No RUSTSEC advisories affect any of the 346 locked crates.

**Disposition:** No action required.

---

## 2. `cargo deny check`

**Result: advisories ok, bans ok, licenses ok, sources ok**

Zero errors. Three non-blocking warnings for license entries in the `[licenses].allow` list that are not encountered in the current dependency graph:

| Warning | License | Classification |
|---------|---------|---------------|
| `license-not-encountered` | `BSD-2-Clause` | Stale allowlist entry — no current dep uses this |
| `license-not-encountered` | `OpenSSL` | Stale allowlist entry — no current dep uses this |
| `license-not-encountered` | `Unicode-DFS-2016` | Stale allowlist entry — no current dep uses this |

**Disposition:** LOW. These are defensive allowlist entries (pre-approved for if/when a dep adopts them). Removing them would be safe but is cosmetic and carries zero risk leaving them. Recommend leaving as-is unless `cargo deny` is upgraded to treat warnings as errors.

---

## 3. Outdated Dependencies (`cargo update --dry-run`)

`cargo outdated` was not installed. The dry-run update provides equivalent information for transitive deps. Direct deps in `Cargo.toml` were audited manually — **none have a major version update available** that is newer than what is currently specified.

### 3a. Major-Version Transitive Bumps Available

These are transitive dependencies where a major version bump is available in the lock update. Because all direct deps in `Cargo.toml` use SemVer range specifiers (e.g. `"1"`, `"0.13"`) rather than exact pins, a `cargo update` would apply compatible minor/patch bumps but would NOT automatically cross a major boundary. These majors require an upstream dep to declare compatibility first.

| Crate | Current | Available | Root Cause / Blocker |
|-------|---------|-----------|----------------------|
| `jni` | 0.21.1 | **0.22.4** | Pulled by `rustls-platform-verifier` (via `reqwest`). The 0.21→0.22 bump is a minor pre-1.0 semver step but carries API changes. **Significant**: if `rustls-platform-verifier` adopts jni 0.22, it would remove `thiserror 1.x`, `windows-sys 0.45`, and 8 `windows_* 0.42` arch crates from the lock — collapsing 10–14 deny.toml skip entries (see §4). |
| `rustls-platform-verifier` | 0.6.2 | **0.7.0** | Pulled by `reqwest`. Minor-pre-1.0 semver. If reqwest bumps to 0.7.x it cascades jni upgrade opportunity. |
| `shlex` | 1.3.0 | **2.0.1** | Build-dep only: `cc` → `cmake` → `aws-lc-sys` (build script). Not in runtime binary. Shlex 2.x is a breaking rewrite for security hardening; the bump would happen automatically when `cc` or `aws-lc-sys` adopts it. |

**Severity: LOW.** All three are transitive and blocked upstream; none are direct deps; none have known CVEs.

### 3b. Minor/Patch Transitive Bumps Available (~60 packages)

A `cargo update` (without `--dry-run`) would apply these automatically. Highlights:

| Crate | Current | Available | Notes |
|-------|---------|-----------|-------|
| `aws-lc-rs` | 1.16.2 | 1.17.0 | Cryptography backend for rustls. Minor bump — compatible. |
| `aws-lc-sys` | 0.39.0 | 0.41.0 | C-bindings companion. Two minor steps. |
| `hyper` | 1.8.1 | 1.10.1 | HTTP core. Minor bump — compatible. |
| `rustls` | 0.23.37 | 0.23.40 | TLS. Patch — compatible. |
| `h2` | 0.4.13 | 0.4.15 | HTTP/2. Patch — compatible. |
| `pulldown-cmark` | 0.13.3 | 0.13.4 | Used directly by `jr` for ADF rendering. Patch — compatible. |
| `insta` | 1.47.2 | 1.48.0 | Snapshot testing. Minor — compatible. |
| `winnow` | 1.0.0 | 1.0.3 | TOML parser dep. Patch — compatible. |
| `zerocopy` | 0.8.47 | 0.8.52 | Minor bump — compatible. |

**Disposition:** LOW. A routine `cargo update` would apply all ~60 minor/patch bumps safely. Recommended as a periodic maintenance commit (not blocking).

### 3c. Direct Dependency Assessment

All direct dependencies in `Cargo.toml` are at or near current latest within their specified major:

| Dep | Specified | Notes |
|-----|-----------|-------|
| `clap` | `"4"` | clap 4.x current, no major 5 yet |
| `reqwest` | `"0.13"` | current major |
| `tokio` | `"1"` | current major |
| `serde` | `"1"` | current major |
| `pulldown-cmark` | `"0.13"` | current minor series |
| `keyring` | `"3"` | current major |
| `figment` | `"0.10"` | no 1.0 released |
| `thiserror` | `"2"` | current major |
| `rand` | `"0.10"` | current major |
| `dirs` | `"6"` | current major |

**No direct dep has a newer major available that requires action.**

---

## 4. deny.toml Skip Set — Stale Entry Analysis

The deny.toml currently contains **40 `[[bans.skip]]` entries** (WIN-DENY-FRAGILITY). The skip set is architecturally sound for the current Cargo.lock topology. However, a `cargo update` — especially if `rustls-platform-verifier` and `jni` bump to their available versions — would make **10–14 entries stale**:

### Entries that become stale if jni bumps 0.21→0.22

The dry-run shows that jni 0.22.4 drops its dependency on `thiserror 1.x`, `windows-sys 0.45`, and the corresponding `windows_* 0.42` arch crates. If `cargo update` were run and jni 0.22 becomes the locked version, the following skips become stale (would trigger `warning[unmatched-skip]` or `warning[unnecessary-skip]`):

| Skip entry | Reason it becomes stale |
|------------|------------------------|
| `thiserror version = "1"` | jni 0.22 drops thiserror 1.x dep |
| `thiserror-impl version = "1"` | proc-macro companion of thiserror 1.x |
| `windows-sys version = "0.45"` | jni 0.22 drops windows-sys 0.45 dep |
| `windows-targets version = "0.42"` | sub-dep of windows-sys 0.45 |
| `windows_aarch64_gnullvm version = "0.42"` | arch crate for windows-targets 0.42 |
| `windows_aarch64_msvc version = "0.42"` | arch crate for windows-targets 0.42 |
| `windows_i686_gnu version = "0.42"` | arch crate for windows-targets 0.42 |
| `windows_i686_msvc version = "0.42"` | arch crate for windows-targets 0.42 |
| `windows_x86_64_gnu version = "0.42"` | arch crate for windows-targets 0.42 |
| `windows_x86_64_gnullvm version = "0.42"` | arch crate for windows-targets 0.42 |
| `windows_x86_64_msvc version = "0.42"` | arch crate for windows-targets 0.42 |

Additionally, if `thiserror 1.x` is fully removed from the graph, `thiserror version = "2"` and `thiserror-impl version = "2"` become unnecessary skips (cargo-deny flags them with `unnecessary-skip` because only one version remains).

### Entries that become stale if getrandom/wit-bindgen topology changes

The dry-run shows `wit-bindgen 0.51.0` and `wasip3 0.4.0` being removed (getrandom 0.4 WASI backend changed). This would make the `wit-bindgen version = "0.51"` skip stale.

**Current state:** `cargo deny check` passes cleanly today (0 errors, 0 warnings on bans). The skips are correct for the current lock. No action required now.

**Action on next `cargo update`:** After running `cargo update`, re-run `cargo deny check` and remove any entries that produce `unmatched-skip` or `unnecessary-skip` warnings. Expected: ~11–14 entries removable if jni bumps to 0.22.

---

## 5. PR #519 — codecov/codecov-action 6.0.1 → 7.0.0

**Recommendation: SAFE TO MERGE.**

### Analysis

The v7.0.0 release notes state:
> Due to migration issues with keybase, we are unable to update our keys under the `codecovsecurity` account. We have deleted the account and are using `codecovsecops` with the original GPG key.

The actual code change between 6.0.1 and 7.0.0 is **two commits**: removal of a license compliance CI workflow and the version bump. The v6.0.2 release is explicitly described as "a copy of the v7.0.0 release to make updates easier" — meaning there is no functional difference between 6.0.1 and 7.0.0 from a behavior standpoint.

### Breaking-change exposure

The workflow using codecov-action (`ci.yml`) passes only:
```yaml
- uses: codecov/codecov-action@e79a6962e0d4c0c17b229090214935d2e33f8354  # v6
  with:
    files: lcov.info
    token: ${{ secrets.CODECOV_TOKEN }}
    fail_ci_if_error: false
```

The inputs `files`, `token`, and `fail_ci_if_error` are stable across v6→v7. No new required inputs. No removal of used inputs. The GPG key change is internal to Codecov's signing infrastructure and transparent to consumers of the action.

### SHA-pin note

The workflow correctly pins to a commit SHA (`e79a6962e0d4c0c17b229090214935d2e33f8354`) for security. The PR from dependabot will update this to the v7.0.0 SHA (`fb8b3582c8e4def4969c97caa2f19720cb33a72f`). This is the expected and correct change.

**CI impact:** `fail_ci_if_error: false` means even if the upload step fails (e.g. Codecov service issue), CI passes. No blocking risk.

**Security note:** The keybase key migration in v7.0.0 is a supply-chain hardening step, not a regression. Merging to the new signed SHA is preferable to staying on the old one.

---

## 6. Recommended Actions

| Priority | Action | Effort |
|----------|--------|--------|
| LOW | Merge PR #519 (codecov-action 6→7) | 1 click — safe |
| LOW | Run `cargo update` to apply ~60 minor/patch bumps | 1 command + CI green |
| LOW | After `cargo update`, prune ~11–14 stale `[[bans.skip]]` entries from deny.toml | ~15 min manual |
| DEFERRED | Track jni 0.21→0.22 upgrade via rustls-platform-verifier bump | Upstream-gated |
| COSMETIC | Remove stale `BSD-2-Clause`, `OpenSSL`, `Unicode-DFS-2016` from deny.toml license allow-list | Optional |

---

## Appendix: Tool Versions

| Tool | Version |
|------|---------|
| cargo-audit | 0.22.1 |
| cargo-deny | 0.19.6 |
| cargo-outdated | NOT INSTALLED |
| Advisory DB entries | 1134 |
| Scan date | 2026-06-17 |
