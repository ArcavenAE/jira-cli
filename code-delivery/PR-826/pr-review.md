# Fresh-Eyes PR Review — PR #826

**Title:** chore(deps): allow temporary syn 2.x/3.x duplicate in deny.toml during syn-3 migration
**Branch:** `chore/deny-syn-skip-2026-09-16` @ 2acc5419 → `develop`
**Diff:** `deny.toml` ONLY, +10 / -0
**Reviewer model:** fresh-context, diff + description + CI only

## VERDICT: APPROVE (merge-ready pending human go-ahead)

> POSTING NOTE: This review was NOT posted to GitHub via `gh pr review`. The
> launching caller explicitly instructed "Do NOT merge, do NOT approve via gh,"
> and the PR body is flagged **DO NOT MERGE**. The formal GitHub verdict is
> therefore deferred to the human. Verdict was delivered to the caller directly.
> Neither `--approve` (would violate the caller's constraint) nor
> `--request-changes` (would be a false verdict — the assessment is APPROVE) is
> appropriate here, so no `gh pr review` was issued by design.

## Checklist assessment

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence (all changes relate to the stated purpose) | PASS |
| 2 | Description accuracy (body matches diff) | PASS |
| 3 | Test/verification coverage | PASS (CI Deny gate green) |
| 4 | Demo evidence | N/A (dependency-policy config change) |
| 5 | Commit quality (conventional format) | PASS (`chore(deps):`) |
| 6 | Diff size (<500 LOC) | PASS (10 lines) |
| 7 | Missing changes | None |
| 8 | Dependency status | N/A (this PR is itself the enabler for #729/#730/#688) |

## Findings against the five review foci

### 1. Correctness of the skip — PASS
Diff adds exactly two `[[bans.skip]]` entries — `syn` version `"2"` and `syn`
version `"3"` — and nothing else (purely additive, 0 deletions). Verified against
the current file:
- `[bans] multiple-versions = "deny"` (line 21) UNCHANGED — global ban not relaxed.
- `wildcards = "deny"` unchanged; `[advisories]`, `[licenses]`, `[sources]` untouched.
- No crate other than `syn` is skipped.
- Entry shape (`name`/`version`/`reason`) is byte-consistent with the ~30 existing
  skip blocks (thiserror, toml, serde_spanned, windows-sys, cpufeatures, winnow, …).
- Inserted in the file's alphabetical slot (serde_spanned < syn < thiserror).

### 2. Scoping — PASS
Both entries pin a specific major (`"2"`, `"3"`), not a bare unversioned skip. A
future `syn` 4.x would still correctly trip `multiple-versions = deny`. Matches the
file's universal convention that every skip carries an explicit version.

### 3. Documentation — PASS (exemplary)
Both `reason` strings are self-documenting and reversible:
- **WHY:** names the three syn-2 upstream holdouts with dates/paths —
  `pear_codegen 0.2.9` + `proc-macro2-diagnostics 0.10.1` (via figment's optional
  `pear` feature; figment 0.10.19 is already the ceiling) and
  `tracing-attributes 0.1.31` (via tracing 0.1.44, its latest). The syn-3 side names
  the crates that already migrated (clap_derive, futures-macro, serde_derive,
  thiserror-impl).
- **REMOVAL TRIGGER:** concrete and testable — "once `cargo tree -i syn` (after
  `cargo update`) shows only one syn version, delete BOTH skip entries together,
  then confirm `cargo deny check bans` passes with no unmatched-skip/unnecessary-skip
  warnings before landing the removal." Entries cross-reference each other so neither
  is orphaned.

### 4. CI — PASS on the load-bearing check
`Deny (licenses + vulnerabilities)` = **pass** (authoritative for this change). Also
green: Clippy (ubuntu), Format, MSRV 1.88.0, Mutation Test Plan, Secret Scan,
Spec Guards, dependency-review, Signing Workflow Injection Guard. Remaining checks
(Coverage, Test matrix ubuntu/macos/windows, Clippy windows, 8 Mutation shards) were
`pending` at review time — none failed; expected to pass given zero source impact.
As disclosed in the PR test plan and confirmed by the green Deny job, the pre-emptive
skips currently emit benign warnings (syn "2" → `unnecessary-skip` since only one syn
version is on develop today; syn "3" → `unmatched-skip` since syn 3 isn't in the tree
yet) — warnings, not errors, the same class as the pre-existing tolerated
`cpufeatures = ^0.2` unmatched-skip already in the file.

### 5. Risk — LOW; sound, reversible, precedent-following
Documented policy exception, not a policy weakening. Follows the established "skip
with reason + removal trigger" idiom. Deliberately pre-emptive (landed before the
Dependabot bumps rebase on top of it) — a defensible sequencing choice, transparently
disclosed. Version-scoped, single-crate, no global-policy change.

## Non-blocking nits (no changes required)
- Block header comment (line 25) still reads "Unavoidable duplicate crate versions
  as of 2026-05-07," now stale — but consistent with later entries (cpufeatures
  D-185, windows-sys ADR-0021) that also postdate it; each new `reason` carries its
  own inline date.
- `syn = "2"` will surface an `unnecessary-skip` warning on develop until the
  Dependabot bumps introduce syn 3. Expected, documented, self-resolving.

## Bottom line
Minimal, correct, well-scoped, exemplarily documented with a concrete removal
trigger, precedent-following; critical Deny CI gate green. Recommend the human
confirm remaining pending checks finish green (expected) before merge. The PR's
explicit DO NOT MERGE flag is honored — no approve/merge issued.
