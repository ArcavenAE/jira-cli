---
document_type: cycle-document
cycle: cycle-013-msrv-1.88-bump
phase: phase-f7-delta-convergence
producer: consistency-validator
timestamp: 2026-09-16
status: complete
delta_ref: "git diff 7160a534..b960c305 (46 files, +1073/-1050)"
develop_at: b960c305
factory_artifacts_at: e7451237
---

# Phase F7 Delta-Convergence Audit — cycle-013 (`msrv-1.88-bump`)

**Scope:** MSRV 1.85→1.88 bump, ~73-site clippy `collapsible_if`→let-chain retrofit, and
docs reconciliation (PRs #818, #819, #822). `develop` @ `b960c305`; `factory-artifacts` @
`e7451237`. Fresh-context audit, read-only. Runs the 7-dimension convergence check
(cycle-007 F7 precedent) over the delta and its ripple across the full spec/code perimeter.

## Executive summary

The delta itself is clean: `Cargo.toml`, `.github/workflows/ci.yml`, `tests/ci_gate_completeness.rs`,
CLAUDE.md, README, the design spec, `docs/specs/ci-gate-completeness.md`, and the three
let-chain retrofit sites (`keychain.rs`, `board.rs`, `list.rs`) are all mutually consistent at
1.88, and the BC-5.3.001/002/003 prose was independently verified against the actual landed
code line-for-line. All CI-facing scripts (`check-spec-counts.sh`, `check-bc-cumulative-counts.sh`,
`check-bc-citation-symbols.sh`, `cargo test --test claude_md_citations`) are green.

However, the **process-state perimeter is NOT yet self-consistent**, for reasons unrelated to
the code delta itself:

1. **Phase F6 targeted hardening has already been executed and produced a COMPLETE,
   HARDENED_WITH_RESIDUALS verdict** (`.factory/cycles/cycle-013/phase-f6-hardening/hardening-record.md`),
   but this file — along with a `STATE.md` timestamp-only edit and a `sidecar-learning.md`
   append — is **uncommitted** in the `factory-artifacts` worktree (`git status` shows it as an
   untracked directory). `factory-artifacts` @ `e7451237` (the committed tip this task cites as
   baseline) predates F6 entirely. `STATE.md`'s own `current_step`/`phase`/headline text still
   reads "NEXT = Phase F6 targeted hardening", not "F6 complete, NEXT = F7" — i.e. `STATE.md` has
   not been updated to reflect F6's own completion, uncommitted or not. **CRIT** — see Finding 1.
2. **Input-hash drift** across 5 real (non-sentinel) cycle-013 artifacts, all traceable to a
   single root cause: `ADR-0025` was legitimately edited a second time at the Wave-2 integration
   gate (adding the "Status as of 2026-09-16" reconciliation section / fixing consistency-audit
   finding F-1), and the four downstream artifacts that list it as an `inputs:` dependency
   (`verification-delta.md`, all three F3 story files) were never re-hashed afterward; a fifth
   (`dependency-graph-extended.md`) is stale for the analogous reason against the story files'
   own post-hash status-field changes. This is the same "benign lifecycle drift" class the
   cycle-007 F7 precedent found and resolved (its "Job A"). **MED** — see Finding 2.
3. One **new, previously untracked** stale-MSRV-prose site was found in an ADR (not a dated plan
   doc) that the existing `CYCLE-013-F3-HISTORICAL-PLANDOC-MSRV-MENTIONS` standing item's file
   list does not cover. **LOW** — see Finding 3.

None of these are code-correctness defects. All are closeable in minutes with no risk to
`develop`. They should be resolved (or the human should explicitly accept them) before the F7
human gate, because the gate's premise — "the whole perimeter is self-consistent" — is not
currently true of the `.factory/` state layer, only of the code/spec layer.

---

## Dimension 1 — spec ↔ code

**Verdict: PASS**

- `Cargo.toml:7` — `rust-version = "1.88"` ✓ (matches ADR-0025 Decision, verification-delta.md,
  STATE.md, all F3 story files).
- `Cargo.toml:37` — `comfy-table = "=7.2.2"` ✓, with an in-file comment (`Cargo.toml:29-37`)
  correctly explaining the exact-pin convention (mirrors `saphyr-parser` precedent) — matches
  ADR-0025 Consequences (Positive) bullet 2.
- `.github/workflows/ci.yml:248-266` (`msrv` job) — name `MSRV (1.88.0)`, `dtolnay/rust-toolchain`
  step pinned to SHA `6c977a6ca4077a0ceb28ffbe03f59d46e9ac8772` with `toolchain: "1.88.0"`, `cargo
  check --all-targets --all-features --locked` with `RUSTUP_TOOLCHAIN: "1.88.0"` ✓ — matches
  ADR-0025 Alternatives-Considered (scope widening) and the F1 human-gate decision (b).
- `tests/ci_gate_completeness.rs` — pinned literals `"1.88.0"` (toolchain + `RUSTUP_TOOLCHAIN`)
  appear at the live assertion sites (`~L3752`, `~L3904`); the surviving `"1.85.0"` occurrences
  (`~L1571`, `~L3697`, `~L3803`, `~L3864`, `~L3871`, `~L6750`) are all inside comments describing
  the **historical** pre-fix / S-626-1-era state, explicitly and correctly framed as such
  ("the `1.85.0` literals here describe that original S-626-1 fix... the job now runs both pieces
  at 1.88.0"). No live assertion pins a stale value. ✓
- **BC-5.3.001/BC-5.3.002 vs actual code — verified line-for-line, not just referenced:**
  - `src/cli/board.rs:231-256` — `if matches!(output_format, OutputFormat::Table) && let
    Some(field_id) = team_field_id { ... if uuids.iter().any(...) { ... } else { Vec::new() }
    /*~252-253*/ } else { Vec::new() } /*~255-256*/` — matches BC-5.3.002's cited line pointers
    `~252`/`~255` exactly (off by at most 1 line, within the documented `~` tolerance).
  - `src/cli/issue/list.rs:760-789` — identical shape; matches the cited `~784`/`~787` pointers
    exactly (line 784 = inner `else { Vec::new() }`, line 787 = outer `else { Vec::new() }`).
  - `src/cli/auth/keychain.rs:50-53` — `if let Ok(v) = std::env::var(env_name) && !v.is_empty()
    { return Ok(v); }` — matches BC-5.3.001's "simple two-level" characterization and ADR-0025's
    Context section description verbatim.
  - The `Nested if (not a let-chain)` marker comments the ADR/CLAUDE.md/F5 claim were removed:
    confirmed zero occurrences anywhere under `src/`.
- CLAUDE.md — zero occurrences of "let-chain"/"let_chain" remain in the Conventions section (the
  retirement claimed by ADR-0025 Consequences and the F4 Wave-1 burst is real); the Gotchas
  `rust-toolchain.toml` bullet's action-SHA citation reads `6c977a6ca4077a0ceb28ffbe03f59d46e9ac8772`
  with explicit historical framing of the `1.85.0` values — matches the F1-flagged, F4-fixed drift.
- `README.md:8` — MSRV badge reads `MSRV-1.88-orange.svg` ✓.
- `docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md:656-658` — MSRV Policy section rewritten
  to "bump as needed (currently **1.88.0**)... (ADR-0025)" — matches ADR-0025's Decision section
  wording near-verbatim. ✓
- `docs/specs/ci-gate-completeness.md` — the PR #822 (consistency-audit F-2) fix is present and
  accurate: "Since the cycle-013 MSRV-1.88 bump widened the `msrv` CI job's `cargo check` scope...
  This is fine as of cycle-013: the crate's own MSRV (1.85.0) sits below this repo's `rust-version
  = "1.88"` floor, with headroom to spare" — correctly reconciled, no residual staleness on the
  `--all-targets`/1.88 facts specifically. ✓
- `CHANGELOG.md` `[Unreleased]` — carries both the MSRV-raise entry and the let-chain-retrofit
  entry with accurate detail (comfy-table repin, `msrv` job rename/scope, the one genuine
  1.88-only borrow-checker fix). ✓

No spec↔code mismatch found in the delta's own surface.

---

## Dimension 2 — code ↔ test

**Verdict: PASS**

All BC-5.3.001/002/003 cited tests exist with exactly the cited names, one match each, no
ambiguity, no moved/renamed symbols:

- `tests/team_column_parity.rs`: `sprint_current_shows_team_column_when_populated`,
  `board_view_kanban_shows_team_column_when_populated`,
  `sprint_current_omits_team_column_when_field_unconfigured`,
  `sprint_current_omits_team_column_when_no_issue_has_team`,
  `board_view_kanban_omits_team_column_when_no_issue_has_team`,
  `test_board_view_omits_team_column_when_field_unconfigured`,
  `test_issue_list_omits_team_column_when_field_unconfigured`,
  `sprint_current_falls_back_to_uuid_when_team_not_cached`,
  `test_board_view_falls_back_to_uuid_when_team_not_cached`,
  `sprint_current_json_output_keeps_team_uuid_without_resolution` — all present, 1 match each.
- `tests/cli_handler.rs`: `test_list_shows_team_column_with_cached_name`,
  `test_list_omits_team_column_when_no_issue_has_team`,
  `test_list_team_column_falls_back_to_uuid_when_cache_missing` — all present, 1 match each.
- `tests/ci_gate_completeness.rs::test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env`
  and the `RUSTUP_TOOLCHAIN`-env sibling assertion both live and asserting `"1.88.0"` — confirmed
  by direct read (Dimension 1 above).
- `tests/common/wf.rs` — not modified by this delta (confirmed via `git diff 7160a534..b960c305`
  file list not including it); F5's claim that CI-gate guards were untouched is consistent with
  the diff surface.

`cargo test --test claude_md_citations` — **61/61 pass**, including
`test_claude_md_citations_resolve_to_real_files`, exactly matching the task's expected count.

No dead/renamed test citation found for any cycle-013-touched BC.

---

## Dimension 3 — traceability

**Verdict: PASS**

- `.factory/stories/STORY-INDEX.md` — `total_stories: 185` ✓ (matches STATE.md, all F3/F4 burst
  claims). All three `S-cycle13-*` story rows (Feature Followup + Story Manifest tables) present,
  `status: **done**`, correctly cite PR #818 @ `29e2d362` (S1+S2 combined) and PR #819 @
  `cfe1dedc` (S3), with accurate `depends_on`/`blocks` chains.
- Story → BC/ADR anchors resolve: S1 and S3 are `bcs: []` (ADR-0025-anchored, by design — no
  behavioral contract, pure infra/docs); S2 anchors `BC-5.3.001, BC-5.3.002`, both of which exist
  and were independently re-verified in Dimension 1. VP-CIGATE-001 (S1's VP anchor) exists and is
  unaffected in shape (only its pinned literal parameter changed, per F2 §3 — correctly
  characterized as not a new/modified VP).
- `git diff --shortstat 7160a534..b960c305` reproduces **46 files changed, 1073 insertions(+),
  1050 deletions(-)** exactly matching every burst/report citation of this figure across
  STATE.md, F5 pass files, and the F6 hardening record.
- F1 (DEC-363) → F2 (DEC-364) → F3 (DEC-365) → F4/Wave-1 (DEC-366) → Wave-2 gate (no DEC,
  automated) → F5 (no DEC, automated, CONVERGED) chain is unbroken and internally consistent
  across `STATE.md`'s Decisions Log, Phase Progress table, and the per-phase artifact files.

No orphaned story, no broken BC/VP anchor, no count mismatch.

---

## Dimension 4 — index-consistency

**Verdict: PASS (scripts) / FINDING (input-hash drift — see Findings 2 and 3)**

| Check | Result |
|---|---|
| `scripts/check-spec-counts.sh` | **exit 0** — "Check passed: 8 bc files validated" |
| `scripts/check-bc-cumulative-counts.sh` | **exit 0** — "OK: all cumulative BC counts verified (769 total across 9 files; Surface H footer checked where present)." |
| `cargo test --test claude_md_citations` | **green, 61/61 pass** |
| `scripts/check-bc-citation-symbols.sh` | **exit 0** — "Check passed: 525 citations checked" (run as a supporting citation-integrity check, Dimension 6) |

**Input-hash drift scan** (`bin/compute-input-hash`, rc.25, `--check`/`--scan .factory/cycles/cycle-013`):

| Artifact | Stored hash | Computed hash | Status |
|---|---|---|---|
| `phase-f1-delta-analysis/delta-analysis.md` | `9964eb4` | matches | **MATCH** |
| `phase-f2-spec-evolution/verification-delta.md` | `536fcf1` | `3b233fd` | **DRIFT** |
| `specs/architecture/decisions/ADR-0025-raise-msrv-to-1-88.md` | `1c24441` | matches | **MATCH** |
| `phase-f3-stories/S-cycle13-msrv-cargo-ci-atomic-bump.md` | `eace019` | `122246b` | **DRIFT** |
| `phase-f3-stories/S-cycle13-letchain-retrofit-convention-cleanup.md` | `cdc1cd8` | `c6d59c2` | **DRIFT** |
| `phase-f3-stories/S-cycle13-doc-policy-reconciliation.md` | `c3f7137` | `abb7a73` | **DRIFT** |
| `phase-f3-stories/dependency-graph-extended.md` | `af39ee9` | `eec9d90` | **DRIFT** |
| `phase-f3-stories/wave-schedule.md` | `8f72345` | matches | **MATCH** |
| `phase-f6-hardening/hardening-record.md` | `27f4d97` | matches | **MATCH** (uncommitted file, see Finding 1) |
| `session-checkpoints.md` | `[live-state]` | n/a — sentinel | **ACCEPTED SENTINEL**, not real drift (`inputs: [STATE.md]`, deliberately untracked per cycle-007 F7 precedent) |
| `lessons.md` | `[live-state]` | n/a — sentinel | **ACCEPTED SENTINEL**, same as above |

**Root cause (all 5 real DRIFT entries trace to one event):** `ADR-0025` was edited a second
time at the Wave-2 integration gate (`.factory` commit `6e434a0b`) to add its "Status as of
2026-09-16" reconciliation section and fix consistency-audit finding F-1. `ADR-0025` is a direct
`inputs:` dependency of `verification-delta.md` and all three F3 story files, and none of those
four were re-hashed after that edit. `dependency-graph-extended.md`'s drift is the same class one
level downstream: its `inputs:` are the three story files themselves, whose own content (status
fields flipping `draft`→`done`, etc.) changed after `af39ee9` was recorded at F3 (2026-09-15),
before the Wave-1/Wave-2 deliveries (2026-09-16) that changed them landed.

This is the same "benign lifecycle drift" class the **cycle-007 F7 precedent** (Phase Progress
row `CYCLE-007-F7-CONVERGED-2026-09-15`) found and closed as its own "Job A" — re-hashing
artifacts in topological order after confirming the drift is purely metadata-timing, not a
content contradiction. See **Finding 2** below for the exact remediation.

---

## Dimension 5 — ADR-alignment

**Verdict: PASS, with one adjacent finding (Finding 3)**

- `ADR-0025` `status: proposed` — **correctly still `proposed`**. Per the cycle-012/ADR-0024
  lifecycle precedent (explicitly cited in the ADR's own Status section), it flips to `Accepted`
  only at the F7 human gate, which has not yet convened. Confirmed the ADR's Status section
  itself narrates F2→F3→F4-both-waves as complete while correctly leaving the top-level `status:`
  field untouched — this is the intended, not-yet-flipped state, not an oversight.
- `ARCH-INDEX.md:42` — one row present: `ADR-0025 | Raise Minimum Supported Rust Version from
  1.85 to 1.88 | SS-02, SS-08, SS-09 | decisions/ADR-0025-raise-msrv-to-1-88.md` — matches the F2
  verification-delta.md's stated artifact output exactly.
- `ADR-0025`'s own `--check` (input-hash `1c24441` against its own 3 inputs: F1 delta-analysis +
  2 research files) **MATCHES** — its own content is internally consistent with its own recorded
  inputs (the Wave-2-gate edit did not change *its own* declared inputs, only its body prose, so
  self-consistency is preserved even though downstream consumers went stale — see Dimension 4).
- No other ADR contradicts the 1.88 state: `ADR-0024` (cycle-012, `status: Accepted`) makes no
  MSRV claim. A full grep of `.factory/specs/architecture/decisions/*.md` for MSRV/rust-version
  mentions outside ADR-0025 surfaced exactly one hit: **`ADR-0021`** (Windows DPAPI fallback,
  cycle-004, CLOSED+RELEASED), whose §"MSRV verification" note at `~L724-725` still reads
  "`windows-sys` 0.60.2's MSRV against this repo's `rust-version = "1.85"` must be confirmed at
  F4" — now stale prose (the floor is 1.88). This is a real, previously-untracked instance of the
  same historical-stale-prose class already tracked for dated plan docs, but in an ADR file,
  which the existing standing item's file list does not cover. **Flagged as Finding 3 (LOW).**

---

## Dimension 6 — citation-integrity

**Verdict: PASS**

- `cargo test --test claude_md_citations` — **61/61 pass** (exact match to task's stated
  expectation).
- `scripts/check-bc-citation-symbols.sh` — **exit 0**, 525 citations checked (no stale
  `src/...::symbol` token in any BC Trace/Source field).
- `BC-X.13.007` (`.factory/specs/prd/cross-cutting.md`) — its Invariants prose reconciliation
  entry (dated 2026-09-15, "S-cycle13 doc reconciliation... commit `29e2d362`") is present,
  accurately describes the landed `1.88.0`/`--all-targets` state, and correctly preserves the
  pre-existing self-disclaimer that no BC/VP governs the `msrv`/`ci-gate` story-AC guards
  themselves. No count change (658 total / 85 individually-bodied, both unchanged) — consistent
  with F2's "zero BC content/count edits" verdict.
- `BC-5.3.001`/`BC-5.3.002` Trace/Source fields (Dimension 1/2 above) resolve to real files and
  real, currently-passing tests; no dead symbol citation introduced by this delta.
- No new dead file/symbol citation was found anywhere touched by this delta.

---

## Dimension 7 — cross-references

**Verdict: FAIL — see Finding 1 (CRIT)**

- `.factory/cycles/OPEN-STANDING-ITEMS.md` correctly contains all four items STATE.md's headline
  claims to have recorded this cycle: `CYCLE-013-COMFY-TABLE-ZERO-HEADROOM-MSRV`,
  `CYCLE-013-F3-HISTORICAL-PLANDOC-MSRV-MENTIONS`, `CYCLE-013-HOOK-FALSE-POSITIVE-COMMIT-MSG-SCAN`,
  `CYCLE-013-PR822-SUBAGENT-STALL`, `CYCLE-013-MERGE-WRAPPER-SCRIPTS-MISSING` — all present,
  1 match each. ✓
- `.factory/cycles/cycle-013/burst-log.md`'s F5 entry (Dim-2/5/6/7 attestations) is internally
  consistent with the code/CI evidence independently re-derived above (zero BC/VP change, zero
  `src/` change, `develop` unchanged at `b960c305`, no `.github/` file touched by that specific
  state-management burst). ✓
- `.factory/spec-changelog.md` has no cycle-013 entry — correctly so, since F2 declared zero
  PRD/BC content changes and the changelog tracks PRD-level spec evolution, not ADR/story
  bookkeeping. Not a gap. ✓
- **`STATE.md` vs the actual `.factory/` filesystem state is broken.** `STATE.md` (`version:
  "4.45"`, committed at `factory-artifacts@e7451237`) states, in every headline field
  (`phase`, `current_step`, `current_cycle`, `cycle_013_status`, the Phase Progress table, the
  Current Phase Steps narrative, and the Session Resume Checkpoint's "Resume command"), that
  cycle-013 is at **"Phase F5 CONVERGED, NEXT = Phase F6 targeted hardening"** — i.e., F6 has
  not started. This is factually false against the actual `.factory/` working tree: **`.factory/cycles/cycle-013/phase-f6-hardening/hardening-record.md`
  exists, is fully written, `status: complete`, `verdict: HARDENED_WITH_RESIDUALS`**, dated
  2026-09-16, and covers all six hardening axes with CI evidence citations (PR #818 run
  `35035863974`, PR #822 run `35149165790`). Neither `STATE.md` nor the hardening-record file
  itself has been committed to `factory-artifacts` (`git status` inside `.factory/` shows
  `STATE.md` modified — a **timestamp-only** diff, no narrative update — `sidecar-learning.md`
  modified, and `cycles/cycle-013/phase-f6-hardening/` untracked). **CRIT — see Finding 1.**

---

## Per-dimension verdict summary

| # | Dimension | Verdict |
|---|---|---|
| 1 | spec ↔ code | **PASS** |
| 2 | code ↔ test | **PASS** |
| 3 | traceability | **PASS** |
| 4 | index-consistency | **PASS** (scripts all green) with a flagged input-hash DRIFT set (Finding 2, MED) |
| 5 | ADR-alignment | **PASS** with one adjacent LOW finding (Finding 3) |
| 6 | citation-integrity | **PASS** |
| 7 | cross-references | **FAIL** (Finding 1, CRIT — STATE.md/factory-artifacts drift vs actual F6 completion) |

## Input-hash drift result

**NOT all MATCH.** 5 real DRIFT entries (all one root-cause chain), 2 accepted `[live-state]`
sentinels (not real drift), 4 MATCH. See Dimension 4 table above for the full breakdown and
Finding 2 for remediation.

## Findings

| ID | Severity | Location | Finding | Concrete fix |
|---|---|---|---|---|
| F7-AUDIT-1 | **CRIT** | `.factory/STATE.md` (all headline fields); `.factory/cycles/cycle-013/phase-f6-hardening/hardening-record.md` (untracked); `.factory` `git status` | Phase F6 targeted hardening has been fully executed with a complete, well-evidenced `HARDENED_WITH_RESIDUALS` verdict, but (a) `STATE.md` still narrates "NEXT = Phase F6" everywhere (Phase Progress table, Current Phase Steps, Session Resume Checkpoint, `current_step`/`phase`/`cycle_013_status` frontmatter fields all unedited beyond a bare timestamp bump), and (b) neither `STATE.md`'s update nor the hardening-record file itself is committed to `factory-artifacts` (still on `e7451237`, which predates F6 entirely). The `factory-artifacts` branch — the system of record this task cites as baseline — is stale relative to the actual pipeline state. This must be reconciled before the F7 human gate convenes, or the gate will be evaluating an artifact set (`e7451237`) that misrepresents where the pipeline actually is. | Run the state-manager to (1) add a `CYCLE-013-F6-HARDENED-...` Phase Progress row, (2) rewrite `current_step`/`phase`/`current_cycle`/`cycle_013_status` to read "F6 HARDENED_WITH_RESIDUALS complete, NEXT = Phase F7 delta convergence", (3) commit `STATE.md` + `cycles/cycle-013/phase-f6-hardening/hardening-record.md` + `sidecar-learning.md` to `factory-artifacts` in one atomic burst, per the repo's own Single-Commit Burst Protocol. |
| F7-AUDIT-2 | **MED** | `.factory/cycles/cycle-013/phase-f2-spec-evolution/verification-delta.md`, `phase-f3-stories/S-cycle13-msrv-cargo-ci-atomic-bump.md`, `phase-f3-stories/S-cycle13-letchain-retrofit-convention-cleanup.md`, `phase-f3-stories/S-cycle13-doc-policy-reconciliation.md`, `phase-f3-stories/dependency-graph-extended.md` | Input-hash DRIFT on all 5 artifacts, single root cause: `ADR-0025`'s Wave-2-gate edit (adding the "Status as of 2026-09-16" section) postdates these artifacts' recorded hashes, and `dependency-graph-extended.md`'s three story-file inputs changed (status draft→done) after its own hash was set at F3. Purely a metadata-timing issue — no content contradiction was found in any of the 5 files during this audit (their prose is accurate, as verified in Dimensions 1/3/5) — but it is real, mechanical DRIFT that should not carry into the closed cycle's permanent record. Directly analogous to the cycle-007 F7 precedent's own "Job A" remediation. | Run `bin/compute-input-hash <file> --update` on all 5 files, in topological order (verification-delta.md and the 3 story files first, since they are `dependency-graph-extended.md`'s own inputs; then `dependency-graph-extended.md` last), and commit alongside Finding 1's burst. |
| F7-AUDIT-3 | LOW | `.factory/specs/architecture/decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md:~724-725` | Stale MSRV prose: "`windows-sys` 0.60.2's MSRV against this repo's `rust-version = "1.85"` must be confirmed at F4" — now reads the wrong floor (1.88). This is the same historical-stale-prose class already tracked by `CYCLE-013-F3-HISTORICAL-PLANDOC-MSRV-MENTIONS`, but in an ADR (not a dated plan doc), and its file list does not currently include this location. | Either (a) extend `CYCLE-013-F3-HISTORICAL-PLANDOC-MSRV-MENTIONS`'s file list to include this ADR location, or (b) since ADR-0021 belongs to a CLOSED+RELEASED cycle (cycle-004) and this is a live spec directory (not a dated plan-doc snapshot), consider a one-line prose fix ("...against this repo's `rust-version` floor at the time (1.85; now 1.88, unaffected by this ADR's conclusion) was confirmed at F4") in the same burst as Findings 1/2. Non-blocking either way. |

No HIGH or additional MED/LOW findings beyond the three listed. No finding indicates a defect in
the shipped code, the CI configuration, the BC/test pairing, or any citation — every substantive
piece of the cycle-013 delta itself (Dimensions 1, 2, 3, 6) is clean.

## Overall verdict

**NOT-CONVERGED** at the process-state layer (Finding 1, CRIT — the system-of-record
`factory-artifacts` branch does not yet reflect F6's completion, and `STATE.md`'s own narrative
contradicts the file that already exists on disk). The **code/spec delta itself is CONVERGED**
(Dimensions 1, 2, 3, 6 all clean PASS; Dimension 5 clean PASS aside from one adjacent
pre-existing-class LOW finding; Dimension 4's scripts are all green, with only mechanical
input-hash bookkeeping drift, Finding 2, MED).

**Recommendation:** before the human F7 close/release gate convenes, run a state-manager burst
that (a) commits the F6 hardening-record and reconciles `STATE.md` to say "F6 complete, NEXT =
F7" (Finding 1), and (b) re-hashes the 5 stale cycle-013 artifacts (Finding 2). Finding 3 (LOW)
can be folded into the same burst or deferred at human discretion, consistent with how
`CYCLE-013-F3-HISTORICAL-PLANDOC-MSRV-MENTIONS` was already deferred. None of these require
touching `develop`, re-running CI, or any code change — this is `.factory/` bookkeeping only, and
should not block the human gate on a code/spec-quality basis; it should block it on a
process-integrity basis until the record is honest about what has actually happened.

## Finding counts by severity

- CRIT: 1
- HIGH: 0
- MED: 1
- LOW: 1
- NIT: 0

---

## Re-verification

**producer:** consistency-validator (fresh context) · **timestamp:** 2026-09-16 ·
**develop @** `b960c305` (unchanged since the original audit above) · **factory-artifacts @**
`87cf1bbc` (state-manager remediation burst `d6a5037c` + timestamp-fold `87cf1bbc`, both landed
after the original audit's `e7451237` baseline).

**Purpose:** confirm the two dimensions that FAILED/flagged in the original audit above
(Dimension 4 index-consistency DRIFT, MED; Dimension 7 cross-references, CRIT) are now clean,
and spot-confirm the rest is unaffected. Read-only — no files modified except this append.

### 1. Input-hash drift (Dimension 4) — RE-CHECK

Ran the canonical scan tool (`plugins/vsdd-factory/bin/compute-input-hash --scan cycles/cycle-013`,
vsdd-factory engine repo) from `.factory/`:

```
STALE: cycles/cycle-013/session-checkpoints.md
STALE: cycles/cycle-013/lessons.md
TOTAL=10 MATCH=8 STALE=2 UNCOMPUTED=0 NOINPUT=0 UPDATED=0 UPDATE_FAILED=0
```

**Result: MATCHES the burst's claim exactly.** 8/10 MATCH; the only 2 STALE entries are the
2 accepted `[live-state]` sentinels named in the task (`session-checkpoints.md`,
`lessons.md`) — both frontmatter-confirmed `input-hash: "[live-state]"`, `inputs: [STATE.md]`,
`document_type: session-checkpoints` / `lessons`, i.e. intentionally-untracked archive/rolling
files per the cycle-007 F7 precedent, not real drift. **No unexpected STALE entries.**

Spot-verified the 7 remediated artifacts' frontmatter `input-hash` values against the exact
hashes the burst's `last_amended` narrative claims — all match byte-for-byte:
`verification-delta.md` → `3b233fd`, `S-cycle13-msrv-cargo-ci-atomic-bump.md` → `2f15ce1`,
`S-cycle13-letchain-retrofit-convention-cleanup.md` → `29ac0d0`,
`S-cycle13-doc-policy-reconciliation.md` → `abb7a73`, `dependency-graph-extended.md` →
`93f2753`, `wave-schedule.md` → `0608fae`, `hardening-record.md` → `d68d682`.

**Verdict: Dimension 4 now PASS, clean.** (Original MED finding F7-AUDIT-2 — RESOLVED.)

### 2. Cross-references (Dimension 7) — RE-CHECK

- `STATE.md` frontmatter `version: "4.46"`, `phase`/`current_step`/`current_cycle`/
  `cycle_013_status` all narrate **"Phase F6 targeted hardening COMPLETE
  (HARDENED_WITH_RESIDUALS) ... NEXT = Phase F7 fresh re-verification, then the human
  close/release gate."** Grepped the entire file (235 lines) for the string `"NEXT = F6"` and
  for any residual "F5 CONVERGED, NEXT = Phase F6" framing — **zero matches**. Every headline
  field, the Phase Progress table (`CYCLE-013-F6-HARDENED-2026-09-16` row, `COMPLETE /
  HARDENED_WITH_RESIDUALS`), the Session Resume Checkpoint, and the Blocking Issues /
  Constraints-Carried-Forward sections all agree on the same "F6 complete → NEXT = F7
  re-verification → human gate" narrative. **Internally self-consistent, no lingering
  stale-phase language found anywhere in the file.**
- `cycles/cycle-013/phase-f6-hardening/hardening-record.md` **is tracked** in the
  `factory-artifacts` worktree (`git ls-files` confirms) and was committed in `d6a5037c`
  ("record Phase F6 HARDENED_WITH_RESIDUALS + remediate Phase F7 audit findings
  F7-AUDIT-1/2/3"), one commit before the current tip `87cf1bbc` ("fold in
  stamp-state-timestamp residual from prior Edit").
- `git status` inside `.factory/` (factory-artifacts, up to date with `origin/factory-artifacts`)
  shows exactly 2 modified, unstaged files: `STATE.md` (diff is a single `timestamp:`
  frontmatter field bump, `22:41:14Z` → `22:41:51Z`, zero narrative change) and
  `sidecar-learning.md` (diff is one appended `- Session ended at 2026-09-16T22:43:13Z
  (awaiting /session-review)` line). Both are the benign hook-driven timestamp/session-log
  churn the task anticipated ("git status clean or only benign timestamp churn") — not
  unreconciled drift; no other file is dirty or untracked.
- `stories/STORY-INDEX.md` shows all 3 cycle-013 stories (`S-cycle13-msrv-cargo-ci-atomic-bump`,
  `S-cycle13-letchain-retrofit-convention-cleanup`, `S-cycle13-doc-policy-reconciliation`) at
  `status: done`, each citing its correct merge commit/PR — consistent with STATE.md's F4-COMPLETE
  narrative.
- `cycles/CYCLE-SUMMARY.md` has no `cycle_013_status` section, which is *correct* (not drift):
  that file only receives an extracted section when a cycle is compacted out of STATE.md's live
  frontmatter at cycle CLOSE; cycle-013 is still ACTIVE, so its full status legitimately lives
  inline in STATE.md's own `cycle_013_status` frontmatter field, exactly as observed.

**Verdict: Dimension 7 now PASS, clean.** (Original CRIT finding F7-AUDIT-1 — RESOLVED.)

### 3. Index-consistency guards — RE-RUN

| Guard | Result | Exit |
|---|---|---|
| `scripts/check-spec-counts.sh` | `Check passed: 8 bc files validated` | **0** |
| `scripts/check-bc-cumulative-counts.sh` | `OK: all cumulative BC counts verified (**769** total across 9 files; Surface H footer checked where present).` | **0** |
| `cargo test --test claude_md_citations` | **61 passed**; 0 failed; 0 ignored (includes `test_claude_md_citations_resolve_to_real_files`) | green |

All three match the task's expectation (0/0/green, 769 BCs, 61/61) exactly.

### 4. Code/spec dimensions — spot-confirmed unaffected

- **ADR-0025** (`specs/architecture/decisions/ADR-0025-raise-msrv-to-1-88.md`): `status:
  proposed` — unchanged, as expected (flips to `Accepted` only at the human F7 gate).
- **`Cargo.toml`**: `rust-version = "1.88"` — matches spec.
- **`.github/workflows/ci.yml`** `msrv` job: `toolchain: "1.88.0"` +
  `RUSTUP_TOOLCHAIN: "1.88.0"` + `cargo check --all-targets --all-features --locked` — matches
  spec (both the toolchain pin and the `--all-targets` scope widening are present).
- **ADR-0021** (`specs/architecture/decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md:725`):
  now reads "...against this repo's `rust-version` floor at the time (1.85; now 1.88 under
  ADR-0025, unaffected by this ADR's conclusion)..." — the stale-1.85-only prose is fixed.
  `CYCLE-013-F3-HISTORICAL-PLANDOC-MSRV-MENTIONS` in `cycles/OPEN-STANDING-ITEMS.md` shows its
  scope broadened 2026-09-16 to "historical/closed docs including ADRs" with this ADR's location
  cited. (Original LOW finding F7-AUDIT-3 — RESOLVED.)
- No `src/` changes since the original audit (`develop` head unchanged at `b960c305`); Dimensions
  1 (spec↔code), 2 (code↔test), 3 (traceability), and 6 (citation-integrity), all clean PASS in
  the original audit and untouched by this bookkeeping-only remediation, stand unchanged.

### Per-dimension verdict summary (re-verification)

| # | Dimension | Original verdict | Re-verified verdict |
|---|---|---|---|
| 1 | spec ↔ code | PASS | PASS (unchanged, not re-derived — no code/spec delta) |
| 2 | code ↔ test | PASS | PASS (unchanged, not re-derived) |
| 3 | traceability | PASS | PASS (unchanged, not re-derived) |
| 4 | index-consistency | PASS w/ MED drift finding | **PASS, clean** (F7-AUDIT-2 RESOLVED) |
| 5 | ADR-alignment | PASS w/ adjacent LOW finding | **PASS, clean** (F7-AUDIT-3 RESOLVED) |
| 6 | citation-integrity | PASS | PASS (unchanged, not re-derived) |
| 7 | cross-references | **FAIL** | **PASS** (F7-AUDIT-1 RESOLVED) |

### Overall verdict

**CONVERGED.** All three original findings (F7-AUDIT-1 CRIT, F7-AUDIT-2 MED, F7-AUDIT-3 LOW) are
independently confirmed RESOLVED by this fresh-context re-verification: the input-hash scan
shows only the 2 accepted `[live-state]` sentinels stale (8/10 MATCH, zero unexpected drift);
`STATE.md` and the actual `.factory/` filesystem state agree with each other everywhere (no
lingering "NEXT = F6" language anywhere in the file); `hardening-record.md` is committed and
tracked on `factory-artifacts`; the worktree's only uncommitted changes are the two anticipated
benign timestamp/session-log churn lines. All three CI-facing index-consistency guards re-run
green (0/0/green, 769 BCs, 61/61). The code/spec dimensions (ADR-0025 `proposed`, Cargo.toml
1.88, ci.yml msrv job 1.88.0+`--all-targets`, ADR-0021 prose fix) remain exactly as the prior
audit found them. **The pipeline is genuinely CONVERGED and ready for the human close/release
gate.** No further remediation required before that gate convenes.
