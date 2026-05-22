---
document_type: consistency-audit
issue: "#396"
title: "Cross-document consistency audit — F2 spec delta for issue #396 (issue edit --field NAME=VALUE)"
date: "2026-05-22"
auditor: consistency-validator
phase: F2
gate: human-approval
---

# Consistency Audit — Issue #396: `issue edit --field NAME=VALUE`

Fresh-context audit of the F2 spec delta before the human approval gate.
Audited documents: `bc-3-issue-write.md`, `BC-INDEX.md`, `CANONICAL-COUNTS.md`,
`prd-delta-396.md`, `verification-delta-396.md`, `delta-analysis.md`.

---

## Guard Script Results

| Script | Exit Code | Result |
|--------|-----------|--------|
| `scripts/check-spec-counts.sh` | **0** | PASS — all definitional_count frontmatter values match actual `#### BC-` heading counts |
| `scripts/check-bc-cumulative-counts.sh` | **0** | PASS — all 8 count surfaces agree (583 total; Surface H footer verified) |

---

## Check 1: Count-Surface Consistency

**All 9 scripted surfaces: CONSISTENT.**

| Surface | Claimed Value | Actual / Status |
|---------|---------------|-----------------|
| bc-3 frontmatter `total_bcs` | 103 | Matches CANONICAL-COUNTS.md row |
| bc-3 frontmatter `definitional_count` | 74 | Matches actual `#### BC-` count (confirmed by script) |
| bc-3 body preamble | "103 behavioral contracts" | Present at line 64 |
| BC-INDEX.md `total_bcs` frontmatter | 583 | Correct (+3 vs prior 580) |
| BC-INDEX.md Section 3 header | "103 BCs cumulative; 74 individually-bodied" | Line 215 — correct |
| BC-INDEX.md Section 3.4 header | "17 BCs: BC-3.4.001..017" | Line 262 — correct |
| BC-INDEX.md Coverage Statistics table Section 3 row | 103 / 74 | Line 692 — correct |
| BC-INDEX.md Coverage Statistics table Total row | 583 / 351 | Line 698 — correct |
| CANONICAL-COUNTS.md bc-3 definitional | 74 | Line 23 — correct |
| CANONICAL-COUNTS.md bc-3 total_bcs | 103 | Line 44 — correct |
| CANONICAL-COUNTS.md Sum row | 583 | Line 51 — correct |
| CANONICAL-COUNTS.md individually-bodied total | 351 | Correct (351 = 348 + 3) |
| CANONICAL-COUNTS.md grand total | 583 | Correct |
| bc-3 end-of-file footer (Surface H) | "74 individually-bodied (cumulative 103 ...)" | Present — script-verified |
| bc-3 `_Last updated_` prose | "2026-05-22 (issue #396 F2): +3 BCs (BC-3.4.015..017)" | Present at line 2140 |
| BC-INDEX.md `last_updated` | 2026-05-22 | Correct (fixed in adversary pass 7) |
| BC-INDEX.md frontmatter comment | "+3 added 2026-05-22 (BC-3.4.015..017, issue #396 F2)" | Present |

**VP tri-surface invariant:** 12 VPs (VP-396-001..012) are declared in `verification-delta-396.md` frontmatter `new_vps` list. All 12 unique VP IDs (VP-396-001 through VP-396-012) appear in `bc-3-issue-write.md` as one-liner `**Verification Properties**` subsections within the relevant BC bodies. VPs do not affect BC count surfaces — confirmed consistent.

**Unguarded surfaces acknowledged in spec (not new findings):**
The BC-INDEX Coverage Statistics body table (9th surface), the `_Last updated_` prose line, and the BC-INDEX frontmatter comment are documented as manually-maintained surfaces not validated by either guard script (process-gap O-5 per adversary pass 6, P3-MED-002). Visual inspection above confirms all three are correct for this delta.

---

## Check 2: Cross-References — Dangling or Missing

### 2a. New BCs citing existing artifacts — verified VALID

| Reference in new BCs | Target exists? |
|----------------------|---------------|
| BC-3.4.015 cites BC-3.8.008 (parse_field_kv bypass) | YES — BC-3.8.008 exists at line 1759 |
| BC-3.4.015 cites BC-3.4.012 (table-mode echo) | YES — BC-3.4.012 exists |
| BC-3.4.015 cites BC-3.4.013 (JSON-mode echo) | YES — BC-3.4.013 exists |
| BC-3.4.015 cites BC-3.4.017 Gate A/B (preconditions) | YES — BC-3.4.017 follows at line 1386 |
| BC-3.4.015 invariant 4 cites BC-3.4.012 invariant 6 | YES — BC-3.4.012 invariant 6 exists |
| BC-3.4.016 cites BC-3.4.015 (base steps) | YES — bidirectional within same file |
| BC-3.4.017 cites BC-3.4.003 (single-match --jql fast path) | YES — BC-3.4.003 exists |
| BC-3.4.015 VP-396-001..012 | YES — all 12 confirmed present in bc-3-issue-write.md |
| verification-delta-396.md §related_bcs | BC-3.4.015/016/017 all exist |
| prd-delta-396.md inputs reference delta-analysis.md | File exists |
| prd-delta-396.md inputs reference issue-396-jsm-fields-validation.md | File exists under .factory/research/ |

### 2b. Existing BCs that should reference new BCs — FINDING

**BC-3.4.003 (issue edit PUT wire contract) does NOT reference BC-3.4.015/016/017.**

BC-3.4.003 was updated for issues #388 (BC-3.4.010/011) and #398 (BC-3.4.012/013) with inline cross-references. The pattern established by those updates is: when new BCs extend the `issue edit` single-key path, BC-3.4.003 receives an annotation noting the cross-reference.

The issue #396 F2 delta did NOT add an analogous annotation to BC-3.4.003 for BC-3.4.015/016/017. The frontier between BC-3.4.003 (wire contract) and BC-3.4.015/016 (--field extension, also on the same PUT path) is semantically similar to the frontier between BC-3.4.003 and BC-3.4.012/013 (success echo).

**Severity assessment: LOW.** BC-3.4.003 describes the ADF-description PUT wire contract specifically. BC-3.4.015/016 add new flag behavior on the same path but are anchored at a different abstraction layer (field resolution, not the wire description encoding). Unlike BC-3.4.012/013 (which govern what happens to the response) or BC-3.4.010/011 (which govern what happens on PUT 400), BC-3.4.015/016 describe an input-extension path that already forwards to the same PUT. The missing cross-reference is a navigation aid, not a contract gap. An implementer following BC-3.4.003 alone can correctly implement the unchanged ADF path; BC-3.4.015 is the authoritative contract for the --field extension. This is a documentation polish gap, not a behavioral inconsistency.

### 2c. BC-3.8.012 scope — correct and does NOT need updating

BC-3.8.012 governs `--field` on the `issue create` platform path (warning + drop). It explicitly scopes itself to `jr issue create` WITHOUT `--request-type`. The new feature is on `jr issue edit`. BC-3.8.012 correctly does NOT cover `issue edit --field` and should not be updated — the two are orthogonal.

### 2d. Verification-delta VP placement vs body BCs — CONSISTENT

The `verification-delta-396.md` "Project Convention Note" maps each VP to its permanent home in the BC body:
- VP-396-001, 003, 004, 006, 007, 008, 009, 010, 011, 012 → BC-3.4.015 `**Verification Properties**`
- VP-396-002 → BC-3.4.016 `**Verification Properties**`
- VP-396-005 and 008 → BC-3.4.017 `**Verification Properties**`

Verified by grep: all 12 IDs are present in bc-3-issue-write.md at the correct BC anchors.

---

## Check 3: Naming and Taxonomy Consistency

### 3a. BC ID numbering — CONSISTENT

BC-3.4.015, 016, 017 follow monotonically after the previously-added BC-3.4.014 (issue #398). No gaps, no collisions, no reuse.

### 3b. EC numbering — CONSISTENT

BC-3.4.015: EC-3.4.015-1 through -20 (including -4a, -12a). Monotonic; the sub-variants (-4a, -12a) follow the project convention used in other BCs (e.g., BC-3.4.013 has EC-3.4.013-13). No gaps.

BC-3.4.016: EC-3.4.016-1 through -7. Monotonic.

BC-3.4.017: EC-3.4.017-1 through -12. Monotonic. The reordering from adversary pass 2 (P2-003) confirmed numeric sequence — 9, 10, 11, 12 appear in order.

### 3c. VP ID numbering — CONSISTENT

VP-396-001 through VP-396-012. Monotonic. No gaps. Count matches frontmatter `new_vps` list in verification-delta-396.md.

### 3d. Test name conventions — CONSISTENT

All suggested test names in verification-delta-396.md follow the project convention `test_BC_S_SS_NNN_<description>` as required by CLAUDE.md and `docs/specs/test-naming-convention.md`.

### 3e. BC-3.4.015 Source field contains `find_field_by_name` — MINOR INCONSISTENCY

At line 964, BC-3.4.015's `**Source**` field still lists `src/api/jira/fields.rs::find_field_by_name (new)`.

Adversary pass 8 OBS-3 dropped `find_field_by_name` from the `**Trace**` field (which was correctly updated — the Trace at line 1256 does NOT mention `find_field_by_name`, citing `resolve_edit_fields` as the spec-anchored orchestrator). However, the `**Source**` field at line 964 was not updated and still lists `find_field_by_name`.

The Source and Trace fields serve different roles (Source = empirical evidence; Trace = spec linkage). The CLAUDE.md convention for Source is "file + test category, not counts." The reference to a helper function name in Source is cosmetically inconsistent with pass-8 OBS-3's intent, but since Source describes where the implementation evidence will live and `find_field_by_name` may indeed be created as an implementation detail, this is low impact.

**Severity: LOW.** The Trace field (the primary spec anchor) is correct. The Source field discrepancy does not affect behavioral correctness or implementer guidance.

---

## Check 4: Scope/Perimeter Gaps

### 4a. CLAUDE.md — MISSING REQUIRED GOTCHA ENTRY

The F2 delta (`prd-delta-396.md §10`) and the F1 delta analysis both explicitly require adding a new Gotcha entry to CLAUDE.md covering:
1. `--field` on `issue edit` is single-key only (C-1 guard rejects bulk).
2. Changing the Request Type of an existing JSM issue is NOT supported (JSDCLOUD-4609).
3. JSM Urgency/Impact and other select fields CAN be set via `--field` provided the field is on the agent Edit screen.
4. `--field` on `issue edit` uses `editmeta`; one extra HTTP round-trip when `--field` is set.

**CLAUDE.md currently contains NO entry for any of these four points.** grep confirms zero matches for `JSDCLOUD`, `sd-customerrequesttype`, `editmeta`, `resolve_edit_fields`, and `--field.*single-key` in CLAUDE.md.

**Severity: MEDIUM.** The CLAUDE.md update was explicitly mandated in prd-delta-396.md §10 and delta-analysis.md §CLAUDE.md Update Required. Omitting it means the next implementer who reads CLAUDE.md Gotchas will find no guidance about the Request Type non-goal (JSDCLOUD-4609), the single-key constraint, or the fields.json cache pattern — all of which have a direct bearing on correct implementation. This is not blocking spec correctness (the behavior is fully specified in bc-3-issue-write.md) but is a mandatory process deliverable for the F2 phase.

### 4b. CANONICAL-COUNTS.md Cache Types section — MINOR INCONSISTENCY

The CANONICAL-COUNTS.md `## Cache Types` section at lines 166-176 lists "6 distinct cache files" and enumerates them (team list, project meta, workspace ID, CMDB fields, object-type attributes, resolutions). The new `fields.json` cache introduced by the F2 amendment to BC-3.4.015 is a 7th distinct cache type, not listed here.

The section says "(per cache.rs)." Since `write_fields_cache` and `read_fields_cache` are new additions to `src/cache.rs` per prd-delta-396.md §5, the count should be "7 distinct cache files" after implementation. The CANONICAL-COUNTS.md text predates implementation (it tracks spec claims, not code), but the spec now claims 7 cache types and the count is already stale against its own specification.

**Severity: LOW.** The CANONICAL-COUNTS.md Cache Types section is a narrative section with no guard script. It does not affect any count surface verified by the guard scripts. It is a documentation consistency gap that should be corrected before F3 implementation begins, to avoid misleading the implementer about the expected cache footprint.

### 4c. holdout-scenarios.md — no update needed, CONSISTENT

There are no missing holdout scenarios for this feature. BC-3.4.015/016/017 describe a user-facing flag on `issue edit`. The existing holdout corpus does not cover `issue edit --field`, but the verified properties (VP-396-001..012) are integration-test-level VPs, not holdout-scenario-level. The feature does not introduce new security assumptions, new multi-workspace concerns, or new MUST-FIX class behaviors that would typically trigger a holdout scenario. No gap here.

### 4d. nfr-catalog.md — no update needed, CONSISTENT

None of the four standard NFR concerns (reliability, security, observability, performance) are newly implicated by `--field` on `issue edit` at a level requiring a new NFR row. The `editmeta` HTTP call adds one round-trip under a flag — within the existing NFR-R-C (latency) and NFR-O-A (progress feedback) scope. No new NFR required.

### 4e. risk-register.md — no update needed, CONSISTENT

The F1 delta analysis classified regression risk as MEDIUM and enumerated the risk surfaces (handle_edit single-key path, has_any_field_change guard, clap variant). All are mitigated by the specified tests. No new R-NNN required.

### 4f. F1 → F2 delta consistency — CONSISTENT

The F1 delta analysis listed `src/cache.rs` under "No changes required." The F2 spec amendment added a `fields.json` cache as a new implementation detail. This is explicitly acknowledged in prd-delta-396.md §5 as "Field-list cache (`fields.json`) — F2 amendment" — meaning it is a deliberate expansion of scope during the F2 phase, not a silent contradiction of the F1 analysis. The delta-analysis.md is a precursor document; the prd-delta-396.md is authoritative for the locked F2 scope. No inconsistency.

The five F1 open questions (Q1–Q5) are all resolved in prd-delta-396.md §2 Locked Design Decisions, with Q5 (helpers.rs vs field_resolve.rs) resolved as helpers.rs and recorded as OBS-1.

### 4g. ADR index — no update needed

The `--field` feature on `issue edit` uses the existing thin-client pattern (ADR-0001), the existing OAuth auth (ADR-0006), the existing cache pattern (no new ADR needed). The field-resolution algorithm and `editmeta` API call are implementation details, not architectural decisions warranting a new ADR.

---

## Check 5: Consistency with CLAUDE.md Conventions

| Convention | Status |
|-----------|--------|
| No lint suppression without refactoring | Consistent — prd-delta-396.md §5 explicitly documents `#[allow(dead_code)]` guidance for `required` and `name` fields with justification comments |
| Cache writer: best-effort pattern documented | Consistent — invariant 7 of BC-3.4.015 and prd-delta-396.md §5 both document the "best-effort writer" rationale per the CLAUDE.md Gotchas pattern |
| Per-profile cache boundary | Consistent — `profile: &str` is second argument to `resolve_edit_fields` (P2-006 fix); CLAUDE.md multi-profile boundary rule explicitly cited |
| `#[serde(rename = "allowedValues")]` | Consistent — prd-delta-396.md §5 OBS-1 audit documents the required rename to prevent silent deserialization failure |
| Test naming `test_BC_S_SS_NNN_<description>` | Consistent throughout verification-delta-396.md |
| No unsafe code | No unsafe code introduced by this feature |
| Output channel profiles | BC-3.4.015/016 use Profile 4 (Symmetric) via the shared BC-3.4.012/013 echo path — consistent |

---

## Summary of Findings

| # | Finding | Severity | Blocking? |
|---|---------|----------|-----------|
| F1 | CLAUDE.md missing required Gotcha entry for `--field` on `issue edit`, JSDCLOUD-4609 non-goal, editmeta, and fields.json cache | MEDIUM | No (spec is correct; this is an F2 process deliverable gap) |
| F2 | CANONICAL-COUNTS.md Cache Types section counts 6 caches; new `fields.json` makes 7 | LOW | No |
| F3 | BC-3.4.003 `**Source**` field still references `find_field_by_name` (removed from `**Trace**` in adversary pass 8 OBS-3) | LOW | No |
| F4 | BC-3.4.003 has no cross-reference annotation for BC-3.4.015/016/017 (pattern established for prior --field extensions) | LOW | No |

No CRITICAL or HIGH findings. No blocking violations. Both guard scripts exit 0.

---

## Verdict

**CONSISTENT**

The F2 spec delta for issue #396 is internally consistent across all 9 count surfaces, all cross-references in the new BCs resolve to existing artifacts, all 12 VP IDs are present in the correct BC bodies, EC numbering is monotonic across all three new BCs, and no holdout/NFR/ADR/risk-register updates are required.

Four non-blocking gaps are recorded: one MEDIUM (CLAUDE.md Gotcha entry not yet written — an explicit F2 deliverable that must be completed before F3 implementation begins), and three LOW (CANONICAL-COUNTS.md cache count stale, BC-3.4.015 Source field residual, BC-3.4.003 missing cross-reference annotation). None of these gaps affect the correctness of the behavioral contracts or the implementer's ability to correctly build and test the feature.

**Guard script exit codes: `check-spec-counts.sh` = 0, `check-bc-cumulative-counts.sh` = 0.**

The spec perimeter is correct and ready for human approval, provided the CLAUDE.md Gotcha entry (F1 above) is added before or alongside F3 implementation.
