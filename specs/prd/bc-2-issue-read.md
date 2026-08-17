---
context: bc-2
title: "Issue Read (list/view/comments/changelog)"
total_bcs: 114   # cumulative claim (incl. range-collapsed); definitional_count below is individually-bodied headings
definitional_count: 72   # count of `#### BC-` headings in this file
last_updated: 2026-08-17
source_pass: 3
trace: |
  - v1.4.1 — F5 scoped-adversarial fix round (2026-08-17, component-mgmt, `issue list
    --component` filter): resolves findings F5-A-M1/F5-C-001 (human-adjudicated: UNION).
    `MatchResult::ExactMultiple` (2+ same-project components sharing a case-insensitive name,
    e.g. `Backend` id 10001 + `backend` id 10005) was underspecified on the read path — a
    naive reuse of `partial_match`'s first-match-wins return value would silently union to
    only ONE id, dropping issues tagged with the other duplicate from `issue list --component`
    results. BC-2.1.018 gains Precondition/Postcondition 3 + EC-2.1.018-3 + VP-COMPONENT-022
    (bare `in (...)` UNION, ascending-id order within a duplicate's own slot); BC-2.1.019
    gains Postcondition 3 + EC-2.1.019-4 (`not:` OR-EMPTY-group UNION); BC-2.1.021 gains
    Postcondition 2 + EC-2.1.021-4 (`all:` parenthesized-OR-of-equalities term per duplicated
    name); BC-2.1.022 gains EC-2.1.022-3 + a new "ExactMultiple read-path disposition"
    subsection documenting the deliberate divergence from the mutating path's fail-closed
    disposition (`component edit`/`delete`/`--move-to`, BC-8.1.008 branch (0), unchanged by
    this fix — mutations still exit 64 and require the numeric id). Cross-references
    bc-8-components.md BC-8.4.005, amended in the same round to state both caller-specific
    dispositions explicitly instead of implying a single universal outcome. No new BC IDs; no
    count change (114/72). BC-INDEX v6.79→v6.80; spec v1.4.0→v1.4.1 (PATCH).
  - F2 spec evolution, component-management bundle (2026-08-15, issue #606, plus the shared
    prerequisite for #604/#605/#608): BC-2.1.018..022 ADDED — `issue list --component` filter:
    OR-list (018), `not:` with OR-EMPTY (019), reserved `none` keyword (020), `all:` AND-form
    (021), unresolvable/ambiguous exit-64 pre-search (022). BC-2.1.006 UPDATED — filter-source
    count 13→14 (`--component` added to the enumerated stderr list). BC-2.1.007 UPDATED —
    `--component`'s stable clause position pinned (after `asset`, before date-range clauses).
    BC-2.3.040 ADDED — `Component` struct gains `id: Option<String>` (shared prerequisite all
    four component-management issues depend on; precedent: 2026-08-13 `duedate` amendment
    shape; `Option<String>`, not `String` — this trace line previously said `String`, drifting
    from the BC-2.3.040 body's `Option<String>` M8 fix-burst correction; fixed here 2026-08-15,
    M-4, adversarial spec-delta review pass 2).
    +6 new individually-bodied BCs (66→72); total_bcs 108→114. See
    `.factory/phase-f1-delta-analysis/delta-analysis-components.md`,
    `.factory/phase-f1-delta-analysis/business-analyst-input-components.md`.
  - v1.3.180 — F2 spec evolution, bucket1-defects bundle (2026-08-13, issue #694): 0 new BCs — docs-only help-text sync between `src/cli/mod.rs` clap doc comments (the `IssueCommand::Attachment` parent `about` string, the `Download` subcommand's `--out-dir` help, and its `--newest` help) and the behavior these BCs already specify. No BC body text changed; the three doc-comment sites were stale/incomplete relative to already-ratified behavior: (1) parent `about` under-enumerated the four `AttachmentSubcommand` variants (List/Download/Upload/Delete) — behavior already implicit in the enum itself, no owning BC; (2) `--out-dir` help did not mention the batch on-disk naming scheme `<40-char-SHA-1-of-attachment-id>_<sanitized-filename>`, already specified by BC-2.7.010; (3) `--newest` help did not state the filter-before-sort-before-truncate order (filter → sort by `created` descending → truncate to N), already specified by BC-2.7.009 (cross-referencing BC-2.7.008). See `.factory/research/bucket1-694-attachment-docs-2026-08-13.md` for the full claim-by-claim verification. BC count unchanged (66/108).
  - v1.3.177 — F2 spec evolution (2026-08-13, issue #668, duedate feature): BC-2.2.028 AMENDED (search_issues default fields list 16→17, `duedate` inserted after `updated`/before `resolution`); BC-2.3.036 AMENDED (get_issue field enumeration gains `duedate`, dedicated date-only semantics documented, named-field-not-flatten confirmed); BC-2.2.032 NEW (`issue list --duedate` opt-in column, position/formatter/empty-rendering policy); BC-2.3.039 NEW (`issue view` always-on Due Date row, position/formatter/empty-rendering policy); BC count 106→108 (64→66 individually-bodied); BC-INDEX v6.75→v6.76.
  - v1.3.177 fix-round — scoped adversarial review (2026-08-13, issue #668) found 1 HIGH + 6 MEDIUM + 2 LOW real findings, all fixed same-day, no BC count change: F1 (HIGH) BC-2.3.039 hallucinated a `Resolution` row precedent that does not exist in `handle_view` — corrected to `Created`/`Updated` only; F2 (MED) BC-2.2.032 parse-failure warning corrected to name the real `log_parse_failure_once` chokepoint, its `--verbose` gating, and the resulting `format_issue_row`/`format_issue_rows_public` signature change (new `verbose: bool` param) as a normative part of the BC; F3 (MED) BC-2.2.032 gained a Scope clause naming `board.rs`/`queue.rs`/`sprint.rs` as other callers of the shared row/header builders that do NOT gain the column; F4 (MED) `cross-cutting.md` BC-X.8.009 amended — its stale 3-arg `issue_table_headers` citation and unconditional "same column set as `jr issue list`" claim corrected against BC-2.2.032; F5 (MED) BC-2.3.039's "raw JSON passthrough" claim corrected to "typed struct serialization via `output::render_json`," with the two conditions (`BASE_ISSUE_FIELDS` request + no `skip_serializing_if`) stated explicitly; F6 (MED) BC-2.3.039's citation for the request-field-list amendment corrected from BC-2.3.036 to BC-2.2.028 (the BC that actually amends `BASE_ISSUE_FIELDS`); F7 (MED) BC-2.2.032 gained an explicit JSON-mode clause (`--duedate` has no effect on `--output json` shape); F8 (MED) BC-2.2.032's `--points` precedent citation corrected to distinguish "same code mechanism" from "same contracted behavior" (BC-2.2.021/022 do not themselves contract column-rendering); F9 (LOW) Column-set backfill deferral note reworded with a normativity caveat (BC-2.2.032's Column position clause is now the sole written column-list contract); F10 (LOW) both BCs gained a defensive `Some("")`-treated-as-`-` empty-string clause. F11 (BC-ID near-miss collision across subsystems, e.g. BC-2.2.032/BC-2.3.032) and F12 (a physical mis-placement of BC-2.2.032 between BC-2.2.028 and BC-2.2.029, now corrected to sit after BC-2.2.031) — F12 fixed as a drafting-error correction (BC-2.2.032 moved to its correct sequential position); F11 is a pre-existing file-wide numbering-convention property (also present at BC-2.4.043/BC-2.5.043) and is not fixed by this delta.
  - v1.3.179 fix-round — human-directed formatter simplification (2026-08-13, issue #668): BC-2.2.032 and BC-2.3.039 both simplified from a `chrono::NaiveDate` parse-then-reformat round-trip (plus its `log_parse_failure_once`/`--verbose`-gated warning and the resulting `verbose: bool` signature-change mandate on `format_issue_row`/`format_issue_rows_public`) down to VERBATIM string display — Jira already returns `duedate` as `YYYY-MM-DD`, so the round-trip was pure overhead for input Jira never emits. All parse/reformat/warning/verbose-threading machinery removed from both BC bodies; replaced with a shared trivial render-string-or-dash helper (`None`/`Some("")` → `-`, else verbatim). Blast radius reduced from a 4-call-site signature change (`board.rs`/`queue.rs`/`sprint.rs`/`list.rs`, threading `verbose: bool`) to the single, already-scoped opt-in Due Date column parameter. No BC IDs changed, no count change (still 108/66).
  - L2: .factory/specs/domain-spec/bc-02-issue-read.md
  - Source broad: .factory/semport/jira-cli/jira-cli-pass-3-behavioral-contracts.md §2.2
  - Source R1: .factory/semport/jira-cli/jira-cli-pass-3-deep-r1.md §3.2
  - Source R4: .factory/semport/jira-cli/jira-cli-pass-3-deep-r4.md §3.1
  - SOH-ATTACHMENTS-1 F2 addition (2026-07-15): BC-2.7.001..012 — Attachment Read: attachment list (table+JSON, filters mime/name/size-max), attachment download (single/batch/newest, streaming, redirect-following, CWE-22 sanitization, SHA-1 default path, JSDCLOUD-10841 JSM uniform), error taxonomy (DEC-179, issues #576 #585)
  - SOH-ATTACHMENTS-1 adversary pass-19 (2026-07-16): BC-2.7.002 BTreeMap-alphabetical key order clause + example reorder (P19-001); EC-2.7.001-2 JSON-mode filter-count hint clause (P19-002); EC-2.7.007-5 best-effort MUST + tokio ctrl_c implementation note (P19-003); spec v1.3.59
  - SOH-ATTACHMENTS-1 adversary pass-20 (2026-07-16): BC-2.7.007 `--out` unconditional step-1 clause added — step 1 always issued even with `--out`; pre-stream existence validation; one extra GET accepted cost (P20-003); VP-576-004 attachment-object JSON transformation pin added to BC-2.7.002 — `"self"` OMITTED, `"content"` RENAMED to `"contentUrl"` (P20-006); spec v1.3.60
  - SOH-ATTACHMENTS-1 adversary pass-21 (2026-07-16): BC-2.7.012 KEY-404 batch-paths-only annotation — `--id` does not server-verify KEY per BC-2.7.007 (P21-006); spec v1.3.61
  - SOH-ATTACHMENTS-1 adversary pass-22 (2026-07-16): BC-2.7.012 body prose "Unknown issue key" sentence prepended with batch-only caveat; BC-2.7.012 Trace field updated with P22-003 citation (P22-003); spec v1.3.62
  - v1.3.64 — P24 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): VP-576-004 story-allocation annotation added (P24-002): list half verified at S1 (BC-2.7.002 home); upload-platform-POST half verified at S3 (BC-3.9.009); full cross-path test lands at S3 — S3 depends_on S1 for shared curated-serialization plumbing (R3.13 earliest-consumer principle); NOT part of S1 acceptance matrix as a whole; S1 matrix includes only the list half. (Note: v1.3.63 entry is NOT owed — P23 did not touch bc-2-issue-read.md.)
  - v1.3.65 — P25 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): EC-2.7.008-6 extended — JSON-mode hint-vs-error policy added (per-file failure warnings ARE emitted in JSON mode as ERRORS; `Downloaded N of M` summary NOT emitted in JSON mode as it is a HINT) (P25-001); EC-2.7.008-7 mode-scoped — summary scoped to human mode only (P25-001); Per-file download error policy point (3) updated — summary clause scoped to human mode (P25-001); BC-2.7.008 Trace updated; BC-2.7.011 containment step-1 case (c) reworded — pure does-not-apply exclusion for `--out <PATH>` (trusted operator input; neither step-1 canonicalize nor step-2 starts_with applies) (P25-002).
  - v1.3.66 — P26 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): BC-2.7.012 KEY-403 batch-paths-only row added to error table (P26-001); BC-2.7.007 step 1 partial-struct absent-tolerance clause added (P26-003); BC-2.7.007 and BC-2.7.012 Trace fields updated.
  - v1.3.67 — P27 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): EC-2.7.007-7 `filename` semantics clause added — `downloaded[].filename` is RAW Jira name (pre-sanitization); on-disk basename recoverable from `path`; deliberate pairing documented (P27-001); EC-2.7.008-6 same `filename` semantics clause added; collision-skip warnings classified as NON-ERROR hints, suppressed in JSON mode (P27-003); BC-2.7.007 and BC-2.7.008 Trace fields updated.
  - v1.3.71 — P31 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): BC-2.7.008 Batch metadata source scoped — list response for NAMING/filtering/pre-download; manifest `size` = written-bytes per EC-2.7.008-6 (P31-002); EC-2.7.008-6 `size` semantics sentence added — written-bytes authoritative, NOT list-reported `fields.attachment[].size`; "Shape aligns" → "Shape and field semantics align" (P31-002); BC-2.7.008 Trace updated.
  - v1.3.72 — P32 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): BC-2.7.007 `--out` unconditional step-1 paragraph: ordering sentence added — local pre-flight checks (EC-2.7.007-6 parent-exists, EC-2.7.007-11 path-is-directory, overwrite-refuse) fire BEFORE step-1 metadata GET; fail cheap/offline first (AID-regex-before-HTTP precedent); double-fault → local check's message wins (P32-001); BC-2.7.007 Trace updated.
  - v1.3.74 — P34 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): EC-2.7.008-1 JSON-mode clause added — empty-issue `--all` returns `{"downloaded":[]}` in JSON mode; `"No attachments on <KEY>."` is a HINT suppressed in JSON mode per EC-2.7.008-6 taxonomy; EC-2.7.001-1 unification clarified as canonical STRING only, not JSON shape (P34-004); EC-2.7.009-4 empty-issue cross-ref added to BC-2.7.009 — empty issue on `--newest` follows EC-2.7.008-1 (P34-004); BC-2.7.008 and BC-2.7.009 Trace fields updated.
  - v1.3.78 — Closing micro-round 1.3.77→1.3.78 (2026-07-17, SOH-ATTACHMENTS-1): BC-2.7.002 `302/303-redirects` parity with BC-2.7.007 (P38-I1); EC-2.7.001-2 N==M clause added — hint fires only when displayed count is reduced (P39-I2); triple blank lines after EC-2.7.008-6 collapsed to one (INFO-1).
  - v1.3.95 — Adversary pass-1 P1-002 reconciliation (2026-07-19, SOH-ATTACHMENTS-1 Step 4.5): BC-2.7.002 author-curated-form ruling — removed internal contradiction between "User serde shape / pass-through" claim and the authority clause's self-omission mandate. Author in JSON is always the curated `{accountId, displayName}` object only (values as-received including null); no `self`, `avatarUrls`, `accountType`, `timeZone`, `emailAddress`, or `active` fields are emitted. Partial-author case now specifies `{"accountId": null, "displayName": null}` (not raw pass-through). Line 612 field note rewritten; line 619 pass-through sentence replaced.
  - v1.3.80 — Security fix round SEC-576-v2 (2026-07-17, SOH-ATTACHMENTS-1): BC-2.7.007 step 2 `?redirect=false` prohibition promoted to body clause (SEC-576-009); EC-2.7.007-12 added — single-id overwrite-refuse pre-flight EC (SEC-576-010); BC-2.7.010 server-ID trust assumption note (SEC-576-008); BC-2.7.011 display-sanitization clause for TTY output (SEC-576-011 CWE-116); SEC-576-011 cross-references added to BC-2.7.008 Overwrite behavior and BC-2.7.010 degenerate-name warning; BC-2.7.007/BC-2.7.008/BC-2.7.010/BC-2.7.011 Trace fields updated.
  - v1.3.81 — r43 micro-fix round (2026-07-17, SOH-ATTACHMENTS-1): BC-2.7.011 display-sanitization primary clause corrected — earliest consumer S2→S1 (S1 list table cells ship first; NEW-576-V3-001 fold); S3 added to allocation guidance alongside S4 (GAP-R43-002); Unicode bidi/line-terminator out-of-scope sentence appended (NEW-576-V3-002); BC-2.7.011 Trace updated.
  - v1.3.88 — P20-ROUND micro-fix (2026-07-18, SOH-ATTACHMENTS-1): 0 new BCs — Error Path Summary network drop bullet corrected from semicolon form `"Could not reach <host>; check your connection"` to loose-substring form consistent with the adjacent 401 row (P20-002 INFO three-way divergence); source: `src/error.rs::JrError::NetworkError` `#[error("Could not reach {0} — check your connection")]` (em-dash, no semicolon/colon); BC count unchanged (64/106)
  - v1.3.94 — PRE-F4-UNICODE-DISPLAY-SANITIZATION (2026-07-18, SOH-ATTACHMENTS-1): 0 new BCs — BC-2.7.011 display-sanitization character set extended to Unicode bidi controls U+202A..U+202E and U+2066..U+2069, line/paragraph separators U+2028/U+2029, and NEL U+0085; implementation form specified (char-level matching, not bytes); unit-test mandate added (U+202E/U+2028/U+0085 required cases); scope note REPLACED with closed-enumeration scope statement (confusables/homoglyphs OUT of scope — not a terminal-injection vector); BC-2.7.008/BC-2.7.010 cross-ref wording updated to point to BC-2.7.011 character set (preferred over inline range re-statement); BC-2.7.008/BC-2.7.010/BC-2.7.011 Trace fields updated; BC count unchanged (64/106)
  - v1.3.96 — P2-001 ratification micro-round (2026-07-19, SOH-ATTACHMENTS-1 Step 4.5 pass-2): 0 new BCs — EC-2.7.001-3 extended: empty-string ("") values treated as absent for author fallback-chain purposes; a present-but-empty displayName or accountId falls through to the next link (defensive display convention; real Jira Cloud never emits empty-string displayName; ratified per P2-001 finding 2026-07-19); BC-2.7.001 Trace updated; BC count unchanged (64/106)
  - v1.3.97 — P8-002 correction micro-round (2026-07-20, SOH-ATTACHMENTS-1 Step 4.5 pass-8): 0 new BCs — EC-2.7.007-5 implementation-strategy note corrected: SIGINT temp-file cleanup was NEVER implemented (main.rs ctrl_c arm calls std::process::exit(130) directly; no temp-file registry exists); orphaned tmp_<random-hex> files are an accepted best-effort residual (harmless; deferred as S-576 bundle tracked debt); "best-effort MUST" language relaxed to "best-effort"; BC-2.7.007 Trace updated; BC count unchanged (64/106)
  - v1.3.102 — F5-R5-001 research-backed amendment (2026-07-24): 0 new BCs — BC-2.7.012 disk-write error strings amended to HYBRID shape per `.factory/research/f5-r5-001-disk-error-taxonomy-2026-07-24.md`; three error-table rows updated: (1) disk-full row: `ErrorKind::StorageFull | QuotaExceeded` detection, appends `<os_error>` + "Free up disk space and try again." remediation hint; (2) permission-denied row: `ErrorKind::PermissionDenied | ReadOnlyFilesystem` detection, appends `<os_error>` + "Check directory permissions and try again." hint; (3) generic fallback: changed from "OS error message surfaced" to `Failed to write <dest>: <os_error>.`; detection-and-testing note added: `e.kind()` at all three io sites in `stream_to_file`; `<dest>` = final path (not `tmp_<hex>`), server-supplied filename portion display-sanitized (CWE-116); MSRV-1.85 `ErrorKind` stability confirmed (StorageFull/ReadOnlyFilesystem stable 1.83, QuotaExceeded stable 1.85, PermissionDenied stable 1.0; Windows ERROR_DISK_FULL→StorageFull, ERROR_ACCESS_DENIED→PermissionDenied; no #[cfg] needed); pure classifier fn unit-test mandate (`fn classify_write_error(kind, dest_display, dir_display, os_err) -> String`, non-exhaustive `_ =>` arm); BC count unchanged (64/106)
  - v1.3.103 — FIX-F5-010 Windows CI collision (2026-07-24): 0 new BCs — BC-2.7.012 permission-denied row amended: `(writing <dest>)` parenthetical added after `<dir>` in the error prefix, making the full string `Permission denied: cannot write to <dir> (writing <dest>): <os_error>. Check directory permissions and try again.`; prefix and hint preserved verbatim; `<dest>` = display-sanitized final destination filename (CWE-116); reconciles BC-2.7.007 P9-001 (rename-failure error must contain the display-sanitized destination filename) which the v1.3.102 shape violated on Windows (rename-to-existing returns ErrorKind::PermissionDenied → message omitted filename); P9-001 reconciliation note added to Disk-write error detection and classification paragraph; BC count unchanged (64/106)
  - v1.3.162 — AX-001 (REFINEMENT, MEDIUM): BC-2.7.001 H1 synced with BC-INDEX (2026-07-28): added "renders table:" prefix (was "table columns —"); added "; output channel profile 2 (stdout data, stderr hints)" suffix; "(human-readable)" was already correct in H1; verified against `src/cli/issue/attachments.rs::format_size` (human-formatted size used in table at line 249/1240; raw `u64` used for JSON per line 307 contrast comment) and `**Output channel profile**: 2` field in BC-2.7.001 body; BC count unchanged (64/106)
  - v1.3.104 — F5-R6-001/F5-R6-002 micro-fix (2026-07-24): 0 new BCs — BC-2.7.012 disk-write detection paragraph: io-site count corrected three→four (add `flush`; delayed-allocation rationale: ENOSPC can surface at flush time on Linux ext4 and similar delayed-allocation filesystems); INFO note added for F5-R6-002 mid-stream body-read abort sub-case (distinct from content-GET NetworkError row; `"stream error: {e}"` exit 1; accepted wording divergence documented); BC-INDEX v6.41→v6.42; BC count unchanged (64/106)
---

# BC-2 — Issue Read (list / view / comments / changelog)

114 behavioral contracts across 7 subdomains: JQL composition (2.1), Issue list
behavior (2.2), Issue view (2.3), Comments (2.4), Changelog (2.5), API layer (2.6),
Attachment Read (2.7).

---

## Subdomains

### 2.1 JQL Composition (the canonical build pipeline)

#### BC-2.1.001: `issue list` cursor-paginates via `POST /rest/api/3/search/jql`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~7-31, 130-166`
**Subject**: Issue read
**Behavior**: `client.search_issues(jql, limit, fields)` posts to `/rest/api/3/search/jql`; returns `{issues: Vec<Issue>, has_more: bool}`. Pagination via `nextPageToken` cursor.
**Trace**: Pass 3 BC-101

---

#### BC-2.1.002: `--jql X` wraps in parens, strips ORDER BY, re-appends `ORDER BY updated DESC`

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~36-52`; `tests/all_flag_behavior.rs:~54-66`; unit tests covering `build_jql_base_parts` variants
**Subject**: Issue read
**Behavior**: `build_jql_base_parts(jql, project_key)` calls `jql::strip_order_by(jql)`, wraps in parens. Order-by slot is ALWAYS `"updated DESC"` — user's `ORDER BY rank ASC` is silently replaced. `--jql "priority = Highest ORDER BY created DESC" --project PROJ` → `(project = "PROJ") AND (priority = Highest) ORDER BY updated DESC`.
**Edge cases**: user ORDER BY is stripped, never preserved.
**Trace**: Pass 3 BC-102, BC-125 (R1)

---

#### BC-2.1.003: Scrum board with active sprint → JQL `sprint = <id> ORDER BY rank ASC`

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~278-282`; `tests/all_flag_behavior.rs:~347-352`
**Subject**: Issue read
**Behavior**: When no `--jql` AND board_id+scrum+active-sprint: `sprint = {sprint.id}` + order by `rank ASC`. Sprint ID from `client.list_sprints(bid, Some("active"))`.
**Trace**: Pass 3 BC-126 (R1)

---

#### BC-2.1.004: Kanban board → `project = "X" AND statusCategory != Done ORDER BY rank ASC`

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~302-310`; `tests/all_flag_behavior.rs:~497-516, 542-562`
**Subject**: Issue read
**Behavior**: Body-match pins literal composed JQL. The `statusCategory != Done` is server-side (not `--open` flag).
**Trace**: Pass 3 BC-127 (R1)

---

#### BC-2.1.005: No board_id → `project = "X" ORDER BY updated DESC`

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~331-338`; `tests/all_flag_behavior.rs:~42-86`
**Trace**: Pass 3 BC-128 (R1)

---

#### BC-2.1.006: No project AND no filters AND no `--jql` → exit 64 listing all 14 filter sources

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~344-351`
**Subject**: Issue read
**Behavior**: stderr contains literal `"No project or filters specified. Use --project, --assignee, --reporter, --status, --open, --team, --recent, --created-after, --created-before, --updated-after, --updated-before, --asset, --component, or --jql. You can also set a default project in .jr.toml or run \"jr init\"."`.
**Error taxonomy**: `JrError::UserError` (exit 64).

**[UPDATED 2026-08-15 issue #606 F2]** `--component` joins the enumerated filter-source list
as source #14 (13 → 14). **Previous version (superseded, retained for audit trail):** stderr
literal ended `"... --updated-before, --asset, or --jql. ..."` (13 sources, no `--component`).

**Trace**: Pass 3 BC-129 (R1)

---

#### BC-2.1.007: `build_filter_clauses` emits in stable order: assignee, reporter, status, open, team, recent, asset, component, created-after/before, updated-after/before

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~613-649`; unit tests covering `build_jql_parts_*` clause variants
**Subject**: Issue read
**Behavior**: Each `Some` flag pushes clause in listed order. Final JQL: `parts.join(" AND ")`. Order stable across invocations. Key clause shapes:
- `assignee = currentUser()` (for `--assignee me`)
- `reporter = <accountId>` (raw, not quoted)
- `created >= -7d` (for `--recent 7d`)
- `statusCategory != Done` (for `--open`)
- `status = "He said \"hi\" \\o/"` (JQL-escaped)
- `component in (10001, 10002)` / `(component not in (10001) OR component is EMPTY)` /
  `component is EMPTY` / `component = 10001 AND component = 10002` — one of the four
  `--component` operator shapes, per BC-2.1.018..021.

**[UPDATED 2026-08-15 issue #606 F2]** `--component` is inserted into the stable-order list
immediately AFTER `asset` and BEFORE the created/updated date-range clauses — i.e. between
BC-2.1.011..017's asset-filter clause and BC-2.1.008..010's date-range clauses in emission
order. This position is pinned by the same exact-clause-order test discipline as every other
member of this list (`Vec<String>` positional equality, not membership — see F1 delta
analysis §3 regression-risk note on this function). **Previous version (superseded, retained
for audit trail):** "assignee, reporter, status, open, team, recent, asset, created-after/
before, updated-after/before" (no `component` member).

**Verification Properties**:
- VP-COMPONENT-015: `build_filter_clauses` emits the four `--component` operator shapes
  exactly (bare/repeated → `component in (id1, id2, …)` in input order; `not:` → the single
  `(component not in (…) OR component is EMPTY)` group; `none` → `component is EMPTY` with
  zero resolver HTTP; `all:` → `component = id1 AND component = id2 …`), and the `--component`
  clause holds its pinned position (after `asset`, before date-range) via `Vec<String>`
  positional equality.

**Trace**: Pass 3 BC-130 (R1); BC-1093 (R4 enumeration)

---

#### BC-2.1.008: `--recent <duration>` validated by `jql::validate_duration` (NOT `duration::parse_duration`); combined units rejected

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~90-92`; `src/jql.rs:~16-34`
**Subject**: Issue read
**Behavior**: `validate_duration("4w2d")` → Err. `--recent 4w2d` → `JrError::UserError("Invalid duration '4w2d'. Use a number followed by y, M, w, d, h, or m (e.g., 7d, 4w, 2M).")`. Pre-HTTP validation.
**Trace**: Pass 3 BC-131 (R1)

---

#### BC-2.1.009: `--created-after/before` and `--updated-after/before` validated via `jql::validate_date` BEFORE any HTTP

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~95-114`
**Subject**: Issue read
**Behavior**: Format: `YYYY-MM-DD`. On invalid: `Invalid date "<X>". Expected format: YYYY-MM-DD (e.g., 2026-03-18).` All four validators run before HTTP.
**Trace**: Pass 3 BC-132 (R1)

---

#### BC-2.1.010: `--created-before` and `--updated-before` use `date + Days::new(1)` for end-day-inclusive semantics

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~118-126`
**Subject**: Issue read
**Behavior**: User passes `--created-before 2026-03-31`; emitted clause is `created < "2026-04-01"`. Pinned by unit test `build_jql_parts_created_date_range`.
**Trace**: Pass 3 BC-133 (R1)

---

#### BC-2.1.011: `--asset KEY` resolves via CMDB fields; if NO CMDB fields → exit 64 with JSM plan message

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~168-183`
**Subject**: Issue read
**Behavior**: On `cmdb_fields.is_empty()`: `JrError::UserError("--asset requires Assets custom fields on this Jira instance. Assets requires a paid Jira Service Management plan.")`.
**Trace**: Pass 3 BC-134 (R1)

---

#### BC-2.1.012: `--asset KEY` ambiguous AQL result → exit 64 `Multiple assets match`; NO issue search fired

**Confidence**: HIGH
**Source**: `tests/assets.rs:~1480-1573`; `src/cli/issue/list.rs:~128-133`
**Subject**: Issue read
**Behavior**: Test asserts `stderr.contains("Multiple assets match")` + both candidate labels + `expect(0)` on `/rest/api/3/search/jql`. Exit 64.
**Trace**: Pass 3 BC-135 (R1)

---

#### BC-2.1.013: `--status <single-substring>` → exit 64 `Ambiguous status`; NO JQL search fired

**Confidence**: HIGH
**Source**: `tests/issue_list_errors.rs:~368-422`; `src/cli/issue/list.rs:~222-247`
**Subject**: Issue read
**Behavior**: `Mock::expect(0)` on `POST /rest/api/3/search/jql`. stderr `Ambiguous status "prog". Matches: In Progress`. Exit 64.
**Trace**: Pass 3 BC-105, BC-136 (R1)

---

#### BC-2.1.014: `--status NOMATCH` → `JrError::UserError` listing available statuses alphabetically

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~234-246`
**Subject**: Issue read
**Behavior**: `MatchResult::None(all)` constructs full error: `"No status matching \"X\" for project Y. Available: <comma-joined alphabetical list>"`. List always sorted.
**Trace**: Pass 3 BC-138 (R1)

---

#### BC-2.1.015: `--status <ExactMultiple>` treated as Exact (case-variant duplicates)

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~223-226`
**Trace**: Pass 3 BC-137 (R1)

---

#### BC-2.1.016: `--assets` column auto-enabled when `--asset KEY` filter is set

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~86-87`
**Subject**: Issue read
**Behavior**: `let show_assets = show_assets || asset_key.is_some();`
**Trace**: Pass 3 BC-145 (R1)

---

#### BC-2.1.017: `--assets` with no CMDB fields → stderr warning, no asset column

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~357-371`
**Behavior**: stderr: `"warning: --assets ignored. No Assets custom fields found on this Jira instance."`.
**Trace**: Pass 3 BC-146 (R1)

---

#### BC-2.1.018: `--component <NAME>` (repeated) → OR-combined `component in (id1, id2, ...)`; each name resolved independently BEFORE composition

**Confidence**: HIGH
**Source**: F1 delta analysis §2 (BA precedent BC-2.1.011 asset-key resolution pattern);
`src/cli/issue/list.rs` (pending F4)
**Subject**: Issue read — `--component` filter (issue #606)
**Behavior**: `--component <NAME>` is repeatable; each occurrence independently resolves via
§8.4 (`bc-8-components.md`, scoped to the `issue list` invocation's resolved project — the
SAME project scope `--asset`/other project-scoped filters already use) to a numeric
component id BEFORE JQL composition. Multiple `--component` values OR-combine into a single
`component in (id1, id2, ...)` clause (NOT one clause per value) — this is the natural
semantics of Jira's `IN` operator and matches how a user expects repeated `--component` flags
to behave (any-of, not all-of; `all:` is the explicit AND-form, BC-2.1.021).
**Preconditions**:
1. At least one `--component <NAME>` (no `not:`/`none`/`all:` prefix) is supplied.
2. Every supplied name resolves to exactly one component within the resolved project scope
   (§8.4) — see BC-2.1.022 for the failure path.
3. **[NEW 2026-08-15, M3 fix-burst]** Bare `--component <NAME>` values MAY coexist with
   `--component not:<NAME>` values in the SAME invocation (see BC-2.1.019 Postcondition 2) —
   composition is DEFINED, not rejected. Coexistence with `--component none` (BC-2.1.020
   Precondition 1) or `--component all:...` (BC-2.1.021 Precondition 2) remains rejected;
   only bare+`not:` may combine. Rationale: bare (inclusion, OR-list) and `not:` (exclusion,
   OR-EMPTY) are ADDITIVE, non-contradictory constraints — "must have Backend AND must not
   have Deprecated" is a coherent filter — unlike combining `all:`'s AND-semantics with
   `in`'s OR-semantics in the same logical dimension (rejected by BC-2.1.021 Precondition 2),
   or `none`'s "zero components" statement with any positive/negative constraint (rejected by
   BC-2.1.020 Precondition 1).
**Postconditions**:
1. The composed clause is `component in (<id1>, <id2>, ...)` where ids are numeric, comma-
   space-joined, in the order names were resolved (input order preserved).
2. This clause takes the ordered position established by BC-2.1.007's amendment (after
   `asset`, before the date-range clauses). When BC-2.1.019's `not:` clause is ALSO present
   (Precondition 3), the bare `in (...)` clause emits FIRST, immediately followed by the
   `not:` group's `(component not in (...) OR component is EMPTY)` clause — both clauses
   occupy two consecutive slots at the position BC-2.1.007 pins, and the overall JQL AND-joins
   them via `build_filter_clauses`' existing `parts.join(" AND ")` composition (no special
   merge logic — each shape independently pushes its own `String` onto `parts`).
3. **[NEW 2026-08-15, F5-A-M1/F5-C-001 fix — human-adjudicated: UNION]** When a single
   `--component <NAME>` value resolves to `MatchResult::ExactMultiple` (BC-X.10.003 — the
   resolved project has 2+ components sharing the same case-insensitive name, e.g. `Backend`
   id `10001` and `backend` id `10005`; see BC-8.4.005), `jr` does NOT pick one id and does
   NOT error. It UNIONS every id sharing that case-insensitive name into the SAME `in (...)`
   list this Postcondition already builds. Concretely: after `partial_match` reports
   `ExactMultiple(matched_name)`, the resolver re-scans the ALREADY-FETCHED project component
   list (the same `Vec<Component>` `partial_match`'s candidate names were drawn from — no
   second HTTP call) for every entry whose `name.to_lowercase() == matched_name.to_lowercase()`,
   and contributes ALL of their ids — not just the first — to this `--component` value's slot
   in the `in (...)` list. A single `--component NAME` that resolves to ExactMultiple therefore
   contributes MULTIPLE ids from ONE CLI occurrence (contrast the ordinary case, where one
   occurrence contributes exactly one id). Within one value's contributed ids, order is
   ASCENDING NUMERIC by id (ids are parsed as integers for comparison; this is independent of,
   and does not disturb, the across-values input-order preservation this Postcondition already
   specifies — ascending-by-id applies ONLY to sort the ids contributed by a single
   ExactMultiple value, since `partial_match`/the resolver has no other stable ordering signal
   for same-named duplicates per BC-8.4.005's confidence rationale). This is a DELIBERATE
   divergence from the mutating-path disposition for the identical `MatchResult::ExactMultiple`
   (`component edit`/`delete`/`--move-to` fail closed, exit 64 — BC-8.1.008 branch (0)): see
   BC-2.1.022's "ExactMultiple read-path disposition" subsection for the full rationale.
**Edge Cases**:
- EC-2.1.018-1: Single `--component Backend` → `component in (10001)` (a one-element `IN`
  list is valid JQL, not rewritten to `component = 10001`).
- EC-2.1.018-2 **[NEW 2026-08-15, M3 fix-burst]**: `--component Backend --component
  not:Frontend` → composes `component in (10001) AND (component not in (10002) OR component
  is EMPTY)` (two clauses, bare first, AND-joined at the top-level JQL by the normal
  `build_filter_clauses` mechanism); exit 0.
- EC-2.1.018-3 **[NEW 2026-08-15, F5-A-M1/F5-C-001 fix]**: Project ENG has `Backend` (id
  `10001`) and `backend` (id `10005`) — a case-only duplicate pair. `--component Backend` →
  `partial_match` returns `ExactMultiple("Backend")` → per Postcondition 3, `jr` unions BOTH
  ids: `component in (10001, 10005)`; exit 0. This is a SUPERSET filter (returns issues
  carrying EITHER duplicate) — the deliberately safe choice for a read-only filter, since
  the two entries are indistinguishable by name to the user typing `--component Backend`.
  `--component Backend --component Frontend` where `Frontend` resolves to a single id
  `10002` (no duplicate) → `component in (10001, 10005, 10002)` — the ExactMultiple value's
  two ids are contiguous within their own slot; the ordinary single-id value's contribution is
  unaffected by ExactMultiple handling elsewhere in the list.
**Verification Properties**:
- VP-COMPONENT-015: Repeated `--component <NAME>` composes `component in (id1, id2, …)` in
  input order (single clause, not one clause per value); a bare-list and a `not:`-list MAY
  coexist in one invocation, emitting two AND-joined clauses in bare-then-not: order
  (EC-2.1.018-2).
- VP-COMPONENT-022 **[NEW 2026-08-15, F5-A-M1/F5-C-001 fix]**: A wiremock fixture with two
  same-project components differing only by case (`Backend`/10001, `backend`/10005) —
  `--component Backend` composes `component in (10001, 10005)` (both ids present, ascending
  numeric order), never a single-id clause and never an exit-64 error; the project component-
  list GET fires exactly once (no second HTTP call to re-derive the duplicate set).
**Trace**: F1 delta analysis §2; BC-2.1.011 (structural resolve-before-compose precedent);
BC-8.4.001 (resolver); BC-8.4.005 (ExactMultiple definition); BC-X.10.003 (`MatchResult::
ExactMultiple` primitive); BC-2.1.022 (read-vs-mutating divergence documentation);
F5 adversarial review findings F5-A-M1/F5-C-001 (2026-08-17, human-adjudicated: UNION)

---

#### BC-2.1.019: `--component not:<NAME>` → `(component not in (id) OR component is EMPTY)`

**Confidence**: HIGH
**Source**: F1 delta analysis §validated API facts ("JQL `not in`/`!=` exclude EMPTY, so
`not:` MUST emit the OR-EMPTY form"); `src/cli/issue/list.rs` (pending F4)
**Subject**: Issue read — `--component` filter (issue #606)
**Behavior**: A bare `component not in (id)` clause would silently EXCLUDE issues that have
NO component at all — a well-documented JQL surprise (Jira's `NOT IN`/`!=` operators do not
match `EMPTY` values). To give `not:` its intuitive meaning ("show me issues NOT tagged with
this component" — which should include untagged issues), `jr` composes the parenthesized
OR-form: `(component not in (<id>) OR component is EMPTY)`. Multiple `not:` values combine
within the SAME parenthesized group: `(component not in (id1, id2) OR component is EMPTY)` —
NOT a separate OR-EMPTY clause per value.
**Postconditions**:
1. The emitted clause is ALWAYS the full parenthesized `(component not in (...) OR component
   is EMPTY)` form — `jr` never emits a bare `component not in (...)` for `not:` input.
2. **[NEW 2026-08-15, M3 fix-burst]** `not:` values MAY coexist with bare `--component <NAME>`
   values in the same invocation — see BC-2.1.018 Precondition 3/Postcondition 2 for the
   defined composition (bare clause first, `not:` clause second, both AND-joined). `not:`
   coexistence with `none`/`all:` remains rejected (BC-2.1.020/BC-2.1.021).
3. **[NEW 2026-08-15, F5-A-M1/F5-C-001 fix — human-adjudicated: UNION]** When a single
   `--component not:<NAME>` value resolves to `MatchResult::ExactMultiple` (BC-X.10.003; see
   BC-8.4.005), the SAME UNION rule BC-2.1.018 Postcondition 3 specifies for the bare form
   applies here: ALL ids sharing that case-insensitive name (re-scanned from the already-
   fetched candidate list, zero extra HTTP) are unioned into the `not:` group's `not in
   (id1, id2, ...)` list — the group still emits its single, always-parenthesized
   `(component not in (...) OR component is EMPTY)` form (Postcondition 1 is unchanged; only
   the population of `not in (...)`'s id list gains the ExactMultiple union). Ids contributed
   by one ExactMultiple `not:` value are ordered ascending numeric within their own slot,
   identical to BC-2.1.018 Postcondition 3's rule. Rationale for UNION here specifically (as
   opposed to picking one duplicate to exclude): excluding only ONE of the two same-named
   duplicates would leave issues tagged with the OTHER duplicate incorrectly matching the
   filter — a silent-incorrect exclusion, the exact class of bug this whole amendment closes
   for the read path. Unioning both into the exclusion set makes `not:Backend` mean "excludes
   every component a user would call Backend," which is the intuitive reading `not:` already
   promises for the untagged/EMPTY case (Behavior above).
**Edge Cases**:
- EC-2.1.019-1: `--component not:Backend --component not:Frontend` → single clause
  `(component not in (10001, 10002) OR component is EMPTY)`, not two separate clauses.
- EC-2.1.019-2 **[NEW 2026-08-15, M3 fix-burst]**: `--component Backend --component
  not:Frontend` (bare + `not:` mixed) → BOTH clauses compose, per BC-2.1.018 Postcondition 2:
  `component in (10001) AND (component not in (10002) OR component is EMPTY)`. This is NOT
  rejected — contrast `all:`/`none`, which DO reject mixing with any other `--component`
  value.
- EC-2.1.019-3 **[NEW 2026-08-15, P6 fix-burst — documents a reserved-syntax collision found
  by adversarial spec-delta review pass 6, LOW-1]**: a component literally NAMED `not:Deprecated`
  is UNREACHABLE via `--component not:Deprecated` — the leading `not:` prefix is always
  interpreted as the reserved negation syntax (Behavior above) and the remainder is resolved as
  the NAME to negate, never as a literal name containing a colon. This is the SAME class of gap
  documented for `none` (EC-2.1.020-4) and `all:` (EC-2.1.021-3) — symmetric shape, different
  trigger (a reserved prefix vs. a reserved keyword vs. a reserved separator). **Workaround**:
  filter on the component's numeric id via the raw JQL escape hatch: `jr issue list --jql
  "component = <id>"` (look up the id via `jr component list --output json | jq`). There is no
  `--component`-flag workaround, since the `not:` prefix is unconditionally reserved.
- EC-2.1.019-4 **[NEW 2026-08-15, F5-A-M1/F5-C-001 fix]**: Project ENG has `Backend` (id
  `10001`) and `backend` (id `10005`). `--component not:Backend` → `partial_match` returns
  `ExactMultiple("Backend")` → per Postcondition 3, `jr` unions both ids into the exclusion
  set: `(component not in (10001, 10005) OR component is EMPTY)`; exit 0. An issue carrying
  ONLY `backend` (id 10005) is correctly excluded by this clause — under a hypothetical
  first-pick-only disposition it would have incorrectly matched (the exact silent-incomplete
  defect class this fix-round closes, mirrored onto the negated form).
**Verification Properties**:
- VP-COMPONENT-015: `not:` composes the single, always-parenthesized `(component not in (…)
  OR component is EMPTY)` group — multiple `not:` values combine within the SAME group, never
  one OR-EMPTY clause per value; a `not:`-list MAY coexist with a bare-list in one invocation
  (EC-2.1.019-2).
- VP-COMPONENT-022: (see BC-2.1.018) also covers the `not:` form — a same-project case-only
  duplicate pair resolved via `--component not:<NAME>` unions both ids into the `not in (...)`
  list (EC-2.1.019-4), with the group's OR-EMPTY form unaffected.
**Trace**: F1 delta analysis §Validated API facts; BC-8.4.005 (ExactMultiple definition);
BC-2.1.018 Postcondition 3 (shared UNION rule); F5 adversarial review findings
F5-A-M1/F5-C-001 (2026-08-17, human-adjudicated: UNION)

---

#### BC-2.1.020: `--component none` → `component is EMPTY`

**Confidence**: HIGH
**Source**: F1 delta analysis §2 (BA note: "the real payoff of #606"); `src/cli/issue/list.rs`
(pending F4)
**Subject**: Issue read — `--component` filter (issue #606)
**Behavior**: The literal value `none` (case-insensitive: `none`/`None`/`NONE`) is a RESERVED
keyword meaning "issues with zero components" — it composes `component is EMPTY` directly,
with NO name-resolution round-trip (unlike every other `--component` value, `none` never
consults the project component list or §8.4). `--component none` combined with other
`--component` values (bare OR `not:`/`all:`) in the SAME invocation is rejected: exit 64
pre-flight, `"--component none cannot be combined with other --component values."` — `none`
is a complete, standalone filter statement; combining it with an OR-list or an AND-list would
be either redundant or contradictory in every case, so `jr` rejects rather than silently
picking one interpretation.
**Preconditions**:
1. `--component none` is the ONLY `--component` occurrence in the invocation.
2. **[NEW 2026-08-15, M2 fix-burst]** Like every other `--component` value, `none` requires a
   resolved project scope — the same `--project` flag > `.jr.toml` configured-project
   precedence as `list`'s other project-scoped operations (BC-2.1.001 family). Unlike bare/
   `not:`/`all:` (whose §8.4 resolver GET against `/project/{key}/components` fails
   structurally without a project key, so those forms are naturally project-gated by their
   own resolution step), `none` skips resolution entirely (Postcondition 1) and could
   otherwise compose an UNSCOPED `component is EMPTY` clause with no `project = X`
   restriction — an accidental org-wide search across every project the caller can see. This
   precondition exists specifically to prevent that: see BC-2.1.022 EC-2.1.022-2 for the
   exit-64 behavior when no project scope is available.
**Postconditions**:
1. `component is EMPTY` is composed with ZERO resolver HTTP calls (no project component-list
   GET fires for `none` specifically) — but ONLY once Precondition 2's project-scope
   requirement is satisfied; see BC-2.1.022 EC-2.1.022-2 for the no-project-scope failure
   path.
**Edge Cases**:
- EC-2.1.020-1: `--component none --component Backend` (combined with a bare value) → exit 64
  pre-flight, zero HTTP.
- EC-2.1.020-2: `--component none --component not:Backend` → exit 64 pre-flight (same
  combination guard — `none` rejects ANY other `--component` occurrence, regardless of that
  occurrence's own prefix).
- EC-2.1.020-3 **[NEW 2026-08-15, M2 fix-burst]**: `jr issue list --component none` with no
  `--project` and no configured default project → exit 64 pre-flight, zero HTTP (see
  BC-2.1.022 EC-2.1.022-2 for the exact message and rationale). `none` is NOT exempt from
  project-scoping just because it skips name resolution.
- EC-2.1.020-4 **[NEW 2026-08-15, L1 fix-burst — documents a reserved-keyword collision found
  by adversarial spec-delta review pass 2]**: a component literally NAMED `"none"` (or any
  case variant: `"None"`, `"NONE"`) is UNREACHABLE via `--component none` — the reserved
  keyword (Precondition 1/Postcondition 1) always short-circuits to `component is EMPTY` and
  never reaches §8.4 name resolution, so there is no code path by which a literal component
  named `"none"` could ever be selected through this positional. This is the SAME class of gap
  CLAUDE.md already documents for `jr requesttype fields <NAME|ID>`'s numeric-bypass ("100" is
  unreachable by name) — symmetric shape, different trigger (a reserved keyword vs. an
  all-digit string). **Workaround**: filter on the component's numeric id instead, via the raw
  JQL escape hatch already available on `issue list`: `jr issue list --jql "component = <id>"`
  (look up the id via `jr component list --output json | jq`). There is no `--component`-flag
  workaround, since the flag's `none` value is unconditionally reserved.
**Verification Properties**:
- VP-COMPONENT-015: `none` composes `component is EMPTY` with zero resolver HTTP, PROVIDED a
  project scope is available (Precondition 2); the `none`+any-other-value combination guard
  is exit-64 pre-flight (no HTTP); `none` with no project scope at all is ALSO exit-64
  pre-flight (EC-2.1.020-3 / BC-2.1.022 EC-2.1.022-2), never an unscoped org-wide search.
**Trace**: F1 delta analysis §2

---

#### BC-2.1.021: `--component all:<NAME1>,<NAME2>` → AND-combined `component = id1 AND component = id2`

**Confidence**: HIGH
**Source**: F1 delta analysis §2 (BA note: distinct JQL shape from the OR-list form, since
Jira issues can carry multiple components); `src/cli/issue/list.rs` (pending F4)
**Subject**: Issue read — `--component` filter (issue #606)
**Behavior**: `all:<NAME1>,<NAME2>,...` (comma-separated names after the `all:` prefix, ONE
`--component all:...` occurrence) requires an issue to carry EVERY listed component
simultaneously — this needs `AND`, not `IN`, because `component in (...)` is inherently an
OR/any-of test. Each comma-separated name resolves independently via §8.4 (same project
scope, same failure handling as BC-2.1.018) before composition. The composed clause is
`component = <id1> AND component = <id2> AND ...` (repeated equality, AND-joined — NOT
`component in (...) AND` anything, since Jira has no native "array contains all of" JQL
operator for a multi-valued field; repeated equality on the same field is the correct JQL
idiom for "has both X and Y" per Jira's documented multi-select field semantics).
`--component all:X` (a SINGLE name after `all:`, no comma) degenerates to a one-term AND —
`component = id1` — functionally identical to `--component X` (BC-2.1.018 with one value)
but composed via a DIFFERENT code path; both are valid, equivalent JQL.
**Preconditions**:
1. At most ONE `--component all:...` occurrence per invocation (repeating `all:` — e.g.
   `--component all:X --component all:Y` — is rejected: exit 64, `"--component all: may only
   be specified once; comma-separate multiple names within one all: value."`).
2. `all:` is NOT combined with bare/`not:`/`none` `--component` values in the same invocation
   (mirrors BC-2.1.020's `none` isolation guard — mixing AND-semantics with OR/negation
   semantics in one filter dimension is rejected rather than given an implicit precedence).
**Postconditions**:
1. The composed clause is `component = <id1> AND component = <id2> AND ...`, resolved names
   in the CLI-supplied comma-separated order.
2. **[NEW 2026-08-15, F5-A-M1/F5-C-001 fix — human-adjudicated: UNION]** Each comma-separated
   NAME within the `all:` list resolves INDEPENDENTLY (Behavior above). When one of those
   names resolves to `MatchResult::ExactMultiple` (BC-X.10.003; see BC-8.4.005 — 2+ same-
   project components share that case-insensitive name), that name's term in the AND-chain is
   NOT a bare `component = id` equality — it becomes a PARENTHESIZED OR-of-equalities group
   covering every id sharing the name: `(component = id1 OR component = id2)`. This group is
   then AND-joined with the other `all:` names' terms exactly as an ordinary single-id term
   would be. This is the precise, general composition rule: for name `N` at position `i` in
   the comma-separated list, resolving to id set `{id_a, id_b, ...}` —
   - `{id_a}` (ordinary, single id) → the term is `component = id_a` (unchanged from
     Postcondition 1, unparenthesized).
   - `{id_a, id_b, ...}` (ExactMultiple, 2+ ids) → the term is `(component = id_a OR
     component = id_b OR ...)`, ids in ascending numeric order within the group, the WHOLE
     parenthesized group standing in for that one name's position in the AND-chain.
   The overall clause is therefore `<term_1> AND <term_2> AND ...` in comma-supplied order,
   where each `<term_i>` is independently either a bare equality or a parenthesized OR-group
   per the id-set size resolved for that position — never a mix of AND and un-parenthesized OR
   at the same nesting level (JQL precedence would otherwise misgroup an unparenthesized
   `component = id1 OR component = id2 AND component = id3` chain). Semantically this
   preserves the `all:` contract's promise — "the issue must carry EVERY listed component" —
   because an issue satisfies `(component = id_a OR component = id_b)` if it carries EITHER
   same-named duplicate, and `all:` only requires that the issue carry SOME component matching
   each listed NAME, not a specific duplicate's id (the user cannot distinguish `id_a` from
   `id_b` by name in the first place).
**Edge Cases**:
- EC-2.1.021-1: `--component all:Backend,Frontend` → `component = 10001 AND component =
  10002` (two-term AND).
- EC-2.1.021-2: `--component all:Backend --component Frontend` (mixing `all:` with a bare
  value) → exit 64 pre-flight (Precondition 2), zero HTTP.
- EC-2.1.021-3 **[NEW 2026-08-15, P6 fix-burst — documents reserved-syntax collisions found by
  adversarial spec-delta review pass 6, LOW-1]**: two distinct collisions, symmetric with
  `none`'s documented gap (EC-2.1.020-4) and `not:`'s (EC-2.1.019-3): (a) a component literally
  NAMED `all:Backend` is UNREACHABLE via `--component all:Backend` — the leading `all:` prefix
  is always interpreted as the reserved AND-list syntax (Behavior above), never as a literal
  name containing a colon; (b) a component whose NAME itself contains a comma (e.g.
  `"Backend, Legacy"`) is UNREACHABLE within an `all:` list — the comma-separated parser
  (Behavior above) always splits on every comma in the `all:` value, so such a name is silently
  misinterpreted as two separate names to resolve rather than one name containing a comma, and
  either fails to resolve (exit 64, not-found) or — in the unlikely case both split fragments
  happen to independently resolve to real components — silently composes the WRONG AND-clause.
  **Workaround (both cases)**: filter on the component's numeric id via the raw JQL escape
  hatch: `jr issue list --jql "component = <id>"` (look up the id via `jr component list
  --output json | jq`). There is no `--component`-flag workaround for either collision, since
  the `all:` prefix and the comma separator are both unconditionally reserved.
- EC-2.1.021-4 **[NEW 2026-08-15, F5-A-M1/F5-C-001 fix]**: Project ENG has `Backend` (id
  `10001`), `backend` (id `10005`), and `Frontend` (id `10002`, no duplicate).
  `--component all:Backend,Frontend` → `Backend` resolves `ExactMultiple` (two ids),
  `Frontend` resolves `Exact` (one id) → per Postcondition 2: `(component = 10001 OR
  component = 10005) AND component = 10002`; exit 0. An issue carrying `backend` (10005) and
  `Frontend` (10002) — but NOT the `Backend` (10001) spelling — correctly satisfies this
  clause (it has SOME component the user would call "Backend", plus "Frontend"), matching the
  `all:` contract's name-level (not id-level) promise.
**Verification Properties**:
- VP-COMPONENT-015: `all:` composes `component = id1 AND component = id2 …` (AND-joined, not
  `IN`); the repeated-`all:` and `all:`+bare/`not:`/`none` combination guards are exit-64
  pre-flight (no HTTP).
- VP-COMPONENT-022: (see BC-2.1.018) also covers the `all:` form — a same-project case-only
  duplicate pair named within an `all:` list contributes a parenthesized `(component = id_a OR
  component = id_b)` term at that position, AND-joined with the list's other terms
  (EC-2.1.021-4), never a bare single-id equality and never an exit-64 error solely because of
  the duplicate.
**Trace**: F1 delta analysis §2; BC-8.4.005 (ExactMultiple definition); BC-2.1.018
Postcondition 3 (sibling UNION rule, `in (...)` form); F5 adversarial review findings
F5-A-M1/F5-C-001 (2026-08-17, human-adjudicated: UNION)

---

#### BC-2.1.022: Unresolvable or ambiguous `--component` name → exit 64 BEFORE any JQL search fires, listing valid names or candidates for the resolved project scope

**Confidence**: HIGH
**Source**: Precedent BC-2.1.012 (asset ambiguity, no issue search fired), BC-2.1.014
(status NOMATCH listing pattern); §8.4 resolver contracts (BC-8.4.002/003);
`src/cli/issue/list.rs` (pending F4)
**Subject**: Issue read — `--component` filter (issue #606)
**Behavior**: Any `--component` value that is NOT the reserved `none` keyword resolves via
§8.4 BEFORE JQL composition. Zero matches (BC-8.4.002) → exit 64, `"Component '<input>' not
found in project <key>. Available: <comma-joined alphabetical list>."` — mirrors BC-2.1.014's
shape exactly. 2+ matches (BC-8.4.003) → exit 64, `"Ambiguous component '<input>'. Matches:
<candidates>."` — mirrors BC-2.1.013's shape exactly. In BOTH cases, `POST /rest/api/3/
search/jql` is NEVER called — the resolution failure short-circuits before the issue search
fires, matching BC-2.1.012's "no issue search fired" invariant for the analogous asset case.
**Edge Cases** **[NEW 2026-08-15, M2 fix-burst]**:
- EC-2.1.022-1: `--component <NAME>` (bare/`not:`/`all:`) with no `--project` and no
  configured default project → the project-scoped §8.4 resolver GET
  (`/rest/api/3/project/{key}/components`) has no project key to target. `jr` exits 64
  pre-flight BEFORE attempting the call, naming `--project` (same "no default scope" posture
  as BC-2.1.006), rather than issuing a malformed request or guessing a project.
- EC-2.1.022-2: `--component none` with no `--project` and no configured default project →
  despite requiring zero resolver HTTP (BC-2.1.020 Postcondition 1), `none` is NOT exempt
  from the project-scope requirement (BC-2.1.020 Precondition 2): `jr` exits 64 pre-flight,
  `"--component none requires --project (or a configured default project) to avoid an
  unrestricted org-wide search."` This prevents `component is EMPTY` from ever composing as
  an unscoped, unbounded cross-project JQL clause. `POST /rest/api/3/search/jql` is never
  called.
- EC-2.1.022-3 **[NEW 2026-08-17, F5-A-M1/F5-C-001 fix — human-adjudicated: UNION]**: `--component
  <NAME>` (bare, `not:`, or a name inside an `all:` list) resolves to `MatchResult::
  ExactMultiple` (2+ same-project components sharing the case-insensitive name) → this is
  explicitly **NOT** a member of this BC's "unresolvable or ambiguous" family and does **NOT**
  exit 64. See the "ExactMultiple read-path disposition" subsection immediately below for the
  full contract (owned by BC-2.1.018 Postcondition 3, BC-2.1.019 Postcondition 3, and
  BC-2.1.021 Postcondition 2 respectively) — it is cross-referenced here only so a reader
  scanning this BC's error/exit-64 enumeration does not mistake ExactMultiple for a fourth
  failure mode alongside zero-match and ambiguous-substring.

### ExactMultiple read-path disposition (UNION, exit 0) — divergence from the mutating path

**[NEW 2026-08-17, F5-A-M1/F5-C-001 fix — human-adjudicated: UNION]**

**The defect this resolves**: prior to this fix, `--component <NAME>` resolving to
`MatchResult::ExactMultiple` (BC-X.10.003 — 2+ components in the resolved project share the
same case-insensitive name, e.g. `Backend` id `10001` and `backend` id `10005`; see
BC-8.4.005) was underspecified for `issue list --component` specifically. Naively reusing
`partial_match`'s own first-match-wins return value (`ExactMultiple(String)` carries only the
FIRST matching name, not the full duplicate id set — see `src/partial_match.rs`) would compose
a single-id clause (e.g. `component in (10001)` only), silently EXCLUDING issues tagged with
the other duplicate (`backend`/10005) from the result set — a silent-incomplete filter with no
error, no warning, and no indication to the user that a second component shared the name they
typed. This is the class of bug flagged by adversarial review findings **F5-A-M1** and
**F5-C-001**.

**Disposition (human-adjudicated 2026-08-17): UNION.** On every read-path `--component`
resolution path — bare (BC-2.1.018 Postcondition 3), `not:` (BC-2.1.019 Postcondition 3), and
each name within an `all:` list (BC-2.1.021 Postcondition 2) — `MatchResult::ExactMultiple` is
resolved by re-scanning the ALREADY-FETCHED project component list (zero additional HTTP) for
every entry whose name matches case-insensitively, and folding ALL of their ids into that
value's contribution to the composed JQL clause. The result is exit 0, a normal (superset)
search, and no user-visible error — the query becomes "any component a reasonable person would
call `<NAME>`," which is the safe, non-lossy reading for a FILTER (a read never destroys data
by matching a superset of intended issues; at worst it shows the user one extra duplicate
component's issues, which is self-evidently correct once the two same-named components are
understood to exist).

**Why this correctly diverges from the mutating path.** `component edit`/`delete`/
`--move-to`'s `NAME|ID` positional resolving to the SAME `MatchResult::ExactMultiple` FAILS
CLOSED instead: BC-8.1.008 branch (0) routes it to BC-8.4.003's ambiguity handling — exit 64,
zero mutating HTTP, requiring the numeric id (`jr component edit 10001 …` / `jr component edit
10005 …`) to disambiguate. The two dispositions are not in tension; they are the correct
answer to two different questions with different safety profiles:
- **A read/filter (`issue list --component`) asks "which issues match?"** Unioning both
  duplicate ids answers this SAFELY — the operation is idempotent, non-destructive, and a
  superset result is a correct (if slightly broader than the user may have anticipated)
  answer. There is no safe way to "fail closed" on a filter without reintroducing the
  original silent-drop defect (dropping the filter, or exiting 64 and blocking the whole `jr
  issue list` invocation, would be strictly WORSE UX than showing a superset).
- **A mutation (`edit`/`delete`/`--move-to`) asks "which ONE component do I change/delete/move
  issues off of?"** This question has no safe superset answer — guessing which of `10001`/
  `10005` the user meant and silently modifying (or deleting) the WRONG one is a data-loss-
  adjacent, non-reversible mistake (component delete in particular can move or orphan issues
  irrecoverably — see §8.2). Requiring the numeric id is the only sound resolution; there is
  no "union the mutation" analogue.
This mirrors the general shape of `jr`'s error-taxonomy default for `ExactMultiple`
(`error-taxonomy.md` §5: "No error — use any (or first)") being narrowed to fail-closed by
specific mutating callers with irreversible consequences — the SAME pattern already
established for `jr requesttype fields`/`jr queue view` (both exit 64 on ExactMultiple,
cross-cutting.md BC-X.10.003 callers) versus `--status <ExactMultiple>` (BC-2.1.015, a
read-only list filter, which auto-resolves without erroring). `issue list --component`'s
UNION disposition is a THIRD point on this spectrum, distinct from both precedents: BC-2.1.015
auto-resolves to a SINGLE status (Jira issues carry exactly one status, so "pick one" and
"union" coincide for a single-valued field); `--component` cannot coincide the same way
because an issue can legitimately carry multiple components, so "pick one" and "union" are
OBSERVABLY DIFFERENT result sets here, and the F5 finding is precisely that the single-pick
choice was silently wrong. UNION, not "treat as Exact," is therefore the correct generalization
of BC-2.1.015's read-path leniency for a filter over a multi-valued field.

**Cross-reference**: BC-8.4.005 (the resolver's case-insensitive `ExactMultiple` definition,
now amended to state both dispositions explicitly rather than leaving caller behavior
implicit); BC-8.1.008 branch (0) (the mutating-path fail-closed disposition this subsection
contrasts against).

**Verification Properties**:
- VP-COMPONENT-013: Unresolvable/ambiguous `--component` value (bare, `not:`, or within an
  `all:` list) → `POST /rest/api/3/search/jql` is never called (`.expect(0)`), mirroring
  BC-2.1.012's `.expect(0)` pattern for `--asset`. **[CLARIFIED 2026-08-17]** `ExactMultiple`
  is explicitly OUT of this VP's scope (EC-2.1.022-3) — it is a superset-search success case,
  not a zero-match/ambiguous failure case; `POST /rest/api/3/search/jql` DOES fire for an
  ExactMultiple resolution, exactly as it would for any other successful `--component`
  resolution.
- VP-COMPONENT-022: (see BC-2.1.018) is the canonical UNION verification property covering all
  three read-path forms (bare/`not:`/`all:`); this BC's role is the explicit non-membership
  statement (EC-2.1.022-3) plus the read-vs-mutating divergence documentation above.
**Trace**: BC-2.1.012; BC-2.1.013; BC-2.1.014; BC-8.4.002; BC-8.4.003; BC-8.4.005 (ExactMultiple
definition, amended); BC-8.1.008 branch (0) (mutating-path fail-closed contrast); BC-2.1.018
Postcondition 3, BC-2.1.019 Postcondition 3, BC-2.1.021 Postcondition 2 (the three read-path
UNION implementations this subsection documents the shared rationale for); F5 adversarial
review findings F5-A-M1/F5-C-001 (2026-08-17, human-adjudicated: UNION)

---

### 2.2 Issue List Behavior

#### BC-2.2.018: `--all` passes `maxResults=50`; default passes `maxResults=30`

**Confidence**: HIGH
**Source**: `tests/all_flag_behavior.rs:~42-145`
**Subject**: Issue read
**Behavior**: `maxResults=50` for `--all`; `maxResults=30` for default. Pinned by request body match. `src/api/jira/issues.rs:~50`: `max_per_page = limit.unwrap_or(50).min(100)`.
**Trace**: Pass 3 BC-103, BC-141 (R1)

---

#### BC-2.2.019: Truncation triggers second HTTP `POST /rest/api/3/search/approximate-count`

**Confidence**: HIGH
**Source**: `tests/all_flag_behavior.rs:~88-145`; body-match pins `"jql": "(project = CAP)"`
**Subject**: Issue read
**Behavior**: When `--all` NOT set AND results > limit: issues `POST /search/approximate-count` with ORDER BY-stripped JQL. Stderr: `Showing 30 of ~42`. With `--all`: no truncation hint AND no count call.
**Trace**: Pass 3 BC-104, BC-140 (R1)

---

#### BC-2.2.020: `--all` + `--limit N` clap conflict: `cannot be used with`

**Confidence**: HIGH
**Source**: `tests/cli_smoke.rs:~300-307`
**Trace**: Pass 3 BC-142 (R1)

---

#### BC-2.2.021: `--points` with no story_points_field_id → silently ignored, stderr warning

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~756-770`
**Subject**: Issue read
**Behavior**: stderr: `"warning: --points ignored. Story points field not configured. Run "jr init" or set story_points_field_id under [profiles.<name>] in ~/.config/jr/config.toml"`. Non-fatal; list proceeds without points column. Note: message must reference `[profiles.<name>]` not the deprecated `[fields]` section.
**Related**: BC-6.3.001 (multi-profile fields MUST-FIX); the error message text updated here is one of the pinned-text changes required by that fix.
**Trace**: Pass 3 BC-143 (R1)

---

#### BC-2.2.022: `--points` with configured field → pushes `customfield_NNNNN` onto request `extra` fields list

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~147-149, 656-668`
**Trace**: Pass 3 BC-144 (R1)

---

#### BC-2.2.023: Asset enrichment deduplicates by `(workspace_id, object_id)` before per-asset GETs

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~397-411`
**Subject**: Issue read
**Behavior**: `to_enrich: HashMap<(String, String), ()>` collects unique workspace/object pairs. Per-asset GETs issued once per unique key via `join_all` (concurrent). Mitigates partial N+1.
**Trace**: Pass 3 BC-147 (R1)

---

#### BC-2.2.024: board_id 404 → exit 64 with `Board 42 not found or not accessible` + board_id hint + `--jql` hint

**Confidence**: HIGH
**Source**: `tests/issue_list_errors.rs:~21-76`
**Error taxonomy**: `JrError::UserError`.
**Trace**: Pass 3 BC-106

---

#### BC-2.2.025: board config 5xx → exit 1 with `Failed to fetch config for board 42` + `--jql` hint

**Confidence**: HIGH
**Source**: `tests/issue_list_errors.rs:~78-130`
**Trace**: Pass 3 BC-107

---

#### BC-2.2.026: Sprint list 5xx → exit 1 with `Failed to list sprints for board 42` + `--jql` hint

**Confidence**: HIGH
**Source**: `tests/issue_list_errors.rs:~132-194`
**Trace**: Pass 3 BC-108

---

#### BC-2.2.027: No active sprint → falls back to project-scoped JQL without error

**Confidence**: HIGH
**Source**: `tests/issue_list_errors.rs:~196-263`
**Subject**: Issue read
**Behavior**: Empty `state=active` sprint list → falls back to `project = PROJ` JQL. No error, no warning (silent degrade per state machine §2.5 of Pass 8 synthesis).
**Trace**: Pass 3 BC-109

---

#### BC-2.2.028: `search_issues` default fields list: 17 fields in EXACT order

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~967-1022`
**Subject**: Issue read
**Behavior**: `summary, status, issuetype, priority, assignee, reporter, project, description, created, updated, duedate, resolution, components, fixVersions, labels, parent, issuelinks`. Body partial-JSON match asserts EXACT array.

> **[AMENDED 2026-08-13 F2 issue #668]** Field count changed 16 → 17: `duedate` added to `BASE_ISSUE_FIELDS` (`src/api/jira/issues.rs`), positioned immediately after `updated` and before `resolution` — grouped with the other two date-bearing fields (`created`, `updated`). `BASE_ISSUE_FIELDS` is the single shared field-request constant consumed by BOTH `search_issues` (this BC) and `get_issue` (BC-2.3.036), so one array edit satisfies both contracts simultaneously. Prior 16-field array (superseded): `summary, status, issuetype, priority, assignee, reporter, project, description, created, updated, resolution, components, fixVersions, labels, parent, issuelinks`. Source test `tests/issue_commands.rs::test_search_issues_includes_labels_parent_issuelinks` (exact-array `body_partial_json` assertion) MUST be updated in lockstep with the array literal in F4 — this is a MANDATORY test update (array-length mismatch otherwise), not merely at-risk, per F1 delta analysis (`.factory/feature-delta/668-duedate/delta-analysis.md`).

**Trace**: Pass 3 BC-1063 (R4); F2 issue #668 (2026-08-13) — `duedate` field added

---

#### BC-2.2.029: `search_issues` with cursor continuation token sets `has_more = true`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~264-310`
**Trace**: Pass 3 BC-1047, BC-1048 (R4)

---

#### BC-2.2.030: `search_issues` JQL body includes literal composed string with double-quoted project key

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~492-524`
**Behavior**: `project = "PROJ" AND (priority = Highest) ORDER BY updated DESC` pinned by body partial-match.
**Trace**: Pass 3 BC-1052 (R4)

---

#### BC-2.2.031: `client.approximate_count(jql)` POSTs to `/rest/api/3/search/approximate-count`; 5xx propagates as Err

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~337-386`
**Behavior**: Returns `u64`. Zero and 42 boundary cases tested. Server error → Err.
**Trace**: Pass 3 BC-1050 (R4)

---

#### BC-2.2.032: `issue list --duedate` opts in a Due Date column (`YYYY-MM-DD`, `-` when unset)

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs::handle_list`; `src/cli/issue/format.rs::format_issue_row`/`issue_table_headers` (implementation pending F4 — issue #668)
**Subject**: Issue read
**Behavior**: New CLI flag `--duedate` (boolean, default off) on `jr issue list`, an opt-in column following the SAME code mechanism `format_issue_row`/`issue_table_headers` already use for the Points column: a new optional parameter, gated on the flag, added to the row-builder and header-builder col-count logic. This is the same mechanism the Points column uses (config-gated via `sp_field_id: Option<&str>`), NOT the same CONTRACT — BC-2.2.021/BC-2.2.022 contract the `--points` flag's config-resolution and request-field-injection behavior, not the column-rendering consequence itself; no existing BC states "an opt-in flag renders an optional table column" as its own contract. **This BC is the first to state that column-rendering consequence explicitly** (closing part of the gap named in the Column-set backfill note below). Due Date is explicitly NOT an always-on column (contrast with `issue view`'s always-on Due Date row, BC-2.3.039). When `--duedate` is set, the table gains a "Due Date" column populated from `IssueFields.duedate` (BC-2.3.036); when absent, the column is omitted entirely.

**Scope — `issue list` only**: `format_issue_row` and `issue_table_headers` have OTHER call sites beyond `list.rs::handle_list` — `board.rs::handle_view`, `queue.rs::handle_view` (twice), and `sprint.rs::handle_current` all call one or both functions (`src/cli/issue/format.rs` is a shared module). This BC governs the `issue list` column set ONLY. `board view`/`queue view`/`sprint current` do NOT gain a `--duedate` flag or a Due Date column under this BC; their call sites pass the new Due Date parameter as absent/`None`/`false`, matching how they already pass `None`/`false` for Points/Team/Assets today. A call site the implementer forgets to update is a compile error (new required parameter on a shared function), not a silent bug. `cross-cutting.md`'s BC-X.8.009 (`jr queue view`) is cross-referenced separately (see its own amendment) since its body makes an explicit "same column set as `jr issue list`" claim that this BC's addition falsifies unless BC-X.8.009 is also corrected.

**Column position**: `Key, Type, Status, Priority, [Due Date], [Points], Assignee, [Team], [Assets], Summary` — Due Date is inserted immediately after Priority and before Points. Rationale: Due Date and Priority are both triage-relevant single-value fields best read together near the front of the row; Team/Assets remain enrichment columns anchored just before Summary (unchanged). This resolves F1 Open Question #2 — implementer MUST follow this exact ordering, not an alternative placement.

**Rendering (SIMPLIFIED, human-directed, 2026-08-13)**: the Due Date column displays `IssueFields.duedate`'s string value **VERBATIM** — no parser, no reformatter, no round-trip. Jira already returns `duedate` as date-only `YYYY-MM-DD`; reformatting it would produce a byte-identical string, so the parse-then-reformat step is pure overhead and is explicitly NOT implemented. This is a deliberate, human-approved simplification of an earlier draft of this BC (which specified a `chrono::NaiveDate::parse_from_str` round-trip formatter with a parse-failure fallback and warning — that machinery is removed; see the fix-round changelog entry for the full rationale). Explicitly NOT `format_comment_date` (the existing `Created`/`Updated` formatter) — that formatter genuinely parses RFC3339 datetime strings and reformats them (`"%Y-%m-%d %H:%M"`); `duedate` requires no such transformation and gets no formatter at all, verbatim string display only.

**Empty rendering**: `-` (single dash) when `IssueFields.duedate` is `None` OR `Some("")` (empty string; Jira itself never emits this — defensive-only, mirroring the EC-2.7.001-3 empty-string-treated-as-absent convention) — matches the `Created`/`Updated`/`Points` convention already used in this exact row-builder family, explicitly NOT the `(none)` convention used for `Reporter`/`Labels` in `issue view`'s detail table. This resolves F1 Open Question #3 for the list-column half. Implementation is a single `is_none_or(str::is_empty)`-style check before emitting the string verbatim — no parser is involved in this check.

**JSON mode**: `--duedate` has NO effect on `issue list --output json`. `duedate` is unconditionally present in the JSON output once BC-2.2.028's field-list amendment lands, regardless of whether `--duedate` was passed — the flag gates ONLY the human table column. `--duedate --output json` is a silent no-op with respect to JSON shape (no warning; not an error — same non-error treatment `--points`/`--assets`/`--team` already receive when combined with `--output json`).

**Relationship to `issue view`'s Due Date row (BC-2.3.039)**: both consume the same `IssueFields.duedate: Option<String>` field and the SAME trivial render-string-or-dash helper — a single shared function, not duplicated per call site, mirroring how `format_comment_date` is already shared between the `Created`/`Updated` rows in `view.rs`. This shared helper is explicitly NOT a parsing formatter (no `chrono` dependency, no date-shape validation) and explicitly NOT `format_comment_date` — it exists solely because two call sites need the identical `None`/empty-string → `-` else-verbatim logic, not because the value needs any transformation.

**Column-set backfill note (F1 Open Question #7 disposition)**: no BC in this file enumerates `issue list`'s full table column set (Key/Type/Status/Priority/[Points]/Assignee/[Team]/[Assets]/Summary) as a contract in its own right — only this BC and the pre-existing row-builder code define it implicitly. **Disposition: DEFERRED, with a normativity caveat.** This BC's Column position clause is, by necessity, now the only WRITTEN contract that states the full ordered column list — it is normative for Due Date's placement within that list, but is NOT a retroactive backfill contract for the pre-existing columns' own behavior (their config/warning semantics remain contracted elsewhere: BC-2.2.021/022 for Points, BC-2.1.016/017 for Assets). A future standalone column-set BC, if written, supersedes this clause's column-list enumeration without needing to touch Due Date's own policy. Tracked as pre-existing spec debt, not a blocker for this feature.

**Trace**: F2 spec evolution (issue #668, 2026-08-13); precedent mechanism BC-2.2.021/BC-2.2.022 (`--points` config/warning contract — mechanism precedent only, see Behavior clause for the contract-scope correction); precedent BC-2.1.016/BC-2.1.017 (`--assets` opt-in column); `.factory/feature-delta/668-duedate/delta-analysis.md` Open Questions #1, #2, #3, #7; adversarial F2 review (2026-08-13) F2/F3/F7/F8/F9/F10 corrections; human-directed simplification fix-round (2026-08-13) — parse/reformat/verbose machinery removed, verbatim-display + shared trivial helper substituted

---

### 2.3 Issue View

#### BC-2.3.032: `issue view <key>` GETs `/rest/api/3/issue/<key>` with `--output json` returning raw JSON

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~33-53`
**Trace**: Pass 3 BC-112

---

#### BC-2.3.033: `issue view` 5xx → exit 1 + `API error (500)` + no panic

**Confidence**: HIGH
**Source**: `tests/issue_view_errors.rs:~18-56`
**Trace**: Pass 3 BC-113; BC-1135a (R4)

---

#### BC-2.3.034: `issue view` 401 → exit 2 + `Not authenticated` + `jr auth login`

**Confidence**: HIGH
**Source**: `tests/issue_view_errors.rs:~58-100`
**Trace**: Pass 3 BC-114; BC-1135b (R4)

---

#### BC-2.3.035: Corrupt `teams.json` cache is non-fatal; UUID + "name not cached" hint shown inline

**Confidence**: HIGH
**Source**: `tests/issue_view_errors.rs:~142-206`
**Subject**: Issue read
**Behavior**: Truncated `teams.json` (`{"teams": [`) → `read_cache` returns `Ok(None)` (parse-fail = cache miss). Issue view exits 0. Team row shows raw UUID + `(name not cached — run 'jr team list --refresh')`. stderr NOT contain `panic`.
**Trace**: Pass 3 BC-115; BC-1135d (R4); Top-30 BC rank #26

---

#### BC-2.3.036: `get_issue` deserializes: created, updated, duedate, reporter, resolution, components, fix_versions (all nullable)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~526-577, 579-607`
**Behavior**: Full fixture: all fields present. Minimal fixture: all return `None` (NOT panic). `created`/`updated` are RFC3339+0000 timestamps; `duedate` is a bare `YYYY-MM-DD` date string with no time component — Jira's wire field name `duedate` matches the Rust field name verbatim (no `#[serde(rename)]` needed). `IssueFields.duedate: Option<String>` is a NAMED struct field (not routed through the `#[serde(flatten)] extra` catch-all map), matching the existing `created`/`updated`/`reporter` precedent established by issue #59 — a named field is required anyway for the human-render path's `issue.fields.duedate.as_deref()` access (BC-2.2.032, BC-2.3.039).

> **[AMENDED 2026-08-13 F2 issue #668]** `duedate` added to the enumerated field set. Prior enumeration (superseded): created, updated, reporter, resolution, components, fix_versions (all nullable). Recommended test extension (not a new BC/VP — ordinary coverage): `tests/issue_commands.rs::get_issue_includes_standard_fields` and `::get_issue_null_standard_fields` should gain `duedate` present/absent assertions mirroring the issue #59 present/absent pair; `tests/common/fixtures.rs::issue_response_with_standard_fields` is the shared fixture extension point.

**Trace**: Pass 3 BC-1053, BC-1054 (R4); F2 issue #668 (2026-08-13) — `duedate` field added

---

#### BC-2.3.037: `get_issue` with parent + links deserializes `fields.parent.key`, `fields.issuelinks[0].link_type.name`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~208-231`
**Trace**: Pass 3 BC-1044 (R4)

---

#### BC-2.3.038: `IssueFields::story_points("customfield_X")` returns None for non-numeric values

**Confidence**: HIGH
**Source**: `src/types/jira/issue.rs:~83-85`
**Trace**: Pass 3 BC-124

---

#### BC-2.3.039: `issue view` always shows a "Due Date" detail row (`YYYY-MM-DD`, `-` when unset)

**Confidence**: HIGH
**Source**: `src/cli/issue/view.rs::handle_view` (Table arm; implementation pending F4 — issue #668)
**Subject**: Issue read
**Behavior**: `jr issue view <key>` (human/table output) ALWAYS renders a "Due Date" row in the detail table — unconditional, like `Created`/`Updated`, NOT opt-in (contrast with the `issue list` column, BC-2.2.032, which IS opt-in via `--duedate`; a single-issue detail view has no width pressure, matching the existing `Created`/`Updated` precedent already in this same `rows` vec). Sourced from `IssueFields.duedate` (BC-2.3.036). **Correction**: an earlier draft of this BC cited `Resolution` as a third always-on-row precedent alongside `Created`/`Updated` — `handle_view` has no Resolution row (`grep -c Resolution src/cli/issue/view.rs` = 0; `resolution` is fetched and deserialized but never rendered in the table). The precedent is `Created`/`Updated` only.

**Row position**: inserted immediately after the `Updated` row and before the `Project` row — grouping the three date-bearing rows (`Created`, `Updated`, `Due Date`) together, mirroring `handle_view`'s existing adjacency of `Created`/`Updated`.

**Rendering (SIMPLIFIED, human-directed, 2026-08-13)**: `IssueFields.duedate`'s string value is displayed **VERBATIM** — no parser, no reformatter. Jira already returns `duedate` as date-only `YYYY-MM-DD`; a parse-then-reformat round-trip would produce a byte-identical string, so it is not implemented (deliberate simplification of an earlier draft of this BC; see the fix-round changelog entry). Uses the SAME shared trivial render-string-or-dash helper introduced by BC-2.2.032 (one function, not duplicated per call site) — explicitly NOT `format_comment_date` (the existing `Created`/`Updated` formatter, which genuinely parses and reformats RFC3339 datetimes) and explicitly NOT a parsing formatter of any kind.

**Empty rendering**: `-` (single dash) when `IssueFields.duedate` is `None` OR `Some("")` (empty string; defensive-only, Jira never emits this — mirrors BC-2.2.032's identical clause) — matches the existing `Created`/`Updated` convention in this exact `rows` vec, explicitly NOT the `(none)` convention used for `Reporter`/`Labels`/`Parent`/`Links` rows in the same table. This resolves F1 Open Question #3 for the detail-view half; combined with BC-2.2.032's independent convergence on `-` for the list-column half, the empty-value convention for Due Date is now uniform across both human-render surfaces.

**JSON output (corrected)**: unaffected by this BC, but NOT because JSON output is "raw passthrough" — `issue view --output json` serializes the TYPED `Issue`/`IssueFields` struct via `output::render_json` (`src/cli/issue/view.rs`: `render_json(&issue)`), not the raw Jira response body. `duedate` surfaces there because (a) `BASE_ISSUE_FIELDS` requests it from Jira — that amendment is contracted by **BC-2.2.028**, not BC-2.3.036 (BC-2.3.036 contracts `get_issue`'s DEserialization of the response Jira sends back, which is a consequence of BC-2.2.028's request-field change, not the request change itself; `get_issue` and `search_issues` share the one `BASE_ISSUE_FIELDS` constant per BC-2.2.028's amendment note) — and (b) `IssueFields.duedate` is a plain `Option<String>` field with no `#[serde(skip_serializing_if)]` attribute, matching the existing `created`/`updated` fields' serialization behavior (serializes as JSON `null` when `None`, never omitted). Both conditions must hold for the JSON path to work; this BC does not introduce a renderer change (see JSON-render-invariant confirmation below), but "no renderer change" is not the same claim as "raw passthrough."

**Trace**: F2 spec evolution (issue #668, 2026-08-13); precedent: `Created`/`Updated` rows in `handle_view`; `.factory/feature-delta/668-duedate/delta-analysis.md` Open Questions #3, #4; adversarial F2 review (2026-08-13) F1/F5/F6 corrections; human-directed simplification fix-round (2026-08-13) — parse/reformat machinery removed, verbatim-display substituted

---

#### BC-2.3.040: `Component` struct (`src/types/jira/issue.rs`) gains an `id: Option<String>` field alongside the existing `name: String`

**[UPDATED 2026-08-15, M8 fix-burst]** `id` is `Option<String>`, NOT a required `String`.
**Previous version (superseded, retained for audit trail):** "`id: String` field... REQUIRED
(non-`Option`)... A fixture with `components: [{"name": "Backend"}]` (no `id` key)... FAILS to
deserialize... a BREAKING change to the deserialization contract." That design made a single
component missing `id` on ANY issue (e.g. Compass-adjacent drift, a non-standard third-party
add-on's edge response, or any future Jira response shape this BC did not anticipate) hard-fail
`get_issue`/`search_issues` deserialization for the ENTIRE issue — including `issue view`
and `issue list` for issues that have nothing to do with the `jr component` command group.
That blast radius is disproportionate to what `id` is needed for (see Behavior below), so the
field is corrected to `Option<String>` here, with enforcement pushed to the specific call
sites that actually need a real id, per Invariant 2.

**Confidence**: HIGH
**Source**: F1 delta analysis §2 ("`Component` struct currently lacks an `id` field — every
one of the four issues needs it"); F1 delta analysis §2 (precedent: the 2026-08-13 `duedate`
amendment shape, BC-2.2.028/BC-2.3.036 — additive field on an existing nullable struct,
amend-in-place); adversarial spec-delta review pass 1 M8 (2026-08-15) — non-Option `id`
hard-fails `issue view`/`issue list` deserialization for ALL issues-with-components on a
single absent id, disproportionate for a display-only struct; `src/types/jira/issue.rs::
Component` (pending F4)
**Subject**: Issue read — shared prerequisite for #604/#605/#606/#608
**Behavior**: `src/types/jira/issue.rs::Component` currently deserializes ONLY `name: String`
(`fields.components[].name`). This BC amends it to ALSO deserialize `id: Option<String>`
(`fields.components[].id`), matching the wire shape Jira actually returns (every component
object in a real API response carries both `id` and `name` in the documented case, but this
field is tolerant of the id being absent — see Description above for why non-optional was
rejected). This is the SINGLE shared prerequisite change every one of the four
component-management issues (#604/#605/#606/#608) implicitly depends on: without a
struct-level `id`, `jr` cannot distinguish two same-named components across projects
(BC-8.4.004's core invariant) purely from a deserialized `Issue`/component-list response — but
that distinguishing need is scoped to the specific call sites that consume `id` for
identity/disambiguation purposes (Invariant 2), not to `Issue` deserialization as a whole.
**Preconditions**:
1. This amendment applies to the standalone `Component` struct used for the `fields.
   components` array on an `Issue` (the "embedded, name-plus-id" shape) — it is DISTINCT from
   the fuller component RESOURCE shape (id, name, description, lead, assigneeType, project)
   introduced by `src/types/jira/component.rs` for the `jr component` command group (BC-8.1.*)
   — the two types serve different call sites and are NOT unified by this BC. `Component`
   (this file) is embedded on an `Issue`; the new `types/jira/component.rs` type is the
   full resource returned by `/rest/api/3/component/*` and `/rest/api/3/project/{key}/
   components`. **This BC's `Option<String>` relaxation applies ONLY to the embedded
   `Component` struct.** The full resource type (`types/jira/component.rs::Component`, used by
   the `jr component` command group's list/create/edit/delete/rename endpoints and by §8.4's
   `resolve_component` resolver) is UNCHANGED by this BC — its `id` field stays a required,
   non-optional `String`, because `GET /rest/api/3/project/{key}/components` (the endpoint
   that populates the resolver's candidate list) is documented to always return `id` on every
   element, and §8.4's resolver depends on a real id to construct numeric JQL/wire values;
   relaxing THAT type would silently weaken the resolver's guarantees, which is not this BC's
   intent.
**Postconditions**:
1. `Component { id: Option<String>, name: String }` deserializes both fields from any fixture
   containing `{"id": "...", "name": "..."}` inside `fields.components[]` (`id` populated as
   `Some(...)`).
2. A fixture with `components: [{"name": "Backend"}]` (no `id` key) deserializes SUCCESSFULLY,
   with `id: None` — this is NOT a breaking change (reversing the prior, superseded
   Postcondition 2, which required a serde failure here). `tests/common/fixtures.rs` and any
   inline test fixture supplying `components` are NOT required to add an `id` key as a
   correctness matter, though existing fixtures that already carry realistic `id` values are
   unaffected and continue to deserialize as `Some(...)`.
**Invariants**:
1. `Component.name` remains non-optional `String`; `Component.id` is `Option<String>` —
   these are asymmetric, not "both non-optional" as the prior version stated.
2. **Resolver-side enforcement.** Any code path that NEEDS a real component id for identity
   or cross-project disambiguation (BC-8.4.004's invariant; e.g. a future `issue view --output
   json` consumer that wants to feed a displayed component's id into `--component` filtering,
   or any equivalent identity-sensitive use of THIS embedded struct) MUST treat `id: None` as
   "cannot disambiguate this component reference" and handle it explicitly (e.g. exclude it
   from an id-keyed lookup, or surface it distinctly in rendering) — it MUST NOT `.unwrap()`
   or otherwise assume `Some`. This BC does not itself define such a consumer; it only
   establishes that the type permits `None` and that consumers are responsible for handling
   it. §8.4's `resolve_component` resolver is UNAFFECTED (Precondition 1) since it never reads
   THIS struct's `id` — it reads the full resource type's `id`, which remains required.
   **[CLARIFIED 2026-08-15, L4 fix-burst — pass 3, states this honestly rather than implying an
   active driver, per a gap found by adversarial spec-delta review pass 3]** To be explicit:
   this embedded struct's `id: Option<String>` field has NO in-cycle consumer as of this F2
   burst. Every consumer of a component id across the four component-management issues
   (#604/#605/#606/#608) reads the FULL resource type's required `String` id (via
   `resolve_component`/§8.4, per Precondition 1 above) — `issue view`/`issue list`'s rendering
   of `fields.components[]` (this embedded struct) displays `name` only and never reads `id`
   (EC-2.3.040-2). This field is added as a FORWARD-LOOKING prerequisite (matching the wire
   shape Jira actually returns, so a future consumer does not require another struct amendment)
   and to keep this codebase's `Issue` deserialization tolerant of a component entry that
   omits `id`; it is not backing any consumer this cycle implements or requires.
**Edge Cases**:
- EC-2.3.040-1: Existing test fixtures asserting `components[0].name == "Backend"` continue to
  compile and pass unchanged (BC-2.3.036's `get_issue` deserialization test family,
  `src/types/jira/issue.rs::tests`) — no fixture update is required by this BC (contrast the
  prior, superseded version, which mandated one).
- EC-2.3.040-2 **[NEW 2026-08-15, M8 fix-burst]**: A fixture/live response where a component
  entry inside `fields.components[]` omits `id` (Compass-adjacent drift or any non-standard
  edge response) → `issue view`/`issue list` deserialization SUCCEEDS for the whole issue;
  that one component's `id` is `None`; display rendering (issue view/list's components
  column) is unaffected since it renders `name` only and never reads `id`.
**Verification Properties**:
- VP-COMPONENT-020: `Component { id: Option<String>, name: String }` deserializes both fields
  from `{"id":"…","name":"…"}` (`id: Some(...)`) AND from `{"name":"…"}` alone (`id: None`,
  no deserialization error); the embedded (`fields.components[]`) type stays distinct from the
  full `types/jira/component.rs` resource type, whose `id` remains required (Precondition 1).
**Trace**: F1 delta analysis §2; BC-2.2.028/BC-2.3.036 (structural amendment precedent,
`duedate`); BC-8.4.004 (the cross-project-id-non-collision invariant this field supports, via
the SEPARATE full-resource `Component` type, not this embedded one); adversarial spec-delta
review pass 1 M8

---

### 2.4 Comments

#### BC-2.4.039: `issue comments <key>` paginates at 100/page with `expand=properties`

**Confidence**: HIGH
**Source**: `tests/comments.rs:~9-46, 73-158`
**Subject**: Issue read
**Behavior**: `maxResults=100`. `--limit N` → `maxResults=N`. Paginates via startAt until total reached.
**Trace**: Pass 3 BC-116

---

#### BC-2.4.040: `issue comments` 5xx → exit 1 + `API error (500)`

**Confidence**: HIGH
**Source**: `tests/comments.rs:~163-200`
**Trace**: Pass 3 BC-117

---

#### BC-2.4.041: `issue comments --internal` adds `sd.public.comment` property (JSM-aware)

**Confidence**: MEDIUM
**Source**: `src/api/jira/issues.rs:~181-198`
**Behavior**: `properties: [{key:"sd.public.comment", value:{internal:true}}]` on write. Read shape preserves `EntityProperty[]`. Non-JSM: Jira silently ignores.
**Trace**: Pass 3 BC-118

---

#### BC-2.4.042: `client.list_comments(key, None)` lists ALL comments via offset pagination

**Confidence**: HIGH
**Source**: `tests/comments.rs:~104-158`
**Behavior**: Advances `startAt` by 100 until total reached.
**Trace**: Pass 3 BC-122

---

#### BC-2.4.043: `list_comments` offset pagination aborts cleanly if startAt does not advance (anti-stall guard)

**Confidence**: HIGH
**Source**: `src/api/jira/issues.rs::list_comments` (impl guard); `tests/comments.rs::test_list_comments_stall_guard_returns_error_when_start_at_does_not_advance` (verification)
**Subject**: Issue read
**Behavior**: After each page fetch inside `list_comments`, before advancing `start_at`, the implementation MUST check `if next_start_at <= start_at`. If the condition is true, it MUST return `Err(anyhow::anyhow!("Jira comment pagination did not advance (startAt {} → {}) — aborting to prevent infinite loop", start_at, next_start_at))` — an abort, not a silent loop or an empty-result return. `start_at` is only advanced to `next_start_at` when `next_start_at > start_at`. This guard pattern is identical to the one in `get_changelog` (the reference implementation) and is a defensive-by-design guard against a non-advancing `startAt` offset / stale `has_more` (infinite-loop class). No external tracker ticket is cited — none publicly documents this symptom for the comment endpoint; the guard exists to mirror the `get_changelog` anti-loop guard as a precautionary measure. The guard does NOT apply to cursor-based paginators (`search_issues`, `search_issue_keys`) — those use the JRACLOUD-95368 repeated-token guard instead (BC-2.6.050, BC-2.6.051).
**Edge cases**:
- EC-1: Server returns `total > current_count` (has_more true) but `next_start_at == start_at` (zero-advance) → Err, no further pages fetched.
- EC-2: Server returns `total > current_count` but `next_start_at < start_at` (regression) → same Err path. _(Note: the strict-regression branch `next < start_at` is unreachable for a well-formed u32 OffsetPage response — reaching it would require u32 offset overflow. The `<=` guard is retained as defensive code mirroring `get_changelog`; the reachable case under test is the `==` zero-advance arm, EC-1 above, which is exercised by `max_results == 0`.)_
- EC-3: Normal page where `next_start_at > start_at` → advances cleanly, loop continues.
- EC-4: Final page where `has_more = false` → exits loop normally before guard is evaluated.
**Trace**: CR-001 (Bundle C 2026-06-17); reference impl: `src/api/jira/issues.rs::get_changelog` offset-guard at `if next <= start_at`

---

### 2.5 Changelog

#### BC-2.5.043: `issue changelog --field <substr>` filters items by case-insensitive field substring (client-side)

**Confidence**: MEDIUM
**Source**: `src/cli/issue/changelog.rs`; unit tests in `src/cli/issue/changelog.rs::tests`
**Trace**: Pass 3 BC-119

---

#### BC-2.5.044: `issue changelog --author X` smart-constructs author needle (`:` or 12+ chars with digit → exact accountId)

**Confidence**: MEDIUM
**Source**: `src/cli/issue/changelog.rs` author needle
**Trace**: Pass 3 BC-120

---

#### BC-2.5.045: `issue changelog --reverse` reverses chronological order

**Confidence**: MEDIUM
**Source**: `src/cli/issue/changelog.rs`
**Trace**: Pass 3 BC-121

---

#### BC-2.5.046: Changelog JSON output snapshot pins full shape including nullable `fromString`/`toString`

**Confidence**: HIGH
**Source**: `tests/snapshots/issue_changelog__changelog_json_output_snapshot.snap`
**Subject**: Issue read
**Behavior**: `{entries: [{author: {accountId, active, displayName, emailAddress}, created, id, items: [{field, fieldtype, from, fromString, to, toString}]}], key}`. `author` can be `null` (system events). `fromString`/`toString` ARE nullable (null != missing).
**Trace**: Pass 3 BC-1118 (R4)

---

### 2.6 API Layer (Search / Find)

#### BC-2.6.047: `client.search_issues` with story-points extra field: deserializes `Some(5.0)` for issue with field, `None` without

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~130-166`
**Trace**: Pass 3 BC-1041 (R4)

---

#### BC-2.6.048: `client.find_story_points_field_id()` returns fields with name == "Story Points" from `/rest/api/3/field`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~168-186`
**Trace**: Pass 3 BC-1042 (R4)

---

#### BC-2.6.049: `search_users` accepts FOUR distinct response shapes (bare array, paginated, empty, error)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~388-490`
**Subject**: Issue read
**Behavior**: Bare array `[{...}]`; `{values: [...]}` paginated envelope; `[]`; error shape → Err. Via serde-untagged enum. Unrecognized shapes do NOT default to empty — they error.
**Trace**: Pass 3 BC-1051 (R4); Top-30 BC rank #20

---

#### BC-2.6.050: `client.search_issue_keys(jql, limit)` posts `/rest/api/3/search/jql` with body `fields: ["key"]` and returns `KeySearchResult { keys, has_more }`

**Confidence**: HIGH
**Source**: issue #350 (audit-followup from PR #348 / issue #110 PR2 Copilot review round 7); spec at `docs/specs/2026-05-13-search-issue-keys.md`; research at `.factory/research/issue-350-search-issue-keys-design.md`
**Subject**: Issue read (API layer — keys-only JQL search)
**Behavior**: POST `/rest/api/3/search/jql` sends body `fields: ["key"]` exclusively (never `BASE_ISSUE_FIELDS`). Deserializes only the top-level `key` per issue; ignores `fields {}` and unknown top-level fields. Paginates via `nextPageToken` cursor identically to `search_issues`, including the JRACLOUD-95368 repeated-cursor anti-loop guard (same stderr warning text). Returns `KeySearchResult { keys: Vec<String>, has_more: bool }`; `has_more = true` under TWO conditions: (a) the caller's limit was hit while the API still had rows (caller-side truncation), OR (b) the JRACLOUD-95368 repeated-cursor anti-loop guard fired (results may be incomplete; data loss is signaled to callers via this bit). Pure cursor exhaustion (page_has_more = false on a non-truncated path) always returns `has_more = false`. Refinement from PR #362 Copilot R1. Clamps `maxResults` per page to `.min(100)` for parity with `search_issues`. On every page-fetch iteration, after extending `all_keys` and before any break-decision check, `search_issue_keys` deduplicates `all_keys` in-place using order-preserving, first-occurrence-wins deduplication (HashSet retain, keyed on the key string). All exit paths (guard-abort, limit-truncation, cursor-exhaustion) therefore return a duplicate-free `keys` vec. Introduced in #365.
**Trace**: `src/api/jira/issues.rs::search_issue_keys` (impl); `src/cli/issue/edit.rs::handle_edit` (effective_keys caller); `tests/search_issue_keys.rs` (wiremock suite: library tokio + subprocess) + `tests/issue_bulk_pr2.rs::test_handle_edit_jql_truncation_error_still_triggers_after_migration` (caller-level regression)

---

#### BC-2.6.051: `client.search_issues(jql, limit, fields)` deduplicates results in-place on all exit paths (JRACLOUD-95368 mitigation)

**Confidence**: HIGH
**Source**: issue #365 (dedupe follow-up from PR #362); spec at `docs/specs/2026-05-14-search-issue-keys-dedupe.md`; research at `.factory/research/issue-365-design-validation.md`
**Subject**: Issue read (API layer — full-body JQL search)
**Behavior**: On every page-fetch iteration, after extending `all_issues` and before any break-decision check, `search_issues` deduplicates `all_issues` in-place using order-preserving, first-occurrence-wins deduplication keyed on `issue.key` (HashSet<String> of cloned keys, because `Issue` does not impl `Hash`). All exit paths (guard-abort, limit-truncation, cursor-exhaustion) therefore return a duplicate-free `issues` vec. `SearchResult.has_more` semantics are unchanged. As of issue #365, `has_more = true` on the guard-abort path no longer implies that `issues` contains duplicates. Symmetric to BC-2.6.050.
**Trace**: `src/api/jira/issues.rs::search_issues` (impl); `tests/rate_limit_cap_tests.rs` (dedupe regression suite added in #365: `test_search_issues_repeated_cursor_abort_dedupes`, `test_search_issues_dedupes_non_consecutive_across_pages`, `test_search_issues_limit_truncation_dedupes_under_drift`, `test_search_issues_apr2025_overshoot_silenced_by_drift_dedupe`)

---

### 2.7 Attachment Read

#### BC-2.7.001: `attachment list <KEY>` renders table: id, filename, mimeType, size (human-readable), created, author; output channel profile 2 (stdout data, stderr hints)

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_list` (implementation pending — SOH-ATTACHMENTS-1 Story 1); `src/api/jira/attachments.rs::list_attachments` (implementation pending)
**Subject**: Issue read
**Output channel profile**: 2 (Read-only) — table data to stdout; filter-count hint to stderr; no filter-count hint on stderr when no filter is active.

`jr issue attachment list <KEY>` fetches `GET /rest/api/3/issue/{key}?fields=attachment` and renders the `fields.attachment[]` array as a comfy-table on stdout. There is no dedicated Jira "list attachments" endpoint; all attachment metadata is returned in a single response via the issue field projection (no cursor pagination for this call — confirmed in research §1a of `.factory/research/issue-576-attachments-api-2026-07-15.md`).

**ASSUMPTION — completeness of `fields.attachment`**: `fields.attachment` is returned COMPLETE (not paginated) in this single response. The current Jira Cloud REST API v3 schema does not paginate the attachment field. **S1 delivery obligation**: the S1 implementer MUST live-verify against an issue with more than 100 attachments, OR document the maximum attachment count per issue if explicitly bounded by Atlassian documentation, before S1 delivery. The correctness of `--all`, `--newest N`, and `--older-than` (BC-3.9.019) depends entirely on this completeness assumption — a partial list would silently miss attachments. BC-3.9.019 cites this clause.

Table columns (in display order):

| Column | Source field | Notes |
|--------|-------------|-------|
| ID | `attachment.id` | Numeric string |
| Filename | `attachment.filename` | Raw as returned by Jira; untrusted for disk write (see BC-2.7.011) |
| Type | `attachment.mimeType` | MIME type string |
| Size | `attachment.size` | Human-readable formatted (e.g., `42.0 KB`, `1.2 MB`); raw bytes in JSON output (BC-2.7.002) |
| Created | `attachment.created` | ISO 8601 string; displayed as-is (no parsing or TZ conversion) |
| Author | `attachment.author.displayName` | Falls back to `attachment.author.accountId` when `displayName` is absent or null; falls back to `"(anonymous)"` when both are absent or null (full chain: displayName → accountId → "(anonymous)") |

When the issue has zero attachments, the handler exits 0 with no table, empty stdout (pipe-friendly), and emits `"No attachments on <KEY>."` to stderr (profile 2 hint — same canonical string as EC-2.7.001-1 and EC-2.7.008-1); this is not an error.

**Thumbnail omitted**: the `thumbnail` field (pre-signed short-TTL URL) present in some Jira attachment metadata is NOT included in the table. Only the six columns listed above are displayed in this slice.

**EC-2.7.001-1** (zero attachments): `attachment list <KEY>` on a valid issue with no attachments → exit 0, empty stdout (pipe-friendly; no table, no message on stdout); stderr: `"No attachments on <KEY>."` (profile 2 hint — human mode; JSON mode: empty stdout `[]` per BC-2.7.002, no stderr, exit 0).

**EC-2.7.001-2** (filter-count hint): when any `--filter` flag is active and reduces the displayed row count, a hint is emitted to stderr: `"Showing N of M attachments."` (N = filtered count, M = total from API). When no filter is active this hint is suppressed. **N==M clause (P39-I2)**: when a filter is active but excludes nothing (N==M), the hint is NOT emitted — it fires only when the displayed count is reduced. **JSON mode**: the hint fires in `--output json` mode as well — emitted to stderr via `eprintln!` unconditionally after the JSON array is written to stdout. This mirrors the empirical house behavior in `src/cli/issue/list.rs::handle_list` (the `eprintln!` at ~line 580 fires after `output::print_output` regardless of `output_format`) and `src/cli/board.rs::handle_view` (~line 283). **Deliberate asymmetry with EC-2.7.001-1**: the zero-attachment hint from EC-2.7.001-1 IS suppressed in JSON mode (the empty `[]` array is self-describing and unambiguous); the filter-count hint here is NOT suppressed because a filtered JSON array gives no indication of the total — without the hint, a script would see a smaller array than expected with no context. (P19-002)

**EC-2.7.001-3** (null/missing author or exhausted fallback chain): the Author column displays `"(anonymous)"` when: (a) `attachment.author` is absent or null (system-generated or anonymous attachment); OR (b) `attachment.author` is present but both `displayName` and `accountId` are absent or null (exhausted fallback chain). Full resolution chain: (1) `attachment.author.displayName` if present and non-null; (2) else `attachment.author.accountId` if present and non-null; (3) else `"(anonymous)"`. This covers the H-NEW-ATTACHMENT-001 Call B fixture (author present, `displayName` null, no `accountId`). Empty-string (`""`) values are treated as absent for fallback-chain purposes — a present-but-empty `displayName` or `accountId` falls through to the next link in the chain (defensive display convention; real Jira Cloud never emits empty-string `displayName`; P2-001 ratification 2026-07-19).

**CLI flags** (pinned for e2e surface guard): `<KEY>` (positional, required); `--filter <FILTER>` (repeatable; key=value form); `--output json`; `--no-input`; `--profile <NAME>`; `--no-color`.

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design; research §1a VERIFIED — no dedicated list endpoint); v1.3.96 — P2-001 ratification (EC-2.7.001-3 empty-string values treated as absent)

---

#### BC-2.7.002: `attachment list <KEY> --output json` shape — `[{author, contentUrl, created, filename, id, mimeType, size}]`

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_list` (implementation pending — SOH-ATTACHMENTS-1 Story 1); `src/api/jira/attachments.rs::list_attachments` (implementation pending); `src/output.rs::render_json`
**Subject**: Issue read

`attachment list --output json` routes through `output::render_json` (JSON render invariant #526). The output is a JSON array; each element:

```json
[
  {
    "author": {
      "accountId": "62abc123...",
      "displayName": "Alice Operator"
    },
    "contentUrl": "https://mysite.atlassian.net/rest/api/3/attachment/content/10042",
    "created": "2026-07-10T14:23:11.000+0000",
    "filename": "screenshot.png",
    "id": "10042",
    "mimeType": "image/png",
    "size": 43008
  }
]
```

Field notes:
- `size` is a raw `u64` integer (bytes), never a human-formatted string (contrast with the table in BC-2.7.001).
- `contentUrl` is the stable authenticated Jira content endpoint (`/rest/api/3/attachment/content/{id}`) — it is an indirection that 302/303-redirects to a pre-signed media URL at request time; it is NOT itself an expiring signed URL. Surfacing this field satisfies issue #585 (absorbed into SOH-ATTACHMENTS-1 Story 1; close #585 as fixed-by #576 after Story 1 ships). **Research basis**: research §7 VERIFIED — the `content` field is already present in `fields.attachment[]` and is a stable Jira endpoint. **Field name rationale**: `jr` exposes this as `contentUrl` (not the raw Jira API field name `content`) for clarity — `content` alone is ambiguous in a JSON context; `contentUrl` makes the type (URL) self-evident. This is a `jr` display convention documented here.
- `author` is serialized as a curated two-field object `{accountId, displayName}` only — both fields are passed through as-received from the Jira API (including null values when absent from the sub-object); no other Jira attachment-author fields (`self`, `avatarUrls`, `accountType`, `timeZone`, `emailAddress`, `active`) are emitted. This curated form is consistent with the `accountId` < `displayName` BTreeMap ordering required by the key-ordering clause above.
- `thumbnail` / `thumbnailUrl` fields that may appear in some Jira attachment objects are **omitted** from both the table output (BC-2.7.001) and this JSON output in this slice. They are not surfaced because thumbnail availability is instance-dependent and the pre-signed thumbnail URL has a short TTL unsuitable for offline use.

Empty issue → `[]` array, exit 0, no error.

**JSON key ordering (BTreeMap-canonical — P19-001)**: the canonical attachment-object JSON shape has BTreeMap-ordered (alphabetical) keys at all depths: `author` < `contentUrl` < `created` < `filename` < `id` < `mimeType` < `size` at the top level; `accountId` < `displayName` within the `author` object. This is consistent with BC-3.9.010 (delete shapes, BTreeMap-ordered) and the EC-2.7.007-7 download manifest inner key ordering (`filename` < `id` < `path` < `size`). Implementation consequence: serialize via a type that yields alphabetical key order — e.g., a `BTreeMap`-backed serializer or `serde_json::Map` without the `preserve_order` feature (which is NOT enabled in this crate). Bare struct-declaration order does NOT guarantee alphabetical JSON emission.

**Null author in JSON**: when `attachment.author` is absent or null, the JSON element emits `"author": null` (not an omitted key and not an empty object). This is consistent with the Jira API's own null representation for missing sub-objects. **Partial-author case** (author present but `displayName` and `accountId` both absent or null): the JSON element emits `"author": {"accountId": null, "displayName": null}` — the curated two-field form with values as-received; no `"(anonymous)"` substitution is applied in JSON mode, and no other Jira API author fields (`self`, `avatarUrls`, `accountType`, `timeZone`, `emailAddress`, `active`) are emitted. The resolution chain in EC-2.7.001-3 is a table-rendering convention only; JSON mode always emits the curated `{accountId, displayName}` object with field values as-received (including null).

All `--output json` paths MUST route through `output::render_json` or `output::print_output` — never `serde_json::to_string_pretty` or direct compact printing (JSON render invariant #526).

**Authority for all attachment-object serializations**: the curated form defined in this BC is the single canonical attachment-object JSON shape for `jr` attachment **list** and **upload** (platform POST + bulk echo) responses. **`download` is excluded**: the download JSON shape is the distinct `{"downloaded":[...]}` manifest defined in BC-2.7.007 (EC-2.7.007-7), not an attachment-object array. [P6-003 correction] BC-3.9.009 (upload JSON output) cross-references this BC as the authority. The `"self"` field MUST be omitted and `"content"` MUST be renamed to `"contentUrl"` across every code path that serializes a Jira attachment object.

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; #585 absorbed — research §7 VERIFIED; DEC-179 ratified design); v1.3.95 (2026-07-19) P1-002 author-curated-form ruling — "User serde shape / pass-through" contradiction resolved; author JSON shape is curated `{accountId, displayName}` only

**VP-576-004**: curated attachment-object JSON transformation pin — `jr issue attachment list <KEY> --output json` and `jr issue attachment upload <KEY> <FILE> --output json` via wiremock: inspect every JSON object in the returned array and assert: (1) NO element contains a `"self"` key — the Jira API `"self"` field MUST be omitted from `jr` output; (2) every element contains a `"contentUrl"` key and NO element contains a `"content"` key — the Jira API `"content"` field MUST be renamed to `"contentUrl"`. These two invariants hold for ALL serialization paths — list (BC-2.7.002) and upload platform POST (BC-3.9.009). A regression that passes `"self"` through or emits `"content"` instead of `"contentUrl"` MUST fail these assertions. Pins BC-2.7.002 authority clause ("the `'self'` field MUST be omitted and `'content'` MUST be renamed to `'contentUrl'` across every code path that serializes a Jira attachment object"); cross-references BC-3.9.009 (upload JSON output authority). P20-006. **Story allocation (P24-002)**: list half verified at S1 (BC-2.7.002 home); upload-platform-POST half verified at S3 (BC-3.9.009); the full cross-path test lands at S3 — S3 depends_on S1 for the shared curated-serialization plumbing (earliest consumer S1 ships it, per the R3.13 principle). NOT part of the S1 acceptance matrix as a whole; the S1 matrix includes only the list half.

---

#### BC-2.7.003: `attachment list <KEY> --filter mime=<glob>` client-side mimeType filter

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_list` (implementation pending — SOH-ATTACHMENTS-1 Story 1)
**Subject**: Issue read

`--filter mime=<glob>` applies a client-side filter retaining only rows whose `mimeType` field matches the glob pattern. The full attachment list is fetched from the API before filtering; no server-side filter is applied.

Glob semantics: `*` matches any character sequence (including `/`); `?` matches any single character; matching is case-insensitive. Examples:
- `--filter mime=image/*` → retains `image/png`, `image/jpeg`, `image/gif`, etc.
- `--filter mime=application/pdf` → exact match (glob-interpreted but no wildcards)

After filtering, the table is rendered (BC-2.7.001) with only matching rows. When `--output json` is combined with `--filter mime=`, the JSON array contains only matching elements (BC-2.7.002 shape unchanged). The filter-count hint (EC-2.7.001-2) fires when the filter reduces row count.

**Filter composition with download commands**: `--filter mime=<glob>` (and all `--filter` flags) also applies to `jr issue attachment download --all` and `--newest N`. The filter runs before top-N selection: `--newest 3 --filter mime=image/*` yields the 3 most recently created images (see BC-2.7.008/BC-2.7.009).

**EC-2.7.003-1** (zero matches): empty table or `[]` JSON, exit 0. Hint fires: `"Showing 0 of M attachments."`
**EC-2.7.003-2** (unknown filter key or missing `=` — applies to the entire `--filter` family across `attachment list` and `attachment download`): if a `--filter` value does not contain `=`, exit 64 before any HTTP call: `"Invalid filter '<VALUE>': expected key=value form. Accepted keys: mime=, name=, size-max=."`. If `=` is present but the key before it is not `mime`, `name`, or `size-max`, exit 64: `"Unknown filter key '<KEY>'. Accepted keys: mime=, name=, size-max=."`. This validation is an application pre-flight check; no HTTP call is issued on either path.

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design)

---

#### BC-2.7.004: `attachment list <KEY> --filter name=<glob>` client-side filename filter

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_list` (implementation pending — SOH-ATTACHMENTS-1 Story 1)
**Subject**: Issue read

`--filter name=<glob>` applies a client-side filter retaining only rows whose `filename` field matches the glob pattern. Semantics mirror BC-2.7.003 (glob, case-insensitive, client-side). Examples:
- `--filter name=*.png` → PNG files only
- `--filter name=screenshot*` → files starting with "screenshot"

The filter matches against the raw `filename` as returned by Jira. This BC governs display/filter behavior only; CWE-22 sanitization for disk writes is covered by BC-2.7.011.

Multiple `--filter` flags combine with AND semantics: `--filter mime=image/* --filter name=screenshot*` retains only images whose filename starts with "screenshot".

**Filter composition with download commands**: same as BC-2.7.003 — `--filter name=<glob>` also applies to `--all` and `--newest N` download paths (filter-before-select order).

**EC-2.7.004-1** (zero matches): same as EC-2.7.003-1.

**EC-2.7.004-2** (JRACLOUD-96384 note): when multiple attachments share the same `filename`, all matching rows are returned. Downstream callers performing download or delete operations MUST reference attachments by `id`, not by `filename`, because filename collisions are legal in Jira and filename-based matching is ambiguous (JRACLOUD-96384, confirmed in research §6 of `.factory/research/issue-576-attachments-api-2026-07-15.md`).

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; research §6 JRACLOUD-96384 match-by-id invariant VERIFIED)

---

#### BC-2.7.005: `attachment list <KEY> --filter size-max=<bytes>` client-side size filter

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_list` (implementation pending — SOH-ATTACHMENTS-1 Story 1)
**Subject**: Issue read

`--filter size-max=<bytes>` applies a client-side filter retaining only rows whose `size` (bytes, `u64`) is less than or equal to the given byte limit. The argument is a raw non-negative integer. Examples:
- `--filter size-max=10485760` → files at most 10 MB
- `--filter size-max=0` → zero-byte attachments only (valid edge case)

The `size` field from API metadata is authoritative; no hard-coded instance cap is assumed or enforced here (research §3a INCONCLUSIVE on cloud attachment cap; Rev 2 §R2.5 SQ-5 ruling — no hard-coded cap).

Multiple `--filter` flags combine with AND semantics (see BC-2.7.004).

**Filter composition with download commands**: same as BC-2.7.003 — `--filter size-max=<bytes>` also applies to `--all` and `--newest N` download paths (filter-before-select order).

**EC-2.7.005-1** (parse error): if `<bytes>` is not a valid non-negative integer → exit 64 before any HTTP call; message includes the invalid value and states that `--filter size-max` expects a byte count integer.

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; research §3a INCONCLUSIVE ruling — no hard-coded cap)

---

#### BC-2.7.006: `attachment list <KEY>` on unknown or inaccessible KEY → exit 64

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_list` (implementation pending — SOH-ATTACHMENTS-1 Story 1); `src/api/jira/attachments.rs::list_attachments` (implementation pending)
**Subject**: Issue read

When `<KEY>` does not exist or the authenticated user lacks Browse Projects permission, `GET /rest/api/3/issue/{key}?fields=attachment` returns 404. The handler maps this to `JrError::UserError` (exit 64).

**Error paths**:

| Condition | Exit code | stderr |
|-----------|-----------|--------|
| KEY 404 (not found / no access) | 64 | `"Issue <KEY> not found or not accessible."` |
| 403 | 1 | `"Permission denied: cannot access issue <KEY>."` |
| 401 | 2 | Not authenticated + `jr auth login` hint |
| 5xx | 1 | `API error (<N>)` |
| Network error | 1 | Connectivity hint |

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design; follows BC-2.3.033/034 universal error pattern); P15-005 (403 row added — consistent with BC-2.7.012 403 = exit 1)

---

#### BC-2.7.007: `attachment download <KEY> --id <AID>` single-file download; `--out <PATH>` path override

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_download (implementation pending — SOH-ATTACHMENTS-1 Story 2); src/api/jira/attachments.rs::get_attachment_content (implementation pending)
**Subject**: Issue read
**Output channel profile**: 3 (Mixed) — human mode writes no stdout data (completion hints and errors to stderr); `--output json` writes the download manifest to stdout (EC-2.7.007-7 shape).

`jr issue attachment download <KEY> --id <AID>` downloads a single attachment to disk.

**Selector required (clap required-group)**: `jr issue attachment download <KEY>` without any selector (`--id`, `--all`, or `--newest`) is rejected by clap at parse time — the three selector flags form a required mutually-exclusive group. clap exits 2 with a usage hint listing all three options. This is enforced at the CLI layer; no HTTP call is made.

**AID validation (P7-001, CWE-88)**: before issuing any HTTP request, `jr` validates `<AID>` against `^[0-9]+$`. A non-numeric or path-traversal-shaped AID (e.g., `"10001/../../issue/X"`) → exit 64; stderr: `"invalid attachment id: '<VALUE>' (must be numeric)"`; no HTTP calls issued. This fires before step 1 below.

**Wire path (two-step)**:
1. `GET /rest/api/3/attachment/{id}` — metadata fetch (read-only). The Jira API response includes a `"content"` field (the stable content URL); `jr` renames this to `"contentUrl"` in its curated output (BC-2.7.002 convention). The download flow does NOT read this field from the step-1 response — it constructs the content URL from the attachment id directly (see step 2). The metadata response is used solely to obtain the canonical `filename` for BC-2.7.010 naming. **The metadata deserialization uses a PARTIAL struct requiring only `filename` (id implied by the request); all other fields (`created`, `author`, `mimeType`, `size`, `content`) are absent-tolerant — the step's sole purpose is canonical-filename retrieval, and fixtures/servers may omit metadata fields. (P26-003)** (Curated `jr` output fields from BC-2.7.002: `author`, `contentUrl`, `created`, `filename`, `id`, `mimeType`, `size` — BTreeMap-alphabetical order per P19-001.) **The `<KEY>` argument is NOT server-verified on the `--id` path** — the AID is authoritative; `<KEY>` is accepted for CLI-surface uniformity but `jr` does not issue a separate key-ownership check.
2. `GET /rest/api/3/attachment/content/{id}` — streaming download. This path is uniform for both platform and JSM issues. The servicedeskapi `links.content` URLs MUST NOT be used for download: JSDCLOUD-10841 (confirmed in research §P2-6 of `.factory/research/issue-576-attachments-api-2026-07-15.md`) shows these URLs return 404. **`?redirect=false` is prohibited on this endpoint (JRACLOUD-97046, SEC-576-009)**: The content URL MUST be issued with no additional query parameters — appending `?redirect=false` changes the server's redirect behavior and invalidates the credential-stripping invariant established by EC-2.7.007-3. The download MUST follow Jira's CDN redirect via reqwest's default redirect policy; no custom redirect policy is permitted on this endpoint.

**`--out` does NOT skip step 1 (UNCONDITIONAL two-step; P20-003)**: When `--out <PATH>` is supplied, `GET /rest/api/3/attachment/{id}` (step 1, metadata fetch) is issued unconditionally before any download begins. Rationale: uniform wire story + pre-stream existence validation — if the AID does not exist or is inaccessible, `jr` exits 64 (EC-2.7.007-1 / EC-2.7.007-1b) before writing any bytes to the specified output path. The accepted cost is one extra GET per download on the `--out` path. On the `--out` path, the local pre-flight checks (EC-2.7.007-6 parent-exists, EC-2.7.007-11 path-is-directory, overwrite-refuse) fire BEFORE the step-1 metadata GET — fail cheap/offline first (AID-regex-before-HTTP precedent, P32-001); on a double-fault the local check's message wins.

**Redirect following**: Jira Cloud redirects this endpoint (302/303) to a pre-signed CDN URL (`media.atlassian.com` or AWS). The reqwest client MUST rely on its default redirect policy (up to 10 redirects). reqwest 0.13.4 strips `Authorization`, `Cookie`, and `Proxy-Authorization` headers on cross-host redirects — VERIFIED in research §1c and independently corroborated by GHSA-9857-6MW7-FQ2M (which explicitly states the reqwest backend compares `prev_url.host_str()` to `curr_url.host_str()` and strips sensitive headers on cross-domain hops). No custom `RedirectPolicy` is needed. **CRITICAL**: `?redirect=false` MUST NOT be used — JRACLOUD-97046 (research §6) causes encoded or broken responses for some file formats when this query parameter is present.

**Streaming**: response bytes are streamed to disk via `Response::bytes_stream()` + incremental write (e.g., `tokio::io::copy`). The full body is never buffered in memory, guarding against OOM for large attachments. Requires the reqwest `stream` feature in `Cargo.toml` (Rev 2 §R2.1).

**Output path**: for single `--id` without `--out`, the default filename is the bare sanitized basename (no SHA-1 prefix) — see BC-2.7.010 (single-id bare naming rule) and the degenerate-name fallback (id-as-filename when sanitization yields None). `--out <PATH>` overrides the default with an explicit file path; the user-supplied path is NOT sanitized against CWE-22 (trusted input from the operator).

**Overwrite behavior** (DEC-179 ruling 3): if the computed or specified output path already exists as a regular file, the handler MUST refuse with exit 64: `"File already exists: <path>. Use --force to overwrite."` The `--force` flag bypasses this check and overwrites silently. This prevents accidental data loss for idempotent re-runs.

On success, a completion hint is emitted to stderr: `"Downloaded: <path> (<size_human>)."` Nothing is written to stdout (profile 3).

**Write-to-temp + atomic-rename**: The download MUST write to a temporary file named `tmp_<random>` in the same directory as the final path (where `<random>` is a process-unique random string; NO basename is embedded). A deterministic or basename-derived name (e.g., `.partial` suffix, `tmp_<random>_<basename>`) MUST NOT be used — a fixed name collides when two processes download to the same directory concurrently, and embedding the basename risks overflowing `NAME_MAX` when the sanitized basename is near the 214-byte cap (41-byte SHA-1 prefix + random token + basename can exceed 255 bytes on the temp filename even when the final name fits). Only on successful stream completion does `jr` atomically rename the temporary file to the final path. This prevents an interrupted download from leaving a truncated file at the final path that would block a retry (the overwrite-refuse guard checks for the FINAL path, not the temp file). On any error (network failure, disk error, process signal), the temporary file MUST be deleted before `jr` exits; the final path is NOT written.

**Ctrl+C / SIGINT during download** (exit 130): if the user interrupts the download mid-stream, the partial file is cleaned up (deleted), the final path is not written, and `jr` exits 130 (standard signal-interrupt exit code). Exit 130 is consistent with `JrError::Interrupted` (maps to exit code 130 in `src/error.rs`).

**EC-2.7.007-6** (`--out <PATH>` with missing parent directory): if the user-specified `--out <PATH>` names a file in a parent directory that does not exist, `jr` exits 64 before any download: `"Output directory does not exist: <parent>"`. The handler does NOT create parent directories automatically.

**EC-2.7.007-1** (AID does not exist — 404): `GET /rest/api/3/attachment/{id}` (metadata step 1) returns 404 → exit 64: `"Attachment <AID> not found or not accessible."` (canonical not-found string — aligns with BC-2.7.012, BC-3.9.008 EC-3.9.008-2, BC-3.9.015 EC-3.9.015-6); no streaming request issued; no file created. (see BC-2.7.012 for full error taxonomy).

**EC-2.7.007-1b** (AID permission denied — 403): `GET /rest/api/3/attachment/{id}` (metadata step 1) returns 403 → exit 1: `"Permission denied: cannot access attachment <AID>."` (NOT the canonical not-found string — 403 means the attachment exists but is inaccessible, which is a distinct condition; consistent with the 403 = exit 1 mapping across all attachment operations); no streaming request issued; no file created.

**EC-2.7.007-2** (JSM issue uniform behavior): downloading an attachment from a JSM issue uses the exact same platform content endpoint as a non-JSM issue. There is no JSM-specific code path for download. JSDCLOUD-10841 confirms the servicedeskapi links are unreliable; the platform endpoint is the correct single code path.

**EC-2.7.007-3** (credential-stripping regression guard — SEC-576-003 CWE-522): A wiremock integration test MUST assert that `GET /rest/api/3/attachment/content/{id}` following a cross-host 302/303 redirect does NOT include an `Authorization` header on the redirect-target request. Use a two-server wiremock setup (one for the Jira API endpoint, one for the simulated CDN redirect target). **The two wiremock servers MUST use DISTINCT HOST STRINGS** (e.g., `127.0.0.1` for the Jira API server and a second address such as `[::1]` or a distinct loopback hostname for the CDN target). Using the same host at different ports (e.g., two `127.0.0.1` instances on different ports) would make the assertion vacuous: reqwest's cross-host check compares `host_str()` output which IGNORES port numbers, so a same-host-different-port redirect would NOT strip `Authorization` headers — the test would pass while the credential-stripping invariant goes untested. This guards against a future `JiraClient` refactor adding a custom `RedirectPolicy` that silently forwards bearer/Basic credentials to CDN hosts.

**EC-2.7.007-4** (error mid-stream): temporary file (`tmp_<random>`) deleted; exit 1; `"Download failed: <reason>"` on stderr; final path not written.
**EC-2.7.007-5** (Ctrl+C / SIGINT mid-stream): best-effort — temporary file (`tmp_<random>`) cleanup on SIGINT is NOT implemented in this bundle; exit 130; no final path written. **Implementation-strategy note (corrected P8-002 2026-07-20)**: the `src/main.rs` Ctrl+C handler calls `std::process::exit(130)` directly — there is no temp-file registry, no pre-exit deletion step, and `Drop` is not invoked on the abort/signal path (release profile uses `panic = abort`; `std::process::exit()` does not run destructors). Orphaned `tmp_<random-hex>` scratch files are an accepted best-effort residual: reusing the same random name on a subsequent run is astronomically unlikely so auto-cleanup effectively never happens, but the files are harmless — the overwrite-refuse check (EC-2.7.007-12) guards the FINAL path only, not temp paths. Temp-file cleanup on SIGINT is deferred (S-576 bundle deferral; tracked debt). **Not holdout/VP-pinned**: this path is not deterministically testable in CI (signal timing dependent); the error-path cleanup (EC-2.7.007-4, H-NEW-ATTACHMENT-002) is the tested proxy for temp-file correctness. (P19-003; corrected P8-002 2026-07-20)

**EC-2.7.007-8** (concurrent downloads, same out-dir): if two `jr` processes download the same attachment to the same output directory simultaneously, each writes to its own uniquely-named `tmp_<random>` file. There is no interleaving of temp files. When both rename to the final path, the last successful rename wins (standard OS atomic-rename semantics); the earlier written file is silently overwritten. This is safe: both processes produce identical bytes (same source URL), so the last rename wins without data loss. No locking between processes is required.
**EC-2.7.007-7** (`--output json` success shape for `--id`): `{"downloaded":[{"filename":"<name>","id":"<AID>","path":"<written path>","size":N}]}`; one-element `downloaded` array; inner keys in alphabetical order (`filename` < `id` < `path` < `size`); stdout only; exit 0. `path` is the output path as-constructed by `jr` — NOT canonicalized, NOT made absolute (BC-2.7.010 path-non-determinism note; P18-004). `size` is the byte count written. No stderr output in JSON mode. Output MUST route through `output::render_json` (#526 invariant). **`filename` semantics (P27-001)**: `downloaded[].filename` is the RAW Jira `attachment.filename` (pre-sanitization); the on-disk basename (post-sanitization per BC-2.7.011) is recoverable from `path` (basename of `path` = on-disk name). Deliberate pairing: `filename` = what Jira calls it; `path` = where it landed. **Degenerate-name warning in JSON mode (INFO-NEW-7)**: when the degenerate-name fallback fires (BC-2.7.010 R3.10), its stderr warning is a NON-ERROR hint suppressed in `--output json` mode — consistent with the "No stderr output in JSON mode" policy of this EC; shared rule defined at BC-2.7.010.

**EC-2.7.007-9** (`--out` without `--id` — clap binding): `--out <PATH>` MUST be declared with `requires = "id"` (clap `requires` → exit 2 when `--out` is supplied without `--id`). `--out` combined with `--all` or `--newest` is invalid: batch downloads write to a directory (`--out-dir`), not a single file path.

**EC-2.7.007-10** (`--filter` with `--id` — clap conflict): `--filter <FILTER>` MUST be declared with `conflicts_with = "id"` (clap `conflicts_with` → exit 2 when `--filter` is supplied together with `--id`). `--filter` applies only to `--all` and `--newest N` batch paths; it has no defined semantics on the single-ID path (the AID already uniquely identifies one attachment). Applies to all `--filter` variants (mime/name/size-max). P15-004.

**EC-2.7.007-11** (`--out <PATH>` names an existing directory): if the user-specified `--out <PATH>` resolves to a path that already exists as a **directory**, `jr` exits 64 before any download: `"output path is a directory: <PATH>"`. Checked pre-download in the same pre-flight family as the overwrite-refuse guard (BC-2.7.007 Overwrite behavior). No file is created and no streaming request is issued. P15-006.

**EC-2.7.007-12** (single-`--id` overwrite-refuse pre-flight — `--out <PATH>` targets an existing regular file without `--force` — SEC-576-010): When `--out <PATH>` is supplied and the resolved path already exists as a regular file and `--force` is absent, `jr` exits 64 before any download: `"File already exists: <path>. Use --force to overwrite."` Checked pre-download in the same pre-flight family as EC-2.7.007-6 (parent-exists) and EC-2.7.007-11 (is-directory), firing before the step-1 metadata GET per P32-001 ordering (fail cheap/offline first). `--force` bypasses this check and overwrites the existing file silently upon download completion — mirrors the batch path `--force` semantics in BC-2.7.008. **Stderr-clause taxonomy (§2.7 taxonomy, P25/P30)**: this is an ERROR exit (exit 64), not a hint; JSON mode: this check fires pre-HTTP and exits 64 before any output is produced — no manifest envelope is emitted (consistent with EC-2.7.007-6 and EC-2.7.007-11 behavior).

**Observability** (`--verbose` / `--verbose-bodies`): `--verbose` logs method + URL only (unchanged CLAUDE.md rule SD-003). `--verbose-bodies` MUST NOT attempt to materialize the streaming response body — the body is a potentially large binary stream and buffering it for logging would defeat the OOM-safety design of streaming download. On a download response, `--verbose-bodies` MUST log response headers and the final written byte count ONLY (e.g., `<download body: N bytes written to <path>>`), never content. The PII warning that `--verbose-bodies` emits extends to attachment content by extension (attachment payloads may contain credentials, personal data, or confidential documents).

**CLI flags** (pinned for e2e surface guard): `<KEY>` (positional, required); `--id <AID>` (single download); `--all` (batch); `--newest <N>` (top-N); `--out <PATH>` (single-file path override; requires `--id`, clap `requires` — EC-2.7.007-9); `--out-dir <DIR>` (batch target directory; requires `--all` or `--newest` via clap `ArgGroup` + `requires` — EC-2.7.008-9); `--force` (overwrite existing); `--filter <FILTER>` (repeatable; `conflicts_with = "id"` — exit 2 when combined with `--id` — EC-2.7.007-10); `--output json`; `--no-input`; `--profile <NAME>`; `--no-color`.

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design; research §1b–1d VERIFIED; JSDCLOUD-10841 §P2-6 VERIFIED — platform endpoint for JSM; JRACLOUD-97046 §6 no-redirect-false; GHSA-9857-6MW7-FQ2M corroboration); SEC-576-003 (CWE-522 credential-stripping wiremock-test requirement added 2026-07-15); P26-003 (step 1 partial-struct clause added — metadata deserialization is absent-tolerant on all fields except `filename`; partial form distinguished from shared LIST-path struct); P27-001 (EC-2.7.007-7 `filename` semantics clause added: RAW Jira name pre-sanitization; on-disk basename recoverable from `path`); P32-001 (ordering sentence added to `--out` unconditional step-1 paragraph: local pre-flight checks EC-2.7.007-6/EC-2.7.007-11/overwrite-refuse fire BEFORE step-1 metadata GET; fail cheap/offline first; double-fault local check wins); v1.3.80 — SEC-576-009 (CWE-22: `?redirect=false` prohibition promoted from CRITICAL note in "Redirect following" paragraph to explicit body clause in step 2 wire path); SEC-576-010 (EC-2.7.007-12 added: single-id overwrite-refuse pre-flight as numbered EC — exit 64, `--force` bypass, pre-HTTP ordering per P32-001, §2.7 taxonomy compliance); v1.3.97 — P8-002 correction (EC-2.7.007-5 implementation-strategy note corrected: SIGINT cleanup NOT implemented in this bundle; orphaned tmp files accepted best-effort residual; deferred S-576 bundle debt)

---

#### BC-2.7.008: `attachment download <KEY> --all` batch download to `--out-dir <DIR>`; default dir is cwd

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_download (implementation pending — SOH-ATTACHMENTS-1 Story 2)
**Subject**: Issue read

`jr issue attachment download <KEY> --all` downloads all attachments on the issue to a directory. Default target is the current working directory; `--out-dir <DIR>` overrides. The handler first fetches the full attachment list (same `GET /rest/api/3/issue/{key}?fields=attachment` call as `attachment list`). **Batch metadata source**: filename, size, and `contentUrl` for each attachment are taken directly from `fields.attachment[]` in this list response for NAMING, filtering, and pre-download purposes; the manifest `size` field is the byte count written to disk per EC-2.7.008-6, NOT the list-reported `fields.attachment[].size` (in normal operation the two coincide since the atomic rename fires only on a complete stream, but written-bytes is authoritative). The per-attachment step-1 `GET /rest/api/3/attachment/{id}` metadata fetch used by single-`--id` download (BC-2.7.007) is SKIPPED on batch paths — that step is only needed on the single-ID path to obtain the canonical filename when no list is available. The handler then issues the streaming step-2 `GET /rest/api/3/attachment/content/{id}` for each attachment (the download step from BC-2.7.007 wire path). H-NEW-ATTACHMENT-003 and H-NEW-ATTACHMENT-007 holdout mock topologies correctly reflect this: they mount only the issue-fetch GET and per-attachment content GETs, not per-attachment metadata GETs. Each file is named using BC-2.7.010 (batch path: `<sha1-of-id>_<sanitized-basename>`) within the target directory.

**Overwrite behavior with `--all`**: without `--force`, per-file collision is handled fail-soft — the colliding file is skipped with a per-file stderr warning (e.g., `"Skipping <filename>: file already exists. Use --force to overwrite."`). **Display-sanitization cross-reference (SEC-576-011)**: `<filename>` in any collision-skip warning is a server-supplied value and MUST be display-sanitized (replaced with `?` per the BC-2.7.011 display-sanitization character set) before writing to a TTY, per BC-2.7.011 display-sanitization requirement. RAW value retained in JSON mode. The download continues for remaining attachments. With `--force`, existing files are overwritten silently. **Collision-skip is a NON-ERROR**: the overall exit code is 0 even if some files were skipped for being pre-existing (same class as `--filter` exclusions). Exit 1 is scoped exclusively to content-GET/stream failures (EC-2.7.008-7/8).

On completion a summary hint emits to stderr: `"Downloaded N of M attachments to <dir>."` (N = successful, M = total).

**Per-file download error policy (fail-soft-continue)**: A per-file content-GET failure (403, 404, 5xx, network error, or mid-stream abort on `GET /rest/api/3/attachment/content/{id}`) on a batch path (`--all` / `--newest`) does NOT abort the batch. For each failed file: (1) a stderr warning is emitted: `"warning: failed to download attachment <AID>: <reason>"`; (2) any in-progress temporary file for that attachment is deleted (same temp-delete mechanics as EC-2.7.007-4 for the single-ID path); (3) the failed attachment is excluded from the `downloaded` array in JSON mode and from the N count in the human-mode summary (the `"Downloaded N of M"` summary is a HINT — not emitted in JSON mode per EC-2.7.008-6 JSON-mode stderr policy, P25-001). The batch continues with the remaining attachments. **Final exit code**: 0 if all files succeeded; 1 if ANY file failed (including all-fail). In `--output json` mode on partial failure, the manifest is still emitted to stdout (partial `downloaded` array) while exit code is 1 — callers MUST NOT assume a non-zero exit code implies no stdout output on download commands.

**EC-2.7.008-1** (empty attachment list): issue has no attachments → exit 0; stderr: `"No attachments on <KEY>."` (canonical string — unified with EC-2.7.001-1 for the canonical STRING only, not the JSON shape; "found" removed for consistency); **JSON mode: stdout `{"downloaded":[]}` (empty array, consistent with EC-2.7.008-6 uniform `downloaded` array shape); the `"No attachments on <KEY>."` message is a HINT — suppressed in JSON mode (per EC-2.7.008-6 hint-vs-error taxonomy; same class as EC-2.7.001-1 zero-attachment hint on the list path); no download requests issued. P34-004.**

**EC-2.7.008-2** (directory does not exist): if `--out-dir <DIR>` is specified and the directory does not exist → exit 64 before any download: `"Output directory does not exist: <DIR>"`. The handler does NOT create the directory automatically.

**EC-2.7.008-3** (`--id` and `--all` mutual exclusion): clap enforces `conflicts_with` → exit 2 when both are supplied simultaneously.
**EC-2.7.008-4** (`--out-dir` path exists but is not a directory): exit 64: `"Not a directory: <PATH>"`. A regular file at the specified path is rejected; the handler requires a directory.
**EC-2.7.008-5** (`--out-dir` path does not exist): supersedes EC-2.7.008-2 wording clarification — same exit 64: `"Output directory does not exist: <DIR>"`.
**EC-2.7.008-6** (`--output json` success shape for `--all` / `--newest N`): `{"downloaded":[{"filename":"<name>","id":"<AID>","path":"<written path>","size":N},…]}`; N-element `downloaded` array (one entry per file written; files skipped due to collision or `--filter` are NOT in the array); inner keys alphabetical; stdout only; exit 0 (all attempted downloads either succeeded or were skipped as pre-existing — collision-skips are NON-ERROR, same class as `--filter` exclusions) or exit 1 (content-GET/stream failure — per EC-2.7.008-7/8; the manifest is still emitted even when exit code is 1). **JSON-mode stderr policy (hint-vs-error distinction, P25-001)**: per-file failure warnings (`"warning: failed to download attachment <AID>: <reason>"`) ARE emitted to stderr in JSON mode — download failures are ERRORS, not hints, and fire unconditionally (consistent with the model-b cache-writer warning convention). The `"Downloaded N of M"` summary is NOT emitted in JSON mode — it is a HINT, suppressed in JSON mode by this rule. **Collision-skip warnings (P27-003)**: collision-skip warnings (e.g., `"Skipping <filename>: file already exists. Use --force to overwrite."`) are NON-ERROR hints — suppressed in `--output json` mode (same class as the `"Downloaded N of M"` summary and `--filter` exclusions which are silent; the manifest's omission of the skipped file IS the machine signal, consistent with EC-2.7.008-10 filtered-to-zero precedent). Human mode unchanged. `path` is the output path as-constructed by `jr` — NOT canonicalized, NOT made absolute (BC-2.7.010 path-non-determinism note; P18-004). **`size` semantics (P31-002)**: `downloaded[].size` is the byte count written to disk — identical semantics to EC-2.7.007-7 — NOT the `fields.attachment[].size` value from the list response. In normal operation the two coincide (the atomic rename fires only on a complete stream), but written-bytes is authoritative. Shape and field semantics align with EC-2.7.007-7 for a uniform download response type. Output MUST route through `output::render_json` (#526 invariant). **`filename` semantics (P27-001)**: `downloaded[].filename` is the RAW Jira `attachment.filename` (pre-sanitization); the on-disk basename (post-sanitization per BC-2.7.011, post-SHA-1-prefix for batch paths per BC-2.7.010) is recoverable from `path`. Deliberate pairing: `filename` = what Jira calls it; `path` = where it landed.

**EC-2.7.008-7** (some-fail-some-succeed — fail-soft exit code): if one or more content-GET/stream steps fail while others succeed, exit code is 1; `downloaded` array in JSON mode contains only the successful entries (failed attachments excluded); stderr per-file warnings emitted for each failure (in both human and JSON modes — failures are ERRORS, not hints; see EC-2.7.008-6 JSON-mode stderr policy, P25-001); **human mode only**: summary prints actual `N` of `M` where N < M (the `Downloaded N of M` summary is not emitted in JSON mode — it is a HINT per EC-2.7.008-6). Temp file deleted per failure (EC-2.7.007-4 mechanics).

**EC-2.7.008-8** (all-fail): if every content-GET step fails, exit 1; `downloaded` array is empty (`[]`) in JSON mode; summary prints `"Downloaded 0 of M attachments to <dir>."` Per-file stderr warnings still emitted for each failure.

**EC-2.7.008-9** (`--out-dir` without `--all` or `--newest` — clap binding): `--out-dir` MUST be declared with `#[arg(requires = "batch_selector")]` where `batch_selector` is an `ArgGroup` containing `[all, newest]` — the correct clap 4 mechanism for "requires any one of a group" (clap 4 has no `requires_one_of` attribute; `ArgGroup` is the canonical approach; note this is `jr`'s first `ArgGroup` use, establishing precedent). clap exits 2 when `--out-dir` is supplied without either `--all` or `--newest`. Supplying `--out-dir` with `--id` is invalid: a single-file download writes to an explicit `--out <PATH>` or defaults to the current directory.

**EC-2.7.008-10** (filtered-to-zero on a non-empty issue): when `--all` is used with one or more `--filter` flags and the filter set matches zero attachments from a non-empty issue (i.e., the issue has ≥1 attachments but none pass the filter), the behavior is **distinct** from EC-2.7.008-1 (empty-issue path): → exit 0; stderr: `"No attachments matched the filter on <KEY>."` (canonical string; different from `"No attachments on <KEY>."` which is the empty-issue message); JSON mode: stdout `{"downloaded":[]}` (empty array, consistent with EC-2.7.008-6 uniform `downloaded` array shape); **JSON-mode stderr**: the `"No attachments matched the filter"` message is a HINT — suppressed in JSON mode (same class as EC-2.7.001-1 zero-attachment hint; the empty `downloaded` array is self-describing; per EC-2.7.008-6 hint-vs-error principle, INFO-NEW-6); no download requests issued. P15-007.

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design); P15-007 (EC-2.7.008-10 filtered-to-zero non-empty); P25-001 (EC-2.7.008-6 JSON-mode hint-vs-error policy; EC-2.7.008-7 human-mode summary scoping; Per-file download error policy point (3) scoped); INFO-NEW-6 (EC-2.7.008-10 JSON-mode stderr: filtered-to-zero hint suppressed — per EC-2.7.008-6 hint-vs-error principle); P27-001 (EC-2.7.008-6 `filename` semantics clause added: RAW Jira name pre-sanitization; on-disk basename recoverable from `path`); P27-003 (EC-2.7.008-6 collision-skip hint-vs-error classification: collision-skip warnings are NON-ERROR hints, suppressed in JSON mode); P31-002 (EC-2.7.008-6 `size` semantics sentence added: written-bytes authoritative, NOT list-reported `fields.attachment[].size`; "Shape aligns" → "Shape and field semantics align"; Batch metadata source scoped: list response for naming/filtering/pre-download; manifest `size` = written-bytes); P34-004 (EC-2.7.008-1 JSON-mode clause added: `{"downloaded":[]}` in JSON mode; "No attachments on <KEY>." is a HINT suppressed in JSON mode; EC-2.7.001-1 unification clarified as STRING-only); v1.3.80 — SEC-576-011 (CWE-116: display-sanitization cross-reference added to Overwrite behavior paragraph — collision-skip warning filename MUST be display-sanitized before TTY write; RAW value retained in JSON mode); v1.3.94 — PRE-F4-UNICODE-DISPLAY-SANITIZATION: cross-ref wording updated — inline range removed, now points to BC-2.7.011 display-sanitization character set (preferred over re-stating range)

---

#### BC-2.7.009: `attachment download <KEY> --newest N` — select most-recent N attachments by `created` date, then download

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_download (implementation pending — SOH-ATTACHMENTS-1 Story 2)
**Subject**: Issue read

`jr issue attachment download <KEY> --newest N` downloads at most N attachments, selecting the N most recently created (by `attachment.created` descending). The `created` field is parsed as a `chrono::DateTime<FixedOffset>` before sorting; lexicographic sort MUST NOT be used (consistent with BC-3.9.019 which also mandates `chrono` for `created` comparison). Fixtures typically use the `+0000` offset, but the implementation MUST NOT assume a uniform offset — different attachments on the same issue may carry distinct UTC offsets, making lexicographic comparison incorrect in the general case.

**Behavior**: fetch full attachment list (same `GET /rest/api/3/issue/{key}?fields=attachment` as `attachment list`) → apply any `--filter` flags (mime/name/size-max) → sort by `created` descending → take first N → issue step-2 streaming `GET /rest/api/3/attachment/content/{id}` for each selected attachment. **Batch metadata source**: filename, size, and `contentUrl` are taken from `fields.attachment[]` in the list response. The per-attachment step-1 `GET /rest/api/3/attachment/{id}` metadata fetch is SKIPPED (same as BC-2.7.008) — that step is single-`--id`-only. Output naming follows BC-2.7.010.

`--filter` applies BEFORE the top-N selection: `--newest 3 --filter mime=image/*` = the 3 most recently added images.

If the issue has fewer than N attachments after filtering, all available attachments are downloaded (not an error; N > available count is handled gracefully).

`--newest N` is mutually exclusive with `--id` (clap `conflicts_with` → exit 2). `--newest N` combined with `--all` is rejected (clap `conflicts_with` → exit 2). Overwrite and `--force` behavior follow BC-2.7.007/BC-2.7.008. Per-file content-GET errors on `--newest` batch downloads follow BC-2.7.008's fail-soft-continue policy (EC-2.7.008-7/8): per-file warning + temp-delete + continue; exit 1 if any file failed.

**EC-2.7.009-1** (N ≤ 0 — clap parses `--newest` as a signed integer i64; app validates N ≥ 1): `--newest` MUST be declared with `allow_negative_numbers = true` so that negative values (e.g. `-5`) reach the handler as a valid i64 rather than being intercepted by clap as an unknown flag (clap exit 2). The handler validates N ≥ 1; if it finds N ≤ 0, exit 64 before any HTTP call: `"--newest requires a positive integer."` N = 0 is rejected (zero-download is ambiguous, not silently accepted). (arg-level `Arg::allow_negative_numbers`, clap 4 — verified against docs.rs 4.6.1, P17-007)
**EC-2.7.009-2** (non-integer value for `--newest`): clap cannot parse the value as i64 → clap exit 2 with a usage error; no HTTP call. Message is clap-generated (not controlled by `jr` application code).

**EC-2.7.009-3** (filtered-to-zero on a non-empty issue): when `--newest N` is used with one or more `--filter` flags and the filter set matches zero attachments from a non-empty issue (i.e., the issue has ≥1 attachments but none pass the filter), the behavior is distinct from the empty-issue case: → exit 0; stderr: `"No attachments matched the filter on <KEY>."` (canonical string; matches EC-2.7.008-10; different from the empty-issue message); JSON mode: stdout `{"downloaded":[]}` (empty array); **JSON-mode stderr**: the `"No attachments matched the filter"` message is a HINT — suppressed in JSON mode (same class as EC-2.7.008-10 / EC-2.7.001-1; per EC-2.7.008-6 hint-vs-error principle, INFO-NEW-6); no download requests issued. P15-007.

**EC-2.7.009-4** (empty attachment list on `--newest`): when the issue has zero attachments, `--newest N` behavior follows EC-2.7.008-1 — exit 0; stderr `"No attachments on <KEY>."` (HINT, suppressed in JSON mode); JSON mode: stdout `{"downloaded":[]}` (empty array); no download requests issued. P34-004.

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design); P15-007 (EC-2.7.009-3 filtered-to-zero non-empty); INFO-NEW-6 (EC-2.7.009-3 JSON-mode stderr: filtered-to-zero hint suppressed — per EC-2.7.008-6 hint-vs-error principle); P34-004 (EC-2.7.009-4 empty-issue cross-ref to EC-2.7.008-1)

---

#### BC-2.7.010: Default download output path — batch: `<sha1-of-id>_<sanitized-basename>`; single-`--id`: bare sanitized basename; id-as-filename degenerate fallback

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_download (implementation pending — SOH-ATTACHMENTS-1 Story 2)
**Subject**: Issue read

When no `--out <PATH>` is specified, the default output filename depends on the selector used:

**Single-`--id` path (bare naming)**: the default filename is the bare result of `sanitize_attachment_filename(attachment.filename)` (BC-2.7.011 pipeline). No SHA-1 prefix. Filename is human-readable; overwrite-refuse (`--force`) handles collisions on re-runs (BC-2.7.007). This aligns with peer conventions (e.g., `curl` default, `gh` download).

**Batch paths (`--all` / `--newest N`) — SHA-1-prefix naming**:
```
<sha1-of-id>_<sanitized-basename>
```
- `<sha1-of-id>`: full 40-character lowercase hex-encoded SHA-1 of the attachment `id` string (NOT a content hash — ID is stable; deterministic naming without reading file content).
- `<sanitized-basename>`: result of `sanitize_attachment_filename(attachment.filename)` per BC-2.7.011.

**Rationale for SHA-1 prefix on batch paths**: collision-resistance when an issue has multiple attachments sharing the same sanitized basename (e.g., two files both named `report.pdf`); idempotency (re-running `--all` produces the same filenames, allowing `--force` to overwrite predictably). On single-`--id`, there is only one file; collisions are handled by the overwrite-refuse guard; the prefix is unnecessary and reduces usability.

**Single-vs-batch asymmetry (deliberate)**: the two modes intentionally differ. Peer-convention alignment (bare for targeted download) and deduplication-safety (prefixed for batch) are both served. This is the research-backed ruling (Part 3 of `.factory/research/issue-576-attachments-api-2026-07-15.md`).

**Degenerate-name fallback (R3.10 ruling)**: if `sanitize_attachment_filename` returns `None` or an empty string (rejects path-traversal, NUL bytes, etc.), the fallback depends on mode: **single-`--id` mode** → raw attachment `id` string (bare, no prefix — consistent with single-id bare naming); **batch mode (`--all`/`--newest N`)** → `<sha1-of-id>_<id>` (SHA-1 prefix of the id + raw id — consistent with the normal batch naming scheme, and zero special-cases in batch collision logic). In both cases the id string is always a safe filename (numeric-only, no path components). The fallback is NOT subject to BC-2.7.011 (the id needs no sanitization). Emit a stderr informational note: `"warning: using id as filename for attachment <AID> — original name '<raw>' could not be sanitized."` (distinct wording from the "skipping" warning in BC-2.7.011 caller contract; this fallback writes a file rather than skipping). **Degenerate-name warning channel classification (INFO-NEW-7)**: this warning is a NON-ERROR hint — suppressed in `--output json` mode (same class as collision-skip warnings per EC-2.7.008-6 hint-vs-error taxonomy; the operation succeeds and the manifest `path` field reveals the id-based substituted name). Human mode unchanged. This classification applies to both single-`--id` and batch paths.

**Display-sanitization cross-reference (SEC-576-011)**: the `<raw>` value in the degenerate-name warning (`"warning: using id as filename for attachment <AID> — original name '<raw>' could not be sanitized."`) is a server-supplied attachment filename and MUST be display-sanitized (replaced with `?` per the BC-2.7.011 display-sanitization character set) before writing to a TTY, per BC-2.7.011 display-sanitization requirement. RAW value retained in JSON mode (this warning is a hint, suppressed in JSON mode — no exposure vector in that path).

**Trust assumption for server-supplied IDs in batch mode (SEC-576-008, INFO)**: the assertion that `fields.attachment[].id` values are numeric-only rests on the behavioral invariant of the legitimate Jira Cloud API. For single-`--id` mode the numeric invariant holds by construction — the user-supplied AID is validated against `^[0-9]+$` before any HTTP call (BC-2.7.007 AID validation, CWE-88). For batch mode (`--all`/`--newest N`) the IDs originate from server API responses and carry no client-side `^[0-9]+$` validation — the spec accepts this on the basis that a legitimate Jira server always returns numeric attachment IDs. A compromised or rogue server returning non-numeric IDs in batch responses is outside the stated threat model for this check. Implementers MAY apply `^[0-9]+$` validation to server-supplied batch IDs before using them in the degenerate-fallback naming path as additional defense-in-depth.

**Combined-name length cap (batch)**: `<sha1(40)>_<basename>` is at most 255 bytes (41-byte prefix + 214-byte cap from BC-2.7.011 step 5 = 255). **Single-id**: bare name is capped at 214 bytes (BC-2.7.011 step 5) — conservative, fits within 255 bytes.

**Examples (single-`--id`)**:
- `id="10042"`, `filename="notes.txt"` → `notes.txt` (bare)
- `id="10042"`, `filename="../../../etc/passwd"` → sanitized → `passwd` (bare)
- `id="10042"`, `filename=".."` → sanitization returns `None` → fallback `10042`

**Examples (batch)**:
- `id="20001"`, `filename="report.pdf"` → `<sha1("20001")>_report.pdf`
- `id="20002"`, `filename="report.pdf"` → `<sha1("20002")>_report.pdf` (distinct prefix prevents collision)
- `id="20003"`, `filename=".."` → sanitization returns `None` → fallback `<sha1("20003")>_20003` (batch degenerate: SHA-1 prefix + raw id, R3.10)

When `--out <PATH>` is supplied on the single-file path (BC-2.7.007), all default naming is bypassed and the explicit path is used. The user-supplied path is NOT sanitized (trusted operator input).

**`path` field non-determinism (P18-004 ruling)**: the `path` value in the download JSON manifest (EC-2.7.007-7 / EC-2.7.008-6) is the output path exactly as constructed by `jr`: the user-supplied `--out` value verbatim, or the out-dir joined with the final filename (BC-2.7.010 naming rules above). The path is NOT canonicalized and NOT made absolute. Consequently: snapshot tests MUST redact or normalize `path` (e.g., via a TempDir root substitution); exact-match assertions on `path` are only valid with a controlled current working directory.

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design; #576 SHA-1-prefix proposal incorporated); P18-004 (path-non-determinism ruling added); v1.3.80 — SEC-576-008 (INFO: degenerate-fallback server-ID trust assumption note added — numeric invariant is API-behavioral for batch mode, not client-validated; single-id path holds by construction via AID validation); SEC-576-011 (CWE-116: display-sanitization cross-reference added to degenerate-name warning — `<raw>` MUST be display-sanitized before TTY write; RAW value retained in JSON mode); v1.3.94 — PRE-F4-UNICODE-DISPLAY-SANITIZATION: cross-ref wording updated — inline range removed, now points to BC-2.7.011 display-sanitization character set

---

#### BC-2.7.011: Filename sanitization (CWE-22 path traversal mitigation) — `sanitize_attachment_filename(name: &str) -> Option<String>`

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::sanitize_attachment_filename (implementation pending — SOH-ATTACHMENTS-1 Story 2)
**Subject**: Issue read (security invariant — applies to all attachment download paths)

The `filename` field in Jira attachment metadata is **attacker-controllable**: any user who can attach to an issue controls this value, and JSM portals accept customer uploads. When this field is used to construct a local path, it MUST be sanitized before use.

**Required algorithm** (`sanitize_attachment_filename(name: &str) -> Option<String>`):

1. **Basename extraction**: apply `Path::new(name).file_name()` — strips any directory component (`../../etc/passwd` becomes `passwd`; `/etc/passwd` becomes `passwd`; `C:\Windows\system32\calc.exe` becomes `calc.exe`). If `file_name()` returns `None` (path ends in `..` or reduces to empty), return `None` (reject).
2. **Pseudo-name rejection**: if the extracted basename as a `Path` component equals `"."` or `".."`, return `None`. Empty string after OsStr conversion also returns `None`.
3. **NUL byte rejection**: if the name contains a NUL byte (`\0`), return `None`. NUL terminates strings in OS path APIs and is never a valid filename character on any supported platform.
4. **Character scrub** (defensive-depth): replace any remaining `/`, `\`, or `:` in the string with `_`. These are path separators on various platforms and MUST NOT appear in a filename component even after step 1 (guards against encoding edge cases on Windows UNC and drive-letter paths).
5. **Length cap** (UTF-8-safe truncation for the sanitized basename): truncate to at most **214 bytes** on a valid UTF-8 character boundary (Rust `floor_char_boundary` semantics — never split a multi-byte codepoint). Rationale for 214 bytes: batch paths (BC-2.7.010) prepend a 41-byte SHA-1 prefix (`<40 hex chars>_`); 214 + 41 = 255 = POSIX/Windows NTFS filename component limit. Single-`--id` bare paths and `--out <PATH>` overrides carry no prefix and could in principle allow up to 255 bytes, but 214 bytes is retained as a conservative uniform cap — avoids a dual cap-calculation per call site and leaves headroom for OS metadata.
5.5. **Trailing whitespace/dot strip** (SEC-576-007 — Windows predictability): strip trailing ASCII whitespace characters and trailing `.` from the basename after the length cap. Windows silently removes trailing dots and spaces from filename components on write; stripping them makes the sanitized output identical on Windows and POSIX, preventing unpredictable collision between two Jira attachments whose names differ only by trailing characters.

Return `Some(sanitized_name)` if all steps produce a non-empty string; otherwise `None`.

**Caller contract** [P8-001 CORRECTION — prior "MUST skip" + skip-warning text reversed; R3.10 fallback writes the file, does not skip]: if `sanitize_attachment_filename` returns `None` or an empty string, the caller MUST apply the BC-2.7.010 R3.10 degenerate-name fallback: **single-`--id` mode** → write the file named with the raw attachment `id` string (bare, no prefix); **batch mode** → write the file named `<sha1-of-id>_<id>`. In both cases emit a per-file stderr informational note: `"warning: using id as filename for attachment <AID> — original name '<raw>' could not be sanitized."` (wording is intentionally distinct from the CWE-22 path-escape warning; see BC-2.7.010 R3.10 for the naming rule). The overall download operation continues for remaining attachments (fail-soft per-file).

**Windows device-name caller note (SEC-576-001 — CWE-22)**: The sanitized name returned by `sanitize_attachment_filename` may match a Windows reserved device base-name (`CON`, `NUL`, `PRN`, `AUX`, `COM1`–`COM9`, `LPT1`–`LPT9`). Any call site that writes the result to disk MUST ensure the final on-disk filename is not a bare device name before the extension dot. **Batch paths** (BC-2.7.010): the SHA-1 prefix (`<sha1>_CON`, `<sha1>_NUL`, etc.) satisfies this requirement automatically — `<sha1>_CON` is NOT a Windows reserved name. **Single-`--id` bare naming** (BC-2.7.010): the implementation call site MUST apply a device-name escape before writing (e.g., prepend `_` when the sanitized basename before the first `.` is a reserved device name). **`--out <PATH>` override**: uses trusted operator-supplied paths and is NOT subject to this note (the operator is responsible for their path choice).

**Defense-in-depth containment check (SEC-576-002 — CWE-22, corrected procedure)**: after joining the sanitized name with the target directory, the implementer MUST use the following two-step procedure. Do NOT call `canonicalize()` on the joined path — `std::fs::canonicalize` returns `Err` for non-existent paths, which would cause every new download to be treated as a containment failure:

1. `let resolved_dir = out_dir.canonicalize()?` — canonicalize `out_dir` (which is guaranteed to exist: (a) `--all`/`--newest` batch paths enforce existence via BC-2.7.008 EC-2.7.008-2 before any download begins; (b) single-`--id` without `--out` defaults `out_dir` to the current working directory — `canonicalize(cwd)` trivially succeeds since cwd always exists; (c) **`--out <PATH>` is excluded from this containment check entirely** — the user-supplied path is trusted operator input (BC-2.7.007/BC-2.7.010); neither step 1 (`canonicalize(out_dir)`) nor step 2 (`starts_with`) of this check applies to `--out`-supplied paths).
2. Assert `resolved_dir.join(&sha1_filename).starts_with(&resolved_dir)` — `Path::starts_with` is component-based (not a string-prefix check), so it correctly evaluates containment for a file that does not yet exist on disk.

Since step 4 of sanitization already strips `../`, `/`, `\`, `:`, the join will in practice always satisfy the `starts_with` assertion. The check is defense-in-depth against any encoding edge case not caught by steps 1–4. If `starts_with` returns `false`, skip with a warning: `"warning: skipping attachment <AID> — path escape detected after sanitization."` This skip-case is a defensive guard only; it should not occur for any name produced by the five-step algorithm above.

**Coverage/mutation exemption note**: The `starts_with` false branch is intentionally unreachable via any current Jira API-supplied filename after steps 1–5. This branch exists as defense-in-depth against future encoding edge cases or platform differences not covered by the step 1–5 guarantee. A mutation testing or line-coverage exemption for this specific branch is acceptable; annotate the branch with a comment referencing this BC (e.g., `// BC-2.7.011 defense-in-depth: unreachable via API-supplied filenames after sanitization steps 1-5`).

**Naive blacklist approaches are INSUFFICIENT**: do NOT rely on string-stripping `../` patterns alone — such blacklists are bypassable. The algorithm above is the required standard mitigation (research §4 of `.factory/research/issue-576-attachments-api-2026-07-15.md`, VERIFIED HIGH; OWASP/PortSwigger/CWE-31/22 first-principles).

**Unit test coverage required**: at minimum: `../../etc/passwd`, `/etc/passwd`, `C:\Windows\system32\foo.exe`, `"."`, `".."`, empty string, NUL-containing string, a normal filename, a filename exceeding 255 bytes, a filename containing `:` (Windows drive path), `"CON"` (Windows device name → `Some("CON")`), `"NUL"` (Windows device name → `Some("NUL")`), `"COM1"` (Windows device name → `Some("COM1")`), and `"nul.txt"` (Windows device name with extension → `Some("nul.txt")`), and a filename containing a multi-byte UTF-8 codepoint at the truncation boundary (e.g., a 214-byte ASCII prefix followed by a 3-byte UTF-8 char `"é"` — the char must be dropped, not split, so the output is the 214-byte prefix without truncation artifact). The test matrix confirms that `sanitize_attachment_filename` returns `Some(name)` for device names — the call-site device-name escape (SEC-576-001 caller note above, not this function) is what prevents on-disk device-name collisions on Windows for both batch (SHA-1 prefix) and single-id bare (explicit `_`-prefix escape at call site) paths.

**VP-576-001**: `sanitize_attachment_filename` property-based test — for every input in the required test matrix (BC-2.7.011 "Unit test coverage required" list): assert (1) no `Some(name)` result contains `/`, `\`, `:`, or a NUL byte; (2) `Some(name)` length in bytes is ≤ 214; (3) all `Some(name)` values are valid UTF-8 (no truncated multi-byte codepoints — `std::str::from_utf8` succeeds); (4) the specific cases `"."`, `".."`, empty string, and NUL-byte inputs each return `None`; (5) `"../../etc/passwd"` returns `Some("passwd")`; (6) `"/etc/passwd"` returns `Some("passwd")`; (7) a 214-byte ASCII prefix + 3-byte UTF-8 char returns `Some(214-byte prefix)` (char dropped, not split). Additional containment assertion for any `Some(name)`: `resolved_dir.join(&name).starts_with(&resolved_dir)` must hold for any `out_dir = TempDir::new()`. Pins BC-2.7.011 steps 1–5 and the defense-in-depth containment check. P14-007.

**Display sanitization for terminal output (SEC-576-011 — CWE-116)**: When any server-supplied attachment `filename` value is written to a TTY (confirmation prompts, collision-skip warnings, degenerate-name warnings, table cells, or any other human-readable stderr/stdout) — distinct from the disk-write path governed by `sanitize_attachment_filename` above — ALL of the following characters MUST be replaced with `?` before writing: (1) ASCII control characters in the byte range 0x00–0x1F and 0x7F; (2) Unicode bidirectional controls U+202A..U+202E (LRE/RLE/PDF/LRO/RLO) and U+2066..U+2069 (LRI/RLI/FSI/PDI); (3) Unicode line/paragraph separators U+2028 and U+2029; (4) NEL U+0085. This prevents terminal injection via `\r` (cursor-to-start overwrite of the visible prompt or warning text), ANSI escape sequences, and bidi-override visual reordering of displayed filenames in confirmation prompts. **Implementation form**: match on `char` values (Rust chars, not bytes) so multi-byte UTF-8 sequences are handled correctly; each matched char is replaced with a single `?`. The sanitization is display-only: the RAW value continues to be used for disk writes (the `sanitize_attachment_filename` pipeline above), JSON output (`downloaded[].filename`, attachment list array), and all Jira API calls. The `--no-color` flag controls only `jr`'s own ANSI output and does NOT strip attacker-injected control characters from displayed filenames. **Implementation note**: a `display_sanitize_filename(name: &str) -> String` helper function (or equivalent inline sanitization) MUST be applied at every call site that echoes a server-supplied filename to stderr or stdout in human mode. **Unit test mandate**: the `display_sanitize_filename` test set MUST include at least one bidi case (U+202E RIGHT-TO-LEFT OVERRIDE → `?`), one separator case (U+2028 LINE SEPARATOR → `?`), and NEL (U+0085 → `?`), in addition to ASCII control character coverage. **Stderr-clause taxonomy (§2.7 taxonomy, P25/P30)**: display sanitization applies in human mode only; it is not a new hint or error class — it modifies the display channel of existing warnings and prompts already classified in this taxonomy. JSON mode paths already carry RAW values by spec, so display sanitization has no JSON-mode interaction. **Earliest consumer: S1** (Story 1 — first surface to write server-supplied filenames to human-readable output; S1 story-writers must apply display-sanitization to attachment list table cells (BC-2.7.001); S3 and S4 story-writers must allocate display-sanitization at confirmation prompt call sites per DEC-184 R3.13). Cross-referenced from: BC-2.7.008 Overwrite behavior (collision-skip warnings), BC-2.7.010 degenerate-name warning, BC-3.9.015 step 1 (delete confirmation prompt), BC-3.9.017 step 2 (`--replace-existing` prompt). **Scope**: the sanitization covers ASCII controls (0x00–0x1F, 0x7F) plus the enumerated Unicode injection vectors above (bidi controls U+202A..U+202E and U+2066..U+2069, line/paragraph separators U+2028/U+2029, NEL U+0085) — a closed enumerated set. Remaining Unicode confusables and homoglyphs — non-control characters that may visually resemble other glyphs — are explicitly OUT of scope: visual spoofing via lookalike glyphs does not constitute a terminal-injection vector (no cursor movement, no control-sequence injection, no bidi-override reordering effect), and expanding to confusables would not close a meaningful attack surface while substantially increasing implementation complexity and false-positive risk. The enumeration remains closed.

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; research §4 CWE-22 VERIFIED HIGH; DEC-179 SQ-1 resolved; OWASP/CWE-22/CWE-31 first-principles); SEC-576-001 (CWE-22 Windows device-name caller note + unit test matrix added 2026-07-15); SEC-576-002 (CWE-22 corrected two-step containment check procedure added 2026-07-15); SEC-576-007 (trailing-whitespace/dot strip step 5.5 added 2026-07-15); P14-007 (VP-576-001 added); P25-002 (containment step-1 case (c) reworded — pure does-not-apply exclusion for `--out <PATH>`: trusted operator input; neither step 1 nor step 2 applies to `--out`-supplied paths); v1.3.80 — SEC-576-011 (CWE-116: display-sanitization clause added — distinct display-channel requirement from disk-write pipeline; covers all TTY output of server-supplied filenames; earliest consumer S2; cross-referenced from BC-2.7.008, BC-2.7.010, BC-3.9.015, BC-3.9.017); v1.3.81 — r43 micro-fix round: earliest consumer corrected S2→S1 (BC-2.7.001 list table cells ship with S1 per prd-delta Scope table; NEW-576-V3-001); S3 added to allocation guidance sentence alongside S4 (GAP-R43-002); Unicode bidi/line-terminator accepted-residual scope note appended (NEW-576-V3-002); v1.3.94 — PRE-F4-UNICODE-DISPLAY-SANITIZATION (human ruling 2026-07-17 DISCHARGED): display-sanitization character set extended beyond ASCII — Unicode bidi controls U+202A..U+202E and U+2066..U+2069, line/paragraph separators U+2028/U+2029, and NEL U+0085 added to the enumerated set; implementation form specified (char-level matching, not bytes); unit-test mandate added (U+202E/U+2028/U+0085 required cases); scope note REPLACED with closed-enumeration scope statement — confusables/homoglyphs OUT of scope with rationale (not a terminal-injection vector)

---

#### BC-2.7.012: `attachment download` on unknown KEY or unknown AID → exit 64 with informative error

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_download (implementation pending — SOH-ATTACHMENTS-1 Story 2); src/api/jira/attachments.rs::get_attachment_content (implementation pending)
**Subject**: Issue read

**Unknown issue key** (batch paths only — `--all`/`--newest`; the `--id` path does not server-verify KEY per BC-2.7.007): when `<KEY>` does not exist or is inaccessible, `GET /rest/api/3/issue/{key}?fields=attachment` returns 404. Handler exits 64: `"Issue <KEY> not found or not accessible."`

**Unknown attachment ID**: when `--id <AID>` references a non-existent attachment, `GET /rest/api/3/attachment/{id}` (metadata step 1, per BC-2.7.007 two-step wire path) returns 404 → handler exits 64: `"Attachment <AID> not found or not accessible."` (canonical not-found string). A 403 response instead exits 1: `"Permission denied: cannot access attachment <AID>."` (403 = exists-but-inaccessible, not missing; consistent with 403 = exit 1 across all attachment operations).

**404 body-surfacing asymmetry (deliberate read-vs-write divergence)**: A 404 from the download metadata endpoint (`GET /rest/api/3/attachment/{id}`) emits the canonical string ONLY — the Jira error body is NOT appended. This diverges from `attachment delete` (BC-3.9.008), where a 404 surfaces the Jira error body per DEC-168. Rationale: delete is a write operation targeting a specific user-named resource (DEC-168: 404 on a targeted delete is a user error requiring the Jira body context); download metadata fetch is a read operation where the canonical string is sufficient and the Jira body would add no actionable information.

**Match-by-ID invariant** (JRACLOUD-96384 + JRACLOUD-78388, both confirmed in research §6): attachment operations MUST identify attachments by their numeric `id`, not by `filename`. Multiple attachments with the same `filename` on one issue are legal in Jira (JRACLOUD-96384); filename-based matching is ambiguous and unreliable. There is also no reliable REST mapping from a comment to the attachments it contains (JRACLOUD-78388). `--id <AID>` is the sole selector for single-file download operations.

**Error path taxonomy**:

| Condition | Exit code | stderr |
|-----------|-----------|--------|
| Invalid `--id` AID (non-numeric, e.g. path-traversal) | 64 | `"invalid attachment id: '<VALUE>' (must be numeric)"` (no HTTP) |
| KEY 404 (batch paths only — `--id` does not server-verify KEY per BC-2.7.007) | 64 | `"Issue <KEY> not found or not accessible."` |
| KEY 403 (batch paths only — `--all`/`--newest`) | 1 | `"Permission denied: cannot access issue <KEY>."` |
| AID 404 from metadata endpoint (`GET /attachment/{id}`) | 64 | `"Attachment <AID> not found or not accessible."` |
| AID 403 from metadata endpoint (`GET /attachment/{id}`) | 1 | `"Permission denied: cannot access attachment <AID>."` |
| KEY or AID 401 | 2 | Not authenticated + `jr auth login` hint |
| KEY or AID 5xx | 1 | `API error (<N>)` (single mode; batch mode: per-file fail-soft per BC-2.7.008) |
| Network error | 1 | Connectivity hint (single mode; batch mode: per-file fail-soft per BC-2.7.008) |
| Disk full (ENOSPC/EDQUOT; `ErrorKind::StorageFull` \| `QuotaExceeded`) | 1 | `Disk full: not enough space to write <dest>: <os_error>. Free up disk space and try again.` (single mode; batch mode: per-file fail-soft per BC-2.7.008) |
| Permission denied (EACCES / read-only FS; `ErrorKind::PermissionDenied` \| `ReadOnlyFilesystem`) | 1 | `Permission denied: cannot write to <dir> (writing <dest>): <os_error>. Check directory permissions and try again.` (single mode; batch mode: per-file fail-soft per BC-2.7.008) |
| Other OS write error (generic fallback) | 1 | `Failed to write <dest>: <os_error>.` (single mode; batch mode: per-file fail-soft per BC-2.7.008) |

**Disk-write error detection and classification** (F5-R5-001): detection is via `e.kind()` on the raw `std::io::Error` at **all four** io sites (`File::create` temp, `write_all` chunk, `flush`, `rename`) inside `stream_to_file`, so both single-mode (exit 1) and batch-mode (per-file fail-soft warning) paths benefit from one chokepoint. `flush` is included as a distinct io site because ENOSPC can surface at flush time on delayed-allocation filesystems (e.g. Linux ext4 with delayed allocation, where the kernel defers disk-full detection until dirty pages are committed to disk — ENOSPC does not fire at `write_all` time but at `flush` time). `<dest>` is the **final destination path** (NOT the internal `tmp_<hex>` temp path) — all four io sites unified on the same display helper already used in the `rename` error branch; the server-supplied filename portion of `<dest>` is display-sanitized (CWE-116, BC-2.7.011) before writing to TTY; the parent directory component is rendered verbatim. `<dir>` = `final_path.parent()`. `<os_error>` = `std::io::Error::Display` (e.g. `No space left on device (os error 28)`). **`ErrorKind` stability at MSRV 1.85**: `StorageFull` stable since Rust 1.83.0; `QuotaExceeded` stable since Rust 1.85.0; `ReadOnlyFilesystem` stable since Rust 1.83.0; `PermissionDenied` stable since Rust 1.0; no `#[cfg]` required — cross-platform: Windows `ERROR_DISK_FULL` (112) → `StorageFull`, `ERROR_ACCESS_DENIED` (5) → `PermissionDenied`. **Testing**: extract a **pure classifier** `fn classify_write_error(kind: io::ErrorKind, dest_display: &str, dir_display: &str, os_err: &str) -> String` and unit-test with synthetic `io::Error::from(ErrorKind::X)` values, one per branch: `StorageFull`, `QuotaExceeded`, `PermissionDenied`, `ReadOnlyFilesystem`, generic fallback (`ErrorKind::Other`). Use a **non-exhaustive `_ =>` arm** in the classifier — do NOT exhaustively match `ErrorKind` (it is `#[non_exhaustive]` and intended to grow). Post-merge Trace refresh obligation: once `classify_write_error` is implemented, update the `**Source**:` field to cite `src/cli/issue/attachments.rs::classify_write_error`. **P9-001 reconciliation (FIX-F5-010)**: on Windows, `rename`-to-existing returns `ErrorKind::PermissionDenied` — the `(writing <dest>)` parenthetical in the permission-denied prefix ensures the display-sanitized destination filename appears in rename-failure errors, satisfying BC-2.7.007 P9-001 (CWE-116).

**INFO (F5-R6-002)**: mid-stream body-read abort (HTTP 200 response has started streaming but the connection drops before all chunks arrive) surfaces as a generic `"stream error: {e}"` exit 1 message — this is a distinct sub-case from the content-GET `NetworkError` row in the taxonomy table above (which covers failure-to-connect or connection drop before the first byte). The two cases produce different error messages: the NetworkError row produces `"Could not reach <host> — check your connection"` (via `JrError::NetworkError`); the mid-stream abort produces `"stream error: {e}"` (via the `bytes_stream()` chunk error arm in `stream_to_file`). This wording divergence is accepted — the mid-stream abort is classified as a streaming I/O error, not a network-connectivity error, and does not route through `classify_write_error`.

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design; research §6 JRACLOUD-96384/-78388 VERIFIED); P21-006 (KEY-404 batch-paths-only annotation — `--id` does not server-verify KEY per BC-2.7.007); P22-003 (body prose "Unknown issue key" sentence prepended with batch-only caveat: batch paths only — `--all`/`--newest`; `--id` does not server-verify KEY per BC-2.7.007); P26-001 (KEY-403 batch-paths-only row added to error table — mirrors BC-2.7.006 P15-005 row; error-taxonomy row 95 issue-GET sub-variant citation re-pointed to BC-2.7.012); v1.3.102 — F5-R5-001 research-backed amendment (2026-07-24): disk-write error rows amended to HYBRID shape per `.factory/research/f5-r5-001-disk-error-taxonomy-2026-07-24.md` (friendly prefix + `<os_error>` + remediation hint); `<dest>` = final path not `tmp_<hex>`; `ErrorKind` detection at all three io sites in `stream_to_file` (implementation pending — SOH-ATTACHMENTS-1 Story 2); MSRV-1.85 stability confirmed; pure classifier fn unit-test mandate added; v1.3.103 — FIX-F5-010 Windows CI collision: permission-denied row amended — `(writing <dest>)` parenthetical added after `<dir>` so rename-failure errors include the display-sanitized destination filename; P9-001 reconciliation note added to classification paragraph (BC-2.7.007 P9-001 CWE-116); v1.3.104 — F5-R6-001: io-site count corrected three→four (add `flush`; delayed-allocation rationale added: ENOSPC can surface at flush on Linux ext4 and similar filesystems where dirty pages are deferred); F5-R6-002: INFO note added — mid-stream body-read abort (`"stream error: {e}"` exit 1) is a distinct sub-case from the content-GET NetworkError row; accepted wording divergence documented

---

## Error Path Summary

All issue-read errors follow the universal pattern (BC-X.3.012):
- Network drop → exit 1 + stderr contains "Could not reach" (full literal: `Could not reach <host> — check your connection` — `src/error.rs::JrError::NetworkError`)
- 401 → exit 2 + `Not authenticated` + `jr auth login`
- 5xx → exit 1 + `API error (5xx)` + friendly message
- Never: `panic` in stderr

Pass 3 sources: `tests/issue_list_errors.rs`, `tests/issue_view_errors.rs`, `tests/comments.rs`

## Total BCs in this file: 72 individually-bodied (cumulative 114 incl. range-collapsed; see BC-INDEX.md)