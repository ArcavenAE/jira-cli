---
document_type: story
level: ops
story_id: "S-cycle8-teams-graphql-oauth-replatform-spike"
epic_id: "OAUTH-SURFACE-CORRECTNESS-1"
title: "SPIKE: Teams GraphQL OAuth re-platform investigation (teamSearchV2, get_org_metadata scope, api-token host preservation) -- report + go/no-go, NO code delivery"
wave: "non-gating"
status: draft
intent: research
feature_type: spike
mode: feature
scope: standard
severity: LOW
trivial_scope: false
producer: story-writer
timestamp: "2026-09-17T00:00:00"
phase: 3
inputs:
  - ".factory/cycles/cycle-008/F1-delta-analysis.md"
  - ".factory/cycles/cycle-008/F2-architecture-delta.md"
  - ".factory/specs/architecture/decisions/ADR-0026-oauth-3lo-gateway-routing-invariant-and-granular-jira-software-scopes.md"
  - ".factory/cycles/cycle-008/oauth-endpoint-inventory.md"
  - ".factory/cycles/cycle-008/oauth-scope-matrix.md"
  - "src/api/jira/teams.rs"
input-hash: "4f56048"
traces_to: "ADR-0026 Decision 4 (Deferred/Context, Workstream D open questions)"
cycle: cycle-008-oauth-surface-correctness
estimated_effort: spike
estimated_days: 2
target_module: "src/api/jira/teams.rs (investigation only, no edits)"
subsystems: ["SS-04"]
# SS-04 (Jira API Resources, src/api/jira/) is the subsystem
# src/api/jira/teams.rs lives in -- named here as the investigation TARGET,
# not as a subsystem this story modifies. This spike makes zero src/ edits;
# SS-04 is listed to correctly scope which subsystem a future S7
# implementation story (conditional on this spike's findings) would touch.
depends_on: []
blocks: []
# Independent of every other cycle-008 story -- Workstream D (Teams) was
# explicitly scoped OUT of this cycle's delivery set at the F1 gate (DEC-368:
# "DELIVER Workstreams A/B/C/E... Workstream D = SPIKE ONLY this cycle").
# This spike does not gate S1-S5's delivery, and S1-S5 do not gate this
# spike -- it may run in parallel with the whole Wave 1/Wave 2 delivery
# track, as the dispatch prompt's "non-gating parallel track" instruction
# specifies.
behavioral_contracts: []
# BC status: N/A by design -- this is a research/investigation story with NO
# code delivery. Per ADR-0026 Decision 4 and F2-architecture-delta.md §S6:
# "No BC/VP delta for S6 in this pass." No BC governs an investigation
# artifact; a future S7 (conditional, implementation) story would author or
# anchor BCs once this spike's findings are known.
bcs: []
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0026"]
sd_refs: []
priority: P3
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-008/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: research
tdd_mode: facade
module_criticality: LOW
points: 3
acceptance_criteria_count: 6
assumption_validations: []
risk_mitigations: []
created: "2026-09-17"
version: "1.0"
last_updated: "2026-09-17"
breaking_change: false
retroactive: false
origin: >
  cycle-008 oauth-surface-correctness, non-gating parallel track, no deps, no
  blocks. F1 delta-analysis (.factory/cycles/cycle-008/F1-delta-analysis.md
  §2.4, §6a) rated Workstream D (Teams) HIGH regression risk versus
  LOW-MEDIUM for Workstreams A/B/C/E: new host
  (https://api.atlassian.com/graphql, not a base_url/instance_url swap), new
  query shape (teamSearchV2, unconfirmed pagination-model parity with the
  existing TeamsResponse), UNCERTAIN scope-string addability
  (view:team:teams / view:membership:teams) pending live Developer Console
  verification, and a live open question (get_org_metadata / jr init
  exposure) the F1 pass itself surfaced and could not resolve from static
  code + docs research alone. Human-approved at the F1 gate (DEC-368):
  Workstream D is SPIKE ONLY this cycle -- this story is that spike. ADR-0026
  Decision 4 records, without deciding, the exact open questions this spike
  must resolve.
---

> **tdd_mode:** `facade` — this field is set for frontmatter-schema
> completeness only. This story is a SPIKE: investigation and reporting, not
> code delivery. There is no Red Gate, no `todo!()` scaffold, and no merge to
> `develop` of any `src/` change. The Task list below produces a spike
> report and a go/no-go recommendation as its sole deliverable — see the
> explicit "NOT delivered by this story" list under Acceptance Criteria.

> **Execute:** `/vsdd-factory:deliver-story S-cycle8-teams-graphql-oauth-replatform-spike`
> — note: the delivery workflow for a spike story stops at the investigation
> report; it does NOT proceed through implementer/stub-architect/Red-Gate
> steps. If the delivery tooling attempts to dispatch an implementer against
> this story, that is a process error — escalate rather than proceeding.

# S-cycle8-teams-graphql-oauth-replatform-spike — Teams GraphQL OAuth re-platform investigation

## Narrative

- **As a** `jr` maintainer deciding whether to fix `jr team list`'s OAuth breakage in a future
  cycle
- **I want to** a grounded investigation resolving the exact host/query/scope shape a Teams
  OAuth re-platform would require, whether `jr init`'s `get_org_metadata` is also affected, and
  whether API-token users' currently-working Teams commands would regress
- **So that** a future `S7` implementation story (if approved) starts from confirmed facts
  instead of the three UNCERTAIN items this cycle's static-analysis passes could not resolve

## Behavioral Contracts

**No BC-S.SS.NNN anchors this story** (see frontmatter `bcs: []` and the `# BC status` comment
above). Per ADR-0026 Decision 4 and F2-architecture-delta.md §S6: "No BC/VP delta for S6 in this
pass." This story's acceptance criteria trace to ADR-0026 Decision 4's own enumerated open
questions, not to a behavioral contract — there is nothing for a BC to govern until a future S7
implementation story exists.

## Acceptance Criteria

### AC-001 (traces to ADR-0026 Decision 4, open question 1 — GraphQL host + query-shape verification)
Live-verify (via the Atlassian GraphQL Explorer or an equivalent authenticated live check, NOT
training-data recall) whether `jr`'s Teams listing should move to `POST
https://api.atlassian.com/graphql` with a `teamSearchV2` query for OAuth profiles, and determine
whether `teamSearchV2`'s response/pagination shape is compatible with (or requires translation
from) the existing `TeamsResponse` type `jr` already deserializes into.
**Deliverable:** a dated finding in the spike report stating the confirmed (not assumed) query
shape, response shape, and pagination model, with a citation to the live check performed or the
authoritative Atlassian documentation consulted.

### AC-002 (traces to ADR-0026 Decision 4, open question 2 — scope addability, UNCERTAIN per research)
Live-verify in the Atlassian Developer Console whether `view:team:teams` and (if member data will
be rendered) `view:membership:teams` are addable scopes for a Jira Cloud 3LO OAuth app (the kind
`jr`'s embedded app is) — this was flagged UNCERTAIN by the cycle-008 research pass and is NOT
resolved by static documentation review alone.
**Deliverable:** a dated finding stating CONFIRMED-ADDABLE or CONFIRMED-NOT-ADDABLE (with the
Console screenshot/state description or an authoritative citation), or, if genuinely unresolvable
without an app-owner action this spike cannot perform, an explicit STILL-UNCERTAIN finding naming
exactly what human/app-owner action would resolve it.

### AC-003 (traces to ADR-0026 Decision 4, open question 3 — `get_org_metadata`/`jr init` exposure)
Determine, by reading `src/api/jira/teams.rs::get_org_metadata` and tracing its callers, whether
this function (used by `jr init`'s org/cloud-ID resolution — confirmed by F1 code audit to be a
DIFFERENT function from `list_teams`, not two calls in one function as the original feature
request's line attribution implied) is also affected by the OAuth host/routing gap, or whether it
is a legitimately different, already-correct use of the site-local `/gateway/api/graphql`
endpoint that must NOT be touched by a future Workstream D implementation.
**Deliverable:** a dated finding stating whether `get_org_metadata` is IN-SCOPE or OUT-OF-SCOPE
for a future Teams re-platform, with the code-read evidence (call graph, query shape comparison
against `list_teams`) supporting the conclusion. Getting this wrong risks breaking `jr init` under
OAuth — a materially worse regression than the status-quo-broken `jr team list` — so this finding
must be evidence-based, not inferred from the function names alone.

### AC-004 (traces to ADR-0026 Decision 4, open question — API-token host preservation)
Determine whether `api.atlassian.com/graphql` (the OAuth-required host, per AC-001) also works
correctly for Basic/API-token auth, or whether the site-local `/gateway/api/graphql` +
`/gateway/api/public/teams/...` MUST be retained for API-token profiles while ONLY OAuth profiles
switch hosts — i.e. whether a future implementation needs an `is_oauth_auth()`-gated host fork
(the existing predicate already used for JSM error-hint dispatch) rather than a blanket host swap.
**Deliverable:** a dated finding stating CONFIRMED-FORK-REQUIRED or
CONFIRMED-UNIFIED-HOST-SAFE-FOR-BOTH, with supporting evidence. A blanket host swap that breaks
currently-working API-token Teams commands would be a strictly worse outcome than today's
OAuth-only breakage — this finding is a hard prerequisite for any future S7 design.

### AC-005 (traces to CLAUDE.md Gotchas "Citation discipline" — no fabricated findings)
Every finding in this spike's report is either (a) grounded in a live check performed during this
spike (Developer Console state, GraphQL Explorer query result), (b) grounded in a direct code read
of `src/api/jira/teams.rs` and its callers, or (c) explicitly marked STILL-UNCERTAIN with the
specific human/app-owner action that would resolve it. No finding is presented as CONFIRMED based
on training-data recall of Atlassian's GraphQL API shape alone — this mirrors the rigor already
applied by `oauth-scope-matrix.md`'s CONFIRMED/UNCERTAIN confidence-tagging convention.
**Deliverable:** the spike report itself, reviewed for citation discipline before hand-off.

### AC-006 (traces to F1 §6a — go/no-go recommendation, the story's terminal output)
The spike report concludes with an explicit go/no-go recommendation for a future `S7
teams-graphql-oauth-replatform` implementation story: PROCEED (with the confirmed host/query/scope
shape and fork strategy from AC-001–AC-004), DEFER (naming what remains blocking), or REJECT (if a
finding makes the re-platform infeasible or not worth the risk). This recommendation is handed to
the orchestrator/human for the next cycle's F1 gate decision — this story does NOT itself decide to
proceed with implementation.
**Deliverable:** the spike report's closing section; no code is written, no PR is opened, no
`develop` merge occurs as part of this story.

## What this story explicitly does NOT deliver

- **No `src/api/jira/teams.rs` code changes** — this is investigation-only.
- **No new BC, VP, or ADR amendment** — a future S7 story (if approved) would author these once
  findings are confirmed; this spike's findings feed that future authorship, they do not pre-empt
  it.
- **No Red Gate, no `todo!()` scaffold, no stub-architect dispatch, no test-writer dispatch against
  production code** — there is no implementation to scaffold or test in a spike.
- **No `DEFAULT_OAUTH_SCOPES` edit** — Teams scopes remain explicitly excluded from that constant
  (enforced by `S-cycle8-agile-oauth-scope-gap`'s own negative-assertion AC) until a future S7 is
  separately approved.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `list_teams` (read-only investigation target) | `src/api/jira/teams.rs` | Effectful (HTTP GET; UNCHANGED by this spike) |
| `get_org_metadata` (read-only investigation target) | `src/api/jira/teams.rs` | Effectful (HTTP POST GraphQL; UNCHANGED by this spike) |
| Spike report (the deliverable) | `.factory/cycles/cycle-008/teams-graphql-spike-report.md` (or equivalent path per state-manager convention) | N/A (documentation artifact) |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-1 | Live GraphQL Explorer / Developer Console access is unavailable during this spike's execution window | Findings for the blocked AC(s) are marked STILL-UNCERTAIN (AC-005) rather than fabricated; the go/no-go recommendation (AC-006) defaults to DEFER, naming the blocked verification as the reason |
| EC-2 | `get_org_metadata` (AC-003) turns out to be IN-SCOPE for the re-platform | The go/no-go recommendation (AC-006) must flag the increased blast radius (breaking `jr init` is a materially worse regression than `jr team list`) as a factor weighing toward DEFER or a more cautious PROCEED (e.g. `jr init`-specific regression tests required before any S7 implementation) |
| EC-3 | The Developer Console confirms `view:team:teams` is NOT addable to a Jira Cloud 3LO app (AC-002 resolves CONFIRMED-NOT-ADDABLE) | The go/no-go recommendation is REJECT or DEFER-INDEFINITELY, since no implementation can proceed without this scope regardless of how the routing/host questions resolve |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `src/api/jira/teams.rs` (`list_teams`, `get_org_metadata` — read-only investigation target) | effectful-shell | HTTP GET/POST GraphQL calls; UNCHANGED by this spike |
| Spike report (the deliverable) | N/A (documentation artifact) | Not source code |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~2,600 |
| Referenced code (`src/api/jira/teams.rs` full file, `list_teams`/`get_org_metadata` callers) | ~2,500 |
| Research tool outputs (Perplexity/WebFetch/Developer-Console-check transcripts) | ~6,000 |
| Spike report drafting overhead | ~2,000 |
| **Total** | **~13,100** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~7%** |

## Tasks

1. [ ] Read `src/api/jira/teams.rs` in full; confirm the call graph for `list_teams` vs.
   `get_org_metadata` (they are separate functions — do not conflate them, per F1's own
   line-attribution correction) — `research-agent`
2. [ ] Perform live verification of `teamSearchV2`'s query/response/pagination shape (AC-001) —
   `research-agent`
3. [ ] Perform live Developer Console verification of `view:team:teams`/`view:membership:teams`
   addability (AC-002) — `research-agent`
4. [ ] Determine `get_org_metadata`'s in-scope/out-of-scope status via code-read evidence (AC-003)
   — `research-agent`
5. [ ] Determine whether `api.atlassian.com/graphql` is safe for API-token auth or whether an
   `is_oauth_auth()` host fork is required (AC-004) — `research-agent`
6. [ ] Draft the spike report with citation discipline (AC-005) — `research-agent`
7. [ ] Write the closing go/no-go recommendation (AC-006) — `research-agent`
8. [ ] Hand the spike report to the orchestrator for the next cycle's F1 gate decision — no PR,
   no `develop` merge, no `src/` diff

## Previous Story Intelligence

N/A — first and only Teams-workstream story in cycle-008; no prior spike exists to draw
intelligence from. A future `S7 teams-graphql-oauth-replatform` (conditional on this spike's
findings) will treat THIS story's report as its own "Previous Story Intelligence" input.

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| No `src/` code change may be made under this story, regardless of how confident a finding is | ADR-0026 Decision 4; F1 §6a (DEC-368: Workstream D = SPIKE ONLY this cycle) | Task 8's explicit "no PR, no develop merge, no src/ diff" close-out |
| No finding may be presented as CONFIRMED without a live check or direct code-read citation | CLAUDE.md "Citation discipline for external-tracker IDs" (generalized to API-shape claims); `oauth-scope-matrix.md`'s own CONFIRMED/UNCERTAIN precedent | AC-005 |
| `list_teams` and `get_org_metadata` are separate functions with potentially different in-scope status — do not conflate them as the original feature request's line attribution did | F1 §2.4 (line-attribution correction) | AC-003's explicit call-graph-based finding |
| Teams scopes remain excluded from `DEFAULT_OAUTH_SCOPES` regardless of this spike's findings, until a future S7 is separately approved | ADR-0026 Decision 2 | This story makes no edit to `src/api/auth.rs`; the sibling `S-cycle8-agile-oauth-scope-gap` story's negative assertions are the enforcement mechanism, not this story |

## Library & Framework Requirements

No new dependency is added or evaluated for addition by this story. Any library implications of a
future GraphQL client shape change are deferred to a future S7 implementation story's own Library &
Framework Requirements section.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/api/jira/teams.rs` | none — read-only investigation target | Confirmed unchanged; this spike delivers no code |
| Spike report (new file, path per state-manager's artifact-path convention, e.g. under `.factory/cycles/cycle-008/`) | create | The sole deliverable of this story (AC-001 through AC-006) |
