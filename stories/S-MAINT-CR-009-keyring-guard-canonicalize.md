---
document_type: story
story_id: "S-MAINT-CR-009"
title: "Canonicalize keyring-gate guard idiom to Idiom B (as_deref() != Ok(\"1\")) across all 17 test functions"
wave: feature-followup
status: draft
intent: refactor
feature_type: pattern-consistency
mode: feature
scope: small
severity: LOW
trivial_scope: false
points: 3
priority: P3
tdd_mode: strict
estimated_effort: small
estimated_days: 0.75
target_module: tests
subsystems: []
depends_on: []
blocks: []
bc_anchors: []
bcs: []
# BC status: pending PO authorship
# No product BCs are added or modified by this story. This is a pure test-infrastructure
# refactor — only test gate idioms change. No src/ code changes, no observable runtime
# behavior changes for end users.
# Do NOT add BCs to this story.
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/maintenance/2026-06-19/pattern-consistency.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 4
assumption_validations: []
risk_mitigations: []
created: "2026-06-19"
version: "1.0"
last_updated: "2026-06-19"
changelog:
  - "1.0 (2026-06-19): Initial draft — originated from 2026-06-19 maintenance sweep finding CR-009 / KEYRING-GUARD-IDIOM-DRIFT."
breaking_change: false
lineage:
  - S-410        # established the keyring gate pattern (PR #416 @ 04e019a; auth_profiles.rs sibling scope)
  - S-TESTTOOL-1 # added one more gated test in auth_profiles.rs; noted is_err() vs as_deref() tension
drift_items:
  - KEYRING-GUARD-IDIOM-DRIFT
files_modified:
  - tests/auth_profiles.rs       # MODIFY — migrate 3 Idiom-A (is_err()) occurrences to Idiom B (as_deref() != Ok("1"))
  - tests/common/mod.rs          # MODIFY (optional) — add fn keyring_tests_enabled() -> bool helper
  - CLAUDE.md                    # MODIFY — update AI Agent Notes JR_RUN_KEYRING_TESTS entry to document canonical Idiom B form
---

# S-MAINT-CR-009 — Canonicalize keyring-gate guard idiom to Idiom B

**Origin:** 2026-06-19 maintenance sweep, finding CR-009 (`pattern-consistency.md` §4, "Part B — New Findings") and drift item KEYRING-GUARD-IDIOM-DRIFT.
**Status at sweep:** OPEN / DEFERRED (LOW severity, pattern-consistency).

## Source of Truth

Maintenance sweep report: `.factory/maintenance/2026-06-19/pattern-consistency.md` §4 (CR-009)
Drift item: KEYRING-GUARD-IDIOM-DRIFT (`spec-coherence.md` §3.2 row 20)

## The Three Idioms (from sweep finding)

| Idiom | Guard form | Files / count | Behavior when `JR_RUN_KEYRING_TESTS=anything` |
|-------|-----------|---------------|------------------------------------------------|
| **A** | `if std::env::var("JR_RUN_KEYRING_TESTS").is_err() { return; }` | `tests/auth_profiles.rs` (3 sites) | Runs test — `is_err()` is false whenever the variable is SET to ANY value, including `"0"` |
| **B** | `if std::env::var("JR_RUN_KEYRING_TESTS").as_deref() != Ok("1") { return; }` | `tests/multi_cloudid_disambiguation.rs` (5), `tests/oauth_refresh_integration.rs` (5), `tests/auth_output_json.rs` (5), `tests/auth_profiles.rs` (1 after S-TESTTOOL-1 added one using `is_err()`) — 17 total | Runs test ONLY when value is exactly `"1"` |
| **C** | `match` + `panic!` | `tests/auth_output_json.rs` (1) | Panics with an error message if env var unset or not `"1"` |

**Problem:** A developer who sets `JR_RUN_KEYRING_TESTS=yes` (or any non-`"1"` value) will
run tests under Idiom A but silently skip them under Idioms B and C, producing inconsistent
opt-in behavior. The behavioral difference is subtle and not documented in CLAUDE.md.

**Resolution:** Adopt Idiom B as canonical (majority, stricter, consistent with Idiom C
semantics). Migrate Idiom A occurrences to Idiom B. Idiom C (`panic!`) is effectively
equivalent to Idiom B for the passing-case and is left as-is (one occurrence; acceptable).

## Behavioral Contracts

No product BCs are added or modified by this story. The change is in test-gate behavior:
tests gated with Idiom A that previously ran on `JR_RUN_KEYRING_TESTS=yes` will now
require `JR_RUN_KEYRING_TESTS=1`. For CI (which either does not set this variable or
sets it to exactly `"1"`), no behavior changes. The migration is backwards-compatible
for the canonical opt-in form documented in CLAUDE.md (`JR_RUN_KEYRING_TESTS=1`).

This story traces its ACs to drift item KEYRING-GUARD-IDIOM-DRIFT and finding CR-009.

## Story Narrative

As a contributor to `jr`,
I want every keyring-gate guard in the test suite to use the canonical Idiom B form
(`as_deref() != Ok("1")`),
so that `JR_RUN_KEYRING_TESTS=yes` (or any non-`"1"` value) consistently skips gated
tests across all files, and AI agents and human contributors have a single clear opt-in
form to follow.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~3,500 |
| `tests/auth_profiles.rs` (full, ~400 LOC) | ~5,200 |
| `tests/multi_cloudid_disambiguation.rs` (guard sites only, ~20 LOC) | ~260 |
| `tests/oauth_refresh_integration.rs` (guard sites only, ~20 LOC) | ~260 |
| `tests/auth_output_json.rs` (guard sites only, ~20 LOC) | ~260 |
| `tests/common/mod.rs` (current, ~50 LOC) | ~650 |
| `CLAUDE.md` AI Agent Notes JR_RUN_KEYRING_TESTS section | ~800 |
| Maintenance sweep CR-009 §4 (finding detail) | ~800 |
| **Total** | **~11,730** |

Well within 20% agent context window budget. No splitting required.

## Previous Story Intelligence

**S-410** (PR #416 @ 04e019a, 2026-05-27) established the initial keyring-gate pattern
for `tests/auth_profiles.rs`. It used `is_err()` (Idiom A) as the canonical form for that
file, matching two pre-existing sibling tests.

**S-TESTTOOL-1** (PR #533 → b4a470f, 2026-06-18) added a third `is_err()` gate in
`tests/auth_profiles.rs` (`global_profile_flag_targets_auth_status`), explicitly preserving
Idiom A to match the sibling convention in that file.

**This story supersedes the Idiom A convention for `tests/auth_profiles.rs`.** After this
story, all three `auth_profiles.rs` Idiom A sites are migrated to Idiom B. The justification
for using `is_err()` in those tests (matching siblings) no longer applies once all siblings
are migrated.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Canonical gate form | CR-009 finding | The canonical keyring-gate guard MUST be `if std::env::var("JR_RUN_KEYRING_TESTS").as_deref() != Ok("1") { return; }` — Idiom B. No new `is_err()` gates may be added (Idiom A). |
| Migrate only Idiom A sites | CR-009 finding | Migrate the 3 Idiom A sites in `tests/auth_profiles.rs`. Do NOT touch Idiom B (17 sites — they are already correct) or Idiom C (1 site — equivalent behavior, leave as-is). |
| Optional shared helper | CR-009 proposed fix | Optionally extract `fn keyring_tests_enabled() -> bool { std::env::var("JR_RUN_KEYRING_TESTS").as_deref() == Ok("1") }` into `tests/common/mod.rs`. If extracted, update at least the 3 migrated sites to call the helper. Do NOT require all 17 sites to be updated in this story — batch migration of existing Idiom B callers is out of scope. |
| CLAUDE.md doc-fallout (required) | CLAUDE.md AI Agent Notes | Update the `JR_RUN_KEYRING_TESTS=1` entry to state that the canonical gate form is `as_deref() != Ok("1")` (Idiom B, requires value exactly `"1"`), and that `JR_RUN_KEYRING_TESTS=yes` will NOT trigger keyring tests. |
| `cargo clippy -D warnings` must pass | CLAUDE.md zero-warnings policy | After every edit, `cargo clippy -- -D warnings` must exit 0. |

## Library and Framework Requirements

No new library or framework dependencies.

| Item | Version / Constraint |
|------|---------------------|
| `std::env::var` | Rust standard library — no crate needed |

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `tests/auth_profiles.rs` | MODIFY | Migrate 3 Idiom A occurrences (`is_err()`) to Idiom B (`as_deref() != Ok("1")`). |
| `tests/common/mod.rs` | MODIFY (optional) | Add `pub fn keyring_tests_enabled() -> bool` helper. |
| `CLAUDE.md` | MODIFY | Update AI Agent Notes `JR_RUN_KEYRING_TESTS` entry: document canonical Idiom B form; note that `JR_RUN_KEYRING_TESTS=yes` does NOT opt in. |

**Files NOT to touch:** `tests/multi_cloudid_disambiguation.rs`, `tests/oauth_refresh_integration.rs`,
`tests/auth_output_json.rs` (already on Idiom B — no change needed in this story).

## Acceptance Criteria

### AC-001 (KEYRING-GUARD-IDIOM-DRIFT) — No Idiom A guards remain in the test suite

After the migration, `grep -rn 'JR_RUN_KEYRING_TESTS.*is_err' tests/` returns 0 matches.

**Verifiable by:**
```bash
grep -rn 'JR_RUN_KEYRING_TESTS.*is_err\|is_err.*JR_RUN_KEYRING_TESTS' tests/
# Expected: 0 matches
```

(traces to KEYRING-GUARD-IDIOM-DRIFT — Idiom A accepts any value including "0")

---

### AC-002 (KEYRING-GUARD-IDIOM-DRIFT) — All 3 migrated tests in `auth_profiles.rs` use Idiom B

The three previously Idiom A sites in `tests/auth_profiles.rs` now contain:
`std::env::var("JR_RUN_KEYRING_TESTS").as_deref() != Ok("1")`.

**Verifiable by:**
```bash
grep -n 'as_deref.*Ok.*1.*JR_RUN_KEYRING_TESTS\|JR_RUN_KEYRING_TESTS.*as_deref.*Ok.*1' tests/auth_profiles.rs
# Expected: ≥ 3 matches (one per migrated function)
```

(traces to CR-009 — three Idiom A sites in auth_profiles.rs)

---

### AC-003 (KEYRING-GUARD-IDIOM-DRIFT) — Gated tests still pass when `JR_RUN_KEYRING_TESTS=1`

The 17 keyring-gated tests (including the 3 migrated) still execute and pass when the
variable is set to exactly `"1"`.

**Verifiable by (CI or local with keyring access):**
```bash
JR_RUN_KEYRING_TESTS=1 cargo test --test auth_profiles -- --include-ignored
# Expected: all 3 previously Idiom A tests run and pass (requires keyring backend)
```

Note: this AC requires `JR_RUN_KEYRING_TESTS=1` and a system keyring. In CI without
keyring support, confirm only that the tests appear as `ignored` under plain `cargo test`
and that `cargo test --test auth_profiles` exits 0.

(traces to CR-009 — migration must not break the gated-test opt-in path)

---

### AC-004 (KEYRING-GUARD-IDIOM-DRIFT) — CLAUDE.md documents canonical Idiom B form

`CLAUDE.md` AI Agent Notes section for `JR_RUN_KEYRING_TESTS=1` states that the canonical
gate form is `as_deref() != Ok("1")` and notes that `JR_RUN_KEYRING_TESTS=yes` (or any
non-`"1"` value) will NOT opt in.

**Verifiable by:**
```bash
grep -A5 'JR_RUN_KEYRING_TESTS' CLAUDE.md | grep 'as_deref\|Ok.*1'
# Expected: at least one match confirming the canonical form is documented
```

(traces to KEYRING-GUARD-IDIOM-DRIFT — no canonical form documented in CLAUDE.md)

---

## Tasks

### Item 1: Audit all Idiom A sites

- [ ] `grep -rn 'is_err.*JR_RUN_KEYRING_TESTS\|JR_RUN_KEYRING_TESTS.*is_err' tests/` — confirm exactly 3 matches, all in `tests/auth_profiles.rs`
- [ ] Read `tests/auth_profiles.rs` in full — identify the 3 function names and their guard lines

### Item 2: Migrate 3 Idiom A sites in `tests/auth_profiles.rs`

For each of the 3 sites, replace:
```rust
if std::env::var("JR_RUN_KEYRING_TESTS").is_err() { return; }
```
with:
```rust
if std::env::var("JR_RUN_KEYRING_TESTS").as_deref() != Ok("1") { return; }
```

- [ ] Migrate site 1 (`auth_login_creates_new_profile_with_url` or current name)
- [ ] Migrate site 2 (`auth_login_with_jr_profile_pointing_to_unrelated_profile_still_creates_target` or current name)
- [ ] Migrate site 3 (`global_profile_flag_targets_auth_status` — added by S-TESTTOOL-1)
- [ ] Run `cargo test --test auth_profiles` — must exit 0 (all gated tests skipped; ungated tests pass)

### Item 3: (Optional) Extract `keyring_tests_enabled()` helper

- [ ] Read `tests/common/mod.rs` in full
- [ ] Add `pub fn keyring_tests_enabled() -> bool { std::env::var("JR_RUN_KEYRING_TESTS").as_deref() == Ok("1") }`
- [ ] Optionally update the 3 migrated `auth_profiles.rs` sites to call `if !common::keyring_tests_enabled() { return; }` — or leave the inline form

### Item 4: CLAUDE.md doc-fallout (required)

- [ ] Read the `JR_RUN_KEYRING_TESTS=1` entry in CLAUDE.md AI Agent Notes
- [ ] Update to state canonical Idiom B form: `as_deref() != Ok("1")`, requiring value exactly `"1"`; note that `JR_RUN_KEYRING_TESTS=yes` will NOT opt in

### Integration checks (all must pass before PR)

- [ ] `cargo test` exits 0 (all gated tests are `#[ignore]` and skipped; ungated suite passes)
- [ ] `grep -rn 'is_err.*JR_RUN_KEYRING_TESTS\|JR_RUN_KEYRING_TESTS.*is_err' tests/` → 0 matches
- [ ] `cargo clippy -- -D warnings` exits 0
- [ ] `cargo fmt --all -- --check` exits 0
- [ ] `bash scripts/check-spec-counts.sh` exits 0
- [ ] `bash scripts/check-bc-cumulative-counts.sh` exits 0

## Out of Scope

- **Migrating the 17 existing Idiom B sites.** They are already correct — no change needed.
- **Migrating the 1 Idiom C site** (`match` + `panic!`) in `tests/auth_output_json.rs`.
  Idiom C is semantically equivalent to Idiom B for the passing case; leave as-is.
- **`src/` changes.** Test-only refactor.
- **New BCs, new VPs, new NFRs, new ADRs.**

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `tests/auth_profiles.rs` | `tests/` | Effectful (keychain I/O gated) | Migrate 3 Idiom A guards to canonical Idiom B |
| `tests/common/mod.rs` | `tests/common` | Pure (env var read) | Optional: `keyring_tests_enabled()` helper |
| `CLAUDE.md` | root | N/A (documentation) | Document canonical Idiom B form |

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-001 | CR-009 | A developer currently uses `JR_RUN_KEYRING_TESTS=yes` to run keyring tests | After migration, `JR_RUN_KEYRING_TESTS=yes` will silently skip the 3 migrated tests (Idiom B requires `"1"`). This is the DESIRED behavior — the canonical opt-in form is `JR_RUN_KEYRING_TESTS=1`. Document in CLAUDE.md (AC-004). |
| EC-002 | CR-009 | Migrated test fails under `JR_RUN_KEYRING_TESTS=1` after idiom change | The Idiom A → B change is a gate-form change only; the test body is unchanged. Any failure under `JR_RUN_KEYRING_TESTS=1` indicates a pre-existing keyring issue, not a regression from this migration. |

## Dependency Analysis

**depends_on: []** — No story dependencies. Standalone test-infrastructure refactor.

**blocks: []** — No story depends on this within the current story graph.

This is a LEAF story in the dependency graph.

---

## Story Points and Effort

**3 story points** (small). Breakdown:
- Audit all Idiom A sites: 0.25 SP
- Migrate 3 sites in `auth_profiles.rs`: 0.75 SP
- Optional helper extraction: 0.5 SP
- CLAUDE.md doc-fallout: 0.5 SP
- Integration checks: 1 SP

Risk: LOW (test-only refactor; behavioral change is intentional and documented).
