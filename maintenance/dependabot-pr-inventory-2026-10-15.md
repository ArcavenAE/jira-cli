# Dependabot PR Inventory — 2026-10-15 (Maintenance Sweep 1, read-only)

Baseline: origin/develop @ fb9d015c (v0.8.0-dev.2 release commit, committed 2026-10-05). No PRs were merged, approved, commented, labelled, rebased or closed. Throwaway worktree/refs under /private/tmp/claude-501/ were used; the worktree and temp refs are removed (target dir /private/tmp/claude-501/jr-dep-target left behind; it was blocked from deletion by a hook, safe to `rm -rf`).

## HEADLINE FINDING (affects every PR)

**develop itself fails `cargo deny check` (advisories) today.** rustls 0.23.45 (locked) is hit by four new advisories: RUSTSEC-2026-0346, -0347, -0348, -0349. Patched in rustls >= 0.23.46 (published 2026-10-14). So the "Deny (licenses + vulnerabilities)" failure on #918/#917 (and any PR run after ~2026-10-14) is a real, base-state failure, not caused by the PR. Verified locally on a clean origin/develop worktree: `advisories FAILED, bans ok, licenses ok, sources ok`. Because Deny feeds ci-gate, no PR can go green until a `rustls` bump lands (lockfile-only `cargo update -p rustls` to 0.23.46 should do it). Recommend this be the first fix, ahead of any PR merging.

## Per-PR inventory

All 5 Actions PRs are 0 commits behind develop (merge-base = fb9d015c). Cargo PRs are 19 / 44-45 behind (Dependabot branches carry a "Merge develop" commit, so they are stale-based).

| PR | Change | Files | Behind | Mergeable | CI Gate / failing checks | Stale-base vs real |
|---|---|---|---|---|---|---|
| #918 | actions/download-artifact 8.0.1 -> 8.0.2 | backfill-release, ci, mutants-nightly, release, sign-and-publish .yml | 0 | MERGEABLE (BLOCKED by required check) | FAIL: Deny only (RUSTSEC-2026-0346..0349 on rustls 0.23.45) | Real base-state failure (develop has it), not PR-caused |
| #917 | step-security/harden-runner 2.21.1 -> 2.22.1 | 11 workflow files (33 uses lines) incl. ci.yml, scorecards | 0 | MERGEABLE (BLOCKED) | FAIL: Deny only (same advisories) | Same; touches ci-gate job (see Task 4) |
| #915 | taiki-e/install-action 2.87.17 -> 2.87.26 | ci.yml, mutants-nightly.yml | 0 | MERGEABLE (BLOCKED) | FAIL: Test (macos-latest) CANCELLED at ~15m (job timeout/runner stall; no failed step) | Flaky/infra; needs re-run |
| #914 | dtolnay/rust-toolchain 02cb101e -> e2a55d2f (master tip, "Safely handle action inputs") | backfill-release, ci, e2e-sweeper, e2e, release, sign-and-publish | 0 | MERGEABLE (BLOCKED) | statusCheckRollup empty at query time, but CI run 37940356951 and Dependency Review run on 2026-10-09 are `success`. Predates the rustls advisories (2026-10-14); a re-run would now fail Deny. | Stale result; effectively unverified against current develop |
| #892 | github/codeql-action/upload-sarif 4.38.1 -> 4.38.2 | scorecards.yml | 0 | MERGEABLE (BLOCKED) | CI Gate FAIL because 13 checks CANCELLED/failed after ~15m on 2026-10-05 (all jobs started 20:08Z, all ran 15m3s then died; Windows clippy succeeded, ubuntu jobs incl. Format and gitleaks cancelled) | **Not a Clippy code failure.** The "Clippy (ubuntu)" job was cancelled with zero failed steps; the whole run was a runner outage/timeout on 2026-10-05. Stale infra failure; needs re-run (will then hit the rustls Deny issue) |
| #885 | serde_json 1.0.151 | Cargo.lock | 19 | MERGEABLE (BLOCKED) | No checks reported (rollup empty) | No CI evidence; head is stale |
| #883 | rand 0.10.3 | Cargo.lock | 19 | MERGEABLE (BLOCKED) | No checks reported | No CI evidence; head is stale |
| #855 | comfy-table =7.2.2 -> =8.0.0 (major) | Cargo.toml, Cargo.lock | 45 | MERGEABLE (BLOCKED) | FAIL: Clippy (win, ubuntu), Test (3 OS), MSRV, Coverage | Real compile break (see Task 3), CI was from 2026-09-21 |
| #854 | reqwest 0.13.4 -> 0.13.5 | Cargo.lock | 44 | MERGEABLE (BLOCKED) | FAIL: Deny only: `error[duplicate]: found 2 duplicate entries for crate 'base64'` (run 2026-09-21) | Real, but depends on #842 (Task 2) |
| #842 | base64 0.22.1 -> 0.23.1 (Cargo.toml `"0.22"` -> `"0.23"`) | Cargo.toml, Cargo.lock | 44 | MERGEABLE (BLOCKED) | FAIL: Deny only (duplicate base64 again) | Real, resolved only together with #854 plus more (Task 2) |

Closed/superseded confirmation: #900 (dtolnay 7e38f4b4) CLOSED 2026-10-09 unmerged, superseded by #914 (e2a55d2f). #912 (install-action 2.87.21) CLOSED 2026-10-06 unmerged, superseded by #915. Also closed: #916 (harden-runner 2.22.0, superseded by #917), #913 (2.87.22), #893, #889, #884. #882 (2.87.17) is the merged predecessor.

## Task 2 — base64 / reqwest duplicate-version ban (#854 + #842 combined)

Method: throwaway worktree on origin/develop, cherry-picked the two non-merge Dependabot commits (725a3474 reqwest, 601e79e1 base64). Only Cargo.lock conflicted (both edit it); resolved by taking the reqwest lock then running `cargo metadata` to re-resolve minimally. Result diff vs develop: Cargo.toml `base64 = "0.23"`, lock adds base64 0.23.1, reqwest 0.13.5. No other packages moved.

Results on the combined state:

| Check | Result |
|---|---|
| `cargo build` | PASS |
| `cargo clippy --all-targets -- -D warnings` | PASS |
| `cargo test` | PASS (all suites ok, 0 failed) |
| `cargo deny check` | FAIL: bans (duplicate base64) AND advisories (the pre-existing rustls issue) |

**The duplicate-version ban does NOT clear with #854 + #842 alone.** Remaining base64 0.22.1 consumers (`cargo tree -i base64@0.22.1`):
- `hyper-util 0.1.20` (normal dep; reached via reqwest 0.13.5 and hyper-rustls 0.27.7, and wiremock dev-dep)
- `wiremock 0.6.5` (dev-dependency; `base64 ^0.22`, and 0.6.5 is the latest wiremock release)

reqwest 0.13.5 and jr directly use base64 0.23.1.

Follow-up experiment (not part of "update-free" application): `cargo update -p hyper-util --precise 0.1.21` (hyper-util 0.1.21, published 2026-09-24, MSRV 1.85, declares optional `base64 ^0.23`). Note plain `cargo update -p hyper-util` locked nothing; `--precise` was required. This also moves hyper 1.8.1 -> 1.12.0, want 0.3.1 -> 0.3.2 and removes pin-utils. After it, `cargo deny check bans` no longer reports base64 even though wiremock (dev-dep) still pulls 0.22.1, but it newly reports `duplicate: windows_i686_gnullvm` (0.52.6 via windows-targets/windows-sys 0.52 vs 0.53.1 via windows-sys 0.60) — a ban that was not firing on develop. I did not investigate why the base64 dev-dep duplicate is not flagged in that state or why the windows crate split appears; treat it as an open question. Build with that lock succeeded. So the clean path likely needs: #854 + #842 + hyper-util 0.1.21 (+ hyper 1.12) and then either a `[[bans.skip]]` for windows_i686_gnullvm or a further lock tweak. Alternatively add a `[[bans.skip]] name="base64" version="0.22"` (reason: wiremock 0.6.5 dev-dep and hyper-util 0.1.20), consistent with the existing skip entries in deny.toml.

simd-unsafe: base64 0.23.1 has `default = ["std", "simd-unsafe"]`, and jr declares `base64 = "0.23"` with default features, so `simd-unsafe` IS enabled in jr's graph (`cargo tree -e features -i base64@0.23.1` shows `base64 feature "simd-unsafe"` via `default`). reqwest 0.13.5 also takes base64 with defaults. `cargo deny check` does not flag it: deny.toml has no `[bans.features]` rules and no unsafe policy; advisories/bans/licenses/sources have no unsafe check. The only unsafe-related policy found is CLAUDE.md prose ("No unsafe code without explicit justification" for jr's own code), and `src/` has no `forbid(unsafe_code)`/`deny(unsafe_code)`. Dependency unsafe is not policed by tooling. Decision for the human: accept the default, or set `base64 = { version = "0.23", default-features = false, features = ["std"] }` in jr's own Cargo.toml to avoid enabling it for jr's own use (reqwest will still enable defaults on its own copy, so the feature stays on in the graph either way).

## Task 3 — #855 comfy-table 8.0.0 compile errors

Applied 47ea00ba onto develop; `cargo build --all-targets`:

```
error[E0599]: no method named `load_preset` found for struct `comfy_table::Table` in the current scope
  --> src/output.rs:13:10   (table.load_preset(UTF8_FULL_CONDENSED))
error[E0599]: no method named `load_preset` found for struct `comfy_table::Table` in the current scope
  --> src/output.rs:117:10  (table.load_preset(UTF8_FULL_CONDENSED))
error: could not compile `jr` (lib) due to 2 previous errors
error: could not compile `jr` (lib test) due to 2 previous errors
```

Cause (comfy-table 8.0.0 changelog): `Table::load_preset`, `set_style`, `style`, `TableComponent`, `modifiers` removed; presets are now `TableStyle` consts, loaded via the new `Table::load_style(style)`.

Scope: tiny. Only `src/output.rs` (2 call sites, lines ~13 and ~117, plus the import at line 3 `presets::UTF8_FULL_CONDENSED` which still resolves). `src/cli/user.rs` only imports `Color` (unaffected). No other src/ or tests/ uses of removed APIs.

Sizing experiment (discarded, not committed): `sed s/.load_preset(/.load_style(/` in `src/output.rs`, then `cargo test` — compiles and the full suite passes (0 failed, including output.rs sanitizer/render tests and snapshot tests). So the adaptation is a 2-line rename, apparently rendering-identical for the preset in use. Not yet checked: clippy, MSRV 1.88 (comfy-table 8.0.0 MSRV unverified), Windows. Note the Cargo.toml comment about the exact pin `=7.2.2` should be updated to `=8.0.0` wording by whoever lands it (PR already changes the value; comment references 7.2.2 behavior).

## Task 4 — GitHub Actions SHA pin verification

All five PRs pin full 40-char commit SHAs with a version comment. Verified via GitHub API (tag ref -> deref annotated tag objects):

| PR | Action | Pinned SHA | Tag | Tag deref SHA | Match |
|---|---|---|---|---|---|
| #918 | actions/download-artifact | 9000827ccba6bdab643e8b6fd33ac0654aef8333 | v8.0.2 (lightweight, commit) | 9000827c... | yes (comment says `# v8`, not exact version) |
| #917 | step-security/harden-runner | ccd8616d44fd3846e67624a50d5aad6d37bf2d25 | v2.22.1 (commit) | ccd8616d... | yes |
| #915 | taiki-e/install-action | f7e5d7c961414b23f5b25b2da9294395d08513ad | v2.87.26 (commit) | f7e5d7c9... | yes |
| #914 | dtolnay/rust-toolchain | e2a55d2ffb04f378e9626c28d38b36d230d1e12f | none (tracks `master` branch tip, 2026-10-09, "Safely handle action inputs", PR #187) | n/a: it is master HEAD; matches branch | yes, branch pin (no tag exists); comments say `stable` / `1.88.0` but SHA is the one master commit |
| #892 | github/codeql-action/upload-sarif | 2892aa5e19bbd11bc0cff5427e3b750a04d9e3c2 | v4.38.2 (annotated tag) | 2892aa5e... | yes, after dereferencing the tag object |

Notes:
- #914: dtolnay/rust-toolchain has no version tags in use; the repo pins master tip. This is a behavior change in the action's input handling ("Safely handle action inputs"); CI on 2026-10-09 was green including the msrv job (`toolchain: "1.88.0"` + `RUSTUP_TOOLCHAIN`), but that result predates the rustls advisories. #914 updates the msrv job line (ci.yml ~291 region, `# 1.88.0`). CLAUDE.md's Gotcha text cites msrv pin SHA 6c977a6c...; develop's ci.yml actually uses 02cb101e for the msrv job, so that CLAUDE.md gotcha is stale (doc drift, flag for the sweep).
- #918's comment stays `# v8` (tag v8.0.2 within moving v8 line); fine.

ci-gate decision-path touch check (ci-gate job in develop ci.yml is lines ~718-752; its two `uses:` are harden-runner at L743 and actions/checkout at L747; neither `scripts/check-ci-gate.sh`, `tests/ci_gate_completeness.rs`, `tests/common/wf.rs`, `scripts/lib/trusted-jq.sh` nor `scripts/mutants-aggregate.sh` is modified by any of the five PRs):
- **#917 DOES touch the ci-gate job**: its ci.yml diff includes a hunk at ~L740 that bumps the harden-runner `uses:` inside `ci-gate` (the unpinned-by-tests `uses:` value class CLAUDE.md calls NOT enforced). Needs the human `uses:`-value review the CLAUDE.md control specifies. SHA/tag match verified above, which is the substance of that review; flag for explicit human sign-off.
- #918: ci.yml hunks at L526, L652, L666 (not in ci-gate job).
- #915: ci.yml hunks at L292, L394, L520 (not in ci-gate).
- #914: ci.yml hunks at L256, L288 (rust-toolchain in non-gate jobs).
- #892: scorecards.yml only; no ci.yml change.
Still, any ci.yml change is within "six-file review scope" #1; the rest of the five-file set is untouched.

## Suggested ordering (for the orchestrator's consideration, not actioned)

1. Fix base-state Deny failure: `cargo update -p rustls` to >= 0.23.46 (lockfile only), verify `cargo deny check`.
2. Re-run (or let Dependabot rebase) the Actions PRs; #918/#917/#915/#914/#892 are all content-clean (SHAs verified). #917 needs explicit human review for ci-gate job touch.
3. #885/#883: stale lock-only bumps with no CI; rebase then run CI.
4. #854 + #842 together plus hyper-util 0.1.21 (or a documented base64 0.22 `bans.skip`); decide on `simd-unsafe` default feature.
5. #855: 2-line `load_preset` -> `load_style` fix in src/output.rs; verify clippy/MSRV/Windows.
