# windows_i686_gnullvm duplicate-version investigation — clap 4.6.1 → 4.6.6 (PR #727)

**Date:** 2026-09-17
**Baseline:** `develop@5fd65608` (includes the syn 2/3 skip from #826, and merged futures/thiserror/serde/open bumps)
**Method:** Throwaway detached git worktree at
`/private/tmp/claude-501/-Users-zious-Documents-GITHUB-jira-cli/3abc7165-e749-41fe-8c83-e82381615105/scratchpad/wt/jira-cli-clap-investigation`,
created via `git worktree add --detach <path> 5fd65608`. **No file in the main checkout or the
`.factory` worktree was modified.** `cargo --version` = 1.98.1; `cargo-deny` = 0.19.6 (matches
repo tooling).

Repro command: `cargo update -p clap --precise 4.6.6` on top of develop@5fd65608, then
`cargo tree` / `cargo deny check bans` / `cargo deny check`.

---

## 1. Reproduction — exactly ONE duplicated crate

`cargo deny check bans` on baseline (clap 4.6.1): **`bans ok`**, exit 0. (One pre-existing,
unrelated `unmatched-skip` warning for `cpufeatures = ^0.2` — present on baseline too, not
caused by this investigation; leave as-is.)

After `cargo update -p clap --precise 4.6.6`: **`bans FAILED`**, exit 2, with exactly one
`error[duplicate]` block:

```
error[duplicate]: found 2 duplicate entries for crate 'windows_i686_gnullvm'
    windows_i686_gnullvm 0.52.6
    windows_i686_gnullvm 0.53.1
```

Confirmed via `grep -c "error\[duplicate\]"` on the full log — **only one** duplicate-crate
error is produced. No other member of the windows-targets sibling family
(`windows-targets` itself, `windows_aarch64_gnullvm`, `windows_aarch64_msvc`,
`windows_i686_gnu`, `windows_i686_msvc`, `windows_x86_64_gnu`, `windows_x86_64_gnullvm`,
`windows_x86_64_msvc`) or `windows-sys` newly duplicates. Those are all already covered by
the existing S-WIN-3 skip pairs (deny.toml lines ~136–287), which are untouched by the clap
bump — their skip sets remain exactly N−1 versions skipped, one canonical version
un-skipped, same as before.

A full `cargo deny check` (advisories + bans + licenses + sources) on the bumped tree
produces no other new failures — the 3 pre-existing `license-not-encountered` warnings
(BSD-2-Clause, OpenSSL, Unicode-DFS-2016) are present identically on baseline; confirmed via
side-by-side counts. **`windows_i686_gnullvm` is the sole regression the clap 4.6.6 bump
introduces for `cargo deny`.**

## 2. What pulls the new/second reachable path

The `cargo deny` error's dependency trace names the path explicitly (no guessing needed):

```
windows_i686_gnullvm v0.53.1
└── windows-targets v0.53.5
    └── windows-sys v0.60.2
        ├── anstyle-query v1.1.5
        │   └── anstream v1.0.0
        │       └── clap_builder v4.6.6
        │           └── clap v4.6.6 → clap_complete v4.6.9 / jr
        ├── dirs-sys v0.5.0 → dirs v6.0.0 → jr
        ├── keyring v3.6.3 → jr                    (pre-existing S-WIN-3 path)
        ├── nu-ansi-term v0.50.3 → tracing-subscriber v0.3.23 → jr
        └── socket2 v0.6.3 → tokio/hyper-util/reqwest chain
```

versus the pre-existing/unchanged other side of the duplicate:

```
windows_i686_gnullvm v0.52.6
└── windows-targets v0.52.6
    └── windows-sys v0.52.0
        ├── colored v3.1.1 → jr  (direct dep)
        ├── errno v0.3.14 → rustix → crossterm/tempfile chain
        ├── rustls-platform-verifier v0.6.2 → reqwest
        ├── tempfile v3.27.0
        └── winapi-util v0.1.11 → same-file/walkdir → jni (build-dep)
```

**Root cause, empirically verified via lockfile diff:** at clap 4.6.1 (baseline),
`anstream`/`anstyle-query` (clap_builder's transitive terminal-color-detection deps) resolved
to `windows-sys 0.61.2` — the pre-existing "broad graph" canonical duplicate that was already
accounted for by the S-WIN-3 `windows-sys 0.61` skip, and which does **not** independently
pull `windows-targets`/`windows_i686_gnullvm` into a new reachable state (windows-sys 0.61's
own arch-crate sub-deps are a separate, already-unified lineage). At clap 4.6.6, the same
`anstream`/`anstyle-query` pair (crate versions unchanged — only their resolved `windows-sys`
pick changed) now resolves to **`windows-sys 0.60.2`** instead. `windows-sys 0.60` was
*already* present in the tree (via keyring's windows-native feature) and *already* skipped —
but that pre-existing 0.60 path only fed `windows-targets 0.53.5` / `windows_i686_gnullvm
0.53.1` from **one** direction. Adding `anstream`/`anstyle-query`/`clap_builder` as a **second,
independent** consumer of the same `windows-sys 0.60.2` → `windows-targets 0.53.5` →
`windows_i686_gnullvm 0.53.1` chain is what flips cargo-deny's reachability check for this one
specific arch crate from "single reachable version" (pass) to "two reachable versions"
(duplicate error) — confirmed with `cargo tree --target=all -i windows_i686_gnullvm@<ver>` on
both the baseline and bumped trees (baseline: `0.53.1` reachable only via
`keyring`; `0.52.6` reachable via `--target=all` at all — see caveat below).

**Confirmed via lockfile diff** (`cargo update -p clap --precise 4.6.6`, no other package
changed version): only `clap`, `clap_builder`, `clap_derive` bump; `clap_derive` also switches
its `syn` dependency from `syn 2.0.117` to `syn 3.0.6` (this is the syn-2/3 duplicate class
already handled by #826's skip — re-verified present and unaffected here). No other crate
gained or lost a version in Cargo.lock; the *set* of versions for `windows-targets`/
`windows_i686_gnullvm`/`windows-sys` is byte-identical before and after (0.42.2/0.52.6/0.53.5
for windows-targets; 0.52.6/0.53.1 for windows_i686_gnullvm) — the bump changes **reachability
topology**, not the version set.

**Documentation-accuracy side-note (pre-existing, independent of this investigation):**
deny.toml's own S-WIN-3 comment (line 138) attributes the `windows-sys 0.52.0` /
`windows-targets 0.52.6` lineage to "ring (cryptography dep of rustls)". Empirically, `ring`
and `aws-lc-rs` are both present in `Cargo.lock` (0.17.14 / 1.18.1) but **neither appears** in
`cargo tree --target=all -i windows-sys@0.52.0` on baseline — that query returns "nothing to
print" on baseline, i.e. cargo tree's own resolution doesn't reach it there at all, while
cargo-deny's own graph walk (post-bump) attributes the 0.52.0 lineage instead to `colored`
(jr's direct dep), `errno`/`rustix`/`tempfile`, `rustls-platform-verifier`, and
`winapi-util`/`walkdir`/`jni` (build-dep). This looks like a stale attribution comment,
similar in kind to the already-documented rand-0.9-vs-0.10 "Cargo-lock placeholder that never
enters the actual build" phenomenon (deny.toml lines 58–69) — **flagging for a separate,
future doc-accuracy pass; not blocking, not touched here, not part of this fix.**

## 3. Convergence feasibility — checked against crates.io, verdict: **NOT-CONVERGEABLE-NOW**

Checked live crates.io max-stable-version + per-version dependency manifests for every crate
in the windows-sys/windows-targets family chain (`jni`, `rustls-platform-verifier`, `keyring`,
`ring`, `aws-lc-rs`, `windows-sys`, `windows-targets`, `anstream`, `anstyle-query`):

| Crate | Locked | Latest stable | Latest's windows-sys req |
|---|---|---|---|
| `jni` | 0.21.1 (build-dep, via rustls-platform-verifier) | 0.22.4 | `^0.61` + `windows-link ^0.2` (**drops 0.45!**) |
| `rustls-platform-verifier` | 0.6.2 (requires `jni ^0.21`) | 0.7.0 (requires `jni ^0.22.4`) | n/a |
| `keyring` | 3.6.3 (direct windows-sys dep via windows-native feature) | 4.2.0 | drops direct windows-sys entirely — moves to a separate `windows-native-keyring-store` plugin crate (breaking API restructure, `Entry`/`CredentialBuilder` surface changes) |
| `ring` | 0.17.14 | 0.17.14 (current) | n/a (see doc-accuracy note above — may not be the real 0.52 consumer) |
| `aws-lc-rs` | 1.18.1 | 1.18.1 (current) | n/a |
| `windows-sys` | 0.45/0.52/0.60/0.61 (4 lineages) | 0.61.2 | — |
| `anstream` / `anstyle-query` | 1.0.0 / 1.1.5 (unchanged by clap bump) | 1.0.0 / 1.1.5 (current) | resolves `windows-sys` per caret range; picked 0.60 this time, previously 0.61 |

**Interesting adjacent finding (not this PR's fix, but worth tracking separately):** `jni`
0.22.4 has already dropped `windows-sys 0.45` in favor of `^0.61`, which would collapse the
**0.45 lineage** into the existing 0.61 "broad graph" canonical version if adopted. But
`rustls-platform-verifier` (which pins jr's transitive `jni` requirement) needs its own
0.6→0.7 bump to allow `jni ^0.22.4`, and 0.6→0.7 is itself a semver-breaking jump for a 0.x
crate that `reqwest` (jr's direct dep, currently on `reqwest 0.13.4`) would need to adopt —
unverified whether `reqwest 0.13.4`'s `Cargo.toml` range already permits
`rustls-platform-verifier 0.7`, and out of scope to test here since it's unrelated to clap.
**This would not fix the windows_i686_gnullvm 0.52-vs-0.53 split anyway** — it only touches
the separate 0.45-lineage skip triplet, leaving the 0.52/0.53 split (the one clap 4.6.6
actually breaks) untouched.

`keyring` 4.x would eliminate keyring's own direct windows-sys pin, but is a major breaking
API migration (credential-store plugin architecture) — far outside the scope of a Dependabot
clap patch bump, and not something to bundle into PR #727.

**Verdict: no released version set today unifies `windows-targets`/`windows_i686_gnullvm`
0.52.6 vs 0.53.1 onto a single major without a keyring 4.x migration (breaking) or a
speculative future anstream/anstyle-query release reverting its windows-sys pick back to
0.61.** This mirrors the syn-2/3 precedent from #826: transitional skip, not upstream fix, is
the right move for a dependency-patch PR.

## 4. Recommendation — add a `[[bans.skip]]` pair, validated empirically

**Verified in the throwaway tree:** adding the skip block below (plus, ideally, updating the
now-stale doc comment above it) makes `cargo deny check bans` — and the full `cargo deny
check` (advisories/bans/licenses/sources) — pass cleanly with clap 4.6.6 applied. No
`unnecessary-skip` warning is produced (confirmed: the resulting warning set is byte-identical
to baseline's pre-existing, unrelated `cpufeatures`/license warnings).

### Exact `[[bans.skip]]` block to add (insert immediately after the existing
`windows_x86_64_msvc` "0.53" skip entry, i.e. after current deny.toml line ~287, before the
`cpufeatures` skip):

```toml
[[bans.skip]]
name = "windows_i686_gnullvm"
version = "0.53"
reason = "transitive arch crate for windows-targets 0.53.5, now reachable via TWO independent paths as of the clap 4.6.6 bump (PR #727): (1) windows-sys 0.60 via keyring v3.6.3's windows-native feature (pre-existing, S-WIN-3), and (2) windows-sys 0.60 via clap_builder 4.6.6 -> anstream 1.0.0 -> anstyle-query 1.1.5, whose windows-sys resolution shifted from 0.61 (clap 4.6.1, an already-exempt canonical duplicate that did not reach this arch crate as a second path) to 0.60 as of this bump. windows-targets 0.52.6 (via windows-sys 0.52) remains canonical/un-skipped. Unlike its six sibling arch crates (windows_aarch64_gnullvm, windows_aarch64_msvc, windows_i686_gnu, windows_i686_msvc, windows_x86_64_gnu, windows_x86_64_msvc), windows_i686_gnullvm has no 0.42 lineage (the i686-gnullvm stub did not exist in the windows 0.42 generation jni's windows-sys 0.45 pulls), so only this ONE skip is needed to leave a single canonical un-skipped version, versus the paired 0.42/0.53 skips those siblings carry. Unavoidable until jni and keyring converge on the same windows-sys version (see the S-WIN-3 block above), or a future anstream/anstyle-query release reverts to windows-sys ^0.61. Removal trigger: re-run `cargo tree --target=all -i windows_i686_gnullvm@0.53.1` after any keyring/jni/anstream/clap bump -- if it no longer shows a concurrently-reachable second path alongside windows-targets 0.52.6, remove this skip (an unremoved skip with only one remaining version produces an `unnecessary-skip` warning, per cargo-deny 0.19.6)."
```

### Companion doc-comment fix (same PR, not optional — the existing comment directly
contradicts the new skip and must not ship self-contradictory):

Replace the current block (deny.toml, current lines ~178–186):

```
# The 7 skipped arch crates are: windows_aarch64_gnullvm, windows_aarch64_msvc,
# windows_i686_gnu, windows_i686_msvc, windows_x86_64_gnu, windows_x86_64_gnullvm,
# windows_x86_64_msvc. windows_i686_gnullvm is deliberately NOT skipped: it exists
# in Cargo.lock only at 0.52.6 and 0.53.1 (the i686-gnullvm stub did not exist in
# the windows 0.42 generation). Because these are Windows-only crates, cargo-deny
# does not flag them as multiple-version violations when run on Linux or macOS CI
# (they are absent from the resolved dependency graph on those platforms). A skip
# entry for either version would produce an `unmatched-skip` error on those runners.
```

with something like:

```
# 8 arch crates are now skipped total: windows_aarch64_gnullvm, windows_aarch64_msvc,
# windows_i686_gnu, windows_i686_gnullvm, windows_i686_msvc, windows_x86_64_gnu,
# windows_x86_64_gnullvm, windows_x86_64_msvc.
#
# windows_i686_gnullvm was ORIGINALLY left unskipped: it has no 0.42 lineage, and prior
# to the clap 4.6.6 bump (PR #727) only one of its two Cargo.lock-listed versions (0.52.6
# vs 0.53.1) was concurrently reachable in cargo-deny's resolved graph, so no skip was
# needed and the "absent from the resolved graph on non-Windows CI" reasoning held. The
# clap 4.6.6 bump added a second concurrently-reachable path to 0.53.1 (clap_builder ->
# anstream -> anstyle-query's windows-sys resolution shifting from 0.61 to 0.60,
# alongside keyring's pre-existing windows-sys 0.60 path) -- verified via `cargo deny
# check bans`, which now flags it as a duplicate on macOS/Linux CI. A skip entry (below)
# is required as of this bump; if a future dependency shift removes the second path,
# this skip becomes an unnecessary-skip and should be removed (see its reason text for
# the exact re-check command).
```

### Empirical validation performed (throwaway tree only)

1. `cargo deny check bans` on develop@5fd65608 unmodified: `bans ok`, exit 0.
2. `cargo update -p clap --precise 4.6.6`; `cargo deny check bans`: `bans FAILED`, exit 2, one
   `error[duplicate]` for `windows_i686_gnullvm` (0.52.6 vs 0.53.1) — full trace captured
   above.
3. Inserted the exact skip block above into the throwaway `deny.toml`; re-ran
   `cargo deny check bans`: **`bans ok`, exit 0** — only the pre-existing, unrelated
   `cpufeatures` `unmatched-skip` warning remains (present identically on baseline).
4. Ran full `cargo deny check` (all four lint categories) with the skip applied:
   **`advisories ok, bans ok, licenses ok, sources ok`**, exit 0 — the 3 pre-existing
   `license-not-encountered` warnings (BSD-2-Clause, OpenSSL, Unicode-DFS-2016) are present
   identically on baseline (confirmed via side-by-side count), i.e. no new licensing or
   advisory regression from the clap 4.6.6 bump.
5. No other duplicate/ban violation of any kind was observed with clap 4.6.6 applied, before
   or after the fix, beyond the single `windows_i686_gnullvm` entry documented above.

## Summary for the human

- **Duplicated crates introduced by clap 4.6.6 (PR #727):** exactly one —
  `windows_i686_gnullvm` (0.52.6 vs 0.53.1). No other windows-targets sibling arch crate,
  `windows-targets` itself, or `windows-sys` is newly duplicated; the existing S-WIN-3 skip
  set is untouched and still correct.
- **Root cause:** clap_builder 4.6.6's transitive `anstream`/`anstyle-query` dependency now
  resolves to `windows-sys 0.60.2` (previously `0.61.2` on clap 4.6.1) — an already-skipped
  windows-sys version, but this specific shift adds a second independent path into the
  pre-existing `windows-targets 0.53.5` → `windows_i686_gnullvm 0.53.1` sub-lineage (alongside
  keyring's), which flips cargo-deny's per-crate reachability count from one to two for this
  one arch crate only.
- **Verdict:** NOT-CONVERGEABLE-NOW. No released version set unifies the windows-targets
  0.52-vs-0.53 split today without a breaking `keyring` 4.x migration (unrelated, far larger
  scope) or a speculative future anstream/anstyle-query reversion. (A separate, unrelated
  convergence opportunity exists for the windows-sys **0.45** lineage via `jni 0.22.4` +
  `rustls-platform-verifier 0.7.0`, but that doesn't touch this 0.52-vs-0.53 split and needs
  its own investigation/PR if pursued.)
- **Recommendation:** add the one `[[bans.skip]]` block drafted in §4 above (transitional,
  same pattern/tone as the existing S-WIN-3 windows-targets-family skips), plus update the
  now-contradicted doc comment directly above it in the same PR. Empirically validated in a
  throwaway worktree to make `cargo deny check` pass cleanly with clap 4.6.6 applied, with no
  other regressions.
- **Nothing in the real repo was changed.** This file is the only artifact written; the
  throwaway worktree used for validation is not part of the main checkout or the `.factory`
  worktree and can be discarded.
