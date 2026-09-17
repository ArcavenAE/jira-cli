---
document_type: wave-schedule
level: ops
version: "1.0"
phase: phase-f3-incremental-stories
cycle: cycle-008
feature: oauth-surface-correctness
status: draft
producer: story-writer
created: 2026-09-17
timestamp: "2026-09-17T00:00:00"
inputs:
  - ".factory/cycles/cycle-008/phase-f3-stories/dependency-graph-extended.md"
traces_to: "dependency-graph-extended.md §3"
input-hash: "a13acb6"
---

# F3 Wave Schedule — `oauth-surface-correctness` (cycle-008)

Wave grouping by Kahn-layering (BFS levels over the acyclic 6-node graph proven in
`dependency-graph-extended.md` §3), plus a parallel non-gating track for the spike.

## Summary

| Metric | Value |
|--------|-------|
| Total stories (this cycle) | 6 |
| Total waves | 2 gating waves + 1 parallel non-gating track |
| Max parallelism (stories in one wave) | 4 (Wave 1: S1, S2, S3, S4) |
| Total story points | 20 (S1: 5, S2: 3, S3: 2, S4: 5, S5: 2, S6: 3) |
| Critical path (gating) | S1 -> S5 (5 + 2 = 7 points; S2/S3/S4's Wave-1 points do not extend this path since none blocks S5) |
| Non-gating track | S6 (3 points) — runs in parallel with Waves 1-2, does not extend or shorten the critical path, and must not block cycle-008's release |
| Estimated agent spawns | 6 (one implementer dispatch per story; S6 dispatches a research/investigation agent, not `implementer`) |

---

## 1. Layering Derivation

| Round | Indegree-0 set at this round | Wave |
|-------|----------------------------------|------|
| 1 | {S1, S2, S3, S4} (S6 excluded from wave numbering — parallel non-gating track, see §3) | **Wave 1** |
| 2 | {S5} (reaches indegree 0 only after S1's Wave-1 completion) | **Wave 2** |

**Computed layering — 2 gating waves + 1 parallel track:** S1, S2, S3, S4 all have
`depends_on: []` and reach indegree 0 immediately (Wave 1, four-way parallel — no edges among
them, confirmed by the File-Overlap Check in `dependency-graph-extended.md` §5, which found zero
`src/`-level file overlap across all four). S5 depends on S1 (a genuine content-truth dependency,
per `dependency-graph-extended.md` §4) and reaches indegree 0 only once S1 completes and merges
(Wave 2, sole story). S6 is intentionally NOT assigned a wave number in the gating sequence — per
F1 §6(a)'s explicit recommendation and ADR-0026 Decision 4's deferred framing, it runs on a
**parallel, non-gating track** alongside Waves 1-2 and must not block either wave's completion or
this cycle's release.

---

## 2. File-Overlap Check

| Story | Primary file(s) touched |
|-------|-----------------------------|
| S1 (`jsm-servicedeskapi-oauth-routing`) | `src/api/jsm/servicedesks.rs`, `src/api/jsm/request_types.rs`, `src/api/jsm/queues.rs`, `src/api/jsm/requests.rs`, `docs/adr/0009-*.md`, `docs/adr/0006-*.md`, `docs/adr/0013-*.md`, `CHANGELOG.md` |
| S2 (`agile-oauth-scope-gap`) | `src/api/auth.rs`, `src/cli/auth/tests/mod.rs`, `CHANGELOG.md` |
| S3 (`assets-workspace-oauth-routing`) | `src/api/assets/workspace.rs`, `CHANGELOG.md` |
| S4 (`agile-scope-mismatch-error-mapping`) | `src/cli/board.rs`, `src/cli/sprint.rs`, `CHANGELOG.md` |
| S5 (`jsm-attachments-oauth-verification`, Wave 2) | `tests/attachment_jsm.rs` only |
| S6 (`teams-graphql-oauth-replatform-spike`, parallel track) | none (investigation-only) |

**No overlap found among Wave 1's four stories at the `src/` level** — S1/S2/S3/S4 each touch
entirely disjoint source directories/files (`src/api/jsm/`, `src/api/auth.rs`,
`src/api/assets/workspace.rs`, `src/cli/{board,sprint}.rs` respectively). All four are fully
dispatch-eligible in parallel with no merge-order coordination needed beyond the shared
`CHANGELOG.md` append-only convention below.

- **`CHANGELOG.md` overlap (S1, S2, S3, S4, all in Wave 1):** append-only shared file, same
  low-risk class as every prior cycle's `CHANGELOG.md` overlap in this repo (cycle-007 Wave 1's
  4-story bundle, cycle-013 Wave 2's S2/S3 pair). No `depends_on:` edge needed; whichever PR
  merges first appends first, subsequent PRs rebase trivially over an append-only section.
- **`src/api/auth.rs` overlap with EXISTING (non-cycle-008) draft stories** — see
  `dependency-graph-extended.md` §6 for the full accounting: `S-cycle7-credential-absence-fix`
  and `S-cycle7-auth-state-derivation` (both `status: draft`, cycle-007, still un-dispatched) also
  touch `src/api/auth.rs`, in disjoint code regions (`load_api_token`/`derive_auth_state` vs. this
  cycle's `DEFAULT_OAUTH_SCOPES` constant). No dependency edge — recommended merge-order
  sequencing only, mirroring the precedent `S-cycle7-auth-state-derivation`'s own frontmatter
  already set for the identical class of overlap.

No blocking conflict to flag beyond the standard intra-wave/cross-cycle merge-order
recommendations above.

---

## 3. Wave Execution Plan

### Wave 1 (4-way parallel)

| Story | Points | Blocks |
|-------|--------|--------|
| `S-cycle8-jsm-servicedeskapi-oauth-routing` | 5 | `S-cycle8-jsm-attachments-oauth-verification` |
| `S-cycle8-agile-oauth-scope-gap` | 3 | (none — RECOMMENDED, non-blocking sequencing note only for S4, see `dependency-graph-extended.md` §4) |
| `S-cycle8-assets-workspace-oauth-routing` | 2 | (none) |
| `S-cycle8-agile-scope-mismatch-error-mapping` | 5 | (none) |

All four stories are dispatch-eligible simultaneously. **Recommended (non-blocking) intra-wave
ordering:** dispatch `S-cycle8-agile-oauth-scope-gap` slightly ahead of
`S-cycle8-agile-scope-mismatch-error-mapping` if resourcing allows, per F1 §7's editorial
sequencing note — but this is a scheduling preference, not a gate; `S-cycle8-agile-scope-
mismatch-error-mapping` may be dispatched and fully completed (mocked-401 tests) with zero
dependency on the other story's landed state.

**Gate before Wave 2 dispatch:** `S-cycle8-jsm-servicedeskapi-oauth-routing`'s PR must be MERGED
(not merely "PR opened") before dispatching Wave 2 — `S-cycle8-jsm-attachments-oauth-
verification`'s test has a real content-truth dependency on S1's actual landed
`list_service_desks` fix (see `dependency-graph-extended.md` §4), stricter than the default
"story status: done" gate.

### Wave 2

| Story | Points | Depends On |
|-------|--------|------------|
| `S-cycle8-jsm-attachments-oauth-verification` | 2 | `S-cycle8-jsm-servicedeskapi-oauth-routing` (content-truth) |

Sole story in this wave — dispatch-eligible once the Wave-1 gate above is satisfied.

### Parallel Non-Gating Track (runs alongside Waves 1-2)

| Story | Points | Depends On |
|-------|--------|------------|
| `S-cycle8-teams-graphql-oauth-replatform-spike` | 3 | none |

Per F1 §6(a)'s explicit recommendation: this spike may be dispatched at any time (including
concurrently with Wave 1) and its findings are NOT a prerequisite for either wave's completion or
this cycle's release. If the spike is still in progress when Waves 1-2 complete, cycle-008 ships
without it — `jr team list` remains status-quo-broken under OAuth, an accepted, documented gap
(ADR-0026 Consequences), not a regression.

---

## 4. Wave Holdout Scenarios

Per the F3 skill's Step 7b, cross-story integration and regression scenarios for this cycle's 2
gating waves (the parallel spike track has no holdout scenario — it produces no code):

### Wave 1 holdout (MUST-PASS)

1. **Routing/scope independence:** a fresh checkout of `develop` after Wave 1 merges shows all
   four stories' changes coexisting correctly — `jr queue`/`jr requesttype`/`jr issue create
   --request-type` route through `base_url` (S1), `DEFAULT_OAUTH_SCOPES` carries the full
   16-scope union (S2), `jr assets *`'s workspace discovery routes through `base_url` (S3), and
   `jr board`/`jr sprint`'s 401 disambiguation fires correctly (S4) — all four simultaneously
   true, none regressing another (confirmed by each story's own regression-guard ACs plus a full
   `cargo test` run against the merged tree).
2. **API-token no-op guarantee, cross-story:** for an API-token profile, `jr queue`, `jr
   requesttype`, `jr issue create --request-type`, `jr assets *`, `jr board`, and `jr sprint` all
   produce byte-for-byte identical behavior to pre-cycle-008 `develop` — the combined regression
   surface of S1+S3's routing swaps and S4's auth-scheme-conditional rewrite (which short-circuits
   entirely for `is_oauth_auth() == false`).
3. **Full regression suite:** `cargo test` (all binaries) passes on the merged Wave-1 tree,
   including every pre-existing `tests/jsm_request_api.rs`, `tests/assets.rs`,
   `tests/board_commands.rs`, `tests/sprint_commands.rs`, and `tests/issue_create_jsm.rs` case.

### Wave 2 holdout (MUST-PASS)

4. **End-to-end JSM attachment OAuth proof:** after S5 merges, the JSM two-step attachment upload
   flow succeeds end-to-end under a real OAuth-shaped wiremock scenario (project-meta GET,
   service-desk-list GET, attach-temporary-file POST, request-attachment POST all targeting
   `base_url`), closing the transitive dependency chain F1 §1 item 1 identified.
5. **No CHANGELOG duplication:** `CHANGELOG.md`'s `[Unreleased]` section, read after both waves
   complete, contains no contradictory or near-duplicate entries describing the same underlying
   OAuth-routing fix across S1's and S5's PRs (S5 deliberately adds no CHANGELOG entry of its own,
   per its own AC-003 — this holdout confirms that discipline held).

### Release-gate holdout (MUST-PASS, cross-cutting — not tied to a single wave)

6. **Developer Console coordination confirmed BEFORE release:** the PR for `S-cycle8-agile-
   oauth-scope-gap` (Wave 1) explicitly documents, in its own description, that the Atlassian
   Developer Console app-permission update for all 8 new scopes has landed (or is scheduled to
   land) before the release containing this change ships — per that story's own AC-006 hard
   release-gate note. This is a manual PR-review-level check, not an automated test.

---

## 5. Human Approval Gate (F3, per skill Step 9)

This wave schedule, the 6 story files, and the extended dependency graph are presented for
explicit human approval before any F4 dispatch. Per the task framing for this F3 pass: **no DEC
is minted by this burst** — that is the orchestrator's F3 human-gate action, not story-writer's.
`STATE.md` is not touched by this burst. `STORY-INDEX.md` is not touched by this burst — its
integration is a separate, subsequent sub-burst per the dispatch's own create-only scoping.
