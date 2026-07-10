# Fresh-Eyes Review — PR #554

**Verdict: APPROVE** — ready to merge.

Doc-only change (CLAUDE.md +1 line, CHANGELOG.md +6 lines; 0 deletions, 2 files). No
source, test, or runtime behavior delta. Every citation and factual claim in the new
content was verified against the repo at HEAD.

## What I verified

### CLAUDE.md — new ADF recursion-depth guard bullet (DRIFT-S3-001)

| Claim | Repo state | Result |
|-------|-----------|--------|
| `MAX_ADF_DEPTH = 256`, `pub(crate)` | `src/adf.rs:15` `pub(crate) const MAX_ADF_DEPTH: usize = 256;` | PASS |
| All guard sites use `depth >= MAX_ADF_DEPTH` (inclusive cap) | 6 sites (lines 204, 1662, 1795, 1860, 2073, 2147) all read `if depth >= MAX_ADF_DEPTH` | PASS |
| Six named guard-site functions exist | `autolink_bare_urls`, `normalize_list_item_content`, `normalize_blockquote_content`, `normalize_panel_content`, `assign_local_ids_walk`, `AdfRenderer::render_node` all present | PASS |
| `test_max_adf_depth_constant_is_256` | `src/adf.rs:10651` | PASS |
| `test_markdown_to_adf_depth_256_blockquote_is_err` | `src/adf.rs:10778` | PASS |
| `test_adf_to_text_depth_256_is_err` | `src/adf.rs:10975` | PASS |
| `test_issue_create_deep_markdown_description_exits_64` | `tests/adf_recursion_depth.rs:98` | PASS |
| Cited file paths exist | `src/adf.rs`, `tests/adf_recursion_depth.rs` both present | PASS |
| `tests/claude_md_citations.rs` guard will pass | Shorthand `adf.rs` is auto-excluded (`test_shorthand_adf_rs_excluded`); symbol-form `src/adf.rs::test_...` strips to `src/adf.rs` (exists); `tests/adf_recursion_depth.rs` (exists) | PASS |
| Backtick balance on new bullet | 44 backticks (even) — no broken inline code spans | PASS |

**Off-by-one factual accuracy (focus item 2):** The bullet states three guard sites
initially used `depth > MAX_ADF_DEPTH` (now `>=`), so depth-256 was wrongly accepted
(guard fired at 257). Current HEAD shows all six sites read `if depth >= MAX_ADF_DEPTH`
— consistent with the bullet's "until corrected" past-tense framing. The corrected
boundary is what ships; the historical claim is internally consistent and matches the
inclusive-cap semantics pinned by `test_max_adf_depth_constant_is_256`.

### CHANGELOG.md — two `[Unreleased]` entries (DRIFT-S3-002, DRIFT-S3-004)

| Claim | Repo state | Result |
|-------|-----------|--------|
| #551 = `JR_SERVICE_NAME` debug-gate (`SEC-JR-SERVICE-NAME-GATE`) | PR #551 title matches verbatim | PASS |
| #550 = `actions/checkout` 6.0.3 → 7.0.0 | PR #550 title matches; all workflows pinned to v7.0.0 (`9c091bb…`) | PASS |
| #551 entry placed under `### Security` | Correct section for a security-gating change | PASS |
| #550 entry appended to existing dep-bump list under `### Changed` | Correct — sits with `codecov-action`, `insta`, `quinn-proto` bumps | PASS |
| Existing CHANGELOG entries untouched | +6 insertions, 0 deletions — no edits to prior content | PASS |
| Markdown/list formatting consistent | Matches surrounding bullet/indent style | PASS |

## Findings

No blocking findings. No suggestions that require a file change.

**[NIT — no change needed]** The PR *description* labels the `JR_SERVICE_NAME` CHANGELOG
entry as "**Added:**", but the actual diff (correctly) places it under `### Security`.
A keychain-service-name release-gate is a security-posture change, so the diff's section
choice is the right one; only the prose label in the PR body is slightly loose. The
committed file is correct — no edit warranted.

## Scope confirmation

`git diff origin/develop...origin/docs/maint-2026-06-25-doc-fixes --stat`:
- `CHANGELOG.md` | 6 ++++++
- `CLAUDE.md` | 1 +
- 2 files changed, 7 insertions(+)

Matches the PR's declared doc-only scope exactly. No coherence, coverage, size, or
dependency concerns.

**Recommendation: APPROVE and merge.**
