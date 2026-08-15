---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-15T00:00:00
phase: f2
inputs: [.factory/specs/prd/bc-3-issue-write.md, .factory/specs/prd/bc-8-components.md, .factory/specs/prd/bc-2-issue-read.md, .factory/phase-f2-spec-evolution/prd-delta-components.md, .factory/specs/prd/BC-INDEX.md, .factory/phase-f2-spec-evolution/verification-delta-components.md, .factory/specs/architecture/decisions/ADR-0018-component-resolution-caching-mutation-strategy.md]
input-hash: "b98832e"
traces_to: .factory/phase-f2-spec-evolution/prd-delta-components.md
pass: 12
previous_review: .factory/phase-f2-spec-evolution/adversarial-spec-delta-review-components-p11.md
---

# Adversarial Review: Component Management Bundle (Pass 12)

Adversarial Spec-Delta Review — Component Management (F2, pass 12). VERDICT: NOT CLEAN. 0 CRIT,
1 HIGH, 0 MEDIUM, 0 LOW, 2 INFO. (Derivative-doc tail CONFIRMED CLOSED — INFO-1 verified all
P10/P11 re-sync items consistent.)

## Part B — New Findings

### HIGH

#### P12-HIGH-1: `--label` conflict-block flag count is self-contradictory — BC-3.4.020/BC-3.4.022 say 13, EC-3.4.017-14 (the completeness enforcer) still says 12

- **Severity:** HIGH
- **Category:** spec-fidelity / count-consistency (sibling-BC propagation lag)
- **Location:** `.factory/specs/prd/bc-3-issue-write.md` — BC-3.4.020 Precondition 3 (~L2118, "12 →
  13 flags … all 13 flags"), corroborated by BC-3.4.022 Precondition 3 (~L2415, "updated 13-flag
  list") vs. EC-3.4.017-14 (~L1935, "Of the 12 fields currently in scope"; ~L1941, "caught by the
  R2 pin's 12-flag enumeration"; ~L1948-1952, R2 pin "assert extracted set has exactly 12 members
  … [12-flag list, no `--component`]"; ~L1953-1957, "**Co-author**: 10 positive regression tests
  … [list of 10, no `--component` test]") and VP-COMPONENT-027 prose (~L2183, "general 12-flag
  `test_label_conflict_block_lists_every_relevant_flag` meta-test").
- **Description:** The delta added `--component` to the `--label` mutual-exclusion conflict block
  (BC-3.4.020 Precondition 3), correctly stating the block now has 13 members (verified: the
  Precondition 3 list — `--summary`, `--priority`, `--type`, `--team`, `--points`,
  `--no-points`, `--parent`, `--no-parent`, `--description`, `--description-stdin`, `--markdown`,
  `--field`, `--component` — is 13 items). BC-3.4.022 Precondition 3 corroborates, citing "BC-
  3.4.020 Precondition 3's updated 13-flag list." But EC-3.4.017-14 — the spec of the mechanical
  completeness enforcer `test_label_conflict_block_lists_every_relevant_flag` referenced by name
  from BC-3.4.020 Precondition 3 itself — was never propagated and still describes and pins a
  12-member block: "Of the 12 fields currently in scope" (enumerating 11 fields plus `issue_type`,
  no `--component`), "the R2 pin's 12-flag enumeration," an R2 pin instructing "assert extracted
  set has exactly 12 members for the current block" followed by a 12-item flag list with no
  `--component`, and a "Co-author" note calling for "10 positive regression tests" enumerating 10
  flags with no `--component` case. VP-COMPONENT-027's own prose (~L2183) independently repeats
  the stale count, calling EC-3.4.017-14's enforcer the "general 12-flag … meta-test."
- **Rationale for HIGH:** `--component` has a bulk path (BC-3.4.023), making it `BULK_SUPPORTED`;
  BC-3.4.017 Invariant 2's exhaustive partition (`(BULK_SUPPORTED \ {"label"}) ∪ REJECTED_IN_BULK`,
  the formula EC-3.4.017-14 itself specifies for deriving the block's expected set) therefore
  yields an expected set of 13, and the block correctly pushes 13 `conflicting.push` lines per
  BC-3.4.020. EC-3.4.017-14's "exactly 12 members for the current block" is UNSATISFIABLE against
  BC-3.4.020's required 13-member block: an implementer building
  `test_label_conflict_block_lists_every_relevant_flag` from EC-3.4.017-14's spec text pins 12,
  the real extractor returns 13, `cargo test` fails at the R2 pin — and the implementer's two
  choices are either to revert `--component` from the conflict block (reintroducing the exact
  FIX-F5-001 silent-data-loss footgun BC-3.4.020 Precondition 3's own rationale says the block
  exists to prevent) or to silently override the spec's stated count without a spec update. Blast
  radius spans 2 BCs (BC-3.4.020, BC-3.4.022) plus one VP (VP-COMPONENT-027) in the same file →
  HIGH, not MEDIUM.
- **Evidence:**
  - bc-3-issue-write.md L2118 (BC-3.4.020 Precondition 3): "**[UPDATED 2026-08-15 issue #605 F2]
    `--component` added — 12 → 13 flags**" … "the `--label` conflict block is a separate
    earlier-return covering all 13 flags at any key count."
  - bc-3-issue-write.md L2412-2415 (BC-3.4.022 Precondition 3): "see BC-3.4.020 Precondition 3's
    updated 13-flag list."
  - bc-3-issue-write.md L1935 (EC-3.4.017-14): "Of the 12 fields currently in scope."
  - bc-3-issue-write.md L1941: "be caught by the R2 pin's 12-flag enumeration."
  - bc-3-issue-write.md L1947-1952 (R2 pin): "assert extracted set has exactly 12 members for the
    current block: `--field`, `--summary`, `--priority`, `--type`, `--team`, `--points`,
    `--no-points`, `--parent`, `--no-parent`, `--description`, `--description-stdin`,
    `--markdown`." (12 items, no `--component`.)
  - bc-3-issue-write.md L1953-1957 ("Co-author"): "10 positive regression tests in
    `tests/issue_edit_field.rs` … for each of: `priority`, `type`, `team`, `points`, `no-points`,
    `parent`, `no-parent`, `description`, `description-stdin`, `markdown`." (10 flags, no
    `--component`.)
  - bc-3-issue-write.md L2182-2184 (VP-COMPONENT-027 prose): "the general 12-flag
    `test_label_conflict_block_lists_every_relevant_flag` meta-test's set-membership check."
- **Impact:** A test-writer/implementer following EC-3.4.017-14 literally either fails
  `cargo test` on the R2 pin's own asserted count, or silently drops `--component` from the block
  to make the pin's stated 12-count true — the latter reintroduces the FIX-F5-001 silent
  data-loss hazard (`--label add:foo --component add:bar` would route through
  `handle_edit_bulk_labels`, which does not accept a `components` payload, dropping the write with
  exit 0). Also blocks VP-COMPONENT-027's own co-author test pattern citation, since the meta-test
  it cites is itself internally inconsistent about the count it enforces.
- **Novelty:** genuinely new — pass 10/11 focused on the new BC-8.*/BC-3.4.022-025 bodies and the
  Gate B 4→5 field extension; neither pass inspected EC-3.4.017-14's separately-numbered `--label`
  conflict-block enforcer spec, which lives inside the *sibling* BC-3.4.017 rather than
  BC-3.4.020/022 where the `--component`-affecting edits landed. Partial-fix/count-drift class,
  same root-cause family as pass-10/11's derivative-doc lag findings, but this time the lag is
  BC-to-sibling-BC within the SAME authoritative file, not BC-to-derivative-doc.
- **Proposed Fix:**
  1. L1935: "Of the 12 fields currently in scope" → "Of the 13 fields currently in scope."
  2. L1941: "the R2 pin's 12-flag enumeration" → "the R2 pin's 13-flag enumeration."
  3. L1947-1952: "exactly 12 members for the current block: `--field`, `--summary`, `--priority`,
     `--type`, `--team`, `--points`, `--no-points`, `--parent`, `--no-parent`, `--description`,
     `--description-stdin`, `--markdown`." → "exactly 13 members for the current block: `--field`,
     `--summary`, `--priority`, `--type`, `--team`, `--points`, `--no-points`, `--parent`,
     `--no-parent`, `--description`, `--description-stdin`, `--markdown`, `--component`."
  4. L1953-1957: "10 positive regression tests … for each of: `priority`, `type`, `team`,
     `points`, `no-points`, `parent`, `no-parent`, `description`, `description-stdin`,
     `markdown`." → "11 positive regression tests … for each of: `priority`, `type`, `team`,
     `points`, `no-points`, `parent`, `no-parent`, `description`, `description-stdin`, `markdown`,
     `component`."
  5. L2183: "general 12-flag `test_label_conflict_block_lists_every_relevant_flag` meta-test" →
     "general 13-flag `test_label_conflict_block_lists_every_relevant_flag` meta-test."
  6. Check BC-3.4.017 Invariant 2's `test_343_every_edit_field_is_categorized` note (the
     `--field`-inclusion sentence) for an equivalent `--component`/`components` gap — verified
     during this pass's fix-burst: that invariant text does not itself enumerate
     `BULK_SUPPORTED`/`REJECTED_IN_BULK` membership (it only requires `--field`'s categorization,
     historical to #396), so no numeric drift exists there; no change needed.

## Sweep Findings (targeted count/enumeration consistency pass)

Per the task's Step 2, swept `bc-3-issue-write.md` (plus the component BCs in `bc-8-components.md`
and `bc-2-issue-read.md`) for every numeric flag-count/field-count/enumeration-length claim
touched by the `--component` additions.

- **(a) Gate B field count (BC-3.4.017), "4→5 fields":** VERIFIED CONSISTENT. "Scope of Gate B"
  (~L1793) enumerates exactly 5: `summary`, `description`, `issuetype`, `priority`, `components`.
  Preconditions for Gate B error (~L1810-1813) and Invariant 4 (~L1851-1858) both correctly
  enumerate the same 5-member set. No drift.
- **(b) `--label` conflict block, 13 everywhere:** RESOLVED by P12-HIGH-1's fix above (was the
  finding itself). No residual "12" remains after the fix.
- **(c) BC-2.1.006 filter-source count "13→14" (bc-2-issue-read.md):** VERIFIED CONSISTENT. The
  literal stderr enumeration (~L123) lists 14 members counted end-to-end: `--project`,
  `--assignee`, `--reporter`, `--status`, `--open`, `--team`, `--recent`, `--created-after`,
  `--created-before`, `--updated-after`, `--updated-before`, `--asset`, `--component`, `--jql` =
  14. Title ("listing all 14 filter sources") and the "13 → 14" UPDATED note both match. No drift.
- **(d) Sweep of all other "N flags"/"N fields"/"N members"/"N tests"/"N sources" phrasing in
  bc-3-issue-write.md, bc-8-components.md, bc-2-issue-read.md touching `--component`/`components`:**
  found ONE additional drift item beyond P12-HIGH-1, promoted to INFO-3 below (a stale
  4-member enumeration with no explicit count number, so it did not match the numeric-phrasing
  grep pattern used for (a)-(c), but is the same enumeration-completeness class the task asked
  the sweep to catch).

### INFO

#### P12-INFO-3 (sweep finding): EC-3.4.017-11's illustrative "canonical system field keys" enumeration is a stale 4-member list, missing `components`

- **Severity:** INFO
- **Category:** enumeration-consistency (illustrative prose, not a pinned test count)
- **Location:** `.factory/specs/prd/bc-3-issue-write.md` EC-3.4.017-11 (~L1895-1898)
- **Description:** EC-3.4.017-11 explains why `--field type=Bug` does NOT trigger Gate B: "The
  Gate B comparison checks whether the `--field NAME` key, lowercased, matches the canonical
  system field keys `summary`, `description`, `issuetype`, `priority`." This is the same
  4-member enumeration Gate B's own "Scope" paragraph (~L1793) and Invariant 4 (~L1852) were both
  correctly updated to 5-member (`summary`, `description`, `issuetype`, `priority`, `components`)
  when Gate B's scope was extended 2026-08-15. EC-3.4.017-11 was not swept in that same edit and
  still names only the original four keys.
- **Impact:** Low — EC-3.4.017-11's substantive point (that `type` ≠ `issuetype`) is unaffected
  by the omission, and no test count or assertion depends on this specific enumeration (unlike
  EC-3.4.017-14's R2 pin, which is why this is INFO not HIGH). But it is a genuine residual
  inconsistency a careful reader would notice immediately after reading the corrected "Scope of
  Gate B" paragraph two sections earlier.
- **Proposed Fix:** Append `, components` to the enumeration at L1897: "...matches the canonical
  system field keys `summary`, `description`, `issuetype`, `priority`, `components`."

#### P12-INFO-4: `test_343_every_edit_field_is_categorized` `--component` coverage was checked per the task's explicit ask — no drift found

- **Severity:** INFO
- **Category:** verification (negative finding, recorded for audit trail)
- **Location:** `.factory/specs/prd/bc-3-issue-write.md` BC-3.4.017 Invariant 2 (~L1842-1848)
- **Description:** The task asked to verify BC-3.4.017 Invariant 2's `test_343_...` note includes
  `--component`/`components` "companion to the '--field' note." Invariant 2's text only mandates
  that `--field` be categorized into exactly one of `SELECTORS`/`BULK_SUPPORTED`/
  `REJECTED_IN_BULK` (historical to issue #396, predates the component bundle) — it does not
  itself enumerate current set membership, so there is no stale count to correct here. EC-3.4.017-
  14's own R2-pin formula (`(BULK_SUPPORTED \ {"label"}) ∪ REJECTED_IN_BULK`, ~L1933) is the
  actual mechanism by which `--component`'s `BULK_SUPPORTED` status (per BC-3.4.023's bulk path)
  flows into the conflict block's expected set — fixed as part of P12-HIGH-1 above. No separate
  change needed to Invariant 2's text.
- **Proposed Fix:** None — recorded as a checked-clean item.

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 1 |
| MEDIUM | 0 |
| LOW | 0 |
| INFO | 2 |

**Overall Assessment:** pass-with-findings
**Convergence:** findings remain — iterate (fixed in the same burst that produced this review,
including the sweep-driven INFO-3 fix)
**Readiness:** requires revision (single HIGH, count-consistency only — no new wire-shape/
resolver-mechanism defect; fixed in this burst)

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 12 |
| **New findings** | 3 (HIGH-1, INFO-3, INFO-4) |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 3 / (3 + 0) = 1.0 by location; qualitatively MODERATE by class (first HIGH
  since pass 9; a genuinely new sibling-BC count-drift shape distinct from pass 10/11's
  derivative-doc-lag class) |
| **Trajectory** | P10: 1 MED + 1 LOW → P11: 1 MED + 2 LOW → P12: 1 HIGH + 0 MED/LOW |
| **Verdict** | FINDINGS_REMAIN; fixed in this burst. Expect convergence at pass 13 if the fix
  holds and the sweep found no further drift beyond INFO-3 (which was also fixed in this burst). |
