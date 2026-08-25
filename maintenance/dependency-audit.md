# Dependency Audit Sweep (Sweep 1)

- **Date:** 2026-08-25
- **Mode:** Read-only scan — no `Cargo.toml`/`Cargo.lock`/source changes made, no PRs opened.
- **Raw output:** `.factory/maintenance/dependency-audit-raw.log`
- **Repo:** jira-cli (`jr`), branch `develop`

## Advisories

`cargo audit` (installed via `cargo install cargo-audit --locked`, was already present):

- Advisory DB loaded: 1,226 entries (RustSec `advisory-db`).
- Scanned 358 crate dependencies (`Cargo.lock`).
- **Result: 0 RUSTSEC advisories matched.** No vulnerable, no unmaintained, no yanked crates flagged.
- Exit code: 0.

**Severity: none (clean).**

## License/Deny

`cargo deny check` (installed, already present; config: `deny.toml`, same job CI's `deny` runs):

- **Result: `advisories ok, bans ok, licenses ok, sources ok`.** Exit code: 0.
- 4 non-fatal warnings, all config-drift hygiene (no findings against actual dependencies):
  - `license-not-encountered`: `BSD-2-Clause`, `OpenSSL`, `Unicode-DFS-2016` are allow-listed in `deny.toml` but no crate in the current graph currently uses them (stale allow-list entries).
  - `unmatched-skip`: the `cpufeatures = ^0.2` skip entry (documented for the sha1/chacha20 cpufeatures-major split, DEC-185) was not encountered this run — the skip is currently unnecessary but harmless (kept for when the split reappears).
- No denied licenses, no banned crates triggered, no duplicate-version bans triggered against the **current, committed** `Cargo.lock`.

**Severity: LOW** — cosmetic config drift only (unmatched license allowances / skip entry). Not a defect, no action required beyond optional config cleanup.

## Available Updates

`cargo update --dry-run` (no lockfile changes made):

- 117 packages would be locked to newer semver-compatible versions; 13 unchanged behind latest (need `--verbose` for that list).
- Notable minor/patch bumps available: `aws-lc-rs` 1.16.2→1.18.0, `aws-lc-sys` 0.39.0→0.44.0, `hyper` 1.8.1→1.11.0, `regex` 1.12.3→1.13.1, `rustls` 0.23.37→0.23.43, `tower-http` 0.6.8→0.6.11, `clap`/`clap_builder`/`clap_derive` 4.6.x→4.6.6, `serde`/`serde_core`/`serde_derive` 1.0.228→1.0.229, `thiserror`/`thiserror-impl` 2.0.18→2.0.20, `toml`/`toml_parser` 1.1.3→1.1.4, `futures*` 0.3.32→0.3.34, `wasm-bindgen*` 0.2.114→0.2.127, `zerocopy`/`zerocopy-derive` 0.8.47→0.8.56.
- **Notable anomaly:** the dry-run resolution would add **`syn v3.0.4`** alongside the existing `syn v2.0.117`→`v2.0.119` update (both present simultaneously) — this is the root cause of the Dependabot block described below; a real `cargo update` today would trip `cargo-deny`'s `multiple-versions = "deny"` bans check the same way the open PRs do.
- `shlex` would jump 1.3.0→2.0.1 (a SemVer-major move for a transitive dependency, pulled in by some other crate's own newer constraint) — worth a second look before landing, though it's transitive and not a direct `Cargo.toml` entry.
- `cargo outdated` is **not installed**; skipped per instructions (not installed automatically). No major-version-behind report was generated this sweep — only the semver-compatible dry-run view above.

**Severity: none/informational** — these are ordinary available updates, not advisories.

## Dependabot PRs

`gh pr list --author "app/dependabot" --state open` — **6 open PRs**, not ~4 as assumed, but the assumption about the blocking cause is confirmed:

| # | Title | Created | mergeStateStatus | Blocking check |
|---|---|---|---|---|
| 735 | bump `taiki-e/install-action` 2.85.13→2.86.3 (github_actions) | 2026-08-25 | UNKNOWN | n/a — not a cargo dep, unaffected by syn issue |
| 730 | bump `futures` 0.3.32→0.3.34 | 2026-08-24 | **BLOCKED** | `Deny (licenses + vulnerabilities)` fails |
| 729 | bump `thiserror` 2.0.18→2.0.20 | 2026-08-24 | **BLOCKED** | `Deny (licenses + vulnerabilities)` fails |
| 728 | bump `toml` 1.1.3→1.1.4 | 2026-08-24 | **BLOCKED** | `Deny (licenses + vulnerabilities)` fails |
| 727 | bump `clap` 4.6.1→4.6.6 | 2026-08-24 | **BLOCKED** | `Deny (licenses + vulnerabilities)` fails |
| 688 | bump `serde` 1.0.228→1.0.229 | 2026-08-13 | **BLOCKED** | `Deny (licenses + vulnerabilities)` fails |

Confirmed root cause (checked PR #727's failing `Deny` job log, run 32735648887):

```
error[duplicate]: found 2 duplicate entries for crate 'syn'
  syn 2.0.117 registry+https://github.com/rust-lang/crates.io-index
  syn 3.0.4 registry+https://github.com/rust-lang/crates.io-index
```

Each individual Dependabot bump's `Cargo.lock` resolution pulls in `synstructure v0.13.2` (or a similar proc-macro chain) that now resolves to `syn 3.0.x`, while the bulk of the tree's proc-macro derives (`clap_derive`, `displaydoc`, `futures-macro`, `serde_derive`, `pear_codegen`, etc.) are still on `syn 2.0.x`. `deny.toml`'s `[bans] multiple-versions = "deny"` correctly fails this as a duplicate-crate violation. This matches `cargo update --dry-run`'s own resolution above (`Adding syn v3.0.4` alongside the `syn v2.x` update) — a real `cargo update` today would hit the identical failure. The **current, committed** `Cargo.lock` has only `syn v2.0.117` (single version) and passes `cargo deny check` clean — the problem is confined to the *next* update step, not the present state.

Resolution requires either (a) waiting for the remaining `syn 2.x`-pinned proc-macro crates to migrate to `syn 3.0`, or (b) an explicit `[[bans.skip]]`/allow decision (human-authorized, per `deny.toml`'s existing DEC-### precedent) to tolerate the dual-version window temporarily. Not something to resolve unilaterally in this read-only sweep.

**Severity: LOW** (process/CI-hygiene, not a security finding) — none of the 5 blocked bumps are security fixes by their titles (all routine patch/minor chores); the block only delays routine currency, it does not leave a known vulnerability unpatched.

## Benchmarks present?

- `ls benches/` → **no such directory.**
- `grep criterion Cargo.toml` → **no match.**
- **No performance benchmarks exist in this repo.** Maintenance Sweep 5 (performance regression sweep) does not apply to this project as currently structured.

## Recommended actions

Per config (auto-PR only at severity ≥ HIGH): **highest severity found this sweep is LOW. No auto-fix PR is warranted or opened.**

Non-blocking follow-ups for a human/maintainer to consider (informational only, not auto-actioned):
1. `deny.toml` cleanup: drop or update the 3 stale `license-not-encountered` allow-list entries (BSD-2-Clause, OpenSSL, Unicode-DFS-2016) and the stale `cpufeatures = ^0.2` skip entry if they're confirmed permanently unneeded — or leave as-is if they're pre-staged for currently-known future dependency changes.
2. The `syn` 2.x/3.0 duplicate-version block on 5 Dependabot PRs (#688, #727, #728, #729, #730) is a known, understood condition — no action needed until upstream crates converge on `syn 3.0`, or until a human explicitly authorizes a temporary `[[bans.skip]]` (would need a DEC-### decision entry per repo convention).
3. `shlex` 1.3.0→2.0.1 transitive major-version jump is worth a human glance before any future bulk `cargo update`, even though it's not currently actionable (no direct `Cargo.toml` entry).
4. `cargo outdated` was not installed and not run — if major-version-behind visibility is wanted going forward, that's a manual install decision, not made in this read-only sweep.
