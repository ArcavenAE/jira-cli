---
document_type: story
story_id: "S-WIN-6"
title: "Docs fallout: CLAUDE.md JR_* table entries, Windows config/cache path docs, ADR-0016 materialize, adr-index update"
wave: feature-followup
status: ready
intent: enhancement
feature_type: docs
mode: feature
scope: small
severity: LOW
trivial_scope: false
points: 2
priority: P1
tdd_mode: strict
estimated_effort: small
estimated_days: 0.5
target_module: docs
subsystems: []
depends_on: ["S-WIN-2"]
blocks: []
bc_anchors:
  - BC-6.2.017
bcs:
  - BC-6.2.017
verification_properties: []
holdout_anchors: []
nfr_anchors:
  - NFR-P-W1
adr_refs:
  - ADR-0016
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-001/windows-build/architecture-delta.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 5
assumption_validations: []
risk_mitigations: []
created: "2026-06-12"
last_updated: "2026-06-12"
breaking_change: false
files_modified:
  - CLAUDE.md                                     # JR_CONFIG_DIR / JR_CACHE_DIR in JR_* env table; Windows config/cache path entries; NOTE gotcha
  - docs/adr/0016-windows-build-target.md         # Materialize ADR-0016 from .factory/architecture/adr/ into docs/adr/
  - .factory/architecture/adr-index.md            # Add ADR-0016 row to ADR registry
---

# S-WIN-6 — Docs Fallout: CLAUDE.md + ADR-0016 Materialization

## Source of Truth

Architecture delta: `.factory/cycles/cycle-001/windows-build/architecture-delta.md §8`
ADR-0016: `.factory/architecture/adr/0016-windows-build-target.md`
BC-6.2.017 §CLAUDE.md documentation obligation
CLAUDE.md "AI Agent Notes" JR_* env var table (existing pattern)

## Behavioral Contracts

| BC | Title | Role in this story |
|----|-------|-------------------|
| BC-6.2.017 | `JR_CONFIG_DIR` / `JR_CACHE_DIR` env vars override config/cache directory resolution in debug builds; compiled out in release builds | TRACING: BC-6.2.017 explicitly requires CLAUDE.md documentation of these env vars in the JR_* table |

## Story Narrative

As a developer or AI agent working with `jr`,
I want `CLAUDE.md` to document the new `JR_CONFIG_DIR` and `JR_CACHE_DIR`
debug env vars in the JR_* table, and to reflect Windows config/cache paths,
and I want ADR-0016 to be accessible in `docs/adr/` alongside the existing ADRs,
so that documentation is consistent with the implemented behavior and future
contributors and agents do not use incorrect paths or miss the new env vars.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~900 |
| CLAUDE.md (relevant sections for edit) | ~1,500 |
| ADR-0016 source (already authored) | ~2,500 |
| architecture-delta.md §8 | ~200 |
| .factory/architecture/adr-index.md | ~400 |
| **Total** | **~5,500** |

Small. No splitting required.

## Previous Story Intelligence

**Depends on S-WIN-2** (the debug seam must be implemented before its docs are written).
Can be implemented any time after S-WIN-2 merges (does not require S-WIN-1/3/4/5).

**Doc-fallout pattern (from CLAUDE.md "AI Agent Notes"):**
> When adding a new `JR_*` test-seam env var: grep `CLAUDE.md` for existing `JR_*` entries
> and add a parallel line in the SAME commit as the code change. This is the codified
> doc-fallout pattern from #335/#357.

S-WIN-2 is the code change; S-WIN-6 is the doc change. Both must land before the
feature is considered complete.

**ADR materialization:**
ADR-0016 was authored in `.factory/architecture/adr/0016-windows-build-target.md` during F2.
The existing ADRs (ADR-0001 through ADR-0015) live in `docs/adr/`. Copy ADR-0016 to
`docs/adr/0016-windows-build-target.md`. Do not modify the `.factory/` copy.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| JR_* table format | CLAUDE.md §AI Agent Notes; existing entries | Add two entries in the same bulleted-list format as existing `JR_BASE_URL`, `JR_AUTH_HEADER`, etc. entries. Parallel form: "`JR_CONFIG_DIR` env var overrides the config directory in debug builds (combined with direnv to scope tests; see BC-6.2.017). Debug-only." |
| Windows config/cache path entry | BC-6.2.017 §CLAUDE.md documentation; BC-6.1.014; BC-6.2.016 | Add a brief bullet in the "AI Agent Notes" or "Gotchas" section noting Windows paths: `%APPDATA%\jr` (config) and `%LOCALAPPDATA%\jr` (cache). Reference the BCs. |
| ADR-0016 cross-reference to ADR-0003 | ADR-0016 §See Also | The ADR-0016 body already includes cross-references to ADR-0003 and ADR-0006. The materialized copy in `docs/adr/` must be verbatim from the source. |
| adr-index update | architecture-delta.md §8 | Add ADR-0016 row to `.factory/architecture/adr-index.md`. |
| No spec body changes | F2 is frozen | Do NOT modify any BC or NFR body in `.factory/specs/prd/`. Documentation lives in CLAUDE.md and docs/adr/ only. |

## Library and Framework Requirements

N/A — documentation-only story. No library changes.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `CLAUDE.md` | MODIFY | (1) Add `JR_CONFIG_DIR` entry to JR_* env var table in "AI Agent Notes" section; (2) Add `JR_CACHE_DIR` entry (same section); (3) Add Windows config/cache path note (either in "AI Agent Notes" or under "Gotchas" — whichever is consistent with existing structure) |
| `docs/adr/0016-windows-build-target.md` | CREATE | Verbatim copy of `.factory/architecture/adr/0016-windows-build-target.md` |
| `.factory/architecture/adr-index.md` | MODIFY | Add ADR-0016 row |

## Acceptance Criteria

### AC-001 — CLAUDE.md documents JR_CONFIG_DIR in JR_* env var table
(traces to BC-6.2.017 §CLAUDE.md documentation — JR_CONFIG_DIR must be in JR_* table)

`CLAUDE.md` "AI Agent Notes" section contains a bullet entry for `JR_CONFIG_DIR`
explaining it overrides config directory resolution in debug builds, citing BC-6.2.017,
and noting "Debug builds only" (consistent with neighboring entries like `JR_BASE_URL`).

Pinned by: `test_claude_md_documents_jr_config_dir` (source-text grep of CLAUDE.md)

---

### AC-002 — CLAUDE.md documents JR_CACHE_DIR in JR_* env var table
(traces to BC-6.2.017 §CLAUDE.md documentation — JR_CACHE_DIR must be in JR_* table)

`CLAUDE.md` "AI Agent Notes" section contains a bullet entry for `JR_CACHE_DIR`
with parallel content to AC-001.

Pinned by: `test_claude_md_documents_jr_cache_dir` (source-text grep of CLAUDE.md)

---

### AC-003 — CLAUDE.md notes Windows config/cache paths
(traces to BC-6.1.014; BC-6.2.016 — Windows paths must be documented for agents and developers)

`CLAUDE.md` contains documentation noting that on Windows, the config directory is
`%APPDATA%\jr` and the cache directory is `%LOCALAPPDATA%\jr`. References BC-6.1.014
and BC-6.2.016.

Pinned by: `test_claude_md_documents_windows_paths` (source-text grep)

---

### AC-004 — ADR-0016 is present in docs/adr/
(traces to architecture-delta.md §8 — ADR must be accessible alongside existing ADRs)

`docs/adr/0016-windows-build-target.md` exists and is a verbatim copy of
`.factory/architecture/adr/0016-windows-build-target.md`, including all five top-level
decisions PLUS sub-decisions 5b (keyring Windows Credential Manager) and 5c (OAuth
smoke-step gate), rationale, consequences, and cross-references to ADR-0003 and ADR-0006.

Pinned by: `test_adr_0016_materialized_in_docs_adr` (file existence + grep for both
`5b` and `5c` headings/labels so a truncated copy missing either sub-decision fails)

---

### AC-005 — ADR-0016 row present in adr-index.md (verify/reconcile, do not overwrite)
(traces to architecture-delta.md §8 — ADR registry updated)

`.factory/architecture/adr-index.md` contains an entry for ADR-0016 with status
`Accepted` and a link to the ADR file. **Do NOT overwrite an existing row** — if an
ADR-0016 row is already present (e.g., carrying the 2026-06-13 amendment annotation
"Accepted (amended 2026-06-13: Decision 2 primary zip mechanism clarified; Decision 3
separate-clippy-matrix corrected)"), verify that row is intact and leave it unchanged.
Only add a new row if no ADR-0016 entry exists at all.

Pinned by: `test_adr_index_includes_adr_0016` (substring grep for `ADR-0016` AND
`Accepted` in adr-index.md — NOT a full-title exact match, so the test passes against
both the bare title and the amended-annotation form)

---

## Out of Scope (explicit)

- **CANONICAL-COUNTS.md "Cache Types" Windows path entry** (WIN-O-3): deferred per the
  original prompt (low priority, may be bundled with this story if the implementer
  finds it trivial). The canonical-counts script checks numeric frontmatter; no numeric
  claim changes in this story.
- **User-facing documentation** (README, docs/user-guide): not in scope for this cycle.
- **CHANGELOG entry for Windows support**: tracked as part of the release process, not
  this story.

---

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `CLAUDE.md` | docs | N/A | Developer/agent-facing documentation; no runtime behavior |
| `docs/adr/0016-windows-build-target.md` | docs | N/A | Architecture decision record; copied from .factory/architecture/adr/ |
| `.factory/architecture/adr-index.md` | .factory | N/A | ADR registry |

---

## Edge Cases

| ID | Source | Description | Expected Behavior | AC / BC |
|----|--------|-------------|-------------------|---------|
| EC-001 | CLAUDE.md "When adding a new JR_* var" note | JR_CONFIG_DIR / JR_CACHE_DIR entries must be in the same commit as or after S-WIN-2's code change | This story depends on S-WIN-2 being merged; doc entries should not pre-date the feature implementation | (dependency ordering) |
| EC-002 | adr-index.md format | ADR-0016 row must match existing row format in adr-index | Read the existing ADR-0003 row and match the format exactly | AC-005 |

---

## Test Coverage Summary

| Test name | File | AC |
|-----------|------|-----|
| `test_claude_md_documents_jr_config_dir` | `tests/docs_fallout_windows.rs` (new) | AC-001 |
| `test_claude_md_documents_jr_cache_dir` | same file | AC-002 |
| `test_claude_md_documents_windows_paths` | same file | AC-003 |
| `test_adr_0016_materialized_in_docs_adr` | same file | AC-004 |
| `test_adr_index_includes_adr_0016` | same file | AC-005 |

All tests are source-text greps of the respective files. No runtime behavior tested.

---

## Holdout Scenarios

**H-WIN-10: JR_CONFIG_DIR / JR_CACHE_DIR discoverable in CLAUDE.md**
An agent parsing CLAUDE.md to find available debug env vars for test isolation
finds `JR_CONFIG_DIR` and `JR_CACHE_DIR` in the JR_* table adjacent to
`JR_BASE_URL` and `JR_AUTH_HEADER`.
_Validation: source-text assertions AC-001/AC-002._

---

## Dependency Analysis

**depends_on: ["S-WIN-2"]** — Documentation must follow the implementation.
The `JR_CONFIG_DIR`/`JR_CACHE_DIR` entries must not be added to CLAUDE.md before
the feature exists in the codebase.

**blocks: []** — No other story depends on these docs.

**Can be dispatched in parallel with S-WIN-3, S-WIN-4, S-WIN-5** (those don't depend on docs).

---

## Tasks

1. Read CLAUDE.md "AI Agent Notes" section to find the JR_* env var table format.
2. Add `JR_CONFIG_DIR` and `JR_CACHE_DIR` entries to the JR_* table (same format as `JR_BASE_URL`).
3. Add Windows config/cache path note in CLAUDE.md (either under "AI Agent Notes" or "Gotchas").
4. Read `.factory/architecture/adr/0016-windows-build-target.md`.
5. Copy verbatim to `docs/adr/0016-windows-build-target.md`.
6. Read `.factory/architecture/adr-index.md` to find existing row format.
7. Add ADR-0016 row to adr-index.md.
8. Create `tests/docs_fallout_windows.rs` with 5 source-text grep assertions.
9. Run `cargo test --test docs_fallout_windows` — passes.
10. Run `cargo clippy -- -D warnings` — zero warnings.
11. Run `scripts/check-bc-cumulative-counts.sh` — exits 0 (no BC body changes).

## Story Points and Effort

**2 story points.** Documentation-only changes with lightweight source-text tests.

Breakdown:
- F4 implementation (CLAUDE.md edits + ADR copy + index update + 5 source-text tests): 1.5 SP
- F5/F7 adversarial review + PR: 0.5 SP
