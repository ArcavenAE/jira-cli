---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-15T00:00:00
phase: f2
inputs: [.factory/specs/prd/bc-8-components.md, .factory/phase-f2-spec-evolution/prd-delta-components.md, .factory/specs/prd/BC-INDEX.md, .factory/phase-f2-spec-evolution/verification-delta-components.md]
input-hash: "1659046"
traces_to: .factory/phase-f2-spec-evolution/prd-delta-components.md
pass: 8
previous_review: .factory/phase-f2-spec-evolution/adversarial-spec-delta-review-components-p7.md
---

# Adversarial Review: Component Management Bundle (Pass 8)

Adversarial Spec-Delta Review — Component Management (F2, pass 8). VERDICT: NOT CLEAN. 0 CRIT,
0 HIGH, 1 MEDIUM, 1 LOW, 3 INFO. (Documentation-surface drift only; no behavioral
contradictions — P7 message-deferral + VP-027/028 internally consistent.)

## Finding ID Convention

Finding IDs use the format: `ADV-P8-<SEV>-<SEQ>` (no cycle prefix — no `.factory/current-cycle`
file present for this bundle at review time).

## Part A — Fix Verification (pass >= 2)

| ID | Previous Severity | Status | Notes |
|----|-------------------|--------|-------|
| ADV-P7-MED-001 (BC-8.1.008 message divergence) | MEDIUM | RESOLVED | Branch (0) added, defers to BC-8.4.002/003 verbatim |
| ADV-P7-MED-002 (prd-delta BC-8.1.004 scope wording) | MEDIUM | RESOLVED | L53/L164 corrected list/edit/delete + per-subcommand rows |
| ADV-P7-MED-003 (VP-COMPONENT-027/028 missing) | MEDIUM | RESOLVED | Both VPs minted and cited in BC bodies (see this pass's LOW-1 for the residual handoff-note gap) |
| ADV-P7-LOW-001 (BC-8.3.002/004 discovery-order EC) | LOW | RESOLVED | EC-8.3.002-4 / EC-8.3.004-2 added |

## Part B — New Findings

### MEDIUM

#### ADV-P8-MED-001: BC-8.1.008 H1 omits `rename` despite body/Trace/prd-delta all including it

- **Severity:** MEDIUM
- **Category:** spec-fidelity
- **Location:** `.factory/specs/prd/bc-8-components.md` BC-8.1.008 H1 (~L575) vs body (~L582-583),
  branch (2) (~L610), Trace (~L691); `prd-delta-components.md` summary (L57) and taxonomy (L166)
- **Description:** The H1 reads "Unknown component `NAME|ID` on `edit`/`delete` → exit 64…" but
  the BC's own body text, its numeric branch (2) (which explicitly cites BC-8.3.001 M1's
  confirming-GET on `rename`), its Trace field, and both `prd-delta-components.md` surfaces
  (summary row L57: "edit/delete/rename"; taxonomy L166) all state the taxonomy this BC defines
  also covers `rename`. This BC is the definitional owner of `rename`'s numeric-`OLD` not-found
  taxonomy (branch (2), via BC-8.3.001 M1). The H1 is the sole outlier among four corroborating
  surfaces.
- **Evidence:** H1 (L575): "on `edit`/`delete`" — omits `rename`. Body (L582-583): "The `NAME|ID`
  positional on `edit`/`delete` (and the `OLD` positional on `rename`, see §8.3) is resolved via
  §8.4…". Branch (2) (~L610-611): "BC-8.1.007 M1 on `edit`, BC-8.2.002 M1 on `delete`,
  BC-8.3.001 M1 on `rename`". Trace (~L691): cites BC-8.3.001 M1 as a caller. `prd-delta` L57:
  "Unknown `NAME\|ID` on edit/delete/rename → exit 64". `BC-INDEX.md` L649 (sourced from the
  prd-delta row) already reads "edit/delete/rename" — so BC-INDEX is in sync with everything
  except this BC's own H1.
- **Proposed Fix:** Extend the H1 to "on `edit`/`delete`/`rename`" so the title matches the body,
  branch (2), Trace, prd-delta, and BC-INDEX. No content/behavioral change — title-only.

### LOW

#### ADV-P8-LOW-001: prd-delta VP-range handoff note stale — omits VP-027/028 minted in P7

- **Severity:** LOW
- **Category:** verification-gaps
- **Location:** `prd-delta-components.md` Anchor-Back / Handoff Notes, VP citations bullet
  (~L267-283)
- **Description:** The handoff note states the VP range as "VP-COMPONENT-001..026" and enumerates
  additions only through VP-025/026, but VP-COMPONENT-027 (BC-3.4.020 FIX-F5-001 `--label`+
  `--component` silent-data-loss guard) and VP-COMPONENT-028 (BC-3.4.021 dry-run
  `plannedChanges.components` shape) were minted in the pass-7 fix-burst (see
  `adversarial-spec-delta-review-components-p7.md` MEDIUM-3 resolution) and cited inline in
  their respective BC bodies, but this handoff note was never updated to match. The
  authoritative `verification-delta-components.md` §0.1 already correctly lists 001..028, and
  the BC bodies themselves carry the correct citations — this is a single stale note, not a
  spec-content defect. Left as-is, the architect's VP-INDEX registration pass (which this note
  drives) would under-register two VPs.
- **Evidence:** `prd-delta-components.md` L268: "VP-COMPONENT-001..026 **[CORRECTED
  2026-08-15, L2 fix-burst — range was stale at 001..024]**…" — range not further extended
  despite VP-027/028 existing since P7. The "VP citation changes" list (L279-281) enumerates
  BC-8.4.001, BC-8.4.005, BC-8.1.005/BC-8.1.007/BC-8.2.008 but omits BC-3.4.020/BC-3.4.021.
- **Proposed Fix:** Update the range to "001..028" and add VP-027 (BC-3.4.020) and VP-028
  (BC-3.4.021) to the VP-citation-changes list, so the architect's VP-INDEX registration note is
  complete.

### INFO

#### ADV-P8-INFO-001: ADR-0018 current

All 4 numeric confirming-GET paths + cache derivation + snapshot ORDER BY + wire shapes are
covered — prior deferred staleness resolved.

#### ADV-P8-INFO-002: `Component.id` typing coherent

Embedded `Option<String>`, full-resource `String`, bulk `u64` parse (M2-corrected citation) —
no drift found.

#### ADV-P8-INFO-003: `--component` echo/preview surfaces consistent

The 3-string-surfaces + 1-array-surface split is deliberate and consistent; reserved-syntax
collisions are documented.

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 1 |
| LOW | 1 |
| INFO | 3 |

**Overall Assessment:** pass-with-findings
**Convergence:** findings remain — iterate
**Readiness:** requires revision (documentation-surface only; title/reference wording, no
behavioral defect)

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 8 |
| **New findings** | 2 (MEDIUM-1, LOW-1) |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 2 / (2 + 0) = 1.0 (both residues are one-surface doc fixes; no behavioral defect — novelty rated LOW in substance despite the raw score, per the qualitative note below) |
| **Median severity** | 2.5 (MEDIUM=3, LOW=2, average of the two substantive findings) |
| **Trajectory** | P7: 3 MED + 1 LOW → P8: 1 MED + 1 LOW |
| **Verdict** | FINDINGS_REMAIN (both trivially fixable in this same burst; expect CONVERGENCE_REACHED at pass 9) |

Novelty LOW — both residues are one-surface doc fixes, no behavioral defect.
