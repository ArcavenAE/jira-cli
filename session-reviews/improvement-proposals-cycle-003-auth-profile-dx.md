---
document_type: improvement-proposals
date: 2026-09-03
run_id: cycle-003 (auth-profile-dx) — resume→F6→F7→release
source_review: review-2026-09-03-cycle-003-auth-profile-dx.md
proposal_count: 8
status: pending-human-review
review_window_hours: 72
---

# Improvement Proposals: cycle-003 (auth-profile-dx) session review

Full evidence and analysis for each proposal below is in
`review-2026-09-03-cycle-003-auth-profile-dx.md`. Each proposal awaits human
disposition (APPROVE / DEFER / REJECT) within the standard 72h window; any
proposal not dispositioned auto-defers to `improvement-backlog.md`.

---

## Proposal 1: Cost Tracking Initialization (carried forward, 6th cycle)

- **Category:** cost
- **Priority:** HIGH
- **Evidence:** `cost-summary.md` remains absent for a 6th consecutive cycle (cycle-001's #571/#577/SOH-ATTACHMENTS-1 lineage, cycle-002, and now cycle-003 all lack cost data). Cannot benchmark F6/F7 phase efficiency, attribute the operational-friction items below to a cost figure, or detect a runaway loop by cost signal.
- **Recommendation:** state-manager initializes `.factory/cost-summary.md` at cycle/F1 open with per-phase token-budget estimates; orchestrator appends actuals at each phase close (F4 wave, F5 round, F6 gate, F7 dimension, release).
- **Affected files:** `.factory/cost-summary.md` (new), orchestrator F1/F7 prompts.
- **Risk:** Low. Token counting is approximate and may need recalibration if model pricing/context-window behavior changes; an approximate number is still strictly better than "unknown" for six cycles running.

---

## Proposal 2: Durable Pattern for Long-Running Verification Jobs

- **Category:** workflow / infrastructure
- **Priority:** HIGH
- **Evidence:** The full `cargo test` suite (~26 minutes) and `cargo-mutants` runs were repeatedly killed when launched as sub-agent background tasks — the harness kills a sub-agent's background job when that sub-agent yields control, which is the normal control-flow shape of a verification agent kicking off a long job and reporting back. A **main-loop-owned** background job was also killed at approximately 1600 seconds (~27 minutes), suggesting an additional ceiling independent of sub-agent lifecycle. Recovery required chunking the suite by test binary and using main-loop-owned waiters with completion markers — a workaround improvised mid-session, not a documented default.
- **Recommendation:**
  1. Document "chunk by test binary + main-loop-owned waiter with an explicit completion marker" as the standard pattern for any verification run expected to exceed a few minutes (F6 targeted hardening, full regression, mutation testing).
  2. Investigate whether the ~1600s main-loop background-job ceiling is a hard platform limit or a configurable timeout; if configurable, raise it for verification-class jobs specifically.
  3. Consider a dedicated long-running-job runner (outside the sub-agent/main-loop background-task model entirely) for F6/mutation-testing-class work, since this project's regression suite is growing (2341 → 4763 tests in seven weeks) and will only make this worse.
- **Affected files:** `vsdd-factory` F6/formal-verifier workflow docs (chunking convention); harness background-job lifecycle policy (engine-side, likely outside this repo's control).
- **Risk:** MEDIUM. Chunking changes what "one verification run" means for reporting — needs a clear aggregation convention (e.g., a manifest of chunk results rolled into one gate verdict) so a chunked F6 run still reads as a single, auditable PASS/FAIL the same way an unchunked one does.

---

## Proposal 3: Prioritize the Keychain-Injection-Seam Follow-Up

- **Category:** quality / timing
- **Priority:** MEDIUM
- **Evidence:** macOS keychain prompts fire during auth integration test binaries, making F6/F7 test runs slower and semi-interactive (a human or agent must dismiss/pre-authorize OS-level prompts mid-run). This is the direct mechanical reason VP-AUTHDX-005/006/007/008 are gated behind `#[ignore]` + `JR_RUN_KEYRING_TESTS=1` and are therefore invisible to ordinary CI — a gap already tracked in `cycles/cycle-003/STATE.md` Drift/Standing items, but framed there purely as a CI-coverage gap rather than also as an active session-timing cost.
- **Recommendation:** Prioritize the already-tracked keychain-injection-seam story for the next maintenance/self-improvement cycle. This repo already has the exact seam pattern needed, applied to four other test-isolation problems (`JR_CONFIG_DIR`, `JR_CACHE_DIR`, `JR_SERVICE_NAME`, `JR_STDIN_IS_TTY` — all `#[cfg(debug_assertions)]`-gated, release-binary-safe, each pinned by its own `tests/*_release_gate.rs`). Applying the same pattern to keychain access (an injectable `Entry`-construction seam, debug-only) would let `store_api_token`/`load_api_token` be tested without touching the real OS keychain, closing both the CI-coverage gap and this session's timing friction in one change.
- **Affected files:** `src/api/auth.rs` (keychain access layer — the seam target), `tests/oauth_refresh_integration.rs`, `tests/multi_cloudid_disambiguation.rs`, a new `tests/jr_keychain_seam_release_gate.rs` mirroring the existing release-gate pattern.
- **Risk:** LOW. This is applying a proven, already-4x-used pattern in this codebase, not inventing a new mechanism. Primary risk is scope creep if the seam is generalized beyond what F6/F7 actually need — keep it narrowly scoped to the `Entry` construction call, mirroring `JiraClient::new_for_test`'s precedent.

---

## Proposal 4: Codify the F7 Pre-Gate Fresh-Context Consistency Audit as a Standing Step

- **Category:** convergence / template
- **Priority:** HIGH
- **Evidence:** This is the 2nd project cycle where a fresh-context/cross-perspective check found real findings a converged pipeline had missed, run before the human gate rather than discovered post-release: SOH-ATTACHMENTS-1's Step-7 secondary review found a cross-model-unique HIGH-value refactor candidate after 14 primary adversarial rounds missed it; cycle-003's F7 pre-gate consistency audit found 12 findings (1 CRIT/3 HIGH/2 MED/6 LOW, all documentation/index-layer, zero code defects) including a CRITICAL (STORY-INDEX.md frozen at F3-status language despite all 7 stories shipping through F4–F6). Both instances are currently ad hoc additions rather than named, mandatory workflow steps.
- **Recommendation:** Add a named "F7 pre-gate fresh-context consistency audit" step to the F7 delta-convergence workflow with its own template/report artifact (mirroring `phase-f7-convergence/consistency-audit-delta.md`'s shape from this cycle), run unconditionally before every F7 human gate, not only when an agent happens to decide to run one.
- **Affected files:** `vsdd-factory:phase-f7-convergence` workflow/skill; a new consistency-audit report template alongside the existing delta-convergence-report template.
- **Risk:** LOW. Adds one audit pass of cost per cycle; net-positive given a 2/2 hit rate on real, gate-relevant findings across the two cycles where it has been tried.

---

## Proposal 5: Reconcile Report-Only Dispatch with Posting Hooks

- **Category:** agent / gate
- **Priority:** MEDIUM
- **Evidence:** A hook demanded the pr-reviewer agent post `pr-review.md` and/or run `gh pr review`, directly conflicting with the orchestrator's explicit "report-only, do not post/merge" dispatch instruction for that specific invocation. The agent spent approximately 3 turns refusing the hook's demand before the conflict resolved. This is structurally the same class of problem as the previously-tracked "pr-reviewer hook vs. DEC-173" conflict from SOH-ATTACHMENTS-1 (occurrences 1–3 in that lineage): a hook enforces a blanket rule with no visibility into an orchestrator-level, dispatch-scoped exception.
- **Recommendation:** Either (a) have the orchestrator pre-authorize the `pr-review.md` artifact write up front whenever it issues a report-only dispatch, satisfying the hook's requirement without contradicting the "do not post to GitHub" intent, or (b) extend the posting-hook to recognize an explicit report-only dispatch flag and skip enforcement in that mode. Recommend merging this pattern-database entry with the existing hook-vs-DEC-173 lineage (now its 4th occurrence across cycles) rather than tracking as a fresh, unrelated pattern.
- **Affected files:** posting-hook configuration (`.claude/hooks/`, engine-side); orchestrator pr-reviewer dispatch template/prompt.
- **Risk:** LOW-MEDIUM. Option (b) requires the hook to trust a self-reported dispatch-mode flag, which is a small trust-boundary widening; option (a) avoids that by satisfying the hook's literal requirement rather than bypassing it, and is the lower-risk choice.

---

## Proposal 6: Tighten Git-Hook Scope Detection (Two False Positives)

- **Category:** agent / infrastructure
- **Priority:** MEDIUM
- **Evidence:**
  (a) `validate-factory-path-staging` blocked a `git add` bundling explicit non-`.factory` file arguments inside a compound command, and separately mis-attributed the active branch as `develop` when running inside a worktree (whose actual branch differs from `develop`).
  (b) `verify-git-push` blocked a command because the literal substring `--force` appeared in a co-located `git worktree remove --force` within the same compound shell command, even though the actual `git push` invocation in that command carried no force flag at all.
  Both required a workaround (isolating the `git add`; splitting the compound command) rather than being fixed at the hook.
- **Recommendation:**
  (a) Parse the explicit file arguments of a `git add` invocation rather than pattern-matching across the whole command string; make branch detection read the actual current branch of the invoking worktree (`git branch --show-current` scoped to that worktree's cwd) instead of assuming a default.
  (b) Scope `--force` detection to tokens following the `git push` verb specifically (or to a parsed argument list for that sub-command), not to the full compound command string.
- **Affected files:** `.claude/hooks/` (the factory-path-staging and git-push-verification hook implementations, engine-side).
- **Risk:** LOW. This narrows existing over-broad pattern matching to the actual command shape being gated — it does not remove any real enforcement, only false positives on adjacent, unrelated tokens/commands.

---

## Proposal 7: Apply `--update` in Topological/Dependency Order

- **Category:** workflow
- **Priority:** LOW
- **Evidence:** cycle-003's bookkeeping artifacts (manifest/graph/schedule/holdout files) did not fully converge under repeated `--update` runs, due to circular input dependencies among the files themselves (a change to one artifact re-invalidates another that was already just updated). Documented as a non-blocking bookkeeping cascade — 6 residual STALE files remained at cycle-close. This is the same underlying class as the already-open `TWIN-ARTIFACT-SWEEP` pattern in this project's pattern database (fix rounds must propagate to all mirroring artifacts simultaneously; here, the propagation order itself is the defect).
- **Recommendation:** Before applying `--update` in bulk across cycle-scoped bookkeeping artifacts, compute a dependency order among them (a small topological sort over "artifact A cites/derives-from artifact B" edges) and apply updates in that order, rather than an arbitrary or alphabetical pass order.
- **Affected files:** `vsdd-factory:check-input-drift` skill/tooling (engine-side).
- **Risk:** LOW. This is an ordering fix to existing update logic, not new validation surface; worst case it converges no faster than today if the dependency graph itself has a genuine cycle (in which case the tool should say so explicitly rather than silently leaving residual STALE files).

---

## Proposal 8: Retire or Scope the Engine-Dogfood Citation Convention Check for Non-Engine Projects

- **Category:** template
- **Priority:** LOW
- **Evidence:** state-manager's citation-convention hook flags the engine's own `D-NNN` dogfood decision-ID convention as expected, when this project (jira-cli) uses `DEC-NNN` throughout its own STATE.md/CLAUDE.md. This fires as advisory noise on essentially every state-manager burst that touches decisions, with zero actionable content — the project's convention is deliberate and consistent, not a defect.
- **Recommendation:** Either scope the `D-NNN` convention check to the engine's own dogfood repository specifically, or make the expected prefix project-configurable — e.g., auto-detect it from the first decision-ID pattern already present in the target project's STATE.md rather than hard-coding `D-NNN` as the universal expectation.
- **Affected files:** state-manager citation-convention hook (engine-side).
- **Risk:** LOW. This narrows an existing check's applicability; it does not remove any check that has ever caught a real defect in this project's history (searched: no instance of this check catching a genuine cross-project citation error was found in the reviewed artifacts).

---

## Disposition Table (to be filled in by human review)

| # | Proposal | Category | Priority | Disposition | Notes |
|---|----------|----------|----------|--------------|-------|
| 1 | Cost tracking initialization | cost | HIGH | pending | 6th consecutive cycle carried forward |
| 2 | Long-running verification job pattern | workflow/infra | HIGH | pending | |
| 3 | Keychain-injection-seam prioritization | quality/timing | MEDIUM | pending | Closes 2 tracked gaps at once |
| 4 | Codify F7 pre-gate consistency audit | convergence/template | HIGH | pending | 2/2 hit rate on real findings |
| 5 | Reconcile report-only dispatch vs. posting hook | agent/gate | MEDIUM | pending | Likely same lineage as hook-vs-DEC-173 |
| 6 | Tighten git-hook scope detection | agent/infra | MEDIUM | pending | 2 false-positive instances this session |
| 7 | Topological `--update` ordering | workflow | LOW | pending | Same class as TWIN-ARTIFACT-SWEEP |
| 8 | Scope engine-dogfood citation check | template | LOW | pending | Advisory noise only, no defect caught |
