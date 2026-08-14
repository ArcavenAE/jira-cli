---
document_type: f7-traceability-chain-delta
feature: bucket1-defects (issues #692, #663, #693, #694)
spec_version: v1.3.179 -> v1.3.180
bc_index_version: v6.76 -> v6.77 (661 BCs)
pr: "#695, #696, #697, #698 (+ #699 ancestry reconnect, #700 F6 mutation-survivor fix)"
develop_tip: 89164b8d
date: 2026-08-13/14
producer: f7-converge
status: see delta-convergence-report.md
---

# Traceability Chain — bucket1-defects Delta

4-level hierarchy (BC -> Story -> src -> test) for each of the four stories, plus
DEC-274's reversal note on BC-3.4.021 and cross-references to shared infrastructure.
This file APPENDS to, and does not replace, the S-388 traceability record that
previously occupied the generic `traceability-chain-delta.md` filename — see the
Note at the end of the companion convergence report for why this bundle uses a
`bucket1-defects-`-prefixed filename instead of overwriting that file.

---

## S-663-1 — `auth switch --profile` exit-64 guard (closes #663)

```
BC-1.2.047 (NEW: "auth switch --profile <X>" rejected exit 64)
  -> STORY S-663-1 (.factory/stories/S-663-1-auth-switch-profile-guard.md, 9 ACs, 3 pts, breaking_change: true)
  -> src/main.rs (AuthCommand::Switch dispatch arm, guard fires before Config::load_with, cli.profile.is_some() only)
  -> tests/auth_profiles.rs:
       test_bc_1_2_047_auth_switch_with_profile_flag_exits_64
       test_bc_1_2_047_auth_switch_guard_fires_before_config_load_no_existence_check
       test_bc_1_2_047_auth_switch_charset_invalid_profile_preempted_by_validate_profile_name
       test_bc_1_2_047_auth_switch_profile_flag_rejected_regardless_of_order_or_value
       test_bc_1_2_047_auth_switch_with_profile_flag_json_error_envelope_stderr_stdout_empty
       test_bc_1_2_047_auth_switch_jr_profile_env_var_not_rejected  (EC-1.2.047-4)
  -> PR #696 (c9218389), CI 15/15 green (mutation gate: 0 mutants -- src/main.rs not in
     .cargo/mutants.toml examine_globs, a pre-existing scope choice, unaffected by this story)
  -> pr-reviewer (Zious11, COMMENT-state/self-review) APPROVE, 4 non-blocking findings, 0 CRIT/HIGH

BC-1.2.018 (AMENDED: auth switch carved out as the sole --profile-rejecting subcommand;
            List/Remove/Login/Status/Refresh/Logout unaffected -- regression coverage)
  -> STORY S-663-1 (same story, regression ACs 7/8)
  -> src/main.rs (Login/Status/Refresh/Logout compose subcmd.profile.or(cli.profile);
                  List/Remove pass cli.profile.as_deref() straight through)
  -> tests/auth_profiles.rs:
       test_bc_1_2_018_auth_login_status_refresh_logout_profile_composition_unaffected
       test_bc_1_2_018_auth_list_remove_profile_flag_still_honored_not_rejected
  -> also the regression pin for wave holdout H-BUCKET1-005
```

## S-692-1 — `issue edit --dry-run` stdin/bare-description ADF preview (closes #692, DEC-274)

```
BC-3.4.021 (STATUS: UPDATED under DEC-274 -- REVERSES pre-existing Invariant 3;
            scope extended to bare --description by adversary pass-3 MEDIUM-1,
            ratified at the same F2 gate)
  -> DEC-274 (RATIFIED 2026-08-13, decisions-archive.md / STATE.md Decisions Log)
  -> STORY S-692-1 (.factory/stories/S-692-1-dry-run-stdin-adf-preview.md, 14 ACs, 5 pts, breaking_change: true)
  -> src/cli/issue/edit.rs (handle_edit dry-run block, lines ~397-434 pre-step +
                            ~505-598 JSON/table emission; MANDATED ORDERING: stdin
                            read + markdown_to_adf/text_to_adf conversion completes,
                            including possible Err->exit 64, BEFORE `match output_format`
                            begins printing -- verified in source, matches
                            Postconditions-Common item 6 / Invariant 3 exactly)
  -> tests/issue_edit.rs (808 new LOC; VP-692-001..004 test vectors, e.g.:
       ..._multiline_markdown_stdin_produces_real_adf_document (VP-692-001 family)
       test_bc_3_4_021_dry_run_description_stdin_depth_guard_exits_64_json_stdout_empty (VP-692-002)
       test_bc_3_4_021_dry_run_description_stdin_depth_guard_exits_64_table_stdout_empty (VP-692-002)
       test_bc_3_4_021_dry_run_bare_description_depth_guard_exits_64_json_stdout_empty (VP-692-004)
       test_bc_3_4_021_dry_run_bare_description_depth_guard_exits_64_table_stdout_empty (VP-692-004)
       [label-only dry-run: neither `description` nor `descriptionAdf` present -- H-BUCKET1-004 pin])
  -> PR #697 (83b529d2), CI 15/15 green, in-diff cargo-mutants (src/cli/issue/edit.rs IS in
     examine_globs): 4 caught / 0 missed / 0 timeout / 0 unviable -- 100% kill rate
     (CI-verified directly, job 94634768193)
  -> pr-reviewer (Zious11, COMMENT-state/self-review) "no blocking findings", built branch,
     ran `cargo test --test issue_edit` (38/38 passed), 5 non-blocking findings, 0 CRIT/HIGH
  -> cross-reference: BC-3.4.013/#398 raw-input invariant explicitly UNCHANGED (no body edit);
     BC-7.2.012 MAX_ADF_DEPTH guard newly REACHABLE from this call site, not modified
```

## S-693-1 — `queue view` custom-field passthrough (closes #693)

```
BC-X.8.009 (STATUS: UPDATED 2026-08-13, issue #693 -- Issue fetch pipeline step 3 +
            JSON-output clause amended; additive, not breaking)
  -> STORY S-693-1 (.factory/stories/S-693-1-queue-view-custom-fields.md, 8 ACs, 5 pts, breaking_change: false)
  -> src/cli/queue.rs (handle_view: name-path retains resolved Queue.fields at no extra
                       HTTP cost; --id path costs one auxiliary list_queues call, fail-open
                       with stderr warning on failure/no-match (EC-X.8.009-1);
                       extra_fields_allow_list() / is_customfield_token() -- anchored
                       ^customfield_\d+$ allow-list, source-verified byte-for-byte against
                       the BC's reject-example list)
  -> tests/queue.rs (851 new LOC, 8 tests covering AC-1..8, incl.
       test_bc_x_8_009_extra_fields_all_filtered_out_yields_empty_slice_no_regression
       [H-BUCKET1-006 pin] + is_customfield_token accept/reject unit tests matching the
       BC's pinned reject examples verbatim)
  -> PR #698 (c34f4db9), CI 15/15 green; in-diff cargo-mutants: 0 mutants (src/cli/queue.rs
     is NOT currently in .cargo/mutants.toml examine_globs -- pre-existing scope gap,
     flagged as deferred follow-up S4 below, not unique to this story)
  -> pr-reviewer (Zious11, COMMENT-state/self-review) "no blocking findings", 6 suggestions +
     3 nits incl. S4 (mutation gate zero-mutants observation, non-blocking) -- 0 CRIT/HIGH
  -> FOLLOW-UP FIX PR #700 (4fe1a3a1, test-only): F6-style out-of-band `cargo mutants --file
     src/cli/queue.rs` run (outside the CI in-diff gate, since queue.rs is out of
     examine_globs) found 2 surviving mutants in `collapse_and_truncate`'s 200-char boundary
     (`>` -> `==`, `>` -> `>=`); #700 adds
     test_collapse_and_truncate_boundary_exact_length_is_not_truncated and
     test_collapse_and_truncate_boundary_over_length_is_truncated, closing both --
     independently spot-checked by this F7 pass (see Mutation Verification in the
     companion convergence report)
```

## S-694-1 — attachment help-text/doc-comment sync (closes #694, docs-only)

```
No BC body change (frontmatter changelog note only) -- BC-2.7.008/009/010 already
described the verified runtime behavior; this story brings CLI help text INTO sync
with those pre-existing BCs, it does not amend them.
  -> STORY S-694-1 (.factory/stories/S-694-1-attachment-help-text-sync.md, 5 ACs, 2 pts, breaking_change: false)
  -> src/cli/mod.rs (3 doc-comment edits on IssueCommand::Attachment / Download fields;
                     zero #[arg]/behavior changes -- source-verified)
  -> tests/attachment_help_text.rs (NEW, 184 LOC, 4 tests):
       test_bc_2_7_008_attachment_help_about_enumerates_all_four_subcommands
       test_bc_2_7_009_attachment_download_help_newest_documents_filter_then_sort_order
       test_bc_2_7_010_attachment_download_help_out_dir_documents_sha1_naming_scheme
       test_attachment_help_text_story_is_docs_only_and_touches_no_attachment_logic
         (self-enforcing scope guard)
  -> PR #695 (241e8a7a), CI 15/15 green, mutation gate: doc-comment-only diff, no
     production logic touched (self-verified by the story's own scope guard test)
  -> pr-reviewer approve-equivalent (implicit -- no distinct review comment thread found
     on #695; CI green, scope-guard test passing)
  -> also the regression pin for wave holdout H-BUCKET1-007 (zero attachment LOGIC changed)
```

## Cross-story / shared-infrastructure links (wave holdouts)

```
H-BUCKET1-001 (shared src/main.rs error-exit handler, S-692-1 x S-663-1)
  -> tests/issue_edit.rs::assert_json_error_envelope call sites (VP-692-002/004)
     + tests/auth_profiles.rs::test_bc_1_2_047_..._json_error_envelope_stderr_stdout_empty
     + common::assertions::assert_json_error_envelope (single shared helper, both stories route through it)
     + full-suite regression run (see convergence report Regression Validation table)

H-BUCKET1-002 (src/cli/mod.rs doc-only change does not perturb clap parsing for the
               other 3 stories) -> `cargo build` + `cargo clippy --all-targets -- -D
               warnings` clean (CI Format/Clippy jobs, all 6 PRs) + full test suite green

H-BUCKET1-003 (queue.rs's non-empty extra_fields does not regress other search_issues
               callers, whose extra_fields stay &[]) -> full regression suite
               (issue_list.rs / issue_view tests unaffected, extra_fields call-site-scoped)

H-BUCKET1-004 (dry-run non-description fields unaffected, no descriptionAdf key)
  -> tests/issue_edit.rs label-only-dry-run assertion (line ~778-783):
     "neither description nor descriptionAdf may appear when no description flag was supplied"

H-BUCKET1-005 (other 5 auth subcommands' --profile handling unaffected)
  -> tests/auth_profiles.rs::test_bc_1_2_018_auth_login_status_refresh_logout_profile_composition_unaffected
     + test_bc_1_2_018_auth_list_remove_profile_flag_still_honored_not_rejected

H-BUCKET1-006 (queue view byte-identical output for a queue with no custom fields)
  -> tests/queue.rs::test_bc_x_8_009_extra_fields_all_filtered_out_yields_empty_slice_no_regression

H-BUCKET1-007 (attachment subcommands' actual behavior byte-identical, docs-only story)
  -> tests/attachment_help_text.rs::test_attachment_help_text_story_is_docs_only_and_touches_no_attachment_logic
     + existing attachment_{list,download,upload,delete}.rs suites unchanged/green
```

## Spec-changelog / index anchors

```
.factory/spec-changelog.md [1.3.180] MINOR (2026-08-13) -- mints BC-1.2.047, amends
  BC-3.4.021 / BC-1.2.018 / BC-X.8.009; #694 frontmatter-only note.
.factory/specs/prd/BC-INDEX.md v6.77, total_bcs: 661 (+1 for BC-1.2.047 only -- the
  other three amendments are in-place, no count change; internally consistent with
  each amended BC body's own STATUS/trace notes).
CHANGELOG.md [Unreleased] -- Breaking Changes: S-663-1 (#663), S-692-1 (#692, DEC-274);
  Added: S-693-1 (#693); Internal: #699 ancestry reconnect. (S-694-1 docs-only, no
  CHANGELOG entry expected/found -- consistent with its docs-only scope.)
```
