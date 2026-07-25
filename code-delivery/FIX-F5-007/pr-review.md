# PR #646 — Fresh-Eyes Review

**Verdict: APPROVE (with notes)**

F5 round-2 polish for the #576 attachment CRUD surface: SEC-576-004 backslash symmetry (F5-R2-002), `post_request_attachment` rustdoc sync (F5-R2-001), and a test-strengthening refactor (F5-R2-003). All three production changes were verified against the actual source, not just the diff. No blocking findings.

## Verified correct

- **F5-R2-001 (rustdoc)** — Split now matches `post_request_attachment` (`src/api/jsm/attachments.rs:284-291`): transport → `JrError::NetworkError` (`.map_err`, line 327); 5xx → `JrError::ApiError` (status match, line 386). Retry hint is genuinely appended only on the HTTP branches, never on NetworkError, so the "HTTP branches only" qualifier is accurate.
- **F5-R2-002 (backslash guard)** — Correctly applied to BOTH production paths: `src/api/jira/attachments.rs:288` and `src/api/jsm/attachments.rs:74`. No guard site missed (grepped). Rationale (RFC 2616 quoted-string escape char) is sound and consistent with the existing `"` treatment.
- **F5-R2-003 (`.find().expect()`)** — Genuine de-vacuum-ing. The old `for req in received { if POST {...} }` passed silently when zero POSTs arrived; `.find(|r| r.method == POST).expect(...)` now asserts a POST exists before asserting on its body.

## Findings

### R-1 — COSMETIC — stale guard comment breaks the PR's own symmetry
`src/api/jira/attachments.rs:491`

The doc-comment "The guard lives inline in `upload_attachments`:" still reproduces the OLD 4-char guard `matches!(c, '\r' | '\n' | '\0' | '"')` — missing `\`. It now contradicts both the real guard (line 288) and its own mirror helper 7 lines below (line 498). The JSM twin comment (`jsm/attachments.rs:404`) WAS updated, so this is an incomplete-edit asymmetry inside a PR titled "backslash symmetry".

**Fix:** update line 491 to `matches!(c, '\r' | '\n' | '\0' | '"' | '\\')`.

### R-2 — ADVISORY — backslash unit tests pin a mirror helper, not production
`src/api/jira/attachments.rs:495-504`; `src/api/jsm/attachments.rs` test module

The new `test_f5_r2_002_*` tests exercise the mirror-copy `safe_name` free function defined in the test module, NOT the production guard. Reverting only the production guard (line 288 / jsm line 74) would leave these tests GREEN. Unlike the double-quote case (which has the production-exercising integration test strengthened in F5-R2-003), the backslash guard has NO integration test through real `upload_attachments`/`attach_temporary_file`. Backslash coverage is strictly weaker than double-quote coverage.

**Fix:** add a backslash integration test mirroring `test_f5_r1_006_upload_content_disposition_double_quote_mapped_to_underscore` (assert multipart body contains `file_name.txt`, not `file\name.txt`) for at least the platform path.

## Minor notes (not findings)

- F5-R2-003 now inspects only the first POST (`.find`); fine for this single-file, no-retry test.
- Mapping `\` → `_` corrupts legitimate Unix filenames containing a backslash, but this is a deliberate, consistent security tradeoff (identical to the existing `"` handling).

## Rationale

Behavioral changes are limited to a security-hardening character-guard extension plus a rustdoc sync; both confirmed correct against source. R-1 is a one-character stale comment; R-2 is a pre-existing mirror-helper pattern where the backslash case lacks the production-level integration coverage the double-quote case already has. Neither blocks merge — approving with notes.
