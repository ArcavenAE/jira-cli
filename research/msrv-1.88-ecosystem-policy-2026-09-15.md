---
document_type: research
date: 2026-09-15
topic: >-
  Ecosystem/policy context for the jr MSRV 1.85→1.88 decision — current Rust
  stable version, comparable-CLI MSRV posture, distribution-cost assessment,
  and the repo's own unfollowed MSRV policy statement. Companion to
  msrv-let-chains-comfy-table-2026-07-30.md, which covers the dependency-floor
  half of the decision; this note covers the "why 1.88 and not something
  higher/lower" and "is this an acceptable cost" half.
status: conclusive
confidence: medium
verification_method: >-
  Synthesis of human-supplied decision context (already researched this
  session prior to this note being written) plus direct repo-file citation
  checks (design-spec policy line, README badge, CHANGELOG history) performed
  by the architect agent during Phase F1 of cycle-013. This note does not
  re-run external web/Perplexity research — it persists the decision context
  the human explicitly stated as "already researched this session" so it is
  not lost to conversation-only scope, per the F1 task's own instruction
  (point 6: persist supporting research under .factory/research/).
sources:
  - Human-supplied F1 task context (2026-09-15 session), stated as
    already-researched prior to this F1 burst
  - docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md (direct repo read,
    this pass — confirms the stated policy text verbatim)
  - README.md (direct repo read, this pass — confirms current MSRV badge text)
  - CHANGELOG.md (direct repo read, this pass — confirms prior MSRV-correctness
    entry exists as a style precedent)
---

# Research note: MSRV 1.88 ecosystem/policy context (cycle-013)

## Purpose

`msrv-let-chains-comfy-table-2026-07-30.md` establishes the *dependency floor*:
nothing in `jr`'s graph requires more than 1.85 today, and if the `comfy-table`
pin is ever lifted, the honest floor becomes exactly 1.88 (not 1.86 or 1.87).
That answers "what is the minimum defensible bump," not "should we bump, and
why 1.88 specifically as a target rather than staying pinned at 1.85 forever."
This note captures that second half of the decision, as supplied and already
researched earlier in the same session that produced this F1 delta analysis,
so it persists as a citable artifact rather than living only in a prompt.

## Current Rust stable version

At the time of this analysis (2026-09-15), current Rust stable is **1.98**.
1.88 is therefore ten stable releases behind current — a real, but modest,
lag; not "bleeding edge," not "ancient."

## Comparable-CLI MSRV posture

Two widely-used Rust CLI tools with a similar profile to `jr` (single-binary,
cross-platform, Homebrew-distributed) were cited as MSRV-policy comparables:

- **gitui** — MSRV 1.88
- **zoxide** — MSRV 1.88
- **jj (Jujutsu)** — MSRV 1.89

`jr` targeting 1.88 places it in the same band as these comparables, not
ahead of or meaningfully behind the norm for this class of tool.

## Why 1.88 and not 1.86/1.87

Per the companion dependency-floor research doc: 1.86 and 1.87 unlock nothing
for `jr` specifically (no dependency's real floor sits in that window; the
`comfy-table` 7.2.2 break is bracketed strictly between 1.85 — fails — and
1.88 — succeeds, with 1.86/1.87 not independently measured but not implicated
by any evidence either). 1.88 is the first version that is simultaneously:
(a) sufficient to compile `comfy-table` 7.2.2+ and `wiremock` 0.6.x without
workarounds, and (b) the exact stabilization point for let-chains, which is
the one lint-convention exception the repo currently carries specifically
because of the 1.85 floor (`CLAUDE.md`'s "No let-chains" entry names its own
deletion condition as "when MSRV is raised to ≥1.88"). There is no
intermediate version that captures either benefit; 1.88 is the minimum
version that captures both.

## Distribution cost assessment

`jr` ships as a compiled binary (cargo install, Homebrew tap, GitHub Releases
per-platform artifacts) rather than as a library consumed by other crates'
`Cargo.toml`. For binary/Homebrew end users, the MSRV value is invisible —
they consume a pre-built artifact, never invoke `rustc` themselves. The cost
of a higher MSRV falls only on: (a) source-builders (`cargo install --locked`
from crates.io or git) who have not updated their local toolchain past 1.85,
and (b) the CI matrix itself. Given current stable is 1.98, a source-builder
without at least 1.88 available is already meaningfully behind upstream Rust
release cadence (Rust ships a new stable roughly every 6 weeks; 1.88→1.98 is
about 15 months of releases). This mirrors the existing CHANGELOG precedent
(`CHANGELOG.md` L1090-1091) that explicitly recorded "User impact: None for
binary users or source-builders on Rust ≥1.85.0" for the *previous*
MSRV-correctness fix — the same reasoning applies here, updated to the new
floor: user impact is none for binary consumers, and low for source-builders
already tracking anything resembling a recent toolchain.

## The unfollowed design-spec MSRV policy (flagged, not resolved here)

`docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md` §"MSRV Policy"
(confirmed by direct read this pass, line ~658) states:

> "Minimum Supported Rust Version: **1.85.0** (or latest stable minus 3
> releases). MSRV bumps increment the minor version. Tested in CI on every
> PR."

This policy has never actually been followed as a live mechanism. If it had
been, and current stable is 1.98, the "latest stable minus 3" clause would
imply an MSRV far higher than either 1.85 or the proposed 1.88 — the design
spec's own two clauses ("1.85.0" as a fixed floor vs. "latest stable minus 3"
as a rolling one) have been in tension since the document was written, and no
prior MSRV-adjacent change (including the S-626-1 CI-correctness fix
documented at length in CHANGELOG.md and `tests/ci_gate_completeness.rs`) has
reconciled it. This is flagged in the cycle-013 F1 delta-analysis report
(§3, §4, §7 Open Question 3) as a decision F2 should make explicitly rather
than defer again — this note does not resolve it, only documents that the
inconsistency is real, pre-existing, and independently confirmed by direct
file read (not merely restated from the human's summary).

## Confidence and limits

**Confidence: medium**, not high — unlike the companion dependency-floor
note (empirically measured via real toolchain compilation), the ecosystem
comparables (gitui/zoxide/jj MSRV values) and the "current stable is 1.98"
claim are carried forward from human-supplied context stated as
already-researched this session, not independently re-verified via
Perplexity/WebFetch by this agent during this F1 pass. If this note's
ecosystem claims need to appear in user-facing text (CHANGELOG, README) with
a citable source, re-verify gitui/zoxide/jj's current MSRV values and the
current Rust stable version number against their respective repositories at
implementation time (F2/F4), since both are point-in-time facts that drift.
The repo's own citation-discipline convention (CLAUDE.md: "Citation
discipline for external-tracker IDs in user-facing strings") applies by the
same logic to external-project MSRV claims, not just tracker IDs.
