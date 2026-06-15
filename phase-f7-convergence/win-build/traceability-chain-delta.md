---
document_type: f7-traceability-chain-delta
feature: windows-build (x86_64-pc-windows-msvc)
cycle: cycle-001
activation_head: "587206e"
develop_head: "fac555f"
delta_range: "587206e..fac555f"
date: 2026-06-14
producer: state-manager
---

# Traceability Chain — Windows Build Delta

This document records the end-to-end traceability for the Windows-build feature delta,
linking behavioral contracts and NFRs through stories, implementation artifacts, merged
PRs, adversarial passes, and formal verification results.

---

## BC → Story → PR → Implementation → Verification

### BC-6.1.014 — Config path fallback purity (Windows AppData)

| Link | Artifact |
|------|----------|
| **Behavioral Contract** | BC-6.1.014 in `.factory/specs/prd/bc-6-config.md` |
| **Spec anchor** | `config_dir_fallback()` MUST be a pure function: given `Option<OsString>` env input, returns a deterministic `PathBuf` with no I/O or global-state side effects. On Windows, falls back to `%APPDATA%\jr` when `JR_CONFIG_DIR` is unset. |
| **Story** | S-WIN-1 (AppData path fallback) |
| **Merged PR** | #506 → develop |
| **Implementation** | `src/config.rs` — `config_dir_fallback(env_val: Option<OsString>) -> PathBuf`; `dirs::config_dir()` chain on Windows. |
| **Adversary passes** | F5 R1–R14 (14 passes; convergence at R12/R13/R14 CLEAN). |
| **F6 proptest** | `tests/win_path_fallback_props.rs` — EC-1 (returns AppData fallback when var absent), EC-3 (override accepted); 2048 cases each. |
| **Mutation** | 5/5 config.rs mutants killed (100%; all 4 `is_empty()` guard mutants killed). |
| **Dependency** | Depends on BC-1.4.027 (per-profile keychain keys; per-profile XDG cache boundary). |

---

### BC-6.2.004 — Cache directory resolution (XDG seam)

| Link | Artifact |
|------|----------|
| **Behavioral Contract** | BC-6.2.004 in `.factory/specs/prd/bc-6-config.md` |
| **Spec anchor** | Cache path resolution MUST respect `JR_CACHE_DIR` env override (debug builds only), falling back to OS-native cache directory. All call sites MUST use the `JR_CACHE_DIR` seam, never `dirs::cache_dir()` directly. |
| **Story** | S-WIN-5 (XDG→JR seam migration; 37-file migration across all call sites) |
| **Merged PR** | #510 → develop @ 4bd83c7 |
| **Implementation** | `src/cache.rs` — `cache_dir_fallback(env_val: Option<OsString>) -> PathBuf`; all 37 call sites migrated from `dirs::cache_dir()` direct calls to the `JR_CACHE_DIR`-aware seam. |
| **Adversary passes** | F5 R4–R5 (R4 found incomplete migration; R5 CLEAN post-fix). |
| **Guard test** | `tests/ci_yml_windows_matrix.rs` — AC-004 per-call-site count guard (presence-only; subprocess sites checked separately). |
| **F6 proptest** | `tests/win_path_fallback_props.rs` — EC-1, EC-4 (cache dir properties); 2048 cases each. |
| **Mutation** | 4/4 cache.rs mutants killed (100%). |

---

### BC-6.2.016 — Cache path fallback purity (Windows AppData/Local)

| Link | Artifact |
|------|----------|
| **Behavioral Contract** | BC-6.2.016 in `.factory/specs/prd/bc-6-config.md` |
| **Spec anchor** | `cache_dir_fallback()` MUST be a pure function; on Windows, falls back to `%LOCALAPPDATA%\jr` when `JR_CACHE_DIR` is unset. |
| **Story** | S-WIN-1 (AppData path fallback) |
| **Merged PR** | #506 → develop |
| **Implementation** | `src/cache.rs` — `cache_dir_fallback(env_val: Option<OsString>) -> PathBuf`; `dirs::cache_dir()` chain on Windows. |
| **F6 proptest** | `tests/win_path_fallback_props.rs` — EC-1 (returns LocalAppData fallback), EC-4 (override accepted); 2048 cases each. |
| **Mutation** | Covered by cache.rs 4/4 kill. |

---

### BC-6.2.017 — Path-injection guard (empty-string filter)

| Link | Artifact |
|------|----------|
| **Behavioral Contract** | BC-6.2.017 in `.factory/specs/prd/bc-6-config.md` |
| **Spec anchor** | When `JR_CONFIG_DIR` or `JR_CACHE_DIR` is set to an empty string, the override MUST be treated as absent (fallback to default). Empty-string env var MUST NOT inject a bare `/` or empty path. |
| **Story** | S-WIN-1 (security guard); S-WIN-5 (seam migration preserves guard at all sites) |
| **Merged PRs** | #506 (guard impl), #510 (seam migration), #514 (guard test hardening R5-001) |
| **Implementation** | `src/config.rs` / `src/cache.rs` — `is_empty()` check before using env value; non-empty-only branch uses `OsString` override. |
| **Guard test** | `tests/config_path_guard.rs::test_global_config_struct_has_no_path_override_field` (R5-001; added FIX-F5-004 PR #514). |
| **Mutation** | All 4 `delete !` mutants (negating `is_empty()`) KILLED — security-critical coverage confirmed. |
| **Adversary verification** | R5 (security perimeter) CLEAN post-guard-test. R14 (security lens, "confirm HEAD SHA" protocol) CLEAN. |

---

## Story → PR Map

| Story | Title | Merged PR | develop SHA |
|-------|-------|-----------|-------------|
| S-WIN-2 | Cross-compile setup + initial deny.toml | #504 | — |
| S-WIN-3 | deny.toml 17-entry windows-sys 0.60 skip set | #505 | — |
| S-WIN-1 | AppData path fallback (config.rs / cache.rs) | #506 | — |
| S-WIN-4 | release.yml Compress-Archive + zip artifact | #507/#508 | — |
| S-WIN-6 | Documentation fallout (WIN-O-3/WIN-O-4/SEC-WCM-DOC) | #509 | bc69c625 |
| S-WIN-5 | XDG→JR seam migration + ci.yml windows matrix + /STACK:8388608 | #510 | 4bd83c7 |

## Fix PR → F5/F6 Adversary Finding Map

| Fix PR | Finding Source | Dimension | Status |
|--------|---------------|-----------|--------|
| #511 (FIX-F5-001) | R1: CHANGELOG.md Windows section missing | Spec/Docs | MERGED |
| #512 (FIX-F5-002) | R1: ci.yml MSRV job missing Windows | Test/CI | MERGED |
| #513 (FIX-F5-003) | R1/R2: ADR-0016 prose gaps | Spec | MERGED |
| #514 (FIX-F5-004) | R6: Security perimeter — figment guard test R5-001 | Test/Security | MERGED |
| #515 (FIX-F5-005) | R8: OAuth guard alignment | Test | MERGED |
| #516 (FIX-F6-001) | F6: proptest property suite (9 props) | Test | MERGED → fac555f |

---

## NFR Traceability

| NFR | Description | Evidence |
|-----|-------------|----------|
| NFR-P-W1 | Windows path correctness: jr MUST resolve config/cache paths to OS-native Windows directories | BC-6.1.014 + BC-6.2.016 proptest PASS; CI Test (windows-latest) GREEN |

---

## ADR Traceability

| ADR | Decision | Relevance |
|-----|----------|-----------|
| ADR-0016 | Windows Build Support | Documents all 6 architectural decisions: cross-compile, XDG→JR seam, stack-size override, deny.toml topology, OAuth scope, runtime env. Authored + merged during F5. FINDING-001 (factory copy sync) fixed at ba1fc1a. |

---

## Adversary Pass Summary (F5)

| Pass | Lens | Findings | Status |
|------|------|----------|--------|
| R1 | Full coverage (security/spec/test/impl) | CRIT/HIGH (stack crash, CHANGELOG, MSRV) | FIXED via #511–#513 |
| R2 | Re-check R1 fixes + deep security | 0 CRIT; ADR-0016 amendment | MERGED ADR fix |
| R3 | Spec completeness | 0 CRIT; prose gaps | Fixed inline |
| R4 | XDG seam completeness | CRIT (incomplete migration at 3 sites) | FIXED in #510 |
| R5 | Security perimeter | HIGH (guard test absent) | FIXED via #514 |
| R6 | Regression/figment re-entry | 0 CRIT/HIGH; guard test confirmed | CLEAN |
| R7 | Test completeness | 0 CRIT/HIGH; proptest gap noted | Noted for F6 |
| R8 | OAuth alignment | LOW; guard string alignment | FIXED via #515 |
| R9 | Regression/CHANGELOG | 0 CRIT/HIGH | CLEAN |
| R10 | Completeness re-scan | 0 CRIT/HIGH | CLEAN |
| R11 | VOID — checkout-race (concurrent git pull) | N/A | Re-run as R14 |
| R12 | Regression/spec | 0/0/0 | CONVERGED CLEAN |
| R13 | Completeness | 0/0/0 | CONVERGED CLEAN |
| R14 | Security/guard ("confirm HEAD SHA" protocol) | 0/0/0 | CONVERGED CLEAN |

**F5 convergence:** 14 passes (R1–R14, R11 VOID). 3 consecutive clean: R12/R13/R14. CONVERGED.

---

## Formal Verification Summary (F6)

| Method | Result | Justification |
|--------|--------|---------------|
| Proptest (9 props, 2048 cases each) | PASS | BC-6.1.014 EC-1/EC-3 + BC-6.2.016 EC-1/EC-4 |
| Kani (CBMC) | JUSTIFIED SKIP | OOM on PathBuf equality symbolic expansion |
| Fuzz testing | JUSTIFIED SKIP | No new untrusted-input parsers in delta |
| cargo audit | 0 vulns | fac555f clean |
| cargo deny | PASS | deny.toml updated; 17-entry skip set |
| Mutation (delta) | 9/9 CAUGHT (100%) | config.rs 5/5 + cache.rs 4/4 |
| Security review | APPROVED (0 CRIT/HIGH/MED/LOW) | F6 scoped review |
| CI regression | 1808/0 PASS | cargo test --all-features on fac555f |

---

## Dependency Note

The Windows-native keyring path (AppData-based keychain service name) implicitly depends on
**BC-1.4.027** (per-profile keychain keys) — the per-profile `<profile>:oauth-*` namespacing
applies equally on Windows because the Windows Credential Manager is keyed by service name,
not path. This cross-dependency is documented in ADR-0016 Decision 2 and is satisfied by the
existing BC-1.4.027 implementation (not modified by the Windows delta).

**NFR-P-W1** cross-references BC-6.1.014 and BC-6.2.016 as the primary measurable acceptance
criteria for the Windows path-correctness requirement.
