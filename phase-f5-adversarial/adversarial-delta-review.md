---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-31T00:00:00
phase: 5
inputs: []
input-hash: "[live-state]"
traces_to: prd.md
pass: 1
previous_review: null
---

# Adversarial Review: field-dx (Pass 1)

## Scope

Primary-adversary review of the integrated delta across all 5 field-dx
bundle stories, reviewed as a single unified change rather than 5
independent per-story diffs. Delta range: `91d04fe1..ae8514b8` on
`develop`.

| Story | PR | Merge SHA |
|-------|----|-----------|
| S-578-1 | #739 | `993de833` |
| S-580-1 | #740 | `74221bbc` |
| S-578-2 | #741 | `a3739763` |
| S-578-3 | #742 | `41763ff0` |
| S-578-4 | #746 | `ae8514b8` |

Each story already passed its own per-story adversarial convergence,
security review, and pr-reviewer gate during F4 delivery. This F5 pass
specifically targets INTEGRATION seams introduced by combining all 5
stories' changes into one delta — cross-story field-resolution reuse,
shared helper duplication, and convention drift across the bundle —
rather than re-litigating already-converged per-story findings. No
`current-cycle` file is set for this project, so finding IDs use the
no-cycle fallback form `ADV-P<PASS>-<SEV>-<SEQ>`.

## Finding ID Convention

Finding IDs use the format: `ADV-P<PASS>-<SEV>-<SEQ>`

- `ADV`: Fixed prefix identifying adversarial findings
- `<PASS>`: Two-digit pass number (`P01` for this review)
- `<SEV>`: Severity abbreviation (`CRIT`, `HIGH`, `MED`, `LOW`)
- `<SEQ>`: Three-digit sequence within the pass

No `current-cycle` file exists for this project, so the cycle segment is
omitted per the template's fallback rule.

## Part A — Fix Verification (pass >= 2 only)

N/A — this is pass 1 of the F5 scoped-adversarial review for the field-dx
integrated delta. No prior F5-scope review exists to verify fixes against.

## Part B — New Findings (pass 1, all findings)

### CRITICAL

None.

### HIGH

None.

### MEDIUM

#### ADV-P01-MED-001: `get_issue_types_for_project` missing termination safeguards its twin gained this cycle

- **Severity:** MEDIUM
- **Category:** missing-edge-cases
- **Location:** `src/api/jira/issues.rs::get_issue_types_for_project`
- **Description:** `src/api/jira/issues.rs::get_createmeta_fields` (added/
  hardened this cycle) gained two termination safeguards that
  `get_issue_types_for_project` lacks: (a) a MAX page-count bound
  (CWE-400 unbounded-loop protection), and (b) the `total`-absent
  full-page heuristic: `if total > 0 { start_at + page_len >= total }
  else { page_len < page_size }`.
- **Evidence:** `CreatemetaIssueTypesResponse.total` is `#[serde(default)]`,
  so when the field is omitted from the API response it defaults to `0`.
  Under `get_issue_types_for_project`'s current termination check, this
  produces `200 >= 0 → true` on the first page regardless of how many
  issue types actually exist — silent truncation to page 1. This
  undermines VP-578-020's "issue-types page ≥2" guarantee specifically
  in the total-absent response-shape branch. A project with more issue
  types than one page returns would silently report only the first
  page's worth to every caller (name→id resolution in S-331's bulk
  `--type` path, S-578-4's platform `--field` issue-type resolution,
  etc.) with no error, warning, or truncation signal. Likelihood is LOW
  in practice — real Jira Cloud responses include `total`, and >200
  issue types on one project is rare — hence MEDIUM rather than HIGH
  severity.
- **Proposed Fix:** Mirror `get_createmeta_fields`'s heuristic and page
  bound onto `get_issue_types_for_project`. Being delivered as
  **FIX-F5-001** (branch `fix/F5-001-issuetypes-pagination`).

### LOW

#### ADV-P01-LOW-001: `:asset` malformed-shape validation duplicated byte-for-byte

- **Severity:** LOW
- **Category:** code-quality
- **Location:** `src/cli/issue/jsm_create.rs::resolve_asset_field_l2`
  (JSM path) and `src/cli/issue/field_resolve.rs::compose_asset_hint`
  (platform path)
- **Description:** Both functions implement the identical 5-branch
  malformed-shape parser for `:asset` hint values.
- **Evidence:** Byte-for-byte duplicated validation logic across the two
  files.
- **Proposed Fix:** Already tracked — see Disposition below. No new
  tracked-debt id opened; cross-referencing the existing one.

#### ADV-P01-LOW-002: edit-path Gate B not refactored onto shared `detect_flag_field_overlap`

- **Severity:** LOW
- **Category:** code-quality
- **Location:** `src/cli/issue/edit.rs:155-193` ("Gate B")
- **Description:** Implements its own flag/field-overlap detection
  rather than the shared `detect_flag_field_overlap` helper that
  ADR-0019 §D2 envisioned as the single collision-detection entry
  point. Only `create.rs` is wired to the shared helper; `edit.rs` was
  documented as deliberately out-of-scope for S-578-4.
- **Evidence:** Behavior is correct — error strings are consistent
  between the two paths — but the duplication is a maintenance
  liability if the collision rules diverge in a future change to one
  path without the other.
- **Proposed Fix:** Refactor `edit.rs` Gate B onto the shared helper in
  a future story. Tracked as `F5-EDIT-GATEB-SHARE`.

#### ADV-P01-LOW-003: divergent case-folding for issue-type name→id resolution

- **Severity:** LOW
- **Category:** ambiguous-language
- **Location:** `src/cli/issue/field_resolve.rs::resolve_against_createmeta`
  (`eq_ignore_ascii_case`, ASCII-only) vs. `src/cli/field.rs`
  (`to_lowercase()`, full Unicode)
- **Description:** Both functions consume the same
  `get_issue_types_for_project` API call and both perform name→id
  matching against the returned issue-type list, but fold case
  differently.
- **Evidence:** Negligible in practice — Jira issue-type names are
  near-always ASCII — but the two call sites will disagree on a
  non-ASCII issue-type name with case variants (e.g. a Turkish
  dotless-I or German eszett/ß case-fold edge case).
- **Proposed Fix:** Unify on one case-folding strategy in a future pass.
  Tracked as `F5-ISSUETYPE-CASEFOLD-SPLIT`.

#### ADV-P01-LOW-004: weak assertion in negative-pin display-name spelling test

- **Severity:** LOW
- **Category:** coverage-gap
- **Location:** `tests/issue_create_field.rs::test_vp_578_021_negative_pin_display_name_spelling_does_not_trip_guard`
- **Description:** Asserts only `!requests.is_empty()` — does not
  assert exit code 0, does not inspect the POST body, and does not
  assert last-wins residual behavior when the same field is supplied
  via both a display-name spelling and a canonical spelling.
- **Evidence:** The test can pass even if the guard's actual VP-578-021
  contract (exit-0, correct residual field value sent) silently
  regresses, as long as at least one HTTP request is recorded.
- **Proposed Fix:** Strengthen the assertion to check exit code, POST
  body, and last-wins field value. Tracked as `F5-VP578021-WEAK-NEGPIN`.

## Observations (non-defects, for the record)

- JSM `:option` hint kind is a plain string-wrap with no `allowedValues`
  resolution or cascading-select support. This is documented as
  VP-578-016 parity-PENDING, not a regression — noted here for
  traceability into the F5 record.
- `field_resolve.rs::compose_asset_wire` panics on a colon-less value.
  This is an unreachable internal invariant in practice: the L2
  qualifier path always prefixes a colon-bearing shape before
  `compose_asset_wire` is invoked, so no caller can currently reach the
  panic branch. Flagged for awareness, not classified as a finding.

## Disposition Summary

| Finding | Severity | Disposition |
|---------|----------|--------------|
| ADV-P01-MED-001 (`get_issue_types_for_project` pagination termination gap) | MEDIUM | FIX-F5-001 (in progress) |
| ADV-P01-LOW-001 (`:asset` validator duplication) | LOW | Cross-ref `S-578-3-SHARED-ASSET-VALIDATOR` (no new id) |
| ADV-P01-LOW-002 (edit-path Gate B not on shared overlap helper) | LOW | `F5-EDIT-GATEB-SHARE` (new, tracked) |
| ADV-P01-LOW-003 (issue-type case-folding split) | LOW | `F5-ISSUETYPE-CASEFOLD-SPLIT` (new, tracked) |
| ADV-P01-LOW-004 (weak negative-pin test assertion) | LOW | `F5-VP578021-WEAK-NEGPIN` (new, tracked) |

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 1 |
| LOW | 4 |

**Overall Assessment:** pass-with-findings
**Convergence:** CONVERGENCE_REACHED
**Readiness:** ready for next phase (F6), pending FIX-F5-001 landing

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 1 |
| **New findings** | 5 |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 1.0 (5/5) |
| **Median severity** | 2.0 (LOW=2, MEDIUM=3; median of [3,2,2,2,2] = 2.0) |
| **Trajectory** | 5 (pass 1, single-pass scoped delta review — no CRITICAL/HIGH, converged on first pass) |
| **Verdict** | CONVERGENCE_REACHED |

<!--
  This is pass 1 of a scoped (not full multi-pass) F5 adversarial review.
  Novelty is necessarily 1.0 for pass 1 by definition (all findings are new).
  Convergence is declared on pass 1 because zero CRITICAL/HIGH findings were
  found against the integrated delta, and the 5 findings surfaced (1 MEDIUM,
  4 LOW) are all either already being fixed (FIX-F5-001) or tracked as
  non-blocking debt — no further adversarial iteration is required before
  proceeding to F6.
-->
