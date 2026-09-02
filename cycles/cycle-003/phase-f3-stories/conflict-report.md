---
document_type: conflict-report
phase: phase-f3-incremental-stories
cycle: cycle-003
feature: auth-profile-dx
status: draft
producer: story-writer
created: 2026-09-01
inputs:
  - ".factory/cycles/cycle-003/phase-f3-stories/decomposition-manifest.md"
  - ".factory/stories/S-384-jsm-401-auth-aware-hints.md"
  - ".factory/stories/S-663-1-auth-switch-profile-guard.md"
  - ".factory/stories/S-MAINT-532-global-profile-fallback-coverage.md"
  - ".factory/stories/STORY-INDEX.md"
  - "src/api/client.rs"
traces_to: "decomposition-manifest.md §6/§7"
input-hash: "b4f9daa"
---

# F3 Conflict Report — `auth-profile-dx` (cycle-003)

INTEGRATE sub-burst artifact. Checks the 7 new cycle-003 stories against
in-progress/ready existing stories for same-file modification races or unmet-dependency
races. The manifest flagged three items for confirmation: `S-663-1` (done, disjoint),
`S-384` (ready, sequence-aware), `S-MAINT-532` (draft, deliberately out of scope). This
report confirms, refines, and closes each.

---

## 1. Cycle-003 File Footprint (recap, derived from each story's own File Structure
   Requirements section)

| Story | Files touched |
|---|---|
| `S-cycle3-env-tag` | `src/config.rs`, `src/cli/auth/list.rs`, `src/cli/auth/status.rs`, `src/output.rs` (or new module), `src/cli/auth/tests/snapshots/jr__cli__auth__tests__list_table_snapshot.snap` |
| `S-cycle3-percred-storage` | `src/api/auth.rs`, `src/cli/auth/login.rs`, `src/api/client.rs`, `tests/` (new/existing auth test file) |
| `S-cycle3-credential-absence-guard` | `src/api/auth.rs` |
| `S-cycle3-remove-logout-semantics` | `src/api/auth.rs`, `src/cli/auth/remove.rs`, `src/cli/auth/logout.rs` |
| `S-cycle3-adr0011-newtype` | `src/config.rs` (or new `src/profile.rs`), `src/cache.rs`, `src/api/auth.rs`, `src/api/client.rs`, every caller under `src/cli/**`, `docs/adr/0011-type-level-profile-fence.md` |
| `S-cycle3-oauth-default-creation` | `src/cli/mod.rs`, `src/cli/auth/login.rs`, `src/cli/auth/refresh.rs` |
| `S-cycle3-chosen-flow-reconcile` | `src/cli/auth/mod.rs`, `src/cli/auth/refresh.rs` |

Union of touched files across all 7: `src/config.rs`, `src/cli/auth/list.rs`,
`src/cli/auth/status.rs`, `src/output.rs`, `src/api/auth.rs`, `src/cli/auth/login.rs`,
`src/api/client.rs`, `src/cli/auth/remove.rs`, `src/cli/auth/logout.rs`, `src/cache.rs`,
`src/cli/mod.rs`, `src/cli/auth/refresh.rs`, `src/cli/auth/mod.rs`, plus one snapshot
file and (for `adr0011-newtype`) an unenumerated but wide `src/cli/**` call-site sweep.
(Intra-cycle same-file overlap across these 7 stories — e.g. `src/api/auth.rs` touched
by 3 stories, `src/cli/auth/login.rs` by 2 — is resolved by the wave schedule's
serialization, not by this report; see `wave-schedule.md`.)

---

## 2. Item 1 — `S-663-1` (`auth switch --profile` guard)

**Manifest's claim:** "done, disjoint."

**Verification:**
- `story_id: "S-663-1"`, `status: done` (confirmed via frontmatter read).
- `target_module: src/main.rs`, `depends_on: []`, `blocks: []`.
- STORY-INDEX.md row confirms: DELIVERED and squash-merged as PR #696 (`c9218389`),
  closes #663, 2026-08-14 — already on `develop`.
- File touched: `src/main.rs`'s `AuthCommand::Switch` dispatch arm only. None of the 7
  cycle-003 stories touch `src/main.rs` (checked against §1's file footprint table).

**Disposition: CONFIRMED — no conflict.** `S-663-1` is both (a) already merged (no live
race is possible against completed, merged work) and (b) file-disjoint from every
cycle-003 story even if it were still in flight. No action needed.

---

## 3. Item 2 — `S-384` (JSM 401 auth-aware hints)

**Manifest's claim:** "ready, sequence-aware" — i.e., `S-384` is still undelivered, and
cycle-003 doesn't change its gating logic but shifts which profiles most commonly hit
`is_oauth_auth()`'s gate (since OAuth becomes the creation-time default).

**Verification — REFINEMENT REQUIRED (manifest's characterization is stale):**
- Story file frontmatter reads `status: ready` (matching the manifest's claim at face
  value).
- **However, `STORY-INDEX.md`'s own Feature-Followup summary table (row for `S-384`)
  states: "completed — PR #394 / b36b291 (2026-05-20)."**
- **Ground-truth check against the actual codebase:** `grep -n "fn is_oauth_auth" src/`
  finds `src/api/client.rs:230: pub(crate) fn is_oauth_auth(&self) -> bool {` — the
  function this story was scoped to add **already exists in `src/` on the current
  branch.** This confirms the STORY-INDEX row (completed/merged), not the story file's
  own stale `status: ready` frontmatter.
- **This is pre-existing metadata drift on `S-384`'s own story file** (frontmatter never
  flipped to `done` after merge) — out of scope for this burst to fix (Constraints: "Do
  NOT modify existing stories"). Flagged here for whoever next touches `S-384`'s file.

**File-footprint check (for completeness, in case the drift assessment above is somehow
wrong and `S-384` is still live):** `S-384`'s File Structure Requirements name
`src/api/client.rs` (add `is_oauth_auth`), `src/error.rs`, `src/cli/issue/create.rs`,
`src/api/jsm/servicedesks.rs`, and explicitly state: "Do NOT modify `src/api/auth.rs`,
`src/api/refresh_coordinator.rs`..." — a self-imposed disjointness guard on the auth
primitives cycle-003 touches. The one file-level overlap is `src/api/client.rs`, shared
with `S-cycle3-percred-storage` (`load_auth_from_keychain`) and `S-cycle3-adr0011-newtype`
(`JiraClient::profile_name`) — but since `is_oauth_auth()` is already merged, any
cycle-003 story touching `src/api/client.rs` is editing on top of already-landed code,
not racing an in-flight PR. No rebase-churn risk remains.

**Disposition: CONFIRMED, refined.** `S-384` is de facto complete (code present on
`develop`); the manifest's "ready, not yet delivered" framing was accurate to `S-384`'s
own (stale) frontmatter but not to reality. Net effect on cycle-003: **no conflict**,
stronger than the manifest's "sequence-aware, no code overlap" framing — there is no
sequence to be aware of, because the dependency is already satisfied. The manifest's
"sequence-awareness worth a PR-description mention if S-384 lands concurrently" note is
moot (it already landed). No action needed beyond this note.

---

## 4. Item 3 — `S-MAINT-532` (global `--profile` fallback coverage, #532)

**Dispatch instruction:** record as "explicitly-deferred, non-conflicting, NOT folded
in" — this supersedes the manifest's own tentative "recommend folding into
`S-cycle3-oauth-default-creation`" suggestion (manifest §2 Story 6 Notes), which was
explicitly flagged there as "orchestrator/human should confirm this folding decision
before F4 dispatch." That confirmation has now been made, in the negative: keep
`S-MAINT-532` separate and deferred.

**Verification:**
- `story_id: "S-MAINT-532"`, `status: draft`, `target_module: cli`, `depends_on: []`,
  `blocks: []`.
- File Structure Requirements: `tests/auth_profiles.rs` only (add 3 ungated tests for
  `auth login`/`auth refresh`/`auth logout` global `--profile` fallback with an unknown
  profile name). The story's own text is explicit: **"No src/ changes. Test-only
  story."**
- Behavioral coupling (not a file conflict): the 3 new tests exercise the
  `subcmd.profile.or(cli.profile)` composition inside `src/cli/auth/{login,refresh,logout}.rs`
  — files that `S-cycle3-percred-storage` (`login.rs`), `S-cycle3-remove-logout-semantics`
  (`remove.rs`/`logout.rs`), and `S-cycle3-oauth-default-creation` (`login.rs`/`refresh.rs`)
  all modify. Because `S-MAINT-532` only *reads* current behavior via CLI invocation
  (it adds assertions in `tests/`, never edits `src/`), there is no possible
  simultaneous-write conflict — but there IS a **test-content risk**: if `S-MAINT-532`
  lands (in either order relative to cycle-003) asserting exact CLI behavior that a
  cycle-003 story later changes (e.g. `S-cycle3-oauth-default-creation`'s BC-1.1.016
  precondition-guard reordering, or `S-cycle3-remove-logout-semantics`'s non-destructive
  `logout` notice), the new assertions could go stale or fail — not a merge conflict in
  the git sense, but a same-target-behavior assumption risk.
- Per the dispatch's disposition, this risk is accepted and explicitly NOT resolved by
  folding: `S-MAINT-532` remains a fully independent, deferred draft story. Whoever
  dispatches `S-MAINT-532` in the future is responsible for re-checking its assertions
  against whatever cycle-003 has landed by then (ordinary "existing test still describes
  current behavior" hygiene — no special handling required, since `S-MAINT-532` is
  `status: draft` and has not itself been dispatched to F4).

**Disposition: CONFIRMED, refined.** No file-write conflict (test-only vs. src-only).
Recorded here as an **explicitly-deferred, non-conflicting item — deliberately NOT
folded into cycle-003's scope**, per the dispatch's binding disposition, superseding the
manifest's earlier folding recommendation. No wave-schedule action required; `S-MAINT-532`
does not appear in `wave-schedule.md`.

---

## 5. Additional Scan (not requested but performed for completeness)

A broader grep of `STORY-INDEX.md` for any other `status: ready` or `in-progress` row
naming `src/api/auth.rs`, `src/cache.rs`, `src/config.rs`, `src/cli/auth/*`, or
`src/cli/mod.rs` as a target found no further candidates beyond the three items above
(`S-384`/de facto done, `S-663-1`/done, `S-MAINT-532`/draft-deferred). No other
in-flight story in `STORY-INDEX.md` touches this file set.

---

## 6. Summary

| Item | Manifest's claim | This report's disposition |
|---|---|---|
| `S-663-1` | done, disjoint | **CONFIRMED** — no conflict (merged + file-disjoint) |
| `S-384` | ready, sequence-aware | **CONFIRMED, refined** — de facto already merged (STORY-INDEX row + `src/api/client.rs::is_oauth_auth` both confirm), stale `status: ready` frontmatter on the story file itself (out of scope to fix here); no conflict, no live sequencing concern remains |
| `S-MAINT-532` | (manifest tentatively recommended folding into `S-cycle3-oauth-default-creation`) | **RESOLVED per dispatch instruction** — recorded as explicitly-deferred, non-conflicting, NOT folded in; test-only footprint, no file-write race |

**No blocking conflict found.** Cycle-003's 7 new stories are clear to proceed per the
wave schedule in `wave-schedule.md`.
