---
document_type: adversary-convergence-report
feature: "issue #475 — ADF E2E read-path coverage"
phase: F3 (Incremental Stories)
date: 2026-06-11
verdict: CONVERGED
rounds: 2
---

# Adversary Convergence Report — F3 Story Decomposition, Issue #475

## Verdict: CONVERGED

Two adversary rounds completed. Round 1 found 2 findings; both were fixed. Round 2
produced three consecutive clean passes (0/0/0) with zero novelty. Gate APPROVED
2026-06-11.

---

## Round 1

### Pass 1 — Findings: 2

**F1 (MEDIUM) — comfy-table cell-wrap fragility in AC-1 multi-word substring assertions**

The original AC-1 assertion strings were multi-word phrases (e.g. "Section Header",
"code snippet", "blockquote link"). comfy-table wraps long cell content at column
boundaries, which can split these strings across lines in the rendered terminal output.
The E2E test captures human-mode stdout and asserts via `contains(...)`. A cell wrap
would cause a multi-word assertion to fail spuriously — not a logic bug in the
implementation, but a brittle test design that would yield a false-positive CI failure
on narrow terminals or long column content.

**F2 (LOW) — STORY-INDEX:30 prose count drift 67/32**

STORY-INDEX.md line 30 prose read "67 stories ... feature-followup 32 stories" while
frontmatter `total_stories:` was still 68 (correctly updated by story-writer). A reader
scanning line 30 prose would see 67, mismatching the frontmatter. The manifest row at
line 305 (Total rows: 68) agreed with frontmatter; prose alone was stale.

### Fix Verification

**F1 fix — verified real:**

AC-1 assertions were revised to use single-token discriminators:

- `contains("Header")` — targets the heading text; comfy-table will not wrap a
  single word unless the column is narrower than the word itself (impossible for
  "Header"). Non-tautological: `adf_to_text` renders `heading` nodes as
  `## Section Header`; the fixture content word "Header" appears only in the heading
  context, not in body text. Absence of "Header" would indicate heading rendering
  failure.
- `"snippet"` — targets the code block body text. `adf_to_text` renders `codeBlock`
  nodes as fenced blocks containing the literal source text. Non-tautological: this
  word appears only in the code block content; its absence indicates code-block
  rendering failure.
- `"blockquote"` — targets the blockquote paragraph text. The fixture sentence is
  "A blockquote paragraph." `adf_to_text` unwraps `blockquote` nodes to `> ` prefix
  + paragraph text. Non-tautological: this word is the fixture prose; its absence
  indicates blockquote unwrapping failure.
- `"link"` — targets the link anchor text. `adf_to_text` renders a `link`-marked
  text node as `[anchor](href)`. Non-tautological: the fixture anchor text is "a
  link"; its absence indicates link-mark rendering failure.

Wrap-risk note present in story comments: single-token assertions are wrap-safe
because comfy-table only wraps at word boundaries and these tokens contain no
internal spaces.

AC-3 verified already wrap-resilient: the `_emphasis_` discriminator for comment
read path is a single-token underscore-delimited sequence that comfy-table will not
split (no internal spaces; the whole token is shorter than any realistic column width).

**F2 fix — verified real:**

STORY-INDEX.md line 30 prose updated to "68 stories ... feature-followup 33 stories".
All three count surfaces now agree:
- Frontmatter line 6: `total_stories: 68`
- Prose line 30: "68 stories ... feature-followup 33 stories"
- Manifest footer line 305: "Total rows: 68"

No stale 67/32 values remain.

---

## Round 2 (fresh context adversary — no memory of Round 1)

### Pass 1: 0 findings

Fresh-context adversary reviewed S-475-adf-e2e-readpath.md and STORY-INDEX.md from
scratch. Zero findings. No regression from Round 1 fixes. No novel issues identified.

### Pass 2: 0 findings

Second fresh pass over all F3 artifacts. Zero findings. Confirmed: AC/BC bidirectional
traces present and consistent; dependency graph acyclic (Kahn's: leaf node); conflict
detection clean (tests/e2e_live.rs not modified by any in-progress story); effort
estimate reasonable (3 SP / 1 day); wave assignment correct (feature-followup, leaf).

### Pass 3: 0 findings

Third fresh pass. Three consecutive clean passes achieved. Convergence criterion met.

---

## Helper Existence Verification (cited in S-475)

All helpers cited in S-475 ACs verified to exist or be resolvable:

| Helper | Location | Status |
|--------|----------|--------|
| `poll_view` | `tests/e2e_live.rs` ~line 474 | EXISTS — used by existing task-list tests around line 9074 |
| `adf_has_task_item` | `tests/e2e_live.rs` ~line 8912 | EXISTS — gated under JR_RUN_E2E |
| `adf_contains_text` | `tests/e2e_live.rs` ~line 8932 | EXISTS |
| `adf_has_node_type` | `tests/e2e_live.rs` ~line 8950 | EXISTS |
| `adf_has_blockquote_in_list_item` | NOT YET AUTHORED | TO BE WRITTEN in F4 per story AC-2 spec |

Rename touch-points verified present:
- `tests/e2e_live.rs` ~line 4591: function `test_e2e_issue_markdown_description_roundtrip` — present, rename target confirmed
- `docs/specs/e2e-live-jira-testing.md` ~line 123: bullet citing the old test name — present, rename touch-point confirmed

No exact-tree-equality assertions present in S-475 (structural + rendered assertions only,
per spec v1.3.9 mandate that Jira silently normalizes stored ADF server-side).

---

## Convergence Summary

| Dimension | Result |
|-----------|--------|
| Leaf node, acyclic | CONFIRMED |
| BC anchors traced (bidirectional) | CONFIRMED — BC-7.2.003 / BC-7.2.004 / BC-7.2.006 |
| BC 594 / NFR 41 unchanged | CONFIRMED — no new BCs or NFRs authored |
| No exact-tree-equality assertions | CONFIRMED |
| Helper existence (all cited) | CONFIRMED (adf_has_blockquote_in_list_item deferred to F4) |
| Rename touch-points present | CONFIRMED |
| Wrap-resilient assertions | CONFIRMED — single-token discriminators |
| No process-gap findings in Round 2 | CONFIRMED |
| Gate | APPROVED 2026-06-11 |

---

## Process Gap Logged

**O1-TABLE-ASSERT (DEFERRED LOW):** S-475 is the first human-mode (table output) E2E
test in the suite. There is no shared `assert_table_contains` / de-wrap helper for
asserting against comfy-table stdout. The single-token approach is sufficient this cycle.
A shared helper should be codified before more human-mode E2E tests land to prevent
copy-paste fragility. Logged as drift item O1-TABLE-ASSERT in STATE.md.
