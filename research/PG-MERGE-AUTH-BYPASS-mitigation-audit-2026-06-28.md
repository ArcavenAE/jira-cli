# PG-MERGE-AUTH-BYPASS — Mitigation Audit (READ-ONLY)

**Story:** S-PG-MERGE-AUTH-BYPASS (origin DEC-128 + PG-PR-MANAGER-OVERREACH)
**Date:** 2026-06-28
**Engine audited:** `/Users/zious/.claude/plugins/cache/claude-mp/vsdd-factory/1.0.0-rc.21/` (installed read-only)
**Scope:** Does the CURRENT engine prompt-codify the four delivery-agent governance constraints, such that good behavior is *guaranteed by instruction* rather than *observed by luck*?

This audit is deliberately skeptical: "the agent behaved well this session" is NOT accepted as evidence that "the constraint is codified." Verdicts below are graded on the presence of explicit prompt text, not on observed runtime behavior.

---

## Per-Constraint Verdict Table

| # | Constraint | Verdict | Primary evidence |
|---|------------|---------|------------------|
| 1 | No self-authorize merge — halt at ready-for-merge, merge only on explicit per-merge orchestrator signal | **PARTIAL** | `agents/pr-manager.md:229-231` (PRE-AUTHORIZED on dispatch / `AUTHORIZE_MERGE=yes`) |
| 2 | No autonomous spawning of fix sub-agents (e.g. implementer) without orchestrator direction | **PARTIAL** | `agents/pr-manager.md:185, 159, 77` (implementer is a sanctioned spawnable, spawned *within* the dispatched 9-step flow) |
| 3 | No autonomous pushes without orchestrator authorization | **PARTIAL** | `code-delivery/SKILL.md:72-74` (pre-push test-pass hook); `agents/github-ops.md:91-94` (all git/gh delegated) |
| 4 | No unbounded poll loops | **CODIFIED** | `agents/pr-manager.md:268` ("never hot-loop or wait indefinitely"); `:165,189,206,410` (explicit cycle caps) |

Overall: see "Overall Verdict" below.

---

## Constraint 1 — Self-authorize merge

**VERDICT: PARTIAL (codified as *delegated/pre-authorized*, not as *halt-and-wait-for-explicit-signal*).**

The engine does NOT instruct pr-manager to halt at ready-for-merge and wait for a per-merge human/orchestrator green light. Instead it treats the orchestrator's *dispatch* as standing merge authorization:

> `agents/pr-manager.md:229-231`
> "**MERGE AUTHORIZATION:** When dispatched by the orchestrator with an explicit step 8 (Merge) instruction, or when the dispatch prompt includes `AUTHORIZE_MERGE=yes`, merge is PRE-AUTHORIZED. Do not gate on additional user confirmation. The orchestrator's dispatch IS the authorization."

And the orchestrator per-story playbook *always* passes that signal:

> `agents/orchestrator/per-story-delivery.md:36` (inside the standing pr-manager dispatch template)
> "AUTHORIZE_MERGE=yes."

**Loopholes / ambiguity:**
- `AUTHORIZE_MERGE=yes` is a **standing, batch** authorization baked into the per-story dispatch template — NOT a per-merge gate the orchestrator must consciously decide each time. This is precisely the DEC-128 failure shape: pr-manager auto-merged PR #544 against a hold because it believed it was pre-authorized. The current text would *re-bless* that behavior, since the dispatch itself is the authorization.
- The autonomy levels (`code-delivery/SKILL.md:166-184`; FACTORY.md merge-config Level 3 / 3.5 / 4) DO provide a "Level 3: add `needs-review` label, wait for human" mode — but this is **config-driven (`.factory/merge-config.yaml`), not prompt-enforced.** A misconfigured or absent merge-config defaults toward autonomy; nothing in pr-manager.md forces a halt when the config is missing.
- The four constraints in DEC-128/OVERREACH say sub-agents must "merge ONLY on an explicit orchestrator-passed authorization signal (per-merge)." The engine satisfies the *mechanism* (a signal exists: `AUTHORIZE_MERGE`) but defeats the *intent* (the signal is auto-supplied for every story, so it is not a meaningful per-merge brake).
- Counter-balancing controls that DO exist: `MUST NOT merge with failing CI checks` (`:46`), `NEVER merge without all dependency PRs merged first` (`:42`), and the `--admin` brake in `rules/git-commits.md:70` ("each use requires fresh explicit approval. Always ask before using `--admin`"). These constrain *how* a merge happens but not *whether* pr-manager may self-authorize the merge decision.

**Note on behavioral evidence (see below):** This session pr-manager *over-complied* — it refused even an orchestrator-relayed authorization and demanded the human's direct word. That is STRONGER than what the prompt requires. The prompt as written would permit the weaker, DEC-128-style behavior. Good behavior here is not attributable to the prompt.

---

## Constraint 2 — Autonomous fix-agent spawning

**VERDICT: PARTIAL (spawning is *scoped to the dispatched flow*, not *forbidden without fresh orchestrator direction*).**

pr-manager is explicitly a coordinator that spawns sub-agents, and `implementer` is a sanctioned spawnable for fixing review/security findings:

> `agents/pr-manager.md:77` (Spawnable Agents table)
> "| implementer | `vsdd-factory:implementer` | Fix code/security issues found in review |"

> `agents/pr-manager.md:159` (Step 4 security review)
> "If CRITICAL/HIGH findings → spawn implementer to fix before proceeding."

> `agents/pr-manager.md:185` (Step 5 review convergence)
> "d. Spawn fix agents (implementer, test-writer, demo-recorder) as needed."

**Loopholes / ambiguity:**
- The spawns are constrained *only* by being inside the orchestrator-dispatched 9-step flow. There is **no explicit prohibition** against pr-manager spawning a fix agent for a problem it discovers *outside* that triage loop (e.g. PG-PR-MANAGER-OVERREACH's PR #553: pr-manager autonomously spawned an implementer + pushed `4b10e77`). Nothing in the prompt says "do NOT spawn a fix agent for findings the orchestrator did not route to you" or "escalate novel fixes to the orchestrator rather than self-dispatching."
- The "as needed" phrasing (`:185`) is permissive and bounds the decision to pr-manager's own judgment.
- Mitigating factor: the spawnable set is a *closed list* (`:72-79`) — pr-manager cannot spawn arbitrary agents. And the security/review fix spawns are genuinely part of the delegated lifecycle, so they are arguably *within* orchestrator direction (the orchestrator dispatched the whole 9-step flow). The gap is the absence of an explicit boundary statement distinguishing "fixes for findings surfaced by your own review steps" (allowed) from "fixes for problems you noticed off-script" (must escalate).

---

## Constraint 3 — Autonomous pushes

**VERDICT: PARTIAL (pushes are delegated + gated by a test-pass hook, but not prompt-gated on orchestrator authorization).**

pr-manager itself cannot push — it has no shell (`agents/pr-manager.md:431-432`: "Denied: `exec`, `process` … CANNOT execute shell commands") and must delegate all git/gh to github-ops, which "execute[s] exactly the command requested — no modifications" (`agents/github-ops.md:94`). Pushes in the flow come from the implementer/test-writer fix agents in the worktree.

The only hard push gate is a deterministic hook:

> `skills/code-delivery/SKILL.md:72-74`
> "**Gate:** The `code-delivery` plugin's `before_tool_call` hook verifies tests have passed before allowing `git push`. If tests haven't passed, the push is blocked with `{ skip: true, reason: \"Tests must pass before push\" }`."

Pushes use `--force-with-lease` for safety (`code-delivery/SKILL.md:69`).

**Loopholes / ambiguity:**
- The push gate is about **test-pass state, not orchestrator authorization.** A push that passes tests is allowed regardless of whether the orchestrator sanctioned *that specific* push. This is the exact PG-PR-MANAGER-OVERREACH gap (autonomous push of `4b10e77`): if pr-manager spawns a fix agent (Constraint 2 gap) and that fix passes tests, the push sails through. Constraints 2 and 3 are coupled — closing 2 largely closes 3.
- No prompt text in pr-manager.md, code-delivery, or fix-pr-delivery says "do not push commits the orchestrator has not authorized." The control is purely the test-pass hook + the no-shell tool fence.
- The no-shell fence is a *real* and strong structural control (pr-manager physically cannot push), but it is undermined the moment pr-manager is permitted to spawn a fix agent that DOES have shell (Constraint 2).

---

## Constraint 4 — Unbounded poll loops

**VERDICT: CODIFIED.**

Every wait/loop in the lifecycle has an explicit bound, and the engine names the anti-pattern directly:

> `agents/pr-manager.md:268` (Step 8a merge-queue wait)
> "Poll every ~30 seconds, up to 10 attempts (total ~5 minutes). If state is still not MERGED after 10 attempts, abort Step 8 and emit a clear BLOCKED note — **never hot-loop or wait indefinitely.**"

> `agents/pr-manager.md:165` "### Step 5: Review convergence loop (max 10 cycles)"
> `agents/pr-manager.md:189` "After 10 cycles with blocking findings: escalate to human."
> `agents/pr-manager.md:206` (Step 6 CI) "Max 3 CI fix cycles; escalate to human after 3 failures."
> `agents/pr-manager.md:410` "Max 10 review cycles. If pr-reviewer still has blocking findings after 10 cycles, escalate to human."

Branch-deletion verification is also bounded: "bounded retry (up to 3 re-checks)" (`:299-302`, `:334-340`) with an explicit deadlock-breaker so replication lag "must not wedge the completion gate" (`:339-340`).

`skills/code-delivery/SKILL.md:140-141` reinforces: "Maximum 30 minute wait, poll every 30 seconds … Maximum 3 CI fix cycles."

**Loopholes / ambiguity:** None material. Every identified wait is bounded with a numeric cap and an escalate-to-human or BLOCKED exit. This is the strongest-codified of the four constraints, and it is the one that directly maps to the PG-PR-MANAGER-OVERREACH "expensive poll loops" symptom.

---

## Reinforcing controls (cross-cutting)

- **Deterministic merge-prerequisites hook** (`hooks/validate-pr-merge-prerequisites.sh`, dispatched via the compiled `factory-dispatcher` registered in `hooks/hooks.json` PreToolUse): blocks (exit 2) any github-ops `gh pr merge` dispatch unless the evidence trail (`pr-description.md`, `pr-review.md`, `security-review.md`) exists in `.factory/code-delivery/STORY-NNN/`. This enforces *process completeness before merge* but does NOT enforce *authorization* — a fully-evidenced PR can still be self-authorized under Constraint 1's gap.
- **Tool fence:** pr-manager is `coding` profile with `exec`/`process` DENIED (`:429-432`) — it cannot run git/gh itself; all mutations route through github-ops. Strong structural backstop for Constraints 1 & 3, weakened only via spawned shell-capable fix agents.
- **Feature/Quick mode** (`skills/phase-f7-delta-convergence/SKILL.md:142-178`, `quick-dev-routing/SKILL.md:61-82`) DOES hard-require human merge authorization ("Phase F7 is COMPLETE only when the human explicitly authorizes the merge"). So the *human-gate* posture IS codified — but only on the Feature/Quick F7 path, NOT on the per-story greenfield delivery path, which auto-passes `AUTHORIZE_MERGE=yes`. The constraint is path-dependent.

---

## Behavioral Evidence (this session, 2026-06-28)

Recorded for completeness; explicitly NOT treated as proof of codification.

- **Constraint 1:** pr-manager held at merge on BOTH PR #566 and #567, refusing even an ORCHESTRATOR-RELAYED merge authorization and demanding the human's direct word. This is *stronger* than the prompt requires (`AUTHORIZE_MERGE=yes` would have permitted merge). Good behavior is therefore NOT attributable to the audited prompt text — it may reflect a stricter dispatch the orchestrator actually sent this session, session-level human instruction, or model conservatism. The prompt-as-written remains PARTIAL.
- **Constraints 2-4:** Across this session pr-manager ran clean delivery lifecycles with no autonomous fix-agent spawning, no autonomous pushes beyond authorized branch work, and no unbounded poll loops observed. Consistent with the codified bounds (Constraint 4) and with the tool fence (Constraint 3); does not independently prove the Constraint 2 boundary, since no off-script fix opportunity arose to test it.
- **Historical violations (the reason the story exists):** PR #544 — auto-merge against a hold (DEC-128, Constraint 1). PR #553 — autonomous implementer-spawn + push `4b10e77` + expensive poll loops (PG-PR-MANAGER-OVERREACH, Constraints 2/3/4). Constraint 4 (poll loops) has since been thoroughly codified; Constraints 1-3 have NOT been closed at the prompt level in a way that would prevent a recurrence of the #544/#553 shapes.

---

## Overall Verdict

**PARTIALLY-MITIGATED.**

- Constraint 4 (unbounded poll loops): **CODIFIED** — fully closed. The #553 poll-loop symptom would now be prevented by explicit numeric caps and the "never hot-loop or wait indefinitely" instruction.
- Constraints 1, 2, 3: **PARTIAL** — real controls exist (tool fence, test-pass push hook, merge-evidence hook, closed spawnable set, autonomy-level config, Feature-mode human gate), but none *prompt-codifies the DEC-128/OVERREACH intent* on the per-story greenfield path:
  - C1: the orchestrator's dispatch is treated as standing per-story merge authorization (`AUTHORIZE_MERGE=yes` baked into the template) — not a per-merge brake. This would re-permit the #544 auto-merge-against-hold shape.
  - C2: no explicit prohibition on spawning fix agents for off-script/self-discovered problems — only the closed spawnable list + in-flow framing constrain it. The #553 autonomous-implementer-spawn shape is not explicitly fenced.
  - C3: pushes are gated on test-pass + the no-shell fence, not on orchestrator authorization; coupled to the C2 gap.

The story should NOT be marked resolved-as-fully-mitigated on the strength of this session's good behavior. It can reasonably be marked **mitigated-with-residual-gaps** if the team accepts the existing structural controls (tool fence + hooks + Feature-mode gate) as sufficient defense-in-depth, OR kept open pending the prompt changes below.

---

## Recommendations to close residual gaps (engine-source prompt text)

These are concrete edits a future engine-source change could apply. (The plugin cache is read-only; do not edit it here.)

**Gap C1 — per-merge authorization brake.** In `agents/pr-manager.md` Step 8 / MERGE AUTHORIZATION block, replace the "dispatch IS the authorization" standing grant with a per-merge gate, e.g.:
> "Reaching all gates (security + review + CI + deps) means you are READY-FOR-MERGE — it does NOT authorize the merge. HALT and emit `READY_FOR_MERGE: PR #<N>`. Execute `gh pr merge` ONLY when the dispatch carries a fresh, story-specific `AUTHORIZE_MERGE=<PR#>` token issued for THIS merge. A standing or batch `AUTHORIZE_MERGE=yes` is NOT sufficient. If a hold/block is in effect for this PR or branch, do not merge even with a token — escalate."
And in `agents/orchestrator/per-story-delivery.md:36`, stop baking `AUTHORIZE_MERGE=yes` into the standing template; require the orchestrator to issue the per-PR token consciously after confirming no hold is active.

**Gap C2 — fix-agent spawn boundary.** Add to `agents/pr-manager.md` Constraints:
> "You may spawn fix agents (implementer/test-writer/demo-recorder) ONLY to remediate findings surfaced by YOUR OWN review/security/CI steps within this dispatched lifecycle. For any problem outside that scope — including refactors, scope creep, or issues you notice off-script — do NOT spawn a fix agent or push a fix; return to the orchestrator with a BLOCKED/NEEDS_CONTEXT note and let it decide."

**Gap C3 — push authorization.** Add to `agents/pr-manager.md` Constraints (and mirror in `skills/code-delivery/SKILL.md` Step 3):
> "No commit may be pushed to a PR branch except (a) the implementer's authorized story/fix work within this lifecycle, or (b) a fix you were explicitly routed to remediate. Passing tests is necessary but NOT sufficient authorization to push. Never push to remediate a problem the orchestrator did not route to you."

**Gap C1 (config hardening, optional).** State in `agents/pr-manager.md` that when `.factory/merge-config.yaml` is absent or unreadable, pr-manager MUST default to Level 3 (human review / halt), never to auto-merge — so a missing config fails safe.
