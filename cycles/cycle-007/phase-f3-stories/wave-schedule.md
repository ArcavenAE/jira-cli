---
document_type: wave-schedule
level: ops
version: "1.0"
phase: phase-f3-incremental-stories
cycle: cycle-007
feature: auth-correctness-dx
status: draft
producer: story-writer
created: 2026-09-10
timestamp: "2026-09-10T00:00:00"
inputs:
  - ".factory/cycles/cycle-007/phase-f3-stories/dependency-graph-extended.md"
traces_to: "dependency-graph-extended.md §4a"
input-hash: "00f4118"
---

# F3 Wave Schedule — `auth-correctness-dx` (cycle-007)

Wave grouping by Kahn-layering (BFS levels over the acyclic 5-node graph
proven in `dependency-graph-extended.md` §4a).

## Summary

| Metric | Value |
|--------|-------|
| Total stories (this cycle) | 5 |
| Total waves | 2 |
| Max parallelism (stories in one wave) | 4 (Wave 1: A, B1, C, D) |
| Estimated agent spawns | 5 (one implementer dispatch per story) |

---

## 1. Layering Derivation

| Round | Indegree-0 set at this round | Wave |
|-------|----------------------------------|------|
| 1 | {A, B1, C, D} | **Wave 1** |
| 2 | {B2} (indegree 0 only after B1's Wave-1 completion) | **Wave 2** |

**Computed layering — 2 waves:** A, B1, C, and D all have `depends_on: []`
and reach indegree 0 immediately (Wave 1). B2 depends on B1 and reaches
indegree 0 only once B1 completes (Wave 2). This matches the task brief's
own expectation of "1-2 waves" for a set of largely-independent, different-
file stories.

---

## 2. File-Overlap Check

| Story | Primary file(s) touched |
|-------|-----------------------------|
| A (`credential-absence-fix`) | `src/api/auth.rs` (two isolated error-message branches in `load_api_token`) |
| B1 (`auth-state-derivation`) | `src/api/auth.rs` (new `derive_auth_state` function, elsewhere in the same file), `src/cli/auth/list.rs` |
| B2 (`auth-status-json`) | `src/cli/auth/status.rs`, `src/main.rs` (thin dispatch-threading change) |
| C (`oauth-help-text-fix`) | `src/cli/mod.rs` |
| D (`readme-migration-note`) | `README.md` |

**Overlap found: A and B1 both touch `src/api/auth.rs`, in the SAME Wave
(Wave 1).** This is the one genuine file-overlap risk in this cycle's
schedule.

- **Nature of the overlap:** A modifies two `Err(...)` construction sites
  inside the EXISTING `load_api_token` function (two isolated string/error-
  type changes). B1 ADDS a wholly new, separate function (`derive_auth_state`)
  to the same file, plus modifies `src/cli/auth/list.rs` (no overlap with A
  there). No line-level collision is expected — the two diffs touch disjoint
  regions of `auth.rs` — but both stories editing the SAME file concurrently
  in the SAME wave carries the standard rebase/merge-conflict risk this
  project's convention already recognizes (e.g. cycle-003 Wave 4's
  `S-cycle3-adr0011-newtype` + `S-cycle3-oauth-default-creation`, and
  cycle-004's file-overlap notes).
- **Resolution: NOT encoded as a `depends_on:` edge** (there is no functional
  build-order requirement — B1's `derive_auth_state` does not call, is not
  called by, and shares no state with A's error-message branches). Instead,
  per the established precedent (`dependency-graph-extended.md` §2's
  cross-reference to cycle-003 Wave 4), **RECOMMENDED intra-wave sequencing**:
  whichever of A/B1's PRs is ready first should land first; the other rebases
  onto it before merging. Both may be DISPATCHED in parallel (same wave); only
  the MERGE order needs light coordination.
- **Shared append-only files (not a merge-conflict risk in the usual sense,
  same convention as `CHANGELOG.md`):** `.cargo/mutants.toml` currently has NO
  entry for `src/api/auth.rs` or ANY `src/cli/auth/*.rs` file (confirmed
  absent by grep at F3 time — a pre-existing mutation-testing coverage gap
  for a HIGH-criticality auth module, newly surfaced by this F3 pass, not
  previously flagged in any prior cycle's F3 output). `CHANGELOG.md` itself
  is touched by ALL FIVE stories (append-only, one line per story, the
  established convention).
  **`examine_globs` ownership (F3 adversary pass-3, finding MED-1 —
  supersedes the pass-2 "each story confirms rather than duplicates" framing
  below for `list.rs`/`status.rs` specifically; FURTHER REVISED at F3
  adversary pass-4, finding MEDIUM-1, for `src/api/auth.rs` specifically —
  see the dedicated callout below):** each of the two `src/cli/auth/*.rs`
  files this cycle actually adds to `examine_globs` gets exactly ONE owning
  story, the one that modifies that file: `src/cli/auth/list.rs` is owned
  exclusively by B1 (Task 14); `src/cli/auth/status.rs` is owned exclusively
  by B2 (Task 15) — neither A nor B1 add `status.rs`, and A adds neither
  `list.rs` nor `status.rs` (an earlier draft of A's Task 10 had proposed
  adding both, despite A touching neither file — corrected at pass-3).
  **`src/api/auth.rs` — DROPPED, deferred (F3 adversary pass-4, finding
  MEDIUM-1):** the pass-2/pass-3 framing above had A's Task 10 add
  whole-file `src/api/auth.rs` to `examine_globs`, with B1's Task 14
  "confirming rather than duplicating" (whichever of A/B1's PR lands first
  adds the entry). That whole-file addition — and A's paired
  `load_api_token`-scoped `exclude_re` (Task 10a) — is now REMOVED from
  BOTH stories: `examine_globs` has no sub-file targeting, so the addition
  would have pulled ~15-20 PRE-EXISTING keyring-gated functions neither A
  nor B1 touches (`load_oauth_tokens`, `store_*`, `clear_*`,
  `probe_stored_credential_kind`, etc.) into the nightly full-scope
  mutation run, flooding it with un-actionable false survivors. Neither A
  nor B1 modifies `.cargo/mutants.toml`'s `examine_globs` for
  `src/api/auth.rs` — the addition is a standing DEFERRED item, not this
  cycle's task. See Story A's "Deferred: `src/api/auth.rs` Mutation-Scope
  Expansion" section for the full rationale and locked disposition.
  **`exclude_re` additions (F3 adversary pass-2 finding MEDIUM-1, EXTENDED
  by F3 adversary pass-3 finding MED-1 — corrects the pass-2 claim that only
  Story A adds one; FURTHER REVISED at F3 pass-4, MEDIUM-1 — Story A's own
  entry, below, is DROPPED along with its `examine_globs` addition):** B1
  and B2 each add an `exclude_re` entry to this shared array, one per
  owning story, each scoped to the one genuinely keyring-gated (no
  in-memory injection seam) effectful surface that story's own diff newly
  brings into `examine_globs`. **A's own `load_api_token`-scoped
  `exclude_re` is REMOVED (F3 pass-4, MEDIUM-1) along with its
  `examine_globs` addition** — its exact regex text is retained in Story
  A's own "Mutation Testing Scope" section as a historical/deferred-design
  note for whichever future story undertakes the deferred whole-file
  `auth.rs` expansion, but it is NOT applied by this cycle:
  - **B1** — a pair of regexes scoped to `probe_matching_kind_credential`
    (`list.rs`), a NEW small function B1's own diff introduces to hold the
    real `load_oauth_tokens`/`load_api_token` probe selection; extracted
    specifically so it could be file+function-name excluded rather than
    left as an undocumented false-survivor once `list.rs` entered
    `examine_globs`. `derive_auth_state`, `collect_probe_results`'s loop
    logic, and the AC-014-purified renderers remain fully default-CI-
    testable and are NOT covered by this exclusion. See B1's "Mutation
    Testing Scope — `probe_matching_kind_credential` Exclusion" section.
  - **B2** — a pair of regexes scoped to `probe_matching_kind_credential`
    (`status.rs`, a file-local function independent of B1's identically-
    named `list.rs` function) plus a pair scoped to the pre-existing
    `peek_oauth_app_source` (which reads the keychain via
    `try_load_oauth_app_credentials`, newly brought into `examine_globs`
    scope by B2's own Task 15). `build_status_json` and
    `peek_oauth_app_source_for_test` remain fully default-CI-testable and
    are NOT covered by this exclusion. See B2's "Mutation Testing Scope —
    `probe_matching_kind_credential` / `peek_oauth_app_source` Exclusion"
    section.
  **Corrected coverage claim (F3 adversary pass-3, MED-1):** the pass-2
  draft of this section claimed whole-file `src/api/auth.rs`/`list.rs`/
  `status.rs` in `examine_globs` gives "a genuinely TRUE coverage signal…
  without scoping" for B1 and B2. That claim was TRUE only for the PURE
  functions each story introduces (`derive_auth_state`; the AC-014-purified
  `render_list_table`/`render_list_json`; `build_status_json`) — it did NOT
  account for B1's own `probe_matching_kind_credential` (a genuinely new,
  genuinely untestable-in-default-CI function B1's diff adds) or for the
  pre-existing `status.rs` probe surfaces (`probe_matching_kind_credential`,
  `peek_oauth_app_source`) that B2's own `examine_globs` addition newly
  brings into scope. The TRUE-signal claim is now correctly scoped: TRUE for
  the pure functions each story owns, and honest (via the `exclude_re`
  entries above) for the effectful probe surfaces each story's
  `examine_globs` addition would otherwise silently mis-report as MISSED.
- **C and D have zero overlap with anything** — `src/cli/mod.rs` (C) and
  `README.md` (D) are touched by no other cycle-007 story.

---

## Wave Plan

### Wave 1 — `S-cycle7-credential-absence-fix`, `S-cycle7-auth-state-derivation`, `S-cycle7-oauth-help-text-fix`, `S-cycle7-readme-migration-note`

- **Stories:** 4, parallel.
- **Points:** 8 + 8 + 2 + 2 = 20. (`S-cycle7-credential-absence-fix` re-estimated
  5 → 8 at F3 adversary pass-7, MEDIUM-1 — Task 7a's ~12-pre-existing-test
  rewrite scope.)
- **File footprint:** `src/api/auth.rs` (A + B1, overlap noted above),
  `src/cli/auth/list.rs` (B1), `src/cli/mod.rs` (C), `README.md` (D),
  `.cargo/mutants.toml` (B1 only — F3 adversary pass-4, MEDIUM-1: A no
  longer touches `.cargo/mutants.toml` at all, since its `examine_globs`
  Task 10/10a were dropped and deferred; see Story A's "Deferred:
  `src/api/auth.rs` Mutation-Scope Expansion" section), `CHANGELOG.md`
  (all 4 — shared append-only).
- **Recommended intra-wave merge order:** A and B1 may dispatch and implement
  in parallel; whichever PR is ready first merges first, the other rebases.
  C and D have no ordering constraint with anything in this wave or with each
  other. D's own frontmatter carries an EDITORIAL (non-blocking) note
  recommending it cite A's corrected `--profile` syntax if A has already
  landed by the time D's PR is written — this is a writing-time convenience,
  not a dispatch/merge gate.
- **Gate:** standard wave-gate (full regression on `develop`, adversarial
  review of the wave diff, demo evidence for A/B1's exit-code and
  STATUS-column behavioral changes). Given this wave touches
  `src/api/auth.rs` (module_criticality: HIGH for A and B1), the wave gate's
  adversarial-review pass should explicitly re-verify: (a) A's exit-code
  reclassification does not leak into `status.rs`'s unrelated unknown-profile
  site (BC-1.1.004 regression, AC-006/007/008 in A); (b) B1's
  `derive_auth_state` is genuinely pure/IO-free (AC-004 in B1); (c) neither
  A nor B1 has added `src/api/auth.rs` to `.cargo/mutants.toml`
  `examine_globs` — that whole-file addition (and A's paired
  `load_api_token` `exclude_re`) was DROPPED and deferred at F3 adversary
  pass-4, finding MEDIUM-1 (see Story A's "Deferred: `src/api/auth.rs`
  Mutation-Scope Expansion" section); confirm neither PR reintroduces it;
  (d) B1's `probe_matching_kind_credential` `exclude_re` pair (F3 pass-3,
  MED-1), scoped to `src/cli/auth/list.rs` only, matches only that
  function, per B1's own "VERIFY BEFORE LANDING" dry-run check.

### Wave 2 — `S-cycle7-auth-status-json`

- **Stories:** 1, solo (its sole dependency, B1, is satisfied by Wave 1's
  completion).
- **Points:** 8.
- **File footprint:** `src/cli/auth/status.rs`, `src/main.rs`,
  `.cargo/mutants.toml` (shared append-only — B2 owns `status.rs`'s
  `examine_globs` entry EXCLUSIVELY, per the F3 pass-3 MED-1 ownership
  reconciliation in §2 above; no confirm-vs-duplicate check needed for this
  file), `CLAUDE.md` (NFR-O-N gotcha update),
  `CHANGELOG.md` (shared append-only).
- **Precondition:** `S-cycle7-auth-state-derivation`'s `derive_auth_state`
  helper must exist and be merged to `develop` (or at minimum available on a
  shared branch this story's implementer can build against) before this
  story's implementation can compile its own tests.
- **Gate:** standard wave-gate (full regression on `develop`, adversarial
  review of the wave diff). Special attention: (a) the human-text
  byte-for-byte-unchanged regression (AC-006) — this is the single easiest
  guarantee to accidentally violate in this whole cycle, since it requires
  NOT changing observable output while changing internal derivation source;
  (b) the intentional `url: None` + credential-present divergence (AC-008,
  EC-1.6.050-4) must be confirmed as accepted, not "fixed" by an
  over-eager reviewer trying to force 3-way parity across all three channels
  (text/list-JSON/status-JSON) — that is explicitly NOT what VP-AUTHDX-024/
  029 require, per BC-1.6.048 Postcondition 3 as revised round 6; (c) B2's
  `probe_matching_kind_credential`/`peek_oauth_app_source` `exclude_re` pairs
  (F3 pass-3, MED-1) match only those two functions, per B2's own "VERIFY
  BEFORE LANDING" dry-run check.

---

## 3. Pipeline Overlap Plan

Wave 1's 4 stories may be dispatched to 4 concurrent implementer agents
(subject to the A/B1 file-overlap merge-order recommendation in §2 above).
Wave 2's single story (B2) cannot dispatch until Wave 1's B1 has merged —
standard sequential-wave gating; no additional overlap opportunity exists
since B2 is the sole Wave-2 member.

No cross-cycle overlap conflicts identified: no other cycle in this repo
(cycle-001 through cycle-006, all CLOSED/MERGED or otherwise not concurrently
active per `STATE.md`'s Concurrent Cycles tracking at F3 time) touches
`src/api/auth.rs`, `src/cli/auth/*.rs`, `src/cli/mod.rs`, or `README.md` in a
way that would race this cycle's Wave 1/Wave 2 dispatch.

---

## 4. Critical Path

```
S-cycle7-auth-state-derivation (Wave 1, 8 pts) -> S-cycle7-auth-status-json (Wave 2, 8 pts)
```

**Critical path length: 2 stories / 2 waves, 16 points.** A, C, and D are all
off the critical path (each completes within Wave 1, in parallel with B1).

---

## 5. Total Feature Points

| Story | Wave | Points |
|-------|------|--------|
| `S-cycle7-credential-absence-fix` | 1 | 8 |
| `S-cycle7-auth-state-derivation` | 1 | 8 |
| `S-cycle7-oauth-help-text-fix` | 1 | 2 |
| `S-cycle7-readme-migration-note` | 1 | 2 |
| `S-cycle7-auth-status-json` | 2 | 8 |
| **Total** | — | **28** |

---

## 6. Conflict-Report Summary

No existing `STORY-INDEX.md` story shares a `depends_on:`/`blocks:` edge with
any new cycle-007 story (per `dependency-graph-extended.md` §2). No
in-progress story (checked against `STORY-INDEX.md`'s status column at
authoring time) touches `src/api/auth.rs`, `src/cli/auth/*.rs`,
`src/cli/mod.rs`, or `README.md` concurrently with this cycle's dispatch
window — no cross-cycle blocking conflict identified. The ONE
intra-cycle conflict is the A/B1 same-file (`src/api/auth.rs`)
overlap documented in §2 above — a merge-order recommendation, not a
dispatch blocker; both stories may be dispatched in parallel.
