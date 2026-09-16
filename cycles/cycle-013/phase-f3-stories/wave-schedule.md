---
document_type: wave-schedule
level: ops
version: "1.0"
phase: phase-f3-incremental-stories
cycle: cycle-013
feature: msrv-1.88-bump
status: draft
producer: story-writer
created: 2026-09-15
timestamp: "2026-09-15T00:00:00"
inputs:
  - ".factory/cycles/cycle-013/phase-f3-stories/dependency-graph-extended.md"
traces_to: "dependency-graph-extended.md §3"
input-hash: "0608fae"
---

# F3 Wave Schedule — `msrv-1.88-bump` (cycle-013)

Wave grouping by Kahn-layering (BFS levels over the acyclic 3-node graph proven in
`dependency-graph-extended.md` §3).

## Summary

| Metric | Value |
|--------|-------|
| Total stories (this cycle) | 3 |
| Total waves | 2 |
| Max parallelism (stories in one wave) | 2 (Wave 2: S2, S3) |
| Total story points | 12 (S1: 5, S2: 5, S3: 2) |
| Critical path | S1 -> S2 (5 + 5 = 10 points; S3's 2 points run in parallel with S2 in Wave 2 and does not extend the critical path) |
| Estimated agent spawns | 3 (one implementer dispatch per story) |

---

## 1. Layering Derivation

| Round | Indegree-0 set at this round | Wave |
|-------|----------------------------------|------|
| 1 | {S1} | **Wave 1** |
| 2 | {S2, S3} (both reach indegree 0 only after S1's Wave-1 completion) | **Wave 2** |

**Computed layering — 2 waves:** S1 has `depends_on: []` and reaches indegree 0 immediately
(Wave 1, sole story). S2 and S3 both depend on S1 (compile-order dependency for S2, per
`dependency-graph-extended.md` §4; content-accuracy dependency for S3, same section) and reach
indegree 0 only once S1 completes and merges (Wave 2, both parallel — no edge between them).
This matches the human F1-gate's own expected default shape ("likely Wave 1 = S1; Wave 2 = S2 +
S3").

---

## 2. File-Overlap Check

**Note (Pass-4, F-D):** `tests/common/wf.rs` is deliberately NOT listed as a "touched" file below.
It is READ-ONLY / out-of-scope for S1 (F-H1, Pass-3, reaffirmed by `affected-files.txt`'s Pass-4
F-D removal note): S1 greps it once, at Task 9, only to confirm its ~L1782-1784 decoy-attack
narrative stays on the AC-008 DECOY-PRESERVE allow-list — it is never edited by any cycle-013
story.

| Story | Primary file(s) touched |
|-------|-----------------------------|
| S1 (`msrv-cargo-ci-atomic-bump`) | `Cargo.toml`, `.github/workflows/ci.yml`, `tests/ci_gate_completeness.rs`, `CHANGELOG.md` |
| S2 (`letchain-retrofit-convention-cleanup`) | `src/cli/auth/keychain.rs`, `src/cli/board.rs`, `src/cli/issue/list.rs`, `CLAUDE.md`, `.factory/specs/prd/bc-5-boards-sprints.md`, `.factory/specs/prd/cross-cutting.md`, `CHANGELOG.md` |
| S3 (`doc-policy-reconciliation`) | `README.md`, `CHANGELOG.md`, `docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md`, `CLAUDE.md` |

**Overlap found: S2 and S3 both touch `CLAUDE.md` and `CHANGELOG.md`, in the SAME Wave (Wave
2).** Full accounting already performed in `dependency-graph-extended.md` §5; summarized here
for wave-execution purposes:

- **`CLAUDE.md`:** S2 deletes the standalone "No let-chains" Conventions-section bullet; S3
  edits the separate Gotchas-section SHA/version-citation bullet. Disjoint sections, no
  line-level collision expected. **Resolution: NOT a `depends_on:` edge** — no functional
  build-order requirement between the two edits. **Recommended intra-wave sequencing:**
  whichever of S2/S3's PRs is ready first should land first; the other rebases onto it before
  merging (same pattern as cycle-003 Wave 4 and cycle-007's A/B1 `auth.rs` overlap).
- **`CHANGELOG.md`:** append-only shared file across all three stories (S1 in Wave 1; S2 and S3
  in Wave 2). S3's own AC-002 explicitly instructs checking S1's and S2's entries for
  duplication before appending its own — this is the mechanism that keeps three stories'
  append-only edits to the same section coherent without a graph edge.

Both S2 and S3 may be **DISPATCHED** in parallel in Wave 2; only the **MERGE** order of the
`CLAUDE.md`/`CHANGELOG.md` touches needs light coordination, consistent with this project's
established precedent for same-wave same-file overlaps.

---

## 3. Wave Execution Plan

### Wave 1

| Story | Points | Blocks |
|-------|--------|--------|
| `S-cycle13-msrv-cargo-ci-atomic-bump` | 5 | `S-cycle13-letchain-retrofit-convention-cleanup`, `S-cycle13-doc-policy-reconciliation` |

**Gate before Wave 2 dispatch:** `S-cycle13-msrv-cargo-ci-atomic-bump`'s PR must be MERGED and
the `msrv` CI job GREEN at 1.88.0 (not merely "PR opened") before dispatching Wave 2 — both
Wave-2 stories have a real dependency on this story's actual landed state (compile-order for
S2, content-accuracy for S3), not just its existence as a story file. This is stricter than the
default "story status: done" gate and should be called out explicitly at Wave-1-complete
handoff.

### Wave 2 (parallel)

| Story | Points | Depends On |
|-------|--------|------------|
| `S-cycle13-letchain-retrofit-convention-cleanup` | 5 | `S-cycle13-msrv-cargo-ci-atomic-bump` (compile-order) |
| `S-cycle13-doc-policy-reconciliation` | 2 | `S-cycle13-msrv-cargo-ci-atomic-bump` (content-accuracy) |

Both stories are dispatch-eligible simultaneously once the Wave 1 gate above is satisfied.
Recommended intra-wave merge-order sequencing (§2): either order is fine; whichever PR is ready
first merges first, the other rebases over the shared `CLAUDE.md`/`CHANGELOG.md` touches.

---

## 4. Wave Holdout Scenarios

Per the F3 skill's Step 7b, cross-story integration and regression scenarios for this cycle's
2 waves:

### Wave 1 holdout (MUST-PASS)

1. **Atomic-commit integrity:** a fresh checkout of `develop` after Wave 1 merges shows
   `Cargo.toml`'s `rust-version = "1.88"`, `.github/workflows/ci.yml`'s `msrv` job pinned to
   `1.88.0`, AND `tests/ci_gate_completeness.rs`'s `test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env`
   passing against that same `ci.yml` — all three simultaneously true (never a state where one
   lags the other).
2. **`--all-targets` regression check:** `cargo check --all-targets --locked` under a real
   1.88.0 toolchain succeeds cleanly post-merge (this is the first time this repo's full
   `tests/` tree and inline `#[cfg(test)]` modules are validated against the MSRV floor — a
   previously-untested code path becoming newly gated).
3. **Full regression suite:** `cargo test` (all binaries, not just `ci_gate_completeness`)
   passes, including the `list_table_snapshot` insta snapshot in whatever state AC-006 left it
   (either unchanged, or changed-and-reviewed-accepted).

### Wave 2 holdout (MUST-PASS)

4. **Team-column parity, full suite:** after S2 merges, `tests/team_column_parity.rs` (every
   test in the file, not just the board.rs/list.rs-specific subset) and the team-column tests in
   `tests/cli_handler.rs` all pass — proving the let-chain retrofit at the two BC-5.3.001/
   BC-5.3.002 sites is outcome-preserving.
5. **`keychain.rs` credential resolution, full suite:** the existing unit tests covering
   `src/cli/auth/keychain.rs`'s env-var-then-prompt resolution helper pass unmodified in outcome
   after its let-chain retrofit.
6. **No dead citations:** `tests/claude_md_citations.rs::test_claude_md_citations_resolve_to_real_files`
   passes after both S2 (CLAUDE.md convention-entry deletion) and S3 (CLAUDE.md SHA/version-citation
   fixes) land — proving neither edit orphaned a file-path citation elsewhere in the document.
7. **No CHANGELOG duplication:** `CHANGELOG.md`'s `[Unreleased]` section, read after Wave 2
   completes, contains no contradictory or near-duplicate entries describing the same MSRV bump
   across S1/S2/S3's three separate appends (manual PR-review-level check, not an automated
   test — see S3 AC-002).

### Wave 2 holdout (SHOULD-PASS)

8. **Design-spec / ADR-0025 consistency:** the design spec's rewritten MSRV Policy section
   (S3 AC-003) and ADR-0025's Decision section state the same going-forward policy language
   ("bump as needed... driven by dependency floor and ecosystem pressure") without drifting into
   a third, independently-invented phrasing.

---

## 5. Human Approval Gate (F3, per skill Step 9)

This wave schedule, the 3 story files, and the extended dependency graph are presented for
explicit human approval before any F4 dispatch. Per the task framing for this F3 pass: **no DEC
is minted by this burst** — that is the orchestrator's F3 human-gate action, not story-writer's.
`STATE.md` is not touched by this burst.
