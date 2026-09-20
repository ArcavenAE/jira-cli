# Dependency Audit — 2026-09-19 Maintenance Sweep

**Scope:** read-only. No `src/`, `.factory/`, or `deny.toml` files were modified. No commits made.
**Repo tip audited:** `develop` @ `3d9ca35e`
**Tools:** `cargo-deny 0.19.6` (local) vs `cargo-deny 0.20.2` (pinned in CI's `EmbarkStudios/cargo-deny-action`) — both agree on the findings below; version mismatch noted as informational only. `cargo-audit 0.22.1` (installed fresh, was missing on host).

## Summary Table

| # | Finding | Severity | Fixable? | Recommendation |
|---|---|---|---|---|
| 1 | `cargo deny check` — advisories/bans/licenses/sources all `ok` on develop tip | — | — | No action; healthy baseline |
| 2 | `cargo audit` — 0 vulnerabilities found across 360 crates | — | — | No action |
| 3 | `windows_i686_gnullvm = ^0.53` skip → `unnecessary-skip` warning (only 1 version now reachable) | LOW | Automated-fixable | Remove the skip entry (housekeeping PR) |
| 4 | `cpufeatures = ^0.2` skip → `unmatched-skip` warning (crate no longer present; sha1 0.11.0 + chacha20 now both resolve to cpufeatures 0.3.0) | LOW | Automated-fixable | Remove the skip entry (housekeeping PR) |
| 5 | `syn` 2/3 dual-version skips | — | N/A | **Still needed** — do NOT remove; tree genuinely has syn 2.0.117 + syn 3.0.6 |
| 6 | 3 stale license allowances (`BSD-2-Clause`, `OpenSSL`, `Unicode-DFS-2016`) never matched by any crate in the tree | LOW | Automated-fixable | Remove from `[licenses] allow` (housekeeping PR) |
| 7 | PR #842 (base64 0.22.1→0.23.1) fails `Deny` + `CI Gate` | MEDIUM | Needs-judgment (policy-file change or hold) | **HOLD** — do not merge as-is |
| 8 | PR #841 (saphyr-parser 0.0.11→0.0.12, exact pin) | — | — | **Safe to merge** |
| 9 | PR #837 (taiki-e/install-action bump) | — | — | Merge |
| 10 | PR #838 (windows-sys 0.60.2→0.61.2) | — | — | Merge |
| 11 | PR #839 (glob 0.3.3→0.3.4) | — | — | Merge |
| 12 | PR #840 (libc 0.2.183→0.2.189) | — | — | Merge |

---

## 1. `cargo deny check` (Task 1)

Result: **`advisories ok, bans ok, licenses ok, sources ok`** — zero errors, deny check exits 0 on develop tip. All findings below are warnings only (do not fail the check).

### Warnings emitted

- `warning[license-not-encountered]` ×3 — `BSD-2-Clause` (deny.toml:8), `OpenSSL` (deny.toml:15), `Unicode-DFS-2016` (deny.toml:13). None of these three license strings are actually used by any crate currently in the dependency graph. Safe, mechanical cleanup: delete the three lines from `[licenses] allow`. LOW severity, no functional risk — cargo-deny would simply re-add the warning if a future dependency reintroduces one of these licenses (fail-open, not fail-closed, so no risk of silently missing a real license).

- `warning[unnecessary-skip]` — **`windows_i686_gnullvm = ^0.53`** (deny.toml:297-299). Verified independently via `cargo tree -i windows_i686_gnullvm@0.52.6 --target=all` → **"nothing to print"** (not actually reachable in the build graph), while `@0.53.1` resolves through `windows-targets 0.53.5 → windows-sys 0.60.2 → {jr, keyring}`. Despite `windows-targets 0.52.6` existing in `Cargo.lock` (pulled by `ring` via an older `windows-sys 0.52`), it apparently does not pull the `i686-gnullvm` arch stub into cargo-deny's evaluated graph, so only ONE version of `windows_i686_gnullvm` is truly duplicated-flagged. **This is the "one of two 2026-09-16 entries" the task asked about — it is now stale and removable.** Note: PR #838 (open, green) bumps jr's direct `windows-sys` pin from 0.60→0.61, which will further reshuffle this dependency's resolution — re-verify with `cargo tree --target=all -i windows_i686_gnullvm` after #838 merges before actually deleting the skip, per the skip's own documented "Removal trigger."

- `warning[unmatched-skip]` — **`cpufeatures = ^0.2`** (deny.toml:302-304, "Authorized DEC-185"). Verified via `cargo tree -i cpufeatures --target=all`: both `sha1 v0.11.0` (jr's own dep — note Cargo.toml already declares `sha1 = { version = "^0.11" }`, newer than the skip comment's stale "sha1 v0.10.7" text) and `chacha20 v0.10.2` (via `rand v0.10.2`) now resolve to the **same** `cpufeatures v0.3.0`. The split this skip was authorized for no longer exists. This skip was **not** part of the 2026-09-16 sweep (it predates it, "DEC-185") but is independently stale as of this audit — flagging it since the task asked to check "temporary" skips generally and this one is now provably unneeded.

- **`syn` 2 and `syn` 3 skips (deny.toml:87-94): still fully justified, do NOT remove.** Confirmed via `cargo tree -i syn` → ambiguous between `syn@2.0.117` and `syn@3.0.6`, both genuinely present (no `unnecessary-skip`/`unmatched-skip` warning fired for either). The documented holdouts (`pear_codegen`/`proc-macro2-diagnostics` via figment's `pear` feature; `tracing-attributes` via `tracing`) have not yet shipped syn-3 releases. Task's phrasing grouped "syn 2/3, windows_i686_gnullvm 0.53" as "two entries from the 2026-09-16 sweep" — of those, only the `windows_i686_gnullvm` skip is now removable; the syn pair is still load-bearing.

**Net recommendation for Task 1:** open a small housekeeping PR removing the 3 stale license allowances + the `windows_i686_gnullvm` skip + the `cpufeatures` skip (5 mechanical deletions, re-run `cargo deny check` to confirm clean). All LOW severity, zero risk — cargo-deny would immediately re-flag if any deletion were premature. Do not touch the syn skips.

## 2. `cargo audit` (Task 1)

`cargo audit` was missing on this host; installed via `cargo install cargo-audit --locked` (no security-advisory concerns — audit binary itself, standard crates.io install). Ran against `Cargo.lock` (360 crate dependencies, advisory DB freshly fetched from RustSec `advisory-db`, 1251 advisories loaded).

Result (confirmed via `cargo audit --json`): **`vulnerabilities.found: false`, `count: 0`, `warnings: []`**. Zero RUSTSEC advisories, zero unmaintained/yanked warnings. Plain-text `cargo audit` run produced no summary line past "Scanning Cargo.lock for vulnerabilities" in this terminal capture — this is a known cargo-audit 0.22.x quirk (no explicit "0 vulnerabilities" banner line when clean); the `--json` run is the authoritative confirmation (exit code 0 both times).

## 3. PR #842 root cause (Task 2) — base64 0.22.1 → 0.23.1

**FAILS**: `Deny (licenses + vulnerabilities)` and `CI Gate`. All other 20 checks (Format, Clippy ×2, Test ×3, MSRV, Coverage, Spec Guards, Secret Scan, all 8 mutation shards + aggregate, Signing Guard, Dependency Review) are **green**.

### Root cause (confirmed from the actual CI job log, run 35352945506, job "Deny (licenses + vulnerabilities)")

```
error[duplicate]: found 2 duplicate entries for crate 'base64'
  ┌─ Cargo.lock:17:1
17 │ ╭ base64 0.22.1 registry+https://github.com/rust-lang/crates.io-index
18 │ │ base64 0.23.1 registry+https://github.com/rust-lang/crates.io-index

├ base64 v0.22.1
│   ├── hyper-util v0.1.20 → hyper-rustls v0.27.7 → reqwest v0.13.4 → jr
│   ├── reqwest v0.13.4 (*)
│   └── wiremock v0.6.5 → (dev) jr
├ base64 v0.23.1
│   └── jr v0.7.0-dev.7   (direct dep, this PR)

advisories ok, bans FAILED, licenses ok, sources ok
```

This is **not** a license change and **not** a security advisory — it is `deny.toml`'s `[bans] multiple-versions = "deny"` policy tripping on a genuine new duplicate. On the current `develop` tip, `base64` is unified at a single version (0.22.1) across jr's own direct dep, `reqwest 0.13.4`'s transitive stack (`hyper-util 0.1.20` → `hyper-rustls 0.27.7`), and `wiremock 0.6.5`. Confirmed live via `cargo tree -i base64` on develop — single version, no skip entry needed today.

Dependabot's PR bumps **only jr's own direct `Cargo.toml` pin** (`base64 = "0.22"` → presumably `"0.23"`) — `hyper-util 0.1.20` (checked: this is still the latest published `hyper-util` on crates.io as of this audit) has **not yet released** a base64-0.23-compatible version, so the tree splits into two base64 versions and `bans` fails closed, cascading to `CI Gate`.

### Is it fixable?

Yes, in either of two ways — both legitimate, this repo has ample precedent (syn, toml, thiserror, getrandom, etc. all carry exactly this kind of documented dual-version skip):

1. **Hold** (recommended): wait for `hyper-util`/`hyper-rustls` to publish a release depending on `base64 0.23`, then the tree unifies naturally with zero `deny.toml` changes needed. `base64 0.22.1` carries no known RUSTSEC advisory (confirmed via the clean `cargo audit` run above), and `0.23`'s changelog (SIMD engines, `DecodeError` message tweak, custom padding symbols, MSRV bump to 1.71.0) offers no compelling driver for jr to force the upgrade now.
2. **Accept the debt**: add a paired `[[bans.skip]]` for `base64 = "0.22"` and `base64 = "0.23"` mirroring the syn/toml pattern, with a removal trigger tied to `hyper-util` shipping a base64-0.23 release. This is a `deny.toml` policy-file edit and should go through the same maintainer review the file's own header ("Note:" comments) implies for every other skip — not something to auto-merge via Dependabot's own green light.

**Recommendation: HOLD PR #842.** Root cause is transitive-dependency lag, not a jr defect; no urgency (no advisory); the "fix" is a policy-file change that needs deliberate authorship (a DEC-### rationale block), which is out of scope for a straight Dependabot merge.

## 4. PR #841 — saphyr-parser 0.0.11 → 0.0.12 exact-pin assessment (Task 3)

CLAUDE.md documents `saphyr-parser = "=0.0.11"` in `Cargo.toml` as a **deliberate exact pin**: "0.0.x carries no semver guarantee by convention, so a 0.0.x bump can be breaking; the exact pin forces any upgrade through a reviewed Cargo.toml diff rather than a silent `cargo update`." Dependabot's PR #841 **does** produce exactly that reviewed diff (`Cargo.toml` line changed `"=0.0.11"` → `"=0.0.12"` alongside `Cargo.lock`), so the mechanism is working as designed — the question is whether the diff's content is safe.

Investigated via the upstream `saphyr-rs/saphyr` monorepo (the `saphyr-parser` crate lives at `parser/` within it; tag `v0.0.11` → `v0.0.12`, 12 commits, 9 files changed):

- **`parser/CHANGELOG.md`** (the crate jr actually depends on) lists exactly **one** change for v0.0.12: *"`thiserror` was updated to `v2.0.20`."* No other entries.
- All other changed files (`saphyr/src/emitter.rs`, `saphyr/src/encoding.rs`, `saphyr/tests/emitter.rs`, `saphyr/CHANGELOG.md`) belong to the sibling **`saphyr`** crate (the higher-level `Yaml`/`YamlLoader` API) — jr does **not** depend on that crate, only on `saphyr-parser`'s low-level `Parser`/`Event` stream (per CLAUDE.md's explicit note: "never the higher-level `saphyr::Yaml`/`YamlLoader` API"). Those changes (a whole-float emitter fix, a `YamlDecoder` infinite-loop fix on short multibyte input) are irrelevant to jr's usage.
- **Zero changes** to `parser/src/` (the `Parser`/`Event`/`Scanner` module `tests/common/wf.rs` actually calls) between the two tags.
- **MSRV unchanged**: `rust-version = "1.85.0"` in `[workspace.package]` at both `v0.0.11` and `v0.0.12` — matches CLAUDE.md's documented "1.85.0, below this repo's rust-version = 1.88, WITH headroom" claim; the headroom rationale still holds verbatim.
- The `thiserror` bump to `2.0.20` introduces **no new duplicate-version risk**: jr's own direct `thiserror = "2"` dependency already resolves to `2.0.20` in `Cargo.lock` today (confirmed) — saphyr-parser's transitive thiserror requirement lands on a version jr's tree already carries, so this doesn't even touch the existing thiserror-1/thiserror-2 skip pair.
- No changes to YAML 1.1 vs 1.2 line-break/scalar handling in either the parser or its changelog — irrelevant to this bump. (CLAUDE.md's separate note about `saphyr-parser` being YAML-1.2-conformant per se is unaffected — no scanner changes shipped.)

**Verdict: SAFE TO MERGE.** The exact-pin's entire purpose — preventing an *unreviewed* breaking 0.0.x bump — is satisfied: this review found the actual upstream diff for the crate jr depends on is a single transitive dependency-version bump with no API surface change, no MSRV change, and no interaction with jr's own YAML-parsing test logic. Classify as **safe-to-merge**, not needs-maintainer-judgment — though since it touches a file CLAUDE.md calls out by name as "deliberate," a human eyeballing the ~2-line diff before clicking merge is still reasonable process hygiene, not a substantive risk gate.

## 5. Other 4 green Dependabot PRs (Task 3/4)

All four report 0 failing checks (verified via `gh pr view --json statusCheckRollup`, filtered for non-SUCCESS conclusions):

- **#837** `taiki-e/install-action` 2.87.10→2.87.11 — GitHub Actions tooling pin bump (installs `cargo-deny`/`cargo-nextest`/etc. in CI), not a crate dependency. No license/advisory/bans surface at all. **Merge.**
- **#838** `windows-sys` 0.60.2→0.61.2 (jr's own direct Windows DPAPI dependency, `src/api/auth_windows_store.rs`). Diff inspected: bumps jr's own `windows-sys` requirement in `Cargo.toml`; as a side effect `tokio`'s independently-resolved `windows-sys` transitive pin shifts from 0.60.2 to 0.52.0 in `Cargo.lock` (cargo resolver artifact — tokio's own version constraint no longer unifies with jr's new 0.61 pin). `cargo-deny` still reports `bans ok` for this PR (confirmed green), so existing `windows-targets`/`windows_*` skip entries already tolerate this shift — but per the note in Finding #3 above, this bump is exactly the trigger the `windows_i686_gnullvm` skip's own "Removal trigger" text calls out ("re-run `cargo tree` ... after any keyring/jni/anstream/clap bump"); re-verify that skip after this merges. **Merge** (no blocker today).
- **#839** `glob` 0.3.3→0.3.4 — patch bump of a jr direct dev-dependency (used by the mutants-scope-guard tests, S-MUTANTS-SCOPE-GUARDS-1). Trivial patch release. **Merge.**
- **#840** `libc` 0.2.183→0.2.189 — patch-series bump of a jr direct dev-dependency (PG-F4-10, already a resolved transitive dep via tokio/reqwest so this just adds the explicit Cargo.toml edge at a newer version). Trivial. **Merge.**

None of these four interact with the base64 or saphyr-parser findings above.

## Classification Table (Task 4)

| Finding | Severity | Automated-fixable? | Notes |
|---|---|---|---|
| `windows_i686_gnullvm` unnecessary-skip | LOW | Yes | Delete skip block; re-verify after PR #838 merges |
| `cpufeatures` unmatched-skip | LOW | Yes | Delete skip block; sha1 0.11 + chacha20 now unified on 0.3.0 |
| 3 unmatched license allowances | LOW | Yes | Delete 3 lines from `[licenses] allow` |
| `syn` 2/3 dual-version skip | N/A (correctly retained) | N/A | Do not touch — genuinely still needed |
| PR #842 base64 duplicate-version bans failure | MEDIUM | Manual-review (policy decision) | Hold; not a security issue, just needs either upstream `hyper-util` catch-up or a deliberate `deny.toml` skip-pair addition |
| PR #841 saphyr-parser exact-pin bump | — (verified safe) | — | Safe to merge; only change is a same-version thiserror bump already present in jr's own tree |
| PRs #837/#838/#839/#840 | — | — | All green, no license/advisory/bans concerns found; merge |
| No RUSTSEC advisories anywhere in the tree | — | — | `cargo audit` clean, 0/360 crates flagged |

## Merge Recommendations (Task 4, all 6 Dependabot PRs)

| PR | Change | Recommendation |
|---|---|---|
| #837 | taiki-e/install-action 2.87.10→2.87.11 | **Merge** |
| #838 | windows-sys 0.60.2→0.61.2 | **Merge** |
| #839 | glob 0.3.3→0.3.4 | **Merge** |
| #840 | libc 0.2.183→0.2.189 | **Merge** |
| #841 | saphyr-parser 0.0.11→0.0.12 (exact pin) | **Merge** (safe — verified upstream diff is thiserror-only, MSRV unchanged, zero Parser/Event API change) |
| #842 | base64 0.22.1→0.23.1 | **Hold** — fails `Deny`/`CI Gate` due to a genuine new multiple-versions duplicate (`hyper-util 0.1.20` hasn't caught up to base64 0.23 yet); not a security or license issue; either wait for upstream or deliberately author a `deny.toml` skip pair, don't force-merge |
