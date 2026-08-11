---
document_type: drift-items-closed
level: ops
version: "1.0"
status: archive
producer: state-manager
timestamp: 2026-08-09T00:00:00Z
cycle: "cycle-001"
inputs: [STATE.md]
input-hash: "9f96073"
traces_to: STATE.md
---

# Closed/Superseded/Resolved Drift Items — cycle-001

<!-- 20 CLOSED / SUPERSEDED / RESOLVED / CLOSED-BY-REMOVAL / CLOSED-STRUCTURALLY drift-item rows
     extracted verbatim from STATE.md v2.28's Drift Items table during the 2026-08-09 COMPACTION
     burst. STATE.md's Drift Items table now carries only OPEN items (as a compact index — see
     drift-items-open-detail.md for their full narrative bodies). -->

| ID | Area | Severity | Status |
|----|------|----------|--------|
| TEST-JOB-ZERO-TEST-FLOOR | CI integrity | LOW | CLOSED IN-CYCLE — FIXED IN-CYCLE by product commit 9312f11f (DEC-211). |
| STORY-TEMPLATE-DRIFT-BLOCKS-EDITS | spec process | MEDIUM | SUPERSEDED by PRE-EXISTING-DRIFT-BLOCKS-CORRECTNESS-FIXES. |
| CI-YML-LINE-CITATION-RIPPLE | citation hygiene | MEDIUM | CLOSED-STRUCTURALLY — 10-workflow-file sweep confirmed zero remaining line-number citations. Class fully closed across both .factory/ and ci.yml surfaces. |
| AGENT-DECLINED-TO-INVENT-FRONTMATTER | process quality | INFO | CLOSED — positive datapoint (2026-08-04). |
| PIN-ASSERTIONS-PROSE-SATISFIABLE | guard integrity | MEDIUM | CLOSED — fixed fix round 9 (7798b1bf). TWENTY-ONE-plus independent confirmations through pass-44; passes 45-53 did not re-probe this specific class (different frontier each pass). |
| COUNT-IN-PROSE-DRIFT-CLASS | spec process | LOW | CLOSED-BY-REMOVAL — CLASS LESSON: prefer structural assertions over prose count claims. |
| BRIEFING-DERIVED-FROM-DIFFSTAT-MISCLASSIFIES-FILES | orchestrator process | LOW | CLOSED — no recurrence since pass-27. |
| FIX-ROUND-GENERATES-NEXT-WINDOW-FINDINGS | convergence process | HIGH | SUPERSEDED — by TARGETED-FIX-ROUNDS-DO-NOT-CONVERGE. |
| REVIEWED-ARTIFACT-NOT-MERGEABLE-ARTIFACT | orchestrator process | MEDIUM | RESOLVED FOR THIS CYCLE — branch pushed before every dispatch since round 12; PR #667 head has equaled the reviewed head at every subsequent window, now `3ad496eb` (was `ada50a34`). |
| STORY-INDEX-OUTSIDE-REVIEW-PERIMETER | review process | MEDIUM | CLOSED — `STORY-INDEX.md` added to the reviewer whitelist for the passes 36/37/38 window; no self-contradiction found since. |
| CI-GATE-SKIPPED-FALSE-GREEN | CI governance | HIGH | CLOSED — FIXED (2026-08-07). S-CIGATE-2's Option C merged via PR #671 (`df203233`). Confirmed live across three runs including a genuine-failure proof. Residual lexer-fidelity gap tracked separately as S-CIGATE-3. |
| FILES-MODIFIED-UNDECLARED | spec process | MEDIUM | **CLOSED — FIXED (2026-08-07, FIX-ROUND-20).** `files_modified` re-derived to the true 18 and declared at all five S-626-1 surfaces. |
| AUTHORIZATION-TRAIL-LAGS-CONTENT-NARRATIVE | spec process | MEDIUM | **CLOSED — FIXED (2026-08-07, FIX-ROUND-20), re-confirmed unchanged this burst.** `tests/ci_gate_completeness.rs` authorization trail re-derived to the true 17 commits with an explicit, restatable scope rule. Recurrence risk tracked going forward under TRAIL-DERIVATION-UNGUARDED, which now has a registered follow-up story (S-TRAIL-DERIVATION-GUARD-1). |
| STRENGTHENED-CANARY-UNPINNED | spec/test integrity | HIGH | **CLOSED — FIXED (2026-08-07, REGRESSION-PIN+EC+GUARD-STORY).** Commit `ada50a34` extends `test_verify_test_job_has_zero_test_floor` 12→15 `assert!(` calls, human-authorized per DEC-241. |
| SPEC-EDGE-CASES-LAG-GUARD-STRENGTHENING | spec integrity | MEDIUM | **CLOSED — FIXED (2026-08-07, REGRESSION-PIN+EC+GUARD-STORY).** `cross-cutting.md` gained `EC-CIGATE-006` with a matching Verification-status bullet and Canonical Test Vectors row; Postcondition 5 split. |
| ANTI-NEUTERING-CONTROLS-STOP-AT-CI-GATE | CI governance | HIGH | **CLOSED — FIXED (2026-08-07, PILE-1-GUARD-STRENGTH).** Commit `3ad496eb` closed all four pass-51 instances via one default-deny mechanism (`PINNED_TEST_GUARD_STEP_KEYS`/`PINNED_TEST_GUARD_ENV_KEYS`, scoped to `test`'s POL-11 guard step) plus a class sweep (`test_always_run_jobs_have_no_continue_on_error`) covering all seven always-run `ci-gate.needs` members — not four point fixes. `mutants`/`ci-gate` deliberately excluded with in-code rationale. |
| GUARD-MANDATES-ITS-OWN-DEFEAT-TOKEN | guard integrity | HIGH | **CLOSED — FIXED (2026-08-07, PILE-1-GUARD-STRENGTH).** New `test_test_job_pipefail_bracket_ordering_is_position_constrained` asserts strictly-increasing byte offsets across the four pipefail-related markers — a genuine position constraint, not a presence check. RED-proven: relocating `set +o pipefail` was missed by the old presence assertions (stayed GREEN) but caught by the new ordering test (byte offset 2066 vs 1836), confirming the old guard's blindness. |
| DIAGNOSTIC-INSTRUCTS-REINTRODUCING-THE-DEFECT | spec/doc hygiene | MEDIUM | CLOSED -- FIXED (2026-08-07, CLASS-LEVEL-STALE-CLAIM-SWEEP, commit `7f8723a5`). Both Class-6 assertion messages/comments in the guard suite that instructed reconstructing the retired inline `contains(needs.*.result, ...)` mechanism corrected -- most notably the M2-c panic message in `test_ci_gate_pass_fail_semantics_are_structurally_placed`, which told a maintainer the retired expression must be on a STEP-level `if:` while M2-d ~90 lines below panics if any step-level `if:` exists; now describes the shipped fail-closed `check-ci-gate.sh` design and warns against the step-level move. |
| DOWNSTREAM-DOCS-EXCLUDED-FROM-CORRECTION-PERIMETER | spec process | MEDIUM | CLOSED -- FIXED (2026-08-07, CLASS-LEVEL-STALE-CLAIM-SWEEP, commit `7f8723a5`). Correction perimeter widened to include `docs/specs/` for the first time; `docs/specs/cargo-mutants-policy.md`'s ten stale occurrences fixed, including the retired false-green stated as its own safety rationale and a 90-minute budget prohibition corrected against the shipped 240-minute `cargo-mutants --timeout`. Perimeter-widening precedent set -- future sweeps should default to including `docs/specs/`, not treat it as out of scope. |
| ASSERTION-COUNT-CITATIONS-LAG-CODE | spec integrity | MEDIUM | CLOSED -- FIXED (2026-08-07, CLASS-LEVEL-STALE-CLAIM-SWEEP, commit `7f8723a5`). The 15→18 assertion-count change on `test_verify_test_job_has_zero_test_floor` propagated to BC-X.13.007/VP-CIGATE-001 (`cross-cutting.md`, `BC-INDEX.md`) and S-626-1 at all cited sites; gate arity also corrected 3→4 (canary presence and canary passed-count split into separate items). |
| GITHUB-PATH-UNRECORDED-AT-ROUND-13-SEAM | CI governance | LOW | CLOSED -- OPENED AND CLOSED SAME PASS (2026-08-10, DEC-261, `research/gh-actions-open-semantics-2026-08-10.md`). `CLAUDE.md` round-13 IMPORTANT 2 named only `$GITHUB_ENV` as the cross-step mechanism reachable via `ci-gate`'s two unpinned `uses:` steps (`harden-runner`, `checkout`); `$GITHUB_PATH` is a second, equivalent, documented mechanism at the same seam ("Prepends a directory to the system `PATH` ... available to all subsequent actions in the current job") and nothing recorded it. Confirms the `PATH`->`jq` shim vector (`ADV-P59-LOW-001`) was real, retroactively justifying `f2bea32e`. Fixed by recording `$GITHUB_PATH` alongside `$GITHUB_ENV` in `CLAUDE.md` via product commit `5ca51bc2`. |
| SUDO-BOUND-UNRECORDED-IN-PROJECT-RECORD | CI governance | LOW | CLOSED (2026-08-11, PR #675, `d55bedf7`). Recorded 2026-08-11 (DEC-263) as "a follow-up PR is being raised for this; not actioned this pass" -- that follow-up PR is `d55bedf7`, merged after passing a targeted claim-accuracy review (ADV-P675, DEC-264). `resolve_trusted_jq`'s `HONEST SCOPE` comment's passwordless-sudo bound now has a matching `CLAUDE.md` entry beside the pre-existing knowingly-unpinned `uses:` residual -- both are recorded as the same residual: whatever runs before the gate step can forge the decision, and no in-script check can prevent it. |
