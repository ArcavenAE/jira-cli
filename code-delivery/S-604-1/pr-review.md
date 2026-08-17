---
story: S-604-1
pr: 703
covered_sha: d20eb2a603a3faa0d1a6ba2cd0e35d140da6174e
base: develop
head: feature/S-604-1-component-foundation
verdict: REQUEST_CHANGES
pass: 2
prior_pass: pr-review-pass1.md
blocking: 4
advisory: 6
critical: 0
high: 0
posting_note: >-
  PR author and reviewer share the Zious11 GitHub account. GitHub rejects
  `gh pr review --approve|--request-changes` on one's own PR. Pass 1 fell back
  to `gh pr comment`, which the pipeline's own validator forbids for verdicts.
  See "Posting" at the foot of this file for the outcome of pass 2's attempt.
reviewed_at: 2026-08-16
---

## PR Review — PR #703 (S-604-1 Component Foundation) — Pass 2

**Verdict: REQUEST_CHANGES** — 0 CRITICAL, 0 HIGH. Four MEDIUM blockers, all in tests
and evidence artifacts; no source-behavior change required.

This is a second, independent fresh-context pass over the same SHA
(`d20eb2a6`). Pass 1 is preserved verbatim at `pr-review-pass1.md`. The two passes
**agree on the verdict and on the corrected test counts** (29 = 16 integration + 13 unit),
derived independently. This pass adds four findings pass 1 did not raise and **corrects one
pass-1 statement** (pass 1 asserts the demo evidence report "IS accurate"; it is not — see
BLOCK-3).

### Verification performed at HEAD `d20eb2a6`

Run in the story worktree `/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-604-1`:

| Check | Result |
|---|---|
| `cargo clippy --all-targets --all-features -- -D warnings` | clean |
| `cargo fmt --all -- --check` | clean |
| `cargo test --lib` | 1127 passed, 0 failed, 11 ignored |
| `cargo test --test component_commands` | 42 passed, 0 failed |
| `git show origin/develop:tests/common/wf.rs \| grep -c "fn test_"` | 26 (pre-existing) |

### Implementation assessment

The shipped slice is correct and I concur with pass 1's focus-item table (BC-8.1.001–004,
BC-8.4.001, BC-2.3.040 two-type split, ADR-0018 model-b writer, ADR-0007 profile-first
argument order, JSON via `output::print_output` → `render_json`). Independently confirmed
highlights: the exit-64 guard precedes `list_components` so no HTTP occurs; the `!input.is_empty()`
conjunct correctly closes the vacuous-truth hole in `chars().all(is_ascii_digit)`; the
deliberate non-glob re-export in `types/jira/mod.rs` prevents the two `Component` types from
colliding; `RelatedIssueCounts.id` is `Option` with a two-test pin for the mock-vs-live drift
class (FIX-576-DL lineage). Security is clean: read-only GETs, no new dependencies, no new
auth or secret path, `types/` free of I/O imports, and `--counts` component ids originate from
Jira's own list response rather than user input.

---

### BLOCKING

**BLOCK-1 — Four test names assert guarantees their bodies do not check.**
*Category: test integrity · Severity: MEDIUM · Not raised in pass 1*

CLAUDE.md (Conventions → Test naming) is explicit: *"a name asserting a guarantee its body
doesn't check is a defect, not a style deviation, and may be corrected independently."* Four
new tests are in that state:

| Test | Name claims | Body actually checks |
|---|---|---|
| `helpers.rs::test_bc_8_4_002_resolve_component_unknown_name_message_and_zero_http` | a message and zero HTTP | only that `MatchResult::None(available)` contains both candidates |
| `helpers.rs::test_bc_8_4_003_resolve_component_ambiguous_name_message_and_zero_http` | a message and zero HTTP | only that `Ambiguous` includes `Backend`/`Backlog` and excludes `Frontend` |
| `helpers.rs::test_bc_8_4_001_resolve_component_numeric_bypass_zero_partial_match_calls` | zero `partial_match` calls | only that the result is `Exact("10042")`; nothing observes a call count |
| `component_commands.rs::test_bc_8_4_004_resolve_component_never_spans_projects` | `resolve_component` does not span projects | never invokes `resolve_component`; runs `jr component list --project PRJA` and asserts PRJB's mock is `.expect(0)` |

The fourth is a genuinely useful assertion — it just belongs to `component list`, not to the
resolver. Neither `..._message...` test can check a message, because no message exists yet
(see BLOCK-4).

**Suggestion:** rename each to what its body proves — e.g.
`test_bc_8_4_002_resolve_component_unknown_name_returns_none_with_candidates`,
`test_bc_8_1_001_component_list_never_calls_another_projects_endpoint` — or strengthen the
bodies. Renaming is the cheaper and more honest fix here.

**BLOCK-2 — PR body overstates test counts; 32 claimed tests do not exist.**
*Category: description accuracy · Severity: MEDIUM · Independently concurs with pass-1 B-1*

The PR body claims *"51 added (42 integration + 9 unit)"*, a `tests-51/51` badge, and a table
row labelled *"(32 additional parameterized and edge-case variants)"*. Actual: **16** new
`#[tokio::test]` functions in `tests/component_commands.rs` and **13** new lib tests (12
`#[test]` + 1 proptest) = **29**. The 42 figure is the integration *binary's* total: 16 new
component tests plus the 26 pre-existing `tests/common/wf.rs` inline tests that link into
every integration binary (confirmed unchanged on develop, `EXPECTED_WF_TEST_COUNT = 26`).
There is no set of 32 variants. This matters because the badge and the Pre-Merge Checklist
line *"Coverage delta is positive (51 new tests, 0 regressions)"* are merge-decision inputs.

**Suggestion:** `29 added (16 integration + 13 unit)`, badge `tests-29/29`, delete the phantom
row. No source change required — the 29 real tests do cover all 19 ACs.

**BLOCK-3 — `evidence-report.md` contains a self-contradicting claim; pass 1's "evidence report is accurate" finding is incorrect.**
*Category: evidence integrity · Severity: MEDIUM · Corrects pass 1*

`docs/demo-evidence/S-604-1/evidence-report.md:185` states, in one sentence, that the call is
`resolve_component("10042", "FOO", &["Backend", "Frontend"])` and then that zero-`partial_match`
is *"confirmed by the test using an empty candidate list and still getting Exact("10042")"*.
The test uses the two-element list; no empty-candidate-list test exists. Separately, lines 34,
100 and 273 repeat BLOCK-2's inflated 42 ("42 tests, all PASS — cover AC-001..AC-009, AC-012"),
so the inflation is **not** confined to the PR body as pass 1 concluded.

**Suggestion:** delete the "empty candidate list" clause (or add such a test, which would also
help BLOCK-1c), and correct the three count references.

**BLOCK-4 — AC-013 and AC-014 are marked PASS, but their pinned user-visible strings exist nowhere.**
*Category: spec compliance · Severity: MEDIUM · Not raised in pass 1*

The story spec pins exact text and exit codes:
`"Component '<input>' not found in project <key>. Available: <comma-joined alphabetical list>."`
and `"Ambiguous component '<input>'. Matches: <candidates>."`, both exit 64. Neither string
appears anywhere in the diff, and no test asserts either — `resolve_component` returns a
`MatchResult` and has **no non-test caller** (`src/cli/component.rs` merely does
`let _ = resolve_component;`). Both ACs are nonetheless listed PASS in the PR body's
traceability table.

**Suggestion:** mark AC-013/AC-014 explicitly deferred to the first consuming story
(S-604-2 / S-605-1), or implement the two messages at a real call site in this PR. Either is
fine; silently claiming PASS is not.

---

### ADVISORY

**ADV-1 — `--counts` fail-soft swallows every error class, not just 5xx.**
*Not raised in pass 1.* `src/cli/component.rs` matches bare `Err(e)` and renders `?`/`null`
with a warning. Spec EC-8.1.003-2 scopes fail-soft to **5xx**. On an expired token a user gets
N warnings, `?` in every row, and **exit 0** instead of an auth error — the failure mode
fail-soft exists to avoid. Suggestion: let 401/403 propagate (`JrError::NotAuthenticated`),
keep fail-soft for 5xx and transport errors.

**ADV-2 — No CHANGELOG entry for a new user-facing command group.**
*Extends pass-1 A-6, which covered CLAUDE.md/`docs/` but not CHANGELOG.* `[Unreleased]` has a
live `### Added` section; `jr component list` adds a whole command group and appears in
neither it nor the README.

**ADV-3 — Doc fallout (concurs with pass-1 A-6/A-7).** CLAUDE.md's architecture tree gains no
entry for `src/cli/component.rs`, `src/api/jira/components.rs`, or
`src/types/jira/component.rs`, and the `cache.rs` line — which enumerates every cache family
and its TTL — omits `components_<profile>.json`. ADR-0018 is cited 11 times in source but has
no `docs/adr/0018-*.md`; the text already exists in the PR body and needs only pasting.

**ADV-4 — `let _ = resolve_component;` in a production handler (concurs with pass-1 A-1).** An
inert statement at the end of `handle_list` whose only purpose is to keep the `pub(crate)`
re-export from tripping `-D warnings`. It achieves precisely what CLAUDE.md's *"No lint
suppression without refactoring"* rule exists to prevent while evading its letter. Cleanest
fix: drop the import and the re-export until S-604-2 lands a caller.

**ADV-5 — `_project` parameter is unused (concurs with pass-1 A-3).** The signature advertises
project scoping that `resolve_component` does not enforce; BC-8.4.004 is caller-enforced by
design, so this is a readability hazard for the five downstream stories, not a bug.

**ADV-6 — Cache filename repeats the profile (concurs with pass-1 C-1).**
`cache_dir(profile).join(format!("components_{profile}.json"))` yields
`~/.cache/jr/v1/<profile>/components_<profile>.json`; every sibling uses a bare name
(`project_meta.json`, `cmdb_fields.json`, `object_type_attrs.json`, `teams.json`). Cosmetic,
but this is a brand-new file and the cheapest moment to align.

**Also noted:** the story spec's `files_modified` lists `src/lib.rs`, which is unchanged and
needs no change — spec drift only. Pass 1's A-2 (cache family has zero non-test call sites),
A-4 (`MatchResult::Exact` means an id for numeric input and a name otherwise), A-5 (a component
named `"100"` is unreachable by name), A-8 (the additive `id` key now appears in
`issue view --output json` component arrays) and A-9 (demo evidence is two-thirds `--help`)
all stand; I concur and do not restate them here.

---

### To clear this review

BLOCK-1 through BLOCK-4 are all test-name, PR-body, and evidence-file edits plus one
AC-status correction — **no source-behavior change is required**. I would additionally fold in
ADV-1 (a real, if narrow, behavior fix), ADV-2 and ADV-3, since CHANGELOG and doc fallout are
codified repo conventions (#335/#357: "add a parallel line in the SAME commit as the code
change") and the ADR text is already written. ADV-4 through ADV-6 and pass 1's A-2/A-4/A-5 are
reasonable to defer to S-604-2 provided the deferral is recorded rather than left implicit.

### Posting

Attempted via the pipeline-required command:

```
gh pr review 703 --request-changes --body-file .factory/code-delivery/S-604-1/pr-review.md
```

Exit code **1**:

```
failed to create review: GraphQL: Review Can not request changes on your own pull request (addPullRequestReview)
```

The PR author and the authenticated reviewer are the same account (`Zious11`), and GitHub
refuses a formal review verdict on one's own pull request. Pass 1 fell back to
`gh pr comment`, which this pipeline's own `validate-pr-review-posted` hook explicitly forbids
for verdicts; **pass 2 did not repeat that fallback**, so no GitHub-side review or comment was
created by this pass. That leaves an unresolved tooling conflict — the pipeline mandates a
posting mechanism GitHub structurally denies for self-authored PRs — which needs a decision
from the human (e.g. a separate reviewer identity/bot token, or an explicit hook exemption for
self-authored PRs). It is recorded here rather than papered over.

**Authoritative signal for `d20eb2a6`:** this file plus the finding-by-finding message
delivered to team-lead. The verdict is REQUEST_CHANGES.
