---
document_type: adversarial-review
issue: "#327"
pass: 4
date: "2026-05-26"
phase: F5
verdict: CLEAN
findings_count: 0
findings_observations: 1
adversary_tool_profile: read-only (no Bash, no Write; captured tool outputs accepted as ground truth)
convergence_pass: 3-of-3 (combined with passes 2 and 3)
---

# Adversarial Review — Issue #327 F5, Pass 4

## Adversary scope honesty disclosure

Read-only profile. Accepted orchestrator's captured tool outputs as ground
truth. Read passes 1-3 ONLY at the end of analysis to confirm no
duplication.

## Re-derived correctness checks (independently performed)

- `Cargo.toml:34` — `rand = "0.10"` matches rand 0.10 default feature set;
  `sys_rng` included → `rand::rngs::SysRng` available.
- `src/api/auth.rs:1094` — `use rand::TryRng;` resolves at crate root in
  0.10.
- `src/api/auth.rs:1096` — `rand::rngs::SysRng.try_fill_bytes(&mut bytes)`
  documented usage; `SysRng: TryRng<Error = SysError>`; `SysError` satisfies
  `anyhow::Context` bounds.
- `src/api/auth.rs:1101-1105` — 32 bytes × `{b:02x}` = 64 lowercase hex
  chars; `String::with_capacity(64)` exactly. Discarded `Result` from
  `write!` sound (`fmt::Write for String` infallible).
- Three pinned tests at `src/api/auth.rs:1184-1223` exercise type-name-
  agnostic assertions. 8/8 distinctness with birthday-bound ≈ 2⁻²⁵³.
- `grep -rn 'OsRng\|TryRngCore' src/ tests/ Cargo.toml` → 0 matches. AC-7
  satisfied.
- BC H1 ↔ BC-INDEX title sync invariant holds (`SysRng` on both).
- All 7 spec sites updated; residual `OsRng` only in semport historical
  snapshots (explicitly preserved).
- No `#[allow]` introduced.

## Findings

- 0 CRITICAL
- 0 HIGH
- 0 MEDIUM

## Observations (non-blocking)

### OBS-327-P4-001 [content-defect] — Story AC-5 antecedent describes a path NOT taken

**Severity:** LOW (Observation — story-spec content drift, no functional impact)
**Confidence:** HIGH
**Tag:** [content-defect]

`/Users/zious/Documents/GITHUB/jira-cli/.factory/stories/S-327-rand-0.10-migration.md`
AC-5 (lines 138-150) reads: "After adding `[[bans.skip]]` entries for the dual
`rand` presence: ... `cargo deny check` exits 0 after all necessary skip
entries are added."

The terminal-condition gate is satisfied (cargo deny check exit 0). But the
antecedent is contradicted by the implementation: zero skip entries were
added. The path taken was the empirical-green alternative documented in
`deny.toml:58-69` (13-line comment block explaining cargo-deny correctly
excludes rand 0.9.4 from the multiple-versions check because it's only in
the lockfile as a placeholder for proptest transitives + cross-platform
feature combos that don't activate under the current build target).

The story spec was not updated to reflect the chosen path.

**Why this is novel relative to passes 1-3:** Pass-1's F-327-P1-001 was the
substantive implementation question (resolved false-positive). Pass-2's
OBS-327-P2-001 was about the deny.toml comment block's accuracy. Pass-3's
OBS-327-P3-001 was about F5 tooling. None asked: now that the empirical-
green path was adopted, why does AC-5 still narrate the F1-anticipated
skip-entry path?

**Why LOW (non-blocking):**

- Gate condition is unambiguous and satisfied.
- `deny.toml:58-69` comment is the operative document for future maintainers.
- Story is a point-in-time artifact; amending retroactively is documentation
  hygiene, not correctness.
- F7 PR description / CHANGELOG can carry the clarification.

**Recommended (optional) action:** Either (a) amend AC-5's narrative on a
followup pass, or (b) leave the story as point-in-time and rely on
`deny.toml`'s comment block + pass-1's resolution record as the operative
documentation. Neither is blocking.

## Novelty assessment

**LOW — single observation, non-blocking.** Pass-1 exhausted the deny.toml/
skip-entry question. Pass-2 covered comment-block + rustdoc precision.
Pass-3 covered F5 tooling. Pass-4 surfaces the spec-vs-implementation
antecedent mismatch in story AC-5, which is content-drift (not
contradiction), below blocking threshold. Anchoring invariants (BC ID, BC
title, BC-INDEX row, spec-source paths) all hold.

## Verdict

**CLEAN.** 3rd consecutive CLEAN F5 pass.

**F5 CONVERGENCE ACHIEVED** — combined verdict across passes 2, 3, and 4:
the migration is mechanically correct, behaviorally preserved, spec-aligned,
and convention-compliant. The single LOW observation is non-blocking and
documents minor content-drift in story AC-5's narrative; operational gate
(`cargo deny check` exit 0) is satisfied; `deny.toml:58-69` comment block
is the load-bearing forward-documentation.

Eligible for F6 (Targeted Hardening).
