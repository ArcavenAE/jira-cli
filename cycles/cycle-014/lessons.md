---
document_type: lessons
level: ops
version: "1.0"
status: active
producer: state-manager
timestamp: 2026-10-04T23:59:00Z
cycle: "cycle-014-issue-triage-quickfixes"
inputs: [STATE.md]
input-hash: "[live-state]"
traces_to: STATE.md
---

# Lessons Learned — cycle-014-issue-triage-quickfixes

<!-- Entries tagged [codified] are recorded and adopted as process policy (each already in force
     via a human decision `D-NNN` or a STATE.md anti-drift convention). Newest first.
     `Closes:` lines carry structured D-NNN IDs only (hook D-419(c)); finding IDs are in the prose. -->

## L-006 — Do not enumerate a function's full effect matrix in a caller's rustdoc (`FIX-P5-015`) [codified]

**Closes:** D-407

Findings `P12-001`, `P13-001`, `CR13-001`. The `field.rs::handle` effects list drifted three passes
in a row (`P12-001`, PR #909 `NB-1`, `P13-001`/`CR13-001`). Summarize and defer to the callee's own
docs. Source: pass-13.md.

## L-005 — A NIT-only counted pass counts clean under the strict rule (`D-407(a)`) [codified]

**Closes:** D-407, D-403, D-406

Strict means no BLOCKING/MEDIUM/LOW findings; NITs alone do not reset the counter. NITs are fixed in
a tiny comment-only PR before the confirming passes so they review the code that ships. Passes 12-14
converged F5 under this reading. Recompute the slip budget from counter and remaining passes
whenever a pass is recorded.

## L-004 — Run an uncounted fresh-adversary rehearsal before each counted pass (`D-406(c)`) [codified]

**Closes:** D-406

Finding `P11-001`; rehearsals R12, R12B, R12C, R13, R14. Rehearsals catch doc/spec drift cheaply;
counted passes are then spent on a branch that already survived a fresh adversary. Adopted after
Pass 11; Passes 12-14 were clean.

## L-003 — A "mirrored copies" spec claim needs a guard or an explicit shared-vs-divergent contract (`D-405`, process-gap `#53`) [codified]

**Closes:** D-405

Finding `P10-001`, process-gap `#53`. `BC-X.14.001` Invariant 3 claimed two resolvers were mirrored;
they were not. State the shared contract and the deliberate divergence explicitly.

## L-002 — Any "complete/only/every" claim must be mechanically verified, or scoped by source class (`D-404`) [codified]

**Closes:** D-404

Findings `P9-001`, `P11-002`, `P11-003`. `P9-001`: the Canonical Sink Inventory completeness claim
was audited from diffs, not whole files. Whole-file sweep, record the method, split server/config
echoes from user-typed echoes. Applies to rustdoc "only"/"M2-only" claims too.

## L-001 — When a fix strengthens or renames a test, update every spec surface that describes it (process-gap `#52`, `P7-001`) [codified]

**Closes:** D-402, D-401

Finding `P7-001`, process-gap `#52`. Grep the spec corpus for the test name in the same fix. Related
anti-drift conventions (`D-401`): approximate "~N LOC" in size-deviation entries, symbol-form
citations, one authoritative inventory that other docs point to rather than duplicate.
