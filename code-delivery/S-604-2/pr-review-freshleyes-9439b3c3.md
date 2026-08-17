# PR Review — #704 `feat(components): jr component create and jr component edit (S-604-2)`

**Reviewed SHA:** `9439b3c3eb0099ed79b9baa5eaefdfe8ffb95f2a`
**Verdict:** REQUEST_CHANGES (1 BLOCKING, 5 MINOR, 3 COSMETIC)

Fresh-eyes review against the diff, PR body, story spec ACs, and demo evidence. All 22
changed files reviewed (2 source, 1 client, 1 CLI enum, 2 test files, 16 demo artifacts).

---

## What I verified as correct

Most of this PR is in good shape, and I want to be explicit about what I actually checked:

- **Omit-if-absent POST body (BC-8.1.005 / VP-COMPONENT-022):** `handle_create` builds a
  `serde_json::Map` and inserts `description`/`leadAccountId`/`assigneeType` only inside
  `if let Some(...)` guards. No `null` placeholders. Pinned by three `body_json(...)`
  matchers — `body_json` is exact equality, not subset, so a stray `"description":null`
  would fail the match and then `.expect(1)` at `server.verify()`.
- **Precondition-1 ordering (BC-8.1.007 P16):** the `has_fields` check is the first
  statement in `handle_edit`, before the numeric/name fork, before `get_component`, and
  before `list_components`. AC-010 and AC-011 pin it with `.expect(0)` on the respective GET
  mock, so the ordering is enforced behaviourally rather than by reading code.
- **404 taxonomy (VP-COMPONENT-024):** the confirming-GET 404 is downcast to
  `JrError::ApiError { status: 404, .. }` and re-wrapped as `JrError::UserError` (exit 64),
  while the PUT error path deliberately propagates unwrapped (`ApiError` → exit 1). The two
  tests assert `Some(64)` and `Some(1)`. This is the subtlest requirement in the story and it
  is handled correctly — the classes cannot silently collapse.
- **One confirming GET, not two (ADR-0018 §1):** `get_component` is called once on the
  numeric path and its `project` field feeds both lead resolution and cache invalidation;
  `.expect(1)` pins the count.
- **`--lead ""` vs omitted `--lead`:** `Value::Null` vs no key, pinned by two `body_json`
  matchers (`{"name":"Backend","leadAccountId":null}` vs `{"name":"Backend"}`).
- **Project mismatch (AC-013):** fires before lead resolution and before the PUT; message
  pinned verbatim with `.expect(0)` on the PUT.
- **Cache invalidation (ADR-0018 §2):** after both successful mutations, keyed on the derived
  (not user-supplied) project — plus a negative test asserting a *failed* edit does not
  invalidate. That is the assertion I would have asked for and it is already there.
- **Lead resolver reuse:** `search_assignable_users_by_project` (single-page) is the same
  function `src/cli/issue/helpers.rs:451` uses for `issue assign --to`, exactly as the story
  mandates. I confirmed the `_all` paginated sibling is *not* the precedent, so the
  single-page choice is deliberate rather than an oversight.
- **`handle_list` untouched:** the only change is deleting the `let _ = resolve_component;`
  lint placeholder, now required since `resolve_component` is genuinely used by `handle_edit`.
- **No new crate dependencies;** `Cargo.toml`/`Cargo.lock` absent from the diff.
- **Commit quality:** 14 Conventional Commits, `(S-604-2)` scoped, fix-burst provenance in
  subjects.

---

## Findings

### BLOCKING-1 — `--assignee-type PROJECT_LEAD` is rejected (exit 2); AC-002 is not satisfied as written

| Field | Value |
|-------|-------|
| Severity | **blocking** |
| Category | spec-fidelity / missing |
| Location | `src/cli/mod.rs` — `pub enum AssigneeType` + `ComponentSubcommand::Create::assignee_type`; `tests/component_commands.rs::test_bc_8_1_005_component_create_all_optional_fields_present` |

The story's Behavior Summary — flagged "verbatim per BC — do not deviate" — states that
`--assignee-type` is a clap `ValueEnum` over `PROJECT_LEAD`, `COMPONENT_LEAD`, `UNASSIGNED`,
`PROJECT_DEFAULT`, and AC-002 spells its command line literally as:

```
jr component create --project FOO Backend --description "d" --lead alice --assignee-type PROJECT_LEAD
```

I ran that exact form against the PR's own build at this SHA:

```
$ jr component create --project FOO --assignee-type PROJECT_LEAD Backend
error: invalid value 'PROJECT_LEAD' for '--assignee-type <ASSIGNEE_TYPE>'
  [possible values: component-lead, project-lead, unassigned, project-default]
```

Exit 2, zero HTTP. The derived `ValueEnum` emits kebab-case names and, with no `ignore_case`
set, matching is case-sensitive — so every value spelling the spec enumerates is rejected and
only the four kebab-case forms work. This is a user-facing CLI contract, not an internal
detail: the four uppercase values are also the literal Jira API strings a user reading
Atlassian's docs (or this story) would reach for first.

The AC-002 test does not catch it because it was written against the implementation rather
than the AC: it passes `--assignee-type component-lead` and asserts
`"assigneeType": "COMPONENT_LEAD"`, where AC-002 specifies `PROJECT_LEAD` on both sides. The
one test tracing to AC-002 therefore exercises a different scenario than AC-002 describes,
and the deviation is invisible to CI.

Why blocking rather than a nit: it is the only place in this PR where a spec'd,
externally-visible input contract is unmet, and the test that should have caught it was
adapted to the code. Every other message and body shape here is pinned verbatim; this one
path silently is not.

**Suggestion** — either closes it; I only require that code, AC, and test end up agreeing:

1. Accept both spellings (existing repo precedent — `src/cli/mod.rs:133` already does this
   for `HttpMethod`):

```rust
#[arg(long, value_enum, ignore_case = true)]
assignee_type: Option<AssigneeType>,
```

   `ignore_case = true` alone fixes case but not underscore-vs-hyphen, so add aliases:

```rust
#[derive(clap::ValueEnum, Clone, Debug)]
pub enum AssigneeType {
    #[value(name = "component-lead", alias = "COMPONENT_LEAD")]
    ComponentLead,
    // ... same for the other three
}
```

   Then change AC-002's test to use `PROJECT_LEAD` (as the AC says) and add a case covering
   the kebab-case form.

2. Or, if kebab-case-only is intended, amend BC-8.1.005/AC-002 to record the accepted
   spellings so the spec stops describing a surface that doesn't exist — and change AC-002's
   literal to `project-lead`. The internal mapping in `assignee_type_to_api_str` is already
   correct either way.

---

### MINOR-1 — 20 stale "Red Gate: todo!()" comments shipped, plus a module header claiming all these tests FAIL

| Field | Value |
|-------|-------|
| Severity | suggestion |
| Category | coherence / description accuracy |
| Location | `tests/component_commands.rs` — module doc, section banner, 20 per-test doc comments |

The module doc reads `S-604-2 tests (handle_create, handle_edit): all FAIL — todo!() stubs.`
and the section banner says `all FAIL — Red Gate` / `Handlers are todo!() stubs; all tests
below MUST fail until implemented`, with 20 comments of the form `Red Gate: todo!() handler
panics → exit ≠ 0 → assertion fails.` None is true at this SHA — the handlers are
implemented and CI is green. Two tests also carry a now-meaningless `NOTE: This test
LEGITIMATELY PASSES against todo!() stubs` caveat. The next reader will either distrust the
suite or waste time reconciling it with green CI.

**Suggestion:** sweep the Red-Gate scaffolding language in one commit; keep the per-test
intent comments, which are good.

---

### MINOR-2 — The no-fields guard message is the only user-facing string here without a test pin

| Field | Value |
|-------|-------|
| Severity | suggestion |
| Category | coverage |
| Location | `src/cli/component.rs::handle_edit`; AC-010 / AC-011 tests |

The guard emits `No fields to update. Supply --name, --description, or --lead.`; the story
renders the requirement as exit 64 `"no fields specified to update"`. AC-010/AC-011 assert
only `Some(64)` and zero HTTP, never stderr. Every other message in this PR (empty-lead,
mismatch, both not-found variants, BC-8.4.002/003 lists) has a verbatim `contains` pin,
several added by dedicated fix-burst commits — so this is a gap, not a consistent policy. I
can't read BC-8.1.007, so I'm not asserting the wording is wrong; only that nothing stops it
from drifting.

**Suggestion:** add a `stderr.contains(...)` pin to AC-010/AC-011 for the BC's verbatim text.

---

### MINOR-3 — `--description ""` advertises "clear the description" with no test, via a different mechanism than `--lead ""`

| Field | Value |
|-------|-------|
| Severity | suggestion |
| Category | coverage |
| Location | `src/cli/mod.rs` Edit `description` help text; `handle_edit` |

Help says `Pass an empty string (--description "") to clear the description.` The code sends
`"description": ""`, while the sibling clear semantic `--lead ""` sends
`"leadAccountId": null` — two mechanisms for the same user-visible verb, and no test for the
description case (grep for `"description", ""` in the diff: 0 hits). Whether Jira treats `""`
as a clear is an API-behaviour claim the diff makes in help text without evidence.

**Suggestion:** add an edit test with `--description ""` plus a `body_json` matcher pinning
the intended wire shape. If `null` is actually required, this is a behaviour bug.

---

### MINOR-4 — No demo recording of a successful create or edit; all five are error/help paths

| Field | Value |
|-------|-------|
| Severity | suggestion |
| Category | demo evidence |
| Location | `docs/demo-evidence/S-604-2/` |

`evidence-report.md` plus 5 recordings are present as GIF+WebM with `.tape` sources, and the
error coverage is genuinely strong (clap exit 2; empty-lead exit 64; no-fields exit 64 on both
NAME and numeric paths). But the two happy paths this story exists to deliver appear only as
`--help` output; success rests entirely on wiremock. The report is transparent that 13 ACs are
test-only. Flagging because the bar is "success and error paths recorded," and here it's error
paths plus help.

**Suggestion:** if a tape can point `JR_BASE_URL` at a short-lived stub, one recording of
`Created component "Backend" (id 10001) in project FOO.` closes this cheaply.

---

### MINOR-5 — New commands and the numeric-ID bypass are absent from CLAUDE.md

| Field | Value |
|-------|-------|
| Severity | suggestion |
| Category | description / doc fallout |
| Location | `CLAUDE.md` (not in diff) |

`is_numeric_id` means a component *named* `10042` is unreachable by name on
`jr component edit` — structurally identical to the documented `jr requesttype fields
<NAME|ID>` numeric-bypass gotcha, which exists precisely so the next maintainer doesn't
rediscover it. This PR touches no docs: no `cli/component.rs` in the architecture tree, no
bypass gotcha, no note on the `--lead ""` (null) vs `--description ""` (empty string)
asymmetry. Partly inherited — S-604-1 also landed the module without an entry — so this asks
only for the behaviour this PR adds.

---

### COSMETIC-1 — `AssigneeType` rustdoc claims it applies to `edit`, which has no such flag

`Maps to Jira's assigneeType field … (BC-8.1.005 create / BC-8.1.007 edit).` The `Edit`
variant correctly exposes only `--project`/`--name`/`--description`/`--lead`. Drop the
`/ BC-8.1.007 edit` clause.

### COSMETIC-2 — `MatchResult::ExactMultiple` silently picks the first component

`Exact(n) | ExactMultiple(n) => n` followed by `.find(|c| c.name == matched_name)` mutates an
arbitrary duplicate if two components ever share a byte-identical name. Semantics come from
the merged S-604-1 resolver, so this is an observation — but a one-line comment recording why
it's unreachable (or an exit-64 disambiguation arm) would save the next reader the derivation.

### COSMETIC-3 — Identifier quoting is inconsistent between sibling errors

`Component '99999' not found in project FOO.` quotes the id; `Component 10001 belongs to
project FOO, not WRONG.` does not. Both are verbatim-pinned, so both presumably match their
BCs — noted only in case the BCs drifted.

### Informational — diff size

+2,914 / −11 across 22 files exceeds the 500-line threshold, but the split is healthy: ~1,840
test lines, ~400 implementation lines, 16 demo artifacts, no file past its ADR-0012 shard
threshold. No action needed.

---

## Checklist result

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence | PASS — every change traces to S-604-2; the one `handle_list` edit is a now-required placeholder removal |
| 2 | Description accuracy | PASS for the PR body; the test file's own comments contradict it (MINOR-1) |
| 3 | Test coverage | PASS with gaps — 18 ACs covered, but AC-002 tests a different input than it specifies (BLOCKING-1); MINOR-2/-3 name two unpinned user-facing strings |
| 4 | Demo evidence | PASS with gap — report + 5 GIF/WebM pairs, strong error paths, no success-path recording (MINOR-4) |
| 5 | Commit quality | PASS — 14 Conventional Commits, story-scoped |
| 6 | Diff size | PASS in substance (>500 lines, ~63% tests) |
| 7 | Missing changes | FAIL — AC-002's specified input spelling is unimplemented (BLOCKING-1); CLAUDE.md fallout absent (MINOR-5) |
| 8 | Dependency status | PASS — S-604-1 merged (`e2c403e8`); base is `develop` |

**Verdict: REQUEST_CHANGES.** BLOCKING-1 is a one-attribute fix plus a test/AC
reconciliation. Once `--assignee-type` accepts the spelling AC-002 specifies (or the AC and
its test are amended to agree with the code), I expect to approve — the rest of this PR is
careful, well-pinned work, and the 404-taxonomy and guard-ordering requirements in particular
are handled better than I usually see.

---

*Reviewed at `9439b3c3eb0099ed79b9baa5eaefdfe8ffb95f2a`. Findings derived from the diff, PR
description, story spec, demo evidence, and one empirical run of the PR's own build; no
internal pipeline artifacts consulted.*
