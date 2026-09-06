---
document_type: f2-verification-delta
phase: phase-f2-spec-evolution
producer: formal-verifier
issue: 674
feature: "adf-mentions"
cycle: cycle-005
status: complete
timestamp: 2026-09-06
project: jira-cli
mode: BROWNFIELD
intent: feature
inputs:
  - ".factory/phase-f2-spec-evolution/prd-delta-674.md"
  - ".factory/specs/prd/bc-7-output-render.md"
  - ".factory/specs/prd/cross-cutting.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/phase-f1-delta-analysis/cycle-005/artifact-mapping.md"
  - ".factory/phase-f1-delta-analysis/cycle-005/delta-analysis.md"
  - ".cargo/mutants.toml"
  - "docs/specs/cargo-mutants-policy.md"
  - "src/adf.rs"
  - "src/cli/issue/helpers.rs"
  - "src/api/jira/users.rs"
vp_count_before: 55
vp_count_after: 76
new_vps:
  - VP-674-001
  - VP-674-002
  - VP-674-003
  - VP-674-004
  - VP-674-005
  - VP-674-006
  - VP-674-007
  - VP-674-008
  - VP-674-009
  - VP-674-010
  - VP-674-011
  - VP-674-012
  - VP-674-013
  - VP-674-014
  - VP-674-015
  - VP-674-016
  - VP-674-017
  - VP-674-018
  - VP-674-019
  - VP-674-020
  - VP-674-021
updated_vps: []
related_bcs:
  - BC-7.2.016
  - BC-7.2.017
  - BC-7.2.018
  - BC-7.2.019
  - BC-7.2.004
  - BC-X.7.007
  - BC-X.7.008
  - BC-X.7.009
  - BC-X.7.010
  - BC-3.3.012
  - BC-3.4.032
  - BC-3.5.013
  - BC-3.8.018
input-hash: "c5c5cb8"
---

# Verification Delta — Issue #674 ("adf-mentions", cycle-005)

Companion to `.factory/phase-f2-spec-evolution/prd-delta-674.md`. Defines and
formally assigns the verification properties (VPs) that pin the 12 new BCs and
the reverse-path amendment (BC-7.2.004) authored for the markdown-mention
feature. This document is the F2 Step-4 (formal-verifier) output: it OWNS the
final VP-id assignment and its propagation across the inline BC registration
surface.

---

## 1. VP-ID Reconciliation (own the sequence)

The product-owner's PRD-delta authored the 12 BC bodies citing VP ids
`VP-674-001..011` firmly and `VP-674-012..017` as **placeholder** ids (`e.g.
VP-674-0NN`, "to be assigned an issue-scoped id at F3/F4"). F1's two
`artifact-mapping.md` runs had proposed only `VP-674-001..006` (primary) and
`VP-674-007..011` (the "Alternative decomposition" reverse-path / 3-way-split
additions).

**Reconciliation verdict — adopt `VP-674-001` through `VP-674-021` (21 VPs),
no renumbering, no collision.** The six placeholder ids (`VP-674-012..017`)
already occupy the exact next-available positions in the `VP-674-NNN`
sequence with no gap and no overlap; formalizing them requires only
promoting the `e.g.` hedge to a firm assignment (done — see §2).
**`VP-674-018` is a NEW dedicated VP allocated by the formal-verifier**
(cycle-005 F2 adversarial pass-1, HIGH-3) — it takes the next contiguous
position after the promoted placeholders and pins the `@Name` detection grammar
in `find_mention_candidates` (charset / start-boundary / single-token /
trailing-punctuation rules), a surface no other VP exercises directly (see §4
and the §9 mutant-kill re-attribution).
**`VP-674-019` is a second NEW dedicated VP allocated by the formal-verifier this
pass** (cycle-005 F2 adversarial pass-3, M1) — it takes the next contiguous
position and pins the `--no-mentions` OBSERVABLE (both the pure-side "zero
mention nodes emitted" and the effectful-side "resolver fully skipped, zero
`/user/search` and zero `/user?accountId=` calls"), a surface no other VP pins
and which backs the MUST-PASS holdout H-NEW-MENTION-006 (see §4A and the §9
mutant-kill class 8).
**`VP-674-020` is a third NEW dedicated VP allocated by the formal-verifier this
pass** (cycle-005 F2 adversarial pass-4, M3) — it takes the next contiguous
position and pins the `--dry-run` FORCED-non-interactive observable: that
`issue edit --dry-run` passes `no_input = true` UNCONDITIONALLY (not the ambient
no_input), so an ambiguous `@Name` at an interactive TTY during `--dry-run`
takes the exit-64 error-with-candidates path and NEVER pops a `dialoguer::Select`
prompt. No prior VP pins this override — VP-674-010 exercises the general
resolver's interactive/non-interactive branches but keyed on the ambient
no_input, so a mutant threading the ambient no_input into the dry-run path
survives all other VPs (see §6, the §8 table, and the §9 mutant-kill class 9).
**`VP-674-021` is a fourth NEW dedicated VP allocated by the formal-verifier this
pass** (cycle-005 F2 — HUMAN DECISION: TIGHTEN @Name single-result resolution) —
it takes the next contiguous position and pins the tightened single-result
name-match behavior: a lone `@Name` search result whose display name does NOT
contain the typed query (case-insensitive substring, per `partial_match`
semantics) MUST HARD ERROR (exit 64), NOT silently resolve; a lone result whose
name DOES contain the query resolves normally. No prior VP pins this: VP-674-009
pins the unique EXACT-match happy path and VP-674-010 pins the ambiguous and
zero-match taxonomy, but neither guards the single-result-but-non-matching case —
so a mutant reverting to the inherited `disambiguate_user` `len==1`
short-circuit (which resolves ANY lone result regardless of name match) survives
all other VPs (see §6, the §8 table, and the §9 mutant-kill class 10).
The final sequence is dense and contiguous: `001..021`,
every id used, none skipped, none reused.

**Collision check (independent of the VP-COUNT-RECONCILIATION bookkeeping
discrepancy)**: a repo-wide grep for `VP-674-` returns matches ONLY in the
cycle-005 artifacts (the three PRD BC files just edited, `prd-delta-674.md`,
`artifact-mapping.md`, `STATE.md`, `burst-log.md`) — no pre-existing
`VP-674-NNN` id exists anywhere else in the tree. The `674` issue-scope prefix
is itself the collision firewall: every VP id in this repo is issue-scoped
(`VP-<issue#>-NNN`), so a new `VP-674-NNN` id cannot collide with any
`VP-571-*` / `VP-396-*` / `VP-692-*` / … id regardless of whether the "right"
global VP count is STATE's tracked 55 or the raw-grep ~177 (the open,
non-blocking `VP-COUNT-RECONCILIATION` follow-up). **This delta does NOT
attempt to resolve VP-COUNT-RECONCILIATION** — it only guarantees the 21 new
ids are firewalled from every existing id by the `674` prefix.

`vp_count_after` in this frontmatter (76 = 55 + 21) is stated on STATE's
tracked-55 basis for continuity with STATE.md's running total; it inherits
STATE's basis caveat and does not assert the raw-grep basis is wrong.

---

## 2. Registration Surface & Propagation (VP Citation Change Handoff)

**This project has no `VP-INDEX.md`, `verification-architecture.md`, or
`verification-coverage-matrix.md` file** — none exists in the tree
(`find` confirmed). Per the standing Project Convention (documented in
`.factory/phase-f2-spec-evolution/verification-delta-398.md` §"Project
Convention Note" and reaffirmed in `verification-delta-571.md`), VPs are
registered **inline** as `**Verification Properties**:` subsections within the
BC bodies. The orchestrator task named `.factory/specs/verification-*` VP
files and a VP-INDEX to update; **those artifacts do not exist in this
repository**, so the equivalent registration surface is the inline BC
subsections, which the product-owner already populated with the VP ids.

Owning the "VP Citation Change Handoff" for this delta therefore means firming
the six placeholder citations from `e.g. VP-674-0NN` to concrete, assigned ids.
**Done this pass** (6 edits, spec bodies only — no `src/` change):

| VP | BC body edited | Citation (symbol-form) |
|----|----------------|------------------------|
| VP-674-012 | BC-7.2.018 (`\@`-escape pin) | `bc-7-output-render.md § BC-7.2.018` |
| VP-674-013 | BC-X.7.010 (accountId preflight dedup) | `cross-cutting.md § BC-X.7.010` |
| VP-674-014 | BC-3.3.012 (E2E create, platform) | `bc-3-issue-write.md § BC-3.3.012` |
| VP-674-015 | BC-3.4.032 (E2E edit) | `bc-3-issue-write.md § BC-3.4.032` |
| VP-674-016 | BC-3.5.013 (E2E comment add) | `bc-3-issue-write.md § BC-3.5.013` |
| VP-674-017 | BC-3.8.018 (E2E JSM create) | `bc-3-issue-write.md § BC-3.8.018` |

(Citations use SYMBOL-FORM — `<file> § <BC-id>` — per CLAUDE.md's
citation-discipline convention; the earlier `<file>:NN` line numbers had drifted
on refactor and are deliberately not reintroduced.)

`VP-674-001..011` were already firm in the BC bodies (no edit needed).

**VP-674-018 citation HANDOFF to the product-owner — COMPLETED (cycle-005 F2
adversarial pass-3, L3).** VP-674-018 is a NEW VP allocated by the
formal-verifier (pass-1 HIGH-3) to pin the `@Name` detection grammar (§4). This
handoff is now **DONE**: the product-owner has already added the VP-674-018
citation to **BC-7.2.018**'s `**Verification Properties**:` subsection
(`bc-7-output-render.md § BC-7.2.018`), so no further product-owner action is required
for VP-674-018. The exact citation string that was added (retained here for the
audit trail; append form was to BC-7.2.018's existing VP list alongside
VP-674-012):

> `VP-674-018` — `@Name` detection-grammar property (proptest +
> example-anchored `#[test]`, `src/adf.rs::tests` over
> `find_mention_candidates`): start-boundary rule (EC-7.2.018-1 email
> exclusion), single-token `/`-stop (EC-7.2.018-2 npm scope), trailing-`.`/`-`/`_`
> trim (EC-7.2.018-5), consecutive `@a @b`, and mid-word `@` negative.

**VP-674-019 citation HANDOFF to the product-owner — COMPLETED (cycle-005 F2
adversarial pass-3, M1; confirmed present pass-4, L1).** VP-674-019 is a NEW VP
allocated by the formal-verifier to back the `--no-mentions` MUST-PASS holdout
**H-NEW-MENTION-006**, which previously had NO backing VP (the observable — that
`--no-mentions` emits zero mention nodes AND fully skips the resolver — was
pinned by nothing, so a mutant collapsing `markdown_to_adf_no_mentions` into
`markdown_to_adf` survived all prior VPs). This handoff is now **DONE**: the
product-owner has already added the VP-674-019 citation to
**H-NEW-MENTION-006's Status line** in `holdout-scenarios.md`, so no further
product-owner action is required for VP-674-019. The exact citation string that
was added (retained here for the audit trail):

> Backed by `VP-674-019` — `--no-mentions` observable (§4A): (a) pure-side
> proptest+example, `src/adf.rs::tests`, `markdown_to_adf_no_mentions` over
> `[~accountid:X]` and `@jsmith` emits ZERO `mention` nodes (both forms stay
> literal text); (b) wiremock/CLI-side, a write command invoked with
> `--no-mentions` issues ZERO `GET /rest/api/3/user/search` and ZERO
> `GET /rest/api/3/user?accountId=` requests (resolver fully skipped).

**VP-674-020 citation HANDOFF to the product-owner — COMPLETED (cycle-005 F2
adversarial pass-4, M3; confirmed present pass-5, L-1).** VP-674-020 is a NEW VP
allocated by the formal-verifier to pin the `--dry-run` FORCED-non-interactive
observable (§6): that `issue edit --dry-run` forces `no_input = true`
UNCONDITIONALLY, so an ambiguous `@Name` at an interactive TTY during `--dry-run`
takes the exit-64 error-with-candidates path and NEVER pops a `dialoguer::Select`
prompt. No prior VP pins this override (VP-674-010 keys on the ambient no_input,
not the dry-run force). This handoff is now **DONE**: the product-owner has
already added the VP-674-020 citation to **BC-3.4.032's `**Verification
Properties**:` subsection** (`bc-3-issue-write.md § BC-3.4.032`, present at
`bc-3-issue-write.md:~3585`; BC-3.4.032 point 5 is the `--dry-run`
forced-non-interactive spec point), so no further product-owner action is
required for VP-674-020. The exact citation string that was added (retained here
for the audit trail):

> `VP-674-020` — `--dry-run` forced-non-interactive observable (§6):
> wiremock/CLI-integration test with the `JR_STDIN_IS_TTY=1` seam,
> `issue edit <KEY> --description "cc @<ambiguous-name>" --markdown --dry-run`
> at a simulated TTY resolves an ambiguous `@Name` via the NON-interactive
> branch — exit 64 + candidate list on stderr + NO `dialoguer::Select` prompt
> (no hang) + zero POST/PUT. Pins BC-3.4.032 point 5 (`--dry-run` passes
> `no_input = true` unconditionally, not the ambient no_input).

**VP-674-021 citation HANDOFF to the product-owner — COMPLETED (cycle-005 F2 —
HUMAN DECISION: TIGHTEN @Name single-result resolution; confirmed present
pass-5, L-1).** VP-674-021 is a NEW VP allocated by the formal-verifier to pin the
human-approved tightened single-result name-match rule (§6): a lone `@Name` search
result whose display name does NOT contain the typed query (case-insensitive
substring, per `partial_match` semantics) MUST HARD ERROR (exit 64), not silently
resolve; a lone result whose name DOES contain the query resolves normally. No
prior VP pins this (VP-674-009 pins the unique EXACT-match happy path; VP-674-010
pins ambiguous / zero-match). This handoff is now **DONE**: the product-owner has
already added the VP-674-021 citation to **BC-X.7.007's `**Verification
Properties**:` subsection** (`cross-cutting.md § BC-X.7.007`, present at
`cross-cutting.md:~717`; BC-X.7.007 is the unique-match source contract), so no
further product-owner action is required for VP-674-021. The exact citation string
that was added (retained here for the audit trail):

> `VP-674-021` — single-result name-match tightening (§6): wiremock/CLI-integration
> test — `query=jsmith` returning exactly ONE ACTIVE user
> `[{"accountId":"acc-1","displayName":"John Smith","active":true}]` (name does NOT
> contain "jsmith", but the user PASSES the active-filter, so the exit-64 is
> produced by the NAME-MATCH filter, NOT the active-filter) → `jr` exits 64 with the
> `"No user found matching"` substring, the error message does NOT contain the
> `"deactivated"` substring (the discriminator against the all-inactive wording),
> and `jr` issues ZERO POST/PUT (the lone non-matching result is NOT resolved to
> acc-1); `query=smith` returning the same single active "John Smith" (name DOES
> contain "smith") → resolves to acc-1, mention emitted; plus a multi-result
> reduction case — `query=smith` returning TWO active users
> `[{"accountId":"acc-1","displayName":"John Smith","active":true},{"accountId":"acc-2","displayName":"Jane Doe","active":true}]`
> where only "John Smith" name-matches → resolves to acc-1 (the lone name-match
> after reduction), zero ambiguity prompt. Guards against a regression to the
> inherited `disambiguate_user` `len==1` short-circuit that resolves a non-matching
> lone result.

(All FOUR dedicated-VP citation handoffs are now COMPLETED — no OPEN
product-owner action remains: VP-674-018 to BC-7.2.018 (present at
`bc-7-output-render.md § BC-7.2.018`), VP-674-019 to H-NEW-MENTION-006 (present in
`holdout-scenarios.md`), VP-674-020 to BC-3.4.032 (present at
`bc-3-issue-write.md:~3585`), and VP-674-021 to BC-X.7.007 (present at
`cross-cutting.md:~717`). The six placeholder rows were firmed in a prior F2 pass
and are unchanged here.)

**ARCH-INDEX.md — NO CHANGE (documented no-op).** `.factory/specs/architecture/
ARCH-INDEX.md` is an ADR + subsystem registry only; it tracks no verification
subsystem and no VP ids (there is no verification row/section to propagate
into). Adding one would fabricate a structure the repo does not use. The
verification subsystem for `adf.rs` and the mention resolver is SS-08
(Cross-cutting Utilities) / SS-02 (CLI Layer) per the existing Subsystem
Registry; no new subsystem is introduced by this feature. If the architect
adds a mention-architecture ADR this cycle, that ADR row is the architect's
ARCH-INDEX edit, not this delta's.

**Frontmatter count sweep — N/A.** No BC file frontmatter carries a
`total_vps` field (verified — only `total_bcs`/`definitional_count` exist), so
no VP-count frontmatter is affected. `scripts/check-spec-counts.sh` /
`check-bc-cumulative-counts.sh` govern BC counts, not VP counts.

---

## 3. Verification Toolchain In Scope (and the Kani/Fuzz Justified-Skip)

**In scope for this cycle:**
- **proptest** + example-based `#[test]` unit tests inside `src/adf.rs::tests`
  (the PURE-core forward/reverse conversion — highly proptest-amenable).
- **wiremock integration tests** (`tests/`) for the EFFECTFUL resolver
  (`@Name` search, accountId preflight, exit-64 taxonomy, dedup call-count).
- **`JR_RUN_E2E`-gated live-Jira tests** (`tests/e2e_live.rs`) for the
  human-required round-trip acceptance (controlled test account, self-cleaning
  per the `Drop`-guard / `jsm_self_close` conventions).
- **cargo-mutants** on the delta diff (`src/adf.rs` is already in
  `.cargo/mutants.toml` §examine_globs; the new `src/cli/issue/mentions.rs`
  resolver must be ADDED to examine_globs at F4 — see §7).

**Kani / cargo-fuzz — JUSTIFIED-SKIP (0-GAP), per cycle-002/003/004 precedent.**
This project has NEVER provisioned Kani or any formal-methods toolchain, nor a
cargo-fuzz harness, for `adf.rs` or any module (confirmed: no `kani`/`fuzz`
crate in `Cargo.toml`, no `kani-verifier`, no `fuzz/` directory). The
established precedent (verification-delta-571.md §"Verification toolchain in
scope"; the same statement in the 396/398/field-dx deltas) is that
proptest + example-based unit tests + cargo-mutants provide the substitution:
- The pure conversion invariants (round-trip stability, "exactly one mention
  node per eligible token", boundary-rule totality, no-panic, INV-1, depth
  guard) are **universally quantified** and are captured by proptest's
  universal-quantifier generators rather than a bounded model checker — a
  proptest property over a well-chosen grammar generator IS the "what must be
  true" statement Kani would otherwise prove, with shrinking giving the minimal
  counterexample a model checker would give.
- There is no `unsafe` code, no arithmetic-overflow surface, and no
  out-of-bounds array-index surface introduced by this feature (the tree-walk
  reuses `autolink_bare_urls`'s already-bounded slicing and the established
  `MAX_ADF_DEPTH` guard) — the specific defect classes Kani is strongest at are
  not present.
- Fuzzing's value (crash-finding on untrusted byte input) is covered by the
  proptest no-panic invariant (VP-674-008) run over generated markdown, which
  is the same "arbitrary input never crashes the converter" guarantee at this
  module's trust boundary.

**0-GAP statement**: skipping Kani and fuzz introduces NO coverage gap relative
to the BC set, because every correctness claim in BC-7.2.016..019 is either
(a) a universal property captured by a proptest generator, (b) a deterministic
example-anchored regression, (c) an effectful behavior only observable through
HTTP (wiremock/e2e, out of Kani/fuzz reach entirely), or (d) an explicit F4
empirical-schema check (VP-674-005) that no static tool can answer because it
depends on Atlaskit's runtime ADF schema. This is a documented substitution,
not an omission.

---

## 4. New Verification Properties — Pure Conversion (proptest + example)

These pin the pure, zero-HTTP core in `src/adf.rs`. All are `src/adf.rs::tests`
unit/proptest tests.

### VP-674-001 — Bracket-form emission property (proptest)
**Technique**: proptest. **Pins**: BC-7.2.016 (the bracket-conversion ECs
specifically — EC-7.2.016-5 is pinned by VP-674-005 and EC-7.2.016-7 by
VP-674-019, so those two are covered elsewhere); shared into BC-X.7.010
(validation is orthogonal to emitter correctness).
**Property**: for any string `S` drawn from the accountId charset
`[A-Za-z0-9:_-]+` (generator: `"[A-Za-z0-9:_-]{1,40}"`), and any eligible
prefix context (start-of-node / after whitespace / after one of `*_~(`),
`markdown_to_adf(prefix + "[~accountid:" + S + "]")` emits **exactly one**
`mention` node whose `attrs.id == S` **byte-for-byte** (opaque — `:` and `-`
preserved, NEVER UUID-normalized), correctly nested inside its enclosing
paragraph, with `attrs.text` ABSENT (bare `markdown_to_adf` path). Include a
shrink-friendly small-alphabet variant. Suggested name:
`prop_bc_7_2_016_bracket_form_emits_single_mention_id_verbatim`.
**Also asserts** (idempotence corollary): a second `markdown_to_adf` over the
`adf_to_text` render of the output is not required (round-trip is lossy by
design, BC-7.2.019 EC-5) — the pinned invariant is on the FORWARD emission
only.

### VP-674-004 — Zero-HTTP purity invariant (example/structural)
**Technique**: example-based / structural (no network mock needed — the
functions take no `client`). **Pins**: BC-7.2.016 point 6.
**Property**: `markdown_to_adf`, `markdown_to_adf_with_mentions`,
`markdown_to_adf_no_mentions`, and `find_mention_candidates` have signatures
that **cannot** perform I/O (no `JiraClient`/`reqwest` parameter, not `async`)
— purity is enforced by construction and pinned by a compile-level test that
these remain synchronous, `client`-free functions. A body containing bracket
and `@Name` tokens run through bare `markdown_to_adf` performs zero HTTP by
construction. Suggested name:
`test_bc_7_2_016_pure_conversion_functions_take_no_client`.

### VP-674-006 — Depth guard + INV-1 regression pin (proptest + example)
**Technique**: proptest (depth) + example (INV-1). **Pins**: BC-7.2.016
points 8/9; guards BC-7.2.012 (MAX_ADF_DEPTH) and INV-1 (BC-7.2.011).
**Property A (depth)**: markdown nested ≥256 levels containing a mention token
still exits with the `MAX_ADF_DEPTH` "nesting too deep" error (exit 64), never
a stack overflow — the mention pass is a sibling call in the same
post-`finish()` sequence as `autolink_bare_urls` and inherits the inclusive
depth-256 boundary. **Property B (INV-1)**: no emitted `text` node anywhere in
the output of `markdown_to_adf_with_mentions` over any generated input contains
a raw `\n` or `\r`; a `mention` node's `attrs.text` (`"@" + display_name`) is a
single-line string. Suggested names:
`test_bc_7_2_016_mention_pass_respects_max_adf_depth`,
`prop_bc_7_2_016_no_raw_newline_in_text_nodes_with_mentions`.

### VP-674-002 — `@Name` happy-path resolution + `attrs.text` (example)
**Technique**: example-based (pure-emitter half) — the resolution HALF is
wiremock (VP-674-009); this VP pins the EMITTER consuming a resolved map.
**Pins**: BC-7.2.017 (population), BC-X.7.007 (unique-match source).
**Property**: given a `MentionResolutions` map with entry
`@jsmith -> {account_id: "abc", display_name: "Jane Smith"}`,
`markdown_to_adf_with_mentions("cc @jsmith", &map)` emits
`{"type":"mention","attrs":{"id":"abc","text":"@Jane Smith"}}` — `attrs.text`
is exactly `"@" + display_name` (single `@`, no double-prefix). Suggested name:
`test_bc_7_2_017_at_name_resolved_emits_id_and_at_prefixed_text`.

### VP-674-005 — Mark-composition empirical check (F4-VERIFY, FLAGGED)
**Technique**: F4 EMPIRICAL SCHEMA CHECK (deferred), then example anchor.
**Pins**: BC-7.2.016 EC-7.2.016-5, BC-7.2.017, BC-7.2.018 (mark interaction for
both forms). **STATUS — UNPROVEN AT F2, MECHANISM DEFERRED.** Whether an ADF
`mention` node may legally carry `marks` (e.g. `**[~accountid:X]**` / `**@jsmith**`
— bold wrapping a mention) is an **Atlaskit `adf-schema` runtime question**, not
a `jr`-logic question, and no static tool (Kani/proptest/fuzz) can answer it.
Per the same "F4 empirical check" pattern VP-571-002 used for code-mark
exclusivity, the F4 test-writer MUST: (1) empirically determine the `mention`
node's allowed mark set against the schema (or Jira's accept/reject on a live
POST); (2) encode the observed rule as an example anchor — either "mention
inherits no marks" (the BC-7.2.016 point 5 assumption) or an explicit
strip/reject rule; (3) if the observed behavior diverges from BC-7.2.016
point 5's stated assumption, propagate a same-PR spec companion edit to
BC-7.2.016 EC-7.2.016-5 (same phase-perimeter discipline VP-571-002's
R13-LOW-3 clause established). **Flagged for the F2 gate**: this VP's anchor
shape is contingent on an F4 finding, not fixed here.

### VP-674-018 — `@Name` detection-grammar property (proptest + example)
**Technique**: proptest (grammar generator) + example-anchored `#[test]` cases.
**Pins**: BC-7.2.018 (the `@Name` candidate-detection grammar) — the surface
`find_mention_candidates` implements. This VP pins BC-7.2.018 **only**
(detection grammar); resolution of a detected candidate is BC-X.7.007's
concern, covered by the resolver VPs, and is deliberately NOT in this VP's
scope. **This VP is dedicated to the
`@Name` FORM.** It exists precisely because VP-674-001 is defined strictly over
the BRACKET form (`markdown_to_adf("[~accountid:"+S+"]")`) and emits NO `@Name`
input, so VP-674-001 cannot and does not exercise the `@Name` boundary/charset
grammar that BC-7.2.018 specifies (HIGH-3).
**Property (over `find_mention_candidates` — the pure detection pass, zero
HTTP)**: for a generator producing text nodes with `@`-tokens embedded in
varied surrounding context, the set of detected candidate spans obeys, exactly:
1. **Start-boundary rule** — a `@` is a candidate opener ONLY at
   start-of-text-node or immediately after whitespace or one of `*_~(`. A `@`
   with a preceding word character (mid-word) is NOT an opener. **EC-7.2.018-1
   (email exclusion)**: `user@example.com` → NO candidate (the `@` follows the
   word char `r`). Example anchors: `"user@example.com"` (none), `"a@b"` (none),
   `"@jsmith"` at node start (candidate `jsmith`), `"cc @jsmith"` after space
   (candidate `jsmith`).
2. **Single-token / `/`-exclusion rule** — a candidate name is a single token
   that STOPS at `/` (and at whitespace). **EC-7.2.018-2 (npm scope)**:
   `@angular/core` → candidate `angular` (the `/core` is NOT part of the name),
   never `angular/core`.
3. **Charset + trailing-punctuation rule** — the name body admits the `@Name`
   charset; trailing `.`, `-`, `_` are TRIMMED from the candidate (coordinate
   with the product-owner's HIGH-1 fix — the observable rule is that a trailing
   sentence-punctuation/connector char is not part of the resolved name).
   **EC-7.2.018-5**: `@jsmith.` → candidate `jsmith` (trailing `.` trimmed);
   `@jsmith,` / `@jsmith-` / `@jsmith_` → candidate `jsmith` at the trailing
   boundary. INTERIOR `.`/`-`/`_` (if in-charset) are preserved — only the
   TRAILING run is trimmed.
4. **Consecutive-mentions rule** — `@a @b` yields TWO distinct candidates
   (`a`, `b`), each opened at its own whitespace boundary; the second `@`
   follows a space, so it is a valid opener.
5. **Mid-word negative** — `foo@bar`, `e@ mail`, and any `@` immediately after a
   word char yield NO candidate for that `@`.
**Proptest shape**: generate a token stream interleaving `@name` fragments with
random boundary/non-boundary prefixes and random trailing punctuation, and
assert (a) every candidate's opener position satisfies rule 1; (b) no candidate
name contains `/` or whitespace (rules 2/4); (c) no candidate name ends in
`.`/`-`/`_` (rule 3); (d) `find_mention_candidates` never panics and returns a
deterministic, order-stable candidate list. Suggested names:
`prop_bc_7_2_018_at_name_detection_grammar` (property) +
`test_bc_7_2_018_at_name_boundary_and_charset_examples` (the EC anchor matrix
covering EC-7.2.018-1/-2/-5, consecutive, and mid-word cases).
**Relationship to VP-674-012**: VP-674-012 pins the `\@`-ESCAPE observable (an
otherwise-eligible `@Name` NOT becoming a candidate/mention); VP-674-018 pins
the UN-escaped detection grammar (which `@`-tokens ARE candidates and where the
name boundaries fall). The two are complementary, non-overlapping.

---

## 4A. New Verification Property — `--no-mentions` Suppression (pure + wiremock)

### VP-674-019 — `--no-mentions` observable: zero emission + resolver fully skipped
**Technique**: two-part — (a) proptest + example (pure core, `src/adf.rs::tests`);
(b) wiremock-integration (`tests/`, effectful CLI path). **Pins**: the
`--no-mentions` MUST-PASS holdout **H-NEW-MENTION-006** and the `--no-mentions`
observable across the write-command surface (BC-3.3.012 / BC-3.4.032 /
BC-3.5.013 / BC-3.8.018 wiring — the flag routes those paths through the
`markdown_to_adf_no_mentions` engine with the resolver skipped).
**Why this VP exists (M1)**: no prior VP pins the `--no-mentions` observable.
VP-674-004 only checks the pure-fn signatures (no-client) plus bare
`markdown_to_adf` zero-HTTP; it does NOT distinguish `markdown_to_adf_no_mentions`
from `markdown_to_adf` behaviorally, nor does it pin the resolver being skipped.
Consequently a mutant that COLLAPSES `markdown_to_adf_no_mentions` into
`markdown_to_adf` (so a bracket `[~accountid:X]` still converts to a `mention`
node, or the `@Name` resolver still runs) survives all 18 other VPs. VP-674-019
closes that hole from both sides.

**Part (a) — pure-side (proptest + example, `src/adf.rs::tests`, zero HTTP)**:
for BOTH mention forms, `markdown_to_adf_no_mentions` emits **ZERO** `mention`
nodes — the tokens stay LITERAL text:
- `markdown_to_adf_no_mentions("[~accountid:X]")` → the output ADF contains NO
  node of `"type":"mention"`; the bracket text `[~accountid:X]` is preserved as
  literal `text` content (no conversion). Proptest over the accountId charset
  generator `"[A-Za-z0-9:_-]{1,40}"` asserts the mention-node count is exactly
  0 for every generated `S`.
- `markdown_to_adf_no_mentions("@jsmith")` → NO `mention` node; `@jsmith` stays
  literal `text`. Proptest over an `@Name` grammar generator (reuse VP-674-018's
  fragment generator) asserts zero mention nodes regardless of boundary context.
- **Contrast anchor (kills the collapse mutant directly)**: an example pair
  asserting `markdown_to_adf("[~accountid:X]")` DOES emit exactly one `mention`
  node while `markdown_to_adf_no_mentions("[~accountid:X]")` emits zero — so a
  mutant making the two functions identical fails this differential assertion.
Suggested names: `prop_bc_no_mentions_emits_zero_mention_nodes_both_forms`,
`test_no_mentions_vs_default_bracket_is_differential`.

**Part (b) — effectful CLI-side (wiremock, `tests/`)**: invoking a write command
with `--no-mentions` on a body containing BOTH a resolvable `@Name` and a
bracket `[~accountid:X]` issues **ZERO** resolver HTTP calls:
- **exactly ZERO** `GET /rest/api/3/user/search?query=…` requests (the `@Name`
  resolver is fully skipped), AND
- **exactly ZERO** `GET /rest/api/3/user?accountId=…` requests (the bracket-form
  accountId preflight is fully skipped).
Wiremock asserts a request count of 0 against BOTH endpoints (mount the mocks so
any hit is observable and `verify`-counted at 0). The POST body carries the
literal, unconverted mention text (no `mention` node), tying back to part (a).
Suggested name: `test_no_mentions_flag_issues_zero_resolver_requests`.

**Relationship to VP-674-004**: VP-674-004 pins purity-by-construction (no client
param, not async) for the whole family INCLUDING `markdown_to_adf_no_mentions`;
VP-674-019 pins the BEHAVIORAL distinction (`no_mentions` actually suppresses
emission AND the CLI actually skips the resolver). Complementary, non-overlapping
— VP-674-004 cannot catch the collapse mutant because a collapsed
`markdown_to_adf_no_mentions` still has the same (client-free) signature.

---

## 5. New Verification Properties — Reverse Path (proptest + example)

### VP-674-007 — `adf_to_text` fallback rendering (example)
**Technique**: example-based. **Pins**: BC-7.2.019 (all ECs).
**Property**: `adf_to_text` renders a `mention` node by the three-way
precedence — `attrs.text` present & non-empty → verbatim (NO double `@`);
else `attrs.id` present & non-empty → `"@" + id`; else → literal `"@?"`.
Anchor matrix (one `#[test]` per EC-7.2.019-1..4):
| Input mention attrs | Rendered | EC |
|---|---|---|
| `{"id":"X","text":"@Jane Doe"}` | `@Jane Doe` | EC-1 |
| `{"id":"X"}` | `@X` | EC-2 |
| `{}` (or no `attrs`) | `@?` | EC-3 |
| `{"text":"","id":""}` | `@?` | EC-4 (empty == absent) |
Suggested name: `test_bc_7_2_019_mention_render_fallback_precedence`.
**Also pins BC-7.2.004 amendment**: an example asserting `emoji`/`inlineCard`/
`media` remain silently dropped (the `_` catch-all is now narrower but
UNCHANGED for those three), so the amendment does not accidentally start
rendering them. Suggested name:
`test_bc_7_2_004_emoji_inlinecard_media_still_dropped_after_mention_arm`.

### VP-674-008 — Reverse-path no-panic / nesting property (proptest)
**Technique**: proptest. **Pins**: BC-7.2.019 (robustness across nesting).
**Property**: a `mention` node placed at ANY legal inline-content position
(paragraph, listItem, panel, tableCell, taskItem, blockquote, heading) — with
arbitrary `attrs` shapes (id-only / text-only / both / neither /
empty-strings / non-string junk values) — never causes `adf_to_text` to panic
or return `Err`; it always renders one of the three fallback forms and never
recurses (a `mention` is a leaf, no `content` array). Generator builds a
random ADF tree with mention leaves at random depths ≤ a small bound.
Suggested name: `prop_bc_7_2_019_mention_never_panics_at_any_inline_position`.

### VP-674-012 — `\@` escape regression pin (example, MECHANISM F4-VERIFY, FLAGGED)
**Technique**: example-based regression pin. **Pins**: BC-7.2.018 point 6 /
EC-7.2.018-8. **The OBSERVABLE property is testable now; the MECHANISM is
unproven pending F4.**
**Observable property (fixed, testable regardless of mechanism)**:
`markdown_to_adf_with_mentions("Contact \\@jsmith directly", &map)` — where
`map` DOES contain a resolving entry for `@jsmith` — produces literal text
`"@jsmith"` and **NO** `mention` node, i.e. the backslash escape wins over an
otherwise-resolvable candidate. A companion assertion: `find_mention_candidates`
returns NO candidate for the `\@jsmith` span.
**Even-backslash-count genuine-mention case (LOW-2)**: the escape rule is
backslash-parity, not "any backslash suppresses". A single (odd) backslash
before `@` = literal (the case above); a DOUBLED (even) backslash before `@` =
an escaped LITERAL backslash followed by a GENUINE `@`-mention. So
`markdown_to_adf_with_mentions("Contact \\\\@jsmith directly", &map)` (source
`\\@jsmith` — one literal `\` then `@jsmith`) MUST produce a literal `\`
followed by a real `mention` node resolving `@jsmith` (attrs.id populated), and
`find_mention_candidates` MUST return a candidate `jsmith` for that span. The
observable property is exactly: **odd backslash-count before `@` ⇒ literal `@`
(no mention); even backslash-count ⇒ genuine mention** (with the even case
leaving `even/2` literal backslashes in the rendered text). Keep this consistent
with whatever `\@`-mechanism the architect finalizes in parallel — it constrains
the same mechanism from both sides (odd suppresses, even passes through).
Suggested name for the even-case anchor:
`test_bc_7_2_018_double_backslash_at_name_is_genuine_mention`.
**MECHANISM CAVEAT (flagged for F2 gate / F4 spike)**: CommonMark treats `@` as
an escapable ASCII punctuation char, and pulldown-cmark consumes the backslash
BEFORE `jr`'s post-`finish()` tree-walk runs — so in the BUILT AST `\@jsmith`
and `@jsmith` are byte-identical (precedent: `test_markdown_escape_literal_asterisk`
for `\*`). The BC RECOMMENDS `Parser::into_offset_iter()` byte-offset
correlation against the raw source, with a private-use-sentinel pre-parse pass
as the fallback — **neither is proven**. This VP's assertion is authorable at
F4 as a RED-first regression pin, but if BOTH mechanisms prove impractical the
F4 story MUST route a scope-cut decision back to the orchestrator (do not
silently ship without the escape). The property is a verification obligation
even though the mechanism is TBD.
**F3/F4 GATE ENFORCEMENT (LOW-6)**: VP-674-012 (the `\@` escape MECHANISM, incl.
the even-backslash genuine-mention case above) and VP-674-005 (mark composition)
are the two F4-CONTINGENT VPs in this delta — their PROOF depends on an F4 spike
finding, not on anything decidable at F2. The F3/F4 gate MUST enforce the
scope-cut routing: if the `\@` escape proves infeasible after the F4 spike
(both offset-iter correlation AND sentinel pre-parse impractical), the F4 story
MUST route a scope decision to the orchestrator — the feature MUST NOT ship
silently without the escape. This gate obligation is a hard F3/F4 checkpoint,
not a suggestion; see §11 item 6 for the consolidated F4-contingency register.

---

## 6. New Verification Properties — Effectful `@Name` Resolution & Preflight (wiremock)

These are NETWORK-effectful and CANNOT be Kani/proptest targets — they pin
`src/cli/issue/mentions.rs::resolve_mentions` (new) and its reuse of
`search_users` / `get_user` / `disambiguate_user`. All are wiremock
integration tests in `tests/` (suggested new file `tests/mention_resolution.rs`,
mirroring `tests/duplicate_user_disambiguation.rs`'s style per
`artifact-mapping.md` §3).

### VP-674-009 — `@Name` unique-match + dedup call-count (wiremock)
**Pins**: BC-X.7.007. Asserts: N repeated `@jsmith` occurrences in one body →
**exactly ONE** `GET /rest/api/3/user/search?query=jsmith` request (per-invocation
in-memory dedup); a single `active==true` exact match resolves to its
accountId; the endpoint is the UNSCOPED `/user/search` (NOT
`multiProjectSearch`). Wiremock verifies the request count and the query param.

### VP-674-003 — `@Name` ambiguous reuses BC-X.7.004 contract (wiremock/example)
**Pins**: BC-X.7.008. Asserts: a `@Name` matching two+ users reuses
`disambiguate_user`'s EXISTING `ExactMultiple`/`Ambiguous` stderr wording
verbatim (assert against the SAME substrings `tests/duplicate_user_disambiguation.rs`
pins — `"Multiple users named"` / `"Multiple users match"`), applied at the
NEW mention resolver call site specifically. No new disambiguation UX invented.

### VP-674-010 — `@Name` ambiguous + zero-match exit-64 taxonomy (wiremock)
**Pins**: BC-X.7.008 (ambiguous half), BC-X.7.009 (zero-match half).
Asserts, non-interactively (`--no-input`): ambiguous → exit 64 + candidate
list + **zero POST/PUT**; zero-match → exit 64 (NOT exit 0 / pass-through — the
human-approved hard-error override) + load-bearing substring `"No user found
matching"` + **zero POST/PUT**. Interactive branch (TTY via `JR_STDIN_IS_TTY`
seam) exercises the `dialoguer::Select` prompt for the ambiguous case.
Deactivated-only match (EC-X.7.007-3 / EC-X.7.009-4) is exercised as a
zero-match hard error (filtered before disambiguation).
**`MatchResult::None` unreachable on the mention path (F2 adversarial pass-6,
M-3)**: because the F2-gate single-result tightening runs `filter_by_name_match`
BEFORE `disambiguate_user` on the mention path, a search that returns candidates
but none matching the query by name is intercepted at the filter — the reduced
candidate list is EMPTY, so the case lands on the EMPTY-LIST (zero-match) branch
above (exit 64 + `"No user found matching"`), NOT on `disambiguate_user`'s
internal `partial_match` `MatchResult::None` branch. Consequently
`disambiguate_user` can never return `MatchResult::None` on the mention path, and
this VP does NOT (and cannot) exercise a "candidates returned but none matching by
name → `MatchResult::None`" case directly — that exact input reaches the
empty-list branch instead. `MatchResult::None` is reachable only via a non-mention
caller and is out of the mention path's scope. (The single-result variant of this
same non-matching case is pinned by VP-674-021 case 1, which lands on the identical
empty-after-filter zero-match branch.)

### VP-674-013 — Bracket-form accountId preflight dedup + hard error (wiremock)
**Pins**: BC-X.7.010. Asserts: N repeated `[~accountid:X]` → **exactly ONE**
`GET /rest/api/3/user?accountId=X`; two distinct ids → two calls (both must
succeed); `get_user` 404/400 → exit 64 + substring `"not found"` + **zero
POST/PUT**; on success, the returned `display_name` populates `attrs.text` on
the emitted node (integration-level tie-back to VP-674-002). 401/403/5xx during
validation propagates via the standard `JrError` mapping, NOT re-wrapped as
"not found" (EC-X.7.010-3).

### VP-674-011 — Mention presence does not alter visibility routing (wiremock/example)
**Pins**: BC-3.5.013 point 4 (orthogonality). Asserts: a `comment add
--internal` whose body contains a resolved mention still POSTs the identical
`properties: [{key:"sd.public.comment", value:{internal:true}}]` shape
(BC-3.5.001/006/007 unchanged) — the mention node in the body and the
visibility property are independent; the presence of a mention does not add,
drop, or mutate the visibility property. `jr` makes NO delivery guarantee
(EC-3.5.013-3 is a documented non-error, not an assertion target).

### VP-674-020 — `--dry-run` forces non-interactive `@Name` resolution (wiremock/CLI-integration)
**Technique**: wiremock/CLI-integration test, with the `JR_STDIN_IS_TTY=1` debug
seam forcing TTY mode (the same seam VP-674-010's interactive branch uses).
**Pins**: BC-3.4.032 point 5 — `issue edit --dry-run` passes `no_input = true`
UNCONDITIONALLY (not the ambient no_input).
**Property**: `jr issue edit <KEY> --description "cc @<ambiguous-name>"
--markdown --dry-run`, run with stdin FORCED to a TTY via `JR_STDIN_IS_TTY=1`,
resolves the AMBIGUOUS `@Name` through the NON-interactive branch — it takes the
exit-64 error-with-candidates path and **NEVER** pops a `dialoguer::Select`
prompt (no interactive read, no hang). The wiremock mock serves the ambiguous
`GET /rest/api/3/user/search?query=…` response (two+ active matches); the test
asserts (a) exit code 64, (b) the candidate list on stderr (reuse the
BC-X.7.008 disambiguation substrings VP-674-003/VP-674-010 pin), (c) **no**
interactive prompt fired / the process does not block, and (d) **zero**
POST/PUT (dry-run performs no write regardless).
**Why this VP exists (M3)**: no prior VP pins the dry-run override. VP-674-010
exercises the general resolver's interactive/non-interactive branches, but keyed
on the AMBIENT no_input — at a TTY without `--dry-run` it takes the interactive
prompt branch. A mutant that threads the ambient no_input into the `--dry-run`
path (instead of forcing `no_input = true`) would therefore pop a
`dialoguer::Select` prompt (or hang) on an ambiguous `@Name` at a TTY during
`--dry-run`, yet pass all 19 other VPs — VP-674-020 is the only assertion that
distinguishes forced-true from ambient in the dry-run path.
**Relationship to VP-674-010**: VP-674-010 pins the resolver's
interactive-vs-non-interactive taxonomy in the NON-dry-run path (ambient
no_input drives the branch); VP-674-020 pins that `--dry-run` OVERRIDES the
ambient TTY state and forces the non-interactive branch. Complementary,
non-overlapping. Suggested name:
`test_bc_3_4_032_dry_run_forces_non_interactive_mention_resolution`.

### VP-674-021 — Single `@Name` result must NAME-MATCH or hard-error (wiremock/CLI-integration)
**Technique**: wiremock/CLI-integration test. **Pins**: BC-X.7.007 (the
unique-match source contract). **HUMAN DECISION (cycle-005 F2): tighten
single-result resolution.**
**Property**: a `@Name` search is resolved ONLY when, AFTER the active-filter and
the `filter_by_name_match` reduction, exactly ONE result's display name CONTAINS
the typed query (case-insensitive substring, matching `partial_match` semantics).
A single result whose name does NOT contain the query MUST hard-error (exit 64),
NOT silently resolve; a set of 2+ active results reduced by name-match to exactly
one resolves to that lone name-match with no ambiguity prompt.
**Fixture ground-truth note (F2 adversarial pass-6, M-1)**: `User.active` is
`Option<bool>` (`src/types/jira/user.rs`) and BC-X.7.007 point 1's active-filter
(`active == Some(true)`) runs FIRST, before `filter_by_name_match`, and
`User.account_id` is a required `String`. Every fixture below therefore carries
`"active": true` AND an `"accountId"` — so each result PASSES the active-filter,
and the exit-64 in case 1 is produced by the NAME-MATCH filter, NOT the
active-filter. This is what makes the VP discriminate mutation class 10 (remove
`filter_by_name_match`): a fixture missing `"active"` would deserialize to `None`,
be dropped by the active-filter BEFORE `filter_by_name_match` even runs, and the
VP would then (wrongly) exit-64 via the active path — failing to discriminate the
target mutant. A fixture missing `"accountId"` would fail to deserialize entirely.
Three anchored wiremock cases:
1. **Non-matching lone result → hard error (via name-match, not active-filter).**
   `query=jsmith`, the `GET /rest/api/3/user/search?query=jsmith` mock returns
   exactly ONE ACTIVE user
   `[{"accountId":"acc-1","displayName":"John Smith","active":true}]` (name does
   NOT contain the substring `jsmith`; the user PASSES the active-filter, so it is
   `filter_by_name_match` — not the active-filter — that drops it) → `jr` exits
   **64** with the load-bearing substring `"No user found matching"` on stderr,
   the error message does **NOT** contain the `"deactivated"` substring (the
   discriminator against the all-inactive wording that would (wrongly) indicate an
   active-filter drop), and `jr` issues **ZERO** POST/PUT (the mention is NOT
   resolved to acc-1 — no `mention` node carrying acc-1 is ever emitted).
2. **Matching lone result → resolves.** `query=smith`, the same single active
   result `[{"accountId":"acc-1","displayName":"John Smith","active":true}]`
   (name DOES contain the substring `smith`) → resolves to `acc-1`, and the
   emitted body carries the `mention` node (POST/PUT proceeds).
3. **Multi-result reduction to a lone name-match → resolves (F2 adversarial
   pass-6, L-2).** `query=smith`, the mock returns TWO active users
   `[{"accountId":"acc-1","displayName":"John Smith","active":true},{"accountId":"acc-2","displayName":"Jane Doe","active":true}]`
   where only "John Smith" name-matches the substring `smith` (Jane Doe does not)
   → `filter_by_name_match` reduces the 2 candidates to exactly ONE, which resolves
   to `acc-1` with **NO** ambiguity prompt and **NO** exit-64. Pins the reduction
   behavior on a 2+ input set — guards a mutant that weakens `filter_by_name_match`'s
   reduction on 2+ inputs (e.g. keeps both survivors and triggers a false
   ambiguity, or keeps the wrong one).
**Why this VP exists (HUMAN DECISION)**: this directly guards against a regression
to the inherited `disambiguate_user` `len==1` short-circuit, which resolves ANY
lone search result regardless of whether the name actually matches the typed
query. VP-674-009 pins the unique EXACT-match happy path (a name that fully
matches), and VP-674-010 pins the ambiguous (2+) and zero-match (0) cases —
neither exercises the single-result-but-non-matching case, so a mutant that skips
the name-match check on the single-result path (or reuses the raw `len==1`
short-circuit) survives every other VP. VP-674-021 is the only assertion that
distinguishes "lone result whose name matches" (resolve) from "lone result whose
name does not match" (hard error).
**Relationship to VP-674-009 / VP-674-010**: VP-674-009 pins the happy-path unique
resolution + dedup call-count; VP-674-010 pins the 2+/0 taxonomy (2+ that stay
ambiguous after filtering, and the 0-result / empty-after-filter zero-match);
VP-674-021 pins the single-result NAME-MATCH gate AND the complementary 2+ case
that REDUCES to exactly one name-match (case 3) — distinct from VP-674-010's
non-reducible 2+ ambiguity. Complementary, non-overlapping. Suggested name:
`test_bc_x_7_007_single_result_must_name_match_or_hard_error`.

---

## 7. New Verification Properties — E2E Round-Trip Acceptance (JR_RUN_E2E-gated)

The human added a NEW live-Jira E2E requirement (DEC-344). Each wiring BC folds
its round-trip acceptance into a `JR_RUN_E2E=1` + `#[ignore]`-gated test in
`tests/e2e_live.rs`, inert in `cargo test`/`ci.yml`, running only in
`.github/workflows/e2e.yml`. All four use a CONTROLLED test account
(`JR_E2E_*` account, or `JR_E2E_MENTION_ACCOUNT_ID` — a new optional env seam
the F4 story SHOULD add to `docs/specs/e2e-live-jira-testing.md`'s env table
per the "grep CLAUDE.md for JR_* and document in the same commit" convention)
and are SELF-CLEANING per the `Drop`-guard / `jsm_self_close` conventions. Each
clean-skips (early return) when its required env is unset.

**Common acceptance shape**: write a comment/description containing a mention
(bracket or `@Name`), fetch the object back via the read API, and assert the
fetched ADF contains a `mention` node with the RESOLVED `attrs.id` matching the
controlled account.

### VP-674-016 — E2E `comment add` (PRIMARY scenario)
**Pins**: BC-3.5.013. `jr issue comment add <KEY> "cc @<test-user>" --markdown`
→ `GET /rest/api/3/issue/{key}/comment/{id}` → assert a `mention` node with the
resolved accountId in the comment's ADF. **This is the PRIMARY E2E acceptance
scenario** (comment add is named first in scope item 9). Self-cleans the
created comment (delete on teardown / `Drop`-guard).

### VP-674-014 — E2E `issue create` (platform)
**Pins**: BC-3.3.012. `jr issue create --description "cc [~accountid:<test-id>]"
--markdown` → `GET /rest/api/3/issue/{key}` → assert a `mention` node with
`attrs.id == <test-id>` in the description ADF. Self-cleans the created issue.

### VP-674-015 — E2E `issue edit`
**Pins**: BC-3.4.032. `jr issue edit <KEY> --description "cc @<test-user>"
--markdown` on a throwaway issue → fetch back → assert the resolved-accountId
`mention` node. Self-cleans.

### VP-674-017 — E2E JSM `issue create --request-type`
**Pins**: BC-3.8.018. `jr issue create --request-type <RT> --description "cc
[~accountid:<test-id>]" --markdown` against a JSM project → fetch the request
back → assert a `mention` node in `requestFieldValues.description`. Self-cleans
via `jsm_self_close` (JSM teardown convention — no "Done" transition name
assumption, `to.statusCategory.key == "done"` discovery). Gated additionally by
`JR_E2E_JSM_PROJECT`.

---

## 8. Proof-Strategy Summary (per VP)

| VP | Technique | Toolchain | Trigger surface | BC(s) |
|----|-----------|-----------|-----------------|-------|
| VP-674-001 | Property-based | proptest (`adf.rs::tests`) | `markdown_to_adf` bracket emission | BC-7.2.016, BC-X.7.010 |
| VP-674-002 | Example | `#[test]` (`adf.rs::tests`) | `markdown_to_adf_with_mentions` `attrs.text` | BC-7.2.017, BC-X.7.007 |
| VP-674-003 | Wiremock-integration | `tests/` | ambiguous `@Name` stderr reuse | BC-X.7.008 |
| VP-674-004 | Example/structural | `#[test]` (`adf.rs::tests`) | pure-fn signatures (no client) | BC-7.2.016 |
| VP-674-005 | **F4 empirical + example (FLAGGED)** | schema check → `#[test]` | mention mark composition | BC-7.2.016/017/018 |
| VP-674-006 | Property + example | proptest + `#[test]` | depth guard / INV-1 | BC-7.2.016 (BC-7.2.011/012) |
| VP-674-007 | Example | `#[test]` (`adf.rs::tests`) | `adf_to_text` mention fallback | BC-7.2.019, BC-7.2.004 |
| VP-674-008 | Property-based | proptest (`adf.rs::tests`) | `adf_to_text` no-panic at any nesting | BC-7.2.019 |
| VP-674-009 | Wiremock-integration | `tests/` | `@Name` unique + dedup call-count | BC-X.7.007 |
| VP-674-010 | Wiremock-integration | `tests/` | ambiguous+zero-match exit-64 taxonomy | BC-X.7.008/009 |
| VP-674-011 | Wiremock-integration | `tests/` | visibility-routing orthogonality | BC-3.5.013 |
| VP-674-012 | **Example regression (MECHANISM F4-VERIFY, FLAGGED)** | `#[test]` (`adf.rs::tests`) | `\@` escape observable (odd=literal / even=mention) | BC-7.2.018 |
| VP-674-013 | Wiremock-integration | `tests/` | accountId preflight dedup + hard error | BC-X.7.010 |
| VP-674-014 | E2E-gated | `tests/e2e_live.rs` (`JR_RUN_E2E`) | create round-trip | BC-3.3.012 |
| VP-674-015 | E2E-gated | `tests/e2e_live.rs` (`JR_RUN_E2E`) | edit round-trip | BC-3.4.032 |
| VP-674-016 | E2E-gated (PRIMARY) | `tests/e2e_live.rs` (`JR_RUN_E2E`) | comment-add round-trip | BC-3.5.013 |
| VP-674-017 | E2E-gated | `tests/e2e_live.rs` (`JR_RUN_E2E`) | JSM create round-trip | BC-3.8.018 |
| VP-674-018 | Property + example | proptest + `#[test]` (`adf.rs::tests`) | `find_mention_candidates` `@Name` detection grammar (boundary/charset/`/`-stop/trailing-trim) | BC-7.2.018 |
| VP-674-019 | Property + example + wiremock (2-part) | proptest + `#[test]` (`adf.rs::tests`) **and** wiremock (`tests/`) | (a) `markdown_to_adf_no_mentions` emits ZERO mention nodes both forms; (b) `--no-mentions` issues ZERO `/user/search` + ZERO `/user?accountId=` | H-NEW-MENTION-006, BC-3.3.012/3.4.032/3.5.013/3.8.018 |
| VP-674-020 | Wiremock/CLI-integration | `tests/` (+ `JR_STDIN_IS_TTY` seam) | `issue edit --dry-run` forces non-interactive `@Name` resolution (no prompt on ambiguous) | BC-3.4.032 |
| VP-674-021 | Wiremock/CLI-integration | `tests/` | single `@Name` result must name-match query or hard-error (exit 64, zero POST/PUT) | BC-X.7.007 |

**Technique tally (21 VPs)**: proptest 4 (VP-674-001/006/008/018 are
property-based, with 006 and 018 additionally carrying example anchors);
example-based unit / pure core 5 (VP-674-002/004/005/007/012);
wiremock-integration 7 (003, 009, 010, 011, 013, 020, 021); E2E-gated 4 (014, 015,
016, 017); hybrid pure+wiremock 1 (VP-674-019 — a two-part VP with a
proptest+example pure-side half in `adf.rs::tests` AND a wiremock call-count half
in `tests/`). Two are FLAGGED as F4-contingent (005 schema, 012 escape-mechanism).
VP-674-018, VP-674-019, VP-674-020, and VP-674-021 are NOT flagged — VP-674-018's
`@Name` grammar is fully decidable at F4 as a pure `find_mention_candidates`
property, VP-674-019's `--no-mentions` observable (zero emission + zero resolver
calls) is decidable at F4 with no runtime-schema or escape-mechanism dependency,
VP-674-020's `--dry-run` forced-non-interactive observable is a decidable
wiremock/CLI assertion (exit-64 + no-prompt via the `JR_STDIN_IS_TTY` seam) with
no F4 spike dependency, and VP-674-021's single-result name-match gate is a
decidable wiremock/CLI assertion (exit-64 + zero POST/PUT vs. resolve) with no F4
spike dependency.

---

## 9. Mutation-Testing Note (cargo-mutants scope)

- `src/adf.rs` is ALREADY in `.cargo/mutants.toml` §examine_globs — the new
  `find_mention_candidates` / `convert_mentions` / `markdown_to_adf_with_mentions`
  / `markdown_to_adf_no_mentions` / the `adf_to_text` `"mention"` arm all fall
  inside the mutation-tested surface automatically.
- **F4 ACTION REQUIRED**: the NEW effectful module `src/cli/issue/mentions.rs`
  is NOT covered by any existing `examine_globs` entry — the F4 story MUST add
  it (and the `pub(super)` `disambiguate_user` visibility bump's reachability
  is unaffected). `tests/mutants_glob_existence.rs` will fail if a stale glob is
  added, so add the real path in the same commit as the module.
- Expected surviving-mutant classes the VPs are designed to kill (attribution
  corrected per HIGH-3 — kills that require an `@Name` input are credited to
  **VP-674-018**, NOT VP-674-001, because VP-674-001 is defined strictly over
  the BRACKET form and emits NO `@Name` input):
  1a. **Bracket-form start-boundary mutation** (eligible-prefix set for
     `[~accountid:…]` widened/narrowed) → killed by VP-674-001 (property over
     eligible prefixes) + EC anchor EC-7.2.016-1.
  1b. **`@Name` start-boundary mutation** (the `@`-opener rule loosened — e.g.
     mid-word `@` accepted, so `user@example.com` would be detected, or the
     after-whitespace/`*_~(` set changed) → killed by **VP-674-018** (the
     `@Name` detection-grammar property) + EC anchor **EC-7.2.018-1** (email
     exclusion). *(Was mis-credited to VP-674-001, which never emits `@Name`.)*
  2a. **Bracket id charset mutation** (bracket id charset drops `:`/`-`, or the
     id is UUID-normalized) → killed by VP-674-001 (verbatim-id property).
  2b. **`@Name` charset / single-token mutation** (`@Name` charset admits `/`
     so `@angular/core`→`angular/core`, or the trailing-punctuation trim is
     removed so `@jsmith.`→`jsmith.`) → killed by **VP-674-018** + EC anchors
     **EC-7.2.018-2** (npm `/`-stop) and **EC-7.2.018-5** (trailing-trim).
     *(Was mis-credited to VP-674-001.)*
  3. **Fallback-precedence swap** in the `adf_to_text` mention arm (id checked
     before text, or `@?` never reached) → killed by VP-674-007's 4-row matrix.
  4. **Dedup deletion** (per-invocation dedup removed → N calls instead of 1)
     → killed by VP-674-009 / VP-674-013 call-count assertions (the reason
     those are wiremock `verify`-count tests, not just outcome tests).
  5. **Zero-match policy flip** (hard-error → pass-through, reverting the
     human-approved override) → killed by VP-674-010 (exit-64 + zero-POST
     assertion, explicitly NOT exit-0).
  6. **Visibility-property mutation** on a mention-bearing comment → killed by
     VP-674-011.
  7. **`\@`-escape parity mutation** (odd/even backslash logic inverted or
     dropped) → killed by VP-674-012 (both the odd=literal and even=genuine
     anchors), F4-contingent on the escape mechanism landing.
  8. **`no_mentions` still converts / still resolves** —
     `markdown_to_adf_no_mentions` collapsed into `markdown_to_adf` (so a bracket
     `[~accountid:X]` still emits a `mention` node), OR the `--no-mentions` flag
     dropped/negated so the CLI resolver still runs (`/user/search` /
     `/user?accountId=` still called) → killed by **VP-674-019**: part (a)'s
     zero-mention-node + differential-vs-default assertions kill the pure-side
     collapse, part (b)'s wiremock ZERO-`/user/search` + ZERO-`/user?accountId=`
     call-count assertions kill the resolver-not-skipped mutation. This class
     was previously UNGUARDED (VP-674-004 only pins the client-free signatures,
     which a collapsed `no_mentions` retains) — the exact hole M1 identified.
  9. **`--dry-run` threads ambient no_input instead of forcing true** — the
     dry-run edit path threads the AMBIENT `no_input` into the `@Name` resolver
     instead of forcing `no_input = true`, so an ambiguous `@Name` at an
     interactive TTY during `--dry-run` pops a `dialoguer::Select` prompt (hang /
     interactive read) instead of taking the exit-64 error-with-candidates path
     → killed by **VP-674-020** (the `JR_STDIN_IS_TTY=1` + `--dry-run` +
     ambiguous-`@Name` assertion of exit-64 + no-prompt + zero POST/PUT). This
     class was previously UNGUARDED (VP-674-010 keys on the ambient no_input, so
     it cannot distinguish forced-true from ambient in the dry-run path) — the
     exact hole M3 identified.
  10. **Single-result name-match check skipped / raw `len==1` short-circuit
     reused / `filter_by_name_match` reduction weakened** — the single-result
     resolution path drops the name-match check (or reverts to the inherited
     `disambiguate_user` `len==1` short-circuit), so a lone search result whose
     display name does NOT contain the typed query is silently resolved instead of
     hard-erroring; OR `filter_by_name_match`'s reduction on a 2+ result set is
     weakened → killed by **VP-674-021** (case 1: `query=jsmith` → single ACTIVE
     `[{"accountId":"acc-1","displayName":"John Smith","active":true}]` → exit-64
     via the NAME-MATCH filter (the active-filter passes, so the drop is by
     `filter_by_name_match`) + `"No user found matching"` + NO `"deactivated"`
     substring + zero POST/PUT; case 2: `query=smith` → same active result →
     resolves to acc-1; case 3: `query=smith` → TWO active users (John Smith +
     Jane Doe) where only "John Smith" name-matches → reduces to the lone
     name-match acc-1, resolves with no ambiguity prompt — the three cases together
     force the name-match gate AND its 2+ reduction to be present and correct).
     This class was previously UNGUARDED (VP-674-009 pins the exact-match happy
     path and VP-674-010 the 2+/0 taxonomy; neither exercises the
     single-result-but-non-matching case nor the reduce-2+-to-one-name-match case)
     — the exact hole the HUMAN DECISION to tighten single-result resolution
     identified. The fixtures carry `"accountId"` + `"active": true` so the class-10
     kill is attributable to `filter_by_name_match`, not the upstream active-filter
     (F2 adversarial pass-6, M-1).
- **Run gate**: `cargo mutants --in-diff <pr-diff> --jobs 4 --timeout 240` per
  `docs/specs/cargo-mutants-policy.md`. Surviving mutants in classes 1–10 block
  the F6 gate.

---

## 10. Existing Verification Properties Reviewed (none invalidated)

- **BC-7.2.004 amendment**: the reverse-path drop-set narrowed from
  {mention, emoji, inlineCard, media} to {emoji, inlineCard, media}. No existing
  VP pinned "mention is silently dropped" (BC-7.2.004 had no inline VP
  subsection pre-#674). VP-674-007's second anchor pins that emoji/inlineCard/
  media are STILL dropped, so the amendment is fenced. **No existing VP
  retracted.**
- **VP-692-002 / VP-692-004** (dry-run "stdout EMPTY on error"): NOT modified —
  they are declared MUST-STAY-GREEN and additionally re-exercised with a
  mention-resolution failure as a new error source (BC-3.4.032 point 2). Listed
  in BC-3.4.032's Verification Properties as pre-existing pins.
- **VP-571-005** (JSM path parity): the same by-construction argument (single
  shared `markdown_to_adf_with_mentions` engine for platform and JSM POST
  bodies) extends to mentions — BC-3.8.018 records this as a "VP-571-005-style
  parity note", not a new VP (the invariant is the emitter's, already pinned by
  VP-674-001/002).
- `updated_vps: []` — no existing VP's contract changed.

---

## 11. Under-Specified / Flagged Items Carried to F4 (verification lens)

0. **F4-CONTINGENCY REGISTER + F3/F4 GATE ENFORCEMENT (LOW-6)** — exactly TWO
   VPs in this delta are F4-contingent: **VP-674-005** (mark composition, anchor
   shape awaits an Atlaskit schema finding) and **VP-674-012** (the `\@` escape
   MECHANISM, incl. the even-backslash genuine-mention case). The F3/F4 gate
   MUST enforce the scope-cut routing: if the `\@` escape proves infeasible after
   the F4 spike (both offset-iter correlation AND sentinel pre-parse
   impractical), the F4 story MUST route a scope decision to the orchestrator —
   the feature MUST NOT ship silently without the escape. This is a hard gate
   checkpoint, not advisory. VP-674-018 is explicitly NOT on this register (its
   `@Name` grammar is fully decidable at F4). (§4, §5, §8)
1. **VP-674-005 (mark composition)** — F4 EMPIRICAL SCHEMA CHECK required
   before the anchor shape is fixed; may trigger a same-PR spec companion edit
   to BC-7.2.016 EC-7.2.016-5. (§4)
2. **VP-674-012 (`\@` escape mechanism)** — observable property is authorable
   (both odd=literal and even=genuine-mention cases); the MECHANISM (offset-iter
   correlation vs. sentinel pre-parse) is UNPROVEN. If both prove impractical at
   F4, route a scope-cut back to the orchestrator; do not ship the feature
   without the escape silently. (§5)
3. **`src/cli/issue/mentions.rs` mutants scope** — MUST be added to
   `.cargo/mutants.toml` examine_globs in the F4 commit that creates it. (§9)
4. **`JR_E2E_MENTION_ACCOUNT_ID` (proposed)** — if F4 needs a dedicated
   controlled mention target distinct from the existing `JR_E2E_*` account, add
   the env seam AND its `docs/specs/e2e-live-jira-testing.md` table row AND a
   `tests/*_release_gate.rs` pin in the same commit (per the JR_* seam
   convention), OR reuse the existing E2E account and note it. (§7)
5. **VP-COUNT-RECONCILIATION** — NOT resolved here (out of scope, non-blocking);
   the `674` prefix firewalls the 21 new ids from any existing id regardless of
   the resolved global count. (§1)
6. **VP-674-018 BC-7.2.018 citation handoff — COMPLETED (L3).** The product-owner
   has already added the VP-674-018 `**Verification Properties**:` citation to
   BC-7.2.018's subsection (`bc-7-output-render.md § BC-7.2.018`); no further
   action required. (§2, §4)
7. **VP-674-019 H-NEW-MENTION-006 citation handoff — COMPLETED (M1; confirmed
   present pass-4, L1).** VP-674-019's citation is already present in
   H-NEW-MENTION-006's Status line in `holdout-scenarios.md`; no further
   product-owner action required. (§2, §4A)
8. **VP-674-020 BC-3.4.032 citation handoff — COMPLETED (M3; confirmed present
   pass-5, L-1).** VP-674-020 is a NEW VP allocated (cycle-005 F2 adversarial
   pass-4) pinning the `--dry-run` forced-non-interactive observable. The
   product-owner has already added its `**Verification Properties**:` citation to
   BC-3.4.032's subsection (`bc-3-issue-write.md § BC-3.4.032`, present at
   `bc-3-issue-write.md:~3585`; BC-3.4.032 point 5); no further product-owner
   action required. VP-674-020 is explicitly NOT on the F4-contingency register —
   its observable is a decidable wiremock/CLI assertion via the `JR_STDIN_IS_TTY`
   seam. (§2, §6)
9. **VP-674-021 BC-X.7.007 citation handoff — COMPLETED (HUMAN DECISION;
   confirmed present pass-5, L-1).** VP-674-021 is a NEW VP allocated (cycle-005
   F2 — HUMAN DECISION: tighten @Name single-result resolution) pinning the
   single-result name-match gate (a lone result whose name does not contain the
   query hard-errors exit-64; a matching lone result resolves). The product-owner
   has already added its `**Verification Properties**:` citation to BC-X.7.007's
   subsection (`cross-cutting.md § BC-X.7.007`, present at `cross-cutting.md:~717`);
   no further product-owner action required. VP-674-021 is explicitly NOT on the
   F4-contingency register — its observable is a decidable wiremock/CLI assertion
   (exit-64 + zero POST/PUT vs. resolve). (§2, §6)

---

## 12. DTU / Gene-Transfusion Assessment

Not applicable. Issue #674 introduces no new external service dependency and no
reference implementation in another language. The Jira REST endpoints reused
(`/user/search`, `/user?accountId=`, `/issue`, `/servicedeskapi/request`) are
all already exercised by existing wiremock fixtures and the existing e2e suite;
no new DTU behavioral clone is warranted (`dtu_required: false` per the
cycle-005 F1 record).

---

## 13. Project Convention Note

This project inlines Verification Properties directly in BC body files rather
than maintaining separate `VP-INDEX.md`, `verification-architecture.md`, or
`verification-coverage-matrix.md` files (none exist in this repository — `find`
confirmed). See §"Project Convention Note" in
`.factory/phase-f2-spec-evolution/verification-delta-571.md` and
`verification-delta-398.md` for the same statement. VP-674-001..021 are
registered as `**Verification Properties**:` subsections within the BC bodies
(and, for VP-674-019, the holdout H-NEW-MENTION-006 Status line) in
`bc-7-output-render.md`, `cross-cutting.md`, `bc-3-issue-write.md`, and the
holdout scenarios file; this delta firmed the six placeholder citations to
concrete ids (§2), confirmed the VP-674-018 BC-7.2.018 citation handoff COMPLETE
(present at `bc-7-output-render.md § BC-7.2.018`, §2 / §11 item 6), confirmed the
VP-674-019 H-NEW-MENTION-006 citation handoff COMPLETE (present in
`holdout-scenarios.md`, §2 / §11 item 7), confirmed the VP-674-020 BC-3.4.032
citation handoff COMPLETE (present at `bc-3-issue-write.md:~3585`, §2 / §11
item 8), and confirmed the VP-674-021 BC-X.7.007 citation handoff COMPLETE
(present at `cross-cutting.md:~717`, §2 / §11 item 9). Citations in
this delta use SYMBOL-FORM (`<file> § <BC-id>`) per CLAUDE.md's
citation-discipline convention rather than drift-prone `<file>:NN` line numbers.
No separate index propagation is required, and ARCH-INDEX.md needs no change (no
verification subsystem is tracked there).
