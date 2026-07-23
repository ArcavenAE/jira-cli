# PR Review — #640 (S-576-5): attachment upload `--public`/`--internal` JSM visibility

**Verdict: APPROVE (MERGE_READY)** — zero BLOCKING findings.
**Reviewer:** fresh-context PR reviewer (different model family), diff + public API surface only.

## What was reviewed

Full `gh pr diff 640`, PR description, story spec `S-576-5.md` (ACs + settled rulings),
and the five key sources: `src/api/jsm/attachments.rs`, `src/cli/issue/attachments.rs`,
`src/api/jsm/servicedesks.rs`, `src/cache.rs`, `src/api/jira/issues.rs`. Spot-checked the
discriminating tests in `tests/attachment_jsm.rs` (stale-heal, BC-3.9.006 error taxonomy,
two-step body matcher, BC-3.9.020 dry-run visibility, BC-3.9.007 best-effort echo) and the
e2e gating in `tests/e2e_live.rs`. Verified the `JrError` exit-code table.

## Checklist outcome

1. Diff coherence — PASS. All changes scoped to S-576-5 JSM attachment visibility.
2. Description accuracy — PASS. PR body matches the implemented two-step flow, guards, taxonomy.
3. Test coverage — PASS. 29 integration tests + unit test + 2 gated e2e; tests are discriminating
   (`body_partial_json`, `.expect(1)` call counts, `received_requests()` ordering assertions).
4. Demo evidence — Not verified by this reviewer (out of provided scope); defer to pr-manager gate.
5. Commit quality — PASS. Conventional format, story ID, `#576` reference.
6. Diff size — Large (5822/-88) but dominated by a 4291-line test file; production code is modest.
7. Missing changes — None found; all 8 BCs + VP-576-005 traced and implemented.
8. Dependency status — S-576-3 and S-576-4 merged; this PR closes #576.

## Findings (all non-blocking)

### [LOW] Step-2 lacks the 429 rate-limit retry that step-1 has
- `src/api/jsm/attachments.rs` (`post_request_attachment`, ~L568-587), category: error-handling.
- Step-1 (`attach_temporary_file`) retries HTTP 429 with `Retry-After` backoff. Step-2 uses a raw
  `reqwest_client().post()`; a 429 falls into `_ if status.is_client_error() => JrError::UserError`
  → exit 64, treating a transient rate-limit as a permanent usage error. Asymmetric with step-1 and
  with the rest of the codebase (429 → `ApiError`/exit 1). It IS literally spec-compliant with
  BC-3.9.006 ("other 4xx → 64") and the appended retry hint mitigates.
- Suggestion: special-case 429 in step-2 to `ApiError { status: 429 }` (exit 1) like step-1, or
  confirm 429→64 is intended in BC-3.9.006.

### [INFO] `--dry-run` requires `--replace-existing`; `--public --dry-run` alone is unreachable
- `src/cli/mod.rs` (`AttachmentSubcommand::Upload::dry_run` has `requires = "replace_existing"`),
  category: spec-fidelity.
- `jr issue attachment upload KEY FILE --public --dry-run` without `--replace-existing` exits 2
  (clap). The EC-3.9.020-7 visibility annotation is only reachable with `--replace-existing`.
  Inherited from S-576-3, not introduced here. Confirm intended.

### [INFO] `--internal` JSM dry-run carries no visibility annotation
- `src/cli/issue/attachments.rs` (~L1013), category: code-quality.
- For `--internal` on JSM, `public=false`, so `wouldUpload` has no marker — indistinguishable from a
  plain dry-run. Per spec only `--public` is annotated (EC-3.9.020-7), so this is intended; noted for
  symmetry only.

### [INFO] OQ-9 `--internal` on non-JSM adds two silent extra GET round-trips
- `src/cli/issue/attachments.rs` (`handle_attachment_upload_jsm`, ~L964-1002), category: code-quality.
- `--internal` on a software project performs issue GET + project-meta GET before falling through to
  the platform path (which makes no pre-check GETs). Required for JSM determination and documented as
  the OQ-9 silent no-op; correct, minor latency cost only.

## Verification notes (confirmed correct, no defect)

- `attach_temporary_file` trailing `unreachable!()` is genuinely unreachable (the only `continue` is
  429 with `attempt < MAX_RETRIES`; at the last attempt a 429 falls through to the non-success return).
  No panic risk.
- SEC-576-006 `stale_healed` guard bounds the self-heal to once per invocation; the P1-001 explicit
  EC-4 mapping produces exit 64 (not exit 1) on the post-retry 404.
- BC-3.9.007 best-effort echo returns exit 0 + empty array + stderr warning on malformed/bare-array
  step-2 responses.
- JSM full-UserDTO author is curated to `{accountId, displayName}` via `serialize_attachment_curated`
  in `render_upload_result`.
- CWE-93 CRLF/NUL guard on the step-1 Content-Disposition filename and CWE-116 display sanitization in
  both prompt gates are present and test-pinned.
- The S-576-3 interim-rejection guard and its test were fully removed; no stale references remain.
- e2e tests are triple-gated (`#[ignore]` + `e2e_enabled()` + `JR_E2E_JSM_PROJECT` presence check).

## Conclusion

No CRITICAL or HIGH findings. All findings are LOW/INFO and none block merge. **APPROVE.**
