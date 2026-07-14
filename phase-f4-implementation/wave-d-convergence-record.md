# F4 Wave D Convergence Record — SOH-COMMENT-CRUD-1 (issue #577) — CONVERGED 2026-07-14

Merged: 4dcec9f (S-577-5 visibility/edit, PR #620, user-merged; closes #577), f4ab77b (docs/577-s5-deferral-sweep, PR #621, user-merged; commits 31b174c+7c97f5e). Base: a486f79 (wave-C tip).

Per-story Step-4.5 convergence:

**S-577-5 (edit visibility):** 1M+1L→0→0→0 (pass-1 findings; window p2/p3/p4 CLEAN×3 STRICT).

- **Pass-1 finding 1 (1M):** Adversary false claim that `--yes` flag requires `--public` (CHANGELOG described it as required; clap model is independent optional flags — `--yes` silences the y/N prompt regardless of visibility flag; fixed by adversary, a437135).
- **Pass-1 finding 2 (1L):** E2E scope substitution PG-F4-11 — implementer improvised sd.public.comment property probe in place of story-mandated role/group visibility restriction; human-directed research before adjudication (research/issue-577-jsm-visibility-restriction-2026-07-14.md; 6 cited answers); DEC-175 RESTORE ruling; implemented fbf1a1e.
- **Red Gate:** 09d8467 (10 red + 3 green; stub output validated).
- **Implementation:** 9ca64ec (26/26 tests green; mutation gate via diff-mutants, PASS).
- **Demos:** 12/12 AC demos PASS.
- **Passes 2/3/4 (fresh context each):** CLEAN×3 (STRICT window). Pass-4 sign-off: 7 live gate paths driven end-to-end; guard scripts green (spec-counts OK, bc-cumulative 624/8 surfaces, 334 citations).

Wave-level integration convergence: 4 passes, STRICT CONVERGED (passes 2/3/4 CLEAN×3).

**Pass 1 (2026-07-14):** 2L — (a) stale S-577-5 deferral notes (docs/specs/ still referenced "scope: deferred to S-577-5" for visibility features now shipped); (b) incomplete edit JSON output shapes in comment-crud.md (edit response shape not fully documented post-implementation). Docs/spec-layer findings.

**Passes 2/3/4 (2026-07-14, fresh context each):** CLEAN×3 (STRICT window).

Fix-sweep chronology:

1. **Sweep 1** (pass-1 findings, docs layer): docs/577-s5-deferral-sweep — removed stale deferral notes in docs/specs/ for now-shipped visibility features; completed edit JSON output shape documentation in comment-crud.md; PR #621 commits 31b174c+7c97f5e (user-merged @ f4ab77b).
2. **Sweeps 2/3/4**: passes 2/3/4 clean window confirmed; no further changes.

Zero [process-gap] findings across passes 2/3/4 (S-7.02 step 2/3 satisfied vacuously for this wave).

BC Source sync (9 lines BC-3.5.002..010): completed as part of PR #620 delivery; check-bc-citation-symbols.sh PASS (334 citations). Wave-C adjudication honored — BC Source citations updated at bundle close in S-577-5's PR, not per-wave.

Whole-bundle collateral sweep (d0faf1c...f4ab77b): CLEAN. mutants.toml end-state verified.

**F4 PHASE COMPLETE** — 5 stories (S-577-1/2/3/4/5; S-577-6 parallel to S-577-4 wave-C), 4 waves A/B/C/D, 11 PRs merged:

| PR | Story | SHA | Notes |
|----|-------|-----|-------|
| #610 | S-577-1 | 907a795 | comment group + clap authoring |
| #611 | S-577-2 | bbe54e9 | comment add handler |
| #613 | fix/docs | — | wave-A docs fix (DEC-173) |
| #614 | fix/src | — | wave-A src fix (DEC-173) |
| #615 | S-577-3 | d0faf1c | comment delete handler; wave-B tip |
| #616 | S-577-6 | d14fb10 | comment view handler (incl. mutation-gate fix 32e8991) |
| #617 | S-577-4 | f9ad71e | comment edit core |
| #618 | fix/docs | 5433dc3 | wave-C docs stub-label sweep (3 commits) |
| #619 | fix/src  | a486f79 | wave-C src-comment sweep; wave-C tip |
| #620 | S-577-5 | 4dcec9f | edit visibility; closes #577; BC Source sync |
| #621 | fix/docs | f4ab77b | wave-D deferral-notes sweep; wave-D tip |

develop tip: f4ab77b. Issue #577 CLOSED (user, 2026-07-14).

F5-forward notes:

- **H-NEW-COMMENT-002 wording pin** (holdout): verified satisfied — wording matches the adversary-reviewed spec text exactly; no F5 action required.
- **Deferred EJ probe (BC-3.5.006):** e2e visibility read-back (`test_e2e_comment_edit_visibility_merge_semantics`) completes when e2e.yml runs green nightly. F7 checklist item — close BC-3.5.006 probe pending that first green nightly run.
- **Stderr-hint follow-up story candidate (DEC-169 item 3):** house-wide `--yes` / `--no-resolution` / `--no-input` silent-flag hint pattern; open for cycle close; not required for F5/F6/F7.
- **Story-frontmatter sync verification:** S-577-1..6 story file `status:` fields should be synced to DELIVERED at bundle close (F7 checklist).

All worktrees cleaned: S-577-4 (.worktrees/S-577-4, feat/comment-edit-handler), S-577-5 (.worktrees/S-577-5, feat/comment-edit-visibility), docs/577-s5-deferral-sweep — all removed post-merge.
