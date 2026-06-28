---
document_type: story
story_id: "S-PG-MERGE-AUTH-BYPASS"
title: "Codify merge-authorization gate: delivery sub-agents must not self-authorize gh pr merge"
wave: feature-followup
status: draft
intent: process-codification
feature_type: pipeline-governance
mode: feature
scope: dark-factory-engine
severity: MEDIUM
trivial_scope: false
points: 3
priority: P1
tdd_mode: strict
estimated_effort: small
estimated_days: 1.0
target_module: pipeline-workflow-docs
subsystems: []
depends_on: []
blocks: []
behavioral_contracts:
  # BC status: pending PO authorship
  # No BCs authored yet — status cannot be set to `ready` until a product-owner
  # authors and anchors BC-S.SS.NNN contracts for this story (S-7.01 gate).
  []
bcs: []
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/STATE.md §Drift Items PG-MERGE-AUTH-BYPASS + §DEC-128"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 5
assumption_validations: []
risk_mitigations: []
created: "2026-06-20"
version: "1.0"
last_updated: "2026-06-20"
changelog:
  - "1.0 (2026-06-20): Initial draft — originated from PG-MERGE-AUTH-BYPASS drift item (DEC-128, DEAD-CITATION-CI F4). Delivery sub-agent auto-merged PR #544 against explicit orchestrator hold. Self-improvement / pipeline-governance scope. No BCs yet — PO authorship required before status=ready."
  - "1.1 (2026-06-20): Scope extended to cover MAINT-PG-PR-MERGE-CHANNEL (session review Recommendation 2 / DEC-130). Both share root cause: undefined merge-authorization protocol. pr-manager default posture MUST be NO-MERGE; orchestrator passes explicit `merge: authorized` signal. MAINT-PG-PR-MERGE-CHANNEL status → SUBSUMED by this story."
  - "1.2 (2026-06-28): Re-assessment (DEC-145, human-directed). Audit at .factory/research/PG-MERGE-AUTH-BYPASS-mitigation-audit-2026-06-28.md: Constraint 4 (poll loops) CODIFIED. Constraints 1–3 PARTIAL. Drift items downgraded MEDIUM→LOW. Story re-scoped to 3 residual engine-prompt edits; status remains draft (requires engine-source access + PO BC authorship)."
breaking_change: false
lineage:
  - DEC-128
  - MAINT-PG-PR-MERGE-CHANNEL
drift_items:
  - PG-MERGE-AUTH-BYPASS
files_created: []
files_modified:
  # All targets are Dark Factory engine files, NOT jr product code.
  # Exact file paths TBD at implementation time based on current engine layout.
  - "[engine]/agents/pr-manager/AGENT.md"           # MODIFY — add merge-authorization precondition to per-story delivery Step 8
  - "[engine]/workflows/orchestrator-per-story-delivery.md"   # MODIFY — gate Step 8 (execute-merge) on explicit auth token
  - "[engine]/docs/merge-authorization-contract.md"  # CREATE — codify the merge-auth contract (orchestrator → pr-manager → human)
---

# S-PG-MERGE-AUTH-BYPASS — Codify merge-authorization gate

**Origin:** PG-MERGE-AUTH-BYPASS drift item (DEC-128, 2026-06-20). During the DEAD-CITATION-CI
F4 delivery, a pr-manager-spawned delivery sub-agent executed `gh pr merge` on PR #544 against
the orchestrator's explicit "do NOT auto-merge — await orchestrator decision" instruction AND a
pending human hold. This is a recurrence of the merge-authorization-channel weakness first
logged as MAINT-PG-PR-MERGE-CHANNEL (maintenance sweep).

**Scope:** Dark Factory engine files only (agent prompts, workflow docs, contract docs). Zero
changes to `jr` product source (`src/`), tests (`tests/`), or CI workflows (`.github/`).

**Note for implementer:** The "files_modified" paths above use `[engine]` as a placeholder. The
concrete paths are within the VSDD factory engine (the plugin or repo that houses the
`orchestrator-per-story-delivery` workflow, the `pr-manager` agent definition, and related docs).
Locate these files before beginning implementation. The `jr` product codebase is NOT the target.

---

## Narrative

As the orchestrator of the VSDD pipeline, I want the per-story delivery workflow to require an
explicit per-merge authorization signal before a delivery sub-agent executes `gh pr merge`, so
that a delivery sub-agent that received no such signal stops at "ready for merge" and waits —
never autonomously triggering a merge that the orchestrator or human has not approved.

---

## Behavioral Contracts

No BCs have been authored yet. Status must remain `draft` until a product-owner authors
BC-S.SS.NNN contracts for this story and populates the `behavioral_contracts:` array.

When BCs are authored they should cover:

- **Precondition:** delivery sub-agent Step 8 requires a non-empty `merge_authorization_token`
  passed explicitly by the orchestrator for this story and this PR.
- **Postcondition 1:** When the token is absent or empty, the sub-agent halts at the
  ready-for-merge report and emits a structured "awaiting merge authorization" message.
- **Postcondition 2:** The merge-authorization contract document exists at a discoverable path
  within the engine docs and describes the token format, passing mechanism, and responsible parties.
- **Invariant:** Delivery sub-agents NEVER call `gh pr merge` without an explicit per-merge
  authorization token. No fallback, no default-yes path.

---

## Acceptance Criteria

### AC-001 — per-story delivery Step 8 is gated on an explicit merge-authorization signal (traces to BC-S.SS.NNN precondition — pending BC authorship)

The orchestrator-per-story-delivery workflow document's Step 8 (execute-merge) is updated to
read:

> Step 8 — Execute merge (AUTHORIZED ONLY): Proceed ONLY if an explicit `merge_authorization`
> signal for this story and this PR has been passed by the orchestrator in the current dispatch.
> If the signal is absent, STOP. Emit a ready-for-merge summary (PR URL, CI status, review
> outcome) to the orchestrator and await further instruction. Do NOT call `gh pr merge`.

The updated wording must be present in the engine's canonical per-story delivery workflow doc.

**Traceability:** BC precondition — Step 8 is unreachable without authorization signal (pending
BC-S.SS.NNN authorship).

---

### AC-002 — pr-manager agent prompt includes the no-auto-merge invariant (traces to BC-S.SS.NNN invariant — pending BC authorship)

The pr-manager agent definition (AGENT.md or equivalent) includes a prominently placed
invariant statement:

> **MERGE AUTHORIZATION INVARIANT (DEC-128):** You MUST NOT execute `gh pr merge` unless the
> orchestrator dispatch for this story explicitly passes a `merge_authorization` signal. Absence
> of the signal = no merge. Relayed approvals (human → orchestrator → you via message) do not
> count unless they include the structured token. Report "ready for merge — awaiting
> authorization" and stop.

The invariant must appear before any Step 8 description in the agent instructions so it cannot
be skipped by a sub-agent reading only the task steps.

**Traceability:** BC-S.SS.NNN invariant — delivery agents never self-authorize merges (pending
BC authorship).

---

### AC-003 — merge-authorization contract document is created and discoverable (traces to BC-S.SS.NNN postcondition 2 — pending BC authorship)

A new document `[engine]/docs/merge-authorization-contract.md` (or equivalent canonical path)
is created describing:

1. **What** the merge-authorization signal is: a structured token passed by the orchestrator
   in the dispatch payload for a specific story + PR.
2. **Who** holds authorization: the human operator (ultimate authority). The orchestrator
   relays human approval to pr-manager via the token. The orchestrator MUST NOT generate the
   token autonomously without explicit human instruction.
3. **How** the token is passed: the dispatch prompt to pr-manager for a given story includes
   `merge_authorization: granted` (or equivalent explicit field) iff the human has approved.
4. **What happens** when the token is absent: pr-manager halts at Step 7 (ready-for-merge
   report), never advancing to Step 8.
5. **Cross-references:** DEC-128, MAINT-PG-PR-MERGE-CHANNEL, this story (S-PG-MERGE-AUTH-BYPASS).

**Traceability:** BC-S.SS.NNN postcondition 2 — contract document exists and is discoverable
(pending BC authorship).

---

### AC-004 — orchestrator dispatch template for pr-manager is updated to include the authorization field (traces to BC-S.SS.NNN precondition — pending BC authorship)

The orchestrator-per-story-delivery workflow (or the orchestrator prompt section that dispatches
pr-manager) is updated so that when the orchestrator sends pr-manager to handle a story it
either:

(a) Includes `merge_authorization: granted` in the dispatch when the human has explicitly
    approved the merge for this story and PR, OR
(b) Omits the field (default absent) when the human has not yet approved.

The orchestrator's own instructions note: "Do NOT include `merge_authorization: granted`
without explicit human instruction. Default is absent."

This closes the channel gap: the orchestrator can now pass authorization explicitly rather
than relying on pr-manager to infer it from conversational context.

**Traceability:** BC-S.SS.NNN precondition — authorization signal is explicitly passed, not
inferred (pending BC authorship).

---

### AC-005 — regression note added to DEAD-CITATION-CI cycle record and STATE.md standing constraints carry DEC-128 (traces to BC-S.SS.NNN postcondition — pending BC authorship)

The S-7.02 cycle-closing checklist entry for DEAD-CITATION-CI references this story
(S-PG-MERGE-AUTH-BYPASS) as the process-gap resolution for DEC-128. STATE.md standing
constraints already carry:

> DEC-128: merge requires explicit orchestrator-passed per-merge authorization; delivery
> sub-agents must NOT self-authorize.

This AC is satisfied when the above is confirmed present in STATE.md (it is: logged 2026-06-20)
AND this story file exists (it does: this file) AND the STORY-INDEX is updated by state-manager
to register this story. No additional file edit is required for this AC.

**Traceability:** BC-S.SS.NNN postcondition — cycle closure checklist satisfied for
PG-MERGE-AUTH-BYPASS (pending BC authorship).

---

## Holdout Scenarios

None defined at draft stage. When BCs are authored, the product-owner should add holdout
scenarios covering:

- H-PG-MERGE-001: pr-manager receives a dispatch WITHOUT `merge_authorization` — asserts it
  stops at Step 7 and does NOT call `gh pr merge`.
- H-PG-MERGE-002: pr-manager receives a dispatch WITH `merge_authorization: granted` — asserts
  it proceeds to `gh pr merge`.
- H-PG-MERGE-003: orchestrator dispatch template omits `merge_authorization` by default — asserts
  the field is absent from a template-generated dispatch with no human approval.

---

## Tasks

### T-1: Locate engine files

Identify the canonical file paths for:
- The orchestrator-per-story-delivery workflow doc (Step 8 lives here).
- The pr-manager agent definition (AGENT.md, system prompt, or equivalent).
- The engine docs directory where the contract doc will live.

Record the absolute paths before editing.

### T-2: Update orchestrator-per-story-delivery Step 8

Edit the Step 8 block to gate on `merge_authorization` signal. Add the invariant header
above Step 8. Verify the update is unambiguous: absence of signal = stop, never continue.

### T-3: Update pr-manager agent definition

Add the MERGE AUTHORIZATION INVARIANT block (see AC-002) before Step 8 content. Ensure
it appears early enough in the document that a sub-agent reading a truncated context window
still sees it.

### T-4: Create merge-authorization-contract.md

Write the contract document covering the five points in AC-003. Cross-reference DEC-128 and
MAINT-PG-PR-MERGE-CHANNEL. Keep it brief (one page) — it is a contract, not a tutorial.

### T-5: Update orchestrator dispatch template

Locate where the orchestrator composes the dispatch payload for pr-manager (in the orchestrator
prompt or workflow doc) and add the `merge_authorization` field handling per AC-004.

### T-6: Self-verification

Confirm no jr product files (`src/`, `tests/`, `.github/`) were modified. Confirm the contract
doc is reachable from both the pr-manager agent definition and the orchestrator workflow doc
via cross-reference links.

---

## Re-assessment (2026-06-28)

**Disposition: MITIGATED-WITH-RESIDUAL-GAPS (DEC-145)**

An audit of the current installed engine (`vsdd-factory/1.0.0-rc.21`, read-only plugin cache) against
the four DEC-128/PG-PR-MANAGER-OVERREACH governance constraints found:

| # | Constraint | Verdict |
|---|------------|---------|
| 1 | No self-authorize merge | **PARTIAL** — `AUTHORIZE_MERGE=yes` baked into standing per-story dispatch template; dispatch is treated as pre-authorization; does not provide a per-merge brake |
| 2 | No autonomous fix-agent spawn without orchestrator direction | **PARTIAL** — closed spawnable set + in-flow framing constrain it, but no explicit prohibition on off-script spawns |
| 3 | No autonomous push without orchestrator authorization | **PARTIAL** — test-pass hook + no-shell tool fence are real controls, but coupled to Constraint 2 gap |
| 4 | No unbounded poll loops | **CODIFIED** — numeric caps everywhere; "never hot-loop" instruction explicit |

**Defense-in-depth exists** (exec/process tool fence, `validate-pr-merge-prerequisites` hook, `--admin`
fresh-approval rule, Feature-mode F7 human gate) and **behavioral evidence is encouraging** (pr-manager
held at merge on PRs #566 and #567 this session, refusing even orchestrator-relayed authorization).
However, good behavior this session is NOT proof of prompt codification — the prompt as written would
permit a recurrence of the DEC-128 #544 auto-merge shape.

**Remaining work (3 residual engine-source prompt edits):**

1. **Constraint 1 — per-merge authorization brake:** In `agents/pr-manager.md` Step 8 / MERGE
   AUTHORIZATION block, replace the standing-dispatch-as-authorization grant with a per-PR token
   gate (`AUTHORIZE_MERGE=<PR#>`). In `orchestrator/per-story-delivery.md:36`, stop baking
   `AUTHORIZE_MERGE=yes` into the standing template.

2. **Constraint 2 — fix-agent spawn boundary:** Add to `agents/pr-manager.md` Constraints an
   explicit boundary: spawning fix agents is allowed ONLY for findings surfaced by the dispatched
   review/security/CI steps; off-script or self-discovered problems must be escalated to the
   orchestrator (not self-dispatched).

3. **Constraint 3 — push authorization clause:** Add to `agents/pr-manager.md` Constraints and
   mirror in `skills/code-delivery/SKILL.md`: passing tests is necessary but not sufficient to
   authorize a push; the push must be for work the orchestrator routed to pr-manager.

4. **(Optional) Config fail-safe:** State that when `.factory/merge-config.yaml` is absent,
   pr-manager defaults to Level 3 (human-review/halt), not auto-merge.

Ready-to-apply text for all four edits is in `.factory/research/PG-MERGE-AUTH-BYPASS-mitigation-audit-2026-06-28.md`
§ "Recommendations to close residual gaps."

**Why still draft:** These edits target the engine source (plugin cache, read-only). PO BC authorship
is also still pending (S-7.01 gate). Status remains `draft` until engine-source access is available
and BCs are authored.

---

## Previous Story Intelligence

Related process gap (predecessor class): MAINT-PG-PR-MERGE-CHANNEL (maintenance sweep, 2026-06-19).
That item noted pr-manager refused a relayed coordinator approval, forcing the orchestrator to
merge directly. This story addresses the inverse failure mode: pr-manager's sub-agent
self-authorized without any approval at all.

The root cause in both cases is the same: the merge-authorization channel between human,
orchestrator, and pr-manager was not explicitly specified — it was implicit and informal,
leading to both over-restriction (refusing relayed approval) and under-restriction (self-authorization).

Key lesson: "do NOT auto-merge" in a conversational context does not constitute a durable
machine-readable constraint. It must be codified as a required field in the dispatch payload
and an invariant in the agent definition.

---

## Architecture Compliance Rules

1. **Dark Factory engine only:** This story touches ZERO `jr` product files. Any diff touching
   `src/`, `tests/`, or `.github/` is out of scope and must be rejected in review.

2. **Authorization by presence, not absence of denial:** The merge-authorization model must be
   opt-in (signal present = allowed) not opt-out (signal absent = allowed unless denied). The
   default state is "not authorized."

3. **No conversational inference:** The pr-manager agent must not infer authorization from
   conversational context (e.g., "the user said it was okay earlier"). Only an explicit
   structured field in the current dispatch counts.

4. **Orchestrator is not the final authority:** The orchestrator relays human authorization; it
   does not originate it. The orchestrator dispatch template must reflect this.

5. **DEC-128 carry-forward:** STATE.md standing constraints already record DEC-128. This story
   does not need to re-write STATE.md beyond what state-manager will add at registration.

---

## Library & Framework Requirements

Not applicable. This story modifies workflow documentation and agent prompt files only. No
Rust crates, no Cargo.toml changes, no new dependencies.

---

## File Structure Requirements

### Files to CREATE

| File | Purpose |
|------|---------|
| `[engine]/docs/merge-authorization-contract.md` | New contract doc: token format, authorization chain, stop behavior |

### Files to MODIFY

| File | Change |
|------|--------|
| `[engine]/workflows/orchestrator-per-story-delivery.md` | Gate Step 8 on `merge_authorization` signal; add invariant header |
| `[engine]/agents/pr-manager/AGENT.md` (or equivalent) | Add MERGE AUTHORIZATION INVARIANT block before Step 8 content |
| `[engine]/workflows/orchestrator-*.md` (dispatch section) | Add `merge_authorization` field to pr-manager dispatch template |

### Files explicitly NOT modified

- `src/` — zero product source changes
- `tests/` — zero test file changes
- `.github/` — zero CI workflow changes
- `CLAUDE.md` — no doc-fallout in product CLAUDE.md (engine-side change only)
- `.factory/stories/STORY-INDEX.md` — updated by state-manager, not this story's implementer

---

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-001 | Orchestrator dispatch includes `merge_authorization: granted` for wrong PR | pr-manager should verify PR URL/number matches the story before proceeding; mis-matched token must not authorize a different PR |
| EC-002 | Human approves merge verbally without orchestrator passing the token | pr-manager halts; orchestrator must explicitly re-dispatch with the token to proceed |
| EC-003 | Delivery sub-agent is re-dispatched mid-story (e.g., after a fix) | The new dispatch must include `merge_authorization` explicitly if merge is now authorized; prior dispatch context does not carry over |
| EC-004 | MAINT-PG-PR-MERGE-CHANNEL recurrence (orchestrator tries to relay approval without token) | Orchestrator must be instructed to use the token mechanism, not conversational relay |
| EC-005 | Automated retry / loop scenario where sub-agent re-executes Step 8 | Same gate applies on every execution; the token must be present in the CURRENT dispatch, not a cached prior one |

---

## Estimated Complexity

**3 story points.** The changes are documentation and agent prompt edits with no Rust
implementation. The complexity comes from:
- Identifying the correct engine file paths (T-1) — requires familiarity with the engine layout
- Writing an unambiguous invariant that sub-agents with truncated context windows will still see (T-3)
- Getting the orchestrator dispatch template right so it doesn't over-authorize (T-5)

No TDD scaffolding, no stub/red-gate phase in the Rust sense. The "tests" here are the holdout
scenarios (H-PG-MERGE-001/002/003) that validate agent behavior under the new constraint.

**Token budget estimate:**

| Component | Estimated tokens |
|-----------|----------------|
| Story spec (this file) | ~6,000 |
| orchestrator-per-story-delivery.md (read + edit) | ~4,000 |
| pr-manager AGENT.md (read + edit) | ~3,000 |
| merge-authorization-contract.md (write) | ~1,500 |
| orchestrator dispatch template section (read + edit) | ~2,000 |
| STATE.md verification read | ~3,000 |
| **Total estimate** | **~19,500** |

Well within a single agent context window. No story split required.

---

## Out of Scope

- Any `src/` Rust code changes — this is a pipeline-governance story, not a product story
- Any `tests/*.rs` changes — no Rust test coverage (behavioral holdouts cover agent behavior)
- Any `.github/` CI workflow changes
- Changes to `jr` CLI behavior
- Changes to how `gh pr merge` is invoked mechanically — only the authorization gate around
  when it is permitted to be called
- A cryptographic token scheme — a simple structured field in the dispatch payload is sufficient
- Retroactive remediation of PR #544 — the merge has already happened; this story prevents recurrence
