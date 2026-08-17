# PR Review — #704 (S-604-2: `jr component create` / `jr component edit`)

**Reviewed SHA:** `9439b3c3eb0099ed79b9baa5eaefdfe8ffb95f2a`
**Base:** `develop` · **Head:** `feature/S-604-2-component-create-edit`
**Diff:** 22 files, +2,914 / −11 (src ~546 lines; tests ~1,855; evidence report 354; 10 binary recordings)

## Verdict: REQUEST_CHANGES

> **Mechanical note on the review state.** This is submitted as a review *comment*, not as a
> GitHub "Changes requested", because GitHub refuses both `--request-changes` and `--approve` on
> a PR authored by the same account (`gh pr review 704 --request-changes` → `GraphQL: Review Can
> not request changes on your own pull request`). The absence of a red "Changes requested" badge
> is a platform constraint, **not** a softened verdict — treat this document as a
> changes-requested review and do not merge on the strength of a missing badge.

One BLOCKING spec-fidelity defect, verified empirically against a build of this PR's HEAD.
Everything else is MINOR/COSMETIC. The implementation is otherwise careful and well-pinned —
the ordering-sensitive parts of BC-8.1.007 (Precondition 1 before all HTTP, single confirming
GET, 404 exit-code taxonomy) are all correct and genuinely tested, not merely claimed.

> **Note on a second review.** A separate fresh-eyes review of this PR reached **APPROVE**,
> independently finding the same `--assignee-type` defect but classifying it MAJOR rather than
> BLOCKING and recommending a fast-follow. I have read it, I agree with its four findings that
> I missed (see "Findings I did not independently reach" below), and I am keeping my BLOCKING
> classification for the reasons in finding 1. The practical delta between the two verdicts is
> narrow: the fix is the same one-line clap attribute either way — the only question is whether
> it lands before or after this feature's flag surface becomes public.

---

## Findings

| # | Severity | Category | File | Finding |
|---|----------|----------|------|---------|
| 1 | **BLOCKING** | spec-fidelity | `src/cli/mod.rs::AssigneeType` | `--assignee-type` accepts kebab-case only; the spec's own values (`PROJECT_LEAD`, …) exit 2 |
| 2 | MAJOR | output-contract | `src/cli/component.rs::handle_edit` | Table-mode output has no confirmation/subject line — only bare `  name → NewName` |
| 3 | MINOR | test-docs | `tests/component_commands.rs` | Module header and several test rustdocs still narrate `todo!()` stubs / Red Gate — false at HEAD |
| 4 | MINOR | duplication | `src/cli/component.rs::is_numeric_id` | Second independent copy of the BC-8.4.001 step-1 numeric predicate |
| 5 | MINOR | spec-fidelity | `src/cli/component.rs::handle_edit` | `--project` mismatch comparison is case-insensitive, undocumented and untested |
| 6 | MINOR | spec-fidelity | `src/cli/component.rs::handle_edit` | No-fields guard wording differs from the story's quoted text; no test can catch drift |
| 7 | MINOR | demo-evidence | `docs/demo-evidence/S-604-2/` | 5 of 18 ACs have recordings |
| 8 | COSMETIC | clap | `src/cli/mod.rs` | `required = true` redundant on a non-`Option` field |
| 9 | COSMETIC | style | `src/cli/component.rs` | `.unwrap()` on `into_iter().next()` in the `1 =>` arms (×2) |

---

### 1. [BLOCKING] `--assignee-type` rejects the values the contract specifies

**`src/cli/mod.rs`, `AssigneeType`**

```rust
#[derive(clap::ValueEnum, Clone, Debug)]
pub enum AssigneeType {
    ComponentLead,
    ProjectLead,
    Unassigned,
    ProjectDefault,
}
```

The story's Behavior Summary — the section headed *"Behavior Summary (verbatim per BC — do not
deviate)"* — states: *"`--assignee-type` is a clap `ValueEnum` (`PROJECT_LEAD`, `COMPONENT_LEAD`,
`UNASSIGNED`, `PROJECT_DEFAULT`)"*. AC-002's command line is literally
`--assignee-type PROJECT_LEAD`. clap's `ValueEnum` derive defaults to `rename_all = "kebab-case"`
with case-**sensitive** matching, and no `rename_all`, `alias`, or `ignore_case` was added — so the
spec's own values are rejected.

Verified by building this PR's HEAD (`9439b3c3`) and running the binary:

```
$ jr component create --project FOO Backend --assignee-type PROJECT_LEAD
error: invalid value 'PROJECT_LEAD' for '--assignee-type <ASSIGNEE_TYPE>'
  [possible values: component-lead, project-lead, unassigned, project-default]
```

Note `_` vs `-` as well as the case difference, so `ignore_case` alone would not fix it.

Why it matters beyond the letter of the spec: Jira's REST documentation and API responses spell
`assigneeType` values in SCREAMING_SNAKE — which the implementation itself acknowledges, since
`assignee_type_to_api_str` maps back to exactly those strings for the wire. A user copying a value
from Jira docs, from a `jr component list` row, or from BC-8.1.005 gets exit 2 with no hint that
the same value in a different spelling would work.

**Compounded by the test having been written to the code rather than the contract.**
`test_bc_8_1_005_component_create_all_optional_fields_present` (AC-002) passes
`"--assignee-type", "component-lead"`, so the suite is green against the implementation's surface
while AC-002 as specified fails. CLAUDE.md is explicit: *"Default to fixing code, not tests… Only
modify a test when requirements have changed."* Nothing in the diff or PR body records a
requirements change for these spellings, and 11 adversarial passes did not surface it — notable,
since the values appear verbatim in the story text those passes ran against.

**Why BLOCKING and not MAJOR** (the one point where I differ from the other reviewer): the set of
accepted flag values is a public CLI surface. Fixing it now is one line. Fixing it after release
means either a breaking change — which this repo treats as a heavyweight event, with BC entries,
CHANGELOG migration notes, and explicit sign-off — or carrying both spellings forever as
accumulated debt. And an acceptance criterion whose literal command does not work is, by this
pipeline's own standard, not delivered. The asymmetry in cost is what makes me hold the line
rather than accept a fast-follow; I acknowledge this is a judgment call on which two reviewers
landed differently, and that the remedy is identical either way.

Suggested fix (accept the contract's spelling; optionally keep kebab-case as an alias so the
already-recorded demos and any early users keep working):

```rust
#[derive(clap::ValueEnum, Clone, Debug)]
#[value(rename_all = "SCREAMING_SNAKE_CASE")]
pub enum AssigneeType {
    #[value(alias = "component-lead")]
    ComponentLead,
    #[value(alias = "project-lead")]
    ProjectLead,
    #[value(alias = "unassigned")]
    Unassigned,
    #[value(alias = "project-default")]
    ProjectDefault,
}
```

Keep `assignee_type_to_api_str` as-is — the wire mapping is already correct. Then:

- update AC-002's test to the spec's `PROJECT_LEAD` and, if aliases are kept, add a case pinning
  the kebab-case alias so the aliasing itself is tested;
- re-record `AC-HELP-create-help` and `AC-005-bad-assignee-type-exit-2` — the possible-values list
  is visible in both, and `evidence-report.md` currently documents
  `[possible values: component-lead, project-lead, unassigned, project-default]` as expected output;
- `jr component edit` has no `--assignee-type` flag. That is consistent with BC-8.1.007's field
  list, so no change needed — flagged only so it reads as a deliberate scope boundary when the
  enum is touched.

---

### 2. [MAJOR] `component edit` table-mode output never says what happened

**`src/cli/component.rs::handle_edit`**

```rust
OutputFormat::Table => {
    // F-05 / BC-3.4.012: one "  field → value" line per changed field.
    if let Some(n) = echo_name {
        eprintln!("  name \u{2192} {}", n);
    }
    ...
}
```

A successful `jr component edit Backend --project FOO --name NewName` prints exactly this to
stderr and nothing else:

```
  name → NewName
```

No verb, no subject, no component id, no project — and the indentation implies a header line that
does not exist. `handle_create` in the same diff emits a complete sentence
(`Created component "Backend" (id 10001) in project FOO.`). For a state-changing command under the
repo's Symmetric output profile (profile 4, *"state-changing commands that also print a result"*),
this reads as truncated output rather than a result.

The cited precedent does not carry the omission: `jr issue edit`'s BC-3.4.012 echo lines are
preceded by a line naming the issue, which is what makes the indented `field → value` lines parse
as a sublist.

The story is silent on `edit`'s table output, so this is not a contract violation — hence MAJOR,
not BLOCKING. Suggestion:

```rust
eprintln!(
    "Updated component \"{}\" (id {}) in project {}.",
    updated.name, updated.id, proj
);
// then the existing echo lines
```

Sourcing the header from the response (`updated.name`) while keeping echoes from the request values
(`echo_name`/`echo_desc`/`echo_lead`) is the right split and matches issue-edit precedent — the echo
records what the user asked for, the header confirms what the server returned. Worth a test pinning
the header string if added.

---

### 3. [MINOR] Test-file documentation still describes the pre-implementation state

**`tests/component_commands.rs`**

```rust
//! S-604-1 tests (handle_list): all PASS — fully implemented.
//! S-604-2 tests (handle_create, handle_edit): all FAIL — todo!() stubs.
```

At HEAD all tests pass — I ran `cargo test --test component_commands`: **65 passed, 0 failed** — so
the second line is false. Several per-test rustdocs carry the same artifact:
`/// Red Gate: todo!() panics before HTTP.`, `/// Red Gate for numeric case: todo!() panics.`, and
AC-005's `/// NOTE: This test LEGITIMATELY PASSES against todo!() stubs.`

Accurate during RED, misleading as present-tense claims in a merged file. CLAUDE.md treats this
class as a defect rather than style: *"a name asserting a guarantee its body doesn't check is a
defect, not a style deviation"* — the same logic applies to a doc comment asserting a state that no
longer holds. Suggest rewriting the header for the current suite and either deleting the Red Gate
lines or moving them to past tense (*"Originally RED against the `todo!()` stub; now pins the
implemented guard."*). AC-005's note is worth keeping in some form — the observation that clap
validates before dispatch is genuinely useful — just not phrased as though stubs remain.

---

### 4. [MINOR] The numeric-ID predicate now exists in two places

**`src/cli/component.rs::is_numeric_id`** vs **`src/cli/issue/helpers.rs::resolve_component`**

```rust
// component.rs (new)
fn is_numeric_id(s: &str) -> bool {
    !s.is_empty() && s.chars().all(|c| c.is_ascii_digit())
}

// helpers.rs:~628 (S-604-1, inline in resolve_component)
if !input.is_empty() && input.chars().all(|c| c.is_ascii_digit()) {
```

Byte-identical logic, both implementing BC-8.4.001 step 1, in two files with no link. `handle_edit`
uses its copy to pick the numeric-vs-name branch while `resolve_component` uses the other to decide
the bypass — if either drifts (accepting a leading `+`, trimming whitespace), the two halves of one
contract disagree silently, and only one call site has a test aimed at the predicate.

The repo does inline this pattern elsewhere (`attachments.rs`, `field_resolve.rs`,
`jsm_create.rs`), so it is not a convention violation — but those are unrelated ID kinds; these two
are the *same* predicate on the *same* contract. Suggest promoting one to
`pub(crate) fn is_numeric_component_id` in `helpers.rs` beside `resolve_component`, using the
existing empty-string rationale comment (`helpers.rs:~626`) as its rustdoc — that comment is
load-bearing and currently guards only one of the two copies.

---

### 5. [MINOR] `--project` mismatch check is case-insensitive, undocumented, untested

```rust
if !derived_project.is_empty() && !user_project.eq_ignore_ascii_case(&derived_project) {
```

BC-8.1.007 Postcondition 3 as quoted in the story is a plain mismatch condition; this implements it
leniently, so `--project eng` succeeds against derived `ENG`. Very likely the right call — Jira keys
are uppercase and punishing lowercase input would be hostile — but the choice is not noted in the
code, no test pins it (AC-013 uses `WRONG` vs `FOO`, which differ in letters and so pass identically
under strict equality), and a mutation to `==` would be invisible to the suite.

Suggest either a rustdoc line explaining the leniency plus a test asserting `--project eng` is
accepted for derived `ENG`, or strict equality if the BC is meant literally. Please confirm against
BC-8.1.007's actual text — outside my visibility.

---

### 6. [MINOR] No-fields guard wording may not match BC-8.1.007 Precondition 1

```rust
"No fields to update. Supply --name, --description, or --lead."
```

The story renders the guard as exit 64 `("no fields specified to update")`. Tests assert the
substring `"No fields to update"`, pinning the implementation's wording rather than the contract's,
so divergence is undetectable by the suite. If the story's parenthetical is a paraphrase, no code
change is needed — but a rustdoc note saying the wording is implementation-chosen (not BC-verbatim)
would stop a future reviewer re-litigating it. If BC-8.1.007 specifies verbatim text, the message
must match and the assertion should quote the full string.

Worth contrasting with the create-path empty-lead guard, which *is* pinned verbatim including the
em-dash (`\u{2014}`) and which the pass-3 fix burst specifically corrected — the project clearly
distinguishes verbatim-required from free-wording messages, and it is not evident from the diff
which class this one is in. (The other reviewer reached the same conclusion here and suggested
amending the BC rather than degrading the message if they differ; I agree — the implemented message
is the better one for users.)

---

### 7. [MINOR] Demo evidence covers 5 of 18 ACs

`docs/demo-evidence/S-604-2/` contains 5 `.gif` + `.webm` pairs with tapes: two `--help` surfaces,
AC-005, AC-006, AC-010/AC-011. All are real recordings (no `.txt` placeholders), and
`evidence-report.md` is present and unusually thorough — it documents per-AC which evidence class
covers what, and its rationale for the 13 test-only ACs (exact-JSON-body wire assertions are not
visually demonstrable) is sound. Both success and error paths are represented.

Where I would push: AC-004 (success output both modes), AC-009 (lead clear vs omit), AC-013
(project-mismatch message) and AC-014/AC-015 (not-found variants) are all *terminal-visible* string
contracts, and those messages are exactly what the adversarial passes kept correcting (pass-1
F-01…F-07, pass-2 B-01/B-02, pass-3 LOW-1). A recording of the rendered message is the cheapest
guard against another wording regression. These need a mock server behind the tape, which the
current tapes do not set up — so weight this suggestion by that cost. AC-004 is the one to add if
only one is.

---

### 8. [COSMETIC] `required = true` is redundant

```rust
#[arg(long, required = true)]
project: String,
```

A non-`Option` field is already required by clap; the attribute is a no-op. Harmless, but it invites
a later reader to assume the field was once `Option<String>` and that the attribute is load-bearing.
The intent (BC-8.1.004 exclusion case 1 — no config fallback) is already carried by the doc comment,
which is the part that matters. Behavior verified correct either way:
`Usage: jr component create [OPTIONS] --project <PROJECT> <NAME>`.

---

### 9. [COSMETIC] `.unwrap()` on a provably-non-empty iterator

```rust
1 => Some(users.into_iter().next().unwrap().account_id),
```

Twice (create and edit). Safe by construction — reached only when `users.len() == 1` — and the repo
has no rule against it. `if let Some(u) = users.into_iter().next()`, or `users.remove(0)`, would be
panic-free without the reader re-deriving the invariant from the match arm.

---

## Findings I did not independently reach

From the other fresh-eyes review; I have checked each against the diff and concur. Listing them
here so a single document carries the union, not to claim them:

- **`MatchResult::ExactMultiple` collapsed into the `Exact` arm** — `MatchResult::Exact(n) |
  MatchResult::ExactMultiple(n) => n`, then `find(|c| c.name == matched_name)` silently selects the
  first of several identically-named components and mutates it. Unreachable if Jira enforces
  per-project component-name uniqueness, a silent wrong-target write if it does not. This is the
  best of the findings across both reviews and I missed it. Either split the arm into an exit-64
  disambiguation, or record in a comment *why* the variant is unreachable.
- **`allow_hyphen_values` asymmetry** — present on `--description` for both subcommands, absent on
  the `Create` `NAME` positional and on `Edit --name`, so a component named `-legacy` can be neither
  created nor renamed. CLAUDE.md applies this attribute to user-authored free-text write inputs, and
  a component name is exactly that. Note the documented missing-value tradeoff before adding it to
  the positional, and note the separate CLAUDE.md carve-out that `allow_hyphen_values` must NOT go
  on greedy variadic positionals — not the case here (`NAME` is a single value), so the carve-out
  does not block the fix, but it is the reason to state the choice explicitly rather than apply the
  attribute reflexively.
- **No CHANGELOG entry** for two new user-facing subcommands.
- **Numeric-path fail-open corner** — when `--project WRONG` is supplied *and* the confirming GET
  returns no `project` field, the mismatch check is skipped and `WRONG` becomes both the
  lead-resolution scope and the cache-invalidation key. The F-07 fail-closed guard above fires only
  when `--project` was absent. Narrow, but the asymmetry deserves a comment or a fail-closed
  extension. This sharpens my finding 5 — both concern the same conditional.

---

## What I verified (checklist, all 8 items)

**Diff coherence.** Every change traces to S-604-2. `src/api/jira/users.rs` unmodified as required.
`src/cache.rs` unmodified (new call sites only — `invalidate_components_cache` already existed from
S-604-1, so the story's "MODIFY" row was pessimistic). `handle_list` is untouched apart from
deleting the now-obsolete `let _ = resolve_component;` unused-import suppressor — 4 lines, zero
behavioral change, correct to remove since `handle_edit` now genuinely uses the symbol. Technically
a hunk inside `handle_list` against the story's "MUST NOT change" line; I read it as de-scaffolding,
and it is the only deletion in the src diff.

**Description accuracy.** The traceability table matches the tests that exist, and the names match
the file. Two overstatements, noted rather than filed: the body claims 18 new tests while the diff
adds 23 test functions (5 beyond the AC set — `edit_success_output_json_shape`,
`numeric_notfound_config_project_qualified`, `edit_failed_does_not_invalidate_cache`,
`edit_lead_no_match_zero_put`, `edit_lead_ambiguous_zero_put`) — an undercount in the author's
favour, and those five are good tests, the negative cache-invalidation one especially. Separately,
the Pre-Merge Checklist's "Demo evidence present (18/18 ACs)" is checked, which finding 7 shows is
true only in the "evidence of some class" sense.

**Test coverage.** All 18 ACs have a named test; I read each rather than trusting the table. Ran the
suite at HEAD: **65 passed, 0 failed**. The wiremock pinning is the strong part of this PR:
`body_json(...)` exact-equality matchers with `.expect(1)` on every mutating call and `.expect(0)`
on every call that must not fire, with `server.verify()` asserting both directions. That is what
makes the ordering claims below falsifiable rather than aspirational.

**Ordering and taxonomy — each traced through the code, not just the test name:**

- **BC-8.1.005 omit-if-absent (AC-001/003).** Body built as a `serde_json::Map` with `if let
  Some(...)` inserts; no `Value::Null` anywhere on the create path. AC-001 pins
  `{"name":"Backend","project":"FOO"}` by exact JSON equality, so an added `null` key fails.
- **BC-8.1.006 `--lead ""` on create (AC-006).** Guard is the first statement in `handle_create`,
  ahead of lead resolution, body composition, and POST. Message matches the story's quoted text
  verbatim including the em-dash. AC-006 pins `.expect(0)` on both the POST and the user-search GET,
  so "before any HTTP" is actually asserted, not just "before the POST".
- **BC-8.1.006 resolution before mutation (AC-007 + two extra edit-side tests).** On both paths
  `search_assignable_users_by_project` is awaited before the mutating call, and both the 0-match and
  2+-match arms `return Err` before any body composition. `.expect(0)` on POST/PUT in all three.
- **BC-8.1.007 Precondition 1 before everything (AC-010/011).** `has_fields` is checked immediately
  after destructuring, ahead of the `is_numeric_id` branch — so it precedes both the name-path
  component-list GET *and* the numeric-path confirming GET. AC-010 pins `.expect(0)` on
  `/project/FOO/components`; AC-011 pins `.expect(0)` on `/component/10042`. This is the
  load-bearing P16 ordering and it is correct.
- **BC-8.1.007 M1 — confirming GET fires exactly once (AC-012).** One `client.get_component` call on
  the numeric path; `comp.project` is reused for *both* lead-resolution scoping and the
  `invalidate_components_cache` argument. AC-012 pins `.expect(1)` on the confirming GET, `.expect(1)`
  on the ENG-scoped user search, and `.expect(1)` on the PUT — a second GET fails `server.verify()`.
  `get_component`'s rustdoc correctly states `resolve_component` performs no HTTP, so there is no
  hidden second round-trip. Matches ADR-0018 §1.
- **BC-8.1.007 404 taxonomy (AC-014 vs AC-016).** Confirming-GET 404 is caught via
  `downcast_ref::<JrError>()` → `ApiError { status: 404 }` → re-raised as `JrError::UserError`
  (exit 64). The PUT's error is propagated with a bare `?`, so a racing 404 stays `ApiError(404)`
  (exit 1). Both tests pass, and AC-016 pins `.expect(1)` on the racing PUT — proving the code
  reached the mutation rather than exiting 1 for an earlier reason. Genuinely distinguishable, per
  VP-COMPONENT-024.
- **BC-8.1.008 message variant selection (AC-014 + extra config test).** Uses
  `config.project_key(project.as_deref())` (flag > config), not the flag alone — correctly
  implementing "project KNOWN from ANY source". The extra
  `test_bc_8_1_008_component_edit_numeric_notfound_config_project_qualified` covers the config-only
  source, which the AC alone would have missed.
- **BC-8.1.007 Postcondition 3 (AC-013).** Mismatch error fires before body composition and before
  the PUT; exact message pinned; `.expect(0)` on PUT. (See findings 5 and the fail-open corner.)
- **ADR-0018 §2 (AC-018 + negative test).** `invalidate_components_cache` is called after — and only
  after — a successful `create_component`/`edit_component`; the `?` short-circuits before
  invalidation on failure. Both directions covered, including
  `test_adr_0018_component_edit_failed_does_not_invalidate_cache`.
- **BC-8.1.004 numeric exemption (AC-017).** Name path requires `config.project_key(...)` and exits
  64 when absent; numeric path never consults it. Both arms covered.
- **DEC-188 exit-code class (AC-005).** Grep-verified: no app-level `assignee_type` guard exists
  anywhere in `component.rs` (the only two hits are `handle_list`'s display of existing values).
  Rejection is purely clap's `ValueEnum` → exit 2, with `.expect(0)` on the POST. **This part of
  DEC-188 is correctly implemented** — finding 1 concerns the accepted value *spelling*, not the
  exit class, and the two must not be conflated when fixing it.
- **JSON render invariant (#526).** Both new JSON paths route through `output::render_json`; no
  direct `to_string_pretty`. Compliant.
- **Output channels.** Create and edit both use JSON→stdout, human→stderr (profile 4, Symmetric).

**Commit quality.** 14 commits, all Conventional Commits with an `(S-604-2)` scope, and the
RED-then-GREEN pairing is visible (a `test(...)` pinning a message immediately followed by the
`fix(...)` implementing it — e.g. `df247799` → `05ec2310`). Clean, readable history.

**Diff size.** +2,914 is above the 500-line flag threshold, but the composition justifies it:
~1,855 test lines, 354 evidence-report lines, 10 binary recordings, ~546 lines of src.

**Missing changes.** Nothing from the story's file list is absent. The `src/cache.rs` MODIFY row
turned out unnecessary. (CHANGELOG is missing — see the other reviewer's finding above.)

**Dependency status.** S-604-1 merged at `e2c403e8`; base is `develop`; PR is `MERGEABLE`.

**CI at this SHA.** 13 checks green — Clippy (ubuntu + windows), Test (ubuntu + macos), Coverage,
Deny, MSRV 1.85.0, Mutation testing, Format, gitleaks, Spec Guards, Signing Workflow Injection
Guard, dependency-review. `Test (windows-latest)` was still pending at review time and `CI Gate` had
not yet reported. Per CLAUDE.md's `strict: false` note, if `develop` moves before merge the gate
should be re-checked rather than trusted from this run.

---

## Recommendation

Fix finding 1 (`--assignee-type` value spellings, AC-002's test, the two affected recordings, and
the corresponding `evidence-report.md` lines) and re-request review. Fold in finding 2 and the
`ExactMultiple` item while the relevant paths are open — the latter is the only other finding across
both reviews that can cause a *wrong* outcome rather than a confusing one. Everything else is
reviewer's discretion; 3, 5 and 6 have the best cost/benefit, since each removes a way for a future
change to break something silently.

Findings 5 and 6 both hinge on BC-8.1.007's verbatim text, which is behind the information wall for
me. If the story's parentheticals were descriptive, both collapse to a one-line rustdoc each.
