# PR #647 Review — Fresh-Eyes (PR Reviewer)

**Title:** fix(issue): restore BC-2.7.012 download-404 canonical-only asymmetry + containment base canonicalization (FIX-F5-008, F5 round for #576)

**Verdict: APPROVE** (with advisory notes — no blocking findings)

## Summary

This PR fixes a HIGH regression (F5-R3-001) introduced by PR #644's F5-R1-004
and a LOW defensive-hardening item (F5-R3-002). The core fix moves 404 body
formatting out of the `get_attachment_metadata` API layer and back to each call
site, restoring the BC-2.7.012 / DEC-168 body-surfacing asymmetry: the download
path shows a canonical-only message; the interactive delete gate surfaces the
Jira error body; the bulk dry-run swallows errors. Verified by running the suite.

## Verification Performed

| Focus area | Result |
|---|---|
| F5-R3-001 (a) download → canonical-only | CONFIRMED. `handle_single_download` (attachments.rs:711) remaps only `status==404` to canonical `UserError`, body discarded. `test_f5_r3_001` passes: exit 64, canonical prefix present, sentinel body absent. |
| F5-R3-001 (b) delete gate → canonical + `\n{body}` | CONFIRMED. Interactive gate (attachments.rs:1897) formats `"…not accessible.\n{message}"`; `message` = Jira body via `extract_error_message`. |
| F5-R3-001 (c) bulk dry-run → swallowed | CONFIRMED. attachments.rs:1978 `Err(_)` → id-only fallback row; body irrelevant. |
| Delete body regression guard wired | CONFIRMED. `test_f5_r1_004_single_aid_404_message_includes_jira_error_body` (tests/attachment_delete.rs:3111) intact; sub-case A asserts `"does not exist"` present on interactive delete 404 — passes. Catches a regression if the delete call site drops body enrichment. |
| No orphaned callers | CONFIRMED. Exactly 3 production callers, all updated for the new raw `ApiError{404}` contract. |
| F5-R3-002 canonicalize-before-`starts_with` + `Err` propagates | CONFIRMED. `resolved_dir.canonicalize()?` runs before `starts_with`; `?` propagates `Err` to the call-site warn-and-skip fail-open path (attachments.rs:941). |
| Test genuineness | `test_f5_r3_001` uses a distinctive SENTINEL and asserts its ABSENCE. `test_f5_r3_002` builds `canonical_base/../basename` — a genuinely non-canonical `..`-containing path; `Path::starts_with` is component-based so it fails pre-fix. Both are real RED gates. |
| Build / tests | `cargo build --tests` clean; all 3 target tests green. |

## Findings

### Finding 1 — ADVISORY (correctness / finding-justification)

- **Severity:** suggestion (advisory)
- **Category:** correctness
- **Finding:** The F5-R3-002 finding narrative ("silent Downloaded 0 of N in
  production") is not reachable via the sole call site. At attachments.rs:906-908
  `resolved_dir` is already `base_dir.canonicalize().unwrap_or(base_dir)`. If
  canonicalize succeeds, `resolved_dir` is fully canonical and the OLD code
  already matched (`parent.canonicalize()` yields the same canonical dir →
  `starts_with` true). If canonicalize fails, the raw fallback is passed, but then
  `final_path.parent().canonicalize()?` fails first → `Err` → warn-and-skip, in
  both old and new code. The fix is therefore an idempotent defensive no-op for
  the current single caller; the described production impact is overstated (LOW
  severity is still appropriate).
- **Suggestion:** Keep the fix — it is harmless and makes the helper robust for
  any future caller (matches the comment at attachments.rs:928 anticipating
  sub-directory logic). Optionally soften the finding's production-impact claim to
  "defensive hardening; not reachable via the current call site." No code change
  required.

### Finding 2 — COSMETIC (ux)

- **Severity:** nit
- **Category:** ux
- **Finding:** Delete gate 404 formatting is `"…not accessible.\n{message}"`. If
  Jira returns a 404 with an empty/absent error body, `message` is empty → a
  dangling trailing newline in stderr. Mirrors existing `delete_attachment_targeted`
  behavior, so it is consistent, not a regression.
- **Suggestion:** Optional: append `\n{message}` only when `!message.is_empty()`.
  Low priority; consistency with the existing targeted-delete path arguably
  outweighs the cosmetic fix.

## Rationale

The core fix is correct: `get_attachment_metadata` no longer bakes call-site
formatting into the API layer, and the two 404-sensitive call sites format per
their own BC contracts (download canonical-only; delete gate body-surfacing). The
asymmetry documented in BC-2.7.012 / DEC-168 is restored, the regression guard is
preserved and passing, and the new tests are genuine RED gates rather than
tautologies. Diff is 213/-23 lines — well under the 500-line threshold; two clean
conventional commits (RED tests, then implementation); CLAUDE.md updated in
lockstep. This is a fix PR in the F5 refinement round, so demo-evidence is not
applicable under the fix-delivery flow. The only substantive note (Finding 1) is
about the description of F5-R3-002, not the code. Nothing blocks merge.
