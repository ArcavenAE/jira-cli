---
document_type: story
level: ops
story_id: "S-CIGATE-3"
epic_id: "none"
title: "Replace tests/ci_gate_completeness.rs's line-based YAML extraction with a real YAML parser"
version: "1.3"
producer: story-writer
timestamp: "2026-08-11T06:15:00Z"
phase: 3
cycle: CIGATE-REAL-YAML-PARSER
inputs:
  - ".github/workflows/ci.yml"
  - "tests/ci_gate_completeness.rs"
  - "tests/common/yaml.rs"
input-hash: "8fcd547"
traces_to: "tests/ci_gate_completeness.rs (residual documented in fix/ci-gate-skipped-false-green commit cf00f2fc); STATE.md Drift Items POSITIONAL-ASSUMPTION-AXIS and RED-PROOF-NEEDS-SPELLING-VARIANTS (both DEFERRED to S-CIGATE-3, window 57/58/59, 2026-08-10)"
wave: feature-followup
status: in-progress
intent: tech-debt
feature_type: ci
mode: feature
scope: small
severity: MEDIUM
trivial_scope: false
points: 8
priority: P2
tdd_mode: strict
estimated_effort: standard
estimated_days: 2
target_module: ci
subsystems: []
depends_on: ["S-CIGATE-2"]
blocks: []
behavioral_contracts: []
bc_anchors: []
bcs: []
# BC status: no product BCs (CI-test-infra refactor; trace ACs to the residual documented in
# S-CIGATE-2's close-out commit `cf00f2fc` and to CLAUDE.md's ci-gate conventions). BC catalog
# untouched. Do NOT add BCs.
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F1-delta-analysis
spec_source: "No pre-existing delta-analysis document. Written from a direct read of
  .github/workflows/ci.yml, tests/ci_gate_completeness.rs (develop HEAD, 8 tests) and the
  in-flight fix/ci-gate-skipped-false-green branch (.worktrees/S-CIGATE-2, 17 tests,
  commit cf00f2fc — read-only, not modified by this story), plus the S-CIGATE-1/S-CIGATE-2
  story files, on 2026-08-06."
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 9
assumption_validations: []
risk_mitigations:
  - "Scoped as an evaluate-then-implement story rather than a pre-committed library choice:
     the brief that originated this story presumed a fix category (real parser) without
     naming a library; this story requires a documented supply-chain evaluation (AC-001)
     before any Cargo.toml change, because MSRV 1.85 + `cargo deny check` compliance are
     both load-bearing CI gates in this repo and `serde_yaml` (the obvious first guess) is
     unmaintained (see AC-001)."
  - "CORRECTION (v1.1, 2026-08-07, class-level correction sweep): `.github/workflows/ci.yml`
     grew from 445 to 675 LOC and `tests/ci_gate_completeness.rs` grew from 750 to 5,214 LOC
     between this story's authoring (2026-08-06) and develop HEAD `3ad496eb` (2026-08-07) —
     S-CIGATE-2/PR #671 merged in the interim, and S-626-1's in-flight rounds also landed
     content on both files. Token Budget Estimate, Story Points and Effort, Purity
     Classification, and Architecture Mapping corrected in place (see those sections for
     detail and derivation). `status: draft` is unchanged and correct — the parser refactor
     itself has not shipped; only the pre-existing file sizes this story measures against
     had drifted."
  - "DECISION (v1.2, 2026-08-10, human-approved this session; spec-only update, no code
     changed): AC-001's evaluate-then-implement scaffolding is now RESOLVED, not open. The
     approved decision is `saphyr-parser` pinned `=0.0.11`, added under `[dev-dependencies]`,
     used ONLY at the EVENT-STREAM level — the crate's higher-level `saphyr::Yaml` API is
     explicitly FORBIDDEN for this story's purpose (see Parser Decision section below for
     why). The decision and every constraint below it were established by execution in an
     isolated scratch worktree this session (`yaml-crate-probe`), not from documentation
     alone — several are non-obvious and would silently change the implementation if
     discovered only at F4 time, so they are recorded here as explicit ACs rather than left
     for the implementer to rediscover. This update also folds in two STATE.md Drift Items
     routed to this story: `POSITIONAL-ASSUMPTION-AXIS` (HIGH, OPEN — window 57/58/59,
     2026-08-10 — `extract_key_name_at_indent`'s hard-coded 4-space job-child indent is
     assumed, never checked; see AC-008) and `EXTRACT-JOB-BLOCK-RAW-ANCHOR-WIDENED` (LOW,
     already CLOSED via an interim line-based patch on `1381af17` before this update landed —
     folded in here only as further evidence for the flat, non-decaying finding-rate argument
     in Problem Statement, not as an open item requiring its own AC; the interim patch is
     superseded, not undone, by this story's structural fix)."
created: "2026-08-06"
last_updated: "2026-08-10"
breaking_change: false
files_modified:
  - tests/ci_gate_completeness.rs   # MODIFY: parse ci.yml once via saphyr-parser's event stream; assert structure over the parsed event data; retain today's byte-for-byte scalar pins as a SECOND assertion layer over parsed values, not a replacement
  - tests/common/yaml.rs            # MODIFY: replace extract_job_block/extract_key_name_at_indent/collect_mapping_key_set and siblings with event-stream-backed equivalents; shared helper module for both this file's callers
  - Cargo.toml                      # MODIFY (dev-dependencies): add `saphyr-parser = "=0.0.11"` (exact pin, not a caret range — see AC-006 for why)
  - Cargo.lock                      # MODIFY: lockfile update — adds exactly 2 crates (saphyr-parser + its sole dependency, arraydeque)
  - deny.toml                       # NOT expected to require a change (probe finding: saphyr-parser 0.0.11 passes all four `cargo deny check` categories — licenses/bans/advisories/sources — as a normal dependency); MODIFY only if a future `cargo deny check` run at implementation time disagrees with this probe result
  - CLAUDE.md                       # MODIFY: document the saphyr-parser event-stream-only decision, the MSRV-1.85-zero-headroom pin rationale, and the "byte pins are a second layer, not the only layer" convention under the existing ci-gate bullet
---

# S-CIGATE-3 — Replace Line-Based YAML Extraction with a Real YAML Parser

## Source of Truth

`.github/workflows/ci.yml` (develop HEAD, 445 lines) and `tests/ci_gate_completeness.rs`
(develop HEAD, 750 lines / 8 test functions, built on `read_ci_yml()` + `parse_needs_set()`
source-text helpers — no YAML library is used today).

The durable-fix direction and its motivating defect were established, not invented here, by
the in-flight `fix/ci-gate-skipped-false-green` branch's close-out commit `cf00f2fc`
("docs(ci-gate): document node-properties residual risk, not fixed (close-out, human
decision)"), read from `.worktrees/S-CIGATE-2` for this story (read-only — that worktree is
frozen pending merge and is NOT touched by this story). That commit's message states
verbatim: *"A follow-up story to replace line-based extraction with a real YAML parser is
tracked separately and is NOT opened by this change."* This story is that follow-up.

**Independently re-verified for this story (2026-08-06), not taken on report:**

- On the frozen branch, `tests/ci_gate_completeness.rs` has grown to 3,887 lines / 17 test
  functions, all built on the same three line-based primitives: `read_ci_yml()`,
  `collect_mapping_key_set()`, and `extract_key_name_at_indent()`. Six independent members of
  the "lexer disagrees with a real YAML parser" defect class were found across three
  consecutive PR #671 review rounds while hardening these primitives (per `cf00f2fc`'s own
  history summary): comment-indentation truncation in `collect_mapping_key_set` (round 13),
  UTF-8 BOM prefix (round 13), YAML explicit-key syntax `? key` (round 13), lone CR (U+000D)
  and three Unicode line breaks — NEL U+0085, LS U+2028, PS U+2029 (round 14), and **key-level
  node properties — `&anchor` / `!tag` / `!!tag` prefixing a mapping key on the same physical
  line (round 16, left open)**. The finding rate across these three rounds is flat, not
  decaying.
- The open member is demonstrable and was independently verified against real YAML parsers
  (PyYAML and Ruby Psych), not merely asserted: inserting `        &x shell: cat {0}` as a
  one-line addition to the `ci-gate` step's mapping is parsed by both loaders as adding a real
  `shell:` key (`["env","name","run","shell"]`, `shell: "cat {0}"` — the same custom-shell-
  template override rounds 11/14 already showed defeats the pinned `run:` line), while
  `extract_key_name_at_indent`'s bare-key branch stops at the space after `&x`, sees no colon,
  returns `None`, and is invisible to every key-set pin built on that function. The frozen
  branch's own commit records a full 17/17 green run of the existing suite with this line
  present.
- **What is NOT established** (per `cf00f2fc`, restated here rather than overclaimed): this
  repo's exact payload has not been executed against a real GitHub Actions runner by anyone —
  only against PyYAML/Ruby Psych locally. GitHub shipped YAML anchor/alias support to
  production Actions on 2025-09-18 (per the official github.blog changelog cited in
  `cf00f2fc`), so the underlying mechanism is confirmed live, not hypothetical — but the
  runner-level reproduction of this specific payload is a separate, unverified claim this
  story does not need to re-derive to justify the fix (a real parser closes the *class* of
  gap, independent of whether this exact payload has been run against a live runner).
- `cf00f2fc`'s own framing of the durable fix, restated precisely because a prior round (11)
  conflated two different proposals: round 11 *correctly* rejected "hand-roll a full
  block-mapping parser" as impractical; it did **not** reject, and this story does not
  re-litigate, the separate and always-viable option of using an **off-the-shelf YAML
  parser** — the same category `actionlint` and GitHub's own runner both use.

**Drift items folded in (2026-08-10, v1.2):**

- `POSITIONAL-ASSUMPTION-AXIS` (HIGH, OPEN, window 57/58/59) — `extract_key_name_at_indent`'s
  hard-coded 4-space job-child indent is assumed, never checked; a legal 6-space (or 3- or
  8-space) sibling job body bypasses every key-set guard built on it while the full suite
  stays green (`ADV-P57-HIGH-001`, live-verified against `ci-gate`'s DEC-246 duplicate-check-
  name guard). This is a SECOND, orthogonal axis of the same "lexer disagrees with a real
  parser" defect class as the node-properties/BOM/Unicode-line-break findings above — spelling
  (round 13/14/16 findings) and indent/position (this finding) vary independently, and a fix or
  RED proof that covers only one axis does not cover the other. A real, tree-structured parser
  (this story's approach) eliminates this axis by construction: a parsed mapping's children are
  identified by tree membership, not by a re-derived indent-column literal, so there is no
  "assumed indent" left to get wrong. See AC-008.
- `EXTRACT-JOB-BLOCK-RAW-ANCHOR-WIDENED` (LOW, CLOSED via an interim line-based patch on
  `1381af17`, prior to this update) — `extract_job_block`'s job-header search previously took
  the first raw substring match anywhere in the file instead of requiring a line-anchored
  match; patched to require the match start at byte 0 or immediately follow `\n`, and to panic
  on multiple line-anchored occurrences instead of silently taking the first. Folded in here
  purely as additional evidence for the flat, non-decaying finding-rate argument in Problem
  Statement below (a fourth independent member of the same defect class, patched member-by-
  member rather than closed structurally) — it is already closed and does not need its own AC.
  This story's `extract_job_block` replacement (AC-003) supersedes the interim patch rather
  than needing to re-verify it.

## Behavioral Contracts

No product BCs are added or modified. BC catalog untouched. This story traces its ACs to the
residual risk documented in `fix/ci-gate-skipped-false-green`'s close-out commit `cf00f2fc`
and to `CLAUDE.md`'s `ci-gate` convention bullet, following the same no-BC convention used by
`S-CIGATE-1` and `S-CIGATE-2` for CI-test-infra-only stories.

## Story Narrative

As a maintainer of `jr`,
I want `tests/ci_gate_completeness.rs`'s structural assertions about `.github/workflows/ci.yml`
to be built on a real YAML parse tree instead of a hand-rolled line-by-line lexer,
so that the "lexer disagrees with a real parser" defect class — which has produced a new,
previously-undiscovered member every round for three consecutive rounds of adversarial review,
each one capable of defeating every existing set-equality pin with a single, syntactically
valid, one-line YAML addition — is closed structurally rather than patched member-by-member.

## Problem Statement

Every one of `tests/ci_gate_completeness.rs`'s test functions is built on `read_ci_yml()` →
`str::lines()` → hand-rolled indent/key extraction (`extract_key_name_at_indent`,
`collect_mapping_key_set`, and siblings on the frozen branch). This is a partial
re-implementation of a YAML lexer that has repeatedly proven narrower than the YAML spec
actual runners implement against. Patching each discovered gap (BOM, explicit-key syntax,
Unicode line breaks, now node properties) treats a structural mismatch — "a string-splitting
approximation of a context-free grammar" — as a series of unrelated bugs. The fix pattern is
the same each time (widen the lexer's character/token acceptance) and the finding rate has
not decayed after three rounds, which is evidence the approximation has an unbounded number of
remaining gaps, not a small finite list.

## Approach

Parse `.github/workflows/ci.yml` **once**, with a real YAML parser, into a structured
document. Assert `ci-gate`/`mutants`/`spec-guard`/other-gated-job structure (job existence,
`needs:` membership, `if:` conditions, step bodies) **over the parsed tree** — key lookups,
not line-position arithmetic. Retain today's byte-for-byte scalar pins (e.g. the exact `run:`
step body text, the exact `if:` expression string) as a **second assertion layer applied to
values read out of the parsed tree**, not as a replacement for structural parsing and not
deleted. This dual-layer design is deliberate: the parse-tree layer closes the lexer-fidelity
gap class (this story's purpose); the byte-pin layer keeps catching semantically-inert
whitespace/formatting drift that a structural-equality check alone would treat as unchanged
(the property that made byte pins valuable in the first place, per round 10's original
rationale).

## Parser Decision (RESOLVED 2026-08-10 — human-approved this session)

**Decision: `saphyr-parser`, pinned `=0.0.11`, added under `[dev-dependencies]`, used ONLY at
the EVENT-STREAM level.** This closes AC-001's evaluate-then-implement scaffolding — the
choice is no longer open at implementation time; the implementer's job is to build against this
decision, not to re-run the evaluation. The decision and every constraint below it were
established by direct execution against a real `saphyr-parser` build in an isolated scratch
worktree this session, not inferred from crate documentation — several would silently change
the shape of the implementation if discovered only during F4, so they are recorded here as
binding constraints (folded into the Acceptance Criteria below), not left implicit.

### Why the high-level API is forbidden

`saphyr::Yaml` — the crate family's obvious, ergonomic, "just give me a document" API — is a
trap for this story's purpose: it **silently normalizes exactly what the guards must see**.
Verified directly: a mapping with a duplicate key (`{if: one, if: two}`) collapses to
last-wins (`if: two`) with no error or signal that a duplicate existed; quoting style
(`plain` / `'single'` / `"double"`) is erased on the way into a `Yaml::String`; and aliases are
silently resolved to their target values rather than left as a distinguishable alias reference.
Building this story's guards on `saphyr::Yaml` would REINTRODUCE, one level higher, the same
"the checker sees less than the runner does" defect class this story exists to close. **Only
the `saphyr-parser` crate's low-level `Parser`/`Event` stream is permitted** — see AC-002.

### What the event stream exposes (verified)

- Duplicate mapping keys arrive as **separate events in document order** — no collapsing, no
  last-wins — so duplicate-key detection is a linear walk counting key-name occurrences within
  a mapping's event range, not a `HashMap` insert that silently overwrites.
- Each scalar event carries `style` (`Plain` / `SingleQuoted` / `DoubleQuoted` — the three
  spellings the existing byte pins and the `RED-PROOF-NEEDS-SPELLING-VARIANTS` drift item care
  about), an unresolved `Alias(n)` variant (never silently substituted), an `anchor_id`, a
  `tag`, and a byte span on every event.
- **Flow-vs-block mapping/sequence style is NOT a direct API flag** — it must be recovered from
  spans: a flow `MappingStart` (`{...}`) has a non-empty span containing the literal `{`
  character; a block mapping's start event has a zero-width span. This is usable but implicit;
  budget implementation effort for it rather than assuming a `style: Flow | Block` accessor
  exists on the event itself (there isn't one).

### Round-16 residual: genuinely closed by this parser

`&x shell: cat {0}` and `!!str shell: cat {0}` — the two round-16 node-property constructions
that defeated every line-based set-equality pin (per Source of Truth above) — both parse under
`saphyr-parser` to a `Scalar("shell", anchor_id=1)` and a `Scalar("shell", tag=Some(Tag{handle:
"tag:yaml.org,2002:", suffix: "str"}))` respectively: **real, visible `shell` keys**, with the
node property exposed as event metadata rather than silently swallowing the key. A guard built
on the event stream can therefore assert the key set correctly AND separately reject any anchor
or tag on a key outright. This is a **third independent parser implementation** (after PyYAML
and Ruby Psych, both cited in Source of Truth) confirming the round-16 residual — S-CIGATE-3
closes it structurally. See AC-007.

### CRITICAL — the round-14 byte scan is RETAINED, not retired

`saphyr-parser` implements **YAML 1.2**: a lone CR (U+000D) genuinely IS a line break under
YAML 1.2, so the round-14 lone-CR case is handled natively by the parser. **NEL (U+0085), LINE
SEPARATOR (U+2028), and PARAGRAPH SEPARATOR (U+2029) are NOT line breaks under YAML 1.2** — the
parser folds them into the surrounding scalar's text and only errors if the resulting construct
is otherwise invalid. This IS fail-closed (a malformed document is rejected), but it is **NOT
equivalent coverage** to the round-14 fix: PyYAML (YAML 1.1) treats all three as line breaks,
so a real, different divergence exists between the two spec versions, not just an
implementation quirk. **Any assumption that "a real parser subsumes the byte scan and it can be
deleted" is WRONG and is explicitly contradicted here** — `test_ci_yml_contains_no_non_lf_yaml_line_breaks`
MUST survive this rewrite as an independent second layer, unconditionally. See AC-005.

### Dependency facts (verified)

- Passes all four `cargo deny check` categories (licenses, bans, advisories, sources) **even
  as an ordinary (non-dev) dependency** — there is headroom if this crate is ever promoted out
  of `tests/` in a future story.
- Adds exactly 2 crates to the dependency tree: itself, plus its sole dependency `arraydeque`.
- License: `MIT OR Apache-2.0`.
- Actively maintained (verified at evaluation time, not assumed).

### Risks and mitigations

- **MSRV is exactly 1.85.0 for `saphyr-parser` 0.0.11 — zero headroom** against this repo's
  pinned MSRV 1.85 (`rust-toolchain.toml`, the required `msrv` CI job). Mitigation: pin the
  EXACT version `=0.0.11` (not a caret range) in `Cargo.toml`, so a transitive patch bump cannot
  silently raise the floor out from under CI; treat any future version bump as a reviewed
  change, not an automatic `cargo update`. Note for context (not required for this story): a
  separate `status: draft` story, `S-640-1`, already plans to raise the repo's declared MSRV
  floor from 1.85 to 1.88, which — if it ships first — removes this zero-headroom risk
  entirely; this story does not depend on `S-640-1` and must work correctly under the MSRV
  1.85 floor as it stands today.
- **`0.0.x` version — no semver guarantee** from the crate's own versioning scheme (a `0.0.x`
  bump can be breaking by convention). Same mitigation as above: the exact `=0.0.11` pin.
- **Pre-vetted fallback, recorded for the record (not the chosen path):** `yaml-rust2` 0.11.0 —
  exposes an identical low-level event API, so migration would be mechanical if `saphyr-parser`
  became untenable; MSRV 1.65 (much more headroom); passes `cargo deny check`; but is
  maintenance-only per its own maintainers' stated policy. Not selected because `saphyr-parser`
  is actively maintained and its MSRV, while tighter, still meets this repo's current floor.

### Two corrections to prior beliefs (recorded so they are not re-derived wrongly)

- `deny.toml` carries **~40** `bans.skip` entries at present, not five as previously assumed in
  informal discussion — relevant context for AC-006's "no `deny.toml` change expected" claim:
  this is not a file with a small, easily-perturbed allowlist.
- The `rand` exemption's prior stated rationale — "never enters the actual build" — was
  imprecise. The real mechanism is cargo-deny's `bans.multiple-versions-include-dev` option
  defaulting to `false`, not an intrinsic property of `rand` itself.

## Previous Story Intelligence (MANDATORY)

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|--------------|---------------------|-------------------|
| `S-CIGATE-1` | Introduced the `ci-gate` aggregator job; used source-text grep testing of `ci.yml` (no YAML parser dependency) as the original, pragmatic choice for a ~20-line job. | `extract_job_block()`-style helper anchoring assertions to one job's slice, to avoid cross-job false matches — established the pattern this story's assertions must migrate off of. | A source-text-grep approach that was adequate for a single, small, newly-added job did not scale as the file grew and came under adversarial review — the same lesson `S-CIGATE-2` records independently. |
| `S-CIGATE-2` | Kept `ci-gate.needs` as the single source of truth and moved the pass/fail *decision* logic into an extracted, self-tested shell script (`scripts/check-ci-gate.sh`) rather than inline YAML — a "decision logic in scripts/, source-text pins in tests/" split. | 20+ PR #671 review rounds hardened `tests/ci_gate_completeness.rs`'s line-based extraction helpers one member at a time (BOM, explicit-key syntax, Unicode line breaks, comment-indentation truncation) — each round found a NEW member of the same defect class, not a one-off bug. | The line-based approximation of a YAML lexer has an apparently unbounded number of remaining gaps (round 16's node-properties finding was the third consecutive round to find a new member, at a flat, non-decaying rate) — the close-out commit `cf00f2fc` explicitly named "parse once with a real YAML parser" as the durable fix and deferred it to this story rather than attempting a fourth patch-in-place round. |

_Populated from a direct read of `S-CIGATE-1`, `S-CIGATE-2`, and the frozen
`fix/ci-gate-skipped-false-green` branch's commit history (`cf00f2fc` specifically) — the two
prior stories to touch this exact file, plus the branch that discovered and documented this
story's motivating defect._

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Parse once, assert many times | This story | `ci.yml` is parsed via the `saphyr-parser` event stream exactly once per test-binary run (or once per test, if per-test isolation is preferred for failure-message clarity) — not re-parsed line-by-line per assertion. |
| Event stream only — `saphyr::Yaml` forbidden | Parser Decision (RESOLVED 2026-08-10) | No code added by this story constructs a `saphyr::Yaml`/`YamlLoader` document; only `saphyr_parser::Parser`/`Event` are used. The high-level API silently collapses duplicate keys, erases quote style, and resolves aliases — exactly the signal AC-007/AC-008's guards need to see. See AC-002. |
| Byte pins are a second layer, not deleted | Brief instruction; `cf00f2fc` rationale | Every existing byte-for-byte scalar pin (`run:` step bodies, `if:` expression strings) is retained and re-anchored to read its input from an `Event::Scalar`'s text, not from a fresh substring/line search. |
| Non-LF line-break byte scan is a third layer, not subsumed | Parser Decision (RESOLVED 2026-08-10); round 14 | `test_ci_yml_contains_no_non_lf_yaml_line_breaks` is retained unconditionally — `saphyr-parser` (YAML 1.2) does not treat NEL/LS/PS as line breaks, so the parser does not close that part of the round-14 gap. See AC-005. |
| MSRV 1.85.0 compliance, zero headroom | `CLAUDE.md` Build & Test; `Cargo.toml::rust-version` | `saphyr-parser` 0.0.11's own MSRV is exactly 1.85.0 — any new crate dependency (test-scoped or otherwise) MUST compile under the pinned 1.85 toolchain (`rust-toolchain.toml`); verified by the existing `msrv` CI job, not a new one. Pinned via `=0.0.11` exact-version syntax. |
| `cargo deny check` compliance | `CLAUDE.md` Build & Test | Any new crate dependency MUST pass `cargo deny check` (license + vulnerability audit) with zero new advisories/license violations, or ships with an explicit, justified `deny.toml` allow/skip entry. Probe finding: `saphyr-parser` 0.0.11 passes as-is, no `deny.toml` change expected. |
| No change to `ci-gate`'s runtime evaluator | Scope boundary (this story vs. S-CIGATE-2) | `scripts/check-ci-gate.sh` (S-CIGATE-2/PR #671) evaluates `toJSON(needs)` at CI **runtime** — it does not parse `ci.yml` itself and is unaffected by this story. This story is scoped entirely to the **static test-time** assertions in `tests/ci_gate_completeness.rs`. |

## Library & Framework Requirements (MANDATORY)

**RESOLVED 2026-08-10, human-approved this session — see the Parser Decision section above for
full rationale and probe findings.** AC-001's original evaluate-then-implement framing is
retained below only as a record of the candidates considered and why each was accepted or
rejected; the implementer does not re-run this evaluation.

| Candidate | Disposition |
|-----------|-------------|
| `serde_yaml` | REJECTED. Officially unmaintained (author archived the repo). |
| **`saphyr-parser` (event-stream API only) `=0.0.11`** | **CHOSEN.** MSRV 1.85.0 exactly (zero headroom, mitigated by the exact-version pin — see Parser Decision § Risks); passes `cargo deny check` as an ordinary dependency; MIT OR Apache-2.0; adds only 2 crates (itself + `arraydeque`); actively maintained; event stream exposes duplicate keys, quote style, unresolved aliases, anchor/tag metadata, and byte spans — exactly the access pattern this story's guards need. The crate's higher-level `saphyr::Yaml` API is a SEPARATE, FORBIDDEN option (see Parser Decision § "Why the high-level API is forbidden") — it silently collapses duplicate keys, erases quote style, and resolves aliases, defeating the guards it would be used to build. |
| `yaml-rust2` `0.11.0` | REJECTED as primary, RECORDED as pre-vetted fallback. Identical low-level event API to `saphyr-parser` (mechanical migration if ever needed); MSRV 1.65 (far more headroom); passes `cargo deny check`; maintenance-only per its own maintainers' stated policy — not chosen while `saphyr-parser` remains actively maintained. |
| Shell out to PyYAML (or Ruby Psych) | REJECTED. Precedent exists in this repo (`scripts/check-signing-workflow-injection.sh`, `scripts/check-ci-gate.sh` are both already shelled-out-to from CI), but a Rust dev-dependency keeps `tests/ci_gate_completeness.rs` hermetic (no `python3`/PyYAML availability assumption on `ubuntu-latest`/`windows-latest`, no new supply-chain surface, no deviation from this repo's "hermetic, no network, no external process" `tests/` convention) at negligible MSRV/deny cost. |

The decision and its rationale (including the rejected alternatives and why) are recorded in
this story's Parser Decision section above; a follow-up ADR is optional (implementer's
judgment, per `ADR-0001`–`ADR-0003`'s precedent) but not required — the rationale is already
durably recorded here.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|--------------|
| `tests/ci_gate_completeness.rs` | MODIFY | Replace `read_ci_yml()`'s line-based consumers with a single `saphyr-parser` event-stream parse; rewrite structural assertions (job existence, `needs:` set membership, `if:` presence, duplicate-key detection) to query the parsed event data; retain byte-for-byte scalar pins as a second layer over event `Scalar` values. |
| `tests/common/yaml.rs` | MODIFY | Replace `extract_job_block`/`extract_key_name_at_indent`/`collect_mapping_key_set` and siblings with event-stream-backed equivalents (job-block lookup by tree membership, not line-anchored substring search; key-set collection by walking mapping-scoped events, not indent-column arithmetic). |
| `Cargo.toml` | MODIFY | Add `saphyr-parser = "=0.0.11"` under `[dev-dependencies]` — exact pin, not a caret range (see Parser Decision § Risks: MSRV 1.85.0 zero headroom + `0.0.x` no-semver-guarantee). |
| `Cargo.lock` | MODIFY | Lockfile update — adds exactly 2 crates (`saphyr-parser` + `arraydeque`). |
| `deny.toml` | NOT expected (conditional only) | Probe finding: `saphyr-parser` 0.0.11 passes all four `cargo deny check` categories as an ordinary dependency. MODIFY only if a fresh `cargo deny check` run at implementation time disagrees with this probe result. |
| `CLAUDE.md` | MODIFY | Extend the existing `ci-gate` Conventions bullet (or add a sibling bullet) documenting: `tests/ci_gate_completeness.rs` asserts over a real `saphyr-parser` event stream (never the crate's high-level `saphyr::Yaml` API), with byte-for-byte scalar pins as a second, non-exclusive layer, and the round-14 non-LF-line-break byte scan retained as an independent third layer (YAML-1.2 NEL/LS/PS gap) — so a future contributor extending this file does not reintroduce line-based extraction or assume the parser alone covers everything the byte scans cover. |

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|-----------------|----------------|
| Event-stream structural assertions | `tests/ci_gate_completeness.rs`, `tests/common/yaml.rs` | pure-core | Reads `ci.yml` as bytes, parses via `saphyr-parser`'s `Parser`/`Event` stream (in-process, no I/O beyond the one already-open file), and asserts on the resulting event data only — no network, no filesystem writes, no `cargo mutants` invocation |
| Byte-for-byte scalar pins (second layer) | `tests/ci_gate_completeness.rs` | pure-core | Asserts exact string equality on scalar values read out of `Event::Scalar` — hermetic and deterministic given a fixed `ci.yml` |
| Non-LF YAML line-break byte scan (retained third layer, round 14) | `tests/ci_gate_completeness.rs` | pure-core | `test_ci_yml_contains_no_non_lf_yaml_line_breaks` — a raw byte scan independent of the parser, because `saphyr-parser` (YAML 1.2) does not treat NEL/LS/PS as line breaks the way PyYAML (YAML 1.1) does; see Parser Decision § "the round-14 byte scan is RETAINED" |
| `ci-gate` / `mutants` / `spec-guard` job definitions | `.github/workflows/ci.yml` | effectful-shell (CI config, not Rust) | Unmodified by this story — this story only changes how the job definitions are *asserted against* in tests, not the definitions themselves |
| `run_check_ci_gate_sh` shell-out helper (pre-existing, added FIX correction 2026-08-07 — previously undeclared here) | `tests/ci_gate_completeness.rs` | effectful (process spawn + pipe I/O) | Added by S-CIGATE-2 / PR #671 (merged 2026-08-07), NOT by this story. Spawns `bash scripts/check-ci-gate.sh` via `std::process::Command`, `#[cfg(unix)]`-gated, called by three tests. This story does not add, remove, or modify it, but its presence means `tests/ci_gate_completeness.rs` as a whole is not uniformly pure-core at head — see the Purity Classification row's correction below |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|----------------|
| `tests/ci_gate_completeness.rs` | mixed (corrected from "pure-core", 2026-08-07 — see Justification) | The file is NOT already fully hermetic at head. `run_check_ci_gate_sh` (`#[cfg(unix)]`, added by S-CIGATE-2 / PR #671, merged 2026-08-07) spawns a `bash` subprocess via `std::process::Command::new("bash")` to invoke `scripts/check-ci-gate.sh`, and three `#[cfg(unix)]`-gated tests call it; `run_check_ci_gate_sh` is not hermetic-pure by any definition — it does process spawn plus stdin/stdout/stderr I/O. This story's OWN additions (the event-stream structural assertions and scalar pins over `ci.yml`) remain pure-core as described — reads `ci.yml` as a string/bytes and asserts on parsed event data and scalar values only, no network calls, no script execution, no filesystem writes beyond reading the one tracked file — but the file as a whole is mixed, not uniformly hermetic, and this story does not change that (it neither adds nor removes the `run_check_ci_gate_sh` shell-out) |
| `saphyr-parser` (chosen YAML-parsing dependency, RESOLVED) | pure-core | A crate-based, in-process `Parser`/`Event` iterator — no I/O beyond reading the already-open file. The previously-open shell-out alternative (invoking `python3`/PyYAML as a subprocess) was rejected partly on this basis — see Library & Framework Requirements. |

## Token Budget Estimate (MANDATORY)

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~4,500 |
| `.github/workflows/ci.yml` (corrected 2026-08-07: 445 LOC → 675 LOC at develop HEAD `3ad496eb` — S-CIGATE-2/PR #671 and S-626-1's in-flight rounds both landed content since the 445 figure was recorded; re-verified via `wc -l`) | ~7,300 |
| `tests/ci_gate_completeness.rs` (corrected 2026-08-07: the "develop HEAD, 750 LOC; up to ~3,900 LOC on the not-yet-merged `S-CIGATE-2` branch" framing is stale on two counts — S-CIGATE-2 merged as PR #671 on 2026-08-07, and the file is 5,214 LOC at develop HEAD `3ad496eb`, beyond the previously-anticipated ~3,900 LOC upper bound; re-verified via `wc -l`) | ~60,000 |
| `S-CIGATE-1` / `S-CIGATE-2` story files (cross-reference for Previous Story Intelligence) | ~5,000 |
| Candidate YAML crate docs (`saphyr` / `yaml-rust2`) research overhead | ~2,000 |
| **Total** | **~78,800 (corrected 2026-08-07, up from ~25,300–61,300)** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~39% (corrected 2026-08-07, up from ~13–31%)** |

**Corrected 2026-08-07:** `tests/ci_gate_completeness.rs` at develop HEAD `3ad496eb` is 5,214
LOC — already beyond the 3,900 LOC figure this section previously flagged as a ceiling to
watch for. At ~39% of the 200K Sonnet context window, this story is now ABOVE the 20–30%
target ceiling this template enforces, not merely "approaching" it. The implementer MUST
re-check actual file size at dispatch time (it may have grown further) and split the rewrite
(e.g. one pass per job-block's assertions) rather than attempting it as a single pass — this
is no longer a conditional recommendation for the upper end of a range, it is the expected
path given the file's current size.

## Acceptance Criteria

### AC-001 — Parser decision is RESOLVED and implemented as decided (no re-evaluation)

`Cargo.toml` adds exactly `saphyr-parser = "=0.0.11"` under `[dev-dependencies]` (exact-version
pin, not a caret range). The implementer does not re-run the evaluate-then-implement process —
the decision, its rationale, and its rejected alternatives (`serde_yaml`, `yaml-rust2`, PyYAML
shell-out) are already recorded in this story's Parser Decision and Library & Framework
Requirements sections. If, at implementation time, a fact this decision relied on has changed
(e.g. `saphyr-parser` 0.0.11 no longer builds under MSRV 1.85, or a new `cargo deny check`
finding appears), the implementer documents the discrepancy in this story's own history rather
than silently substituting a different crate.

### AC-002 — Only the `saphyr-parser` event-stream API is used; the high-level `saphyr::Yaml` API is forbidden

No code added by this story constructs a `saphyr::Yaml` document (or equivalent high-level
tree type from any other crate). All parsing goes through `saphyr_parser::Parser` and its
`Event` stream directly. This is a hard constraint, not a style preference: per Parser
Decision § "Why the high-level API is forbidden," the high-level API silently collapses
duplicate mapping keys (last-wins, no error), erases scalar quoting style, and resolves
aliases — each of which is exactly the signal AC-007's and AC-008's guards depend on being able
to see. A code-review-time grep for `saphyr::Yaml` (or `saphyr::YamlLoader`) resolving to zero
matches in `tests/ci_gate_completeness.rs` and `tests/common/yaml.rs` is an acceptable
verification method.

### AC-003 — `ci.yml` is parsed once via the event stream; job/needs/if: structure is asserted over parsed event data

`tests/ci_gate_completeness.rs` (via `tests/common/yaml.rs`) parses `.github/workflows/ci.yml`
through `saphyr-parser`'s event stream exactly once (per test-binary run or per test —
implementer's choice), and its structural assertions (job existence, `needs:` set membership
and exact-set checks, job-level and step-level `if:` presence/content, duplicate-key presence)
query the parsed event data by key/path lookup rather than by line-position or indent-column
arithmetic. `extract_job_block`'s replacement locates a job by walking mapping-scoped events,
not by line-anchored substring search — eliminating the indent/position assumption described in
`POSITIONAL-ASSUMPTION-AXIS` by construction (there is no indent literal left to hard-code).

### AC-004 — Byte-for-byte scalar pins are retained as a second assertion layer, not deleted or replaced

Every existing byte-for-byte pin on a scalar value (e.g. the `ci-gate` gate step's exact
`run:` body, exact `if:` expression strings) continues to assert the exact expected string, now
sourced from an `Event::Scalar`'s text (and, where quoting style matters, its `style` field)
rather than a raw substring search. No byte pin is deleted, weakened to a substring/contains
check, or replaced by structural-equality-only coverage.

### AC-005 — The round-14 non-LF-line-break byte scan is RETAINED as an independent third layer, not subsumed by the parser

`test_ci_yml_contains_no_non_lf_yaml_line_breaks` (or its direct successor) remains in the
suite, unconditionally, after this rewrite. Per Parser Decision § "the round-14 byte scan is
RETAINED, not retired": `saphyr-parser` is YAML 1.2, under which NEL (U+0085), LINE SEPARATOR
(U+2028), and PARAGRAPH SEPARATOR (U+2029) are NOT line breaks (unlike YAML 1.1 / PyYAML), so
the parser alone does not close the round-14 gap for those three characters — only the lone-CR
case is natively subsumed. This AC exists specifically to prevent a well-intentioned but
incorrect simplification during the rewrite ("we have a real parser now, we can delete the
byte scan").

### AC-006 — The new dependency passes `cargo deny check` and compiles under MSRV 1.85.0 with zero headroom acknowledged

`cargo deny check` exits 0 with `saphyr-parser = "=0.0.11"` present (per the probe finding, no
`deny.toml` change is expected — see File Structure Requirements), and `cargo build`/`cargo
test` succeed under the pinned 1.85 toolchain (verified via the existing `msrv` CI job — no new
CI job is required). The `Cargo.toml` entry uses the exact-version pin `"=0.0.11"`, not a caret
range — a caret range is a failing implementation of this AC even if it happens to resolve to
0.0.11 today, because MSRV 1.85.0 is `saphyr-parser` 0.0.11's exact floor with zero headroom
(Parser Decision § Risks) and an unreviewed transitive bump could silently break the `msrv` CI
job on an unrelated PR.

### AC-007 — The round-16 node-properties defeat case from `cf00f2fc` is caught, via event-level anchor/tag exposure

Inserting a key-level node property (`&x` or `!!str`) immediately before a mapping key inside
the `ci-gate` gate step's body (the exact reproduction case from `cf00f2fc`: `&x shell: cat
{0}`, and separately `!!str shell: cat {0}`) causes at least one of the rewritten assertions to
fail for BOTH forms — because `saphyr-parser`'s event stream correctly resolves the resulting
document to include a `Scalar("shell", anchor_id=…)` / `Scalar("shell", tag=…)` event where the
pinned expected key set does not include `shell`, and the event-based key-set assertion (AC-003)
detects the mismatch that the old line-based `extract_key_name_at_indent` could not see. This is
proven as a RED-then-fixed cycle for each of the two forms: the malicious line is inserted
against a temporary/local copy of `ci.yml` (not the tracked file) and confirmed to fail the new
assertions before this AC is marked satisfied; the tracked `ci.yml` itself is never modified to
include either malicious line.

### AC-008 — Two-axis RED proof: every rewritten guard is proven RED across key spelling AND indent/position variants

For every guard rewritten under AC-003/AC-004/AC-007, a RED proof is produced covering BOTH:
(a) the **spelling axis** — the guard's target key expressed as `key:`, `"key":`, `'key':`, and
`key :` (space before colon), per the `RED-PROOF-NEEDS-SPELLING-VARIANTS` drift item (now
confirmed two-axis, window 57/58/59); and (b) the **indent/position axis** — the same guard
re-checked against job bodies indented at 3, 6, and 8 spaces (not only the file's native
4-space convention), per the `POSITIONAL-ASSUMPTION-AXIS` drift item. A guard that is RED-proven
on only one axis does not satisfy this AC. Note that AC-003's event-stream approach is expected
to close the indent axis *by construction* (tree membership, not indent arithmetic) — this AC's
indent-axis proof is the confirmation that the construction-level claim actually holds for every
rewritten guard, not an assumption taken on faith.

### AC-009 — No regression: full existing suite passes against the current, legitimate `ci.yml`

`cargo test --test ci_gate_completeness` exits 0 against the tracked (non-malicious)
`.github/workflows/ci.yml`, with every pre-existing test function still present (none silently
deleted, renamed without a documented reason, or weakened to make the rewrite pass), and
`cargo test` (full suite) shows no regression elsewhere. `cargo clippy -- -D warnings` and
`cargo fmt --all -- --check` are both clean.

## Out of Scope (explicit)

- **Any change to `scripts/check-ci-gate.sh`'s runtime `toJSON(needs)` evaluation logic** — that
  script does not parse `ci.yml` and is unaffected by this story (S-CIGATE-2/PR #671 scope).
- **Executing the node-properties payload against a real GitHub Actions runner** — per
  `cf00f2fc`, this remains unverified end-to-end; this story closes the *test-suite-side*
  detection gap, not a live-runner reproduction. Not required for this story's ACs.
- **A general-purpose YAML linter/schema-validator for `ci.yml`** (e.g. wiring up
  `actionlint` in CI) — a related but distinct idea; not opened by this story, no pointer
  added since it is not identified as a residual risk anywhere in the source material.
- **Migrating any other test file's source-text-grep pattern** (e.g. `tests/ci_yml_windows_matrix.rs`,
  if it uses a similar approach) to a real parser — scoped to `tests/ci_gate_completeness.rs`
  only, since that is the file with the demonstrated, repeatedly-recurring defect class.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|--------------------|
| EC-001 | Merge-key (`<<:`) YAML syntax, a related but distinct anchor/alias feature | Per `cf00f2fc`'s research, GitHub has NOT shipped merge-key support in Actions (github/community discussion #185877 is an open follow-on request) — anchors/tags are the confirmed-live mechanism, merge keys are not. A real parser (AC-003) will correctly resolve merge keys if GitHub ever ships them, without further code change, since the fix is structural rather than per-syntax. Not a required test case for this story; noted for completeness. |
| EC-002 | `saphyr-parser` rejects or warns on a construct `actionlint` accepts (or vice versa) | Not expected to be reachable for this repo's own `ci.yml` (which is not adversarially authored), but if implementation discovers a real divergence, document it in this story's own history rather than silently picking whichever tool is more permissive. |
| EC-003 | Future `ci.yml` edits (by unrelated PRs) land on `develop` between this story's authoring and its dispatch, changing job names/needs lists | The rewritten assertions must be re-derived against `ci.yml` as it exists AT IMPLEMENTATION TIME, not against the job list quoted in this story's Source of Truth section (which is a snapshot, not a live reference) — mirrors the "re-derive current test function names/count from the tree at merge time" convention already established in `S-CIGATE-2`'s AC-006 coordination note. |
| EC-004 | Flow-style mapping/sequence (`{...}`/`[...]`) appears anywhere in `ci.yml` and a guard needs to distinguish it from block style | Per Parser Decision § "what the event stream exposes": there is no direct `style: Flow \| Block` field on a `MappingStart`/`SequenceStart` event — flow style must be recovered from the event's byte span (non-zero-width, containing the literal `{`/`[`) versus a block start's zero-width span. Budget implementation effort for this; do not assume an accessor exists. |
| EC-005 | A mapping in `ci.yml` legitimately contains no duplicate keys (the common case) | Duplicate-key detection (AC-003) must not false-positive on any of `ci.yml`'s existing, legitimate mappings — verified as part of AC-009's full-suite regression run against the tracked file, not as a separate malicious-fixture test. |

## Test Coverage Summary

| # | Assertion | File | AC |
|---|-----------|------|-----|
| 1 | `Cargo.toml` pins `saphyr-parser = "=0.0.11"` exactly (not a caret range) | `Cargo.toml` | AC-001 |
| 2 | Code-review-time grep for `saphyr::Yaml`/`saphyr::YamlLoader` resolves to zero matches in the rewritten files | `tests/ci_gate_completeness.rs`, `tests/common/yaml.rs` | AC-002 |
| 3 | `ci.yml` parses successfully via the `saphyr-parser` event stream exactly once; job existence / `needs:` set membership assertions query parsed event data, not line position | `tests/ci_gate_completeness.rs`, `tests/common/yaml.rs` | AC-003 |
| 4 | Every pre-existing byte-for-byte scalar pin still asserts its exact string, now sourced from `Event::Scalar` | `tests/ci_gate_completeness.rs` | AC-004 |
| 5 | `test_ci_yml_contains_no_non_lf_yaml_line_breaks` (or direct successor) still present and passing, independent of the parser rewrite | `tests/ci_gate_completeness.rs` | AC-005 |
| 6 | `cargo deny check` exits 0 with `saphyr-parser = "=0.0.11"` present; `cargo build`/`cargo test` succeed under MSRV 1.85 | CI (`deny`, `msrv` jobs) | AC-006 |
| 7 | Node-properties payloads (`&x shell: cat {0}` AND `!!str shell: cat {0}`) against a local/temporary `ci.yml` copy each fail at least one rewritten assertion; proven RED-then-fixed for both forms | `tests/ci_gate_completeness.rs` (test-local fixture, not the tracked file) | AC-007 |
| 8 | For every rewritten guard: RED proof across 4 spelling variants (`key:`/`"key":`/`'key':`/`key :`) AND 3 indent variants (3/6/8-space job bodies) | `tests/ci_gate_completeness.rs` (test-local fixtures) | AC-008 |
| 9 | `cargo test --test ci_gate_completeness` exits 0 against the tracked `ci.yml`; no test functions silently removed; `cargo clippy`/`cargo fmt` clean | `tests/ci_gate_completeness.rs` | AC-009 |

## Dependency Analysis

**depends_on: ["S-CIGATE-2"]** — `tests/ci_gate_completeness.rs` is the exact file
`S-CIGATE-2`'s in-flight `fix/ci-gate-skipped-false-green` branch has already grown from 8
tests (develop HEAD) to 17 tests (frozen worktree), rewriting/adding the very primitives
(`collect_mapping_key_set`, `extract_key_name_at_indent`) this story targets for replacement.
Dispatching this story's F4 implementation BEFORE `S-CIGATE-2` merges would mean building the
new parser-based assertions against a version of the file that is about to be superseded
wholesale by that merge, guaranteeing a large, wasted merge conflict. **This story MUST NOT be
dispatched until `S-CIGATE-2`'s PR #671 merges to `develop`.**

**blocks: []** — no story depends on this one.

## Tasks

1. Re-read `tests/ci_gate_completeness.rs`, `tests/common/yaml.rs`, and
   `.github/workflows/ci.yml` as they exist on `develop` HEAD AT IMPLEMENTATION TIME
   (post-`S-CIGATE-2` merge) — do not assume this story's snapshot is still current on test
   count, LOC, or job list.
2. Add `saphyr-parser = "=0.0.11"` to `Cargo.toml` `[dev-dependencies]` (AC-001); run `cargo
   deny check` and the `msrv`-pinned build to confirm AC-006 before writing the rewrite. The
   evaluation itself is NOT re-run — the decision is already RESOLVED (Parser Decision
   section) — this task is implementation of that decision, not a fresh comparison.
3. Rewrite `tests/common/yaml.rs`'s `extract_job_block`/`extract_key_name_at_indent`/
   `collect_mapping_key_set` and siblings to walk `saphyr-parser`'s `Event` stream instead of
   `str::lines()` — job-block lookup by tree membership, key-set collection by walking
   mapping-scoped events, duplicate-key detection by counting key-name occurrences within a
   mapping's event range (AC-003). Confirm no code path constructs `saphyr::Yaml` (AC-002).
4. Rewrite `tests/ci_gate_completeness.rs`'s structural assertions to consume the new
   event-based helpers, retaining every existing byte-for-byte scalar pin as a second layer
   sourced from `Event::Scalar` (AC-004).
5. Confirm `test_ci_yml_contains_no_non_lf_yaml_line_breaks` (or its direct successor) is
   still present and unconditionally run after the rewrite — do NOT delete it on the
   assumption the parser now covers it (AC-005; it does not, for NEL/LS/PS — see Parser
   Decision).
6. Prove AC-007: against a local/temporary copy of `ci.yml` (not the tracked file), insert
   `&x shell: cat {0}` and separately `!!str shell: cat {0}` into the `ci-gate` step and
   confirm at least one rewritten assertion fails for each; record both as RED proofs.
7. Prove AC-008 for every rewritten guard: RED-proof each of the 4 key-spelling variants
   (`key:`/`"key":`/`'key':`/`key :`) crossed with each of the 3 job-body indent variants
   (3/6/8-space), against local/temporary `ci.yml` copies.
8. Run `cargo test --test ci_gate_completeness` against the tracked `ci.yml` — confirm AC-009
   (all tests green, none silently removed).
9. Run `cargo test` (full suite), `cargo clippy -- -D warnings`, `cargo fmt --all -- --check`
   — confirm no regressions.
10. Update `CLAUDE.md`'s `ci-gate` convention bullet documenting the event-stream + byte-pin +
    non-LF-line-break dual/triple-layer approach and the "no `saphyr::Yaml` high-level API"
    constraint.
11. Run `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` — both must
    exit 0 (no BCs touched, so this should be a no-op).

## Story Points and Effort

**8 story points** (standard, unchanged by the v1.2 decision update — the decision resolves
AC-001's open-ended evaluation risk but adds the two-axis RED-proof obligation in its place,
roughly offsetting). Breakdown:
- Dependency add + `cargo deny check`/MSRV confirmation (AC-001, AC-006) — now a bounded
  implementation step, not an open evaluation: 1 SP
- F4 TDD (event-stream rewrite of assertions in both `tests/ci_gate_completeness.rs` and
  `tests/common/yaml.rs` — file sizes must be re-verified at dispatch time per the Token
  Budget Estimate section; dual/triple-layer retention, RED-proof cycles for AC-007 and the
  two-axis AC-008): 5 SP
- F5/F7 review + CI verification: 2 SP

Risk: MEDIUM — this lands in the same heavily-adversarially-reviewed file
(`tests/ci_gate_completeness.rs`) that `S-CIGATE-2`'s 20+ PR #671 review rounds already
hardened; a rewrite that accidentally narrows coverage during the event-stream migration would
be a regression in the single most scrutinized test file in this repo. Mitigated by AC-004's
explicit "retain every existing pin" requirement, AC-005's explicit "byte scan is not
subsumed" requirement, and AC-009's full-suite regression check.
