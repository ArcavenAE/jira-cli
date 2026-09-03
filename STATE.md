---
document_type: pipeline-state
level: ops
version: "3.53"
status: active
producer: state-manager
timestamp: 2026-09-03T16:48:00Z
phase: F1
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-453 latest brownfield (unchanged). trajectory-tail →1→3→0→2 (unchanged this burst). cycle-004 windows-correctness OPENED (Feature Mode) — bundle: #759 Windows OAuth blob-size fix (DPAPI-file fallback + honest-fail, strategy validated by research) + #760 Windows docs. Phase F1 delta-analysis DISPATCHED. develop @ 42e92b46."
trajectory_tail: "→1→3→0→2"
maintenance_run:
  status: COMPLETE
  date: 2026-08-25
  findings_count: 10
  fixes_applied: 6
  fixes_pending: 4
  pr: 737
current_cycle: "cycle-004"
feature_mode_bundle: windows-correctness
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: SOH-ATTACHMENTS-1 F5 SCOPED ADVERSARIAL CONVERGED 2026-07-24 STRICT (14 rounds; window pass-12/pass-13/pass-14 CLEANx3; spec v1.3.99 to v1.3.106; BC-INDEX v6.38 to v6.44; develop @ db207b81) + F7 DELTA CONVERGENCE APPROVED 2026-07-25 (DEC-186; 5-dim PASS; MAXIMUM_VIABLE_REFINEMENT_REACHED) + CYCLE FULLY CLOSED 2026-07-25
cycle_001_status: "list-read-ergonomics -- CLOSED (DEC-309), historical; see cycles/cycle-001/"
cycle_002_status: "field-dx -- CLOSED + RELEASED 2026-09-01 (DEC-311 close; v0.7.0-dev.3 tagged @ 87f17aff, release.yml run 33459579699 triggered). All 5 stories delivered/merged (F4); F5 CONVERGED (FIX-F5-001, PR #747); F6 COMPLETE (FIX-F6-001, PR #749); F7 COMPLETE (5-dim convergence PASS + full regression PASS 4660/0/106, FIX-F7-001, PR #750 @ 2000c455); RELEASED (version bump PR #751 @ 87f17aff, tag v0.7.0-dev.3 pushed, release.yml triggered). Pipeline SHIPPED."
cycle_003_status: "auth-profile-dx -- CLOSED + RELEASED 2026-09-03 (v0.7.0-dev.4 @ 42e92b46, PR #767; release.yml run 33769389700 SUCCESS; GitHub prerelease published, 10 assets/5 targets). F1-F7 complete + released. Pipeline shipped."
cycle_004_status: "windows-correctness -- OPEN, Phase F1 delta-analysis DISPATCHED 2026-09-03 (DEC-334). Bundles GitHub #759 (Windows OAuth CredWriteW 2560-byte blob-limit fix: keyring-first + DPAPI-encrypted-file fallback for oversized access+refresh tokens + honest-fail backstop) + #760 (Windows README/docs: install guidance, config-path table, cloud_id caveat)."
activation_head: "42e92b46"
activation_version: "v0.7.0-dev.4"
---

<!-- STATE.md SIZE BUDGET (2026-09-03, cycle-004 OPEN burst / Burst 1):
     276 lines (wc-l) -- shrank 13 lines from the prior burst's 289: one new
     Phase Progress row, a reset (shorter) Current Phase Steps table, one
     new DEC-334 row plus a collapsed older-decisions summary line, updated
     Convergence Status/Concurrent Cycles/Constraints Carried Forward prose,
     a replaced (shorter) Session Resume Checkpoint, and one new
     cycle-004-scoped Drift/Standing note; no new structural section added.
     soft-target 200; hard cap 500. margin from soft-target = 76 -- 76 lines
     OVER the soft target of 200. margin from actual (hard cap) = 224 lines
     of headroom remain before the hard cap of 500.
     This burst records cycle-004 (`windows-correctness`) OPENING: human
     triaged two Windows GitHub issues (#759, #760, both @aparajit0) against
     the just-released v0.7.0-dev.4 and authorized a new Feature-Mode cycle
     bundling both as one "Windows correctness" fix. #759 = OAuth login
     always fails on Windows because the access/refresh token exceeds
     Windows Credential Manager's CredWriteW 2560-byte blob cap (UTF-16 ->
     ~1280 char ceiling); `store_oauth_tokens` (src/api/auth.rs) has no size
     handling today. A pre-cycle research pass
     (research/win-oauth-keychain-blob-limit-2026-09-03.md) validated the
     fix strategy: keyring-first + a user-scope DPAPI-encrypted-file
     fallback under %LOCALAPPDATA% for oversized secrets (both access AND
     refresh tokens, atomic), PLUS a ship-now honest-fail backstop (match
     `keyring::Error::TooLong`, replace the misdirecting "Unlock your
     keychain" text at its ~4 sites in auth.rs, explicit dangling-grant
     revoke); chunking across multiple credential entries and scope-
     trimming were both evaluated and REJECTED (no peer precedent / not
     durable, respectively). #760 = stale Windows install guidance (README
     says no Windows asset ships / use a prerelease -- a Windows asset does
     ship per ADR-0016) + an unqualified config-path doc (README says
     ~/.config/jr/config.toml without noting the Windows
     %APPDATA%\jr\config.toml override) + a cloud_id auto-discovery caveat
     (overlaps the cycle-003 carried-forward A-PA-LOW-001 standing item).
     `phase` frontmatter -> F1; `pipeline` -> ACTIVE; `current_cycle` ->
     "cycle-004"; `feature_mode_bundle` -> "windows-correctness"; new
     `cycle_004_status` field added, `cycle_001_status`/`cycle_002_status`/
     `cycle_003_status` preserved unchanged (all three cycles remain
     CLOSED, historical). `activation_head`/`activation_version` held at
     42e92b46/v0.7.0-dev.4 (unchanged -- no develop-side commit this
     burst). New DEC-334 records the human's cycle-open authorization and
     the research-validated fix strategy (collision-checked: highest prior
     ID was DEC-333, no collision). Counts unchanged: 733 BCs / 41 VPs /
     106 holdout scenarios / 168 stories -- F1 does not create/modify specs;
     that begins at F2. All cycle-001/002/003 Drift/Standing items are
     carried forward verbatim, including the tracked cycle-003 non-blockers
     and the A-PA-LOW-001 cloud_id item -- flagged as overlapping #759/#760's
     docs scope. One full-content Write, no Edit chain (DEC-247). Hygiene:
     the four pre-existing-dirty/untracked files unrelated to this burst's
     explicit scope (`regression-state.json`, `sidecar-learning.md`, the
     modified `S-cycle3-env-tag` demo gif, and the untracked
     `research/win-oauth-keychain-blob-limit-2026-09-03.md` +
     modified `research/RESEARCH-INDEX.md`) remain uncommitted from before
     this burst started -- explicitly NOT staged, NOT committed this burst
     either; the research file/index are left for a future burst that
     explicitly dispatches research-artifact bookkeeping. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →1→3→0→2 (unchanged this burst) |
| **Last Updated** | trajectory-tail →1→3→0→2 (unchanged). CYCLE-OPEN burst (2026-09-03): human authorized a new Feature-Mode cycle, **cycle-004 (`windows-correctness`)**, bundling GitHub #759 (Windows OAuth CredWriteW blob-limit fix) + #760 (Windows docs). Phase F1 delta-analysis DISPATCHED. `develop` unchanged at `42e92b46`. cycle-001/002/003 remain CLOSED; cycle-004 is now the sole OPEN cycle. |
| **Current Phase** | Feature Mode cycle-004 (`windows-correctness`) -- **Phase F1 (delta analysis), IN PROGRESS.** cycle-001, cycle-002, and cycle-003 remain CLOSED, historical. |
| **Activation HEAD** | `42e92b46` (`develop` tip; unchanged this burst -- no develop-side commit, cycle-004 has not started implementation) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, cycles/cycle-003/burst-log.md, cycles/cycle-004/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| F6-TARGETED-HARDENING (cycle-003) | COMPLETE — PASS | 2026-09-03 | Automated quality gate PASS (no human gate) | Mutation 100% (28/28, 0 survivors); security 0 CRIT/HIGH/MED (1 LOW pre-existing yanked `chacha20`, not delta-introduced); regression 4763 passed/0 failed/157 ignored (all 112 integration binaries + lib unittests + doctests), clippy exit 0, fmt clean; Kani→proptest substitution 0 GAP (VP-AUTHDX-001..009 all covered); fuzz justified-skip. Full detail: `cycles/cycle-003/phase-f6-hardening/summary.md`. 0 FIX-F6 candidates. | 733 BCs unchanged; 41 VPs unchanged |
| F7-DELTA-CONVERGENCE (cycle-003) | APPROVED — CONVERGED | 2026-09-03 | human-approved F7 gate; 3-clean-passes bar confirmed satisfied at F5 | 5/5 dimensions PASS: spec-consistency, tests (regression 4763 passed/0 failed/157 ignored), implementation (mutation 100%, security 0 CRIT/0 HIGH), holdout evaluation (0.895), documentation. HIGH-3 (stale `docs/specs/multi-profile-auth.md`) + LOW-2 + LOW-3 resolved via docs PR #766 (squash commit `c9bb74f4`, CI `ci-gate` 15/15 green) per human directive, BEFORE release. Full detail: `cycles/cycle-003/phase-f7-convergence/delta-convergence-report.md`, `traceability-chain-delta.md`, `holdout-eval-delta.md`. | 733 BCs unchanged; 41 VPs unchanged |
| RELEASE v0.7.0-dev.4 (cycle-003) | RELEASED — SHIPPED | 2026-09-03 | human-authorized dev release; `release.yml` run `33769389700` SUCCESS | Human authorized "Proceed with the Dev release." Version-bump PR #767 squash-merged to `develop` (`c9bb74f4` → `42e92b46`); annotated tag `v0.7.0-dev.4` pushed at `42e92b46`; `release.yml` run `33769389700` concluded SUCCESS; GitHub prerelease published 2026-09-03T14:58:38Z with 10 assets (5 targets × archive+sha256: x86_64/aarch64 linux-gnu, x86_64/aarch64 apple-darwin, x86_64 windows-msvc). Cargo.toml/lock @ 0.7.0-dev.4; CHANGELOG [Unreleased] → [0.7.0-dev.4] - 2026-09-03. cycle-003 `auth-profile-dx` is now CLOSED. | PR #767 @ `42e92b46`; tag `v0.7.0-dev.4`; GitHub prerelease, 10 assets/5 targets — counts unchanged |
| **F1-DELTA-ANALYSIS (cycle-004)** | **IN PROGRESS** | 2026-09-03 | (feature-mode delta analysis) | #759 (Windows OAuth DPAPI-fallback+honest-fail) + #760 (Windows docs); research-validated strategy; dispatched architect | counts TBD |

## Current Phase Steps (cycle-004, Phase F1 delta-analysis)

| Step | Status | Notes |
|------|--------|-------|
| Human triage of #759 + #760 | DONE | Human bundled both Windows GitHub issues into one Feature-Mode cycle: cycle-004 `windows-correctness` |
| Pre-cycle research pass (#759 fix strategy) | DONE | `research/win-oauth-keychain-blob-limit-2026-09-03.md` — keyring-first + DPAPI-encrypted-file fallback validated as the peer-standard approach (git-credential-manager/azure-cli precedent); chunking and scope-trim rejected |
| DEC-334 recorded (fix-strategy authorization) | DONE | Human-decided strategy for #759 (DPAPI-file fallback + honest-fail backstop, both access+refresh tokens, atomic) + #760 bundling, recorded in Decisions Log |
| cycle-004 STATE.md + scaffolding bootstrap | DONE | STATE.md refreshed (one full-content Write); `cycles/cycle-004/burst-log.md` + `cycles/cycle-004/phase-f1-delta-analysis/` created; committed to factory-artifacts |
| F1 delta-analysis (architect) | DISPATCHED | Impact boundary, affected specs/stories/tests, and regression risk for #759 (DPAPI-fallback design) + #760 (docs) against `develop` @ `42e92b46` |

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-334 | Human authorized a new Feature-Mode cycle (cycle-004 `windows-correctness`) bundling GitHub issues #759 + #760. #759 fix strategy = keyring-first + user-scope DPAPI-encrypted file fallback (%LOCALAPPDATA%) for oversized OAuth access+refresh tokens (atomic) + honest-fail backstop (match `keyring::Error::TooLong`, accurate message, explicit grant-revoke); chunking and scope-trim rejected after research validation (`.factory/research/win-oauth-keychain-blob-limit-2026-09-03.md`). #760 (README Windows install + config-path + cloud_id caveat) bundled in | #759 is a live, high-impact defect on `v0.7.0-dev.4` — cycle-003 (DEC-313) just made OAuth the default at profile creation, so every fresh Windows OAuth login is affected; the research pass ruled out chunking (no peer precedent) and scope-trimming (not durable) before recommending the DPAPI-file peer-standard. #760 is a low-risk docs fix naturally bundled with the same Windows-correctness theme, and its cloud_id caveat overlaps a cycle-003 carried-forward standing item (`A-PA-LOW-001`) | F1 | 2026-09-03 | human |
| DEC-333 | Human authorized and executed the cycle-003 dev release **v0.7.0-dev.4** (version-bump PR #767 squash-merged to `develop` @ `42e92b46`, annotated tag `v0.7.0-dev.4` pushed, `release.yml` run `33769389700` concluded SUCCESS, GitHub prerelease published with 10 assets/5 targets). cycle-003 (`auth-profile-dx`) is now **CLOSED** | F7 (delta convergence) reached human-approved CONVERGENCE at DEC-332 with the one outstanding HIGH finding already resolved via a pre-release docs PR; the human then explicitly triggered the held release action, completing the cycle's final gate and closing it | RELEASE | 2026-09-03 | human |
| DEC-332 | cycle-003 F7 delta convergence HUMAN-APPROVED / CONVERGED (5-dim PASS: regression 4763/0/157, mutation 100%, holdout 0.895, security 0 CRIT/0 HIGH — zero regressions). Human directed HIGH-3 (stale `docs/specs/multi-profile-auth.md`) fixed via a docs PR before release — DONE (PR #766, squash commit `c9bb74f4`, CI `ci-gate` 15/15 green; LOW-2/LOW-3 also resolved in the same PR). RELEASE HELD pending an explicit human trigger (trigger arrived and was executed — see DEC-333) | F7 is the final human approval gate before release; the human elected to close out the one outstanding HIGH finding via a low-risk docs-only PR rather than deferring it past release, while still reserving the release trigger itself for a separate, deliberate action | F7 | 2026-09-03 | human |
| DEC-331 | Refined autonomous auto-merge policy (human-confirmed 2026-09-02, refines DEC-330): cycle-003 story PRs merge FULLY AUTONOMOUSLY — no human merge gate — when ALL of: (1) CI `ci-gate` green, (2) a reviewer (pr-reviewer) returns an explicit MERGE RECOMMENDATION on the final post-fix state, and (3) EVERY HIGH and MEDIUM finding is ADDRESSED (LOW/cosmetic non-blocking). Applied to Wave 4 PRs (#758, #761), Wave 5's PR #762, F5's PR #763/#764, and the F7-close docs PR #766 — all merged cleanly with zero human-pause events. The version-bump release PR #767 was human-authorized directly, not auto-merged under this policy | Operational note: the `gh pr merge` action itself was blocked by Claude Code's auto-mode permission classifier when agent-initiated (PR #757); a session permission rule for the merge command may be needed. **Reaffirmed at session-wrap (2026-09-02) and at every subsequent resume:** `gh pr merge`/push must run from the MAIN session, not via github-ops sub-agents, until this permission-classifier gap is resolved — this constraint carries forward into cycle-004 | F4/F5 | 2026-09-02 | human |
| (327 older cycle-003 + cycle-002/cycle-001 decisions) | DEC-330 through DEC-309 and earlier — unchanged this burst | — | F1-F7/historical | 2026-08-24…2026-09-03 | various — see `cycles/cycle-003/burst-log.md` Bursts 13-22 for the full listing |

**cycle-004 note (Burst 1, this burst):** DEC-334 is the only new decision this burst — cycle-open bookkeeping plus the human-decided #759 fix strategy. No F1 delta-analysis findings exist yet to generate further decisions; those land when the architect's report reaches the F1 human gate.

## Skip Log

| Step | Skipped? | Justification |
|------|----------|----------------|
| UX Spec (cycle-002) | yes | `jr` is a CLI-only product; field-dx bundle adds no UI surfaces. |
| DTU creation (cycle-002) | yes | `dtu_required: false` -- no external service behavior is being cloned by this bundle. |
| F5 secondary review-tier (Step 7, cycle-002) | yes | Every story already individually adversarially converged in F4; primary pass found only 1 low-likelihood MED + 4 LOW. |
| F6 Kani formal verification (cycle-002) | yes | Not set up in repo; proptest substitution justified (32/32 VPs covered, 0 GAP). |
| F6 cargo-fuzz (cycle-002) | yes | Not set up in repo; proptest arbitrary-input substitution justified (0 uncovered input surface). |
| F6 DTU adversarial testing / accessibility re-check (cycle-002) | yes | `dtu_required: false`; `feature_type: backend-cli`, no UI surface. |
| UX Spec (cycle-003) | yes | `jr` is CLI-only; auth-profile-dx confirmed no-UI-surface at F1/F2, same as cycle-002. |
| DTU creation (cycle-003) | yes | `dtu_required: false` -- no external service behavior is being cloned; auth flows target the real Atlassian OAuth/token endpoints already covered by existing DTU-not-required precedent. |
| Demo recording (cycle-003, Waves 4-5) | yes | Human decision (standing since post-PR#757): demos skipped for Wave 4's two stories and Wave 5's final story. |
| F6 Kani formal verification (cycle-003) | yes | Not set up in repo; proptest substitution justified — VP-AUTHDX-001..009 all covered, 0 GAP. |
| F6 cargo-fuzz (cycle-003) | yes | Not set up in repo; proptest arbitrary-input substitution justified, same precedent as cycle-002. |
| UX Spec (cycle-004, tentative) | tbd | `jr` is CLI-only; windows-correctness (keychain fallback + docs) is likely no-UI-surface -- confirm at F1/F2. |
| DTU creation (cycle-004, tentative) | tbd | Likely `dtu_required: false` -- #759's DPAPI-file fallback targets the OS keychain/filesystem, not a third-party service being cloned -- confirm at F1. |

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/<cycle>/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| (none currently open) | -- the DEC-namespace disambiguation question is tracked debt, not a hard blocker | -- | -- | -- | -- |

## Convergence Status

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): historical, unchanged this burst.

`cycle-002` (`field-dx`) F2-F7 COMPLETE, human-authorized at the F7 gate (DEC-311). **RELEASED 2026-09-01 as `v0.7.0-dev.3`.** Historical, unchanged this burst.

`cycle-003` (`auth-profile-dx`) F1-F7 all COMPLETE, human-approved at every gate. **RELEASED 2026-09-03 as `v0.7.0-dev.4`** (DEC-333). **cycle-003 is CLOSED** — SHIPPED, historical, unchanged this burst. Outstanding, non-blocking, carried to a future maintenance/self-improvement cycle: MED-1 (VP count, 41, unverified line-by-line), LOW-4/LOW-6 (doc nits), the 4-story template-compliance gap, the cycle-003 bookkeeping input-hash cascade (6 files), and the two S-7.02 process-gap deferrals (STORY-INDEX index-currency; story-template-compliance) — all recorded in `cycles/cycle-003/lessons.md` and Drift/Standing below.

`cycle-004` (`windows-correctness`) **OPEN — Phase F1 (delta analysis) IN PROGRESS.** Human authorized this cycle (DEC-334) to bundle GitHub #759 (Windows OAuth CredWriteW 2560-byte blob-limit fix — keyring-first + user-scope DPAPI-encrypted-file fallback for oversized access+refresh tokens, atomic, plus a ship-now honest-fail backstop) and #760 (Windows README/docs: install guidance, config/cache-path table, cloud_id caveat). F1 delta-analysis (architect) dispatched against `develop` @ `42e92b46`. Counts unchanged so far: **733 total BCs**, **41 total VPs**, **106 holdout scenarios**; `total_stories` unchanged at **168** — F1 does not add specs; new BCs/VPs for #759/#760 land at F2.

**cycle-004 is the sole cycle with open work.** cycle-001, cycle-002, and cycle-003 are all CLOSED. **Next:** F1 delta-analysis report → human F1 gate → F2 spec evolution.

## Concurrent Cycles

Four tracked cycles, **cycle-004 is the sole OPEN cycle — cycle-001, cycle-002, and cycle-003 are all CLOSED, no open work.** `cycle-001` is CLOSED, historical. `cycle-002` (`field-dx`) is **CLOSED + RELEASED** (2026-09-01), historical. `cycle-003` (`auth-profile-dx`) is **CLOSED + RELEASED** (2026-09-03, DEC-333) as **`v0.7.0-dev.4`** @ `42e92b46`, historical: F1-F7 all complete, all 7 stories merged, F5 CONVERGED, F6 PASS, F7 APPROVED — CONVERGED, RELEASED. `cycle-004` (`windows-correctness`) is **OPEN, Phase F1 IN PROGRESS** (DEC-334, 2026-09-03): bundles #759 (Windows OAuth DPAPI-fallback + honest-fail) + #760 (Windows docs); `develop` unchanged at `42e92b46` (no implementation started). The standing auto-merge policy (DEC-330/DEC-331, fully autonomous when CI green + reviewer merge-recommendation + all HIGH/MED findings addressed) and the `gh pr merge`/push MAIN-session-only constraint both remain in effect for cycle-004's future story/fix PRs. **Pipeline is ACTIVE**; `phase` frontmatter is **F1**. **Next:** F1 delta-analysis (architect) → human F1 gate → F2 spec evolution.

## Constraints Carried Forward

**cycle-004 (windows-correctness, OPEN, F1 IN PROGRESS):** ADR-0016 (Windows build target: x86_64-pc-windows-msvc, AppData config/cache paths, Windows Credential Manager keyring via the `keyring` crate's `windows-native` feature, `.zip` packaging, CI) is the direct architectural predecessor this cycle extends. Windows Credential Manager isolation posture (SEC-WCM-DOC: OS-level user-session isolation is the trust boundary, `CRED_TYPE_GENERIC` entries) is unchanged by the DPAPI-file fallback design — the fallback file itself must inherit an equivalent or stronger isolation guarantee (user-scope `%LOCALAPPDATA%`, DPAPI-encrypted, i.e. OS-user-keyed). Research-validated fix strategy for #759 (`research/win-oauth-keychain-blob-limit-2026-09-03.md`, referenced by DEC-334): keyring-first + user-scope DPAPI-encrypted-file fallback for BOTH access and refresh tokens (atomic, not independently persisted), plus a ship-now honest-fail backstop matching `keyring::Error::TooLong` with an accurate message (replacing the misdirecting "Unlock your keychain" text at its ~4 sites in `src/api/auth.rs`) and explicit dangling-grant revoke; chunking across multiple credential entries and scope-trimming were both evaluated and REJECTED. #760's docs scope overlaps the cycle-003 carried-forward `A-PA-LOW-001` standing item (stale `cloud_id` survives an oauth→api_token switch) via its cloud_id auto-discovery caveat — F1/F2 should confirm whether #760's doc fix subsumes or merely documents around `A-PA-LOW-001`, or whether that item needs its own code fix in this cycle. `S-MAINT-532` and the 10-story SELF-IMPROVEMENT `S-PG-*` backlog remain explicitly OUT of cycle-004 scope (unchanged, pre-existing).

**cycle-003 (auth-profile-dx, historical — cycle CLOSED):** ADR-0006 (embedded OAuth app, fixed callback port 53682), ADR-0013 (PKCE deferral -- Atlassian 3LO does not support public-client PKCE as of 2026-05), SD-002 release gates (`JR_AUTH_HEADER`/`JR_BASE_URL` debug-only, release binaries ignore them), single-use refresh tokens + `refresh_coordinator.rs` per-profile single-flight, Windows Credential Manager posture (SEC-WCM-DOC), and the shared-vs-per-profile keychain invariant -- **fully restructured and IMPLEMENTED end-to-end, ALL 7 F3 stories delivered, F5 hardening CONVERGED, F6 COMPLETE/PASS, F7 APPROVED/CONVERGED, RELEASED as v0.7.0-dev.4, cycle CLOSED:** DEC-315's design, migration mechanism finalized as no-copy detect-and-instruct (DEC-326, IMPLEMENTED via `S-cycle3-credential-absence-guard`), full-delete-vs-session-clear semantics (DEC-322, IMPLEMENTED via `S-cycle3-remove-logout-semantics`), the `Profile` newtype hard-fence (ADR-0011, IMPLEMENTED + APPLIED via `S-cycle3-adr0011-newtype`), the OAuth-default-at-creation flow + `--api-token` flag + non-interactive env-var guard (DEC-313/323/327, IMPLEMENTED via `S-cycle3-oauth-default-creation`), and DEC-321's refresh-override removal + I-6 relogin-then-replace (IMPLEMENTED via `S-cycle3-chosen-flow-reconcile`, PR #762) — **no cycle-003 decision remains unimplemented.** `S-MAINT-532` remains explicitly out of cycle-003 scope (ratified at the F3 gate), a candidate for a future maintenance cycle. DEC-331 authorized fully-autonomous auto-merge for all cycle-003 story/fix PRs; the release version-bump PR #767 itself was human-authorized directly per DEC-333. **From Burst 16:** the `S-cycle3-chosen-flow-reconcile`-mirroring login-switch relogin-then-replace fix (PR #763), a locked-keychain refresh-error-swallow fix (PR #764 FIX-1), and two spec-only MED reconciliations (BC-1.1.016 and VP-AUTHDX-005/006/008); two non-blocking LOW follow-ups tracked (cache-guard traversal broadening; FIX-1 site-2 test) — carried to a future maintenance cycle, see `cycles/cycle-003/lessons.md`. **From Burst 20 (F7 PRE-GATE CONSISTENCY-AUDIT):** 12 findings (1 CRIT/3 HIGH/2 MED/6 LOW), all doc/index-layer; 6 fixed at audit time, HIGH-3/LOW-2/LOW-3 resolved at Burst 21 via docs PR #766, MED-1/LOW-4/LOW-6 and the 4-story template-compliance gap remain non-blocking outstanding, carried to a future maintenance cycle. **From Burst 21 (F7 CLOSE):** Phase F7 reached **APPROVED — CONVERGED** at the human gate (DEC-332); cycle-003-scoped input-hash bookkeeping re-converged (17 → 6 residual STALE files, documented as a non-blocking bookkeeping cascade); two S-7.02 process-gap deferral candidates recorded (STORY-INDEX index-currency gap; story-template-compliance gap). **From Burst 22 (RELEASE + CLOSE):** human authorized and executed the release — version-bump PR #767 squash-merged @ `42e92b46`, tag `v0.7.0-dev.4` pushed, `release.yml` run `33769389700` SUCCESS, GitHub prerelease published (10 assets/5 targets). `cycle_003_status` → CLOSED + RELEASED (DEC-333). The two S-7.02 process-gap deferrals are codified in `cycles/cycle-003/lessons.md`. All prior outstanding non-blocking items (MED-1, LOW-4, LOW-6, 4-story template-compliance gap, the 6-file bookkeeping cascade, `JR_OAUTH_CODE` seam hygiene, `{target:?}` Debug-quoting NIT, `auth list`/`auth status` STATUS divergence, F2-03/F2-04, the keychain-injection-seam for VP-coverage, **A-PA-LOW-001**, OBS-PB-1, `auth.rs:~1160` stale doc comment, `remove.rs` step-enumeration doc nit, `chacha20` 0.10.0 yanked-crate advisory) are carried forward verbatim, unresolved, targeted at a future maintenance/self-improvement cycle — **A-PA-LOW-001 is now additionally in cycle-004's direct scope-overlap set** (see the cycle-004 paragraph above) — full detail in Drift/Standing below and `cycles/cycle-003/lessons.md`.

## Session Resume Checkpoint

**Date:** 2026-09-03. **Position:** cycle-004 (`windows-correctness`), Phase F1 delta-analysis IN PROGRESS; `develop` @ `42e92b46`; pipeline **ACTIVE**. cycle-001, cycle-002, and cycle-003 remain CLOSED, historical, unaltered by this burst.

**Convergence counter:** cycle-004 F1 — no adversarial convergence trajectory yet (F1 is delta-analysis, not a review pass); begins tracking at F2/F5.

**What's new this burst:** Human triaged GitHub #759 (Windows OAuth CredWriteW 2560-byte blob-limit failure — access token exceeds the cap, `store_oauth_tokens` has no size handling) and #760 (stale Windows install docs + unqualified config path + cloud_id caveat), authorized cycle-004 (`windows-correctness`) to fix both as one bundle (DEC-334). A pre-cycle research pass (`research/win-oauth-keychain-blob-limit-2026-09-03.md`) validated the #759 fix strategy: keyring-first + user-scope DPAPI-encrypted-file fallback (`%LOCALAPPDATA%`) for oversized OAuth access+refresh tokens (atomic), plus a ship-now honest-fail backstop (match `keyring::Error::TooLong`, accurate message, explicit dangling-grant revoke); chunking and scope-trim were both rejected. STATE.md refreshed via one full-content Write (v3.52 → v3.53): frontmatter `phase`→F1, `pipeline`→ACTIVE, `current_cycle`→"cycle-004", `feature_mode_bundle`→windows-correctness, new `cycle_004_status` field; `activation_head`/`activation_version` unchanged (`42e92b46`/`v0.7.0-dev.4`, no develop-side commit yet). cycle-004 scaffolding created (`cycles/cycle-004/burst-log.md`, `cycles/cycle-004/phase-f1-delta-analysis/`).

**In-flight now:** F1 delta-analysis (architect) DISPATCHED against `develop` @ `42e92b46` — impact boundary, affected specs/stories/tests, and regression risk for the #759 + #760 bundle.

**Pending human decisions / policy in effect:** the F1 delta-analysis report, once produced, needs a human gate approval before F2 (spec evolution) can begin. The standing auto-merge policy (DEC-330/DEC-331) and the `gh pr merge`/push MAIN-session-only constraint (permission-classifier gap, unresolved) both carry forward into cycle-004's future story/fix PRs.

**Tracked non-blocking follow-ups carried forward verbatim (full detail `cycles/cycle-003/lessons.md` and Drift/Standing below):** all cycle-003 items (MED-1 VP count unverified; LOW-4/LOW-6 doc nits; 4-story template-compliance gap; the 6-file bookkeeping input-hash cascade; `JR_OAUTH_CODE` debug-gating; `{target:?}` Debug-quoting; `auth list`/`auth status` STATUS divergence; F2-03/F2-04; keychain-injection-seam for VP-AUTHDX coverage; **A-PA-LOW-001** — now also flagged as overlapping cycle-004's #760 docs scope; OBS-PB-1; `auth.rs:~1160` stale doc comment; `remove.rs` step-enumeration doc nit; `chacha20` 0.10.0 yanked-crate advisory; the two S-7.02 process-gap deferrals), plus all cycle-002 and cycle-001 standing items — carry ALL forward verbatim.

**NEXT on resume (exact):** F1 delta-analysis (architect) completes its report → human F1 gate → F2 spec evolution (`/vsdd-factory:phase-f2-spec-evolution`).

**Resume command:** `/vsdd-factory:next-step`.

**Superseded checkpoints:** the prior cycle-003 CLOSED+RELEASED checkpoint (v3.52, 2026-09-03 — recorded the dev release v0.7.0-dev.4 shipping and cycle-003's final close) is superseded in place by this checkpoint and queued for archival to `cycles/cycle-003/session-checkpoints.md`, alongside the still-pending v3.49/v3.50/v3.51 archival noted at the prior burst and v3.48 (F6-IN-PROGRESS), v3.47 (F5-CONVERGED/PAUSED), v3.46 (F5-FINDINGS-FIXED), v3.45 (F4-PHASE-COMPLETE), v3.44 (Wave-4-COMPLETE), v3.43 (Wave-3-COMPLETE), v3.42 (Wave-2-COMPLETE), v3.41 (Wave-1-COMPLETE), v3.40 (Wave-1-story-1-merged), v3.39 (F3-GATE-APPROVED/F4-ACTIVE), v3.38 (F3 authored/integrated, gate pending), v3.37 (F2-gate-approval/residual-sweep), v3.36 (F2 CONVERGED/PAUSED), v3.35 (SESSION-WRAP/PAUSED), v3.34 (F2-GATE-FIX-ROUND-COMPLETE), v3.33 (F2 authoring complete), v3.32 (F2 in progress), and v3.31 (F1-pending). Earlier archives (RELEASED/SHIPPED v3.29, F7-PASS/AWAITING-GATE v3.27, F6-COMPLETE v3.26, F5-COMPLETE v3.25, F4-COMPLETE v3.24, `WRAP-F4-WAVE2-COMPLETE-PAUSE` v3.23, and the SESSION-WRAP checkpoint) remain at `cycles/cycle-002/session-checkpoints.md`. The `list-read-ergonomics` cycle-001 CLOSED-position checkpoint (v3.05) remains archived at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-14 = F2/F3/F4; 15 = F5 CONVERGED + FIX-F5-001; 16 = F6 COMPLETE + FIX-F6-001; 17 = F7 delta-convergence analyses PASS + FIX-F7-001; 18 = F7 human gate APPROVED + cycle-002 CLOSED; 19 = release v0.7.0-dev.3 SHIPPED; 20 = SESSION-WRAP) |
| cycle-003 burst history | `cycles/cycle-003/burst-log.md` (Burst 1 = cycle OPENED; Bursts 2-9 = F1 through F3 gates; Bursts 10-15 = F4 Waves 1-5, all 7 stories merged; Burst 16 = F5 findings fixed; Burst 17 = SESSION WRAP, F5 CONVERGED; Burst 18 = SESSION RESUMED, F6 DISPATCHED; Burst 19 = F6 COMPLETE — PASS; Burst 20 = F7 pre-gate consistency audit; Burst 21 = F7 human gate APPROVED — CONVERGED (DEC-332); Burst 22 = RELEASE v0.7.0-dev.4 SHIPPED, cycle-003 CLOSED (DEC-333)) |
| cycle-004 burst history | `cycles/cycle-004/burst-log.md` (Burst 1 = cycle OPENED — DEC-334 recorded, #759+#760 bundle confirmed, F1 delta-analysis dispatched) |
| cycle-003 grounding artifacts | `cycles/cycle-003/investigation/auth-profile-current-state.md` (current-state map); `cycles/cycle-003/investigation/modern-cli-auth-profile-research.md` (modern-CLI research, 39 sources, 4 ranked recommendations) |
| cycle-003 F1 delta-analysis report | `cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md` (impact boundary, affected specs/stories/tests, regression risk; APPROVED at human gate) |
| cycle-003 F2 spec-evolution artifacts | `cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md`; `cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md` (ADR-0011 amendment — APPLIED via `S-cycle3-adr0011-newtype`) |
| cycle-003 F3 story-decomposition artifacts | `cycles/cycle-003/phase-f3-stories/` — `decomposition-manifest.md`, `S-cycle3-*.md` ×7, `dependency-graph-extended.md`, `wave-schedule.md`, `conflict-report.md`, `wave-holdout-scenarios/wave-{1..5}-holdout-scenarios.md` |
| cycle-003 F4 implementation artifacts | `cycles/cycle-003/phase-f4-implementation/regression-baseline.md`; `wave-1-integration-gate.md`; `wave-2-integration-gate.md` (Waves 3-5 had no standalone report, treated PASSED-implied) |
| cycle-003 F6 targeted-hardening artifacts | `cycles/cycle-003/phase-f6-hardening/summary.md`; `kani-results.md`, `fuzz-results.md`, `mutation-results.md`, `security-scan-results.md` |
| cycle-003 F7 delta-convergence artifacts | `cycles/cycle-003/phase-f7-convergence/consistency-audit-delta.md`; `delta-convergence-report.md`; `traceability-chain-delta.md`; `holdout-eval-delta.md` (score 0.895) |
| cycle-003 F7 close delivery evidence | `code-delivery/FIX-F7-DOCS-1/pr-review.md` (PR #766) — top-level `code-delivery/` path (project-wide accumulating convention, DF-030) |
| cycle-003 release delivery evidence | version-bump PR #767 (`develop` @ `42e92b46`); tag `v0.7.0-dev.4`; `release.yml` run `33769389700` (external to `.factory/`); GitHub prerelease (10 assets/5 targets, external to `.factory/`) |
| cycle-003 F4 story delivery evidence (all 7 stories) | `cycles/cycle-003/code-delivery/S-cycle3-{env-tag,percred-storage,credential-absence-guard,remove-logout-semantics,adr0011-newtype,oauth-default-creation,chosen-flow-reconcile}/` (demos + `pr-review.md` per story; Waves 4-5 skip demos per human decision) |
| cycle-003 F5 fix-PR delivery evidence | `code-delivery/FIX-F5-login-switch/pr-review.md` (PR #763); `code-delivery/FIX-F5-refinement/pr-review.md` (PR #764) |
| cycle-003 lessons learned | `cycles/cycle-003/lessons.md` (codifies the two S-7.02 process-gap deferrals as justified deferrals targeting a future SELF-IMPROVEMENT/maintenance cycle) |
| cycle-004 research grounding | `research/win-oauth-keychain-blob-limit-2026-09-03.md` (pre-cycle research validating the #759 fix strategy — file exists untracked in the worktree as of this burst; see Drift/Standing) |
| F5 scoped-adversarial review report (cycle-002) | `phase-f5-adversarial/adversarial-delta-review.md`; `phase-f5-adversarial/convergence-summary.md` |
| F6 targeted-hardening report (cycle-002) | `phase-f6-hardening/summary.md`; `kani-results.md`, `fuzz-results.md`, `mutation-results.md`, `security-scan-results.md` |
| F7 delta convergence report + traceability (cycle-002) | `phase-f7-convergence/delta-convergence-report.md`; `phase-f7-convergence/traceability-chain-delta.md`; `phase-f7-convergence/consistency-audit-delta.md`; `phase-f7-convergence/holdout-eval-delta.md`; `cycles/cycle-002/convergence/traceability-chain.md` (master) |
| cycle-001/cycle-002 convergence trajectory + session checkpoints + lessons + resolved blockers | `cycles/cycle-001/` and `cycles/cycle-002/` (see per-cycle files; cycle-002 session-checkpoints.md holds all prior F2-F7 + RELEASED + SESSION-WRAP checkpoints) |
| S-578-2/S-578-3/S-578-4 delivery artifacts | `cycles/cycle-002/S-578-2/`, `S-578-3/`, `S-578-4/` (red-gate-log.md, adversary-convergence-state.json); `code-delivery/S-578-2/`, `S-578-3/`, `S-578-4/` (pr-review.md, demos) |
| FIX-F5-001/FIX-F6-001/FIX-F7-001 delivery artifacts | `code-delivery/FIX-F5-001/`, `FIX-F6-001/`, `FIX-F7-001/` (pr-description.md, pr-review.md) |
| Release v0.7.0-dev.3 delivery artifacts | `code-delivery/release-v0.7.0-dev.3/` (pr-description.md, pr-review.md) |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**cycle-004 (this burst — CYCLE OPENED, Burst 1):** Human authorized cycle-004 (`windows-correctness`), bundling GitHub #759 (Windows OAuth CredWriteW 2560-byte blob-limit fix) and #760 (Windows docs) (DEC-334). Fix strategy for #759 was validated by a pre-cycle research pass rather than derived at F1 — F1 delta-analysis (dispatched this burst) still needs to confirm the impact boundary (which BCs/stories/tests are touched, e.g. `src/api/auth.rs::store_oauth_tokens`/`load_oauth_tokens`, ADR-0016, SEC-WCM-DOC) before F2 spec authoring begins. **New note this burst:** #760's cloud_id auto-discovery caveat directly overlaps the cycle-003 carried-forward standing item **A-PA-LOW-001** (stale `cloud_id` survives an oauth→api_token switch → `jr assets` sends Basic auth to the OAuth gateway → 401 instead of a clean error) — F1/F2 should determine whether #760's docs-only fix is sufficient or whether `A-PA-LOW-001` needs an accompanying code fix folded into this cycle. **Hygiene note (carried forward, unresolved):** the untracked `research/win-oauth-keychain-blob-limit-2026-09-03.md` and the modified `research/RESEARCH-INDEX.md` (presumably from the same pre-cycle research pass) remain uncommitted as of this burst — explicitly NOT staged this burst (this burst's dispatched scope was STATE.md + cycle-004 scaffolding only); a future burst should either commit them alongside the F1 report or confirm they are redundant with content already captured elsewhere.

**cycle-003 (RELEASE + CLOSE, historical):** Human authorized and executed the cycle-003 dev release (DEC-333): version-bump PR #767 squash-merged to `develop` (`c9bb74f4` → `42e92b46`), annotated tag `v0.7.0-dev.4` pushed, `release.yml` run `33769389700` concluded SUCCESS, GitHub prerelease published 2026-09-03T14:58:38Z with 10 assets across 5 targets. **cycle-003 (`auth-profile-dx`) is CLOSED.** Per the S-7.02 cycle-closing checklist, both process-gap deferral candidates are confirmed present as justified deferrals (target: a future SELF-IMPROVEMENT/maintenance cycle) and are codified in `cycles/cycle-003/lessons.md`: (1) `STORY-INDEX.md` was frozen at F3 and never updated through F4/F5/F6 execution — an index-currency process gap; (2) the story-template-compliance gap (4 of 7 story files missing the `level` frontmatter key plus the Architecture Mapping / Purity / Library sections). **All prior outstanding, non-blocking items carried forward verbatim:** MED-1 (VP count, 41, still not independently re-verified line-by-line), LOW-4 (BC-INDEX title paraphrase), LOW-6 (env-flag scope-boundary note), the 4-story template-compliance gap, and the 6-file cycle-003 bookkeeping input-hash cascade — none of these block cycle-004; all deferred to a future maintenance/self-improvement cycle.

**cycle-003 (F7 CLOSE, HUMAN-APPROVED/CONVERGED, historical):** Human approved Phase F7 delta convergence as CONVERGED (5/5 dimensions PASS: regression 4763/0/157, mutation 100%, holdout evaluation 0.895, security 0 CRITICAL/0 HIGH; zero regressions). HIGH-3 + LOW-2 + LOW-3 RESOLVED via docs PR #766 (squash commit `c9bb74f4`): `docs/specs/multi-profile-auth.md` reconciled, `logout.rs` stale comment fixed, CLAUDE.md DEC-322 notice documented; CI `ci-gate` PASS 15/15. `develop` HEAD advanced `202414f2` → `c9bb74f4` → `42e92b46` (release). **Outstanding, unchanged:** MED-1, LOW-4, LOW-6, and the 4-story template-compliance gap.

**cycle-003 (bookkeeping input-hash cascade, non-blocking, historical):** Three targeted `compute-input-hash --update` passes over files under `.factory/cycles/cycle-003/` reduced cycle-003 STALE files from 17 to 6, but did not reach 0 due to a genuine circular-dependency cascade among `phase-f7-convergence/consistency-audit-delta.md` and, under `phase-f3-stories/`, `wave-holdout-scenarios/wave-{1,3,4}-holdout-scenarios.md`, `dependency-graph-extended.md`, and `wave-schedule.md`. Documented per the orchestrator's explicit 3-pass stop condition; non-blocking, distinct from `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` below.

**cycle-003 (F7 PRE-GATE CONSISTENCY AUDIT, historical):** A fresh-context consistency audit ahead of the F7 human gate found 12 findings (1 CRITICAL / 3 HIGH / 2 MEDIUM / 6 LOW), all documentation/index-layer. All CRITICAL/HIGH/most-MED findings FIXED (CRIT-1 STORY-INDEX staleness, HIGH-1/HIGH-2 AC-trace staleness, MED-2 wave-label drift, LOW-1 overclaim correction, LOW-5 stale story-count headline, plus HIGH-3/LOW-2/LOW-3 via docs PR #766). **Still OUTSTANDING, non-blocking, carried to a future maintenance cycle:** MED-1 (VP count 41, unverifiable-not-wrong); LOW-4/LOW-6 (documentation nits, full detail `cycles/cycle-003/phase-f7-convergence/consistency-audit-delta.md`). **Non-blocking standing item:** 4 of 7 cycle-003 story files missing the story-template `level` frontmatter key and Architecture Mapping/Purity/Library sections — pre-existing template-compliance gap, does not block any shipped story. Full detail: `cycles/cycle-003/burst-log.md` Burst 20.

**cycle-003 (Bursts 16-19, historical, resolved within cycle-003):** F5 findings (login-switch relogin-then-replace MED, refresh locked-keychain error-swallow MED, logout unset-`auth_method` handling, comment-accuracy nits, `clear_profile_cache` empty-guard, BC-1.1.016↔DEC-321 spec reconciliation) all RESOLVED via PR #763/#764. MED-2 (VP-AUTHDX-005/006/008 keyring-gated coverage-boundary) ADDRESSED (spec now states the CI-coverage boundary explicitly) but the underlying gap (no in-CI real-keychain coverage) remains open, carried to a future maintenance cycle — **directly relevant to cycle-004's #759 fix**, since the DPAPI-file fallback path will need its own keychain-injection-seam consideration for CI coverage. F6 (targeted hardening) reached GATE VERDICT PASS: mutation 100% (28/28), security 0 CRIT/0 HIGH/0 MED (1 pre-existing LOW `chacha20` advisory), regression GREEN (4763/0/157), Kani-substitution 0 GAP, fuzz justified-skip. **Two LOW follow-ups from PR #764's AI review, non-blocking, carried forward:** (a) broaden the `clear_profile_cache` guard to reject `.`/`..`/traversal components; (b) add an explicit regression test for FIX-1 call-site-2. **Kept OPEN, unchanged, carried forward:** `JR_OAUTH_CODE` debug-gating (LOW/MED seam hygiene); the `{target:?}` Debug-quoting NIT (LOW); the `auth list`/`auth status` STATUS divergence (deferred cosmetic, pre-existing); F2-03 (auth_header resolution efficiency, LOW); F2-04 (non-atomic config write, LOW/MED); the `remove.rs` step-enumeration doc-comment nit (LOW). **Still uncommitted, unrelated to any cycle, noted at every burst since before this session:** `regression-state.json`, `sidecar-learning.md`, and the modified `S-cycle3-env-tag` demo gif remain uncommitted — left untouched again this burst per explicit instruction.

**cycle-003 (earlier F4/F3/F2 resolutions, historical, not listed here as open):** F1 (BYO-OAuth-cred over-delete on `auth refresh`) and the adr0011 doc-drift LOW item are CLOSED (Burst 15). The ADR-0011-staged-not-applied item is CLOSED (Burst 14) — `S-cycle3-adr0011-newtype` (PR #758) applied the staged amendment. DEC-NAMESPACE-COLLISION-RISK remains clean (max allocated ID DEC-334, no collision this burst). `S-cycle3-remove-logout-semantics`'s SEC-1 HIGH finding and DEC-331's recording are historical (Burst 13). Wave 1/2 integration gates PASSED (Bursts 11/12); all F2/F3-gate residuals FIXED/RATIFIED (Bursts 7/8/9); `S-cycle3-env-tag`, `S-cycle3-percred-storage`, `S-cycle3-credential-absence-guard`, `S-cycle3-remove-logout-semantics` all squash-merged (Bursts 10-13). `STORY-INDEX.md`'s pre-existing grep-count discrepancy note (a naive unique-`S-*`-ID scan returning ~165 distinct IDs against `total_stories: 168`) remains still-open, very likely counting-methodology noise, not root-caused — flagged for a future maintenance pass.

**Still open (2026-09-02, cycle-003 Wave 1 adversary, standing drift, not a cycle blocker):** `auth status` (a documented read-only probe) can transitively trigger the OAuth `"default"`-profile lazy-migration WRITE via `load_oauth_tokens` — pre-existing OAuth behavior, unrelated to cycle-003's per-credential redesign. Tracked here for future maintenance-cycle attention.

**Still open (2026-09-01, cycle-002 F7 human gate + S-7.02 cycle-closing checklist -- justified deferral, carried forward unchanged):**
- `CYCLE-002-PROCESS-GAP-DEFERRAL-1/2/3` (all LOW, justified deferral — no follow-up story exists in STORY-INDEX; target: a future SELF-IMPROVEMENT maintenance cycle). Full detail: `cycles/cycle-002/lessons.md` Process-Level items 3/4/5.

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
- **A-PA-LOW-001** (stale `cloud_id` survives oauth→api_token switch → `jr assets` sends Basic auth to the OAuth gateway → 401 instead of a clean error) — **now flagged as overlapping cycle-004's #760 docs scope; see the cycle-004 note above.**
- **OBS-PB-1** (`auth status` credential probe `.is_ok()` swallows a genuine keyring backend error into "not found").
- `auth.rs:~1160` stale doc comment; `remove.rs` step-enumeration doc nit; `chacha20` 0.10.0 yanked-crate advisory (routine `cargo update -p chacha20` at next maintenance sweep).

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- ~142 historical stale `input-hash` artifacts factory-wide; standing debt, **not** a cycle blocker.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`) -- the 3 `CYCLE-002-PROCESS-GAP-DEFERRAL` items, plus cycle-003's 2 S-7.02 process-gap deferral candidates (codified in `cycles/cycle-003/lessons.md`), are candidates for future stories in this same epic.
