# Dependabot Batch Research — 2026-10-20

**Scope:** Open Dependabot PRs #930, #931, #932, #933, #934 on `Zious11/jira-cli` (`jr`, MSRV `rust-version = "1.88"`).
**Date of research:** 2026-10-20. All registry/API facts below are as of this date.
**Trust note:** PR bodies, release notes, issue text and changelogs were treated as untrusted data. Nothing in them was followed as instructions. Every claim below was cross-checked against a registry API, a tag object, or crate source where possible.

---

## Summary table

| PR | Change | Verdict | One-line reason |
|----|--------|---------|-----------------|
| #930 | `dirs` 6.0.0 -> 7.0.0 (major) | **SAFE** | The only breaking change is Windows `preference_dir` (Local -> Roaming). `jr` never calls `preference_dir`. `config_dir`/`cache_dir`/`home_dir`/`data_dir` are byte-identical on all three OSes, and `dirs-sys` stays at 0.5.0. |
| #931 | `toml` 1.1.6 -> 1.1.8 (+4 sibling crates) | **SAFE** | Bug fixes only: duplicate-key check when deserializing into a `Table`, quoting of struct-field table headers, and a soundness fix for `toml_parser`'s opt-in `unsafe` feature. MSRV stays at 1.85. |
| #932 | `libc` 0.2.189 -> 0.2.190 | **CAUTION (low)** | This release had real regressions on FreeBSD, Apple mobile, and `siginfo_t` Send/Sync on Linux (still open). None of them is on `jr`'s build path. 0.2.191 already exists and fixes two of the three. CI is the deciding signal. |
| #933 | `ossf/scorecard-action` v2.4.4 -> v2.5.0 | **SAFE** (recommended) | No input/output changes and no new permissions. Upgrading removes a leftover debug `Println` that printed the GitHub token value (masked by Actions in standard setups). The PR's SHA matches the dereferenced tag commit. |
| #934 | `taiki-e/install-action` v2.87.26 -> v2.87.28 | **SAFE** | Only bumps the versions in the action's tool manifests. None affects `cargo-llvm-cov` or `cargo-mutants@27.1.0`. The PR's SHA matches the tag commit. One base-version discrepancy is noted below. |

---

## PR #930 — `dirs` 6.0.0 -> 7.0.0 (MAJOR)

### Registry facts (crates.io API, verified)
- `dirs` 7.0.0 was published `2026-09-05T17:32:15Z` by `soc`. Not yanked. `rust_version: null`. License `MIT OR Apache-2.0`. Checksum `8d57d423b3c82e89b9a24ca3091fee61f456a26edbd28d26c65906f4bc1dcd8f`. **This matches the checksum in PR #930's Cargo.lock diff.** [crates.io/api/v1/crates/dirs/7.0.0]
- **7.0.0 is the latest.** No 7.0.x patch release exists. [crates.io/api/v1/crates/dirs/versions]
- The repository moved from `github.com/dirs-dev/dirs-rs` to `codeberg.org/dirs/dirs-rs` (crate metadata). The GitHub mirror's last commit is "Release 6.0.0" (2025-01-12) and it has no v7 tag, so a GitHub compare view is not available. Source was verified via docs.rs instead.

### Dependency / dirs-sys / MSRV
- Dependencies for 7.0.0: `dirs-sys ^0.5.0` only. **This is identical to 6.0.0.** [crates.io deps API for both versions]
- Latest `dirs-sys` is still 0.5.0 (2025-01-11), not yanked. No new release accompanied dirs 7. That means **no change to transitive `windows-sys` / `option-ext` versions** (lock: `option-ext 0.2.0`; dirs-sys 0.5.0 uses `windows-sys` 0.59 per the dirs v6 README changelog).
- Neither `dirs` nor `dirs-sys` declares a `rust_version`. Both are tiny std-only crates, so no MSRV risk is expected against 1.88 (inference, not a declared guarantee).
- PR #930 changes only `Cargo.toml` (`dirs = "6"` -> `"7"`) and 2 lines of `Cargo.lock`. No other crate in the graph depends on `dirs` 6, so no duplicate is introduced.

### Breaking changes (README "Changelog" in the 7.0.0 crate source, verified against `src/win.rs` diff)
- **The only v7 breaking change:** on Windows, `preference_dir` now returns `{FOLDERID_RoamingAppData}` (via `data_dir`) instead of `{FOLDERID_LocalAppData}`.
  - 6.0.0 `win.rs`: `preference_dir() -> dirs_sys::known_folder_local_app_data()`
  - 7.0.0 `win.rs`: `preference_dir() -> dirs_sys::known_folder_roaming_app_data()`
  - [docs.rs/crate/dirs/6.0.0/source/src/win.rs, docs.rs/crate/dirs/7.0.0/source/src/win.rs, docs.rs/crate/dirs/7.0.0/source/README.md]
- Per-function verification of the 7.0.0 source:

| fn | Linux (`lin.rs`) | macOS (`mac.rs`) | Windows (`win.rs`) | Changed vs 6.0.0? |
|----|------------------|------------------|--------------------|-------------------|
| `home_dir` | `dirs_sys::home_dir()` | `dirs_sys::home_dir()` | `known_folder_profile()` | No |
| `config_dir` | `$XDG_CONFIG_HOME` (absolute only) else `$HOME/.config` | `~/Library/Application Support` | `known_folder_roaming_app_data()` | No |
| `cache_dir` | `$XDG_CACHE_HOME` (absolute only) else `$HOME/.cache` | `~/Library/Caches` | `data_local_dir()` = LocalAppData | No |
| `data_dir` | `$XDG_DATA_HOME` (absolute only) else `$HOME/.local/share` | `~/Library/Application Support` | RoamingAppData | No |
| `preference_dir` | (same as config) | `~/Library/Preferences` | **RoamingAppData (was LocalAppData)** | **Yes, Windows only** |

- **No macOS move to `~/.config`, no XDG handling change, and no Windows Roaming/Local change** for `config_dir`/`cache_dir`/`home_dir`/`data_dir`. The README platform table is the same in both versions.

### Impact on `jr` (repo grep, read-only)
- `src/config.rs::global_config_dir` uses `dirs::config_dir()` on Windows (BC-6.1.014, `%APPDATA%`) and `dirs::home_dir()` on Unix. It does not use `dirs::config_dir()` on macOS, because `jr` builds `~/.config/jr` itself.
- `src/cache.rs` uses `dirs::cache_dir()` on Windows (BC-6.2.016, `%LOCALAPPDATA%`) and `dirs::home_dir()` on Unix.
- **`preference_dir` is not referenced anywhere** in `src/`, `tests/`, or `build.rs`.
- Conclusion: there is **zero behavioral change** for `jr` on any platform. The existing Windows tests (`config.rs`/`cache.rs` parent-equals-`dirs::config_dir()`/`dirs::cache_dir()` assertions, `tests/docs_fallout_windows.rs`) remain valid.

### Advisories / regressions
- RustSec `crates/dirs/` contains only RUSTSEC-2020-0053 (an "unmaintained" notice, since **withdrawn**). Nothing affects 6.0.0 or 7.0.0. [api.github.com/repos/rustsec/advisory-db/contents/crates/dirs]
- Perplexity sweep: no GHSA/OSV advisories, and no post-release regression reports against 7.0.0 found on the Codeberg issue tracker. **Partially inconclusive:** I could not fetch the Codeberg issue list directly. This finding relies on the Perplexity synthesis.

**Verdict: SAFE.**

---

## PR #931 — `toml` 1.1.6+spec-1.1.0 -> 1.1.8+spec-1.1.0

### Registry facts (crates.io API)
| crate | old (lock) | new (PR) | new published | MSRV |
|-------|-----------|----------|---------------|------|
| toml | 1.1.6 (2026-09-10) | 1.1.8 (2026-10-09T02:46Z, by `epage`; checksum `20489e00…678d`) | 1.1.7 was 2026-10-08 | 1.85 |
| toml_parser | 1.1.3 | 1.1.5 (2026-10-09) | — | 1.85 |
| toml_writer | 1.1.2 | 1.1.3 (2026-10-08) | — | 1.85 |
| toml_datetime | 1.1.1 | 1.1.2 (2026-10-08) | — | 1.85 |
| serde_spanned | 1.1.1 | 1.1.2 (2026-10-08) | — | 1.85 |

- None are yanked. 1.1.8 is the latest `toml`. All declared MSRVs are 1.85, which is at or below jr's 1.88.
- The PR changes only `Cargo.lock` (5 crates, list confirmed from the PR diff). `Cargo.toml` is unchanged (`toml = "1"`).
- `toml` 1.1.8 deps now require `serde_spanned ^1.1.2`, `toml_datetime ^1.1.2`, `toml_parser ^1.1.5`, and `toml_writer ^1.1.3` (was ^1.1.1/^1.1.1/^1.1.3/^1.1.2). That is why the siblings move.
- Out of scope and unaffected: figment's separate `toml 0.8.23` / `toml_edit 0.22.27` / `toml_datetime 0.6.11` / `serde_spanned 0.6.9` chain is not touched.

### Changes (crates/toml/CHANGELOG.md + compare `toml-v1.1.7...toml-v1.1.8`)
- **1.1.7 (2026-10-08):** Fix: "When deserializing to a `Table`, be sure to check for duplicate keys". Perf: reduce cloning.
- **1.1.8 (2026-10-09):** Fix (ser): "Ensure keys are always encoded" (toml-rs/toml#1242). Before the fix, a struct field renamed via serde to a name with special characters (e.g. dots or parentheses) and holding a nested struct serialized to an **unquoted** table header. A name like `io.containerd.grpc.v1.cri` was emitted bare and read back as nested tables. The fix calls `to_toml_key()` instead of `to_owned()` in `ser/document/map.rs` / `mod.rs`.
- **toml_parser 1.1.5:** "`unsafe`: Remove possible unsoundness" (toml-rs/toml#1175). Commit text says the `unsafe` feature is exposed only in `toml_parser`, and the unsoundness is "not reachable through `toml` or `toml_edit`". Also perf: removes no-op code.
- **toml_parser 1.1.4:** perf only (token pre-allocation).

### Impact on `jr`
- `jr` uses `toml::to_string_pretty`/`to_string`/`from_str` on `GlobalConfig` and related types in `src/config.rs`. There are no `#[serde(rename…)]` attributes in `config.rs` and no `toml::Table`/`toml::Value` usage, so neither fix changes `jr`'s output for normal configs.
- The 1.1.8 key-encoding fix only produces *more correct* output. Profile names live in a map whose keys were already quoted correctly according to the issue report.
- The 1.1.7 duplicate-key check applies to `Table` deserialization, which `jr` does not use. A hand-edited config with duplicate keys is already invalid TOML.

### Advisories
- No RustSec directory exists for `toml` or `toml_parser` (advisory-db contents API 404). Perplexity found no GHSA/OSV. **The toml_parser #1175 unsoundness fix has no RUSTSEC entry** (not reachable via `toml`). Moving to 1.1.5 is a positive change regardless.

**Verdict: SAFE.**

---

## PR #932 — `libc` 0.2.189 -> 0.2.190

### Registry facts
- 0.2.190 was published `2026-10-02T19:33Z`. Not yanked. MSRV 1.65. Checksum `ce5d3ddc6d3fa000eb1536d85e147bfe31aacaba692ed6a876f95cb7c855be78`. **This matches PR #932's Cargo.lock.**
- **A newer 0.2.191 exists** (2026-10-16T22:56Z, not yanked, MSRV 1.65). `1.0.0-alpha.5` (2026-10-02) is a pre-release and is not selected by `"0.2"`.
- In `jr`, `libc = "0.2"` is a `[dev-dependencies]` edge (used only by `tests/interrupt_signal.rs`: `libc::kill`, `pid_t`, `SIGINT`). It is also a transitive dependency of tokio/reqwest and others on Unix, so the lock bump affects production builds too.

### Notable 0.2.190 changes (libc CHANGELOG / GitHub release 0.2.190)
- Adds a new opt-in `--cfg=libc_unstable_time64` (64-bit `time_t` on 32-bit gnu/musl/uclibc/windows-gnu/ESP-IDF). It is inert unless set.
- Adds many `Default` impls and a large number of platform additions.
- **Breaking in a patch release:** `BPF_ALIGNMENT` becomes `size_t` on AIX and Apple. Apple mobile targets (iOS/tvOS/watchOS/visionOS) lose many macOS-only items. **Most items deprecated before 0.2.100 are removed.** Unsound Linux/Android `af_alg_iv` trait impls are removed.

### Regressions reported against 0.2.190 (GitHub issue search, rust-lang/libc, created after 2026-10-01)
1. **#5598 FreeBSD:** `NOTE_PCTRLMASK` was removed, breaking `mio`/`nix` (and therefore tokio) on FreeBSD. tokio pinned libc 0.2.189 in its FreeBSD CI (tokio-rs/tokio#8594). **Fixed in 0.2.191** (restored with a deprecation warning).
2. **#5601 Apple mobile:** `_dyld_*` image functions became macOS-only, which broke `backtrace` and rust-lang/rust std builds on iOS (rust-lang/rust#163732). **Fixed in 0.2.191** ("Mach API available on non-macOS targets again", PR #5612).
3. **#5624 (OPEN):** "Linux siginfo_t is not Send/Sync since 0.2.190" (filed by dtolnay, x86_64-unknown-linux-gnu, caused by PR #5345). Code that requires `siginfo_t: Send + Sync` stops compiling. As of this research it is **not fixed in 0.2.191** (inconclusive whether it is intentional).

### Impact on `jr`
- `jr`'s targets are macOS (desktop), Linux gnu/musl, and Windows MSVC. None are FreeBSD or Apple mobile, so regressions 1 and 2 do not apply.
- Regression 3 would only bite if something in `jr`'s dependency tree requires `siginfo_t: Send/Sync`. Nothing in `jr` itself uses `siginfo_t`. Whether a transitive dependency does (e.g. a signal-handling crate) is **inconclusive from research alone**. A green `cargo check --all-targets` + test run on Linux in the PR's CI settles it definitively.
- Recommendation: merge if CI is green. Optionally let Dependabot rebase or supersede to 0.2.191, which carries the two fixes, though neither matters for `jr`'s targets.

### Advisories
- No RustSec directory exists for `libc` (advisory-db contents API 404). No GHSA/OSV found (Perplexity).

**Verdict: CAUTION (low).** This is a CI-gated merge, not a blocker.

---

## PR #933 — `ossf/scorecard-action` v2.4.4 -> v2.5.0

### Tag dereference (api.github.com git refs/tags, annotated tags)
| Tag | ref object (type `tag`) | dereferenced commit | Tagger / date | Signature |
|-----|-------------------------|---------------------|---------------|-----------|
| v2.5.0 | `46dc3187a971a9febf3aeb7f94ccde489f7bb46a` | **`fa7117db83c52d787ae5a89f350999701505d78e`** | Stephen Augustus, 2026-10-12T02:40:10Z | SSH-signed, `verified: true` |
| v2.4.4 | `55891bbd73f2425e97637d96e306fc9d491d0b21` | `2d1146689b8cda280b9bc96326124645441f03bc` | Spencer Schrock, 2026-07-23T21:05:14Z | `verified: true` |

- The release was published 2026-10-12T02:54:09Z (not a pre-release).
- **PR #933 pins `ossf/scorecard-action@fa7117db83c52d787ae5a89f350999701505d78e # v2.5.0`, which matches the dereferenced commit.** The current pin `2d114668…` in `.github/workflows/scorecards.yml` matches v2.4.4.
- (`gh api` was not available in this environment because shell access is denied by policy. The same REST endpoints were fetched unauthenticated via WebFetch: `/repos/ossf/scorecard-action/git/ref/tags/v2.5.0` -> `/git/tags/46dc3187…`.)

### Changes (release notes v2.5.0, cross-checked against `action.yaml` at both commits)
- Bumps Scorecard to **v5.6.0**, the first release since Scorecard's hosted services moved to new infrastructure.
- Image built with Go 1.27.2 on a refreshed distroless base. The installer now writes `scorecard.yml` (still recognizes `scorecards.yml`).
- Result metadata version now matches the built Scorecard version (#1718).
- **#1709 "Remove leftover debug print":** `Options.Validate` ran `fmt.Println("EnvGithubAuthToken:", EnvGithubAuthToken, os.Getenv(EnvGithubAuthToken))`, which printed the **token value**. It had been present since 2022 (#335). In standard setups (`github.token`/`secrets.*`), Actions log masking shows `***`. No GHSA was published (Perplexity, and the repo advisory page shows none).
- `results_format` gains a new `intoto` option (#1702). Additive only.

### `action.yaml` diff (verified at both commit SHAs)
- Inputs are identical apart from the `results_format` description adding `intoto`. Same required inputs (`results_file`, `results_format`) and same defaults (`repo_token`, `publish_results: false`, `file_mode: archive`, `internal_publish_base_url: https://api.scorecard.dev`, `internal_default_token`).
- No top-level `outputs:` in either version.
- `runs.image`: `docker://ghcr.io/ossf/scorecard-action:v2.4.4` -> `docker://ghcr.io/ossf/scorecard-action:v2.5.0`.
- **No new permission requirements.** `jr`'s job already grants `security-events: write` and `id-token: write`, with `permissions: read-all` at top level. That is unchanged and sufficient for `publish_results: true` + SARIF upload.

### Residual / known issues
- **Pre-existing residual, not introduced by this PR:** the action's docker image is referenced by a **mutable tag** (`:v2.5.0`), not a digest. Pinning the action SHA does not pin the container image. Same posture as v2.4.4.
- Issues and PRs opened since release (through 2026-10-17) are routine bumps and docs/CI work (#1723–#1730). **No regression reports were found** in the first 8 of 12 search results. The remaining 4 were not read (truncation), so this is mildly inconclusive.

**Verdict: SAFE. Recommended**, since it removes a token print from the job log path.

---

## PR #934 — `taiki-e/install-action` v2.87.26 -> v2.87.28

### Tag SHAs (api.github.com git refs; all are **lightweight tags** pointing directly at commits, so no dereference is needed)
| Tag | commit SHA | Published |
|-----|-----------|-----------|
| v2.87.26 | `f7e5d7c961414b23f5b25b2da9294395d08513ad` | 2026-10-06T15:27Z |
| v2.87.27 | `ab6895351a88b908e96a4697860d4ffea5e57dbe` | 2026-10-09T21:04Z |
| **v2.87.28** | **`1168f6810a3cb30a3514bf5756a3b7f0422c6df8`** | 2026-10-12T06:11Z |
| v2.87.29 | `8cca0918f8471c33515202b73f56ab27f2bed283` | 2026-10-16T16:10Z |

- **PR #934 pins `1168f6810a3cb30a3514bf5756a3b7f0422c6df8 # v2.87.28` in 4 places** (3 in `ci.yml`, 1 in `mutants-nightly.yml`). This matches the tag.

### Changes (GitHub release bodies)
- **v2.87.27:** manifest updates for vacuum 0.32.0, uv 0.12.24, typos 1.51.1, tombi 1.7.3, syft 1.54.1, release-plz 0.3.170, mise 2026.10.4, kingfisher 2.11.1, hyperfine 2.0.0, dprint 0.61.1, cargo-nextest 0.9.148, cargo-neat 0.6.0, cargo-binstall 1.25.2.
- **v2.87.28:** dprint 0.62.0, vacuum 0.33.0, uv 0.13.0, tombi 1.8.1, release-plz 0.3.171, rclone 1.75.2, mise 2026.10.7, cargo-binstall 1.25.3.
- **v2.87.29 (not in PR):** zizmor 1.31.0, wasmtime 49.0.3, uv 0.13.1, trivy 0.76.0, osv-scanner 2.7.0, just 1.59.0, cargo-crap 0.8.0, and others. Also manifest-only.
- None of these releases touch `cargo-llvm-cov` or `cargo-mutants`, the only tools `jr` installs through this action. `cargo-mutants` stays explicitly pinned at `@27.1.0`, and `cargo-llvm-cov` is unpinned (resolves to the manifest's latest, which is unchanged by these releases per the notes). No input/behavior changes are listed.

### Discrepancy to flag
- The **local `develop` checkout** used for this research pins `taiki-e/install-action@94c31af3204a9f15ab40b35ad084410b905bbc73 # v2.87.17` (verified as the v2.87.17 commit). **PR #934's diff shows a base of v2.87.26.** The likely cause is that the local `develop` is behind `origin/develop`, with an earlier install-action bump merged upstream since the local snapshot. I could not confirm this without shell/git access. The orchestrator should verify that `origin/develop` pins v2.87.26 (`f7e5d7c9…`) before merging. Otherwise the PR's base is stale or conflicting.

### Advisories
- The repo's security-advisories page shows zero published advisories. No GHSA/OSV for the v2.87.x line (Perplexity).

**Verdict: SAFE**, conditional on the base-version check above.

---

## RustSec / GHSA sweep (consolidated)

| Item | RustSec | GHSA/OSV | Notes |
|------|---------|----------|-------|
| dirs 6.0.0 / 7.0.0, dirs-sys 0.5.0 | RUSTSEC-2020-0053 only (withdrawn "unmaintained") | none found | — |
| toml 1.1.6–1.1.8, toml_parser 1.1.3–1.1.5 | no crate dir | none found | toml_parser #1175 unsoundness fixed in 1.1.5; no advisory issued; unreachable via `toml` |
| libc 0.2.189–0.2.191 | no crate dir | none found | functional regressions only (see #932) |
| ossf/scorecard-action v2.4.4 / v2.5.0 | n/a | none published | v2.4.4 token debug print (masked in std setups); removed in v2.5.0 |
| taiki-e/install-action v2.87.x | n/a | none published | — |

## Open questions
1. **#934:** confirm that `origin/develop` pins install-action v2.87.26 (the local checkout shows v2.87.17).
2. **#932:** whether any transitive dependency needs `libc::siginfo_t: Send + Sync` on Linux (libc#5624, still open). CI answers this. Consider taking 0.2.191 instead.
3. **#930:** Codeberg issue tracker for `dirs` 7.0.0 was not fetched directly. "No regressions" relies on Perplexity synthesis.
4. **#933:** scorecard-action's container image is tag-referenced (`ghcr.io/ossf/scorecard-action:v2.5.0`), not digest-pinned. This is a pre-existing supply-chain residual, unchanged by this PR.

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Consolidated RustSec/GHSA/OSV advisory + yank + regression sweep across all five items |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 1 | libc 0.2.190 regression reports (found tokio#8594, rust-lang/rust#163732, libc#5598) |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | Not needed; questions were version-diff/registry, answered from primary sources |
| Tavily | 0 | Not available in this session; WebFetch of primary APIs used for cross-validation |
| WebFetch | ~45 | crates.io API (versions, deps, checksums for dirs/dirs-sys/toml/toml_parser/toml_writer/toml_datetime/serde_spanned/libc); docs.rs crate source (dirs 6.0.0/7.0.0 README, lib.rs, win.rs, mac.rs, lin.rs, Cargo.toml.orig); raw CHANGELOGs (toml, toml_parser, libc); GitHub REST (dirs-rs commits; toml-rs compare + issue #1242; libc issue search + #5624; scorecard-action releases, refs, tag objects, PR #1709, action.yaml at both SHAs, issue search; install-action releases + refs; rustsec advisory-db contents; Zious11/jira-cli PR #930–#934 files) |
| WebSearch | 0 | — |
| Repo Read/Grep | 6 | `dirs::`/`toml::`/`libc::` usage, Cargo.toml/Cargo.lock versions, workflow action pins |
| Training data | 1 area | General background only (rustup/semver conventions). All version numbers, dates, SHAs, and behaviors were verified from fetched sources |

**Total MCP tool calls:** 2 (1 `perplexity_research`, 1 `perplexity_search`)
**Training data reliance:** low. Every version, date, checksum, and SHA came from registry or GitHub API responses. Behavioral claims for `dirs` were verified against crate source on docs.rs. Unauthenticated GitHub API was used in place of `gh api` because shell access is denied for this agent.
