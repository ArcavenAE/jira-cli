---
document_type: story
level: ops
story_id: "S-cycle5-mention-resolution-wiring"
epic_id: "ADF-MENTIONS-1"
title: "Effectful @Name/accountId mention resolution (src/cli/issue/mentions.rs) + wiring into create/edit/comment/JSM-create"
wave: 2
status: draft
intent: feature
feature_type: backend
mode: feature
scope: standard
severity: HIGH
trivial_scope: false
producer: story-writer
timestamp: "2026-09-06T00:00:00"
phase: 3
inputs:
  - ".factory/specs/prd/cross-cutting.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/architecture/decisions/ADR-0023-markdown-mention-pure-effectful-conversion-seam.md"
  - ".factory/phase-f2-spec-evolution/architecture-delta.md"
  - ".factory/phase-f2-spec-evolution/verification-delta-674.md"
  - ".factory/specs/prd/holdout-scenarios.md"
  - ".factory/cycles/cycle-005/phase-f3-stories/S-cycle5-mention-pure-conversion.md"
input-hash: "86fbb15"
traces_to: ".factory/specs/prd/cross-cutting.md"
cycle: cycle-005-adf-mentions
estimated_effort: large
estimated_days: 5
target_module: src/cli/issue/mentions.rs
subsystems: ["SS-02"]
depends_on: ["S-cycle5-mention-pure-conversion"]
blocks: []
behavioral_contracts:
  - "BC-X.7.007"
  - "BC-X.7.008"
  - "BC-X.7.009"
  - "BC-X.7.010"
  - "BC-3.3.012"
  - "BC-3.4.032"
  - "BC-3.5.013"
  - "BC-3.8.018"
  - "BC-7.2.016"  # cross-ref only, F-M-02: point 7 WIRING half (CLI flag + call-site plumbing); pure half owned by S-cycle5-mention-pure-conversion
bcs:
  - "BC-X.7.007"
  - "BC-X.7.008"
  - "BC-X.7.009"
  - "BC-X.7.010"
  - "BC-3.3.012"
  - "BC-3.4.032"
  - "BC-3.5.013"
  - "BC-3.8.018"
  - "BC-7.2.016"
verification_properties:
  - "VP-674-002"
  - "VP-674-003"
  - "VP-674-009"
  - "VP-674-010"
  - "VP-674-011"
  - "VP-674-013"
  - "VP-674-014"
  - "VP-674-015"
  - "VP-674-016"
  - "VP-674-017"
  - "VP-674-019"
  - "VP-674-020"
  - "VP-674-021"
holdout_anchors:
  - "H-NEW-MENTION-001"  # F-H-01: effectful MUST-PASS (GET-preflight+POST+GET-before-POST ordering+attrs.text) — cannot be satisfied by the pure-only Story A; anchored here instead
  - "H-NEW-MENTION-002"
  - "H-NEW-MENTION-003"
  - "H-NEW-MENTION-004"
  - "H-NEW-MENTION-005"  # F-M-03: `\@` escape CLI scenario is vacuous against Story A alone (`.expect(0)` passes trivially with no resolver) — also anchored here so the discriminating assertion (escape wins even when @jsmith WOULD resolve) is exercised
  - "H-NEW-MENTION-006"
  - "H-NEW-MENTION-008"
  - "H-NEW-MENTION-009"
  - "H-NEW-MENTION-010"
  - "H-NEW-MENTION-011"
  - "H-NEW-MENTION-012"
nfr_anchors: []
adr_refs: ["ADR-0023", "ADR-0014"]
sd_refs: []
priority: P0
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-005/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: tdd
tdd_mode: strict
module_criticality: HIGH
points: 13
acceptance_criteria_count: 17
assumption_validations: []
risk_mitigations: []
created: "2026-09-06"
version: "1.0"
last_updated: "2026-09-06"
breaking_change: false
retroactive: false
origin: >
  cycle-005 adf-mentions (GitHub #674), Wave 2 of 2, depends_on:
  [S-cycle5-mention-pure-conversion]. The effectful half of the feature: a new
  CLI-layer resolver module plus wiring into all four write-command call sites
  that can carry a mention (comment add/edit, issue create platform, issue edit,
  JSM issue create --request-type). Depends on Story A because every code path
  here calls Story A's find_mention_candidates/markdown_to_adf_with_mentions/
  markdown_to_adf_no_mentions and cannot compile, let alone be tested, without
  them. Folds in the former "Story C" (accountId preflight + attrs.text feed)
  since preflight validation is naturally part of the same resolver module and
  splitting it into a third story would only fragment one cohesive resolve()
  call path across two files with no independent shippability benefit.
---

> **tdd_mode:** `strict` — full TDD Iron Law enforced. A new effectful module
> reachable from every write-command surface in the CLI, with real notification
> side effects and hard-error semantics — not a facade/DTU candidate.

> **Execute:** `/vsdd-factory:deliver-story S-cycle5-mention-resolution-wiring`

# S-cycle5-mention-resolution-wiring — Effectful mention resolution + write-path wiring

## Anchor Justification

**Subsystem anchor:** `SS-02` (CLI Layer) owns this story's scope because the new
`src/cli/issue/mentions.rs` file is a support module alongside `helpers.rs`/
`field_resolve.rs` — a CLI-layer resolver, not a top-level command handler — per
`architecture-delta.md` §2.2 and ADR-0023 §1's explicit placement decision. The four
wiring call sites this story modifies (`create.rs`, `edit.rs`, `interactions.rs`,
`jsm_create.rs`) are all pre-existing `SS-02` files.

**Dependency anchors:** `depends_on: [S-cycle5-mention-pure-conversion]` because
`resolve_mentions` calls `adf::find_mention_candidates` (pure, Story A) to discover
candidates before any HTTP call, and every wiring call site converts the final body
via `adf::markdown_to_adf_with_mentions`/`adf::markdown_to_adf_no_mentions` (pure,
Story A) — neither function exists until Story A merges, so this story cannot
compile before Story A lands. `blocks: []` — no other cycle-005 story depends on
this one; it is the terminal node of the feature's dependency graph.

## Source of Truth

- `.factory/specs/prd/cross-cutting.md` §X.7, BC-X.7.007, BC-X.7.008, BC-X.7.009,
  BC-X.7.010 (all read in full for this story).
- `.factory/specs/prd/bc-3-issue-write.md`, BC-3.3.012, BC-3.4.032, BC-3.5.013,
  BC-3.8.018 (all read in full for this story).
- `ADR-0023-markdown-mention-pure-effectful-conversion-seam.md` §1 (the
  `resolve_mentions` shape and call-site pattern), §6 (`--no-mentions` flag shape
  and composition rules), §7 (the F2-gate human decision tightening single-result
  `@Name` resolution — `filter_by_name_match`, Option (a), the definitive mechanism).
- `architecture-delta.md` §2.2 (`src/cli/issue/mentions.rs` component definition),
  §2.3 (dependency graph — verified acyclic).
- `verification-delta-674.md` §6 (effectful resolution VPs), §7 (E2E round-trip
  acceptance VPs), §9 (mutation-testing note — `src/cli/issue/mentions.rs` MUST be
  added to `.cargo/mutants.toml` examine_globs in the SAME commit that creates it).
- `.factory/specs/prd/holdout-scenarios.md` Group 21, H-NEW-MENTION-002/003/004
  (resolution taxonomy), H-NEW-MENTION-006 (`--no-mentions` wiremock half),
  H-NEW-MENTION-008 (JSM), H-NEW-MENTION-009 (live-E2E, human-required),
  H-NEW-MENTION-010/011 (platform create/edit automated wiremock coverage),
  H-NEW-MENTION-012 (single-result name-match tightening).
- `.factory/cycles/cycle-005/phase-f3-stories/S-cycle5-mention-pure-conversion.md`
  (Story A) — the pure API this story's resolver and wiring call sites depend on.

## Narrative

As a `jr` user writing a comment, creating an issue, editing a description, or
filing a JSM request with `--markdown`, I want any `[~accountid:<id>]` or `@Name`
mention token in my text to be validated and resolved against real Jira users
before my write is sent, so that a mention I author actually notifies the right
person (or fails loudly with a clear reason instead of silently posting a dead,
non-notifying reference).

## Behavioral Contracts

| BC | Status | What this story delivers |
|----|--------|---------------------------|
| BC-X.7.007 | NEW | `@Name` unique-match resolution via `GET /rest/api/3/user/search`, per-invocation dedup, the F2-gate `filter_by_name_match` name-match tightening (a lone non-name-matching result now hard-errors) |
| BC-X.7.008 | NEW | `@Name` ambiguous-match disambiguation, reusing `disambiguate_user`'s `ExactMultiple`/`Ambiguous` contract verbatim |
| BC-X.7.009 | NEW | `@Name` zero-match HARD ERROR, exit 64 (human-approved override of the architect's pass-through recommendation), three-way `empty_msg` wording selection |
| BC-X.7.010 | NEW | Bracket-form accountId mandatory preflight validation via `GET /rest/api/3/user?accountId=`, per-invocation dedup, hard error on unknown id |
| BC-3.3.012 | NEW | `issue create --description --markdown` (platform path) mention wiring; `--no-mentions` opt-out |
| BC-3.4.032 | NEW | `issue edit --description --markdown` mention wiring at BOTH the dry-run and live PUT call sites; dry-run FORCES non-interactive resolution unconditionally |
| BC-3.5.013 | NEW | `issue comment add`/`issue comment edit --markdown` mention wiring; visibility (`--internal`/`--public`) is orthogonal to mention resolution/notification |
| BC-3.8.018 | NEW | JSM `issue create --request-type` mention wiring in `JsmRequestBuilder::build()`, resolution threaded in as pre-computed data since `build()` stays synchronous |
| BC-7.2.016 | CROSS-REF (F-M-02) | point 7's WIRING half only — the `--no-mentions` clap flag declaration (AC-014) and its plumbing into the four write-command call sites (AC-015). The pure-side bypass entrypoint (`markdown_to_adf_no_mentions`) this flag calls is `S-cycle5-mention-pure-conversion`'s (completed) scope — this story does not touch `src/adf.rs` |

## Acceptance Criteria

### AC-001 — `resolve_mentions` shape and dedup
`src/cli/issue/mentions.rs::resolve_mentions(client: &JiraClient, text: &str, no_input: bool) -> Result<MentionResolutions, JrError>`
calls `adf::find_mention_candidates` (pure), then deduplicates candidates per
unique bracket-form accountId and per unique `@Name` token BEFORE any network
call — a body mentioning `@jsmith` three times or `[~accountid:X]` three times
issues exactly ONE resolution call each, not three.
(traces to BC-X.7.007 edge case [dedup]; BC-X.7.010 point 1; VP-674-009, VP-674-013)

### AC-002 — `@Name` resolution: active filter, then `filter_by_name_match`, then `disambiguate_user`
For each unique `@Name` candidate: (1) filter `client.search_users(name)` results
to `active == Some(true)`; (2) apply the NEW pure `filter_by_name_match(active_users, query) -> Vec<User>`
reduction step (reuses `partial_match::partial_match`'s existing classification,
never a second independently-maintained name-match predicate) — keeps only users
whose `display_name` case-insensitively-substring-contains `query`; (3) pass the
reduced list to `disambiguate_user` (bumped `fn` -> `pub(super) fn`, otherwise
UNCHANGED — no new parameter, no behavior change to its three existing callers
`resolve_user`/`resolve_assignee`/`resolve_assignee_by_project`).
(traces to BC-X.7.007 postcondition/point 1,2,3; VP-674-002, VP-674-009, VP-674-021)

### AC-003 — Single-result name-match tightening (human-approved F2 decision)
A search reduced by `filter_by_name_match` to exactly ONE user resolves silently
(the true happy path). A raw search returning exactly one ACTIVE result whose
display name does NOT case-insensitively-substring-match the query is filtered to
an EMPTY list by `filter_by_name_match` and therefore hits `disambiguate_user`'s
empty-list branch — HARD ERROR, exit 64, with the wording-(iii) neutral message
(load-bearing substring `"No user found matching"`, explicitly WITHOUT the
`"deactivated"` hint, since the matched account IS active). A 2+ raw result set
that `filter_by_name_match` reduces to exactly one name-match resolves with NO
ambiguity prompt.
(traces to BC-X.7.007 postcondition [behavioral contract table]; VP-674-021)

### AC-004 — `@Name` ambiguous disambiguation reuses existing wording verbatim
Two or more name-matching active candidates surviving `filter_by_name_match`
produce `disambiguate_user`'s existing `ExactMultiple`/`Ambiguous` behavior
UNCHANGED: non-interactive (`no_input == true`) -> exit 64 + the SAME stderr
substrings `tests/duplicate_user_disambiguation.rs` already pins (`"Multiple
users named"`/`"Multiple users match"`) + zero mutation HTTP; interactive (TTY)
-> `dialoguer::Select` prompt, proceeds to a resolved mention once answered.
(traces to BC-X.7.008 postcondition 1,2,3; VP-674-003, VP-674-010)

### AC-005 — `@Name` zero-match hard error, three-way message selection
A `@Name` candidate reducing to an empty list — via any of: (i) genuinely zero
raw search results, (ii) all raw results deactivated, or (iii) at least one
active raw result but none name-matching — hard-errors exit 64 via
`disambiguate_user`'s empty-list branch, carrying the pinned substring `"No user
found matching"` in all three cases, with wording (ii) additionally carrying a
`"deactivated"` hint ONLY in case (ii) (never in case (i) or (iii)). The
resolver's call site (not `disambiguate_user`) is responsible for constructing
whichever `empty_msg` variant applies, based on a single inspection of the raw
(pre-filter) search result.
(traces to BC-X.7.009 postcondition/behavior 1,2; VP-674-010, VP-674-021)

### AC-006 — Bracket-form accountId mandatory preflight validation
Every unique bracket-form accountId `find_mention_candidates` finds is validated
via `client.get_user(account_id)` (the SAME method `jr user view` already calls)
before the body is posted. 404/400 -> `JrError::UserError`, exit 64, load-bearing
substring `"not found"`. On success, `User.display_name` populates
`MentionResolutions[<id>] = {account_id, display_name}`. A 401/403/5xx during
validation propagates via the standard `JrError` mapping, NOT re-wrapped as
"not found".
(traces to BC-X.7.010 postcondition 2,3,4; edge case [401/403/5xx]; VP-674-013)

### AC-007 — Zero-POST/PUT guarantee, all-or-nothing across the whole body
ANY resolution failure (ambiguous, zero-match, invalid bracket-form id) among
otherwise-resolvable candidates in one body fails the WHOLE write, exit 64, with
ZERO mutation HTTP call (POST/PUT) — a partially-successful resolution is never
partially applied.
(traces to BC-X.7.008 postcondition 3; BC-X.7.009 postcondition 3; BC-X.7.010
postcondition 5; VP-674-010)

### AC-008 — `issue create --description --markdown` wiring (platform, non-JSM)
`handle_create` calls `mentions::resolve_mentions(client, &text, no_input).await`
before the existing `POST /rest/api/3/issue`, then converts via
`adf::markdown_to_adf_with_mentions(&text, &resolutions)` in place of bare
`markdown_to_adf`. `--markdown` absent -> unaffected (`text_to_adf`, no mention
resolution attempted). `--no-mentions` present -> resolution skipped entirely,
converts via `adf::markdown_to_adf_no_mentions(text)`. On resolution failure,
exit 64, zero POST (mirrors BC-3.3.005's assignee-not-found precedent).
(traces to BC-3.3.012 behavior 1,2,3,4; VP-674-014, VP-674-019 part b)

### AC-009 — `issue edit --description --markdown` wiring, both call sites
BOTH the `--dry-run` preview call site (`dr_desc_adf`) and the live PUT call site
run the identical resolve-then-convert sequence. Live path: exit 64 + zero PUT on
resolution failure. Dry-run path: a resolution `Err` propagates with the SAME
urgency as today's `MAX_ADF_DEPTH` `Err` — BEFORE any per-field `println!` in the
table-mode preview sequence, preserving EC-3.4.021-15/-19/VP-692-002/-004's
"stdout EMPTY on error, in both modes" postcondition exactly.
(traces to BC-3.4.032 behavior 1,2,4; VP-674-015, VP-692-002/-004 [MUST-STAY-GREEN])

### AC-010 — `issue edit --dry-run` forces non-interactive mention resolution unconditionally
The dry-run call site passes `no_input = true` to `mentions::resolve_mentions`
UNCONDITIONALLY, regardless of the invocation's own ambient `no_input` value (TTY
or not). An ambiguous `@Name` during `--dry-run` ALWAYS takes the non-interactive
exit-64-with-candidates path and NEVER pops a `dialoguer::Select` prompt, even at
an interactive TTY without `--no-input`. The LIVE path (AC-009) is unaffected —
it continues to use the invocation's own ambient `no_input`.
(traces to BC-3.4.032 behavior 5; VP-674-020)

### AC-011 — `comment add`/`comment edit --markdown` wiring
`handle_comment_add` gains a new `no_input: bool` parameter (threaded from its
sole call site in `src/cli/issue/mod.rs`, which already has it in scope) so it
can call the resolver identically to `handle_comment_edit` (which already takes
`no_input`). Both resolve mentions before their respective `markdown_to_adf`
call. Resolution failure -> exit 64, zero POST (`comment add`) / zero PUT
(`comment edit`) — this is a NEW zero-POST guarantee for `comment add`.
(traces to BC-3.5.013 behavior 1,2; VP-674-016, VP-674-019 part b)

### AC-012 — Comment visibility is orthogonal to mention resolution
`--internal`/`--public` visibility flags have NO effect on mention resolution —
`jr` resolves and validates mentions identically regardless of visibility. A
comment's `properties: [{key:"sd.public.comment",...}]` shape is unaffected by
whether the body contains a mention (whether the notification actually reaches a
portal customer with restricted visibility is Jira's server-side decision,
documented but not validated against).
(traces to BC-3.5.013 behavior 4; VP-674-011)

### AC-013 — JSM `issue create --request-type --description --markdown` wiring
`handle_jsm_create` (async) resolves mentions via `mentions::resolve_mentions`
BEFORE constructing `JsmRequestBuilder` and calling its SYNCHRONOUS, effect-free
`.build()` — the resolution result (a `MentionResolutions` value, or an
already-converted `description_adf` value) is threaded into the builder as
plain data; `build()` itself gains no `async`/network capability. Runs AFTER the
existing BC-3.8.016/BC-3.8.017 pre-flight guards, BEFORE the POST to
`/rest/servicedeskapi/request`. On resolution failure, exit 64, zero POST.
BC-3.8.018 point 5 (the JSM visibility-orthogonality caveat, parallel to
AC-012's BC-3.5.013 behavior 4) is a documented, NOT independently
AC-validated, caveat — this AC does not assert anything about whether a
resolved mention's notification reaches a restricted-visibility JSM portal
customer, since delivery is Jira's server-side domain (H-NEW-MENTION-008 does
not assert delivery either).
(traces to BC-3.8.018 behavior 1,2,3,4; edge case [build() stays synchronous];
BC-3.8.018 point 5 [documented caveat, not AC-validated — cross-ref only];
VP-674-017, VP-674-019 part b)

### AC-014 — `--no-mentions` CLI flag: declaration, scope, composition
A boolean clap flag `--no-mentions`, declared alongside `--markdown` on
`IssueCommand::Create`, `IssueCommand::Edit`, `CommentSubcommand::Add`, and
`CommentSubcommand::Edit` (covering all four wiring call sites, including the
JSM `--request-type` fork via the shared `Create` args struct). No
`conflicts_with`/`requires` relationship to `--markdown` — `--no-mentions`
without `--markdown` is an accepted, silent no-op. When present, the call site
skips `mentions::resolve_mentions().await` entirely (saving every HTTP round
trip) and calls `adf::markdown_to_adf_no_mentions(text)` in place of
`adf::markdown_to_adf_with_mentions`.
(traces to BC-7.2.016 point 7 [wiring half]; BC-3.3.012 edge case
[--no-mentions no-op]; VP-674-019 part b)

### AC-015 — `--no-mentions` issues zero resolver HTTP calls (all four call sites)
Invoking any of the four write commands with `--no-mentions` on a body
containing BOTH a resolvable `@Name` and a bracket `[~accountid:X]` issues
EXACTLY ZERO `GET /rest/api/3/user/search` requests AND EXACTLY ZERO
`GET /rest/api/3/user?accountId=` requests. The POST/PUT body carries the
literal, unconverted mention text.
(traces to BC-3.3.012/BC-3.4.032/BC-3.5.013/BC-3.8.018 [--no-mentions
composition rules]; VP-674-019 part b; H-NEW-MENTION-006)

### AC-016 — `mentions.rs` added to mutation-testing scope in the same commit
`src/cli/issue/mentions.rs` is added to `.cargo/mutants.toml`'s `examine_globs`
in the SAME commit that creates the file (per `verification-delta-674.md` §9 —
F4 ACTION REQUIRED; `tests/mutants_glob_existence.rs` will fail if a stale glob
is ever added without a matching file, so add the real path only once the file
exists).
(traces to no BC clause directly — cross-cutting task obligation per
verification-delta-674.md §9/§11 item 3; enforced by `tests/mutants_glob_existence.rs`)

### AC-017 — Live-Jira E2E round-trip acceptance (human-required)
`JR_RUN_E2E=1`-gated tests in `tests/e2e_live.rs`, each self-cleaning per the
existing `Drop`-guard/`jsm_self_close` conventions and using a CONTROLLED test
account (never a real person), assert: (a) `comment add` — PRIMARY scenario —
posting a mention via `jr issue comment add`, fetched back via
`GET /rest/api/3/issue/{key}/comment/{id}`, contains a `mention` node with the
resolved accountId; (b) `issue create` (platform) — same assertion via
`GET /rest/api/3/issue/{key}`; (c) `issue edit` — same assertion on a throwaway
issue; (d) JSM `issue create --request-type` — same assertion on
`requestFieldValues.description`, self-closing via `jsm_self_close` (gated
additionally by `JR_E2E_JSM_PROJECT`). Each test clean-skips (early return) when
its required env is unset. `jr --help`'s new `--no-mentions` surface is
registered in `tests/e2e_cli_surface_guard.rs`'s SURFACE table in the same
commit.
(traces to BC-3.3.012/BC-3.4.032/BC-3.5.013/BC-3.8.018 [E2E acceptance
sections]; VP-674-014, VP-674-015, VP-674-016, VP-674-017; H-NEW-MENTION-009)

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|---------------|
| `resolve_mentions` | `src/cli/issue/mentions.rs` (NEW) | Effectful Shell (network I/O — `GET /user/search`, `GET /user?accountId=`) |
| `filter_by_name_match` | `src/cli/issue/mentions.rs` (NEW) | Pure (in-memory reduction over already-fetched data; not part of `adf.rs`'s pure core, but zero I/O) |
| `disambiguate_user` | `src/cli/issue/helpers.rs` (MODIFIED — visibility only, `fn` -> `pub(super) fn`) | Effectful Shell (unchanged behavior) |
| `handle_create` (mention wiring) | `src/cli/issue/create.rs` (MODIFIED) | Effectful Shell |
| `handle_edit` (mention wiring, both call sites) | `src/cli/issue/edit.rs` (MODIFIED) | Effectful Shell |
| `handle_comment_add`, `handle_comment_edit` (mention wiring) | `src/cli/issue/interactions.rs` (MODIFIED) | Effectful Shell |
| `handle_jsm_create` (mention wiring) | `src/cli/issue/jsm_create.rs` (MODIFIED) | Effectful Shell |
| `JsmRequestBuilder::build` (resolution threaded in as data) | `src/api/jsm/requests.rs` (MODIFIED — signature/field addition only, stays synchronous) | Pure (assembles JSON from already-resolved data; no I/O) |
| `--no-mentions` flag declarations | `src/cli/mod.rs` (MODIFIED) | N/A (clap derive) |

## UX Screens

N/A — CLI-only, no UI surface.

## Design System Components

N/A — not a UI story.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-X.7.007-1 | Same `@jsmith` mentioned 3x in one body | Exactly ONE `/user/search` call (dedup) |
| EC-X.7.007-2 | Case-insensitive exact match (`MatchResult::Exact`) | Reached only when 2+ name-matching active results survive `filter_by_name_match`; a lone surviving result short-circuits before `partial_match` runs at all, and is now guaranteed to already be a name match |
| EC-X.7.007-3 / EC-X.7.009-4 | Deactivated-only match | Empty-list branch (not `MatchResult::None`), hard error with the deactivated-hint wording |
| EC-X.7.007-4 | Bot/app account (`userType: "app"`) matches `@Name` | Resolves and is mentioned like a human user — deliberate, not filtered |
| EC-X.7.007-5 | Fuzzy single-hit that does NOT name-match | Hard error via the empty-list branch, neutral wording (no "deactivated" hint) — H-NEW-MENTION-012 |
| EC-X.7.008-1 | Ambiguous `@Name` resolution error | Surfaces BEFORE any HTTP mutation |
| EC-X.7.008-2 | Ambiguous `@Name` disambiguation wording | Reuses BC-X.7.004's exact stderr substrings verbatim — no new message strings introduced for the mention call site |
| EC-X.7.009-1/-2/-3 | Java annotation (`@Override`), npm scope (`@angular`), Slack broadcast (`@channel`/`@here`) in prose | Hard-fail exit 64 unless a Jira user happens to match — documented, accepted consequence of the human-approved policy |
| EC-X.7.010-1 | Malformed-but-charset-valid, stale, or typo'd accountId | All collapse to the same "unknown id" 404 hard error |
| EC-X.7.010-2 | Two distinct bracket-form ids in one body | TWO `get_user` calls, both must succeed (all-or-nothing) |
| EC-X.7.010-3 | HTTP failure during validation (401/403/5xx, not 404/400) | Propagates via the standard `JrError` mapping (auth/API hint), NOT re-wrapped as a mention-specific "not found" error — AC-006 |
| EC-3.3.012-1 | No mention tokens present (`issue create`) | `find_mention_candidates` returns an empty candidate set, zero resolution HTTP calls, output byte-for-byte identical to pre-#674 `markdown_to_adf` — AC-001, AC-008 |
| EC-3.3.012-2 | `--no-mentions` with no `--markdown` (`issue create`) | Accepted silently as a no-op — mentions were never going to be detected on the `text_to_adf` path anyway — AC-014 |
| EC-3.3.012-3 / analogous | Mixed resolvable + unresolvable candidates in one body | WHOLE write fails, zero POST — the resolvable candidate's success is discarded, not partially applied |
| EC-3.4.032-1 | Dry-run preview shows the raw ADF tree, not `adf_to_text` | A mention node appears as `{"type":"mention","attrs":{...}}` in `plannedChanges.descriptionAdf`, never rendered `@Name` text |
| EC-3.4.032-2 | No mention tokens present (`issue edit`, both call sites) | Byte-for-byte identical to pre-#674 behavior at both call sites (same as EC-3.3.012-1) — AC-001, AC-009 |
| EC-3.4.032-3 | Bulk multi-key `--description` is not a thing | `--description` is inherently single-value per invocation (one description string applied to every resolved key identically); mention resolution therefore runs ONCE per invocation, never once per key — AC-009 |
| EC-3.5.013-1 | `handle_comment_add`'s new `no_input` parameter | Exactly ONE call site to update (`src/cli/issue/mod.rs`) |
| EC-3.5.013-2 | No mention tokens present (`comment add`/`comment edit`) | Byte-for-byte identical to pre-#674 behavior (same as EC-3.3.012-1/EC-3.4.032-2) — AC-001, AC-011 |
| EC-3.5.013-3 | JSM internal comment mentions a portal customer with no internal-comment visibility | Comment posts successfully; delivery/notification is Jira's domain, not a `jr` error |
| EC-3.8.018-1 | `JsmRequestBuilder::build()` | Remains synchronous and effect-free — resolution completes (or is skipped) before `build()` runs |
| EC-3.8.018-2 | No mention tokens present (JSM `issue create --request-type`) | Byte-for-byte identical to pre-#674 behavior (same as the platform-path analogues) — AC-001, AC-013 |
| EC-3.8.018-3 | BC-3.8.017's `--field description=` conflict guard | Fires BEFORE any mention-resolution attempt — deterministic ordering, no race |

**Correction (F3 adversarial pass-4, MED — DEFINITIVE EC-mirror reconciliation):**
this table previously omitted 7 effectful-side edge cases that
`dependency-graph-extended.md` §7 already cited as being present here —
EC-X.7.010-3, EC-3.3.012-1, EC-3.3.012-2, EC-3.4.032-2, EC-3.4.032-3,
EC-3.5.013-2, EC-3.8.018-2 — making §7's "Edge Cases table" citation for those
BCs false as written, even though the underlying behavior was always
AC-covered (the omitted rows are mostly degenerate "no tokens" cases —
candidates empty, nothing resolves, covered by the same wiring ACs that cover
the non-degenerate path). All 7 are now added above, each with its covering AC
cited inline. With this addition, every EC that `dependency-graph-extended.md`
§7 cites against this story's Edge Cases table is now genuinely present in it
— see that file's own §7 per-BC three-surface reconciliation table for the
full verification.

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|---------------|
| `src/cli/issue/mentions.rs::resolve_mentions` | Effectful Shell | Network I/O (`search_users`, `get_user`) |
| `src/cli/issue/mentions.rs::filter_by_name_match` | Pure (non-`adf.rs` core) | In-memory reduction, zero I/O, but not part of the formally-hardened `adf.rs` pure core — a plain sync helper like most of `helpers.rs` |
| `src/cli/issue/create.rs`, `edit.rs`, `interactions.rs`, `jsm_create.rs` (post-change) | Effectful Shell (unchanged classification) | Already effectful; gain one more `.await` each |
| `src/api/jsm/requests.rs::JsmRequestBuilder::build` (post-change) | Pure (unchanged classification) | Assembles JSON from already-resolved data; resolution happens in the async caller before `.build()` runs |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|---------------|-----------------|
| This story spec | ~5,200 |
| BC-X.7.007/008/009/010 (full, `cross-cutting.md`) | ~7,500 |
| BC-3.3.012/3.4.032/3.5.013/3.8.018 (full, `bc-3-issue-write.md`) | ~6,500 |
| ADR-0023 §1,6,7 (relevant sections) | ~5,000 |
| `src/cli/issue/helpers.rs::disambiguate_user` + 3 existing callers (read for reuse) | ~3,000 |
| `src/cli/issue/create.rs`/`edit.rs`/`interactions.rs`/`jsm_create.rs` (existing call sites, read for wiring) | ~6,000 |
| `src/api/jira/users.rs` (existing `search_users`/`get_user`, reused as-is) | ~1,500 |
| New `src/cli/issue/mentions.rs` (to be written, est. ~250-350 LOC) | ~3,500 |
| wiremock integration test suites (est. ~700-900 LOC) | ~8,000 |
| `tests/e2e_live.rs` E2E additions | ~3,000 |
| **Total** | **~49,200** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~25%** |

At the upper edge of the 20-30% target band, driven by the four wiring call sites'
existing-code read requirement. If F4 discovery finds any one call site
substantially larger than estimated, consider a same-story task-level split (e.g.
land the resolver + two call sites first, the remaining two + E2E in a same-PR
follow-up commit) rather than a story split, since all four share one resolver
and one dependency edge.

## Tasks

1. [ ] Read `src/cli/issue/helpers.rs::disambiguate_user` and its three existing
   callers (`resolve_user`, `resolve_assignee`, `resolve_assignee_by_project`) in
   full before writing any test — this story reuses the function verbatim.
2. [ ] Read `src/cli/issue/create.rs::handle_create`, `edit.rs::handle_edit`
   (both `markdown_to_adf` call sites), `interactions.rs::handle_comment_add`/
   `handle_comment_edit`, and `jsm_create.rs::handle_jsm_create` +
   `src/api/jsm/requests.rs::JsmRequestBuilder::build` in full — confirm the
   exact insertion points named in the BC bodies before touching any of them.
3. [ ] Write failing tests for `resolve_mentions`'s dedup contract (AC-001,
   VP-674-009/013) — wiremock, asserting exact-once call counts.
4. [ ] Implement `src/cli/issue/mentions.rs::resolve_mentions` skeleton (dedup +
   candidate collection via `adf::find_mention_candidates`).
5. [ ] Write failing tests for the `@Name` resolution taxonomy: unique-match
   (AC-002/003), ambiguous (AC-004), zero-match three-way messaging (AC-005) —
   wiremock fixtures per H-NEW-MENTION-002/003/004/012.
6. [ ] Implement `filter_by_name_match` and bump `disambiguate_user` to
   `pub(super)`; wire the active-filter -> `filter_by_name_match` -> resolver
   call-order pipeline.
7. [ ] Write failing tests for bracket-form accountId preflight validation
   (AC-006) — wiremock, per H-NEW-MENTION-001.
8. [ ] Implement bracket-form validation via `client.get_user`, populating
   `MentionResolutions`.
9. [ ] Write failing tests asserting the zero-POST/PUT all-or-nothing guarantee
   across mixed resolvable/unresolvable candidates (AC-007) — per
   H-NEW-MENTION-010/011.
10. [ ] Wire `create.rs::handle_create` (AC-008, VP-674-014).
11. [ ] Wire `edit.rs::handle_edit`'s live PUT call site (AC-009 live half,
    VP-674-015).
12. [ ] Wire `edit.rs::handle_edit`'s dry-run call site with the FORCED
    `no_input = true` override (AC-009 dry-run half, AC-010, VP-674-020) —
    write the `JR_STDIN_IS_TTY=1` + `--dry-run` + ambiguous-`@Name` regression
    test FIRST (RED) to pin the forced-non-interactive behavior before wiring.
13. [ ] Add `handle_comment_add`'s new `no_input: bool` parameter (its sole
    call site already has it in scope); wire `comment add`/`comment edit`
    (AC-011, AC-012, VP-674-016, VP-674-011).
14. [ ] Wire `jsm_create.rs::handle_jsm_create` + thread resolution data into
    `JsmRequestBuilder` without making `.build()` async (AC-013, VP-674-017).
15. [ ] Declare the `--no-mentions` clap flag on `IssueCommand::Create`,
    `IssueCommand::Edit`, `CommentSubcommand::Add`, `CommentSubcommand::Edit` in
    `src/cli/mod.rs` (AC-014).
16. [ ] Write failing tests for the `--no-mentions` zero-resolver-HTTP-calls
    observable at all four call sites (AC-015, VP-674-019 part b) — per
    H-NEW-MENTION-006.
17. [ ] Wire `--no-mentions` to skip `resolve_mentions().await` and call
    `adf::markdown_to_adf_no_mentions` at all four call sites.
18. [ ] Add `src/cli/issue/mentions.rs` to `.cargo/mutants.toml`'s
    `examine_globs` IN THE SAME COMMIT that creates the file (AC-016) — verify
    `tests/mutants_glob_existence.rs` passes.
19. [ ] Write the four `JR_RUN_E2E`-gated `tests/e2e_live.rs` scenarios
    (comment add PRIMARY, issue create, issue edit, JSM create), each
    self-cleaning via the existing `Drop`-guard/`jsm_self_close` conventions and
    early-returning when required env is unset (AC-017, VP-674-014/015/016/017).
20. [ ] Register the new `--no-mentions` surface in
    `tests/e2e_cli_surface_guard.rs`'s SURFACE table (AC-017).
21. [ ] Verify purity boundaries against the table above.
22. [ ] Update STATE.md (state-manager, not this story's implementer).
23. [ ] Verify Red Gate (all new tests fail before implementation).
24. [ ] Refactor.
25. [ ] Add a CHANGELOG entry under `[Unreleased] > Added` describing the new
    mention resolution + write-path wiring (closes #674), before creating the
    PR.

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|--------------|---------------------|-------------------|
| `S-cycle5-mention-pure-conversion` | `find_mention_candidates`/`markdown_to_adf_with_mentions`/`markdown_to_adf_no_mentions` are the ONLY entrypoints this story may call into `adf.rs` for mention handling — never re-implement candidate detection here | `MentionResolutions` is keyed separately per form (bracket accountId vs. POST-TRIM `@`-prefixed `@Name` span) — this story's resolver MUST write into whichever key space matches the candidate's form, never conflate them | The `@Name` candidate reported by `find_mention_candidates` is ALREADY trailing-punctuation-trimmed — do not re-trim or re-derive the search query from a raw, untrimmed span; use the reported candidate token verbatim as both the search query and the `MentionResolutions` key |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|-----------|
| `resolve_mentions` uses the UNSCOPED `GET /rest/api/3/user/search`, never `search_assignable_users_by_project`/`multiProjectSearch` | BC-X.7.007 Source note; `artifact-mapping.md` §1.2 | AC-002/VP-674-009's wiremock test mounts only the unscoped endpoint; a wrong-endpoint implementation 404s |
| `disambiguate_user`'s three existing callers (`resolve_user`/`resolve_assignee`/`resolve_assignee_by_project`) are UNTOUCHED — no new parameter, no behavior change | ADR-0023 §7 "Why NOT option (b)" | Code review; existing `tests/duplicate_user_disambiguation.rs` suite must stay green byte-for-byte |
| `filter_by_name_match` reuses `partial_match::partial_match`'s existing classification — never a second, independently-maintained name-match predicate | ADR-0023 §7 | Code review of the `filter_by_name_match` implementation |
| `JsmRequestBuilder::build()` stays synchronous and effect-free | BC-3.8.018 edge case [EC-3.8.018-1]; existing builder doc comment | Code review — no `async`, no `Client` parameter added to `build()`'s signature |
| The mention resolver's `empty_msg`/`none_msg_fn` strings are its OWN, distinct from `resolve_user`'s `"No active user found matching..."` wording | BC-X.7.009 point 2 [Wording-source clarification] | AC-005's test asserts the load-bearing substring `"No user found matching"` (no `"active"`) |
| `--no-mentions` has no `conflicts_with`/`requires` relationship to `--markdown` | ADR-0023 §6 | AC-014's clap flag declaration; a `--no-mentions`-without-`--markdown` regression test |
| `mentions.rs` is added to `.cargo/mutants.toml` examine_globs in the SAME commit that creates it | verification-delta-674.md §9/§11 item 3 | Task 18; `tests/mutants_glob_existence.rs` |
| Zero-warnings policy | CLAUDE.md | `cargo clippy -- -D warnings` |

## Library & Framework Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| `wiremock` (existing dev-dependency) | existing pinned version | Effectful resolution integration tests (VP-674-003/009/010/011/013/019b/020/021) |
| `dialoguer` (existing) | existing pinned version | Interactive `@Name` disambiguation prompt (reused, unchanged) |
| `reqwest`/`JiraClient` (existing) | existing pinned version | `search_users`/`get_user` calls (reused as-is) |

No new external dependency is introduced by this story.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/cli/issue/mentions.rs` | CREATE | `resolve_mentions`, `filter_by_name_match` |
| `src/cli/issue/mod.rs` | MODIFY | Module declaration + re-export for `mentions` (per the existing `helpers.rs`/`field_resolve.rs` pattern) |
| `src/cli/issue/helpers.rs` | MODIFY | `disambiguate_user` visibility bump, `fn` -> `pub(super) fn` (mechanical, zero behavior change) |
| `src/cli/issue/create.rs` | MODIFY | `handle_create` mention-resolution wiring |
| `src/cli/issue/edit.rs` | MODIFY | `handle_edit`'s dry-run and live `markdown_to_adf` call sites, both wired |
| `src/cli/issue/interactions.rs` | MODIFY | `handle_comment_add` (new `no_input` parameter) and `handle_comment_edit` wiring |
| `src/cli/issue/jsm_create.rs` | MODIFY | `handle_jsm_create` mention-resolution wiring |
| `src/api/jsm/requests.rs` | MODIFY | `JsmRequestBuilder` gains a field to carry pre-resolved mention data into `.build()` |
| `src/cli/mod.rs` | MODIFY | `--no-mentions` clap flag on `IssueCommand::Create`/`Edit`, `CommentSubcommand::Add`/`Edit` |
| `.cargo/mutants.toml` | MODIFY | Add `src/cli/issue/mentions.rs` to `examine_globs` (Task 18) |
| `tests/mention_resolution.rs` (NEW, suggested name per `artifact-mapping.md` §3) | CREATE | wiremock integration tests for `resolve_mentions`/`filter_by_name_match` |
| `tests/e2e_live.rs` | MODIFY | Four new `JR_RUN_E2E`-gated round-trip scenarios (Task 19) |
| `tests/e2e_cli_surface_guard.rs` | MODIFY | Register `--no-mentions` in the SURFACE table (Task 20) |
| `docs/specs/e2e-live-jira-testing.md` | MODIFY (if a new `JR_E2E_MENTION_ACCOUNT_ID` seam is added) | Env-var table row, per the "grep CLAUDE.md for `JR_*` and document in the same commit" convention — OPTIONAL, only if F4 needs a dedicated controlled mention target distinct from the existing `JR_E2E_*` account |
| `CHANGELOG.md` | MODIFY | `[Unreleased] > Added` entry per Task 25 |

**Files NOT to touch:** `src/adf.rs` (Story A's completed scope — this story only
CALLS its public API, never modifies it), `src/api/jira/users.rs` (reused as-is,
no changes needed to `search_users`/`get_user`).

## Out of Scope

- Any change to `src/adf.rs`'s pure conversion functions — entirely
  `S-cycle5-mention-pure-conversion`'s (completed) scope.
- The `\@` escape mechanism's implementation — Story A's scope; this story only
  benefits from it existing (an escaped `\@Name` never reaches
  `find_mention_candidates` as a candidate, so this story's resolver never sees
  it).
- The mark-composition empirical schema check (VP-674-005) — Story A's scope.
- Any new `--include-bots`-style opt-in/opt-out flag for bot/app accounts
  (EC-X.7.007-4) — explicitly deferred to a future, separately-specified BC if
  ever needed.
- Validating whether a resolved mention's notification actually reaches a
  restricted-visibility portal customer — documented, not validated against
  (BC-3.5.013/BC-3.8.018's visibility-orthogonality notes).

## Dependency Analysis

**depends_on: [S-cycle5-mention-pure-conversion]** — Wave 2, cannot compile until
Story A's pure API (`find_mention_candidates`, `markdown_to_adf_with_mentions`,
`markdown_to_adf_no_mentions`, `MentionResolutions`) exists.

**blocks: []** — terminal node; no other cycle-005 story depends on this one.

## Story Points and Effort

**13 story points** (large). Breakdown:
- `resolve_mentions` core + dedup + `filter_by_name_match` + `disambiguate_user`
  visibility bump: 3 SP
- `@Name` resolution taxonomy (unique/ambiguous/zero-match/tightened
  single-result) + bracket-form preflight validation: 3 SP
- Four wiring call sites (create, edit x2 incl. dry-run-forced-non-interactive,
  comment add/edit, JSM create) + `--no-mentions` flag + zero-resolver-call
  observable: 4 SP
- Live-Jira E2E round-trip acceptance (4 scenarios) + CLI surface guard
  registration + mutants.toml task: 3 SP

Risk: HIGH (module criticality HIGH — a new effectful module reachable from every
write-command surface, with real, irreversible notification side effects and a
hard-error policy that deliberately diverges from the architect's own risk
analysis for zero-match `@Name`). The four-call-site wiring breadth (not any
single site's complexity) is this story's main integration risk — F4 should
budget for cross-call-site regression testing, not just per-site unit coverage.
