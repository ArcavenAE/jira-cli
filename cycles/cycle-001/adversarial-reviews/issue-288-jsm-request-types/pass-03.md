---
document_type: adversarial-pass
phase: F1d
pass: 03
cycle: 3-feature-jsm-request-types-288
target: "issue-288 F2 spec delta — pass-02 remediations + fresh review"
model: "Opus 4.7 (1M context)"
timestamp: 2026-05-18
verdict: FINDINGS-PRESENT
counts:
  blocking: 0
  concern: 4
  nit: 6
counter_status: "0/3 (resets on CONCERN findings)"
pass_02_disposition: "4 ADDRESSED / 2 PARTIALLY ADDRESSED (F14, F15) / 0 NOT / 1 partial-regression (F15 introduced CANONICAL-COUNTS:119 self-contradiction)"
---

# F1d Pass 03 — Issue #288 — FINDINGS-PRESENT

**Target**: F2 spec delta for issue #288 (JSM request type support) — pass-02 remediations + fresh review
**Verdict**: FINDINGS-PRESENT — 0 BLOCKING, 4 CONCERN, 6 NIT. Counter: 0/3 (reset by CONCERN findings).

Product-owner conducted comprehensive grep-based sweep across 8 files after this pass:
17 fixes including BC-INDEX Section X header (130/64 → 138/72), "Queue commands require"
literal in BC-X.8.004 index row, CANONICAL-COUNTS:119 prose self-contradiction (54→55),
holdout-scenarios prose "50 scenarios" → 55, last_updated timestamps, H-NEW-JSM-RT-005
mock cardinality correction, prd-delta footer, and README.md PRD prose count (541→566).
Pass-04 pending.

---

## Pass-02 Disposition Summary

| # | Severity | Title | Disposition | Evidence |
|---|----------|-------|-------------|----------|
| F14 | CONCERN | prd-delta Count Bumps table has stale totals | ADDRESSED | prd-delta Group 9 range updated BC-3.8.001..BC-3.8.010; holdout sub-total and grand total refreshed to 55 |
| F15 | CONCERN | CANONICAL-COUNTS internal prose references stale pre-remediation totals | PARTIALLY ADDRESSED / PARTIAL REGRESSION | Main totals (547→566, 315→334) updated correctly; however remediation introduced a new within-file self-contradiction at CANONICAL-COUNTS line 119: prose section now asserts "54 authoritative individually-bodied" but frontmatter and table rows sum to 55. Old stale values removed; new inconsistency introduced. |
| F16 | CONCERN | BC-X.12.005 lacks caching subsection | ADDRESSED | BC-X.12.005 §Caching subsection added with XDG path, 7-day TTL, cross-reference to BC-X.12.008 |
| F17 | NIT | BC-X.12.008 redundant footnote duplicates BC-X.12.003 Errors | ADDRESSED | Redundant footnote replaced with cross-reference to BC-X.12.003 |
| F18 | NIT | BC-X.8.004 caller-supplied label lacks `&'static str` contract | ADDRESSED | BC-X.8.004 implementation contract note added for `&'static str` label parameter type |
| F19 | NIT | BC-3.8.010 Expected in H-NEW-JSM-RT-004 reads as success-path-only | ADDRESSED | H-NEW-JSM-RT-004 Expected clarified; scope re-interpreted as success-path-only per user re-scope (warning fires before API call in all paths but Expected explicitly describes success path per design intent) |
| F20 | NIT | ADR-0014 related[] missing BC-3.8.010 and BC-1.3.023 | ADDRESSED | ADR-0014 related[] updated to include BC-3.8.010 and BC-1.3.023 |

---

## Summary Table — Net-New Findings F21–F30

| # | Severity | Area | Title |
|---|----------|------|-------|
| F21 | CONCERN | counts / arithmetic | BC-INDEX Section X header still reads "130 BCs / 64 individually-bodied" after #288 added 8 BC-X.12.* BCs |
| F22 | CONCERN | implementation contract | BC-INDEX Section 3.8 row summary still contains the "Queue commands require" literal that was fixed in BC bodies by F4 but not swept in the index row |
| F23 | CONCERN | counts / arithmetic | CANONICAL-COUNTS:119 prose asserts 54 authoritative individually-bodied BCs; frontmatter and per-file table sum to 55 (F15 partial-regression) |
| F24 | CONCERN | counts / arithmetic | holdout-scenarios.md prose introduction reads "50 scenarios" while frontmatter total_count: 55 |
| F25 | NIT | counts / arithmetic | prd-delta footer "Total delta: 18 BCs / 5 holdouts" understates holdout count (should be 5 new holdouts: H-NEW-JSM-RT-001..005) — verify footer matches post-sweep actual |
| F26 | NIT | counts / arithmetic | verification-delta.md VP count summary not refreshed after #288 delta; last_updated timestamp stale |
| F27 | NIT | counts / arithmetic | architecture-delta.md component count summary references pre-#288 totals in its "Changes Summary" table header |
| F28 | NIT | timestamp | bc-3-issue-write.md frontmatter last_updated not bumped after BC-3.8.010 + BC-3.8.009 revision in pass-01/02 remediation |
| F29 | NIT | holdout coverage | H-NEW-JSM-RT-005 setup mocks 3 request types but Expected output column lists only 2 display rows; mock cardinality vs expected output mismatch |
| F30 | NIT | counts / arithmetic | README.md PRD prose references 541 BCs (pre-#288 baseline) instead of 566 post-delta |

---

## Detailed Findings

### F21 — CONCERN — BC-INDEX Section X header reads 130/64 after #288 added 8 BC-X.12.*

**Evidence**:
- `BC-INDEX.md` Section X (cross-cutting) header row reads "Section X: 130 BCs,
  64 individually-bodied" (pre-#288 values).
- #288 delta added BC-X.12.001 through BC-X.12.008 (8 new individually-bodied BCs)
  and revised BC-X.8.004 (pre-existing body, no count change). Post-delta Section X
  should read: 130 + 8 = **138 BCs**, 64 + 8 = **72 individually-bodied**.
- The BC-INDEX coverage-stats footer was updated to 334 at F2 remediation (pass-01),
  but the per-section header rows were not swept in the same pass.

**Why this matters**: BC-INDEX section headers are the first artifact a reviewer
skims when assessing which sections changed. A stale section-level count for Section X
signals to the reviewer that no cross-cutting BCs were added — masking the 8 new
BC-X.12.* contracts from scope-verification at F4 implementation. This is the
highest-risk propagation gap: the BCs exist in the body files but the index
misrepresents their count.

**Recommendation**: Update BC-INDEX Section X header to "138 BCs, 72 individually-bodied".
Run a secondary grep to verify no other section headers contain stale counts after the #288 delta.

---

### F22 — CONCERN — BC-INDEX Section 3.8 index row still contains "Queue commands require" literal

**Evidence**:
- `BC-INDEX.md` Section 3.8 summary row (the compact single-line index entry for the
  BC-3.8.* range) contains the text: "Queue commands require a JSM service desk project."
- This literal was the root-cause of F4 in pass-01 (cross-feature context leakage).
  F4 remediation updated BC-3.8.002 body, BC-X.12.003 body, and BC-X.8.004 body.
- The BC-INDEX index row is a separately maintained prose summary — it was not part
  of the F4 body-level sweep.

**Why this matters**: The BC-INDEX row summary is read by the F4 implementer as a
quick scan to understand what BC-3.8.* governs. Seeing "Queue commands require"
in the index summary creates an incorrect mental model that the BC-3.8.* range
covers queue commands rather than JSM request type creation. This is a direct
audit-trail gap: the fix exists in the body, not the index.

**Recommendation**: Update BC-INDEX Section 3.8 summary row to remove the "Queue
commands require" literal and replace with an accurate description of the BC-3.8.*
JSM request type creation scope.

---

### F23 — CONCERN — CANONICAL-COUNTS:119 asserts 54 individually-bodied vs frontmatter 55 (F15 partial-regression)

**Evidence**:
- `CANONICAL-COUNTS.md` line 119 (in the §Authoritative Summary prose block):
  "54 authoritative individually-bodied BCs across all sections."
- `CANONICAL-COUNTS.md` frontmatter `individually_bodied_total: 55` and the
  per-file table rows sum to 55 (bc-2: 51 + bc-3: 4 net-new = correction value
  visible in per-row data).
- This is a direct within-file self-contradiction introduced during pass-02 F15
  remediation: the pass-02 remediation correctly updated the frontmatter and the
  per-file table rows (from 315→334 and 54→55 net additions), but the prose
  narrative block at line 119 was updated to 54 instead of 55, creating a new
  contradiction where the old one was removed.

**Why this matters**: CANONICAL-COUNTS.md is the spec-integrity anchor document.
A within-file contradiction between frontmatter (55) and prose summary (54) means
any agent or human that reads the prose first will use 54 as the count anchor —
then disagree with the frontmatter when they reach it. This directly undermines
the remediation goal of F15, which was to make CANONICAL-COUNTS self-consistent.
The regression is more subtle than the original: old stale values (547/315) were
obviously from a prior epoch; the new contradiction (54 vs 55) looks like a
typographic error that could be either value.

**Recommendation**: Update CANONICAL-COUNTS line 119 to read "55 authoritative
individually-bodied BCs across all sections." Run a grep sweep for "54" in
CANONICAL-COUNTS.md to catch any other prose locations that may carry the
stale value.

---

### F24 — CONCERN — holdout-scenarios.md prose introduction reads "50 scenarios" vs frontmatter 55

**Evidence**:
- `holdout-scenarios.md` §Introduction prose paragraph: "This document contains
  50 holdout scenarios for the jira-cli behavioral contract test suite."
- `holdout-scenarios.md` frontmatter: `total_count: 55`
- The holdout count has been updated 5 times since the prose introduction was
  authored: +3 (H-NEW-VERBOSE-001/002, H-NEW-AUTH-002 post-Phase-1d) → 51,
  +1 (H-NEW-JSM-RT-001..004 pass-01 burst) → 54, then 55 (H-NEW-JSM-RT-005
  pass-02 burst). The prose introduction was never swept.

**Why this matters**: An F4 implementer reading the introduction to understand
the scope of behavioral contracts will see "50 scenarios" and assume the document
is anchored at the pre-#288 count. Any count-check tooling that scans prose
introduction lines (rather than frontmatter) will silently diverge from the
authoritative frontmatter value.

**Recommendation**: Update holdout-scenarios.md §Introduction to read "55 holdout
scenarios". Run a grep for "50 scenarios" across all factory files to confirm no
other prose repeats the stale count.

---

### F25 — NIT — prd-delta footer "Total delta: 18 BCs / 5 holdouts" holdout count may be understated

**Evidence**:
- `prd-delta.md` footer (Count Bumps section grand total line): "Total delta: 18 BCs
  added, 5 holdouts added" (or equivalent).
- Actual holdouts added by this delta: H-NEW-JSM-RT-001 through H-NEW-JSM-RT-005 = 5.
  This count appears consistent with the footer claim, but the footer was written
  before H-NEW-JSM-RT-005 was added in pass-02 burst. Verification required that
  the footer refresh included H-NEW-JSM-RT-005.

**Recommendation**: Verify prd-delta footer grand total explicitly states 5 holdouts
(H-NEW-JSM-RT-001..005) and matches the post-sweep actual count. No change needed
if the pass-02 refresh already captured it.

---

### F26 — NIT — verification-delta.md VP count summary not refreshed; last_updated stale

**Evidence**:
- `phase-f2-spec-evolution/verification-delta.md` frontmatter `last_updated` and
  the §Changes Summary VP count header still reflect pre-pass-02 values. The delta
  document's own frontmatter was not bumped when pass-02 added H-NEW-JSM-RT-005
  and revised BC-X.12.005 (which has associated VP coverage).

**Recommendation**: Update verification-delta.md `last_updated` to 2026-05-18.
Confirm VP count in Changes Summary matches the post-#288 delta scope.

---

### F27 — NIT — architecture-delta.md Changes Summary table header references pre-#288 component totals

**Evidence**:
- `phase-f2-spec-evolution/architecture-delta.md` §Changes Summary table header
  row uses pre-#288 component totals for the "JSM/Queue subsystem" row. The
  table header was not swept when BC-X.12.* was finalized (8 BCs, 1 cache
  integration point, 1 new endpoint group).

**Recommendation**: Update architecture-delta.md Changes Summary to reflect
the 8 BC-X.12.* additions and the request type cache as a new subsystem entry.

---

### F28 — NIT — bc-3-issue-write.md frontmatter last_updated not bumped

**Evidence**:
- `bc-3-issue-write.md` frontmatter `last_updated` still reflects a date prior
  to the pass-01/02 burst that added BC-3.8.010, revised BC-3.8.009 (regime change
  from regex to pass-through), and updated BC-3.8.002 Errors. Three substantive
  changes in two bursts; frontmatter not refreshed.

**Recommendation**: Bump bc-3-issue-write.md `last_updated` to 2026-05-18.

---

### F29 — NIT — H-NEW-JSM-RT-005 setup mocks 3 request types but Expected output lists 2 rows

**Evidence**:
- `holdout-scenarios.md` H-NEW-JSM-RT-005 Setup section: mocks 3 request types
  (e.g., Bug Report, Feature Request, General Inquiry).
- H-NEW-JSM-RT-005 Expected output: lists 2 display rows in the table.
- A mock cardinality of 3 should produce 3 display rows. If Expected intentionally
  shows only 2 (e.g., truncation test or --limit scenario), this must be explicitly
  annotated in the Expected section.

**Recommendation**: Either (a) update Expected to show 3 display rows matching
the 3 mocked request types, or (b) add an annotation in Expected clarifying that
the scenario tests truncation/limit behavior and only 2 of 3 mocked types are
expected to appear.

---

### F30 — NIT — README.md PRD prose references 541 BCs (pre-#288 baseline)

**Evidence**:
- `README.md` or `docs/README.md` (or equivalent project root README) contains a
  prose sentence citing "541 behavioral contracts" or "541 BCs" as the PRD scope.
- Post-#288 delta, the authoritative BC count is 566. The README PRD prose was
  not swept as part of pass-01/02 count-propagation remediations.

**Recommendation**: Update README.md PRD prose reference from 541 to 566.
Confirm no other user-visible prose documents cite the 541 baseline.

---

## Per-Mandate Audit Confirmations

| Mandate | Status |
|---------|--------|
| Citation discipline (external tracker IDs Perplexity-validated) | CLEAR — no new external tracker citations in pass-03 findings |
| No numeric test counts in BC Trace/Source fields | CLEAR — no new BCs in pass-03 add numeric test counts |
| Count arithmetic (BC total = sum of per-file counts) | FAIL — F21 (BC-INDEX Section X header 130/64 → should be 138/72); F23 (CANONICAL-COUNTS:119 prose 54 vs frontmatter 55) |
| Error message accuracy (no cross-feature context leakage) | FAIL — F22 ("Queue commands require" literal still in BC-INDEX Section 3.8 index row) |
| Holdout setup completeness (mocked fields match Expected assertions) | FAIL — F29 (H-NEW-JSM-RT-005 mock cardinality 3 vs Expected output rows 2) |
| Call-site label contract (BC-X.8.004 index row consistent with body) | FAIL — F22 also applies here (BC-INDEX row summary leaks old label language) |
| --no-input parity (all new BCs have flag-equivalent non-interactive path) | CLEAR — no new BCs added in pass-03 |
| JSON output stability (--output json shape stable across error paths) | CLEAR — no new JSON output shape changes in pass-03 scope |
| OAuth scope coordination (write:servicedesk-request gate) | CLEAR — BC-1.3.023 release gate confirmed in place (F10 remediation, pass-01) |
| ADR/BC consistency (ADR-0014 ↔ BC-3.8.*) | CLEAR after F20 remediation (pass-02) |
| Cache invalidation (TTL acceptability stated) | CLEAR — BC-X.12.005 caching subsection in place (F16 remediation, pass-02) |
| bc-2 reconciliation (BC-2.6.051 propagation complete) | CLEAR — CANONICAL-COUNTS bc-2 row = 51; consistent |
| Wire shape (requestFieldValues labels plain-string array) | CLEAR — BC-3.8.007 Confidence: HIGH retained; JSDSERVER-4564 caveat in place |

---

## Novelty Assessment

**Novelty: MEDIUM-HIGH** — 10 net-new findings, all propagation drift, but now operating at the
meta-meta level.

Pass-01 found propagation drift in body files. Pass-02 found drift in summary prose within the
same files that were corrected in pass-01. Pass-03 finds drift in:
- Index row summaries (BC-INDEX section headers and row text) — one level above the body
- Cross-document prose introductions (holdout-scenarios §Introduction) — authored once, never swept
- Delta documents' own metadata (verification-delta, architecture-delta last_updated)
- External-facing documents (README.md)
- A regression introduced by the pass-02 remediation itself (CANONICAL-COUNTS:119)

This is the third consecutive pass where all findings are instances of the same root pattern:
count updates in one authoritative location (frontmatter, table) do not propagate to all
asserting prose locations. The pattern is now demonstrably systemic and extends beyond the
spec corpus to index rows, delta documents, and project-level README. DRIFT-008 scope expansion
is warranted (see STATE.md update).

**Recurring pattern at increasing scope radius**:
- Pass-01: body-level propagation (BC bodies, holdout scenario bodies)
- Pass-02: within-document summary vs table drift (CANONICAL-COUNTS prose vs table)
- Pass-03: cross-document index vs body drift, external-prose vs frontmatter drift, delta-doc metadata drift

The novelty is structural: the pattern has expanded to encompass the index layer and external
documents. No new pattern class emerged, but the scope radius of the known pattern is now
confirmed to be project-wide.

---

## Top 3 Net-New Findings Synopsis

**1. F23 (CONCERN) — CANONICAL-COUNTS:119 self-contradiction (54 vs 55)**: The F15 pass-02
remediation correctly updated frontmatter and table rows but introduced a new prose contradiction
at line 119 (54 individually-bodied vs frontmatter 55). CANONICAL-COUNTS.md is the
spec-integrity anchor; a within-file contradiction at line 119 means any agent reading
prose-first will use the wrong count anchor. This is the only finding in pass-03 where
a prior remediation introduced a regression.

**2. F21 (CONCERN) — BC-INDEX Section X header 130/64 → should be 138/72**: Eight
BC-X.12.* BCs were added by this delta, but the BC-INDEX section-level header row
for Section X was not swept. A reviewer skimming BC-INDEX will conclude no cross-cutting
BCs were added — the highest-scope implementation risk in pass-03, because it affects
the reviewer's understanding of the delta's full surface area.

**3. F24 (CONCERN) — holdout-scenarios prose introduction "50 scenarios" vs frontmatter 55**:
The §Introduction prose has not been updated since the 50-holdout epoch. Five additions
since then (post-Phase-1d H-NEW-VERBOSE/AUTH, plus H-NEW-JSM-RT-001..005) never triggered
a prose sweep. Count-check tooling that reads prose introduction lines will silently diverge.

---

## Convergence Counter Status

**Counter: 0/3** — unchanged from pass-02. Pass-03 contains 4 CONCERN findings; counter
resets to 0. Pass-04 required. Counter will increment to 1/3 only on a CLEAN-PASS (0
BLOCKING, 0 CONCERN, 0 NIT). Current trajectory: 4B/6C/3N → 0B/3C/4N → 0B/4C/6N.
