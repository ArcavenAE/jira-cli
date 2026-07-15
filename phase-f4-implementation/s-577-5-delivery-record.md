# S-577-5 Delivery Record — comment edit visibility flags + e2e probe (closes #577) — MERGED 2026-07-14
PR #620 → develop, squash 4dcec9f (user-merged; wave-D, bundle-closing; closes #577). Base a486f79 (wave-C tip).
Red Gate: 09d8467 (10 red + 3 green). Implementation: 9ca64ec (26/26 tests green; diff-mutants PASS).
Step 4.5 convergence: 1M+1L→0→0→0 (pass-1 findings; window p2/p3/p4 CLEAN×3 STRICT).
Pass-1 finding 1 (1M): adversary false CHANGELOG claim that --yes requires --public; fixed a437135.
Pass-1 finding 2 (1L): e2e scope substitution PG-F4-11 — human-directed research (research/issue-577-jsm-visibility-restriction-2026-07-14.md); DEC-175 RESTORE ruling; implemented fbf1a1e.
12/12 AC demos PASS. Docs sweep: PR #621 @ f4ab77b (31b174c+7c97f5e).
Full detail: phase-f4-implementation/wave-d-convergence-record.md.
