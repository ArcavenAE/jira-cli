---
document_type: adversarial-review-log
issue: 471
bc: BC-7.2.010
pass: 4
reviewer: adversary (read-only pass — could not write)
persisted_by: product-owner
date: 2026-06-10
status: resolved
---

# Adversarial Pass 4 Findings — BC-7.2.010 (Issue #471)

Pass 4 found NO critical or structural errors — the Pass 3 precision fixes are confirmed correct.
4 EC-11-centered consistency findings: 0 CRITICAL, 0 HIGH, 3 MEDIUM, 1 LOW + 1 process-gap
reaffirmation + 1 count-surface check.

---

## Findings (verbatim from adversarial pass)

### F-1 — MEDIUM: EC-11 round-trip claim contradicts EC-10(g)

EC-11 says a native hardBreak inside a taskItem round-trips "the same as in paragraph context"
(implying the round-trip is stable). However, EC-10(g) correctly states that ANY hardBreak
rendered inside a `- [ ] ` line is round-trip-LOSSY — a bare newline inside the item line
re-parses as a soft break or item terminator, not as a GFM hardBreak (which requires two trailing
spaces or a backslash before the newline). The "same as paragraph context" framing is misleading
because paragraph-context hardBreaks DO survive the round-trip (a `hardBreak` in a paragraph
renders as two-trailing-spaces+newline, which re-parses correctly), whereas taskItem-context
hardBreaks do NOT — the `- [ ] ` line format provides no mechanism to re-encode the hardBreak.
EC-11 therefore contradicts EC-10(g) and creates an overclaim that could mislead the F4
implementer into believing the round-trip is stable when it is not. Additionally, the same
lossiness analysis applies to EC-16-injected hardBreaks — both native (EC-11) and
EC-16-injected (EC-10(g)) hardBreaks produce the identical lossy artifact.

---

### F-2 — MEDIUM/LOW: Missing worked example for all-empty multi-paragraph case

No worked example covers `- [ ]\n\n  ` (two paragraphs, BOTH empty). The existing examples
cover: normal case (`line1 + line2`), trailing-empty-paragraph case (`x + empty`), and
leading-empty-paragraph case (`empty + y`). The BOTH-empty case exercises all three pipeline
stages in sequence — flatten→trim→prune — and the expected output is prune-to-nothing (EC-8).
Without an explicit worked example, a reader could incorrectly infer that the leading-empty trim
removes the leading hardBreak but leaves a residual empty `taskItem` in the output.

---

### F-3 — MEDIUM: EC-11 trace-test orphan

EC-11 (native hardBreak inside taskItem) has no corresponding trace test in the Trace section.
All other ECs with testable observable behavior have at least one trace entry. EC-11 is the only
EC without a traceable test, creating an orphan. Since native-inline and EC-16-injected hardBreaks
produce the identical artifact and identical lossiness, the cleanest resolution is either: (a) add
a dedicated test `test_task_item_native_hardbreak_inline_is_roundtrip_lossy` that asserts the
hardBreak renders as a newline continuation but the round-trip is lossy; or (b) fold EC-11 into
EC-16 and note both share the test `test_task_item_multi_paragraph_flattened_to_inline`, making
the consolidation explicit. Either option eliminates the orphan; option (a) is preferred because
EC-11 and EC-16 describe structurally different inputs (native vs injected hardBreak) even though
they produce the same output.

---

### F-4 — LOW: Headline overclaim — unconditional `- [ ]`/`- [x]` mapping

The BC-7.2.010 behavior headline asserts an unconditional clean two-way `- [ ]`/`- [x]` mapping.
The reverse-path body correctly notes that only `state: "DONE"` (case-insensitive) renders as
`- [x]`, and everything else (including `"TODO"` and absent/unrecognized state) renders as
`- [ ] `. The headline does not reflect this directional asymmetry and could be read as implying
a simpler 1:1 mapping in both directions.

---

### O-1 [process-gap reaffirmation]: F4 blockquote probe back-propagation remains tracked

The F4 blockquote-probe back-propagation obligation (EC-6 / obligation #2 / EC-10(c)) was
logged in Pass 3 (O3) and carries forward. Pass 4 reaffirms this is a tracked F4 dependency —
it does not block F2 convergence but must be discharged before F7. No change needed here; this
entry records the forward-carry.

---

### O-4 [count-surface]: Script verification

Both `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` must pass at
594 total BCs after this pass. No BC numbering changes in this pass.

---

## Resolution

Each finding is addressed in the BC-7.2.010 revision committed alongside this file:

| ID | Severity | Resolution |
|----|----------|------------|
| F-1 | MEDIUM | EC-11 reworded to state that a hardBreak inside `taskItem.content` renders as a newline continuation of the item line but the round-trip is LOSSY — a bare newline in a `- [ ] ` line re-parses as a soft break / item terminator, not a GFM hardBreak. Cross-reference to EC-10(g) added. The misleading "same as paragraph context" stability framing is removed. Added note that the lossiness applies equally to native (EC-11) and EC-16-injected (EC-10(g)) hardBreaks. |
| F-2 | MEDIUM/LOW | Added explicit worked example for all-empty multi-paragraph case (`- [ ]\n\n  `) to EC-16: flatten→trim→prune sequence fires in order; the taskItem is ultimately pruned (EC-8). |
| F-3 | MEDIUM | Added trace test `test_task_item_native_hardbreak_inline_is_roundtrip_lossy` to the Trace section of BC-7.2.010 and cited it in EC-11. This test asserts: (1) a native hardBreak in taskItem renders as a newline continuation, and (2) the round-trip re-parse does NOT produce a hardBreak (lossiness confirmed). EC-11 cross-references this test explicitly. |
| F-4 | LOW | Behavior headline qualified: replaced the unconditional round-trip claim with a phrase noting the reverse-path rule (DONE → `[x]`, all other states → `[ ]`). The headline now accurately reflects the directional asymmetry documented in the body. |
| O-1 [process-gap] | reaffirmed | F4 blockquote-probe back-propagation dependency confirmed carried forward to F7. Obligation #2 in BC body retains its existing "[process-gap] F4 probe result MUST be back-propagated into EC-6 and EC-10(c) before F7 convergence" note. No change needed. |
| O-4 | confirmed | Both count scripts pass at 594 BCs. No BC numbering changes in this pass. |
