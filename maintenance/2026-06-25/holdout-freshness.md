---
# Holdout Freshness — Maintenance Sweep 2026-06-25

**Verdict: NEEDS-REVISION.** 3 stale scenarios, 7 coverage gaps (2 NEW shipped areas). Coverage ratio ≈0.61 vs 0.8 threshold — BELOW. Owner: product-owner.

## Stale scenarios (3)
- **H-NEW-MP-001** (carry-forward): Action line uses `--story-points 5` → clap `error: unexpected argument`, exit 2. Only `--points` parses. Fix: `--story-points`→`--points` (~line 480).
- **H-028** (NEW — regression introduced by H-019 fix #548): hand-edited `[profiles."foo:bar"]` + `jr auth list` now returns exit 0 with empty table (invalid key silently filtered), NOT expected exit 64 + stderr `invalid profile name "foo:bar"`. Config-key validation no longer fires on the listing path. `auth switch "foo:bar"` does reject (exit 64). Re-point H-028 to a command that resolves the active profile, or relax expectation.
- **H-007** (mechanism, carry-forward): ADR-0015/BC-3.2.013 proactive pre-POST interception. Re-point to BC-3.2.013 primary, BC-3.2.009 fallback.

**Resolved since prior sweep:** H-019 FIXED (PR #548 — flag/env `foo:bar` → exit 64). H-027 soft prose-only, not re-counted.

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
H-019 STALE→FIXED. H-028 PASS→STALE (NEW regression from #548). H-NEW-MP-001/H-007 still open. Coverage gaps 6→7 (+SEC-001 ADF recursion). Stale 4→3.

## Recommended owner: product-owner
