---
document_type: consistency-report
round: 29
spec_version: 1.3.59
date: 2026-07-16
validator: cv-f2-576-r29 (fresh context, no prior round visibility)
verdict: GAPS-FOUND
bc_count: 657
holdout_count: 98
vp_count: 33
priority_checks: P19-001 (BC-2.7.002 BTreeMap-alphabetical), P19-002 (EC-2.7.001-2 JSON-mode hint), P19-003 (EC-2.7.007-5 best-effort MUST), P19-004 (BC-3.9.001 --dry-run annotation), P19-I1 (4-column vs 6-column note), K-1..K-4 keystones, echo-breaker audit (7 of 14 sentences), guard output
level: ops
version: "1.0"
status: gaps-found
producer: cv-f2-576-r29
timestamp: 2026-07-16T00:00:00
phase: 2
inputs:
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/holdout-scenarios.md"
  - ".factory/specs/prd/BC-INDEX.md"
  - ".factory/spec-changelog.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576-worklog.md"
  - ".factory/phase-f1-delta-analysis/impact-boundary-576.md"
  - "src/main.rs"
  - "src/cli/issue/list.rs"
  - "src/cli/board.rs"
  - "Cargo.toml"
input-hash: "427e12f"
traces_to: ".factory/specs/prd/BC-INDEX.md"
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 29 (post-P19 remediation)

**Spec version**: 1.3.59 | **BCs**: 657 | **Holdouts**: 98 | **VPs**: 33 | **Verdict**: GAPS-FOUND

---

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) — SOH-ATTACHMENTS-1 F2 |
| **Generated** | 2026-07-16T00:00:00 |
| **Generator** | cv-f2-576-r29 (fresh-context consistency validator, round 29) |
| **Artifacts Scanned** | 12 (bc-2-issue-read.md, bc-3-issue-write.md, holdout-scenarios.md, BC-INDEX.md, spec-changelog.md, prd-delta-576.md, prd-delta-576-worklog.md, impact-boundary-576.md, src/main.rs, src/cli/issue/list.rs, src/cli/board.rs, Cargo.toml) |
| **Focus** | Post-P19 adversary-pass remediation verification — spec v1.3.58 → v1.3.59 |
| **Prior round** | consistency-report-576-r28.md (CONSISTENT at v1.3.58) |

---

## Summary Table

| # | Check | Result |
|---|-------|--------|
| P19-001 | BC-2.7.002 BTreeMap-alphabetical ordering clause + example reorder | pass |
| P19-001 | BC-2.7.007 cross-reference updated to alphabetical order | pass |
| P19-001 | BC-3.9.009 key enumeration updated to alphabetical order | pass |
| P19-001 | BC-INDEX rows BC-2.7.002, BC-3.9.009 updated | pass |
| P19-001 | impact-boundary-576.md BC-2.7.002 table row updated | pass |
| P19-001 | bc-3 shape-table upload row key order byte-identical to BC-2.7.002 | pass |
| P19-001 | Deliberate non-change: worklog line 471 (historical record) | pass |
| P19-001 | Deliberate non-change: holdout fixtures are wire-payload mocks, not jr-output assertions | pass |
| P19-002 | EC-2.7.001-2 JSON-mode clause added with house-behavior citation | pass |
| P19-002 | list.rs ~580 eprintln! fires after output::print_output regardless of output_format | pass |
| P19-002 | board.rs ~283 eprintln! fires after output::print_output regardless of output_format | pass |
| P19-002 | EC-2.7.001-1 suppressed vs EC-2.7.001-2 unsuppressed asymmetry — rationale stated | pass |
| P19-003 | EC-2.7.007-5 downgraded to best-effort MUST; implementation note added | pass |
| P19-003 | src/main.rs:~393 citation resolves to tokio::select! ctrl_c arm | pass |
| P19-003 | Drop-guard inapplicability noted; panic=abort in release profile confirmed | pass |
| P19-003 | Not holdout/VP-pinned noted | pass |
| P19-004 | BC-3.9.001 --dry-run annotated with clap-requires constraint | pass |
| P19-004 | EC-3.9.020-6 consistent constraint description | pass |
| P19-I1 | BC-3.9.001 4-column vs 6-column table note added | pass |
| P19-I1 | 6-column enumeration matches BC-2.7.001 actual table spec verbatim | pass |
| BC-INDEX v6.19 | index_version v6.18→v6.19; BC-2.7.002, BC-3.9.001, BC-3.9.009 rows updated | pass |
| spec-changelog [1.3.59] | Entry present with correct summary and Changed Requirements | pass |
| prd-delta spec_version_after 1.3.59 | **GAP: prd-delta-576.md frontmatter still at 1.3.58; P19 section absent** | **FAIL** |
| NFR mislabel check | No artifact absorbed "33 NFRs" mislabel; all references say "VP count: 33" | pass |
| A-full-application | No non-deliberate id-first key sequence in canonical spec surfaces; no bare-MUST residue in EC-2.7.007-5 mirrors | pass (INFO-15) |
| K-1 | BC-2.7.002 ordering ↔ BC-3.9.009 ↔ shape-table row ↔ EC-2.7.007-7 manifest ↔ BC-3.9.010 — one coherent ordering story | pass |
| K-2 | EC-2.7.001-1 suppressed vs EC-2.7.001-2 unsuppressed asymmetry | pass |
| K-3 | EC-2.7.007-5 best-effort ↔ EC-2.7.007-4 tested-proxy ↔ H-NEW-ATTACHMENT-002 | pass |
| K-4 | BC-3.9.001 --dry-run annotation ↔ EC-3.9.020-6 | pass |
| Echo-breaker | 7 of 14 newly-authored P19 sentences audited — no behavioral over-claims | pass |
| Counts BC 657 / holdouts 98 / VP 33 | BC-INDEX frontmatter and guard confirm 657; holdout 98; VP 33 in all active spec artifacts | pass |
| Guard: check-spec-counts.sh | OK: all spec counts verified | pass |
| Guard: check-bc-cumulative-counts.sh | OK: all cumulative BC counts verified (657 total across 8 files) | pass |

**One behavioral GAP found** (MEDIUM): `prd-delta-576.md` frontmatter `spec_version_after` not updated; P19 section absent.

---

## Guard Script Output

### check-spec-counts.sh

```
OK: all spec counts verified.
```

### check-bc-cumulative-counts.sh

```
OK: all cumulative BC counts verified (657 total across 8 files; Surface H footer checked where present).
```

Both guards exit 0. No count drift.

---

## P19-001 — BC-2.7.002 BTreeMap-alphabetical key ordering

### BC-2.7.002 Ordering Clause and Example

**Quote-verified verbatim** (`bc-2-issue-read.md` BC-2.7.002 heading, line 569):

> `#### BC-2.7.002: \`attachment list <KEY> --output json\` shape — \`[{author, contentUrl, created, filename, id, mimeType, size}]\``

**Quote-verified** (BC-2.7.002 JSON example, lines 577–591):

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

Top-level key order: `author` < `contentUrl` < `created` < `filename` < `id` < `mimeType` < `size` — alphabetical. ✓  
`author` sub-object: `accountId` < `displayName` — alphabetical. ✓

**Quote-verified** (BC-2.7.002 ordering clause, line 602):

> `**JSON key ordering (BTreeMap-canonical — P19-001)**: the canonical attachment-object JSON shape has BTreeMap-ordered (alphabetical) keys at all depths: \`author\` < \`contentUrl\` < \`created\` < \`filename\` < \`id\` < \`mimeType\` < \`size\` at the top level; \`accountId\` < \`displayName\` within the \`author\` object. This is consistent with BC-3.9.010 (delete shapes, BTreeMap-ordered) and the EC-2.7.007-7 download manifest inner key ordering (\`filename\` < \`id\` < \`path\` < \`size\`). Implementation consequence: serialize via a type that yields alphabetical key order — e.g., a \`BTreeMap\`-backed serializer or \`serde_json::Map\` without the \`preserve_order\` feature (which is NOT enabled in this crate). Bare struct-declaration order does NOT guarantee alphabetical JSON emission.`

Ordering clause present with correct enumeration, consistent cross-references, and implementation consequence note. ✓

### BC-2.7.007 Cross-Reference

**Quote-verified** (`bc-2-issue-read.md` BC-2.7.007 step 1 description, line 719 tail):

> `(Curated \`jr\` output fields from BC-2.7.002: \`author\`, \`contentUrl\`, \`created\`, \`filename\`, \`id\`, \`mimeType\`, \`size\` — BTreeMap-alphabetical order per P19-001.)`

Updated to alphabetical order with P19-001 citation. ✓

### BC-3.9.009 Key Enumeration

**Quote-verified** (`bc-3-issue-write.md` BC-3.9.009, line 3465):

> `The attachment-object shape for each element is the **curated form** defined in BC-2.7.002: \`{author, contentUrl, created, filename, id, mimeType, size}\` (BTreeMap-alphabetical key order — P19-001).`

Key enumeration updated to alphabetical order with P19-001 citation. ✓

### BC-INDEX Rows

**Quote-verified** (`BC-INDEX.md` row BC-2.7.002, line 221):

> `| BC-2.7.002 | \`attachment list --output json\` returns array of attachment objects including \`contentUrl\` field; JSON render invariant #526 (\`output::render_json\`); closes #585 contentUrl surface; **BTreeMap-alphabetical key order at all depths: author < contentUrl < created < filename < id < mimeType < size** (P19-001) | — (SOH-ATTACHMENTS-1 F2; P19-001) | src/cli/issue/attachments.rs (pending S1) | HIGH |`

**Quote-verified** (`BC-INDEX.md` row BC-3.9.009, line 381):

> `| BC-3.9.009 | \`attachment upload --output json\`: array in curated form (BC-2.7.002: author, contentUrl, created, filename, id, mimeType, size — BTreeMap-alphabetical; \`self\` OMITTED, \`content\`→\`contentUrl\`); \`output::render_json\` required (#526 invariant); platform POST path only | — (SOH-ATTACHMENTS-1 F2; P19-001) | src/cli/issue/attachments.rs (pending S3) | HIGH |`

Both rows updated with alphabetical ordering and P19-001 citation. ✓

### impact-boundary-576.md BC-2.7.002 Row

**Quote-verified** (`impact-boundary-576.md`, line 136):

> `| BC-2.7.002 | \`attachment list --output json\` shape: \`[{author, contentUrl, created, filename, id, mimeType, size}]\` (BTreeMap-alphabetical — P19-001) |`

Row updated with alphabetical ordering and P19-001 citation. ✓

### bc-3 Shape-Table Upload Row — Byte-Identical Key Order Check

**Quote-verified** (`bc-3-issue-write.md` JSON Output Shape Contracts table, line 3215):

> `| \`attachment upload\` (platform POST path) | \`[{"author":{...},"contentUrl":"https://…/rest/api/3/attachment/content/10042","created":"2026-07-15T...","filename":"foo.pdf","id":"10042","mimeType":"application/pdf","size":43008}]\` | curated form (BC-2.7.002): \`"self"\` omitted, \`"content"\`→\`"contentUrl"\`; keys alphabetical; one element per file; BC-3.9.009 |`

Top-level key sequence in table row: `author`, `contentUrl`, `created`, `filename`, `id`, `mimeType`, `size` — alphabetical. Matches BC-2.7.002 example key ordering byte-for-byte at the top-level key sequence. ✓

### Deliberate Non-Changes

**Worklog line 471 (historical record)** (`prd-delta-576-worklog.md`, line 471):

> `| GAP-R11-006 | LOW | bc-3-issue-write.md | JSON Output Shape Contracts table -- upload row: self OMITTED, content renamed contentUrl, author included, alphabetical key order (id, filename, mimeType, size, created, author, contentUrl) | DONE |`

This is a historical worklog entry describing the key order as it stood at round R11, before P19-001 reordered to BTreeMap-alphabetical. This is a descriptive historical record of what was done in R11, not an expected-output assertion about jr's current behavior. The text "(id, filename, mimeType, size, created, author, contentUrl)" reflects the OLD key order at the time of R11. Correctly preserved; the worklog is an immutable audit trail. ✓

**Holdout fixtures at lines 2080–2081** (`holdout-scenarios.md`, H-NEW-ATTACHMENT-001 Call B setup):

> `2. Wiremock mounts \`GET /rest/api/3/issue/FOO-2?fields=attachment\` returning 200 with two attachment objects:`
> `   - \`{"id": "10001", "filename": "report.pdf", "size": 204800, "mimeType": "application/pdf", "created": "2026-07-01T10:00:00.000+0000", "author": {"displayName": "Alice"}}\``
> `   - \`{"id": "10002", "filename": "photo.png", "size": 51200, "mimeType": "image/png", "created": "2026-07-01T11:00:00.000+0000", "author": {"displayName": null}}\``

These objects show `"id"` first — the raw Jira API wire key ordering. These are **wire-payload mocks** in the wiremock setup step (Jira API response bodies injected by the test harness), NOT expected jr output assertions. The Expected B section (lines 2093–2098) tests for `report.pdf` and `photo.png` in table form and `"(anonymous)"` rendering — it checks neither JSON key order nor raw JSON output. id-first ordering in Jira's wire response is the live API convention; jr's curated output re-serializes in alphabetical order. No discrepancy. ✓

Similarly, `holdout-scenarios.md` line 2117 fixture: `{"id":"10001","filename":"notes.txt","size":12,"mimeType":"text/plain","content":"<JR_BASE_URL>/rest/api/3/attachment/content/10001"}` — explicitly described as "the attachment metadata" from `GET /rest/api/3/attachment/{id}` (step 1 of BC-2.7.007 two-step wire path). Wire-payload mock. ✓

**Result**: APPLIED ✓. All P19-001 changes correctly propagated. Deliberate non-changes confirmed correct.

---

## P19-002 — EC-2.7.001-2 JSON-Mode Filter-Count Hint Clause

**Quote-verified** (`bc-2-issue-read.md` EC-2.7.001-2, line 559):

> `**EC-2.7.001-2** (filter-count hint): when any \`--filter\` flag is active and reduces the displayed row count, a hint is emitted to stderr: \`"Showing N of M attachments."\` (N = filtered count, M = total from API). When no filter is active this hint is suppressed. **JSON mode**: the hint fires in \`--output json\` mode as well — emitted to stderr via \`eprintln!\` unconditionally after the JSON array is written to stdout. This mirrors the empirical house behavior in \`src/cli/issue/list.rs::handle_list\` (the \`eprintln!\` at ~line 580 fires after \`output::print_output\` regardless of \`output_format\`) and \`src/cli/board.rs::handle_view\` (~line 283). **Deliberate asymmetry with EC-2.7.001-1**: the zero-attachment hint from EC-2.7.001-1 IS suppressed in JSON mode (the empty \`[]\` array is self-describing and unambiguous); the filter-count hint here is NOT suppressed because a filtered JSON array gives no indication of the total — without the hint, a script would see a smaller array than expected with no context. (P19-002)`

JSON-mode clause added, source citations present, deliberate asymmetry documented. ✓

**Source-code citation verification** (`src/cli/issue/list.rs`, lines 574–592):

```rust
output::print_output(output_format, &headers, &rows, &issues)?;

if has_more && !all {
    let count_jql = crate::jql::strip_order_by(&effective_jql);
    match client.approximate_count(count_jql).await {
        Ok(total) if total > 0 => {
            eprintln!(
                "Showing {} of ~{} results. Use --limit or --all to see more.",
                issues.len(),
                total
            );
        }
        ...
    }
}
```

The `if has_more && !all` block fires AFTER `output::print_output`. It is NOT guarded by `output_format`. The eprintln! at ~line 580 fires regardless of output format. ✓

**Source-code citation verification** (`src/cli/board.rs`, lines 273–283):

```rust
output::print_output(output_format, &headers, &rows, &issues)?;

if has_more && !all {
    if board_type != "scrum" {
        ...
        match client.approximate_count(count_jql).await {
            Ok(total) if total > 0 => {
                eprintln!(
                    "Showing {} of ~{} results. Use --limit or --all to see more.",
                    issues.len(),
                    total
                );
```

eprintln! at ~line 283 fires after `output::print_output` without any `output_format` guard. ✓

**EC-2.7.001-1 suppressed (JSON mode)** (`bc-2-issue-read.md` EC-2.7.001-1, line 557):

> `**EC-2.7.001-1** (zero attachments): ... JSON mode: empty stdout \`[]\` per BC-2.7.002, no stderr, exit 0`

Zero-attachment hint IS suppressed in JSON mode — stated explicitly. ✓

**Result**: APPLIED ✓. JSON-mode clause added; source citations verified; asymmetry documented.

---

## P19-003 — EC-2.7.007-5 Best-Effort MUST + Implementation Note

**Quote-verified** (`bc-2-issue-read.md` EC-2.7.007-5, line 747):

> `**EC-2.7.007-5** (Ctrl+C / SIGINT mid-stream): best-effort MUST — temporary file (\`tmp_<random>\`) is deleted when possible; exit 130; no final path written. **Implementation-strategy note**: cleanup runs in the existing \`tokio::signal::ctrl_c()\` select! arm at \`src/main.rs:~393\` (the \`tokio::select!\` race that calls \`std::process::exit(130)\` on signal receipt); it does NOT run via \`Drop\` guards — the release profile uses \`panic = abort\` and \`std::process::exit()\` does not invoke destructors, so \`Drop\` is unreliable on the abort/signal path. The practical cleanup mechanism is explicit pre-exit deletion within the signal-handling code path. **Not holdout/VP-pinned**: this path is not deterministically testable in CI (signal timing dependent); the error-path cleanup (EC-2.7.007-4, H-NEW-ATTACHMENT-002) is the tested proxy for temp-file correctness. (P19-003)`

All four elements present: "best-effort MUST" downgrade ✓; tokio ctrl_c citation ✓; Drop-guard inapplicability note ✓; not holdout/VP-pinned note ✓.

**Source-code citation verification** (`src/main.rs`, lines 391–397):

```rust
tokio::select! {
    result = main_task => result,
    _ = tokio::signal::ctrl_c() => {
        eprintln!("\nInterrupted");
        std::process::exit(130);
    }
}
```

The `tokio::select!` at ~line 391 with the `ctrl_c()` arm calling `std::process::exit(130)` is exactly what EC-2.7.007-5 cites at `src/main.rs:~393`. Citation resolves. ✓

**panic=abort verification** (`Cargo.toml`, line 62):

```toml
[profile.release]
...
panic = "abort"
```

`panic = "abort"` confirmed in the release profile. The EC's claim that "`Drop` is unreliable on the abort/signal path" because of `panic = abort` is correctly licensed. ✓

**Result**: APPLIED ✓. EC-2.7.007-5 downgraded to best-effort; implementation note correct; citations verified.

---

## P19-004 — BC-3.9.001 `--dry-run` CLI-Flags Annotation

**Quote-verified** (`bc-3-issue-write.md` BC-3.9.001 CLI flags, line 3270):

> `**CLI flags** (pinned for e2e surface guard): \`<KEY>\` (positional, required); \`<FILE>...\` (positional, repeatable, 1+); \`--public\`; \`--internal\`; \`--yes\`; \`--replace-existing\`; \`--dry-run\` (requires \`--replace-existing\` — EC-3.9.020-6, clap \`requires\`, exit 2); \`--output json\`; \`--no-input\`; \`--profile <NAME>\`; \`--no-color\`.`

`--dry-run` annotated with `(requires --replace-existing — EC-3.9.020-6, clap requires, exit 2)`. ✓

**Quote-verified** (`bc-3-issue-write.md` EC-3.9.020-6, line 3879):

> `**EC-3.9.020-6** (\`upload --dry-run\` without \`--replace-existing\`): exit 2 (clap \`requires\` constraint); clap error to stderr; no application code reached.`

Constraint description consistent between BC-3.9.001 annotation and EC-3.9.020-6: clap `requires`, exit 2. ✓

**BC-INDEX row BC-3.9.001** (`BC-INDEX.md`, line 373):

> `| BC-3.9.001 | Platform upload \`POST /rest/api/3/issue/{key}/attachments\`; ... **\`--dry-run\` requires \`--replace-existing\` (EC-3.9.020-6, clap requires, exit 2)** (P19-004); **4-column upload echo table (Filename/Size/ID/Created) deliberately differs from 6-column list table** (P19-I1) |`

Both P19-004 and P19-I1 updates present in BC-INDEX row. ✓

**Result**: APPLIED ✓.

---

## P19-I1 — BC-3.9.001 4-Column vs 6-Column Table Note

**Quote-verified** (`bc-3-issue-write.md` BC-3.9.001, line 3251):

> `**Note (P19-I1)**: this 4-column upload echo table deliberately differs from the 6-column list table (BC-2.7.001: ID / Filename / Type / Size / Created / Author) — the upload echo surface is a minimal confirmation of what was just sent; the list surface is the full read metadata surface. JSON output: the curated array, pretty-printed via \`output::render_json\` (#526 invariant).`

**6-column enumeration verification** (`bc-2-issue-read.md` BC-2.7.001 table columns, lines 544–551):

```
| ID       | attachment.id       | Numeric string |
| Filename | attachment.filename | Raw as returned by Jira |
| Type     | attachment.mimeType | MIME type string |
| Size     | attachment.size     | Human-readable formatted |
| Created  | attachment.created  | ISO 8601 string |
| Author   | attachment.author.displayName | Falls back ... |
```

BC-2.7.001 actual columns in display order: ID, Filename, Type, Size, Created, Author — exactly six. The BC-3.9.001 P19-I1 note cites "BC-2.7.001: ID / Filename / Type / Size / Created / Author" — matches the actual column enumeration verbatim. ✓

**Result**: APPLIED ✓. 4-column note present; 6-column enumeration matches BC-2.7.001 exactly.

---

## GAP: prd-delta-576.md spec_version_after Not Updated

**GAP-P19-FWD-001 (MEDIUM)**

**Quote-verified** (`prd-delta-576.md` frontmatter):

```yaml
spec_version_after: 1.3.58
```

The P19 fix round advanced the spec version from 1.3.58 to 1.3.59. Every prior fix round (P14–P18) updated the `prd-delta-576.md` frontmatter `spec_version_after` field and appended a fix-round dispositions section. P19 did neither.

The spec-changelog `[1.3.59]` Changed Requirements section lists only three modified files:
- `bc-2-issue-read.md`
- `bc-3-issue-write.md`
- `BC-INDEX.md`

`prd-delta-576.md` is absent from that list — confirming the omission was not tracked. The file ends at line 356 with the P18 closing statement `"**BC count at this round: 657 (unchanged). Holdout count: 98 (unchanged). VP count: 33 (unchanged). Spec version: 1.3.58.**"` — no P19 section follows.

**Expected state**: `spec_version_after: 1.3.59` in frontmatter; P19 fix-round dispositions section appended with summary line "BC count at this round: 657 (unchanged). Holdout count: 98 (unchanged). VP count: 33 (unchanged). Spec version: 1.3.59."

**Behavioral impact**: zero — no behavioral contract is mis-stated. The prd-delta is a tracking document, not an implementation authority.

**Severity**: MEDIUM (tracking document out of sync; missing official P19 disposition record).

---

## NFR vs VP Mislabel Sweep

The task notes the adversary-576-p19 fix-round report contained a slip using "NFRs" for the 33 verification points (correct label is VPs; the NFR catalog has 42 items). No spec artifact absorbed this mislabel.

**Evidence**: grep across all P19-touched artifacts (`bc-2-issue-read.md`, `bc-3-issue-write.md`, `BC-INDEX.md`, `spec-changelog.md`) for "NFRs" or "33 NFR":

- `spec-changelog.md` [1.3.59] entry: no "33 NFRs" phrase; count rows absent from Impact Assessment table (INFO-14 below).
- `bc-3-issue-write.md` footer (line 3887): "0 new BCs"; "spec v1.3.59" — no count statement at all.
- `BC-INDEX.md` frontmatter: no VP/NFR count claim.
- `bc-2-issue-read.md` frontmatter: no VP/NFR count claim.
- `prd-delta-576.md` last count statement (line 356): "VP count: 33 (unchanged)" — correct label. ✓

No artifact absorbed the "NFR" mislabel. ✓

---

## Echo-Breaker Audit

The P19 fix round authored new text in three modified artifacts. At least 7 of the 14 newly-authored sentences are audited below, with special scrutiny on sentences 3, 5, 6, 10, and 11 as directed.

### Sentence 1: BC-2.7.002 alphabetical key list (bc-2 line 602)

**New text**: `author < contentUrl < created < filename < id < mimeType < size at the top level; accountId < displayName within the author object`

**Licensing basis**: The JSON example (lines 577–591) is the authoritative shape definition. Alphabetical check: a(uthor) < c(ontentUrl) < c(reated) < f(ilename) < i(d) < m(imeType) < s(ize). For `contentUrl` vs `created`: "contentU" < "create" — `contentUrl` comes before `created` (ASCII `U` = 85 < `a` = 97, comparing character 7 after "content" vs "create": `U` < `e`). Correct. `accountId` < `displayName` (a < d). Correct.

**Assessment**: All orderings are strictly alphabetical. No over-claim. ✓

### Sentence 2: BC-2.7.007 cross-reference alphabetical order (bc-2 line 719)

**New text**: `author, contentUrl, created, filename, id, mimeType, size — BTreeMap-alphabetical order per P19-001`

**Licensing basis**: BC-2.7.002 ordering clause (sentence 1 above). This sentence is a cross-reference reciting the canonical list. No independent factual claim beyond what BC-2.7.002 establishes.

**Assessment**: Consistent with BC-2.7.002. No over-claim. ✓

### Sentence 3 (SPECIAL SCRUTINY): preserve_order NOT enabled

**New text**: `serde_json::Map without the preserve_order feature (which is NOT enabled in this crate)`

**Licensing basis**: Cargo.toml, line 27: `serde_json = "1"` — no `features` array. The serde_json crate's `preserve_order` feature is an opt-in feature that preserves insertion order in `Map`. Without explicit `features = ["preserve_order"]`, it is NOT enabled. Verified directly in Cargo.toml.

**Assessment**: Claim is correct and directly verifiable. No over-claim. ✓

### Sentence 4: BC-3.9.009 key enumeration (bc-3 line 3465)

**New text**: `{author, contentUrl, created, filename, id, mimeType, size} (BTreeMap-alphabetical key order — P19-001)`

**Licensing basis**: BC-2.7.002 authority (BC-3.9.009 explicitly cross-references it as the canonical attachment-object shape). Same alphabetical ordering as BC-2.7.002.

**Assessment**: Consistent with BC-2.7.002. No over-claim. ✓

### Sentence 5 (SPECIAL SCRUTINY): list.rs source citation (bc-2 line 559)

**New text**: `the eprintln! at ~line 580 fires after output::print_output regardless of output_format`

**Licensing basis**: `src/cli/issue/list.rs` lines 574–592 (read verbatim):
- Line 574: `output::print_output(output_format, &headers, &rows, &issues)?;`
- Lines 576–593: `if has_more && !all { ... eprintln!(...) ... }` — condition checks only `has_more && !all`, NOT `output_format`.

The eprintln! is unconditional on `output_format`. Citation line ~580 is accurate (the eprintln! is at lines 580–584 within the block). No output_format guard wraps it.

**Assessment**: Citation accurate. No over-claim. ✓

### Sentence 6 (SPECIAL SCRUTINY): board.rs source citation (bc-2 line 559)

**New text**: `src/cli/board.rs::handle_view (~line 283)`

**Licensing basis**: `src/cli/board.rs` lines 273–287 (read verbatim):
- Line 273: `output::print_output(output_format, &headers, &rows, &issues)?;`
- Lines 275–287: `if has_more && !all { if board_type != "scrum" { ... eprintln!(...) at line 283 ... } }` — condition checks `has_more && !all` and `board_type != "scrum"` (board-type guard), NOT `output_format`.

The eprintln! at line 283 fires after `output::print_output`. No `output_format` guard wraps it. Citation resolves.

**Assessment**: Citation accurate. No output_format guard. ✓

### Sentence 7: EC-2.7.001-1 suppressed in JSON mode (bc-2 line 557)

**New text** (EC-2.7.001-1 update): `JSON mode: empty stdout [] per BC-2.7.002, no stderr, exit 0`

**Licensing basis**: An empty `[]` array is unambiguous; the zero-attachment hint `"No attachments on <KEY>."` adds no information when the JSON output is empty. The deliberate asymmetry note in EC-2.7.001-2 cites the self-describing character of the empty array as the rationale.

**Assessment**: Correct. The empty-array self-description is the license for suppression. No over-claim. ✓

### Sentence 8: EC-2.7.007-5 "best-effort MUST" downgrade (bc-2 line 747)

**New text**: `best-effort MUST — temporary file (tmp_<random>) is deleted when possible; exit 130; no final path written`

**Licensing basis**: The original constraint (MUST cleanup on Ctrl+C) cannot be deterministically enforced when `std::process::exit()` is called before Drop runs (confirmed by panic=abort + process::exit semantics). "Best-effort" is the correct qualifier for behavior that depends on an explicit pre-exit code path, not a language guarantee.

**Assessment**: Downgrade is correctly scoped and licensed. "Best-effort MUST" is a weaker but not contradictory claim. ✓

### Sentence 9: Implementation note (bc-2 line 747)

**New text**: `cleanup runs in the existing tokio::signal::ctrl_c() select! arm at src/main.rs:~393`

**Licensing basis**: `src/main.rs` lines 391–397 (read verbatim):
```rust
tokio::select! {
    result = main_task => result,
    _ = tokio::signal::ctrl_c() => {
        eprintln!("\nInterrupted");
        std::process::exit(130);
    }
}
```
The `tokio::select!` occupies lines 391–397; the `ctrl_c()` arm body with `std::process::exit(130)` is at line 395. Citation `~393` is accurate (within the `tokio::select!` block containing the ctrl_c arm). ✓

**Assessment**: Citation resolves to the correct code region. ✓

### Sentence 10 (SPECIAL SCRUTINY): Drop-guard inapplicability (bc-2 line 747)

**New text**: `it does NOT run via Drop guards — the release profile uses panic = abort and std::process::exit() does not invoke destructors, so Drop is unreliable on the abort/signal path`

**Licensing basis**:
1. `panic = abort` in `[profile.release]` — confirmed in Cargo.toml line 62: `panic = "abort"`. ✓
2. `std::process::exit()` does not invoke destructors — standard Rust specification: `std::process::exit` terminates the process immediately, running only shutdown handlers registered via `atexit`. Rust `Drop` destructors are NOT run. This is documented in the Rust standard library. ✓

**Assessment**: Both factual claims verified. No over-claim. ✓

### Sentence 11 (SPECIAL SCRUTINY): panic=abort release profile (bc-2 line 747)

**New text**: `the release profile uses panic = abort`

**Licensing basis**: Cargo.toml `[profile.release]` block includes `panic = "abort"` at line 62. Verified directly.

**Assessment**: Claim is correct. ✓

---

**Echo-breaker audit result**: All 11 audited sentences are grounded in their licensing sources. No over-claims found. The implementation-note sentences (5/6/10) were verified against actual source code; the panic=abort claim (sentences 10/11) was verified against Cargo.toml; the preserve_order claim (sentence 3) was verified against Cargo.toml.

---

## Keystone Coherence Checks

### K-1: BC-2.7.002 ordering clause ↔ BC-3.9.009 ↔ shape-table row ↔ EC-2.7.007-7 manifest ordering ↔ BC-3.9.010 delete shapes — ONE coherent ordering story

| Element | Key order claim | Location |
|---------|----------------|----------|
| BC-2.7.002 ordering clause | `author < contentUrl < created < filename < id < mimeType < size` (BTreeMap-alphabetical) | bc-2 line 602 |
| BC-3.9.009 key enumeration | `{author, contentUrl, created, filename, id, mimeType, size}` — BTreeMap-alphabetical (P19-001) | bc-3 line 3465 |
| bc-3 shape-table upload row | `{"author":{...},"contentUrl":...,"created":...,"filename":...,"id":...,"mimeType":...,"size":...}` | bc-3 line 3215 |
| EC-2.7.007-7 manifest ordering | inner keys: `filename < id < path < size` (alphabetical) — cited from BC-2.7.002 ordering clause | bc-2 line 602 cross-ref |
| BC-3.9.010 delete shapes | "two keys, alphabetical (BTreeMap-ordered per project convention)" | bc-3 line 3486 |

All surfaces state BTreeMap-alphabetical ordering. Cross-references are mutually consistent. ONE coherent ordering story throughout the attachment JSON spec. ✓

**K-1 COHERENT ✓**

---

### K-2: EC-2.7.001-1 suppressed vs EC-2.7.001-2 unsuppressed asymmetry — rationale stated, no contradiction

| Element | JSON-mode behavior | Rationale | Location |
|---------|-------------------|-----------|----------|
| EC-2.7.001-1 (zero attachments) | Hint IS suppressed — empty stdout `[]`, no stderr | "empty `[]` array is self-describing and unambiguous" | bc-2 line 557 |
| EC-2.7.001-2 (filter-count hint) | Hint is NOT suppressed — `eprintln!` after JSON array to stdout | "a filtered JSON array gives no indication of the total — without the hint, a script would see a smaller array than expected with no context" | bc-2 line 559 |

The two cases have different JSON semantics: an empty `[]` is unambiguous; a filtered-nonempty `[...]` is ambiguous without total count. The asymmetry is rationale-grounded and non-contradictory. ✓

**K-2 COHERENT ✓**

---

### K-3: EC-2.7.007-5 best-effort ↔ EC-2.7.007-4 tested-proxy ↔ H-NEW-ATTACHMENT-002 — coherent

| Element | Claim | Location |
|---------|-------|----------|
| EC-2.7.007-5 | best-effort MUST on SIGINT cleanup; "tested proxy" is EC-2.7.007-4 | bc-2 line 747 |
| EC-2.7.007-4 | error mid-stream cleanup (deterministic) | bc-2 line 745 area |
| H-NEW-ATTACHMENT-002 | temp file absent on error; atomic rename | holdout-scenarios.md line 2108 |

EC-2.7.007-5 explicitly calls EC-2.7.007-4 the "tested proxy for temp-file correctness." H-NEW-ATTACHMENT-002 pins EC-2.7.007-4 (error cleanup). The SIGINT path (EC-2.7.007-5) is NOT holdout-pinned — the best-effort qualifier licenses this absence. Coherent; no contradiction between best-effort and tested-proxy framing. ✓

**K-3 COHERENT ✓**

---

### K-4: BC-3.9.001 --dry-run annotation ↔ EC-3.9.020-6 — consistent constraint description

| Element | Constraint | Location |
|---------|-----------|----------|
| BC-3.9.001 CLI flags | `--dry-run (requires --replace-existing — EC-3.9.020-6, clap requires, exit 2)` | bc-3 line 3270 |
| EC-3.9.020-6 | `exit 2 (clap requires constraint); clap error to stderr; no application code reached.` | bc-3 line 3879 |

Both describe clap `requires`, exit 2, and reference each other. No contradiction. ✓

**K-4 COHERENT ✓**

---

## Cross-Reference Validation

### BC Counts

| Source | bc-2 definitional | bc-2 total_bcs | bc-3 definitional | bc-3 total_bcs | Grand Total |
|--------|-------------------|-----------------|-------------------|-----------------|-------------|
| Frontmatter | 64 | 106 | 111 | 140 | 657 |
| CANONICAL-COUNTS.md | 64 | 106 | 111 | 140 | 657 |
| Guard output | verified | — | verified | — | 657 |

P19 added 0 new BCs. PASS ✓

### Holdout Counts

| Source | Count | Status |
|--------|-------|--------|
| `holdout-scenarios.md` frontmatter `total_holdouts` | 98 | PASS ✓ |
| `prd-delta-576.md` frontmatter `holdout_count_after` | 98 | PASS ✓ |
| `spec-changelog.md` [1.3.58] Impact table (most recent explicit count) | "Holdout count: 98 (unchanged)" | PASS ✓ |

P19 added 0 holdouts. 98 unchanged. PASS ✓

### VP Counts

| Source | VP count reference | Status |
|--------|-------------------|--------|
| `prd-delta-576.md` P18 fix-round closing line | "VP count: 33 (unchanged)" | PASS ✓ |
| `spec-changelog.md` [1.3.58] Impact table | "VP count: 33 (unchanged)" | PASS ✓ |
| `bc-3-issue-write.md` preamble | VP count: 33 | PASS ✓ |

---

## Spec Version Surface Verification

| Artifact | Spec version shown | Status |
|----------|--------------------|--------|
| `spec-changelog.md` | `[1.3.59] - 2026-07-16` entry present | PASS ✓ |
| `bc-3-issue-write.md` footer (line 3887) | "spec v1.3.59" in P19 last-updated note | PASS ✓ |
| `bc-2-issue-read.md` trace header (line 14) | "spec v1.3.59" in P19 trace line | PASS ✓ |
| `BC-INDEX.md` `last_updated` | P19 adversary fix round; spec v1.3.59; BC-INDEX v6.19 | PASS ✓ |
| `prd-delta-576.md` frontmatter `spec_version_after` | **1.3.58** — not updated to 1.3.59 | **FAIL (GAP-P19-FWD-001)** |
| `STATE.md` `current_step` | "spec v1.3.56" (still at P16) | STALE (INFO-8 carries forward) |

---

## INFO Ledger Status

### INFO-1 (carry-forward R21–R29) — RE-VERIFIED

**Quote** (`bc-2-issue-read.md` lines 787–791):
```
787: **EC-2.7.008-6** (...)
788: [blank]
789: [blank]
790: [blank]
791: **EC-2.7.008-7** (...)
```
Three blank lines between EC-2.7.008-6 and EC-2.7.008-7 (two more than the single blank line used elsewhere). Not introduced or worsened by P19. Non-blocking formatting issue.

**Status**: CARRY-FORWARD ✓ (re-verified)

---

### INFO-2 (carry-forward R21–R29) — RE-VERIFIED

**Quote** (`bc-2-issue-read.md` lines 782, 786):
- Line 782: `**EC-2.7.008-2** (directory does not exist): ... exit 64 before any download: "Output directory does not exist: <DIR>". The handler does NOT create the directory automatically.`
- Line 786: `**EC-2.7.008-5** (\`--out-dir\` path does not exist): supersedes EC-2.7.008-2 wording clarification — same exit 64: "Output directory does not exist: <DIR>".`

EC-2.7.008-5 supersedes EC-2.7.008-2, but both are retained. The "wording clarification" note makes EC-2.7.008-2 redundant. Not introduced or worsened by P19. Non-blocking.

**Status**: CARRY-FORWARD ✓ (re-verified)

---

### INFO-3 (carry-forward R21–R29) — RE-VERIFIED

**Quote** (`bc-2-issue-read.md` BC-2.7.012 error table, line 936):
> `| KEY or AID 5xx | 1 | \`API error (<N>)\` (single mode; batch mode: per-file fail-soft per BC-2.7.008) |`

Combined-scope row covers both KEY 5xx and AID 5xx in one row. Correct but imprecise (the AID 5xx path differs from the KEY 5xx path mechanically). Not introduced or worsened by P19. Non-blocking.

**Status**: CARRY-FORWARD ✓ (re-verified)

---

### INFO-4 (carry-forward R22–R29) — RE-VERIFIED

**Quote** (`holdout-scenarios.md` H-NEW-ATTACHMENT-003 BC refs, line 2203):
> `**BC refs**: BC-2.7.008 (primary), BC-2.7.010 (collision prefix), BC-2.7.011 (sanitization pipeline), BC-2.7.008 EC-2.7.008-7 (fail-soft-continue, Call B)`

Call B2 is described in the "Why hidden" section (line 2199) as exercising "EC-2.7.008-7 JSON-mode path (exit 1 + partial manifest emitted)" but the BC refs footer at line 2203 does NOT explicitly list `BC-2.7.008 EC-2.7.008-6` for Call B2. P18-004 made B2's `"<path>"` placeholder semantically grounded (snapshot-redaction guidance), but the BC refs footer omission remains. Not introduced or worsened by P19. Non-blocking.

**Status**: CARRY-FORWARD ✓ (re-verified)

---

### INFO-5 — RESOLVED (P14)

Carry-forward audit note only.

**Status**: RESOLVED (P14)

---

### INFO-6 (carry-forward R23–R29) — RE-VERIFIED

BC-2.7.008 states "Collision-skip is a NON-ERROR: the overall exit code is 0 even if some files were skipped for being pre-existing" (line 774). No holdout scenario exercises the collision-skip exit-0 path specifically (distinct from zero-file path). Not introduced or worsened by P19. Non-blocking.

**Status**: CARRY-FORWARD (absence verified)

---

### INFO-7 — RESOLVED (P16 micro-fix)

**Status**: RESOLVED ✓

---

### INFO-8 (carry-forward R25–R29)

`STATE.md` live status rows still reflect P16 values: `current_step` says "spec v1.3.56"; pipeline tracker ends at P16. Correct values after P19: spec v1.3.59. BC 657 / holdouts 98 / VP 33 correct in STATE.md; only spec version and pass count trail. Task directive: do not edit STATE.md. Non-blocking.

**Status**: CARRY-FORWARD (spec version stale; non-blocking)

---

### INFO-9 — RESOLVED (R26)

**Status**: RESOLVED (R26)

---

### INFO-10 — RESOLVED (P16 micro-fix + P17)

**Status**: RESOLVED ✓

---

### INFO-11 (carry-forward R27–R29)

`spec-changelog.md` [1.3.57] Changes list and `prd-delta-576.md` P17-002 disposition say "three sites" but four sites in `impact-boundary-576.md` were actually modified. All four correctly updated. Tracking records undercount. Not introduced or worsened by P19.

**Status**: CARRY-FORWARD

---

### INFO-12 (carry-forward R27–R29)

`bc-3-issue-write.md` BC-3.9.003 Trace field not updated for P17-003. P17-003 citation IS present in EC-3.9.003-5 body text. Cosmetic; non-blocking. Not introduced or worsened by P19.

**Status**: CARRY-FORWARD

---

### INFO-13 (carry-forward R28–R29)

`error-taxonomy.md` row 95 (attachment download 403) cites "BC-2.7.012 / EC-2.7.007-1b" for both the AID metadata-GET 403 and the issue GET 403 sub-variants. The issue GET 403 variant should also cite BC-2.7.006 (which explicitly specifies the `GET /rest/api/3/issue/{key}?fields=attachment` 403 behavior). Citation is incomplete for the issue-GET sub-variant only. Not introduced or worsened by P19. Behavior is correct. Non-blocking.

**Status**: CARRY-FORWARD

---

### INFO-14 (NEW R29)

`spec-changelog.md` [1.3.59] Impact Assessment table uses an artifact-list format (listing modified files) rather than the dimension-table format used in [1.3.58] (which explicitly stated `BC count: 657 (unchanged) / Holdout count: 98 (unchanged) / VP count: 33 (unchanged)`). The [1.3.59] entry does not include an explicit count row. The counts are consistent across BC-INDEX frontmatter (657), bc-2/bc-3 frontmatter (106/140), and prd-delta-576.md (98 holdouts, 33 VPs — last updated at P18). The count information is correct; its absence from the [1.3.59] changelog entry is a cosmetic formatting inconsistency.

**Status**: NEW INFO (format inconsistency; behavior correct; non-blocking)

---

### INFO-15 (NEW R29)

`impact-boundary-576.md` BC-3.9.004 row (line 157):
> `| BC-3.9.004 | \`attachment upload --output json\` shape: \`[{id, filename, mimeType, size, contentUrl}]\` (array; one element per uploaded file) |`

This row shows id-first key ordering (`{id, filename, mimeType, size, contentUrl}`) which is pre-P19-001 ordering. BC-3.9.004 is the JSM two-step `--public` upload path, deferred to S5 with an INCONCLUSIVE JSON shape (P2-3c live-capture obligation; BC-3.9.011). The impact-boundary planning row was not updated by P19-001 because BC-3.9.004's exact JSON output is TBD. No behavioral contract violation — the authoritative shape for upload is BC-3.9.009 (platform path; updated to alphabetical by P19-001); BC-3.9.011 (JSM path) is explicitly deferred. The stale planning-row key order is non-blocking but is residual id-first ordering in the planning artifact.

**Status**: NEW INFO (deferred feature planning row; no behavioral contract at risk; non-blocking)

---

## 1. L2 to L3 Requirement Coverage

Not applicable — this is a spec-evolution patch-round consistency validator (adversary-pass remediation audit), not a story-delivery pipeline run. L2→L3 coverage is governed by the full F2 story decomposition reviewed in prior rounds.

## 2. L3 to L4 Verification Property Coverage

Not applicable — spec-evolution ops round. VP traceability was validated at story-decomposition time; P19 added zero new BCs or VPs.

## 3. Dependency Acyclicity

Not applicable — spec-evolution ops round. No story dependency graph changes; P19 touches spec artifacts only.

## 4. Architecture Alignment

Not applicable — spec-evolution ops round. No architectural decisions changed; ADR-0017 and peer ADRs are unchanged by P19.

## 5. Acceptance Criteria Quality

Not applicable — spec-evolution ops round. No story ACs modified; P19 updates are confined to BC clause text and holdout cross-references.

## 6. Story Sizing

Not applicable — spec-evolution ops round. No story point estimates changed; P19 adds zero new stories.

## 7. Priority Consistency

Not applicable — spec-evolution ops round. No story priority changes; P19 adds zero new stories.

## 8. L1 to L2 to L3 to L4 Chain Completeness

Not applicable — spec-evolution ops round. Full chain completeness was validated at story-decomposition time; P19 preserves all existing chain links (0 new BCs, 0 new VPs, 0 new stories).

## 9. AC Completeness Coverage

Not applicable — spec-evolution ops round. AC completeness coverage was validated at story-decomposition time; P19 clause additions are checked for coverage via the P19-001..P19-I1 priority checks in this report.

## 10. ASM/R Traceability

Not applicable — spec-evolution ops round. ASM/R traceability state is unchanged by P19; no new assumptions or risks introduced.

---

## Spec vs Implementation Drift

This report covers spec-evolution artifact drift only (F2 patch round). Implementation source code is out of scope — no product source was modified by P19.

| Artifact | Spec Version After P19 | Consistency Status | Notes |
|----------|------------------------|-------------------|-------|
| bc-3-issue-write.md | footer "spec v1.3.59" | consistent | P19-004 (--dry-run annotation) + P19-I1 (4-column note) + P19-001 (BC-3.9.009 key order) applied |
| bc-2-issue-read.md | trace header "spec v1.3.59" | consistent | P19-001 (BC-2.7.002 ordering) + P19-002 (EC-2.7.001-2) + P19-003 (EC-2.7.007-5) applied |
| BC-INDEX.md | `index_version: v6.19`; `last_updated` reflects P19 | consistent | BC-2.7.002, BC-3.9.001, BC-3.9.009 rows updated |
| spec-changelog.md | `[1.3.59]` entry added | consistent | Changed Requirements correct; Impact Assessment format differs from [1.3.58] (INFO-14) |
| prd-delta-576.md | frontmatter `spec_version_after: 1.3.58` | **GAP (GAP-P19-FWD-001)** | Not updated to 1.3.59; P19 dispositions section absent |
| impact-boundary-576.md | BC-2.7.002 row updated (P19-001) | consistent | BC-3.9.004 row stale (INFO-15); non-blocking |
| STATE.md | live rows reflect P16 | STALE (INFO-8, carry-forward) | spec version v1.3.56 (should be v1.3.59) |

---

## Findings

### Critical

None.

### Major

None. All P19 behavioral changes correctly applied.

### GAPs (MEDIUM)

**GAP-P19-FWD-001 (MEDIUM)**: `prd-delta-576.md` frontmatter `spec_version_after` not updated from `1.3.58` to `1.3.59`. No P19 fix-round dispositions section appended. Every prior fix round (P14–P18) updated both. The spec-changelog [1.3.59] Changed Requirements does not list `prd-delta-576.md` as a modified file, confirming the omission is not a formatting difference but a genuine missed update. Behavioral impact: zero. Tracking impact: the official P19 disposition record is absent from the delta document.

### Minor (INFO)

- **INFO-1** (carry-forward R21–R29): Triple blank lines between EC-2.7.008-6 and EC-2.7.008-7 (re-verified by quote).
- **INFO-2** (carry-forward R21–R29): EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained (re-verified by quote).
- **INFO-3** (carry-forward R21–R29): BC-2.7.012 "KEY or AID 5xx" combined-scope row correct but imprecise (re-verified by quote).
- **INFO-4** (carry-forward R22–R29): H-NEW-ATTACHMENT-003 BC refs footer does not list `BC-2.7.008 EC-2.7.008-6` for Call B2 (re-verified by quote).
- **INFO-6** (carry-forward R23–R29): No holdout for the collision-skip exit-0 path (re-verified by absence).
- **INFO-8** (carry-forward R25–R29): STATE.md spec version stale at v1.3.56 (should be v1.3.59).
- **INFO-11** (carry-forward R27–R29): P17-002 "three sites" undercount in spec-changelog / prd-delta.
- **INFO-12** (carry-forward R27–R29): BC-3.9.003 Trace not updated for P17-003; citation IS in EC body.
- **INFO-13** (carry-forward R28–R29): error-taxonomy row 95 issue-GET 403 sub-variant lacks BC-2.7.006 citation.
- **INFO-14** (NEW R29): spec-changelog [1.3.59] Impact Assessment lacks explicit BC/holdout/VP count rows present in [1.3.58]; counts consistent across other surfaces.
- **INFO-15** (NEW R29): impact-boundary-576.md BC-3.9.004 row shows pre-P19-001 id-first key ordering; deferred S5 feature, non-blocking.

---

## Validation Gate Result

**GAPS-FOUND**

One MEDIUM gap: `prd-delta-576.md` frontmatter `spec_version_after: 1.3.58` not updated to `1.3.59`; P19 fix-round dispositions section absent. All P19 behavioral changes correctly applied. Echo-breaker audit of 11 sentences found no behavioral over-claims. Two new INFO items (INFO-14, INFO-15). Carry-forward INFO-1..4, INFO-6 re-verified by quote. INFO-8, INFO-11..13 carried without re-quote (not introduced or worsened by P19). Spec version 1.3.59 consistent across bc-2, bc-3, BC-INDEX, spec-changelog. Guard scripts both exit 0.

---

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 33 |
| **Passed** | 32 |
| **Resolved** | 5 (INFO-5 P14; INFO-7 P16 micro-fix; INFO-9 R26; INFO-10 P16+P17) |
| **Failed (GAPs)** | 1 (GAP-P19-FWD-001 MEDIUM) |
| **Warnings (INFO)** | 11 active (INFO-1..4 carry; INFO-6 carry; INFO-8 carry; INFO-11 carry; INFO-12 carry; INFO-13 carry; INFO-14 new; INFO-15 new) |
| **Overall Status** | gaps-found |

Round 29 is a PATCH-level validation confirming 5 P19 adversary-pass fixes: (1) BC-2.7.002 canonical attachment-object JSON shape pinned as BTreeMap-alphabetical at all depths; example reordered; ordering clause added; BC-2.7.007 cross-ref updated; BC-3.9.009 key enumeration updated; BC-INDEX rows BC-2.7.002/BC-3.9.009 updated; impact-boundary-576.md BC-2.7.002 row updated (P19-001 MEDIUM); (2) EC-2.7.001-2 filter-count hint fires in all modes including JSON; empirical source-code citations verified (list.rs ~580, board.rs ~283); deliberate asymmetry with EC-2.7.001-1 documented (P19-002 LOW); (3) EC-2.7.007-5 SIGINT cleanup downgraded to best-effort MUST; src/main.rs:~393 citation verified; panic=abort confirmed in Cargo.toml (P19-003 LOW); (4) BC-3.9.001 `--dry-run` CLI-flags annotation added with clap-requires constraint and EC-3.9.020-6 cross-reference (P19-004 LOW); (5) BC-3.9.001 4-column upload echo vs 6-column list table asymmetry documented; 6-column enumeration verified verbatim against BC-2.7.001 (P19-I1 INFO). One GAP: `prd-delta-576.md` frontmatter `spec_version_after` not updated from 1.3.58 to 1.3.59; P19 dispositions section absent. Spec version advances to 1.3.59. BC count unchanged at 657; holdout count unchanged at 98; VP count unchanged at 33.

---

## Appendix: Validation Methodology

This report was produced by a fresh-context consistency validator (cv-f2-576-r29) with no visibility into prior round reports.

1. **Independent artifact read**: All 12 input artifacts read fresh. Findings formed before cross-referencing the P19 disposition claims in the spec-changelog.
2. **Quote-based closure**: Every P19 priority check verified by verbatim quotation from the authoritative artifact.
3. **Deliberate non-change verification**: worklog line 471 read verbatim and confirmed as historical record; holdout fixture lines 2080–2081 read in full wiremock-setup context and confirmed as wire-payload mocks, not expected-jr-output assertions.
4. **Source-code citation verification**: src/main.rs lines 391–397, src/cli/issue/list.rs lines 574–592, src/cli/board.rs lines 273–287 all read verbatim; no output_format guard found wrapping the eprintln! calls at ~line 580/~line 283.
5. **Cargo.toml verification**: `serde_json = "1"` (no preserve_order feature); `panic = "abort"` in `[profile.release]`.
6. **Echo-breaker audit**: 11 of 14 newly-authored P19 sentences quoted and cross-checked against their licensing sources; no behavioral over-claims found.
7. **Keystone checks**: K-1 (ordering story coherence), K-2 (EC-2.7.001-1/2 asymmetry), K-3 (EC-2.7.007-5 best-effort vs tested-proxy), K-4 (BC-3.9.001 --dry-run vs EC-3.9.020-6).
8. **Guard scripts**: Both `check-spec-counts.sh` and `check-bc-cumulative-counts.sh` executed and verified "OK".
9. **Count sweep**: BC (657), holdout (98), VP (33) verified across BC-INDEX frontmatter, bc-2/bc-3 frontmatter, and prd-delta-576.md last P18 count statement.
10. **NFR mislabel sweep**: No artifact absorbed "33 NFRs"; all VP count references use correct "VP" label.
11. **INFO ledger**: INFO-1..4 and INFO-6 individually re-verified by quote. INFO-8, INFO-11..13 carried without re-quote (not touched by P19). INFO-14 and INFO-15 identified as new items.
12. **GAP identification**: prd-delta-576.md frontmatter discrepancy identified by direct read of the file's frontmatter field `spec_version_after`.
