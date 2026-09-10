# Dependency Audit — Analysis (2026-09-10)

Analysis half of Sweep 1 (Dependency Audit). Read-only. No fixes applied, no PRs opened, no commits made.

Raw inputs analyzed:
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/maintenance/dependency-audit-raw-2026-09-10.log`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/maintenance/dependency-audit-raw-summary-2026-09-10.md`

Branch analyzed: `develop` @ `78aeb86c` (current tip at analysis time).

---

## Finding 1 — `chacha20 0.10.0` yanked

- **Severity: LOW**
- **Real security impact vs. hygiene:** Hygiene-only. No RUSTSEC advisory, no CVE, and no vulnerability entry is attached to this warning — `cargo audit` reports it strictly as `Warning: yanked`, a distinct category from its `Vulnerability:` findings (of which there were zero in this scan; only "1 allowed warning found", exit 0).
- **Advisory research (Perplexity, 2026-09-10):**
  - No RUSTSEC advisory ID exists for `chacha20` 0.10.0's yank. The only historical RustSec advisory against the RustCrypto `chacha20` crate is **RUSTSEC-2019-0029** (32-bit block-counter overflow), which affects versions **before 0.2.3** — six major versions and several years removed from 0.10.0; not applicable here.
  - RUSTSEC-2026-0124 (a ciphertext-buffer panic/DoS) was surfaced by search relevance but confirmed **unrelated** — it affects the separate `libcrux-chacha20poly1305` crate (Cryspen's implementation), not RustCrypto's `chacha20`.
  - No public yank rationale (security fix / broken build / publish mistake) was found in available records. RustCrypto crates are yanked periodically for benign reasons (metadata errors, MSRV/build fixes, superseding patch releases) — the pattern here (0.10.0 immediately superseded by 0.10.1, now 0.10.2) is consistent with routine patch-replacement, not a security recall.
- **Dependency path:** `chacha20 0.10.0` ← `rand 0.10.2` ← `jr 0.7.0-dev.5` (direct dependency of `jr` on `rand`).
- **Recommended action: fix now (low-risk, isolated) — but does not need to be urgent.** Verified via `cargo update -p chacha20 --dry-run`: a **scoped** update cleanly resolves `chacha20 0.10.0 → 0.10.2` with **zero other package changes** (0 unchanged-dependency side effects beyond chacha20 itself — no `syn` split triggered, unlike a broad `cargo update`; see Finding 2/3 below for why a broad update is NOT safe to run right now). This makes the fix cheap: `cargo update -p chacha20` + commit `Cargo.lock`, standalone PR, no other dependency movement.
- **Disposition on the existing standing item:** The existing standing item tracking this as **LOW is correct and should remain LOW** — confirmed no security impact. Recommend downgrading the "no action" framing to "trivial scoped fix available, safe to land independently of the syn/Dependabot backlog" since the two issues (chacha20 yank vs. syn 2.0/3.0 convergence, Finding 2/3) are otherwise conflated in the dependency graph but are **independently actionable** — fixing chacha20 does not require waiting on syn convergence, and vice versa.

---

## Finding 2 — Why the 5 open cargo Dependabot PRs fail `Deny (licenses + vulnerabilities)`

PRs in scope: **#738** (open, `dependabot/cargo/open-5.4.1`), **#730** (`futures-0.3.34`), **#729** (`thiserror-2.0.20`), **#727** (`clap-4.6.6`), **#688** (`serde-1.0.229`).

### Direct evidence gathered

1. **`gh pr checks 727 --json name,link,state`** — confirmed `Deny (licenses + vulnerabilities)` = `FAILURE` (job id `101248362302`, run `33944620708`), while every other required check (Tests × 3 platforms, Clippy × 2, MSRV, Format, Coverage, Mutation testing, Secret Scan, Spec Guards, Signing Guard, dependency-review) is `SUCCESS`. This isolates the failure to `cargo deny check` specifically, not a broader regression from the dependency bump itself.
2. **Fetched the actual failing job log** (`gh run view --job 101248362302 --log`) and found the root cause:
   ```
   error[duplicate]: found 2 duplicate entries for crate 'syn'
     ┌─ /github/workspace/Cargo.lock:214:1
   214 │ ╭ syn 2.0.117 registry+https://github.com/rust-lang/crates.io-index
   215 │ │ syn 3.0.5   registry+https://github.com/rust-lang/crates.io-index
   ...
   advisories ok, bans FAILED, licenses ok, sources ok
   ```
   This is a **`[bans]` failure** (`multiple-versions = "deny"` in `deny.toml`), **not** a `[licenses]` or `[advisories]` failure — the job's display name ("Deny (licenses + vulnerabilities)") is misleadingly narrow; it actually gates all four `cargo deny` categories (advisories, bans, licenses, sources), and `bans` is the one tripping here.
   - PR #727's Cargo.lock was generated against `jr v0.7.0-dev.4` (one version behind current develop's `v0.7.0-dev.5`), and its dependency tree still contains `thiserror 1.0.69`/`thiserror-impl 1.0.69` alongside `thiserror 2.0.18`/`thiserror-impl 2.0.18` (both **already explicitly `[[bans.skip]]`-allowed** in `deny.toml` — not the actual problem) plus the `syn 2.0.117`/`syn 3.0.5` pair, which has **no skip entry** and is therefore a hard `deny`.
3. **Branch staleness (`git fetch origin` + `git rev-list --count`)**, confirmed for all 5 PRs — all are single-commit Dependabot bumps, all branched well behind current `develop` tip (`78aeb86c`):

   | PR | Head branch | Behind `develop` by | Ahead by |
   |---|---|---|---|
   | #727 | `dependabot/cargo/clap-4.6.6` | 19 commits | 1 |
   | #729 | `dependabot/cargo/thiserror-2.0.20` | 40 commits | 1 |
   | #730 | `dependabot/cargo/futures-0.3.34` | 47 commits | 1 |
   | #738 | `dependabot/cargo/open-5.4.1` | 40 commits | 1 |
   | #688 | `dependabot/cargo/serde-1.0.229` | 40 commits | 1 |

4. **Reproduced the identical condition on current `develop` HEAD** via `cargo update --dry-run`:
   ```
   Removing syn v2.0.117
     Adding syn v2.0.119
     Adding syn v3.0.5
   ```
   This is the critical finding: **the syn 2.0-vs-3.0 split is not something the PR branches are simply "missing a fix" for — it reproduces today, on current `develop`, the moment any `cargo update` regenerates `Cargo.lock`.** The currently-committed `Cargo.lock` on `develop` pins a single `syn 2.0.117` and passes `cargo deny check` clean; but that's a frozen snapshot, not evidence the underlying ecosystem conflict is resolved. Some part of the graph (reachable once resolver re-solves) wants `syn 3.0.x` while the bulk of the tree's proc-macro derives (`clap_derive`, `displaydoc`, `futures-macro`, `serde_derive`, `pear_codegen`, etc.) remain on `syn 2.0.x`, and `deny.toml`'s `multiple-versions = "deny"` has no `[[bans.skip]]` entry for `syn` (unlike `thiserror`, `toml`, `getrandom`, etc., which each have documented, human-authorized skip entries for their own known dual-version splits).
   - A prior maintenance sweep (`.factory/maintenance/dependency-audit.md`, referenced by `.factory/cycles/OPEN-STANDING-ITEMS.md`) had already diagnosed this exact mechanism: *any* Dependabot bump's `cargo update` pulls in a `synstructure`-chain resolution that lands on `syn 3.0.x`, independent of which specific crate is being bumped. Today's dry-run against current `develop` **corroborates that diagnosis is still accurate as of 2026-09-10** — the condition has not resolved upstream in the intervening period.

### Classification

**(a) Staleness — partially true but NOT sufficient by itself, and NOT the actionable fix.** All 5 PRs are stale (19–47 commits behind `develop`), but staleness is not what's blocking them.

**(b) A real condition the bump introduces — YES, this is the operative cause**, but it's more precisely an **ecosystem-wide condition triggered by regenerating `Cargo.lock` at all**, not something specific to any one PR's bumped crate (clap, thiserror, futures, open, serde are otherwise unrelated to `syn`/`synstructure`). Rebasing any of these 5 PRs onto current `develop` would **not** clear the failure — Dependabot (or a manual `cargo update`) regenerating the lockfile during a rebase would re-trigger the identical `syn 2.0/3.0` duplicate, because the underlying cause (remaining `syn 2.x`-pinned proc-macro crates in the graph vs. whatever newly wants `syn 3.0.x`) is still present in the crates.io ecosystem today.

**(c) Undetermined — ruled out.** This was determinable with direct log evidence plus a live reproduction against current `develop`; not left open.

### Recommendation

- **Keep all 5 PRs HELD, not rebase-and-merge.** Rebasing alone will not clear the Deny gate; it would just reproduce the same `syn` duplicate on the rebased branch (confirmed by the `cargo update --dry-run` reproduction on `develop` itself).
- Two real paths to unblock, matching the disposition already on file in `.factory/cycles/OPEN-STANDING-ITEMS.md`:
  1. **Wait for upstream convergence** — once the remaining `syn 2.x`-pinned proc-macro crates in the graph (or whatever crate is newly requesting `syn 3.0.x`) release `syn 3.0`-compatible versions, a routine `cargo update` will no longer produce a duplicate, and these PRs (or fresh Dependabot bumps) will pass Deny cleanly.
  2. **Or** a human-authorized `[[bans.skip]]` entry for `syn` in `deny.toml` (mirroring the existing precedent for `thiserror`/`toml`/`getrandom`/etc.), accepting the dual-version window temporarily. This is a DEC-### decision per repo convention (`deny.toml`'s own comment: *"Not something to resolve unilaterally in this read-only sweep"*) — **not something this analysis authorizes**; flag for explicit human sign-off if the team wants to unblock the backlog before upstream converges.
- This is a genuinely different, more specific finding than "just stale" — I'd flag it explicitly to whoever is triaging the backlog so no one attempts a rebase expecting it to clear cleanly.

---

## Finding 3 — Duplicate-version crate families: is the `syn` 2.0-vs-3.0 hold still valid? Any other family a concern?

- **The `syn` 2.0-vs-3.0 standing hold is STILL VALID** (see Finding 2). It is correctly absent from today's `cargo tree --duplicates` output on `develop` (current committed `Cargo.lock` has only `syn 2.0.117`), which is why the raw scan's summary correctly noted "no syn duplicate found in this run" — but that reflects the frozen lockfile, not resolution of the underlying conflict. `cargo update --dry-run` reproduces the split immediately. **The standing item should not be closed or downgraded**; it remains an accurate, live blocker for any Dependabot merge or manual `cargo update`.

- **The other 7 duplicate families found by `cargo tree --duplicates`** (`getrandom`, `rand`, `rand_core`, `serde_spanned`, `toml`, `toml_datetime`, `winnow`) are **NOT a concern** — verified against `deny.toml`:
  - Every single one of these has an explicit, individually-justified `[[bans.skip]]` entry in `deny.toml` (e.g. `getrandom` 0.2/0.3/0.4 — three semver-incompatible majors from independent transitive deps; `serde_spanned`/`toml`/`toml_datetime`/`winnow` 0.x-vs-1.x — figment's `toml 0.8` dependency vs. `jr`'s direct `toml 1.x` dependency, blocked on figment upgrading).
  - `rand`/`rand_core` dual versions (0.9.x and 0.10.x) are **deliberately not skip-listed** per an explicit comment in `deny.toml` (`.factory`/`deny.toml` lines ~59–69): adding skip entries for them triggers `unmatched-skip`/`unnecessary-skip` warnings in the current cargo-deny version, because the live dependency graph only exercises `rand 0.10` (jr's direct dep) — `rand 0.9.4` is a dev-only/cross-platform placeholder pulled by `proptest` that never enters the actual build. This is a documented, intentional non-skip, not an oversight.
  - `cargo deny check` on `develop` returned `advisories ok, bans ok, licenses ok, sources ok` (exit 0) with these families present — proof that `bans.skip` coverage for all of them is currently complete and effective. None of them are flagged by `bans`, and none showed up as CVE/RUSTSEC advisories in `cargo audit`.
  - **No new action needed on any of these 7 families.** They are governed, documented, and passing.

- **Secondary items from the raw scan, for completeness (neither blocks anything):**
  - 3× `license-not-encountered` warnings (`BSD-2-Clause`, `OpenSSL`, `Unicode-DFS-2016` in the `[licenses] allow` list) — these are **harmless allow-list entries with no current matching dependency**; not a finding requiring action, just unused allowances. **LOW / no action** — could be pruned as a future hygiene pass but changes nothing about the current pass/fail state.
  - 1× `unmatched-skip` for `cpufeatures = ^0.2` — explicitly authorized and documented under **DEC-185** in `deny.toml` (sha1 0.10.7 needs cpufeatures 0.2.17, chacha20 0.10.0 pulls cpufeatures 0.3.0 via rand). Currently "unmatched" because the CI/local resolution happens not to hit the 0.2.x path in this exact `Cargo.lock` snapshot; **LOW / no action** — this is a pre-authorized, already-reasoned skip declaration, not a new drift signal. Worth noting: if the chacha20 targeted-update fix in Finding 1 is applied, re-verify this skip entry still reflects reality (chacha20 0.10.2's cpufeatures requirement should be re-checked, though the `cargo update -p chacha20 --dry-run` showed zero other package movement, so this is very unlikely to change).

---

## Summary table

| # | Finding | Severity | Real security impact? | Recommended action |
|---|---|---|---|---|
| 1 | `chacha20 0.10.0` yanked | LOW | No — no RUSTSEC/CVE, hygiene-only yank | Fix now: scoped `cargo update -p chacha20` (0.10.0→0.10.2), zero side effects, standalone PR. Standing LOW classification confirmed correct. |
| 2 | 5 open Dependabot PRs fail `Deny` check | N/A (process/CI, not a vuln) | No — failure is a `[bans]` duplicate-version policy hit, not a license or advisory violation | Keep HELD (not rebase-and-merge — rebasing will not clear it, confirmed by reproducing the same `syn` split via `cargo update --dry-run` on current `develop`). Unblocks only via upstream `syn 3.0` convergence or an explicit human-authorized `[[bans.skip]]` DEC-### decision. |
| 3a | `syn` 2.0-vs-3.0 duplicate (dry-run only, not in committed lockfile) | LOW today / blocking for merges | No current vulnerability; pure dependency-resolution policy conflict | Standing hold confirmed still valid — do not close. Same disposition as Finding 2. |
| 3b | 7 other duplicate-version families (`getrandom`, `rand`, `rand_core`, `serde_spanned`, `toml`, `toml_datetime`, `winnow`) | LOW / none | No | No action — all fully governed by documented, justified `[[bans.skip]]` entries (or an intentional non-skip for `rand`/`rand_core`); `cargo deny check` passes clean with them present. |
| 3c | 3× `license-not-encountered` warnings, 1× `unmatched-skip` (`cpufeatures`, DEC-185) | LOW | No | No action needed; pre-authorized/unused-allowance hygiene items only. |

**Overall scan health:** `cargo audit` and `cargo deny check` both pass clean on `develop` (exit 0, no errors, only pre-understood warnings). The one actionable item is the low-risk chacha20 targeted update (Finding 1). The Dependabot backlog (Finding 2/3a) is correctly held and should stay held pending upstream `syn` convergence or an explicit human decision — this analysis does not authorize adding a `syn` skip entry itself.
