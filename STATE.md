---
document_type: pipeline-state
level: ops
version: "3.26"
status: active
producer: state-manager
timestamp: 2026-08-31T16:20:00Z
phase: F6
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-453 latest brownfield (unchanged). trajectory-tail →1→3→0→2 (unchanged this burst). F6 (targeted hardening) COMPLETE: formal verification (proptest substitute, 32/32 VPs, 0 GAP), fuzz (proptest substitute, 0 uncovered surface), mutation (config gap fixed+merged as FIX-F6-001 PR #749 @ dd311e13; numeric run 0 MISSED / 93/93 = 100% conclusive kill rate on the 2 newly-covered files; ≥90% via CI on the rest), security scan (CLEAN, 3 LOW non-blocking), full regression PASS (4660/0/106). NEXT: Phase F7 (5-dimensional delta convergence + full-tree regression), then the FINAL HUMAN GATE to close cycle-002. Full detail: cycles/cycle-002/burst-log.md Burst 16 + phase-f6-hardening/summary.md."
trajectory_tail: "→1→3→0→2"
maintenance_run:
  status: COMPLETE
  date: 2026-08-25
  findings_count: 10
  fixes_applied: 6
  fixes_pending: 4
  pr: 737
current_cycle: "cycle-002"
feature_mode_bundle: field-dx
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: SOH-ATTACHMENTS-1 F5 SCOPED ADVERSARIAL CONVERGED 2026-07-24 STRICT (14 rounds; window pass-12/pass-13/pass-14 CLEANx3; spec v1.3.99 to v1.3.106; BC-INDEX v6.38 to v6.44; develop @ db207b81) + F7 DELTA CONVERGENCE APPROVED 2026-07-25 (DEC-186; 5-dim PASS; MAXIMUM_VIABLE_REFINEMENT_REACHED) + CYCLE FULLY CLOSED 2026-07-25
cycle_001_status: "list-read-ergonomics -- CLOSED (DEC-309), historical; see cycles/cycle-001/"
cycle_002_status: "field-dx -- Phase F6 (targeted hardening) COMPLETE 2026-08-31. All 5 stories delivered/merged (F4); F5 CONVERGED (FIX-F5-001, PR #747). F6: formal/fuzz proptest-substitute PASS (0 GAP), mutation config gap fixed+merged (FIX-F6-001, PR #749 @ dd311e13; 0 missed / 100% conclusive kill), security CLEAN (3 LOW non-blocking), full regression PASS (4660/0/106). NEXT: Phase F7 (delta convergence + human gate). Resume via /vsdd-factory:next-step."
activation_head: "dd311e13"
activation_version: "v0.7.0-dev.2"
---

<!-- STATE.md SIZE BUDGET (2026-08-31, F6-close / F6->F7 transition burst):
     217 lines (wc-l). soft-target 200; hard cap 500.
     margin from soft-target = 217 - 200 = 17 -- 17 lines OVER the soft target of 200 (accepted this burst; F6-close narrative needs the extra detail, well within the hard cap).
     margin from actual (hard cap) = 500 - 217 = 283 lines of headroom remain before the hard cap of 500.
     This burst closes Phase F6 for cycle-002 (field-dx): targeted hardening
     (formal verification, fuzz testing, mutation testing, security scan, full
     regression) is COMPLETE. The one actionable finding from F6 -- a mutation
     `examine_globs` config-scope gap on `src/cli/field.rs` +
     `src/cli/issue/field_resolve.rs` -- was fixed and merged in-phase as
     FIX-F6-001 (PR #749, merge commit `dd311e13`, 2026-08-31), not deferred
     as tracked debt. A numeric mutation run on the two newly-covered files
     scored 142/177 mutants conclusively with 93 caught / 0 missed (100% kill
     rate on conclusively-scored mutants); the 38 timeouts + 35 unscored are
     documented host-contention artifacts, corroborated by the F6
     formal-verifier's independent static coverage pass finding 0
     test-quality-gap survivors. Security scan is CLEAN (3 LOW, none
     blocking). Full regression: 4660 passed / 0 failed / 106 ignored.
     Full consolidated record: `phase-f6-hardening/summary.md`
     (+ `kani-results.md`, `fuzz-results.md`, `mutation-results.md`,
     `security-scan-results.md` in the same directory). phase frontmatter
     field advances F5 -> F6 (F6 now COMPLETE); activation_head advances
     `4e4ae4f5` -> `dd311e13`; activation_version re-derived from Cargo.toml
     on develop @ dd311e13 -- confirmed unchanged at v0.7.0-dev.2 (FIX-F6-001
     is a `.cargo/mutants.toml` + policy-doc config-only change, no crate
     version bump). This burst also compacts STATE.md: the F4-WAVE-3 Phase
     Progress row and the pre-F6 Session Resume Checkpoint text are archived
     to cycles/cycle-002/burst-log.md (already fully narrated there, Bursts
     14-15) and cycles/cycle-002/session-checkpoints.md respectively --
     STATE.md keeps only the current F5-COMPLETE/F6-COMPLETE rows and the
     latest checkpoint. No BC/VP/holdout counts changed (719/32/106). One
     full-content Write, no Edit chain (DEC-247).
     Pre-compaction (pre-2026-08-25) full history remains at factory-artifacts commit 43f4a5e3. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →1→3→0→2 (unchanged this burst) |
| **Last Updated** | F6 COMPLETE / TRANSITION TO F7 (2026-08-31): trajectory-tail →1→3→0→2 (unchanged this burst). FIX-F6-001 merged (PR #749 @ dd311e13); F6 targeted hardening COMPLETE (formal/fuzz proptest-substitute PASS, mutation 0-missed after config fix, security CLEAN, full regression PASS). Phase advances F5 -> F6. NEXT: Phase F7 (delta convergence + human gate). |
| **Current Phase** | Feature Mode cycle-002 (`field-dx`, GH #580 + #578) -- **Phase F6 (targeted hardening) COMPLETE**. NEXT: **Phase F7 (delta convergence + human gate)** -- 5-dimensional check on the delta plus full-tree regression, then the FINAL HUMAN GATE to close cycle-002. cycle-001 remains CLOSED, historical. |
| **Activation HEAD** | dd311e13 (`develop` tip after PR #749/FIX-F6-001 merge; `v0.7.0-dev.2`) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| F5-SCOPED-ADVERSARIAL-COMPLETE | **CONVERGED** | 2026-08-31 | primary-adversary scoped review (F5 gate; secondary tier SKIPPED, justified) | Integrated field-dx delta (`91d04fe1..ae8514b8`, all 5 stories) reviewed as one unit. Zero CRITICAL/HIGH. 1 MEDIUM (`get_issue_types_for_project` pagination-termination gap) -> **FIX-F5-001 merged, PR #747 @ `4e4ae4f5`**. 4 LOW tracked non-blocking. Full report: `phase-f5-adversarial/adversarial-delta-review.md` + `phase-f5-adversarial/convergence-summary.md`. Full narrative: `cycles/cycle-002/burst-log.md` Burst 15. | pass 1: 5 findings (0 CRIT, 0 HIGH, 1 MED, 4 LOW) -> MED fixed, CONVERGENCE_REACHED |
| F6-TARGETED-HARDENING-COMPLETE | **COMPLETE** | 2026-08-31 | formal-verifier (formal/fuzz/mutation/security) + full regression, all checks PASS or justified substitution | Kani/fuzz: not set up -> justified proptest substitution, 32/32 VPs covered, 0 GAP, 0 uncovered input surface. Mutation: config gap (`field.rs`+`field_resolve.rs` absent from `examine_globs`) fixed & merged as **FIX-F6-001, PR #749 @ `dd311e13`**; numeric run 142/177 scored, **93 caught / 0 MISSED (100% conclusive kill)**; remaining 6 delta files ≥90% via per-PR CI. Security: CLEAN, 3 LOW (SEC-F6-1/2/3), none blocking. Full regression: 4660/0/106. Full report: `phase-f6-hardening/summary.md` (+ per-check files in same dir). Full narrative: `cycles/cycle-002/burst-log.md` Burst 16. | N/A (hardening phase, not adversary-pass-scored) |

## Current Phase Steps (cycle-002, phase F6→F7; last 5)

| Step | Status | Notes |
|------|--------|-------|
| F6 formal-verifier dispatched | **RUN** | Fresh-context, delta-scoped (`91d04fe1..4e4ae4f5`). Kani + fuzz + mutation + security scan, all against the field-dx bundle. |
| F6 formal/fuzz assessed | **PASS** | Kani/cargo-fuzz not set up -> justified proptest substitution per repo convention. 32/32 VPs covered (VP-578-016 PASS-with-intended-deferral), 0 GAP; all 3 named input surfaces have arbitrary-input no-panic proptest coverage. |
| FIX-F6-001 delivered + merged | **MERGED @ dd311e13** | PR #749. `.cargo/mutants.toml::examine_globs` gained `field.rs`+`field_resolve.rs` (18→20); policy §Scope citations updated (guard green, 69 pairs). Numeric run: 93/93 = 100% conclusive kill, 0 MISSED. |
| Security scan + full regression | **PASS** | `cargo deny`/`cargo audit` clean, 0 new deps, 3 LOW findings (none blocking). `cargo test`: 4660 passed / 0 failed / 106 ignored. |
| F6 phase closed | **COMPLETE** | `phase-f6-hardening/summary.md` written (consolidates all 4 checks). `activation_head` advanced `4e4ae4f5` → `dd311e13`. Phase frontmatter advanced F5 → F6. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-310 | Reverses DEC-188: `--field` alone on the platform `issue create` path no longer exits 64 -- resolves via `createmeta` instead (BC-3.3.010/BC-3.8.012) | Non-JSM `--field` support was the point of issue #578; the DEC-188 guard predates that scope and now blocks it needlessly | F2 | 2026-08-25/26 | product-owner; human (approved) |
| F-3 | D2 collision-guard extension to the JSM create path -- **RESOLVED: retain the pre-existing last-wins behavior**, no guard extension | BC-3.8.008's JSM dedicated-flag semantics already diverge from platform | F2 | 2026-08-26 | human (decided) |
| ADR-0019 | Context mechanism for `jr field options` is `createmeta` (PRIMARY platform) / requesttype-fields (PRIMARY JSM) / `editmeta` (FALLBACK); cascading-select delimiter is `>` | Ranked recommendation from `research/field-dx-context-mechanism-2026-08-25.md` | F1/F2 | 2026-08-25 (Accepted); amendments through round-6 | architect |
| DEC-309 (historical, cycle-001) | `list-read-ergonomics` cycle closure -- MAXIMUM_VIABLE_REFINEMENT_REACHED, human-authorized | F7 5-dimensional convergence PASS | F7 | 2026-08-24 | human (authorized) |

## Skip Log

| Step | Skipped? | Justification |
|------|----------|----------------|
| UX Spec (cycle-002) | yes | `jr` is a CLI-only product; field-dx bundle adds no UI surfaces. |
| DTU creation (cycle-002) | yes | `dtu_required: false` -- no external service behavior is being cloned by this bundle. |
| F5 secondary review-tier (Step 7) | yes | Every story already individually adversarially converged in F4; primary pass found only 1 low-likelihood MED + 4 LOW. Full justification: `phase-f5-adversarial/convergence-summary.md`. |
| F6 Kani formal verification | yes | Not set up in repo; proptest substitution justified (32/32 VPs covered, 0 GAP). `phase-f6-hardening/kani-results.md`. |
| F6 cargo-fuzz | yes | Not set up in repo; proptest arbitrary-input substitution justified (0 uncovered input surface). `phase-f6-hardening/fuzz-results.md`. |
| F6 DTU adversarial testing | yes | `dtu_required: false`. |
| F6 accessibility re-check | yes | `feature_type: backend-cli`, no UI surface. |

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/<cycle>/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| (none currently open) | -- the DEC-namespace disambiguation question is tracked debt, not a hard blocker | -- | -- | -- | -- |

## Convergence Status

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): historical, unchanged this burst.

`cycle-002` (`field-dx`) F2 CONVERGED (streak-6) and human-approved. F3 COMPLETE. F4 COMPLETE (all 3 waves, all 5 stories merged). F5 COMPLETE (primary-adversary CONVERGED, FIX-F5-001 merged). **F6 (targeted hardening) now COMPLETE** — formal verification and fuzz testing PASS via justified proptest substitution (0 GAP); mutation testing's `examine_globs` config gap fixed and merged in-phase as FIX-F6-001 (PR #749), numeric run 93/93 = 100% conclusive kill / 0 missed; security scan CLEAN (3 LOW, none blocking); full regression PASS (4660/0/106). No convergence loop open, nothing in-flight. **NEXT:** Phase F7 (delta convergence — 5-dimensional check on the delta + full-tree regression) → FINAL HUMAN GATE to close cycle-002. No BC/VP/holdout counts changed (719/32/106).

## Concurrent Cycles

Two tracked cycles. `cycle-001` is CLOSED, historical. `cycle-002` (`field-dx`) is ACTIVE, Phase F6 COMPLETE, queued to start Phase F7 (delta convergence + human gate). No greenfield or other concurrent cycle is in flight.

## Session Resume Checkpoint

**Date:** 2026-08-31. **Position:** Feature Mode cycle-002 (`field-dx`, GitHub issues #580 + #578) -- Phase **F6 (targeted hardening) COMPLETE** this burst. 5-story decomposition, full F1-F7 lifecycle, DTU not required.

**This burst:** F6 targeted hardening executed against the integrated field-dx delta (`91d04fe1..4e4ae4f5`) by the formal-verifier and security-reviewer agents. Kani (not set up) and cargo-fuzz (not set up) were both justifiably substituted with proptest per repo convention — 32/32 declared field-dx VPs have realizing proptest/unit/wiremock coverage, 0 GAP (VP-578-016 is an intended parity-PENDING deferral, not a gap); all 3 named input-parsing surfaces (`parse_field_kv`, `:asset` `WS:OBJ` split, `:option` cascading `>` split) have arbitrary-Unicode-input no-panic/no-malformed-JSON proptest coverage. Mutation testing surfaced one config-quality gap — `src/cli/field.rs` and `src/cli/issue/field_resolve.rs` (91+45 in-diff mutants, including the #1-priority resolution/dispatch hub) were absent from `.cargo/mutants.toml::examine_globs`, so the required CI mutation gate under-scoped the field-dx delta to 71/207 mutants. This was fixed and merged in-phase as **FIX-F6-001, PR #749, merge commit `dd311e13`** — both files added to `examine_globs` (18→20) with matching `docs/specs/cargo-mutants-policy.md` §Scope citations (Guard 2 green, 69 pairs). A numeric mutation run on the two newly-covered files (`cargo mutants --no-config --file src/cli/field.rs --file src/cli/issue/field_resolve.rs --jobs 3 --timeout 240`) scored 142/177 mutants conclusively: **93 caught, 0 MISSED** (100% kill rate on conclusively-scored mutants); the 38 timeouts + 35 unscored are documented host-contention artifacts (concurrent-agent load ballooned per-mutant build times to ~13 min), corroborated by the formal-verifier's independent static coverage pass finding 0 test-quality-gap survivors across the same functions. The 6 examine_globs-covered field-dx delta files (`create.rs`, `edit.rs`, `jsm_create.rs`, `issues.rs`, `requests.rs`, `editmeta.rs`) were already mutation-verified ≥90% via their own PR's required CI at merge time. Security scan: CLEAN — `cargo deny`/`cargo audit` both pass, 0 new dependencies, 0 CRITICAL/HIGH; 3 LOW findings documented (SEC-F6-1 CWE-617 unreachable invariant panic, SEC-F6-2 CWE-674 deserialization-time recursion cross-referencing the pre-existing `SEC-001-EDITMETA-RECURSION-GUARD` tracked item, SEC-F6-3 CWE-20 informational charset note, not injection/SSRF); FIX-F5-001's `MAX_CREATEMETA_PAGES` bound reconfirmed as a genuine CWE-400/770 fix. Full regression: PASS — 4660 passed / 0 failed / 106 ignored. `activation_head` advanced `4e4ae4f5` → `dd311e13`; `activation_version` re-derived from `Cargo.toml` on `develop` @ `dd311e13` — confirmed unchanged at `v0.7.0-dev.2` (config-only PR, no crate version bump). Phase frontmatter field advanced `F5` → `F6`. With all checks PASS/justified-substitution and the one actionable finding fixed in-phase, **Phase F6 is now COMPLETE**: consolidated record written to `phase-f6-hardening/summary.md`.

**F5 (prior, unchanged):** primary-adversary review CONVERGED (0 CRIT/HIGH, 1 MEDIUM fixed as FIX-F5-001/PR #747 @ `4e4ae4f5`, 4 LOW tracked non-blocking); secondary tier skipped, justified. Counts: 719 total BCs (BC-INDEX v6.82), 32 VPs, 106 holdout scenarios -- unchanged.

**NEXT on resume:** proceed to **Phase F7 (delta convergence)** — 5-dimensional convergence check on the field-dx delta (spec, tests, implementation, verification, documentation dimensions per the standard F7 rubric) plus full-tree regression validation — then the **FINAL HUMAN GATE** to formally close cycle-002. No implementation work is queued besides F7 itself.

**In-flight:** none. FIX-F6-001 is delivered and merged; no worktrees, PRs, or adversary convergence loops open.

**Infra observation carried forward:** the `github-ops` sub-agent has stalled on prior dispatches this cycle (dependency check, stale-verdict check, merge) without returning completion reports, though the underlying `gh`/`git` actions succeeded; pr-manager fell back to direct `gh`/`git` verification. Worth investigating before the next PR cycle if the pattern recurs. Prior environment notes (manual-merge requirement, `validate-pr-review-posted` hook loop on author-owned PRs, demo-recorder race, host CPU contention from concurrent agents affecting long-running `cargo-mutants`/`cargo test` invocations this F6 burst) remain relevant for any future story delivery or hardening pass in this repo.

**Pending human decisions / blockers:** none. Full-autonomous-run mandate stands for Phase F7 through the point of the FINAL HUMAN GATE itself.

**Resume command:** `/vsdd-factory:next-step` -- reads STATE.md and surfaces Phase F7 (delta convergence + human gate) as the next step for cycle-002.

**Superseded checkpoint:** the prior F5-COMPLETE checkpoint (v3.25, 2026-08-31, pre-F6) is superseded in place by this burst's F6-COMPLETE position above and archived to `cycles/cycle-002/session-checkpoints.md`, alongside the F4-COMPLETE (v3.24), pre-FIX-F5-001-F5-review-recorded (v3.24), and `WRAP-F4-WAVE2-COMPLETE-PAUSE` (v3.23, 2026-08-27) checkpoints. The `list-read-ergonomics` cycle-001 CLOSED-position checkpoint (v3.05) remains archived at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-6 = F2 adversary rounds; Burst 7 = streak-6 close; Burst 8 = F2 gate APPROVED + F2->F3; Burst 9 = F3 decomposition; Burst 10 = S-578-1 merged; Burst 11 = S-580-1 merged, WAVE 1 COMPLETE; Burst 12 = S-578-2 merged; Burst 13 = S-578-3 merged, WAVE 2 COMPLETE; Burst 14 = S-578-4 merged, WAVE 3 COMPLETE / F4 COMPLETE; Burst 15 = F5 CONVERGED + FIX-F5-001 merged, F5 COMPLETE; Burst 16 = F6 targeted hardening COMPLETE + FIX-F6-001 merged, transition to F7) |
| F5 scoped-adversarial review report | `phase-f5-adversarial/adversarial-delta-review.md` (raw pass-1 findings); `phase-f5-adversarial/convergence-summary.md` (F5 close record) |
| F6 targeted-hardening report | `phase-f6-hardening/summary.md` (consolidated); `kani-results.md`, `fuzz-results.md`, `mutation-results.md`, `security-scan-results.md` (per-check detail) |
| cycle-001 convergence trajectory | `cycles/cycle-001/convergence-trajectory.md` |
| cycle-001 session checkpoints | `cycles/cycle-001/session-checkpoints.md` |
| cycle-002 session checkpoints | `cycles/cycle-002/session-checkpoints.md` (all prior F2/F3/F4/F5/F6 checkpoints archived here) |
| cycle-001 lessons learned | `cycles/cycle-001/lessons.md` |
| cycle-002 lessons learned | `cycles/cycle-002/lessons.md` |
| cycle-001 resolved blockers | `cycles/cycle-001/blocking-issues-resolved.md` |
| S-578-2 delivery artifacts | `cycles/cycle-002/S-578-2/` (red-gate-log.md, adversary-convergence-state.json); `code-delivery/S-578-2/pr-review.md` |
| S-578-3 delivery artifacts | `cycles/cycle-002/S-578-3/` (red-gate-log.md, adversary-convergence-state.json); `code-delivery/S-578-3/pr-review.md` |
| S-578-4 delivery artifacts | `cycles/cycle-002/S-578-4/adversary-convergence-state.json`; `code-delivery/S-578-4/`; demo evidence at `.factory/demos/S-578-4/` |
| FIX-F6-001 delivery artifacts | `code-delivery/FIX-F6-001/` (pr-description.md, pr-review.md) |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**New (2026-08-31, F6 targeted hardening — `phase-f6-hardening/security-scan-results.md`):**
- `SEC-F6-1` (LOW, accepted-as-documented) -- `src/api/jsm/requests.rs::compose_asset_wire` invariant panic on a missing `:` separator; unreachable today (sole production caller always supplies a qualified value). Consider converting to a `Result`-propagated `JrError::Internal` in a future defense-in-depth pass.
- `SEC-F6-2` (LOW, accepted-as-documented) -- `AllowedValue.children` (new recursive field, `src/types/jira/editmeta.rs`) has no deserialization-time recursion-depth guard; runtime tree-walks are guarded at `MAX_FIELD_OPTION_DEPTH=256`, but raw `serde_json` deserialization depth is bounded only by the process stack. Cross-references the pre-existing `SEC-001-EDITMETA-RECURSION-GUARD` item below (not a duplicate — same underlying candidate).
- `SEC-F6-3` (LOW, informational) -- `:asset` `WORKSPACE` segment has no format/charset validation beyond non-emptiness; not an injection/SSRF vector (JSON-escaped via `serde_json::json!`, never concatenated into a URL). No fix required.

**Still open (2026-08-31, F5 scoped-adversarial review — `phase-f5-adversarial/convergence-summary.md`):**
- `F5-EDIT-GATEB-SHARE` (LOW) -- `edit.rs:155-193` Gate B not refactored onto the shared `detect_flag_field_overlap` helper (ADR-0019 §D2); only `create.rs` wired to it. Behavior correct, error strings consistent; deliberately out-of-scope for S-578-4.
- `F5-ISSUETYPE-CASEFOLD-SPLIT` (LOW) -- `field_resolve.rs::resolve_against_createmeta` (`eq_ignore_ascii_case`) vs. `field.rs` (`to_lowercase()`) diverge on issue-type name→id case-folding. Negligible (issue-type names near-always ASCII).
- `F5-VP578021-WEAK-NEGPIN` (LOW) -- `tests/issue_create_field.rs::test_vp_578_021_negative_pin_display_name_spelling_does_not_trip_guard` asserts only `!requests.is_empty()`, not exit-0/POST-body/last-wins residual.

**Still open (2026-08-27, S-578-3 / PR #742):**
- `S-578-3-SHARED-ASSET-VALIDATOR` (LOW) -- extract a shared `validate_asset_value` helper used by BOTH `field_resolve.rs::compose_asset_hint` (platform) and `jsm_create.rs::resolve_asset_field_l2` (JSM). Cross-referenced (not duplicated) by both the F5 review's and F6's `:asset` validator-duplication findings.
- `S-578-3-FIELDVALUESPEC-RELOCATION` (LOW, architectural) -- move `FieldValueSpec`/`FieldValueKind` from `cli/issue/create.rs` to a neutral `src/types/` module.
- `S-578-3-PR742-RESIDUAL-NITS` (LOW) -- residual pr-reviewer non-blocking nits on #742; details in `.factory/code-delivery/S-578-3/pr-review.md`.

**Still open (2026-08-27, S-578-2 / PR #741):**
- `SEC-001-EDITMETA-RECURSION-GUARD` (LOW, security-hardening follow-up) -- apply a MAX_ADF_DEPTH-style recursion-depth cap to `AllowedValue.children` serde deserialization in `src/types/jira/editmeta.rs`. F6 confirmed this remains open (SEC-F6-2 cross-reference above); candidate for a future dedicated hardening pass, not blocking F6/F7.
- `S-578-2-PR741-RESIDUAL-NITS` (LOW) -- 7 residual pr-reviewer NON-BLOCKING findings; details in `code-delivery/S-578-2/pr-review.md`.

**Still open (2026-08-26, PR #740 pr-reviewer NON-BLOCKING follow-ups):**
- `S-580-1-PR740-S1`/`S2`/`S3`, `S-580-1-PR740-N1`/`N2` (all LOW) -- pagination-truncation risk, untested fallback, test-naming, citation, CLAUDE.md tree gap. Tracked debt.
- `BC-3.3.010-CITATION-UPGRADE-ELIGIBLE` (LOW, spec-hygiene) -- eligible for upgrade to enforced symbol-form now that `get_createmeta_fields` is implemented and reused across S-580-1/S-578-4. Tracked, not blocking.

**Still open (unchanged from streak-6, LOW doc-hygiene, non-blocking):**
- `PRD-DELTA-ROUND2-STEP2A-STALE-NARRATION`, `PLATFORM-ASSET-WIRE-SHAPE-UNVERIFIED`, `M1-EDITMETA-STATUS-PERMISSION-CAVEAT`, `PRD-DELTA-SUMMARY-AMENDED-BC-COUNT-STALE` (all LOW) -- tracked for cycle close.

**Still open (2026-08-26):**
- `DEC-NAMESPACE-COLLISION-RISK` (LOW, process) -- flat `DEC-NNN` prefix shared by spec-authored and cycle-gate DECs, no central registry. Revisit at cycle-002 close.
- `BC-INDEX-GUARD-GAP`, `GUARD-SCOPE-COPY-PASTE-PATTERN`, `COUNT-RECONCILIATION-FORCED-CONSISTENCY-PATTERN` (all LOW/process, unchanged) -- logged in `cycles/cycle-002/lessons.md`.

**New (2026-08-25):** `HOLDOUT-COVERAGE-GAP-LIST-READ-ERGONOMICS-FLAGS` (LOW, missing holdouts for 4 flags); `STORY-INDEX-DECLARED-VS-FILE-COUNT-MISMATCH` (LOW, pre-existing, unrelated to field-dx). Candidate: reactivate vsdd-factory plugin rc.20 to rc.23.

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- ~145 historical stale `input-hash` artifacts factory-wide; standing debt, **not** a field-dx / cycle-002 item.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
