---
document_type: burst-log
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-09-01T15:30:00Z
cycle: "cycle-003"
inputs: [STATE.md]
input-hash: "ae8ea2b"
traces_to: STATE.md
---

# Burst Log — cycle-003 (auth-profile-dx)

## Burst: Burst 1 — cycle-003 OPENED (Feature Mode) — auth-profile-dx scope confirmed at architect gate (2026-09-01)

**Parent-commit:** `87f17aff` (`develop` tip; unchanged this burst — no `develop`-side commit; cycle-003 has not started implementation).

**Trigger:** human confirmed the auth-profile-dx feature bundle scope at a senior-architect gate, following grounded investigation of the existing auth/profile subsystem and modern-CLI auth/profile-design research (39 cited sources, 4 ranked decision recommendations). Opening this as cycle-003 — a new brownfield Feature Mode cycle on `jr` (jira-cli). cycle-001 (`list-read-ergonomics`) and cycle-002 (`field-dx`) remain CLOSED and historical, unaltered by this burst.

**Actions taken:**
1. STATE.md refreshed via one full-content Write (v3.30 → v3.31): frontmatter `phase` → `F1`, `pipeline` → `ACTIVE`, `current_cycle` → `"cycle-003"`, `feature_mode_bundle` → `auth-profile-dx`; `current_step` updated to describe cycle-003 OPENED, scope confirmed, F1 next. `cycle_001_status`/`cycle_002_status` preserved unchanged; added `cycle_003_status`.
2. Recorded 8 new Decisions Log entries, DEC-312 through DEC-319 (collision-checked: highest pre-existing ID was DEC-311, confirmed via corpus-wide grep — no collision): cycle-003 opened; `auth_method` as first-class intrinsic profile property; additive `env`/role tag on profile; per-profile credentials (api-token symmetric with OAuth, one-time keychain migration); API-token auth stays coequal/first-class; un-defer ADR-0011; 2LO service-account CI deferred; Device Authorization Grant rejected as design basis.
3. Added Phase Progress + Current Phase Steps rows for cycle-003 OPENED; replaced Session Resume Checkpoint (archived the prior SESSION-WRAP checkpoint to `cycles/cycle-002/session-checkpoints.md`).
4. Created cycle-003 scaffolding: this burst-log.md and `cycles/cycle-003/session-checkpoints.md`. `cycles/cycle-003/investigation/{auth-profile-current-state.md,modern-cli-auth-profile-research.md}` were already present in the worktree ahead of this burst (untracked) and are referenced from STATE.md's Historical Content table.
5. Did NOT touch `sidecar-learning.md` — a pre-existing uncommitted modification unrelated to this burst is left as-is per instruction; only cycle-003-init paths are staged explicitly for this commit.

**Adversary verdict:** N/A — bookkeeping/cycle-open burst (STATE.md + scaffolding only), no code or spec-body change; no `adversary` agent dispatched. The scope decisions this burst records were themselves reached via a human-confirmed architect gate, not an adversarial review pass.

**Outcome:** cycle-003 (`auth-profile-dx`) is OPEN, phase F1 (delta analysis) pending. No BC/VP/holdout counts changed (719/32/106) — this burst is scope-recording only, no spec authoring yet.

**NEXT:** dispatch F1 delta analysis (`/vsdd-factory:phase-f1-delta-analysis`) against the confirmed auth-profile-dx scope.

**Codifications:** none this burst — the 8 decisions are recorded in STATE.md's Decisions Log; no spec/BC/VP authored yet (that is F1/F2's work).

**Closes:** nothing. **Does NOT close:** any cycle-002 standing Drift/Standing Items — all carried forward unchanged in STATE.md.

### Counts reconciled this burst

No BCs/VPs/holdouts added or removed — 719 BCs / 32 VPs / 106 holdouts unchanged. `total_stories` unchanged at 161.

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Initialize cycle-003 in STATE.md (frontmatter, 8 Decisions Log entries DEC-312..DEC-319, Phase Progress + Current Phase Steps rows, Session Resume Checkpoint); create cycle-003 scaffolding (`burst-log.md`, `session-checkpoints.md`); archive final cycle-002 checkpoint; commit + push to factory-artifacts | `STATE.md`; `cycles/cycle-003/burst-log.md` (this file); `cycles/cycle-003/session-checkpoints.md`; `cycles/cycle-002/session-checkpoints.md` |

**Files touched (Dim-1): 4 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-003/burst-log.md
- cycles/cycle-003/session-checkpoints.md
- cycles/cycle-002/session-checkpoints.md

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` / `scripts/check-bc-cumulative-counts.sh` — N/A this burst (no BC/VP/holdout count change; bookkeeping-only cycle-open, no `.factory/specs/prd/` or `BC-INDEX.md` edits).

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` artifact bookkeeping only, no `develop`-side commit).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression remains PASS (4660/0/106) as of the cycle-002 F7 delta-convergence pass, unchanged.

## Burst: Burst 2 — F1 delta-analysis HUMAN GATE APPROVAL — cycle-003 transitions to Phase F2 (2026-09-01)

**Parent-commit:** `87f17aff` (`develop` tip; unchanged this burst — no `develop`-side commit; cycle-003 has not started implementation).

**Trigger:** the F1 delta-analysis report (`cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md`, produced by `architect`) was presented at the human gate. Human APPROVED the impact boundary and resolved all 4 open questions plus the 3 architect recommendations + deprecation-window call.

**Actions taken:**
1. STATE.md refreshed via one full-content Write (v3.31 → v3.32): frontmatter `phase` → `F2` (pipeline stays `ACTIVE`); `current_step` and `cycle_003_status` updated to record F1 APPROVED / F2 IN PROGRESS. `cycle_001_status`/`cycle_002_status` preserved unchanged.
2. Recorded 6 new Decisions Log entries, DEC-320 through DEC-325 (collision-checked: highest pre-existing ID was DEC-319, confirmed via corpus-wide grep — no collision): F1 delta-analysis APPROVED (DEC-320); refresh override removed, `auth refresh` always follows the profile's intrinsic `auth_method` (DEC-321, resolves F1 Open Question 8); `auth logout` is session-clear only / non-destructive, `auth remove` remains full-delete (DEC-322, resolves Open Question 6); explicit `--api-token` flag added to `auth login` (DEC-323, resolves Open Question 5); `env` tag surfaced as an `auth list` table column + `auth status`/JSON, BC-1.6.046 snapshot updated (DEC-324, resolves Open Question 7); accepted architect recommendations — no version bump, ADR-0011 amended in place, one combined new ADR-0020, `--oauth` deprecated indefinitely with no hard removal date (DEC-325).
3. Added Phase Progress rows for F1-DELTA-ANALYSIS (COMPLETE) and F2-SPEC-EVOLUTION (IN PROGRESS); refreshed Current Phase Steps (kept last 5, archived Burst-1 steps implicitly via this burst-log); replaced Session Resume Checkpoint (archived the prior F1-pending checkpoint, v3.31, to `cycles/cycle-003/session-checkpoints.md`).
4. Committed the F1 deliverable alongside STATE.md: `cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md` (previously untracked in the worktree, produced ahead of this burst by `architect`).
5. Did NOT touch `sidecar-learning.md` — a pre-existing uncommitted modification unrelated to this burst is left as-is per instruction; only F1-approval/F2-entry paths are staged explicitly for this commit.

**Adversary verdict:** N/A — human gate approval + bookkeeping burst (STATE.md + F1 deliverable commit only), no code or spec-body change this burst; no `adversary` agent dispatched. F2 spec-evolution work (which will carry adversarial/consistency review) has not yet been dispatched.

**Outcome:** cycle-003 (`auth-profile-dx`) F1 delta-analysis is APPROVED; Phase F2 (spec evolution) is now IN PROGRESS. No BC/VP/holdout counts changed (719/32/106) — F2 spec authoring has not yet landed any BC/VP edits.

**NEXT:** dispatch F2 spec evolution (`/vsdd-factory:phase-f2-spec-evolution`) — ADR-0011 amendment (Deferred→Accepted), new ADR-0020 authorship, BC delta (~8 amend / ~9-13 new).

**Codifications:** none this burst — the 6 decisions are recorded in STATE.md's Decisions Log; no ADR text or BC delta authored yet (that is F2's work).

**Closes:** nothing new. Resolves F1 Open Questions 5/6/7/8 (DEC-321..324) and F1 Open Questions 1/2/3 + deprecation window (DEC-325). **Does NOT close:** any cycle-002 standing Drift/Standing Items — all carried forward unchanged in STATE.md. Deferred to F2 (noted, not blocking): input-hash drift check at the F2 gate; NFR-S-B nfr-catalog vs CLAUDE.md doc-drift reconciliation.

### Counts reconciled this burst

No BCs/VPs/holdouts added or removed — 719 BCs / 32 VPs / 106 holdouts unchanged. `total_stories` unchanged at 161.

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Record F1 delta-analysis human-gate APPROVAL in STATE.md (frontmatter, 6 Decisions Log entries DEC-320..DEC-325, Phase Progress + Current Phase Steps rows, Session Resume Checkpoint); commit the F1 deliverable; archive the prior checkpoint; commit + push to factory-artifacts | `STATE.md`; `cycles/cycle-003/burst-log.md` (this file); `cycles/cycle-003/session-checkpoints.md`; `cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md` |

**Files touched (Dim-1): 4 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-003/burst-log.md
- cycles/cycle-003/session-checkpoints.md
- cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` / `scripts/check-bc-cumulative-counts.sh` — N/A this burst (no BC/VP/holdout count change; F1-gate approval + F2-entry bookkeeping only, no `.factory/specs/prd/` or `BC-INDEX.md` edits).

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` artifact bookkeeping only, no `develop`-side commit).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression remains PASS (4660/0/106) as of the cycle-002 F7 delta-convergence pass, unchanged.

## Burst: Burst 3 — F2 spec-evolution AUTHORING COMPLETE (2026-09-01)

**Parent-commit:** `87f17aff` (`develop` tip; unchanged this burst — no `develop`-side commit; cycle-003 has not started implementation).

**Trigger:** Phase F2 (spec evolution) was dispatched against the approved F1 delta-analysis and DEC-320..DEC-325. This burst records the AUTHORING-COMPLETE milestone: ADR-0011 amended, ADR-0020 authored, BC delta landed, nfr-catalog updated. F2 quality-gate checks (consistency-validator, input-hash drift, spec-reviewer, adversarial) and the human F2 gate have NOT yet run.

**Actions taken:**
1. **BC delta landed** (`specs/prd/bc-1-auth-identity.md`, `specs/prd/bc-6-config-cache.md`): +12 BCs in bc-1 (BC-1.1.013..015, BC-1.2.048..051, BC-1.4.031..033, BC-1.6.047 — per-profile API-token credential storage DEC-315, non-destructive `auth logout` + 4-step `auth remove` DEC-322, OAuth-default-at-creation DEC-313, `auth refresh` mechanism-override removal DEC-321, new `--api-token` flag + `--oauth` deprecation DEC-323, `auth list` ENV column DEC-324); +1 BC in bc-6 (BC-6.1.015 — `ProfileConfig.env: Option<String>` config-schema tag, DEC-314). BC-1.1.009/010, BC-1.2.013/014/017, BC-1.4.025/027/029, BC-1.6.046 amended in place (per-profile keychain restructuring); BC-6.2.015 amended in place (ADR-0011 hard-fence un-defer, DEC-317). Net: **719 → 731 total BCs**.
2. **VP delta landed**: 9 new verification properties, VP-AUTHDX-001..009, threaded through bc-1-auth-identity.md (VP-AUTHDX-001..008) and bc-6-config-cache.md (VP-AUTHDX-009). Net: **32 → 41 total VPs**.
3. **BC-INDEX.md + CANONICAL-COUNTS.md** updated to reflect the 719→731 BC count across all tracked surfaces (frontmatter `total_bcs`, per-file table, Sum row, grand-total prose) — `scripts/check-bc-cumulative-counts.sh` reconfirmed green (731 total across 9 files) after this burst's commit.
4. **`specs/architecture/ARCH-INDEX.md`** and **`architecture/adr-index.md`** updated with a new row for ADR-0020.
5. **New ADR authored**: `specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md` — combined ADR covering per-profile credential layout (DEC-315), `env` tag (DEC-314), and OAuth-default-at-creation (DEC-313), per DEC-325(c).
6. **ADR-0011 amended** (Deferred → Accepted, DEC-317/DEC-325(b)) — status change, Trigger-met rationale, Sequencing section binding the F4 newtype call-site sweep to land after the credential-storage/migration stories. **Routing correction this burst:** `docs/adr/0011-type-level-profile-fence.md` is a MAIN-REPO tracked file on `develop`, not a `.factory` artifact — committing the amendment directly to `develop` (bypassing PR review) or to `factory-artifacts` would violate the branch-workflow invariant and the F2/F4 artifact-boundary. The amended content is instead **STAGED** at `cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md` (committed to factory-artifacts this burst) with an explicit header marking it not-yet-applied; `develop`'s working-tree copy of `docs/adr/0011-type-level-profile-fence.md` was reverted (`git restore`) to keep `develop` clean. The F4 story `S-cycle3-adr0011-newtype` MUST apply this staged amendment to the main-repo file as part of its implementation PR.
7. **nfr-catalog.md updated**: NFR-SCA-2 routing DEFER → FIX-IN-CYCLE (design accepted via ADR-0011 amendment, DEC-317; F4 implementation pending); NFR-S-B routing SECURITY-DECIDE → RESOLVED (doc-drift fix — CLAUDE.md already documents `JR_AUTH_HEADER` as `#[cfg(debug_assertions)]`-gated per SD-002; the row's prior description was stale). Neither change adds/removes an NFR row (`total_nfrs` unchanged at 42).
8. STATE.md refreshed via one full-content Write (v3.32 → v3.33): `current_step` and `cycle_003_status` updated to record F2 authoring COMPLETE / F2 gate PENDING; Phase Progress + Current Phase Steps rows added; Convergence Status / count lines updated 719→731 BCs, 32→41 VPs (106 holdouts unchanged); new Drift/Standing item recorded for the staged ADR-0011 amendment; Session Resume Checkpoint replaced (prior v3.32 checkpoint archived to `cycles/cycle-003/session-checkpoints.md`).
9. Did NOT touch `regression-state.json` or `sidecar-learning.md` — pre-existing uncommitted modifications unrelated to this burst are left as-is per instruction.

**Adversary verdict:** N/A this burst — F2 authoring only. F2 quality-gate checks (consistency-validator, input-hash drift check, spec-reviewer second opinion, adversarial review) are the immediate next step, followed by the human F2 gate.

**Outcome:** cycle-003 (`auth-profile-dx`) Phase F2 (spec evolution) authoring is COMPLETE: BC delta (719→731), VP delta (32→41, VP-AUTHDX-001..009), ADR-0011 amended (staged for F4 application), ADR-0020 authored, nfr-catalog.md reconciled (NFR-SCA-2, NFR-S-B). F2 quality-gate checks and the human F2 gate are NEXT.

**NEXT:** run F2 quality-gate checks (consistency-validator + input-hash drift + spec-reviewer + adversarial), then present at the human F2 gate; on approval, dispatch Phase F3 (incremental stories) against the ~10 preliminary F3 stories from the F1 delta analysis.

**Codifications:** ADR-0011 amendment content is finalized but staged, not yet applied to `docs/adr/`; ADR-0020 is a new, final architecture decision record (no further staging needed — it lives entirely under `.factory/`).

**Closes:** nothing at the human-gate level yet (F2 authoring is complete, the gate itself has not run). Resolves the F2 spec-authoring obligations from DEC-317/DEC-325 (ADR-0011 amendment, new ADR-0020) and DEC-313/314/315/321/322/323/324 (BC delta encoding each decision).

### Counts reconciled this burst

- BCs: 719 → 731 (+12 in bc-1-auth-identity.md, +1 in bc-6-config-cache.md; 9 BCs amended in place with no count change).
- VPs: 32 → 41 (+9, VP-AUTHDX-001..009).
- Holdout scenarios: 106 (unchanged this burst — holdout authoring is an F3 concern, not F2).
- `total_stories`: unchanged at 161 (story decomposition is F3's work).
- `total_nfrs`: unchanged at 42 (2 rows re-routed, none added/removed).

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Correct ADR-0011 main-repo/factory-artifacts routing (stage the amendment, revert `develop`'s working tree); commit the F2 spec-evolution deltas to factory-artifacts; record F2 authoring-complete milestone in STATE.md (frontmatter, Phase Progress + Current Phase Steps rows, Convergence Status counts, Drift/Standing item, Session Resume Checkpoint); archive the prior checkpoint; commit + push to factory-artifacts | `STATE.md`; `cycles/cycle-003/burst-log.md` (this file); `cycles/cycle-003/session-checkpoints.md`; `cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md`; `specs/prd/bc-1-auth-identity.md`; `specs/prd/bc-6-config-cache.md`; `specs/prd/nfr-catalog.md`; `specs/prd/BC-INDEX.md`; `specs/prd/CANONICAL-COUNTS.md`; `specs/architecture/ARCH-INDEX.md`; `specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md`; `architecture/adr-index.md` |

**Files touched (Dim-1): 12 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-003/burst-log.md
- cycles/cycle-003/session-checkpoints.md
- cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md
- specs/prd/bc-1-auth-identity.md
- specs/prd/bc-6-config-cache.md
- specs/prd/nfr-catalog.md
- specs/prd/BC-INDEX.md
- specs/prd/CANONICAL-COUNTS.md
- specs/architecture/ARCH-INDEX.md
- specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md
- architecture/adr-index.md

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` / `scripts/check-bc-cumulative-counts.sh` — both PASS this burst (BC count 719→731 verified across all tracked surfaces post-commit; no drift detected).

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` artifact bookkeeping + spec authoring only; `docs/adr/0011-type-level-profile-fence.md` on `develop` was reverted, not committed, this burst).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression remains PASS (4660/0/106) as of the cycle-002 F7 delta-convergence pass, unchanged.
