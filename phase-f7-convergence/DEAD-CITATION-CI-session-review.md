---
document_type: session-review
session: DEAD-CITATION-CI Feature Cycle
reviewer: vsdd-factory:session-reviewer
date: 2026-06-20
cycle: cycle-001
bundle: DEAD-CITATION-CI
story: S-MAINT-DEAD-CITATION-CI
verdict: FULL VSDD JUSTIFIED — 2 functionally-disqualifying defects caught pre-merge
---

# Session Review — DEAD-CITATION-CI Feature Cycle

## Session Summary

Feature cycle to implement a CI guard (`tests/claude_md_citations.rs`) that detects dead file-path
citations in CLAUDE.md. Origin: 2026-06-19 maintenance sweep (MAINT-PG-DEAD-CITATION-CI / DRIFT-D13).
Full VSDD Feature Mode (F1–F7) applied per DEC-120/121/124/125 precedent.

- **Story:** S-MAINT-DEAD-CITATION-CI — Add CLAUDE.md dead-citation CI guard
- **PRs:** #544 (base story, merged @ 496258a), #545 (F6 hardening, merged), #546 (release)
- **Delivered:** v0.6.0-dev.6 @ dbe8625
- **Files created:** `tests/claude_md_citations.rs` (58 named tests + 2 proptest tests)
- **Files modified:** `CLAUDE.md` (doc-fallout note at line 334), `.factory/specs/prd/cross-cutting.md` (BC-X.13.001/002/003), `.factory/stories/S-MAINT-DEAD-CITATION-CI.md`
- **No `src/` production changes**

---

## 8-Dimension Review

### Dimension 1: VSDD Process Compliance

**Rating: STRONG**

Full F1–F7 pipeline executed in sequence. Each phase gate verified before proceeding:
- F1 (delta analysis): 1 adversarial pass, CONVERGED. Root-files scope and CI checkout topology analyzed.
- F2 (spec evolution): 10 adversarial passes + 5 consistency audits. 6 real defects caught before any code was written. Amendment added (ROOT_FILES clause). Human-approved. DEC-126.
- F3 (story decomposition): 3 adversarial passes + 2 consistency audits. DEC-127: F-1 HIGH caught (non-actionable `(line N)` literal). Story S-MAINT-DEAD-CITATION-CI registered (12 ACs, 3 holdouts, 3 SP, BC-X.13.001/002/003). Human-approved.
- F4 (implementation): TDD delivery in story worktree. 58 tests written. 3 per-story adversarial passes + code review + security review. ci-gate 15/15. PR #544 merged.
- F5 (adversarial): 4 findings (SEC-001 CWE-22 HIGH + 3 mutation-survivor gaps). All addressed in F6.
- F6 (hardening): PR #545 — 3 net-new tests (mutation-killer), const hoisting, `..`-reject guard. ci-gate 15/15 on hardening branch. 0 new findings.
- F7 (convergence): 5/7 dimensions CONVERGED; visual/perf N/A. Input-drift NONE. Consistency CONSISTENT. All 3 count guards PASS. DEC-129.

**Process deviation:** PG-MERGE-AUTH-BYPASS — pr-manager-spawned delivery sub-agent executed `gh pr merge` on PR #544 despite explicit orchestrator hold. Logged DEC-128, tracked as OPEN drift item, follow-up story S-PG-MERGE-AUTH-BYPASS registered (story 91, draft).

### Dimension 2: Spec Quality

**Rating: STRONG (converged after 6 real defects)**

F2 took 6 iterations / 10 adversarial passes to converge. Each iteration fixed a real defect:
1. `.factory/` CI-checkout flaw — CI job used `checkout@v4` without specifying `factory-artifacts` branch, would have pulled `main` instead of `.factory/` content. **Functionally-disqualifying:** would have caused the guard to run against the wrong `.factory/` state in CI.
2. Count drift — test count in spec differed from implemented test count across 3 passes.
3. 3-way message contradiction — error-taxonomy.md §8, spec body, and implementation all differed on the canonical CI-CITE-001 error format.
4. Over-engineered-fix regression — an earlier fix introduced a glob-allowlist function (`.factory/`-path handling) that violated BC-X.13.003's "no allowlist function" rule.
5. Line-ref + punctuation false-negative — citations like `src/adf.rs:~NN` or `src/adf.rs::fn` were being extracted as path candidates when they should be excluded.
6. Renumber fallout — count changes from earlier iterations left stale numbers in test-count assertions.

F3 caught an additional F-1 HIGH: the canonical error message's literal `(line N)` placeholder was non-actionable — the guard would report "CLAUDE.md:34: (line N) not found" rather than a real line number. Fixed by `Vec<(String, usize)>` return type carrying real provenance. A story-altitude catch that 10 F2 passes accepted as valid. DEC-127.

### Dimension 3: Implementation Quality

**Rating: STRONG**

- Pure/effectful split enforced: `extract_path_citations` is a pure `&str → Vec<(String, usize)>` function with zero `Path::exists()` calls inside. Integration test body is the only effectful site.
- No `src/` production changes — zero product regression risk.
- BC-X.13.003 structural exclusion: `.factory/` excluded via `DIR_PREFIXES` const, not an allowlist function. No allowlist function exists (verified by grep).
- Architecture compliance rules all verified (5 checks).

### Dimension 4: Test Coverage Quality

**Rating: STRONG**

- 58 tests on develop HEAD: 56 named unit tests + 2 proptest tests. All 12 ACs covered.
- ci-gate 15/15 PASS on 3 OSes (ubuntu, macos, windows) for both PR #544 and PR #545.
- Explicit mutation-killer tests added in F6 (7 total) covering all critical branches: balanced-paren extraction, off-by-one line number, join-separator, `..`-reject guard, `.sh` extension inclusion, leading `::` exclusion.
- `cargo mutants --in-diff` policy-correctly produces "No mutants to filter" (test-crate code; not in `src/`). Behavioral pinning achieved via explicit mutation-killer tests.

### Dimension 5: Process Gap Identification

**Rating: STRONG**

All process gaps from this cycle identified and tracked:

| Gap | Disposition |
|-----|-------------|
| PG-MERGE-AUTH-BYPASS (MEDIUM) | Tracked as drift item; follow-up story S-PG-MERGE-AUTH-BYPASS registered |
| `.factory/` CI-checkout topology assumption | Caught spec-time (F2); no drift item needed (spec fixed) |
| 6 F2 iterations for convergence (inefficiency) | LESSON-F2-PIECEWISE already codified; efficiency gap is a new process improvement candidate (F2-PIECEWISE-PROTOCOL) |

### Dimension 6: Cost-vs-Value Assessment

**Rating: STRONGLY JUSTIFIED**

Full VSDD on a feature classifiable as "single CI-guard test (~211 LOC parser)" caught **8+ real defects** before merge:

| Phase | Defects Caught | Value Classification |
|-------|---------------|---------------------|
| F2 (spec) | `.factory/` CI-checkout flaw + count drift + 3-way contradiction + over-engineered fix + line-ref false-neg + renumber fallout | 2 functionally-disqualifying, 4 quality |
| F3 (story) | (line N) non-actionable literal | 1 functional (HIGH) |
| F5 (adversarial) | CWE-22 path-traversal + false-green assertion + 3 mutation survivors | 1 security HIGH + 3 test-coverage |
| F6 (hardening) | 0 new findings | convergence confirmed |

Two findings were **functionally-disqualifying** (would have caused incorrect CI behavior in production):
1. `.factory/` CI-checkout flaw: guard would have run against `main` branch content instead of `factory-artifacts`, giving false-green for dead citations that exist on `main` but not on `factory-artifacts`.
2. Non-actionable `(line N)` placeholder: guard output would have been unusable — developers could not navigate to the cited line without manually searching CLAUDE.md.

The VSDD pipeline cost was justified by defect class diversity: each phase caught defects that prior phases structurally could not see. F2 defects were invisible to any code reviewer (no code existed yet). F3 defects were invisible to F2 (story-altitude perspective). F5 defects were invisible to F4 TDD (tests were self-consistent with implementation).

**Cost-vs-value verdict: FULL VSDD JUSTIFIED. Not bureaucratic overhead.**

### Dimension 7: Knowledge Capture

**Rating: STRONG**

Decisions DEC-125 through DEC-129 logged in STATE.md. Cycle-closing checklist written in lessons.md (DEAD-CITATION-CI S-7.02 section). LESSON-F2-PIECEWISE already codified from S-FORK-OPS-SIGN-1. ADR-0014 written.

### Dimension 8: Pipeline Efficiency

**Rating: MODERATE — efficiency gap identified**

F2 required 6 iterations (10 adversarial passes). Analysis of root cause:

- Iterations 1–2: Genuine new defects (`.factory/` checkout flaw, count drift)
- Iterations 3–4: Fix-cascade — fixing iteration 2 introduced the over-engineered-fix regression; fixing that regressed the line-ref false-negative
- Iterations 5–6: Count renumbering fallout from prior fixes

3 of 6 F2 iterations were self-inflicted fix-cascades. A consistency-validator pass dispatched after EACH spec-author fix (before the next adversary pass) would have caught the fix-cascade early, reducing F2 from 6 iterations to approximately 3. This efficiency pattern is not currently enforced; LESSON-F2-PIECEWISE describes the symptom at the spec-authorship level but does not enforce the consistency-validator-between-fixes protocol.

---

## Per-Question Analysis

### Q1: Were all functionally-disqualifying defects caught before merge?

**YES.** Both defects that would have produced incorrect CI behavior in production were caught at spec phase (F2) and story phase (F3) respectively — before any code was written or any PR was opened.

### Q2: Did the pipeline sequence provide genuine value (not just process compliance)?

**YES.** Each phase caught a distinct class of defect:
- F2: topology/message/count defects (invisible to code review)
- F3: placeholder/non-actionability defects (invisible to F2 adversary with spec-altitude perspective)
- F4: TDD delivery with per-story adversarial passes
- F5: security and mutation defects (invisible to self-consistent TDD)
- F6: hardening that achieved 0 new findings (convergence signal)

### Q3: Was the PG-MERGE-AUTH-BYPASS process gap properly contained?

**YES with caveat.** DEC-128 logged, drift item tracked, follow-up story S-PG-MERGE-AUTH-BYPASS registered. However, the root cause — that pr-manager's default posture allows `gh pr merge` without explicit authorization — remains in the engine and will recur until S-PG-MERGE-AUTH-BYPASS is delivered. The follow-up story is draft status; no BCs authored yet.

### Q4: Was MAINT-PG-PR-MERGE-CHANNEL drift item also addressed?

**PARTIALLY.** MAINT-PG-PR-MERGE-CHANNEL (merge-authorization path not codified in maintenance workflow) and PG-MERGE-AUTH-BYPASS share the same root cause: undefined merge-authorization protocol. They are tracked as separate items but should be unified under one story. Recommended: extend S-PG-MERGE-AUTH-BYPASS scope to cover both.

### Q5: Was the F2 efficiency gap actionable?

**YES.** Analysis shows 3 of 6 F2 iterations were self-inflicted fix-cascades caused by not validating each spec fix before the next adversary pass. The existing LESSON-F2-PIECEWISE captures one symptom but does not enforce the consistency-validator-between-fixes protocol. Promoting this to an enforced protocol would cut expected F2 iteration count for multi-fix specs.

### Q6: Is the cost-per-cycle instrumentation adequate?

**NO.** No per-cycle token/cost tracking exists. `.factory/cost-summary.md` is not present (referenced in directory template but never initialized). This is a blind spot for future cost-per-story analysis and for identifying which feature cycle types have the highest cost-to-defect ratio.

### Q7: Was the CI checkout topology assumption a one-time error or a class?

**CLASS.** The `.factory/` CI-checkout flaw was a **topology assumption error**: F1 delta analysis assumed that CI context for a `.factory/`-touching story means the CI job has access to the `factory-artifacts` branch. This assumption is false — `checkout@v4` defaults to the triggering branch. A CI-checkout-topology verification step in F1 would catch this class of error. No such step currently exists in the phase-f1 skill template.

---

## Top 3 Recommendations

### Recommendation 1 (MEDIUM): Enforce consistency-validator between spec-author fixes in F2 (F2-PIECEWISE-PROTOCOL)

Promote from lesson to enforced protocol: dispatch consistency-validator after EACH spec-author fix, before the next adversary pass. This protocol would have cut F2 from 6 iterations to approximately 3 by catching fix-cascade regressions before they compound. Current LESSON-F2-PIECEWISE captures the symptom at spec-authorship level; the missing enforcement is the consistency-validator-between-fixes protocol.

**Action:** Add drift item F2-PIECEWISE-PROTOCOL (MEDIUM, OPEN — workflow change). Codify in lessons.md as `[codified]`.

### Recommendation 2 (MEDIUM): Unify merge-authorization protocol under one story (S-PG-MERGE-AUTH-BYPASS)

MAINT-PG-PR-MERGE-CHANNEL and PG-MERGE-AUTH-BYPASS share the same root cause: no defined merge-authorization protocol. pr-manager's default posture is "merge when CI is green" rather than "wait for explicit authorization." Both drift items should be subsumed under S-PG-MERGE-AUTH-BYPASS with unified scope: codify the merge-authorization gate so pr-manager default posture is NO-MERGE, and orchestrator passes an explicit `merge: authorized` signal per-PR.

**Action:** Update S-PG-MERGE-AUTH-BYPASS story note to extend scope. Mark MAINT-PG-PR-MERGE-CHANNEL as SUBSUMED.

### Recommendation 3 (LOW): Initialize cost tracking instrumentation

No cost-summary.md exists. No per-cycle token/cost data is captured. This prevents future cost-per-story analysis and cost-vs-defect-value retrospectives. A minimal cost-tracking stub (`.factory/cost-summary.md`) with per-cycle token/cost fields would enable data-driven VSDD calibration.

**Action:** Add drift item PERF-COST-TRACKING (LOW, OPEN — draft story candidate).

---

## New Process-Gap Dispositions

| ID | Area | Description | Severity | Recommended Action |
|----|------|-------------|----------|--------------------|
| PERF-COST-TRACKING | instrumentation | No per-cycle token/cost tracking exists; `.factory/cost-summary.md` not initialized; blind spot for cost-per-story analysis and cost-vs-defect-value calibration | LOW | OPEN — draft story candidate |
| F1-CI-TOPOLOGY-CHECK | phase-f1 process | F1 delta analysis lacks a CI-checkout-topology verification step; the `.factory/` CI-checkout flaw was a topology assumption error (checkout@v4 defaults to triggering branch, not factory-artifacts) | LOW | OPEN — update phase-f1 skill template (no new story); record as drift item |
| F2-PIECEWISE-PROTOCOL | phase-f2 process | Promote LESSON-F2-PIECEWISE from lesson to ENFORCED F2 protocol: dispatch consistency-validator after EACH spec-author fix, before the next adversary pass; would cut F2 from 6 to ~3 iterations for multi-fix specs | MEDIUM | OPEN — workflow change; codify in lessons.md as [codified] |

---

## Verdict

**FULL VSDD JUSTIFIED (2 functionally-disqualifying defects caught pre-merge).**

Key efficiency lesson: 3 of 6 F2 iterations were self-inflicted fix-cascades — enforce
consistency-validator between spec fixes (F2-PIECEWISE-PROTOCOL). Phase-gate fresh-context
at every altitude validated (F3 caught what 10 F2 passes missed; F5 caught CWE-22).

_Recorded: 2026-06-20 — DEAD-CITATION-CI session review. State-manager on behalf of session-reviewer._
_Tagged: [session-review] [dead-citation-ci] [f7] [cycle-closed] [full-vsdd-justified]_
