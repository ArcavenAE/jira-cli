---
document_type: dependency-graph
phase: phase-f3-incremental-stories
cycle: cycle-014
feature: issue-triage-quickfixes
status: draft
producer: story-writer
created: 2026-09-26
inputs:
  - ".factory/cycles/cycle-014/phase-f3-stories/S-cycle14-user-list-project-resolution.md"
  - ".factory/cycles/cycle-014/phase-f3-stories/S-cycle14-api-query-param.md"
  - ".factory/cycles/cycle-014/phase-f3-stories/S-cycle14-field-options-name-label.md"
  - ".factory/stories/STORY-INDEX.md"
  - ".factory/cycles/cycle-014/cycle-manifest.md"
traces_to: ".factory/cycles/cycle-014/cycle-manifest.md, D-381"
input-hash: "5317e88"
---

# F3 Extended Dependency Graph -- `issue-triage-quickfixes` (cycle-014)

Computes the dependency graph over the 3 new cycle-014 stories, confirms it is acyclic (Kahn's
algorithm), and cross-links it against the existing `STORY-INDEX.md` graph (191 pre-cycle-014
stories per `STORY-INDEX.md` frontmatter `total_stories: 191` at analysis time -- this document
does not itself edit that file; a separate integrate sub-burst registers the new rows).

---

## 1. Node Inventory

**Convention note (mirrors cycle-007/008/012/013's dependency-graph-extended.md §1):**
`depends_on:` is the authoritative graph EDGE set; `blocks:` is informational/
inverse-consistency-checked only.

| ID | Story | Issue | `depends_on` (frontmatter, verified against story file) |
|----|-------|-------|-----------------------------------------------------------|
| A | `S-cycle14-user-list-project-resolution` | #862 | `[]` |
| C | `S-cycle14-api-query-param` | #583 | `["S-cycle14-user-list-project-resolution"]` |
| B | `S-cycle14-field-options-name-label` | #861 (read-side only) | `["S-cycle14-api-query-param"]` |

**`blocks:` inverse-consistency check:**

| Story | `blocks:` (frontmatter) | Inverse holds? |
|-------|---------------------------|-----------------|
| A (`user-list-project-resolution`) | `["S-cycle14-api-query-param"]` | consistent -- C names A in its own `depends_on:` |
| C (`api-query-param`) | `["S-cycle14-field-options-name-label"]` | consistent -- B names C in its own `depends_on:` |
| B (`field-options-name-label`) | `[]` | consistent -- nothing depends on B |

No inconsistency to flag. This is a single linear chain, A -> C -> B -- unlike cycle-008's
mostly-parallel shape, this reflects the human-decided SERIAL delivery order (D-381,
2026-09-25 F2 review, superseding the F1-gate's original parallel-wave-eligible framing).

---

## 2. Adjacency List

```
A (user-list-project-resolution) -> [C]                    depends_on: []       [root of the chain]
C (api-query-param)               -> [B]                    depends_on: [A]      [rebased on A]
B (field-options-name-label)      -> []                     depends_on: [C]      [rebased on C; terminal node]
```

**Cross-links to EXISTING stories:** none. Grep-verified against `STORY-INDEX.md`: no existing
story's `depends_on:`/`blocks:` frontmatter references any `S-cycle14-*` id (no such ids existed
before this burst), and none of the 3 new stories references an existing story ID as a hard
dependency. The cycle-014 subgraph is a **disjoint 3-node linear chain** relative to the existing
191-story graph.

---

## 3. Cycle Detection (Kahn's Algorithm)

```
Initial in-degree:  A=0, C=1, B=1

Round 1: indegree-0 set = {A}                  -> emit A
         remove A's outgoing edge (A -> C)
         after removal: C=0

Round 2: indegree-0 set = {C}                  -> emit C
         remove C's outgoing edge (C -> B)
         after removal: B=0

Round 3: indegree-0 set = {B}                  -> emit B

Round 4: indegree-0 set = {}                   -> queue empty, all 3 nodes emitted
```

**Topological order:** `A, C, B` (unique -- this is a linear chain, no alternative ordering
exists).

**Result: ACYCLIC.** All 3 nodes are emitted; no residual edges remain after the algorithm
terminates. No cycle exists in the extended graph (the new 3-node subgraph is disjoint from, and
does not interact with, the existing 191-story graph -- trivially acyclic in combination).

---

## 4. Rationale for the Serial (Not Parallel) Dependency Edges

Unlike cycle-008's dependency graph, which deliberately did NOT encode an editorial sequencing
recommendation as a `depends_on:` edge (see cycle-008's own §4, "S2 -> S4"), cycle-014's two edges
(`A -> C`, `C -> B`) ARE encoded as hard `depends_on:` edges, for a reason specific to this cycle:

- **This is a human decision, not a story-writer inference (D-381, 2026-09-25 F2 review).** The
  F1 human gate (2026-09-24) originally accepted "three parallel-wave-eligible S stories." The F2
  human review revisited this and REPLACED it with serial delivery A -> C -> B, because — per
  `cycle-manifest.md`'s dated amendment note — all three stories touch `src/cli/mod.rs` and
  `README.md`, and A and C additionally both touch `src/main.rs`, `.cargo/mutants.toml`, and
  `docs/specs/cargo-mutants-policy.md`. This is a file-overlap-driven human decision to keep
  merges linear, not a content-truth dependency of the `S1 -> S5` class from cycle-008 (where S5's
  own test assertion is false until S1's code exists).
- **The `.cargo/mutants.toml`/`docs/specs/cargo-mutants-policy.md` edits ARE a genuine sequential
  numeric dependency between A and C specifically:** per `verification-delta.md` §2's
  `examine_globs` table and D-382, A bumps the policy's "Current `examine_globs` count" line
  32 -> 33 and C bumps it 33 -> 34 -- C's edit textually depends on starting from A's
  already-landed 33. This is a real edge, not merely a recommendation.
- **The `C -> B` edge has no equivalent numeric dependency** (B adds no new `examine_globs` entry
  -- `src/cli/field.rs` is already in scope via FIX-F6-MUTANTS-SCOPE), but the human decision at
  D-381 fixed the whole chain to A -> C -> B as a single ordering, not just the A -> C pair, to
  avoid a 3-way merge reconciliation on `src/cli/mod.rs`/`README.md`. This story-writer pass
  therefore encodes `C -> B` as `depends_on:` too, honoring the human's explicit choice rather
  than second-guessing it with a weaker "recommended, not blocking" framing (contrast cycle-008's
  §4, where NO human decision fixed a serial order and the story-writer was free to classify S2->S4
  as editorial-only).

**Conclusion:** all three cycle-014 stories are correctly WAVE-SEPARATED (Wave 1: A; Wave 2: C;
Wave 3: B), one story per wave, per D-381. This is a deliberate divergence from cycle-008's
mostly-parallel Wave 1 shape and is not a story-writer error.

---

## 5. File-Overlap Check (informational -- see `wave-schedule.md` §2 for the full accounting)

| Story | Primary file(s) touched |
|-------|-----------------------------|
| A (`user-list-project-resolution`) | `src/cli/mod.rs` (`UserCommand::List.project`), `src/main.rs` (`Command::User` arm), `src/cli/user.rs`, `tests/user_commands.rs` (modify), `tests/user_list_project_resolution.rs` (new), `tests/user_pagination.rs` (modify), `tests/all_flag_behavior.rs` (modify, conditional -- only if Task 2's grep finds a stale assertion), `README.md` (~L335), `.cargo/mutants.toml`, `docs/specs/cargo-mutants-policy.md`, `CHANGELOG.md` |
| C (`api-query-param`) | `src/cli/mod.rs` (`Command::Api`), `src/main.rs` (`Command::Api` arm), `src/cli/api.rs`, `tests/api_query_param.rs` (new), `README.md` (~L332), `.cargo/mutants.toml`, `docs/specs/cargo-mutants-policy.md`, `CHANGELOG.md` |
| B (`field-options-name-label`) | `src/cli/field.rs`, `src/cli/mod.rs` (`Command::Field`/`FieldCommand::Options`), `src/types/jira/editmeta.rs`, `src/api/jira/issues.rs`, `tests/field_options.rs` (modify -- rename (AC-007) + comment corrections (AC-006) only; no new test file), `README.md` (~L346), `CLAUDE.md` (~L61), `CHANGELOG.md` |

**Overlap summary:** `src/cli/mod.rs`, `README.md`, and `CHANGELOG.md` are touched by all three
stories, but each touches a DIFFERENT clap subcommand/enum variant (`UserCommand::List` /
`Command::Api` / `FieldCommand::Options`) and a DIFFERENT README row (~L335 / ~L332 / ~L346) --
disjoint line ranges within shared files. `.cargo/mutants.toml` and
`docs/specs/cargo-mutants-policy.md` are shared by A and C only, with the genuine sequential
numeric dependency described in §4. `src/main.rs` is shared by A and C only: both touch different
arms of the same `match` statement (`run` at ~L212, dispatch match ~L233 -- `Command::User`
at ~L434-439 for A, `Command::Api` at ~L493-503 for C), not the same match arm or helper function --
a same-file, different-arm overlap, which the serial delivery order (§4, D-381) resolves the same
way it resolves the `src/cli/mod.rs`/`README.md` overlap. No two stories touch the same match arm
or the same helper function. The serial delivery order (§4) exists specifically to avoid requiring
three-way conflict resolution on the shared files, even though the touched regions are disjoint.

---

## 6. Conflict Check Against In-Progress Work

Checked per the orchestrator's instruction: `.worktrees/` and `sprint-state.yaml`.

- **`.worktrees/` does not exist** in this repository (`ls .worktrees/` returns nothing) -- no
  story worktree is currently checked out.
- **`.factory/sprint-state.yaml`** tracks the original Phase-3 greenfield wave delivery (Wave 0
  through Wave 3, all historical/completed) -- no live cycle-014-relevant entries.
- **`.factory/stories/sprint-state.yaml`** tracks cycle-008 (`oauth-surface-correctness`) only; all
  6 of its rows are `merged` except `S-cycle8-teams-graphql-oauth-replatform-spike`, which is a
  non-gating, no-code-delivery SPIKE with zero file touches. No overlap with any cycle-014 file.

Grep of `STORY-INDEX.md`'s Story Manifest table for the file paths this cycle's stories touch
(`src/cli/mod.rs`, `src/main.rs`, `src/cli/user.rs`, `src/cli/api.rs`, `src/cli/field.rs`,
`src/types/jira/editmeta.rs`, `src/api/jira/issues.rs`, `tests/user_commands.rs`,
`tests/user_list_project_resolution.rs`, `tests/user_pagination.rs`, `tests/all_flag_behavior.rs`,
`tests/api_query_param.rs`, `tests/field_options.rs`, `README.md`, `CLAUDE.md`,
`.cargo/mutants.toml`, `docs/specs/cargo-mutants-policy.md`), cross-referenced against every
`**draft**`/`**in-progress**`/`**ready**` (undelivered) row:

- **No existing undelivered story touches** `src/cli/user.rs`, `src/cli/api.rs`,
  `src/cli/field.rs`, `src/types/jira/editmeta.rs`, `src/api/jira/issues.rs`,
  `tests/user_commands.rs`, `tests/user_list_project_resolution.rs`, `tests/user_pagination.rs`,
  `tests/all_flag_behavior.rs`, `tests/api_query_param.rs`, `tests/field_options.rs`,
  `.cargo/mutants.toml`, or `docs/specs/cargo-mutants-policy.md`.
- **`src/cli/mod.rs` and `README.md` ARE touched by one existing `**draft**` story**,
  `S-cycle7-oauth-help-text-fix` (cycle-007 `auth-correctness-dx` bundle, F3-registered
  2026-09-10, still awaiting F4 dispatch): it corrects `AuthCommand::Login`'s `--oauth` doc
  comment in `src/cli/mod.rs` -- a wholly different subcommand (`auth login`) and enum
  (`AuthCommand`, not `UserCommand`/`Command::Api`/`FieldCommand`) from any cycle-014 story's own
  `src/cli/mod.rs` edit. `S-cycle7-readme-migration-note` (same bundle, same status) touches
  `README.md`'s migration-section bullet about per-profile credentials -- a different section from
  any of this cycle's three README rows (~L332/~L335/~L346).
- **No other in-progress/draft story** references any `src/cli/mod.rs`/`README.md` region this
  cycle's stories touch.

**Resolution: NOT encoded as a `depends_on:` edge** against either cycle-007 story -- the touched
regions are disjoint (different clap subcommand families, different README sections), following
the same file-overlap-without-content-dependency precedent cycle-008's own §6 established for
`S-cycle7-credential-absence-fix`/`S-cycle7-auth-state-derivation`'s shared `src/api/auth.rs`
touch. A file-overlap note only, carried here and in `wave-schedule.md` §2, recommending
merge-order awareness (rebase, not blocking) if either cycle-007 story lands during cycle-014's
delivery window.

**Conflict report result: NO CONFLICTS FOUND.** No in-progress work blocks or is blocked by any
of the three new cycle-014 stories.

---

## 7. BC / VP Traceability Summary

| BC | Story | VP |
|----|-------|----|
| BC-X.7.002 | A (`user-list-project-resolution`) | VP-USER-LIST-PROJECT-001 |
| BC-X.16.001, BC-X.16.002 | C (`api-query-param`) | VP-API-QP-001..006 |
| BC-X.14.001, BC-X.14.003, BC-X.14.004 (cross-ref) | B (`field-options-name-label`) | VP-580-013 |

All 8 new VPs minted at cycle-014 F2 (`verification-delta.md`, 89 -> 97) are anchored to exactly
one of the three new stories, per `verification-delta.md` §5's own hand-off: "F3 anchors STORY-A
(#862) -> VP-USER-LIST-PROJECT-001, STORY-B (#861) -> VP-580-013, STORY-C (#583) ->
VP-API-QP-001..006." No VP is left unanchored; no story lacks a VP.
