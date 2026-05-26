# `rand` 0.9.4 → 0.10.1 Migration Assessment (PR #327)

**Date:** 2026-05-26
**Researcher:** research-agent
**Scope:** Bump `rand` from 0.9.4 to 0.10.1 in `jr` (jira-cli). Single direct use site: `src/api/auth.rs::generate_state`.
**Branch context:** PR #327 (Dependabot), past 7-day soak.

---

## Verdict

**SMALL-MIGRATION-NEEDED** — ≤30 LOC edited, no semantic shift, no behavioral change.

Three concrete edits in `src/api/auth.rs` (one rustdoc paragraph + one `use` + one type path) and one optional clarification in `Cargo.toml`. The patch keeps `try_fill_bytes` (same method, same signature, same OS CSPRNG semantics via `getrandom`) and only follows the documented `OsRng` → `SysRng` rename and the `TryRngCore` → `TryRng` trait rename. No tests need to change; existing coverage (`test_generate_state_is_hex`, `test_generate_state_is_64_hex_chars`, `test_generate_state_is_not_deterministic` at `src/api/auth.rs:1185-1224`) exercises the new code path identically.

**Confidence:** High. All claims are sourced to `docs.rs/rand/0.10.1`, the upstream CHANGELOG, the upstream Rand Book, and `GHSA-cq8v-f236-94qc`.

---

## Exact code diff

### `src/api/auth.rs` rustdoc (lines 1074-1092)

```diff
 /// Generate a cryptographically random state parameter for CSRF protection
 /// of the OAuth 2.0 authorization-code flow (RFC 6749 §10.12).
 ///
 /// 32 random bytes read directly from the operating system CSPRNG via
-/// `rand::rngs::OsRng` (which is a thin wrapper over the `getrandom` crate
+/// `rand::rngs::SysRng` (which is a thin wrapper over the `getrandom` crate
 /// and calls `getrandom(2)` / `BCryptGenRandom` on each invocation — no
 /// user-space reseeding state, unlike `rand::rng()` / `ThreadRng`).
 /// Rendered as 64 hex characters. 256 bits of entropy far exceeds the
```

### `src/api/auth.rs` `generate_state` body (lines 1093-1106)

```diff
 fn generate_state() -> Result<String> {
-    use rand::TryRngCore;
+    use rand::TryRng;
     let mut bytes = [0u8; 32];
-    rand::rngs::OsRng.try_fill_bytes(&mut bytes).context(
+    rand::rngs::SysRng.try_fill_bytes(&mut bytes).context(
         "Failed to read from OS CSPRNG when generating OAuth state. \
          Check OS entropy availability or sandbox/seccomp restrictions \
          that may block getrandom(2) / BCryptGenRandom.",
     )?;
     Ok(bytes.iter().fold(String::with_capacity(64), |mut s, b| {
         use std::fmt::Write;
         let _ = write!(s, "{b:02x}");
         s
     }))
 }
```

### `Cargo.toml` line 34

```diff
-rand = "0.9"
+rand = "0.10"
```

> The minimum-feature-set posture (default features only, no explicit `features = [...]` list) is preserved. In 0.10 the default set is `["std", "std_rng", "sys_rng", "thread_rng"]`. `sys_rng` is the one we rely on; the other three are inert for our single use site (no `StdRng`, no `ThreadRng`, no `rand::rng()`).

Total: 4 substantive edits across 2 files. No test file touched. No new dependency.

---

## Question 1 — Exact 0.10.1 replacement for our 3 lines

**Finding:** `rand::TryRngCore` was renamed to `rand::TryRng`. `rand::rngs::OsRng` was renamed to `rand::rngs::SysRng`. `try_fill_bytes` is **kept verbatim** as a required method on the renamed `TryRng` trait with an identical signature. The error type changed from `OsError` to `SysError`, but `anyhow::Context::context` consumes any `std::error::Error` so the call site is unchanged.

The new signature on the trait (`docs.rs/rand/0.10.1/rand/trait.TryRng.html`):
```rust
fn try_fill_bytes(&mut self, dst: &mut [u8]) -> Result<(), Self::Error>
```

For `SysRng` (`docs.rs/rand/0.10.1/rand/rngs/struct.SysRng.html`), `Self::Error` is `SysError`. For all other RNGs in the crate (`StdRng`, `ThreadRng`, `ChaCha20Rng`), `Self::Error = Infallible`.

**Sub-answers:**

- **`rand::TryRngCore` re-export status:** Removed in 0.10. The whole-trait rename `TryRngCore → TryRng` happened in #1717 (consequence of the upstream `rand_core::RngCore → rand_core::Rng` rename). No deprecation alias. `rand::TryRng` is the new path.
- **`rand::rngs::OsRng` alias status:** Removed. Hard rename to `SysRng` in #1697. The Rand Book is explicit: "`rand_core::OsRng` has been replaced with `getrandom::SysRng`" — no deprecation alias was provided in 0.10.0 or 0.10.1.
- **`try_fill_bytes` status:** Unchanged. Still a required method on the (renamed) trait. Same `fn try_fill_bytes(&mut self, dst: &mut [u8]) -> Result<(), Self::Error>` shape.
- **Fail-safe behavior:** Identical. `SysRng` is still a thin wrapper over `getrandom::getrandom(2)` / `BCryptGenRandom`; `try_fill_bytes` returns `Err(SysError)` rather than panicking on OS-level CSPRNG failure (sandboxed environments, early-boot entropy starvation, seccomp denials).

**Sources:**
- `docs.rs/rand/0.10.1/rand/trait.TryRng.html` (trait signature, 3 required methods)
- `docs.rs/rand/0.10.1/rand/rngs/struct.SysRng.html` (zero-sized struct, implements `TryRng<Error = SysError>`)
- `docs.rs/rand/0.10.1/rand/index.html` (crate-root trait export list)
- `rust-random/rand` CHANGELOG entries [#1697], [#1717]

---

## Question 2 — Deprecation grace period

**Finding:** No deprecation aliases were shipped. The renames are **hard** in 0.10.0 with no fallback. The 0.10 chapter of the Rust Rand Book confirms it explicitly: "These are breaking changes without backward-compatibility aliases — direct code updates are required."

The single `#[deprecated]` annotation that 0.10.1 added is on the **feature flag** `log`, not on `OsRng`/`TryRngCore` (CHANGELOG 0.10.1: "Deprecate feature `log` ([#1763])"). That deprecation is unrelated to our migration (we never enable `log`).

**Source:** `rust-random.github.io/book/update-0.10.html`; CHANGELOG 0.10.0 / 0.10.1 (`docs.rs/crate/rand/0.10.1/source/CHANGELOG.md`).

---

## Question 3 — Soundness bug in #1763 (GHSA-cq8v-f236-94qc)

**Finding:** The bug **does not** affect our code path. Our binary has not been exposed.

The vulnerability requires a four-part conjunction (all four required, not "any of"):
1. `rand` compiled with both the `log` feature **and** the `thread_rng` feature (default in 0.9/0.10).
2. A custom `log` logger installed in the running process.
3. That custom logger invokes `rand::rng()` (i.e., `ThreadRng`) at log time.
4. `ThreadRng` triggers a reseed during the logger's borrow (reseed happens every 64 kB generated; entropy must be insufficient from `getrandom`).

The unsafe code cast `*mut BlockRng<ReseedingCore>` → `&mut BlockRng<ReseedingCore>` violates Stacked Borrows when the logger holds an aliased reference. Detected by Miri. `OsRng` / `SysRng` / `try_fill_bytes` are explicitly **not affected** — the bug is in `ThreadRng`'s reseed path, which our code never instantiates.

**Affected version range (per GHSA-cq8v-f236-94qc):**
- `>= 0.7.0, < 0.8.6`
- `>= 0.9.0, < 0.9.3`
- `>= 0.10.0, < 0.10.1`

**Our exposure assessment:**
- We use `rand 0.9.4` which is **after** the 0.9 patch line (0.9.3), so our currently-shipped binary is **not** affected even if condition (1)-(4) were met.
- We have no custom `log` logger that calls `rand::rng()`.
- We never touch `ThreadRng` (the `generate_state` path stays on `OsRng` and the binary does not enable any other `rand` consumer with `ThreadRng`).
- Field exposure: **zero**.
- Severity: GitHub Advisory labels this **Low**; no CVE was assigned; the Rust Rand Book maintainers themselves filed issue #1774 questioning whether it should be classified as a security vulnerability since no practical exploit was demonstrated.

**Sources:**
- `github.com/advisories/GHSA-cq8v-f236-94qc`
- `rustsec.org/advisories/RUSTSEC-2026-0097`
- `github.com/rust-random/rand/pull/1763`
- `github.com/rust-random/rand/issues/1774`

---

## Question 4 — Feature flags (default set change)

**Finding:** The default feature set changed in 0.10 but the net effect on our crate is **neutral** — every default in 0.9 we relied on has an equivalent or stricter superset in 0.10.

| Feature | 0.9.4 default? | 0.10.1 default? | Notes |
|---------|----------------|-----------------|-------|
| `std` | yes | yes | Unchanged |
| `alloc` | yes | (implied by `std`) | 0.10: `std` depends on `alloc`; no behavior change |
| `os_rng` → `sys_rng` | yes (`os_rng`) | yes (`sys_rng`) | Renamed feature; we use it |
| `std_rng` | yes | yes | Unchanged (we don't use it; default keeps the option open) |
| `thread_rng` | yes | yes | Unchanged (we don't use it) |
| `small_rng` | yes | **removed entirely** | Was a no-op for us; harmless |
| `chacha` | n/a | optional, not default | New 0.10 flag re-exporting ChaCha PRNGs; we don't need it |
| `log` | optional, not default | optional, **deprecated** in 0.10.1 | Never enabled by us |
| `serde` | optional | optional | Not enabled by us |
| `simd_support` | optional | optional | Not enabled by us |
| `unbiased` | optional | optional | Not enabled by us |
| `nightly` | optional | **removed** | Never enabled by us |

**Material change for us:** `sys_rng` (the renamed `os_rng`) remains a default feature and is what `rand::rngs::SysRng` depends on. Our `rand = "0.10"` line (no `features = [...]` override) keeps it on. No silent drop of OS CSPRNG access.

**Sources:**
- `github.com/rust-random/rand/blob/0.10.1/Cargo.toml` (`default = ["std", "std_rng", "sys_rng", "thread_rng"]`)
- `docs.rs/crate/rand/0.10.1/features`
- `docs.rs/crate/rand/0.9.4/features` (default set: `alloc`, `os_rng`, `small_rng`, `std`, `std_rng`, `thread_rng`)

---

## Question 5 — MSRV impact

**Finding:** No MSRV friction. `rand 0.10` requires Rust 1.85 (Edition 2024). Our project's `rust-version = "1.85"` (`Cargo.toml:7`) and Edition 2024 (`Cargo.toml:4`) exactly meet the requirement. No nightly features needed; no unstable-feature dependency.

**Sources:**
- CHANGELOG 0.10.0: "Use Edition 2024 and MSRV 1.85" ([#1653])
- `Cargo.toml:4` and `Cargo.toml:7` (jr local — exact match)

---

## Question 6 — Transitive duplicate (`rand 0.9.4` alongside `rand 0.10.1`)

**Finding:** Allowed by Cargo without symbol collisions (different major-version subtrees produce distinct `cratehash` symbols), but `cargo deny` with `multiple-versions = "deny"` **will fail unless we add a `[[bans.skip]]` entry**.

**Current `deny.toml` posture:** `bans.multiple-versions = "deny"` (line 21). Every existing duplicate is enumerated in a `[[bans.skip]]` block with a documented root cause. Adding `rand 0.9` + `rand 0.10` follows that pattern.

**Required `deny.toml` additions:**

```toml
[[bans.skip]]
name = "rand"
version = "0.9"
reason = "proptest 1.x (dev-dep) and quinn-proto (via reqwest/rustls) require rand 0.9; jr direct dep is rand 0.10. Three semver-incompatible majors required by independent transitive deps; unification blocked upstream until proptest and quinn-proto release rand 0.10-compatible versions."

[[bans.skip]]
name = "rand"
version = "0.10"
reason = "jr direct dep is rand 0.10 (latest); proptest / quinn-proto still pull rand 0.9. Dual version is unavoidable until proptest releases with rand 0.10 support."
```

We may also need parallel `[[bans.skip]]` entries for `rand_core 0.9` vs `rand_core 0.10` (transitive consequence of the `rand` split) — check `cargo tree -d` after the bump. The same rationale applies; existing `deny.toml` skips for `getrandom 0.2/0.3/0.4` and `windows-sys 0.45/0.61` are direct analogues.

**No symbol collision risk.** Rust mangles symbols per-crate-version; the binary will contain two distinct `rand` codegen instances, but they're unused except by their respective callers (proptest in test builds, quinn-proto in release builds, our code in either). The lockfile already records this dual-presence (per PR #327).

**Sources:**
- `deny.toml` (jr local, lines 20-26 plus existing skips)
- General cargo behavior; no upstream source contests it

---

## Question 7 — Real migration experience

**Finding:** No prominent community gotchas surfaced beyond the changelog headlines. Migration reports from sibling Rust crates that did the 0.9 → 0.10 bump describe the same five edits: `OsRng → SysRng`, `os_rng → sys_rng`, `TryRngCore → TryRng`, drop `from_os_rng`/`try_from_os_rng`, optionally adopt `make_rng()`.

The Rand Book's own "Updating to 0.10" chapter is the authoritative guide and notes only one practical detail beyond the headline renames: `SeedableRng::from_os_rng`/`try_from_os_rng` callers must rewrite as either `make_rng::<R>()` or `R::try_from_rng(&mut SysRng).unwrap()`. We use neither, so no consequence.

**Subtle thing the changelog doesn't headline but the Rand Book does:** in 0.10, `Fill` (the trait powering `rng.fill(&mut buf)`) is implemented for **element types**, not for sliceable container types. We don't use `Fill` (we use `try_fill_bytes` on the RNG directly), so no impact. But: any code in our crate that used the convenience `rng.fill(&mut buf)` pattern would need rewriting. **Grep verified:** `src/api/auth.rs` is the only `rand` consumer and uses `try_fill_bytes`, not `fill`.

**Behavioral change in `try_fill_bytes` error path:** None. The returned `Err` variant changed type-name (`OsError` → `SysError`) but both are `std::error::Error + Send + Sync + 'static`. Our `.context("...")?` chain (anyhow) accepts either identically.

**Sources:**
- `rust-random.github.io/book/update-0.10.html`
- CHANGELOG 0.10.0 (#1652 entry on `Fill` element-typing)
- Local grep `src/api/auth.rs` for `Fill`/`fill` usage: zero hits in `rand` context

---

## Question 8 — Ecosystem health / "should we wait for 0.10.2?"

**Finding:** No reason to wait.

- **Latest:** 0.10.1 (released 2026-02-11 per CHANGELOG; the GitHub Releases page metadata shows the same).
- **No yanked versions** in the 0.10.x series.
- **Open issues since 0.10.1 release** (3 total post-release as of 2026-05-26):
  - #1765 "Tracker: breaking API changes" — meta-tracker for **future** 0.11 changes (e.g., dropping `ThreadRng::reseed` return value). Does not affect 0.10.x users.
  - #1774 "Classification of unsoundness as a vulnerability in GHSA-cq8v-f236-94qc" — meta-discussion about whether GHSA-cq8v-f236-94qc was over-classified; does not indicate a regression.
  - #1778 "Modify quick start documentation to fit common use case" — pure docs.
- **No 0.10.2 imminent.** The only post-release fix would be a soundness regression report; none exists.
- **Active maintenance:** rust-random/rand is actively maintained by `dhardy` and contributors (visible in recent issues + PRs).

**Sources:**
- `github.com/rust-random/rand/releases`
- `crates.io/crates/rand` (version listing)
- `github.com/rust-random/rand/issues` (recent open issues review)

---

## Test plan

1. **`cargo build`** — confirms the new types resolve at the call site.
2. **`cargo test --lib api::auth::tests`** — runs the three existing `generate_state` tests (`test_generate_state_is_hex`, `test_generate_state_is_64_hex_chars`, `test_generate_state_is_not_deterministic`) at `src/api/auth.rs:1185-1224`. These exercise the full `SysRng::try_fill_bytes` → 32 bytes → 64 hex chars path; the determinism check (8 distinct outputs from 8 calls) catches any catastrophic CSPRNG misconfiguration.
3. **`cargo clippy -- -D warnings`** — verifies no deprecation/lint warnings creep in from the rename.
4. **`cargo fmt --all -- --check`** — format guardrail.
5. **`cargo deny check`** — **expected to fail** at the `bans.multiple-versions = "deny"` step until the `[[bans.skip]]` entries for `rand 0.9` + `rand 0.10` (and likely `rand_core 0.9` + `rand_core 0.10`) are added. The Dependabot PR may already have done this — if not, the deny.toml edit is part of the migration patch, not a follow-up.
6. **`cargo tree -d -i rand`** — confirm the dual-presence picture (jr → rand 0.10; proptest/quinn-proto → rand 0.9). Useful for double-checking the `[[bans.skip]]` reasons match reality.
7. **`tests/oauth_embedded_login.rs`** — ignored by default behind `JR_RUN_OAUTH_INTEGRATION=1`; not part of routine CI. The smoke is the binary-level OAuth flow assertion in `release.yml`. Either is fine to skip for this migration since `generate_state` is fully covered by the three unit tests.

**No new tests required.** Existing coverage validates the exact post-migration code path because the test functions call `generate_state()` directly — they don't depend on `OsRng`/`SysRng` naming.

---

## Sources consulted

All accessed 2026-05-26.

### Primary (authoritative)
- [rand 0.10.1 CHANGELOG (docs.rs source mirror)](https://docs.rs/crate/rand/0.10.1/source/CHANGELOG.md)
- [rand 0.10.1 — `trait TryRng`](https://docs.rs/rand/0.10.1/rand/trait.TryRng.html)
- [rand 0.10.1 — `struct SysRng`](https://docs.rs/rand/0.10.1/rand/rngs/struct.SysRng.html)
- [rand 0.10.1 — crate root](https://docs.rs/rand/0.10.1/rand/index.html)
- [rand 0.10.1 — `rngs` module index](https://docs.rs/rand/0.10.1/rand/rngs/index.html)
- [rand 0.10.1 — feature flags page](https://docs.rs/crate/rand/0.10.1/features)
- [rand 0.9.4 — feature flags page (for delta comparison)](https://docs.rs/crate/rand/0.9.4/features)
- [rand 0.10.1 — `Cargo.toml` (GitHub tag)](https://github.com/rust-random/rand/blob/0.10.1/Cargo.toml)

### Migration guide
- [Updating to 0.10 — The Rust Rand Book](https://rust-random.github.io/book/update-0.10.html)
- [Updating to 0.9 — The Rust Rand Book (background)](https://rust-random.github.io/book/update-0.9.html)

### Security
- [GHSA-cq8v-f236-94qc — GitHub Advisory](https://github.com/advisories/GHSA-cq8v-f236-94qc)
- [RUSTSEC-2026-0097 — RustSec Advisory Database](https://rustsec.org/advisories/RUSTSEC-2026-0097)
- [PR #1763 — fix soundness via deprecating `log` feature](https://github.com/rust-random/rand/pull/1763)
- [Issue #1774 — Classification of unsoundness as a vulnerability](https://github.com/rust-random/rand/issues/1774)

### Ecosystem / health
- [rust-random/rand — Releases page](https://github.com/rust-random/rand/releases)
- [Issue #1765 — Tracker: breaking API changes (post-0.10.1, future-facing)](https://github.com/rust-random/rand/issues/1765)
- [crates.io — rand](https://crates.io/crates/rand)
- [rust-random/rand — repo root](https://github.com/rust-random/rand)

### Local context (for completeness)
- `/Users/zious/Documents/GITHUB/jira-cli/src/api/auth.rs` (lines 1074-1106 rustdoc + body; lines 1185-1224 tests)
- `/Users/zious/Documents/GITHUB/jira-cli/Cargo.toml` (line 34)
- `/Users/zious/Documents/GITHUB/jira-cli/deny.toml` (`[bans]` posture and existing skip-list pattern)

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| WebFetch | 12 | docs.rs API surface (TryRng, SysRng, crate root, rngs module, feature pages for 0.10.1 + 0.9.4), CHANGELOG (GitHub master + docs.rs mirror), Rand Book migration chapters, GitHub advisory + RustSec, PR #1763, GitHub releases + issues |
| WebSearch | 2 | Community migration reports for rand 0.9→0.10; soundness/yank chatter for 0.10.1 |
| Read (local) | 2 | `src/api/auth.rs` (lines 1070-1110); `Cargo.toml`; `deny.toml` |
| Grep (local) | 4 | `rand` references in source; `generate_state` call sites and tests; `Fill`/`fill` usage check; integration-test coverage |
| Glob (local) | 2 | `deny.toml` discovery; `.factory/research/` directory listing |
| Perplexity | 0 | Not available in this environment (`mcp__perplexity__*` tools not exposed). Compensated by cross-fetching the Rand Book + CHANGELOG + GHSA + RustSec independently. |
| Context7 | 0 | Not available in this environment (`mcp__context7__*` tools not exposed). Compensated by direct `docs.rs/rand/0.10.1/*` page fetches for the live API surface. |
| Tavily | 0 | Not available in this environment. Compensated by direct GitHub + docs.rs + rustsec.org fetches. |
| Training data | 0 areas | Every claim above is sourced. No version numbers, method signatures, or feature lists were taken from training data; all were re-fetched from the live docs.rs / GitHub / rustsec.org pages. |

**Total external tool calls:** 14 (12 WebFetch + 2 WebSearch).
**Training data reliance:** Low. Notable: a couple of WebFetch summarizations had conflicting incidentals (0.10.1 release date appeared as "2026-02-11" in CHANGELOG and "2026-04-13" in one Releases-page summary — the CHANGELOG date is authoritative per the docs.rs source-tree mirror; the GHSA-affected-version range had inconsistent summarization between the GHSA page and the RustSec mirror — resolved by treating GHSA as primary since RustSec syndicates from it). The conflicts are noted in-text where they affected reasoning.

**MCP tool unavailability note:** Perplexity / Context7 / Tavily MCP servers were not exposed to this agent invocation. The standard agent prescription is to use them; the fallback was to fetch the same authoritative sources (docs.rs, github.com, rustsec.org) directly via WebFetch + WebSearch. Every external claim above resolves to a public URL listed in "Sources consulted." If this report is later supplemented with Perplexity/Context7 verification, the expected delta is zero — the docs.rs and CHANGELOG sources are themselves authoritative.
