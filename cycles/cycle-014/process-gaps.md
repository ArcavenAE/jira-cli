---
document_type: process-gaps
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-09-26T00:01:34Z
cycle: "cycle-014-issue-triage-quickfixes"
inputs: [STATE.md]
input-hash: "553c03a"
traces_to: STATE.md
---

# Process-Gap Candidates — cycle-014 (issue-triage-quickfixes)

Candidates for the S-7.02 cycle-closing checklist, recorded during the F2
CYCLE-014-F2-CHECKPOINT burst (2026-09-25/26, F2 IN PROGRESS, not yet
dispositioned — dispositioning happens at cycle close per S-7.02).

1. **`scripts/check-bc-citation-symbols.sh` does not scan `cross-cutting.md`** —
   the guard's glob is `bc-*.md` only; every new/amended citation added to
   `cross-cutting.md` this cycle was written to resolve against real `src/`
   symbols by hand, with no mechanical check backing that claim. Candidate:
   extend the guard's glob, or add a sibling guard scoped to `cross-cutting.md`.

2. **Partial-fix propagation** — corrections made during the F2 adversarial
   spec-delta review repeatedly reached the BC body but not its sibling
   summary surfaces (index rows, changelog entries, canonical-counts blocks),
   requiring later passes to re-discover and re-fix the same drift on a
   different surface. Candidate: a per-fix propagation checklist (BC body →
   INDEX row → CANONICAL-COUNTS → changelog) enforced before a pass is
   declared clean.

3. **The vsdd-factory hook fails closed with `FUEL_EXHAUSTED` on edits** — this
   is a resource cap (fuel budget exhaustion), not a content-validation
   failure, yet it surfaces identically to a real block (`block_intent=true`,
   exit code 2) from `validate-factory-path-root`/`validate-input-hash`/
   `validate-template-compliance`. Observed live during this F2 checkpoint
   burst on plain `Edit` calls. Candidate: raise the fuel cap for known-large
   payload files, or distinguish resource-exhaustion blocks from
   content-validation blocks in the hook's reported reason string.

4. **A whole-file Python rewrite by an agent duplicated `cross-cutting.md`** —
   detected only via a heading-count check (`grep -c '^#### BC-'`), not by any
   structural guard. Candidate: a guard that rejects a rewrite producing a
   duplicate `#### BC-` heading, or a policy steering agents away from
   whole-file rewrites of `cross-cutting.md` in favor of targeted edits.

5. **`JR_AUTH_HEADER` is missing from `CLAUDE.md`'s `JR_*` seam table** — it is
   documented in `docs/specs/e2e-live-jira-testing.md` but not in the
   top-level table alongside the other `JR_*` seams. Candidate: add a row (or
   a cross-reference note) to the `JR_*` table for E2E-only env vars that live
   outside the debug-build test-seam family.

6. **No guard for the `BC-INDEX.md` Coverage Statistics table or the
   `CANONICAL-COUNTS.md` Breakdown block** — `scripts/check-bc-cumulative-counts.sh`
   checks the 8 documented surfaces but not these two supplementary blocks,
   which can drift silently. Candidate: extend the cumulative-counts guard to
   cover both blocks, or document them as explicitly out of guard scope.

7. **No story owned `README.md` doc-delta obligations** — cycle-014's three
   stories (#862/#583/#861) changed CLI behavior but none was assigned
   responsibility for a corresponding `README.md` update, and the
   pre-existing `README-JR-API-BODY-FLAG` drift item (registered this burst)
   went unnoticed until an ad hoc pass-30 finding. Candidate: add a
   README-delta checklist item to the story template for any story that
   changes CLI-visible behavior.

8. **No CI check compares `docs/specs/cargo-mutants-policy.md`'s "Current
   examine_globs count" line with `.cargo/mutants.toml`** — the count is
   maintained by hand and can drift from the actual file. Candidate: a small
   guard script (mirroring `tests/mutants_glob_existence.rs`'s existence
   check) that also asserts the documented count matches
   `len(examine_globs)`.

9. **Agent stalls (600s no-progress) on large-file tasks** — observed on
   tasks touching the now-large `cross-cutting.md`/`edge-case-catalog.md`
   files during this cycle; mitigated in-session by giving agents narrow,
   pre-located briefs (exact section/line targets) rather than open-ended
   "find and fix" instructions. Candidate: codify the narrow-brief mitigation
   as standing guidance for any future task touching these files, and
   consider whether the files themselves are due for a size-reduction pass.

## Disposition

Not yet dispositioned. This is a checkpoint record (F2 IN PROGRESS, not
approved) — the S-7.02 cycle-closing checklist dispositions each item when
cycle-014 closes.
