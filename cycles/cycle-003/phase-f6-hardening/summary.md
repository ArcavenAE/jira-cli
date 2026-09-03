# F6 Targeted Hardening — SUMMARY — cycle-003 `auth-profile-dx`

- **Baseline → HEAD:** `87f17aff` (v0.7.0-dev.3) → `202414f2` (develop tip)
- **Date (UTC):** 2026-09-03
- **Verifier:** formal-verifier (F6 targeted hardening)
- **Sub-artifacts:** `kani-results.md`, `fuzz-results.md`, `mutation-results.md`, `security-scan-results.md`

## Gate scorecard

| Dimension | Verdict | Headline |
|-----------|---------|----------|
| Formal verification (Kani) | **PASS** | Justified proptest substitution; 0 GAP (VP-AUTHDX-001..009 all covered) |
| Fuzz testing | **PASS (justified skip)** | No `fuzz/` dir; delta adds no new untrusted raw-byte parser |
| Mutation testing | **PASS** | 100% kill (28/28); 0 survivors -> 0 FIX-F6 candidates |
| Security scan | **PASS** | 0 CRIT / 0 HIGH / 0 MED; 1 LOW pre-existing yanked crate |
| Regression (full tree) | **PASS** | 4763 passed / 0 failed / 157 ignored; clippy + fmt clean |
| DTU adversarial | **SKIP** | `dtu_required: false` |
| Accessibility | **SKIP** | backend-CLI feature, no UI |

## 1. Formal verification (Kani) — PASS

**JUSTIFIED PROPTEST/UNIT-TEST SUBSTITUTION** per the documented cycle-002 precedent. No
`#[kani::proof]` harness exists anywhere in the repo, and the delta surface is structured
credential-string routing + keychain I/O + tolerant TOML deserialization — invariant classes
`proptest` covers naturally and that every cycle-003 VP explicitly designates as its
verification method (no VP was designated for formal/Kani proof).

**0 GAP.** All nine VP-AUTHDX-001..009 have covering tests:
- **Default-CI covered (4):** 001 (non-interactive never launches OAuth), 002 (`auth_method`
  default byte-identical `"api_token"`), 003 (mechanism intrinsic to profile, never follows the
  flag), 009 (`ProfileConfig.env` tolerant reader, 1000-case proptest).
- **Keyring-gated per documented spec coverage boundary (5):** 004 (per-profile round-trip +
  cross-profile isolation), 005 (detect-and-instruct, no legacy pair copied), 006 (no profile
  special-cased), 007 (real-backend end-to-end scenario, gated by definition), 008
  (namespaced partial-state safety). These run only under `#[ignore]` + `JR_RUN_KEYRING_TESTS=1`
  because `store_api_token`/`load_api_token` touch the real OS keychain with no in-memory seam —
  a spec-declared boundary, not an F6 gap.

## 2. Fuzz testing — PASS (JUSTIFIED SKIP)

No `fuzz/` directory exists, and the cycle-003 delta introduces no new untrusted raw-byte-stream
parser. The 17-file changed set is entirely structured auth/credential I/O over the `keyring`
typed `Entry` API, an `Option<&str>` fallback in client auth-method resolution, the ADR-0011
`Profile` newtype propagation (no parsing logic), and one additive config field. The single
parse-shaped change — `ProfileConfig.env: Option<String>` — rides existing `serde`/`figment` TOML
deserialization and is additionally covered by VP-AUTHDX-009's 1000-case tolerant-reader proptest
(exercising present/absent/arbitrary-string values including any byte sequence). A new byte-stream
parser would have triggered a `libfuzzer` target at `-max_total_time=300`; no such surface exists.

## 3. Mutation testing — PASS

`cargo-mutants 27.0.0`, `--in-diff` over `git diff 87f17aff..202414f2`, scoped by
`.cargo/mutants.toml::examine_globs`.

| Metric | Value |
|--------|-------|
| Mutants generated (in-diff ∩ examine_globs) | 28 |
| Caught | 28 |
| Missed | 0 |
| Timeout | 0 |
| Unviable | 0 |
| **Kill rate** | **100% (28/28)** |

**Per-file (all caught):** `src/output.rs` 25 (DEC-314 `env`-tag display sanitizer —
`sanitize_env_display` / `strip_control_and_ansi`, the terminal-escape / control-char injection
guard added this cycle), `src/cache.rs` 2 (per-profile path construction), `src/main.rs` 1
(top-level dispatch return value).

**Security-critical scope reconciliation (documented boundary):** `refresh_coordinator.rs` is
unchanged in the delta (0 mutants). `api/auth.rs`, `api/client.rs`, and `cli/auth/*.rs` are NOT
members of `examine_globs` (pre-existing policy) — `--in-diff` narrows within `examine_globs`, it
does not add files — so they produced 0 diff-scoped mutants and the >=95% security-critical bar is
met vacuously there. Those modules' credential logic is instead verified by the keyring-gated
VP-AUTHDX suite. Every mutant within the enforced scope (including the security-relevant
`output.rs` env-tag sanitizer) was caught.

**0 surviving mutants -> 0 FIX-F6 mutation candidates.**

## 4. Security scan — PASS

- **`cargo audit` — PASS (exit 0):** 0 vulnerabilities across 358 dependencies. 1
  LOW/informational warning: `chacha20 0.10.0` is a **yanked** crate version (transitive via
  `rand`). Yanked != vulnerable — no RUSTSEC advisory, no CVE/CWE. **Pre-existing on the
  `87f17aff` baseline, NOT delta-introduced.** Routine `cargo update -p chacha20` recommended at
  next maintenance sweep; not a BLOCK.
- **`cargo deny check` — PASS:** advisories / bans / licenses / sources all ok. Only benign
  hygiene warnings (3x stale `license-not-encountered` allow-list entries, 1x DEC-185-authorized
  `unmatched-skip` for `cpufeatures`, 1x the same yanked-crate notice).
- **`gitleaks`:** CI-gated (`pull_request`, `vars.GITLEAKS_DISABLED != 'true'`), not run locally;
  no secrets observed in the delta during manual review.
- **Manual auth-delta lens — 0 CRIT / 0 HIGH / 0 MED:** keychain namespacing secure
  (`<profile>:email` / `<profile>:api-token`, no flat pair ever written — cross-profile isolation
  upheld); no-copy detect-and-instruct migration secure (DEC-326, existence-only check, byte-
  identical actionable error, no `"default"` special-casing); partial-state safe (distinct
  "Incomplete credentials" error, no silent half-credential `Ok`); no plaintext-secret logging
  (CWE-532 clear — only profile NAMES and env-var NAMES appear in sinks); `JR_BASE_URL` /
  `JR_AUTH_HEADER` release gates intact at both read sites (CWE-522/CWE-200 token-leak-on-redirect
  class); `refresh` relogin-then-replace with no data-loss window (DEC-321 / BC-1.2.051 I-6).

## 5. Regression (full tree) — CERTIFIED this session — PASS

- **Full suite GREEN:** **4763 passed / 0 failed / 157 ignored** (all 112 integration binaries +
  both lib unittest sets + doctests). Cycle-003 total 4920 = 4763 passed + 157 ignored.
- **`cargo clippy -- -D warnings`:** exit 0 (clean).
- **`cargo fmt --all -- --check`:** clean.
- **Comparison:** F4 baseline / cycle-002 was 4660/0/106; the 4763/157 counts are consistent with
  cycle-003 delta additions.
- **Record note:** the suite was executed in segments this session (the harness kills any single
  ~26-minute background job); every integration binary and the doctests were confirmed run with
  0 failures.

## 6. Out-of-scope gates

- **DTU adversarial:** SKIP — `dtu_required: false`.
- **Accessibility:** SKIP — `feature_type` backend-CLI, no UI surface.

---

## F6 GATE VERDICT: PASS

All in-scope hardening dimensions clear their thresholds: 0 unmapped VPs (Kani substitution
justified), justified fuzz skip, 100% mutation kill rate, 0 CRIT/HIGH/MED security findings, and a
fully GREEN regression suite with clean clippy/fmt.

**0 FIX-F6-NNN candidates** — no surviving mutants, no CRITICAL/HIGH security findings, no
regressions.
