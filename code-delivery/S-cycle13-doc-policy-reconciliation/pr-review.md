# PR #819 — Fresh-Eyes Pre-Merge Review

**PR:** #819 — docs(cycle13): reconcile docs to MSRV 1.88 (Wave-2 S3)
**Branch:** `docs/cycle13-doc-policy-reconciliation` → `develop`
**Story:** S-cycle13-doc-policy-reconciliation (cycle-013 S3)
**Scope:** docs-only, 5 files, +25 / -19
**State:** MERGEABLE

## Verdict: APPROVE

Mergeable, zero blocking findings. Docs-only reconciliation of the already-merged MSRV-1.88 change (#818). Every doc claim was verified against the merged code on `develop`.

## Assessment

### 1. Docs accuracy vs merged code — VERIFIED

- `tests/team_column_parity.rs` doc-comments (doc-COMMENT only) accurately describe the merged let-chain:
  - `src/cli/board.rs:231-233` — `if matches!(output_format, OutputFormat::Table) && let Some(field_id) = team_field_id { … } else { Vec::new() }`; the separate inner `uuids.iter().any(..)` gate and the outer `else { Vec::new() }` arm both exist exactly as the comment states.
  - `src/cli/issue/list.rs:760-762` — identical structure, verified the same way.
- README MSRV badge = 1.88 (`README.md:8`).
- Design-spec §MSRV Policy now reads "bump as needed (currently **1.88.0**), driven by dependency floor and ecosystem pressure, evaluated ad hoc per cycle … (ADR-0025)" — matches `ADR-0025-raise-msrv-to-1-88.md` §Decision near-verbatim.
- CLAUDE.md cross-ref: line-range `Cargo.toml:78-85` replaced with prose ref "`Cargo.toml`'s `saphyr-parser` dependency comment". The saphyr-parser comment block is at `Cargo.toml:78-86`; the prose ref is correct AND improves compliance with CLAUDE.md's own citation-discipline convention (prefer symbol/prose form over drift-prone line numbers).

### 2. No new contradiction / no residual present-tense "MSRV 1.85" — VERIFIED

- Design-spec CI section changed from "(1.85.0)" to "the currently-declared MSRV floor — see §MSRV Policy". No stale literal.
- The one remaining "1.85" (plans file `2026-04-23-…md`) is inside the historical note and now explicitly suffixed "(MSRV since raised to 1.88 in cycle-013 — this note is dated-historical…)". Correctly framed as dated-historical, not present-tense.

### 3. Scope discipline — VERIFIED

- Exactly 5 docs/comment-only files. `tests/team_column_parity.rs` diff touches ONLY `///` doc-comment lines above two test fns; `#[tokio::test]`/`async fn` lines are unchanged context. NO source-logic, NO test-body, NO ci.yml, NO Cargo.toml change.

### 4. Security — N/A / CLEAN

- Docs/comment-only diff; no code, config, or attack-surface change. Pre-existing README "License: MIT" badge intentionally not treated as a finding (out of scope; flagged separately to human).

### 5. CHANGELOG correctly NOT re-touched — VERIFIED

- CHANGELOG.md not in the file set; already covered by #818. A duplicate entry would have been the defect.

## Findings

| Severity | Category | Finding | Suggestion |
|----------|----------|---------|------------|
| — | — | No blocking or suggestion findings. | — |

### Nits
None material. (Cosmetic-only: design-spec says "1.88.0" while Cargo.toml/ADR say "1.88" — semantically identical, not worth changing.)
