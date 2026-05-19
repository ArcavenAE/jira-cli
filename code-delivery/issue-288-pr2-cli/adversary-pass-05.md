# S-288-pr2-cli Adversary Pass 05

## Verdict
FINDINGS — clean-pass counter remains 0/3.

## Findings

### CRITICAL
None.

### HIGH (orchestrator downgraded — see triage)

**H-1 (DOWNGRADED to LOW)**: Adversary flagged `use serde_json;` in `src/cli/requesttype.rs:9` as a likely `clippy::single_component_path_imports` violation. Orchestrator ran `cargo clippy --all-targets --all-features -- -D warnings` independently — exit 0 clean. The lint does not fire on this codebase/clippy version. **Reclassified to L-0.** However, the defensive cleanup is cheap (remove the import; macro reference at line 165 resolves via `serde_json::json!` fully qualified), so apply it to reduce surface for future clippy version drift.

### MEDIUM

**M-1: Story `files_modified` frontmatter incomplete**
- File: `.factory/code-delivery/issue-288-pr2-cli/story.md:31-39`
- Missing files actually touched: `src/config.rs`, `src/types/jsm/request_type.rs`, `tests/queue.rs`, `tests/project_meta.rs`.
- Impact: blast-radius / semport / downstream traceability tooling misled.
- **Fix**: PO updates frontmatter to declare all touched files.

**M-2: AC-012 release-gate scope omits `tests/project_meta.rs`**
- File: `.factory/code-delivery/issue-288-pr2-cli/story.md:173-175`
- AC-012 calls out `tests/queue.rs` + `tests/auth_profiles.rs` as regression guards. But `tests/project_meta.rs::require_service_desk_errors_for_software_project` was also modified (3-arg signature + BC-X.8.004 verbatim phrase pin) — it's the original anchor source per cross-cutting.md.
- **Fix**: PO adds `tests/project_meta.rs` to AC-012 regression list.

**M-3: `RequestTypeCache` and `RequestTypeFieldsCache` should be `pub(crate)` not `pub`**
- File: `src/cache.rs:362, 427`
- Wrapper structs are not returned by any public function (callers receive `Vec<RequestType>` / `RequestTypeFieldsResponse` directly). Sibling `TeamCache` is `pub` only because `read_team_cache` returns the wrapper; the new structs don't.
- **Fix**: implementer narrows visibility to `pub(crate)` (or `pub(super)` if appropriate).

**M-4: `RequestTypeCache.types` and `RequestTypeFieldsCache.response` fields are `pub` but never read externally**
- File: `src/cache.rs:363, 428`
- Only accessed inside the cache module via `.map(|c| c.types)` / `.map(|c| c.response)`.
- **Fix**: implementer narrows fields to private; module-level access via the existing pattern still works.

### LOW / NIT
- **L-0 (was H-1)**: Apply defensive cleanup of `use serde_json;`.
- **L-1**: `find_id_by_name` case-sensitive equality couples to `partial_match::Exact` contract — pending intent verification; defer.
- **L-2**: Empty-string positional `""` produces confusing Ambiguous error (clap normally blocks this); defer.
- **L-3**: Test helper uses legacy `[instance]` config form — sibling-consistent; defer.
- **L-4**: `clear_profile_cache` test doesn't assert new RequestType cache families purged (relies on `remove_dir_all` transitively); defer.
- **L-5**: Story Implementation Tasks checklist (lines 179-203) shows `[ ]` unchecked despite shipped work. **Fix**: PO checks off completed items.

### Process-gap findings (codification follow-up)

**F-PG-1**: No `[lints.clippy]` in Cargo.toml to pin `single_component_path_imports = "deny"`. Adversary's defensive concern about clippy-version drift is valid even though current clippy passes. Codify pinning future-volatile lints to `deny` so local builds catch them before CI/adversary.

## Reviewed surfaces
- All src/ files in scope (handler, dispatch, cache, config, types)
- All test files (requesttype_commands, queue, project_meta, cache cfg(test) mod)
- Spec/story artifacts (cross-cutting.md BCs, story.md)
- CLAUDE.md (worktree)
- Cargo.toml + CI workflow check

## Not reviewed (scope guard)
- pr1-api (merged), pr3-OAuth (separate), pr4-dispatch (Wave 3)
- cargo-mutants (out per story)
- Prior adversary reports (fresh-context constraint)

## Triage / routing

| Finding | Severity | Route | Action |
|---------|----------|-------|--------|
| H-1 → L-0 | LOW | implementer | Remove `use serde_json;` (defensive) |
| M-1 | MEDIUM | product-owner | Story frontmatter completeness |
| M-2 | MEDIUM | product-owner | AC-012 add tests/project_meta.rs |
| M-3 | MEDIUM | implementer | `pub` → `pub(crate)` on RequestTypeCache, RequestTypeFieldsCache |
| M-4 | MEDIUM | implementer | `pub types/response` → private fields |
| L-1..L-4 | LOW | DEFER | Cosmetic / coverage-gap |
| L-5 | LOW | product-owner | Check off completed Implementation Tasks |
| F-PG-1 | process-gap | follow-up issue | `[lints.clippy]` codification |

Sequencing for pass 06 prep:
1. implementer: L-0 (remove import), M-3 (visibility narrow), M-4 (field privacy)
2. product-owner: M-1 (frontmatter), M-2 (AC-012), L-5 (checklist)
3. orchestrator re-dispatches adversary

Novelty: **MEDIUM-LOW** — H-1 false positive; M-1/M-2/L-5 are real but cosmetic story-doc issues; M-3/M-4 are real but minor encapsulation cleanups. No functional defects.
