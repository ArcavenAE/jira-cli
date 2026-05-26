---
document_type: consistency-audit
phase: phase-f3-story-decomposition
issue: 327
producer: consistency-validator
date: 2026-05-26
status: READY-FOR-HUMAN-REVIEW
---

# F3 Consistency Audit — Issue #327 (`rand` 0.9 → 0.10 Migration)

Fresh-context second-opinion audit. The auditor had no prior exposure to the F3 work.
All artifact reads are independent; no diff or summary from the story-writer was used.

---

## Check 1 — Story file exists and has required frontmatter

**Result: PASS**

File `/Users/zious/Documents/GITHUB/jira-cli/.factory/stories/S-327-rand-0.10-migration.md` exists and
opens cleanly.

Required field verification:

| Field | Expected | Actual | Status |
|-------|----------|--------|--------|
| `story_id` | `"S-327"` | `"S-327"` | PASS |
| `title` | non-empty | `rand 0.9.4 → 0.10.1: OsRng/TryRngCore symbol-rename migration + deny.toml dual-presence skip (closes #327)` | PASS |
| `wave` | present | `feature-followup` | PASS |
| `status` | `ready` | `ready` | PASS |
| `intent` | `enhancement` | `enhancement` | PASS |
| `feature_type` | `infrastructure` | `infrastructure` | PASS |
| `scope` | `small` | `small` | PASS |
| `issue` | `327` | `327` | PASS |
| `points` | `1` | `1` | PASS |
| `priority` | present | `medium` | PASS |
| `tdd_mode` | present | `strict` | PASS |
| `bc_anchors` | `[BC-1.5.035]` | `[BC-1.5.035]` | PASS |
| `verification_properties` | `[]` | `[]` (with explanatory comment) | PASS |
| `holdout_anchors` | `[]` | `[]` | PASS |
| `nfr_anchors` | `[]` | `[]` | PASS |
| `adr_refs` | `["ADR-0006"]` | `["ADR-0006"]` | PASS |
| `parent_phase` | present | `F3-story-decomposition` | PASS |
| `spec_source` | `.factory/phase-f2-spec-evolution/prd-delta-327.md` | `.factory/phase-f2-spec-evolution/prd-delta-327.md` | PASS |
| `implementation_strategy` | `tdd` | `tdd` | PASS |
| `module_criticality` | `HIGH` | `HIGH` | PASS |
| `breaking_change` | `false` | `false` | PASS |
| `depends_on` | `[]` | `[]` | PASS |
| `files_modified` | must include 4 expected files | `src/api/auth.rs`, `Cargo.toml`, `deny.toml`, `Cargo.lock` | PASS |
| `files_created` | `[]` | `[]` | PASS |

All 24 required frontmatter fields are present with correct values.

---

## Check 2 — BC anchor resolves

**Result: PASS**

`BC-1.5.035` was searched in
`/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/bc-1-auth-identity.md`.

Match found at **line 395**:

```
#### BC-1.5.035: `generate_state()` produces 32 bytes from SysRng encoded as 64 hex chars
```

The title correctly reads `SysRng` (not `OsRng`) — confirming the F2 spec-evolution pass updated
the BC title as claimed. The behavioral claim (32 bytes, 64 hex chars, OS CSPRNG) is confirmed
present in the BC body. No F2/F3 inconsistency detected.

---

## Check 3 — ADR-0006 reference resolves

**Result: PASS**

`/Users/zious/Documents/GITHUB/jira-cli/docs/adr/0006-embedded-jr-oauth-app.md` exists. The
`adr_refs: ["ADR-0006"]` frontmatter field resolves to a real file. The ADR governs the embedded
OAuth app context for which `generate_state` provides CSRF protection — the reference is
semantically appropriate even though no new architectural decision is required by this migration.

---

## Check 4 — `spec_source` field resolves

**Result: PASS**

`/Users/zious/Documents/GITHUB/jira-cli/.factory/phase-f2-spec-evolution/prd-delta-327.md` exists
on disk. The frontmatter `spec_source` field is accurate.

---

## Check 5 — STORY-INDEX.md frontmatter integrity

**Result: PASS**

Frontmatter of `STORY-INDEX.md`:

- `version: "1.4.20"` — present. Prior version per the update log trail was 1.4.19 (S-407 was
  1.4.19; 1.4.20 is a single-minor bump for S-327). Bump is consistent.
- `total_stories: 48` — present.
- `last_updated: 2026-05-26 (S-327 added; feature mode F3; 47→48)` — present, mentions S-327
  explicitly, date matches 2026-05-26, increment 47→48 is correct.

---

## Check 6 — STORY-INDEX.md entry count sanity

**Result: PASS**

Independent count of rows in the **Story Manifest** section (the authoritative table):

- Wave 0: 7 rows (S-0.01 through S-0.07)
- Wave 1: 8 rows (S-1.01 through S-1.08)
- Wave 2: 7 rows (S-2.01 through S-2.07)
- Wave 3: 10 rows (S-3.01 through S-3.10)
- Feature Followup: 16 rows (S-340, S-345, S-346, issue-288-pr1-api, issue-288-pr2-cli,
  issue-288-pr4-dispatch, S-382, S-383, S-392, S-384, S-385, S-388, S-398, S-396, S-407, S-327)

**Total manifest rows: 48.** Matches `total_stories: 48`.

The wave totals (7 + 8 + 7 + 10 + 16) = 48. Arithmetic correct.

Note: the Feature Followup body table (under `## Feature Followup — Audit-followup Test Pins`)
has 13 rows; the 3 issue-288 stories live in the separate `## Cycle 3` table. The 16-story
prose count in the Wave Plan paragraph correctly aggregates across both sections. This is an
established structural pattern that predates S-327 — not introduced by this F3 pass.

---

## Check 7 — Wave plan group prose

**Result: PASS**

The Wave Plan paragraph reads:

> Feature-followup group: 16 stories — S-340, S-345, S-346, issue-288-pr1-api, issue-288-pr2-cli,
> issue-288-pr4-dispatch, S-382, S-383, S-392, S-384, S-385, S-388, S-398, S-396, S-407,
> **S-327** (rand 0.9→0.10 OsRng/TryRngCore symbol-rename migration + deny.toml skip; 2026-05-26)

S-327 is mentioned. The "16 stories" claim matches the 16 story IDs explicitly enumerated
in that same sentence. The count is correct: 13 rows in the Feature Followup standalone table
plus 3 rows in the Cycle 3 table = 16 total feature-followup stories.

---

## Check 8 — Feature Followup table row

**Result: PASS**

The row at line 194 of STORY-INDEX.md:

```
| S-327 | `rand` 0.9.4 → 0.10.1: OsRng/TryRngCore symbol-rename migration + deny.toml dual-presence skip (closes #327) | BC-1.5.035 | — | **ready** — F3 COMPLETE (2026-05-26); awaiting F4 dispatch | small (1 SP) |
```

Verification:

| Sub-check | Expected | Actual | Status |
|-----------|----------|--------|--------|
| Title matches story file title | exact match | exact match | PASS |
| BC anchor column | `BC-1.5.035` | `BC-1.5.035` | PASS |
| Status column | consistent with "ready" | `**ready** — F3 COMPLETE (2026-05-26); awaiting F4 dispatch` | PASS |
| Size column | "small (1 SP)" or equivalent | `small (1 SP)` | PASS |

---

## Check 9 — Story Manifest row

**Result: PASS**

The row at the bottom of the Story Manifest section:

```
| S-327 | feature-followup (feature mode F3) | /Users/zious/Documents/GITHUB/jira-cli/.factory/stories/S-327-rand-0.10-migration.md |
```

Verification:

| Sub-check | Expected | Actual | Status |
|-----------|----------|--------|--------|
| Wave column | `feature-followup` | `feature-followup (feature mode F3)` | PASS |
| File path resolves on disk | yes | confirmed present | PASS |
| Path is absolute | yes | yes (`/Users/zious/...`) | PASS |

---

## Check 10 — AC coverage sanity

**Result: PASS**

The story body contains **8 acceptance criteria** (AC-1 through AC-8):

| AC | Coverage dimension |
|----|-------------------|
| AC-1 | `cargo build` exits 0 — compile-time symbol resolution gate |
| AC-2 | Three existing unit tests pass without modification — CSPRNG behavioral gate |
| AC-3 | `cargo clippy -- -D warnings` exits 0 — zero-warning policy |
| AC-4 | `cargo fmt --all -- --check` exits 0 — formatting unchanged |
| AC-5 | `cargo deny check` exits 0 after deny.toml skip entries — supply-chain gate |
| AC-6 | Rustdoc references `SysRng`, not `OsRng` — spec/implementation consistency |
| AC-7 | No residual `OsRng` or `TryRngCore` in src/ tests/ Cargo.toml — migration completeness |
| AC-8 | Full `cargo test` exits 0 — regression zone (6 stories) remains green |

All required dimensions are covered: build, existing tests pass, clippy, fmt, deny check,
no residual OsRng refs in source, full test suite passes. The count (8 ACs) is at the upper
bound of the 5-8 expected range. Each AC traces explicitly to BC-1.5.035.

---

## Check 11 — Cross-reference to F1/F2 outputs

**Result: PASS**

The story's "Source of Truth" section cites:

| Citation | Path | Resolves |
|----------|------|---------|
| F1 delta analysis | `.factory/phase-f1-delta-analysis/issue-327/delta-analysis.md` | YES |
| F1 BA input | `.factory/phase-f1-delta-analysis/issue-327/business-analyst-input.md` | YES |
| F2 PRD delta | `.factory/phase-f2-spec-evolution/prd-delta-327.md` | YES |
| F2 consistency audit | `.factory/phase-f2-spec-evolution/consistency-audit-327.md` | YES |
| Migration research | `.factory/research/rand-0.10-migration-assessment.md` | YES |
| Perplexity verification | `.factory/research/rand-0.10-perplexity-verification.md` | YES |

All 6 cited files exist on disk. F1 and F2 outputs are both cited and resolve.

---

## Check 12 — No source code modified

**Result: PASS**

`git status --short` output at time of audit:

```
?? .claude/pr-reviews/
?? .claude/spec-config.json
```

The only untracked files are `.claude/pr-reviews/` and `.claude/spec-config.json` — both are
Claude harness artifacts unrelated to this feature. No modifications to `src/`, `tests/`,
`Cargo.toml`, `Cargo.lock`, or `deny.toml` are present. The F3 story-writer correctly
limited changes to `.factory/` spec artifacts only, consistent with the F3 phase boundary
(F4 owns source implementation).

---

## Check 13 — Guard scripts exit 0

**Result: PASS**

All three guard scripts were run independently by the auditor:

| Script | Exit code | Output |
|--------|-----------|--------|
| `scripts/check-spec-counts.sh` | **0** | `OK: all spec counts verified.` |
| `scripts/check-bc-cumulative-counts.sh` | **0** | `OK: all cumulative BC counts verified (583 total across 8 files; Surface H footer checked where present).` |
| `scripts/check-bc-no-numeric-test-counts.sh` | **0** | `OK: no numeric test counts in BC Trace/Source fields.` |

BC count surfaces unchanged (583 total). No count drift introduced by F3.

---

## Additional Observations

### WARN-A — Wave Plan table `story count` column not updated

**Severity: WARN (cosmetic; non-blocking)**

The Wave Plan summary table (top of STORY-INDEX.md) still shows `feature-followup | 1` for the
story count column. This was `1` when the wave was first defined for S-340 and has never been
updated as subsequent feature-followup stories were added. The authoritative count is the Story
Manifest total (48), which is correct. The stale `1` in the summary table is a cosmetic
inconsistency that predates S-327 by many story additions. Not introduced by this F3 pass;
not blocking.

### OBS-B — F3 audit file placement follows F2 precedent

The F2 consistency audits for issues 327, 396, and 407 all live under
`.factory/phase-f2-spec-evolution/consistency-audit-NNN.md`. This F3 audit was placed at
`.factory/phase-f2-spec-evolution/f3-consistency-audit-327.md` to co-locate with the F2 audit
for the same issue while distinguishing the phase via the `f3-` prefix. If a dedicated
`.factory/phase-f3-story-decomposition/` directory is created in the future, this file should
be relocated.

---

## Summary Table

| # | Check | Result | Notes |
|---|-------|--------|-------|
| 1 | Story file exists + required frontmatter (24 fields) | **PASS** | All fields present with correct values |
| 2 | BC-1.5.035 resolves in bc-1-auth-identity.md at ~line 395 with SysRng title | **PASS** | F2 title refresh confirmed |
| 3 | ADR-0006 file resolves | **PASS** | `docs/adr/0006-embedded-jr-oauth-app.md` exists |
| 4 | `spec_source` path resolves | **PASS** | `prd-delta-327.md` exists |
| 5 | STORY-INDEX.md frontmatter: version 1.4.20, total_stories 48, last_updated mentions S-327 | **PASS** | All three correct |
| 6 | Story Manifest row count = total_stories = 48 | **PASS** | Exact count verified programmatically |
| 7 | Wave plan group prose: mentions S-327, 16-story count correct | **PASS** | 16 stories enumerated explicitly; count verified |
| 8 | Feature Followup table row: title, BC anchor, status, size all correct | **PASS** | Exact match on all four sub-checks |
| 9 | Story Manifest row: correct wave, file path resolves | **PASS** | Path confirmed on disk |
| 10 | AC count ≥ 5; covers build, tests, clippy, fmt, deny, OsRng residuals, full test suite | **PASS** | 8 ACs covering all required dimensions |
| 11 | F1 and F2 citations present and resolve | **PASS** | All 6 cited files exist |
| 12 | No source code modified (F4 boundary respected) | **PASS** | git status clean of src/tests/Cargo.* |
| 13 | All 3 guard scripts exit 0 | **PASS** | 583 BCs verified; no count drift |
| WARN-A | Wave plan summary table `story count` column | **WARN** | Stale `1` pre-dates S-327; cosmetic; non-blocking |

**Blocking failures: 0**
**Warnings: 1 (cosmetic, non-blocking, pre-existing)**

---

## Final Verdict

**READY-FOR-HUMAN-REVIEW**

All 13 checks pass. One cosmetic warning (WARN-A: stale story-count cell in the Wave Plan
summary table) is noted but predates this F3 pass and does not block gate approval. The F3
deliverables are internally consistent, correctly traced to F1 and F2 outputs, and leave no
source code footprint (correctly deferring implementation to F4).
