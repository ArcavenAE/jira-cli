---
document_type: story
story_id: "S-D4-TEST-HARDENING-BACKFILL-1"
title: "Retroactive F3 traceability — D4 ADF regression pins (#560) and cache-coverage audit pins (#561)"
wave: feature-followup
status: done
intent: test-hardening-backfill
feature_type: test-only
mode: feature
scope: small
severity: LOW
trivial_scope: false
issue: ~560-561
points: 2
priority: P2
tdd_mode: strict
estimated_effort: xsmall
estimated_days: 0
target_module: adf,cache
subsystems: []
depends_on: []
blocks: []
bc_anchors:
  - BC-7.2.011
  - BC-6.2.009
  - BC-6.2.011
bcs:
  - BC-7.2.011
  - BC-6.2.009
  - BC-6.2.011
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-story-decomposition
spec_source: ".factory/research/cache-coverage-audit-2026-06-27.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 10
assumption_validations: []
risk_mitigations: []
created: "2026-06-27"
last_updated: "2026-06-27"
breaking_change: false
retroactive: true
retroactive_reason: >
  Both PRs were delivered via a lighter flow (direct F3+merge without a pre-delivery
  story file).  This story provides the missing F3 traceability and closes the process
  deviation.  No production source change is involved; all 10 ACs are characterization
  pins — each was verified PASS at the time of merge.
predecessor_cycles: >
  PR #560 (test(adf): plain-text block-HTML + discrete footnote node shapes, develop @
  9657b1e); PR #561 (test(cache): per-profile cache isolation + fields.json self-heal,
  develop @ 5ab4e0f).
origin: >
  D4 holdout convergence (PR #560: two adf regression gaps surfaced by holdout scenario
  O-1 and footnote node-granularity audit) and cache-coverage audit
  (.factory/research/cache-coverage-audit-2026-06-27.md, PR #561: BC-6.2.009 cross-profile
  isolation families + BC-6.2.011 corrupt/legacy format self-heal).
f5_review_outcome: >
  F5 fresh-context adversarial review run post-merge for both PRs: CLEAN (0 CRIT/HIGH/MED,
  3 LOW observations — no follow-up PR required).  This story records that clean signal as
  the authoritative F5 gate for this delivery.
delivering_prs:
  - "PR #560 — develop @ 9657b1e"
  - "PR #561 — develop @ 5ab4e0f"
skip_log:
  - reason: "Per-AC demo recording N/A — test-only story; no user-facing surface added or changed."
changelog:
  - date: "2026-06-27"
    phase: F3-story-decomposition
    author: story-writer
    summary: >
      Retroactive F3 traceability backfill for PRs #560 and #561.  10 characterization pins
      documented across BC-7.2.011 (2 adf::tests) and BC-6.2.009/BC-6.2.011 (8 cache tests).
      F5 review outcome: CLEAN (0 CRIT/HIGH/MED).
files_modified:
  - src/adf.rs    # 2 new inline unit tests: test_block_html_plain_text_interior_lines_preserved_in_one_paragraph, test_footnote_reference_and_definition_are_discrete_unmarked_text_nodes
  - src/cache.rs  # 8 new inline unit tests: cache_profile_isolation_tests module (6 fns) + fields_cache_format_drift_tests module (2 fns)
---

# S-D4-TEST-HARDENING-BACKFILL-1 — Retroactive F3 Traceability: D4 ADF + Cache Test Pins

## Status

**DONE — already delivered.**

This story is a RETROACTIVE TRACEABILITY BACKFILL. Both PRs were merged to `develop`
before a story file was written (process deviation from the standard F3-first flow). This
document provides the missing F3 artifact and closes the deviation. No production code is
or was changed by either PR; all acceptance criteria are characterization pins.

**F5 fresh-context adversarial review** was run post-merge and returned **CLEAN** — 0
CRIT / 0 HIGH / 0 MED / 3 LOW observations. No follow-up PR was required. The CLEAN
signal is recorded in `f5_review_outcome` frontmatter above.

## Source of Truth

| Artifact | Location |
|----------|----------|
| Cache coverage audit | `.factory/research/cache-coverage-audit-2026-06-27.md` |
| BC-7.2.011 body | `.factory/specs/prd/bc-7-output-render.md §7.2.011` |
| BC-6.2.009 body | `.factory/specs/prd/bc-6-config-cache.md §6.2.009` |
| BC-6.2.011 body | `.factory/specs/prd/bc-6-config-cache.md §6.2.011` |
| PR #560 commit | `develop @ 9657b1e` |
| PR #561 commit | `develop @ 5ab4e0f` |

## Behavioral Contracts

| BC | Title | Role in this story |
|----|-------|-------------------|
| BC-7.2.011 | `markdown_to_adf` block-HTML + CR/LF normalization invariants (INV-1) | PRIMARY: two regression pins from D4 holdout — Algorithm B plain-text interior lines (O-1) and footnote reference/definition node-granularity (O-3, issue #472) |
| BC-6.2.009 | Cross-profile cache isolation: writing `prod` does NOT make `sandbox` cache visible | PRIMARY: 6 cache-family isolation pins across workspace, resolutions, cmdb_fields, fields, object_type_attrs, project_meta |
| BC-6.2.011 | Corrupt cache files (garbage data + valid-JSON-wrong-shape) both return `Ok(None)` | PRIMARY: 2 fields.json format-drift self-heal pins (legacy ID-only array + garbage bytes / wrong-shape JSON) |

Also referenced in body (non-anchor): footnote behavioral contract is covered under
BC-7.2.011 via the issue #472 gotcha entry; no separate footnote BC exists (the footnote
node-granularity test is an AC-tracing pin for the existing BC-7.2.011 clause).

## Story Narrative

As a developer maintaining the `jr` codebase,
I want regression tests that pin the behavioral guarantees of block-HTML Algorithm B,
footnote node granularity, and per-profile cache isolation / format self-heal,
so that future refactors immediately surface regressions against these behavioral contracts
before they reach CI and before they affect users.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~1,500 |
| src/adf.rs excerpt (2 test fns, ~150 LOC) | ~700 |
| src/cache.rs excerpt (8 test fns + 2 modules, ~450 LOC) | ~1,800 |
| BC files (3 BC sections, bc-6 + bc-7) | ~600 |
| **Total** | **~4,600** |

Well within a 20% agent context window budget. No splitting required.

## Previous Story Intelligence

**PR #560 predecessor context (S-492, S-522, S-525):**
The two adf tests in PR #560 were surfaced by D4 holdout convergence that identified
Algorithm B (BC-7.2.011) had a coverage gap for plain-text interior lines (holdout O-1)
and footnote node-granularity (O-3, issue #472). The sibling story S-492 delivered
Algorithm B; S-522 delivered the `push_text` / `push_code` CR/LF chokepoint. PR #560
adds pins that S-492/S-522 did not include.

**PR #561 predecessor context (S-396, S-525):**
The cache isolation tests were surfaced by a coverage audit of `src/cache.rs`. Story
S-396 (`issue edit --field`) introduced `write_fields_cache` / `read_fields_cache` with
per-profile scoping, but no cross-profile isolation test existed. The audit documented
this gap for all 6 cache families plus the `fields.json` format-drift self-heal.
S-TESTTOOL-1 expanded cargo-mutants scope to include `src/cache.rs`, making these tests
also reachable via mutation testing.

**N/A — no successor stories blocked by this backfill.**

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Test-only scope | Both PRs | No production source file modified; `src/adf.rs` and `src/cache.rs` test modules only. No CLI flags, API calls, config, or keychain changes. |
| No new ADF invariant violations | BC-7.2.011 INV-1 | All text-node assertions in the ADF tests must confirm `\n` / `\r` absence (INV-1). Each AC-001 / AC-002 assertion already includes this check inline. |
| `with_temp_cache` isolation | `src/cache.rs::tests::with_temp_cache` | All cache tests run inside `with_temp_cache` to prevent on-disk side effects and cross-test profile leakage. No test writes to the real `~/.cache/jr/` path. |
| No numeric test-count citations in BC bodies | scripts/check-bc-no-numeric-test-counts.sh | The BC `Source:` and `Trace:` fields reference test names and file paths only — not counts. This story does not modify BC bodies; it documents tests that already satisfy BC Source/Trace fields. |

## Library and Framework Requirements

| Library | Version | Constraint |
|---------|---------|-----------|
| pulldown-cmark | 0.13.x (from Cargo.toml) | Algorithm B relies on CommonMark §4.6 block-continuation behaviour. No version change. |
| serde_json | current (from Cargo.toml) | ADF JSON structural assertions in `test_block_html_plain_text_interior_lines_preserved_in_one_paragraph`. No version change. |
| chrono | current (from Cargo.toml) | `ProjectMeta.fetched_at: Utc::now()` in `test_project_meta_cross_profile_isolation`. No version change. |

No new crate dependencies were added by either PR.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `src/adf.rs` | MODIFIED (PR #560) | 2 new inline unit tests appended to `adf::tests` module: `test_block_html_plain_text_interior_lines_preserved_in_one_paragraph` and `test_footnote_reference_and_definition_are_discrete_unmarked_text_nodes` |
| `src/cache.rs` | MODIFIED (PR #561) | `mod cache_profile_isolation_tests` (6 test fns) and `mod fields_cache_format_drift_tests` (2 test fns) added to the inline test section |

No new files were created. No integration test files were added.

---

## Acceptance Criteria

All ACs below are **characterization pins** — each was verified PASS at the time the
delivering PR merged. No production change is required. Each AC includes the test
function name that satisfies it.

---

### PR #560 — ADF Regression Pins (src/adf.rs)

#### AC-001 — Block-HTML plain-text interior lines produce one paragraph with hardBreak separators
(traces to BC-7.2.011 postcondition / Algorithm B — plain-text interior lines preserved as one paragraph with N-1 hardBreak nodes; O-1 regression pin)

`markdown_to_adf("<div>\nline one\nline two\n</div>")` produces exactly one top-level
node of type `"paragraph"` containing exactly 7 content nodes:
`[text("<div>"), hardBreak, text("line one"), hardBreak, text("line two"), hardBreak, text("</div>")]`.
All text nodes contain no raw `\n` or `\r` character (BC-7.2.011 INV-1).

This pin closes the D4 holdout scenario O-1 coverage gap: the existing
`test_convert_multiline_block_html_preserves_interior_newlines` used HTML-tag interior
lines; this test covers plain-text interior lines that follow the same Algorithm B path.

Verified PASS (develop @ 9657b1e).
Pinned by: `src/adf.rs::tests::test_block_html_plain_text_interior_lines_preserved_in_one_paragraph`

---

#### AC-002 — Footnote reference and definition produce discrete, unmarked text nodes
(traces to BC-7.2.011 postcondition — footnote reference emits a plain, unmarked `[label]` text marker; issue #472 node-granularity pin)

`markdown_to_adf("See note.[^1]\n\n[^1]: The note body.")` produces:
- `content[0]` (reference paragraph) containing exactly 2 text nodes: `"See note."` and `"[1]"`.
  The `"[1]"` node carries zero marks (not bold, not link-mark, no inherited marks).
- A rule node separating references from definitions.
- A definition paragraph containing text that includes `"[1]"` as a label prefix.

This pin closes the D4 holdout scenario O-3 coverage gap: pre-existing tests
(`test_markdown_footnote_reference_renders_marker_not_literal_caret` and
`test_markdown_footnote_definition_appended_after_rule_with_label`) verified string
content but NOT node-level discreteness or mark absence at the individual node level.

Verified PASS (develop @ 9657b1e).
Pinned by: `src/adf.rs::tests::test_footnote_reference_and_definition_are_discrete_unmarked_text_nodes`

---

### PR #561 — Cache Coverage Audit Pins (src/cache.rs)

#### AC-003 — workspace cache is isolated per profile
(traces to BC-6.2.009 postcondition — `read_team_cache("sandbox")` returns None after writing prod cache; path construction `cache_root().join("v1").join(profile)`)

After writing distinct workspace IDs to `"prod"` and `"sandbox"`, reading `"prod"`
returns the prod workspace ID and reading `"sandbox"` returns the sandbox ID. The
on-disk paths `cache_dir("prod").join("workspace.json")` and
`cache_dir("sandbox").join("workspace.json")` are distinct (`assert_ne!`).

Verified PASS (develop @ 5ab4e0f).
Pinned by: `src/cache.rs::cache_profile_isolation_tests::test_workspace_cache_cross_profile_isolation`

---

#### AC-004 — resolutions cache is isolated per profile
(traces to BC-6.2.009 postcondition — cross-profile isolation; wrong resolution name would silently corrupt `jr issue move` payload)

After writing `"Fixed"` resolutions to `"prod"` and `"Resolved"` to `"sandbox"`,
reading each profile returns only its own list. The on-disk paths are distinct.

Verified PASS (develop @ 5ab4e0f).
Pinned by: `src/cache.rs::cache_profile_isolation_tests::test_resolutions_cache_cross_profile_isolation`

---

#### AC-005 — cmdb_fields cache is isolated per profile
(traces to BC-6.2.009 postcondition — highest sub-risk family: custom-field IDs differ between sandbox and prod; a leak would silently write the wrong field ID into an asset-enriched issue payload)

After writing `customfield_10191` to `"prod"` and `customfield_20001` to `"sandbox"`,
reading each profile returns only its own field ID. Because `write_cmdb_fields_cache`
is a model-b (always-Ok) writer, the test also asserts the cache files were actually
created on disk after each call.

Verified PASS (develop @ 5ab4e0f).
Pinned by: `src/cache.rs::cache_profile_isolation_tests::test_cmdb_fields_cache_cross_profile_isolation`

---

#### AC-006 — fields cache is isolated per profile
(traces to BC-6.2.009 postcondition — Story Points field ID differs between instances; a leak would target the wrong field on `issue edit --field`)

After writing `customfield_10016` (`"Story Points"`) to `"prod"` and `customfield_10028`
to `"sandbox"`, reading each profile returns only its own field ID. Because
`write_fields_cache` is a model-b writer, the test also asserts the cache files were
created on disk.

Verified PASS (develop @ 5ab4e0f).
Pinned by: `src/cache.rs::cache_profile_isolation_tests::test_fields_cache_cross_profile_isolation`

---

#### AC-007 — object_type_attrs cache is isolated per profile
(traces to BC-6.2.009 postcondition — attribute IDs can differ across CMDB workspaces; a leak would cause AQL queries with wrong attribute IDs)

After writing attribute ID `"134"` to `"prod"` (object type `"23"`) and ID `"999"` to
`"sandbox"` (same object type `"23"`), reading each profile returns only its own
attribute. On-disk paths are distinct.

Verified PASS (develop @ 5ab4e0f).
Pinned by: `src/cache.rs::cache_profile_isolation_tests::test_object_type_attr_cache_cross_profile_isolation`

---

#### AC-008 — project_meta cache is isolated per profile
(traces to BC-6.2.009 postcondition — same project key "HELPDESK" in two profiles must return distinct service_desk_id; existing multi-project test only exercised one profile)

After writing `service_desk_id: Some("15")` to `"prod"` and `Some("77")` to `"sandbox"`
for project key `"HELPDESK"`, reading each profile returns only its own service desk ID
and project ID. On-disk paths are distinct.

Verified PASS (develop @ 5ab4e0f).
Pinned by: `src/cache.rs::cache_profile_isolation_tests::test_project_meta_cross_profile_isolation`

---

#### AC-009 — Legacy ID-only fields.json self-heals as Ok(None)
(traces to BC-6.2.011 postcondition — corrupt cache files return Ok(None); format-change resilience)

Writing a bare-string JSON array `["customfield_10001", "customfield_10016"]` to
`fields.json` (the pre-`(id,name)` tuple format) and calling `read_fields_cache("default")`
returns `Ok(None)` — not `Err` and not `Some`. The caller re-fetches from the API, self-healing
the stale format. This matches the documented CLAUDE.md behaviour for `cmdb_fields.json`.

Verified PASS (develop @ 5ab4e0f).
Pinned by: `src/cache.rs::fields_cache_format_drift_tests::test_fields_cache_legacy_id_only_format_self_heals`

---

#### AC-010 — Garbage bytes and wrong-shape JSON in fields.json both self-heal as Ok(None)
(traces to BC-6.2.011 postcondition — two corruption modes: (1) unparseable bytes and (2) valid JSON wrong shape; both → Ok(None))

Case 1: writing `b"not json {{{{ garbage"` to `fields.json` and calling
`read_fields_cache("default")` returns `Ok(None)` — not `Err`.
Case 2: writing `{"unexpected_key": true, "no_fields_array": null}` and calling
`read_fields_cache("default")` returns `Ok(None)`. Both cases confirm the `read_cache`
serde-error swallow path is exercised for `fields.json`.

Verified PASS (develop @ 5ab4e0f).
Pinned by: `src/cache.rs::fields_cache_format_drift_tests::test_corrupt_fields_cache_returns_none`

---

## Out of Scope (explicit)

**No production source changes.** Both PRs are test-only. No CLI flag, API method,
config path, keychain entry, or observable user-facing behaviour was changed.

**Per-AC demo recording.** These are pure regression pins with no observable user-facing
surface. Skip Log: `per-AC demo recording N/A — test-only / no user-facing surface`.

**request_type_cache cross-profile isolation tests (`test_request_type_cache_cross_profile_isolation`,
`test_request_type_fields_cache_cross_profile_isolation`)** are also present in
`src/cache.rs::request_type_cache_tests` from a prior cycle (S-288-pr2-cli). They are NOT
part of this story — they pre-date this backfill. This story covers only the 8 new tests
in `cache_profile_isolation_tests` and `fields_cache_format_drift_tests`.

---

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `test_block_html_plain_text_interior_lines_preserved_in_one_paragraph` | `src/adf.rs::tests` | Pure (test assertion only) | Invokes `markdown_to_adf` (pure fn) and asserts structural properties of the returned JSON value |
| `test_footnote_reference_and_definition_are_discrete_unmarked_text_nodes` | `src/adf.rs::tests` | Pure (test assertion only) | Invokes `markdown_to_adf` (pure fn) and asserts node-level discreteness and mark absence |
| `cache_profile_isolation_tests` (6 fns) | `src/cache.rs` (inline) | Effectful (disk I/O via `with_temp_cache`) | Uses `with_temp_cache` for XDG isolation; writes and reads real files in a temp dir; asserts path-distinctness |
| `fields_cache_format_drift_tests` (2 fns) | `src/cache.rs` (inline) | Effectful (disk I/O via `with_temp_cache`) | Writes intentionally corrupt/legacy-shaped files; asserts `Ok(None)` return |

**Subsystem anchor justification:** No ARCH-INDEX subsystem applies — both modified files
are single-purpose modules (`src/adf.rs` ADF transform, `src/cache.rs` XDG cache layer)
with no cross-subsystem interaction in these test additions.

**Dependency anchor justification:** `depends_on: []` — all prerequisite production code
for both ADF (Algorithm B in S-492; `push_text` chokepoint in S-522) and cache
(`write_fields_cache` / `read_fields_cache` from S-396; model-b writers documented in
S-525) was already merged before PRs #560/#561. `blocks: []` — no story depends on these
test pins.

---

## Edge Cases

| ID | Source | Description | Expected Behavior | AC |
|----|--------|-------------|-------------------|----|
| EC-001 | BC-7.2.011 / O-1 | Block-HTML block whose interior lines are plain prose (not HTML tags) | CommonMark §4.6 continuation: all lines form one HtmlBlock event; Algorithm B produces one paragraph with N-1 hardBreak nodes | AC-001 |
| EC-002 | BC-7.2.011 INV-1 | All text nodes in the resulting ADF must contain no raw `\n` or `\r` | Each text node is individually checked; violation indicates Algorithm B step-2 strip or step-3 normalize-then-split regressed | AC-001 |
| EC-003 | BC-7.2.011 / O-3 | Footnote reference in an active-marks context (e.g. inside `**bold**`) must NOT inherit those marks | `push_footnote_marker` bypasses `push_text` entirely; no mark inheritance at all — this is documented in BC-7.2.011; pinned separately by `test_markdown_footnote_reference_marker_does_not_inherit_marks` (pre-existing). The AC-002 fixture has no surrounding marks; the mark-inheritance edge case is not tested here. | AC-002 |
| EC-004 | BC-6.2.009 | `write_cmdb_fields_cache` and `write_fields_cache` are model-b writers that always return Ok(()) | Silent write no-op would leave the test asserting None for a value expected to be Some; file-existence assertion immediately after write catches this | AC-005, AC-006 |
| EC-005 | BC-6.2.011 | Legacy bare-string array `["customfield_10001"]` — valid JSON, wrong shape | `read_fields_cache` matches on serde deserialize error → Ok(None); no panic | AC-009 |
| EC-006 | BC-6.2.011 | Garbage non-JSON bytes — completely unparseable | `read_fields_cache` matches on serde deserialize error → Ok(None); no panic | AC-010 |

---

## Test Coverage Summary

All tests are inline unit tests. No new integration test files. No E2E tests.

### PR #560 — src/adf.rs (2 new tests)

| Test name | BC | AC |
|-----------|----|----|
| `test_block_html_plain_text_interior_lines_preserved_in_one_paragraph` | BC-7.2.011 | AC-001 |
| `test_footnote_reference_and_definition_are_discrete_unmarked_text_nodes` | BC-7.2.011 | AC-002 |

### PR #561 — src/cache.rs (8 new tests)

| Test name | BC | AC |
|-----------|----|----|
| `cache_profile_isolation_tests::test_workspace_cache_cross_profile_isolation` | BC-6.2.009 | AC-003 |
| `cache_profile_isolation_tests::test_resolutions_cache_cross_profile_isolation` | BC-6.2.009 | AC-004 |
| `cache_profile_isolation_tests::test_cmdb_fields_cache_cross_profile_isolation` | BC-6.2.009 | AC-005 |
| `cache_profile_isolation_tests::test_fields_cache_cross_profile_isolation` | BC-6.2.009 | AC-006 |
| `cache_profile_isolation_tests::test_object_type_attr_cache_cross_profile_isolation` | BC-6.2.009 | AC-007 |
| `cache_profile_isolation_tests::test_project_meta_cross_profile_isolation` | BC-6.2.009 | AC-008 |
| `fields_cache_format_drift_tests::test_fields_cache_legacy_id_only_format_self_heals` | BC-6.2.011 | AC-009 |
| `fields_cache_format_drift_tests::test_corrupt_fields_cache_returns_none` | BC-6.2.011 | AC-010 |

**Total new tests: 10.** All pass at delivering commits (develop @ 9657b1e, 5ab4e0f).
`cargo test` green on both. No test renames; no test deletions.

---

## Dependency Analysis

**No dependency cycle introduced.** This story has `depends_on: []` and `blocks: []`.
It is a leaf node in the dependency graph.

Wave placement: feature-followup (retroactive backfill of delivered test-only changes).
No wave gate impact — story is already `done`.

---

## Story Points and Effort

**2 story points** (retroactive F3 traceability document only; implementation already merged).

Breakdown:
- F3 story authoring: 1 SP
- F5 review: already run post-merge (CLEAN); no separate dispatch needed: 1 SP

From-scratch TDD estimate would be ~3 SP. Reduction reflects that all tests are already
written, merged, and passing.
