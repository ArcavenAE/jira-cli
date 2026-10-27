# Dependabot Batch Soak Research — 2026-10-27

**Type:** general (dependency soak review), read-only
**As of:** 2026-10-27 (UTC)
**Extends:** `.factory/maintenance/dependabot-soak-research-2026-10-15.md`
**Policy:**
- cargo major bumps: 30 days. A pre-1.0 minor bump counts as major.
- cargo minor and patch bumps: 7 days.
- GitHub Actions: 7 days.
- A version that fixes a published GHSA or RUSTSEC advisory is exempt.

Soak is measured from the TARGET version's publish date.

**Formula:** days elapsed = calendar-date difference (2026-10-27 − publish date, UTC). A version passes when elapsed ≥ required.

**Untrusted-input note:** PR bodies, changelogs and release notes were treated as data only. No instructions in them were followed.

**Tooling note:** this agent has no shell, so `gh pr diff` / `gh pr checks` were not run. The same data came from the public GitHub REST API instead: `pulls/<N>/files`, `pulls/<N>`, `commits/<head>/check-runs`, and `commits/<head>` for the parent SHA.

## 0. Headline — every PR's CI Gate is red for a reason outside the PRs

- **Every PR in the batch fails `Deny (licenses + vulnerabilities)`, so `CI Gate` fails too.** That covers the Actions-only PRs (#937, #942, #943) and the 1-line Cargo.lock bumps (#938, #939).
  - #923 was rebased at 2026-10-27T14:59Z and was still running when fetched. Expect the same result.
- **`develop` itself was green.** Its last push CI, run 39474013995 on c72f8131 (2026-10-20), concluded `success`. The PRs' lockfiles are byte-identical to develop apart from their own bumps.
- **So the failure is almost certainly from RustSec advisory-db entries published after 2026-10-20 against crates already in develop's lockfile.** Most likely causes:
  - **RUSTSEC-2026-0382** (rustls-webpki, vulnerability, crypto-failure, CVE-2026-111943; issued 2026-10-20; patched `>=0.103.16, <0.104.0-alpha.1`). develop locks **rustls-webpki 0.103.15**.
  - **RUSTSEC-2026-0383** (webpki-root-certs, vulnerability, same CVE; issued 2026-10-20; patched `>=1.0.10`). develop locks **webpki-root-certs 1.0.6**.
  - **RUSTSEC-2026-0386** (tokio `AsyncFd` safe constructors, informational/unsound; issued 2026-10-23; patched `>=1.53.3` and `>=1.51.6,<1.52.0`). develop locks **tokio 1.53.2**. It may or may not fail deny, depending on the `unsound` scope setting. #939 clears it but still fails Deny, which is consistent with the two webpki advisories being the blockers.
- `deny.toml` has `[advisories] ignore = []`.
- **UNVERIFIED:** the job log needs a GitHub login, and the only annotation is an unrelated Ubuntu-26 runner notice. The exact failing IDs above are inferred from the advisory DB and develop's lockfile, not read from the log. Confirm with `cargo deny check advisories` on develop.
- **Recommended prerequisite:** first land a separate lockfile-only PR, then rebase the batch.
  - The PR: `cargo update -p rustls-webpki -p webpki-root-certs` (→ ≥0.103.16 / ≥1.0.10). It is advisory-fixing, so it is soak-exempt under policy.
  - webpki-root-certs 1.0.10 was published 2026-10-19T20:11Z and 1.0.11 on 2026-10-23.
  - The rustls-webpki 0.103.16 publish date was not fetched. The crates.io page listing returned only 0.104 alphas. Its existence is attested by the RUSTSEC-2026-0382 patched range.
  - Otherwise every PR below needs an admin bypass of the single required check.

## 1. Summary table

| PR | Target (pinned SHA verified) | Publish (UTC) | Req. | Elapsed | Soak | Yanked | Advisories | Newer available / recommendation | MSRV (floor 1.88) |
|---|---|---|---|---|---|---|---|---|---|
| #937 | taiki-e/install-action v2.87.29 → `8cca0918f8471c33515202b73f56ab27f2bed283`. Lightweight tag, matches the PR. | 2026-10-16T16:10:45Z | 7 | 11 | **PASS** | No | None (actions advisories API: nothing in 2026-10) | v2.87.30 (10-21, 6d, **FAIL**), v2.87.31 (10-23, 4d, FAIL), v2.87.32 (10-26, 1d, FAIL). v2.87.29 is the newest that passes. **Merge as-is** once the Gate is green. | n/a |
| #938 | insta 1.49.0 | 2026-10-03T01:12:59Z | 7 (minor) | 24 | **PASS** | No | None found (GHSA rust feed; Perplexity sweep) | None; it is the latest. **Merge** once the Gate is green. The PR's own Test/Coverage/Mutation jobs are all green, so no snapshot churn (see §2.2). | 1.66.0 — OK |
| #939 | tokio 1.53.3 | 2026-10-13T20:51:46Z | 7 (patch) | 14 | **PASS** (also soak-exempt: fixes RUSTSEC-2026-0386) | No | 1.53.3 is the **fix** for RUSTSEC-2026-0386 (unsound AsyncFd). Unaffected by RUSTSEC-2026-0384 / GHSA-5wjr-9356-4wc8 (`=1.54.0` only). | 1.54.0 (2026-10-19) is **YANKED** (RUSTSEC-2026-0384, Interval UAF race). 1.54.1 (2026-10-21T21:05Z, 6d) **FAILS** 7d; first eligible **2026-10-28**. It raises tokio MSRV to 1.85 (still OK). **Merge 1.53.3**; consider 1.54.1 in a later batch. | 1.71 — OK |
| #940 | proptest 1.12.0 | 2026-10-10T18:18:05Z | 7 (minor) | 17 | **PASS** | No | None found | None; it is the latest. **HOLD** pending the baseline Deny fix **plus** a local `cargo deny check bans`, because the lock adds a second `toml_edit` (see §2.4). | **1.88 = floor** — OK (no headroom) |
| #941 | saphyr-parser 0.0.12 → 0.2.2 | — | — | — | — | — | — | **See separate review.** | — |
| #942 | github/codeql-action/upload-sarif v4.39.0 → `6f2ac81f5cd81fe351a197ba0b00d91d03cd2aee`. Annotated tag `48870fdd…` dereferenced; matches the PR. | 2026-10-15T10:57:05Z (release; tagger 10:56:58Z) | 7 | 12 | **PASS** | No | None in 2026-10 | v4.39.1 (2026-10-21T15:48Z, 6d, **FAIL**; first eligible **2026-10-28**). It only bumps the default bundle to 2.27.3. **Merge 4.39.0** once the Gate is green. | n/a |
| #943 | step-security/harden-runner v2.22.2 → `dc2769abcc0fcfbadfc1df54081c1608579ef6b2`. Lightweight tag, matches the PR. | 2026-10-19T16:55:35Z | 7 | 8 | **PASS** | No | None new. The last GHSAs are from 2026-03-17 (≤2.15.1). | None; it is the latest. **Merge** once the Gate is green. | n/a |
| #923 | dtolnay/rust-toolchain `683b588c487a69d01f6c6ddf40f036ff682cc2c8`. Untagged; HEAD of protected `master`. | 2026-10-16T02:21:45Z (commit) | 7 | 11 | **PASS** | n/a (protected `master`) | None | **No newer commit**: 683b588c is still the `master` tip. **Merge** once the Gate is green. | n/a |

- No target version is yanked.
- #939 fixes RUSTSEC-2026-0386, so the security exemption applies to it. It also passes soak anyway.
- No new GHSA was found for the four Actions. The GitHub advisories API (actions ecosystem) shows nothing published since 2026-06.

## 2. Per-PR notes

### 2.1 taiki-e/install-action v2.87.29 (#937)
- Changes:
  - Manifest-only update of 16 default tool versions: zizmor, wasmtime, uv, trivy, osv-scanner, just, cargo-crap and others.
  - Nothing security-related, and no non-manifest changes.
- The PR touches `ci.yml` (3 lines) and `mutants-nightly.yml` (1 line). The `cargo-mutants@27.1.0` pin is unchanged context.
- Sources:
  - https://api.github.com/repos/taiki-e/install-action/releases
  - https://api.github.com/repos/taiki-e/install-action/git/ref/tags/v2.87.29
  - https://api.github.com/repos/Zious11/jira-cli/pulls/937/files

### 2.2 insta 1.49.0 (#938)
- Notable items in 1.49.0:
  - **JSON map keys for unit enum variants now use the serialized variant name, including serde renames (#934). This changes snapshot output for maps keyed by unit enum variants.**
    - Our `assert_json_snapshot!` sites live in `src/cli/issue/json_output.rs`, `src/cli/auth/tests/mod.rs`, `src/cli/sprint.rs`, `src/adf.rs` and `tests/issue_changelog.rs`.
    - All Test (ubuntu/macos/windows), Coverage and Mutation jobs passed on the PR, so no committed snapshot is affected.
  - `cargo insta test --all-targets` under nextest no longer runs doctests (#460). This is irrelevant: CI uses `cargo test`.
  - Smaller items:
    - `Option<&OsStr>` snapshot names are accepted.
    - Trailing semicolons were removed from the serialization macros (#940).
    - The mismatch hint now mentions `INSTA_UPDATE=always`.
    - Prebuilt `cargo-insta` binaries are now published for aarch64 Linux.
- Unreleased (not in 1.49.0):
  - u64/u128 map-key JSON fix
  - `**` redaction-matching fix
  - `INSTA_UNREFERENCED` env var
- One-line Cargo.lock change. There are no new transitive dependencies.
- Sources:
  - https://crates.io/api/v1/crates/insta/versions
  - https://raw.githubusercontent.com/mitsuhiko/insta/master/CHANGELOG.md
  - https://api.github.com/repos/Zious11/jira-cli/pulls/938/files

### 2.3 tokio 1.53.3 (#939)
- Changes:
  - Adds `AsyncFd::register` / `register_with_interest`.
  - **Deprecates `AsyncFd::{new, with_interest, try_new, try_with_interest}`** (the RUSTSEC-2026-0386 remedy).
  - Fixes:
    - a `DuplexStream` waker bug
    - a `join!`/`try_join!` `unreachable_code` warning
    - paused-time auto-advance on `current_thread`
    - semaphore close wakeups
    - an unstable `io_uring` op lifetime issue
- **The repo has zero `AsyncFd` uses** (grep over `src/` and `tests/`), so the deprecation cannot raise `-D warnings` clippy errors. Clippy on the PR was green.
- One-line Cargo.lock change.
- **1.54.0 context:**
  - Released 2026-10-19 and yanked 2026-10-21.
  - Advisory: RUSTSEC-2026-0384 / GHSA-5wjr-9356-4wc8 / CVE-2026-115567, medium severity.
  - Bug: an `Interval::poll_tick` vs time-driver race causes use-after-free on the multi-thread runtime.
  - 1.54.1 reverts "remove the runtime handle from timers" (#8692).
  - Do **not** accept a 1.54.0 bump.
- Sources:
  - https://crates.io/api/v1/crates/tokio/versions
  - https://api.github.com/repos/tokio-rs/tokio/releases
  - https://rustsec.org/advisories/RUSTSEC-2026-0386.html
  - https://api.github.com/advisories/GHSA-5wjr-9356-4wc8
  - https://api.github.com/repos/Zious11/jira-cli/pulls/939/files

### 2.4 proptest 1.12.0 (#940)
- **Breaking changes (upstream):**
  - MSRV is now 1.88.0, which equals our floor.
  - Moves to rand 0.10 / rand_xorshift 0.5. Rand extension methods now need `RngExt`, which is in the prelude.
  - bit-set 0.11 / bit-vec 0.10.
- **The repo has zero `TestRng`, `RngCore`, `new_tree` or `BitSet` uses** in `src/` and `tests/`, so none of these break us. CI Test, Clippy and MSRV were green on the PR.
- **Shrinking and persistence: no changes in 1.12.0.**
  - The regression-file format is unchanged.
  - `rand_chacha` → `chacha20::ChaCha20Rng` with "seed formats and seeded output preserved". Existing `proptest-regressions/` files should replay identically.
  - The fix "forked tests no longer fail to report persisted failures" only matters with `fork`/`timeout`.
- **Soundness fixes:**
  - RDRAND CPU check under `hardware-rng` + no_std (not used by us)
  - a `handle-panics` hook init race
- Other fixes: panics on near-max `Duration` and on `0.0..=0.0` float ranges.
- **Lockfile delta: +71/−12.**
  - Changed: bit-set 0.8.0→0.11.1, bit-vec 0.8.0→0.10.1, rand_xorshift 0.4.0→0.5.0.
  - Added: **borsh 1.8.1, borsh-derive 1.8.1** (proc-macro), core_detect 1.0.0, **proc-macro-crate 3.5.0, toml_edit 0.25.17**.
  - Nothing removed. rand 0.9.4 and rand_chacha stay because other crates still depend on them.
  - **A second `toml_edit` now coexists with 0.22.27**, and the existing `toml` dependency entry is disambiguated to `"toml_edit 0.22.27"`.
  - `deny.toml` has `multiple-versions = "deny"`, and its `skip` list covers `toml`/`toml_datetime`/`serde_spanned`/`winnow` but **not `toml_edit`**.
- **UNVERIFIED:** whether cargo-deny's feature-resolved graph actually includes borsh, and so toml_edit 0.25. bit-vec 0.10.1 declares `borsh` as optional with `std = ["serde?/std", "borsh?/std"]`, a weak dependency.
  - If it does, #940 will **still** fail `bans` after the baseline advisory fix. It would then need a reviewed `skip` entry, or a check on what activates borsh.
- **Action:** after the baseline fix, run `cargo deny check` on the rebased #940 before merging.
- Sources:
  - https://crates.io/api/v1/crates/proptest/versions
  - https://raw.githubusercontent.com/proptest-rs/proptest/main/proptest/CHANGELOG.md
  - https://api.github.com/repos/Zious11/jira-cli/pulls/940/files
  - https://crates.io/api/v1/crates/bit-vec/0.10.1/dependencies
  - https://crates.io/api/v1/crates/bit-vec/0.10.1
  - https://raw.githubusercontent.com/Zious11/jira-cli/c72f81317fd9b0b0459b9f29518f2d3d7010df06/deny.toml

### 2.5 github/codeql-action/upload-sarif v4.39.0 (#942)
- **Breaking: the minimum CodeQL bundle is now 2.20.7 (#4205).**
  - This is irrelevant to `upload-sarif` in `scorecards.yml`, which only uploads the Scorecard SARIF and runs no CodeQL analysis.
- Other changes:
  - `analyze` validates `checkout_path`.
  - A cache-restore fix for third-party cache implementations.
  - `start-proxy` release lookup.
- v4.38.3 (current pin) already emitted the CodeQL ≤2.21.2 deprecation warning.
- The PR changes one line in `scorecards.yml`.
- Sources:
  - https://api.github.com/repos/github/codeql-action/releases
  - https://api.github.com/repos/github/codeql-action/git/ref/tags/v4.39.0
  - https://api.github.com/repos/github/codeql-action/git/tags/48870fdd6b42ee6474ec4207209ff87609271a5e
  - https://api.github.com/repos/Zious11/jira-cli/pulls/942/files

### 2.6 step-security/harden-runner v2.22.2 (#943)
- Changes:
  - Fixes macOS inbound traffic being classified as outbound.
  - Fixes implicit self-hosted-runner endpoints being applied to custom Linux VM environments (enterprise).
  - Improves Linux network/DNS tracing, enforcement and process correlation (described as enterprise tier).
- No egress-policy default changes are stated.
- The PR changes 11 workflows (33 `uses:` lines), all the same SHA swap `ccd8616d…` → `dc2769ab…`.
- Not re-checked this run:
  - The `action.yml` input defaults were not diffed. Last verified at v2.22.1: `egress-policy` default `block`.
  - Issue #705 (westus2 `127.0.0.1:53` bind) was not re-fetched; it was a runner-environment issue, not a regression.
- The PR's CI jobs (which run under harden-runner) were green apart from Deny. That is a functional smoke signal for the new agent.
- Sources:
  - https://api.github.com/repos/step-security/harden-runner/releases
  - https://api.github.com/repos/step-security/harden-runner/git/ref/tags/v2.22.2
  - https://api.github.com/repos/Zious11/jira-cli/pulls/943/files

### 2.7 dtolnay/rust-toolchain 683b588c (#923) — reconfirmation
- 683b588c ("Add 1.99.1 patch release", 2026-10-16T02:21:45Z, parent `e2a55d2f`) is still the `master` HEAD (`branches-where-head` → `master`, `protected: true`).
- **It changes only `scripts/update-revs.sh`** (1+/1−). `action.yml` is untouched, so runtime behavior is identical to the already-reviewed `e2a55d2f` (PR #187 input-hardening).
- No newer commit exists.
- The PR touches 6 workflows (7 lines); the `# stable` / `# 1.88.0` comments are unchanged.
- It was rebased by Dependabot at 2026-10-27T14:59:43Z onto c72f8131. CI was in progress when fetched: 7 jobs completed `success`, 15 were in progress, and CI Gate had not run yet.
- Sources:
  - https://api.github.com/repos/dtolnay/rust-toolchain/commits?sha=master
  - https://api.github.com/repos/dtolnay/rust-toolchain/commits/683b588c487a69d01f6c6ddf40f036ff682cc2c8
  - https://api.github.com/repos/dtolnay/rust-toolchain/commits/683b588c487a69d01f6c6ddf40f036ff682cc2c8/branches-where-head
  - https://api.github.com/repos/Zious11/jira-cli/pulls/923/files

## 3. CI status and base SHA

`origin/develop` = `c72f81317fd9b0b0459b9f29518f2d3d7010df06`. It has not moved since 2026-10-20, and its push CI run 39474013995 was `success`.

| PR | Head SHA | Base SHA (checks ran against) | Checks | CI Gate | Non-success jobs |
|---|---|---|---|---|---|
| #923 | 978ed8f4 | c72f8131 (head parent verified) | 22 runs; 7 success, 15 in progress | not yet reported | none yet (in progress) |
| #937 | d2c18942 | c72f8131 (PR base.sha) | 24 | **failure** | Deny |
| #938 | c3be4a28 | c72f8131 (head parent verified) | 24 | **failure** | Deny |
| #939 | 358a3112 | c72f8131 (PR base.sha) | 24 | **failure** | Deny |
| #940 | e5d6f8bd | c72f8131 (PR base.sha) | 24 | **failure** | Deny |
| #942 | d5e4b7db | c72f8131 (PR base.sha) | 24 | **failure** | Deny |
| #943 | 9c9cb08b | c72f8131 (PR base.sha) | 24 | **failure** | Deny |

All PRs report `mergeable: true`, `mergeable_state: unstable`. The base is current, so there is no stale-base (`strict: false`) concern for this batch.

## 4. Verdicts

| PR | Soak | Verdict |
|---|---|---|
| #923 | PASS (11/7) | **MERGE-READY on soak.** Blocked only by the baseline Deny/CI Gate; wait for its in-progress CI. |
| #937 | PASS (11/7) | **MERGE-READY on soak.** Blocked by the baseline Deny/CI Gate. |
| #938 | PASS (24/7) | **MERGE-READY on soak.** Blocked by the baseline Deny/CI Gate. |
| #939 | PASS (14/7) and advisory-exempt | **MERGE-READY on soak.** Blocked by the baseline Deny/CI Gate. Do not jump to 1.54.0 (yanked). 1.54.1 is eligible 2026-10-28. |
| #940 | PASS (17/7) | **HOLD.** Needs the baseline Deny fix, then a clean local `cargo deny check` (possible `toml_edit` duplicate → `bans` failure). MSRV equals the floor exactly. |
| #941 | — | See separate review. |
| #942 | PASS (12/7) | **MERGE-READY on soak.** Blocked by the baseline Deny/CI Gate. |
| #943 | PASS (8/7) | **MERGE-READY on soak.** Blocked by the baseline Deny/CI Gate. |

**Merge order:**
1. Land the baseline advisory fix PR (rustls-webpki ≥0.103.16, webpki-root-certs ≥1.0.10; advisory-exempt).
2. Have Dependabot rebase the batch.
3. Merge #939 (it closes RUSTSEC-2026-0386 on develop), then the Actions PRs and #938.
4. Evaluate #940 last.

## 5. Inconclusive / UNVERIFIED

- **Exact Deny failure cause.** The job logs need authentication, so they were not read. The RUSTSEC-0382/0383 (and possibly 0386) attribution is an inference: develop's lockfile versions fall in the advisory ranges, the advisories were issued after develop's last green CI, and every PR fails identically. Confirm with `cargo deny check advisories` on develop.
- **rustls-webpki 0.103.16 publish date.** Not fetched. The crates.io listing page returned only the 0.104 alphas.
- **#940's `bans` exposure.** Depends on whether borsh is activated in the feature-resolved graph. Not determined.
- **The `unsound` severity scope** cargo-deny applies to RUSTSEC-2026-0386 under our `deny.toml`. Not checked.
- **harden-runner `action.yml` defaults at v2.22.2.** Not diffed this run.
- **Regression searches** rely on one Perplexity sweep plus release notes. Finding no reports does not prove there are no regressions.
- Not added to `.factory/specs/research/RESEARCH-INDEX.md`, because the output path was caller-specified (same as the prior reports).

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Sweep for 2026-10-15..27 cargo-deny breakage reports; advisories, regressions and yanks for all 6 targets plus proptest's new transitive deps; tokio 1.54.0 yank cause |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | Not needed (registry and release facts, not API docs) |
| Tavily | 0 | Not available in this session; cross-validated via primary-source WebFetch |
| WebFetch | ~45 | PR files, metadata and check-runs (GitHub API); develop push runs; tag refs and annotated-tag deref; releases (install-action, codeql-action, harden-runner, tokio); rust-toolchain commits and branches-where-head; crates.io versions (insta, tokio, proptest, rustls-webpki, webpki-root-certs, bit-vec); develop Cargo.lock and deny.toml at c72f8131; GHSA advisories API (rust and actions); rustsec.org advisory and package pages; rustsec advisory-db commits; insta and proptest CHANGELOGs |
| Grep (local) | 3 | Cargo.toml dep specs and `rust-version`; `AsyncFd`/`TestRng`/`RngCore`/`BitSet`/`assert_json_snapshot` usage in src/ and tests/ |
| Training data | 0 areas | — |

**Total MCP tool calls:** 1
**Training data reliance:** low. Every date, SHA, yanked flag, MSRV and advisory statement comes from the GitHub, crates.io or rustsec primary sources fetched above. The Perplexity output was used only for leads (RUSTSEC-0386, 0382/0383) and every lead was then verified on rustsec.org.
