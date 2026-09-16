---
document_type: story
level: ops
story_id: "S-cycle13-letchain-retrofit-convention-cleanup"
epic_id: "MSRV-1.88-BUMP"
title: "Let-chain retrofit at 3 sites + retire CLAUDE.md No-let-chains convention"
wave: 2
status: draft
intent: enhancement
feature_type: refactor
mode: feature
scope: standard
severity: LOW
trivial_scope: false
producer: story-writer
timestamp: "2026-09-15T00:00:00"
phase: 3
inputs:
  - ".factory/cycles/cycle-013/phase-f1-delta-analysis/delta-analysis.md"
  - ".factory/specs/architecture/decisions/ADR-0025-raise-msrv-to-1-88.md"
  - ".factory/cycles/cycle-013/phase-f2-spec-evolution/verification-delta.md"
  - "src/cli/auth/keychain.rs"
  - "src/cli/board.rs"
  - "src/cli/issue/list.rs"
  - "CLAUDE.md"
  - ".factory/specs/prd/bc-5-boards-sprints.md"
  - ".factory/specs/prd/cross-cutting.md"
input-hash: "29ac0d0"
traces_to: "ADR-0025 Consequences (Negative) §4; BC-5.3.001; BC-5.3.002"
cycle: cycle-013-msrv-1.88-bump
estimated_effort: medium
estimated_days: 1.5
target_module: "src/cli/auth/keychain.rs, src/cli/board.rs, src/cli/issue/list.rs, CLAUDE.md"
subsystems: ["SS-02"]
depends_on: ["S-cycle13-msrv-cargo-ci-atomic-bump"]
blocks: []
behavioral_contracts: ["BC-5.3.001", "BC-5.3.002"]
bcs: ["BC-5.3.001", "BC-5.3.002"]
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0025"]
sd_refs: []
priority: P1
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-013/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: tdd
tdd_mode: strict
module_criticality: MEDIUM
points: 5
acceptance_criteria_count: 9
assumption_validations: []
risk_mitigations: []
created: "2026-09-15"
version: "1.0"
last_updated: "2026-09-15"
breaking_change: false
retroactive: false
origin: >
  cycle-013 msrv-1.88-bump, Wave 2, depends_on: [S-cycle13-msrv-cargo-ci-atomic-bump] because
  let-chain syntax (`if let Some(x) = y && cond { ... }`) only compiles once the repo's real
  MSRV floor is 1.88 in CI (Story 1's Cargo.toml/ci.yml change) — a hard compile-order
  dependency, not an editorial recommendation. F2 verification-delta.md §2/§4 corrects an F1
  assumption: src/cli/board.rs (~L231) and src/cli/issue/list.rs (~L760) are NOT the same
  simple two-level pattern as src/cli/auth/keychain.rs (~L50) — they are a three-level nested
  if/else with a `let uuids = ...` computation interposed between the second and third
  conditions, and they directly implement BC-5.3.001/BC-5.3.002 (Team-column gating). This
  story's Task list treats the three sites as two distinct classes of change, per that
  correction, and requires the full tests/team_column_parity.rs + relevant
  tests/cli_handler.rs suite to run red->green around the board.rs/list.rs sites specifically,
  not just narrow per-branch unit coverage. This story additionally refreshes prose-currency
  debt in BC-X.13.007's Invariants (cross-cutting.md) and BC-5.3.001's "three-level nested if"
  Behavior description, tracked as CYCLE-013-F4-BC-PROSE-CURRENCY /
  CYCLE-013-F4-LETCHAIN-BC-COUPLING drift items per the orchestrator's task framing (both
  become stale only once Story 1's ci.yml/ci_gate_completeness.rs values AND this story's
  code shape actually change — bundled here since this story is the one that lands after
  Story 1 is CI-green and is the direct implementer of the BC-5.3.001 prose it refreshes).
  Human-approved at the F1 gate (2026-09-15) as part of the 3-story MSRV bump decomposition.
---

> **tdd_mode:** `strict` — this is a behavior-preserving refactor of code that implements
> BC-5.3.001/BC-5.3.002 (Team-column gating). The Red Gate discipline here is: run the FULL
> `tests/team_column_parity.rs` + relevant `tests/cli_handler.rs` suite RED (temporarily revert
> or stub the refactor) before applying the let-chain collapse, then GREEN after, to prove the
> collapse is truly behavior-preserving rather than merely "looks equivalent." This is NOT a
> from-scratch `todo!()` stub cycle (there is no new function signature to stub) — the Red Gate
> here is regression-proof-by-toggle, not new-code-by-stub.

> **Execute:** `/vsdd-factory:deliver-story S-cycle13-letchain-retrofit-convention-cleanup`

# S-cycle13-letchain-retrofit-convention-cleanup — Let-chain retrofit (3 sites) + convention deletion

## Narrative

- **As a** `jr` contributor writing or reading `src/cli/auth/keychain.rs`, `src/cli/board.rs`,
  or `src/cli/issue/list.rs`
- **I want to** the three MSRV-driven nested-`if` workaround sites collapsed into let-chains,
  and CLAUDE.md's "No let-chains" convention entry (plus its three citing in-code comments)
  removed
- **So that** the codebase stops carrying a lint-policy exception whose own stated trigger for
  deletion ("Temporary — delete this entry ... when MSRV is raised to ≥1.88") has now fired,
  and new/reviewed code can use the more concise, drop-order-equivalent let-chain form without
  contradicting a stale convention note

## Behavioral Contracts

This story does **not** add or modify any BC postcondition. `BC-5.3.001`/`BC-5.3.002` govern
**outcome-level** behavior (does the "Team" column appear, what does each cell contain) that is
unchanged by this syntax-only refactor — F2 verification-delta.md §2 independently verified
(not merely inherited from F1) that Rust 1.88's let-chains stabilization was deliberately
sequenced (the `if let` temporary-scope change) so that this class of collapse produces
matching, not diverging, drop order versus the nested form. This story's ACs trace to the
EXISTING postconditions of `BC-5.3.001`/`BC-5.3.002` as a regression-proof obligation (the
refactor must not break them), not as new contract content, plus a prose-currency correction to
those same BCs' descriptive text (AC-007 and AC-009 below; AC-008, also below, is a sibling
prose-currency correction but covers a different BC — `BC-X.13.007` in `cross-cutting.md`, not
`BC-5.3.001`/`BC-5.3.002`).

## Acceptance Criteria

### AC-001 (traces to ADR-0025 Consequences/Negative §4 — simple two-level site)
`src/cli/auth/keychain.rs`'s nested form (currently ~L50: `if let Ok(v) =
std::env::var(env_name) { if !v.is_empty() { return Ok(v); } }`) collapses to a single
let-chain: `if let Ok(v) = std::env::var(env_name) && !v.is_empty() { return Ok(v); }`. The
"Nested if (not a let-chain)" marker comment above this site is removed (it no longer
describes the code below it).
**Test:** existing unit test coverage for this credential-resolution helper (present/non-empty
and absent/empty branches) passes unmodified; `cargo check` compiles under the 1.88 floor
established by Story 1.

### AC-002 (traces to BC-5.3.001 postcondition 1, BC-5.3.002 postcondition 1 — board.rs three-level site)
`src/cli/board.rs`'s three-level nested `if`/`else { Vec::new() }` structure (~L231, currently
`if matches!(output_format, OutputFormat::Table) { if let Some(field_id) = team_field_id { let
uuids = ...; if uuids.iter().any(...) { ... } else { Vec::new() } } else { Vec::new() } } else
{ Vec::new() }`) is restructured using let-chains **without changing the outcome-level
Team-column gating behavior** BC-5.3.001/BC-5.3.002 specify. Because let-chains cannot interpose
an arbitrary statement (the `let uuids = ...` computation) between chained conditions, the
implementer chooses EITHER: (a) restructure so the `uuids` computation itself is expressed as
part of a chained `let` binding compatible with the let-chain form, collapsing all three
conditions into one chain, OR (b) collapse the first two conditions
(`matches!(output_format, OutputFormat::Table) && let Some(field_id) = team_field_id`) into one
let-chain and leave the third condition (`uuids.iter().any(...)`) as a nested `if` after the
`let uuids = ...` statement. **Strategy (a) carries a lint-viability caveat: folding the
`let uuids = ...` statement itself into a single 3-condition let-chain requires an irrefutable
`let` pattern inside the chain, which trips clippy's `irrefutable_let_patterns` lint under
`-D warnings` (and `#[allow]` suppression is forbidden by CLAUDE.md's no-lint-suppression
convention) — or, depending on how the binding is expressed, may not be expressible as a
mid-chain statement at all. Strategy (b) does not have this problem (the `let uuids = ...`
statement stays a plain statement, never folded into the chain itself). Default to strategy
(b) unless the implementer confirms strategy (a) compiles clean under
`cargo clippy -- -D warnings` with no suppression.** Either shape is acceptable if it compiles
clean; the choice must preserve TWO distinct short-circuit gates, not one (F-L1, Pass-3
correction — `uuids` itself is NOT the filesystem-effecting operation, it is an in-memory
`issues.iter().map(|i| i.fields.team_id(...)).collect()` allocation; the actual filesystem read
is `crate::cache::read_team_cache`, nested one level deeper still, inside the third condition's
(`uuids.iter().any(...)`) true branch):
1. The `uuids` map allocation itself must not execute unless `output_format == Table` AND
   `team_field_id.is_some()` (the first two gates).
2. The `crate::cache::read_team_cache` call — the actual side-effecting filesystem read — must
   not execute unless ALL THREE conditions pass, i.e. additionally `uuids.iter().any(|u|
   u.is_some())` (the third gate), per ADR-0025 Consequences "current code intentionally avoids
   the team-cache filesystem read unless the first two gates already passed" (that ADR prose
   describes the READ's own two-gate minimum, not `uuids`'s gating — `uuids` sits strictly
   upstream of the read and has the same first-two-gate requirement independently).

Both gates must be reviewed independently in whichever let-chain shape is chosen — collapsing
condition 3 into a chain must not accidentally hoist `read_team_cache` above condition 3's own
check. **Neither gate is detectable by the outcome-level test suite (see EC-001); both are a
manual code-review obligation, and the reviewer should locate `read_team_cache`'s call site
specifically (not just `uuids`'s) when checking gate 2.** The "Nested if (not a let-chain)"
marker comment is removed.
**Test:** the FULL `tests/team_column_parity.rs` suite (not just the board.rs-specific subset)
plus `tests/cli_handler.rs` team-column tests run red (temporarily, via a local
revert-and-diff check) then green around this change — `board_view_kanban_shows_team_column_when_populated`,
`test_board_view_omits_team_column_when_field_unconfigured`,
`test_board_view_falls_back_to_uuid_when_team_not_cached`, and the mixed-set `"-"` arm behavior
(BC-5.3.001 postcondition 1, clause (c)) all pass unmodified in outcome.

### AC-003 (traces to BC-5.3.001 postcondition 1, BC-5.3.002 postcondition 1 — issue/list.rs three-level site)
`src/cli/issue/list.rs`'s structurally identical three-level site (~L760) is retrofitted using
the SAME strategy choice ((a) or (b) from AC-002) as `board.rs`'s site, for consistency between
the two call sites BC-5.3.001's own Behavior prose already groups together ("Implementation form
differs by call site... `src/cli/board.rs::handle_view` and `src/cli/issue/list.rs::handle_list`
express the three conditions as a three-level nested if"). The "Nested if (not a let-chain)"
marker comment is removed.
**Test:** `tests/team_column_parity.rs::test_issue_list_omits_team_column_when_field_unconfigured`,
`tests/cli_handler.rs::test_list_shows_team_column_with_cached_name`,
`::test_list_omits_team_column_when_no_issue_has_team`,
`::test_list_team_column_falls_back_to_uuid_when_cache_missing` all pass unmodified in outcome,
run red->green around the change per the same discipline as AC-002.

### AC-004 (traces to ADR-0025 Consequences/Positive — retire the CLAUDE.md convention entry)
CLAUDE.md's Conventions section entry beginning "**No let-chains.** `if let … && …` / `… && let
…` syntax requires Rust ≥1.88 with edition 2024; MSRV is 1.85..." (line ~186) is deleted in its
entirety — its own text names its deletion trigger ("Temporary — delete this entry and the
three citing in-code comments when MSRV is raised to ≥1.88"), which has now fired.
**Test:** `grep -c "No let-chains" CLAUDE.md` returns 0 (the retrospective mention in this
story's own body/history does not count — this checks the live CLAUDE.md convention entry
only); `tests/claude_md_citations.rs::test_claude_md_citations_resolve_to_real_files` remains
green (no file-path citation is removed by this deletion, since the entry cited no file paths
of its own).

### AC-005 (traces to AC-001/002/003 — remove all three "Nested if (not a let-chain)" marker comments)
All three source-level marker comments ("Nested if (not a let-chain): let-chains require Rust
>= 1.88 + edition 2024; MSRV is 1.85. See CLAUDE.md Conventions — No let-chains.") are removed
as part of the same retrofit (subsumed by AC-001/002/003's own text but stated as an explicit,
independently-checkable AC per CLAUDE.md's own instruction: "delete this entry and the three
citing in-code comments").
**Test:** `grep -rn "Nested if (not a let-chain)" src/` returns zero matches after this story.

### AC-006 (traces to CLAUDE.md conventions — CHANGELOG delivery task)
`CHANGELOG.md`'s `[Unreleased]` section gains a `Changed` entry noting the let-chain retrofit
and the retired "No let-chains" convention, cross-referencing this story and ADR-0025.
**Test:** N/A (doc artifact; verified by PR review); presence check only.

### AC-007 (traces to prose-currency debt — BC-5.3.001 Behavior description, tracked as CYCLE-013-F4-LETCHAIN-BC-COUPLING)
`.factory/specs/prd/bc-5-boards-sprints.md`'s `BC-5.3.001` Behavior field — which currently
describes `board.rs::handle_view` and `issue/list.rs::handle_list` as expressing "the three
conditions as a three-level nested `if`" — is updated to describe the POST-retrofit shape
(let-chain form per whichever of strategy (a)/(b) AC-002/AC-003 selected), so the BC's
descriptive prose matches the actual code shape after this story lands. This is a prose-only
update — the Postconditions themselves are outcome-level and are NOT edited (they remain true
regardless of control-flow syntax, per F2 verification-delta.md §2/§4).
**Test:** manual review — `BC-5.3.001`'s Behavior field text, read after this story's code
change, accurately describes the control-flow shape in `src/cli/board.rs`/`src/cli/issue/list.rs`
at that point (no automated test governs BC prose accuracy; this is a documentation-currency
obligation, not a code postcondition).

### AC-008 (traces to prose-currency debt — BC-X.13.007 Invariants, tracked as CYCLE-013-F4-BC-PROSE-CURRENCY)
`.factory/specs/prd/cross-cutting.md`'s `BC-X.13.007` scope-exclusion bullet — the BC's heading
is at ~L1894 ("The `test` job enforces a runtime-computed test-execution floor..."); the specific
bullet within its Invariants list that cites the literal strings `toolchain: "1.85.0"` and
`RUSTUP_TOOLCHAIN: "1.85.0"` is the "This BC also does not govern the `ci-gate` job's own
structural / pass-fail-semantics guards ... or the `msrv` job's toolchain-pinning guard" bullet
at ~L2074-2076 (self-disclaimed as descriptive prose, not a governed contract clause, by that
same bullet's own trailing text at ~L2092-2093: "with no corresponding BC or VP registered in
this PRD") — is updated to cite `"1.88.0"`, matching Story 1's already-landed
`ci.yml`/`tests/ci_gate_completeness.rs` change. This is bundled into this story (rather than
Story 1) because this story is the first cycle-013 story dispatched after Story 1 is CI-green,
and both prose-currency items (this AC and AC-007) are opportunistically bundled per the
orchestrator's task framing for this cycle.

**Accepted transient staleness window (cross-wave prose-currency, explicitly documented, not
silently absorbed):** between Story 1's merge (Wave 1) and this story's merge (Wave 2),
`BC-X.13.007`'s `"1.85.0"` citation is briefly stale relative to the actually-landed `ci.yml`
state. This window is accepted, not fixed by moving the prose update into Story 1, because: (1)
`BC-X.13.007`'s own paragraph already self-disclaims that these literal citations are
descriptive prose, not a governed contract clause — no gate or test reads this text as a source
of truth; (2) no automated guard (e.g. `scripts/check-bc-*.sh`) asserts currency of this specific
citation, so the window has no enforcement consequence; (3) folding this one-line prose fix into
Story 1 would add a `.factory/specs/prd/` file to Story 1's already-HIGH-risk, atomic-commit-
constrained file surface (`Cargo.toml`/`ci.yml`/`ci_gate_completeness.rs`) for no
build-order or correctness benefit — Story 1's own scope is deliberately narrow per its
Architecture Compliance Rules. (Pass-3 correction, F-H1 fallout: Story 1's file surface no
longer includes `tests/common/wf.rs` — an earlier revision of Story 1 mischaracterized its
~L1782-1784 decoy narrative as real and directed a bump; that was corrected to leave `wf.rs`
untouched entirely, so it is dropped from this list too.) The window closes at this story's
merge, same wave it always would have.
**Test:** manual review — `BC-X.13.007` Invariants text no longer cites `"1.85.0"`;
`scripts/check-bc-no-numeric-test-counts.sh` (if applicable — this is a version-string
citation, not a test-count enumeration, so out of that guard's scope) is unaffected either way.

### AC-009 (traces to prose-currency debt — BC-5.3.002 Behavior description, sibling correction to AC-007, tracked as CYCLE-013-F4-LETCHAIN-BC-COUPLING)
`.factory/specs/prd/bc-5-boards-sprints.md`'s `BC-5.3.002` Behavior field (~L238) currently
describes the PRE-retrofit control flow for the two retrofitted call sites — "inner branch (no
populated UUIDs) at ... `src/cli/board.rs::handle_view:~252` ... `src/cli/issue/list.rs::handle_list:~547`;
outer branch (unconfigured field) at ... `src/cli/board.rs::handle_view:~255` ...
`src/cli/issue/list.rs::handle_list:~550`" — and is updated in the SAME PR as AC-007's
`BC-5.3.001` refresh (F-M5, Pass-3: an earlier revision of this story refreshed `BC-5.3.001`'s
Behavior prose via AC-007 but left this sibling BC's Behavior field describing the pre-retrofit
shape, a drift the two BCs' shared "Implementation form differs by call site" framing makes
directly visible).

**F2 (Pass-5) — the `list.rs` line pointers this BC currently cites are ALREADY stale, independent
of this story's retrofit:** `bc-5-boards-sprints.md:238`'s `handle_list:~547`/`:~550` pair does
not match the live file — the real inner/outer `else { Vec::new() }` sites are at
`src/cli/issue/list.rs::handle_list:~784` (inner, no populated UUIDs) and `:~787` (outer,
unconfigured `team_field_id`), stale by ~237 lines (the `board.rs::handle_view:~252`/`:~255`
half of the same BC sentence IS accurate and needs no correction). This AC's refresh therefore
does not copy `~547`/`~550` forward as the "pre-retrofit" baseline to diff against — it CORRECTS
them to the real pre-retrofit line numbers (`~784`/`~787`) as part of landing the POST-retrofit
prose, so the citation drift does not survive into the updated BC. Per CLAUDE.md's citation-form
convention ("prefer symbol-form (`<file>::<fn>` or `… § "<comment>"`) over line numbers, which
drift on refactor"), the updated Behavior field should anchor on `handle_list`'s two
`else { Vec::new() }` branches by description (inner/no-populated-UUIDs vs. outer/unconfigured-
`team_field_id`) rather than on a fresh set of line numbers that will drift again at the next
`list.rs` edit; a `~NN`-prefixed approximate line MAY still accompany the symbol form as a
locator, consistent with existing BC citation style, but must not be the sole anchor.

The update describes the POST-retrofit shape for `board.rs`/`list.rs` (matching whichever of
strategy (a)/(b) AC-002/AC-003 actually selected — under the DEFAULT strategy (b), the merge
topology is NOT "the inner and outer branches merge" as an earlier revision of this AC stated
(F-F, Pass-4 correction): `board.rs`/`list.rs` each have THREE nesting levels, each with its own
`else { Vec::new() }` — level 1 (`output_format != Table`, not separately labeled by this BC's
current prose), level 2 ("outer branch", unconfigured `team_field_id`), and level 3 ("inner
branch", no populated UUIDs). Strategy (b) collapses only the first two conditions
(`matches!(output_format, OutputFormat::Table) && let Some(field_id) = team_field_id`) into one
let-chain, so it is **levels 1 and 2 — the two OUTER levels — whose `else { Vec::new() }`
branches merge into the let-chain's single combined `else`**; level 3's `else { Vec::new() }`
(the "inner branch" this BC's current prose already names) stays a separate, unmerged nested-`if`
`else` after the `let uuids = ...` statement, structurally unchanged in shape. The Behavior field
update must describe this actual topology — two-outer-levels-merge, inner-level-unchanged — not
a blanket "inner/outer merge" claim; if the implementer instead selects strategy (a) (full
three-condition collapse), the topology differs again and EC-004 governs writing the prose from
the real landed diff rather than either of this AC's illustrative shapes. The `src/cli/sprint.rs::handle_current:~312`/`:~315` portion
of this same Behavior sentence is explicitly PRESERVED UNCHANGED — `sprint.rs` is out of this
story's scope (EC-002; Architecture Compliance Rules row 3) and its `match`-arm gating form is
untouched by this retrofit. Postconditions are NOT edited (same rationale as AC-007 — outcome-
level, syntax-independent, per F2 verification-delta.md §2/§4).
**Test:** manual review — `BC-5.3.002`'s Behavior field text, read after this story's code
change, accurately describes the control-flow shape at all three call sites (post-retrofit form
for `board.rs`/`list.rs`, unchanged form for `sprint.rs`); no automated test governs BC prose
accuracy, same as AC-007.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| Credential env-var resolution helper | `src/cli/auth/keychain.rs` | pure-core (no I/O beyond the already-existing `std::env::var` call, unchanged by this refactor) |
| Team-column gating (board view) | `src/cli/board.rs::handle_view` | effectful-shell (reads `crate::cache::read_team_cache`, best-effort filesystem I/O) — BC-5.3.001/BC-5.3.002 |
| Team-column gating (issue list) | `src/cli/issue/list.rs::handle_list` | effectful-shell (same team-cache read) — BC-5.3.001/BC-5.3.002 |
| CLAUDE.md Conventions section | `CLAUDE.md` | N/A (project documentation) |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-001 | Strategy choice (a) (full three-condition let-chain via a restructured `uuids` binding) accidentally changes when the `uuids` map allocation OR the `crate::cache::read_team_cache` filesystem read executes (e.g., either now runs even when `output_format != Table`, or `read_team_cache` now runs without waiting for `uuids.iter().any(...)` to be true) | Regression — must not happen; AC-002/AC-003's two-gate laziness requirement exists specifically to catch this (F-L1, Pass-3: `uuids` is an in-memory allocation gated by the first two conditions; `read_team_cache` is the actual filesystem-effecting call, nested deeper still inside the third condition). **The red->green outcome-level test suite (`tests/team_column_parity.rs`, `tests/cli_handler.rs`) CANNOT detect this regression** — the team-cache read is best-effort and purely display-affecting; a table's rendered output is byte-for-byte identical whether the read fires eagerly or lazily (it only changes WHEN a filesystem call happens, not what ends up on screen). **The only laziness guard is manual code review**, and the reviewer must check `read_team_cache`'s placement specifically (not just `uuids`'s) against the two-gate requirement — see the Architecture Compliance Rules table, row 1. Defaulting to strategy (b) (AC-002) structurally preserves the original short-circuit order for both gates and is the lower-risk choice for this reason. |
| EC-002 | `src/cli/sprint.rs::handle_current`'s structurally-DIFFERENT team-column gating (a `match` arm on `OutputFormat::Table`, not a three-level nested `if`, per BC-5.3.001's own Behavior prose) is mistakenly "fixed" to match `board.rs`/`list.rs`'s new let-chain shape | Out of scope — `sprint.rs` is not in F1's affected-files manifest and carries no "Nested if (not a let-chain)" marker comment; do not touch it in this story |
| EC-003 | The let-chain collapse at `keychain.rs` (AC-001) is applied while Story 1's CI floor is not yet actually 1.88 (e.g., this story is dispatched out of wave order) | Compile failure under the `msrv` job (still at 1.85.0) — this is the exact reason `depends_on: [S-cycle13-msrv-cargo-ci-atomic-bump]` is a hard graph edge, not editorial; the wave scheduler must not dispatch this story before Story 1 merges |
| EC-004 | BC-5.3.001's prose refresh (AC-007) is written to describe strategy (a) or (b) but the implementer actually chose the other one | Must match the ACTUAL shape landed in code, not a presumed default — implementer writes AC-007's prose update in the same PR as the code change, from the real diff, not from this story spec's own illustrative text |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `src/cli/auth/keychain.rs` (retrofit site) | pure-core | Reads an already-resolved `Option<&str>`/env var; no new I/O introduced |
| `src/cli/board.rs::handle_view` (retrofit site) | effectful-shell | `crate::cache::read_team_cache` filesystem read, unchanged classification (already effectful before this refactor) |
| `src/cli/issue/list.rs::handle_list` (retrofit site) | effectful-shell | Same team-cache read, unchanged classification |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~3,800 |
| Referenced code (3 retrofit sites + surrounding function bodies, ~150 lines total; CLAUDE.md convention entry + 3 marker comments) | ~4,500 |
| Test files (`tests/team_column_parity.rs` full file, `tests/cli_handler.rs` team-column subset) | ~6,000 |
| BC prose (`bc-5-boards-sprints.md` §5.3, `cross-cutting.md` BC-X.13.007 region) | ~2,500 |
| Tool outputs overhead | ~2,500 |
| **Total** | **~19,300** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~10%** |

Well within budget.

## Tasks

1. [ ] Confirm `S-cycle13-msrv-cargo-ci-atomic-bump` has merged and `msrv` CI is green at
   1.88.0 before starting (hard dependency, EC-003) — `implementer`
2. [ ] Retrofit `src/cli/auth/keychain.rs` (~L50) to a let-chain; remove its marker comment
   (AC-001, AC-005) — `implementer`
3. [ ] Run the existing `keychain.rs` credential-resolution unit tests red (temporarily,
   diff-checked) then green — `implementer`
4. [ ] Retrofit `src/cli/board.rs` (~L231) choosing strategy (a) or (b) — **default to (b)**
   unless (a) is confirmed clean under `cargo clippy -- -D warnings` with no suppression (AC-002
   lint-viability caveat); remove its marker comment; document the choice in the PR description
   (AC-002, AC-005) — `implementer`
5. [ ] Run the FULL `tests/team_column_parity.rs` + relevant `tests/cli_handler.rs` suite red
   then green around the `board.rs` change (AC-002) — `implementer`
6. [ ] Retrofit `src/cli/issue/list.rs` (~L760) using the SAME strategy as `board.rs`; remove
   its marker comment (AC-003, AC-005) — `implementer`
7. [ ] Run the FULL `tests/team_column_parity.rs` + relevant `tests/cli_handler.rs` suite red
   then green around the `list.rs` change (AC-003) — `implementer`
8. [ ] Delete CLAUDE.md's "No let-chains" Conventions entry in full (AC-004) — `implementer`
9. [ ] Update `BC-5.3.001`'s Behavior field prose to describe the actual post-retrofit shape
   (AC-007) — `implementer`
10. [ ] Update `BC-5.3.002`'s Behavior field prose (~L238, `bc-5-boards-sprints.md`) for the
    `board.rs`/`list.rs` sites to match the actual post-retrofit shape landed in Task 4/6,
    PRESERVING the `sprint.rs:~312`/`:~315` portion of that same sentence unchanged (AC-009) —
    `implementer`, **same PR as Task 9**
11. [ ] Update `BC-X.13.007`'s scope-exclusion bullet (~L2074-2076, cross-cutting.md — NOT the
    BC's own heading at ~L1894/Invariants-section preamble) `"1.85.0"` citations to `"1.88.0"`
    (AC-008) — `implementer`
12. [ ] Run the full `cargo test` suite green (regression net beyond team-column tests) —
    `implementer`
13. [ ] Add a CHANGELOG entry under `[Unreleased] > Changed` (AC-006), before creating the PR —
    `implementer`

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|-----------------|--------------------------|------------------------|
| `S-cycle13-msrv-cargo-ci-atomic-bump` (this cycle, Wave 1, hard dependency) | Establishes the real 1.88 CI floor this story's let-chain syntax needs to compile; whatever comfy-table version/snapshot outcome Story 1 landed has no functional bearing on this story (disjoint files) but confirms the `msrv` job is genuinely green at 1.88.0 before this story starts | `cargo check --all-targets --locked` under 1.88.0 is now the enforcement mechanism that would catch a let-chain compile failure at CI time, not just locally | N/A yet — populate from Story 1's actual PR once merged |
| S-626-1 (prior, unrelated "let-chain rewrite" cited in `BC-5.3.002`'s Trace field) | Added `else { Vec::new() }` branch coverage for board view and issue list, using "let-chain" as loose prose for a nested-`let`/`if` refactor, NOT the real Rust `let_chains` language feature (which did not exist at 1.85) | The existing `else { Vec::new() }` branches at all three nesting levels are the exact behavior this story's retrofit must preserve bit-for-bit | F2 verification-delta.md flags this naming coincidence explicitly — do not confuse S-626-1's prior "let-chain" prose with this story's actual language-feature retrofit when reading `BC-5.3.002`'s Trace field |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| TWO distinct short-circuit gates must be preserved across the retrofit (F-L1, Pass-3): (1) the `uuids` map allocation (an in-memory `issues.iter().map(...).collect()`, NOT itself a filesystem operation) must not execute unless `output_format == Table` AND `team_field_id.is_some()`; (2) the actual filesystem-effecting call, `crate::cache::read_team_cache`, is nested one level deeper still — inside the third condition's (`uuids.iter().any(...)` — truthy when any UUID resolved) true branch — and must not execute unless that third condition is ALSO true | ADR-0025 Consequences (Negative) §4; existing code comment "Team cache read is best-effort for display" | Manual code review of the chosen let-chain shape (strategy (a) vs (b)), specifically locating `read_team_cache`'s call site (not just `uuids`'s) to verify gate 2; no automated laziness-specific test exists today (F1 §4 risk table notes this as covered by outcome-level tests, not a dedicated laziness probe) |
| `board.rs` and `issue/list.rs` retrofit sites must use the SAME let-chain strategy ((a) or (b)) for consistency, since BC-5.3.001's Behavior prose already groups them as implementing "the same" three-condition pattern | BC-5.3.001 Behavior field; this story's own AC-003 | PR review: both sites' diffs compared for structural consistency |
| Do not touch `src/cli/sprint.rs::handle_current` (a `match`-arm-based gating form, not a nested-`if` site) | F1 delta-analysis.md §3 (affected-files manifest does not list `sprint.rs`); BC-5.3.001 Behavior field (distinguishes the `match` form explicitly) | PR review: `git diff` scope check against `affected-files.txt` — the expected diff surface is F1's original manifest rows PLUS the two ADR-0025-anchored prose-currency files this story's own AC-007/AC-008 add (`.factory/specs/prd/bc-5-boards-sprints.md`, `.factory/specs/prd/cross-cutting.md` — see `affected-files.txt`'s Pass-3 F-M4 reconciliation note for these two rows, which are legitimately in-scope via ADR-0025 Consequences even though F1's delta-analysis did not originally identify them). Any file outside that combined set (e.g. `sprint.rs`) fails the check. |
| No `#[allow]` lint suppression — if the let-chain form somehow trips clippy, refactor further rather than suppress | CLAUDE.md Conventions ("No lint suppression without refactoring") | `cargo clippy -- -D warnings` in CI |

## Library & Framework Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| Rust toolchain | 1.88.0 (established by Story 1) | Let-chains (`if let ... && ...`) stabilize exactly here, edition-2024-gated; `jr` is already on edition 2024 |

_No dependency version changes in this story — pure language-feature adoption in already-owned
source files._

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/cli/auth/keychain.rs` | modify | Let-chain retrofit (AC-001) |
| `src/cli/board.rs` | modify | Let-chain retrofit, Team-column gating (AC-002) |
| `src/cli/issue/list.rs` | modify | Let-chain retrofit, Team-column gating (AC-003) |
| `CLAUDE.md` | modify | Delete "No let-chains" Conventions entry (AC-004) |
| `.factory/specs/prd/bc-5-boards-sprints.md` | modify | `BC-5.3.001` Behavior prose refresh (AC-007); `BC-5.3.002` sibling Behavior prose refresh, `sprint.rs` portion preserved (AC-009) |
| `.factory/specs/prd/cross-cutting.md` | modify | `BC-X.13.007` Invariants prose refresh (AC-008) |
| `CHANGELOG.md` | modify | `[Unreleased] > Changed` entry (AC-006) |
