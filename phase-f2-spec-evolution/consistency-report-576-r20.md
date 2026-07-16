---
document_type: consistency-report
round: 20
spec_version: 1.3.50
date: 2026-07-16
validator: cv-f2-576-r20 (fresh context, no prior round visibility)
verdict: CONSISTENT
bc_count: 657
holdout_count: 96
priority_checks: P10-001 (BC-3.9.001 Content-Disposition clause + BC-3.9.017 step-1 cross-ref), P10-002 (render_json in EC-2.7.007-7 + EC-2.7.008-6), P10-003 (allow_negative_numbers EC-2.7.009-1)
level: ops
version: "1.0"
status: pass
producer: cv-f2-576-r20
timestamp: 2026-07-16T00:00:00
phase: 2
inputs:
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/holdout-scenarios.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576-worklog.md"
  - ".factory/specs/prd/BC-INDEX.md"
  - ".factory/specs/prd/CANONICAL-COUNTS.md"
  - ".factory/spec-changelog.md"
input-hash: "post-p10-r20"
traces_to: ".factory/specs/prd/BC-INDEX.md"
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 20 (post-P10 remediation)

**Spec version**: 1.3.50 | **BCs**: 657 | **Holdouts**: 96 | **Verdict**: CONSISTENT

---

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) — SOH-ATTACHMENTS-1 F2 |
| **Generated** | 2026-07-16T00:00:00 |
| **Generator** | cv-f2-576-r20 (fresh-context consistency validator, round 20) |
| **Artifacts Scanned** | 8 (bc-2-issue-read.md, bc-3-issue-write.md, holdout-scenarios.md, prd-delta-576.md, prd-delta-576-worklog.md, BC-INDEX.md, CANONICAL-COUNTS.md, spec-changelog.md) |
| **Focus** | Post-P10 adversary-pass remediation verification — spec v1.3.50 |
| **Prior round** | consistency-report-576-r19.md (CONSISTENT at v1.3.49) |

---

## Summary

| # | Check | Result |
|---|-------|--------|
| — | Counts / Versions / Stale Markers | pass |
| P10-001 | BC-3.9.001 Content-Disposition clause + BC-3.9.017 step-1 cross-ref | pass |
| P10-002 | render_json sentence in EC-2.7.007-7 and EC-2.7.008-6 | pass |
| P10-003 | allow_negative_numbers pin in EC-2.7.009-1 | pass |
| — | [1.3.50] in spec-changelog + prd-delta + BC-3 trace | pass |
| — | Holdout ↔ BC coherence | pass |
| — | Contradiction scan | pass |

All 7 check areas pass. Two INFO-level annotation gaps found; neither is a behavioral gap.

---

## Priority Check Closure Table

### P10-001 — BC-3.9.001 Content-Disposition filename=basename clause + BC-3.9.017 step-1 cross-ref

#### BC-3.9.001 Content-Disposition clause

**Quote-verified verbatim** (`bc-3-issue-write.md` line 3262):

> **Content-Disposition filename value (BC-3.9.017 step 1 invariant)**: the filename value in each part's `Content-Disposition` header MUST be `Path::file_name(<FILE>)` — the basename of the supplied file path, no directory components. Jira derives `attachment.filename` from this value verbatim (the attachment list response's `filename` field equals whatever was sent in `Content-Disposition`). The `--replace-existing` step 1 match (BC-3.9.017) depends on this invariant: `attachment.filename == basename(<FILE>)`. The SEC-576-004 CRLF-safety test below applies to this basename value.

**Result**: PRESENT and CORRECT ✓

#### BC-3.9.017 step-1 cross-ref

**Quote-verified verbatim** (`bc-3-issue-write.md` line 3712, step 1 body):

> 1. **List step**: `GET /rest/api/3/issue/{key}?fields=attachment` to retrieve `fields.attachment[]`. Filter entries where `attachment.filename` equals the basename of `<FILE>` (case-sensitive string equality; Jira stores filenames verbatim — the invariant that `attachment.filename == basename(<FILE>)` is pinned by BC-3.9.001's Content-Disposition filename clause).

**Result**: Cross-ref "BC-3.9.001's Content-Disposition filename clause" PRESENT ✓. Invariant string `attachment.filename == basename(<FILE>)` matches BC-3.9.001 body exactly ✓.

---

### P10-002 — render_json sentence in EC-2.7.007-7 and EC-2.7.008-6

#### EC-2.7.007-7

**Quote-verified verbatim** (`bc-2-issue-read.md` line 749, final sentence):

> **EC-2.7.007-7** (`--output json` success shape for `--id`): `{"downloaded":[{"filename":"<name>","id":"<AID>","path":"<written path>","size":N}]}`; one-element `downloaded` array; inner keys in alphabetical order (`filename` < `id` < `path` < `size`); stdout only; exit 0. `path` is the absolute or relative path actually written (per BC-2.7.010). `size` is the byte count written. No stderr output in JSON mode. Output MUST route through `output::render_json` (#526 invariant).

**Result**: `output::render_json` (#526 invariant) sentence PRESENT ✓

#### EC-2.7.008-6

**Quote-verified verbatim** (`bc-2-issue-read.md` line 778, final sentence):

> **EC-2.7.008-6** (`--output json` success shape for `--all` / `--newest N`): `{"downloaded":[{"filename":"<name>","id":"<AID>","path":"<written path>","size":N},…]}`; N-element `downloaded` array (one entry per file written; files skipped due to collision or `--filter` are NOT in the array); inner keys alphabetical; stdout only; exit 0. No stderr hints (truncation, skips) in JSON mode. Shape aligns with EC-2.7.007-7 for a uniform download response type. Output MUST route through `output::render_json` (#526 invariant).

**Result**: `output::render_json` (#526 invariant) sentence PRESENT ✓

**Consistency check**: both ECs share the same terminal sentence verbatim. EC-2.7.008-6 cross-references EC-2.7.007-7 ("Shape aligns with EC-2.7.007-7 for a uniform download response type") ✓. Download exclusion note in BC-2.7.002 (`download` excluded from attachment-object shape) is correctly maintained — these ECs define a distinct `{"downloaded":[...]}` manifest shape, not an attachment-object array ✓.

---

### P10-003 — allow_negative_numbers pin in EC-2.7.009-1

**Quote-verified verbatim** (`bc-2-issue-read.md` line 802):

> **EC-2.7.009-1** (N ≤ 0 — clap parses `--newest` as a signed integer i64; app validates N ≥ 1): `--newest` MUST be declared with `allow_negative_numbers = true` so that negative values (e.g. `-5`) reach the handler as a valid i64 rather than being intercepted by clap as an unknown flag (clap exit 2). The handler validates N ≥ 1; if it finds N ≤ 0, exit 64 before any HTTP call: `"--newest requires a positive integer."` N = 0 is rejected (zero-download is ambiguous, not silently accepted).

**Result**: `allow_negative_numbers = true` pin PRESENT ✓. Logic chain: negative value → valid i64 (not clap exit 2) → handler validates N ≥ 1 → exit 64 with canonical message ✓. EC-2.7.009-2 (non-i64 → clap exit 2) present at line 803, correctly differentiating the two failure modes ✓.

---

## Standard Check Class

### Check 1: [1.3.50] in spec-changelog + prd-delta + BC-3 trace

| Surface | Expected | Observed | Status |
|---------|----------|----------|--------|
| spec-changelog.md | `## [1.3.50]` entry | `## [1.3.50] - 2026-07-16` (line 10) | PASS |
| prd-delta-576.md frontmatter | `spec_version_after: 1.3.50` | `spec_version_after: 1.3.50` (line 8) | PASS |
| bc-3-issue-write.md trace | `v1.3.50` trace entry | `v1.3.50 — P10 adversary fix round (2026-07-16, SOH-ATTACHMENTS-1): 0 new BCs — BC-3.9.001 Content-Disposition filename clause pinned (P10-001); BC-3.9.017 step 1 cross-ref added; BC count unchanged (140/30)` (line 90) | PASS |

spec-changelog [1.3.50] type is correctly classified as PATCH (0 new BCs, no holdout changes, no behavioral-contract additions — only invariant pins and code-structure requirements). ✓

### Check 2: BC count arithmetic

| File | total_bcs |
|------|----------|
| bc-1-auth-identity.md | 57 |
| bc-2-issue-read.md | 106 |
| bc-3-issue-write.md | 140 |
| bc-4-assets-cmdb.md | 32 |
| bc-5-boards-sprints.md | 36 |
| bc-6-config-cache.md | 43 |
| bc-7-output-render.md | 93 |
| cross-cutting.md | 150 |
| **Sum** | **657** ✓ |

BC-INDEX.md `total_bcs: 657` ✓ | CANONICAL-COUNTS.md Sum `657` ✓ | prd-delta `bc_count_after: 657` ✓

### Check 3: Holdout count

`holdout-scenarios.md` frontmatter `total_holdouts: 96` ✓

`grep -c "^### H-"` → 96 (confirmed) ✓

CANONICAL-COUNTS.md canonical holdout total: 96 ✓

### Check 4: bc-3 frontmatter integrity

| Field | Expected | Observed | Status |
|-------|----------|----------|--------|
| `total_bcs` | 140 | 140 | PASS |
| `definitional_count` | 111 | 111 | PASS |
| `last_updated` | 2026-07-16 | 2026-07-16 | PASS |
| `v1.3.50` trace entry | present | present (line 90) | PASS |

### Check 5: BC-INDEX Section 3.9 row count

BC-INDEX Section 3.9 header: "20 BCs: BC-3.9.001..020" ✓
20 table rows for BC-3.9.001..BC-3.9.020 confirmed ✓. No P10 row updates required (P10 added text to existing BC bodies; no new BC rows, no row-title changes). ✓

### Check 6: Worklog P10 round tracking

Round P10 entry present in `prd-delta-576-worklog.md`:

```
### Round P10 — 2026-07-16
| P10-001 | LOW | APPLIED | BC-3.9.001 gains Content-Disposition filename clause...
| P10-002 | LOW | APPLIED | EC-2.7.007-7 and EC-2.7.008-6 (download manifest JSON paths) gain...
| P10-003 | INFO | APPLIED | EC-2.7.009-1: --newest pinned with allow_negative_numbers = true...
```

All three findings marked APPLIED ✓.

Changelog-sync note in worklog: "v1.3.50 PATCH entry inserted in `spec-changelog.md`; `prd-delta-576.md` `spec_version_after` → 1.3.50; bc-3-issue-write.md frontmatter: v1.3.50 trace prepended + `_Last updated` prepended." ✓

### Check 7: Holdout ↔ BC coherence

P10 changes are invariant pins (Content-Disposition basename, render_json obligation, clap allow_negative_numbers) — none introduces a new user-visible behavioral branch requiring a new holdout scenario.

- H-NEW-ATTACHMENT-002 (download single-id, write-to-temp): tests human mode; EC-2.7.007-7 covers `--output json` mode only. No holdout update required for P10-002. ✓
- H-NEW-ATTACHMENT-004 (upload + --replace-existing): P10-001 pins the Content-Disposition invariant underpinning BC-3.9.017 step 1. Holdout tests the behavioral outcome (replace-then-upload ordering), not the multipart Content-Disposition header value. No holdout update required. ✓
- No holdout tests `--newest` with a negative N value; EC-2.7.009-1's allow_negative_numbers pin is a clap-config invariant, not a new user-scenario branch. No holdout update required for P10-003. ✓

holdout count confirmed unchanged at 96 across spec-changelog, prd-delta, holdout-scenarios frontmatter, and CANONICAL-COUNTS. ✓

### Check 8: Contradiction scan

| Citation | Target | Resolves? |
|---------|--------|----------|
| BC-3.9.017 step 1 → "BC-3.9.001's Content-Disposition filename clause" | BC-3.9.001 line 3262 | YES ✓ |
| BC-3.9.001 Content-Disposition → "BC-3.9.017 step 1 match depends on this invariant" | BC-3.9.017 step 1 | YES ✓ (bidirectional, consistent) |
| EC-2.7.007-7 → `output::render_json` (#526 invariant) | BC-7.3.010 / CLAUDE.md JSON render invariant | RESOLVES ✓ |
| EC-2.7.008-6 → "Shape aligns with EC-2.7.007-7" | EC-2.7.007-7 | YES ✓ (shapes match identically) |
| EC-2.7.009-1 exit 64 string `"--newest requires a positive integer."` | standalone (no cross-ref) | CONSISTENT ✓ |

No contradictions found.

### Check 9: BC-INDEX and CANONICAL-COUNTS dates

`BC-INDEX.md` `last_updated: 2026-07-15`, `index_version: v6.14`. P10 added 0 new BC rows; BC-INDEX is not updated on body-text-only changes. Same convention as P7/P8/P9. ✓

`CANONICAL-COUNTS.md` `last_verified: "2026-07-15"`. Same reasoning — count claims (657 total) remain accurate; file not updated on 0-BC-count changes. ✓

---

## Findings (non-blocking)

### GAP-R20-001 (INFO) — spec-changelog [1.3.50] Changes omits prd-delta-576.md

**Surface**: `spec-changelog.md` [1.3.50] `**Changes**:` list  
**Description**: The `**Changes**:` list records modifications to `bc-3-issue-write.md` and `bc-2-issue-read.md` only. It does not record that `prd-delta-576.md` was also modified (`spec_version_after` → 1.3.50). The worklog confirms the update was made (worklog changelog-sync note). The prd-delta frontmatter IS at 1.3.50.  
**Precedent**: Same omission pattern in [1.3.48] and [1.3.49]. Accepted as-is in r17, r18, r19 (r19 verdict CONSISTENT).  
**Impact**: Zero behavioral impact. prd-delta housekeeping updates are tracked in the worklog.  
**Action**: None required.

### GAP-R20-002 (INFO) — bc-3 trace ordering for P10/P9/P8 sub-block

**Surface**: `bc-3-issue-write.md` frontmatter `trace:` block, lines 89-92  
**Description**: The three most-recent trace entries appear at the end of the trace block in this order: v1.3.47 (line 89), v1.3.50 (line 90), v1.3.49 (line 91), v1.3.48 (line 92). The sub-block v1.3.50/v1.3.49/v1.3.48 is in descending version order but sits at the end of the trace list (after older entries at lines 84-89). The overall trace block is therefore not in monotone version order.  
**Precedent**: Present from P8 onward. Accepted in r17/r18/r19 (r19 CONSISTENT).  
**Impact**: Zero behavioral consequence. Trace is informational.  
**Action**: None required.

---

## Observations (non-blocking, pre-existing)

### OBS-R20-001 — EC-2.7.007-8 appears before EC-2.7.007-7 in bc-2-issue-read.md

EC-2.7.007-8 (concurrent-downloads note, line 748) appears one line before EC-2.7.007-7 (`--output json` shape, line 749). The two ECs are numbered out of order in the file. This is pre-existing (P10 added the render_json sentence to the existing EC-2.7.007-7 body; it did not move the EC). The out-of-order placement was present at r19 and not flagged. EC content is correct in both; behavioral impact is zero.

---

## Conclusion

**VERDICT: CONSISTENT**

Spec v1.3.50 (657 BCs / 96 holdouts) is consistent post-P10 remediation. All four P10 priority check areas are fully closed with verbatim quote verification:

1. **P10-001** — BC-3.9.001 gains the Content-Disposition filename clause (`Path::file_name(<FILE>)` basename invariant). BC-3.9.017 step 1 gains the cross-ref "the invariant that `attachment.filename == basename(<FILE>)` is pinned by BC-3.9.001's Content-Disposition filename clause." The two clauses are bidirectionally consistent.

2. **P10-002** — EC-2.7.007-7 and EC-2.7.008-6 both carry the terminal sentence "Output MUST route through `output::render_json` (#526 invariant)." These were the only two download-manifest JSON paths without it. The download manifest shape (`{"downloaded":[...]}`) is correctly excluded from the attachment-object authority in BC-2.7.002.

3. **P10-003** — EC-2.7.009-1 carries the `allow_negative_numbers = true` clap pin. Without this flag, a negative `--newest` value (e.g. `-5`) would be intercepted by clap as an unknown flag (exit 2) rather than reaching the handler for the exit-64 path. EC-2.7.009-2 correctly covers the non-i64 clap-parse-failure path (exit 2), differentiating it from the handler-validated path.

4. **[1.3.50] presence** — `## [1.3.50]` present in spec-changelog (line 10, type PATCH); `spec_version_after: 1.3.50` present in prd-delta frontmatter (line 8); `v1.3.50` trace entry present in bc-3-issue-write.md frontmatter (line 90). All three surfaces confirmed verbatim.

Two INFO-level annotation gaps (GAP-R20-001 and GAP-R20-002) are continuations of patterns accepted since r17; neither is a behavioral gap and no action is required.

---
