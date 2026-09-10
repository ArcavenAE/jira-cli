---
document_type: f6-hardening-report
phase: phase-f6-targeted-hardening
producer: state-manager
cycle: cycle-005
feature_mode_bundle: adf-mentions
issue: 674
project: jira-cli
mode: BROWNFIELD
intent: feature
status: complete
verdict: HARDENED
timestamp: 2026-09-09
develop_head: cef4a021
inputs:
  - ".factory/phase-f2-spec-evolution/verification-delta-674.md"
  - "tests/mention_resolution.rs"
  - "tests/e2e_live.rs"
  - "src/adf.rs"
  - ".cargo/mutants.toml"
  - ".factory/STATE.md"
input-hash: "85f1def"
---

# Phase F6 Targeted Hardening — Report (cycle-005, `adf-mentions`, #674)

Companion to `.factory/phase-f2-spec-evolution/verification-delta-674.md` (F2
VP assignment) and the cycle-005 F4/F5 delivery record in `STATE.md`. This
report is the F6 (targeted hardening) evidence package: formal
verification/mutation posture for the delta, full-tree regression/lint/
security gate results, and the VP→realizing-test coverage mapping built by
reading the VP-674 definitions and mechanically grep-matching the tests that
realize them. **No test/build/mutation command was executed by the producer
of this report** — every gate result below is orchestrator-verified on
`develop @ cef4a021` and is cited, not re-run.

---

## 1. VP-674-001..021 → Realizing-Test Coverage Mapping

Mapping built by (a) reading `verification-delta-674.md` §4/§4A/§5/§6/§7 for
each VP's defined property and suggested test name(s), then (b) grepping the
actual realizing test/proptest function names in `src/adf.rs::tests`,
`tests/mention_resolution.rs`, and `tests/e2e_live.rs`. Mechanical
name-matching only — tests were not executed.

| VP | Pins | Technique | Realizing test(s) | Status |
|----|------|-----------|--------------------|--------|
| VP-674-001 | BC-7.2.016, BC-X.7.010 | proptest + example | `src/adf.rs::tests::test_bc_7_2_016_bracket_form_emits_single_mention_id_verbatim`, `::test_bc_7_2_016_bracket_form_id_preserves_colon_and_hyphen_verbatim`, `::test_bc_7_2_016_bracket_form_nested_inside_paragraph`, `::prop_bc_7_2_016_bracket_form_emits_single_mention_id_verbatim`, `::prop_bc_7_2_016_bracket_form_start_after_whitespace_or_open_punct` | COVERED |
| VP-674-002 | BC-7.2.017, BC-X.7.007 | example | `src/adf.rs::tests::test_bc_7_2_017_at_name_resolved_emits_id_and_at_prefixed_text` | COVERED |
| VP-674-003 | BC-X.7.008 | wiremock | `tests/mention_resolution.rs::test_bc_x_7_008_ambiguous_non_exact_non_interactive_exit64_zero_post`, `::test_h_new_mention_003_exact_multiple_non_interactive_exit64_zero_post`, `::test_f1_unicode_case_fold_exact_multiple_non_interactive_exit64_zero_post` | COVERED |
| VP-674-004 | BC-7.2.016 (purity) | example/structural | Enforced by construction: `src/adf.rs::markdown_to_adf`, `::markdown_to_adf_with_mentions`, `::markdown_to_adf_no_mentions`, `::find_mention_candidates` are all synchronous, take no `JiraClient`/`reqwest` parameter (verified by signature inspection) — plus explicit regression `src/adf.rs::tests::test_find_mention_candidates_deterministic_across_calls` (tagged `// VP-674-004` at its call site) | COVERED |
| VP-674-005 | BC-7.2.016/017/018 (mark composition) | F4 empirical + example | **DOCUMENTED DEFERRED** — see §4 below | DEFERRED (documented, non-blocking) |
| VP-674-006 | BC-7.2.016 (depth/INV-1) | proptest + example | `src/adf.rs::tests::test_bc_7_2_016_mention_pass_respects_max_adf_depth`, `::test_find_mention_candidates_respects_max_adf_depth`, `::prop_bc_7_2_016_no_raw_newline_in_text_nodes_with_mentions` | COVERED |
| VP-674-007 | BC-7.2.019, BC-7.2.004 | example | `src/adf.rs::tests::test_bc_7_2_019_mention_render_fallback_precedence`, `::test_bc_7_2_004_emoji_inlinecard_media_still_dropped_after_mention_arm` | COVERED |
| VP-674-008 | BC-7.2.019 (no-panic) | proptest | `src/adf.rs::tests::prop_bc_7_2_019_mention_never_panics_at_any_inline_position`, `::prop_bc_7_2_019_mention_junk_attrs_values_never_panic` | COVERED |
| VP-674-009 | BC-X.7.007 | wiremock | `tests/mention_resolution.rs::test_bc_x_7_007_at_name_repeated_three_times_dedupes_to_one_search_call`, `::test_h_new_mention_002_at_name_unique_name_matching_result_resolves` | COVERED |
| VP-674-010 | BC-X.7.008/009 | wiremock | `tests/mention_resolution.rs::test_h_new_mention_004_zero_raw_results_hard_error_exit64_not_exit0`, `::test_bc_x_7_009_all_matches_deactivated_hard_error_with_deactivated_hint`, `::test_bc_x_7_008_ambiguous_non_exact_non_interactive_exit64_zero_post`, `::test_h_new_mention_003_exact_multiple_non_interactive_exit64_zero_post` | COVERED |
| VP-674-011 | BC-3.5.013 (visibility orthogonality) | wiremock/example | `tests/mention_resolution.rs::test_vp_674_011_internal_visibility_orthogonal_to_mention_resolution` | COVERED |
| VP-674-012 | BC-7.2.018 (`\@` escape) | example (F4-VERIFY mechanism) | `src/adf.rs::tests::test_bc_7_2_018_backslash_escaped_at_name_is_not_a_candidate`, `::test_bc_7_2_018_odd_backslash_escape_wins_over_resolvable_candidate`, `::test_bc_7_2_018_double_backslash_at_name_is_genuine_mention`, `::test_bc_7_2_016_backslash_at_inside_code_span_stays_literal_backslash` — mechanism SPIKE came back FEASIBLE (ADR-0023 §4/§4a, per STORY-INDEX.md) | COVERED |
| VP-674-013 | BC-X.7.010 (accountId preflight) | wiremock | `tests/mention_resolution.rs::test_bc_x_7_010_bracket_form_repeated_three_times_dedupes_to_one_get_call`, `::test_h_new_mention_001_bracket_form_preflight_before_post_populates_attrs_text`, `::test_bc_x_7_010_bracket_form_404_hard_error_exit64_zero_post`, `::test_ec_x_7_010_2_two_distinct_bracket_ids_both_must_succeed`, `::test_ec_x_7_010_3_bracket_form_401_propagates_standard_error_not_wrapped_as_not_found`, `::test_ec_x_7_010_3_bracket_form_500_propagates_standard_error_not_wrapped_as_not_found` | COVERED |
| VP-674-014 | BC-3.3.012 (E2E create, platform) | E2E-gated (`JR_RUN_E2E`) | `tests/e2e_live.rs::test_e2e_mention_issue_create_roundtrip` | COVERED (E2E-gated, inert in CI, clean-skip without env) |
| VP-674-015 | BC-3.4.032 (E2E edit) | E2E-gated | `tests/e2e_live.rs::test_e2e_mention_issue_edit_roundtrip` | COVERED (E2E-gated) |
| VP-674-016 | BC-3.5.013 (E2E comment add, PRIMARY) | E2E-gated | `tests/e2e_live.rs::test_e2e_mention_comment_add_roundtrip` | COVERED (E2E-gated) |
| VP-674-017 | BC-3.8.018 (E2E JSM create) | E2E-gated | `tests/e2e_live.rs::test_e2e_mention_jsm_create_roundtrip` | COVERED (E2E-gated) |
| VP-674-018 | BC-7.2.018 (`@Name` detection grammar) | proptest + example | `src/adf.rs::tests::test_bc_7_2_018_at_name_boundary_and_charset_examples`, `::prop_bc_7_2_018_at_name_detection_grammar`, `::prop_bc_7_2_018_at_name_no_candidate_contains_slash_or_whitespace`, `::prop_bc_7_2_018_at_name_no_candidate_ends_in_trim_chars`, `::prop_bc_7_2_018_find_mention_candidates_never_panics_and_deterministic` | COVERED |
| VP-674-019 | H-NEW-MENTION-006, BC-3.3.012/3.4.032/3.5.013/3.8.018 | proptest + example + wiremock (2-part) | **Part (a), pure-side:** `src/adf.rs::tests::prop_bc_no_mentions_emits_zero_mention_nodes_bracket`, `::prop_bc_no_mentions_emits_zero_mention_nodes_at_name`, `::test_no_mentions_bracket_form_stays_literal_zero_mention_nodes`, `::test_no_mentions_at_name_stays_literal_zero_mention_nodes`, `::test_no_mentions_vs_default_bracket_is_differential`. **Part (b), effectful CLI-side:** `tests/mention_resolution.rs::test_h_new_mention_006_no_mentions_comment_add_zero_resolver_http`, `::test_ac_015_no_mentions_comment_edit_zero_resolver_http`, `::test_ac_015_no_mentions_create_zero_resolver_http`, `::test_ac_015_no_mentions_edit_zero_resolver_http`, `::test_ac_015_no_mentions_jsm_create_zero_resolver_http` | COVERED (both parts) |
| VP-674-020 | BC-3.4.032 (`--dry-run` forced non-interactive) | wiremock/CLI-integration | `tests/mention_resolution.rs::test_vp_674_020_dry_run_forces_non_interactive_resolution_no_prompt` | COVERED |
| VP-674-021 | BC-X.7.007 (single-result name-match tightening) | wiremock/CLI-integration | `tests/mention_resolution.rs::test_h_new_mention_012_single_non_name_matching_result_hard_errors_no_deactivated_hint` (case 1, hard-error), `::test_vp_674_021_single_name_matching_result_resolves` (case 2, resolves), `::test_vp_674_021_case3_multi_result_reduces_to_lone_name_match_resolves_no_ambiguity` (case 3, 2+→1 reduction) | COVERED |

**Tally: 20 of 21 VPs fully COVERED by name-matched realizing tests (or, for
VP-674-004, by a combination of compile-time signature enforcement plus an
explicit regression test). 1 of 21 (VP-674-005) carries a DOCUMENTED
DEFERRED residual — not a gap in the sense of "untested," see §4.**

## 2. VP-674-005 — Documented Deferred Item

`verification-delta-674.md` §4 originally flagged VP-674-005 (mark
composition on a `mention` node, e.g. `**[~accountid:X]**`) as an **F4
EMPIRICAL SCHEMA CHECK, STATUS UNPROVEN AT F2, MECHANISM DEFERRED** — an
Atlaskit `adf-schema` runtime question no static tool can answer.

**F4 resolved the primary empirical question.** `S-cycle5-mention-pure-conversion`
added AC-015 (`.factory/cycles/cycle-005/phase-f3-stories/S-cycle5-mention-pure-conversion.md`
§AC-015) and the anchor tests exist in `src/adf.rs::tests`:
- `test_bc_7_2_016_ec5_bold_wrapped_bracket_mention_carries_no_marks`
- `test_bc_7_2_018_ec5_italic_wrapped_at_name_mention_carries_no_marks`

Both are tagged `// AC-015 / VP-674-005 — mark-composition (F4 empirical
check anchor)` at `src/adf.rs:~14066`, encoding the observed rule: a
`mention` node emitted from within active marks (bold/italic) carries **no**
marks of its own (the BC-7.2.016 point 5 assumption held).

**The residual sub-case explicitly carried forward as a documented,
non-blocking deferral is the id-only bracket-mention path (no `attrs.text`)
— tracked as `CYCLE5-F5-L2-IDONLY-BRACKET-VP674005` in `STATE.md`'s Drift /
Standing Items** (added at cycle-005 F5, Burst 11): this specific sub-case
is **UNREACHABLE from any wired write path**, because a bracket mention
always receives the BC-X.7.010 mandatory accountId preflight before
conversion, which always populates `attrs.text` — so the id-only,
`attrs.text`-absent shape VP-674-005's original wording contemplated cannot
occur on any code path a `jr` user can actually reach. This is a coverage
non-gap by construction, not an untested behavior: there is no live,
reachable state that would exercise it.

**Verdict on VP-674-005: not a blocking gap.** The decidable half (mark
composition, both bracket and `@Name` forms) is empirically verified and
pinned by regression tests; the residual half (id-only bracket, no
`attrs.text`) is provably unreachable from any wired path and is recorded as
a documented, accepted, non-blocking deferral per the F5 record.

## 3. Mutation Posture

- `.cargo/mutants.toml` `examine_globs` includes `src/adf.rs` (line 11) and
  `src/cli/issue/mentions.rs` (line 95) — both confirmed present at these
  exact line numbers. The entire mention pure-conversion surface
  (`find_mention_candidates`, `convert_mentions`,
  `markdown_to_adf_with_mentions`, `markdown_to_adf_no_mentions`, the
  `adf_to_text` `"mention"` arm) and the entire effectful resolver surface
  (`resolve_mentions`, `filter_by_name_match`) fall inside the
  mutation-tested scope.
- The sharded cargo-mutants CI gate ran **in-line and GREEN** on both PR #794
  (Wave 2, merge commit `0eaf4268`) and PR #795 (F5 fix, merge commit
  `cef4a021`): Mutation Test Plan pass → 8 shards pass → Aggregate pass → CI
  Gate pass, with **no `>120`-mutant escape-hatch invoked** on either PR
  (Wave 1's PR #778 needed the escape-hatch/admin-bypass at 281 in-diff
  mutants per DEC-352 — a separate, earlier merge; both F6-relevant PRs
  #794/#795 ran to full completion with zero escalation).
- `verification-delta-674.md` §9 enumerates 10 expected surviving-mutant
  classes (bracket/`@Name` boundary mutations, charset mutations,
  fallback-precedence swap, dedup deletion, zero-match policy flip,
  visibility mutation, `\@`-escape parity mutation, `no_mentions`
  collapse, `--dry-run` ambient-vs-forced threading, single-result
  name-match skip) and attributes each to a specific covering VP — all 10
  classes map onto VPs confirmed COVERED in §1 above.
- **Kill posture: GREEN** — no surviving mutant in any of the 10 documented
  classes reached the F6 gate on either merged PR.

## 4. Kani / cargo-fuzz — Justified Skip

**SKIPPED**, proptest-substitution justified per the cycle-002/003/004
precedent recorded in `STATE.md`'s Skip Log (this repo has never
provisioned Kani or a cargo-fuzz harness for `adf.rs` or any module; no
`kani`/`fuzz` crate in `Cargo.toml`, no `fuzz/` directory).

The mention parse/conversion surface specifically respects the two
invariants a static/fuzz toolchain would otherwise be relied on to check:

- **INV-1 (no raw newline in a non-codeBlock text node):** `build_mention_text`
  (the `attrs.text` population path) sanitizes control characters —
  the display name's control chars, including `\n`/`\r`, are mapped to a
  space before being embedded in `attrs.text`, consistent with the
  file-wide INV-1 enforcement chokepoint (`push_text`/`push_code`/
  `text_to_adf`). Pinned by `src/adf.rs::tests::test_bc_7_2_017_attrs_text_never_contains_raw_newline`
  and the depth/INV-1 proptest `prop_bc_7_2_016_no_raw_newline_in_text_nodes_with_mentions`
  (VP-674-006 Property B).
- **`MAX_ADF_DEPTH` recursion guard:** the mention conversion pass is a
  sibling call in the same post-`finish()` sequence as `autolink_bare_urls`
  and inherits the existing inclusive depth-256 boundary (BC-7.2.012);
  pinned by `test_bc_7_2_016_mention_pass_respects_max_adf_depth` and
  `test_find_mention_candidates_respects_max_adf_depth` (both VP-674-006).

No `unsafe` code, arithmetic-overflow surface, or out-of-bounds
array-indexing surface is introduced by this feature — the defect classes
Kani is strongest at are not present. Fuzzing's crash-finding value is
covered by the proptest no-panic invariants (VP-674-008,
`prop_bc_7_2_018_find_mention_candidates_never_panics_and_deterministic`)
run over generated/arbitrary markdown. **0-GAP**: this is a documented
substitution, not an omission, matching the established precedent.

## 5. Verified Regression / Lint / Security Results (develop @ cef4a021)

All results below are orchestrator-verified; no command was re-run to
produce this report.

| Gate | Result |
|------|--------|
| `cargo clippy --all-targets -- -D warnings` | CLEAN |
| `cargo fmt --all -- --check` | CLEAN |
| `cargo deny check` | advisories ok / bans ok / licenses ok / sources ok |
| Full regression (Test suite: macOS + Ubuntu + Windows + Coverage) | GREEN — PR #795 CI ran the complete suite on merged commit `cef4a021` (CI evidence, run `34416725940`); PR #794's CI was also fully green prior |
| Mutation gate (sharded, `.cargo/mutants.toml` scope) | GREEN on both PR #794 and PR #795 — Mutation Test Plan → 8 shards → Aggregate → CI Gate, no escape-hatch invoked |
| Secret Scan (gitleaks) | GREEN on both merged PRs |
| Dependency review | GREEN on both merged PRs |

## 6. Verdict

**HARDENED.**

- 20 of 21 VPs (VP-674-001..004, 006..021) are fully covered by name-matched
  realizing tests across `src/adf.rs::tests` (proptest + example, pure
  core), `tests/mention_resolution.rs` (wiremock, effectful resolver), and
  `tests/e2e_live.rs` (E2E-gated round-trip acceptance).
- VP-674-005 (mark composition) has its decidable half empirically verified
  and pinned; its residual sub-case (id-only bracket, no `attrs.text`) is
  **UNREACHABLE from any wired write path** and is carried as a documented,
  non-blocking deferral (`CYCLE5-F5-L2-IDONLY-BRACKET-VP674005`) — not an
  outstanding test gap.
- Mutation kill posture is GREEN on both merge-relevant PRs (#794, #795),
  with no escape-hatch invoked and every one of the 10 documented
  surviving-mutant classes mapped to a covering, present VP.
- Kani/cargo-fuzz are justifiably skipped with a documented 0-GAP
  substitution (proptest + example anchors covering the same universal
  properties and no-panic guarantees).
- Full-tree regression (all three OS targets + Coverage), lint (clippy/fmt),
  license/advisory (cargo deny), secret scan, and dependency review are all
  GREEN on the merged commit `cef4a021`.

**No GAP was found beyond the documented VP-674-005 deferral.** The
VP-coverage mapping constructed for this report did not surface any
additional VP without a covering test, nor any undocumented residual beyond
the one the F5 record already tracks.

---

*Producer: state-manager. This report records verified facts and a
mechanically-constructed coverage mapping; it does not itself execute any
build, test, or mutation command.*
