---
document_type: spec-delta-handoff
cycle: cycle-014
phase: f5
fix: FIX-P5-004
decision: D-398
spec_version: 2.6.0
bc: BC-7.1.006
---

# FIX-P5-004 spec delta (implementer hand-off)

Scope (human decision D-398): all LOW and NIT findings from F5 pass 3; no CR3-002 behavior change.
Spec only — nothing below is implemented yet. Product code baseline: develop @ 8e843385.

## 1. Policy addition (SEC3-001 / CR3-003, CWE-451)

Edit `src/output.rs::classify_default_char` ONLY. It is the single default per-character policy shared
by `sanitize_table_cell`, `sanitize_terminal_text`, and `sanitize_terminal_line`; no per-function
branching. Add these to the `CharDisposition::Drop` condition (nothing substituted):

| Code points | Names |
|---|---|
| `U+200B..=U+200F` | ZWSP, ZWNJ, ZWJ, LRM, RLM |
| `U+061C` | ARABIC LETTER MARK (ALM) |
| `U+2060..=U+2064` | WORD JOINER, FUNCTION APPLICATION, INVISIBLE TIMES, INVISIBLE SEPARATOR, INVISIBLE PLUS |
| `U+FEFF` | BOM / ZERO WIDTH NO-BREAK SPACE |
| `U+E0000..=U+E007F` | Unicode tag block (all 128) |

Use `u32` code-point range checks (`(0xE0000..=0xE007F).contains(&code)`), consistent with the
existing arms. Must stay KEPT: `U+200A`, `U+2010`, `U+205F`, `U+2065`, `U+FEFE`, `U+FF00`,
`U+E0080`, `U+1F600`.

## 2. ZWJ (U+200D) decision: STRIPPED

Rationale: invisible and usable for identity spoofing, so it fits the threat model; a lone exception
inside a contiguous invisible-format range is harder to state/test/audit; affected sinks are
security-relevant disambiguation/echo surfaces; `--output json` is never sanitized so machines keep
the raw value. Accepted trade-off: ZWJ emoji sequences (and legitimate LRM/RLM/ZWNJ in RTL/Persian
names) lose those characters in table/human output (`👩<ZWJ>💻` -> `👩💻`). Pinned by EC-20 so a future
narrowing (e.g. ZWJ allowed only between emoji) is a deliberate spec change.

## 3. Out of scope

- `strip_control_and_ansi` / `sanitize_env_display` (no C1 handling, `SANITIZE-ENV-DISPLAY-C1-GAP`):
  NOT modified, does not gain these characters; the drift item stays OPEN.
- CR3-002 (`jr user list --project ""`): behavior unchanged; recorded as a KNOWN LIMITATION on
  `EC-X.7.002-6` (`.factory/specs/prd/cross-cutting.md`, `edge-case-catalog.md`).
- CSI/OSC state machine, `\n` handling, JSON-never-sanitized: unchanged.

## 4. New ECs and VP (all NOT YET IMPLEMENTED, targets for FIX-P5-004)

| ID | Covers |
|---|---|
| EC-18 | zero-width / directional marks / word-joiner range / BOM stripped; boundary KEEP pins; identity collapse |
| EC-19 | tag block stripped in full, both endpoints; `U+E0080` and `U+1F600` kept |
| EC-20 | ZWJ emoji sequences lose joiner (accepted trade-off) |
| VP-SEC-001-002 | (a) property + (b) example cells + (c) mutation kill targets |

Test targets (all in `src/output.rs` tests module, convert to live citations post-merge):
- `prop_bc_7_1_006_sanitizers_strip_invisible_format_characters` (all three sanitizers; generator must include range endpoints)
- `test_bc_7_1_006_sanitize_strips_zero_width_and_directional_marks`
- `test_bc_7_1_006_sanitize_invisible_format_range_boundaries_kept`
- `test_bc_7_1_006_sanitize_strips_unicode_tag_block`
- `test_bc_7_1_006_sanitize_zwj_emoji_sequence_loses_joiner`
- `test_bc_7_1_006_sanitize_terminal_line_invisible_chars_identity_collapse`

## 5. Doc-fallout for the implementer

Update the `classify_default_char` / `sanitize_table_cell` / `sanitize_terminal_text` /
`sanitize_terminal_line` rustdoc and the CLAUDE.md `output::sanitize_table_cell` bullet's per-character
policy list and `output.rs` LOC note. Run the four spec guards after any spec edit.

## 6. Files changed by this spec delta

- `.factory/specs/prd/bc-7-output-render.md` (H1, policy bullet, EC-18..20, VP-SEC-001-002, version row 1.5.0)
- `.factory/specs/prd/BC-INDEX.md` (BC-7.1.006 title cell)
- `.factory/specs/prd/cross-cutting.md` (EC-X.7.002-6 known limitation)
- `.factory/specs/prd/edge-case-catalog.md` (EC-X.7.002-6 mention)
- `.factory/spec-changelog.md` ([2.6.0])
- this file

Stories affected by BC changes: none (no `bcs:` array changes). VP citations changed in: BC-7.1.006
(new VP-SEC-001-002; architect should add it to VP-INDEX if VP-SEC-001-001 is indexed there). [CORRECTED 2026-10-05, F7C1-001: this mint raised the VP total 98 -> 99; it was not counted at the time (no VP-INDEX exists in this repo).]

## 7. Post-merge conversion (spec v2.6.1, BC-7.1.006 v1.5.1)

PR #896 merged to `develop` as `6cece14b`. Sections 1-6 above are retained as the pre-merge
hand-off (dated history). As of the merge, the implementation is live:

- `src/output.rs::classify_default_char` implements the D-398 invisible-format strip.
- All six VP-SEC-001-002 / EC-18..EC-20 tests exist at `6cece14b` in `src/output.rs`:
  `prop_bc_7_1_006_sanitizers_strip_invisible_format_characters`,
  `test_bc_7_1_006_sanitize_strips_zero_width_and_directional_marks`,
  `test_bc_7_1_006_sanitize_invisible_format_range_boundaries_kept`,
  `test_bc_7_1_006_sanitize_strips_unicode_tag_block`,
  `test_bc_7_1_006_sanitize_zwj_emoji_sequence_loses_joiner`,
  `test_bc_7_1_006_sanitize_terminal_line_invisible_chars_identity_collapse`.
- The "NOT YET IMPLEMENTED" qualifiers in BC-7.1.006 (H1, policy bullet, EC-18/19/20,
  VP-SEC-001-002) and the BC-INDEX row are converted to present tense. Row 1.5.0 stays as history.
- Renamed test: `test_bc_7_1_006_print_output_with_styles_does_not_error_on_hostile_cells` is now
  `..._returns_ok_on_hostile_cells`; no spec text cites either name (only the historical
  `.factory/code-delivery/FIX-P5-001/pr-review.md` mentions the old name; left as history).

