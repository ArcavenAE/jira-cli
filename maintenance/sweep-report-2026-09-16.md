# Maintenance Sweep Report — 2026-09-16

**Trigger:** manual (human, resume session). **Mode:** maintenance bookkeeping + dependency/doc
cleanup — pipeline stayed **PAUSED** throughout (no cycle ACTIVE, 008-011 remain PARKED); no DEC
minted. `develop` advanced `01e278fc` → `0496834d` (12 PRs merged this sweep). Counts unchanged:
769 BCs / 86 VPs / 118 holdout / 185 stories.

**Final verification:** `cargo deny check` on merged `develop @ 0496834d` — `advisories ok, bans
ok, licenses ok, sources ok`. Clean.

## Sweeps run

### 1. Dependency Audit (dx-engineer scan + security-reviewer analysis)

**Posture: CLEAN.** `cargo audit` scanned 359 crate dependencies against a freshly-fetched
advisory DB (1246 advisories) — **0 RUSTSEC advisories**, corroborated by a second isolated
re-run. `cargo deny check` passed all four gated categories (`advisories`, `bans`, `licenses`,
`sources`) — exit 0.

**Blocker discovered and resolved:** the `syn` crate's 3.0 major release (2026-07-18) plus the
`windows-targets` 0.53 lineage created transitional duplicate-version conflicts
(`deny.toml`'s `multiple-versions = deny` under `[bans]`) that blocked every queued cargo bump
adopting either lineage. Both were investigated for true convergeability and, finding none
available yet, resolved via **two temporary, precedent-following `deny.toml` `[[bans.skip]]`
entries**, each with a documented removal trigger:

| Skip | PR | Removal trigger | Verdict |
|---|---|---|---|
| `syn` 2/3 duplicate | #826 | Remove once `cargo tree -i syn` shows a single version. Upstream holdouts: `pear_codegen`, `proc-macro2-diagnostics`, `tracing-attributes`. | NOT-CONVERGEABLE-NOW |
| `windows_i686_gnullvm` 0.53 duplicate | #830 | Remove once `cargo tree -i windows_i686_gnullvm` shows a single version. Upstream holdout: `keyring` 3→4. | NOT-CONVERGEABLE-NOW |

Full investigations: `maintenance/syn-convergence-investigation-2026-09-16.md`,
`maintenance/windows-targets-convergence-investigation-2026-09-16.md`.

Raw scan output and analysis:
- `maintenance/dependency-audit-raw-2026-09-16.log`
- `maintenance/dependency-audit-raw-summary-2026-09-16.md`
- `maintenance/dependency-audit-analysis-2026-09-16.md`

### 2. Documentation Drift (technical-writer)

7 findings (1 HIGH, 2 MEDIUM, 4 LOW) — **ALL fixed** (folded into PR #825).

| ID | File | Severity | Summary |
|---|---|---|---|
| DRIFT-001 | README.md | HIGH | Entire `jr component` command family (`list`/`create`/`edit`/`delete`/`rename`) absent from README's Commands table. |
| DRIFT-002 | README.md | MEDIUM | `jr issue attachment` `download`/`upload`/`delete` subcommands undocumented (only `list` covered). |
| DRIFT-003 | README.md | LOW | Shell-completions list omits `elvish`/`powershell` (both supported per `--help`). |
| DRIFT-004 | CLAUDE.md | MEDIUM | "`sprint list` omits start/end dates" is stale — only start date is actually omitted; end date is rendered. |
| DRIFT-005 | CLAUDE.md | LOW | "`jr version --output json` is not implemented" phrasing implies a `jr version` subcommand exists; it doesn't (only builtin `-V`/`--version`). |
| DRIFT-006 | CLAUDE.md | LOW | `cli/mod.rs` LOC figure stale (documented ~1,356, actual 1,453, +7.2%). |
| DRIFT-007 | CLAUDE.md | LOW | `cli/issue/comments.rs` inline LOC annotation stale (documented ~61, actual 64). |

Verified clean (no drift): MSRV 1.88 claim consistency, `--dry-run` on `issue edit`, `_meta`
envelope absence, `cli/component.rs` single-file claim, full architecture-tree diff (123 `.rs`
files, zero discrepancies), ADR index (docs/adr/ = ADR-0001..0016; `.factory/.../decisions/` =
ADR-0017..0025), `docs/specs/` non-empty, TODO/FIXME/HACK/XXX scan (zero genuine developer
markers), CHANGELOG `[Unreleased]` coherence.

Full findings: `maintenance/doc-drift-findings-2026-09-16.md`

### 3. Pattern Consistency (consistency-validator)

4 CLAUDE.md "Known Size Deviations" doc gaps — **ALL fixed** (folded into PR #825):

| ID | Location | Severity | Summary |
|---|---|---|---|
| PAT-001 | `src/cli/field.rs` (1,901 LOC) | Major | Crosses ADR-0012's 1,000-LOC shard threshold; no CLAUDE.md entry. |
| PAT-002 | `src/cli/auth/login.rs` (1,869 LOC) | Major | Same — crosses threshold, no CLAUDE.md entry. |
| PAT-003 | `src/cli/auth/tests/mod.rs` (2,484 LOC) | Low | Largest `src/cli/` file by LOC; literal-text ADR-0012 crossing (test module), undocumented. |
| PAT-004 | `cli/issue/edit.rs` (actual 3,287 vs documented ~3,187 LOC); `cli/mod.rs` (actual 1,453 vs documented ~1,356 LOC) | Low | Two already-documented entries drifted ~100 LOC without a re-measurement note. |

Clean confirmations: no raw panics in production code paths (~55 `panic!` hits, all in
`#[test]`/`#[cfg(test)]`); exactly 1 non-`main.rs` `process::exit` (justified, documented
in-line — PAT-005, informational only, no fix needed); only 2 `#[allow(...)]` suppressions
repo-wide, both carrying required justification comments; **zero #526 JSON-render-invariant
violations** (every `OutputFormat::Json`-branching file in `src/cli/` routes through
`render_json`/`print_output`); test-naming spot-check of 5 absolute-claim test names — all
matched their bodies.

### 4. Holdout Freshness — **SKIPPED by human decision**

### 5. Performance Regression — **SKIPPED by human decision**

### 6. DTU Fidelity — **N/A** (`dtu_required: false`, CLI-only product, no third-party service
clones in scope)

### 7. Spec Coherence (consistency-validator)

All 5 automated guard scripts **PASS**, exit 0:

| Script | Result |
|---|---|
| `check-spec-counts.sh` | PASS — 8 BC files validated |
| `check-bc-cumulative-counts.sh` | PASS — 769 total across 9 files |
| `check-bc-no-numeric-test-counts.sh` | PASS — no numeric test counts in Trace/Source |
| `check-bc-citation-symbols.sh` | PASS — 525 citations checked |
| `check-cargo-mutants-policy-citations.sh` | PASS — 22 bullets / 77 (file,fn) pairs validated |

Canonical counts independently confirmed against baseline: 769 BCs / 118 holdout / 185 stories —
all match. VP count (86) could not be independently cross-checked (no single VP registry exists;
namespaced-per-feature VP IDs).

Three findings, all **KNOWN/BACKLOGGED, not new drift**:

| ID | Summary | Status |
|---|---|---|
| SPEC-001 | No canonical `VP-INDEX.md`/registry exists; VPs are namespaced per-feature. | Known — backlog story `S-PG-VP-REGISTRY-1` exists to close it. |
| SPEC-002 | BC→story coverage tooling gap; a raw grep-and-eyeball proxy is unreliable (33% false-positive-prone on sampling). | Known — recommend a dedicated `check-bc-story-coverage.sh` guard (not yet built). |
| SPEC-003 | L2 domain-spec `bc_count` stale for 4 files; `bc-08-components.md` doesn't exist at L2. | Known — self-documented accepted convention in `CANONICAL-COUNTS.md`. |

Full findings: `maintenance/pattern-and-spec-findings-2026-09-16.md`

### 8. Tech-Debt Register (orchestrator)

No formal due-date debt register exists; `cycles/OPEN-STANDING-ITEMS.md` serves as the
project's debt log. **No overdue items found.**

### 9. Accessibility — **N/A** (CLI-only product, no UI surface)

## PRs merged this sweep (12 total, all squash-merged to `develop`)

All Dependabot/dependency PRs were security-triaged CLEAN (no RUSTSEC advisories introduced) and
verified green (CI) before merge. Merge method: **admin squash** — branch protection requires
code-owner approval, which Dependabot PRs structurally lack; the human explicitly authorized
admin-bypass for these CI-green, reviewed PRs. Doc PR #825 and both `deny.toml` skip PRs
(#826, #830) each additionally received a fresh-eyes `pr-reviewer` **APPROVE**.

| PR | Subject |
|---|---|
| #825 | docs: README + CLAUDE.md reconciliation (11 findings: 7 doc-drift + 4 pattern-consistency) |
| #826 | `deny.toml`: `syn` 2/3 transitional skip |
| #830 | `deny.toml`: `windows_i686_gnullvm` 0.53 transitional skip |
| #821 | `codeql-action/upload-sarif` → 4.38.0 |
| #820 | `taiki-e/install-action` → 2.87.9 |
| #829 | `taiki-e/install-action` → 2.87.10 |
| #738 | `open` → 5.4.3 |
| #730 | `futures` → 0.3.34 |
| #729 | `thiserror` → 2.0.20 |
| #688 | `serde` → 1.0.229 |
| #828 | `toml` → 1.1.5+spec-1.1.0 |
| #727 | `clap` → 4.6.6 |

`develop`: `01e278fc` → `0496834d`.

## Still open / out of sweep scope (recorded, not actioned)

| PR | Note |
|---|---|
| #827 | **DUPLICATE** of #628 ("ci: guard scorecard behind SCORECARD_ENABLED") — flagged for human dedup decision. |
| #628 | **DUPLICATE** of #827 — same. |
| #574 | "ci: attest build provenance" — pre-existing non-Dependabot CI-infra PR, needs separate human review. |

## Process-gap findings (appended to `cycles/OPEN-STANDING-ITEMS.md`)

1. **`pr-manager-completion-guard` Stop hook premature-stop** — fired with a hardcoded/incorrect
   `AUTHORIZE_MERGE=yes` claim regardless of actual (review-only) dispatch. **Recurrence** of
   `CYCLE-013-PR-MANAGER-COMPLETION-GUARD-PREMATURE-STOP`. Agents correctly refused to act on it.
2. **`validate-pr-review-posted` Stop hook mismatch** — demanded a `gh pr review --approve`
   posting that conflicts with review-only dispatches. **Recurrence** of
   `CYCLE-013-VALIDATE-PR-REVIEW-POSTED-HOOK-MISMATCH`. Fired on the #825, #826, #830 reviews.
3. **github-ops sub-agent stall** — `pr-manager` hung waiting on a `github-ops` PR-creation
   sub-dispatch that never returned (PR #825 was actually created; the reply never propagated).
   **Recurrence** of the `CYCLE-013-PR-REVIEWER-SUBAGENT-STALL` class. Mitigation used this
   sweep: have the authoring agent run `gh pr create` directly instead of delegating to
   `github-ops`.
4. **NEW — `validate-factory-path-staging` hook false-positive (recurrence of the *mechanism*
   behind `CYCLE-013-HOOK-FALSE-POSITIVE-COMMIT-MSG-SCAN`, different trigger):** blocked a commit
   because the commit **message text** contained a literal `.factory/...` path substring, even
   though no `.factory` file was staged. Workaround: reword commit messages to avoid literal
   `.factory/` path substrings.
5. **NEW — dependency-handling operational learnings:**
   - `@dependabot rebase` **no-ops** when a PR is already MERGEABLE (no conflict) — it only
     rebases to resolve conflicts, not to refresh CI against a moved base. Use
     `@dependabot recreate` to force a rebuild against current `develop`.
   - The "Dependabot Updates" runner queue can stall for many minutes.
   - Sequential merges of cargo bumps re-conflict each other's `Cargo.lock` — recreate the next
     queued PR immediately after each merge.
6. **NEW — Claude Code auto-mode classifier non-determinism:** the "Merge Without Review" /
   "Modify Shared Resources" classifier blocked agent-initiated admin merges and branch pushes
   **non-deterministically** (allowed one batch, blocked others). Net effect: merges required
   direct orchestrator action with per-merge human go-ahead; branch-push retriggers were fully
   blocked. Noted for future sweeps.

## Standing items to track (appended to `cycles/OPEN-STANDING-ITEMS.md`)

- **Two temporary `deny.toml` skips now active:** `syn` 2/3 (#826) and `windows_i686_gnullvm`
  0.53 (#830). Each has a removal trigger (see table above). Track for removal when the syn-3 /
  windows-targets-0.53 ecosystem migration completes.
- **Unrelated convergence opportunity spotted:** `jni` 0.22.4 + `rustls-platform-verifier` 0.7.0
  would collapse the `windows-sys` 0.45 lineage — candidate for a future sweep.

## Artifacts

- `.factory/maintenance/sweep-report-2026-09-16.md` (this file)
- `.factory/maintenance/dependency-audit-raw-2026-09-16.log`
- `.factory/maintenance/dependency-audit-raw-summary-2026-09-16.md`
- `.factory/maintenance/dependency-audit-analysis-2026-09-16.md`
- `.factory/maintenance/doc-drift-findings-2026-09-16.md`
- `.factory/maintenance/pattern-and-spec-findings-2026-09-16.md`
- `.factory/maintenance/syn-convergence-investigation-2026-09-16.md`
- `.factory/maintenance/windows-targets-convergence-investigation-2026-09-16.md`
