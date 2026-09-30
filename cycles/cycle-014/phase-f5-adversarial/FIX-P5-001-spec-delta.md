---
document_type: spec-delta
fix_id: FIX-P5-001
finding_id: SEC-001-RENDER-TABLE-ANSI-SANITIZE
severity: MEDIUM
cwe: ["CWE-150", "CWE-116"]
phase: F5
cycle: cycle-014
human_decision: D-392
decision_date: 2026-09-30
date: 2026-09-30
author: product-owner
new_bcs:
  - BC-7.1.006
amended_bcs: []
new_vps:
  - VP-SEC-001-001
related_files:
  - .factory/cycles/cycle-014/wave-integration-gate.md
  - .factory/cycles/OPEN-STANDING-ITEMS.md
  - .factory/spec-changelog.md
  - .factory/specs/prd/bc-7-output-render.md
  - .factory/specs/prd/BC-INDEX.md
  - .factory/specs/prd/CANONICAL-COUNTS.md
---

# Phase F5 Spec Delta — FIX-P5-001 (SEC-001-RENDER-TABLE-ANSI-SANITIZE)

Companion to cycle-014's F4-completion combined wave integration gate security review
(`cycles/cycle-014/wave-integration-gate.md` step (d)), which surfaced `SEC-001` (MEDIUM,
CWE-150/CWE-116): table-rendered server strings passed through `output::render_table` are not
ANSI-escape/control-character sanitized before being written to the terminal — pre-existing and
codebase-wide (every table-mode command that renders server-supplied text shares the unsanitized
path). The finding was recorded as a standing security-debt item,
`SEC-001-RENDER-TABLE-ANSI-SANITIZE`, in `cycles/OPEN-STANDING-ITEMS.md`, with disposition
pending a human decision on whether to fix it within cycle-014 (before or during F5) or defer it.

**Human decision D-392 (2026-09-30):** fix within cycle-014, during F5. This delta is the
spec-side half of that fix — it is a **delta-only** spec update, zero `src/` production files
touched. The implementation (`output::sanitize_table_cell` itself, the `render_table` call site,
and the `format_active` structural-styling refactor) is an F6/F7 obligation of this same cycle,
tracked under this same `FIX-P5-001` ID.

## 1. Summary of decisions

| Question | Decision |
|---|---|
| Where does the new BC go — `cross-cutting.md` or a `bc-N.md` file? | **`bc-7-output-render.md`, §7.1 Table / JSON Output.** Searched `cross-cutting.md` for an existing output-rendering subsection (BC-X.1 HTTP Client, X.2 Pagination, X.3 Error Handling, X.4 Rate Limiting, X.5 Worklogs, X.6 Teams, X.7 Users — none cover table rendering). `bc-7-output-render.md` §7.1 is the file whose entire scope is "Table / JSON Output" and already hosts the sibling sanitizer's home (`output.rs`) via BC-7.1.001 (renderer selection) and BC-7.1.005 (JSON error shape). The new contract is appended as BC-7.1.006, the next sequential ID in §7.1 (BC-7.1.001..005 existed; no gap to fill). |
| Amend an existing BC, or create a new one? | **New BC.** No existing BC in §7.1 (or elsewhere) specifies `render_table`'s per-character sanitization policy — BC-7.1.001 only states which renderer is used for which `--output` mode, and BC-7.1.002 covers `--no-color`/`NO_COLOR` (suppressing jr's own ANSI output, an orthogonal concern to sanitizing server-supplied content). A genuinely new, previously-unspecified contract. |
| Create a VP? | **YES — one, inlined in the BC body** (established convention per `verification-delta-571.md`'s "Registration surface" note and the BC-7.2.015/S-MUTANTS-SCOPE-1 precedents: VPs are recorded inline in a BC's `**Verification Properties**:` subsection; there is no separate VP-INDEX/VP-registry in this project). `VP-SEC-001-001`, ID chosen to trace directly back to the `SEC-001` finding this BC closes, rather than an issue number (there is no GitHub issue for this — it was found internally during security review). One VP with three named parts — (a) property-based whole-string invariant, (b) example-based per-EC pins, (c) end-to-end table-vs-JSON asymmetry check — rather than three separately-numbered VPs, to keep the VP count delta at exactly +1 (97→98) as scoped by the task. |
| Does `sanitize_table_cell` exist in `src/` yet? | **NO.** This delta specifies the contract ahead of F6 implementation — the same "spec precedes code" posture as the `src/api/jira/tenant.rs (NEW FILE — does not exist yet, F4 target, not a live citation)` precedent in `bc-1-auth-identity.md:648`. The BC's `**Trace**:` field cites the proposed function WITHOUT backticks and with an explicit "(NEW FUNCTION — does not exist yet, F6 target, not a live citation)" annotation, so `scripts/check-bc-citation-symbols.sh`'s backtick-token extractor does not treat it as a live (and therefore stale) citation. All OTHER citations in the BC (`render_table`, `sanitize_env_display`, `strip_control_and_ansi`, `format_active`) are real, already-existing symbols and are cited normally in backticks. |
| Does this BC's fix require any `format_active` spec change? | **YES — folded into the same BC, not a separate amendment.** Once `render_table` sanitizes every cell, `format_active`'s current ANSI-bytes-in-`String` styling would itself be stripped, silently breaking jr's own intentional Active-column coloring. Rather than minting a second BC for this, BC-7.1.006's Behavior section states the general rule (jr's own styling must be structural `Cell` attributes going forward) and names `format_active` as the concrete caller that must be refactored in the same implementation burst. No existing BC specifies `format_active`'s current ANSI-embedding behavior, so there is nothing to amend — this is new specification, not a correction. |
| Is an architecture change needed? | **NO.** This is a pure-function addition inside an existing module (`output.rs`) with no new file, no module-boundary change, and no purity-boundary crossing. `.factory/specs/architecture/*` is not touched. |
| Spec version bump? | **MINOR, 2.4.0 → 2.5.0.** Per `.factory/spec-changelog.md`'s Type legend ("MINOR = new BCs/VPs/sections"), a new BC + new VP classifies as MINOR regardless of the change's product-facing size — the same rule applied to the cycle-014 F2 entries in the same changelog. |

## 2. BC addition — BC-7.1.006

**File**: `.factory/specs/prd/bc-7-output-render.md` (§7.1 Table / JSON Output)

Full BC text lives in the file itself (`#### BC-7.1.006: ...`); this section summarizes it for
traceability.

- **Scope**: `output::render_table`, the single table-mode rendering chokepoint
  (`output::print_output`'s `OutputFormat::Table` arm is its only production call site). Covers
  every header and every cell.
- **Character policy**: `\n` preserved; `\r` stripped outright; `\t` → single space (deliberately
  NOT stripped outright, to avoid word-merging across the tab boundary — e.g. `"rm -rf /\thome"`
  must not collapse to `"rm -rf /home"`); all other C0 controls + `0x7F` stripped; ANSI CSI/OSC
  consumed and stripped wholesale reusing `strip_control_and_ansi`'s existing state machine,
  including its fail-closed unterminated-sequence behavior (consumed through EOF); C1 controls
  `U+0080`-`U+009F` stripped as a class (new relative to `strip_control_and_ansi`, which has no
  C1 handling — a documented, explicitly out-of-scope gap on that sibling function); bidi
  overrides and line/paragraph separators stripped (same set `strip_control_and_ansi` already
  strips); no length cap.
- **JSON asymmetry**: `--output json` is never sanitized — mirrors `sanitize_env_display`'s own
  documented rule and the issue #398 description-echo asymmetry already codified in CLAUDE.md.
- **jr's own styling**: `format_active` (`src/cli/user.rs`) must move its Active-column
  `"✓"`/`"✗"` coloring from ANSI-bytes-in-`String` to structural `comfy_table::Cell` attributes,
  since a server-supplied string can now never itself produce a colored cell once this BC's
  sanitizer is in place.
- **Explicit out-of-scope residuals** (documented, not fixed by this BC): `project.rs` name
  lists, `workflow.rs` transition-name prompts, `sprint.rs`'s summary hint, `component.rs`'s
  delete-confirmation echo, `field.rs::normalize_or_degrade`'s degrade hint, `JrError` bodies
  that echo server text, and `sanitize_env_display`'s own pre-existing C1 gap.
- **12 edge cases** (EC-1..EC-12) with exact input→output pairs, covering: CSI stripped, OSC
  stripped (BEL-terminated), unterminated CSI fail-closed, bidi override stripped, C1 CSI
  introducer stripped with literal survivor bytes, NUL/C0 stripped, bare `\r` stripped, `\r\n`
  collapse, bare `\n` preserved, `\t`→space, long clean text unchanged (no cap), and the
  `--output json` never-sanitized case.

## 3. Verification Property — VP-SEC-001-001

Inlined in BC-7.1.006's `**Verification Properties**:` subsection. Three named parts:

- **(a) Property-based whole-string invariant**: over an arbitrary generated `String`, the
  sanitizer's output contains no C0 control other than `\n`, no C1 control, no raw `ESC`, no
  `\r`, no `\t`, and none of the bidi/line/paragraph-separator code points; every `\n` in the
  input survives in the output in the same relative order; the function is the identity on
  input composed solely of printable non-control characters plus `\n`.
- **(b) Example-based pins**: one deterministic test per EC-1..EC-12, asserting the exact stated
  output string (or, for EC-12, the exact unsanitized JSON stdout content).
- **(c) End-to-end check**: `jr field options` and `jr issue list` against hostile wiremock
  fixtures (a hostile option label / a hostile issue summary respectively), asserting the
  captured stdout under `--output table` contains no raw `ESC` byte and no UTF-8 encoding of a
  C1 code point, while the identical fixtures under `--output json` assert the raw hostile
  payload IS present byte-for-byte — proving the table/JSON asymmetry end to end, not just at
  the unit level.

VP count: **97 → 98**. No Kani proofs, no fuzz targets — this is a bounded, deterministic
string-transform function; property-based + example-based + end-to-end coverage is the
appropriate proof strategy, matching the sibling `sanitize_env_display`'s existing test shape.

## 4. Bookkeeping performed in this burst

- `.factory/specs/prd/bc-7-output-render.md`: new `#### BC-7.1.006` section inserted at the end
  of §7.1 (before §7.2); frontmatter `total_bcs` 97→98, `definitional_count` 53→54,
  `last_updated` bumped, `trace:` gains a dated history line; body preamble "97 behavioral
  contracts" → "98 behavioral contracts" with a trailing parenthetical note.
- `.factory/specs/prd/BC-INDEX.md`: frontmatter `total_bcs` 772→773 with a dated history line;
  frontmatter `last_updated`/`index_version` bumped (v6.89→v6.90) with a dated history line;
  frontmatter `sections:` bc-7 entry 97→98 cumulative / 53→54 individually-bodied; `## Section 7`
  header 97→98 / 53→54 with a bracketed note; `### 7.1` subsection header "(5 BCs:
  BC-7.1.001..005)" → "(6 BCs: BC-7.1.001..006)"; new BC-7.1.006 table row appended.
- `.factory/specs/prd/CANONICAL-COUNTS.md`: per-file definitional-count table row (bc-7:
  53→54, total individually-bodied 542→543); per-file `total_bcs` table row (bc-7: 97→98, Sum
  772→773); grand-total prose bumped to 773 with a dated note; Breakdown section's
  "772 = sum.../542 of 772" lines updated to 773/543 (543 of 773), noting the addition is
  entirely individually-bodied (230 range-collapsed figure unchanged); `last_verified`
  frontmatter bumped with a dated note.
- `.factory/spec-changelog.md`: new `## [2.5.0] - 2026-09-30` entry (MINOR) prepended above the
  existing `## [2.4.0]` entry, following the established New/Modified/Removed
  Requirements + New Verification Properties + Architecture Changes + Impact Assessment +
  Feature Request Link template.
- Verified both `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` exit
  0 after all of the above. Also re-verified `scripts/check-bc-citation-symbols.sh` and
  `scripts/check-bc-no-numeric-test-counts.sh` exit 0 (the citation guard required removing
  backticks around the not-yet-existing `sanitize_table_cell` citation in the BC's `**Trace**:`
  field, per the house convention documented in decision row 3 above).

## 5. Explicitly NOT touched in this burst

Per task scope: `src/` (no implementation — this is spec-only, ahead of F6), `STATE.md`,
`STORY-INDEX.md` (state-manager's responsibility), and no git commit was created (state-manager
commits `.factory/` changes).

## 6. Hand-offs

- **F6 implementation** must: (1) add `output::sanitize_table_cell` to `src/output.rs` matching
  this BC's exact character policy; (2) wire it into `render_table`'s header/cell loop; (3)
  refactor `src/cli/user.rs::format_active` and its Active-column call sites to structural
  `comfy_table::Cell` styling; (4) add the unit/property/example tests and the end-to-end
  wiremock check described in VP-SEC-001-001; (5) update `CLAUDE.md`'s `output.rs` line if its
  one-line module description needs to mention the sanitizer (currently just "Table (comfy-table)
  and JSON formatting" — no citation change required unless a future maintainer judges the
  one-liner now materially incomplete).
- **No BC array / story propagation needed this burst** — BC-7.1.006 is net-new and not yet
  anchored to any story (`## Story Anchor` left TBD in the BC's future story-decomposition pass,
  if this fix is later formalized into a story rather than shipped as a direct F6 fix burst).
- **No VP-INDEX/architecture propagation needed** — this project has no separate VP-INDEX or
  verification-architecture document (VPs live inline in BC bodies); `verification-coverage-matrix.md`
  does not exist in this repo either.

## 7. Amendment (2026-09-30, post-implementation, spec v2.5.1 PATCH)

FIX-P5-001's implementation and Red Gate (branch `fix/FIX-P5-001`) surfaced three wording defects
in BC-7.1.006 / VP-SEC-001-001 that this delta's original text got wrong, corrected in place —
no policy change, BC count unchanged (98/54, cumulative 773):

1. VP-SEC-001-001(a)'s `\n`-preservation clause was unconditional, contradicting the BC's own
   EC-3 (unterminated CSI/OSC consumed fail-closed through EOF, which also swallows an embedded
   `\n` — e.g. `"\u{1b}[31;1;9\n"` → `""`, since the CSI scan finds no final byte in `0x40`-`0x7E`
   before end-of-string, including the `\n` itself). The CSI scan has no `\n` boundary check at
   all: `"\u{1b}[31;1;9\nline2"` resolves to `"ine2"`, not `""` — the lowercase `l` in `line2`
   falls in `0x40`-`0x7E` and terminates the CSI there, consuming the params, the `\n`, and the
   `l` together. (This literal was corrected mid-burst: the orchestrator's first draft used
   `"\u{1b}[31;1;9\nline2"` → `""`, which the test-writer found does not hold against the
   implemented state machine — pinned test
   `test_bc_7_1_006_ec13_unterminated_csi_consumption_includes_embedded_newline`.) Split the
   clause into an unconditional "never fabricates a `\n`" invariant plus a conditional "exact
   preservation when no `\n` falls inside a CSI/OSC sequence's scan span" invariant — narrower
   and more precise than "absent an unterminated CSI/OSC", since a *terminated* sequence with an
   embedded `\n` still swallows it. New **EC-13** added pinning both the swallowed-newline
   minimal case and the terminated-but-still-swallows contrast case.
2. VP-SEC-001-001(c) and EC-12 claimed the hostile payload is present "byte-for-byte" in JSON
   stdout — impossible for payloads containing `0x00`-`0x1F` under JSON's escaping grammar.
   Reworded to a `serde_json`-parse round-trip claim, noting non-escaped characters (e.g. C1
   `U+009B`) do appear literally in the raw text.
3. The `**Trace**` field's `sanitize_table_cell` qualifier was updated from "does not exist yet"
   to "implemented in FIX-P5-001, pending merge" (still unbackticked, per the house convention in
   decision row 3 above, so `check-bc-citation-symbols.sh` — which validates against `develop`'s
   `src/` — doesn't flag it stale pre-merge). The same unbackticked pending-merge form was added
   for the implementation's additional API surface: `output::render_table_with_styles`,
   `output::print_output_with_styles`, `output::StyledCell`, `cli::user::active_cell`.

Full text: `.factory/specs/prd/bc-7-output-render.md` BC-7.1.006 (EC-12/EC-13, VP-SEC-001-001,
`**Trace**`, version-history row 1.0.1). Changelog: `.factory/spec-changelog.md` `[2.5.1]`.
Re-verified `scripts/check-spec-counts.sh`, `scripts/check-bc-cumulative-counts.sh`,
`scripts/check-bc-citation-symbols.sh --bc-dir .factory/specs/prd`, and
`scripts/check-bc-no-numeric-test-counts.sh` all exit 0 after this amendment.
