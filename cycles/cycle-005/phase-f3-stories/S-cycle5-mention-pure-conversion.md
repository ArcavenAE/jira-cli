---
document_type: story
level: ops
story_id: "S-cycle5-mention-pure-conversion"
epic_id: "ADF-MENTIONS-1"
title: "adf.rs pure mention conversion — bracket-form + @Name detection/emission, \\@ escape, reverse-path render"
wave: 1
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
  - ".factory/specs/prd/bc-7-output-render.md"
  - ".factory/specs/architecture/decisions/ADR-0023-markdown-mention-pure-effectful-conversion-seam.md"
  - ".factory/phase-f2-spec-evolution/architecture-delta.md"
  - ".factory/phase-f2-spec-evolution/verification-delta-674.md"
  - ".factory/specs/prd/holdout-scenarios.md"
input-hash: "90a5d3a"
traces_to: ".factory/specs/prd/bc-7-output-render.md"
cycle: cycle-005-adf-mentions
estimated_effort: large
estimated_days: 5
target_module: src/adf.rs
subsystems: ["SS-08"]
depends_on: []
blocks: ["S-cycle5-mention-resolution-wiring"]
behavioral_contracts:
  - "BC-7.2.016"
  - "BC-7.2.017"
  - "BC-7.2.018"
  - "BC-7.2.019"
  - "BC-7.2.004"
bcs:
  - "BC-7.2.016"
  - "BC-7.2.017"
  - "BC-7.2.018"
  - "BC-7.2.019"
  - "BC-7.2.004"
verification_properties:
  - "VP-674-001"
  - "VP-674-002"
  - "VP-674-004"
  - "VP-674-005"
  - "VP-674-006"
  - "VP-674-007"
  - "VP-674-008"
  - "VP-674-012"
  - "VP-674-018"
  - "VP-674-019"
holdout_anchors: ["H-NEW-MENTION-005", "H-NEW-MENTION-006", "H-NEW-MENTION-007"]
nfr_anchors: []
adr_refs: ["ADR-0023"]
sd_refs: []
priority: P0
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-005/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: tdd
tdd_mode: strict
module_criticality: CRITICAL
points: 13
acceptance_criteria_count: 15
assumption_validations: []
risk_mitigations: []
created: "2026-09-06"
version: "1.0"
last_updated: "2026-09-06"
breaking_change: false
retroactive: false
origin: >
  cycle-005 adf-mentions (GitHub #674), Wave 1 of 2, no deps. This is the
  pure-core half of the feature: every function and data type this story adds
  lives in src/adf.rs, is synchronous, takes no JiraClient, and performs zero
  HTTP. It is independently BUILDABLE, TESTABLE, and MERGEABLE without Story
  B or any network-mocking infrastructure — but it is NOT independently
  ACCEPTANCE-COMPLETE for the feature: see "Interim Shippability Note" below
  for the accepted, time-boxed unvalidated-bracket-conversion window this
  story's merge opens (F-M-01). This is the FIRST src/adf.rs feature cycle (of
  ten, #470->#674) that needs data obtainable only through network I/O for
  full end-to-end value — ADR-0023 is the architectural precedent this story
  implements. Story B (S-cycle5-mention-resolution-wiring) depends on this
  story because the effectful resolver it adds calls find_mention_candidates
  (pure) and feeds a MentionResolutions map into markdown_to_adf_with_mentions
  (pure) — both defined here.
---

> **tdd_mode:** `strict` — full TDD Iron Law enforced. `src/adf.rs` is the single
> most heavily hardened, highest-blast-radius file in the codebase (275 pre-#674
> `#[test]`s, `MAX_ADF_DEPTH`, the INV-1 CR/LF chokepoint, code-mark exclusivity) —
> not a facade/DTU candidate.

> **Execute:** `/vsdd-factory:deliver-story S-cycle5-mention-pure-conversion`

# S-cycle5-mention-pure-conversion — Pure markdown-mention conversion in `adf.rs`

## Anchor Justification

**Subsystem anchor:** `SS-08` (Cross-cutting Utilities) owns this story's scope because
`src/adf.rs` is registered there in the ARCH-INDEX.md Subsystem Registry, and every
change this story makes (three new pure functions, two new pure data types, one new
`AdfRenderer::render_node` match arm) lands inside that existing file — no new
subsystem is introduced, per `architecture-delta.md` §1/ADR-0023's own "no new
subsystem, no structural redesign" Rationale bullet.

**Dependency anchors:** `depends_on: []` — this story is the pure-core half of the
feature and needs nothing from the effectful resolver; it is deliberately ordered
FIRST so it can be built, tested, and reviewed independently of any network-mocking
infrastructure. `blocks: [S-cycle5-mention-resolution-wiring]` because Story B's new
`src/cli/issue/mentions.rs::resolve_mentions` calls `adf::find_mention_candidates`
(defined here) to discover candidates before resolving them over HTTP, and every one
of Story B's four wiring call sites calls `adf::markdown_to_adf_with_mentions`/
`adf::markdown_to_adf_no_mentions` (also defined here) to emit the final ADF body —
Story B cannot compile, let alone be tested, until this story's public API exists.

## Source of Truth

- `.factory/specs/prd/bc-7-output-render.md` §7.2, BC-7.2.004 (amended), BC-7.2.016,
  BC-7.2.017, BC-7.2.018, BC-7.2.019 (all read in full for this story).
- `ADR-0023-markdown-mention-pure-effectful-conversion-seam.md` §1 (two pure
  entrypoints), §2 (`MentionCandidates`/`MentionResolutions` ownership), §4 (the
  `\@`-escape mechanism, code-context-guarded pre-parse sentinel protect/restore,
  two-codepoint scheme), §5 (definitive post-`finish()` pass order), §6
  (`--no-mentions` flag shape — CLI wiring itself is Story B's scope, but the third
  pure entrypoint `markdown_to_adf_no_mentions` this section specifies is built here).
- `architecture-delta.md` §2.1 (new/modified component definitions for `src/adf.rs`),
  §4 (the two flagged design risks — `\@` escape feasibility, pass-order definitive
  fix).
- `verification-delta-674.md` §4 (pure-conversion VPs), §4A (`--no-mentions` VP,
  pure-side half), §5 (reverse-path VPs), §9 (mutation-testing note — `src/adf.rs` is
  ALREADY in `.cargo/mutants.toml` examine_globs, no action needed by this story).
- `.factory/specs/prd/holdout-scenarios.md` Group 21, H-NEW-MENTION-005 (`\@`
  escape), H-NEW-MENTION-006 (`--no-mentions`, pure-side half — the wiremock
  zero-HTTP half is Story B's), and H-NEW-MENTION-007 (reverse-path render).
  **Not anchored here (F3 adversarial pass-1, F-H-01):** H-NEW-MENTION-001 is an
  effectful MUST-PASS scenario (`GET /user?accountId` preflight + `POST` +
  GET-before-POST ordering + `attrs.text` population) that this story cannot
  satisfy on its own — it is owned/anchored by
  `S-cycle5-mention-resolution-wiring` (Story B). This story's ONLY relationship
  to H-NEW-MENTION-001 is that it provides the pure bracket-form EMISSION
  primitive (`markdown_to_adf_with_mentions`) Story B's resolver consumes to
  satisfy it — see this story's `holdout_anchors` frontmatter, which correctly
  omits H-NEW-MENTION-001.

## Narrative

As a `jr` maintainer, I want the markdown-to-ADF and ADF-to-text converters in
`src/adf.rs` to recognize `[~accountid:<id>]` and `@Name` mention syntax and render
`mention` nodes back to readable `@name` text, entirely through pure, synchronous,
zero-HTTP functions, so that the effectful resolution work (Story B) has a stable,
independently-testable pure core to build on, and so that `adf.rs`'s nine-cycle
purity invariant is never put at risk by this feature.

## Behavioral Contracts

| BC | Status | What this story delivers |
|----|--------|---------------------------|
| BC-7.2.016 | NEW | `find_mention_candidates`/`markdown_to_adf_with_mentions`/`markdown_to_adf_no_mentions` — bracket-form `[~accountid:<id>]` detection + unconditional emission (opaque id, never UUID-validated); the definitive five-step post-`finish()` pass order; the `--no-mentions` bypass entrypoint |
| BC-7.2.017 | NEW | `attrs.text = "@" + display_name` population on a resolved mention node, with leading-`@` normalization and control-character sanitization |
| BC-7.2.018 | NEW | `@Name` candidate-detection grammar in `find_mention_candidates` (start-boundary, single-token/`/`-stop, trailing-punctuation trim) and the finalized `\@` escape mechanism (`protect_mention_escapes`, two-codepoint sentinel protect/restore, code-range-guarded) |
| BC-7.2.019 | NEW | `AdfRenderer::render_node`'s new `"mention"` match arm — three-way fallback (`attrs.text` verbatim -> `"@" + attrs.id` -> literal `"@?"`) |
| BC-7.2.004 | AMENDED | The `_` catch-all's silently-dropped-node enumeration narrows from `{mention, emoji, inlineCard, media}` to `{emoji, inlineCard, media}` — `mention` is carved out by the new BC-7.2.019 arm, inserted BEFORE the catch-all |

## Acceptance Criteria

### AC-001 — Bracket-form emission is unconditional and opaque
`markdown_to_adf("[~accountid:" + S + "]")`, for any `S` matching `[A-Za-z0-9:_-]+`,
emits exactly one `mention` node `{"type":"mention","attrs":{"id":S}}`, correctly
nested inside its enclosing paragraph, with the id preserved byte-for-byte (never
regex-validated or normalized as a UUID).
(traces to BC-7.2.016 postcondition 1 / point 1,5; VP-674-001)

### AC-002 — Bracket-form start-boundary and skip-context rules
A candidate `[~accountid:` may start only at text-node start or immediately after
whitespace or one of `*_~(`; a mid-word start (`foo[~accountid:X]`) is left literal.
The pass never converts a candidate inside `codeBlock` content or a `code`-marked
text node; it does NOT exclude `link`-marked text (a bracket-form span inside
existing link text still converts, per EC-7.2.016-4).
(traces to BC-7.2.016 point 2,3; VP-674-006)

### AC-003 — Two pure entrypoints, unchanged `markdown_to_adf` signature
`find_mention_candidates(markdown: &str) -> Result<MentionCandidates, JrError>` is a
read-only scan performing zero conversion and zero HTTP.
`markdown_to_adf_with_mentions(markdown: &str, resolved: &MentionResolutions) -> Result<Value, JrError>`
is the extended real emitter. `markdown_to_adf(markdown: &str) -> Result<Value, JrError>`
becomes the one-line wrapper `markdown_to_adf_with_mentions(markdown, &MentionResolutions::empty())`
— its public signature is byte-for-byte unchanged, and all 275 pre-#674 `#[test]`s
pass without modification.
(traces to BC-7.2.016 postcondition 6, invariant [pure-fn signature]; VP-674-004)

### AC-004 — `--no-mentions` pure bypass entrypoint
`markdown_to_adf_no_mentions(markdown: &str) -> Result<Value, JrError>` is
byte-for-byte equivalent to `markdown_to_adf`'s pre-#674 behavior: both mention
forms are left as literal text, zero mention nodes, zero HTTP. This function does
NOT call `protect_mention_escapes` (per ADR-0023 §4 pass-2/L-3 correction) — it
relies on pulldown-cmark's native `\@`->`@` handling, which already matches its
byte-for-byte contract with zero extra code.
(traces to BC-7.2.016 postcondition 7; VP-674-019 part (a))

### AC-005 — `attrs.text` population, both forms
The pure emitter populates `attrs.text` on a `mention` node whenever `resolved` has
a matching entry for the span (bracket form keyed by the literal accountId; `@Name`
form keyed by the POST-TRIM `@`-prefixed candidate token). `attrs.text` is built as
`"@" + display_name`, with (a) leading-`@` normalization (`display_name.trim_start_matches('@')`
before the single `@` prefix, so a bot display name `"@build-bot"` yields
`"@build-bot"`, never `"@@build-bot"`) and (b) control-character sanitization
(`\r`/`\n`/other C0 control chars in `display_name` replaced with a single space,
BEFORE the leading-`@` step). When `resolved` has no entry, the mention node is
still emitted with `attrs.id` only — `attrs.text` is OMITTED (not a placeholder key).
(traces to BC-7.2.017 postcondition 1,2,3; invariant [control-char sanitization];
VP-674-002 emitter half)

### AC-006 — `@Name` detection grammar
`find_mention_candidates` recognizes a single-token `@Name` candidate per: (1)
start-boundary identical to the bracket form; (2) charset `[A-Za-z0-9._-]`
excluding `/` (so `@angular/core` yields candidate `angular` only); (3) a
trailing-punctuation trim step stripping trailing `.`/`-`/`_` from the captured
token (so `Thanks @jsmith.` yields candidate `jsmith`, not `jsmith.`) — a token
that trims to empty is discarded entirely, not a candidate; (4) `@a @b` (space
between) yields two candidates; `@a@b` (no space) yields exactly one (`a`). The
REPORTED span is the POST-TRIM token, uniformly, in `MentionCandidates`, the
`MentionResolutions` key space, and the tree-replacement span.
(traces to BC-7.2.018 point 1,2,3,4; VP-674-018)

### AC-007 — `\@` escape mechanism (F4 SPIKE — see contingency note below)
A shared pure helper `protect_mention_escapes(markdown: &str) -> String` runs at
the top of BOTH `find_mention_candidates` and `markdown_to_adf_with_mentions`
(never `markdown_to_adf_no_mentions`, per AC-004). It performs, in order: (1) a
disposable `into_offset_iter()` code-range guard scan collecting `Event::Code`/
`Tag::CodeBlock` byte ranges against the untouched raw string, discarding
everything else; (2) a collision pre-pass remapping any pre-existing literal
`U+E000` in the non-code complement to `U+E001`; (3) a backslash-parity scan
(odd consecutive `\` before `@` = escaped) replacing each unescaped `\@` with
`U+E000`, skipping code ranges entirely (byte-for-byte untouched, e.g.
`` `\@x` `` stays literal `` `\@x` ``). A paired sentinel-restore pass (position
per AC-009) reverses both remaps (`U+E000` -> `@`, then `U+E001` -> `U+E000`),
itself skipping `code`-marked/`codeBlock` content as defense-in-depth. The
OBSERVABLE property — odd backslash count before `@` yields literal `@Name`
(no mention, no candidate reported); even backslash count yields a literal `\`
followed by a genuine mention candidate — is testable and REQUIRED regardless of
mechanism.
**F4-CONTINGENCY (VP-674-012, hard gate per verification-delta-674.md §11 item 0):**
if empirical F4 testing shows the chosen sentinel codepoints or the code-range
guard's boundary handling do not survive pulldown-cmark 0.13's full enabled
`Options` set cleanly, the implementer MUST NOT silently ship without the escape
and MUST NOT silently fall back to `--no-mentions`-only. Route a scope-cut decision
back to the orchestrator per the documented fallback order (try a different PUA
codepoint first; only fall back to declaring `\@` infeasible if no sentinel
codepoint proves clean) BEFORE closing this AC.
(traces to BC-7.2.018 point 6; VP-674-012)

### AC-008 — Definitive five-step post-`finish()` pass order
Both `find_mention_candidates`'s own build (steps 0-3 only) and
`markdown_to_adf_with_mentions`'s build (all five steps) apply, in this exact
order: `0. protect_mention_escapes` (pre-parse) -> `1. parse+finish()` -> `2. autolink_bare_urls`
-> `3. convert_mentions` (candidate-collection in `find_mention_candidates`'s case,
no mutation) -> `4. sentinel-restore` -> `5. assign_local_ids` (LAST, unconditionally,
for ALL pipelines including pre-#674 ones with no mentions — a real, in-scope
reordering of `assign_local_ids`'s previously-documented position, behavior-preserving
for every pre-#674 test since neither `mention` nor `link`-marked text runs
currently receive a `localId`).
(traces to BC-7.2.016 point 10; VP-674-006)

### AC-009 — `convert_mentions`/`find_mention_candidates` skip rule is `code`-only
`convert_mentions` and `find_mention_candidates` skip ONLY text carrying a `code`
mark or `codeBlock` content — they do NOT skip `link`-marked text (a bracket-form
or `@Name` span inside existing link text still converts, per EC-7.2.016-4/
EC-7.2.018-6). The URL-interior false-positive case (`http://example.com/@handle`)
is excluded solely by the start-of-node/whitespace boundary rule (AC-002/AC-006
point 1), independent of any mark.
(traces to BC-7.2.016 point 3,10; VP-674-006)

### AC-010 — Depth guard and INV-1 hold with mentions
Markdown nested >=256 levels containing a mention token still exits via the
`MAX_ADF_DEPTH` "nesting too deep" error (exit 64), never a stack overflow. No
`text` node emitted by `markdown_to_adf_with_mentions` over any generated input
contains a raw `\n`/`\r`; a `mention` node's `attrs.text` is always a single-line
string (enforced by AC-005's control-character sanitization step).
(traces to BC-7.2.016 point 8,9; VP-674-006)

### AC-011 — Reverse-path three-way mention render
`AdfRenderer::render_node` gains a new `"mention"` match arm, inserted BEFORE the
`_` catch-all, as a LEAF render (never calls `render_children`): (1) `attrs.text`
present and non-empty -> render verbatim (no double `@`); (2) else `attrs.id`
present and non-empty -> render `"@" + id`; (3) else -> literal `"@?"`. Empty-string
values are treated identically to absent (no special empty-string branch).
(traces to BC-7.2.019 postcondition 1,2,3; VP-674-007)

### AC-012 — BC-7.2.004 amendment: `emoji`/`inlineCard`/`media` still dropped
The `_` catch-all's silently-dropped-node set narrows from `{mention, emoji,
inlineCard, media}` to `{emoji, inlineCard, media}` — `mention` is now handled by
AC-011's new arm. `emoji`/`inlineCard`/`media` remain UNCHANGED, silently dropped,
confirmed by a differential test that AC-011's addition does not accidentally
start rendering them.
(traces to BC-7.2.004 amended postcondition; VP-674-007)

### AC-013 — Reverse-path never panics at any nesting
A `mention` node placed at any legal inline-content position (paragraph, listItem,
panel, tableCell, taskItem, blockquote, heading), with arbitrary `attrs` shapes
(id-only / text-only / both / neither / empty-strings / non-string junk values),
never causes `adf_to_text` to panic or return `Err` — it always renders one of the
three fallback forms and never recurses (a `mention` is a leaf node with no
`content` array).
(traces to BC-7.2.019 invariant [no-panic, no-recursion]; VP-674-008)

### AC-014 — `MentionCandidates`/`MentionResolutions` key-space non-collision
`MentionResolutions` is implemented so a lookup by one mention form's key can
never accidentally resolve against an entry inserted under the other form's key
(e.g., two internal maps, or a single map keyed by a tagged/enum key) — never a
bare `HashMap<String, _>` relying on the improbability that a bracket-form id and
an `@Name` span's literal text happen to collide.
(traces to BC-7.2.016 point 6 [F4 IMPL DETAIL — key-space non-collision note];
no dedicated VP — code-review-enforced, see Architecture Compliance Rules)

### AC-015 — Mark-composition empirical check for mention nodes (F4, VP-674-005)
The implementer ATTEMPTS the VP-674-005 empirical check for EC-7.2.016-5: does a
`mention` node produced from a mark-wrapped candidate (e.g. `**[~accountid:X]**`,
`_@jsmith_`) yield ADF the Atlaskit `adf-schema` accepts? This is not resolvable
statically from this repo — the implementer either (a) validates against a real
or vendored `adf-schema` validator, or (b) round-trips a mark-wrapped mention
through a sandbox/live Jira `PUT` and observes whether it is accepted or
rejected. **Outcome A (schema-invalid):** the observed rule is encoded as an
example-anchor regression test pinning the exact input, and the offending marks
are stripped from the `mention` node's run at emission time, mirroring the
`code`-mark-exclusivity precedent set by BC-7.2.015/issue #571 (`push_code`
already strips typographic marks from code spans for the identical
schema-composition reason). **Outcome B (schema-valid):** an example-anchor test
pins the mark-preserving behavior instead; no stripping code is added. Either
outcome is an acceptable closure of this AC — the ONLY failure mode is a SILENT
skip (neither branch attempted, no example anchor written, VP-674-005 left with
no test at all).
(traces to BC-7.2.016 edge case EC-7.2.016-5 [mark-composition, not resolvable
statically]; VP-674-005)

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|---------------|
| `find_mention_candidates` | `src/adf.rs` (NEW) | Pure Core (read-only scan, zero HTTP) |
| `protect_mention_escapes` | `src/adf.rs` (NEW) | Pure Core (string transform, zero HTTP) |
| `markdown_to_adf_with_mentions` | `src/adf.rs` (NEW) | Pure Core |
| `markdown_to_adf_no_mentions` | `src/adf.rs` (NEW) | Pure Core |
| `markdown_to_adf` (wrapper) | `src/adf.rs` (MODIFIED — body only, signature unchanged) | Pure Core |
| `convert_mentions` (internal pass) | `src/adf.rs` (NEW, private) | Pure Core |
| `MentionCandidates`, `MentionResolutions` | `src/adf.rs` (NEW data types) | Pure data, no I/O |
| `AdfRenderer::render_node`'s `"mention"` arm | `src/adf.rs` (MODIFIED) | Pure Core |

## UX Screens

N/A — CLI-only, no UI surface.

## Design System Components

N/A — not a UI story.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-7.2.016-1 | Mid-word bracket start (`foo[~accountid:abc]`) | No match, literal text |
| EC-7.2.016-2 | Malformed bracket (empty id, in-id whitespace) | Not a candidate, no error raised |
| EC-7.2.016-3 | `` `[~accountid:X]` `` inside inline code/fence, incl. `` `\@x` `` | Never converted; sentinel substitution skips code ranges byte-for-byte |
| EC-7.2.016-4 | Bracket span inside markdown link text `[[~accountid:X]](url)` | Inner span still converts (link marks NOT excluded) |
| EC-7.2.016-5 | Mark composition on a `mention` node (e.g. `**[~accountid:X]**`) | F4 empirical schema check, ATTEMPTED by AC-015 (VP-674-005) — Atlaskit `adf-schema` question, not resolvable statically; see AC-015 for the two acceptable outcomes |
| EC-7.2.016-6 | Same-document `[~accountid:X]: <url>` reference definition collision | Resolves as a link, not a mention; no special-casing |
| EC-7.2.016-7 | `--no-mentions` suppresses bracket-form too | `markdown_to_adf_no_mentions` leaves `[~accountid:X]` as literal text |
| EC-7.2.017-1 | Display name with no special characters (`"Jane Doe"`) | `attrs.text = "@Jane Doe"` — a JSON string value, no markdown re-parsing |
| EC-7.2.017-2 | Bracket form, unvalidated (bare `markdown_to_adf` caller, no resolution ever attempted) | `{"type":"mention","attrs":{"id":"X"}}` — `attrs.text` key OMITTED entirely, not empty-stringed |
| EC-7.2.017-3 (cross-story) | `@Name` form always has `attrs.text` when resolved | No code path emits `attrs.id` with no `attrs.text` for a resolved `@Name` — depends on Story B's resolver populating both fields atomically in one `MentionResolutions` entry (Story B AC-001/AC-002); this story's AC-005 is the consuming half |
| EC-7.2.017-4 | Display name already `@`-prefixed (`"@build-bot"`) | Leading `@`s stripped before the single `@` prefix is re-applied — `attrs.text = "@build-bot"`, never `"@@build-bot"` |
| EC-7.2.017-5 | Pathological control characters in `display_name` (e.g. embedded `\n`) | Sanitized to a space before the leading-`@` step — `attrs.text` never contains a raw `\n`/`\r` (holds INV-1) |
| EC-7.2.018-1 | Email local part (`user@example.com`) | Excluded by mid-word boundary rule, zero candidates |
| EC-7.2.018-2 | npm scoped package (`@angular/core`) | Candidate is `angular` only, `/core` untouched literal text |
| EC-7.2.018-3 | Java annotation in prose (`add @Override to the method`, not inside code marks) | `@Override` IS a valid candidate per the detection grammar; whether it hard-errors or resolves to a real Jira user is a resolution-layer concern (Story B), not a detection-layer one — detection-layer negative documented here for completeness |
| EC-7.2.018-4 | Slack-style broadcast tokens (`@channel`/`@here`) | Match the grammar as candidates with no corresponding user; zero-match hard-error is a resolution-layer concern (Story B) — detection-layer negative documented here for completeness |
| EC-7.2.018-5 | Trailing punctuation, both non-charset (`@jsmith!`) and in-charset (`@jsmith.`) forms | Both trim to candidate `jsmith` |
| EC-7.2.018-6 | `@Name` inside an existing link/code mark (e.g. `[@jsmith](url)`) | Excluded only when `code`-marked/`codeBlock`; NOT excluded when `link`-marked — a bare `@Name` inside markdown link text still converts (mirrors EC-7.2.016-4's treatment of the analogous bracket-form case; see AC-009) |
| EC-7.2.018-7 | Multi-word display name (`@Jane Doe`) | Detects `@Jane` as the candidate (space terminates the token); `Doe` is untouched literal text — documented non-support, the bracket form is the escape hatch |
| EC-7.2.018-8 | `\@jsmith` vs `\\@jsmith` (odd vs. even backslash parity) | Odd -> literal `@jsmith`, no candidate; even -> literal `\` + genuine mention candidate |
| EC-7.2.018-9 | Trim-to-empty (`@.`, `@---`) | Not a candidate at all, discarded entirely |
| EC-7.2.018-10 | Adjacent mentions `@a @b` vs. `@a@b` | Two candidates vs. one candidate (`a` only) |
| EC-7.2.019-1 | `attrs.text` present (`{"id":"X","text":"@Jane Doe"}`) | Renders `"@Jane Doe"` verbatim — no double `@` |
| EC-7.2.019-2 | `attrs.text` absent, `attrs.id` present (`{"id":"X"}`) | Renders `"@X"` — the shape for a bare/unresolved mention `jr` wrote via bracket-form (EC-7.2.017-2) or an externally-produced mention |
| EC-7.2.019-3 | Neither present (`{}` or `attrs` missing) | Renders the literal `"@?"` fallback |
| EC-7.2.019-4 | Empty-string `attrs.text`/`attrs.id` | Treated identically to absent, falls through the three-way chain |
| EC-7.2.019-5 | Round-trip stability is POST-fetch only, not dry-run preview | Dry-run preview shows the raw ADF tree directly (Story B's scope), never passed through `adf_to_text` |

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|---------------|
| `find_mention_candidates` | Pure Core | Read-only tree scan; no `Client`/`async`, zero HTTP |
| `protect_mention_escapes` | Pure Core | String transform using a disposable `into_offset_iter()` scan; no I/O |
| `markdown_to_adf_with_mentions` | Pure Core | Extended `markdown_to_adf` body; takes a caller-supplied `MentionResolutions` value, never fetches one |
| `markdown_to_adf_no_mentions` | Pure Core | Byte-for-byte pre-#674 `markdown_to_adf` behavior |
| `AdfRenderer::render_node` (`"mention"` arm) | Pure Core | Leaf string-formatting logic, no I/O |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|---------------|-----------------|
| This story spec | ~4,800 |
| BC-7.2.016/017/018/019/004 (full bodies) | ~9,000 |
| ADR-0023 (full) | ~7,500 |
| `src/adf.rs` (existing `autolink_bare_urls`/`find_bare_url_spans`/`AdfRenderer`, ~400 LOC read for precedent) | ~5,000 |
| New/modified `src/adf.rs` code (est. ~350-500 LOC) | ~4,500 |
| proptest + example test suites (est. ~600-900 LOC) | ~7,000 |
| **Total** | **~37,800** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~19%** |

Within budget; on the higher end due to `adf.rs`'s size and the number of pure
functions this story adds — if F4 discovers the `\@`-escape spike needs
substantially more exploratory iteration than estimated, consider splitting the
escape mechanism into its own follow-up fix-PR rather than blocking this story's
merge (see the F4-contingency note on AC-007).

## Tasks

1. [ ] Read `src/adf.rs::autolink_bare_urls`/`find_bare_url_spans`/`AdfRenderer::render_node`
   in full — these are the structural precedents this story's new passes mirror.
2. [ ] Write failing tests for `find_mention_candidates`'s bracket-form detection
   grammar (AC-001, AC-002).
3. [ ] Implement `find_mention_candidates` (bracket-form half only, first pass).
4. [ ] Write failing tests for the `@Name` detection grammar (AC-006), including the
   EC-7.2.018-1/-2/-5/-9/-10 anchor matrix + a proptest generator (VP-674-018).
5. [ ] Extend `find_mention_candidates` with `@Name` detection.
6. [ ] **F4 SPIKE (AC-007):** implement `protect_mention_escapes` per ADR-0023 §4's
   revised (b) mechanism. Write the odd/even backslash-parity regression pin FIRST
   (RED), then implement. If the spike concludes the mechanism is impractical after
   a reasonable, documented attempt (both the primary sentinel scheme AND at least
   one alternate PUA codepoint), STOP and escalate a scope-cut decision to the
   orchestrator before proceeding — do not silently skip this AC or silently ship
   without the escape.
7. [ ] Write failing tests for `markdown_to_adf_with_mentions`'s bracket-form
   unconditional-emission property (AC-001, VP-674-001) and `MentionResolutions`
   lookup/`attrs.text` population (AC-005, VP-674-002 emitter half).
8. [ ] Implement `markdown_to_adf_with_mentions`, `MentionCandidates`,
   `MentionResolutions` (with the key-space non-collision design, AC-014).
9. [ ] Implement the `markdown_to_adf` one-line wrapper; run the full pre-#674 test
   suite (275 tests) and confirm zero regressions (AC-003).
10. [ ] Write failing tests for `markdown_to_adf_no_mentions`'s byte-for-byte
    pre-#674-equivalence property (AC-004, VP-674-019 part a).
11. [ ] Implement `markdown_to_adf_no_mentions`.
12. [ ] Pin the definitive five-step pass order (AC-008) with an explicit ordering
    test; move `assign_local_ids` to run last, unconditionally, and confirm this
    reordering changes zero pre-#674 assigned IDs.
13. [ ] Write failing depth-guard/INV-1 regression-pin tests (AC-010, VP-674-006).
14. [ ] Write failing tests for the reverse-path `"mention"` render arm (AC-011,
    VP-674-007) and the BC-7.2.004 differential (`emoji`/`inlineCard`/`media` still
    dropped, AC-012).
15. [ ] Implement `AdfRenderer::render_node`'s new `"mention"` arm.
16. [ ] Write the reverse-path no-panic/no-recursion proptest across legal inline
    positions (AC-013, VP-674-008).
17. [ ] **VP-674-005 empirical check (AC-015):** attempt the mark-composition
    schema-validity check for a mention node wrapped in typographic marks
    (`**[~accountid:X]**`, `_@jsmith_`) against the Atlaskit `adf-schema`
    (validator or sandbox/live-Jira round-trip). Encode whichever outcome is
    observed (schema-invalid -> strip marks at emission + example-anchor
    regression test, mirroring BC-7.2.015's `push_code` precedent;
    schema-valid -> example-anchor test pinning mark-preserving behavior). Do
    NOT close this task with neither branch attempted.
18. [ ] Verify purity boundaries against the table above — grep for `async`/`Client`/
    `reqwest` in every new function signature, must find none.
19. [ ] Update STATE.md (state-manager, not this story's implementer).
20. [ ] Verify Red Gate (all new tests fail before implementation).
21. [ ] Refactor.
22. [ ] Confirm `.cargo/mutants.toml` already covers `src/adf.rs` (per
    `verification-delta-674.md` §9 — no action needed; do not add a redundant glob).
23. [ ] Add a CHANGELOG entry under `[Unreleased] > Added` describing the new
    markdown-mention pure conversion (bracket-form + `@Name` detection, `\@` escape,
    reverse-path render), before creating the PR.

## Previous Story Intelligence

N/A — first story in the `ADF-MENTIONS-1` epic; no completed cycle-005 stories exist
yet. Cross-reference for the implementer: this story's design directly extends
`autolink_bare_urls`/`find_bare_url_spans` (issue #473, bare-URL autolinking) —
read that pass first as the closest existing precedent for a post-`finish()`
tree-walk that splits text nodes and applies a boundary rule. The `\@`-escape
mechanism (AC-007) has no prior `adf.rs` precedent — no earlier cycle needed a
pre-parse source-mutation pass; `test_markdown_escape_literal_asterisk` is cited
by BC-7.2.018/ADR-0023 as evidence that CommonMark's own backslash handling
happens upstream of any post-`finish()` walk, which is why the escape can't be
solved by walking the built tree alone.

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|-----------|
| `adf.rs`'s pure/synchronous/zero-HTTP invariant is preserved for every new function | ADR-0023 §3, `system-overview.md` §Purity Boundary | Code review: no `async fn`, no `Client`/`JiraClient`/`reqwest` parameter anywhere in this story's new signatures |
| `markdown_to_adf`'s public signature is unchanged | BC-7.2.016 point 6 | AC-003's full pre-#674 test-suite regression run |
| `markdown_to_adf_no_mentions` MUST NOT call `protect_mention_escapes` | ADR-0023 §4 pass-2/L-3 correction | Code review; AC-004's differential test |
| `convert_mentions`/`find_mention_candidates` skip ONLY `code`/`codeBlock`, never `link` | ADR-0023 §5 pass-2/H-2 correction | AC-009's EC-7.2.016-4/EC-7.2.018-6 regression tests |
| `assign_local_ids` runs LAST, unconditionally, after every other post-`finish()` pass | ADR-0023 §5 | AC-008's explicit ordering test |
| `MentionResolutions` uses a collision-safe key design (never a bare single-namespace map) | BC-7.2.016 point 6 [F4 IMPL DETAIL] | Code review of the `MentionResolutions` type definition (AC-014) |
| `protect_mention_escapes` is a single shared helper, never duplicated as two independently-maintained backslash-parity checks | ADR-0023 §4 | Code review — grep for a second backslash-parity implementation |
| Zero-warnings policy | CLAUDE.md | `cargo clippy -- -D warnings` |

## Library & Framework Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| `pulldown-cmark` | existing pinned version, unchanged | `into_offset_iter()` for the code-range guard scan (AC-007); no new feature flags needed beyond what `markdown_to_adf` already enables |
| `proptest` (existing dev-dependency) | existing pinned version | Property tests for VP-674-001/006/008/018 |
| `serde_json` (existing) | unchanged | `Value` construction for `mention` nodes |

No new external dependency is introduced by this story.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/adf.rs` | MODIFY | All new pure functions/types/passes; the `markdown_to_adf` wrapper; the `AdfRenderer::render_node` `"mention"` arm; the BC-7.2.004 catch-all narrowing |
| `CHANGELOG.md` | MODIFY | `[Unreleased] > Added` entry per Task 22 |

**Files NOT to touch:** `src/cli/issue/mentions.rs` (does not exist yet — Story B's
scope), `src/cli/issue/create.rs`/`edit.rs`/`interactions.rs`/`jsm_create.rs` (all
wiring is Story B's scope), `src/cli/mod.rs` (the `--no-mentions` clap flag
declarations are Story B's scope), `.cargo/mutants.toml` (already covers `src/adf.rs`
— no edit needed by this story).

## Out of Scope

- Any effectful `@Name`/accountId resolution (HTTP calls, `disambiguate_user`,
  `filter_by_name_match`) — entirely `S-cycle5-mention-resolution-wiring`'s scope.
- The `--no-mentions` CLI flag declaration and its wiring into the four write-command
  call sites — Story B's scope. This story only builds the pure entrypoint
  (`markdown_to_adf_no_mentions`) that flag will call.
- Resolving VP-674-005 outside the two outcomes AC-015 defines. AC-015 IS this
  story's Task (Task 17) for the mark-composition empirical schema check
  (EC-7.2.016-5) — it is in scope, not deferred; only a decision to add a
  same-PR spec companion edit for a discovered schema quirk beyond the two
  documented outcomes would be out of scope for this story alone.
- Live-Jira E2E acceptance (H-NEW-MENTION-009, VP-674-014..017) — Story B's scope,
  since it requires the effectful resolver to exist.

## Dependency Analysis

**depends_on: []** — root story, Wave 1, independently BUILDABLE and TESTABLE
without any network-mocking infrastructure. See "Interim Shippability Note"
below for what this does and does not mean for the feature as a whole.

**blocks:** `S-cycle5-mention-resolution-wiring` — Story B's new effectful resolver
and all four wiring call sites call this story's public API
(`find_mention_candidates`, `markdown_to_adf_with_mentions`,
`markdown_to_adf_no_mentions`, `MentionResolutions`) and cannot compile until it
exists.

## Interim Shippability Note (F-M-01)

`markdown_to_adf` is the ONE existing entrypoint every one of `adf.rs`'s six
pre-#674 call sites (`issue create`, `issue edit` incl. dry-run,
`comment add`/`edit`, JSM `issue create --request-type`, and any other
markdown-to-ADF conversion path) already calls today, and this story's
`markdown_to_adf` wrapper unconditionally routes through
`markdown_to_adf_with_mentions` (AC-003). Per ADR-0023, this means that as soon
as this story merges to `develop` — BEFORE Story B's preflight resolver
(`BC-X.7.010`) exists — a `[~accountid:<id>]` bracket-form token typed into ANY
of those six call sites converts to a real ADF `mention` node UNCONDITIONALLY
and UNVALIDATED: no `GET /rest/api/3/user?accountId=` check runs, so a
stale/invalid/malformed accountId is emitted into Jira exactly as typed, with
no server-side notification guaranteed and no client-side "unknown user" error
raised. This is an ACCEPTED, TIME-BOXED interim condition, not an oversight:
(1) both waves belong to the same cycle-005 delivery — there is no planned
mid-cycle release of `develop` between Wave 1 merging and Wave 2 opening; (2)
this cycle's F7 delta-convergence gate (and the feature's "closes #674" claim)
requires BOTH stories, so the window is bounded by this cycle's own schedule,
not left open-ended; (3) the window is closed by Story B's BC-X.7.010 mandatory
preflight validation, which this story's Task 17/AC-015 note deliberately does
NOT attempt to substitute for. Anyone building or testing against `develop` in
the gap between the two waves' merges should treat bracket-form mentions as
UNVALIDATED during that window — see `wave-schedule.md`'s Wave 1 gate for the
schedule-level restatement of this same condition.

## Story Points and Effort

**13 story points** (large). Breakdown:
- Bracket-form detection + emission (`find_mention_candidates` half 1,
  `markdown_to_adf_with_mentions` bracket path): 2 SP
- `@Name` detection grammar + trailing-punctuation trim + proptest (VP-674-018): 2.5 SP
- `\@` escape mechanism — F4 spike, two-codepoint sentinel protect/restore, code-range
  guard: 4 SP (highest-uncertainty item in this story; the F4-contingency note on
  AC-007 exists specifically because this estimate assumes the primary mechanism
  works — a fallback attempt would consume additional, currently unbudgeted time)
- Pass-order pin + `assign_local_ids` reorder + depth-guard/INV-1 regression: 1.5 SP
- `attrs.text` population, leading-`@`/control-char sanitization: 1 SP
- Reverse-path `"mention"` render arm + BC-7.2.004 differential + no-panic proptest: 2 SP

Risk: HIGH (module criticality CRITICAL — `src/adf.rs` is the single highest-blast-radius
file in the codebase per ADR-0023's own framing, and the `\@`-escape mechanism is a
genuinely novel pre-parse source-mutation pass with no prior `adf.rs` precedent). The
F4 spike on AC-007 is this story's dominant risk; budget schedule slack for it and do
not treat the point estimate above as a hard ceiling on that task alone.
