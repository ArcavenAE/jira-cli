---
round: r44
spec_version_checked: 1.3.81
prev_spec_version: 1.3.80
fix_round: R43-ROUND
date: 2026-07-17
verdict: CONSISTENT
medium_gaps: 0
low_gaps: 0
info_findings_new: 0
info_findings_resolved: 0
---

# Consistency Validation Report — Round 44 (cv-576-r44)

**Feature:** SOH-ATTACHMENTS-1 (issues #576 + #585)
**Spec version checked:** v1.3.81 (immediately after R43-ROUND micro-fix round)
**Prior spec version:** v1.3.80
**Date:** 2026-07-17
**Verdict:** CONSISTENT — 0 gaps, 0 INFO findings

---

## 1. Scope

This is the post-micro-fix confirmation round for the R43-ROUND (v1.3.80→v1.3.81). The
r43 report found 2 LOW gaps and 1 INFO finding. The micro-fix round was instructed to close:

- **GAP-R43-001** (LOW): BC-INDEX rows stale for all 6 BCs modified in v1.3.80
- **GAP-R43-002** (LOW): BC-2.7.011 display-sanitization primary clause allocation
  sentence named S4 but omitted S3
- **INFO-R43-001** (INFO): prd-delta-576.md SEC-576-V2-ROUND section contained a stale
  duplicate closing-count line stating "Spec version: 1.3.79"

Additionally, two security re-verify findings were folded into this round:

- **NEW-576-V3-001** (INFO fold): "Earliest consumer: S2" understated S1 (BC-2.7.001 list
  table cells); label corrected S2→S1
- **NEW-576-V3-002** (INFO): Unicode bidi/line-terminator out-of-scope note absent from
  BC-2.7.011 primary clause

Files examined:
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/phase-f2-spec-evolution/consistency-report-576-r43.md`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/BC-INDEX.md`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/bc-2-issue-read.md`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/bc-3-issue-write.md`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/phase-f2-spec-evolution/prd-delta-576.md`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/spec-changelog.md`

Protocol: verbatim verification at claim time, double-insertion sweep (grep counts),
cross-reference symmetry, version-bump completeness, S2 residue check, guard scripts.

---

## 2. Check 1 — GAP-R43-001 Closed: BC-INDEX Rows Updated

r43 required: update BC-INDEX rows for all 6 BCs modified in v1.3.80 before F3 story
decomposition.

**BC-INDEX frontmatter state (from file):**
```
index_version: v6.34
last_updated: 2026-07-17  # r43 micro-fix round: BC-INDEX rows updated for 6 BCs...
```
BC-INDEX version bumped v6.33→v6.34 ✓

**BC-2.7.007 row** (bc-index-line 226): Contains the required additions:
- `?redirect=false` prohibited in step 2 body clause (SEC-576-009, JRACLOUD-97046) ✓
- EC-2.7.007-12 (SEC-576-010): `--out <PATH>` targets existing regular file without
  `--force` → exit 64 pre-HTTP ✓

**BC-2.7.008 row** (bc-index-line 227): Contains:
- display-sanitization cross-reference (SEC-576-011): `<filename>` in collision-skip
  warnings MUST be display-sanitized (0x00–0x1F/0x7F → `?`) before TTY write ✓

**BC-2.7.010 row** (bc-index-line 229): Contains:
- server-ID trust assumption (SEC-576-008): batch IDs numeric invariant is API-behavioral;
  compromised server outside threat model; MAY defense-in-depth ✓
- display-sanitization cross-reference (SEC-576-011): `<raw>` in degenerate-name warning
  MUST be display-sanitized ✓

**BC-2.7.011 row** (bc-index-line 230): Contains the CRITICAL update:
- ALSO: display sanitization for TTY output (SEC-576-011 — CWE-116): ALL ASCII control
  characters 0x00–0x1F and 0x7F in server-supplied `filename` values MUST be replaced
  with `?` before TTY write ✓
- earliest consumer S1 (list table cells) ✓ (reflects the NEW-576-V3-001 correction)
- cross-referenced from BC-2.7.008/BC-2.7.010/BC-3.9.015/BC-3.9.017 ✓
- Unicode bidi controls outside scope ✓

**BC-3.9.015 row** (bc-index-line 387): Contains:
- display-sanitization cross-reference (SEC-576-011): `<filename>` in step 1 delete
  confirmation prompt MUST be display-sanitized ✓

**BC-3.9.017 row** (bc-index-line 389): Contains:
- display-sanitization cross-reference (SEC-576-011): all `<filenameN>` values in step 2
  --replace-existing gate prompts MUST be display-sanitized ✓

**Index verbatim-body consistency:** All 6 rows describe additions; none contradicts the
BC body file content (which remains authoritative per BC-INDEX preamble). The BC-2.7.011
row is now consistent with the v1.3.81 body: both say "earliest consumer S1." **PASS.**

---

## 3. Check 2 — GAP-R43-002 + NEW-576-V3-001 Closed: Allocation Sentence and Earliest-Consumer Label

r43 required: (a) correct "Earliest consumer: S2" → S1 in BC-2.7.011 primary clause body;
(b) add S3 to the allocation guidance sentence alongside S4.

**Verbatim from bc-2-issue-read.md line 932 (BC-2.7.011 primary clause):**

> `**Earliest consumer: S1** (Story 1 — first surface to write server-supplied filenames
> to human-readable output; S1 story-writers must apply display-sanitization to attachment
> list table cells (BC-2.7.001); S3 and S4 story-writers must allocate display-sanitization
> at confirmation prompt call sites per DEC-184 R3.13).`

Assessment of closure:

- "Earliest consumer: S1" ✓ — corrected from S2 (NEW-576-V3-001 closed)
- "S1 story-writers must apply display-sanitization to attachment list table cells
  (BC-2.7.001)" ✓ — S1 obligation explicitly stated with BC anchor
- "S3 and S4 story-writers must allocate display-sanitization at confirmation prompt call
  sites per DEC-184 R3.13" ✓ — S3 added alongside S4 (GAP-R43-002 closed)

**Cross-reference sentence immediately follows:**
> `Cross-referenced from: BC-2.7.008 Overwrite behavior (collision-skip warnings),
> BC-2.7.010 degenerate-name warning, BC-3.9.015 step 1 (delete confirmation prompt),
> BC-3.9.017 step 2 (\`--replace-existing\` prompt).`

S3 owns BC-3.9.017 step 2; S4 owns BC-3.9.015 step 1 — the cross-reference list provides
the precise per-story call-site mapping. **PASS.**

**Prd-delta Scope table consistency:**

- S1 row (Scope table): contains attachment list (BC-2.7.001..006) ✓ — consistent with
  "S1 story-writers...table cells (BC-2.7.001)"
- S3 row (Scope table line 33): contains BC-3.9.017; "S3 and S4 story-writers" ✓
- S4 row (Scope table): contains BC-3.9.015; "S3 and S4 story-writers" ✓

**S2 residue check (grep "Earliest consumer" + "S2" near display-sanitization in bc-2/bc-3/prd-delta):**

bc-2-issue-read.md:
- Line 932 (body): "**Earliest consumer: S1**" — ONE occurrence, says S1. ✓
- Line 934 (Trace, v1.3.80 sub-entry): "earliest consumer S2" — historical record of
  what was written in v1.3.80. NOT a live claim; the v1.3.81 sub-entry immediately
  below records "earliest consumer corrected S2→S1". NOT contradictory. ✓

prd-delta-576.md:
- Line 32 (S2 Scope row, delivery obligations): "BC-2.7.011 surface — earliest consumer"
  appears in the context of the CLAUDE.md §3.4(2c) CWE-22 disk-write sanitization gotcha
  note obligation. This refers to `sanitize_attachment_filename` (CWE-22, disk write) —
  NOT to `display_sanitize_filename` (CWE-116, display). S2 is correctly the "earliest
  consumer" of the CWE-22 disk-write CLAUDE.md note because S2 is the first story that
  downloads files and invokes `sanitize_attachment_filename`. NOT contradictory to
  BC-2.7.011 saying S1 is the earliest consumer of the display-sanitization helper. ✓
- Line 765 (SEC-576-V2-ROUND dispositions row 4): "earliest consumer S2" — historical
  record of what was written in v1.3.80. The R43-ROUND table row (line 783) documents the
  correction. NOT a live contradiction. ✓
- Line 783 (R43-ROUND table row 3): `"Earliest consumer: S2" may understate S1` — this
  IS the description of the finding that was corrected. ✓

**No contradictory S2 residue found.** PASS.

---

## 4. Check 3 — NEW-576-V3-002 Closed: Unicode Bidi Out-of-Scope Note

r43 micro-fix round folded NEW-576-V3-002 (INFO): add a scope note clarifying that Unicode
bidirectional control characters are outside the 0x00–0x1F/0x7F sanitization scope.

**Verbatim from bc-2-issue-read.md line 932 (appended to BC-2.7.011 primary clause):**

> `**Scope note (NEW-576-V3-002)**: this sanitization covers ASCII control characters
> 0x00–0x1F and 0x7F only; Unicode bidirectional control characters (e.g. U+202E
> RIGHT-TO-LEFT OVERRIDE, U+2028 LINE SEPARATOR, U+2029 PARAGRAPH SEPARATOR) are outside
> this sanitization scope — accepted residual (mirrors the INV-1 ASCII \`\r\`/\`\n\` only
> scope in adf.rs).`

Assessment:

- Scope note present and tagged with NEW-576-V3-002 ✓
- Does NOT contradict the primary clause ("ALL ASCII control characters in the byte range
  0x00–0x1F and 0x7F MUST be replaced with `?`") — the scope note clarifies WHAT IS
  OUT of scope (Unicode bidi/line separators), not what is IN scope ✓
- The "accepted residual" framing matches adf.rs INV-1 precedent ✓
- Grep count: "Scope note (NEW-576-V3-002)" appears exactly once in bc-2-issue-read.md ✓

**PASS.**

---

## 5. Check 4 — INFO-R43-001 Closed: Stale Closing-Count Line Removed

r43 required: remove or correct the stale "Spec version: 1.3.79" duplicate closing-count
line from prd-delta-576.md SEC-576-V2-ROUND section.

**Current state of prd-delta-576.md SEC-576-V2-ROUND section close:**

- Line 769 (ECHO-BREAKER LIST B): "No holdout assertions changed in this security fix round."
- Line 771: "**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged).
  VP count: 35 (unchanged). Spec version: 1.3.80. BC-INDEX version: v6.33 (unchanged —
  no BC rows modified).**"
- Line 773: `---` (section separator)
- Line 775: `## R43-ROUND — r43 Micro-Fix Round (spec v1.3.80 → v1.3.81)`

Exactly ONE closing-count line in the SEC-576-V2-ROUND section (line 771), reading
Spec version: 1.3.80 ✓. The stale "Spec version: 1.3.79" line from r43's detected
duplicate has been removed ✓. The R43-ROUND section follows immediately after the
section separator ✓.

**R43-ROUND section closing line (prd-delta line 791):**
"**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35
(unchanged). Spec version: 1.3.81. BC-INDEX version: v6.34.**"
Records 1.3.81 ✓. **PASS.**

---

## 6. Check 5 — [1.3.80] "BC-INDEX Unchanged" Claim NOT Retroactively Rewritten

r44 must confirm the historical v1.3.80 claims were preserved, not retroactively altered.

**prd-delta-576.md line 771 (SEC-576-V2-ROUND closing line):**
"BC-INDEX version: v6.33 (unchanged — no BC rows modified)" — STILL READS v6.33 ✓

**spec-changelog.md [1.3.80] Impact Assessment table:**
"| BC-INDEX.md | Verified, NO change | No BC rows modified; v6.33 unchanged |"
STILL READS "NO change" / "v6.33 unchanged" ✓

Neither historical claim was retroactively altered. The [1.3.81] entries correctly record
the BC-INDEX row updates as belonging to v1.3.81, not v1.3.80. **PASS.**

---

## 7. Check 6 — Version-Bump Surface Completeness

| Surface | Expected | Observed | Status |
|---------|----------|----------|--------|
| bc-2-issue-read.md frontmatter trace v1.3.81 entry | Present | "v1.3.81 — r43 micro-fix round (2026-07-17, SOH-ATTACHMENTS-1): BC-2.7.011 display-sanitization primary clause corrected — earliest consumer S2→S1...; S3 added to allocation guidance alongside S4 (GAP-R43-002); Unicode bidi/line-terminator out-of-scope sentence appended (NEW-576-V3-002); BC-2.7.011 Trace updated." | PASS |
| bc-3-issue-write.md frontmatter trace v1.3.81 entry | NOT owed (bc-3 body not edited in this round) | No v1.3.81 entry; last entry is v1.3.80 (security round) | CORRECT — not owed |
| BC-INDEX.md index_version | v6.34 | v6.34 | PASS |
| prd-delta-576.md frontmatter spec_version_after | 1.3.81 | 1.3.81 | PASS |
| spec-changelog.md [1.3.81] entry | Present with 657/100/35 | "BCs: 657 (unchanged). Holdouts: 100 (unchanged). VPs: 35 (unchanged)." | PASS |
| BC-2.7.011 Trace field v1.3.81 sub-entry | Present | "v1.3.81 — r43 micro-fix round: earliest consumer corrected S2→S1 (BC-2.7.001 list table cells ship with S1 per prd-delta Scope table; NEW-576-V3-001); S3 added to allocation guidance sentence alongside S4 (GAP-R43-002); Unicode bidi/line-terminator accepted-residual scope note appended (NEW-576-V3-002)" | PASS |

All required surfaces present and consistent. **PASS.**

---

## 8. Check 7 — Double-Insertion Sweep

Grep-count verification on the edited region (bc-2-issue-read.md BC-2.7.011 body):

| Pattern | File | Count | Expected | Status |
|---------|------|-------|----------|--------|
| `Earliest consumer` (capital E) | bc-2-issue-read.md | 1 | 1 (body clause only; Trace uses lowercase) | PASS |
| `Scope note (NEW-576-V3-002)` | bc-2-issue-read.md | 1 | 1 | PASS |
| `S3 and S4 story-writers` | bc-2-issue-read.md | 1 | 1 | PASS |
| `earliest consumer S1` | BC-INDEX.md | 1 | 1 (BC-2.7.011 row only) | PASS |

No double-insertion detected. **PASS.**

---

## 9. Check 8 — Guard Scripts

Both guards were run from `/Users/zious/Documents/GITHUB/jira-cli`:

```
$ bash scripts/check-spec-counts.sh
OK: all spec counts verified.
EXIT: 0

$ bash scripts/check-bc-cumulative-counts.sh
OK: all cumulative BC counts verified (657 total across 8 files; Surface H footer checked where present).
EXIT: 0
```

**Both guards: EXIT 0. PASS.**

---

## 10. Summary

### Gap Table

**No gaps found.** All r43 gaps are confirmed closed.

### Closure Verification

| r43 Finding | Status |
|-------------|--------|
| GAP-R43-001: BC-INDEX rows stale for 6 BCs modified in v1.3.80 | CLOSED — all 6 rows updated; BC-INDEX v6.34; rows are consistent with BC body files |
| GAP-R43-002: BC-2.7.011 allocation sentence omitted S3 | CLOSED — "S3 and S4 story-writers must allocate display-sanitization at confirmation prompt call sites per DEC-184 R3.13" ✓ |
| NEW-576-V3-001 (fold): "Earliest consumer: S2" understated S1 | CLOSED — body reads "Earliest consumer: S1"; BC-INDEX row reads "earliest consumer S1 (list table cells)" ✓ |
| NEW-576-V3-002: Unicode bidi out-of-scope note absent | CLOSED — scope note appended; does not contradict primary clause ✓ |
| INFO-R43-001: stale "Spec version: 1.3.79" duplicate line in prd-delta | CLOSED — stale line removed; exactly one closing-count line in SEC-576-V2-ROUND section (Spec version: 1.3.80) ✓ |

### Checks Passed

| Check | Result |
|-------|--------|
| 1. BC-INDEX rows updated (6 BCs) | PASS |
| 2. GAP-R43-002 + NEW-576-V3-001: allocation sentence S1/S3/S4 + body label S1 | PASS |
| 3. NEW-576-V3-002: Unicode bidi scope note present, non-contradictory | PASS |
| 4. INFO-R43-001: exactly one closing-count line in SEC-576-V2-ROUND (1.3.80); R43-ROUND records 1.3.81 | PASS |
| 5. [1.3.80] "BC-INDEX unchanged" claim NOT retroactively rewritten | PASS |
| 6. Version-bump surfaces complete (bc-2 v1.3.81; bc-3 not owed; spec-changelog 657/100/35; prd-delta 1.3.81; BC-INDEX v6.34) | PASS |
| 7. Double-insertion sweep | PASS |
| 8. Guard scripts (check-spec-counts + check-bc-cumulative-counts) | PASS — both exit 0 |

---

## 11. Verdict

**CONSISTENT** — 0 gaps, 0 INFO findings.

All five r43 findings (2 LOW gaps, 1 INFO, 2 INFO folds) are confirmed closed. The spec
is at v1.3.81. Both guard scripts exit 0. No new inconsistencies introduced by the
micro-fix round. The spec is ready to proceed to F3 story decomposition.
