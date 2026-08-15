---
context: phase-f1-delta-analysis
title: "F1 Delta Analysis — Component Management Bundle (#604, #605, #606, #608)"
author: business-analyst
date: 2026-08-15
issues: [604, 605, 606, 608]
deferred: [607, 609]
status: draft
---

# F1 Delta Analysis — Component Management Bundle

Scope: `jr component` CRUD/rename (#604, #608), `--component` on `issue create/edit` (#605),
`--component` filter on `issue list` (#606). #607 (shared filter grammar) and #609 (impact
scan) are explicitly deferred — do not map BCs for them; only note where the deferred work
would eventually attach.

This is a delta-mapping document only. No BCs, stories, or VPs are created here — F2/F3 own
that. Everything below is "where would this land and what would it need to say," grounded in
the current PRD (`total_bcs: 661` per `BC-INDEX.md` frontmatter, source of truth confirmed
against `CANONICAL-COUNTS.md`).

---

## 1. Placement Recommendation

### Recommendation: split across a NEW `bc-8-components.md` file + MODIFIED sections in two existing files

**A. NEW `bc-8-components.md`** — for `jr component list/create/edit/delete` (#604) and
`jr component rename` (#608). Rationale:

- These are a new top-level `jr component` command group (peer of `jr board`, `jr sprint`,
  `jr worklog`, `jr team`, `jr queue`, `jr requesttype` in `src/cli/mod.rs::Command`), not a
  modification of an existing command's behavior. The PRD's convention for a command group of
  this size is a dedicated file, not a cross-cutting subsection — compare `bc-5-boards-sprints.md`
  (36 BCs cumulative / 18 individually-bodied, covering `board` + `sprint`, itself split into
  4 subsections: 5.1 Board Commands, 5.2 Sprint Commands, 5.3 Team Column Parity, 5.4 API
  Layer) against the cross-cutting `X.6 Teams` subsection (only 4 BCs, because `team list` is
  a single read-only command with no CRUD surface). Component CRUD + delete-safety + rename +
  disambiguation is closer in shape and size to boards/sprints than to `team list`: four
  operations (list/create/edit/delete), each with its own error taxonomy, plus a dedicated
  rename command with `--project`/`--all-projects`/`--dry-run` modes. Estimate ~20-28 BCs
  once F2 expands this (CRUD behavior + name/ID resolution/disambiguation + delete-safety +
  rename fan-out + JSON shapes + error taxonomy), which crosses the file-split threshold the
  existing corpus already uses.
- Precedent for *where in the file tree* a new bounded-context-sized command group goes:
  `bc-4-assets-cmdb.md` and `bc-5-boards-sprints.md` were both added as new numbered files
  rather than folded into `cross-cutting.md`, specifically because they represent a discrete
  product surface with its own subsections (`README.md` Document Map, per CANONICAL-COUNTS.md
  §Other Counts, lists "7 bounded contexts (bc-1..bc-7) + 1 cross-cutting" — `bc-8` extends
  that same numbering scheme rather than growing `cross-cutting.md` past its current 151 BCs).
- Suggested internal structure for `bc-8-components.md` (mirrors `bc-5-boards-sprints.md`'s
  4-subsection shape):
  - `8.1 Component Read & CRUD` (list/create/edit — #604)
  - `8.2 Component Delete Safety` (delete + `--move-to`/`--orphan` — #604)
  - `8.3 Component Rename` (`--project`/`--all-projects`/`--dry-run` — #608)
  - `8.4 Name/ID Resolution & Disambiguation` (shared resolver logic used by all four issues —
    OR fold this into an EXTENSION of the existing `X.10 Partial-Match` subsection in
    `cross-cutting.md` instead of duplicating it in bc-8; see Open Question below)

**B. MODIFIED `bc-3-issue-write.md` §3.4 Edit and Open** — for #605 (`issue create/edit
--component add:/remove:`). This is NOT a new command; it is a new flag on the existing
`issue edit`/`issue create` handlers, directly parallel to `BC-3.4.006` (label add/remove
wire-shape) and `BC-3.4.020` (label single-key-PUT vs multi-key-bulk-POST routing fork).
The validated correction that #605 needs NO read-modify-write (native `update` verb
add/remove, editmeta-gated) means the new BCs are closer in shape to `BC-3.4.006` (a pure
wire-shape contract) than to a CMDB-style enrichment pass. Belongs in §3.4 alongside the
label BCs it is symmetric with, not in a new file.

**C. MODIFIED `bc-2-issue-read.md` §2.1 JQL Composition** — for #606 (`--component` filter on
`issue list`). Directly parallel to `BC-2.1.007` (filter-clause stable ordering),
`BC-2.1.011`/`BC-2.1.012` (asset-key resolution + ambiguity handling pattern — resolves a
human name to an ID before composing JQL, exits 64 pre-search on ambiguity), and
`BC-2.1.013`–`BC-2.1.015` (status-filter operator handling: exact vs substring vs
`NOMATCH`). #606's `not:`/`none`/`all:` operators are new JQL-composition surface but the
placement precedent (name→ID resolution feeding into `build_filter_clauses`) is squarely
§2.1, not a new file.

### Count-propagation warning (flag, not resolve)

`BC-INDEX.md` frontmatter declares `total_bcs: 661` with **8 propagation surfaces** enforced
by `scripts/check-bc-cumulative-counts.sh` (per CLAUDE.md AI Agent Notes): (A) per-file
frontmatter `total_bcs`, (B) `BC-INDEX.md` section headers, (C) `BC-INDEX.md` `sections:`
list lines, (D) `CANONICAL-COUNTS.md` per-file table, (E) `CANONICAL-COUNTS.md` body preamble
prose, (F) `BC-INDEX.md` frontmatter `total_bcs`, (G) `CANONICAL-COUNTS.md` Sum row, and the
grand-total prose. A NEW `bc-8-components.md` file additionally requires:
- A new row in `BC-INDEX.md`'s `sections:` frontmatter list and a new `## Section 8:` header.
- A new row in `CANONICAL-COUNTS.md`'s "Per-file definitional counts" AND "Per-file
  `total_bcs`" tables, plus an update to the Sum row (currently 661) and grand-total prose.
- A new row in `README.md`'s Document Map (currently "7 bounded contexts + 1 cross-cutting").
- `scripts/check-bc-cumulative-counts.sh` and `scripts/check-spec-counts.sh` must both be
  re-run clean after F2 lands the new file — CLAUDE.md explicitly documents these as
  DRIFT-001/DRIFT-002 mitigations that must be run "after any edit to .factory/specs/prd/ BC
  files." The modifications in (B) and (C) above (new sub-BCs inside bc-3/bc-2) only bump
  their OWN file's `total_bcs`/`definitional_count` plus the two index files — they do not
  need a new `sections:` row, but still touch all 8 propagation surfaces' numeric values.
- **This is an F2 obligation, not resolved here.** Flagging so F2's spec-evolution pass
  budgets for the count-propagation edit in the same commit as the new BCs (CLAUDE.md's
  documented failure mode for this class of change is a same-commit doc-fallout miss, per
  the "When adding a new `JR_*` test-seam env var" convention and the BC-CITE-001/CI-CITE-001
  guard history — the count guards exist because this exact drift has happened before).

### Open question for F2 (not decided here)

Should component name/ID resolution + disambiguation (8.4 above) be:
(a) its own subsection in the new `bc-8-components.md`, scoped to component-specific
    disambiguation UX (error strings, `jr component list` fallback hints), or
(b) an EXTENSION of `cross-cutting.md §X.10 Partial-Match` (`BC-X.10.001`–`003`), since the
    underlying resolver is almost certainly `src/partial_match.rs` reused verbatim (same
    `MatchResult::Ambiguous`/`ExactMultiple` shape already used by `queue`/`requesttype`/move
    status resolution) — in which case only the CALLER contracts belong in bc-8, and
    `BC-X.10.001`'s Edge Cases list gets one more caller citation (mirroring how it already
    cites `src/cli/queue.rs::resolve_queue_by_name`, `src/cli/issue/workflow.rs`, and
    `src/cli/requesttype.rs`).
Recommend (b) for the resolver-purity contract and (a) for the component-specific
"unknown component name → exit 64, list valid names" / "ambiguous → exit 64, list matches"
error-message contracts, matching how `BC-2.1.013`/`014` (status disambiguation, bc-2-local)
coexist with `BC-X.10.001`/`003` (partial_match, cross-cutting-shared) today.

---

## 2. NEW vs MODIFIED BC Map

Placeholders use `BC-8.S.NNN` for the new file, `BC-3.4.NNN`/`BC-2.1.NNN` for modifications to
existing sections. Exact numbers are F2's job (next available slot in each section); this is
a coverage checklist, not a numbering commitment.

### 8.1 Component Read & CRUD (NEW, bc-8-components.md) — issue #604

| Placeholder | Summary | Precedent BC |
|---|---|---|
| new BC-8.1.001 | `jr component list <PROJECT>` GETs `/rest/api/3/project/{key}/components`, renders table (id, name, description, lead, assigneeType); accepts project key or name resolvable via existing project-lookup path | `BC-X.8.005` (`list_projects` pagination shape), `BC-2.7.001` (attachment list channel-profile precedent) |
| new BC-8.1.002 | `jr component list --output json` returns array of component objects; JSON render invariant (#526, `output::render_json`) | `BC-7.3.010`, `BC-2.7.002` |
| new BC-8.1.003 | `jr component create <PROJECT> <NAME>` POSTs `/rest/api/3/component`; accepts `--description`, `--lead <display-name>`, `--assignee-type` | — (new) |
| new BC-8.1.004 | `jr component create --lead <NAME>` resolves display name → accountId via existing assignable-user search (`search_assignable_users_by_project` / `search_users`), mirrors `issue assign --to <name>` resolution | `BC-3.1.002`, `BC-X.7.001/002` |
| new BC-8.1.005 | `jr component create --lead <NAME>` ambiguous/no-match → exit 64 before POST (no partial create) | `BC-X.7.004` (duplicate display-name handling pattern) |
| new BC-8.1.006 | `jr component edit <NAME\|ID>` PUTs `/rest/api/3/component/{id}`; supports `--description`, `--lead`, `--assignee-type` field-level updates (only supplied fields sent) | `BC-3.4.005` (multi-field simultaneous PUT), `BC-3.4.015` (`--field` editmeta-gated pattern, if reused for arbitrary fields) |
| new BC-8.1.007 | `jr component edit --lead <NAME>` reuses the same display-name→accountId resolver and ambiguity handling as create | new BC-8.1.004/005 |
| new BC-8.1.008 | Component name/ID accepted interchangeably on `edit`/`delete`/`view`-if-added; all-digit input short-circuits to ID lookup (mirrors the `requesttype fields` numeric-bypass convention) | CLAUDE.md Gotcha "`jr requesttype fields <NAME\|ID>` numeric-bypass edge case" |
| new BC-8.1.009 | Unknown component name/ID on any CRUD verb → exit 64, taxonomy-consistent message | `BC-2.7.006` (unknown-KEY taxonomy pattern) |

### 8.2 Component Delete Safety (NEW, bc-8-components.md) — issue #604

| Placeholder | Summary | Precedent BC |
|---|---|---|
| new BC-8.2.001 | `jr component delete <NAME\|ID>` refuses (exit 64) without EITHER `--move-to <COMPONENT>` OR `--orphan` — mutually exclusive, one required (clap-level conflict, mirrors `--resolution`/`--no-resolution`) | `BC-3.2.013`/ADR-0015 (proactive-guard-before-mutating-call shape); `--to`/`--account-id`/`--unassign` 3-way clap conflict (`BC-3.1.006`) |
| new BC-8.2.002 | `--move-to <COMPONENT>` DELETEs `/rest/api/3/component/{id}?moveIssuesTo=<targetId>` (Jira's native single-call reassignment — confirmed endpoint, no client-side per-issue re-tag loop needed) | — (new; confirmed endpoint per validated context) |
| new BC-8.2.003 | `--orphan` DELETEs `/rest/api/3/component/{id}` with no `moveIssuesTo` param — issues on the deleted component lose that component tag (Jira-native behavior, not client-orchestrated) | — (new) |
| new BC-8.2.004 | `--move-to` target resolution reuses 8.1's name/ID resolver; unknown/ambiguous target → exit 64 BEFORE the DELETE fires (no partial delete-then-fail) | `BC-2.1.012` (ambiguous asset → exit 64, no search fired — same "resolve before mutate" invariant) |
| new BC-8.2.005 | `--move-to <SELF>` (target == component being deleted) → exit 64 pre-flight, no HTTP | — (new edge case; needs explicit BC per delete-safety framing) |
| new BC-8.2.006 | Interactive confirmation gate for delete (TTY) vs `--yes`/`--no-input` non-interactive requirement, mirroring the attachment-delete and comment-delete confirmation pattern | `BC-3.5.*` comment-delete `--yes` gate family (DEC-168), `H-NEW-ATTACHMENT-005` |
| new BC-8.2.007 | `--output json` shape for delete: `{"deleted": "<id>", "movedIssuesTo": "<id>"\|null}` | `BC-2.7.008` downloaded[] JSON-shape precedent (structured success payload) |

### 8.3 Component Rename (NEW, bc-8-components.md) — issue #608

| Placeholder | Summary | Precedent BC |
|---|---|---|
| new BC-8.3.001 | `jr component rename OLD NEW --project <KEY>` resolves OLD via 8.1 resolver scoped to one project, PUTs new name | new BC-8.1.006 (edit is effectively rename-via-PUT with `name` field) |
| new BC-8.3.002 | `jr component rename OLD NEW --all-projects` fans out: discovers every project containing a component named OLD (cross-project ID resolution — the corrected, validated value-add of this issue, NOT casing normalization) via project-scoped component list calls per accessible project | `BC-X.8.005` (`list_projects` pagination) composed with new BC-8.1.001 (per-project component list) |
| new BC-8.3.003 | `--all-projects` fan-out is per-project atomic: a failure renaming component in project B does not roll back a successful rename already committed in project A; summary report lists per-project success/failure | `BC-2.7.008` per-file fail-soft pattern (batch operations degrade gracefully, not all-or-nothing) — analogous shape, different domain |
| new BC-8.3.004 | `--dry-run` on rename (single-project or `--all-projects`) previews the set of components that WOULD be renamed with zero mutating HTTP calls; `--output json` schema `{dryRun: true, targets: [...]}` | `BC-3.4.021` (`issue edit --dry-run` `plannedChanges` shape — direct structural precedent) |
| new BC-8.3.005 | `rename` without `--project` or `--all-projects` → exit 64 (ambiguous scope, same "no default scope" philosophy as `BC-2.1.006`'s "no project AND no filters" guard) | `BC-2.1.006` |
| new BC-8.3.006 | Case-only rename (`OLD`="Backend", `NEW`="backend") — since JQL name matching is case-insensitive (validated correction), this is a legitimate operation and must NOT be short-circuited as a no-op by any case-insensitive equality check in the resolver | — (new; explicit edge-case-driven BC given the corrected premise) |
| new BC-8.3.007 | `NEW` collides with an existing component name in the same project → Jira API error surfaced verbatim (400), not pre-validated client-side (avoids a second round-trip; consistent with `BC-X.3.004`'s field-specific-error passthrough convention) | `BC-X.3.004` |

### Modified: bc-3-issue-write.md §3.4 Edit and Open — issue #605

| Placeholder | Summary | Precedent BC |
|---|---|---|
| modified/new BC-3.4.NNN-a | `issue edit --component add:X --component remove:Y` interprets prefix, sends native Jira `update` verb ops (`{"update":{"components":[{"add":{"name":"X"}},{"remove":{"name":"Y"}}]}}` or `{"id":...}` form — exact shape is F2/architecture's job to confirm against editmeta, corrected context says NO read-modify-write needed) — single-key path | `BC-3.4.006` (label add/remove wire-shape — direct structural twin) |
| modified/new BC-3.4.NNN-b | `--component` multi-key/`--jql` bulk path — needs its OWN routing decision: does Jira's bulk-fields API support a `componentsFields`-shaped bulk op analogous to `labelsFields` (`BC-3.4.020`)? If not confirmed, multi-key `--component` should follow the `REJECTED_IN_BULK` pattern (`BC-3.4.017` Gate A) until confirmed, NOT silently assumed symmetric with labels | `BC-3.4.020` (if bulk-supported) OR `BC-3.4.017` Gate A (if rejected) — **F2 must resolve which, do not assume** |
| modified/new BC-3.4.NNN-c | `issue create --component X --component Y` (bare, no add:/remove: prefix — create has no existing state to diff against) sets the initial components array on POST | `BC-3.3.004` (create body composition pattern — additive field, not update-verb) |
| modified/new BC-3.4.NNN-d | `--component` name resolution is editmeta-gated per the validated correction — an unknown component name → exit 64 listing valid names for that project, discovered via one `GET editmeta` or `GET project/{key}/components` round-trip (choose one; must not duplicate both) | `BC-3.4.015` (`--field` editmeta round-trip pattern), `BC-2.1.014` (`--status NOMATCH` listing pattern) |
| modified/new BC-3.4.NNN-e | Flag-overlap guard: does `--component` need a Gate-B-style mutual exclusion against a hypothetical `--field components=...`? Given `--field` already exists and `components` is a system field, this is a REAL overlap risk symmetric to `BC-3.4.017`'s summary/description/issuetype/priority list — `components` should likely be ADDED to that four-field list, becoming five | `BC-3.4.017` Gate B (extend, don't duplicate) |
| modified BC-3.4.017 | Gate B's fixed four-field list (`summary`/`description`/`issuetype`/`priority`) is a candidate for amendment to include `components`, OR an explicit documented exclusion decision (mirrors how `--team`/`--points` were explicitly deferred to v2 in the existing BC body) | `BC-3.4.017` (amend-in-place candidate, same pattern as BC-1.2.018/BC-2.2.028's prior amendments) |
| modified BC-2.2.028 / BC-2.3.036 (bc-2, not bc-3, but co-dependent) | `Component` struct (`src/types/jira/issue.rs::Component`) currently has ONLY `pub name: String` — no `id` field. #605/#606/#604 all need component IDs. Adding `id: Option<String>` (or non-optional, TBD by F2/architecture) to `Component` is a MODIFIED read-contract touching `BC-2.3.036`'s "deserializes: ... components ..." clause and the existing inline test `src/types/jira/issue.rs::tests` (asserts `components[0].name == "Backend"`, does not currently assert an id) — same amendment shape as the 2026-08-13 `duedate` precedent (BC-2.2.028/BC-2.3.036 amended in place, no count change) | `BC-2.2.028`/`BC-2.3.036` duedate precedent (exact structural analog: additive field on an existing nullable struct, amend-in-place) |

### Modified: bc-2-issue-read.md §2.1 JQL Composition — issue #606

| Placeholder | Summary | Precedent BC |
|---|---|---|
| new BC-2.1.NNN-a | `--component <NAME>` (repeated) → OR-combined `component in (id1, id2, ...)` JQL clause; each repetition resolves name→ID independently before composition | `BC-2.1.011` (`--asset KEY` name→ID resolution before JQL composition) |
| new BC-2.1.NNN-b | `--component not:<NAME>` → `component not in (id)` | — (new operator; no direct BC precedent, closest shape is `BC-2.1.004`'s `statusCategory != Done` negation) |
| new BC-2.1.NNN-c | `--component none` → `component is EMPTY` (the "untagged queue" value confirmed in validated context — this is the real payoff of #606, not casing) | — (new; must NOT be conflated with an unresolvable name — `none` is a reserved keyword like `--assignee unassigned` likely already has a precedent worth checking in `build_filter_clauses`) |
| new BC-2.1.NNN-d | `--component all:<NAME1>,<NAME2>` → AND-combined (`component = id1 AND component = id2`, since Jira issues can carry multiple components) — distinct JQL shape from the OR-list form above | — (new; F2 must confirm exact JQL AND-composition Jira accepts for multi-component AND, since `component in (...)` is inherently OR) |
| new BC-2.1.NNN-e | Unresolvable component name (no match in project, and no `not:`/`none`/`all:` prefix recognized as a keyword) → exit 64 BEFORE any JQL search fires, listing valid component names for the resolved project scope | `BC-2.1.012` (asset ambiguity: exit 64, NO issue search fired), `BC-2.1.014` (status NOMATCH listing pattern) |
| new BC-2.1.NNN-f | Ambiguous component name (matches 2+ within project scope via `partial_match`) → exit 64, `Ambiguous component` message listing candidates | `BC-2.1.013` (status single-substring ambiguity), `BC-X.10.001` |
| new BC-2.1.NNN-g | `build_filter_clauses` clause-ordering: `--component` joins the existing stable-order list (`BC-2.1.007`: assignee, reporter, status, open, team, recent, asset, created/updated dates) — F2 must pick and pin its position in that ordered list (test asserts EXACT clause order per `BC-2.1.007`'s existing behavior) | `BC-2.1.007` (amend-in-place: ordered list gains one more member, same amendment shape as prior additions to this BC) |
| modified BC-2.1.006 | "No project AND no filters AND no `--jql` → exit 64 listing all 13 filter sources" — `--component` becomes filter source #14; the enumerated list in this BC's error message and body text needs updating (amend-in-place, no count change, same class as BC-1.2.018's "carve-out" amendment) | `BC-2.1.006` |

### Error Taxonomy additions (error-taxonomy.md, likely modified not new file)

- `component-not-found` (unknown name, no match) — Section 6 "Domain-Specific Error Messages"
  gains a "Component Commands" subsection alongside existing "Sprint Commands"/"Asset
  Commands"/"Auth Commands"/"Config / Profile"/"Issue Commands" subsections.
- `component-ambiguous` (2+ matches) — same subsection, mirrors the `--asset`/`--status`
  ambiguity error shape already documented for issue commands.
- `component-delete-guard` (neither `--move-to` nor `--orphan`) — exit 64, mirrors the
  `--resolution`/`--no-resolution` proactive-guard message shape (ADR-0015 precedent).
- Cross-project rename ambiguity (same name resolves in 2+ projects under
  `--all-projects` when the user probably meant one) is NOT an error under `--all-projects`
  semantics (that's the point of the flag) but IS an error under bare `rename OLD NEW`
  without `--project`/`--all-projects` — already covered by new BC-8.3.005 above.

---

## 3. Regression-Risk Stories (existing stories touching modified modules)

Modules being modified: `issue edit`/`issue create` flag routing (`src/cli/issue/edit.rs`,
`src/cli/issue/create.rs`), `issue list` JQL composition (`src/cli/issue/list.rs`), and
possibly `src/cache.rs` (if a component-list cache family is added — see §5 Edge Case seed).
Grepped `.factory/stories/` for label/edit/list/cache relevance; the following existing
stories are the regression zone F4 (delta implementation) and F6 (targeted hardening) must
re-run full regression against, because they assert exact behavior in the same functions
`--component` will touch:

**`issue edit`/`issue create` flag-routing regression zone:**
- `S-396-issue-edit-field-flag.md` — introduced `--field`, the editmeta-gated resolution
  pattern #605 will most likely reuse; also owns `REJECTED_IN_BULK`/Gate-A/Gate-B guard
  machinery in `handle_edit` that a new `--component` flag must be correctly slotted into
  (BULK_SUPPORTED vs REJECTED_IN_BULK vs SELECTORS partition, per `BC-3.4.017` Invariant 2).
- `S-407-label-conflict-block-coverage-and-meta-test.md` — the `--label` mutual-exclusion
  block (BC-3.4.020 Precondition 3's 12-flag list) is the exact shape `--component` will
  need its own version of, or will need to be ADDED to if `--component` and `--label` should
  also be mutually exclusive with each other's target fields. Direct regression risk: this
  story's `test_label_conflict_block_lists_every_relevant_flag` meta-test (BC-3.4.017 EC-14)
  mechanically enforces the flag-partition is exhaustive — adding `--component` without
  updating that partition will fail this story's own meta-test.
- `S-398-issue-edit-create-changed-fields-echo.md` — the `changed_fields` JSON echo and
  table-mode stderr echo (`field → value` format, BC-3.4.012/013) must gain a `components`
  entry; this story owns the echo mechanism `--component` edits must route through.
- `S-639-1.md` (DEC-188 pre-flight guards, `--field`/`--on-behalf-of` without
  `--request-type`) — establishes the "exit-64 pre-flight BEFORE project-key resolution /
  interactive prompts / HTTP" ordering convention that a `--component` platform-vs-JSM
  dispatch fork (if JSM request creation also needs component support) would need to respect.
- `S-692-1-dry-run-stdin-adf-preview.md` — owns `--dry-run`'s `plannedChanges` JSON shape
  (BC-3.4.021) that new BC-8.3.004 (rename `--dry-run`) and any `--component` dry-run preview
  should structurally mirror.
- `S-388-cross-hierarchy-type-change-error-and-fake-endpoint-fix.md` — establishes the HTTP
  400 → classified-hint pattern (`BC-3.4.010`/`011`) that component-name-rejected-by-Jira 400s
  should probably NOT reuse verbatim (component name errors are pre-validated client-side per
  BC-3.4.NNN-d above) but is worth checking against for consistency of 400-handling style.

**`issue list` filter regression zone:**
- Any story touching `build_filter_clauses`'s ordered emission (`BC-2.1.007`) is regression
  risk by construction once `--component` is inserted into that list — grep found no
  single dedicated story file for this function (it predates the F2/story-splitting
  convention used post-#340), so F4 should treat `src/cli/issue/list.rs::build_filter_clauses`
  itself, not a story file, as the regression anchor; existing coverage lives in
  `tests/issue_list_errors.rs` and `tests/issue_list_assets.rs` (see §4).
- `S-668-1-duedate-issue-view-list.md` — most recent precedent for "add a column/filter to
  `issue list`" as a shipped F2 feature; useful as a template for how #606's F2 spec delta
  and F4 implementation should be scoped and sequenced (single-file `list.rs`/`format.rs`
  touch, amend-in-place BCs, no new file).

**Cache regression zone (conditional on whether F2 decides a component-list cache is worth
adding, per §6 edge-case seed below):**
- `S-CACHE-WARM-HIT-COVERAGE-1.md` — owns the "warm cache hit issues ZERO HTTP calls"
  invariant (`BC-6.2.018`, "holds for all nine cache families") — if a `components.json`
  cache family is added, this BC's "nine cache families" enumeration becomes ten, and this
  story's coverage-completeness test needs the new family added to its parametrized list.
- `S-CMDB-OBJTYPE-WARM-HIT-COVERAGE-1.md` — most recent precedent for adding a NEW cache
  family and extending BC-6.2.018's warm-hit coverage in lockstep; template for how F4 would
  do the same for a `components.json` family if F2 decides one is warranted.
- `S-MAINT-CR-005-offset-page-underuse.md` and `S-D4-TEST-HARDENING-BACKFILL-1.md` — general
  cache/pagination hardening stories; lower-priority regression touch, worth a grep-check at
  F4 time but not a hard dependency.

**Not in scope but adjacent (do not treat as regression risk, note only):**
- `S-577-*` (comment CRUD) and `S-576-*` (attachment CRUD) are the two most recent "add a new
  CRUD command family to `jr`" precedents (`comment`/`attachment` subcommand groups under
  `issue`, vs. `component` as a top-level command) — useful as STRUCTURAL templates for #604's
  new-command-group shape (confirmation gates, `--yes`/`--no-input`, JSON envelope
  conventions, error taxonomy subsection placement) even though they don't touch the same
  code paths.

---

## 4. Affected Existing Tests (regression-safety net)

Test files covering the modules #605/#606/#604 will modify or extend:

**`issue edit`/`issue create` (module: `src/cli/issue/edit.rs`, `src/cli/issue/create.rs`):**
- `tests/issue_edit.rs` — core `issue edit` behavior; baseline regression.
- `tests/issue_edit_labels.rs` — the `--label` add/remove/routing-fork tests `--component`
  is structurally symmetric with; if #605 shares any helper code with the label path, this
  file's tests are the closest thing to a regression oracle.
- `tests/issue_edit_field.rs` — `--field` editmeta-gated resolution tests; #605's likely
  reused resolution mechanism.
- `tests/issue_edit_echo.rs` — `changed_fields`/stderr echo tests; must gain `components`
  coverage and must not regress existing field echoes.
- `tests/issue_edit_type_errors.rs` — 400-classification tests; check for accidental overlap
  if component 400s ever reach this classifier.
- `tests/issue_edit_no_parent.rs` — narrower, lower regression risk, but touches the same
  `handle_edit` dispatch function.
- `tests/issue_bulk.rs` / `tests/issue_bulk_pr2.rs` — bulk `--type`/`--label` routing-fork
  tests (`BC-3.4.018`–`020`); directly relevant if #605 gains a multi-key bulk path (see
  §2 modified-BC-3.4.NNN-b open question).
- `tests/issue_commands.rs` — owns the exact-array field-list pins (`BC-2.2.028`,
  `test_search_issues_includes_labels_parent_issuelinks`) and the `get_issue` deserialization
  fixtures (`BC-2.3.036`) that the `Component.id` field addition (§2) will touch; also owns
  general create/edit success-path fixtures.
- `src/types/jira/issue.rs` (inline `#[cfg(test)] mod tests`) — owns the `Component` struct
  deserialization tests (`components[0].name == "Backend"` etc., lines ~504-563 per the read
  above) — DIRECT regression target for the `id` field addition; existing tests use fixtures
  with `"components": [{"name": "Backend"}, {"name": "API"}]` (no `id` key) — if `Component.id`
  becomes non-optional, these fixtures break and must be updated in the SAME change (mirrors
  the duedate-field precedent's "MANDATORY test update... not merely at-risk" framing in
  `BC-2.2.028`).

**`issue list` filters (module: `src/cli/issue/list.rs`):**
- `tests/issue_list_errors.rs` — owns the "no project/no filters/no `--jql` → exit 64 listing
  N filter sources" test (`BC-2.1.006`) that needs its enumerated count bumped when
  `--component` becomes a new filter source; also owns board/sprint 404/5xx error-path tests
  (lower relevance but same file).
- `tests/issue_list_assets.rs` — closest existing structural template for `--component`'s
  name→ID resolution + ambiguity-exit-64 behavior, since `--asset KEY` (`BC-2.1.011`/`012`)
  is the nearest precedent for "resolve a human name to an ID before composing JQL, exit 64
  pre-search on ambiguity."
- `tests/all_flag_behavior.rs` — `--all`/`--limit` interaction tests; lower direct relevance
  but shares `list.rs` dispatch surface, worth a smoke-check.

**Cache (module: `src/cache.rs`) — conditional, only if F2 adds a component cache family:**
- `tests/cache_warm_hit.rs` — the parametrized "zero HTTP on warm hit" test suite
  (`BC-6.2.018`) would need a new case added.
- `tests/cmdb_fields.rs` — closest structural template for a new `(id, name)`-tuple-style
  cache file, if F2 follows the `cmdb_fields.json` precedent for component caching.
- `tests/multi_profile_fields.rs` — cross-profile cache isolation regression test template
  (`BC-6.2.009`/`010`); every new cache family must independently prove this invariant.

**Partial-match / disambiguation (module: `src/partial_match.rs`):**
- No dedicated `tests/partial_match_*.rs` integration file was found in the top-level
  `tests/` listing (unit + proptest coverage lives inline in `src/partial_match.rs`, per
  `BC-X.10.001`–`003`'s `**Source**` citations) — F4 should add component-resolver-specific
  integration coverage in a new test file (`tests/component_*.rs`, matching the `tests/*.rs`
  per-command-group convention already used for `tests/comment_edit.rs`,
  `tests/comment_delete.rs`, `tests/attachment_*.rs`) rather than assuming inline unit tests
  in `src/partial_match.rs` alone are sufficient — those exercise the pure function, not the
  new callers.

---

## 5. Verification Properties — extension + new candidates

**Existing VPs likely needing extension (F2/F3 to confirm exact IDs — none found under a
`VP-COMPONENT-*` or similar prefix in a grep of `.factory/specs/prd/`, confirming this is
genuinely new VP territory, not an extension of a misfiled existing one):**
- None of the existing `VP-LABEL-FORK-001`/`002` (BC-3.4.020) VPs directly extend to
  `--component` — they are specific to the labels wire shape. However, their STRUCTURE
  (assert endpoint call-count via `.expect(0)`/`.expect(1)` on the mock NOT taken, assert
  payload shape on the mock that IS taken) is the template new component-routing VPs should
  follow, especially given #605's open question about whether a bulk `--component` path
  exists at all (§2).
- `VP-576-001` (`prop_sanitize_attachment_filename_no_path_traversal`) — not directly
  reusable, but the precedent of "a resolver/sanitizer function gets its own `.cargo/mutants.toml`
  `examine_globs` entry and dedicated proptest" is worth applying to the component name/ID
  resolver if it becomes a standalone pure function (mirrors `partial_match.rs`'s existing
  treatment).

**New VPs the delta likely needs (F2/F3 to formalize):**
1. **Resolver determinism** — `component_name_resolve(name, candidates)` (or wherever the
   name→ID logic lands) is a pure function: same input always produces the same
   `MatchResult`; exact-match always found even when substring-ambiguous; empty candidates →
   `None`/appropriate not-found variant. Direct structural analog to `BC-X.10.002` proptest.
2. **Add/remove-doesn't-clobber** — `issue edit --component add:X` on an issue that already
   has components `[A, B]` results in `[A, B, X]`, NOT a full replace; `--component remove:A`
   on `[A, B]` results in `[B]` only, never touching B. This is the CORE invariant the
   "no read-modify-write" validated correction depends on — if Jira's native `update` verb
   for components doesn't actually support additive add/remove server-side (unlike labels,
   which are confirmed to), this VP would catch that assumption failing at integration-test
   time against a wiremock fixture that returns the post-update state.
3. **Delete-move ordering** — `component delete --move-to TARGET`: the target resolution
   (name→ID, ambiguity check) completes and succeeds BEFORE the DELETE HTTP call fires; a
   wiremock test asserting `.expect(0)` on the DELETE endpoint when the target is ambiguous
   or unknown (same shape as `BC-2.1.012`'s "no issue search fired" `.expect(0)` pattern).
4. **Filter-operator composition correctness** — for each of OR (repeated `--component`),
   `not:`, `none`, `all:`, assert the EXACT JQL fragment emitted matches the validated
   context's stated shapes (`component in (ids)` / `component not in (ids)` /
   `component is EMPTY` / AND-chain for `all:`) — a direct structural analog to
   `BC-2.1.002`'s JQL-composition string-shape pinning.
5. **Rename fan-out atomicity/reporting** — `--all-projects` rename: a wiremock test with N
   projects where project K's PUT returns a 4xx/5xx must still attempt (or must skip,
   depending on F2's chosen semantics — flagged as undecided in new BC-8.3.003) projects K+1
   through N, and the final summary/JSON output must accurately reflect per-project outcome.
6. **Dry-run zero-mutation guarantee** — `component rename --dry-run` and any
   `--component`/`component delete` dry-run mode (if F2 adds one, not confirmed in the issue
   list above — #604's delete doesn't explicitly mention `--dry-run` in the bundle
   description, only rename does) issues ZERO PUT/POST/DELETE calls; direct structural analog
   to `BC-3.4.021`'s existing dry-run VP coverage.
7. **Cross-project ID non-collision** — if two different projects each have a component
   literally named "Backend" with different IDs, `--component Backend` on an `issue list`
   scoped to a single project must resolve to THAT project's component ID, never the other
   project's — this is the corrected, validated core value of #606 (cross-project ID
   resolution) and deserves an explicit VP given it's the reason #606's original "casing
   drift" premise was wrong in the first place.

---

## 6. Edge-Case Catalog Seed

For F2's `edge-case-catalog.md` (likely a new `## EC-COMPONENT:` section, following the
existing `## EC-AUTH:`/`## EC-CFG:`/`## EC-HTTP:`/`## EC-JQL:`/`## EC-ASSET:`/`## EC-SPRINT:`/
`## EC-OUT:` pattern):

1. **Name collisions across projects** — two projects each have a component named identically
   (e.g., both have "Backend"); `--component Backend` on a project-scoped `issue list` or
   `issue edit` must resolve within that issue's/project's own scope, never cross-contaminate.
   This is the headline corrected value of #606/#608 per validated context.
2. **Casing variants within one project** — "Backend" vs "backend" vs "BACKEND" as distinct
   candidate strings the resolver must treat per JQL's case-insensitive name matching
   (confirmed correction: NOT a real casing-drift bug at the JQL layer) — but the CLIENT-SIDE
   resolver (`partial_match`-based, likely) may itself be case-SENSITIVE by default per
   `BC-X.10.003`'s `ExactMultiple` handling (`name.to_lowercase() == input.to_lowercase()` —
   note this is ALREADY case-insensitive at the partial_match layer) — F2 must confirm the
   resolver and the JQL layer agree, or document why a client-side ambiguity could exist that
   JQL itself would resolve identically (e.g. two components "Backend" and "backend" in the
   SAME project are themselves an edge case Jira may or may not permit — worth a Perplexity
   check at F2 time, not assumed here).
3. **Compass Components projects** — Atlassian's "Compass" product has an entirely separate
   "Components" entity (service/software catalog components, distinct API surface —
   `createCompassComponent`/`getCompassComponent`/`getCompassComponents` in the Atlassian
   MCP tool surface confirm this is a real, separate, currently-integrated Atlassian concept)
   from classic Jira issue-tracking "Components" (`/rest/api/3/component`, the `fields.components`
   array on an issue). `jr component` MUST be scoped explicitly, in its own help text and in
   the BC bodies, to classic Jira project components — NOT Compass. This is a naming-collision
   risk worth flagging prominently in F2's spec (a user typing `jr component list` on a
   Compass-integrated Atlassian site could reasonably expect Compass components; the CLI
   should either explicitly disclaim this in `--help` or, if there's appetite, note it as
   explicitly out of scope in the BC preamble). Not something #604/#605/#606/#608 currently
   claim to handle, and correctly so — but the silence should be an explicit documented
   decision, not an accidental omission.
4. **Empty component set** — an issue with zero components (`fields.components: []` or
   `null` — both are valid per the existing `Component` struct's nullable handling,
   `BC-2.3.036`) must render cleanly in any future `issue view`/`issue list --components`
   display path (not in the current 4-issue bundle, but the underlying data shape already
   supports it) and must correctly match `--component none` on the filter side (#606).
5. **`none` vs unknown-name collision** — the literal string "none" as an ACTUAL component
   name (unlikely but not impossible — Jira doesn't reserve component names) would collide
   with the `none` keyword in `--component none`. F2 must decide: is `none` always treated as
   the reserved "no component" keyword (blocking a real component literally named "none" from
   ever being filterable by name), or is there an escape hatch? Direct analog: how `--assignee
   unassigned` (if it exists as a reserved value elsewhere in `list.rs`) handles the same
   class of collision — worth checking `src/cli/issue/list.rs` for that precedent at F2 time.
6. **`--all-projects` rename fan-out on a huge org** — no explicit page/rate-limit budget
   mentioned in the issue bundle; `--all-projects` implies iterating `list_projects`
   (`BC-X.8.005`, already paginated) times a per-project component-list GET times a
   conditional PUT — this is O(N) HTTP calls where N = project count, with no batching API
   confirmed to exist for cross-project component rename. Worth an explicit NFR or at minimum
   a documented "this can be slow on a large org" caveat, following the existing NFR-O-*
   convention for known scale limitations (cf. `NFR-O-G`'s LOC-deviation entries as a
   convention example of "document the known limitation rather than silently ship it").
7. **`--dry-run` correctness under `--all-projects`** — the dry-run preview must reflect the
   SAME project-discovery logic the real run would use (same `list_projects` filter, same
   per-project component-list resolution) — a dry-run that used a stale or differently-scoped
   project list than the real run would be a correctness bug, not just a UX nit. Direct
   analog to `BC-3.4.021`'s existing dry-run-vs-live parity requirement.
8. **Delete-safety `--move-to` target belonging to a DIFFERENT project** — since components
   are project-scoped, `component delete <ID-in-project-A> --move-to <NAME-in-project-B>`
   should almost certainly be rejected (cross-project move is likely nonsensical/unsupported
   by the Jira endpoint) — needs an explicit BC (candidate: new BC-8.2.008, not yet in §2's
   table above — flagging here as a gap F2 should close) rather than being silently allowed
   to 400 at the API layer with an unhelpful error.
9. **`--field components=...` vs `--component`** — since `components` is a real Jira system
   field name and `--field` already exists as a generic escape hatch (`BC-3.4.015`), a user
   could attempt `--field components=X` today (pre-#605) and get UNDEFINED behavior (the
   generic `--field` path was never designed with components' array-of-objects shape in
   mind — string/number/date/user/select are the documented `--field` value types per
   `BC-3.4.015`/`016`, not array-of-object). This is both a pre-existing latent gap (worth a
   regression check on CURRENT `main` behavior — does `--field components=X` today silently
   corrupt state, error cleanly, or coincidentally work?) and a forward-looking overlap #605
   must resolve via the Gate B extension noted in §2.

---

## Summary

Placement: NEW `bc-8-components.md` for the `jr component` CRUD/delete-safety/rename command
group (#604, #608) — sized and shaped like `bc-5-boards-sprints.md`, not like the smaller
cross-cutting `X.6 Teams`/`X.12 JSM Request Types` subsections — plus MODIFIED sub-BCs in
`bc-3-issue-write.md §3.4` (issue edit/create `--component`, #605, directly symmetric with the
existing label add/remove BC-3.4.006/BC-3.4.020 pair) and `bc-2-issue-read.md §2.1` (issue
list `--component` filter, #606, symmetric with the asset/status resolution-then-filter
pattern in BC-2.1.011-015). The `Component` struct in `src/types/jira/issue.rs` currently
lacks an `id` field — every one of the four issues needs it, making that struct's amendment
(mirroring the 2026-08-13 `duedate` precedent) the single shared prerequisite change all four
issues' BCs implicitly depend on. Flagged the mandatory 8-surface count-propagation cost of
adding a new `bc-8` file (`BC-INDEX.md` × 3 surfaces, `CANONICAL-COUNTS.md` × 4 surfaces,
`README.md` Document Map) as an F2 obligation, not resolved here. Full delta detail, BC
placeholders, regression-risk story list, affected test files, VP candidates, and a
9-item edge-case seed are in the file above.

File: `/Users/zious/Documents/GITHUB/jira-cli/.factory/phase-f1-delta-analysis/business-analyst-input-components.md`
