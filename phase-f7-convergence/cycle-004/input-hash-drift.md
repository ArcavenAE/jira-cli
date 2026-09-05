---
artifact: F7 Input-Hash Drift Check — cycle-004
cycle: cycle-004
phase: F7-DELTA-CONVERGENCE
date: 2026-09-05
status: complete
scan_scope: .factory/ (factory-wide, 215 tracked artifacts)
tool: compute-input-hash --scan .factory (+ --resolve)
verified_against: develop @ 024de4d8 (current checked-out branch, confirmed in sync with origin/develop)
---

# F7 Input-Hash Drift Check — cycle-004

Mandatory pre-human-gate scan, run ahead of the cycle-004 F7 5-dimensional
delta convergence check. Full factory-wide scan via `compute-input-hash
--scan .factory`, followed by `--resolve` to rule out inputs silently
dropping out of drift detection.

## Factory-wide totals

```
TOTAL=215 MATCH=20 STALE=176 UNCOMPUTED=0 NOINPUT=19 UPDATED=0 UPDATE_FAILED=0
--resolve: TOTAL=215 RESOLVABLE=211 UNRESOLVABLE=4
```

The 4 unresolvable entries (missing-input references — a GitHub issue URL,
a `../` path-traversal-rejected reference, a live-CI-run citation, and two
missing F1 sub-artifacts) are all in `code-delivery/issue-333/`,
`phase-f7-convergence/issue-577-*`, `stories/S-CIGATE-2-*`, and
`phase-f1-delta-analysis/issue-383/` — none are cycle-004 artifacts and none
changed this scan. Carried as pre-existing, out of scope for this gate.

## (A) cycle-004-relevant drift

11 cycle-004 artifacts under `.factory/cycles/cycle-004/` reported STALE.
They split into two distinct causes:

### A1 — Sentinel pattern, not real drift (2 artifacts)

| Artifact | inputs | input-hash |
|---|---|---|
| `cycles/cycle-004/burst-log.md` | `[STATE.md]` | `"[live-state]"` |
| `cycles/cycle-004/session-checkpoints.md` | `[STATE.md]` | `"[live-state]"` |

These use the factory-wide `"[live-state]"` sentinel convention (also present
identically in cycle-001/002/003's `burst-log.md`/`session-checkpoints.md`):
the tool's placeholder-detection only recognizes literal `"[md5]"`/`null`, so
a non-empty `inputs:` paired with the `"[live-state]"` string always computes
a real hash against current `STATE.md` and never matches — by design, since
these files intentionally track "current session state," not a frozen
snapshot. **Not gate-relevant drift** — same category as the standing pool's
own use of this convention.

### A2 — Real drift, single traceable root cause (9 artifacts)

| Artifact | Stored hash | Computed hash |
|---|---|---|
| `cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md` | `debb122` | `11806e1` |
| `cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md` | `8f572bf` | `9e27f28` |
| `cycles/cycle-004/phase-f3-stories/decomposition-manifest.md` | `02698fc` | `9b0aa5b` |
| `cycles/cycle-004/phase-f3-stories/S-cycle4-windows-docs.md` | `4dd740b` | `237717d` |
| `cycles/cycle-004/phase-f3-stories/conflict-report.md` | `6c8fb56` | `e8a8ed6` |
| `cycles/cycle-004/phase-f3-stories/dependency-graph-extended.md` | `56c22cf` | `4a8a495` |
| `cycles/cycle-004/phase-f3-stories/wave-schedule.md` | `ae9fd49` | `39d60d0` |
| `cycles/cycle-004/phase-f3-stories/wave-holdout-scenarios/wave-1-holdout-scenarios.md` | `0be69d9` | `31e3a8a` |
| `cycles/cycle-004/phase-f3-stories/wave-holdout-scenarios/wave-2-holdout-scenarios.md` | `fb4c7e5` | `989f90e` |

**Root cause (traced, not assumed):** `delta-analysis.md` (F1) and
`architecture-delta.md` (F2) are the only two artifacts in this cluster with
independent, non-cascading `inputs:` lists. Both declare `.factory/STATE.md`
and/or `src/api/auth.rs`, `src/api/client.rs`, `src/api/refresh_coordinator.rs`,
`src/cli/auth/{login,refresh,logout,remove,status}.rs`, `src/config.rs`,
`src/cache.rs`, `Cargo.toml`, `Cargo.lock`, `deny.toml`, `README.md`,
`CLAUDE.md` as inputs. `git log` confirms every one of those files (except
`refresh_coordinator.rs`, unchanged) received commits from the cycle-004 F4
implementation PRs (#768, #769, #771), the doc-consistency fix (#772), and
the F5/F6 fix rounds (#773, #774, #775) — all already merged to `develop`
per `STATE.md`'s own DEC-338/339/340/341 log. `.factory/STATE.md` itself is
also a declared input and has been rewritten every burst since (Bursts 1–19).

The remaining 7 artifacts (`decomposition-manifest.md` through both
`wave-*-holdout-scenarios.md`) do not reference `STATE.md` or `src/` directly
— they drift purely by **cascade**: each declares the previous file in the
F1→F2→F3 chain as one of its own `inputs:` (e.g.
`decomposition-manifest.md` → `delta-analysis.md` + `architecture-delta.md`;
`conflict-report.md`/`dependency-graph-extended.md` →
`decomposition-manifest.md`; `wave-schedule.md` → both of those; the two
`wave-*-holdout-scenarios.md` → `wave-schedule.md` + the per-story files).
One upstream hash change propagates through the whole chain.

**Interpretation:** this is the expected shape of a Feature Mode cycle that
has already passed F4/F5/F6 — the F1–F3 documents describe what to build
*before* the code existed in its current form; F4–F6 then built and hardened
it, mechanically changing the very source files F1 declared as inputs. This
is not evidence the specs are semantically wrong against what shipped (F4's
wave-gate reviews, F5's 3-pass adversarial convergence, and F6's hardening
all independently verified the delivered code against these same specs and
found no contradiction) — it is the tool correctly detecting that its
snapshot predates the implementation the snapshot specified.

**Not fixed here.** Per the state-manager's write scope, `delta-analysis.md`,
`architecture-delta.md`, `decomposition-manifest.md`, `conflict-report.md`,
`dependency-graph-extended.md`, `wave-schedule.md`, both
`wave-*-holdout-scenarios.md`, and the story file are owned by
business-analyst/architect/story-writer, not state-manager — no `input-hash`
field was touched. All 9 are **pure-recompute candidates** (content is not
semantically incorrect; the drift is a bookkeeping artifact of implementation
having proceeded as specified) — `compute-input-hash --update` on these 9
paths would resolve the drift without a content edit, but that call was left
for the orchestrator/producing agents to authorize and execute, per this
task's explicit "note it, don't do it" instruction.

**Gate impact:** None of the 9 represent semantic contradiction between spec
and shipped code — F4/F5/F6 already independently re-validated the delta.
Flagging this cluster for a hash-refresh pass (via the owning agents, or a
human-approved bulk `--update` scoped to exactly these 9 paths) **before**
the human F7 gate is recommended for bookkeeping hygiene, but it is **not a
blocking defect** and does not require re-opening F1/F2/F3 content review.

## (B) Standing historical pool

**165 STALE artifacts** outside `.factory/cycles/cycle-004/` (176 total STALE
− 11 cycle-004 = 165), consistent with the pre-existing, documented
`F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` standing debt item (last
recorded at ~142; the pool has grown by roughly the amount of ordinary burst
churn against `cycles/cycle-002/`, `cycles/cycle-003/`'s own `[live-state]`
`burst-log.md`/`session-checkpoints.md`/`lessons.md` files plus routine
STATE.md-referencing artifacts since that count was last taken). Distribution:
`cycles/cycle-001/` (adversarial-review passes, red-gate logs, decisions
archive — bulk of the count), `cycles/cycle-002/` and `cycles/cycle-003/`
(`burst-log.md`, `session-checkpoints.md`, `lessons.md` — same `[live-state]`
sentinel pattern as A1 above), `code-delivery/`, `phase-f1-delta-analysis/`,
`phase-f2-spec-evolution/` (issue-576/577 consistency-report rounds,
adversarial-spec-delta-review-components passes), `phase-f7-convergence/`
(issue-571 reports), `specs/domain-spec/bc-02-issue-read.md`, and a large
block of `.factory/stories/*.md` (pre-cycle-004 feature stories: S-576-*,
S-577-*, S-604-*, S-605-*, S-608-*, S-CIGATE-*, S-PG-*, etc.).

**Not investigated further, not modified** — this pool is factory-wide,
predates cycle-004, and is explicitly out of scope for this check per task
instructions.

## Verdict

- **(A) gate-blocking drift: NONE.** The 2 sentinel-pattern artifacts are
  by-design, non-blocking. The 9 real-hash artifacts form one traceable
  cascade rooted in expected F4–F6 implementation activity already
  independently re-validated by those phases; recommended for a
  hash-refresh (pure recompute, no content change) but not a gate blocker.
- **(B) standing pool: 165 artifacts**, unchanged in kind from the documented
  `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` debt item, not modified.
- Recommendation to the orchestrator: proceed to the 5-dimensional delta
  convergence check; optionally dispatch a housekeeping `--update` scoped to
  the 9 A2 paths (owning agents: business-analyst for
  `delta-analysis.md`/`decomposition-manifest.md`-family, architect for
  `architecture-delta.md`, story-writer for `S-cycle4-windows-docs.md` and
  the wave/dependency/conflict files) either before or after the human F7
  gate — it does not block it.
