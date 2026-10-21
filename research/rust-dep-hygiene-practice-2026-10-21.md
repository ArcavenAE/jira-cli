# Rust dependency-hygiene practice: dev-only duplicate crates, dormant deps, HTTP mocking

> **CORRECTION (orchestrator, 2026-10-21): this report read the stale local develop checkout (fb9d015c). On origin/develop (c72f8131, after PR #936) the duplicate DOES exist: base64 0.23.1 is used by jr/reqwest 0.13.5/hyper-util 0.1.21, and base64 0.22.1 comes only via the wiremock 0.6.5 dev-dependency. Verified via cargo tree on an origin/develop worktree, and `cargo deny check bans` passes (with and without --exclude-dev) with no base64 skip. Conclusions are unchanged.**

**Date:** 2026-10-21 · **Type:** general · **Status:** complete (some items flagged inconclusive)

**Question:** A project has a dormant but stable dev-dependency (`wiremock` 0.6.5, last release 2025-08-24) that pins an older version of a shared crate (`base64` 0.22, while 0.23 is used everywhere else). The result is a duplicate crate version in `Cargo.lock` that affects only tests. What does the Rust community normally do about this?

Each finding below is marked with how it was obtained. **[V]** means I fetched the primary source myself (raw file, official docs, or registry API). **[P]** means the finding came from a Perplexity synthesis with cited URLs that I did not re-fetch. **[TD]** means it comes from training data.

---

## 0. Project-specific facts (checked locally, 2026-10-21)

These change how the recommendation applies to `jr`, so they come first.

- `deny.toml` sets `multiple-versions = "deny"` and does **not** set `multiple-versions-include-dev`, so the default (`false`) applies. **[V]** `/Users/zious/Documents/GITHUB/jira-cli/deny.toml` lines 17-20.
- `Cargo.lock` today contains **only one** base64, `base64 0.22.1`. Four packages depend on it: `hyper-util`, `jr`, `reqwest`, and `wiremock`. **[V]** `Cargo.lock`. So the duplicate does not exist yet. It would only appear after `jr` (and/or `reqwest`/`hyper-util`) moves to 0.23.
- `reqwest` 0.13.5 (latest) depends on `base64 ^0.23`. **[P]** (deps.rs / docs.rs Cargo.toml). I did **not** verify which base64 version the latest `hyper-util` uses (**INCONCLUSIVE**).
- base64 0.23.0 was released 2026-07-23 and 0.23.1 on 2026-08-04. 0.22.1 dates from 2024-04-30. **[V]** crates.io API.
- **Implication:** once every *normal* (non-dev) path is on 0.23 and only `wiremock` still pulls 0.22, cargo-deny **will not report the duplicate at all** under the current config. A crate reached only through dev-dependency edges is excluded (see §1.1). Adding a `[[bans.skip]]` for `base64@0.22` in that state would itself trigger an `unmatched-skip`/`unnecessary-skip` warning. `deny.toml` already documents this exact behavior for `rand`. If some normal-edge crate such as `hyper-util` were still on 0.22, the duplicate *would* be flagged, but then it would not be dev-only.
- Scale of the mock suite: `MockServer::start` appears **1,533 times across 93 files** (`tests/` plus inline `src/` tests). **[V]** grep.

---

## 1. Duplicate crate versions

### 1.1 cargo-deny semantics (current version: **0.20.2**, not 0.19.x)

- **Version correction:** the latest cargo-deny on crates.io is **0.20.2**. 0.20.0 was released 2026-07-09. **[V]** crates.io API. The CHANGELOG shows **no changes** to `multiple-versions`, `multiple-versions-include-dev`, `skip`, `skip-tree`, or dev-dependency handling anywhere from 0.19.0 to 0.20.2. 0.20.0 added a new `bans.std-replacements` lint. 0.19.1 fixed `krates` graph pruning, which "may surface issues previously hidden". **[V]** [CHANGELOG.md](https://github.com/EmbarkStudios/cargo-deny/blob/main/CHANGELOG.md). The semantics below therefore hold for both 0.19.x and 0.20.x.
- **`multiple-versions`:** the default is `warn`. The docs say it "Prints a warning for each crate with duplicates, but does not fail the check." **[V]** [bans cfg docs](https://embarkstudios.github.io/cargo-deny/checks/bans/cfg.html)
- **`multiple-versions-include-dev`:** the default is **`false`**. The docs say: "If `true`, `dev-dependencies` are included when checking for multiple versions. By default this is false, and any crates that are only reached via dev dependency edges are ignored." They add: "this also means that `skip` and `skip` tree are not used, which may lead to warnings about unused configuration." **[V]** same page. This was introduced in **0.14.2 (2023-09-04, PR #557)**, which flipped dev-only crates out of duplicate detection by default. **[V]** CHANGELOG.
  - **Reading:** the cargo-deny maintainers have made it the *tool default* to treat dev-only duplicates as not worth flagging. This is the strongest primary-source signal for "dev-only duplicates are tolerated".
- **`skip`** ("temporarily ignore a crate during duplicate detection"). Specific version constraints are recommended, because "cargo-deny will emit warnings when any entry in the `skip` list no longer matches a crate in your graph." **[V]**
- **`skip-tree`:** like `skip`, but it also covers the crate's transitive dependencies down to `depth`. "A depth of `0` would be the same as specifying the crate in the `skip` field", and "by default, the `depth` is infinite." **[V]** The docs do not describe an unused-entry warning for `skip-tree`. In practice `skip-tree` is the blunter tool, suited to foundational crates that churn (see cargo-deny's own `windows-sys` entry below).
- **Tolerating:** `multiple-versions = "warn"` or `"allow"`. Several flagship projects do this (table below).

### 1.2 What large projects actually configure

| Project | File | `multiple-versions` | skip / skip-tree | Source |
|---|---|---|---|---|
| rust-lang/cargo | [deny.toml](https://github.com/rust-lang/cargo/blob/master/deny.toml) | `warn` | both lists present but empty | **[V]** |
| tokio-rs/tokio | [deny.toml](https://github.com/tokio-rs/tokio/blob/master/deny.toml) | `allow` | none | **[V]** |
| astral-sh/uv | [.cargo/deny.toml](https://github.com/astral-sh/uv/blob/main/.cargo/deny.toml) | `allow` | none. Comment: "Rust as a whole simply has too many split resolutions for us to enforce a single version per crate" | **[V]** |
| astral-sh/ruff | [.cargo/deny.toml](https://github.com/astral-sh/ruff/blob/main/.cargo/deny.toml) | `allow` | none. Comment: "Duplicate versions are common in the current dependency graph. Revisit this once enforcing a single version per crate is practical." | **[V]** |
| EmbarkStudios/cargo-deny | [deny.toml](https://github.com/EmbarkStudios/cargo-deny/blob/main/deny.toml) | `deny` | skip `getrandom@0.2.17` ("ring uses this old version"); skip-tree `windows-sys` | **[V]** |
| bytecodealliance/wasmtime | [deny.toml](https://github.com/bytecodealliance/wasmtime/blob/main/deny.toml) | `deny` | 7 skip-tree entries (e.g. `proptest` depth 20, `indexmap` depth 2) | **[P]** |
| bevyengine/bevy | [deny.toml](https://github.com/bevyengine/bevy/blob/main/deny.toml) | `warn`, with per-crate `deny-multiple-versions = true` on 6 crates | skip `bevy_math` | **[P]** |
| rustls/rustls | [deny.toml](https://github.com/rustls/rustls/blob/main/deny.toml) | not set (licenses only) | — | **[P]** |
| BurntSushi/ripgrep | none found | — | — | **[P]**, INCONCLUSIVE: absence not proven |
| denoland/deno | none found | — | — | **[P]**, INCONCLUSIVE: absence not proven |

None of the verified files sets `multiple-versions-include-dev = true`. **[V]** for cargo, cargo-deny, uv, ruff, and tokio. So none of them opts dev-only duplicates *into* enforcement.

**Takeaway:** among the most visible projects, `warn`/`allow` is more common than `deny`. Projects that do use `deny` (cargo-deny itself, wasmtime, and `jr`) pair it with documented, reasoned skips. Nobody in this sample treats a dev-only duplicate as a defect.

### 1.3 `[patch.crates-io]` git forks to dedupe

- Cargo documents `[patch.crates-io]` with a git source as the way to **test an upstream fix before it is released**. The patched crate must still satisfy the version requirements of the crates that depend on it. A patch cannot force a parent that requires `base64 0.22` to accept 0.23; the fork would need its own `Cargo.toml` changed. **[P]** [Cargo: Overriding dependencies](https://doc.rust-lang.org/cargo/reference/overriding-dependencies.html)
- `[patch]` is read only from the top-level workspace. It is not inherited by downstream dependents. Separately, a git-only *normal* dependency blocks `cargo publish`. **[P]** [specifying-dependencies](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html), [users.rust-lang.org thread](https://users.rust-lang.org/t/how-to-publish-a-crate-that-needs-fixes-to-dependencies/24764)
- `jr` is a binary crate, so the publish and inheritance concerns are weak. The real costs would be:
  - a git source in the dependency graph;
  - `cargo-deny`'s `[sources]` check, which would need `allow-git`;
  - supply-chain review of a fork;
  - fork maintenance, which ends only when upstream releases.
- **Community norm:** a patch is acceptable as a *temporary* bridge for a needed fix, ideally tied to an upstream PR. It is generally considered overkill and somewhat discouraged as a cosmetic dedupe of a dev-only duplicate. **[P]** synthesis. I found no maintainer post saying "never do this" (**partially inconclusive**).

---

## 2. Dormant dependencies

### 2.1 Unmaintained vs feature-complete; RustSec criteria

- **RustSec [HOWTO_UNMAINTAINED.md](https://github.com/rustsec/advisory-db/blob/main/HOWTO_UNMAINTAINED.md)** **[V]**:
  - *Explicit* unmaintained: the author has declared it unmaintained.
  - *Implicit* unmaintained: "the author is incommunicado for a prolonged period". This requires **both**:
    - a stale repo ("Inactivity over a period of 1 year or more is the preferred threshold"), **and**
    - documented unanswered contact: at least **270 days**, or **60 days** after a vulnerability notification.
  - The first step is always "ASK THE AUTHOR(S)", preferably in a public repo issue. If the author says the crate is maintained, RustSec takes their word over metrics.
  - **Time since the last release is not sufficient on its own.**
- **Applied to wiremock (as of 2026-10-21):**
  - It has been about 14 months since 0.6.5, and the repo is not archived. **[P]**
  - There are open community PRs from 2026, and I found no 2026 commits to `main`. **[P]**
  - **#176 "Update deadpool to 0.13.0"** was opened 2026-02-18. **[V]** It received a review/release ping on 2026-09-15. **[P]**
  - There is **no open PR bumping base64**. **[V]** [open PRs](https://github.com/LukeMathWalker/wiremock-rs/pulls), 9 open, newest #178 on 2026-10-13.
  - I found no RustSec advisory and no abandonment statement.
  - **It does not meet RustSec's unmaintained criteria.** "Dormant/slow-moving" is the accurate label.
- Community framing (users.rust-lang.org): "no updates in N months means dead" is a social perception, not a technical rule. A finished crate is not abandoned. **[P]** e.g. [Maintaining a crate](https://users.rust-lang.org/t/maintaining-a-crate/66181)

### 2.2 Upstream etiquette; forking and vendoring

- **Norm:** send a small, tested bump PR that explains the motivation. Give volunteer maintainers time, follow up politely once, and don't spam pings. Before treating silence as abandonment, ask publicly about maintenance status and/or offer to help maintain. **[P]** [Etiquette for taking over a repo/crate](https://users.rust-lang.org/t/etiquette-for-taking-over-a-repo-crate/40252), [r/rust etiquette thread](https://www.reddit.com/r/rust/comments/k8mcwm/etiquette_if_a_crate_seems_unmaintained_is_it/)
- **crates.io:** names are transferred only with the owner's consent. RFC 3646 removed crates.io-mediated transfers, so an unreachable owner means publishing a fork under a **new name**. **[P]** [crates.io policies](https://crates.io/policies), [RFC 3646](https://rust-lang.github.io/rfcs/3646-remove-crate-transfer-mediation-policy.html)
- **Fork/vendor triggers** in practice: a needed bug fix, a security issue, or blocking breakage. A cosmetic dev-only lockfile duplicate is not among them. Cargo recommends `[patch]`/path dependencies over editing `cargo vendor` output. **[P]** [cargo vendor](https://doc.rust-lang.org/cargo/commands/cargo-vendor.html)
- **Applied here:** the conventional move is to open a `base64 = "0.23"` bump PR on wiremock-rs, or add base64 to the existing #176 thread. The cost is low and it is the community-expected first step. Then tolerate the duplicate until a release ships. **[TD]/[P]** synthesis.

---

## 3. HTTP mocking landscape (crates.io API, fetched 2026-10-21) **[V]**

| Crate | All-time downloads | Recent (90d) | Latest | Released |
|---|---:|---:|---|---|
| **wiremock** | 91,999,844 | 28,331,153 | 0.6.5 | 2025-08-24 |
| **mockito** | 60,144,390 | 9,738,913 | 1.7.2 | 2026-02-02 |
| **httpmock** | 32,413,753 | 6,539,136 | 0.9.0 | **2026-10-20** (yesterday) |

- **Trend:** wiremock's recent downloads are about 3× mockito's and about 4× httpmock's. Despite its release dormancy it is clearly the de-facto standard by usage. A large share of those downloads is probably transitive dev-dependency CI churn **[TD]**.
- **Notable users** **[P]**:
  - wiremock: `uv`, `octocrab`, `reqwest-middleware`/`reqwest-retry`, `surrealdb` (dev-deps).
  - mockito: LaunchDarkly server SDK, Statsig SDK, `cynic`, `nu-command`.
  - httpmock: AWS `lambda_runtime`, `c2pa`, `async-stripe`, `goose`, Datadog `libdd-*` crates.
- **Guidance:**
  - *Zero To Production* (Luca Palmieri, wiremock's author) uses wiremock for its email client. **[P]** [lpalmieri.com post](https://www.lpalmieri.com/posts/how-to-write-a-rest-client-in-rust-with-reqwest-and-wiremock/)
  - wiremock's own README comparison table now lists all three as parallel-capable. httpmock is the only one with a standalone mode, and wiremock is async-only. **[P]** [README](https://github.com/LukeMathWalker/wiremock-rs)
  - mockito 1.x supports parallel tests and `Server::new_async()`, so older "mockito is sequential" claims are outdated. **[P]**
  - Reddit and users.rust-lang.org threads show all three in use, with no consensus against wiremock. **[P]**
- **httpmock 0.9.0** is a fresh release, so it is less proven and its API may still churn. The sibling report `wiremock-alternatives-2026-10-21.md` (being written by another agent) covers alternatives in depth.

---

## 4. Is migrating a large mock suite for dependency hygiene advisable?

- **Precedent found:** pinecone-rust-client [PR #19](https://github.com/pinecone-io/pinecone-rust-client/pull/19) (2024-07-01) migrated mockito → httpmock. The stated reason was Tokio problems after upgrading mockito, which is functional, not hygiene-driven. **[P]**
- httpmock 0.7.0 slimmed its own default dependency tree by making remote features opt-in. That is hygiene work inside one library, not a cross-library migration. **[P]**
- **Not found:** any PR or blog post where a Rust project migrated between mocking libraries *purely* to remove a duplicate transitive crate. Searches for mockito→wiremock and wiremock→httpmock migrations turned up nothing. **INCONCLUSIVE.** Absence of evidence is weak, but it is consistent with the community norm.
- **Assessment:** migrating 1,533 `MockServer::start` call sites across 93 files to fix a dev-only duplicate has no community precedent and is disproportionate. **[TD]/[P]** synthesis:
  - cargo-deny by default ignores this duplicate.
  - It has no effect on the shipped binary.
  - The upstream crate is the most-used option and is not "unmaintained" by RustSec's standard.
  - The rewrite would carry real regression risk across a suite this repo leans on for behavioral contracts.
- **Conditions that would change this:** an actual RustSec advisory on wiremock or one of its deps; incompatibility with a needed toolchain or dependency (e.g. hyper/http major bumps breaking compilation); or a confirmed maintainer statement of abandonment.

---

## Recommended decisions

1. **Tolerate the dev-only duplicate.** Keep `multiple-versions = "deny"` with `multiple-versions-include-dev` at its default `false`. Do **not** add a `base64@0.22` skip while it is dev-only, because it would be flagged as an unmatched/unnecessary skip. Optionally add a comment in `deny.toml` like the existing `rand` note.
2. **First verify the duplicate really is dev-only after the bump:** `cargo tree -i base64@0.22.1 -e normal` should be empty. `hyper-util` is unverified.
3. **Upstream:** open a focused `base64 = "0.23"` PR on wiremock-rs, or comment on #176. Make one polite follow-up later, without repeated pings.
4. **No `[patch.crates-io]` fork** for this. It is reserved for needed fixes, and would add a git source plus `[sources]` allowances.
5. **No migration** off wiremock unless a trigger from §4 happens.

## CI/CD integration patterns

- `cargo deny check bans` in CI already enforces this through `EmbarkStudios/cargo-deny-action` (pinned SHA, `v2`) in `.github/workflows/ci.yml`. cargo-deny's `unmatched-skip`/`unnecessary-skip` warnings act as an automatic signal for removing stale skips. **[V]**
- An optional advisory check would run `cargo tree -d -e normal,build` to list only shipped duplicates. This mirrors the cargo-deny default and is not needed while cargo-deny is in place. **[TD]**

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 3 | cargo-deny semantics plus large-project deny.toml survey; RustSec/dormancy/etiquette/wiremock activity; HTTP-mocking landscape and migration precedent |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 1 | Migration-precedent PR search (nothing relevant found) |
| Perplexity perplexity_ask | 1 | reqwest/hyper-util base64 version |
| Context7 | 0 | Not needed; questions were policy/ecosystem, not API |
| Tavily | 0 | Not available or needed; WebFetch used for primary-source verification |
| WebFetch | 13 | cargo-deny cfg docs and CHANGELOG; deny.toml for cargo, tokio, uv, ruff, cargo-deny; RustSec HOWTO_UNMAINTAINED; crates.io API (wiremock, httpmock, mockito, base64, cargo-deny); wiremock-rs open PRs |
| Local Read/Grep | 6 | Project `deny.toml`, `Cargo.lock`, CI workflow, mock-suite size |
| Training data | 3 areas | Download-mix interpretation; CI tree-check suggestion; proportionality judgment in §4 |

**Total MCP tool calls:** 5
**Training data reliance:** low. Every load-bearing fact (cargo-deny defaults and semantics, version and download numbers, RustSec thresholds, flagship deny.toml values, wiremock open PRs) was verified against primary sources. Items marked [P] rely on Perplexity's cited synthesis. Inconclusive items: the ripgrep/deno deny.toml absence, hyper-util's base64 version, and whether any purely hygiene-motivated mock-library migration exists.
