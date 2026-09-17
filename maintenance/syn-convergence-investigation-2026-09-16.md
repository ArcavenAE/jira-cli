# syn 2.x/3.x Convergence Investigation — 2026-09-16

**Status:** Decision-support only. No files in the main checkout or `.factory` worktree were
modified. All commands below were run in a throwaway detached-HEAD `git worktree` under the
scratchpad directory (`git worktree add --detach <scratch>/syn-investigation HEAD` at
`develop@01e278fc`), which was removed (`git worktree remove`) after the investigation
completed. `deny.toml` in the real tree is unchanged.

## Background

`develop@01e278fc` is uniformly on `syn 2.0.117` and `cargo deny check` passes cleanly
(one pre-existing, unrelated `unmatched-skip` warning for `cpufeatures = ^0.2`, not
addressed here — out of scope). Four open Dependabot PRs each pull a proc-macro
companion crate that has migrated to `syn 3.x`, colliding with the syn-2 crates still in
the tree:

- #729 `thiserror` 2.0.18 → 2.0.20 (`thiserror-impl` 2.0.20 → syn 3)
- #730 `futures` 0.3.32 → 0.3.34 (`futures-macro` 0.3.34 → syn 3)
- #727 `clap` 4.6.1 → 4.6.6 (`clap_derive` pinned `=4.6.4` by clap 4.6.6 → syn 3)
- #688 `serde` 1.0.228 → 1.0.229 (`serde_derive` 1.0.229 → syn 3)

`deny.toml` currently has no `syn` skip (it does have a `thiserror`/`thiserror-impl` 1.x/2.x
skip pair, but that is unrelated — it's for the `jni`-via-`rustls-platform-verifier` thiserror
1.x holdout, not syn).

## 1. Current syn-2 holdout list (develop @ 01e278fc)

`cargo tree -i syn` on the clean tree shows a single `syn 2.0.117` node with these direct
proc-macro consumers:

| Consumer (locked version) | Reached via | Direct or transitive dep of `jr` |
|---|---|---|
| `clap_derive 4.6.1` | `clap 4.6.1` | direct (`clap = "4"`) |
| `displaydoc 0.2.5` | `icu_*` crates (via `idna_adapter` → `idna` → `url`) | transitive (deep, via `url`/`reqwest`) |
| `futures-macro 0.3.32` | `futures-util` → `futures 0.3.32` | direct (`futures = "0.3"`) |
| `pear_codegen 0.2.9` | `pear 0.2.9` → `figment 0.10.19` | transitive, optional feature (direct dep `figment`) |
| `proc-macro2-diagnostics 0.10.1` | `pear_codegen 0.2.9` | transitive (dependency of pear_codegen) |
| `serde_derive 1.0.228` | `serde 1.0.228` | direct (`serde = "1"`) |
| `synstructure 0.13.2` | `yoke-derive`, `zerofrom-derive` (icu chain) | transitive (deep, via `url`) |
| `thiserror-impl 2.0.18` | `thiserror 2.0.18` | direct (`thiserror = "2"`) |
| `tokio-macros 2.7.0` | `tokio 1.53.1` | direct (`tokio`) |
| `tracing-attributes 0.1.31` | `tracing 0.1.44` | direct (`tracing`) |
| `yoke-derive 0.8.1`, `zerofrom-derive 0.1.6`, `zerovec-derive 0.11.2` | icu chain | transitive |

(`clap_derive`, `futures-macro`, `serde_derive`, `thiserror-impl` are the four named in the
Dependabot PRs; the rest are additional syn-2 holdouts not touched by those PRs.)

## 2. Syn-3 availability per holdout (checked against crates.io, 2026-09-16)

Queried via crates.io API (`GET /api/v1/crates/<name>` and `.../<version>/dependencies`),
requires a `User-Agent` header (crates.io rejects anonymous UAs with an empty/opaque body).

| Crate | Locked (syn2) | Latest on crates.io | Latest's syn req | syn-3 released? | Last release date |
|---|---|---|---|---|---|
| `clap_derive` | 4.6.1 | **4.6.7** | `^3.0.2` | **Yes** (switched at 4.6.4) | recent |
| `serde_derive` | 1.0.228 | **1.0.229** | `^3` | **Yes** (switched exactly at 1.0.229) | recent |
| `thiserror-impl` | 2.0.18 | **2.0.20** | `^3` | **Yes** (switched at 2.0.19) | recent |
| `futures-macro` | 0.3.32 | **0.3.34** | `^3.0` | **Yes** (switched at 0.3.34; 0.3.33 is still syn2) | recent |
| `synstructure` | 0.13.2 | **0.14.0** | `^3` | **Yes** | recent |
| `displaydoc` | 0.2.5 | **0.2.7** | `^3.0` | **Yes** | recent |
| `tokio-macros` | 2.7.0 | **2.7.2** | `^3.0` | **Yes** (switched at 2.7.2; already satisfied by tokio's own `~2.7.0` req — see §5) | recent |
| **`pear_codegen`** | 0.2.9 | 0.2.9 (no newer) | `^2.0.30` | **No** | 2024-03-20 (~2.5 yr stale) |
| **`proc-macro2-diagnostics`** | 0.10.1 | 0.10.1 (no newer) | `^2.0` | **No** | 2023-07-10 (~3.2 yr stale) |
| **`tracing-attributes`** | 0.1.31 | 0.1.31 (already latest) | `^2.0` | **No** | 2025-11-26 (recent — actively maintained, just hasn't migrated) |

`syn 3.0.0` itself shipped **2026-07-18** — roughly **two months** before this investigation.
The ecosystem split is a normal, expected transitional state for a two-month-old major
version, not stagnation.

## 3. Can the four PR target versions stay on syn 2? (Confirmed: no)

Verified via crates.io dependency metadata for the exact PR target versions, and empirically
reproduced with `cargo update -p <crate> --precise <version>` + `cargo tree -i syn` in the
throwaway worktree:

- `thiserror-impl` 2.0.20 → `syn ^3` (no way to stay on 2; the syn3 switch happened at 2.0.19,
  one patch before the PR's target).
- `futures-macro` 0.3.34 → `syn ^3.0` (switch happened exactly at 0.3.34; 0.3.33, one patch
  below the PR's target, is still syn2 — see §6 for a partial-bump option).
- `clap` 4.6.6 pins `clap_derive = "=4.6.4"` (exact pin in clap's own `Cargo.toml`), and
  `clap_derive` 4.6.4 → `syn ^3.0.2` (switch happened at 4.6.4; 4.6.3, immediately below, is
  still syn2 — see §6).
- `serde_derive` 1.0.229 → `syn ^3` (switch happened exactly at 1.0.229, the PR's target — no
  intermediate patch exists between 1.0.228 (current, syn2) and 1.0.229).

Empirical confirmation: bumping all four in the throwaway worktree and running
`cargo deny check bans` reproduces the exact failure described in the background:

```
error[duplicate]: found 2 duplicate entries for crate 'syn'
  syn v2.0.117  (displaydoc, pear_codegen, proc-macro2-diagnostics, synstructure,
                 tokio-macros, tracing-attributes, yoke-derive, zerofrom-derive, zerovec-derive)
  syn v3.0.6    (clap_derive 4.6.4, futures-macro 0.3.34, serde_derive 1.0.229,
                 thiserror-impl 2.0.20)
```

## 4. Feasibility verdict: **NOT-CONVERGEABLE-NOW**

Full unification onto a single syn version — in **either** direction — is not achievable
today with released crates:

- **syn-3-everywhere is blocked**, hard, by three holdouts with no released syn-3 version:
  - `pear_codegen` 0.2.9 and its dependency `proc-macro2-diagnostics` 0.10.1 — both reached
    via `figment`'s optional `pear` feature (`figment` is a **direct** `jr` dependency, used
    by `config.rs`). `figment`'s own latest release (0.10.19, already what `jr` is on) still
    depends on `pear ^0.2`, and `pear`'s latest (0.2.9, unchanged) still depends on
    `pear_codegen ^0.2.9`. Neither `pear` nor `pear_codegen` has released anything since
    2024-03-20. There is no newer `figment` to jump to, either — 0.10.19 is figment's
    ceiling. This chain looks dormant, not merely lagging.
  - `tracing-attributes` 0.1.31 — reached via `tracing` (a **direct** `jr` dependency).
    `tracing`'s latest release (0.1.44, already what `jr` is on) requires
    `tracing-attributes ^0.1.31`, which is already the newest `tracing-attributes` release
    (2025-11-26). Unlike the pear chain, `tracing` is actively maintained (recent release),
    it simply has not shipped a syn-3 migration yet — unsurprising given syn 3.0.0 is only
    ~2 months old.
- **syn-2-only is what develop already has.** It is trivially "achievable" only in the sense
  of *not merging* the four PRs (or a bounded partial merge — see §6). It is not a
  forward-looking convergence strategy since it means indefinitely holding back
  security/dependency-hygiene bumps on four widely-used crates while the rest of the Rust
  ecosystem moves to syn 3.

**Maturity read:** this is an early-stage, fast-moving major-version migration (syn
3.0.0 → 2026-07-18; four of jr's direct deps — serde, thiserror, futures, clap — already
migrated within ~2 months). The two genuinely stuck holdouts are a small, identifiable set
(2 dormant crates in one optional-feature chain, 1 crate belonging to an active but
not-yet-migrated project). This is very likely a temporary state, not a durable split.

## 5. Related finding (not one of the 4 PRs): `tokio-macros` is *already* eligible for a
silent syn-3 drift

`tokio` 1.53.1 (current, already latest) depends on `tokio-macros` with the requirement
`~2.7.0`, which permits any `2.7.x` patch. `tokio-macros` 2.7.2 (already released, syn-3)
satisfies that range. A future bare `cargo update` (no Dependabot PR needed, no
Cargo.toml change) could silently introduce a **fifth** syn-3 path independent of the four
PRs in scope here. Worth keeping in mind when scoping the skip's removal trigger and any
future Dependabot lockfile-only PR for `tokio-macros`/`tokio`.

## 6. Partial-bump (syn-2-preserving) ceilings, if the goal were to take *some* of the
churn without syn 3 at all

- `futures`: `futures-macro` 0.3.33 is still syn2 (only 0.3.34 switches). A Dependabot PR
  amended to target 0.3.33 instead of 0.3.34 would stay on syn2. (0.3.34 is one patch away;
  this is a thin margin, not a durable strategy.)
- `clap`: `clap_derive` 4.6.3 is still syn2 (4.6.4 switches, and clap 4.6.6 exact-pins
  `clap_derive =4.6.4`, so any `clap` version ≥4.6.4 forces syn3). Manually holding `clap` at
  4.6.3 (below the PR's 4.6.6 target) would stay on syn2. This is *not* what PR #727 does; the
  PR cannot be merged as-is and stay off syn3.
- `thiserror`, `serde`: **no partial option** — the very next patch above the current locked
  version (2.0.18→2.0.19; 1.0.228→1.0.229) is the syn-3 switch point in both cases.

Given the above, "syn-2-only" convergence would only buy a few more days/weeks before the
next patch release forces the same collision anyway — not a real long-term fix.

## 7. Collateral finding: PR #727 (clap) trips a *second*, independent multiple-versions
error — not syn-related

Empirically isolated (bump `clap` alone via `cargo update -p clap --precise 4.6.6`, nothing
else): `cargo deny check bans` reports **two** errors, not one:

```
error[duplicate]: found 2 duplicate entries for crate 'syn'
error[duplicate]: found 2 duplicate entries for crate 'windows_i686_gnullvm'
```

Bumping `thiserror`+`futures`+`serde` together (without `clap`) reproduces only the `syn`
error — confirming the `windows_i686_gnullvm` error is specific to the `clap` bump.

Root cause: `windows_i686_gnullvm` 0.52.6 and 0.53.1 **already both exist** in develop's
`Cargo.lock` today (via `ring`'s `windows-sys 0.52` and `keyring`'s `windows-native`
`windows-sys 0.60` respectively — this is the pre-existing, intentionally-unskipped
`windows-sys` split documented at length in `deny.toml`, which states cargo-deny does not
flag `windows_i686_gnullvm` on non-Windows CI because it's absent from the *resolved* graph
for that host target). Bumping `clap_builder` to 4.6.6 adds a new reachability path to the
same 0.53.1 version (`anstyle-query → anstream → clap_builder 4.6.6 → clap`), which appears
to change whether cargo-deny's default (non-`--target all`) resolution considers the crate
"in graph" on macOS/Linux CI, flipping a previously-silent duplicate into a reported one.
This was **not investigated to a root-cause fix** — it's out of scope for a syn-focused
investigation — but it means **PR #727 cannot be merged today even if the syn split is
skip-listed**, without also handling this second finding. Recommend the PR's own reviewer
re-run `cargo deny check bans` (and ideally `--target all`, before/after) once `clap` is
bumped, and decide whether it needs its own `[[bans.skip]]` entry or whether it's a
resolution-order artifact best fixed by also bumping `clap_builder`/`clap_derive` all the way
to their own latest (4.6.7) rather than clap's exact `=4.6.4` pin.

## Recommendation

**Do not relax `multiple-versions = "deny"`.** Add a temporary, documented `[[bans.skip]]`
pair for `syn`, following the exact precedent already established in this file for
`thiserror`/`thiserror-impl` (1.x/2.x), `toml`/`toml_datetime`/`serde_spanned` (0.8/1.x via
figment), and `windows-sys` (multiple 0.x lines via jni/ring/keyring) — all of which are the
same shape of problem: one crate genuinely needs two major/minor lines because independent
upstream dependencies haven't converged yet, and the project's established policy has always
been "skip with a reason + removal trigger," not "relax the ban."

Proposed exact addition to `deny.toml` (placed alongside the other proc-macro/version-split
skips, e.g. near the `thiserror`/`thiserror-impl` block):

```toml
[[bans.skip]]
name = "syn"
version = "2"
reason = "syn 3.0.0 shipped 2026-07-18; as of 2026-09-16 three syn-2 holdouts remain with no released syn-3 version: pear_codegen 0.2.9 + proc-macro2-diagnostics 0.10.1 (both last released 2023/2024, reached via figment's optional `pear` feature — figment is a direct jr dependency for config.rs; figment 0.10.19 is already its ceiling release and still requires pear ^0.2) and tracing-attributes 0.1.31 (reached via tracing, a direct jr dependency already on its latest 0.1.44 release, which requires tracing-attributes ^0.1.31 — the newest tracing-attributes release, 2025-11-26 — tracing is actively maintained but has not yet migrated to syn 3). Unavoidable dual version alongside syn 3.x (see skip below) until all three holdouts ship a syn-3-compatible release. REMOVAL TRIGGER: once `cargo tree -i syn` (after `cargo update`) shows only one syn version, delete this skip and the syn-3 skip below together, then confirm `cargo deny check bans` passes with no unmatched-skip/unnecessary-skip warnings before landing the removal."

[[bans.skip]]
name = "syn"
version = "3"
reason = "clap_derive >=4.6.4, futures-macro >=0.3.34, serde_derive >=1.0.229, and thiserror-impl >=2.0.19 have migrated to syn 3.x (the versions pulled in by Dependabot PRs #727/#730/#688/#729, 2026-09). Dual version with syn 2.x (see skip above) is unavoidable until every syn-2 holdout (pear_codegen/proc-macro2-diagnostics via figment's pear feature, tracing-attributes via tracing) ships a syn-3 release. REMOVAL TRIGGER: same as the syn 2 skip above — remove both entries together once the tree resolves to a single syn version."
```

This was validated empirically in the throwaway worktree: with all four PR bumps applied
(`cargo update -p thiserror@2.0.18 --precise 2.0.20 -p futures --precise 0.3.34
-p clap --precise 4.6.6 -p serde --precise 1.0.229`) plus this exact skip pair appended to a
scratch copy of `deny.toml`, `cargo deny check bans` no longer reports the `syn` duplicate
error — the only remaining error is the unrelated `windows_i686_gnullvm` collateral finding
from §7, which is specific to the `clap` bump and needs its own handling in PR #727's review.

**Sequencing recommendation:**
1. Land the `syn` skip pair above as its own small, reviewed PR (references this
   investigation doc), independent of the four Dependabot PRs.
2. Merge #729 (thiserror), #730 (futures), #688 (serde) — these only trip the syn duplicate,
   which the skip resolves.
3. Hold #727 (clap) until the `windows_i686_gnullvm` collateral finding (§7) is separately
   understood/resolved — merging it today would still fail `cargo deny check` even with the
   syn skip in place.
4. Track removal: re-run `cargo tree -i syn` on a cadence (e.g. next `cargo-mutants`/dependency
   sweep) and drop both skip entries the moment `pear_codegen`/`proc-macro2-diagnostics`/
   `tracing-attributes` all have syn-3 releases — expected to be weeks-to-months out given the
   fast pace of the other four crates' migrations.

## Appendix: commands used

```bash
git worktree add --detach <scratch>/syn-investigation HEAD   # at develop@01e278fc
cd <scratch>/syn-investigation
cargo tree -i syn                                             # holdout enumeration
curl -s -A "<UA>" https://crates.io/api/v1/crates/<crate>                       # latest version
curl -s -A "<UA>" https://crates.io/api/v1/crates/<crate>/<ver>/dependencies    # syn req at a version
cargo update -p <crate>[@<current>] --precise <target>         # simulate a Dependabot bump
cargo deny check bans                                          # reproduce/verify the failure
git worktree remove <scratch>/syn-investigation                # cleanup (worktree left clean)
```
