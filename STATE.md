---
document_type: pipeline-state
level: ops
version: "3.75"
status: active
producer: state-manager
timestamp: 2026-09-06T18:28:57Z
phase: "cycle-005 (adf-mentions) Phase F1 delta analysis APPROVED; Phase F2 (spec evolution) IN PROGRESS."
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
last_amended: "2026-09-06, v3.75, state-manager — Burst 1 (cycle-005): cycle-005 (adf-mentions, GitHub #674) OPENED; Phase F1 delta analysis APPROVED by human (DEC-344); duplicate F1 artifact-mapping.md reconciled (alternative decomposition folded into canonical as an F2 input note, duplicate + empty dir removed); Phase F2 spec evolution now IN PROGRESS."
current_step: "D-chain cite D-31 latest brownfield (unchanged). trajectory-tail →1→3→0→2 (unchanged this burst). Burst 1 of cycle-005 (2026-09-06): CYCLE OPEN + F1 APPROVED. Human requested a new feature-mode cycle: adf-mentions (GitHub #674) — convert markdown mentions ([~accountid:<id>] bracket form and @Name form) into ADF mention nodes on the write path, with a corresponding adf_to_text reverse-path update. F1 delta analysis dispatched (architect: delta-analysis.md + affected-files.txt; business-analyst: artifact-mapping.md). An orchestrator coordination error re-dispatched a second business-analyst run, producing a duplicate artifact-mapping.md; the two were diffed and reconciled — the duplicate's genuinely distinct proposals (a committed reverse-path BC-7.2.019 closing issue #202/NFR-O-I, and a 3-way @Name-resolution BC-X.7.007/008/009 split, plus VP-674-007..011) were appended to the canonical artifact-mapping.md as an 'Alternative decomposition (F2 input)' note; the duplicate file and its now-empty cycles/cycle-005/phase-f1-delta-analysis/ dir were removed. A pre-existing VP-count bookkeeping discrepancy surfaced during F1 (~177 raw-grepped VP ids vs STATE's tracked 55) was logged as VP-COUNT-RECONCILIATION, a non-blocking follow-up for a future maintenance cycle. Human then APPROVED the F1 scope in full (DEC-344): two mention input forms (bracket pure-conversion+preflight-validate; @Name effectful resolution), hard-error @Name no-match (exit 64) with \\@ escape + --no-mentions opt-out, ambiguous-match prompt/error-with-candidates, unique-match resolve+tag, attrs.text from resolved display name, wiring across comment add / issue create (platform) / issue edit / JSM issue create --request-type, reverse-path adf_to_text update, and a NEW human requirement for live-Jira E2E test coverage (controlled test account, self-cleaning per existing JSM-teardown/Drop-guard conventions). Architecture: pure find_mention_candidates/markdown_to_adf_with_mentions in adf.rs (existing markdown_to_adf kept as a thin 1-arg wrapper); effectful resolve_mentions in new src/cli/issue/mentions.rs. Phase advances F1→F2. Counts unchanged this burst (742/55/106/172); F1 estimate for F2 to finalize: ~750-751 BCs / ~61 VPs / 107-111 holdouts / 176-178 stories. cycle-001 through cycle-004 remain CLOSED, historical, unaltered — their Constraints-Carried-Forward/Drift-Standing-Items prose was condensed for length this burst (no content lost; full per-burst detail remains at each cycle's own burst-log.md). NEXT: dispatch Phase F2 spec evolution (architect/product-owner) to author binding BCs/VPs from the two F1 proposals."
trajectory_tail: "→1→3→0→2"
maintenance_run:
  status: COMPLETE
  date: 2026-08-25
  findings_count: 10
  fixes_applied: 6
  fixes_pending: 4
  pr: 737
current_cycle: "cycle-005"
feature_mode_bundle: adf-mentions
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: SOH-ATTACHMENTS-1 F5 SCOPED ADVERSARIAL CONVERGED 2026-07-24 STRICT (14 rounds; window pass-12/pass-13/pass-14 CLEANx3; spec v1.3.99 to v1.3.106; BC-INDEX v6.38 to v6.44; develop @ db207b81) + F7 DELTA CONVERGENCE APPROVED 2026-07-25 (DEC-186; 5-dim PASS; MAXIMUM_VIABLE_REFINEMENT_REACHED) + CYCLE FULLY CLOSED 2026-07-25
cycle_001_status: "list-read-ergonomics -- CLOSED (DEC-309), historical; see cycles/cycle-001/"
cycle_002_status: "field-dx -- CLOSED + RELEASED 2026-09-01 (DEC-311 close; v0.7.0-dev.3 tagged @ 87f17aff, release.yml run 33459579699 triggered). All 5 stories delivered/merged (F4); F5 CONVERGED (FIX-F5-001, PR #747); F6 COMPLETE (FIX-F6-001, PR #749); F7 COMPLETE (5-dim convergence PASS + full regression PASS 4660/0/106, FIX-F7-001, PR #750 @ 2000c455); RELEASED (version bump PR #751 @ 87f17aff, tag v0.7.0-dev.3 pushed, release.yml triggered). Pipeline SHIPPED."
cycle_003_status: "auth-profile-dx -- CLOSED + RELEASED 2026-09-03 (v0.7.0-dev.4 @ 42e92b46, PR #767; release.yml run 33769389700 SUCCESS; GitHub prerelease published, 10 assets/5 targets). F1-F7 complete + released. Pipeline shipped."
cycle_004_status: "windows-correctness -- CLOSED + RELEASED 2026-09-06 (DEC-343; v0.7.0-dev.5 @ 569d85a8, PR #777; release.yml run 34046676423 SUCCESS; GitHub prerelease published, 10 assets/5 targets). F1-F7 complete + released. Pipeline shipped."
cycle_005_status: "adf-mentions -- OPEN; Phase F1 delta analysis APPROVED (DEC-344, 2026-09-06); Phase F2 (spec evolution) IN PROGRESS. See phase-f1-delta-analysis/cycle-005/ + cycles/cycle-005/burst-log.md Burst 1."
activation_head: "569d85a8"
activation_version: "v0.7.0-dev.5"
---

<!-- STATE.md SIZE BUDGET (2026-09-06, cycle-005 Burst 1 -- CYCLE OPEN + F1 APPROVED;
     line count refreshed after this burst's Write):
     A new feature-mode cycle, cycle-005 (adf-mentions, GitHub #674), was opened this
     burst following cycle-004's release and close. F1 delta analysis (architect +
     business-analyst) ran; an orchestrator coordination error produced a duplicate
     business-analyst artifact-mapping.md, which was diffed against the canonical run
     and reconciled (the duplicate's distinct proposals folded into the canonical file
     as an "Alternative decomposition (F2 input)" note; the duplicate + its empty dir
     removed). Human APPROVED the F1 scope (DEC-344); phase advances F1->F2.
     To make room within budget for cycle-005's new content, the now fully-historical
     cycle-004 Constraints-Carried-Forward and Drift/Standing-Items paragraphs (Bursts
     3-22, previously kept as full per-burst narrative even after cycle-004 closed)
     were condensed into brief historical summary lines -- the exact compaction
     pattern already applied to cycle-003 when cycle-004 opened. No content was lost:
     full per-burst detail remains unchanged at cycles/cycle-004/burst-log.md (see
     Historical Content table). The per-burst Decisions-Log footnote paragraphs for
     cycle-004 Bursts 19-22 were likewise condensed to one historical line, since that
     detail is now fully covered by the condensed Constraints-Carried-Forward entry
     and the burst-log. Phase Progress table gained one new cycle-005 F1 row (all
     cycle-004 rows kept -- table is still well under its ~12-row budget). Current
     Phase Steps table fully replaced with cycle-005 Burst-1 steps (cycle-004's steps
     already archived at cycles/cycle-004/burst-log.md). Decisions Log gained DEC-344
     (kept in full, alongside DEC-343 as the direct predecessor); DEC-342 and older
     folded into the collapsed-older bucket. Session Resume Checkpoint replaced with
     the cycle-005 F1-APPROVED/F2-IN-PROGRESS position; the prior v3.74 CLOSED+RELEASED
     resting-state checkpoint was archived to cycles/cycle-004/session-checkpoints.md
     with a "Superseded at" note BEFORE this burst's new checkpoint was written.
     soft target 200 lines; hard cap 500 lines. 320 lines (wc-l) (this file, this
     Write). margin from soft-target = 320 - 200 = 120 (OVER the soft target;
     documented, ongoing known deviation across cycles-002/003/004/005, not a
     blocker). margin from actual = 500 - 320 = 180 (dual-margin form; headroom
     remains before the hard cap). Net effect vs. the pre-burst 360 lines: the
     cycle-004 historical-content compaction more than offset cycle-005's new content.
     RECOVERY CONTEXT: no crash this burst -- clean,
     immediate continuation from the cycle-004 CLOSED+RELEASED resting state within
     the same session; no in-flight work of any kind existed before this burst (no
     live sub-agents, no open PRs, no story worktrees, no open cycle).
     Factory lock: no factory_lock frontmatter block is present in this STATE.md and
     the lock-write/verify-sha-currency scripts are not provisioned in this repo --
     the renew/unlock step this burst is therefore a no-op, noted rather than
     fabricated. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →1→3→0→2 (unchanged this burst) |
| **Last Updated** | trajectory-tail →1→3→0→2 (unchanged this burst). Burst 1 of cycle-005 (2026-09-06) — **CYCLE OPEN + F1 APPROVED:** cycle-005 (`adf-mentions`, GitHub #674) OPENED; F1 delta analysis dispatched, a coordination-duplicate artifact reconciled, and Phase F1 human-**APPROVED** (**DEC-344**). Phase advances F1→F2 (spec evolution). `develop` unchanged this burst at `569d85a8` (F1/F2 are spec-only phases, no code merged). |
| **Current Phase** | Feature Mode cycle-005 (`adf-mentions`) — **Phase F1 (delta analysis) APPROVED; Phase F2 (spec evolution) IN PROGRESS.** cycle-001 through cycle-004 remain CLOSED, historical. |
| **Activation HEAD** | `569d85a8` (`develop` tip; unchanged this burst — cycle-005 has not started implementation) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, cycles/cycle-003/burst-log.md, cycles/cycle-004/burst-log.md, cycles/cycle-005/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| F6-TARGETED-HARDENING (cycle-004) | **COMPLETE** | 2026-09-05 | Kani/fuzz JUSTIFIED SKIP; mutation 97-100% on testable surface + tenant.rs 100%; security CLEAN; regression GREEN (DEC-341) | Scope: cycle-004 delta (`42e92b46`→`024de4d8`), info-asymmetry wall honored. Full detail: `phase-f6-hardening/cycle-004/summary.md`. | counts unchanged (742/55/106/172); F6 verdict **COMPLETE (DEC-341)** |
| F7-DELTA-CONVERGENCE (cycle-004) | **CONVERGED** | 2026-09-06 | 5-dimensional convergence check on the delta + full regression + Windows-verification gate satisfied via CI + final human gate PASSED (DEC-342) | All 5 automated dimensions PASS; Windows-11 DPAPI verification satisfied via `windows-latest` CI (PR #776 @ `135eb804`). Full detail: `cycles/cycle-004/burst-log.md` Burst 21. | counts unchanged (742/55/106/172); F7 verdict **CONVERGED (DEC-342)** |
| **RELEASE v0.7.0-dev.5 (cycle-004)** | **RELEASED — SHIPPED** | 2026-09-06 | human-authorized dev release; `release.yml` run `34046676423` SUCCESS | PR #777 squash-merged (`135eb804`→`569d85a8`); tag `v0.7.0-dev.5` pushed; GitHub prerelease published (10 assets/5 targets). cycle-004 (`windows-correctness`) is now CLOSED (DEC-343). | PR #777 @ `569d85a8`; tag `v0.7.0-dev.5` — counts unchanged |
| **F1-DELTA-ANALYSIS (cycle-005)** | **APPROVED** | 2026-09-06 | Human approved F1 delta analysis scope (DEC-344) | Feature: `adf-mentions` (GitHub #674), brownfield delta on the markdown→ADF write path. Scope: two mention forms (bracket `[~accountid:<id>]` pure conversion + preflight-validate; `@Name` effectful resolution via user search), reverse-path `adf_to_text` update, wiring across comment add / issue create (platform) / issue edit / JSM `issue create --request-type`. **New** live-Jira E2E test requirement added as an explicit F2+ design constraint (controlled test account, self-cleaning). Duplicate F1 `artifact-mapping.md` (business-analyst coordination re-run) reconciled: its distinct proposals (reverse-path BC-7.2.019 closing #202/NFR-O-I; 3-way `@Name` BC-X.7.007-009 split; VP-674-007..011) folded into the canonical `phase-f1-delta-analysis/cycle-005/artifact-mapping.md` as an "Alternative decomposition (F2 input)" note; duplicate + its now-empty dir removed. Tracked non-blocking follow-up logged: `VP-COUNT-RECONCILIATION`. Full detail: `phase-f1-delta-analysis/cycle-005/{delta-analysis.md,affected-files.txt,artifact-mapping.md}`. | counts unchanged (742/55/106/172); F1 estimate for F2: ~750-751 BCs / ~61 VPs / 107-111 holdouts / 176-178 stories |

## Current Phase Steps (cycle-005, F1 APPROVED / F2 IN PROGRESS; Burst 1)

| Step | Status | Notes |
|------|--------|-------|
| cycle-005 OPENED | **DONE** | Human requested a new feature-mode cycle: `adf-mentions` (GitHub #674), brownfield, `dtu_required: false`. |
| F1 delta analysis dispatched | **DONE** | architect (`delta-analysis.md` + `affected-files.txt`) + business-analyst (`artifact-mapping.md`) ran against `develop`; a coordination error produced a second business-analyst `artifact-mapping.md` run. |
| Duplicate F1 artifact reconciled | **DONE** | Diffed canonical vs. duplicate; the duplicate's distinct proposals (committed reverse-path BC-7.2.019 closing #202/NFR-O-I; 3-way `@Name` BC-X.7.007-009 split; VP-674-007..011) appended to the canonical `artifact-mapping.md` as an "Alternative decomposition (F2 input)" note; duplicate file + empty dir removed. |
| F1 delta analysis APPROVED | **DONE (DEC-344)** | Human approved F1 scope: two mention forms, hard-error `@Name` no-match with `\@` escape + `--no-mentions` opt-out, `attrs.text` from resolved display name, JSM wiring included, reverse-path update, **new** live-Jira E2E test requirement. |
| Phase F2 (spec evolution) dispatched | **IN PROGRESS** | Phase advances F1→F2; architect/product-owner to author binding BCs/VPs from the two F1 proposals (canonical + alternative decomposition note). |

(Prior cycle-004 burst steps — cycle OPENED through RELEASE + CLOSE (DEC-343) — archived in full to `cycles/cycle-004/burst-log.md` Bursts 1-22. Prior cycle-001/002/003 steps archived to their own `cycles/<cycle>/burst-log.md`.)

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-344 | Human **APPROVED** cycle-005 (`adf-mentions`, GitHub #674) Phase F1 delta analysis. Scope: markdown mentions → ADF mention nodes — bracket form `[~accountid:<id>]` (pure post-pass conversion + preflight-validate the accountId via `GET /rest/api/3/user?accountId=`) and `@Name` form (effectful resolution via user search); `@Name` no-match is a HARD ERROR (exit 64) with a `\@` escape and a `--no-mentions` opt-out; ambiguous match prompts (interactive) / errors-with-candidates (`--no-input`); unique match resolves+tags; `attrs.text` populated from the resolved display name; wiring includes JSM `issue create --request-type` (`handle_jsm_create`) alongside comment add / issue create (platform) / issue edit; reverse-path `adf_to_text` updated (affects BC-7.2.004, `issue view` rendering). **NEW human requirement:** live-Jira E2E test coverage (`tests/e2e_live.rs`, `JR_RUN_E2E`-gated) verifying a posted mention round-trips with the resolved accountId, against a controlled/designated test account only, self-cleaning per existing JSM-teardown/Drop-guard conventions. Architecture: pure `find_mention_candidates`/`markdown_to_adf_with_mentions` in `src/adf.rs` (existing `markdown_to_adf` kept as a thin 1-arg wrapper — zero blast radius on the ~275 adf tests); effectful `resolve_mentions` in new `src/cli/issue/mentions.rs` reusing `get_user`/`search_users` + `disambiguate_user` (needs a `pub(super)` bump). Classification: feature-type backend, intent feature, NOT trivial → full F1-F7. Story shape: Story A (pure bracket-form conversion), Story B (`@Name` effectful resolution + wiring incl. JSM), Story C (accountId preflight + `attrs.text`, foldable into B), plus E2E coverage as an explicit acceptance requirement across the wiring stories. Projected (F1 estimate, F2 to finalize): ~750-751 BCs / ~61 VPs / 107-111 holdouts / 176-178 stories; ~8-9 new BCs, 5 existing BCs MODIFIED (esp. BC-7.2.004), reusing BC-X.7.001 (user search) + BC-X.7.004 (disambiguation). Also **APPROVED** the reconciliation of a duplicate F1 artifact-mapping.md (orchestrator coordination error) — its distinct proposals preserved as an "Alternative decomposition (F2 input)" note rather than discarded. Phase advances F1→F2 | Human reviewed both F1 delta-analysis artifacts (`delta-analysis.md`, `affected-files.txt`, the reconciled `artifact-mapping.md`) and approved proceeding to spec evolution with the captured scope and design decisions above | F1 | 2026-09-06 | human (explicit approval) |
| DEC-343 | Human authorized and executed the cycle-004 dev release **v0.7.0-dev.5** (version-bump PR #777 squash-merged to `develop` @ `569d85a8`, annotated tag `v0.7.0-dev.5` pushed, `release.yml` run `34046676423` concluded SUCCESS, GitHub prerelease published with 10 assets/5 targets). cycle-004 (`windows-correctness`) is now **CLOSED** | F7 (delta convergence) reached human-authorized CONVERGENCE at DEC-342, with the Windows-verification gate already satisfied via CI (PR #776) and the final human gate passed; the human then explicitly triggered the release action, completing the cycle's final gate and closing it | RELEASE | 2026-09-06 | human (explicit authorization) |
| (344 older cycle-004/003/002/001 decisions) | DEC-342 through DEC-309 and earlier — unchanged this burst | — | F1-F7/historical | 2026-08-24…2026-09-06 | various — see `cycles/cycle-004/burst-log.md` Bursts 1-22 and `cycles/cycle-003/burst-log.md` Bursts 13-22 |

**cycle-004 note (historical, all bursts):** F1 APPROVED (DEC-335); F2 scoped adversarial convergence APPROVED (DEC-336); F3 story decomposition APPROVED (DEC-337); F4 COMPLETE (DEC-339); F5 CONVERGED (DEC-340); F6 COMPLETE (DEC-341); F7 CONVERGED (DEC-342); RELEASED + CLOSED (DEC-343). Full burst-by-burst decision detail: `cycles/cycle-004/burst-log.md` Bursts 1-22.

**cycle-005 note (Burst 1, this burst):** **DEC-344** (F1 APPROVED) recorded above. cycle-005 (`adf-mentions`, #674) OPENED this burst; F1 delta analysis reconciled (duplicate artifact removed, alternative decomposition preserved as an F2 input note) and approved by human. Phase advances F1→F2.

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
| DTU creation (cycle-003) | yes | `dtu_required: false` -- auth flows target the real Atlassian OAuth/token endpoints already covered by existing DTU-not-required precedent. |
| Demo recording (cycle-003, Waves 4-5) | yes | Human decision (standing since post-PR#757): demos skipped for Wave 4's two stories and Wave 5's final story. |
| F6 Kani formal verification (cycle-003) | yes | Not set up in repo; proptest substitution justified — VP-AUTHDX-001..009 all covered, 0 GAP. |
| F6 cargo-fuzz (cycle-003) | yes | Not set up in repo; proptest arbitrary-input substitution justified, same precedent as cycle-002. |
| UX Spec (cycle-004) | yes | `jr` is CLI-only; F1 delta-analysis explicitly confirmed `feature_type: backend (infrastructure; no UI)` across all 4 stories. |
| Demo recording (cycle-004, all 4 stories) | yes | Human decision this session: demos skipped for all cycle-004 stories (backend/Windows, no UI surface) — recorded at Burst 15, applies to Wave 1 and Wave 2 stories alike. |
| DTU creation (cycle-004) | yes | `dtu_required: false` — #759's DPAPI-file fallback targets the OS keychain/filesystem, not a third-party service being cloned; confirmed at F4, no reversal. |
| F6 Kani formal verification (cycle-004) | yes | Not set up in repo; proptest/unit substitution justified — VP-AUTHDX-010..023 (all 14 new cycle-004 VPs) covered, 0 GAP. |
| F6 cargo-fuzz (cycle-004) | yes | Not set up in repo; proptest arbitrary-input substitution justified — 0 uncovered input surface (DPAPI envelope, tenant_info parse+body-cap, profile-name guard, cloud_id plausibility). |
| F6 DTU adversarial testing / accessibility re-check (cycle-004) | yes | `dtu_required: false`; `tenant_info` is a real endpoint, not a cloned DTU; `feature_type: backend`, no UI surface. |
| REQUIRED manual Windows-11 physical smoke test (cycle-004, Burst 21) | superseded, not skipped | Human explicitly authorized the `windows-latest` CI runner (PR #776) as the verification path for the DPAPI-file round-trip mechanism instead of a physical machine — see DEC-342. Two residuals ((a) natural `TooLong` trigger, (b) live OAuth browser-consent flow) remain genuinely un-exercised and are recorded as explicitly descoped, not silently dropped. |
| DTU creation (cycle-005) | yes | `dtu_required: false` -- the feature targets Jira's own REST API user-search/mention surface (already-covered endpoints), not a cloned third-party service. |

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/<cycle>/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|

**No open blocking issues.**

## Convergence Status

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): historical, unchanged this burst.

`cycle-002` (`field-dx`) F2-F7 COMPLETE, human-authorized at the F7 gate (DEC-311). **RELEASED 2026-09-01 as `v0.7.0-dev.3`.** Historical, unchanged this burst.

`cycle-003` (`auth-profile-dx`) F1-F7 all COMPLETE, human-approved at every gate. **RELEASED 2026-09-03 as `v0.7.0-dev.4`** (DEC-333). **cycle-003 is CLOSED** — SHIPPED, historical, unchanged this burst.

`cycle-004` (`windows-correctness`) F1-F7 COMPLETE, human-authorized at every gate (DEC-335 through DEC-343). **RELEASED 2026-09-06 as `v0.7.0-dev.5`**; **CLOSED** — SHIPPED, historical. Full detail: `cycles/cycle-004/burst-log.md` Bursts 1-22.

`cycle-005` (`adf-mentions`) Phase **F1 (delta analysis) APPROVED** (DEC-344, 2026-09-06); Phase **F2 (spec evolution) IN PROGRESS.** Full detail: `phase-f1-delta-analysis/cycle-005/` + `cycles/cycle-005/burst-log.md` Burst 1.

**cycle-005 is the sole OPEN cycle** (Phase F2 in progress); cycle-001 through cycle-004 remain CLOSED, historical, unaltered this burst.

## Concurrent Cycles

Five tracked cycles. `cycle-001` is CLOSED, historical. `cycle-002` (`field-dx`) is **CLOSED + RELEASED** (2026-09-01), historical. `cycle-003` (`auth-profile-dx`) is **CLOSED + RELEASED** (2026-09-03, DEC-333) as **`v0.7.0-dev.4`** @ `42e92b46`, historical. `cycle-004` (`windows-correctness`) is **CLOSED + RELEASED** (2026-09-06, DEC-343) as **`v0.7.0-dev.5`** @ `569d85a8`, historical — F1-F7 all APPROVED/CONVERGED (DEC-335 through DEC-343); full detail `cycles/cycle-004/burst-log.md`. `cycle-005` (`adf-mentions`, GitHub #674) is **OPEN** — Phase F1 delta analysis **APPROVED** (DEC-344), Phase F2 (spec evolution) **IN PROGRESS**. `develop` @ `569d85a8` (`activation_head`, unchanged this burst — no code merged yet; F1/F2 are spec-only phases). The standing auto-merge policy (DEC-330/DEC-331, fully autonomous when CI green + reviewer merge-recommendation + all HIGH/MED findings addressed) and the `gh pr merge`/push MAIN-session-only constraint both remain in effect for cycle-005's future story/fix PRs. **Pipeline is ACTIVE** (cycle-005 open). **Next:** dispatch Phase F2 spec evolution (architect + product-owner) to author binding BCs/VPs from the two F1 decomposition proposals (canonical `phase-f1-delta-analysis/cycle-005/artifact-mapping.md`, including its "Alternative decomposition (F2 input)" note).

## Constraints Carried Forward

**cycle-005 (F1 APPROVED, Burst 1, this burst):** New feature-mode cycle opened: `adf-mentions` (GitHub #674), brownfield, `dtu_required: false`. F1 delta analysis (business-analyst + architect) produced two independent `artifact-mapping.md` runs due to an orchestrator coordination error — canonical retained at `phase-f1-delta-analysis/cycle-005/` (`delta-analysis.md` + `affected-files.txt` + `artifact-mapping.md`); duplicate at `cycles/cycle-005/phase-f1-delta-analysis/artifact-mapping.md` diffed against canonical. Duplicate's genuinely distinct proposals — a committed reverse-path `adf_to_text` render (**BC-7.2.019**) explicitly closing issue #202/NFR-O-I (canonical had left this as an open F2 decision under BC-7.2.004), a 3-way split of `@Name` resolution into **BC-X.7.007** (unique match)/**BC-X.7.008** (ambiguous)/**BC-X.7.009** (zero-match) (canonical proposed one shared-resolver BC-X.7.007), and **VP-674-007/008** (reverse-path render + round-trip property) plus **VP-674-009/010/011** (tied to the 3-way BC split and JSM visibility orthogonality) — were appended to the canonical `artifact-mapping.md` as an "**Alternative decomposition (F2 input)**" note; the duplicate file and its now-empty `cycles/cycle-005/phase-f1-delta-analysis/` directory were removed. Human then **APPROVED** the F1 scope (**DEC-344**): two mention input forms (bracket pure-conversion + preflight-validate; `@Name` effectful resolution), hard-error `@Name` no-match (exit 64) with `\@` escape + `--no-mentions` opt-out, `attrs.text` from resolved display name, wiring across comment add / issue create (platform) / issue edit / JSM `issue create --request-type`, reverse-path `adf_to_text` update, and a **NEW live-Jira E2E test requirement** (controlled test account, self-cleaning per existing JSM-teardown/Drop-guard conventions). Architecture: pure `find_mention_candidates`/`markdown_to_adf_with_mentions` in `src/adf.rs` (existing `markdown_to_adf` kept as a thin 1-arg wrapper); effectful `resolve_mentions` in new `src/cli/issue/mentions.rs` reusing `get_user`/`search_users` + `disambiguate_user` (needs a `pub(super)` bump). Story shape: Story A (pure bracket-form), Story B (`@Name` effectful resolution + wiring incl. JSM), Story C (accountId preflight + `attrs.text`, foldable into B), plus E2E coverage as an explicit acceptance requirement. Projected (F1 estimate): ~750-751 BCs / ~61 VPs / 107-111 holdouts / 176-178 stories. Phase advances F1→F2. **Tracked follow-up (non-blocking):** `VP-COUNT-RECONCILIATION` — a raw grep found ~177 VP ids across `bc-*.md` bodies vs STATE's tracked 55 VPs (pre-existing bookkeeping discrepancy the business-analyst surfaced during F1); logged for a future maintenance/self-improvement cycle, not resolved now. **Counts entering F2: 742 BCs / 55 VPs / 106 holdouts / 172 stories** (unchanged this burst — F1 is analysis-only, no spec content written yet).

**cycle-004 (RELEASE + CLOSE, historical):** Human authorized and executed the cycle-004 dev release (DEC-343): PR #777 squash-merged (`135eb804`→`569d85a8`), tag `v0.7.0-dev.5` pushed, `release.yml` run `34046676423` SUCCESS, GitHub prerelease published with 10 assets/5 targets. **cycle-004 is CLOSED.** F7 Windows-verification gate satisfied via `windows-latest` CI (PR #776, DEC-342, superseding a physical smoke test per human authorization). All prior outstanding non-blocking items carried forward verbatim (see "cycle-004 maintenance items" below); none block cycle-005; deferred to a future maintenance/self-improvement cycle.

**cycle-004 (earlier F1-F7 detail, historical):** F1 APPROVED (DEC-335); F2 scoped adversarial convergence, 25 passes across two attempts, HUMAN GATE APPROVED (DEC-336); F3 story decomposition CONVERGED + APPROVED (DEC-337); F4 Waves 1-2 delivered/merged (PRs #768-#772), COMPLETE (DEC-339); F5 CONVERGED (DEC-340, PR #773/#774); F6 COMPLETE (DEC-341, PR #775). Full detail: `cycles/cycle-004/burst-log.md` Bursts 1-22.

**cycle-003 (RELEASE + CLOSE, historical):** Human authorized and executed the cycle-003 dev release (DEC-333): PR #767 squash-merged (`c9bb74f4` → `42e92b46`), tag `v0.7.0-dev.4` pushed, `release.yml` run `33769389700` SUCCESS, GitHub prerelease published with 10 assets/5 targets. **cycle-003 is CLOSED.** Both S-7.02 process-gap deferral candidates codified in `cycles/cycle-003/lessons.md`. All prior outstanding, non-blocking items carried forward verbatim (MED-1 VP count unverified, LOW-4/LOW-6 doc nits, 4-story template-compliance gap, 6-file input-hash cascade) — none block cycle-004/cycle-005; deferred to a future maintenance/self-improvement cycle.

**cycle-003 (earlier F1-F7 detail, historical):** F5 findings RESOLVED via PR #763/#764; F6 GATE VERDICT PASS (mutation 100%, security clean, regression GREEN 4763/0/157); F7 pre-gate consistency audit found 12 findings, CRIT/HIGH/most-MED FIXED, MED-1/LOW-4/LOW-6 carried to future maintenance. Full detail: `cycles/cycle-003/burst-log.md` Bursts 10-22.

**Still open (2026-09-02, cycle-003 Wave 1 adversary, standing drift, not a cycle blocker):** `auth status` can transitively trigger the OAuth `"default"`-profile lazy-migration WRITE via `load_oauth_tokens` — pre-existing behavior, unrelated to cycle-003's redesign. Tracked for future maintenance-cycle attention.

**Still open (2026-09-01, cycle-002 F7 human gate + S-7.02 cycle-closing checklist -- justified deferral, carried forward unchanged):**
- `CYCLE-002-PROCESS-GAP-DEFERRAL-1/2/3` (all LOW, justified deferral). Full detail: `cycles/cycle-002/lessons.md` Process-Level items 3/4/5.

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
- **A-PA-LOW-001** — CLOSED, implemented by `S-cycle4-cloud-id-correctness` (merged PR #769 @ `c2074247`).
- **OBS-PB-1** (`auth status` credential probe `.is_ok()` swallows a genuine keyring backend error into "not found").
- `auth.rs:~1160` stale doc comment; `remove.rs` step-enumeration doc nit; `chacha20` 0.10.0 yanked-crate advisory (routine `cargo update -p chacha20` at next maintenance sweep).

**cycle-004 maintenance items (carried forward, not blockers):**
- **F6-MUTATION-EXAMINE-GLOBS-EXPANSION** (Burst 19) — add `src/api/auth.rs`, `src/cli/auth/login.rs`, `src/api/auth_windows_store.rs` to `.cargo/mutants.toml` examine_globs so CI mutation-tests the credential-critical modules. Needs a keychain-injection seam OR a documented exclude_re allowlist for the keyring-gated (VP-005/006/007) + Windows-`#[cfg]` (VP-010) boundary survivors, else CI floods/times-out. Test quality already verified 97-100% via the manual F6 run; only CI enforcement is missing. Target: a future SELF-IMPROVEMENT/maintenance cycle.
- **JR_CACHE_DIR-TEST-ENV-MUTEX-UNIFICATION** (Burst 21) — `src/cache.rs`, `src/config.rs`, and `src/api/auth_windows_store.rs` each carry a SEPARATE `ENV_MUTEX`/`CACHE_DIR_SEAM_MUTEX` guarding the SAME process-global `JR_CACHE_DIR` env var; they do not mutually exclude and `cargo test` runs multithreaded. Safe failure mode (a race yields a visible test failure, never a false pass). Unify into one shared crate-test env mutex. Target: a future SELF-IMPROVEMENT/maintenance cycle.
- **PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP** (Burst 21) — the vsdd-factory `pr-manager-completion-guard` hook (`plugins/vsdd-factory/hooks/dispatcher`) has no cross-turn memory; it parses only the current turn for `STEP_COMPLETE:` and loops after genuine 9-step completion. This is a FACTORY-ENGINE tooling bug (vsdd-factory plugin), NOT a jira-cli product defect. Target: vsdd-factory engine fix.
- **CYCLE-004-INPUT-HASH-HYGIENE** (Burst 19, RESOLVED @ `a038ac0d`) — the 9 cycle-004 F1-F3 delta artifacts flagged with a stale `input-hash` at the F7 pre-gate drift check have been recomputed (pure-recompute, no content change). Detail: `phase-f7-convergence/cycle-004/input-hash-drift.md`.
- **TD-031-BLOCKED-BC-6.2.016-CROSSREF** — deferred `bc-6-config-cache.md` cross-reference blocked by a pre-existing TD-031 hook violation, unrelated to cycle-004/005.
- **BC-1.4.035-PC5-VP-GAP** — production round-trip now CI-verified (VP-AUTHDX-010(b)); formal VP itself still deferred to maintenance.
- **S-410-KEYCHAIN-ISOLATION-FILE-OVERLAP** — shares `tests/oauth_refresh_integration.rs` with cycle-004; non-blocking.
- **W2-INT-PROCESS-GAP-README-PROSE-DRIFT** (Burst 17) — no CI guard cross-checks README prose against the code model. Target: a future maintenance cycle.

**PROCESS-GAP (Pass 14, cycle-004, historical, not a blocker):**
- `scripts/check-bc-cumulative-counts.sh` does not cover a per-file `bc-*.md` "## Summary Stats" closing "Note:" cumulative-prose line. Target: a future SELF-IMPROVEMENT/maintenance cycle.

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- 165 factory-wide stale `input-hash` artifacts confirmed via full scan (cycle-004 F7 pre-gate check, 2026-09-05; standing debt, **not** a cycle blocker).
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
- `VP-COUNT-RECONCILIATION` (new, cycle-005 F1) — ~177 raw-grepped VP ids across `bc-*.md` bodies vs. STATE's tracked 55; pre-existing bookkeeping-basis discrepancy, non-blocking. Target: a future maintenance/self-improvement cycle.

## Session Resume Checkpoint

**Date:** 2026-09-06. **Position:** cycle-005 (`adf-mentions`, GitHub #674) **OPEN** — Phase F1 delta analysis **APPROVED** (DEC-344); Phase F2 (spec evolution) **IN PROGRESS**. cycle-001 through cycle-004 remain CLOSED, historical.

**F1 delta analysis:** business-analyst + architect produced `phase-f1-delta-analysis/cycle-005/{delta-analysis.md,affected-files.txt,artifact-mapping.md}` (canonical). A duplicate business-analyst run's `artifact-mapping.md` (orchestrator coordination error) was diffed and reconciled: its genuinely distinct proposals — a committed reverse-path **BC-7.2.019** closing #202/NFR-O-I (vs. the canonical's open F2 decision under BC-7.2.004), a 3-way `@Name` **BC-X.7.007/008/009** split (vs. the canonical's single shared-resolver BC-X.7.007), and **VP-674-007/008/009/010/011** — were appended to the canonical `artifact-mapping.md` as an "**Alternative decomposition (F2 input)**" note before the duplicate file and its now-empty directory were removed.

**Approved scope (DEC-344):** two mention forms (bracket `[~accountid:<id>]` pure conversion + preflight-validate; `@Name` effectful resolution), hard-error `@Name` no-match with `\@` escape + `--no-mentions` opt-out, `attrs.text` from resolved display name, wiring incl. JSM `issue create --request-type`, reverse-path `adf_to_text` update, and a **NEW live-Jira E2E requirement** (controlled test account, self-cleaning per existing JSM-teardown/Drop-guard conventions). Architecture: pure `find_mention_candidates`/`markdown_to_adf_with_mentions` in `src/adf.rs` (thin-wrapper preserved); effectful `resolve_mentions` in new `src/cli/issue/mentions.rs`.

**In-flight work:** Phase F2 spec evolution about to be dispatched (architect + product-owner) to author binding BCs/VPs from the two F1 proposals (canonical + alternative decomposition note).

**Pending human decisions / blockers:** **NONE blocking** — the F1 gate has passed. F2 itself will need to decide (not gating the pipeline, this IS F2's job): (1) keep BC-7.2.004 unchanged vs. commit to the reverse-path render (canonical left this open; duplicate proposes closing #202/NFR-O-I via BC-7.2.019); (2) one shared `@Name`-resolver BC vs. the 3-way BC-X.7.007-009 split; (3) `attrs.text` placeholder-vs-omit disposition for the raw-token path.

**Tracked non-blocking follow-up:** `VP-COUNT-RECONCILIATION` (~177 raw-grepped VP ids across `bc-*.md` bodies vs. STATE's tracked running total of 55) — surfaced by the business-analyst during F1; target a future maintenance/self-improvement cycle.

**WIP branches:** **None.** No code changes yet — F1 and F2 are spec-only phases.

**Counts: total_bcs 742; VP count 55; holdout scenarios 106; total_stories 172** (unchanged this burst — F1 is analysis-only; F2 projects ~750-751 BCs / ~61 VPs / 107-111 holdouts / 176-178 stories, to be finalized at F2).

**EXACT RESUME COMMAND:** `/vsdd-factory:phase-f2-spec-evolution` to dispatch F2 spec evolution for cycle-005, reading both proposals in `phase-f1-delta-analysis/cycle-005/artifact-mapping.md` (canonical decomposition + the "Alternative decomposition (F2 input)" note).

**Superseded checkpoints:** the prior cycle-004 resting-state checkpoint (v3.74, 2026-09-06 — CLOSED + RELEASED, no open cycle) is superseded in place by this checkpoint and archived to `cycles/cycle-004/session-checkpoints.md` ahead of this Write, with a "Superseded at" note. Earlier cycle-004 archives (v3.53 through v3.73) remain at `cycles/cycle-004/session-checkpoints.md`; the cycle-003 checkpoints (v3.31 through v3.52) remain at `cycles/cycle-003/session-checkpoints.md`; cycle-002 checkpoints (v3.23 through v3.29 and earlier) remain at `cycles/cycle-002/session-checkpoints.md`; the cycle-001 CLOSED-position checkpoint (v3.05) remains at `cycles/cycle-001/session-checkpoints.md`. `cycles/cycle-005/session-checkpoints.md` was bootstrapped this burst (empty archive — this v3.75 checkpoint is cycle-005's first, and has not yet been superseded).

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-14 = F2/F3/F4; 15 = F5 CONVERGED + FIX-F5-001; 16 = F6 COMPLETE + FIX-F6-001; 17 = F7 delta-convergence PASS + FIX-F7-001; 18 = F7 human gate APPROVED + cycle-002 CLOSED; 19 = release v0.7.0-dev.3 SHIPPED; 20 = SESSION-WRAP) |
| cycle-003 burst history | `cycles/cycle-003/burst-log.md` (Burst 1 = cycle OPENED; Bursts 2-9 = F1 through F3 gates; Bursts 10-15 = F4 Waves 1-5, all 7 stories merged; Burst 16 = F5 findings fixed; Burst 17 = SESSION WRAP, F5 CONVERGED; Burst 18 = SESSION RESUMED, F6 DISPATCHED; Burst 19 = F6 COMPLETE — PASS; Burst 20 = F7 pre-gate consistency audit; Burst 21 = F7 human gate APPROVED — CONVERGED (DEC-332); Burst 22 = RELEASE v0.7.0-dev.4 SHIPPED, cycle-003 CLOSED (DEC-333)) |
| cycle-004 burst history | `cycles/cycle-004/burst-log.md` (Burst 1 = cycle OPENED; Burst 2 = F1 human gate APPROVED (DEC-335); Burst 3 = CRASH RECOVERY; Bursts 4-10 = F2 scoped adversarial convergence, 25 passes across two attempts + 2 consistency audits; Burst 11 = F2 HUMAN GATE APPROVED (DEC-336); Burst 12 = F3 story decomposition CONVERGED; Burst 13 = SESSION WRAP (F3 gate pending); Burst 14 = F3 HUMAN GATE APPROVED (DEC-337), phase F3→F4; Burst 15 = F4 Wave 1 DELIVERED + MERGED, integration gate PASSED (DEC-338), F4 CI spike SUCCEEDED; Burst 16 = F4 Wave 2 PARTIALLY DELIVERED + SESSION WRAP; Burst 17 = PR #771 merged, Wave 2 gate PASSED, F4 COMPLETE (DEC-339), phase F4→F5; Burst 18 = F5 scoped adversarial review CONVERGED (DEC-340) via PR #773/#774, phase F5→F6; Burst 19 = F6 targeted hardening COMPLETE (DEC-341) via PR #775, phase F6→F7; Burst 20 = F7 automated prep COMPLETE (commit `a038ac0d`) then SESSION WRAP — pipeline PAUSED at the F7 final human gate; Burst 21 = REQUIRED Windows-11 DPAPI verification SATISFIED VIA CI (PR #776 @ `135eb804`) and F7 human gate PASSED — CONVERGED (DEC-342); Burst 22 = **RELEASE v0.7.0-dev.5 SHIPPED** (PR #777 @ `569d85a8`, tag `v0.7.0-dev.5`, `release.yml` run `34046676423` SUCCESS), **cycle-004 CLOSED (DEC-343)**) |
| cycle-005 burst history | `cycles/cycle-005/burst-log.md` (Burst 1 = cycle OPENED, F1 delta analysis dispatched, duplicate artifact reconciled, F1 human gate APPROVED (DEC-344), phase F1→F2) |
| cycle-005 F1 delta-analysis artifacts | `phase-f1-delta-analysis/cycle-005/delta-analysis.md` + `affected-files.txt` + `artifact-mapping.md` (canonical, includes the "Alternative decomposition (F2 input)" note folded in from the reconciled duplicate) |
| cycle-005 session checkpoints | `cycles/cycle-005/session-checkpoints.md` (bootstrapped this burst, empty archive; this burst writes the live v3.75 checkpoint into STATE.md directly) |
| cycle-004 F1 delta-analysis artifacts | `cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md` + `affected-files.txt` |
| cycle-004 F2 spec-evolution artifacts | `cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md`; `vp-delta.md`; `specs/architecture/decisions/ADR-0021-*.md`; `specs/architecture/decisions/ADR-0022-*.md` |
| cycle-004 F3 story-decomposition artifacts | `cycles/cycle-004/phase-f3-stories/` — `decomposition-manifest.md`, `S-cycle4-{dpapi-storage-fix,cloud-id-correctness,honest-fail-message,windows-docs}.md`, `dependency-graph-extended.md`, `wave-schedule.md`, `conflict-report.md`, `wave-holdout-scenarios/` |
| cycle-004 F4-F7 delivery + release evidence | `code-delivery/S-cycle4-*/`, `code-delivery/FIX-*`, `phase-f5-adversarial/cycle-004/`, `phase-f6-hardening/cycle-004/`, `phase-f7-convergence/cycle-004/`; GitHub PR #776 + #777; tag `v0.7.0-dev.5`; `release.yml` run `34046676423` |
| cycle-004 research | `research/atlassian-3lo-revoke-granularity-2026-09-05.md`, `research/edge-tenant-info-cloudid-2026-09-03.md` |
| cycle-004 session checkpoints | `cycles/cycle-004/session-checkpoints.md` (archives v3.53 through v3.74 — v3.74 archived this burst as part of the cycle-005 Burst-1 checkpoint replacement) |
| cycle-003 grounding + phase artifacts | `cycles/cycle-003/investigation/`, `cycles/cycle-003/phase-f1-delta-analysis/`, `phase-f2-spec-evolution/`, `phase-f3-stories/`, `phase-f4-implementation/`, `phase-f6-hardening/`, `phase-f7-convergence/` |
| cycle-003 release + F4/F5 delivery evidence | version-bump PR #767 (`develop` @ `42e92b46`); tag `v0.7.0-dev.4`; `release.yml` run `33769389700`; `code-delivery/FIX-F7-DOCS-1/`, `code-delivery/S-cycle3-*/`, `code-delivery/FIX-F5-*/` |
| cycle-002/cycle-001 historical artifacts | `cycles/cycle-002/`, `cycles/cycle-001/` (see per-cycle files) |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**cycle-005 (F1 APPROVED, DEC-344, Burst 1, this burst):** cycle-005 (`adf-mentions`, #674) OPENED. F1 delta analysis produced two independent artifact-mapping.md runs (orchestrator coordination error) — reconciled: the duplicate's distinct proposals (reverse-path BC-7.2.019 closing #202/NFR-O-I; 3-way `@Name` BC-X.7.007-009 split; VP-674-007..011) appended to the canonical mapping as an "Alternative decomposition (F2 input)" note; duplicate removed. Human **APPROVED** the F1 scope (**DEC-344**) — see `Constraints Carried Forward` above for the full captured scope. Phase advances F1→F2. **New tracked follow-up:** `VP-COUNT-RECONCILIATION` (~177 raw-grepped VP ids vs. STATE's tracked 55), non-blocking, target a future maintenance/self-improvement cycle.

**cycle-004 (RELEASE + CLOSE, historical):** DEC-343: PR #777 squash-merged (`135eb804`→`569d85a8`), tag `v0.7.0-dev.5` pushed, `release.yml` SUCCESS, GitHub prerelease published. **cycle-004 is CLOSED.** F7 Windows-verification gate satisfied via CI (PR #776, DEC-342). All prior outstanding non-blocking items carried forward verbatim — see "cycle-004 maintenance items" under `Constraints Carried Forward` above; none block cycle-005.

**cycle-004 (earlier F1-F7 detail, historical):** F1 APPROVED (DEC-335); F2 25-pass scoped adversarial convergence APPROVED (DEC-336); F3 story decomposition APPROVED (DEC-337); F4 Waves 1-2 COMPLETE (DEC-339, PRs #768-#772); F5 CONVERGED (DEC-340, PR #773/#774); F6 COMPLETE (DEC-341, PR #775); F7 CONVERGED (DEC-342, PR #776). Full detail: `cycles/cycle-004/burst-log.md` Bursts 1-22.

**cycle-003 (RELEASE + CLOSE, historical):** DEC-333: PR #767 squash-merged, tag `v0.7.0-dev.4` pushed, `release.yml` SUCCESS, GitHub prerelease published. **cycle-003 is CLOSED.** Both S-7.02 process-gap deferrals codified in `cycles/cycle-003/lessons.md`. All prior outstanding items (MED-1, LOW-4/LOW-6, template-compliance gap, input-hash cascade) deferred to a future maintenance cycle.

**cycle-003 (F7 pre-gate audit + F5/F6 detail, historical):** 12-finding pre-gate consistency audit, CRIT/HIGH/most-MED FIXED, MED-1/LOW-4/LOW-6 carried forward. F5 findings RESOLVED via PR #763/#764; F6 GATE VERDICT PASS (mutation 100%, security clean, regression 4763/0/157). Full detail: `cycles/cycle-003/burst-log.md` Bursts 16-20.

**cycle-003 (earlier F4/F3/F2 resolutions, historical):** F1 (BYO-OAuth-cred over-delete) and ADR-0011 doc-drift CLOSED (Burst 15). ADR-0011-staged-not-applied CLOSED (Burst 14, `S-cycle3-adr0011-newtype` PR #758). DEC-NAMESPACE-COLLISION-RISK clean (max ID DEC-344 after this burst, no collision). Wave 1/2 integration gates PASSED; all 7 cycle-003 stories squash-merged.

**Still open (2026-09-02, cycle-003 Wave 1 adversary, standing drift, not a cycle blocker):** `auth status` can transitively trigger the OAuth `"default"`-profile lazy-migration WRITE via `load_oauth_tokens` — pre-existing behavior. Tracked for future maintenance-cycle attention.

**Still open (2026-09-01, cycle-002 F7 human gate + S-7.02 checklist — justified deferral, unchanged):**
- `CYCLE-002-PROCESS-GAP-DEFERRAL-1/2/3` (all LOW). Full detail: `cycles/cycle-002/lessons.md` Process-Level items 3/4/5.

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
- **A-PA-LOW-001** — CLOSED, implemented by `S-cycle4-cloud-id-correctness` (merged).
- **OBS-PB-1** (`auth status` credential probe `.is_ok()` swallows a genuine keyring backend error into "not found").
- `auth.rs:~1160` stale doc comment; `remove.rs` step-enumeration doc nit; `chacha20` 0.10.0 yanked-crate advisory.

**cycle-004 maintenance items (carried forward, not blockers):** see `Constraints Carried Forward` above for the full itemized list (`F6-MUTATION-EXAMINE-GLOBS-EXPANSION`, `JR_CACHE_DIR-TEST-ENV-MUTEX-UNIFICATION`, `PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP`, `CYCLE-004-INPUT-HASH-HYGIENE` resolved, `TD-031-BLOCKED-BC-6.2.016-CROSSREF`, `BC-1.4.035-PC5-VP-GAP`, `S-410-KEYCHAIN-ISOLATION-FILE-OVERLAP`, `W2-INT-PROCESS-GAP-README-PROSE-DRIFT`).

**PROCESS-GAP (Pass 14, cycle-004, historical, not a blocker):**
- `scripts/check-bc-cumulative-counts.sh` coverage gap on per-file Summary-Stats-Note prose. Target a future maintenance cycle.

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- 165 historical stale `input-hash` artifacts factory-wide (confirmed cycle-004 F7); standing debt, **not** a cycle blocker.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
- `VP-COUNT-RECONCILIATION` (new, cycle-005 F1) — ~177 raw-grepped VP ids vs. tracked 55; non-blocking, target a future maintenance/self-improvement cycle.
