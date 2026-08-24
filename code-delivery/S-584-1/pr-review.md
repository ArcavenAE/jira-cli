# PR Review — #732 · S-584-1 "Preserve raw ADF for `--fields comment`"

**Verdict: APPROVE**

Fresh-eyes review of the diff, PR description, and test evidence only.

Clean, genuinely comment-only src change plus non-tautological confirmatory
tests that correctly lock in the pre-existing raw-ADF passthrough. Every
claim in the defensive comments was verified against the actual code, and
all 4 new tests pass green locally.

## Checklist

1. **Diff coherence** — All changes relate to S-584-1 (confirmatory raw-ADF
   passthrough). No unrelated changes. 3 files, +387 lines, additions only.
2. **Description accuracy** — PR body matches the diff (tests + defensive
   comments, zero production logic change).
3. **Test coverage** — 4 confirmatory integration tests added; independently
   run green (`237 passed; 0 failed`).
4. **Demo evidence** — N/A surfaced to this reviewer; confirmatory story with
   integration-test evidence. Not treated as blocking for a comment-only +
   test-only change.
5. **Commit quality** — Conventional format, story ID present, clear messages
   (`test:` / `docs:` with ADV-P#-LOW citations).
6. **Diff size** — Small (+387, mostly a fixture + 4 tests). Well under 500
   production lines; zero production logic.
7. **Missing changes** — None. Story is confirmatory; no production delta
   expected or present.
8. **Dependency status** — No upstream PR dependency observed.

## What I verified

- **Src is truly comment-only.** Every added line in `list.rs` (+12) and
  `view.rs` (+13) is a `//` comment. Production path untouched; regression
  risk on the code path is nil.
- **Defensive comments are accurate and correctly placed.**
  - `IssueFields.extra` is `#[serde(flatten)] pub extra: HashMap<String, Value>`
    (`src/types/jira/issue.rs:79-80`) — the "unnamed `--fields` lands in the
    flatten catch-all" claim is correct.
  - Comments sit immediately above the correct `--fields` dispatch blocks
    (`if let Some(field_list)` → `search_issues_with_fields` in list.rs;
    `if let Some(csv)` → `get_issue_with_fields` in view.rs).
  - Serialization routes through `output::print_output` → `render_json` →
    `to_string_pretty` (`src/output.rs:20-39`) — "ZERO transformation" claim
    is accurate; JSON render invariant (#526) respected.
  - Cross-references consistent (list.rs → "See also BC-2.3.042"; view.rs →
    "See also BC-2.2.034").
- **Tests prove the guarantee (non-tautological).** Fixture is a real ADF doc
  with a `strong`-marked run and a two-item `bulletList`. AC-001/002 assert
  `body` deep-equals the doc object and `body["type"] == "doc"`. If the code
  ever flattened via `adf_to_text`, `body` would be a plain string and the
  assertion would fail — the guarantee is proven by construction.
- **Cross-path independence covered.** AC-003 runs the same fixture through
  the pre-existing `issue comments` command and asserts flattened plain text
  with no raw ADF. AC-004 covers pre-HTTP exit-64 rejection (with a
  zero-requests assertion) and that the untouched table-mode description
  `adf_to_text` site still works.
- **Conventions.** Test names follow the repo `test_bc_…` pattern; no new
  direct `serde_json::to_string_pretty` in production; output channels
  unchanged.

## Findings

| Severity | Category | Finding | Suggestion |
|----------|----------|---------|------------|
| nit | coverage | AC-003's negative guard `!stdout.contains("\"type\":")` is mildly fragile against future human-output formatting that could legitimately print a `"type":` substring. | Acceptable as-is; the quoted-key form is specific enough for a confirmatory regression test. No change required. |

No BLOCKING or SUGGESTION findings. Recommend merge.
