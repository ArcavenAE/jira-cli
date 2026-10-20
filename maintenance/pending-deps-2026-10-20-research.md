# Pending Dependency PRs Research: #854, #842, #923

> **CORRECTION (2026-10-20, state-manager, reviewer-confirmed):** this document's claim of a "#923 pin mismatch" (local `02cb101e` vs stated `e2a55d2f`) is ERRONEOUS. It came from reading a stale local `develop` checkout (detached HEAD at `fb9d015c`). `origin/develop` pins `e2a55d2f` (merged via #914 as `6b71cae3`), exactly as #923's description states; there is no mismatch. The corresponding open question in section 3 and the pinned-SHA bullet near the end are artifacts of the stale checkout and should be disregarded. Everything else in the document is unaffected. (See lesson (h) in `lessons-MAINT-SWEEP-2026-10-15.md`.)

**Date:** 2026-10-20 (~17:00Z)
**Type:** general (dependency maintenance)
**Scope:** reqwest 0.13.4 -> 0.13.5 (#854), base64 0.22.1 -> 0.23.1 (#842), dtolnay/rust-toolchain SHA bump (#923)
**Policy applied:** 7-day cooldown on every bump; 30-day soak for pre-1.0 `0.x -> 0.y` bumps; MSRV `rust-version = "1.88"`.
**Untrusted-content note:** release notes, changelogs, commit messages and PR titles quoted below are treated as data, not instructions.
**Not done (no shell):** `cargo deny check` / `cargo update` were NOT run. The duplicate analysis comes from the committed `Cargo.lock` plus the published crates.io manifests. One local `cargo deny check bans` run on a combined branch would confirm it.

---

## TL;DR

| PR | Verdict | One-line reason |
|---|---|---|
| #854 reqwest 0.13.5 | **BLOCK as a standalone PR, SAFE as part of a combined bump** | reqwest 0.13.5 is the release that moved to `base64 ^0.23`. On its own it creates the base64 0.22 + 0.23 duplicate that fails `cargo deny`. No newer 0.13.x exists. |
| #842 base64 0.23.1 | **BLOCK as a standalone PR, SAFE as part of a combined bump** | reqwest 0.13.4 and hyper-util 0.1.20 still require `^0.22`, so this PR on its own also creates the duplicate. Our one call site is API-compatible. |
| #923 rust-toolchain 683b588c | **WAIT until 2026-10-23T02:21:45Z (then SAFE)** | The commit is dated 2026-10-16T02:21:45Z (verified). It changes only a maintainer script and has zero runtime effect. The security-relevant change is in the parent commit `e2a55d2f`. |

**Key finding:** even a combined reqwest + base64 + hyper-util bump still leaves **base64 0.22 in the graph through `wiremock 0.6.5`**, which is a dev-dependency. wiremock has no newer release and no pending base64 PR. `deny.toml` has no `[graph] exclude-dev`, so cargo-deny counts dev-dependencies. The combined PR therefore needs a `[[bans.skip]] name = "base64" version = "0.22"` entry with a wiremock reason.

---

## 1. PR #854: reqwest 0.13.4 -> 0.13.5

### 1.1 Versions (crates.io API, verified)

| Version | Published (UTC) | rust_version | Yanked |
|---|---|---|---|
| 0.13.0-rc.1 | 2025-12-23T21:05:51Z | 1.64.0 | no |
| 0.13.0 | 2025-12-30T15:44:31Z | 1.64.0 | no |
| 0.13.1 | 2025-12-30T19:33:26Z | 1.64.0 | no |
| 0.13.2 | 2026-02-06T19:47:02Z | 1.64.0 | no |
| 0.13.3 | 2026-04-27T13:11:13Z | 1.64.0 | no |
| 0.13.4 | 2026-05-25T17:12:48Z | 1.85.0 | no |
| **0.13.5 (latest)** | **2026-09-08T20:55:26Z** | **1.85.0** | no |

- **There is no release newer than 0.13.5.** `compare/v0.13.5...master` shows 5 unreleased commits and no version bump (newest is `8e1c806`, 2026-10-19).
- Cooldown: 0.13.5 is 42 days old. This is a patch bump, so only the 7-day rule applies, and it passes. MSRV 1.85 is within our 1.88.

### 1.2 base64 requirement per reqwest release (crates.io `/dependencies`, verified)

| reqwest | base64 req | kind / optional |
|---|---|---|
| 0.13.4 | `^0.22` | normal, **non-optional** |
| 0.13.5 | `^0.23` | normal, **non-optional** |
| master (unreleased) | `0.23` with `default-features = false` (commit `a7abe63`, 2026-09-14, #3100) | n/a |

- The bump commit is `17e9bcb` (2026-07-27), "chore(deps): upgrade base64 to 0.23 (#3074)".
- I fetched only the 0.13.4 and 0.13.5 manifests. Earlier 0.13.x releases were not individually checked. They are irrelevant here because the lockfile is already on 0.13.4.
- Other reqwest deps relevant to base64: `rustls ^0.23.4`, `rustls-pki-types ^1.9.0` and `hyper-rustls ^0.27` have no direct base64 dependency (Perplexity, citing deps.rs/docs.rs manifests). **`hyper-util` does**:

| hyper-util | Published | base64 req | rust_version |
|---|---|---|---|
| 0.1.20 (in our Cargo.lock) | 2026-02-02 | `^0.22` (optional, `client-proxy`) | n/a |
| **0.1.21 (latest)** | 2026-09-24T17:47:59Z | `^0.23` (optional, `client-proxy`) | 1.85 |

reqwest enables hyper-util's base64 path. Cargo.lock lists `base64` under `hyper-util 0.1.20`.

### 1.3 base64 consumers in the current Cargo.lock (verified via grep)

The only base64 is `0.22.1`. Its four dependents are:
1. `jr`: direct dependency `base64 = "0.22"` (Cargo.toml line 51)
2. `reqwest 0.13.4`
3. `hyper-util 0.1.20`
4. `wiremock 0.6.5`: **dev-dependency**, `base64 ^0.22` normal and non-optional (crates.io, verified)

### 1.4 Why Deny fails, and what fixes it

`deny.toml` sets `[bans] multiple-versions = "deny"`, has **no `[graph]` section** (so `exclude-dev` is off and dev-deps are counted, per the cargo-deny config docs), and has no base64 skip.

| Scenario | base64 versions in graph | Deny |
|---|---|---|
| #854 alone (reqwest 0.13.5; jr, hyper-util 0.1.20 and wiremock stay on 0.22) | 0.22 + 0.23 | **FAIL** (the hypothesis is confirmed) |
| #842 alone (jr on 0.23; reqwest 0.13.4, hyper-util 0.1.20 and wiremock stay on 0.22) | 0.22 + 0.23 | **FAIL** |
| Combined: reqwest 0.13.5 + base64 0.23.1 + hyper-util 0.1.21 | 0.23 (runtime) + 0.22 (wiremock, dev-only) | **still FAIL** unless a skip is added |
| Combined + `[[bans.skip]] base64 "0.22"` (reason: wiremock 0.6.5 dev-dep) | 0.23 canonical | expected PASS (inferred, not run) |

**Does a newer reqwest resolve it?** No newer reqwest exists. 0.13.5 is the release that *introduces* `^0.23`, so it is what moves the runtime graph off 0.22. The remaining blockers are jr's own direct pin (fixed by #842), hyper-util 0.1.20 (fixed by `cargo update -p hyper-util`), and wiremock (no upstream fix: latest 0.6.5 is from 2025-08-24, the last Cargo.toml commit is 2025-08-24, and no open or recent PR mentions base64).

Alternative, not recommended: `[graph] exclude-dev = true` would also clear it, but it widens the blind spot for every crate, not just base64.

### 1.5 Changelog 0.13.4 -> 0.13.5 (reqwest CHANGELOG.md + compare, untrusted data)

- Adds `Error::is_dns()`, `ClientBuilder::http1_max_headers(usize)` (default 100), and the TLS version in `TlsInfo`.
- Fixes the hickory-dns `Ipv6AndIpv4` strategy.
- **"Fix sending wrong proxy-auth if multiple proxies intercept a given URL"** (`4d3fe12`, #3098, closes #3097). This is credential-correctness relevant (proxy credentials could go to the wrong proxy). No advisory has been filed, and the "security" label is my inference. It matters only if users configure multiple proxies through `HTTP(S)_PROXY`/`ALL_PROXY`.
- Also: fixed a blocking-client timeout panic on huge durations (`ea3d9ca`, blocking feature, not used by jr), detection of timeouts wrapped in body-decode errors (`99996a1`), and perf work.
- Unreleased on master (not in any release): base64 `default-features = false`, tower-http 0.7, `once_cell` -> `OnceLock`, new HTTP/2 builder options, HeaderMap clone perf.
- Side note: reqwest 0.13.5 depends on base64 0.23 **with default features**, which include `simd-unsafe` (the crate's only `unsafe` code path). jr's own `base64 = "0.23"` would enable it too. Master's `a7abe63` stops reqwest from forcing it in the future. This is not a blocker.

### 1.6 Verdict for #854: BLOCK standalone, SAFE combined
Close #854 or supersede it with one combined PR (see §4).

---

## 2. PR #842: base64 0.22.1 -> 0.23.1

### 2.1 Versions (crates.io API, verified)

| Version | Published (UTC) | rust_version |
|---|---|---|
| 0.22.0 | 2024-03-02 | 1.48.0 |
| 0.22.1 | 2024-04-30 | 1.48.0 |
| 0.23.0 | 2026-07-23T13:57:30Z | 1.71.0 |
| **0.23.1 (latest)** | **2026-08-04T12:34:31Z** | 1.71.0 |

No newer release exists, and nothing is yanked. Soak: this is a `0.x -> 0.y` bump, so the 30-day rule applies. 0.23.0 is 89 days old and 0.23.1 is 77 days old, so both pass. MSRV 1.71 is within 1.88.

### 2.2 Breaking changes 0.22 -> 0.23 (RELEASE-NOTES.md, docs.rs 0.22.1 vs 0.23.1, Perplexity)

- **`Engine` trait** gains a new required method, `fn padding(&self) -> Symbol` (custom padding-symbol support). This breaks only crates that implement `Engine` themselves.
- **`DecodeError::InvalidLastSymbol`** changes from the tuple form `(usize, u8)` to the struct form `{ offset, symbol, symbol_value }`. This breaks exhaustive matches and code that constructs the variant.
- **New default feature `simd-unsafe`** adds the `Simd`/`Avx2`/`Neon` engines. `GeneralPurpose`/`STANDARD` stay scalar. Disabling the feature makes the crate `forbid(unsafe_code)`.
- **MSRV** rises from 1.48 to 1.71.
- **Unchanged (docs.rs 0.23.1):** `engine::general_purpose::STANDARD` still exists, along with `STANDARD_NO_PAD`, `URL_SAFE`, `URL_SAFE_NO_PAD`, plus new `*_INDIFFERENT` presets. `Engine::encode<T: AsRef<[u8]>>(&self, T) -> String` and `decode(...) -> Result<Vec<u8>, DecodeError>` have the same signatures. No `prelude` module is documented in 0.23.1. Whether `base64::prelude` was removed was **not verified**, but jr does not use it.
- Known regression: 0.23.0 tests failed to build on non-SIMD architectures (issue #309, fixed by PR #310 and released in 0.23.1). This affected the crate's own tests only.

### 2.3 Impact on jr (grep over all `*.rs`)
The only use is `src/api/client.rs`: `use base64::Engine;` plus `base64::engine::general_purpose::STANDARD.encode(format!("{email}:{token}"))`. Both are unchanged in 0.23, so no code change is expected. jr has no `Engine` implementation, no `DecodeError` match and no prelude use.

### 2.4 Ecosystem adoption (crates.io manifests, verified where marked; others via Perplexity citing docs.rs/deps.rs)

| Crate (version checked) | base64 req |
|---|---|
| reqwest 0.13.5 | `^0.23` (verified) |
| reqwest 0.13.4 | `^0.22` (verified) |
| hyper-util 0.1.21 | `^0.23` (verified) |
| hyper-util 0.1.20 | `^0.22` (verified) |
| wiremock 0.6.5 | `^0.22` (verified; no newer release) |
| oauth2 5.0.0 | `>=0.21, <0.23`, which excludes 0.23 (Perplexity; jr does not use it) |
| tower-http 0.7.1 | `^0.22` (optional `auth`; Perplexity) |
| jsonwebtoken 11.1.0 | `^0.22` (Perplexity) |
| http-auth 0.1.10 | `^0.22` (Perplexity) |
| keyring 4.2.0 | `^0.23` dev-dep only (Perplexity). jr is on keyring 3, which has no base64 in our lock. |
| hyper-rustls 0.27.10, rustls-pemfile 2.2.0, tungstenite 0.30.0 | no direct base64 dependency (Perplexity) |

### 2.5 Verdict for #842: BLOCK standalone, SAFE combined

---

## 3. PR #923: dtolnay/rust-toolchain e2a55d2f -> 683b588c

### 3.1 Commits (GitHub API, verified)

| SHA | Date (UTC) | Message | Verified sig |
|---|---|---|---|
| `e2a55d2ffb04f378e9626c28d38b36d230d1e12f` | 2026-10-09T01:48:42Z | "Merge pull request #187 from dtolnay/pwn" / "Safely handle action inputs" | yes (GitHub web-flow) |
| `683b588c487a69d01f6c6ddf40f036ff682cc2c8` | **2026-10-16T02:21:45Z** (author = committer, dtolnay) | "Add 1.99.1 patch release" | yes (PGP, valid) |

- **7-day point: 2026-10-23T02:21:45Z (confirmed).**
- `compare/e2a55d2f...683b588c`: ahead 1, behind 0, one commit. The only file changed is **`scripts/update-revs.sh`** (+1/-1), which appends `1.99.1` to the `patch_releases` array. **`action.yml` is unchanged.** This is a maintainer script that regenerates version branches, so it has no effect on consumers of the master SHA.
- **Branch:** `683b588c` is the current HEAD of `master` (the `commits?sha=master` list puts it first). **There are no commits newer than 683b588c on master** as of this check.

### 3.2 Security relevance
- `683b588c` has none.
- The security-relevant change is in **`e2a55d2f`** (PR #187, branch name "pwn"). It stops inlining `${{ inputs.* }}` / `${{ steps.parse.outputs.toolchain }}` into `run:` shell scripts and passes them through `env:` with quoted expansion. It writes `$GITHUB_OUTPUT` with a random heredoc delimiter, builds rustup flags as a bash array with `set -f`, and drops the separate `flags` step. This hardens against script injection through action inputs. For our workflows the inputs are hard-coded literals (`toolchain: "1.88.0"`/stable), so practical exposure was low, but the hardening is good to have.

### 3.3 Discrepancy to verify
The local checkout (detached HEAD at `fb9d015c`) pins **`02cb101ec7c40f2c49e1d9714d64511d8e1b74de`** (2026-09-12) in ci.yml (two sites), release.yml, sign-and-publish.yml, e2e.yml, e2e-sweeper.yml and backfill-release.yml. It does not pin `e2a55d2f`. The PR's stated "from" SHA is `e2a55d2f`, so either `develop` has moved past this snapshot (an earlier bump to e2a55d2f merged) or the PR description differs from the tree. From `02cb101e`, `compare/02cb101e...683b588c` = 6 commits: "Retry release-server checksum failures" (#186, 2026-10-01), the #187 input-hardening commits (2026-10-09), and 683b588c. Files: `action.yml` +44/-20 and `update-revs.sh` +1/-1. The ci.yml line-259 `# 1.88.0` comment and the msrv job also have to be reconciled with CLAUDE.md, which says the msrv job uses SHA `6c977a6c...`. **This needs checking against the live `develop` tip.**

### 3.4 Verdict for #923: WAIT until ≥ 2026-10-23T02:21:45Z, then SAFE
Waiting costs nothing, because 683b588c is functionally identical to e2a55d2f. If `develop` is actually still on `02cb101e`, then `e2a55d2f` (11 days old, passes the cooldown) is policy-eligible today and carries the input-hardening fix.

---

## 4. Advisories (RustSec / GHSA / OSV)

- **reqwest:** no RustSec package page exists (404 at rustsec.org/packages/reqwest.html), the OSV list query returned "No results", and Perplexity found no GHSA. **No advisories for 0.13.x.**
- **base64:** the only advisory is RUSTSEC-2017-0004 / GHSA-x67x-vg9m-65c3 (affects < 0.5.2). **None for 0.22.x or 0.23.x.**
- **hyper-util 0.1.x:** none found (Perplexity search of RustSec/GHSA/OSV; lower confidence, because no direct package-page fetch was made).
- Caveat: transitive-dependency advisories were not swept. The CI `cargo deny check advisories` job remains the authority.

---

## 5. Recommended action

1. **Close #854 and #842** (or keep one as a carrier) and open **one combined PR** with:
   - `Cargo.toml`: `base64 = "0.23"`
   - `cargo update -p reqwest --precise 0.13.5 -p hyper-util --precise 0.1.21 -p base64` (hyper-util 0.1.21: 26 days old, patch bump, MSRV 1.85, edition 2024. Its changelog includes a behavior change for the `tracing` feature that jr does not use, plus CONNECT-response validation and proxy-matcher fixes.)
   - `deny.toml`: add `[[bans.skip]] name = "base64" version = "0.22"` with a reason like "wiremock 0.6.5 (dev-dependency only) requires base64 ^0.22; runtime graph (jr, reqwest 0.13.5, hyper-util 0.1.21) is on 0.23. Remove when wiremock releases with base64 0.23." This follows the repo's existing skip-reason convention.
   - Run `cargo deny check` locally. Expect no `unnecessary-skip` and no new duplicates.
2. **#923:** merge on or after 2026-10-23T02:21:45Z, after confirming `develop`'s current pin (§3.3).

## 6. Open questions / inconclusive

- The combined-PR Deny result is **inferred, not executed**. Verify with `cargo deny check bans`.
- Whether `base64::prelude` existed in 0.22 and was removed in 0.23 was not verified. jr does not use it.
- The pinned-SHA mismatch for #923 (`02cb101e` local vs `e2a55d2f` stated in the PR) needs a check against the `develop` tip.
- hyper-util advisory status rests on a search-engine synthesis, not a direct registry page.
- The reqwest proxy-credential fix (#3098) has no advisory. Whether it rises to security severity is not established.
- `.factory/specs/research/RESEARCH-INDEX.md` was not updated, as instructed ("touch nothing else").

---

## Research Methods

| Tool | Queries | Purpose |
|---|---|---|
| **Perplexity perplexity_research (PRIMARY)** | 1 | base64 0.23 breaking changes and regressions, ecosystem base64 adoption, RustSec/GHSA/OSV sweep |
| Perplexity perplexity_reason | 0 | n/a |
| Perplexity perplexity_search | 0 | n/a |
| Perplexity perplexity_ask | 0 | n/a |
| Context7 | 0 | not needed: docs.rs fetched directly |
| Tavily | 0 | not available in this session |
| WebFetch | ~27 | crates.io API (reqwest/base64/hyper-util/wiremock versions and dependencies); GitHub API (dtolnay commits/compare x3, reqwest compares x2, wiremock commits/PRs); raw CHANGELOG/RELEASE-NOTES (reqwest, base64, hyper-util); docs.rs base64 0.23.1 (Engine, general_purpose); rustsec.org; osv.dev; cargo-deny config docs |
| WebSearch | 0 | n/a |
| Local Read/Grep | ~9 | Cargo.toml, Cargo.lock, deny.toml, workflow pins, base64 call sites |
| Training data | 1 area | general knowledge that cargo-deny `exclude-dev` defaults to false. The docs only imply this ("off unless enabled"). |

**Total MCP tool calls:** 1 (plus about 27 primary-source WebFetch calls)
**Training data reliance:** low. Every version, date and dependency requirement came from the crates.io or GitHub APIs. Ecosystem rows marked "Perplexity" are secondary.
