---
document_type: session-review
date: 2026-09-03
run_id: cycle-003 (auth-profile-dx) — resume→F6→F7→release — develop @ 42e92b46 — v0.7.0-dev.4 SHIPPED (DEC-333)
path: 4
path_name: feature
product: jr (jira-cli)
duration: ~1 calendar day (2026-09-02 session resume from PAUSED F5-CONVERGED → 2026-09-03 release SHIPPED); full cycle-003 arc 2026-08-24 (F1 open) → 2026-09-03 (release)
total_cost: unknown (PERF-COST-TRACKING still open — cost-summary.md absent; 6th consecutive cycle with no cost data)
stories_delivered: 7 (all merged in a prior session; this session covers no new story delivery — F6 hardening, F7 convergence, and release only)
status: complete
proposals_adjudicated: pending (72h window opens 2026-09-03)
proposals_outcome: pending — see improvement-proposals-cycle-003-auth-profile-dx.md
---

# Session Review: jr (jira-cli) — feature — 2026-09-03

**Cycle:** cycle-003 (`auth-profile-dx`)
**Session scope:** resume from PAUSED (F5 already CONVERGED) → F6 targeted hardening → F7 delta convergence → release v0.7.0-dev.4 → cycle CLOSE
**Mode:** Feature Mode (F1–F7), brownfield, Rust
**Dates:** session resumed 2026-09-02 (F5 CONVERGED checkpoint) → 2026-09-03 (release SHIPPED, DEC-333); full cycle-003 arc began 2026-08-24 (F1 gate)
**Release:** v0.7.0-dev.4 @ `42e92b46` — SHIPPED (`release.yml` run `33769389700` SUCCESS, GitHub prerelease, 10 assets/5 targets)
**Reviewer model:** adversary tier (session-reviewer agent), independent of the builder model
**Prior review:** review-2026-07-25-soh-attachments-1.md (SOH-ATTACHMENTS-1, cycle-001 lineage)

## Executive Summary

This session picked up cycle-003 at F5-CONVERGED/PAUSED and drove it to a shipped release in roughly one calendar day: F6 targeted hardening passed clean on the first attempt (mutation 100% 28/28, security 0 CRIT/HIGH, regression 4763/0/157, Kani→proptest 0 GAP, fuzz justified-skip), F7 delta convergence scored 5/5 dimensions PASS with a holdout mean of 0.895, and a fresh-context consistency audit run *before* the human gate caught 12 doc/index findings (1 CRIT/3 HIGH/2 MED/6 LOW, all documentation/index layer, zero code defects) that a fully-converged pipeline had otherwise missed. The human approved F7 (DEC-332), directed the one outstanding HIGH be closed via a pre-release docs PR (#766, merged clean, CI 15/15), then explicitly authorized the release (DEC-333); the version-bump PR (#767) and a 5-target GitHub Actions release run both succeeded on the first attempt. All three tracked cycles (cycle-001, cycle-002, cycle-003) are now CLOSED.

The dominant story this session is not code-quality — the pipeline mechanics behind F6/F7 stayed clean — it is **operational friction between the VSDD workflow and its own execution harness**: long-running verification (full `cargo test`, `cargo-mutants`) was repeatedly killed by background-task lifecycle rules that don't distinguish a legitimately long-running verification job from an abandoned one; macOS keychain prompts made the auth test suite slow and semi-interactive; a posting-hook and an explicit report-only dispatch directive contradicted each other and burned agent turns; and two factory git-hooks produced false positives that required workaround rather than being fixed at the source. None of these were process failures in the VSDD sense (no gate was skipped, no quality bar was lowered) — they were friction in the substrate the pipeline runs on, and they are the actionable material of this review.

## Run Overview

| Metric | Value | Benchmark (SOH-ATTACHMENTS-1 / cycle-002 baseline) | Status |
|--------|-------|----------------------------------------------------|--------|
| Total cost | unknown | unknown (~4–6M tokens comparable arc) | DATA GAP (PERF-COST-TRACKING open, 6th consecutive cycle) |
| Session duration (resume → release) | ~1 calendar day | ~3 calendar days (wave-gate → F7, SOH-ATTACHMENTS-1) | FASTER (narrower scope: F6→F7→release only, not a full wave arc) |
| Stories delivered this session | 0 (all 7 delivered in a prior session; F4 already CLOSED at resume) | 7 (SOH-ATTACHMENTS-1) | N/A — different phase scope |
| F6 gate result | PASS, first attempt, 0 FIX-F6 candidates | PASS (cycle-002, FIX-F6-001 required 1 fix) | CLEANER |
| F6 mutation kill rate | 100% (28/28, 0 survivors) | 100% (cycle-002 adjudicated) | ON-PAR |
| F7 dimensions PASS | 5/5 | 5/5 (cycle-002) | ON-PAR |
| F7 holdout mean satisfaction | 0.895 | 1.00 (SOH-ATTACHMENTS-1, 12/12 MUST-PASS) | LOWER (still well above any documented pass floor; no regression flagged) |
| F7 pre-gate consistency audit findings | 12 (1 CRIT/3 HIGH/2 MED/6 LOW), all doc/index-layer, 0 code defects | not run as a distinct pre-gate step in SOH-ATTACHMENTS-1 | NEW PRACTICE, high value |
| Regression at F7 | 4763 passed / 0 failed / 157 ignored | 2341 passed / 0 failed (SOH-ATTACHMENTS-1) | GROWING (test suite ~2x larger cycle-over-cycle) |
| Human gate decisions this session | 2 (DEC-332 F7 approval, DEC-333 release authorization) | 3 (DEC-184..186, SOH-ATTACHMENTS-1) | LOWER (narrower session scope) |
| PRs merged this session | 2 (#766 docs fix, #767 version bump) | 15 (SOH-ATTACHMENTS-1, full delivery+F5 arc) | LOWER (narrower session scope) |
| Gate failures | 0 | 0 | PASS |
| Background-job kills during verification | ≥2 documented (sub-agent background `cargo test`/mutants; one main-loop background job at ~1600s) | not previously logged as a named pattern | NEW PATTERN, HIGH priority |
| API infra failures | 1 (529 overload, formal-verifier mid-run; recovered via resume) | occasional, not systematically tracked | consistent with known infra transience |

---

## 1. Cost Analysis

**Status: DATA GAP — `cost-summary.md` still absent. This is the 6th consecutive cycle without cost tracking** (cycle-001's issue #571/#577/SOH-ATTACHMENTS-1 lineage plus cycle-002 and now cycle-003 all lack it). The recommendation from the prior review (Proposal 1, SOH-ATTACHMENTS-1) was not implemented.

Qualitative cost drivers this session, reconstructed from the burst log:
- F6 targeted hardening ran once, clean, no re-verification needed — likely the cheapest F6 in project history (0 FIX-F6 candidates means no fix-round cost).
- F7's fresh-context consistency audit (Burst 20) was an **added** cost relative to a pipeline that skips pre-gate audits, but it is the single highest-value spend of the session: it found 12 real findings a fully-converged pipeline had missed, at a cost far lower than discovering the same gaps post-release.
- The session's actual burn was dominated by the operational friction items below (background-task kills forcing suite re-chunking, keychain-prompt slowdowns extending real wall-clock/interaction time on auth tests, and the pr-reviewer/hook deadlock burning ~3 turns) — none of which show up in a token-cost figure even if `cost-summary.md` existed, because they are wall-clock/retry costs, not raw token costs. This is itself an argument for tracking wall-clock alongside tokens, not just tokens.

**Self-cost awareness:** this session-review pass itself is read-only (STATE.md, burst-log.md, lessons.md, phase-f6/phase-f7 artifacts) and produced no code or state changes; its cost is not separately measurable without `cost-summary.md`, consistent with the same data gap it is flagging.

**Recommendation:** unchanged from the standing Proposal 1 lineage (IP-571-01 → SOH-ATTACHMENTS-1 Proposal 1) — initialize `cost-summary.md` at cycle open. See Improvement Proposal 1 below, now carried forward for a 6th time.

---

## 2. Timing Analysis

**Session wall clock (resume → release):** ~1 calendar day, 2026-09-02 (F5-CONVERGED checkpoint resume) → 2026-09-03 (release SHIPPED).

| Phase | Duration (approx.) | Notes |
|-------|---------------------|-------|
| Resume + F6 dispatch | same-day | Session resumed directly from a PAUSED/F5-CONVERGED checkpoint; F6 dispatched to formal-verifier immediately |
| F6 targeted hardening | same-day | Mutation, security, regression, Kani-substitution, fuzz-skip all completed in one pass; 0 fix candidates |
| F7 pre-gate consistency audit | same-day | 12 findings surfaced and triaged; 6 fixed immediately, HIGH-3/LOW-2/LOW-3 deferred to a docs PR, MED-1/LOW-4/LOW-6 deferred to a future maintenance cycle |
| F7 human gate | same-day | Human approved with a directive (fix HIGH-3 before release) |
| Docs fix PR #766 | same-day | Squash-merged, CI 15/15 |
| Release cut (PR #767 + tag + release.yml) | same-day | Human explicitly triggered; version bump, tag, and 5-target release build all succeeded first attempt |

**Bottleneck — background-task lifecycle vs. long-running verification (HIGH priority, new this session):** The full `cargo test` suite (~26 minutes) and `cargo-mutants` runs were **repeatedly killed** when launched as sub-agent background tasks — the harness kills a sub-agent's background job when the sub-agent yields control back to its caller, which is exactly what a verification sub-agent does after kicking off a long job. Even a **main-loop-owned** background job was killed at approximately 1600 seconds (~27 minutes), suggesting a hard ceiling independent of sub-agent lifecycle. The workaround — chunking the suite by test binary and using main-loop-owned waiters with explicit completion markers — recovered correctness but cost real session time and required the orchestrator to notice and re-architect the verification approach mid-session rather than having a known-good pattern to reach for.

**Secondary friction — macOS keychain prompts (MEDIUM priority):** auth integration test binaries trigger real-OS-keychain access prompts, making F6/F7 test runs slower and semi-interactive (a human or agent must dismiss or pre-authorize prompts). This directly extends wall clock on every cycle touching `src/api/auth.rs`/`cli/auth/`, and cross-references the already-tracked keychain-injection-seam follow-up (would also close the VP-AUTHDX-005/006/007/008 in-CI coverage gap — those tests are currently `#[ignore]`-gated behind `JR_RUN_KEYRING_TESTS=1` specifically because of this).

**Recommendation:** See Proposals 2 and 3 below (background-task pattern for long verification; keychain-injection-seam prioritization).

---

## 3. Convergence Analysis

**F5 was already CONVERGED at session start** (3/3 clean adversarial passes, carried over from the prior session — no new convergence work this session). This session's convergence-relevant work is F6 (automated gate, not an iterative round-based convergence) and F7 (5-dimension convergence, single pass, human-approved).

**F6 — single pass, clean:** Unlike cycle-002 (which required FIX-F6-001), cycle-003's F6 needed zero fix rounds. Mutation 100% (28/28), security 0 CRIT/HIGH/MED (1 pre-existing LOW, not delta-introduced), regression fully green, Kani→proptest substitution 0 GAP across all 9 VP-AUTHDX scenarios, fuzz justified-skip (no new byte-stream parser in the delta). This is the cleanest F6 in the tracked project history for a 7-story bundle.

**F7 — single convergence pass, but a pre-gate audit surfaced real drift:** The fresh-context consistency audit (Burst 20) ran *before* the human gate and found 12 findings: 1 CRITICAL (STORY-INDEX.md frozen at F3 status across all 7 stories despite F4–F6 completion), 3 HIGH (including the stale `docs/specs/multi-profile-auth.md`), 2 MEDIUM, 6 LOW — every one a documentation/index-currency gap, **zero implementation defects**. Six were fixed at audit time; HIGH-3/LOW-2/LOW-3 were deferred to a dedicated pre-release docs PR (#766) per human direction; MED-1/LOW-4/LOW-6 remain open, explicitly carried to a future maintenance/self-improvement cycle. This is the same "fresh-context audit finds what a converged pipeline missed" value pattern the project has seen before (cf. SOH-ATTACHMENTS-1's Step-7 secondary-review finding), but applied at the F7 pre-gate boundary instead of within F5 — worth codifying as a standing practice rather than an ad hoc addition.

**Holdout evaluation:** 0.895, PASS, no scenario below a documented floor. Lower than SOH-ATTACHMENTS-1's 1.00 but not flagged as a regression by any gate — worth a benchmark note (see Quality Signal Analysis) since this is the lowest holdout score on record for this project and warrants a one-line rationale in a future F7 report even when it clears the bar comfortably, so future reviews can tell "expected variance" from "early warning."

**Recommendation:** Formalize the F7 pre-gate fresh-context consistency audit as a standing, named step (not implicit best practice) in the F7 workflow — see Improvement Proposal 4.

---

## 4. Agent Behavior Analysis

**T1 compliance:** No violations observed this session. The formal-verifier (F6) and the F7 convergence/audit agents stayed within their read/verify scope; state-manager performed the cycle-close write and commit (`bcc90d01`) with no lock contention reported.

**pr-reviewer ↔ posting-hook deadlock (HIGH priority, new this session):** A hook demanded the pr-reviewer agent post `pr-review.md` and/or run `gh pr review`, directly conflicting with the orchestrator's explicit "report-only, do not post/merge" dispatch instruction for that invocation. The agent spent approximately 3 turns refusing the hook's demand before the conflict was resolved. This is a **contract mismatch between two enforcement layers** (the hook enforces "always post," the orchestrator's dispatch enforces "never post this time") rather than a defect in either layer alone — the hook has no way to know the dispatch was deliberately report-only.

**API 529 overload (infra transience, not agent behavior):** The formal-verifier was killed mid-run by an upstream 529; recovered cleanly via resume/re-dispatch and main-loop verification. No agent-side defect — noted for completeness since it consumed session time.

**Recommendation:** See Improvement Proposal 5 (authorize the pr-review.md artifact write up front in report-only dispatches, and/or make the posting-hook aware of report-only mode).

---

## 5. Gate Outcome Analysis

| Gate | Status | Notes |
|------|--------|-------|
| F6 targeted hardening (automated) | PASS, first attempt | 0 FIX-F6 candidates; cleanest F6 on record for this project |
| F7 pre-gate consistency audit | 12 findings, 6 fixed at audit time, 3 deferred to pre-release PR, 3 deferred to future cycle | All doc/index-layer; zero code defects |
| F7 human approval gate | APPROVED — CONVERGED (DEC-332) | Human directed HIGH-3 be fixed via a docs PR before release (partial override — not a rejection, a scoping refinement of what "convergence" required before shipping) |
| Docs fix PR #766 | PASS, CI 15/15, merged clean | W1/W2 review nits fixed in-PR, no re-round needed |
| Release version-bump PR #767 | PASS, human-authorized directly (DEC-333), not auto-merge-policy-covered | First attempt clean |
| `release.yml` run 33769389700 | SUCCESS, 5 targets, 10 assets | First attempt clean |

**Human override/correction frequency:** One partial-approval-with-directive (DEC-332: approve F7 but require HIGH-3 fixed pre-release) — this is a gate-threshold judgment call by the human, not a correction of agent output; the finding itself (HIGH-3) was correctly surfaced by the agent-run consistency audit. No agent output was corrected by the human this session; the human's role was disposition (what to fix now vs. defer) rather than defect-catching.

**Phase skip frequency:** None this session — F6 and F7 both ran in full; the only "skips" are the long-standing, re-affirmed justified skips (Kani formal verification, cargo-fuzz — both "not set up in repo," proptest substitution accepted) which are pre-existing project posture, not new decisions.

---

## 6. Wall Integrity Analysis

No wall-integrity issues were reported or evident in the reviewed artifacts for this session's scope (F6/F7/release). The formal-verifier and consistency-audit agents operated over the full `develop` tree as their mandate requires (F6/F7 do not carry an information-asymmetry wall the way F5 adversarial review or holdout evaluation do). No evidence of the pr-reviewer or any other agent referencing prior-review internal reasoning it shouldn't have seen.

One adjacent, non-wall-integrity observation: the **state-manager citation-convention hook noise** (flagging `D-NNN` engine-dogfood citation convention on a project that uses `DEC-NNN`) is advisory noise from a convention mismatch between the engine's own dogfood expectations and this product repo's established convention — not a wall breach, just a false-positive-shaped irritant. Tracked under friction item 7 below.

---

## 7. Quality Signal Analysis

**F6 mutation testing:** 100% kill rate (28/28), 0 survivors, 0 timeouts, 0 unviable. Scoped to `--in-diff` against `examine_globs`; per-file breakdown: `src/output.rs` 25 mutants (the DEC-314 env-tag display sanitizer — a security-relevant control-char/ANSI-injection guard added this cycle), `src/cache.rs` 2, `src/main.rs` 1. All caught.

**Security scan:** 0 CRITICAL / 0 HIGH / 0 MEDIUM; 1 pre-existing LOW (yanked `chacha20` crate, not delta-introduced, tracked for a routine `cargo update` at the next maintenance sweep).

**Kani → proptest substitution:** 0 GAP. All 9 VP-AUTHDX-001..009 scenarios have covering tests — 4 default-CI-covered, 5 keyring-gated (behind `JR_RUN_KEYRING_TESTS=1` + `#[ignore]`, a documented spec boundary, not an F6 gap, but the same boundary the keychain-injection-seam friction item above would close for CI visibility).

**Fuzz:** justified skip — no new untrusted byte-stream parser in the 17-file changed set; the one parse-shaped change (`ProfileConfig.env: Option<String>`) rides existing serde/figment deserialization and is covered by VP-AUTHDX-009's 1000-case tolerant-reader proptest.

**Regression:** 4763 passed / 0 failed / 157 ignored — full tree, all 112 integration binaries + lib unittests + doctests, clippy exit 0, fmt clean. This is roughly double SOH-ATTACHMENTS-1's 2341-test count seven weeks earlier — the test suite is growing at a healthy clip, which is also exactly why the background-task-kill friction on `cargo test`'s ~26-minute runtime (Timing Analysis, above) is only going to get worse without a durable pattern.

**Holdout evaluation:** 0.895 — the lowest score on record for this project (prior recorded scores are 1.00). No scenario fell below a documented pass floor and no gate treated this as a regression, but the absence of a stated floor or a one-line "why 0.895 and not 1.00" rationale in the F7 report means a future reviewer cannot distinguish "expected scenario-mix variance" from "early quality drift" by inspection alone. Recommend the holdout-eval report always include a floor value and a short delta rationale when the score changes from the prior cycle's score.

---

## 8. Pattern Detection (Cross-Run)

**NEW pattern — BACKGROUND-TASK-KILL-ON-LONG-VERIFICATION (HIGH severity, first occurrence, but structurally certain to recur):** Long-running `cargo test`/`cargo-mutants` invocations were killed both as sub-agent background jobs (killed when the sub-agent yields) and, at ~1600s, as a main-loop background job. As the regression suite grows (2341 → 4763 tests in seven weeks), this ceiling will be hit more often, not less. This is the single highest-priority new pattern from this session — see Improvement Proposal 2.

**NEW pattern — KEYCHAIN-PROMPT-TEST-SLOWDOWN (MEDIUM severity, first occurrence as a named pattern, though the underlying gap — VP-AUTHDX-005/006/007/008 gated behind `JR_RUN_KEYRING_TESTS=1` — has been a known, accepted spec boundary since cycle-003's F1):** worth promoting from "accepted spec boundary" to "active friction" now that it has a session-level cost attached (slow, semi-interactive F6/F7 runs), not just a CI-coverage-gap framing.

**NEW pattern — REPORT-ONLY-DISPATCH-VS-POSTING-HOOK-CONFLICT (MEDIUM severity, first occurrence):** structurally similar to the previously-tracked "hook vs. DEC-173" conflict class from SOH-ATTACHMENTS-1 (a hook enforcing a blanket rule collides with an orchestrator-level exception) — this is very likely the same underlying pattern class (hooks that cannot see dispatch-level intent) recurring in a new instance. Recommend merging this into the existing hook-vs-standing-rule pattern lineage rather than tracking as fully novel — see Improvement Proposal 5.

**NEW pattern — GIT-HOOK-FALSE-POSITIVE-ON-COMPOUND-COMMAND (MEDIUM severity, 2 instances this session):** (a) `validate-factory-path-staging` blocked a `git add` bundling explicit non-`.factory` files and mis-attributed the branch as `develop` inside a worktree; (b) `verify-git-push` blocked a command because `--force` appeared in a co-located `git worktree remove --force` even though the actual `git push` in the same compound command carried no force flag. Both are **scope-detection bugs in hooks that pattern-match across an entire compound shell command rather than parsing the specific verb/args they're meant to gate.** This is a distinct pattern from the two above (it's about hook precision, not hook-vs-policy conflict) — see Improvement Proposal 6.

**Cross-run: input-hash cascade non-convergence under repeated `--update` — recurring, not new.** cycle-003's bookkeeping artifacts (manifest/graph/schedule/holdout files) did not fully converge under repeated `--update` due to circular input dependencies among the files themselves; documented as non-blocking (6 residual STALE files at cycle-close). This is structurally the same class of problem as TWIN-ARTIFACT-SWEEP (already an open pattern in this database) — propagation order matters when artifacts reference each other. Recommend `--update` be applied in topological/dependency order rather than an arbitrary or alphabetical order. See Improvement Proposal 7.

**Cross-run: STATE-MANAGER-MONOLITHIC-WRITE-STALL — not observed this session.** Notably, the previously-tracked pattern (5 prior occurrences across SOH-BUGS-1/SOH-COMMENT-CRUD-1/SOH-ATTACHMENTS-1) did not recur in this session's burst log — the F7-close and release-cut bursts each used "one full-content Write, no Edit chain" per the codified DEC-247/feedback_statemd_full_write convention. This is a **positive cross-run signal**: the standing practice appears to be holding. Worth explicitly noting as resolved-in-practice rather than silently dropping it from future reviews' attention.

**Cross-run: fresh-context audit before human gate is a repeat-validated high-value practice.** This is the second project cycle (after SOH-ATTACHMENTS-1's Step-7 secondary review) where a fresh-context / cross-perspective check surfaced real findings a converged pipeline missed, at a point before the human gate rather than after. The pattern is now 2-for-2 in this project's history. Recommend formal codification (Improvement Proposal 4) rather than continued ad hoc application.

**Cross-run: clean releases.** Both cycle-002 and cycle-003 shipped on a first-attempt release run with no `release.yml` retries and no target failures. The release pipeline itself is a solved problem for this project at this point — no action needed, noted as a durable positive.

---

## 9. Governance Policy Audit

**`append_only_numbering`:** No BC renumbering, no ID reuse, no filename slug changes this session. BC count (733) and VP count (41) unchanged across F6/F7/release. PASS.

**`lift_invariants_to_bcs`:** No new invariants surfaced this session that required BC/EC elevation — F6/F7 were verification/convergence of already-spec'd behavior (VP-AUTHDX-001..009), not new-spec authoring. N/A this session.

**`state_manager_runs_last`:** state-manager committed factory-artifacts after each phase burst (F6 complete, F7 pre-gate fixes, F7 human-gate approval, release-cut, cycle-close `bcc90d01`) — confirmed via `.factory` worktree git log (Burst 18 through Burst 22). PASS.

**`semantic_anchoring_integrity`:** No anchor-scope changes this session (F6/F7/release phases do not author new SEC-*/BC-* anchors). N/A.

**`creators_justify_anchors`:** VP-AUTHDX-001..009 traced to named test functions per the F6 summary's per-VP coverage table (4 default-CI + 5 keyring-gated, each with an explicit rationale for its gating). PASS.

**`bc_array_changes_propagate_to_body_and_acs`:** BC-INDEX unchanged this session (733 BCs, 41 VPs, 106 holdouts, 168 stories — all held constant across F6/F7/release per STATE.md Convergence Status). N/A — no array changes to propagate.

**Deviation from standing policy, self-disclosed and justified:** the F7 pre-gate consistency audit found the STORY-INDEX.md index-currency gap (CRIT-1) — a case where an already-established governance expectation (index reflects shipped reality) silently drifted for four phases (F4 through F6) before being caught. This is not a new-policy gap; it is a **detection-timing** gap in an existing policy — the fix (Improvement Proposal 4 / Follow-Up Story 3) is to catch this at each wave-gate close rather than only at the F7 pre-gate audit.

**New policy candidate this session:** none beyond what is already captured in Improvement Proposals 4–8 above; no proposal here rises to the level of a new governance rule distinct from a workflow/tooling fix.

---

## Improvement Proposals

See `improvement-proposals-cycle-003-auth-profile-dx.md` for full proposals with evidence and affected files.

Summary:

### Proposal 1: Cost Tracking Initialization (carried forward, 6th cycle)
- **Category:** cost
- **Priority:** HIGH
- **Evidence:** 6th consecutive cycle with no `cost-summary.md`. Cannot benchmark F6/F7 efficiency or attribute the friction items below to a cost figure.
- **Recommendation:** State-manager initializes `cost-summary.md` at cycle/F1 open; orchestrator appends phase actuals.
- **Affected files:** `.factory/cost-summary.md` (new), orchestrator F1/F7 prompts.
- **Risk:** Low; approximate token accounting only.

### Proposal 2: Durable Pattern for Long-Running Verification Jobs
- **Category:** workflow / infrastructure
- **Priority:** HIGH
- **Evidence:** Full `cargo test` (~26 min) and `cargo-mutants` runs repeatedly killed as sub-agent background tasks; a main-loop background job was also killed at ~1600s.
- **Recommendation:** Establish a factory-level pattern for long verification: segment the suite by test binary (already used as a workaround — promote to documented default), prefer main-loop-owned background jobs with explicit completion markers over sub-agent-owned ones, or stand up a dedicated long-running-job runner that outlives a sub-agent's yield.
- **Affected files:** vsdd-factory F6/formal-verifier workflow docs; harness background-job lifecycle policy (engine-side).
- **Risk:** Chunking changes what "one verification run" means for reporting; needs a clear aggregation convention so chunked results still read as one gate verdict.

### Proposal 3: Prioritize the Keychain-Injection-Seam Follow-Up
- **Category:** quality / timing
- **Priority:** MEDIUM
- **Evidence:** macOS keychain prompts slow F6/F7 auth test runs and force semi-interactive execution; VP-AUTHDX-005/006/007/008 remain CI-invisible as a direct consequence (`#[ignore]` + `JR_RUN_KEYRING_TESTS=1`).
- **Recommendation:** Prioritize the already-tracked keychain-injection-seam story in the next maintenance/self-improvement cycle — it closes both the timing friction and the CI-coverage gap in one change.
- **Affected files:** `src/api/auth.rs` (keychain access layer), `tests/oauth_refresh_integration.rs`, `tests/multi_cloudid_disambiguation.rs`.
- **Risk:** Low; the seam pattern already exists for other test-isolation cases in this repo (`JR_CONFIG_DIR`, `JR_CACHE_DIR`, `JR_SERVICE_NAME`) — this is applying a proven pattern, not inventing one.

### Proposal 4: Codify the F7 Pre-Gate Fresh-Context Consistency Audit as a Standing Step
- **Category:** convergence / template
- **Priority:** HIGH
- **Evidence:** 2nd project cycle in a row where a fresh-context/cross-perspective check (SOH-ATTACHMENTS-1's Step-7; cycle-003's F7 pre-gate audit) found real findings a converged pipeline missed. cycle-003's instance found 12 findings (1 CRIT/3 HIGH/2 MED/6 LOW), all before the human gate.
- **Recommendation:** Make the fresh-context consistency audit a named, mandatory step in the F7 workflow (not an ad hoc addition), with its own template/report artifact, the same way F5's Step-7 secondary review should be standing per the prior review's Proposal 2.
- **Affected files:** `phase-f7-convergence` workflow/template; F7 delta-convergence-report template.
- **Risk:** Adds one audit pass of cost per cycle; net-positive given 2/2 hit rate on real findings so far.

### Proposal 5: Reconcile Report-Only Dispatch with Posting Hooks
- **Category:** agent / gate
- **Priority:** MEDIUM
- **Evidence:** pr-reviewer burned ~3 turns refusing a posting-hook's demand to post `pr-review.md`/`gh pr review` when the orchestrator's explicit dispatch was report-only.
- **Recommendation:** Either (a) have the orchestrator pre-authorize the `pr-review.md` artifact write up front whenever it dispatches a report-only review, or (b) make the posting-hook aware of a report-only dispatch flag so it doesn't fire in that mode. Likely the same underlying pattern class as the previously-tracked "hook vs. DEC-173" conflict (SOH-ATTACHMENTS-1) — should be merged into that lineage in the pattern database rather than tracked as fully separate.
- **Affected files:** posting-hook configuration (engine-side); orchestrator pr-reviewer dispatch template.
- **Risk:** Option (b) requires the hook to trust a self-reported dispatch-mode flag; option (a) is simpler and lower-risk.

### Proposal 6: Tighten Git-Hook Scope Detection (Two False Positives)
- **Category:** agent / infrastructure
- **Priority:** MEDIUM
- **Evidence:** (a) `validate-factory-path-staging` blocked a compound `git add` with explicit non-`.factory` file args and mis-attributed the branch as `develop` inside a worktree; (b) `verify-git-push` blocked a command because `--force` appeared in a co-located `git worktree remove --force`, not in the actual `git push`.
- **Recommendation:** (a) Parse explicit `git add <files>` arguments rather than pattern-matching the whole command; make branch detection worktree-aware (read the actual current branch of the invoking worktree, not an assumed default). (b) Scope `--force` detection to the `git push` verb specifically, not the whole compound command string.
- **Affected files:** `.claude/hooks/` (factory-path-staging and git-push-verification hooks, engine-side).
- **Risk:** Low; this is a precision fix to existing hooks, not new enforcement surface.

### Proposal 7: Apply `--update` in Topological/Dependency Order
- **Category:** workflow
- **Priority:** LOW
- **Evidence:** cycle-003's bookkeeping artifacts (manifest/graph/schedule/holdout files) did not fully converge under repeated `--update` due to circular input dependencies among the files; 6 residual STALE files at cycle-close, documented non-blocking. Same underlying class as the already-tracked TWIN-ARTIFACT-SWEEP pattern.
- **Recommendation:** Compute a dependency order among bookkeeping artifacts before applying `--update` in bulk, rather than an arbitrary/alphabetical pass order.
- **Affected files:** input-hash drift-check tooling (`check-input-drift` skill, engine-side).
- **Risk:** Low; ordering fix only, no new validation logic.

### Proposal 8: Retire or Scope the Engine-Dogfood Citation Convention Check for Non-Engine Projects
- **Category:** template
- **Priority:** LOW
- **Evidence:** state-manager's citation-convention hook flags `D-NNN` (the engine's own dogfood convention) on jira-cli, which uses `DEC-NNN` throughout — advisory noise, not a real defect, every cycle it fires.
- **Recommendation:** Scope the `D-NNN` convention check to the engine's own dogfood repo, or make it project-configurable (read the project's actual decision-ID prefix from an existing convention marker, e.g. the first DEC-* seen in STATE.md).
- **Affected files:** state-manager citation-convention hook (engine-side).
- **Risk:** Low; narrowing an existing check's scope, not removing a real guard.

---

## Reinforcement (What Worked Well)

1. **Fresh-context consistency audit before the human gate** proved its value a second time (2/2 cycles where a cross-perspective check found real findings a converged pipeline missed) — see Proposal 4 for codification.
2. **Main-loop-driven git writes (per DEC-331)** worked cleanly for both the docs PR and the release — no permission-classifier friction this session on the actions that were run from the main loop (the classifier gap on agent-initiated `gh pr merge` remains a known, separately-tracked constraint, not newly resolved).
3. **Clean 5-target release on the first attempt** — the release pipeline continues to be a solved, low-friction part of this project (2/2 recent cycles, cycle-002 and cycle-003, both first-attempt clean).
4. **STATE-MANAGER-MONOLITHIC-WRITE-STALL did not recur this session** — the "one full-content Write, no Edit chain" discipline (DEC-247) appears to be holding after 5 prior occurrences across three earlier cycles. Worth confirming this is durable rather than coincidental over the next 1-2 cycles before declaring the pattern closed.

---

## Follow-Up Stories / SELF-IMPROVEMENT Epic Candidates

The following are recommended as candidate stories for a future maintenance/self-improvement cycle, tying together this session's findings with cycle-003's own carried-forward process-gap deferrals (`cycles/cycle-003/lessons.md`):

1. **Keychain-injection-seam for auth tests** (Proposal 3) — closes both a timing-friction item from this session and the pre-existing VP-AUTHDX-005/006/007/008 CI-coverage gap tracked since cycle-003 F1. Highest-leverage single change: fixes two tracked problems with one seam.
2. **Long-running-verification job pattern** (Proposal 2) — engine-side, but directly gates how fast this project's own F6/F7 phases can run as its regression suite keeps growing (2341 → 4763 tests in seven weeks; will only get slower without a fix).
3. **STORY-INDEX index-currency sync at wave-gate close** (already codified in `cycles/cycle-003/lessons.md` Lesson 1 / Policy Candidate 1) — directly caused this session's F7 pre-gate audit CRIT-1 finding; recommend bundling with Proposal 4's audit-codification work since both touch the F7/wave-gate-close boundary.
4. **Story-template conformance check at authoring time** (already codified in `cycles/cycle-003/lessons.md` Lesson 2 / Policy Candidate 2) — 4/7 cycle-003 stories missing template sections; recommend bundling with #3 above as a single "gate-close bookkeeping discipline" story.
5. **Git-hook precision fixes** (Proposal 6) and **posting-hook/report-only reconciliation** (Proposal 5) — both engine-side, both low-risk precision fixes; good candidates for a small, self-contained engine-improvement batch.

---

## Metrics for Next Run

To validate improvements from this session:

1. **Background-task kill count during F6/F7 verification:** if Proposal 2 is applied, should trend toward 0 for any properly-chunked/main-loop-owned run. Any kill of a correctly-chunked job is a signal the pattern is incomplete.
2. **Keychain-gated test visibility in CI:** if the injection seam ships, VP-AUTHDX-005/006/007/008 should move from `#[ignore]`-gated to CI-default-run. Track the count of keyring-gated tests still requiring `JR_RUN_KEYRING_TESTS=1` — target 0.
3. **F7 pre-gate audit finding count and layer:** if STORY-INDEX/template-conformance sync-at-close is applied, the next cycle's F7 pre-gate audit should find 0 index-currency findings of the CRIT-1 class. Any recurrence means the sync step was not actually wired into the wave-gate-close procedure.
4. **Cost data availability:** if `cost-summary.md` is finally initialized, report actual token/wall-clock cost for the next cycle instead of "unknown" for a 7th consecutive time.
5. **Hook false-positive count:** if Proposal 6 lands, the two named hook classes (`validate-factory-path-staging`, `verify-git-push`) should produce 0 false positives on an equivalent compound-command shape in the next session.
