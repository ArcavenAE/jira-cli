---
document_type: spec-delta
story_id: S-MUTANTS-SCOPE-1
phase: F2
date: 2026-08-14
author: product-owner
new_bcs: []
amended_bcs:
  - BC-X.3.006
new_vps:
  - VP-MUTANTS-SCOPE-1-001
  - VP-MUTANTS-SCOPE-1-002
related_files:
  - .factory/phase-f1-delta-analysis/S-MUTANTS-SCOPE-1-delta-analysis.md
  - .factory/research/S-MUTANTS-SCOPE-1-ctrl-c-mutation-testing.md
---

# Phase F2 Spec Evolution — S-MUTANTS-SCOPE-1

Companion to the F1 delta analysis. This is a **delta-only** spec update — no
rewrite of unaffected sections. Zero `src/` production files touched.

## 1. Summary of decisions

| Question | Decision |
|---|---|
| Create a new BC for the `examine_globs` scope gap itself? | **NO.** F1 already established no BC governs `examine_globs` membership (`docs/specs/cargo-mutants-policy.md` is the governing artifact and explicitly disclaims prescriptiveness on membership). Confirmed at F2: no new/changed spec needed for that half of the story. |
| Create a new BC for the Ctrl+C/SIGINT interrupt behavior the new tests will pin? | **NO — a governing BC already existed.** `BC-X.3.006` in `cross-cutting.md` ("Ctrl+C exits 130 with `Interrupted` handling") was found by grep for `sigint\|ctrl.?c\|130\|interrupt` across `.factory/specs/prd/`. It was a thin, semport-extracted stub (Confidence MEDIUM; only title/Confidence/Source/Trace; stale `src/main.rs:~264` citation; no Behavior, no Edge Cases, no Verification Properties). **Amended in place** rather than superseded/replaced, per the append-only-numbering + H1-title-authority conventions (the ID persists; the body gains detail). |
| Does the amended test approach reveal an underspecified detail? | **YES, two.** (1) The stub never stated the *exact* stderr bytes — only "`Interrupted` handling." The adopted test asserts `stderr == "\nInterrupted\n"` byte-exact, so the BC now states that exact string explicitly (derived directly from `eprintln!("\nInterrupted")`'s known behavior — `eprintln!` appends its own `\n`). (2) The stub's `Source` citation (`src/main.rs:~264`) was stale — the actual `tokio::select!` block is at `src/main.rs:415-422` today (confirmed by direct read); corrected to `~415`. |
| Create a VP (verification property)? | **YES — two, inlined in the BC body** (this repo's established convention per `verification-delta-571.md`'s "Registration surface" note: VPs are recorded inline in a BC's `**Verification Properties**:` subsection; there is no separate VP-INDEX/VP-registry in this project). `VP-MUTANTS-SCOPE-1-001` (the load-bearing `#[cfg(unix)]` out-of-process SIGINT subprocess test — the only shape that can kill the `130`-literal and `eprintln!`-deletion mutants) and `VP-MUTANTS-SCOPE-1-002` (the portable `run_until_shutdown` arm-selection unit test — cross-platform, catches arm-swap mutants, cannot substitute for VP-001). Both are direct restatements of the research doc's Task 4 recommendation, now given VP IDs and anchored into the BC so F4's test-writer has a locked contract instead of a research memo to trace to. |
| Is the `docs/specs/cargo-mutants-policy.md` §Scope edit part of F2? | **NO.** Confirmed out of scope here per F1 §9 ("F2 (spec evolution): none required beyond the doc edit already scoped in §3/§4"). That edit (2 new bullets + count 16→18) is tracked as an **F4 implementation artifact** — not touched by this F2 burst. Same for `.cargo/mutants.toml::examine_globs` itself. |

## 2. BC amendment — BC-X.3.006

**File**: `.factory/specs/prd/cross-cutting.md` (§X.3 Error Handling)

Promoted in place from a thin stub to a fully-specified BC:

- New title: "Ctrl+C during a running command exits 130 with stderr
  `"\nInterrupted\n"` — `tokio::select!` graceful-shutdown race between the
  in-flight command and `tokio::signal::ctrl_c()`" (H1 is now descriptive and
  precise, per this project's H1-title-authority convention — the old title
  "Ctrl+C exits 130 with `Interrupted` handling" undersold the actual
  contract).
- Added `**STATUS: UPDATED (2026-08-14, S-MUTANTS-SCOPE-1)**` marker.
- Confidence MEDIUM → HIGH (re-verified directly against current `src/main.rs`
  source, not re-derived from a stale semport extraction).
- Source citation corrected: `src/main.rs:~264` → `src/main.rs::run` — the
  `tokio::select!` block near `src/main.rs:~415` (verified via direct
  `grep -n` against the current file; the guard tool `validate-stable-anchors`
  enforces the `~NN` approximate-citation form over a bare `NNN-MM` range for
  non-Amendment sections, per TD-031 — both new citations use the compliant
  `~NN` form).
- Added `**Subject**`, `**Behavior**` (full two-arm race description, exact
  byte contract, no-cleanup-between-steps note), and a documented,
  not-a-defect race-condition paragraph covering the `ctrl_c()`
  first-poll registration window.
- Added three edge cases: EC-1 (registration race — falls through to OS
  default disposition, exit code NOT 130 in that narrow window — documented
  limitation, not fixed by this story), EC-2 (SIGINT after `main_task` already
  won — unreachable), EC-3 (`--output json` invocations still get the plain
  interrupt text, never the JSON error envelope — pre-existing, intentional
  asymmetry with BC-7.3.010).
- Added `**Verification Properties**:` subsection (VP-MUTANTS-SCOPE-1-001,
  VP-MUTANTS-SCOPE-1-002 — see §3 below) plus an explicit note that
  `#[mutants::skip]` is rejected for this block, citing
  `docs/specs/cargo-mutants-policy.md` §Whitelist Convention's "hard to test"
  / "tests don't cover this" invalid-justification list verbatim.
- Retained the previous (pre-amendment) version inline in a blockquote for
  audit trail, matching the format established by BC-1.2.018's 2026-08-13
  amendment.
- Added a `Version | Date | Author | Change` changelog table (new convention
  for this specific BC; several other BCs in `bc-7-output-render.md` already
  use this table — this is the first such table in `cross-cutting.md`, but
  the format is copied directly from the `bc-7` precedent, not invented).

**Not added**: a "Capability Anchor Justification" row. Grepped
`.factory/specs/prd/*.md` for the literal string "Capability Anchor
Justification" — zero hits anywhere in this project's specs. This repo's BCs
(semport-extracted, code-first) do not use CAP-NNN capability anchors at all;
introducing that field on a single BC would be a new, one-off convention
inconsistent with the other 660 BCs in this index. Deferred to a human/
orchestrator decision if this project ever adopts that convention repo-wide.

## 3. New Verification Properties

Both inlined in BC-X.3.006's `**Verification Properties**:` subsection (see
`cross-cutting.md` for full text — not duplicated here per this project's
"registration surface" convention, which keeps VPs in the BC body as the
single source of truth rather than a separate index).

- **VP-MUTANTS-SCOPE-1-001** — `#[cfg(unix)]` out-of-process SIGINT
  subprocess test. Spawns the compiled `jr` binary, uses a deterministic
  readiness handshake (not a fixed sleep, to avoid the EC-1 registration
  race), sends `SIGINT` via `libc::kill` (no new dependency — `libc 0.2.183`
  already resolved in `Cargo.lock`), asserts real exit code `130` and real
  stderr `"\nInterrupted\n"` byte-exact. Load-bearing: the only test shape
  that can kill the `130`-literal-substitution and `eprintln!`-deletion
  mutants.
- **VP-MUTANTS-SCOPE-1-002** — portable `#[tokio::test]` against a new,
  behavior-preserving `run_until_shutdown(work, shutdown)` extraction of the
  `select!`'s decision logic, injecting `std::future::ready(())` for
  `shutdown` and `std::future::pending::<()>()` for `work`, asserting the
  shutdown arm is selected. Cross-platform (no signal delivery). Does NOT
  replace VP-MUTANTS-SCOPE-1-001 — cannot observe `process::exit` or a
  sibling process's stderr.

Both VPs are direct formalizations of the Task 4 recommendation in
`.factory/research/S-MUTANTS-SCOPE-1-ctrl-c-mutation-testing.md` — no new
research was needed at F2; this step gives the research's recommendation a
BC-anchored, VP-numbered identity so F3/F4 trace to a spec artifact instead of
a research memo.

## 4. Drift fix (discovered incidentally, fixed in the same change)

While confirming BC-X.3.006 was the correct governing BC, found that
`.factory/specs/prd/edge-case-catalog.md`'s **EC-HTTP-005** ("Ctrl+C during
API call — graceful exit 130") cited `"Covered by BC-X.1.009"` —
**BC-X.1.009 is a different, unrelated BC** ("429-exhausted warning always
emitted to stderr (not verbose-gated)", `src/api/client.rs`). This is a
pre-existing citation-drift defect, not something introduced by this story.
Corrected the citation to BC-X.3.006 in the same change (directly adjacent to
the BC I was already amending; in scope, not scope creep) and bumped the
confidence label to match BC-X.3.006's new HIGH confidence.

## 5. Files changed (all `.factory/specs/prd/` — zero `src/`, zero
   `.cargo/`, zero `docs/specs/cargo-mutants-policy.md`)

| File | Change |
|---|---|
| `.factory/specs/prd/cross-cutting.md` | BC-X.3.006 body amended in place (§2 above); frontmatter `trace:`/`last_updated` updated. No count change (85 individually-bodied / 151 cumulative, unchanged). |
| `.factory/specs/prd/BC-INDEX.md` | §X.3 row updated (summary/source/confidence/`[AMENDED]` tag); frontmatter `total_bcs` narrative + `last_updated` + `index_version` (v6.77→v6.78) updated. No count change (661 total, unchanged). |
| `.factory/specs/prd/edge-case-catalog.md` | EC-HTTP-005 citation fixed (§4 above); frontmatter `trace:`/`last_updated` updated. |
| `.factory/spec-changelog.md` | New entry `[1.3.181] - 2026-08-14`, Type: PATCH (no new BC minted — amendment only, per this repo's Type legend). |

**Verification run**: `scripts/check-bc-cumulative-counts.sh` (exit 0, "661
total across 8 files"), `scripts/check-spec-counts.sh` (exit 0, "7 bc files
validated"), `scripts/check-bc-citation-symbols.sh` (exit 0, "376 citations
checked") — all green after the edits, confirming no count or citation drift
was introduced.

## 6. Explicitly NOT done in F2 (tracked forward)

- `.cargo/mutants.toml::examine_globs` — the actual two-entry addition. **F4.**
- `docs/specs/cargo-mutants-policy.md` §Scope — two new bullets + count line
  16→18. **F4 implementation artifact**, confirmed by F1 §9 and this task's
  own instructions; not a spec-evolution change.
- No architecture delta (F1 confirmed zero structural architecture impact —
  pure CI-scope + spec-doc change).
- No new holdout scenarios (this story doesn't introduce new user-facing
  behavior; it adds verification coverage of existing, documented behavior).
- No adversarial spec review dispatched by this agent — that is the
  orchestrator's Step 6, sequenced after this delta is delivered.

## 7. Open item carried forward to F3/F6 (unchanged from F1, restated for
   continuity)

F1 §5/§6 flagged the `main.rs` kill-rate risk as the single highest-attention
item in the story: even with VP-MUTANTS-SCOPE-1-001/002 landed, other
branches in `main.rs` (init_tracing's level selection, the InvalidSubcommand
intercept, etc.) may still produce a handful of additional first-run
survivors below the 90% floor, to be triaged in F6 per the Deferral Policy.
That triage is downstream of this F2 spec change and does not block it.
