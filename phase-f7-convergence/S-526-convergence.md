---
document_type: delta-convergence-report
story_id: S-526
title: "F7 Delta Convergence — S-526 JSON-render unification (CR-002)"
phase: feature-f7
producer: consistency-validator
version: "1.0.0"
traces_to: .factory/stories/S-526-unify-json-render.md
timestamp: 2026-06-17T00:00:00Z
---

# F7 Delta Convergence Report: S-526 — JSON-Render Unification (CR-002)

## Feature Summary

- Feature request: GitHub issue #526 / spec `.factory/phase-f1-delta-analysis/bundle-c-2026-06-17.md §CR-002`
- Story: `.factory/stories/S-526-unify-json-render.md`
- Governing BC: BC-7.1.001
- Branch: `chore/unify-json-render` (3 commits ahead of `develop`)
- Files changed: 0 new, 10 modified
- Sites migrated: 24 `serde_json::to_string_pretty` (byte-identical) + 2 compact `serde_json::json!` Display (intentional compact→pretty output change)

---

## Five-Dimensional Convergence (Delta)

| Dimension | Status | Evidence |
|-----------|--------|----------|
| 1. Spec ↔ Implementation | CONVERGED | All 4 ACs satisfied; enumeration claim verified (24+2=26 sites); behavior-change disclosure accurate |
| 2. Tests | CONVERGED | F6 regression 1309/0 green; mutation 5/5; behavior-change sites covered by format-agnostic assertions |
| 3. Implementation | CONVERGED | F5 3/3 clean (round 3); zero bypass sites remaining in src/cli/ |
| 4. Verification | CONVERGED | Mutation 100% diff-scoped; audit/deny clean (reported F6); no security surface |
| 5. Documentation | FINDING — see below | STORY-INDEX drift; no stale CLAUDE.md found; one recommended note |

---

## Dimension 1: Spec ↔ Implementation

### AC-001 — Byte-identical on to_string_pretty sites

VERIFIED. The diff shows exactly 24 `serde_json::to_string_pretty` removals, all replaced with `output::render_json` which is `Ok(serde_json::to_string_pretty(data)?)`. The serializer is identical; only the error type changes (serde_json::Error → anyhow::Error). No snapshot files were modified, confirming byte-identity. Auth JSON snapshot files (`jr__cli__auth__tests__auth_login_json_shape.snap` etc.) are already in pretty-printed format and are unchanged.

### AC-002 — Every OutputFormat::Json arm routes through output::render_json

VERIFIED by enumeration.

Total `OutputFormat::Json` arms across `src/cli/`: **40** (including out-of-scope files like `assets/`, `sprint.rs`, `worklog.rs`, etc.).

Arms in the 10 modified files: **25 direct match arms** + 1 function-level call within `render_list_json` (called from `auth/list.rs` arm) = **~26 serialization sites**, consistent with the story's "approximately 26" claim.

Zero bypass sites remain:

```
grep -rn "serde_json::to_string_pretty" src/cli/   → 0 matches
```

The 2 compact `serde_json::json!` Display sites (create.rs line 2723, project.rs line 85-90) are now routed through `output::render_json`.

All out-of-scope files that have `OutputFormat::Json` arms also route correctly:
- `src/cli/worklog.rs`: `output::render_json`
- `src/cli/requesttype.rs`: `output::print_output` (which internally calls `render_json` at `src/output.rs:39`)
- `src/cli/sprint.rs`: already using `output::render_json` (3 sites — the reference implementation)
- `src/cli/issue/view.rs`, `assets/`, etc.: all use `output::render_json` or `output::print_output`

No exceptions with `// AC-002 exception:` comment required.

### AC-003 — Test suite passes, at most two snapshot updates

VERIFIED. No snapshot files were modified (confirmed via `git diff --name-only origin/develop...HEAD -- "*.snap"` returns empty). The two behavior-change sites (`handle_jsm_create`, `project fields`) have existing tests that use `serde_json::from_str` / `serde_json::from_slice` to parse output — both are format-agnostic and pass without modification.

### AC-004 — Clippy + fmt clean

RECORDED as PASS per F6 hardening summary. No suppressed warnings were introduced. Import cleanup performed correctly (`crate::output` added where missing; `serde_json` imports not orphaned since `serde_json` is used elsewhere in those files).

### Behavior-Change Disclosure Accuracy

Both disclosures are factually accurate as verified against the worktree code:

| Command | Payload | Before | After | Verified |
|---------|---------|--------|-------|----------|
| `jr issue create --request-type <RT> --output json` | `{"key": "<ISSUE-KEY>"}` only | Compact single-line | Pretty multi-line | `src/cli/issue/create.rs:2718-2724` |
| `jr project fields --output json` | `{project, issue_types, priorities, statuses_by_issue_type, asset_fields}` | Compact single-line | Pretty multi-line | `src/cli/project.rs:82-93` |

The story's Behavior-Change Disclosure note that `handle_jsm_create` returns only `key` (not `requestTypeId` and `serviceDeskId`) is **accurate** — the code at line 2718 emits `serde_json::json!({"key": issue_key})` which contains only the key.

### files_modified accuracy

Story claims 10 files modified. Diff confirms exactly 10: `src/cli/auth/list.rs`, `src/cli/auth/login.rs`, `src/cli/auth/logout.rs`, `src/cli/auth/refresh.rs`, `src/cli/auth/remove.rs`, `src/cli/auth/switch.rs`, `src/cli/issue/create.rs`, `src/cli/issue/links.rs`, `src/cli/issue/workflow.rs`, `src/cli/project.rs`. MATCH.

---

## Dimension 2: Tests

### Regression baseline

F6 reported: **1309/0** (1309 passing, 0 failing). Regression PASS.

### Behavior-change sites coverage

Both behavior-change sites are covered by format-agnostic tests:

1. `handle_jsm_create`: `tests/issue_create_jsm.rs::test_jsm_create_output_json_shape_matches_platform` — calls `serde_json::from_str(&stdout)` and asserts `parsed.get("key") == Some("HELP-42")`. Does not do byte-exact string matching. No snapshot. Passes before and after the compact→pretty change.

2. `jr project fields`: `tests/e2e_live.rs::test_e2e_project_fields_returns_object` — calls `serde_json::from_slice(&output.stdout)` and asserts structure. Format-agnostic. Non-E2E wiremock integration test for project fields JSON does not exist (the command's JSON output is only tested via live E2E).

**Assessment (coverage gap classification):** The absence of a wiremock-level integration test for `jr project fields --output json` is a PRE-EXISTING gap, not introduced by this story. AC-003 explicitly permits this (no new test files are required). The format-agnostic E2E test provides adequate coverage of the structure contract. **Acceptable.**

### 24 byte-identical migration sites coverage

All 24 `to_string_pretty` sites are covered by the existing test suite (auth JSON snapshots + issue workflow integration tests + link integration tests). The existing snapshot files already contain pretty-printed JSON output, confirming these tests will continue to pass byte-for-byte. **Adequate.**

### Mutation testing

F6 reported: **5/5 diff-scoped mutations killed**. Given the nature of the change (pure function substitution with identical output), this rate confirms the tests do exercise the changed paths.

---

## Dimension 3: Implementation

F5 adversarial review converged at **round 3 (3/3 clean)**. The critical F5 finding (C-1/F-2: `project.rs` compact Display site missed by single-line grep) was resolved by:
1. Adding `project.rs` to `files_modified` in the story
2. Adding task T-2.5 for `project.rs` migration
3. Strengthening AC-002 to use enumeration-based audit instead of single-line grep negation

The implementation contains no out-of-scope changes. The diff modifies only the 10 declared files and makes only the declared substitutions plus import adjustments (`use crate::output;` added where absent).

One stylistic observation: the diff also simplifies some `crate::output::print_success` / `crate::output::print_warning` calls to `output::print_success` / `output::print_warning` in files where `use crate::output;` was being added. This is consistent cleanup within scope.

---

## Dimension 4: Verification

- **Mutation testing**: 5/5 kill rate on diff-scoped mutations (F6 reported). PASS.
- **Audit/deny**: Clean (F6 reported). No new dependencies introduced (`Cargo.toml` unchanged).
- **Security surface**: None. This is a pure refactor of string-serialization call paths. No new network calls, no new key handling, no new capabilities.
- **Purity boundary**: `output::render_json` is a pure function (`&T: Serialize → anyhow::Result<String>`). All callers are effectful CLI handlers. No boundary violation.

---

## Dimension 5: Documentation

### Finding DOC-1 — STORY-INDEX does not contain S-526 (MEDIUM severity, should be tracked)

**File:** `/Users/zious/Documents/GITHUB/jira-cli/.factory/stories/STORY-INDEX.md`

S-526 is absent from:
- The Feature-Followup story table (lines 177–338)
- The Story Manifest section (lines 339–445)

Current `total_stories: 77` (S-522 is the last entry). After S-526 is shipped, both the table and the manifest row and the `total_stories` frontmatter need updating to 78.

**Recommendation:** **Track separately** from this PR. STORY-INDEX updates are factory-side bookkeeping that happen after merge, not a PR blocker. Add as a post-merge task.

### Finding DOC-2 — No stale CLAUDE.md documentation found (PASS)

The CLAUDE.md Gotcha at line 212 for `jr issue create --request-type` does not mention output format. No documentation asserts compact JSON for either of the two changed commands. The compact format was an undocumented implementation detail, not a documented contract. **No CLAUDE.md update is required** for the behavior-change disclosures.

### Finding DOC-3 — Recommended CLAUDE.md note (LOW severity, optional)

**Recommendation:** A note clarifying that ALL `--output json` paths in `jr` CLI now route through `output::render_json` (and are therefore always pretty-printed) would be useful for future contributors. This is informational, not correctness-critical. Suggested addition to the Architecture Compliance section:

> **All `--output json` paths route through `output::render_json` (src/cli/):** After S-526, every `OutputFormat::Json` arm in `src/cli/` emits via `output::render_json` or `output::print_output` (which calls `render_json` internally). Future JSON output paths MUST use one of these two; direct `serde_json::to_string_pretty` calls in `src/cli/` are forbidden. Enforced by AC-002 enumeration-based audit.

**Recommendation:** Include in this PR (low-effort, prevents the same class of bypass from re-appearing, directly motivated by the F5 finding C-1/F-2). If preferred, track separately.

### Finding DOC-4 — No other stale documentation found

Searched: `CLAUDE.md`, `docs/specs/json-output-shapes.md`, `docs/specs/issue-create-json-full-shape.md`, `docs/specs/jsm-e2e-coverage.md`. None reference compact JSON format for `jr issue create --request-type --output json` or `jr project fields --output json`. No stale documentation found.

---

## Regression Validation

| Metric | Baseline (develop) | This branch | Status |
|--------|-------------------|-------------|--------|
| Total tests passing | — | 1309 | PASS (F6) |
| Test failures | — | 0 | PASS (F6) |
| New tests added | — | 0 | Expected (AC-003) |
| Snapshot files modified | — | 0 | Expected (format-agnostic tests) |
| Files changed | — | 10 | Matches story |
| New dependencies | — | 0 | Expected |

---

## Traceability Chain (Delta)

```
BC-7.1.001 (--output json emits structured JSON)
  → S-526 (replace all direct JSON serialization with output::render_json)
    → AC-001 (byte-identical for 24 to_string_pretty sites)
      → src/cli/issue/create.rs (6 sites)
      → src/cli/issue/workflow.rs (8 sites)
      → src/cli/issue/links.rs (4 sites)
      → src/cli/auth/{login,logout,switch,remove,list,refresh}.rs (6 sites)
    → AC-002 (all OutputFormat::Json arms route through render_json)
      → 25 direct arms + render_list_json fn = ~26 sites: ZERO bypass remains
    → AC-003 (test suite green, 0 snapshot updates)
      → 1309/0 regression (F6)
      → format-agnostic tests for 2 behavior-change sites
    → AC-004 (clippy + fmt clean)
      → F6 PASS
  → Behavior-Change Disclosure
    → src/cli/issue/create.rs::handle_jsm_create (compact → pretty, key only)
    → src/cli/project.rs::handle_fields (compact → pretty, 5 keys)
```

Cross-reference to existing features:
```
S-526 depends_on: BC-7.1.001 (existing, unchanged)
S-526 extends: src/output.rs::render_json (existing helper, unchanged)
S-526 is-sibling-of: S-288-pr4 (JSM create dispatch; defines handle_jsm_create)
```

---

## Overall Verdict

**F7 CONVERGED** — with one post-merge tracking item.

| Dimension | Verdict |
|-----------|---------|
| 1. Spec ↔ Implementation | CONVERGED |
| 2. Tests | CONVERGED |
| 3. Implementation | CONVERGED |
| 4. Verification | CONVERGED |
| 5. Documentation | CONVERGED (with tracked items) |

**Blocking findings:** None.

**Post-merge action required:**
1. Update `.factory/stories/STORY-INDEX.md`: add S-526 row to Feature-Followup table and Manifest section; increment `total_stories: 77 → 78`. (DOC-1, factory bookkeeping, not a PR blocker)

**Optional include-in-PR:**
2. Add CLAUDE.md note about `output::render_json` requirement for future `OutputFormat::Json` arms. (DOC-3, low-effort, prevents recurrence of F5 C-1/F-2 class)

**READY FOR MERGE.**
