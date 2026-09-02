---
document_type: burst-log
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-09-01T15:30:00Z
cycle: "cycle-003"
inputs: [STATE.md]
input-hash: "e9c4050"
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

## Burst: Burst 4 — F2-gate FIX round: no-copy migration redesign + adversary pass-1/pass-2 fixes (2026-09-01)

**Parent-commit:** `87f17aff` (`develop` tip; unchanged this burst — spec-only, no `develop`-side commit).

**Trigger:** F2 quality-gate adversarial review ran two convergence passes against the Burst 3 F2-authoring-complete package. Pass-1 surfaced a CRITICAL migration-lockout finding (C-1); pass-2, run after the pass-1 fix, surfaced 2 HIGH + 3 MED seam issues (H-1/H-2/M-1/M-2/M-3) plus several LOW items. This burst records the FIX round closing all of pass-1 and pass-2's findings. Adversary pass-3 (convergence check) and the human F2 gate have NOT yet run.

**Actions taken:**
1. **REDESIGNED BC-1.4.032/033 (closes C-1, HUMAN DECISION — DEC-326):** the shared legacy `email`/`api-token` credential migration model changed from copy-then-delete to **no-copy detect-and-instruct** — `load_api_token` never reads-as-credential, copies, or deletes the legacy keys for any profile (including `default`); an absent namespaced pair produces an actionable exit-64 instructing `jr auth login <profile>`. BC-1.4.033's partial-write recovery narrowed to the namespaced-pair case only (the legacy-partial branch no longer exists — there is no copy step left to interrupt). VP-AUTHDX-005/006/007/008 oracles rewritten for the no-copy model; VP-AUTHDX-007 relabeled a mandatory keyring-gated scenario (SR-014).
2. **ADDED BC-1.1.016 (closes I-1):** airtight non-interactive OAuth guard — `auth login --oauth` and `auth refresh` against an oauth-method profile both exit 64 under any non-interactive trigger, fail-fast, never launch a browser (ADR-0020 §Decision 8).
3. **ADDED BC-1.4.034:** one-time re-login breaking-change contract formalizing BC-1.4.032's no-copy redesign, with an F4 CHANGELOG doc-fallout obligation.
4. **AMENDED BC-1.6.046/047 (adversary pass-2 H-2):** JSON-vs-human-text channel split formalized (Postcondition 2a JSON-verbatim/lossless vs 2b human-text-sanitized); terminal display-sanitization contract added for the `ENV` table cell (control-character/ANSI-escape strip + length cap).
5. **AMENDED BC-1.1.013/014 (adversary pass-2 M-1, L-2; human decision SR-010, refines DEC-313 — DEC-327):** the outgoing-mechanism credential-clear (O-1/SR-011) extended to fire identically on a non-interactive mechanism switch, not just interactive re-declaration; `JR_EMAIL`/`JR_API_TOKEN` presence is a non-interactive-ONLY trigger for suppressing the OAuth-default picker — it never overrides an interactive TTY session, which always shows the picker regardless of env vars.
6. **AMENDED BC-1.2.013/014/048/050/051, BC-1.4.031 (adversary pass-2 M-3 + F2-gate fix pass):** ordering corrections (credential-deletion before config-entry removal on `auth logout`/`auth remove`), scope narrowing (`--api-token` inert-with-notice on `refresh`), and cross-reference fixes threaded through ADR-0020 and `architecture-delta.md` in lockstep.
7. **BC-INDEX.md + CANONICAL-COUNTS.md** updated: `total_bcs` 731 → **733** (+2: BC-1.1.016, BC-1.4.034); `bc-1-auth-identity.md` 69→71 cumulative, 58→60 individually-bodied; `bc-6-config-cache.md` unaffected (44 cumulative / 34 individually-bodied). `scripts/check-bc-cumulative-counts.sh` reconfirmed green (733 total) after this burst's commit.
8. **Committed to factory-artifacts** (Single-Commit Burst Protocol, explicit paths, no `git add -A`): `specs/prd/bc-1-auth-identity.md`, `specs/prd/bc-6-config-cache.md`, `specs/prd/BC-INDEX.md`, `specs/prd/CANONICAL-COUNTS.md`, `specs/architecture/decisions/ADR-0020-...md`, `cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md`, `cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md` — commit `d9b69e61`, pushed. Pre-existing uncommitted `regression-state.json` and `sidecar-learning.md` modifications left untouched (unrelated, per standing instruction).
9. **Recorded DEC-326 and DEC-327** (resolves adversary finding M-3 — undocumented human decisions from the fix round): DEC-326 (no-copy migration, supersedes DEC-325(a)'s "additive keychain keys + lazy migration" language — the lazy-migration clause is reversed, the additive-keychain-keys part stands); DEC-327 (env-var non-interactive-only trigger, refines DEC-313). DEC-325(a) annotated SUPERSEDED in the Decisions Log (not removed).
10. STATE.md refreshed via one full-content Write (v3.33 → v3.34): `current_step`/`cycle_003_status` updated to record the FIX round complete and adversary pass-3 + human gate as NEXT; Phase Progress + Current Phase Steps rows added; Convergence Status counts updated 731→733 BCs (41 VPs, 106 holdouts unchanged); new LOW Drift/Standing item L-3 recorded (BC-1.2.017 phantom BC-1.1.017 self-citation); Session Resume Checkpoint replaced (prior v3.33 checkpoint archived to `cycles/cycle-003/session-checkpoints.md`).
11. Did NOT touch `regression-state.json` or `sidecar-learning.md`, and did NOT touch `src/` — spec-only fix round, per standing instruction.

**Adversary verdict:** Pass-1 CRITICAL (C-1 migration-lockout) — FIXED. Pass-2: 2 HIGH (H-1, H-2) + 3 MED (M-1, M-2, M-3) — all FIXED; several LOW items also addressed in the same pass (see `bc-1-auth-identity.md` frontmatter Trace history for the full itemized list). Pass-3 (convergence check) is the immediate next step.

**Outcome:** cycle-003 (`auth-profile-dx`) Phase F2 spec-evolution FIX round is COMPLETE: the no-copy migration redesign (DEC-326) closes the pass-1 CRITICAL migration-lockout; all pass-2 HIGH/MED seam issues are closed; DEC-326/327 recorded and DEC-325(a) annotated superseded. BC count 731→733, VP count unchanged at 41, holdouts unchanged at 106. Adversary pass-3 (convergence check) and the human F2 gate are NEXT.

**NEXT:** run adversary pass-3 (convergence check — confirm no new findings / novelty decayed to zero); on a clean pass, present the F2 spec-evolution package (as fixed) at the human gate. On approval, dispatch Phase F3 (incremental stories).

**Codifications:** BC-1.4.032/033's no-copy redesign is final pending F4 implementation; ADR-0020 amended in place to reflect Decision 8 (airtight non-interactive OAuth guard) and the DEC-327 env-var trigger refinement; ADR-0011 amendment (staged) unaffected by this burst.

**Closes:** adversary pass-1 finding C-1; adversary pass-2 findings H-1, H-2, M-1, M-2, M-3 (M-3 closed via this burst's DEC-326/DEC-327 recording). Does NOT close: DEC-NAMESPACE-COLLISION-RISK monitoring (still standing, re-verified clean this burst — highest allocated ID is now DEC-327), or any pre-existing cycle-002 Drift/Standing item.

### Counts reconciled this burst

- BCs: 731 → 733 (+2: BC-1.1.016, BC-1.4.034; bc-1-auth-identity.md 69→71 cumulative / 58→60 individually-bodied; bc-6-config-cache.md unchanged at 44/34).
- VPs: 41 (unchanged — VP-AUTHDX-005/006/007/008 oracles rewritten in place for the no-copy model, no VP added/removed).
- Holdout scenarios: 106 (unchanged — holdout authoring is F3's work).
- `total_stories`: unchanged at 161.
- `total_nfrs`: unchanged at 42.
- DEC IDs: 325 → 327 (DEC-326, DEC-327 newly allocated; collision-checked clean via corpus-wide grep, highest pre-existing was DEC-325).

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Commit the F2-gate FIX round deltas to factory-artifacts (explicit paths, no `git add -A`); record DEC-326/DEC-327 and annotate DEC-325(a) as superseded; record the FIX-round-complete milestone in STATE.md (frontmatter, Phase Progress + Current Phase Steps rows, Convergence Status counts, new LOW Drift/Standing item L-3, Session Resume Checkpoint); archive the prior checkpoint; verify `scripts/check-bc-cumulative-counts.sh` green at 733; commit + push to factory-artifacts | `STATE.md`; `cycles/cycle-003/burst-log.md` (this file); `cycles/cycle-003/session-checkpoints.md`; `specs/prd/bc-1-auth-identity.md`; `specs/prd/bc-6-config-cache.md`; `specs/prd/BC-INDEX.md`; `specs/prd/CANONICAL-COUNTS.md`; `specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md`; `cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md`; `cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md` |

**Files touched (Dim-1): 10 unique files this burst (7 committed to factory-artifacts as commit `d9b69e61`; STATE.md, burst-log.md, and session-checkpoints.md committed in the state-manager's own follow-on commit)**

- specs/prd/bc-1-auth-identity.md
- specs/prd/bc-6-config-cache.md
- specs/prd/BC-INDEX.md
- specs/prd/CANONICAL-COUNTS.md
- specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md
- cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md
- cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md
- STATE.md
- cycles/cycle-003/burst-log.md
- cycles/cycle-003/session-checkpoints.md

**Dim-2 Attestation:** `scripts/check-bc-cumulative-counts.sh` — PASS this burst (BC count 731→733 verified across all tracked surfaces post-commit; 0 mismatches).

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` artifact bookkeeping + spec fix round only; `src/` untouched per instruction).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression remains PASS (4660/0/106) as of the cycle-002 F7 delta-convergence pass, unchanged.

## Burst: Burst 5 — SESSION-WRAP: pass-3 propagation fixes committed, pass-4 abandoned, pipeline PAUSED (2026-09-01)

**Parent-commit:** `87f17aff` (`develop` tip; unchanged this burst — spec-only, no `develop`-side commit).

**Trigger:** human-requested `/wrap` (SESSION-WRAP) mid-session, while adversary pass-4 (the F2-gate convergence check following Burst 4's pass-1/pass-2 fixes) was in flight. The architect had already produced pass-3 fixes (BC-to-architecture-doc propagation gaps found between pass-2's fix round and pass-4) but they were sitting uncommitted in the `.factory` worktree when the wrap was requested. This burst brings the factory to a safe, resumable PAUSED stop without doing any further F2-gate work.

**Actions taken:**
1. **Verified worktree preconditions:** `.factory/.git` marker present, `git -C .factory rev-parse --git-dir` succeeds, `git -C .factory branch --show-current` == `factory-artifacts`, HEAD was `228c4905` at wrap start.
2. **Committed the architect's F2-gate pass-3 propagation fixes** (explicit paths, no `git add -A`) — commit `8fe5d78f`: `specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md`, `cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md`, `cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md`. These close pass-3's HIGH-1 (env-var trigger, DEC-327, propagated from the BCs into the architecture doc), MED-2 (newtype-scope clarifying note in the staged ADR-0011 amendment), and MED-3 ("relogin-then-replace" terminology fix, aligning prose with the DEC-326 no-copy detect-and-instruct migration model).
3. **Left `regression-state.json` and `sidecar-learning.md` untouched** — both were dirty at session start, pre-existing and unrelated to cycle-003 work; not staged, not committed, per standing instruction.
4. **ABANDONED adversary pass-4 (convergence check) mid-review** — it is READ-ONLY (produces no artifacts) and had made no persisted progress at the point of the wrap request; it must be RE-RUN in full on resume against the now fully-reconciled specs (bc-1, bc-6, ADR-0020, architecture-delta, staged ADR-0011).
5. **STATE.md refreshed via one full-content Write (v3.34 → v3.35):** `pipeline: ACTIVE` → `PAUSED`; timestamp refreshed; `current_step`/`cycle_003_status` updated to record pass-3 fixes committed + pass-4 abandoned/pending; Session Resume Checkpoint replaced (prior v3.34 checkpoint archived to `cycles/cycle-003/session-checkpoints.md`); Current Phase Steps row added for this wrap.
6. **Did NOT touch `src/`** — bookkeeping-only wrap, per standing instruction and the orchestrator's explicit constraint.

**Adversary verdict:** N/A this burst — pass-4 did not complete; no findings to report. Pass-3's own findings (HIGH-1, MED-2, MED-3) are FIXED by this burst's commit `8fe5d78f`.

**Outcome:** factory brought to a safe, resumable **PAUSED** stop. All real work (pass-3 propagation fixes) is committed and persisted on `factory-artifacts`. cycle-003 (`auth-profile-dx`) remains at Phase F2, inside the F2-gate adversarial convergence loop, one clean pass (pass-4) away from the human F2 gate.

**NEXT on resume:** re-run adversary pass-4 (convergence check) against the fully-reconciled F2-gate package; on a clean pass, present the F2 human approval gate; on approval, dispatch Phase F3 (incremental stories).

**Codifications:** none new this burst — this is a pause/bookkeeping burst, not a spec-content burst.

**Closes:** F2-gate pass-3 findings HIGH-1, MED-2, MED-3 (propagation gaps between the BC layer and the architecture docs). Does NOT close: adversary pass-4 (must be re-run from scratch on resume — it made no persisted progress), the F2 human gate (still pending), or any pre-existing Drift/Standing item.

### Counts reconciled this burst

- BCs: 733 (unchanged — pass-3 was a documentation-propagation fix, no BC content added/removed).
- VPs: 41 (unchanged).
- Holdout scenarios: 106 (unchanged).
- `total_stories`: unchanged at 161.
- `total_nfrs`: unchanged at 42.
- DEC IDs: unchanged at 327 (no new decisions this burst).

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Commit the F2-gate pass-3 propagation fixes to factory-artifacts (explicit paths, no `git add -A`); set pipeline PAUSED in STATE.md frontmatter, bump version 3.34→3.35; replace Session Resume Checkpoint (archiving v3.34 verbatim); append this Burst 5 narrative; commit + push wrap to factory-artifacts | `specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md` (commit `8fe5d78f`); `cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md` (commit `8fe5d78f`); `cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md` (commit `8fe5d78f`); `STATE.md`; `cycles/cycle-003/burst-log.md` (this file); `cycles/cycle-003/session-checkpoints.md` |

**Files touched (Dim-1): 6 unique files this burst (3 committed as `8fe5d78f`; STATE.md, burst-log.md, and session-checkpoints.md committed in the wrap commit)**

- specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md
- cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md
- cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md
- STATE.md
- cycles/cycle-003/burst-log.md
- cycles/cycle-003/session-checkpoints.md

**Dim-2 Attestation:** `scripts/check-bc-cumulative-counts.sh` — expected PASS this burst (no BC count change; re-verified as part of wrap Step 6).

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` artifact bookkeeping only; `src/` untouched per instruction).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression remains PASS (4660/0/106) as of the cycle-002 F7 delta-convergence pass, unchanged.

## Burst: Burst 6 — Adversary pass-4 (convergence check) re-run fresh, COMPLETED CLEAN — F2 delta CONVERGED (2026-09-01)

**Parent-commit:** `87f17aff` (`develop` tip; unchanged this burst — spec-only, no `develop`-side commit).

**Trigger:** the prior burst's `/wrap` left adversary pass-4 (the F2-gate convergence check) recorded as "IN-FLIGHT and ABANDONED... must be RE-RUN in full on resume." A subsequent attempt to run that re-run itself died mid-run before this burst started, persisting NOTHING — verified before starting this burst: STATE.md was still at v3.35/`pipeline: PAUSED`, with no new factory-artifacts commit since `dc1cf35b`. This burst re-runs pass-4 fresh (idempotent — not a resume of either dead attempt) against the fully-reconciled F2-gate package (bc-1, bc-6, ADR-0020, architecture-delta, adr-0011-amendment-staged, and the STATE Decisions Log DEC-312..327).

**Actions taken:**
1. **Verified worktree preconditions and prior-attempt state:** `.factory/.git` marker present, `git -C .factory rev-parse --git-dir` succeeds, `git -C .factory branch --show-current` == `factory-artifacts`; confirmed HEAD was still `dc1cf35b` and STATE.md still read v3.35/PAUSED before this burst began — the dead re-run attempt left no trace to build on.
2. **Ran adversary pass-4 (convergence check) fresh** against all six reviewed documents: `specs/prd/bc-1-auth-identity.md`, `specs/prd/bc-6-config-cache.md`, `specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md`, `cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md`, `cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md`, and STATE.md's Decisions Log entries DEC-312 through DEC-327. **Result: CLEAN — 0 CRITICAL, 0 HIGH, 0 material-MED findings.** Two LOW findings surfaced, both non-blocking:
   - **F-1 (LOW):** BC-1.2.051 Invariant 2(b) characterizes EC-1.1.013-2's clear-ordering more strongly ("once the write has a confirmed value") than EC-1.1.013-2 itself states ("before or alongside"). Wording-alignment only, no behavioral ambiguity.
   - **F-2 (LOW):** ADR-0020 §Decision 7 calls api-token `auth logout` a "no-op" without noting BC-1.2.013's F2-gate upgrade to an informational stderr notice (exit 0 unchanged). Doc-completeness only.
3. **The F2 delta has CONVERGED** — no further adversary pass is required before the human F2 approval gate. Convergence trajectory: pass-1 (major, incl. CRITICAL C-1) → pass-2 (2 HIGH + 3 MED seams) → pass-3 (1 HIGH + 2 MED BC→architecture-doc propagation gaps) → pass-4 (CLEAN).
4. **Recorded F-1 and F-2** as new LOW, non-blocking Drift/Standing Items — sweep opportunistic before/during F3, not gating.
5. STATE.md refreshed via one full-content Write (v3.35 → v3.36): `pipeline` stays `PAUSED`, `phase` stays `F2` (this burst corrects the record, it does not advance past the human gate); `current_step`/`cycle_003_status` updated to record pass-4 CLEAN / F2 CONVERGED; Phase Progress row added (F2-GATE-PASS4-CONVERGED); Current Phase Steps row added (oldest row, "BC delta landed", dropped to keep the last-5 window); Convergence Status / Concurrent Cycles / Constraints Carried Forward paragraphs updated to reflect CONVERGED status; Skip Log row for the (now-superseded) "deferred pass-4" framing removed; Session Resume Checkpoint replaced (prior v3.35 checkpoint archived to `cycles/cycle-003/session-checkpoints.md`).
6. **Did NOT touch `src/`, `regression-state.json`, or `sidecar-learning.md`** — bookkeeping-only burst, per standing instruction; the latter two are pre-existing uncommitted modifications unrelated to cycle-003 work.

**Adversary verdict:** Pass-4 (convergence check) — **CLEAN**. 0 CRITICAL/HIGH/material-MED across all six reviewed documents. 2 LOW findings (F-1, F-2), both non-blocking, recorded to Drift/Standing Items.

**Outcome:** cycle-003 (`auth-profile-dx`) Phase F2 (spec evolution) adversarial convergence loop is **CONVERGED**. BC count unchanged at 733, VP count unchanged at 41, holdouts unchanged at 106. The human F2 approval gate is now the sole remaining step before Phase F3 (incremental stories) can be dispatched. Pipeline remains **PAUSED** pending that gate.

**NEXT:** present the F2 human approval gate (spec package: BC delta, ADR-0011 amendment (staged), ADR-0020, 4-pass adversarial convergence record). On approval, dispatch Phase F3 (incremental stories) against the ~10 preliminary F3 story candidates from the F1 delta analysis. Sweep F-1/F-2 opportunistically before/during F3.

**Codifications:** none new this burst — pass-4 is read-only by design; no spec-body content changed. F-1 and F-2 are tracked as Drift/Standing Items, not yet fixed.

**Closes:** the adversary pass-4 convergence check (CLEAN) — the F2-gate adversarial convergence loop opened at Burst 3/4 is now CONVERGED. Does NOT close: the human F2 gate itself (still pending presentation), F-1/F-2 (tracked, not fixed), the staged ADR-0011 amendment (still pending F4 application), or any pre-existing Drift/Standing item.

### Counts reconciled this burst

- BCs: 733 (unchanged — pass-4 is a read-only convergence check, no BC content added/removed).
- VPs: 41 (unchanged).
- Holdout scenarios: 106 (unchanged).
- `total_stories`: unchanged at 161.
- `total_nfrs`: unchanged at 42.
- DEC IDs: unchanged at 327 (no new decisions this burst — F-1/F-2 are adversary findings, not human decisions).

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Verify worktree preconditions and confirm the prior wrap-time pass-4 attempt persisted nothing; re-run adversary pass-4 (convergence check) fresh against the six-document F2-gate package; record the CLEAN result and 2 new LOW Drift/Standing items (F-1, F-2) in STATE.md (frontmatter, Phase Progress + Current Phase Steps rows, Convergence Status/Concurrent Cycles/Constraints paragraphs, Session Resume Checkpoint); archive the prior checkpoint; verify `scripts/check-bc-cumulative-counts.sh` green at 733; commit + push to factory-artifacts | `STATE.md`; `cycles/cycle-003/burst-log.md` (this file); `cycles/cycle-003/session-checkpoints.md` |

**Files touched (Dim-1): 3 unique files this burst (all committed in the state-manager's own bookkeeping commit — no spec-body files touched, pass-4 is read-only)**

- STATE.md
- cycles/cycle-003/burst-log.md
- cycles/cycle-003/session-checkpoints.md

**Dim-2 Attestation:** `scripts/check-bc-cumulative-counts.sh` — expected PASS this burst (no BC count change; re-verified as part of this burst's close-out).

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` artifact bookkeeping only; `src/` untouched per instruction).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression remains PASS (4660/0/106) as of the cycle-002 F7 delta-convergence pass, unchanged.
