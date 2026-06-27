---
document_type: story
story_id: "S-E2E-WIREMOCK-COVERAGE-1"
title: "Retroactive F3 traceability — E2E wiremock-tier coverage (INV-1 ADF wiring, partial_match no-HTTP, bulk-move nested schema) (PR #564)"
wave: feature-followup
status: done
intent: test-hardening-backfill
feature_type: test-only
mode: feature
scope: small
severity: LOW
trivial_scope: false
issue: ~564
points: 2
priority: P2
tdd_mode: strict
estimated_effort: xsmall
estimated_days: 0
target_module: adf,queue,issue_bulk
subsystems: []
depends_on: []
blocks: []
bc_anchors:
  - BC-7.2.011
  - BC-X.10.001
  - BC-3.2.009
bcs:
  - BC-7.2.011
  - BC-X.10.001
  - BC-3.2.009
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-story-decomposition
spec_source: "E2E edge-case audit 2026-06-27 (wiremock tier, drift item E2E-EDGE-CASE-GAPS-2026-06-27)"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 3
assumption_validations: []
risk_mitigations: []
created: "2026-06-27"
last_updated: "2026-06-27"
breaking_change: false
retroactive: true
retroactive_reason: >
  PR #564 was delivered via the full VSDD pipeline (clean code review + adversarial gate
  CLEAN after one iteration that caught and corrected a CRITICAL false-reachability claim)
  and merged to develop before a pre-delivery story file was written.  This story provides
  the missing F3 traceability and closes the process deviation.  No production source change
  is involved; all 3 ACs are regression pins — each confirmed ALREADY IMPLEMENTED and PASSING
  before PR #564 was raised.  The audit's key finding: these were regression-hardening tests,
  NOT bug fixes.
predecessor_cycles: >
  PR #564 (test(e2e): wiremock-tier coverage for INV-1 ADF wiring, partial_match no-HTTP,
  bulk-move nested schema, develop @ 502898f).
origin: >
  E2E edge-case audit (wiremock tier, drift item E2E-EDGE-CASE-GAPS-2026-06-27).  Audit
  confirmed: (1) ADF push_text INV-1 routing (no-hardBreak on inline-HTML path,
  tests/adf_inline_html_inv1_e2e.rs), (2) partial_match ambiguous-query SD-list HTTP count
  (tests/queue.rs), and (3) bulk-move nested bulkTransitionInputs wire schema + all-keys-failed
  exit code (tests/issue_bulk.rs) were all already implemented and passing.  PR #564 adds
  regression pins so these confirmed behaviors survive future refactors.
f5_review_outcome: >
  F5 fresh-context adversarial review run pre-merge (PR #564): adversarial gate found 1 CRITICAL
  false-reachability claim (the §2.3 lone-\r issue — the original fix mechanism wrongly asserted
  that a lone-\r from markdown source would reach push_text; in fact CommonMark §2.3 normalizes
  lone-\r (and \r\n) → \n BEFORE pulldown tokenization, so a raw \r from markdown source never
  reaches push_text at all; the AC note was corrected to state that the e2e-unique guard is the
  no-hardBreak routing assertion (inline-HTML push_text path vs block-HTML Algorithm B), and that
  char-level CR/LF normalization is delegated to direct push_text unit tests because the \r never
  arrives at push_text from markdown source).  After iteration, adversarial gate returned CLEAN.
  All CI green.  Gated merge.  Post-merge signal: CLEAN.  This story records that outcome as the
  authoritative F5 gate for this delivery.  The adversarial gate's catch is notable as a strong
  diverse-lens/fresh-context catch: the inverted CommonMark §2.3 claim survived initial authoring
  and was caught only by the adversary pass.
delivering_prs:
  - "PR #564 — develop @ 502898f"
skip_log:
  - reason: "Per-AC demo recording N/A — test-only story; no user-facing surface added or changed."
changelog:
  - date: "2026-06-27"
    phase: F3-story-decomposition
    author: story-writer
    summary: >
      Retroactive F3 traceability backfill for PR #564.  3 regression pins documented across
      BC-7.2.011 (tests/adf_inline_html_inv1_e2e.rs), BC-X.10.001 (tests/queue.rs), and
      BC-3.2.009 (tests/issue_bulk.rs).  F5 adversarial gate pre-merge: 1 CRITICAL false-claim
      found and corrected; post-iteration CLEAN.  All CI green.  Story #94 (93 → 94).
files_modified:
  - tests/adf_inline_html_inv1_e2e.rs  # new file: test_issue_create_markdown_inline_html_submits_inv1_compliant_adf_no_hardbreak
  - tests/queue.rs                     # 1 new test: test_resolve_queue_ambiguous_fires_list_exactly_once_no_followon_http
  - tests/issue_bulk.rs                # 1 new test: test_move_multikey_bulk_nonidempotent_per_key_400_exits_1_with_nested_schema
---

# S-E2E-WIREMOCK-COVERAGE-1 — Retroactive F3 Traceability: E2E Wiremock-Tier Coverage (PR #564)

## Status

**DONE — already delivered.**

This story is a RETROACTIVE TRACEABILITY BACKFILL.  PR #564 was merged to `develop`
before a story file was written (process deviation from the standard F3-first flow).
This document provides the missing F3 artifact and closes the deviation.  No production
code was changed; all three acceptance criteria are regression pins against behaviors
that were confirmed ALREADY IMPLEMENTED and PASSING before the PR was raised.

**Origin:** E2E edge-case audit (wiremock tier, drift item E2E-EDGE-CASE-GAPS-2026-06-27).
The audit's key finding was that all three behaviors were already implemented — the tests
PASS without a production change.  This is regression-hardening, not a bug fix.

**F5 fresh-context adversarial review** was run pre-merge.  The adversarial gate caught
a CRITICAL false-reachability claim: the original fix mechanism wrongly asserted a lone-`\r`
from markdown source would reach `push_text`.  In fact, CommonMark §2.3 normalizes lone-`\r`
(and `\r\n`) → `\n` BEFORE pulldown tokenization, so a raw `\r` from markdown source never
reaches `push_text` at all — which is precisely why this e2e test does NOT pin char-level
CR/LF normalization (that is delegated to the direct `push_text` unit tests).  After the
correction (the AC note was updated to describe the no-hardBreak routing assertion as the
genuine e2e-unique value: the structural distinction between the inline-HTML `push_text`
path and block-HTML Algorithm B), the adversarial gate returned CLEAN.  All CI passed; the
PR was gated-merged.

This catch is recorded as a strong diverse-lens/fresh-context signal: the false claim
survived initial authoring and was found only by the adversary pass.  Post-merge signal
is CLEAN and recorded in `f5_review_outcome` frontmatter above.

## Source of Truth

| Artifact | Location |
|----------|----------|
| BC-7.2.011 body | `.factory/specs/prd/bc-7-output-render.md §7.2.011` |
| BC-X.10.001 body | `.factory/specs/prd/cross-cutting.md §X.10.001` |
| BC-3.2.009 body | `.factory/specs/prd/bc-3-issue-write.md §3.2.009` |
| PR #564 commit | `develop @ 502898f` |
| E2E audit drift item | `E2E-EDGE-CASE-GAPS-2026-06-27` (wiremock tier) |

## Behavioral Contracts

| BC | Title | Role in this story |
|----|-------|-------------------|
| BC-7.2.011 | `markdown_to_adf` block-HTML + CR/LF normalization invariants (INV-1) | PRIMARY: one regression pin — e2e wiring guard that `jr issue create` with multi-line inline HTML submits INV-1-compliant ADF (no raw `\r`/`\n` in text nodes) via the no-hardBreak push_text routing path. |
| BC-X.10.001 | `partial_match` with single-substring → `Ambiguous` (NOT Exact); never auto-resolves | PRIMARY: one regression pin — ambiguous partial queue match fires the SD list endpoint exactly once and then exits 64 with zero follow-on HTTP calls. |
| BC-3.2.009 | `issue move` 400 "resolution required" → `--resolution` hint + `jr issue resolutions` discovery pointer | PRIMARY: one regression pin — bulk move nested `bulkTransitionInputs` wire schema (`sendBulkNotification:false`) + all-keys-failed → exit 1. Also pins FIX-BULK-TRANSITION-001 (nested-not-flat wire schema). |

## Story Narrative

As a developer maintaining the `jr` codebase,
I want regression tests that pin the behavioral guarantees of the INV-1 ADF
inline-HTML push_text routing path, the `partial_match` ambiguous-query HTTP
non-escalation invariant, and the bulk-move nested wire schema with all-keys-failed
exit code,
so that future refactors immediately surface regressions against these behavioral
contracts before they reach CI and before they affect users.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~1,600 |
| tests/adf_inline_html_inv1_e2e.rs (~340 LOC) | ~1,500 |
| tests/queue.rs (1 new test fn, ~80 LOC context) | ~400 |
| tests/issue_bulk.rs (1 new test fn, ~120 LOC context) | ~550 |
| BC files (3 BC sections, bc-7 + cross-cutting + bc-3) | ~900 |
| **Total** | **~4,950** |

Well within a 20% agent context window budget. No splitting required.

## Previous Story Intelligence

**BC-7.2.011 context (S-492, S-522, S-D4-TEST-HARDENING-BACKFILL-1):**
S-492 delivered Algorithm B (block-HTML hardBreak interior newlines).  S-522 delivered
the `push_text` / `push_code` CR/LF normalization chokepoint.  S-D4-TEST-HARDENING-BACKFILL-1
added D4 holdout pins for Algorithm B (block-HTML plain-text interior lines) and footnote
node-granularity.  PR #564 adds the distinct e2e-tier wiring guard: that `jr issue create`
with a multi-line inline HTML `--description` routes through `push_text` (not Algorithm B)
and submits INV-1-compliant ADF (no hardBreak — inline HTML → space, not hardBreak).
This is the integration-layer closure for the block-HTML / inline-HTML asymmetry
documented in the BC-7.2.011 gotcha entry.

**BC-X.10.001 context (S-428):**
S-428 (wiremock-only refactor: extract `resolve_cloud_id`) established the pattern of
wiremock-isolated in-process tests for the partial_match code path.  PR #564 adds the
missing ambiguous-queue-name guard test, which pins that the SD list endpoint is called
exactly once (not re-queried after the disambiguation failure) and that zero follow-on
HTTP occurs after the ambiguous result is returned.

**BC-3.2.009 context (S-2.02, S-JSM-RESOLUTION-REQUIRED, S-3.07):**
S-2.02 established the BC-3.2.009 reactive backstop (POST→400 rewrite and `--resolution`
hint).  S-JSM-RESOLUTION-REQUIRED added proactive enforcement (BC-3.2.013) which preserved
BC-3.2.009 as a fallback.  S-3.07 added the anti-loop guard for JRACLOUD-95368.  PR #564
adds the missing wiremock test for the **bulk** move path (multi-key, not single-key),
pinning the FIX-BULK-TRANSITION-001 nested wire schema and the all-keys-failed → exit 1
behavior.  The bulk move path is explicitly excluded from BC-3.2.013 proactive enforcement,
so BC-3.2.009 reactive backstop is the primary contract here.

**N/A — no successor stories blocked by this backfill.**

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Test-only scope | PR #564 | No production source file modified.  Three integration test files only: one new file (`tests/adf_inline_html_inv1_e2e.rs`) and two existing files (`tests/queue.rs`, `tests/issue_bulk.rs`).  No CLI flags, API methods, config paths, or keychain changes. |
| INV-1 ADF no-hardBreak routing guard | BC-7.2.011 | The e2e-unique value of AC-001 is the no-hardBreak assertion: inline-HTML enters the `push_text` (Other-context) code path, which maps `\r\n`/lone-`\r`/bare-`\n` to a SPACE (not a `hardBreak`).  This is structurally distinct from block-HTML Algorithm B (which produces `hardBreak` nodes).  The test asserts absence of any `hardBreak` node in the submitted ADF body to pin this routing. |
| Char-level CR/LF normalization NOT covered at e2e tier | BC-7.2.011 INV-1 | CommonMark §2.3 normalizes lone-`\r` (and `\r\n`) → `\n` BEFORE pulldown tokenization, so a raw `\r` from markdown source never reaches `push_text` at all (adversary-gate finding, pre-merge corrected: the original fix wrongly claimed the \r would reach push_text).  This is precisely why this e2e test does NOT pin char-level CR/LF normalization — that is delegated to direct `push_text` unit tests (`src/adf.rs::tests`).  The e2e test covers the routing path (no-hardBreak: inline-HTML enters push_text Other-context, not Algorithm B) and the INV-1 structural guarantee (no raw `\r`/`\n` in any text node) for a standard multi-line inline-HTML input. |
| partial_match no-follow-on HTTP | BC-X.10.001 | AC-002 mounts only the SD list endpoint with `.expect(1)` and verifies exit 64.  Zero follow-on HTTP is asserted implicitly: WireMock fails the test on any unexpected call, and `.expect(1)` asserts exactly one call was made.  No mock for queue-detail or issue-list endpoints is needed. |
| Nested bulkTransitionInputs wire schema (FIX-BULK-TRANSITION-001) | BC-3.2.009 | AC-003 mounts a `POST /rest/api/3/bulk/issues/transition` stub that only matches the NESTED schema (`{"bulkTransitionInputs":[{"selectedIssueIdsOrKeys":[…],"transitionId":"…"}],"sendBulkNotification":false}`).  Any deviation from this schema (flat root, wrong `sendBulkNotification`) causes the mock not to match, producing an unexpected-call failure. |
| No numeric test-count citations in BC bodies | scripts/check-bc-no-numeric-test-counts.sh | This story does not modify BC bodies.  It documents tests that already satisfy existing BC Source/Trace fields. |

## Library and Framework Requirements

| Library | Version | Constraint |
|---------|---------|-----------|
| wiremock | current (from Cargo.toml) | All three tests use WireMock for HTTP isolation.  `.expect(1)` used in AC-002 to assert exact HTTP call count.  No version change. |
| tokio | current (from Cargo.toml) | `#[tokio::test(flavor = "multi_thread", worker_threads = 2)]` on all new tests.  No version change. |
| serde_json | current (from Cargo.toml) | AC-001 parses the captured ADF request body to assert structural properties.  AC-003 builds the expected nested wire-schema fixture.  No version change. |

No new crate dependencies were added by PR #564.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `tests/adf_inline_html_inv1_e2e.rs` | CREATED (PR #564) | New integration test file; one test function: `test_issue_create_markdown_inline_html_submits_inv1_compliant_adf_no_hardbreak` |
| `tests/queue.rs` | MODIFIED (PR #564) | 1 new integration test appended: `test_resolve_queue_ambiguous_fires_list_exactly_once_no_followon_http` |
| `tests/issue_bulk.rs` | MODIFIED (PR #564) | 1 new integration test appended: `test_move_multikey_bulk_nonidempotent_per_key_400_exits_1_with_nested_schema` |

---

## Acceptance Criteria

All ACs below are **regression pins** — each was verified PASS at the time the
delivering PR merged (develop @ 502898f).  No production change was required;
the behaviors being pinned were confirmed already implemented.  Each AC includes the
test function name that satisfies it.

---

### tests/adf_inline_html_inv1_e2e.rs — BC-7.2.011 INV-1 Routing Guard

#### AC-001 — `jr issue create` with multi-line inline HTML submits INV-1-compliant ADF with no hardBreak node
(traces to BC-7.2.011 postcondition — INV-1: no raw `\r`/`\n` in any text node; routing
postcondition: inline-HTML enters `push_text` Other-context path → space (not hardBreak);
`tests/adf_inline_html_inv1_e2e.rs::test_issue_create_markdown_inline_html_submits_inv1_compliant_adf_no_hardbreak`)

`jr issue create --project TEST --type Task --summary "test" --description "foo <span\ndata-x=\"y\">bar</span> baz"` when
`POST /rest/api/3/issue` is stubbed with a 201 response:

1. Exits 0.
2. The captured `description` ADF body contains no `hardBreak` node (inline HTML interior
   newline was mapped to a space by `push_text`, not to a `hardBreak` by Algorithm B).
3. No text node in the submitted ADF body contains a raw `\n` or `\r` character (INV-1
   structural invariant).

The e2e-unique guard is the no-hardBreak routing assertion (#2).  This distinguishes the
inline-HTML `push_text` code path from block-HTML Algorithm B (which DOES emit hardBreak
nodes for interior newlines).  The test confirms the two paths remain structurally distinct.

Char-level CR/LF normalization (e.g., that a lone-`\r` in inline HTML produces a space)
is NOT the primary claim of this test and is NOT asserted at the e2e tier.  That delegation
was the subject of the adversary-gate CRITICAL finding corrected pre-merge: CommonMark §2.3
normalizes lone-`\r` (and `\r\n`) → `\n` BEFORE pulldown tokenization, so a raw `\r` from
markdown source never reaches `push_text` at all — which is precisely why the e2e test
cannot pin char-level CR/LF normalization via a markdown input string.  Char-level
normalization is covered by direct `push_text` unit tests in `src/adf.rs::tests`.

Verified PASS (develop @ 502898f).
Pinned by: `tests/adf_inline_html_inv1_e2e.rs::test_issue_create_markdown_inline_html_submits_inv1_compliant_adf_no_hardbreak`

---

### tests/queue.rs — BC-X.10.001 Partial-Match Ambiguous No-Follow-On HTTP

#### AC-002 — Ambiguous partial queue-name match fires SD list endpoint exactly once, exits 64, zero follow-on HTTP
(traces to BC-X.10.001 postcondition — `partial_match` single-substring → `Ambiguous`, never
auto-resolves; SD list endpoint called exactly once; no follow-on HTTP calls;
`tests/queue.rs::test_resolve_queue_ambiguous_fires_list_exactly_once_no_followon_http`)

`jr queue view --name "Support" --project HELP` when `GET /rest/servicedeskapi/servicedesk/HELP/queue`
returns two queues whose names both contain "Support" (e.g., "Support Tier 1" and "Support Tier 2"):

1. Exits 64 (ambiguous match).
2. Stderr identifies the two matching queue names (disambiguation hint).
3. The SD list endpoint was called exactly once (`.expect(1)` assertion on the WireMock mount).
4. No follow-on HTTP calls are made after the ambiguous result is returned (WireMock fails on
   any call to a non-mounted endpoint; no queue-detail or issue-list endpoint mock is registered).

This pin closes the audit gap: prior queue tests exercised the exact-match and not-found paths;
no test previously verified that the ambiguous path does not escalate to additional HTTP requests.

Verified PASS (develop @ 502898f).
Pinned by: `tests/queue.rs::test_resolve_queue_ambiguous_fires_list_exactly_once_no_followon_http`

---

### tests/issue_bulk.rs — BC-3.2.009 Bulk-Move Nested Wire Schema

#### AC-003 — Bulk move with nested `bulkTransitionInputs` wire schema and all-keys-failed exits 1
(traces to BC-3.2.009 postcondition — reactive backstop: bulk move 400 per-key `"resolution required"`
→ `--resolution` hint + exit 1; FIX-BULK-TRANSITION-001: NESTED `bulkTransitionInputs` wire schema
(not flat root), `sendBulkNotification:false`;
`tests/issue_bulk.rs::test_move_multikey_bulk_nonidempotent_per_key_400_exits_1_with_nested_schema`)

`jr issue move FOO-1 FOO-2 --to "Done"` when:
- `GET /rest/api/3/issue/FOO-1` and `GET /rest/api/3/issue/FOO-2` return issues with
  valid transitions including a "Done" transition (id: "31").
- `POST /rest/api/3/bulk/issues/transition` is stubbed to match ONLY the nested schema:
  `{"bulkTransitionInputs":[{"selectedIssueIdsOrKeys":["FOO-1","FOO-2"],"transitionId":"31"}],"sendBulkNotification":false}`
  and returns a task-id response.
- Bulk poll returns a completed task with all-keys-failed (each key has a 400 error indicating
  "resolution required").

Result:
1. Exits 1 (all-keys-failed is a non-recoverable error).
2. Stderr contains a message referencing the `--resolution` flag or `jr issue resolutions`
   (BC-3.2.009 reactive hint text).
3. The bulk transition POST was called with the NESTED schema (mock only matches nested;
   any deviation — flat root, missing `sendBulkNotification`, wrong key name — causes the
   stub not to match, producing an unexpected-call WireMock failure).

This pin closes the audit gap: S-2.02 (PR #304) established the single-key BC-3.2.009
reactive backstop test.  No test previously pinned the multi-key (bulk) code path with the
FIX-BULK-TRANSITION-001 nested wire schema and all-keys-failed → exit 1 outcome together.
The test is intentionally NON-idempotent (bulk transitions are not idempotent — per CLAUDE.md
gotcha; BC-3.2.009 is the reactive backstop, not proactive enforcement which is single-key-only).

Verified PASS (develop @ 502898f).
Pinned by: `tests/issue_bulk.rs::test_move_multikey_bulk_nonidempotent_per_key_400_exits_1_with_nested_schema`

---

## Out of Scope (explicit)

**No production source changes.** PR #564 is test-only.  No CLI flag, API method,
config path, keychain entry, or observable user-facing behavior was changed.

**Per-AC demo recording.** These are pure regression pins with no observable user-facing
surface.  Skip Log: `per-AC demo recording N/A — test-only / no user-facing surface`.

**Char-level CR/LF normalization at the e2e tier.** Delegated to direct `push_text`
unit tests in `src/adf.rs::tests` (pre-existing coverage in S-522).  CommonMark §2.3
normalizes lone-`\r` (and `\r\n`) → `\n` BEFORE pulldown tokenization, so a raw `\r`
from markdown source never reaches `push_text` at all — it is impossible to deliver a
lone-`\r` to `push_text` via a markdown CLI input string.  Coverage of the char-level
normalization behavior inside `push_text` requires direct unit-test injection, not an
e2e test driven through a `--description` CLI flag.

**Live E2E tier.** All three tests are wiremock-tier (offline integration).  The queue
non-JSM-project guard is already exercised at the live E2E tier by S-JSM-E2E-1 (PR #460).
Bulk-move and inline-HTML-ADF tests are appropriate at the wiremock tier only — they test
guard conditions or structural wire-format properties that do not require a real Jira instance.

---

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `test_issue_create_markdown_inline_html_submits_inv1_compliant_adf_no_hardbreak` | `tests/adf_inline_html_inv1_e2e.rs` | Effectful (subprocess + WireMock) | Spawns `jr` subprocess with inline-HTML description; captures the POST request body and asserts ADF structural properties (no hardBreak, no raw `\r`/`\n`); mounts issue-create 201 stub |
| `test_resolve_queue_ambiguous_fires_list_exactly_once_no_followon_http` | `tests/queue.rs` | Effectful (subprocess + WireMock) | Spawns `jr` subprocess; mounts SD queue-list stub with `.expect(1)`; asserts exit 64, stderr disambiguation message, and zero follow-on HTTP via WireMock strict-mode |
| `test_move_multikey_bulk_nonidempotent_per_key_400_exits_1_with_nested_schema` | `tests/issue_bulk.rs` | Effectful (subprocess + WireMock) | Spawns `jr` subprocess; mounts transition, bulk-move, and poll stubs; stub for bulk-move only matches nested schema; asserts exit 1 and `--resolution` hint in stderr |

**Subsystem anchor justification:** No ARCH-INDEX subsystem applies — all three modified
or created files are integration test files (`tests/`) with no cross-subsystem interaction
in these additions.

**Dependency anchor justification:** `depends_on: []` — all prerequisite production code
(BC-7.2.011 `push_text` chokepoint from S-522; BC-X.10.001 `partial_match` from S-428;
BC-3.2.009 bulk-move wire schema from S-2.02 + FIX-BULK-TRANSITION-001 from the bulk
transition fix that preceded PR #564) was already merged before PR #564.  `blocks: []` —
no story depends on these test pins.

---

## Edge Cases

| ID | Source | Description | Expected Behavior | AC |
|----|--------|-------------|-------------------|----|
| EC-001 | BC-7.2.011 INV-1 / inline-HTML routing | `jr issue create` description contains multi-line inline HTML (interior `\n` in the flag value) | `push_text` Other-context path maps the `\n` to a space; no `hardBreak` node in submitted ADF; INV-1 holds | AC-001 |
| EC-002 | BC-7.2.011 routing asymmetry | Inline-HTML `\n` → space vs block-HTML `\n` → hardBreak | The two paths are structurally distinct; char-level CR/LF normalization of edge-case inputs (lone-`\r`) is covered by direct unit tests, not this e2e test | AC-001 |
| EC-003 | BC-X.10.001 | Ambiguous partial queue name produces exactly one SD list call | No auto-resolution, no re-query, no follow-on HTTP after the `Ambiguous` result is returned; exit 64 with disambiguation hint | AC-002 |
| EC-004 | BC-3.2.009 / FIX-BULK-TRANSITION-001 | Bulk move with flat root schema (pre-fix shape) | Stub only matches nested schema; flat-root POST does not match → WireMock unexpected-call failure; confirms the nested schema is enforced in the live code path | AC-003 |
| EC-005 | BC-3.2.009 | Bulk move all-keys-failed with per-key 400 "resolution required" | Exit 1 (not 0, not 64); stderr `--resolution` hint present | AC-003 |

---

## Test Coverage Summary

All tests are integration tests (subprocess + WireMock).  No new inline unit tests.
No new E2E (live) tests.

### PR #564 test inventory

| File | Test name | BC | AC |
|------|-----------|----|----|
| `tests/adf_inline_html_inv1_e2e.rs` | `test_issue_create_markdown_inline_html_submits_inv1_compliant_adf_no_hardbreak` | BC-7.2.011 | AC-001 |
| `tests/queue.rs` | `test_resolve_queue_ambiguous_fires_list_exactly_once_no_followon_http` | BC-X.10.001 | AC-002 |
| `tests/issue_bulk.rs` | `test_move_multikey_bulk_nonidempotent_per_key_400_exits_1_with_nested_schema` | BC-3.2.009 | AC-003 |

**Total new tests: 3.**  All pass at delivering commit (develop @ 502898f).
`cargo test` green.  No test renames; no test deletions.

**F5 adversarial gate outcome (pre-merge):** 1 CRITICAL finding (false CommonMark §2.3
lone-`\r` pre-normalization claim) caught and corrected.  Post-iteration: CLEAN.  All CI
green.  Gated merge.

---

## Dependency Analysis

**No dependency cycle introduced.**  This story has `depends_on: []` and `blocks: []`.
It is a leaf node in the dependency graph.

Wave placement: feature-followup (retroactive backfill of delivered test-only changes).
No wave gate impact — story is already `done`.

---

## Story Points and Effort

**2 story points** (retroactive F3 traceability document only; implementation already
merged).

Breakdown:
- F3 story authoring: 1 SP
- F5 review: already run pre-merge (1 CRITICAL corrected; post-iteration CLEAN); no
  separate dispatch needed: 1 SP

From-scratch TDD estimate would be ~3 SP.  Reduction reflects that all tests are
already written, merged, and passing.
