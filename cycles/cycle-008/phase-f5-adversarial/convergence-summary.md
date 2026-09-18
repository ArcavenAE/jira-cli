# F5 Scoped Adversarial — Convergence Summary

- **Cycle:** cycle-008 (`oauth-surface-correctness`)
- **Phase:** F5 scoped adversarial review
- **Scope:** whole cycle-008 code delta, `git diff 0793b9c5..fc608cd3` — base
  `0793b9c5` (last commit before any cycle-008 story merged) through the current
  `develop` tip `fc608cd3` (FIX-F5-001 merged). Covers all 6 merged commits: S1
  (`4afc5aa5`), S3 (`9caa7bb5`), S2 (`5f718d13`), S4 (`a32caef4`), wave-gate fix
  `#836` (`578a7848`), S5 (`926fdb96`), and this phase's own fix, FIX-F5-001
  (`fc608cd3`).
- **Reviewer:** adversary agent, fresh context each pass, adversary model family
  (distinct from the builder model family used for S1-S5 implementation) —
  satisfies the cross-model information-asymmetry requirement.
- **Date:** 2026-09-18

## Verdict: F5 CONVERGED

| Pass | Scope | CRIT | HIGH | MED | LOW/COSMETIC | Novelty | Verdict |
|------|-------|------|------|-----|--------------|---------|---------|
| 1 | Whole cycle-008 delta (fresh context) | 0 | 0 | 2 (F1, F2) | 2 (F3, F4) + 1 process-gap note | HIGH (first pass, baseline) | CLEAN on CRITICAL/HIGH — 4 findings + 1 process observation |
| 2 | Re-review of FIX-F5-001 fix (fresh context) | 0 | 0 | 0 | 0 | LOW (fix-confirmation only) | CLEAN — fix CONFIRMED genuine (F3 chain-traversal closes the fragility; new tests non-vacuous, would fail against pre-fix code) |
| 3 | Whole cycle-008 delta, fresh convergence-confirmation, fix included (fresh context) | 0 | 0 | 0 | 0 | 0.10 (< 0.15 convergence threshold) | CLEAN — spec-faithful, regression-safe, leak-free, well-tested |

**3 consecutive passes with 0 CRITICAL/HIGH, novelty decaying HIGH → LOW → 0.10.**
Minimum-3-clean-pass convergence criterion met per
`vsdd-factory:adversarial-review` (novelty < 0.15 on the final pass).

## Findings — initial (Pass 1) vs. final (Pass 3)

| Finding | Severity | Description | Initial disposition | Final status (Pass 3) |
|---------|----------|--------------|----------------------|------------------------|
| F1 | MEDIUM (test-quality) | `init.rs`'s `list_boards` scope-hint call site had no CI-running test — only reachable via the keyring-gated `#[ignore]`d integration test | **FIXED** (FIX-F5-001) — new CI-running unit test pins the init.rs scope string through the shared helper | RESOLVED (test added and confirmed genuine by Pass 2); one narrow residual accepted (see deferrals) |
| F2 | MEDIUM (test-quality) | Post-refresh double-fault classification wiring in `client.rs` (`578a7848`'s fix) covered only by `#[ignore]`d keyring tests — no CI-running coverage | **DEFERRED** — structural keyring limitation, no OS-keychain test seam exists to exercise it under CI | Still open — justified deferral, tracked as standing item |
| F3 | LOW (convention/fragility) | Agile scope-hint downcast (`rewrite_agile_scope_error` and 2 sites in `issue/list.rs`) inspected only the top of the `anyhow` error chain — a `.context()`-wrapped `InsufficientScope` would be missed | **FIXED** (FIX-F5-001) — new chain-aware `is_insufficient_scope_error()` helper in `board.rs`, walking the whole chain via `err.chain().find_map(...)`; applied at all 3 Agile call sites + guard comments on the 6 underlying Agile API fns | RESOLVED — confirmed genuinely load-bearing by Pass 2 (test wraps `InsufficientScope` in `.context()`, fails against old top-level-only downcast, passes against the fix) |
| F4 | COSMETIC | Discarded `NotAuthenticated` allocation on a dead branch | **DEFERRED** — cosmetic, no behavioral or test impact | Still open — note-only, non-blocking |
| (process-gap) | — | `DEFAULT_OAUTH_SCOPES` → Atlassian Developer Console release-gate step has no automated enforcement (human must remember to add the 8 new scopes before release) | **DEFERRED** — already tracked as a hard release-gate blocking issue | Already tracked (`CYCLE-008-CONSOLE-SCOPE-RELEASE-GATE`); confirmed unchanged, still OPEN/PENDING |

## FIX-F5-001 resolution

PR **#844** (`fix/cycle8-f5-001-scope-hint-robustness`, squash-merged to `develop`
@ `fc608cd3`) bundled the F3 + F1 fixes:

- `src/cli/board.rs`: new `is_insufficient_scope_error(&anyhow::Error) -> bool`
  helper, chain-aware via `err.chain().find_map(|c| c.downcast_ref::<JrError>())`.
- All 3 Agile scope-hint call sites (`rewrite_agile_scope_error` in `board.rs`;
  `issue/list.rs`'s sprint-list and board-config sites) switched to the helper.
- Guard comments added at the 6 underlying Agile API functions
  (`list_boards`/`get_board_config` in `api/jira/boards.rs`;
  `list_sprints`/`get_sprint_issues`/`add_issues_to_sprint`/`move_issues_to_backlog`
  in `api/jira/sprints.rs`) plus the `init.rs` call site, documenting that they
  return `InsufficientScope` raw (no `.context()`), so the chain-aware helper is
  currently a robustness/future-proofing change, not a behavior change today.
- New unit tests: `test_rewrite_agile_scope_error_fires_through_context_wrapped_chain`
  (genuine — fails against the pre-fix top-level-only downcast) and
  `test_rewrite_agile_scope_error_fires_for_init_list_boards_scope_string`
  (pins the init.rs scope string via the shared helper, closing part of F1's
  coverage gap).
- Fresh-eyes `pr-reviewer` review: **APPROVE**, 0 blocking findings, 2 non-blocking
  nits (documented in `code-delivery/FIX-F5-001-cycle8-scope-hint/pr-review.md`).
  Build/lint clean (`cargo test --lib board::tests` 9/9 pass, `cargo clippy
  --all-targets` clean, `cargo fmt --check` clean).
- Behavior confirmed byte-identical: all 6 Agile fns return `InsufficientScope`
  raw via `?` with no `.context()` today, so it always sat at chain-top before
  the fix too — this closes a **latent** fragility, not an active bug.

**Delivery path:** worktree → implement → push → PR #844 opened → CI green →
fresh-eyes `pr-reviewer` APPROVE → human manual merge @ `fc608cd3` (same
self-approval-structural-gap admin-bypass pattern as every other cycle-008 PR;
see `CYCLE-008-SELF-APPROVAL-STRUCTURAL-GAP`) → worktree/branch cleanup.

## Deferrals (justified, not blocking F5 convergence)

| ID | Finding | Severity | Justification |
|----|---------|----------|----------------|
| `CYCLE-008-F5-KEYRING-WIRING-COVERAGE` | F2 | MEDIUM (test-quality) | Post-refresh double-fault classification wiring (`client.rs`, landed `578a7848`) has no CI-running test coverage — only exercised by `#[ignore]`d keyring-gated integration tests (Linux CI may lack secret-service, macOS prompts on novel service names; same structural limitation documented for every other keyring-dependent code path in this repo). No OS-keychain test seam exists that would let this run unattended in CI. Target: a future test-infrastructure investment (a mockable keyring seam), not a cycle-008 fix. |
| `CYCLE-008-F5-INIT-MAPERR-MUTANT-RESIDUAL` | F1 residual | LOW (mutation-testing residual) | Even after FIX-F5-001's new init.rs scope-string test, a mutant deleting `init.rs`'s own `.map_err` wiring (as opposed to the shared `is_insufficient_scope_error` helper itself, which the new tests do cover) still survives CI — the new test pins the *string content* of the rewritten hint but does not independently prove the `.map_err` call site is reached only through the intended error path. Accepted per the FIX-F5-001 story spec, which scoped coverage to the shared helper + string pin, not full mutation-kill on every call site. |
| F4-cosmetic | F4 | COSMETIC | Discarded `NotAuthenticated` allocation on a dead branch. Note-only — no behavioral, performance, or test impact. Not tracked as a standing item ID; recorded here for completeness. |
| `CYCLE-008-CONSOLE-SCOPE-RELEASE-GATE` | (process-gap, Pass 1) | RELEASE-GATE | Already tracked (opened at F2 approval, 2026-09-17). Confirmed still OPEN/PENDING, unaffected by F5. Hard human-owned pre-release blocker, does not block F5/F6/F7 pipeline work. |
| `CYCLE-008-ENV-RESTORE-NON-RAII` | (carried from S5, not an F5 finding) | LOW | Already tracked (recorded at S5 merge, 2026-09-18). Confirmed still present, unaffected by F5's scope (F5 reviewed the whole delta including S5's test, and did not surface this as a new/distinct finding — it is the same known non-RAII env-restore pattern). |
| `CYCLE-008-WORKTREE-NAME-VS-STORYID` | (carried from S5, not an F5 finding) | LOW | Already tracked (recorded at S5 merge, 2026-09-18). Confirmed still present, unaffected by F5's scope. |

## Secondary review-tier pass

**NOT run.** Per the F5 skill's optional/additive secondary review tier
(code-reviewer + security-reviewer on top of the primary adversary-convergence
loop): the delta was thoroughly cleared via primary adversary convergence (3
clean passes, novelty decayed to 0.10, well below the 0.15 threshold), and the
delta itself is narrow (OAuth scope/routing/error-classification fixes plus one
robustness fix) with no new attack surface, no new dependencies, and no new
user-facing I/O paths. Skipped as genuinely optional/additive for this cycle,
not as a shortcut around a required gate.

## Evidence

- `code-delivery/FIX-F5-001-cycle8-scope-hint/pr-review.md` — fresh-eyes
  `pr-reviewer` review of PR #844 (FIX-F5-001), APPROVE verdict, includes the
  Pass-2-equivalent independent confirmation that F3's fix is genuine
  (mutation-style: temporarily broke the routing/downcast logic, confirmed the
  new test catches it, reverted).
- PR #844: https://github.com/Zious11/jira-cli/pull/844 (`fix/cycle8-f5-001-scope-hint-robustness`, merged squash @ `fc608cd3`).
- Per-pass adversary transcripts were not separately persisted as standalone
  artifact files this burst (unlike cycle-013's `pass-01.md`/`pass-02.md`/
  `pass-03.md` precedent) — Pass 1's findings (F1-F4 + process-gap) and Pass
  3's clean-verdict rationale are captured in full in this summary and in the
  Decisions/burst-log narrative (`cycles/cycle-008/burst-log.md`). No
  CRIT/HIGH/MED finding from any pass is undocumented.

## Next

Phase F6 targeted hardening — formal verification / fuzz / mutation testing
scoped to the cycle-008 delta (base `0793b9c5` → `fc608cd3`), plus full-tree
regression and security scans. `CYCLE-008-CONSOLE-SCOPE-RELEASE-GATE` remains
OPEN and human-owned; it does not block F6/F7 pipeline work, only a release
that ships cycle-008 content.
