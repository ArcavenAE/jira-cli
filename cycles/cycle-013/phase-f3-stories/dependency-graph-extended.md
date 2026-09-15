---
document_type: dependency-graph
phase: phase-f3-incremental-stories
cycle: cycle-013
feature: msrv-1.88-bump
status: draft
producer: story-writer
created: 2026-09-15
inputs:
  - ".factory/cycles/cycle-013/phase-f3-stories/S-cycle13-msrv-cargo-ci-atomic-bump.md"
  - ".factory/cycles/cycle-013/phase-f3-stories/S-cycle13-letchain-retrofit-convention-cleanup.md"
  - ".factory/cycles/cycle-013/phase-f3-stories/S-cycle13-doc-policy-reconciliation.md"
  - ".factory/stories/STORY-INDEX.md"
traces_to: ".factory/cycles/cycle-013/phase-f1-delta-analysis/delta-analysis.md §5"
input-hash: "af39ee9"
---

# F3 Extended Dependency Graph — `msrv-1.88-bump` (cycle-013)

Computes the dependency graph over the 3 new cycle-013 stories, confirms it is acyclic (Kahn's
algorithm), and cross-links it against the existing `STORY-INDEX.md` graph (182 pre-cycle-013
stories per `STORY-INDEX.md` frontmatter `total_stories: 182` at analysis time — this document
does not itself edit that file; state-manager registers the new rows).

---

## 1. Node Inventory

**Convention note (mirrors cycle-005/006/007/012's dependency-graph-extended.md §1):**
`depends_on:` is the authoritative graph EDGE set; `blocks:` is informational/
inverse-consistency-checked only.

| ID | Story | `depends_on` (frontmatter, verified against story file) |
|----|-------|-----------------------------------------------------------|
| S1 | `S-cycle13-msrv-cargo-ci-atomic-bump` | `[]` |
| S2 | `S-cycle13-letchain-retrofit-convention-cleanup` | `["S-cycle13-msrv-cargo-ci-atomic-bump"]` |
| S3 | `S-cycle13-doc-policy-reconciliation` | `["S-cycle13-msrv-cargo-ci-atomic-bump"]` |

**`blocks:` inverse-consistency check:**

| Story | `blocks:` (frontmatter) | Inverse holds? |
|-------|---------------------------|-----------------|
| S1 (`msrv-cargo-ci-atomic-bump`) | `["S-cycle13-letchain-retrofit-convention-cleanup", "S-cycle13-doc-policy-reconciliation"]` | consistent — both S2 and S3 name S1 in their own `depends_on:` |
| S2 (`letchain-retrofit-convention-cleanup`) | `[]` | consistent — nothing depends on S2 |
| S3 (`doc-policy-reconciliation`) | `[]` | consistent — nothing depends on S3 |

No inconsistency to flag.

---

## 2. Adjacency List

```
S1 (msrv-cargo-ci-atomic-bump)          -> [S2, S3]                 [no deps; blocks both S2 and S3]
S2 (letchain-retrofit-convention-cleanup) -> []   depends_on: [S1]  [1 dep; no dependents within this cycle]
S3 (doc-policy-reconciliation)          -> []   depends_on: [S1]    [1 dep; no dependents within this cycle]
```

**Cross-links to EXISTING stories:** none. All 3 new stories' `depends_on:`/`blocks:` arrays
reference only each other or are empty. Grep-verified: no existing `STORY-INDEX.md` story
references any `S-cycle13-*` id in its own `depends_on:`/`blocks:` frontmatter (no such ids
existed before this burst), and none of the 3 new stories references an existing story ID as a
hard dependency. The cycle-013 subgraph is a **disjoint 3-node component** (one fan-out pair:
`S1 -> {S2, S3}`) relative to the existing 182-story graph.

---

## 3. Cycle Detection (Kahn's Algorithm)

```
Initial in-degree:  S1=0, S2=1, S3=1
Round 1: indegree-0 set = {S1}          -> emit S1, remove its outgoing edges
         after removal: S2=0, S3=0
Round 2: indegree-0 set = {S2, S3}      -> emit S2, S3 (parallel — no edge between them)
Round 3: indegree-0 set = {}            -> queue empty, all 3 nodes emitted

Topological order: S1, {S2, S3} (order within round 2 is arbitrary — no edge S2<->S3)
```

**Result: ACYCLIC.** All 3 nodes are emitted; no residual edges remain after the algorithm
terminates. No cycle exists in the extended graph (new-3-node subgraph is disjoint from, and
does not interact with, the existing 182-story graph — trivially acyclic in combination).

---

## 4. Rationale for the S1→S3 Edge (not left independent)

The task framing for this F3 pass explicitly asked the story-writer to decide and justify
whether `S3` should be `S1`-dependent or fully independent (F1 §5 itself only speculates "could
even land before A/B"). This pass chooses **`S3` depends on `S1`**, for a reason distinct from
`S2`'s dependency:

- **S1 -> S2 is a compile-order dependency:** let-chain syntax literally does not compile
  against a toolchain below 1.88; `S2`'s code cannot be written correctly, let alone tested,
  until `S1`'s `Cargo.toml`/`ci.yml` change is real. This is the hardest, least-debatable edge in
  the graph.
- **S1 -> S3 is a content-accuracy dependency, not a compile-order one:** `S3`'s README badge
  and CHANGELOG-consolidation ACs need to cite the EXACT `comfy-table` version `S1`'s
  implementer selects (`S1` AC-002 deliberately leaves this open — "current latest 7.x release
  at implementation time") and whether the `--all-targets` scope widening shipped cleanly (`S1`
  EC-004). Writing `S3`'s doc claims before `S1` merges risks a wrong version number or an
  unconfirmed scope claim. This is weaker than a compile-order dependency (a `--output json`-style
  "the code would still build" case) but is a real correctness dependency the story-writer's own
  Anchor Justification Requirement obligates encoding as a graph edge rather than leaving as
  prose-only "recommended sequencing" (contrast with the `S-cycle7-readme-migration-note`
  precedent, cited in `S3`'s own frontmatter `origin:`, where the predecessor story had no
  comparable stake in the successor's exact claims).

Both edges are therefore real `depends_on:` graph edges (not editorial-only notes), giving the
`S1 -> {S2, S3}` fan-out shape.

---

## 5. File-Overlap Check (informational — see `wave-schedule.md` §2 for the full accounting)

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

**Overlap found: S2 and S3 both touch `CLAUDE.md` and `CHANGELOG.md`, in the SAME wave (Wave
2).** Since `S1 -> {S2, S3}` and there is no edge between `S2`/`S3` themselves, both are
dispatch-eligible in parallel once `S1` merges.

- **`CLAUDE.md` overlap:** S2 deletes the "No let-chains" Conventions-section entry (a
  standalone bullet). S3 edits the Gotchas-section SHA/version-citation bullet (a different,
  unrelated bullet). No line-level collision expected — disjoint sections of the same file — but
  both stories editing the same file in the same wave carries the standard rebase/merge-conflict
  risk this project's convention already recognizes (cycle-003 Wave 4, cycle-007's A/B1
  `auth.rs` overlap). **Resolution: NOT encoded as a `depends_on:` edge** (no functional
  build-order requirement — S2's convention-entry deletion does not touch S3's SHA-citation
  bullet's text, and vice versa). Recommended intra-wave merge-order sequencing only: whichever
  PR is ready first lands first; the other rebases.
- **`CHANGELOG.md` overlap:** treated as a shared, append-only file (same class as the
  `.cargo/mutants.toml` `examine_globs` precedent in cycle-007's dependency-graph-extended.md
  §2) — S1 adds the primary MSRV-bump entry, S2 adds a let-chain-retrofit entry, S3
  reviews/consolidates (its own AC-002 explicitly instructs checking for duplication before
  adding). Three stories appending to the same `[Unreleased]` section across two waves is
  ordinary CHANGELOG hygiene, not a structural risk — no edge needed.

No inconsistency or blocking conflict to flag beyond the standard intra-wave merge-order
recommendation above.

---

## 6. Conflict Check Against In-Progress Work

Per `STORY-INDEX.md`'s `last_updated` log at analysis time, the most recent in-flight work is
cycle-012's `S-cycle12-jsm-adf-autoconvert` (status `ready`, Wave 2 eligible) and its merged
sibling `S-cycle12-platform-adf-autoconvert`. Neither touches any file this cycle's 3 stories
touch (`Cargo.toml`, `.github/workflows/ci.yml`, `tests/ci_gate_completeness.rs`,
`src/cli/auth/keychain.rs`, `src/cli/board.rs`, `src/cli/issue/list.rs`,
`README.md`, `CHANGELOG.md`, `CLAUDE.md`, the design spec, or the two BC files this cycle
edits — `tests/common/wf.rs` is deliberately excluded from this list too, per §5's Pass-4 F-D
note: it is read-only/out-of-scope, never edited by any cycle-013 story) — cycle-012's
ADF-autoconversion work is scoped to `src/adf.rs`, `src/cli/issue/field_resolve.rs`,
and `src/cli/issue/jsm_create.rs`. **No conflict with in-progress work identified.**

`CHANGELOG.md` is the one file both cycle-012 and cycle-013 stories may append to concurrently
— append-only, same low-risk class as the overlap noted in §5.
