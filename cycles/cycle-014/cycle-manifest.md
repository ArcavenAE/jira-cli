---
document_type: cycle-manifest
cycle_id: cycle-014-issue-triage-quickfixes
cycle_type: bug-fix
version: TBD — proposed roll into next dev prerelease as three PATCH-shaped fixes (no breaking change); confirm at F1 gate
status: f1-approved
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
`.cargo/mutants.toml` `examine_globs` additions, added at F4 by the story that
introduces each file (STORY-A: `user.rs`, STORY-C: `api.rs`); F6 verifies.
`.cargo/mutants.toml` is now listed as a modified file (see
`phase-f1-delta-analysis/delta-analysis.md` Files Changed and
`phase-f1-delta-analysis/affected-files.txt`).
**(amended at F2, PASS-28: timing clarified F6→F4 per-story; human to confirm
at F2 gate)**

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
dependency-free, delivered SERIALLY A → C → B, each rebased on the
previous, per the amendment above) → F4 (delta
implementation, including the
per-story `src/cli/api.rs` / `src/cli/user.rs` `examine_globs` additions) →
F5 (scoped adversarial on the diff) → F6 (targeted `cargo mutants --in-diff`
hardening on the diff scope, verifying those additions) → F7 (delta
convergence + human close gate).

Next: F2 (spec evolution). D-379 to be minted by state-manager recording
this F1 gate outcome.
