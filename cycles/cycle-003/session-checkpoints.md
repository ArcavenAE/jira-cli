---
document_type: session-checkpoints
level: ops
version: "1.0"
status: archive
producer: state-manager
timestamp: 2026-09-01T15:30:00Z
cycle: "cycle-003"
inputs: [STATE.md]
input-hash: "a1d4693"
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

**Superseded by:** v3.35 (SESSION-WRAP / PAUSED -- F2-gate pass-3 propagation fixes committed, commit `8fe5d78f`; adversary pass-4 convergence check IN-FLIGHT and ABANDONED mid-review by a human-requested `/wrap`, must be re-run on resume; pipeline PAUSED), 2026-09-01, archived below.

---

## Session Resume Checkpoint (2026-09-01) — v3.35, SESSION-WRAP / PAUSED, adversary pass-4 IN-FLIGHT and ABANDONED (superseded — that pass-4 attempt persisted nothing)

### Spec Versions

| Artifact | Version |
|----------|---------|
| STATE.md | v3.35 |
| BC-INDEX | 733 BCs / 41 VPs / 106 holdouts (unchanged this checkpoint) |

**Date:** 2026-09-01. **Position:** cycle-003 (`auth-profile-dx`) F1 delta-analysis APPROVED, Phase F2 (spec evolution) AUTHORING COMPLETE then F2-GATE FIX ROUND COMPLETE, then adversary pass-3 (arch-doc propagation fixes) committed as `8fe5d78f`. Adversary pass-4 (convergence check) was IN-FLIGHT and ABANDONED mid-review by a human-requested `/wrap`. `develop` @ `87f17aff` (unchanged -- no code touched yet). cycle-001 and cycle-002 remain CLOSED, historical, unaltered by this burst. **Pipeline is PAUSED** by this human-requested SESSION-WRAP.

```
This burst (SESSION-WRAP): human requested `/wrap` mid-session while adversary pass-4 (the
F2-gate convergence check following Burst 4's pass-1/pass-2 fixes) was in flight. The
architect had already produced pass-3 fixes (BC-to-architecture-doc propagation gaps found
between pass-2's fix round and pass-4) but they were sitting uncommitted in the `.factory`
worktree when the wrap was requested. Committed the architect's F2-gate pass-3 propagation
fixes (explicit paths, no `git add -A`) as commit `8fe5d78f`: ADR-0020, architecture-delta.md,
adr-0011-amendment-staged.md -- closing pass-3's HIGH-1 (env-var trigger, DEC-327,
propagated into the architecture doc), MED-2 (newtype-scope clarifying note), and MED-3
("relogin-then-replace" terminology fix). ABANDONED adversary pass-4 mid-review -- it is
READ-ONLY (produces no artifacts) and had made no persisted progress at the point of the
wrap request; recorded as MUST BE RE-RUN IN FULL on resume. STATE.md refreshed via one
full-content Write (v3.34 -> v3.35): `pipeline: ACTIVE` -> `PAUSED`; timestamp refreshed;
current_step/cycle_003_status updated; Session Resume Checkpoint replaced (prior v3.34
checkpoint archived above); Current Phase Steps row added. Did NOT touch `src/`.

In-flight: adversary pass-4 (convergence check) -- ABANDONED, no persisted progress, MUST
be re-run in full on resume. The human F2 gate has NOT yet been presented. Two
pre-existing dirty files carried forward untouched: regression-state.json,
sidecar-learning.md (dirty since session start; not cycle-003 work).

NEXT on resume: re-run adversary pass-4 (convergence check) against the fully-reconciled
F2-gate package; on a clean pass, present the F2 human approval gate; on approval, dispatch
Phase F3 (incremental stories).

Resume command: /vsdd-factory:next-step.
```

**CORRECTION (recorded at v3.36, 2026-09-01):** a subsequent attempt to act on this checkpoint's "MUST BE RE-RUN IN FULL on resume" instruction itself died mid-run before producing any persisted progress -- verified at the start of the v3.36 burst: STATE.md was still exactly this v3.35 content (`pipeline: PAUSED`), with no new factory-artifacts commit since `dc1cf35b`. The v3.36 burst re-ran adversary pass-4 fresh (idempotent, not a resume of either dead attempt) and it returned **CLEAN** -- 0 CRITICAL/HIGH/material-MED across all six reviewed documents. **The F2 delta has CONVERGED** as of v3.36. This checkpoint's "IN-FLIGHT and ABANDONED... must be RE-RUN" framing is now historical only -- see the v3.36 checkpoint below for the corrected, current position.

**Superseded by:** v3.36 (adversary pass-4 re-run fresh, COMPLETED CLEAN -- F2 delta CONVERGED; pipeline remains PAUSED pending the human F2 approval gate), 2026-09-01, live in STATE.md.

---

## Session Resume Checkpoint (2026-09-01) — v3.36, F2 delta CONVERGED (pass-4 CLEAN), PAUSED pending human F2 approval gate

### Spec Versions

| Artifact | Version |
|----------|---------|
| STATE.md | v3.36 |
| BC-INDEX | 733 BCs / 41 VPs / 106 holdouts (unchanged this checkpoint) |

**Date:** 2026-09-01. **Position:** cycle-003 (`auth-profile-dx`), phase F2 -- the F2-GATE ADVERSARIAL CONVERGENCE loop has **CONVERGED** (adversary pass-4 completed CLEAN this burst); the human F2 approval gate has NOT yet been presented. `develop` @ `87f17aff` (unchanged -- no code touched yet). cycle-001 and cycle-002 remain CLOSED, historical, unaltered by this burst. **Pipeline remains PAUSED** -- this burst only corrects the record left by a prior wrap-time attempt at pass-4 that died mid-run and persisted nothing; it does not advance the pipeline past the human F2 gate.

```
Convergence trajectory (counter, CONVERGED): adversary pass-1 (major -- incl. C-1
default-only migration-lockout) -> fixed -> pass-2 (2 HIGH + 3 MED document-seam issues
H-1/H-2/M-1/M-2/M-3) -> fixed -> pass-3 (1 HIGH env-var-trigger + 2 MED
newtype-note/terminology, all BC->architecture-doc propagation gaps) -> fixed (committed
8fe5d78f) -> pass-4 (convergence check) COMPLETED CLEAN this burst: 0
CRITICAL/HIGH/material-MED across all six reviewed documents (bc-1, bc-6, ADR-0020,
architecture-delta, adr-0011-amendment-staged, STATE DEC-312..327). The F2 delta has
CONVERGED. Two LOW non-blocking residuals recorded -- F-1 (BC-1.2.051 Invariant 2(b)
characterizes EC-1.1.013-2's clear-ordering more strongly than EC-1.1.013-2 itself states;
wording alignment) and F-2 (ADR-0020 SS Decision 7 calls api-token `auth logout` a "no-op"
without noting BC-1.2.013's F2-gate upgrade to an informational stderr notice) -- see
Drift/Standing Items.

Committed spec state: unchanged from pass-3 -- bc-1 = 71 BCs (60 individually-bodied),
bc-6 = 44, grand total = 733 BCs; 41 VPs (VP-AUTHDX-001..009); 106 holdouts. BC layer
confirmed AIRTIGHT by adversary pass-3; architecture docs (ADR-0020 / architecture-delta /
staged ADR-0011) confirmed reconciled to the BCs by adversary pass-4 (CLEAN). Prior
commits: d9b69e61 (pass-1/2 fixes), 228c4905 (STATE v3.34 + DEC-326/327), 8fe5d78f (pass-3
propagation-fix commit). This burst's commit is bookkeeping-only (STATE.md/burst-log/
session-checkpoints) -- pass-4 is read-only by design and produced no spec-body changes.

Human decisions already made + recorded: DEC-326 (no-copy api-token migration; supersedes
DEC-325a) and DEC-327 (env-var non-interactive-only OAuth-picker trigger). Do NOT re-ask
these on resume.

Pending human decision: the F2 human approval gate has NOT been presented -- it is now the
immediate next step. Pass-4 CLEAN removes the last blocker; no further adversary pass is
required before presenting the gate.

Resolved this burst: the prior wrap-time adversary-pass-4 attempt (recorded at v3.35 as
"IN-FLIGHT and ABANDONED... must be RE-RUN") is superseded -- that attempt died mid-run and
persisted NOTHING (verified before this burst started: STATE.md was still v3.35/PAUSED with
no new factory-artifacts commit since dc1cf35b). This burst re-ran pass-4 fresh -- not a
resume of the dead attempt -- and it returned CLEAN. Two pre-existing dirty files remain
carried forward untouched: regression-state.json, sidecar-learning.md (dirty since session
start; not cycle-003 work).

NEXT on resume (exact): (1) F2 is CONVERGED -- a pass-4 re-run is OPTIONAL/confirmatory
only; proceed directly to present the F2 human approval gate; (2) on F2 approval -> F3 story
decomposition (10 preliminary story candidates enumerated in
cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md SS2, led by env-tag ->
per-profile-credential-storage -> no-copy-detect-and-instruct -> ADR-0011 newtype); (3)
sweep the two LOW residuals F-1/F-2 opportunistically before/during F3 -- neither blocks the
gate or F3 start. Note the F4 obligation: the staged ADR-0011 amendment
(cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md) must be applied to
docs/adr/0011-type-level-profile-fence.md by the F4 newtype story's PR.

Resume command: /vsdd-factory:next-step.
```

**RESOLVED (recorded at v3.37, 2026-09-01):** the human F2 approval gate was presented and **APPROVED** (DEC-328), directing the 4 LOW residuals (F-1, NEW-1, F-2, L-3) be swept in a dedicated burst before F3 -- all 4 were fixed in that same v3.37 burst. Pipeline transitions PAUSED -> ACTIVE, phase F2 -> F3. This checkpoint's "Pending human decision" / "NEXT on resume" framing is now historical only -- see the v3.37 checkpoint below for the corrected, current position.

**Superseded by:** v3.37 (F2 human gate APPROVED via DEC-328; all 4 LOW residuals swept; phase F2 -> F3, pipeline PAUSED -> ACTIVE), 2026-09-01, live in STATE.md.

---

## Session Resume Checkpoint (2026-09-01) — v3.37, F2 human approval gate APPROVED (DEC-328), all 4 LOW residuals swept, F2 CLOSED, phase F2 -> F3, pipeline PAUSED -> ACTIVE

### Spec Versions

| Artifact | Version |
|----------|---------|
| STATE.md | v3.37 |
| BC-INDEX | 733 BCs / 41 VPs / 106 holdouts (unchanged this checkpoint) |

**Date:** 2026-09-01. **Position:** cycle-003 (`auth-profile-dx`), the F2 human approval gate is APPROVED (DEC-328) and all 4 LOW residuals (F-1, NEW-1, F-2, L-3) are fixed. Phase is F3 (incremental stories); pipeline is ACTIVE. `develop` @ `87f17aff` (unchanged -- no code touched yet, this is spec-only bookkeeping). cycle-001 and cycle-002 remain CLOSED, historical, unaltered by this burst.

```
Convergence trajectory (counter, CONVERGED -- F2 CLOSED): adversary pass-1 (major -- incl.
C-1 default-only migration-lockout) -> fixed -> pass-2 (2 HIGH + 3 MED document-seam issues
H-1/H-2/M-1/M-2/M-3) -> fixed -> pass-3 (1 HIGH env-var-trigger + 2 MED
newtype-note/terminology, all BC->architecture-doc propagation gaps) -> fixed (committed
8fe5d78f) -> pass-4 (convergence check) COMPLETED CLEAN: 0 CRITICAL/HIGH/material-MED
across all six reviewed documents -> F2 human approval gate presented and APPROVED
(DEC-328) this burst -> all 4 LOW residuals (F-1, NEW-1, F-2, L-3) fixed this same burst.
F-1 = BC-1.2.051 Invariant 2(b) wording aligned to EC-1.1.013-2's actual "before or
alongside" characterization. NEW-1 = DEC-326 traceability citation added to
BC-1.4.032/033 Trace lines and ADR-0020 SS Decision 2. F-2 = ADR-0020 SS Decision 7 note
added (api-token `auth logout` emits an informational stderr notice per BC-1.2.013, not a
fully silent no-op). L-3 = F1-report phantom "BC-1.1.017" citation footnoted in
delta-analysis.md, input-hash refreshed 344ff59->b635a86 (also resolves the single
cycle-003 STALE drift-check hit).

Committed spec state: unchanged in count from pass-3/pass-4 -- bc-1 = 71 BCs (60
individually-bodied), bc-6 = 44, grand total = 733 BCs; 41 VPs (VP-AUTHDX-001..009); 106
holdouts. Both scripts/check-bc-cumulative-counts.sh and scripts/check-spec-counts.sh
re-verified green after this burst's residual-fix edits. Prior commits: d9b69e61
(pass-1/2 fixes), 228c4905 (STATE v3.34 + DEC-326/327), 8fe5d78f (pass-3
propagation-fix commit). This burst's commit carries both the STATE/burst-log/
session-checkpoints bookkeeping AND the 3 residual-fix spec files (bc-1, ADR-0020,
delta-analysis.md) -- the first cycle-003 commit since pass-3 to touch spec-body content.

Human decisions already made + recorded: DEC-326 (no-copy api-token migration; supersedes
DEC-325a), DEC-327 (env-var non-interactive-only OAuth-picker trigger), and DEC-328 (F2
gate APPROVED; residual-sweep-before-F3 directive). Do NOT re-ask these on resume.

Pending human decision: none for F2 -- the gate is closed. The next human-facing
checkpoint is whatever gate F3 (incremental stories) itself produces, if any.

NEXT on resume (exact): (1) dispatch Phase F3 story decomposition
(/vsdd-factory:phase-f3-incremental-stories) against the 10 preliminary story candidates
enumerated in cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md SS2 (led by
env-tag -> per-profile-credential-storage -> no-copy-detect-and-instruct -> ADR-0011
newtype); (2) note the F4 obligation carried forward: the staged ADR-0011 amendment
(cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md) must be applied
to docs/adr/0011-type-level-profile-fence.md by the F4 newtype story's PR -- this is now
the only outstanding staged-but-unapplied item from F2.

Resume command: /vsdd-factory:next-step.
```

**RESOLVED (recorded at v3.38, 2026-09-01):** Phase F3 (incremental stories) was dispatched -- MANIFEST -> CREATE -> INTEGRATE all COMPLETE this burst, producing 7 draft stories, an ACYCLIC dependency graph, a 5-wave schedule (57 pts / 39-pt critical path), and a conflict report finding zero blocking conflicts. A fresh-context consistency audit returned SOUND (3 findings, all fixed in the same burst). Pipeline stays ACTIVE; phase stays F3. This checkpoint's "NEXT on resume" framing (dispatch F3) is now historical only -- see the v3.38 checkpoint in STATE.md for the corrected, current position: the F3 human approval gate is PENDING presentation, NOT yet approved.

**Superseded by:** v3.38 (F3 story decomposition AUTHORED + INTEGRATED, fresh-context consistency audit SOUND, F3 human approval gate PENDING presentation), 2026-09-01, live in STATE.md.

---

## Checkpoint v3.38 (2026-09-01) — F3 AUTHORED + INTEGRATED, human approval gate PENDING presentation

```
Date: 2026-09-01. Position: cycle-003 (auth-profile-dx), Phase F3 (incremental
stories) is AUTHORED and VALIDATED -- 7 stories, all status: draft. The F3 human
approval gate has NOT been presented and F3 is NOT approved. develop @ 87f17aff
(unchanged -- no code touched yet, this is spec-only bookkeeping). cycle-001 and
cycle-002 remain CLOSED, historical, unaltered by this burst.

F3 story set (7 stories, 57 total pts, 5 waves):
1. S-cycle3-env-tag (Wave 1, 5 pts, no deps) -- ProfileConfig.env tag +
   auth list/auth status surfacing.
2. S-cycle3-percred-storage (Wave 1, 8 pts, no deps) -- per-profile API-token
   keychain storage (store_api_token/load_api_token).
3. S-cycle3-credential-absence-guard (Wave 2, 8 pts, P0, HIGH-risk,
   depends_on:[2]) -- no-copy detect-and-instruct guard (DEC-326 redesign);
   cycle's only MANDATORY keyring-gated VP.
4. S-cycle3-remove-logout-semantics (Wave 3, 5 pts, depends_on:[2,3]) -- auth
   remove 4-step delete reorder + non-destructive auth logout notice.
5. S-cycle3-adr0011-newtype (Wave 4, 13 pts, depends_on:[2,3,4]) --
   Profile(String) newtype, ~60-80 call sites, applies the staged ADR-0011
   amendment to docs/adr/.
6. S-cycle3-oauth-default-creation (Wave 4, 13 pts, P0, depends_on:[2,3,4]) --
   OAuth-default-at-creation picker + BC-1.1.016 airtight non-interactive guard;
   shares Wave 4 with story 5 (no dependency edge between them, recommended
   order: 5 then 6).
7. S-cycle3-chosen-flow-reconcile (Wave 5, 5 pts, terminal, depends_on:[6]) --
   removes chosen_flow_for_profile's per-command override entirely.

Critical path: percred-storage(2) -> credential-absence-guard(3) ->
remove-logout-semantics(4) -> oauth-default-creation(6) ->
chosen-flow-reconcile(7) = 5 stories / 5 waves, 39 points. env-tag(1) and
adr0011-newtype(5) are off the critical path.

Two items carried forward for the F3 human gate (NOT decided by the
orchestrator unilaterally):
- (a) S-MAINT-532 (global --profile fallback coverage, draft, test-only)
  deliberately kept OUT of cycle-003 scope -- orchestrator's conservative
  default, superseding the manifest's own tentative folding recommendation.
  Pending human ratification at the gate.
- (b) The S-cycle3-oauth-default-creation -> S-cycle3-remove-logout-semantics
  dependency edge (story 6 depends on story 4) was added by orchestrator
  decision during dispatch, not solely derived from independent story
  authoring -- shapes both the critical path and Wave 4's composition.
  Flagged for human awareness/ratification.

Convergence trajectory (counter, F2 CLOSED, F3 AUTHORED-not-approved): ... ->
F2 human approval gate presented and APPROVED (DEC-328) -> all 4 LOW residuals
(F-1, NEW-1, F-2, L-3) fixed -> F3 MANIFEST -> CREATE -> INTEGRATE all COMPLETE
this burst -> fresh-context consistency audit SOUND (F3-audit F-1 governance
fix, F-2 manifest wave-pointer fix, F-3 blocks-convention note confirmed --
all 3 fixed this same burst) -> F3 human approval gate PENDING presentation.

Committed spec state: unchanged in BC/VP/holdout count from the F2-gate-approval
burst -- bc-1 = 71 BCs (60 individually-bodied), bc-6 = 44, grand total = 733
BCs; 41 VPs (VP-AUTHDX-001..009, all 9 now assigned to a covering F3 story);
106 holdouts (master count; the 30 new wave-holdout-scenarios are cycle-003
-scoped planning artifacts, not yet merged into the master count -- that merge
is an F4/wave-gate-time activity). total_stories: 161 -> 168 (7 new draft
stories). Both scripts/check-bc-cumulative-counts.sh and
scripts/check-spec-counts.sh re-verified green after this burst.

Human decisions already made + recorded: DEC-326 (no-copy api-token migration;
supersedes DEC-325a), DEC-327 (env-var non-interactive-only OAuth-picker
trigger), and DEC-328 (F2 gate APPROVED; residual-sweep-before-F3 directive).
Do NOT re-ask these on resume.

Pending human decision: the F3 human approval gate -- the story package (7
stories + BC/VP coverage matrices, dependency graph + acyclicity proof, wave
schedule + critical path, conflict report, wave holdout scenarios) has NOT
yet been presented. At the gate, the human should also explicitly ratify or
override the two carried-forward items above (S-MAINT-532 scope exclusion;
the oauth-default-creation -> remove-logout-semantics dependency edge).

NEXT on resume (exact): (1) present the F3 human approval gate; (2) on
approval, dispatch Phase F4 (delta implementation) starting with Wave 1
(S-cycle3-env-tag + S-cycle3-percred-storage, parallel); (3) note the F4
obligation carried forward: the staged ADR-0011 amendment
(cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md) must
be applied to docs/adr/0011-type-level-profile-fence.md by
S-cycle3-adr0011-newtype's (Wave 4) implementation PR.

Resume command: /vsdd-factory:next-step.
```

**RESOLVED (recorded at v3.39, 2026-09-01):** the F3 human approval gate was presented and returned **APPROVED (DEC-329)**. All 7 stories flipped `status: draft` -> `status: ready`; both carried-forward items were ratified, not left open (the oauth-default-creation -> remove-logout-semantics dependency edge stands; S-MAINT-532 confirmed out of cycle-003 scope). Phase advances F3 -> F4; pipeline stays ACTIVE. This checkpoint's "NEXT on resume" framing (present the F3 gate) is now historical only -- see the v3.39 checkpoint in STATE.md for the corrected, current position: Phase F4 (delta implementation) is ACTIVE, Wave 1 (env-tag + percred-storage) is the next dispatch.

**Superseded by:** v3.39 (F3 human approval gate APPROVED (DEC-329), all 7 stories ready, phase F3 -> F4, F4 delta-implementation ACTIVE), 2026-09-01, live in STATE.md.

---

## Checkpoint v3.39 (2026-09-01) — F3 human gate APPROVED (DEC-329), F4 delta-implementation ACTIVE, Wave 1 dispatch pending

```
Date: 2026-09-01. Position: cycle-003 (auth-profile-dx), Phase F3 (incremental
stories) is APPROVED at the human gate (DEC-329) -- 7 stories, all
status: ready. Phase F4 (delta-implementation) is now ACTIVE. develop @
87f17aff (unchanged -- no code touched yet this burst; this is spec-only
bookkeeping recording the gate verdict + phase transition). cycle-001 and
cycle-002 remain CLOSED, historical, unaltered by this burst.

F3 story set (7 stories, ALL status: ready, 57 total pts, 5 waves):
1. S-cycle3-env-tag (Wave 1, 5 pts, no deps) -- ProfileConfig.env tag +
   auth list/auth status surfacing.
2. S-cycle3-percred-storage (Wave 1, 8 pts, no deps) -- per-profile
   API-token keychain storage (store_api_token/load_api_token).
3. S-cycle3-credential-absence-guard (Wave 2, 8 pts, P0, HIGH-risk,
   depends_on:[2]) -- no-copy detect-and-instruct guard (DEC-326
   redesign); cycle's only MANDATORY keyring-gated VP.
4. S-cycle3-remove-logout-semantics (Wave 3, 5 pts, depends_on:[2,3]) --
   auth remove 4-step delete reorder + non-destructive auth logout notice.
5. S-cycle3-adr0011-newtype (Wave 4, 13 pts, depends_on:[2,3,4]) --
   Profile(String) newtype, ~60-80 call sites, applies the staged
   ADR-0011 amendment to docs/adr/.
6. S-cycle3-oauth-default-creation (Wave 4, 13 pts, P0,
   depends_on:[2,3,4]) -- OAuth-default-at-creation picker + BC-1.1.016
   airtight non-interactive guard; shares Wave 4 with story 5 (no
   dependency edge between them, recommended order: 5 then 6).
7. S-cycle3-chosen-flow-reconcile (Wave 5, 5 pts, terminal,
   depends_on:[6]) -- removes chosen_flow_for_profile's per-command
   override entirely.

Critical path: percred-storage(2) -> credential-absence-guard(3) ->
remove-logout-semantics(4) -> oauth-default-creation(6) ->
chosen-flow-reconcile(7) = 5 stories / 5 waves, 39 points. env-tag(1) and
adr0011-newtype(5) are off the critical path.

Items ratified at the F3 human gate (no longer open, DEC-329):
- (a) S-MAINT-532 (global --profile fallback coverage, draft, test-only)
  confirmed OUT of cycle-003 scope, deferred to a future maintenance
  cycle.
- (b) The S-cycle3-oauth-default-creation -> S-cycle3-remove-logout-
  semantics dependency edge (story 6 depends on story 4) ratified --
  story 6 reuses the clear_profile_creds api-token clear-branch that
  story 4 adds. Stands as authoritative in the dependency graph and wave
  schedule.

Convergence trajectory (counter, F3 APPROVED, F4 ACTIVE): ... -> F2 human
approval gate presented and APPROVED (DEC-328) -> F3 MANIFEST -> CREATE ->
INTEGRATE all COMPLETE -> fresh-context consistency audit SOUND -> F3
human approval gate presented and APPROVED (DEC-329) -> F4
delta-implementation OPENED, Wave 1 dispatch pending.

Committed spec state: unchanged in BC/VP/holdout count from the
F3-authored burst -- bc-1 = 71 BCs (60 individually-bodied), bc-6 = 44,
grand total = 733 BCs; 41 VPs (VP-AUTHDX-001..009, all 9 now assigned to
a covering, ready F3 story); 106 holdouts (master count; the 30
wave-holdout-scenarios are cycle-003-scoped planning artifacts, not yet
merged into the master count -- that merge is an F4/wave-gate-time
activity). total_stories: unchanged at 168 (status flip only, no new
stories this burst). Both scripts/check-bc-cumulative-counts.sh and
scripts/check-spec-counts.sh re-verified green after this burst.

Human decisions already made + recorded: DEC-326 (no-copy api-token
migration; supersedes DEC-325a), DEC-327 (env-var non-interactive-only
OAuth-picker trigger), DEC-328 (F2 gate APPROVED; residual-sweep-
before-F3 directive), and DEC-329 (F3 gate APPROVED; both carried-forward
items ratified). Do NOT re-ask these on resume.

Pending human decision: none for F3 -- the gate is closed and APPROVED.
The next human-facing checkpoint is whatever gate F4 (delta
implementation) itself produces -- most likely per-story PR review/merge
decisions during Wave dispatch, and any wave-gate presented at wave
boundaries.

NEXT on resume (exact): (1) dispatch Phase F4 Wave 1 --
S-cycle3-env-tag (5 pts) + S-cycle3-percred-storage (8 pts), parallel,
via per-story TDD delivery (test-writer -> implementer -> demo-recorder
-> pr-manager -> devops-engineer); (2) on Wave 1 merge, proceed to Wave 2
(S-cycle3-credential-absence-guard, P0, HIGH-risk -- the cycle's only
MANDATORY keyring-gated VP); (3) continue through Waves 3-5 per
wave-schedule.md; (4) note the F4 obligation carried forward: the staged
ADR-0011 amendment (cycles/cycle-003/phase-f2-spec-evolution/
adr-0011-amendment-staged.md) MUST be applied to
docs/adr/0011-type-level-profile-fence.md by
S-cycle3-adr0011-newtype's (Wave 4) implementation PR -- do not let that
PR skip this step; (5) note the HIGH-risk S-cycle3-credential-absence-
guard (Wave 2) implements DEC-326's no-copy behavior -- load_api_token
must NEVER read-as-credential, copy, or delete the legacy shared
email/api-token keys for any profile, including default; an absent
namespaced pair must produce an actionable exit-64 instructing
jr auth login <profile>.

Resume command: /vsdd-factory:next-step.
```

**RESOLVED (recorded at v3.40, 2026-09-02):** Phase F4 Wave 1 story 1/2 (`S-cycle3-env-tag`) was dispatched, delivered via full per-story TDD, and squash-merged to `develop` -- PR #752, merge commit `4d0ae2d56e880a7a7645954f6da6193c5c62564e`, `develop` `87f17aff` -> `4d0ae2d5`. The human additionally authorized an auto-merge policy for cycle-003 F4 story PRs (DEC-330). Pipeline stays ACTIVE; phase stays F4. This checkpoint's "NEXT on resume" framing (dispatch Wave 1) is now historical only -- see the v3.40 checkpoint in STATE.md for the corrected, current position: Wave 1 story 2/2 (`S-cycle3-percred-storage`) is next.

**Superseded by:** v3.40 (F4 Wave 1 story 1 `S-cycle3-env-tag` delivered + merged @ `4d0ae2d5` via PR #752, DEC-330 auto-merge authorization recorded, Wave 1 story 2/2 next), 2026-09-02, live in STATE.md.

---

## Checkpoint v3.40 (2026-09-02) — F4 Wave 1 story 1 (`S-cycle3-env-tag`) MERGED, Wave 1 story 2/2 (`S-cycle3-percred-storage`) NEXT

**Date:** 2026-09-02. **Position:** cycle-003 (`auth-profile-dx`), Phase **F4 (delta implementation) ACTIVE** — Wave 1 story 1/2 (`S-cycle3-env-tag`) is **MERGED** to `develop` (PR #752 @ `4d0ae2d56e880a7a7645954f6da6193c5c62564e`, `develop` `87f17aff`→`4d0ae2d5`, 2026-09-02). Auto-merge policy **DEC-330** is in effect for cycle-003 F4 story PRs. Wave 1 story 2/2 (`S-cycle3-percred-storage`, 8 pts, HIGH-risk — adds a security review) is next; its worktree must be rebased onto the new `develop` tip before dispatch. cycle-001 and cycle-002 remain CLOSED, historical, unaltered by this burst.

**Wave 1 status: 1 of 7 cycle-003 stories now delivered/merged.** `S-cycle3-env-tag` (5 pts) full TDD delivery trail: Red Gate (`61e139eb` stubs, `f3cb9103` tests) → implementation (`40c79fb0`, `826dcf79`) → local review CHANGES-REQUESTED fixed (`6d34fe38`, `a03d5c46`, `8b65af72`, `4df5b20a`) → demos recorded (4 ACs, VHS, `cycles/cycle-003/code-delivery/S-cycle3-env-tag/demos/`) → PR #752 opened → AI review (pr-reviewer) converged after 3 cycles → CI `ci-gate` 15/15 green → squash-merged. Full regression `cargo test --lib`: **1234 passed / 0 failed / 11 ignored** (was 1203/0/11 pre-story). Worktree removed, branches deleted.

**DEC-330 (auto-merge authorization, human, 2026-09-02):** once CI `ci-gate` is green AND both the AI review (pr-reviewer) and the local code review (code-reviewer) converge, the orchestrator may squash-merge a cycle-003 F4 story PR to `develop` WITHOUT a separate per-PR human prompt — pausing only for material/escalated findings. First applied: PR #752.

**Remaining wave order (unchanged from the F3 gate, DEC-329):**
2. `S-cycle3-percred-storage` (Wave 1, 8 pts, no deps) — **NEXT.**
3. `S-cycle3-credential-absence-guard` (Wave 2, 8 pts, P0, HIGH-risk, depends_on:[2]).
4. `S-cycle3-remove-logout-semantics` (Wave 3, 5 pts, depends_on:[2,3]).
5. `S-cycle3-adr0011-newtype` (Wave 4, 13 pts, depends_on:[2,3,4]) — MUST apply the staged ADR-0011 amendment to `docs/adr/`.
6. `S-cycle3-oauth-default-creation` (Wave 4, 13 pts, P0, depends_on:[2,3,4]).
7. `S-cycle3-chosen-flow-reconcile` (Wave 5, 5 pts, terminal, depends_on:[6]).

**Critical path (unchanged):** `percred-storage`(2) → `credential-absence-guard`(3) → `remove-logout-semantics`(4) → `oauth-default-creation`(6) → `chosen-flow-reconcile`(7), 39 points.

**Convergence trajectory (counter):** ... → F3 human approval gate presented and APPROVED (DEC-329) → F4 delta-implementation OPENED → **Wave 1 story 1 (`S-cycle3-env-tag`) delivered + merged** → Wave 1 story 2 (`S-cycle3-percred-storage`) NEXT.

**Committed spec state:** unchanged in BC/VP/holdout count this burst — 733 BCs, 41 VPs, 106 holdouts (master count); `total_stories` unchanged at 168 (no story-file status change this burst — merge/delivery bookkeeping only, not a spec-authoring burst). Both count guards unaffected (no spec content touched). Prior commits: the F3-gate-approval burst commit (v3.39, DEC-329 + phase F3→F4). This burst's `.factory/` commit carries `cycles/cycle-003/phase-f4-implementation/regression-baseline.md` (F4 pre-Wave-1 regression baseline, GREEN), the `S-cycle3-env-tag` demo evidence (4 recordings + README), and STATE.md/burst-log.md/session-checkpoints.md bookkeeping — the story's `src/` changes already landed on `develop` via PR #752's own merge commit, not via this `.factory/` commit.

**Human decisions already made + recorded:** DEC-326 (no-copy api-token migration), DEC-327 (env-var non-interactive-only OAuth-picker trigger), DEC-328 (F2 gate APPROVED), DEC-329 (F3 gate APPROVED; both carried-forward items ratified), and **DEC-330** (auto-merge authorization for cycle-003 F4 story PRs). Do NOT re-ask these on resume.

**Pending human decision:** none blocking — DEC-330 covers routine story-PR merges through the remainder of Waves 1–5 unless a PR surfaces a material/escalated finding, in which case pause and ask.

**NEXT on resume (exact):** (1) rebase/refresh the `S-cycle3-percred-storage` worktree onto the new `develop` tip (`4d0ae2d5`); (2) dispatch its per-story TDD delivery (test-writer → implementer → demo-recorder → pr-manager → devops-engineer); (3) on CI green + dual-review convergence, auto-merge per DEC-330 (pause only for material/escalated findings); (4) on Wave 1 full completion (both stories merged), proceed to Wave 2 (`S-cycle3-credential-absence-guard`, P0, HIGH-risk — the cycle's only MANDATORY keyring-gated VP; HIGH-risk flag means it also gets a security review); (5) continue through Waves 3–5 per `wave-schedule.md`; (6) note the F4 obligation carried forward: the staged ADR-0011 amendment (`cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md`) MUST be applied to `docs/adr/0011-type-level-profile-fence.md` by `S-cycle3-adr0011-newtype`'s (Wave 4) implementation PR — do not let that PR skip this step; (7) note the HIGH-risk `S-cycle3-credential-absence-guard` (Wave 2) implements DEC-326's no-copy behavior — `load_api_token` must NEVER read-as-credential, copy, or delete the legacy shared `email`/`api-token` keys for any profile, including `default`; an absent namespaced pair must produce an actionable exit-64 instructing `jr auth login <profile>`.

**Resume command:** `/vsdd-factory:next-step`.

**RESOLVED (recorded at v3.41, 2026-09-02):** Phase F4 Wave 1 story 2/2 (`S-cycle3-percred-storage`) was dispatched, delivered via full per-story TDD (including a security review, HIGH-risk), and squash-merged to `develop` — PR #755, merge commit `d3ba27262be5cd26992c8ac71b2162c895cc90d0`, `develop` `4d0ae2d5` → `d3ba2726`. Wave 1 is now COMPLETE (2/2 stories merged). The Wave 1 integration gate ran and returned GREEN across all five checks. The Wave 1 adversary review returned 3 non-blocking findings (1 MED, 2 LOW), all dispositioned — see the v3.41 Drift/Standing Items in STATE.md. Pipeline stays ACTIVE; phase stays F4. This checkpoint's "NEXT on resume" framing (dispatch story 2/2) is now historical only — see the v3.41 checkpoint in STATE.md for the corrected, current position: Wave 2 (`S-cycle3-credential-absence-guard`) is next.

**Superseded by:** v3.41 (F4 Wave 1 COMPLETE — `S-cycle3-percred-storage` delivered + merged @ `d3ba2726` via PR #755, Wave 1 integration gate PASSED, adversary findings dispositioned, Wave 2 next), 2026-09-02, live in STATE.md.

---

## Checkpoint v3.41 (2026-09-02) — F4 Wave 1 COMPLETE, Wave 2 (`S-cycle3-credential-absence-guard`) NEXT

**Date:** 2026-09-02. **Position:** cycle-003 (`auth-profile-dx`), Phase **F4 (delta implementation) ACTIVE** — **Wave 1 is COMPLETE**: both stories merged to `develop` — `S-cycle3-env-tag` (PR #752 @ `4d0ae2d5`) and `S-cycle3-percred-storage` (PR #755, merge commit `d3ba27262be5cd26992c8ac71b2162c895cc90d0`, `develop` `4d0ae2d5`→`d3ba2726`, 2026-09-02). Auto-merge policy **DEC-330** was applied to both PRs. The Wave 1 integration gate ran and returned **GREEN** (`cargo build --tests`; `cargo test --lib` 1242/0/18; clippy; fmt; `JR_RUN_KEYRING_TESTS=1`-gated tests 15/0 — all clean; report at `cycles/cycle-003/phase-f4-implementation/wave-1-integration-gate.md`). The Wave 1 adversary review returned 3 findings (1 MED, 2 LOW), none blocking — verdict **SAFE TO PASS** — and all 3 are dispositioned (see below). **Wave 2 (`S-cycle3-credential-absence-guard`, 8 pts, P0, HIGH-risk — adds a security review) is next.** cycle-001 and cycle-002 remain CLOSED, historical, unaltered by this burst.

**Wave 1 adversary findings + dispositions:**
1. **MED** — `auth list` STATUS (config-only, `url.is_some()`→`configured`) vs `auth status` Credentials (keychain-probing via `load_api_token`) disagree during the migration window: a pre-cycle-003 api-token profile shows `configured` in `auth list` but `Credentials: not found` in `auth status`. **Disposition:** folded into Wave 2's `S-cycle3-credential-absence-guard` as an adversary-recommended enhancement to EVALUATE (make `auth list` STATUS credential-aware, existence-only probe, same discipline as the legacy-pair check) — story file updated with a "Wave 1 integration-gate finding (MED)" section; implement if it fits the story's existing file list, else flag as a tracked follow-up in the delivery PR rather than silently dropping it.
2. **LOW** — `auth status` (a documented read-only probe) can transitively trigger the OAuth `"default"`-profile lazy-migration WRITE via `load_oauth_tokens`. **Disposition:** pre-existing OAuth behavior, unrelated to cycle-003's per-credential redesign; tracked as standing drift, NOT folded into Wave 2.
3. **LOW [process-gap]** — `S-cycle3-percred-storage.md`'s `breaking_change` frontmatter read `false`, contradicting the story's own CHANGELOG entry (already correctly framed `BREAKING — Action required`) and the actual behavior (removing the legacy flat-key read fallback locks out every existing api-token profile, including `default`, until re-authentication). **Disposition:** corrected to `true` this burst, with a "Correction Note" section added to the story explaining the fix; `compute-input-hash --update` re-run (stored `3f4ee5d`→`f01a25d`). A systemic frontmatter-coherence guard was considered and its addition **justified-deferred** — LOW severity, one-off, non-recurring pattern, not worth a new CI check at this time.

**Wave 1 delivery summary (both stories):** `S-cycle3-env-tag` (5 pts, Burst 10) — full TDD trail, PR #752, squash-merged @ `4d0ae2d5`. `S-cycle3-percred-storage` (8 pts, HIGH-risk, Burst 11) — per-profile API-token keychain storage (BC-1.4.031), full TDD trail including a security review, PR #755 (3 review-confirmation cycles: `pr-review-cycle1.md`/`-cycle2.md`/`-cycle3.md` + final `pr-review.md`, `cycles/cycle-003/code-delivery/S-cycle3-percred-storage/`), demos at `cycles/cycle-003/code-delivery/S-cycle3-percred-storage/demos/`, squash-merged @ `d3ba2726`. Combined full regression on `develop` post-Wave-1: `cargo test --lib` **1242 passed / 0 failed / 18 ignored**.

**Remaining wave order (unchanged from the F3 gate, DEC-329):**
3. `S-cycle3-credential-absence-guard` (Wave 2, 8 pts, P0, HIGH-risk, depends_on:[2]) — **NEXT.** Implements DEC-326's no-copy detect-and-instruct contract; carries forward the Wave 1 MED finding (above) as an enhancement to evaluate.
4. `S-cycle3-remove-logout-semantics` (Wave 3, 5 pts, depends_on:[2,3]) — **MUST also clear the new per-profile `email`/`api-token` keys** that `S-cycle3-percred-storage` introduced (a deferred gap noted in that story) as part of its logout-semantics rework, not just the OAuth session tokens.
5. `S-cycle3-adr0011-newtype` (Wave 4, 13 pts, depends_on:[2,3,4]) — **MUST apply the staged ADR-0011 amendment** to `docs/adr/0011-type-level-profile-fence.md`.
6. `S-cycle3-oauth-default-creation` (Wave 4, 13 pts, P0, depends_on:[2,3,4]).
7. `S-cycle3-chosen-flow-reconcile` (Wave 5, 5 pts, terminal, depends_on:[6]).

**Critical path (unchanged):** `percred-storage`(2, MERGED) → `credential-absence-guard`(3) → `remove-logout-semantics`(4) → `oauth-default-creation`(6) → `chosen-flow-reconcile`(7), 39 points.

**Convergence trajectory (counter):** ... → F3 human approval gate APPROVED (DEC-329) → F4 delta-implementation OPENED → Wave 1 story 1 (`S-cycle3-env-tag`) delivered + merged → **Wave 1 story 2 (`S-cycle3-percred-storage`) delivered + merged, Wave 1 integration gate PASSED, adversary findings dispositioned** → Wave 2 (`S-cycle3-credential-absence-guard`) NEXT.

**Committed spec state:** unchanged in BC/VP/holdout count this burst — 733 BCs, 41 VPs, 106 holdouts (master count); `total_stories` unchanged at 168 (no story-file status change this burst — the two story-file edits are a MED-finding annotation and a `breaking_change` frontmatter correction, not new coverage). Both count guards unaffected (no spec content touched). Prior commits: the Wave-1-story-1-merged burst commit (v3.40). This burst's `.factory/` commit carries `cycles/cycle-003/phase-f4-implementation/wave-1-integration-gate.md` (Wave 1 gate report), the `S-cycle3-percred-storage` demo evidence (`cycles/cycle-003/code-delivery/S-cycle3-percred-storage/demos/`), both stories' pr-review artifacts relocated into the `cycles/cycle-003/code-delivery/<story>/` convention, the two story-file edits (MED-finding annotation + `breaking_change` correction, both with refreshed input-hash), and STATE.md/burst-log.md/session-checkpoints.md bookkeeping — the `S-cycle3-percred-storage` `src/` changes already landed on `develop` via PR #755's own merge commit, not via this `.factory/` commit.

**Human decisions already made + recorded:** DEC-326 (no-copy api-token migration), DEC-327 (env-var non-interactive-only OAuth-picker trigger), DEC-328 (F2 gate APPROVED), DEC-329 (F3 gate APPROVED; both carried-forward items ratified), and DEC-330 (auto-merge authorization for cycle-003 F4 story PRs, applied to both Wave 1 PRs). Do NOT re-ask these on resume.

**Pending human decision:** none blocking — DEC-330 covers routine story-PR merges through the remainder of Waves 2–5 unless a PR surfaces a material/escalated finding, in which case pause and ask.

**NEXT on resume (exact):** (1) stand up a worktree for `S-cycle3-credential-absence-guard` (Wave 2) rebased onto the current `develop` tip (`d3ba2726`); (2) dispatch its per-story TDD delivery (test-writer → implementer → demo-recorder → pr-manager → devops-engineer), noting the HIGH-risk flag adds a security review to the trail; (3) while scoping the story, evaluate folding in the Wave 1 MED finding (make `auth list` STATUS credential-aware) per the disposition above — implement if it fits cleanly, else flag as a tracked PR-description follow-up; (4) on CI green + dual-review convergence, auto-merge per DEC-330 (pause only for material/escalated findings); (5) on Wave 2 completion, run its own integration gate (mirror this burst's Wave 1 gate) before proceeding to Wave 3 (`S-cycle3-remove-logout-semantics` — remember it must also clear the new per-profile credential keys, not just OAuth session tokens); (6) continue through Waves 4–5 per `wave-schedule.md`, noting the two carried F4 obligations: `S-cycle3-adr0011-newtype` (Wave 4) must apply the staged ADR-0011 amendment to `docs/adr/`, and `S-cycle3-oauth-default-creation` (Wave 4) is P0.

**Resume command:** `/vsdd-factory:next-step`.

**RESOLVED (recorded at v3.42, 2026-09-02):** Phase F4 Wave 2 (`S-cycle3-credential-absence-guard`) was dispatched, delivered via full per-story TDD (including a security review, HIGH-risk), and squash-merged to `develop` — PR #756, merge commit `5c568d0fa6856d1b4606ef053d1579e3afb6fcaa`, `develop` `d3ba2726` → `5c568d0f`. Wave 2 is now COMPLETE (3/7 cycle-003 stories merged). The Wave 2 integration gate ran and returned GREEN (fmt clean locally; build/test/clippy deferred to CI, justified via PR #756's own `ci-gate` green 15/15 on the merged tree; gated keychain suite 1275/0/0). The Wave 2 adversary review returned 2 non-blocking findings (1 MED, 1 LOW), both dispositioned — the MED (CHANGELOG self-contradiction) is now a firm obligation on Wave 3's PR; the LOW (the carried-forward Wave 1 MED, `auth list`/`auth status` STATUS divergence) was evaluated, confirmed cosmetic, and remains tracked, not implemented — see the v3.42 Drift/Standing Items in STATE.md. Pipeline stays ACTIVE; phase stays F4. This checkpoint's "NEXT on resume" framing (dispatch Wave 2) is now historical only — see the v3.42 checkpoint in STATE.md for the corrected, current position: Wave 3 (`S-cycle3-remove-logout-semantics`) is next.

**Superseded by:** v3.42 (F4 Wave 2 COMPLETE — `S-cycle3-credential-absence-guard` delivered + merged @ `5c568d0f` via PR #756, Wave 2 integration gate PASSED, adversary findings dispositioned, Wave 3 next), 2026-09-02, live in STATE.md.

---

## Checkpoint v3.42 (2026-09-02) — F4 Wave 2 COMPLETE, Wave 3 (`S-cycle3-remove-logout-semantics`) NEXT

**Date:** 2026-09-02. **Position:** cycle-003 (`auth-profile-dx`), Phase **F4 (delta implementation) ACTIVE** — **Wave 2 is COMPLETE**: all three Wave 1–2 stories merged to `develop` — `S-cycle3-env-tag` (PR #752 @ `4d0ae2d5`), `S-cycle3-percred-storage` (PR #755 @ `d3ba2726`), and `S-cycle3-credential-absence-guard` (PR #756, merge commit `5c568d0fa6856d1b4606ef053d1579e3afb6fcaa`, `develop` `d3ba2726`→`5c568d0f`, 2026-09-02). Auto-merge policy **DEC-330** was applied to all three PRs. The Wave 2 integration gate ran and returned **GREEN** (`cargo fmt --all -- --check` clean locally; `cargo build --tests`/`cargo test --lib`/`cargo clippy --all-targets --all-features -- -D warnings` DEFERRED TO CI — justified because PR #756's own `ci-gate` already ran green 15/15 on this exact merged tree, and re-running them locally hit foreground timeout/lock-contention; `JR_RUN_KEYRING_TESTS=1`-gated suite **1275 passed / 0 failed / 0 ignored** per the implementer's prior verification; report at `cycles/cycle-003/phase-f4-implementation/wave-2-integration-gate.md`). The Wave 2 adversary review returned 2 findings (1 MED, 1 LOW), none blocking — verdict **SAFE TO PASS** — and both are dispositioned (see below). **Wave 3 (`S-cycle3-remove-logout-semantics`, 5 pts, `depends_on:[S-cycle3-percred-storage, S-cycle3-credential-absence-guard]`) is next**, carrying two obligations beyond its own scope. cycle-001 and cycle-002 remain CLOSED, historical, unaltered by this burst.

**Wave 2 adversary findings + dispositions:**
1. **MED** — CHANGELOG `[Unreleased]` self-contradiction: the Wave 1 (`S-cycle3-percred-storage`) entry still quotes the absent-credential failure message (`No stored API token for profile "<name>" — run "jr auth login --profile <name>"`) that Wave 2 SUPERSEDED with the BC-1.4.032 text (`No credentials stored for profile '<name>'...`) — so the shipped binary never emits the string the Wave 1 entry quotes, and both entries ship in the same release. **Disposition:** fold the CHANGELOG reconciliation into the Wave 3 (`S-cycle3-remove-logout-semantics`) PR, which touches `CHANGELOG.md` anyway for its own logout-semantics rework. **MUST be reconciled before release (F7 gate)**; does NOT gate Wave 3 dispatch.
2. **LOW** — `auth list` STATUS (config-only) vs `auth status` Credentials (keychain-probing) divergence — this is the carried-forward Wave 1 MED finding, evaluated per its own story-file disposition instruction (`S-cycle3-credential-absence-guard.md` § "Wave 1 integration-gate finding (MED)"): it does not fit cleanly within the story's existing File Structure Requirements (`src/cli/auth/list.rs` not in scope), so it was explicitly flagged as a tracked follow-up in PR #756's description rather than silently dropped. Wave 2's adversary independently re-evaluated it and downgraded/confirmed it as **COSMETIC, not a functional trap** — the recovery loop (one `jr auth login <profile>` call) closes the gap for both surfaces simultaneously, and no user is left in a state neither command can diagnose. **Disposition:** remains tracked (already recorded in STATE Drift/Standing Items and PR #756's own body), not implemented, not a cycle-003 blocker.

**Adversary also confirmed (verification, not new findings):** the migration recovery loop CLOSES (a successful `jr auth login <profile>` writes exactly the namespaced pair the loader subsequently reads — no partial-success state survives a completed login); DEC-326's no-copy invariant holds at every production call site (grep-confirmed, no `set_password`/`delete_credential` call on the legacy keys anywhere in `load_api_token`'s call graph); OAuth (`load_oauth_tokens`) is unaffected by this story's changes; and the exit-64 error surfaces cleanly with byte-exact BC text end-to-end (`main.rs` downcast → exit 64, `client.rs` hot-path propagation via `?`).

**Wave 2 delivery summary:** `S-cycle3-credential-absence-guard` (8 pts, P0, HIGH-risk) — no-copy detect-and-instruct guard for `load_api_token`'s absent-credential branch (`src/api/auth.rs`), BC-1.4.032/033/034 (new) + BC-1.4.025/029 (amended regression-confirmation), full TDD trail including a security review, PR #756 (AI review verdict APPROVE across 6 dimensions, 2 non-blocking doc-only findings folded into the disposition record — see `cycles/cycle-003/code-delivery/S-cycle3-credential-absence-guard/pr-review.md`), demos at `cycles/cycle-003/code-delivery/S-cycle3-credential-absence-guard/demos/` (CLI-level transcript + gated keyring test suite transcript covering AC-004 through AC-011 + `load_oauth_tokens` regression baseline transcript + README), squash-merged @ `5c568d0f`. Gated keychain suite (`JR_RUN_KEYRING_TESTS=1 cargo test --lib --include-ignored`): **1275 passed / 0 failed / 0 ignored**.

**Remaining wave order (unchanged from the F3 gate, DEC-329, except Wave 3's two new carried obligations):**
4. `S-cycle3-remove-logout-semantics` (Wave 3, 5 pts, `depends_on:[2,3]`) — **NEXT.** MUST clear the new per-profile `<profile>:email`/`<profile>:api-token` keys that `S-cycle3-percred-storage` introduced (a deferred gap noted in that story) as part of its logout-semantics rework, not just the OAuth session tokens; **MUST also reconcile the stale Wave-1 CHANGELOG entry** per the Wave 2 adversary MED finding.
5. `S-cycle3-adr0011-newtype` (Wave 4, 13 pts, `depends_on:[2,3,4]`) — **MUST apply the staged ADR-0011 amendment** to `docs/adr/0011-type-level-profile-fence.md`.
6. `S-cycle3-oauth-default-creation` (Wave 4, 13 pts, P0, `depends_on:[2,3,4]`).
7. `S-cycle3-chosen-flow-reconcile` (Wave 5, 5 pts, terminal, `depends_on:[6]`).

**Critical path (unchanged):** `percred-storage`(2, MERGED) → `credential-absence-guard`(3, MERGED) → `remove-logout-semantics`(4) → `oauth-default-creation`(6) → `chosen-flow-reconcile`(7), 39 points.

**Convergence trajectory (counter):** ... → F3 human approval gate APPROVED (DEC-329) → F4 delta-implementation OPENED → Wave 1 (2/2 stories) delivered + merged, integration gate PASSED → **Wave 2 (`S-cycle3-credential-absence-guard`) delivered + merged, Wave 2 integration gate PASSED, adversary findings dispositioned** → Wave 3 (`S-cycle3-remove-logout-semantics`) NEXT.

**Committed spec state:** unchanged in BC/VP/holdout count — 733 BCs, 41 VPs, 106 holdouts (master count); `total_stories` unchanged at 168. Prior commits: the Wave-1-COMPLETE burst commit (v3.41). This checkpoint's `.factory/` commit carried `cycles/cycle-003/phase-f4-implementation/wave-2-integration-gate.md` (Wave 2 gate report), the `S-cycle3-credential-absence-guard` demo evidence, the story's `pr-review.md` (relocated from the stray top-level `code-delivery/pr-review.md` scratch path), and STATE.md/burst-log.md/session-checkpoints.md bookkeeping — the `S-cycle3-credential-absence-guard` `src/` changes already landed on `develop` via PR #756's own merge commit, not via this `.factory/` commit.

**Human decisions already made + recorded:** DEC-326 (no-copy api-token migration, IMPLEMENTED), DEC-327 (env-var non-interactive-only OAuth-picker trigger), DEC-328 (F2 gate APPROVED), DEC-329 (F3 gate APPROVED; both carried-forward items ratified), and DEC-330 (auto-merge authorization for cycle-003 F4 story PRs, applied to all three Wave 1–2 PRs). Do NOT re-ask these on resume.

**Pending human decision:** none blocking — DEC-330 covers routine story-PR merges through the remainder of Waves 3–5 unless a PR surfaces a material/escalated finding, in which case pause and ask.

**NEXT on resume (exact, as recorded):** (1) stand up a worktree for `S-cycle3-remove-logout-semantics` (Wave 3) rebased onto the current `develop` tip (`5c568d0f`); (2) dispatch its per-story TDD delivery (test-writer → implementer → demo-recorder → pr-manager → devops-engineer); (3) ensure its scope covers BOTH obligations carried into it — clearing the new per-profile `<profile>:email`/`<profile>:api-token` keys on `auth remove`/`auth logout`, AND reconciling the stale Wave-1 CHANGELOG `[Unreleased]` entry as part of the same PR's `CHANGELOG.md` edit; (4) on CI green + dual-review convergence, auto-merge per DEC-330 (pause only for material/escalated findings); (5) on Wave 3 completion, run its own integration gate before proceeding to Wave 4 (`S-cycle3-adr0011-newtype` ∥ `S-cycle3-oauth-default-creation`); (6) continue through Wave 5 (`S-cycle3-chosen-flow-reconcile`) per `wave-schedule.md`, noting the still-open F4 obligation: `S-cycle3-adr0011-newtype` (Wave 4) must apply the staged ADR-0011 amendment to `docs/adr/`.

**Resume command:** `/vsdd-factory:next-step`.

**RESOLVED (recorded at v3.43, 2026-09-02):** Phase F4 Wave 3 (`S-cycle3-remove-logout-semantics`) was dispatched, delivered, and squash-merged to `develop` — PR #757, merge commit `5e9dba8a`, `develop` `5c568d0f` → `5e9dba8a`. Wave 3 is now COMPLETE (4/7 cycle-003 stories merged). PR #757 carried a HIGH security finding SEC-1, found and fixed pre-merge (`clear_profile_creds`/`clear_profile_oauth_pair` split — see the v3.43 checkpoint in STATE.md for detail). Both obligations this checkpoint's "NEXT on resume" listed for Wave 3 — per-profile credential-key clearing on `auth remove`/`auth logout`, and the CHANGELOG `[Unreleased]` reconciliation — are CLOSED, verified in `src/` and `CHANGELOG.md` respectively. DEC-331 (human, 2026-09-02) refines cycle-003's auto-merge policy to fully autonomous, superseding DEC-330's interim HIGH/CRITICAL-pause handling used on this PR. Per human request, PR #757's demo directory was deleted; an OPEN, undecided human question on demo-recording scope for the remainder of cycle-003 is tracked. This checkpoint's "NEXT on resume" framing (dispatch Wave 3) is now historical only — see the v3.43 checkpoint in STATE.md for the corrected, current position: the Wave 3 integration gate is running, Wave 4 is next.

**Superseded by:** v3.43 (F4 Wave 3 COMPLETE — `S-cycle3-remove-logout-semantics` delivered + merged @ `5e9dba8a` via PR #757, SEC-1 HIGH found+fixed pre-merge, both Wave-2-carried obligations closed, DEC-331 recorded, Wave 3 integration gate running, Wave 4 next), 2026-09-02, live in STATE.md.

---

<!-- Repeat for each archived checkpoint. Maintain chronological order. -->
