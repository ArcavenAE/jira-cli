---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-15T00:00:00
phase: f2
inputs: [.factory/specs/prd/bc-3-issue-write.md, .factory/specs/prd/bc-8-components.md, .factory/phase-f2-spec-evolution/prd-delta-components.md, .factory/specs/prd/BC-INDEX.md, .factory/phase-f2-spec-evolution/verification-delta-components.md, .factory/specs/architecture/decisions/ADR-0018-component-resolution-caching-mutation-strategy.md]
input-hash: "0cbc11e"
traces_to: .factory/phase-f2-spec-evolution/prd-delta-components.md
pass: 10
previous_review: .factory/phase-f2-spec-evolution/adversarial-spec-delta-review-components-p9.md
---

# Adversarial Review: Component Management Bundle (Pass 10)

Adversarial Spec-Delta Review — Component Management (F2, pass 10). VERDICT: NOT CLEAN. 0 CRIT,
0 HIGH, 1 MEDIUM, 1 LOW, 2 INFO. Novelty LOW-to-MODERATE (both substantive findings NEW, not
retreads; full VP run 001-028 + BC↔VP mapping independently re-verified gapless/consistent/
single-def, no title↔postcondition contradiction among sampled BCs).

## Finding ID Convention

Finding IDs use the format: `ADV-P10-<SEV>-<SEQ>` (no cycle prefix — no `.factory/current-cycle`
file present for this bundle at review time).

## Part A — Fix Verification (pass >= 2)

| ID | Previous Severity | Status | Notes |
|----|-------------------|--------|-------|
| ADV-P9-HIGH-001 (BC-8.2.008 H1 claimed idempotent-friendly, contradicting body/VP/EC/prd-delta) | HIGH | RESOLVED | H1 now reads "component delete is NOT idempotent — source-not-found → exit 64, concurrent-delete race → exit 1", matching Idempotency section, VP-COMPONENT-024, EC-8.2.008-1, and prd-delta |
| ADV-P9-LOW-001 (BC-8.2.002 `--output json` literal a 3-key subset missing `affectedIssues`) | LOW | RESOLVED | BC-8.2.002's inline literal replaced with an explicit cross-reference: "`--output json` — see BC-8.2.008 for the full canonical 4-key shape, including `affectedIssues`" (L857) |

## Part B — New Findings

### MEDIUM

#### ADV-P10-MED-001: Live-smoke gate mandates a REPLACE operation `jr` never emits — VP-COMPONENT-012 §1.2/§5 + BC-3.4.023 Delivery note overspecify the F4/F6 gate beyond jr's own wire behavior

- **Severity:** MEDIUM
- **Category:** spec-fidelity / test-plan overspecification
- **Location:** `.factory/phase-f2-spec-evolution/verification-delta-components.md` VP-COMPONENT-012
  §1.2 (~L277) and §5 (~L698-705); `.factory/specs/prd/bc-3-issue-write.md` BC-3.4.023 Delivery
  note (~L2486); (architect handles the companion ADR-0018 rationale text concurrently)
- **Description:** The live-smoke gate text reads "1×ADD, 1×REMOVE, 1×REPLACE across ≥2 issues in
  one project" in three places (VP-012's Method text, §5's callout, and BC-3.4.023's Delivery
  note), but BC-3.4.023 Postcondition 3 is unambiguous that `jr` ONLY ever emits `ADD` or `REMOVE`
  as `bulkEditMultiSelectFieldOption`: a bare `--component X` resolves to ADD; a mixed
  `add:`+`remove:` invocation issues TWO sequential POSTs (ADD then REMOVE) — never a single
  REPLACE POST. `jr` has no `set:`/`replace:`/`clear:` CLI grammar (confirmed absent from both
  BC-3.4.022's single-key and BC-3.4.023's bulk sections), so it structurally cannot construct a
  `bulkEditMultiSelectFieldOption: "REPLACE"` request body. The gate as worded requires F4/F6 to
  exercise a code path that does not exist in the spec it is gating — an unsatisfiable acceptance
  criterion. Postcondition 3's `ADD | REMOVE | REPLACE | REMOVE_ALL` enum listing is correctly
  scoped as a WIRE-SCHEMA completeness statement (what the endpoint accepts) but the live-smoke
  gate conflated that with what `jr` itself generates — the same conflation VP-COMPONENT-012's own
  History note flags research §Q2.4 as originating ("aligns this restatement with BC-3.4.023
  Postcondition 6" was the pass-3 fix; this MEDIUM is a sibling gap in the LIVE-VALIDATION gate,
  not the wire-shape restatement).
- **Evidence:** BC-3.4.023 Postcondition 3 (bc-3-issue-write.md ~L2513-2522): "`
  bulkEditMultiSelectFieldOption` is one of `ADD` \| `REMOVE` \| `REPLACE` \| `REMOVE_ALL`. When
  BOTH `add:` and `remove:` specs are present in one invocation, `jr` issues TWO coalesced entries
  in a single POST … `jr` performs TWO sequential bulk POSTs when both add: and remove: specs are
  present" — REPLACE/REMOVE_ALL are named only as endpoint-accepted enum values, never as
  something `jr` sends. VP-COMPONENT-012 §1.2 (~L277): "F4/F6 MUST gate shipping behind a live
  smoke test (1×ADD, 1×REMOVE, 1×REPLACE across ≥2 issues in one project…)". §5 (~L701-703):
  identical "1×ADD, 1×REMOVE, 1×REPLACE" wording. BC-3.4.023 Delivery note (~L2486): "one ADD,
  one REMOVE, one REPLACE against ≥2 issues in one project".
- **Impact:** F4/F6 cannot satisfy a "1×REPLACE" smoke-test line item without either (a)
  fabricating a REPLACE call `jr` never issues in production (testing dead code, wasted effort and
  a false sense of live-validation coverage for a path no user can reach), or (b) misreading the
  gate as license to add out-of-scope `set:`/`replace:` CLI grammar (#607 territory — explicitly
  out of scope for this bundle per DEC-280/#605). Either outcome is a real implementation-time
  cost traceable directly to this wording. The ADD+REMOVE operations `jr` does emit already fully
  exercise the load-bearing wire elements DEC-280 exists to validate (the `multiselectComponents`
  envelope, the integer `componentId` typing, the camelCase/lowercase field-name asymmetry, and
  the async bulk-task poll) — REPLACE differs from ADD/REMOVE only in the `bulkEditMultiSelectFieldOption`
  enum string, not in envelope shape, so a REPLACE-specific live call would not validate anything
  ADD doesn't already cover.
- **Proposed Fix:** Scope the live-smoke gate in VP-COMPONENT-012 (§1.2 Method text and §5
  callout) and BC-3.4.023's Delivery note to "1×ADD, 1×REMOVE across ≥2 issues in one project" —
  the operations `jr` actually generates. Add an explicit annotation at each site that
  `REPLACE`/`REMOVE_ALL` are wire-schema-completeness enum values the endpoint accepts but `jr`
  does NOT generate with any current CLI grammar, and are therefore intentionally OUT of scope for
  the jr-gated live-smoke test. Do NOT add a `replace:`/`set:` CLI grammar to close this gap — that
  is `#607` territory, explicitly out of scope for this bundle. (Architect concurrently updates the
  ADR-0018 rationale text describing this same gate.)

### LOW

#### ADV-P10-LOW-001: BC-8.1.001 "(endpoint confirmed non-paginated)" cites a research file that never discusses component-list pagination

- **Severity:** LOW
- **Category:** citation-fidelity
- **Location:** `.factory/specs/prd/bc-8-components.md` BC-8.1.001 Source field (~L49) and
  Behavior sentence "(non-paginated — the endpoint returns the full component set for the project
  in one response…)" (~L57-59)
- **Description:** BC-8.1.001's Source field cites
  `.factory/research/component-delete-and-bulk-wire-2026-08-15.md` with the parenthetical
  "(endpoint confirmed non-paginated)", and the Behavior section asserts the pagination claim as
  settled fact. The cited research file's own scope line states it covers exactly two questions —
  "Q1 — Component DELETE safety semantics" and "Q2 — multi-key bulk component-edit wire shape" —
  and a full-text scan of the file confirms it contains zero mentions of
  `GET /rest/api/3/project/{key}/components` pagination behavior (its only "paginat*" hits concern
  the unrelated `GET /rest/api/3/bulk/issues/fields` discovery endpoint and cross-cutting
  rate-limit notes, both in the Q2 bulk-wire section). Neither `.factory/phase-f1-delta-analysis/
  business-analyst-input-components.md` nor `delta-analysis-components.md`/`impact-boundary-
  components.md` establishes this pagination claim either — F1's only related citation is the
  precedent contrast to `BC-X.8.005` (`list_projects`, which IS paginated), not an independent
  confirmation of `/project/{key}/components`'s own behavior. The underlying behavioral claim is
  plausibly correct (Atlassian's `/project/{key}/components` endpoint is documented elsewhere as
  returning the full unpaginated array — components counts are typically small), but "confirmed"
  overstates what any cited source in this spec bundle actually establishes, and no wiremock
  pagination guard is specified anywhere in the VP set on the strength of this unverified claim.
- **Evidence:** `component-delete-and-bulk-wire-2026-08-15.md` header: "**Scope:** Jira Cloud REST
  API v3 — feeds `jr component delete` design (Q1) and #605 Wave 2 bulk component edit (Q2)". Full
  scan for "paginat" in that file returns only L109 (`GET /rest/api/3/bulk/issues/fields` is
  paginated), L208 (bulk-editable-fields GET pagination), L214/L217 (same, in the "Cross-cutting"
  section) — none reference `/project/{key}/components`. `bc-8-components.md` L49: "**Source**:
  F1 delta analysis §2 Impact table; `.factory/research/component-delete-and-bulk-wire-2026-08-15.md`
  (endpoint confirmed non-paginated)".
- **Impact:** Low — the behavioral claim is very likely correct and no test currently depends on
  the word "confirmed" specifically, but an implementer or F4 test-writer trusting the citation at
  face value could skip verifying non-pagination against the live endpoint or a real API response
  sample, and a future reader tracing the claim back to its cited source would find it
  unsupported.
- **Proposed Fix:** Soften BC-8.1.001's Source field and Behavior sentence to "(assumed
  non-paginated — standard `/project/{key}/components` behavior — pending F4 live verification)",
  removing the unsupported "confirmed" attribution to the Q1/Q2-scoped research file. If a real
  source establishing this (e.g. an Atlassian doc page or a first-hand F4 live-run observation) is
  identified later, re-cite that source specifically rather than reinstating "confirmed" against
  the Q1/Q2 file.

### INFO

#### ADV-P10-INFO-001: BC-8.2.007 Postcondition 5's JRACLOUD-95368 drift-abort sub-path has no named exit code/error message; prd-delta's taxonomy row only covers the propagated-error sub-path

- **Severity:** INFO
- **Category:** spec-completeness
- **Location:** `.factory/specs/prd/bc-8-components.md` BC-8.2.007 Postcondition 5 (~L1281-1313);
  `.factory/phase-f2-spec-evolution/prd-delta-components.md` Error Taxonomy table, "Snapshot JQL
  search fails before delete" row (~L172)
- **Description:** Postcondition 5's H1-fix-burst text establishes that the JRACLOUD-95368
  anti-loop-drift abort (`search_issue_keys`'s guard returning `has_more=true` with a partial
  deduped key set) is a SUCCESSFUL Rust return — not a propagated `JrError` — and states the
  command must be aborted before `DELETE` identically to a genuine fetch error. The prd-delta
  Error Taxonomy row for "Snapshot JQL search fails before delete" describes the exit code/error
  type as "`JrError::ApiError`/`JrError::NetworkError` (propagated verbatim from the read-only
  JQL search call … typically 1)" — language that only fits a genuine `Err` propagation, not a
  successful-but-partial `Ok(has_more=true)` return that `jr`'s own component-delete code must
  actively detect and convert into an abort. VP-COMPONENT-017 pins the OBSERVABLE safety property
  (`.expect(0)` on DELETE for the drift-abort fixture) but neither BC-8.2.007 nor the taxonomy
  names what specific exit code or message the drift-abort sub-path itself produces, leaving an
  implementer to invent ad hoc wording/exit-code choice for a case the taxonomy table format
  implies is already fully enumerated.
- **Evidence:** BC-8.2.007 Postcondition 5 (~L1297-1301): "`search_issue_keys`'s own
  JRACLOUD-95368 anti-loop drift guard … does NOT raise an error when it aborts pagination early —
  it sets `has_more=true` on the returned result and hands back whatever deduped keys it already
  collected, which is a SUCCESSFUL Rust return, not an `Err`." prd-delta L172: "Snapshot JQL
  search fails before delete | fail-closed, aborts before DELETE | `JrError::ApiError`/
  `JrError::NetworkError` (propagated verbatim from the read-only JQL search call … typically 1) |
  BC-8.2.007" — the row's error-type description names only the two propagated-`Err` variants.
- **Proposed Fix:** Add an explicit sub-path to BC-8.2.007 Postcondition 5 and a companion
  taxonomy row (or a split of the existing row) naming the drift-abort's synthesized error and
  exit code — e.g. exit 1 with a message on the shape of "could not reliably enumerate affected
  issues — aborting delete" (parity with the existing fetch-error row's exit-1 outcome, but
  distinguished as an application-level `JrError::UserError`-or-equivalent synthesized by
  `component delete`'s own drift-check, not a propagated `ApiError`/`NetworkError`).

#### ADV-P10-INFO-002: BC-8.1.004 title reads as unconditional exit-64 for `edit`/`delete`, though the body's numeric-ID exemption (EC-8.1.004-6..8) makes it conditional

- **Severity:** INFO
- **Category:** title-fidelity
- **Location:** `.factory/specs/prd/bc-8-components.md` BC-8.1.004 H1 (~L117)
- **Description:** The H1 — "`jr component list`/`edit`/`delete` (single-project forms) with no
  `--project` and no configured project → exit 64" — reads as an unconditional exit-64 outcome for
  all three subcommands whenever `--project`/config is absent. The body (Behavior section, ~L158-
  169) is explicit that this is conditional for `edit`/`delete`: "**except** for the NUMERIC-ID
  EXEMPTION on `edit`/`delete` described immediately below … a numeric `NAME\|ID` on `edit`/
  `delete` never needed project scoping to begin with." The body is exhaustive and internally
  correct (this is a title-simplification gap, not a body defect, consistent with the file's own
  bc_h1_is_title_source_of_truth convention requiring the H1 to accurately describe what the
  postconditions/behavior actually specify) — borderline severity, not HIGH, precisely because the
  body already disambiguates for any reader who continues past the title.
- **Evidence:** BC-8.1.004 H1 (~L117): "…with no `--project` and no configured project → exit 64"
  — no numeric-ID qualifier. Behavior (~L160-163): "`jr component list`, `jr component edit`, and
  `jr component delete` exit 64 BEFORE any HTTP call … **except** for the NUMERIC-ID EXEMPTION on
  `edit`/`delete`".
- **Proposed Fix:** Add the qualifier "(single-project forms; numeric-id edit/delete are
  exempt — see EC-8.1.004-6..8)" to the H1, per this file's own bc_h1_is_title_source_of_truth
  policy (enrichment that clarifies scope belongs in the H1, not left as index-only or body-only
  context).

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 1 |
| LOW | 1 |
| INFO | 2 |

**Overall Assessment:** pass-with-findings
**Convergence:** findings remain — iterate
**Readiness:** requires revision (test-plan scoping + citation softening + taxonomy/title
completeness only; no behavioral defect — the MEDIUM reflects an unsatisfiable acceptance
criterion in a gating test plan, not a design or wire-shape gap in `jr`'s own behavior)

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 10 |
| **New findings** | 2 (MED-1, LOW-1) |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 2 / (2 + 0) = 1.0 raw; qualitatively LOW-to-MODERATE (see prose below) |
| **Median severity** | 3.0 (MED=3, LOW=2, average of the two substantive findings) |
| **Trajectory** | P8: 1 MED + 1 LOW → P9: 1 HIGH + 1 LOW → P10: 1 MED + 1 LOW |
| **Verdict** | FINDINGS_REMAIN (all four findings trivially fixable in this same burst; no behavioral defect surfaced in nine consecutive passes now — expect CONVERGENCE_REACHED at pass 11 if this burst's fixes hold) |

MED-1 is a genuinely new finding class (test-plan/gate overspecification vs. the spec-internal
title/literal-drift class pass 8/9 found), while LOW-1/INFO-1/INFO-2 are the same "unsupported
citation" / "incomplete taxonomy row" / "title doesn't restate a body exemption" shapes seen in
prior passes, applied to new locations.

Novelty LOW-to-MODERATE — MED-1 is a fresh finding CLASS (an unsatisfiable/overspecified test-plan
line item, not a spec-internal contradiction), but severity has trended down from pass 9's HIGH
and no CRITICAL/HIGH has appeared across the last several passes. The bundle continues to
converge.
