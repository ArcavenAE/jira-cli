---
document_type: bc-authoring-plan
product: jr (jira-cli)
date: "2026-06-27"
status: PLAN-ONLY — no BC files written
drift_item: MISSING-BC-SUBCLAUSE-PATTERN
baseline_total_bcs: 603
proposed_total_bcs: 609
new_bc_ids: 6
author: product-owner (planning pass)
---

# BC-Authoring Plan — MISSING-BC-SUBCLAUSE-PATTERN Backfill
## 2026-06-27 Planning Pass

**Purpose:** Characterize already-shipped behaviors that have full test coverage and
CLAUDE.md Gotchas entries but no dedicated behavioral contract body. These missing
sub-clauses break the holdout/wiremock anchor chain (the D4 broken-anchor class
identified in DEC-137 / MISSING-BC-SUBCLAUSE-PATTERN STATE.md drift item).

**Scope:** 9 behaviors itemized in the drift item (6 ADF-wave, 1 cache, 2 read/error).

**This document is planning-only. No BC files, BC-INDEX, or CANONICAL-COUNTS were
modified. All counts below are projected; actual authoring must run
`check-bc-cumulative-counts.sh` and `check-spec-counts.sh` after each burst.**

---

## 1. Behavior-by-Behavior Decision Table

### How to read this table

- **Decision:** EXTEND = add a new Edge Case or clause to an existing BC body (no new
  `#### BC-` heading, no count change). NEW = add a new `#### BC-` heading with a new
  ID (increments both `definitional_count` in the file frontmatter AND `total_bcs` in
  the file frontmatter, BC-INDEX, CANONICAL-COUNTS, and preamble prose).
- **Count impact:** An in-body Edge Case (EC-NNN) appended to an existing BC section
  does NOT increment any BC count. A new `#### BC-` heading increments by 1.
- **Anchor:** The holdout/wiremock test reference that cites this contract.

---

| # | Behavior | GitHub Issue | Decision | Proposed ID | Target File | Anchor for Tests | Trace Sources (qualitative) |
|---|----------|-------------|----------|-------------|-------------|------------------|-----------------------------|
| 1 | Markdown footnotes → ADF: `[^1]` → unmarked `[1]` text marker; definitions flushed at `finish()` as `rule` + paragraph; `push_footnote_marker` bypasses `push_text`/`dedup_marks`; empty-container pruning (empty blockquote from `> [^1]: x` eliminated) | #472 | **NEW BC-7.2.013** | BC-7.2.013 | bc-7-output-render.md | `test_e2e_markdown_footnote_*`, wiremock footnote body-capture; holdout H-NEW-ADF-FOOTNOTE | `src/adf.rs::push_footnote_marker`; `src/adf.rs::finish` (footnote flush); `src/adf.rs::is_empty_block_container`; `src/adf.rs::tests` (footnote unit tests) |
| 2 | Markdown minor: subsup (`^x^`/`~x~`) + heading attrs (`## T {#id}`) — THESE ALREADY HAVE BC-7.2.007 (subsup) and BC-7.2.008 (heading-attrs). See note below. | #474 | **NO ACTION** (BC-7.2.007 + BC-7.2.008 already exist and are individually-bodied) | — | — | existing BCs | — |
| 3 | GFM alerts → ADF `panel` — ALREADY HAS BC-7.2.009 (individually-bodied). See note below. | #483 | **NO ACTION** (BC-7.2.009 already exists and is individually-bodied) | — | — | — | — |
| 4 | Block-HTML → literal text + `hardBreak` interior newlines — ALREADY HAS BC-7.2.011 (individually-bodied, extensively revised through v1.11.0). See note below. | #489/#492 | **NO ACTION** (BC-7.2.011 already exists and is individually-bodied) | — | — | — | — |
| 5 | INV-1 CR/LF normalization (`push_text` context-aware dispatch; `push_code` defense-in-depth) — ALREADY COVERED as EC-11 inside BC-7.2.011. See note below. | #522 | **NO ACTION** (EC-11 inside BC-7.2.011 covers this; it is a testable edge case within an existing BC, not a gap) | — | — | — | — |
| 6 | Bare-URL autolink → ADF `link` mark: `http(s)://`-only scope; `autolink_bare_urls` post-`finish()` pass; `find_bare_url_spans`/`trim_url_extent`; boundary rules; code/existing-link exclusion; `www.`-prefix and emails OUT of scope | #473 | **NEW BC-7.2.014** | BC-7.2.014 | bc-7-output-render.md | `test_e2e_markdown_bare_url_produces_link_mark` (live, existing); wiremock body-capture; holdout H-NEW-ADF-BARE-URL | `src/adf.rs::autolink_bare_urls`; `src/adf.rs::find_bare_url_spans`; `src/adf.rs::trim_url_extent`; `src/adf.rs::split_text_node_on_urls`; `src/adf.rs::tests` (bare-url unit tests) |
| 7 | Cache warm-hit no-HTTP: second invocation within TTL fires zero HTTP to the backing endpoint (D2 dimension). Covers request-type (#8,#9), workspace (#3), Jira fields (#6) families at minimum. | cache-coverage-audit | **NEW BC-6.2.018** | BC-6.2.018 | bc-6-config-cache.md | `test_requesttype_list_cache_hit_no_second_http`, `test_requesttype_fields_cache_hit_no_second_http`, `test_bc_3_4_015_warm_fields_cache_skips_field_list_http`; holdout H-037 (workspace); wiremock `expect(1)` tests | `src/cache.rs::read_cache`; `src/cache.rs::read_request_type_cache`; `src/cache.rs::read_workspace_cache`; `src/cache.rs::read_fields_cache`; wiremock integration tests (`tests/requesttype_commands.rs`, `tests/*.rs`) |
| 8 | Read-command error output channel: `--output json` error paths (4xx/5xx) emit to stderr, NOT stdout; stdout is empty on error; `render_json` / `print_output` is the ONLY permitted JSON serialization path (#526 invariant) | #526 | **NEW BC-7.3.010** | BC-7.3.010 | bc-7-output-render.md | wiremock 4xx injection per read command; holdout H-NEW-ERR-CHANNEL; offline CLI: `test_e2e_issue_view_404_exits_nonzero`, `test_e2e_issue_list_bad_jql_exits_nonzero` (existing) | `src/main.rs::main` (error rendering, error JSON envelope to stderr); `src/output.rs::render_json`; `src/output.rs::print_output`; `src/cli/**/*.rs` (all read handlers); `tests/issue_commands.rs`; `tests/issue_view_errors.rs` |
| 9 | `partial_match` short-circuits BEFORE any network call on ambiguous input: exits 64 with disambiguation hint, zero HTTP requests issued | `src/partial_match.rs` | **EXTEND BC-X.10.001** (add EC clause; no new heading) | — (edge case in BC-X.10.001) | cross-cutting.md | wiremock `expect(0)` test with ambiguous input; `tests/queue.rs::resolve_queue_single_substring_is_ambiguous` (existing, offline) | `src/partial_match.rs`; `src/cli/queue.rs::resolve_queue_by_name`; `src/cli/issue/workflow.rs` (move-status resolution); `tests/queue.rs`; `tests/requesttype_commands.rs` |

---

## 2. Decision Rationale per Behavior

### (1) Footnotes #472 → NEW BC-7.2.013

Footnotes are a genuinely distinct markdown→ADF mapping: a named extension path
(`ENABLE_FOOTNOTES`), a unique bypass of `push_text` / `dedup_marks` via
`push_footnote_marker`, a document-end flush into a `rule` + paragraph section, and
a distinct empty-container pruning obligation. None of the existing BCs (BC-7.2.001
through BC-7.2.012) describe this flow. The e2e-edge-case-audit-2026-06-27-write.md
flags this as HIGH (G-ADF-FOOTNOTE) and explicitly states "holdout requires authoring
a new BC first."

BC-7.2.013 is the next free ID in the BC-7.2 sequence (BC-7.2.012 = recursion depth,
the last individually-bodied one). The range-collapsed block BC-7.2.013..057 currently
absorbs these numbers — authoring BC-7.2.013 as an individually-bodied section moves
one BC from the range-collapsed pool into an individually-bodied section, so the
TOTAL_BCS does not change for this specific item. HOWEVER, since the range-collapsed
block starts at 013, adding an individually-bodied BC-7.2.013 requires renaming the
range to BC-7.2.014..057. This is a BC INDEX housekeeping update, NOT a count change.

**CRITICAL CLARIFICATION:** Re-reading BC-INDEX.md: the `BC-7.2.013..057` row is
labelled `[range-collapsed]` and references "Additional ADF contracts (range-collapsed
from bc-7 body)". This means BC-7.2.013..057 already EXIST in the cumulative count
(they ARE counted in the 603 total). Authoring BC-7.2.013 as an individually-bodied
heading promotes one ID from range-collapsed to individually-bodied status — this
increments `definitional_count` by 1 but does NOT increment `total_bcs` because the
ID was already claimed. The range annotation in BC-INDEX changes from `013..057`
to `014..057` (still 44 range-collapsed IDs, same count).

**Count impact: definitional_count +1 in bc-7-output-render.md. total_bcs unchanged.**

### (2) Subsup + heading-attrs #474 → NO ACTION

BC-7.2.007 and BC-7.2.008 were added on 2026-06-08 and are individually-bodied in
bc-7-output-render.md. The drift item listed "#474" as needing a contract but these
already exist. Confirmed by reading the `#### BC-7.2.007` and `#### BC-7.2.008`
headings in bc-7-output-render.md.

### (3) GFM alerts #483 → NO ACTION

BC-7.2.009 was added on 2026-06-09 and is individually-bodied. Confirmed.

### (4) Block-HTML #489 → NO ACTION

BC-7.2.011 was added on 2026-06-15 and has been through 11 revision passes
(v1.0.0 through v1.11.0). It is extensively individually-bodied and covers
the block-HTML→literal+hardBreak contract in full. Confirmed.

### (5) INV-1 CR/LF normalization #522 → NO ACTION

EC-11 inside BC-7.2.011 covers the `push_text` context-aware CR/LF normalization
contract (including the bare-`\n` F5-R2 fix). EC-12 inside BC-7.2.011 covers
`text_to_adf`. Both are testable Edge Cases within the existing BC, not gaps. The
CLAUDE.md Gotcha for #522 cross-references BC-7.2.011 directly. No new BC needed.

### (6) Bare-URL autolink #473 → NEW BC-7.2.014

The bare-URL autolink behavior is a distinct post-`finish()` tree-walking pass
(`autolink_bare_urls`) with its own scope rules (http(s):// explicit-scheme only;
boundary conditions; exclusions for code/existing-link nodes; `www.`/email explicitly
out of scope). It is NOT described by any of BC-7.2.001..012. The e2e test
`test_e2e_markdown_bare_url_produces_link_mark` exists (live, covered) but the BC
anchor for wiremock body-capture of the submitted `href` mark is missing.

BC-7.2.014 is the next free individually-bodied ID after BC-7.2.013 (planned above).
It also falls within the existing range-collapsed block (013..057), so the same
analysis applies: this promotes one more ID to individually-bodied status.

**Count impact: definitional_count +1 in bc-7-output-render.md. total_bcs unchanged.**

### (7) Cache warm-hit no-HTTP → NEW BC-6.2.018

The D2 "warm HIT → no HTTP" dimension is the ONLY dimension that requires a wiremock
`expect(N)` assertion — it is invisible from output alone. Three existing wiremock
integration tests already pin this for specific families (request-types #8, #9 and
Jira fields #6) but there is no BC body formally stating this as an invariant. The
cache-coverage-audit-2026-06-27.md P4/P5/P8 proposals all cite "flag as MED — BC may
need a caching sub-clause." BC-6.2.017 is the last individually-bodied BC in bc-6.

**Count impact: definitional_count +1, total_bcs +1 in bc-6-config-cache.md.**
**Global total: 603 → 604.**

### (8) Read-command error output channel #526 → NEW BC-7.3.010

BC-7.3.005 covers the specific case of "empty 4xx body → `{error: '<empty response
body>', code: N}` to STDERR." But BC-7.3.005 does NOT state the general invariant:
that ALL `--output json` error paths route to stderr and NEVER to stdout, and that
`render_json`/`print_output` is the only permitted JSON serialization path (#526).
The e2e-edge-case-audit-2026-06-27-read.md flags G-H1 (HIGH) specifically noting the
absent BC anchor for the error-channel contract across the full read-command surface.

BC-7.3.009 is the last individually-bodied BC in the BC-7.3 section. BC-7.3.010 is
next. This is a genuinely distinct testable contract (which stdout channel carries the
error under --output json) that warrants its own ID because:
- It applies cross-cutting to all read commands
- The holdout/wiremock tests cite different source fns than BC-7.3.005
- It covers a file-wide coding invariant, not just one specific error shape

**Count impact: definitional_count +1, total_bcs +1 in bc-7-output-render.md.**
**Global total: 604 → 605.**

### (9) `partial_match` no-network short-circuit → EXTEND BC-X.10.001

BC-X.10.001 already states "`partial_match` with single-substring → `Ambiguous` (NOT
Exact); never auto-resolves." The missing property is the implied pre-network
short-circuit: the implementation exits 64 with the disambiguation message BEFORE any
HTTP call is issued. This is an Edge Case of BC-X.10.001's contract, not a standalone
BC. Adding EC-1 to BC-X.10.001's body (or extending the Behavior clause) provides the
anchor for wiremock `expect(0)` tests without creating a new BC heading.

This is confirmed as an EXTEND (not NEW) because:
- The network-avoidance is a consequence of `partial_match` being a pure function
  called before any API calls in every resolver
- The callers (queue resolver, move-status resolver, requesttype resolver) already
  have per-command BCs (BC-X.8.009, BC-X.10.001, BC-X.12.006) that reference this
- A separate BC would duplicate the contract surface without adding testable behavior

**Count impact: zero (in-body EC clause only).**

---

## 3. BC-7.2.013..057 Range Housekeeping

The range-collapsed block `BC-7.2.013..057` (45 IDs) currently sits in BC-INDEX as
a single row. Promoting BC-7.2.013 and BC-7.2.014 to individually-bodied sections
requires:

1. Updating the range annotation in BC-INDEX from `BC-7.2.013..057` to `BC-7.2.015..057`
2. The row count stays the same (range shrinks by 2 IDs, but those 2 now have their
   own rows above the collapsed row)
3. The section header `### 7.2 ADF Rendering (12 individually-bodied BCs: BC-7.2.001..012;`
   changes to `14 individually-bodied BCs: BC-7.2.001..014;`
4. No total_bcs change (both IDs were already counted in the 603)

---

## 4. Count-Impact Summary

### New `#### BC-` headings (definitional_count changes)

| File | Current `definitional_count` | Delta | New `definitional_count` |
|------|------------------------------|-------|--------------------------|
| bc-7-output-render.md | 45 | +4 (BC-7.2.013, BC-7.2.014, BC-7.3.010 + see note) | 48 |
| bc-6-config-cache.md | 32 | +1 (BC-6.2.018) | 33 |
| cross-cutting.md | 79 | 0 (EXTEND only) | 79 |

Note on bc-7: BC-7.2.013 and BC-7.2.014 promote from range-collapsed (already
counted in total_bcs) to individually-bodied (increases definitional_count). BC-7.3.010
is a brand-new ID (increases both definitional_count and total_bcs).

### New total_bcs (count-bearing changes — genuinely new BC IDs)

| Behavior | New BC ID | total_bcs delta |
|----------|-----------|-----------------|
| (1) Footnotes #472 | BC-7.2.013 | 0 (already in range-collapsed) |
| (6) Bare-URL #473 | BC-7.2.014 | 0 (already in range-collapsed) |
| (7) Cache warm-hit no-HTTP | BC-6.2.018 | +1 |
| (8) Read error-channel #526 | BC-7.3.010 | +1 |
| (9) partial_match no-network | EXTEND BC-X.10.001 | 0 |

**Net total_bcs change: 603 → 605** (+2 genuinely new IDs: BC-6.2.018, BC-7.3.010).

### Surfaces that must be updated after authoring

For each NEW BC ID that increments total_bcs (BC-6.2.018, BC-7.3.010):

| Surface | File | What to update |
|---------|------|----------------|
| A: per-file frontmatter `total_bcs` | bc-6-config-cache.md, bc-7-output-render.md | +1 each |
| B: BC-INDEX section header | BC-INDEX.md §6.2 header, §7.3 header | update "(N BCs)" count |
| C: BC-INDEX section-lines count | BC-INDEX.md §6.2 table row count, §7.3 table row count | +1 row each |
| D: CANONICAL-COUNTS per-file table | CANONICAL-COUNTS.md | update bc-6 and bc-7 rows |
| E: BC-INDEX frontmatter `total_bcs` | BC-INDEX.md | 603 → 605 |
| F: CANONICAL-COUNTS Sum row | CANONICAL-COUNTS.md | 603 → 605 |
| G: CANONICAL-COUNTS grand-total prose | CANONICAL-COUNTS.md | update prose + append "+2" items |

For definitional_count-only changes (BC-7.2.013, BC-7.2.014):

| Surface | File | What to update |
|---------|------|----------------|
| per-file frontmatter `definitional_count` | bc-7-output-render.md | 45 → 47 (for both) |
| CANONICAL-COUNTS definitional counts table | CANONICAL-COUNTS.md | bc-7 row: 45 → 47 |
| BC-INDEX section header | BC-INDEX.md §7.2 | "(12 individually-bodied BCs: BC-7.2.001..012;" → "(14 individually-bodied BCs: BC-7.2.001..014;" |
| BC-INDEX range-collapsed row | BC-INDEX.md | `BC-7.2.013..057` → `BC-7.2.015..057` |

After ALL changes, run:
```bash
scripts/check-bc-cumulative-counts.sh   # must exit 0
scripts/check-spec-counts.sh            # must exit 0
scripts/check-bc-no-numeric-test-counts.sh  # must exit 0
```

---

## 5. Recommended Authoring Burst Split

The 8-artifact rule (no more than ~8 file writes per burst to protect quality and
stay within context limits) suggests splitting into 2 bursts.

### Burst 1 — ADF wave BCs (bc-7, BC-INDEX housekeeping)

Artifacts to write/edit:
1. bc-7-output-render.md — add `#### BC-7.2.013` (footnotes #472) body
2. bc-7-output-render.md — add `#### BC-7.2.014` (bare-URL #473) body
3. BC-INDEX.md — update §7.2 section header + range-collapsed row (013..057 → 015..057) + add BC-7.2.013 and BC-7.2.014 rows
4. CANONICAL-COUNTS.md — update definitional_count for bc-7-output-render.md (45 → 47)
5. bc-7-output-render.md frontmatter — update `definitional_count: 45 → 47`

Count impact: definitional_count changes only; no total_bcs change in this burst.
Run check-bc-cumulative-counts.sh after this burst.

### Burst 2 — Cache BC, error-channel BC, partial_match EC

Artifacts to write/edit:
1. bc-6-config-cache.md — add `#### BC-6.2.018` (warm-hit no-HTTP) body
2. bc-7-output-render.md — add `#### BC-7.3.010` (read error-channel #526) body
3. cross-cutting.md — extend BC-X.10.001 with EC-1 (no-network short-circuit)
4. BC-INDEX.md — add BC-6.2.018 row (§6.2), add BC-7.3.010 row (§7.3), update section headers, update frontmatter total_bcs (603 → 605)
5. bc-6-config-cache.md frontmatter — update `definitional_count: 32 → 33`, `total_bcs: 42 → 43`
6. bc-7-output-render.md frontmatter — update `definitional_count: 47 → 48` (from burst 1), `total_bcs: 91 → 92`
7. CANONICAL-COUNTS.md — update bc-6 row (42→43), bc-7 row (91→92), Sum (603→605), grand-total prose, last_verified
8. BC-INDEX.md §7.3 section header update + frontmatter total_bcs

Count impact: +2 to total_bcs (603 → 605). Run both check scripts after this burst.

---

## 6. Items Confirmed NOT Needing a New BC

These were listed in the drift item but already have adequate coverage:

| Behavior | Confirmed status |
|----------|-----------------|
| #474 subsup + heading-attrs | BC-7.2.007 + BC-7.2.008 (individually-bodied, 2026-06-08) |
| #483 GFM alerts → panel | BC-7.2.009 (individually-bodied, 2026-06-09) |
| #489/#492 block-HTML hardBreak | BC-7.2.011 (individually-bodied, 2026-06-15, v1.11.0) |
| #522 INV-1 CR/LF normalization | EC-11 inside BC-7.2.011 (v1.9.8 + v1.11.0) |
| #471 GFM task lists | BC-7.2.010 (individually-bodied, 2026-06-10) — NOT in the MISSING list but confirming no gap |

---

## 7. Uncertainty Flags for Orchestrator/Human Decision

### UNSURE-1: BC-7.2.013..057 range interpretation

The plan above assumes BC-7.2.013 and BC-7.2.014 already exist in the cumulative
count (they are part of the `BC-7.2.013..057` range-collapsed block). If the
range-collapsed block was NOT counted in the cumulative 603 for these specific IDs,
then promoting them to individually-bodied WOULD increment total_bcs. A human or
orchestrator should verify this by checking whether the bc-7 `total_bcs: 91` figure
already includes the full 013..057 range (45 IDs) or just the 12 individually-bodied
ones. If it includes only the 12, the range-collapsed IDs are NOT in the total and
promoting any of them adds to the count.

**Guidance:** The CANONICAL-COUNTS.md shows `bc-7-output-render.md: total_bcs = 91`
and `definitional_count = 45`. The difference is 46, which matches the range
BC-7.2.013..057 (45 IDs) plus a small remainder. This confirms the range-collapsed
block IS included in the total_bcs cumulative claim, and promoting BC-7.2.013 /
BC-7.2.014 does NOT add to the total. The plan is consistent.

**Decision needed:** Nonetheless, the orchestrator should confirm before executing
burst 1 that the intent is to promote these IDs from range-collapsed to individually-
bodied rather than treat them as brand-new additions.

### UNSURE-2: BC-7.3.010 vs EXTEND BC-7.3.005

The read-error-channel contract could alternatively be expressed as a new Edge Case
(EC-NNN) added to BC-7.3.005's body. The reason for recommending NEW (BC-7.3.010) is:
- BC-7.3.005 is specifically about "empty 4xx body" only
- The general cross-read-command invariant is logically broader than BC-7.3.005
- Holdout tests for multiple read commands will benefit from a first-class anchor

If the orchestrator prefers to minimize count churn, the alternative is to add an
EC to BC-7.3.005 instead (zero count impact). The trade-off: less anchor visibility,
slightly weaker test naming (test would cite BC-7.3.005 not a specific 010 ID).

### UNSURE-3: BC-6.2.018 scope (which cache families does it cover?)

The warm-hit no-HTTP contract is already partially pinned by individual tests:
- Family 8 (request-types): `test_requesttype_list_cache_hit_no_second_http`
- Family 9 (RT-fields): `test_requesttype_fields_cache_hit_no_second_http`
- Family 6 (Jira fields): `test_bc_3_4_015_warm_fields_cache_skips_field_list_http`
- Family 3 (workspace): H-037

Should BC-6.2.018 be a single "all families" contract or a per-family contract? The
recommendation is a single "invariant" contract (one BC) that states the generic
warm-hit property with a cross-reference table to family-specific existing tests.
This avoids creating 9 near-identical BCs. The orchestrator may choose to split it.

---

## 8. Final Count Summary

| Metric | Before | After |
|--------|--------|-------|
| Global total_bcs | 603 | 605 |
| New individually-bodied BCs (definitional_count) | — | +4 (BC-7.2.013, BC-7.2.014, BC-7.3.010, BC-6.2.018) |
| bc-7-output-render.md total_bcs | 91 | 92 |
| bc-7-output-render.md definitional_count | 45 | 48 |
| bc-6-config-cache.md total_bcs | 42 | 43 |
| bc-6-config-cache.md definitional_count | 32 | 33 |
| cross-cutting.md total_bcs | 145 | 145 |
| cross-cutting.md definitional_count | 79 | 79 |
| New BC IDs that increment total_bcs | 0 | 2 (BC-6.2.018, BC-7.3.010) |
| BC IDs promoted range-collapsed → individually-bodied | 0 | 2 (BC-7.2.013, BC-7.2.014) |
| In-body EC additions (no count change) | 0 | 1 (EC to BC-X.10.001) |

Holdout anchors unblocked by this plan: G-ADF-FOOTNOTE (HIGH), G-ADF-BARE-URL (wiremock),
G-H1 read-error-channel (HIGH), G-H2 partial_match no-HTTP (HIGH), cache D2 warm-hit
wiremock tests (MEDIUM). All five were flagged as blocked on missing BC sub-clauses.
