---
document_type: story
level: ops
epic_id: "BUCKET1-DEFECTS"
story_id: "S-692-1"
title: "issue edit --dry-run reads stdin/renders ADF preview for --description and --description-stdin (closes #692, DEC-274)"
wave: feature-followup
status: draft
intent: enhancement
feature_type: backend
mode: feature
scope: standard
severity: MEDIUM
trivial_scope: false
issue: 692
points: 5
priority: HIGH
tdd_mode: strict
estimated_effort: medium
producer: story-writer
timestamp: "2026-08-13T00:00:00"
phase: 3
cycle: cycle-bucket1-defects
inputs:
  - ".factory/phase-f1-delta-analysis/bucket1-impact-boundary.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-bucket1-defects.md"
  - ".factory/research/bucket1-692-dry-run-stdin-2026-08-13.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
input-hash: "3f89b78"
traces_to: ".factory/specs/prd/bc-3-issue-write.md"
estimated_days: 1
target_module: src/cli/issue/edit.rs
subsystems: ["SS-03"]
depends_on: []
blocks: []
behavioral_contracts:
  - "BC-3.4.021"
bcs:
  - "BC-3.4.021"
verification_properties:
  - "VP-DRY-RUN-001"
  - "VP-692-001"
  - "VP-692-002"
  - "VP-692-003"
  - "VP-692-004"
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/bc-3-issue-write.md"
implementation_strategy: tdd
module_criticality: "informal (no module-criticality.md exists in this repo; target_module src/cli/issue/edit.rs is a Seam-B extraction per ADR-0012, 2,067 LOC, breaking-change surface — treat as HIGH by convention pending a formal criticality doc)"
acceptance_criteria_count: 14
assumption_validations: []
risk_mitigations: []
created: "2026-08-13"
version: "1.0"
last_updated: "2026-08-13"
breaking_change: true
retroactive: false
origin: >
  BUCKET1-DEFECTS bundle, DEC-274 (RATIFIED at F2 gate, commit 60ac2ff7). Reverses
  BC-3.4.021 Invariant 3 ("--dry-run does NOT read stdin ... correct behavior, not
  a bug") and, per F2 adversary pass-3 MEDIUM-1 (human-ratified same gate), extends
  the reversal's ADF-preview half to bare --description as well as --description-stdin.
  Breaking change to jr issue edit --dry-run --output json output shape. Requires a
  CHANGELOG.md Breaking: entry at release (F2 "Acceptance Note for F3/Release").
files_modified:
  - src/cli/issue/edit.rs
  - tests/issue_edit.rs
  - CHANGELOG.md
test_files:
  - tests/issue_edit.rs
---

> **Execute:** `/vsdd-factory:deliver-story S-692-1`

# S-692-1 — `issue edit --dry-run` Reads Stdin and Renders an ADF Preview

## Narrative

- **As a** `jr issue edit --dry-run` caller supplying `--description` or
  `--description-stdin`
- **I want to** see the actual rendered ADF document (and any conversion error,
  such as the `MAX_ADF_DEPTH` recursion-depth guard) in the dry-run preview
- **So that** I can catch Jira-rejection failure modes before ever issuing a live
  write — dry-run is the ONLY non-mutating path in `issue edit`, so previously
  skipping ADF conversion there meant these failures were uncatchable without a
  live edit.

*Breaking change: `jr issue edit --dry-run --description-stdin --output json`
previously emitted `plannedChanges.description = "<from stdin — not yet read in
dry-run>"` and never read stdin. As of this story, `plannedChanges.description`
carries the actual piped content and a new `plannedChanges.descriptionAdf` field
is added. Any automation asserting on the literal placeholder string will observe
a different value. See CHANGELOG.md `### Breaking Changes`.*

## Source of Truth

- F2 spec evolution (authoritative): `.factory/specs/prd/bc-3-issue-write.md`
  BC-3.4.021 (`STATUS: UPDATED (DEC-274 ...)`, ratified at the F2 gate,
  commit `60ac2ff7`) — this BC's body is the SSOT for verbatim strings, guard
  placement, ordering, and the full Postconditions/Invariants/EC/VP set. The F2
  delta doc (`.factory/phase-f2-spec-evolution/prd-delta-bucket1-defects.md`) is
  the pre-adversary-review summary; BC-3.4.021's committed body supersedes it
  (adversary passes 1–6 extended scope from `--description-stdin`-only to ANY
  description input — pass-3 MEDIUM-1).
- Research brief: `.factory/research/bucket1-692-dry-run-stdin-2026-08-13.md`
  (root-cause verification, stdin-read safety analysis, #398 raw-input tension).
- Cross-references (unaffected, no body edit): BC-3.4.013 (issue #398 raw-input
  invariant), BC-7.2.012 (`MAX_ADF_DEPTH = 256` recursion-depth guard, CWE-674).

## Problem Statement

`handle_edit`'s dry-run short-circuit (`src/cli/issue/edit.rs`, `if dry_run {
... return Ok(()); }` block, `:~366`–`:~559`) builds its preview from raw CLI
flag values only and returns BEFORE the live path's stdin read (`:~642`,
`desc_text = if description_stdin { spawn_blocking(read_to_string) } else {
description }`) and ADF conversion (`:~654`–`:~658`, `markdown_to_adf` if
`--markdown` else `text_to_adf`). This was EXPLICIT, INTENTIONAL, spec-locked
behavior (pre-DEC-274 BC-3.4.021 Invariant 3), not an oversight — but it meant a
depth-guard `Err` or other ADF-rejection failure mode was invisible under
`--dry-run`, defeating the entire point of a preview. DEC-274 reverses this.

**Note — no `--file` flag on `issue edit`:** only `--description`/
`--description-stdin` exist as description inputs (Invariant 6). Do not add a
file-based path here.

## Behavioral Contracts

| BC ID | Title | Clause |
|-------|-------|--------|
| BC-3.4.021 | `issue edit --dry-run` `plannedChanges` preview, description/ADF reversal | `STATUS: UPDATED (DEC-274)`, Postconditions-Common item 6, Postconditions-json items 1–3, Postconditions-table items 1–3, Invariants 2/3/5/6, EC-3.4.021-6/-7/-13/-15..-19, VP-DRY-RUN-001, VP-692-001..004 |

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| Dry-run block stdin read + ADF conversion pre-step | `src/cli/issue/edit.rs::handle_edit` dry-run block, before `match output_format` (`:~397`) | effectful-shell (stdin I/O) wrapping a pure conversion call (`adf::markdown_to_adf`/`adf::text_to_adf`) |
| `plannedChanges.descriptionAdf` json emission | `src/cli/issue/edit.rs::handle_edit`, `OutputFormat::Json` arm | effectful-shell (stdout write) |
| `description (ADF): rendered OK` table line | `src/cli/issue/edit.rs::handle_edit`, `OutputFormat::Table` arm | effectful-shell (stdout write) |
| ADF conversion itself | `src/adf.rs::markdown_to_adf` / `src/adf.rs::text_to_adf` | pure-core (reused verbatim from the live path, no new code) |

## Guard/Ordering Implementation Pattern (MANDATORY, adversary pass-6 LOW-1)

The stdin-read (for `--description-stdin` only) + ADF-conversion step MUST run
EXACTLY ONCE and MUST complete — including a possible `markdown_to_adf` `Err` →
exit 64 — BEFORE the `match output_format` block begins emitting ANY output.
This is a structural requirement, not merely an outcome one: `--output table`'s
preview lines are printed INCREMENTALLY via per-field `println!` calls, so
performing the read/conversion step interleaved with (or after) the start of
that sequence risks a depth-guard `Err` firing mid-table-output, leaking partial
stdout before the exit-64 return — directly contradicting "stdout EMPTY on
error, in both modes" (EC-3.4.021-15/-19, VP-692-002/-004). Implement the
read+conversion as a single, unconditional pre-step ahead of the `match
output_format` dispatch, whose `?`/early-return propagates before either arm
prints anything.

Both `--description` and `--description-stdin` route through the SAME
conversion selection the live path uses: `adf::markdown_to_adf(text)` if
`--markdown` else `adf::text_to_adf(text)`.

## Acceptance Criteria

### AC-1 (traces to BC-3.4.021 EC-3.4.021-6, VP-692-001): `--description-stdin` happy path, JSON
- `jr issue edit FOO-1 --description-stdin --dry-run --output json` with piped
  stdin `"Fixed it"` → `plannedChanges.description == "Fixed it"` (raw,
  byte-identical to stdin) AND `plannedChanges.descriptionAdf` is present, is a
  valid ADF `doc` node, and is byte-identical to `adf::text_to_adf("Fixed it")`.
  Top-level JSON keys remain exactly `{dryRun, issues, plannedChanges}`. PUT not
  called. Exit 0.
- **Test:** `test_BC_3_4_021_dry_run_description_stdin_renders_adf_preview_json`

### AC-2 (traces to BC-3.4.021 EC-3.4.021-15, VP-692-002): `--description-stdin` depth-guard error, JSON mode
- `jr issue edit FOO-1 --description-stdin --markdown --dry-run --output json`
  with stdin engineered to trip `MAX_ADF_DEPTH = 256` (BC-7.2.012 fixture) →
  exit 64. **stdout is EMPTY.** stderr parses as JSON `{"error","code"}`
  envelope, `code == 64`. No `plannedChanges`/`dryRun`/`issues` keys anywhere
  (stdout or stderr). PUT not called.
- **Test:** `test_BC_3_4_021_dry_run_description_stdin_depth_guard_exits_64_json_stdout_empty`

### AC-3 (traces to BC-3.4.021 EC-3.4.021-15, VP-692-002): `--description-stdin` depth-guard error, table mode
- Same invocation as AC-2 without `--output json` (default table mode) → exit
  64, **stdout EMPTY**, stderr carries `Error: ...`. PUT not called.
- **Test:** `test_BC_3_4_021_dry_run_description_stdin_depth_guard_exits_64_table_stdout_empty`

### AC-4 (traces to BC-3.4.021 EC-3.4.021-18, VP-692-003): bare `--description` happy path, JSON
- `jr issue edit FOO-1 --description "Fixed it" --dry-run --output json`
  (no stdin involved) → `plannedChanges.description == "Fixed it"` (raw,
  unchanged from the flag value) AND `plannedChanges.descriptionAdf` present,
  valid ADF `doc` node, byte-identical to `adf::text_to_adf("Fixed it")`.
  Top-level keys remain exactly `{dryRun, issues, plannedChanges}`. PUT not
  called. Exit 0.
- **Test:** `test_BC_3_4_021_dry_run_bare_description_renders_adf_preview_json`

### AC-5 (traces to BC-3.4.021 EC-3.4.021-19, VP-692-004 — the exact false-OK regression this closes): bare `--description` depth-guard error, JSON mode
- `jr issue edit FOO-1 --description "<content engineered to trip MAX_ADF_DEPTH>"
  --markdown --dry-run --output json` → exit 64, **stdout EMPTY**, stderr
  carries the standard `{"error","code":64}` envelope. PUT not called. Prior to
  this fix, this exact invocation returned exit 0 with a misleading success
  preview while the corresponding live edit would exit 64 on the same guard.
- **Test:** `test_BC_3_4_021_dry_run_bare_description_depth_guard_exits_64_json_stdout_empty`

### AC-6 (traces to BC-3.4.021 EC-3.4.021-19, VP-692-004): bare `--description` depth-guard error, table mode
- Same invocation as AC-5 without `--output json` → exit 64, **stdout EMPTY**,
  stderr carries `Error: ...`. PUT not called.
- **Test:** `test_BC_3_4_021_dry_run_bare_description_depth_guard_exits_64_table_stdout_empty`

### AC-7 (traces to BC-3.4.021 EC-3.4.021-17): empty stdin edge case
- `jr issue edit FOO-1 --description-stdin --dry-run --output json < /dev/null`
  → `plannedChanges.description == ""` (KEY PRESENT, not absent/null) AND
  `plannedChanges.descriptionAdf == adf::text_to_adf("")`. `--description-stdin`
  itself is a field flag, so the pre-HTTP zero-flag guard (Precondition 2) does
  not fire. Table mode: `"  description → <empty preview>"` followed by
  `"  description (ADF): rendered OK"`. Exit 0.
- **Test:** `test_BC_3_4_021_dry_run_empty_stdin_produces_empty_description_and_valid_adf`

### AC-8 (traces to BC-3.4.021 EC-3.4.021-16): multi-line Markdown stdin round-trip
- `jr issue edit FOO-1 --description-stdin --markdown --dry-run --output json`
  with piped multi-line Markdown (bullet list + fenced code block) →
  `plannedChanges.description` is the raw multi-line stdin string verbatim,
  INCLUDING embedded `\n` (this is a bare string, not an ADF text node — the
  newline-in-text-node prohibition does not apply here); `plannedChanges.descriptionAdf`
  is the full `adf::markdown_to_adf` output containing `bulletList`/`codeBlock`
  nodes (not a placeholder, not a flattened string). PUT not called. Exit 0.
- **Test:** `test_BC_3_4_021_dry_run_multiline_markdown_stdin_produces_real_adf_document`

### AC-9 (traces to BC-3.4.021 Postconditions-table items 1–2, EC-3.4.021-7/-13): table-mode render-OK line, unconditional on truncation
- `--output table --description "<61 codepoints>"` → truncated with `"..."`
  suffix PLUS `"  description (ADF): rendered OK"` is ALSO emitted
  unconditionally (not gated on whether truncation fired). Exactly 60
  codepoints → no truncation suffix, but the render-OK line still appears.
  When BOTH `--markdown` and a description input are supplied, `"  markdown
  rendering: enabled"` is emitted BEFORE `"  description (ADF): rendered OK"`
  (pinned relative order, adversary pass-5 INFO-2).
- **Test:** `test_BC_3_4_021_dry_run_table_render_ok_line_unconditional_on_truncation_and_ordering`

### AC-10 (traces to BC-3.4.021 Postconditions-json item 1): three-top-level-key invariant preserved
- For ANY combination of description-input flags (`--description`,
  `--description-stdin`, either with or without `--markdown`), `--dry-run
  --output json` stdout has EXACTLY three top-level keys:
  `{dryRun, issues, plannedChanges}` — `descriptionAdf` is nested INSIDE
  `plannedChanges`, never a fourth top-level key.
- **Test:** `test_BC_3_4_021_dry_run_json_top_level_key_count_preserved_with_description_adf`

### AC-11 (traces to BC-3.4.021 Postconditions-Common item 6, MANDATED ORDERING, adversary pass-6 LOW-1): structural pre-step ordering, no partial-stdout leak
- Implementation-level requirement (verified via AC-2/AC-3/AC-5/AC-6's
  stdout-EMPTY assertions, which are FALSIFIABLE only if the read+conversion
  step runs strictly before any table `println!`/JSON print begins): a
  depth-guard `Err` in TABLE mode must never leak any of the incremental
  preview lines (`"DRY RUN — ..."`, `"Issues affected"`, etc.) to stdout before
  the exit-64 return. This AC is the explicit regression pin for the
  MANDATED ORDERING requirement — do not treat AC-3/AC-6's stdout-empty
  assertions as incidental; they are this ordering's discriminating proof.
- **Test:** covered by `test_BC_3_4_021_dry_run_description_stdin_depth_guard_exits_64_table_stdout_empty` (AC-3) and `test_BC_3_4_021_dry_run_bare_description_depth_guard_exits_64_table_stdout_empty` (AC-6); no separate test function required, but implementer MUST NOT structure the fix as "print partial preview, then error" even if today's fixture data would make it pass coincidentally.

### AC-12 (traces to BC-3.4.021 Invariant 1, description exception): live-wire byte-identity preserved, other fields still simplified
- `descriptionAdf` is the ONE field whose dry-run preview is byte-identical to
  the live POST payload; `summary`/`priority`/`issueType`/`labels`/etc. remain
  INTENTIONALLY SIMPLIFIED previews (regression pin — do not "fix" those to
  match live wire shapes as a side effect of this story).
- **Test:** `test_BC_3_4_021_dry_run_other_fields_remain_simplified_previews_unaffected_by_description_fix`

### AC-13 (traces to BC-3.4.021 Invariant 6): no `--file` flag regression pin
- `jr issue edit --help` output contains no `--file` flag on the `edit`
  subcommand; description input remains `--description`/`--description-stdin`
  only.
- **Test:** `test_BC_3_4_021_issue_edit_help_has_no_file_flag`

### AC-14 (release obligation, F2 "Acceptance Note for F3/Release", mirrors S-639-1 precedent): CHANGELOG `Breaking:` entry
- `CHANGELOG.md` gains a `### Breaking Changes` (or equivalent `Breaking:`)
  entry describing the `plannedChanges.description`/`descriptionAdf` shape
  change for `issue edit --dry-run --description-stdin --output json`, citing
  DEC-274 and issue #692, in the SAME PR/commit as the code change. This story
  is NOT considered complete without this entry — do not let it be implicit or
  deferred.
- **Test:** manual/PR-review gate (not a `cargo test` assertion) — verified at
  PR creation per the Branch/PR Plan below.

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-1 | `--description-stdin --dry-run` with piped content | Stdin read once, ADF rendered, `descriptionAdf` populated (AC-1) |
| EC-2 | `--description-stdin --markdown --dry-run` with pathological nesting | Exit 64 before any output, both modes (AC-2/AC-3) |
| EC-3 | Bare `--description "X" --dry-run` | `descriptionAdf` populated even without stdin (AC-4) |
| EC-4 | Bare `--description "<nested>" --markdown --dry-run` | Exit 64 — the exact false-OK regression this story closes (AC-5/AC-6) |
| EC-5 | `--description-stdin --dry-run < /dev/null` | Empty description, valid empty-input ADF, exit 0 (AC-7) |
| EC-6 | Multi-line Markdown stdin | Raw string in `description`, real ADF tree in `descriptionAdf` (AC-8) |
| EC-7 | `--dry-run` with no description flag at all | No `descriptionAdf` key at all (derived-key absence, Postconditions-json item 2) |
| EC-8 | `--markdown` without any description flag | Guarded earlier by the pre-existing `--markdown requires --description/--description-stdin` guard (unaffected by this story) |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|----------------|
| `src/cli/issue/edit.rs::handle_edit` dry-run block | effectful-shell | stdin read (I/O) + stdout write, wraps a pure conversion call |
| `src/adf.rs::markdown_to_adf` / `text_to_adf` | pure-core | No I/O; reused verbatim, unmodified by this story |

## Token Budget Estimate

| Item | Tokens (approx) |
|------|-------------------|
| This story file | ~4 k |
| BC-3.4.021 full body (read for verbatim strings + AC bodies) | ~9 k |
| Research brief `bucket1-692-dry-run-stdin-2026-08-13.md` | ~3 k |
| `src/cli/issue/edit.rs` (dry-run block + live-path description handling, two windows) | ~4 k |
| `src/adf.rs` entry points (`markdown_to_adf`/`text_to_adf` signatures + depth guard) | ~1 k |
| `tests/issue_edit.rs` (existing dry-run tests to extend) | ~6 k |
| Tool outputs + `cargo test` output | ~4 k |
| **Total** | **~31 k** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~16%** |

## Tasks

1. [ ] Read BC-3.4.021 in full (including "Previous version" blocks — do NOT
   re-implement the pre-DEC-274 or pass-2-reverted behavior).
2. [ ] Write failing tests for AC-1 through AC-13 (Red Gate).
3. [ ] Implement the pre-step: stdin read (for `--description-stdin`) +
   `markdown_to_adf`/`text_to_adf` conversion, placed BEFORE `match
   output_format`, with its `?` propagating an exit-64 UserError before any
   print statement runs.
4. [ ] Wire `plannedChanges.descriptionAdf` into the JSON arm (nested inside
   `plannedChanges`, never top-level).
5. [ ] Wire the `"  description (ADF): rendered OK"` line into the table arm,
   respecting the markdown-enabled-line-before-render-OK-line pinned order.
6. [ ] Verify AC-1 through AC-13 GREEN.
7. [ ] Add `CHANGELOG.md` `### Breaking Changes` entry (AC-14).
8. [ ] Full suite: `cargo test`, `cargo clippy -- -D warnings`, `cargo fmt --all
   -- --check`, `cargo deny check`.
9. [ ] Per-story adversarial review (project convention — 3/3 CLEAN before push).

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|-----------------|-------------------------|------------------------|
| S-639-1 | Pre-flight exit-64 guard pattern; breaking-change CHANGELOG discipline | `JrError::UserError` exit-64 over clap `requires` (wrong exit code); breaking_change frontmatter marker | Vacuous-negative test assertions must be replaced, not left as false-security after a behavior reversal — apply the same discipline to any pre-DEC-274 placeholder-string assertions in existing dry-run tests |
| S-668-1 | `--output json` additive-field pattern (`duedate`) preserving top-level key count | Nested additive fields inside an existing object, not new top-level keys | N/A |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| Read+conversion pre-step MUST complete before `match output_format` begins printing | BC-3.4.021 Postconditions-Common item 6, MANDATED ORDERING (adversary pass-6 LOW-1) | AC-3/AC-6 stdout-EMPTY assertions on the table arm |
| `descriptionAdf` nested inside `plannedChanges`, never top-level | BC-3.4.021 Postconditions-json item 1 | AC-10 |
| `plannedChanges.description` remains RAW input in both cases (BC-3.4.013 unaffected) | BC-3.4.021 Invariant 3, cross-ref BC-3.4.013 | AC-1/AC-4 |
| No `--file` flag added | BC-3.4.021 Invariant 6 | AC-13 |
| ADF selection mirrors live path exactly (`markdown_to_adf` iff `--markdown`) | BC-3.4.021 Description | AC-1/AC-4/AC-8 |

## Library & Framework Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| tokio (existing) | as in `Cargo.lock` | `spawn_blocking` for the stdin read, same idiom as the live path |
| serde_json (existing) | as in `Cargo.lock` | `plannedChanges` JSON construction |

No new crate dependencies.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/cli/issue/edit.rs` | MODIFY | Add stdin-read+ADF-conversion pre-step inside the dry-run block; wire `descriptionAdf` into both output arms |
| `tests/issue_edit.rs` | MODIFY | Add/extend dry-run tests for AC-1..AC-13; remove/replace any pre-DEC-274 placeholder-string assertions |
| `CHANGELOG.md` | MODIFY | `### Breaking Changes` entry (AC-14) |

**MUST NOT change**: `src/adf.rs` (conversion functions reused verbatim, unmodified); BC files in `.factory/specs/prd/` (F2 sealed — escalate discrepancies to orchestrator).

## Branch / PR Plan

- Bundle: `BUCKET1-DEFECTS`
- Branch: `feat/692-dry-run-stdin-adf-preview`
- Target: `develop`
- Commit style: `feat(edit)!: --dry-run reads stdin and renders ADF preview (#692, DEC-274)` (breaking change `!`)
- PR closes #692
- `CHANGELOG.md` `### Breaking Changes` entry in same commit (AC-14)
