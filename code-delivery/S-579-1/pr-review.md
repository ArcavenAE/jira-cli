# PR Review — S-579-1 `--updated-recent` (PR #725, cycle 1)

- **PR:** https://github.com/Zious11/jira-cli/pull/725
- **Branch:** `feat/issue-updated-recent-filter` → `develop`
- **Head reviewed:** `b1d31d57359cfdda32dfbdbf6d6378e082063827`
- **Reviewer:** pr-reviewer (fresh context, diff + PR description + test evidence only)
- **Verdict: REQUEST_CHANGES** — 1 blocking, 3 suggestions, 1 nit

## Posting mechanism — deviation from contract, unavoidable

`gh pr review 725 --request-changes --body-file …` was **rejected by GitHub**:

```
failed to create review: GraphQL: Review Can not request changes on your own
pull request (addPullRequestReview)
```

The authenticated `gh` account (`Zious11`) is the author of PR #725. GitHub forbids
both `--request-changes` and `--approve` on a self-authored PR, so **no** `gh pr review`
verdict state is reachable on this repo under the current credentials.

Fallback used (NOT `gh pr comment`): `gh pr review 725 --comment --body-file …` — a
formal review object of event type `COMMENT`, carrying an explicit
`Verdict: REQUEST_CHANGES` header in the body. Two inline review comments were posted
via `gh api repos/Zious11/jira-cli/pulls/725/comments`:

- `src/cli/issue/list.rs:171` — https://github.com/Zious11/jira-cli/pull/725#discussion_r3834281511
- `src/cli/issue/list.rs:186` — https://github.com/Zious11/jira-cli/pull/725#discussion_r3834281570

**Process implication for pr-manager:** the "review convergence (pr-reviewer APPROVE)"
pre-merge checklist item cannot be satisfied mechanically on this repo. Either a distinct
reviewer identity/token is provisioned, or the gate must accept a COMMENT-event review
whose body carries the verdict.

## Findings

| # | Severity | Category | Finding |
|---|----------|----------|---------|
| 1 | **blocking** | spec-fidelity | `board_id.is_none()` conjunct is a coarse proxy for board scoping; EC-2.1.023-4 unenforced when a scrum board has no active sprint, and the justifying comment is provably false |
| 2 | suggestion | coverage | 9 of 15 guard conjuncts have no regression test |
| 3 | suggestion | maintainability | Nothing links the 15-condition conjunction to the 15-source message it must track |
| 4 | suggestion | test-quality | AC-003 part (a) does not assert the zero-HTTP property its doc comment claims |
| 5 | nit | style | `#[arg(long = "updated-recent")]` redundant with clap derive default |

---

### 1. [BLOCKING] `config.project.board_id.is_none()` leaves EC-2.1.023-4 unenforced

**Location:** `src/cli/issue/list.rs:171` (conjunct); `:160-168` (justifying comment)
**Category:** spec-fidelity

The Pass-2 fix comment asserts:

> Both a bare `jr issue list` and `jr issue list --recent <d>` succeed in that
> configuration by falling through to the active-sprint resolution below

This is false for a subset of "that configuration", and the guard weakening derived from
it is unsound for that same subset. A configured `board_id` does not imply the board
contributes a scoping clause: in the scrum branch, `Ok(_)` (board exists, no active
sprint) falls back to `parts` seeded only from `project_key`, which is `None` in exactly
the configuration this conjunct was added for. `base_parts` returns empty.

**Reproduction** (local mock HTTP server; scrum board `42`, empty active-sprint list,
`.jr.toml` containing only `board_id = 42`, no default project; debug binary built from
`b1d31d57`):

```
$ jr --no-input issue list
Error: No project or filters specified. Use --project, ... or --jql.     # exit 64

$ jr --no-input issue list --updated-recent 60d
No results found.                                                        # exit 0
# composed JQL actually sent:
updated >= -60d ORDER BY updated DESC

$ jr --no-input issue list --recent 7d
# composed JQL actually sent:
created >= -7d ORDER BY updated DESC
```

Bare `jr issue list` hits the very guard the comment says it falls through, while
`--updated-recent` alone proceeds into an unbounded cross-project query — the outcome
EC-2.1.023-4 exists to prevent.

**Mitigating context (why this is flagged as reasoning/documentation rather than a
demanded behavioral rewrite):**

- `--recent 7d` behaves identically in the same config, so this is **not a regression** —
  it is consistency with a long-standing sibling.
- The query remains time-bounded, just not project-bounded.
- The config is narrow: board set, scrum type, no active sprint, no default project.
- Kanban boards are unaffected (`statusCategory != Done` keeps `base_parts` non-empty).

**Minimum acceptable fix:** correct the comment so it no longer asserts something false,
and state the residual caveat explicitly — `board_id.is_none()` is a proxy for board
scoping that does not hold when a scrum board has no active sprint, and `--updated-recent`
matches `--recent`'s unbounded behavior there by choice.

**Preferred fix** (closes the hole at zero cost to AC-007's zero-HTTP assertion): the
zero-HTTP guarantee only matters in the no-board case; when a board *is* configured the
board-config and sprint-list calls have already happened. Keep the early guard as-is for
the no-board path, and add a backstop immediately after `base_parts` is resolved — if
`base_parts.is_empty()` and `updated_recent.is_some()` and no other filter source is set,
return the same `NO_FILTERS_SPECIFIED_MSG`.

### 2. [SUGGESTION] 9 of 15 guard conjuncts untested

**Location:** `src/cli/issue/list.rs:169-187`
**Category:** coverage

Guard correctness depends on 15 hand-maintained conjuncts. This PR's tests exercise only
six: `project` (AC-001), `recent` (AC-004), `asset` (AC-005), `updated_before` (AC-003b),
the empty case (AC-007), and `board_id` (Pass-2 regression test). A wrong or missing
conjunct for `--assignee`, `--reporter`, `--status`, `--team`, `--open`, `--component`,
`--created-after`, `--created-before`, or `--jql` would ship silently as a spurious exit-64.

All nine were verified correct by direct probe during this review (each returns exit 1 —
network failure against an unroutable base URL — not 64; `--component` returns 64 both
with and without `--updated-recent`, which is the pre-existing
`validate_component_preflight` project-scope error, not this guard). That verification
lives in a review comment, not the suite. The board_id case is proof this class of
omission escapes. A table-driven test iterating each filter flag and asserting
`--updated-recent 60d --<flag> <val>` does not exit 64 would pin all fifteen cheaply.

### 3. [SUGGESTION] Conjunction and message have no enforced link

**Location:** `src/cli/issue/list.rs:43` (const) and `:169-187` (conjunction)
**Category:** maintainability

Extracting `NO_FILTERS_SPECIFIED_MSG` genuinely fixes the *message* half of the drift
hazard the PR's ADR names. The unfixed half: the 15-condition conjunction and the
15-source enumeration inside that constant are two independent hand-maintained lists with
nothing tying them together. Adding a 16th filter flag to `IssueCommand::List` updates
neither, and the failure mode is a silent spurious exit-64 rather than a compile error.
Suggest at minimum a doc-comment on the const naming the guard as its co-maintained sibling.

### 4. [SUGGESTION] AC-003 part (a) does not assert zero HTTP

**Location:** `tests/issue_commands.rs::test_bc_2_1_023_issue_list_updated_recent_conflicts_with_updated_after_only`
**Category:** test-quality

Part (a) asserts the clap conflict exits 2, and its doc comment claims "no HTTP, no
handler code reached" — but the test never asserts that, and the shared `server` later has
mocks mounted on it for part (b). `s606_1_expect_zero_http` is already used elsewhere in
this same block; applying it on its own `MockServer` would make the claim checkable
instead of assumed.

### 5. [NIT] Redundant explicit `long`

**Location:** `src/cli/mod.rs`, `IssueCommand::List::updated_recent`
**Category:** style

`#[arg(long = "updated-recent")]` is what clap's derive already produces for a field named
`updated_recent`; sibling `recent` uses a bare `#[arg(long)]`. Harmless — `component` sets
it explicitly too, so there is precedent either way.

---

## Checklist results

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence | PASS — 3 files, all S-579-1 scoped, no unrelated changes |
| 2 | Description accuracy | PASS — traceability table matches the tests actually present; mutation-testing "0 mutants / passes trivially" note is honest rather than spun |
| 3 | Test coverage | PARTIAL — 8 ACs + M1 positional unit test + board regression test all present; gap is finding 2 |
| 4 | Demo evidence | UNVERIFIED — `.factory/demos/S-579-1/`; `docs/demo-evidence/` does not exist in this repo, so that path is local convention. Behind the information wall; asserted by PR description, not independently checked |
| 5 | Commit quality | PASS — conventional format with story ID; Red-Gate stub removed by the implementing commit, not left behind. `stub(issue):` is a non-standard type but develop is squash-merged, so it never lands |
| 6 | Diff size | PASS — 623/-7, of which 501 lines are tests; production change ~122 lines |
| 7 | Missing changes | PASS — no CHANGELOG/README/docs fallout expected; nearest analogue (#707, `issue list --component`) shipped the identical 3-file shape |
| 8 | Dependency status | PASS — `depends_on: []`; predecessor S-575-1 (#724) already merged to develop |

## Independently verified

- Field-swap correct: `updated >= -{d}`, and AC-008 asserts `created >= -7d` is absent.
- `jql::validate_duration` reused unchanged; `src/jql.rs` is not in the diff, so the PR's
  JQL-injection argument holds — the interpolated value is digits plus one unit character.
- Clause order pinned by exact `Vec<String>` equality
  (`["created >= -7d", "updated >= -60d", asset_clause]`); the M1 fix is real, and the
  integration test's doc comment was correctly downgraded to describe itself as a
  relative-order smoke check.
- Direct execution: `--updated-after` → exit 2; `--updated-before` → composes; `4w2d` →
  exit 64 pre-HTTP with the shared validator's error text; `--updated-recent` alone →
  exit 64 with the amended 15-source message.
- `--help` renders `--updated-recent <UPDATED_RECENT>` with the mirrored description.
- CI at review time: all green except `Test (windows-latest)` pending.
- Review probes left no artifacts; both worktrees clean.
