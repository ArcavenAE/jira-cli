# PR Review — #644

**Title:** fix(issue): F5 adversarial fix cluster — attachment parser/guard/taxonomy LOW findings (FIX-F5-006, F5 round for #576)

**Reviewer:** PR Reviewer (fresh-eyes, independent model family)
**Verdict:** ✅ **APPROVE** (with advisory notes — no blocking findings)

---

## Summary

Fresh-eyes review conducted against the PR diff, description, and test files only. All
five code fixes (F5-R1-001, -002, -004, -006, -007) are correct and behavior-preserving
where intended. No blocking issues and no new bugs found. Load-bearing behaviors were
verified empirically, not assumed.

## What I verified (not rubber-stamped)

- **F5-R1-002 (RFC3339 `--newest` parser).** Compiled against the project's own chrono
  and confirmed: the old `parse_from_str(s, "%Y-%m-%dT%H:%M:%S%.3f%z")` returns
  `Err("input contains invalid characters")` for 1-digit and 4+-digit fractional seconds,
  while `.parse::<DateTime<FixedOffset>>()` accepts every fractional precision AND the
  `+0000` no-colon offset used in the test fixtures. The RED→GREEN test is genuine (old
  parser sorts `[older, newer]` → downloads OLDER; fixed parser sorts `[newer, older]` →
  downloads NEWER). Parity with the `--older-than` path (`src/cli/issue/attachments.rs`
  `filter_attachments_older_than`) confirmed.
- **F5-R1-004 (metadata 404 body).** The `..` wildcard in
  `get_attachment_metadata` (`src/api/jira/attachments.rs`) genuinely discarded `message`;
  the fix captures and appends it after the canonical prefix, matching
  `delete_attachment_targeted` (DEC-168). Confirmed `parse_error` populates `message` from
  the Jira body via `extract_error_message`, so the "does not exist" assertion is real.
  Bulk benign-skip path untouched.
- **F5-R1-006 (`"` guard).** Correct symmetric addition of `'"'` to the `matches!` scrub on
  both platform (`upload_attachments`) and JSM (`attach_temporary_file`) paths. AC-018 test
  appropriately re-pinned from "pass-through" to "sanitized."
- **F5-R1-007 (NetworkError).** Confirmed `JrError::NetworkError(String)` Displays as
  `"Could not reach {0} — check your connection"` and maps to exit 1 via the catch-all
  (`src/error.rs`), so exit code is preserved. Parity with step-1 `attach_temporary_file`
  transport mapping confirmed.

## Findings

| ID | Severity | Category | Location | Finding | Suggestion |
|----|----------|----------|----------|---------|------------|
| N1 | suggestion | description | PR body → Test Evidence table | Every test name listed in Test Evidence is inaccurate; none match the actual test names in the diff (e.g. described `test_f5_r1_002_newest_timestamp_rfc3339_parsed_correctly` → actual `test_newest_selects_no_millis_attachment_over_millis_older`; `test_f5_r1_004_metadata_404_propagates_jira_error_body` → actual `test_f5_r1_004_single_aid_404_message_includes_jira_error_body`). Hinders traceability. | Update the Test Evidence table to the real test names. |
| N2 | suggestion | coverage | tests/attachment_download.rs (`test_batch_download_traversal_filename_lands_inside_out_dir`) + src/cli/issue/attachments.rs (F5-R1-001) | The repaired F5-R1-001 containment check has no regression test for its rejection branch. The added test is explicitly GREEN-only and exercises only the sanitizer+SHA-1 happy path; reverting the code fix to the vacuous `resolved_dir.join(fname).starts_with(resolved_dir)` would make NO test fail. The PR description also lists a `test_f5_r1_001_batch_containment_check_rejects_path_escape` that does not exist in the diff, and the commit map labels `96bb02f3` a "red-gate" commit for F5-R1-001, but F5-R1-001 has no red gate. | Add a unit test driving the check's skip branch (factor parent-containment into a testable fn), OR document that F5-R1-001 relies solely on the VP-576-001 proptest and correct the description/commit map. |
| N3 | nit | coherence | src/cli/issue/attachments.rs (F5-R1-001) | The repaired check is still unreachable for real inputs: `compute_default_output_path` always returns `base_dir.join(single_component)`, so `final_path.parent()` is always `base_dir` and the `starts_with` is always true. Honest defense-in-depth future-proofing (comment says so). Also fails OPEN if `parent.canonicalize()` returns `Err` — not exploitable since `parent` is the user-controlled out-dir, not attacker-influenced. | No change required; optionally note the fail-open-on-`Err` is acceptable because `parent` is not attacker-controlled. |
| N4 | nit | coverage | src/api/jsm/attachments.rs (`test_bc_3_9_006_step2_network_error_appends_retry_hint`) | Test name is now misleading: after F5-R1-007 the network branch no longer appends RETRY_HINT and the body asserts `"check your connection"` instead. The `_appends_retry_hint` name contradicts the assertion. | Rename to e.g. `test_bc_3_9_006_step2_network_error_reports_connectivity`. |

## Questions for the author

1. F5-R1-001: was a rejection-path test intentionally omitted (relying on the VP-576-001
   proptest), or was `test_f5_r1_001_batch_containment_check_rejects_path_escape` (named in
   the description) meant to be included but dropped?
2. F5-R1-007: dropping RETRY_HINT from the network branch is called "parity with step-1"
   (confirmed correct in code). Was losing the "try the upload again" guidance on genuine
   transport failures a deliberate UX call, or a side effect of reusing the canonical
   `NetworkError` variant?

## Verdict rationale

All code changes are correct and verified. The findings are documentation-accuracy (N1),
a test-coverage gap on an unreachable-by-design defense-in-depth check (N2/N3), and a
misleading test name (N4) — none block merge. Approving; N1 and N2 are worth addressing
for a self-documenting change.

---

# Delta Re-Verify — polish commit `21f8021b`

**Scope:** LIGHT delta re-verify. Confirms advisory findings N2 and N4 are resolved by
polish commit `21f8021b`. Not a full re-review.

**Delta verdict: ✅ APPROVE**

## N2 — F5-R1-001 containment repair had no rejection-branch unit test

**Resolved: YES**

- Containment logic extracted into a pure helper
  `batch_path_is_within_dir(final_path, resolved_dir) -> io::Result<bool>` in
  `src/cli/issue/attachments.rs`. The batch loop consumes it via a three-arm `match`
  (`Ok(true)` proceed / `Ok(false)` skip-with-warning / `Err` fail-open-with-warning).
- `test_batch_path_is_within_dir_rejects_path_outside_base` exists and is non-trivial:
  builds `final_path` inside a separate `escape` tempdir (exists on disk so the parent
  canonicalizes, exercising the rejection branch rather than the `Err` arm) and asserts
  `matches!(result, Ok(false))`.
- Red-when-reverted confirmed: stubbing the helper to `return Ok(true)` fails the
  `matches!(_, Ok(false))` assertion; deleting it fails compilation. The repair is no
  longer silently revertable. Paired positive test
  `test_batch_path_is_within_dir_accepts_child_path` guards against false-positives.

## N4 — misleading test name `..._appends_retry_hint`

**Resolved: YES**

- Renamed to
  `test_bc_3_9_006_step2_network_error_uses_connectivity_message_no_retry_hint` in
  `src/api/jsm/attachments.rs`.
- Negative assertion added: `assert!(!err_string.contains("may have expired"), ...)`,
  confirming the expired-ID retry hint is absent on transport/network-error paths.
- Companion `test_f5_r1_007_...` doc comment updated to drop the stale RED note and
  cross-reference the renamed test.

## Bonus change (SEC-F5-001)

Silent `if let Ok` canonicalize arm replaced with a full `match` whose `Err` arm now
emits an observable stderr warning. Preserves prior fail-open behavior; adds
observability only. No behavioral regression.

## New issues (blocking only)

None.

## Note

The brief referenced "four advisories" but specified only N2 and N4; those two were
re-verified. N1/N3 were not part of this delta pass.
