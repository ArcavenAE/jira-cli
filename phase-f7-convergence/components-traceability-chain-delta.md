---
document_type: f7-traceability-chain-delta
bundle: component-mgmt
feature: "Component management: jr component list/create/edit/delete/rename + issue create/edit/list --component (issues #604, #605, #606, #608)"
bc_files: [".factory/specs/prd/bc-8-components.md", ".factory/specs/prd/bc-3-issue-write.md", ".factory/specs/prd/bc-2-issue-read.md"]
bc_index_total: 699
story_index_version: v1.6.01
develop_sha: c266169a
date: 2026-08-20
producer: spec-steward (F7 delta synthesis)
---

# F7 Traceability Chain Delta — component-mgmt

4/6-level chain for every BC in the component-mgmt delta:
**BC-S.SS.NNN → VP-COMPONENT-NNN (where allocated) → representative test(s) → src symbol → adversarial-review evidence → live/CI evidence**

Delta = 28 new BCs in `bc-8-components.md` (BC-8.1.001..008, BC-8.2.001..008, BC-8.3.001..007,
BC-8.4.001..005) + 6 new BCs in `bc-2-issue-read.md` (BC-2.1.018..022, BC-2.3.040) + 4 new BCs
in `bc-3-issue-write.md` (BC-3.4.022..025) + 5 pre-existing BCs amended in place for component
wiring (BC-3.4.012, BC-3.4.013, BC-3.4.017, BC-3.4.020, BC-3.4.021) = 38 new + 5 amended = 43
BC-level rows across 7 stories.

**No Kani proof harness applies.** `jr` is a thin HTTP client (reqwest + tokio) with no
`unsafe` code and no Kani proof infrastructure anywhere in this repository (see CLAUDE.md
"No unsafe code without explicit justification"). The verification tier for this codebase is
mutation testing (cargo-mutants, CI-gated) + property tests (proptest, where applicable) +
adversarial review, not formal proof discharge. Levels below read
`N/A — no Kani harness in this codebase` rather than a fabricated `KANI-xxx-PASS` for that
reason; this is a standing repo-wide property, not a component-mgmt-specific gap.

depends_on edges (story level, from story frontmatter `depends_on`):
- S-604-2 depends_on S-604-1 (component types/API client/cache/resolver foundation)
- S-604-3 depends_on S-604-1
- S-606-1 depends_on S-604-1 (shares `resolve_component`/`is_numeric_component_id` resolver family)
- S-608-1 depends_on S-604-1
- S-605-1 depends_on S-604-1 (single-key `issue create`/`edit --component`, shares the same resolver)
- S-605-2 depends_on S-605-1 (bulk/`--jql` path extends the single-key wire contract to `POST /bulk/issues/fields`)

Cross-feature depends_on: BC-3.4.022/023/024/025 (issue create/edit `--component`) depend on
the pre-existing `issue create`/`issue edit` JQL-composition and multi-key bulk-guard BCs
(BC-3.4.017 C-1 guard, BC-3.4.019 cross-project guard shape) — the component stories extend
those existing surfaces rather than introducing new ones. BC-2.1.018..022 (`issue list
--component`) depend on the pre-existing JQL-composition BCs in `bc-2-issue-read.md` §2.1
(the four operator shapes bare/`not:`/`none`/`all:` reuse the existing filter-composition
pipeline `build_filter_clauses` — the story only adds one more filter kind to it).

---

## S-604-1: Component foundation — types, API client, cache, resolver, CLI scaffold, `jr component list` (PR #703, MERGED)

| BC | One-liner | VP | Representative test | Src symbol | Review evidence |
|----|-----------|-----|---------------------|-----------|------------------|
| BC-8.1.001 | `jr component list [--project KEY]` GETs `/rest/api/3/project/{key}/components`; renders table (id, name, description, lead, assigneeType) | — | `tests/component_commands.rs::test_bc_8_1_001_*` | `src/cli/component.rs::handle_list`; `src/api/jira/components.rs::list_components` | Step-4.5 CONVERGED 3/3 CLEAN (DEC-245 strict, 12 passes) |
| BC-8.1.002 | `jr component list --output json` returns array of full component objects | VP-COMPONENT (JSON render invariant, BC-7.3.010 cross-trace) | `tests/component_commands.rs::test_bc_8_1_002_*` | `src/cli/component.rs::handle_list`; `output::render_json` | Step-4.5 STRICT |
| BC-8.1.003 | `jr component list --counts` enriches each row with `relatedIssueCounts` (N+1 HTTP, one extra GET per component) | VP-COMPONENT-001 (exactly one GET per component) | `tests/component_commands.rs::test_bc_8_1_003_*`; `test_vp_component_001_*` | `src/cli/component.rs::handle_list`; `src/api/jira/components.rs::get_related_issue_counts` | Step-4.5 STRICT |
| BC-8.1.004 | `component list`/`edit`/`delete` (single-project forms) with no `--project` and no configured project → exit 64 (numeric-id edit/delete exempt, EC-8.1.004-6..8) | — | `tests/component_commands.rs::test_bc_8_1_004_*` | `src/cli/component.rs::handle_list`/`handle_edit`/`handle_delete` | Step-4.5 STRICT; also verified by S-604-2/S-604-3 (BC shared across three sibling commands) |
| BC-8.4.001 | `resolve_component(input, project, candidates)` — all-ASCII-digit input short-circuits to numeric ID; non-digit input resolves via project-scoped `partial_match` | VP-COMPONENT-014 (canonical determinism/numeric-short-circuit property) | `tests/component_commands.rs::test_bc_8_4_001_*` (lib-level: `src/cli/issue/helpers.rs` inline unit tests, a dozen-plus component-tagged lib unit tests) | `src/cli/issue/helpers.rs::resolve_component`; `src/cli/issue/helpers.rs::is_numeric_component_id` (consolidated F5-feature-level, see FIX-F5 section below) | Step-4.5 STRICT; F5 feature-level Round-1 FIX-1 (predicate consolidation) |
| BC-8.4.002 | Unknown component name (zero matches in scope) → exit 64 listing valid component names for the resolved project scope | VP-COMPONENT-009 (ambiguous/unknown zero-mutating-HTTP pin, shared) | `tests/component_commands.rs::test_bc_8_4_002_*` | `src/cli/issue/helpers.rs::resolve_component` | Step-4.5 STRICT |
| BC-8.4.003 | Ambiguous component name (2+ matches in scope) → exit 64, `Ambiguous component` message listing candidates | VP-COMPONENT-009 | `tests/component_commands.rs::test_bc_8_4_003_*` | `src/cli/issue/helpers.rs::resolve_component` | Step-4.5 STRICT |
| BC-8.4.004 | Component name resolution is ALWAYS single-project-scoped — a same-named component in a different project is NEVER silently considered a match | VP-COMPONENT-010 (two-project same-name fixture) | `tests/component_commands.rs::test_bc_8_4_004_*` | `src/cli/issue/helpers.rs::resolve_component` | Step-4.5 STRICT |
| BC-8.4.005 | Client-side resolver case-insensitivity agrees with JQL's case-insensitive component-name matching; `MatchResult::ExactMultiple` disposition is caller-specific (mutating fail-closed, read-path UNION) | VP-COMPONENT-014 (canonical), VP-COMPONENT-021 (renumbered, `ExactMultiple` id-listing message) | `tests/component_commands.rs::test_bc_8_4_005_*` (id-listing message pin, F5 feature-level FIX) | `src/cli/issue/helpers.rs::resolve_component` | F5 feature-level Round-1: BC-8.4.005 pinned to the real 5-site `ExactMultiple` id-listing message (`bc-8-components.md` v1.4.1→v1.4.2, O-CS-1) |
| BC-2.3.040 | `Component` struct (`src/types/jira/issue.rs`) gains an `id: Option<String>` field alongside the existing `name: String` | VP-COMPONENT-020 (dual-field deserialization) | unit tests in `src/types/jira/component.rs` / `src/types/jira/issue.rs` (part of a dozen-plus component-tagged lib unit tests across helpers.rs / component.rs / issue.rs, all green) | `src/types/jira/issue.rs::Component`; `src/types/jira/component.rs` | Step-4.5 STRICT; foundational for every downstream story's id-vs-name resolver path |

**Story-level evidence:** Step-4.5 CONVERGED 3/3 CLEAN under DEC-245 strict, 12 passes. security-reviewer APPROVE, pr-reviewer APPROVE, CI 15/15 green incl. CI Gate. develop HEAD `e2c403e8` (wave-1 merge point). New src files: `src/api/jira/components.rs`, `src/types/jira/component.rs`, `src/cli/component.rs`; `tests/component_commands.rs` established as the primary suite (120 tests total across all 4 component-mgmt stories that extend it).

---

## S-604-2: `jr component create` / `jr component edit` (PR #704, MERGED)

| BC | One-liner | VP | Representative test | Src symbol | Review evidence |
|----|-----------|-----|---------------------|-----------|------------------|
| BC-8.1.004 (create/edit scope) | No-project guard applies identically to `create`/`edit` single-project forms | — | `tests/component_commands.rs::test_bc_8_1_004_create_edit_*` | `src/cli/component.rs::handle_create`; `src/cli/component.rs::handle_edit` | Step-4.5 CONVERGED 3/3 CLEAN post-fix (rounds FA/FB/FC) |
| BC-8.1.005 | `jr component create --project KEY NAME [--description D] [--lead NAME] [--assignee-type TYPE]` POSTs `/rest/api/3/component` | VP-COMPONENT-022 (POST body shape, NEW M10 fix-burst) | `tests/component_commands.rs::test_bc_8_1_005_*` | `src/cli/component.rs::handle_create`; `src/api/jira/components.rs::create_component` | Step-4.5 STRICT; PR-review-caught BLOCKING (`--assignee-type` ValueEnum kebab-vs-SCREAMING_SNAKE) fixed pre-merge |
| BC-8.1.006 | `--lead <NAME>` resolves display name to `accountId`; ambiguous or no-match aborts BEFORE the mutating HTTP call | VP-COMPONENT-002 (zero-HTTP-on-ambiguous pin) | `tests/component_commands.rs::test_bc_8_1_006_*` | `src/cli/component.rs::handle_create`; `src/api/jira/users.rs` (user search) | Step-4.5 STRICT |
| BC-8.1.007 | `jr component edit NAME\|ID [--project KEY] [--name N] [--description D] [--lead NAME]` PUTs `/rest/api/3/component/{id}`; only supplied fields are sent | VP-COMPONENT-023 (PUT partial-body shape, NEW M10 fix-burst) | `tests/component_commands.rs::test_bc_8_1_007_*` | `src/cli/component.rs::handle_edit`; `src/api/jira/components.rs::edit_component` | Step-4.5 STRICT; PR-review-caught HIGH (`ExactMultiple` fold, BC-X.10.003) fixed pre-merge |
| BC-8.1.008 | Unknown component `NAME\|ID` on `edit`/`delete`/`rename` → exit 64, taxonomy-consistent message; component `NAME\|ID` accepted interchangeably with an all-digit numeric bypass | VP-COMPONENT-014 (numeric short-circuit, shared with BC-8.4.001), VP-COMPONENT-009 | `tests/component_commands.rs::test_bc_8_1_008_*` | `src/cli/component.rs::is_numeric_id` (thin wrapper) → `src/cli/issue/helpers.rs::is_numeric_component_id` (post-F5-consolidation) | Step-4.5 STRICT; F5 feature-level Round-1 FIX-1 consolidated this to the single-source-of-truth helper |

**Story-level evidence:** Step-4.5 CONVERGED, re-converged 3/3 CLEAN after PR-review catch (11 total Step-4.5 passes). security-reviewer APPROVE, pr-reviewer APPROVE, CI 15/15 green. develop `e2c403e8`→`1f8ba3e4`. **Process-gap lesson recorded:** the BLOCKING + HIGH findings above were caught by pr-reviewer, not by the 11 Step-4.5 adversary passes — this is the standing `STEP45-MISSED-CONTRACT-BUGS-PR-REVIEW-CAUGHT` drift item, disposed of at the F7 gate (see convergence report §Keep-Deferred Disposition).

---

## S-604-3: `jr component delete` — disposition-required, snapshot-before-delete safety (PR #706, MERGED)

| BC | One-liner | VP | Representative test | Src symbol | Review evidence |
|----|-----------|-----|---------------------|-----------|------------------|
| BC-8.2.001 | `jr component delete NAME\|ID [--project KEY]` refuses (exit 64) without EITHER `--move-to <NAME\|ID>` OR `--orphan` | VP-COMPONENT-003 (neither-flag zero-DELETE pin) | `tests/component_commands.rs::test_bc_8_2_001_*` | `src/cli/component.rs::handle_delete` | Step-4.5 CONVERGED 3/3 CLEAN then RE-CONVERGED 3/3 CLEAN post security-hardening (10 passes total) |
| BC-8.2.002 | `--move-to <NAME\|ID>` DELETEs with `moveIssuesTo=<targetId>`; target resolution completes BEFORE the DELETE fires | VP-COMPONENT-004 (zero-DELETE-until-resolved, extended P5 fix-burst) | `tests/component_commands.rs::test_bc_8_2_002_*` | `src/cli/component.rs::handle_delete`; `src/api/jira/components.rs::delete_component` | Step-4.5 STRICT |
| BC-8.2.003 | `--move-to` target must resolve within the SAME project as the component being deleted | VP-COMPONENT-004 (scope-confirmation mechanism) | `tests/component_commands.rs::test_bc_8_2_003_*` | `src/cli/component.rs::handle_delete` | Step-4.5 STRICT |
| BC-8.2.004 | `--move-to` target ambiguous or unknown → exit 64 BEFORE the DELETE, listing candidates or valid names | VP-COMPONENT-004 | `tests/component_commands.rs::test_bc_8_2_004_*` | `src/cli/component.rs::handle_delete` | Step-4.5 STRICT |
| BC-8.2.005 | `--move-to <SELF>` (target equals the component being deleted) → exit 64 pre-flight, zero HTTP | VP-COMPONENT-005 (self-target zero-DELETE) | `tests/component_commands.rs::test_bc_8_2_005_*` | `src/cli/component.rs::handle_delete` | Step-4.5 STRICT |
| BC-8.2.006 | `--orphan` DELETEs with no `moveIssuesTo`; requires `--yes` (non-interactive) or an interactive TTY confirm naming the affected-issue count | VP-COMPONENT-006 (non-interactive-no-yes zero-DELETE), VP-COMPONENT-007 (interactive decline zero-DELETE) | `tests/component_commands.rs::test_bc_8_2_006_*` | `src/cli/component.rs::handle_delete` | Step-4.5 STRICT |
| BC-8.2.007 | Affected issue keys are snapshotted (JQL `component = <id>`) BEFORE the DELETE, for both `--move-to` and `--orphan` | VP-COMPONENT-017 (snapshot-before-DELETE ordering, mirrors VP-576-003's class) | `tests/component_commands.rs::test_bc_8_2_007_*` | `src/cli/component.rs::handle_delete` | Step-4.5 STRICT; security-reviewer LOW-1 (CWE-116 unencoded id in DELETE URL) fixed via `urlencoding::encode`, commit `80a56c23` |
| BC-8.2.008 | `--output json` delete result: `{"deleted": "<id>", "movedIssuesTo": "<id>"\|null, "affectedIssueCount": N, "affectedIssues": [...]}`; delete is NOT idempotent — source-not-found → exit 64, concurrent-delete race → exit 1 | VP-COMPONENT-024 (idempotency, NEW M10 fix-burst) | `tests/component_commands.rs::test_bc_8_2_008_*` | `src/cli/component.rs::handle_delete`; `output::render_json` | Step-4.5 STRICT |

**Story-level evidence:** Step-4.5 CONVERGED 3/3 CLEAN (P8/P9/P10 window after CWE-116 fix). security-reviewer APPROVE (LOW-1 fixed), fresh pr-reviewer APPROVE. CI 15/15 green. develop `1f8ba3e4`→`49a927fd`. This is the SAFETY-CRITICAL story of the bundle (13 pts, disposition-required + snapshot-before-delete) — its 8 BCs form the densest VP cluster in the delta (VP-COMPONENT-003 through -007, -017, -024).

---

## S-606-1: `jr issue list --component` filter (bare/`not:`/`none`/`all:`) (PR #707, MERGED)

| BC | One-liner | VP | Representative test | Src symbol | Review evidence |
|----|-----------|-----|---------------------|-----------|------------------|
| BC-2.1.018 | `--component <NAME>` (repeated) → OR-combined `component in (id1, id2, ...)`; each name resolved independently BEFORE composition; gains Precondition/Postcondition 3 (UNION disposition) | VP-COMPONENT-015 (four operator shapes), VP-COMPONENT-022 (NEW, UNION disposition on `ExactMultiple`) | `tests/issue_commands.rs::test_bc_2_1_018_*` | `src/cli/issue/list.rs::resolve_component_clauses` | Step-4.5 CONVERGED 3/3 CLEAN (11 passes, 3 diverse lenses); F5-A-M1/F5-C-001 fix (UNION ruling) applied same-cycle |
| BC-2.1.019 | `--component not:<NAME>` → `(component not in (id) OR component is EMPTY)` | VP-COMPONENT-015; VP-COMPONENT-022 (`not:` UNION coverage) | `tests/issue_commands.rs::test_bc_2_1_019_*` | `src/cli/issue/list.rs::resolve_component_clauses` | Step-4.5 STRICT |
| BC-2.1.020 | `--component none` → `component is EMPTY` | VP-COMPONENT-015 (zero resolver HTTP when only `none` supplied) | `tests/issue_commands.rs::test_bc_2_1_020_*` | `src/cli/issue/list.rs::resolve_component_clauses` | Step-4.5 STRICT |
| BC-2.1.021 | `--component all:<NAME1>,<NAME2>` → AND-combined `component = id1 AND component = id2` | VP-COMPONENT-015; VP-COMPONENT-022 (`all:` UNION coverage) | `tests/issue_commands.rs::test_bc_2_1_021_*` | `src/cli/issue/list.rs::resolve_component_clauses` | Step-4.5 STRICT |
| BC-2.1.022 | Unresolvable or ambiguous `--component` name → exit 64 BEFORE any JQL search fires, listing valid names or candidates for the resolved project scope | VP-COMPONENT-013 (read-path zero-search pin) | `tests/issue_commands.rs::test_bc_2_1_022_*` | `src/cli/issue/list.rs::resolve_one_component_id` | Step-4.5 STRICT |

**Story-level evidence:** Step-4.5 CONVERGED 3/3 CLEAN across 11 adversary passes (3 diverse lenses, parallel). security-reviewer APPROVE, pr-reviewer APPROVE. CI 14/14 + required CI Gate green. Fast-follow test pins added post-review: SEC-707-1 + `--component`/`--jql` interaction. develop `6f689c5a`→`b1610d55`. This story is where BC-2.1.018/019/021's `ExactMultiple` UNION-vs-fail-closed disposition question was first raised and resolved (F5-A-M1/F5-C-001, human-adjudicated: UNION for the read path, contrasted with the fail-closed mutating-path disposition BC-8.4.005 documents) — captured in `bc-2-issue-read.md` v1.4.0→v1.4.1.

---

## S-608-1: `jr component rename` — single-project, `--all-projects` fan-out, `--dry-run` (PR #710, MERGED)

| BC | One-liner | VP | Representative test | Src symbol | Review evidence |
|----|-----------|-----|---------------------|-----------|------------------|
| BC-8.3.001 | `jr component rename OLD NEW --project KEY` resolves `OLD` scoped to the project, PUTs `{"name": NEW}` | VP-COMPONENT-004 (extended, numeric-`OLD` project-confirmation), VP-COMPONENT-024 (extended, idempotency) | `tests/component_commands.rs::test_bc_8_3_001_*` | `src/cli/component.rs::handle_rename_single_project`; `src/api/jira/components.rs::rename_component` | Step-4.5 CONVERGED 3/3 CLEAN (10 rounds/30 fresh-context diverse-lens passes/9 fix bursts) |
| BC-8.3.002 | `jr component rename OLD NEW --all-projects` fans out: discovers every project containing a component named `OLD` via per-project component-list calls; zero-match → exit 64 (AMENDED, F5 feature-level, was exit 0 silent no-op) | VP-COMPONENT-026 (numeric-`OLD` rejection under `--all-projects`) | `tests/component_commands.rs::test_bc_8_3_002_component_rename_all_projects_zero_matches_exits_64_not_found` (live+`--dry-run` parity, F5 feature-level fix); `test_bc_8_3_002_component_rename_all_projects_exact_equality_not_substring`; `test_bc_8_3_002_component_rename_all_projects_numeric_old_rejected_zero_http`; `test_bc_8_3_002_component_rename_all_projects_scale_no_new_rate_limit_logic`; `test_bc_8_3_002_component_rename_all_projects_discovery_phase_error_aborts_fanout_zero_put`; `test_bc_8_3_002_component_rename_all_projects_intra_project_duplicate_fails_closed_not_first_picked` | `src/cli/component.rs::handle_rename_all_projects` | Step-4.5 STRICT; **F5 feature-level Round-1 FIX-2**: zero-match now exits 64 (human-approved behavioral change) |
| BC-8.3.003 | `--all-projects` fan-out is per-project atomic: a failure in one project does NOT roll back a successful rename already committed in another | VP-COMPONENT-018 | `tests/component_commands.rs::test_bc_8_3_003_*` | `src/cli/component.rs::handle_rename_all_projects` | Step-4.5 STRICT |
| BC-8.3.004 | `--dry-run` previews the rename set with ZERO mutating HTTP calls, using the SAME project-discovery logic as the live run | VP-COMPONENT-008 (zero-PUT pin), VP-COMPONENT-026 (cross-reference, numeric-`OLD` under `--dry-run`) | `tests/component_commands.rs::test_bc_8_3_004_*` | `src/cli/component.rs::handle_rename`; `src/cli/component.rs::handle_rename_all_projects` | Step-4.5 STRICT; F5 feature-level FIX-2 verified live+dry-run parity explicitly (guard placed before the dry-run fork) |
| BC-8.3.005 | `rename` without EITHER `--project` OR `--all-projects` → exit 64 (ambiguous scope); `--project` AND `--all-projects` together → exit 2 | — | `tests/component_commands.rs::test_bc_8_3_005_*` | `src/cli/component.rs::handle_rename`; clap arg-group (mutual exclusion) | Step-4.5 STRICT; H-COMPONENT-010 holdout pin |
| BC-8.3.006 | Case-only rename (`OLD`="Backend", `NEW`="backend") is a legitimate operation — the resolver MUST NOT short-circuit it as a no-op | VP-COMPONENT-019 (case-insensitive-resolve-still-renames) | `tests/component_commands.rs::test_bc_8_3_006_*` | `src/cli/component.rs::handle_rename_single_project` | Step-4.5 STRICT |
| BC-8.3.007 | `NEW` collides with an existing component name in the same project → Jira 400 surfaced verbatim, NOT pre-validated client-side | — | `tests/component_commands.rs::test_bc_8_3_007_*` | `src/api/jira/components.rs::rename_component` | Step-4.5 STRICT |

**Story-level evidence:** Step-4.5 CONVERGED 3/3 CLEAN (DEC-245 strict, 10 rounds/30 fresh-context diverse-lens passes/9 fix bursts). Real bug caught+fixed R7 (global `--project` + `--all-projects` clap-guard gap, app-level exit-64 fix). security-reviewer APPROVE, pr-reviewer APPROVE, CI 15/15 green. RUSTSEC-2026-0258 (h2) resolved in-PR via surgical Cargo.lock bump. develop `2d74b2b5`→`23cc83aa`. Serialized trio (S-604-2/S-604-3/S-608-1, all touching `component.rs`) COMPLETE at this merge. Issue #608 CLOSED.

---

## S-605-1: `issue create`/`issue edit --component` — single-key path (PR #712, MERGED)

| BC | One-liner | VP | Representative test | Src symbol | Review evidence |
|----|-----------|-----|---------------------|-----------|------------------|
| BC-3.4.022 | `issue edit KEY --component add:X --component remove:Y` (single-key) interprets prefix, sends native Jira `update`-verb wire shape; gains EC-3.4.022-4 (numeric-bypass wiring: `{"id":"<n>"}` inside add/remove object, F5 feature-level wording amendment) | VP-COMPONENT-011 (single-key PUT shape), VP-COMPONENT-016 (add/remove don't-clobber + editmeta-gated fallback) | `tests/issue_commands.rs::test_bc_3_4_022_*` | `src/cli/issue/edit.rs::resolve_component_change_names_with_list`; `src/cli/issue/format.rs::ComponentRefKind` | Step-4.5 CONVERGED 3/3 CLEAN (DEC-245 strict, 9 rounds/27 fresh-context diverse-lens passes/8 fix bursts) |
| BC-3.4.024 | `issue create --component X --component Y` (bare, no `add:`/`remove:` prefix) sets the initial components array on POST; gains EC-3.4.024-4 (numeric-bypass wiring: `{"id":"<n>"}` array element, F5 feature-level wording amendment) | VP-COMPONENT-025 (resolution-mechanism pin: project component-list GET, not editmeta) | `tests/issue_commands.rs::test_bc_3_4_024_*` | `src/cli/issue/create.rs::resolve_create_components` | Step-4.5 STRICT |
| BC-3.4.025 | `--component` name resolution — unknown/ambiguous name exits 64 pre-flight; one round-trip via the project component-list GET (not editmeta) on `issue list`/`create`, editmeta-gated on `issue edit` per BC-3.4.022 | VP-COMPONENT-025 | `tests/issue_commands.rs::test_bc_3_4_025_*` | `src/cli/issue/create.rs::resolve_create_components`; `src/cli/issue/edit.rs::resolve_component_change_names` | Step-4.5 STRICT |
| BC-3.4.012 (amended) | `issue edit KEY` single-key success echo gains a `component → …` line in the changed-field echo | — | `tests/issue_commands.rs::test_bc_3_4_012_component_echo_*` | `src/cli/issue/edit.rs` (echo block) | Step-4.5 STRICT; regression-verified against the pre-existing BC-3.4.012 echo contract |
| BC-3.4.013 (amended) | `issue edit KEY` JSON `changed_fields` gains a `components` key on single-key `--component` edits | — | `tests/issue_commands.rs::test_bc_3_4_013_component_json_*` | `src/cli/issue/edit.rs` (JSON echo block) | Step-4.5 STRICT |
| BC-3.4.017 (amended) | C-1 multi-key/`--jql` rejection guard + flag-overlap hard error extended to include `components` in the `summary`/`description`/`issuetype`/`priority` overlap set | — | `tests/issue_commands.rs::test_bc_3_4_017_component_overlap_*` | `src/cli/issue/edit.rs` (mutual-exclusion guard) | Step-4.5 STRICT |
| BC-3.4.020 (amended, cross-reference) | `--label`'s single-vs-bulk PUT/POST asymmetry is the precedent BC-3.4.022/023 deliberately mirror for `--component` | — | (regression coverage only — no new test, existing `tests/issue_edit_labels.rs` suite unchanged) | `src/cli/issue/edit.rs::handle_edit_bulk_labels` (unmodified) | Step-4.5 STRICT; cited as design precedent, not modified |
| BC-3.4.021 (amended, cross-reference) | `--dry-run` preview taxonomy extended to cover the `--component` resolution step (resolution happens BEFORE the dry-run preview renders, closing the R1 HIGH below) | — | `tests/issue_commands.rs::test_bc_3_4_021_component_dry_run_*` | `src/cli/issue/edit.rs` (dry-run block) | Step-4.5 STRICT; R1 HIGH fix (dry-run originally skipped component resolution, exit 0 on unknown name) |

**Story-level evidence:** Step-4.5 CONVERGED 3/3 CLEAN (DEC-245 strict, 9 rounds/27 fresh-context diverse-lens passes/8 fix bursts). Real defects caught+fixed: R1 HIGH (dry-run skipped component resolution) + R1 MED (echo/dry-run rendered ADD-before-REMOVE instead of CLI input order); R3 HIGH (numeric `--component` wired as `{"name":"<digits>"}` instead of `{"id":...}`); R4 MED (RMW fallback re-emitted retained components by name → silent duplicate-name data loss); R6 HIGH (name-remove silently no-op'd against live id-bearing components, a regression from R5's refactor); R7 MED (two-PUT partial-write + false-negative → single combined `edit_issue_combined` PUT). R8 LOW (cross-identifier contradiction, adjudicated ACCEPTED, documented + test-pinned — `S-605-1-CROSS-IDENTIFIER-DIVERGENCE-ACCEPTED`, disposed at F7, see convergence report). security-reviewer APPROVE (2 LOW/INFO), pr-reviewer APPROVE (1 LOW nit), CI 15/15 green. Full suite 4,297 passed/0 failed at merge. develop `23cc83aa`→`f1ff9151`.

---

## S-605-2: `issue edit --component` (multi-key/`--jql` bulk path) (PR #714, MERGED)

| BC | One-liner | VP | Representative test | Src symbol | Review evidence |
|----|-----------|-----|---------------------|-----------|------------------|
| BC-3.4.023 | `issue edit KEY1 KEY2 --component add:X` (multi-key/`--jql` bulk path) — `POST /bulk/issues/fields` with `multiselectComponents`/integer `componentId`; Postcondition 2 explicitly OMITS `sendBulkNotification` (research-confirmed, `.factory/research/S-605-2-bulk-component-wire-2026-08-19.md`, 8/8 CONFIRM); Invariant 2 clarified (oversized numeric-id error taxonomy) | VP-COMPONENT-012 (zero single-key PUT under bulk), VP-COMPONENT-027 (co-specified-field guard, NEW P7 fix-burst — resolves the same MEDIUM-3 class as BC-3.4.020's label fork), VP-COMPONENT-028 (NEW P7 fix-burst) | `tests/issue_commands.rs::test_bc_3_4_023_*` (single-object body, integer `componentId`, two-sequential-POST ADD-then-REMOVE); AC-010 live smoke test `tests/e2e_live.rs::test_e2e_issue_edit_component_multikey_bulk_roundtrip` | `src/cli/issue/edit.rs::handle_edit_bulk_components`; `src/cli/issue/edit.rs::render_bulk_component_results`; `src/cli/issue/edit.rs::resolve_bulk_component_ids_with_list`; `src/api/jira/bulk.rs::build_component_edited_fields` | Step-4.5 CONVERGED 3/3 CLEAN (DEC-245 strict, 11 rounds/33 fresh-context diverse-lens passes/8 fix bursts, clean rounds R4/R5/R9/R10/R11) |

**Story-level evidence:** Real defects beyond Round-1/DEC-291: R2 (dry-run cross-project guard + oversized-id parse both lived only in the live path → hoisted before the dry-run block for dry-run==live parity, a recurrence of the S-605-1 R1 dry-run/live class); R3/R6/R7/R8 (`render_bulk_component_results` per-key status branches had silent-success mutation surfaces → partial-failure, inaccessible, out-of-chunk-failed, and duplicate-row/row-count all mutation-pinned — the codified `[process-gap][codified]` "render-branch silent-success mutation" class recurring 4×, disposed of at F7, see convergence report). security-reviewer APPROVE (0 CRIT/HIGH/MED/LOW), pr-reviewer APPROVE (0 BLOCKING/HIGH/MED), CI 15/15 green incl. CI Gate PASS and **Mutation testing PASS (2h18m)**. Full regression 4,326 passed/0 failed. develop `f1ff9151`→`4a4cd1fd`. **AC-010 live-Jira smoke test PASSED** (GitHub Actions run 32290952058, `test_e2e_issue_edit_component_multikey_bulk_roundtrip ... ok`, full live `e2e_live` suite 98 passed/0 failed) — the `multiselectComponents` wire shape is LIVE-CONFIRMED, matching the research (8/8 CONFIRM) and the shipped BC text; no BC correction needed (contrast the FIX-BULK-TRANSITION-001 precedent DEC-280 was guarding against).

---

## Feature-level FIX-F5 (PR #715, MERGED) — cross-story consolidation, not a new BC

The feature-level F5 scoped-adversarial pass (baseline `2d74b2b5`→`4a4cd1fd`, covering the
combined S-608-1/S-605-1/S-605-2 delta plus the earlier-merged S-604-1/2/3 and S-606-1) found
**0 CRITICAL / 0 HIGH** across 3 fresh-context diverse-lens passes (Lens A cross-story
spec-fidelity, Lens B delta regression/security, Lens C convention/test-quality). All findings
were spec-precision/doc/refactor only:

| Fix | Description | Src symbol touched | BC amended | Test evidence |
|-----|--------------|---------------------|------------|----------------|
| FIX-1 | Numeric-id-bypass predicate consolidated from 5 open-coded copies into ONE `pub(crate) is_numeric_component_id` | `src/cli/issue/helpers.rs::is_numeric_component_id` (new SSOT); call sites: `helpers.rs::resolve_component`, `format.rs::ComponentRefKind::for_input`, `component.rs::is_numeric_id` (thin wrapper), `edit.rs::resolve_bulk_component_ids_with_list`, `list.rs::resolve_one_component_id` | BC-8.1.008, BC-8.4.001 (no behavioral change — byte-identical predicate at every site, verified by pr-reviewer diff review) | `tests/component_commands.rs` + `tests/issue_commands.rs` full regression, unchanged pass/fail |
| FIX-2 | `jr component rename --all-projects` zero-match now exits 64 (was exit 0 silent no-op) | `src/cli/component.rs::handle_rename_all_projects` | BC-8.3.002 (AMENDED, human-approved behavioral change) | `tests/component_commands.rs::test_bc_8_3_002_component_rename_all_projects_zero_matches_exits_64_not_found` (live+`--dry-run`, 4 flipped-RED-to-GREEN assertions) |
| FIX-3 | CLAUDE.md `component.rs` Known Size Deviations refreshed (~1,066→~1,800 LOC, +rename) | (docs only) | — | Spec Guards CI check |

pr-reviewer APPROVE (0 blocking, full review recorded at `.factory/code-delivery/FIX-F5-component/pr-review.md`); security F5-Lens-B-cleared; CI 15/15 green incl. Mutation testing PASS; full regression 4,326 passed/0 failed. `bc-8-components.md` v1.4.1→v1.4.2, `bc-3-issue-write.md` gains EC-3.4.022-4/EC-3.4.024-4 (F-CS-1 wording amendment, no count change). Four drift items RESOLVED this pass: `NUMERIC-ID-PREDICATE-TRIPLICATED`, `S-605-1-NUMERIC-ID-BC-WORDING`, `BC-8.4.005-EXACTMULTIPLE-MESSAGE-CROSS-STORY`, `NUMERIC-ID-PREDICATE-4TH-COPY`. develop `4a4cd1fd`→`c266169a`.

---

## Story-level depends_on cross-references (confirmed against story frontmatter)

| Depends | On | Mechanic | Evidence |
|---------|----|----------|---------|
| S-604-2 | S-604-1 | Component types, API client (`components.rs`), cache family, `component.rs` CLI scaffold | story frontmatter `depends_on: ["S-604-1"]` |
| S-604-3 | S-604-1 | Same foundation; delete reuses the list-based snapshot/resolver machinery | story frontmatter `depends_on: ["S-604-1"]` |
| S-606-1 | S-604-1 | `issue list --component` reuses `resolve_component`/the component-list GET the foundation ships | story frontmatter `depends_on: ["S-604-1"]` |
| S-608-1 | S-604-1 | `rename` reuses `resolve_component` + `components.rs` API client | story frontmatter `depends_on: ["S-604-1"]` |
| S-605-1 | S-604-1 | `issue create/edit --component` single-key path reuses the SAME `resolve_component`/numeric-bypass resolver family, not a divergent one | story frontmatter `depends_on: ["S-604-1"]` |
| S-605-2 | S-605-1 | Bulk/`--jql` path extends S-605-1's single-key wire contract (`ComponentRefKind`, `resolve_component_change_names`) to the multi-key `POST /bulk/issues/fields` shape | story frontmatter `depends_on: ["S-605-1"]` |

## Cross-references to pre-existing (non-delta) BCs

```
BC-3.4.022/023/024/025 depends_on BC-3.4.017 (C-1 multi-key/--jql rejection guard shape,
  amended in place to extend the flag-overlap set to `components`)
BC-3.4.022/023 depends_on BC-3.4.020 (--label single-vs-bulk PUT/POST asymmetry precedent
  --component's own single-vs-bulk fork deliberately mirrors)
BC-2.1.018..022 depends_on the pre-existing bc-2-issue-read.md §2.1 JQL-composition BCs
  (build_filter_clauses pipeline — --component is one more filter kind added to existing
  machinery, not a new pipeline)
BC-8.1.008/BC-8.4.001 is the resolver family every one of BC-3.4.022/023/024/025 and
  BC-2.1.018..022's resolution steps calls into (single shared `resolve_component` /
  `is_numeric_component_id`, not five divergent implementations post-FIX-F5)
```

## Master traceability chain — decision

`.factory/cycles/cycle-001/convergence/traceability-chain.md` (or any
`.factory/cycles/**/convergence/traceability-chain.md`) was searched and **does not exist**
anywhere under `.factory/cycles/`. No cycle-level master traceability-chain file has been
created by any prior bundle in this cycle (SOH-ATTACHMENTS-1 and bucket1-defects each used
their own bundle-prefixed `*-traceability-chain-delta.md` filename instead, per the
bucket1-defects file's own note explaining why it didn't overwrite a generic filename). Per
the task instructions, no new directory tree or master file was speculatively created here —
this delta chain stands alone, following the same precedent the two prior bundles already
established.
