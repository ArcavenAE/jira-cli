---
document_type: lessons-codification
rule_id: DRIFT-001
last_updated: 2026-05-09
status: active
producer: story-writer
related_story: S-3.06
mitigation: scripts/check-spec-counts.sh
---

# DRIFT-001: BC Heading vs Body Count Drift

## Pattern

During Phase 1d adversarial spec review, the same finding class recurred 4
times across passes P21, P22, P23, P24:

- Pass 21: H-044 + L2 — BC heading count mismatch
- Pass 23: reaffirms same pattern with different BC file
- Pass 24: BC-2.1.006 12 vs 13 discrepancy
- (Plus the original P21 instance)

Each instance involved a numeric count claim in a BC file's YAML frontmatter
(`definitional_count: N`) drifting from the actual `#### BC-` heading count
in the body. The same pattern affected `total_nfrs:` in `nfr-catalog.md` and
`total_holdouts:` in `holdout-scenarios.md`.

## Root Cause

Edits to a spec file that change the body BC heading count update either:
- (a) the frontmatter declaration, OR
- (b) the body content,

but rarely both atomically. The drift is invisible to git diff review (which
sees a coherent change in either file location), and only surfaces when
adversarial-pass token counters or the canonical-counts document are recomputed.

## Mitigation

`scripts/check-spec-counts.sh` (introduced in S-3.06) is a pre-merge bash
script that:

1. Walks each `bc-*.md` file in `.factory/specs/prd/`, counts `#### BC-`
   headings, compares to `definitional_count:` frontmatter. Mismatch → exit 1.
2. Walks `nfr-catalog.md`, counts `^| \*\*NFR-` table rows, compares to
   `total_nfrs:`. Mismatch → exit 1.
3. Walks `holdout-scenarios.md`, counts `^### H-` headings, compares to
   `total_holdouts:`. Mismatch → exit 1.
4. Exits 0 if all counts match.

## When to Run

Run `scripts/check-spec-counts.sh` from the repo root:

- After any adversarial pass that adds or removes a BC, NFR, or holdout.
- Before declaring spec convergence at any phase gate.
- Before merging any PR that touches `.factory/specs/prd/bc-*.md`,
  `nfr-catalog.md`, or `holdout-scenarios.md`.
- Optionally: as a `lefthook` pre-commit or pre-push hook (deferred — see
  story's Out of Scope).

## Escalation

If the script reports drift:

1. Identify the affected file(s) from script output.
2. Determine which side is correct: did a recent edit add/remove a heading
   without updating the count, or vice versa?
3. Fix the inconsistent side. Do NOT auto-fix via the script — the script
   intentionally reports only and does not modify content (auto-fix could
   mask the root cause).
4. Re-run the script to verify exit 0.

## Cross-Reference

- `CANONICAL-COUNTS.md` (`.factory/specs/prd/CANONICAL-COUNTS.md`, if present)
  is the source of truth for grand totals across all spec files.
  `check-spec-counts.sh` validates per-file consistency; it does NOT validate
  the canonical grand total. That's a separate (deferred) verification.
- `STATE.md` Drift Items table tracks DRIFT-NNN findings as they are
  identified during pipeline operation.
