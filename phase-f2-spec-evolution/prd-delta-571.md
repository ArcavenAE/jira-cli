---
document_type: prd-delta
feature: ADF-CODE-MARK-EXCLUSIVITY
issue: "#571"
phase: F2
authored: 2026-07-07
spec_version_before: 1.3.24
spec_version_after: 1.3.25
bc_count_before: 611
bc_count_after: 612
holdout_count_before: 82
holdout_count_after: 83
---

# PRD Delta — ADF Code-Mark Exclusivity (issue #571)

## Summary

F2 spec evolution for the ADF-CODE-MARK-EXCLUSIVITY cycle. Adds one new
individually-bodied BC (BC-7.2.015) governing code-mark exclusivity at ADF
emission time. Modifies BC-7.2.007 EC-2 to replace the "not guarded here"
deferral clause with a description of the now-enforced behavior. Adds holdout
H-NEW-ADF-010 as a MUST-PASS black-box POST-body assertion.

---

## BC-7.2.015 — Final Text

### Heading

```
BC-7.2.015: A text node emitted by `markdown_to_adf` that carries a `code`
mark may only additionally carry `link` and/or `annotation` marks; all
typographic marks (`strong`, `em`, `strike`, `subsup`, `underline`,
`textColor`, `backgroundColor`) are stripped from the code node's mark set
at emission time in `src/adf.rs::push_code`; surrounding non-code text nodes
in the same span retain their typographic marks unchanged; `adf_to_text`
read-tolerance for externally-produced ADF with typographic+code combinations
is retained and is NOT a violation of this BC
```

### Confidence / Subject / Behavior

**Confidence**: HIGH  
**Subject**: Output rendering  
**Behavior**: The ADF schema defines two mutually exclusive inline text node
subtypes: `code_inline_node` (permits only `code`, `link`, `annotation` marks)
and `formatted_text_inline_node` (permits typographic marks but NOT `code`). A
text node carrying both a typographic mark and `code` satisfies neither
subtype — Jira Cloud REST API rejects it with HTTP 400. `markdown_to_adf`
enforces the exclusivity on the write path by filtering `active_marks` in
`src/adf.rs::push_code` before appending the `code` mark: only `link` and
`annotation` co-marks survive the filter; all typographic marks are stripped.
The stripping is node-scoped: non-code text nodes in the same inline span
(e.g., the surrounding bold text in `` **a `b` c** ``) retain their
typographic marks. The reverse path (`adf_to_text`) is intentionally lenient:
it renders externally-produced `[strong, code]` ADF nodes as `` **`x`** ``
without error. This write-strict / read-lenient asymmetry is deliberate and
NOT a BC violation.

### Edge Cases

| ID | Input | ADF marks on code node | Notes |
|----|-------|------------------------|-------|
| EC-1 | `` **`code`** `` | `[code]` | `strong` stripped |
| EC-2 | `` _`code`_ `` | `[code]` | `em` stripped |
| EC-3 | `` ~~`code`~~ `` | `[code]` | `strike` stripped |
| EC-4 | `` ^`code`^ `` | `[code]` | `subsup` stripped; primary issue #571 regression target (closes BC-7.2.007 EC-2 follow-up) |
| EC-5 | `` [`code`](url) `` | `[code, link]` | `link` preserved; `link` is a permitted co-mark |
| EC-6 | `` **a `b` c** `` | `"a "` → `[strong]`; `"b"` → `[code]`; `" c"` → `[strong]` | surrounding non-code nodes retain marks |
| EC-7 | externally-produced `[strong, code]` ADF via `adf_to_text` | renders as `` **`x`** `` (lenient) | write-strict / read-lenient asymmetry intentional |

### Source / Trace

**Source**: `src/adf.rs::push_code`; `src/adf.rs::tests`; issue #571  
**Trace**: `src/adf.rs::push_code` (sole emit site for `code` marks in
`markdown_to_adf`)

### Version History

| Version | Date | Author | Change |
|---------|------|--------|--------|
| 1.0.0 | 2026-07-07 | product-owner | Initial BC-7.2.015 (issue #571) |

---

## BC-7.2.007 EC-2 — Modification

**Before** (pre-#571):

> `` `code` `` mark cannot coexist with `subsup`/`em`/`strong`/`strike` on one
> text node per the ADF schema (`code_inline_node`), so `` ^`x`^ `` would be
> invalid — not guarded here (pre-existing class: `` **`x`** `` has the same
> issue; tracked as a follow-up).

**After** (post-#571):

> **(EC-2) `code` mark exclusivity enforced at emission time** [UPDATED
> 2026-07-07 issue #571]: ADF schema forbids the `code` mark alongside
> `subsup`, `em`, `strong`, `strike`, `underline`, `textColor`, or
> `backgroundColor` on the same text node (`code_inline_node` allows only
> `code`, `link`, `annotation`). `` ^`code`^ `` (superscript wrapping a code
> span) now emits a text node carrying `code` only — the `subsup` mark is
> stripped at emission time in `src/adf.rs::push_code`. The same rule applies
> to `` **`code`** `` (strong), `` _`code`_ `` (em), and `` ~~`code`~~ ``
> (strike). This constraint was previously unguarded (follow-up deferred from
> issue #474); issue #571 closes that follow-up. See BC-7.2.015 for the
> positive mark-coexistence invariant. Note: `adf_to_text` read-tolerance for
> externally-produced `[strong, code]` text nodes is retained (renders as
> `` **`x`** ``); this is intentional asymmetry and does NOT violate the
> write-path invariant.

---

## Holdout H-NEW-ADF-010 — Summary

**Title**: Text node with `code` mark carries NO typographic marks; `link`
mark co-exists with `code`; surrounding non-code text retains marks; JSM path
parity confirmed via `POST /rest/servicedeskapi/request` (MUST-PASS)

**BC**: BC-7.2.015  
**Group**: 12 (ADF Footnote Empty-Container Pruning + Code-Mark Exclusivity)  
**Coverage**: EC-1 (strong stripped), EC-4 (subsup stripped; primary regression
target), EC-5 (link preserved), EC-6 (mixed-range surrounding marks), Call E
(JSM path parity — `requestFieldValues.description` obeys same invariant)

Five sub-calls via `jr issue create --markdown`. Calls A–D mount
`POST /rest/api/3/issue` (platform path); for each captured body, the
code-mark exclusivity invariant asserts no text node with `"type":"code"` in
its marks also carries `strong`/`em`/`strike`/`subsup`/`underline`/
`textColor`/`backgroundColor`. Call C also pins that `link` IS preserved on the
same node as `code`. Call E mounts the JSM fixture set (servicedesk list +
requesttype list + `POST /rest/servicedeskapi/request`) and asserts the same
invariant on `requestFieldValues.description` — proving BC-7.2.015 holds on
the `handle_jsm_create` dispatch path (ADR-0014) via the shared
`markdown_to_adf`/`push_code` engine. F2 adversarial finding F2 (MED) resolved
by option a (Call E extension); option b (VP-571-005 by-construction reword)
not taken.

---

## Count Propagation (REGISTRATION-SURFACE-SWEEP)

All 8 count surfaces updated atomically per DEC-155:

| Surface | Field | Before | After |
|---------|-------|--------|-------|
| bc-7-output-render.md frontmatter | `total_bcs` | 92 | 93 |
| bc-7-output-render.md frontmatter | `definitional_count` | 48 | 49 |
| BC-INDEX.md frontmatter | `total_bcs` | 611 | 612 |
| §7 file-level header (BC-INDEX:480) | individually-bodied count | 48 | 49 |
| §7.2 subsection header (BC-INDEX:492) | cumulative BCs | 57 | 58 |
| BC-INDEX.md `sections:` entry | cumulative/individually-bodied | 92/48 | 93/49 |
| BC-INDEX.md range-collapsed row | range end | BC-7.2.016..057 | BC-7.2.016..058 |
| BC-INDEX.md grand total | **N** | **611** | **612** |
| BC-INDEX.md summary table | total / individually-bodied | 611 / 381 | 612 / 382 |
| CANONICAL-COUNTS.md definitional table | bc-7 Actual / Frontmatter | 48 / 48 | 49 / 49 |
| CANONICAL-COUNTS.md definitional table | Total individually-bodied | **381** | **382** |
| CANONICAL-COUNTS.md total_bcs table | bc-7 | 92 | 93 |
| CANONICAL-COUNTS.md total_bcs table | Sum | **611** | **612** |
| CANONICAL-COUNTS.md grand total | canonical grand total | 611 | 612 |
| CANONICAL-COUNTS.md Breakdown | total = sum | 611 | 612 |
| CANONICAL-COUNTS.md Breakdown | individually-bodied of total | 381 of 611 | 382 of 612 |
| CANONICAL-COUNTS.md L2 alignment table | bc-07 L2 bc_count | 92 | 93 |
| CANONICAL-COUNTS.md L2 alignment table | bc-07 L3 total_bcs | 92 | 93 |
| bc-7-output-render.md body preamble | "N behavioral contracts" | 92 | 93 |
| domain-spec/bc-07-output-render.md | `bc_count` | 92 | 93 |

---

## Files Edited

| File | Change |
|------|--------|
| `.factory/specs/prd/bc-7-output-render.md` | BC-7.2.015 added; BC-7.2.007 EC-2 modified; frontmatter counts bumped |
| `.factory/specs/prd/BC-INDEX.md` | BC-7.2.015 row; range-collapsed shifted; all count surfaces updated (Python bypass, TD-031) |
| `.factory/specs/prd/CANONICAL-COUNTS.md` | All bc-7 counts + sums updated across all tables; §Holdout updated 57→83 with Groups 8b–14 enumeration (F2 fix round 1 F3) |
| `.factory/specs/domain-spec/bc-07-output-render.md` | `bc_count` 92 → 93 (Python bypass, TD-031) |
| `.factory/specs/prd/holdout-scenarios.md` | H-NEW-ADF-010 added to Group 12; extended with Call E JSM-path parity (F2 fix round 1 F2); total_holdouts 82 → 83 (original authoring) |
| `.factory/spec-changelog.md` | v1.3.25 MINOR entry added; template guide appended |
| `.factory/phase-f2-spec-evolution/prd-delta-571.md` | This file (NEW); updated by F2 fix round 1 (band 016..058, Call E, holdout total 83) |
| `.factory/phase-f2-spec-evolution/verification-delta-571.md` | NEW — VP-571-001..005 verification properties; referenced by BC-7.2.015 §Verification Properties; consumed by F3 story (F2 fix round 4 manifest addition) |

### F2 Fix Round 1 Changes (adversarial pass 1 findings)

| Finding | Severity | Resolution |
|---------|----------|------------|
| F1 (band arithmetic) | MED | Band end slid from 057 to 058 in BC-INDEX.md:511 via Python bypass; 15 bodied + 43 band = 58 cumulative ✓; no artifact references BC-7.2.057/058 as a specific contract (corpus-wide grep returned zero results) |
| F2 (VP-571-005 JSM enforcement claim) | MED | Option a chosen: H-NEW-ADF-010 extended with Call E — `POST /rest/servicedeskapi/request` fixture using H-NEW-JSM-RT-001 precedent; `requestFieldValues.description` ADF asserted for code-mark exclusivity; VP-571-005 text in BC-7.2.015 body remains as-is (now backed by Call E) |
| F3 (CANONICAL-COUNTS.md §Holdout stale) | LOW | Canonical holdout total updated 57→83; enumeration brought current through Group 14; grouped-count convention used for new groups |

### F2 Fix Round 2 Changes (adversarial pass 2 findings — H-NEW-ADF-010 Call E only)

| Finding | Severity | Resolution |
|---------|----------|------------|
| R2-F-CRIT-1 (a): missing project-meta mount | CRIT | Added `GET /rest/api/3/project/HELPDESK` as mount 1 returning `{"id":"77","key":"HELPDESK","projectTypeKey":"service_desk","simplified":false}`; `require_service_desk` calls `get_or_fetch_project_meta` first (confirmed via `src/api/jsm/servicedesks.rs::require_service_desk` + `tests/issue_create_jsm.rs::mount_project_meta_help`) |
| R2-F-CRIT-1 (b): wrong service-desk fixture fields | CRIT | Replaced `{"id":"3","projectKey":"HELPDESK"}` with `{"id":"3","projectId":"77","projectName":"Help Desk"}`; `ServiceDesk` struct (`src/types/jsm/servicedesk.rs`) deserializes only `id`/`projectId`/`projectName` — no `projectKey` field; match condition is `d.project_id == "77"` (numeric project id from mount 1) |
| R2-F-CRIT-1 (c): request-type fixture missing pagination fields | CRIT | Added `"size":1,"start":0,"limit":50` to request-type fixture; `ServiceDeskPage` requires non-optional `size`/`start`/`limit`; endpoint URL corrected to include `?start=0&limit=50` (confirmed via `src/api/jsm/request_types.rs::list_request_types`) |
| R2-F-LOW-1: ambiguous Call E setup wording | LOW | Reworded "replaces the shared POST …mount for this call only" → "For Call E, mount instead (the shared POST /rest/api/3/issue mount does NOT apply…)" |
| R2-F-LOW-2: Call D `containing "a"` / `containing "c"` imprecise | LOW | Pinned exact text: `"a "` (trailing space) and `" c"` (leading space) — deterministic pulldown-cmark emission boundaries documented in F1 delta |

### F2 Fix Round 3 Changes (adversarial pass 3 findings)

| Finding | Severity | Resolution |
|---------|----------|------------|
| R3-F-MED-1: CLAUDE.md gotcha update scope boundary | MED | CLAUDE.md update (F1 delta §10: replace "not guarded here … tracked as a follow-up" stale text at CLAUDE.md ~line 293 with a pointer to BC-7.2.015) is **DEFERRED TO F4** by orchestrator adjudication — rationale: CLAUDE.md is a product file on `develop`; F2 is spec-only (`.factory/` artifacts); product-file edits go through the F4 story worktree/PR per LESSON-F2-WORKTREE-FIRST. F3 story MUST include CLAUDE.md in its files-modified list so F4 implementer applies the update in the same PR as the code change. |
| R3-F-LOW-2: filter-vs-dedup ordering not pinned | LOW | Added sentence to BC-7.2.015 §Behavior in `bc-7-output-render.md`: filter operates on a clone of `active_marks` BEFORE appending `{"type":"code"}`; trailing `dedup_marks_by_type` call retained unchanged (BC-7.2.007 dedup guarantee; removing it is out of scope for #571) |
| R3-F-LOW-3: BC-7.2.007 EC-2 denylist framing | LOW | Rewrote EC-2 opening sentence to allowlist framing: "ADF `code_inline_node` permits only `code`, `link`, and `annotation` marks; all other marks are stripped … currently emitted and stripped: `subsup`, `em`, `strong`, `strike`; defensively stripped: `underline`, `textColor`, `backgroundColor`" — same semantics, forward-compatible, consistent with BC-7.2.015 |
| R3-N-NITPICK-1: H-NEW-ADF-010 title 4-mark enumeration | NITPICK | Replaced `(strong, em, strike, subsup)` enumeration in heading with generic "carries NO typographic marks" phrasing; JSM-path-parity clause appended; Expected section already enumerates all 7 typographic marks |

### F2 Fix Round 4 Changes (adversarial pass 4 findings)

| Finding | Severity | Resolution |
|---------|----------|------------|
| R4-F-MED-1: BC-INDEX.md Coverage Statistics row stale (BC-INDEX-9TH-SURFACE) | MED | Updated BC-INDEX.md:732 row "7: Output Rendering" from `92 / 48` to `93 / 49` (cumulative/individually-bodied) via Python bypass; 9th surface unguarded by three scripts — process-gap note at BC-INDEX.md:740 documents this class |
| R4-F-MED-2: spec-changelog.md v1.3.25 stale claims | MED | (a) Band ref: "BC-7.2.015..057 → BC-7.2.016..057" → "BC-7.2.015..057 → BC-7.2.016..058" (landed band end is 058); (b) Call count: "four sub-calls covering strong-stripped, subsup-stripped, link-preserved, and mixed-range cases" → "five sub-calls covering strong-stripped, subsup-stripped, link-preserved, mixed-range, and JSM-path parity via POST /rest/servicedeskapi/request (Call E)" |
| R4-F-LOW-1: EC-5 marks array ordered notation | LOW | Rewrote bc-7-output-render.md BC-7.2.015 EC-5 from `[{"type":"code"}, {"type":"link",...}]` (incorrect emission order) to `{{"type":"code"}, {"type":"link",...}}` set notation with "(order-agnostic; tests use set comparison)" note; `link` is from `active_marks` (emitted first), `code` appended after — order is implementation-defined |
| R4-F-LOW-2: Count Propagation table ambiguous section-header labels | LOW | Relabeled two "BC-INDEX.md § section header (bc-7)" rows to "§7 file-level header (BC-INDEX:480)" and "§7.2 subsection header (BC-INDEX:492)" for unambiguous surface identification |
| R4-F-LOW-3: verification-delta-571.md absent from Files Edited manifest | LOW | Added `.factory/phase-f2-spec-evolution/verification-delta-571.md` row to Files Edited table |
| R4-N-1: fix-round finding IDs un-namespaced | NITPICK | Namespaced Round 2 finding IDs as R2- and Round 3 finding IDs as R3- throughout prd-delta-571.md; Round 1 IDs (F1/F2/F3) unchanged (predate convention); Round 4 IDs use R4- prefix going forward |

**Scope boundary note — CLAUDE.md update deferred to F4:**

The F1 delta (§10) identified a stale CLAUDE.md gotcha at approximately line 293:
> "not guarded here (pre-existing class: `` **`x`** `` has the same issue; tracked as a follow-up)"

This text was the original BC-7.2.007 EC-2 deferral clause before issue #571 closed the follow-up. The replacement text should read:
> "This constraint is now enforced at emission time in `push_code`; see BC-7.2.015 for the positive mark-coexistence invariant."

This edit is a product file edit (`CLAUDE.md` on `develop`) and MUST go through the F4 story worktree/PR. The F3 story file must include `CLAUDE.md` in its `files_modified` list. F2 spec-only artifacts (`.factory/`) are complete; no CLAUDE.md edit is made here.

---

## Verification Script Results

All three scripts run against current `.factory/specs/prd/` (post F2 fix round 4):

| Script | Exit Code | Output |
|--------|-----------|--------|
| `scripts/check-spec-counts.sh` | 0 | `OK: all spec counts verified.` |
| `scripts/check-bc-cumulative-counts.sh` | 0 | `OK: all cumulative BC counts verified (612 total across 8 files; Surface H footer checked where present).` |
| `scripts/check-bc-citation-symbols.sh --bc-dir .factory/specs/prd/` | 0 | `Check passed: 312 citations checked` |

*(Post F2 fix round 4: all three scripts still exit 0 — counts unchanged by fix round 4 prose edits.)*

---

## Version Bump

- **Before**: 1.3.24  
- **After**: 1.3.25  
- **Type**: MINOR (new BC added, existing BC modified; no NFR changes, no
  structural schema changes)  
- **Changelog entry**: `.factory/spec-changelog.md` § [1.3.25] - 2026-07-07
