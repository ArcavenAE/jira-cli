---
document_type: adr
adr_id: ADR-0025
status: proposed
date: 2026-09-15
subsystems_affected: ["SS-02", "SS-08", "SS-09"]
supersedes: null
superseded_by: null
related: []
inputs:
  - .factory/cycles/cycle-013/phase-f1-delta-analysis/delta-analysis.md
  - .factory/research/msrv-let-chains-comfy-table-2026-07-30.md
  - .factory/research/msrv-1.88-ecosystem-policy-2026-09-15.md
input-hash: "1c24441"
---

# ADR-0025: Raise Minimum Supported Rust Version from 1.85 to 1.88

## Status

**Proposed** (2026-09-15). Gate: F2 spec evolution for cycle-013 `msrv-1.88-bump` (Feature Mode).
The 1.88 target itself was already confirmed by the human at the F1 delta-analysis gate
(`.factory/cycles/cycle-013/phase-f1-delta-analysis/delta-analysis.md`); this ADR records the
decision's durable rationale for F2's human approval gate. Do not treat this as Accepted until
the F2 gate is passed — no DEC is minted by this document.

## Context

`jr` declares `rust-version = "1.85"` in `Cargo.toml` (edition is already `2024`). That declared
floor is currently **false**: `comfy-table = "7"` resolves to `7.2.2`, which silently dropped its
own `rust-version` metadata in the same release that started using let-chains internally
(`if let Some(x) = y && cond { ... }`, stabilized in Rust 1.88.0, edition-2024-gated) — so
`comfy-table 7.2.2` fails to compile on a real 1.85.0 toolchain (`E0658`, confirmed by direct
compilation against both toolchains). `jr`'s own `Cargo.toml` pins `comfy-table = "=7.2.1"` today
specifically to paper over this, and the `msrv` CI job's `cargo check` scope is narrowed to
`lib + bins` (excluding `--all-targets`) specifically because `wiremock 0.6.x` — a dev-dependency
— also requires ≥1.88. Both workarounds are documented, dated, and load-bearing today.

Separately, the codebase carries one live lint-policy exception: CLAUDE.md's Conventions section
bans let-chains repo-wide ("`if let … && …` syntax requires Rust ≥1.88 with edition 2024; MSRV is
1.85. Use nested `if` blocks instead... Temporary — delete this entry ... when MSRV is raised to
≥1.88"), citing three source sites that currently use the nested-`if` workaround form:
`src/cli/auth/keychain.rs`, `src/cli/board.rs`, and `src/cli/issue/list.rs`. Two of those three
sites (`board.rs`, `issue/list.rs`) implement the Team-column gating logic governed by
`BC-5.3.001`/`BC-5.3.002` in `.factory/specs/prd/bc-5-boards-sprints.md` — their current
three-level nested-`if`/`else { Vec::new() }` shape is described in BC-5.3.001's own Behavior
prose, and BC-5.3.002's Trace field already references a prior, unrelated "let-chain" branch-
coverage change (S-626-1) at the same call sites — see this cycle's F2 verification-delta note
for the disambiguation between that prior usage and this ADR's actual Rust `let_chains` language
feature.

Human decision context (already researched this session, persisted in
`.factory/research/msrv-1.88-ecosystem-policy-2026-09-15.md`): current Rust stable is 1.98 (1.88
is ten releases behind, a modest lag); comparable single-binary Homebrew-distributed Rust CLIs
target similar floors (gitui 1.88, zoxide 1.88, jj/Jujutsu 1.89); and `jr`'s own design spec
(`docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md` §"MSRV Policy") states an MSRV policy
("1.85.0, or latest stable minus 3 releases") that has never actually been followed as a live
mechanism — if it had been, "latest stable minus 3" from 1.98 would already imply a floor well
above 1.88.

## Decision

We will raise `jr`'s declared and CI-enforced MSRV from **1.85** to **1.88**
(`Cargo.toml` `rust-version = "1.88"`; edition remains `2024`, unchanged). This is headroom, not a
forced bump — nothing in the checked `lib + bins` dependency graph requires more than 1.85 today
(§4 Q3 of the F1 delta analysis) — but 1.88 is the exact floor that (a) makes the declared MSRV
true again for the full dependency graph including dev-dependencies, and (b) unblocks retiring
the codebase's one active MSRV-driven lint-policy exception.

Going forward, `jr`'s MSRV policy is: **bump as needed, driven by dependency floor and ecosystem
pressure, evaluated ad hoc per cycle** (currently 1.88) — not a fixed "latest stable minus N"
offset. This supersedes the unfollowed "latest stable minus 3" line in the 2026-03-21 design spec
as the actual, going-forward policy statement; the design-spec text itself is reconciled by F4
(Story 3 in the F1 preview decomposition), not by this ADR directly, but this ADR is the decision
record that F4's doc edit traces back to.

## Rationale

1. **Dependency floor forces the choice between 1.88 and re-pinning, not between 1.85 and 1.88.**
   `comfy-table` 7.2.1 is empirically confirmed (real toolchain compilation, not manifest
   inspection) to be the *last* 7.x release that builds on 1.85.0; 7.2.2+ requires 1.88 and no
   longer declares a `rust-version` floor at all, so nothing in `comfy-table`'s own metadata will
   stop a future `cargo update` from silently re-breaking a 1.85-pinned build. Holding 1.85 means
   holding the `=7.2.1` pin indefinitely, manually, forever, against an upstream crate whose
   MSRV-declaration was already shown to lapse once. Raising to 1.88 removes this fragility instead
   of choosing to keep maintaining it. (`.factory/research/msrv-let-chains-comfy-table-2026-07-30.md`
   Q2.)
2. **1.88 is the minimum version that captures every benefit on the table — no intermediate
   version does.** 1.86/1.87 unlock nothing for `jr` specifically: the `comfy-table` break is
   bracketed strictly between 1.85 (fails) and 1.88 (succeeds), and let-chains stabilize exactly
   at 1.88, edition-2024-gated (`jr` is already on edition 2024, so it satisfies that half of the
   requirement today). 1.88 simultaneously (a) makes `comfy-table` 7.2.2+ buildable without a
   version pin, (b) makes `wiremock` 0.6.x buildable, which lets the `msrv` CI job's
   `cargo check` scope widen to `--all-targets` and close a documented enforcement gap (inline
   `#[cfg(test)]` modules and integration tests are currently outside the `msrv` job's reach), and
   (c) lets CLAUDE.md retire its "No let-chains" convention entry, which explicitly names "MSRV
   raised to ≥1.88" as its own deletion trigger.
3. **Distribution cost is near-zero for this product's shape.** `jr` ships as a compiled binary
   (Homebrew tap, GitHub Releases per-platform artifacts, `cargo install`) — binary/Homebrew end
   users never invoke `rustc` and are unaffected by MSRV regardless of its value. The cost falls
   only on source-builders who have not updated their local toolchain past 1.85 and on the CI
   matrix itself. With current stable at 1.98, a source-builder without at least 1.88 already
   available is roughly 15 months of Rust release cadence behind upstream — this mirrors the
   "User impact: None for binary users or source-builders on Rust ≥1.85.0" precedent already
   recorded in `CHANGELOG.md` for the prior MSRV-correctness fix (S-626-1), updated to the new
   floor. (`.factory/research/msrv-1.88-ecosystem-policy-2026-09-15.md`.)
4. **1.88 is ecosystem-mainstream for this class of tool, not ahead of or behind the norm.**
   Comparable single-binary, cross-platform, Homebrew-distributed Rust CLIs cite similar floors:
   gitui and zoxide both target MSRV 1.88; jj (Jujutsu) targets 1.89. Targeting 1.88 places `jr`
   in the same band as its nearest comparables. (Confidence on this specific comparables claim is
   **medium**, not independently re-verified via live web lookup this pass — carried forward from
   human-supplied research context per the companion research note's own stated limitation; if
   these values are ever surfaced in user-facing text, re-verify against the respective projects'
   current MSRV at that time.)
5. **Policy reconciliation closes a recurring, previously-deferred inconsistency.** The design
   spec's "latest stable minus 3" clause has never once been the actual mechanism behind any prior
   MSRV-adjacent change in this repo's history (including the S-626-1 CI-correctness fix). Rather
   than defer the reconciliation again, this ADR records the going-forward policy explicitly —
   ad hoc, dependency/ecosystem-pressure-driven bumps — so future MSRV cycles have a real policy
   statement to cite instead of an aspirational one the project has never followed.

## Consequences

### Positive

- `Cargo.toml`'s declared `rust-version` becomes true for the full dependency graph again
  (lib + bins + dev-dependencies), closing the `comfy-table`/`wiremock` false-MSRV gap.
- The `comfy-table = "=7.2.1"` exact pin can be lifted (or re-pinned to a reviewed ≥7.2.2 version
  per the project's existing exact-pin convention for MSRV-surprise-prone dependencies, mirroring
  the `saphyr-parser = "=0.0.11"` precedent) — F2/F4's call, not fixed by this ADR.
- CLAUDE.md's "No let-chains" convention entry is retirable, along with its three citing
  in-code comments (`src/cli/auth/keychain.rs`, `src/cli/board.rs`, `src/cli/issue/list.rs`).
- The `msrv` CI job's `cargo check` scope can widen from `lib + bins` to `--all-targets`,
  closing a documented enforcement gap for inline `#[cfg(test)]` modules and integration tests —
  contingent on the human confirming this scope change explicitly (F1 Open Question 2; already
  confirmed per this cycle's task framing: scope will widen).
- Removes a fragile, silently-defeasible pin (`comfy-table` no longer declares its own MSRV floor
  past 7.2.1, so nothing but this project's own CI job was protecting against a future
  `cargo update` re-breaking a held-at-1.85 build).

### Negative / Trade-offs

- **`tests/ci_gate_completeness.rs` HIGH-risk coupling (F1 §3/§4):** the test
  `test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env` hard-pins the literal strings
  `toolchain: "1.85.0"` / `RUSTUP_TOOLCHAIN: "1.85.0"` at multiple assertion sites. This test and
  `.github/workflows/ci.yml`'s `msrv` job must change in the same atomic commit/burst — landing
  one without the other breaks the `ci-gate` required check for every subsequent PR on
  `develop`/`main`. This is the single hardest sequencing constraint on F3/F4 (per F1's
  recommendation: one story, not split across waves).
- **`comfy-table` 7.2.2 rendering-fix regression tail:** the 7.2.2 changelog documents a "Fixed
  table misformatting without vertical border styling" change alongside the let-chain refactor.
  `src/cli/auth/tests/snapshots/jr__cli__auth__tests__list_table_snapshot.snap` is the one and
  only insta snapshot in the repo that exercises table-mode rendering byte-for-byte; if this
  snapshot changes when the pin lifts, it must be reviewed visually (not blindly
  `cargo insta accept`-ed) before acceptance, since the change is expected to be a legitimate
  upstream fix, not a regression.
- **Source-builder floor moves up.** A source-builder (`cargo install`/`cargo build` from source)
  pinned below 1.88 can no longer build `jr` after this change. Mitigated by the near-zero
  distribution-cost analysis above (binary/Homebrew consumers unaffected; source-builders already
  meaningfully behind current stable regardless of this specific bump).
- **Three source-level let-chain retrofits are not uniformly trivial.** The
  `src/cli/board.rs`/`src/cli/issue/list.rs` sites are a three-level nested `if`/`else` (not the
  simpler two-level pattern at `src/cli/auth/keychain.rs`), with a `let uuids = …` computation
  interposed between the second and third conditions — that computation cannot be folded into a
  single let-chain spanning all three conditions without either restructuring the laziness
  (current code intentionally avoids the team-cache filesystem read unless the first two gates
  already passed) or leaving the third condition as a separate nested `if` after the let-chain
  covering the first two. F4's implementer must preserve `BC-5.3.001`/`BC-5.3.002`'s postconditions
  (`tests/team_column_parity.rs`, `tests/cli_handler.rs` team-column tests) exactly, not just
  "collapse the nested if" mechanically per file.
- **Prose-currency debt, not a contract change:** `BC-X.13.007`'s Invariants section
  (`.factory/specs/prd/cross-cutting.md`) cites the literal `toolchain: "1.85.0"` /
  `RUSTUP_TOOLCHAIN: "1.85.0"` strings as descriptive prose of current `ci_gate_completeness.rs`
  coverage (the same paragraph already disclaims "no corresponding BC or VP registered in this
  PRD" for the msrv guard, so this is not a governed contract) — this prose goes stale once F4
  updates the test to pin `1.88.0` and should be corrected in the same burst, per CLAUDE.md's own
  citation-discipline convention. Similarly, BC-5.3.001's "three-level nested if" Behavior
  description will describe pre-refactor code once F4 lands the let-chain retrofit and should be
  refreshed as a documentation-currency pass — see this cycle's F2 verification-delta artifact.

### Status as of 2026-09-15

Proposed, pending the F2 human approval gate. No code, `Cargo.toml`, or `ci.yml` changes have been
made under this ADR — F2 is spec-layer only. Implementation is F4's responsibility per the F1
preview story decomposition (Story A: mechanical version bump + CI-gate contract, atomic; Story B:
let-chain retrofit + convention cleanup; Story C: doc/policy reconciliation).

## Alternatives Considered

- **Hold `rust-version = "1.85"` and keep pinning `comfy-table = "=7.2.1"` indefinitely.**
  Rejected: `comfy-table` 7.2.2+ no longer declares any `rust-version` at all, so the pin has no
  upstream metadata backstop — a future `cargo update` (or a contributor bumping the range without
  re-reading this research) can silently re-break the 1.85 build again. This defers the problem
  rather than resolving it, and forfeits the let-chains/CI-scope benefits for no compensating gain
  (nothing in the actual dependency graph needs to stay at 1.85 — see Rationale item 1).
- **Raise MSRV to something higher than 1.88 (e.g., track current stable, or "latest stable minus
  3" as the design spec's unfollowed policy literally states).** Rejected: no dependency in `jr`'s
  graph requires anything above 1.88 today; going higher than the minimum defensible floor adds
  source-builder cost with zero corresponding benefit, and contradicts the "bump as needed"
  going-forward policy this ADR establishes (bumps should be driven by an actual forcing function,
  not a rolling offset from whatever current stable happens to be).
- **Raise to 1.86 or 1.87 instead of 1.88.** Rejected: neither version unlocks anything for `jr`
  specifically — the `comfy-table` break and the let-chains stabilization both sit exactly at the
  1.85→1.88 boundary, with no evidence that 1.86/1.87 changes anything relevant in between
  (empirically measured: 1.85.0 fails, 1.88.0 succeeds; 1.86/1.87 not independently tested but not
  implicated by any evidence). 1.88 is the minimum version that captures the full benefit set.
- **Keep the `msrv` CI job's `cargo check` scope narrow (`lib + bins`) rather than widening to
  `--all-targets`.** Rejected per explicit human confirmation at the F1 gate: the sole reason the
  narrow scope existed (`wiremock`'s ≥1.88 requirement) no longer applies once the floor moves to
  1.88, so keeping it narrow would mean carrying a workaround whose original justification is
  gone, for no new reason.

## Source / Origin

- `.factory/cycles/cycle-013/phase-f1-delta-analysis/delta-analysis.md` — F1 delta analysis
  (human-approved 2026-09-15), §1 (feature summary), §3 (file inventory), §4 (regression risk),
  §7 (open questions, all resolved per this cycle's task framing).
- `.factory/research/msrv-let-chains-comfy-table-2026-07-30.md` — empirical dependency-floor
  research: let-chains stabilization version (Rust 1.88.0, PR rust-lang/rust#132833), last
  1.85-compatible `comfy-table` release (7.2.1), and the 7.2.2 MSRV-metadata lapse.
- `.factory/research/msrv-1.88-ecosystem-policy-2026-09-15.md` — ecosystem/policy research:
  current Rust stable (1.98 as of 2026-09-15), comparable-CLI MSRV posture (gitui/zoxide 1.88, jj
  1.89), distribution-cost assessment, and the design spec's unfollowed MSRV policy line.
- Code as-built: `Cargo.toml` (`rust-version = "1.85"`, `comfy-table = "=7.2.1"` pin);
  `.github/workflows/ci.yml` `msrv` job; `tests/ci_gate_completeness.rs`
  (`test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env`); `src/cli/auth/keychain.rs`,
  `src/cli/board.rs`, `src/cli/issue/list.rs` (the three "Nested if (not a let-chain)" marker
  comments); `CLAUDE.md` Conventions section ("No let-chains" entry).
- `.factory/specs/prd/bc-5-boards-sprints.md` `BC-5.3.001`/`BC-5.3.002` — Team-column gating
  behavioral contracts whose current implementation is two of the three let-chain retrofit sites
  (flagged as a change to F1's LOW-risk assumption for these two sites; not a contract requiring
  edit — outcomes/postconditions are unaffected by the syntax-only refactor).
- `.factory/specs/prd/cross-cutting.md` `BC-X.13.007` — explicitly disclaims governing the `msrv`
  job's toolchain-pinning guard; its Invariants prose citing the literal `"1.85.0"` value is
  documentation of current test coverage, not a contract on that value.
