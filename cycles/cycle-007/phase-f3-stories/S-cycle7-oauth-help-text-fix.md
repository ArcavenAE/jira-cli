---
document_type: story
level: ops
story_id: "S-cycle7-oauth-help-text-fix"
epic_id: "AUTH-CORRECTNESS-DX-1"
title: "Correct --oauth help text overclaims (issue #790)"
wave: 1
status: draft
intent: bug-fix
feature_type: documentation
mode: feature
scope: trivial
severity: LOW
trivial_scope: true
producer: story-writer
timestamp: "2026-09-10T00:00:00"
phase: 3
inputs:
  - ".factory/phase-f2-spec-evolution/cycle-007-prd-delta.md"
  - ".factory/specs/prd/bc-1-auth-identity.md"
  - "src/cli/mod.rs"
input-hash: "696e65c"
traces_to: ".factory/phase-f2-spec-evolution/cycle-007-prd-delta.md §6.1"
cycle: cycle-007-auth-correctness-dx
estimated_effort: xsmall
estimated_days: 0.5
target_module: "src/cli/mod.rs"
subsystems: ["SS-02"]
depends_on: []
blocks: []
behavioral_contracts:
  - BC-1.2.049
bcs:
  - BC-1.2.049
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0006"]
sd_refs: []
priority: P3
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-007/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: tdd
tdd_mode: strict
module_criticality: LOW
points: 2
acceptance_criteria_count: 5
assumption_validations: []
risk_mitigations: []
created: "2026-09-10"
version: "1.0"
last_updated: "2026-09-10"
breaking_change: false
retroactive: false
origin: >
  cycle-007 auth-correctness-dx, Wave 1, no deps. `AuthCommand::Login`'s
  `--oauth` doc comment (`src/cli/mod.rs`) states "(requires your own OAuth
  app)" — factually wrong given jr's embedded OAuth app (ADR-0006,
  `embedded_oauth_app_present()`, resolver order flag -> env -> keychain ->
  embedded -> prompt). The same doc string also overclaims the deprecation
  notice prints unconditionally in human mode, when in fact
  `check_noninteractive_oauth_guard`'s rejection already correctly precedes
  and suppresses it (confirmed-correct EXISTING runtime behavior, not a bug —
  BC-1.2.049 gains EC-1.2.049-3 to document this so the corrected help text has
  something to agree with). This is a doc-string-only fix; no BC
  Postcondition/Invariant changes. Human-approved at the F1 gate (2026-09-10)
  as part of the 6-issue `auth-correctness-dx` bundle.
---

> **tdd_mode:** `strict` — even though this is a doc-string-only change, the
> one behavioral claim it makes (guard-rejection precedes the deprecation
> notice) gets a regression-pinning test, not merely a doc review.
> `module_criticality: LOW` reflects the change's blast radius (help text
> only), not a relaxed testing bar.

> **Execute:** `/vsdd-factory:deliver-story S-cycle7-oauth-help-text-fix`

# S-cycle7-oauth-help-text-fix — `--oauth` help text no longer overclaims

## Narrative

- **As a** `jr` user reading `jr auth login --help`
- **I want to** see accurate help text for `--oauth` that reflects jr's
  embedded OAuth app (I don't need to register my own app), and an accurate
  description of when the deprecation notice actually prints
- **So that** I don't waste time registering an unnecessary OAuth app, and so
  that the help text matches what the CLI actually does

## Behavioral Contracts

| BC | Role | Clauses this story implements |
|----|------|-------------------------------|
| BC-1.2.049 | CROSS-REFERENCE (amended, doc-only) | EC-1.2.049-3 (confirms the guard-rejection-precedes-notice runtime behavior this story's corrected help text must agree with) — this story makes NO Postcondition/Invariant change; the doc-string edit lives entirely outside this BC's normative clauses |

**No BC pins the literal CLI help-text wording** (per the PRD delta §6.1: "it's a doc comment, not a tested contract"). This story's ACs therefore trace to the PRD delta's own doc-delta requirements (§6.1) and to EC-1.2.049-3's confirmed-correct runtime behavior, which this story adds a regression test for (previously untested, though already correct).

## Acceptance Criteria

### AC-001 (traces to PRD delta §6.1 primary defect / BC-1.2.049 EC-1.2.049-3 cross-reference)
`AuthCommand::Login`'s `--oauth` doc comment in `src/cli/mod.rs` (currently `~line 221`: `"Use OAuth 2.0 instead of API token (requires your own OAuth app)."`) no longer states "(requires your own OAuth app)". The corrected wording states that `jr` ships an embedded default OAuth app (ADR-0006) and describes `--client-id`/`--client-secret`/`JR_OAUTH_CLIENT_ID`/`JR_OAUTH_CLIENT_SECRET` as an OPTIONAL override, not a requirement.
**Test:** `test_help_text_oauth_flag_does_not_claim_own_app_required` (a string-content assertion against `Cli::command().render_help()` or the equivalent clap introspection API, NOT a manual doc read)

### AC-002 (traces to PRD delta §6.1 secondary (a))
The same doc string no longer implies the deprecation notice is printed unconditionally in human mode — reworded to be consistent with the confirmed-correct runtime behavior (guard rejection precedes the notice; see AC-003).
**Test:** `test_help_text_oauth_flag_does_not_overclaim_unconditional_notice`

### AC-003 (traces to BC-1.2.049 EC-1.2.049-3, regression pin for EXISTING correct behavior)
`jr auth login --oauth --no-input` against a target `check_noninteractive_oauth_guard` rejects (`src/cli/auth/login.rs`, runs BEFORE `emit_oauth_deprecation_notice` in `handle_login`'s call order) → the guard's rejection fires, and the deprecation-notice code path is NEVER reached (asserted by the absence of the deprecation-notice substring in stderr, alongside the guard's own rejection message being present). This is NOT a new behavior — it is the pre-existing, correct call order, now formalized as a regression pin per EC-1.2.049-3's own stated purpose ("documents existing, correct behavior against which the corrected help text must now agree").
**Test:** `test_ec_1_2_049_3_guard_rejection_precedes_deprecation_notice`

### AC-004 (traces to PRD delta §6.2(b), explicitly declined this cycle)
Clap's default `conflicts_with`-driven usage-line rendering for `--oauth`/`--api-token` is NOT modified by this story (out of scope — cosmetic, low value, higher implementation cost per the PRD delta's own recommendation). A test confirms the existing clap-generated usage string is unaffected by this story's doc-comment-only diff (i.e., no accidental change to arg attributes).
**Test:** `test_clap_conflicts_with_usage_rendering_unaffected_by_doc_change`

### AC-005 (traces to CLAUDE.md conventions — CHANGELOG delivery task)
`CHANGELOG.md`'s `[Unreleased]` section gains a `Fixed` entry documenting the corrected `--oauth` help text (no functional/behavioral change, doc-accuracy fix only).
**Test:** N/A (doc artifact; verified by PR review)

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `AuthCommand::Login`'s `--oauth` doc comment | `src/cli/mod.rs` | Pure (clap derive doc-attribute; no runtime code path) |
| `check_noninteractive_oauth_guard` / `emit_oauth_deprecation_notice` call order | `src/cli/auth/login.rs` | Effectful-shell (existing, UNCHANGED by this story — AC-003 is a regression pin, not a behavior change) |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|-------------------|
| EC-1.2.049-1 | `--oauth --output json` | No deprecation notice on stderr either (unaffected by this story — output-format gate, not TTY gate) |
| EC-1.2.049-2 | `--oauth` combined with `--api-token` on the same invocation | Mutually exclusive, clap-level rejection (exit 2) — unaffected by this story |
| EC-1.2.049-3 (this story's regression pin) | `--oauth --no-input` against a guard-rejected target | Guard rejection fires; deprecation notice never reached (AC-003) |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|----------------|
| `src/cli/mod.rs`'s doc-comment edit | pure-core (compile-time only) | A `#[doc = "..."]`/`///` comment has zero runtime effect; the change is purely textual |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~1,800 |
| Referenced code files (`src/cli/mod.rs::AuthCommand::Login` region, `src/cli/auth/login.rs`'s guard/notice call order) | ~2,500 |
| Test files (help-text assertion, guard-order regression test) | ~1,500 |
| Tool outputs overhead | ~1,200 |
| **Total** | **~7,000** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~3.5%** |

Trivially within budget.

## Tasks

1. [ ] Write failing test for AC-001/AC-002 (help-text content assertions) — `test-writer`
2. [ ] Write failing test for AC-003 (guard-rejection-precedes-notice regression pin) — `test-writer`
3. [ ] Write failing/passing-as-baseline test for AC-004 (usage-line rendering unaffected — this test should PASS before AND after, since no `#[arg(...)]` attribute changes; write it to lock the baseline) — `test-writer`
4. [ ] Verify Red Gate: AC-001/AC-002 tests fail against the current, overclaiming doc string
5. [ ] Implement: edit `AuthCommand::Login`'s `--oauth` doc comment in `src/cli/mod.rs` — remove "(requires your own OAuth app)"; add the embedded-default + optional-override wording; correct the unconditional-notice overclaim — `implementer`
6. [ ] Confirm zero `#[arg(...)]` attribute changes (diff review — only doc-comment text changes)
7. [ ] Add a CHANGELOG entry under `[Unreleased] > Fixed` (AC-005), before creating the PR

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|----------------|------------------------|----------------------|
| S-cycle3-oauth-default-creation (cycle-003) | Established the embedded-OAuth-app-by-default framing this story's corrected help text describes (ADR-0006, ADR-0020 §Decision 5) | `--oauth` is a deprecated-but-accepted alias (BC-1.2.049), not removed | N/A — first story to touch this specific doc string since its original (incorrect) wording predates cycle-003 |
| N/A (first story in this cycle's epic to touch `src/cli/mod.rs`'s help text specifically) | — | — | N/A — first story in epic for this file/scope |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| Help-text/doc-comment changes must not alter any `#[arg(...)]` attribute (flag name, `conflicts_with`, `long`/`short`) | General CLI-stability convention (this project's `--allow_hyphen_values`/`conflicts_with` conventions are load-bearing elsewhere in CLAUDE.md) | AC-004 |
| A corrected doc string must be verified via a real clap introspection call (`Cli::command().render_help()` or equivalent), not asserted by manual reading alone | This story's own test discipline (`tdd_mode: strict`) | AC-001/AC-002's test bodies |

## Library & Framework Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| `clap` | Per `Cargo.toml` pin (existing dependency, unchanged) | Help-text/usage-line introspection for AC-001/AC-002/AC-004 |

No new library is introduced.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/cli/mod.rs` | modify | `AuthCommand::Login`'s `--oauth` doc comment |
| `tests/` (existing CLI-surface test file, or a new small one, implementer's judgment) | modify or create | Help-text content assertions, guard-order regression pin |
| `CHANGELOG.md` | modify | `[Unreleased] > Fixed` entry (Task 7) |
