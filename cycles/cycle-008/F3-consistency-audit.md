---
document_type: consistency-report
level: ops
phase: phase-f3-incremental-stories
cycle: cycle-008
feature: oauth-surface-correctness
producer: consistency-validator
version: "1.0"
timestamp: "2026-09-17T00:00:00"
traces_to: ".factory/cycles/cycle-008/phase-f3-stories/wave-schedule.md"
inputs:
  - ".factory/cycles/cycle-008/phase-f3-stories/S-cycle8-jsm-servicedeskapi-oauth-routing.md"
  - ".factory/cycles/cycle-008/phase-f3-stories/S-cycle8-agile-oauth-scope-gap.md"
  - ".factory/cycles/cycle-008/phase-f3-stories/S-cycle8-assets-workspace-oauth-routing.md"
  - ".factory/cycles/cycle-008/phase-f3-stories/S-cycle8-agile-scope-mismatch-error-mapping.md"
  - ".factory/cycles/cycle-008/phase-f3-stories/S-cycle8-jsm-attachments-oauth-verification.md"
  - ".factory/cycles/cycle-008/phase-f3-stories/S-cycle8-teams-graphql-oauth-replatform-spike.md"
  - ".factory/cycles/cycle-008/phase-f3-stories/dependency-graph-extended.md"
  - ".factory/cycles/cycle-008/phase-f3-stories/wave-schedule.md"
  - ".factory/stories/STORY-INDEX.md"
  - ".factory/cycles/cycle-008/F1-delta-analysis.md"
  - ".factory/cycles/cycle-008/F2-architecture-delta.md"
  - ".factory/cycles/cycle-008/oauth-endpoint-inventory.md"
  - ".factory/cycles/cycle-008/oauth-scope-matrix.md"
  - ".factory/specs/architecture/decisions/ADR-0026-oauth-3lo-gateway-routing-invariant-and-granular-jira-software-scopes.md"
  - ".factory/specs/prd/bc-4-assets-cmdb.md"
  - ".factory/specs/prd/bc-1-auth-identity.md"
  - ".factory/specs/prd/cross-cutting.md"
  - ".factory/specs/prd/bc-5-boards-sprints.md"
  - ".factory/specs/prd/bc-8-components.md"
  - ".factory/specs/architecture/ARCH-INDEX.md"
input-hash: "22a9cde"
---

# Cycle-008 Phase F3 Consistency Audit — Pre-Human-Gate

**Scope:** Fresh-context cross-document validation of the 6 new `S-cycle8-*` story files, the
extended dependency graph, the wave schedule, and their STORY-INDEX integration, against
cycle-008's upstream ground truth (F1 delta analysis, F2 architecture delta, the OAuth endpoint
inventory and scope matrix, ADR-0026, and BC-4.2.001 / BC-1.3.023 / BC-X.15.001).

**Verdict: CONSISTENT** — no CRITICAL or blocking findings. The F3 human gate may proceed. Two
non-blocking findings are noted below (both pre-existing upstream drift, not defects introduced
by this F3 story-decomposition pass).

---

## 1. AC → BC → VP Traceability — PASS

| Story | Cited BC | Cited VP | BC exists? | VP exists (registered)? | AC↔BC clause match verified? |
|---|---|---|---|---|---|
| S1 `jsm-servicedeskapi-oauth-routing` | BC-4.2.001 | VP-OAUTH-GW-001 | Yes — `bc-4-assets-cmdb.md:108` (AMENDED, unified 7-row fix table) | Yes — `verification-delta.md` §VP-OAUTH-GW-001 | Yes — AC-001..006 each map 1:1 to fix-table rows 1–6; row text/symbols byte-match ADR-0026 Decision 1's table |
| S2 `agile-oauth-scope-gap` | BC-1.3.023 | VP-OAUTH-GW-002 | Yes — `bc-1-auth-identity.md:820` (AMENDED a second time) | Yes — `verification-delta.md` §VP-OAUTH-GW-002 | Yes — AC-001's 16-scope literal is a byte-for-byte match of BC-1.3.023's pinned Behavior-section string |
| S3 `assets-workspace-oauth-routing` | BC-4.2.001 | VP-OAUTH-GW-001 | Yes (same BC, row 7 / native subject area) | Yes | Yes — AC-001 maps to fix-table row 7 |
| S4 `agile-scope-mismatch-error-mapping` | BC-X.15.001 (new) | VP-OAUTH-GW-003 | Yes — `cross-cutting.md:3004` (NEW, §X.15) | Yes — `verification-delta.md` §VP-OAUTH-GW-003 | Yes — AC-001's per-command scope-hint table is a byte-for-byte match of BC-X.15.001's Behavior clause 1 list; AC-002/004/005/006 map to clauses 2–4 and EC-X.15.001-1/2/3 |
| S5 `jsm-attachments-oauth-verification` | BC-4.2.001 (transitive, no amendment) | none (documented as covered transitively by VP-OAUTH-GW-001) | Yes | N/A by design — matches `F2-architecture-delta.md` §S5 ("No new VP") and `verification-delta.md`'s explicit statement | Yes — correctly cited as transitive, not a new fix-table row |
| S6 `teams-graphql-oauth-replatform-spike` | none (`bcs: []`) | none | N/A by design | N/A by design | Correctly matches ADR-0026 Decision 4 / `F2-architecture-delta.md` §S6 ("No BC/VP delta for S6") |

No dangling BC/VP reference, no AC without a BC anchor, no fabricated ID. `verification-delta.md`
explicitly documents (and this repo confirms by absence of any `VP-INDEX.md`) that VPs are
inline-registered labels, not a separate corpus — all three `VP-OAUTH-GW-00{1,2,3}` IDs cited by
the stories are defined there and cross-referenced correctly into their target BCs.

One structural nuance, not a defect: `verification-delta.md`'s own VP-OAUTH-GW-001 write-up
(pre-F2-gate) proposed the 6 JSM call sites register into "a new or amended BC under
`cross-cutting.md`" as a still-open BC-home decision. The product-owner's actual F2 BC delta
resolved this by anchoring all 7 rows in BC-4.2.001 instead (confirmed in `bc-4-assets-cmdb.md`'s
own frontmatter `trace:` and body, which explicitly reasons through this choice: "anchored here...
rather than duplicated across `bc-X.8`/`bc-X.12`"). S1's story correctly reflects the *actual*
finalized anchor (BC-4.2.001), not the stale pre-decision proposal — this is the BC delta pass
overriding its own earlier draft note, not a story-writer error.

---

## 2. Scope Fidelity — PASS

Cross-checked the F1-approved delivery scope (D-368: "DELIVER Workstreams A/B/C/E... Workstream
D = SPIKE ONLY") and ADR-0026's unified fix table / 16-scope set against the 6 stories:

- **All 6 JSM `servicedeskapi` routing call sites** (`list_service_desks`, `list_request_types`,
  `get_request_type_fields`, `list_queues`, `get_queue_issue_keys`, `create_jsm_request`) are
  covered by S1 AC-001..006 — exact file::symbol match against ADR-0026 Decision 1's table and F1
  §2.1.
- **The 1 Assets workspace-discovery call site** (`get_or_fetch_workspace_id`) is covered by S3
  AC-001 — matches ADR-0026 Decision 1 fix-table row 7 / F1 §2.3.
- **The 16-scope set**, including `manage:jira-project` and the 7 granular Agile scopes, is
  covered by S2 AC-001, with the Teams-exclusion negative assertions in AC-002/AC-004. The exact
  16-scope literal in S2 matches BC-1.3.023's pinned Behavior-section string byte-for-byte (see
  Finding F-1 below re: an ADR-0026-vs-BC-1.3.023 *ordering* discrepancy that does not affect S2's
  own correctness, since S2 correctly cites the BC, not the ADR's illustrative code block).
- **The component-write `manage:jira-project` gap** (endpoints #41/#42/#44, `jr component
  create/edit/delete/rename`) is closed by S2's scope addition alone — confirmed correct per
  ADR-0026 Decision 2a ("these three endpoints already route correctly... require no routing
  change... fixing them is scope-addition-only"). No separate component-routing story exists, and
  none is needed — `bc-8-components.md` (BC-8.1.005/007, BC-8.2.001, BC-8.3.001) already carries
  cross-reference notes to this effect, confirmed present in the file.
- **The error-mapping fix** (`jr board`/`jr sprint` 401 disambiguation) is covered by S4,
  correctly scoped to ONLY the 3-way classification (scope-mismatch / expired-token /
  wrong-host-regression-guard) and correctly leaving `src/error.rs`'s shared
  `InsufficientScope` template and `jsm_create.rs`'s BC-3.8.015 rewrite untouched (AC-007).
- **The JSM attachment verification** is covered by S5 as a test-only, zero-`src/`-change story —
  matches F1 §1 item 1 / F2-architecture-delta.md §S5 exactly (no new production code, no new BC).
- **The Teams spike is spike-only, no code delivery** — S6's frontmatter (`bcs: []`,
  `implementation_strategy: research`) and its explicit "What this story explicitly does NOT
  deliver" section (no `src/` edit, no new BC/VP/ADR amendment, no `DEFAULT_OAUTH_SCOPES` edit)
  correctly enforce D-368's "SPIKE ONLY this cycle" constraint. **Confirmed: no Teams
  re-platform CODE story exists in this batch** — the scope-fidelity "nothing more" check passes.
- **Nothing extra**: no story touches any file in F1 §8 / F2-architecture-delta.md's "Files
  confirmed NOT touched" regression baseline (`src/api/jira/issues.rs`, `users.rs`, `sprints.rs`
  itself, `src/api/assets/objects.rs`/`linked.rs`/`schemas.rs`/`tickets.rs`,
  `src/api/jsm/attachments.rs`, `src/error.rs`, `src/cli/auth/login.rs`, `src/cli/issue/`, etc.) —
  confirmed by grepping each story's File Structure Requirements table.

**Verdict: scope fidelity PASS — exactly the F2-approved scope, nothing more, nothing less.**

---

## 3. File-Overlap / Wave / Dependency Correctness — PASS

- **Wave-1 file disjointness confirmed:** S1 touches only `src/api/jsm/*.rs` (+ 3 `docs/adr/`
  files + CHANGELOG.md); S2 touches only `src/api/auth.rs` + `src/cli/auth/tests/mod.rs` (+
  CHANGELOG.md); S3 touches only `src/api/assets/workspace.rs` (+ CHANGELOG.md); S4 touches only
  `src/cli/board.rs` + `src/cli/sprint.rs` (+ CHANGELOG.md). Independently re-derived from each
  story's own File Structure Requirements table — matches `dependency-graph-extended.md` §5 and
  `wave-schedule.md` §2 exactly. `CHANGELOG.md` is the only shared file across all four, correctly
  classified as append-only/low-risk with no dependency edge required (consistent with prior-cycle
  precedent cited in both documents).
- **Acyclic graph confirmed:** independently re-ran Kahn's algorithm over the stated
  `depends_on:` edges (`S1:[]`, `S2:[]`, `S3:[]`, `S4:[]`, `S5:[S1]`, `S6:[]`) — round 1 emits
  {S1,S2,S3,S4,S6}, round 2 emits {S5}, queue empties with all 6 nodes emitted. **ACYCLIC**,
  matching the dependency graph's own §3 result.
- **S1→S5 is correctly the sole hard edge:** S5's own AC-001 test literally cannot pass without
  S1's real `list_service_desks` fix landed (the attachment flow's `serviceDeskId` resolution
  chain — `resolve_service_desk_id` → `get_or_fetch_project_meta` → `list_service_desks` —
  transitively depends on S1's fix site), confirmed against F1 §1 item 1 and ADR-0026 Decision 1's
  own attachments.rs paragraph. This is a genuine content-truth dependency, correctly encoded.
- **S2→S4 non-edge decision is sound:** S4's AC-001 hints reference scope name strings that are
  already fully specified in BC-1.3.023 (independent of whether S2's code has actually merged),
  and S4's tests mock the 401 body directly rather than requiring the real
  `DEFAULT_OAUTH_SCOPES` value. Verified: S4's own frontmatter carries this as an editorial/
  recommended-sequencing note (not a `depends_on:` edge), and its test plan (AC-001's wiremock
  fixtures) does not read the live constant. Correctly NOT an edge — matches
  `dependency-graph-extended.md` §4's stated rationale, and matches the general pattern this repo
  already established for content-accuracy-vs-compile-order edges in cycle-013.
- **Wave-1/Wave-2/parallel-track layering correct:** Wave 1 = {S1,S2,S3,S4} (indegree 0
  immediately), Wave 2 = {S5} (indegree 0 only after S1 completes), S6 = non-gating parallel track
  (matches D-368 / F1 §6a's explicit "spike, non-gating" framing). Critical path S1→S5 = 5+2 = 7
  points, correctly computed in `wave-schedule.md` §Summary.
- **Cross-cycle overlap correctly flagged, correctly NOT gated:** `src/api/auth.rs` overlap with
  two still-undispatched cycle-007 `status: draft` stories
  (`S-cycle7-credential-absence-fix`, `S-cycle7-auth-state-derivation`) is disjoint-region
  (different functions: `load_api_token`/`derive_auth_state` vs. `DEFAULT_OAUTH_SCOPES`), correctly
  resolved as a merge-order note only, not a dependency edge, mirroring the precedent the
  cycle-007 stories' own frontmatter already set.

**Verdict: wave/dependency correctness PASS.**

---

## 4. STORY-INDEX Integrity — PASS

- `total_stories: 191` in frontmatter (was 185, +6) — confirmed.
- "Total rows: 191 (matches `total_stories: 191` in frontmatter...)" note at STORY-INDEX.md:1543 —
  confirmed present and arithmetically consistent.
- `last_updated` narrative documents the incremental additions 185→186→187→188→189→190→191, one
  per story, in the same order the Feature Followup table's per-row parenthetical counters show
  (verified: `...185→186...` on S1's row, `...186→187...` on S2's row, ... `...190→191...` on S6's
  row) — no drift, no double-counting, no skipped number.
- All 6 stories appear exactly twice (once in the descriptive Story Manifest table, once in the
  file-path Feature Followup table) — 12 total `S-cycle8-*` row occurrences confirmed by direct
  count, matching the established two-table convention used by every prior cycle's rows in this
  file. No duplicate story IDs, no missing story ID, no orphaned row referencing a nonexistent
  story file.
- Version bump `1.6.26 → 1.6.27` is internally consistent with the frontmatter `version` field.
- Per-story metadata echoed in STORY-INDEX (points, wave, `depends_on`/`blocks`, priority,
  module_criticality, tdd_mode, AC count, target files, epic, subsystems) matches each story
  file's own frontmatter exactly for all 6 stories — spot-checked in full for S1/S2 and
  confirmed via the Feature Followup table row text for S3–S6.

**Verdict: STORY-INDEX count and integrity PASS.**

---

## 5. Template Compliance — PASS

All 6 story files contain every required section: Narrative, Behavioral Contracts, Acceptance
Criteria, Architecture Mapping, Edge Cases, **Purity Classification** (the hook-flagged section —
confirmed present in all 6), Token Budget Estimate, Tasks, Previous Story Intelligence,
Architecture Compliance Rules, Library & Framework Requirements, File Structure Requirements. No
missing section in any of the 6 files.

`acceptance_criteria_count` frontmatter field matches the actual count of `### AC-NNN` headings in
the body for all 6 stories (7/7, 8/8, 5/5, 4/4, 9/9, 6/6) — no drift.

`inputs:`/`input-hash:` frontmatter fields are present and populated (non-empty, non-placeholder)
in all 6 stories; each story's `inputs:` list correctly enumerates the upstream artifacts it
actually cites in its body (F1/F2 delta docs, ADR-0026, the relevant BC file(s), and the specific
`src/`/`tests/` files it targets).

**Verdict: template compliance PASS.**

---

## 6. Regression-Guard Presence — PASS (with one scoping clarification)

- **S1, S3, S5** (the three routing/verification stories) each explicitly state the api-token
  invariant (`base_url() == instance_url()` under Basic auth ⇒ the swap is a provable no-op) and
  explicitly specify `JiraClient::new_for_test_with_instance_url` as the test-construction
  primitive for every new AC test. Confirmed present in all three (S1: 4 invariant mentions / 8
  seam mentions; S3: 2 / 7; S5: 1 / 3).
- **S2 and S4** do NOT use the `new_for_test_with_instance_url` seam or restate the
  `base_url==instance_url` invariant verbatim — **this is correct, not a gap**: neither story
  touches `base_url`/`instance_url` routing at all. S2 is a pure `DEFAULT_OAUTH_SCOPES` constant
  edit (its own EC-4 states the equivalent, correctly-scoped regression guard: "API-token
  profile... Entirely unaffected — `DEFAULT_OAUTH_SCOPES` is only consulted by the OAuth
  login/refresh flow, never by Basic-auth request construction"). S4 is an auth-scheme-conditional
  (`is_oauth_auth()`) 401 rewrite; its own AC-004 is the correctly-scoped equivalent regression
  guard ("Basic-auth 401... continues to surface via the universal... path, unchanged"). Both
  stories state *their own* correct regression invariant for their own nature; requiring the
  routing-specific seam of a non-routing story would be a spec-mismatch, not a fix.
- **Platform-command non-regression** is explicitly stated in every code story via a dedicated
  regression-guard AC: S1 AC-007/AC-008 (existing JSM suite green, no other line changed), S2
  AC-005 (auth-URL builder unchanged), S3 AC-003/AC-004 (Assets AQL/object layer + existing suite
  unchanged), S4 AC-007 (`src/error.rs` + `jsm_create.rs`'s existing rewrite byte-for-byte
  unchanged), S5 AC-002 (`attachments.rs` byte-for-byte unchanged, zero `src/` diff).

**Verdict: regression-guard presence PASS**, with the above scoping note recorded for the human
gate's awareness (not a defect).

---

## 7. Perimeter Check — PASS

- **docs/adr/ backlinks** (to ADR-0026, from `0009-handle-open-instance-url.md`,
  `0006-embedded-jr-oauth-app.md`, `0013-pkce-deferral.md`): correctly folded into **S1's AC-009**
  and Task 10. Confirmed via direct read of all three `docs/adr/` files: none currently reference
  ADR-0026 (grep returned zero hits), consistent with ADR-0026's own "Bidirectional backlink note"
  stating these edits are DEFERRED to the F4 implementation PR and that an earlier direct edit was
  intentionally reverted. S1 is the only story claiming this task — no duplication across stories.
- **The pinning-test update** (`default_oauth_scopes_pins_the_full_set_with_offline_access`):
  correctly folded into **S2's AC-002** (same-commit obligation, full 16-scope union assertion,
  plus the two new Teams negative assertions).
- **The JSM attachment E2E path**: correctly folded into **S5** as its sole deliverable (a new
  end-to-end wiremock test proving the two-step upload flow succeeds once S1 lands).
- No approved-scope work item was found with zero story coverage. Cross-checked against F1 §7's
  Recommended Story Decomposition Preview table (S1–S6 exactly, same sizes, same dependency
  shape) and F2-architecture-delta.md's Workstream→files map (S1–S6, same file sets) — the F3
  story set is a 1:1 realization of both upstream previews with no scope drift in either
  direction.

**Verdict: perimeter check PASS.**

---

## Non-Blocking Findings (upstream drift, not introduced by this F3 pass)

### F-1 (MINOR / informational) — ADR-0026 Decision 2's illustrative scope-list ordering differs from BC-1.3.023's / S2's authoritative literal string order

ADR-0026's Decision 2 code block presents the 16 scopes grouped by category with comments
(`manage:jira-project` inserted in position 4, immediately after `read:jira-user`; `offline_access`
placed last under a "Refresh token" heading). The actual finalized, pinned literal in
`BC-1.3.023`'s Behavior section — and the byte-identical string in S2's own AC-001 — instead
preserves the **pre-existing 8-scope substring unchanged in its original relative order**
(`read:jira-work write:jira-work read:jira-user read:servicedesk-request
write:servicedesk-request read:cmdb-object:jira read:cmdb-schema:jira offline_access`, confirmed
against `oauth-endpoint-inventory.md`'s verbatim pre-cycle-008 scan of `auth.rs:83-88`) and
**appends** `manage:jira-project` plus the 7 granular Agile scopes after it. These are two
different byte-for-byte strings for the "same" finalized 16-scope set.

This does not affect S2's implementability or correctness — S2 explicitly and unambiguously cites
BC-1.3.023 (not ADR-0026's code block) as its source of truth, and BC-1.3.023's append-only
ordering is the more defensible design (minimal diff against the pre-existing constant, order
of the untouched 8 scopes literally unchanged). However, a reviewer who reads only ADR-0026 and
expects its code block to be the literal string will be surprised. Recommend a documentation-only
follow-up (not a blocker for this F3 gate) reconciling ADR-0026's Decision 2 code block to either
(a) match BC-1.3.023's actual append-only order, or (b) add a note that the block is
category-illustrative, not order-authoritative.

**Files:** `.factory/specs/architecture/decisions/ADR-0026-oauth-3lo-gateway-routing-invariant-and-granular-jira-software-scopes.md` (Decision 2 code block) vs. `.factory/specs/prd/bc-1-auth-identity.md:829` (BC-1.3.023 Behavior section) vs. `.factory/cycles/cycle-008/phase-f3-stories/S-cycle8-agile-oauth-scope-gap.md` (AC-001).

### F-2 (MINOR / informational) — F2-architecture-delta.md's "New artifacts this phase" table is stale re: docs/adr/ backlinks

`F2-architecture-delta.md` line 29 lists, under "New artifacts this phase": *"Backlink notes
(pre-existing ADRs) | `docs/adr/0009-...`, `docs/adr/0006-...`, `docs/adr/0013-...` — each gained
a 'See Also'/backlink line pointing to ADR-0026"* — phrased as already-done. This directly
contradicts ADR-0026's own "Bidirectional backlink note" (written the same day), which states
these backlinks are explicitly **deferred to the F4 implementation PR** and that an earlier
direct edit adding them was **intentionally reverted**. Direct inspection of all three
`docs/adr/` files (this audit, 2026-09-17) confirms zero references to ADR-0026 in any of
them — ADR-0026's statement is the accurate one; F2-architecture-delta.md's line is stale.

This does not affect the F3 story set's correctness: S1 correctly follows ADR-0026's (accurate)
instruction and schedules the backlinks as an F4 task (AC-009), not as already-done. Recommend a
documentation-only fix to `F2-architecture-delta.md` line 29 (change tense/status to "deferred to
F4, not yet applied") so a future reader isn't misled by this document in isolation.

**Files:** `.factory/cycles/cycle-008/F2-architecture-delta.md:29` vs. ADR-0026's "Bidirectional backlink note" (final section) vs. `docs/adr/0009-handle-open-instance-url.md`, `docs/adr/0006-embedded-jr-oauth-app.md`, `docs/adr/0013-pkce-deferral.md` (confirmed unchanged).

---

## Explicit Verdicts Summary

| Dimension | Verdict |
|---|---|
| AC → BC → VP traceability | **PASS** |
| Scope fidelity (exactly F2-approved scope) | **PASS** |
| Wave / dependency-graph correctness (acyclic, correct edges/non-edges) | **PASS** |
| STORY-INDEX count integrity (185→191, no dupes/gaps) | **PASS** |
| Template compliance (all 6 stories, all required sections) | **PASS** |
| Regression-guard presence | **PASS** (scoping note recorded, not a defect) |
| Perimeter check (docs/adr backlinks, pinning-test, JSM attachment E2E all covered) | **PASS** |

## Overall Gate Recommendation

**CONSISTENT.** No CRITICAL or blocking findings against the 6 story files, the dependency graph,
the wave schedule, or the STORY-INDEX integration. The two findings recorded above (F-1, F-2) are
MINOR, pre-existing in the F1/F2/ADR-0026 upstream artifacts (not introduced by this F3 story
decomposition), and do not affect any story's implementability, testability, or traceability. The
F3 human gate may proceed to APPROVE without requiring story-file changes; F-1/F-2 may be queued
as a low-priority documentation follow-up at the human's discretion.
