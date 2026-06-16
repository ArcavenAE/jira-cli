# Issue #492 — F2 Spec Convergence Record

**BC:** BC-7.2.011 (block-HTML → ADF hardBreak interior-newline mapping)
**Spec version trail:** v1.2.0 → v1.9.1
**Commit (frozen):** factory-artifacts @ 634cb88
**Date converged:** 2026-06-16
**DEC:** DEC-106

---

## Version Trail

| Version | Key change |
|---------|------------|
| v1.2.0 | Initial post-F1 spec; Algorithm A (raw-join) still present; vague round-trip claim |
| ~v1.4 | Algorithm disambiguation pass; A vs B distinction clarified |
| ~v1.6 | CRLF split double-count finding resolved; step-3 CR-normalize added |
| ~v1.7 | Byte-identity annotation set introduced; FRESH-02 reverse-trim_end overclaim caught and corrected |
| ~v1.8 | FRESH-04 forward trailing-newline overclaim caught; 5-condition exhaustive enumeration |
| v1.9.1 | Full 7-step Algorithm B; 6-EC fully annotated; 5-condition byte-identity claim confirmed exhaustive; CLEAN final pass |

---

## Substantive Findings Burned Down (~12 fresh-context adversarial passes)

| Severity | Finding | Resolution |
|----------|---------|------------|
| CRITICAL | Algorithm A→B ambiguity — spec described both raw-join (A) and split (B) simultaneously | Resolved: Algorithm B (normalize-then-split with hardBreak) made canonical; Algorithm A removed |
| HIGH | Impossible href autolink example — example URL cited in spec was unreachable/incorrect | Corrected example |
| HIGH | CRLF split double-count — step splitting on `\r\n` then `\n` would double-count `\r\n` boundaries | Resolved: step-3 CR-normalize (`\r\n` → `\n`) added before split |
| MED | Count-prose drift — EC count in prose didn't match annotated EC table | Synchronized: 6 ECs throughout |
| MED | **FRESH-02 (highest-value):** Byte-identity reverse-path trim_end overclaim — spec claimed `adf_to_text` trim_end was a byte-identity mechanism for the round-trip; it isn't (trim_end removes trailing whitespace, not just the leading trim inverse) | Corrected: reverse-path condition scoped to `finish()` trailing-whitespace removal only |
| MED | **FRESH-04 (highest-value):** Byte-identity forward-path trailing-newline overclaim — spec claimed step-2 trailing-newline strip was fully byte-identity reversible; CRLF inputs are not (CR-normalization in step-3 is lossy) | Corrected: byte-identity forward-path condition narrowed to LF-only trailing newline; CRLF inputs noted as lossy |
| LOW | Wording/annotation polish — 4+ passes of phrasing harmonization across 6-EC table | Applied throughout v1.7–v1.9.1 |

FRESH-02 and FRESH-04 were the highest-value catches: they would have caused
implementation divergence from spec in the F4 test suite if left uncorrected.

---

## Final Pass Result

Scoped pass on frozen v1.9.1 (634cb88): **CLEAN** — zero findings.
Passes were fresh-context (no carry-over state between runs).
Multi-lens coverage: algorithm/EC correctness, code-drift (vs current adf.rs), consistency/implementer perspective.

---

## BC-7.2.011 v1.9.1 Summary (for F4 reference)

**Algorithm B — 7 steps:**
1. Receive raw HtmlBlock text (possibly multi-line, may have CRLF)
2. Strip single trailing `\n` (if present)
3. CR-normalize: replace all `\r\n` → `\n`
4. Split on `\n` → line segments
5a. If single segment: emit as one `text` node (existing behavior preserved)
5b. Trim leading and trailing empty segments
6. If zero non-empty segments remain after trim: return `None` (empty-block prune)
7. Emit segment[0] as `text`, then alternate `hardBreak` + `text` for each subsequent segment

**6 Edge Cases (all annotated with byte-identity status):**
- EC-1: Single-line, no trailing newline → text node, pass-through
- EC-2: Single-line + trailing `\n` → strip, single text node
- EC-3: Multi-line LF → hardBreak segments
- EC-4: Multi-line CRLF → CR-normalize then hardBreak segments (lossy round-trip)
- EC-5: Empty block → `None` (prune)
- EC-6: Leading/trailing blank lines → step-5b trim removes them

---

## F4 Carry-Forward Task List

1. Replace `strip_suffix('\n')` in HtmlBlock end-handler with `trim_end_matches(['\r', '\n'])` then apply full Algorithm B
2. **REPLACE** `test_convert_multiline_block_html_preserves_interior_newlines` — currently asserts old raw-`\n` behavior; must be replaced with hardBreak-segmented assertion matching EC-3
3. Add 9 named tests per BC-7.2.011 Source/Trace (covering EC-1 through EC-6 + CRLF + empty + leading-trailing-blank)
4. Create `docs/specs/adf-block-html.md` (spec cross-reference document)

Tracked as drift item `#492-F4-IMPL` in STATE.md.
