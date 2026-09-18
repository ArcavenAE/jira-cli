# PR Review — #843

**Story:** S-cycle8-jsm-attachments-oauth-verification (BC-4.2.001, ADR-0026)
**Branch:** `fix/cycle8-jsm-attachments-oauth-verification` → `develop`
**Head SHA:** `da7fc4df8ef5c9e754565ca1f2cf26284aa694c5`
**Reviewer:** pr-reviewer (fresh-eyes PR-level check)
**Date:** 2026-09-18

## Verdict: COMMENTED

No blocking findings. COMMENTED is the honest ceiling: this PR is self-authored by
the same automation pipeline reviewing it, and the tool-layer classifier structurally
blocks self-approval merges (CYCLE-008-SELF-APPROVAL-STRUCTURAL-GAP). Final merge is
human-owned. I found nothing that justifies REQUEST_CHANGES.

## Scope Confirmed

- Verification-only story: **zero `src/` diff** — confirmed `git diff origin/develop...HEAD -- src/` = 0 lines.
- Full diff: `tests/attachment_jsm.rs` (+209, one new test) and `CHANGELOG.md` (+7).

## Verification Performed (not just diff-reading)

1. **Compiles & passes** — ran `cargo test --test attachment_jsm test_bc_4_2_001_jsm_attachment_upload_succeeds_end_to_end_under_oauth` in the existing worktree
   (`.worktrees/cycle8-s5-jsm-attachments-oauth-verification`): `ok, 1 passed`.
2. **Test is genuinely load-bearing, not a tautology** — temporarily mutated
   `post_request_attachment` in `src/api/jsm/attachments.rs` to route via
   `client.instance_url()` instead of `base_url()`, re-ran the test, and it FAILED as
   designed (`POST /rest/servicedeskapi/request/EJOAUTH-1/attachment must be hit exactly
   once against base_url; got 0`). Reverted immediately; worktree confirmed clean
   (`git status --porcelain` empty). This proves both the positive (`base_url == 1` per
   endpoint) and negative-control (`instance_url == 0`) assertions discriminate real
   routing regressions.
3. **Asserts exactly what the PR claims** — all four chain endpoints (GET project, GET
   servicedesk list, POST attachTemporaryFile, POST request-attachment) each hit
   `base_url` exactly once and `instance_url` zero times, using `base_url != instance_url`
   via `JiraClient::new_for_test_with_instance_url`. Mocks-on-both-servers technique is
   correct: success is guaranteed regardless of host, so the request-count assertions are
   the sole discriminator.
4. **Endpoint paths match real code** — verified `src/api/jsm/servicedesks.rs`
   (`resolve_service_desk_id` → `get_or_fetch_project_meta` → `list_service_desks`) and
   `src/api/jsm/attachments.rs` (`attach_temporary_file` / `post_request_attachment`).
   Chain is accurate; single-page `service_desk_list_response` (`isLastPage: true`) keeps
   the "exactly once" count valid.
5. **CHANGELOG accurate and correctly scoped** — narrowed to the upload path only, with
   the correct clarifying clause that download/delete use platform `/rest/api/3/attachment`
   endpoints (matches CLAUDE.md). Reflects the `da7fc4df` adversarial-Pass-1 narrowing.

## Findings

| # | Severity | Location | Status | Description |
|---|----------|----------|--------|-------------|
| 1 | LOW (non-blocking) | `tests/attachment_jsm.rs:5235` | Posted inline (`discussion_r4047408907`) | Manual `remove_var("JR_CACHE_DIR")` at test end is skipped on panic-unwind; a failing assertion could leak the env var to a future in-process test in this binary. Today nothing else in this file mutates `JR_CACHE_DIR` and it mirrors the existing `tests/project_meta.rs` pattern, so not a defect. A `Drop`-guard (`ComponentDropGuard`/`AttachmentDropGuard` idiom in CLAUDE.md) would make cleanup fire on both normal and panic paths. Suggestion only. |
| 2 | INFO (not posted) | `tests/attachment_jsm.rs` | N/A | Test exercises only `--public` (`public=true`); `--internal` (`public=false`) differs only in a body field, not routing — no routing-coverage gap. |

**Critical:** 0 · **High:** 0 · **Medium:** 0 · **Low:** 1 · **Info:** 1

## Conclusion

The verification-only premise holds, the new test does what the PR claims, and there are
no blocking defects. Ready for human merge.
