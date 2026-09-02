---
document_type: pipeline-state
level: ops
version: "3.37"
status: active
producer: state-manager
timestamp: 2026-09-01T23:55:00Z
phase: F3
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-453 latest brownfield (unchanged); trajectory-tail →1→3→0→2 (unchanged). The F2 human approval gate for cycle-003 (`auth-profile-dx`) was presented and APPROVED this burst (DEC-328) -- F2 delta CONVERGED (4-pass adversarial trajectory, pass-4 CLEAN) + fresh-context consistency audit CONSISTENT + cycle-003-scoped input-hash drift check NO-DRIFT. Human directed the 4 LOW residuals (F-1, NEW-1, F-2, L-3) be swept in a dedicated burst before F3 -- all 4 were fixed this same burst (BC-1.2.051 wording alignment, DEC-326 traceability citations added to bc-1 + ADR-0020, ADR-0020 Decision-7 logout-notice note, delta-analysis.md phantom-citation footnote + input-hash refresh). Both `scripts/check-bc-cumulative-counts.sh` and `scripts/check-spec-counts.sh` re-verified green (733 BCs unchanged). Phase advances F2 -> F3; pipeline PAUSED -> ACTIVE. Phase F3 (incremental stories) dispatch is the immediate next activity."
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
cycle_003_status: "auth-profile-dx -- OPEN (feature mode), pipeline ACTIVE, Phase F3 (incremental stories) next. Phase F1 delta-analysis APPROVED at human gate 2026-09-01. Phase F2 (spec evolution) AUTHORING COMPLETE, then F2-GATE FIX ROUND COMPLETE (adversary pass-1 C-1 + pass-2 H-1/H-2/M-1/M-2/M-3, DEC-326/327), then adversary pass-3 (arch-doc propagation fixes) committed as 8fe5d78f, then adversary pass-4 (convergence check) COMPLETED CLEAN 2026-09-01, then the F2 human approval gate presented and APPROVED (DEC-328) 2026-09-01 -- human directed a dedicated residual-sweep burst before F3, and all 4 LOW residuals (F-1, NEW-1, F-2, L-3) were fixed in that same burst. F2 is CLOSED. F3 story decomposition (10 preliminary candidates, see delta-analysis.md §2) is the immediate next step. BC/VP/holdout counts unchanged this burst (733/41/106)."
activation_head: "87f17aff"
activation_version: "v0.7.0-dev.3"
---

<!-- STATE.md SIZE BUDGET (2026-09-01, F2-gate-approved + residual-sweep + F3-entry burst):
     217 lines (wc-l). soft-target 200; hard cap 500.
     margin from soft-target = 217 - 200 = 17 -- 17 lines OVER the soft target of 200.
     margin from actual (hard cap) = 500 - 217 = 283 lines of headroom remain before the hard cap of 500.
     This burst records the F2 human approval gate's APPROVAL (DEC-328) and the
     human-directed sweep of all 4 LOW residuals (F-1, NEW-1, F-2, L-3) carried over from
     Burst 6's pass-4-CLEAN convergence check and the F2-gate consistency audit. All 4 were
     fixed in the spec files themselves this burst (see burst-log.md Burst 7 for exact
     edits) -- they are removed from Drift/Standing Items as resolved, not merely
     re-labeled. Frontmatter: version 3.36->3.37, timestamp refreshed, `phase` F2->F3,
     `pipeline` PAUSED->ACTIVE -- this burst both closes F2 and opens F3. cycle_001_status/
     cycle_002_status preserved verbatim, unaltered. Session Resume Checkpoint replaced; the
     prior CONVERGED/PAUSED checkpoint (v3.36) is archived to
     cycles/cycle-003/session-checkpoints.md. Burst narrative:
     cycles/cycle-003/burst-log.md Burst 7. `scripts/check-bc-cumulative-counts.sh` and
     `scripts/check-spec-counts.sh` both reconfirmed green (733 BCs unchanged) after this
     burst's residual fixes, before committing. One full-content Write, no Edit chain
     (DEC-247). Pre-existing uncommitted `regression-state.json` and `sidecar-learning.md`
     modifications in the worktree are left untouched -- not staged, not committed, per
     standing instruction; both predate this session and are unrelated to cycle-003 work. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →1→3→0→2 (unchanged this burst) |
| **Last Updated** | F2-gate-approved + residual-sweep burst (2026-09-01): trajectory-tail →1→3→0→2 (unchanged). The F2 human approval gate for `auth-profile-dx` was presented and APPROVED (DEC-328); all 4 LOW residuals (F-1, NEW-1, F-2, L-3) swept in the same burst per the human's directive. Phase advances F2 → F3; pipeline PAUSED → ACTIVE. |
| **Current Phase** | Feature Mode cycle-003 (`auth-profile-dx`) -- **F2 CLOSED (human-approved, DEC-328); F3 (incremental stories) is the immediate next activity**. cycle-001 and cycle-002 remain CLOSED, historical. |
| **Activation HEAD** | 87f17aff (`develop` tip; unchanged this burst -- no `develop`-side commit in cycle-003) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, cycles/cycle-003/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| F2-GATE-FIX-ROUND (cycle-003) | COMPLETE | 2026-09-01 | Superseded by pass-3/pass-4 below | Adversary pass-1 CRITICAL (C-1 migration-lockout) fixed via DEC-326 no-copy redesign; pass-2's 2 HIGH + 3 MED (H-1/H-2/M-1/M-2/M-3) fixed; DEC-326/DEC-327 recorded, DEC-325(a) annotated superseded. Spec commit `d9b69e61`. Report: `cycles/cycle-003/burst-log.md` Burst 4. | 731→733 BCs; 41 VPs unchanged |
| F2-GATE-PASS3 + SESSION-WRAP (cycle-003) | COMPLETE (fixes committed) | 2026-09-01 | Superseded by pass-4 below | Pass-3 (arch-doc propagation: HIGH-1 env-var trigger, MED-2 newtype-scope, MED-3 relogin terminology) committed as `8fe5d78f`. Session was then paused mid-pass-4 by a human `/wrap`; that pass-4 attempt died mid-run with no persisted progress. Report: `cycles/cycle-003/burst-log.md` Burst 5. | 733 BCs unchanged; 41 VPs unchanged |
| F2-GATE-PASS4-CONVERGED (cycle-003) | COMPLETE — CLEAN | 2026-09-01 | Superseded by F2-GATE-APPROVED below | Adversary pass-4 (convergence check) re-run fresh (prior wrap-time attempt persisted nothing) and returned CLEAN: 0 CRITICAL/HIGH/material-MED across bc-1, bc-6, ADR-0020, architecture-delta, adr-0011-amendment-staged, STATE DEC-312..327. **F2 delta CONVERGED.** 2 LOW non-blocking residuals (F-1, F-2) recorded. Report: `cycles/cycle-003/burst-log.md` Burst 6. | 733 BCs unchanged; 41 VPs unchanged; pass-4: 0 CRITICAL/HIGH/material-MED |
| F2-GATE-APPROVED (cycle-003) | **COMPLETE (this burst)** | 2026-09-01 | Human gate — F2 spec-evolution delta **APPROVED** (DEC-328) | Human approved the F2 delta (4-pass adversarial trajectory: pass-1 major → pass-2 seams → pass-3 arch-doc propagation → pass-4 CLEAN) + fresh-context consistency audit CONSISTENT + cycle-003-scoped input-hash drift check NO-DRIFT. Human directed a dedicated residual-sweep burst before F3; all 4 LOW residuals (F-1, NEW-1, F-2, L-3) fixed in this same burst. Phase advances F2 → F3. Report: `cycles/cycle-003/burst-log.md` Burst 7. | 733 BCs unchanged; 41 VPs unchanged |

## Current Phase Steps (cycle-003, F2 APPROVED + residuals swept + F3 entry; last 5)

| Step | Status | Notes |
|------|--------|-------|
| SESSION-WRAP: pipeline set PAUSED (historical) | **DONE** | Human-requested `/wrap`. STATE.md v3.34→v3.35, `pipeline: ACTIVE`→`PAUSED`. |
| Adversary pass-4 CLEAN — F2 CONVERGED (recorded post-wrap) | **DONE** | Re-run fresh (not resumed) against the fully-reconciled specs; 0 CRITICAL/HIGH/material-MED. Two LOW residuals (F-1, F-2) recorded. |
| F2 human approval gate — presented and APPROVED (DEC-328) | **DONE (this burst)** | Human approved the F2 delta; directed the 4 LOW residuals be swept in a dedicated burst before F3 dispatch. |
| 4 LOW residuals swept: F-1, NEW-1, F-2, L-3 all fixed | **DONE (this burst)** | F-1 (bc-1 wording alignment), NEW-1 (DEC-326 citations added to bc-1 + ADR-0020), F-2 (ADR-0020 §Decision 7 note), L-3 (delta-analysis.md phantom-citation footnote + input-hash `344ff59`→`b635a86`). Both count guards re-verified green (733 BCs). |
| Phase transition F2 → F3, pipeline PAUSED → ACTIVE | **DONE (this burst)** | F2 is CLOSED. F3 story decomposition is the immediate next activity — dispatch by the orchestrator right after this commit. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-328 | cycle-003 F2 (spec evolution / `auth-profile-dx`) delta APPROVED at the human gate; F2 delta CONVERGED (4-pass adversarial trajectory, pass-4 CLEAN) + fresh-context consistency audit CONSISTENT + cycle-003-scoped input-hash drift check NO-DRIFT. Human directed the 4 LOW residuals be swept in a dedicated burst before F3. Proceed to F3 story decomposition | F2 spec-evolution package (BC delta, staged ADR-0011 amendment, ADR-0020, 4-pass adversarial convergence record) presented at the gate; human approved, contingent on the residual sweep completing first — F-1/NEW-1/F-2/L-3 all fixed in this same burst | F2 | 2026-09-01 | human |
| DEC-327 | Env-var (`JR_EMAIL`/`JR_API_TOKEN`) presence suppresses the OAuth-default picker in NON-INTERACTIVE mode ONLY (`--no-input`/non-TTY); on an interactive TTY the OAuth picker always shows regardless of env vars. Refines DEC-313 | Resolves F2-gate adversary pass-2 finding M-1/L-2 (SR-010): an env-var trigger that also suppressed the picker on an interactive TTY would silently deny users the OAuth-default experience DEC-313 established. Encoded in BC-1.1.014 | F2 | 2026-09-01 | human (at F2-gate fix round) |
| DEC-326 | No-copy detect-and-instruct migration for the shared legacy `email`/`api-token` credential (supersedes DEC-325(a)'s "lazy migration" clause): `load_api_token` NEVER reads-as-credential, copies, or deletes the legacy keys for any profile (including `default`); an absent namespaced pair produces an actionable exit-64 instructing `jr auth login <profile>`. DEC-325(a)'s "additive keychain keys" clause stands, unaffected | Closes F2-gate adversary pass-1 CRITICAL finding C-1 (migration-lockout): the original copy-then-delete design could silently place a prod credential behind a sandbox-tagged profile, defeating DEC-312's environment-locking goal. Encoded in BC-1.4.032/033/034, VP-AUTHDX-005/006/007/008, ADR-0020 §Decision 2/2a/2b | F2 | 2026-09-01 | human (at F2-gate fix round) |
| DEC-325 | Accepted architect recommendations for cycle-003 F1 (Open Questions 1/2/3 + deprecation window): (a) NO version bump -- per-profile `<profile>:email`/`<profile>:api-token` are additive keychain keys **[lazy-migration clause SUPERSEDED 2026-09-01 by DEC-326's no-copy detect-and-instruct redesign; "additive keychain keys" stands]**, keychain stays profile-prefixed (no `v2` marker), no cache-root bump; (b) ADR-0011 un-deferred via IN-PLACE amendment (Deferred->Accepted), not supersession; (c) ONE combined new ADR (target ADR-0020, collision-checked clean) covering per-profile credential layout + `env` tag + OAuth-default-at-creation; (d) `--oauth` kept accepted indefinitely, marked deprecated, no hard removal date -- removal left to a future cycle | Matches human's caution on breaking changes; avoids an unforced cache/keychain version bump; consolidates related spec work into one ADR rather than three | F1 | 2026-09-01 | human (at F1 gate) |
| DEC-324 | `env` tag (prod/sandbox/uat) surfaced as an `auth list` table column | Resolves F1 Open Question 7; the tag exists on the profile (DEC-314) but was not yet visible in any command output. Appears in the human table plus `auth status` and JSON. The pinned BC-1.6.046 4-column insta-snapshot is updated to accommodate it (documented, routine output change) | F1 | 2026-09-01 | human (at F1 gate) |
| DEC-323 | Explicit `--api-token` flag added to `auth login`, symmetric with the now-deprecated `--oauth` alias | Resolves F1 Open Question 5; gives non-interactive mechanism declaration and lets an existing profile's mechanism be re-declared explicitly, without relying on `--oauth`'s absence as the implicit signal | F1 | 2026-09-01 | human (at F1 gate) |
| DEC-322 | `auth logout` is session-clear only, NON-DESTRUCTIVE: for an OAuth profile, `logout` clears ONLY the OAuth session tokens (`<profile>:oauth-access-token`/`-refresh-token`) and PRESERVES the profile config entry and all non-session identity (url, cloud_id, env, any stored email), so re-login requires no re-entry of email/url. `auth remove` remains the full-delete (profile + all per-profile credentials) | Resolves F1 Open Question 6; matches user expectation that logout is reversible without re-answering setup questions, while remove is the destructive operation | F1 | 2026-09-01 | human (at F1 gate) |
| DEC-321 | Refresh override REMOVED: `auth refresh` always follows the profile's intrinsic `auth_method`; the current per-call `--oauth` override in `chosen_flow_for_profile` (`cli/auth/mod.rs:107`) is removed. Changing a profile's mechanism is done via explicit `auth login <profile>` re-declaration | Resolves F1 Open Question 8; a per-call override on `refresh` contradicts DEC-313's "auth mechanism is an intrinsic profile property, no per-command switch" design | F1 | 2026-09-01 | human (at F1 gate) |
| DEC-320 | F1 delta-analysis for cycle-003 (`auth-profile-dx`) APPROVED at the human gate -- impact boundary accepted: ~8 BCs amend, ~9-13 new BCs, ADR-0011 amendment + one new ADR, 10 preliminary F3 stories, HIGH-risk shared->per-profile credential migration flagged | F1 delta-analysis report (`cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md`) presented at the gate; human approved proceeding to F2 | F1 | 2026-09-01 | human |
| DEC-319 | Device Authorization Grant (RFC 8628) rejected as a design basis for cycle-003 | Unsupported on Atlassian 3LO; does not solve unattended CI (still needs a human) -- not designed against | F1 | 2026-09-01 | human |
| DEC-318 | 2LO service-account client-credentials CI **deferred** to a future cycle | Correct future zero-friction-CI direction, but needs an Atlassian-endpoint-coverage spike; separable additive new grant type, out of scope for a make-OAuth-default cycle | F1 | 2026-09-01 | human |
| DEC-317 | Un-defer ADR-0011 (`Profile` newtype type-level hard-fence) | Per-profile credential normalization (DEC-315) multiplies cross-profile scoping call-sites -- the hard-fence is now justified; this cycle is ADR-0011's documented "config overhaul" revisit trigger | F1 | 2026-09-01 | human |
| DEC-316 | API-token auth stays coequal & first-class -- **not deprecated** | No leading CLI removed token/key auth; it remains `jr`'s only unattended-CI path | F1 | 2026-09-01 | human |
| DEC-315 | Per-profile credentials (option 1): api-token becomes per-profile (`<profile>:email`/`<profile>:api-token`), symmetric with per-profile OAuth tokens; one-time migration of the shared account-level `email`/`api-token` keys into the `default` profile | Restructures the shared-vs-per-profile keychain invariant to match OAuth's existing per-profile scoping; preserves the `"default"`-only legacy-key lazy-migration discipline **[migration mechanism superseded 2026-09-01 by DEC-326 — see above]**. Migration discipline mandatory; a `v1`→`v2` keychain/cache-namespace bump is on the table | F1 | 2026-09-01 | human |
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

`cycle-003` (`auth-profile-dx`) F1 delta-analysis APPROVED at the human gate; Phase F2 (spec evolution) AUTHORING COMPLETE, then F2-GATE-FIX-ROUND COMPLETE, then adversary pass-3 (arch-doc propagation fixes) committed as `8fe5d78f`, then adversary pass-4 (convergence check) COMPLETED CLEAN — 0 CRITICAL/HIGH/material-MED across bc-1, bc-6, ADR-0020, architecture-delta, adr-0011-amendment-staged, and STATE DEC-312..327 — then the **F2 human approval gate presented and APPROVED this burst (DEC-328)**. Human directed a dedicated residual-sweep burst before F3; **all 4 LOW residuals (F-1, NEW-1, F-2, L-3) fixed in this same burst**. **F2 is CLOSED.** Pipeline transitions **PAUSED → ACTIVE**; phase **F2 → F3**. Phase F3 (incremental stories) is the immediate next activity, to be dispatched right after this commit. Counts unchanged this burst: **733 total BCs**, **41 total VPs**, **106 holdout scenarios**.

## Concurrent Cycles

Three tracked cycles. `cycle-001` is CLOSED, historical. `cycle-002` (`field-dx`) is **CLOSED + RELEASED** (2026-09-01), historical. `cycle-003` (`auth-profile-dx`) is the sole cycle with open work: F1 APPROVED, F2 spec-evolution + gate-fix-round + pass-3 propagation fixes + pass-4 convergence check all COMPLETE (F2 delta CONVERGED), F2 human approval gate **APPROVED** (DEC-328), all 4 LOW residuals swept. Phase is now **F3** (incremental stories); pipeline is **ACTIVE** as of this burst.

## Constraints Carried Forward (cycle-003)

ADR-0006 (embedded OAuth app, fixed callback port 53682), ADR-0013 (PKCE deferral -- Atlassian 3LO does not support public-client PKCE as of 2026-05), SD-002 release gates (`JR_AUTH_HEADER`/`JR_BASE_URL` debug-only, release binaries ignore them), single-use refresh tokens + `refresh_coordinator.rs` per-profile single-flight, Windows Credential Manager posture (SEC-WCM-DOC), and the shared-vs-per-profile keychain invariant -- being **deliberately restructured** by DEC-315, migration mechanism finalized as no-copy detect-and-instruct (DEC-326); migration discipline mandatory (see F2 spec delta for the concrete migration design). Refresh mechanism override removed (DEC-321) -- `auth refresh` always follows the profile's intrinsic `auth_method`; ADR-0011 amendment (Deferred->Accepted, DEC-317/DEC-325b) is authored and STAGED (not yet applied to `docs/adr/`) -- application is an F4 obligation (`S-cycle3-adr0011-newtype`); ADR-0020 (DEC-325c) is authored, final under `.factory/`, and reconciled through pass-3, pass-4 (CLEAN), and the F2-gate residual sweep (§Decision 2 heading now cites DEC-326; §Decision 7 carries the BC-1.2.013 logout-notice note) -- no further fixes required, F2 is CLOSED.

## Session Resume Checkpoint

**Date:** 2026-09-01. **Position:** cycle-003 (`auth-profile-dx`), the **F2 human approval gate is APPROVED (DEC-328)** and all 4 LOW residuals (F-1, NEW-1, F-2, L-3) are **fixed**. Phase is now **F3** (incremental stories); pipeline is **ACTIVE**. `develop` @ `87f17aff` (unchanged -- no code touched yet, this is spec-only bookkeeping). cycle-001 and cycle-002 remain CLOSED, historical, unaltered by this burst.

**Convergence trajectory (counter, CONVERGED — F2 CLOSED):** adversary pass-1 (major — incl. C-1 default-only migration-lockout) → fixed → pass-2 (2 HIGH + 3 MED document-seam issues H-1/H-2/M-1/M-2/M-3) → fixed → pass-3 (1 HIGH env-var-trigger + 2 MED newtype-note/terminology, all BC→architecture-doc propagation gaps) → fixed (committed `8fe5d78f`) → pass-4 (convergence check) COMPLETED CLEAN: 0 CRITICAL/HIGH/material-MED across all six reviewed documents → **F2 human approval gate presented and APPROVED (DEC-328) this burst** → **all 4 LOW residuals (F-1, NEW-1, F-2, L-3) fixed this same burst**. F-1 = BC-1.2.051 Invariant 2(b) wording aligned to EC-1.1.013-2's actual "before or alongside" characterization. NEW-1 = DEC-326 traceability citation added to BC-1.4.032/033 Trace lines and ADR-0020 §Decision 2. F-2 = ADR-0020 §Decision 7 note added (api-token `auth logout` emits an informational stderr notice per BC-1.2.013, not a fully silent no-op). L-3 = F1-report phantom "BC-1.1.017" citation footnoted in `delta-analysis.md`, `input-hash` refreshed `344ff59`→`b635a86` (also resolves the single cycle-003 STALE drift-check hit).

**Committed spec state:** unchanged in count from pass-3/pass-4 — bc-1 = 71 BCs (60 individually-bodied), bc-6 = 44, grand total = 733 BCs; 41 VPs (VP-AUTHDX-001..009); 106 holdouts. Both `scripts/check-bc-cumulative-counts.sh` and `scripts/check-spec-counts.sh` re-verified green after this burst's residual-fix edits. Prior commits: `d9b69e61` (pass-1/2 fixes), `228c4905` (STATE v3.34 + DEC-326/327), `8fe5d78f` (pass-3 propagation-fix commit). This burst's commit carries both the STATE/burst-log/session-checkpoints bookkeeping AND the 3 residual-fix spec files (bc-1, ADR-0020, delta-analysis.md) — the first cycle-003 commit since pass-3 to touch spec-body content.

**Human decisions already made + recorded:** DEC-326 (no-copy api-token migration; supersedes DEC-325a), DEC-327 (env-var non-interactive-only OAuth-picker trigger), and DEC-328 (F2 gate APPROVED; residual-sweep-before-F3 directive). Do NOT re-ask these on resume.

**Pending human decision:** none for F2 — the gate is closed. The next human-facing checkpoint is whatever gate F3 (incremental stories) itself produces, if any.

**NEXT on resume (exact):** (1) dispatch **Phase F3 story decomposition** (`/vsdd-factory:phase-f3-incremental-stories`) against the 10 preliminary story candidates enumerated in `cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md` §2 (led by env-tag → per-profile-credential-storage → no-copy-detect-and-instruct → ADR-0011 newtype); (2) note the F4 obligation carried forward: the staged ADR-0011 amendment (`cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md`) must be applied to `docs/adr/0011-type-level-profile-fence.md` by the F4 newtype story's PR — this is now the only outstanding staged-but-unapplied item from F2.

**Resume command:** `/vsdd-factory:next-step`.

**Superseded checkpoints:** the prior CONVERGED/PAUSED checkpoint (v3.36, 2026-09-01 — recorded F2 delta CONVERGED via pass-4 CLEAN, human gate still pending presentation, since superseded by this burst's gate-approval + residual-sweep + F3-entry position above) is superseded in place and archived to `cycles/cycle-003/session-checkpoints.md`, alongside the SESSION-WRAP/PAUSED checkpoint (v3.35), F2-GATE-FIX-ROUND-COMPLETE checkpoint (v3.34), F1-pending checkpoint (v3.31), F2-in-progress checkpoint (v3.32), and F2-authoring-complete checkpoint (v3.33). Earlier archives (RELEASED/SHIPPED v3.29, F7-PASS/AWAITING-GATE v3.27, F6-COMPLETE v3.26, F5-COMPLETE v3.25, F4-COMPLETE v3.24, `WRAP-F4-WAVE2-COMPLETE-PAUSE` v3.23, and the SESSION-WRAP checkpoint) remain at `cycles/cycle-002/session-checkpoints.md`. The `list-read-ergonomics` cycle-001 CLOSED-position checkpoint (v3.05) remains archived at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-14 = F2/F3/F4; 15 = F5 CONVERGED + FIX-F5-001; 16 = F6 COMPLETE + FIX-F6-001; 17 = F7 delta-convergence analyses PASS + FIX-F7-001; 18 = F7 human gate APPROVED + cycle-002 CLOSED; 19 = release v0.7.0-dev.3 SHIPPED; 20 = SESSION-WRAP) |
| cycle-003 burst history | `cycles/cycle-003/burst-log.md` (Burst 1 = cycle OPENED; Burst 2 = F1 delta-analysis APPROVED at human gate, F2 entry; Burst 3 = F2 spec-evolution AUTHORING COMPLETE; Burst 4 = F2-gate FIX round COMPLETE — adversary pass-1/pass-2 fixes, DEC-326/327 recorded; Burst 5 = SESSION-WRAP — pass-3 propagation fixes committed, pass-4 abandoned, PAUSED; Burst 6 = pass-4 CLEAN — F2 CONVERGED, recorded post-wrap; Burst 7 = F2 human approval gate APPROVED (DEC-328), all 4 LOW residuals swept, F2 → F3, PAUSED → ACTIVE, this burst) |
| cycle-003 grounding artifacts | `cycles/cycle-003/investigation/auth-profile-current-state.md` (current-state map); `cycles/cycle-003/investigation/modern-cli-auth-profile-research.md` (modern-CLI research, 39 sources, 4 ranked recommendations) |
| cycle-003 F1 delta-analysis report | `cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md` (impact boundary, affected specs/stories/tests, regression risk; APPROVED at human gate; L-3 phantom-citation residual fixed at F2-gate-approval burst) |
| cycle-003 F2 spec-evolution artifacts | `cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md` (architecture delta narrative); `cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md` (STAGED ADR-0011 amendment, pending F4 application to `docs/adr/`) |
| F5 scoped-adversarial review report (cycle-002) | `phase-f5-adversarial/adversarial-delta-review.md` (raw pass-1 findings); `phase-f5-adversarial/convergence-summary.md` (F5 close record) |
| F6 targeted-hardening report (cycle-002) | `phase-f6-hardening/summary.md` (consolidated); `kani-results.md`, `fuzz-results.md`, `mutation-results.md`, `security-scan-results.md` (per-check detail) |
| F7 delta convergence report + traceability (cycle-002) | `phase-f7-convergence/delta-convergence-report.md`; `phase-f7-convergence/traceability-chain-delta.md`; `phase-f7-convergence/consistency-audit-delta.md`; `phase-f7-convergence/holdout-eval-delta.md`; `cycles/cycle-002/convergence/traceability-chain.md` (master) |
| cycle-001/cycle-002 convergence trajectory + session checkpoints + lessons + resolved blockers | `cycles/cycle-001/` and `cycles/cycle-002/` (see per-cycle files; cycle-002 session-checkpoints.md holds all prior F2-F7 + RELEASED + SESSION-WRAP checkpoints) |
| S-578-2/S-578-3/S-578-4 delivery artifacts | `cycles/cycle-002/S-578-2/`, `S-578-3/`, `S-578-4/` (red-gate-log.md, adversary-convergence-state.json); `code-delivery/S-578-2/`, `S-578-3/`, `S-578-4/` (pr-review.md, demos) |
| FIX-F5-001/FIX-F6-001/FIX-F7-001 delivery artifacts | `code-delivery/FIX-F5-001/`, `FIX-F6-001/`, `FIX-F7-001/` (pr-description.md, pr-review.md) |
| Release v0.7.0-dev.3 delivery artifacts | `code-delivery/release-v0.7.0-dev.3/` (pr-description.md, pr-review.md) |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**cycle-003 (carried forward, unchanged):** ADR-0011's docs/adr amendment is **STAGED, not applied** — `cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md` holds the amended (Status Deferred→Accepted) ADR-0011 body; the main-repo file `docs/adr/0011-type-level-profile-fence.md` on `develop` remains reverted to its pre-amendment content. **The F4 story `S-cycle3-adr0011-newtype` MUST apply this staged amendment to `docs/adr/0011-type-level-profile-fence.md` as part of its implementation PR** — do not let the F4 PR skip this application step. DEC-NAMESPACE-COLLISION-RISK remains clean (max allocated ID DEC-328, no collision this burst).

**cycle-003 (resolved this burst — see `cycles/cycle-003/burst-log.md` Burst 7 for exact edits, not listed here as open):** F-1 (BC-1.2.051 wording alignment), NEW-1 (DEC-326 traceability citations), F-2 (ADR-0020 §Decision 7 note), and L-3 (delta-analysis.md phantom-citation footnote + input-hash refresh) are all FIXED, not merely tracked. F2 is CLOSED with zero open residuals.

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
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- ~142 historical stale `input-hash` artifacts factory-wide; standing debt, **not** a cycle-002 or cycle-003 blocker. cycle-003's own F2-authored specs' input-hash drift check ran at the F2 gate this burst — the single STALE hit found (`delta-analysis.md`) was resolved as part of the L-3 fix.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`) -- the 3 `CYCLE-002-PROCESS-GAP-DEFERRAL` items above are candidates for future stories in this same epic.
