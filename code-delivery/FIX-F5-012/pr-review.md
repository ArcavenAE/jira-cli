# PR #651 — Fresh-Eyes Review (FIX-F5-012 / F5-R9-001)

- **Branch:** `test/f5-r9-step2-429-pin` → `develop`
- **Commit:** 33d56ca0 (`test(issue): pin EC-3.9.006-7 step-2 429 no-retry asymmetry …`)
- **Scope:** test-only, +174 lines, single new test in `tests/attachment_jsm.rs`. No production code modified.

## Verdict: PASS (APPROVE-equivalent, not posted)

No blocking findings. No suggestions or nits worth churning. See "GitHub posting" note below for why no formal `gh pr review` verdict was posted.

## What I verified

- **Passes green against current code** — correct for a regression pin of already-correct behavior. `cargo test --test attachment_jsm test_ec_3_9_006_7_step2_429_no_retry_exactly_one_post` → ok.
- **`cargo clippy --test attachment_jsm`** — warning-free.
- **`cargo fmt --check`** on the file — clean.
- **Behavior actually pinned** — confirmed `post_request_attachment` (`src/api/jsm/attachments.rs:292`) is a single `.post().send()` with no retry loop; a 429 lands in the `_ if status.is_client_error()` arm → `JrError::UserError` + retry hint → exit 64. Exactly-one-POST is therefore the precise invariant.

## Checklist findings

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence | PASS — single test, matches PR intent (EC-3.9.006-7 pin) |
| 2 | Description accuracy | PASS — PR body matches the diff |
| 3 | Test coverage | PASS — adds coverage; is itself the coverage artifact |
| 4 | Demo evidence | N/A — test-only PR, no user-facing AC |
| 5 | Commit quality | PASS — conventional `test(issue):` + FIX-F5-012 / F5-R9-001 IDs |
| 6 | Diff size | PASS — 174 lines, well under 500 |
| 7 | Missing changes | PASS — none; test matches described behavior |
| 8 | Dependency status | N/A |

## Detail

**Mock setup / two-step flow (CORRECT).** All hops mocked: step-0 issue GET, project-meta GET (`projectTypeKey: service_desk`), service-desk list (`projectId 93429` matches), step-1 `attachTemporaryFile` → 200, step-2 `request/{key}/attachment` → 429 with `Retry-After: 1`. Reaching exit 64 with the step-2 hint proves the flow ran end-to-end into step-2. No attachment-list GET is mocked, which is correct — `--public` without `--replace-existing` does not trigger the VP-576-005 list GET. Fixtures (`issue_get_response`, `jsm_project_response`, `service_desk_list_response`, `jr_cmd_with_xdg`) are reused from the file — no bespoke fixtures.

**`step2_count == 1` trip-wire (CORRECT and well-chosen).** The deliberate `Retry-After: 1` header is the right load-bearing detail: any future retry arm keyed on that header would sleep 1s and re-POST, pushing the count to 2 and tripping the assertion within the 10s command timeout. Assertions triangulate from three independent angles (exit 64, hint text, POST count) rather than restating one fact.

**Naming (acceptable).** `test_ec_3_9_006_7_step2_429_no_retry_exactly_one_post` leads with the EC id rather than a verb — a soft deviation from `test_<verb>_<subject>_<outcome>`, but consistent with the file's established BC/EC-anchored pattern (`test_bc_3_9_006_…`, `test_f5_r1_006_…`). Not worth changing.

**No other material issues.** Minor style: assertion (3) uses exact path match while assertion (4) uses `.contains("attachTemporaryFile")` — harmless, both resolve unambiguously. The 429 body field `errorMessage` is not asserted; production captures it as an unparsed string, so no coupling risk.

## GitHub posting

No `gh pr review` verdict was posted — **intentional**. The launching agent's task instruction explicitly stated "No `gh pr review --approve` — DEC-173 prohibits agent approval." The verdict is PASS, so `--request-changes` would also be a false verdict. This PASS must be actioned by the orchestrator/human. This is an F5 adversarial fresh-eyes review within phase-5 refinement, not a code-delivery posting flow.
