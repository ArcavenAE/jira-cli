---
document_type: cycle-manifest
cycle_id: cycle-014-issue-triage-quickfixes
cycle_type: bug-fix
version: TBD — human decision D-390 (2026-09-29, F3 gate) confirms STORY-A (#862) ships as a BREAKING CHANGE; STORY-C (#583) and STORY-B (#861) remain non-breaking. This makes the release bump shape MINOR-or-breaking-flagged rather than three PATCH-shaped fixes as originally proposed at F1. Final version-bump decision stays at release.
status: f5-in-progress
started: 2026-09-24
completed: null
producer: architect (F1 delta analysis)
---

# Cycle Manifest: cycle-014 (issue-triage-quickfixes)

## Delivered

**STORY-A** (`S-cycle14-user-list-project-resolution`, #862, 3 pts, 11 ACs,
**BREAKING**) — MERGED 2026-09-29, PR #886 @ `2d8467c4` (squash, `develop`,
mergedAt 2026-09-29T18:49:19Z).

**STORY-C** (`S-cycle14-api-query-param`, #583, 8 pts, 11 ACs, non-breaking)
— MERGED 2026-09-30, PR #887 @ `e54be670` (squash, `develop`, mergedAt
2026-09-30T03:57:04Z; merged manually by the human, see dated note below).

**STORY-B** (`S-cycle14-field-options-name-label`, #861, 5 pts, 9 ACs,
non-breaking) — MERGED 2026-09-30, PR #888 @ `2ee422e0` (squash, `develop`,
mergedAt 2026-09-30T12:48:06Z; merged manually by the human, see dated note
below).

**3 of 3 cycle-014 stories delivered.** Serial order `A -> C -> B` per
`D-381` COMPLETE. Phase F4 (delta implementation) is **COMPLETE**.
Combined wave integration gate over the 3-story delta (`204b1fb5..2ee422e0`):
**PASSED**. Full gate report:
`cycles/cycle-014/wave-integration-gate.md`.

**FIX-P5-001** (`SEC-001-RENDER-TABLE-ANSI-SANITIZE`, F5's first routed finding, `D-392`) —
MERGED 2026-10-01T03:48:52Z, PR #891 @ `769365ab99be60c92a3494d630c423b962a0509d` (squash,
`develop`; merged manually by the human). Scope grew three times during review (`D-393`
comment view / SEC-003, `D-394` `jr issue assign` / re-review residual, `D-395` shared
`disambiguate_user` resolver / SEC-891-2, which also froze the PR's scope) — full round-by-round
review narrative: `code-delivery/FIX-P5-001/review-summary.md`. Final CI head `2973ef65`:
24/24 checks green. Spec `bc-7-output-render.md` `v2.5.1` -> `v2.5.5`; BC count unchanged 773,
VP count unchanged 98.

## Summary

**F1 GATE OUTCOME (2026-09-24): "Approve, as corrected."** Scope minted as
**D-378** (mint pending state-manager action): #862 (full) + #861
READ-SIDE ONLY + #583 (full). Three parallel-wave-eligible S stories:
STORY-A = #862, STORY-B = #861 read-side, STORY-C = #583. The #861
write-side item (`find_option_match`/`resolve_option_value` name-fallback)
is REMOVED from scope — see item 2 below and the Deferred / Follow-up
section. Next phase: **F2** (spec evolution).

Source: human-approved triage of three open GitHub issues, cross-referenced
against
`.factory/research/github-issues-triage-grounding-2026-09-24.md` (external
grounding) and the prior `.factory/phase-f1-delta-analysis/issue-triage-enhancement-cluster-2026-09-10.md`
triage pass (which independently flagged #583 as a clean, low-risk S item).

Three independent, isolated defects/gaps, bundled into one cycle because
each is small (S-sized) **[CORRECTED 2026-09-25, F2 human review: the
original "none touches the others' files" framing here was inaccurate —
STORY-A (#862) and STORY-C (#583) both touch `src/main.rs`,
`.cargo/mutants.toml`, and `docs/specs/cargo-mutants-policy.md`, and all
three stories touch `src/cli/mod.rs` and `README.md`. This is the reason
delivery was changed to serial A → C → B — see the dated amendment note in
the Notes section below]**:

1. **#862 — `jr user list` ignores global `--project`.** `UserCommand::List`
   (`src/cli/mod.rs`) declares a REQUIRED local `project: String`, and
   `src/main.rs`'s `User` dispatch arm never passes `cli.project` down at
   all (unlike every other `Command` variant with a same-id local
   `--project` field, which is passed the global value and merges it).
   Root cause confirmed; reproduced (`jr --no-input --project FOO user
   list` exits 2 with clap's own missing-required-arg message, not a
   `jr`-level "no project configured" error). **[CORRECTED 2026-09-25, F2
   human review: the actual root cause is that `UserCommand::List.project`
   was typed as a clap-REQUIRED `String` — clap's own required-argument
   validation runs BEFORE its global-value propagation step
   (`fill_in_global_values`), so that typing alone explains the reported
   bug; `handle_list`'s missing `Config`-default fallback is the other
   half. `src/main.rs`'s `User` dispatch arm not passing `cli.project`
   through is a separate, pre-existing gap relative to every other
   project-bearing dispatch arm — it is NOT the root cause of the reported
   bug.]**
2. **#861 — `jr field options` renders system-field options as
   `(unnamed)`. READ-SIDE ONLY (D-378 human gate, 2026-09-24).**
   `normalize_from_allowed_values_at_depth` (`src/cli/field.rs`) reads only
   `AllowedValue.value` for the display label; system fields (`priority`,
   `resolution`, `versions`, `components`, `security`, `issuetype`) carry
   `name`, not `value` (externally grounded, HIGH confidence). The
   adjacent write-side item originally flagged in this pass
   (`find_option_match`/`resolve_option_value` in
   `src/cli/issue/field_resolve.rs` falling back to `av.name`) was
   **REMOVED from scope** after a fresh-context audit REFUTED its
   reachability: the orchestrator verified in code that
   `dispatch_field_value` (`src/cli/issue/field_resolve.rs`) matches on
   `meta_field.schema.field_type` and only reaches
   `resolve_option_value`/`find_option_match` for `"option"` (the hinted
   `:option` composer's entry gate, EC-3.4.027-1, likewise admits only
   `"option" | "option-with-child"`). Real Jira system fields report
   `schema.type` `priority`/`resolution`/`issuetype`/`securitylevel`, so
   `--field Priority=High` fails earlier via `unsupported_field_type_error`
   and never reaches value-only matching — corroborated by
   `tests/issue_edit_field.rs::test_bc_3_4_017_field_priority_without_flag_does_not_trigger_gate_b`,
   which mocks priority as a custom `"string"` field. `field_resolve.rs`
   is therefore removed from this item's modified-files list (retained
   only as a dependent/unchanged reference file). The resulting capability
   gap — the bare, un-hinted `--field NAME=VALUE` form cannot set
   system-typed fields; the `:id`/`:name` hinted-bypass composers
   (BC-3.4.028/029) already can — is a separate concern, tracked as a
   follow-up (see Deferred / Follow-up section below), not folded into
   #861.
3. **#583 — `jr api --query-param NAME=VALUE`.** No BC exists for `jr api`
   today. `normalize_path` (`src/cli/api.rs`) passes the path through
   verbatim; there is no query-string assembly or encoding layer. `url`
   and `urlencoding` are already direct dependencies (Cargo.toml), so no
   new external dependency is introduced.

Bug-fix intent (items 1–2 are confirmed defects against documented/expected
behavior; item 3 is a capability gap with an existing precedent-backed
design, filed here as a bug-fix-adjacent quickfix per the human's bundling
decision, not a net-new feature). **[CORRECTED 2026-09-29, F3 human gate,
D-390: this "non-breaking scope for all three" framing is INACCURATE and
superseded.** STORY-A (#862) ships as a BREAKING CHANGE, human-confirmed at
the F3 gate — today the no-project case is rejected by clap with exit 2;
after the fix, jr's own path exits 64. Invocations that give the project
only through the global flag or a configured default currently error; after
the fix they succeed. STORY-A's CHANGELOG entry uses a `**Breaking:**`
prefix. STORY-C (#583) and STORY-B (#861) remain non-breaking.**
Feature type: backend (all three are CLI/API-layer, no UX/visual surface). Severity:
LOW-MEDIUM (all have workarounds — `--project` can be set via `.jr.toml`
per-invocation as a stopgap for #862, `jr api` GET on the `/option`
enumeration endpoint or reading `id` directly works around #861, and
pre-encoding a query string onto the path is #583's existing workaround).

## Spec Changes

F2 (spec evolution) is **recommended REQUIRED** for this cycle — see
`phase-f1-delta-analysis/delta-analysis.md` §"F2 Scope" for the full
amendment list:

- BC-X.7.002 (`cross-cutting.md`) — additive amendment: document the
  local/global/config-default `--project` resolution order for
  `user list`, mirroring the existing `component`/`field` precedent
  language.
- BC-X.14.001 and BC-X.14.003 (`cross-cutting.md`) — text amendment: label
  resolution is `value`, else `name` (read-side only, per D-378); `AllowedValue.name`'s
  "unused in v1" doc comment in `src/types/jira/editmeta.rs` becomes
  stale and must be corrected in the same burst. No BC-3.4.016 amendment —
  the write-side `find_option_match` name-fallback is REMOVED from scope
  (RESOLVED at the F1 gate, 2026-09-24: reachability refuted; see Summary
  item 2 and Deferred / Follow-up).
- **New BC subsection** for `jr api --query-param` (issue #583) — no
  existing `jr api` BC file; F2 must decide dedicated-file vs.
  cross-cutting-subsection sizing (BC-X.14's own precedent note applies:
  "Sized and filed as a Cross-Cutting subsection... not a new numbered
  section file" — likely the same disposition here, `BC-X.16` or similar,
  pending F2's own numbering pass).

## Living Spec Snapshot

Not applicable yet — no spec change has been written; F2 is the phase that
produces it, contingent on F1-gate approval of scope.

## Deprecations (if any)

None.

## Tech Debt Created

None. The write-side `find_option_match`/`resolve_option_value`
name-fallback question (previously an open item pending F2) was RESOLVED
at the F1 gate (2026-09-24): reachability was refuted by code audit, so
there is no write-side defect to defer as tech debt for #861. The
genuinely separate capability gap this audit surfaced (`--field` cannot
set system-typed fields at all) is recorded below as a Deferred /
Follow-up item, not as tech debt created by this cycle.

## Deferred / Follow-up

- **`--field` cannot set system-typed fields (priority/resolution/issuetype/securitylevel → unsupported type error).**
  Surfaced during the F1 human gate's fresh-context audit of #861's
  originally-proposed write-side fix. This is a distinct capability gap
  from #861 (which is a read-side display-label defect) — `--field
  Priority=High` fails via `unsupported_field_type_error` before any
  option-matching logic runs, for any Jira system field whose
  `schema.type` is `priority`/`resolution`/`issuetype`/`securitylevel`.
  **Explicitly NOT in scope for cycle-014.** Suggested drift-item ID:
  `FIELD-SYSTEM-TYPES-UNSUPPORTED` (LOW priority) — final ID to be
  assigned by state-manager.

## Governance Policies Adopted

None.

## Notes

**Phase F1 (delta analysis): APPROVED, "Approve, as corrected" (2026-09-24,
D-379 pending mint by state-manager).** F1 artifacts:
`phase-f1-delta-analysis/delta-analysis.md`,
`phase-f1-delta-analysis/affected-files.txt`. All Open Questions from the
delta-analysis report are RESOLVED as follows:

1. **D-378 scope wording — RESOLVED.** #862 (full) + #861 READ-SIDE ONLY +
   #583 (full). Three parallel-wave-eligible S stories: STORY-A = #862,
   STORY-B = #861 read-side, STORY-C = #583.
2. **#861 write-side scope — RESOLVED: REMOVED from scope.** The
   fresh-context audit REFUTED the write-side item's reachability (see
   Summary item 2 above for the code-level verification). Not deferred to
   a follow-up story — the underlying concern is a different, separate
   capability gap, tracked under Deferred / Follow-up as
   `FIELD-SYSTEM-TYPES-UNSUPPORTED`.
3. **#861 output-shape caution — RESOLVED: accepted without change.**
   `field options --output json`'s `label` changing from `null` to a
   string for system fields is a bug fix, not a breaking change.
4. **#583 nature vs. bundling — RESOLVED: confirmed YES.** #583 stays
   bundled in this bug-fix-intent cycle.
5. **#583 BC filing — RESOLVED: deferred to F2** as a cross-cutting
   subsection, per BC-X.14's own precedent.
6. **#583 design defaults — RESOLVED: all four accepted** (merge with
   existing `?`, allow repeated same-name params, encode raw values
   exactly once, method-orthogonal).
7. **Story split — RESOLVED: confirmed 3 stories (A/B/C),
   parallel-wave-eligible**, per item 1 above (B is now read-side only).
   **[SUPERSEDED 2026-09-25, F2 human review: parallel-wave eligibility was
   revisited and replaced with serial delivery A → C → B — see the dated
   amendment note in the Notes section below.]**
8. **`user_list_requires_project_flag` test name — RESOLVED: no rename.**
   Acknowledged, name stays as-is.

**Audit finding folded in (item 4 of the human gate decision, 2026-09-24):**
`src/cli/api.rs` and `src/cli/user.rs` are added to this cycle's planned
`.cargo/mutants.toml` `examine_globs` additions, in scope for F6 targeted
hardening. `.cargo/mutants.toml` is now listed as a modified file (see
`phase-f1-delta-analysis/delta-analysis.md` Files Changed and
`phase-f1-delta-analysis/affected-files.txt`).
**(amended at F2: per-story F4 timing adopted by human decision D-382,
2026-09-25; supersedes the F1 F6 placement)**

**(amended at F2, 2026-09-25, human decision, F2 review; D-381): delivery order changed from the single
parallel wave accepted at the F1 gate (item 7 above, Open Question 7) to
SERIAL delivery, A → C → B — STORY-A (#862) first, then STORY-C (#583)
rebased on STORY-A, then STORY-B (#861) rebased on STORY-C. Reason: all
three stories touch `src/cli/mod.rs` and `README.md`; STORY-A and STORY-C
additionally both touch `src/main.rs`, `.cargo/mutants.toml`, and
`docs/specs/cargo-mutants-policy.md`. This supersedes every
"parallel-wave-eligible" / "single wave" framing elsewhere in this
manifest and in `prd-delta.md`.)**

**Phase sequence:** F1 (APPROVED) → **F2 (next — spec evolution:
BC-X.7.002 amendment, BC-X.14.001/003 amendment read-side only, new `jr
api` BC cross-cutting subsection)** → F3 (3 incremental stories,
dependency-free, single wave) → F4 (delta implementation) → F5 (scoped
adversarial on the diff) → F6 (targeted `cargo mutants --in-diff`
hardening on the diff scope, including the `src/cli/api.rs` /
`src/cli/user.rs` `examine_globs` additions) → F7 (delta convergence +
human close gate). **(amended at F2, 2026-09-25; D-381/D-382 — see the
amendment note above, which supersedes this paragraph's original
"dependency-free, single wave" / F6 `examine_globs` placement with the
serial STORY-A→STORY-C→STORY-B ordering and per-story F4 timing.)**

Next: F2 (spec evolution). D-379 to be minted by state-manager recording
this F1 gate outcome.

**(progress note, 2026-09-28, state-manager checkpoint burst):** F3 adversarial
story review passes 3, 4, and 5 completed, all NOT CLEAN (pass 3: 1H/1M/3L/2C;
pass 4: 1M/8L/2C; pass 5: 4L); fixes applied to the 3 story files plus
`dependency-graph-extended.md`/`wave-schedule.md`/`wave-holdout-scenarios.md`;
clean-pass counter reset to 0/3, pass 6 in progress; 3 new process-gap
candidates recorded (#14-16, now 16 total in `process-gaps.md`). See
`STATE.md` v4.99 (`CYCLE-014-F3-ADV-REVIEW-CHECKPOINT-2026-09-28`) for full
detail.

**(progress note, 2026-09-28, state-manager checkpoint burst D-386):** F3 adversarial story review passes 6 and 7 completed, both NOT CLEAN (pass 6: 2M/6L/1C; pass 7: 7L/1C); fixes applied. Human decision `D-386` (2026-09-28): non-convergence over 7 passes (0/3 clean, recurring VP-pin carry-through defect class) resolved by switching stories to bind VP clauses by reference — AC Test lines cite exact VP sub-clauses plus a normative binding-not-narrowing sentence, pin checklists replaced by clause-level maps; all 3 F3 stories bumped to v2.0 under this pattern. `D-385`'s STANDARD 3-consecutive-clean rule continues to apply. Clean-pass counter remains 0/3; pass 8 in progress. 2 new process-gap items recorded (#17-18, now 18 total in `process-gaps.md`). See `STATE.md` v5.00 (`CYCLE-014-F3-D386-CHECKPOINT-2026-09-28`) for full detail.

**(progress note, 2026-09-28, state-manager checkpoint burst D-387):** D-387 (2026-09-28, human): F3 story loop still non-converging after D-386 (10 passes, 0/3 clean; hand-written clause maps drifted from AC citations). Clause maps deleted; AC `[CC:L<s>-<e>]` citations are the single ownership record; each story declares `## Coverage Scope (D-387)` with `[SCOPE:]`/`[EXCLUDE:]` spans; coverage verified mechanically by a read-only script (scratchpad d387_coverage.py + d387_changed_lines.py, checking every cycle-014-changed spec line against git diff bdd92e57) — final run: A PASS, C PASS, B PASS after L2720 listed. Strict 3-consecutive (D-385) continues. F3 adversarial story review passes 8, 9, and 10 completed, all NOT CLEAN (pass 8: 1M/4L/3C; pass 9: 10L/3C; pass 10: 4M/9L/3C); fixes applied in-place. D-387 applied post-pass-10: all 3 stories bumped to v3.x; mechanical coverage script confirms PASS for all three. Clean-pass counter remains 0/3; pass 11 in progress. 2 new process-gap items recorded (#19-20, now 20 total in `process-gaps.md`). See `STATE.md` v5.01 (`CYCLE-014-F3-D387-CHECKPOINT-2026-09-28`) for full detail.

**(progress note, 2026-09-28, state-manager checkpoint burst, revision-history split):** F3 adversarial story review passes 11, 12, and 13 completed, all NOT CLEAN (pass 11: 1H/1M/4L/1C; pass 12: 4L/2C; pass 13: 4L/2C) — severity trended down to LOW-only since pass 12. Pass-13 fixes: warm-cache refetch mechanism naming, M3 never-drop test naming, and the AC-002/AC-008 labels on STORY-C. Passes 11-12 also ran a citation-verifiability sweep: every `[CC:]` citation is now either verified by an owned cell or explicitly labelled informational with a named enforcement mechanism. Orchestrator structural decision (2026-09-28, no new `D-NNN` — not a human decision): every in-body Revision Note section is moved verbatim out of the story body into a non-normative sibling `*.revision-history.md` file per story, removing the stale-history-contradiction finding class; stories now v4.0 (A 704 lines, C 907, B 539), bringing token budgets to roughly 11-20% of context. Strict 3-consecutive (D-385) continues, unaffected. Clean-pass counter remains 0/3; pass 14 in progress. 2 new process-gap items recorded (#21-22, now 22 total in `process-gaps.md`). Input-hash frontmatter refreshed on the 6 F3 files (two passes) and on `process-gaps.md`. See `STATE.md` v5.02 (`CYCLE-014-F3-REVHIST-CHECKPOINT-2026-09-28`) for full detail.

**(progress note, 2026-09-28, state-manager checkpoint burst, D-388):** F3 adversarial story review passes 14, 15, and 16 completed, all NOT CLEAN (pass 14: 3L/3C; pass 15: 1L/4C; pass 16: 2M/5L/4C); fixes applied in-place, all 3 stories now v4.3. Pass-16 notable fixes: subsystem anchors for STORY-A and STORY-C corrected to SS-01 + SS-02 (`src/main.rs` is owned by SS-01 per `ARCH-INDEX.md`, and both stories functionally edit a `src/main.rs` dispatch arm), and STORY-C's `target_module` list now includes `src/main.rs`. Human decision **D-388** (2026-09-28): at pass 16, the human was offered an accept-after-1-clean-pass exception (in the style of `D-383`'s F2-only override) and declined it — the human chose to KEEP the STANDARD strict 3-consecutive-clean-pass rule, reaffirming `D-385` unchanged. Clean-pass counter remains 0/3; pass 17 in progress. See `STATE.md` v5.03 (`CYCLE-014-F3-D388-CHECKPOINT-2026-09-28`) for full detail.

**(progress note, 2026-09-28, state-manager checkpoint burst, pass-17 + sentence-level sweep):** F3 adversarial story review pass 17 completed, NOT CLEAN (4L/2C); fixes applied in-place, all 3 stories now v4.4. Beyond the pass-17 fixes, this burst also ran a sentence-level completeness sweep of every cited clause across the 3 stories: every sentence of every `[CC:]`-cited clause is now either (a) verified by an owned test/scenario cell, or (b) explicitly labelled informational and paired with a named enforcement mechanism (test/script/compiler guarantee) per the `#21` pattern. The sweep added labels: STORY-A +7, STORY-B +7, STORY-C +13 (27 total). Also this burst: process-gap `#17` was reclassified from "suspected hook defect" to a documentation/format-discoverability gap — the `validate-trajectory-tail-cell-completeness` hook's earlier "false positive" was root-caused as a literal-format mismatch (the hook requires the unquoted, hyphenated `trajectory-tail →N→N→N→N` substring, not a `trajectory_tail`-labelled or backtick-separated value); the hook behaved correctly. Clean-pass counter remains 0/3; pass 18 in progress. Input-hash frontmatter refreshed on the 6 F3 files (two passes) and on `process-gaps.md`. See `STATE.md` v5.04 (`CYCLE-014-F3-PASS17-CHECKPOINT-2026-09-28`) for full detail.

**(progress note, 2026-09-28, state-manager checkpoint burst, pass-18 + pass-19):** F3 adversarial story review pass 18 completed, NOT CLEAN (4L/2C), and pass 19 completed, NOT CLEAN (5L/1C); fixes applied in-place both times, all 3 stories now v4.6. Notable: pass 19 caught Task 8 in STORY-A pointing the implementer at the test substrings instead of the full pinned `--help` string — fixed byte-for-byte to `BC-X.7.002` Fix step 1, enforced at PR review. Clean-pass counter remains 0/3; pass 20 in progress. Input-hash frontmatter refreshed on the 6 F3 files (two passes, stable on the second). A concurrent read-only adversarial review was in progress during this checkpoint burst; state-manager made no story body-text edits — pass-18/pass-19 fixes were applied by separate story-writer/adversarial-fix bursts this checkpoint records after the fact. See `STATE.md` v5.05 (`CYCLE-014-F3-PASS19-CHECKPOINT-2026-09-28`) for full detail.

**(progress note, 2026-09-28, state-manager checkpoint burst, pass-20 + pass-21):** F3 adversarial story review pass 20 completed, NOT CLEAN (4L), and pass 21 completed, NOT CLEAN (4L); fixes applied in-place both times, all 3 stories now v4.8. Notable: pass 20 caught STORY-A's Task 14 CHANGELOG instruction stating the behavior change backwards — it said global-only invocations now exit 64, when in fact global-only (and configured-default-only) invocations now succeed (only the fully-unresolvable-project case newly exits 64) — corrected to match `BC-X.7.002`'s actual Fix behavior. Clean-pass counter remains 0/3; pass 22 in progress. Input-hash frontmatter refreshed on the 6 F3 files (two passes, stable on the second). A concurrent read-only adversarial review was in progress during this checkpoint burst; state-manager made no story body-text edits — pass-20/pass-21 fixes were applied by separate story-writer/adversarial-fix bursts this checkpoint records after the fact. See `STATE.md` v5.06 (`CYCLE-014-F3-PASS21-CHECKPOINT-2026-09-28`) for full detail.

**(progress note, 2026-09-28, state-manager checkpoint burst, pass-22 + pass-23):** F3 adversarial story review pass 22 completed, NOT CLEAN (6L/1C), and pass 23 completed, NOT CLEAN (4L/1C); fixes applied in-place both times, all 3 stories now v5.0. Notable: pass 22 caught a real test gap — the `-q k=` wire output was untested — closed with a pinned example added; STORY-C's tally is now 45/41/3/1 → 41/44 (direct-call 23 / subprocess 22). Pass 23's fixes included cross-story pattern sweeps (fault-model citation scoping; multi-sided clause attribution). Clean-pass counter remains 0/3; pass 24 in progress. Input-hash frontmatter refreshed on the 6 F3 files (two passes, stable on the second). A concurrent read-only adversarial review was in progress during this checkpoint burst; state-manager made no story body-text edits — pass-22/pass-23 fixes were applied by separate story-writer/adversarial-fix bursts this checkpoint records after the fact. See `STATE.md` v5.07 (`CYCLE-014-F3-PASS23-CHECKPOINT-2026-09-28`) for full detail.

**(progress note, 2026-09-28, state-manager checkpoint burst, pass-24 + pass-25 + pass-26):** F3 adversarial story review pass 24 completed, NOT CLEAN (1L/2C); pass 25 completed, NOT CLEAN (1M/1L/1C); and pass 26 completed, NOT CLEAN (1M/3L/2C); fixes applied in-place all three times, all 3 stories now v5.3. Pass-24 fixes: exclusive-or-negative fault-attribution claims rewritten as non-exclusive positive claims, swept across all stories. Pass-25 fix: STORY-B's EC-12 matrix cells are now asserted at both tree levels, per `VP-580-013(1)`. Pass-26 fix: generator properties pinned behind proptest kill claims in STORY-C, with a cross-story sweep. Recorded new process-gap **`#23`** (now 23 total in `process-gaps.md`): fixes were applied only to the story where a finding was reported and not swept across sibling stories, so the same defect class resurfaced in a sibling one pass later (pass-25's STORY-B proptest-generator pin recurred as a STORY-C gap at pass-26; `P22-001`'s fault-model-scoping fix recurred as sibling `P23-002`); remediation already adopted from pass 26 onward — every fix burst now sweeps each finding's pattern across all sibling stories. Clean-pass counter remains 0/3; pass 27 in progress. Input-hash frontmatter refreshed on the 6 F3 files (two passes, stable on the second) and on `process-gaps.md` (two passes, stable on the second). A concurrent read-only adversarial review was in progress during this checkpoint burst; state-manager made no story body-text edits — pass-24/pass-25/pass-26 fixes were applied by separate story-writer/adversarial-fix bursts this checkpoint records after the fact. See `STATE.md` v5.08 (`CYCLE-014-F3-PASS26-CHECKPOINT-2026-09-28`) for full detail.

**(progress note, 2026-09-28, state-manager checkpoint burst, pass-27 + pass-28):** F3 adversarial story review pass 27 completed, NOT CLEAN (3L/1C), and pass 28 completed, NOT CLEAN (3L/1C); fixes applied in-place both times, all 3 stories now v5.5 (up from v5.3). Pass-27 fixes: removed unverified exhaustive "ONLY" claims across all stories; demoted holdout-as-enforcement citations to "see also". Pass-28 fixes: corrected an overclaim about what a pre-existing test asserts; added a mechanical `inputs:` completeness sweep, which added 9 missing input paths across the 3 stories. No new process-gap this burst (remains 23 total in `process-gaps.md`). Clean-pass counter remains 0/3; pass 29 in progress. Input-hash frontmatter refreshed on the 6 F3 files (two passes each, stable on the second) — the 3 stories' hashes changed this time because their `inputs:` lists grew via the pass-28 sweep, and the 3 sibling files' hashes changed in turn since they reference the stories; `process-gaps.md` was NOT touched this burst. A concurrent read-only adversarial review was in progress during this checkpoint burst; state-manager made no story body-text edits — pass-27/pass-28 fixes were applied by separate story-writer/adversarial-fix bursts this checkpoint records after the fact. See `STATE.md` v5.09 (`CYCLE-014-F3-PASS28-CHECKPOINT-2026-09-28`) for full detail.

**(progress note, 2026-09-28, state-manager checkpoint burst, pass-29 + pass-30):** F3 adversarial story review pass 29 completed, NOT CLEAN (2L), and pass 30 completed, NOT CLEAN (1L/1C); fixes applied in-place both times, all 3 stories now v5.7 (up from v5.5). Pass-29 fixes: a prose postcondition number was corrected; a dead architecture-doc reference was replaced with ARCH-INDEX in all 3 stories; a clause-number sweep checked ~280 citations and a path-existence sweep checked 49 paths. Pass-30 fixes: an informational-label sweep — testable sentences that had been labelled informational were relabelled to their observing cells or cross-references; a drifted test-line citation was converted to symbol form. No new process-gap this burst (remains 23 total in `process-gaps.md`). Recorded a new drift item in `cycles/OPEN-STANDING-ITEMS.md` (`LEGACY-STORIES-STALE-ARCH-DOC-CITE`): 18 legacy stories outside cycle-014 still cite the non-existent `architecture/module-decomposition.md`/`architecture/dependency-graph.md`, targeted for a future maintenance sweep. Clean-pass counter remains 0/3; pass 31 in progress. Input-hash frontmatter refreshed on the 6 F3 files (two passes each, stable on the second) — the 3 stories' hashes were already current (refreshed by the pass-29/30 fix bursts themselves); the 3 sibling files' hashes changed in turn since they reference the stories; `process-gaps.md` was NOT touched this burst. A concurrent read-only adversarial review was in progress during this checkpoint burst; state-manager made no story body-text edits — pass-29/pass-30 fixes were applied by separate story-writer/adversarial-fix bursts this checkpoint records after the fact. See `STATE.md` v5.10 (`CYCLE-014-F3-PASS30-CHECKPOINT-2026-09-28`) for full detail.

**(progress note, 2026-09-28, state-manager checkpoint burst, pass-31 + pass-32):** F3 adversarial story review pass 31 completed, NOT CLEAN (2M/5L/1C), and pass 32 completed, NOT CLEAN (2M/4L); fixes applied in-place both times. Pass-31 response: every story relabelled with the O/N/U scheme (**O** observed by named test / **N** not runtime-observable with a named mechanism / **U** observable, no cell by design), all 3 stories bumped to v6.0; in-story Revision History collapsed to a pointer at the sibling `*.revision-history.md` file; an `inputs:` re-sweep run across the 3 stories. Pass-32 fixes: tightened the O/N/U label rules and the N-vs-U boundary, with a ban on implicit O; every CC citation in STORY-C labelled explicitly (107/107); corrected STORY-C's token-budget figure (~50k/28%). All 3 stories now v6.1. Recorded 2 new process-gap items (**`#24`**, **`#25`** — now 25 total in `process-gaps.md`): the O/N/U label-ambiguity finding (sources `ADV-C14-F3-P31-002`, `P32-003`, `P32-006`) and the token-budget double-counting finding (source `ADV-C14-F3-P32-001`). Clean-pass counter remains 0/3; pass 33 in progress. Input-hash frontmatter refreshed on the 6 F3 files (`inputs:` lists grew this burst, so hashes changed as expected) and on `process-gaps.md` (stable after one update pass). A concurrent read-only adversarial review was in progress during this checkpoint burst; state-manager made no story body-text edits beyond input-hash frontmatter — pass-31/pass-32 fixes were applied by separate story-writer/adversarial-fix bursts this checkpoint records after the fact. **Observed anomaly (state-manager, this burst):** `S-cycle14-api-query-param.md` and `dependency-graph-extended.md` cite each other in their own `inputs:` frontmatter (a genuine circular reference, not a one-way chain), so their input-hashes — and the downstream hashes of `wave-schedule.md`/`wave-holdout-scenarios.md` — did not stabilize after 2 update passes; a 3rd exploratory pass confirmed continued drift. Recorded here for awareness only, not added as a new process-gap item (out of scope for this burst's instructions); flagged to the orchestrator/human for a future disposition. See `STATE.md` v5.11 (`CYCLE-014-F3-PASS32-CHECKPOINT-2026-09-28`) for full detail.

**(progress note, 2026-09-29, state-manager session-wrap checkpoint, D-389):** At F3 pass 33 (0/3 clean after 33 passes), the human directed research to validate assumptions. Research found this cycle's review bar was stricter than the factory's own. The factory's bar:
- clause-level BC traceability (story-template L60-71);
- CLEAN = nitpicks/refinements only (VSDD.md L242; phase-2 lobster 'cosmetic only');
- 10-pass cap then human escalation (adversary.md ~L205; adversarial-review SKILL L186-188);
- F5 treats LOW as non-blocking.

Decision: return to the factory rules. Sentence-level O/N/U labels and D-387 line-span coverage are retained as NON-BLOCKING annotations. F3 adversarial convergence is closed. Final fixes were applied (stories v6.2):
- C Task 2 names the story-added `/x?k=` cell;
- A Task 3 names the `cli.project == Some("L")` assertion;
- the circular `inputs:` between S-cycle14-api-query-param.md and dependency-graph-extended.md is broken (the story no longer lists the graph);
- N→U relabels P33-002/003/005 are applied, and the EC-14 label is split (P33-004);
- C's 2 malformed tags are reworded.

Proceed directly to the F3 human gate. This supersedes `D-385` and `D-388` (strict 3-consecutive-clean) for F3.

Human decision **D-389** (2026-09-29) is recorded in full in `STATE.md`'s Decisions Log. All 3 F3 stories bumped to **v6.2** with the fixes listed above; the circular `inputs:` reference observed at the prior checkpoint is now broken and all 6 F3 files' input-hashes are confirmed STABLE (2 update passes, `--check` clean on all 6). Six new process-gap items recorded (`#26`-`#31` — now 31 total in `process-gaps.md`), each flagged as needing a follow-up story or an explicit deferral decision before cycle-014 closes (S-7.02 checklist), covering: the F3 review-loop definition's three-way conflict across the Feature Mode skill / `feature.lobster` / `feature-sequence.md`; "clean" being undefined against the adversary's own "novel findings through pass 9+"/"zero findings is a prompt bug" language; the fresh-context mandate conflicting with accumulate-invariants guidance; the adversary agent's `model: opus` pin not actually delivering the documented cross-model-family diversity; the unenforced 10-pass cap (33 passes ran with no automatic escalation); and the mathematical non-convergence of a strict 3-consecutive-clean rule under cycle-invented review requirements combined with LLM reviewer false-positive rates (`E[N] ≈ 49` passes at `p=0.7`, `≈1,110` at `p=0.9`). F3 adversarial story review is now CLOSED per `D-389`; **NEXT: the F3 human approval gate** (3 stories, dependency graph, conflicts, 16-pts serial `A→C→B` estimate, structured review questions), then F4 serial delivery `A→C→B` per `per-story-delivery.md`. **Known blocker ahead of F4 PRs:** the GitHub MCP server fails auth ("Authorization header is badly formatted") — the user should re-authenticate it, or `pr-manager`/`github-ops` should fall back to the `gh` CLI. See `STATE.md` v5.12 (`CYCLE-014-F3-D389-CHECKPOINT-2026-09-29`) for full detail.

**(2026-09-29, F3 human gate, D-390 — APPROVED):** Human decision **D-390**
("Approve, A breaking") APPROVES the cycle-014 3-story package, delivered
SERIALLY `A -> C -> B`, 16 pts total: `S-cycle14-user-list-project-resolution`
(STORY-A, `#862`, 3 pts, 11 ACs), `S-cycle14-api-query-param` (STORY-C, `#583`,
8 pts, 11 ACs), `S-cycle14-field-options-name-label` (STORY-B, `#861`, 5 pts,
9 ACs). **The human explicitly confirmed STORY-A ships as a BREAKING CHANGE:**
today the no-project case is rejected by clap with exit 2; after the fix,
`jr`'s own path exits 64. Invocations that give the project only through the
global flag or a configured default currently error; after the fix they
succeed. STORY-A's CHANGELOG entry uses a `**Breaking:**` prefix. STORY-C and
STORY-B remain non-breaking. This corrects the "no breaking change" /
"Non-breaking scope for all three" framing at the version-header note and in
the Summary section above (both marked `[CORRECTED 2026-09-29, F3 human gate,
D-390]`) — the release bump shape is now MINOR-or-breaking-flagged rather
than three PATCH-shaped fixes; the final version-bump decision stays at
release.

**Pre-gate evidence recorded:** a fresh-context consistency audit (2026-09-29)
returned PASS-WITH-FINDINGS — one MAJOR (this manifest's stale
non-breaking framing at L5/L100, now fixed by this burst) and one MINOR
(stale frontmatter `status:`, now fixed to `f3-approved`); the 3 story files
themselves were clean (clause-level BC traceability, 8/8 VPs mapped 1:1,
`A -> C -> B` ordering consistent across all artifacts, points/AC counts
consistent, all `src/` symbols verified). An input-drift check (2026-09-29)
was CLEAN — all 8 hash-governed cycle-014 files MATCH. An out-of-scope
repo-wide input-hash scan observation (`TOTAL=304 MATCH=20 STALE=262
NOINPUT=22`, entirely in cycles 001-013 / the flat `.factory/stories/`
directory / root-level `phase-f1`/`f2`/`f7` dirs, none touching cycle-014)
is recorded as a new drift item in `cycles/OPEN-STANDING-ITEMS.md`, targeted
for the next maintenance sweep.

Status frontmatter updated `f2-approved-f3-drafted` -> `f3-approved`. All 3
F3 story files' `status:` frontmatter moved `draft` -> `ready`; the 3
corresponding `STORY-INDEX.md` rows (Story Manifest + Feature Followup
tables) moved `draft` -> `ready` in the same burst (`STORY-INDEX.md`
v1.6.29 -> v1.6.30, `total_stories` unchanged at 194). **NEXT: F4 serial
delivery `A -> C -> B`** per `per-story-delivery.md`, starting with STORY-A
(`S-cycle14-user-list-project-resolution`). See `STATE.md` v5.13
(`CYCLE-014-F3-D390-APPROVED-2026-09-29`) for full detail.

**(2026-09-29, F4 STORY-A delivered, D-391):** **STORY-A**
(`S-cycle14-user-list-project-resolution`, `#862`, 3 pts, 11 ACs,
**BREAKING**) is DELIVERED — squash-merged to `develop` as **PR #886**
("fix(user)!: resolve user list --project from configured default, exit 64
when none (#862) (#886)"), merge commit `2d8467c4d7627ae186b02617520c864a55d09296`,
mergedAt 2026-09-29T18:49:19Z. `develop` moved `204b1fb5 -> 2d8467c4`; the
remote and local `fix/user-list-project-resolution` branches and the story
worktree are deleted. pr-manager's 9-step flow: security review 0 findings;
`pr-reviewer` 1 cycle / 2 independent fresh-eyes reviews, both APPROVE with
0 blocking findings (7 non-blocking observations accepted or deferred); CI
24/24 green including CI Gate.

**Merge-gate gap observed:** the merge landed with **NO approving review**
(`reviewDecision` empty; the only review was a COMMENTED review by
`Zious11`, since GitHub rejects self-approval) — root cause: `develop`'s
branch protection sets `require_code_owner_reviews=true` but
`required_approving_review_count=0`, so the code-owner requirement was not
actually enforced at merge time. No `--admin` flag or other bypass was
used; the orchestrator had intended pr-manager to stop at merge-ready for
human sign-off, and it did not.

**Human decision D-391** (2026-09-29): **ACCEPT the PR #886 merge as-is.**
Branch protection stays UNCHANGED (not flipped to
`required_approving_review_count=1` or similar). Standing policy for this
pipeline going forward: **pr-manager MAY merge autonomously once ALL of
these hold** — (1) the story has passed its Step 4.5 adversarial
convergence; (2) the PR review convergence is APPROVE with 0 blocking
findings; (3) the security review is clean; (4) `ci-gate` is green. Human
words: "Merging it is fine once it's passed all the Adversarial reviews."
Any PR that has not met all four conditions must still stop at
merge-ready for the human. Full text recorded in `STATE.md`'s Decisions
Log (`D-391`).

Process-gap `#34` recorded in `process-gaps.md`: pr-manager's merge-gate
logic relies on GitHub branch protection to actually block unapproved
merges, and does not detect when protection is configured so that it
enforces nothing — resolved for this project by `D-391`'s explicit
autonomous-merge policy; engine follow-up flagged for `vsdd-factory`.

Cycle-014 progress: **1 of 3 stories delivered** (STORY-A). STORY-C
(`S-cycle14-api-query-param`, `#583`, 8 pts) and STORY-B
(`S-cycle14-field-options-name-label`, `#861`, 5 pts) remain queued, serial
`A -> C -> B` per `D-381`. **NEXT:** begin STORY-C — worktree
`.worktrees/S-cycle14-api-query-param`, branch `feat/api-query-param`, at
`2d8467c4`, no upstream yet; Red Gate stubs in progress. See `STATE.md`
v5.15 (`CYCLE-014-STORY-A-MERGED-D391-2026-09-29`) for full detail.

**(2026-09-30, F4 STORY-C delivered):** **STORY-C**
(`S-cycle14-api-query-param`, `#583`, 8 pts, 11 ACs, non-breaking) is
DELIVERED — squash-merged to `develop` as **PR #887** ("feat(api): add
repeatable -q/--query-param NAME=VALUE to jr api (#583) (#887)"), merge
commit `e54be670cf77cb9220e1aad7e3826c66de908923`, mergedAt
2026-09-30T03:57:04Z. `develop` moved `2d8467c4 -> e54be670`; the remote and
local `feat/api-query-param` branches and the story worktree are deleted.
pr-manager's gates: security review APPROVE (0 CRITICAL/HIGH/MEDIUM, 2 LOW
informational notes — unbounded `-q` count/length is local-arg-only,
repeated-NAME non-dedup is by design); `pr-reviewer` 1 cycle, APPROVE with 0
blocking findings (2 suggestions + 3 nits, non-blocking); CI 24/24 green
including Windows (the known 5s held-stdin flake did not trigger). All four
`D-391` autonomous-merge conditions HELD.

**Why the merge was manual, not autonomous:** pr-manager's dispatch of the
merge action was **DENIED by the Claude Code auto-mode permission
classifier** — a harness-level permission gate, distinct from and
unrelated to `D-391`'s content-based autonomous-merge policy (which
concerns WHEN a merge is authorized, not the mechanics of executing one).
pr-manager correctly stopped without attempting to work around the denial,
and the human (`Zious11`) merged PR #887 by hand. **Operating note for the
rest of this pipeline** (recorded in `STATE.md`): until the human adds a
permission rule authorizing the merge action, `pr-manager` must STOP at
merge-ready (all four `D-391` gates green) and hand off to the human for
the merge click — it must not attempt the merge action itself. This is a
first-class terminal state for `pr-manager`'s playbook, not an error
condition.

Process-gap `#36` recorded in `process-gaps.md`: the harness auto-mode
classifier blocks agent-initiated PR merges even when a human decision
(`D-391`) authorizes autonomous merge; also flags that, before its merge
attempt, `pr-manager` accumulated self-inflicted status-check filler tasks
and routed messages to "team-lead", causing wall-clock delays in both PR
runs (STORY-A's and STORY-C's) — engine follow-up flagged for
`vsdd-factory`.

Cycle-014 progress: **2 of 3 stories delivered** (STORY-A, STORY-C).
STORY-B (`S-cycle14-field-options-name-label`, `#861`, 5 pts) remains
queued. **NEXT:** begin STORY-B — worktree
`.worktrees/S-cycle14-field-options-name-label`, branch
`fix/field-options-name-label`, at `e54be670`, no upstream yet; Red Gate
stubs in progress. See `STATE.md` v5.17
(`CYCLE-014-STORY-C-MERGED-2026-09-30`) for full detail.

**(2026-09-30, F4 STORY-B delivered + F4 COMPLETE):** **STORY-B**
(`S-cycle14-field-options-name-label`, `#861`, 5 pts, 9 ACs, non-breaking)
is DELIVERED — squash-merged to `develop` as **PR #888** ("fix(field): show
system-field option labels via name fallback in `jr field options` (#861)
(#888)"), merge commit `2ee422e0cf15ac5ab94d1077649a64f7dad1169a`, mergedAt
2026-09-30T12:48:06Z. `develop` moved `e54be670 -> 2ee422e0`; the worktree,
local branch, and remote branch are all removed. pr-manager's gates:
security review APPROVE (0 CRITICAL/HIGH/MEDIUM, 0 findings); `pr-reviewer`
1 cycle, APPROVE with 0 blocking findings (1 non-blocking finding — no
wiremock-level end-to-end test of the rendered `#861` output, tracked as
`FIELD-OPTIONS-E2E-RENDER-TEST` — plus 2 nits); CI 24/24 green. All four
`D-391` autonomous-merge conditions HELD.

**Why the merge was manual, not autonomous:** identical to STORY-A's and
STORY-C's precedent — pr-manager's dispatch of the merge action was
**DENIED by the Claude Code auto-mode permission classifier**, a
harness-level permission gate unrelated to `D-391`'s content-based policy.
pr-manager stopped at merge-ready without working around the denial, and
the human (`Zious11`) merged PR #888 by hand.

**Cycle-014 Phase F4 (delta implementation) is now COMPLETE — 3 of 3
stories delivered:** STORY-A (`#886`@`2d8467c4`), STORY-C
(`#887`@`e54be670`), STORY-B (`#888`@`2ee422e0`), serial order `A -> C -> B`
per `D-381` complete.

**Combined wave integration gate** (per-story-delivery.md steps a-f) run
over the full 3-story delta `204b1fb5..2ee422e0` (19 files): **PASSED**.
Full verification (fmt/clippy clean, lib 1562 passed, full suite 5789
passed/0 failed/188 ignored across 131 binaries, release build OK, `cargo
deny` OK, all 4 guard scripts OK; local mutants run skipped — CI's sharded
mutation gate already passed on each PR diff). Adversary on the combined
diff: CLEAN_NITPICK_ONLY (2 nits in `tests/common/hermetic.rs`, no
cross-story defects). Code-reviewer: APPROVE, 0 blocking (1 SHOULD-FIX —
`jr_cmd`/`write_default_profile_config` test-helper duplication across two
test files — plus nits). Security review: 0 CRITICAL/HIGH (SEC-001 MEDIUM
pre-existing codebase-wide ANSI/control-char table-rendering gap, slightly
widened by `#888`; SEC-002 LOW query-param-under-`--verbose` doc gap).
Consistency-validator: PASS-WITH-FINDINGS (traceability/counts/evidence all
clean; 0 of 37 process-gaps dispositioned, deferred to the S-7.02
cycle-closing checklist; input-hash refreshed this burst). Holdout
evaluation: PASS, all 14 scenarios at 1.0, mean 1.00. Full gate report:
`cycles/cycle-014/wave-integration-gate.md`.

**Process deviation recorded** (process-gap `#37`): per-wave integration
gates after Wave 1 (STORY-A) and Wave 2 (STORY-C) were NOT run — the
orchestrator moved straight to the next story each time, given the serial
one-story-per-wave schedule. One combined gate over all 3 waves was run
this burst to compensate; see `process-gaps.md` for the full finding and
recommended `per-story-delivery.md` fix.

**NEXT:** Phase **F5 scoped adversarial review** of the delta
`204b1fb5..2ee422e0` (adversary + code-reviewer + security-reviewer loop, 3
clean passes, 10-pass cap). Pending human decision before or during F5:
whether SEC-001 (pre-existing, codebase-wide ANSI/control-char
table-rendering gap) is fixed in this cycle or deferred. See `STATE.md`
v5.19 (`CYCLE-014-F4-COMPLETE-2026-09-30`) for full detail.

**(2026-09-30, F5 STARTED, human decision D-392):** At the start of F5, the
human chose to **FIX SEC-001 inside cycle-014** rather than defer it (human
words: "Fix in cycle-014"), and to "Continue into F5". SEC-001 becomes fix
task **FIX-P5-001**, delivered via `fix-pr-delivery` — F5's first routed
finding. security-reviewer (read-only) ran a design triage settling on:
sanitize inside `src/output.rs::render_table` (the single comfy_table
chokepoint, 9 call sites) via a new `output::sanitize_table_cell`
(`\n` preserved, `\r` stripped, `\t`→space, other C0/C1 controls and
bidi/line-separator overrides stripped, ANSI CSI/OSC consumed fail-closed,
no length cap, never applied to JSON); `jr user list`/`jr user view`'s
Active ✓/✗ coloring moves from ANSI-in-`String` to structural `comfy_table`
`Cell` styling so it survives sanitization. Full triage:
`cycles/cycle-014/phase-f5-adversarial/SEC-001-triage.md`. product-owner
then wrote the spec delta: new `BC-7.1.006` in
`specs/prd/bc-7-output-render.md` (inline `VP-SEC-001-001`), spec `2.4.0`
→ `2.5.0` (`spec-changelog.md` `[2.5.0]` entry), BCs `772` → `773` (bc-7
`97`→`98` cumulative / `53`→`54` individually-bodied), `BC-INDEX.md` and
`CANONICAL-COUNTS.md` updated to match. All four count-guard scripts
(`check-spec-counts.sh`, `check-bc-cumulative-counts.sh`,
`check-bc-citation-symbols.sh`, `check-bc-no-numeric-test-counts.sh`) PASS.
product-owner separately flagged pre-existing, unrelated drift:
`CANONICAL-COUNTS.md`'s "L2 domain-spec bc_count alignment" table row for
bc-7 (~L271) was already stale (read `93`, should already have read `97`,
now further stale at `98`) — not fixed by this burst, recorded as a new
standing item (`CANONICAL-COUNTS-L2-BC7-ALIGNMENT-STALE`). 3 more new
standing items recorded in `cycles/OPEN-STANDING-ITEMS.md`:
`NONTABLE-SERVER-TEXT-SANITIZE` (the 6 non-table server-text sinks, same
CWE class, no shared chokepoint), `SANITIZE-ENV-DISPLAY-C1-GAP`
(`strip_control_and_ansi` misses the same C1 range in the `auth` env
display), and the alignment-row item above. `SEC-001-RENDER-TABLE-ANSI-SANITIZE`'s
existing standing-item entry updated to "IN PROGRESS as FIX-P5-001
(D-392)". A fix worktree already exists at `.worktrees/FIX-P5-001` on
branch `fix/FIX-P5-001` (checked out at `develop`'s current tip
`2ee422e0`, clean, no commits yet). **Spec-only burst — no `src/` changes
this burst.** **F5 status: IN PROGRESS, FIX-P5-001 spec done, implementation
not started.** **NEXT:** implement `FIX-P5-001` in the existing worktree
(failing tests first: proptest + EC-1..EC-12 pins + `format_active`
`Cell`-styling test + end-to-end wiremock check, per
`SEC-001-triage.md` §5/§6) → implementation → PR review + security review
+ demo + PR to merge-ready → human merge (per `fix-pr-delivery`); after
merge, resume the F5 delta adversarial loop over
`204b1fb5..<new develop>` (adversary + code-reviewer + security-reviewer,
3 consecutive clean passes, 10-pass cap). See `STATE.md` v5.20
(`CYCLE-014-F5-D392-FIX-P5-001-SPEC-2026-09-30`) for full detail.

**2026-09-30 (later, `FIX-P5-001` implementation burst):** `FIX-P5-001`
is now implemented on branch `fix/FIX-P5-001` in worktree
`.worktrees/FIX-P5-001`, HEAD `7d289d75` (pushed in parallel with this
burst), 6 commits on top of `develop` `2ee422e0` — stub (`79fea6e9`),
failing RED-gate tests (`0af5f7bb`, 19 RED), `sanitize_table_cell` plus a
shared `sanitize_control_and_ansi_core` wired into `render_table`, plus
`StyledCell`/`render_table_with_styles`/`print_output_with_styles`
(`49a3d8a0`), `format_active` returning the bare glyph with the `user`
Active column recolored via structural `Cell::fg` gated on
`colored::control::SHOULD_COLORIZE` (`af388800`), CHANGELOG `### Security`
+ CLAUDE.md gotcha/Known-Size-Deviations entry for `src/output.rs`
(~1,004 LOC, ~417 prod) (`67aa863d`), and an exact-`\n`-preservation
proptest plus the EC-13 pin (`7d289d75`). Verified: `cargo test --lib`
1,586 passed; full suite 5,845 passed; `clippy`/`fmt` clean; the `auth
list` insta snapshot unchanged. `cargo-mutants` scope unaffected —
`output.rs`/`user.rs` were already in `examine_globs`. Process note
(recorded as process-gap `#38`): the implementer weakened one RED-gate
proptest assertion (`\n` count `==` → `<=`) without stopping first to
report the contradiction; the contradiction was genuine (EC-3 fail-closed
unterminated-CSI/OSC consumption swallows an embedded `\n`), so the
orchestrator accepted it and had `test-writer` restore exact `\n`
preservation as a separate, narrower conditional property. Orchestrator
error recorded honestly (process-gap `#39`): the orchestrator supplied
`product-owner` a wrong EC-13 example literal; `test-writer` caught it
against the real state machine and the orchestrator corrected it.
`product-owner` landed spec `[2.5.1]` (PATCH, uncommitted-then-committed
in this same burst) correcting BC-7.1.006/VP-SEC-001-001 wording to match:
the `\n`-preservation clause split into (i) never-fabricates-`\n` and
(ii) exact-preservation-absent-a-`\n`-inside-a-CSI/OSC-scan-span; new
EC-13 (`"\u{1b}[31;1;9\n"` → `""`, contrasted with
`"\u{1b}[31;1;9\nline2"` → `"ine2"`); EC-12/VP(c) JSON wording changed to
round-trip equality (not byte-for-byte, since JSON escapes C0 controls);
`**Trace**` updated to "implemented in FIX-P5-001, pending merge" plus
the new API-surface citations. BC count unchanged at 773; all 4
count-guard scripts re-verified PASS. 19 demo-evidence files (GIF/WebM/
tape pairs for 5 ACs plus `evidence-report.md`, `mock_server.py`,
`setup.sh`, `fixtures/`) copied from
`.worktrees/FIX-P5-001/docs/demo-evidence/FIX-P5-001/` to
`.factory/demos/FIX-P5-001/`, counts verified matching (19/19). **F5
status: IN PROGRESS.** **NEXT:** `pr-manager` takes the PR to
merge-ready (`pr-reviewer` + security review) → human merges → worktree
cleanup → convert the BC-7.1.006 `**Trace**` citations to live backticked
form → resume the F5 delta adversarial loop over
`204b1fb5..<new develop>` (adversary + code-reviewer + security-reviewer,
3 clean passes, 10-pass cap). See `STATE.md` v5.21 for full detail.

**2026-10-01 (later, `FIX-P5-001` merged burst):** `FIX-P5-001` is now
**MERGED** — PR #891 squash-merged to `develop` by the human at
2026-10-01T03:48:52Z, merge commit `769365ab99be60c92a3494d630c423b962a0509d`;
`develop` moves `2ee422e0 -> 769365ab`; the worktree and local/remote
`fix/FIX-P5-001` branches are removed; `main`'s checkout fast-forwards.
Final CI head `2973ef65`: 24/24 checks green. The PR's scope grew three
times during review, each a human decision: **D-393** (security review 1,
fresh reviewer, SEC-003 HIGH) extended the fix to `jr issue comment
view`'s human output via the `output::sanitize_terminal_text` alias;
**D-394** (security re-review) extended it to `jr issue assign`'s two
`print_success` human-output sites; **D-395** (final security re-review,
SEC-891-2 MEDIUM) extended it to the shared resolver
`helpers.rs::disambiguate_user` (reached from `assign --to`,
`create`/`edit --assignee`, `list --assignee`, and `@mentions`) via a new
`disambiguation_labels` helper, and **froze** the PR's scope going
forward — `--output json`'s error envelope is sanitized too as a
documented spec decision, since it shares the same `JrError::UserError`
message string. Spec `bc-7-output-render.md` progressed
`v2.5.1 -> v2.5.2` (D-393, EC-14) `-> v2.5.3` (D-394, EC-15)
`-> v2.5.4` (D-395, EC-16, JSON decision) `-> v2.5.5` (post-merge:
`**Trace**` citations made live, EC-15/EC-16 pinned-test names
corrected, new `resolve_asset` Out-of-scope residual added). BC count
unchanged 773; VP count unchanged 98 throughout. Full round-by-round
review narrative: `code-delivery/FIX-P5-001/review-summary.md`. The
original security-reviewer dispatch for this PR hung indefinitely and
never returned; the orchestrator dispatched a fresh one, which is the
reviewer that found SEC-003. `pr-manager` also recommended a merge
command referencing wrapper scripts
(`plugins/vsdd-factory/bin/check-stale-verdict.sh`,
`enforce-merge-strategy.sh`) that do not exist in this repo — the
orchestrator corrected it to `gh pr merge 891 --squash --delete-branch`.
Both findings recorded as new process-gap items (`#42`-`#43` below).
`OPEN-STANDING-ITEMS.md`'s `SEC-001-RENDER-TABLE-ANSI-SANITIZE` item is
now marked **RESOLVED** (full text archived to
`cycles/RESOLVED-DRIFT-ITEMS.md`); `NONTABLE-SERVER-TEXT-SANITIZE` is
updated to its final known, non-exhaustive list, including the new
`resolve_asset` (MEDIUM, priority) entry. **F5 status: IN PROGRESS —
FIX-P5-001 delivered.** **NEXT:** the F5 delta adversarial loop over
`204b1fb5..769365ab` (adversary + code-reviewer + security-reviewer,
fresh context, 3 consecutive clean passes required, 10-pass cap);
newly found residuals are tracked, not fixed, unless a human decides
otherwise. See `STATE.md` v5.22 for full detail.
