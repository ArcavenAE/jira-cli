---
document_type: consistency-audit
issue: 475
feature: "ADF E2E read-path coverage"
gate: F7-pre-merge
auditor: consistency-validator
created: 2026-06-11
pr: "#499"
branch: test/issue-475-adf-e2e-readpath
commits:
  - d052264
  - ca07cbc
---

# Consistency Audit — Issue #475 ADF E2E Read-Path (F7 Pre-Merge Gate)

## Verdict

**CONSISTENT — clear to merge.**

No blockers. One LOW documentation observation that is a pre-existing spec
divergence (e2e-coverage-spec.md was not updated to reflect the single-token
assertion refinement), already noted in DEC-074 as deferred.

---

## Summary Table

| Check area | Result | Severity |
|------------|--------|----------|
| Story AC count vs implementation | PASS | — |
| Test function names (new/renamed) consistent across artifacts | PASS | — |
| Old name `test_e2e_issue_markdown_description_roundtrip` removal | PASS (with note) | — |
| Gate hardening: #[test] not async, gate-guard covers new test | PASS | — |
| `adf_has_blockquote_in_list_item` helper present and correct | PASS | — |
| `docs/specs/e2e-live-jira-testing.md` rename applied | PASS | — |
| BC Trace fields (7.2.003/004/006) updated, qualitative only | PASS | — |
| BC count invariant (594) | PASS | — |
| NFR count invariant (41) | PASS | — |
| Story count invariant (68) | PASS | — |
| `check-spec-counts.sh` | PASS | — |
| `check-bc-cumulative-counts.sh` | PASS | — |
| `check-bc-no-numeric-test-counts.sh` | PASS | — |
| CLAUDE.md doc-fallout assessment | PASS | — |
| spec-changelog version 1.3.9 | PASS | — |
| Assertion strategy: single-token vs spec multi-word | LOW observation | LOW |
| STORY-INDEX S-475 status ("draft") | ACCEPTABLE | — |

---

## Findings

### [PASS] 1. Story AC count vs implementation

Story `S-475-adf-e2e-readpath.md` declares `acceptance_criteria_count: 4` and defines
AC-1, AC-2, AC-3, AC-4.

Verification in worktree `tests/e2e_live.rs`:

- AC-1 (human-mode view assertions): implemented at lines 9614-9643. Four assertions
  on `stdout_view`: "Header", "snippet", "blockquote", "link".
- AC-2 (listItem normalization): implemented at lines 9649-9671. Three-step assertion
  sequence: positive gate (`adf_has_node_type`), content sanity (`adf_contains_text`),
  absence assertion (`!adf_has_blockquote_in_list_item`).
- AC-3 (comments human-mode): implemented at lines 9703-9730. Three assertions:
  `contains("**body**")`, `contains("*emphasis*")`, `!contains("_emphasis_")`.
- AC-4 (rename): `test_e2e_issue_markdown_description_roundtrip` renamed to
  `test_e2e_markdown_description_produces_heading_node` at line 4607. Clarifying comment
  present in function body at lines 4610-4611.

All 4 ACs fully implemented.

---

### [PASS] 2. Test function names consistent across artifacts

New test name `test_e2e_adf_read_path_human_output`:
- Defined in worktree `tests/e2e_live.rs:9539`
- Referenced in story `S-475-adf-e2e-readpath.md` (AC-1, AC-2, AC-3, Test Coverage table)
- Referenced in `e2e-coverage-spec.md` (BC Anchors table)
- Referenced in BC-7.2.003 Trace field (`bc-7-output-render.md:99`)
- Referenced in BC-7.2.004 Trace field (`bc-7-output-render.md:109`)
- Referenced in BC-7.2.006 Trace field (`bc-7-output-render.md:141`)
- Listed in `docs/specs/e2e-live-jira-testing.md` ADF Read-Path Coverage table (line 169)
- Listed in `spec-changelog.md:60` (v1.3.9 entry)
- Listed in `prd-delta.md:93`

Renamed test `test_e2e_markdown_description_produces_heading_node`:
- Defined in worktree `tests/e2e_live.rs:4607`
- Story AC-4 references both old and new name correctly
- `docs/specs/e2e-live-jira-testing.md` (worktree, line 123): uses new name with
  `BC-7.2.003` annotation and cross-reference to `test_e2e_adf_read_path_human_output`
- BC-7.2.003 Trace field: references new name with "formerly ..." provenance note

All name references are internally consistent within the PR delta.

---

### [PASS] 3. Old name `test_e2e_issue_markdown_description_roundtrip` removal

The old name is ABSENT from:
- `tests/e2e_live.rs` in worktree (grep confirms: zero hits in code; only in provenance notes
  in doc-strings)
- `tests/e2e_cli_surface_guard.rs` (confirmed: SURFACE table keyed on CLI command paths,
  not test function names; no entries for this name)
- Worktree `docs/specs/e2e-live-jira-testing.md`: old name appears ONLY in the
  "Formerly..." provenance note in the ADF Read-Path Coverage table (line 172), which is
  correct and intentional

The old name persists in `.factory/` artifacts as provenance/historical reference — this
is correct. These are: `spec-changelog.md`, `prd-delta.md`, `e2e-coverage-spec.md`,
`adversary-convergence.md`, `f3-story-decomposition.md`, `delta-analysis.md`, and the
story file itself (all use it as "Formerly..." or "rename target" notation).

In the main repo (develop HEAD), `docs/specs/e2e-live-jira-testing.md:123` still shows the
OLD name — but this is correct: the rename is IN the PR branch (the diff confirms the
update is present), so pre-merge the main repo shows the old state. Post-merge it will
show the new name.

---

### [PASS] 4. Gate hardening: #[test] not async, gate-guard covers new test

Critical fix from commit ca07cbc verified:

- `test_e2e_adf_read_path_human_output` is declared `fn` (synchronous), NOT `async fn`.
  Lines 9537-9539: `#[test]`, `#[ignore = "..."]`, `fn test_e2e_adf_read_path_human_output()`.
- The `test_every_ignored_test_has_gate_guard` meta-test (line 1184) was hardened in
  ca07cbc to strip `async ` prefix before checking `fn test_` — so even if a future test
  is declared async, the guard will catch it.
- The new test has `if !e2e_enabled() { return; }` as the first statement in the body
  (line 9540), confirmed.
- F4 notes: the original d052264 commit used `#[tokio::test]` / `async fn`, which caused
  the gate-guard to silently skip validation. ca07cbc correctly de-asynced the test.

---

### [PASS] 5. `adf_has_blockquote_in_list_item` helper present and correct

Helper defined at `tests/e2e_live.rs:9488` (worktree). Implementation matches the
story's specification verbatim: checks `listItem.content` array entries for direct
children with `type == "blockquote"`, then recursively walks the whole tree. The
doc-comment at line 9478 correctly identifies it as used by `test_e2e_adf_read_path_human_output`
(AC-2).

The helper is positioned near the other ADF helpers (lines 9478-9502), consistent with
the story's `File Structure Requirements` ("near line 8960 in `tests/e2e_live.rs`";
the actual file grew since story authoring, so ~9488 is the correct location).

---

### [PASS] 6. `docs/specs/e2e-live-jira-testing.md` rename applied (worktree)

Worktree `docs/specs/e2e-live-jira-testing.md`:
- Line 123: `test_e2e_markdown_description_produces_heading_node` (new name) — CORRECT
- Lines 162-175: New "ADF Read-Path Coverage (issue #475)" section added, with the full
  table of 4 ACs mapping tests to BC anchors and coverage descriptions.

The git diff confirms the change is present in the PR and will update the main repo on merge.

---

### [PASS] 7. BC Trace fields qualitative and correct

All three BC Trace fields in `.factory/specs/prd/bc-7-output-render.md` were updated
in F2 (spec-changelog v1.3.9):

- BC-7.2.003 (line 99): Qualitative — references `test_e2e_adf_read_path_human_output`
  as "first live E2E exercise" and `test_e2e_markdown_description_produces_heading_node`
  with "formerly..." provenance note. No numeric test counts.
- BC-7.2.004 (line 109): Qualitative — references both AC-1 and AC-3 paths.
- BC-7.2.006 (line 141): Qualitative — references AC-2 blockquote-in-listItem sub-case.

`check-bc-no-numeric-test-counts.sh` exits 0 — no numeric test counts in any Trace fields.

---

### [PASS] 8-10. Count invariants BC 594 / NFR 41 / Stories 68

Script results (run from repo root on develop HEAD, which includes the .factory artifacts):

- `check-spec-counts.sh`: **OK** — all spec counts verified.
- `check-bc-cumulative-counts.sh`: **OK** — 594 total BCs across 8 surfaces agree.
- STATE.md line 9: "BC 594. NFR 41. Stories 68."
- STORY-INDEX.md frontmatter `total_stories: 68`; prose line 30 agrees; manifest row 305
  says "Total rows: 68 (matches `total_stories: 68`)".
- spec-changelog.md v1.3.9 impact table: BC 594→594 (delta 0), NFR 41→41.

Story is test-only; no production code changes; no new BCs, NFRs, or count-surface changes.
All invariants hold.

---

### [PASS] 11. CLAUDE.md doc-fallout assessment

The story explicitly states (Architecture Compliance Rules table): "No new JR_* env var
added." The changes are test-only, following existing E2E conventions.

CLAUDE.md assessment:
- No new `JR_*` env vars introduced — no CLAUDE.md AI Agent Notes update required.
- The gate-guard hardening (async fn recognition) is an internal E2E test infrastructure
  concern, already documented by the commit message and covered by the meta-test. The
  existing CLAUDE.md entry at "Live-Jira E2E tests" adequately covers the gate pattern.
- The new `test_e2e_adf_read_path_human_output` is the first human-mode E2E test; the
  `O1-TABLE-ASSERT` deferred item in STATE.md notes the single-token assertion strategy.
  This pattern is novel but does not rise to "CLAUDE.md gotcha" level — it is adequately
  documented in the story's AC-1 rationale and in the test body comments.
- Conclusion: **no CLAUDE.md update is required or missing for this delta.**

---

### [PASS] 12. spec-changelog version 1.3.9

`spec-changelog.md` line 10: `## [1.3.9] - 2026-06-11`. Entry covers the F2 BC Trace
field updates and rename for #475. Three BC fields listed. BC/NFR counts unchanged (0 delta).

---

### [LOW] 13. Assertion strategy: spec multi-word vs implementation single-token

**Severity: LOW (not a blocker).**

`e2e-coverage-spec.md` (lines 113-118) specifies multi-word assertion strings:
`"Section Header"`, `"link text"`, `"code snippet"`, `"nested blockquote text"`.

The implementation (`tests/e2e_live.rs:9627-9642`) uses single-token strings:
`"Header"`, `"snippet"`, `"blockquote"`, `"link"`.

The story (`S-475-adf-e2e-readpath.md`, AC-1 Assertions section) explicitly documents
this divergence from the spec: the single-token strategy is the CORRECT, FINAL behavior,
adopted to resist comfy-table cell-wrap word-splitting. The story explains: "comfy-table
(src/output.rs ContentArrangement::Dynamic) may word-wrap the description cell and insert
a newline between adjacent words, which would cause `contains("Section Header")` to fail."

The spec was not updated to reflect this AC-1 refinement (DEC-074 notes this as
"F3 fresh adversary caught F1 (comfy-table cell-wrap fragility) → fixed"). The spec
remains at the multi-word form as an artifact of the F2→F3 timeline.

**Impact:** No test correctness concern. The implementation is correct; the spec is stale.
The spec is not authoritative over the story for implementation details — the story is
the authoritative AC source (as stated in the story's "Source of Truth" section).

**Recommendation:** Update `e2e-coverage-spec.md` lines 113-118 in a post-merge
cleanup commit (or document as known spec drift). This is LOW priority — the spec is
a non-code artifact with no downstream enforcement.

---

### [ACCEPTABLE] 14. STORY-INDEX S-475 status "draft"

STORY-INDEX.md row 215 shows S-475 as `**draft** — F3 COMPLETE (2026-06-11); awaiting F4 dispatch`.
This is the main-repo (develop HEAD) copy and reflects the pre-implementation state correctly.
The STORY-INDEX is not part of the PR diff (the PR only changes `tests/e2e_live.rs` and
`docs/specs/e2e-live-jira-testing.md`).

STORY-INDEX is a factory-side tracking artifact, not a merge gate requirement for the code
PR. The STATE.md (line 9) accurately reflects the current state: "F4 CONVERGED — entering PR."
Post-merge, the STORY-INDEX should be updated to reflect the story as MERGED, per the pattern
of other completed stories. This is a standard post-merge housekeeping step, not a blocker.

---

## No-findings Checklist

The following were checked and found clean:

- Old function name in `tests/e2e_cli_surface_guard.rs`: absent (SURFACE table is CLI-path keyed)
- New test CLI paths already registered in SURFACE guard (per e2e-coverage-spec.md §AC-4)
- `best_effort_close` called at end of `test_e2e_adf_read_path_human_output` (line ~9732)
- `--label &label` passed at issue creation (line ~9582), satisfying sweeper requirement
- Comment in renamed function body present: "Verifies the forward markdown→ADF direction
  only: asserts a heading node appears in the submitted ADF. Read-path (adf_to_text) coverage
  is in test_e2e_adf_read_path_human_output." (lines 4610-4611)
- No `src/` files modified — confirmed by `git diff --name-only origin/develop...HEAD`
  showing only `docs/specs/e2e-live-jira-testing.md` and `tests/e2e_live.rs`
- No `Cargo.toml` changes (no new dependencies)
- BC Trace fields no numeric counts: `check-bc-no-numeric-test-counts.sh` exits 0

---

## Overall Gate Decision

**PASS — CONSISTENT — clear to merge.**

The delta is internally consistent across story, spec, BC Trace fields, and
implementation. All four ACs are fully implemented. Gate invariants (BC 594, NFR 41,
Stories 68) hold. The gate-guard false-green regression (F-1, async fn) was correctly
identified and fixed in ca07cbc. No CLAUDE.md update is required.

The single LOW observation (spec AC-1 assertion strings not updated to single-token)
is pre-existing spec drift documented in DEC-074, does not affect test correctness, and
does not block the merge gate.

**Recommended action:** Proceed to merge PR #499. Post-merge: update STORY-INDEX.md
S-475 status to MERGED + PR number, and optionally update `e2e-coverage-spec.md` lines
113-118 to document the single-token assertion rationale (LOW priority cleanup).
