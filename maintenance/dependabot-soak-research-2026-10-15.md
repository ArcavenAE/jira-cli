# Dependabot Soak-Timer Research — 2026-10-15

**Type:** general (dependency soak review), read-only
**As of:** 2026-10-15 (UTC)
**Extends:** `.factory/maintenance/dependabot-soak-research-2026-10-05.md`
**Policy:**
- cargo major bumps: 30 days. A pre-1.0 minor bump counts as major.
- cargo minor and patch bumps: 7 days.
- GitHub Actions: 7 days.
- A version that fixes a published GHSA or RUSTSEC advisory is exempt.

Soak is measured from the TARGET version's publish date.

**Formula:** days elapsed = calendar-date difference (2026-10-15 − publish date, UTC). A version passes when elapsed ≥ required.

## 1. Summary table

| PR | Target (pinned SHA verified) | Publish (UTC) | Req. | Elapsed | Soak | Yanked | Advisories | Newer available / recommendation | MSRV (floor 1.88) |
|---|---|---|---|---|---|---|---|---|---|
| #918 | actions/download-artifact v8.0.2 → `9000827ccba6bdab643e8b6fd33ac0654aef8333`. Lightweight tag, matches the PR. | 2026-10-07T10:09:51Z (release) | 7 | 8 | **PASS** | No | None in 2026. The only GHSA is GHSA-cxww-7g56-2vh6 (2024, affects only 4.0.0–4.1.2). | None; it is the latest v8. **Merge.** Note: the PR keeps the comment `# v8`, not `# v8.0.2`. | n/a |
| #917 | step-security/harden-runner v2.22.1 → `ccd8616d44fd3846e67624a50d5aad6d37bf2d25`. Lightweight tag, matches the PR. | 2026-10-08T00:46:25Z | 7 | 7 | **PASS** (exactly at the threshold) | No | None new. The last harden-runner GHSAs are from 2026-03-17 (affect ≤2.15.1). | None; it is the latest. **Merge**, but see §2.2 on agent changes and open issue #705. | n/a |
| #915 | taiki-e/install-action v2.87.26 → `f7e5d7c961414b23f5b25b2da9294395d08513ad`. Lightweight tag, matches the PR. | 2026-10-06T15:27:14Z | 7 | 9 | **PASS** | No | None | v2.87.27 (2026-10-09, 6d, **FAIL**) and v2.87.28 (2026-10-12, 3d, **FAIL**). v2.87.26 is the newest that passes. **Merge as-is.** | n/a |
| #914 | dtolnay/rust-toolchain `e2a55d2ffb04f378e9626c28d38b36d230d1e12f`. Untagged merge of PR #187; HEAD of protected `master`. | 2026-10-09T01:48:42Z (commit) | 7 | 6 | **FAIL** (first eligible **2026-10-16**) | n/a (on protected `master`) | None. The repo security-advisories API returns `[]`. PR #187 is input-injection hardening with no GHSA, so the exemption does not apply. | It is the current `master` tip. The intermediate `7e38f4b4` (2026-10-01, 14d) would pass now, but it lacks the #187 hardening. **Wait one day and merge #914.** | n/a |
| #892 | github/codeql-action/upload-sarif v4.38.2 → `2892aa5e19bbd11bc0cff5427e3b750a04d9e3c2`. **Annotated tag dereferenced; matches the PR. The prior UNVERIFIED note is resolved.** | 2026-09-24T10:27:53Z | 7 | 21 | **PASS** | No | None in 2026 | **Yes.** v4.38.3 (2026-10-08T13:01:01Z, 7d, **PASS**; annotated tag `cee97f86…` → commit `24c54180a607b1449ed407dd24f251e4e9147c8d`) is the newest that passes. v4.39.0 (2026-10-15, 0d, FAIL; it raises the minimum CodeQL bundle to 2.20.7). Merging 4.38.2 is fine. Optionally take v4.38.3: it updates the bundle to 2.27.2 and fixes an `init` bundle-selection bug that is irrelevant to `upload-sarif`. | n/a |
| #885 | serde_json 1.0.151 | 2026-07-20T05:54:44Z | 7 | 87 | **PASS** | No | None (rustsec page 404) | **Yes, but none pass yet.** 1.0.152 (2026-10-10, 5d), 1.0.153 (2026-10-11, 4d) and 1.0.154 (2026-10-11, 4d) all **FAIL**. 1.0.151 is the newest that passes. **Merge as-is.** 1.0.154 becomes eligible on 2026-10-18. | 1.71 — OK |
| #883 | rand 0.10.3 | 2026-09-20T06:37:47Z | 7 | 25 | **PASS** | No | RUSTSEC-2026-0097 / GHSA-cq8v-f236-94qc affects only `=0.10.0`, so it does not affect this version. Nothing new. | None; it is the latest. **Merge.** | 1.85 — OK |
| #855 | comfy-table 8.0.0 | 2026-08-05T01:05:28Z | 30 (major) | 71 | **PASS** | No | None (rustsec 404) | 8.0.1 (2026-09-25T15:21:37Z) is at 20d. As a 7.2.2→8.0.1 major jump it **FAILS** until **2026-10-25**. There is no 8.0.2: the CHANGELOG shows `[8.0.2] - unreleased` with no entries. The recommendation is unchanged: merge 8.0.0 now and take 8.0.1 as a patch later. PR `mergeable_state: unstable` (not investigated). | 8.0.0: none declared (edition 2024). 8.0.1: 1.88 = floor — OK |
| #854 | reqwest 0.13.5 | 2026-09-08T20:55:26Z | 7 | 37 | **PASS** | No | None (rustsec 404; GHSA query empty) | None; it is the latest. **Merge.** PR `mergeable_state: unstable` (not investigated). | 1.85.0 — OK |
| #842 | base64 0.23.1 | 2026-08-04T12:34:31Z | 30 (pre-1.0 minor) | 72 | **PASS** | No | None new. The only advisory is RUSTSEC-2017-0004 / GHSA-x67x-vg9m-65c3, which affects `<0.5.2`. | None; it is the latest, and RELEASE-NOTES has no newer section. **Merge.** PR `mergeable_state: unstable` (not investigated). | 1.71.0 — OK |

- No target version is yanked.
- No PR fixes an advisory, so the security exemption applies to none of them.
- **No new GHSA or RUSTSEC advisory was published between 2026-10-05 and 2026-10-15 for any of these packages.** This was checked against the GitHub advisories API (actions and rust ecosystems), rustsec.org package pages, and one Perplexity sweep.

## 2. New targets — notes

### 2.1 actions/download-artifact v8.0.2 (#918)
- **Changes:**
  - updates `@actions/artifact` to 6.3.1 (#492)
  - better HTTP 429 retries: honors a valid `Retry-After`, otherwise uses bounded backoff
  - README update (#473)
- No input or default changes. The ESM migration and `digest-mismatch: error` are v8.0.0 changes and are already in the current pin.
- The PR touches 9 `uses:` lines across 5 workflows.
- Sources:
  - https://api.github.com/repos/actions/download-artifact/releases
  - https://api.github.com/repos/actions/download-artifact/git/ref/tags/v8.0.2
  - https://api.github.com/repos/Zious11/jira-cli/pulls/918/files

### 2.2 step-security/harden-runner v2.22.1 (#917)
- **Releases since the current pin:**
  - v2.22.0 (2026-10-06): community Linux ARM64 support, GHES self-hosted VM support (enterprise), and macOS/Windows deny-list support in block mode (enterprise).
  - v2.22.1 (2026-10-08): fixes security rules not initializing on GHES VMs, and implicitly adds the GHES hostname to `allowed_endpoints` in block mode.
- **Egress-policy defaults: unchanged.** `action.yml` at both `e14015d5` (v2.21.1) and `ccd8616d` (v2.22.1) has `egress-policy` default `"block"`, `disable-sudo` `"false"` and `disable-file-monitoring` `"false"`, and uses `runs.using: node24`.
  - The only new inputs are `customer` and `server-name` (GHES-only, default `""`).
  - The PR changes only `uses:` lines across 11 workflows. All existing `egress-policy: audit` / `block` lines are untouched context.
- **Egress logic change.** `src/policy-utils.ts` adds `includeGHESServerEndpoint`, which appends `<GHES host>:*` to the allow-list on GHES only. This is a no-op on github.com runners.
- **Other behavior changes (compare `e14015d5...ccd8616d`, 24 commits):**
  - `src/cleanup.ts` drops an arm64/TLS-disabled early return.
  - The bundled agent binaries and checksums were bumped:

| Agent | Old version | New version |
|---|---|---|
| Linux community (non-TLS) | v0.16.3 (amd64 only) | v0.17.0 (now also arm64) |
| Linux agent-ebpf / bravo | v1.9.1 | v1.9.3 |
| macOS installer | v0.0.6 | v0.0.7 |
| Windows agent | v1.0.7 | v1.0.10 |

  The community agent is the runtime component on our Linux jobs, so this is the main regression surface. Watch the first CI runs after merge.
- **Open issue #705 (2026-10-13).** On `ubuntu-24.04` westus2 hosted runners the agent cannot bind `127.0.0.1:53`. Its revert then restarts Docker and kills service containers; in audit mode the agent exits.
  - The reporter reproduced it on **both v2.21.1 and v2.22.1**, so it is a runner-environment problem, not a regression from this bump.
  - The issue was still open when fetched. Perplexity claimed GitHub deployed a runner-side fix; that is UNVERIFIED.
- Sources:
  - https://api.github.com/repos/step-security/harden-runner/releases
  - https://api.github.com/repos/step-security/harden-runner/git/ref/tags/v2.22.1
  - https://raw.githubusercontent.com/step-security/harden-runner/ccd8616d44fd3846e67624a50d5aad6d37bf2d25/action.yml
  - https://raw.githubusercontent.com/step-security/harden-runner/e14015d583714f6e62063499dc959a02595150a1/action.yml
  - https://api.github.com/repos/step-security/harden-runner/compare/e14015d583714f6e62063499dc959a02595150a1...ccd8616d44fd3846e67624a50d5aad6d37bf2d25
  - https://api.github.com/repos/step-security/harden-runner/issues/705
  - https://api.github.com/advisories?ecosystem=actions&affects=step-security/harden-runner

### 2.3 taiki-e/install-action v2.87.26 (#915)
- v2.87.18 through v2.87.26 only bump the default tool manifests. For v2.87.26 those are tombi, prek, mise, kache and hyperfine.
- Nothing is security-related and there are no non-manifest changes.
- The PR touches `ci.yml` (3 lines) and `mutants-nightly.yml` (1 line).
- Sources:
  - https://api.github.com/repos/taiki-e/install-action/releases
  - https://api.github.com/repos/taiki-e/install-action/git/ref/tags/v2.87.26
  - https://api.github.com/repos/Zious11/jira-cli/pulls/915/files

### 2.4 dtolnay/rust-toolchain e2a55d2f (#914)
- **Branch.** `branches-where-head` returns `master` with `protected: true`.
- **Changes since the current pin `02cb101e` (2026-09-12):**
  1. `7645b072` / merge `7e38f4b4` (2026-10-01): "Retry release-server checksum failures" (PR #186). This is the content of the superseded #900.
  2. `83d06109` "Safely handle action inputs" and `6af9a09a` "Unify flags[@] and downgrade[@]", merged as `e2a55d2f` (PR #187, branch `dtolnay/pwn`, closes #179, merged 2026-10-09T01:48:42Z).
     - The `toolchain`, `targets` and `components` inputs are no longer `${{ }}`-expanded into `run:` scripts. They are passed via `env:` and quoted, with `set -f` and a bash flags array.
     - The `flags` step was removed.
     - `GITHUB_OUTPUT` uses a heredoc delimiter that resists collisions.
     - This is defense-in-depth against script injection. Our inputs are static literals (`1.88.0` / `stable`), so we were not exposed. There is no GHSA (advisories API `[]`), so no soak exemption applies.
- The `toolchain:` input and the `RUSTUP_TOOLCHAIN` handling in our `msrv` job are unaffected in principle: the toolchain is still installed via `rustup toolchain install "$toolchain"`. Confirm on the PR's CI run.
- The PR touches 6 workflows (7 lines).
- Sources:
  - https://api.github.com/repos/dtolnay/rust-toolchain/commits?sha=master
  - https://api.github.com/repos/dtolnay/rust-toolchain/commits/e2a55d2ffb04f378e9626c28d38b36d230d1e12f/branches-where-head
  - https://api.github.com/repos/dtolnay/rust-toolchain/pulls/187
  - https://github.com/dtolnay/rust-toolchain/commit/83d06109b7912fe94032e68e59feb6b9e3070e34.diff
  - https://api.github.com/repos/dtolnay/rust-toolchain/security-advisories

## 3. Re-check notes (changes since 2026-10-05)

- **#892 codeql.** The tag dereference is now verified: annotated tag `88585263…` → commit `2892aa5e…`, tagger date 2026-09-24T10:27:46Z. It matches the PR's pin.
  - New since 10-05: v4.38.3 (2026-10-08) and v4.39.0 (2026-10-15). v4.39.0 raises the minimum bundle to 2.20.7, validates `checkout_path` in `analyze`, and has cache and `start-proxy` fixes.
  - The v3.38.3 and v3.39.0 backports are not relevant to us.
  - Sources: https://api.github.com/repos/github/codeql-action/releases , https://api.github.com/repos/github/codeql-action/git/tags/88585263c0627ee42c0e1c5143a112c8d6f4aa18 , https://api.github.com/repos/github/codeql-action/git/tags/cee97f86b972a3ded3c58d04148362b193ddc518
- **#885 serde_json.** Three new patch releases, none of them security-related:
  - 1.0.152: keeps the sign of `-0` in `arbitrary_precision`, and fixes comparing large values with `f32::INFINITY`.
  - 1.0.153: reports invalid UTF-8 at the first bad byte.
  - 1.0.154: supports `preserve_order` in no_std builds.

  The PR still targets 1.0.151. Sources: https://crates.io/api/v1/crates/serde_json/versions , https://api.github.com/repos/serde-rs/json/releases
- **#883 rand.** **The PR #1841 claim is now VERIFIED.** "Reject UniformDuration sampler state which can panic in Duration::new" was opened 2026-09-21 and is still **open and unmerged**. The author says it is reachable only by deserializing untrusted or corrupted data, is not a memory-safety issue, and was deliberately not filed as an advisory. No newer rand release exists. Sources: https://api.github.com/repos/rust-random/rand/pulls/1841 , https://crates.io/api/v1/crates/rand/versions , https://rustsec.org/packages/rand.html
- **#855 comfy-table.** 8.0.1 passes its 30-day soak on **2026-10-25** (2026-09-25 + 30). There is no 8.0.2 on crates.io; the CHANGELOG shows `[8.0.2] - unreleased` and it is empty. Sources: https://crates.io/api/v1/crates/comfy-table/versions , https://raw.githubusercontent.com/nukesor/comfy-table/main/CHANGELOG.md
- **#854 reqwest.** No change: 0.13.5 is still the latest and has no advisories. Sources: https://crates.io/api/v1/crates/reqwest/versions , https://rustsec.org/packages/reqwest.html (404)
- **#842 base64.** No change: 0.23.1 is still the latest.
  - The features map is still `default = ["std", "simd-unsafe"]`, `simd-unsafe = []`.
  - Nothing new published about `simd-unsafe`: no advisory, no RELEASE-NOTES entry, and nothing in the Perplexity sweep.
  - The posture note from 10-05 stands: SIMD unsafe code is on by default, and `default-features = false, features = ["std"]` opts out.
  - Sources: https://crates.io/api/v1/crates/base64/versions , https://raw.githubusercontent.com/marshallpierce/rust-base64/master/RELEASE-NOTES.md , https://rustsec.org/packages/base64.html

## 4. Inconclusive / UNVERIFIED

- PRs #855, #854 and #842 show `mergeable_state: unstable` (last updated 2026-09-21). This probably means failing or pending checks. Not investigated; out of scope.
- The claim that GitHub deployed a runner-side fix for harden-runner #705 comes from Perplexity only (UNVERIFIED). The GitHub issue was still open when fetched.
- I read the harden-runner compare diff only through a summarizer, not line by line. A reviewer who wants certainty about the agent checksum values should read `src/checksum.ts` in the PR.
- Regression searches rely on one Perplexity sweep plus release notes and issue lookups. Finding no reports does not prove there are no regressions.
- Not added to `.factory/specs/research/RESEARCH-INDEX.md`, because the output path was caller-specified (same as the prior report).

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Advisory and regression sweep (2026-10-01..15) for all 4 new actions, codeql and 5 crates; harden-runner v2.22.x and download-artifact v8.0.2 change summaries |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | Not needed (registry and release facts, not API docs) |
| Tavily | 0 | Not available in this session; cross-validated via primary-source WebFetch |
| WebFetch | 44 | GitHub releases, tag refs and annotated-tag objects, commits, branches-where-head, compare, issues, PR files/metadata, security-advisories and global advisories APIs; crates.io versions API; rustsec.org package pages; CHANGELOG/RELEASE-NOTES; action.yml at both harden-runner SHAs |
| Grep (local) | 1 | Current pins in `.github/workflows` and Cargo.toml repository URL |
| Training data | 0 areas | — |

**Total MCP tool calls:** 1
**Training data reliance:** low. Every date, SHA, yanked flag, MSRV and advisory statement comes from the GitHub, crates.io or rustsec primary sources fetched above.
