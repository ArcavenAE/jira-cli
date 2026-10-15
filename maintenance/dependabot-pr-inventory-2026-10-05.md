# Dependabot PR Inventory and In-Repo Impact — 2026-10-05

Read-only inventory of the 8 open Dependabot PRs on `Zious11/jira-cli`. Nothing was merged,
approved, commented on, labelled, or rebased. PR heads were inspected through temporary
`refs/tmp/pr-N` refs and one throwaway worktree under `/private/tmp/claude-501/`. Both were
removed afterwards. The main tree is still on `develop` at `fb9d015c`, and its untracked `.claude/`
files were left alone.

`develop` tip: `fb9d015c` (`chore(release): v0.8.0-dev.2 (#911)`).

## Summary Table

| PR | Ecosystem | Change | Created | Behind develop | Mergeable | CI Gate | Failing checks |
|----|-----------|--------|---------|----------------|-----------|---------|----------------|
| #912 | actions | taiki-e/install-action 2.87.17 -> 2.87.21 | 2026-10-05 | 0 | MERGEABLE (BLOCKED = review) | PASS | none |
| #900 | actions | dtolnay/rust-toolchain `02cb101e` -> `7e38f4b4` | 2026-10-02 | 10 | MERGEABLE (BLOCKED) | PASS | none |
| #892 | actions | github/codeql-action/upload-sarif 4.38.1 -> 4.38.2 | 2026-10-01 | 15 | MERGEABLE (BLOCKED) | FAIL | Clippy (ubuntu), Clippy (windows), CI Gate. The failures are stale-base and unrelated to this PR |
| #885 | cargo | serde_json 1.0.150 -> 1.0.151 | 2026-09-29 | 19 | MERGEABLE (BLOCKED) | PASS | none |
| #883 | cargo | rand 0.10.2 -> 0.10.3 | 2026-09-29 | 19 | MERGEABLE (BLOCKED) | PASS | none |
| #855 | cargo | comfy-table 7.2.2 -> 8.0.0 (MAJOR) | 2026-09-21 | 45 | MERGEABLE (BLOCKED) | FAIL | Clippy (ubuntu+windows), Coverage, MSRV, Test (macos/ubuntu/windows), CI Gate, all from a compile error |
| #854 | cargo | reqwest 0.13.4 -> 0.13.5 | 2026-09-21 | 44 | MERGEABLE (BLOCKED) | FAIL | Deny (licenses + vulnerabilities), CI Gate |
| #842 | cargo | base64 0.22.1 -> 0.23.1 | 2026-09-18 | 44 | MERGEABLE (BLOCKED) | FAIL | Deny (licenses + vulnerabilities), CI Gate |

- All base branches are `develop`.
- `mergeStateStatus` is `BLOCKED` for all of them. That reflects the code-owner-review requirement, not a conflict.
- `git merge-tree --write-tree origin/develop <pr-head>` merges cleanly (rc=0) for all 8 PRs.
- No pending checks on any PR.
- #854 and #842 each carry 2 commits: the bump, plus a Dependabot `Merge branch 'develop'` commit from 2026-09-21.

### #893 status
#893 (`taiki-e/install-action 2.87.17 -> 2.87.20`) was **CLOSED, not merged**, at 2026-10-05T13:56:33Z.
Dependabot superseded it with #912 (created 13:56:29Z). This continues the chain #879 -> #881 -> #884 -> #889 -> #893 -> #912. The last
taiki-e bump actually merged was #882 (2.87.13 -> 2.87.17, 2026-09-28).

---

## Complete Added/Changed Crate List (for the soak-timer check)

For each cargo PR, the full lockfile package set was computed from (name, version) pairs and compared two ways:
- the PR head against its merge base;
- `develop` against a simulated merge of develop and the PR (`git merge-tree`).

Both comparisons gave identical results for every PR.

| PR | Added / changed crates (name old -> new) |
|----|------------------------------------------|
| #885 | `serde_json 1.0.150 -> 1.0.151` (only change) |
| #883 | `rand 0.10.2 -> 0.10.3` (only change; jr's dep edge `rand 0.10.2` -> `rand 0.10.3`) |
| #855 | `comfy-table 7.2.2 -> 8.0.0` (only version change). Also `Cargo.toml`: `comfy-table = "=7.2.2"` -> `"=8.0.0"` |
| #854 | `reqwest 0.13.4 -> 0.13.5`; **ADDED** `base64 0.23.1` (alongside existing `base64 0.22.1`) |
| #842 | **ADDED** `base64 0.23.1` (alongside existing `base64 0.22.1`). Also `Cargo.toml`: `base64 = "0.22"` -> `"0.23"` |

Notes:
- #855 and #854 also show a `quinn-udp 0.5.14` edge change (`windows-sys 0.52.0` -> `0.60.2`) when diffed against their old merge base.
  `develop` already has that edge, so it is not a delta against current develop.
  No crate version was added for it, since `windows-sys 0.60.2` was already locked.
- #854 edge changes (no new versions): `reqwest` -> `base64 0.23.1`; `hyper-util 0.1.20`, `jr` and `wiremock 0.6.5` -> `base64 0.22.1`.
- #842 edge changes: `jr` -> `base64 0.23.1`; `hyper-util`, `reqwest 0.13.4` and `wiremock` stay on `base64 0.22.1`.
- Latest upstream versions seen on crates.io today, for the soak check's reference:
  - `comfy-table 8.0.1`. Released 2026-09-25 and only sets `rust-version = 1.88`; its `src/` is byte-identical to 8.0.0 (`diff -rq`).
  - `reqwest 0.13.5`
  - `hyper-util 0.1.21`. Published 2026-09-24T17:47:59Z.
  - `wiremock 0.6.5`

---

## Per-PR Detail

### #912 — taiki-e/install-action 2.87.17 -> 2.87.21
- Head `dependabot/github_actions/taiki-e/install-action-2.87.21`. Merge base equals the develop tip `fb9d015c`, so it is 0 behind.
- CI: all 24 checks pass, including CI Gate and dependency-review.
- Change: SHA `94c31af3204a9f15ab40b35ad084410b905bbc73` (`# v2.87.17`) -> `4cef1412cce204788f482e778a0b9187f9626a29` (`# v2.87.21`). Locations:
  - `.github/workflows/ci.yml:295`, job `coverage`
  - `.github/workflows/ci.yml:397`, job `mutants-plan`
  - `.github/workflows/ci.yml:523`, job `mutants` (shard matrix)
  - `.github/workflows/mutants-nightly.yml:64`
- Release notes (2.87.18–.21) only update the `@latest` tool manifests: wasm-bindgen, uv, mise, wasmtime, cargo-shear, cargo-nextest, and others.
- CI-gate relevance:
  - `ci.yml` is inside the six-file review scope.
  - `mutants-plan` and `mutants` feed `mutants-aggregate`, which is in `ci-gate.needs`. Their results are on the gate's decision path indirectly.
  - `coverage` is NOT in `ci-gate.needs` (`needs: [fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection, mutants-aggregate]`).
  - None of these `uses:` lines are in the `ci-gate` job itself. Its only `uses:` are `step-security/harden-runner` and `actions/checkout`.
- `tests/ci_gate_completeness.rs` pins only the step key SET `["uses","with"]` for the taiki-e step in the mutants shard (`PINNED_MUTANTS_SHARD_STEP_KEY_SETS`, comment "taiki-e/install-action (cargo-mutants@27.1.0)").
  No SHA or `uses:` value is pinned: the test file has no 40-hex `@sha` literals.
  The SHA swap does not change any key set, so no test update is needed.

### #900 — dtolnay/rust-toolchain `02cb101ec7c4…` -> `7e38f4b43b4d…`
- 10 commits behind (merge base `ce6be7ad`). CI is all green, but the run is from 2026-10-02 on the stale base.
- Upstream delta: rust-toolchain PR #186, "Retry release-server checksum failures" (commit `7645b07`), merged as `7e38f4b`. It adds install-retry robustness and nothing else.
- Change: SHA `02cb101ec7c40f2c49e1d9714d64511d8e1b74de` -> `7e38f4b43b4db5c8dd498af069a4f6196df1d067`. Locations:
  - `.github/workflows/backfill-release.yml:68` (`# stable`)
  - `.github/workflows/ci.yml:259`, job `msrv` (`# 1.88.0`). **`msrv` is in `ci-gate.needs`.**
  - `.github/workflows/ci.yml:291`, job `coverage` (`# stable`). Not in `ci-gate.needs`.
  - `.github/workflows/e2e-sweeper.yml:74`
  - `.github/workflows/e2e.yml:80`
  - `.github/workflows/release.yml:38`
  - `.github/workflows/sign-and-publish.yml:53`
- CI-gate relevance:
  - The `msrv` job is a `ci-gate.needs` member.
  - `tests/ci_gate_completeness.rs` finds the dtolnay step by the prefix `uses:` starts with `"dtolnay/rust-toolchain@"`.
  - It also pins the step key set `["uses","with"]` and the `with.toolchain` / `env.RUSTUP_TOOLCHAIN` values `"1.88.0"`.
  - It does NOT pin the SHA, so the SHA change does not touch any assertion.
  - The action at the new SHA must still declare/accept the `toolchain` input. Retry-only upstream change makes that very likely, and the green MSRV job on this PR confirms it.
- Pre-existing doc drift, not caused by this PR:
  - `tests/ci_gate_completeness.rs` (~line 3775, an assertion-failure message) still names the pinned SHA `6c977a6ca4077a0ceb28ffbe03f59d46e9ac8772`.
  - The CLAUDE.md msrv Gotcha also says `6c977a6c…`.
  - develop has been on `02cb101e` since #857 (merged 2026-09-21).
  - Prose only, no assertion, but worth correcting when this lands.

### #892 — github/codeql-action/upload-sarif 4.38.1 -> 4.38.2
- 15 commits behind (merge base `769365ab`).
- Change: `.github/workflows/scorecards.yml:83`, `1c5b675653bb5c22dbe9b12b556ec555138e09fd` (`# v4.38.1`) -> `2892aa5e19bbd11bc0cff5427e3b750a04d9e3c2` (`# v4.38.2`).
  The upstream change only bumps the default CodeQL bundle to 2.27.1.
- Not in `ci.yml`, not in the six-file scope, not on the ci-gate path.
- CI failure (run 36872706104, 2026-10-01): **Clippy ubuntu + windows** fail on `tests/e2e_live.rs:4936:57` and `:4944:26`.
  The lint is `clippy::needless_borrows_for_generic_args`, raised as an error by `-D warnings`, on `.map(&norm)` in the PR's base.
  - **Unrelated to the PR.** The lint is in code from its stale base.
  - That code was rewritten on develop by `cc19c2f9` (#894, 2026-10-01). `.map(&norm)` no longer appears in develop's `tests/e2e_live.rs`, and develop CI (PR #911) is green on Clippy.
  - A re-run on a merge with current develop should clear this. CI Gate failed only because the Clippy job failed.

### #885 — serde_json 1.0.150 -> 1.0.151
- 19 commits behind (merge base `204b1fb5`). CI: all pass.
- Lock: `serde_json 1.0.150 -> 1.0.151` (checksum `e8014e44…` -> `c841b55e…`). No Cargo.toml change (`serde_json = "1"`).
- In-repo use is pervasive: `src/output.rs::render_json` (`serde_json::to_string_pretty`), plus every `json!`/`Value` user in `src/` and `tests/`. This is patch-level and API-compatible.

### #883 — rand 0.10.2 -> 0.10.3
- 19 commits behind (merge base `204b1fb5`). CI: all pass.
- Lock: `rand 0.10.2 -> 0.10.3` (checksum `c7f5fa3a…` -> `65c9fb96…`). No Cargo.toml change (`rand = "0.10"`).
- Patch-level. No new transitive versions (`chacha20` and `getrandom 0.4.2` are unchanged).

### #855 — comfy-table 7.2.2 -> 8.0.0 (semver MAJOR, previously DEFERRED)
- 45 commits behind (merge base `8b4c797a`).
- Cargo.toml: `comfy-table = "=7.2.2"` -> `"=8.0.0"`. Dependabot kept the exact-pin convention from ADR-0025, but rewrote the version without touching the comment block above it, which still says "Pinned to 7.2.2 …".
- Lock: `comfy-table 7.2.2 -> 8.0.0`. `crossterm` and `unicode-segmentation` are unchanged.
- CI failure (run 35608748499):
  - Every compiling job fails on `error[E0599]: no method named 'load_preset' found for struct comfy_table::Table` at `src/output.rs`.
  - Affected jobs: Clippy (ubuntu/windows), Test (macos/ubuntu/windows), Coverage, MSRV.
  - Deny, Format, Spec Guards and the mutants jobs pass.

#### API-usage inventory (all comfy-table call sites in `src/` and `tests/`)
| Location | Symbol | Status in 8.0 |
|----------|--------|---------------|
| `src/output.rs:3` | `use comfy_table::{Cell, Color, ContentArrangement, Table, presets::UTF8_FULL_CONDENSED}` | All still exported. `UTF8_FULL_CONDENSED` changes type: `&str` -> `TableStyle` const. `Color` is still the crossterm re-export |
| `src/output.rs:13` (`render_table`) | `.load_preset(UTF8_FULL_CONDENSED)` | **REMOVED.** Replace with `.load_style(UTF8_FULL_CONDENSED)` |
| `src/output.rs:117` (`render_table_with_styles_inner`) | `.load_preset(UTF8_FULL_CONDENSED)` | **REMOVED.** Same fix |
| `src/output.rs:14,118` | `.set_content_arrangement(ContentArrangement::Dynamic)` | unchanged |
| `src/output.rs:15,119` / `:24,138` | `.set_header(..)` / `.add_row(..)` (Vec<String>, Vec<Cell>) | unchanged (`Into<Row>`) |
| `src/output.rs:114` | `table.force_no_tty().enforce_styling()` (test seam) | unchanged |
| `src/output.rs:131-133` | `Cell::new(..)`, `cell.fg(color)` (StyledCell structural color, BC-7.1.006) | unchanged |
| `src/output.rs` `StyledCell { fg: Option<Color> }` | `comfy_table::Color` in a public struct | unchanged type |
| `src/cli/user.rs:2,225-226` | `Color::Green`/`Color::Red` via `StyledCell::colored` | unchanged |
| `src/cli/user.rs:472-478` (test pinning third-party behavior) | `Table::new`, `force_no_tty().enforce_styling()`, `set_header`, `Cell::new(..).fg(..)` | unchanged; `should_style()` is still `enforce_styling \|\| is_tty()` |

- Other 8.0 removals: `TableComponent`, `modifiers`, `apply_modifier`, `set_style`, `style`, `remove_style`, `current_style_as_preset`. None are used in jr.
- The default truncation indicator changes from `...` to `…`. jr sets no `max_height` or row truncation, so this has no effect.
- `UTF8_FULL_CONDENSED` in 8.0 uses the same glyphs as the 7.2.2 string `"││──╞═╪╡┆    ┬┴┌┐└┘"`: `┌─┬┐`, `│┆│` header/content lines, `╞═╪╡` header separator, `└─┴┘`, and no row separators.
  The table-splitting helper in `tests/issue_commands.rs` (split on `┆`) keeps working.

#### Empirical migration check (throwaway worktree, since removed)
Applied #855's Cargo.toml change on top of develop `fb9d015c`, ran `cargo update -p comfy-table --precise 8.0.0`, and changed the two `.load_preset(` calls to `.load_style(`:
- `cargo clippy --all-targets -- -D warnings`: clean, on macOS with cargo 1.99.
- `cargo test` with `INSTA_UPDATE=no`: every test binary reported `0 failed`, and no `*.snap.new` files were produced. Table rendering and all insta snapshots match.
- Not verified locally: the Windows build (crossterm `windows` feature) and an actual 1.88.0 MSRV build.
  8.0.1 declares `rust-version = 1.88`, the same as jr's floor, so there is zero MSRV headroom. That is the same posture as standing item `CYCLE-013-COMFY-TABLE-ZERO-HEADROOM-MSRV`.

**Breakage assessment:**
- The migration is a 2-line production change (`load_preset` -> `load_style` in `src/output.rs`).
- Doc/comment fallout:
  - The Cargo.toml pin comment ("Pinned to 7.2.2 …").
  - The `tests/issue_commands.rs` (~1956) helper doc comment that calls `UTF8_FULL_CONDENSED` a "preset string".
  - Historical plans in `docs/superpowers/plans/` mention `load_preset`. They are historical and need not change.
- Also consider pinning `=8.0.1` rather than `=8.0.0`, since 8.0.1 is identical code plus correct MSRV metadata.
- Dependabot cannot make this change by itself, so #855 will stay red until someone pushes a commit to the PR or opens a replacement branch.

### #854 — reqwest 0.13.4 -> 0.13.5 (HELD 2026-09-21)
- 44 commits behind (merge base `c50a4860`).
- Lock: `reqwest 0.13.4 -> 0.13.5`, plus ADDED `base64 0.23.1`. reqwest 0.13.5 requires `base64 ^0.23`.
- CI failure (run 35621422654): `Deny (licenses + vulnerabilities)`, with `error[duplicate]: found 2 duplicate entries for crate 'base64'` and the summary `advisories ok, bans FAILED, licenses ok, sources ok`.
  - base64 0.22.1 is reached via `hyper-util 0.1.20` (from reqwest and wiremock), `jr`, and `wiremock 0.6.5`.
  - base64 0.23.1 is reached via `reqwest 0.13.5`.
- The log also has `error: override toolchain 'stable-x86_64-unknown-linux-musl' is not installed`. This is a harmless line from the cargo-deny-action container and also appears on passing runs. The real failure is the bans check.
- In-repo use: `reqwest` is the HTTP client everywhere (`src/api/client.rs`, `src/api/auth.rs`, `src/api/jira/attachments.rs` multipart, `src/api/jsm/attachments.rs`, and others). The patch bump has no API changes visible in this repo; all Test/Clippy/MSRV jobs passed on the PR.

### #842 — base64 0.22.1 -> 0.23.1 (HELD 2026-09-21)
- 44 commits behind (merge base `c50a4860`).
- Cargo.toml `base64 = "0.22"` -> `"0.23"`. Lock adds `base64 0.23.1`.
- CI failure (run 35621428695): Deny bans, `found 2 duplicate entries for crate 'base64'`. 0.22.1 comes via hyper-util 0.1.20, reqwest 0.13.4 and wiremock; 0.23.1 via jr.
- In-repo use: `base64` is a direct dependency, used for the Basic-auth header and other encode/decode in `src/api/` (including `src/api/auth.rs` / `client.rs`).
  Every Test/Clippy/MSRV job passed on the PR, so the 0.22 -> 0.23 API is compatible for jr's call sites.

---

## base64 0.22 -> 0.23 Blocker Re-verification (MAINT-BASE64-023-DEDUPE-BLOCKED-ON-UPSTREAM)

`cargo tree --locked -i base64@0.22.1 -e normal,build,dev --target all --depth 1` on develop `fb9d015c`:
```
base64 v0.22.1
├── hyper-util v0.1.20
├── jr v0.8.0-dev.2
├── reqwest v0.13.4
└── wiremock v0.6.5   [dev-dependencies]
```

**Upstream status has changed since 2026-09-21:**
- **`hyper-util` 0.1.21 (published 2026-09-24) now depends on `base64 = "0.23"`** (optional, behind `client-proxy`; verified in its registry Cargo.toml). The hyper-util half of the blocker is **resolved upstream**. develop is simply still locked to 0.1.20.
- **`wiremock` 0.6.5 is still the latest release and still requires `base64 = "0.22"`.** The `main` branch Cargo.toml upstream is still 0.6.5 on base64 0.22. This half of the blocker remains.

**Simulation** (throwaway worktree, since removed): develop + #842's Cargo.toml + #854's lock (`git merge-tree` result) + `cargo update -w`:
1. Without updating hyper-util: `cargo deny check bans` still FAILS with `duplicate entries for crate 'base64'`. Merging #842 and #854 as they stand still fails.
2. Adding `cargo update -p hyper-util --precise 0.1.21` (which also takes `hyper 1.8.1 -> 1.11.1` and removes `pin-utils 0.1.0`):
   - The base64 0.22.1 tree shrinks to `wiremock v0.6.5 [dev-dependencies]` only.
   - **cargo-deny 0.19.6 no longer reports the base64 duplicate.** `deny.toml` does not set `multiple-versions-include-dev`, and the default excludes dev-only duplicates. The remaining 0.22.1 path is dev-only, so it is not flagged.
     Inferred from the empirical result; the cargo-deny docs were not checked.
   - **New problem:** with local cargo 1.99.0, that `cargo update -p hyper-util` also re-resolved the `windows-sys` dependency edges of about 11 packages from `0.61.2` to `0.52.0`/`0.60.2`.
     The affected packages include colored, errno, rustix, tempfile, rustls-platform-verifier and anstyle-query. The cause is resolver behavior, not new crate versions.
     The result is a NEW `cargo deny` failure: `found 2 duplicate entries for crate 'windows_i686_gnullvm'` (0.52.6 via windows-sys 0.52, 0.53.1 via windows-sys 0.60).
     `deny.toml` has no `windows_i686_gnullvm` skip, even though its own comment block discusses one. It skips the other 7 arch crates at 0.42/0.53.
     The churn came the same way with `CARGO_RESOLVER_INCOMPATIBLE_RUST_VERSIONS=allow`.

**Revised blocker status:**
- The **hyper-util blocker is cleared** upstream.
- **wiremock 0.6.5 is still on base64 0.22**, but because it is dev-only it does not appear to trip the current `cargo deny check bans` configuration.
- A coordinated #842 + #854 + `hyper-util 0.1.21` bump looks feasible for the base64 dedupe. However, the lockfile must be produced without the windows-sys edge churn, or the `windows_i686_gnullvm` duplicate has to be addressed first.
  Options:
  - targeted edge cleanup;
  - a Dependabot-generated hyper-util bump, then check its lockfile;
  - a reviewed `windows_i686_gnullvm` skip. The human has declined skips for "wait for upstream" cases before, so this needs sign-off.
- The windows-sys behavior was seen with local cargo 1.99.0 only. CI's resolver result could differ, so this needs confirming on a real branch.
- Hold decision remains a human call. Suggested update to the standing item: change "blocked on wiremock or hyper-util" to "hyper-util unblocked as of 0.1.21; wiremock remains on base64 0.22 but is dev-only and not flagged by cargo-deny's default dev exclusion; re-attempt as a coordinated bump."

---

## Housekeeping performed
- Temporary refs `refs/tmp/pr-{912,900,892,885,883,855,854,842}` were created, then deleted. `git for-each-ref refs/tmp` is empty.
- Throwaway worktree `/private/tmp/claude-501/jr-dep-wt`: edits were discarded with `git checkout`, then it was removed with `git worktree remove` and `git worktree prune`.
- Leftover scratch files were not deleted, because `rm` is outside the allowlist:
  - the build cache `/private/tmp/claude-501/jr-dep-target/`
  - the lock snapshot `/private/tmp/claude-501/lock-842-854.lock`
- Main working tree: still `develop` @ `fb9d015c`, no stash, and its untracked `.claude/` files are untouched.
- No commits, no PR interactions.
