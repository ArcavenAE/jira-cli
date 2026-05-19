# S-288-pr4-dispatch Adversary Pass 03

## Verdict
FINDINGS — counter remains 0/3.

## Findings

### CRITICAL / HIGH
None.

### MEDIUM

**M-01: BC-3.8.011 has no acceptance criterion in story doc**
- Story `bc_anchors:` frontmatter + Behavioral Contracts table list BC-3.8.011, but no AC-NNN entry references it via `(traces to BC-3.8.011 ...)`. Implementation + 5 tests are correct; the spec doc itself has a coverage gap.
- **Fix**: PO adds AC-019 traced to BC-3.8.011.

**M-02: Wire-shape integration tests don't pin top-level `serviceDeskId`/`requestTypeId`**
- Grep for `body["serviceDeskId"]` / `body["requestTypeId"]` in `tests/issue_create_jsm.rs` returns 0. AC-005 numeric-bypass test only asserts list endpoint `expect(0)` + stdout key, not that POST body contains `requestTypeId: "11002"`.
- A regression placing `serviceDeskId` inside `requestFieldValues` or dropping the numeric ID would not be caught.
- **Fix**: test-writer extends AC-005 test + add C.4 proptest in `JsmRequestBuilder` covering top-level IDs.

**M-03: `JrError::InsufficientScope` Display surfaces stale `write:jira-work` legacy workaround text on JSM path**
- `src/error.rs:8-15` hardcodes the legacy workaround text. JSM `map_err` wraps the `message` correctly but Display still emits the full legacy block, mentioning `write:jira-work` (irrelevant to JSM) and citing issue #185 (unrelated bug).
- Users see BOTH the correct JSM hint AND irrelevant legacy advice in the same stderr block. UX polish; not a contract violation.
- **Decision: DEFER to follow-up issue post-merge.** Refactoring `InsufficientScope` Display affects the shared error type used by every API call — out of S-288-pr4 perimeter. Track as a separate "JSM error message cleanup" issue.

### LOW / NIT
- **L-01**: JSM Table mode emits no browse URL (platform mode does). UX asymmetry; defer.

### Process-gap findings
- **PG-01**: No CI check that every BC anchor in story frontmatter has a matching AC reference. Suggested: extend `scripts/check-spec-counts.sh` or add `scripts/check-story-bc-ac-coverage.sh`. File as follow-up.

## Reviewed surfaces
(per adversary's report — full read of all worktree files + spec/story)

## Not reviewed (scope guard)
- pr1-api / pr2-cli regression baselines (assumed converged)
- Other unrelated tests

## Triage / routing

| Finding | Severity | Route | Action |
|---------|----------|-------|--------|
| M-01 | MEDIUM | product-owner | Add AC-019 traced to BC-3.8.011 |
| M-02 | MEDIUM | test-writer | Pin `serviceDeskId`/`requestTypeId` top-level body shape |
| M-03 | MEDIUM | DEFER → post-merge issue | Refactor InsufficientScope Display (out of perimeter) |
| L-01 | LOW | DEFER | UX polish |
| PG-01 | process-gap | follow-up issue | Codify BC↔AC coverage check |

Sequencing: PO + test-writer in parallel; re-dispatch adversary pass-04.

Novelty: **MEDIUM** — M-01 is a real spec-doc gap that survived 3 passes; M-02 is a tight wire-shape coverage gap; M-03 is a pre-existing legacy issue that the JSM path inherits.
