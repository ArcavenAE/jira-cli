---
document_type: f1-delta-analysis
step: 4-affected-artifact-mapping
issue: 571
title: "ADF code-mark exclusivity — affected artifact mapping"
date: 2026-07-07
author: subagent (F1 Step 4)
research_source: .factory/research/issue-571-adf-code-mark-exclusivity-2026-07-07.md
status: complete
---

# F1 Step 4 — Affected Artifact Mapping (Issue #571)

**Subject**: `markdown_to_adf` emits invalid `strong+code` (and `em`/`strike`/`subsup`+`code`) mark combinations on a single text node; ADF schema allows `code` only alongside `link` and `annotation`; Jira Cloud rejects with HTTP 400.

**Root cause** (from research): `src/adf.rs::AdfBuilder::push_code` clones `self.active_marks` and appends `{type:"code"}` to the end. When the active marks include `strong` (or `em`, `strike`, `subsup`), the resulting marks array carries both — an invalid combination per the ADF v1 JSON schema (`code_inline_node` allows only `code`, `link`, `annotation`).

---

## 1. BC Mapping

### 1.1 BC that pins the WRONG behavior

**BC-7.2.007** — "markdown_to_adf maps `^x^`→subsup sup and `~x~`→subsup sub; double-tilde stays strike"

Specifically **EC-2** in that BC body:

> "(EC-2) `code` mark cannot coexist with `subsup` on one text node: ADF schema forbids the `code` mark alongside `subsup`, `em`, `strong`, or `strike` on the same text node. `` ^`x`^ `` (superscript wrapping a code span) would produce a node with both `code` and `subsup` marks, which Jira rejects with HTTP 400. **This is an accepted known limitation in the same class as `` **\`x\`** `` (pre-existing); not guarded here, tracked as a follow-up.**"

The phrase "not guarded here, tracked as a follow-up" is the load-bearing wrong-behavior pin. Issue #571 is explicitly that follow-up.

Additionally, the **Trace field of BC-7.2.007** cites `src/adf.rs::push_code` and `src/adf.rs::dedup_marks_by_type` — both of which will be modified or superseded by the fix. The Trace must be updated post-F4.

### 1.2 Secondary BC with stale assertion logic

**BC-3.3.008** — "`issue create --markdown -d '...'` converts markdown to ADF before POST"

**Confidence: MEDIUM.** This is cited as `tests/issue_create_json.rs` and covers the markdown→ADF write path end-to-end. After the fix, the same `--markdown` path will produce different (corrected) ADF for bold+code inputs. No structural change to BC-3.3.008 is required, but the implementation of BC-3.3.008 is tested indirectly through the same `markdown_to_adf` pipeline. The fix will cause previously-written tests that asserted the wrong wire payload (strong+code together) to be updated; BC-3.3.008 itself remains accurate.

### 1.3 BC modification decision

| BC | Action | Scope |
|----|--------|-------|
| BC-7.2.007 EC-2 | **MODIFY** — replace "not guarded here, tracked as a follow-up" with a description of the normalization pass behavior; update Trace/Source once F4 delivers the function name | Required |
| NEW BC-7.2.015 | **ADD** — positive mark-coexistence contract (see §1.4) | Required |
| BC-3.3.008 | **NO CHANGE** — the BC is accurate; test coverage internal to BC-3.3.008 does not assert on mark-level wire details | No action |

### 1.4 New BC: BC-7.2.015

A new BC is warranted because the fix introduces a positive invariant (what MUST be true after the pass runs) that is not captured anywhere in the existing BC corpus. The EC-2 amendment alone describes what changes; BC-7.2.015 describes what the system now guarantees.

**Proposed identity**: BC-7.2.015 (next sequential after the BC-7.2.014 bare-URL autolink BC).

**Proposed summary**: A text node carrying a `code` mark may only additionally carry `link` and/or `annotation`. All typographic marks (`strong`, `em`, `strike`, `subsup`, `underline`, `textColor`, `backgroundColor`) are incompatible with `code` on the same node per the ADF v1 JSON schema (`code_inline_node`). The `markdown_to_adf` post-finish normalization pass enforces this invariant before any payload is submitted to Jira.

**Behavior envelope** (to be hardened in F2):
- **Code-only range** (`**\`code\`**` — the entire typographic span is a code span): the outer typographic mark (`strong`) is dropped; the node carries `code` only. Code semantics are preserved over styling (matches Atlaskit editor precedent, Claim C CONFIRMED).
- **Mixed range** (`**prose \`code\` prose**` — the typographic span contains both plain text and code): the paragraph is split into three nodes — plain text node carrying `strong`, code text node carrying `code` only, plain text node carrying `strong`. Both semantics are preserved.
- **`code + link`** is valid and MUST NOT be stripped — `link` is allowed alongside `code` in `code_inline_node`.
- **`code + annotation`** is valid and MUST NOT be stripped.
- The pass runs post-`finish()`, before any HTTP call, as part of the `markdown_to_adf` pipeline (alongside `autolink_bare_urls`, `assign_local_ids`, etc.).

**Citation guard note**: The Trace/Source citations in BC-7.2.015 must reference the normalization function that F4 will create (e.g., `strip_excluded_marks_from_code_nodes` or `normalize_code_mark_exclusivity`). Because `tests/claude_md_citations.rs` (BC-X.13) and `scripts/check-bc-citation-symbols.sh` (DEC-148 Guard 1) validate that cited symbols exist at CI time, the F2 BC body must either (a) use a provisional name with a note that citations are finalized in F4, or (b) cite only the existing surrounding functions (`src/adf.rs::markdown_to_adf`, `src/adf.rs::push_code`) until the new function name is pinned in F4's Trace update pass.

---

## 2. Story Regression-Risk Zone

The following delivered stories directly touched `src/adf.rs` and are in the blast radius of any change to `push_code`, `dedup_marks_by_type`, or the `markdown_to_adf` post-finish pass pipeline:

| Story | PR | BC anchors | Risk |
|-------|----|------------|------|
| S-474 | PR #474 (branch feat/adf-minor-constructs-474) | BC-7.2.007, BC-7.2.008 | **HIGH** — S-474 introduced `dedup_marks_by_type`, added the `push_code` dedup call, introduced subsup mark handling. BC-7.2.007 EC-2 is EXPLICITLY a deferred item from S-474. The tests `test_subsup_composes_with_strong` (checks subsup+strong, NOT code) remain valid; `test_markdown_inline_code_mark_and_composition` (second assertion) pins the WRONG behavior and must change in F4. |
| S-522 | PR #560/#561 (approximate) | BC-7.2.011 EC-11 | **MEDIUM** — S-522 added CR/LF normalization inside `push_code`. Any modification to `push_code` must preserve the CR/LF normalization logic (lines `src/adf.rs::push_code`  ~1270-1285). The normalization runs on the raw text string BEFORE mark assembly, so it is not affected by mark-set changes — no regression expected if the fix is a post-finish pass rather than a `push_code` rewrite. |
| S-492 | PR ~2026-06-16 | BC-7.2.011 (Algorithm B) | **LOW** — S-492 added the `NodeKind::HtmlBlock` end-handler. No interaction with inline code marks. |
| S-483 | PR #487 | BC-7.2.009 | **LOW** — S-483 introduced `normalize_panel_content`. The new normalization pass for code-mark exclusivity will be structurally similar (post-finish tree walk). No known interaction. |
| S-471 | — | BC-7.2.010 | **LOW** — S-471 introduced task lists. `taskItem` inline content accepts `code` marks; the fix must not strip `code` from `taskItem` text nodes. Confirm the normalization pass scope excludes `codeBlock` context (already the invariant from S-522). |
| S-MAINT-SEC-001 | PR #553 | BC-7.2.012 | **LOW** — SEC-001 added recursion-depth guards on all recursive-descent passes. The new normalization pass will also need a depth guard if it recurses (follows the same pattern as `normalize_panel_content`, `normalize_list_item_content`). |
| S-475 | PR #499 | BC-7.2.003/004/006 | **LOW** — E2E read-path tests; no write-path mark composition. |

**Summary**: Only S-474 carries HIGH regression risk. The two tests from S-474 that assert the wrong write-path behavior (see §3) must be updated in F4. All other stories are LOW risk assuming the fix is a post-finish normalization pass (not a rewrite of `push_code` itself).

---

## 3. Existing Tests Covering the Affected Area

### 3.1 Tests that pin the WRONG behavior (must change in F4)

| Test name | File | Line (approx) | Wrong assertion |
|-----------|------|---------------|-----------------|
| `test_markdown_inline_code_mark_and_composition` | `src/adf.rs` | ~2855 | Second assertion: asserts `markdown_to_adf("**bold \`code\` bold**")` produces a code node with BOTH `code` AND `strong` marks. After the fix, the code node must carry ONLY `code` (code-only-range rule: outer bold spans the backtick range only). |

### 3.2 Tests that cover the affected area and must STAY GREEN (read path + invariants)

| Test name | File | Line (approx) | Purpose | Action needed |
|-----------|------|---------------|---------|---------------|
| `test_render_marks_code_and_strong` | `src/adf.rs` | ~6564 | `adf_to_text` graceful rendering of `[code, strong]` ADF (externally created or legacy). ADF produced by Jira itself may contain these combos on older issues. | KEEP as-is. Comment update: remove the claim "The write-path emits `[strong, code]`" (stale post-fix). |
| `test_render_strong_with_code_applies_code_innermost` | `src/adf.rs` | ~6666 | `adf_to_text` graceful rendering of `[strong, code]` (write-path order). Same reasoning — read path must handle external ADF gracefully. | KEEP as-is. Comment update: "write-path's marks ordering" claim becomes stale; the function being tested is `adf_to_text`, not `push_code`, so the test itself is correct. |
| `test_push_code_normalizes_lone_cr_in_inline_code` | `src/adf.rs` | ~9732 | BC-7.2.011 EC-11 pin for `push_code` CR normalization. Not affected by mark-set changes. | MUST STAY GREEN — no action needed. |
| `test_push_code_normalizes_bare_lf_to_space` | `src/adf.rs` | ~10391 | BC-7.2.011 EC-11 pin for `push_code` LF normalization. Not affected by mark-set changes. | MUST STAY GREEN — no action needed. |
| `test_subsup_composes_with_strong` | `src/adf.rs` | ~2854 (S-474) | Asserts that non-code marks compose freely (subsup + strong on non-code text). No code mark involved. | MUST STAY GREEN — no action needed. |
| `test_markdown_strike_sub_sup_coexist` | `src/adf.rs` | — | BC-7.2.007 EC-3 — nested same-type dedup. No code mark involved. | MUST STAY GREEN — no action needed. |

### 3.3 Tests that will need new companions (add in F4)

The following new test cases are missing from the corpus and will be needed to cover the fix:

1. **write-path code-only range**: `markdown_to_adf("**\`x\`**")` → code node carries ONLY `{type:"code"}`; no `strong` mark present.
2. **write-path mixed range**: `markdown_to_adf("**a \`b\` c**")` → three text nodes: `a ` with `strong`, `b` with `code` only, ` c` with `strong`.
3. **write-path em+code**: `markdown_to_adf("_\`x\`_")` → code node carries ONLY `{type:"code"}`; no `em` mark.
4. **write-path strike+code**: `markdown_to_adf("~~\`x\`~~")` → code node carries ONLY `{type:"code"}`; no `strike` mark.
5. **write-path subsup+code**: `markdown_to_adf("^\`x\`^")` → code node carries ONLY `{type:"code"}`; no `subsup` mark. (This was EC-2 of BC-7.2.007 — the primary motivation for issue #571.)
6. **link+code preserved**: `markdown_to_adf("[\`x\`](https://example.com)")` → code node carries BOTH `code` AND `link`; link is NOT stripped.
7. **holdout-tier**: a `--markdown` integration test asserting the POST body ADF contains no `strong+code`, `em+code`, `strike+code`, or `subsup+code` text nodes (see §5).

---

## 4. Verification Properties

There are no separate VP files in this codebase (`.factory` has no `VP-*.md` files). Verification is expressed through BCs (behavioral contracts) and holdout scenarios. The verification properties for the ADF mark pipeline are embedded in:

- `bc-7-output-render.md` — BC-7.2.001..014 ADF rendering behavioral contracts
- `holdout-scenarios.md` — H-NEW-ADF-001..H-NEW-ADF-009 (ADF write-path integration tests with POST body assertions)

**Extension needed**: A new holdout scenario (H-NEW-ADF-010 or next available) covering code-mark exclusivity at the integration level (see §5). No existing holdout exercises the `strong+code` case.

The BC-7.2.011 "no raw `\n` in text nodes" invariant (INV-1) and its tests are in scope as regression-risk guards (§2) but require no extension.

---

## 5. Holdout Scenarios

### 5.1 Existing ADF holdouts (H-NEW-ADF-001..009, H-NEW-SEC-001..002)

None of the existing holdouts cover the code-mark exclusivity class:
- H-NEW-ADF-001..002: GFM alert → panel (BC-7.2.009)
- H-NEW-ADF-003: GFM task list → taskList/taskItem (BC-7.2.010)
- H-NEW-ADF-004..005: block HTML / inline HTML INV-1 (BC-7.2.011)
- H-NEW-ADF-006: footnote → plain marker (BC-7.2.013)
- H-NEW-ADF-007: subsup marks (`^x^`/`~x~`/`~~x~~`) (BC-7.2.007)
- H-NEW-ADF-008: bare URL autolink (BC-7.2.014)
- H-NEW-ADF-009: empty-container pruning (BC-7.2.013)
- H-NEW-SEC-001..002: ADF recursion depth guard (BC-7.2.012)

### 5.2 G-ADF-FOOTNOTE gap status

G-ADF-FOOTNOTE was a gap-close item that re-anchored H-NEW-ADF-006 and added H-NEW-ADF-009 (both BC-7.2.013). That gap is CLOSED.

### 5.3 New holdout candidate: H-NEW-ADF-010 (code-mark exclusivity)

A new MUST-PASS holdout is warranted and should be authored in F2/F3. The holdout should:

- **Setup**: wiremock POST to `/rest/api/3/issue`
- **Action**: `jr issue create --project PROJ --type Task --summary "test" --description "**bold \`code\` bold**" --markdown --no-input`
- **Expected (primary)**: The captured POST body `fields.description` ADF contains NO text node where the `marks` array contains BOTH a `{type:"code"}` and any of `{type:"strong"}`, `{type:"em"}`, `{type:"strike"}`, `{type:"subsup"}`.
- **Expected (secondary)**: The code text node ("code") carries exactly `[{type:"code"}]`. The surrounding plain text nodes ("bold ") carry `[{type:"strong"}]`.
- **Why hidden**: The ADF mark-set exclusivity is invisible from `jr issue view` text rendering (which renders `**\`code\`**` back from either the valid or invalid form). A regression where `normalize_code_mark_exclusivity` is removed or scope-limited would silently emit an ADF payload that Jira rejects with HTTP 400. The mock body assertion is the only channel.

This holdout should cite BC-7.2.015 (the new mark-coexistence BC) and reference the research finding (Claim B CONFIRMED: HTTP 400 from Jira Cloud on `strong+code` payloads).

---

## 6. Feature Classification

**Feature type**: Backend / CLI library. `src/adf.rs` is a pure Rust conversion library with no UI surface. The fix produces no visible change in `jr issue view` text rendering or `--output json` command responses — it only affects the ADF JSON submitted in `fields.description` / `fields.body` payloads on `issue create`, `issue edit`, `issue comment`, and the JSM `--markdown` path.

Confirmation: **BACKEND ONLY**. No UI, no CLI surface change, no JSON output format change. The affected file is `/Users/zious/Documents/GITHUB/jira-cli/src/adf.rs`.

---

## 7. Severity

**MEDIUM** — confirmed.

**Rationale**:
- The bug causes HTTP 400 when a user writes markdown like `` **`code`** `` (bold+code) or `` _`code`_ `` (italic+code) in a `--description --markdown` flag value.
- The workaround is accessible: omit the outer typographic mark (write plain `` `code` `` instead of `` **`code`** ``), or write the description in ADF JSON directly and bypass the markdown path.
- The affected path requires both `--markdown` AND a typographic+code combination in the same span. Most plain markdown descriptions (headings, lists, plain code blocks) are unaffected.
- The bug is not data-destroying: Jira returns 400 without mutating the issue, so no data loss occurs. The user sees a clear error (though the error message from Jira is not user-friendly: "not valid Atlassian Document Format (ADF) content").
- All four excluded mark types (`strong`, `em`, `strike`, `subsup`) trigger the 400 identically per the ADF schema, but `strong+code` (bold+backtick) is the most common real-world trigger.

**Challenge**: One could argue HIGH severity on the grounds that (1) the bug affects all `--markdown` users who follow standard markdown conventions for bold code, (2) the error message is non-actionable ("not valid ADF content" with no hint about which marks conflict), and (3) JSM endpoints are also affected (same `markdown_to_adf` pipeline). For this cycle the team classification of MEDIUM is accepted.

---

## 8. Summary Table

| Dimension | Finding |
|-----------|---------|
| **BCs pinning wrong behavior** | BC-7.2.007 EC-2 (MODIFY: "not guarded here" → describes normalization pass) |
| **New BCs warranted** | BC-7.2.015 (ADD: mark-coexistence invariant — positive contract) |
| **Story regression-risk zone** | S-474 (HIGH); S-522 (MEDIUM); S-483, S-471, S-MAINT-SEC-001, S-475 (LOW) |
| **Tests pinning wrong behavior** | `src/adf.rs::test_markdown_inline_code_mark_and_composition` (second assertion, ~line 2880) |
| **Tests needing comment update only** | `src/adf.rs::test_render_marks_code_and_strong` (~6564); `src/adf.rs::test_render_strong_with_code_applies_code_innermost` (~6666) |
| **Tests that must stay green** | `test_push_code_normalizes_lone_cr_in_inline_code`, `test_push_code_normalizes_bare_lf_to_space`, all `test_subsup_*` tests |
| **New tests needed** | ≥7 (see §3.3) — write-path code-only range; mixed range; em/strike/subsup+code; link+code preserved; integration holdout |
| **VP files** | None (verification embedded in BCs + holdout-scenarios.md) |
| **Holdout coverage gap** | H-NEW-ADF-010 candidate (code-mark exclusivity POST body assertion; cites BC-7.2.015) |
| **Feature type** | Backend (CLI library); no UI; no CLI surface change |
| **Severity** | MEDIUM (confirmed) |

---

## 9. Citation Guard Risk Note

The BC-X.13 citation guard (`tests/claude_md_citations.rs`) validates backtick-quoted file paths in CLAUDE.md. The mutation policy citation guard (`scripts/check-bc-citation-symbols.sh`, DEC-148 Guard 1) validates `src/` symbol citations in BC `Trace:`/`Source:` fields. The new BC-7.2.015 will reference a normalization function that does not exist until F4. F2 (spec evolution) must draft BC-7.2.015 with placeholder symbol cites (e.g., `src/adf.rs::markdown_to_adf` as the call site, noting the new function name is TBD pending F4), and the F4 implementer must update BC-7.2.015's Trace/Source as a mandatory companion commit step before CI can pass.
