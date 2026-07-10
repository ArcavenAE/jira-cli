---
document_type: f1-delta-analysis
phase: phase-f1-delta-analysis
producer: architect
timestamp: 2026-07-09
issue: 577
status: awaiting-human-gate
intent: feature
feature_type: backend-cli
mode: BROWNFIELD
---

# F1 Delta Analysis — Issue #577: Extend `jr issue comment` to delete/edit/view

**Feature summary:** Today `jr issue comment` is add-only. This feature adds three new
operations (`delete`, `edit`, `view`) and ships the `sd.public.comment` property
preservation guarantee on `edit` — the primary safety motivation from the issue.

**Research doc status:** `.factory/research/issue-577-comment-crud-jsdpublic-2026-07-09.md`
did NOT exist when this analysis was written. API-behavior claims marked PENDING-RESEARCH
where live-validation is needed before story-writing.

---

## 1. Impact Boundary

### CLI surface — `src/cli/mod.rs` — MODIFIED (structural refactor required)

`IssueCommand::Comment` is currently a leaf variant with a positional `message` argument.
The proposed surface (`jr issue comment delete KEY --id ID`, `jr issue comment edit KEY
--id ID --file PATH`, `jr issue comment view KEY --id ID`) requires `Comment` to become
a subcommand group.

**Breaking CLI change:** `jr issue comment FOO-1 "text"` maps to the new canonical form
`jr issue comment add FOO-1 "text"`. The old flat form cannot coexist with nested
subcommands in clap without an explicit external-subcommand fallback; the flat form must
be deprecated and documented in CHANGELOG.

**Design decision required (BA gate):** Choose between:

- (A) Clean break: `comment add`, `comment delete`, `comment edit`, `comment view`.
  Old `jr issue comment KEY "text"` emits a clap error with a migration hint. Semver:
  requires a minor-version bump (0.6.x → 0.7.0) per project convention.
- (B) Additive: add `CommentDelete`, `CommentEdit`, `CommentView` as new top-level
  `IssueCommand` variants alongside the existing `Comment` variant, resulting in the CLI
  surface `jr issue comment-delete`, `jr issue comment-edit`, `jr issue comment-view`
  (hyphen-joined). No breaking change; ugly ergonomics.

Option A is strongly recommended — it produces a coherent verb-noun surface and removes
a footgun path (the old flat form can never set `--id`). CHANGELOG must document the
rename. This analysis proceeds with Option A.

**New enum required:** `CommentSubcommand` with variants `Add`, `Delete`, `Edit`, `View`.
The existing `Comment { key, message, markdown, file, stdin, internal }` fields move into
`CommentSubcommand::Add`.

### Dispatch — `src/cli/issue/mod.rs` — MODIFIED

New routing arms for `CommentSubcommand::Delete`, `CommentSubcommand::Edit`,
`CommentSubcommand::View`. The existing `Comment { .. }` arm routes to the Add handler
(relocated). All four comment arms will call into the new `interactions.rs` shard (see
PF-017 below).

### PF-017 shard: `src/cli/issue/interactions.rs` — NEW (ADR-0012 trigger)

`workflow.rs` is currently 1,341 LOC (already 34% over the ADR-0012 1,000-LOC threshold,
documented as PF-017). Adding three new handlers — `handle_comment_delete`,
`handle_comment_edit`, `handle_comment_view` — would add ~250–350 LOC, pushing it to
approximately 1,600 LOC. The existing comment handler (`handle_comment`) is already named
as the primary extraction candidate in CLAUDE.md ("extract `handle_comment` + `handle_open`
into an `interactions.rs` shard"). This feature is the right moment to trigger that split.

**Split scope:**
- Extract `handle_comment` → `handle_comment_add` (cosmetic rename) into `interactions.rs`
- Add `handle_comment_delete`, `handle_comment_edit`, `handle_comment_view` into same file
- `handle_open` extraction: optional in this cycle (caller can extract later; don't bloat
  this feature's PR scope further)

`workflow.rs` after split: ~1,200 LOC (still over 1,000, but no longer growing; PF-017
remains DOCUMENT-AS-IS for the remainder of `workflow.rs`).

`interactions.rs` initial size: ~400–500 LOC covering all four comment handlers plus the
shared `read_comment_body_from_source` helper (file/stdin/text). Keep `refuse_noninteractive`
and `dialoguer` helpers in `workflow.rs` (they serve move/assign too); expose them as
`pub(super)` for `interactions.rs` to call.

### API layer — `src/api/jira/issues.rs` — MODIFIED

Three new client methods required:

| Method | Endpoint | Notes |
|--------|----------|-------|
| `get_comment(key, id) -> Result<Comment>` | `GET /rest/api/3/issue/{key}/comment/{id}?expand=properties` | Returns `Comment` (existing type; `properties` field already present). PENDING-RESEARCH: verify `?expand=properties` needed on single-comment GET vs list GET. |
| `delete_comment(key, id) -> Result<()>` | `DELETE /rest/api/3/issue/{key}/comment/{id}` | 204 → Ok(()); 404 → idempotent (exit 0, see §5 below). |
| `update_comment(key, id, body, property) -> Result<Comment>` | `PUT /rest/api/3/issue/{key}/comment/{id}` | `property: Option<bool>` encodes the three states: `None` = send no properties array, `Some(true)` = internal, `Some(false)` = public. The `add_comment` method uses `bool` (defaulting to public when false); `update_comment` uses `Option<bool>` to distinguish "no property to send" (non-JSM path) from "explicitly public" (`Some(false)`) from "explicitly internal" (`Some(true)`). |

If `issues.rs` grows beyond ~900 LOC as a result, consider extracting to a parallel
`src/api/jira/comments.rs` file (same ADR-0012 principle). Check LOC before merging.

Current `issues.rs` LOC (estimated ~750 LOC based on file position of methods). Three
new methods add ~50-70 LOC — likely safe without extraction. CONFIRM LOC in story.

### Types — `src/types/jira/issue.rs` — MINIMAL MODIFICATION

`Comment` already has `properties: Vec<EntityProperty>` (with `EntityProperty { key, value }`).
The `sd.public.comment` property is fully representable with existing types. No new types
needed for the three new operations. The existing `Comment` struct is reused as the return
type of `get_comment` and `update_comment`.

**Optional new type:** `CommentVisibility` enum (`Internal`, `Public`, `Unknown`) could
express the three states parsed from a Comment's properties. This is a nice-to-have that
aids `handle_comment_edit`'s property-preservation logic; it can also be an inline helper
function. Not a required type-level change. Leave for story-writer decision.

### `src/adf.rs` — DEPENDENT, NOT MODIFIED

`handle_comment_edit` calls `markdown_to_adf` (for `--markdown` path) and `text_to_adf`
(plain text). The ADF path is identical to `handle_comment_add`; no changes to `adf.rs`.

---

## 2. Affected Specs

### Existing BC sections that cover comments today

| BC | Location | Coverage today | Status under #577 |
|----|----------|---------------|-------------------|
| BC-3.5.001 | `bc-3-issue-write.md §3.5` | `add_comment` sets `sd.public.comment` property on `--internal` | UNCHANGED — add path behavior preserved byte-for-byte |
| BC-2.4.039 | `bc-2-issue-read.md §2.4` | `issue comments` paginates with `expand=properties` | UNCHANGED |
| BC-2.4.040 | `bc-2-issue-read.md §2.4` | `issue comments` 5xx → exit 1 | UNCHANGED |
| BC-2.4.041 | `bc-2-issue-read.md §2.4` | `sd.public.comment` property wire shape on read | UNCHANGED |
| BC-2.4.042 | `bc-2-issue-read.md §2.4` | `list_comments` offset pagination | UNCHANGED |
| BC-2.4.043 | `bc-2-issue-read.md §2.4` | `list_comments` anti-stall guard | UNCHANGED |

### New BCs required (estimate: 8–10 new BCs in `bc-3-issue-write.md §3.5`)

**NOTE: F1 analysis only — no spec edits here. BC text below is PROPOSED for BA
review; final wording requires BA sign-off before story-writing.**

**BC-3.5.002 (proposed):** `comment delete <KEY> --id <ID>` sends
`DELETE /rest/api/3/issue/{key}/comment/{id}`; 204 → exit 0 with human success message.

**BC-3.5.003 (proposed):** `comment delete` requires confirmation. Without `--yes` in
non-interactive mode (`--no-input` or stdin not a TTY) → exit 64 with actionable message
("Use `--yes` to confirm deletion of comment {ID} on {KEY}"). Interactive mode → `y/N`
prompt (same pattern as `issue edit` large-JQL confirmation). With `--yes` → proceeds
without prompt.

**BC-3.5.004 (proposed):** `comment delete` is idempotent on 404. A 404 response from
the Jira API is treated as "already deleted" → exit 0 (consistent with `issue assign`
idempotency convention). PENDING-RESEARCH: confirm Jira returns 404 (not 403 or 400) on
already-deleted comments.

**BC-3.5.005 (proposed):** `comment edit` GET-preserve-PUT invariant. When neither
`--internal` nor `--public` is passed, `edit` MUST: (1) GET the current comment with
`?expand=properties`, (2) extract the current `sd.public.comment.internal` boolean, (3)
include the same property value in the PUT body. This closes the footgun identified in the
issue. The preservation guarantee is the core BC of this feature.

**BC-3.5.006 (proposed):** `comment edit` fail-safe. If the GET of the current comment
fails (404 = deleted, 403 = forbidden, or any network/API error), the PUT MUST NOT be
sent. Exit 64 with a clear message ("Cannot edit: failed to fetch current comment state").
This is a security-critical fail-safe: defaulting to "public" on a failed GET would
re-publish an internal note.

**BC-3.5.007 (proposed):** `comment edit --internal` explicitly sets `sd.public.comment`
to `{internal: true}` in the PUT body regardless of current state (bypasses GET). Does
not require confirmation.

**BC-3.5.008 (proposed):** `comment edit --public` explicitly sets `sd.public.comment`
to `{internal: false}` in the PUT body. Requires confirmation if the current comment is
internal (visibility-change promotion to public). Non-interactive mode (`--no-input` or
not a TTY) without `--yes` → exit 64 with hint ("Adding `--yes` will make this comment
publicly visible to the customer"). With `--yes` → proceeds.

**BC-3.5.009 (proposed):** `comment edit` on a non-JSM issue. When the fetched comment
has no `sd.public.comment` property in its `properties` array, the PUT body includes no
`properties` array (no property injected). Jira silently ignores the property on non-JSM
issues when present, but clean round-trip behavior requires not injecting a false property
where none existed.

**BC-3.5.010 (proposed):** `comment view <KEY> --id <ID>` displays the single comment
body, author, created timestamp, and visibility status. Table output: one-line header row
+ rendered ADF body (via `adf_to_text`). `--output json` returns the full `Comment` JSON
shape via `output::render_json`. Output channel profile: 2 (Read-only — stdout for data,
stderr for warnings). PENDING-RESEARCH: confirm single-comment GET endpoint returns
full ADF body + properties without extra flags.

**BC-3.5.011 (proposed):** `--internal` and `--public` are mutually exclusive on
`comment edit`; clap-enforced via `conflicts_with`; exit 2 on conflict.

### New ECs required (estimate: 5–7)

- EC for `comment edit` without `--file`: `--file` is required for `comment edit` (no
  positional message, no stdin without `--stdin`). Exit 64 with hint.
- EC for `comment edit --file PATH` where PATH does not exist: exit 64 "file not found".
- EC for `comment delete` with nonexistent KEY: 404 on the issue itself → exit 64 or
  exit 1 (existing error propagation from JiraClient handles this).
- EC for GET-then-PUT race documentation: the GET-preserve-PUT is NOT atomic. If another
  user changes visibility between GET and PUT, the stale state will be sent. This is
  documented as a known limitation (accepted; truly atomic property-preserving updates
  would require a conditional PUT / entity-tag mechanism Jira does not expose in the
  standard comment PUT endpoint — PENDING-RESEARCH).
- EC for `comment view` on deleted comment ID: 404 → exit 64 with "comment not found".

### New VPs required (estimate: 5–7)

- VP-577-001: edit preserves internal property — GET shows `internal:true`, PUT body
  includes `internal:true`, no `--internal` flag supplied.
- VP-577-002: edit preserves public property — GET shows `internal:false` (or property
  absent), PUT body matches.
- VP-577-003: edit fail-safe — GET returns 404 → no PUT sent, exit 64.
- VP-577-004: edit `--public` confirmation gate — `--no-input` without `--yes` on an
  internal comment → exit 64 with visibility-change warning; `--yes` → proceeds.
- VP-577-005: delete sends correct HTTP DELETE; 204 → exit 0; 404 → exit 0 (idempotent).
- VP-577-006: delete non-interactive without `--yes` → exit 64.
- VP-577-007: view returns Comment JSON shape with `--output json`.

---

## 3. Affected Stories / Tests

### Existing comment tests

| Test file / function | Coverage | Risk under #577 |
|---------------------|----------|-----------------|
| `tests/comments.rs` (all tests) | `list_comments` API + pagination | LOW — list path unchanged |
| `tests/cli_smoke.rs::test_comment_message_leading_dash_value_accepted` | `IssueCommand::Comment` clap parsing | HIGH — if `Comment` becomes a subcommand group, this test's parse invocation changes. Must be updated to `jr issue comment add FOO-1 "- a note"`. |
| `tests/cli_smoke.rs::test_comment_flag_stdin_not_absorbed_as_positional_message` | `IssueCommand::Comment` clap parsing | HIGH — same reason |
| `tests/cli_smoke.rs::test_comment_flag_markdown_not_absorbed_as_positional_message` | `IssueCommand::Comment` clap parsing | HIGH — same reason |
| `tests/cli_smoke.rs::test_comment_message_leading_dash_followed_by_flag_does_not_swallow_flag` | `IssueCommand::Comment` clap parsing | HIGH — same reason |
| `tests/e2e_cli_surface_guard.rs` (SURFACE table) | CLI surface validation | HIGH — must register the new `comment add/delete/edit/view` entries and deregister old `comment` flat form |

**Regression risk on the add path:** The `handle_comment_add` handler logic is a
relocation (extraction from `workflow.rs` to `interactions.rs`), not a behavior change.
Existing integration tests for the add path (if any are in `tests/`) will exercise the
same code path via the new `interactions.rs` import. The relocation is LOW regression
risk if done carefully with no logic changes.

### New test files expected

| File | Purpose |
|------|---------|
| `tests/comment_delete.rs` | `handle_comment_delete` integration tests: 204→exit 0, 404→exit 0, no-confirmation exit 64, `--yes` proceeds |
| `tests/comment_edit.rs` | `handle_comment_edit` integration tests: GET-preserve-PUT invariant (VP-577-001/002), fail-safe (VP-577-003), `--internal`/`--public` explicit overrides, `--public` confirmation gate (VP-577-004), non-JSM no-property injection |
| `tests/comment_view.rs` | `handle_comment_view` integration tests: table output shape, `--output json` shape (VP-577-007), 404 exit 64 |

### Holdout scenario scope

No existing holdout scenarios cover comment operations (confirmed: grep of
`holdout-scenarios.md` yields no comment results). New holdout scenarios needed:

- HS-577-1: edit preserves internal property end-to-end (wiremock: GET returns
  `sd.public.comment.internal=true`; assert PUT body re-sends same property; no
  `--internal` flag)
- HS-577-2: edit fail-safe (wiremock: GET returns 404; assert no PUT sent, exit 64)
- HS-577-3: delete idempotent on 404 (wiremock: DELETE returns 404; assert exit 0)
- HS-577-4: `--public` confirmation blocked in non-interactive mode without `--yes`

---

## 4. Security Dimension (CRITICAL)

The `sd.public.comment` property is a **client-visibility gate** on JSM projects. An
internal note made public by a tooling oversight is a data exposure incident. This feature
exists specifically to remove the footgun from the manual `jr api PUT` workflow. Getting
it wrong would be worse than not shipping it.

### Failure mode analysis

**GET-then-PUT race (non-atomic):**
Two users editing the same comment concurrently: User A's GET reads `internal:true`,
User B's GET reads `internal:true`, User B's PUT sets `public`, User A's PUT then sends
`internal:true` again — "fixing" a change they didn't intend to make. This is an
inherent limitation of a non-conditional PUT. Atlassian's comment PUT endpoint does not
expose an `ETag` or `If-Match` header per available documentation (PENDING-RESEARCH:
verify whether Jira Cloud's `/rest/api/3/issue/{key}/comment/{id}` PUT supports
`If-Match` for conditional updates). If ETags are not supported, the race is documented
as a known limitation.

**Fail-safe on GET failure:**
The most critical design question. If `get_comment` fails (404, 403, timeout, parse
error), `handle_comment_edit` MUST exit 64 rather than defaulting public or internal.
There is no safe default: `internal` as default would silently swallow a typo'd
comment ID; `public` as default would be a data exposure risk. The only correct behavior
is: **refuse**. This must be a hard invariant in the BC (BC-3.5.006 above).

BC-3.5.006 must be written with "fail-closed" language: the absence of confirmed internal
state is NOT permission to send a public comment.

**Non-JSM issues (property absent):**
If the fetched comment has no `sd.public.comment` in its properties array, the correct
behavior for `edit` is to PUT without a properties array — not to inject `internal:false`.
Injecting a false property on a non-JSM issue is harmless (Jira ignores it), but it is
sloppy and should not be done. BC-3.5.009 codifies this.

**`--public` confirmation pattern:**
Any explicit transition to `internal:false` on a comment that was previously `internal:true`
is a visibility promotion. The confirmation prompt for `--public` mirrors the pattern in
`issue move` (ADR-0015) and `issue edit` large-JQL confirmation. Non-interactive mode must
exit 64 without proceeding. The prompt text should clearly state the data-visibility
consequence: "This will make an internal note publicly visible to the customer. Continue?"

**Interaction with `--no-input`:**
When `--no-input` is set (or stdin is not a TTY), `--public` without `--yes` MUST exit
64. The `refuse_noninteractive` helper in `workflow.rs` is reusable for this check.

**Security reviewer pass warranted:**
Given that the core of this feature is a client-visibility control, a formal
`vsdd-factory:security-reviewer` pass is REQUIRED at F2 / pre-spec-crystallization.
The security reviewer should specifically audit:
1. The fail-safe path (does it ever NOT exit 64 on GET failure?)
2. The `--public` gate (does any code path bypass the confirmation?)
3. The non-JSM path (does the implementation inject a property that could become active
   on a later project type change?)
4. The PENDING-RESEARCH items (GET single-comment endpoint shape; ETag conditional PUT
   availability)

---

## 5. CLI Surface Consistency

### `--id` flag

The `--id <COMMENT_ID>` flag on `comment delete`, `comment edit`, and `comment view` is a
new pattern in this codebase. Existing edit/view operations use positional arguments or
`--jql`. `--id` is the correct choice here because:
- Comment IDs are numeric strings (`"10001"`) that look like issue IDs
- A positional ID would conflict with the mandatory KEY positional
- `--id` is conventional for resource-level sub-operations (see `jr api --method`)

Clap annotation: `#[arg(long = "id")]` with type `String` (Jira comment IDs are not
guaranteed to be `u64` per API docs — PENDING-RESEARCH: confirm type. Use `String` to
be safe).

### Output channel profiles

| Command | Profile | Rationale |
|---------|---------|-----------|
| `comment add` | 5 (No-log facade, current behavior) | Returns `{key, id}` JSON; only success message to stdout |
| `comment delete` | 5 (No-log facade) | Returns `{"key": KEY, "id": ID, "deleted": true}` JSON; human: success message |
| `comment edit` | 4 (Symmetric) | Stdout for JSON result or success message; stderr for confirmation prompts and errors |
| `comment view` | 2 (Read-only) | Stdout for data; stderr for hints/warnings |

### Exit codes

| Scenario | Code | Precedent |
|----------|------|-----------|
| Success | 0 | — |
| Already deleted (404 on DELETE) | 0 | Idempotency convention (assign, move) |
| Comment not found (view/edit, 404 on GET) | 64 | `JrError::UserError` |
| Confirmation required but non-interactive | 64 | `issue edit` JQL large-set, `issue move` resolution |
| Mutually exclusive flags (`--internal` + `--public`) | 2 | Clap enforcement |
| GET fail-safe blocked PUT | 64 | `JrError::UserError` |
| API error (5xx) | 1 | `JrError::ApiError` |

### Idempotency on delete

`DELETE /rest/api/3/issue/{key}/comment/{id}` returning 404 should be treated as
"already deleted" → exit 0. This is consistent with `issue assign` (already-unassigned →
exit 0) and `issue move` (already-in-target-status → exit 0). PENDING-RESEARCH: confirm
Jira returns 404 (not 403) for a previously-deleted comment requested by an authorized
user.

---

## 6. Scope Recommendation

### Minimum viable scope (P1 — this cycle)

1. CLI refactor: `CommentSubcommand` group + `add` rename (breaking change, CHANGELOG)
2. PF-017 shard: extract `handle_comment_add` to `interactions.rs`
3. API: `get_comment`, `delete_comment`, `update_comment`
4. `comment delete` handler + tests
5. `comment edit` GET-preserve-PUT + confirmation + fail-safe + tests
6. `comment view` handler + tests

### Deferred (P2)

**`comment supersede`:** The atomic post+delete+verify primitive. This is a useful
downstream scripting primitive but is strictly composite — it calls `comment add` +
`comment delete` + optionally `comment view`. It adds no new API surface and its
correctness depends on `delete` being idempotent. **Defer to a follow-up issue.**
Rationale: the failure modes on `supersede` (post succeeded, delete failed → dangling
old comment; or post succeeded, verify shows wrong visibility → ???  ) are more subtle
than a simple composition suggests. Scoping it separately lets the simpler primitives
ship first and be validated before composing.

### Story split and rough point estimate

| Story | Scope | Est. |
|-------|-------|------|
| S-577-1: CLI surface refactor | `CommentSubcommand` enum in `src/cli/mod.rs`; `add` variant preserves all existing fields; clap tests updated; CHANGELOG entry | 3 pts |
| S-577-2: PF-017 shard extraction | Extract `handle_comment_add` → `interactions.rs`; wire dispatch in `mod.rs`; all existing tests green | 2 pts |
| S-577-3: API layer | `get_comment`, `delete_comment`, `update_comment` in `issues.rs`; unit tests with wiremock | 3 pts |
| S-577-4: `comment delete` | `handle_comment_delete` in `interactions.rs`; confirmation gate; idempotent 404; tests in `tests/comment_delete.rs` | 3 pts |
| S-577-5: `comment edit` (core) | `handle_comment_edit`; GET-preserve-PUT invariant; fail-safe; BC-3.5.005/006/009; tests in `tests/comment_edit.rs` (VP-577-001/002/003) | 5 pts |
| S-577-6: `comment edit` (flags + confirmation) | `--internal`/`--public` overrides; `--public` confirmation gate; BC-3.5.007/008/011; tests (VP-577-004) | 3 pts |
| S-577-7: `comment view` | `handle_comment_view`; table + JSON output; BC-3.5.010; tests in `tests/comment_view.rs` (VP-577-007) | 2 pts |

**Total: 7 stories, ~21 points.** S-577-2 and S-577-3 can be parallelized (no
dependency between shard extraction and API layer methods).

### Route recommendation: Standard feature route (NOT quick-dev)

Disqualifiers for quick-dev:
- New BC cluster (8–10 BCs, 5–7 ECs, 5–7 VPs) — F2 spec-crystallization required
- Security-reviewer pass mandatory at F2 (visibility-control footgun)
- Breaking CLI surface change requiring BA confirmation
- Multi-story decomposition (7 stories)
- Non-trivial cross-file structural change (shard extraction + API additions)

Recommended pipeline: F1 (this doc) → BA human gate → F2 spec evolution
(`bc-3-issue-write.md §3.5` amendment + CHANGELOG entry) → F1d adversarial spec review
(given security dimension) → F3 story decomposition → F4 TDD implementation per story →
security reviewer pass on S-577-5 and S-577-6 diffs → F5/F6/F7 convergence.

---

## 7. Regression Risk and CI Topology Check

### Regression risk summary

| Risk zone | Level | Mitigation |
|-----------|-------|------------|
| Existing `comment add` path behavior | LOW | Handler logic is extracted (relocated), not changed; same API call emitted |
| `IssueCommand::Comment` clap parse tests | HIGH | 4 `cli_smoke.rs` tests reference the old flat `Comment` variant; must be updated to `comment add` form in same PR as S-577-1 |
| `tests/e2e_cli_surface_guard.rs` SURFACE table | HIGH | Must register `comment add/delete/edit/view` and remove legacy `comment` entry |
| `tests/comments.rs` (list path) | LOW | `list_comments` API unchanged; dispatch routing unchanged |
| `src/cli/issue/workflow.rs` callers | LOW | `handle_comment` caller in `mod.rs` is the only call site; it becomes a call to `interactions::handle_comment_add` |
| `src/api/jira/issues.rs` existing methods | NONE | New methods added; existing `add_comment`, `list_comments` unchanged |

### CI topology check

No CI YAML files are in scope for this feature. The CI gate pattern (`ci-gate.needs`)
is unchanged. No new CI jobs are introduced. The feature adds new test files
(`tests/comment_delete.rs`, `tests/comment_edit.rs`, `tests/comment_view.rs`) which
ride the existing `cargo test` job without any CI configuration changes.

The E2E surface guard (`tests/e2e_cli_surface_guard.rs`) is a **regression risk** (HIGH,
above): it will fail if the SURFACE table is not updated in S-577-1 in the same PR that
changes the CLI surface. This is not a CI topology change — it is a test-synchronization
obligation.

---

## 8. PENDING-RESEARCH Items

The following API-behavior claims are unverified and must be resolved before story-writing.
If the parallel research doc (`.factory/research/issue-577-comment-crud-jsdpublic-2026-07-09.md`)
exists and covers these, supersede this list with its verdicts.

| ID | Claim | Impact if wrong |
|----|-------|-----------------|
| PR-1 | `GET /rest/api/3/issue/{key}/comment/{id}?expand=properties` returns the full ADF body + `properties` array in one call | If `expand=properties` not needed on single-GET, simpler URL; if body not returned by default, may need `?expand=renderedBody` or similar |
| PR-2 | `DELETE /rest/api/3/issue/{key}/comment/{id}` returns 404 (not 403 or 400) for an already-deleted comment requested by an authorized user | Affects BC-3.5.004 idempotency behavior |
| PR-3 | Jira comment IDs are strings, not guaranteed integer | `String` vs `u64` type for `--id` flag |
| PR-4 | `PUT /rest/api/3/issue/{key}/comment/{id}` does NOT support `If-Match` / `ETag` conditional updates | Affects whether the GET-then-PUT race can be eliminated (determines whether race is documented limitation or fixable) |
| PR-5 | On non-JSM issues, `GET …/comment/{id}?expand=properties` returns an empty `properties` array `[]` (not absent key) | Affects BC-3.5.009 property-absent detection: `properties.is_empty()` vs `properties not present in JSON` — the existing `Comment` type uses `#[serde(default)]` on `properties: Vec<EntityProperty>`, so both cases deserialize to empty vec; however the PUT behavior difference matters |
| PR-6 | `PUT /rest/api/3/issue/{key}/comment/{id}` body shape mirrors `POST` (i.e., accepts `{"body": ADF, "properties": [...]}`) | If PUT has a different shape (e.g., requires `visibility` object instead of `properties` array), `update_comment` must diverge from `add_comment` shape |

---

## Open Questions for Human F1 Gate

1. **BA gate: breaking CLI change (Option A vs B).** Confirm `jr issue comment add` as
   the new canonical form + CHANGELOG entry as acceptable semver-bump scope. If Option B
   (no break) is required, the analysis reverts to additive top-level `IssueCommand`
   variants with hyphenated CLI names.

2. **BA gate: BC-3.5.008 `--public` confirmation scope.** Should the confirmation prompt
   fire ONLY when the current comment is confirmed internal (GET shows `internal:true`),
   or ALWAYS when `--public` is passed regardless of current state? The latter is safer
   but noisier; the former requires the GET to happen even on explicit `--public`.

3. **BA gate: BC-3.5.003 delete confirmation default.** Should `comment delete` ALWAYS
   require `--yes` in non-interactive mode, or should it only prompt for comments that are
   internal (per a GET check before DELETE)? Requiring a GET before DELETE doubles the
   HTTP footprint and increases latency; always requiring `--yes` is simpler and more
   predictable.

4. **Security reviewer scheduling.** Confirm that a `vsdd-factory:security-reviewer` pass
   is scheduled at F2 / pre-story, not post-F4, given the visibility-control nature.

5. **Research doc.** `.factory/research/issue-577-comment-crud-jsdpublic-2026-07-09.md`
   was not present when this analysis was written. Resolve PENDING-RESEARCH items PR-1
   through PR-6 before story-writing.

6. **PF-017 scope.** Confirm that `handle_open` extraction into `interactions.rs` is
   OUT of this feature's scope (keep it for a later maintenance sweep). Including it
   would reduce `workflow.rs` further but would also add unrelated test churn to this PR.
