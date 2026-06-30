---
document_type: phase-f1-delta-analysis
title: "Holdout Coverage Gaps — Delta Analysis & Authoring Plan"
date: 2026-06-30
drift_item: HOLDOUT-COVERAGE-GAPS-2026-06-25
pipeline_state: IDLE at Phase 3
current_holdout_count: 71
proposed_new_total: 80
author: product-owner
---

# Holdout Coverage Gaps — Delta Analysis & Authoring Plan

**Date**: 2026-06-30
**Drift item**: HOLDOUT-COVERAGE-GAPS-2026-06-25
**Pipeline state**: IDLE at Phase 3
**Current holdout count**: 71 (per holdout-scenarios.md frontmatter `total_holdouts: 71`)
**Proposed new total**: 80 (9 new scenarios; see summary section)

---

## Preamble: Anchor-First Protocol

The broken-anchor class (DEC-137/DEC-138) blocks holdout authoring when the anchoring BC
lacks individually-bodied sub-clauses that describe observable behavior. Every verdict below
was made by reading the BC body in the relevant spec file (bc-2-issue-read.md, bc-3-issue-write.md,
bc-5-boards-sprints.md, cross-cutting.md) and confirming adequate Preconditions, Postconditions,
and Edge Cases are present.

**Adequacy criteria**: A BC is ADEQUATE when it has at least one named edge case (EC-NNN) or
explicit sub-clause that describes an observable exit code, stdout/stderr string, or HTTP call
count — sufficient for the holdout-evaluator to construct a wiremock scenario and assert results
using public CLI surface only.

---

## Per-Target Analysis

### Target 1: `jr issue edit --field NAME=VALUE` (single-key; editmeta validation; JSM behavior)

**Anchor BC(s)**:
- **BC-3.4.015** (`bc-3-issue-write.md` line 1115): `issue edit KEY --field NAME=VALUE`
  (string/number/date/datetime/user field, single-key path). Individually bodied. Has
  Preconditions, Postconditions (10 numbered steps), Invariants (10 numbered), and Edge Cases
  EC-3.4.015-1 through EC-3.4.015-20 including dry-run (EC-3.4.015-18), editmeta validation
  (EC-3.4.015-12), and JSM behavior (EC-3.4.015-1 notes no JSM-specific fork on this path).
- **BC-3.4.016** (`bc-3-issue-write.md` line 1449): `issue edit KEY --field NAME=VALUE`
  (single-select `option` field). Individually bodied. Has Preconditions, Postconditions, and
  Edge Cases EC-3.4.016-1 through EC-3.4.016-4.
- **BC-3.4.017** (`bc-3-issue-write.md` line 1562): `--field` multi-key rejection (C-1 guard)
  + flag-overlap hard error. Individually bodied. Has Gate A (multi-key) and Gate B (overlap)
  postconditions, Invariants 1-2, and Edge Cases EC-3.4.017-1 through EC-3.4.017-14.

**Anchor adequacy verdict**: ADEQUATE for BC-3.4.015, BC-3.4.016, and BC-3.4.017.
All three are individually bodied with observable exit codes, HTTP counts, and stderr substrings.

**Black-box evaluability**: EVALUABLE. The editmeta validation path (field absent from editmeta
→ exit 64 + Edit-screen hint) is fully observable: exit code 64, stderr substring, zero PUT.
The option-type path (unknown option → exit 64 listing allowed values) is similarly observable.
The C-1 guard for multi-key rejection is observable via exit 64 + stderr substring. No
source-internal knowledge required; wiremock can supply editmeta responses.

**JSM behavior note**: BC-3.4.017 and CLAUDE.md explicitly state that `--field` is single-key
only (C-1 guard fires on multi-key or --jql matching multiple issues). The editmeta-JSM
interaction (RT request-type field is unsupported) is documented in CLAUDE.md as JSDCLOUD-4609
"out-of-scope" — explicitly not evaluable (would require source-internal knowledge). Do not
attempt a holdout on the JSM `sd-customerrequesttype` rejection.

**Existing holdouts covering this target**: None (confirmed: no BC-3.4.015/016/017 refs in
holdout-scenarios.md).

**Proposed scenarios** (2 scenarios):

1. **H-NEW-EDIT-FIELD-001**: `jr issue edit FOO-1 --field "My Field=Some Value"` — happy path,
   field absent from editmeta → exit 64 with Edit-screen hint, zero PUT.
   Given: wiremock returns `GET /rest/api/3/issue/FOO-1/editmeta` with `{"fields": {}}` (empty
   fields map — "My Field" not present). PUT mock mounted with `.expect(0)`.
   When: `jr issue edit FOO-1 --field "My Field=Some Value" --no-input --output json`.
   Then: exit 64; stderr contains both `"My Field"` and a hint substring about the Edit screen
   (per BC-3.4.015 EC-3.4.015-12: `field absent from editmeta → exit 64 with Edit-screen hint`);
   PUT is not invoked.
   Why hidden: The editmeta gate is invisible from the success path. Pins BC-3.4.015 EC-3.4.015-12.

2. **H-NEW-EDIT-FIELD-002**: `--field` on 2 positional keys → exit 64 (C-1 guard) before any
   editmeta GET.
   Given: wiremock mounts `GET /rest/api/3/issue/FOO-1/editmeta` with `.expect(0)` (must NOT
   be called). No PUT mock.
   When: `jr issue edit FOO-1 FOO-2 --field "Story Points=5" --no-input`.
   Then: exit 64; stderr contains reference to bulk rejection or single-key requirement; editmeta
   GET is not invoked; PUT is not invoked.
   Why hidden: C-1 guard fires pre-HTTP. Pins BC-3.4.017 Gate A (EC-3.4.017-1).

---

### Target 2: `jr issue edit --type` (multi-key bulk path; cross-project guard; name→id resolution)

**Anchor BC(s)**:
- **BC-3.4.018** (`bc-3-issue-write.md` line 1783): Multi-key `--type` bulk wire shape.
  Individually bodied. Has numbered Preconditions, Postconditions 1-5, Invariants 1-5, and
  Edge Cases EC-3.4.018-1 through EC-3.4.018-5 (including dry-run EC-3.4.018-5 and
  unknown-type EC-3.4.018-2).
- **BC-3.4.019** (`bc-3-issue-write.md` line 1832): Cross-project guard. Individually bodied.
  Has Preconditions, Postconditions (exit 64 + stderr substrings), Invariants 1-4, and Edge
  Cases EC-3.4.019-1 through EC-3.4.019-5 (including the cross-project positive case).

**Anchor adequacy verdict**: ADEQUATE for BC-3.4.018 and BC-3.4.019. Both are deeply bodied
with specific wire-shape invariants, observable exit codes, and HTTP call count expectations.

**Black-box evaluability**: EVALUABLE. The cross-project guard (exit 64 before HTTP) is fully
observable via exit code + stderr substrings + zero mock calls. The unknown-type-name path
(exit 64 listing valid types) requires only a wiremock `GET .../createmeta/{proj}/issuetypes`
response. The happy-path camelCase/lowercase asymmetry in the POST body is observable via
wiremock request capture. CLAUDE.md Gotcha confirms the wire asymmetry (`selectedActions:
["issuetype"]` lowercase vs `editedFieldsInput: {"issueType":...}` camelCase) is load-bearing.

**Existing holdouts covering this target**: None.

**Proposed scenarios** (2 scenarios):

1. **H-NEW-EDIT-TYPE-001**: `jr issue edit FOO-1 BAR-2 --type Bug` — cross-project guard fires
   before any HTTP.
   Given: wiremock mounts `GET .../createmeta/FOO/issuetypes` with `.expect(0)` and
   `POST .../bulk/issues/fields` with `.expect(0)`.
   When: `jr issue edit FOO-1 BAR-2 --type Bug --no-input`.
   Then: exit 64; stderr contains `--type` AND one or both of the project keys (`FOO`, `BAR`)
   AND a cross-project constraint reference; neither createmeta GET nor bulk POST is called.
   Pins BC-3.4.019 EC-3.4.019-1 (VP-331-003).

2. **H-NEW-EDIT-TYPE-002**: `jr issue edit FOO-1 FOO-2 --type Bug` — happy path: correct
   `selectedActions`/`editedFieldsInput` camelCase/lowercase asymmetry on wire.
   Given: wiremock returns `GET .../createmeta/FOO/issuetypes` → `[{"id":"10001","name":"Bug"}]`;
   wiremock captures `POST .../bulk/issues/fields` returning 200 `{"taskId":"t-123"}`;
   subsequent bulk-task poll returns `{"status":"COMPLETE","progressPercent":100}`.
   When: `jr issue edit FOO-1 FOO-2 --type Bug --no-input`.
   Then: exit 0; the captured POST body contains `"selectedActions":["issuetype"]` (lowercase)
   AND `"editedFieldsInput":{"issueType":{"issueTypeId":"10001"}}` (camelCase key, string id);
   the body does NOT contain `"\"name\":\"Bug\""` inside the issueType value position.
   Pins BC-3.4.018 EC-3.4.018-1 (VP-331-001). The camelCase/lowercase asymmetry is the
   primary regression risk (CLAUDE.md Gotcha: "do NOT fix").

---

### Target 3: `jr issue edit --label` (single-key bare-string vs 2+ key object schema fork)

**Anchor BC(s)**:
- **BC-3.4.006** (`bc-3-issue-write.md` line 565): `issue edit --label add:foo --label
  remove:bar` interprets prefix and emits correct JSON wire shape. Individually bodied at
  MEDIUM body depth — cites source files and tests but has limited Preconditions/Postconditions
  structure compared to BC-3.4.015+.
- **BC-INDEX line 274**: One-line summary notes `tests/issue_create_json.rs`,
  `tests/issue_bulk.rs`, `tests/issue_bulk_pr2.rs` as test locations; references
  `build_labels_edited_fields`.

**Anchor adequacy verdict**: INADEQUATE-BROKEN-ANCHOR for the single-key vs multi-key schema
fork specifically. BC-3.4.006 describes the prefix semantics (`add:` / `remove:`) but does NOT
individually document the critical endpoint fork described in CLAUDE.md Gotcha BUG-LABEL-400:
- ONE key (incl. --jql matching one) → `PUT /issue/{key}` with **bare-string** labels (sync 204)
- TWO+ keys → `POST /bulk/issues/fields` with `{"name":...}` **object** schema (async poll)

The two payload shapes are ASYMMETRIC and the BC body does not have an edge case that makes
each path's wire shape observable. BC-3.4.006 is a thin body citing source/tests only.

**Recommendation**: BLOCKED for authoring scenarios specific to the single/multi schema fork.
A BC sub-clause pass is a prerequisite (separate cycle). Create a dedicated EC in BC-3.4.006
or author BC-3.4.006-extension capturing: (a) single-key PUT payload shape (bare-string
labels array), (b) multi-key POST payload shape (`{"name":...}` objects), (c) why they differ.
Until that EC is authored and converged, the holdout evaluator cannot assert the wire shape
without source-internal knowledge.

**Black-box evaluability**: PARTIALLY EVALUABLE. The high-level behavior (two keys → async
poll succeeds; one key → sync 204 succeeds) is evaluable by exit code only. The payload
asymmetry is invisible from exit codes — requires wiremock request capture. Without a BC
sub-clause documenting the expected payload, a captured payload assertion would be invented
behavior not grounded in spec.

**Proposed scenarios**: 0 (BLOCKED). Flag for BC sub-clause pass before F2.

---

### Target 4: `jr issue edit --dry-run` (multi-key positional + --jql; --output json)

**Anchor BC(s)**:
- **BC-3.4.012** (`bc-3-issue-write.md` line 817), EC-3.4.012-9: `--dry-run` set → handle_edit
  emits planned-changes preview and exits; this contract (echo) does not fire on dry-run.
- **BC-3.4.013** (`bc-3-issue-write.md` line 905), EC-3.4.013-7: Same dry-run short-circuit note.
- **BC-3.4.015** EC-3.4.015-18 (`bc-3-issue-write.md` line 1382): `--field NAME=VALUE --dry-run`
  → exit 0; read-only HTTP fires (editmeta); PUT NOT issued. Resolution failure still exits 64.
- **BC-3.4.018** EC-3.4.018-5 (`bc-3-issue-write.md` line 1820): `--type --dry-run --output json`
  → plannedChanges emits "issueType" camelCase key with bare string value.

**Anchor adequacy verdict**: INADEQUATE-BROKEN-ANCHOR for the general dry-run observable behavior.
The dry-run short-circuit is noted in multiple BC edge cases but there is NO standalone BC or
dedicated sub-clause that describes:
1. What `--output json` emits on dry-run (the `plannedChanges` structure)
2. What `--output table` emits (human preview format)
3. That exit code is always 0 on a successful dry-run
4. That `--jql` resolution fires (HTTP to search issues) but PUT does not

CLAUDE.md states: "`--dry-run` is implemented on `issue edit` (multi-key positional + `--jql`-resolved sets) with `--output json` support." But there is no BC that individually bodies the dry-run output contract. BC-3.4.015 EC-3.4.015-18 only covers the `--field` sub-case.

**Recommendation**: BLOCKED. The dry-run output shape (specifically what `plannedChanges`
contains for a multi-key `--summary` edit) is not documented in any BC sub-clause. A BC
sub-clause pass is a prerequisite — specifically authoring EC entries in BC-3.4.012 or a
new BC covering the dry-run path. Flag for BC sub-clause pass before F2.

**Black-box evaluability**: PARTIALLY EVALUABLE for exit-code-only scenarios, but the primary
holdout value (verifying no mutation fires + plannedChanges output shape) requires knowing the
plannedChanges JSON structure, which is not in any BC body.

**Proposed scenarios**: 0 (BLOCKED).

---

### Target 5: `jr issue edit` bulk-nested-schema scenario (POST /bulk/issues/fields)

**Anchor BC(s)**:
- **BC-3.4.018** (`bc-3-issue-write.md` line 1783): Multi-key `--type` bulk POST wire shape.
  Individually bodied (fully adequate, see Target 2 analysis above).
- The "bulk-nested-schema" scenario as stated in the gap inventory refers to the general
  `POST /rest/api/3/bulk/issues/fields` request schema with nested `editedFieldsInput`. The
  `--type` path in BC-3.4.018 is the only fully individually-bodied BC for this endpoint.
  `--priority` and `--summary` multi-key paths reference the same endpoint but their wire
  shapes are documented in collapsed/thin BCs (BC-3.4.003 range-collapsed).

**Anchor adequacy verdict**: ADEQUATE specifically for BC-3.4.018 (the `--type` path).
The BC provides precise wire-shape assertions for `selectedActions` (lowercase) vs
`editedFieldsInput` (camelCase key, string `issueTypeId`). This is the most specific and
regression-prone sub-case of the bulk nested schema.

Target 5 overlaps significantly with Target 2 (same BC, same wire shape). The distinct
holdout value here is the `--type` path's POST body capture (already proposed as
H-NEW-EDIT-TYPE-002 in Target 2). Do not author a duplicate scenario.

**Proposed scenarios**: 0 (covered by H-NEW-EDIT-TYPE-002 in Target 2).

---

### Target 6: `jr issue changelog`

**Anchor BC(s)**:
- **BC-2.5.043** (`bc-2-issue-read.md` line 444): `--field <substr>` client-side filter.
  Thin body: cites source files only. No Preconditions/Postconditions structure.
- **BC-2.5.044** (`bc-2-issue-read.md` line 452): `--author X` needle construction. Thin body.
- **BC-2.5.045** (`bc-2-issue-read.md` line 460): `--reverse` flag. Thin body.
- **BC-2.5.046** (`bc-2-issue-read.md` line 468): JSON output snapshot (nullable
  `fromString`/`toString`). Has a concrete body: the field is `{entries: [{author, created, id,
  items: [{field, fieldtype, from, fromString, to, toString}]}], key}` with `author` nullable
  and `fromString`/`toString` explicitly nullable (not missing).

**Anchor adequacy verdict**:
- BC-2.5.046: ADEQUATE for the JSON shape assertion (the body explicitly states
  `fromString`/`toString` ARE nullable; `author` can be null for system events).
- BC-2.5.043/044/045: INADEQUATE-BROKEN-ANCHOR as standalone. Thin bodies without observable
  postconditions. However, for a black-box holdout the evaluator can still test these by
  asserting on stdout content (presence/absence of specific entries in `--output json` output).

**Black-box evaluability**: EVALUABLE for BC-2.5.046 (JSON shape). The null `fromString`/
`toString` distinction is exactly the kind of shape-invariant that a holdout can assert via
`--output json` output parsing. The `--reverse` behavior is evaluable by comparing timestamps
of first vs last entry. The author-null case is evaluable if the wiremock fixture includes a
system event.

**Existing holdouts**: None anchored to BC-2.5.04x.

**Proposed scenarios** (1 scenario):

1. **H-NEW-CHANGELOG-001**: `jr issue changelog FOO-1 --output json` → nullable fields and
   ordering are correctly serialized; author null for system event.
   Given: wiremock returns `GET /rest/api/3/issue/FOO-1/changelog` with two entries:
   (A) a user-authored entry with `fromString: "To Do"`, `toString: "In Progress"`, and a
   valid `author` object; (B) a system-automation entry with `fromString: null`,
   `toString: null`, and `author: null` (no human author).
   When: `jr issue changelog FOO-1 --output json`.
   Then: exit 0; stdout parses as valid JSON; the JSON contains an `entries` array with 2
   items; the second entry's `author` is `null` (not missing); the second entry's items have
   `"fromString": null` and `"toString": null` (null values, not absent keys).
   Why hidden: The null-vs-absent distinction for `fromString`/`toString` is invisible from
   table output. A regression serializing as `{}` (missing keys) instead of `{"fromString":
   null}` would only surface via `--output json`. Pins BC-2.5.046 load-bearing shape.

---

### Target 7: `jr worklog add`

**Anchor BC(s)**:
- **BC-X.5.001** (`cross-cutting.md` line 283): `client.add_worklog(key, seconds, message)`
  POSTs `/issue/<key>/worklog`; returns Worklog; accepts 201. Thin body: cites test location
  `tests/worklog_commands.rs:8-26` only.
- **BC-X.5.009** (`cross-cutting.md` line 358): `worklog add` forwards the user-supplied
  duration string to Jira as `timeSpent`. Has a more complete body describing the behavioral
  contract: `parse_duration_validate` is client-side syntax validator only; Jira applies server
  settings for day/week normalization. States this RESOLVED NFR-R-C.

**Anchor adequacy verdict**: ADEQUATE for BC-X.5.009. The body describes the observable
behavior (duration string passed through verbatim as `timeSpent`; invalid syntax → exit 64
before POST). BC-X.5.001 is thin but paired with the test cite. Together they provide a
grounded anchor for happy-path POST and invalid-duration exit-64 scenarios.

**Black-box evaluability**: EVALUABLE. The POST body with `timeSpent` field is capturable
via wiremock. Invalid duration (`"bad-input"`) → exit 64 before POST is fully observable
(exit code + stderr + zero POST). The `parse_duration_validate` accepts `1w2d3h30m` per
BC-X.5.005 — that invariant is testable.

**Existing holdouts**: None for `worklog add`. H-045 covers `list_worklogs` pagination,
not `add`.

**Proposed scenarios** (1 scenario):

1. **H-NEW-WORKLOG-ADD-001**: `jr worklog add FOO-1 1h30m "Fixed the thing"` — duration
   string forwarded verbatim as `timeSpent`; invalid duration exits 64 before POST.
   Given for call A: wiremock captures `POST /rest/api/3/issue/FOO-1/worklog` returning 201
   with a valid `Worklog` JSON body (id, author, timeSpent, etc.).
   Given for call B: wiremock mounts `POST` with `.expect(0)`.
   Action A: `jr worklog add FOO-1 1h30m "Fixed the thing" --no-input`.
   Action B: `jr worklog add FOO-1 badunit "message" --no-input`.
   Then A: exit 0; captured POST body contains `"timeSpent": "1h30m"` (the exact user-supplied
   string, NOT a normalized form like `90m` or `5400s`). Jira's server handles normalization.
   Then B: exit 64; stderr contains `badunit` or a duration-parsing error; POST is not called.
   Why hidden: The verbatim pass-through is invisible from exit codes. Pre-S-2.06 behavior
   calculated seconds client-side; BC-X.5.009 documents the v2 string-passthrough. A
   regression re-introducing client-side calculation would silently produce wrong results on
   custom-schedule Jira instances. Pins BC-X.5.009 (RESOLVED NFR-R-C).

---

### Target 8: `jr issue link` / `jr issue unlink`

**Anchor BC(s)**:
- **BC-3.6.001** (`bc-3-issue-write.md` line 1902): `issue link <k1> <k2> [--type T]` POSTs
  `/rest/api/3/issueLink`; default type "Relates". Thin body: cites source + tests.
- **BC-3.6.002** (`bc-3-issue-write.md` line 1910): Ambiguous link type → exit 64 +
  "Ambiguous link type" + ZERO POST. Has adequate exit code, stderr substring, HTTP count.
- **BC-3.6.003** (`bc-3-issue-write.md` line 1918): `issue unlink` ambiguous type → exit 64 +
  ZERO DELETE. Same shape as BC-3.6.002.

**Anchor adequacy verdict**: ADEQUATE for BC-3.6.002 and BC-3.6.003 (both have individually
observable postconditions). BC-3.6.001 is thin but grounded in tests.

**Black-box evaluability**: EVALUABLE. The ambiguous-type exit-64 paths are fully observable.
The happy-path POST for `issue link` is evaluable (POST body + 204 → exit 0).

**Existing holdouts**: None for `issue link` / `issue unlink`.

**Proposed scenarios** (1 scenario):

1. **H-NEW-LINK-001**: `jr issue link FOO-1 FOO-2 --type block` ambiguous → exit 64, zero POST;
   `jr issue link FOO-1 FOO-2` default type "Relates" → POST fires once.
   Given for call A: wiremock returns `GET /rest/api/3/issueLinkType` with types
   `["Blocks", "is blocked by", "Blocker"]` (three entries matching `block` substring).
   POST mounted with `.expect(0)`.
   Given for call B: wiremock returns `GET /rest/api/3/issueLinkType` with
   `[{"name":"Relates"},{"name":"Blocks"}]`; `POST /rest/api/3/issueLink` returns 201.
   Action A: `jr issue link FOO-1 FOO-2 --type block --no-input`.
   Action B: `jr issue link FOO-1 FOO-2 --no-input`.
   Then A: exit 64; stderr contains `"Ambiguous link type"`; POST not called.
   Then B: exit 0; POST was called once with `inwardIssue.key=FOO-1` (or FOO-2),
   `outwardIssue.key=FOO-2` (or FOO-1), `type.name="Relates"`.
   Why hidden: The default-to-"Relates" behavior and the ambiguous-type exit-before-POST are
   both invisible from a success-only test. Pins BC-3.6.002 (VP exits 64, ZERO POST).

---

### Target 9: `jr queue view`

**Anchor BC(s)**:
- **BC-X.8.009** (`cross-cutting.md` line 637): `jr queue view` resolves queue by name or
  `--id`, fetches issue keys, batch-fetches, reorders. Individually bodied with full
  Preconditions, Postconditions (queue ID resolution × 5 outcomes), issue fetch pipeline
  (4 steps), Output section, Error section, and Trace. This is one of the most comprehensive
  BC bodies in the codebase.

**Anchor adequacy verdict**: ADEQUATE. BC-X.8.009 is individually bodied with explicit
postcondition paths for all partial-match outcomes (Ambiguous, ExactMultiple, None, neither
supplied), the `--id` bypass, and the reorder-to-queue-position invariant.

**Black-box evaluability**: EVALUABLE. The partial-match outcomes (Ambiguous exit 64, None
exit 64) are fully observable. The queue-position reorder is observable via `--output json`
comparing the order of `key` fields against the original queue order from the mock. The `--id`
bypass is evaluable.

**Existing holdouts**: None for `queue view`. The partial-match evaluability is already proven
by H-039 (`assets tickets --status PROG` ambiguous pattern).

**Proposed scenarios** (1 scenario):

1. **H-NEW-QUEUE-VIEW-001**: `jr queue view` positional name: exact match → issues in queue
   order; single-substring → Ambiguous exit 64.
   Given for call A: wiremock returns `GET .../servicedesk/{sdId}/queue` with queues
   `[{id:"10",name:"Triage"}, {id:"20",name:"Escalations"}]`;
   `GET .../servicedesk/{sdId}/queue/10/issue` returns keys `["FOO-2","FOO-1","FOO-3"]`
   (queue order: FOO-2 first, FOO-1 second, FOO-3 third);
   `POST /rest/api/3/search` (or `GET .../search/jql`) returns issues in DIFFERENT order
   `[FOO-1, FOO-2, FOO-3]` (alphabetical, not queue order).
   Given for call B: same service desk queues; `GET .../queue` with `.expect(1)` (the list
   call for resolution fires); no queue issue-keys mock (must not be called).
   Action A: `jr --project EJ queue view Triage --output json --no-input`.
   Action B: `jr --project EJ queue view esca --no-input`.
   Then A: exit 0; stdout JSON array has `key` values in the order `["FOO-2","FOO-1","FOO-3"]`
   (queue position order, not search order). The reorder contract is the primary regression risk.
   Then B: exit 64; stderr contains `"esca"` and `"matches multiple"` OR equivalent Ambiguous
   message (per BC-X.8.009: single-substring hit → `MatchResult::Ambiguous` → exit 64 with
   matching queue names); issue-keys GET is not called.
   Why hidden: The reorder-to-queue-position step is invisible from exit codes. A regression
   that returns issues in search order (alphabetical) instead of queue order would produce
   wrong results silently. Pins BC-X.8.009 issue-fetch-pipeline step 4 (reorder invariant).

---

### Target 10: `jr board view`

**Anchor BC(s)**:
- **BC-5.1.001** (`bc-5-boards-sprints.md` line 25): `client.list_boards` GETs
  `/rest/agile/1.0/board`. Thin body.
- **BC-5.1.002** (`bc-5-boards-sprints.md` line 35): `board view --limit --all` clap conflict.
  Thin body (cites test).
- **BC-5.1.003** (`bc-5-boards-sprints.md` line 43): Auto-resolve board. Thin body.
- **BC-5.1.004** (`bc-5-boards-sprints.md` line 53): `get_sprint_issues` with limit returns
  has_more=true. Thin body.

No individually-bodied BC exists for `jr board view`'s truncation/hint behavior or its
scrum-vs-kanban path distinction. The truncation logic confirmed in `src/cli/board.rs` (lines
275-299: `Showing N of ~M results. Use --limit or --all to see more.`) is not documented in
any BC with Postconditions. BC-5.3.001/002 cover team column gating for `board view` and
`sprint current` but not truncation.

**Anchor adequacy verdict**: INADEQUATE-BROKEN-ANCHOR. No BC individually bodies the
observable behavior of `jr board view` (truncation + hint, scrum vs kanban path, `--all`
override). BC-5.1.002 only covers the clap conflict, not the runtime behavior.

**Recommendation**: BLOCKED. A BC sub-clause pass is a prerequisite. Specifically, BC-5.1
needs a new individually-bodied contract (e.g., BC-5.1.005) or expansion of BC-5.1.003/004
to describe:
- Truncation: N < 30 → no hint; N == 30 (has_more) → stderr hint with `--limit` or `--all`.
- Scrum path: uses sprint issues (BC-5.1.004 exists but thin).
- Kanban path: uses JQL search with `statusCategory != Done`.
- The `--all` flag suppresses truncation.

**Black-box evaluability**: EVALUABLE once anchor BC is adequate. The truncation hint is
fully observable from stderr. The scrum/kanban path distinction is observable via different
API endpoints hit (sprint endpoint vs JQL search endpoint). The `--all` flag behavior mirrors
H-040 (sprint current) exactly. But without a BC body documenting expected substrings and
HTTP call patterns, authoring would be based on source inspection, not spec.

**Proposed scenarios**: 0 (BLOCKED). Flag for BC sub-clause pass before F2.
Priority: LOW — truncation behavior is already covered for the analogous `sprint current`
command (H-040). The board view scenario adds value but is not a correctness regression risk.

---

## Summary

### AUTHORABLE-NOW (adequate anchor + evaluable)

| Target | BCs | Proposed Scenarios |
|--------|-----|--------------------|
| 1. `issue edit --field NAME=VALUE` | BC-3.4.015, BC-3.4.016, BC-3.4.017 | 2 (H-NEW-EDIT-FIELD-001, H-NEW-EDIT-FIELD-002) |
| 2. `issue edit --type` multi-key | BC-3.4.018, BC-3.4.019 | 2 (H-NEW-EDIT-TYPE-001, H-NEW-EDIT-TYPE-002) |
| 5. bulk-nested-schema | BC-3.4.018 | 0 (covered by H-NEW-EDIT-TYPE-002) |
| 6. `issue changelog` | BC-2.5.046 | 1 (H-NEW-CHANGELOG-001) |
| 7. `worklog add` | BC-X.5.001, BC-X.5.009 | 1 (H-NEW-WORKLOG-ADD-001) |
| 8. `issue link` / `issue unlink` | BC-3.6.001, BC-3.6.002, BC-3.6.003 | 1 (H-NEW-LINK-001) |
| 9. `queue view` | BC-X.8.009 | 1 (H-NEW-QUEUE-VIEW-001) |

**Total AUTHORABLE-NOW**: 7 targets, 8 scenarios.

### BLOCKED (broken/missing anchor — BC sub-clause pass required)

| Target | Blocking gap | Recommendation |
|--------|-------------|----------------|
| 3. `issue edit --label` schema fork | BC-3.4.006 lacks EC for single-key PUT bare-string vs multi-key POST `{name:}` object asymmetry | Author EC-3.4.006-extension or new BC before authoring holdout |
| 4. `issue edit --dry-run` | No BC individually bodies the `plannedChanges` output structure or `--output json` dry-run shape | Author BC sub-clause (extend BC-3.4.012 EC-3.4.012-9 or new BC-3.4.0xx) |
| 10. `jr board view` | No individually-bodied BC for truncation, scrum vs kanban path, hint format | Author BC-5.1.005 or extend BC-5.1.003/004 |

### NOT-EVALUABLE

No targets fall into this category. All targets are evaluable via the public CLI surface
(wiremock + process-spawn). The only source-internal behaviors (JSM `sd-customerrequesttype`
rejection, JSDCLOUD-4609) are explicitly scoped out in CLAUDE.md and are not target scenarios.

---

## Recommended F2 Authoring Batch

All 8 AUTHORABLE-NOW scenarios fit in a single burst (below the ≤8-scenario burst limit).
No sub-burst split required.

**F2 batch — single burst**:

| ID | Scenario summary | Anchor BC(s) | Priority |
|----|-----------------|--------------|----------|
| H-NEW-EDIT-FIELD-001 | `--field` absent from editmeta → exit 64 Edit-screen hint, zero PUT | BC-3.4.015 EC-3.4.015-12 | HIGH |
| H-NEW-EDIT-FIELD-002 | `--field` on 2+ keys → C-1 guard exit 64 before editmeta GET | BC-3.4.017 Gate A | HIGH |
| H-NEW-EDIT-TYPE-001 | Cross-project `--type` bulk → exit 64 before any HTTP | BC-3.4.019 EC-3.4.019-1 | HIGH |
| H-NEW-EDIT-TYPE-002 | Multi-key `--type` bulk wire: camelCase/lowercase asymmetry on POST body | BC-3.4.018 EC-3.4.018-1 | HIGH |
| H-NEW-CHANGELOG-001 | Changelog JSON: null `fromString`/`toString` and null `author` (system event) | BC-2.5.046 | HIGH |
| H-NEW-WORKLOG-ADD-001 | `worklog add` verbatim `timeSpent` passthrough; bad duration exits 64 pre-POST | BC-X.5.009 | HIGH |
| H-NEW-LINK-001 | `issue link` ambiguous type exit 64; default "Relates" POST | BC-3.6.002 | MEDIUM |
| H-NEW-QUEUE-VIEW-001 | `queue view` reorder-to-queue-position; single-substring Ambiguous exit 64 | BC-X.8.009 | HIGH |

**Holdout count**: 71 current + 8 new = **79 total** (Target 5 is covered by H-NEW-EDIT-TYPE-002;
no separate scenario).

---

## Regression Risk

**Duplication check**: No proposed scenario duplicates an existing holdout. Confirmed by
grepping holdout-scenarios.md for all anchor BC IDs (BC-3.4.015/016/017/018/019, BC-2.5.046,
BC-X.5.009, BC-3.6.002, BC-X.8.009) — all returned zero matches.

**Conflict check**:
- H-NEW-EDIT-TYPE-002 confirms the POST body asymmetry. It is compatible with H-041 (sprint
  add JSON shape) — both pin asymmetric JSON shapes in different domains.
- H-NEW-QUEUE-VIEW-001 uses the same partial-match infrastructure as H-039 (assets tickets
  ambiguous). No conflict — different endpoint, different service.
- H-NEW-CHANGELOG-001 does not conflict with BC-2.4.043 (list_comments stall guard) — the
  changelog stall guard is already an invariant in the BC but not yet a holdout scenario. The
  proposed scenario focuses on the JSON shape (BC-2.5.046), not the pagination stall guard.

**BLOCKED targets**: Targets 3, 4, 10 are blocked. Authoring those holdouts without anchor
BC sub-clause pass would produce evaluator-blocking scenarios (the evaluator would not know
what wire payload shape to assert, requiring source inspection — violating information
asymmetry). Flag for next BC maintenance cycle.

---

## Notes for F2 Author

1. All 8 scenarios use the `--output json` + wiremock request-capture pattern already
   established by H-NEW-ADF-* and H-NEW-JSM-RT-* groups.
2. H-NEW-EDIT-TYPE-002 is the most complex scenario: it requires a three-step mock chain
   (createmeta GET → bulk POST → bulk-task poll). The bulk-task poll fixture pattern
   is already established in existing tests (`tests/issue_bulk.rs`).
3. H-NEW-QUEUE-VIEW-001 requires a wiremock that returns issues in alphabetical order from
   the search endpoint but asserts the output is in queue-position order — the reorder is
   the key behavior to pin. Use `--output json` to parse `key` field order.
4. H-NEW-WORKLOG-ADD-001 pair structure (call A happy path, call B bad-duration exit 64)
   follows the pattern of H-NEW-ADF-007/008 (two-call scenarios). Author both calls.
5. For H-NEW-LINK-001: the `--type block` substring matches multiple link type names. Wire
   the mock to return three entries containing "block" (e.g., "Blocks", "is blocked by",
   "Blocked by"). Do NOT match on a single entry — the ambiguity must be genuine.

_Document authored: 2026-06-30 by product-owner agent as Phase F1 scoping output._
_This document is SCOPING ONLY — no spec files were modified._
