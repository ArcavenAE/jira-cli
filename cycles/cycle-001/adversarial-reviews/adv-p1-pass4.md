# Adversarial Review — Phase 1d Pass 4

**Reviewer**: adversary (fresh-context)
**Date**: 2026-05-04
**Convergence trajectory**: 30 → 15 → 9 → 5 (linear decay continuing)

## §1: Findings — 5 (0 CRITICAL / 0 HIGH / 4 MEDIUM / 1 LOW)

**ADV-P4-001 [content-defect / mis-anchor] MEDIUM**
H-004 cites BC-1.6.046 (auth list table snapshot). Should be **BC-1.1.011** (auth refresh --no-input against unconfigured profile exits 64 naming "no URL configured").

**ADV-P4-002 [content-defect / mis-anchor] MEDIUM**
H-005 cites BC-6.1.002 (migration idempotency). Should be **BC-1.1.012** (malformed config TOML errors exit 78 + does NOT overwrite). Note: edge-case-catalog.md EC-AUTH-004 correctly cites BC-1.1.012 — direct contradiction with holdout.

**ADV-P4-003 [content-defect / mis-anchor] MEDIUM**
H-012 cites BC-1.6.044, BC-X.1.007. BC-X.1.007 is "send_raw preserves 404" — unrelated to scope-mismatch. Should be **BC-1.6.042** (primary) + **BC-X.3.005** (universal-error wrapper).

**ADV-P4-004 [content-defect / count-drift] MEDIUM**
Architecture README line 24: "26 architectural risks (12 R1-NEW + 14 broad-pass)". Authoritative risk-register.md: **27 total** (1C/7H/8M/11L). Pass 2 added R-H7 but README didn't propagate. Same README line 68: ADR-0007 "12+ sites" (should be 14 per Pass 3 fix).

**ADV-P4-005 [content-defect / count-drift] LOW**
nfr-catalog.md line 192-193: "FIX-IN-PHASE-3: 9 (1 CRITICAL, 5 HIGH, 0 MEDIUM, 3 LOW)". Counting from Summary Table: NFR-R-D (CRIT), 5 HIGH, NFR-R-C/NFR-O-L (2 MEDIUM), NFR-O-H (1 LOW) = 1+5+2+1 = 9. Per-severity decomposition wrong (says 0M/3L; should be 2M/1L).

## §2: Strengths

1. NFR catalog 42-row arithmetic verified consistent across 4 locations
2. MUST-FIX BC anchors fully consistent across 5 docs (all say 14 sites)
3. State machine BC anchors all resolve (SM-1..SM-5)

## §3: Routing

product-owner: ADV-P4-001/002/003 (holdout anchors), ADV-P4-005 (NFR routing arithmetic)
architect: ADV-P4-004 (architecture README count refresh)

## §4: Verdict — FINDINGS (5 substantive)

Trajectory 30→15→9→5. Linear decay. All findings small-blast-radius content defects.

## §5: Follow-ups

- Pass 5 should converge (or 1 more pass)
- Consider [process-gap]: automated holdout BC anchor lint would prevent recurring class

Phase 1d adversary Pass 4 complete.
