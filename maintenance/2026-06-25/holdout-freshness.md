---
# Holdout Freshness — Maintenance Sweep 2026-06-25

**Verdict: NEEDS-REVISION.** 2 stale scenarios, 7 coverage gaps (2 NEW shipped areas). Coverage ratio ≈0.61 vs 0.8 threshold — BELOW. Owner: product-owner.

## Stale scenarios (2)
- **H-NEW-MP-001** (carry-forward): Action line uses `--story-points 5` → clap `error: unexpected argument`, exit 2. Only `--points` parses. Fix: `--story-points`→`--points` (~line 480).
- **H-007** (mechanism, carry-forward): ADR-0015/BC-3.2.013 proactive pre-POST interception. Re-point to BC-3.2.013 primary, BC-3.2.009 fallback.

**H-028 — FALSE POSITIVE (2026-06-25 investigation).** Verdict B: `jr auth list` already exits 64 on `[profiles."foo:bar"]` — the sweep's "exit 0 + empty table" observation could not be reproduced. No regression; no code change. See `maintenance/2026-06-25/H-028-root-cause.md`.

**Resolved since prior sweep:** H-019 FIXED (PR #548 — flag/env `foo:bar` → exit 64). H-027 soft prose-only, not re-counted. H-028 INVESTIGATED → FALSE POSITIVE (verdict B).

## Coverage gaps (7)
- ADF markdown→ADF wave (#471/#472/#474/#483/#489/#492/#522/#473) — 257 unit tests, ZERO black-box holdout — HIGH.
- SEC-001 ADF recursion-depth guard (BC-7.2.012, CWE-674, #553) — NEW since 2026-06-22; ZERO holdout (black-box exit-64-on-deep-nesting pin missing) — HIGH (security).
- `issue edit` (--field/--type/--label/--dry-run, single/bulk routing #446/#331, #398 echo asymmetry) — ZERO — HIGH.
- Bulk operations (transition/field/label, nested wire schema FIX-BULK-TRANSITION-001) — ZERO — MEDIUM-HIGH.
- `issue changelog` — ZERO — LOW-MEDIUM.
- `worklog add` (duration parsing) — ZERO (only worklog list via H-045) — LOW-MEDIUM.
- `issue link/unlink/link-types`, `queue list/view`, `board view` — ZERO/partial — LOW.

## Coverage ratio
60 holdouts on disk; ~18 distinct shipped feature areas; ~11 with ≥1 black-box holdout; 7 with ZERO. Estimated ratio ≈ 0.61, BELOW 0.8 threshold. The two HIGH ADF gaps dominate.

## Delta vs prior (2026-06-22)
H-019 STALE→FIXED. H-028 initially flagged PASS→STALE but investigated 2026-06-25 and confirmed FALSE POSITIVE — stale count corrected from 3→2 (H-028 is NOT a real new stale). H-NEW-MP-001/H-007 still open. Coverage gaps 6→7 (+SEC-001 ADF recursion). Stale 4→3→**2** (H-028 false positive removed).

**Note:** coverage ratio estimate (≈0.61) is unaffected by this correction — the 7 coverage gaps are independent of H-028 and unchanged.

## Recommended owner: product-owner
