# Mutation Report — SOH-ATTACHMENTS-1 (jr)

**Bundle:** SOH-ATTACHMENTS-1
**Report Date:** 2026-07-23
**Tool:** cargo-mutants 27.0.0
**Policy doc:** `docs/specs/cargo-mutants-policy.md`

---

## Scope Classification

| Story | tdd_mode | mutation_testing_required | Scope |
|-------|----------|--------------------------|-------|
| S-576-1 | strict | true | diff-scoped PR-time |
| S-576-2 | strict | true | diff-scoped PR-time |
| S-576-3 | strict | true | diff-scoped PR-time |
| S-576-4 | strict | true | diff-scoped PR-time |
| S-576-5 | strict | true | diff-scoped PR-time |
| FIX-576-DL | strict | true | diff-scoped PR-time |
| S-576-6 | **facade** | false | wave-gate facade control |

---

## Wave-Gate Facade Control (S-576-6)

**Execution:** `cargo mutants --in-diff` over S-576-6 diff (commits 7298c035..9da03d5b) per repo policy (`docs/specs/cargo-mutants-policy.md`).

**Result:** `No mutants to filter` — **0 mutants generated**.

**Reason:** The diff is exclusively `tests/e2e_live.rs` additions (4 new test functions + supporting helpers) plus `docs/` and `CHANGELOG.md` updates. No production `src/` code was modified. The `--in-diff` filter produces 0 mutants when there is no diff-covered production code. This is the correct and expected result for a facade story.

**Kill-rate floor:** The 80% kill-rate floor is vacuously satisfied (0/0 = vacuous pass). No undispositioned survivors.

---

## PR-Time Diff-Scope Results (Strict Stories)

All strict stories ran `cargo mutants --in-diff` at their respective PR-time diffs. Results were verified before each PR merge.

| Story | PR | Kill Rate | Caught | Total | Missed-Equivalent | Disposition |
|-------|-----|-----------|--------|-------|-------------------|-------------|
| S-576-1 | #630 | **95%** | 60 | 63 | 3 unviable | Passed ≥80% floor |
| S-576-2 | #631 | **94%** | — | — | 4 missed-equivalent (481:28, 481:47, 602:32 always-true, 721:24 always-true) | Passed ≥80% floor; equivalent survivors documented in PR |
| S-576-3 | #635 | **97%** | — | — | 0 | Passed ≥80% floor |
| S-576-4 | #638 | **97%** | — | — | 0 | Passed ≥80% floor |
| S-576-5 | #640 | **94%** | 53 | 56 | 3 equivalent `sleep(0)` survivors | Passed ≥80% floor; 3 survivors documented at commit c03868b3, Disposition B |
| FIX-576-DL | #642 | **100%** | 9 | 9 | 0 | Passed ≥80% floor |

All stories ≥80% kill-rate floor. No undispositioned survivors. S-576-5 `sleep(0)` survivors are recorded as Disposition B (equivalent mutants; behavioral tests would take ~0ms either way; no feasible kill test).

---

## Note: Whole-Crate Scan Not Performed

`cargo mutants -p jr` (whole-crate) was NOT run at wave gate. This would:

1. Exceed the 60-minute wave budget by a large margin
2. Contradict the repo diff-scope policy (`docs/specs/cargo-mutants-policy.md`)

The diff-scoped PR-time gates on each strict story provide the required mutation coverage at the right granularity.

---

## Summary

- Facade story S-576-6: 0 mutants (test-only-diff path), floor vacuously satisfied
- All 6 strict stories passed ≥80% kill-rate floor at PR-time
- No undispositioned survivors across any story
- Compensating E2E coverage: `tests/e2e_live.rs` (S-576-6) provides live-Jira round-trip validation of the full attachment surface; e2e run 30041659024 97/97 GREEN
