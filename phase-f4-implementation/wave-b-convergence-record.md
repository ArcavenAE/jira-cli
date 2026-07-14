# F4 Wave B Convergence Record — SOH-COMMENT-CRUD-1 (issue #577) — CONVERGED 2026-07-14

Merged: d0faf1c (S-577-3 comment delete, PR #615, user-merged; base 729b8c4). Deviation D-1 ratified DEC-174.

Wave-level integration convergence: 3 passes, ALL CLEAN (STRICT 3/3).

**Pass 1 (2026-07-13, pre-wrap):** CLEAN. Dismissed non-finding: delete's single-line blocking stdin read vs add's spawn_blocking — adjudicated justified (implementation-specific to DEC-174 dialoguer UNUSABLE finding; not a cross-story inconsistency).

**Pass 2 (2026-07-14, fresh context):** CLEAN. Verified: dispatch seam arg threading (cli.no_input, not re-derived is_terminal); delete_comment injection surface nil (validate_comment_id pre-validation); exit taxonomy vs BC-3.5.004; holdout anchors H-NEW-COMMENT-003/005; mutants.toml choreography; #526 render invariant. Borderline: json-output-shapes.md cancel-shape doc gap ruled into settled stub-marker deferral (item 3). Adjudicated src/main.rs compact H-020 error envelope as pre-existing/non-delta.

**Pass 3 (2026-07-14, fresh context):** CLEAN. Verified: mod.rs:82-85 dispatch signature match; EC-3.5.002-1 caller-side precondition documentation; error re-wrap scope (only 404/403→UserError); JR_STDIN_IS_TTY cfg adjacency pin; CLAUDE.md citation guard; BC-3.5.003 cancel envelope. Empirical run: `cargo test --test comment_delete --test jr_stdin_is_tty_release_gate` — 11/11 PASS. BC-3.5.002 trailing-period nit on settled list, not re-filed.

Zero [process-gap] findings across the window (S-7.02 step 2/3 satisfied vacuously for this wave).

S-577-3 worktree (.worktrees/S-577-3) + local branch feat/comment-delete-handler removed post-merge. develop tip: d0faf1c.

Wave-C preflight (carried from checkpoint 67, still valid):
- S-577-4 (edit core) + S-577-6 (view) PARALLEL off develop ≥d0faf1c
- Both edit interactions.rs + mutants.toml exclude_re (second lander hits designed rebase conflict — stories carry conditional resolution instructions)
- validate_comment_id module-private in interactions.rs, directly callable, no visibility change needed
- Stale stub-marker class (comment-crud.md + json-output-shapes.md "Stub (S-577-3)" + CHANGELOG "delete ... are stubs") deferred to bundle close — do not re-file
