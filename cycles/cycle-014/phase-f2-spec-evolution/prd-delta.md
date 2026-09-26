---
document_type: prd-delta
cycle: cycle-014
feature_slug: issue-triage-quickfixes
feature_type: backend
intent: bug-fix
scope: standard
severity: LOW
issue_refs: ["#862", "#861", "#583"]
created: 2026-09-24
status: draft
---

# PRD Delta: issue-triage-quickfixes (cycle-014)

## Source

- F1 delta analysis: `.factory/cycles/cycle-014/phase-f1-delta-analysis/delta-analysis.md`
  ("Approve, as corrected", D-379; scope minted D-378)
- Cycle manifest: `.factory/cycles/cycle-014/cycle-manifest.md`
- External grounding: `.factory/research/github-issues-triage-grounding-2026-09-24.md`
  (§#583 gh api/HTTPie/curl prior art; §#861 `allowedValues` shapes by field type, first-party
  Atlassian API doc citations; §#862 clap global/local shadow semantics)
- Fixes GitHub issues #862, #861 (READ-SIDE ONLY per D-378), #583 (full).
- Verification rationale: `.factory/cycles/cycle-014/phase-f2-spec-evolution/verification-delta.md`
  (owned by formal-verifier; authoritative for VP proof-strategy design and ID-collision audit).

Scope confirmed at the F1 human gate: exactly three items, no others. The #861 write-side item
(`find_option_match`/`resolve_option_value` name-fallback in `src/cli/issue/field_resolve.rs`)
was REMOVED from scope after a fresh-context audit refuted its reachability — see Item 2 below
and the drift item `FIELD-SYSTEM-TYPES-UNSUPPORTED`.

---

## Summary of the final delta

The authoritative BC text lives in `.factory/specs/prd/cross-cutting.md`; this section
summarizes the final state (post-revision) per item, not the revision history — see
"F2 revision history" below for how it was reached.

### Item 1 — BC-X.7.002 AMENDED (issue #862): `jr user list` `--project` resolution order

**Root cause**, verified directly against `src/cli/mod.rs::UserCommand::List.project`,
`src/cli/user.rs::handle_list`, and the `clap_builder` parser source:
`UserCommand::List.project` was the only subcommand-local `--project` field in the entire CLI
surface typed `String` (clap-REQUIRED) rather than `Option<String>`. Because clap's own
required-argument validation runs BEFORE its global-value propagation step
(`fill_in_global_values`), that typing alone was sufficient to reject `jr --project FOO user
list` with clap's own missing-required-argument message (exit 2) — the propagation mechanism
never got a chance to run. `handle_list` also had no `Config`-default fallback. `src/main.rs`'s
`Command::User` dispatch arm not threading `&Config`/`cli.project` through was a separate,
pre-existing gap relative to every other project-bearing dispatch arm — verified directly
against `src/main.rs`: `Project`, `Issue`, `Board`, `Sprint`, `Queue`, `RequestType`, `Field`,
and `Component` each pass `cli.project.as_deref()` as an explicit parameter (`Worklog`, `Team`,
`User`, `Api`, `Assets`, `Me`, among others, do not) — optional/redundant for the
local-vs-global half of the fix once the field becomes `Option<String>` (clap's own propagation
handles that half with zero `jr`-level code), but still needed for the config-default fallback
half.

**Final BC shape**: H1 and body extended with a four-step resolution order — local `--project` →
global `--project` (clap propagation) → `Config::project_key`'s configured `.jr.toml`/profile
default → exit 64 `JrError::UserError` naming `--project`, before any HTTP call.
`cli::user::handle`/`handle_list` gain a `&Config` parameter threaded from `src/main.rs`'s
already-loaded `config` binding (MUST NOT reload config, or `--profile`/`JR_PROFILE` would be
silently ignored). A new pure resolver, `resolve_user_list_project(cli_project: Option<&str>,
config: &Config) -> Option<String>`, wraps `Config::project_key` for the config-fallback half
only. Precedent for local-over-global: `src/cli/component.rs::handle`'s List/Create arms
(explicit `project.as_deref().or(project_flag)` / `project.or_else(...)` code) and its
Edit/Delete arms (clap propagation only, no explicit merge) — NOT BC-8.1.004, which covers only
the no-project-configured exit-64 condition. New Edge Cases — see BC-X.7.002 Edge Cases in
`cross-cutting.md` — including a non-default `--profile`'s own configured default (with the
caveat that an ancestor `.jr.toml` project still wins ahead of any profile default per
`Config::project_key`'s own fallback order) and an explicit `--project ""` empty-string
pass-through that resolves to the empty string without consulting the configured default
(EC-X.7.002-6).
Postcondition 5: every request carries `projectKeys=<resolved-key>` — exactly one on the default
path (BC-X.7.003), one-or-more offset pages with `--all`. New VP-USER-LIST-PROJECT-001
(2^3 presence-space coverage; the local-vs-global half is pinned as clap propagation via a
`Cli::try_parse_from` unit test, the config-fallback half via a proptest on the pure resolver).
COUNT-NEUTRAL.

**Source anchors** (BC-X.7.002's Source field, `cross-cutting.md`): `tests/all_flag_behavior.rs`;
`tests/user_commands.rs::user_list_requires_project_flag`; `src/cli/mod.rs::
UserCommand::List.project` (type change `String` → `Option<String>`); `src/cli/user.rs::
{handle,handle_list,resolve_user_list_project}`; `src/main.rs`'s `Command::User` dispatch arm
(`&Config` threading); `src/config.rs::Config::project_key` (reused, unmodified). All
`src/`-side changes are marked "to be modified/implemented, cycle-014" — no code has landed yet;
this is a spec-only delta.

**Canonical error string** (F4 MUST implement verbatim, reusing `queue.rs`/`requesttype.rs`'s
existing wording byte-for-byte):

```
No project configured. Run "jr init" or pass --project. Run "jr project list" to see available projects.
```

**BC-INDEX.md**: BC-X.7.002's title row mirrors the extended H1 verbatim; the Source cell (row
~818) reads: `tests/all_flag_behavior.rs:~260-`; `tests/user_commands.rs::
user_list_requires_project_flag` (isolation to be added, no rename); `src/cli/mod.rs::
UserCommand::List.project` (type change `String` → `Option<String>`, to be modified cycle-014);
`src/cli/user.rs::{handle,handle_list,resolve_user_list_project}` (`&Config` threading + new pure
resolver, to be implemented cycle-014); `src/main.rs`'s `Command::User` dispatch arm (`&Config`
threading only, to be modified cycle-014); `src/config.rs::Config::project_key` (reused,
unmodified).

### Item 2 — BC-X.14.001/BC-X.14.003 AMENDED (issue #861, READ-SIDE ONLY): M1/M2 label-resolution fallback

**Root cause**: `normalize_from_allowed_values_at_depth` (`src/cli/field.rs`) mapped
`label: v.value.clone()` only. System-typed fields — `priority`, `resolution` (when present on
the Create/Edit screen), `versions`/`fixVersions`, `components`, `security`, `issuetype` — return
`allowedValues[]`
entries carrying `name`, not `value`, as their display label (externally grounded against
first-party Atlassian API docs, HIGH confidence:
`.factory/research/github-issues-triage-grounding-2026-09-24.md` §#861). A normalizer reading
`value` alone therefore rendered these labels as BC-X.14.003's degenerate placeholder
(`"(unnamed)"` table / `null` JSON) even though the entries were well-formed on the wire. M3
(`normalize_from_valid_values`, JSM requesttype-fields) already reads `.value` for id and
`.label` for display — already correct, confirmed unaffected.

**Scope narrowing at the F1 human gate (D-378)**: the originally-proposed WRITE-side companion
fix (`src/cli/issue/field_resolve.rs::find_option_match`/`resolve_option_value` falling back to
`av.name`) was REMOVED from scope after a fresh-context audit REFUTED its reachability:
`dispatch_field_value` routes to option-matching logic only when `meta_field.schema.field_type`
is `"option"` (or `"option-with-child"`), and real Jira system fields report `schema.type`
`priority`/`resolution`/`issuetype`/`securitylevel` — none of which is `"option"` — so `jr issue
edit ISSUE-1 --field Priority=High` fails earlier via `unsupported_field_type_error` and never
reaches `find_option_match` at all. Corroborated by
`tests/issue_edit_field.rs::test_bc_3_4_017_field_priority_without_flag_does_not_trigger_gate_b`
(mocks priority as a custom `"string"` field specifically because a genuine `"priority"`-typed
field never reaches that code path). The genuinely separate capability gap this surfaced — the
bare, un-hinted `--field NAME=VALUE` form cannot set system-typed fields; the `:id`/`:name`
hinted-bypass composers (BC-3.4.028/029) already can — is tracked as drift item
`FIELD-SYSTEM-TYPES-UNSUPPORTED` (LOW), not folded into this amendment.

**Final BC shape**: **BC-X.14.001** — the "M1/M2's display text is the field named `value`"
parenthetical corrected to state the `value`-else-`name` fallback (presence-based: a populated
`value: Some("")` still wins over a populated `name`, per the M1/M2 label-resolution fallback
paragraph). New "Scope boundary — READ-SIDE ONLY" paragraph documenting the write-side
reachability refutation above; new "M3 is UNCHANGED and was ALREADY CORRECT" paragraph. New Edge
Cases covering the `value`-else-`name` fallback and its boundary conditions — see BC-X.14.001's
own Edge Cases section in `cross-cutting.md` for the authoritative, current EC-numbered list
(a range enumerated here would go stale after every F2 remediation pass). New VP-580-013
(renumbered from a colliding
"VP-580-011" mint at F2 Step 4 — the pre-existing BC-X.14.002 already owns VP-580-011; an example
matrix at the top level and one cascading-child level, including explicit-null and empty-string
cells, a recursive proptest over `AllowedValue`, and an M3 regression against a hand-written
expected value proving the change is M1/M2-only). BC-X.14.001's H1 itself is NOT changed by this
cycle — only the body edits above. The BC-INDEX.md title row for BC-X.14.001 already mirrors the
(unchanged) H1 verbatim, per the pre-existing header note from the 2026-08-26 correction
(flagged there for the state-manager's next reconciliation pass, unaffected by this cycle).

**BC-X.14.003** — new UPDATED blockquote clarifying that the RENDERING contract
(`NULL_GLYPH`/`"(unnamed)"`/`null` for `None`) is unchanged; only the UPSTREAM normalizer now
produces fewer `None` labels for system fields (now including `fixVersions` in the enumerated
system-field list). COUNT-NEUTRAL, no VP change (VP-580-008 stands as-is).

**`src/types/jira/editmeta.rs` stale doc comments** (spec-only flag, no `src/` edit made in this
F2 delta): BOTH comments are stale and MUST be corrected at F4 to describe this new read-side
consumer — (1) the `AllowedValue` struct-level doc comment (`~L64-77`: "`name` is parsed but
unused in v1 — retained for future cascade-select matching"), and (2) the `name` field-level doc
comment (`~L83-85`: "Secondary label present on some Jira option types... unused in v1
resolution logic. Future: v2 cascade-select name matching.").

**`field options --output json` label shape**: per the F1 human gate's Open Question 3
(RESOLVED: accepted without change), a system field's JSON `label` key changing from `null` to a
real string is a bug fix, not a breaking change. No JSON-shape BC amendment needed beyond what
BC-X.14.001/003 already specify.

**Spec-accuracy correction (PASS-6, unrelated to #861's own fix):** BC-X.14.001's Behavior and
Invariant 4 wrongly described `<field>` NAME resolution (the step upstream of the label fallback
above) as going through `partial_match`/BC-X.10.001. Verified against `src/cli/field.rs` and
`test_bc_x_14_001_search_field_list_*`: it actually goes through `search_field_list`, a distinct
algorithm (single exact match auto-resolves; multiple exact → exit 64; else single substring
auto-resolves; multiple substring → exit 64). This is a pre-existing spec/code drift, not
introduced by #861, surfaced by EC-X.14.001-14 (PASS-5). Corrected in place, marked "(corrected
cycle-014: aligns with existing code and tests; no behavior change)" — no BC/VP count change.
Invariant 3 corrected: `src/cli/field.rs`'s customfield bypass and cache-first name resolution is
a mirrored copy of `src/cli/issue/field_resolve.rs::resolve_edit_fields`'s Step 1 / nested
`search_field`, not a shared function — they share only
`read_fields_cache`/`write_fields_cache`/`list_fields`, and a change to one must be mirrored in
the other. Aligns spec with existing code; no behavior change.

**Label convention:** pre-existing body prose that was incomplete/inaccurate is tagged "corrected
cycle-014"; entries newly added this cycle (EC-X.14.001-15, the BC-X.14.004 row) are tagged
"added cycle-014".

**Subsection-intro rewording (PASS-15, orchestrator decision):** the `## BC-X.14: Field Option
Discovery` subsection intro in `cross-cutting.md` — "enumerates a custom select field's allowed
options" — becomes "enumerates a field's allowed options (custom select fields and system fields
such as priority/components/versions, whose labels resolve correctly since cycle-014 #861)" (the
duplicated trailing "(cycle-014, #861)" citation from the PASS-15 wording was dropped at PASS-16
— see PASS-16 below). Noted here rather than under BC-X.14.001/BC-X.14.003 above because it edits
the `## BC-X.14` subsection intro paragraph itself, not either BC's own body — no BC/VP count
change.

### Item 3 — BC-X.16.001/BC-X.16.002 NEW (issue #583): `jr api --query-param`

**Design defaults** (human-approved at the F1 gate, all four confirmed): (a) merge with an
existing `?` query already present in the path (append with `&`); (b) repeated same-name params
are all sent, in the given order; (c) percent-encode raw NAME and VALUE exactly once — a literal
`%` encodes to `%25`, never double-decoded or passed through; (d) method-orthogonal — applies to
GET/POST/PUT/PATCH/DELETE identically, never moves `-d` body content into the query.

**Final BC shape**: new `## BC-X.16: API Query Parameters` subsection in `cross-cutting.md`
(filed as a Cross-Cutting subsection, not a new numbered domain-spec section file, per
BC-X.12/BC-X.14/BC-X.15's own sizing precedent).

**BC-X.16.001** — `jr api <path> --query-param NAME=VALUE` (repeatable, `-q`) builds a
percent-encoded query string and merges it with any `?` already present in `<path>`;
method-orthogonal, ordering-preserving for repeated names. Query-string detection scans only the
part of `<path>` before the first `#` (a fragment is never scanned for `?`); the query component
is the text after the FIRST `?` in that pre-fragment part — empty or `&`-terminated → new pairs
appended with no separator; otherwise → `&`-joined, even when the component itself ends in a
literal `?` (EC-X.16.001-9: `/s?jql=why?` + `k=v` → `/s?jql=why?&k=v`, never
`/s?jql=why?k=v`). The assembly never adds a second `?` and never adds `&` immediately after an
empty or `&`-terminated component — there is no broader claim that the output never contains
`?&`/`??` as substrings, since EC-X.16.001-9 legitimately produces `?&` when the existing query
content itself ends in a literal `?`. NAME/VALUE are percent-encoded exactly once via
`urlencoding::encode` (the RFC 3986 unreserved alphabet, space → `%20` never `+` — an
encoder-agnostic choice, since `%20` decodes back to a space byte under both RFC 3986 and
form-urlencoded semantics, while `+` does not). NAME/VALUE are used exactly as typed, not
trimmed — settled behavior, human-confirmed 2026-09-25 (D-380) (see "Decisions confirmed during F2
review" below). `#fragment` interaction: per RFC 3986 component
ordering (`path?query#fragment`), the assembled query is inserted between the path and any
`#fragment`, passed through verbatim; per RFC 9112 §3.2 (request-target) a fragment is
client-side-only and is never
transmitted to the server regardless of `jr`'s own choices — documented as an edge case of the
new assembly step, not a change to `normalize_path` itself (`normalize_path` remains
unmodified and performs no fragment-aware handling). Precondition cites
`src/cli/api.rs::normalize_path` directly: `<path>` already has a leading slash and is not an
absolute `http(s)://` URL by the time this step runs. Full Edge Cases — see BC-X.16.001 Edge
Cases in `cross-cutting.md` — covering empty VALUE, VALUE containing `=`, non-ASCII VALUE,
existing `?`, a `#` fragment, method combinations, the zero-flag no-op guarantee, a `<path>`
already ending in a bare `?` or in `&`, the literal trailing-`?` query component, NAME/VALUE
non-trimming, and a `--query-param` NAME colliding with an existing query-string NAME being
neither deduplicated nor overridden — both sent, existing pairs first (EC-X.16.001-12);
Verification Properties
VP-API-QP-001..004, targeting the pure `append_query_params` function — VP-API-QP-001's proptest
needs no `JiraClient`/network/config; VP-API-QP-002 additionally adds a hermetic wiremock argv
cell (EC-X.16.001-13) proving a comma inside VALUE is never split into multiple pairs (no
`value_delimiter`) at the wire level — a second argv cell (repeated well-formed flags reach the
wire in order) is added by formal-verifier; VP-API-QP-003 additionally adds a `jr api --help`
integration cell (VP-API-QP-003(e))
pinning the "do not pre-encode" help text; VP-API-QP-004 additionally adds a hermetic
table-driven wiremock layer over GET/POST/PUT/PATCH/DELETE to prove method-orthogonality at the
wire level, on top of its own structural (signature) and proptest (zero-flag identity) checks —
VP-API-QP-001's separator oracle explicitly covers the `?&`
substring produced by EC-X.16.001-9 rather than banning it. `url = "2"` and `urlencoding = "2"`
are already direct dependencies — no new dependency is added. `urlencoding::encode` is the
PRODUCTION encoder; `url::form_urlencoded::parse` is used exclusively as a TEST-ORACLE decoder in
VP-API-QP-002/003's proptests; `url::form_urlencoded::byte_serialize` is explicitly FORBIDDEN for
production use (it targets `application/x-www-form-urlencoded` semantics, not this BC's RFC 3986
alphabet).

BC-X.1.007 (`send_raw` raw passthrough) and BC-X.1.011 (`-X`/`--method` case-insensitivity) are
both explicitly confirmed UNAFFECTED: a zero-`--query-param` invocation produces byte-for-byte
the same path `normalize_path` already produces, and the new assembly step runs strictly between
`normalize_path` and `client.request`, orthogonal to both method dispatch and raw-passthrough
response handling.

**BC-X.16.002** — Error taxonomy: `--query-param` with no `=` and `--query-param` with an empty
NAME both exit 64 pre-HTTP via a new `parse_query_param` function (distinct from
`append_query_params`); an empty VALUE (`k=`) is explicitly ALLOWED, not an error; a multi-flag
invocation with any one malformed value fails the whole invocation before any HTTP call, on the
FIRST malformed value in flag order. Parsing is inserted immediately after `normalize_path` in
`handle_api` and BEFORE `resolve_body` (which can block on `-d @-` stdin) and BEFORE `-H`/
`--header` parsing, per D-188's pre-flight-before-blocking-read convention. The two error
messages are pinned VERBATIM, modeled on `parse_header`'s own two messages, each naming a
concrete next step: `"--query-param must be in NAME=VALUE format (got: {raw})"` and
`"--query-param NAME cannot be empty (got: {raw}) — use NAME=VALUE, e.g. -q maxResults=50"`.
Edge Cases — see BC-X.16.002 Edge Cases in `cross-cutting.md`; Verification Properties
VP-API-QP-005..006, targeting `parse_query_param` and asserting on the two pinned strings
verbatim.

## BCs NOT Touched

- BC-X.1.001..010, BC-X.1.011 (unaffected, see above) — HTTP client / method-flag mechanics
  untouched.
- BC-X.7.001, BC-X.7.003..010 — other `user` command BCs untouched; only BC-X.7.002's resolution
  order changed.
- BC-X.14.002 (`--value` filter), BC-X.14.004 (error taxonomy) — CONTRACT untouched; the
  label-resolution fallback is upstream of both and changes neither's text. BC-X.14.002's filter
  now also matches system-field option names via the fallback `label` as a downstream
  consequence of #861 (new EC-X.14.001-13, filed under BC-X.14.001 since it documents the
  normalizer's effect, not a BC-X.14.002 contract change). BC-X.14.004's contract is likewise
  unchanged, but it gains one cycle-014 cross-reference row in its error-taxonomy table (the
  pre-existing empty-`<field>` guard, citing BC-X.14.001 EC-X.14.001-15) — documentation-only,
  COUNT-NEUTRAL (PASS-14, propagated to the other summary surfaces at PASS-15).
- All `bc-1` through `bc-8` files — no cross-cutting change touches module/component boundaries
  in this cycle (F1 confirmed no architecture change).
- `src/cli/issue/field_resolve.rs` and every `src/cli/issue/*.rs` BC (bc-3-issue-write.md) —
  confirmed DEPENDENT-UNCHANGED; the write-side reachability audit (Item 2 above) is read-only
  reference, not a BC change.

---

## Architecture unchanged

F1 confirmed no architecture change for any of the three items — no module boundary change, no
new file, no purity-boundary crossing (pure config-merge for #862, pure normalizer fallback for
#861, pure query-string assembly for #583, all within existing effectful-shell command
handlers). No entry written to `.factory/specs/architecture/`; this note stands in place of an
`architecture-delta.md` file per the phase skill's "if no structural changes needed, skip this
step and note 'Architecture unchanged'" instruction.

---

## Verification Property Extension

New VPs, continuing existing VP-ID sequences. A separate F2 Step 4 verification delta exists for
this cycle, produced by the formal-verifier:
`.factory/cycles/cycle-014/phase-f2-spec-evolution/verification-delta.md` — it is the
authoritative rationale, proof-strategy design, and ID-collision audit for all 8 VPs below.
These remain inline BC-level VPs, not new Kani-proof/fuzz-target classes; consistent with
BC-X.14.001's own prior VP-580-* additions living inline in `cross-cutting.md` rather than in a
verification-architecture ARCH-INDEX:

- VP-USER-LIST-PROJECT-001 (BC-X.7.002)
- VP-580-013 (BC-X.14.001; RENUMBERED from "VP-580-011" at F2 Step 4 — the mint collided with
  the pre-existing BC-X.14.002 VP-580-011 (2026-08-26) and the also-taken VP-580-012
  (BC-X.14.004); see `verification-delta.md` Task 1 for the full audit)
- VP-API-QP-001..006 (BC-X.16.001/002)

No verification-architecture artifact exists in this repo (see verification-delta.md
`vp_count_basis`); all new VPs live inline in cross-cutting.md — no new Kani proofs or fuzz
targets; the new VPs combine example, proptest (including a recursive AllowedValue strategy and
a biased UTF-8 strategy) and hermetic wiremock layers — see verification-delta.md §1.

---

## Edge Case Catalog / Error Taxonomy

- `.factory/specs/prd/edge-case-catalog.md`: new `## EC-CYCLE014: Cross-References` section
  (EC-CYCLE014-001..003) pointing to the authoritative inline edge cases in `cross-cutting.md`
  added above, per this repo's convention that BC-owned edge cases live inline in their BC file.
  EC-CYCLE014-003's Boundary/Expected text points to BC-X.16.001's Edge Cases in
  `cross-cutting.md` rather than enumerating a range (a repeated ID range in a summary surface
  goes stale after every F2 remediation pass).
- `.factory/specs/prd/error-taxonomy.md`: Section 6 gains two new subsections — "User Commands"
  (BC-X.7.002's no-resolvable-project row, reusing `queue.rs`/`requesttype.rs`'s exact wording,
  with a note that `config::validate_profile_name`, `Config::load_with` (e.g. unknown profile,
  malformed config) and `JiraClient::from_config` failures all preempt this row's exit-64; some
  of these also exit 64) and "API Commands" (BC-X.16.002's two malformed-`--query-param`-value
  rows, with the same note and a note on NAME/VALUE non-trimming and pre-flight ordering relative
  to `resolve_body`/header parsing).

---

## Stories

No story files exist for cycle-014 yet — F3 (incremental story decomposition) is the next
phase. Three S stories are planned per the cycle manifest, delivered SERIALLY in the order
A → C → B — STORY-A (#862) first, then STORY-C (#583) rebased on STORY-A, then STORY-B (#861,
read-side only) rebased on STORY-C (human decision, 2026-09-25 F2 review, superseding the
parallel-wave-eligible framing accepted at the F1 gate — see the dated amendment note in
`cycle-manifest.md`). No BC array re-anchoring or story-body propagation is needed from this F2
burst (no existing story references any of these BCs).

**F4 obligation (PASS-8, P8-002):** as part of STORY-B, F4 must rename
`tests/field_options.rs::test_bc_x_14_001_field_name_human_name_resolves_via_partial_match`
(confirmed present) to a name reflecting `search_field_list` rather than `partial_match`, per
CLAUDE.md's test-naming convention, and correct its doc comment (currently reads "the
field-name-resolution happy path via `list_fields()` + `partial_match`"), consistent with the
BC-X.14.001 field-name-resolution correction landed in this delta.

**F4 obligation extension (PASS-9, P9-002):** the same `partial_match`-vs-`search_field_list`
staleness reaches beyond the one renamed test above. Confirmed present at each site — F4 must
also correct: the user-facing clap doc comment on
`src/cli/mod.rs::FieldCommand::Options.field` (`~L1231-1232`, "resolved via `list_fields()` +
`partial_match`"); the about-text at `src/cli/mod.rs` `~L128` ("Discover custom-field allowed
options") and `~L1224` ("Enumerate a custom field's allowed options") — reword away from "custom
field" (e.g. "a field's allowed options"), since after #861 the command also serves system
fields, not custom fields only; the module doc comment at `src/cli/field.rs:1` ("enumerate a
custom field's allowed options"); README.md's `jr field options <NAME>` command-reference row
(`~L346`, "Enumerate a custom field's allowed options…"); CLAUDE.md's `field.rs` file-tree line
(`~L61`, "enumerate a custom field's allowed options"); the `src/cli/field.rs::handle` Step 2
comment (`~L134`, "resolved via the per-profile fields cache / `list_fields()` + `partial_match`");
and the `tests/field_options.rs` comments at `~L1436` (section banner "customfield_NNNNN bypass /
list_fields + partial_match") and `~L2050` ("it resolves via `list_fields()` + `partial_match`
first"). Because the about-text/help-text corrections and the README.md/CLAUDE.md wording are
user-visible/documentation-visible, `jr field options --help` output and both docs change as a
result — cosmetic, not a behavior change.

**F4 doc-delta obligations (PASS-13, P13-003):** two further README.md rows go stale as a direct
consequence of this delta's other two items and must be updated as part of the corresponding
story. As part of STORY-A (#862), F4 must update README.md's `jr user list --project FOO` row
(`~L335`) to show `--project` as optional, reflecting the new fallback to the configured default
project rather than implying the flag is required. As part of STORY-C (#583), F4 must update
README.md's `jr api <PATH>` row (`~L332`) to document `-q`/`--query-param NAME=VALUE`. That same
row's existing `--body` mention is a pre-existing stale name for the actual flag, `-d`/`--data`
(`src/cli/mod.rs::Command::Api.data`) — unrelated to cycle-014's own changes, so it is not
corrected here but is registered as drift item `README-JR-API-BODY-FLAG` (LOW) for a future pass.
`README.md` is added to `spec-changelog.md`'s `[2.4.0]` Impact Assessment table accordingly.

**F4 obligation (PASS-28, P28-001):** the `.cargo/mutants.toml` `examine_globs` additions and
their `docs/specs/cargo-mutants-policy.md` §Scope bullets are added per-story, at F4, in the PR
that introduces each file's functions — not deferred to F6, correcting the cycle manifest's
earlier framing. As part of STORY-A (#862), F4 adds `src/cli/user.rs`
(`resolve_user_list_project`). As part of STORY-C (#583), F4 adds `src/cli/api.rs`
(`append_query_params`, `parse_query_param`). Delivery is serial (A → C → B): STORY-A bumps the
policy's hard-coded "Current `examine_globs` count" line 32 → 33 and STORY-C bumps it 33 → 34,
each adding its own newest-first row to the policy's `## Changelog` table. F6 (targeted hardening)
verifies both additions rather than introducing them.

---

## Spec Version Bump

**MINOR** (`.factory/spec-changelog.md` 2.3.2 → 2.4.0, 2026-09-25) — per this repo's own Type
legend ("MINOR = new BCs/VPs/sections; PATCH = amendments to existing bodies/ACs/ECs"), issue
#583 adds a genuinely new BC family (`## BC-X.16: API Query Parameters`, 2 new BCs), which
classifies the bundled delta as MINOR even though items #862 and #861 are individually
PATCH-shaped amendments — the strictest change in a bundled delta determines the Type,
consistent with how cycle-005's bundled amendments+new-BCs delta was classified. Rolls into the
next dev prerelease per the cycle manifest's framing; no immediate tag cut.

---

## Guard Script Results

- `scripts/check-bc-cumulative-counts.sh`: **PASS** — `OK: all cumulative BC counts verified
  (772 total across 9 files; Surface H footer checked where present).`
- `scripts/check-spec-counts.sh`: **PASS** — `Check passed: 8 bc files validated.`
- `scripts/check-bc-citation-symbols.sh`: **PASS** — `Check passed: 526 citations checked.`
  (Note: this guard's glob is `bc-*.md` only and does not scan `cross-cutting.md`; all new/
  amended citations in `cross-cutting.md` were nonetheless written to resolve against real
  `src/` files/symbols, or explicitly marked "to be implemented/modified, cycle-014" for
  F4-pending code.)
- `cross-cutting.md` `#### BC-` heading count verified directly: 96 (matches
  `definitional_count: 96`).

---

## Decisions confirmed during F2 review

Three design defaults, human-confirmed 2026-09-25 during F2 review (D-380) — settled behavior, not
pending:

- **(a) NAME/VALUE trimming (BC-X.16.001 Behavior 3)**: `--query-param` NAME and VALUE are used
  exactly as typed — NEITHER is trimmed, matching `gh api -f`'s raw-bytes behavior.
- **(b) `--project ""` pass-through (BC-X.7.002 EC-X.7.002-6)**: an explicit empty-string
  `--project ""` passes through as-is, resolving the project key to the empty string without
  consulting the configured default — matching `jr queue`/`jr requesttype`'s existing
  empty-string pass-through behavior.
- **(c) No override/dedup for a `-q` NAME collision (BC-X.16.001 EC-X.16.001-12)**: a
  `--query-param` NAME colliding with a NAME already present in `<path>`'s existing query string
  is NEITHER deduplicated against NOR overridden — both are sent, existing pairs first.

---

## F2 revision history

Cycle-014's F2 spec-writing pass went through an initial authoring burst followed by twenty-nine
adversarial-review passes, PASS-1 through PASS-29 (PASS-11, PASS-12, PASS-22 and PASS-26 CLEAN)
(all BC-side; VP text and
`verification-delta.md` are owned by formal-verifier and were out of scope except where noted).
Every finding below was independently re-verified against `src/` before being applied — nothing
here was taken on faith from the review passes. The sections that follow condense what changed
and why; the individual pass-by-pass finding tables that used to live in this file have been
folded into this narrative, since `cross-cutting.md`, `BC-INDEX.md`, `CANONICAL-COUNTS.md`,
`edge-case-catalog.md`, `error-taxonomy.md` and `spec-changelog.md`'s `[2.4.0]` entry now all
reflect the final, converged state described above.

**Root-cause and precedent framing (issue #862).** The first review round caught that
`src/main.rs`'s `Command::User` arm not passing `cli.project` through had been mis-framed as the
sole root cause alongside the `String`-vs-`Option<String>` typing; direct inspection of clap's
`fill_in_global_values` ordering showed the typing alone was sufficient to explain the reported
bug, with the missing `&Config` threading a separate, pre-existing gap. A later round found this
correction had only been applied to the BC's inline Behavior prose, not to its own Trace field
or to `spec-changelog.md`'s Rationale cell, which still cited the superseded framing — both were
re-anchored to match. The BC-8.1.004 citation was similarly corrected from an implied
"local-over-global precedent, reused verbatim" to the accurate anchor:
`src/cli/component.rs::handle`'s List/Create arms carry the actual explicit local-over-global
code, while BC-8.1.004 itself covers only the no-project-configured exit-64 condition.

**The `resolve_user_list_project` pure-resolver shape.** Once the local-vs-global half of the
resolution order was reframed as clap's own propagation (not `jr` code), the pure resolver's
signature was corrected from a naive two-parameter merge to
`resolve_user_list_project(cli_project: Option<&str>, config: &Config) -> Option<String>` — a
one-parameter fallback over the already-clap-resolved local/global value, consulting `Config`
only for the third resolution step. `cli::user::handle`/`handle_list` gaining a `&Config`
parameter, and `main.rs` threading its already-loaded `config` binding through (never reloading
it, so `--profile`/`JR_PROFILE` selection survives), was added as an explicit MUST alongside
this, plus a new EC-X.7.002-5 covering a non-default `--profile`'s own configured default.

**Source anchors.** BC-X.7.002's Source field was extended to cite `src/cli/mod.rs`'s
`UserCommand::List.project` field (the type change site) and `src/main.rs`'s `Command::User`
dispatch arm (the `&Config`-threading site) alongside the handler functions, each marked "to be
modified/implemented, cycle-014" since no code has landed yet for this spec-only delta.

**BC-X.14.001 index title and label-resolution fallback (issue #861).** BC-X.14.001's H1 is
UNCHANGED by cycle-014 — the H1 was last corrected in an earlier pass (2026-08-26, F2
adversary-convergence round-3, F-MED-2), and that pre-existing header note (BC-INDEX.md title
row must mirror the H1 verbatim, flagged for the state-manager's next reconciliation pass) is
carried over unmodified; only the BC's body (Edge Cases, VP) was refined this cycle. The
label-resolution fallback rule was tightened from an
emptiness-based reading to a presence-based one: `value: Some("")` wins over a populated `name`,
never falling through to `name` merely because the `value` string is empty (new
EC-X.14.001-12). The `.jr.toml` caveat was added to EC-X.7.002-5 for the analogous #862 case: a
non-default profile's own default only wins when no ancestor `.jr.toml` project exists, since
`Config::project_key`'s own fallback order checks `.jr.toml` first.

**BC-X.16.001 query-merge precision (issue #583).** The query-merge rule went through two
rounds of precision fixes: first, stating the algorithm exactly (query detection scans only the
pre-`#` part of `<path>`; the query component is the text after the first `?`; empty-or-`&`-
terminated → no separator; otherwise → `&`-join, even when the component itself ends in a
literal `?`, EC-X.16.001-9). A follow-up round found EC-X.16.001-8's own closing sentence still
described a "trailing `?`/`&` immediately before the insertion point" heuristic left over from
before EC-X.16.001-9 was added — a residual that directly contradicted the new edge case. It was
rewritten to state the actual QUERY COMPONENT rule and to clarify explicitly that a `?&`
substring may legitimately appear in output (EC-X.16.001-9) even though the assembly never
*adds* `?&` as a separator — there is no blanket "never produces `?&`" claim, only a claim about
what the assembly itself inserts.

**Encoder rationale and forbidden alternative.** `urlencoding` 2.1.3's source was read directly
to confirm it percent-encodes every byte outside `A-Za-z0-9-._~` with no space-to-`+` special
case, which grounds the BC's alphabet claim and the "space → `%20`, encoder-agnostic" rationale
(`%20` decodes back to a space byte under both RFC 3986 and form-urlencoded semantics, `+` does
not). `url::form_urlencoded::byte_serialize` was explicitly named and forbidden for production
use, distinguished from `url::form_urlencoded::parse`'s legitimate role as a test-oracle decoder
in VP-API-QP-002/003 — earlier drafts had blended "reuses url/urlencoding" into one undifferentiated
phrase, which was replaced everywhere it appeared (BC body, Source/Trace, BC-INDEX.md row, and
this file's "No new dependency" framing) with the precise three-way split.

**Error-message and fault-model consistency.** BC-X.16.002's two error messages were pinned
verbatim in both the BC's Behavior table and `error-taxonomy.md`'s API Commands table, each
distinguishable by a unique substring; the M1 (missing-`=`) message states the required
`NAME=VALUE` format directly as its own next-step guidance, consistent with the repo's "always
suggest what to do next" convention. VP fault-model sections across the affected BCs were
normalized to a consistent "**Fault models (killed by example/proptest):**" label. The
NAME/VALUE non-trimming default's pending-confirmation marker was made consistent everywhere it
appeared at the time (BC body, VP-API-QP-003(d), this file's own summary above) — it was
subsequently confirmed by the human 2026-09-25; see "Decisions confirmed during F2 review" below.

**Propagation and summary-surface sweep.** A final round re-grepped every editable file for each
corrected phrase to confirm no stale copy survived outside the BC body that was first fixed —
including `CANONICAL-COUNTS.md`'s system-field list (missing `fixVersions`), BC-INDEX.md's
Source cells (now citing `src/cli/mod.rs`/`src/main.rs` for BC-X.7.002 and
`normalize_from_allowed_values_at_depth` for BC-X.14.001), and the summary/rationale prose in
this file and in `spec-changelog.md`'s `[2.4.0]` entry, both now folded into the clean,
pass-tag-free descriptions above.

**PASS-5** re-verified the changelog's VP table against
the actual VP bodies in `cross-cutting.md` and found the "first malformed flag in order"
property had been misattributed to VP-API-QP-005's row when it is actually VP-API-QP-006(ii);
both rows were corrected, and the changelog's VP-API-QP-005 in-body cross-reference
(`VP-API-QP-005(i)`) was reworded to `VP-API-QP-005 (distinguishing-substring assertion)`
everywhere it appears, since VP-API-QP-005 has no sub-enumerated clauses of its own. It also
tightened several BC-X.7.002/BC-X.14.001/BC-X.16.001-002 passages against direct `src/`
re-verification: the BC-X.14.001 Trace's "(modified"/"(both corrected" phrasing was corrected to
"(to be modified"/"(both to be corrected at F4" since no `src/` code has landed for this delta;
EC-X.14.001-12 was extended to state that a wire `"value": null` deserializes to `None` (not
presence-but-empty) so `name` is still consulted, and a new EC-X.14.001-13 documents that
BC-X.14.002's existing `--value` filter now also matches system-field option names via the
fallback label as a read-side-only consequence of #861 (BC-X.14.002's own contract is
unchanged); a new EC-X.7.002-6 states the `--project ""` pass-through explicitly, matching
`queue`/`requesttype`'s existing behavior; BC-X.7.002's hermetic-test precondition and
`error-taxonomy.md`'s User Commands note were extended to require clearing `JR_PROFILE` and any
other `JR_`-prefixed environment variable, verified against `Config::load_inner`'s two
`JR_`-reading sites (`Env::prefixed("JR_")` and the separate `JR_PROFILE` read); BC-X.16.002's
Preconditions and `error-taxonomy.md`'s API Commands note were extended to state that `-q`
validation in `main.rs`'s `Command::Api` arm runs only after `Config::load_with` and
`JiraClient::from_config` both succeed; BC-X.16.001's Behavior 5/Postcondition 1/EC-X.16.001-7
zero-flag wording was reworded from an implementation claim ("no query-assembly step runs") to
an observable one (byte-identical output; `append_query_params(p, &[]) == p` is the assembler's
own identity contract); a new EC-X.16.001-12 states that a `--query-param` NAME colliding with
an existing query-string NAME is neither deduplicated nor overridden — both are sent, existing
pairs first; the component.rs citation for `handle_list`'s project resolution was corrected from
`config.project_key(project.as_deref())` to the actual `config.project_key(project)` (verified
against `src/cli/component.rs:~188`, where `handle_list`'s `project` parameter is already
`Option<&str>`); the dispatch-arm lists in both this file and BC-X.7.002 were completed against a
direct `src/main.rs` read (`Project`, `Issue`, `Board`, `Sprint`, `Queue`, `RequestType`,
`Field`, `Component` all thread `cli.project.as_deref()`; `Worklog`/`Team`/`User`/`Api` do not);
the `[2.4.0]` changelog header date was unified to 2026-09-25, matching `cross-cutting.md`'s own
trace date; BC-X.16.001 Behavior 1 and `edge-case-catalog.md`'s EC-CYCLE014-003 were reworded so
the empty-query-component case reads "the pre-fragment part ends at the first `?`" (covering
`/s?#f`, not just a path that literally ends at the `?`); and BC-X.16.001's Behavior gained a
note that the `--query-param`/`-q` clap help text states values are passed raw and must not be
pre-encoded by the caller. PASS-5 also added EC-X.14.001-14 (P5-008 — documents that `<field>`
name RESOLUTION itself, via `search_field_list`, is pre-existing behavior unaffected by #861) and
EC-X.16.002-5..8 (P5-005 — clap attached-form edge cases for `-q=v`/`-q==v`/`--query-param==v`/
`-q -x=1`).

**PASS-6** confirmed the three previously-pending design defaults — (a) NAME/VALUE
non-trimming, (b) `--project ""` pass-through, (c) `-q` NAME no-override/dedup — as settled,
human-confirmed 2026-09-25 (D-380) decisions, and removed every "pending F2-gate confirmation" marker for
them across `cross-cutting.md`, `edge-case-catalog.md`, `error-taxonomy.md`, `BC-INDEX.md`,
`CANONICAL-COUNTS.md` and `spec-changelog.md` (see "Decisions confirmed during F2 review" above).
It also fixed a pre-existing spec/code drift PASS-5's EC-X.14.001-14 had surfaced but not
corrected: BC-X.14.001's Behavior and Invariant 4 misattributed `<field>` name resolution to
`partial_match`/BC-X.10.001, when the code (`search_field_list`) actually implements a distinct
exact-then-substring rule — corrected to describe the real rule, marked "(corrected cycle-014:
aligns with existing code and tests; no behavior change)"; reworded EC-X.14.001-14 to state
display names as tenant/locale-dependent rather than pinning `Fix Version/s` as a portable
constant, and corrected its discovery-command pointer to `jr api /rest/api/3/field` (verified:
`jr project fields --output json` does not list generic field names); added a cosmetic note to
EC-X.14.001-13 that `--value high` matches both `Highest` and `High`; dropped an RFC
3986/Jira-interoperability overclaim from BC-X.16.001's Invariants; corrected a false claim in
BC-INDEX.md's `last_updated` annotation that had attributed the +2 BC-X.16 addition's own history
entry to the unrelated cycle-012 entry; and unified the `2026-09-24` date label used for the
2.4.0 delta / +2 BC addition to `2026-09-25` across `cross-cutting.md`, `BC-INDEX.md`,
`CANONICAL-COUNTS.md` and `error-taxonomy.md`.

**PASS-7** finished the field-name-resolution correction PASS-6 started: every
remaining `partial_match`/BC-X.10.001 mention of BC-X.14.001's own `<field>` resolution
(Preconditions, EC-X.14.001-1/2/6, Trace) was corrected to `search_field_list`
(`src/cli/field.rs`), leaving `partial_match` mentions only where they correctly describe a
DIFFERENT resolution target (M3's own `--request-type` name lookup, BC-X.12.006). It also: added
a known-inconsistency note to EC-X.14.001-14 and to this file's follow-ups, tracked as drift item
`FIELD-OPTIONS-NOTFOUND-HINT` (BC-X.14.004's zero-match hint and `resolve_field_id`'s shipped
error message both name `jr project fields --output json`, which does not list field names —
out of scope for cycle-014); reworded EC-X.7.002-1 to correctly attribute `component list`/
`create`'s explicit local-over-global merge code versus `component edit`/`delete`'s
clap-propagation-only mechanism; corrected BC-X.14.001's Behavior/Postconditions to state that
`list_fields()` is re-fetched on a cache miss OR when `<field>` is absent from the cached list,
while an ambiguity found WITHIN the cached list exits 64 without a refresh; removed an incorrect
shell-quoting workaround claim from EC-X.16.002-8 (only the attached form, `-q=-x=1` /
`--query-param=-x=1`, works); clarified that `UserCommand::List.project`'s `short = 'p'`
attribute is retained unmodified, only its type changes; pinned the exact "do not pre-encode"
help-text substring for BC-X.16.001 Behavior 3; corrected VP-580-013's description away from
"byte-identical"/"4-cell" toward an accurate example-matrix (including explicit-null and
empty-string cells) plus an M3 regression against a hand-written expected value, in both
`cross-cutting.md` (VP bullet, formal-verifier scope, unchanged by this burst) and
`spec-changelog.md`; added a hermetic wiremock argv cell note to VP-API-QP-002's
`spec-changelog.md` row; clarified (here and in this file's Item 2 discussion) that
BC-X.14.001's H1 is NOT changed by cycle-014 — only its body was refined; and fixed the garbled
"never `?&`" phrasing in `edge-case-catalog.md`'s trace and EC-CYCLE014-003 to state the rule
plainly (no separator after an empty or `&`-terminated query component), adding the
stdin-held-open, no-blocking, exit-64-before-body-read outcome to EC-CYCLE014-003's Expected.

**PASS-8** closed a further adversarial round, BC-side only (VP text and
`verification-delta.md` remain formal-verifier's, untouched). It traced the BC-X.14.001
field-name-resolution correction PASS-7 had made in `cross-cutting.md` out to its remaining
summary surfaces: `cross-cutting.md`'s cycle-014 frontmatter `trace:` entry, `spec-changelog.md`'s
`[2.4.0]` BC-X.14.001/BC-X.14.003 row, and `BC-INDEX.md`'s BC-X.14.001 Source cell now all state
that field-name resolution was corrected from `partial_match`/BC-X.10.001 to `search_field_list`
(`src/cli/field.rs::resolve_field_id`/`search_field_list`), aligning spec with existing
code/tests with no behavior change. It logged an F4 obligation for STORY-B: rename
`tests/field_options.rs::test_bc_x_14_001_field_name_human_name_resolves_via_partial_match`
(confirmed present) to a name reflecting `search_field_list`, per CLAUDE.md's test-naming
convention, and fix its stale doc comment. It corrected EC-X.14.001-14(b): `fixVersions` fails
resolution because the camelCase field id lacks the space (and, where present, the slash) that
the display name carries — not because of a tenant-specific `/`-in-display-name qualifier, which
was dropped; (c)'s slash-contiguity explanation for the `versions`/`version` ambiguity is
unchanged. It refreshed `BC-INDEX.md`'s stale Coverage Statistics table and notes (previously
658/428 cumulative/individually-bodied totals, missing the `8: Components` row and showing
`X: Cross-Cutting` at 151/85) to match `CANONICAL-COUNTS.md` exactly — 772/542 totals, verified
by `scripts/check-bc-cumulative-counts.sh`. It corrected three inaccuracies in this file's own
"Summary of the final delta": the BC-X.7.002 BC-INDEX Source-cell description now matches row
~818 verbatim rather than an abbreviated paraphrase; the VP-API-QP integration-layer description
now states that VP-API-QP-002 carries a hermetic wiremock argv cell (EC-X.16.001-13) and
VP-API-QP-003 carries a `jr api --help` integration cell, not just VP-API-QP-004; and
`BC-INDEX.md`'s BC-X.16.001 Source cell gained an explicit `url::form_urlencoded::byte_serialize
(forbidden)` entry alongside its production/test-oracle encoder citations, closing the
encoder three-way split gap without needing to reword this file's own summary. It replaced
`spec-changelog.md`'s `[2.4.0]` "Migration needed: NO … Migration notes: None" with an accurate
note that two `jr user list` behaviors are user-visible (exit 64 instead of clap's exit 2 on an
unresolvable project; success with no `--project` flag when a `.jr.toml`/profile default is
configured) and belong in the product CHANGELOG at release — everything else in the delta remains
additive. Finally, it added the same `jr api --help` integration-cell note to
`spec-changelog.md`'s VP-API-QP-003 proof-strategy cell. No BC or VP body content changed and no
count changed; all fixes were citation/summary-surface corrections.

**PASS-9** closed a further adversarial round, BC-side only (formal-verifier owns
`verification-delta.md` concurrently and was not touched). It added BC-X.14.001's existing
`resolve_field_id` empty-name guard (`query.is_empty()` → exit 64, zero HTTP, already covered by
`test_bc_x_14_001_empty_field_name_exits_64_zero_http`) to the BC's Behavior, Postconditions,
Invariant 4, and a new trailing Edge Case, so the corrected field-name algorithm now states the
guard rather than omitting it. It extended STORY-B's F4 obligation with the additional
`partial_match`-vs-`search_field_list` stale-comment sites in `src/cli/mod.rs`, `src/cli/field.rs`,
and `tests/field_options.rs`, and flagged the resulting `jr field options --help` text change as
user-visible but cosmetic. It reworded EC-X.16.002-4 and `edge-case-catalog.md`'s
EC-CYCLE014-003 to cover every stdin state (TTY, inherited, closed, held-open pipe) instead of
naming only "not piped", matching what VP-API-QP-006(iii) actually exercises. It also made three
cosmetic corrections: the BC-X.7.002/prd-delta.md "do not pass cli.project" command list now
reads `Worklog`, `Team`, `User`, `Api`, `Assets`, `Me`, among others (verified against
`src/main.rs`); this file's Item 2 "Final BC shape" now points at BC-X.14.001's own Edge Cases
section instead of enumerating a range; and BC-X.16.001's stray comma and an empty code span in
EC-X.16.001-8 were fixed in `cross-cutting.md`. No BC or VP count changed.

**PASS-10** closed a further adversarial round, BC-side only (`verification-delta.md`
untouched). It reworded BC-X.14.001's Behavior and Invariant 4 so the empty-`<field>` guard is
described relative to the mode-selector arity check (Invariant 1) rather than claiming it fires
"first" in absolute terms — the guard runs AFTER Step 1's arity check and BEFORE any cache read
or HTTP call, matching `src/cli/field.rs::handle`'s actual step order (Step 1 arity check, Step 2
`resolve_field_id`). It added a sentence to the M2 project-resolution paragraph flagging a
known, out-of-scope ordering drift: because Step 2's field-name resolution runs before M2's own
project-resolution step, a human-name `<field>` on a cold cache can issue a `GET /rest/api/3/field`
before the incomplete-M2 project error fires, in tension with Invariant 1's "before any HTTP
call" framing for that specific error — logged as drift item `FIELD-OPTIONS-RESOLUTION-ORDER`,
alongside `FIELD-OPTIONS-NOTFOUND-HINT` (PASS-7) in this file's follow-ups. Two further,
independently-verified follow-up items are logged the same way: `FIELD-OPTIONS-M3-PROJECT-ERROR-TEXT`
(BC-X.14.001's M3 "no resolvable ambient project" clause says the error is
`require_service_desk`'s own "project required" message, but `src/cli/field.rs::handle`'s
`Mode::RequestType` arm actually returns `resolve_m2_project`'s own distinct message,
`"--request-type needs a resolvable project — pass --project <P> or configure a default."`,
~L207-213, BEFORE `require_service_desk` is ever called) and `BC-INDEX-X14-TITLE-DRIFT`
(BC-X.14.002's and BC-X.14.004's `BC-INDEX.md` title-row summaries no longer read verbatim
against their own H1s in `cross-cutting.md` — a title-row propagation gap, not a body defect).
None of the three items changes any BC's contract this pass; all are recorded as follow-ups only,
per the orchestrator's decision to document rather than widen cycle-014's scope.

It added a one-sentence F1-gate rationale to BC-X.7.002's Source and Invariants for the existing
"no rename" annotation on `tests/user_commands.rs::user_list_requires_project_flag`: the human
accepted keeping the name at the F1 gate (cycle-manifest Open Question 8), because — unlike the
now-renamed `partial_match`-named field-options test, which named a mechanism the code no longer
uses — this test's own assertion (stderr mentions `--project`) makes no mechanism claim, so it
continues to accurately describe what it checks under the required hermetic setup.

It added EC-X.16.002-9 to BC-X.16.002: an empty raw value from any of `-q ""`, `-q=`, or
`--query-param=` reaches `parse_query_param` as `raw = ""`, verified directly against
`clap_builder` 4.6.7's short-flag attached-value path and `clap_lex` 1.1.0's `to_long`
long-flag split — both deliver `Some("")`, a provided-but-empty value, not a missing one. Since
`""` contains no `=`, this classifies as M1 (missing `=`) with `(got: )`, not M2 — the
empty-NAME check is only reachable once a `=` has been found to split on. It also rewrote
EC-X.16.002-8: `-q-x=1` (bare concatenated, no `=` after `-q`) delivers the identical
`raw = "-x=1"` as `-q=-x=1` and `--query-param=-x=1`, so "the only working escape" (implying a
single form) was corrected to "any attached form."

It corrected EC-X.14.001-13's citation from the bare `field.rs::filter_one` to the full
`src/cli/field.rs::filter_options`/`src/cli/field.rs::filter_one` paths, per this repo's
citation-form convention (`CLAUDE.md` § "Citation form in spec/CLAUDE.md"). It extended
STORY-B's F4 stale-wording list (PASS-9, P9-002) with one further site: the module doc comment
at `src/cli/field.rs:1` ("enumerate a custom field's allowed options") — the same "custom field"
staleness class as the about-text corrections already listed there, since the command now also
serves system fields post-#861. It reworded `edge-case-catalog.md`'s EC-CYCLE014-003 Expected
clause to include "a TTY" among the stdin states the pre-flight ordering guarantee covers,
matching that same entry's own Boundary field, which already listed it. Finally, it appended a
note to `BC-INDEX.md`'s `last_updated` frontmatter flagging that PASS-8/PASS-9 made further
edits — the Coverage Statistics table refresh and the BC-X.7.002/BC-X.14.001 Source-cell
updates — not reflected in that entry's own PASS-5/PASS-6 narrative.

No BC or VP count changed: `cross-cutting.md` stays at `definitional_count: 96` / `total_bcs: 162`
cumulative, re-verified by `scripts/check-spec-counts.sh`, `scripts/check-bc-cumulative-counts.sh`,
and `scripts/check-bc-no-numeric-test-counts.sh` (all PASS). All changes were prose corrections,
precision additions, and two new inline Edge Cases (EC-X.16.002-9; no new heading count change).

**PASS-11** was CLEAN — the adversarial round found no new gaps, contradictions, or missing edge
cases. Three cosmetic wording fixes were made to BC-X.16.001/BC-X.16.002's edge-case text: (1)
EC-X.16.001-1 no longer claims RFC 3986 affirmatively sanctions an empty query value — it now
says the literal `k=` is sent as-is, since RFC 3986 places no constraint on it; (2) EC-X.16.001-5's
fragment-not-transmitted citation was corrected from the obsoleted RFC 7230 to RFC 9112 §3.2
(request-target); (3) EC-X.16.002-8 dropped the "or a missing-value error for `-q`" alternative,
since `-q -x=1` deterministically yields clap's `unexpected argument '-x' found` on exit 2, never
a missing-value message. No BC/VP count or heading count changed.

**PASS-12** was CLEAN — the adversarial round found no new gaps, contradictions, or missing edge
cases. Four cosmetic fixes were made.

**PASS-13** closed a further adversarial round, BC-side only (`verification-delta.md` is owned
concurrently by formal-verifier and was not touched). It corrected this file's Verification
Property Extension section, which had overstated the new VPs as purely example-based with no new
proptest strategy class: the new VPs actually combine example, proptest (including a recursive
`AllowedValue` strategy and a biased UTF-8 strategy) and hermetic wiremock layers (see
`verification-delta.md` §1). It added three stale-wording sites to STORY-B's own F4 obligation
paragraph that a PASS-10 history entry had claimed were already listed but were not:
`src/cli/field.rs:1`'s module doc comment, README.md's `field options` command-reference row, and
CLAUDE.md's `field.rs` file-tree line. It logged two new F4 doc-delta obligations under the
Stories section — STORY-A must update README.md's `jr user list --project FOO` row to show
`--project` as optional with its configured-default fallback, and STORY-C must update README.md's
`jr api <PATH>` row to add `-q`/`--query-param NAME=VALUE` — and registered that row's unrelated,
pre-existing `--body` naming mismatch as drift item `README-JR-API-BODY-FLAG`; `README.md` was
added to `spec-changelog.md`'s `[2.4.0]` Impact Assessment accordingly. It corrected
`CANONICAL-COUNTS.md`'s Breakdown block, which still stated the pre-cycle-014 754/524/159 totals
against the per-file table's current 772/542/162. Two cosmetic fixes: `cross-cutting.md`'s
FieldOption paragraph now attributes the M1/M2-vs-M3 fallback distinction to `(cycle-014, #861)`;
BC-X.7.002's Fix step 1 now notes that `UserCommand::List.project`'s help text is updated to
state the fallback order, modeled on `ComponentSubcommand::List`'s wording. No BC or VP count
changed.

**PASS-14** closed a further adversarial round, BC-side only (`verification-delta.md`'s own VP
bullets are owned concurrently by formal-verifier and were not touched). It corrected this
file's Item 3 narrative, which had mischaracterized VP-API-QP-002's hermetic wiremock argv cell
as proving repeated same-name params are sent in flag order; the argv cell (`-q
fields=summary,status` → one pair `fields=summary%2Cstatus`) actually proves a comma inside
VALUE is never split into multiple pairs (no `value_delimiter`) — the narrative now says so, and
notes that a second argv cell proving repeated well-formed flags reach the wire in order is
added by formal-verifier. It reworded the hermetic-test rule in `error-taxonomy.md`'s User
Commands note and this file's own sibling instance in `cross-cutting.md`'s BC-X.7.002
Preconditions from "clear `JR_PROFILE` and any other `JR_`-prefixed variable" to "clear every
ambient `JR_`-prefixed variable EXCEPT the hermetic seams the test sets (`JR_CONFIG_DIR`,
`JR_CACHE_DIR`, `JR_BASE_URL`, `JR_AUTH_HEADER`)", per `verification-delta.md` §2 — the prior
wording would have had tests clear seams they themselves rely on. It added a cross-reference row
to BC-X.14.004's error taxonomy table for the `<field>` empty-string case (Exit 64, `Field ''
not found. The field name must not be empty.`, zero cache/HTTP), citing BC-X.14.001
EC-X.14.001-15 rather than minting a new EC-X.14.004 entry. Two cosmetic fixes:
`error-taxonomy.md`'s API Commands note now calls BC-X.16.002's message block by its actual
name, "Pinned error messages", not "Behavior table"; `CANONICAL-COUNTS.md`'s Breakdown
rationale now confirms the later additions through cycle-014's own +2 (BC-X.16.001..002) are all
individually-bodied (230 range-collapsed unchanged), replacing a stale "does NOT add +1 beyond
the 656" sentence left over from an earlier count baseline. No BC or VP count changed.

**PASS-15** closed a further adversarial round, BC-side only (`verification-delta.md`'s own VP
bullets are owned concurrently by formal-verifier and were not touched). It found that PASS-14's
own cross-reference-row addition to BC-X.14.004's error taxonomy table (the `<field>` empty-string
guard, citing BC-X.14.001 EC-X.14.001-15) had landed only in `cross-cutting.md` itself and had not
been propagated to any of the summary surfaces that track BC-body changes — this file's own "BCs
NOT Touched" section, `spec-changelog.md`'s `[2.4.0]` Modified Requirements table,
`cross-cutting.md`'s own frontmatter cycle-014 trace entry, and `BC-INDEX.md`'s Section X header —
all four now note the row (documentation-only, contract unchanged, COUNT-NEUTRAL). It corrected
`spec-changelog.md`'s Summary paragraph, which attributed all 8 new VPs to issue #583 — only 6
(VP-API-QP-001..006) are #583's; the remaining two (VP-USER-LIST-PROJECT-001, VP-580-013) belong
to #862 and #861 respectively, now stated explicitly. It extended `spec-changelog.md`'s
VP-API-QP-002 and VP-API-QP-005 descriptions (after re-reading their current `cross-cutting.md`
bullets) to also name the repeated-flags argv cell plus the EC-X.16.001-12 no-override guarantee
(QP-002) and the attached-form argv cell covering EC-X.16.002-5..9 (QP-005), matching the fuller
detail already present in `cross-cutting.md`. It broadened BC-X.7.002's Resolution-order step 4
and Preconditions section in `cross-cutting.md` — previously framed as "auth errors from
`JiraClient::from_config` ... always preempt this step" — to state that `config::validate_profile_name`,
`Config::load_with` (e.g. unknown profile, malformed config) and `JiraClient::from_config`
failures all preempt this step, since all three run in `src/main.rs`'s dispatch path before
`cli::user::handle`/`handle_list` is ever reached and some of these (an invalid `--profile` name)
also exit 64, not just auth failures; mirrored verbatim in `error-taxonomy.md`'s User Commands
note. Finally, per an orchestrator-level rewording decision, it reworded the `## BC-X.14: Field
Option Discovery` subsection intro in `cross-cutting.md` — "enumerates a custom select field's
allowed options" becomes "enumerates a field's allowed options (custom select fields and, since
cycle-014 #861, system fields such as priority/resolution/versions) (cycle-014, #861)" — noted
here, in this Item 2 (#861) summary, since it touches the subsection intro rather than a single
BC's body. No BC or VP count changed.

**PASS-16** closed a further adversarial round, BC-side only (`verification-delta.md`'s own VP
bullets are owned concurrently by formal-verifier and were not touched). It found that the
"auth/config failures preempt this exit-64" concept had drifted into several inconsistent, partial
phrasings across surfaces instead of the full three-point form settled at PASS-15 (`config::
validate_profile_name`, `Config::load_with` (e.g. unknown profile, malformed config) and
`JiraClient::from_config` failures all preempt the step; some of these also exit 64). It
normalized BC-X.16.002's Preconditions in `cross-cutting.md` (previously a `ConfigError`/
`NotAuthenticated` parenthetical ending in "surface with their own exit codes") and its mirror in
`error-taxonomy.md`'s API Commands note, plus `error-taxonomy.md`'s own frontmatter cycle-014
trace line and this file's Edge Case Catalog / Error Taxonomy section, to the same settled
wording. It corrected BC-X.7.002's Fix step 1 in `cross-cutting.md`, which had modeled `user
list`'s new `--project` help text on `ComponentSubcommand::List`'s wording ("overrides the
configured default project. Required when no project is configured") without noting that
`user list`'s config fallback (`Config::project_key`, `src/config.rs`) — unlike `component
list`'s `.jr.toml`-only fallback — also falls back to the active profile's configured project
default; the step now quotes `ComponentSubcommand::List`'s help verbatim and pins the corrected
string, "Project key (overrides the configured default project). Required when no project is
configured in `.jr.toml` or the active profile." (corrected in PASS-17: `component list`'s
behavior matches; only its help text understates it.) It extended `spec-changelog.md`'s `[2.4.0]`
Impact Assessment table with STORY-B's `jr field options` README.md row and new rows for
CLAUDE.md, `docs/specs/cargo-mutants-policy.md`, and `.cargo/mutants.toml`, each marked "UPDATED
(F4)" since those files are not yet touched pending F4 implementation. It dropped the duplicated
trailing "(cycle-014, #861)" citation from the `## BC-X.14: Field Option Discovery` subsection
intro in `cross-cutting.md`, rewording to "(custom select fields and system fields such as
priority/resolution/versions, whose labels resolve correctly since cycle-014 #861)", and removed
the stray "(PASS-14)" tag from `cross-cutting.md`'s own frontmatter cycle-014 trace entry, noting
the count-neutral intro reword there instead. No BC or VP count changed.

**PASS-17** closed a further adversarial round, BC-side only (`verification-delta.md`'s own VP
bullets are owned concurrently by formal-verifier and were not touched). It corrected BC-X.7.002's
Fix step 1 rationale for why `component list`'s help text cannot be reused byte-for-byte:
`component list`'s actual resolution behavior already falls back to the active profile's
configured default (via `Config::project_key`), matching `user list`'s new behavior — only
`component list`'s own help text understates this by naming solely `.jr.toml`. It added the
`append_query_params`/`parse_query_param` symbol pair to `docs/specs/cargo-mutants-policy.md`'s
§Scope citation list in `spec-changelog.md`'s `[2.4.0]` Impact Assessment table. It synced the
EC-X.16.001-5 fragment-passthrough note's summary-quote wording with RFC 9112 §3.2's
request-target semantics (a fragment is client-side-only, never transmitted on the wire) so the
Edge Case text and the RFC citation agree verbatim. It propagated BC-X.14.004's error-taxonomy
cross-references into the newly-added BC-X.16 subsection's own error-taxonomy pointers. It added
new Edge Case EC-X.16.002-10 (`jr api /x -q` with no following token at all — `-q` as the LAST
argv token — exits 2 via clap's own argument-value validation, not `jr`'s exit-64 path). No BC or
VP count changed.

**PASS-18** is this remediation burst: P18-001 qualified the "`--field` cannot set system-typed
fields at all" capability-gap wording (`cross-cutting.md`, this file, and other cycle-014
surfaces) to note the `:id`/`:name` hinted-bypass composers (BC-3.4.028/029) already can; P18-002
is this revision-history backfill; P18-003 extended `spec-changelog.md`'s VP-API-QP-005 row with
the EC-X.16.002-10 cell. No BC or VP count changed.

**PASS-19** closed a further adversarial round, BC-side only (`verification-delta.md`'s own VP
bullets are owned concurrently by formal-verifier and were not touched). P19-001 added a
`--help`-cell assertion cross-reference to BC-X.7.002's Fix step 1 pinned help string
(VP-USER-LIST-PROJECT-001). P19-002 corrected the headline system-field example in the
`## BC-X.14: Field Option Discovery` subsection intro, the BC-X.14.003 blockquote, and
`CANONICAL-COUNTS.md` — `resolution` is usually only present in transition metadata, not on the
Create/Edit screens `jr field options` enumerates, so it was replaced with `components` (intro)
or dropped from the two exhaustive field-type lists; BC-X.14.001's own M1/M2 label-resolution
fallback list keeps `resolution` but now carries an inline caveat pointing to EC-X.14.001-5
instead. P19-003 folded `spec-changelog.md`'s VP-API-QP-005 EC-X.16.002-10 fragment into the
Description sentence and added a matching Proof Strategy entry. P19-004 added EC-X.16.002-11
(non-UTF-8 `-q` argv value rejected by clap before `parse_query_param` runs, mirroring `-H`
today). No BC or VP count changed.

**PASS-20** is this remediation burst: P20-001 corrected this file's own PASS-15 quoted
`## BC-X.14` subsection-intro text to match `cross-cutting.md`'s current wording
(`priority/components/versions`, post-PASS-19); P20-002 aligned `spec-changelog.md`'s README
Impact Assessment row with the same correction; P20-003 corrected `spec-changelog.md`'s
Migration-needed count from "two" to "three" `jr user list` behavior changes to match the three
enumerated items; P20-004 appended a `jr user list --help` integration-cell reference to
VP-USER-LIST-PROJECT-001's Proof Strategy; P20-005 marked EC-X.16.002-11 informational (inherited
clap behavior, no VP cell, same treatment as EC-X.14.001-14); P20-006 extended
`cross-cutting.md`'s cycle-014 preamble parenthetical to note BC-X.14.004's documentation-only
cross-reference row and the count-neutral §BC-X.14 intro reword. No BC or VP count changed.

**PASS-21** is this remediation burst: P21-001 reworded VP-API-QP-005's Description in
`spec-changelog.md` to scope the `--output json` envelope assertion to the exit-64 cells only,
adding that the EC-X.16.002-10 trailing-`-q` cell instead asserts clap's own exit-2 `a value is
required for` error (clap exits via `err.exit()` in `src/main.rs` before jr's own JSON error
envelope is ever constructed); P21-002 added EC-X.7.002-7 to `cross-cutting.md` documenting a
configured empty-string project default (`.jr.toml`/profile `project = ""`) as resolving to
`Some("")` through `Config::project_key`'s presence-based `Option` chain with no exit 64 — an
orchestrator-classified informational EC, no VP cell, same treatment as EC-X.14.001-14 — and
clarified Postcondition 3 to state that "present" means `Some(_)`, including `Some("")`; P21-003
corrected `spec-changelog.md`'s Migration-needed wording from "neither requires action" to "none
requires action" (three items were being described, not two); P21-004 updated
`spec-changelog.md`'s README Impact Assessment row to state both pending README edits together —
the `~L346` wording correction from "a custom field's" to "a field's" (system-typed fields are
covered too) and the existing system-field-label-resolution note; P21-005 corrected
`error-taxonomy.md`'s User Commands note to attribute `JrError::ConfigError` to a missing profile
URL and `JrError::NotAuthenticated` to missing/invalid credentials specifically, rather than
implying `JiraClient::from_config` could return either for the same condition; P21-006 appended
"(when present on the Create/Edit screen)" to every `resolution` mention in the system-typed-field
enumeration (`prd-delta.md` Item 2 Root cause, `spec-changelog.md`'s BC-X.14.001/003 Previous
cell) and reworded `cross-cutting.md`'s BC-X.14.004 empty-`<field>` cross-reference row from
"corrected cycle-014, aligns with existing code" to "added cycle-014 as a cross-reference;
documents pre-existing behavior" (the row was newly added this cycle, not a correction of a
prior-cycle row). No BC or VP count changed.

**PASS-23** is this remediation burst: P23-001 corrected `spec-changelog.md`'s `[2.4.0]` Impact
Assessment row for `docs/specs/cargo-mutants-policy.md` to describe its §Scope bullets in the
policy's own one-bullet-per-file format (`` `src/cli/api.rs` — `append_query_params`,
`parse_query_param` ``; `` `src/cli/user.rs` — `resolve_user_list_project` ``) and to note the
policy's hard-coded "Current `examine_globs` count" line is bumped 32 → 34; P23-002 corrected
`cross-cutting.md`'s BC-X.14.001 Invariant 3, which claimed `src/cli/field.rs` REUSES "the same
function" as `resolve_edit_fields`/`search_field` (BC-3.4.015) — direct inspection showed
`is_customfield_literal`/`search_field_list` in `field.rs` are a separate, mirrored
implementation of the same algorithm sharing only the cache file and cache functions
(`read_fields_cache`/`write_fields_cache`/`list_fields`), not a literal shared function; P23-003
aligned `spec-changelog.md`'s VP-API-QP-005 Proof Strategy cell's argv-cell range with its own
Description sentence, widening "attached-form argv cells (EC-X.16.002-5..9)" to "argv cells
(EC-X.16.002-5..10)" and keeping the trailing-`-q` note consistent with the Description. No BC
or VP count changed.

**PASS-24** is this remediation burst: P24-002 reworded `cross-cutting.md`'s EC-X.14.001-15 label
from "(corrected cycle-014: aligns with existing code and tests; no behavior change)" to "(added
cycle-014; documents pre-existing behavior, no behavior change)", matching the BC-X.14.004 row's
P21-006 treatment (the row documents pre-existing behavior, not a correction of prior-cycle text);
P24-003 (COSMETIC) sharpened BC-X.14.001 Invariant 3's citation from "`resolve_edit_fields`'s Step
1 and `search_field`" to "`src/cli/issue/field_resolve.rs::resolve_edit_fields`'s Step 1 and its
nested `search_field`" (verified: the nested fn exists at ~L467). No BC or VP count changed.

**PASS-25** is this remediation burst: P25-001 (LOW) corrected `cross-cutting.md`'s BC-X.14.001
Invariant 3 lead-in, which had regressed back to claiming the `customfield_NNNNN` bypass and
`fields.json` cache-first contract are "REUSED, not reimplemented — same algorithm and same cache
file" — restating PASS-23's P23-002 finding: `field.rs` mirrors, rather than shares, the algorithm
with `resolve_edit_fields`/`search_field`, sharing only the cache file/functions
(`read_fields_cache`/`write_fields_cache`/`list_fields`); P25-002 (COSMETIC) moved this file's
PASS-20 P20-006 wording — `cross-cutting.md`'s cycle-014 preamble parenthetical's two clauses
noting BC-X.14.004's documentation-only cross-reference row and the count-neutral §BC-X.14 intro
reword — from trailing after the #674 entry to immediately following "no separate count for
either amendment", matching the order the other cycle-014 clauses in that parenthetical are
introduced in; guard scripts re-run clean; P25-003 (COSMETIC) appended a note to
`spec-changelog.md`'s `[2.4.0]` Impact Assessment row for `docs/specs/cargo-mutants-policy.md`
that the policy's own `## Changelog` table also gains a newest-first row for the same
examine_globs 32 → 34 bump. No BC or VP count changed.

**PASS-26** was CLEAN — the adversarial round found no new gaps, contradictions, or missing edge
cases. One cosmetic wording fix was made (P26-002): `cross-cutting.md`'s BC-X.7.002 Preconditions
and `error-taxonomy.md`'s User Commands note both reworded "`JrError::ConfigError` for a missing
profile URL" to "`JrError::ConfigError` for a missing/unknown active profile or a missing profile
URL" — verified against `src/api/client.rs::JiraClient::from_config`, which calls both
`config.base_url()?` (raises `ConfigError` for a missing profile URL or an unconfigured profile)
and `config.active_profile_or_err()?` (raises `ConfigError` when the active profile is not in
`[profiles]`), per `src/config.rs`. No BC or VP count changed.

**PASS-27** closed a further adversarial round, BC-side only (`verification-delta.md` is owned
concurrently by formal-verifier and was not touched): P27-001 (LOW) propagated the pre-existing
Invariant 3 "mirrored copy, not a shared function" correction from `cross-cutting.md`'s BC body to
the three summary surfaces that had omitted it (`spec-changelog.md`'s BC-X.14.001 row,
`cross-cutting.md`'s own frontmatter cycle-014 trace entry, and `BC-INDEX.md`'s BC-X.14.001 Source
cell), plus this file's own Item 2 summary; P27-002 (COSMETIC) aligned the BC-X.14.003 blockquote's
and `CANONICAL-COUNTS.md`'s system-field lists with BC-X.14.001's canonical
`priority, resolution (when present on the Create/Edit screen), versions, fixVersions, components,
security, issuetype` enumeration; P27-003 (COSMETIC) corrected `spec-changelog.md`'s stale
`<field>` placeholder to `<NAME>` in its README row and added an F4 doc/test obligations pointer
(test rename + stale-comment fixes + `src/cli/mod.rs` help-text updates); P27-004 (COSMETIC) added
the "corrected cycle-014" vs. "added cycle-014" label-convention note above. No BC or VP count
changed.

**PASS-28** is this remediation burst: P28-001 (MEDIUM) verified that the CI guard in
`scripts/check-cargo-mutants-policy-citations.sh` (~L159-164) fails on a cited fn not yet defined,
then corrected `spec-changelog.md`'s `[2.4.0]` Impact rows for `docs/specs/cargo-mutants-policy.md`
and `.cargo/mutants.toml` to split the `examine_globs`/§Scope additions per story — STORY-A adds
`src/cli/user.rs`, STORY-C adds `src/cli/api.rs` — delivery is serial (A → C → B): STORY-A bumps
the policy's "Current `examine_globs` count" 32 → 33 and STORY-C bumps it 33 → 34, each with its
own newest-first change-log row, both at F4 in the PR that introduces the functions — reworded the cycle manifest's "in scope for
F6 targeted hardening" framing to "added at F4 by the story that introduces each file … F6
verifies" with a dated amendment note (F1-approved artifact), and added the matching F4 obligation
to this file's own Stories section; P28-002 (LOW) narrowed BC-X.14.001's empty-`<field>` pin claim
in the Behavior "[CORRECTED …]" passage, Invariant 4, and EC-X.14.001-15:
`test_bc_x_14_001_empty_field_name_exits_64_zero_http` pins exit 64, the message, and zero HTTP on
a cold cache, not the "before any cache read"/"zero cache reads" ordering, which is a code-level
fact verified by inspection of `resolve_field_id` (guard ~L442-447 precedes the cache read at
~L451); P28-004 (COSMETIC) appended "+ zero-flag wiremock examples" to VP-API-QP-004's Proof
Strategy cell; P28-005 (COSMETIC) added `src/cli/api.rs::normalize_path`'s own path errors (empty
path, absolute URL), which run first in `handle_api`, to BC-X.16.002's Preconditions preemption
list and `error-taxonomy.md`'s API Commands note; P28-006 (COSMETIC) broadened `BC-INDEX.md`'s
PASS-10 note from "PASS-8/PASS-9" to "later passes (e.g. PASS-8/9/15/27)". No BC or VP count
changed.

**PASS-29** is this remediation burst, prompted by a human decision at F2 review (2026-09-25):
P29-001 corrected `spec-changelog.md`'s `[2.4.0]` Affected-tests note, which had listed
`UserCommand::List.project`'s help (`~L1146`) under STORY-B's rename-and-stale-comment clause; it
is BC-X.7.002 Fix step 1 (the fallback-order help-text update), pinned by
VP-USER-LIST-PROJECT-001(d), so it belongs to STORY-A and was moved into that story's own clause.
P29-002 recorded the human decision, superseding the F1-gate's single parallel wave (Open
Question 7): the three stories are now delivered SERIALLY, A → C → B — STORY-A (#862), then
STORY-C (#583) rebased on STORY-A, then STORY-B (#861) rebased on STORY-C — because STORY-A and
STORY-C both touch `src/main.rs`, `.cargo/mutants.toml`, and `docs/specs/cargo-mutants-policy.md`,
and all three stories touch `src/cli/mod.rs` and `README.md`; this file's Stories section intro
and `cycle-manifest.md`'s Summary/Notes sections were updated accordingly, the latter via a dated
amendment note (F1-approved artifact, not rewritten). P29-003 corrected `cycle-manifest.md`'s
Summary preamble, which had claimed "none touches the others' files" — now lists the shared files
above. P29-004 (LOW) corrected `cross-cutting.md`'s EC-X.16.002-8: the prior wording implied a
hyphen-leading VALUE itself needs an attached form, when the actual clap-verified rule is that
only a raw `NAME=VALUE` argument whose NAME itself starts with `-` needs one (`-q=-x=1`,
`-q-x=1`, `--query-param=-x=1`); a hyphen-leading VALUE such as `-q startAt=-1` or `-q jql=-x`
already works space-separated, because the argv token starts with the NAME, not `-`. P29-005
corrected `cross-cutting.md`'s BC-X.14.001 Behavior "[CORRECTED cycle-014]" sentence, which still
read "shared cache, shared function, no new cache family" — an affirmative "shared function"
claim inconsistent with Invariant 3's own "mirrored, not shared" finding (PASS-23/25/27) — reworded
to "shared cache and shared `list_fields`/`read_fields_cache`/`write_fields_cache`, no new cache
family; the resolution logic itself is mirrored, not shared (Invariant 3)"; no other affirmative
"shared function" wording was found elsewhere in BC-X.14.001 (grepped and confirmed). P29-006
(COSMETIC) tagged BC-X.14.001's Edge Cases EC-X.14.001-8 through EC-X.14.001-13 — new this cycle
but previously untagged — with a single group label ("new Edge Cases added this cycle, #861")
rather than six repeated per-line tags, and reworded EC-X.14.001-14's "(corrected cycle-014:
aligns with existing code and tests; no behavior change)" to "(added cycle-014; documents
pre-existing behavior)", matching the "added" vs. "corrected" label convention (PASS-27 P27-004):
the entry is a newly-added Edge Case documenting pre-existing, unmodified behavior, not a
correction of prior-cycle text. EC-X.14.001-15 is unchanged. No BC or VP count changed.

**Net effect.** No BC or VP count changed across this remediation work: `cross-cutting.md` stays
at `definitional_count: 96` / `total_bcs: 162` cumulative, and guard scripts (above) confirm 772
total across all files. All changes were prose corrections, precision additions, and
propagation fixes to existing BC bodies, plus a small number of new Edge Cases added inline under
each affected BC's own Edge Cases section in `cross-cutting.md` (BC-X.7.002, BC-X.14.001,
BC-X.16.001, BC-X.16.002) — see those sections for the current, authoritative enumeration rather
than a list here, which would drift on the next pass; no new `#### BC-` headings resulted from
this remediation work itself.

---

## Open Questions

None — all F1 Open Questions were RESOLVED at the human gate (see
`.factory/cycles/cycle-014/phase-f1-delta-analysis/delta-analysis.md` §Open Questions and
§F1 Gate Outcome). The three items carried forward from F2 — the NAME/VALUE trimming
default, the `--project ""` pass-through default, and the `-q` NAME collision no-override/dedup
default — are recorded under "Decisions confirmed during F2 review" above, now settled
(human-confirmed 2026-09-25, D-380), not Open Questions in the F1 sense.
