---
document_type: adversarial-review-log
issue: 471
bc: BC-7.2.010
pass: 3
reviewer: adversary (read-only pass — could not write)
persisted_by: product-owner
date: 2026-06-10
status: resolved
---

# Adversarial Pass 3 Findings — BC-7.2.010 (Issue #471)

Pass 3 found NO critical or structural errors — the Pass 2 schema fixes are confirmed correct.
6 edge-case-interaction precision findings: 0 CRITICAL, 0 HIGH, 4 MEDIUM, 2 LOW + 1 process-gap.

---

## Findings (verbatim from adversarial pass)

### F1 — MEDIUM: EC-8 ↔ EC-16 ordering ambiguity

The order of multi-paragraph inline-flattening (EC-16) vs the empty-content prune (EC-8) is
unstated, making `- [ ]\n\n  y` ambiguous: the prune might fire on the empty first paragraph
before EC-16 has had a chance to concatenate and trim, or EC-16 might run first making EC-8's
criterion clear. Without an explicit ordering, two compliant implementations could disagree on
whether `- [ ]\n\n  y` yields `taskItem.content: [text("y")]` or yields a pruned item.

---

### F2 — MEDIUM: EC-10 omits hardBreak round-trip lossiness

EC-10 bolds "ALL lossy transforms enumerated" and lists six entries (a)–(f). However, it omits
that an interior `hardBreak` inside a `taskItem` does NOT round-trip as a `hardBreak`: a bare
newline inside a `- [ ] ` line re-parses as a soft break / item terminator, NOT as a GFM
hardBreak (which requires two trailing spaces or a backslash before the newline). The
hardBreak-separator injected by EC-16's multi-paragraph flattening is therefore permanently lost
through the round-trip text form. The "ALL" claim is overstated without this entry.

---

### F3 — MEDIUM: EC-10(a) loss-direction mis-described

EC-10(a) frames the mixed-list loss as happening on the `adf_to_text` re-render leg: "the
`adf_to_text` render emits it as `- [ ] `, which on re-parse produces a real checkbox item — the
original non-checkbox identity is permanently lost." This is misleading — the irreversible
decision (plain bullet item promoted to `taskItem { state: "TODO" }`) is made at the FORWARD
markdown→ADF parse step. The re-render merely makes the loss visible. The loss direction should
be described as occurring at parse time, not render time.

---

### F4 — MEDIUM: localId uniqueness "guaranteed"/"guarantees" overclaims schema enforcement

The BC states localId assignment "guarantees document-wide uniqueness" (in the Required Attributes
section) and the per-document DFS-walk rule says the counter "guarantees document-wide-unique
localIds." These phrasings imply the ADF schema enforces or mandates uniqueness. The research
§2 (and `@atlaskit/adf-schema` `full.json` v40.9.2) is explicit that uniqueness is RECOMMENDED to
avoid renderer ambiguity, not schema-enforced — `full.json` has no uniqueness constraint on the
`localId` field. The BC overclaims.

---

### O1 — LOW: EC-10(c) does not reflect EC-6 CONDITIONAL status

EC-10(c) lists blockquote unwrapping as a definite lossy transform in the enumerated loss ledger,
but EC-6 marks that path as CONDITIONAL/F4-unconfirmed — it only applies if pulldown-cmark
actually emits `blockquote > taskList`, which is unconfirmed. EC-10(c) should carry the same
conditional qualifier as EC-6.

---

### O2 — LOW: Test name understates EC-5 normalization shape

Trace entry `test_task_list_in_list_item_normalized_to_plain_list` understates what EC-5 produces.
EC-5 normalizes a task list inside a list item to `listItem > [bulletList > [listItem > paragraph,
...]]` — a NESTED bulletList, not a flat list. A future test writer reading the name "plain_list"
might assert the INVALID flat-listItem shape (which EC-5 explicitly rejects as `listItem > listItem`
INVALID ADF). The name should accurately describe the nested structure.

---

### O3 — LOW [process-gap]: F4-conditional blockquote probe must back-propagate before F7

The blockquote-probe result from F4 (whether pulldown emits `blockquote > taskList` for
`> - [ ] item`) MUST be back-propagated into EC-6 / obligation #2 and into EC-10(c) before the
BC is considered fully converged at F7. This is a tracked F4 dependency. It does not block F2
convergence, but if it is not scheduled it will result in a permanently-conditional EC-6 at ship
time. Tag: [process-gap].

---

## Resolution

Each finding is addressed in the BC-7.2.010 revision committed alongside this file:

| ID | Severity | Resolution |
|----|----------|------------|
| F1 | MEDIUM | Added explicit ordering sentence to EC-16: "Multi-paragraph inline-flattening (EC-16) runs BEFORE the empty-content prune (EC-8); the prune evaluates the fully-concatenated taskItem.content." Updated EC-8 opening clause to note the evaluation order ("After EC-16 inline-flattening is applied…"). |
| F2 | MEDIUM | Added entry (g) to EC-10's lossiness ledger: "hardBreak-separator from EC-16 multi-paragraph flattening does not round-trip — a bare newline inside a `- [ ] ` line re-parses as a soft break or item terminator, not as a GFM hardBreak (which requires two trailing spaces or a backslash)." The "ALL" claim is qualified to "all known lossy transforms enumerated." |
| F3 | MEDIUM | EC-10(a) reworded: "the plain-item identity is lost at markdown→ADF promotion; the round-trip cannot recover it." The re-render leg is no longer described as the site of the loss. |
| F4 | MEDIUM | Rewrote localId uniqueness claims to: "the monotonic counter yields document-wide-unique localIds (uniqueness is recommended to avoid renderer ambiguity, not schema-enforced — see research §2)." Both occurrence sites (Required Attributes section and DFS-walk rule sentence) updated. |
| O1 | LOW | EC-10(c) tagged "(conditional on EC-6 confirmation)" to match EC-6's CONDITIONAL status. |
| O2 | LOW | Trace test name renamed from `test_task_list_in_list_item_normalized_to_plain_list` to `test_task_list_in_list_item_normalized_to_nested_bullet_list` to accurately describe the `listItem > [bulletList > [listItem > paragraph, ...]]` output shape and prevent a future assertion of the invalid flat-listItem form. |
| O3 [process-gap] | LOW | Logged as tracked F4 dependency. Added a note to EC-6 obligation #2: "F4 probe result MUST be back-propagated into EC-6 and EC-10(c) before F7 convergence — tracked as an F4 dependency [process-gap]." |
