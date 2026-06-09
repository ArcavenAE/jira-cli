# Phase F5 — Adversarial Convergence Record: issue #474 (ADF minor constructs)

- **Feature:** `feat(adf): markdown subsup (^x^/~x~ → ADF subsup mark) + heading-attribute stripping`
- **BCs authored:** BC-7.2.007 (subsup mark round-trip) + BC-7.2.008 (heading-attribute stripping)
- **Branch:** `feat/adf-minor-constructs-474`
- **Review model:** HYBRID — Claude `adversary` agent (Passes 1–8, fresh context each) + cross-model Gemini pass (via `agy` Antigravity CLI, after gemini-cli was replaced)
- **Convergence achieved:** 3 consecutive CLEAN passes (Passes 6 / 7 / 8)
- **Date:** 2026-06-09

---

## Pass Trajectory

| Pass | Lens | Findings | Severity | Status | Fix notes |
|------|------|----------|----------|--------|-----------|
| P1 | Claude adversary — full delta | 3 MAJOR + 1 false-positive | 3M/1FP | NOT-CLEAN → REMEDIATED | See below |
| P2 | Claude adversary — post-P1-fixes | 1 MEDIUM + 2 LOW | 1M/2L | NOT-CLEAN → REMEDIATED | See below |
| P3 | Claude adversary — post-P2-fixes | count-drift (CANONICAL-COUNTS §7.2) | 1 blocker | NOT-CLEAN → REMEDIATED | See below |
| P4 | Claude adversary — post-P3-fixes | 5 LOW stale-narration; 1 N-1 deferred | 5L (fixed) + 1 deferred | CLEAN-for-blocking | N-1 DRIFT-README pre-existing |
| P5 | Claude adversary — post-P4 | 1 LOW (story EC-004 wrong mechanism) | 1L | NOT-CLEAN → REMEDIATED | See below |
| P6 | Claude adversary — fresh-context | 0 + mark-leak VERIFIED-NO-LEAK | 0 | **CLEAN** (streak start) | — |
| Cross-model | Gemini via `agy` — diff-only review | 1 CRITICAL (false-positive) + 1 LOW | 1FP/1L | CRITICAL REFUTED; LOW FIXED | See below |
| P7 | Claude adversary — fresh-context | 0 | 0 | **CLEAN** | — |
| P8 | Claude adversary — fresh-context | 0 + mark-leak re-derived NO-LEAK | 0 | **CLEAN** | — |

**Converged at Pass 8 (3 consecutive clean: P6/P7/P8).**

---

## Pass 1 — Claude Adversary (Full Delta)

**Verdict: NOT-CLEAN**

**Finding 1 — MAJOR: BC-7.2.007 dedup-survivor label wrong ("sub" vs "sup")**
The BC body's dedup-survivor example showed `sub` as the surviving mark when the semantic intent
is `sup` (superscript wins when two subsup marks of different types coexist). The BC text was
internally inconsistent with the `dedup_marks_by_type` invariant.
_Fixed: corrected survivor label in BC-7.2.007._

**Finding 2 — MAJOR: Non-existent symbol citations across BC + story + delta**
Multiple locations cited `push_text_node` / `append_code_inline_node` — function names that do
not exist in `src/adf.rs`. The correct internal names are `push_text` / `push_code`. The
misattribution appeared in BC bodies, the story ACs, and the F1 delta-analysis doc.
_Fixed: replaced all non-existent citations with correct symbol-form references._

**Finding 3 — MAJOR: Dedup test unfalsifiable**
The `test_markdown_subsup_dedup_does_not_produce_two_subsup_marks` test name and assertion
correctly described the invariant, but the test body constructed a text node already having
only one subsup mark — meaning it would pass even if `dedup_marks_by_type` were deleted
entirely (no mutation kill potential).
_Fixed: rewrote the test to exercise a scenario where `dedup_marks_by_type` is actually
called with two same-type marks and must deduplicate, producing a genuine Red Gate._

**Finding 4 — FALSE-POSITIVE: Heading-brace EC-2 claim**
Adversary claimed that the heading-attribute stripping should produce a different EC-2 exit
behavior. Investigation showed the existing EC-2 was correctly scoped to heading-attribute
stripping leaving no trailing brace in the ADF text content. Claim was unfalsifiable given
pulldown-cmark's upstream parsing behavior.
_No fix; finding rejected._

---

## Pass 2 — Claude Adversary (Post-P1 Fixes)

**Verdict: NOT-CLEAN**

**Finding 1 — MEDIUM: Dangling VP anchors in story**
The story `verification_properties` field referenced `VER-474-001` / `VER-474-002` but no
VP catalog file exists for #474, and the VSDD convention for spec-only features is to leave
this field as `[]` unless VPs are formally defined in a companion spec.
_Fixed: set `verification_properties: []` in the story frontmatter._

**Finding 2 — LOW: BC-INDEX round-trip overclaim**
BC-7.2.007 Source row cited a round-trip test that would only verify the `adf_to_text`
→ display path, not the full markdown→ADF→text round-trip. The claim was inflated.
_Fixed: narrowed Source row to describe coverage accurately._

**Finding 3 — LOW: EC-4 inaccurate mechanism description**
EC-4 in the story described the heading-attribute mechanism as "ENABLE_HEADING_ATTRIBUTES
flag parses then discards attributes" but the accurate description is that pulldown-cmark
parses and exposes them as events that the ADF mapper ignores (never emitting to ADF output).
_Fixed: corrected EC-4 mechanism prose._

---

## Pass 3 — Claude Adversary (Post-P2 Fixes)

**Verdict: NOT-CLEAN**

**Finding — Count drift: CANONICAL-COUNTS 590→592 prose + §7.2 range row 052→054**
Two surfaces were out of sync after BC-7.2.007 and BC-7.2.008 were added (BC grand total
moves 590 → 592; §7.2 range shifts from 052 to 054):
1. `CANONICAL-COUNTS.md` prose/Sum row still showed 590.
2. `BC-INDEX.md` §7.2 collapsed range row still showed `…052`.
_Fixed: updated all 8 count surfaces (per-file frontmatter, BC-INDEX.md Section headers,
BC-INDEX.md sections: lines, CANONICAL-COUNTS.md per-file table, body preamble prose,
BC-INDEX.md frontmatter total_bcs, CANONICAL-COUNTS.md Sum row, grand-total prose).
All 8 surfaces reconciled at 592, §7.2 = 54._

---

## Pass 4 — Claude Adversary (Post-P3 Fixes)

**Verdict: CLEAN-for-blocking (5 LOW stale-narration fixed; N-1 deferred)**

5 LOW findings were stale-narration items (test-count references in story ACs and BC Source
rows that were written before test names were finalized). All fixed in one sweep.

**N-1 (deferred):** `DRIFT-README` — `.factory/specs/prd/README.md` Document Map grand
total stale (pre-existing across ~13 cycles). Out of scope for #474; deferred to dedicated
doc-reconciliation pass. Tracked as DRIFT-README in STATE.md Drift Items (pre-existing entry).

_No blocking issues remain. Adversary CLEAN-for-blocking._

---

## Pass 5 — Claude Adversary (Post-P4)

**Verdict: NOT-CLEAN**

**Finding — LOW: Story EC-004 wrong mechanism description**
EC-004 in the story described the heading-attribute dedup behavior using the phrase
"active_marks forcibly empty" — a phrase that implies the mark stack is cleared, which
is not what happens. The correct description is that heading-attribute events are silently
bypassed (the ADF mapper never receives them as marks to push; pulldown-cmark exposes them
as `HeadingAttributes` events which the match arm ignores entirely).
_Fixed: corrected EC-004 to describe the bypass-mechanism accurately._

---

## Pass 6 — Claude Adversary (Fresh Context) — CLEAN

**Verdict: CLEAN**

All 6 prior fix-areas verified:
- BC-7.2.007 survivor label (sup, not sub): CORRECT
- Symbol citations (push_text, push_code): CORRECT
- Dedup test now has genuine Red Gate: CORRECT
- VP anchors set to []: CORRECT
- All 8 count surfaces at 592: CORRECT
- EC-004 bypass mechanism: CORRECT

**Mark-leak independently VERIFIED-NO-LEAK:** Adversary independently traced the
`push_mark` / generic `end()` / `pop_mark` call flow and confirmed: `push_mark` pushes a
`NodeKind::InlineMark` frame; generic `end()` pops it uniformly via `pop_mark`; no
special-casing for subsup vs other marks. Every opened mark frame is closed by its
corresponding `end()` event from pulldown-cmark. No leak.

**Convergence counter: 1/3.**

---

## Cross-Model Gemini Pass (via `agy` Antigravity CLI)

**Timing:** After Pass 6 CLEAN; before Pass 7.

**Tooling note:** gemini-cli was replaced by `agy` (Antigravity CLI). `agy -p` print-mode
is agentic and requires a SHORT prompt in a clean (non-repo) working directory to stay
on-task; long prompts and/or `--model` flags cause derailment. Free-tier Gemini is also
capacity-throttled (~25 min rolling windows, per tier not per-account).

**Finding 1 — Claimed CRITICAL: subsup mark-leak (push_mark never popped)**
Gemini claimed that `push_mark` for subsup marks never calls `pop_mark`, leaving the
mark-stack permanently polluted for all subsequent text nodes.

**Verdict: REFUTED (false-positive, diff-only blindness)**
Root cause of the false-positive: Gemini reviewed only the diff and did not see the
`match Event::End(_) => self.end()` arm in the existing event loop. The `end()` method
is generic — it dispatches to `pop_mark` for all `InlineMark` frames regardless of mark
type. The subsup implementation correctly piggybacks on this existing generic mechanism.
Evidence: 105 `adf::tests` green (including `test_markdown_superscript_no_mark_leak_to_trailing_text`
added specifically as a no-leak regression guard).

**Finding 2 — LOW: BC-7.2.008 Source/Trace missing test reference**
`BC-7.2.008` Source/Trace rows did not reference
`test_markdown_heading_non_attribute_brace_stripped`, a test that directly exercises the
heading-attribute stripping contract.
_Fixed: added test reference to BC-7.2.008 Source and Trace rows._

---

## Pass 7 — Claude Adversary (Fresh Context) — CLEAN

**Verdict: CLEAN**

All prior fix-areas verified including Gemini LOW fix (BC-7.2.008 Trace/Source).
Mark-leak not re-raised (no new concern).

**Convergence counter: 2/3.**

---

## Pass 8 — Claude Adversary (Fresh Context) — CLEAN

**Verdict: CLEAN**

Fresh-context adversary independently re-derived the NO-LEAK conclusion (consistent with
Pass 6 and the Gemini REFUTED analysis): `end()` dispatch to `pop_mark` is uniform for
all `InlineMark` frames; subsup marks are not special-cased.

**Convergence counter: 3/3 — CONVERGED.**

---

## Final State

| Metric | Value |
|--------|-------|
| Total passes | 8 Claude + 1 Gemini cross-model |
| CLEAN streak | Passes 6, 7, 8 (3/3) |
| False-positive refutations | 1 (Gemini Finding 1: mark-leak) + 1 (P1 heading EC-2) |
| Findings fixed | P1: 3 MAJOR; P2: 1M/2L; P3: 1 count-drift blocker; P4: 5L stale-narration; P5: 1L; Gemini: 1L |
| Tests | 105 `adf::tests` green; 13 new for #474; regression guard `test_markdown_superscript_no_mark_leak_to_trailing_text` added |
| BC grand total | 592 (BC-7.2.007/008 added; all 8 surfaces reconciled) |
| §7.2 BC count | 54 |
| fmt + clippy | Clean |
| Code status | Verified correct from Pass 1; all fix-cycle findings were in spec/story/doc text only |
