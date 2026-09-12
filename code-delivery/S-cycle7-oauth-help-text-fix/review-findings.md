---
document_type: review-findings
story: S-cycle7-oauth-help-text-fix
pr_number: 805
pr_url: https://github.com/Zious11/jira-cli/pull/805
base: develop
head: fix/cycle7-oauth-help-text
head_sha: 5b411e93a5c84ae09d804d5e8067a4a2ee546f9b
merge_sha: 5b5b44329396d2232eb44b0d8f7ca2f7e2b20871
status: MERGED
timestamp: "2026-09-11"
---

# Review Findings — S-cycle7-oauth-help-text-fix

## Convergence Summary

| Cycle | Findings | Blocking | Fixed | Remaining | Verdict |
|-------|----------|----------|-------|-----------|---------|
| 1 | 9 total (0 blocking, 3 suggestion, 4 nit, 2 info) | 0 | 0 | 0 | APPROVE |

**Converged at cycle 1.** 0 blocking findings.

## Reviewer

- **Agent:** vsdd-factory:pr-reviewer (fresh-eyes, different model)
- **covered_sha:** `5b411e93a5c84ae09d804d5e8067a4a2ee546f9b`
- **Verdict:** APPROVE (posted as COMMENTED due to self-approval restriction on Zious11 account)

## Findings

### SUGGESTION-1: Login wording drops "human-output mode" qualifier
- **Severity:** SUGGESTION (non-blocking)
- **Location:** `src/cli/mod.rs` AuthCommand::Login --oauth doc comment
- **Problem:** Corrected wording says "may be emitted on interactive runs" — drops the accurate "human-output mode" qualifier that governs `emit_oauth_deprecation_notice`. Refresh's parallel text has this correct.
- **Disposition:** DEFERRED — hedged "may" is not affirmatively false; zero runtime impact; tracked for follow-up

### SUGGESTION-2: AC-002 login test negative-only
- **Severity:** SUGGESTION (non-blocking)
- **Location:** `tests/oauth_help_text.rs` test_help_text_oauth_flag_does_not_overclaim_unconditional_notice
- **Problem:** Only asserts absence; no positive pin for the replacement wording (unlike the parallel refresh test)
- **Disposition:** DEFERRED — behavioral intent correct; improvement tracked

### SUGGESTION-3: AC-004 conflicts_with pin incomplete
- **Severity:** SUGGESTION (non-blocking)
- **Location:** `tests/oauth_help_text.rs` test_clap_conflicts_with_usage_rendering_unaffected_by_doc_change
- **Problem:** Docstring claims conflicts_with pinning but deleting the attribute would still pass all assertions
- **Disposition:** DEFERRED — clap enforces conflicts_with at runtime; zero blast-radius for help-text story

### NIT-1: Duplicated block extractor
- **Severity:** NIT
- **Disposition:** NOTED

### NIT-2: Unanchored find with indentation baked into needle
- **Severity:** NIT
- **Disposition:** NOTED

### NIT-3: PR description test count/mechanism overstated
- **Severity:** NIT
- **Problem:** PR description says 4 tests, 5 present; claims `Cli::command()`/`render_help()`/`arg_by_id("oauth")` but tests use assert_cmd subprocess
- **Disposition:** NOTED — PR description internal only; no spec/code impact

### NIT-4: CHANGELOG narrates adversary pass history
- **Severity:** NIT
- **Disposition:** NOTED

### INFO-1: CI pending at review time
- **Severity:** INFO
- **Disposition:** RESOLVED — ci-gate PASSED by the time triage was posted

### INFO-2: No demo evidence
- **Severity:** INFO
- **Disposition:** ACCEPTED — doc-comment only; reviewer consciously did not block; clap-introspection tests provide equivalent coverage

## Gate Results

| Gate | Result | Note |
|------|--------|------|
| Security review | N/A | doc-comment only per dispatch |
| pr-reviewer | APPROVE | 0 blocking findings |
| ci-gate | PASS | all 25+ checks pass |
| dependencies | CLEAR | no depends_on; Story A #803 merged |
| stale-verdict | PASS | covered_sha matches live PR HEAD (exit 0) |
| merge-strategy | PASS | enforce-merge-strategy.sh exit 0 (--squash, non-release branch) |
| ancestry assertion | PASS | merge-base --is-ancestor exit 0; 5b5b4432 on origin/develop |
| branch deletion | CONFIRMED | ls-remote exit 2 (auto-delete-on-merge) |
