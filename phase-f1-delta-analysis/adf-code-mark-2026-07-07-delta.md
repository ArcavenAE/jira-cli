---
bundle: ADF-CODE-MARK-EXCLUSIVITY
issue: 571
date: 2026-07-07
intent: bug-fix
severity: MEDIUM
feature_type: backend
scope: standard
quick_dev_eligible: false
stories_recommended: 1
analyst: vsdd-factory:architect
origin: >
  GitHub issue #571 — markdown_to_adf emits strong+code (and em/strike/subsup+code)
  on a single ADF text node; ADF schema forbids this; Jira Cloud rejects with HTTP 400.
  Deferred follow-up from issue #474 / BC-7.2.007 EC-2.
---

# F1 Delta Analysis — ADF `code` mark exclusivity (issue #571)

**Feature cycle:** ADF-CODE-MARK-EXCLUSIVITY
**Date:** 2026-07-07
**Intent:** `bug-fix`
**Severity:** `MEDIUM`
**Feature type:** `backend` (CLI library; no UI surface, no CLI flag change)
**Scope:** `standard` — full F1–F7 mandated

**Research basis:** `.factory/research/issue-571-adf-code-mark-exclusivity-2026-07-07.md`
**Detailed impact boundary:** `.factory/phase-f1-delta-analysis/impact-boundary-571.md`
**Artifact mapping:** `.factory/phase-f1-delta-analysis/artifact-mapping-571.md`

---

## 1. Classification

**Intent:** `bug-fix` — this fix closes a confirmed HTTP 400 defect; it does not change
observable CLI behavior for any valid markdown input that does not combine typographic
marks with inline code.

**Severity: MEDIUM.** The bug causes HTTP 400 when a user writes markdown like
`` **`code`** `` (bold+code) or `` _`code`_ `` (italic+code) in a `--description
--markdown` or `--markdown` comment. The workaround is accessible: omit the outer
typographic mark. Jira returns 400 without mutating the issue (no data loss). The fix
is schema-correct and precedent-confirmed (Atlaskit editor + `@atlaskit/editor-markdown-
transformer` apply the identical strategy; research Claim C CONFIRMED).

**Quick-dev eligible:** No. The fix requires a test suite update (the existing forward
test pins the wrong behavior) and new tests for all four typographic+code combos plus
the link+code preserved case. The standard F1–F7 pipeline is required.

---

## 2. Background and Motivation

`markdown_to_adf` in `src/adf.rs` is the shared conversion engine for all markdown
write surfaces: `issue create --description`, `issue edit --description`, `issue comment
--markdown`, and JSM request `--markdown`. pulldown-cmark emits `Event::Code(text)` for
inline backtick spans; `AdfBuilder::push_code` handles this event.

In `push_code`, the mark array is built by cloning `self.active_marks` (which captures
currently-open typographic spans: `strong`, `em`, `strike`, `subsup`) and appending
`{"type":"code"}`. When a backtick span appears inside a bold/italic/etc. span, the
resulting text node carries e.g. `marks: [strong, code]`.

The ADF v1 JSON schema (`@atlaskit/adf-schema@47.6.0`) partitions inline text nodes
into two mutually-exclusive subtypes:

- `code_inline_node` — carries `code` mark; may additionally carry `link` and
  `annotation` only. All typographic marks are prohibited.
- `formatted_text_inline_node` — carries any combination of typographic marks and
  `link`/`annotation`; does NOT permit `code`.

A text node with both `strong` and `code` satisfies neither subtype. The Jira Cloud
REST v3 server-side validator rejects it with HTTP 400 "not valid Atlassian Document
Format (ADF) content" (confirmed: research Claim B, two independent primary sources
including `rust-works/omni-dev#1047` which encountered the same schema constraint).

Issue #571 is the explicit follow-up deferred by BC-7.2.007 EC-2, which noted: "`code`
mark cannot coexist with `subsup`/`em`/`strong`/`strike` — not guarded here, tracked
as a follow-up." This cycle closes that follow-up.

---

## 3. Mechanism Decision: emit-site filter in `push_code`

### The discrepancy

The business-analyst's proposed BC-7.2.015 wording described typographic marks as
"stripped by the post-finish normalization pass." The impact-boundary analysis
identified the fix site as `push_code` itself (the single emit path for all code
marks), with a simple allowlist filter on the marks assembled there.

### Decision: emit-site filter in `push_code` — adopted

**Rationale:**

1. **`push_code` is the sole and only emitter of code marks.** A grep of all `src/`
   confirms a single site that pushes `{"type":"code"}` onto a text node's marks array:
   `src/adf.rs::push_code` line ~1285. A post-finish normalization pass would walk the
   entire ADF tree searching for nodes that can only have been produced by this one site.
   That indirection adds complexity without benefit.

2. **No S-522 CR/LF interaction.** The analyst's note cited S-522 as a reason to
   prefer a post-finish pass to "avoid interaction with CR/LF normalization." However,
   in `push_code` the text normalization (lines ~1270–1283) runs on the raw `text`
   string BEFORE the mark assembly at line ~1284 (`let mut marks =
   self.active_marks.clone()`). The mark filter operates on a different value (the
   marks array) after the text string is already finalized. There is no interaction.

3. **DEC-148 citation guard is simpler.** The analyst flagged that BC-7.2.015's
   Trace/Source citations would reference a new function that does not exist until F4,
   requiring a provisional-citation dance. With the emit-site fix, the implementation
   modifies an existing function (`push_code`) — the citation in BC-7.2.015 can point
   directly to `src/adf.rs::push_code`, which already passes the DEC-148 Guard 1
   `scripts/check-bc-citation-symbols.sh` check today. No provisional citation is
   needed.

4. **Consistency argument does not override simplicity.** The post-finish pass pattern
   (`normalize_list_item_content`, `normalize_panel_content`, etc.) exists because those
   passes detect structural properties that are only visible after the whole document is
   built (e.g., reclassifying BulletList→TaskList, pruning empty containers). Mark
   exclusivity on a `push_code`-emitted node is a local property: it depends only on
   `active_marks` at the moment of emission, not on the surrounding document structure.
   The emit-site is the natural enforcement point.

### Implementation shape (for F4)

In `push_code`, replace the current mark assembly:
```rust
let mut marks = self.active_marks.clone();
marks.push(json!({ "type": "code" }));
```
with a filter that retains only schema-valid co-marks (`link`, `annotation`) from
`active_marks` before appending `code`. The exact implementation (inline filter vs
a small private helper) is left to the F4 implementer; `push_code`'s function
signature is unchanged.

### BC-7.2.015 wording implication

BC-7.2.015 must be written at the **behavior level**, not the mechanism level:
"A text node emitted by `markdown_to_adf` that carries a `code` mark may only
additionally carry `link` and/or `annotation` marks. All typographic marks (`strong`,
`em`, `strike`, `subsup`, `underline`, `textColor`, `backgroundColor`) are stripped
at emission time." Trace/Source cites `src/adf.rs::push_code` directly. No provisional
citation is required; the symbol exists today and the DEC-148 guard already validates it.

---

## 4. Impact Assessment Table

| Artifact class | Impact | Notes |
|---------------|--------|-------|
| **PRD / BC spec** | BC-7.2.007 EC-2 MODIFY + BC-7.2.015 ADD | EC-2 drops "not guarded here"; new BC-7.2.015 states positive mark-coexistence invariant |
| **Architecture** | No change | No ADR required; emit-site filter is an implementation detail of `push_code` |
| **UX / CLI surface** | No change | No new flags, no new output fields; invisible to users except that previously-400-failing commands now succeed |
| **Stories** | 1 new story | Single implementation story covering `push_code` filter + test suite update |
| **Tests (unit)** | 1 test updated + ≥7 new | `test_markdown_inline_code_mark_and_composition` (second assertion updated); new tests for all excluded combos + link+code preserved |
| **Tests (integration / holdout)** | 1 new holdout candidate | H-NEW-ADF-010: POST body assertion; no `strong+code` etc. on any text node |
| **Verification** | BC-level + holdout | No new VP files; verification embedded in BCs + `holdout-scenarios.md` |

---

## 5. Files Changed

### Files that WILL be modified

| File | Change type | Description |
|------|------------|-------------|
| `src/adf.rs` | MODIFIED | `push_code`: emit-site typographic-mark filter; `test_markdown_inline_code_mark_and_composition`: second assertion updated to pin correct behavior; new forward tests for all four excluded combos + link+code preserved case; `apply_marks` docstring updated (code-innermost behavior now described as read-tolerance, not write-path mirror) |

### Files NOT changed (regression baseline)

| File | Reason |
|------|--------|
| `src/cli/issue/create.rs` | Call site; no code change needed |
| `src/cli/issue/edit.rs` | Call site; no code change needed |
| `src/cli/issue/workflow.rs` | Call site; no code change needed |
| `src/api/jsm/requests.rs` | Call site; no code change needed |
| `src/cli/worklog.rs` | Uses `text_to_adf`; no markdown parsing; cannot produce code marks |
| All other `src/` files | No `markdown_to_adf` invocation; no code-mark emit path |
| `tests/` integration tests | No behavioral regression expected; existing tests exercise the write path end-to-end but do not assert on mark-level wire details |
| `.github/workflows/ci.yml` | No CI topology change required |
| Any `.factory/specs/prd/` BC file | F2 updates these; F1 does not modify specs |

---

## 6. BC Delta Summary

### BC-7.2.007 EC-2 — MODIFY

**Location:** `.factory/specs/prd/bc-7-output-render.md`, BC-7.2.007, sub-clause EC-2

**Current wording (wrong):**
> `code` mark cannot coexist with `subsup`/`em`/`strong`/`strike` on one text node
> per the ADF schema (`code_inline_node`), so `` ^`x`^ `` would be invalid — not
> guarded here (pre-existing class: `` **`x`** `` has the same issue; tracked as a
> follow-up).

**Required revision:**
Drop the "not guarded here, tracked as a follow-up" clause. EC-2 should instead
describe the now-enforced behavior: inline code spans appearing within typographic spans
emit a text node carrying `code` only (typographic marks stripped at emission time;
see BC-7.2.015 for the positive invariant). The prose that the issue is "tracked as a
follow-up" becomes stale once BC-7.2.015 is added.

The Trace/Source field of BC-7.2.007 currently cites `src/adf.rs::push_code` and
`src/adf.rs::dedup_marks_by_type`. After F4 these remain valid citations; no Trace
update is required.

### BC-7.2.015 — ADD (new)

**Location:** `.factory/specs/prd/bc-7-output-render.md` (append after BC-7.2.014
bare-URL autolink BC)

**Positive invariant (behavior-level statement):**

A text node emitted by `markdown_to_adf` that carries a `code` mark may only
additionally carry `link` and/or `annotation` marks. All typographic marks (`strong`,
`em`, `strike`, `subsup`, `underline`, `textColor`, `backgroundColor`) are stripped
from the code node's mark set at emission time in `src/adf.rs::push_code`.

**Coverage envelope (ECs):**

- EC-1: `**\`code\`**` → code node carries `[code]` only; `strong` mark absent.
- EC-2: `*\`code\`*` → code node carries `[code]` only; `em` mark absent.
- EC-3: `~~\`code\`~~` → code node carries `[code]` only; `strike` mark absent.
- EC-4: `` ^`code`^ `` → code node carries `[code]` only; `subsup` mark absent. (Closes BC-7.2.007 EC-2 follow-up.)
- EC-5: `` [`code`](url) `` → code node carries `[code, link]`; `link` mark IS preserved (schema-valid on `code_inline_node`).
- EC-6: `**a \`b\` c**` (mixed range) — code node `b` carries `[code]` only; surrounding plain-text nodes `a ` and ` c` carry `[strong]`.
- EC-7 (inverse / read-tolerance): `adf_to_text` renders a text node with `[strong, code]` as `` **`x`** `` (code applied innermost regardless of array position). This is read-leniency for externally-produced or legacy ADF; it does not imply `markdown_to_adf` may emit this combination.

**Trace / Source (DEC-148 guard-safe citations):**

Both cite `src/adf.rs::push_code` (existing symbol; no provisional-citation dance
needed). The DEC-148 Guard 1 (`scripts/check-bc-citation-symbols.sh`) validates these
against develop's `src/` tree and will pass from F2 onward.

**`check-bc-cumulative-counts.sh` (DRIFT-002):** Adding BC-7.2.015 increments the
total BC count for `bc-7-output-render.md` and the grand total in CANONICAL-COUNTS.md.
F2 must update both `bc-7-output-render.md`'s frontmatter `total_bcs:` and
CANONICAL-COUNTS.md, then run `scripts/check-bc-cumulative-counts.sh` to verify
consistency before committing.

### Holdout candidate: H-NEW-ADF-010

A new MUST-PASS holdout covering code-mark exclusivity at the integration level. The
holdout exercises the POST body ADF directly (the defect is invisible from `jr issue
view` text rendering, which handles both valid and invalid mark combos gracefully in
`adf_to_text`).

**Acceptance shape:**
- **Setup:** wiremock POST to `/rest/api/3/issue`
- **Action:** `jr issue create --project PROJ --type Task --summary "test"
  --description "**bold \`code\` bold**" --markdown --no-input`
- **Expected:** captured POST body `fields.description` ADF contains no text node where
  `marks` includes both `{"type":"code"}` and any of `{"type":"strong"}`,
  `{"type":"em"}`, `{"type":"strike"}`, `{"type":"subsup"}`
- **Secondary:** the code text node carries exactly `[{"type":"code"}]`; surrounding
  plain-text nodes carry `[{"type":"strong"}]`
- **BC anchor:** BC-7.2.015

---

## 7. Regression Risk Assessment

| Module | Risk | Criteria |
|--------|------|----------|
| `src/adf.rs` | HIGH | Core shared module; all `--markdown` write surfaces flow through it; large test suite; the one forward test that must change is currently pinning incorrect behavior (expected to fail after fix; must be rewritten) |
| `src/cli/issue/create.rs` | LOW | Call site only; no code change |
| `src/cli/issue/edit.rs` | LOW | Call site only; no code change |
| `src/cli/issue/workflow.rs` | LOW | Call site only; no code change |
| `src/api/jsm/requests.rs` | LOW | Call site only; same `markdown_to_adf` pipeline as platform path; research §Claim D found no endpoint-specific leniency |

**S-474 story risk (HIGH):** S-474 introduced `dedup_marks_by_type`, the `push_code`
dedup call, and the subsup mark handling. BC-7.2.007 EC-2 from S-474 is explicitly this
cycle's deferred item. The test `test_markdown_inline_code_mark_and_composition` (second
assertion) pins the wrong behavior from S-474 and must be updated in F4.

**S-522 story risk (MEDIUM → mitigated):** S-522 added CR/LF normalization inside
`push_code`. The emit-site fix modifies mark assembly (line ~1284+) which runs AFTER
text normalization (lines ~1270–1283). The two operations are on different values (text
string vs marks array); no interaction. Risk is LOW in practice.

**Tests that must stay green (regression baseline):**
- `test_push_code_normalizes_lone_cr_in_inline_code` — BC-7.2.011 EC-11 pin
- `test_push_code_normalizes_bare_lf_to_space` — BC-7.2.011 EC-11 pin
- `test_subsup_composes_with_strong` — non-code marks compose freely; no code mark involved
- `test_url_in_inline_code_not_linkified` — code node must not gain link mark from autolink pass
- `test_render_marks_code_and_strong` — `adf_to_text` read-leniency; retained unchanged
- `test_render_strong_with_code_applies_code_innermost` — `adf_to_text` read-leniency; retained unchanged
- All `test_markdown_alert_*`, `test_markdown_task_*`, `test_bare_*`, `test_markdown_footnote_*` tests

---

## 8. Reverse-Path Retention Decision

**`src/adf.rs::apply_marks` and both reverse-path tests are retained unchanged.**

`apply_marks` applies `code` innermost regardless of array position, allowing
`adf_to_text` to render any text node with a `code` mark as `` `…` `` with other marks
wrapping outside. This is correct read-tolerance:

- Jira issues created before this fix (or created by other tools) may carry
  `[strong, code]` nodes that the Jira editor once accepted or auto-corrected. `jr issue
  view` (which calls `adf_to_text`) must render these gracefully.
- The read path has no correctness obligation to mirror the write path's invariants.
  Writing leniency and reading leniency are orthogonal.

The `apply_marks` docstring will be updated in F4 to remove the stale claim that
"the write-path `push_code` appends `{type:"code"}` after active marks, so on roundtrip
we see `marks: [strong, code]`" — this will no longer be true after the fix. The
updated docstring will describe the behavior as read-tolerance for externally-produced
or legacy ADF.

---

## 9. Out-of-Scope List

- **`annotation` marks:** `annotation` is schema-valid on `code_inline_node` and must
  not be stripped. `jr` does not emit annotation marks today; the fix must treat them
  the same as `link` (preserve). No additional tests are required for annotation.

- **`underline`, `textColor`, `backgroundColor` marks:** `jr` does not emit these today.
  Stripping them defensively alongside typographic marks is safe and forward-compatible
  but requires no dedicated tests for this cycle.

- **`codeBlock` content:** Handled by a separate block-level path; `push_code` handles
  inline `Event::Code` only. No interaction.

- **`adf_to_text` behavior for schema-invalid inputs:** Read tolerance is retained
  (§8). No scope here to harden `adf_to_text` against all possible invalid ADF inputs.

- **Node-splitting for mixed ranges:** The research (Claim C) documents a split-nodes
  strategy for `**a \`b\` c**` where bold wraps both plain text and inline code.
  pulldown-cmark already emits three separate events for this case (plain text "a ",
  code "b", plain text " c") because the backtick span is a discrete event boundary.
  `push_code` is only called for the `b` span; `active_marks` will contain `strong` for
  all three events. The fix produces: `a ` → `[strong]`, `b` → `[code]` only (strong
  stripped at push_code), ` c` → `[strong]`. The three-node split is a natural
  consequence of the emit-site filter — no explicit node-splitting logic is needed.

- **`worklog add --message`:** Uses `text_to_adf` (no markdown parsing). Out of scope.

- **`issue comment` without `--markdown`:** Uses `text_to_adf`. Out of scope.

---

## 10. Recommended Scope for F2, F3, F4

### F2 — Spec evolution

- Amend BC-7.2.007 EC-2 in `bc-7-output-render.md`: drop "not guarded here" clause.
- Add BC-7.2.015 to `bc-7-output-render.md` with the positive mark-coexistence
  invariant, 7 ECs (§6), and Trace/Source citing `src/adf.rs::push_code`.
- Update `bc-7-output-render.md` frontmatter `total_bcs:` and CANONICAL-COUNTS.md.
- Run `scripts/check-bc-cumulative-counts.sh` and `scripts/check-bc-no-numeric-test-counts.sh`.
- Draft H-NEW-ADF-010 in `holdout-scenarios.md`.
- Update CLAUDE.md gotcha for the `code` mark note in the subsup bullet: drop "not guarded here, tracked as a follow-up" and add a pointer to BC-7.2.015.

### F3 — Story authoring

One story is sufficient:
- `S-571`: ADF `code` mark exclusivity — `push_code` emit-site typographic-mark filter
  + test suite update. BCs: BC-7.2.015 (all ECs) + BC-7.2.007 EC-2 (behavior closure).
  Test plan: update `test_markdown_inline_code_mark_and_composition`; add ≥7 new
  forward tests (§3.3 of artifact-mapping); ensure reverse-path tests stay green;
  update `apply_marks` docstring.

### F4 — Delta implementation

Single story `S-571`. TDD order:
1. Red: update `test_markdown_inline_code_mark_and_composition` to assert `code` only
   on the code node (fails immediately against current code).
2. Green: implement emit-site filter in `push_code`.
3. Add new tests for em, strike, subsup, link+code, mixed range.
4. Update `apply_marks` docstring.
5. Confirm all S-522 CR/LF normalization tests still pass.
