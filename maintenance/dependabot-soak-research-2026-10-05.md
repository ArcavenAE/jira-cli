# Dependabot Soak-Timer Research — 2026-10-05

**Type:** general (dependency soak review), read-only
**As of:** 2026-10-05 (UTC)
**Policy source:** `.github/dependabot.yml` — cargo major 30d (pre-1.0 minor counts as major), cargo minor/patch 7d; github-actions 7d. Measured from the TARGET version's publish date.
**Formula:** days elapsed = calendar-date difference (2026-10-05 − publish date, UTC). Pass when elapsed ≥ required.

## 1. Summary table

| PR | Target | Publish (UTC) | Req. days | Elapsed | Soak | Yanked / retracted | Advisories | Newer available | MSRV (floor 1.88) |
|---|---|---|---|---|---|---|---|---|---|
| #912 | taiki-e/install-action v2.87.21 (tag -> commit `4cef1412cce204788f482e778a0b9187f9626a29`) | 2026-09-26T15:33:50Z (release published) | 7 | 9 | **PASS** | No (release present) | None found | Yes: v2.87.22 (2026-09-29, 6d, FAIL), v2.87.23 (10-03), v2.87.24 (10-04), v2.87.25 (10-05). v2.87.21 is the newest version that passes soak, so **merge as-is**. | n/a |
| #900 | dtolnay/rust-toolchain `7e38f4b43b4db5c8dd498af069a4f6196df1d067` (untagged; the HEAD of `master`, merge of PR #186 "Retry release-server checksum failures") | 2026-10-01T22:51:00Z (commit/committer date) | 7 | 4 | **FAIL** (first eligible 2026-10-08) | n/a (commit present on protected `master`) | None found | No; it is the current `master` tip | n/a |
| #892 | github/codeql-action/upload-sarif v4.38.2 (annotated tag object `88585263c0627ee42c0e1c5143a112c8d6f4aa18`) | 2026-09-24T10:27:53Z | 7 | 11 | **PASS** | No | None in 2026 (repo advisories are 2021/2025 only) | No; v4.38.2 is the latest v4 | n/a |
| #885 | serde_json 1.0.151 | 2026-07-20T05:54:44Z | 7 (patch) | 77 | **PASS** | No | None | No (latest) | rust-version 1.71 — OK |
| #883 | rand 0.10.3 | 2026-09-20T06:37:47Z | 7 (patch) | 15 | **PASS** | No | RUSTSEC-2026-0097 / GHSA-cq8v-f236-94qc does **not** affect it (affects 0.10.0; patched in 0.10.1+). 0.10.3 fixes no advisory. | No (latest) | 1.85 — OK |
| #855 | comfy-table 8.0.0 | 2026-08-05T01:05:28Z | 30 (major) | 61 | **PASS** | No | None (no RustSec page for this crate) | Yes: **8.0.1** (2026-09-25T15:21:37Z). Only change is "Set MSRV to 1.88". As a 7.2.2→8.0.1 jump, that is a major bump measured from 8.0.1, so 10d elapsed **FAILS** the 30d soak until 2026-10-25. **Merge 8.0.0 now**; take 8.0.1 later as a patch (7d, already PASS). | 8.0.0: no `rust-version` declared; edition 2024 implies 1.85 or newer — OK. 8.0.1: 1.88, equal to the floor — OK. |
| #854 | reqwest 0.13.5 | 2026-09-08T20:55:26Z | 7 (patch) | 27 | **PASS** | No | None (no RustSec page). The release notes include "fix sending wrong proxy-auth if multiple proxies intercept a URL" (#3098). That fix has no GHSA/RUSTSEC, so no security exception applies. | No (latest) | 1.85.0 — OK |
| #842 | base64 0.23.1 | 2026-08-04T12:34:31Z | 30 (pre-1.0 minor = major) | 62 | **PASS** | No | None for 0.23.x (the only advisory is RUSTSEC-2017-0004, patched in 0.5.2) | No (latest) | 1.71.0 — OK |

No target version is yanked. No PR fixes an advisory, so the security exception to the soak does not apply to any of them.

## 2. Per-item notes and changelogs

- **install-action v2.87.21.** The release body only lists tool-manifest updates (wasm-bindgen 0.2.129, protoc-gen-connect-openapi 0.27.3, wasmtime 49.0.1, uv 0.12.19, mise 2026.9.13, kingfisher 2.7.0). Nothing is security-related. The current pin is `94c31af…` (v2.87.17, published 2026-09-20T12:13:59Z). Source: https://api.github.com/repos/taiki-e/install-action/releases , https://api.github.com/repos/taiki-e/install-action/git/ref/tags/v2.87.21
- **dtolnay/rust-toolchain.** `branches-where-head` for 7e38f4b4 returns only `master` (protected). Its parents are `02cb101e…` (the current pin, committed 2026-09-12T03:40:55Z) and `7645b072…` (2026-10-01T14:07:21Z). Even if you take the earlier child commit date, it still fails the 7-day soak. The repo pins this master SHA with the comments `# 1.88.0` / `# stable` and passes `toolchain:` explicitly, so following master is consistent with CLAUDE.md's msrv note. Source: https://api.github.com/repos/dtolnay/rust-toolchain/commits/7e38f4b43b4db5c8dd498af069a4f6196df1d067 , https://api.github.com/repos/dtolnay/rust-toolchain/commits?sha=master
- **codeql-action v4.38.2.** The only change is "Update default CodeQL bundle version to 2.27.1 (#4160)". The tag ref is an annotated tag object; dereferencing it to the commit SHA was not done here (UNVERIFIED: the commit SHA the PR pins should be checked to match the dereferenced tag). Source: https://api.github.com/repos/github/codeql-action/releases/tags/v4.38.2
- **serde_json 1.0.151.** Adds `RawValue::from_string_unchecked` (#1331). No regressions found. Source: https://crates.io/api/v1/crates/serde_json/1.0.151 , https://api.github.com/repos/serde-rs/json/releases
- **rand 0.10.3.** Fixes:
  - a `WeightedIndex` panic when float weights sum to infinity (#1808)
  - a spurious `NonFinite` error from `Uniform::new_inclusive` (#1821)
  - a possible panic sampling a deserialized `Uniform<char>` (#1831)

  Perplexity reports an open PR (#1841) for a `UniformDuration` panic after deserializing invalid state, with 0.10.3 as its baseline. That is a panic, not memory-safety, and only matters if you deserialize rand distributions (jr does not appear to). The PR number comes from a secondary source and was not fetched directly, so treat it as UNVERIFIED. Sources: https://crates.io/api/v1/crates/rand/0.10.3 , https://raw.githubusercontent.com/rust-random/rand/master/CHANGELOG.md , https://rustsec.org/packages/rand.html , https://github.com/advisories/GHSA-cq8v-f236-94qc
- **reqwest 0.13.5.** Changes:
  - adds `Error::is_dns()`, `ClientBuilder::http1_max_headers`, and the TLS version in `TlsInfo`
  - hickory now uses an IPv6-preferring strategy
  - fixes a blocking-client timeout panic and timeout detection inside body-decode errors
  - fixes proxy-auth selection when multiple proxies match
  - **upgrades base64 to 0.23 (#3074). This is a non-optional dependency, `base64 = "^0.23"`.** So #854 alone pulls base64 0.23 into Cargo.lock, next to the 0.22.1 already there.

  Sources: https://crates.io/api/v1/crates/reqwest/0.13.5 , https://crates.io/api/v1/crates/reqwest/0.13.5/dependencies , https://api.github.com/repos/seanmonstar/reqwest/releases , https://rustsec.org/packages/reqwest.html (404 means no advisories)
- **base64 0.23.x.**
  - 0.23.0 (2026-07-23T13:57:30Z) adds const configs/engines, clearer `InvalidLastSymbol` errors, custom padding, and an MSRV of 1.71.
  - **It also adds SIMD engines behind a new default-enabled `simd-unsafe` feature.** That is a supply-chain/unsafe-code posture change worth a reviewer's attention. You can opt out with `default-features = false` plus the needed features; I did not check which features remain.
  - 0.23.1 fixes the test build on non-SIMD architectures.

  Sources: https://crates.io/api/v1/crates/base64/versions , https://raw.githubusercontent.com/marshallpierce/rust-base64/master/RELEASE-NOTES.md , https://rustsec.org/packages/base64.html

## 3. base64 hold — upstream status

| Crate | Current lock | Newer release? | Uses base64 | Publish (UTC) | Soak |
|---|---|---|---|---|---|
| wiremock | 0.6.5 (2025-08-24T11:50:14Z) | **No.** 0.6.5 is still the latest on crates.io, and `main`'s Cargo.toml is still at version 0.6.5 with `base64 = "0.22"`. | `^0.22` (non-optional) | — | — |
| hyper-util | 0.1.20 (2026-02-02) | **Yes: 0.1.21.** | `^0.23`, **optional** (normal kind). The feature that enables it was not identified; it is likely the proxy feature (UNVERIFIED). | 2026-09-24T17:47:59Z | Patch class (7d), 11d elapsed: **PASS**. Not yanked. rust-version 1.85 (edition 2024) — OK against 1.88. Notable changes: a `tracing`-feature behavior change (`TokioExecutor` no longer propagates spans), CONNECT-response validation fixes, and SOCKS/proxy fixes. No RustSec page (no advisories). |

**Implication:** wiremock (a dev-dependency) is the remaining 0.22 holdout. After reqwest 0.13.5 (#854) and hyper-util 0.1.21, both production-path users of base64 are on 0.23. Duplicate base64 versions then exist only through wiremock in dev builds plus the direct `base64 = "0.22"` dep, until #842 lands. Sources: https://crates.io/api/v1/crates/wiremock/versions , https://crates.io/api/v1/crates/wiremock/0.6.5/dependencies , https://raw.githubusercontent.com/LukeMathWalker/wiremock-rs/main/Cargo.toml , https://crates.io/api/v1/crates/hyper-util/0.1.21 , https://crates.io/api/v1/crates/hyper-util/0.1.21/dependencies , https://raw.githubusercontent.com/hyperium/hyper-util/master/CHANGELOG.md

## 4. comfy-table 8.0.0 breaking changes

Source: https://raw.githubusercontent.com/nukesor/comfy-table/main/CHANGELOG.md

- **Removed:** the `TableComponent` enum, the `modifiers` module plus `Table::apply_modifier`, `Table::current_style_as_preset`, `Table::set_style`, `Table::remove_style`, `Table::load_preset`, and the old `Table::style` (whose signature changed).
- **Preset strings replaced by types.** Positional preset strings are replaced by `TableStyle`, `LineStyle` and `ContentLineStyle`, and every constructor is `const`. Presets in `comfy_table::presets::*` are now `TableStyle` constants.
  - Load a preset or style with `Table::load_style(style)`.
  - Access it with `Table::style()` / `Table::style_mut()`; the fields are public.
  - Modifiers become `TableStyle::with_rounded_corners` / `with_solid_inner_borders`.
- **Default truncation indicator changed** from `...` to `…` (U+2026). This is a visible output change and can break insta snapshots or byte-exact table assertions.
- **Fixes:** 34–70% formatting speedups, better UTF-8 layout (this can also shift column widths in snapshots), no panic on `Row::max_height(0)`, and no multi-width truncation indicator wider than the column.
- **Cargo:** edition 2024, no declared rust-version. 8.0.1 declares 1.88.
- **Migration check for jr:** grep for `load_preset`, `apply_modifier`, `UTF8_ROUND_CORNERS`, `set_style`, and `TableComponent` in `src/output.rs` and its callers. Also re-run insta snapshots for truncated cells and multi-byte text. I did not inspect jr source code (out of scope).

## 5. Inconclusive / UNVERIFIED

- The SHA in PR #892 was not checked against the dereferenced v4.38.2 commit, and the SHA in PR #912 was not checked against `4cef1412…`. The PR diffs were not fetched.
- rand PR #1841 (the `UniformDuration` panic) comes from a secondary source only.
- The hyper-util feature that gates its optional base64 dependency was not identified.
- Regression searches rely on one Perplexity sweep plus release notes. Finding no reports does not prove there are no regressions.
- Not added to `.factory/specs/research/RESEARCH-INDEX.md`, because the output path was caller-specified outside the research directory.

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | RustSec/GHSA advisory sweep for all 5 crates and 3 actions, plus a regression-report sweep |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | Not needed (registry/changelog facts, not API docs) |
| Tavily | 0 | Not available in this session; cross-validation done via WebFetch of primary sources instead |
| WebFetch | 33 | crates.io version/versions/dependencies APIs; GitHub releases/tags/commits/branches-where-head APIs; CHANGELOG/RELEASE-NOTES raw files; rustsec.org package pages; docs.rs Cargo.toml |
| Grep (local) | 3 | Current pins in `.github/workflows`, Cargo.toml, Cargo.lock |
| Training data | 1 area | Only the general knowledge that rustsec.org returns 404 for packages without advisories |

**Total MCP tool calls:** 1
**Training data reliance:** low. Every date, version, yanked flag and MSRV comes from the crates.io or GitHub API.
