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
| §7.2 subsection header (BC-INDEX:492) | cumulative BCs | 57 | 59 |
| BC-INDEX.md `sections:` entry | cumulative/individually-bodied | 92/48 | 93/49 |
| BC-INDEX.md range-collapsed row | range end | BC-7.2.016..057 | BC-7.2.016..059 |
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

### F2 Fix Round 5 Changes (adversarial pass 5 — polish tier)

| Finding | Severity | Resolution |
|---------|----------|------------|
| R5-F-L1: §7.2 subsection sum drift (BC-INDEX-9TH-SURFACE) | LOW | Root cause: range-collapsed band has been short by 1 since a historical bodied-BC addition that extended the total but not the band end. Total=93, individually-bodied=49 → range-collapsed must=44; band BC-7.2.016..058=43 (short). Fixed: BC-INDEX.md 7.2 subsection header "58 BCs cumulative" → "59 BCs cumulative"; band row BC-7.2.016..058 → BC-7.2.016..059; bc-7-output-render.md 7.2 header same; spec-changelog.md v1.3.25 band ref updated; Count Propagation table updated. Drift predated this delta (was 91 vs 92 before; 92 vs 93 after round 4). |
| R5-F-L2: H-NEW-ADF-010 missing Newline delivery field | LOW | Inserted `**Newline delivery**: N/A — single-line input (Calls A–E; no multi-line content).` before `**Why hidden**:` in holdout-scenarios.md H-NEW-ADF-010 — matches template carried by Group 10-12 siblings |
| R5-F-L4: domain-spec bc-07-output-render.md:15 stale "52 BCs" prose | LOW | Genericized both stale count references (line 15 intro paragraph and §6 Aggregate Boundaries bullet) to reference frontmatter rather than a specific number; Python bypass (TD-031) |
| R5-F-N1: EC-5 marks set-notation nonstandard (optional) | NITPICK | Applied: rewrote `{{"type":"code"}, {"type":"link",...}}` double-curlybrace notation to prose "marks that are the unordered set of {type:code} and {type:link,...} (order-agnostic; tests use set comparison; concrete emission order today is [link, code])" |

### F2 Fix Round 6 Changes (adversarial pass 6 — targeted precision)

| Finding | Severity | Resolution |
|---------|----------|------------|
| R6-F-DELTA-3: VP-571-002 test pointer positional + shape-inaccurate | MED | Rewrote the pointer from positional ("second assertion") + vague shape ("pre-fix `[strong, code]`") to content-anchored + shape-accurate: "has a `mark_types Vec<&str>` contains-check (`contains &"code" && contains &"strong"`) that MUST be rewritten to pin `mark_types == ["code"]`"; full locate-detail deferred to verification-delta-571.md |
| R6-F-DELTA-4: H-NEW-ADF-010 missing Test file placement | MED | Checked `tests/` directory: dedicated ADF-BC pattern established by `tests/adf_inline_html_inv1_e2e.rs` (BC-7.2.011) and `tests/adf_recursion_depth.rs` (BC-7.2.012), both using `POST /rest/api/3/issue` wiremock on the platform create path. Decision: Calls A–D → `tests/adf_code_mark_exclusivity.rs` (matches naming convention and file-per-BC pattern); Call E retains existing anchor in `tests/issue_create_jsm.rs`. Added as last `**Test file placement**:` line in H-NEW-ADF-010. |

### F2 Fix Round 7 Changes (adversarial pass 7 — implementer-simulation lens)

| Finding | Severity | Resolution |
|---------|----------|------------|
| R7-F-DELTA-MED-1: EC-5 phantom title key in link attrs | MED | `jr` suppresses empty titles (`if !title.is_empty()` guard in `src/adf.rs` `Tag::Link` handler); `[code](url)` with no title emits `{"type":"link","attrs":{"href":"url"}}` — no `"title"` key. Removed `"title":""` from EC-5 example in bc-7-output-render.md. Confirmed no other occurrences in BC-7.2.015 body. |
| R7-F-DELTA-LOW-1: §Behavior allowlist semantics not explicit | LOW | Appended bomb-proofing sentence to second §Behavior paragraph: "The filter is an allowlist: any mark whose type is outside `{link, annotation}` in `active_marks` — including future mark types not currently emitted by pulldown-cmark — is stripped from the code node." |

### F2 Fix Round 8 Changes (adversarial pass 8 — one item)

| Finding | Severity | Resolution |
|---------|----------|------------|
| R8-LOW-1: dedup-retention parenthetical technically wrong | LOW | Replaced "(prevents duplicate `link` marks from nested autolink processing)" — incorrect because `autolink_bare_urls` runs post-`finish()` and skips code-marked nodes (BC-7.2.014 EC-5), so that scenario cannot fire — with "(BC-7.2.007 same-type dedup invariant; retained defensively even though the post-filter mark set for a code node has no producible same-type collisions today)". Retention of `dedup_marks_by_type` remains correct; only the motivating clause was wrong. |

### F2 Fix Round 9 Changes (adversarial pass 9 — three items)

| Finding | Severity | Resolution |
|---------|----------|------------|
| R9-F-MED-3: Scope boundary note's "replacement text" block underspecified — three overlapping stale phrasings in CLAUDE.md clause (b); story-writers could not produce byte-identical patches | MED | Rewrote the Scope boundary note in `prd-delta-571.md` to include a verbatim "Clause (b) replacement template" block showing the full clause (b) after the splice, plus a plain-text "splice target" fenced block showing the exact tail to copy into CLAUDE.md. Keep/replace boundary documented explicitly (ends at `code_inline_node`)`). |
| R9-F-LOW-1: No sizing basis for F3 in prd-delta-571.md — story-writer lacked effort anchor | LOW | Added `## Sizing Basis for F3` section: single-file src change (~15–30 LOC), ~11 unit tests, 1 proptest, 2 test helpers, 1 existing-test rewrite, 5 integration scenarios across 2 test files, docstring/comment refreshes, CLAUDE.md splice; precedent anchors S-522 (2 pts) / S-492 (3 pts); estimate 3–4 story points. |
| R9-F-LOW-3: VP-571-002's two locked helper contracts not visible in BC body — BC-body-only reader would not know these helpers are required | LOW | Added helper mirror bullet after VP-571-005 in `bc-7-output-render.md` BC-7.2.015 §Verification Properties: `assert_marks_eq` (unordered set comparison) + `assert_link_mark_with_href` (field-by-field href check) as F4-MUST-introduce `#[cfg(test)]` helpers in `src/adf.rs::tests`; full contracts pointer to `verification-delta-571.md` §VP-571-002. |

### F2 Fix Round 10 Changes (adversarial pass 10 — three items)

| Finding | Severity | Resolution |
|---------|----------|------------|
| R10-F-MED-1: H-NEW-ADF-010 Calls B and E use an empirically unconfirmed subsup+code input; no Red-Gate fallback ladder documented | MED | Added `**Empirical-check propagation (F4)**` note to H-NEW-ADF-010 in `holdout-scenarios.md` after `**Test file placement**`: states that VP-571-002 EC-4 empirical check BINDS Calls B and E; provides two-rung fallback ladder: (i) confirmed alternate input adopted byte-for-byte; (ii) if subsup+code not producible, Call B replaced with proven strong form (text `"code"`, same marks), "primary" label moves to Call A, subsup coverage recorded schema-derived only; Call E follows same substitution. Do NOT preemptively rewrite inputs. |
| R10-F-LOW-1: BC-7.2.015 §Behavior omits security non-claim for `link` mark href pass-through | LOW | Appended security-framing sentence to the write-strict/read-lenient paragraph in `bc-7-output-render.md` §Behavior: "The allowlist retains `link` marks verbatim (including `attrs.href`); jr does not perform scheme-based href sanitization on link marks — unchanged pre-/post-#571 and not a BC-7.2.015 concern (see the `Tag::Link` handler in `src/adf.rs`); the write-strict schema-validity gate is not a security control." |
| R10-F-N-1: H-NEW-ADF-010 Call C assertion lacks retention-anchor disclosure — reader unclear whether GREEN pre-fix is expected | N | Added parenthetical disclosure after Expected point 3 of Call C in `holdout-scenarios.md`: "(Retention anchor — GREEN pre-fix AND post-fix; catches a mutant that drops `link` from the allowlist, not a pre-fix→post-fix regression pin.)" |

### F2 Fix Round 11 Changes (adversarial pass 11 — four items)

| Finding | Severity | Resolution |
|---------|----------|------------|
| R11-F-LOW-1: `spec-changelog.md` v1.3.25 omits `verification-delta-571.md` from Changed Requirements and Impact Assessment — R4 fixed prd-delta manifest but never propagated to changelog | LOW | Added `- .factory/phase-f2-spec-evolution/verification-delta-571.md (NEW): VP-571-001..005 verification properties for BC-7.2.015; consumed by F3 story.` to v1.3.25 Changed Requirements list; added matching `verification-delta-571.md \| NEW \| VP-571-001..005 verification properties for BC-7.2.015` row to Impact Assessment table. |
| R11-F-N-1: CANONICAL-COUNTS.md stale literal "the 611." at line 65 — should read "the 612." after BC-7.2.015 addition | N | Changed "It does NOT add +1 beyond the 611." → "It does NOT add +1 beyond the 612." |
| R11-F-N-2: `spec-changelog.md` Impact Assessment CANONICAL-COUNTS row says "All 8 count surfaces updated atomically (DEC-155)" — omits the 11 unguarded prose surfaces | N | Replaced with "All guarded count surfaces (8 per check-bc-cumulative-counts.sh) plus unguarded body/prose surfaces updated atomically (19 surface rows; see prd-delta-571.md Count Propagation table)". |
| R11-PREEX-1: `domain-spec/bc-07-output-render.md` "1,826 LOC" citation appears twice (lines 15 and 127) — >6× stale (src/adf.rs is ~11,4xx lines) | PREEX | Line 15: replaced "The ADF renderer alone is 1,826 LOC and accounts for" → "The ADF renderer (`src/adf.rs`) is the largest single module in the crate and accounts for". Line 127: removed "1,826 LOC; " from the parenthetical, leaving "(see bc-7-output-render.md frontmatter for canonical BC count)". Accepted non-fix: CANONICAL-COUNTS:67 historical note is self-disclosing and makes no currency claim — no change. |

### F2 Fix Round 12 Changes (adversarial pass 12 — four items)

| Finding | Severity | Resolution |
|---------|----------|------------|
| R12-F-1: Empirical-check propagation ladder missing rung (iii) for mixed-range confirmed input — holdout Expected topology would be wrong if pulldown produces `^a \`b\` c^` | LOW | Added rung (iii) to fallback ladder in `holdout-scenarios.md` H-NEW-ADF-010: if confirmed composing input is a mixed-range shape, Calls B and E adopt it AND their Expected sections are rewritten to multi-node topology (surrounding text nodes retain `[subsup]`, code node carries `[code]` only); single-text-node assertion MUST NOT be retained; assertion-topology update applies to both holdout Expected sections and, by consistency, EC-4 unit anchor if it adopts a mixed-range input. |
| R12-F-2: prd-delta-571.md template block heading conflates rendered preview with splice copy target; "F4 implementer" annotation on wrong block | LOW | Renamed first block heading from "Clause (b) replacement template — verbatim (F4 implementer applies byte-for-byte)" to "Clause (b) replacement — rendered preview of post-splice state"; moved "F4 implementer applies byte-for-byte" annotation to plain-text splice block heading only; backtick-wrapped `push_code` and `code` in the fenced splice content to match CLAUDE.md token style. |
| R12-F-3: Sizing Basis "~11 unit tests" overcounts by 1 (8 anchor-matrix rows incl. control + PANEL-ANCHOR + 2 VP-571-003 tests = 10) | NITPICK | Changed "~11 unit tests" → "~10 unit tests" in `## Sizing Basis for F3`. |
| R12-F-4: EC-2 in `bc-7-output-render.md` BC-7.2.007 states "`subsup` mark is stripped" as causal certainty — presumes empirically unconfirmed subsup+code composition | NITPICK | Reworded to outcome-form with hedge: "now emits a text node carrying `code` only (any `subsup` mark present in `active_marks` is stripped; whether pulldown composes subsup around a code span is adjudicated by the F4 empirical check — see VP-571-002)." |

### F2 Fix Round 13 Changes (adversarial pass 13 — two items)

| Finding | Severity | Resolution |
|---------|----------|------------|
| R13-LOW-1: "Clause (b) replacement — rendered preview" block creates hostile-misread trap — token styling diverges from CLAUDE.md conventions and duplicates the plain-text splice; implementer could copy the wrong block | LOW | Deleted the entire "rendered preview" block (heading + keep-boundary sentence + full-clause blockquote) from `prd-delta-571.md` Scope boundary note. Plain-text splice block (with byte-for-byte annotation) is now the sole authoritative source. Updated splice heading to add: "apply this splice mentally to CLAUDE.md ~:293 to preview the post-splice rendered result". |
| R13-N-1: Sizing Basis "~10 unit tests" overcounts by 1 — EC-6 anchor is shared between VP-571-002 and VP-571-003 (8 matrix rows + 1 distinct VP-571-003 multi-mark test = 9) | N | Changed "~10 unit tests" → "~9 unit tests" in `## Sizing Basis for F3`. |

**Scope boundary note — CLAUDE.md update deferred to F4:**

The F1 delta (§10) identified stale clause (b) inside the "Markdown minor constructs → ADF (`adf.rs`, issue #474)" gotcha entry in CLAUDE.md (~line 293). The current tail of clause (b) is `, so `` ^`x`^ `` would be invalid — not guarded here (pre-existing class: `` **`x`** `` has the same issue; tracked as a follow-up).` — the follow-up is now closed by issue #571.

**Plain-text splice — F4 implementer applies byte-for-byte (copy verbatim into CLAUDE.md replacing from ", so" through "follow-up)."; apply this splice mentally to CLAUDE.md ~:293 to preview the post-splice rendered result):**

```
 — enforced at emission time since #571: `push_code` strips typographic marks from code spans (see BC-7.2.015); `` ^`x`^ `` and `` **`x`** `` now emit schema-valid ADF with the `code` mark only.
```

This edit is a product file edit (`CLAUDE.md` on `develop`) and MUST go through the F4 story worktree/PR. The F3 story file must include `CLAUDE.md` in its `files_modified` list. F2 spec-only artifacts (`.factory/`) are complete; no CLAUDE.md edit is made here.

---

## Sizing Basis for F3

Single-file `src/` change (~15–30 LOC allowlist filter in `push_code`) + ~9 unit tests + 1 proptest (full generator, no MVP subset — orchestrator decision) + 2 test helpers + 1 existing-test rewrite + 5 integration scenarios across 2 test files (`tests/adf_code_mark_exclusivity.rs` Calls A–D + `tests/issue_create_jsm.rs` Call E) + docstring/comment refreshes + CLAUDE.md splice. Precedent anchors: S-522 (2 pts, single-path `push_text` guard) / S-492 (3 pts, HtmlBlock Algorithm B). Estimate: **3–4 story points**.

---

## Verification Script Results

All three scripts run against current `.factory/specs/prd/` (post F2 fix round 4):

| Script | Exit Code | Output |
|--------|-----------|--------|
| `scripts/check-spec-counts.sh` | 0 | `OK: all spec counts verified.` |
| `scripts/check-bc-cumulative-counts.sh` | 0 | `OK: all cumulative BC counts verified (612 total across 8 files; Surface H footer checked where present).` |
| `scripts/check-bc-citation-symbols.sh --bc-dir .factory/specs/prd/` | 0 | `Check passed: 312 citations checked` |

*(Post F2 fix round 4: all three scripts still exit 0 — counts unchanged by fix round 4 prose edits.)*

*(Post F2 fix round 5: all three scripts still exit 0 — R5 fixes are subsection/band/prose edits only; no guarded-surface counts change.)*

*(Post F2 fix round 6: all three scripts still exit 0 — R6 fixes are VP prose and holdout template additions only; no counts change.)*

*(Post F2 fix round 7: all three scripts still exit 0 — R7 fixes are BC body prose edits only; no counts change.)*

*(Post F2 fix round 8: all three scripts still exit 0 — R8 fix is a single parenthetical prose correction; no counts change.)*

*(Post F2 fix round 9: all three scripts still exit 0 — R9 fixes are scope-note verbatim template expansion, sizing section addition, and VP helper mirror bullet; no guarded-surface counts change.)*

*(Post F2 fix round 10: all three scripts still exit 0 — R10 fixes are holdout empirical-check propagation note, BC §Behavior security sentence, and holdout Call C retention disclosure; no guarded-surface counts change.)*

*(Post F2 fix round 11: all three scripts still exit 0 — R11 fixes are changelog manifest propagation, stale 611 literal correction, surface-count prose expansion, and domain-spec LOC citation genericization; no guarded-surface counts change.)*

*(Post F2 fix round 12: all three scripts still exit 0 — R12 fixes are holdout fallback-ladder rung iii, template-block heading restructure + splice token backticking, sizing ~11→~10, and EC-2 causality hedge; no guarded-surface counts change.)*

*(Post F2 fix round 13: all three scripts still exit 0 — R13 fixes are rendered-preview block deletion and sizing ~10→~9; no guarded-surface counts change.)*

---

## Version Bump

- **Before**: 1.3.24  
- **After**: 1.3.25  
- **Type**: MINOR (new BC added, existing BC modified; no NFR changes, no
  structural schema changes)  
- **Changelog entry**: `.factory/spec-changelog.md` § [1.3.25] - 2026-07-07
