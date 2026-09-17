---
document_type: dependency-graph
phase: phase-f3-incremental-stories
cycle: cycle-008
feature: oauth-surface-correctness
status: draft
producer: story-writer
created: 2026-09-17
inputs:
  - ".factory/cycles/cycle-008/phase-f3-stories/S-cycle8-jsm-servicedeskapi-oauth-routing.md"
  - ".factory/cycles/cycle-008/phase-f3-stories/S-cycle8-agile-oauth-scope-gap.md"
  - ".factory/cycles/cycle-008/phase-f3-stories/S-cycle8-assets-workspace-oauth-routing.md"
  - ".factory/cycles/cycle-008/phase-f3-stories/S-cycle8-agile-scope-mismatch-error-mapping.md"
  - ".factory/cycles/cycle-008/phase-f3-stories/S-cycle8-jsm-attachments-oauth-verification.md"
  - ".factory/cycles/cycle-008/phase-f3-stories/S-cycle8-teams-graphql-oauth-replatform-spike.md"
  - ".factory/stories/STORY-INDEX.md"
traces_to: ".factory/cycles/cycle-008/F1-delta-analysis.md §7"
input-hash: "bdd9f77"
---

# F3 Extended Dependency Graph — `oauth-surface-correctness` (cycle-008)

Computes the dependency graph over the 6 new cycle-008 stories, confirms it is acyclic (Kahn's
algorithm), and cross-links it against the existing `STORY-INDEX.md` graph (185 pre-cycle-008
stories per `STORY-INDEX.md` frontmatter `total_stories: 185` at analysis time — this document
does not itself edit that file; a separate integrate sub-burst registers the new rows).

---

## 1. Node Inventory

**Convention note (mirrors cycle-005/006/007/012/013's dependency-graph-extended.md §1):**
`depends_on:` is the authoritative graph EDGE set; `blocks:` is informational/
inverse-consistency-checked only.

| ID | Story | `depends_on` (frontmatter, verified against story file) |
|----|-------|-----------------------------------------------------------|
| S1 | `S-cycle8-jsm-servicedeskapi-oauth-routing` | `[]` |
| S2 | `S-cycle8-agile-oauth-scope-gap` | `[]` |
| S3 | `S-cycle8-assets-workspace-oauth-routing` | `[]` |
| S4 | `S-cycle8-agile-scope-mismatch-error-mapping` | `[]` |
| S5 | `S-cycle8-jsm-attachments-oauth-verification` | `["S-cycle8-jsm-servicedeskapi-oauth-routing"]` |
| S6 | `S-cycle8-teams-graphql-oauth-replatform-spike` | `[]` |

**`blocks:` inverse-consistency check:**

| Story | `blocks:` (frontmatter) | Inverse holds? |
|-------|---------------------------|-----------------|
| S1 (`jsm-servicedeskapi-oauth-routing`) | `["S-cycle8-jsm-attachments-oauth-verification"]` | consistent — S5 names S1 in its own `depends_on:` |
| S2 (`agile-oauth-scope-gap`) | `[]` | consistent — nothing depends on S2 as a hard graph edge (S4's sequencing note is editorial-only, not a `depends_on:` entry — see §4) |
| S3 (`assets-workspace-oauth-routing`) | `[]` | consistent — nothing depends on S3 |
| S4 (`agile-scope-mismatch-error-mapping`) | `[]` | consistent — nothing depends on S4 |
| S5 (`jsm-attachments-oauth-verification`) | `[]` | consistent — nothing depends on S5 |
| S6 (`teams-graphql-oauth-replatform-spike`) | `[]` | consistent — nothing depends on S6 |

No inconsistency to flag. This is a single fan-in edge (`S1 -> S5`) plus 4 isolated nodes
(S2, S3, S4, S6) — the sparsest graph shape of any cycle to date in this repo.

---

## 2. Adjacency List

```
S1 (jsm-servicedeskapi-oauth-routing)     -> [S5]                    [no deps; blocks S5 only]
S2 (agile-oauth-scope-gap)                -> []   depends_on: []     [isolated node]
S3 (assets-workspace-oauth-routing)       -> []   depends_on: []     [isolated node]
S4 (agile-scope-mismatch-error-mapping)   -> []   depends_on: []     [isolated node; RECOMMENDED
                                                                       editorial sequencing after
                                                                       S2, NOT a graph edge]
S5 (jsm-attachments-oauth-verification)   -> []   depends_on: [S1]   [1 dep; no dependents]
S6 (teams-graphql-oauth-replatform-spike) -> []   depends_on: []     [isolated node; parallel,
                                                                       non-gating track]
```

**Cross-links to EXISTING stories:** none. Grep-verified against `STORY-INDEX.md`: no existing
story's `depends_on:`/`blocks:` frontmatter references any `S-cycle8-*` id (no such ids existed
before this burst), and none of the 6 new stories references an existing story ID as a hard
dependency. The cycle-008 subgraph is a **disjoint 6-node component** (one edge, `S1 -> S5`, plus
4 isolated nodes) relative to the existing 185-story graph.

---

## 3. Cycle Detection (Kahn's Algorithm)

```
Initial in-degree:  S1=0, S2=0, S3=0, S4=0, S5=1, S6=0

Round 1: indegree-0 set = {S1, S2, S3, S4, S6}  -> emit all 5 (no edges among them)
         remove S1's outgoing edge (S1 -> S5)
         after removal: S5=0

Round 2: indegree-0 set = {S5}                  -> emit S5

Round 3: indegree-0 set = {}                    -> queue empty, all 6 nodes emitted
```

**Topological order:** `{S1, S2, S3, S4, S6}` (any internal order — no edges among them), then
`S5`.

**Result: ACYCLIC.** All 6 nodes are emitted; no residual edges remain after the algorithm
terminates. No cycle exists in the extended graph (the new 6-node subgraph is disjoint from, and
does not interact with, the existing 185-story graph — trivially acyclic in combination).

---

## 4. Rationale for NOT Encoding S2 -> S4 as a Graph Edge

F1 §7's story-decomposition preview frames `S4`'s sequencing as "Best sequenced AFTER S2 (needs
the real Agile-scope-mismatch case to exist/be testable against; can be built with a mocked 401
body independently...)". This pass deliberately does **NOT** encode this as a `depends_on:` edge,
for a reason distinct from the genuine `S1 -> S5` dependency below:

- **`S1 -> S5` is a content-truth dependency:** S5's own test asserts that the JSM attachment flow
  succeeds end-to-end under OAuth. That assertion is FALSE until S1's fix is actually merged —
  there is no way to make S5's test pass, even with mocks, without S1's real code change existing
  in the tree (the whole point is exercising `resolve_service_desk_id` →
  `get_or_fetch_project_meta` → `list_service_desks`, S1's own fix site, for real). This is a hard
  graph edge.
- **`S2 -> S4` is NOT a compile-order or content-truth dependency:** S4's own verification
  strategy (BC-X.15.001 / VP-OAUTH-GW-003, confirmed in that story's own frontmatter and body)
  uses a MOCKED 401 response body for every test case — it does not need `DEFAULT_OAUTH_SCOPES`
  to have actually changed in order to compile, implement, or test its rewrite. The scope names
  S4's hints reference (`read:board-scope:jira-software`, etc.) are ALREADY fully specified in
  BC-1.3.023 as finalized at the F2 gate, independent of whether S2's code has merged. This is
  the SAME class of distinction cycle-013's dependency-graph-extended.md §4 drew between its own
  `S1 -> S2` (real compile-order edge) and a rejected candidate content-accuracy edge — here, even
  the weaker "content-accuracy" class does not apply, because S4 does not need to CITE anything
  about S2's landed state (its scope names come from the ADR/BC, not from S2's own file).

**Conclusion:** the F1 §7 sequencing note is retained as an editorial/recommended-order note in
S4's own frontmatter `depends_on:` comment and Previous Story Intelligence section, but is
correctly NOT a `depends_on:` graph edge. S2 and S4 are both Wave 1, fully parallel-dispatchable.

---

## 5. File-Overlap Check (informational — see `wave-schedule.md` §2 for the full accounting)

| Story | Primary file(s) touched |
|-------|-----------------------------|
| S1 (`jsm-servicedeskapi-oauth-routing`) | `src/api/jsm/servicedesks.rs`, `src/api/jsm/request_types.rs`, `src/api/jsm/queues.rs`, `src/api/jsm/requests.rs`, `docs/adr/0009-*.md`, `docs/adr/0006-*.md`, `docs/adr/0013-*.md`, `CHANGELOG.md` |
| S2 (`agile-oauth-scope-gap`) | `src/api/auth.rs`, `src/cli/auth/tests/mod.rs`, `CHANGELOG.md` |
| S3 (`assets-workspace-oauth-routing`) | `src/api/assets/workspace.rs`, `CHANGELOG.md` |
| S4 (`agile-scope-mismatch-error-mapping`) | `src/cli/board.rs`, `src/cli/sprint.rs`, `CHANGELOG.md` |
| S5 (`jsm-attachments-oauth-verification`) | `tests/attachment_jsm.rs` only (no `src/` file; no CHANGELOG entry, per its own AC-003) |
| S6 (`teams-graphql-oauth-replatform-spike`) | none (investigation-only; no file is modified) |

**No intra-cycle-008 file overlap found among S1/S2/S3/S4/S5's `src/`-level touches** — each
story's own file set (`src/api/jsm/*.rs`, `src/api/auth.rs`+test file, `src/api/assets/
workspace.rs`, `src/cli/board.rs`+`src/cli/sprint.rs`, `tests/attachment_jsm.rs`) is disjoint from
every other story's own file set, matching the dispatch framing's own note. `CHANGELOG.md` is the
one file S1/S2/S3/S4 all append to (append-only, low-risk class, same treatment as prior cycles'
`CHANGELOG.md` overlaps — no dependency edge needed).

---

## 6. Conflict Check Against In-Progress Work

Grep of `STORY-INDEX.md`'s Story Manifest table for the file paths this cycle's stories touch
(`src/api/jsm/servicedesks.rs`, `src/api/jsm/request_types.rs`, `src/api/jsm/queues.rs`,
`src/api/jsm/requests.rs`, `src/api/auth.rs`, `src/api/assets/workspace.rs`, `src/cli/board.rs`,
`src/cli/sprint.rs`, `src/error.rs`, `src/api/jira/teams.rs`), cross-referenced against every
`status: draft`/`in-progress` row:

- **No existing `draft`/`in-progress` story touches** `src/api/jsm/*.rs`, `src/api/assets/
  workspace.rs`, `src/cli/board.rs`, `src/cli/sprint.rs`, `src/error.rs`, or `src/api/jira/
  teams.rs`.
- **`src/api/auth.rs` IS touched by two existing `status: draft` stories** from cycle-007's
  `auth-correctness-dx` bundle, still un-dispatched at analysis time:
  - `S-cycle7-credential-absence-fix` — touches `load_api_token`'s two error-message branches
    (a different function/code region entirely from `DEFAULT_OAUTH_SCOPES`).
  - `S-cycle7-auth-state-derivation` — touches a new `derive_auth_state` helper (also a different
    code region; that story's OWN frontmatter already documents an analogous file-overlap note
    against `S-cycle7-credential-absence-fix`, confirming this repo's established convention for
    handling same-file, disjoint-region overlaps without a dependency edge).

**Resolution: NOT encoded as a `depends_on:` edge**, following the exact precedent
`S-cycle7-auth-state-derivation`'s own frontmatter already set for the identical situation: no
functional build-order requirement exists (S2's `DEFAULT_OAUTH_SCOPES` constant edit does not
touch `load_api_token` or `derive_auth_state`, and vice versa) — a **file-overlap note only**,
carried in `wave-schedule.md` §2, recommending merge-order sequencing (rebase, not blocking) if
any of these three `src/api/auth.rs`-touching stories land in overlapping timeframes.

No other conflict with in-progress work identified.
