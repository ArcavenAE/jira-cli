---
document_type: pipeline-state
level: ops
version: "3.41"
status: active
producer: state-manager
timestamp: 2026-09-02T15:47:20Z
phase: F4
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-453 latest brownfield (unchanged); trajectory-tail →1→3→0→2 (unchanged). F4 Wave 1 COMPLETE (env-tag #752 + percred-storage #755 merged @ d3ba2726; integration gate GREEN + adversary non-blocking). Next: Wave 2 = S-cycle3-credential-absence-guard (HIGH-risk, DEC-326 no-copy detect-and-instruct; carries the Wave-1 MED auth-list-STATUS enhancement)."
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
cycle_003_status: "auth-profile-dx -- OPEN (feature mode), pipeline ACTIVE. Phase F1 delta-analysis APPROVED at human gate 2026-09-01. Phase F2 (spec evolution) CLOSED (human-approved, DEC-328). Phase F3 (incremental stories) APPROVED at the human gate 2026-09-01 (DEC-329): 7 stories flipped draft->ready -- 24/24 BCs + 9/9 VPs covered exactly-once, 5-wave schedule, 57 total pts / 39-pt critical path. Phase F4 (delta implementation) is ACTIVE -- Wave 1 is now COMPLETE: both stories merged to develop -- S-cycle3-env-tag (PR #752, 5 pts) and S-cycle3-percred-storage (PR #755, 8 pts) -- develop @ d3ba2726 (was 87f17aff). Wave 1 integration gate returned GREEN (cargo build --tests, cargo test --lib 1242/0/18, clippy, fmt, and JR_RUN_KEYRING_TESTS=1-gated keychain tests 15/0 all GREEN; report at cycles/cycle-003/phase-f4-implementation/wave-1-integration-gate.md). Wave 1 adversary review returned 3 non-blocking findings, all dispositioned this burst: (1) MED -- auth list STATUS (config-only) vs auth status Credentials (keychain-probing) disagree during the migration window -- folded into Wave 2's S-cycle3-credential-absence-guard as an adversary-recommended enhancement to evaluate; (2) LOW -- auth status can transitively trigger the OAuth default-profile lazy-migration write via load_oauth_tokens -- pre-existing OAuth behavior, tracked as standing drift, not folded into Wave 2; (3) LOW [process-gap] -- S-cycle3-percred-storage.md's breaking_change frontmatter was false, contradicting the correct CHANGELOG framing -- corrected to true, input-hash refreshed, systemic frontmatter-coherence guard justified-deferred as a one-off. Auto-merge for cycle-003 F4 story PRs authorized by DEC-330 (CI green + AI review + local review convergence, no separate per-PR human prompt unless a finding escalates) -- applied to both Wave 1 PRs (#752, #755). Wave 2 (S-cycle3-credential-absence-guard, 8 pts, P0, HIGH-risk -- adds a security review, depends_on:[S-cycle3-percred-storage]) is next. BC/VP/holdout counts unchanged this burst (733/41/106); total_stories unchanged at 168."
activation_head: "d3ba2726"
activation_version: "v0.7.0-dev.3"
---

<!-- STATE.md SIZE BUDGET (2026-09-02, F4-WAVE1-COMPLETE burst / Burst 11):
     265 lines (wc-l). soft-target 200; hard cap 500.
     margin from soft-target = 265 - 200 = 65 -- 65 lines OVER the soft target of 200.
     margin from actual (hard cap) = 500 - 265 = 235 lines of headroom remain before the hard cap of 500.
     This burst records: (1) S-cycle3-percred-storage (F4 Wave 1, story 2/2) squash-merged to
     develop via PR #755 -- merge commit d3ba27262be5cd26992c8ac71b2162c895cc90d0, develop
     4d0ae2d5 -> d3ba2726 -- completing Wave 1 (2/2 stories merged); (2) the Wave 1
     integration gate ran and returned GREEN (build/test/clippy/fmt/gated-keychain-tests all
     clean) -- report at cycles/cycle-003/phase-f4-implementation/wave-1-integration-gate.md;
     (3) the Wave 1 adversary review returned 3 non-blocking findings (1 MED, 2 LOW), gate
     verdict SAFE TO PASS -- all 3 dispositioned this burst (MED folded into the Wave 2 story
     as an evaluate-worthy enhancement; LOW oauth-migration-write tracked as standing drift;
     LOW [process-gap] breaking_change frontmatter corrected on S-cycle3-percred-storage.md,
     both edited stories' input-hash refreshed via compute-input-hash --update); (4)
     frontmatter activation_head 4d0ae2d5 -> d3ba2726 (develop moved again); phase stays F4,
     pipeline stays ACTIVE; (5) Phase Progress gained F4-WAVE1-STORY2, F4-WAVE1-INTEGRATION-
     GATE, and F4-WAVE2-PENDING rows; Current Phase Steps reset to the Wave-1-closing trail
     (story-2 merge -> integration gate -> adversary review -> findings dispositioned -> Wave
     1 closed); (6) Session Resume Checkpoint replaced -- prior Wave-1-story-1-merged
     checkpoint (v3.40) archived to cycles/cycle-003/session-checkpoints.md as Checkpoint
     v3.40; (7) Burst 11 narrative appended to cycles/cycle-003/burst-log.md. This burst also
     COMMITS delivery evidence left uncommitted in the worktree: the S-cycle3-percred-storage
     demos (cycles/cycle-003/code-delivery/S-cycle3-percred-storage/demos/), the wave-1
     integration-gate report, and the S-cycle3-env-tag + S-cycle3-percred-storage pr-review
     artifacts -- relocated from the stray top-level code-delivery/S-cycle3-*/ paths into the
     cycles/cycle-003/code-delivery/<story>/ convention (sibling of each story's demos/,
     matching the existing S-cycle3-env-tag/demos/ layout) rather than left dangling outside
     cycles/. cycle_001_status/cycle_002_status and all standing Drift/Standing items
     preserved verbatim except the two edits noted above. Zero new BCs/VPs this burst --
     delivery + gate + disposition bookkeeping only, no spec content added (the two story-file
     edits are corrections/annotations, not new coverage). One full-content Write, no Edit
     chain (DEC-247). Pre-existing uncommitted `regression-state.json` and
     `sidecar-learning.md` modifications in the worktree remain untouched -- not staged, not
     committed, per standing instruction. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →1→3→0→2 (unchanged this burst) |
| **Last Updated** | F4-WAVE1-COMPLETE burst (2026-09-02): trajectory-tail →1→3→0→2 (unchanged). `S-cycle3-percred-storage` (Wave 1, story 2/2) squash-merged to `develop` via PR #755 — merge commit `d3ba27262be5cd26992c8ac71b2162c895cc90d0`, `develop` `4d0ae2d5` → `d3ba2726` — **Wave 1 is now COMPLETE (2/2 stories merged)**. Wave 1 integration gate ran GREEN; Wave 1 adversary review returned 3 non-blocking findings, all dispositioned. Phase stays **F4**; pipeline stays **ACTIVE**. Wave 2 (`S-cycle3-credential-absence-guard`) is next. |
| **Current Phase** | Feature Mode cycle-003 (`auth-profile-dx`) -- **F4 delta-implementation ACTIVE, Wave 1 COMPLETE (2/7 stories merged: `S-cycle3-env-tag`, `S-cycle3-percred-storage`); Wave 2 (`S-cycle3-credential-absence-guard`) next.** cycle-001 and cycle-002 remain CLOSED, historical. |
| **Activation HEAD** | `d3ba2726` (`develop` tip; moved this burst — PR #755 squash-merge, was `4d0ae2d5`) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, cycles/cycle-003/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| F3-GATE-APPROVED (cycle-003) | COMPLETE | 2026-09-01 | Human gate — F3 story decomposition **APPROVED** (DEC-329) | All 7 stories flipped `draft`→`ready`. Phase advances F3 → F4. Report: `cycles/cycle-003/burst-log.md` Burst 9. | 733 BCs unchanged; 41 VPs unchanged |
| F4-DELTA-IMPLEMENTATION (cycle-003) | **IN PROGRESS — Wave 1 COMPLETE (2/7 stories merged); Wave 2 next** | — | Wave-gated; Wave 1 gate PASSED this burst | Phase F4 opened (Burst 9). Wave 1 = `S-cycle3-env-tag` (5 pts, MERGED Burst 10) + `S-cycle3-percred-storage` (8 pts, MERGED this burst) — both delivered, gate PASSED. Waves 2–5 unchanged from the F3-approved schedule: Wave 2 `S-cycle3-credential-absence-guard` (8 pts, P0, HIGH-risk), Wave 3 `S-cycle3-remove-logout-semantics` (5 pts), Wave 4 `S-cycle3-adr0011-newtype` + `S-cycle3-oauth-default-creation` (13+13 pts, parallel), Wave 5 `S-cycle3-chosen-flow-reconcile` (5 pts). Full regression suite is the F4 safety net. | 733 BCs unchanged; 41 VPs unchanged |
| F4-WAVE1-STORY1 (cycle-003) | MERGED | 2026-09-02 | CI `ci-gate` green + AI review + local review converged; auto-merged per DEC-330 | `S-cycle3-env-tag` (Wave 1, story 1/2, 5 pts) squash-merged to `develop` @ `4d0ae2d5` via PR #752. Full detail: `cycles/cycle-003/burst-log.md` Burst 10. | 733 BCs unchanged; 41 VPs unchanged |
| **F4-WAVE1-STORY2 (cycle-003)** | **MERGED (this burst)** | 2026-09-02 | CI `ci-gate` green + AI review (pr-reviewer, 3 confirmation cycles) + local review converged; auto-merged per DEC-330 | `S-cycle3-percred-storage` (Wave 1, story 2/2, 8 pts, HIGH-risk) — per-profile API-token keychain storage (BC-1.4.031) — delivered via full per-story TDD, squash-merged to `develop` @ `d3ba27262be5cd26992c8ac71b2162c895cc90d0` (`4d0ae2d5`→`d3ba2726`). Its `breaking_change` frontmatter corrected `false`→`true` this burst (Wave 1 adversary [process-gap] finding — see Drift/Standing Items). | 733 BCs unchanged; 41 VPs unchanged |
| **F4-WAVE1-INTEGRATION-GATE (cycle-003)** | **PASSED (this burst)** | 2026-09-02 | `cargo build --tests`, `cargo test --lib` (1242/0/18), clippy, fmt, `JR_RUN_KEYRING_TESTS=1`-gated tests (15/0) — all GREEN; adversary review 3 findings, none blocking → **SAFE TO PASS** | Report: `cycles/cycle-003/phase-f4-implementation/wave-1-integration-gate.md`. Adversary findings (1 MED, 2 LOW) all dispositioned this burst — see Drift/Standing Items. **Wave 1 CLOSED: 2/7 cycle-003 stories now merged.** | 733 BCs unchanged; 41 VPs unchanged |
| **F4-WAVE2 (cycle-003)** | **PENDING DISPATCH** | — | Wave-gated on Wave 1 integration gate PASSED (met this burst) | Wave 2 = `S-cycle3-credential-absence-guard` (8 pts, P0, HIGH-risk, `depends_on:[S-cycle3-percred-storage]`) — implements DEC-326's no-copy detect-and-instruct contract; carries forward the Wave 1 MED finding as an enhancement to evaluate (`auth list` STATUS column credential-aware); HIGH-risk flag adds a security review. | 733 BCs unchanged; 41 VPs unchanged |

## Current Phase Steps (cycle-003, F4 Wave 1 close-out; last 5)

| Step | Status | Notes |
|------|--------|-------|
| `S-cycle3-percred-storage` (Wave 1 story 2/2) delivered + merged | DONE | Full per-story TDD; PR #755 squash-merged to `develop` @ `d3ba2726` (was `4d0ae2d5`) |
| Wave 1 integration gate run | DONE | `cargo build --tests`, `cargo test --lib` 1242/0/18, clippy, fmt, gated keychain tests 15/0 — ALL GREEN. Report: `cycles/cycle-003/phase-f4-implementation/wave-1-integration-gate.md` |
| Wave 1 adversary review | DONE | 3 findings (1 MED, 2 LOW), none blocking — verdict SAFE TO PASS |
| Findings dispositioned | DONE | MED → folded into Wave 2 story as an evaluate-worthy enhancement; LOW (oauth-migration-write) → standing drift, tracked separately; LOW [process-gap] → `breaking_change` frontmatter corrected on `S-cycle3-percred-storage.md`, input-hash refreshed |
| Wave 1 CLOSED | **DONE (this burst)** | 2/7 cycle-003 stories merged, gate PASSED. **NEXT:** dispatch Wave 2 (`S-cycle3-credential-absence-guard`, HIGH-risk, adds a security review). |

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-330 | Human authorized AUTO-MERGE of cycle-003 F4 story PRs: once CI `ci-gate` is green AND both the AI review (pr-reviewer) and the pre-PR local code review (code-reviewer) converge, the orchestrator may squash-merge the story PR to `develop` WITHOUT a separate per-PR human prompt — pausing only for material/escalated findings. This overrides the fail-safe human-gated default (no `merge-config.yaml`) for cycle-003 F4 story PRs specifically. Applied: PR #752 (`S-cycle3-env-tag`) and PR #755 (`S-cycle3-percred-storage`), both squash-merged to `develop` (now @ `d3ba2726`) | Speeds F4 Wave dispatch across the remaining story PRs without lowering the quality bar — CI + dual-review convergence is still mandatory; the human retains an override valve whenever a finding is material or escalated | F4 | 2026-09-02 | human |
| DEC-329 | cycle-003 F3 story decomposition APPROVED at the human gate -- proceed to F4 delta-implementation. 7 stories (S-cycle3-*), dependency graph ACYCLIC, 5-wave schedule (57 total pts, 39-pt critical path), 24/24 BCs + 9/9 VP-AUTHDX covered exactly-once, fresh-context consistency audit SOUND. Ratified at the gate: (a) the orchestrator-added dependency `S-cycle3-oauth-default-creation` → `S-cycle3-remove-logout-semantics` (story 6 reuses the `clear_profile_creds` api-token clear-branch that story 4 adds); (b) `S-MAINT-532` kept OUT of cycle-003 scope, deferred to a future maintenance cycle (human confirmed "keep separate") | F3 story package (7 stories + BC/VP coverage matrices, dependency graph + acyclicity proof, wave schedule + critical path, conflict report, wave holdout scenarios) presented at the gate; human approved, ratifying both carried-forward items rather than leaving them open | F3 | 2026-09-01 | human |
| DEC-328 | cycle-003 F2 (spec evolution / `auth-profile-dx`) delta APPROVED at the human gate; F2 delta CONVERGED (4-pass adversarial trajectory, pass-4 CLEAN) + fresh-context consistency audit CONSISTENT + cycle-003-scoped input-hash drift check NO-DRIFT. Human directed the 4 LOW residuals be swept in a dedicated burst before F3. Proceed to F3 story decomposition | F2 spec-evolution package (BC delta, staged ADR-0011 amendment, ADR-0020, 4-pass adversarial convergence record) presented at the gate; human approved, contingent on the residual sweep completing first — F-1/NEW-1/F-2/L-3 all fixed in this same burst | F2 | 2026-09-01 | human |
| DEC-327 | Env-var (`JR_EMAIL`/`JR_API_TOKEN`) presence suppresses the OAuth-default picker in NON-INTERACTIVE mode ONLY (`--no-input`/non-TTY); on an interactive TTY the OAuth picker always shows regardless of env vars. Refines DEC-313 | Resolves F2-gate adversary pass-2 finding M-1/L-2 (SR-010): an env-var trigger that also suppressed the picker on an interactive TTY would silently deny users the OAuth-default experience DEC-313 established. Encoded in BC-1.1.014 | F2 | 2026-09-01 | human (at F2-gate fix round) |
| DEC-326 | No-copy detect-and-instruct migration for the shared legacy `email`/`api-token` credential (supersedes DEC-325(a)'s "lazy migration" clause): `load_api_token` NEVER reads-as-credential, copies, or deletes the legacy keys for any profile (including `default`); an absent namespaced pair produces an actionable exit-64 instructing `jr auth login <profile>`. DEC-325(a)'s "additive keychain keys" clause stands, unaffected | Closes F2-gate adversary pass-1 CRITICAL finding C-1 (migration-lockout): the original copy-then-delete design could silently place a prod credential behind a sandbox-tagged profile, defeating DEC-312's environment-locking goal. Encoded in BC-1.4.032/033/034, VP-AUTHDX-005/006/007/008, ADR-0020 §Decision 2/2a/2b | F2 | 2026-09-01 | human (at F2-gate fix round) |
| DEC-325 | Accepted architect recommendations for cycle-003 F1 (Open Questions 1/2/3 + deprecation window): (a) NO version bump -- per-profile `<profile>:email`/`<profile>:api-token` are additive keychain keys **[lazy-migration clause SUPERSEDED 2026-09-01 by DEC-326's no-copy detect-and-instruct redesign; "additive keychain keys" stands]**, keychain stays profile-prefixed (no `v2` marker), no cache-root bump; (b) ADR-0011 un-deferred via IN-PLACE amendment (Deferred->Accepted), not supersession; (c) ONE combined new ADR (target ADR-0020, collision-checked clean) covering per-profile credential layout + `env` tag + OAuth-default-at-creation; (d) `--oauth` kept accepted indefinitely, marked deprecated, no hard removal date -- removal left to a future cycle | Matches human's caution on breaking changes; avoids an unforced cache/keychain version bump; consolidates related spec work into one ADR rather than three | F1 | 2026-09-01 | human (at F1 gate) |
| DEC-324 | `env` tag (prod/sandbox/uat) surfaced as an `auth list` table column | Resolves F1 Open Question 7; the tag exists on the profile (DEC-314) but was not yet visible in any command output. Appears in the human table plus `auth status` and JSON. The pinned BC-1.6.046 4-column insta-snapshot is updated to accommodate it (documented, routine output change) | F1 | 2026-09-01 | human |
| DEC-323 | Explicit `--api-token` flag added to `auth login`, symmetric with the now-deprecated `--oauth` alias | Resolves F1 Open Question 5; gives non-interactive mechanism declaration and lets an existing profile's mechanism be re-declared explicitly, without relying on `--oauth`'s absence as the implicit signal | F1 | 2026-09-01 | human |
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

`cycle-003` (`auth-profile-dx`) F1 delta-analysis APPROVED at the human gate; Phase F2 (spec evolution) is **CLOSED** (human-approved, DEC-328). Phase F3 (incremental stories) is **APPROVED at the human gate** (DEC-329) — all 7 stories `status: ready`. Phase **F4 (delta implementation) is ACTIVE — Wave 1 is COMPLETE (2/7 stories merged): `S-cycle3-env-tag`** (PR #752) **and `S-cycle3-percred-storage`** (PR #755, this burst) **— `develop` @ `d3ba2726`.** Wave 1 integration gate PASSED (GREEN across build/test/clippy/fmt/gated-keychain-tests); Wave 1 adversary review's 3 non-blocking findings all dispositioned this burst. **DEC-330** authorizes auto-merge for cycle-003 F4 story PRs once CI + both reviews converge, applied to both Wave 1 PRs. Wave 2 (`S-cycle3-credential-absence-guard`, HIGH-risk) is next. Pipeline stays **ACTIVE**; phase stays **F4**. Counts unchanged this burst: **733 total BCs**, **41 total VPs**, **106 holdout scenarios**; `total_stories` unchanged at **168**.

## Concurrent Cycles

Three tracked cycles. `cycle-001` is CLOSED, historical. `cycle-002` (`field-dx`) is **CLOSED + RELEASED** (2026-09-01), historical. `cycle-003` (`auth-profile-dx`) is the sole cycle with open work: F1 APPROVED, F2 CLOSED (DEC-328), F3 APPROVED (DEC-329) — 7 stories `ready`. **F4 (delta implementation) is ACTIVE — Wave 1 is COMPLETE: 2/7 stories merged (`S-cycle3-env-tag` PR #752, `S-cycle3-percred-storage` PR #755), integration gate PASSED, adversary findings dispositioned.** Wave 2 (`S-cycle3-credential-absence-guard`) is next. Auto-merge policy DEC-330 in effect for cycle-003 F4 story PRs. Pipeline is **ACTIVE**; phase is **F4**.

## Constraints Carried Forward (cycle-003)

ADR-0006 (embedded OAuth app, fixed callback port 53682), ADR-0013 (PKCE deferral -- Atlassian 3LO does not support public-client PKCE as of 2026-05), SD-002 release gates (`JR_AUTH_HEADER`/`JR_BASE_URL` debug-only, release binaries ignore them), single-use refresh tokens + `refresh_coordinator.rs` per-profile single-flight, Windows Credential Manager posture (SEC-WCM-DOC), and the shared-vs-per-profile keychain invariant -- being **deliberately restructured** by DEC-315, migration mechanism finalized as no-copy detect-and-instruct (DEC-326); migration discipline mandatory (see F2 spec delta for the concrete migration design). Refresh mechanism override removed (DEC-321) -- `auth refresh` always follows the profile's intrinsic `auth_method`; ADR-0011 amendment (Deferred->Accepted, DEC-317/DEC-325b) is authored and STAGED (not yet applied to `docs/adr/`) -- application is an F4 obligation of `S-cycle3-adr0011-newtype` (Wave 4), still `status: ready`, not yet dispatched; ADR-0020 (DEC-325c) is authored, final under `.factory/`, reconciled through pass-3/pass-4 (CLEAN) and the F2-gate residual sweep -- F2 is CLOSED, no further ADR-0020 fixes required. F3's 7 stories are all `status: ready`; `S-cycle3-env-tag` and `S-cycle3-percred-storage` are now delivered/merged (Wave 1 COMPLETE); the remaining 5 map every other cycle-003 obligation onto the wave-scheduled order. `S-MAINT-532` remains explicitly out of cycle-003 scope (ratified at the F3 gate). DEC-330 authorizes auto-merge for cycle-003 F4 story PRs (CI + dual-review convergence gate, human retains an override valve for escalated findings) — applied to both Wave 1 PRs. **New this burst:** the Wave 1 integration gate PASSED and its adversary review's 3 findings are dispositioned — see Drift/Standing Items for the exact carry-forward text of the MED finding folded into Wave 2's `S-cycle3-credential-absence-guard` scope, and the LOW oauth-migration-write item tracked as standing (non-cycle-003) drift. `S-cycle3-percred-storage.md`'s `breaking_change` frontmatter is corrected `false`→`true` (Wave 1 adversary [process-gap] finding); its human-facing CHANGELOG entry was already correctly framed as `BREAKING — Action required`.

## Session Resume Checkpoint

**Date:** 2026-09-02. **Position:** cycle-003 (`auth-profile-dx`), Phase **F4 (delta implementation) ACTIVE** — **Wave 1 is COMPLETE**: both stories merged to `develop` — `S-cycle3-env-tag` (PR #752 @ `4d0ae2d5`) and `S-cycle3-percred-storage` (PR #755, merge commit `d3ba27262be5cd26992c8ac71b2162c895cc90d0`, `develop` `4d0ae2d5`→`d3ba2726`, 2026-09-02). Auto-merge policy **DEC-330** was applied to both PRs. The Wave 1 integration gate ran and returned **GREEN** (`cargo build --tests`; `cargo test --lib` 1242/0/18; clippy; fmt; `JR_RUN_KEYRING_TESTS=1`-gated tests 15/0 — all clean; report at `cycles/cycle-003/phase-f4-implementation/wave-1-integration-gate.md`). The Wave 1 adversary review returned 3 findings (1 MED, 2 LOW), none blocking — verdict **SAFE TO PASS** — and all 3 are dispositioned (see below). **Wave 2 (`S-cycle3-credential-absence-guard`, 8 pts, P0, HIGH-risk — adds a security review) is next.** cycle-001 and cycle-002 remain CLOSED, historical, unaltered by this burst.

**Wave 1 adversary findings + dispositions (this burst):**
1. **MED** — `auth list` STATUS (config-only, `url.is_some()`→`configured`) vs `auth status` Credentials (keychain-probing via `load_api_token`) disagree during the migration window: a pre-cycle-003 api-token profile shows `configured` in `auth list` but `Credentials: not found` in `auth status`. **Disposition:** folded into Wave 2's `S-cycle3-credential-absence-guard` as an adversary-recommended enhancement to EVALUATE (make `auth list` STATUS credential-aware, existence-only probe, same discipline as the legacy-pair check) — story file updated with a "Wave 1 integration-gate finding (MED)" section; implement if it fits the story's existing file list, else flag as a tracked follow-up in the delivery PR rather than silently dropping it.
2. **LOW** — `auth status` (a documented read-only probe) can transitively trigger the OAuth `"default"`-profile lazy-migration WRITE via `load_oauth_tokens`. **Disposition:** pre-existing OAuth behavior, unrelated to cycle-003's per-credential redesign; tracked as standing drift (see Drift/Standing Items below), NOT folded into Wave 2.
3. **LOW [process-gap]** — `S-cycle3-percred-storage.md`'s `breaking_change` frontmatter read `false`, contradicting the story's own CHANGELOG entry (already correctly framed `BREAKING — Action required`) and the actual behavior (removing the legacy flat-key read fallback locks out every existing api-token profile, including `default`, until re-authentication). **Disposition:** corrected to `true` this burst, with a "Correction Note" section added to the story explaining the fix; `compute-input-hash --update` re-run (stored `3f4ee5d`→`f01a25d`). A systemic frontmatter-coherence guard was considered and its addition **justified-deferred** — LOW severity, one-off, non-recurring pattern, not worth a new CI check at this time.

**Wave 1 delivery summary (both stories):** `S-cycle3-env-tag` (5 pts, Burst 10) — full TDD trail, PR #752, squash-merged @ `4d0ae2d5`. `S-cycle3-percred-storage` (8 pts, HIGH-risk, this burst) — per-profile API-token keychain storage (BC-1.4.031), full TDD trail including a security review, PR #755 (3 review-confirmation cycles: `pr-review-cycle1.md`/`-cycle2.md`/`-cycle3.md` + final `pr-review.md`, `cycles/cycle-003/code-delivery/S-cycle3-percred-storage/`), demos at `cycles/cycle-003/code-delivery/S-cycle3-percred-storage/demos/`, squash-merged @ `d3ba2726`. Combined full regression on `develop` post-Wave-1: `cargo test --lib` **1242 passed / 0 failed / 18 ignored**.

**Remaining wave order (unchanged from the F3 gate, DEC-329):**
3. `S-cycle3-credential-absence-guard` (Wave 2, 8 pts, P0, HIGH-risk, depends_on:[2]) — **NEXT.** Implements DEC-326's no-copy detect-and-instruct contract; carries forward the Wave 1 MED finding (above) as an enhancement to evaluate.
4. `S-cycle3-remove-logout-semantics` (Wave 3, 5 pts, depends_on:[2,3]) — **MUST also clear the new per-profile `email`/`api-token` keys** that `S-cycle3-percred-storage` introduced (a deferred gap noted in that story) as part of its logout-semantics rework, not just the OAuth session tokens.
5. `S-cycle3-adr0011-newtype` (Wave 4, 13 pts, depends_on:[2,3,4]) — **MUST apply the staged ADR-0011 amendment** to `docs/adr/0011-type-level-profile-fence.md`.
6. `S-cycle3-oauth-default-creation` (Wave 4, 13 pts, P0, depends_on:[2,3,4]).
7. `S-cycle3-chosen-flow-reconcile` (Wave 5, 5 pts, terminal, depends_on:[6]).

**Critical path (unchanged):** `percred-storage`(2, MERGED) → `credential-absence-guard`(3) → `remove-logout-semantics`(4) → `oauth-default-creation`(6) → `chosen-flow-reconcile`(7), 39 points.

**Convergence trajectory (counter):** ... → F3 human approval gate APPROVED (DEC-329) → F4 delta-implementation OPENED → Wave 1 story 1 (`S-cycle3-env-tag`) delivered + merged → **Wave 1 story 2 (`S-cycle3-percred-storage`) delivered + merged, Wave 1 integration gate PASSED, adversary findings dispositioned (this burst)** → Wave 2 (`S-cycle3-credential-absence-guard`) NEXT.

**Committed spec state:** unchanged in BC/VP/holdout count this burst — 733 BCs, 41 VPs, 106 holdouts (master count); `total_stories` unchanged at 168 (no story-file status change this burst — the two story-file edits are a MED-finding annotation and a `breaking_change` frontmatter correction, not new coverage). Both count guards unaffected (no spec content touched). Prior commits: the Wave-1-story-1-merged burst commit (v3.40). This burst's `.factory/` commit carries `cycles/cycle-003/phase-f4-implementation/wave-1-integration-gate.md` (Wave 1 gate report), the `S-cycle3-percred-storage` demo evidence (`cycles/cycle-003/code-delivery/S-cycle3-percred-storage/demos/`), both stories' pr-review artifacts relocated into the `cycles/cycle-003/code-delivery/<story>/` convention, the two story-file edits (MED-finding annotation + `breaking_change` correction, both with refreshed input-hash), and STATE.md/burst-log.md/session-checkpoints.md bookkeeping — the `S-cycle3-percred-storage` `src/` changes already landed on `develop` via PR #755's own merge commit, not via this `.factory/` commit.

**Human decisions already made + recorded:** DEC-326 (no-copy api-token migration), DEC-327 (env-var non-interactive-only OAuth-picker trigger), DEC-328 (F2 gate APPROVED), DEC-329 (F3 gate APPROVED; both carried-forward items ratified), and DEC-330 (auto-merge authorization for cycle-003 F4 story PRs, applied to both Wave 1 PRs). Do NOT re-ask these on resume.

**Pending human decision:** none blocking — DEC-330 covers routine story-PR merges through the remainder of Waves 2–5 unless a PR surfaces a material/escalated finding, in which case pause and ask.

**NEXT on resume (exact):** (1) stand up a worktree for `S-cycle3-credential-absence-guard` (Wave 2) rebased onto the current `develop` tip (`d3ba2726`); (2) dispatch its per-story TDD delivery (test-writer → implementer → demo-recorder → pr-manager → devops-engineer), noting the HIGH-risk flag adds a security review to the trail; (3) while scoping the story, evaluate folding in the Wave 1 MED finding (make `auth list` STATUS credential-aware) per the disposition above — implement if it fits cleanly, else flag as a tracked PR-description follow-up; (4) on CI green + dual-review convergence, auto-merge per DEC-330 (pause only for material/escalated findings); (5) on Wave 2 completion, run its own integration gate (mirror this burst's Wave 1 gate) before proceeding to Wave 3 (`S-cycle3-remove-logout-semantics` — remember it must also clear the new per-profile credential keys, not just OAuth session tokens); (6) continue through Waves 4–5 per `wave-schedule.md`, noting the two carried F4 obligations: `S-cycle3-adr0011-newtype` (Wave 4) must apply the staged ADR-0011 amendment to `docs/adr/`, and `S-cycle3-oauth-default-creation` (Wave 4) is P0.

**Resume command:** `/vsdd-factory:next-step`.

**Superseded checkpoints:** the prior Wave-1-story-1-merged checkpoint (v3.40, 2026-09-02 — recorded the `S-cycle3-env-tag` merge and the story-2 dispatch-pending position, since superseded by this burst's Wave-1-COMPLETE position above) is superseded in place and archived to `cycles/cycle-003/session-checkpoints.md` as Checkpoint v3.40, alongside Checkpoint v3.39 (F3-GATE-APPROVED/F4-ACTIVE), v3.38 (F3 authored/integrated, gate pending), v3.37 (F2-gate-approval/residual-sweep), v3.36 (F2 CONVERGED/PAUSED), v3.35 (SESSION-WRAP/PAUSED), v3.34 (F2-GATE-FIX-ROUND-COMPLETE), v3.33 (F2 authoring complete), v3.32 (F2 in progress), and v3.31 (F1-pending). Earlier archives (RELEASED/SHIPPED v3.29, F7-PASS/AWAITING-GATE v3.27, F6-COMPLETE v3.26, F5-COMPLETE v3.25, F4-COMPLETE v3.24, `WRAP-F4-WAVE2-COMPLETE-PAUSE` v3.23, and the SESSION-WRAP checkpoint) remain at `cycles/cycle-002/session-checkpoints.md`. The `list-read-ergonomics` cycle-001 CLOSED-position checkpoint (v3.05) remains archived at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-14 = F2/F3/F4; 15 = F5 CONVERGED + FIX-F5-001; 16 = F6 COMPLETE + FIX-F6-001; 17 = F7 delta-convergence analyses PASS + FIX-F7-001; 18 = F7 human gate APPROVED + cycle-002 CLOSED; 19 = release v0.7.0-dev.3 SHIPPED; 20 = SESSION-WRAP) |
| cycle-003 burst history | `cycles/cycle-003/burst-log.md` (Burst 1 = cycle OPENED; Burst 2 = F1 delta-analysis APPROVED at human gate, F2 entry; Burst 3 = F2 spec-evolution AUTHORING COMPLETE; Burst 4 = F2-gate FIX round COMPLETE — adversary pass-1/pass-2 fixes, DEC-326/327 recorded; Burst 5 = SESSION-WRAP — pass-3 propagation fixes committed, pass-4 abandoned, PAUSED; Burst 6 = pass-4 CLEAN — F2 CONVERGED, recorded post-wrap; Burst 7 = F2 human approval gate APPROVED (DEC-328), all 4 LOW residuals swept, F2 → F3, PAUSED → ACTIVE; Burst 8 = F3 MANIFEST/CREATE/INTEGRATE AUTHORING COMPLETE, fresh-context consistency audit SOUND, F3 human approval gate PENDING presentation; Burst 9 = F3 human approval gate APPROVED (DEC-329), 7 stories draft→ready, F3 → F4; Burst 10 = F4 Wave 1 story 1 (`S-cycle3-env-tag`) delivered + squash-merged to develop @ 4d0ae2d5 via PR #752, DEC-330 auto-merge authorization recorded; Burst 11 = F4 Wave 1 story 2 (`S-cycle3-percred-storage`) delivered + squash-merged to develop @ d3ba2726 via PR #755, Wave 1 integration gate PASSED, adversary findings dispositioned, this burst) |
| cycle-003 grounding artifacts | `cycles/cycle-003/investigation/auth-profile-current-state.md` (current-state map); `cycles/cycle-003/investigation/modern-cli-auth-profile-research.md` (modern-CLI research, 39 sources, 4 ranked recommendations) |
| cycle-003 F1 delta-analysis report | `cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md` (impact boundary, affected specs/stories/tests, regression risk; APPROVED at human gate; L-3 phantom-citation residual fixed at F2-gate-approval burst) |
| cycle-003 F2 spec-evolution artifacts | `cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md` (architecture delta narrative); `cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md` (STAGED ADR-0011 amendment, pending F4 application to `docs/adr/` via `S-cycle3-adr0011-newtype`) |
| cycle-003 F3 story-decomposition artifacts | `cycles/cycle-003/phase-f3-stories/` — `decomposition-manifest.md` (BC/VP coverage matrices), `S-cycle3-*.md` ×7 (per-story files, all `status: ready` as of DEC-329; two edited this burst — see below), `dependency-graph-extended.md` (Kahn's-algorithm acyclicity proof), `wave-schedule.md` (5-wave schedule + critical path), `conflict-report.md` (S-663-1/S-384/S-MAINT-532 dispositions), `wave-holdout-scenarios/wave-{1..5}-holdout-scenarios.md` (30 scenarios). |
| cycle-003 F4 implementation artifacts | `cycles/cycle-003/phase-f4-implementation/regression-baseline.md` (pre-Wave-1 full regression baseline, GREEN); `cycles/cycle-003/phase-f4-implementation/wave-1-integration-gate.md` (Wave 1 integration gate, PASSED, committed this burst) |
| cycle-003 F4 story-1 delivery evidence | `cycles/cycle-003/code-delivery/S-cycle3-env-tag/demos/` (4 VHS recordings + README) + `cycles/cycle-003/code-delivery/S-cycle3-env-tag/pr-review.md` (relocated from stray top-level `code-delivery/S-cycle3-env-tag/`, committed this burst) |
| cycle-003 F4 story-2 delivery evidence | `cycles/cycle-003/code-delivery/S-cycle3-percred-storage/demos/` (2 test-run recordings + README) + `pr-review.md`/`pr-review-cycle1.md`/`pr-review-cycle2.md`/`pr-review-cycle3.md` (relocated from stray top-level `code-delivery/S-cycle3-percred-storage/`, committed this burst) |
| F5 scoped-adversarial review report (cycle-002) | `phase-f5-adversarial/adversarial-delta-review.md` (raw pass-1 findings); `phase-f5-adversarial/convergence-summary.md` (F5 close record) |
| F6 targeted-hardening report (cycle-002) | `phase-f6-hardening/summary.md` (consolidated); `kani-results.md`, `fuzz-results.md`, `mutation-results.md`, `security-scan-results.md` (per-check detail) |
| F7 delta convergence report + traceability (cycle-002) | `phase-f7-convergence/delta-convergence-report.md`; `phase-f7-convergence/traceability-chain-delta.md`; `phase-f7-convergence/consistency-audit-delta.md`; `phase-f7-convergence/holdout-eval-delta.md`; `cycles/cycle-002/convergence/traceability-chain.md` (master) |
| cycle-001/cycle-002 convergence trajectory + session checkpoints + lessons + resolved blockers | `cycles/cycle-001/` and `cycles/cycle-002/` (see per-cycle files; cycle-002 session-checkpoints.md holds all prior F2-F7 + RELEASED + SESSION-WRAP checkpoints) |
| S-578-2/S-578-3/S-578-4 delivery artifacts | `cycles/cycle-002/S-578-2/`, `S-578-3/`, `S-578-4/` (red-gate-log.md, adversary-convergence-state.json); `code-delivery/S-578-2/`, `S-578-3/`, `S-578-4/` (pr-review.md, demos) |
| FIX-F5-001/FIX-F6-001/FIX-F7-001 delivery artifacts | `code-delivery/FIX-F5-001/`, `FIX-F6-001/`, `FIX-F7-001/` (pr-description.md, pr-review.md) |
| Release v0.7.0-dev.3 delivery artifacts | `code-delivery/release-v0.7.0-dev.3/` (pr-description.md, pr-review.md) |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**cycle-003 (new this burst — Wave 1 integration gate PASSED, adversary findings dispositioned):** the Wave 1 integration gate (`cycles/cycle-003/phase-f4-implementation/wave-1-integration-gate.md`) ran GREEN across build/test/clippy/fmt/gated-keychain-tests with both Wave 1 stories merged. Its adversary review returned 3 non-blocking findings: **(1) MED, carried into Wave 2 scope** — `auth list` STATUS (config-only) vs `auth status` Credentials (keychain-probing) disagree during the migration window this cycle introduces; `S-cycle3-credential-absence-guard`'s story file now carries a "Wave 1 integration-gate finding (MED)" section directing it to EVALUATE making `auth list`'s STATUS column credential-aware, implementing if it fits cleanly within the story's existing file list, else flagging it as a tracked PR-description follow-up rather than dropping it silently. **(2) LOW, standing drift, not folded into any cycle-003 story** — `auth status` (documented read-only) can transitively trigger the OAuth `"default"`-profile lazy-migration WRITE via `load_oauth_tokens`; this is pre-existing OAuth behavior orthogonal to cycle-003's per-credential redesign, tracked here for future maintenance-cycle attention, not a cycle-003 blocker. **(3) LOW [process-gap], FIXED this burst** — `S-cycle3-percred-storage.md`'s `breaking_change` frontmatter (`false`) contradicted its own correctly-framed CHANGELOG entry and the actual migration-lockout behavior; corrected to `true` with an explanatory "Correction Note" section, input-hash refreshed (`3f4ee5d`→`f01a25d`). A systemic frontmatter-coherence CI guard was considered for this class of drift and its addition is **justified-deferred**: one observed instance, LOW severity, no evidence of a recurring pattern — revisit if a second instance surfaces.

**cycle-003 (carried forward, unchanged):** ADR-0011's docs/adr amendment is **STAGED, not applied** — `cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md` holds the amended (Status Deferred→Accepted) ADR-0011 body; the main-repo file `docs/adr/0011-type-level-profile-fence.md` on `develop` remains reverted to its pre-amendment content. **`S-cycle3-adr0011-newtype` (Wave 4, `status: ready`, not yet dispatched) MUST apply this staged amendment to `docs/adr/0011-type-level-profile-fence.md` as part of its implementation PR** — do not let the F4 PR skip this application step. DEC-NAMESPACE-COLLISION-RISK remains clean (max allocated ID DEC-330, no collision this burst).

**cycle-003 (resolved at F2-gate-approval burst — see `cycles/cycle-003/burst-log.md` Burst 7 for exact edits, not listed here as open):** F-1 (BC-1.2.051 wording alignment), NEW-1 (DEC-326 traceability citations), F-2 (ADR-0020 §Decision 7 note), and L-3 (delta-analysis.md phantom-citation footnote + input-hash refresh) are all FIXED, not merely tracked. F2 is CLOSED with zero open residuals.

**cycle-003 (resolved at F3-authored burst — see `cycles/cycle-003/burst-log.md` Burst 8 for exact edits, not listed here as open):** the F3-authoring fresh-context consistency audit's 3 findings are all FIXED — **F-1** (governance fix: all 7 `S-cycle3-*` story files' `status:` frontmatter corrected from stale `ready` to `draft` pending the F3 human approval gate; `STORY-INDEX.md`'s `last_updated` header text corrected in place to `draft` with a dated annotation), **F-2** (`decomposition-manifest.md`'s wave-pointer cross-reference corrected), and **F-3** (`dependency-graph-extended.md`'s `blocks:`-vs-`depends_on:` edge-source-of-truth convention note confirmed present and accurate). F3 authoring was VALIDATED with zero open consistency findings.

**cycle-003 (resolved at F3-gate-approved burst — see `cycles/cycle-003/burst-log.md` Burst 9 for exact edits, not listed here as open):** the F3 human approval gate is no longer pending — it was presented and returned APPROVED. All 7 `S-cycle3-*` story files' `status:` frontmatter flipped `draft`→`ready`; `STORY-INDEX.md`'s 7 cycle-003 rows updated to match (`total_stories` held at 168, no new rows). Both carried-forward items (S-MAINT-532 scope exclusion; the oauth-default-creation→remove-logout-semantics dependency edge) are RATIFIED — see DEC-329.

**cycle-003 (resolved at F4-Wave-1-story-1-merged burst — see `cycles/cycle-003/burst-log.md` Burst 10):** `S-cycle3-env-tag`'s implementation PR #752 squash-merged to `develop`; the story is no longer open work. DEC-330 (auto-merge policy) first applied there.

**cycle-003 (new residual, out of cycle-003 scope, not fixed here, unchanged from Burst 8):** `STORY-INDEX.md` has a pre-existing grep-count discrepancy — a naive unique-`S-*`-ID scan returns ~165 distinct IDs against the frontmatter's `total_stories: 168` counter. Very likely counting-methodology noise (prose mentions of story IDs outside table rows, list-numbering artifacts), not root-caused this burst. Flagged for reconciliation in a future maintenance pass; does not block F4.

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
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- ~142 historical stale `input-hash` artifacts factory-wide; standing debt, **not** a cycle-002 or cycle-003 blocker. cycle-003's own F2-authored specs' input-hash drift check ran at the F2 gate — the single STALE hit found (`delta-analysis.md`) was resolved as part of the L-3 fix.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`) -- the 3 `CYCLE-002-PROCESS-GAP-DEFERRAL` items above are candidates for future stories in this same epic.
