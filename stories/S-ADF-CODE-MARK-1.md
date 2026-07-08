---
document_type: story
level: ops
story_id: "S-ADF-CODE-MARK-1"
epic_id: "none"
title: "ADF code-mark exclusivity: push_code allowlist filter strips typographic marks (issue #571)"
wave: feature-followup
status: delivered
intent: adf-correctness
feature_type: bug-fix
mode: feature
scope: standard
severity: MEDIUM
trivial_scope: false
points: 4
priority: P2
tdd_mode: strict
producer: story-writer
timestamp: "2026-07-07T00:00:00"
phase: 3
inputs: [".factory/phase-f2-spec-evolution/prd-delta-571.md", ".factory/phase-f2-spec-evolution/verification-delta-571.md", ".factory/specs/prd/bc-7-output-render.md"]
input-hash: "95a65f7"
traces_to: ".factory/specs/prd/bc-7-output-render.md"
cycle: cycle-001
estimated_effort: medium
estimated_days: 1.5
target_module: src/adf.rs
subsystems: ["adf", "jsm"]
depends_on: []
blocks: []
behavioral_contracts: ["BC-7.2.015", "BC-7.2.007"]
bcs: ["BC-7.2.015", "BC-7.2.007"]
verification_properties: ["VP-571-001", "VP-571-002", "VP-571-003", "VP-571-004", "VP-571-005"]
holdout_anchors: ["H-NEW-ADF-010"]
nfr_anchors: []
adr_refs: ["ADR-0014"]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/phase-f1-delta-analysis/adf-code-mark-2026-07-07-delta.md"
implementation_strategy: tdd
module_criticality: HIGH
acceptance_criteria_count: 12
assumption_validations: []
risk_mitigations:
  - "Red-Gate empirical-check protocol for EC-2/EC-3/EC-4 (pulldown-cmark composition unconfirmed) — three-rung adjudication ladder in Task 0 + Task 3; phase-perimeter clause authorizes same-PR spec-companion commit if demotion occurs (precedent: PR #592)"
created: "2026-07-07"
version: "1.9"
last_updated: "2026-07-08"
breaking_change: false
retroactive: false
origin: >
  Issue #571. BC-7.2.007 EC-2 (issue #474) deferred as "not guarded here — tracked as a
  follow-up" the case where a code span is wrapped in a typographic mark (e.g. subsup). The
  ADF schema forbids `code` alongside any typographic mark on the same text node
  (code_inline_node permits only code, link, annotation); Jira Cloud REST API rejects such
  nodes with HTTP 400. This story closes the follow-up by adding an allowlist filter in
  src/adf.rs::push_code that strips typographic marks from the code node's mark set at
  emission time, retaining only link and annotation marks. The fix is write-strict /
  read-lenient: adf_to_text retains intentional tolerance for externally-produced ADF with
  typographic+code combinations. BC-7.2.015 (new) governs the positive mark-coexistence
  invariant; BC-7.2.007 EC-2 is amended from deferral to enforced. F2 spec delta converged
  2026-07-07 (19 passes / 13 fix rounds, STRICT). F1 delta: .factory/phase-f1-delta-analysis/
  adf-code-mark-2026-07-07-delta.md. F2 artifacts: .factory/phase-f2-spec-evolution/
  prd-delta-571.md + verification-delta-571.md.
changelog:
  - "1.9 (2026-07-08): DELIVERED — PR #593 squash-merged by human @ 7ba4cf4 (DEC-128 honored). F4 full delivery: Red Gate verified (8 RED anchors, all CONFIRMED-INPUT), 8 commits, Step 4.5 CONVERGED STRICT (4 passes, window p2/p3/p4), 992 lib + 49 integration tests green, mutation gate PASS (first real code-diff exercise), security 1 LOW, pr-reviewer APPROVE cycle 1, 12/12 AC demos. Closes issue #571 and the BC-7.2.007 EC-2 follow-up deferred from #474."
  - "1.8 (2026-07-08): F3 gate approved (human) — status draft→ready. F3 CONVERGED under STRICT (DEC-160): 10 passes / 6 fix rounds, clean window p8/p9/p10 on v1.7. F4 dispatch authorized; Step 4.5 criterion: STRICT (human ruling)."
  - "1.7 (2026-07-07): F3 adversarial pass 6 (1 MED). Task 6 item 2 + AC-008 item 3 both extended to enumerate twin comment refreshes: test_render_marks_code_and_strong AND test_render_strong_with_code_applies_code_innermost both carry stale write-path comments that must be reframed to read-tolerance for externally-produced ADF (assertion bodies untouched, MUST-STAY-GREEN). VP-571-004 obligation extended in parallel (same finding, F3 pass 7 per team-lead note)."
  - "1.6 (2026-07-07): F3 adversarial pass 5 fixes (4 applied, 2 accepted-as-is). LOW-1: Task 4 reworded 'Do NOT touch apply_marks' → 'Do NOT touch the SEMANTICS of … apply_marks (its docstring refresh is Task 6)'. LOW-2: Demo Plan expanded to cover all 12 ACs — AC-001..AC-009 via cargo test --lib, AC-010/AC-011 via integration test runs, AC-012 via claude_md_citations.rs pass + CLAUDE.md diff hunk. LOW-3: AC-009 + Task 8 case cap aligned to VP-571-001 upstream: default ~256 cases; cap to 128 only on CI flake pressure (was unconditionally 128). NITPICK-1: Architecture Compliance Rules grep expectation amended — multiple matches expected; exactly 1 must be outside #[cfg(test)] mod tests (currently push_code). Pass-6 NITPICK-2/3: accepted per standard holdout-delegation pattern."
  - "1.5 (2026-07-07): F3 adversarial pass 4 fixes (5 items). L-1: AC-002 header BC-7.2.007 EC-1 mis-anchor → EC-2 pre-#571 write-strict clause. N-1: unify Task 0 clause names — both MIXED-RANGE and DEMOTE now use 'phase-perimeter spec-companion clause (R13-LOW-3)'. VA-3: Task 3 topology sub-note extended 'for the EC-4 anchor' → 'for the EC-2/EC-3/EC-4 anchors (only EC-4 carries downstream Call B/E propagation obligation)'. VA-2: Task 2 evidence form pinned to mandatory 'Red-Gate pre-fix evidence' PR description section (all outcomes including CONFIRMED-INPUT). VA-1: AC-009 proptest weight-uniformity sentence added (~5% floor per branch)."
  - "1.4 (2026-07-07): F3 adversarial pass 3 (1 applied, 2 blocked). LOW: AC-011 mis-cite fixed — '(test-hardening note 3)' → '(see Task 0 ladder and Task 3 topology-obligation sub-note)'. NITPICK-1 (epic_id) + NITPICK-2 (phase): KEPT — both fields appear as required frontmatter in story-template.md (lines 5 + 10); removal would trip validate-template-compliance hook. Awaiting adjudication on template exception."
  - "1.3 (2026-07-07): F3 adversarial pass 2 fixes (4 items). LOW-1: MIXED-RANGE Task 0 bullet extended with spec-companion clause (verification-delta-571.md row + holdout-scenarios.md Call B/E multi-node rewrite) mirroring DEMOTE; Task 3 sub-note gains matching mirror line. LOW-2: Task 9 Call E isolation reworded from jr_cmd_with_xdg to inline .env() TempDir pattern (integration tests don't share cross-file helpers). OBS-1: Architecture Compliance Rules row 1 grep fixed from '\"type\":\"code\"' to '\"type\": \"code\"' (source uses space) + note expected match count = 1. OBS-2: File Structure Requirements table footnote added for conditional MIXED-RANGE/DEMOTE spec-companion file additions."
  - "1.2 (2026-07-07): F3 adversarial pass 2 (preemptive) — replace numbered rung references with named outcomes (CONFIRMED-INPUT/MIXED-RANGE/DEMOTE) throughout Task 0 and Task 3 to eliminate cross-ladder collision with H-NEW-ADF-010 holdout ladder. Add holdout mapping sentence: holdout (i)/(ii)/(iii) = CONFIRMED-INPUT/DEMOTE/MIXED-RANGE. Update 1.1 changelog annotation to use named outcomes."
  - "1.1 (2026-07-07): F3 adversarial pass 1 fixes (3 items). MED-01: severity HIGH→MEDIUM (bug has workaround; no data loss; module_criticality HIGH unchanged). LOW-01: Task 3 topology-obligation sub-note added — MIXED-RANGE/DEMOTE outcomes for EC-4 require multi-node assertion rewrite in AC-004/AC-010 Call B/AC-011 Call E. LOW-02: AC-003 Tests bullet extended to surface test_bc_7_2_015_plain_code_baseline as control/baseline anchor (GREEN pre/post)."
  - "1.0 (2026-07-07): Initial F3 story authored per F2 CONVERGED spec (prd-delta-571.md v1.3.25 / verification-delta-571.md; 19 passes / 13 fix rounds). Status: draft (adversarial convergence follows)."
---

> **tdd_mode:** strict — full TDD Iron Law enforced (todo!() + Red Gate ≥0.5 required). Task 0 specifies the empirical-check adjudication ladder that MUST precede any production code change (see Tasks section).

> **Execute:** `/vsdd-factory:deliver-story S-ADF-CODE-MARK-1`

# S-ADF-CODE-MARK-1: ADF code-mark exclusivity — `push_code` allowlist filter

**Bundle**: ADF-CODE-MARK-EXCLUSIVITY  
**GitHub issue**: #571  
**BC anchors**: BC-7.2.015 (primary), BC-7.2.007 EC-2 (amendment — closure of deferred follow-up)  
**Holdout**: H-NEW-ADF-010 (Group 12, MUST-PASS)  
**VPs**: VP-571-001 (proptest), VP-571-002 (EC anchors), VP-571-003 (node-scoped stripping), VP-571-004 (reverse-path retention), VP-571-005 (JSM parity)

---

## Narrative

- **As a** developer or AI agent composing Jira issues with markdown-formatted descriptions
- **I want** code spans wrapped in typographic marks (e.g. `` **`code`** ``, `` ^`code`^ ``) to emit schema-valid ADF with only the `code` mark on the code text node
- **So that** Jira Cloud REST API accepts the ADF body without HTTP 400 rejection caused by the `code_inline_node` / `formatted_text_inline_node` schema exclusivity constraint

---

## Problem

The ADF v1 JSON schema partitions inline text nodes into two mutually-exclusive subtypes: `code_inline_node` (allows `code`, `link`, `annotation` only) and `formatted_text_inline_node` (allows typographic marks but NOT `code`). A text node carrying both `code` and a typographic mark satisfies neither subtype and is rejected by the Jira Cloud REST v3 ADF validator with HTTP 400.

Before this fix, `src/adf.rs::push_code` clones `self.active_marks` verbatim (including any open `strong`, `em`, `strike`, or `subsup` marks from a surrounding span) and appends `{"type":"code"}`. This produces schema-invalid ADF whenever a code span appears inside a typographic wrapper (e.g. `` **`code`** ``, `` ^`code`^ ``). BC-7.2.007 EC-2 previously documented this as "not guarded here — tracked as a follow-up." This story closes that follow-up.

---

## Solution

Add an allowlist filter inside `src/adf.rs::push_code` that retains only `link` and `annotation` marks from `active_marks` before appending `{"type":"code"}`. The filter operates on a clone of `active_marks` (so surrounding non-code text nodes in the same span retain their typographic marks unchanged). The existing `dedup_marks_by_type` call at the end of `push_code` is retained unchanged (BC-7.2.007 same-type dedup invariant). No other emit site is touched; `push_code` is the sole `{"type":"code"}` emit site in `markdown_to_adf`.

The reverse path (`adf_to_text` / `apply_marks`) is intentionally left lenient: it already renders externally-produced `[strong, code]` nodes as `` **`x`** `` and MUST continue to do so (EC-7 read-tolerance, VP-571-004).

---

## Acceptance Criteria

### AC-001 (traces to BC-7.2.015 precondition: test helpers contract)

Test helpers `assert_marks_eq` and `assert_link_mark_with_href` exist in `src/adf.rs::tests` as `#[cfg(test)]` free functions:

1. `fn assert_marks_eq(marks: &serde_json::Value, expected: &[&str])` — asserts the JSON `marks` array contains exactly the mark type names in `expected`, treated as an unordered set. Panics with a formatted message including the actual mark-types vector on mismatch.

2. `fn assert_link_mark_with_href(marks: &serde_json::Value, expected_href: &str)` — asserts the `marks` array contains a mark of type `"link"` whose `attrs["href"]` equals `expected_href`. Uses `mark["attrs"]["href"].as_str() == Some(expected_href)` field-by-field. Does NOT assert on `attrs["title"]` (absent for no-title links). Does NOT use `assert_eq!` on the full `attrs` object.

Both helpers must be authored BEFORE any forward anchors (prerequisite for AC-002 through AC-007).

- **Test:** `assert_marks_eq` and `assert_link_mark_with_href` — helpers, consumed by AC-002..AC-007

---

### AC-002 (traces to BC-7.2.015 EC-1: strong+code regression pin; BC-7.2.007 EC-2 pre-#571 write-strict clause (existing test carries the pre-fix RED evidence))

`test_markdown_inline_code_mark_and_composition` in `src/adf.rs::tests` has its existing assertion rewritten from the pre-fix form (asserting `strong` IS present) to the post-fix form:

```
assert_marks_eq(&code_node["marks"], &["code"]);
```

Locate via grep for `mark_types.contains(&"code") && mark_types.contains(&"strong")` — do NOT rely on line numbers. Surrounding non-code text nodes in the same test that carry `strong` are left untouched.

- **Test:** `test_markdown_inline_code_mark_and_composition` (rewritten assertion)

---

### AC-003 (traces to BC-7.2.015 EC-1: strong stripped)

`test_bc_7_2_015_strong_stripped_from_code_node` in `src/adf.rs::tests`:
- Input: `` **`x`** ``
- Asserts: `assert_marks_eq(&code_node["marks"], &["code"])` (strong absent)
- Pre-fix: RED (proven by class-transfer from AC-002); Post-fix: GREEN

- **Tests:** `test_bc_7_2_015_strong_stripped_from_code_node` (regression pin, RED pre-fix); `test_bc_7_2_015_plain_code_baseline` (control anchor — bare `` `x` `` with no surrounding marks; asserts `marks == [code]`; GREEN pre-fix AND post-fix; validates that the allowlist filter does not break the simplest case)

---

### AC-004 (traces to BC-7.2.015 EC-2/EC-3/EC-4: em, strike, subsup stripped; BC-7.2.007 EC-2 closure)

Three tests in `src/adf.rs::tests`:
- `test_bc_7_2_015_em_stripped_from_code_node`: input `` _`x`_ ``, asserts `marks == [code]`
- `test_bc_7_2_015_strike_stripped_from_code_node`: input `` ~~`x`~~ ``, asserts `marks == [code]`
- `test_bc_7_2_015_subsup_stripped_from_code_node`: input `` ^`x`^ ``, asserts `marks == [code]` (primary regression target, closes BC-7.2.007 EC-2)

Pre-fix RED/GREEN status empirically unconfirmed; resolved by Task 2 observation window. Post-fix: GREEN for all three. EC-4 outcome binds H-NEW-ADF-010 Calls B and E in lockstep.

- **Tests:** `test_bc_7_2_015_{em,strike,subsup}_stripped_from_code_node`

---

### AC-005 (traces to BC-7.2.015 EC-5: link mark preserved; VP-571-002 EC-5 two-part assertion)

`test_bc_7_2_015_link_preserved_on_code_node` in `src/adf.rs::tests`:
- Input: `` [`x`](https://ex/) ``
- Asserts both: `assert_marks_eq(&code_node["marks"], &["code", "link"])` AND `assert_link_mark_with_href(&code_node["marks"], "https://ex/")`
- Pre-fix: GREEN (retention/mutation-catcher anchor); Post-fix: GREEN

- **Test:** `test_bc_7_2_015_link_preserved_on_code_node`

---

### AC-006 (traces to BC-7.2.015 EC-6 + VP-571-003: node-scoped stripping)

Two tests in `src/adf.rs::tests`:

1. `test_bc_7_2_015_mixed_range_surrounding_marks_retained`: input `` **a `b` c** ``
   - `"a "` node: `assert_marks_eq(&node["marks"], &["strong"])`
   - `"b"` code node: `assert_marks_eq(&node["marks"], &["code"])` (strong stripped)
   - `" c"` node: `assert_marks_eq(&node["marks"], &["strong"])`

2. `test_bc_7_2_015_multi_mark_wrapper_only_code_node_stripped`: input `` _a **b `c` d** e_ ``
   - Code text node `"c"`: `assert_marks_eq(&node["marks"], &["code"])` (both em and strong stripped)
   - Sibling text nodes retain their full typographic mark stack

Catches the mutation where `push_code` filters `self.active_marks` in-place instead of filtering a clone.

- **Tests:** `test_bc_7_2_015_mixed_range_surrounding_marks_retained`, `test_bc_7_2_015_multi_mark_wrapper_only_code_node_stripped`

---

### AC-007 (traces to BC-7.2.015 PANEL-ANCHOR: panel.content traversal)

`test_bc_7_2_015_alert_wrapper_strong_code_stripped` in `src/adf.rs::tests`:
- Input: `"> [!NOTE]\n> **\`x\`**"`
- Asserts: ADF top-level node is a `panel` with `panelType: "info"`; within its `content`, text node `"x"` carries `assert_marks_eq(&node["marks"], &["code"])` (strong stripped)
- Pre-fix: RED expected by class-transfer from EC-1 (MUST be confirmed empirically per Task 2)
- Post-fix: GREEN

- **Test:** `test_bc_7_2_015_alert_wrapper_strong_code_stripped`

---

### AC-008 (traces to BC-7.2.015 EC-7 + VP-571-004: adf_to_text read-tolerance retained)

1. `test_render_marks_code_and_strong` and `test_render_strong_with_code_applies_code_innermost` remain GREEN through F4 with NO modification to their assertion bodies (they test the reverse path with hand-constructed ADF, not the write path).

2. `apply_marks` docstring updated to describe code-innermost behavior as "read-tolerance for externally-produced ADF" not write-path behavior.

3. The inline comment in `test_render_marks_code_and_strong` claiming "write path emits `[strong, code]`" updated to "externally-produced or legacy ADF that we must render tolerantly." The sibling test `test_render_strong_with_code_applies_code_innermost` carries the same stale write-path comment ("Matches the write-path's marks ordering: strong + code produces marks = [strong, code]") — that comment is also reframed to "externally-produced or legacy ADF that we must render tolerantly." Assertion bodies of both tests are untouched (MUST-STAY-GREEN).

- **Tests (MUST-STAY-GREEN):** `test_render_marks_code_and_strong`, `test_render_strong_with_code_applies_code_innermost`, `test_push_code_normalizes_lone_cr_in_inline_code`, `test_push_code_normalizes_bare_lf_to_space`

---

### AC-009 (traces to BC-7.2.015 universal quantifier + VP-571-001: proptest)

`prop_bc_7_2_015_no_code_marked_text_node_carries_typographic_marks` proptest in `src/adf.rs::tests`:

Generator `gen_mark_composition_markdown()` covers the FULL VP-571-001 specification — no MVP subset authorized:
- 9 container wrappers: none, blockquote, unordered list, ordered list, GFM task list, GFM alert (outermost-only), heading, GFM table cell (2-column 1-row), footnote-definition body
- All inline templates: plain code, strong+code, em+code, strike+code, subsup sup+code, subsup sub+code, link+code, mixed-range strong, mixed-range em, nested combinations
- Wrapper depth budget: ≤ 3; Proptest cases: default (~256); cap to 128 only if CI flake pressure appears (per VP-571-001)

Property: `assert_code_mark_exclusivity(&adf)` — free fn in `#[cfg(test)]` that recursively descends all container content arrays and asserts no text node with `{"type":"code"}` in `marks` carries any mark outside `{"code", "link", "annotation"}`. Generator combinators use approximately uniform weights across templates and wrappers (no branch below ~5% weight); weight-degenerate strategies do not satisfy this AC.

- **Test:** `prop_bc_7_2_015_no_code_marked_text_node_carries_typographic_marks`

---

### AC-010 (traces to BC-7.2.015 + VP-571-005: H-NEW-ADF-010 Calls A–D, platform path)

New file `tests/adf_code_mark_exclusivity.rs` with four wiremock integration tests (H-NEW-ADF-010 Calls A–D):

- **Call A** (EC-1, strong+code): `**\`hello\`**` → text `"hello"` marks == `[code]`
- **Call B** (EC-4, subsup+code — primary regression target): `^\`code\`^` (subject to EC-4 empirical-check outcome) → `"code"` marks == `[code]`
- **Call C** (EC-5, link+code preserved): `` [`code`](https://example.com) `` → `"code"` marks contain both `code` and link with `href == "https://example.com"` (GREEN pre-fix AND post-fix; retention anchor; parenthetical disclosure per H-NEW-ADF-010 Call C)
- **Call D** (EC-6, mixed-range): `**a \`b\` c**` → `"a "` → `[strong]`; `"b"` → `[code]`; `" c"` → `[strong]`

File placement follows the per-BC ADF test-file pattern (`tests/adf_recursion_depth.rs` for BC-7.2.012; `tests/adf_inline_html_inv1_e2e.rs` for BC-7.2.011). Consolidating into an existing file is NOT permitted.

- **Test:** `tests/adf_code_mark_exclusivity.rs` — four test functions per H-NEW-ADF-010 Calls A–D

---

### AC-011 (traces to BC-7.2.015 + VP-571-005 + ADR-0014: H-NEW-ADF-010 Call E, JSM path parity)

`tests/issue_create_jsm.rs` extended with H-NEW-ADF-010 Call E. Mounts (in order):
1. `GET /rest/api/3/project/HELPDESK` → 200 service_desk project metadata
2. `GET /rest/servicedeskapi/servicedesk` → 200 servicedesk list
3. `GET /rest/servicedeskapi/servicedesk/3/requesttype` with `query_param("start","0")` + `query_param("limit","50")` matchers → 200 requesttype list
4. `POST /rest/servicedeskapi/request` with `.expect(1)` → 201 JSM response
5. `POST /rest/api/3/issue` with `.expect(0)` (loud dispatch-fork regression guard)

Action: `jr issue create --project HELPDESK --request-type "Get IT Help" --summary "jsm-code" --markdown --no-input --description "^\`code\`^"`

Expected: exit 0; `requestFieldValues.description` text `"code"` has `marks == [code]`; platform POST NOT called. Per-test `JR_CACHE_DIR` + `JR_CONFIG_DIR` tempdir isolation (test-hardening note 1). Input subject to EC-4 empirical-check resolution in lockstep with Task 3 outcome (see Task 0 ladder and Task 3 topology-obligation sub-note).

- **Test:** new test function in `tests/issue_create_jsm.rs` per H-NEW-ADF-010 Call E

---

### AC-012 (traces to BC-7.2.015 documentation + BC-7.2.007 EC-2 deferral closure)

In `CLAUDE.md`, the "Markdown minor constructs → ADF (`adf.rs`, issue #474)" gotcha entry (~line 293) clause (b) tail is updated. The text from `, so` through `follow-up).` (inclusive) is replaced with:

```
 — enforced at emission time since #571: `push_code` strips typographic marks from code spans (see BC-7.2.015); `` ^`x`^ `` and `` **`x`** `` now emit schema-valid ADF with the `code` mark only.
```

Splice applied byte-for-byte from `prd-delta-571.md` §"Scope boundary note." Nothing to the left of `, so` changes.

- **Test:** `tests/claude_md_citations.rs::test_claude_md_citations_resolve_to_real_files` (BC-X.13.001) — the BC-7.2.015 back-pointer is a non-path citation and is excluded by the extractor's symbol-form filter; confirm PASS after splice.

---

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|---------------|
| `push_code` (ADF builder inline-code emit site) | `src/adf.rs` | pure-core |
| `markdown_to_adf` (Markdown → ADF pipeline entry) | `src/adf.rs` | pure-core |
| `adf_to_text` / `apply_marks` (ADF → text reverse path) | `src/adf.rs` | pure-core |
| `handle_jsm_create` (JSM path dispatch fork) | `src/cli/issue/jsm_create.rs` | effectful-shell |
| `handle_create` (platform path, markdown→ADF call site) | `src/cli/issue/create.rs` | effectful-shell |

---

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|-------------------|
| EC-1 | `strong` wrapping inline code: `` **`x`** `` | code node carries only `code` mark; `strong` stripped at emission |
| EC-2 | `em` wrapping inline code: `` _`x`_ `` | code node carries only `code` mark; `em` stripped |
| EC-3 | `strike` wrapping inline code: `` ~~`x`~~ `` | code node carries only `code` mark; `strike` stripped |
| EC-4 | `subsup` wrapping inline code: `` ^`x`^ `` | code node carries only `code` mark; `subsup` stripped (primary regression target; closes BC-7.2.007 EC-2 follow-up) |
| EC-5 | `link` mark coexisting with inline code: `` [`x`](url) `` | code node carries BOTH `code` AND `link` marks; `attrs.href` preserved field-by-field |
| EC-6 | Surrounding non-code text in typographic wrapper: `` **a `b` c** `` | code text node carries `code` only; sibling text nodes retain `strong` unchanged |
| EC-7 | Externally-produced ADF `[strong, code]` fed to `adf_to_text` | Rendered tolerantly; reverse path NOT tightened (write-strict / read-lenient asymmetry is load-bearing) |
| PANEL-ANCHOR | `` **`x`** `` inside GFM alert (`> [!NOTE]`) | code node inside `panel.content` carries only `code` mark; `assert_code_mark_exclusivity` descends panel |
| CONTROL | Bare inline code with no surrounding marks: `` `x` `` | code node carries exactly `[code]`; pre-fix GREEN and post-fix GREEN (baseline; not a regression pin) |

---

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|---------------|
| `src/adf.rs::push_code` | pure-core | Stateless mark-set filter; operates on in-memory ADF node list; no I/O |
| `src/adf.rs::markdown_to_adf` | pure-core | String → `serde_json::Value`; no external I/O; deterministic |
| `src/adf.rs::adf_to_text` | pure-core | `serde_json::Value` → String; no external I/O |
| `tests/adf_code_mark_exclusivity.rs` | effectful-shell (test boundary) | Uses wiremock for HTTP interception; isolated per test |
| `tests/issue_create_jsm.rs` (Call E addition) | effectful-shell (test boundary) | Uses wiremock + subprocess invocation; per-test TempDir isolation |

---

## Token Budget Estimate (MANDATORY)

| Context Source | Estimated Tokens |
|---------------|-----------------|
| This story spec | ~8,000 |
| `src/adf.rs` (~3,000 LOC target file) | ~12,000 |
| `src/cli/issue/jsm_create.rs` + `create.rs` | ~5,000 |
| `tests/issue_create_jsm.rs` (existing file for Call E) | ~4,000 |
| F2 spec artifacts (prd-delta + verification-delta, reference only) | ~4,000 |
| New test files (new `adf_code_mark_exclusivity.rs` + Call E additions) | ~5,000 |
| Tool outputs overhead | ~3,000 |
| **Total** | **~41,000** |
| Agent context window | 200K for Sonnet |
| **Budget usage** | **~21%** |

Target: ≤20–30% of agent context window. This story is within budget. No split required.

---

## Tasks (MANDATORY)

### Task 0: Empirical-check adjudication preamble (Red-Gate protocol — read before writing any code)

This is a preamble, not an implementation step. The three-rung ladder from VP-571-002 §"F4 Red-Gate empirical-check checklist" MUST be internalized before writing any EC-2/EC-3/EC-4 anchors:

**CONFIRMED-INPUT** (composes as-is → adopt): if pre-fix run (Task 2) shows the typographic mark IS present in the code node's `marks` array alongside `code`, the anchor is a valid regression pin. No spec update required.

**MIXED-RANGE** (composes only in mixed-range shape → adopt + multi-node topology rewrite + same-PR spec companion): if pre-fix run shows the outer span did NOT open around `Event::Code` for a tight input, adjust to a mixed-range composing form (e.g. `` ^a `b` c^ `` where the code node inherits the mark from the surrounding text run). Re-run pre-fix. Adopt the mixed-range input and apply the **phase-perimeter spec-companion clause (R13-LOW-3)**: the F4 PR includes a companion spec-delta commit updating (α) the VP-571-002 anchor-matrix row in `.factory/phase-f2-spec-evolution/verification-delta-571.md` to reflect the new mixed-range input shape AND (β) H-NEW-ADF-010 Call B and Call E Expected sections in `.factory/specs/prd/holdout-scenarios.md` rewritten to multi-node topology. Then rewrite EC-4 assertions to multi-node topology per the Task 3 topology obligation.

**DEMOTE** (no composing form exists → schema-derived demotion + strong-form substitution for Calls B/E + same-PR spec companion): if no composing form exists, demote the anchor from "regression pin" to "schema-derived defensive anchor (documented, untested pre-fix)." Apply the **phase-perimeter spec-companion clause (R13-LOW-3)**: the F4 PR includes a companion spec-delta commit updating (α) the VP-571-002 anchor-matrix row in `.factory/phase-f2-spec-evolution/verification-delta-571.md` and (β) H-NEW-ADF-010 §"Empirical-check propagation" in `.factory/specs/prd/holdout-scenarios.md` for Calls B and E. Both edits land in the SAME PR (precedent: PR #592 two-tier shape-guard spec companion).

> **Holdout mapping:** the H-NEW-ADF-010 §"Empirical-check propagation" ladder uses numbered rungs — its (i)/(ii)/(iii) correspond to CONFIRMED-INPUT/DEMOTE/MIXED-RANGE respectively. Use named outcomes when cross-referencing to avoid confusion.

EC-4 (subsup+code) outcome BINDS H-NEW-ADF-010 Calls B and E. All three must be resolved in lockstep.

---

### Task 1: Author test helpers, existing-test rewrite, and all forward anchors (PRE-FILTER)

Author all of the following in `src/adf.rs::tests` BEFORE touching any production code:

1. `fn assert_marks_eq(marks: &serde_json::Value, expected: &[&str])` helper (AC-001, locked contract)
2. `fn assert_link_mark_with_href(marks: &serde_json::Value, expected_href: &str)` helper (AC-001, locked contract)
3. Rewrite `test_markdown_inline_code_mark_and_composition` assertion — locate via grep for `mark_types.contains(&"code") && mark_types.contains(&"strong")` (AC-002)
4. `test_bc_7_2_015_plain_code_baseline` — control anchor (bare `` `x` ``; asserts `marks == [code]`; GREEN pre/post)
5. `test_bc_7_2_015_strong_stripped_from_code_node` (EC-1; AC-003)
6. `test_bc_7_2_015_em_stripped_from_code_node` (EC-2; AC-004)
7. `test_bc_7_2_015_strike_stripped_from_code_node` (EC-3; AC-004)
8. `test_bc_7_2_015_subsup_stripped_from_code_node` (EC-4; AC-004 — primary regression target)
9. `test_bc_7_2_015_link_preserved_on_code_node` (EC-5; AC-005)
10. `test_bc_7_2_015_mixed_range_surrounding_marks_retained` (EC-6; AC-006)
11. `test_bc_7_2_015_multi_mark_wrapper_only_code_node_stripped` (VP-571-003; AC-006)
12. `test_bc_7_2_015_alert_wrapper_strong_code_stripped` (PANEL-ANCHOR; AC-007)

Do NOT apply the `push_code` filter in this task. The test suite SHOULD have RED anchors here.

---

### Task 2: Run pre-fix observation window — capture RED/GREEN evidence

Run anchors against `HEAD` BEFORE any production code change:

```
cargo test --lib -- test_bc_7_2_015_ test_markdown_inline_code_mark_and_composition
```

For each of EC-2 (em), EC-3 (strike), EC-4 (subsup variants), and PANEL-ANCHOR: record the actual emitted `marks` array per anchor in a mandatory "Red-Gate pre-fix evidence" section of the F4 PR description (all outcomes, including CONFIRMED-INPUT). This observation window is destroyed by Task 4 and cannot be reconstructed.

Expected: EC-1 (strong) RED (proven), EC-5 (link) and control GREEN. EC-2/EC-3/EC-4/PANEL-ANCHOR: empirically unconfirmed — Task 2 resolves them.

---

### Task 3: Resolve unexpectedly-GREEN regression-pin anchors

For any anchor authored as a Red-Gate regression pin (EC-1 through EC-4, EC-6 code node, PANEL-ANCHOR) that came back GREEN in Task 2, apply the three-rung adjudication ladder from Task 0. For EC-4 specifically: propagate the resolution to H-NEW-ADF-010 Calls B and E in lockstep. This task is a no-op if all expected-RED anchors came back RED.

- **Topology obligation when MIXED-RANGE or DEMOTE applies to EC-4:** If the MIXED-RANGE outcome adopts a mixed-range composing form (e.g. `` ^a `b` c^ ``) for the EC-2/EC-3/EC-4 anchors (only EC-4 carries the downstream Call B/E propagation obligation), the AC-004 EC-4 test + AC-010 Call B + AC-011 Call E assertions MUST be rewritten from single-node topology (one text node `"x"` carrying `[code]`) to multi-node topology (three text nodes: `"a "` → `[subsup]`, `"b"` → `[code]`, `" c"` → `[subsup]`). The single-text-node assertion MUST NOT be retained if the input is changed to a mixed-range form — the assertion would be a false positive against a structurally different event sequence. Both MIXED-RANGE and DEMOTE require a same-PR spec-companion commit (see Task 0 for exact files and sections). The DEMOTE outcome (no composing form) is the only path where the EC-4 test is entirely removed from the regression-pin set; in that case the anchor becomes schema-derived defensive (documented, untested pre-fix) per the phase-perimeter clause in Task 0.

---

### Task 4: Apply the `push_code` typographic-mark allowlist filter in `src/adf.rs`

Implement the filter in `src/adf.rs::push_code` — filter a clone of `active_marks`, retaining only marks whose `type` is `"link"` or `"annotation"`, append `{"type":"code"}`, then call `dedup_marks_by_type`. Do NOT mutate `self.active_marks`. Do NOT touch the SEMANTICS of `push_text`, `text_to_adf`, `adf_to_text`, or `apply_marks` (its docstring refresh is Task 6).

---

### Task 5: Confirm forward anchors GREEN + MUST-STAY-GREEN verification

Re-run all Task 1 anchors — every anchor MUST pass post-fix:

```
cargo test --lib -- test_bc_7_2_015_ test_markdown_inline_code_mark_and_composition
```

Confirm MUST-STAY-GREEN list (VP-571-004 + BC-7.2.011):
- `test_render_marks_code_and_strong`
- `test_render_strong_with_code_applies_code_innermost`
- `test_push_code_normalizes_lone_cr_in_inline_code`
- `test_push_code_normalizes_bare_lf_to_space`

Run full `cargo test --lib` to confirm no regressions across `src/adf.rs::tests`.

---

### Task 6: Refresh `apply_marks` docstring and `test_render_marks_code_and_strong` inline comment

1. `apply_marks` docstring: reword code-innermost description from "write-path behavior" to "read-tolerance for externally-produced ADF."
2. Inline comment in `test_render_marks_code_and_strong` claiming the write path emits `[strong, code]`: rewrite to "externally-produced or legacy ADF that we must render tolerantly." The sibling test `test_render_strong_with_code_applies_code_innermost` carries the same stale write-path comment ("Matches the write-path's marks ordering: strong + code produces marks = [strong, code]") — rewrite it to the same read-tolerance framing. No assertion bodies change in either test (MUST-STAY-GREEN).

---

### Task 7: CLAUDE.md clause-(b) splice

Apply AC-012: replace `, so ^`x`^ would be invalid — not guarded here (pre-existing class: **`x`** has the same issue; tracked as a follow-up).` (from `, so` through `follow-up).` inclusive) with the byte-for-byte splice from `prd-delta-571.md` §"Scope boundary note." Confirm `tests/claude_md_citations.rs` still passes.

---

### Task 8: Proptest — `prop_bc_7_2_015_no_code_marked_text_node_carries_typographic_marks`

Land the VP-571-001 proptest in `src/adf.rs::tests` with the FULL generator per AC-009 (9 container wrappers, all inline templates, ≤3 wrapper depth, default ~256 cases; cap to 128 only if CI flake pressure appears). Alert wrapper (wrapper 6) must be outermost-only (VP-571-001 Footnote A). `assert_code_mark_exclusivity` recursive tree-walk helper is a free fn in the same `#[cfg(test)]` module.

---

### Task 9: Integration tests — H-NEW-ADF-010 Calls A–E

**Calls A–D** (`tests/adf_code_mark_exclusivity.rs` — NEW file): one test per call per H-NEW-ADF-010 Expected assertions. File follows `tests/adf_recursion_depth.rs` import/structure pattern. Apply EC-4 empirical-check resolution to Call B input in lockstep with Task 3 outcome.

**Call E** (`tests/issue_create_jsm.rs` — extension): mount sequence per AC-011; use `query_param()` matcher for requesttype endpoint query string; per-test `JR_CACHE_DIR` + `JR_CONFIG_DIR` tempdir isolation — mirror the existing inline `.env("JR_CACHE_DIR", ...).env("JR_CONFIG_DIR", ...)` per-test `TempDir` pattern already used throughout `tests/issue_create_jsm.rs` (integration-test binaries do not share private helpers across files; do NOT introduce a `jr_cmd_with_xdg` cross-file call); apply EC-4 empirical-check resolution to Call E input in lockstep with Task 3 outcome.

Run `cargo test --test adf_code_mark_exclusivity` and `cargo test --test issue_create_jsm` to confirm.

---

## Previous Story Intelligence (MANDATORY)

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|--------------|---------------------|-------------------|
| S-BC-CITATION-GUARD-1 | Phase-perimeter clause for spec-companion commits in same PR (PR #592 precedent); EC-CITE-0xx anchors must be pre-fix RED before filter lands | Per-test TempDir isolation for cache/config paths via `jr_cmd_with_xdg`; CANONICAL_MODE guard uses floor(0.75 × N) coverage floor | RED-gate observation window must be captured BEFORE any production change; empirical confirmation cannot be reconstructed post-fix |
| S-MUTANTS-SCOPE-GUARDS-1 | Glob-existence guard pattern (`tests/mutants_glob_existence.rs`) | Debug-only env var release gate pattern (`#[cfg(debug_assertions)]` + pinned by release_gate test) | Always add a new `JR_*` env var doc entry to CLAUDE.md in the same commit as the code change (doc-fallout pattern from #335/#357) |

---

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|-------------|
| `push_code` is the SOLE emit site for `{"type":"code"}` marks in `markdown_to_adf`; no other emit site may be introduced | CLAUDE.md §Architecture (`src/adf.rs` description) + ADR-0012 | `grep -n '"type": "code"' src/adf.rs` — expect multiple matches; exactly 1 must be OUTSIDE the `#[cfg(test)] mod tests` block (currently `src/adf.rs::push_code`); all others are in test assertions |
| No unsafe code without justification comment | CLAUDE.md §Conventions | `cargo clippy -- -D warnings`; zero warnings policy |
| `adf_to_text` read-tolerance for externally-produced `[strong, code]` ADF must NOT be removed or tightened | BC-7.2.015 EC-7 + VP-571-004 | MUST-STAY-GREEN tests: `test_render_marks_code_and_strong`, `test_render_strong_with_code_applies_code_innermost` (AC-008) |
| JSM dispatch fork in `handle_create` is gated solely on `request_type.is_some()` — platform path byte-for-byte unchanged | ADR-0014 + CLAUDE.md §Gotchas | H-NEW-ADF-010 Call E `.expect(0)` on `POST /rest/api/3/issue` acts as a live regression guard |
| No lint suppression (`#[allow]`) without refactoring; if refactoring impractical, ask user + include justification comment | CLAUDE.md §Conventions | `cargo clippy -- -D warnings`; any new `#[allow]` requires explicit approval |
| BC-7.2.011 INV-1: no raw `\n` in non-codeBlock text nodes | CLAUDE.md §Gotchas (`push_text`/`push_code` CR/LF normalization) | `test_push_code_normalizes_lone_cr_in_inline_code` + `test_push_code_normalizes_bare_lf_to_space` (MUST-STAY-GREEN) |

---

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|---------|
| pulldown-cmark | 0.13.x (as in `Cargo.lock`) | Markdown parser; `ENABLE_FOOTNOTES`, `ENABLE_GFM`, `ENABLE_TASKLISTS`, `ENABLE_SUPERSCRIPT`, `ENABLE_SUBSCRIPT`, `ENABLE_HEADING_ATTRIBUTES` flags; EC-2/EC-3/EC-4 composition behavior is version-specific — do not upgrade without re-running Task 2 observation window |
| serde_json | as in `Cargo.lock` | ADF JSON construction; test assertions (`["marks"][N]["type"]` field navigation) |
| wiremock | as in `Cargo.lock` | HTTP mock server for H-NEW-ADF-010 Calls A–E integration tests; `query_param()` matcher required for Call E requesttype endpoint |
| proptest | as in `Cargo.lock` | Property-based test for VP-571-001 (128-case budget; `ProptestConfig` cap) |

---

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|---------|
| `src/adf.rs` | modify | Add allowlist filter in `push_code`; add `#[cfg(test)]` helpers `assert_marks_eq` + `assert_link_mark_with_href`; rewrite `test_markdown_inline_code_mark_and_composition` assertion; add EC-1..EC-7 + control + PANEL-ANCHOR unit tests; add proptest strategy + `assert_code_mark_exclusivity` helper; refresh `apply_marks` docstring + `test_render_marks_code_and_strong` inline comment |
| `CLAUDE.md` | modify | Clause (b) splice in "Markdown minor constructs → ADF" gotcha (~line 293): replace stale `, so … follow-up).` tail with enforced behavior description per BC-7.2.015 |
| `tests/adf_code_mark_exclusivity.rs` | create | H-NEW-ADF-010 Calls A–D (platform path wiremock integration tests); per-BC test-file pattern |
| `tests/issue_create_jsm.rs` | modify | H-NEW-ADF-010 Call E (JSM path parity); new test function with 5-mount setup; `.expect(0)` dispatch-fork regression guard on `POST /rest/api/3/issue` |

> **(Conditional additions under MIXED-RANGE or DEMOTE outcomes):** `.factory/phase-f2-spec-evolution/verification-delta-571.md` (modify — EC-4 anchor-matrix row updated to reflect new input shape or demotion) and `.factory/specs/prd/holdout-scenarios.md` (modify — H-NEW-ADF-010 Call B + Call E Expected sections rewritten to multi-node topology or removed from regression-pin set) land in the SAME PR as same-PR spec companions. See Task 0 for the exact trigger condition.

---

## Out-of-Scope

- **Node-splitting enhancement**: `push_code` filter is correct; node boundaries come from pulldown-cmark event structure, not from `push_code`.
- **`adf_to_text` read-path hardening**: EC-7 read-tolerance is intentional and retained (load-bearing asymmetry).
- **`href` scheme sanitization**: link marks retained verbatim; not a BC-7.2.015 concern per BC-7.2.015 §Behavior security framing.
- **`dedup_marks_by_type` removal or relocation**: retained unchanged per R8-LOW-1 resolution.
- **Dedicated tests for `underline`, `textColor`, `backgroundColor`**: no pulldown-cmark composing form; surviving mutants for these types are an accepted-class per Mutation-Testing Note §item 2.
- **Annotation-mark dedicated test**: `jr` does not emit `annotation` marks today; surviving mutant for annotation is accepted-class per Mutation-Testing Note.

---

## Test-Hardening Notes (from F2 adversarial passes 18/19)

1. **Per-test `JR_CACHE_DIR`/`JR_CONFIG_DIR` tempdir isolation for Call E**: the `tests/issue_create_jsm.rs` Call E test MUST use per-test tempdir isolation for both cache and config directories. A warm cache bypasses the project-meta and requesttype fixture mounts, causing non-deterministic test behavior.

2. **`POST /rest/api/3/issue` with `.expect(0)` in Call E**: this is a loud dispatch-fork regression guard. If `handle_create` routes to the platform path instead of `handle_jsm_create`, the test fails immediately with `.expect(0)` violated — surfacing the structural error. Do NOT omit this mount.

3. **`query_param()` matcher for requesttype endpoint**: wiremock `path()` matcher excludes the query string. Mount the requesttype endpoint with separate `query_param("start", "0")` and `query_param("limit", "50")` matchers or use `path_and_query()` — a path-only mount will shadow any `servicedeskapi` GET on that path in a multi-test run.

---

## Demo Plan

All ACs are verified by `cargo test` output rather than observable CLI behavior changes (the correctness improvement is in the ADF POST body, invisible to human-mode terminal output).

**Primary evidence for AC-001..AC-009**: `cargo test --lib` output showing all helpers, existing-test rewrite, `test_bc_7_2_015_*` anchors, and `prop_bc_7_2_015_*` proptest passing on the post-fix branch. The pre-fix RED observation from Task 2 is recorded in the mandatory "Red-Gate pre-fix evidence" PR description section.

**Primary evidence for AC-010/AC-011**: `cargo test --test adf_code_mark_exclusivity` and `cargo test --test issue_create_jsm` showing H-NEW-ADF-010 Calls A–E green.

**Primary evidence for AC-012**: `tests/claude_md_citations.rs` passing (BC-X.13.001) plus the CLAUDE.md diff hunk showing the clause-(b) splice applied byte-for-byte.

**Optional VHS recording**: `jr issue create --project PROJ --type Task --markdown --no-input --description "**\`hello\`**"` exiting 0 is illustrative only — it can show exit code and JSON output (issue key) but not ADF body correctness. The authoritative evidence is the integration test output.

---

## Spec Reference Links

- BC-7.2.015 (primary): `.factory/specs/prd/bc-7-output-render.md` ~line 527
- BC-7.2.007 EC-2 (amendment): `.factory/specs/prd/bc-7-output-render.md` ~line 161
- H-NEW-ADF-010: `.factory/specs/prd/holdout-scenarios.md` ~line 1336
- F1 delta: `.factory/phase-f1-delta-analysis/adf-code-mark-2026-07-07-delta.md`
- F2 PRD delta: `.factory/phase-f2-spec-evolution/prd-delta-571.md`
- F2 verification delta: `.factory/phase-f2-spec-evolution/verification-delta-571.md`
