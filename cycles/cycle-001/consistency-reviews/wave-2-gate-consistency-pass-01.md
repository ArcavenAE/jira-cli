---
document_type: consistency-review
wave: 2
pass: 01
producer: consistency-validator
date: 2026-05-08
diff_range: ab19783..ca22be0
verdict: DRIFT-FOUND
findings_count: 12
blocking: 1
drift: 7
nit: 4
---

# Consistency Review — Wave 2 Gate Pass 01

## Verdict: DRIFT-FOUND — 1 BLOCKING + 7 DRIFT + 4 NIT

The spec corpus is internally coherent on core traceability chains (BC anchors
reach BC-INDEX, holdout counts match file body, research docs are committed).
Seven structural drift items exist across four propagation boundaries
(WAVE-PLAN.md, STORY-INDEX.md, nfr-catalog.md, BC body headings). One blocking
finding (BC-X.5.005 H1 heading mis-anchors the canonical function) was
partially surfaced by the adversary (WV2-ADV-11) but not fully resolved.

Adversary-confirmed findings (not re-discovered): WV2-ADV-01, WV2-ADV-02,
WV2-ADV-03, WV2-ADV-11.

---

## Summary Table

| Category | Check | Result |
|----------|-------|--------|
| STORY-INDEX traceability | Wave 2 rows show merged status with PR/SHA | PASS |
| STORY-INDEX traceability | Wave 0/1 rows show merged status | FAIL (DRIFT) |
| STORY-INDEX BC anchors | S-2.07 BC anchors column matches frontmatter | FAIL (DRIFT) |
| STORY-INDEX count | total_stories:33 matches body rows | PASS |
| WAVE-PLAN.md | Wave 2 status is COMPLETE | FAIL (DRIFT) |
| WAVE-PLAN.md | Wave 3 includes S-3.10 (10 stories) | FAIL (DRIFT) |
| WAVE-PLAN.md | S-2.06 → S-3.10 dependency edge present | FAIL (DRIFT) |
| Holdout count | total_holdouts:51 matches H-NNN entries | PASS |
| Holdout numbering | No skips or duplicates H-001..H-047 + H-NEW-* | PASS |
| BC-INDEX body titles | BC-X.5.005 H1 matches post-S-2.06 production path | FAIL (BLOCKING) |
| BC-INDEX body titles | Other sampled BCs (BC-7.3.001/004/005, BC-6.2.013) | PASS |
| Architecture cross-cutting | line 164 reflects timeSpent passthrough | PASS |
| Risk register | R-M4 shows RESOLVED with PR/SHA | PASS |
| DEC-010 research doc | file exists and is committed (factory-artifacts 37a4be6) | PASS |
| DEC-011 research doc | file exists and is committed (factory-artifacts d1135ca) | PASS |
| CLAUDE.md links | docs/specs/json-output-shapes.md exists | PASS |
| CLAUDE.md links | docs/specs/test-naming-convention.md exists | PASS |
| CLAUDE.md links | docs/superpowers/specs/2026-04-30-embedded-oauth-app-design.md exists | PASS |
| CLAUDE.md modules | 4 S-2.05 module entries (view.rs, comments.rs, observability.rs, schemas.rs) exist | PASS |
| NFR catalog | Body rows and Summary Table updated for Wave 2 closures | FAIL (see WV2-ADV-02, adversary-confirmed) |
| STATE.md Phase 3 count | 23/31 arithmetic vs actual wave totals | FAIL (NIT) |
| STATE.md Drift Items | RESOLVED items have resolution rationale | PASS |
| STATE.md Drift Items | DEFERRED items have target story or rationale | PASS |
| STATE.md DEC-010/011 | both decisions reference committed research docs | PASS |
| Research docs committed | H-018-holdout-strategy-research.md committed (e199d17) | PASS |
| H-018 in-place rewrite | holdout-scenarios.md line 195 correctly updated | PASS |

---

## BLOCKING Findings

### WV2-CV-01 — BC-X.5.005 H1 heading names the deprecated 3-arg calculator as the canonical function

- Severity: BLOCKING
- Category: naming-drift
- Tag: `[novel]` (expands WV2-ADV-11 which asked for this check but did not perform it)

**Description**: The BC body heading in `.factory/specs/prd/cross-cutting.md:316` reads
`#### BC-X.5.005: \`parse_duration("1w2d3h30m", 8, 5)\` accepts combined units; returns total seconds`.
This H1 heading names the 3-argument calculator function (`parse_duration(s, 8, 5)`) as
the canonical subject of BC-X.5.005. Post-S-2.06 v2.0.0, the 3-arg calculator is
deprecated — the production path is `parse_duration_validate("1w2d3h30m")`. The
Behavior prose at line 321 correctly notes the dual-function situation with
"validator path is production path; calculator is deprecated". But the heading is
the anchor identifier for test naming (`test_BC_X_5_005_<description>`) and Phase 4
evaluation lookup. An evaluator reading only the heading would expect to validate
`parse_duration("1w2d3h30m", 8, 5)` — the deprecated function — not the production
validator.

The BC-INDEX.md entry (line 557) was updated with the compound description, but the
body H1 was not updated to match. This is a source-of-truth divergence between
the index description and the body heading.

**Evidence**:
- `.factory/specs/prd/cross-cutting.md:316` — H1 heading: `parse_duration("1w2d3h30m", 8, 5)` (deprecated signature)
- `.factory/specs/prd/cross-cutting.md:321` — Behavior text: `parse_duration_validate("1w2d3h30m")` is the production path
- `.factory/specs/prd/BC-INDEX.md:557` — index description updated to compound form (compound description, not stale)
- `holdout-scenarios.md:196-200` — H-018 correctly invokes `parse_duration_validate("1w2d3h30m")`
- `stories/wave-3/S-3.10-...:10-11` — frontmatter `bc_anchors: [BC-X.5.005]` referencing the BC whose heading names the deprecated function

**Impact**: S-3.10 implementer, Phase 4 evaluator, and any test author using the
heading as their anchor will find BC-X.5.005 names the deprecated function. Mis-anchors
block convergence per the agent SOUL.

**Recommendation**: Update BC-X.5.005 H1 heading in cross-cutting.md to reflect the
post-S-2.06 v2.0.0 production path:
```
#### BC-X.5.005: `parse_duration_validate("1w2d3h30m")` accepts combined units (no arithmetic); deprecated `parse_duration(s, 8, 5)` calculator retained for proptest only
```
This aligns the heading with the H-018 rewritten Expected clause and the BC-INDEX
compound description.

---

## DRIFT Findings

### WV2-CV-02 — WAVE-PLAN.md not updated: Wave 2 still shows ACTIVE and draft statuses; S-3.10 absent

- Severity: DRIFT
- Category: count-mismatch / naming-drift
- Tag: `[novel]`

**Description**: WAVE-PLAN.md (v1.3.0, last_updated 2026-05-08) has multiple
staleness issues introduced when S-3.10 was added during Wave 2:

1. **Frontmatter**: `wave_2_status: ACTIVE` — should be `COMPLETE`
2. **Wave 2 header**: `## Wave 2 — ... (7 stories) — **ACTIVE**` — should say `COMPLETE`
3. **Wave 2 story table**: all 7 stories show `draft` status with no PR numbers
4. **Wave 3 header**: `## Wave 3 — ... (9 stories)` — should say `(10 stories)`
5. **Wave 3 story table**: S-3.10 is absent (9 rows, not 10)
6. **Wave 3 parallel groups**: `{S-3.06, S-3.07, S-3.08, S-3.09}` — S-3.10 not added
7. **S-2.06 → S-3.10 dependency edge**: absent from WAVE-PLAN.md
8. The S-3.10 addition is tracked in STORY-INDEX.md (correctly) but WAVE-PLAN.md was not kept in sync

STORY-INDEX.md (v1.4.10) correctly shows Wave 3 as 10 stories, S-3.10 present,
and the dependency edge via comment. WAVE-PLAN.md is the downstream document
that should mirror this state.

**Evidence**:
- `.factory/stories/WAVE-PLAN.md:9` — `wave_2_status: ACTIVE` (stale)
- `.factory/stories/WAVE-PLAN.md:73` — `## Wave 2 — ... (7 stories) — **ACTIVE**` (stale)
- `.factory/stories/WAVE-PLAN.md:75-83` — Wave 2 table, all rows show `draft` (stale)
- `.factory/stories/WAVE-PLAN.md:91` — `## Wave 3 — ... (9 stories)` (should be 10)
- `.factory/stories/WAVE-PLAN.md:93-103` — Wave 3 table, S-3.10 absent
- `.factory/stories/STORY-INDEX.md:29` — correctly reads "Wave 3: 10 (+S-3.10 added during Wave 2)"
- `.factory/stories/STORY-INDEX.md:154` — S-3.10 row present with `depends_on: S-2.06` annotation

**Recommendation**: Update WAVE-PLAN.md:
- Set `wave_2_status: COMPLETE`
- Update Wave 2 header and all 7 story rows with `merged (#NNN)` status
- Update Wave 3 header to `(10 stories)`
- Add S-3.10 row to Wave 3 table
- Add S-3.10 to Wave 3 parallel groups (cleanup/doc group)
- Add `S-3.10 depends on S-2.06` note

This is tracked under DRIFT-003 (STORY-INDEX↔WAVE-PLAN sibling propagation gap),
a recurring process gap. S-3.06 scope should include verification of this sync.

---

### WV2-CV-03 — STORY-INDEX Wave 0 and Wave 1 rows show `draft` status (15 stories not updated)

- Severity: DRIFT
- Category: count-mismatch
- Tag: `[novel]`

**Description**: STORY-INDEX.md v1.4.10 correctly shows Wave 2 stories as
`merged (PR #NNN / SHA)`. However, all 15 Wave 0 and Wave 1 stories continue
to show `draft` status with no PR numbers or merge SHAs.

Wave 0 stories (S-0.01..S-0.07): merged via PRs #289-#294 + spec-only, 2026-05-07.
Wave 1 stories (S-1.01..S-1.08): merged via PRs #295-#302, 2026-05-07 to 2026-05-08.

STATE.md correctly describes all 15 stories as merged. The WAVE-PLAN.md Wave 0
and Wave 1 sections show them as `COMPLETE` (with merged PR numbers). Only
STORY-INDEX.md Wave 0 and Wave 1 tables are inconsistent with the actual state.

**Evidence**:
- `.factory/stories/STORY-INDEX.md:42-74` — Wave 0/1 rows all show `draft` (15 rows)
- `.factory/stories/STORY-INDEX.md:107-113` — Wave 2 rows correctly show `merged (PR #NNN / SHA)`
- `.factory/STATE.md:61` — "Wave 0 COMPLETE 7/7 via PRs #289-#294 + S-0.07 spec-only; WAVE 1 COMPLETE 8/8 via PRs #295-#302"
- `.factory/stories/WAVE-PLAN.md:56-65` — Wave 1 table shows merged PRs correctly

**Recommendation**: Update STORY-INDEX.md Wave 0 and Wave 1 tables to replace
`draft` with `merged (PR #NNN / SHA)` per the merge history in STATE.md and
WAVE-PLAN.md. Treat as companion to WV2-CV-02 — both are DRIFT-003 recurrence.

---

### WV2-CV-04 — STORY-INDEX S-2.07 row omits BC anchors from the NFR/BC Anchors column

- Severity: DRIFT
- Category: traceability
- Tag: `[novel]`

**Description**: The STORY-INDEX Wave 2 table column is labeled "NFR/BC Anchors"
and is intended to show both NFR and BC anchor IDs. For S-2.07, the column shows
only `NFR-O-F, NFR-O-J, NFR-O-W` — the three NFR anchors. The BC anchors from
the story frontmatter (`BC-7.3.004` and `BC-7.3.005`) are entirely absent from
the STORY-INDEX row.

Note: BC-7.3.004 is itself mis-anchored per WV2-ADV-01 (adversary-confirmed),
but even granting that mis-anchor, the STORY-INDEX column should reflect what
the story frontmatter declares — and it does not.

Compare S-2.06: STORY-INDEX row shows `NFR-R-C, BC-X.5.009, BC-6.2.013` —
correctly combining both NFR and BC anchors from the S-2.06 frontmatter.

**Evidence**:
- `.factory/stories/STORY-INDEX.md:113` — S-2.07 row: `NFR-O-F, NFR-O-J, NFR-O-W` (NFR-only; BC anchors absent)
- `.factory/stories/wave-2/S-2.07-json-output-policy-and-test-naming.md:10-12` — frontmatter `bc_anchors: [BC-7.3.004, BC-7.3.005]`
- `.factory/stories/STORY-INDEX.md:112` — S-2.06 row correctly shows `NFR-R-C, BC-X.5.009, BC-6.2.013`

**Recommendation**: Update S-2.07 row in STORY-INDEX to read:
`BC-7.3.004, BC-7.3.005, NFR-O-F, NFR-O-J, NFR-O-W`
(Apply Fix-PR A from adversary to fix the BC-7.3.004 mis-anchor first, then
update the index column to `BC-7.1.001, BC-7.4.013..016, NFR-O-F, NFR-O-J, NFR-O-W`
or whatever the re-anchored BCs resolve to.)

---

### WV2-CV-05 — STATE.md Phase 3 progress counter 23/31 is arithmetically inconsistent with wave totals

- Severity: DRIFT
- Category: count-mismatch
- Tag: `[novel]`

**Description**: STATE.md claims "Phase 3 progress: 23/31 (74%)" after Wave 2
completion (S-2.07 merged). The arithmetic from wave totals: Wave 0 (7) + Wave 1
(8) + Wave 2 (7) = 22 stories, not 23.

The step log within STATE.md shows a consistent off-by-one from the start of
Wave 2: the S-2.04 step row says "Phase 3: 20/31 (65%)" after the 4th Wave-2
story (expected: 7+8+4 = 19, not 20). The S-2.05 step says "Phase 3: 21/31
(68%)" after the 5th Wave-2 story (expected: 19+1 = 20). S-2.06 step: 22/31
(expected: 21). S-2.07 step: 23/31 (expected: 22). The pre-Wave-2 baseline of
16 is implied, but Wave 0 (7) + Wave 1 (8) = 15, not 16.

The discrepancy is a 1-story overcount that propagated through all Wave 2 step
entries. Its origin is unclear — possibly a counting error introduced at the Wave
1→2 transition.

**Evidence**:
- `.factory/STATE.md:61` — "Phase 3 progress: 23/31 (74%)"
- `.factory/STATE.md:74-77` — Step log: 20/31 (S-2.04), 21/31 (S-2.05), 22/31 (S-2.06), 23/31 (S-2.07)
- STORY-INDEX Wave 0: 7 stories; Wave 1: 8 stories; Wave 2: 7 stories = 22 total

**Recommendation**: Determine the origin of the overcount (most likely Wave 1
baseline was recorded as 16 instead of 15 — check WAVE-PLAN.md Wave 1 completion
entry). Correct the denominator baseline in STATE.md and update the Phase 3
progress figure to 22/31 (71%). Mark as NIT if the off-by-one does not affect
gate decisions; escalate if it causes incorrect convergence accounting.

---

### WV2-CV-06 — WAVE-PLAN.md Wave 2 table rows show stale S-2.06 effort estimate "medium" (actually "small" post-pivot)

- Severity: DRIFT
- Category: naming-drift
- Tag: `[novel]`

**Description**: The WAVE-PLAN.md Wave 2 table (line 82) shows S-2.06 with
`effort: medium`. But the STORY-INDEX.md Wave 2 table (line 112) shows S-2.06
with `Est. Effort: small`. The STORY-INDEX is the more recently updated document
(v1.4.10, last_updated 2026-05-08) and the `small` estimate reflects the v2.0.0
pivot to `timeSpent` string passthrough (which eliminated the endpoint-fetch
complexity). The WAVE-PLAN.md retains the original v1.0.0 `medium` estimate.

**Evidence**:
- `.factory/stories/WAVE-PLAN.md:82` — `S-2.06 | Worklog duration config + CMDB cache tuple | ... | draft | medium`
- `.factory/stories/STORY-INDEX.md:112` — `S-2.06 | ... | merged (PR #308 / c8f15d8) | small`

**Recommendation**: Update WAVE-PLAN.md S-2.06 row effort column to `small`
as part of the Wave 2 COMPLETE sweep (WV2-CV-02 fix).

---

### WV2-CV-07 — S-2.02 SHA in STORY-INDEX has extra zero: `75289600` vs actual `7528960`

- Severity: DRIFT
- Category: broken-link
- Tag: `[novel]`

**Description**: STORY-INDEX.md line 108 (S-2.02 row) shows
`merged (PR #304 / 75289600)` but the actual merge SHA is `7528960` (7 hex digits
as shown in the git log). `75289600` has an extra `0` appended. All other Wave 2
story SHAs in STORY-INDEX use the correct 7-digit short SHA.

**Evidence**:
- `.factory/stories/STORY-INDEX.md:108` — SHA listed as `75289600` (8 digits, extra trailing `0`)
- `git log --oneline` from current HEAD shows `7528960 test(S-2.02): add BC-3 issue-write regression holdout suite`
- STATE.md line 61 — also says `S-2.02 MERGED at 75289600` — the error propagated from STATE.md to STORY-INDEX

**Recommendation**: Correct `75289600` to `7528960` in both STORY-INDEX.md (line 108)
and STATE.md (line 61). Minor fix but broken SHA references mislead future traceability
lookups.

---

### WV2-CV-08 — NFR routing in nfr-catalog.md body rows not updated for 10 Wave-2-closed NFRs

- Severity: DRIFT
- Category: count-mismatch
- Tag: `[adversary-confirmed]`

**Description**: This finding confirms WV2-ADV-02. Spot-checking the nfr-catalog.md
body rows (not just the Summary Table) shows that the following NFRs closed by
Wave 2 stories retain their original open routing text:

- **NFR-O-L** (S-2.05): body row (line 95) still says `FIX-IN-PHASE-3` with no RESOLVED marker
- **NFR-O-M** (S-2.05): body row (line 96) still says `DOCUMENT-AS-IS` (no RESOLVED)
- **NFR-O-O** (S-2.05): body row (line 97) still says `DOCUMENT-AS-IS` (no RESOLVED)
- **NFR-O-R** (S-2.05): body row (line 112) still says `DOCUMENT-AS-IS` (no RESOLVED)
- **NFR-O-V** (S-2.05): body row (line 115) still says `DOCUMENT-AS-IS` (no RESOLVED)
- **NFR-R-F** (S-2.05): body row (line 48) still says `DOCUMENT-AS-IS` (no RESOLVED)
- **NFR-O-F** (S-2.07): body row (line 93) still says `POLICY-DECISION` (no RESOLVED)
- **NFR-O-J** (S-2.07): body row (line 94) still says `POLICY-DECISION` (no RESOLVED)
- **NFR-O-W** (S-2.07): body row (line 99) still says `POLICY-DECISION` (no RESOLVED)
- Summary Table (line 144-186): only NFR-R-C shows RESOLVED; 9 others still show original routing

The b3dd381 retroactive sweep commit touched nfr-catalog.md but updated only NFR-R-C.

**Evidence**:
- `.factory/specs/prd/nfr-catalog.md:47` — NFR-R-C correctly shows `RESOLVED 2026-05-08`
- `.factory/specs/prd/nfr-catalog.md:93-99,112,115` — 9 NFR body rows show original routing
- `.factory/specs/prd/nfr-catalog.md:144-186` — Summary Table: only NFR-R-C marked RESOLVED
- `.factory/STATE.md:61` — asserts all 11 NFRs closed by Wave 2

**Recommendation**: See WV2-ADV-02 Fix-PR B. Sweep all 10 NFR body rows and the
Summary Table. Mark each closed NFR with `RESOLVED — 2026-05-08 via S-2.05/S-2.06/S-2.07`.
Also update the Phase 3 routing summary counts (line 188-193): FIX-IN-PHASE-3 count,
POLICY-DECISION count, DOCUMENT-AS-IS count all need decrementing.

---

## NIT Findings

### WV2-CV-09 — BC-X.5.005 H1 mismatch between cross-cutting.md and BC-INDEX summary (expands WV2-ADV-11)

- Severity: NIT (secondary aspect of WV2-CV-01)
- Category: naming-drift
- Tag: `[adversary-confirmed]`

**Description**: The adversary noted (WV2-ADV-11) that H-018's BC-X.5.005 body
text vs. index summary was not verified. This review confirms: the BC-INDEX.md
summary description (line 557) was correctly updated to a compound form
("Calculator... AND validator..."). The BC body heading in cross-cutting.md
(line 316) was NOT updated. The H1 is the source-of-truth per BC-INDEX preamble
("the body files are canonical"). Both need to agree — the H1 stale text is the
primary gap (WV2-CV-01 BLOCKING); the compound index description is a partial fix.

**Evidence**: See WV2-CV-01.

**Recommendation**: Part of WV2-CV-01 fix.

---

### WV2-CV-10 — WAVE-PLAN.md wave_2_status frontmatter not toggled despite Wave 2 COMPLETE

- Severity: NIT (part of WV2-CV-02)
- Category: naming-drift
- Tag: `[novel]`

**Description**: WAVE-PLAN.md frontmatter line 9: `wave_2_status: ACTIVE` should
be `COMPLETE`. The text body says "ACTIVE" in multiple places. This is a metadata
staleness companion to WV2-CV-02.

**Evidence**:
- `.factory/stories/WAVE-PLAN.md:9` — `wave_2_status: ACTIVE`
- `.factory/stories/WAVE-PLAN.md:73` — `**ACTIVE**` in header

**Recommendation**: Flip `wave_2_status: ACTIVE` to `wave_2_status: COMPLETE` as
part of WV2-CV-02 fix.

---

### WV2-CV-11 — H-018 holdout-scenarios.md BC field still says `BC-X.5.005 (post-S-2.06 v2.0.0)` — parenthetical annotation inconsistent with compact format

- Severity: NIT
- Category: naming-drift
- Tag: `[novel]`

**Description**: H-018's header at holdout-scenarios.md line 195 now reads
`**BC**: BC-X.5.005 (post-S-2.06 v2.0.0)`. The parenthetical `(post-S-2.06 v2.0.0)`
is an annotation not present in any other H-NNN compact-format BC field.
The H-018 note block below (lines 200-202) already explains the version context,
making the parenthetical in the BC field redundant. All other H-NNN entries in
the compact format section use bare `BC-S.SS.NNN` IDs in the BC field.

**Evidence**:
- `.factory/specs/prd/holdout-scenarios.md:195` — `**BC**: BC-X.5.005 (post-S-2.06 v2.0.0)` (inconsistent format)
- `.factory/specs/prd/holdout-scenarios.md:99,110,etc.` — other compact-format BC fields use bare IDs

**Recommendation**: Trim to `**BC**: BC-X.5.005` in the BC field. The version
context is fully captured in the Note block at lines 200-202.

---

### WV2-CV-12 — STATE.md Drift Items: `S-0.05-F2` row shows `TO_VERIFY` status without resolution target

- Severity: NIT
- Category: traceability
- Tag: `[novel]`

**Description**: STATE.md Drift Items table (line 129) has a row for S-0.05-F2
with status `TO_VERIFY` and a note "Verify in next read; close if resolved." The
description says "Stale doc comment in renamed test (likely fixed in clippy-fix
commit c82832c)". This item has no target story, no explicit "no target" rationale,
and is the only DRIFT item with `TO_VERIFY` status. All other drift items in the
table show RESOLVED, DEFERRED, or a named process-gap status.

**Evidence**:
- `.factory/STATE.md:129` — `S-0.05-F2 | ... | TO_VERIFY`
- No other Drift Items row uses `TO_VERIFY` status

**Recommendation**: Either verify the fix was applied and change status to
`RESOLVED` (citing the commit), or change status to `DEFERRED` with an explicit
target story (e.g., "next S-0.06 touch" or bundle into Wave 3 cleanup). The
`TO_VERIFY` status is ambiguous — it signals incomplete follow-through.

---

## Reference Spot-Checks Performed

### BC-INDEX body vs heading checks (5 samples)

| BC | INDEX description | Body H1 | Result |
|----|------------------|---------|--------|
| BC-7.3.001 | `extract_error_message` empty-body returns literal `"<empty response body>"` | Matches | PASS |
| BC-7.3.004 | Empty `errorMessages[]` and empty `errors{}` fall through to raw body | Matches (mis-anchored per WV2-ADV-01) | PASS (heading consistent) |
| BC-7.3.005 | `--output json` + empty 4xx body → stderr JSON structured | Matches | PASS |
| BC-6.2.013 | `write_object_type_attr_cache` MERGES into existing per-type map | Matches | PASS |
| BC-X.5.005 | (see WV2-CV-01) | STALE — deprecated function name in H1 | FAIL |

### Holdout count verification

- `grep "^### H-"` returns exactly 51 entries
- Sequential H-001..H-047 = 47 entries (no gaps, no duplicates confirmed by sequential scan)
- Plus H-NEW-MP-001, H-NEW-VERBOSE-001, H-NEW-VERBOSE-002, H-NEW-AUTH-002 = 4
- Total: 51 entries = matches `total_holdouts: 51` in frontmatter

### DEC-010 / DEC-011 research doc verification

- `S-2.06-jira-timetracking-verification.md` — committed at factory-artifacts SHA 37a4be6
- `S-2.07-json-policy-and-conventions-research.md` — committed at factory-artifacts SHA d1135ca
- `H-018-holdout-strategy-research.md` — committed at factory-artifacts SHA e199d17
- All three files present on disk with non-zero size

### CLAUDE.md link integrity

- `docs/specs/json-output-shapes.md` — EXISTS
- `docs/specs/test-naming-convention.md` — EXISTS
- `docs/superpowers/specs/2026-04-30-embedded-oauth-app-design.md` — EXISTS
- `src/cli/issue/view.rs` — EXISTS (~287 LOC)
- `src/cli/issue/comments.rs` — EXISTS (~61 LOC)
- `src/observability.rs` — EXISTS (~39 LOC)
- `src/api/assets/schemas.rs` — EXISTS (~44 LOC)

### Architecture cross-cutting validation

- `cross-cutting.md:164` — NFR-R-C gap section correctly reads "RESOLVED 2026-05-08" with S-2.06 PR/SHA/DEC-010 citation
- `risk-register.md:40` — R-M4 row reads "RESOLVED 2026-05-08 — S-2.06 v2.0.0 (PR #308 / c8f15d8) via Option 1"
- Both reflect the post-b3dd381 retroactive sweep state

### STATE.md DEFERRED items with targets (5 sampled)

| Item | Target | Status |
|------|--------|--------|
| S-1.02-DEFER | "bundle into next touch; recheck quarterly via Dependabot" | PASS |
| S-1.04-DEFER-01 | "separate matrix-strategy story if cross-platform flakiness" | PASS |
| S-2.03-DOC-01 | DEFERRED 2026-05-08 | PASS (explicit DEFERRED) |
| S-2.04-DOC-01 | DEFERRED 2026-05-08 | PASS (explicit DEFERRED) |
| S-2.07-DEFER-01 | DEFERRED 2026-05-08, "no action" | PASS |

### STATE.md RESOLVED items (5 sampled)

| Item | Resolution claim | Supported by diff? |
|------|-----------------|-------------------|
| DRIFT-002 | "RESOLVED — SD-002 = Option A" | Yes — S-0.05 delivered |
| OBS-13-2 | "RESOLVED — Story Manifest table added" | Yes — STORY-INDEX v1.4.1 |
| S-0.05-DEV | "RESOLVED — SD-002 canonized" | Yes — STATE.md DEC-007 |
| S-2.06-DEFER-01 | "RESOLVED — H-018 replaced in place; S-3.10 queued" | Yes — e199d17 commit |
| S-2.02-DEFER | "RESOLVED — field name is 'changed' per json_output.rs:4-10" | Yes — DEC-011 + holdout-scenarios.md:84 update |

---

## Findings Summary

| ID | Severity | Category | Tag | Description |
|----|----------|----------|-----|-------------|
| WV2-CV-01 | BLOCKING | naming-drift | [novel] | BC-X.5.005 H1 heading names deprecated 3-arg calculator, not production `parse_duration_validate` |
| WV2-CV-02 | DRIFT | count-mismatch / naming-drift | [novel] | WAVE-PLAN.md: Wave 2 ACTIVE/draft, S-3.10 absent, Wave 3 shows 9 not 10 |
| WV2-CV-03 | DRIFT | count-mismatch | [novel] | STORY-INDEX Wave 0/1 rows show `draft` — 15 stories not updated to `merged` |
| WV2-CV-04 | DRIFT | traceability | [novel] | STORY-INDEX S-2.07 NFR/BC column omits BC-7.3.004 and BC-7.3.005 |
| WV2-CV-05 | DRIFT | count-mismatch | [novel] | STATE.md Phase 3 count 23/31 is 1 higher than arithmetic (7+8+7=22) |
| WV2-CV-06 | DRIFT | naming-drift | [novel] | WAVE-PLAN.md S-2.06 effort `medium` vs STORY-INDEX `small` (post-v2.0.0 pivot) |
| WV2-CV-07 | DRIFT | broken-link | [novel] | S-2.02 SHA `75289600` in STORY-INDEX/STATE.md has extra trailing zero (correct: `7528960`) |
| WV2-CV-08 | DRIFT | count-mismatch | [adversary-confirmed] | nfr-catalog.md body rows and Summary Table: 9 of 10 Wave-2-closed NFRs still show open routing |
| WV2-CV-09 | NIT | naming-drift | [adversary-confirmed] | BC-X.5.005 BC-INDEX summary compound but body H1 stale (expansion of WV2-ADV-11) |
| WV2-CV-10 | NIT | naming-drift | [novel] | WAVE-PLAN.md frontmatter `wave_2_status: ACTIVE` not toggled to COMPLETE |
| WV2-CV-11 | NIT | naming-drift | [novel] | H-018 BC field has `(post-S-2.06 v2.0.0)` annotation inconsistent with compact format |
| WV2-CV-12 | NIT | traceability | [novel] | STATE.md S-0.05-F2 drift item shows `TO_VERIFY` without resolution target |

---

## Top 3 Novel Findings

1. **WV2-CV-01 (BLOCKING)** — BC-X.5.005 H1 heading in cross-cutting.md names the deprecated
   3-arg `parse_duration(s, 8, 5)` calculator as the canonical function. Post-S-2.06 v2.0.0,
   the production path is `parse_duration_validate`. Mis-anchoring blocks convergence per the
   agent SOUL; Phase 4 evaluators and S-3.10 implementers will be directed to validate the
   wrong function signature.

2. **WV2-CV-02 (DRIFT)** — WAVE-PLAN.md was not updated after Wave 2 completed and S-3.10
   was added: Wave 2 still shows ACTIVE/draft, Wave 3 shows 9 stories instead of 10, S-3.10
   is absent from the Wave 3 table, and the S-2.06→S-3.10 dependency edge is not represented.
   This is the third recurrence of DRIFT-003.

3. **WV2-CV-07 (DRIFT)** — S-2.02 merge SHA has a trailing zero typo (`75289600` instead
   of `7528960`) in both STORY-INDEX.md and STATE.md. A human or tool following this SHA
   to verify merge provenance will get a git lookup failure.

---

## Adversary-Confirmed Findings

| Adversary ID | CV ID | Notes |
|-------------|-------|-------|
| WV2-ADV-01 | (not re-discovered; WV2-CV-04 is a STORY-INDEX propagation of the same error) | BC-7.3.004 mis-anchor confirmed |
| WV2-ADV-02 | WV2-CV-08 | Confirmed: 9 of 10 NFR body rows + Summary Table rows still show open routing |
| WV2-ADV-03 | (not re-discovered) | BC-6.2.013 mis-anchor confirmed |
| WV2-ADV-11 | WV2-CV-01, WV2-CV-09 | Body text vs index check performed; H1 heading staleness is BLOCKING |

---

## Gate Decision

The wave spec corpus is consistent on core chains (holdout counts, research docs
committed, architecture sections updated, CLAUDE.md links resolve). The 1 BLOCKING
finding (WV2-CV-01) must be fixed before convergence. The 7 DRIFT findings are
structural maintenance items; all have clear remediation paths and do not represent
correctness gaps in the implementation. The 4 NIT findings are low-impact cosmetic issues.

**Recommend**: Fix WV2-CV-01 in the same Fix-PR A that addresses WV2-ADV-01 and
WV2-ADV-03 (the mis-anchor sweep). Fix WV2-CV-08 in Fix-PR B (NFR catalog sweep).
Bundle WV2-CV-02/03/06/07/10 into a single doc-sweep PR. WV2-CV-04/05/11/12 can
be deferred to Wave 3 cleanup story S-3.06.
