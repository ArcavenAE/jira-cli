---
document_type: delta-analysis
issue: null
title: "fix(cli): allow leading-hyphen values for all free-text write-command inputs"
intent: bugfix
feature_type: backend
trivial_scope: true
routing: trivial-scope
new_bcs: []
modified_bcs:
  - BC-3.3.008 (annotation only — no semantics change)
regression_risk: LOW
created: "2026-06-10"
scope_args: 7
scope_args_list:
  - "issue create --summary"
  - "issue create --description"
  - "issue edit --summary"
  - "issue edit --description"
  - "worklog add --message"
  - "issue comment <message> (positional)"
  - "issue remote-link --title"
---

# Phase F1 Delta Analysis — description-leading-dash

> **Scope expansion log:** F1 was originally drafted scoping the fix to `--description`
> only (create + edit, 2 args). On 2026-06-11, a human decision expanded scope to cover
> ALL free-text write-command inputs — same one-attribute fix (`allow_hyphen_values = true`)
> applied uniformly across 5 named flags. During F5 adversarial review the `issue comment`
> positional `<message>` argument was identified as the same class of gap (clap derive
> rejects positional values beginning with `-` too — see §2 correction below) and added
> as a 6th fix. A subsequent human-confirmed pass (2026-06-11) added `issue remote-link
> --title` as a 7th fix (Finding F-04). Findings F-01, F-02, F-03, and F-04 (originally
> deferred or surfaced during review) are RESOLVED IN THIS PR. `trivial_scope: true` and
> `routing: trivial-scope` are preserved — the expansion is the same one-attribute pattern
> repeated; no BC or handler changes.

## Bug

`jr issue create --markdown --description "- [ ] todo"` fails with a clap parse error
(`error: unexpected argument '- ' found`) before any handler runs. The `--description`
arg on both `issue create` and `issue edit` is declared without `allow_hyphen_values`,
so clap treats any value beginning with `-` as an unrecognized flag. This makes the
most natural CLI form for GFM task lists (the flagship #471 feature) unreachable.

The same gap affects `--summary` (create + edit), `worklog add --message`, the
`issue comment` positional `<message>` argument, and `issue remote-link --title`.
All seven are fixed in this PR.

**Confirmed repro forms:**
- `--description "- [ ] x"` (space form) → clap rejects
- `--description="- [ ] x"` (equals form) → parses fine
- `--description-stdin` (piped) → parses fine

The bug was surfaced by nightly E2E workflow run `27318191693` on PR #495 merge to
develop: `test_e2e_markdown_task_list_produces_task_items` failed at the `create.status.success()`
assert (line ~9056 of `tests/e2e_live.rs`). 88 passed / 1 failed. The second task-list
E2E test (`test_e2e_markdown_ordered_task_list_produces_task_items`) uses `"1. [ ] …"` (no
leading dash) and therefore passed.

---

## 1. Impact Boundary

### 1.1 Files Affected

| File | Change | Detail |
|------|--------|--------|
| `src/cli/mod.rs` | MODIFIED | Add `allow_hyphen_values = true` to 7 args: `--summary` (create + edit), `--description` (create + edit), `worklog add --message`, `issue comment` positional `<message>`, and `issue remote-link --title` |
| `tests/cli_smoke.rs` | MODIFIED | +17 hermetic parse-level regression tests (7 canonical one-per-arg + 10 from adversarial findings: 2 conflict-survival F-M1, 2 positional/ordering O-1/O-2, 4 flag-binding F5-P5-01, 2 edge-case F-L1); total test count: 44 (27 baseline + 17 new) |
| Nothing else | UNCHANGED | Handlers, API layer, ADF converter, types, cache — all untouched |

### 1.2 Exact Locations in `src/cli/mod.rs`

**issue create `--summary` — ~line 356:**
Add `allow_hyphen_values = true` to the `#[arg(...)]` decorator on the `summary` field.

**issue create `--description` — ~line 362:**
```
#[arg(short, long, conflicts_with = "description_stdin")]
description: Option<String>,
```
Add `allow_hyphen_values = true` to the `#[arg(...)]` decorator.

**issue edit `--summary` — ~line 439:**
Add `allow_hyphen_values = true` to the `#[arg(...)]` decorator on the `summary` field.

**issue edit `--description` — ~line 469:**
```
#[arg(short, long, conflicts_with = "description_stdin")]
description: Option<String>,
```
Add `allow_hyphen_values = true` to the `#[arg(...)]` decorator.

**worklog add `--message` — ~line 813:**
Add `allow_hyphen_values = true` to the `#[arg(...)]` decorator on the `message` field.

**issue comment positional `<message>` — ~line 544:**
Add `allow_hyphen_values = true` to the `#[arg(...)]` decorator on the positional
`message` field. See §2 for why positionals require the same treatment.

**issue remote-link `--title` — ~line 652:**
Add `allow_hyphen_values = true` to the `#[arg(...)]` decorator on the `title` field.
A remote-link title beginning with `-` (e.g., a dash-prefixed label like `- RFC: foo`)
would otherwise be rejected at parse time before any handler runs.

No changes to `src/cli/issue/create.rs`, `src/cli/issue/workflow.rs`, or any other handler.
The fix is confined to the clap attribute layer; the parsed `String`/`Option<String>` values
flow to handlers unchanged.

### 1.3 Handler Verification

The create handler (`cli/issue/create.rs::handle_create`) and edit handler
(`cli/issue/create.rs::handle_edit`) both receive `description: Option<String>` from the
parsed struct and pass it directly through. No handler code treats a leading-dash value
specially; the fix is entirely parse-layer.

---

## 2. Adjacent-Flag Audit

The following free-text flags were audited for the same leading-dash gap. All gaps found
are **RESOLVED IN THIS PR** — scope was expanded by human decision on 2026-06-11.

> **Correction — positional arguments ARE subject to leading-dash rejection:**
> An earlier version of this document stated "Positional arguments in clap are NOT subject
> to the leading-dash rejection; they are collected by position." This was incorrect.
> Empirically verified: `jr issue comment FOO-1 "- a note"` is rejected by clap derive
> with `error: unexpected argument '- a note' found` — the same class of error as named
> flags. Clap derive rejects positional values beginning with `-` unless the positional
> field carries `allow_hyphen_values = true` (or the user inserts `--` before the value,
> which is awkward when other flags follow and breaks shell-script patterns). This is why
> the `issue comment` positional `<message>` required the same fix as the named flags.

| Flag | Command | Status |
|------|---------|--------|
| `--summary` (create) | `issue create` | **RESOLVED — Finding F-01, fixed in this PR** |
| `--summary` (edit) | `issue edit` | **RESOLVED — Finding F-01, fixed in this PR** |
| `--description` (create) | `issue create` | **RESOLVED — original bug, fixed in this PR** |
| `--description` (edit) | `issue edit` | **RESOLVED — original bug, fixed in this PR** |
| `comment <message>` | `issue comment` | **RESOLVED — Finding F-03, added during F5; positional gap, fixed in this PR** |
| `--message` | `worklog add` | **RESOLVED — Finding F-02, fixed in this PR** |
| `--title` | `issue remote-link` | **RESOLVED — Finding F-04, fixed in this PR** |

**Finding F-01 (RESOLVED IN THIS PR):** `--summary` on both `issue create` and
`issue edit` lacked `allow_hyphen_values`. A summary like `--summary "- My note"` was
rejected by clap. Fixed in this PR alongside `--description`.

**Finding F-02 (RESOLVED IN THIS PR):** `worklog add --message` lacked
`allow_hyphen_values`. Fixed in this PR alongside `--description`.

**Finding F-03 — `issue comment` positional (RESOLVED IN THIS PR, added during F5):**
`issue comment <message>` (positional arg) lacked `allow_hyphen_values`. Discovered
during F5 adversarial review as the same class of gap. Empirically confirmed:
`jr issue comment FOO-1 "- a note"` fails without the fix. Fixed in this PR.

**Finding F-04 — `issue remote-link --title` (RESOLVED IN THIS PR):**
`issue remote-link --title` lacked `allow_hyphen_values`. A remote-link title beginning
with `-` (e.g., `--title "- RFC: foo"`) would be rejected at parse time. Same class of
defect; confirmed and fixed in this PR.

**In-scope fix: all 7 free-text write-command inputs.** One-attribute change repeated
uniformly; trivial-scope routing preserved.

---

## 3. Affected Specs / BCs / Stories

### 3.1 New BCs

**None.** This bug affects clap arg parsing, not behavior contracts. No new behavioral
contract is introduced — the description field already accepted arbitrary text as a
semantic matter; the fix removes an incorrect parse-time rejection. BC-3.3.008 and
BC-3.4.003 implicitly assume `--description` accepts the description value; they do not
need new BC entries.

### 3.2 Modified BCs

**BC-3.3.008** (`issue create --markdown -d '...'` converts markdown to ADF before POST)
and **BC-3.4.003** (`issue edit` with ADF description) may receive an annotation note in
their bodies to record that leading-dash values are now explicitly accepted via
`allow_hyphen_values`. This is a clarifying annotation only — the BC semantics are
unchanged. Optional; not required for F4 correctness.

**BC-3.4.007** (`--description` and `--description-stdin` clap conflict) is UNCHANGED
— the `conflicts_with` constraint remains in place alongside `allow_hyphen_values`.

### 3.3 Affected Stories

No existing stories are affected. No new F3 story is required (trivial-scope routing
goes directly to F4 implementation). The F4 implementer works from this delta-analysis
document directly.

### 3.4 Existing Tests That Cover `--description`

| Test | File | Relation to Fix |
|------|------|-----------------|
| `test_edit_description_and_description_stdin_conflict` | `tests/cli_smoke.rs:34` | UNAFFECTED — tests the `conflicts_with` constraint, not the hyphen-value behavior |
| `test_create_description_and_description_stdin_conflict` | `tests/cli_smoke.rs:238` | UNAFFECTED — same reason |
| `test_edit_issue_with_description` | `tests/issue_commands.rs:610` | UNAFFECTED — integration test uses non-hyphen description |
| `test_e2e_markdown_task_list_produces_task_items` | `tests/e2e_live.rs:9025` | DIRECT REGRESSION — this test is what exposed the bug; it should pass after fix |

No existing test asserts that a leading-dash description is REJECTED. There is no test
to remove or update.

---

## 4. Regression Risk

**Risk Level: LOW**

### 4.1 Behavior Change for Existing Valid Invocations

`allow_hyphen_values = true` changes parsing behavior in two ways:

1. Values beginning with `-` are now accepted — this is the desired fix.
2. If a caller accidentally omits the description value (e.g., `jr issue create -s "Title" -d --markdown`),
   clap will consume `--markdown` as the description value instead of rejecting the missing
   argument. This is the standard `allow_hyphen_values` tradeoff, documented in clap's own
   docs. Mitigated by: `--description-stdin` remains the escape hatch for complex pipelines;
   the equals-form (`--description="-val"`) already worked and continues to work.

### 4.2 No Existing Rejection Test

There is no test that asserts `--description "- val"` FAILS. Adding `allow_hyphen_values`
cannot break any existing test.

### 4.3 Conflict Constraint Preserved

The `conflicts_with = "description_stdin"` constraint is orthogonal to `allow_hyphen_values`
and remains in place. BC-3.4.007 coverage is unaffected.

### 4.4 Summary of Risk

The only risk is the "missing value swallows next flag" tradeoff inherent to
`allow_hyphen_values`. This is universally accepted for free-text fields across CLIs
(git, gh, etc.) and is the same tradeoff present in every other free-text flag in the
codebase. Risk is LOW.

---

## 5. Routing Decision

**Trivial-scope (fast-track F4 → F7).**

Justification:
- Change is a single `#[arg]` attribute addition in seven places in one file.
- No new BC, no new NodeKind, no new ADF node, no handler change.
- No API layer change, no type change, no cache change.
- No existing test breaks.
- Regression tests are straightforward hermetic parse-level tests (model: `tests/cli_smoke.rs`).
- The fix is purely a clap configuration correction; no spec ambiguity to resolve.
- Scope expansion (2 args → 7 args) does not change the analysis — the pattern is identical
  for every arg; no new complexity is introduced.

The trivial-scope routing is unambiguous. Full F2-F7 would be disproportionate for a
seven-attribute change with no BC additions.

---

## 6. GitHub Issue Recommendation

**Recommend filing a new GitHub tracking issue.**

Rationale: the nightly E2E run surfaced a real regression against the #471 feature. The
bug is reproducible, has a known cause, and a confirmed fix. A tracking issue provides:
- A public record of the defect for changelog and release notes.
- An anchor for the PR description (the fix PR should close this issue).
- Traceability from the E2E failure to the resolution.

**Suggested title:** `bug(cli): --description rejects leading-dash values (e.g., "- [ ] todo"), breaking GFM task-list input`

**Suggested labels:** `bug`, `cli`, `good first issue` (one-line fix)

**Suggested body:** Reference the nightly E2E run `27318191693`, note the clap
`allow_hyphen_values` fix, and cross-reference issue #471 (the task-list feature that
made this gap impactful).

The orchestrator should file this issue before or alongside the F4 implementation PR.

---

## 7. Test Strategy

### 7.1 Hermetic Parse-Level Regression Tests (NEW — to be added in F4)

Model: `tests/cli_smoke.rs` (uses `Cli::try_parse_from` via `jr::cli::Cli`; no network).
One test per fixed arg, using the preferred hermetic form.

**Test 1 — `issue create --description` leading-dash parses:**
`test_create_description_leading_dash_value_accepted`
```rust
Cli::try_parse_from(["jr","issue","create","-p","FOO","-t","Task","-s","Summary",
    "--description","- [ ] todo item"]).expect("must parse");
```

**Test 2 — `issue edit --description` leading-dash parses:**
`test_edit_description_leading_dash_value_accepted`
```rust
Cli::try_parse_from(["jr","issue","edit","FOO-1","--description","- [ ] edit item"])
    .expect("must parse");
```

**Test 3 — `issue create --summary` leading-dash parses:**
`test_create_summary_leading_dash_value_accepted`
```rust
Cli::try_parse_from(["jr","issue","create","-p","FOO","-t","Task",
    "--summary","- My issue title"]).expect("must parse");
```

**Test 4 — `issue edit --summary` leading-dash parses:**
`test_edit_summary_leading_dash_value_accepted`
```rust
Cli::try_parse_from(["jr","issue","edit","FOO-1","--summary","- Updated title"])
    .expect("must parse");
```

**Test 5 — `worklog add --message` leading-dash parses:**
`test_worklog_add_message_leading_dash_value_accepted`
```rust
// Shipped form: duration-first (matches implementation in tests/cli_smoke.rs)
Cli::try_parse_from(["jr","worklog","add","FOO-1","1h","--message","- dash message"])
    .expect("must parse");
// A companion test this round also covers the message-before-duration ordering;
// both orderings are valid clap parses.
```

**Test 6 — `issue comment` positional leading-dash parses:**
`test_issue_comment_positional_leading_dash_value_accepted`
```rust
Cli::try_parse_from(["jr","issue","comment","FOO-1","- a note"])
    .expect("must parse");
```

**Test 7 — `issue remote-link --title` leading-dash parses:**
`test_remote_link_title_leading_dash_value_accepted`
```rust
Cli::try_parse_from(["jr","issue","remote-link","FOO-1",
    "--title","- RFC: foo","--url","https://example.com"])
    .expect("must parse");
```

**Test 8 — conflict constraint still holds (regression guard for existing BC-3.4.007):**
This test already exists (`test_edit_description_and_description_stdin_conflict`); no
new test needed. The fix MUST NOT break it.

### 7.2 Live E2E Coverage (EXISTING — kept as live regression)

`test_e2e_markdown_task_list_produces_task_items` (`tests/e2e_live.rs:9025`) will
pass after the fix — this is the definitive end-to-end proof. No modification to
this test is needed; it should be retained as the live coverage anchor for the bug fix.

---

## 8. Impact Assessment Table

| Artifact | Change Type | Notes |
|----------|-------------|-------|
| `src/cli/mod.rs` ~line 356 | MODIFIED | Add `allow_hyphen_values = true` to `--summary` on `Create` |
| `src/cli/mod.rs` ~line 362 | MODIFIED | Add `allow_hyphen_values = true` to `--description` on `Create` |
| `src/cli/mod.rs` ~line 439 | MODIFIED | Add `allow_hyphen_values = true` to `--summary` on `Edit` |
| `src/cli/mod.rs` ~line 469 | MODIFIED | Add `allow_hyphen_values = true` to `--description` on `Edit` |
| `src/cli/mod.rs` ~line 544 | MODIFIED | Add `allow_hyphen_values = true` to `issue comment` positional `<message>` |
| `src/cli/mod.rs` ~line 652 | MODIFIED | Add `allow_hyphen_values = true` to `issue remote-link --title` |
| `src/cli/mod.rs` ~line 813 | MODIFIED | Add `allow_hyphen_values = true` to `worklog add --message` |
| `tests/cli_smoke.rs` | MODIFIED | +17 hermetic `Cli::try_parse_from` parse tests (7 canonical one-per-arg + 10 from adversarial findings: 2 conflict-survival F-M1, 2 positional/ordering O-1/O-2, 4 flag-binding F5-P5-01, 2 edge-case F-L1); total test count: 44 (27 baseline + 17 new) |
| `tests/e2e_live.rs` | UNCHANGED | Existing task-list test passes without modification |
| `bc-3-issue-write.md` | OPTIONALLY MODIFIED | Annotation to BC-3.3.008 / BC-3.4.003 noting `allow_hyphen_values`; not required |
| All other files | UNCHANGED | Zero handler, API, type, or cache changes |

**Files NOT changed:**
- `src/cli/issue/create.rs` — handler receives `Option<String>` unchanged
- `src/cli/issue/workflow.rs` — no changes
- `src/adf.rs` — no changes
- `src/api/` — no changes
- `src/types/` — no changes
- `src/cache.rs`, `src/config.rs`, `src/output.rs` — no changes
- `Cargo.toml` — no new dependencies

---

## 9. F4 Implementation Instructions

1. Open `src/cli/mod.rs`.
2. Apply `allow_hyphen_values = true` to the `#[arg(...)]` decorator at each of these
   seven locations (approximate line numbers — verify before patching):
   - ~line 356: `issue create` — `--summary` field
   - ~line 362: `issue create` — `--description` field
   - ~line 439: `issue edit` — `--summary` field
   - ~line 469: `issue edit` — `--description` field (keep `conflicts_with = "description_stdin"`)
   - ~line 544: `issue comment` — positional `message` field
   - ~line 652: `issue remote-link` — `--title` field
   - ~line 813: `worklog add` — `--message` field
3. Add hermetic regression tests to `tests/cli_smoke.rs` using `Cli::try_parse_from`
   (7 canonical one-per-arg per §7.1, plus adversarial-round additions: 2 conflict-survival
   F-M1, 2 positional/ordering O-1/O-2, 4 flag-binding F5-P5-01, 2 edge-case F-L1).
   Final test count: 44 (27 baseline + 17 new).
4. Run `cargo test` to confirm no regressions.
5. Run `cargo clippy -- -D warnings` and `cargo fmt --all -- --check`.
6. PR title: `fix(cli): allow leading-hyphen values for all free-text write-command inputs`
   Closes: the GitHub issue filed per §6 of this document.
