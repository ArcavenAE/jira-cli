# PR Review — FIX-F7-001 (F7 pre-gate doc-consistency: field-dx bundle)

**PR:** #750 — https://github.com/Zious11/jira-cli/pull/750
**Branch:** fix/F7-001-doc-consistency → develop
**Reviewer:** pr-reviewer (fresh-eyes final pre-merge gate, cycle 1)
**Verdict:** APPROVE — ready to merge
**Date:** 2026-08-31

## Scope reviewed
Docs only, 3 files (50 insertions, 4 deletions), no `src/`, tests, or binaries:
- `CLAUDE.md` — rewrote the stale `cli/issue/create.rs` "Known Size Deviations" entry (~530 LOC → ~1,253 LOC) with a DOCUMENT-AS-IS write-up.
- `docs/specs/issue-create-preflight-guards.md` — top-of-file "PARTIALLY SUPERSEDED — DEC-310" notice + inline superseded-row annotations in the behavior table.
- `CHANGELOG.md` — `### Added` for S-580-1 (#740) and two `### Changed` entries for S-578-2 (#741) and S-578-3 (#742).

Diff obtained via `git diff origin/develop...fix/F7-001-doc-consistency`. No local cargo build/test run (doc-only PR; nothing to compile).

## Independently verified
- **create.rs LOC claim correct.** `git show`-measured `src/cli/issue/create.rs` = 1,253 LOC on both the branch and develop (the file itself is unchanged by this PR; the doc figure was simply stale at ~530). It genuinely crosses ADR-0012's 1,000-LOC shard threshold, so the DOCUMENT-AS-IS treatment is warranted.
- **All cited symbols exist:** `parse_field_kv` (create.rs:564), `CREATE_D2_GOVERNED_KEYS` (field_resolve.rs:187), `get_createmeta_fields` + `get_issue_types_for_project` (create.rs step 4b resolution call), `dispatch_field_value` (field_resolve.rs:771), `FieldMetaSource::Create` arm (field_resolve.rs:153/162).
- **DEC-310 / S-578-4 are real.** DEC-310 present in `src/cli/issue/create.rs`, `docs/adr/0014-jsm-request-type-dispatch.md`, and tests. S-578-4 shipped as PR #746 (`feat(issue): issue create --field platform-path createmeta resolution — reverses DEC-188 (#578 part 5)`); it reverses DEC-188 from S-639-1, exactly as documented.
- **Current guard logic matches the doc's "current behavior."** `create.rs` pre-flight now fires only on `on_behalf_of.is_some()` (line 122); the `--field`-alone check and the combined `--field`+`--on-behalf-of` check are both removed (comment lines 110-111). This confirms the supersession notices: DEC-310 reverses the `--field` half; `--on-behalf-of` (BC-3.8.013) is unchanged; the combined-row reduction to on-behalf-of-only is accurate.
- **BC IDs all resolve in source:** BC-3.3.010/011, BC-3.4.015/016/021/027-031, BC-3.8.008/012/013.
- **CHANGELOG story-ID→PR mapping consistent with the codebase's own labeling** (not just commit "part N" numbering): S-578-2 = `issue edit --field` dispatch = #741 (BC-3.4.x, referenced in edit.rs/field_resolve.rs); S-578-3 = JSM `issue create --field` = #742 (BC-3.8.008, referenced in api/jsm/requests.rs); S-578-4 = #746; S-580-1 = `jr field options` = #740. All agree with `git log`. The pre-existing S-578-1 Breaking Changes entry forward-references "S-578-2/3/4", closing the loop.
- **CHANGELOG placement correct.** New entries land in the correct `### Added` / `### Changed` sub-sections within `## [Unreleased]`.
- **Convention adherence.** Citation form is symbol/story/BC-ID based per CLAUDE.md's own rules; the DOCUMENT-AS-IS rationale mirrors the existing `component.rs`/`attachments.rs` entries.

## Findings
None. No correctness, consistency, or prose issues. No inline comments posted (nothing to flag). No process-requirement inflation applied — treated as the low-risk doc-only change it is.

## Verdict
**APPROVE.** Doc-only consistency fix; every factual claim verified against the repo, internally consistent, and conformant to established doc-writing conventions.
