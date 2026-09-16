---
document_type: cycle-document
cycle: cycle-013-msrv-1.88-bump
phase: phase-f2-spec-evolution
producer: architect
timestamp: 2026-09-15
status: complete
inputs:
  - .factory/cycles/cycle-013/phase-f1-delta-analysis/delta-analysis.md
  - .factory/specs/architecture/decisions/ADR-0025-raise-msrv-to-1-88.md
  - .factory/research/msrv-let-chains-comfy-table-2026-07-30.md
  - .factory/research/msrv-1.88-ecosystem-policy-2026-09-15.md
input-hash: "3b233fd"
---

# Phase F2 Verification Delta: MSRV 1.88 Bump (cycle-013 `msrv-1.88-bump`)

## Verdict

**Zero new VP-NNN properties. Zero modified VP-NNN properties. Zero new Kani proofs, proptest
strategies, or fuzz targets.** This is a delta-only spec burst confirming the F1 delta analysis's
own verdict (§6: "Verification Properties | 0 new VP-NNN needed") after independently re-deriving
it from first principles rather than merely restating it.

## Why no new/modified VPs are warranted

### 1. The change is behavior-preserving by construction

Every source-level change this cycle touches is one of:

- **Build metadata** (`Cargo.toml` `rust-version`, comfy-table pin) — affects which toolchain/
  dependency versions compile, not runtime behavior of any function.
- **CI workflow configuration** (`.github/workflows/ci.yml` `msrv` job toolchain pin + scope) —
  affects what CI validates, not what the shipped binary does.
- **A CI-contract self-test's pinned literals** (`tests/ci_gate_completeness.rs`) — a test
  asserting against `ci.yml`'s own text; it validates the workflow file, not product code.
- **Three syntactic nested-`if` → let-chain collapses** (`src/cli/auth/keychain.rs`,
  `src/cli/board.rs`, `src/cli/issue/list.rs`) — see §2 below for why these are semantics-
  preserving, not merely asserted to be.
- **Prose/doc edits** (CLAUDE.md, README, CHANGELOG, design spec) — no runtime surface at all.

No new capability, endpoint, state machine, arithmetic operation, or security boundary is
introduced or altered. VSDD's verification-property mechanism exists to prove properties of
*product behavior* (state machines, arithmetic bounds, termination, access control, data
integrity — per the architect's Provable Properties Catalog categories); a toolchain-floor bump
has no product-behavior surface to attach a new VP to.

### 2. The three let-chain collapses are provably semantics-preserving, not just claimed to be

This was verified independently this pass, not merely inherited from F1's LOW-risk classification:

- **`src/cli/auth/keychain.rs` (~L50):** a simple two-level nested form,
  `if let Ok(v) = std::env::var(env_name) { if !v.is_empty() { … } }`. Rust 1.88's own
  stabilization rationale (per `.factory/research/msrv-let-chains-comfy-table-2026-07-30.md` Q1)
  is that let-chains required the `if let` temporary-scope change specifically so that this class
  of collapse produces **matching, not diverging**, drop order versus the nested form — the
  language change was deliberately sequenced so this refactor class is safe by construction, not
  merely by convention.
- **`src/cli/board.rs` (~L231) and `src/cli/issue/list.rs` (~L760):** verified by direct read this
  pass (not merely inventoried) to be a **three-level** nested `if`/`else { Vec::new() }` structure
  (`if matches!(output_format, OutputFormat::Table) { if let Some(field_id) = team_field_id { let
  uuids = …; if uuids.iter().any(…) { … } else { Vec::new() } } else { Vec::new() } } else {
  Vec::new() }`), not the simpler two-level pattern F1's file-inventory table implied by using
  identical "same collapse pattern" language for all three sites. This is a **correction to an F1
  assumption** (see §4) — but it does not change the zero-VP verdict: whatever the eventual
  let-chain shape (full three-condition chain if the `uuids` computation is restructured, or a
  partial two-condition chain with the third left as a nested `if` after the `let uuids = …`
  statement, since let-chains cannot interpose an arbitrary statement between chained conditions),
  the **outcome-level postconditions this code must satisfy are already fully specified and
  covered** by existing behavioral contracts and their test suites:
  - `BC-5.3.001` (team column appears iff all three conditions hold) —
    `tests/team_column_parity.rs::sprint_current_shows_team_column_when_populated`,
    `::board_view_kanban_shows_team_column_when_populated`,
    `tests/cli_handler.rs::test_list_shows_team_column_with_cached_name`.
  - `BC-5.3.002` (team column omitted when any condition fails) —
    `tests/team_column_parity.rs::sprint_current_omits_team_column_when_field_unconfigured`,
    `::sprint_current_omits_team_column_when_no_issue_has_team`,
    `::board_view_kanban_omits_team_column_when_no_issue_has_team`,
    `::test_board_view_omits_team_column_when_field_unconfigured`,
    `::test_issue_list_omits_team_column_when_field_unconfigured`,
    `tests/cli_handler.rs::test_list_omits_team_column_when_no_issue_has_team`.
  - `BC-5.3.003` (fallback to bare UUID on cache miss) — covered by a further three tests in the
    same files.

  These existing tests assert outcomes (does the column appear, what does each cell contain), not
  control-flow shape — they will catch any behavior change the refactor might accidentally
  introduce regardless of which of the two let-chain shapes F4 lands on. No new VP is needed to
  cover this; the existing BC/test pairing is the correct and sufficient verification surface, per
  CLAUDE.md's own "Default to fixing code, not tests" + TDD convention (F4's implementer runs
  these tests red→green around the refactor, not the other way around).

### 3. The CI-contract change is covered by an existing, updatable self-test — not a VP-shaped concern

`tests/ci_gate_completeness.rs` is CLAUDE.md's own documented mechanism for enforcing `ci.yml`'s
structural and literal correctness (the "six-file review scope" convention; `VP-CIGATE-001`
already exists and governs the *general* pinned-literal-assertion mechanism, not this specific
MSRV value). Updating this test's pinned `"1.85.0"` literals to `"1.88.0"` in lockstep with
`ci.yml`'s actual change (F1's HIGH-risk, single-atomic-commit requirement) is a **literal-value
update to an existing test**, not a new verification property — the property being verified
("the `msrv` job pins the toolchain and `RUSTUP_TOOLCHAIN` env to the same value") is unchanged;
only the pinned value itself changes. `VP-CIGATE-001`'s existing assertion count and shape are
unaffected by this cycle (confirmed: no VP-CIGATE-001 assertion enumerates the specific version
string as part of its own definition — the version string is a parameter of the test, not of the
VP).

### 4. Correction to an F1 assumption (flagged per this task's "anything that changes the F1
assumptions" instruction, not acted on here — F2 is spec-layer only)

F1's file-inventory table (§3) describes `src/cli/board.rs` and `src/cli/issue/list.rs` with
"Same collapse pattern, same source comment marker" as `src/cli/auth/keychain.rs`, at **LOW** risk
uniformly across all three sites. Direct read this pass shows the `board.rs`/`issue/list.rs` sites
are structurally more complex (three-level nesting, a `let uuids = …` statement interposed between
the second and third conditions, and `else { Vec::new() }` fallback arms at every level) than
`keychain.rs`'s simpler two-level pattern, and — materially — that these two sites are the direct
implementation of `BC-5.3.001`/`BC-5.3.002`, which F1's own architecture-verdict section (§2)
stated finds "no `ARCH-INDEX.md`/module-criticality artifacts reference Rust-toolchain version"
without cross-checking whether the refactor sites *themselves* implement any existing BC. This
does not change the regression-risk verdict from LOW (the postcondition-level test coverage in
§2 above is exactly what an honest LOW-risk verdict requires, and it exists and is adequate) — but
F4's implementer should not assume a single mechanical "nested if → let-chain" edit pattern
applies uniformly to all three sites; the `board.rs`/`issue/list.rs` sites need the full
`tests/team_column_parity.rs` + relevant `tests/cli_handler.rs` suite run red→green around the
change, not just the narrower unit coverage F1's §4 mitigation table implies ("write/keep unit
tests for all 3 call sites covering both the present/non-empty and absent/empty branches").

### 5. No PRD/BC edits required (Task instruction 3)

Grepped `.factory/specs/prd/` for `msrv|rust-version|1\.85|let.?chain` (case-insensitive). Two
categories of hits, both **not** contracts requiring edit:

- **`BC-X.13.007`** (`cross-cutting.md`) Invariants section cites the literal
  `toolchain: "1.85.0"` / `RUSTUP_TOOLCHAIN: "1.85.0"` strings — but the same paragraph explicitly
  disclaims governance: *"This BC also does not govern … the `msrv` job's toolchain-pinning
  guard … Those are pinned at the S-CIGATE-1 / S-626-1 story-AC layer … with no corresponding BC
  or VP registered in this PRD."* This is descriptive prose of current test-file contents, not an
  asserted contract on the value `"1.85.0"` — no BC edit required. It will become **stale prose**
  once F4 updates the pinned literal to `"1.88.0"`; flagged for a documentation-currency fix in
  the same F4 burst (not an F2 spec-evolution task, since no BC/VP text or count changes).
- **`bc-2-issue-read.md`** `BC-2.7.012`/related — cites "MSRV-1.85 `ErrorKind` stability confirmed"
  for `StorageFull`/`QuotaExceeded`/`ReadOnlyFilesystem`/`PermissionDenied`. This confirms those
  `std::io::ErrorKind` variants are stable **at or before** 1.85 (`QuotaExceeded` stable since
  exactly 1.85.0) — raising the floor to 1.88 only adds headroom above this; the claim remains
  true unchanged. No BC edit required, no staleness introduced.
- **`bc-5-boards-sprints.md`** `BC-5.3.002` Trace field references a prior, unrelated "S-626-1
  let-chain rewrite" (a branch-coverage improvement to the same nested-`if` sites, predating this
  cycle, using "let-chain" as loose prose for a nested-`let`/`if` refactor rather than the actual
  Rust `let_chains` language feature — S-626-1 shipped when MSRV was still 1.85 and the real
  language feature was unavailable). This is a pre-existing naming coincidence with this cycle's
  actual let-chain retrofit, not a contract requiring edit now. **Flag for F4:** once the actual
  let-chain retrofit lands, `BC-5.3.001`'s "three-level nested if" Behavior-section prose (which
  describes the current implementation shape verbatim) will describe pre-refactor code and should
  be refreshed as a documentation-currency pass alongside the code change — this is a prose
  update, not a new BC/VP and not a postcondition change (the Postconditions themselves are
  outcome-level and remain true regardless of control-flow syntax).

No `.factory/specs/prd/` file requires a content or count change as part of this F2 burst.

## Spec version

No PRD version bump — zero PRD content changes (see §5). No `.factory/spec-changelog.md` entry
required for the PRD; the architecture changelog (implicit, via the new ADR + ARCH-INDEX row) is
the only spec-surface change this cycle produces.

## Architecture delta

**Architecture unchanged**, per F1 §2's own verdict (no structural change, no new module/
subsystem/interface) and independently re-confirmed this pass: no `architecture/*.md` section file
requires editing beyond the ARCH-INDEX.md Architecture Decisions table row for the new ADR (see
below). No `architecture-delta.md` is produced — the F2 skill's Step 3 instructs skipping this
artifact and noting "Architecture unchanged" when no structural changes are needed; recorded here.

## Artifacts produced this phase

- `.factory/specs/architecture/decisions/ADR-0025-raise-msrv-to-1-88.md` (new, `status: proposed`)
- `.factory/specs/architecture/ARCH-INDEX.md` — one new row in the Architecture Decisions table
  (`ADR-0025 | Raise Minimum Supported Rust Version from 1.85 to 1.88 | SS-02, SS-08, SS-09 |
  decisions/ADR-0025-raise-msrv-to-1-88.md`)
- This file (`verification-delta.md`)

## Deferred to F4 (explicitly not done in this F2 burst, per task scope)

Per this cycle's task framing, the following product-tree doc reconciliations are **deferred to
F4 implementation (Story 3 of the F1 preview decomposition)** and are NOT touched by this F2
spec-layer burst:

1. `docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md` §"MSRV Policy" — update the stated
   "1.85.0 (or latest stable minus 3 releases)" text to match the going-forward policy this ADR
   records ("bump as needed, driven by dependency floor and ecosystem pressure").
2. `README.md` MSRV badge (`MSRV-1.85-orange.svg` → `MSRV-1.88-orange.svg`).
3. `CHANGELOG.md` — new `[Unreleased]` entry for the MSRV raise, comfy-table unpin, and `msrv`
   job `--all-targets` scope widening.
4. `CLAUDE.md` — delete the "No let-chains" Conventions entry (and its three citing in-code
   comments, which are a code change, not a doc change); fix the stale action SHA in the Gotchas
   section's `rust-toolchain.toml` bullet (currently cites `fa04a1451ff1842e2626ccb99004d0195b455a88`;
   F1 confirmed the actual pinned SHA in `ci.yml` today is `6c977a6ca4077a0ceb28ffbe03f59d46e9ac8772`
   — a pre-existing, unrelated drift bundled opportunistically per F1's recommendation).
5. `BC-X.13.007` Invariants prose (`cross-cutting.md`) and `BC-5.3.001` Behavior prose
   (`bc-5-boards-sprints.md`) — documentation-currency updates once the underlying literals/code
   actually change (§5 above); not BC/VP content changes, so out of F2's "new BC/VP" scope, but
   should not be forgotten at F4/state-manager time.

None of the above are spec-content changes in the VSDD sense (no BC/VP added, modified, or
retired) — they are prose-currency housekeeping riding alongside the code change, consistent with
how F1 characterized them (LOW risk, cosmetic/doc-only).
