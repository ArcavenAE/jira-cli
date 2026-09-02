---
document_type: wave-schedule
level: ops
version: "1.0"
phase: phase-f3-incremental-stories
cycle: cycle-003
feature: auth-profile-dx
status: draft
producer: story-writer
created: 2026-09-01
timestamp: "2026-09-01T00:00:00"
inputs:
  - ".factory/cycles/cycle-003/phase-f3-stories/dependency-graph-extended.md"
  - ".factory/cycles/cycle-003/phase-f3-stories/conflict-report.md"
  - ".factory/cycles/cycle-003/phase-f3-stories/decomposition-manifest.md"
traces_to: "dependency-graph-extended.md §4a; ADR-0020 § Sequencing"
input-hash: "84de0b9"
---

# F3 Wave Schedule — `auth-profile-dx` (cycle-003)

Wave grouping by Kahn-layering (BFS levels over the acyclic graph proven in
`dependency-graph-extended.md` §4a) — parallelizable stories that share the same
dependency-satisfaction point are grouped into one wave, rather than serialized purely
because one recommendation-only note suggested an order.

## Summary

| Metric | Value |
|--------|-------|
| Total stories (this cycle) | 7 |
| Total waves | 5 |
| Max parallelism (stories in one wave) | 2 (Wave 1, Wave 4) |
| Estimated agent spawns | 7 (one implementer dispatch per story; Wave 4's two stories run sequentially within the wave per §3, not concurrently, despite sharing a wave boundary) |

---

## 1. Layering Derivation

A node enters wave *N* the first round all of its `depends_on:` entries have already
been placed in a wave < *N* (standard Kahn BFS-layer construction — take all
currently-indegree-0 nodes as one layer, remove them, repeat).

| Round | Indegree-0 set at this round | Wave |
|---|---|---|
| 1 | {A (env-tag), B (percred-storage)} | **Wave 1** |
| 2 (after removing A, B) | {C (credential-absence-guard)} | **Wave 2** |
| 3 (after removing C) | {D (remove-logout-semantics)} | **Wave 3** |
| 4 (after removing D) | {E (adr0011-newtype), F (oauth-default-creation)} | **Wave 4** |
| 5 (after removing E, F) | {G (chosen-flow-reconcile)} | **Wave 5** |

**Computed layering — 5 waves:**

| Wave | Stories | Parallelism |
|---|---|---|
| 1 | `S-cycle3-env-tag`, `S-cycle3-percred-storage` | 2-way parallel |
| 2 | `S-cycle3-credential-absence-guard` | serial (1 story) |
| 3 | `S-cycle3-remove-logout-semantics` | serial (1 story) |
| 4 | `S-cycle3-adr0011-newtype`, `S-cycle3-oauth-default-creation` | 2-way parallel |
| 5 | `S-cycle3-chosen-flow-reconcile` | serial (1 story) |

## 2. Comparison Against the Dispatch's Expected Layering

**This matches the expected layering given in the F3 INTEGRATE dispatch exactly** —
Wave 1 {env-tag, percred-storage}, Wave 2 {credential-absence-guard}, Wave 3
{remove-logout-semantics}, Wave 4 {adr0011-newtype, oauth-default-creation} (both share
identical `depends_on: [percred-storage, credential-absence-guard,
remove-logout-semantics]` and neither names the other as a dependency, so per the
Kahn-layer rule they belong in the same wave, not serialized), Wave 5
{chosen-flow-reconcile}. **No divergence to flag.**

**Deliberately NOT adopted:** `decomposition-manifest.md`'s own §6 "Preliminary Wave
Grouping" proposed a 6-wave, fully-serial-after-Wave-1 schedule that placed
`adr0011-newtype` alone in its own wave (its old Wave 4) strictly before
`oauth-default-creation` (its old Wave 5). That ordering was explicitly labeled
"recommended, not required" in the manifest itself (§2 Story 5 Notes: "this ordering is
not strictly required for correctness... Recommend the wave scheduler honor ADR-0020's
literal order here even though the dependency graph alone would technically allow story
5 and story 6 to run in parallel"; §6: "recommend landing alone... to avoid
merge-conflict churn"). This wave-scheduling pass evaluated that recommendation and
**does not adopt it as a hard wave boundary** — see §3 below for why, and what mitigates
the file-collision concern that motivated it.

---

## 3. Why `adr0011-newtype` and `oauth-default-creation` Are Merged Into One Wave

The manifest's serialization recommendation was motivated by **avoiding rebase churn**
on `src/api/auth.rs` and `src/cli/auth/login.rs`, which both stories touch — not by a
correctness/dependency requirement (the manifest says this explicitly, twice). Evaluating
that concern directly:

- **`adr0011-newtype`'s touch to `src/api/auth.rs`/`src/cli/auth/login.rs` is a pure
  signature change** (`profile: &str` → `profile: &Profile`) applied uniformly across
  every function in those files — a mechanical, whole-file sweep with no logic change.
- **`oauth-default-creation`'s touch to the same two files is a logic change** (new
  picker, new precondition guard, new flags) that does not touch function signatures for
  the profile-typing axis.
- These are edits to **different axes of the same lines** (signature vs. body) — exactly
  the shape of change where a real merge conflict is likely if run as literal concurrent
  branches, but where sequencing WITHIN the wave (not a separate wave) resolves it cheaper:
  **run `adr0011-newtype` to completion and merge FIRST within Wave 4, then rebase
  `oauth-default-creation` onto the merged result before finishing that story's work.**
  This gets the manifest's stated goal (the newtype sweep sees the "enlarged,
  post-restructuring surface exactly once," and `oauth-default-creation`'s new code is
  written directly against `&Profile` signatures rather than needing a follow-up rename)
  without forcing an entire extra wave boundary (with its own wave-gate: full regression
  run, adversarial review, holdout eval) between two stories that have no actual
  *dependency* relationship.
- This is standard "same wave, ordered delivery" practice already used elsewhere in this
  repo's `STORY-INDEX.md` (e.g. the `list-read-ergonomics` bundle: "Wave 1 position 1 of
  3 (sequential delivery, same `list.rs`/`cli/mod.rs` hot region as S-579-1/S-588-1)" —
  three stories share one wave with an explicit intra-wave delivery order specifically
  because of file overlap, not dependency).

**Recommended intra-wave delivery order for Wave 4:** `S-cycle3-adr0011-newtype` first,
`S-cycle3-oauth-default-creation` second (same rationale the manifest gave, applied as
delivery-order guidance rather than a wave-boundary requirement). This is advisory for
the F4 dispatcher, not a graph edge — the dependency graph in
`dependency-graph-extended.md` correctly shows no edge between E and F.

---

## Wave Plan

The per-wave detail below is this cycle's Wave Plan (7 stories, 5 waves — see §1 for the
Kahn-layering derivation and §6 for the points table).

## 4. Per-Wave Detail

### Wave 1 — `S-cycle3-env-tag` + `S-cycle3-percred-storage`

- **Stories:** 2, run in parallel.
- **Points:** 5 + 8 = 13.
- **File overlap:** none (`config.rs`/`cli/auth/{list,status}.rs`/`output.rs` vs.
  `api/auth.rs`/`cli/auth/login.rs`/`api/client.rs`) — genuinely independent worktrees.
- **Gate:** standard wave-gate (full regression on `develop`, adversarial review of the
  wave diff, holdout eval, demo evidence) before Wave 2 opens.

### Wave 2 — `S-cycle3-credential-absence-guard`

- **Stories:** 1 (serial — sole indegree-0 node this round).
- **Points:** 8.
- **Flagged HIGH-RISK** by the manifest (§2 Story 3): the cycle's only MANDATORY
  keyring-gated end-to-end VP (VP-AUTHDX-007), the one-time breaking-change contract
  (BC-1.4.034), and a MUST-NOT-TOUCH regression discipline against `load_oauth_tokens`'s
  existing test suite. Recommend, per the manifest, that this wave get undivided review
  attention — confirmed here by NOT adding a second story to this wave even though no
  other story is graph-eligible for Wave 2 anyway.

### Wave 3 — `S-cycle3-remove-logout-semantics`

- **Stories:** 1 (serial).
- **Points:** 5.
- Depends on Waves 1-2's `percred-storage` + `credential-absence-guard`.

### Wave 4 — `S-cycle3-adr0011-newtype` + `S-cycle3-oauth-default-creation`

- **Stories:** 2, share a wave (see §3 for the file-overlap mitigation via intra-wave
  delivery order, not wave separation).
- **Points:** 13 + 13 = 26 — the single heaviest wave in the cycle.
- **Both are flagged as 13-point-ceiling / split-candidate stories** by the manifest — if
  either proves materially larger once story-writer's own file lists are finalized (they
  already are, per the story files read for this burst), F4 dispatch should re-assess
  splitting before starting implementation, per each story's own Notes section.
- **Recommended intra-wave order:** `adr0011-newtype` → `oauth-default-creation` (§3).

### Wave 5 — `S-cycle3-chosen-flow-reconcile`

- **Stories:** 1 (serial, terminal).
- **Points:** 5.
- Depends on Wave 4's `oauth-default-creation`.

---

## Pipeline Overlap Plan

| Parallel Activity | When |
|---|---|
| Wave 2 stub scaffolding (`S-cycle3-credential-absence-guard`) | Can start once Wave 1's `S-cycle3-percred-storage` `store_api_token`/`load_api_token` signatures are merged (its dependency is on the function signatures existing, not on Wave 1's full wave-gate closing) |
| Wave 3 test authorship (`S-cycle3-remove-logout-semantics`) | Can start once Wave 2's `credential-absence-guard` error-taxonomy text (BC-1.4.032/033 postcondition wording) is settled, ahead of Wave 2's full wave-gate closing — `remove-logout-semantics`' BC-1.2.013 Trace cross-references that error text |
| Wave 4 stub scaffolding for `S-cycle3-oauth-default-creation` | Can start once Wave 3 merges, in parallel with `S-cycle3-adr0011-newtype`'s implementation, PROVIDED the intra-wave delivery order in §3 is honored for the actual `&Profile`-signature rebase (stubs/tests can be drafted early; the final rebase onto `adr0011-newtype`'s merged signatures happens last) |
| Wave 5 test authorship (`S-cycle3-chosen-flow-reconcile`) | Can start once Wave 4's `oauth-default-creation` BC-1.2.048 invariant text is settled, ahead of Wave 4's full wave-gate closing |

This overlap plan is standard TDD-pipeline staggering (stub/test authorship for wave
*N+1* starting once wave *N*'s CONTRACTS are settled, not waiting for wave *N*'s full
wave-gate — full regression + adversarial review + holdout eval — to close) and does not
change the wave boundaries or gate requirements in §4; it only identifies where non-gated
prep work can begin early.

## 5. Critical Path

The critical path is the longest dependency chain by story count (and, secondarily, by
points) from a wave-1 entry to the terminal node:

```
S-cycle3-percred-storage (Wave 1, 8 pts)
  -> S-cycle3-credential-absence-guard (Wave 2, 8 pts)
  -> S-cycle3-remove-logout-semantics (Wave 3, 5 pts)
  -> S-cycle3-oauth-default-creation (Wave 4, 13 pts)
  -> S-cycle3-chosen-flow-reconcile (Wave 5, 5 pts)
```

**Critical path length: 5 stories / 5 waves, 39 points** (8+8+5+13+5).

`S-cycle3-env-tag` (Wave 1) and `S-cycle3-adr0011-newtype` (Wave 4) are NOT on the
critical path — `env-tag` has no downstream dependents at all within cycle-003, and
`adr0011-newtype` is a terminal node (nothing in cycle-003 depends on it) that merely
shares Wave 4 with a critical-path story. Both can, in principle, slip a wave without
delaying the cycle's overall completion — though `adr0011-newtype`'s own manifest Notes
recommend against letting it slip past Wave 4 (file-collision-avoidance with
`oauth-default-creation`, §3).

---

## 6. Total Feature Points

| Story | Wave | Points |
|---|---|---|
| `S-cycle3-env-tag` | 1 | 5 |
| `S-cycle3-percred-storage` | 1 | 8 |
| `S-cycle3-credential-absence-guard` | 2 | 8 |
| `S-cycle3-remove-logout-semantics` | 3 | 5 |
| `S-cycle3-adr0011-newtype` | 4 | 13 |
| `S-cycle3-oauth-default-creation` | 4 | 13 |
| `S-cycle3-chosen-flow-reconcile` | 5 | 5 |
| **Total** | — | **57** |

Matches the manifest's own §7 Summary total ("~57" = 5+8+8+5+13+13+5) exactly — no
drift between the manifest's rough estimate and each story file's actual `points:`
frontmatter value.

---

## 7. Conflict-Report Cross-Reference

Per `conflict-report.md`: no blocking conflict with `S-663-1` (done, disjoint), `S-384`
(de facto already merged), or `S-MAINT-532` (draft, deliberately deferred, test-only
footprint). No wave in this schedule needs to be reordered or gated on any of the three.
