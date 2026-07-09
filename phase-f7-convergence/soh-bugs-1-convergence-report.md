---
document_type: f7-convergence-report
bundle: SOH-BUGS-1
status: CONVERGED
verdict: AWAITING-HUMAN-CLOSURE
timestamp: 2026-07-09T23:00:00Z
producer: state-manager
---

# SOH-BUGS-1 F7-Lite Convergence Report

**Bundle:** SOH-BUGS-1 (issues #589 + #590/#582)
**Stories:** S-SOH-589-1 (story 105, standard bug-fix) + S-SOH-590-1 (story 104, quick-dev)
**Verdict:** CONVERGED — AWAITING HUMAN BUNDLE-CLOSURE GATE
**Date:** 2026-07-09

---

## Dimension Summary

| Dimension | Result | Evidence |
|-----------|--------|----------|
| Spec | PASS | Script trio exit 0; 613 BCs; 313 citations; EC-3.4.016-8 substrings verified in merged src |
| Tests | PASS | 2016 passed / 0 failed / 93 ignored; AC test names resolve in merged branch |
| Implementation | PASS | PRs #597 @ 4f3960e0, #601 @ 081187ae, fix-PR #602 @ bf3b3382; develop lint-green --all-targets |
| Verification | PASS | Step 4.5 STRICT 7-pass window p5/p6/p7; CI mutation gate PASS on both PRs |
| Holdout | PASS | Mean 1.00, 6/6 scenarios, min score 1.0, wire-level evidence |
| Consistency | PASS | CONSISTENT; 3 non-blocking bookkeeping gaps fixed this burst (G-1/G-2/G-3) |
| Documentation | PASS | CHANGELOG entries present for both issues; CLAUDE.md carries no contradictions |

**Overall: 7/7 PASS — CONVERGED**

---

## Spec Dimension Detail

- `scripts/check-spec-counts.sh` exit 0 (613 BCs, verified)
- `scripts/check-bc-cumulative-counts.sh` exit 0 (all 8 surfaces agree: 613)
- `scripts/check-bc-citation-symbols.sh` exit 0 (313 Trace/Source citations resolve)
- EC-3.4.016-8 load-bearing substrings (`"no machine-readable id"`, `"--field"`) present in merged `src/cli/issue/field_resolve.rs` (PR #601 @ 081187ae)
- BC-X.1.011 source column corrected to S-SOH-590 this burst (G-2)

## Tests Dimension Detail

- Full suite on develop @ bf3b3382: **2016 passed / 0 failed / 93 ignored**
- AC test names for S-SOH-589-1 resolve: `test_bc_3_4_015_editmeta_idless_allowed_values_on_non_targeted_field_succeeds`, `test_bc_3_4_016_option_idless_allowed_value_exits_64_with_actionable_message`, `test_bc_3_4_015_field_dry_run_idless_nontargeted_allowedvalues_exits_0`, `test_allowed_value_without_id_deserializes_to_none`
- AC test names for S-SOH-590-1 resolve: `test_parse_api_method_uppercase_delete_dispatches_http_delete`, `test_parse_api_method_mixedcase_delete_dispatches_http_delete`, `test_parse_api_method_lowercase_delete_dispatches_http_delete`

## Implementation Dimension Detail

- **S-SOH-590-1 PR #597 @ 4f3960e0** (quick-dev; `ignore_case = true` on `-X`/`--method` clap arg; single-attribute, single-site)
- **S-SOH-589-1 PR #601 @ 081187ae** (standard; `AllowedValue.id: String` → `Option<String>`; 7 Option-aware call sites in `field_resolve.rs`)
- **fix-PR #602 @ bf3b3382** (reactive maintenance; Rust 1.97 lints: `useless_borrows_in_formatting` ×2 + `question_mark` ×1; human-approved)
- `cargo clippy --all-targets -- -D warnings` on develop: zero warnings
- `cargo test`: 2016/0/93

## Verification Dimension Detail

- **S-SOH-589-1 Step 4.5 STRICT trajectory:** 3→4→0→1→0→0→0 (7 passes / 4 fix rounds; window p5/p6/p7 CLEAN×3)
- **CI mutation gate:** PASS on both PRs (#597 and #601); kill-rate within policy bounds
- Red Gate evidence in `cycles/cycle-001/S-SOH-589-1/implementation/red-gate-log.md` and `cycles/cycle-001/S-SOH-590-1/implementation/red-gate-log.md`
- Step 4.5 detail: `cycles/cycle-001/S-SOH-589-1/implementation/step-4-5-convergence.md`

## Holdout Dimension Detail

- **Score:** mean 1.00, 6/6 scenarios, min 1.0
- **Gate:** PASS (all scenarios at full score)
- **Wire-level evidence:** holdout-evaluator ran against merged develop; all AC behavioral contracts exercised at HTTP boundary
- **Scenario coverage:** AllowedValue id-absent deserialization (non-targeted field, targeted field, dry-run), GDPR accountId shape, case-insensitive method dispatch (uppercase, mixed-case, lowercase regression)

## Consistency Dimension Detail

- **Consistency audit verdict:** CONSISTENT
- **3 non-blocking bookkeeping gaps fixed this burst:**
  - G-1: `stories/S-SOH-589-1.md` and `stories/S-SOH-590-1.md` frontmatter `status: approved` → `status: completed` (match sprint-state / STORY-INDEX)
  - G-2: `specs/prd/BC-INDEX.md` BC-X.1.011 row source column `— (S-SOH-589)` → `— (S-SOH-590)` (correct story attribution; sanctioned shell edit, DRIFT-002 unblocked; cumulative-counts exit 0 post-fix)
  - G-3: `cycles/cycle-001/S-SOH-590-1/implementation/red-gate-log.md` stale test name `test_parse_api_method_mixed_case_dispatches_http_delete` → `test_parse_api_method_mixedcase_delete_dispatches_http_delete` (3 occurrences, all corrected)

## Documentation Dimension Detail

- `CHANGELOG.md` [Unreleased] Fixed section contains both entries:
  - #589: `AllowedValue.id` changed to `Option<String>` (id-absent editmeta crash fix)
  - #590/#582: `jr api -X`/`--method` case-insensitive accept
- CLAUDE.md carries no contradictions introduced by this bundle (verified by consistency-validator)

---

## Cycle-Closing Checklist S-7.02

Process-gap findings from this bundle all have Drift Items entries with current dispositions:

| Drift Item | Disposition |
|------------|-------------|
| STATE-MANAGER-MONOLITHIC-WRITE-STALL | OPEN — engine-side fix candidate |
| PR-MANAGER-HOOK-VS-DEC-128-CONFLICT | OPEN — engine-side fix candidate |
| CLAUDE-MD-CLIPPY-ALL-TARGETS-DRIFT | OPEN — pipeline doc fix candidate |
| TD-031-FULL-CLEANUP | OPEN — follow-up story candidate |
| BC-INDEX-TD031-EDIT-LOCKOUT | MITIGATED — counts synced; full cleanup open |

**S-7.02 checklist:** SATISFIED — zero untracked process-gap findings.

---

## Release Routing

Issues #589, #590, #582 close at next release (develop → main PR). No blocking items.
Secondary candidates: dependabot PRs #595/#591 (DEC-133 soak check); standalone PRs #574/#573 (CHANGES_REQUESTED).
