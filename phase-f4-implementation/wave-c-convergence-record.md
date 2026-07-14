# F4 Wave C Convergence Record — SOH-COMMENT-CRUD-1 (issue #577) — CONVERGED 2026-07-14

Merged: f9ad71e (S-577-4 edit core, PR #617, user-merged), d14fb10 (S-577-6 view, PR #616, user-merged; incl. mutation-gate fix round: CI 86%→pass after 3 mutant-kill tests, commit 32e8991), 5433dc3 (docs stub-label sweep, PR #618, user-merged; 3 commits: edit/view labels + delete-shipped correction + CLAUDE.md nit), a486f79 (src-comment sweep, PR #619, user-merged; 73e41d8). Base: d0faf1c (wave-B tip).

Per-story Step-4.5 convergence:

**S-577-4 (edit core):** 1M→1L→1L→0→0→0 (passes p1/p2/p3 fix-rounds; window p4/p5/p6 CLEAN×3 STRICT). 13 integration tests including AC-012/013 clap-mutual-exclusion extensions. diff-mutants 7/7 PASS (all injected mutants killed, zero survivors).

**S-577-6 (view):** 1M→1M→1L→0→0→0 + CI mutation-gate fix round (CI 86%→PASS after 3 targeted mutant-kill tests added, commit 32e8991; window p4/p5/p6 CLEAN×3 STRICT). 16 subprocess integration tests + 4 inline unit tests.

Wave-level integration convergence: 5 passes, STRICT CONVERGED (passes 3/4/5 CLEAN×3).

**Pass 1 (2026-07-14):** 1L — stale stub labels at 13+ sites across docs layer (comment-crud.md: edit/view still marked "Stub (S-577-X)"; CHANGELOG entry for delete called out as shipped, not stubbed). Docs-only finding.

**Pass 2 (2026-07-14):** 2L — src-comment stub claim residue ×2 (interactions.rs provenance docstrings for edit/view handlers still referenced stubs; comment_edit.rs test file header referenced stub state). Src-layer findings.

**Passes 3/4/5 (2026-07-14, fresh context each):** CLEAN×3 (STRICT window). Pass-5 empirical evidence: live binary probes via `cargo run`, holdout H-NEW-COMMENT-001/004 line-by-line PASS, e2e surface guard (tests/e2e_cli_surface_guard.rs) green.

Fix-sweep chronology (4 sweeps, 3 layers):
1. **Sweep 1** (pass-1 findings, docs layer): comment-crud.md stub-label corrections — edit/view "Stub" markers removed, delete corrected to "Shipped (S-577-3)"; PR #618 commits 1-2.
2. **Sweep 2** (pass-1 findings, docs layer): CLAUDE.md nit + minor corrections; PR #618 commit 3.
3. **Sweep 3** (pass-2 findings, src layer): interactions.rs + comment_edit.rs provenance docstring updates — removed stub-state references; PR #619 commit 1 (73e41d8).
4. **Sweep 4**: passes 3/4/5 clean window confirmed; no further changes.

Zero [process-gap] findings across passes 3/4/5 (S-7.02 step 2/3 satisfied vacuously for this wave).

Settled adjudications carried to wave D:
- **BC Source citations sync at bundle close** (BC-3.5.003 precedent): bc-3-issue-write.md Source-field citations for edit/view handlers will be updated at bundle close (S-577-5), not in each wave. No re-convergence required for source-citation-only updates.
- **Red Gate provenance docstrings accepted**: pass-2 src findings addressed via targeted docstring update (PR #619); pattern is low-delta with no behavioral change; accepted for wave-C integration close.
- **Inert flags DEC-169 adjudication**: --yes flag silent no-op (EC-3.5.008-4) remains settled; no further wave-C action required.

Wave-D preflight items:
- **(a) JSM sd.public.comment wire-shape live verification** recommended before S-577-5 delivery (PR #616 review advisory): confirm that a PUT with a visibility `properties` array is accepted by live Jira JSM before implementing the --internal/--public path; JSDCLOUD-6050 caveat is research-confirmed but live-wire has not been tested in this cycle.
- **(b) S-577-5 extension seams verified ready**: `update_comment` visibility_flag param is inert (None→Some(bool) requires only the caller change); inert clap flags `--internal`/`--public`/`--yes` are already present in CommentSubcommand::Edit from S-577-1; `tests/comment_edit.rs` is extensible (S-577-5 designated to ADD tests, not replace).
- **(c) S-577-5 owns `closes #577`**: the bundle-closing PR for issue #577 is S-577-5's PR — do NOT close #577 in any wave-C or wave-D integration commit.

S-577-4 worktree (.worktrees/S-577-4) + local branch feat/comment-edit-handler cleaned post-merge. S-577-6 worktree (.worktrees/S-577-6) + local branch feat/comment-view-handler cleaned post-merge. develop tip: a486f79.
