---
document_type: consistency-report
round: 21
spec_version: 1.3.51
date: 2026-07-16
validator: cv-f2-576-r21 (fresh context, no prior round visibility)
verdict: CONSISTENT
bc_count: 657
holdout_count: 96
priority_checks: P11-001 (BC-2.7.008 fail-soft-continue policy + EC-2.7.008-6/7/8 + BC-2.7.009 cross-ref + BC-2.7.012 qualifiers + H-NEW-ATTACHMENT-003 Call B), P11-002 (EC-2.7.007-9 + EC-2.7.008-9 + CLI flags clause)
level: ops
version: "1.0"
status: pass
producer: cv-f2-576-r21
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
input-hash: "c4f8255"
traces_to: ".factory/specs/prd/BC-INDEX.md"
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 21 (post-P11 remediation)

**Spec version**: 1.3.51 | **BCs**: 657 | **Holdouts**: 96 | **Verdict**: CONSISTENT

---

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) — SOH-ATTACHMENTS-1 F2 |
| **Generated** | 2026-07-16T00:00:00 |
| **Generator** | cv-f2-576-r21 (fresh-context consistency validator, round 21) |
| **Artifacts Scanned** | 8 (bc-2-issue-read.md, bc-3-issue-write.md, holdout-scenarios.md, prd-delta-576.md, prd-delta-576-worklog.md, BC-INDEX.md, CANONICAL-COUNTS.md, spec-changelog.md) |
| **Focus** | Post-P11 adversary-pass remediation verification — spec v1.3.51 |
| **Prior round** | consistency-report-576-r20.md (CONSISTENT at v1.3.50) |

---

## Summary

| # | Check | Result |
|---|-------|--------|
| P11-001a | BC-2.7.008 fail-soft-continue policy paragraph (fail-soft-continue) | pass |
| P11-001b | EC-2.7.008-6 updated (exit-1 + valid-stdout combination) | pass |
| P11-001c | EC-2.7.008-7 (some-fail-some-succeed exit 1 + partial manifest) | pass |
| P11-001d | EC-2.7.008-8 (all-fail exit 1 + empty array) | pass |
| P11-001e | BC-2.7.009 cross-reference to BC-2.7.008 fail-soft policy | pass |
| P11-001f | BC-2.7.012 5xx/network rows single-vs-batch qualifiers | pass |
| P11-001g | H-NEW-ATTACHMENT-003 Call B (500-fixture, fail-soft assertions) | pass |
| P11-002a | EC-2.7.007-9 (--out requires --id, clap `requires`) | pass |
| P11-002b | EC-2.7.008-9 (--out-dir requires --all or --newest, clap `requires_one_of`) | pass |
| P11-002c | BC-2.7.007 CLI flags clause notes both requires bindings | pass |
| — | [1.3.51] in spec-changelog + prd-delta | pass |
| — | Counts / Versions / Stale Markers (657 BCs / 96 holdouts) | pass |
| — | Batch fail-soft vs single-mode — no conflicting outcomes for same request shape | pass |
| — | Exit code story coherence (0/1/2/64/130 each has exactly one trigger set) | pass (1 INFO) |
| — | Holdout ↔ BC coherence | pass |
| — | Contradiction scan | pass |

All 16 check areas pass. Three INFO-level annotation gaps found; none are behavioral gaps.

---

## Priority Check Closure Table

### P11-001a — BC-2.7.008 fail-soft-continue policy paragraph

**Quote-verified verbatim** (`bc-2-issue-read.md` line 773):

> **Per-file download error policy (fail-soft-continue)**: A per-file content-GET failure (403, 404, 5xx, network error, or mid-stream abort on `GET /rest/api/3/attachment/content/{id}`) on a batch path (`--all` / `--newest`) does NOT abort the batch. For each failed file: (1) a stderr warning is emitted: `"warning: failed to download attachment <AID>: <reason>"`; (2) any in-progress temporary file for that attachment is deleted (same temp-delete mechanics as EC-2.7.007-4 for the single-ID path); (3) the failed attachment is excluded from the `downloaded` array in JSON mode and from the N count in the summary. The batch continues with the remaining attachments. **Final exit code**: 0 if all files succeeded; 1 if ANY file failed (including all-fail). In `--output json` mode on partial failure, the manifest is still emitted to stdout (partial `downloaded` array) while exit code is 1 — callers MUST NOT assume a non-zero exit code implies no stdout output on download commands.

**Result**: PRESENT and CORRECT ✓

---

### P11-001b — EC-2.7.008-6 updated (exit-1 + valid-stdout combination stated)

**Quote-verified verbatim** (`bc-2-issue-read.md` line 782):

> **EC-2.7.008-6** (`--output json` success shape for `--all` / `--newest N`): `{"downloaded":[{"filename":"<name>","id":"<AID>","path":"<written path>","size":N},…]}`; N-element `downloaded` array (one entry per file written; files skipped due to collision or `--filter` are NOT in the array); inner keys alphabetical; stdout only; exit 0 (all succeeded) or exit 1 (partial failure — per EC-2.7.008-7/8; the manifest is still emitted even when exit code is 1). No stderr hints (truncation, skips) in JSON mode. Shape aligns with EC-2.7.007-7 for a uniform download response type. Output MUST route through `output::render_json` (#526 invariant).

**Result**: "exit 0 (all succeeded) or exit 1 (partial failure — per EC-2.7.008-7/8; the manifest is still emitted even when exit code is 1)" PRESENT ✓. `output::render_json` (#526 invariant) sentence PRESENT ✓.

---

### P11-001c — EC-2.7.008-7 (some-fail-some-succeed exit 1 + partial manifest)

**Quote-verified verbatim** (`bc-2-issue-read.md` line 786):

> **EC-2.7.008-7** (some-fail-some-succeed — fail-soft exit code): if one or more content-GET/stream steps fail while others succeed, exit code is 1; `downloaded` array in JSON mode contains only the successful entries (failed attachments excluded); stderr per-file warnings emitted for each failure; summary prints actual `N` of `M` where N < M. Temp file deleted per failure (EC-2.7.007-4 mechanics).

**Result**: PRESENT and CORRECT ✓. Partial manifest (failed entries excluded from array), exit 1, per-file warnings, summary "N of M" form — all stated.

---

### P11-001d — EC-2.7.008-8 (all-fail exit 1 + empty array)

**Quote-verified verbatim** (`bc-2-issue-read.md` line 788):

> **EC-2.7.008-8** (all-fail): if every content-GET step fails, exit 1; `downloaded` array is empty (`[]`) in JSON mode; summary prints `"Downloaded 0 of M attachments to <dir>."` Per-file stderr warnings still emitted for each failure.

**Result**: PRESENT and CORRECT ✓. Empty array, exit 1, per-file warnings — all stated.

---

### P11-001e — BC-2.7.009 cross-reference to BC-2.7.008 fail-soft policy

**Quote-verified verbatim** (`bc-2-issue-read.md` line 810):

> `--newest N` is mutually exclusive with `--id` (clap `conflicts_with` → exit 2). `--newest N` combined with `--all` is rejected (clap `conflicts_with` → exit 2). Overwrite and `--force` behavior follow BC-2.7.007/BC-2.7.008. Per-file content-GET errors on `--newest` batch downloads follow BC-2.7.008's fail-soft-continue policy (EC-2.7.008-7/8): per-file warning + temp-delete + continue; exit 1 if any file failed.

**Result**: "BC-2.7.008's fail-soft-continue policy (EC-2.7.008-7/8): per-file warning + temp-delete + continue; exit 1 if any file failed" PRESENT ✓. Cross-reference is explicit and correctly cites both EC-2.7.008-7 and EC-2.7.008-8.

---

### P11-001f — BC-2.7.012 single-vs-batch qualifiers on 5xx/network rows

**Quote-verified verbatim** (`bc-2-issue-read.md` lines 923–924):

> | KEY or AID 5xx | 1 | `API error (<N>)` (single mode; batch mode: per-file fail-soft per BC-2.7.008) |
> | Network error | 1 | Connectivity hint (single mode; batch mode: per-file fail-soft per BC-2.7.008) |

**Result**: "(single mode; batch mode: per-file fail-soft per BC-2.7.008)" qualifier PRESENT on both 5xx and Network rows ✓.

---

### P11-001g — H-NEW-ATTACHMENT-003 Call B (500-fixture, fail-soft assertions)

**Quote-verified verbatim** (`holdout-scenarios.md` lines 2169–2188):

Call B setup (partial-failure):
> **Call B setup (partial-failure — one content-GET returns 500)**:
>
> 1. Wiremock at `JR_BASE_URL`. Config with a valid profile at `JR_CONFIG_DIR`. Temp directory `OUT_DIR_B` (empty).
> 2. Wiremock mounts `GET /rest/api/3/issue/FOO-5?fields=attachment` returning two attachments:
>    - `{"id":"20020","filename":"ok.txt","size":3,...}` — content GET `GET /rest/api/3/attachment/content/20020` returns 200 + 3 bytes `AAA`.
>    - `{"id":"20021","filename":"fail.txt","size":3,...}` — content GET `GET /rest/api/3/attachment/content/20021` returns 500.
> 3. No per-attachment metadata GETs mounted (batch path skips step-1 per BC-2.7.008).

Expected B (fail-soft assertions):
> **Expected B (MUST-PASS)**:
> - Exit code = 1 (any file failed → fail-soft exit 1 per BC-2.7.008 EC-2.7.008-7).
> - `OUT_DIR_B` contains exactly 1 file (the `ok.txt` entry; `fail.txt` was not written).
> - The successful file MUST carry a SHA-1 prefix (`<sha1("20020")>_ok.txt`) and contain bytes `AAA`.
> - stderr contains a per-file warning for attachment `20021` matching `"warning: failed to download attachment 20021: ..."`.
> - stderr summary: `"Downloaded 1 of 2 attachments to <OUT_DIR_B>."`.
> - In JSON mode (Action B `--output json`): exit 1; stdout `{"downloaded":[{"filename":"<sha1-of-20020>_ok.txt","id":"20020","path":"<path>","size":3}]}`; the `fail.txt` entry (`"id":"20021"`) is absent from `downloaded`; the JSON manifest is emitted despite exit 1 (exit-1 + valid-stdout combination per EC-2.7.008-7). Output routes through `output::render_json` (#526).
> - An implementation that either (a) aborts the batch on the 500 or (b) includes `"id":"20021"` in `downloaded` MUST FAIL this assertion.

**Result**: Call B PRESENT and CORRECT ✓. All fail-soft assertions cross-check with EC-2.7.008-7 body verbatim. "exit-1 + valid-stdout combination per EC-2.7.008-7" citation PRESENT ✓. No per-attachment metadata GET mounted (correctly reflects batch-path skip of step-1 per BC-2.7.008) ✓.

---

### P11-002a — EC-2.7.007-9 (--out requires --id)

**Quote-verified verbatim** (`bc-2-issue-read.md` line 751):

> **EC-2.7.007-9** (`--out` without `--id` — clap binding): `--out <PATH>` MUST be declared with `requires = "id"` (clap `requires` → exit 2 when `--out` is supplied without `--id`). `--out` combined with `--all` or `--newest` is invalid: batch downloads write to a directory (`--out-dir`), not a single file path.

**Result**: PRESENT and CORRECT ✓. Clap `requires = "id"` binding stated, exit 2 on violation, reason for constraint given.

---

### P11-002b — EC-2.7.008-9 (--out-dir requires --all or --newest)

**Quote-verified verbatim** (`bc-2-issue-read.md` line 790):

> **EC-2.7.008-9** (`--out-dir` without `--all` or `--newest` — clap binding): `--out-dir` MUST be declared with `requires_one_of(["all", "newest"])` (clap `requires_one_of` → exit 2 when `--out-dir` is supplied without either `--all` or `--newest`). Supplying `--out-dir` with `--id` is invalid: a single-file download writes to an explicit `--out <PATH>` or defaults to the current directory.

**Result**: PRESENT and CORRECT ✓. Clap `requires_one_of(["all", "newest"])` binding stated, exit 2 on violation, rationale given.

---

### P11-002c — BC-2.7.007 CLI flags clause (both requires bindings noted)

**Quote-verified verbatim** (`bc-2-issue-read.md` line 755):

> **CLI flags** (pinned for e2e surface guard): `<KEY>` (positional, required); `--id <AID>` (single download); `--all` (batch); `--newest <N>` (top-N); `--out <PATH>` (single-file path override; requires `--id`, clap `requires` — EC-2.7.007-9); `--out-dir <DIR>` (batch target directory; requires `--all` or `--newest`, clap `requires_one_of` — EC-2.7.008-9); `--force` (overwrite existing); `--filter <FILTER>` (repeatable); `--output json`; `--no-input`; `--profile <NAME>`; `--no-color`.

**Result**: Both bindings PRESENT ✓. "requires `--id`, clap `requires` — EC-2.7.007-9" and "requires `--all` or `--newest`, clap `requires_one_of` — EC-2.7.008-9" citations correct ✓.

---

### [1.3.51] Changelog + prd-delta presence

**spec-changelog.md** (`spec-changelog.md` line 10):

> ## [1.3.51] - 2026-07-16
>
> ### Type: MINOR
>
> **Summary**: Adversary pass 11 (P11) fix round — batch download fail-soft-continue policy defined; --out/--out-dir clap bindings pinned; H-NEW-ATTACHMENT-003 Call B added.

**prd-delta-576.md** (frontmatter):

> spec_version_after: 1.3.51

**Result**: [1.3.51] PRESENT in both spec-changelog and prd-delta ✓. Summary in changelog accurately reflects P11-001 and P11-002 changes ✓. `bc_count` = 657 (unchanged), `holdout_count` = 96 (unchanged) per spec-changelog impact table ✓.

---

## Batch Fail-soft vs Single-mode Error Taxonomy — No Conflicting Outcomes

Systematic check: for each combination of (request shape, error type), verify the same condition does not produce different prescribed outcomes across BC-2.7.007/008/009/012.

| Request shape | Error type | BC-2.7.007 single outcome | BC-2.7.008/009 batch outcome | Conflict? |
|---|---|---|---|---|
| `--id`, metadata 404 | AID not found | exit 64 (EC-2.7.007-1) | N/A — no metadata fetch on batch | none |
| `--id`, metadata 403 | Permission denied | exit 1 (EC-2.7.007-1b) | N/A — no metadata fetch on batch | none |
| `--id`, content-GET mid-stream error | 5xx, network, mid-stream | exit 1 (EC-2.7.007-4) | N/A — single-ID path only | none |
| `--all`/`--newest`, per-file content-GET | 5xx, network, abort | exit 1 + abort (single mode inapplicable) | fail-soft: per-file warning + temp-delete + continue; exit 1 if any failed (EC-2.7.008-7/8) | none — distinct modes |
| `--id`, SIGINT mid-stream | Ctrl+C | exit 130 (EC-2.7.007-5) | N/A | none |
| Any, issue KEY 404 | Issue not found | exit 64 (BC-2.7.012 table) | exit 64 (BC-2.7.012 table) — list-fetch failure aborts before per-file loop | none |
| Any, 401 | Not authenticated | exit 2 (BC-2.7.012 table) | exit 2 (BC-2.7.012 table) | none |

**Finding**: No path exists where batch fail-soft and single-mode error taxonomy prescribe conflicting outcomes for the same request shape. The two policies operate on mutually exclusive request shapes (`--id` vs `--all`/`--newest`). ✓

---

## Exit Code Story Coherence (0/1/2/64/130 trigger sets)

| Exit code | Trigger(s) for download commands | Source |
|---|---|---|
| 0 | All files succeeded (single or batch) | EC-2.7.007-7, EC-2.7.008-1 (empty = 0 files), EC-2.7.008-6 |
| 1 | Single: mid-stream error (EC-2.7.007-4); 403 on metadata (EC-2.7.007-1b); 5xx/network. Batch: any file failed (EC-2.7.008-7 partial; EC-2.7.008-8 all-fail) | EC-2.7.007-1b/4, EC-2.7.008-7/8, BC-2.7.012 table |
| 2 | clap conflicts (--id+--all, --newest+--id, --newest+--all); --out without --id (EC-2.7.007-9); --out-dir without --all/--newest (EC-2.7.008-9); non-integer --newest (EC-2.7.009-2); 401 (BC-2.7.012 table); no selector supplied (clap required-group) | Multiple ECs |
| 64 | KEY 404; AID 404; non-numeric AID; --out-dir not exist / not a directory; --out parent not exist; --newest N ≤ 0 | EC-2.7.007-1/6, EC-2.7.008-2/4/5, EC-2.7.009-1, BC-2.7.012 table |
| 130 | Ctrl+C / SIGINT mid-stream (single mode) | EC-2.7.007-5 |

**Finding**: Each exit code has a non-overlapping, exhaustive trigger set. Exit 1 is the widest (both single error-stop and batch fail-soft converge on 1), but the trigger conditions are mutually exclusive between modes. No two triggers map the same input to different exit codes. ✓

**INFO gap (not a behavioral contradiction)**: The BC-2.7.012 error taxonomy table row "KEY or AID 5xx" combines two logically distinct failure modes under one row: (a) a 5xx on the issue-list GET (KEY-level) aborts the batch before any per-file loop starts, producing exit 1 without fail-soft; (b) a 5xx on a per-attachment content-GET (AID-level) on the batch path triggers per-file fail-soft per EC-2.7.008-7. The "(batch mode: per-file fail-soft per BC-2.7.008)" qualifier on the row is technically correct for case (b) but potentially misleading for case (a). The exit code (1) is the same in both cases, so no behavioral conflict exists. An implementer reading this row should understand that fail-soft only applies to per-file content-GET failures, not the initial issue-list fetch. This is an INFO-level precision gap — no fix required, no behavioral contradiction.

---

## Standard Check-class Results

### Counts / Versions / Stale Markers

- BC-INDEX.md `total_bcs`: 657 ✓
- CANONICAL-COUNTS.md Sum row: 657 ✓
- holdout-scenarios.md `total_holdouts`: 96 ✓
- CANONICAL-COUNTS.md holdout count: 96 ✓
- spec-changelog.md latest entry: [1.3.51] ✓
- prd-delta-576.md `spec_version_after`: 1.3.51 ✓

### Holdout ↔ BC Coherence

H-NEW-ATTACHMENT-003 Call B cite chain verified:
- Holdout Expected B cites "BC-2.7.008 EC-2.7.008-7" ✓
- BC-2.7.008 EC-2.7.008-7 body matches holdout assertion exactly (partial manifest, failed entry excluded, exit 1) ✓
- H-NEW-ATTACHMENT-003 "BC refs" footer: "BC-2.7.008 (primary), BC-2.7.010 (collision prefix), BC-2.7.011 (sanitization pipeline), BC-2.7.008 EC-2.7.008-7 (fail-soft-continue, Call B)" ✓
- H-NEW-ATTACHMENT-003 "Why hidden" updated: "Call B exercises the fail-soft-continue policy (BC-2.7.008 EC-2.7.008-7): an implementation that aborts on the first 5xx, or includes the failed entry in the JSON manifest, would pass simple success-only tests but fail this holdout." ✓
- H-NEW-ATTACHMENT-003 "Status" updated: "Call B pins BC-2.7.008 EC-2.7.008-7 (fail-soft-continue: partial failure → exit 1, partial manifest, failed entry excluded)." ✓

### Contradiction Scan

No contradictions found. The following cross-document claims all agree:
1. fail-soft policy (BC-2.7.008 body) ↔ EC-2.7.008-7 ↔ EC-2.7.008-8 ↔ EC-2.7.008-6 (all state exit 1 on any failure, manifest emitted even on partial failure) ✓
2. BC-2.7.009 fail-soft cross-ref ↔ BC-2.7.008 policy ↔ H-NEW-ATTACHMENT-003 Call B (all agree on same fail-soft behavior for --newest) ✓
3. EC-2.7.007-9 (--out requires --id) ↔ EC-2.7.008-9 (--out-dir requires --all/--newest) — complementary, not contradictory ✓
4. BC-2.7.012 error taxonomy table ↔ individual BC EC entries — all exit codes consistent ✓

---

## INFO-level Annotation Gaps (no fix required)

### INFO-1: Double blank lines between EC-2.7.008-6 and EC-2.7.008-7

`bc-2-issue-read.md` lines 783–785 contain three consecutive blank lines (one of which is the standard paragraph separator; the additional two appear to be an artifact of the P11 patch insertion). This is a cosmetic formatting gap only. No behavioral content is missing or misrepresented.

**Disposition**: INFO — cosmetic artifact. No action required.

### INFO-2: EC-2.7.008-2 / EC-2.7.008-5 redundancy

EC-2.7.008-5 is labeled "supersedes EC-2.7.008-2 wording clarification — same exit 64: `'Output directory does not exist: <DIR>'`". Both entries prescribe identical behavior for directory-not-found. This is an annotation artifact from a prior wording-correction pass that left both entries in place.

**Quote** (`bc-2-issue-read.md` line 777):
> **EC-2.7.008-2** (directory does not exist): if `--out-dir <DIR>` is specified and the directory does not exist → exit 64 before any download: `"Output directory does not exist: <DIR>"`. The handler does NOT create the directory automatically.

**Quote** (`bc-2-issue-read.md` line 781):
> **EC-2.7.008-5** (`--out-dir` path does not exist): supersedes EC-2.7.008-2 wording clarification — same exit 64: `"Output directory does not exist: <DIR>"`.

Both produce exit 64 with the same message. The redundancy does not create conflicting prescriptions. No behavioral gap.

**Disposition**: INFO — redundant EC pair, no contradiction. No action required.

### INFO-3: BC-2.7.012 "KEY or AID 5xx" row combined scope

Described in the Exit Code Story section above. The "(batch mode: per-file fail-soft per BC-2.7.008)" qualifier on the combined "KEY or AID 5xx" row is correct for AID-level 5xx failures but does not apply to KEY-level 5xx (which aborts the batch before any per-file loop). Exit code is 1 in both cases, so no behavioral conflict exists. Purely a documentation precision gap.

**Disposition**: INFO — precision gap, not a behavioral contradiction. No action required.

---

## Verdict

**CONSISTENT**

All P11-001 and P11-002 remediation items are verbatim-verified present and correctly stated. The [1.3.51] changelog entry and prd-delta are present. No conflicting prescriptions exist between batch fail-soft and single-mode error taxonomy. The exit code story is coherent across all modes. Three INFO-level annotation gaps are identified, none of which are behavioral gaps or spec contradictions.
