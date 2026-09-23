# Maintenance Sweep Report — 2026-09-23

**Trigger:** manual (human request — Dependabot-focused maintenance sweep, 7 open PRs).
**Mode:** dependency-only triage. Pipeline stayed **PAUSED** throughout (no cycle ACTIVE;
cycle-009 CLOSED at F7 per `D-375`; cycle-010/011 remain PARKED); no DEC minted. `develop` tip
**unchanged** at `7c5e9309` this sweep — triage is complete, but delivery (merging the 4
ready PRs) is **PENDING human code-owner approval** on the protected `develop` branch. Agent
merge is blocked by branch protection plus the auto-mode "Merge Without Review" guard — none
of the 7 PRs were merged, closed, or otherwise mutated by this sweep. Counts unchanged: 770
BCs / 89 VPs / 118 holdout / 191 stories. `activation_head`/`activation_version` unchanged at
`8b4c797a`/`v0.7.0-dev.8`.

## Scope

Reviewed all 7 open Dependabot PRs against `develop @ 7c5e9309`, checking CI status (including
the required `CI Gate` check and `cargo deny check`) and classifying each into APPLY / HELD /
DEFERRED.

## Triage Table

| # | Dependency | Bump | Ecosystem | CI status | Verdict |
|---|---|---|---|---|---|
| #872 | `codecov/codecov-action` | 7.1.0 → 7.1.1 | GitHub Action (patch) | CI Gate GREEN | **APPLY** — workflow file only, ready |
| #867 | `taiki-e/install-action` | 2.87.12 → 2.87.13 | GitHub Action (patch) | CI Gate GREEN | **APPLY** — workflow file only, ready |
| #866 | `clap` | 4.6.6 → 4.6.7 | cargo (patch) | CI Gate GREEN | **APPLY** — `Cargo.lock` only, ready |
| #865 | `clap_complete` | 4.6.9 → 4.6.10 | cargo (patch) | CI Gate GREEN | **APPLY** — `Cargo.lock` only, ready |
| #854 | `reqwest` | 0.13.4 → 0.13.5 | cargo (patch) | `cargo deny check` FAIL | **HELD** — duplicate-version ban, not fixable by this PR alone |
| #842 | `base64` | 0.22.1 → 0.23.1 | cargo (minor) | `cargo deny check` FAIL | **HELD** — duplicate-version ban, not fixable by this PR alone |
| #855 | `comfy-table` | 7.2.2 → 8.0.0 | cargo (major, breaking) | compile/test/clippy/MSRV FAIL | **DEFERRED** — breaking API change, needs code adaptation |

## APPLY (4) — CI-green, ready to merge; delivery blocked on human code-owner approval

- **#872** `codecov/codecov-action` 7.1.0 → 7.1.1 — GH Action, patch bump, workflow files only.
  Independent of the other 3 — can merge in any order.
- **#867** `taiki-e/install-action` 2.87.12 → 2.87.13 — GH Action, patch bump, workflow files
  only. Independent of the other 3 — can merge in any order.
- **#866** `clap` 4.6.6 → 4.6.7 — cargo, patch bump, `Cargo.lock` only.
- **#865** `clap_complete` 4.6.9 → 4.6.10 — cargo, patch bump, `Cargo.lock` only.

**Delivery ordering guidance:** `#872`/`#867` are mutually independent of everything else and
of each other — merge in any order. `#866` and `#865` both touch `Cargo.lock`; merge `#866`
**before** `#865` and re-green `#865` against the post-`#866` `develop` tip before merging it —
`strict: false` on branch protection (documented in `CLAUDE.md`'s CI Gate section) means a PR's
last-green CI run is not automatically re-validated against a moved base branch, so a stale
green check on `#865` cannot be trusted once `#866` has landed ahead of it.

**None of these 4 PRs were merged by this sweep.** All four require a human code-owner
approval/merge on the protected `develop` branch — this is a hard governance boundary
(branch protection + auto-mode "Merge Without Review" guard), not a scheduling choice. This
sweep's output is the completed triage; delivery is a separate, human-owned action.

## HELD (2) — `cargo deny` duplicate-version ban, blocked on upstream

Both PRs individually pass their own package's tests, but landing either one in isolation
would leave two versions of the same transitive crate in the dependency graph, which
`deny.toml`'s `[bans] multiple-versions = deny` policy rejects (`cargo deny check` FAIL). The
fix requires the crate(s) still pinning the *old* version to bump their own dependency first —
not something achievable inside the Dependabot PR itself.

- **#854** `reqwest` 0.13.4 → 0.13.5 — `cargo deny check` FAIL: duplicate `reqwest` versions
  detected (a transitive dependency still pins 0.13.4). Root cause is a transitive pinner, not
  this PR's own `Cargo.toml` entry.
- **#842** `base64` 0.22.1 → 0.23.1 — `cargo deny check` FAIL, confirmed:
  `error[duplicate]: found 2 duplicate entries for crate 'base64'` — versions 0.22.1 and
  0.23.1 both present in the resolved graph. Same root cause class as `#854`: a transitive
  pinner (see `cycles/OPEN-STANDING-ITEMS.md`'s `MAINT-BASE64-023-DEDUPE-BLOCKED-ON-UPSTREAM`
  item) still resolves to 0.22.1, and the human has explicitly declined to add a temporary
  `deny.toml [[bans.skip]]` suppression for this duplicate (see `STATE.md`'s "Constraints
  Carried Forward" section) — it stays a live, tracked `cargo deny` finding until upstream
  resolves it.

Neither `#854` nor `#842` is actionable by this sweep or by merging the PR alone; both remain
open, tracked, and blocked on the respective upstream transitive-dependency bump.

## DEFERRED (1) — major breaking bump, needs dedicated code-adaptation effort

- **#855** `comfy-table` 7.2.2 → 8.0.0 — major version bump with a breaking API change.
  `cargo check`/`cargo test`/`cargo clippy`/the MSRV job all FAIL against the bumped version;
  `src/output.rs`'s table-rendering call sites need adaptation to comfy-table 8.0's changed
  API surface before this can land. This is real implementation work, not a sweep-scope fix —
  already tracked as `COMFY-TABLE-8-MIGRATION-DEFERRED` in `cycles/OPEN-STANDING-ITEMS.md`.
  DEFERRED, no change to that tracked item's disposition this sweep.

## No `src/` or product-tree changes

This sweep is triage-only. No file under `src/`, `Cargo.toml`, `Cargo.lock`, or any other
product-tree path was modified by this sweep — only `.factory/` bookkeeping (this report +
`STATE.md`) was written, per the sweep's explicit scope constraint.

## Next steps (human-owned)

1. Human code-owner reviews and merges `#872` and `#867` (GH Action patch bumps) in either order.
2. Human code-owner reviews and merges `#866`, then re-verifies `#865`'s CI is green against
   the post-`#866` `develop` tip before merging `#865`.
3. `#854`/`#842` remain HELD pending upstream transitive-dependency movement — re-triage on a
   future sweep once `cargo tree -i reqwest` / `cargo tree -i base64` show convergence.
4. `#855` remains DEFERRED pending a dedicated `comfy-table` 8.0 migration effort (own cycle
   or maintenance burst with code changes, not a Dependabot-triage sweep).

## Delivery — COMPLETE (2026-09-23)

The human code-owner reviewed and merged all 4 APPLY-ready PRs from this sweep's triage. All
merges verified on `origin/develop`, a clean linear stack:

| # | Dependency | Merge type | Squash SHA |
|---|---|---|---|
| `#872` | `codecov/codecov-action` 7.1.0 → 7.1.1 | squash | `6100af0b` |
| `#867` | `taiki-e/install-action` 2.87.12 → 2.87.13 | squash | `751a2a96` |
| `#866` | `clap` 4.6.6 → 4.6.7 | squash | `34693f19` |
| `#865` | `clap_complete` 4.6.9 → 4.6.10 | squash | `22c7f79f` |

`#865` stacked cleanly on top of `#866` per the delivery-ordering guidance above — `Cargo.lock`
coherent, no re-resolution conflicts.

**`develop` tip advanced: `7c5e9309` → `22c7f79f`** (4 commits).

HELD (`#854` reqwest, `#842` base64) and DEFERRED (`#855` comfy-table) remain **OPEN, untouched**
— no change to their triage disposition. `cargo deny check`'s duplicate-version ban on `#854`/
`#842` is unaffected by this delivery (neither PR merged).

No release was cut for this delivery — `activation_head`/`activation_version` remain
`8b4c797a`/`v0.7.0-dev.8` unchanged; these 4 dependency bumps roll into whatever future release
next tags `develop`. Counts unchanged: 770 BCs / 89 VPs / 118 holdout / 191 stories.
