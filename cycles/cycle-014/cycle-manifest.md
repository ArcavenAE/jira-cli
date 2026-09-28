---
document_type: cycle-manifest
cycle_id: cycle-014-issue-triage-quickfixes
cycle_type: bug-fix
version: TBD — proposed roll into next dev prerelease as three PATCH-shaped fixes (no breaking change); confirm at F1 gate
status: f2-approved-f3-drafted
started: 2026-09-24
completed: null
producer: architect (F1 delta analysis)
---

# Cycle Manifest: cycle-014 (issue-triage-quickfixes)

## Delivered

Not yet started. This manifest is created alongside the F1 delta-analysis
report to hold the cycle's slot and record the pre-approval framing; it will
be updated with real delivery data once the human approves scope at the F1
gate and F4 implementation begins.

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
decision, not a net-new feature). Non-breaking scope for all three. Feature
type: backend (all three are CLI/API-layer, no UX/visual surface). Severity:
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
