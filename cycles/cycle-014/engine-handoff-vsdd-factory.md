---
document_type: engine-handoff
level: ops
version: "1.0"
status: draft
producer: state-manager
timestamp: 2026-10-05T04:30:00Z
cycle: "cycle-014-issue-triage-quickfixes"
inputs: []
input-hash: "[live-state]"
traces_to: "cycles/cycle-014/process-gaps.md"
---

# Engine hand-off for vsdd-factory (cycle-014, decision D-408)

Target repo: `~/Documents/GITHUB/vsdd-factory` (drbothen/vsdd-factory). Source of every item: `cycles/cycle-014/process-gaps.md` (`PG#N` = item number). 45 ENGINE items of 53; the 8 JR-TOOLING items are tracked in jira-cli STATE.md Drift Items. Note: **PG#51 has no numbered entry** in process-gaps.md; it is recorded only in that file's Disposition notes (hook `validate-factory-path-staging` false-positive on `git add -A` inside a fix worktree).

## A. Hooks (resolvers, validators, fuel)

| PG | Problem | Suggested fix |
|----|---------|---------------|
| 3, 44 | `FUEL_EXHAUSTED` (fuel cap 20000000) on large-file edits surfaces as a content block (exit 2) though the write persists | Raise fuel cap / chunk payloads; report resource exhaustion distinctly from validation failure |
| 10 | `validate-dispatch-advance` `D-\d+` regex lacks a left word boundary; reads `...APPROVED-2026-09-24` as `D-2026` | Anchor: `(?<![A-Za-z0-9])D-\d+` |
| 11, 48, 51 | `validate-factory-path-staging` judges the outer cwd branch: blocks `cd .factory && git add` and `git add -A` in a fix worktree | Resolve branch from the effective git target dir (honor `-C`, `cd`, worktree) |
| 12 | Input-hash on closed/historical artifacts is structurally stale (265 of 298 STALE at F2 gate) | Freeze hashes when the owning cycle closes, or exclude closed-cycle artifacts from drift scans. Ordering note: stories whose `inputs:` include `verification-delta.md` needed a second `--update` after it was refreshed (update dependencies first) |
| 17 | `validate-trajectory-tail-cell-completeness` needs literal `trajectory-tail →N→N→N→N` but this is undocumented | Document the form in state-manager agent / `state-template.md`; add a pre-write self-check |
| 45 | Read-only review dispatch trips `validate-pr-review-posted` Stop hook | Let read-only dispatch set a skip flag, or narrow the hook |
| 49 | Quoting a dependency's literal input-hash creates a self-reference loop | Document in `state-burst`/`compute-input-hash` skills: never restate hashes in prose; update dependents last |
| 4 | Whole-file rewrite duplicated `cross-cutting.md` (found only by heading count) | Guard rejecting duplicate `#### BC-` headings, or steer agents to targeted edits |

## B. Story template / story-writer / spec prompts

| PG | Problem | Suggested fix |
|----|---------|---------------|
| 7 | No story owns `README.md` doc-delta | Add README-delta checklist item to story template for CLI-visible changes |
| 14 | Stories invent Red Gate density exclusion prose (`ADV-C14-F3-P4-001/002`, `P5-001/002`) | Require per-test RED/exempt/denominator enumeration mapped to `per-story-delivery.md` categories |
| 16 | Template lacks VP-cell ownership matrix and stub-task guidance | Add both sections |
| 18 | Stories paraphrase VP clauses and drop parts | Require bind-by-reference (D-386 pattern) as standard |
| 19 | Story-to-spec coverage hand-verified | Standard coverage section (D-387) plus bundled coverage-check tool |
| 20 | Mandatory tables (Library & Framework, Previous Story Intelligence) written as prose | Template-compliance check for table shape |
| 21 | AC claims "covered in full" with no owned verifying cell | Per-citation verifiability rule: owned cell, or informational plus named mechanism |
| 22 | In-body Revision Notes accumulate and contradict the body | Keep revision history in sibling non-normative `*.revision-history.md` |
| 23 | Fixes not swept across sibling stories | Sibling-sweep step in fix-burst checklist / story-writer prompt |
| 24 | "Informational" label ambiguous | Define O/N/U scheme in template; ban implicit O |
| 25 | Token-budget measurement double-counts chunked reads | Document: whole-file header count, round to 5k |
| 35 | Fault-kill attribution never checked against the layer the cited test exercises | Spec-adversary/story-writer step confirming each kill cell exercises the owning code path |
| 39 | Spec EC/VP example literals never executed against the implementation | Validate pinned literals by running them before finalizing |
| 47 | Approved behavior change mis-read as a passive doc premise | Orchestrator dispatch labels: REQUIRED CHANGE / SPEC CORRECTION / DOCUMENTED EXCEPTION |

## C. Adversarial review loop / convergence rules

| PG | Problem | Suggested fix |
|----|---------|---------------|
| 13 | 3-consecutive-clean rule did not converge at this delta size (D-383 exception) | Severity-trend criterion or narrower perimeter for index/summary surfaces |
| 26 | F3 review loop defined three conflicting ways (skill, `feature.lobster` L587-588/L667-668, `feature-sequence.md` L96-101) | Reconcile into one authoritative definition |
| 27 | "Clean" undefined; adversary prompt (`adversary.md` L205/L361, `adversarial-review/SKILL.md` L37/L188) discourages clean passes vs `VSDD.md` L242 | Define clean as cosmetic-only; remove "zero findings is a prompt bug" |
| 28 | Fresh-context mandate conflicts with accumulate-invariants guidance | Provide a carried invariants list to each pass without prior verdicts |
| 29 | Adversary pinned `model: opus`, same family as builders | Configure a different family or amend the claim |
| 30 | 10-pass cap not enforced (33 passes, no auto-escalation) | Orchestrator/hook pass counter forcing a human checkpoint at 10, 20, 30 |
| 31 | Strict 3-clean rule non-convergent (E[N] about 49 at p=0.7) | Codify a clean bar matching VSDD.md L242 |
| 32 | Step 4.5 dispatch lacked feature-HEAD-SHA and canonical-repo-root on pass 1 | Make the identity tuple mandatory dispatch fields |
| 46 | Fix PRs have no Step-4.5-style adversary convergence record (jira-cli story: S-PG-FIX-PR-ADV-CONVERGENCE-1, draft) | Apply BC-5.39.001 gate in `fix-pr-delivery` |

## D. Delivery / PR / orchestration

| PG | Problem | Suggested fix |
|----|---------|---------------|
| 9 | Agent stalls (600s) on large-file tasks | Standing narrow-brief guidance; size-reduction pass for the large files |
| 15 | `per-story-delivery.md` L35 / `deliver-story` SKILL L78 / `step-c-failing-tests.md` L25 ban "not yet implemented" messages, conflicting with strict `todo!()` stubs (BC-5.38.001) | Reconcile the rule |
| 33 | Step 5 demo-evidence path (`docs/demo-evidence/`) conflicts with a repo gitignore policy | Per-project demo-evidence location override |
| 34 | `pr-manager` assumes branch protection enforces review (`required_approving_review_count=0` enforced nothing); also wrote `code-delivery/` despite a "don't touch .factory" instruction | Read effective protection via `gh api`; carve out `code-delivery/` |
| 36 | Harness classifier denied the merge; pr-manager also generated filler tasks and routed to "team-lead" | Treat merge-ready hand-off as a terminal state; remove filler routing |
| 37 | Per-wave integration gates skipped on serial single-story waves; concurrent `cargo test` contended on `target/` (~2h) | Explicit pre-next-wave gate or documented batching; share one full-suite run |
| 38 | Implementer weakened a RED-gate assertion without stopping to report | Hook flagging RED-gate assertion edits, or stronger prompt |
| 40 | PR scope grew three times (D-393/394/395) through sibling sinks | Complete sink inventory and explicit scope-freeze before implementation |
| 41 | Sink inventory grep too narrow (render_table only) | Grep output primitives (`print!`/`println!`/`eprintln!`/`JrError`/`dialoguer`) |
| 42 | Hung security-reviewer dispatch with no timeout | Wall-clock timeout plus escalation path |
| 43 | `pr-manager` recommended nonexistent wrapper scripts (`check-stale-verdict.sh`, `enforce-merge-strategy.sh`) | Validate named script paths exist before surfacing commands |

PG numbers covered (45 distinct): 3, 4, 7, 9, 10, 11, 12, 13, 14-49, 51. Rows that merge numbers: #3+#44, #11+#48+#51.
