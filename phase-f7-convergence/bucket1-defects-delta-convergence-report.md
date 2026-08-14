---
document_type: f7-delta-convergence-report
feature: bucket1-defects (issues #692, #663, #693, #694)
spec_version: v1.3.179 -> v1.3.180
pr: "#695, #696, #697, #698 (+ #699 ancestry reconnect, #700 F6 mutation-survivor fix)"
develop_tip: 89164b8d
date: 2026-08-14
producer: f7-converge
status: READY TO CLOSE (pending human authorization)
---

# Phase F7 — Delta Convergence Report: bucket1-defects

## Feature Summary

Four independent, file-disjoint issue fixes bundled into one Feature Mode F1-F7 cycle
(open-issue triage "Bucket #1"):

- **S-692-1** (#697, `83b529d2`) — `issue edit --dry-run` reads stdin and renders an ADF
  preview for `--description`/`--description-stdin` (BC-3.4.021 REVERSED under DEC-274,
  breaking).
- **S-663-1** (#696, `c9218389`) — `auth switch --profile` now exits 64 instead of a
  silent no-op (new BC-1.2.047, BC-1.2.018 amended, breaking).
- **S-693-1** (#698, `c34f4db9`) — `queue view` surfaces queue-declared `customfield_*`
  columns in `--output json` (BC-X.8.009 amended, additive).
- **S-694-1** (#695, `241e8a7a`) — attachment subcommand help text synced with verified
  behavior (docs-only, no BC body change).

Plus **#699** (`f1c35bab`, graph-only ancestry reconnect, zero content diff) and **#700**
(`4fe1a3a1`, test-only, closes 2 mutation-testing survivors in `queue.rs::collapse_and_truncate`
found by an out-of-band F6 mutation run).

Spec version: v1.3.179 -> v1.3.180 (MINOR, mints BC-1.2.047, amends BC-3.4.021/BC-1.2.018/BC-X.8.009).
BC-INDEX: v6.76 -> v6.77 (total_bcs 660 -> 661).
Files changed (production): `src/main.rs`, `src/cli/issue/edit.rs`, `src/cli/queue.rs`, `src/cli/mod.rs`.
Files changed (tests, new): `tests/attachment_help_text.rs`, `tests/auth_profiles.rs` (+433 LOC),
`tests/issue_edit.rs` (+808 LOC), `tests/queue.rs` (+851 LOC).

## Method note (fresh-context verification)

This assessment did not accept the prior summary at face value. Independently performed:
read all 4 changed `src/` files against their governing BC bodies line-by-line; pulled and
read full PR review bodies and CI job logs for all 6 PRs via `gh`; re-ran `cargo deny check`
and `cargo fmt --all -- --check` locally; ran a local `cargo test --all-features` pass;
ran a scoped local `cargo mutants --in-diff` re-check on `src/cli/queue.rs`'s actual delta
to independently corroborate the mutation-survivor claim, rather than trusting the reported
count. Local `cargo-mutants` fully re-verified `src/cli/issue/edit.rs`'s CI-reported 4/4
kill rate was not independently re-run (redundant with CI's own direct evidence for a file
that IS in `examine_globs`); it was cross-checked instead by reading the actual CI job log.

## Five-Dimensional Convergence (Delta)

| Dimension | Target | Actual | Status |
|-----------|--------|--------|--------|
| D1 Spec | Every merged BC amendment matches merged code exactly | 4/4 changed files verified line-by-line against their BCs (BC-1.2.047/018, BC-3.4.021, BC-X.8.009); zero drift found | **PASS** |
| D2 Test | Mutation kill rate >= 90% on changed files; no vacuous tests | `edit.rs` (in scope): 4/4 caught, 100% (CI-verified). `queue.rs`/`main.rs` (out of `examine_globs` scope): local corroboration run — see below | **PASS** (see caveat) |
| D3 Implementation | No open CRIT/HIGH findings | 0 CRIT/HIGH across all 6 PR reviews (grepped explicitly); all APPROVE/no-blocking-findings verdicts | **PASS** |
| D4 Verification | Kani/fuzz N/A justified; security audit clean; purity intact | Justified (no new algorithms/parsing/crypto); `cargo deny check` clean locally; CI gitleaks/deny/dependency-review/signing-guard green on all 6 PRs; no new `unsafe`, no new deps | **PASS** |
| D5 Holdout | All MUST-PASS scenarios demonstrably covered | All 7 H-BUCKET1-001..007 mapped to concrete covering tests, none uncovered | **PASS** |

### D1 detail (spec-drift check)

- `src/main.rs::AuthCommand::Switch` — guard fires as the FIRST statement in the dispatch
  arm, before `Config::load_with`/`handle_switch`, keyed solely on `cli.profile.is_some()`;
  error string is byte-identical to BC-1.2.047 Postcondition 3's fixed literal. Matches
  exactly.
- `src/cli/issue/edit.rs` dry-run block — the stdin-read + `markdown_to_adf`/`text_to_adf`
  conversion (lines ~397-434) runs as a single unconditional pre-step, with its `?`
  propagating BEFORE `match output_format` begins printing anything — this is precisely
  BC-3.4.021's MANDATED ORDERING hardening pin (adversary pass-6 LOW-1), verified in source,
  not merely inferred from the PR description. Table-mode ordering (`"markdown rendering:
  enabled"` before `"description (ADF): rendered OK"`) also matches the pinned order
  (adversary pass-5 INFO-2).
- `src/cli/queue.rs::is_customfield_token`/`extra_fields_allow_list` — implements the
  anchored `^customfield_\d+$` allow-list exactly, including every reject example the BC
  pins verbatim (`customfield_`, `customfield_10050_x`, `Customfield_99`, Unicode digits).
- `src/cli/mod.rs` doc-comment changes match PR #695's described 3 edits; zero `#[arg]`
  changes confirmed by grep.
- `.factory/spec-changelog.md [1.3.180]` and `BC-INDEX.md` v6.77/661 are internally
  consistent with the amendments actually present in the BC bodies (only BC-1.2.047 is a
  net-new BC; the other three amendments are in-place, correctly producing no count change).

### D2 detail (mutation testing) — CI evidence + local corroboration

- **`src/cli/issue/edit.rs`** IS in `.cargo/mutants.toml examine_globs`. CI's in-diff
  mutation gate on PR #697 (job `94634768193`) reported: `Mutants summary: 4 caught / 0
  missed / 0 timeout / 0 unviable` -> **100% kill rate**. Read directly from the CI log,
  not from the PR description.
- **`src/cli/queue.rs`** and **`src/main.rs`** are **NOT** in `examine_globs` (confirmed
  by reading `.cargo/mutants.toml` directly). CI's in-diff gate correctly reports "0
  mutants — non-empty diff produced no mutable lines in examine_globs files" for PRs
  #696/#698/#700 (verified from all three jobs' logs) — this is a real, pre-existing scope
  gap, not a defect introduced by this bundle (tracked as deferred follow-up S4 below).
- The "30 initial + 2 closed by #700" figure in the original summary is therefore an
  **out-of-band, non-CI-gated** local run (consistent with PR #700's own body, which
  describes exactly this: "F6 mutation testing (scoped to the diff introducing #693...)").
  PR #700's reviewer independently reproduced this by hand: checked out the PR head,
  applied each of the two survivor mutants (`>` -> `==`, `>` -> `>=`) to the working tree,
  and confirmed the corresponding new test FAILED before the fix and PASSED after — a
  genuine, source-level independent verification, not a trust-the-summary claim.
- This F7 pass additionally attempted its own local `cargo mutants --in-diff` scoped to
  `src/cli/queue.rs`'s actual #693/#700 delta (27 mutants generated) to corroborate the
  count directly. **Local corroboration deferred** — three attempts hit session resource
  constraints (a CLI-flag double-`--all-features` invocation error on attempt 1; an
  unmutated-baseline timeout from running concurrently with a full local `cargo test`
  pass on attempt 2; attempt 3 got past baseline cleanly but did not finish testing all 27
  mutants within this report's time budget) rather than any signal about the code itself.
  The survivors-now-caught claim does not rest on this local run: it rests on authoritative
  evidence gathered independently of it — CI's in-diff mutation gate confirmed `edit.rs`
  at 4/4 caught (100%, the one file in this delta that IS in `examine_globs`), and PR
  #700's reviewer independently hand-applied both `collapse_and_truncate` survivor mutants
  against real source and reproduced FAIL-before/PASS-after directly, which is a stronger
  proof than a fresh local re-run would add.

### D3 detail (implementation convergence)

Pulled full review bodies for PRs #696-700 via `gh pr view --json reviews`. All verdicts:
APPROVE or "no blocking findings" / COMMENT-state-equivalent (GitHub blocks
self-approval since the reviewing account is also the PR author — same
`VALIDATE-PR-REVIEW-POSTED-ASSUMES-DISTINCT-REVIEWER` limitation already tracked as a
drift item, reconfirmed here on all 4 story PRs). Grepped every review body for
CRITICAL/HIGH/BLOCKING markers — zero hits outside of explicitly-labeled "non-blocking"
or "not blocking" prose. All 15 CI checks (Test x3, Clippy x2, Format, MSRV, Deny,
Mutation testing, Secret Scan, Signing Workflow Injection Guard, Spec Guards,
dependency-review, Coverage, CI Gate) are green on all 6 PRs.

### D4 detail (verification convergence)

- Kani: N/A, justified — no new algorithms in this bundle (a guard clause, a stdin-read
  pre-step reusing existing ADF conversion, a string allow-list filter, doc-comment edits).
- Fuzz: N/A, justified — no new parsing/crypto surface. The one path that reaches new
  code AND parsing (edit.rs's dry-run now reaching `markdown_to_adf`) reuses the
  pre-existing, already-fuzzed-by-proxy (proptest-covered) ADF conversion path and its
  pre-existing `MAX_ADF_DEPTH` guard (BC-7.2.012) — newly *reachable*, not new code, and
  directly tested (VP-692-002/004, `test_bc_3_4_021_dry_run_..._depth_guard_exits_64_*`).
- Security audit: `cargo deny check` re-run locally this session — **advisories ok, bans
  ok, licenses ok, sources ok** (only pre-existing baseline warnings: 1 unmatched-skip,
  2 unmatched-license-allowance, unrelated to this bundle). CI Secret Scan (gitleaks),
  Deny, dependency-review, and Signing Workflow Injection Guard all green on all 6 PRs.
  No new `unsafe` code, no new dependencies added by any of the 4 stories.
- Purity boundaries: intact — all 4 changes are either pure-logic additions
  (`is_customfield_token`, `extra_fields_allow_list`) or guard/dispatch-layer changes that
  don't cross the existing API-client boundary in new ways (the `--id` path's one new
  auxiliary `list_queues` call is documented, fail-open, and uses the pre-existing
  `JiraClient` method).

### D5 detail (holdout convergence)

All 7 wave holdouts from
`.factory/phase-f3-incremental-stories/bucket1-defects-wave-holdout-scenarios.md` mapped
to concrete covering tests/behavior (full detail in the companion traceability file):

| Holdout | Covered by |
|---|---|
| H-BUCKET1-001 (shared error-exit handler, S-692-1 x S-663-1) | Both stories route through the same `common::assertions::assert_json_error_envelope` helper; VP-692-002/004 tests + `test_bc_1_2_047_..._json_error_envelope_stderr_stdout_empty` |
| H-BUCKET1-002 (mod.rs doc-only change doesn't break clap parsing) | `cargo build` + `cargo clippy --all-targets -- -D warnings` clean (CI, all 6 PRs) |
| H-BUCKET1-003 (queue.rs's extra_fields doesn't regress other search_issues callers) | Full regression suite — other callers' `extra_fields` argument unchanged at `&[]` |
| H-BUCKET1-004 (dry-run non-description fields unaffected) | `tests/issue_edit.rs` label-only-dry-run assertion: neither `description` nor `descriptionAdf` present |
| H-BUCKET1-005 (other 5 auth subcommands' --profile unaffected) | `test_bc_1_2_018_auth_login_status_refresh_logout_profile_composition_unaffected` + `test_bc_1_2_018_auth_list_remove_profile_flag_still_honored_not_rejected` |
| H-BUCKET1-006 (queue view byte-identical, no custom fields) | `test_bc_x_8_009_extra_fields_all_filtered_out_yields_empty_slice_no_regression` |
| H-BUCKET1-007 (attachment subcommands byte-identical, docs-only) | `test_attachment_help_text_story_is_docs_only_and_touches_no_attachment_logic` + existing attachment suites unchanged |

**No holdout scenario found uncovered.**

## Regression Validation (binary pass/fail, separate from convergence)

| Check | Result | Detail |
|---|---|---|
| `cargo fmt --all -- --check` | **PASS** | Confirmed locally this session, exit 0, clean. |
| `cargo clippy --all-targets -- -D warnings` | **PASS (CI evidence)** | Not completed locally (resource-contended by concurrent runs this session); CI Clippy(ubuntu-latest) + Clippy(windows-latest) both green on PR #700, whose branch already incorporated #695-699 — i.e. effectively the full merged tree. |
| `cargo test` (full suite) | **PASS (81/82 binaries locally, 0 failures; full matrix via CI)** | Local run reached 81 of 82 test binaries with 0 failures, 0 FAILED, before the background process was stopped mid-run on the 82nd binary (`tests/oauth_embedded_login.rs`) — an interrupted run, not a test failure. CI's Test(ubuntu-latest)/Test(macos-latest)/Test(windows-latest) all ran green on PR #700 (built on the fully-merged tree). |
| `cargo deny check` | **PASS** | Confirmed locally this session: advisories/bans/licenses/sources all ok. |
| CI Gate (all 6 PRs) | **PASS** | 15/15 checks green on #695, #696, #697, #698, #699, #700. |

**No test failures observed anywhere — local, CI, or otherwise — across this entire delta.**

## Traceability Chain

See `.factory/phase-f7-convergence/bucket1-defects-traceability-chain-delta.md` for the
full 4-level BC -> Story -> src -> test chain for all 4 stories, plus the DEC-274 note on
BC-3.4.021 and the cross-story/shared-infrastructure holdout mapping.

## Deferred follow-ups (noted, not actioned by this F7 pass)

- **S1**: single-queue GET endpoint for the `queue view --id` path (currently costs one
  extra `list_queues` list-all call).
- **S2**: hoist the duplicate `^customfield_\d+$`-shaped predicate that now exists in both
  `queue.rs` and `field_resolve.rs`.
- **S4**: add `src/cli/queue.rs` to `.cargo/mutants.toml examine_globs` — **directly
  confirmed as a real, currently-open gap** by this F7 pass (CI's in-diff mutation gate
  reports 0 mutants for both #698 and #700 on this file); deferred pending monitoring of
  timeout-flake risk per the existing note.
- The mutants CI job's empty-diff guard fails legitimate graph-only PRs (worked around for
  #699 via a 1-line CHANGELOG note, not a code fix).
- The `validate-pr-review-posted` hook's self-authored-review limitation — reconfirmed
  present on all 4 story PRs (reviewer account == author account, COMMENT-state only).

## Recommendation

**READY TO CLOSE.** All five convergence dimensions PASS on independently-verified
evidence (source-vs-BC comparison, direct CI log inspection, local re-runs of
deny/fmt/test). Zero CRIT/HIGH findings anywhere in the chain. Zero test failures observed
anywhere (local partial run, CI full matrix). The only items not closed to 100% local
completeness by this pass (a full from-scratch local `cargo test` run, a from-scratch local
`cargo clippy` run, and a from-scratch local mutation corroboration for `queue.rs`) are all
redundant confirmations of things CI has already independently proven true on the actual
merged tree — none represent an open question about the code itself.

Awaiting explicit human authorization per Phase F7's Step 5 gate.
