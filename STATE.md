---
document_type: pipeline-state
level: ops
version: "3.32"
status: active
producer: state-manager
timestamp: 2026-09-01T19:20:00Z
phase: F2
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-453 latest brownfield (unchanged). trajectory-tail →1→3→0→2 (unchanged). cycle-003 auth-profile-dx F1 delta-analysis APPROVED at human gate (all 4 open questions resolved). Phase F2 (spec evolution: ADR-0011 amend, ADR-0020 author, BC delta) IN PROGRESS."
trajectory_tail: "→1→3→0→2"
maintenance_run:
  status: COMPLETE
  date: 2026-08-25
  findings_count: 10
  fixes_applied: 6
  fixes_pending: 4
  pr: 737
current_cycle: "cycle-003"
feature_mode_bundle: auth-profile-dx
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: SOH-ATTACHMENTS-1 F5 SCOPED ADVERSARIAL CONVERGED 2026-07-24 STRICT (14 rounds; window pass-12/pass-13/pass-14 CLEANx3; spec v1.3.99 to v1.3.106; BC-INDEX v6.38 to v6.44; develop @ db207b81) + F7 DELTA CONVERGENCE APPROVED 2026-07-25 (DEC-186; 5-dim PASS; MAXIMUM_VIABLE_REFINEMENT_REACHED) + CYCLE FULLY CLOSED 2026-07-25
cycle_001_status: "list-read-ergonomics -- CLOSED (DEC-309), historical; see cycles/cycle-001/"
cycle_002_status: "field-dx -- CLOSED + RELEASED 2026-09-01 (DEC-311 close; v0.7.0-dev.3 tagged @ 87f17aff, release.yml run 33459579699 triggered). All 5 stories delivered/merged (F4); F5 CONVERGED (FIX-F5-001, PR #747); F6 COMPLETE (FIX-F6-001, PR #749); F7 COMPLETE (5-dim convergence PASS + full regression PASS 4660/0/106, FIX-F7-001, PR #750 @ 2000c455); RELEASED (version bump PR #751 @ 87f17aff, tag v0.7.0-dev.3 pushed, release.yml triggered). Pipeline SHIPPED. Session wrapped 2026-09-01."
cycle_003_status: "auth-profile-dx -- OPEN (feature mode). Phase F1 delta-analysis APPROVED at human gate 2026-09-01 (impact boundary: ~8 BCs amend, ~9-13 new BCs, ADR-0011 amendment + new ADR-0020, 10 preliminary F3 stories, HIGH-risk shared->per-profile credential migration). Phase F2 (spec evolution) IN PROGRESS."
activation_head: "87f17aff"
activation_version: "v0.7.0-dev.3"
---

<!-- STATE.md SIZE BUDGET (2026-09-01, cycle-003-f1-gate burst):
     214 lines (wc-l). soft-target 200; hard cap 500.
     margin from soft-target = 214 - 200 = 14 -- 14 lines OVER the soft target of 200.
     margin from actual (hard cap) = 500 - 214 = 286 lines of headroom remain before the hard cap of 500.
     This burst records the F1 delta-analysis HUMAN GATE APPROVAL for cycle-003
     (auth-profile-dx) and transitions the pipeline to phase F2 (spec evolution).
     Frontmatter: version 3.31->3.32, phase F1->F2, timestamp refreshed,
     current_step + cycle_003_status updated to reflect F1 APPROVED / F2 IN
     PROGRESS. pipeline stays ACTIVE. cycle_001_status/cycle_002_status
     preserved verbatim, unaltered. 6 new Decisions Log rows (DEC-320..DEC-325,
     collision-checked against the DEC-319 ceiling -- corpus-wide grep confirmed
     no collision, closing this instance of the standing
     DEC-NAMESPACE-COLLISION-RISK check). Session Resume Checkpoint replaced;
     the prior F1-pending checkpoint (v3.31) is archived to
     cycles/cycle-003/session-checkpoints.md. Burst narrative:
     cycles/cycle-003/burst-log.md Burst 2. F1 deliverable
     (cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md) committed
     this burst alongside STATE.md. No BC/VP/holdout counts changed yet
     (719/32/106) -- F2 (spec authoring) has not yet landed any BC/VP edits.
     One full-content Write, no Edit chain (DEC-247). A pre-existing
     uncommitted `sidecar-learning.md` modification in the worktree is left
     untouched -- not staged, not committed, per standing instruction. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →1→3→0→2 (unchanged this burst) |
| **Last Updated** | cycle-003 F1 APPROVED (2026-09-01): trajectory-tail →1→3→0→2 (unchanged). F1 delta-analysis for `auth-profile-dx` approved at the human gate (all 4 open questions resolved: refresh override removed, `auth logout` scoped to session-clear, explicit `--api-token` flag added, `env` tag surfaced in `auth list`). Phase F2 (spec evolution) now IN PROGRESS. |
| **Current Phase** | Feature Mode cycle-003 (`auth-profile-dx`) -- **F2 spec evolution IN PROGRESS** (ADR-0011 amend, ADR-0020 author, BC delta). cycle-001 and cycle-002 remain CLOSED, historical. |
| **Activation HEAD** | 87f17aff (`develop` tip; unchanged this burst -- no `develop`-side commit yet in cycle-003) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, cycles/cycle-003/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| CYCLE-003-OPENED | COMPLETE | 2026-09-01 | Human scope confirmation at senior-architect gate | `auth-profile-dx` feature bundle scope confirmed. 8 decisions recorded (DEC-312..DEC-319). | N/A (cycle-open step) |
| F1-DELTA-ANALYSIS (cycle-003) | **COMPLETE (this burst)** | 2026-09-01 | Human gate — F1 delta-analysis APPROVED | Impact boundary accepted: ~8 BCs amend, ~9-13 new BCs, ADR-0011 amendment + new ADR-0020, 10 preliminary F3 stories, HIGH-risk shared->per-profile credential migration. 4 open questions resolved (DEC-320..DEC-325). Report: `cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md`. | N/A (gate, not adversary-scored) |
| F2-SPEC-EVOLUTION (cycle-003) | **IN PROGRESS (started this burst)** | -- | Pending (spec-evolution completion + F2 gate) | ADR-0011 amendment (Deferred->Accepted), new ADR-0020 authorship, BC delta (~8 amend / ~9-13 new). Deferred items: input-hash drift check runs at the F2 gate; NFR-S-B doc-drift to reconcile during F2. | N/A |

## Current Phase Steps (cycle-003, F1-gate + F2-entry burst; last 5)

| Step | Status | Notes |
|------|--------|-------|
| F1 delta-analysis report produced | DONE (pre-burst) | `cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md` -- impact boundary, affected specs/stories/tests, regression risk. |
| F1 delta-analysis APPROVED at human gate | **DONE** | Human approved the impact boundary and resolved all 4 open questions (F1 Open Questions 5/6/7/8) plus the 3 architect recommendations (F1 Open Questions 1/2/3) + deprecation-window call. Made By: human. |
| DEC-320..DEC-325 recorded | **DONE** | 6 F1-gate resolution decisions (Decisions Log below). Collision-checked against DEC-319 ceiling -- clean. |
| STATE.md F1-approval / F2-entry transition | **DONE** | `phase` set `F2`; version bumped v3.31 → v3.32; new Session Resume Checkpoint written; prior F1-pending checkpoint archived. |
| Phase F2 (spec evolution) dispatch | **NEXT** | `/vsdd-factory:phase-f2-spec-evolution` -- ADR-0011 amend, ADR-0020 author, BC delta (~8 amend / ~9-13 new). |

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-325 | Accepted architect recommendations for cycle-003 F1 (Open Questions 1/2/3 + deprecation window): (a) NO version bump -- per-profile `<profile>:email`/`<profile>:api-token` are additive keychain keys + lazy migration, keychain stays profile-prefixed (no `v2` marker), no cache-root bump; (b) ADR-0011 un-deferred via IN-PLACE amendment (Deferred->Accepted), not supersession; (c) ONE combined new ADR (target ADR-0020, collision-checked clean) covering per-profile credential layout + `env` tag + OAuth-default-at-creation; (d) `--oauth` kept accepted indefinitely, marked deprecated, no hard removal date -- removal left to a future cycle | Matches human's caution on breaking changes; avoids an unforced cache/keychain version bump; consolidates related spec work into one ADR rather than three | F1 | 2026-09-01 | human (at F1 gate) |
| DEC-324 | `env` tag (prod/sandbox/uat) surfaced as an `auth list` table column | Resolves F1 Open Question 7; the tag exists on the profile (DEC-314) but was not yet visible in any command output. Appears in the human table plus `auth status` and JSON. The pinned BC-1.6.046 4-column insta-snapshot is updated to accommodate it (documented, routine output change) | F1 | 2026-09-01 | human (at F1 gate) |
| DEC-323 | Explicit `--api-token` flag added to `auth login`, symmetric with the now-deprecated `--oauth` alias | Resolves F1 Open Question 5; gives non-interactive mechanism declaration and lets an existing profile's mechanism be re-declared explicitly, without relying on `--oauth`'s absence as the implicit signal | F1 | 2026-09-01 | human (at F1 gate) |
| DEC-322 | `auth logout` is session-clear only, NON-DESTRUCTIVE: for an OAuth profile, `logout` clears ONLY the OAuth session tokens (`<profile>:oauth-access-token`/`-refresh-token`) and PRESERVES the profile config entry and all non-session identity (url, cloud_id, env, any stored email), so re-login requires no re-entry of email/url. `auth remove` remains the full-delete (profile + all per-profile credentials) | Resolves F1 Open Question 6; matches user expectation that logout is reversible without re-answering setup questions, while remove is the destructive operation | F1 | 2026-09-01 | human (at F1 gate) |
| DEC-321 | Refresh override REMOVED: `auth refresh` always follows the profile's intrinsic `auth_method`; the current per-call `--oauth` override in `chosen_flow_for_profile` (`cli/auth/mod.rs:107`) is removed. Changing a profile's mechanism is done via explicit `auth login <profile>` re-declaration | Resolves F1 Open Question 8; a per-call override on `refresh` contradicts DEC-313's "auth mechanism is an intrinsic profile property, no per-command switch" design | F1 | 2026-09-01 | human (at F1 gate) |
| DEC-320 | F1 delta-analysis for cycle-003 (`auth-profile-dx`) APPROVED at the human gate -- impact boundary accepted: ~8 BCs amend, ~9-13 new BCs, ADR-0011 amendment + one new ADR, 10 preliminary F3 stories, HIGH-risk shared->per-profile credential migration flagged | F1 delta-analysis report (`cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md`) presented at the gate; human approved proceeding to F2 | F1 | 2026-09-01 | human |
| DEC-319 | Device Authorization Grant (RFC 8628) rejected as a design basis for cycle-003 | Unsupported on Atlassian 3LO; does not solve unattended CI (still needs a human) -- not designed against | F1 | 2026-09-01 | human |
| DEC-318 | 2LO service-account client-credentials CI **deferred** to a future cycle | Correct future zero-friction-CI direction, but needs an Atlassian-endpoint-coverage spike; separable additive new grant type, out of scope for a make-OAuth-default cycle | F1 | 2026-09-01 | human |
| DEC-317 | Un-defer ADR-0011 (`Profile` newtype type-level hard-fence) | Per-profile credential normalization (DEC-315) multiplies cross-profile scoping call-sites -- the hard-fence is now justified; this cycle is ADR-0011's documented "config overhaul" revisit trigger | F1 | 2026-09-01 | human |
| DEC-316 | API-token auth stays coequal & first-class -- **not deprecated** | No leading CLI removed token/key auth; it remains `jr`'s only unattended-CI path | F1 | 2026-09-01 | human |
| DEC-315 | Per-profile credentials (option 1): api-token becomes per-profile (`<profile>:email`/`<profile>:api-token`), symmetric with per-profile OAuth tokens; one-time migration of the shared account-level `email`/`api-token` keys into the `default` profile | Restructures the shared-vs-per-profile keychain invariant to match OAuth's existing per-profile scoping; preserves the `"default"`-only legacy-key lazy-migration discipline. Migration discipline mandatory; a `v1`→`v2` keychain/cache-namespace bump is on the table | F1 | 2026-09-01 | human |
| DEC-314 | Lightweight structured profile: add a first-class additive `Option` `env`/role tag (prod/sandbox/uat); per-profile `url` remains the environment lock (profile = environment + identity); platform-vs-JSM stays per-command, not a profile dimension | Tolerant reader (old profiles → `None`); no forced cache/keychain namespace bump for this field alone | F1 | 2026-09-01 | human |
| DEC-313 | Auth mechanism (`auth_method`) is a first-class intrinsic profile property, set once at profile creation (interactive → OAuth default, mirroring `jr init`); every invocation auto-selects the profile's mechanism; no per-command auth switch. `--oauth`/`--api-token` demote to creation-time declaration; `--oauth` retained as a deprecated-but-accepted alias for a migration window. Runtime `client.rs::from_config` `unwrap_or("api_token")` default is NOT flipped -- non-interactive CI (`JR_EMAIL`/`JR_API_TOKEN`, `--no-input`, non-TTY) stays token-first, never launches a browser | Makes OAuth the default for interactive/new users while keeping the existing non-interactive CI contract byte-for-byte unchanged | F1 | 2026-09-01 | human |
| DEC-312 | cycle-003 opened -- `auth-profile-dx` feature bundle; goal: make OAuth the default auth mechanism and restructure auth so authentication is an intrinsic per-profile property with per-profile credential ownership, enabling environment-locked profiles (prod/sandbox) | Grounded investigation (`auth-profile-current-state.md`) + modern-CLI research (`modern-cli-auth-profile-research.md`, 39 sources) presented at the architect gate; human confirmed scope | F1 | 2026-09-01 | human |
| DEC-311 | cycle-002 field-dx closure -- 5-dimensional delta convergence + full-tree regression PASS, human-authorized at the F7 gate ("Approve & release"); proceed to release | F7 delta-convergence report (all 5 dims PASS, regression 4660/0/106, MAXIMUM_VIABLE_REFINEMENT recommended) presented and approved | F7 | 2026-09-01 | human |
| DEC-310 | Reverses DEC-188: `--field` alone on the platform `issue create` path no longer exits 64 -- resolves via `createmeta` instead (BC-3.3.010/BC-3.8.012) | Non-JSM `--field` support was the point of issue #578; the DEC-188 guard predates that scope and now blocks it needlessly | F2 | 2026-08-25/26 | product-owner; human (approved) |
| F-3 | D2 collision-guard extension to the JSM create path -- **RESOLVED: retain the pre-existing last-wins behavior**, no guard extension | BC-3.8.008's JSM dedicated-flag semantics already diverge from platform | F2 | 2026-08-26 | human (decided) |
| ADR-0019 | Context mechanism for `jr field options` is `createmeta` (PRIMARY platform) / requesttype-fields (PRIMARY JSM) / `editmeta` (FALLBACK); cascading-select delimiter is `>` | Ranked recommendation from `research/field-dx-context-mechanism-2026-08-25.md` | F1/F2 | 2026-08-25 (Accepted); amendments through round-6 | architect |
| DEC-309 (historical, cycle-001) | `list-read-ergonomics` cycle closure -- MAXIMUM_VIABLE_REFINEMENT_REACHED, human-authorized | F7 5-dimensional convergence PASS | F7 | 2026-08-24 | human (authorized) |

## Skip Log

| Step | Skipped? | Justification |
|------|----------|----------------|
| UX Spec (cycle-002) | yes | `jr` is a CLI-only product; field-dx bundle adds no UI surfaces. |
| DTU creation (cycle-002) | yes | `dtu_required: false` -- no external service behavior is being cloned by this bundle. |
| F5 secondary review-tier (Step 7, cycle-002) | yes | Every story already individually adversarially converged in F4; primary pass found only 1 low-likelihood MED + 4 LOW. |
| F6 Kani formal verification (cycle-002) | yes | Not set up in repo; proptest substitution justified (32/32 VPs covered, 0 GAP). |
| F6 cargo-fuzz (cycle-002) | yes | Not set up in repo; proptest arbitrary-input substitution justified (0 uncovered input surface). |
| F6 DTU adversarial testing / accessibility re-check (cycle-002) | yes | `dtu_required: false`; `feature_type: backend-cli`, no UI surface. |
| UX Spec (cycle-003, tentative) | tbd | `jr` is CLI-only; auth-profile-dx is likely no-UI-surface, same as cycle-002 -- confirm at F1/F2. |
| DTU creation (cycle-003) | yes | `dtu_required: false` -- no external service behavior is being cloned; auth flows target the real Atlassian OAuth/token endpoints already covered by existing DTU-not-required precedent. |

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/<cycle>/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| (none currently open) | -- the DEC-namespace disambiguation question is tracked debt, not a hard blocker | -- | -- | -- | -- |

## Convergence Status

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): historical, unchanged this burst.

`cycle-002` (`field-dx`) F2-F7 COMPLETE, human-authorized at the F7 gate (DEC-311, MAXIMUM_VIABLE_REFINEMENT_REACHED). **RELEASED 2026-09-01 as `v0.7.0-dev.3`** (PR #751 @ `87f17aff`, tag pushed, `release.yml` run `33459579699` triggered). cycle-002 field-dx is SHIPPED, historical as of this burst.

`cycle-003` (`auth-profile-dx`) F1 delta-analysis **APPROVED** at the human gate this burst; Phase F2 (spec evolution) now IN PROGRESS. No convergence loop started yet (convergence applies from F4 onward). No BC/VP/holdout counts changed yet (719/32/106) -- F2 has not yet landed any spec edits.

## Concurrent Cycles

Three tracked cycles. `cycle-001` is CLOSED, historical. `cycle-002` (`field-dx`) is **CLOSED + RELEASED** (2026-09-01), historical. `cycle-003` (`auth-profile-dx`) is the sole **ACTIVE** cycle, F1 APPROVED, now at Phase F2 (spec evolution).

## Constraints Carried Forward (cycle-003)

ADR-0006 (embedded OAuth app, fixed callback port 53682), ADR-0013 (PKCE deferral -- Atlassian 3LO does not support public-client PKCE as of 2026-05), SD-002 release gates (`JR_AUTH_HEADER`/`JR_BASE_URL` debug-only, release binaries ignore them), single-use refresh tokens + `refresh_coordinator.rs` per-profile single-flight, Windows Credential Manager posture (SEC-WCM-DOC), and the shared-vs-per-profile keychain invariant -- being **deliberately restructured** by DEC-315; migration discipline mandatory (see F2 for the concrete migration design). Additionally as of this burst: refresh mechanism override removed (DEC-321) -- `auth refresh` always follows the profile's intrinsic `auth_method`; ADR-0011 amendment (Deferred->Accepted, DEC-317/DEC-325b) and new ADR-0020 (DEC-325c) are F2 deliverables, not yet written.

## Session Resume Checkpoint

**Date:** 2026-09-01. **Position:** cycle-003 (`auth-profile-dx`) F1 delta-analysis **APPROVED**, Phase **F2 (spec evolution) IN PROGRESS**. `develop` @ `87f17aff` (unchanged -- no code touched yet). cycle-001 and cycle-002 remain CLOSED, historical, unaltered by this burst.

**This burst (cycle-003 F1-gate APPROVED / F2 entry):** the F1 delta-analysis report (`cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md`) was presented at the human gate and APPROVED: impact boundary accepted (~8 BCs amend, ~9-13 new BCs, ADR-0011 amendment + one new ADR, 10 preliminary F3 stories, HIGH-risk shared->per-profile credential migration). All 4 F1 open questions were resolved at the gate, recorded this burst as DEC-320 through DEC-325: F1 APPROVED (DEC-320); refresh override removed -- `auth refresh` always follows the profile's intrinsic `auth_method`, no per-call `--oauth` override (DEC-321, resolves Open Question 8); `auth logout` is session-clear only and non-destructive, preserving profile config + non-session identity, `auth remove` remains full-delete (DEC-322, resolves Open Question 6); explicit `--api-token` flag added to `auth login`, symmetric with the now-deprecated `--oauth` (DEC-323, resolves Open Question 5); `env` tag surfaced as an `auth list` table column plus `auth status`/JSON, pinned BC-1.6.046 snapshot updated (DEC-324, resolves Open Question 7); accepted architect recommendations -- no version bump, ADR-0011 amended in place (not superseded), one combined new ADR-0020 (per-profile credential layout + `env` tag + OAuth-default-at-creation), `--oauth` deprecated indefinitely with no hard removal date (DEC-325). STATE.md refreshed via one full-content Write (v3.31 → v3.32): `phase` F1 → F2; `current_step` and `cycle_003_status` updated to reflect F1 APPROVED / F2 IN PROGRESS. Prior F1-pending checkpoint (v3.31) archived to `cycles/cycle-003/session-checkpoints.md`. Burst narrative: `cycles/cycle-003/burst-log.md` Burst 2.

**In-flight:** Phase F2 (spec evolution) is now open but not yet dispatched/executed -- no ADR-0011 amendment text, no ADR-0020 file, no BC delta written yet. No open worktrees, no pending PRs, no open convergence loop, no code changed.

**Constraints to carry into F2:** ADR-0006 (embedded OAuth, fixed port 53682), ADR-0013 (PKCE deferral), SD-002 debug-only release gates, single-use refresh tokens + `refresh_coordinator.rs` single-flight, Windows Credential Manager posture, and the shared-vs-per-profile keychain invariant under deliberate restructuring (DEC-315) -- migration discipline mandatory. Refresh override removed (DEC-321). Full detail: `cycles/cycle-003/investigation/auth-profile-current-state.md`, `cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md`.

**Deferred to F2 (noted, not blocking):** input-hash drift check runs at the F2 gate (F1 wrote no new specs; only the known ~142-item accepted standing drift exists, see Drift/Standing Items below). NFR-S-B nfr-catalog vs CLAUDE.md doc-drift to be reconciled during F2.

**cycle-002 final state (unchanged, historical):** RELEASED as `v0.7.0-dev.3` (PR #751 @ `87f17aff`, tag pushed, `release.yml` run `33459579699`). Counts: 719 total BCs (BC-INDEX v6.82), 32 VPs, 106 holdout scenarios -- unchanged this burst.

**NEXT on resume:** dispatch Phase F2 spec evolution (`/vsdd-factory:phase-f2-spec-evolution`) against the approved F1 delta-analysis and the 6 gate-resolution decisions (DEC-320..DEC-325): amend ADR-0011 (Deferred->Accepted), author new ADR-0020, write the BC delta (~8 amend / ~9-13 new).

**Resume command:** `/vsdd-factory:next-step` -- reports F2 spec-evolution as the next step -- or `/vsdd-factory:phase-f2-spec-evolution` directly.

**Superseded checkpoints:** the prior F1-pending checkpoint (v3.31, 2026-09-01) is superseded in place by this burst's F1-APPROVED/F2-IN-PROGRESS position above and archived to `cycles/cycle-003/session-checkpoints.md`. Earlier archives (RELEASED/SHIPPED v3.29, F7-PASS/AWAITING-GATE v3.27, F6-COMPLETE v3.26, F5-COMPLETE v3.25, F4-COMPLETE v3.24, `WRAP-F4-WAVE2-COMPLETE-PAUSE` v3.23, and the SESSION-WRAP checkpoint) remain at `cycles/cycle-002/session-checkpoints.md`. The `list-read-ergonomics` cycle-001 CLOSED-position checkpoint (v3.05) remains archived at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-14 = F2/F3/F4; 15 = F5 CONVERGED + FIX-F5-001; 16 = F6 COMPLETE + FIX-F6-001; 17 = F7 delta-convergence analyses PASS + FIX-F7-001; 18 = F7 human gate APPROVED + cycle-002 CLOSED; 19 = release v0.7.0-dev.3 SHIPPED; 20 = SESSION-WRAP) |
| cycle-003 burst history | `cycles/cycle-003/burst-log.md` (Burst 1 = cycle OPENED; Burst 2 = F1 delta-analysis APPROVED at human gate, F2 entry, this burst) |
| cycle-003 grounding artifacts | `cycles/cycle-003/investigation/auth-profile-current-state.md` (current-state map); `cycles/cycle-003/investigation/modern-cli-auth-profile-research.md` (modern-CLI research, 39 sources, 4 ranked recommendations) |
| cycle-003 F1 delta-analysis report | `cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md` (impact boundary, affected specs/stories/tests, regression risk; APPROVED at human gate this burst) |
| F5 scoped-adversarial review report (cycle-002) | `phase-f5-adversarial/adversarial-delta-review.md` (raw pass-1 findings); `phase-f5-adversarial/convergence-summary.md` (F5 close record) |
| F6 targeted-hardening report (cycle-002) | `phase-f6-hardening/summary.md` (consolidated); `kani-results.md`, `fuzz-results.md`, `mutation-results.md`, `security-scan-results.md` (per-check detail) |
| F7 delta convergence report + traceability (cycle-002) | `phase-f7-convergence/delta-convergence-report.md`; `phase-f7-convergence/traceability-chain-delta.md`; `phase-f7-convergence/consistency-audit-delta.md`; `phase-f7-convergence/holdout-eval-delta.md`; `cycles/cycle-002/convergence/traceability-chain.md` (master) |
| cycle-001/cycle-002 convergence trajectory + session checkpoints + lessons + resolved blockers | `cycles/cycle-001/` and `cycles/cycle-002/` (see per-cycle files; cycle-002 session-checkpoints.md holds all prior F2-F7 + RELEASED + SESSION-WRAP checkpoints) |
| S-578-2/S-578-3/S-578-4 delivery artifacts | `cycles/cycle-002/S-578-2/`, `S-578-3/`, `S-578-4/` (red-gate-log.md, adversary-convergence-state.json); `code-delivery/S-578-2/`, `S-578-3/`, `S-578-4/` (pr-review.md, demos) |
| FIX-F5-001/FIX-F6-001/FIX-F7-001 delivery artifacts | `code-delivery/FIX-F5-001/`, `FIX-F6-001/`, `FIX-F7-001/` (pr-description.md, pr-review.md) |
| Release v0.7.0-dev.3 delivery artifacts | `code-delivery/release-v0.7.0-dev.3/` (pr-description.md, pr-review.md) |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**cycle-003 (updated this burst):** DEC-NAMESPACE-COLLISION-RISK re-verified (corpus-wide grep of `DEC-[0-9]+` across `.factory/**/*.md`, max pre-existing `DEC-319`) before allocating DEC-320..DEC-325 -- clean, no collision. New this burst: F2 must reconcile the ~142-item historical input-hash drift check at the F2 gate (deferred from F1, not blocking) and the NFR-S-B nfr-catalog vs CLAUDE.md doc-drift item (deferred to F2, not blocking).

**Still open (2026-09-01, cycle-002 F7 human gate + S-7.02 cycle-closing checklist -- justified deferral, carried forward unchanged):**
- `CYCLE-002-PROCESS-GAP-DEFERRAL-1/2/3` (all LOW, justified deferral — no follow-up story exists in STORY-INDEX; target: a future SELF-IMPROVEMENT maintenance cycle; reason: process-doc refinement, non-blocking): (1) AC-016<->Task-2 story placement conflict; (2) story File-Structure vs Architecture-Mapping self-contradiction; (3) Task-2 test-inversion left stale test-names/doc-comments uncaught until adversary Pass 11. Full detail + `[codified]` disposition notes: `cycles/cycle-002/lessons.md` Process-Level items 3/4/5.

**Still open (2026-08-31, cycle-002 F5/F6, unchanged):**
- `F5-EDIT-GATEB-SHARE`, `F5-ISSUETYPE-CASEFOLD-SPLIT`, `F5-VP578021-WEAK-NEGPIN` (all LOW).
- `SEC-F6-1`, `SEC-F6-2` (cross-refs `SEC-001-EDITMETA-RECURSION-GUARD`), `SEC-F6-3` (all LOW).
- `S-578-3-SHARED-ASSET-VALIDATOR`, `S-578-3-FIELDVALUESPEC-RELOCATION`, `S-578-3-PR742-RESIDUAL-NITS` (all LOW).
- `S-578-2-PR741-RESIDUAL-NITS` (LOW, 7 items; `code-delivery/S-578-2/pr-review.md`).

**Still open (unchanged, LOW doc-hygiene / process, non-blocking):**
- `S-580-1-PR740-S1/S2/S3/N1/N2`, `BC-3.3.010-CITATION-UPGRADE-ELIGIBLE`.
- `PRD-DELTA-ROUND2-STEP2A-STALE-NARRATION`, `PLATFORM-ASSET-WIRE-SHAPE-UNVERIFIED`, `M1-EDITMETA-STATUS-PERMISSION-CAVEAT`, `PRD-DELTA-SUMMARY-AMENDED-BC-COUNT-STALE`.
- `BC-INDEX-GUARD-GAP`, `GUARD-SCOPE-COPY-PASTE-PATTERN`, `COUNT-RECONCILIATION-FORCED-CONSISTENCY-PATTERN` -- logged in `cycles/cycle-002/lessons.md`.
- `HOLDOUT-COVERAGE-GAP-LIST-READ-ERGONOMICS-FLAGS`, `STORY-INDEX-DECLARED-VS-FILE-COUNT-MISMATCH` (both LOW, pre-existing).

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- ~142 historical stale `input-hash` artifacts factory-wide; standing debt, **not** a cycle-002 or cycle-003 blocker.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`) -- the 3 `CYCLE-002-PROCESS-GAP-DEFERRAL` items above are candidates for future stories in this same epic.
