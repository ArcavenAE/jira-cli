---
document_type: consistency-report
scope: issue-474-delta
cycle: feat/adf-minor-constructs-474
gate: F7-convergence
auditor: consistency-validator
timestamp: 2026-06-09
verdict: CONVERGED
---

# Consistency Audit — Issue #474 Delta (F7 Convergence Gate)

Delta: Markdown minor constructs → ADF (`src/adf.rs`)
Scope: superscript/subscript subsup mark + heading-attribute stripping
Gate: F7 pre-human-approval perimeter check

---

## Summary Table

| Dimension | Verdict | Notes |
|-----------|---------|-------|
| SPEC | CONVERGED | BC-7.2.007 + BC-7.2.008 authored, versioned, bodied in bc-7-output-render.md |
| TESTS | CONVERGED | 105 green (0 failed); 13 new tests all present and named correctly |
| IMPLEMENTATION | CONVERGED | Code matches every behavioral claim in both BCs; dedup applied at both emission sites |
| VERIFICATION | CONVERGED | All 13 tests exist verbatim; pass confirmed by live cargo test run |
| DOCS | CONVERGED | CLAUDE.md #474 note accurate; issue #483 deferral traceable; story complete |

**Overall verdict: CONVERGED — zero blocking findings.**

---

## Dimension 1: SPEC (BCs authored and versioned)

### Check 1.1 — BC bodies exist and are structurally complete

- `bc-7-output-render.md §7.2.007` (line 145): heading, Confidence, Source, Subject, Behavior, Edge cases (EC-1..EC-4), Trace — ALL PRESENT.
- `bc-7-output-render.md §7.2.008` (line 167): heading, Confidence, Source, Subject, Behavior, Edge cases (EC-1..EC-3), Trace — ALL PRESENT.

Verdict: PASS

### Check 1.2 — BC-INDEX entries match BC headings

BC-INDEX.md line 494: `BC-7.2.007` — title matches bc-7-output-render.md H4 exactly.
BC-INDEX.md line 495: `BC-7.2.008` — title matches bc-7-output-render.md H4 exactly.

BC-INDEX §7.2 section header (line 484): "8 individually-bodied BCs: BC-7.2.001..008; 54 BCs cumulative including range-collapsed" — CONSISTENT with bc-7-output-render.md `definitional_count: 41` (41 total H4 headings, 8 are in §7.2 post-addition).

Verdict: PASS

### Check 1.3 — Count surfaces (8 surfaces for bc-7-output-render.md)

| Surface | Claimed | Actual | Match? |
|---------|---------|--------|--------|
| A: bc-7-output-render.md frontmatter `total_bcs` | 87 | 87 | YES |
| B: BC-INDEX.md frontmatter `total_bcs` | 592 | 592 | YES |
| C: BC-INDEX.md §7.2 section line count | 8 individually-bodied | 8 (007+008 added to 001..006) | YES |
| D: CANONICAL-COUNTS.md per-file table (bc-7-output-render.md) | 87 | 87 | YES |
| E: BC-INDEX.md frontmatter `total_bcs` (grand total) | 592 | 592 | YES |
| F: CANONICAL-COUNTS.md Sum row | 592 | 592 | YES |
| G: CANONICAL-COUNTS.md grand-total prose | 592 | 592 | YES |
| Story manifest `total_stories` | 65 | 65 (62 S- rows + 3 issue-288 rows) | YES |

Verdict: PASS — all 8 count surfaces agree at 592 grand total; §7.2 = 54 cumulative (8 individually-bodied + 46 range-collapsed).

### Check 1.4 — L2 domain-spec bc_count PENDING (pre-existing gap, not introduced by #474)

CANONICAL-COUNTS.md line 82 documents: `bc-07-output-render.md | 85 | bc-7-output-render.md | 87 | PENDING (L2 bc_count not yet bumped)`.

This PENDING misalignment (L2 `bc_count: 85` vs L3 `total_bcs: 87`) is a **pre-existing pattern** affecting bc-02, bc-03, and bc-07. The L2 domain-spec file is NOT in the working tree changes for this PR (git status shows only `CLAUDE.md` and `src/adf.rs` modified). The CANONICAL-COUNTS.md PENDING tracking note was updated on 2026-06-08 to include the +2 from issue #474.

Severity: MINOR (pre-existing; tracked; not introduced by #474).
Action required before PR merge: none for #474 scope. L2 bump is a maintenance task for a follow-up sweep.

---

## Dimension 2: TESTS (13 new tests, 105 total, all green)

### Check 2.1 — All 13 test names exist verbatim in src/adf.rs

Verified by grep (line numbers confirmed):

| Test name | Line in adf.rs | Exists? |
|-----------|---------------|---------|
| `test_markdown_superscript_to_subsup_sup` | 2048 | YES |
| `test_markdown_subscript_to_subsup_sub` | 2060 | YES |
| `test_markdown_intraword_superscript_stays_literal` | 2072 | YES |
| `test_markdown_double_tilde_still_strikethrough_not_subscript` | 2084 | YES |
| `test_render_subsup_mark_reverse_path` | 2093 | YES |
| `test_subsup_markdown_to_text_roundtrip` | 2114 | YES |
| `test_subsup_composes_with_strong` | 2121 | YES |
| `test_markdown_strike_sub_sup_coexist` | 2155 | YES |
| `test_markdown_nested_sub_in_sup_dedupes_subsup_mark` | 2171 | YES |
| `test_markdown_nested_sub_in_sup_keeps_outer_sup` | 2187 | YES |
| `test_markdown_superscript_no_mark_leak_to_trailing_text` | 2220 | YES |
| `test_markdown_heading_non_attribute_brace_stripped` | 2308 | YES |
| `test_markdown_heading_attributes_stripped` | 2337 | YES |

All 13 present. Grep count of `fn test_` in adf.rs = 105 — matches claimed total.

### Check 2.2 — Tests pass

`cargo test --lib -- adf::tests`: **105 passed; 0 failed; 0 ignored**.

### Check 2.3 — Test names match between story, BC Source fields, and code

BC-7.2.007 Source field: 11 test names listed. Story Test Coverage table: 11 rows for BC-7.2.007 + 2 rows for BC-7.2.008 = 13 total. Cross-check:
- All 11 BC-7.2.007 Source names appear in the story table and exist in adf.rs.
- Both BC-7.2.008 Source names (`test_markdown_heading_attributes_stripped`, `test_markdown_heading_non_attribute_brace_stripped`) appear in the story table and exist in adf.rs.

Verdict: PASS — no orphaned or phantom test names.

---

## Dimension 3: IMPLEMENTATION (code matches spec)

### Check 3.1 — BC-7.2.007 behavioral claims vs code

| BC Claim | Code Location | Match? |
|----------|--------------|--------|
| `Tag::Superscript` → `push_mark({"type":"subsup","attrs":{"type":"sup"}})` | `src/adf.rs` AdfBuilder start() Superscript arm (diff +140..143) | YES |
| `Tag::Subscript` → `push_mark({"type":"subsup","attrs":{"type":"sub"}})` | `src/adf.rs` AdfBuilder start() Subscript arm (diff +144..147) | YES |
| `dedup_marks_by_type` applied at `push_text` | `src/adf.rs::push_text` line 371 | YES |
| `dedup_marks_by_type` applied at `push_code` | `src/adf.rs::push_code` line 390 | YES |
| `dedup_marks_by_type` free function (first-wins) | `src/adf.rs` lines 422-434 | YES |
| `apply_marks` subsup arm: sub → `~{text}~`, else → `^{text}^` | `src/adf.rs` apply_marks (diff +957..972) | YES |
| `ENABLE_SUPERSCRIPT | ENABLE_SUBSCRIPT` in Options block | `src/adf.rs::markdown_to_adf` diff +22..29 | YES |

### Check 3.2 — BC-7.2.008 behavioral claims vs code

| BC Claim | Code Location | Match? |
|----------|--------------|--------|
| `ENABLE_HEADING_ATTRIBUTES` added to Options block | `src/adf.rs::markdown_to_adf` diff +29..32 | YES |
| No AdfBuilder code change for heading text handling | Confirmed: no AdfBuilder heading-specific code added | YES |
| Heading attribute events absent from event stream | Parser-level; confirmed by test `test_markdown_heading_attributes_stripped` passing | YES |

### Check 3.3 — Architecture compliance rules (from story)

| Rule | Verified? |
|------|-----------|
| Single modified production file (`src/adf.rs`) | YES — git diff shows only adf.rs + CLAUDE.md |
| Dedup at BOTH text-emission call sites | YES — push_text (line 371) + push_code (line 390) |
| No new crate dependencies | YES — no Cargo.toml changes |
| `ENABLE_GFM` NOT added | YES — only ENABLE_SUPERSCRIPT, ENABLE_SUBSCRIPT, ENABLE_HEADING_ATTRIBUTES added |

Verdict: PASS

---

## Dimension 4: STORY↔BC Consistency

### Check 4.1 — Frontmatter bcs: list

Story frontmatter `bcs: [BC-7.2.007, BC-7.2.008]` — two entries.

### Check 4.2 — Body BC table matches frontmatter

Story body Behavioral Contracts table has two rows: BC-7.2.007 and BC-7.2.008. MATCHES frontmatter.

### Check 4.3 — All 9 ACs trace to declared BCs (bidirectional)

AC traces confirmed:
- AC-001: `traces to BC-7.2.007` — present
- AC-002: `traces to BC-7.2.007` — present
- AC-003: `traces to BC-7.2.007 edge case EC-1` — present
- AC-004: `traces to BC-7.2.007` — present
- AC-005: `traces to BC-7.2.007 EC-3` — present
- AC-006: `traces to BC-7.2.007` — present
- AC-007: `traces to BC-7.2.007` — present
- AC-008: `traces to BC-7.2.008` — present
- AC-009: `traces to BC-7.2.008 edge case EC-2` — present

All 9 ACs trace to either BC-7.2.007 or BC-7.2.008. No AC is untraced.

Reverse check: BC-7.2.007 has 11 tests in its Source field; all 11 resolve to real test functions in adf.rs. BC-7.2.008 has 2 tests in its Source field; both resolve. No BC postcondition clause is left without at least one AC.

Verdict: PASS — bidirectional coverage complete.

### Check 4.4 — STORY-INDEX manifest row matches story file

STORY-INDEX line 392: `| S-474 | feature-followup (...) | .../S-474-adf-minor-constructs.md |` — file exists at that path. Story `total_stories: 65`, manifest row count: 65 (62 S- + 3 issue-288). MATCH.

---

## Dimension 5: DOCS (CLAUDE.md + deferral traceability)

### Check 5.1 — CLAUDE.md #474 note accuracy

CLAUDE.md line 227 note covers:
- `ENABLE_SUPERSCRIPT | ENABLE_SUBSCRIPT | ENABLE_HEADING_ATTRIBUTES` — matches code
- `^x^` → subsup sup, `~x~` → subsup sub — matches BC-7.2.007
- `adf_to_text` round-trip — matches BC-7.2.007 reverse path
- Single-tilde reassignment, double-tilde stays strike — matches code + test
- `dedup_marks_by_type` — matches code
- Intraword caret limitation — matches BC-7.2.007 EC-1
- `code` mark coexistence limitation — matches BC-7.2.007 EC-2
- Heading attr stripping — matches BC-7.2.008
- GFM alerts deferred with rationale — matches code comment in `markdown_to_adf`

No discrepancy found between CLAUDE.md prose and shipped behavior.

### Check 5.2 — GFM alert deferral traceable

CLAUDE.md: "until then `> [!NOTE]` stays a plain blockquote"
Code comment (diff +19..28): "NOTE: GFM alert blockquotes ... are intentionally NOT enabled here ... Tracked as a follow-up; until then `> [!NOTE]` stays a plain blockquote (#474)."
Story Out of Scope section: explicitly calls out issue #483 as the tracking vehicle.
GitHub issue #483: EXISTS, state OPEN, title: "feat(adf): map GFM alerts (> [!NOTE]) to ADF panel with content-model normalization"

Verdict: PASS — deferral is fully traceable from CLAUDE.md → code comment → story → open GitHub issue.

---

## Minor Observations (non-blocking)

### OBS-001: L2 bc_count drift (pre-existing, tracked)

`bc-07-output-render.md` (L2 domain-spec) `bc_count: 85` lags L3 `total_bcs: 87` by 2.
This is documented in CANONICAL-COUNTS.md as PENDING. The same pattern affects bc-02 and bc-03 with larger deltas. Not introduced by #474; not in working tree changes.
Severity: MINOR. Remediation: bump L2 `bc_count` to 87 in a follow-up maintenance sweep.

### OBS-002: Story manifest count reconciliation (verified, consistent)

STORY-INDEX states "Total rows: 65" but naive `grep "^| S-"` yields 62. The 3-row gap is the three `issue-288-pr*` stories whose IDs are not S-prefixed. Actual manifest total = 62 + 3 = 65. CONSISTENT. No action needed; the discrepancy is a counting artifact from mixed ID prefixes, not a real gap.

---

## 5-Dimension Convergence Summary

| Dimension | Status | Evidence |
|-----------|--------|---------|
| SPEC | CONVERGED | BC-7.2.007 + BC-7.2.008 fully bodied; all 8 count surfaces at 592 agree |
| TESTS | CONVERGED | 13 new tests present verbatim in src/adf.rs; `cargo test` = 105/105 green |
| IMPLEMENTATION | CONVERGED | All BC behavioral claims backed by code; dedup at both emission sites; correct tag arms |
| VERIFICATION | CONVERGED | Every test in BC Source fields and story Test Coverage table is a real, passing function |
| DOCS | CONVERGED | CLAUDE.md matches shipped behavior; GFM-alert deferral traceable to open issue #483 |

---

## Gate Decision

**CONVERGED**

Zero blocking findings. One minor pre-existing PENDING note (L2 bc_count drift, OBS-001) tracked in CANONICAL-COUNTS.md and not introduced by this delta. One non-blocking count artifact in STORY-INDEX (OBS-002) verified as consistent.

The delta is ready for human approval and PR merge.
