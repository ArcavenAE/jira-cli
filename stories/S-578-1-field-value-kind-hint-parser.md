---
document_type: story
level: ops
story_id: "S-578-1"
epic_id: "none"
title: "--field NAME:kind=VALUE hint-syntax parser — FieldValueSpec/FieldValueKind, parse_field_kv extension"
wave: feature-followup
status: ready
intent: feature
feature_type: backend-cli
mode: feature
scope: standard
severity: HIGH
trivial_scope: false
points: 5
priority: P1
tdd_mode: strict
producer: story-writer
timestamp: "2026-08-26T00:00:00"
phase: 3
inputs:
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md"
  - ".factory/phase-f2-spec-evolution/verification-delta-field-dx.md"
input-hash: "8e0daa7"
traces_to: "src/cli/issue/create.rs::parse_field_kv"
cycle: field-dx
bundle: field-dx
estimated_effort: medium
estimated_days: 2
target_module: src/cli/issue/create.rs
subsystems: ["SS-02"]
depends_on: []
blocks: [S-578-2, S-578-3, S-578-4]
behavioral_contracts:
  [BC-3.4.026, BC-3.4.031]
verification_properties:
  [VP-578-005, VP-578-006, VP-578-013, VP-578-014]
holdout_anchors: []
nfr_anchors: []
adr_refs: [ADR-0019]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/bc-3-issue-write.md"
implementation_strategy: tdd
module_criticality: HIGH
acceptance_criteria_count: 10
assumption_validations: []
risk_mitigations: []
created: "2026-08-26"
version: "1.0"
last_updated: "2026-08-26"
breaking_change: false
retroactive: false
origin: >
  Feature Mode cycle field-dx, issues #580/#578 — part 2 of field-dx bundle (#580, #578).
  Extends `parse_field_kv` (`src/cli/issue/create.rs`) to parse the opt-in `NAME:kind=VALUE`
  hint syntax (`kind ∈ {option, id, name, asset}`), returning `HashMap<String, FieldValueSpec>`
  instead of `HashMap<String, String>`. This is the SHARED type/parser S-578-2 (edit),
  S-578-3 (JSM create), and S-578-4 (platform create) all consume verbatim — none of the
  three consumer stories may redefine or diverge the `FieldValueSpec`/`FieldValueKind` shape.
  Scheduled in Wave 1 alongside S-580-1: ADR-0019 is already Accepted, so there is no
  remaining design-lock blocker, and this story has zero code dependency on S-580-1 (both are
  pure-additive, non-overlapping files).
changelog:
  - "1.0 (2026-08-26): Initial story authored; F2 gate convergence; bundle field-dx (issues #580/#578), wave 1."
---

> **tdd_mode:** strict — Red Gate required. Write the extended `parse_field_kv_proptests`
> module in `src/cli/issue/create.rs` and the new `FieldValueSpec`/`FieldValueKind` unit tests
> FIRST — they MUST fail because `parse_field_kv` still returns `HashMap<String, String>`.
> Then implement the type change + parser extension. Red Gate: all tests FAIL → all tests PASS.

> **Execute:** `/vsdd-factory:deliver-story S-578-1`

# S-578-1: `--field NAME:kind=VALUE` Hint-Syntax Parser

**Bundle**: field-dx (issues #580, #578) — part 2 of 5
**GitHub issue**: #578 (item 1)
**BC anchors**: BC-3.4.026 (parser contract, `FieldValueSpec`/`FieldValueKind` shape), BC-3.4.031
(malformed-hint exit-64 catalog, companion to BC-3.4.026)
**VPs**: VP-578-005, VP-578-006, VP-578-013, VP-578-014
**Routing**: standard feature, Wave 1
**Sequencing**: no story dependencies (parallel with S-580-1 — both are pure-additive,
non-overlapping files: this story touches only `src/cli/issue/create.rs`'s `parse_field_kv`
block; S-580-1 touches only the new `src/cli/field.rs`/`src/api/jira/issues.rs`). **Blocks
S-578-2, S-578-3, S-578-4** — all three consume the `FieldValueSpec`/`FieldValueKind` shape and
the parser this story builds.

**Subsystem anchor justification**: `subsystems: ["SS-02"]` — SS-02 (CLI Layer) owns this
story's scope because `parse_field_kv` and the new `FieldValueSpec`/`FieldValueKind` types live
entirely in `src/cli/issue/create.rs` (CLI layer), per ADR-0019 §Context. No API-layer (SS-04)
or Assets (SS-05) code is touched — workspace-id resolution for `:asset` is explicitly a
call-site (S-578-2/3/4) concern, not this parser's.

**Dependency anchor justification**: `depends_on: []` — this story has zero code dependency on
any other story; it is a pure, self-contained extension of an existing function's return type.
`blocks: [S-578-2, S-578-3, S-578-4]` because each of those three stories threads
`FieldValueSpec` (instead of the pre-existing `String`) through their own `--field` call site,
and none of them may define a second, diverging `FieldValueSpec`/`FieldValueKind` — this is the
cross-story invariant the F3 orchestrator flagged explicitly ("do not let any of the three
consumer stories redefine or diverge the type").

---

## Narrative

- **As a** `jr` CLI user setting a custom field via `--field NAME=VALUE`
- **I want** an opt-in `--field NAME:kind=VALUE` hint syntax (`:option`/`:id`/`:name`/`:asset`)
  that declares the wire shape explicitly, bypassing `resolve_edit_fields`'s fuzzy-match
  heuristics for that value
- **So that** I can be unambiguous about intent — particularly in scripts — without changing
  observable behavior versus the bare (unhinted) form, and so I have an explicit, unconditional
  id-bypass, name-bypass, and Assets-object-reference composer available when the fuzzy match
  would be wrong or ambiguous

---

## Behavioral Contracts

| BC | Summary | Clauses Covered |
|----|---------|-----------------|
| BC-3.4.026 | `--field NAME:kind=VALUE` hint-syntax parser — `parse_field_kv` gains kind-tag parsing shared across all three `--field` call sites | Parser contract (5 numbered steps), Return-type change, Rule (ADR-0019 §2(b)), Preconditions, Postconditions, Invariants 1–4 |
| BC-3.4.031 | Malformed `--field NAME:kind=VALUE` hint edge cases — exit 64 catalog, companion to BC-3.4.026 | EC-1..9 (unknown kind, empty `:kind` segment, `:asset` malformed shapes EC-2a/b/c/d, non-numeric `objectId` EC-3, colon-in-VALUE EC-6, multi-colon-NAME EC-7, empty `:id`/`:name` pass-through EC-8/EC-9) |

---

## Acceptance Criteria

### AC-001: `parse_field_kv` return type changes to `HashMap<String, FieldValueSpec>`
(traces to BC-3.4.026 "Return-type change", Postconditions)

```rust
pub(crate) enum FieldValueKind { Option, Id, Name, Asset }
pub(crate) struct FieldValueSpec { pub kind: Option<FieldValueKind>, pub value: String }
pub(crate) fn parse_field_kv(pairs: &[String]) -> Result<HashMap<String, FieldValueSpec>, JrError>
```

`HashMap` (not `Vec`) is RETAINED per BC-3.4.015's existing rationale (last-wins-on-duplicate-key
semantics, structural fit with downstream consumers; no consumer needs argv order). Well-formed
hinted pairs produce `FieldValueSpec { kind: Some(_), value }`; well-formed bare pairs produce
`FieldValueSpec { kind: None, value }`.

**Test**: `test_bc_3_4_026_parse_field_kv_returns_field_value_spec_map` in
`src/cli/issue/create.rs`'s inline `#[cfg(test)]` module.

---

### AC-002: Parse rule — first `=` splits `NAME[:kind]` from `VALUE`; last `:` before `=` splits kind
(traces to BC-3.4.026 "Parser contract" steps 1–3)

1. Split each `--field` argument on the FIRST `=` (existing behavior, unchanged) — this splits
   `NAME[:kind]` from `VALUE`.
2. Within `NAME[:kind]`, split on the LAST `:` that appears BEFORE the `=`. Rationale: a field
   NAME may legitimately contain a colon (e.g. `"Region: EMEA"`); a real kind tag is always the
   short, rightmost segment before `=`.
3. If a `:`-delimited segment is found: validate against the CLOSED set `{option, id, name,
   asset}` (case-sensitive, lowercase only — mirrors the `customfield_` bypass's
   case-sensitivity precedent, BC-3.4.015 EC-3.4.015-17). Unknown kind → exit 64 (BC-3.4.031
   EC-1). Known kind → the pair carries `Some(kind)`.
4. No `:`-delimited segment found before `=` → `kind: None` (bare form — UNCHANGED
   BC-3.4.015/016 auto-detect dispatch).

**Test**: `test_bc_3_4_026_first_equals_then_last_colon_split` +
`test_bc_3_4_026_multi_colon_name_isolates_kind_from_last_colon` in
`src/cli/issue/create.rs`'s inline `#[cfg(test)]` module.

---

### AC-003: Multibyte-safety MUST — Unicode-scalar-safe splitting, never byte-index slicing
(traces to BC-3.4.026 "Parser contract" step 5, VP-578-005)

All splitting in steps 1–2 MUST operate on Unicode scalar boundaries (`char_indices`/`.find(char)`
on `&str`, NEVER raw byte-index slicing) — the same class of bug fixed in `jql::validate_duration`
(FIX-F6-LRE-1, #734, commit `37850b26`, multibyte input panicking on a byte-index slice). A field
NAME or VALUE containing multibyte UTF-8 (e.g. a CJK custom field name) MUST NOT panic the
parser; malformed multibyte boundaries in the hint-tag position surface as a normal exit-64 parse
error, never a panic. Realized as `prop_field_hint_split_no_panic` — a property test over
arbitrary Unicode input, added to `.cargo/mutants.toml` `examine_globs` per the F1 delta
analysis §3 recommendation.

**Test**: `prop_field_hint_split_no_panic` (proptest, VP-578-005) in
`src/cli/issue/create.rs`'s inline `#[cfg(test)] mod parse_field_kv_proptests`.

---

### AC-004: Map key is ALWAYS the bare field name — never a composite `"name:kind"` key
(traces to BC-3.4.026 "Rule (ADR-0019 §2(b), normative)", VP-578-006)

This holds regardless of whether the kind tag is present, absent, or varies across repeated
occurrences of the same NAME: `--field cf:option=A --field cf:id=B` produces exactly ONE map
entry keyed `"cf"`, and the second occurrence's WHOLE `FieldValueSpec` (kind AND value)
overwrites the first — kinds are never merged or compared across duplicate NAME occurrences. A
composite-key implementation (keying by `"cf:option"` and `"cf:id"` as two distinct entries)
would let both reach wire serialization and silently double-apply the field with conflicting
kinds — the exact defect ADR-0019's bare-key refinement exists to prevent.

**Test**: `test_bc_3_4_026_last_wins_across_kinds_single_map_entry` (VP-578-006) in
`src/cli/issue/create.rs`'s inline `#[cfg(test)]` module.

---

### AC-005: All three call sites consume the SAME `HashMap<String, FieldValueSpec>` shape
(traces to BC-3.4.026 Postconditions)

`create.rs` platform path (per BC-3.3.010, consumed by S-578-4), `edit.rs` (per BC-3.4.027-030,
consumed by S-578-2), and `jsm_create.rs` (per BC-3.8.008 amendment, consumed by S-578-3) all
consume the identical `parse_field_kv` output shape — no per-call-site parsing divergence. This
story only CHANGES `parse_field_kv`'s signature; it does NOT thread the new type through the
three call sites (that is S-578-2/3/4's own scope) — but it MUST leave the existing call sites
compiling against the new signature is explicitly OUT of this story's scope; see "Forbidden
Dependencies" below for the precise boundary.

**Test**: N/A — structural invariant verified by S-578-2/3/4's own test suites; this story's
own tests assert only `parse_field_kv`'s own contract in isolation.

---

### AC-006: EC-1 — unknown kind → exit 64, lists the four valid kinds
(traces to BC-3.4.031 EC-1, VP-578-013)

`--field cf:bogus=X` → `:` segment present but not in `{option, id, name, asset}` →
`JrError::UserError` exit 64. Message MUST list the four valid kinds. Load-bearing substring:
`"unknown field-value kind"`. No HTTP (this is a pure parse-level failure).

**Test**: `test_bc_3_4_031_ec1_unknown_kind_exits_64` (VP-578-013) in
`src/cli/issue/create.rs`'s inline `#[cfg(test)]` module.

---

### AC-007: EC-5 — empty `:kind` segment treated as EC-1 (unknown kind)
(traces to BC-3.4.031 EC-5, VP-578-013)

`--field cf:=VALUE` — the segment between `:` and `=` is empty string → treated as EC-1 (empty
string is not in the closed set) → exit 64 with the same four-valid-kinds message.

**Test**: `test_bc_3_4_031_ec5_empty_kind_segment_treated_as_unknown_kind` (VP-578-013) in
`src/cli/issue/create.rs`'s inline `#[cfg(test)]` module.

---

### AC-008: EC-6/EC-7 regression pins — colon-in-VALUE resolves normally; multi-colon-NAME still errors
(traces to BC-3.4.031 EC-6/EC-7, VP-578-014)

**EC-6**: `--field cf:option=High:Priority` (a `:` appears in VALUE, after `=`) → NOT
reinterpreted as a nested hint. The split on `=` (step 1) happens BEFORE the `:kind` split (step
2), and step 2 only inspects the pre-`=` portion. `VALUE = "High:Priority"` verbatim, `kind =
option`. Regression pin: this MUST resolve normally (not an error).

**EC-7**: `--field "Region: EMEA:bogus=X"` → step 2 splits on the LAST `:` before `=`, isolating
`bogus` as the candidate kind → unknown kind (EC-1) → exit 64. Regression pin: this MUST fire
the SPECIFIC unknown-kind error, not a different, wrong error.

**Test**: `test_bc_3_4_031_ec6_colon_in_value_resolves_normally` +
`test_bc_3_4_031_ec7_multi_colon_name_fires_unknown_kind_not_other_error` (VP-578-014) in
`src/cli/issue/create.rs`'s inline `#[cfg(test)]` module.

---

### AC-009: EC-8/EC-9 pass-through — empty `:id`/`:name` value is NOT this parser's exit-64 case
(traces to BC-3.4.031 EC-8/EC-9)

`--field cf:id=` and `--field cf:name=` MUST NOT be rejected by `parse_field_kv` — the empty
value is a legal `String` per `FieldValueSpec.value`. `parse_field_kv` performs NO empty-value
rejection for `:id`/`:name` at the parser level; the pair carries `FieldValueSpec { kind:
Some(Id|Name), value: "" }` and is passed through unchanged. (Only `:asset`'s EC-2a is a
`jr`-side exit-64 for empty value, and that check lives at the CALL SITE composer — S-578-2/3/4
— never inside `parse_field_kv` itself; see Invariant note below.)

**Test**: `test_bc_3_4_031_ec8_empty_id_value_passes_through_parser` +
`test_bc_3_4_031_ec9_empty_name_value_passes_through_parser` in
`src/cli/issue/create.rs`'s inline `#[cfg(test)]` module.

---

### AC-010: Kind validation is case-sensitive, lowercase-only
(traces to BC-3.4.026 Invariant 3)

`:Option=` or `:OPTION=` are NOT recognized as the `option` kind — they fall through to the
unknown-kind exit-64 path (BC-3.4.031 EC-1), never silently treated as bare NAME text
containing a colon. Deliberate strictness: typos should fail loud, not silently misroute.

**Test**: `test_bc_3_4_026_kind_validation_case_sensitive_lowercase_only` in
`src/cli/issue/create.rs`'s inline `#[cfg(test)]` module.

---

## Architecture Mapping

| Component | File | Pure/Effectful | Notes |
|-----------|------|-----------------|-------|
| `FieldValueKind` (enum) | `src/cli/issue/create.rs` (MODIFIED) | Pure core (data type) | `{Option, Id, Name, Asset}` |
| `FieldValueSpec` (struct) | `src/cli/issue/create.rs` (MODIFIED) | Pure core (data type) | `{kind: Option<FieldValueKind>, value: String}` |
| `parse_field_kv` | `src/cli/issue/create.rs` (MODIFIED) | Pure core (function) | No I/O; MUST stay pure — see Forbidden Dependencies |
| `parse_field_kv_proptests` (inline `#[cfg(test)]`) | `src/cli/issue/create.rs` (MODIFIED) | Test | Extended with `prop_field_hint_split_no_panic` |

---

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-1 | `--field cf:bogus=X` (unknown kind) | exit 64, lists 4 valid kinds, substring `"unknown field-value kind"` |
| EC-2 (asset shapes) | `:asset` malformed `WORKSPACE:OBJECTID` shapes | OUT OF SCOPE for this story — the `:asset` composer/validator lives at the call site (S-578-2/3/4), not in `parse_field_kv` |
| EC-3 (asset objectId) | `:asset` non-numeric `objectId` | OUT OF SCOPE — call-site concern (S-578-2/3/4) |
| EC-4 | `:id` value that fails no client-side check | Documented non-goal — `:id` performs NO client-side numeric validation, ever (BC-3.4.028 Invariant 1) |
| EC-5 | `--field cf:=VALUE` (empty `:kind` segment) | treated as EC-1, exit 64 |
| EC-6 | `--field cf:option=High:Priority` (colon in VALUE) | resolves NORMALLY — regression pin, NOT an error |
| EC-7 | `--field "Region: EMEA:bogus=X"` (multi-colon NAME) | exit 64 via unknown-kind (EC-1), regression pin against a different/wrong error |
| EC-8 | `--field cf:id=` (empty `:id` value) | PASS-THROUGH, not exit-64 at the parser level |
| EC-9 | `--field cf:name=` (empty `:name` value) | PASS-THROUGH, not exit-64 at the parser level |

---

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|----------------|
| `src/cli/issue/create.rs::{FieldValueKind, FieldValueSpec}` | pure-core (data types) | Plain data carriers, no I/O |
| `src/cli/issue/create.rs::parse_field_kv` | pure-core (function) | No I/O, no cache access, no `get_or_fetch_workspace_id` call — MUST stay pure to remain property-testable |

---

## Token Budget Estimate

| Item | Est. Tokens |
|------|------------|
| Story spec (this file) | ~6 k |
| BC-3.4.026 + BC-3.4.031 (bc-3-issue-write.md relevant sections) | ~5 k |
| ADR-0019 §2 | ~2 k |
| `src/cli/issue/create.rs` (existing `parse_field_kv` + `parse_field_kv_proptests`, ~150 LOC) | ~2 k |
| CLAUDE.md FIX-F6-LRE-1 precedent (`jql::validate_duration`) | ~1 k |
| New/extended test module | ~4 k |
| **Total** | **~20 k** |

Well under 20% of a 200k context window.

---

## Tasks

**Red Gate protocol**: Write all 10 ACs as unit/proptest tests in `src/cli/issue/create.rs`'s
inline `#[cfg(test)]` module first — they MUST fail to compile (no `FieldValueSpec`/
`FieldValueKind` types exist yet, `parse_field_kv` still returns `HashMap<String, String>`).
Then implement the type change and parser extension.

### Task 0 — Read source context

Read:
- `src/cli/issue/create.rs::parse_field_kv` (current implementation, `HashMap<String, String>`
  return type) and its existing `#[cfg(test)] mod parse_field_kv_proptests`
- `src/jql.rs::validate_duration` — the FIX-F6-LRE-1 (#734) precedent for multibyte-safe
  splitting; read the actual fix, not a summary
- BC-3.4.026 and BC-3.4.031 in full (`bc-3-issue-write.md`)
- ADR-0019 §2 in full

### Task 1 — Write tests (Red Gate)

Write all 10 ACs. Confirm compile failure against the pre-existing `HashMap<String, String>`
signature.

### Task 2 — Define `FieldValueKind`/`FieldValueSpec`

```rust
pub(crate) enum FieldValueKind { Option, Id, Name, Asset }
pub(crate) struct FieldValueSpec { pub kind: Option<FieldValueKind>, pub value: String }
```

### Task 3 — Implement the extended `parse_field_kv`

Follow the 5-step parser contract exactly (first `=` split, last `:` before `=` split, closed-set
kind validation, bare-form fallback, Unicode-scalar-safe splitting via `char_indices`/
`str::find(char)` — never byte-index slicing).

### Task 4 — Confirm all tests pass

```bash
cargo test --lib create -- --nocapture
cargo clippy -- -D warnings
```

### Task 5 — PR creation

Create PR to `develop`:
- Title: `feat(issue): --field NAME:kind=VALUE hint-syntax parser (#578 part 1)`
- Reference #578; note this story ONLY changes `parse_field_kv`'s signature — it does NOT
  thread `FieldValueSpec` through `edit.rs`/`jsm_create.rs`/the platform-create path
  (S-578-2/3/4's scope); the existing call sites will need a follow-on compile fix in those
  stories' own PRs (flag this explicitly in the PR description so reviewers understand the
  three call sites are intentionally left uncompiled by this PR alone if delivered standalone —
  coordinate wave-1 delivery so this merges together with, or immediately before, the first
  consumer story).

---

## Previous Story Intelligence

N/A — first story to touch `parse_field_kv`'s hint-syntax extension. Relevant precedent:

- **`src/cli/issue/create.rs::parse_field_kv`** (pre-existing, from S-396/S-383) is the function
  being extended — its current `HashMap<String, String>` signature and last-wins-on-duplicate-key
  semantics are the baseline this story generalizes, not replaces.
- **FIX-F6-LRE-1 (#734, commit `37850b26`)** — `jql::validate_duration`'s multibyte panic fix is
  the exact bug class this story's AC-003 closes at a new split site. Read the actual diff, not
  just the CLAUDE.md summary line, before implementing.

---

## Architecture Compliance Rules

(Extracted from ADR-0019 §2, CLAUDE.md)

1. **`parse_field_kv` MUST stay pure — no HTTP, no cache access, no `get_or_fetch_workspace_id`
   call.** This is a hard forbidden-dependency, not a style preference: workspace-id resolution
   for `:asset` is an L2 (caller) concern per ADR-0019 §2's explicit purity constraint, needed to
   keep `parse_field_kv` property-testable via `parse_field_kv_proptests`.
2. **`FieldValueSpec.value` is deliberately UNINTERPRETED.** `parse_field_kv` does NOT pre-split
   `:option`'s `Parent>Child` cascading syntax or `:asset`'s `WORKSPACE:OBJECTID` compact form —
   those remain call-site concerns (S-578-2/3/4), never folded into this parser.
3. **No byte-index slicing anywhere in the split logic** — `char_indices`/`str::find(char)` only.
4. **The map key is ALWAYS the bare field name.** Never construct or accept a composite
   `"name:kind"` key at any point in the implementation.

---

## Library & Framework Requirements

| Library | Version | Constraint |
|---------|---------|------------|
| proptest | current (workspace, dev-dep) | `prop_field_hint_split_no_panic`, added to `.cargo/mutants.toml` `examine_globs` |
| (no new crate) | N/A | No new third-party dependency |

---

## File Structure Requirements

| File | Action | Notes |
|------|--------|-------|
| `src/cli/issue/create.rs` | MODIFY | `FieldValueKind`/`FieldValueSpec` definitions + extended `parse_field_kv` + extended `#[cfg(test)] mod parse_field_kv_proptests` |

**Files that MUST NOT change:**
- `src/cli/issue/edit.rs`, `src/cli/issue/field_resolve.rs`, `src/cli/issue/jsm_create.rs`,
  `src/api/jsm/requests.rs` — those call sites are threaded to consume `FieldValueSpec` by
  S-578-2/S-578-3/S-578-4, not this story
- `src/cli/field.rs`, `src/api/jira/issues.rs` — S-580-1's scope, no code overlap
- Any `.factory/specs/prd/` BC file
