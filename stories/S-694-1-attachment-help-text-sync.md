---
document_type: story
level: ops
epic_id: "BUCKET1-DEFECTS"
story_id: "S-694-1"
title: "Sync attachment command help-text/doc comments to already-ratified behavior (closes #694)"
wave: feature-followup
status: draft
intent: docs
feature_type: backend
mode: feature
scope: trivial
severity: LOW
trivial_scope: true
issue: 694
points: 2
priority: LOW
tdd_mode: strict
estimated_effort: small
producer: story-writer
timestamp: "2026-08-13T00:00:00"
phase: 3
cycle: cycle-bucket1-defects
inputs:
  - ".factory/phase-f1-delta-analysis/bucket1-impact-boundary.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-bucket1-defects.md"
  - ".factory/research/bucket1-694-attachment-docs-2026-08-13.md"
  - ".factory/specs/prd/bc-2-issue-read.md"
input-hash: "9b9d118"
traces_to: ".factory/specs/prd/bc-2-issue-read.md"
estimated_days: 1
target_module: src/cli/mod.rs
subsystems: ["SS-02"]
depends_on: []
blocks: []
behavioral_contracts:
  - "BC-2.7.010"
  - "BC-2.7.008"
  - "BC-2.7.009"
bcs:
  - "BC-2.7.010"
  - "BC-2.7.008"
  - "BC-2.7.009"
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/bc-2-issue-read.md"
implementation_strategy: tdd
module_criticality: "informal (no module-criticality.md exists in this repo; target_module src/cli/mod.rs is the clap CLI-surface definition file — docs-only change, no runtime-logic risk)"
acceptance_criteria_count: 5
assumption_validations: []
risk_mitigations: []
created: "2026-08-13"
version: "1.0"
last_updated: "2026-08-13"
breaking_change: false
retroactive: false
origin: >
  BUCKET1-DEFECTS bundle. Pure help-text/doc-comment sync in src/cli/mod.rs.
  No BC body changed (bc-2-issue-read.md frontmatter changelog note only,
  v1.3.180); the three doc-comment sites were stale/incomplete relative to
  already-ratified behavior (BC-2.7.008/009/010). No behavior change.
files_modified:
  - src/cli/mod.rs
test_files:
  - tests/attachment_help_text.rs
---

> **Execute:** `/vsdd-factory:deliver-story S-694-1`

# S-694-1 — Attachment Help-Text/Doc Sync

## Narrative

- **As a** `jr issue attachment --help` reader
- **I want to** see accurate, complete help text describing all four
  subcommands, the batch on-disk naming scheme, and the filter/sort/truncate
  order for `--newest`
- **So that** I don't have to read source code to discover behavior the tool
  already implements correctly — this is a pure documentation-completeness
  fix, no behavior changes.

DOCS-ONLY story: no behavior change, no BC body edits (the underlying BCs
already specify the true behavior correctly — see F2's `bc-2-issue-read.md`
changelog note v1.3.180). No UX/a11y/browser-e2e steps apply (CLI-only
project).

## Source of Truth

- F2 spec evolution: `.factory/specs/prd/bc-2-issue-read.md` frontmatter
  changelog `v1.3.180` (2026-08-13, issue #694) — "0 new BCs — docs-only
  help-text sync ... No BC body text changed."
- Research brief: `.factory/research/bucket1-694-attachment-docs-2026-08-13.md`
  (all three reporter claims independently CONFIRMED against source at
  `develop` tip).
- Owning BCs (unchanged, cited for the true behavior each doc site must
  describe accurately): BC-2.7.010 (batch on-disk naming scheme), BC-2.7.008
  (batch download to `--out-dir`), BC-2.7.009 (`--newest N` filter-then-sort-
  then-truncate order).

## Problem Statement

Three clap doc-comment sites in `src/cli/mod.rs` are stale or incomplete
relative to behavior that is already correctly implemented and already
correctly specified in `bc-2-issue-read.md`:

1. **Parent `about` string** (`src/cli/mod.rs:~651`, doc comment on
   `IssueCommand::Attachment`): reads `/// Attachment operations: list.
   (S-576-1)` — but `AttachmentSubcommand` (`:~741`) has FOUR variants: `List`
   (`:~743`), `Download` (`:~759`), `Upload` (`:~810`), `Delete` (`:~869`).
2. **`--out-dir` help** (`src/cli/mod.rs:~786`–`790`, `out_dir` field doc
   comment inside `AttachmentSubcommand::Download`): does not mention the
   batch on-disk naming scheme, `<40-char-SHA-1-of-attachment-id>_<sanitized-
   filename>` (the SHA-1 input is the attachment ID, not the URL or
   filename — the ID itself never appears in plaintext in the path).
3. **`--newest` help** (`src/cli/mod.rs:~773`–`779`, `newest` field doc
   comment inside `AttachmentSubcommand::Download`): does not state that
   `--filter` predicates are applied BEFORE `--newest` truncation, and that
   the surviving set is sorted by `created` (most recent first) before
   truncation to N.

All three underlying behaviors are already correct and already specified —
`compute_default_output_path` (`src/cli/issue/attachments.rs:~537`) already
implements the SHA-1 scheme exactly as BC-2.7.010 describes; `handle_batch_download`
(`src/cli/issue/attachments.rs:~921`) already filters-then-sorts-then-truncates
exactly as BC-2.7.009 describes. This story changes ONLY the doc-comment text.

## Behavioral Contracts (cited, not modified)

| BC ID | Title | Relevance |
|-------|-------|-----------|
| BC-2.7.010 | Default download output path — batch: `<sha1-of-id>_<sanitized-basename>`; single-`--id`: bare sanitized basename | Owning BC for the `--out-dir` help sentence (AC-2) |
| BC-2.7.008 | `attachment download <KEY> --all` batch download to `--out-dir <DIR>` | Owning BC for the parent `about` enumeration and general batch-download context |
| BC-2.7.009 | `attachment download <KEY> --newest N` — filter, then sort by `created` descending, then truncate | Owning BC for the `--newest` help sentence (AC-3) |

No BC body is edited by this story — all three doc sites describe behavior
these BCs already specify correctly (F2 changelog v1.3.180).

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `IssueCommand::Attachment` `about` doc comment | `src/cli/mod.rs:~651` | n/a (clap-derive metadata, compile-time) |
| `Download::out_dir` field doc comment | `src/cli/mod.rs:~786`–`790` | n/a (clap-derive metadata) |
| `Download::newest` field doc comment | `src/cli/mod.rs:~773`–`779` | n/a (clap-derive metadata) |

## Exact Doc Sites to Amend

1. **Parent `about`** — `src/cli/mod.rs:~651`. Change `Attachment operations:
   list. (S-576-1)` → enumerate all four (list, download, upload, delete).
   Provenance tag update to a range, or drop, is an implementer style call;
   the substantive requirement is the four-subcommand enumeration.
2. **`--out-dir` help** — `src/cli/mod.rs:~786`–`790`. Add one sentence: files
   are written as `<40-char-SHA-1-of-attachment-id>_<sanitized-filename>`; the
   on-disk name is not predictable from `list` output — parse the JSON
   manifest's `path` field to recover it; the attachment id itself is not in
   the path (only its SHA-1 digest is).
3. **`--newest` help** — `src/cli/mod.rs:~773`–`779`. Add one sentence:
   `--filter` predicates are applied BEFORE `--newest` truncation; the
   surviving set is sorted by `created` (most recent first), then truncated to
   N — i.e., the N newest matching attachments.

## Acceptance Criteria

### AC-1 (traces to BC-2.7.008, four-subcommand enumeration): parent `about` lists all four subcommands
- `jr issue attachment --help` stdout contains all four subcommand names
  (`list`, `download`, `upload`, `delete`) in the top-level `about`/description
  text — not merely as subcommand entries in the usage list, but named in the
  parent description string itself.
- **Test:** `test_BC_2_7_008_attachment_help_about_enumerates_all_four_subcommands`

### AC-2 (traces to BC-2.7.010, batch naming scheme documented): `--out-dir` help documents the SHA-1 batch naming scheme
- `jr issue attachment download --help` stdout, within the `--out-dir` entry's
  help text, contains a description of the batch on-disk naming scheme
  (mentions SHA-1 and that it is computed from the attachment id, and that the
  JSON manifest's `path` field is the way to recover the actual on-disk name).
- **Test:** `test_BC_2_7_010_attachment_download_help_out_dir_documents_sha1_naming_scheme`

### AC-3 (traces to BC-2.7.009, filter-then-sort-then-truncate order documented): `--newest` help documents the ordering
- `jr issue attachment download --help` stdout, within the `--newest` entry's
  help text, contains a description stating `--filter` is applied before
  `--newest`, and that the surviving set is sorted by `created` (most recent
  first) before truncation.
- **Test:** `test_BC_2_7_009_attachment_download_help_newest_documents_filter_then_sort_order`

### AC-4 (regression pin, no BC body change): BC bodies remain byte-identical
- `git diff` for this story's commit touches ONLY `src/cli/mod.rs` and its
  test file — `.factory/specs/prd/bc-2-issue-read.md` (or any other
  `bc-*.md` file) has zero diff. `scripts/check-spec-counts.sh` continues to
  exit 0.
- **Test:** manual/PR-review gate (diff inspection at PR creation), not a
  `cargo test` assertion.

### AC-5 (regression pin, no behavior change): existing attachment tests unaffected
- The full existing `tests/` suite for attachment list/download/upload/delete
  behavior (batch naming, filter/sort/truncate logic, single-file path) passes
  unchanged — this story touches doc comments only, never
  `src/cli/issue/attachments.rs` logic.
- **Test:** `cargo test` full suite green (no new/changed behavioral
  assertions expected to fail or need updates in
  `tests/attachment_download.rs` or sibling attachment test files).

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-1 | `jr issue attachment --help` | About string mentions list/download/upload/delete (AC-1) |
| EC-2 | `jr issue attachment download --help` | `--out-dir` entry documents SHA-1-of-id scheme (AC-2) |
| EC-3 | `jr issue attachment download --help` | `--newest` entry documents filter-before-sort-before-truncate (AC-3) |
| EC-4 | Any attachment behavior test | Unaffected — zero logic change (AC-5) |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|----------------|
| `src/cli/mod.rs` doc comments | n/a (compile-time clap metadata, not runtime code) | No I/O, no logic — string literal content only |

## Token Budget Estimate

| Item | Tokens (approx) |
|------|-------------------|
| This story file | ~2 k |
| Research brief `bucket1-694-attachment-docs-2026-08-13.md` | ~2 k |
| `src/cli/mod.rs` (three doc-comment windows) | ~1 k |
| `src/cli/issue/attachments.rs` (`compute_default_output_path`, `handle_batch_download` — read for accuracy verification only, not modified) | ~2 k |
| Tool outputs + `cargo test` output | ~2 k |
| **Total** | **~9 k** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~5%** |

## Tasks

1. [ ] Read the research brief's "Exact doc sites to amend" section and verify
   line citations still match current `src/cli/mod.rs` (they may drift —
   cite by symbol/field name, not line number, in the final commit).
2. [ ] Write failing help-text assertion tests for AC-1 through AC-3 (Red
   Gate — these assert substrings absent from current help output).
3. [ ] Update the three doc comments per the "Exact Doc Sites to Amend"
   section.
4. [ ] Verify AC-1 through AC-3 GREEN.
5. [ ] Verify AC-4 (diff scope) and AC-5 (no regression) manually/via
   `cargo test`.
6. [ ] Full suite: `cargo test`, `cargo clippy -- -D warnings`, `cargo fmt --all
   -- --check`, `cargo deny check`.
7. [ ] Per-story adversarial review (project convention — 3/3 CLEAN before
   push) — lightweight given docs-only scope.

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|-----------------|-------------------------|------------------------|
| S-576-1..5 | Established the attachment subcommand family (list/download/upload/delete) across 5 stories | Batch SHA-1-of-id naming (BC-2.7.010); filter-then-sort-then-truncate (BC-2.7.009) | The parent `about` string was never updated as later subcommands (upload S-576-3, delete S-576-4) were added — this story is the first to catch and fix that drift |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| No behavior change — doc comments only | Story scope (docs-only) | AC-4/AC-5; `git diff` scoped to `src/cli/mod.rs` + test file only |
| Doc text must not contradict BC-2.7.008/009/010 | F2 changelog v1.3.180 | AC-1/AC-2/AC-3 assert substrings matching the BC-specified behavior, not paraphrase drift |
| CLAUDE.md dead-citation guard scope note | `tests/claude_md_citations.rs` applies only to `CLAUDE.md` backtick citations, not clap doc strings | N/A — this story does not touch `CLAUDE.md`; noted here only to confirm no CI guard applies to `src/cli/mod.rs` doc comments |

## Library & Framework Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| clap 4 (existing) | as in `Cargo.lock` | Doc-comment-derived help text (no new attributes) |
| assert_cmd (existing) | as in `Cargo.lock` | `--help` stdout capture for AC-1..AC-3 |

No new crate dependencies.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/cli/mod.rs` | MODIFY | Three doc-comment updates (parent `about`, `--out-dir`, `--newest`) |
| `tests/attachment_help_text.rs` | CREATE | New test file for AC-1..AC-3 help-text substring assertions (or add to an existing attachment test file if the implementer finds a more natural home — CREATE is the default expectation) |

**MUST NOT change**: `src/cli/issue/attachments.rs` (behavior unchanged —
`compute_default_output_path`, `handle_batch_download` are read-only reference
material for this story, never modified); BC files in `.factory/specs/prd/`
(F2 explicitly recorded 0 BC body changes for #694 — any edit here is
out-of-scope drift, escalate to orchestrator).

## Branch / PR Plan

- Bundle: `BUCKET1-DEFECTS`
- Branch: `docs/694-attachment-help-text-sync`
- Target: `develop`
- Commit style: `docs(attachment): sync help text to ratified behavior (#694)`
- PR closes #694
