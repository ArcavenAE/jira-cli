# S-288-pr4-dispatch Adversary Pass 02 (retry)

## Worktree HEAD verification
Confirmed worktree HEAD = `d177c28` with 5 expected pr4 commits.

## Verdict
**FINDINGS** — orchestrator override of adversary's "CLEAN" verdict. Per Wave 2 precedent, MEDIUM-class findings reset the counter to 0/3. Adversary itself listed 3 MEDIUM defects (M-01 silent flag drop, M-02 missing `expect(0)`, M-03 no integration coverage for markdown on JSM path) — these are remediable in one dispatch round.

## Findings

### CRITICAL / HIGH
None.

### MEDIUM

**M-01: `--markdown` silently dropped on JSM path when no description is set**
- File: `src/cli/issue/create.rs` lines 333-343 platform-path validation vs lines 1842-1997 JSM handler
- Platform path emits `JrError::UserError` when `markdown && description.is_none() && !description_stdin`. JSM handler has no equivalent guard. `--request-type X --markdown` (no `--description`) silently accepts; `markdown` bool plumbed but `description: None` skips the ADF branch in `JsmRequestBuilder::build()` lines 94-104.
- Same class as pass-01 C-02 (silent platform-flag drop). Should be a warning per BC-3.8.010/011 pattern OR an error per platform precedent.
- **Fix**: implementer adds a pre-dispatch validation/warning in `handle_jsm_create` (or alongside the 6 BC-3.8.011 warnings).

**M-02: `test_jsm_create_field_missing_equals_exits_64` lacks `expect(0)` on JSM POST regression guard**
- File: `tests/issue_create_jsm.rs:1011-1061`
- Mounts request-type list but not POST `expect(0)`. A regression moving `parse_field_kv` after `create_jsm_request` would pass (exit-64 from JSM 5xx fallback). Compare AC-003 (line 337) + H-03 (line 1912) which do mount `expect(0)` correctly.
- **Fix**: test-writer adds `Mock::given(method("POST")).and(path("/rest/servicedeskapi/request")).expect(0).mount(&server).await;`

**M-03: No integration test for `--markdown` + `--description` on JSM path**
- File: `tests/issue_create_jsm.rs`
- `grep -n "markdown\|description-stdin\|description_stdin" tests/issue_create_jsm.rs` → 0 hits. BC-3.8.006 mandates markdown→ADF conversion via `markdown_to_adf` but no integration test exercises this end-to-end on the JSM path. The proptest C.2 fixes `markdown: false` for both arms.
- **Fix**: test-writer adds `test_jsm_create_markdown_description_yields_adf_with_strong_marks` asserting `requestFieldValues.description.content[*]...marks[*].type == "strong"` for `--description "**bold**" --markdown` input.

### LOW / NIT (deferred)
- L-01: Empty `--request-type ""` produces "Ambiguous" error (should fast-fail with explicit empty message). Defer.
- L-02: Basic-auth 401 hint mentions "OAuth scope" — split could improve UX. Defer.
- L-03: `parse_field_kv` runs after HTTP calls in `handle_jsm_create` — could pre-flight. Defer.

### Process-gap findings
None this pass.

## Audit checklist (all PASS)
- POLICY zero-clippy / no-`#[allow]`: PASS (only rustdoc reference at line 1787)
- POLICY multi-profile-cache (CRITICAL): PASS (`&config.active_profile_name` threaded)
- POLICY output-channel-discipline: PASS (stderr warnings, stdout data)
- POLICY ai-agent-json: PASS (--output json shape consistent)
- L-288-pr2-02 grep (`||` accept-either): CLEAR — zero hits in tests/issue_create_jsm.rs or in src/ `#[cfg(test)] mod` blocks
- BC-3.8.011 wiring: 5 verbatim warning strings in impl match BC verbatim; 5 tests cover each
- AC-016 OAuth scope pin: present at src/api/auth.rs:61

## Reviewed surfaces
- Full read: src/cli/issue/create.rs, src/api/jsm/requests.rs, src/api/jsm/request_types.rs, src/api/auth.rs, src/cli/auth/tests/mod.rs, src/cli/mod.rs, src/cli/requesttype.rs (sibling), src/cache.rs, src/error.rs, src/api/client.rs (401 dispatch), src/partial_match.rs
- Full read: tests/issue_create_jsm.rs (27 tests)
- Spec: bc-3-issue-write.md, story.md
- Configs: CLAUDE.md, CHANGELOG.md, .cargo/mutants.toml

## Not reviewed (scope guard)
- ADR-0014 (out of perimeter)
- Other unrelated holdouts
- pr1/pr2 specs (prerequisites already on develop)

## Triage / routing

| Finding | Route | Action |
|---------|-------|--------|
| M-01 | implementer | Add markdown-without-description guard on JSM path (warn or error per platform precedent) |
| M-02 | test-writer | Add POST `expect(0)` to test_jsm_create_field_missing_equals_exits_64 |
| M-03 | test-writer | Add `test_jsm_create_markdown_description_yields_adf_with_strong_marks` |
| L-01..L-03 | DEFER | Cosmetic UX |

Sequencing: impl + test-writer in parallel (different files); re-dispatch adversary pass-03.

## Novelty assessment
**LOW-MEDIUM**. Pass-02-retry inherits the discipline from pass-01 remediation. Remaining MEDIUM findings are tight UX consistency gaps (markdown-on-JSM symmetry with platform), test-precision (single missing `expect(0)`), and one coverage gap. None block convergence past 3 more clean rounds.
