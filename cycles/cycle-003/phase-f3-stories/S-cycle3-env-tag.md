---
document_type: story
story_id: "S-cycle3-env-tag"
epic_id: "AUTH-PROFILE-DX-1"
title: "Add ProfileConfig.env tag + surface in auth list/auth status (DEC-314/DEC-324)"
wave: feature-followup
status: draft
intent: feature
feature_type: feature
mode: feature
scope: standard
severity: MEDIUM
trivial_scope: false
points: 5
priority: P1
tdd_mode: strict
producer: story-writer
timestamp: "2026-09-01T00:00:00"
phase: 3
inputs:
  - ".factory/specs/prd/bc-1-auth-identity.md"
  - ".factory/specs/prd/bc-6-config-cache.md"
  - ".factory/specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md"
  - ".factory/cycles/cycle-003/phase-f3-stories/decomposition-manifest.md"
input-hash: "49f3e00"
traces_to: ".factory/specs/prd/bc-1-auth-identity.md; .factory/specs/prd/bc-6-config-cache.md"
cycle: cycle-003-auth-profile-dx
estimated_effort: small
estimated_days: 1.5
target_module: src/config.rs
subsystems: []
depends_on: []
blocks: []
behavioral_contracts:
  - "BC-6.1.015"
  - "BC-1.6.046"
  - "BC-1.6.047"
bcs:
  - "BC-6.1.015"
  - "BC-1.6.046"
  - "BC-1.6.047"
verification_properties:
  - "VP-AUTHDX-009"
holdout_anchors: []
nfr_anchors: ["NFR-SCA-2"]
adr_refs: ["ADR-0020"]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-003/phase-f3-stories/decomposition-manifest.md"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 8
assumption_validations: []
risk_mitigations: []
created: "2026-09-01"
version: "1.0"
last_updated: "2026-09-01"
breaking_change: true
retroactive: false
origin: >
  cycle-003 auth-profile-dx, Wave 1 (no deps, file-disjoint from S-cycle3-percred-storage).
  Adds ProfileConfig.env: Option<String> (DEC-314), surfaces it as auth list's 5th table
  column (DEC-324, deliberate breaking insta-snapshot change) and in auth list/status JSON
  and auth status text output, with a channel split: JSON stays verbatim/lossless (issue
  #398 convention), human/table/text channels apply a shared control-char/ANSI-strip +
  length-cap sanitization transform.
---

# S-cycle3-env-tag — Add `ProfileConfig.env` tag + surface in `auth list`/`auth status`

## Anchor Justification

**Dependency anchors:** `depends_on: []` — BC-6.1.015 is a purely additive `Option<String>`
field on `ProfileConfig` with no dependency on any other cycle-003 change (ADR-0020 §
Sequencing item 1: "pure-additive, zero dependencies, can land first and independently").
`blocks: []` — no other cycle-003 story's BCs cite `env` as a functional precondition; the
manifest recommends landing this in Wave 1 alongside `S-cycle3-percred-storage` purely for
scheduling efficiency (both zero-dependency, file-disjoint: this story touches
`src/config.rs` + `src/cli/auth/list.rs` + `src/cli/auth/status.rs`; percred-storage touches
`src/api/auth.rs` + `src/cli/auth/login.rs` + `src/api/client.rs`), not because of a real
functional edge.

## Source of Truth

- `.factory/specs/prd/bc-6-config-cache.md` §6.1, BC-6.1.015 (schema field, storage contract,
  VP-AUTHDX-009)
- `.factory/specs/prd/bc-1-auth-identity.md` §1.6, BC-1.6.046 (amended — `auth list` 5-column
  table), BC-1.6.047 (new — JSON/status surfacing, channel split)
- `.factory/cycles/cycle-003/phase-f3-stories/decomposition-manifest.md` §2 Story 1
- ADR-0020 § Decision 4 ("Additive `env`/role tag (DEC-314)")

## Narrative

As a `jr` user managing multiple Jira profiles (prod / sandbox / uat),
I want each profile to carry an optional, free-form `env` label that is visible in
`auth list` and `auth status`,
so that I can tell at a glance which environment a profile targets without having to
inspect its URL.

## Behavioral Contracts

| BC | Status | What this story delivers |
|----|--------|---------------------------|
| BC-6.1.015 | NEW | `ProfileConfig.env: Option<String>` — additive, tolerant-reader, no migration, no validation/sanitization at the storage layer |
| BC-1.6.046 | AMENDED (breaking) | `auth list` table gains a 5th column `ENV` (between `URL` and `AUTH`); owns the human-table display-sanitization transform |
| BC-1.6.047 | NEW | `env` surfaced in `auth list --output json` (verbatim) and `auth status` (JSON contingent on NFR-O-N; text channel sanitized, same transform as BC-1.6.046) |

## Current State (read before implementing)

- `src/config.rs::ProfileConfig` (`~line 17`) has 8 fields today (`url`, `auth_method`,
  `cloud_id`, `org_id`, `oauth_scopes`, `team_field_id`, `story_points_field_id`, `project`).
  No `env` field exists.
- `src/cli/auth/list.rs::render_list_table` (`~line 9`) renders exactly 4 columns:
  `["NAME", "URL", "AUTH", "STATUS"]`.
- `src/cli/auth/list.rs::render_list_json` (`~line 36`) emits `name`, `url`, `auth_method`,
  `status`, `active` — no `env` key.
- `src/cli/auth/status.rs::status` (`~line 57`) prints human text only (no JSON support,
  NFR-O-N) — does not currently print an `env` line.
- `src/cli/auth/tests/snapshots/jr__cli__auth__tests__list_table_snapshot.snap` is pinned to
  the current 4-column, 3-profile fixture (`default*`/`sandbox`/`staging`).
- `src/cli/issue/attachments.rs::display_sanitize_filename` (`~line 279`) is the CWE-116
  precedent this story's new sanitizer mirrors IN CLASS (control-char/bidi-override
  stripping before terminal display) but NOT in exact behavior: that function REPLACES each
  offending character with `?`; BC-1.6.046 EC-1.6.046-2 requires this story's new helper to
  STRIP offending bytes outright AND apply a length cap with a truncation marker. Do not
  literally reuse `display_sanitize_filename` — write a new, small helper with the
  strip+cap contract this BC actually specifies.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~4,500 |
| BC-6.1.015 (full) | ~2,600 |
| BC-1.6.046 (full) | ~2,800 |
| BC-1.6.047 (full) | ~2,700 |
| `src/config.rs::ProfileConfig` + surrounding (~120 LOC) | ~1,500 |
| `src/cli/auth/list.rs` (full, ~90 LOC) | ~1,200 |
| `src/cli/auth/status.rs` (full, ~140 LOC) | ~1,800 |
| Existing snapshot file + insta test harness | ~600 |
| `cargo test`/`insta review` output for verification | ~500 |
| **Total** | **~18,200** |

Well within 20-30% of a typical agent context window. No splitting required.

## Previous Story Intelligence

N/A — first story in the `auth-profile-dx` epic (cycle-003) to land; no prior cycle-003
story output exists yet to carry forward. The general corpus precedent this story follows
is `display_sanitize_filename` (S-576-1, CWE-116) for the *shape* of a display-safety
transform, and issue #398's `issue edit` description-echo asymmetry for the *shape* of the
JSON-verbatim/human-sanitized channel split — both are cited above and in the Architecture
Compliance Rules below, not duplicated here.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Additive-only schema field | BC-6.1.015 | `env: Option<String>` must deserialize to `None` for any pre-existing `config.toml` with no `env` key — no `#[serde(default)]` needed if every other `Option` field on `ProfileConfig` already omits it (confirm current struct's derive attrs before adding the field; match the existing pattern exactly). |
| No enum/allowlist validation | BC-6.1.015 Invariant | `env` accepts any string, including `""`. Do NOT add a validator. `prod`/`sandbox`/`uat` are illustrative only. |
| Storage stays verbatim | BC-6.1.015 EC-4 | `ProfileConfig.env`'s getter/setter path performs zero sanitization. Sanitization is display-layer only, owned by this story's `list.rs`/`status.rs` call sites. |
| One shared sanitizer, two call sites | BC-1.6.046 Ownership clause; BC-1.6.047 Postcondition 2b/EC-1.6.047-3 | Implement the control-char/ANSI-strip + length-cap transform ONCE (new function, e.g. `output::sanitize_env_display` or co-located in `list.rs` and `pub(crate)`-exported for `status.rs` to reuse) and call it from both `render_list_table` and `status`'s text line. Do not duplicate the transform. |
| JSON channel stays lossless | BC-1.6.047 Postcondition 1/2a, Invariant 3 | `render_list_json` and any future `auth status --output json` MUST echo `env` byte-for-byte — never call the sanitizer on the JSON path. This mirrors issue #398's `issue edit` description-echo asymmetry (CLAUDE.md) — do not collapse the two channels. |
| `Some("")` vs `None` distinction is spec-fixed | BC-1.6.046 EC-1.6.046-1 | Table: `Some("")` → blank cell (zero visible chars); `None` → `-` placeholder. JSON: `Some("")` → `""`; `None` → `null`. Do not conflate. |
| `#[serde(rename = ...)]` / key presence | BC-1.6.047 Postcondition 1 | The JSON `"env"` key is NEVER omitted from a profile object — always present, value varies between the configured string and `null`. |
| `--output json` render invariant | CLAUDE.md #526 | Any new JSON output continues to route through `output::render_json`/`output::print_output`. Do not hand-roll `serde_json::to_string_pretty` or compact `json!` printing. |
| Zero-warnings policy | CLAUDE.md | `cargo clippy -- -D warnings` must pass after every edit. |

## Library and Framework Requirements

No new external dependencies. Uses only `serde` (already a dependency) for the new
`Option<String>` field and `comfy-table` (already used by `output::render_table`) for the
5th column.

| Item | Version / Constraint |
|------|----------------------|
| `serde` | pinned version unchanged — no `Cargo.toml` edit needed |
| `comfy-table` | pinned version unchanged — no `Cargo.toml` edit needed |

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `src/config.rs` | MODIFY | Add `pub env: Option<String>` to `ProfileConfig` (`~line 17`), matching the existing `Option<String>` field pattern exactly (no new attrs unless siblings already carry one). |
| `src/cli/auth/list.rs` | MODIFY | `render_list_table`: insert `ENV` column between `URL` and `AUTH`, applying the shared sanitizer + `Some("")`/`None` rendering rule. `render_list_json`: add `"env"` key (verbatim, `null` when unset). |
| `src/cli/auth/status.rs` | MODIFY | `status()`: print an `env` line to the human-text output, sanitized via the same shared transform, same `-`/blank convention. |
| `src/output.rs` OR a new small module | MODIFY/CREATE | New shared sanitizer function implementing BC-1.6.046 EC-1.6.046-2 / BC-1.6.047 EC-1.6.047-3 (control-char + ANSI CSI/OSC strip, length cap with truncation marker). Prefer `src/output.rs` since it already owns table/JSON formatting helpers — keep the function `pub(crate)`. |
| `src/cli/auth/tests/snapshots/jr__cli__auth__tests__list_table_snapshot.snap` | MODIFY (regenerate via `cargo insta review`) | 5-column snapshot; extend the 3-profile fixture with at least one `env`-tagged profile (per BC-1.6.046's own note). |
| `CHANGELOG.md` | MODIFY | Add a `[Unreleased] > Changed` (breaking) entry for the `auth list` 5-column snapshot change, following the BC-1.2.047/S-663-1 precedent for breaking-change CHANGELOG entries. |

**Files NOT to touch:** `src/api/auth.rs`, `src/cli/auth/login.rs` — this story is
schema+display only; no credential-storage code changes.

## Acceptance Criteria

### AC-001 — `ProfileConfig` deserializes `env: None` for a pre-existing config with no `env` key
A `config.toml` written before this field existed loads successfully with `env: None` for
every profile — no error, no warning.
(traces to BC-6.1.015 postcondition — EC-3)

### AC-002 — `env = ""` deserializes distinctly from an absent key
`env = ""` under `[profiles.x]` deserializes to `Some(String::new())`, never collapsed to
`None`.
(traces to BC-6.1.015 EC-2)

### AC-003 — round-trip and tolerant-reader property test (VP-AUTHDX-009)
A `proptest` over arbitrary `ProfileConfig` field combinations with/without `env` (including
`env = ""`) asserts: absent key → `None`; `Some(s)` survives a serialize→deserialize
round-trip as `Some(s)`; `None`/absent survives as `None`.
(traces to BC-6.1.015 VP-AUTHDX-009)

### AC-004 — `auth list` table renders 5 columns with `ENV` between `URL` and `AUTH`
`jr auth list` (table mode) prints headers `NAME, URL, ENV, AUTH, STATUS` in that order.
(traces to BC-1.6.046 postcondition — Behavior)

### AC-005 — table `ENV` cell: blank for `Some("")`, `-` for `None`
A profile with `env: Some("")` renders a blank `ENV` cell (zero visible characters); a
profile with `env: None` renders `-`.
(traces to BC-1.6.046 EC-1.6.046-1)

### AC-006 — table `ENV` cell sanitizes control chars/ANSI escapes and caps length
A profile with `env` containing `\x1b[31m`, raw `\r`/`\n`, or other ASCII control chars
(`0x00`–`0x1F`, `0x7F`) renders a stripped cell with no raw control bytes reaching the
terminal; a value longer than the fixed cap renders truncated with a truncation marker.
(traces to BC-1.6.046 EC-1.6.046-2)

### AC-007 — `auth list --output json` includes `"env"` verbatim/lossless for every profile
Every profile object in the JSON array carries an `"env"` key: the raw configured string
(including any control chars/ANSI escapes, unmodified) when set, or `null` when unset. The
key is never omitted.
(traces to BC-1.6.047 postcondition 1)

### AC-008 — `auth status` human-text output surfaces `env`, sanitized, same placeholder convention
`jr auth status` prints an `env` line using the identical control-char/ANSI-strip +
length-cap transform AC-006 exercises, with the same `-`/blank convention as AC-005.
(traces to BC-1.6.047 postcondition 2b, EC-1.6.047-3)

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-1.6.046-1 | BC-1.6.046 | `Some("")` vs `None` in the table | blank cell vs. `-` placeholder (AC-005) |
| EC-1.6.046-2 | BC-1.6.046 | hostile `env` value (control chars, ANSI escapes, over-length) | stripped + capped before insertion into the `comfy-table` cell (AC-006) |
| EC-1.6.047-1 | BC-1.6.047 | hostile `env` value in the JSON channel | displayed verbatim, no rejection, no truncation, no stripping (AC-007) |
| EC-1.6.047-2 | BC-1.6.047 | `auth status --output json` not yet implemented (NFR-O-N) | this story's JSON obligation applies to `list` only; `status`'s only current mode is text (AC-008) — do NOT implement `auth status --output json` as a side effect of this story |
| EC-1.6.047-3 | BC-1.6.047 | `auth status` human-text `env` sanitization | identical transform to BC-1.6.046 EC-1.6.046-2 (AC-008) |

## Tasks

### Item 1: Schema field
- [ ] Add `pub env: Option<String>` to `src/config.rs::ProfileConfig`
- [ ] Confirm no `#[serde(default)]` needed (match sibling `Option` fields' existing attrs)
- [ ] Write AC-001/AC-002 unit tests
- [ ] Write AC-003 `proptest` (VP-AUTHDX-009)

### Item 2: Shared display-sanitization helper
- [ ] Add a new `pub(crate) fn sanitize_env_display(value: &str) -> String` (or equivalent
      name) implementing: strip ASCII control chars (`0x00`–`0x1F`, `0x7F`) and ANSI
      CSI/OSC escape sequences; cap to a fixed max display length with a truncation marker
      when capped
- [ ] Unit tests: control chars stripped, ANSI escapes stripped, over-length capped with
      marker, ordinary strings pass through unchanged

### Item 3: `auth list` table + JSON
- [ ] `render_list_table`: insert `ENV` column, apply Item 2's sanitizer, apply the
      blank/`-` rendering rule
- [ ] `render_list_json`: add `"env"` key, verbatim (no sanitizer call)
- [ ] Regenerate `jr__cli__auth__tests__list_table_snapshot.snap` via `cargo insta review`,
      extending the fixture with at least one `env`-tagged profile
- [ ] Write AC-004/005/006/007 tests

### Item 4: `auth status` text output
- [ ] Add an `env` line to `status()`'s human-text output, sanitized via Item 2's helper,
      same blank/`-` convention
- [ ] Write AC-008 test

### Item 5: CHANGELOG + doc-fallout
- [ ] Add `[Unreleased] > Changed` CHANGELOG entry: `auth list` table gains a 5th `ENV`
      column — breaking insta-snapshot change; mention the `env` tag's purpose
- [ ] Confirm no CLAUDE.md doc-fallout is required (no new `JR_*` env var, no new gotcha) —
      if a genuinely new gotcha surfaces during implementation, add it per CLAUDE.md's
      "When adding a new `JR_*` test-seam env var" convention (N/A here, but the same
      same-commit-doc-fallout discipline applies to any other CLAUDE.md-worthy behavior)

### Integration checks (all must pass before PR)
- [ ] `cargo test` exits 0 (full suite)
- [ ] `cargo clippy -- -D warnings` exits 0
- [ ] `cargo fmt --all -- --check` exits 0
- [ ] `cargo insta review` — snapshot changes reviewed and accepted, not blindly `--accept`ed
- [ ] `bash scripts/check-spec-counts.sh` exits 0
- [ ] `bash scripts/check-bc-cumulative-counts.sh` exits 0

## Out of Scope

- `auth status --output json` (NFR-O-N, documented gap) — not implemented by this story.
- Any credential-storage change (`src/api/auth.rs`) — that is `S-cycle3-percred-storage`.
- Cache-root or keychain-namespace version bumps — explicitly out per ADR-0020 §3/DEC-325a
  (dropped F1 candidate, not this story's concern).

## Dependency Analysis

**depends_on: []** — leaf/root story, no prerequisite.
**blocks: []** — no other cycle-003 story has a hard functional dependency on `env`
existing; recommended (not required) Wave 1 co-scheduling with `S-cycle3-percred-storage`
for parallelism only (file-disjoint).

## Story Points and Effort

**5 story points** (small). Breakdown:
- Schema field + round-trip proptest: 1 SP
- Shared sanitizer + unit tests: 1.5 SP
- `auth list` table/JSON wiring + snapshot regen: 1.5 SP
- `auth status` text wiring: 0.5 SP
- CHANGELOG + integration checks: 0.5 SP

Risk: LOW. Purely additive schema change plus two existing, well-understood display call
sites. The only genuinely new logic is the sanitizer, which is small and unit-testable in
isolation.
