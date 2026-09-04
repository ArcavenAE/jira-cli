---
document_type: wave-schedule
level: ops
version: "1.0"
phase: phase-f3-incremental-stories
cycle: cycle-004
feature: windows-correctness
status: draft
producer: story-writer
created: 2026-09-04
timestamp: "2026-09-04T00:00:00"
inputs:
  - ".factory/cycles/cycle-004/phase-f3-stories/dependency-graph-extended.md"
  - ".factory/cycles/cycle-004/phase-f3-stories/conflict-report.md"
  - ".factory/cycles/cycle-004/phase-f3-stories/decomposition-manifest.md"
traces_to: "dependency-graph-extended.md §4a; DEC-335"
input-hash: "ae9fd49"
---

# F3 Wave Schedule — `windows-correctness` (cycle-004)

Wave grouping by Kahn-layering (BFS levels over the acyclic graph proven in
`dependency-graph-extended.md` §4a).

## Summary

| Metric | Value |
|--------|-------|
| Total stories (this cycle) | 4 |
| Total waves | 2 |
| Max parallelism (stories in one wave) | 2 (both waves) |
| Estimated agent spawns | 4 (one implementer dispatch per story) |

---

## 1. Layering Derivation

| Round | Indegree-0 set at this round | Wave |
|---|---|---|
| 1 | {A (`dpapi-storage-fix`), B (`cloud-id-correctness`)} | **Wave 1** |
| 2 (after removing A, B) | {C (`honest-fail-message`), D (`windows-docs`)} | **Wave 2** |

**Computed layering — 2 waves:**

| Wave | Stories | Parallelism |
|---|---|---|
| 1 | `S-cycle4-dpapi-storage-fix`, `S-cycle4-cloud-id-correctness` | 2-way parallel |
| 2 | `S-cycle4-honest-fail-message`, `S-cycle4-windows-docs` | 2-way parallel |

---

## 2. File-Overlap Check for Wave 1's Parallel Pair

`S-cycle4-dpapi-storage-fix` touches: `src/api/auth.rs`, `src/api/auth_windows_store.rs`
(new), `src/api/mod.rs`, `Cargo.toml`, `deny.toml`, and DPAPI-focused test files.

`S-cycle4-cloud-id-correctness` touches: `src/cli/auth/login.rs`,
`src/cli/auth/refresh.rs`, `src/cli/init.rs`, `src/api/jira/tenant.rs` (new),
`src/api/jira/mod.rs`, `src/config.rs`/`src/api/client.rs` (read-only, no modification),
and `cloud_id`-focused test files.

**Zero SOURCE/test-code file overlap.** These are genuinely independent worktrees for
`src/`, `tests/`, `Cargo.toml`, and `deny.toml` — no rebase-churn risk on any of those files,
no need for an intra-wave delivery-order recommendation (unlike cycle-003's Wave 4, which
needed one due to real file overlap).

**Correction (F3 re-review, 2026-09-04, Finding #1) — the prior "zero file overlap" claim
was FALSE once `CHANGELOG.md` is counted.** Both Wave 1 stories' Task lists require a
`CHANGELOG.md` entry under `[Unreleased]` (`S-cycle4-dpapi-storage-fix` Task 20,
`S-cycle4-cloud-id-correctness` Task 17) — a file neither story's original File Structure
Requirements table listed (fixed in each story file by this same re-review pass). See §7a
below for the corrected overlap statement covering the FULL cycle, including Wave 2.

## 3. File-Overlap Check for Wave 2's Parallel Pair

`S-cycle4-honest-fail-message` touches only `src/api/auth.rs` (two `map_err` closures) and
test files.

`S-cycle4-windows-docs` touches only `README.md` and `CHANGELOG.md`.

**Zero SOURCE/test-code file overlap** between the two Wave 2 stories (`src/api/auth.rs`
and test files vs. `README.md`) — genuinely independent on those files.

**Correction (F3 re-review, 2026-09-04, Finding #1) — `CHANGELOG.md` is NOT
overlap-free here either.** `S-cycle4-honest-fail-message` Task 14 also requires a
`CHANGELOG.md` entry (fixed in that story's File Structure Requirements table by this same
re-review pass), so BOTH Wave 2 stories touch `CHANGELOG.md`, exactly as both Wave 1
stories do. See §7a below.

---

## Wave Plan

### Wave 1 — `S-cycle4-dpapi-storage-fix` + `S-cycle4-cloud-id-correctness`

- **Stories:** 2, run in parallel.
- **Points:** 13 + 8 = 21.
- **File overlap:** none on `src/`/`tests/`/`Cargo.toml`/`deny.toml` (§2); both stories
  append their own line to `CHANGELOG.md`'s `[Unreleased]` section — a trivial
  append-collision, not a real conflict (§7a).
- **Gate:** standard wave-gate (full regression on `develop`, adversarial review of the
  wave diff, holdout eval, demo evidence per §6 below) before Wave 2 opens.
- **Windows validation note (DEC-335):** `S-cycle4-dpapi-storage-fix`'s F4 CI spike
  (does `windows-latest` CI exercise DPAPI end-to-end?) should run during this wave, since
  its outcome informs how Wave 1's own wave-gate demo evidence is captured (automated
  Windows-CI evidence vs. a placeholder pending the F7 manual gate).

### Wave 2 — `S-cycle4-honest-fail-message` + `S-cycle4-windows-docs`

- **Stories:** 2, run in parallel.
- **Points:** 5 + 3 = 8.
- **File overlap:** none on `src/`/`tests/`/`README.md` (§3); both stories append their
  own line to `CHANGELOG.md`'s `[Unreleased]` section — a trivial append-collision, not a
  real conflict (§7a).
- **Depends on:** Wave 1's `S-cycle4-dpapi-storage-fix` (for `S-cycle4-honest-fail-message`'s
  marker types) and Wave 1's `S-cycle4-cloud-id-correctness` (for
  `S-cycle4-windows-docs`'s content accuracy) — both Wave-1 stories must have their
  respective relevant surface (marker types; finalized `cloud_id` fetch contract) merged
  before Wave 2 starts, though NOT necessarily Wave 1's full wave-gate closing for the
  half of Wave 1 each Wave-2 story doesn't depend on (see §5 Pipeline Overlap Plan).
- **Gate:** standard wave-gate; this is the cycle's FINAL wave — its gate closing is a
  precondition for cycle-004's F7 delta-convergence gate (not merely this wave's own
  completion).

---

## Pipeline Overlap Plan

| Parallel Activity | When |
|---|---|
| `S-cycle4-honest-fail-message` stub scaffolding + test authorship | Can start once `S-cycle4-dpapi-storage-fix`'s `DpapiFallbackFailed`/`ProfilePathEscape` marker-type SIGNATURES are merged (its dependency is on the types existing, not on Wave 1's full wave-gate closing) |
| `S-cycle4-windows-docs`'s install-steps and path-table sections (AC-001/002/003) | Can start immediately in Wave 1, in parallel with `S-cycle4-cloud-id-correctness` — these three ACs have NO dependency on `cloud_id`; only AC-004 (the `cloud_id` caveat paragraph) needs `S-cycle4-cloud-id-correctness`'s finalized contract |
| `S-cycle4-windows-docs`'s `cloud_id` caveat (AC-004) | Waits for `S-cycle4-cloud-id-correctness`'s BC-1.2.052/053 acceptance criteria text to be finalized/merged — the actual trigger for this cycle's Wave-2 placement |

This overlap plan means `S-cycle4-windows-docs` is, in practice, mostly parallelizable
with Wave 1 rather than strictly blocked until Wave 1 closes — only AC-004 is a true
Wave-2 gate item. This is standard TDD-pipeline staggering (documented, not a change to
the wave boundary in §1).

---

## 4. Windows-Validation Schedule (DEC-335)

Per `decomposition-manifest.md` §5 and `S-cycle4-dpapi-storage-fix.md`'s own "Windows
Validation" section:

| Item | Wave | Required? |
|---|---|---|
| F4 CI spike: does `windows-latest` GitHub Actions CI exercise `CryptProtectData` headlessly? | Wave 1 (during `S-cycle4-dpapi-storage-fix`'s F4 delivery) | REQUIRED |
| F7 manual Windows smoke-test gate: human reproduces #759's repro steps on real Windows 11 | AFTER Wave 2 closes, BEFORE cycle-004's F7 delta-convergence gate | REQUIRED, NOT optional |

The F7 manual gate is scheduled after BOTH waves close (not merely Wave 1) because
`S-cycle4-honest-fail-message`'s Site 1/3 message text is part of what a full,
realistic #759 repro exercises (a user attempting `jr auth login --oauth` with an
oversized token that ALSO fails the DPAPI fallback should see the honest-fail message,
not just the DPAPI success path) — though the DPAPI SUCCESS round-trip itself
(the primary #759 fix) is exercisable as soon as Wave 1 closes.

---

## 5. Critical Path

Two independent chains of equal length (2 stories each) — there is no single longest
chain, but for wave-scheduling purposes the CYCLE's critical path is the longer of the
two by POINTS, since both chains share the same wave count:

```
S-cycle4-dpapi-storage-fix (Wave 1, 13 pts)
  -> S-cycle4-honest-fail-message (Wave 2, 5 pts)
```
**18 points**, vs. the `cloud-id-correctness -> windows-docs` chain's **11 points**
(8 + 3). The `dpapi-storage-fix`/`honest-fail-message` chain is therefore this cycle's
critical path by effort, though both chains resolve in exactly 2 waves.

**Critical path length: 2 stories / 2 waves, 18 points.**

---

## 6. Total Feature Points

| Story | Wave | Points |
|---|---|---|
| `S-cycle4-dpapi-storage-fix` | 1 | 13 |
| `S-cycle4-cloud-id-correctness` | 1 | 8 |
| `S-cycle4-honest-fail-message` | 2 | 5 |
| `S-cycle4-windows-docs` | 2 | 3 |
| **Total** | — | **29** |

Matches `decomposition-manifest.md` §7's total exactly.

---

## 7. Conflict-Report Cross-Reference

Per `conflict-report.md`: no blocking conflict with any of the six existing `S-WIN-*`
stories (all DONE/merged, file-disjoint) or any other in-progress `STORY-INDEX.md` entry.
No wave in this schedule needs to be reordered or gated on any existing story.

---

## 7a. Corrected Same-Wave File-Overlap Analysis (F3 re-review, 2026-09-04, Finding #1)

**§2 and §3's original "zero file overlap" claim was FALSE.** All four cycle-004 stories'
Task lists require a `CHANGELOG.md` entry under `[Unreleased]` (`S-cycle4-dpapi-storage-fix`
Task 20 → `Fixed`; `S-cycle4-cloud-id-correctness` Task 17 → `Fixed`;
`S-cycle4-honest-fail-message` Task 14 → `Fixed`; `S-cycle4-windows-docs` Task 7 →
`Changed`), but `CHANGELOG.md` appeared in the File Structure Requirements footprint of
ONLY `S-cycle4-windows-docs` at the time this schedule was first authored. `CHANGELOG.md`
is therefore concurrently edited by:

- **BOTH Wave 1 stories** (`S-cycle4-dpapi-storage-fix` + `S-cycle4-cloud-id-correctness`,
  running in parallel), AND
- **BOTH Wave 2 stories** (`S-cycle4-honest-fail-message` + `S-cycle4-windows-docs`,
  running in parallel).

This has been fixed at the source — `CHANGELOG.md` is now listed in the File Structure
Requirements table of all four story files (`S-cycle4-windows-docs` already had it; the
other three were added by this re-review pass), so the footprint tables and this schedule
are now internally consistent.

**Corrected overlap statement:** `CHANGELOG.md` is the ONLY shared file across ANY
same-wave pair in this cycle. `src/`/`tests/`/`Cargo.toml`/`deny.toml`/`README.md` remain
genuinely file-disjoint within each wave (§2/§3's original analysis stands for those
files) — the "zero file overlap" claim was accurate for CODE, just not for the
documentation-ledger file.

**Mitigation (why this is not a real conflict, and F4 should expect it, not be surprised by
it):** `CHANGELOG.md`'s `[Unreleased]` section is an append-only list of bullet lines under
category subheadings (`Fixed`/`Changed`/`Added`). Each of the four stories appends its OWN
distinct bullet line describing its own shipped behavior — no story edits or removes
another story's line, and no two stories' lines are textually identical. A git merge of two
branches that each append a new line to the same section produces, at worst, a trivial
line-ordering conflict resolved by keeping BOTH lines (a "both sides added a line" conflict,
not a "both sides changed the same line" conflict) — never a semantic conflict requiring a
judgment call about which change wins. F4 delivery (whichever implementer runs the second
of a same-wave pair to open its PR) should expect exactly this class of trivial merge
conflict on `CHANGELOG.md` and resolve it by keeping both entries, rather than treating it
as a sign that the wave schedule under-analyzed file overlap.

This correction also propagates to `conflict-report.md` §1 (footprint recap table) and §4
(Item 3, intra-cycle overlap) — see that file's own Finding #1 correction note.
