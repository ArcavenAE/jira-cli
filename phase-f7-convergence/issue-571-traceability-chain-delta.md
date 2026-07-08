---
document_type: f7-traceability-chain-delta
feature: issue-571 / S-ADF-CODE-MARK-1
bundle: ADF-CODE-MARK-EXCLUSIVITY
spec_version: v1.1.0
pr_fix: "#593"
pr_changelog: "#594"
pr_sha_fix: 7ba4cf4
pr_sha_changelog: d7875e6
date: 2026-07-08
producer: state-manager
inputs:
  - ".factory/stories/S-ADF-CODE-MARK-1.md"
  - ".factory/specs/prd/bc-7-output-render.md"
  - ".factory/phase-f6-hardening/summary.md"
input-hash: "1aa2d75"
---

# Traceability Chain — S-ADF-CODE-MARK-1 Delta (issue #571)

This document records the end-to-end traceability for the S-ADF-CODE-MARK-1 delta, linking
behavioral contracts through verification properties, implementation artifacts, test coverage,
adversarial convergence, and hardening verification.

Bundle: **ADF-CODE-MARK-EXCLUSIVITY**. BC-7.2.015 (new primary) + BC-7.2.007 EC-2 (amended —
closure of deferred follow-up from issue #474). Merged via PRs #593 (fix) + #594 (changelog)
on `develop` at `d7875e6`.

---

## BC → VP → Implementation → Test → Verification

### BC-7.2.015 — ADF code-mark exclusivity at `push_code` emit site

| Link | Artifact |
|------|----------|
| **Behavioral Contract** | `BC-7.2.015` in `.factory/specs/prd/bc-7-output-render.md` |
| **Spec anchor** | A text node emitted by `markdown_to_adf` that carries a `code` mark may only additionally carry `link` and/or `annotation` marks; all typographic marks (`strong`, `em`, `strike`, `subsup`, `underline`, `textColor`, `backgroundColor`) are stripped from the code node's mark set at emission time in `src/adf.rs::push_code`; surrounding non-code text nodes in the same span retain their typographic marks unchanged; `adf_to_text` read-tolerance for externally-produced ADF with typographic+code combinations is retained (write-strict / read-lenient asymmetry). |
| **Amends** | BC-7.2.007 EC-2 (issue #474): "not guarded here — tracked as a follow-up" → "enforced at emission time since #571: `push_code` strips typographic marks from code spans (see BC-7.2.015)". The deferred follow-up is closed by this bundle. |
| **Relates to** | BC-7.2.011 INV-1 chokepoint: `push_code` is one of the three INV-1 enforcement points (alongside `push_text` and `text_to_adf`) that prevent raw `\n`/`\r` in non-codeBlock text nodes. The allowlist filter in `push_code` operates alongside that CR/LF normalization; both are guarded at the same function boundary in `src/adf.rs`. |
| **Implementation** | `src/adf.rs::push_code` — clone of `self.active_marks`, filter retaining only `Some("link") \| Some("annotation")` mark types, append `{"type":"code"}`, then `dedup_marks_by_type`. `self.active_marks` is never mutated (VP-571-003 node-scoped stripping guarantee). This is the sole production emit site for `{"type":"code"}` marks in the codebase. |

---

### VP-571-001 → Tests (property-based universal quantifier)

| Link | Artifact |
|------|----------|
| **Verification Property** | VP-571-001: property-based whole-document invariant — over generated markdown inputs, every ADF text node whose `marks` array contains a `code` mark carries marks that are a subset of `{"code", "link", "annotation"}`. |
| **Test symbol** | `src/adf.rs::tests::prop_bc_7_2_015_no_code_marked_text_node_carries_typographic_marks` (proptest, 256 cases at default; `PROPTEST_CASES=2000` in F6 hardening — PASS) |
| **Generator coverage** | 9 container wrappers × all inline templates (plain, strong+code, em+code, strike+code, subsup sup+code, subsup sub+code, link+code, mixed-range strong, mixed-range em, nested combinations); ≤3 wrapper depth; GFM alert outermost-only (VP-571-001 Footnote A) |
| **Recursive helper** | `src/adf.rs::tests::assert_code_mark_exclusivity` — free fn; descends all `content` arrays (paragraph, heading, blockquote, listItem, bulletList, orderedList, taskList, taskItem, panel, table/tableRow/tableCell/tableHeader) |
| **F6 result** | PASS — `PROPTEST_CASES=2000` run on `develop` @ `d7875e6` (10× default; held as formal-verification substitute per `.factory/phase-f6-hardening/kani-results.md`) |

---

### VP-571-002 → Tests (example-based EC anchors)

| Link | Artifact |
|------|----------|
| **Verification Property** | VP-571-002: one deterministic `#[test]` per EC-1..EC-6 asserting the exact `marks` set on the code text node (order-agnostic set comparison via `assert_marks_eq` helper). |
| **Test symbols — `src/adf.rs::tests`** | |
| — CONTROL (baseline) | `test_bc_7_2_015_plain_code_baseline` — bare `` `x` ``; asserts `marks == [code]`; GREEN pre-fix and post-fix (not a regression pin) |
| — EC-1 (strong stripped) | `test_bc_7_2_015_strong_stripped_from_code_node` — `` **`x`** ``; asserts `marks == [code]`; RED pre-fix (CONFIRMED: `["strong","code"]` observed), GREEN post-fix |
| — EC-2 (em stripped) | `test_bc_7_2_015_em_stripped_from_code_node` — `` _`x`_ ``; asserts `marks == [code]`; RED pre-fix (CONFIRMED-INPUT: `["em","code"]` observed), GREEN post-fix |
| — EC-3 (strike stripped) | `test_bc_7_2_015_strike_stripped_from_code_node` — `` ~~`x`~~ ``; asserts `marks == [code]`; RED pre-fix (CONFIRMED-INPUT: `["strike","code"]` observed), GREEN post-fix |
| — EC-4 (subsup stripped; primary regression target) | `test_bc_7_2_015_subsup_stripped_from_code_node` — `` ^`x`^ ``; asserts `marks == [code]`; RED pre-fix (CONFIRMED-INPUT: `["subsup","code"]` observed), GREEN post-fix. Closes BC-7.2.007 EC-2 deferred follow-up. |
| — EC-5 (link preserved) | `test_bc_7_2_015_link_preserved_on_code_node` — `` [`x`](https://ex/) ``; asserts both `marks ⊇ {code, link}` (via `assert_marks_eq`) AND `attrs.href == "https://ex/"` (via `assert_link_mark_with_href`); GREEN pre-fix and post-fix (retention anchor) |
| — EC-1 existing-test rewrite | `test_markdown_inline_code_mark_and_composition` — assertion rewritten from `mark_types.contains(&"strong")` to `assert_marks_eq(&code_node["marks"], &["code"])`; RED pre-fix, GREEN post-fix |
| **Helper contracts** | `assert_marks_eq` — unordered set comparison on mark-type names; `assert_link_mark_with_href` — field-by-field `attrs.href` check; both in `src/adf.rs::tests` (#[cfg(test)]) |

---

### VP-571-003 → Tests (node-scoped stripping)

| Link | Artifact |
|------|----------|
| **Verification Property** | VP-571-003: code node carries `[code]` only; sibling text nodes in the same typographic wrapper retain their full mark stack unchanged. Catches "filter `self.active_marks` in-place" mutation. |
| **Test symbols — `src/adf.rs::tests`** | |
| — EC-6 mixed-range | `test_bc_7_2_015_mixed_range_surrounding_marks_retained` — `` **a `b` c** ``; `"a "` → `[strong]`, `"b"` → `[code]`, `" c"` → `[strong]`; RED pre-fix (code node had `[strong,code]`), GREEN post-fix |
| — multi-mark wrapper | `test_bc_7_2_015_multi_mark_wrapper_only_code_node_stripped` — `` _a **b `c` d** e_ ``; code text node `"c"` → `[code]`; sibling nodes retain `em`/`em+strong` stack; RED pre-fix (code node had `[em,strong,code]`), GREEN post-fix |
| — PANEL-ANCHOR | `test_bc_7_2_015_alert_wrapper_strong_code_stripped` — `` > [!NOTE]\n> **`x`** ``; ADF top-level is `panel` (panelType `"info"`); text `"x"` → `[code]`; RED pre-fix (CONFIRMED-INPUT: `["strong","code"]`), GREEN post-fix |

---

### VP-571-004 → Tests (reverse-path read-tolerance retained — MUST-STAY-GREEN)

| Link | Artifact |
|------|----------|
| **Verification Property** | VP-571-004: `adf_to_text` renders externally-produced `[strong, code]` (or any typographic+code) nodes tolerantly as `` **`x`** ``. These tests MUST stay GREEN through F4; do not delete or rewrite their assertion bodies. |
| **Test symbols — `src/adf.rs::tests`** | |
| — read-tolerance 1 | `test_render_marks_code_and_strong` — comment refreshed to "externally-produced or legacy ADF that we must render tolerantly"; assertion body untouched; GREEN pre- and post-fix |
| — read-tolerance 2 | `test_render_strong_with_code_applies_code_innermost` — same comment refresh; assertion body untouched; GREEN pre- and post-fix |
| — CR/LF INV-1 1 | `test_push_code_normalizes_lone_cr_in_inline_code` — BC-7.2.011 INV-1 retention anchor; GREEN pre- and post-fix |
| — CR/LF INV-1 2 | `test_push_code_normalizes_bare_lf_to_space` — BC-7.2.011 INV-1 retention anchor; GREEN pre- and post-fix |
| **Docstring refresh** | `src/adf.rs::apply_marks` — description reworded from "write-path behavior" to "read-tolerance for externally-produced ADF"; behavioral semantics unchanged |

---

### VP-571-005 → Tests (JSM path parity — H-NEW-ADF-010 Calls A–E)

| Link | Artifact |
|------|----------|
| **Verification Property** | VP-571-005: BC-7.2.015 invariant holds on both the platform (`/rest/api/3/issue`) and JSM (`/rest/servicedeskapi/request`) POST bodies, because `markdown_to_adf` is the single shared conversion engine. Enforced by holdout H-NEW-ADF-010. |
| **Holdout anchor** | H-NEW-ADF-010 (Group 12, MUST-PASS) — Calls A–E |
| **Test file — platform path (Calls A–D)** | `tests/adf_code_mark_exclusivity.rs` (new file; per-BC pattern, mirrors `tests/adf_recursion_depth.rs` for BC-7.2.012) |
| — Call A (EC-1, strong+code) | `` **`hello`** `` → text `"hello"` `marks == [code]`; wiremock `POST /rest/api/3/issue` |
| — Call B (EC-4, subsup+code; primary regression target) | `` ^`code`^ `` (CONFIRMED-INPUT via Task 3 observation) → `"code"` `marks == [code]`; wiremock `POST /rest/api/3/issue` |
| — Call C (EC-5, link+code preserved) | `` [`code`](https://example.com) `` → `"code"` marks contain both `code` and link with `href == "https://example.com"`; GREEN pre- and post-fix (retention anchor) |
| — Call D (EC-6, mixed-range) | `` **a `b` c** `` → `"a "` → `[strong]`; `"b"` → `[code]`; `" c"` → `[strong]` |
| **Test file — JSM path (Call E)** | `tests/issue_create_jsm.rs` (extended with new test function) |
| — Call E | `jr issue create --project HELPDESK --request-type "Get IT Help" --summary "jsm-code" --markdown --no-input --description "^\`code\`^"`; 5-mount wiremock sequence; `requestFieldValues.description` text `"code"` has `marks == [code]`; `POST /rest/api/3/issue` with `.expect(0)` dispatch-fork regression guard (ADR-0014); per-test `JR_CACHE_DIR` + `JR_CONFIG_DIR` TempDir isolation |

---

### Implementation → Source File Map

| File | Delta | Purpose |
|------|-------|---------|
| `src/adf.rs` | +594 lines (production + test) | `push_code` allowlist filter; `assert_marks_eq` + `assert_link_mark_with_href` helpers; EC-1..EC-7 + CONTROL + PANEL-ANCHOR unit tests; `prop_bc_7_2_015_*` proptest + `assert_code_mark_exclusivity` helper; `apply_marks` docstring refresh + two reverse-path test comment refreshes; `test_markdown_inline_code_mark_and_composition` assertion rewrite |
| `CLAUDE.md` | +1/−1 | Clause (b) splice in "Markdown minor constructs → ADF" gotcha: stale `, so … follow-up).` tail replaced with enforced-behavior description citing BC-7.2.015 and `push_code` |
| `tests/adf_code_mark_exclusivity.rs` | +499 lines (new) | H-NEW-ADF-010 Calls A–D (platform path wiremock integration tests) |
| `tests/issue_create_jsm.rs` | +237 lines | H-NEW-ADF-010 Call E (JSM path parity); 5-mount wiremock; `.expect(0)` dispatch-fork guard |

---

## Convergence Evidence

### F3 Spec Adversarial Convergence

| Phase | Passes | Fix Rounds | Clean Window | Verdict |
|-------|--------|-----------|--------------|---------|
| F3 story spec (S-ADF-CODE-MARK-1) | 10 | 6 | p8/p9/p10 on v1.7 | CONVERGED STRICT (DEC-160) |
| F4 delivery (Step 4.5) | 4 | — | p2/p3/p4 | CONVERGED STRICT |

F3 fix rounds addressed: severity HIGH→MEDIUM (pass 1), spec-companion clause clarifications for MIXED-RANGE/DEMOTE (passes 2–4), AC-009 proptest weight-uniformity (pass 5), AC-008 comment-refresh scope extension (pass 6). All EC-2/EC-3/EC-4/PANEL-ANCHOR anchors resolved as **CONFIRMED-INPUT** (Task 3 was a no-op — no MIXED-RANGE or DEMOTE outcomes; no spec-companion commits required).

### PR Review

| Cycle | Findings | Verdict |
|-------|---------|---------|
| 1 (fresh-eyes, different model family) | 0 BLOCKING, 0 NON-BLOCKING, 1 LOW informational (test helper unbounded recursion — mitigated by production `MAX_ADF_DEPTH=256`) | APPROVE |

---

## Verification Chain

| Verification Type | Result | Evidence |
|------------------|--------|----------|
| Formal proofs (proptest substitute) | PASS — `PROPTEST_CASES=2000` (10× default) | `.factory/phase-f6-hardening/kani-results.md` |
| Fuzz testing | JUSTIFIED SKIP | No cargo-fuzz in project; proptest at 2000 cases is the substitute; no new panic/I/O surface. `.factory/phase-f6-hardening/fuzz-results.md` |
| Mutation testing (`--in-diff`) | **100% kill rate (1/1)** | `src/adf.rs:1282:9 replace push_code with ()` caught in 4.2 s. `.factory/phase-f6-hardening/mutation-results.md` |
| cargo deny | PASS (exit 0) | 0 advisories/bans/license errors; 3 unused-allowance warnings (baseline). `.factory/phase-f6-hardening/summary.md` |
| cargo audit | PASS (exit 0) | 347 crates, 0 vulnerabilities. `.factory/phase-f6-hardening/summary.md` |
| Security (BC-7.2.015 SEC framing) | PASS | Restrictive-only allowlist; no untrusted-input execution; no `href` scheme validation change; no CRIT/HIGH findings. |
| Full regression | **PASS — 2007/0/93** | 0 failures across full workspace. `.factory/phase-f6-hardening/summary.md` |
| cargo clippy | CLEAN (exit 0) | Zero warnings. `.factory/phase-f6-hardening/summary.md` |
| cargo fmt | CLEAN (exit 0) | No formatting drift. `.factory/phase-f6-hardening/summary.md` |
| DTU adversarial | N/A (justified) | `push_code` is pure-core; no external-service interaction change. `dtu_required=false` |

---

## S-ADF-CODE-MARK-1 Story → BC Anchors Summary

| Story | BCs Implemented | VPs | Test Files |
|-------|----------------|-----|-----------|
| S-ADF-CODE-MARK-1 | BC-7.2.015 (new), BC-7.2.007 EC-2 (amended → closed) | VP-571-001..005 | `src/adf.rs::tests` (inline unit + proptest), `tests/adf_code_mark_exclusivity.rs`, `tests/issue_create_jsm.rs` (Call E) |

---

## Cross-References

- **BC-7.2.015 amends BC-7.2.007 EC-2 (subsup):** The `BC-7.2.007` EC-2 clause previously read "not guarded here — tracked as a follow-up" (issue #474). It is now superseded: the allowlist filter in `src/adf.rs::push_code` enforces exclusivity for all typographic marks including `subsup`. The CLAUDE.md gotcha for issue #474 has been spliced at clause (b). See `.factory/specs/prd/bc-7-output-render.md` §BC-7.2.007 EC-2 for the update notice.

- **Relates to BC-7.2.011 INV-1 chokepoint:** `src/adf.rs::push_code` is one of three INV-1 enforcement points (with `push_text` and `text_to_adf`). The new allowlist filter operates at the same function boundary as the CR/LF normalization chokepoint documented in CLAUDE.md §Gotchas. The MUST-STAY-GREEN tests `test_push_code_normalizes_lone_cr_in_inline_code` and `test_push_code_normalizes_bare_lf_to_space` were verified green.

- **PRs:** #593 (fix — squash-merged to `develop` at `7ba4cf4`) + #594 (changelog — at `d7875e6`)

- **Holdout H-NEW-ADF-010:** Group 12, MUST-PASS. Calls A–D in `tests/adf_code_mark_exclusivity.rs`; Call E in `tests/issue_create_jsm.rs`. All five calls passed. EC-4 (subsup) empirical-check outcome: CONFIRMED-INPUT (Task 3 was a no-op; `^\`code\`^` input form retained unchanged in Calls B and E).

---

## Main Traceability Chain Append Note

No `convergence/traceability-chain.md` or equivalent unified project-level traceability matrix exists under `.factory/cycles/cycle-001/`. Checked: `find .factory/cycles -name "traceability-chain.md"` returned no results. This delta document is the authoritative traceability artifact for the S-ADF-CODE-MARK-1 / issue-571 bundle.

If a project-level unified traceability matrix is created in a future cycle, the S-ADF-CODE-MARK-1 entries from this file should be merged with the key:
`bc_ids: [BC-7.2.015, BC-7.2.007]`, `story: S-ADF-CODE-MARK-1`, `bundle: ADF-CODE-MARK-EXCLUSIVITY`, `pr_fix: #593`, `pr_changelog: #594`, `sha: d7875e6`.

Prior traceability deltas in this directory:
- S-388: `traceability-chain-delta.md`
- S-398: `issue-398-traceability-chain-delta.md`
- issue-407: `issue-407-traceability-chain-delta.md`
- fork-ops backfill: `traceability-chain-delta-fork-ops-backfill.md`
- win-build: `win-build/traceability-chain-delta.md`
