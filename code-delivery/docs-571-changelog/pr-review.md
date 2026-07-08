# PR #594 Review — docs/571-changelog-code-mark-exclusivity

## Verdict: APPROVE

Fresh-eyes review of the 9-line CHANGELOG-only fix PR closing F5 adversarial
pass 3 finding LOW-1 (MISSING-CHANGELOG-ENTRY). PR #593 shipped the
`push_code` code-mark exclusivity fix (BC-7.2.015, #571) without a CHANGELOG
entry; PR #594 adds it. This review confirms the prior APPROVE verdict from
the earlier pr-reviewer pass and extends it with the six-dimension analysis
from the current task brief.

## Scope

- **Files changed:** `CHANGELOG.md` (+9 lines, 0 removed)
- **Placement:** `[Unreleased] > Fixed`, correctly above `Changed`
- **Code touched:** none

## Findings

No blocking findings. One advisory item on PR body hygiene.

| Severity | Category | Finding | Suggestion |
|----------|----------|---------|------------|
| ADVISORY | pr-body | The PR body checklist item `- [ ] All CI status checks passing (ci-gate)` is unchecked while all 15 CI checks are actually green. | Cosmetic template drift — branch protection gates on the real CI state, not the checkbox. Author may tick the box before merge; reviewer need not block on it. |

## Six-Dimension Review (from task brief)

### 1. Section placement — PASS

Entry inserted at the top of `[Unreleased] > ### Fixed`, between the empty
`### Fixed` header and `### Changed`. Correct semantic category (user-visible
bug fix, not Changed / Added / Security / a versioned section).

### 2. Wording accuracy vs actual fix behavior — PASS

Cross-checked against `src/adf.rs::push_code` and the CLAUDE.md gotcha
documenting the shipped behavior:

- "allowlist filter" — matches (`push_code` strips typographic marks from
  code spans)
- Retained co-marks `link`, `annotation` — matches (`matches!` arm uses
  `Some("link")` OR `Some("annotation")`)
- Stripped `strong`, `em`, `strike`, `subsup` — matches (implicit via
  allowlist exclusion)
- Defensive `underline`, `textColor`, `backgroundColor` also stripped —
  matches (also excluded by allowlist; not currently emitted upstream but
  stripped defensively)
- Failure patterns `` **`x`** `` and `` ^`x`^ `` producing HTTP-400-rejected
  ADF — matches
- Schema rationale ("`code_inline_node` schema forbids typographic marks
  alongside `code`") — matches
- Implementation detail "clone of `active_marks` so surrounding non-code
  text retains its marks unchanged" — verified against
  `self.active_marks.iter().filter(...).cloned().collect()` (produces a new
  `Vec<Value>`; `self.active_marks` is not mutated)
- "`adf_to_text` stays read-lenient by design" — verified; the reverse path
  is not modified in PR #593. Slightly tangential but useful: signals the
  fix is write-side only and third-party ADF still renders

Entry does not overstate or understate the shipped fix.

### 3. No real Jira keys / org data leaked — PASS

Only internal spec IDs (BC-7.2.015) and public GitHub refs (#571, #593). No
instance URLs, no real project keys, no org IDs.

### 4. CHANGELOG format consistency — PASS

Compared against precedent entries in this CHANGELOG:

- Bold lead phrase with em-dash and colon (`**ADF code-mark exclusivity — …:**`)
  — matches #522 / #492 format
- Parenthetical `(BC-<id>, #<issue>):` — matches
- Prose body describing mechanism + failure symptom + Jira HTTP 400 — matches
- Trailing `(#<pr>)` back-ref — matches
- Line-wrap width — consistent with surrounding entries

### 5. F5 finding traceability — PASS

Entry back-refs source PR #593, which is the correct user-facing citation.
Internal factory IDs (F5, LOW-1, MISSING-CHANGELOG-ENTRY) are correctly
absent from the user-facing CHANGELOG; the PR body carries the F5 trace per
the task brief.

### 6. PR body checklist gap — ADVISORY (see table above)

Non-blocking. Cosmetic drift between markdown checkbox and real CI state.

## Checklist Verification (standard 8-item)

1. **Diff Coherence** — PASS. Single file, all changes relate to LOW-1.
2. **Description Accuracy** — PASS. CHANGELOG entry matches what shipped in #593.
3. **Test Coverage** — N/A (doc-only; test coverage for BC-7.2.015 shipped in #593).
4. **Demo Evidence** — N/A (CHANGELOG-only fix from adversarial refinement; no ACs).
5. **Commit Quality** — PASS (inferred from PR title conforming to Conventional Commits).
6. **Diff Size** — PASS (9 lines added, well under 500-line threshold).
7. **Missing Changes** — PASS (F5 finding LOW-1 requires exactly this entry).
8. **Dependency Status** — PASS (upstream PR #593 already merged to develop, commit `7ba4cf4`).

## Summary

Doc-only, single-file, 9-line addition. Accurately describes the shipped
behavior of `push_code`'s allowlist filter, correctly placed under
`[Unreleased] > Fixed`, well-cited (BC-7.2.015, #571, #593), format matches
neighboring entries, no data leakage. Ship it.
