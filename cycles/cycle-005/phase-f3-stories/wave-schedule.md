---
document_type: wave-schedule
level: ops
version: "1.0"
phase: phase-f3-incremental-stories
cycle: cycle-005
feature: adf-mentions
status: draft
producer: story-writer
created: 2026-09-06
timestamp: "2026-09-06T00:00:00"
inputs:
  - ".factory/cycles/cycle-005/phase-f3-stories/dependency-graph-extended.md"
traces_to: "dependency-graph-extended.md §4a"
input-hash: "b59b05c"
---

# F3 Wave Schedule — `adf-mentions` (cycle-005, GitHub #674)

Wave grouping by Kahn-layering (BFS levels over the acyclic graph proven in
`dependency-graph-extended.md` §4a).

## Summary

| Metric | Value |
|--------|-------|
| Total stories (this cycle) | 2 |
| Total waves | 2 |
| Max parallelism (stories in one wave) | 1 (no intra-wave parallelism this cycle) |
| Estimated agent spawns | 2 (one implementer dispatch per story) |

---

## 1. Layering Derivation

| Round | Indegree-0 set at this round | Wave |
|---|---|---|
| 1 | {A (`mention-pure-conversion`)} | **Wave 1** |
| 2 (after removing A) | {B (`mention-resolution-wiring`)} | **Wave 2** |

**Computed layering — 2 waves, strictly sequential:**

| Wave | Stories | Parallelism |
|---|---|---|
| 1 | `S-cycle5-mention-pure-conversion` | solo |
| 2 | `S-cycle5-mention-resolution-wiring` | solo |

Unlike cycle-004's two independent 2-node chains (which yielded 2-way
parallelism in each wave), this cycle's 2 stories form a single linear chain —
Story B cannot even COMPILE until Story A's public `adf.rs` API
(`find_mention_candidates`, `markdown_to_adf_with_mentions`,
`markdown_to_adf_no_mentions`, `MentionResolutions`) exists. A single-wave
schedule (merging both stories into one wave) was considered and rejected: the
compile-time dependency is real, not merely a suggested delivery order, so
Wave 1 must fully land (merge to `develop`) before Wave 2's implementer can
begin meaningful TDD work against the real functions rather than stubs.

---

## 2. File-Overlap Check

`S-cycle5-mention-pure-conversion` touches: `src/adf.rs`, `CHANGELOG.md`.

`S-cycle5-mention-resolution-wiring` touches: `src/cli/issue/mentions.rs` (new),
`src/cli/issue/mod.rs`, `src/cli/issue/helpers.rs`, `src/cli/issue/create.rs`,
`src/cli/issue/edit.rs`, `src/cli/issue/interactions.rs`,
`src/cli/issue/jsm_create.rs`, `src/api/jsm/requests.rs`, `src/cli/mod.rs`,
`.cargo/mutants.toml`, `tests/mention_resolution.rs` (new), `tests/e2e_live.rs`,
`tests/e2e_cli_surface_guard.rs`, `CHANGELOG.md`.

**Zero SOURCE-file overlap on `src/adf.rs`** — Story B never touches `adf.rs`
itself, only calls its public API. Since these two stories run in DIFFERENT
waves (not in parallel), file-overlap analysis is moot for scheduling purposes
(no rebase-churn risk exists between stories that never run concurrently), but
is recorded here for completeness and to confirm Story B's implementer will
not need to touch `adf.rs` at all.

**`CHANGELOG.md` is the one shared file across the two waves** — both stories'
Task lists require a `[Unreleased]` entry (Story A under `> Added`, describing
the pure conversion; Story B under `> Added`, describing the resolver + wiring,
closing #674). Because the waves are sequential, not parallel, this is a
trivial two-commit append, not a same-wave merge-conflict risk — Story B's
implementer appends its own line after Story A's has already merged.

---

## Wave Plan

### Wave 1 — `S-cycle5-mention-pure-conversion`

- **Stories:** 1, solo.
- **Points:** 13.
- **File footprint:** `src/adf.rs`, `CHANGELOG.md`.
- **Gate:** standard wave-gate (full regression on `develop`, adversarial
  review of the wave diff, holdout evaluation against H-NEW-MENTION-007 (a
  COMPLETE `jr issue view` wiremock scenario — corrected, F3 adversarial
  pass-2 observation: this is not a pure-side fragment like 005/006, it is
  fully satisfiable at Wave 1 because the render arm this scenario exercises
  lands entirely in `adf.rs` and the existing `jr issue view` command already
  picks it up with no CLI change required), plus Story A's own pure-unit VPs
  standing in for H-NEW-MENTION-005/006's pure-side behavior at this gate —
  VP-674-012 (the pure `\@`-escape observable, AC-007) and VP-674-019 part-a
  (the pure `--no-mentions`/no-op-on-bracket observable, AC-004) — **corrected,
  F3 adversarial pass-5, LOW-2:** H-NEW-MENTION-005 and -006 are themselves
  monolithic EFFECTFUL CLI holdout scenarios with no separately-labeled
  pure-side subset of their own (006 even exercises `--no-mentions`, a CLI
  flag that does not exist until Story B), so neither is itself evaluated,
  even partially, at this Wave 1 gate; the full H-NEW-MENTION-005/006 CLI
  scenarios are dual-anchored and evaluated in full only at the Wave 2 gate
  below, once Story B's resolver and `--no-mentions` flag exist. Also part of
  this gate: demo evidence — a `cargo test` transcript showing the new
  proptest/example suites passing, since this is a backend/library-internals
  story with no CLI-surface demo of its own) before Wave 2 opens.
  **Correction (F-H-01):** H-NEW-MENTION-001 is NOT evaluated at
  this gate — it is an EFFECTFUL MUST-PASS scenario (requires the
  `GET /user?accountId` preflight, the `POST` comment, GET-before-POST
  ordering, and `attrs.text` population) with no pure-side-only assertion
  Story A can satisfy on its own. It is anchored to, and evaluated at, the
  Wave 2 gate below. Also see the "Interim Shippability Note" in
  `S-cycle5-mention-pure-conversion.md` — this wave's merge opens an accepted,
  time-boxed window in which bracket-form mentions convert unconditionally and
  UNVALIDATED at every existing `adf.rs` call site, closed only by Wave 2's
  BC-X.7.010 preflight.
- **F4 spike risk note:** the `\@`-escape mechanism (AC-007) is this wave's
  dominant schedule risk — see the story's own F4-contingency note. If the
  spike concludes mid-wave that the escape needs a scope-cut, that decision
  must resolve BEFORE this wave's gate closes, since Story B's
  `H-NEW-MENTION-005`-adjacent wiring assumptions (the escape working) would
  otherwise need to be revisited in Wave 2 planning.

### Wave 2 — `S-cycle5-mention-resolution-wiring`

- **Stories:** 1, solo.
- **Points:** 13.
- **File footprint:** new `src/cli/issue/mentions.rs` + 7 modified `src/`
  files + `.cargo/mutants.toml` + 3 `tests/` files + `CHANGELOG.md`.
- **Depends on:** Wave 1's `S-cycle5-mention-pure-conversion` (compile-time
  dependency — Story B's resolver and every one of its four wiring call sites
  call Story A's public `adf.rs` functions and cannot be implemented, let
  alone tested, against stubs).
- **Gate:** standard wave-gate; this is the cycle's FINAL wave — its gate
  closing is a precondition for cycle-005's F7 delta-convergence gate.
  Holdout evaluation at THIS gate includes H-NEW-MENTION-001 (moved here from
  the Wave 1 gate per F-H-01 — it is an effectful MUST-PASS scenario requiring
  the `GET /user?accountId` preflight, the `POST` comment, GET-before-POST
  ordering, and `attrs.text` population, none of which Wave 1 alone can
  exercise) and H-NEW-MENTION-005 (also anchored here per F-M-03, alongside
  Story A, because the escape's discriminating value — "the `\@` escape wins
  even when `@jsmith` WOULD otherwise resolve" — is only observable once a
  real resolver exists; against Story A alone, `.expect(0)` on
  `GET /user/search` passes trivially with no resolver in the picture). The
  live-Jira E2E acceptance (H-NEW-MENTION-009, VP-674-014..017) is a HUMAN
  REQUIRED gate item per DEC-344 — it must run (via `.github/workflows/e2e.yml`
  or a manual `JR_RUN_E2E=1` invocation) and pass before this cycle's feature
  is considered live-Jira-acceptance-complete, though it is NOT a blocker for
  the standard automated wave-gate (which the wiremock-based ACs already
  satisfy). This gate is also where the Wave 1 "Interim Shippability Note"
  window formally closes: Wave 2's BC-X.7.010 mandatory preflight validation
  must be observed passing before bracket-form mentions are considered
  acceptance-complete for the feature.

---

## 3. Pipeline Overlap Plan

Because this cycle has no intra-wave parallelism, there is limited staggering
opportunity compared to cycle-004's two-chain schedule. The one legitimate
overlap:

| Parallel Activity | When |
|---|---|
| Story B's test-writer authors WIREMOCK FIXTURE SHAPES (request/response JSON bodies for `GET /user/search`, `GET /user?accountId=`) from the BC bodies and holdout scenarios | Can start during Wave 1, in parallel with Story A's implementation — fixture authorship needs only the BC/holdout spec text, not Story A's actual code |
| Story B's stub-architect pass (compilable `todo!()` skeletons for `mentions.rs` and the four call-site diffs) | MUST wait for Wave 1 to merge — the skeletons need Story A's real function signatures to compile against, not guessed ones |

This overlap plan is intentionally narrow — the two stories' actual
implementation work is genuinely sequential, unlike cycle-004's two
file-disjoint chains.

---

## 4. Critical Path

A single chain, no alternative path exists:

```
S-cycle5-mention-pure-conversion (Wave 1, 13 pts)
  -> S-cycle5-mention-resolution-wiring (Wave 2, 13 pts)
```

**Critical path length: 2 stories / 2 waves, 26 points.** This IS the cycle's
total point count — every point in this cycle lies on the critical path, since
there is no parallel branch to absorb slack.

---

## 5. Total Feature Points

| Story | Wave | Points |
|---|---|---|
| `S-cycle5-mention-pure-conversion` | 1 | 13 |
| `S-cycle5-mention-resolution-wiring` | 2 | 13 |
| **Total** | — | **26** |

---

## 6. Conflict-Report Summary

No existing `STORY-INDEX.md` story shares a `depends_on:`/`blocks:` edge with
either new story (per `dependency-graph-extended.md` §2), and no in-progress
story (checked against `STORY-INDEX.md`'s status column at authoring time)
touches `src/adf.rs`, `src/cli/issue/mentions.rs` (new), or any of Story B's
four wiring files. No cycle-005 stories were previously registered in
`STORY-INDEX.md` before this F3 pass — no reconciliation with an
earlier-drafted cycle-005 story set is needed. No blocking conflict identified.
