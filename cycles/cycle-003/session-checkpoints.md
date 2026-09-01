---
document_type: session-checkpoints
level: ops
version: "1.0"
status: archive
producer: state-manager
timestamp: 2026-09-01T15:30:00Z
cycle: "cycle-003"
inputs: [STATE.md]
input-hash: "ae8ea2b"
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

<!-- Repeat for each archived checkpoint. Maintain chronological order. -->
