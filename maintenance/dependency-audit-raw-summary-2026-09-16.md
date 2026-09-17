# Dependency Audit — Raw Scan Summary

**Sweep:** MAINTENANCE SWEEP 1 — dependency audit SCAN phase
**Repo:** jira-cli
**Branch:** develop @ `01e278fcb247e8f40b4f036993a1305edbb97df4`
**Date:** 2026-09-16
**Raw log:** `.factory/maintenance/dependency-audit-raw-2026-09-16.log`

This is a RAW scan report only. No severity classification or remediation
recommendation is made here — that is the security-reviewer's job.

## 1. Tool versions

| Tool | Version | Pre-installed? |
|---|---|---|
| rustc | 1.98.1 (48a229cea 2026-09-01) | n/a |
| cargo | 1.98.1 (797e8a9bc 2026-08-05) | n/a |
| cargo-audit | 0.22.1 | **Yes** — already installed, no `cargo install` step was needed |
| cargo-deny | 0.19.6 | Yes — already installed |

Advisory DB: fetched fresh from `https://github.com/RustSec/advisory-db.git`,
1246 advisories loaded (`/Users/zious/.cargo/advisory-db`). crates.io index updated
before the scan.

## 2. `cargo audit` — RUSTSEC advisories

Scanned **359 crate dependencies** in `Cargo.lock`.

**Result: no advisories printed after the scan line — 0 RUSTSEC vulnerabilities found.**
Command exited 0 both in the combined run and in an isolated re-run used to confirm
the output wasn't truncated.

| ID | Crate | Version | Severity |
|---|---|---|---|
| — none — | — | — | — |

## 3. `cargo deny check` — advisories / bans / licenses / sources

**Final line: `advisories ok, bans ok, licenses ok, sources ok`** — no rule failures
in any of the four checked categories. Exit 0.

Three non-blocking `warning[license-not-encountered]` and one
`warning[unmatched-skip]` were emitted (config hygiene, not failures):

| Kind | Rule / location | Detail |
|---|---|---|
| `license-not-encountered` | `deny.toml:8` | `"BSD-2-Clause"` allowance in `deny.toml` matched no crate currently in the tree |
| `license-not-encountered` | `deny.toml:15` | `"OpenSSL"` allowance matched no crate currently in the tree |
| `license-not-encountered` | `deny.toml:13` | `"Unicode-DFS-2016"` allowance matched no crate currently in the tree |
| `unmatched-skip` | `deny.toml:280-282` | `cpufeatures = "^0.2"` skip entry (DEC-185, documented reason: sha1 v0.10.7 needs cpufeatures 0.2.17 vs chacha20 v0.10.0/rand v0.10.1 needing cpufeatures 0.3.0) was not encountered — the skip is currently unused in the resolved graph |

No advisories/bans/licenses/sources rule **failed**; these four are warnings about
stale/unmatched `deny.toml` entries only.

## 4. `cargo tree --duplicates` — duplicate transitive versions

Duplicate version families found:

| Crate | Versions present | Pulled in by |
|---|---|---|
| `getrandom` | 0.3.4, 0.4.2 | 0.3.4 via `rand_core 0.9.5` (→ `rand 0.9.4`/`rand_chacha 0.9.0`/`rand_xorshift 0.4.0`, all under `proptest 1.11.0` dev-dep); 0.4.2 via `rand 0.10.2` (direct) and `tempfile 3.27.0` (→ `dialoguer`, `insta` dev-dep, `proptest`, `rusty-fork`, and `jr` dev-deps directly) |
| `rand` | 0.9.4, 0.10.2 | 0.9.4 via `proptest 1.11.0` (dev-only); 0.10.2 is `jr`'s direct runtime dependency |
| `rand_core` | 0.9.5, 0.10.1 | 0.9.5 under the proptest/0.9.4 branch; 0.10.1 under `chacha20 0.10.2`/`getrandom 0.4.2`/`rand 0.10.2` |
| `serde_spanned` | 0.6.9, 1.1.1 | 0.6.9 via `toml 0.8.23`/`toml_edit 0.22.27` (→ `figment 0.10.19`); 1.1.1 via `toml 1.1.4+spec-1.1.0` (`jr`'s direct dep) |
| `toml` | 0.8.23, 1.1.4+spec-1.1.0 | 0.8.23 via `figment`; 1.1.4 is `jr`'s direct dep |
| `toml_datetime` | 0.6.11, 1.1.1+spec-1.1.0 | mirrors the `toml` split above |
| `winnow` | 0.7.15, 1.0.0 | 0.7.15 via `toml_edit 0.22.27`; 1.0.0 via `toml 1.1.4`/`toml_parser 1.1.3+spec-1.1.0` |

**Notable non-duplicate observation (not surfaced by `--duplicates` since only one
version is reachable in the resolved graph):** `Cargo.lock` contains two `thiserror`
entries — `1.0.69` and `2.0.18`. `cargo tree -i thiserror@1.0.69` returns "nothing to
print" (no active dependent on this platform/target) while `2.0.18` is pulled in by
`jr` directly and by `saphyr-parser 0.0.11` (dev-dependency). The `1.0.69` lockfile
entry appears to be an orphaned/unreferenced resolution artifact rather than a live
duplicate-in-tree — flagging for the security-reviewer's triage in case it warrants a
`cargo update -p thiserror --precise` cleanup or is simply harmless lockfile residue.

General pattern: the duplication is the well-known `rand`/`getrandom` 0.9→0.10 split
(proptest's dev-only pin vs. `jr`'s direct runtime pin) and the `toml` 0.8→1.1 split
(`figment`'s indirect pin vs. `jr`'s direct pin). Both are common "one direct dep is
ahead of a transitive dep's own pin" duplication shapes, not anything unusual.

## 5. Open Dependabot PRs (7) — for security-reviewer triage

| PR | Dependency | Proposed bump | Current in `Cargo.lock` | Type |
|---|---|---|---|---|
| #821 | `github/codeql-action/upload-sarif` | 4.37.9 → 4.38.0 | n/a (GitHub Action, not a Cargo.lock entry) | CI workflow action |
| #820 | `taiki-e/install-action` | 2.86.3 → 2.87.9 | n/a (GitHub Action, not a Cargo.lock entry) | CI workflow action |
| #738 | `open` | 5.4.0 → 5.4.1 | **5.4.0** (matches PR's stated current version) | Cargo crate |
| #730 | `futures` | 0.3.32 → 0.3.34 | **0.3.32** (matches) | Cargo crate |
| #729 | `thiserror` | 2.0.18 → 2.0.20 | **2.0.18** (matches; note the separate, unrelated `1.0.69` orphan entry above — this PR only touches the `2.x` line) | Cargo crate |
| #727 | `clap` | 4.6.1 → 4.6.6 | **4.6.1** (matches) | Cargo crate |
| #688 | `serde` | 1.0.228 → 1.0.229 | **1.0.228** (matches) | Cargo crate |

All five cargo-crate PRs' "current" version matches `Cargo.lock` exactly — none of
these dependencies have drifted from what the open PRs assume. The two GitHub Actions
PRs (#821, #820) bump pinned action versions in workflow YAML, not `Cargo.lock`;
version currency was not independently re-verified against the live GitHub Marketplace
in this raw scan pass — flagging for security-reviewer to confirm during triage if
needed.

## 6. RAW verdict

**CLEAN** — 0 RUSTSEC advisories, `cargo deny check` fully passing (advisories ok,
bans ok, licenses ok, sources ok, only config-hygiene warnings), duplicate transitive
versions present but of the ordinary "direct dep ahead of indirect dep's pin" shape.
