---
document_type: f2-prd-delta
phase: phase-f2-spec-evolution
issue: 674
cycle: cycle-005
producer: product-owner
timestamp: 2026-09-06
status: complete
sub_burst: create
inputs:
  - .factory/phase-f1-delta-analysis/cycle-005/delta-analysis.md
  - .factory/phase-f1-delta-analysis/cycle-005/artifact-mapping.md
input-hash: "d432a7f"
---

# F2 PRD Delta — Issue #674 ("adf-mentions", cycle-005)

Markdown `@mention`/`[~accountid:...]` → ADF `mention` node. This document is the
CREATE sub-burst output: new/modified behavioral-contract BODIES only. Index files
(BC-INDEX.md, CANONICAL-COUNTS.md), count reconciliation, and holdout scenarios are
explicitly OUT OF SCOPE for this sub-burst — they are a separate, later INTEGRATE pass
per the >8-artifact context-overflow split the orchestrator specified.

---

## Summary

**12 new BCs authored** (F1's `artifact-mapping.md` reserved a range of 9-10 depending
on which of its two proposals was adopted; this burst lands at 12 because it adopts the
"Alternative decomposition" 3-way `@Name` split — BC-X.7.007/008/009, 3 ids instead of
1 — AND additionally mints BC-X.7.010 for the accountId preflight-validation decision
(task item 2), which neither F1 run had explicitly placed as its own BC id — see
"Next-Available BC ID Verification" and "Under-Specified Areas" below for the full
reconciliation):

- BC-7.2.016, BC-7.2.017, BC-7.2.018, BC-7.2.019 (`.factory/specs/prd/bc-7-output-render.md`, §7.2 ADF Rendering)
- BC-X.7.007, BC-X.7.008, BC-X.7.009, BC-X.7.010 (`.factory/specs/prd/cross-cutting.md`, §X.7 Users)
- BC-3.3.012 (`.factory/specs/prd/bc-3-issue-write.md`, §3.3 Create)
- BC-3.4.032 (§3.4 Edit and Open)
- BC-3.5.013 (§3.5 Comments)
- BC-3.8.018 (§3.8 JSM Request Create)

**7 existing BCs amended** (in place, `[UPDATED 2026-09-06 issue #674]` tag, previous
text preserved inline per append-only/H1-authority policy) — **corrected, cycle-005 F2
pass-2 adversarial review M-2: this was previously miscounted as "6 existing BCs
amended," undercounting BC-7.2.004 itself against the 6 annotation-only cross-reference
BCs listed below it; the correct figure is 1 (BC-7.2.004) + 6 (annotation-only) = 7**:

- BC-7.2.004 (H1 + Behavior rewritten to remove `mention` from the silently-dropped
  enumeration; version-history table added — **corrected, cycle-005 F2 pass-4 review:
  this was previously described as "1.0.0/2.0.0 rows" (2 rows); the table actually has
  THREE rows — 1.0.0 (initial), 2.0.0 (the #674 `mention`-removal update), and 2.0.1
  (the pass-2 adversarial-review H-1 double-`@` render-defect fix)**)
- BC-3.3.008, BC-3.4.003, BC-3.4.004, BC-3.5.001, BC-3.5.009, BC-3.8.006 (each gains a
  short `> **[UPDATED …]**` blockquote cross-reference to the new wiring BC — no
  wire-shape change to any of these six)

No BC ids were renumbered or reused. No BC was retired.

---

## Next-Available BC ID Verification (grep-confirmed, not assumed from F1's proposal)

| Family | Last existing (grep, pre-burst) | F1-proposed next | Confirmed/assigned |
|---|---|---|---|
| BC-7.2.* | BC-7.2.015 (BC-7.2.012 appears out of numeric order later in the file — historical insertion-order artifact, not a gap) | BC-7.2.016 | BC-7.2.016, 017, 018, 019 ✓ matches proposal |
| BC-X.7.* | BC-X.7.006 | BC-X.7.007 | BC-X.7.007, 008, 009, 010 — **4 ids, not the F1 "1 shared-resolver BC" proposal**; adopted the "Alternative decomposition" 3-way split (BC-X.7.007/008/009) PLUS a 4th (BC-X.7.010) for the bracket-form accountId preflight-validation, which neither F1 run had placed in this family explicitly (see "Under-specified areas" below) |
| BC-3.3.* | BC-3.3.011 | BC-3.3.012 | BC-3.3.012 ✓ |
| BC-3.4.* | BC-3.4.031 | BC-3.4.032 | BC-3.4.032 ✓ |
| BC-3.5.* | BC-3.5.012 | BC-3.5.013 | BC-3.5.013 ✓ |
| BC-3.8.* | BC-3.8.017 | BC-3.8.018 | BC-3.8.018 ✓ |

No collisions. No id from `artifact-mapping.md`'s reserved range was skipped or reused
for a different purpose, except that BC-7.2.019 was reassigned in scope: F1's PRIMARY
proposal used BC-7.2.019 for "documents jr performs NO client-side accountId
validation" (a stance the human-approved Design Decision 2 — mandatory preflight
validation — supersedes and makes moot), while F1's "Alternative decomposition"
proposed BC-7.2.019 for the reverse-path #202 close. **This burst adopts the
Alternative decomposition's BC-7.2.019 (reverse-path close)**, per the orchestrator
task prompt's explicit instruction to follow the 3-way `@Name` split and the
committed reverse-path close.

---

## New BCs — one-line summaries

| BC ID | Title (one line) | Behavior | New/Modified |
|---|---|---|---|
| BC-7.2.016 | Bracket-form `[~accountid:<id>]` → ADF `mention` node, pure zero-HTTP forward conversion | Post-`finish()` tree-walk mirroring `autolink_bare_urls`; introduces `find_mention_candidates`, `markdown_to_adf_with_mentions`, `markdown_to_adf_no_mentions` (new); `markdown_to_adf` becomes a thin wrapper | NEW |
| BC-7.2.017 | `attrs.text` = `"@" + display_name` population for both mention forms | Pure-emitter enrichment from a caller-supplied `MentionResolutions` map; omitted (not placeholder) when no entry exists | NEW |
| BC-7.2.018 | `@Name` pure candidate-detection grammar (boundary rule, charset, single-token scope, `\@` escape) | Reuses `find_bare_url_spans`'s boundary rule; resolves OQ-3 (single-token only); flags `\@`-escape mechanism as F4-verify | NEW |
| BC-7.2.019 | `adf_to_text` renders `mention` → `@<attrs.text>` / `@<attrs.id>` / `@?`, closing #202/NFR-O-I | New `"mention"` match arm before the `_` catch-all; committed close, not deferred | NEW |
| BC-X.7.007 | `@Name` unique-match resolution (happy path) | `search_users` + `disambiguate_user` `Exact` arm, reused verbatim | NEW |
| BC-X.7.008 | `@Name` ambiguous-match disambiguation | `disambiguate_user` `ExactMultiple`/`Ambiguous` arms, reused verbatim; reuses BC-X.7.004's contract shape | NEW |
| BC-X.7.009 | `@Name` zero-match → HARD ERROR exit 64 | `disambiguate_user` `None` arm, reused verbatim; **supersedes architect's pass-through recommendation per human-approved decision** | NEW |
| BC-X.7.010 | Bracket-form accountId preflight-validation, mandatory | `GET /rest/api/3/user?accountId=`, deduped per unique id; unknown id → hard error exit 64; feeds BC-7.2.017's `attrs.text` | NEW |
| BC-3.3.012 | `issue create --description --markdown` mention wiring (platform path) | Resolve-then-convert-then-POST; `--no-mentions` opt-out; zero-POST on failure (mirrors BC-3.3.005) | NEW |
| BC-3.4.032 | `issue edit --description --markdown` mention wiring (dry-run + live) | Same resolve-then-convert pattern at BOTH call sites; preserves the pre-existing dry-run "resolution error before any preview output" ordering invariant | NEW |
| BC-3.5.013 | `comment add`/`comment edit --markdown` mention wiring | `handle_comment_add` gains new `no_input` param; JSM visibility/notification orthogonality documented | NEW |
| BC-3.8.018 | JSM `issue create --request-type --markdown` mention wiring | Resolution happens in async `handle_jsm_create` BEFORE the synchronous `JsmRequestBuilder::build()`; resolves OQ-1 to IN-SCOPE | NEW |

## Modified BCs — one-line summaries

| BC ID | What changed | New/Modified |
|---|---|---|
| BC-7.2.004 | H1 + Behavior narrowed: `mention` removed from the silently-dropped node enumeration (now emoji/inlineCard/media only); cross-references BC-7.2.019 as the implementation; version-history table added | MODIFIED |
| BC-3.3.008 | Blockquote cross-reference to BC-3.3.012 added; no wire-shape change | MODIFIED (annotation only) |
| BC-3.4.003 | Blockquote cross-reference to BC-3.4.032 added; no wire-shape change | MODIFIED (annotation only) |
| BC-3.4.004 | Blockquote cross-reference to BC-3.4.032 added; no wire-shape change | MODIFIED (annotation only) |
| BC-3.5.001 | Blockquote note: mention notification and comment visibility are orthogonal; cross-references BC-3.5.013 | MODIFIED (annotation only) |
| BC-3.5.009 | Blockquote cross-reference to BC-3.5.013 added, clarifying resolution-step ordering relative to EC-3.5.009-5 | MODIFIED (annotation only) |
| BC-3.8.006 | Blockquote cross-reference to BC-3.8.018 added; no wire-shape change | MODIFIED (annotation only) |

---

## Human-Approved Decisions Encoded Verbatim (not re-litigated)

1. **Forward bracket conversion** — BC-7.2.016. Pure, zero-HTTP, mirrors `autolink_bare_urls`.
2. **AccountId preflight-validation, mandatory** — BC-X.7.010. `GET /rest/api/3/user?accountId=`, hard error exit 64 on unknown id.
3. **`attrs.text` population** — BC-7.2.017. `"@" + display_name` for both forms.
4. **`@Name` resolution, 3-way split** — BC-X.7.007 (unique)/BC-X.7.008 (ambiguous)/BC-X.7.009 (zero-match → **HARD ERROR**, per the task prompt's explicit override of the architect's pass-through recommendation).
5. **`\@` escape** — BC-7.2.018 point 6 / EC-7.2.018-8. Contract specified; mechanism flagged for F4 empirical verification (see below).
6. **`--no-mentions` opt-out** — BC-7.2.016 point 7 (new `markdown_to_adf_no_mentions` pure entrypoint) + wired per-command in BC-3.3.012/BC-3.4.032/BC-3.5.013/BC-3.8.018.
7. **Reverse-path amendment** — BC-7.2.004 amended (UPDATED tag, previous version inlined in a version-history table); BC-7.2.019 authored as the committed close of #202/NFR-O-I.
8. **Per-command wiring** — BC-3.5.013 (comment add + comment edit), BC-3.3.012 (platform create), BC-3.4.032 (edit, both call sites), BC-3.8.018 (JSM create). JSM visibility/notification-orthogonality caveat documented in BC-3.5.013 and BC-3.8.018.
9. **E2E acceptance** — folded into each wiring BC's Verification Properties section (not a separate BC), per the task's explicit "or fold into wiring BCs" allowance. Primary scenario (comment add) called out explicitly in BC-3.5.013.

---

## Open Questions Resolved by This Burst

- **OQ-1** (`delta-analysis.md`): does JSM `issue create --request-type` fall inside scope? **Resolved YES** — BC-3.8.018 authored, per the task prompt's explicit item 8.
- **OQ-3** (`delta-analysis.md`): multi-word `@Name` support this cycle? **Resolved NO (option (a), single-token only)** — BC-7.2.018 point 3, per the architect's own recommendation, adopted without change.
- **OQ-4** (`delta-analysis.md`): zero-match `@Name` — pass-through or hard error? **Resolved HARD ERROR** — BC-X.7.009, per the task prompt's explicit item 4(c), **overriding** the architect's pass-through recommendation. This is the one place this burst's encoded decision diverges from `delta-analysis.md`'s own recommendation; BC-X.7.009's body documents the divergence explicitly rather than silently overwriting the architect's reasoning.
- **OQ-2** (`delta-analysis.md`): fold Decisions (a)/(b) into one story or defer to a fast-follow? **Not a BC-authoring question** — left to F3 story decomposition; this burst's BCs specify the FULL mandatory-validation behavior (per task items 2/3), so F3 has no ambiguity about scope when splitting stories.

---

## Under-Specified Areas Flagged for Human Review at the F2 Gate

1. **`--no-mentions` API shape (BC-7.2.016 point 7)**: neither F1 artifact designed an
   opt-out surface for the pure-conversion API. This burst introduces a THIRD pure
   function, `markdown_to_adf_no_mentions`, as the minimal extension to the architect's
   two-function Design Decision #2. An alternative (a `bool` flag on
   `markdown_to_adf_with_mentions`) was considered and rejected in the BC body's own
   reasoning. **Flag: confirm this API shape before F4 implementation.**

2. **`\@` escape mechanism (BC-7.2.018 point 6 / EC-7.2.018-8)**: this is the single
   biggest technical risk surfaced by this burst that F1 did not anticipate at all (the
   `\@`-escape requirement came from the orchestrator's F2 task prompt, not from
   `delta-analysis.md`/`artifact-mapping.md`). CommonMark treats `@` as an escapable
   ASCII punctuation character, and pulldown-cmark's own parser consumes the backslash
   BEFORE `jr`'s post-`finish()` mention tree-walk ever sees the text — `\@Name` and
   `@Name` are byte-identical in the built AST (directly demonstrated by the existing
   `src/adf.rs::test_markdown_escape_literal_asterisk` precedent for `\*`). The BC
   documents a RECOMMENDED mechanism (pulldown-cmark's `into_offset_iter()`
   byte-offset-tracking API, cross-correlating candidate positions against the raw
   source for an unescaped leading backslash) but explicitly flags this as UNPROVEN —
   no prior `adf.rs` feature has used offset-tracking, and the exact mechanics need
   dedicated F4 design and unit tests before the escape postcondition can be
   considered more than aspirational. **Flag: this may need a research/spike pass
   before F4, or an explicit scope-cut decision if the offset-correlation approach
   proves impractical.**

3. **BC-X.7.009's hard-error decision vs. BC-7.2.018's grammar (cross-BC risk, explicitly
   documented in both bodies rather than silently absorbed)**: the human-approved
   zero-match-hard-error decision, combined with the `@Name` grammar's necessarily
   permissive single-token charset, means ordinary prose containing `@Override`
   (Java annotation, outside a code span), `@angular` (npm scoped-package prefix,
   outside a code span), or `@channel`/`@here` (Slack-style tokens) will now HARD-FAIL
   an entire `comment add`/`issue create`/`issue edit` invocation with exit 64 unless a
   Jira user happens to match the token. This is the architect's own explicitly-named
   risk in `delta-analysis.md` §4 (c)/(e) and OQ-4, now realized as a directed decision
   rather than a hypothetical. `--no-mentions` is the documented mitigation. **Flag:
   confirm this UX tradeoff is acceptable, or consider adding this risk to onboarding/
   help-text/CHANGELOG copy at F4/F6 so users discover `--no-mentions` before hitting
   the failure mode in production.**

4. **JsmRequestBuilder threading shape (BC-3.8.018)**: `JsmRequestBuilder::build()` is
   synchronous and effect-free by design; this burst's BC specifies that resolution must
   happen in the async `handle_jsm_create` caller and be threaded into the builder as
   already-resolved data, but leaves the EXACT field shape (`mention_resolutions: &MentionResolutions`
   vs. a pre-converted `description_adf: Option<Value>` replacing the raw
   `description`/`markdown` pair) as an F4 implementation choice. Both satisfy the BC's
   observable contract; F4/architect should pick one and update the BC's Trace/Source
   fields to the concrete symbol name once implemented.

5. **VP id assignment**: this burst cites `VP-674-001..011` (per `artifact-mapping.md`'s
   own proposed/alternative numbering) plus SEVERAL new VPs this burst's BCs needed that
   neither F1 run enumerated (the `\@`-escape regression pin, the accountId-dedup pin,
   and the three per-wiring-BC E2E acceptance VPs) — these are cited with placeholder
   ids (e.g. `VP-674-012` through `VP-674-017`) and an explicit "F3/F4-assigned id" note
   in each BC body, since final VP numbering in this repo is inline-subsection-owned
   (per `artifact-mapping.md` §4's own caveat about this repo's VP id convention) and
   this burst does not own VP-INDEX bookkeeping. **Flag for architect**: per this
   agent's "VP Citation Change Handoff" policy, VP citations were ADDED (not just
   changed) in BC-7.2.016/017/018/019, BC-X.7.007/008/009/010, and all four wiring BCs
   — architect should propagate final VP numbering to VP-INDEX/verification-architecture
   docs once F3/F4 assigns concrete ids.

---

## Stories Affected by BC Changes (for story-writer, per bc_array_changes_propagate_to_body_and_acs)

No existing stories reference these BC ids yet — this is a CREATE burst, not a
re-anchor. **Count reconciliation (corrected, pass-1 adversarial review MED-4; further
corrected, cycle-005 F2 pass-2 adversarial review M-2):** of the 19 BC ids this burst
touches, 12 are net-new (BC-7.2.016/017/018/019, BC-X.7.007/008/009/010,
BC-3.3.012, BC-3.4.032, BC-3.5.013, BC-3.8.018) and 7 are EXISTING BCs amended in place
(BC-7.2.004 plus the 6 annotation-only cross-reference BCs — BC-3.3.008, BC-3.4.003,
BC-3.4.004, BC-3.5.001, BC-3.5.009, BC-3.8.006 — per the Summary section above) — "12 new
+ 7 amended = 19 touched," not "all net-new" and not the earlier, undercounted "12 new +
1 amended = 13 touched." F3 (incremental story decomposition) will create new
S-674-* stories referencing the 12 net-new BC ids directly; the 7 amended BCs, being
amendments to existing BCs, may already be referenced by existing stories' `bcs:`
frontmatter arrays (mention-unrelated wiring), which are unaffected by these amendments'
narrow scope (BC-7.2.004: removing `mention` from the silently-dropped enumeration; the
other 6: annotation-only cross-reference blockquotes, no wire-shape change) — no existing
story's `bcs:` array needs updating as a RESULT of this burst's changes.

---

## Anchor-Back Note

Per the Anchor-Back Rule, this burst's new BCs are freshly created — there are no
EXISTING stories whose BC tables need updating in this same burst (see "Stories
Affected" above). BC-INDEX.md new-entry rows and CANONICAL-COUNTS.md count updates
are explicitly deferred to the INTEGRATE pass per the orchestrator's task instruction;
they are NOT anchor-back omissions.

---

## Path Deviation Note

The orchestrator's task instruction named the output path as
`.factory/phase-f2-spec-evolution/prd-delta.md`. That exact filename already exists in
this directory and holds unrelated, historical content for issue #288 (JSM request-type
support, 2026-05-18) — overwriting it would destroy that record. This document is
instead written to `.factory/phase-f2-spec-evolution/prd-delta-674.md`, following the
repo's own established per-issue naming convention (`prd-delta-<issue>.md`, e.g.
`prd-delta-571.md`, `prd-delta-576.md`, `prd-delta-field-dx.md`).
