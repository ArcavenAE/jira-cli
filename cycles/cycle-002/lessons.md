---
document_type: lessons-learned
level: ops
version: "1.1"
status: in-progress
producer: state-manager
timestamp: 2026-08-27T00:00:00Z
cycle: "cycle-002-field-dx"
inputs: [STATE.md]
input-hash: "[live-state]"
traces_to: STATE.md
---

# Lessons Learned — cycle-002 (field-dx)

<!-- Durable lessons from this cycle for future VSDD factory runs.
     Organized by category: agent-level, process-level, infrastructure-level.
     Each lesson is numbered continuously and includes the pass/burst
     where it was discovered. -->

## Agent-Level

<!-- none logged yet this cycle -->

## Process-Level

1. **[process-gap] A count-discrepancy reconciliation must verify the semantically correct count, not force consistency onto whichever number appeared first.** Round-5 (F-NEW-1) corrected the D2 create-path collision guard's governed field set from 5 to what it called "nine" wire-key targets. Round-6's adversary pass-1 (M-1, MEDIUM) found this arithmetic itself was wrong: `--points`→`story_points` customfield id and `--team`→`team` customfield id are two distinct `customfield_NNNNN` wire keys, not one collapsed "resolved-id category" — the round-5 reconciliation had wrongly collapsed them into a single member to force the total to read "nine." The correct total is **ten** (5 original + 3 new static keys + 2 distinct resolved-id keys). When a later pass finds a prior round's count claim contradicted by a fresh independent count, the fix is to re-derive the correct value from first principles (what are the actual distinct entities being counted?), not to adjust wording so the old number still holds. This is a sibling failure mode to the round-5 lesson already tracked as `GUARD-SCOPE-COPY-PASTE-PATTERN` (a guard's scope copy-pasted from a sibling site instead of re-derived) — here the *count arithmetic* itself was propagated forward unverified rather than re-derived.
   _Discovered: Round-6 Pass 1 (M-1), 2026-08-26_

2. **[process-gap] F2 BC-citation authoring committed forward-looking `src/...::symbol` citations to not-yet-implemented symbols (`get_createmeta_fields`) without running `check-bc-citation-symbols.sh`; the guard runs only in spec-guard CI, so it wasn't caught until an F4 PR's CI ran, blocking ALL open PRs.** Lesson: F2/spec-authoring must run `check-bc-citation-symbols.sh` before commit, OR planned symbols must use guard-safe prose form until their implementing story lands. Owed follow-up: consider adding the citation guard to the local state-manager verification set for spec commits.
   _Discovered: BC-3.3.010 hygiene fix, 2026-08-26 (blocking S-578-1's PR #739)_

3. **[process-gap] Story AC-016 mandates two help-text tests in `issue_create_field.rs` while Task-2 places the AC-12 count fix in `issue_create_jsm.rs`** — an internal AC-to-Task placement conflict within the same story spec, surfaced only once the adversary cross-checked AC ownership against the Task breakdown.
   _Discovered: S-578-4 delivery, adversary Pass 1, 2026-08-30_

4. **[process-gap] Story File-Structure section states "edit.rs MUST NOT change" while the same story's Architecture-Mapping section requires extending the shared `resolve_edit_fields` signature, which necessarily touches edit.rs call sites** — a spec self-contradiction between two sections of the same story file. Implementation correctly followed Architecture Mapping; the File-Structure constraint was simply wrong for this story's actual design.
   _Discovered: S-578-4 delivery, adversary Passes 5/8/9, 2026-08-30_

5. **[process-gap] Task-2's test-inversion instruction updated test BODIES to assert the DEC-310-reversed behavior but did not mandate updating test NAMES or doc-comments, leaving 5 stale-name/stale-comment strays that took three adversary passes (P8, P10, P11) to fully surface and root-cause.** Lesson: any task instruction that inverts a test's asserted behavior must explicitly require renaming the test and refreshing its doc-comment in the same change — otherwise the test's name/doc actively lies about what its body now checks.
   _Discovered: S-578-4 delivery, adversary Pass 11 (root cause), 2026-08-30_

## Content-Level

1. **[content] The `:option` JSM wire-shape spec conflict: BC-3.8.008 EC-3.8.008-1/EC-3.8.008-3 carried a drafted-by-analogy OBJECT-wrap `{"cf":{"value":...}}` that contradicted AC-002's bare-parity STRING-wrap `{"cf":"V"}` and the shipped code.** Caught pre-convergence by reading the BC before dispatching the adversary; PO adjudicated STRING_WRAP; BC + story corrected. Lesson: drafted-by-analogy/parity-PENDING wire shapes are error-prone; verify BC↔story↔code consistency BEFORE running convergence, not after.
   _Discovered: S-578-3 delivery, pre-adversary-dispatch, 2026-08-27_

2. **[content] The `:asset` validation gap (adversary Pass 1, ADV-S578-3-P1-001, HIGH): the JSM L2 resolver initially dropped the platform sibling's 4-check value-shape validation** — a "mirror-required" call-site needs explicit parity verification + negative tests, not an assumption that copy-then-adapt preserved the guard. Also: PR coverage-count inflation from `mod common;` pulling 26 unrelated `common::wf` tests into the binary total (pr-reviewer B1) — report in-file deltas (61→81), not binary totals (107), when citing test-count growth.
   _Discovered: S-578-3 delivery, PR #742, adversary Pass 1 + pr-reviewer, 2026-08-27_

## Infrastructure-Level

1. **[infra-observation] Concurrent demo-recorder race: a parked-then-resumed background subagent emitted a `completed` task-notification while still running, causing a duplicate demo-recorder dispatch on the same worktree and a `git add -f` that force-added `docs/demo-evidence/` past repo policy #708.** Recovered via a mixed `git reset` to the pushed SHA. Demos correctly live on `factory-artifacts` at `.factory/demos/S-578-2/` (commit `d6a5151c`). Harness/infra behavior, not a VSDD agent-prompt gap; feedback already drafted directly to the human — no follow-up story needed.
   _Discovered: S-578-2 delivery, 2026-08-26/27_

2. **[infra-observation] Author-self-approve Stop-hook loop: the `validate-pr-review-posted` SubagentStop hook is unsatisfiable for author-owned PRs (GitHub forbids author self-approve; only COMMENTED is possible), causing pr-reviewer/pr-manager to loop and re-notify.** Recovered via `TaskStop`. Merge succeeded regardless (admin-bypass squash). Harness/infra behavior, not a VSDD agent-prompt gap; feedback already drafted directly to the human — no follow-up story needed.
   _Discovered: S-578-2 delivery, PR #741, 2026-08-26/27_

3. **[infra-observation] pr-manager over-orchestration: spawned its own verify sub-agents then stalled; separately, the auto-mode permission classifier denied `gh pr merge --admin` at the Bash layer.** Merge completed by the human manually. Harness/infra behavior, not a VSDD agent-prompt gap; feedback already drafted for the related hook issue — no follow-up story needed.
   _Discovered: S-578-3 delivery, PR #742, 2026-08-27_

## Policy Candidates

<!-- Lessons that should be formalized as governance policies.
     Reference the lesson number and proposed policy scope. -->

| Lesson | Proposed Policy | Scope | Status |
|--------|----------------|-------|--------|
| 1 | "Re-derive, don't propagate" count/scope reconciliation check | Any spec-convergence fix chain that reconciles a numeric count (BC/VP/wire-key/etc.) across multiple documents must independently re-derive the count from the underlying entities, not merely propagate the previously-cited number for consistency | proposed |
