# Review Findings — issue-110-pr2

**PR:** #348
**Branch:** feat/issue-110-pr2-jql-dryrun-multifield
**HEAD at documentation time:** a60c4ce
**Status:** Open, 8/8 CI green, 27/27 Copilot threads resolved

---

## Convergence Summary

| Review Phase | Cycle | Findings | Blocking | Fixed | Remaining |
|--------------|-------|----------|----------|-------|-----------|
| Cross-PR audit (pre-F5) | — | 5 must-fix + 1 follow-up | 5 | 5 | 0 |
| F5 adversarial pass 1 | 1 | 12 | 2 | 6 | 0 (later passes) |
| F5 adversarial pass 2 | 2 | 5 | 0 | 3 | 0 |
| F5 adversarial pass 3 | 3 | 0 (CLEAN) | 0 | — | — |
| F5 adversarial pass 4 | 4 | 0 (CLEAN, 1 doc obs) | 0 | 1 doc fix | — |
| F5 adversarial pass 5 | 5 | 0 (CLEAN) | 0 | — | — |
| F6 security | — | 1 Suggestion | 0 | 0 (folded → #334) | 0 |
| F7 consistency | — | 1 observation | 0 | 0 (→ #347) | 0 |
| Copilot rounds 1-10 | 10 | 27 inline + 8 summaries | 0 | 27 (18 fix commits) | 0 |

---

## Cross-PR Audit (Pre-F5) — Commits bf911f1..04413a4

Surfaced by reviewing PR #323 (develop version bump), PR #324 (CLAUDE.md gotchas), and the
PR2 branch before opening PR #348.

| ID | Severity | Finding | Commit Fixed |
|----|----------|---------|--------------|
| C-1 | MUST-FIX | Multi-key edits allowed with unsupported flags (--no-parent, etc.) | 8161256 |
| C-2 | MUST-FIX | `await_bulk_task` silently returned Ok for FAILED/CANCELLED/DEAD tasks; no `failureReason` surfaced | 56d754d + 04413a4 |
| C-3 | MUST-FIX | Dry-run always rendered table; should branch on `--output json` | 823d7db |
| I-2 | MUST-FIX | JQL returning 0 matches was silently success instead of user error | 30b5d5b |
| I-6 | MUST-FIX | `JQL_CONFIRM_THRESHOLD` was a magic inline literal; should be module-level const | bf911f1 |
| follow-up | FIX | `failureReason` needed surfacing from the audit above | 04413a4 |

---

## F5 Adversarial Pass 1 — 12 Findings (commit 2924e49..6915cc3)

See full record: `cycles/cycle-001/adversarial-reviews/issue-110-pr2/pass-01-findings.md`

| ID | Severity | Finding | Commit Fixed |
|----|----------|---------|--------------|
| ADV-P5-PR2-001 | CONCERN | `--jql ""` (empty string) not validated; would send empty search to Jira | 6915cc3 |
| ADV-P5-PR2-002 | CONCERN | `editedFieldsInput` used `issuetype` but `selectedActions` used `issueType` — casing mismatch | c9b5bb0 |
| ADV-P5-PR2-003 | SHOULD | `--dry-run` without any field flags produces confusing "no changes" output instead of error | a0b03af |
| ADV-P5-PR2-004 | SHOULD | `--max` overrun message said "50" not N (hardcoded default leaked into error text) | c552930 |
| ADV-P5-PR2-005 | SHOULD | `selectedActions` field missing from bulk payload; Atlassian spec requires it | d2c0b1e |
| ADV-P5-PR2-006 | SHOULD | Field-change presence check placed after JQL search — wasted API call on invalid input | a0a24b0 |
| ADV-P5-PR2-007 | NIT | `StatusCategory.name` in test fixture made optional with default; better to fix fixture | 2924e49 |
| ADV-P5-PR2-008 | NIT | Single-match JQL path (routes to PUT, not bulk) undocumented | 05a2d2f |
| ADV-P5-PR2-009 | NIT | `selectedActions` assertion missing from PR1 regression-pin tests | 9c90231 |
| ADV-P5-PR2-010 | PROCESS-GAP | `body_string_contains` matchers used instead of structural matchers — deferred-pending-sandbox pattern not documented at usage site | Filed as #331 |
| ADV-P5-PR2-011 | PROCESS-GAP | `failureReason` path not tested in PR1 tests (audit follow-up gap) | already fixed in pre-F5 |
| ADV-P5-PR2-012 | CONCERN | `--max` field-change guard check after JQL (partially overlapped F6 below) | a0a24b0 |

---

## F5 Adversarial Pass 2 — 5 Findings (commits a0a24b0..05a2d2f)

See full record: `cycles/cycle-001/adversarial-reviews/issue-110-pr2/pass-02-findings.md`

| ID | Severity | Finding | Commit Fixed |
|----|----------|---------|--------------|
| ADV-P5-PR2-P2-001 | CONCERN | Field-change guard still slightly mis-ordered — dry-run block ran check after JQL call | a0a24b0 (complete fix) |
| ADV-P5-PR2-P2-002 | SHOULD | Single-match JQL comment missing (code routes to PUT but comment said bulk) | 05a2d2f |
| ADV-P5-PR2-P2-003 | SHOULD | `selectedActions` assertion existed in new tests but not PR1 regression tests | 9c90231 |
| ADV-P5-PR2-P2-004 | NIT | rustfmt violation on JQL mock line in test | 7a39849 |
| ADV-P5-PR2-P2-005 | NIT | CLAUDE.md --dry-run NFR note referenced spec language, not implementation behavior | 1ab056e |

---

## F5 Adversarial Passes 3/4/5 — CLEAN

See records in `cycles/cycle-001/adversarial-reviews/issue-110-pr2/pass-03-clean.md`,
`pass-04-clean.md`, `pass-05-clean.md`. Three consecutive clean passes = VSDD convergence.

---

## F6 Security Review

See full record: `cycles/cycle-001/security-reviews/issue-110-pr2.md`

| ID | Severity | Category | Finding | Resolution |
|----|----------|----------|---------|------------|
| SEC-PR2-001 | Suggestion | CWE-117 log injection | `failureReason` from Atlassian response logged/printed without sanitization | Folded into #334 |
| SEC-PR2-002 | PASS | Input validation | `task_id` URL-encoded via `urlencoding::encode` | Mitigated |
| SEC-PR2-003 | PASS | Input validation | JQL passed as query parameter, not string-interpolated into URL | Mitigated |
| SEC-PR2-004 | PASS | DoS | 5min poll timeout + exponential backoff preserved from PR1 | Mitigated |
| SEC-PR2-005 | PASS | Access control | All new endpoints go through `JiraClient::send` (401/429 handling) | Pass |

**Verdict: F6 SECURITY PASS.**

---

## F7 Consistency Review

See full record: `cycles/cycle-001/consistency-reviews/issue-110-pr2.md`

| Axis | Verdict | Notes |
|------|---------|-------|
| Test naming convention | PASS-WITH-OBS | 1 test uses legacy naming → filed as #347 |
| Output channel discipline | PASS | Dry-run stdout/stderr split correct |
| Error handling convention | PASS | JrError::UserError (exit 64) used for all user-input errors |
| BC traceability | PASS | All ACs traced to test names; all tests pass |
| CLAUDE.md alignment | PASS | --dry-run NFR note updated at 1ab056e |

**Verdict: F7 PASS-WITH-FOLLOWUPS.** #347 filed.

---

## Copilot Review (10 Rounds)

See full record: `cycles/cycle-001/copilot-rounds/issue-110-pr2.md`

| Round | Inline Comments | Key Findings | Fix Commits |
|-------|----------------|--------------|-------------|
| 1 | 4 | --team/description/markdown missing from dry-run; "(default 50)" overrun message misleading; --max 0 should error; description truncation UTF-8 unsafe | 4 commits |
| 2 | 4 | CANCEL_REQUESTED doc; dialoguer errors silent; borrow optimization; --markdown missing field guard | 3 commits |
| 3 | 2 | Duplicate "no fields" check; "no fields" should be JrError::UserError | 2 commits |
| 4 | 2 | No new actionable findings (pass-4 doc fix at 1ab056e) | 0 fix commits |
| 5 | 2 | DATA-LOSS BUG: `--label add:foo --summary X` silently drops --summary (dispatch branches check `!labels.is_empty()` first without checking concurrent non-label fields) | 1 fix commit (d9423df) |
| 6 | 3 | --label rejection should precede JQL search; schema comments overstated; coalesce shape comment | 3 commits |
| 7 | 5 | JQL search comment said GET/should be POST; --max ceiling should be clap-level not handler-level; stale "no fields" comment | 3 commits |
| 8 | 1 | --max with positional keys (no --jql) should error at clap parse time | 1 commit |
| 9 | 2 | --jql makes keys optional (help text implied required); --label conflict guard should cover all non-label flags | 2 commits |
| 10 | 2 | Stale "requires=jql" clap claim (enforcement is handler-level); evidence-report keychain prerequisite unclear | 2 commits |

**Totals:** 27 inline comments, 10 rounds, 18 fix commits, 0 unresolved threads.
