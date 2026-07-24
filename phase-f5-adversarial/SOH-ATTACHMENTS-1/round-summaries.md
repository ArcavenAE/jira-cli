# F5 Scoped Adversarial Refinement — SOH-ATTACHMENTS-1
## Per-Round Summaries

**Bundle:** SOH-ATTACHMENTS-1 | **Criterion:** STRICT | **Converged:** 2026-07-24

---

| Round | Verdict | Counts | Finding IDs | Disposition |
|-------|---------|--------|-------------|-------------|
| **r1** | GAPS | 6L / 1C | F5-R1-001 (C, containment repair), F5-R1-002 (L, RFC3339 --newest parser), F5-R1-003 (L, deferred JSM echo envelope), F5-R1-004 (L, 404 parity), F5-R1-005 (L, quote guard), F5-R1-006 (L, NetworkError taxonomy); + 1L grouped | Fixed → PR #644 FIX-F5-006 @ c33ae7c3. F5-R1-003 deferred spec-level. |
| **r2** | GAPS | 2L / 1C | F5-R2-001 (C, backslash guard asymmetry), F5-R2-002 (L, rustdoc sync), F5-R2-003 (L) | Fixed → PR #646 FIX-F5-007 @ 31a3dfdb. |
| **r3** | GAPS | 1H / 2L | F5-R3-001 (H, BC-2.7.012 download-404 canonical-only restoration — root-caused to r1 over-reach on get_attachment_metadata), F5-R3-002 (L, containment canonicalization), F5-R3-003 (L) | Fixed → PR #647 FIX-F5-008 @ d28a19c5. Process observation (a) recorded. |
| **r4** | GAPS | 1L | F5-R4-001 (L, docstring accuracy) | Fixed → PR #648 FIX-F5-009 @ e0f44b98. |
| **r5** | GAPS | 1L / 1I | F5-R5-001 (L, research-backed disk-error taxonomy; classify_write_error 4 io sites; tmp-path leak; Windows P9-001), F5-R5-002 (I, ruling: dup-of-ledgered does not reset STRICT window) | Fixed → PR #649 FIX-F5-010 @ 81c637b9. Spec v1.3.102/103/104. Research: f5-r5-001-disk-error-taxonomy-2026-07-24.md. |
| **r6** | GAPS | 1L / 1I | F5-R6-001 (L, doc-fallout sync), F5-R6-002 (I) | Fixed → PR #650 FIX-F5-011 @ 58ef7104. |
| **r7** | GAPS | 2L / 1I | F5-R7-001 (L, EC-3.9.006-7 429 trip-wire pin), F5-R7-002 (L), F5-R7-003 (I) | Fixed → PR #651 FIX-F5-012 @ 58d3d079. Spec v1.3.105 (EC-3.9.006-7 deliberate 429 asymmetry). |
| **r8** | CLEAN* | 1L | F5-R8-001 (L, dup of ledgered P8-001) | Ruling: dup-of-ledgered; P8-001 already in ledger; ruling = clean. No fix round. STRICT window NOT reset per ruling. |
| **r9** | GAPS | 1L novel / 1I | F5-R9-001 (L, novel), F5-R9-002 (I, dup of P4-006) | F5-R9-001 fixed → included in context. F5-R9-002 excluded (dup). Ruling F5-R9-002 applied. |
| **r10** | CLEAN | 0 | F5-R10-001 (I, enhancement: JSM 401 scope-hint parity — not a defect) | No fix round. Enhancement candidate logged for backlog. |
| **r11** | GAPS | 1L novel | F5-R11-001 (L, dead single-mode branch removal + SEC-576-001 consolidation guard) | Fixed → PR #652 FIX-F5-013 @ db207b81. Spec v1.3.106 (EC-X.8.010-2 DOCUMENT-AS-IS). WAVE-576-05 CLOSED. |
| **r12** | CLEAN (1/3) | 0 | F5-R12-001 (L, dup of WAVE-576-05 → ruled clean after WAVE-576-05 discharged via EC-X.8.010-2) | Ruling F5-R12-001. No fix round. STRICT window opens 1/3. |
| **r13** | CLEAN (2/3) | 0 | 1I by-design (documented EC; adversary independently confirmed) | No fix round. STRICT window 2/3. |
| **r14** | CLEAN (3/3) | 0 | F5-R14-001 (I, typed sentinel for benign-404, enhancement), F5-R14-002 (I, documented), F5-R14-003 (I, cancel-message channel symmetry, enhancement) | No fix round. WINDOW COMPLETE — **CONVERGED STRICT** 2026-07-24. |

---

**Summary:** 14 rounds / 8 fix PRs (all human-merged per DEC-173). Window r12/r13/r14 CLEAN×3. Spec v1.3.99 → v1.3.106. BC-INDEX v6.38 → v6.44. BC count 657 unchanged. develop @ db207b81.
