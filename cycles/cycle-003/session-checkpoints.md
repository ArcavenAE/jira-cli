---
document_type: session-checkpoints
level: ops
version: "1.0"
status: archive
producer: state-manager
timestamp: 2026-09-01T15:30:00Z
cycle: "cycle-003"
inputs: [STATE.md]
input-hash: "ce28c9c"
traces_to: STATE.md
---

# Session Checkpoints — cycle-003 (auth-profile-dx)

<!-- Archived session resume checkpoints extracted from STATE.md.
     Only the LATEST checkpoint lives in STATE.md.
     Prior checkpoints are archived here for historical reference. -->

## Session Resume Checkpoint (2026-09-01) — v3.31, cycle-003 OPEN, F1 delta-analysis NEXT

### Spec Versions

| Artifact | Version |
|----------|---------|
| STATE.md | v3.31 |
| BC-INDEX | v6.82 (719 BCs / 32 VPs / 106 holdouts, unchanged) |

### State

| Field | Value |
|-------|-------|
| **Date** | 2026-09-01 |
| **Position** | cycle-003 (`auth-profile-dx`) OPEN, Phase F1 (delta analysis) NEXT. `develop` @ `87f17aff` (unchanged -- no code touched yet). cycle-001 and cycle-002 remain CLOSED, historical. |
| **Convergence counter** | N/A (cycle-open step, pre-convergence-loop) |
| **Next step** | dispatch Phase F1 delta analysis (`/vsdd-factory:phase-f1-delta-analysis`) against the confirmed `auth-profile-dx` scope (DEC-312..DEC-319), using the two cycle-003 investigation artifacts as grounding input. |

### Resume Prompt

```
This burst (cycle-003 OPEN): opened a new brownfield Feature Mode cycle following a
senior-architect scope gate. Grounding was produced ahead of this burst:
cycles/cycle-003/investigation/auth-profile-current-state.md (current-state map of the
existing src/api/auth.rs/src/config.rs/keychain layout) and
cycles/cycle-003/investigation/modern-cli-auth-profile-research.md (modern-CLI
auth/profile-design research, 39 cited sources, 4 ranked decision recommendations). The
human confirmed 8 scope decisions at the gate, recorded this burst as DEC-312 through
DEC-319 (collision-checked clean against the DEC-311 ceiling): cycle-003 opened;
auth_method as first-class intrinsic profile property (OAuth-default at creation, no
per-command switch, non-interactive CI stays token-first); additive env/role profile tag;
per-profile credentials (api-token symmetric with OAuth, one-time keychain migration of
the shared email/api-token keys into default); API-token auth stays coequal/first-class;
ADR-0011 (Profile newtype hard-fence) un-deferred; 2LO service-account CI deferred to a
future cycle; Device Authorization Grant rejected as a design basis. STATE.md refreshed
via one full-content Write (v3.30 -> v3.31): phase F7 -> F1, pipeline IDLE -> ACTIVE,
current_cycle cycle-002 -> cycle-003, feature_mode_bundle field-dx -> auth-profile-dx.
Prior SESSION-WRAP checkpoint (v3.30) archived to
cycles/cycle-002/session-checkpoints.md. cycle-003 scaffolding created:
cycles/cycle-003/{burst-log.md,session-checkpoints.md}. Burst narrative:
cycles/cycle-003/burst-log.md Burst 1.

In-flight: NONE beyond this bookkeeping burst -- no open worktrees, no pending PRs, no
open convergence loop, no code changed. F1 delta analysis has not yet been dispatched.

Constraints to carry into F1/F2: ADR-0006 (embedded OAuth, fixed port 53682), ADR-0013
(PKCE deferral), SD-002 debug-only release gates, single-use refresh tokens +
refresh_coordinator.rs single-flight, Windows Credential Manager posture, and the
shared-vs-per-profile keychain invariant under deliberate restructuring (DEC-315) --
migration discipline mandatory. Full detail:
cycles/cycle-003/investigation/auth-profile-current-state.md.

cycle-002 final state (unchanged, historical): RELEASED as v0.7.0-dev.3 (PR #751 @
87f17aff, tag pushed, release.yml run 33459579699). Counts: 719 total BCs (BC-INDEX
v6.82), 32 VPs, 106 holdout scenarios -- unchanged this burst.
```

**Superseded by:** v3.32 (F1 delta-analysis APPROVED / F2 spec-evolution IN PROGRESS), 2026-09-01, live in STATE.md.

---

## Session Resume Checkpoint (2026-09-01) — v3.32, cycle-003 F1 APPROVED, F2 spec evolution IN PROGRESS

### Spec Versions

| Artifact | Version |
|----------|---------|
| STATE.md | v3.32 |
| BC-INDEX | v6.82 (719 BCs / 32 VPs / 106 holdouts, unchanged this checkpoint) |

### State

| Field | Value |
|-------|-------|
| **Date** | 2026-09-01 |
| **Position** | cycle-003 (`auth-profile-dx`) F1 delta-analysis **APPROVED** at the human gate, Phase **F2 (spec evolution) IN PROGRESS**. `develop` @ `87f17aff` (unchanged -- no code touched yet). cycle-001 and cycle-002 remain CLOSED, historical. |
| **Convergence counter** | N/A (F1 gate, pre-convergence-loop; convergence applies from F4 onward) |
| **Next step** | dispatch Phase F2 spec evolution (`/vsdd-factory:phase-f2-spec-evolution`) against the approved F1 delta-analysis and the 6 gate-resolution decisions (DEC-320..DEC-325): amend ADR-0011 (Deferred->Accepted), author new ADR-0020, write the BC delta (~8 amend / ~9-13 new). |

### Resume Prompt

```
This burst (cycle-003 F1-gate APPROVED / F2 entry): the F1 delta-analysis report
(cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md) was presented at the human
gate and APPROVED: impact boundary accepted (~8 BCs amend, ~9-13 new BCs, ADR-0011
amendment + one new ADR, 10 preliminary F3 stories, HIGH-risk shared->per-profile
credential migration). All 4 F1 open questions were resolved at the gate, recorded this
burst as DEC-320 through DEC-325: F1 APPROVED (DEC-320); refresh override removed --
auth refresh always follows the profile's intrinsic auth_method, no per-call --oauth
override (DEC-321, resolves Open Question 8); auth logout is session-clear only and
non-destructive, preserving profile config + non-session identity, auth remove remains
full-delete (DEC-322, resolves Open Question 6); explicit --api-token flag added to auth
login, symmetric with the now-deprecated --oauth (DEC-323, resolves Open Question 5); env
tag surfaced as an auth list table column plus auth status/JSON, pinned BC-1.6.046
snapshot updated (DEC-324, resolves Open Question 7); accepted architect recommendations
-- no version bump, ADR-0011 amended in place (not superseded), one combined new ADR-0020
(per-profile credential layout + env tag + OAuth-default-at-creation), --oauth deprecated
indefinitely with no hard removal date (DEC-325). STATE.md refreshed via one full-content
Write (v3.31 -> v3.32): phase F1 -> F2; current_step and cycle_003_status updated to
reflect F1 APPROVED / F2 IN PROGRESS. Prior F1-pending checkpoint (v3.31) archived above.
Burst narrative: cycles/cycle-003/burst-log.md Burst 2.

In-flight: Phase F2 (spec evolution) is now open but not yet dispatched/executed -- no
ADR-0011 amendment text, no ADR-0020 file, no BC delta written yet. No open worktrees, no
pending PRs, no open convergence loop, no code changed.

Constraints to carry into F2: ADR-0006 (embedded OAuth, fixed port 53682), ADR-0013 (PKCE
deferral), SD-002 debug-only release gates, single-use refresh tokens +
refresh_coordinator.rs single-flight, Windows Credential Manager posture, and the
shared-vs-per-profile keychain invariant under deliberate restructuring (DEC-315) --
migration discipline mandatory. Refresh override removed (DEC-321). Full detail:
cycles/cycle-003/investigation/auth-profile-current-state.md,
cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md.

Deferred to F2 (noted, not blocking): input-hash drift check runs at the F2 gate (F1
wrote no new specs; only the known ~142-item accepted standing drift exists). NFR-S-B
nfr-catalog vs CLAUDE.md doc-drift to be reconciled during F2.

cycle-002 final state (unchanged, historical): RELEASED as v0.7.0-dev.3 (PR #751 @
87f17aff, tag pushed, release.yml run 33459579699). Counts: 719 total BCs (BC-INDEX
v6.82), 32 VPs, 106 holdout scenarios -- unchanged this checkpoint.
```

**Superseded by:** v3.33 (F2 spec-evolution authoring COMPLETE; F2 quality-gate checks NEXT), 2026-09-01, live in STATE.md.

---

## Session Resume Checkpoint (2026-09-01) — v3.33, cycle-003 F2 spec-evolution AUTHORING COMPLETE, F2 GATE PENDING

### Spec Versions

| Artifact | Version |
|----------|---------|
| STATE.md | v3.33 |
| BC-INDEX | 731 BCs / 41 VPs / 106 holdouts (719->731 this checkpoint) |

**Date:** 2026-09-01. **Position:** cycle-003 (`auth-profile-dx`) F1 delta-analysis APPROVED, Phase F2 (spec evolution) AUTHORING COMPLETE, F2 GATE PENDING. `develop` @ `87f17aff` (unchanged -- no code touched yet; the `docs/adr/0011-type-level-profile-fence.md` amendment in `develop`'s working tree was reverted, not committed, this burst). cycle-001 and cycle-002 remain CLOSED, historical, unaltered by this burst.

```
This burst (cycle-003 F2 authoring complete): the F2 spec-evolution deliverables landed:
BC delta (specs/prd/bc-1-auth-identity.md +12, specs/prd/bc-6-config-cache.md +1, 9 BCs
amended in place; 719->731 total, BC-INDEX.md/CANONICAL-COUNTS.md updated,
scripts/check-bc-cumulative-counts.sh green); VP delta (VP-AUTHDX-001..009, 32->41
total); ADR-0011 amended in place (Status Deferred->Accepted, DEC-317/DEC-325b) with
content STAGED at cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md
rather than applied to the main-repo docs/adr/ file (routing correction); new ADR-0020
authored (specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-
tagging-and-oauth-default-at-creation.md, DEC-325c); nfr-catalog.md reconciled
(NFR-SCA-2 DEFER->FIX-IN-CYCLE, NFR-S-B SECURITY-DECIDE->RESOLVED doc-drift fix;
total_nfrs unchanged at 42); specs/architecture/ARCH-INDEX.md and architecture/adr-
index.md updated with the ADR-0020 row. STATE.md refreshed via one full-content Write
(v3.32 -> v3.33): current_step/cycle_003_status updated to F2 AUTHORING COMPLETE / F2
GATE PENDING; Convergence Status counts updated (731 BCs / 41 VPs / 106 holdouts).
Prior F2-in-progress checkpoint (v3.32) archived above. Burst narrative:
cycles/cycle-003/burst-log.md Burst 3.

In-flight: F2 quality-gate checks (consistency-validator, input-hash drift check,
spec-reviewer second opinion, adversarial review) have NOT yet run; the human F2 gate
has NOT yet been presented. No open worktrees, no pending PRs, no open convergence
loop, no code changed. docs/adr/0011-type-level-profile-fence.md on develop is clean
(amendment staged, not applied) pending the F4 implementation PR.

Constraints to carry into the F2 gate and F3: ADR-0006 (embedded OAuth, fixed port
53682), ADR-0013 (PKCE deferral), SD-002 debug-only release gates, single-use refresh
tokens + refresh_coordinator.rs single-flight, Windows Credential Manager posture, and
the shared-vs-per-profile keychain invariant under deliberate restructuring (DEC-315) --
migration discipline mandatory. Refresh override removed (DEC-321). ADR-0011 amendment
is STAGED, not applied -- the F4 story S-cycle3-adr0011-newtype must apply it. Full
detail: cycles/cycle-003/investigation/auth-profile-current-state.md,
cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md,
cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md.

cycle-002 final state (unchanged, historical): RELEASED as v0.7.0-dev.3 (PR #751 @
87f17aff, tag pushed, release.yml run 33459579699).
```

**Superseded by:** v3.34 (cycle-003 F2-gate FIX round COMPLETE — adversary pass-1/pass-2 fixes, DEC-326/DEC-327 recorded; adversary pass-3 + human F2 gate PENDING), 2026-09-01, live in STATE.md.

---

## Session Resume Checkpoint (2026-09-01) — v3.34, cycle-003 F2-gate FIX round COMPLETE, adversary pass-3 + F2 GATE PENDING

### Spec Versions

| Artifact | Version |
|----------|---------|
| STATE.md | v3.34 |
| BC-INDEX | 733 BCs / 41 VPs / 106 holdouts (731->733 this checkpoint) |

**Date:** 2026-09-01. **Position:** cycle-003 (`auth-profile-dx`) F1 delta-analysis APPROVED, Phase F2 (spec evolution) AUTHORING COMPLETE then **F2-GATE FIX ROUND COMPLETE**, adversary pass-3 + F2 GATE PENDING. `develop` @ `87f17aff` (unchanged -- no code touched yet). cycle-001 and cycle-002 remain CLOSED, historical, unaltered by this burst.

```
This burst (cycle-003 F2-gate fix round complete): the F2 quality-gate adversarial review
ran two convergence passes against the Burst-3 F2-authoring package. Pass-1 surfaced a
CRITICAL migration-lockout finding (C-1), closed by a HUMAN-decided no-copy
detect-and-instruct redesign of the shared legacy email/api-token migration (DEC-326,
supersedes DEC-325(a)'s lazy-migration clause) -- load_api_token never
reads-as-credential/copies/deletes legacy keys for any profile; an absent namespaced pair
exits 64 instructing `jr auth login <profile>`. Pass-2 (run after the pass-1 fix) surfaced
2 HIGH + 3 MED seam issues (H-1/H-2/M-1/M-2/M-3), all fixed: BC-1.1.016 added (airtight
non-interactive OAuth guard, closes I-1); BC-1.4.034 added (one-time re-login
breaking-change contract); BC-1.6.046/047 amended (JSON-vs-human-text channel split,
H-2); BC-1.1.013/014 amended (env-var non-interactive-only trigger for the OAuth-default
picker, DEC-327, refines DEC-313, M-1/L-2); BC-1.2.013/014/048/050/051 and BC-1.4.031
amended (ordering/scope/cross-ref fixes, M-3 + fix-pass). BC-INDEX.md/CANONICAL-COUNTS.md
updated to 733 total BCs (731->733, +2); scripts/check-bc-cumulative-counts.sh green.
Spec files (bc-1-auth-identity.md, bc-6-config-cache.md, BC-INDEX.md, CANONICAL-COUNTS.md,
ADR-0020, architecture-delta.md, adr-0011-amendment-staged.md) were already committed to
factory-artifacts as d9b69e61 by a prior burst attempt that died mid-run (transient
transport error) -- NOT re-committed here. DEC-326 and DEC-327 recorded in the Decisions
Log (resolving adversary finding M-3, undocumented human decisions); DEC-325(a) annotated
SUPERSEDED in place (not removed). STATE.md refreshed via one full-content Write (v3.33 ->
v3.34): current_step/cycle_003_status updated; Phase Progress + Current Phase Steps rows
added for the fix round; Convergence Status counts updated (733 BCs / 41 VPs / 106
holdouts); new LOW Drift/Standing item L-3 recorded. Prior F2-AUTHORING-COMPLETE
checkpoint (v3.33) archived to cycles/cycle-003/session-checkpoints.md. Burst narrative:
cycles/cycle-003/burst-log.md Burst 4.

In-flight: adversary pass-3 (convergence check, confirming novelty decayed to zero on the
fixed package) has NOT yet run; the human F2 gate has NOT yet been presented. No open
worktrees, no pending PRs, no open convergence loop, no code changed.
docs/adr/0011-type-level-profile-fence.md on develop is clean (amendment staged, not
applied) pending the F4 implementation PR.

Constraints to carry into the F2 gate and F3: ADR-0006 (embedded OAuth, fixed port
53682), ADR-0013 (PKCE deferral), SD-002 debug-only release gates, single-use refresh
tokens + refresh_coordinator.rs single-flight, Windows Credential Manager posture, and
the shared-vs-per-profile keychain invariant under deliberate restructuring (DEC-315),
migration mechanism finalized as no-copy detect-and-instruct (DEC-326). Refresh override
removed (DEC-321). ADR-0011 amendment is STAGED, not applied -- the F4 story
S-cycle3-adr0011-newtype must apply it. Full detail:
cycles/cycle-003/investigation/auth-profile-current-state.md,
cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md,
cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md.

cycle-002 final state (unchanged, historical): RELEASED as v0.7.0-dev.3 (PR #751 @
87f17aff, tag pushed, release.yml run 33459579699).

NEXT on resume: run adversary pass-3 (convergence check) against the fixed F2
spec-evolution package; on a clean pass (novelty decayed to zero), present the package at
the human F2 gate. On approval, dispatch Phase F3 (incremental stories) against the ~10
preliminary F3 stories from the F1 delta analysis.

Resume command: /vsdd-factory:next-step -- reports adversary pass-3 as the next step --
or run the F2 quality-gate adversarial review directly.

Superseded checkpoints (as recorded at v3.34): the prior F2-AUTHORING-COMPLETE checkpoint
(v3.33, 2026-09-01) is superseded in place by this burst's FIX-ROUND-COMPLETE position
above and archived to cycles/cycle-003/session-checkpoints.md, alongside the F1-pending
checkpoint (v3.31) and F2-in-progress checkpoint (v3.32). Earlier archives
(RELEASED/SHIPPED v3.29, F7-PASS/AWAITING-GATE v3.27, F6-COMPLETE v3.26, F5-COMPLETE
v3.25, F4-COMPLETE v3.24, WRAP-F4-WAVE2-COMPLETE-PAUSE v3.23, and the SESSION-WRAP
checkpoint) remain at cycles/cycle-002/session-checkpoints.md. The list-read-ergonomics
cycle-001 CLOSED-position checkpoint (v3.05) remains archived at
cycles/cycle-001/session-checkpoints.md.
```

**Superseded by:** v3.35 (SESSION-WRAP / PAUSED -- F2-gate pass-3 propagation fixes committed, commit `8fe5d78f`; adversary pass-4 convergence check IN-FLIGHT and ABANDONED mid-review by a human-requested `/wrap`, must be re-run on resume; pipeline PAUSED), 2026-09-01, live in STATE.md.

---

<!-- Repeat for each archived checkpoint. Maintain chronological order. -->
