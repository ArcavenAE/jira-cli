---
document_type: spec-changelog
project: "jr (jira-cli)"
---

# Spec Changelog

Track all spec version changes. Most recent version first.

## [1.3.60] - 2026-07-16

### Type: PATCH

### Summary

Adversary pass 20 (P20) fix round — MEDIUM: BC-3.9.004 wire sequence unspecified + zero holdout coverage: added Step 0 inheritance (inherits BC-3.9.003 Step 0: issue GET existence validation + BC-3.9.005 `get_or_fetch_project_meta` detection mechanism); full HTTP sequence enumerated for (a) JSM branch and (b) non-JSM OQ-9 silent no-op branch; H-NEW-ATTACHMENT-011 added (BC-3.9.004 EC-3.9.004-1 offline pin; mirrors H-NEW-ATTACHMENT-008 assertion style; P20-001); LOW: BC-3.9.014 N≤3 prompt template `, ...` removed — ≤3 variant lists ALL filenames comma-separated, no trailing ellipsis (P20-002); BC-2.7.007 `--out` unconditional step-1 clause added — step 1 always issued even when `--out` is present; rationale: pre-stream existence validation; one extra GET is the accepted cost (P20-003); impact-boundary-576.md §1.1 download row retro-annotated — `--output json` manifest to stdout (EC-2.7.007-7) documented; human mode remains no-stdout-data (P20-004); prd-delta-576.md S3/S5 Scope table BC-3.9.017 split note added — non-public `--replace-existing` ships S3; combined `--public` ECs (EC-3.9.017-11/12) are S5-realized (P20-005); VP-576-004 (attachment-object JSON transformation pin: `"self"` OMITTED, `"content"` RENAMED to `"contentUrl"`) added to BC-2.7.002; VP-576-005 (combined-gate single-prompt pin: `--replace-existing --public` ≥1 match → ONE prompt; `--yes` bypasses both; cancel → zero DELETE + zero POST) added to BC-3.9.017; VP count 33→35 (P20-006); INFO: P20-007 ledgered as BC-NUMBER-043-DUPLICATE drift item, no action.

### Changed Requirements

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED): P20-001 — BC-3.9.004 restructured with Step 0 inheritance (issue GET + `get_or_fetch_project_meta` detection, inheriting BC-3.9.003 Step 0 + BC-3.9.005 mechanism); explicit (a) JSM branch and (b) non-JSM OQ-9 silent no-op branch with full HTTP sequences enumerated; Trace updated. P20-002 — BC-3.9.014 N≤3 prompt template: `, ...` removed; `<filenameN>` placeholder added (all files listed, no ellipsis). P20-006 — VP-576-005 added after VP-576-003 in BC-3.9.017 (combined-gate single-prompt pin; anchor BC-3.9.017, cross-ref EC-3.9.017-11/12). Footer updated (VP count 33→35; P20 round note prepended). Frontmatter trace: v1.3.60 entry added.
- `.factory/specs/prd/bc-2-issue-read.md` (MODIFIED): P20-003 — BC-2.7.007 Wire path section: `--out` unconditional step-1 clause added (step 1 always issued even with `--out`; rationale: pre-stream existence validation; accepted cost one extra GET). P20-006 — VP-576-004 added after BC-2.7.002 Trace (curated attachment-object JSON transformation pin: `"self"` OMITTED and `"content"` RENAMED to `"contentUrl"` across all jr serializations; anchor BC-2.7.002, cross-ref BC-3.9.009).
- `.factory/specs/prd/holdout-scenarios.md` (MODIFIED): P20-001 — total_holdouts 98→99; body preamble 98→99; trace entry for H-NEW-ATTACHMENT-011 added; H-NEW-ATTACHMENT-011 holdout body added (BC-3.9.004 EC-3.9.004-1 offline pin: `--internal` on non-JSM → silent platform POST, exit 0, zero servicedeskapi calls; mirrors H-NEW-ATTACHMENT-008 assertion style).
- `.factory/specs/prd/CANONICAL-COUNTS.md` (MODIFIED): P20-001 — holdout total 98→99; enumeration updated to include H-NEW-ATTACHMENT-011.
- `.factory/specs/prd/BC-INDEX.md` (MODIFIED): P20-001 — BC-3.9.004 row updated (Step 0 inheritance + wire sequence for (a) JSM and (b) non-JSM branches); P20-003 — BC-2.7.007 row updated (`--out` unconditional step-1 note); `last_updated` and `index_version` v6.19→v6.20 updated (VP count 33→35, holdout 98→99 noted).
- `.factory/phase-f2-spec-evolution/prd-delta-576.md` (MODIFIED): `spec_version_after` 1.3.59→1.3.60; `holdout_count_after` 98→99; S3 row: BC-3.9.017 split note added; S5 row: BC-3.9.017 split note added; P20 dispositions section appended.
- `.factory/phase-f1-delta-analysis/impact-boundary-576.md` (MODIFIED): P20-004 — §1.1 download row retro-annotated per PHASE-DOC-RETRO-ANNOTATION pattern (superseded: delivered spec adds `--output json` manifest to stdout, EC-2.7.007-7; human mode remains no-stdout-data).

### Impact Assessment

| Artifact | Change Type | Notes |
|----------|-------------|-------|
| `bc-3-issue-write.md` | MODIFIED | BC-3.9.004 wire sequence + branches; BC-3.9.014 prompt template fix; VP-576-005; footer; frontmatter trace |
| `bc-2-issue-read.md` | MODIFIED | BC-2.7.007 --out clause; VP-576-004 |
| `holdout-scenarios.md` | MODIFIED | H-NEW-ATTACHMENT-011; total 98→99 |
| `CANONICAL-COUNTS.md` | MODIFIED | Holdout count 98→99; enumeration |
| `BC-INDEX.md` | MODIFIED | BC-3.9.004/BC-2.7.007 rows; v6.19→v6.20; VP 33→35 |
| `prd-delta-576.md` | MODIFIED | spec_version 1.3.59→1.3.60; holdout 98→99; S3/S5 split notes; P20 dispositions |
| `impact-boundary-576.md` | MODIFIED | §1.1 download row retro-annotation |

| Dimension | Value |
|---|---|
| BC count | 657 (unchanged) |
| Holdout count | 98→99 (+1 H-NEW-ATTACHMENT-011) |
| VP count | 33→35 (+2: VP-576-004, VP-576-005) |
| Spec version | 1.3.59→1.3.60 |

---

## [1.3.59] - 2026-07-16

### Type: PATCH

### Summary

Adversary pass 19 (P19) fix round — MEDIUM: BC-2.7.002 canonical attachment-object JSON shape pinned as BTreeMap-alphabetical at all depths; example reordered and ordering clause added (P19-001); LOW: EC-2.7.001-2 filter-count hint JSON-mode clause added citing empirical house behavior in `handle_list`/`handle_view`; deliberate asymmetry with EC-2.7.001-1 zero-attachment hint documented (P19-002); EC-2.7.007-5 SIGINT cleanup downgraded to best-effort MUST with tokio ctrl_c implementation note (P19-003); BC-3.9.001 `--dry-run` CLI-flags entry annotated with clap-requires constraint (P19-004); INFO: BC-3.9.001 4-column vs 6-column table asymmetry documented (P19-I1); P19-I2 pre-existing duplicate BC-2.4.043/BC-2.5.043 recorded as spec-maintenance drift (no action).

### Changed Requirements

- `.factory/specs/prd/bc-2-issue-read.md` (MODIFIED): P19-001 — BC-2.7.002 title updated to alphabetical key order (`{author, contentUrl, created, filename, id, mimeType, size}`); JSON example reordered; BTreeMap-canonical ordering clause + implementation consequence note added. BC-2.7.007 curated-fields cross-reference updated to alphabetical order. P19-002 — EC-2.7.001-2 extended with explicit JSON-mode clause (hint fires in all modes, mirroring `src/cli/issue/list.rs::handle_list` ~line 580 empirical behavior) + asymmetry explanation vs EC-2.7.001-1. P19-003 — EC-2.7.007-5 downgraded from bare MUST to best-effort MUST; implementation note citing `src/main.rs:~393` tokio ctrl_c select! arm; Drop-guard inapplicability noted; not holdout/VP-pinned noted.
- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED): P19-004 — BC-3.9.001 CLI-flags `--dry-run` annotated with `(requires --replace-existing — EC-3.9.020-6, clap requires, exit 2)`; Trace updated. P19-I1 — BC-3.9.001 human-table spec note added: 4-column upload echo deliberately differs from 6-column list table. P19-001 — BC-3.9.009 body key enumeration updated to alphabetical order with P19-001 citation.
- `.factory/specs/prd/BC-INDEX.md` (MODIFIED): BC-2.7.002 row (P19-001 alphabetical key order); BC-3.9.001 row (P19-004 --dry-run annotation; P19-I1 4-column note); BC-3.9.009 row (P19-001 key order); `last_updated` and `index_version` v6.18→v6.19 updated.
- `.factory/phase-f2-spec-evolution/prd-delta-576.md` (MODIFIED): GAP-P19-FWD-001 — `spec_version_after` 1.3.58→1.3.59; P19 fix-round finding dispositions section appended.
- `.factory/phase-f1-delta-analysis/impact-boundary-576.md` (MODIFIED): INFO-15 — BC-3.9.004 row annotated: key order is illustrative; shape INCONCLUSIVE pending S5 live capture; if curated per BC-2.7.002, BTreeMap-alphabetical applies.

### Impact Assessment

| Artifact | Change Type | Notes |
|----------|-------------|-------|
| `bc-2-issue-read.md` | MODIFIED | BC-2.7.002 key order + clause; EC-2.7.001-2 JSON-mode; EC-2.7.007-5 best-effort |
| `bc-3-issue-write.md` | MODIFIED | BC-3.9.001 CLI flags + table note; BC-3.9.009 key order |
| `BC-INDEX.md` | MODIFIED | Three row syncs; v6.18→v6.19 |
| `prd-delta-576.md` | MODIFIED | spec_version_after 1.3.58→1.3.59; P19 dispositions section |
| `impact-boundary-576.md` | MODIFIED | BC-3.9.004 row INCONCLUSIVE annotation |

| Dimension | Value |
|---|---|
| BC count | 657 (unchanged) |
| Holdout count | 98 (unchanged) |
| VP count | 33 (unchanged) |
| Spec version | 1.3.58→1.3.59 |

---

## [1.3.58] - 2026-07-16

### Type: PATCH

**Summary**: Adversary pass 18 (P18) fix round — HIGH: attachment upload cancel row label scoped to interactive-only (P18-001); MEDIUM: three 403 canonical-string override rows added to error-taxonomy.md for attachment list/download/delete pre-prompt metadata-GET (P18-002); R3.14 retro-annotated in impact-boundary-576.md; LOW: EC-2.7.003-2 "clap-or-" removed (P18-003); BC-2.7.010 path-non-determinism ruling + EC-2.7.007-7/EC-2.7.008-6 cross-refs (P18-004); holdout group taxonomy note + Group 8b dedup heading (P18-005); INFO: JSON Output Shape Contracts table header S1–S5 pending note (P18-I1); ADR-0017 §Decision item 3 io-util/io feature annotation (P18-I2).

**Changes**:

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED): P18-001 — attachment upload cancel row label: removed "or non-interactive without `--yes`" clause (non-interactive path exits 64, not the cancel shape); scoped to "(cancel — interactive 'n' or empty)". P18-I1 — JSON Output Shape Contracts table header: added parenthetical "(attachment rows pending S1–S5 delivery — spec-only today)".
- `.factory/specs/prd/bc-2-issue-read.md` (MODIFIED): P18-003 — EC-2.7.003-2: "clap-or-application pre-flight check" → "application pre-flight check" (clap value_parser rejects at exit 2, not 64; the validation is application-level). P18-004 — EC-2.7.007-7: `path` description updated to "as-constructed by jr — NOT canonicalized, NOT made absolute". EC-2.7.008-6: same cross-reference added. BC-2.7.010 Trace: added path-non-determinism ruling paragraph (P18-004 pin).
- `.factory/specs/prd/error-taxonomy.md` (MODIFIED): P18-002 — three 403 override rows added after comment-family 403 row: `403 — attachment list` (BC-2.7.006; exit 1; canonical issue string); `403 — attachment download` (BC-2.7.012/EC-2.7.007-1b; exit 1; canonical issue or attachment string); `403 — attachment delete pre-prompt metadata-GET` (BC-3.9.015; exit 1; canonical attachment string).
- `.factory/phase-f1-delta-analysis/impact-boundary-576.md` (MODIFIED): P18-002 — R3.14 disposition row for error-taxonomy.md retro-annotated: "all 403/404 divergences" claim corrected; three missing 403 rows (list/download/delete pre-prompt) were absent until P18-002.
- `.factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md` (MODIFIED): P18-I2 — §Decision item 3: feature note added: `io-util` transitively enables `io`; `io` alone is the minimal feature flag for `ReaderStream`; implementer may use either.
- `.factory/specs/prd/holdout-scenarios.md` (MODIFIED): P18-005 — taxonomy note added near top: group numbers are historical non-contiguous identifiers; groups 16–18 unused/reserved; do NOT renumber. Second "## Group 8" header retitled "## Group 8b: CI Citation Guard" to resolve duplicate heading. CANONICAL-COUNTS.md Group 8b reference updated.
- `.factory/specs/prd/CANONICAL-COUNTS.md` (MODIFIED): P18-005 — "Group 8 (CI Citation Guard…)" entry retitled to "Group 8b".
- `.factory/specs/prd/BC-INDEX.md` (MODIFIED): TWIN-ARTIFACT-SWEEP — BC-2.7.003 row (P18-003); BC-2.7.006 row (P18-002 403 taxonomy); BC-2.7.010 row (P18-004 path-non-determinism); BC-2.7.012 row (P18-002 403 taxonomy); BC-3.9.015 row (P18-002 403 taxonomy). `last_updated` and `index_version` v6.17→v6.18 updated.

**Impact**:

| Dimension | Value |
|---|---|
| BC count | 657 (unchanged) |
| Holdout count | 98 (unchanged) |
| VP count | 33 (unchanged) |
| Spec version | 1.3.57→1.3.58 |

## [1.3.57] - 2026-07-16

### Type: PATCH

**Summary**: Adversary pass 17 (P17) fix round — BC-3.9.014 Source corrected S5→S3 (P17-001); `upload_attachments`/`post_request_attachment` function names aligned in impact-boundary-576.md (P17-002); EC-3.9.003-5 extended with Step-0 suppression on `--replace-existing --public` combined path (P17-003); combined non-interactive exit-64 message added to EC-3.9.017-9 sub-variant B and BC-3.9.014 Non-interactive path section (P17-004); BC-3.9.007 EC-3.9.007-1 S3/S5 allocation note added to body and prd-delta-576.md Scope table (P17-005); upload-cancel JSON shape added to JSON Output Shape Contracts table (P17-006); EC-2.7.009-1 annotated with `Arg::allow_negative_numbers` clap 4.6.1 confirmation (P17-007).

**Changes**:

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED): P17-001 — BC-3.9.014 Source field: `::handle_attachment_upload (pending story S5)` → `src/cli/issue/attachments.rs (pending story S3, gate mechanics; consumed by S5 --public/combined per R3.13)`. P17-003 — EC-3.9.003-5 extended with Step-0 suppression clause: when BC-3.9.003 entered from BC-3.9.017 step 4, Step 0 (issue GET) SKIPPED — existence already validated by BC-3.9.017 step 1's `?fields=attachment` GET; ONE issue GET per invocation on combined path. P17-004a — EC-3.9.017-9 rewritten with two sub-variants: (A) no `--public` → existing message; (B) combined `--public` + ≥1 match → `"Use --yes to confirm uploading as customer-visible (public) and deleting existing same-filename attachments."` P17-004b — BC-3.9.014 Non-interactive path section extended with three message variants enumerated (symmetric with three interactive prompt variants). P17-005 — BC-3.9.007 EC-3.9.007-1 extended with allocation note (exercised in S3; S5 owns EC-3.9.007-2). P17-006 — Upload cancel row added to JSON Output Shape Contracts table (`{"cancelled":true,"uploaded":false}`; BC-3.9.003/014/017). Footer updated with P17 round note.
- `.factory/specs/prd/bc-2-issue-read.md` (MODIFIED): P17-007 — EC-2.7.009-1 annotated with `(arg-level \`Arg::allow_negative_numbers\`, clap 4 — verified against docs.rs 4.6.1, P17-007)`.
- `.factory/phase-f1-delta-analysis/impact-boundary-576.md` (MODIFIED): P17-002 — §1.1 table: `upload_attachment` → `upload_attachments`; SQ-3 prose: `upload_attachment` → `upload_attachments`; R2.1 table: `attach_to_request` → `post_request_attachment`; R3.7 full function list: `upload_attachment` → `upload_attachments`. All four sites (§1.1 table, SQ-3 prose, R2.1 table, R3.7 list) annotated "(name aligned to BC body, P17-002)".
- `.factory/phase-f2-spec-evolution/prd-delta-576.md` (MODIFIED): P17-005 — Scope table S3 row: BC-3.9.007 EC-3.9.007-1 platform-echo ships with S3 note added. S5 row: S5 owns EC-3.9.007-2 JSM echo clauses note added. `spec_version_after` 1.3.56→1.3.57. P17 fix-round finding dispositions section appended.
- `.factory/specs/prd/BC-INDEX.md` (MODIFIED): TWIN-ARTIFACT-SWEEP — BC-2.7.009 row (P17-007 annotation); BC-3.9.003 row (P17-003 Step-0 suppression); BC-3.9.007 row (P17-005 S3/S5 allocation); BC-3.9.014 row (P17-001 Source + P17-004 message variants); BC-3.9.017 row (P17-004 sub-variant B). `last_updated` updated; index_version v6.16→v6.17.

**Impact**:

| Dimension | Value |
|---|---|
| BC count | 657 (unchanged) |
| Holdout count | 98 (unchanged) |
| VP count | 33 (unchanged) |
| Spec version | 1.3.56→1.3.57 |

## [1.3.56] - 2026-07-16

### Type: PATCH

**Summary**: Adversary pass 16 (P16) fix round — error-taxonomy.md 4 new override rows (attachment list/download/delete 404, first 413 upload row); BC-3.9.014 reallocated S5→S3 (gate mechanics ship with earliest consumer); BC-3.9.003 Step 0 added (issue GET + projectTypeKey source pinned to `get_or_fetch_project_meta`); H-NEW-ATTACHMENT-007 ?fields=attachment fix; BC-3.9.015 metadata-fetch-failure clause extended (403/401/5xx); impact-boundary-576.md R3.13 + R3.14 retro-annotations.

**Changes**:

- `.factory/specs/prd/error-taxonomy.md` (MODIFIED): P16-001 — 4 new override rows added after `404 — comment delete/edit/view` row: (1) `404 — attachment list` (issue KEY): read-path canonical string only; BC-2.7.006. (2) `404 — attachment download` (KEY or AID): canonical string only; BC-2.7.012/EC-2.7.007-1. (3) `404 — attachment delete` (split two-sub-case row): DELETE 404 → canonical + Jira body surfaced (DEC-168; BC-3.9.008/BC-3.9.013); pre-prompt metadata-GET 404 → canonical only (BC-3.9.015); multi/bulk/`--replace-existing` 404 → benign-skip exception (BC-3.9.013). (4) `413 — attachment upload` (first 413 row in product): `"Attachment too large: the file exceeds the server-configured limit."` exit 1; BC-3.9.001/BC-3.9.012. `last_updated` updated to 2026-07-16. P16-001 F2 amendment trace added.
- `.factory/phase-f2-spec-evolution/prd-delta-576.md` (MODIFIED): P16-002 — Scope table BC-3.9.014 reallocated S5→S3 (ORCHESTRATOR RULING): S3 row updated with BC-3.9.014 and note (gate mechanics ship with S3 as earliest consumer via BC-3.9.017 step 2; S5 consumes for `--public`/combined variants; S5 depends_on S3 edge noted for F3). S5 row updated with note referencing gate mechanics from S3. `spec_version_after` 1.3.55→1.3.56. P16 fix-round dispositions section appended.
- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED): P16-003 — BC-3.9.003: Step 0 added (`GET /rest/api/3/issue/{key}` existence validation; 404→exit 64 EC-3.9.012-2; `fields.project.key` passed to `get_or_fetch_project_meta`; projectTypeKey source pinned to `get_or_fetch_project_meta` NOT issue GET embedded fields; key-derivation asymmetry vs BC-3.9.017 step 0 documented + "deliberately equivalent" note extended). BC-3.9.003 Trace updated. P16-005 — BC-3.9.015 Metadata-fetch failure clause extended: 403→exit 1 (`"Permission denied: cannot access attachment <AID>."`); 401→exit 2 (`JrError::NotAuthenticated`; `jr auth login` hint); 5xx/network→exit 1 (§1 taxonomy). All fire before gate presentation. BC-3.9.015 Trace updated.
- `.factory/specs/prd/holdout-scenarios.md` (MODIFIED): P16-004 — H-NEW-ATTACHMENT-007 step-2 mount: `GET /rest/api/3/issue/FOO-5` → `GET /rest/api/3/issue/FOO-5?fields=attachment`. P16-003 reconciliation — H-NEW-ATTACHMENT-008 step 2 fixture wording updated (projectTypeKey from `GET /rest/api/3/project/SOFTWARE` via `get_or_fetch_project_meta`, NOT issue GET embedded fields). H-NEW-ATTACHMENT-009 step 2 fixture wording updated similarly (`GET /rest/api/3/project/EJ`).
- `.factory/phase-f1-delta-analysis/impact-boundary-576.md` (MODIFIED): P16-002 — R3.13 added (ORCHESTRATOR RULING — BC-3.9.014 S3/S5 allocation: S3 is earliest consumer via BC-3.9.017 step 2; EC-3.9.020-7 path-c `--public` annotation note; spec impact). P16-001/INFO — R3.14 added (process-gap perimeter-scan retro-annotation: error-taxonomy.md and edge-case-catalog.md omitted from F1 §3.2; inline-EC convention disposition; prevention note for future F1 scans).

**Impact**:

| Dimension | Value |
|---|---|
| BC count | 657 (unchanged) |
| Holdout count | 98 (unchanged) |
| VP count | 33 (unchanged) |
| Spec version | 1.3.55→1.3.56 |

## [1.3.55] - 2026-07-16

### Type: PATCH

**Summary**: Adversary pass 15 (P15) fix round — `--replace-existing` ≥1-match confirmation gate added (R3.12/P15-002); BC-INDEX.md 214-byte cap + en-dash fixes; BC-2.7.006 403 row; BC-2.7.007 --filter conflicts_with + directory-path EC; BC-2.7.008/009 filtered-to-zero EC; H-NEW-ATTACHMENT-010 added; holdout GET fixtures aligned to ?fields=attachment.

**Changes**:

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED): P15-002 — BC-3.9.017 step 2 completely rewritten: ≥1 same-filename match now triggers confirmation gate (DEC-174/BC-3.9.014 mechanics). EC-3.9.017-9 added (non-interactive ≥1-match no-`--yes` → exit 64; zero DELETE, zero POST). EC-3.9.017-10 added (gate fires ONLY on nonempty match; zero-match always non-interactive-safe). EC-3.9.017-11 added (combined `--public`+≥1-match → ONE combined prompt; not two gates). EC-3.9.017-12 added (`--yes` single-bypass for all gate conditions). BC-3.9.017 EC-3.9.017-8 updated (covers all cancel paths). VP-576-003 `--yes` requirement rationale updated. BC-3.9.014 heading + body expanded to THREE consumers with additional prompt variant text for replace-existing and combined paths. EC-3.9.003-5 extended to cover three BC-3.9.017 entry points (≥1-match+public, ≥1-match no-public, zero-match). EC-3.9.020-7 extended to cover ALL three gate consumers on dry-run (not just `--public`). BC-3.9.018 P15-002 zero-match alignment paragraph added. BC-3.9.017 Trace + BC-3.9.014 Trace updated. Footer updated with P15 round entry.
- `.factory/specs/prd/bc-2-issue-read.md` (MODIFIED): P15-004 — BC-2.7.007 `--filter` flag note updated + EC-2.7.007-10 added (conflicts_with "id" → exit 2). P15-005 — BC-2.7.006 error table 403 row added (Permission denied + exit 1). P15-006 — BC-2.7.007 EC-2.7.007-11 added (`--out <PATH>` naming directory → exit 64). P15-007 — BC-2.7.008 EC-2.7.008-10 added (filtered-to-zero non-empty → "No attachments matched the filter on <KEY>." + exit 0; JSON `{"downloaded":[]}`). BC-2.7.009 EC-2.7.009-3 added (same for --newest path).
- `.factory/specs/prd/BC-INDEX.md` (MODIFIED): P15-001 — BC-2.7.011 row "255-byte cap" → "214-byte cap". P15-003 — BC-3.9.005 row en-dash "–-public" → ASCII "--public". BC-3.9.017 row updated to summarise new gate. `index_version` bumped v6.14→v6.15.
- `.factory/specs/prd/holdout-scenarios.md` (MODIFIED): P15-INFO-1 — H-NEW-ATTACHMENT-001 Call A/B and H-NEW-ATTACHMENT-003 setup GET fixtures updated to `?fields=attachment` canonical form. P15-002 — H-NEW-ATTACHMENT-004 Call B Action updated to `--replace-existing --yes`; Expected B note added explaining why `--yes` is required. H-NEW-ATTACHMENT-010 added (non-interactive ≥1-match --replace-existing without `--yes` → exit 64; pins EC-3.9.017-9). Group 19 header updated ..009 → ..010. `total_holdouts` 97→98. Version 1.5.2→1.5.3. Preamble count updated 96→98. Trace line updated.
- `.factory/phase-f1-delta-analysis/impact-boundary-576.md` (MODIFIED): R3.12 section added (--replace-existing ≥1-match confirmation gate ruling; DEC-180 precedent basis; gate mechanics; spec impact summary).
- `.factory/phase-f2-spec-evolution/prd-delta-576.md` (MODIFIED): P15 fix-round section appended with all 9 finding dispositions. Frontmatter: `spec_version_after` 1.3.54→1.3.55; `holdout_count_after` 97→98.

**Impact**:

| Dimension | Value |
|---|---|
| BC count | 657 (unchanged) |
| Holdout count | 98 (+1: H-NEW-ATTACHMENT-010) |
| VP count | 33 (unchanged) |
| Spec version | 1.3.54→1.3.55 |

## [1.3.54] - 2026-07-16

### Type: PATCH

**Summary**: Adversary pass 14 (P14) fix round — EOF contradiction resolved (BC-3.9.003 three-way branch; exit 130 not exit 0); guard-precedence EC added; cancel channel corrected to stderr; BC-3.9.012 error row wording; BC-3.9.020 retitled + --dry-run gate suppression; VP-576-001..003 added; H-NEW-ATTACHMENT-009 added; impact-boundary-576.md retro-annotations.

**Changes**:

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED): P14-001 — BC-3.9.003 interactive-mode bullet rewritten as three-way branch: (a) y/yes → proceed; (b) other/empty-Enter → "Upload cancelled." on stderr + cancel JSON + exit 0; (c) EOF `Ok(0)` or IO `Err(_)` → `JrError::Interrupted` exit 130 (NOT exit 0). EC-3.9.003-4 updated (branch b, stderr). EC-3.9.003-6 added (EOF → exit 130 pin). P14-002 — EC-3.9.003-7 added: non-JSM eligibility check (BC-3.9.005) fires BEFORE non-interactive gate (guard evaluation order: JSM eligibility → interactive/non-interactive → `--yes`). P14-003 — BC-3.9.003 cancel channel corrected (stdout → stderr). EC-3.9.014-2 updated ("non-EOF branch (b)", "on stderr"). BC-3.9.015 cancel-channel divergence note added (attachment delete emits "Deletion cancelled." to stderr; comment-family table-mode emits nothing per `interactions.rs`). P14-005 — BC-3.9.012 error row trigger column: "404 on issue meta fetch" → "404 from the upload POST (platform path) or from the issue GET (`--public` / `--replace-existing` paths)". P14-007 — VP-576-002 added in BC-3.9.015 (delete gate wiremock confirm+cancel). VP-576-003 added in BC-3.9.017 (ordering invariant: DELETE before POST). Preamble + footer VP count updated 30→33. P14-009 — BC-3.9.020 path (c) gains explicit `--public` gate suppression text + EC-3.9.020-7 (gate SUPPRESSED on dry-run; preview JSON includes `"visibility":"public"` in wouldUpload). P14-010 — BC-3.9.020 retitled to "`attachment --dry-run` (delete multi-path + upload `--replace-existing`)" + Source updated. P14-011 — double `---` separator before BC-3.9.015 removed.
- `.factory/specs/prd/bc-2-issue-read.md` (MODIFIED): P14-006 — BC-2.7.001 output-channel profile line: "no stderr output when no filter is active" → "no filter-count hint on stderr when no filter is active" (removes contradiction with EC-2.7.001-1). Also: 46 pre-existing TD-031 volatile line cites converted from `:NNN` to `:~NNN` to clear hook blocker. P14-007 — VP-576-001 added in BC-2.7.011 (sanitize_attachment_filename property-based test; pins steps 1–5 and containment check).
- `.factory/specs/prd/holdout-scenarios.md` (MODIFIED): P14-001 — H-NEW-ATTACHMENT-009 added (--public EOF at confirmation prompt → exit 130, NOT exit 0; pins EC-3.9.003-6 and BC-3.9.014 branch (c)). Group 19 header updated to ..009. `total_holdouts` frontmatter: 96 → 97.
- `.factory/phase-f1-delta-analysis/impact-boundary-576.md` (MODIFIED): P14-001 — R3.11 "Scope of the reversal" paragraph retro-annotated: the claim "neither states EOF=cancel-exit-0 explicitly" was false (BC-3.9.003 DID state it; correction via P14-001). P14-004 — §2.2 BC-3.9.008 row retro-annotated (404 → exit 0 superseded by DEC-168). §2.3 NFR Idempotency row retro-annotated (same). P14-008 — §3.1 `docs/specs/attachments.md` row retro-annotated: F4 delivery obligation (not required before F2).
- `.factory/phase-f2-spec-evolution/prd-delta-576.md` (MODIFIED): P14 fix-round section appended with all 11 finding dispositions. Frontmatter: `spec_version_after` 1.3.53→1.3.54; `holdout_count_after` 96→97. Pre-existing table cell-count violation at line 70 (unescaped `|` in BC-3.9.005 row) fixed.
- `.factory/specs/prd/BC-INDEX.md` (MODIFIED): `last_updated` field updated; VP count note added (30→33).
- `.factory/specs/prd/CANONICAL-COUNTS.md` (MODIFIED): Canonical holdout total 96→97; H-NEW-ATTACHMENT-009 added to expected list; Group 19 entry updated.

**Impact**:

| Dimension | Value |
|---|---|
| BC count | 657 (unchanged) |
| Holdout count | 97 (+1: H-NEW-ATTACHMENT-009) |
| VP count | 33 (+3: VP-576-001..003) |
| Spec version | 1.3.53→1.3.54 |

## [1.3.53] - 2026-07-16

### Type: PATCH

**Summary**: Adversary pass 13 (P13) fix round — disk-write error rows relocated from BC-2.7.006 to BC-2.7.012; collision-skip NON-ERROR clause added to BC-2.7.008; BC-3.9.015 metadata-fetch 404 wording softened.

**Changes**:

- `.factory/specs/prd/bc-2-issue-read.md` (MODIFIED): P13-001 — three disk-write error rows (ENOSPC, EACCES/read-only, other OS write error) removed from BC-2.7.006's table (they are impossible on a read-only list command) and added to BC-2.7.012's download error taxonomy with the "(single mode; batch mode: per-file fail-soft per BC-2.7.008)" qualifier consistent with the 5xx/network rows. P13-002 — BC-2.7.008 Overwrite paragraph gains "Collision-skip is a NON-ERROR" clause; EC-2.7.008-6 "all succeeded" phrase updated to "all attempted downloads either succeeded or were skipped as pre-existing — collision-skips are NON-ERROR".
- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED): P13-003 — BC-3.9.015 Metadata-fetch failure paragraph softened: "mirrors BC-3.9.013 / BC-3.9.008 pre-flight guard" replaced with "aligns with the read-path 404 convention (canonical string only, per BC-2.7.012's read-vs-write divergence); differs from BC-3.9.008's DELETE 404 (canonical + Jira body per DEC-168) because the pre-prompt fetch is a read GET".
- `.factory/specs/prd/BC-INDEX.md` (MODIFIED): BC-2.7.012 description updated to list disk-write-ENOSPC/EACCES/other error classes (P13-001 relocated from BC-2.7.006).
- `.factory/phase-f2-spec-evolution/prd-delta-576.md` (MODIFIED): ADV-007 disposition line gains bracketed correction note: "originally misapplied to BC-2.7.006; relocated to BC-2.7.012 at P13-001".

**Impact**:

| Dimension | Value |
|---|---|
| BC count | 657 (unchanged) |
| Holdout count | 96 (unchanged) |
| Spec version | 1.3.52→1.3.53 |

## [1.3.52] - 2026-07-16

### Type: PATCH

**Summary**: Adversary pass 12 (P12) fix round — H-NEW-ATTACHMENT-003 Call B JSON-mode isolation fixed (fresh OUT_DIR_B2); clap `requires_one_of` replaced with correct clap-4 `ArgGroup` mechanism.

**Changes**:

- `.factory/specs/prd/holdout-scenarios.md` (MODIFIED): P12-001 — H-NEW-ATTACHMENT-003 Call B restructured: human-mode action (OUT_DIR_B) and JSON-mode action split into Call B + Call B2; Call B2 uses fresh `OUT_DIR_B2` with its own fixture mount to prevent the overwrite-refuse guard from firing on the already-written file and producing a vacuous empty-manifest assertion. Why/Status updated.
- `.factory/specs/prd/bc-2-issue-read.md` (MODIFIED): P12-002 — EC-2.7.008-9 and BC-2.7.007 CLI flags line: `requires_one_of` (clap 4 nonexistent) replaced with correct mechanism: `#[arg(requires = "batch_selector")]` where `batch_selector` is an `ArgGroup` over `[all, newest]`. First `ArgGroup` use in `jr` noted.

**Impact**:

| Dimension | Value |
|---|---|
| BC count | 657 (unchanged) |
| Holdout count | 96 (unchanged) |
| Spec version | 1.3.51→1.3.52 |

## [1.3.51] - 2026-07-16

### Type: MINOR

**Summary**: Adversary pass 11 (P11) fix round — batch download fail-soft-continue policy defined; --out/--out-dir clap bindings pinned; H-NEW-ATTACHMENT-003 Call B added.

**Changes**:

- `.factory/specs/prd/bc-2-issue-read.md` (MODIFIED): P11-001 — BC-2.7.008 gains explicit fail-soft-continue policy paragraph: per-file content-GET failure → stderr warning + temp-delete + exclude from manifest + continue; exit 0 all-succeed / exit 1 any-fail; manifest still emitted on partial failure (exit-1 + valid-stdout noted). EC-2.7.008-6 updated to clarify exit 0/1 behavior. New ECs: EC-2.7.008-7 (some-fail-some-succeed exit 1 + partial manifest), EC-2.7.008-8 (all-fail exit 1 + empty array). BC-2.7.009 gains cross-reference to BC-2.7.008 fail-soft policy. BC-2.7.012 5xx/network rows gain "(single mode; batch mode: per-file fail-soft per BC-2.7.008)" qualifier. P11-002 — EC-2.7.007-9 added: `--out` requires `--id` (clap `requires` → exit 2). EC-2.7.008-9 added: `--out-dir` requires `--all` or `--newest` (clap `requires_one_of` → exit 2). BC-2.7.007 CLI flags clause updated to note both requires bindings.
- `.factory/specs/prd/holdout-scenarios.md` (MODIFIED): H-NEW-ATTACHMENT-003 extended with Call B: one content-GET returns 500 → fail-soft exit 1 + partial manifest in JSON mode + failed entry excluded. Why/Status/BC-refs updated to reference Call B and EC-2.7.008-7.

**Impact**:

| Dimension | Value |
|---|---|
| BC count | 657 (unchanged) |
| Holdout count | 96 (unchanged) |
| Spec version | 1.3.50→1.3.51 |

## [1.3.50] - 2026-07-16

### Type: PATCH

**Summary**: Adversary pass 10 (P10) fix round — Content-Disposition filename invariant pinned; #526 render_json obligation added to download manifest EC paths; allow_negative_numbers clap pin for --newest.

**Changes**:

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED): P10-001 — BC-3.9.001 gains explicit Content-Disposition filename clause: part filename value MUST be `Path::file_name(<FILE>)` (basename); Jira derives `attachment.filename` verbatim from this value. BC-3.9.017 step 1 gains cross-ref pinning the match correctness on this invariant.
- `.factory/specs/prd/bc-2-issue-read.md` (MODIFIED): P10-002 — EC-2.7.007-7 and EC-2.7.008-6 gain "Output MUST route through `output::render_json` (#526 invariant)" sentence (the two download-manifest JSON paths previously missing it). P10-003 — EC-2.7.009-1 gains `allow_negative_numbers = true` clap pin: without it, `-5` would be intercepted as an unknown flag (clap exit 2), not reach the handler for the documented exit-64 path.

**Impact**:

| Dimension | Value |
|---|---|
| BC count | 657 (unchanged) |
| Holdout count | 96 (unchanged) |
| Spec version | 1.3.49→1.3.50 |

## [1.3.49] - 2026-07-16

### Type: MINOR

**Summary**: Adversary pass 9 (P9) fix round — anonymous author fallback chain fully specified; get_or_fetch_project_meta signature corrected; raw/curated content URL field names clarified.

**Changes**:

- `.factory/specs/prd/bc-2-issue-read.md` (MODIFIED): P9-001 — EC-2.7.001-3 extended: "(anonymous)" now fires for (a) absent/null `attachment.author` AND (b) author present but both `displayName` and `accountId` absent/null; full resolution chain documented (`displayName → accountId → "(anonymous)"`). Table footnote (Author column) updated to name all three tiers. BC-2.7.002 "Null author in JSON" gains partial-author note (no `"(anonymous)"` substitution in JSON mode — pass-through). P9-003 — BC-2.7.007 step 1 reworded to separate raw Jira API field `"content"` from `jr` curated name `"contentUrl"` (BC-2.7.002 convention); clarifies the download flow ignores the step-1 field and constructs the URL from the id.
- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED): P9-002 — BC-3.9.017 step 0: `get_or_fetch_project_meta(client, config, ...)` → correct 2-arg live signature `get_or_fetch_project_meta(client, project_key)` (profile via `client.profile_name()`; `src/api/jsm/servicedesks.rs:41`); key-derivation equivalence note added (string-prefix derivation here == `fields.project.key` in later paths; canonical single statement).
- `.factory/specs/prd/holdout-scenarios.md` (MODIFIED): P9-001 — H-NEW-ATTACHMENT-001 Call B Expected/Why/Status/BC-refs updated to cite the extended EC-2.7.001-3 exhausted-fallback-chain path (author present, `displayName` null, `accountId` absent). P9-003 — H-NEW-ATTACHMENT-002 step-2 and step-4 wiremock fixtures: `"contentUrl"` → `"content"` (raw Jira wire field name).

**Impact**:

| Dimension | Value |
|---|---|
| BC count | 657 (unchanged) |
| Holdout count | 96 (unchanged) |
| Spec version | 1.3.48→1.3.49 |

## [1.3.48] - 2026-07-16

### Type: MINOR

**Summary**: Adversary pass 8 (P8) fix round — destruction invariant generalization; sanitize→None fallback reconciliation; AID validation uniformity; holdout tightening.

**Changes**:

- `.factory/specs/prd/bc-2-issue-read.md` (MODIFIED): P8-001 — BC-2.7.011 caller contract reversed: prior "MUST skip + skip-warning" replaced by R3.10 degenerate-name fallback (write the file, not skip; single-id: bare `<id>`; batch: `<sha1>_<id>`; corrected wording for stderr note). Correction marker added.
- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED): P8-002 — BC-3.9.017 gains explicit eligibility pre-flight step 0 (non-JSM `--public` rejection derivable from key prefix + cached `get_or_fetch_project_meta`; zero DELETEs on exit 64); invariant restated to cover "confirmation gate OR eligibility guard remains unresolved". BC-3.9.005 gains `--replace-existing` path note + EC-3.9.005-3 (non-JSM `--public --replace-existing` → exit 64, zero DELETEs, zero upload, pre-flight fires). P8-003 — BC-3.9.012 400-row qualified as platform path + BC-3.9.006 cross-ref added; BC-3.9.006 step-2 4xx rationale reworded (expired temporaryAttachmentId / malformed body replaces stale-sdId). P8-004 — BC-3.9.020 single-ID dry-run gains AID `^[0-9]+$` validation bullet (fires before hint; invalid → exit 64; no hint emitted).
- `.factory/specs/prd/holdout-scenarios.md` (MODIFIED): P8-001 — H-007 extended with sanitize→None fixture (filename `".."`, batch fallback `<sha1>_<id>`, write not skip); BC refs updated. P8-005 — H-NEW-ATTACHMENT-003 + H-NEW-ATTACHMENT-007 Expected sections updated: SHA-1 prefix is UNCONDITIONAL on all batch files, not only colliding ones; assertion now rejects implementations that only SHA-1-prefix on collision.

**Impact**:

| Dimension | Value |
|---|---|
| BC count | 657 (unchanged) |
| Holdout count | 96 (unchanged — H-007 extended, not new) |
| Spec version | 1.3.47→1.3.48 |

## [1.3.47] - 2026-07-16

### Type: MINOR

### Summary

P7 adversary fix round (SOH-ATTACHMENTS-1): CWE-88 AID validation contract established across 7 attachment surfaces (delete + download); EC-3.9.018-4 gate suppression pinned; EC-3.9.003-5 extended to zero-match path; batch degenerate fallback corrected (R3.10); BC-X.8.010 self-heal language softened; GAP-R17-001 placeholder sync `<AID>`→`<VALUE>` (3 sites).

### Changes

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED): P7-001 — BC-3.9.008 AID validation paragraph; BC-3.9.013 "does NOT validate" reversed, invalid-AID table row added, EC-3.9.013-3 rewritten (zero HTTP); BC-3.9.015 AID validation preamble; BC-3.9.016 multi-AID AID validation clause; BC-3.9.020 path-b AID validation. P7-002 — BC-3.9.018 gate suppression paragraph + EC-3.9.018-4; EC-3.9.003-5 extended to zero-match path. BC-X.8.010 minor fold-in. GAP-R17-001 BC-3.9.015 placeholder `<AID>`→`<VALUE>`. Frontmatter: v1.3.47 trace entry added; `_Last updated` prepended.
- `.factory/specs/prd/bc-2-issue-read.md` (MODIFIED): P7-001 — BC-2.7.007 AID validation before wire-path step 1; BC-2.7.012 invalid-AID taxonomy row. P7-003 — BC-2.7.010 degenerate batch fallback corrected (`<sha1>_<aid>`, R3.10); batch degenerate example added. GAP-R17-001 BC-2.7.007 + BC-2.7.012 placeholders `<AID>`→`<VALUE>`. Frontmatter: `last_updated` 2026-07-15→2026-07-16.
- `.factory/specs/prd/BC-INDEX.md` (MODIFIED): rows updated for BC-2.7.007, BC-2.7.010, BC-2.7.012, BC-3.9.008, BC-3.9.013, BC-3.9.015, BC-3.9.016, BC-3.9.020 (P7-001/P7-003 notes).
- `.factory/specs/prd/cross-cutting.md` (MODIFIED): BC-X.8.010 self-heal clause softened — "no new cache FILE or cache-family functions; implementer's choice at S5".
- `.factory/specs/prd/holdout-scenarios.md` (MODIFIED): H-007 extended with malicious-AID exit-64 zero-HTTP wiremock assertion (P7-001); holdout count unchanged (96).
- `.factory/phase-f2-spec-evolution/prd-delta-576.md` (MODIFIED): `spec_version_after` 1.3.46→1.3.47.
- `.factory/spec-changelog.md` (MODIFIED): this entry.

### Impact Assessment

| Dimension | Detail |
|-----------|--------|
| BCs added | 0 |
| BCs modified | 9 (BC-3.9.008, BC-3.9.013, BC-3.9.015, BC-3.9.016, BC-3.9.018, BC-3.9.020, BC-2.7.007, BC-2.7.010, BC-2.7.012) + 2 EC extensions (EC-3.9.018-4 new, EC-3.9.003-5 extended) + 1 BC-X cross-cutting (BC-X.8.010) |
| BC count | 140 (bc-3); 657 cumulative (unchanged) |
| VP count | 30 (unchanged) |
| Holdout count | 96 (unchanged — H-007 extended, no new scenario) |
| Spec version | 1.3.46→1.3.47 |
| Severity floor | MINOR (behavioral contract added: CWE-88 AID validation) |

---

## [1.3.46] - 2026-07-16

### Type: PATCH

### Summary

GAP-R15-001 terminology sync in EC-3.5.003-3 + EC-3.5.008-5 (bc-3-issue-write.md): stale "dialoguer::Error" terminology replaced with ratified DEC-174 mechanism language (`io::stdin().lock().read_line()` returning `Ok(0)` (EOF) or `Err(_)` (IO error) → `JrError::Interrupted` exit 130). No behavioral change — exit 130 on EOF/interrupt was always the contract; only the mechanism terminology changed.

### Changes

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED): EC-3.5.003-3 heading + body reworded — "dialoguer Err → JrError::Interrupted" → "EOF / IO-error on delete prompt → JrError::Interrupted, exit 130"; `read_line` `Ok(0)`/`Err(_)` language replaces `dialoguer::Error`; `Ok(0)`-vs-`Ok(n)` distinguishability sentence added (matches EC-3.9.015-5 phrasing from P5-001); GAP-R15-001 marker added to heading. EC-3.5.008-5 same treatment. BC-3.5.003 and BC-3.5.008 Trace fields appended with GAP-R15-001 sync note. Frontmatter: `last_updated` 2026-07-15→2026-07-16; v1.3.46 trace entry added.

### Impact Assessment

| Dimension | Detail |
|-----------|--------|
| BCs added | 0 |
| BCs modified | 2 (EC-3.5.003-3, EC-3.5.008-5 — terminology only; no behavioral change) |
| BC count | 140 (bc-3 unchanged); 657 cumulative (unchanged) |
| VP count | 30 (unchanged) |
| Holdout count | 96 (unchanged) |
| Spec version | 1.3.45→1.3.46 |
| Severity floor | PATCH (terminology sync; no behavioral change) |

---

## [1.3.45] - 2026-07-15

### Type: MINOR

### Summary

Adversary pass-1 fix rounds A+B for SOH-ATTACHMENTS-1 (issues #576 + #585). Round A: 20 corrections to existing BC text (command path sweep ADV-001; delete signature ADV-002; write-to-temp ADV-006/007; retry-rebuild ADV-008; 214-byte UTF-8 truncation ADV-009/010; selector-required ADV-012; --older-than/--replace-existing/--dry-run scope clarifications ADV-014/015; error-string normalization ADV-016/017/018/019/020/021/022; non-JSM terminology ADV-005/ADV-003). Round B: 6 new BCs (BC-3.9.015..020) + 7 new holdout scenarios (H-NEW-ATTACHMENT-001..007) per scope expansion ruling R1/R2/R3 (2026-07-15 adversary-pass-1 checkpoint).

### Changes

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED): 6 new BCs appended (BC-3.9.015..020) — delete confirmation gate (BC-3.9.015, DEC-174 mirror of BC-3.5.002/003), bulk --older-than always-requires-yes + clap mutual-exclusion (BC-3.9.016), --replace-existing non-atomic delete-all-same-filename (BC-3.9.017, JRACLOUD-96384/-78388), --replace-existing zero-match idempotent (BC-3.9.018), --older-than duration-rs + chrono client-side comparison + bulk JSON shape (BC-3.9.019), --dry-run multi-attachment preview + JSON shape + single-ID stderr hint (BC-3.9.020); Section 3.9 now 20 contracts; round A: 20 body-text corrections (ADV-001..022); total_bcs 134→140 / definitional_count 105→111.
- `.factory/specs/prd/holdout-scenarios.md` (MODIFIED): 7 new scenarios appended as Group 19 (H-NEW-ATTACHMENT-001..007) — list zero/N attach, download write-to-temp, batch --all path-traversal, upload+replace-existing ordering, delete gate confirm/cancel/non-interactive, --older-than --dry-run two-phase, SECURITY CWE-22 path-traversal; total_holdouts 88→95.
- `.factory/specs/prd/BC-INDEX.md` (MODIFIED): 6 rows added (BC-3.9.015..020, Source attachments.rs family pending S3/S4); Section 3/3.9 headers updated; frontmatter total_bcs 651→657; index_version v6.13→v6.14; Coverage Statistics table updated.
- `.factory/specs/prd/CANONICAL-COUNTS.md` (MODIFIED): bc-3 rows 134→140 / 105→111; Sum 651→657; grand-total prose updated; L2 alignment row updated.
- `.factory/phase-f2-spec-evolution/prd-delta-576.md` (MODIFIED): frontmatter spec_version_after 1.3.44→1.3.45, holdout_count_after 88→95, bc_count_after 651→657; BC Enumeration Section 3.9 extended with 6 new rows; Scope Note marked DELIVERED.
- `.factory/spec-changelog.md` (MODIFIED): this entry (v1.3.44→v1.3.45).

### Impact Assessment

| Dimension | Detail |
|-----------|--------|
| BCs added | 6 (BC-3.9.015..020) |
| BCs modified (round A body-text) | 20 corrections to existing BCs (ADV-001..022) |
| BC count | 651→657 |
| VP count | 30 (unchanged) |
| Holdout scenarios added | 7 (H-NEW-ATTACHMENT-001..007) |
| Holdout count | 88→95 |
| Spec version | 1.3.44→1.3.45 |
| Scope ruling | R1: --replace-existing/--older-than/--dry-run IN scope; R2: delete y/N + --yes gate; R3: holdouts |
| Severity floor | MINOR (new BCs + new holdouts + scope expansion; no architectural change) |

---

## [1.3.44] - 2026-07-15

### Type: PATCH

### Summary

Security review fix round for SOH-ATTACHMENTS-1 (issues #576 + #585). Applies spec-text updates for findings SEC-576-001 through SEC-576-007 from `.factory/phase-f2-spec-evolution/security-review-576.md`. No BC count change (body-text additions only). No implementation exists; changes are spec additions before story decomposition.

### Changes

- `.factory/specs/prd/bc-2-issue-read.md` (MODIFIED):
  - BC-2.7.007: Added EC-2.7.007-3 (SEC-576-003 CWE-522) — wiremock test MUST assert `Authorization` is absent from redirect-target request (two-server setup). Trace updated.
  - BC-2.7.011: Replaced containment check paragraph with correct two-step procedure: `canonicalize(out_dir)` then `starts_with(resolved_dir)` (SEC-576-002 MEDIUM CWE-22) — resolves the non-existent-path `canonicalize` ambiguity. Added Windows device-name caller note (SEC-576-001 LOW CWE-22) after caller contract. Extended unit test matrix with `"CON"`, `"NUL"`, `"COM1"`, `"nul.txt"` (SEC-576-001). Added step 5.5 trailing-whitespace/dot strip for Windows predictability (SEC-576-007 INFO). Trace updated.

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED):
  - BC-3.9.001: Added EC-3.9.001-5 (SEC-576-005 CWE-352) — wiremock test MUST assert `X-Atlassian-Token: no-check` on every upload POST. Added multipart filename encoding note (SEC-576-004 CWE-93) — reqwest percent-encodes filenames; unit test for `;`, `"`, `\r\n` required (SQ-6 resolution). Trace updated.
  - BC-3.9.003: Added parallel X-Atlassian-Token note inline in Step 1 (SEC-576-005) — `attachTemporaryFile` also requires `X-Atlassian-Token: no-check`; wiremock test MUST assert header on step-1 POSTs. Trace updated.

- `.factory/specs/prd/cross-cutting.md` (MODIFIED):
  - BC-X.8.010: Added stale-ID self-healing clause (SEC-576-006) — if cached sdId causes step-1 HTTP 404/403, delete cache entry and retry resolution once; surface second failure. Trace updated.

- `.factory/spec-changelog.md` (MODIFIED): this entry (v1.3.43 → v1.3.44).

### Impact Assessment

| Dimension | Detail |
|-----------|--------|
| BCs modified (body text) | BC-2.7.007, BC-2.7.011, BC-3.9.001, BC-3.9.003, BC-X.8.010 |
| BC count | 651 (unchanged) |
| VP count | 30 (unchanged) |
| Holdout count | 88 (unchanged) |
| Security findings applied | SEC-576-001 (LOW), SEC-576-002 (MEDIUM), SEC-576-003 (LOW), SEC-576-004 (LOW), SEC-576-005 (LOW), SEC-576-006 (LOW), SEC-576-007 (INFO) |
| Severity floor | PATCH (spec-text additions; no architectural change; no BC numbering change) |

---

## [1.3.43] - 2026-07-15

### Type: MINOR

### Summary

F2 spec evolution for SOH-ATTACHMENTS-1 (issues #576 + #585). Adds 27 new individually-bodied BCs: Section 2.7 (Attachment Read, 12 BCs), Section 3.9 (Attachment Write, 14 BCs), and BC-X.8.010 (serviceDeskId cache). Ratified design per DEC-179.

### Changes

- `.factory/specs/prd/bc-2-issue-read.md` (MODIFIED): Section 2.7 Attachment Read added (BC-2.7.001..012) — attachment list (table+JSON, filters, error taxonomy), attachment download (single/batch/newest, streaming, redirect-following, CWE-22 sanitization, SHA-1 default path, JSDCLOUD-10841 JSM uniform endpoint). `total_bcs: 94 → 106`, `definitional_count: 52 → 64`.

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED): Section 3.9 Attachment Write added (BC-3.9.001..014) — platform upload POST (X-Atlassian-Token, streaming, no client-size cap, 413/400), JSM default (internal by default P2-4a), --public two-step (DEC-174 confirmation gate), --internal two-step (OQ-9 non-JSM silent no-op), --public non-JSM exit 64, temporaryAttachmentId TTL, post-upload echo (P2-3c deferred S5), attachment delete (DEC-168/BC-3.5.004 precedent), JSON output shapes, error taxonomies, confirmation gate (eprint!+read_line, NOT dialoguer). `total_bcs: 120 → 134`, `definitional_count: 91 → 105`.

- `.factory/specs/prd/cross-cutting.md` (MODIFIED): BC-X.8.010 added — `(profile, projectKey) → serviceDeskId` cache; model-b writer (swallow+eprintln warn, return Ok(())); 7-day TTL; deserialize failure = cache miss; used by JSM attachment upload --public/--internal path. `total_bcs: 149 → 150`, `definitional_count: 83 → 84`.

- `.factory/specs/prd/BC-INDEX.md` (MODIFIED): Sections 2.7 and 3.9 rows added; BC-X.8.010 row added; all section and frontmatter counts bumped; index_version v6.12 → v6.13; `total_bcs: 624 → 651`.

- `.factory/specs/prd/CANONICAL-COUNTS.md` (MODIFIED): Per-file tables, Sum row, grand-total prose, L2 alignment table, cache-type count all updated; `624 → 651`.

- `.factory/spec-changelog.md` (MODIFIED): this entry (v1.3.42 → v1.3.43).

### Impact Assessment

| Dimension | Detail |
|-----------|--------|
| New BCs | BC-2.7.001..012 (Section 2.7), BC-3.9.001..014 (Section 3.9), BC-X.8.010 |
| BC count | 624 → 651 (+27) |
| VP count | 30 (unchanged) |
| Holdout count | 88 (unchanged) |
| ADR reference | DEC-179 (F1 gate approval); ADR-0017 Accepted 2026-07-15 (`.factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md` — multipart/streaming HTTP surface) [CONS-576-007 correction: was "planned", ADR exists Accepted on same date] |
| Deferred probes | BC-3.9.007/BC-3.9.011 (P2-3c INCONCLUSIVE — S5 live-capture obligation on EJ) |
| Severity floor | MINOR (new feature — aspirational BCs for stories S1–S5; no implementation yet) |

---

## [1.3.40] - 2026-07-11

### Type: PATCH

### Summary

F2 gate closure DEC-170 fix round 49 for SOH-COMMENT-CRUD-1 bundle (issue #577). Human-ruled: no full re-convergence needed — mechanical mirror of ratified items (f)/(g). Two delivery obligations added to EC-3.5.012-5 as items (h) and (i). VP count unchanged at 30.

### Changes

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED):
  Gate closure (DEC-170 consistency-audit ruling): EC-3.5.012-5 extended with two new items appended after item (g):
  (h) `docs/specs/json-output-shapes.md` registry rows — the canonical JSON-shape registry MUST gain rows for all four comment-CRUD `--output json` shapes (comment add, delete, edit, view) in the same PR as the CLI refactor. Comment-add row registers the CURRENT full `Comment`-struct serialization (`{id, body, author, created, properties}`; no `key` field; byte-identical to pre-refactor per EC-3.5.012-2), noted as predating the BC-pinned key-set convention. VP-577-009/023 BTreeSet pins are the source of truth for the delete/edit rows only. (CV round-49 catch: original item stated `{"key","id"}` for comment add — corrected; orchestrator false-premise acknowledged.)
  (i) `docs/specs/comment-crud.md` feature spec creation — MUST be created in the same PR as the CLI refactor, following `docs/specs/issue-move-resolution.md` precedent (ADR-0004); minimum content specified (old→new CLI form table, --public gate, body-only-PUT guarantee, allow_hyphen_values remapping, interactions.rs shard pointer).
  Both items carry attribution note: "(added at F2 gate closure per DEC-170 consistency-audit ruling, 2026-07-11)".
  BC-3.5.012 Trace updated. Frontmatter trace entry added for fix round 49.
  VP count unchanged: 30. No BC count change.

- `.factory/spec-changelog.md` (MODIFIED): this entry (v1.3.39 → v1.3.40).

### Impact Assessment

| Dimension | Detail |
|-----------|--------|
| EC extended in-place | EC-3.5.012-5 items (h) and (i) added |
| VP count | 30 (unchanged) |
| BC count | 624 (unchanged) |
| Holdout count | 88 (unchanged) |
| Severity floor | Gate closure (human-ruled; mechanical mirror of ratified items f/g) |

---

## [1.3.39] - 2026-07-11

### Type: PATCH

### Summary

Adversary pass-45 fix round 48 for SOH-COMMENT-CRUD-1 bundle (issue #577). One LOW finding fixed: VP-577-006 setup note had a gate mis-cite introduced in round 47 — corrected bodyless-invocation gate reference from EC-3.5.009-5 to BC-3.5.009 body-required rule with verbatim message. VP count unchanged at 30.

### Changes

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED):
  F-1 (LOW, VP-577-006 setup-note gate mis-cite — introduced round 47): VP-577-006 setup note parenthetical corrected. The bodyless counterfactual (`jr issue comment edit FOO-1 --id 10001 --public --no-input`, no positional/--file/--stdin) fires BC-3.5.009's body-REQUIRED gate (no source supplied at all), NOT EC-3.5.009-5 (which fires only when a source IS present but resolves to empty/whitespace). Changed: `(EC-3.5.009-5, "comment body cannot be empty")` → `(BC-3.5.009 body-required rule, "body is required — use --file, --stdin, or pass text as a positional argument.")`. Verbatim message sourced from BC-3.5.009 body. BC-3.5.008 Trace updated.
  Frontmatter trace entry added for adversary pass-45 fix round 48.
  VP count unchanged: 30 (in-place correction). No BC count change.

- `.factory/spec-changelog.md` (MODIFIED): this entry (v1.3.38 → v1.3.39).

### Impact Assessment

| Dimension | Detail |
|-----------|--------|
| VPs corrected in-place | VP-577-006 setup note (BC-3.5.008) |
| VP count | 30 (unchanged) |
| BC count | 624 (unchanged) |
| Holdout count | 88 (unchanged) |
| Severity floor | 1 LOW (single-finding pass; corrects round-47-introduced mis-cite) |

---

## [1.3.38] - 2026-07-11

### Type: PATCH

### Summary

Adversary pass-44 (user-journey lens) fix round 47 for SOH-COMMENT-CRUD-1 bundle (issue #577). Two LOW findings fixed. Streak reset 2/3→0/3 under Full STRICT. VP count unchanged at 30.

### Changes

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED):
  F-1 (LOW, VP-577-006 mis-specified invocation): VP-577-006 (BC-3.5.008) rewritten — invocation changed to non-empty body (`jr issue comment edit FOO-1 --id 10001 "Updated text" --public --no-input`) with a setup note clarifying that exit-64 must come from step-3 `--public` gate, NOT step-2 body gate. Stderr substrings asserted: "visibility to public" AND "--yes". Distinguishes the two gate conditions per EC-3.5.008-1 (which pins that `--yes` does NOT suppress the JSDCLOUD-6050 hint). BC-3.5.008 Trace updated.
  Frontmatter trace entry added for adversary pass-44 fix round 47.
  VP count unchanged: 30 (in-place rewrite). No BC count change.

- `.factory/specs/prd/error-taxonomy.md` (MODIFIED):
  F-2 (LOW, error-taxonomy coherence): Section 3 — two override rows added for comment operations: 403 and 404 both map to `UserError(...)` exit 64 with message pattern `"comment not found or permission denied: <KEY>#<ID>"` + Jira body on separate line (BC-3.5.004/BC-3.5.005/BC-3.5.010 override). Pre-existing TD-031 violation fixed: volatile line cite `src/api/client.rs:448-490` replaced with stable symbol anchor `src/api/client.rs::extract_error_message`. Pre-existing table-cell pipe escaped in BC-CITE-001 False-positive risk row (`[^[:alnum:]_]|$` → `[^[:alnum:]_]\|$`). Pre-existing intra-table wording alignment: CI-CITE-001 False-positive risk cell now reads 'excluded via dir-prefix filter', matching the Tracing BCs cell in the same row-set. Frontmatter trace entry added.

- `.factory/spec-changelog.md` (MODIFIED): this entry (v1.3.37 → v1.3.38).

### Impact Assessment

| Dimension | Detail |
|-----------|--------|
| VPs rewritten in-place | VP-577-006 (BC-3.5.008) |
| VP count | 30 (unchanged) |
| BC count | 624 (unchanged) |
| Holdout count | 88 (unchanged) |
| Severity floor | 2 LOW (2-finding pass) |

---

## [1.3.37] - 2026-07-11

### Type: PATCH

### Summary

Adversary pass-41 fix round 46 (single-finding pass) for SOH-COMMENT-CRUD-1 bundle (issue #577). One LOW finding fixed: VP-577-002 and VP-577-003 extended with assertion (d) pinning the `sd.public.comment` property key name and single-element array cardinality. VP count unchanged at 30.

### Changes

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED):
  F-01 (LOW, properties key unpinned): VP-577-002 (BC-3.5.006) and VP-577-003 (BC-3.5.007) each extended in-place with assertion (d): `parsed["properties"].as_array().unwrap().len() == 1 && parsed["properties"][0]["key"] == "sd.public.comment"` must be `true`. Pins the exact property key name and single-element array cardinality — a key-name typo (e.g. `sd_public_comment`) or stray second array entry would pass assertions (a)–(c) while the JSM visibility change silently no-ops server-side. BC-3.5.006 Trace and BC-3.5.007 Trace updated.
  Frontmatter trace entry added for adversary pass-41 fix round 46.
  VP count unchanged: 30 (in-place extensions). No BC count change.

- `.factory/spec-changelog.md` (MODIFIED): this entry (v1.3.36 → v1.3.37).

### Impact Assessment

| Dimension | Detail |
|-----------|--------|
| VPs extended in-place | VP-577-002 (assertion d), VP-577-003 (assertion d) |
| VP count | 30 (unchanged) |
| BC count | 624 (unchanged) |
| Holdout count | 88 (unchanged) |
| Severity floor | 1 LOW (single-finding pass) |

---

## [1.3.36] - 2026-07-11

### Type: PATCH

### Summary

Adversary pass-40 fix round 45 (hygiene pass) for SOH-COMMENT-CRUD-1 bundle (issue #577). Three LOW findings fixed. One premise corrected (SEC-577-001 was always defined). VP count unchanged at 30 (all in-place).

### Changes

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED):
  F-01 (LOW, routing-sentence mis-anchor): BC-3.5.010 routing sentence rewritten — `handle_comment_view` is the F4-added handler (sibling to `handle_comment`); added relocates qualifier; renamed function reference from `::handle_comment` to `::handle_comment_view`. BC-3.5.010 Trace updated.
  F-02 (LOW, PREMISE CORRECTED — SEC-577-001 citation pointer): First SEC-577-001 cite (BC-3.5.007 rationale paragraph) extended with definitional pointer `(defined in .factory/phase-f2-spec-evolution/security-review-577.md § SEC-577-001)`. Premise correction noted: SEC-577-001 was always defined; this fix is a citation pointer, not a definition addition. Other two citing sites left as bare ID references (resolve via first). BC-3.5.007 Trace updated.
  F-03 (LOW, sibling-VP asymmetry harmonized): VP-577-013 extended in-place — `parsed stdout top-level object keys == BTreeSet::from(["cancelled", "deleted"])` (exact key-set; pins EC-3.5.003-2's id/key-omitted-from-cancel-envelope rule). Harmonizes with VP-577-029 which already uses BTreeSet notation. BC-3.5.003 Trace updated.
  Frontmatter trace entry added for adversary pass-40 fix round 45.
  VP count unchanged: 30. No BC count change.

- `.factory/spec-changelog.md` (MODIFIED): this entry (v1.3.35 → v1.3.36).

### Impact Assessment

| Dimension | Detail |
|-----------|--------|
| VPs extended in-place | VP-577-013 (BTreeSet key-set) |
| VP count | 30 (unchanged) |
| BC count | 624 (unchanged) |
| Holdout count | 88 (unchanged) |
| Premise correction | SEC-577-001 was always defined in security-review-577.md; fix adds citation pointer only |

---

## [1.3.35] - 2026-07-11

### Type: PATCH

### Summary

Adversary pass-39 fix round 44 (exhaustive promise→pin coverage sweep) for SOH-COMMENT-CRUD-1 bundle (issue #577). Five findings fixed — 1 MEDIUM + 4 LOW — plus one marginal item to drain the class. VP count 28 → 30 (VP-577-029, VP-577-030 added). No BC count change.

### Changes

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED):
  F1 (LOW, EDIT human-mode stderr unpinned): VP-577-023 extended with human-mode variant — `jr issue comment edit FOO-1 --id 10001 "Updated text"` → exit 0; stderr contains `"Updated comment 10001 on FOO-1"`; stdout empty. In-place, no new VP number. BC-3.5.005 Trace updated.
  F4 (LOW, VP-577-025 JSDCLOUD-6050 unpinned): VP-577-025 both variants extended — first variant (`--internal`) adds `"JSDCLOUD-6050"` stderr assertion (EC-3.5.006-1 hint pin); second variant (`--public --yes`) adds `"JSDCLOUD-6050"` assertion AND states it simultaneously proves EC-3.5.008-1's hint-not-suppressed-by---yes rule. In-place, no new VP number. BC-3.5.005 Trace updated.
  F2 (LOW, interactive cancel JSON key-set unpinned): NEW VP-577-029 added to BC-3.5.008 — interactive (`JR_STDIN_IS_TTY=1`) + `--public` + user selects N + `--output json` → exit 0; stdout keys == `BTreeSet::from(["cancelled","updated"])`; `cancelled==true`, `updated==false`; wiremock `.expect(0)`. Mirrors VP-577-013. BC-3.5.008 Trace updated.
  F3 (LOW, EOF/interrupt coverage gap): NEW VP-577-030 added to BC-3.5.008 — two variants: (1) delete prompt EOF → exit 130, DELETE `.expect(0)`; (2) `--public` prompt EOF → exit 130, PUT `.expect(0)`. Pins EC-3.5.003-3 + EC-3.5.008-5 delivery with `interact_on(&Term::stderr())` + `JrError::Interrupted` requirements. BC-3.5.008 Trace updated.
  F5 (MEDIUM, field-6 rung a/b/c unpinned): VP-577-021 extended with variants 4/5/6 — (4) `{"type":"role","value":"Administrators"}` → stdout contains `"Restricted: Administrators"` (rung a); (5) `{"type":"role","value":"","identifier":"admin-role-id"}` → `"Restricted: id=admin-role-id"` (rung b); (6) `{"type":"team","value":"AlphaTeam","identifier":"team-123"}` → `"Restricted: team:AlphaTeam"` (rung c). In-place, no new VP number. BC-3.5.010 Trace updated.
  M1 (marginal, JSM internal: No unpinned): VP-577-021 extended with variant 7 — `properties:[{"key":"sd.public.comment","value":{"internal":false}}]` → stdout contains `"JSM internal: No"`. In-place, no new VP number. BC-3.5.010 Trace updated.
  Frontmatter trace entry added for adversary pass-39 fix round 44. `last_updated` bumped to 2026-07-11.
  VP count: 28 → 30 (VP-577-029, VP-577-030 new). No BC count change.

- `.factory/spec-changelog.md` (MODIFIED): this entry (v1.3.34 → v1.3.35).

### Impact Assessment

| Dimension | Detail |
|-----------|--------|
| VPs added | VP-577-029 (BC-3.5.008), VP-577-030 (BC-3.5.008) |
| VPs extended in-place | VP-577-023, VP-577-025 (both variants), VP-577-021 (variants 4/5/6/7) |
| VP count | 28 → 30 |
| BC count | 624 (unchanged) |
| Holdout count | 88 (unchanged) |

---

## [1.3.34] - 2026-07-11

### Type: PATCH

### Summary

Adversary pass-38 fix round 43 + human ratifications R-1/R-2 for SOH-COMMENT-CRUD-1 bundle (issue #577). Three findings fixed — 1 MEDIUM + 2 LOW. Two human-ratified rulings baked in. No BC count change. VP count unchanged at 28 (all extensions in-place).

### Changes

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED):
  F-01 (MEDIUM, EDIT JSON key-sets unpinned): VP-577-023 extended with top-level key-set assertion (`BTreeSet::from(["changed_fields","id","key","updated"])`). VP-577-026 variants 1/2 extended with `changed_fields` key-set assertion (`BTreeSet::from(["body","jsm_internal"])`); variant 3 extended with `BTreeSet::from(["body"])`. All in-place, no new VP numbers. BC-3.5.005 Trace updated.
  F-02 (LOW, DELETE human stderr unpinned): VP-577-009 extended with human-mode variant — `jr issue comment delete FOO-1 --id 10001 --yes` → exit 0; stderr contains `"Deleted comment 10001 on FOO-1"`; stdout empty. In-place, no new VP number. BC-3.5.002 Trace updated.
  F-03 (LOW, VP-577-007 vs H-NEW-COMMENT-004 key-list disagreement): VP-577-007 updated to include `"updated"` in required top-level keys (union with H-NEW-COMMENT-004 fixture). BC-3.5.010 Trace updated.
  R-1 (human-ratified 2026-07-11): EC-3.5.008-4 and VP-577-028 gate language removed ("ORCHESTRATOR RULING", "F2 human gate required before closing"); replaced with ratification note citing research `.factory/research/issue-577-yes-flag-noop-convention-2026-07-11.md` (9/9 CLIs LENIENT). BC-3.5.008 Trace updated.
  R-2 (human-approved follow-up candidate 2026-07-11): "Stray-confirmation-flag stderr hint" follow-up story candidate added after EC-3.5.012-4 — emit `"note: --yes has no effect without --public"` on stderr; consider house-wide pattern for --no-resolution/--no-input.
  Frontmatter trace entry added for adversary pass-38 fix round 43.
  VP count unchanged: 28 (all extensions in-place). No BC count change.

- `.factory/specs/prd/holdout-scenarios.md` (MODIFIED):
  F-03: H-NEW-COMMENT-004 Expected A line — `"properties"` key changed from "may be present or absent" to required assertion ("this fixture guarantees `properties` is present"). Scenario count unchanged (88).

- `.factory/spec-changelog.md` (MODIFIED): this entry (v1.3.33 → v1.3.34).

### Impact Assessment

| Dimension | Detail |
|-----------|--------|
| VPs extended in-place | VP-577-009, VP-577-023, VP-577-026 (variants 1/2/3); VP-577-007, VP-577-028 gate-language update |
| VP count | 28 (unchanged) |
| BC count | 624 (unchanged) |
| Holdout count | 88 (unchanged) |
| Human ratifications | R-1: EC-3.5.008-4 --yes silent-no-op ratified (was orchestrator ruling + gate); R-2: stray-flag hint follow-up story candidate approved |

---

## [1.3.33] - 2026-07-10

### Type: PATCH

### Summary

Adversary pass-37 fix round 42 for SOH-COMMENT-CRUD-1 bundle (issue #577). Four findings fixed — 1 MEDIUM + 3 LOW. No BC count change. VP count unchanged at 28 (VP-577-009 and VP-577-021 reformulated/extended in place; no new VP numbers assigned).

### Changes

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED):
  F-01 (MEDIUM, BC-3.5.012 subcommand-to-BC map wrong): `Edit` variant changed from `BC-3.5.005..BC-3.5.011` (incorrectly included BC-3.5.010 which is View) to `BC-3.5.005..BC-3.5.009, BC-3.5.011` (explicit non-contiguous list). View line unchanged. BC-3.5.012 Trace updated.
  F-02 (LOW, VP-577-009 key-set assertion weak): VP-577-009 reformulated to BTreeSet exact-set pattern — `serde_json` parsed object keys == `BTreeSet::from(["deleted", "id", "key"])` (mirrors VP-577-001/002/003 pattern). BC-3.5.002 Trace updated.
  F-03 (LOW, label-value separator unspecified): Normative sentence added to BC-3.5.010 after field enumeration: "All field lines (fields 1–6) render as `<label> <value>` — single space between the label's colon and the first character of the value, LF line terminator." VP-577-021 extended with third variant (in-place, no new VP number): property-absent fixture → stdout contains `"JSM internal: N/A"` (byte-level pin for N/A render path and separator rule). BC-3.5.010 Trace updated.
  F-04 (LOW, EC-3.5.010-2 catch-all binds future error kinds): EC-3.5.010-2 split into (a) `JrError::UserError` from `adf_to_text` (currently only depth-guard, BC-7.2.012/SEC-001) propagates unchanged; exit 64; (b) any other future error kind NOT covered this cycle, MUST be re-classified when introduced. Field-7 cross-reference updated from `EC-3.5.010-2 (currently only the recursion depth-guard; exit 64)` to `EC-3.5.010-2 (a)`. BC-3.5.010 Trace updated.
  Frontmatter trace entry added for adversary pass-37 fix round 42.
  VP count unchanged: 28 (VP-577-009 reformulated; VP-577-021 extended in place). No BC count change.

- `.factory/spec-changelog.md` (MODIFIED): this entry (v1.3.32 → v1.3.33).

### Impact Assessment

| Dimension | Detail |
|-----------|--------|
| VPs reformulated/extended | VP-577-009 (BTreeSet exact key-set); VP-577-021 third variant (N/A byte-level pin) |
| VP count | 28 (unchanged) |
| BC count | 624 (unchanged) |
| Holdout count | 88 (unchanged) |

---

## [1.3.32] - 2026-07-10

### Type: PATCH

### Summary

Adversary pass-36 fix round 41 for SOH-COMMENT-CRUD-1 bundle (issue #577). Four findings fixed — 1 MEDIUM + 3 LOW. No BC count change. VP count unchanged at 28 (VP-577-027 and VP-577-028 reformulated in place, no additions or removals).

### Changes

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED):
  F-1 (MEDIUM, VP-577-028 second variant tautological): VP-577-028 second variant replaced — old variant asserted `--help` output lacks `requires --public` (tautological: clap's `requires()` does not render into help text). New variant: runtime clap-requires probe — `jr issue comment edit FOO-1 --id 10001 "" --yes` (empty-string positional, WITHOUT `--public`) → exit 64; stderr contains `"comment body cannot be empty"` (EC-3.5.009-5 handler-level path); exit code is 64 NOT 2 (proving clap accepted `--yes` without `--public`, i.e., `requires("public")` was not applied at parse time). BC-3.5.008 Trace updated.
  F-2 (LOW, field-6 rung (b) empty-string gap): BC-3.5.010 field 6 rung (b) condition broadened from "absent/null/non-string" to "not a non-empty string (i.e., absent, null, non-string, or empty string)" so `{"type":"role","value":"","identifier":"X"}` correctly displays `"id=X"` rather than falling through to rung (c). BC-3.5.010 Trace updated.
  F-3 (LOW, VP-577-027 wiremock matcher fragility): VP-577-027 reformulated — old assertion used dual-mount hit-count discrimination (depends on undocumented wiremock-rs raw-vs-decoded path-matching semantics). New assertion: mount with method-only matcher; inspect `mock_server.received_requests().await[0].url` and assert path contains `MY%20KEY-1` (raw percent-encoded bytes). BC-3.5.002 Trace updated.
  F-4 (LOW, EC-3.5.002-2 site-ordering misleading): EC-3.5.002-2 reordered — old text named `src/api/client.rs` first (generic HTTP layer, no path templates). New text names the per-endpoint helper first: "Encoding is applied at the per-endpoint helper (e.g., `src/api/jira/issues.rs::add_comment`…) — not duplicated by each handler; `src/api/client.rs` is a generic HTTP layer and does not hold path templates." BC-3.5.002 Trace updated.
  Frontmatter trace entry added for adversary pass-36 fix round 41.
  VP count unchanged: 28 (VP-577-027 and VP-577-028 reformulated in place). No BC count change.

- `.factory/spec-changelog.md` (MODIFIED): this entry (v1.3.31 → v1.3.32).

### Impact Assessment

| Dimension | Detail |
|-----------|--------|
| VPs reformulated | VP-577-027 (wiremock URL inspection); VP-577-028 second variant (runtime probe) |
| VP count | 28 (unchanged) |
| BC count | 624 (unchanged) |
| Holdout count | 88 (unchanged) |

---

## [1.3.31] - 2026-07-10

### Type: PATCH

### Summary

Adversary pass-35 fix round 40 for SOH-COMMENT-CRUD-1 bundle (issue #577). Six findings fixed — 1 HIGH + 3 MEDIUM + 2 LOW. No BC count change. VP count 26 → 28 (VP-577-027, VP-577-028 added). Contains one ORCHESTRATOR RULING (F-A4 `--yes` silent no-op; F2 human gate required before closing).

### Changes

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED):
  F-A1 (HIGH, migration-documentation gap): EC-3.5.012-5 extended — items (f) and (g) appended: (f) `README.md` §Commands table and all `jr issue comment …` examples MUST be updated to `jr issue comment add` form in the same PR as the CLI refactor (explicit obligation because `tests/claude_md_citations.rs` guards paths only, not command-example text); (g) `CLAUDE.md` "allow_hyphen_values on free-text CLI args" bullet MUST be updated to cite `issue comment add` (positional message) AND `issue comment edit` (positional text) per EC-3.5.012-3. BC-3.5.012 Trace updated.
  F-A2 (MEDIUM, exit-code contract gap — 401 missing from Other-4xx/5xx): "Other 4xx/5xx" refined to "Other 4xx/5xx (except 401)" in BC-3.5.004, BC-3.5.005 Response 404/403, and BC-3.5.010 Response 404/403. Each clause now explicitly states: "**401** → framework auth-error path (`JrError::NotAuthenticated` / `JrError::InsufficientScope`); exit 2 per error-taxonomy.md §Section 3." BC-3.5.004, BC-3.5.005, and BC-3.5.010 Traces updated.
  F-A3 (MEDIUM, URL-encoding obligation unstated): EC-3.5.002-2 added (after EC-3.5.002-1) — KEY URL-percent-encoding via `urlencoding::encode` normative obligation for all comment-family endpoint paths; `--id` value needs no further encoding after EC-3.5.002-1 regex pass. VP-577-027 added (KEY URL-encoding pin — wiremock at `MY%20KEY-1` receives one hit; un-encoded route receives zero). BC-3.5.002 Trace updated.
  F-A4 (MEDIUM, ORCHESTRATOR RULING — F2 human gate required): EC-3.5.008-4 added — `--yes` accepted silently without error when `--public` is absent; clap MUST NOT define `--yes` as `requires("public")`; rationale: ADR-0015 `--no-resolution` accepted-silently precedent. VP-577-028 added (`--yes` silent-no-op pin + clap no-requires variant). BC-3.5.008 Trace updated.
  F-A5 (LOW, Ctrl+C/EOF handling unspecified): EC-3.5.003-3 added to BC-3.5.003 — dialoguer Err on delete confirmation prompt → `JrError::Interrupted`; exit 130. EC-3.5.008-5 added to BC-3.5.008 — same rule for `--public` confirmation prompt. BC-3.5.003 and BC-3.5.008 Traces updated.
  F-A6 (LOW, unknown-type silent-None gap): BC-3.5.010 field 6 `Restricted:` ladder extended from three rungs to four — rung (c) added: if `type` is any non-null, non-empty string AND either `value` or `identifier` is non-null/non-empty → display `<type>:<value-or-identifier>` (defensive rendering for unknown restriction kinds); rung (d) is now the "None" fallback (was rung (c)). BC-3.5.010 Trace updated.
  Frontmatter trace entry added for adversary pass-35 fix round 40.
  VP count 26 → 28 (VP-577-027 + VP-577-028 added). No BC count change.

- `.factory/spec-changelog.md` (MODIFIED): this entry (v1.3.30 → v1.3.31).

### Impact Assessment

| Dimension | Detail |
|-----------|--------|
| VPs added | VP-577-027 (BC-3.5.002 KEY URL-encoding pin); VP-577-028 (BC-3.5.008 --yes silent-no-op + clap no-requires pin — ORCHESTRATOR RULING, F2 human gate required) |
| VP count | 26 → 28 |
| BC count | 624 (unchanged) |
| Holdout count | 88 (unchanged) |
| F2 human gate | F-A4 (EC-3.5.008-4 `--yes` silent no-op on non-`--public` paths, interpretation (ii)) requires F2 human sign-off before closing issue #577 |
| Mainline refactor risk | EC-3.5.012-5 (try_parse() refactor — items (f)+(g) add README.md + CLAUDE.md doc obligations) |

---

## [1.3.30] - 2026-07-10

### Type: PATCH

### Summary

Adversary pass-34 fix round 39 for SOH-COMMENT-CRUD-1 bundle (issue #577). Two findings fixed — 1 MEDIUM + 1 LOW. No BC count change. VP count 25 → 26 (VP-577-026 added).

### Changes

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED):
  F-577-A (MEDIUM, VP coverage gap): VP-577-026 added to BC-3.5.005 Verification Properties (after VP-577-025) — three parse-level variants pinning `changed_fields.jsm_internal`: (1) `--internal` → `Bool(true)` boolean not string; (2) `--public --yes` → `Bool(false)` boolean not string; (3) default body-only → key ENTIRELY ABSENT (`contains_key("jsm_internal")` is false). Pin back-reference added to BC-3.5.005 Response 200 JSON schema paragraph (after "key is omitted entirely."). Pin back-reference added to EC-3.5.008-2 Confirm path (variant 2). BC-3.5.005 Trace updated. Rationale: #398 VP-398-002/004 lossless-machine-channel precedent.
  F-577-B (LOW, graceful-degradation gap, research-adjudicated): BC-3.5.010 field 6 `Restricted:` ladder extended from two rungs to three — (a) `value` present → display `<value>` (unchanged); (b) `value` absent/null/non-string BUT `identifier` present → display `"id=<identifier>"` (new rung; distinguishable marker, not bare "None"); (c) both absent → "None" (unchanged). Research citation added: `.factory/research/issue-577-visibility-identifier-shape-2026-07-10.md` — Q1 VALIDATED high (identifier formally in schema); Q2 INCONCLUSIVE-leans-rare (mechanism supported, no Atlassian GET-response example with identifier-only found); defensive rendering chosen. VP-577-021 "Restricted: None" assertion unaffected (fixture has visibility absent → rung (c) unchanged). BC-3.5.010 Trace updated.
  Frontmatter trace entry added for adversary pass-34 fix round 39.
  VP count 25 → 26 (VP-577-026 added). No BC/holdout count change.

- `.factory/spec-changelog.md` (MODIFIED): this entry (v1.3.29 → v1.3.30).

### Impact Assessment

| Dimension | Detail |
|-----------|--------|
| VPs added | VP-577-026 (BC-3.5.005 jsm_internal boolean-type + key-absence parse pin — three variants: `--internal` Bool(true), `--public --yes` Bool(false), default key-absent) |
| VP count | 25 → 26 |
| BC count | 624 (unchanged) |
| Holdout count | 88 (unchanged) |

---

## [1.3.29] - 2026-07-10

### Type: PATCH

### Summary

Adversary pass-32 fix round 38 for SOH-COMMENT-CRUD-1 bundle (issue #577). Four findings fixed — 1 HIGH + 3 LOW. No BC count change. VP count 24 → 25 (VP-577-025 added).

### Changes

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED):
  F1 (HIGH, cleanup-mandate conflict): BC-3.5.006 Delivery-task obligation ~line 2319 — stale sentence-1 clause `, self-cleaning via \`jsm_self_close\` convention` replaced with forward-reference `, self-cleaning per the per-comment DELETE rule stated below`. Eliminates the contradiction with the authoritative NOT-via-jsm_self_close rule stated later in the same paragraph. BC-3.5.006 Trace updated.
  F2 (LOW, human-echo markers unpinned): VP-577-025 added to BC-3.5.005 Verification Properties (after VP-577-024) — `jr issue comment edit FOO-1 --id 10001 "Updated text" --internal` → exit 0; stderr contains `"(marked internal)"`; second variant `--public --yes` → stderr contains `"(marked public)"`. Pin reference added to BC-3.5.005 Response 200 output Human success line and EC-3.5.008-2 Confirm path line. BC-3.5.005 Trace updated.
  F3 (LOW, sequencing constraint unstated): BC-3.5.006 Delivery-task obligation — **Sequencing constraint (delivery PR, F3)** note added after "comment-DELETE step is mandatory in either flow": `jr issue comment delete` ships in the SAME story; delete subcommand MUST be implemented before or alongside the e2e probe function; raw-API-DELETE fallback permitted but drops CLI regression signal; story PR MUST declare which pattern is used.
  F4 (LOW, BC-3.4.011 wrongly listed): EC-3.5.012-5 — BC-3.4.011 removed from item (a); items (b)-(f) renumbered to (a)-(e); rationale note appended. BC-3.5.012 Trace updated.
  Frontmatter trace entry added for adversary pass-32 fix round 38.
  VP count 24 → 25 (VP-577-025 added). No BC/holdout count change.

- `.factory/spec-changelog.md` (MODIFIED): this entry (v1.3.28 → v1.3.29). Follow-up Obligations bullet updated: "BC-3.4.011 hint," removed from the EC-3.5.012-5 regression list.

- `.factory/STATE.md` (MODIFIED): Counters row updated — VP-577 family 24 → 25; Spec v1.3.28 → v1.3.29.

### Impact Assessment

| Dimension | Detail |
|-----------|--------|
| VPs added | VP-577-025 (BC-3.5.005 human echo marker pin — `--internal` → stderr "(marked internal)"; `--public --yes` → "(marked public)") |
| VP count | 24 → 25 |
| BC count | 624 (unchanged) |
| Holdout count | 88 (unchanged) |

---

## [1.3.28] - 2026-07-09
_Note: entry date extended to 2026-07-10 via pass-12+ remediations._

### Type: MINOR

### Summary

F2 spec evolution for SOH-COMMENT-CRUD-1 bundle (GitHub issue #577: `jr issue comment
delete/edit/view`). DEC-168 human gate approved 2026-07-09. Adds 11 new BCs
(BC-3.5.002..BC-3.5.012) to `bc-3-issue-write.md §3.5`, plus 5 holdout scenarios
(H-NEW-COMMENT-001..H-NEW-COMMENT-005) to `holdout-scenarios.md`. Key design resolution:
`comment edit` default is body-only PUT (no `"properties"` key — the footgun claim was
REFUTED by research); `--public` always-confirm semantics (Option a — no GET required);
`comment delete` 404 exits 64 + surfaces error body (NOT idempotent); CLI breaking change
(`comment` → subcommand group with `add`/`delete`/`edit`/`view`).

BC count 613 → 624 (11 individually-bodied BCs added; bc-3-issue-write.md
definitional_count 80 → 91, total_bcs 109 → 120).

BC-INDEX.md has been updated to 624 total_bcs and bc-3 section count (120/91) via
sanctioned Python shell edit (TD-031 validate-stable-anchors hook bypassed per established
workaround; adversary pass-5 M3/M5 remediation). CANONICAL-COUNTS.md is authoritative
and agrees at 624. All 8 cumulative-count surfaces now agree.

### New Requirements

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED): `total_bcs` 109 → 120;
  `definitional_count` 80 → 91; `last_updated` updated; frontmatter trace entry added for
  SOH-COMMENT-CRUD-1 F2; intro count 109 → 120; §3.5 header updated to "12 BCs:
  BC-3.5.001..BC-3.5.012"; BC-3.5.002..BC-3.5.012 bodies added (delete endpoint, delete
  confirmation, delete 404-exit-64, edit body-only-PUT invariant, edit --internal wire,
  edit --public wire+always-confirm, edit --public confirmation gate, edit body sources,
  comment view, mutual exclusion, CLI breaking change); footer updated to 91/120.
  Security-review corrections (same-version, SEC-577-001..004): BC-3.5.008 item 1
  non-interactive message corrected (CWE-1021 — removed false JSM/internal assumption);
  EC-3.5.009-4 added (CWE-1283 — --stdin/positional mutual exclusion via clap
  conflicts_with → exit 2); EC-3.5.006-1 hint timing unified to "before the PUT is sent"
  (was "after submission") matching EC-3.5.007-1; BC-3.5.005 implementation note added
  (Option<Vec<...>> serde derive emits "properties": null footgun, recommend
  #[serde(skip_serializing_if = "Option::is_none")]). No BC count change (EC-3.5.009-4
  is a new EC within existing BC-3.5.009).
  Adversary pass-1 remediation (same-version, HIGH-1/HIGH-2/MEDIUM-1..6/LOW-1):
  HIGH-1: EC-3.5.012-1 rewritten — custom error handler required to inject "comment add"
  hint on InvalidSubcommand (clap 4 does not propagate about/long_about to error output);
  VP-577-008 added (exit 2 + stderr "comment add" substring, parse-level).
  HIGH-2: BC-3.5.005 implementation note extended to cover Vec::new() → "properties":[]
  hazard from reusing response Comment struct; "Do NOT reuse" sentence added; three
  compliant options enumerated.
  MEDIUM-1: BC-3.5.008 item 2 interactive prompt reworded project-agnostic ("Set this
  comment's visibility to public?" — removes JSM "customer" assumption, CWE-1021 lineage).
  MEDIUM-2: BC-3.5.002 output profile 5 → 4 (Symmetric); BC-3.5.010 output profile 2 →
  3 (Mixed — 404 errors go to stderr, disqualifying Read-only).
  MEDIUM-3: EC-3.5.009-1 extended with deliberate-divergence rationale (edit exits 64 via
  UserError; add bail!→exit-1 is follow-up story candidate); VP-577-011 added.
  MEDIUM-4: EC-3.5.009-5 added (empty/whitespace body → exit 64, no PUT); VP-577-012 added.
  MEDIUM-5: BC-3.5.010 Response 404 harmonized with BC-3.5.004 ("not found or permission
  denied", surface Jira body, Claim 3 CONFIRMED cross-reference).
  MEDIUM-6: VP-577-009 added to BC-3.5.002 (DELETE 204 → exit 0 + JSON shape);
  VP-577-010 added to BC-3.5.011 (--internal --public → exit 2, parse-level).
  LOW-1: EC-3.5.012-3 added (CommentSubcommand::Add allow_hyphen_values=true invariant;
  regression pin for "- [ ] task" parse).
  No BC count change (all additions are ECs/VPs within existing BC bodies).
  Adversary pass-2 remediation (same-version, HIGH-1/HIGH-2/MEDIUM-1..4/LOW-1..4):
  HIGH-1: BC-3.5.002 human output channel corrected stdout → stderr (output::print_success
  per state-changing-command convention).
  HIGH-2: BC-3.5.005 Response 200 output section added (canonical for all edit variants:
  stderr print_success "Updated comment <ID> on <KEY>." + optional visibility marker;
  JSON envelope {updated,id,key,changed_fields{body=raw-input,visibility?}}; cancel-path
  cross-ref; BC-3.4.013 echo-asymmetry precedent cited).
  MEDIUM-1: BC-3.5.003 EC-3.5.003-2 added (--output json × confirmation matrix: prompt
  always stderr; cancel → JSON {deleted:false,cancelled:true} stdout exit 0; confirm → same
  as --yes); BC-3.5.008 EC-3.5.008-2 added (same pattern, {updated:false,cancelled:true});
  VP-577-013 added (cancel-in-JSON-mode, delete path).
  MEDIUM-2+LOW-3: EC-3.5.012-1 extended — hint fires on ALL InvalidSubcommand (flat form,
  KEY-only, typo); bare `jr issue comment` (MissingSubcommand) → NO custom hint (clap
  listing IS the migration hint; intentional asymmetry documented); VP-577-014 added
  (MissingSubcommand → clap listing, no custom hint asserted, parse-level); spec-changelog
  Impact Assessment updated with mainline-refactor risk note.
  MEDIUM-3: BC-3.5.004 "append on separate stderr line" wording pinned; VP-577-004
  strengthened to assert BOTH preamble + Jira error text; H-NEW-COMMENT-003 Expected
  strengthened to match.
  MEDIUM-4: EC-3.5.012-4 added (--dry-run not supported on comment edit/delete this cycle;
  follow-up story candidate; passes --dry-run → exit 2 clap unknown flag).
  LOW-1: BC-3.5.011 reworded "during argument parsing, before any handler dispatch or HTTP
  call"; EC-3.5.009-2/3/4 given same phrasing.
  LOW-2: BC-3.5.008 EC-3.5.008-3 added (--stdin → pipe → --no-input auto-enables → --public
  requires --yes; targeted hint "--stdin disables interactive prompts — pass --yes to confirm
  the visibility change.").
  LOW-4: CANONICAL-COUNTS.md historical note stale parenthetical (612) → (624).
  No BC count change (ECs/VPs/notes within existing bodies).
  Adversary pass-3 remediation (same-version, HIGH-1/HIGH-2/HIGH-3/MEDIUM-1..5/LOW-1..4):
  HIGH-1: 16 stale Source-field citations fixed (non-existent interactions.rs symbols and
  delete/update/get_comment functions → existing anchors workflow.rs::handle_comment and
  add_comment, with "relocates at F4" note); check-bc-citation-symbols.sh passes 334
  citations checked.
  HIGH-2: EC-3.5.012-1 rewritten — two sub-cases: list/ls token → hint directs to
  "jr issue comments" (plural); all other tokens → "use `jr issue comment add` instead"
  (load-bearing pin); try_parse invariant added (non-InvalidSubcommand error kinds pass
  through unmodified byte-identically to pre-refactor); IssueCommand::Comments KEPT clause
  added; VP-577-015 added (list-token hint "jr issue comments" in stderr, exit 2,
  parse-level).
  HIGH-3: PENDING-RESEARCH marker block added to BC-3.5.006 and BC-3.5.007 (Jira PUT
  properties-array merge-vs-replace semantics; implementation BLOCKED until research
  resolves; research/issue-577-properties-merge-replace-2026-07-09.md).
  HIGH-3 closure (human-ruled, same-version): Research verdict MERGE (medium-high
  confidence); local live probe blocked (EJ on E2E sandbox, not local profile instance;
  zero mutations made). Human approved deferral of definitive empirical probe to gated
  CI e2e follow-up. PENDING-RESEARCH marker blocks in BC-3.5.006 and BC-3.5.007 replaced
  with RESOLVED notes documenting the MERGE verdict, confirmed-safe direct-array pattern,
  deferred probe obligation, and the read-modify-write fallback if probe refutes MERGE.
  Delivery-task obligation added to BC-3.5.006: implementing story MUST include (a)
  CLAUDE.md gotcha (MERGE verdict + research citation + do-not-default-to-sending-properties
  rule) and (b) gated e2e test in tests/e2e_live.rs implementing the 5-step MERGE probe
  from research/issue-577-properties-merge-replace-2026-07-09.md against EJ project
  (JR_E2E_JSM_PROJECT), self-cleaning via jsm_self_close. Trace lines updated in both
  BCs. No BC count change.
  MEDIUM-1: EC-3.5.006-2 and EC-3.5.007-2 added (Non-JSM behavior: property sent verbatim,
  Jira silently ignores; no hint fires — mirrors BC-3.5.001).
  MEDIUM-2: BC-3.5.010 JSON output changed to serde_json::Value passthrough (lossless, no
  typed round-trip); VP-577-016 added ("self" Jira-only field survives stdout JSON).
  MEDIUM-3: BC-3.5.010 human render mechanism pinned (plain key-value lines, NOT
  comfy-table; field order: Author, Created, Visibility, body via adf_to_text; routing
  to dedicated render_comment_view function).
  MEDIUM-4: try_parse invariant clause added to EC-3.5.012-1 (clap rendering preservation
  for non-InvalidSubcommand error kinds); VP-577-010 strengthened (assert stderr contains
  "cannot be used with").
  MEDIUM-5: EC-3.5.004-2 added (429-retry 404 edge accepted; no retry-state
  special-casing this cycle).
  LOW-1: EC-3.5.005-2 added and BC-3.5.010 --id validation note added (cross-reference
  EC-3.5.002-1 shared rule across BC-3.5.002/005/010).
  LOW-2: No-truncation note added to BC-3.5.005 Response 200 output (changed_fields.body
  carries raw input without truncation; mirrors BC-3.4.013 lossless channel precedent).
  LOW-3: EC-3.5.008-3 load-bearing pin added (both non-interactive hints MUST contain
  substring "--yes").
  LOW-4: VP-577-008 marker text pinned ("use `jr issue comment add` instead" exact
  substring); VP-577-014 negative assertion rewritten (does NOT contain shared prefix
  "use `jr issue comment"); Trace lines updated.
  No BC count change (all additions are ECs/VPs/notes within existing bodies).
  Adversary pass-4 remediation (same-version, 6 MEDIUM / 4 LOW):
  M1: Cancel envelope key order fixed to serde_json alphabetical in EC-3.5.003-2
  ({"cancelled":true,"deleted":false}), EC-3.5.008-2 ({"cancelled":true,"updated":false}),
  BC-3.5.005 cancel-path cross-ref, and VP-577-013; key-order note added to both primary
  ECs ("matches serde_json default alphabetical; not semantically load-bearing").
  M2: Mainline-refactor-risk row in Impact Assessment extended: SURFACE table obligation
  (four rows replacing single comment row in tests/e2e_cli_surface_guard.rs) and
  tests/e2e_live.rs flat-form call sites (~lines 2513-2548, 3756) update obligation.
  M3: VP-577-007 strengthened — additionally asserts captured wiremock request URL
  contains query parameter "expand=properties".
  M4: BC-3.5.005 edit pipeline validation ordering note added (1: --id regex; 2: body
  resolve + empty check; 3: --public gate; 4: ADF conversion; 5: HTTP PUT); cross-refs
  added to BC-3.5.008 intro and EC-3.5.009-5.
  M5: BC-3.5.004 implementation note added (404 body-surfacing via downcast_ref::<JrError>
  for ApiError{status:404,message} — message carries extracted errorMessages via
  client.rs::parse_error; cross-ref from BC-3.5.010 Response 404 clause).
  M6: EC-3.5.010-2 narrowed — malformed-ADF fallback to raw JSON display applies EXCEPT
  for the recursion depth-guard error (JrError::UserError "nesting too deep"; BC-7.2.012
  / SEC-001), which MUST propagate to exit 64; comment view is NOT a MAX_ADF_DEPTH
  carve-out.
  L1+L2: BC-3.5.010 human render field order updated to ID → Author → Created → Updated
  → Visibility → body (ID added as first field; Updated added between Created and
  Visibility; both lossless display).
  L3: EC-3.5.012-1 implementation note added (argv inspection as recommended
  sub-case discrimination mechanism; clap Error context iterator as acceptable
  alternative; discrimination logic MUST be isolated from rendering path).
  L4: All four unprefixed research/issue-577-properties-merge-replace-2026-07-09.md
  references in §3.5 prefixed with .factory/ (3 lines × occurrences; replace_all).
  No BC count change (all additions are ECs/VPs/notes within existing bodies).
  Adversary pass-5 remediation (same-version, 7 MEDIUM / 2 LOW):
  M1: BC-3.5.010 item 4 "always present" → "present (absent → render N/A)"; human render
  path serde_json::Value access note added; "updated" field added to H-NEW-COMMENT-001
  and H-NEW-COMMENT-004 Setup A holdout fixture JSON.
  M2: BC-3.5.001 title updated to `issue comment add <key> --internal`; one-line body
  note added (canonical CLI form now requires add subcommand per BC-3.5.012 refactor).
  M3: BC-INDEX.md §3.5 Source citations corrected — rows 296–304 had stale refs to
  non-existent delete_comment/update_comment/get_comment functions and interactions.rs
  module; replaced with existing workflow.rs::handle_comment / add_comment anchors
  (with "relocates at F4" notes); also BC-3.5.001 row title updated (M2).
  M4: JSDCLOUD-6050 hint timing pinned in BC-3.5.005 pipeline ordering sentence: fires
  after step 4 ADF conversion succeeds, before step 5 HTTP PUT; does NOT fire if ADF
  conversion fails. Timing cross-note added to EC-3.5.006-1 and EC-3.5.007-1.
  M5: spec-changelog BC-INDEX entry PENDING/BLOCKED language → MODIFIED/done (this entry).
  M6a: BC-3.5.010 human output row 5 renamed `Visibility:` → `JSM internal:` with
  Yes/No/N/A labels; new row 6 `Restricted:` added (Jira visibility object, role/group
  name or "None"); old body row renumbered 7. Field order: ID→Author→Created→Updated→
  JSM internal→Restricted→body.
  M6b: UNRESEARCHED marker block added to BC-3.5.005 for `visibility` field omitted-key
  PUT semantics; research stub path .factory/research/issue-577-visibility-put-semantics-
  2026-07-09.md; F2 implementation MUST omit visibility key (same safe-default as properties).
  M7: EC-3.5.009-6 added to BC-3.5.009 — visibility-only edits not supported; body always
  required; follow-up story candidate pending M6b UNRESEARCHED clarity.
  L1: VP-577-017 added to BC-3.5.008 — `--public --stdin` without `--yes` → exit 64;
  stderr contains "--stdin" AND "--yes"; zero PUT (EC-3.5.008-3 targeted hint pin).
  L2: VP-577-018 added to BC-3.5.012 — `comment add FOO-1 "- [ ] task"` parses without
  clap error (formalizes EC-3.5.012-3 allow_hyphen_values regression pin).
  VP count 16 → 18 (VP-577-017 and VP-577-018 added). No BC count change.
  M6b closure (same-version, post-pass-5 research resolution): UNRESEARCHED marker in
  BC-3.5.005 replaced with RESOLVED blockquote (visibility PRESERVED verdict, medium-high
  confidence; .factory/research/issue-577-visibility-put-semantics-2026-07-09.md; load-
  bearing evidence: child-comment-visibility-400 announcement coherent only under PRESERVED,
  patch-shaped PUT convention, zero restriction-loss reports). BC-3.5.006 delivery-task
  obligation extended: gated e2e probe MUST also include 2-step visibility extension
  (restricted-comment body-only PUT → re-GET → restriction survives). EC-3.5.009-6 wording
  updated to reference RESOLVED verdict rather than UNRESEARCHED. No wire-shape change;
  jr NEVER sends visibility key on comment edit this cycle.
  Adversary pass-6 remediation (same-version, 1 HIGH / 2 MEDIUM / 5 LOW):
  HIGH-1: EC-3.5.006-2 and EC-3.5.007-2 rewritten — trailing "No hint or warning fires"
  replaced: JSDCLOUD-6050 hint still fires on non-JSM projects (jr does not detect JSM vs
  non-JSM at write time; hint is informational and harmless). No additional non-JSM-specific
  warning emitted.
  MEDIUM-1: VP-577-013 updated with JR_STDIN_IS_TTY seam note; implementation note added
  to BC-3.5.003 Verification Properties (debug seam, release-gate required, CLAUDE.md doc
  line ships same commit). BC-3.5.006 delivery-task obligation extended with item (c):
  JR_STDIN_IS_TTY seam implementation + release-gate regression test + CLAUDE.md doc line.
  MEDIUM-2+LOW-1: EC-3.5.010-2 simplified — dead raw-JSON-fallback branch removed; single
  sentence: "Any adf_to_text error propagates to exit 64 (the recursion depth-guard,
  BC-7.2.012 / SEC-001, is currently the only error kind in the reverse-render path)."
  LOW-2: H-NEW-COMMENT-004 Expected B tightened — "comment not found" or "99999" →
  "comment not found" (load-bearing preamble substring only).
  LOW-3: BC-3.5.007 MERGE RESOLVED blockquote collapsed to one-line cross-reference:
  "MERGE semantics: see the RESOLVED block in BC-3.5.006 (verdict + probe deferral apply
  identically here)." BC-3.5.006 retains the full block.
  LOW-4: BC-3.5.005 Response 200 JSON example reordered to alphabetical key order:
  changed_fields → id → key → updated (matches serde_json BTreeMap emission).
  LOW-5: BC-3.5.010 field-4 bullet nested parens flattened: "Updated: — ISO 8601
  timestamp from `updated`; render N/A if the field is absent (uncommon in practice but
  graceful-degradation safe)."
  VP count stays 18 (VP-577-013 modified, none added). No BC count change.
  Adversary pass-7 remediation (same-version, 2 MEDIUM / 5 LOW):
  F1 (MEDIUM): VP-577-001 extended — second wire assertion added: PUT body MUST also not
  contain "visibility" key (.get("visibility").is_none() == true); same assertion added
  to H-NEW-COMMENT-001 Expected.
  F2 (MEDIUM): BC-3.5.005 Implementation note — symmetrical bullet (iii) added: same
  three-pattern rule applies to any visibility field on the PUT request struct; PREFERRED
  pattern is omitting visibility from the request struct entirely.
  F3 (LOW/MEDIUM): EC-3.5.012-3 extended — CommentSubcommand::Edit positional <text>
  MUST also carry allow_hyphen_values = true (file-wide CLAUDE.md invariant); VP-577-019
  added (edit path regression pin: `comment edit FOO-1 --id 10001 "- update"` parses
  without clap error). VP count 18 → 19.
  F4 (LOW): BC-3.5.010 field 2 — fallback clause added: render "Unknown" if author is
  absent, null, or its displayName is missing (parallel to fields 4/5/6).
  F5 (LOW): BC-3.5.003 Implementation note + BC-3.5.006 delivery item (c) — dialoguer
  plumbing clause added: interactive prompts MUST use interact_on(&Term::stdout()) or
  equivalent (NOT /dev/tty); cfg(debug_assertions) conditional prompt acceptable; F4 story
  MUST prove seam+prompt combination works in wiremock subprocess test.
  F6 (LOW): BC-3.5.006 delivery-task probe extended — compound step: comment with BOTH
  role/group restriction AND jr.test.marker; PUT with properties:[sd.public.comment] + NO
  visibility key; re-GET; assert BOTH restriction AND marker survive (closes weakest safety
  cell).
  F7 (LOW): H-NEW-COMMENT-002 Expected — additional assert: stderr contains "visibility
  to public" (SEC-577-001 CWE-1021 wording pin).
  VP count 18 → 19 (VP-577-019 added). No BC count change.
  Adversary pass-8 remediation (same-version, 1 MEDIUM / 3 LOW):
  M1: VP-577-002 (BC-3.5.006) and VP-577-003 (BC-3.5.007) — second wire assertion added to
  each: PUT body MUST also not contain "visibility" key at top level (.get("visibility").is_none()
  == true); the assertion covers all three comment edit paths (body-only, --internal, --public)
  per the BC-3.5.005 note-(iii) NEVER-sends-visibility invariant. Trace lines for BC-3.5.006
  and BC-3.5.007 updated with pass-8 M1 reference.
  L1: BC-3.5.003 Implementation note + BC-3.5.006 delivery item (c) — seam scope extended:
  the JR_STDIN_IS_TTY seam MUST also gate src/main.rs's auto---no-input check
  (std::io::stdin().is_terminal()) so piped stdin under JR_STDIN_IS_TTY=1 does not trigger
  the auto-flip; applying the seam only at the prompt site is insufficient (cli.no_input
  would be forced true before the handler runs, routing to the non-interactive exit-64 branch
  instead of the interactive y/N branch VP-577-013 exercises). BC-3.5.003 Trace updated.
  L2: H-NEW-COMMENT-004 Setup Call B — wiremock mount extended to return body
  {"errorMessages":["Comment with id '99999' does not exist."],"errors":{}};
  Expected B — second bullet added: stderr contains "Comment with id '99999' does not exist."
  (on separate line following preamble; mirrors H-NEW-COMMENT-003 body-surfacing pattern).
  L3: VP-577-020 added to BC-3.5.012 — `jr issue comment ls FOO-1` (ls alias token,
  InvalidSubcommand) → exit 2; stderr contains "jr issue comments" (plural hint; mirrors
  VP-577-015 list-token case; confirms EC-3.5.012-1 two-sub-case discrimination covers ls
  alias). BC-3.5.012 Trace updated with pass-8 L3 reference.
  VP count 19 → 20 (VP-577-020 added). No BC count change.
  Adversary pass-9 remediation (same-version, 1 MEDIUM / 2 LOW):
  F1 (MEDIUM): EC-3.5.008-3 causal wording replaced with prescriptive normative rule —
  the handler MUST treat --stdin as implying no_input=true at handler-start independent
  of TTY detection (a y/N prompt after stdin consumed to EOF reads a dead fd; silent-cancel
  of a state-changing intent is unacceptable); relying on the "stdin is pipe → auto-flip"
  inference fails when JR_STDIN_IS_TTY=1 suppresses the auto-flip with a real pipe stdin.
  VP-577-017 extended with second variant: same invocation with JR_STDIN_IS_TTY=1 set
  (seam active) → still exit 64 (proves the --stdin flag-based branch fires independently
  of TTY-detection state). BC-3.5.008 Trace updated with pass-9 F1 reference.
  F2 (LOW): BC-3.5.005 Response 200 JSON bullet — one-line key-order disclaimer appended
  after the changed_fields.visibility sentence, mirroring EC-3.5.003-2 pattern: "(Key order
  shown matches serde_json default alphabetical emission (Value::Object uses BTreeMap); JSON
  key order is not semantically load-bearing but examples match the wire.)"
  F3 (LOW): BC-3.5.010 Response 404 — Response 403 one-liner added immediately after:
  "Response 403 (if surfaced by endpoint variant) → same treatment: exit 64 + surface body."
  Mirrors BC-3.5.004's 403 clause; ensures comment view exits 64 user-actionably on
  scope-related 403, symmetric with delete.
  VP count stays 20 (VP-577-017 modified, none added). No BC count change.
  Adversary pass-10 remediation (same-version, 1 MEDIUM): spec-changelog.md Mainline
  refactor risk row — tests/e2e_live.rs flat-form call site enumeration completed from
  2 ranges to 5 (~lines 2513-2548, 3756, 4823-4859, 6090-6099, 9687-9695); non-authoritative
  disclaimer appended per #408 citation-form convention; binding obligation is EC-3.5.012-2's
  ALL-sites clause; F4 story MUST re-enumerate via grep at delivery time. No BC/VP/holdout
  count change.
  Adversary pass-11 remediation (same-version, 2 MEDIUM / 2 LOW):
  F1 (MEDIUM): Two occurrences of interact_on(&Term::stdout()) replaced with
  interact_on(&Term::stderr()) — BC-3.5.003 Implementation note and BC-3.5.006 delivery
  item (c). Rationale sentence added to both sites: Term::stderr() writes the prompt to
  stderr per the prompt-to-stderr invariant (EC-3.5.003-2 / EC-3.5.008-2) while dialoguer
  still reads input from stdin (stdin path is independent of the Term used for output).
  Verified: zero Term::stdout() references remain in §3.5. BC-3.5.003 and BC-3.5.006
  Trace lines updated.
  F2 (MEDIUM): BC-3.5.004 Implementation note — output-mode clause added: text mode emits
  two separate stderr lines; --output json mode routes both into H-020 {"error":...,"code":...}
  envelope with newline JSON-escaped as \n; envelope MUST NOT be bypassed; VP-577-004 /
  H-NEW-COMMENT-003 / H-NEW-COMMENT-004 assertions are mode-agnostic. Behavior bullet 404
  (~line 2196) qualified with "(text mode; JSON mode carries both in the single H-020 envelope
  error field)". H-NEW-COMMENT-003 Expected and H-NEW-COMMENT-004 Expected B both qualified
  with same parenthetical. BC-3.5.004 Trace updated.
  F3 (LOW): CANONICAL-COUNTS.md note (line 57) — stale "requires update to 624 (blocked by
  TD-031...)" text replaced with the current state: "BC-INDEX.md total_bcs header was bumped
  to 624 in v1.3.28 via a sanctioned Python shell edit (TD-031 bypassed per established
  workaround). CANONICAL-COUNTS.md remains the primary source of truth; TD-031 line-cite
  violations tracked separately for cleanup."
  F4 (LOW): BC-3.5.006 delivery item (b) — compound-cell sentence rewritten as explicit
  Scenario 3, labeled "NOT a substitute for Scenario 2"; preceding 2-step and 5-step probes
  labeled Scenario 2 and Scenario 1 respectively; "All three scenarios live in the same
  gated e2e test function" replaces "Both probe steps..." BC-3.5.006 Trace updated.
  VP count stays 20. No BC/holdout count change.
  Adversary pass-12 remediation (same-version, 1 HIGH):
  HIGH-1 (L2/L3 drift — bc-03 domain-spec bc_count 109 vs L3 total_bcs 120):
  bc-03-issue-write.md frontmatter bumped bc_count 109 → 120; spec-changelog.md
  Changed Requirements section added with the bc-03 entry; Follow-up Obligations
  section added with L2-BCCOUNT-9TH-SURFACE guard-extension note; CANONICAL-COUNTS.md
  L2 alignment row date corrected 2026-07-09 → 2026-07-10 (actual bump date).
  Root cause: CANONICAL-COUNTS.md L2 alignment table was prematurely marked YES at
  initial F2 spec time, before the L2 domain-spec frontmatter was actually bumped.
  No BC/VP/holdout count change.
  Adversary pass-13 preemptive fix round 17 (CV pass 13 GAP B-ii, delta-attributable):
  §4 Operations table: `issue comment <key>` row renamed `issue comment add <key>` (Option A
  clean break); three rows added: `issue comment delete <key> --id <id>`,
  `issue comment edit <key> --id <id> <body-source>`, `issue comment view <key> --id <id>`.
  §5 Invariants: INV-WRITE-021 command form updated to `issue comment add`; INV-WRITE-025
  added: comment edit operations submit only explicitly-changed fields; properties/visibility
  keys absent from PUT body unless explicit flag passed (MERGE/PRESERVED semantics).
  `invariant_count` 24 → 25. No BC/VP/holdout count change.
  Adversary pass-13 remediation (same-version, 1 MEDIUM-HIGH / 1 MEDIUM / 4 LOW):
  F1 (MEDIUM-HIGH, INV-WRITE-025): rewritten as two-clause form — visibility key absent
  unconditionally (no restriction-editing surface this cycle); properties key absent unless
  --internal/--public passed; MERGE/PRESERVED semantics preserved.
  F2 (MEDIUM): VP-577-021 added to BC-3.5.010 — human-mode render pin: exact label byte-order
  (ID/Author/Created/Updated/JSM internal: Yes/Restricted: None) + body after blank-line
  separator. BC-3.5.010 Trace updated.
  F3 (LOW): CANONICAL-COUNTS.md frontmatter last_verified bumped to 2026-07-10 with
  pass-12+ note; spec-changelog v1.3.28 header note line added.
  F4 (LOW): BC-3.5.010 field 5 — JSDCLOUD-9766 stringly-typed boolean graceful-degradation
  clause added (absent/null/non-boolean value.internal → render N/A; do NOT panic).
  F5 (LOW): BC-3.5.005 — byte-for-byte echo pin added after no-truncation note (whitespace
  trimming applies only to EC-3.5.009-5 gate and ADF input, not JSON echo channel).
  F6 (LOW): BC-3.5.010 JSON passthrough example — renderedBody replaced with jsdPublic;
  clarifier added (renderedBody appears only with ?expand=renderedBody, not requested this cycle).
  VP count 20 → 21 (VP-577-021 added). No BC/holdout count change.
  Adversary pass-14 remediation (same-version, 3 MEDIUM / 2 LOW):
  F1 (MEDIUM, core-invariant hardening): (a) BC-3.5.005 note (ii) rewritten — options (b)/(c)
  cover properties field only in simplest form; achieving "ONLY body" key-set with reused
  Comment struct additionally requires skip_serializing_if on id/author/created; PREFERRED is
  option (a) separate PUT request struct. (b) VP-577-001 strengthened to positive key-set
  containment: keys == exactly {"body"}; VP-577-002/003: keys == exactly {"body","properties"}.
  (c) H-NEW-COMMENT-001 Expected: key-set assertion added (keys == {"body"}).
  F2 (MEDIUM, VP-577-017 untestable): (a) VP-577-017 setup note added: stdin MUST be non-empty
  so step-2 empty-body check passes; EC-3.5.008-3 targeted message emitted at step-3 gate.
  (b) EC-3.5.008-3 clarifier added: "at handler-start" means no_input flag mutation happens
  at handler-start; enforcement still flows through pipeline order (step 2 fires before step 3).
  F3 (MEDIUM, JSON key collision): changed_fields.visibility renamed changed_fields.jsm_internal
  (boolean: true/false; absent when neither flag passed) in BC-3.5.005 JSON example, description
  text, and EC-3.5.008-2 confirm-path. Human echo stays " (visibility: internal/public)" per
  BC-3.4.013 human/machine asymmetry precedent.
  F4 (LOW, hint wording): JSDCLOUD-6050 hint rewording in EC-3.5.006-1 and EC-3.5.007-1:
  "…best-effort on JSM projects — …; no-op on non-JSM projects." (replace_all, 2 occurrences).
  F5 (LOW, properties optionality): (a) EC-3.5.010-1 extended: properties OPTIONAL — may be
  absent entirely on non-JSM issues; Value passthrough preserves either shape; consumers MUST
  treat properties as OPTIONAL. (b) H-NEW-COMMENT-004 Expected A: "properties" dropped from
  required top-level key set; jq assertion already implies presence for JSM fixture.
  VP count stays 21 (modifications only). No BC/holdout count change.
  Adversary pass-15 remediation (same-version, 2 LOW):
  F1 (LOW): BC-3.5.010 fields 3 and 4 — graceful-degradation "or null" added to both:
  `Created:` now reads "render `\"N/A\"` if the field is absent or null (uncommon in practice
  but graceful-degradation safe)"; `Updated:` updated to match same phrasing (was "render N/A
  if the field is absent"). Symmetrical null-guard across all six display fields.
  F2 (LOW): BC-3.5.005 Response 200 — variant clarifier appended immediately after the JSON
  code block: "(The example above illustrates the --internal case; in the default body-only
  variant changed_fields contains only body and the jsm_internal key is omitted entirely;
  in the --public confirmed variant jsm_internal is false.)"
  VP count stays 21. No BC/holdout count change.
  Adversary pass-16 remediation (same-version, 2 LOW):
  F1 (LOW): BC-3.5.005 Implementation note opening sentence — count updated from
  "Two hazards, both violate..." to "Three hazards, all violating the 'key MUST NOT
  be present' invariant, all three caught by VP-577-001's key-set assertion:" (the
  (i)/(ii)/(iii) body was already correct; only the count sentence changed).
  F2 (LOW): BC-3.5.010 field 1 (`ID:`) — graceful-degradation clause added:
  "render `\"N/A\"` if the field is absent or null (uncommon in practice but
  graceful-degradation safe)." Completes symmetrical null-guard across all six display fields.
  VP count stays 21. No BC/holdout count change.
  Adversary pass-17 remediation (same-version, 1 MEDIUM / 1 LOW):
  F1 (MEDIUM): VP-577-022 added to BC-3.5.002 — EC-3.5.002-1 three-command regex guard
  regression pin: (a) delete `--id "../evil"` → exit 64, stderr "invalid comment id",
  wiremock .expect(0) on DELETE; (b) edit `--id "10001;x"` → exit 64, same substring,
  zero PUT; (c) view `--id "../x"` → exit 64, same substring, zero GET. All pre-HTTP
  (parse+guard level; wiremock routes mounted but unhit). Cross-ref note appended to
  EC-3.5.005-2 and BC-3.5.010 --id validation clause. BC-3.5.002 Trace updated.
  F2 (LOW): BC-INDEX.md line 304 (TD-031 sanctioned shell edit) — BC-3.5.010 summary
  updated: "table+JSON output" → "key-value + JSON output" (body forbids comfy-table
  per pass-3 M3; index now consistent with BC body).
  VP count 21 → 22 (VP-577-022 added). VPs row + attributions updated. No BC/holdout count change.
  Adversary pass-18 remediation (same-version, 2 MEDIUM / 4 LOW):
  F1 (MEDIUM, human echo conflation): BC-3.5.005 human success echo updated — `" (visibility: internal)"` / `" (visibility: public)"` → `" (marked internal)"` / `" (marked public)"` (project-agnostic verbing; avoids colliding with word "visibility" and BC-3.5.010's "JSM internal:" field label). Asymmetry citation (~2270) updated to match new marker phrasing and clarify BC-3.4.013 lossy-marker precedent. EC-3.5.008-2 confirm-path explicitly notes human echo `" (marked public)"`.
  F2 (MEDIUM, echo pin unpinned): VP-577-023 added to BC-3.5.005 — `comment edit FOO-1 --id 10001 "  Hello with spaces  " --output json` → `changed_fields.body` byte-for-byte `"  Hello with spaces  "` (whitespace preserved; JSON echo channel is lossless). Mirror assertion added to H-NEW-COMMENT-001 Expected.
  F3 (LOW): EC-3.5.009-1 Rationale rewritten — "exits 1 via `bail!`" → "exits 1 via `?`-propagated `std::io::Error`"; do-NOT instruction updated: "do NOT use bare `?` on `read_to_string` in `edit`; map `ErrorKind::NotFound` to `JrError::UserError`."
  F4 (LOW): BC-3.5.007 Option (a) rationale line 3 — last sentence updated: "The gate flow ALSO surfaces the JSDCLOUD-6050 best-effort caveat via the separate stderr hint (EC-3.5.007-1) emitted after confirmation and before the PUT — the prompt itself stays project-agnostic per SEC-577-001."
  F5 (LOW): BC-3.5.003 Implementation note — seam-gated vs unconditional split: "The seam gates ONE runtime site: src/main.rs's is_terminal() auto-flip. Dialoguer plumbing obligation (UNCONDITIONAL — not a seam-gated site): interact_on(&Term::stderr()) required in all builds." BC-3.5.006 item (c) aligned: "MUST UNCONDITIONALLY use interact_on(&Term::stderr()) — not a seam-gated requirement; required in all builds."
  F6 (LOW, holdout tier): H-NEW-COMMENT-005 added to Group 15 (MUST-PASS): `comment delete FOO-1 --id 10001 --no-input` without `--yes` → exit 64; wiremock .expect(0) on DELETE; stderr contains "--yes" AND "Delete comment". Holdout count 87 → 88: holdout-scenarios.md frontmatter (87→88), intro count (87→88), trace SOH-COMMENT-CRUD-1 updated (+H-NEW-COMMENT-005), Group 15 header updated; CANONICAL-COUNTS.md: Canonical total (87→88), Expected list (+H-NEW-COMMENT-005), Groups added range (57→87 → 57→88), Group 15 row (+4→+5), Note updated. VPs row Holdouts row updated.
  VP count 22 → 23 (VP-577-023 added). Holdout count 87 → 88. No BC count change.
  Adversary pass-19 remediation (same-version, 2 LOW):
  F1 (LOW): EC-3.5.009-6 phrasing corrected — "enforced by EC-3.5.009 at the arg-parsing level" → "enforced by EC-3.5.009's handler-level guard (exit 64)" (body-source-required rule is a handler UserError check, NOT a clap arg-parsing enforcement; EC-3.5.009-2/3/4 arg-parsing phrasing does not apply here).
  F2 (LOW): BC-3.5.010 field 6 (`Restricted:`) — malformed-value fallback clause added: render `"None"` if the visibility key is present but its `value` sub-key is absent, null, non-string, or its `type` sub-key is not `"role"` or `"group"`. Do NOT panic; graceful-degradation-safe like fields 1–5. Completes malformed-value fallback symmetry across all six display fields.
  VP count stays 23. No BC/holdout count change.
  Adversary pass-20 remediation (same-version, 1 MEDIUM / 1 LOW):
  F1 (MEDIUM, edit 404/403 symmetry): (a) BC-3.5.005 — "Response 404 / Response 403" clause added immediately before Verification Properties: 404 → exit 64 (UserError); preamble `"comment not found or permission denied: <KEY>#<ID>"`; Jira body on separate stderr line (text mode) / H-020 envelope (JSON mode); 403 same treatment; BC-3.5.006 and BC-3.5.007 inherit via cross-reference sentence. (b) BC-3.5.004 Implementation note applies-to sentence extended: `"BC-3.5.010 \`comment view\`"` → `"BC-3.5.005 \`comment edit\` ... and BC-3.5.010 \`comment view\`"`. (c) VP-577-024 added to BC-3.5.005 VPs — wiremock PUT returns 404 with errorMessages body → exit 64; stderr contains preamble AND Jira body substrings (mirrors VP-577-004 against the PUT route).
  F2 (LOW, changelog off-by-one): holdout bullet (~line 429) — `total_holdouts` `83 → 87` → `83 → 88`; `intro count 83 → 87` → `83 → 88`; Group-15 enumeration extended to H-NEW-COMMENT-005 (delete confirmation gate, BC-3.5.003).
  VP count 23 → 24 (VP-577-024 added). No BC/holdout count change.
  Adversary pass-21 remediation (same-version, 1 LOW):
  `last_updated` timestamp bumped 2026-07-09 → 2026-07-10 in three files: bc-3-issue-write.md frontmatter (Edit tool); holdout-scenarios.md frontmatter (Edit tool); BC-INDEX.md frontmatter (sanctioned Python shell, TD-031) with shell-edit note extended: "; pass-17 F2 wording fix 2026-07-10" appended. No BC/VP/holdout count change.
  Adversary pass-22 remediation (same-version, 1 MEDIUM / 3 LOW):
  F1 (MEDIUM, field-7 fallback): BC-3.5.010 item 7 — body fallback clause appended: absent/null body → empty body block (blank line, no additional content); Do NOT panic; present malformed ADF MAY propagate adf_to_text error per EC-3.5.010-2. VP-577-021 strengthened with second fixture variant: body-absent comment → exit 0; header fields render with graceful-degradation fallbacks; empty body block; no panic.
  F2 (LOW, holdout mirror unverifiable): H-NEW-COMMENT-001 VP-577-023 mirror bullet replaced with pure cross-reference: "Byte-for-byte JSON-echo behavior is verified separately by VP-577-023 (BC-3.5.005) and is not asserted by this holdout (the Action runs without --output json)."
  F3 (LOW, L2 §2 entity row): bc-03-issue-write.md §2 Comment row Notes cell updated (Python shell, TD-031): full CRUD annotation added — add/delete/edit/put wire shape/visibility/view endpoints, ADF body.
  F4 (LOW, obligation placement): BC-3.5.003 — Delivery-task obligation paragraph added (duplicate of BC-3.5.006 item (c), with "See also BC-3.5.006 item (c)" cross-reference); BC-3.5.003 Trace updated; BC-3.5.006 item (c) end appended with "(Duplicated at BC-3.5.003 delivery obligation.)"
  VP count stays 24 (VP-577-021 modified, none added). No BC/holdout count change.
  Adversary pass-23 remediation (same-version, 7 LOW):
  L1: holdout-scenarios.md H-NEW-COMMENT-004 Expected A — `"updated"` added to top-level-keys-include list (alongside `"id"`, `"author"`, `"body"`, `"created"`).
  L2: BC-3.5.003 — **Delete-pipeline ordering pin** sentence added before EC-3.5.003-1: step 1 = --id regex validation (EC-3.5.002-1); step 2 = confirmation gate (BC-3.5.003 items 1–3); step 3 = HTTP DELETE.
  L3: VP-577-021 second variant — byte-level pin appended: stdout ends with `"Restricted: None\n\n"` (structural blank line separator always renders, nothing follows on body-absent path).
  L4: BC-3.5.005 Implementation note (i) — `CommentProperty` → `EntityProperty` (correct type name matching `src/types/jira/issue.rs`).
  L5: BC-3.5.009 EC-3.5.009-6 — both occurrences of `"EC-3.5.009's"` → `"BC-3.5.009's body-required rule"` (rule lives in BC body prose, not a labeled EC).
  L6+L7: BC-3.5.003 seam content collapsed: (1) VP-577-013 seam note pointer updated "see the implementation note below" → "see the Delivery-task obligation below"; (2) Implementation note replaced with one-liner pointer ("Seam mechanism and delivery obligation: see the Delivery-task obligation below; duplicated at BC-3.5.006 item (c)."); (3) Delivery-task obligation opening reworded "(c) a `JR_STDIN_IS_TTY`..." → "Per BC-3.5.006 item (c), duplicated here: a `JR_STDIN_IS_TTY`..."; test-reachability rationale merged in after "prompt tests)" — "— the interactive branch (TTY path) is unreachable in wiremock tests without this seam; when set to `"1"` in a debug build, `jr` treats stdin as a TTY regardless of the actual fd state"; trailing "(See also BC-3.5.006 item (c)...)" removed (superseded by opening). grep -c "seam gates ONE runtime site" across bc-3-issue-write.md = 2 (BC-3.5.003 Delivery-task + BC-3.5.006 item (c)).
  VP count stays 24. No BC/holdout count change.
  Adversary pass-24 remediation (same-version, 1 MEDIUM / 4 LOW):
  F1 (MEDIUM, view-404 contract): BC-3.5.010 Response 404 clause — "Surface Jira response body if present" replaced with verbatim BC-3.5.005 contract wording: exit 64 (`UserError`); stderr: `"comment not found or permission denied: <KEY>#<ID>"`; Jira response body appended on separate stderr line (text mode) / carried in H-020 envelope error field newline-escaped (JSON mode); reference to BC-3.5.004 `downcast_ref::<JrError>()` body-surfacing mechanism added. Research verdict citation retained (Claim 3 CONFIRMED).
  F2 (LOW, typo-routing note): EC-3.5.012-1 second sub-case (all other tokens → 'add' hint) — note appended: "Typos of delete/edit/view (e.g. `del`, `edt`, `vw`) also receive the 'add' hint by design this cycle — the fixed hint favors the migration case; Levenshtein-based typo discrimination ... is a follow-up story candidate."
  F3 (LOW, case-insensitive token note): EC-3.5.012-1 first sub-case (list/ls → plural hint) — note appended: "Token matching for the list/ls sub-case is case-insensitive (`eq_ignore_ascii_case` — `LS`, `List`, `LIST` all route to the plural hint)."
  F4 (LOW, field-7 modality fix): BC-3.5.010 item 7 — "MAY propagate an `adf_to_text` error" → "that produces an `adf_to_text` error propagates per EC-3.5.010-2 (currently only the recursion depth-guard; exit 64)" (modality: MUST, not MAY).
  F5 (LOW, add-asymmetry note): EC-3.5.009-2 — note appended clarifying that `comment add`'s three-body-source resolution retains legacy priority order (positional > `--file` > `--stdin`) WITHOUT clap `conflicts_with` — deliberate asymmetry; aligning `add` to clap-level mutual exclusion is a follow-up story candidate.
  VP count stays 24. No BC/holdout count change.
  Adversary pass-27 remediation (same-version, 2 MEDIUM / 2 LOW):
  F1 (MEDIUM, pass-26 F3 reversal — code-verified): bc-3-issue-write.md — restored the trim-to-ADF rule at BOTH sites (BC-3.5.005 Byte-for-byte echo pin ~2277 and VP-577-023 ~2289). Pass-26 F3's premise (add passes raw to text_to_adf) was REFUTED by code verification: `workflow.rs::handle_comment` contains `let text = text.trim().to_string()` before ADF conversion. New wording at both sites: "Whitespace trimming applies to the EC-3.5.009-5 emptiness gate AND to the ADF conversion input (matching comment add's trim-then-ADF behavior — verified: `workflow.rs::handle_comment` runs `let text = text.trim().to_string()` before ADF conversion); the JSON echo channel (`changed_fields.body`) receives the raw pre-trim source string byte-for-byte."
  F2 (MEDIUM, conditional-prompt contradiction): bc-3-issue-write.md — deleted "a `#[cfg(debug_assertions)]` conditional prompt is an acceptable alternative; the seam gates ONE runtime site — `src/main.rs`'s `is_terminal()` auto-`--no-input` flip (NOT the prompt site; applying the seam only at the prompt site is insufficient — `cli.no_input` would be forced `true` before the handler runs)" from BOTH duplicated delivery obligation sites (BC-3.5.003 ~2186 and BC-3.5.006 ~2319) using replace_all=true. Replaced with: "interact_on(&Term::stderr()) MUST be used unconditionally (required in all builds); the seam gates ONLY the src/main.rs auto-`--no-input` flip". Both sites verified verbatim-identical (grep -c = 2). Old "seam gates ONE runtime site" count reduced to 0 across the file.
  F3 (LOW, false citation): bc-3-issue-write.md BC-3.5.002 ~2139 — "research Claim 3 verdict: treat as opaque string" replaced with pragmatic rationale: "treating `--id` as an opaque string avoids u64-range hazards on legacy/hosted instances".
  F4 (LOW, process-gap): bc-3-issue-write.md — EC-3.5.012-5 added after EC-3.5.012-4 enumerating try_parse regression obligations as story-input scope (BC-3.4.011, BC-3.7.003/004, BC-3.8.010, --help snapshots, e2e_cli_surface_guard SURFACE 4-row split, e2e_live.rs flat-form sweep per EC-3.5.012-2; "regression suites for each MUST pass unchanged post-refactor"). One-line pointer bullet added in spec-changelog.md v1.3.28 Follow-up Obligations block referencing EC-3.5.012-5.
  VP count stays 24. No BC/holdout count change.
  Adversary pass-26 remediation (same-version, 3 LOW):
  F1 (LOW, summary paragraph holdout count): spec-changelog.md §Summary — "plus 4 holdout scenarios (H-NEW-COMMENT-001..H-NEW-COMMENT-004)" → "plus 5 holdout scenarios (H-NEW-COMMENT-001..H-NEW-COMMENT-005)".
  F2 (LOW, L2 §1 Ubiquitous Language + §3 Invariants): bc-03-issue-write.md (TD-031 Python shell): (a) `--internal` row ~30 — "Flag on `issue comment` that adds" → "Flag on `issue comment add` (append path) and `issue comment edit` (PUT path) that adds"; (b) INV-WRITE-006 row ~102 — "Comment `--internal` adds" → "`issue comment add --internal` (and `edit --internal`) adds".
  F3 (LOW, ADF-trimming claim): bc-3-issue-write.md — two occurrences of "Whitespace trimming applies only to the EC-3.5.009-5 emptiness gate and [to] the ADF conversion input, not to the JSON echo channel" rewritten to the Option-A ruling: "Whitespace trimming applies only to the EC-3.5.009-5 emptiness gate; both the JSON echo channel AND the ADF conversion input receive the raw pre-trim source string byte-for-byte (symmetric with comment add's legacy behavior)." Affected sites: BC-3.5.005 Byte-for-byte echo pin (~line 2277) and VP-577-023 (~line 2289). EC-3.5.009-5 wording and BC-3.5.005 pipeline pin step 4 were checked and require no change (neither asserts ADF conversion receives a trimmed value).
  VP count stays 24. No BC/holdout count change.
  Adversary pass-25 remediation (same-version, 1 LOW + 1 informational preempt):
  Fix 1 (LOW, changelog CANONICAL-COUNTS.md bullet): spec-changelog.md CANONICAL-COUNTS.md bullet — three corrections: (a) "83 → 87" → "83 → 88"; (b) "H-NEW-COMMENT-001..004" → "H-NEW-COMMENT-001..005"; (c) "Last reconciled 2026-07-09" → "Last reconciled 2026-07-10". Brings changelog bullet into alignment with the actual CANONICAL-COUNTS.md file content.
  Fix 2 (informational preempt, mixed-case variant): VP-577-020 extended with mixed-case invocation line: `jr issue comment LS FOO-1` → exit 2; stderr contains `"jr issue comments"` (pins the EC-3.5.012-1 pass-24 F3 `eq_ignore_ascii_case` rule). Trace updated to reference adversary pass-25. VP count stays 24.
  No BC/holdout count change.
  Adversary pass-28 remediation (same-version, 1 MEDIUM / 2 LOW + 1 informational):
  F1 (MEDIUM, 403-scope carve-out): bc-3-issue-write.md — BC-3.5.004 403 clause updated: added scope-indicator carve-out (case-insensitive substring `"scope"` in body → re-wrap as `JrError::InsufficientScope`, exit 2; all other 403s exit 64 + surface body; follows `client.rs` 401-scope branch and BC-3.8.014/015 UX; follow-up candidate: general-purpose `parse_error` branch). Inheritance wording verified: existing cross-refs at BC-3.5.005 and BC-3.5.010 were NOT sufficient (referenced implementation note only, not 403 clause); updated both 403 clauses to "inherits BC-3.5.004's 403 clause in full, including the scope-indicator carve-out". Follow-up Obligations bullet added to v1.3.28 block.
  F2 (LOW, citation precision): bc-3-issue-write.md BC-3.5.010 Response 404 — "research verdict: Claim 3 CONFIRMED — Jira conflates 404 and permission-equivalent 403 for comment endpoints to avoid resource-existence disclosure; same rationale as BC-3.5.004" → "applied by architectural inference from Claim 3 (DELETE-verified) to GET; same rationale as BC-3.5.004".
  F3 (LOW, mutation scope): bc-3-issue-write.md EC-3.5.008-3 — opening condition narrowed: "When `--stdin` is used as the body source," → "When `--stdin` is used as the body source AND `--public` is set," (same runtime behavior; future-proofs against latent prompts on non-`--public` paths).
  Informational: bc-3-issue-write.md BC-3.5.004 Implementation note — sentence added: "The handler MUST re-wrap the matched `ApiError` into `JrError::UserError` (exit 64) — `ApiError`'s default exit code is 1 (`error.rs` catch-all)."
  VP count stays 24. No BC/holdout count change.
  Adversary pass-29 remediation (same-version, 2 HIGH / 2 MEDIUM / 2 LOW):
  H1 (body-source priority inverted; code-verified): (a) bc-3-issue-write.md EC-3.5.009-2 note — "legacy priority order (positional > `--file` > `--stdin`)" → "legacy priority order (`--stdin` > `--file` > positional)" + code-verified pin added ("verified: `workflow.rs::handle_comment` resolution chain begins `if stdin { … } else if let Some(ref path) = file { … } else if let Some(ref msg) = message`"). (b) bc-03-issue-write.md INV-WRITE-021 (TD-031 Python shell) — "positional arg → `--file <path>` → `--stdin`" → "`--stdin` → `--file <path>` → positional arg". Pass-24 F5's stated priority order was INVERTED; corrected by code verification.
  H2+M1 (carve-out removed — InsufficientScope Display is POST-specific): bc-3-issue-write.md — BC-3.5.004 403 clause carve-out removed entirely; ALL 403 causes now exit 64 + surface body; surfaced body disambiguates OAuth-scope causes. BC-3.5.005 and BC-3.5.010 403 clauses reverted to simple inheritance cross-ref ("same treatment as 404: exit 64 + surface body — inherits BC-3.5.004's 403 clause"). spec-changelog.md Follow-up Obligations bullet replaced: "403-scope detection in parse_error" → "Method-agnostic OAuth-scope 403 hint: general-purpose `parse_error` branch with corrected Display wording (current `InsufficientScope` Display is POST-specific and unsuitable for comment CRUD verbs) — follow-up story candidate."
  M2 (wrong cleanup mechanism): bc-3-issue-write.md BC-3.5.006 delivery-task — "self-clean via `jsm_self_close`" rewritten to per-comment DELETE cleanup: `jr issue comment delete <key> --id <cid> --yes` mandatory; jsm_self_close NOT used (closes parent issue, consumes reusable EJ asset); parent MAY be closed via jsm_self_close at teardown; comment-DELETE step is mandatory in either flow.
  L1 (duplicate property entries): bc-3-issue-write.md BC-3.5.010 field 5 — sentence added: "If multiple entries share key == `"sd.public.comment"`, the FIRST such entry (by array order) is authoritative; subsequent duplicates are ignored (matches `iter().find()` idiom)."
  L2 (non-NotFound IO errors): bc-3-issue-write.md EC-3.5.009-1 — scope note appended: "EC-3.5.009-1 covers `ErrorKind::NotFound` only; broader IO-error remaps (permission-denied, is-a-directory) are follow-up story candidates in the same class as the add exit-code alignment."
  L3 (argv inspection hazard): bc-3-issue-write.md EC-3.5.012-1 Implementation note — rewritten to REQUIRE clap `Error` context() iterator as authoritative source; argv inspection demoted to NON-RECOMMENDED with rationale (global-flag reordering hazard: `jr --output json issue comment KEY "text"` breaks naive positional scans).
  VP count stays 24. No BC/holdout count change.
  Adversary pass-30 remediation (same-version, 2 LOW + 2 informational hardenings):
  F1 (LOW, missing implementation option): bc-3-issue-write.md BC-3.5.005 Implementation note — option (d) added to the "Implementations MUST choose one of:" list: "construct the payload via the `serde_json::json!` macro with `body` always present and `properties` conditionally injected — mirrors `add_comment` at `src/api/jira/issues.rs` (existing project idiom); needs no struct at all and natively satisfies the key-set invariant." (c) changed from "or (c)" to "(c)" in the list conjunction.
  F2 (LOW, stale --no-input clause): bc-03-issue-write.md INV-WRITE-021 (TD-031 Python shell) — trailing sentence "Exactly one source must be present in `--no-input` mode." replaced with "In `--no-input` mode, at least one body source MUST be provided; when multiple are supplied, resolution follows the priority order above (`--stdin` > `--file` > positional) — supplying multiple sources is NOT an error (matches `handle_comment`'s if/else-if chain)."
  IH1 (informational hardening): bc-3-issue-write.md BC-3.5.010 typed-struct sentence — "the typed `Comment` struct is NOT extended this cycle" strengthened to "the typed `Comment` struct is NOT extended this cycle and MUST NOT be used for deserializing the view response — it would silently drop `updated`/`self`/`updateAuthor`/`visibility`/`jsdPublic` — the `serde_json::Value` passthrough is mandatory."
  IH2 (informational hardening): holdout-scenarios.md H-NEW-COMMENT-001 setup step 2 note — parenthetical "(no `--internal`/`--public`)" reworded to unambiguous description: invocation context stated first ("passes no visibility flags — `--internal`/`--public` are absent") followed by DEC-168 invariant ("GET is never called on any edit path regardless of visibility flags; `.expect(0)` mount asserts this invariant holds for this specific invocation").
  VP count stays 24. No BC/holdout count change.
  Adversary pass-31 remediation (same-version, 2 LOW):
  F1 (LOW, --no-input conditional prefix overly narrow): bc-03-issue-write.md INV-WRITE-021 (TD-031 Python shell) — "In `--no-input` mode, at least one body source MUST be provided;" replaced with "At least one body source MUST be provided in ANY mode (interactive or `--no-input`);" — the handler bail! fires unconditionally regardless of interactive/non-interactive mode (code-verified).
  F2 (LOW, add row missing <body-source> in signature): bc-03-issue-write.md §4 Operations table add row (TD-031 Python shell) — command cell updated from `issue comment add <key>` to `issue comment add <key> <body-source>`; notes column extended with "`<body-source>` is one of: positional text, `--file <path>`, or `--stdin`." (mirrors edit row's signature form).
  VP count stays 24. No BC/holdout count change.

- `.factory/specs/prd/holdout-scenarios.md` (MODIFIED): `total_holdouts` 83 → 88;
  `version` 1.5.1 → 1.5.2; `last_updated` updated; trace entry added for
  SOH-COMMENT-CRUD-1; intro count 83 → 88; Group 15 added with H-NEW-COMMENT-001
  (body-only PUT wire assert, BC-3.5.005), H-NEW-COMMENT-002 (--public non-interactive
  gate, BC-3.5.008), H-NEW-COMMENT-003 (delete 404 → exit 64 + body surfaced, BC-3.5.004),
  H-NEW-COMMENT-004 (view roundtrip + 404 exit 64, BC-3.5.010), H-NEW-COMMENT-005
  (delete confirmation gate — `--no-input` without `--yes` → exit 64; no DELETE sent, BC-3.5.003).

- `.factory/specs/prd/CANONICAL-COUNTS.md` (MODIFIED): `last_verified` updated;
  bc-3 definitional count 80 → 91; total individually-bodied 383 → 394; bc-3 total_bcs
  109 → 120; Sum 613 → 624; Grand total 613 → 624 (note extended); breakdown 613/383 →
  624/394; BC-X.4.009 references updated; L2 alignment table bc-03 109 → 120; holdout
  section canonical total 83 → 88 (Expected list extended with H-NEW-COMMENT-001..005;
  Group 15 entry added; trailing note frontmatter 83→88, Last reconciled 2026-07-10).

- `.factory/specs/prd/BC-INDEX.md` (MODIFIED): total_bcs 613 → 624; bc-3 section
  "109 BCs cumulative; 80 individually-bodied" → "120 BCs cumulative; 91
  individually-bodied"; §3.5 subsection header + table rows for BC-3.5.002..BC-3.5.012
  added; BC-3.5.001 title updated (add subcommand form); BC-3.5.002..010 Source citations
  corrected (stale delete_comment/update_comment/get_comment/interactions.rs refs →
  existing anchors workflow.rs::handle_comment / add_comment with "relocates at F4" note).
  Executed via sanctioned Python shell edit (TD-031 stable-anchor hook bypassed per
  established workaround; adversary pass-5 M2/M3 remediation 2026-07-09).

- `.factory/spec-changelog.md` (MODIFIED): this entry (v1.3.27 → v1.3.28).

### Changed Requirements

- `.factory/specs/domain-spec/bc-03-issue-write.md` (MODIFIED): `bc_count` 109 → 120 (L2/L3 alignment for +11 BCs BC-3.5.002..012); §4 Operations table updated — `issue comment <key>` row renamed to `issue comment add <key>` (Option A clean break); three rows added (`issue comment delete <key> --id <id>`, `issue comment edit <key> --id <id> <body-source>`, `issue comment view <key> --id <id>`); §5 Invariants: INV-WRITE-021 command form updated (`issue comment` → `issue comment add`); INV-WRITE-025 added (comment edit body-only PUT safety — properties/visibility absent from PUT body unless explicit flag passed; MERGE/PRESERVED semantics); `invariant_count` 24 → 25.

### Follow-up Obligations

- **Guard-extension follow-up (L2-BCCOUNT-9TH-SURFACE)**: extend `scripts/check-bc-cumulative-counts.sh` to assert L2 domain-spec `bc_count` == L3 `total_bcs` per file (9th surface) + update the `CLAUDE.md` 8-surfaces description — follow-up story candidate; recurrence class of BC-INDEX-9TH-SURFACE.
- **try_parse regression obligations (EC-3.5.012-5)**: S-577-1 story MUST include regression tests for all clap error surfaces affected by the `try_parse()` refactor — BC-3.7.003/004, BC-3.8.010, `--help` snapshots, `e2e_cli_surface_guard.rs` SURFACE table 4-row split, `e2e_live.rs` flat-form sweep (EC-3.5.012-2); see EC-3.5.012-5. (BC-3.4.011 removed at pass-32 F4 — post-clap HTTP-400 handling, orthogonal to parse-time intercept.)
- **Method-agnostic OAuth-scope 403 hint**: general-purpose `parse_error` branch with corrected Display wording (current `InsufficientScope` Display is POST-specific and unsuitable for comment CRUD verbs) — follow-up story candidate.

### Impact Assessment

| Dimension | Detail |
|-----------|--------|
| BCs added | BC-3.5.002..BC-3.5.012 (11 individually-bodied BCs in bc-3-issue-write.md §3.5) |
| Holdouts added | H-NEW-COMMENT-001..H-NEW-COMMENT-005 (Group 15, holdout-scenarios.md) |
| VPs added | VP-577-001 (body-only PUT wire — properties + visibility absence), VP-577-002 (--internal wire), VP-577-003 (--public wire), VP-577-004 (delete-404 exit-64), VP-577-005 (delete non-interactive gate), VP-577-006 (--public non-interactive gate), VP-577-007 (view JSON shape + expand=properties URL assert), VP-577-008 (BC-3.5.012 InvalidSubcommand exit-2 + "use `jr issue comment add` instead"), VP-577-009 (BC-3.5.002 DELETE 204 JSON shape), VP-577-010 (BC-3.5.011 --internal --public exit-2 + "cannot be used with"), VP-577-011 (BC-3.5.009 --file not-found exit-64), VP-577-012 (BC-3.5.009 whitespace body exit-64), VP-577-013 (BC-3.5.003 cancel-in-JSON-mode envelope + JR_STDIN_IS_TTY seam), VP-577-014 (BC-3.5.012 MissingSubcommand clap listing, no custom hint), VP-577-015 (BC-3.5.012 list-token hint "jr issue comments", exit-2), VP-577-016 (BC-3.5.010 lossless JSON passthrough — "self" Jira-only field survives), VP-577-017 (BC-3.5.008 --public --stdin without --yes → exit 64; stderr contains "--stdin" AND "--yes"; zero PUT), VP-577-018 (BC-3.5.012 EC-3.5.012-3 allow_hyphen_values — `comment add FOO-1 "- [ ] task"` parses without clap error), VP-577-019 (BC-3.5.012 EC-3.5.012-3 allow_hyphen_values — `comment edit FOO-1 --id 10001 "- update"` parses without clap error), VP-577-020 (BC-3.5.012 EC-3.5.012-1 ls-alias-token hint — `jr issue comment ls FOO-1` → exit 2; stderr contains "jr issue comments" plural-form hint; mirrors VP-577-015), VP-577-021 (BC-3.5.010 human-mode render pin — `comment view FOO-1 --id 10001` NO --output json → exit 0; stdout field labels ID/Author/Created/Updated/JSM internal: Yes/Restricted: None in byte order; body after blank-line separator), VP-577-022 (BC-3.5.002 EC-3.5.002-1 regex guard — three-command pin: delete/edit/view `--id` path-injection → exit 64; zero HTTP calls; wiremock routes mounted but unhit), VP-577-023 (BC-3.5.005 byte-for-byte echo-channel pin — `"  Hello with spaces  "` preserved in `changed_fields.body`; trimming applies only to emptiness gate and ADF conversion), VP-577-024 (BC-3.5.005 edit-404 exit-64 — wiremock PUT returns 404 → exit 64; stderr contains preamble AND Jira body; mirrors VP-577-004 against the PUT route) |
| BC count | 613 → 624 (CANONICAL-COUNTS.md authoritative; BC-INDEX.md MODIFIED via sanctioned shell edit — all surfaces now agree) |
| Breaking change | CLI: `jr issue comment KEY "text"` → `jr issue comment add KEY "text"` (BC-3.5.012) |
| Design decision | --public always-confirm (Option a; DEC-168 open point resolved; recorded in BC-3.5.007) |
| Scripts | check-spec-counts.sh — bc-3 frontmatter and body agree; check-bc-cumulative-counts.sh — all 8 surfaces agree (BC-INDEX.md MODIFIED); check-bc-citation-symbols.sh — all §3.5 citations use existing anchors |
| ADR recommendation | No new ADR warranted — breaking CLI change (comment→subcommand group) is documented via BC-3.5.012 + CHANGELOG entry in S-577-1 PR. The pattern is a CLI evolution, not an architectural decision. ADR-0012 already covers the shard extraction trigger; no new ADR needed. |
| Mainline refactor risk | EC-3.5.012-1 requires changing `src/main.rs` `Cli::parse()` → `try_parse()` (or equivalent) to intercept `ErrorKind::InvalidSubcommand` under `issue comment` and inject the "comment add" hint. This modifies the whole-CLI clap error path, creating regression risk for all other clap error surfaces. The implementing story (S-577-1) MUST include regression-test obligations for: BC-3.4.011 (cross-hierarchy `--type` 400 hint) [removed from regression-test obligations at adversary pass-32 F4, v1.3.29 — post-clap HTTP-400 handling, orthogonal to the parse-time intercept], BC-3.7.003/004 (remote-link error paths), BC-3.8.010 (JSM create error paths), and `--help` snapshot tests. Additionally, the `tests/e2e_cli_surface_guard.rs` SURFACE table MUST be updated in the same PR: the existing single row `(&["issue","comment"], &["--output","--internal","--file","--stdin","--markdown"])` MUST be replaced with four rows — one each for `comment add`, `comment delete`, `comment edit`, and `comment view` — each carrying its own flag set. Also, existing `tests/e2e_live.rs` call sites using the old flat comment form (~lines 2513-2548, 3756, 4823-4859 (--file/--stdin/--markdown channel tests), 6090-6099, 9687-9695) ride the EC-3.5.012-2 obligation and MUST be updated to the `comment add` form in the same PR as the CLI refactor. Line numbers are approximate and NON-authoritative (per the #408 citation-form convention) — the binding obligation is EC-3.5.012-2's ALL-sites clause; the F4 story MUST re-enumerate via `grep -n '"issue", *"comment"' tests/e2e_live.rs` at delivery time and update every match. |

---

## [1.3.27] - 2026-07-09

### Type: PATCH

### Summary

Post-fix micro-BC for SOH-BUGS-1 bundle (DEC-165, human-approved as recommended).
BC-X.1.011 added to `cross-cutting.md` §X.1 HTTP Client: `jr api -X / --method`
accepts HTTP method values case-insensitively — DELETE, delete, and Delete all parse
to `HttpMethod::Delete` and dispatch HTTP DELETE. VP-590-001 registered in BC-X.1.011
§Verification Properties. Fixes issues #590 (uppercase -X rejected by clap) and #582
(feature: match curl -X / gh api -X convention). PR #597 merged @ 4f3960e0 on develop.

BC count 612 → 613 (one individually-bodied BC added; cross-cutting.md
definitional_count 82 → 83, total_bcs 148 → 149).

Note: BC-INDEX.md total_bcs and section X header require a corresponding bump to 613 /
149 BCs, but direct edits to BC-INDEX.md are blocked by the TD-031 validate-stable-anchors
hook (243 pre-existing volatile line-cite violations in the Source column). State-manager
must resolve by either (a) running a TD-031 cleanup pass on BC-INDEX.md first, or (b)
using a hook-bypass mechanism. CANONICAL-COUNTS.md is authoritative and reflects 613.

### Changed Requirements

- `.factory/specs/prd/cross-cutting.md` (MODIFIED): `total_bcs` 148 → 149;
  `definitional_count` 82 → 83; `last_updated` 2026-07-06 → 2026-07-09; SOH-BUGS-1
  trace entry added; intro paragraph count updated; BC-X.1.011 body added after
  BC-X.1.010 with Preconditions, Postconditions, Invariants, Edge Cases, Verification
  Properties (VP-590-001), and amendment log.

- `.factory/specs/prd/CANONICAL-COUNTS.md` (MODIFIED): cross-cutting.md definitional
  count 82 → 83; individually-bodied total 382 → 383; cross-cutting.md total_bcs
  148 → 149; Sum row 612 → 613; grand total prose 612 → 613; grand total note extended
  with BC-X.1.011 entry; `last_verified` updated.

- `.factory/spec-changelog.md` (MODIFIED): this entry (v1.3.26 → v1.3.27).

- `.factory/specs/prd/BC-INDEX.md` (PENDING): total_bcs 612 → 613; last_updated
  2026-07-07 → 2026-07-09; sections list cross-cutting count 148 → 149 / 82 → 83;
  Section X header count update; X.1 subsection header 10 → 11 BCs; BC-X.1.011 row
  added. BLOCKED by TD-031 hook — requires state-manager resolution.

### Impact Assessment

| Dimension | Detail |
|-----------|--------|
| BC added | BC-X.1.011 (`-X`/`--method` case-insensitive; `cross-cutting.md` individually-bodied) |
| VP added | VP-590-001 (uppercase/lowercase/mixed-case DELETE dispatches HTTP DELETE; registered in BC-X.1.011) |
| BC count | 612 → 613 (CANONICAL-COUNTS.md authoritative; BC-INDEX.md pending TD-031 cleanup) |
| Scripts | check-spec-counts.sh — cross-cutting.md frontmatter and body now agree; check-bc-cumulative-counts.sh — will diverge on BC-INDEX.md surfaces until TD-031 cleanup; check-bc-citation-symbols.sh — no new `:NNN` cites introduced |

---

## [1.3.26] - 2026-07-09

### Type: PATCH

### Summary

BC/VP amendments for issue #589 (SOH-BUGS-1 bundle, F1 gate approved 2026-07-09).
`AllowedValue.id` typed `Option<String>` in `src/types/jira/editmeta.rs` to
accommodate GDPR-era user/group picker fields that carry `accountId` instead of `id`.

No new BCs added; no BC count surfaces changed. EC-3.4.016-8 added to BC-3.4.016
(id=None matched option entry → exit 64). VP-589-001 added to BC-3.4.015.
VP-396-002 and VP-396-008 clarified/extended in BC-3.4.016, BC-3.4.015, and
BC-3.4.017 respectively.

Note: EC numbering — the delta analysis proposed EC-3.4.016-5 for the id=None case,
but EC-3.4.016-5 through EC-3.4.016-7 were already defined in the original F2 creation
(case-insensitive matching, uppercase matching, exact-over-substring precedence). Per
the append-only numbering rule, the new id-absent edge case is assigned EC-3.4.016-8
(next sequential). The delta analysis had a counting error.

### Changed Requirements

- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED): `last_updated` 2026-06-30 →
  2026-07-09; frontmatter trace section extended with three F1 amendment entries
  (BC-3.4.015, BC-3.4.016, BC-3.4.017 SOH-BUGS-1 amendments); BC-3.4.015 VP-396-008
  extended (idless allowedValues dry-run sub-case); BC-3.4.015 VP-589-001 added;
  BC-3.4.015 Trace updated (AllowedValue.id Option<String> note + research reference);
  BC-3.4.015 amendment log entry added; BC-3.4.016 Step 1 id-bypass amended (id=None
  excluded); BC-3.4.016 Invariant 4 extended (id=None excluded from bypass); BC-3.4.016
  EC-3.4.016-8 added (id-absent matched entry → exit 64; load-bearing substrings
  "no machine-readable id" and "--field"); BC-3.4.016 VP-396-002 clarified (non-None id
  required for {"id":...} wire form); BC-3.4.016 Trace updated; BC-3.4.016 amendment
  log entry added; BC-3.4.017 VP-396-008 extended (idless allowedValues sub-case);
  BC-3.4.017 amendment log entry added.

- `.factory/phase-f2-spec-evolution/verification-delta-589.md` (NEW): VP-589-001 test
  strategy, VP-396-002 clarification test strategy (EC-3.4.016-8), VP-396-008 extension
  test strategy (idless × dry-run). Consumed by F4 test-writer for issue #589 story.

- `.factory/spec-changelog.md` (MODIFIED): this entry (v1.3.25 → v1.3.26).

### Impact Assessment

| Dimension | Detail |
|-----------|--------|
| BC count | UNCHANGED — 612 total, 80 individually-bodied in bc-3 |
| EC added | EC-3.4.016-8 (one new edge case in BC-3.4.016) |
| VP added | VP-589-001 (new, in BC-3.4.015) |
| VP clarified | VP-396-002 (BC-3.4.016 §Verification Properties) |
| VP extended | VP-396-008 (BC-3.4.015 and BC-3.4.017 §Verification Properties) |
| Scripts | check-spec-counts.sh — unchanged count surfaces; check-bc-cumulative-counts.sh — no count delta |

---

## [1.3.25] - 2026-07-07

### Type: MINOR

### Summary

F2 spec delta for ADF-CODE-MARK-EXCLUSIVITY (issue #571). Adds BC-7.2.015 (new
positive mark-coexistence invariant: a `code`-marked text node emitted by
`markdown_to_adf` may only additionally carry `link` and/or `annotation` marks;
all typographic marks stripped at emit time in `src/adf.rs::push_code`). Modifies
BC-7.2.007 EC-2 to replace the "not guarded here, tracked as a follow-up" clause
with a description of the now-enforced behavior and a pointer to BC-7.2.015. Adds
holdout scenario H-NEW-ADF-010 (MUST-PASS black-box wiremock POST-body assertion
for code-mark exclusivity; five sub-calls covering strong-stripped, subsup-stripped,
link-preserved, mixed-range, and JSM-path parity via POST /rest/servicedeskapi/request
(Call E)). BC count 611 → 612; individually-bodied
count 381 → 382; range-collapsed unchanged at 230.

### Changed Requirements

- `.factory/specs/prd/bc-7-output-render.md` (MODIFIED): `total_bcs` 92 → 93,
  `definitional_count` 48 → 49, `last_updated` 2026-07-07; new BC-7.2.015 body
  inserted after BC-7.2.014; BC-7.2.007 EC-2 updated with [UPDATED 2026-07-07
  issue #571] tag replacing the "not guarded here" clause.

- `.factory/specs/prd/BC-INDEX.md` (MODIFIED): `total_bcs` 611 → 612; bc-7
  section header 92 → 93 cumulative / 48 → 49 individually-bodied; `sections:`
  entry updated; new BC-7.2.015 row added; range-collapsed row shifted
  BC-7.2.015..057 → BC-7.2.016..059; grand-total prose and summary table updated.

- `.factory/specs/prd/CANONICAL-COUNTS.md` (MODIFIED): definitional count table
  bc-7 48 → 49, Total 381 → 382; total_bcs table bc-7 92 → 93, Sum 611 → 612;
  grand total prose 611 → 612 + BC-7.2.015 citation; Note 611 → 612; Breakdown
  612/382 updated; L2 alignment table bc-07 92 → 93 + note updated.

- `.factory/specs/domain-spec/bc-07-output-render.md` (MODIFIED): `bc_count`
  92 → 93.

- `.factory/specs/prd/holdout-scenarios.md` (MODIFIED): `total_holdouts` 82 → 83;
  version 1.5.0 → 1.5.1; `last_updated` 2026-07-07; new H-NEW-ADF-010 scenario
  added to Group 12; Group 12 header updated; format note and history trace updated.

- `.factory/spec-changelog.md` (MODIFIED): this entry (v1.3.24 → v1.3.25).

- `.factory/phase-f2-spec-evolution/prd-delta-571.md` (NEW): authoritative F2
  PRD-delta record for ADF-CODE-MARK-EXCLUSIVITY cycle.

- `.factory/phase-f2-spec-evolution/verification-delta-571.md` (NEW): VP-571-001..005 verification properties for BC-7.2.015; consumed by F3 story.

### Impact Assessment

| Artifact | Change Type | Notes |
|----------|-------------|-------|
| `bc-7-output-render.md` | MODIFIED | +1 BC (BC-7.2.015 new); BC-7.2.007 EC-2 updated |
| `BC-INDEX.md` | MODIFIED | 611 → 612 total_bcs; new BC-7.2.015 row; range shifted |
| `CANONICAL-COUNTS.md` | MODIFIED | All guarded count surfaces (8 per check-bc-cumulative-counts.sh) plus unguarded body/prose surfaces updated atomically (19 surface rows; see prd-delta-571.md Count Propagation table) |
| `bc-07-output-render.md` (domain-spec) | MODIFIED | bc_count 92 → 93 (L2/L3 alignment) |
| `holdout-scenarios.md` | MODIFIED | 82 → 83 holdouts; new H-NEW-ADF-010 MUST-PASS |
| `spec-changelog.md` | MODIFIED | This entry |
| `prd-delta-571.md` | NEW | Authoritative F2 PRD-delta record |
| `verification-delta-571.md` | NEW | VP-571-001..005 verification properties for BC-7.2.015 |

### Files NOT Changed

- BC files other than `bc-7-output-render.md` — no contract changes
- `nfr-catalog.md`, `error-taxonomy.md`, `edge-case-catalog.md` — unchanged
- All `src/` production files — no behavioral change (F4 owns implementation)
- All `tests/` files — no Rust test changes (F4 owns test authoring)

---

## [1.3.24] - 2026-06-18

### Type: PATCH

### Summary

F2 spec delta for the S-FORK-OPS-BACKFILL bundle (3 MED fork-ops infrastructure
drift items). Infrastructure-only and documentation-hygiene change: no new BCs,
no BC modifications, no new NFRs, no Edge Case Catalog additions. Two stories:
S-FORK-OPS-BACKFILL-1 (backfill-release.yml WIN-TARGET + DESTRUCTIVE fixes) and
S-FORK-OPS-GITLEAKS-DOC-1 (doc-only GITLEAKS_DISABLED variable documentation).
WIN-TARGET closes the implementation gap against the existing NFR-P-W1 (Windows
binary availability) — no new NFR needed. DESTRUCTIVE replaces a delete+create
release pattern with a check-then-upsert that preserves curated release notes.
GITLEAKS-DOC adds the `GITLEAKS_DISABLED` repository variable to
`fork-friendly-release-ops.md` and `CLAUDE.md`. All spec artifacts (BC files,
NFR catalog, holdout scenarios, CANONICAL-COUNTS, BC-INDEX) are unchanged.
Implementation contract lives in the engineer/architect's spec delta, not in
product BCs (same precedent as S-FORK-OPS-SIGN-1).

### Changed Requirements

- `.factory/phase-f2-spec-evolution/prd-delta-fork-ops-backfill-1.md` (NEW):
  authoritative F2 PRD-delta record for the bundle, explicitly documenting no
  BC/NFR/EC additions, mapping drift items to stories, and recording the PATCH
  version bump recommendation.

- `.factory/spec-changelog.md` (MODIFIED): this entry (v1.3.23 → v1.3.24).

### Impact Assessment

| Artifact | Change Type | Notes |
|----------|-------------|-------|
| `.factory/phase-f2-spec-evolution/prd-delta-fork-ops-backfill-1.md` | NEW | Authoritative F2 PRD-delta record: no BC/NFR/EC additions; drift-item-to-story mapping |
| `.factory/phase-f2-spec-evolution/spec-delta-fork-ops-backfill.md` | NEW | Engineering-spec delta: `fork-friendly-release-ops.md` changes (WIN-TARGET parity note + GITLEAKS_DISABLED variable table + check-then-upsert behavioral intent) |
| `.factory/phase-f2-spec-evolution/architecture-delta-fork-ops-backfill.md` | NEW | Architecture delta: confirms no module/subsystem/dependency-graph changes; regression-baseline table |
| `.factory/phase-f2-spec-evolution/verification-delta-fork-ops-backfill.md` | NEW | Verification delta: no new VPs; F5 adversarial scan scope + CWE-77 compliance checks |
| `.factory/spec-changelog.md` | MODIFIED | This entry |

### Files NOT Changed

- All BC files (`bc-1` through `bc-7`, `cross-cutting`) — no contract changes; `total_bcs` remains 599
- `BC-INDEX.md` — no new rows; `total_bcs` 599 unchanged
- `CANONICAL-COUNTS.md` — no count changes
- `nfr-catalog.md` — NFR-P-W1 already present; no new NFR rows
- `error-taxonomy.md`, `edge-case-catalog.md`, `holdout-scenarios.md` — unchanged
- All `.factory/architecture/` files — no src/ changes
- All `src/` production files — no behavioral change
- All `tests/` files — no Rust test changes

---

## [1.3.23] - 2026-06-18

### Type: MINOR

### Summary

F2 spec delta for test-tooling hardening cycle (MAINT-MUTANTS-GLOBS-01 / #526-F6-KEYRING-GATE).
Two spec-only changes: (1) `cargo-mutants-policy.md` Scope section extended with `issues.rs` and
`cache.rs`, plus explicit sibling dispositions for three evaluated candidates; (2)
`multi-profile-auth.md` Keyring CI compatibility section extended with the read-path gating rule
and the updated gated-test roster. No behavioral contracts changed. No new BC headings.

### Changed Requirements

- `docs/specs/cargo-mutants-policy.md` (MAINT-MUTANTS-GLOBS-01): Added `src/api/jira/issues.rs`
  and `src/cache.rs` to the Scope section with per-file rationale. Added "Sibling Candidates
  Considered and Deferred" table documenting EXCLUDE/DEFER dispositions for `pagination.rs`,
  `jql.rs`, and `users.rs`. Corrected "three scoped files" → "scoped files" in CI Integration.

- `docs/specs/multi-profile-auth.md` § "Keyring CI compatibility" (#526-F6-KEYRING-GATE):
  Extended section with explicit rule that the gate applies to ANY test reaching a live keychain
  path (including read-only `auth status` with `api_token` profile). Added current gated-test
  roster including `auth_profiles.rs::global_profile_flag_targets_auth_status` as a new entry.

### Impact Assessment

| Artifact | Change Type | Notes |
|----------|-------------|-------|
| `docs/specs/cargo-mutants-policy.md` | MODIFIED | Scope section + sibling table + CI wording fix |
| `docs/specs/multi-profile-auth.md` | MODIFIED | Keyring gating rule + gated-test roster |
| `.factory/spec-changelog.md` | MODIFIED | This entry |

### Files NOT Changed

- `.cargo/mutants.toml` — F4 implementation, not F2 spec
- `tests/auth_profiles.rs` — F4 implementation, not F2 spec
- All `src/` production files — no behavioral change
- All BC files — no contract change; `total_bcs` unchanged

---

## [1.3.22] - 2026-06-17

### Type: MINOR

### Summary

BC-7.2.011 v1.11.0: F5-R2 fix of EC-11 chokepoint contract — bare `\n` in Other-context via multi-line inline HTML was a **reachable HIGH-severity INV-1 violation** (CR-01; `test_markdown_multiline_inline_html_holds_inv1` was RED before the fix). Extends `push_text` (Other context) and `push_code` to normalize bare `\n` → space, making the chokepoint self-sufficient per INV-1. Adds EC-11 behavior table (7 rows), COMP-1 Unicode separator scope exclusion note, and five new tests. No new BC heading — `total_bcs` and `definitional_count` unchanged.

### Changed Requirements

- BC-7.2.011 v1.11.0 (MINOR — EC-11 chokepoint precision fix, reachable HIGH severity, new behavior table, new test names):

  **Bug fixed (HIGH severity, CR-01):** EC-11 (INV-push-text-cr) previously specified the Other-context branch as "`\r\n`→space, lone `\r`→space" but was SILENT on a bare `\n` (U+000A not preceded by `\r`). The code only normalized when `\r` was present, so a bare `\n` could survive into a non-codeBlock text node, violating INV-1 ("no raw `\n`/`\r` in any non-codeBlock text node"). The violation was reachable end-to-end: multi-line inline HTML (`Event::InlineHtml`) in a non-block context delivers a bare `\n` to `push_text` in Other context. `test_markdown_multiline_inline_html_holds_inv1` was RED (failing) before the fix — this is a confirmed reachable HIGH bug, not a latent/defense-in-depth gap.

  **Fix — EC-11 item 3 (Other contexts):** Added "`AND bare \n (U+000A not preceded by \r) → space`" to the normalization rule for all non-codeBlock, non-HtmlBlock contexts. The fix also makes the chokepoint self-sufficient so INV-1 is enforced regardless of future parser-path changes.

  **Fix — `push_code`:** Added "bare `\n`→space" alongside the existing lone-`\r`→space rule (defense-in-depth for inline code spans, which CommonMark §6.3 gates to single-line input).

  **CodeBlock context unchanged:** bare `\n` is PRESERVED in codeBlock (those nodes may contain `\n` per INV-1's allowance for codeBlock).

  **New EC-11 behavior table (7 rows):** canonical rows for Other-context bare `\n`→space, CodeBlock bare `\n` preserved, and for completeness the CRLF/lone-CR rows in both contexts — all directly testable.

  **COMP-1 scope exclusion:** added concise non-normative note: Unicode line/paragraph separators U+2028 LS, U+2029 PS, U+0085 NEL, U+000B VT, U+000C FF are OUT OF SCOPE — passed through verbatim by design. INV-1 covers only ASCII `\r` (U+000D) / `\n` (U+000A); Jira accepts the Unicode separators as ordinary characters. Mirrors narrow-scope pattern from issue #473.

  **New test names (5) added to Source, Trace, and AC:**
  - `test_push_text_normalizes_bare_lf_in_other_context_to_space` — direct `push_text`: Other context `"a\nb"` → `"a b"`
  - `test_push_text_codeblock_preserves_bare_lf` — direct `push_text`: CodeBlock context `"a\nb"` → `"a\nb"`
  - `test_push_code_normalizes_bare_lf_to_space` — direct `push_code`: `"a\nb"` → `"a b"` (defense-in-depth)
  - `test_markdown_multiline_inline_html_holds_inv1` — end-to-end `markdown_to_adf` multi-line inline HTML; was RED before fix (proves CR-01 was reachable HIGH severity)
  - `prop_markdown_to_adf_html_chars_holds_inv1` — proptest: interleaving `<>/"=` with `\r`/`\n` holds INV-1

### Impact Assessment

| Artifact | Change Type | Notes |
|----------|-------------|-------|
| `.factory/specs/prd/bc-7-output-render.md` | MODIFIED | EC-11 item 3 extended with bare `\n`→space (HIGH bug fix); `push_code` line extended; INV-1 rationale updated; EC-11 behavior table added (7 rows); COMP-1 scope exclusion note added; AC section extended with 5 new test names (corrected from wrong names); BC-7.2.011 headline updated; Source and Trace updated; v1.11.0 row added to inline Spec Changelog |
| `.factory/specs/prd/BC-INDEX.md` | MODIFIED | BC-7.2.011 row updated to describe bare-`\n` normalization (F5-R2), COMP-1 scope exclusion, and updated Source column |
| `.factory/spec-changelog.md` | MODIFIED | This entry |

### Files NOT Changed

- `total_bcs` (90 in bc-7 file; 598 global), `definitional_count` (44) — no new BC heading; EC-11 is an existing edge case within BC-7.2.011; EC row count within EC-11 extended, not a new numbered EC
- `CANONICAL-COUNTS.md` — no count change
- All story body files — story-writer handles AC propagation under `bc_array_changes_propagate_to_body_and_acs` policy
- `src/adf.rs` — implementation already committed (commit 182a93d, 244 tests green); this entry corrects test-name citations and severity framing in the spec

---

## [1.3.21] - 2026-06-17

### Type: MINOR

### Summary

BC-7.2.011 v1.10.0: Added EC-12 (INV-1-plain-text) — `text_to_adf` CR/newline normalization. This closes the third INV-1 chokepoint in `src/adf.rs` (plain-text write path), after Algorithm B / HtmlBlock end arm (EC-1..EC-10) and EC-11 (`push_text`/`push_code` markdown parser path). No new BC heading — `total_bcs` and `definitional_count` unchanged.

### Changed Requirements

- BC-7.2.011 v1.10.0 (MINOR — new EC/AC added): Added EC-12 (`text_to_adf` CR/newline normalization, INV-1-plain-text, issue #522 extension).

  **Defect covered:** `text_to_adf(text)` builds an ADF `doc` from a raw `&str` using a one-liner `json!` macro, placing `text` verbatim into a `text` ADF node with no normalization. Any `\r`, `\n`, or `\r\n` in the argument is placed directly into the JSON, violating INV-1 ("no raw `\n`/`\r` in any non-codeBlock text node"). Jira rejects such payloads with HTTP 400. Five call sites are affected: `handle_create` (issue create `--description`), `handle_edit` (issue edit `--description`), `handle_comment` (issue comment arg), `handle_add` (worklog `--message`), and JSM request build (`--description`).

  **EC-12 contract:** `text_to_adf(text)` MUST NOT emit any ADF text node containing raw `\r` (U+000D) or `\n` (U+000A). Normalization algorithm (mirrors Algorithm B steps 2–5): (1) strip trailing `\r`/`\n`; (2) normalize `\r\n`→`\n`, lone `\r`→`\n` (two-pass); (3) split on `\n\n` (blank line) → separate `paragraph` nodes (consecutive blank lines collapse to one boundary); (4) within each block, split on `\n` and emit alternating `text` + `hardBreak` nodes; trim leading/trailing `hardBreak` per paragraph; (5) single-line inputs (no `\r`/`\n`) produce byte-identical output to the pre-fix `text_to_adf` — strict no-regression guarantee.

  **Implementation note:** Implementation MAY share a `normalize_text_to_inline_nodes` private helper with Algorithm B. The behavior table in EC-12 is the contract; Algorithm B's observable output must remain byte-identical.

  **New tests added to Source and Trace:**
  - `test_text_to_adf_single_line_unchanged` — regression guard
  - `test_text_to_adf_normalizes_interior_lf_to_hardbreak`
  - `test_text_to_adf_normalizes_interior_crlf_to_hardbreak`
  - `test_text_to_adf_normalizes_interior_lone_cr_to_hardbreak`
  - `test_text_to_adf_strips_trailing_newlines`
  - `test_text_to_adf_no_raw_newline_in_any_text_node`
  - Optional: `prop_text_to_adf_holds_inv1`

  **Headline update:** BC-7.2.011 section headline extended with `text_to_adf` normalization clause (`text_to_adf` normalizes CR/newlines: interior → `hardBreak` nodes; blank lines → separate `paragraph` nodes; single-line byte-identical).

### Impact Assessment

| Artifact | Change Type | Notes |
|----------|-------------|-------|
| `.factory/specs/prd/bc-7-output-render.md` | MODIFIED | EC-12 added after EC-11; BC-7.2.011 headline extended; Source and Trace fields updated with EC-12 test names and `src/adf.rs::text_to_adf` symbol; v1.10.0 row added to inline Spec Changelog |
| `.factory/specs/prd/BC-INDEX.md` | MODIFIED | BC-7.2.011 row summary updated to include EC-12 plain-text chokepoint clause and `src/adf.rs::text_to_adf` in Source column |
| `.factory/spec-changelog.md` | MODIFIED | This entry |

### Files NOT Changed

- `total_bcs` (90 in bc-7 file; 598 global), `definitional_count` (44) — no new BC heading; EC-12 is an edge case within BC-7.2.011
- `CANONICAL-COUNTS.md` — no count change
- All story body files — story-writer handles AC propagation under `bc_array_changes_propagate_to_body_and_acs` policy
- `src/adf.rs` — implementation handled by implementer in F4 story

---

## [1.3.20] - 2026-06-17

### Type: PATCH

### Summary

BC-7.2.011 v1.9.9: F5 Pass 3 stale-prose AC correction for `test_push_text_crlf_two_pass_ordering_deterministic` — replace the context-independent single-outcome assertion with the correct context-split outcomes (non-codeBlock → space-separated; codeBlock → `\n`-separated). No algorithm, EC count, test names, total_bcs, definitional_count, BC-INDEX, CANONICAL-COUNTS, or src/ changed.

### Changed Requirements

- BC-7.2.011 v1.9.9 (within-v1.9.8 F5 Pass 3 stale-prose correction): The v1.9.8 EC-11 AC line for `test_push_text_crlf_two_pass_ordering_deterministic` was incorrect. The prior text asserted `"a\r\nb"` → `"a\nb"` as the single context-independent outcome and treated `"a  b"` (two spaces) as something to EXCLUDE — contradicting the actual test assertions (which assert context-split behaviour).
  Corrected AC outcomes:
  - **Non-codeBlock**: `"a\r\nb"` → `"a b"` (single space); `"a\r\rb"` → `"a  b"` (two spaces); `"\r\n\r"` → `"  "` (two spaces).
  - **codeBlock**: `"a\r\nb"` → `"a\nb"`.
  The Source field entry for the same test was also corrected to show both context outcomes (non-codeBlock and codeBlock) rather than codeBlock-only. No algorithm, EC numbering, acceptance-criteria logic, test names, `total_bcs`, `definitional_count`, BC-INDEX, CANONICAL-COUNTS, or `src/` changed. Spec version trail: v1.9.7 superseded by v1.9.8 → v1.9.9.

### Impact Assessment

| Artifact | Change Type | Notes |
|----------|-------------|-------|
| `.factory/specs/prd/bc-7-output-render.md` | MODIFIED | EC-11 AC line for `test_push_text_crlf_two_pass_ordering_deterministic` corrected to context-split outcomes; Source field for same test corrected; v1.9.9 row added to inline Spec Changelog |
| `.factory/spec-changelog.md` | MODIFIED | This entry |

### Files NOT Changed

- `total_bcs`, `definitional_count` frontmatter in `bc-7-output-render.md` — no new BC heading
- `CANONICAL-COUNTS.md` — no count change
- `BC-INDEX.md` — no row content change (v1.9.8 row summary remains accurate)
- All story body files — AC-prose correction only; no story acceptance-criteria change
- `src/adf.rs` — implementation is correct; only spec prose was stale

---

## [1.3.19] - 2026-06-17

### Type: PATCH

### Summary

BC-7.2.011 v1.9.8: F5 context-aware CR normalization revision — rewrite EC-11 (INV-push-text-cr) to describe the IMPLEMENTED context-aware contract (issue #522, commit 7968d66). Supersedes v1.9.7 uniform-normalization spec, which described `\r`→`\n` uniformly and would have violated INV-1 for non-codeBlock contexts.

### Changed Requirements

- BC-7.2.011 v1.9.8: EC-11 (INV-push-text-cr) completely rewritten. The v1.9.7 spec described a uniform `\r\n`→`\n` / lone-`\r`→`\n` rule — but a uniform `\r`→`\n` in non-codeBlock contexts (heading, paragraph, etc.) would CREATE a raw `\n` in those text nodes, violating INV-1 (Jira HTTP 400 hazard). The actual implemented contract (commit 7968d66) is CONTEXT-AWARE, three-way dispatch:
  - **CodeBlock context**: `\r\n`→`\n`, lone `\r`→`\n` (codeBlock text nodes may contain `\n`).
  - **HtmlBlock context**: CR left UNCHANGED — Algorithm B (EC-9) owns CR normalization in its End arm.
  - **All other contexts** (heading, paragraph, listItem, taskItem, tableCell, blockquote, panel, inline marks, footnote definitions, inline HTML): `\r\n` and lone `\r` → SPACE (mirrors SoftBreak; preserves INV-1).
  - **`push_code`** (always inline, never codeBlock): lone `\r` → space (defense-in-depth).
  Corrected minimal-repro outcomes: `"# x\ry"` → heading `"x y"` (SPACE); `"\ta\r"` → codeBlock `"a\n"`; `` `a\rb` `` → inline code `"a b"` (public-path output; push_code guard is direct-call only).
  Updated test names (F5-revised): `test_push_text_normalizes_lone_cr_in_heading_and_code_block` (heading→space, codeBlock→`\n`); `test_push_text_normalizes_lone_cr_in_fenced_code_block` (renamed from `test_push_text_normalizes_crlf_in_paragraph`); `test_push_text_crlf_two_pass_ordering_deterministic` (NEW); `test_push_code_normalizes_lone_cr_in_inline_code` (direct-call defense-in-depth). `assert_no_raw_newline_in_text_nodes` `strict_cr` parameter REMOVED (check unconditional); `prop_492_arbitrary_string_holds_core_invariants` calls it without that arg.
  BC-7.2.011 section headline, Critical-invariant paragraph, Source, and Trace fields updated. BC-INDEX row summary updated. No new BC heading — `total_bcs`, `definitional_count`, CANONICAL-COUNTS unchanged.

### Impact Assessment

| Artifact | Change Type | Notes |
|----------|-------------|-------|
| `.factory/specs/prd/bc-7-output-render.md` | MODIFIED | EC-11 rewritten; headline, critical-invariant paragraph, Source, Trace updated; v1.9.7 superseded-by note + v1.9.8 row added to inline Spec Changelog |
| `.factory/specs/prd/BC-INDEX.md` | MODIFIED | BC-7.2.011 row summary updated to describe context-aware dispatch |
| `.factory/spec-changelog.md` | MODIFIED | This entry |

### Files NOT Changed

- `total_bcs`, `definitional_count` frontmatter in `bc-7-output-render.md` — no new BC heading
- `CANONICAL-COUNTS.md` — no count change
- All story body files — story-writer handles body/AC propagation
- `src/adf.rs` — implementation changes handled in F4/F5

---

## [1.3.18] - 2026-06-16

### Type: PATCH

### Summary

BC-7.2.011 v1.9.7: extend no-raw-`\r` invariant to all block types via `push_text`/`push_code` CR normalization chokepoints (issue #522, EC-11 / INV-push-text-cr).

### Changed Requirements

- BC-7.2.011 v1.9.7: added EC-11 (INV-push-text-cr) documenting that `AdfBuilder::push_text` and `AdfBuilder::push_code` normalize `\r\n`→`\n` and lone `\r`→`\n` before building any text node, extending INV-1's no-raw-CR guarantee from block-HTML-only (Algorithm B, EC-9) to ALL block types on the generic parser path (heading, paragraph, codeBlock, listItem, taskItem, tableCell, blockquote, panel, inline marks, footnote definitions, inline HTML). Updated the "file-wide newline-free-text-node rule" critical invariant paragraph to reference INV-push-text-cr. Updated the BC section headline and BC-INDEX row summary to mention the issue #522 extension. Added three new tests to Source and Trace fields: `test_push_text_normalizes_lone_cr_in_heading_and_code_block`, `test_push_text_normalizes_crlf_in_paragraph`, `test_push_code_normalizes_lone_cr_in_inline_code`. Noted that the pre-existing `#[ignore]`d regression test is renamed and de-ignored, and `prop_492_arbitrary_string_holds_core_invariants` flips `strict_cr` from `false` to `true`. No new BC heading added — no change to `total_bcs`, `definitional_count`, BC-INDEX counts, or CANONICAL-COUNTS.

### Impact Assessment

| Artifact | Change Type | Notes |
|----------|-------------|-------|
| `.factory/specs/prd/bc-7-output-render.md` | MODIFIED | Added EC-11 (INV-push-text-cr); extended critical invariant paragraph; extended Source + Trace with 3 new tests; updated BC-7.2.011 section headline |
| `.factory/specs/prd/BC-INDEX.md` | MODIFIED | Updated BC-7.2.011 row summary to mention issue #522 extension; added push_text / push_code to module column |
| `.factory/spec-changelog.md` | MODIFIED | This entry |

### Files NOT Changed

- `total_bcs`, `definitional_count` frontmatter in `bc-7-output-render.md` — no new BC heading
- `CANONICAL-COUNTS.md` — no count change
- All story body files — story-writer handles body/AC propagation in F3
- `src/adf.rs` — implementation changes handled in F4

---

## [1.3.17] - 2026-06-16

### Type: PATCH

### Summary

BC-7.2.011 v1.9.6: add defense-in-depth note to EC-6 for parity with EC-8/EC-9/EC-10 (F-P10-002).

### Changed Requirements

- BC-7.2.011 v1.9.6: added "Defense-in-depth note" to EC-6 (consecutive blank lines → double hardBreak) stating that CommonMark §4.6 terminates a type-6 HTML block at a blank line so this input cannot arrive via `markdown_to_adf`; `test_block_html_consecutive_blank_lines_produce_double_hardbreak` is a handler-level unit test (direct `AdfBuilder` construction). EC-6 was the only handler-level EC in the body lacking the annotation present on EC-8/EC-9/EC-10. No algorithm, AC, EC count, total_bcs, definitional_count, BC-INDEX, CANONICAL-COUNTS, or src/ changed.

---

## [1.3.16] - 2026-06-16

### Type: PATCH

### Summary

BC-7.2.011 v1.9.5: fix self-contradicting forward/reverse loss grouping (F-P8-001) + drop stale BC-INDEX line citation (F-P8-002).

### Changed Requirements

- BC-7.2.011 v1.9.5: corrected Behavior paragraph and Reverse-path paragraph grouping — condition 5 (EC-4, bare-URL autolink) is a FORWARD/POST-PASS loss, not a reverse-path loss; the only reverse-path loss is case 4 (EC-10). Dropped stale `(~L2188-2189)` line-number suffix from BC-INDEX.md `src/adf.rs::AdfRenderer::finish` citation, leaving symbol-form only. No algorithm, EC content, per-condition annotations, total_bcs, definitional_count, or CANONICAL-COUNTS changed.

---

## [1.3.15] - 2026-06-16

### Type: PATCH

### Summary

BC-7.2.011 v1.9.4: traceability — add 2 omitted block-HTML test names to Source/Trace + EC-4 body (F-P3-001).

### Changed Requirements

- BC-7.2.011 v1.9.4: added `test_block_html_round_trips_through_adf_to_text` (EC-5, single-line round-trip) and `test_block_html_interior_line_url_split_preserves_hardbreaks` (EC-4, interior-line URL split preserving flanking hardBreaks) to Source and Trace fields; added `test_block_html_interior_line_url_split_preserves_hardbreaks` to EC-4 body prose. Traceability-text-only change; no algorithm, BC count, AC, EC count, or CANONICAL-COUNTS modified.

### Impact Assessment

- **Affected stories:** None
- **Migration needed:** NO

---

## [1.3.14] - 2026-06-16

### Type: PATCH

### Summary

BC-7.2.011 v1.9.3: citation hygiene — replaced stale line-number anchors with symbol-form (F-P2-002, #408 convention).

### Changed Requirements

- BC-7.2.011 v1.9.3: replaced `~L1975-1976` and `~L2188-2189` approximate line-number citations in Behavior paragraph, Reverse-path paragraph, EC-10, and Trace field with symbol-form citations (`src/adf.rs::AdfRenderer::render_node` `"hardBreak"` arm and `src/adf.rs::AdfRenderer::finish`). Citation-text-only change; no algorithm, BC count, AC, or count surface modified.

### Impact Assessment

- **Affected stories:** None
- **Migration needed:** NO

---

## [1.3.13] - 2026-06-13

### Type: PATCH

### Summary

S-WIN-6 AC-005 Red-Gate reconciliation: product-repo ADR registry re-scoped from
`.factory/architecture/adr-index.md` (factory-internal artifact, unreachable in product CI)
to CLAUDE.md `## Key Decisions` section (product-repo ADR registry).

The DECISION — "document ADR-0016 in the product-repo ADR registry" — is unchanged.
Only WHICH registry was corrected: the `.factory/architecture/adr-index.md` row was already
present from F2/F3 (factory bookkeeping on the factory-artifacts orphan branch). Product CI
cannot read `.factory/` at all; a test reading it would always fail on CI. The correct
product-repo ADR registry is CLAUDE.md `## Key Decisions`, which was missing an ADR-0016
entry. The pinning test was correspondingly corrected:
`test_claude_md_key_decisions_includes_adr_0016` now greps CLAUDE.md (CI-safe) rather than
`.factory/architecture/adr-index.md` (factory artifact, CI-unreachable).

No BC body, NFR body, ADR count, or story count changed. Counts remain: BC 597 / NFR 42 /
ADR 16 / Stories 74.

### Modified Requirements

No BC or NFR bodies modified. Changes are governance/traceability artifacts only:
- `spec-changelog.md`: this entry (v1.3.12→v1.3.13)
- `STORY-INDEX.md`: S-WIN-6 row title reconciled ("adr-index" → "CLAUDE.md §Key Decisions (ADR-0016 entry)")
- `S-WIN-6-windows-docs-fallout.md`: `last_updated` already 2026-06-13; AC-005 body and `files_modified` already reconciled by story-writer prior to this governance pass
- `.factory/cycles/cycle-001/windows-build/spec-change-record-S-WIN-6-AC005.md`: created (this entry)

### Impact Assessment

| Dimension | Before | After | Delta |
|-----------|--------|-------|-------|
| BC corpus (BC-INDEX.md total_bcs) | 597 | 597 | 0 |
| NFR corpus | 42 | 42 | 0 |
| ADR count | 16 | 16 | 0 |
| Stories total | 74 | 74 | 0 |
| S-WIN-6 AC-005 deliverable | `.factory/architecture/adr-index.md` (factory artifact, CI-unreachable) | `CLAUDE.md §Key Decisions` (product-repo ADR registry, CI-safe) | Doc-target correction only |
| Pinning test | (would read `.factory/` — CI failure) | `test_claude_md_key_decisions_includes_adr_0016` greps `CLAUDE.md` | CI-reachability fix |

### Re-Gate Assessment

**No behavioral re-gate required.** This is a doc-target reconciliation within an already
approved and 3-clean-converged story (S-WIN-6, F3 gate APPROVED DEC-080/DEC-082/DEC-084).
The DECISION (document the ADR registry) is unchanged. Only WHICH registry was the correct
product-repo deliverable was corrected. No behavioral contract changed; no BC/NFR/ADR/story
count changed. Standard per-story convergence applies (S-WIN-6 already 3-clean; F4
dispatch unblocked).

### Change Record

`.factory/cycles/cycle-001/windows-build/spec-change-record-S-WIN-6-AC005.md`

---

## [1.3.12] - 2026-06-13

### Type: PATCH

### Summary

S-WIN-3 F4 implementation-confirmed deny.toml scope reconciliation (DEC-082 follow-on).
No BC or NFR bodies were modified (BC 597 / NFR 42 / ADR 16 / Stories 74 unchanged).
Three implementation findings propagated to spec artifacts after `cargo deny check EXIT 0`
confirmed the full transitive scope in the S-WIN-3 worktree:

- **F-WIN3-IMPL-102 (transitive-deny-scope):** The DEC-082 correction had documented a single
  `[[bans.skip]]` entry (windows-sys 0.60). Implementation revealed the full required scope is
  exactly 17 entries: 1 (windows-sys 0.60) + 0.42 tier (windows-targets 0.42 + 7 arch crates)
  + 0.53 tier (windows-targets 0.53 + 7 arch crates) = 1 + 2×(1+7) = 17. Propagated to:
  S-WIN-3 (files_modified comment, AC-002, EC-001), STORY-INDEX.md (S-WIN-3 rows),
  architecture-delta §5.3, ADR-0016 Decision 5b scope correction, research C-V2(b) scope
  annotation.
- **F-WIN3-RA-101 (count correction 8→7 arch crates):** The 0.42 generation lacks
  `windows_i686_gnullvm` (stub did not exist). Only 7 arch crates are skipped per tier
  (not 8); a skip for `windows_i686_gnullvm` would be unmatched and produce a cargo-deny
  error. Propagated alongside F-WIN3-IMPL-102 to same artifacts.
- **F-WIN3-AR1 (windows-sys topology):** Architecture-delta §5.3 and STORY-INDEX now
  document the three-tier lineage explicitly: 0.42.x (jni → windows-sys 0.45 →
  rustls-platform-verifier), 0.52.6 (ring; un-skipped canonical), 0.53.x (keyring
  windows-native → windows-sys 0.60). Plus process-gap PG-WIN3-001 codified in
  architecture-delta §10, and WIN-DENY-FRAGILITY risk (LOW) tracked in §10.

ADR-0016 date remains 2026-06-13 (already set by DEC-082 amendment — no further date bump
needed; the decision content is unchanged, only the scope documentation is corrected).
This is an implementation-driven doc-accuracy reconciliation within the already-approved
S-WIN-3 story, not a behavioral-decision change. 3-clean adversarial re-convergence
(DEC-082/083 passes A/B/C) was already complete before F4 began; no new adversarial
re-convergence or re-gate is required for this follow-on documentation correction.

### Modified Requirements

No BC or NFR bodies modified. Corrections are to architecture-delta cycle artifact,
ADR-0016 Decision 5b scope block, S-WIN-3 story spec, STORY-INDEX.md S-WIN-3 rows,
and research file C-V2(b) annotation. spec-changelog v1.3.11→v1.3.12 (this entry).

### Impact Assessment

| Dimension | Before | After | Delta |
|-----------|--------|-------|-------|
| BC corpus (BC-INDEX.md total_bcs) | 597 | 597 | 0 |
| NFR corpus | 42 | 42 | 0 |
| ADR count | 16 | 16 | 0 (ADR-0016 amended in place) |
| Stories total | 74 | 74 | 0 |
| S-WIN-3 deny scope | "1 skip entry" | "17 skip entries (7 arch crates / 0.52.6 canonical)" | Documentation only |
| Governing decision | — | DEC-082 follow-on (F4 implementation-confirmed) | STATE.md |

### Research Source

`.factory/research/windows-build-f4-preflight-verification.md` (C-V2b scope annotation).
Implementation-confirmed via `cargo deny check EXIT 0` in S-WIN-3 worktree (branch
feat/win-3-keyring-windows-native, 2026-06-13).

### Re-Gate Assessment

**No behavioral re-gate required.** This is an implementation-driven doc-accuracy
reconciliation within an already-approved story (S-WIN-3, F3 gate RE-AFFIRMED DEC-084).
The DECISION (enable windows-native + add required deny skips) is unchanged; only the
documented scope of the skip set is corrected from "1 entry (windows-sys 0.60)" to
"17 entries (transitive tier)". The 3-clean adversarial convergence completed under
DEC-082/083 already validated the full skip requirement. Standard per-story convergence
applies; S-WIN-3 is already 3-clean and implementation-confirmed green.

### Change Record

`.factory/cycles/cycle-001/windows-build/spec-change-record-S-WIN-3-F4.md`

---

## [1.3.11] - 2026-06-13

### Type: PATCH

### Summary

DEC-082 pre-F4 external-claim verification corrections propagated to F3-converged artifacts.
No BC or NFR bodies were modified (BC 597 / NFR 42 unchanged). Two BLOCKER findings from
primary-source research (keyring 3.6.3 Cargo.toml; actions/runner-images manifest; MSYS2
package index) corrected two factually wrong claims that had survived internal-consistency
adversarial review:

- **C-V2(b) BLOCKER:** keyring `windows-native` pulls `windows-sys 0.60` — NOT covered by
  existing deny.toml skips (0.45/0.61). ADR-0016 Decision 5b deny.toml note updated from
  "may need a skip" to "REQUIRED skip". architecture-delta §5.3 strikethrough+correction
  applied. S-WIN-3 AC-002/EC-001/file-structure requirements updated to mandate the
  windows-sys 0.60 `[[bans.skip]]` entry unconditionally. R-W1 risk record corrected.
- **C-V3 BLOCKER:** Unix `zip` command is NOT available on `windows-latest` GitHub runners.
  ADR-0016 Decision 2 F-WIN-F3-003 amendment (Git Bash zip primary) superseded by C-V3
  re-amendment (PowerShell `Compress-Archive` / `shell: pwsh` primary; sha256sum in
  separate `shell: bash` step). architecture-delta §3.3 updated. S-WIN-4 AC-002 and
  packaging steps updated; EC-002 reframed.
- **C-V5 note (confirmed, no correction):** TLS note (aws-lc-rs backend, not ring) added
  to ADR-0016 Decision 1 as a C-V5 inoculation paragraph.
- S-WIN-6 stale adr-index quote genericized (AC-005 wording no longer references a specific
  amendment-annotation text that would silently become stale on the next ADR amendment).

### Modified Requirements

No BC or NFR bodies modified. Corrections are to architecture decision records
(ADR-0016), architecture-delta cycle artifact, and story files (S-WIN-3, S-WIN-4, S-WIN-6).
STORY-INDEX last_updated and version bumped by story-writer (v1.4.37→v1.4.38) reflecting the
F3-convergence + DEC-082 corrections. ADR-0016 date bumped to 2026-06-13 (effective amendment
date). architecture-delta date bumped to 2026-06-13. S-WIN-6 last_updated bumped to 2026-06-13.

### Impact Assessment

| Dimension | Before | After | Delta |
|-----------|--------|-------|-------|
| BC corpus (BC-INDEX.md total_bcs) | 597 | 597 | 0 |
| NFR corpus | 42 | 42 | 0 |
| ADR count | 16 | 16 | 0 (ADR-0016 amended in place, not new) |
| Stories total | 74 | 74 | 0 |
| Governing decision | — | DEC-082 | STATE.md decisions log |

### Research Source

`.factory/research/windows-build-f4-preflight-verification.md` (claims C-V2b, C-V3, C-V5).
Primary sources: keyring v3.6.3 Cargo.toml (docs.rs); actions/runner-images Windows2022/2025
manifests; MSYS2 package index; reqwest v0.13.0 Cargo.toml.

### Required Follow-Ups

- Phase F5 adversarial re-review (scoped to DEC-082 corrections)
- Phase F7 re-gate before S-WIN-3/4 F4 implementation
- S-WIN-3 implementer must add `[[bans.skip]]` for windows-sys 0.60 in same commit as
  keyring `windows-native` feature (AC-002 mandatory, not conditional)
- S-WIN-4 implementer must use `Compress-Archive` (shell: pwsh) for packaging,
  NOT `zip` (shell: bash) — see AC-002

---

## [1.3.10] - 2026-06-11

### Type: PATCH

### Summary

F7 post-merge spec-example sync — AC-1 example assertion strings updated multi-word→single-token to match shipped impl (DEC-074 F3 wrap fix). `contains("Section Header")` → `contains("Header")`, `contains("link text")` → `contains("link")`, `contains("code snippet")` → `contains("snippet")`, `contains("nested blockquote text")` → `contains("blockquote")`. Added one-line note that single-token assertions resist comfy-table `ContentArrangement::Dynamic` cell-wrap. AC-2's `adf_contains_text("nested blockquote text")` (raw ADF JSON check) is unchanged. No BC/NFR change (594/41).

### Modified Requirements

No BC or NFR bodies modified. Spec example strings in `e2e-coverage-spec.md` AC-1 code block only.

### Impact Assessment

| Dimension | Before | After | Delta |
|-----------|--------|-------|-------|
| BC corpus (BC-INDEX.md total_bcs) | 594 | 594 | 0 |
| NFR corpus | 41 | 41 | 0 |
| bc-7-output-render.md total_bcs | 89 | 89 | 0 |

---

## [1.3.9] - 2026-06-11

### Type: PATCH

### Summary

Issue #475 F2 research-validation guardrails added to `e2e-coverage-spec.md`. New section "Server-Side ADF Mutation Guardrail (research-validated)" encodes five confirmed facts from external research (Claim 3, `.factory/research/issue-475-adf-e2e-external-validation.md`): (1) Jira Cloud silently normalizes stored ADF (localId injection, mark reordering, paragraph coalescing, silent node drop — no canonical transform list); (2) mandatory constraint that all ACs must assert structural invariants and/or `adf_to_text` rendered output, NEVER exact-ADF-tree equality — with explicit warning against future snapshot tightening; (3) read path confirmed to return raw ADF (not HTML): `get_issue` uses `?fields={}` (no `expand=renderedFields`), `list_comments` uses `?expand=properties` (not `renderedBody`), both code-confirmed at `src/api/jira/issues.rs:~426,~654`; (4) fixture constraint: no `@mentions`/user-identity nodes (GDPR non-deterministic); (5) recency: no breaking v3/ADF change in 12 months; GraphQL token deprecation 2026-11-01 is non-blocking. No AC assertion logic changed. BC/NFR counts unchanged at 594/41.

### Modified Requirements

No BC or NFR bodies modified. Additive guardrail section in `e2e-coverage-spec.md` only.

### Impact Assessment

| Dimension | Before | After | Delta |
|-----------|--------|-------|-------|
| BC corpus (BC-INDEX.md total_bcs) | 594 | 594 | 0 |
| NFR corpus | 41 | 41 | 0 |
| bc-7-output-render.md total_bcs | 89 | 89 | 0 |

---

## [1.3.8] - 2026-06-11

### Type: PATCH

### Summary

Issue #475 F2 adversarial convergence fixes (pass 2). Resolved all 6 findings from the adversarial spec delta review: (1) CRITICAL — AC-3 assertion strategy corrected: `adf_to_text` is a markdown re-emitter, not a syntax stripper; `_emphasis_` → `*emphasis*` (single asterisk); negative assertion now checks `_emphasis_` absent (raw passthrough would leave underscores); positive assertion checks `**body**` (strong round-trip) and `*emphasis*` (em round-trip). (2) HIGH — `docs/specs/e2e-live-jira-testing.md:~123` added to AC-4 rename touch-point list. (3) MEDIUM — helper names corrected to actual `e2e_live.rs` identifiers (`poll_view`, `adf_has_node_type`, `adf_contains_text`; `adf_has_blockquote_in_list_item` marked NEW); harness invocation pattern corrected to `harness.cmd().args([...]).output()`. (4) MEDIUM — "proves unwrap-not-drop" framing softened to "sanity check." (5) LOW — SURFACE registration questions resolved as hard facts (all three CLI paths already registered; no F4 action needed). (6) LOW — test name verb decomposition made coherent. BC/NFR counts unchanged at 594/41.

### Modified Requirements

No BC or NFR bodies modified. Spec delta doc corrections only (e2e-coverage-spec.md, prd-delta.md in `.factory/phase-f2-spec-evolution/475-adf-e2e-readpath/`).

### Impact Assessment

| Dimension | Before | After | Delta |
|-----------|--------|-------|-------|
| BC corpus (BC-INDEX.md total_bcs) | 594 | 594 | 0 |
| NFR corpus | 41 | 41 | 0 |
| bc-7-output-render.md total_bcs | 89 | 89 | 0 |

---

## [1.3.7] - 2026-06-11

### Type: PATCH

### Summary

Issue #475 F2 Spec Evolution: test-only BC Trace-field annotations and test rename. Three BC Trace fields in `bc-7-output-render.md` updated to reference the new live E2E coverage introduced by issue #475 (`test_e2e_adf_read_path_human_output`). Test rename: `test_e2e_issue_markdown_description_roundtrip` → `test_e2e_markdown_description_produces_heading_node` to correct a misnomer (the test verifies only the forward markdown→ADF direction). BC count unchanged at 594. NFR count unchanged at 41.

### Modified Requirements

| ID | Change |
|----|--------|
| BC-7.2.003 | Trace field extended: added reference to `tests/e2e_live.rs::test_e2e_adf_read_path_human_output` (first live E2E exercise of ADF read path via `jr issue view` human mode — AC-1) and renamed test reference `test_e2e_markdown_description_produces_heading_node` (formerly `test_e2e_issue_markdown_description_roundtrip`). Qualitative only; no numeric test counts added. |
| BC-7.2.004 | Trace field extended: added reference to `tests/e2e_live.rs::test_e2e_adf_read_path_human_output` as the first live E2E coverage of `adf_to_text` — via `cli/issue/view.rs` human mode (AC-1) and `cli/issue/comments.rs` human mode (AC-3). Qualitative only. |
| BC-7.2.006 | Trace field extended: added reference to `tests/e2e_live.rs::test_e2e_adf_read_path_human_output` as the first live E2E exercise of `normalize_list_item_content` — blockquote-in-listItem normalization sub-case AC-2. Qualitative only. |

### Impact Assessment

| Dimension | Before | After | Delta |
|-----------|--------|-------|-------|
| BC corpus (BC-INDEX.md total_bcs) | 594 | 594 | 0 |
| NFR corpus | 41 | 41 | 0 |
| bc-7-output-render.md total_bcs | 89 | 89 | 0 |

### Discovery Basis

F2 Spec Evolution for issue #475. Human gate decisions honored: one story (`S-475-adf-e2e-readpath`), 4 ACs, rename is a RENAME (not annotate-only), AC-3 in scope. No BC/NFR count change. Architecture unchanged. Verification properties unchanged.

---

## [1.3.6] - 2026-06-10

### Type: PATCH

### Summary

BC-7.2.010 EC-8 mechanism correction: The spec incorrectly stated that input `- [ ] \` (backslash line break in a task item) produces `taskItem.content: [hardBreak]`. In pulldown-cmark 0.13.3, a trailing backslash in a task item produces `Text("\\")` (a literal backslash text node), NOT a hardBreak. Discovered during F4 implementation — as-built behavior is authoritative (DOCUMENT-AS-IS). The prune outcome is unchanged and correct: a backslash-only task item is pruned. The fix corrects the mechanism description in EC-8 and the `is_empty_block_container` prune set description to name both the backslash-text case and the hardBreak-only case as distinct sub-cases, each a DELIBERATE PRODUCT CHOICE. BC count unchanged at 594.

### Modified Requirements

| ID | Change |
|----|--------|
| BC-7.2.010 | (1) EC-8: replaced incorrect claim that `- [ ] \` produces `taskItem.content: [hardBreak]` with correct mechanism: pulldown-cmark 0.13.3 emits `Text("\\")` (literal backslash text node) for a trailing backslash; the `is_empty_block_container` structurally-empty-inline branch prunes task items whose content is text-only after trimming whitespace and backslashes. Added "Backslash-text case" sub-entry documenting the correct pulldown behavior and prune rationale. (2) `is_empty_block_container` prune set paragraph updated to include "text nodes that are empty after trimming whitespace and backslash characters" alongside whitespace-only text nodes and bare hardBreaks. (3) Prune criterion summary updated from "all three cases" to "all four cases" (empty, whitespace-only, backslash-text, hardBreak-only). Both backslash-text and hardBreak-only prunes noted as DELIBERATE PRODUCT CHOICES. |

### Impact Assessment

| Dimension | Before | After | Delta |
|-----------|--------|-------|-------|
| BC corpus (BC-INDEX.md total_bcs) | 594 | 594 | 0 |
| NFR corpus | 41 | 41 | 0 |
| bc-7-output-render.md total_bcs | 89 | 89 | 0 |

### Discovery Basis

F4 implementation of BC-7.2.010 (issue #471). The implemented `is_empty_block_container` correctly prunes backslash-only task items via the text-trimming branch. The spec mechanism description was incorrect; the as-built behavior is the authoritative source per DOCUMENT-AS-IS policy.

---

## [1.3.5] - 2026-06-10

### Type: PATCH

### Summary

BC-7.2.010 Phase F2 update: F4-conditional blockquote dependency resolved at spec time by research `issue-471-pulldown-blockquote-tasklist.md`. pulldown-cmark 0.13.3 primary-source read (`firstpass.rs:128–160`, `parse.rs:2269`) confirms `blockquote > taskList` is emitted for `> - [ ] item` — the task scan is container-agnostic, runs after the blockquote `>` prefix is stripped, and is gated only on `ENABLE_TASKLISTS`. No F4 back-propagation needed. BC count unchanged at 594.

### Modified Requirements

| ID | Change |
|----|--------|
| BC-7.2.010 | (1) Obligation #2 de-fenced: removed CONDITIONAL/F4-gated status; normalization arm is now REQUIRED and unconditional. (2) EC-6 de-fenced: removed CONDITIONAL qualifier and `[process-gap]` tag; normalization now specified definitively as `blockquote > [paragraph, ...]`. (3) EC-10(c) `(conditional on EC-6 confirmation)` qualifier removed. (4) Trace test `test_task_list_in_blockquote_normalized_to_paragraphs` annotation updated from "(F4-conditional)" to "(asserts definite output — unconditional)". (5) Builder-mechanics paragraph gains an explicit `TaskListMarker` ordering contract pinning the marker as the first child after `Start(Tag::Item)` in ALL nesting contexts (top-level, blockquote, nested), citing `firstpass.rs:128–160` and the research file. (6) Confidence headline updated: blockquote question now HIGH; MEDIUM-HIGH on top-level placement unchanged. |

### Impact Assessment

| Dimension | Before | After | Delta |
|-----------|--------|-------|-------|
| BC corpus (BC-INDEX.md total_bcs) | 594 | 594 | 0 |
| NFR corpus | 41 | 41 | 0 |
| bc-7-output-render.md total_bcs | 89 | 89 | 0 |

### Research Basis

`.factory/research/issue-471-pulldown-blockquote-tasklist.md` (2026-06-10, HIGH confidence, primary-source read of pulldown-cmark 0.13.3 `firstpass.rs` + `parse.rs` + `gfm_tasklist.rs` snapshot suite, cross-validated via Perplexity sonar-deep-research).

---

## [1.3.4] - 2026-06-10

### Type: PATCH

### Summary

Issue #471: GFM task lists (`- [ ] …` / `- [x] …`) → ADF `taskList`/`taskItem` — F2 spec evolution. One new BC authored in `bc-7-output-render.md` (BC-7.2.010). BC corpus 593→594. NFR corpus unchanged at 41. F1 gate decisions encoded: localId uses counter-based deterministic strings (no `uuid` crate), mixed list promotes whole container to `taskList`, live round-trip verification deferred (needs-sandbox).

### New Requirements

| ID | Description |
|----|-------------|
| BC-7.2.010 | `markdown_to_adf` enables `ENABLE_TASKLISTS`; `- [ ]` maps to `taskItem { state: "TODO" }` and `- [x]`/`- [X]` maps to `taskItem { state: "DONE" }` (uppercase enforced per `full.json` schema). `taskList.attrs.localId` and `taskItem.attrs.localId` are counter-based deterministic strings (`"0"`, `"1"`, …). Mixed lists (any item has a checkbox) promote the entire container to a `taskList`; plain items become `taskItem { state: "TODO" }`. `taskItem.content` is inline-only (no paragraph wrapper). `normalize_list_item_content` gains a `taskList` arm (unwrap to plain `listItem`+`paragraph`). Blockquote content normalizes `taskList` to `paragraph` nodes. Panel content passes `taskList` through unchanged. `is_empty_block_container` prune set gains `"taskList"` and `"taskItem"`. `adf_to_text` renders `taskList`/`taskItem` back to `- [ ]`/`- [x]` GFM syntax with `ListFrame::Task` indentation. Round-trip stable for all five canonical state values. |

### Modified Requirements

None. BC-7.2.003 cross-reference note added (BC-7.2.010 is the task-list coverage anchor; no body change to BC-7.2.003 itself).

### New Spec Artifacts

None (BC added inline to `bc-7-output-render.md`). Implementer should create `docs/specs/adf-task-list.md` design spec in F4 (parallel to `docs/specs/adf-panel-content-model.md` for #483).

### Impact Assessment

| Dimension | Before | After | Delta |
|-----------|--------|-------|-------|
| BC corpus (BC-INDEX.md total_bcs) | 593 | 594 | +1 |
| NFR corpus (nfr-catalog.md total_nfrs) | 41 | 41 | 0 |
| bc-7-output-render.md total_bcs | 88 | 89 | +1 |
| bc-7-output-render.md definitional_count | 42 | 43 | +1 |

### Feature Scope

Backend only — `src/adf.rs` delta. No CLI surface change, no API shape change, no config change. Regression risk MEDIUM: existing test `test_markdown_task_list_syntax_preserved_as_text` will fail when `ENABLE_TASKLISTS` is added and must be replaced in F4 with new tests asserting `taskList`/`taskItem` output shape. No new integration tests or E2E tests required. All new tests will be inline unit tests in `src/adf.rs::tests`.

---

## [1.3.3] - 2026-06-08

### Type: PATCH

### Summary

Issue #474: Markdown minor constructs → ADF (superscript/subscript `subsup` mark + heading-attribute stripping) — F2 spec evolution. Two new BCs authored in `bc-7-output-render.md` (BC-7.2.007 and BC-7.2.008). BC corpus 590→592. NFR corpus unchanged at 41. Implementation already written on branch `feat/adf-minor-constructs-474`; this is a retroactive VSDD wrap.

### New Requirements

| ID | Description |
|----|-------------|
| BC-7.2.007 | `markdown_to_adf` maps `^x^`→`subsup` sup mark and `~x~`→`subsup` sub mark. Single-tilde reassigned from strikethrough to subscript; double-tilde `~~x~~` stays `strike`. `adf_to_text` round-trip lossless: sup→`^x^`, sub→`~x~`. `dedup_marks_by_type` prevents duplicate mark types per text node (first-wins). Intraword carets (`mc^2^`) stay literal. |
| BC-7.2.008 | `markdown_to_adf` with `ENABLE_HEADING_ATTRIBUTES` consumes id/class/key-val attribute blocks from heading lines instead of leaking them into heading text. `## Title {#id}` yields heading text exactly `"Title"`. ADF headings have no id attribute; parsed attribute values are dropped. |

### Modified Requirements

None.

### New Spec Artifacts

None (BCs added inline to `bc-7-output-render.md`).

### Impact Assessment

| Dimension | Before | After | Delta |
|-----------|--------|-------|-------|
| BC corpus (BC-INDEX.md total_bcs) | 590 | 592 | +2 |
| NFR corpus (nfr-catalog.md total_nfrs) | 41 | 41 | 0 |
| bc-7-output-render.md total_bcs | 85 | 87 | +2 |
| bc-7-output-render.md definitional_count | 39 | 41 | +2 |

### Feature Scope

Backend only — `src/adf.rs` delta. No CLI surface change, no API shape change, no config change. F4 delivery validates the 10 inline unit tests in `src/adf.rs::tests` covering subsup forward path, reverse path, round-trip, tilde-collision safety, mark deduplication, and heading-attribute stripping. No new integration tests or E2E tests required.

---

## [1.3.2] - 2026-06-01

### Type: PATCH

### Summary

JSM E2E coverage expansion (project EJ) — F2 spec evolution. New per-feature design spec
added at `docs/specs/jsm-e2e-coverage.md`. Zero BC change; zero NFR change. BC corpus
remains 585; NFR corpus remains 41. This is a test-scope expansion only — zero `src/`
change; all JSM commands already exist. F4 delivery touches `tests/e2e_live.rs`,
`tests/e2e_cli_surface_guard.rs`, `docs/specs/e2e-live-jira-testing.md`, and `CLAUDE.md`.

### New Requirements

None. BC corpus (585) and NFR corpus (41) are explicitly unchanged.

### Modified Requirements

None.

### New Spec Artifacts

| File | Description |
|------|-------------|
| `docs/specs/jsm-e2e-coverage.md` | Per-feature design spec for JSM E2E coverage expansion (project EJ). Covers: problem and context (shallow JSM coverage + false-confidence history); 7 test scenarios (queue list/view shape, requesttype list/fields shape + numeric-bypass pin, comment internal/external visibility round-trip, issue create --request-type write round-trip, non-JSM guard); dynamic-discovery design (queue/RT fixtures from list output, no new env var); self-close teardown design + explicit residual-orphan caveat (sweeper does not cover EJ, labels do not propagate); sd.public.comment property round-trip detail; BC-X.8.004 non-JSM guard scenario; clean-skip policy (unset JR_E2E_JSM_PROJECT, empty list, 403); deferred sub-gaps (--on-behalf-of, scope-stripped-token 401); rollout (set JR_E2E_JSM_PROJECT=EJ in jira-e2e env; no workflow code change needed); verification properties VER-JSM-E2E-1..7 (one per scenario); F4 touch-point list. |

### Impact Assessment

| Dimension | Before | After | Delta |
|-----------|--------|-------|-------|
| BC corpus (BC-INDEX.md total_bcs) | 585 | 585 | 0 |
| NFR corpus (nfr-catalog.md total_nfrs) | 41 | 41 | 0 |
| New per-feature specs | — | `docs/specs/jsm-e2e-coverage.md` | +1 file |

### Feature Scope

Test-scope expansion. Zero `src/` change; zero BC/NFR change. F4 delivery touches:
`tests/e2e_live.rs` (7 new `#[ignore]`-gated JSM test functions), `tests/e2e_cli_surface_guard.rs`
(4 new SURFACE rows: `queue view` + `--id`, `requesttype fields`, `issue comment` + `--internal`,
`issue create` + `--request-type`), `docs/specs/e2e-live-jira-testing.md` (§4/§8 JSM
updates), `CLAUDE.md` (JSM E2E env var + teardown convention note). Rollout: set
`JR_E2E_JSM_PROJECT=EJ` as an environment variable in the `jira-e2e` GitHub Environment
(already wired in e2e.yml; no workflow code change needed).

---

## [1.3.1] - 2026-06-01

### Type: PATCH

### Summary

Fork-safe E2E CI enablement flag + README E2E status badge (F2 spec evolution). New
per-feature design spec added at `docs/specs/e2e-fork-safe-ci-enablement.md`. Zero BC
change; zero NFR change. BC corpus remains 585; NFR corpus remains 41. This is a CI
infrastructure and documentation feature only — no product behavior is altered.

### New Requirements

None. BC corpus (585) and NFR corpus (41) are explicitly unchanged.

### Modified Requirements

None.

### New Spec Artifacts

| File | Description |
|------|-------------|
| `docs/specs/e2e-fork-safe-ci-enablement.md` | Per-feature design spec for the fork-safe E2E CI enablement flag (`JR_E2E_ENABLED`) and README badge. Covers: problem and context, the two-layer model (repo-var gate vs test-binary gate), job-level gate expression, `JR_E2E_ENABLED` MUST-BE-repository-variable requirement with GitHub-docs citation, preflight step specification, badge markdown, rollout and operational notes, verification properties (VER-E2E-FORK-1..4), and F4 touch-point list. |

### Impact Assessment

| Dimension | Before | After | Delta |
|-----------|--------|-------|-------|
| BC corpus (BC-INDEX.md total_bcs) | 585 | 585 | 0 |
| NFR corpus (nfr-catalog.md total_nfrs) | 41 | 41 | 0 |
| New per-feature specs | — | `docs/specs/e2e-fork-safe-ci-enablement.md` | +1 file |

### Feature Scope

CI infrastructure only. F4 delivery touches: `.github/workflows/e2e.yml` (job `if:`
gate + preflight step), `README.md` (E2E badge), `CLAUDE.md` (JR_* table entry + two-
layer model note), `docs/specs/e2e-live-jira-testing.md` (§5 YAML, §6 secret safety,
§8 config table). Zero `src/` change; zero `tests/` change.

---

## [1.3.0] - 2026-05-20

### Type: MINOR

### Summary

Issue #388: Accurate cross-hierarchy type-change error + fix fake-endpoint hint (Option A). Adds 2 new BCs (BC-3.4.010, BC-3.4.011) defining the enriched error behaviour for `jr issue edit KEY --type X` HTTP 400 responses. Annotates BC-3.4.003 with an Errors cross-reference (no behavioral change). The `CROSS_HIERARCHY_HINT` constant (citing JRACLOUD-27893, no fake endpoint) also replaces the misleading `PUT /rest/api/3/issue/{key}/convert` hint at `src/cli/issue/create.rs:834`. Grand total: 575 → 577.

### New Requirements

| ID | Description |
|----|-------------|
| BC-3.4.010 | `jr issue edit KEY --type X` HTTP 400 + source `issuetype.subtask` differs from target type's `subtask` (cross-hierarchy mismatch) → exit 1, `CROSS_HIERARCHY_HINT` on stderr. Hint wording pinned verbatim: cites JRACLOUD-27893, directs user to Jira web UI action menu (`...`), avoids exact UI label (locale-resilient). Subtask-flag mismatch is the primary classifier; English substring `"issue type selected is invalid"` is NOT the sole gate. `CROSS_HIERARCHY_HINT` constant also replaces the fake `/rest/api/3/issue/{key}/convert` hint at `create.rs:834` (`--no-parent` subtask-bound 400 path). |
| BC-3.4.011 | `jr issue edit KEY --type X` HTTP 400 + same-hierarchy flags (`src_subtask == tgt_subtask`) → exit 1, typo hint referencing `jr project types` + raw Atlassian error body. OR indeterminate (source-issue fetch or project-types fetch fails) → exit 1, raw error body only; NO enrichment hint. `CROSS_HIERARCHY_HINT` (JRACLOUD-27893) MUST NOT appear on either sub-path (prevents false positives on typos and workflow-incompatibility 400s). |

### Modified Requirements

| ID | Nature |
|----|--------|
| BC-3.4.003 | Errors cross-reference added: when `edit --type X` returns HTTP 400, see BC-3.4.010 (cross-hierarchy → CROSS_HIERARCHY_HINT) and BC-3.4.011 (same-hierarchy/indeterminate → typo hint or raw error). Primary success path (PUT 204) and ADF description behavior are byte-for-byte unchanged. |

### Impact Assessment

| Dimension | Before | After | Delta |
|-----------|--------|-------|-------|
| bc-3-issue-write.md individually-bodied | 66 | 68 | +2 |
| bc-3-issue-write.md total_bcs | 95 | 97 | +2 |
| BC-INDEX.md total_bcs (grand total) | 575 | 577 | +2 |
| CANONICAL-COUNTS.md Sum | 575 | 577 | +2 |
| BCs modified (no count change) | — | BC-3.4.003 (annotation only) | — |

### New Holdout Scenarios

None. The ten (10) integration tests in `tests/issue_edit_type_errors.rs` provide complete regression coverage for the new BC paths. No holdout-level coverage is required for this delta (error-path enrichment only; no new user-visible flows or success paths).

### Required Test Deliverables

Required test deliverables (to be mandated by the implementing story in F3). Authoritative count: **TEN (10)** integration tests in `tests/issue_edit_type_errors.rs` (the delta-analysis.md figure of five is superseded by this F2 spec delta):

1. `test_edit_type_cross_hierarchy_std_to_subtask_surfaces_conversion_hint` — GET issue (`subtask: Some(false)`), GET project types (target `subtask: Some(true)`), PUT returns 400 → exit 1, stderr contains `JRACLOUD-27893`, stderr does NOT contain `jr api /rest/api/3/issue` (regression pin)
2. `test_edit_type_cross_hierarchy_subtask_to_std_surfaces_conversion_hint` — reverse direction (`subtask: Some(true)` → `Some(false)`), same assertions
3. `test_edit_type_same_hierarchy_400_surfaces_typo_hint` — both flags `subtask: Some(false)` → exit 1, stderr contains `` `jr project types` ``, stderr does NOT contain `JRACLOUD-27893` (negative pin), stderr does NOT contain `jr api /rest/api/3/issue` (fake-endpoint regression pin)
4. `test_edit_type_indeterminate_project_types_5xx_surfaces_raw_error` — GET issue succeeds (`subtask: Some(false)`), GET project types returns 5xx → exit 1, extracted 400 message on stderr, no hint, stderr does NOT contain `JRACLOUD-27893`, stderr does NOT contain `jr api /rest/api/3/issue`
5. `test_edit_type_cross_hierarchy_hint_no_fake_endpoint_literal` — regression pin: CrossHierarchy 400 path → stderr does NOT contain `jr api /rest/api/3/issue`
6. `test_edit_type_indeterminate_absent_subtask_flag_surfaces_raw_error` — `get_issue` returns HTTP 200 with `subtask` key OMITTED from issuetype object → `src_subtask: None` → `Indeterminate` → exit 1, extracted 400 message on stderr, no hint, `JRACLOUD-27893` absent, `jr api /rest/api/3/issue` absent (tests Indeterminate Cause-2, source-side)
7. `test_edit_type_indeterminate_absent_target_subtask_flag_surfaces_raw_error` — source `subtask: Some(false)` present; `get_project_issue_types` returns HTTP 200 with target type's `subtask` key OMITTED → `tgt_subtask: None` → `Indeterminate` → exit 1, same negative assertions (tests Indeterminate Cause-2, target-side)
8. `test_edit_type_unresolved_type_name_surfaces_typo_hint` — `get_issue` returns HTTP 200 with source `subtask: Some(false)`; `get_project_issue_types` returns HTTP 200 with a list that does NOT contain the `--type` value → unresolvable-name sub-path → typo hint, stderr contains `` `jr project types` ``, `JRACLOUD-27893` absent, `jr api /rest/api/3/issue` absent
9. `test_edit_type_indeterminate_get_issue_fails_surfaces_raw_error` — `edit_issue` returns HTTP 400; `get_issue` returns 5xx → `Indeterminate` immediately (R1 routing row; `get_project_issue_types` never called); exit nonzero, raw error on stderr, no hint, `JRACLOUD-27893` absent, `jr api /rest/api/3/issue` absent
10. `test_edit_type_non_400_edit_error_surfaces_raw_error_no_enrichment` — `edit_issue` returns HTTP 403 (non-400, R0b routing row) → enrichment block bypassed entirely; exit nonzero, raw error on stderr, no hint, `JRACLOUD-27893` absent, `jr api /rest/api/3/issue` absent; no wiremock stubs for `get_issue` or `get_project_issue_types`

Additionally: strengthen T-06 in `tests/issue_edit_no_parent.rs` (`test_subtask_parent_clear_surfaces_400_with_convert_hint`): add `assert!(stderr.contains("JRACLOUD-27893"))` literal-pin, `assert!(!stderr.contains("jr api /rest/api/3/issue"))` negative regression guard, and `assert!(stderr.contains("Sub-tasks are structurally bound to a parent; clearing it requires converting the sub-task to a standard issue."))` (pins the verbatim normative context sentence). The regression-pin substring `jr api /rest/api/3/issue` supersedes the broader form `/rest/api/3/issue/` from the F1 delta-analysis — the broader form is over-broad and false-positive-prone against legitimate diagnostic output.

### Feature Request Link

- https://github.com/Zious11/jira-cli/issues/388

---

## [1.2.0] - 2026-05-20

### Type: MINOR

### Summary

Issue #385: JSM create UX polish — harmonize project-required error (O-08-02), guard empty `--request-type` (O-08-04), reject `--markdown` + `--field description=` conflict (O-08-06), clarify warning position post-`require_service_desk` (O-08-07). Adds 2 new BCs (BC-3.8.016, BC-3.8.017) and modifies 3 BCs (BC-3.8.002, BC-3.8.010, BC-3.8.011). Grand total: 573 → 575.

### New Requirements

| ID | Description |
|----|-------------|
| BC-3.8.016 | `--request-type ""` (empty string or whitespace-only after trim) exits 64 with "request type cannot be empty" before `partial_match` or numeric bypass; no HTTP issued |
| BC-3.8.017 | `--markdown` + `--field description=<value>` combination rejected at parse-time in `handle_jsm_create`; exit 64; rationale: desync of `isAdfRequest: true` with plain-string description "may result in a JSM 400 error or silently dropped ADF formatting" (NOT asserted as certain) |

### Modified Requirements

| ID | Nature |
|----|--------|
| BC-3.8.002 | "No project resolvable AND `no_input` effective (explicit `--no-input` OR auto-enabled on non-TTY stdin) OR `prompt_input` errors" error string harmonized: `"Project key is required for JSM request creation. Use --project or configure .jr.toml. Run \"jr project list\" to see available JSM projects."` — adds `--project`/`.jr.toml`/`jr project list` affordances matching platform path, preserves "for JSM request creation" context. The code checks `no_input` only; non-TTY auto-enables it (CLAUDE.md). Previous string: `"project is required for JSM request creation"`. |
| BC-3.8.010 | Warning position clarified: `--type` warning fires INSIDE `handle_jsm_create` AFTER `require_service_desk` returns `Ok`, NOT pre-`handle_jsm_create`. Non-JSM project: ONLY the non-JSM error is emitted (no spurious warning). New companion test required: `test_jsm_create_type_flag_warning_suppressed_on_non_jsm_project`. |
| BC-3.8.011 | Same warning-position constraint applied: all six warnings (the `--type` warning of BC-3.8.010 plus the five platform-only flag warnings of BC-3.8.011: --team, --points, --parent, --to, --account-id) move to post-`require_service_desk` position in `handle_jsm_create`. |

### New Holdout Scenarios

| ID | Description |
|----|-------------|
| H-NEW-JSM-RT-006 | `--request-type ""` exits 64 with explicit empty-string message; no HTTP (pins BC-3.8.016) |
| H-NEW-JSM-RT-007 | `--markdown` + `--field description=plain` exits 64 at parse-time; no HTTP (pins BC-3.8.017) |

**O-08-02 holdout-exempt note**: BC-3.8.002 (O-08-02: project-required error string) is DELIBERATELY holdout-exempt. Unlike O-08-04 (→H-NEW-JSM-RT-006) and O-08-06 (→H-NEW-JSM-RT-007), this is a string-only error-message change with no control-flow impact. The existing unit test `test_jsm_create_missing_project_exits_64_with_jsm_specific_hint` (updated to assert the new verbatim string) provides complete regression coverage. See prd-delta-385.md §BC-3.8.002 for the canonical statement.

### Impact Assessment

| Dimension | Before | After | Delta |
|-----------|--------|-------|-------|
| bc-3-issue-write.md individually-bodied | 64 | 66 | +2 |
| bc-3-issue-write.md total_bcs | 93 | 95 | +2 |
| BC-INDEX.md total_bcs (grand total) | 573 | 575 | +2 |
| CANONICAL-COUNTS.md Sum | 573 | 575 | +2 |
| holdout-scenarios.md total_holdouts | 55 | 57 | +2 |
| BCs modified (no count change) | — | BC-3.8.002, BC-3.8.010, BC-3.8.011 | — |

### Required Test Deliverables

Required test deliverables: see `.factory/phase-f2-spec-evolution/prd-delta-385.md §Required Test Deliverables` (canonical copy — do not duplicate here).

---

## [1.1.0] - 2026-05-19

### Type: MINOR

### Summary

Issue #384: JSM 401 hint surface refinement — distinguish Basic-auth (API-token-expiry hint) vs OAuth (preserve existing hint behavior) on both the `handle_jsm_create` dispatch path and the `require_service_desk` project-GET path. Adds `JiraClient::is_oauth_auth()` predicate contract and four new behavioral contracts covering the auth-conditional error hint branches.

**Corrected design model (adversary C-01/C-02):** The gate is `is_oauth_auth()` ALONE — not error variant. A Basic-auth 401 with a "scope does not match" body arrives as `InsufficientScope` (body check at `src/api/client.rs:696` fires before Bearer guard at line 718). The Basic-auth `map_err` must REWRITE any incoming variant to `NotAuthenticated` with the API-token hint. A shared constant `API_TOKEN_EXPIRY_HINT` is required at both call sites (BC-3.8.014 and BC-X.8.006).

### New Requirements

| ID | Description |
|----|-------------|
| BC-3.8.014 | Basic-auth 401 on JSM POST (`handle_jsm_create`) → any variant rewritten to `NotAuthenticated` with API-token-expiry hint (no OAuth-scope language); gated by `client.is_oauth_auth() == false`; shared constant `API_TOKEN_EXPIRY_HINT` |
| BC-3.8.015 | OAuth 401 on JSM POST (`handle_jsm_create`) → existing behavior preserved unchanged; for OAuth (`is_oauth_auth() == true`), BOTH arms (InsufficientScope AND NotAuthenticated) produce `write:servicedesk-request` hint — the pre-#384 map_err at `src/cli/issue/create.rs:1988-1995` already rewrites NotAuthenticated to `write:servicedesk-request` for all auth; now explicitly gated on `client.is_oauth_auth() == true` |
| BC-X.8.006 | Basic-auth 401 from `require_service_desk` project GET (cache miss) → any variant rewritten to `NotAuthenticated` with API-token-expiry hint; gated by `client.is_oauth_auth() == false`; shared constant `API_TOKEN_EXPIRY_HINT`; benefits all JSM callers |
| BC-X.8.007 | OAuth 401 from `require_service_desk` project GET (cache miss) → both sub-case arms rewrite to `JrError::NotAuthenticated { hint }` (NOT InsufficientScope — that Display is purpose-built for the POST scenario) with read-side scope hint (`read:jira-work` + `read:servicedesk-request`); gated by `client.is_oauth_auth() == true`; both scopes in DEFAULT_OAUTH_SCOPES; same new map_err as BC-X.8.006 |

### Modified Requirements

| ID | Previous | Updated | Rationale |
|----|----------|---------|-----------|
| BC-3.8.001 | Errors cross-reference: no auth-conditional 401 reference | Errors cross-reference updated to point at BC-3.8.009 (auth-conditional: Basic-auth → BC-3.8.014; OAuth → BC-3.8.015) | Cross-reference refresh — no behavioral change |
| BC-3.8.009 | Errors section: monolithic "Scope error for `write:servicedesk-request`" | Auth-conditional: `is_oauth_auth() == false` → BC-3.8.014 (API-token hint; any variant rewritten); `is_oauth_auth() == true` → BC-3.8.015 (existing behavior) | Gate is `is_oauth_auth()` alone; Basic-auth users must never see OAuth scope language |
| BC-X.3.002 | Universal 401 baseline (no JSM footnote) | Added JSM auth-conditional footnote: gate is `is_oauth_auth()` alone; Basic-auth any variant → API-token hint; OAuth → existing variant behavior; base contract unchanged for non-JSM paths | Cross-reference for implementers |

### Revised Holdouts

| ID | Previous | Updated | Rationale |
|----|----------|---------|-----------|
| H-NEW-JSM-RT-003 | Auth fixture: `JR_AUTH_HEADER=Basic ...`; asserted `write:servicedesk-request`; project mock missing `"id"` field; servicedesk mock missing `"projectId"` field | Auth fixture: `JR_AUTH_HEADER=Bearer test-oauth-token` (OAuth); asserts `write:servicedesk-request` (BC-3.8.015 pin). Setup uses helper abstraction: `mount_project_meta_help` (project `HELP`, id `"99"`) + `mount_service_desk_list` (servicedesk list, `projectId "99"`) + `mount_request_types_password_reset` (single-element list: `"Password Reset"` only). BC-X.8.006/X.8.007 removed from BC list (those BCs fire on 401 from `require_service_desk` GETs — this holdout's GETs return 200). Clarifying note added. [Fixture re-bound Pass-9 to real bound test `test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint` — see `holdout-scenarios.md §H-NEW-JSM-RT-003`.] | Prior rationale was incorrect (Basic-auth + scope-mismatch body still routes to InsufficientScope, not NotAuthenticated). Mock bodies were missing required `id`/`projectId` fields that would cause exit 64 before the JSM POST (the holdout's target). |

### Test Instructions (canonical — adversary-pass-9 C-01 corrected; use THESE, not any earlier draft)

> **[adversary-pass-9 C-01 CRITICAL correction]** Prior instructions (items 1 and 4 below in the old draft) said "switch the Basic-auth 401 test to Bearer" — this was UNWORKABLE. See adversary-pass-9 §Corrections below. Corrected instructions (item 3 reflects actual F4 outcome — test repurposed in place and renamed to `test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint`):

1. `test_jsm_create_basic_auth_401_surfaces_api_token_hint` — NEW (BC-3.8.014); Basic-auth fixture, generic 401 body → assert API-token hint.
2. `test_jsm_create_basic_auth_scope_mismatch_401_rewrites_to_api_token_hint` — NEW (BC-3.8.014); Basic-auth fixture, "scope does not match" body → assert API-token hint (pins InsufficientScope→NotAuthenticated rewrite; highest regression risk).
3. `test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint` — REPURPOSED IN PLACE (BC-3.8.014 pin; renamed by F4 from the pre-#384 name): fixture STAYS `JR_AUTH_HEADER=Basic dGVzdDp0ZXN0`; assertions flipped from `write:servicedesk-request` to API-token-expiry hint; negative assertion that `write:servicedesk-request` is ABSENT. Do NOT switch to Bearer.
4. `test_require_service_desk_basic_auth_401_surfaces_api_token_hint` — NEW (BC-X.8.006); Basic-auth fixture, cache miss forced, project-GET returns generic-expiry 401 → assert API-token-expiry hint.
5. `test_require_service_desk_oauth_401_surfaces_read_scope_hint` — NEW (BC-X.8.007); Bearer fixture, cache miss forced, project-GET returns scope-mismatch 401 (`{"errorMessages": ["Unauthorized; scope does not match"]}`) → assert `read:jira-work` + `read:servicedesk-request`; does NOT contain `write:servicedesk-request`. Scope-mismatch body required — generic-expiry body routes through refresh coordinator (raw anyhow, not a JrError).
6. `test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint` — EXISTING (BC-3.8.015 pin, H-NEW-JSM-RT-003); already green on `develop`; MUST remain green unmodified. Bearer fixture, scope-mismatch body → asserts `write:servicedesk-request`.

All hint assertions use `contains`, not `==` (renderer prepends `"Not authenticated. "` or `"Insufficient token scope: "` — NOTE colon, not period, per `src/error.rs:8-16`).

### Removed Requirements

None.

### New Verification Properties

None (all 4 AC paths are boolean dispatch gates; proptest not applicable; BC-level integration test coverage sufficient per F1 delta analysis).

### Architecture Changes

- `JiraClient::is_oauth_auth() -> bool`: new public predicate method on `src/api/client.rs` — additive, no structural change. Reads existing `self.auth_header` field; no new dependencies.
- `API_TOKEN_EXPIRY_HINT: &str`: new shared constant in **`src/error.rs`** (NOT `src/api/client.rs` or any new module — `src/error.rs` is imported by both `api` and `cli` layers with no layering inversion; "no new modules" constraint honored). Referenced identically by `handle_jsm_create` and `require_service_desk` map_err sites.
- Architecture delta: none required.

### Impact Assessment

- **Affected stories:** 1 new story to implement (`is_oauth_auth` predicate + `API_TOKEN_EXPIRY_HINT` constant + gate both hint sites with rewrite logic + repurpose the pre-#384 Basic-auth 401 test → `test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint` as BC-3.8.014 pin with flipped assertions [fixture stays Basic, no Bearer migration] + add 3 new integration tests + `test_require_service_desk_oauth_401_surfaces_read_scope_hint` must use scope-mismatch body)
- **Affected tests:** `tests/issue_create_jsm.rs` — `test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint` stayed Basic, was repurposed with assertions flipped to API-token-expiry hint (not `write:servicedesk-request`); 2 new Basic-auth tests added; 1 new `require_service_desk` Basic test; 1 new `require_service_desk` OAuth test with scope-mismatch body. `test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint` is the BC-3.8.015 pin AND H-NEW-JSM-RT-003 binding — remains green unmodified. (Adversary-pass-9 C-01 correction: prior statement that holdout was realized as the pre-#384 test name is SUPERSEDED.)
- **Migration needed:** NO (no API change; error hint text changes only)
- **Migration notes:** N/A

### Adversary Pass-2 Corrections (2026-05-19)

Applied after second fresh-context adversary pass found 3 CRITICAL + 6 HIGH + 4 MEDIUM findings:

| Finding | Resolution |
|---------|-----------|
| C-01: `require_service_desk` has NO existing `map_err` at line 117 | BC-X.8.006/007 now explicitly state "MUST introduce a NEW `map_err`" — not "modify" |
| C-02: `InsufficientScope` renderer uses colon, not period | All `"Insufficient token scope. "` citations corrected to `"Insufficient token scope: "` throughout |
| C-03: BC-X.8.007 must NOT use `InsufficientScope` | Both OAuth sub-case arms in BC-X.8.007 now rewrite to `NotAuthenticated { hint }` — the `InsufficientScope` Display is POST-specific noise on a read GET |
| H-01: Dual exit codes (64 / 2) on `require_service_desk` | Added to BC-X.8.006/007: exit 64 (UserError, non-JSM) vs exit 2 (NotAuthenticated, 401) |
| H-02: H-NEW-JSM-RT-003 missing `GET /rest/api/3/project/{KEY}` mock | Added step 2 to holdout setup in holdout-scenarios.md and prd-delta |
| H-03: Count evidence missing from prd-delta | Added verbatim guard output + CANONICAL-COUNTS.md authority citation |
| H-04: `is_oauth_auth()` value-space imprecise | Full value-space documented in BC-3.8.014 and prd-delta; constructor error-on-empty noted |
| H-05/H-06: BC-3.8.015 false claim about OAuth NotAuthenticated → "generic jr auth login" | Corrected: pre-#384 map_err at create.rs:1988-1995 ALREADY rewrites NotAuthenticated to `write:servicedesk-request` for all auth; OAuth BOTH arms produce `write:servicedesk-request` |
| M-01: Trace file paths valid | Confirmed: `tests/issue_create_jsm.rs` exists. NOTE (adversary-pass-5 F-01 correction): H-NEW-JSM-RT-003 was at this point realized in `tests/issue_create_jsm.rs` — there is no separate `tests/issue_write_holdouts.rs` holding this holdout. At pass-5, the holdout was realized AS `test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint`. Subsequently, adversary-pass-9 C-01 re-bound H-NEW-JSM-RT-003 to `test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint`. |
| M-02: Cache-warm suppression as user-facing boundary | Added to BC-X.8.006/007 as explicit behavioral boundary (not just test-setup note) |
| M-03: `API_TOKEN_EXPIRY_HINT` location | Pinned to `src/error.rs` in BC-3.8.014, BC-X.8.006, prd-delta, changelog |
| M-04: Count evidence recorded | Covered by H-03 fix |

### Adversary Pass-3 Corrections (2026-05-19)

Applied after third fresh-context adversary pass found 2 CRITICAL + 6 HIGH findings:

| Finding | Resolution |
|---------|-----------|
| C-01: BC-X.8.006/007 described trigger as only `GET /rest/api/3/project/{key}`; `get_or_fetch_project_meta` issues TWO live GETs for service_desk-type projects | BC-X.8.006/007 Behavior sections broadened: trigger is "any 401 from `get_or_fetch_project_meta`'s live calls — the project GET OR the service-desk list GET (the latter fires only for service_desk-type projects)"; trigger description heading updated from "project GET" to "cache miss" |
| C-02: H-NEW-JSM-RT-003 project mock missing `"id"` field → `project_id` defaults to `""` → desk match fails → exit 64 before JSM POST | **[SUPERSEDED by Pass-6 — see `holdout-scenarios.md §H-NEW-JSM-RT-003`]** Pass-3 corrected mock bodies to `{"key":"HELPDESK","id":"10001","projectTypeKey":"service_desk"}` and `"projectId":"10001"`. Pass-6 subsequently regrounded the holdout to the real bound test fixture (project `HELP`, id `"99"`, `mount_project_meta_help`/`mount_service_desk_list` helpers). The `HELPDESK`/`10001` bodies here are historical and no longer authoritative. |
| H-03: BC-X.8.007 hint text leads with BYO-scope sentence before session-expiry recovery | Hint rewritten: LEADS with session-expiry recovery (`jr auth refresh` / `jr auth login`), BYO-OAuth scope sentence is SECONDARY |
| H-04: BC-X.8.007 verbatim hint block labeled "InsufficientScope-arm rewrite" as if sub-case-specific; both arms emit identical hint | ONE canonical verbatim hint block documented and labeled "both arms of the require_service_desk OAuth 401 map_err emit this identical hint"; single pinnable string for the acceptance test |
| H-05: BC-X.8.006/007 acceptance tests unnamed ("New integration test") | Named test functions added following project convention: `test_require_service_desk_basic_auth_401_surfaces_api_token_hint` (BC-X.8.006) and `test_require_service_desk_oauth_401_surfaces_read_scope_hint` (BC-X.8.007); cross-caller coverage clarified (map_err is in require_service_desk; tests pin create path; queue/requesttype existing tests cover regression) |
| H-06: H-NEW-JSM-RT-003 `BC:` list included BC-X.8.006/X.8.007 even though this holdout's GETs return 200 | BC-X.8.006/X.8.007 removed from BC list; clarifying note added to holdout body explaining why (those BCs fire on 401 from the GETs; this holdout's GETs return 200; those BCs are pinned by dedicated integration tests) |
| H-07: Changelog "Modified Requirements" table listed H-NEW-JSM-RT-003 (a holdout) alongside BCs | H-NEW-JSM-RT-003 moved to separate "Revised Holdouts" subsection in changelog |
| H-08: BC-3.8.001 missing from "Modified BCs" section and changelog "Modified Requirements" table | BC-3.8.001 added to both with annotation "cross-reference refresh — no behavioral change" |

### Adversary Pass-4 Corrections (2026-05-19)

Applied after fourth fresh-context adversary pass found 0 CRITICAL + 1 HIGH + 3 MEDIUM findings. Design model confirmed converged. All findings are pinning/consistency defects:

| Finding | Severity | Resolution |
|---------|----------|-----------|
| F-01: H-NEW-JSM-RT-003 step 4 request-type mock has bare-object body `{id: "5", name: "Get IT Help"}` that does NOT deserialize into the request-type page struct (paginated envelope with `isLastPage` + `values`); name resolution fails before the holdout reaches the JSM POST | HIGH | Step 4 body corrected to `{"isLastPage": true, "values": [{"id": "5", "name": "Get IT Help", "description": "IT support"}]}` — verbatim match to H-NEW-JSM-RT-004's step 3 mock (same endpoint, same struct, same deserializer); revision note added to holdout body |
| F-02: BC-3.8.014 acceptance-test list in prd-delta included `test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint` described at the time as a Bearer-fixture test under BC-3.8.014 (Basic-auth) — a test-ownership contradiction; BC body already correctly scoped it | MEDIUM | Removed from BC-3.8.014 acceptance-test list; added explicit F-02 note (subsequently superseded by adversary-pass-9 C-01 which confirmed the test stays Basic and is the BC-3.8.014 pin) |
| F-03: Required test deliverables not explicitly enumerated as mandatory acceptance-gate deliverables; scope-mismatch-rewrite test (`test_jsm_create_basic_auth_scope_mismatch_401_rewrites_to_api_token_hint`) — the highest-regression-risk pin — not flagged with ordering-dependency note | MEDIUM | Added "Required Test Deliverables" section to prd-delta-384.md listing all 5 named test functions as MANDATORY ACs; scope-mismatch-rewrite test explicitly flagged as highest-regression-risk pin with `client.rs:696-718` ordering dependency; corresponding entry added to this changelog Impact Assessment |
| F-04: `API_TOKEN_EXPIRY_HINT` Basic-auth hint text and BC-X.8.007 OAuth read-scope hint text each inlined verbatim in multiple spec files without a canonical-source designation; no doc-fallout protection on future edits | MEDIUM | Designated prd-delta-384.md copy of each hint as the CANONICAL verbatim block (labeled); duplicate locations in bc-3-issue-write.md, cross-cutting.md annotated with "duplicated from prd-delta-384.md §<BC> CANONICAL block — all copies MUST be updated together; cf. JR_* doc-fallout pattern in CLAUDE.md" |

### Required Test Deliverables (adversary-pass-4 F-03; adversary-pass-9 C-01 corrected — Impact Assessment entry)

> **[adversary-pass-5 LOW]** This list is duplicated near-verbatim from `prd-delta-384.md §Required Test Deliverables`. The `prd-delta-384.md` copy is canonical. Update both copies together when either changes.

> **[adversary-pass-9 C-01 CRITICAL correction]** Item 3 corrected — see adversary-pass-9 §Corrections below. Item 6 added.

The following named test functions are MANDATORY acceptance-gate deliverables of the implementing story. The implementing story's ACs MUST include each as a discrete AC:

1. `test_jsm_create_basic_auth_401_surfaces_api_token_hint` (NEW — BC-3.8.014)
2. `test_jsm_create_basic_auth_scope_mismatch_401_rewrites_to_api_token_hint` (NEW — BC-3.8.014; **highest regression risk** — pins `client.rs:696-718` ordering; must not be skipped)
3. `test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint` (REPURPOSED IN PLACE by F4 — BC-3.8.014 pin; fixture STAYS Basic; assertions flipped to API-token-expiry hint; negative assertion that `write:servicedesk-request` is ABSENT. Bearer not used — Bearer + generic-expiry routes through refresh coordinator and is not a valid pin.)
4. `test_require_service_desk_basic_auth_401_surfaces_api_token_hint` (NEW — BC-X.8.006; generic-expiry 401 body for Basic is fine — Basic never enters refresh path)
5. `test_require_service_desk_oauth_401_surfaces_read_scope_hint` (NEW — BC-X.8.007; scope-mismatch 401 body REQUIRED — generic-expiry Bearer 401 routes through refresh coordinator and is not a valid pin)
6. `test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint` (EXISTING — BC-3.8.015 pin; H-NEW-JSM-RT-003 re-bound here; already green on `develop`; MUST remain unmodified)

BC-3.8.015 has a holdout pin (H-NEW-JSM-RT-003 — re-bound to item 6 above). BC-3.8.014, BC-X.8.006, BC-X.8.007 rely solely on the named integration tests.

### Adversary Pass-5 Corrections (2026-05-19)

Applied after fifth fresh-context adversary pass found 0 CRITICAL + 3 HIGH + 4 MEDIUM findings. Design model and source-code anchors confirmed sound. All findings are test-symbol-accuracy and doc-consistency defects:

| Finding | Severity | Resolution |
|---------|----------|-----------|
| F-01: H-NEW-JSM-RT-003 test-file location contradiction — holdout body + changelog Impact Assessment cite `tests/issue_write_holdouts.rs`; ground truth is `tests/issue_create_jsm.rs` (the string `H-NEW-JSM-RT-003` appears ONLY there); the holdout and the pre-#384 Basic-auth 401 test were the SAME artifact at pass-5 | HIGH | Changelog Impact Assessment corrected: holdout was in `tests/issue_create_jsm.rs`, realized AS `test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint` (renamed by F4). M-01 pass-2 table entry corrected. holdout-scenarios.md §H-NEW-JSM-RT-003 clarified. Subsequently superseded by adversary-pass-9 C-01 which re-bound H-NEW-JSM-RT-003 to `test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint`. |
| F-02: BC-3.8.015 "UNCHANGED" framing misleading — the pre-#384 Basic-auth 401 test (`test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint`) used a Basic-auth fixture with generic 401 body (pre-#384 bug scenario); post-#384, Basic+generic-401 MUST produce the API-token hint per BC-3.8.014 → this test WOULD FAIL after BC-3.8.014 lands | HIGH | BC-3.8.015 section in prd-delta-384.md reworded. Subsequently superseded by adversary-pass-9 C-01 which found Bearer migration was unworkable — test was repurposed in place as a BC-3.8.014 pin with flipped assertions. |
| F-03: BC-3.8.015 Trace/prd-delta cite `test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint` as a test that "must remain green unmodified" without confirming the exact `async fn` symbol; test was unverified | HIGH | Verified by reading `async fn test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint` in `tests/issue_create_jsm.rs` (under the `// ─── C-01: OAuth InsufficientScope 401 surfaces write:servicedesk-request ────` section banner): confirmed `async fn` name, uses `JR_AUTH_HEADER=Bearer test-oauth-token` and a 401 body `{"errorMessages": ["Unauthorized; scope does not match"]}`. BC-3.8.015 Trace in bc-3-issue-write.md and prd-delta updated to use symbol-relative anchor (section banner + `async fn` name); hardcoded line numbers removed per adversary-pass-8 F-02. |
| F-04: H-NEW-JSM-RT-003 missing cache-miss precondition — BC-X.8.006/007 explicitly mandate "MUST force a cache miss"; the holdout's request-type GET mock is only reached on a cold cache but this precondition is implicit | MEDIUM | One-line cache-miss precondition added to H-NEW-JSM-RT-003 Setup in holdout-scenarios.md: "Cache dir is empty (isolated `tempfile::tempdir()` for `XDG_CACHE_HOME`) — all GET mocks are reached on a cold cache." |
| F-05: prd-delta Count Impact table omits "Before total" column — the +2 per file cannot be verified end-to-end | MEDIUM | "Before total" column added: bc-3-issue-write.md was 91 definitional / cross-cutting was 138 definitional; grand total before was 569; grand total after is 573 (+4 new BCs). Guard-script output in prd-delta relabeled "expected post-edit output; authoritative verification is `check-bc-cumulative-counts.sh`, not this document." |
| F-06: prd-delta §BC-3.8.001 summary understates change — says only "point at BC-3.8.009" but the BC body also names BC-3.8.014/015 inline | MEDIUM | prd-delta §Modified Behavioral Contracts §BC-3.8.001 summary aligned with BC body: "Errors cross-reference routes 401 via BC-3.8.009 and additionally names BC-3.8.014/015 inline." |
| F-07: `is_oauth_auth()` Interface Contract section missing `JR_AUTH_HEADER` seam value-space note — `is_oauth_auth()` is case- and space-sensitive; a malformed seam value silently misclassifies as Basic | MEDIUM | Added to prd-delta-384.md §Interface Contract: test fixtures using the debug-only `JR_AUTH_HEADER` seam MUST supply `"Bearer <token>"` (capital B, single trailing space) for OAuth branch and `"Basic <b64>"` for Basic branch; malformed values silently misclassify as Basic. |
| LOW: "Required Test Deliverables" list duplicated near-verbatim in prd-delta and changelog | LOW | prd-delta copy designated canonical; changelog copy annotated "duplicated from prd-delta-384.md §Required Test Deliverables — update together." |

### Adversary Pass-8 Corrections (2026-05-19)

Applied after eighth fresh-context adversary pass found 0 CRITICAL + 3 MEDIUM completeness/coherence defects (F-01, F-02, F-03) plus 1 LOW (URL-encoding note):

| Finding | Severity | Resolution |
|---------|----------|-----------|
| F-01: H-NEW-JSM-RT-003 Setup step 4 under-describes the request-type fixture — says "returns request types including Password Reset" without mentioning the two-element list or the `partial_match` resolution mechanism | MEDIUM | step 4 rewritten in holdout-scenarios.md §H-NEW-JSM-RT-003: `mount_request_type_list` returns a TWO-element list (`Get IT Help` id 11001 + `Password Reset` id 11002) via `two_request_types_body()`; `--request-type "Password Reset"` resolves via unique-substring `partial_match` (no ambiguity); note added that the sibling test deliberately uses the distinct `mount_request_types_password_reset` helper — do NOT consolidate the two helpers. |
| F-02: Hardcoded `tests/issue_create_jsm.rs:NNNN` line citations in F2 delta artifacts drift on every test insertion — conflicts with CLAUDE.md anti-drift convention | MEDIUM | Replaced EVERY `tests/issue_create_jsm.rs:NNNN` citation across `prd-delta-384.md`, `bc-3-issue-write.md`, `holdout-scenarios.md`, `spec-changelog.md` with symbol-relative anchors (`async fn` names and `// ─── section banner ───` references). `src/` line references retained (stable design anchors). De-pinned: `issue_create_jsm.rs:1523` → `async fn test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint` under `// ─── C-01 ───` banner; `issue_create_jsm.rs:1548` → `JR_AUTH_HEADER` env line inside that same `async fn`; `issue_create_jsm.rs:1335` → `JR_AUTH_HEADER` env line inside the pre-#384 Basic-auth 401 test (subsequently renamed by F4 to `async fn test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint`); `issue_create_jsm.rs:1309` → `async fn test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint` (same rename). |
| F-03: H-NEW-JSM-RT-003 `BC:` list omits BC-3.8.014 asymmetrically — the Expected section asserts BC-3.8.014's negative boundary but the `**Note**` only justifies BC-X.8.006/007's absence, leaving BC-3.8.014's absence unjustified | MEDIUM | Extended the `**Note**` in holdout-scenarios.md §H-NEW-JSM-RT-003 to address BC-3.8.014: the holdout asserts only BC-3.8.014's *negative* boundary (OAuth path must not leak the Basic-auth hint); BC-3.8.014's *positive* path is pinned by dedicated `test_jsm_create_basic_auth_401_surfaces_api_token_hint`; BC-3.8.014 intentionally absent from `BC:` list (consistent with how BC-X.8.006/007 are handled). |
| LOW: BC-X.8.006/007 Setup blocks mount `GET /rest/api/3/project/{KEY}` without noting URL-encoding — a key with special chars would need an encoded mock path | LOW | Added one-line note to cross-cutting.md §BC-X.8.006 and §BC-X.8.007 Setup blocks: the project key is URL-encoded by `get_or_fetch_project_meta` (`urlencoding::encode`), so a wiremock `path()` matcher is exact for plain-alphanumeric keys (the named tests use `HELP`); a key with special characters would require an encoded mock path. |

### Adversary Pass-9 Corrections (2026-05-19) — CRITICAL Control-Flow Trace

Applied after ninth fresh-context adversary pass traced the actual control flow in `src/api/client.rs` and found the OAuth test-pinning design from passes 1-8 was structurally impossible. This is a CRITICAL design correction.

**Root cause (traced control flow):**
- `client.rs:696-705`: scope-mismatch body (`"scope does not match"`) → `JrError::InsufficientScope` IMMEDIATELY, before Bearer guard AND before refresh coordinator. This fires for ANY auth scheme.
- `client.rs:718`: `if !auth_header.starts_with("Bearer ")` → `JrError::NotAuthenticated`. Fires ONLY for Basic auth. A Bearer client does NOT take this return.
- `client.rs:727+`: Bearer client with non-scope-mismatch 401 enters the auto-refresh coordinator. In `JR_AUTH_HEADER` seam tests (no keychain tokens), `refresh_oauth_token_with_url` returns raw `anyhow::bail!` (not a `JrError`). The `map_err`'s `e.downcast::<JrError>()` hits `Err(other) => other` — hint never injected.

| Finding | Severity | Resolution |
|---------|----------|-----------|
| C-01: BC-3.8.015 plan "migrate the pre-#384 Basic-auth 401 test to Bearer + generic-expiry body" was IMPOSSIBLE — Bearer + generic-expiry routes through refresh coordinator, fails with raw anyhow (not a JrError), `write:servicedesk-request` hint never injected. | CRITICAL | BC-3.8.015 re-specified: testable contract is scope-mismatch path ONLY (client.rs:696-704 short-circuit → deterministic `JrError::InsufficientScope`). Existing `test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint` (green on `develop`, unmodified) is the BC-3.8.015 pin. Generic-OAuth-401 refresh path is pre-existing, unchanged by #384, out of #384 test scope — stated explicitly in BC-3.8.015. |
| C-02: The pre-#384 Basic-auth 401 test — Basic + generic-401 under #384 produces BC-3.8.014 API-token-expiry hint; old assertion (`write:servicedesk-request`) would fail. Plan to switch to Bearer was impossible (C-01). | CRITICAL | Test REPURPOSED IN PLACE and RENAMED by F4 to `test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint`: fixture stays `JR_AUTH_HEADER=Basic dGVzdDp0ZXN0`; assertions flipped from `write:servicedesk-request` to BC-3.8.014 API-token-expiry hint; negative assertion that `write:servicedesk-request` is ABSENT added. BC-3.8.014 pin. Required Test Deliverables item 3 updated. |
| C-03: H-NEW-JSM-RT-003 was bound to the pre-#384 Basic-auth 401 test (now renamed `test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint`; Bearer + generic-expiry was impossible per C-01). | CRITICAL | H-NEW-JSM-RT-003 RE-BOUND to `test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint` (Bearer + scope-mismatch body — deterministic). Holdout rewritten in holdout-scenarios.md. Title updated. Holdout count unchanged (55 — re-bind not add/remove). |
| C-04: BC-X.8.007 Setup specified generic-expiry 401 body for project-GET mock — same defect: Bearer + generic-expiry routes through refresh coordinator, read-scope hint never injected. | CRITICAL | BC-X.8.007 Setup in cross-cutting.md corrected to scope-mismatch body (`{"errorMessages": ["Unauthorized; scope does not match"]}`). WHY explanation added inline. BC-X.8.006 (Basic) UNAFFECTED — Basic never enters refresh path. |
| C-05 (F1 decision reversal): F1 delta analysis §Decision #2 recorded "revise H-NEW-JSM-RT-003 to a Bearer + generic-body fixture." Decision unworkable. | HIGH | Formally reversed in adversary-pass-9: H-NEW-JSM-RT-003 is now the scope-mismatch Bearer test (existing, green, unmodified). The Basic generic-401 test is a BC-3.8.014 pin with flipped assertions. |

### Feature Request Link

- https://github.com/Zious11/jira-cli/issues/384

---

## [1.0.0] - 2026-05-04

### Type: MAJOR

### Summary

Initial L3 PRD release. Brownfield Phase 1 Burst 2 — 540 behavioral contracts imported from Pass 3, sharded into 7 bounded contexts plus cross-cutting. Baseline for all subsequent versions.

### New Requirements

All initial requirements (BC-1.*.* through BC-7.*.*, BC-X.*.*). See README.md Document Map.

### Impact Assessment

- **Affected stories:** None (initial release)
- **Migration needed:** NO

---

<!-- Template guide — copy the section below to add a new version entry above; keep reverse chronological order. Do NOT delete these placeholders — required by validate-template-compliance. -->

## [X.Y.Z] - YYYY-MM-DD

### Type: MAJOR / MINOR / PATCH

### Summary

[One-sentence summary of what changed and why.]

### Changed Requirements

- `file.md` (MODIFIED/NEW): description of change.

### Impact Assessment

| Artifact | Change Type | Notes |
|----------|-------------|-------|
| `file.md` | MODIFIED | Description |

---

<!-- Initial-release template placeholder (do not delete): -->

## [1.0.0] - YYYY-MM-DD

### Type: MAJOR

### Summary

Initial spec release. Baseline for all subsequent versions.

### New Requirements

[All initial requirements listed]

### Impact Assessment

- **Affected stories:** None (initial release)
- **Migration needed:** NO
