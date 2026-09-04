---
document_type: story
level: ops
story_id: "S-cycle4-windows-docs"
epic_id: "WINDOWS-CORRECTNESS-1"
title: "README Windows install steps, config/cache path table, and cloud_id caveat (#760)"
wave: 2
status: draft
intent: enhancement
feature_type: docs
mode: feature
scope: trivial
severity: N/A
trivial_scope: true
points: 3
priority: P1
tdd_mode: facade
producer: story-writer
timestamp: "2026-09-04T00:00:00"
phase: 3
inputs:
  - ".factory/cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md"
  - ".factory/cycles/cycle-004/phase-f1-delta-analysis/affected-files.txt"
  - ".factory/cycles/cycle-004/phase-f3-stories/S-cycle4-cloud-id-correctness.md"
  - "README.md"
  - "CLAUDE.md"
input-hash: "4dd740b"
traces_to: ".factory/cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md"
cycle: cycle-004-windows-correctness
estimated_effort: small
estimated_days: 1
target_module: README.md
subsystems: []
depends_on: ["S-cycle4-cloud-id-correctness"]
blocks: []
behavioral_contracts: []
bcs: []
# BC status: N/A -- this is a documentation-only story (#760). Its acceptance criteria
# are doc-content assertions, not BC-backed behavioral assertions. No src/ code changes.
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-004/phase-f3-stories/decomposition-manifest.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 5
assumption_validations: []
risk_mitigations: []
created: "2026-09-04"
version: "1.2"
last_updated: "2026-09-04"
breaking_change: false
retroactive: false
origin: >
  cycle-004 windows-correctness, Wave 2. Implements issue #760's documentation fixes:
  stale Windows install guidance (README still says a Windows asset is "planned" and
  tells users to use prerelease=true, when v0.6.0+ already ships a stable
  x86_64-pc-windows-msvc.zip with no documented direct-download/Unblock-File steps), the
  Unix-only documented config path (README says ~/.config/jr/config.toml; Windows
  actually resolves to %APPDATA%\jr\config.toml per BC-6.1.014/BC-6.2.016, with a
  confusing "No profiles configured" failure mode instead of a path hint), and the
  cloud_id auto-discovery caveat -- rewritten to describe the CORRECTED, post-cycle-004
  state (auto-discovered for both OAuth and API-token logins, per
  S-cycle4-cloud-id-correctness) rather than the pre-fix OAuth-only limitation #760
  originally reported.
---

> **tdd_mode:** `facade` — documentation-only story; there is no `src/` scaffold to
> Red-Gate. Quality gate is human/markdown-lint review of the README diff, not mutation
> testing or a Red Gate density check.

> **Execute:** `/vsdd-factory:deliver-story S-cycle4-windows-docs`

# S-cycle4-windows-docs — README Windows install, path table, and cloud_id caveat

> **Revision note (v1.1 → v1.2, F3 re-review comprehensive fix pass, 2026-09-04):**
> annotated the existing `CHANGELOG.md` File Structure Requirements row with the
> cross-story `[Unreleased]`-section hotspot note (F3 re-review Finding #1) — this story
> was already the only one of the four with `CHANGELOG.md` correctly listed in its
> footprint; the other three stories' footprints were the ones missing it, now fixed. See
> `conflict-report.md` §1/§4 and `wave-schedule.md` §2/§3/§7a.

## Anchor Justification

**Subsystem anchor:** N/A — this is a documentation-only story (`README.md`), not a
`src/` change. No subsystem in the ARCH-INDEX.md Subsystem Registry owns documentation
files; `subsystems: []` is correct and does not need a forced-fit anchor.

**Dependency anchor:** `depends_on: ["S-cycle4-cloud-id-correctness"]` because this
story's `cloud_id` caveat paragraph (AC-004 below) must describe the CORRECTED,
post-cycle-004 behavior — `cloud_id` is now auto-discovered for API-token logins too, via
an unauthenticated `tenant_info` fetch, with a documented `--cloud-id` override and
soft-fail fallback (BC-1.2.052/053) — not the pre-fix "OAuth-only" limitation issue #760
originally reported. Writing this paragraph before `S-cycle4-cloud-id-correctness`'s
exact fetch/override/soft-fail mechanics are finalized risks documenting behavior that no
longer matches what ships. This is a content-accuracy dependency, not a file-overlap or
compile dependency (the two stories touch disjoint files: this story touches only
`README.md`; `S-cycle4-cloud-id-correctness` touches `src/cli/auth/login.rs`,
`src/cli/auth/refresh.rs`, `src/cli/init.rs`, and a new `src/api/jira/tenant.rs`) — so it
does not block Wave 1 scheduling, but it does mean this story's Wave-2 placement is
deliberate, not incidental.

**No `blocks` entries:** nothing else in cycle-004's F3 scope depends on this story.

## Source of Truth

- `.factory/cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md` §0 (Bundle
  Summary, #760's three defects) and §11 (the `cloud_id` cross-cutting observation).
- `.factory/cycles/cycle-004/phase-f1-delta-analysis/affected-files.txt` (`README.md`
  row).
- `CLAUDE.md`'s existing "Windows config/cache paths (BC-6.1.014, BC-6.2.016)" gotcha
  entry — the authoritative source for the corrected per-platform path table.
- `S-cycle4-cloud-id-correctness.md` (this story's dependency) for the exact,
  finalized `cloud_id` acquisition mechanics to describe.

## Narrative

As a `jr` user installing on Windows for the first time, I want the README to tell me
exactly how to download and run `jr` on Windows (including the `Unblock-File`
mark-of-the-web step), where my config and cache actually live on Windows, and how
`cloud_id` auto-discovery works for whichever auth method I choose — instead of stale
guidance that says Windows support is still "planned" and a Unix-only config path that
leads to a confusing "No profiles configured" error with no path hint.

## Behavioral Contracts

None. This is a documentation-only story (#760) — per the F3 story-writer's contract,
doc-scope acceptance criteria are marked explicitly as no-BC below rather than force-fit
to an unrelated BC. `bcs: []` / `behavioral_contracts: []` is correct and intentional, not
an oversight.

## Acceptance Criteria

> **No-BC notice:** every AC in this section is a doc-content assertion against
> `README.md`'s actual text, not a behavioral assertion against `src/` code. There is no
> BC to trace to for a pure documentation fix — this is explicitly permitted per this
> story's contract for #760.

### AC-001 (doc-only, no BC — README Windows install steps; CONFIRM-AND-PRESERVE, not fix)
**Verified against the current `README.md` during F3 authoring (2026-09-04): this
sub-defect is ALREADY FIXED, ahead of F1's framing.** `README.md:66-68` already states
plainly that a stable `x86_64-pc-windows-msvc.zip` asset ships as of `v0.6.0` and that
`prerelease = true` is "no longer required for Windows" — the "planned"/`prerelease=true`
language F1 §0 described no longer exists in the install section (`grep -n "planned"
README.md` matches only the unrelated Homebrew-tap/crates.io/GitHub-Attestations rows,
none adjacent to "Windows"). This AC is therefore a REGRESSION GUARD: confirm the
mise-based install instructions remain accurate and are not accidentally reverted or
contradicted by this story's other edits (AC-002/003/004) — no content change is expected
here, but the install section is still in scope for review since AC-002's `Unblock-File`
note is added adjacent to it.
- **Test:** manual doc review confirming `README.md`'s existing Windows-asset language is
  unchanged and internally consistent with AC-002's addition; `git diff README.md` for
  this story shows no removal or contradiction of the existing lines 66-68 text.

### AC-002 (doc-only, no BC — `Unblock-File` mark-of-the-web note)
`README.md`'s Windows install steps include an explicit `Unblock-File` (or equivalent
mark-of-the-web removal) instruction, since a `.zip` downloaded via a browser is flagged
by Windows and can otherwise silently fail to run or trigger a SmartScreen warning with
no explanation in the README.
- **Test:** manual doc review; grep for `Unblock-File` in the Windows install section.

### AC-003 (doc-only, no BC — per-platform config/cache path table)
`README.md` gains a per-platform config/cache path table (Unix: `~/.config/jr/config.toml`,
`~/.cache/jr/v1/<profile>/`; Windows: `%APPDATA%\jr\config.toml`,
`%LOCALAPPDATA%\jr\v1\<profile>\`), replacing the current Unix-only path reference — this
must match `CLAUDE.md`'s existing "Windows config/cache paths (BC-6.1.014, BC-6.2.016)"
gotcha entry verbatim in substance, not merely gesture at "platform-specific paths exist."
- **Test:** manual doc review; cross-check the table's Windows paths against
  `src/config.rs::global_config_dir()` and `src/cache.rs::cache_root()`'s actual
  `#[cfg(windows)]` logic (read-only verification, no code change).

### AC-004 (doc-only, no BC — `cloud_id` auto-discovery caveat, CORRECTED state)
`README.md`'s `cloud_id` documentation is rewritten to state that `cloud_id` is now
auto-discovered for BOTH the OAuth flow (existing `accessible-resources` discovery,
unchanged) AND the API-token flow (new `tenant_info` fetch, `S-cycle4-cloud-id-correctness`,
BC-1.2.052) — including the `--cloud-id` override flag and the soft-fail behavior (a
failed lookup never blocks login; Assets/CMDB commands remain the actionable "Cloud ID not
configured" error path if acquisition never succeeds). This explicitly does NOT restate
the pre-fix "OAuth-only" limitation issue #760 originally reported — the doc must describe
the shipped, corrected behavior, not the historical bug.
- **Test:** manual doc review; cross-check against `S-cycle4-cloud-id-correctness`'s
  final AC text (read-only verification once that story lands, no code change here).

### AC-005 (doc-only, no BC — no unrelated content drift)
The README diff for this story touches ONLY the install-steps, path-table, and
`cloud_id`-caveat sections — no unrelated README content (e.g. command reference tables,
other OS sections) is modified as a side effect.
- **Test:** manual PR-diff review; `git diff README.md` scoped to the three sections
  above.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|---------------|
| N/A | `README.md` | N/A — documentation, not executable code; no purity classification applies |

## UX Screens

N/A — documentation change, no UI surface.

## Design System Components

N/A — not a UI story.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-760-1 | A reader on Windows follows the OLD "use prerelease=true" instruction | Already impossible as of this story's authoring — `README.md`'s install section was independently corrected before this cycle began (verified 2026-09-04); AC-001 is now a regression guard, not a fix |
| EC-760-2 | A reader downloads the `.zip` via a browser and does not know about mark-of-the-web | Addressed by AC-002's explicit `Unblock-File` step |
| EC-760-3 | A reader on Windows looks for `~/.config/jr/config.toml` and finds nothing (silent "No profiles configured") | Addressed by AC-003's path table, giving the reader the correct `%APPDATA%\jr\config.toml` location directly |
| EC-760-4 | This story's `cloud_id` caveat text is written BEFORE `S-cycle4-cloud-id-correctness` lands, describing behavior that doesn't exist yet | Prevented by this story's `depends_on` edge (Wave 2, after `S-cycle4-cloud-id-correctness`'s Wave-1 BCs are finalized) — see Anchor Justification |

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|---------------|
| N/A | N/A | Documentation is not executable code; there is no pure/effectful boundary to classify. This section is present per the story-template's mandatory-section rule, with an explicit N/A rather than an omission. |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|---------------|-----------------|
| This story spec | ~2,200 |
| `README.md` (current install/config sections, ~200 LOC) | ~2,500 |
| `CLAUDE.md`'s Windows path gotcha entry (for cross-check) | ~600 |
| `S-cycle4-cloud-id-correctness.md` (for the corrected `cloud_id` caveat text) | ~2,000 |
| **Total** | **~7,300** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~4%** |

Smallest story in the cycle by design — a scoped, three-section README edit with no
`src/` change.

## Tasks

1. [ ] Read `README.md`'s current Windows install section (`README.md:66-68`) and confirm
   it already states the stable-asset/`prerelease`-not-required language correctly (AC-001
   is a confirm-and-preserve regression guard, not a rewrite — verified already-fixed
   during F3 authoring)
2. [ ] Do NOT rewrite the install section's core language; only add AC-002's
   `Unblock-File` note adjacent to it, keeping the existing accurate text intact
3. [ ] Add the `Unblock-File` mark-of-the-web instruction (AC-002)
4. [ ] Add the per-platform config/cache path table, cross-checked against
   `CLAUDE.md`'s existing gotcha entry and `src/config.rs`/`src/cache.rs` (AC-003)
5. [ ] Read `S-cycle4-cloud-id-correctness.md`'s final acceptance criteria (once that
   story has landed, or its BC text is stable) and rewrite the `cloud_id` caveat to
   describe the corrected, both-flows-auto-discover state (AC-004)
6. [ ] Confirm no unrelated README content was touched (AC-005)
7. [ ] Add a CHANGELOG entry under `[Unreleased] > Changed` describing the README
   corrections, before creating the PR

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|--------------|---------------------|-------------------|
| `S-cycle4-cloud-id-correctness` | Defines the exact `cloud_id` fetch/override/soft-fail contract (BC-1.2.052/053) this story's AC-004 caveat text must match | N/A (docs story has no code pattern to inherit) | Do not write AC-004's caveat text from the F1 delta-analysis's speculative framing ("OAuth-only" limitation) — that framing describes the PRE-fix bug this cycle closes, not the shipped behavior; always read the actual landed BC/story text before finalizing this paragraph |
| `S-WIN-6` (earlier Windows-support cycle, pre-existing) | Targets `CLAUDE.md`'s `JR_CONFIG_DIR`/`JR_CACHE_DIR` doc-fallout entries, NOT `README.md` — zero file overlap with this story despite both being "Windows docs" stories | File-scope discipline: a story titled "docs fallout" for one cycle does not automatically cover every doc surface; always check `target_module`/File Structure Requirements before assuming coverage | F1 §0's "README still says planned" claim was ALREADY STALE by the time F3 authored this story (verified against the live `README.md`, not against F1's text) — a lesson for future F3 passes to re-verify F1's file-state claims against the actual current file, not just cite F1 verbatim, since F1 analysis and F3 story-writing can straddle intervening commits |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|-----------|
| Windows config/cache path table must match `src/config.rs`/`src/cache.rs`'s actual `#[cfg(windows)]` behavior, not a guess | CLAUDE.md "Windows config/cache paths (BC-6.1.014, BC-6.2.016)" | AC-003's cross-check task |
| `cloud_id` caveat describes CORRECTED (post-fix) behavior, not the pre-fix limitation | `S-cycle4-cloud-id-correctness` (BC-1.2.052/053) | AC-004 |
| No unrelated README sections touched | N/A (scope discipline) | AC-005; PR-diff review |

## Library & Framework Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| (none) | — | Documentation-only story; no library or framework dependency |

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `README.md` | MODIFY | Windows install steps (AC-001/AC-002), per-platform config/cache path table (AC-003), `cloud_id` auto-discovery caveat (AC-004) |
| `CHANGELOG.md` | MODIFY | `[Unreleased] > Changed` entry per Task 7 — this file is ALSO edited by `S-cycle4-dpapi-storage-fix` (Wave 1), `S-cycle4-cloud-id-correctness` (Wave 1), and `S-cycle4-honest-fail-message` (Wave 2, parallel); see `conflict-report.md` §1/§4 and `wave-schedule.md` §2/§3/§7a for the cross-story `[Unreleased]`-section hotspot analysis (F3 re-review Finding #1) — each story appends its OWN distinct bullet line, so this is a trivial append-collision, not a real conflict |

**Files NOT to touch:** anything under `src/`, `tests/`, `Cargo.toml`, `deny.toml` — this
story makes zero code changes.

## Out of Scope

- Any `src/` code change — this story is documentation-only.
- The Windows OAuth/DPAPI fix itself — `S-cycle4-dpapi-storage-fix` /
  `S-cycle4-honest-fail-message`.
- The `cloud_id` fetch implementation — `S-cycle4-cloud-id-correctness`.

## Dependency Analysis

**depends_on:** `["S-cycle4-cloud-id-correctness"]` — content-accuracy dependency for
AC-004 (see Anchor Justification). Not a file-overlap or compile dependency.

**blocks:** `[]` — terminal node.

## Story Points and Effort

**3 story points** (trivial/small). Breakdown:
- Install steps + `Unblock-File` note: 1 SP
- Config/cache path table: 1 SP
- `cloud_id` caveat rewrite (post-fix accuracy check): 1 SP

Risk: LOW — prose-only change to already-shipped, already-correct behavior (per F1 §9's
regression baseline); worst case is a documentation inaccuracy, not a functional
regression.
