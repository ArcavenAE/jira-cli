# Review Findings — S-E2E-3

PR: #435 (`feat/e2e-m1-assertion-depth` → `test/e2e-enhancements`)
Story: S-E2E-3 — M1 Shared Helpers + Assertion Depth

## Convergence Table

| Cycle | Findings | Blocking | Fixed | Remaining |
|-------|----------|----------|-------|-----------|
| 1     | 2        | 0        | 0     | 2 (nits)  |

## Cycle 1 Findings

### Finding 1 — NITS-001

**Severity:** nit
**Category:** description (CLAUDE.md documentation gap)
**Finding:** `JR_E2E_ISSUE_TYPE` env var is introduced in the diff (the `issue_type()` helper reads it) but is NOT listed in CLAUDE.md's E2E env vars table alongside `JR_RUN_E2E`, `JR_E2E_BASE_URL`, etc. CLAUDE.md explicitly requires: "When adding a new `JR_*` test-seam env var: grep `CLAUDE.md` for existing `JR_*` entries and add a parallel line in the SAME commit as the code change" (codified doc-fallout pattern from #335/#357). `JR_E2E_POLL_MAX_ATTEMPTS` and `JR_E2E_POLL_INITIAL_MS` ARE documented (correctly). `JR_E2E_ISSUE_TYPE` is not.
**Route:** pr-manager — CLAUDE.md update (description fix, not code fix)
**Blocking?** No — the env var has a sane default ("Task") and works without being in CLAUDE.md; the gap is documentation hygiene, not a functional regression.
**Status:** Open

### Finding 2 — NITS-002

**Severity:** nit
**Category:** coverage (test docstring gap)
**Finding:** `test_e2e_issue_view_returns_key_field` was deepened by PR description (it now calls `poll_view` + `v.get("key").is_some()`), but the test's rustdoc comment still says only `"issue view JSON must contain a 'key' field"` without mentioning that `assert_issue_shape` was not applied here (unlike the write-flow which does call it). This is consistent and correct — the test uses `poll_view` which already returns a full issue shape, and the existing assertion is sufficient — but the comment doesn't note that the shape guarantee comes from `poll_view`'s contract, not from an explicit `assert_issue_shape` call. A reader could wonder if this test was simply missed.
**Route:** pr-manager — PR description note (no code change needed; the implementation is correct)
**Blocking?** No — this is a readability/documentation nit. The implementation is correct.
**Status:** Open

## Triage Routing Table

| ID       | Severity | Category    | Route      | Agent          | Status |
|----------|----------|-------------|------------|----------------|--------|
| NITS-001 | nit      | description | pr-manager | CLAUDE.md edit | Open   |
| NITS-002 | nit      | description | pr-manager | PR note only   | Open   |

## Verdict

**APPROVE** — zero blocking findings.

The implementation is correct, well-structured, and follows spec §3/§4 exactly:
- `poll_jql` modes are correctly implemented (SkipOnEmpty vs FailOnShort).
- `poll_schedule` index alignment is safe (accessed only at `attempt-1` when `attempt < max_attempts`, schedule length is `max_attempts - 1`).
- All 12 deepened tests retain their gate guards.
- The 17 always-run unit tests are pure and do not require live Jira.
- `JR_E2E_POLL_MAX_ATTEMPTS` / `JR_E2E_POLL_INITIAL_MS` are documented in both CLAUDE.md and the file-level env table.
- No src/ changes — blast radius is zero.

The two nits (NITS-001 missing `JR_E2E_ISSUE_TYPE` in CLAUDE.md, NITS-002 minor docstring gap) are documentation-only and do not block merge. They should be resolved in a follow-up commit or the next story PR.
