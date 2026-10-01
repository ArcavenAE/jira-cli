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

## 8. Amendment (2026-09-30, PR #891 security review, spec v2.5.2 PATCH, human decision D-393)

PR #891's (this same `FIX-P5-001`) security review returned **REQUEST_CHANGES**, raising finding
**SEC-003** (HIGH, CWE-150/CWE-116): `jr issue comment view`'s default human (non-JSON) output
bypasses the sanitizer this BC specifies — entirely, not partially. `handle_comment_view`
(`src/cli/issue/interactions.rs`) is NOT a `render_table`/`render_table_with_styles` call site; its
`OutputFormat::Table` arm prints `response["author"]["displayName"]` and the ADF-derived comment
body (`adf::adf_to_text(&response["body"])`) directly via `print!`/`println!`. Server-supplied text
— a comment body writable by anyone with comment permission, an author display name — therefore
reaches the terminal raw in this specific command, even after the `render_table` fix landed. The
BC's own rustdoc/CHANGELOG/CLAUDE.md claims of "every table-mode command" being covered were false
for this handler, since it was never a table-mode (`render_table`) path to begin with.

**Human decision D-393 (2026-09-30):** extend `FIX-P5-001` to cover `jr issue comment view`'s
human-output mode. The other five non-table sinks BC-7.1.006 already documented as out-of-scope
stay out of scope, now collectively tracked as `NONTABLE-SERVER-TEXT-SANITIZE`: `project.rs` name
lists, `workflow.rs` transition prompts, `sprint.rs`'s hint, `component.rs`'s delete echo,
`field.rs`'s degrade hint, `JrError` server-text echoes.

### 8.1 Decisions

| Question | Decision |
|---|---|
| Amend BC-7.1.006 in place, or mint a new BC? | **Amend in place.** `handle_comment_view`'s sanitization requirement is the same character policy, same sanitizer function (`output::sanitize_table_cell`), same table/JSON asymmetry, and the same fix ID (`FIX-P5-001`) — this is a scope expansion of an existing contract, not a new one. A separate BC would fragment one security fix across two contracts for no traceability benefit. |
| New VP, or extend VP-SEC-001-001? | **Extend VP-SEC-001-001(c) in place.** Part (c) is already the "end-to-end check" slot naming specific commands (`jr field options`, `jr issue list`); adding `jr issue comment view` to that same slot, rather than minting VP-SEC-001-002, keeps the VP count delta at zero and keeps all of BC-7.1.006's proof obligations in one place, matching the house convention (VPs live inline in BC bodies, one VP per BC in this file so far). |
| Spec version bump? | **PATCH, 2.5.1 → 2.5.2.** Per the Type legend ("PATCH = amendments to existing bodies/ACs/ECs"): this adds a new EC (EC-14) and extends an existing VP part, inside an EXISTING BC — no new BC, no new VP ID. This mirrors the classification already used for the 2.5.1 wording-correction amendment in §7 above, which also touched EC-13/VP wording without a MINOR bump. |
| Does `handle_comment_view`'s Trace citation need the "pending-merge, unbackticked" treatment `sanitize_table_cell` got? | **NO — opposite case.** `handle_comment_view` already exists on `develop` today (confirmed: identical code in the main checkout and on `fix/FIX-P5-001`, since this handler was untouched by the original `render_table` fix). It gets a normal, live, backticked citation. What's still pending is the SANITIZER WIRING inside it, which the Trace entry says explicitly — the same "spec precedes code" posture the BC already used for `sanitize_table_cell` pre-F6, just inverted (function exists, wiring doesn't, vs. wiring's call site existed, function didn't). |
| Which fields get sanitized? | **All six labeled fields plus the body**, not a hand-picked subset. `ID`/`Created`/`Updated`/`JSM internal` are narrow-format or fixed-literal values in practice (numeric id, ISO 8601 timestamp, `"Yes"`/`"No"`/`"N/A"`) and `Author`/`Restricted` carry genuine server-controlled text (display name; `visibility.value`/`.identifier`/`.type` — confirmed via `format_restricted_field`'s implementation, which interpolates raw `value`/`identifier`/`type` strings from the comment's `visibility` object). Sanitizing uniformly avoids a second "is this field server-controlled enough to bother" judgment call per field and matches the BC's existing "sanitize everything, no cap" posture for table cells. |

### 8.2 EC-14 fixture verification

The task instruction for this amendment explicitly flagged that an earlier EC literal (EC-13, in
§7 above) was wrong when first drafted, and required every pinned EC-14 output to be checked
against the real state machine before being written into the spec. Verification performed for
this amendment, not merely asserted:

1. Read `sanitize_control_and_ansi_core` and `sanitize_table_cell` directly from
   `.worktrees/FIX-P5-001/src/output.rs` (the implemented state machine — CSI scan: `ESC [` then
   consume chars until the first byte in `\u{40}..=\u{7e}` or EOF; OSC scan: `ESC ]` then consume
   until BEL `\u{7}` or `ESC \` or EOF; policy: `\n` keep, `\r` drop, `\t`→space, other C0/DEL/C1/
   bidi/line-separators drop, everything else keep).
2. Hand-traced both EC-14 fixtures character-by-character against that exact state machine (see
   the BC body's EC-14 entry for the full trace).
3. Independently re-implemented the same state machine in a standalone Python script
   (scratchpad-only, not committed) and ran it against both fixtures as a cross-check, rather than
   relying on the hand-trace alone:
   - body `"pwned\u{1b}]0;evil\u{7}\r\nline2"` → `"pwned\nline2"` ✓ (matches the hand-trace: OSC
     `\u{1b}]0;evil\u{7}` consumed wholesale, then `\r` dropped, `\n` preserved since it falls
     outside any CSI/OSC span, `line2` untouched)
   - author `"\u{1b}[31mMallory\u{1b}[0m"` → `"Mallory"` ✓ (both CSI sequences are legitimately
     terminated — `m`, `0x6D`, is a valid final byte in `0x40`-`0x7E` — and consumed wholesale;
     `Mallory` passes through untouched)

Both results match the fixture's pinned expectations in the BC body's EC-14 and this amendment's
VP-SEC-001-001(c) extension exactly. Unlike the original EC-13 draft (§7 above), no correction was
needed for EC-14 — the fixture was constructed and verified against the real implementation before
being written into the spec, not drafted first and corrected after a test-writer caught it.

### 8.3 BC changes (full text in the file itself)

**File**: `.factory/specs/prd/bc-7-output-render.md`, `#### BC-7.1.006`

- **H1** enriched with a clause naming `jr issue comment view` as an additional, explicit
  non-`render_table` covered sink (D-393, SEC-003) — per this project's BC H1 Title Authority
  policy, enrichment goes into the H1, not left as index-only context.
- **Behavior** opening sentence corrected: "every table-mode command … renders through it" →
  precise statement of what `render_table`/`render_table_with_styles` cover, plus a called-out
  D-393 addition for `jr issue comment view`'s human output specifically.
- **New Behavior subsection** ("`jr issue comment view`'s human-output mode is also an explicitly
  covered sink") specifying `handle_comment_view`'s six labeled fields (`ID`, `Author`, `Created`,
  `Updated`, `JSM internal`, `Restricted`) and its ADF-derived body must route through
  `output::sanitize_table_cell` before printing; output FORMAT unchanged; `--output json`
  unaffected.
- **Out-of-scope** paragraph's intro sentence and residual list updated: comment view removed
  from the residual enumeration (now five entries, was six) and the remainder tagged
  `NONTABLE-SERVER-TEXT-SANITIZE`.
- **New EC-14** with the hostile body/author fixture above, full character-by-character trace,
  and the two-fixture verification method cited.
- **VP-SEC-001-001(c)** extended (not replaced) with the same EC-14 fixture exercised against
  `jr issue comment view` under both `--output table` and `--output json`.
- **`**Trace**`** gains a new, LIVE (backticked, not pending-merge) citation:
  `src/cli/issue/interactions.rs::handle_comment_view`, with a note that the sanitizer wiring
  itself is not yet implemented.
- **Version history** gains row `1.1.0` recording the SEC-003 provenance and this amendment.
- Frontmatter `trace:` gains a new dated history bullet; `total_bcs`/`definitional_count`
  unchanged (98/54) — no new BC, no new VP ID.

### 8.4 Bookkeeping performed in this amendment

- `.factory/specs/prd/bc-7-output-render.md`: all changes in §8.3 above.
- `.factory/specs/prd/BC-INDEX.md`: BC-7.1.006's title-column row updated to match the enriched
  H1 (per the BC H1 Title Authority policy — title drift between the H1 and downstream index
  references is HIGH severity) and gains the `handle_comment_view` source citation; no count
  change, so no frontmatter/section-header edits were needed.
- `.factory/specs/prd/CANONICAL-COUNTS.md`: **not touched** — no count change (BC/VP counts both
  unchanged).
- `.factory/spec-changelog.md`: new `## [2.5.2] - 2026-09-30` entry (PATCH) prepended above the
  existing `## [2.5.1]` entry, following the established template.
- Re-ran `scripts/check-spec-counts.sh`, `scripts/check-bc-cumulative-counts.sh`,
  `scripts/check-bc-citation-symbols.sh --bc-dir .factory/specs/prd`, and
  `scripts/check-bc-no-numeric-test-counts.sh` — see the orchestrating burst's report for exit
  codes.

### 8.5 Explicitly NOT touched in this amendment

Per task scope: `src/` (no implementation — `handle_comment_view`'s sanitizer wiring is a pending
F6/follow-up-PR obligation, not done in this spec-only burst), `STATE.md`, `STORY-INDEX.md`
(state-manager's responsibility), and no git commit was created.

### 8.6 Hand-off

- **Implementation follow-up on PR #891 (or a successor PR)** must: (1) route
  `handle_comment_view`'s `id_val`/`author`/`created`/`updated`/`jsm_internal`/`restricted`
  locals and its `body_text` through `output::sanitize_table_cell` before the `print!`/`println!`
  calls in its `OutputFormat::Table` arm; (2) add the EC-14 pinned test; (3) add the
  VP-SEC-001-001(c) end-to-end wiremock check for `jr issue comment view`; (4) leave the
  `OutputFormat::Json` arm untouched (already lossless/unsanitized, correctly).
- **No BC array / story propagation needed** — BC-7.1.006 is still not anchored to any story.
- **No VP-INDEX/architecture propagation needed** — same rationale as §6 above; this project has
  no separate VP-INDEX or verification-architecture document.

## 9. Amendment (2026-09-30, PR #891 security re-review, spec v2.5.3 PATCH, human decision D-394)

The PR #891 security re-review **approved** D-393's `jr issue comment view` (SEC-003) fix. In the
same pass, the reviewer identified **an unlisted residual with the identical exposure class**:
`jr issue assign` (`src/cli/issue/workflow.rs::handle_assign`) echoes the assignee's server-side
Jira `displayName` in its human-output success and idempotent messages — `output::print_success`
calls at approximately L1084 (`"<key> is already assigned to <name>"`, the idempotent exit-0 path)
and L1104 (`"Assigned <key> to <name>"`, the changed path) in
`.worktrees/FIX-P5-001/src/cli/issue/workflow.rs`. `handle_assign` is NOT a `render_table` call
site, so neither message passes through `sanitize_table_cell`/`sanitize_terminal_text`. A Jira
display name is user-editable via self-service profile settings, so it carries the same
hostile-content exposure SEC-003 closed for a comment author's display name — a hostile display
name reaches a teammate's terminal raw. The reviewer also named a further, explicitly
**non-exhaustive** set of same-class residuals found during the same pass, which stay out of scope
for this fix: status names echoed by `jr issue move` and its bulk-move error text, link-type names
in `jr issue link`/`links.rs`, component rename/create/edit/list-warning names in `component.rs`,
the board auto-discovery name in `board.rs`, and `jr init`'s interactive board-select items.

**Human decision D-394 (2026-09-30):** fix the `handle_assign` residual in PR #891 (same posture as
D-393), and document the newly named residuals as part of an explicitly **known, non-exhaustive**
list rather than implying the prior five/six-entry enumeration was exhaustive.

### 9.1 Decisions

| Question | Decision |
|---|---|
| Amend BC-7.1.006 in place, or mint a new BC? | **Amend in place**, same rationale as D-393 in §8.1: identical character policy, identical sanitizer function (`output::sanitize_table_cell` via its `sanitize_terminal_text` alias), identical table/JSON asymmetry, same fix ID (`FIX-P5-001`/PR #891). A second scope expansion of one existing contract, not a new one. |
| New VP, or extend VP-SEC-001-001 again? | **Extend VP-SEC-001-001(c) again**, appending a third end-to-end fixture slot alongside the D-393 addition, for the same reasons as §8.1: keeps VP count delta at zero, keeps all proof obligations for this sink class in one place. |
| Spec version bump? | **PATCH, 2.5.2 → 2.5.3.** Adds one EC (EC-15) and extends one VP part inside an EXISTING BC — no new BC, no new VP ID. Same classification precedent as 2.5.1 (§7) and 2.5.2 (§8). |
| Does `handle_assign`'s Trace citation need "pending-merge, unbackticked" treatment? | **NO — same as `handle_comment_view` in §8.1.** `handle_assign` already exists on `develop` today; it gets a normal, live, backticked citation. What's pending is the SANITIZER WIRING inside it — the Trace entry says so explicitly, the same spec-precedes-code posture used for `handle_comment_view`'s citation. |
| Which of `handle_assign`'s messages get sanitized? | **Both messages that echo `display_name`** (`"Assigned <key> to <name>"` and `"<key> is already assigned to <name>"`), including the `--account-id` path where `display_name` is set equal to the raw CLI-supplied account ID (not server text, but sanitized uniformly for chokepoint-discipline simplicity, mirroring D-393's rationale for sanitizing `handle_comment_view`'s narrow-format fields uniformly). The `--unassign` path's two messages (`"Unassigned <key>"`, `"<key> is already unassigned"`) echo only the CLI-supplied issue key — never server-derived — and are explicitly excluded. |
| How to word the Out-of-scope section given a second promotion into scope? | **Change from an implied-complete enumeration to an explicit "known, non-exhaustive" list.** The PR #891 re-review surfaced this exact failure mode: a residual list that reads as complete invites the next reviewer to assume anything not listed was checked and found safe, when in fact it was simply not yet reviewed. The reworded section states plainly that the list records what has been found so far, not a closed set, and folds in the newly named residuals (`workflow.rs` status/bulk-move text, `links.rs`, broadened `component.rs` surface, `board.rs`, `init.rs`) without claiming completeness. |

### 9.2 EC-15 fixture verification

Per this project's standing instruction (reinforced by the EC-13 correction in §7 and the
EC-14 verification discipline in §8.2) that every pinned EC literal must be checked against the
real state machine before being written into the spec, not merely asserted:

1. Read `sanitize_control_and_ansi_core` and `sanitize_table_cell`/`sanitize_terminal_text`
   directly from `.worktrees/FIX-P5-001/src/output.rs` (same state machine as §8.2: CSI scan
   `ESC [` then consume until the first byte in `\u{40}..=\u{7e}` or EOF; OSC scan `ESC ]` then
   consume until BEL `\u{7}` or `ESC \` or EOF; policy: `\n` keep, `\r` drop, `\t`→space, other
   C0/DEL/C1/bidi/line-separators drop, everything else keep).
2. Also read `handle_assign` (`.worktrees/FIX-P5-001/src/cli/issue/workflow.rs`, lines ~1006-1109)
   directly to locate the exact two messages that echo `display_name` and confirm the `--unassign`
   path's messages echo only `key`.
3. Hand-traced the EC-15 fixture `"\u{1b}]0;pwned\u{7}Mallory\u{1b}[2J"` character-by-character
   against the state machine, twice independently (see the BC body's EC-15 entry for the full
   trace): `\u{1b}]0;pwned\u{7}` is a complete OSC sequence (introducer `ESC ]`, `0;pwned` consumed
   scanning, BEL terminates) consumed wholesale; `Mallory` passes through character-by-character
   unchanged; `\u{1b}[2J` is a complete CSI sequence (`2` is not a final byte, `J` — `0x4A`, in
   `0x40`-`0x7E` — terminates it) consumed wholesale. Both independent traces converge on the
   identical result: `"Mallory"`, with no raw `ESC` byte, no BEL, no C1 code point, and none of the
   OSC/CSI parameter bytes surviving.

Result matches the fixture pinned in the BC body's EC-15 and this amendment's VP-SEC-001-001(c)
extension exactly. No correction was needed — the fixture was verified against the real
implementation before being written into the spec.

### 9.3 BC changes (full text in the file itself)

**File**: `.factory/specs/prd/bc-7-output-render.md`, `#### BC-7.1.006`

- **H1** enriched with a clause naming `jr issue assign`'s echoed assignee display name as an
  additional, explicit non-`render_table` covered sink (D-394, PR #891 re-review residual) — per
  this project's BC H1 Title Authority policy.
- **Behavior** opening sentence extended with a second "As of D-394 …" sentence alongside the
  existing D-393 one, and the "earlier revisions claimed … without qualification" sentence updated
  to name both `handle_comment_view` and `handle_assign`.
- **New Behavior subsection** ("`jr issue assign`'s human-output changed and idempotent messages
  are also an explicitly covered sink") specifying both `display_name`-echoing messages must route
  through `output::sanitize_terminal_text`; the `--unassign` path is explicitly out of scope
  (key-only, no server text); output FORMAT unchanged; `--output json` (`assign_changed_response`/
  `assign_unchanged_response`) unaffected.
- **Out-of-scope** paragraph and residual list reworded from an implied-complete enumeration to
  explicit "known, non-exhaustive," naming `jr issue assign` as now promoted into scope (alongside
  `jr issue comment view`) and adding the newly identified residual items: `workflow.rs`'s
  `move`-echoed status names and bulk-move error text (as a bullet distinct from the pre-existing
  transition-name-prompts bullet), `links.rs`'s link-type names, `component.rs`'s broadened
  rename/create/edit/list-warning/delete-confirmation name-echo surface, `board.rs`'s
  auto-discovery name, and `init.rs`'s interactive board-select items.
- **New EC-15** with the hostile display-name fixture above, full character-by-character trace,
  and the two-independent-trace verification method cited.
- **VP-SEC-001-001(c)** extended (not replaced) with the same EC-15 fixture exercised against
  `jr issue assign` under both `--output table` and `--output json`.
- **`**Trace**`** gains a new, LIVE (backticked, not pending-merge) citation:
  `src/cli/issue/workflow.rs::handle_assign`, with a note that the sanitizer wiring itself is not
  yet implemented. The pre-existing `handle_comment_view` citation's stale "does NOT exist yet"
  wiring note is also corrected here — see the next bullet.
- **Stale-item corrections flagged by the re-review**: (1) the D-393 `**Trace**` note stating
  `handle_comment_view`'s sanitizer wiring "does NOT exist yet" is updated to "implemented in
  FIX-P5-001 (PR #891), pending merge" — the re-review approved that fix, so the claim was stale;
  (2) the 1.1.0 version-history row's prose said the Out-of-scope residual list was "narrowed … to
  five entries" while the same sentence went on to name six (`project.rs`, `workflow.rs`,
  `sprint.rs`, `component.rs`, `field.rs`, `JrError`) — corrected in place to say "six" and
  cross-referenced to this row.
- **Version history** gains row `1.2.0` recording the D-394 provenance, the new EC/VP/Trace
  changes, and the two stale-item corrections.
- Frontmatter `trace:` gains a new dated history bullet; `total_bcs`/`definitional_count`
  unchanged (98/54) — no new BC, no new VP ID.

### 9.4 Bookkeeping performed in this amendment

- `.factory/specs/prd/bc-7-output-render.md`: all changes in §9.3 above.
- `.factory/specs/prd/BC-INDEX.md`: BC-7.1.006's title-column row updated to match the enriched
  H1 (per the BC H1 Title Authority policy) and gains the `handle_assign` source citation; no
  count change, so no frontmatter/section-header edits were needed.
- `.factory/specs/prd/CANONICAL-COUNTS.md`: **not touched** — no count change (BC/VP counts both
  unchanged).
- `.factory/spec-changelog.md`: new `## [2.5.3] - 2026-09-30` entry (PATCH) prepended above the
  existing `## [2.5.2]` entry, following the established template.
- Re-ran `scripts/check-spec-counts.sh`, `scripts/check-bc-cumulative-counts.sh`,
  `scripts/check-bc-citation-symbols.sh --bc-dir .factory/specs/prd`, and
  `scripts/check-bc-no-numeric-test-counts.sh` — see the orchestrating burst's report for exit
  codes.

### 9.5 Explicitly NOT touched in this amendment

Per task scope: `src/` (no implementation — `handle_assign`'s sanitizer wiring is a pending
F6/follow-up-PR obligation, not done in this spec-only burst), `STATE.md`, `STORY-INDEX.md`
(state-manager's responsibility), and no git commit was created.

### 9.6 Hand-off

- **Implementation follow-up on PR #891 (or a successor PR)** must: (1) route `handle_assign`'s
  `display_name` local through `output::sanitize_terminal_text` before both `output::print_success`
  calls (~L1084 idempotent, ~L1104 changed) in its table-mode arm; (2) add the EC-15 pinned test;
  (3) add the VP-SEC-001-001(c) end-to-end wiremock/mocked-user-search check for `jr issue assign`;
  (4) leave the `OutputFormat::Json` arm (`assign_changed_response`/`assign_unchanged_response`)
  untouched (already lossless/unsanitized, correctly); (5) leave the `--unassign` path untouched
  (no server-derived text to sanitize).
- **The other known, non-exhaustive residuals** (`workflow.rs` status/bulk-move text, `links.rs`,
  broadened `component.rs`, `board.rs`, `init.rs`, plus the pre-existing `project.rs`, `sprint.rs`,
  `field.rs`, `JrError` items) remain tracked under `NONTABLE-SERVER-TEXT-SANITIZE`, pending a
  future human decision on whether/when to close them — none are fixed by this amendment.
- **No BC array / story propagation needed** — BC-7.1.006 is still not anchored to any story.
- **No VP-INDEX/architecture propagation needed** — same rationale as §8.6 above; this project has
  no separate VP-INDEX or verification-architecture document.

## 10. Amendment (2026-09-30, PR #891 final security re-review, spec v2.5.4 PATCH, human decision D-395)

The PR #891 security re-review **approved** D-394's `jr issue assign` fix. In the same, final pass,
the reviewer identified **a third residual with the identical exposure class** (finding SEC-891-2,
MEDIUM, CWE-150/CWE-116): `disambiguate_user` (`src/cli/issue/helpers.rs`), the shared
user-disambiguation chokepoint, echoes server-supplied, user-editable `User.display_name`/
`email_address`/`account_id` unsanitized in two places — (a) its non-interactive
`MatchResult::ExactMultiple`/`Ambiguous` `JrError::UserError` messages (approx. L310-329,
L349-355 in `.worktrees/FIX-P5-001/src/cli/issue/helpers.rs`), and (b) its interactive
`dialoguer::Select` item labels (approx. L331-342, L356-361). `disambiguate_user` is reached from
four callers: `resolve_assignee` (`jr issue assign --to`), `resolve_assignee_by_project`
(`jr issue create`/`jr issue edit --assignee`), `resolve_user` (`jr issue list --assignee`), and
`mentions::resolve_at_name_candidate` (`@Name` mention resolution, shared by `jr issue create`,
`jr issue edit`'s description, `jr issue comment add`/`edit`, and JSM `jr issue create
--request-type`, per `src/cli/issue/mentions.rs` L167).

**A third sink found during this amendment's own code trace, not explicitly named in the
originating finding**: `disambiguate_user`'s `MatchResult::None` branch hands `all_names` — every
candidate `User`'s display name on the issue/project, not only ones that matched the query — to a
caller-supplied `none_msg_fn` closure. `resolve_assignee`'s and `resolve_assignee_by_project`'s
closures join `all_names` verbatim into their own `"… Found: …"` message text. This is a WIDER
exposure than the matched-duplicate branches above: any assignable user's hostile display name can
leak into an unrelated assignee-resolution error, merely by being assignable on the same
issue/project. `resolve_user`'s and `resolve_at_name_candidate`'s `none_msg_fn` closures do not use
`all_names` and are not affected by this branch.

**Human decision D-395 (2026-09-30):** fix the `disambiguate_user` residual (all three branches) in
PR #891 (same posture as D-393/D-394), sanitize each `User.display_name`/`email_address` value at
its point of embedding inside `disambiguate_user` itself (covering all four callers uniformly, with
no caller-side change required), and **FREEZE PR #891's scope as of this amendment** — this is the
last scope-expansion amendment PR #891 receives from security review; any further residual is
tracked in the known, non-exhaustive Out-of-scope list rather than triggering another PR #891
amendment.

### 10.1 Decisions

| Question | Decision |
|---|---|
| Amend BC-7.1.006 in place, or mint a new BC? | **Amend in place**, same rationale as D-393/D-394 in §8.1/§9.1: identical character policy, identical sanitizer function (`output::sanitize_table_cell` via its `sanitize_terminal_text` alias), same fix ID (`FIX-P5-001`/PR #891). A third scope expansion of one existing contract, not a new one. |
| New VP, or extend VP-SEC-001-001 again? | **Extend VP-SEC-001-001(c) again**, for the same reasons as §8.1/§9.1: keeps VP count delta at zero, keeps all proof obligations for this sink class in one place. Also adds a NEW unit-level check (not merely another end-to-end fixture slot), because `dialoguer::Select::interact()` requires a real TTY and is not subprocess-testable — picker-label coverage needs a factored-out, pure label-building helper to verify directly. |
| Spec version bump? | **PATCH, 2.5.3 → 2.5.4.** Adds one EC (EC-16, in two parts) and extends one VP part inside an EXISTING BC — no new BC, no new VP ID. Same classification precedent as 2.5.1 (§7), 2.5.2 (§8), and 2.5.3 (§9). |
| Does `disambiguate_user`'s Trace citation need "pending-merge, unbackticked" treatment? | **NO — same as `handle_comment_view` (§8.1) and `handle_assign` (§9.1).** `disambiguate_user` already exists on `develop` today; it gets a normal, live, backticked citation. What's pending is the SANITIZER WIRING inside it — the Trace entry says so explicitly. |
| Which values inside `disambiguate_user` get sanitized, and where? | **Every `display_name` and `email_address` value, sanitized once at its point of embedding inside `disambiguate_user` itself** — not at each of the four call sites. This includes the `None` branch's `all_names` list, sanitized BEFORE it is handed to the caller-supplied `none_msg_fn` closure, so `resolve_assignee`'s and `resolve_assignee_by_project`'s closures receive already-sanitized values with no code change on their part. `account_id` values are Jira-generated opaque identifiers, not free-form text, but are sanitized identically for chokepoint-discipline uniformity, mirroring D-393's rationale for `handle_comment_view`'s narrow-format fields. |
| Does `--output json` get a separate, unsanitized "lossless" treatment for this sink, the way `render_table`'s table/JSON asymmetry works? | **NO — this is the key design decision of this amendment.** Unlike `render_table`'s success-data JSON (a genuinely separate raw payload from the human-text rendering) and unlike `handle_assign`'s `assignee` JSON field (a separate raw value from its human-text message), `disambiguate_user`'s errors have only ONE underlying message string: `src/main.rs`'s top-level error handler builds BOTH `eprintln!("Error: {e}")` (human mode) and `{"error": e.to_string(), "code": <exit>}` (`--output json` mode) from the SAME `JrError::UserError` `Display` string (`#[error("{0}")]`). There is no separate structured-data consumer that depends on this prose message staying raw the way `#398`'s `changed_fields.description` or `handle_assign`'s `assignee` field do. Sanitizing the message once at construction time therefore sanitizes both channels identically — correctly closing CWE-150/CWE-116 for a downstream script or CI log viewer that surfaces `--output json`'s `"error"` text to a terminal (e.g. `jr … --output json \| jq -r .error`), which is exactly as exposed as the human-mode path. This decision is scoped to this ONE sink; `render_table`'s/`handle_comment_view`'s/`handle_assign`'s existing table/JSON success-data asymmetries are unchanged. |
| How to word the Out-of-scope section given a third promotion into scope? | **Narrow the lead sentence to name all three promotions (D-393/D-394/D-395) and state the scope freeze explicitly; narrow the generic "`JrError` bodies" bullet** to exclude `disambiguate_user`'s now-covered messages (other `JrError` bodies throughout the codebase remain residual). |

### 10.2 EC-16 fixture verification

Per this project's standing instruction (reinforced by the EC-13 correction in §7 and the EC-14/
EC-15 verification discipline in §8.2/§9.2) that every pinned EC literal must be checked against the
real state machine before being written into the spec, not merely asserted:

1. Read `sanitize_control_and_ansi_core` and `sanitize_table_cell`/`sanitize_terminal_text` directly
   from `.worktrees/FIX-P5-001/src/output.rs` (same state machine as §8.2/§9.2).
2. Read `disambiguate_user` directly from `.worktrees/FIX-P5-001/src/cli/issue/helpers.rs`
   (L276-376) to confirm the three echoing branches (`ExactMultiple` L303-346, `Ambiguous`
   L348-371, `None` L372-374) and their exact message/label formats, and its four callers:
   `resolve_user` (L386-417), `resolve_assignee` (L426-456), `resolve_assignee_by_project`
   (L466-501, all in `helpers.rs`), and `mentions::resolve_at_name_candidate`
   (`.worktrees/FIX-P5-001/src/cli/issue/mentions.rs` L107-184, which calls `disambiguate_user` at
   L167).
3. Confirmed `src/partial_match.rs::partial_match`'s exact-vs-substring semantics
   (`exact_matches` requires `candidate.to_lowercase() == query.to_lowercase()`; `Ambiguous`
   requires `candidate.to_lowercase().contains(query.to_lowercase())`) to verify which `MatchResult`
   variant each EC-16 sub-fixture actually exercises, rather than assuming.
4. Hand-traced EC-16a's two display names — `"\u{1b}[31mAlice\u{1b}[0m"` and
   `"Al\u{9b}ice\u{1b}]0;x\u{7}"` — character-by-character against the state machine (see the BC
   body's EC-16 entry for the full trace): both independently sanitize to the identical clean string
   `"Alice"`, confirming query `"al"` produces `MatchResult::Ambiguous` for both (neither raw string
   equals `"al"` exactly; both lowercased strings contain `"al"` as a contiguous substring — verified
   the C1-introducer case specifically, since `"al\u{9b}ice…"` still starts with the literal
   substring `"al"` even though `"alice"` is NOT contiguous within it).
5. Hand-traced EC-16b's two hostile emails — `"alice\u{1b}]0;pwned\u{7}@example.com"` and
   `"bob\u{9b}@example.com"` — against the state machine: both sanitize to
   `"alice@example.com"`/`"bob@example.com"` respectively. Confirmed the `ExactMultiple` branch
   (which alone carries `email`/`account_id`) requires the query to raw-exact-match (case
   insensitive) BOTH candidates' display names simultaneously — impossible for EC-16a's two
   DIFFERENT raw literals — so EC-16b uses a direct-fixture-construction scenario with both `User`
   records sharing byte-for-byte the same raw hostile display name, a valid and common unit-test
   construction pattern (bypassing the need for a human to literally type the hostile string as
   `--to`).

Both sub-fixtures match what is pinned in the BC body's EC-16 and this amendment's
VP-SEC-001-001(c) extension exactly. No correction was needed — verified against the real
implementation and the real `partial_match` classification logic before being written into the
spec.

### 10.3 BC changes (full text in the file itself)

**File**: `.factory/specs/prd/bc-7-output-render.md`, `#### BC-7.1.006`

- **H1** enriched with a clause naming `disambiguate_user`'s shared user-resolution disambiguation
  output as an additional, explicit non-`render_table` covered sink (D-395, PR #891's final
  scope-expansion amendment) — per this project's BC H1 Title Authority policy.
- **Behavior** opening sentence extended with a third "As of D-395 …" sentence alongside the
  existing D-393/D-394 ones, noting D-395 also freezes PR #891's scope; the "earlier revisions
  claimed … without qualification" sentence updated to name `handle_comment_view`, `handle_assign`,
  AND `disambiguate_user`.
- **New Behavior subsection** ("`disambiguate_user`'s shared user-resolution disambiguation output
  is also an explicitly covered sink") naming the four callers/commands, the three echoing branches
  (`ExactMultiple`, `Ambiguous`, and the wider `None`-branch `all_names` echo), and specifying
  sanitization happens once inside `disambiguate_user` at each value's point of embedding.
- **New dedicated paragraph** deciding `--output json`'s error envelope is NOT a separate lossless
  channel for this sink, contrasting it explicitly with `render_table`'s own table/JSON asymmetry
  and with `#398`'s precedent, and explaining why (one shared message string, not two independently
  sourced payloads).
- **Out-of-scope** lead sentence extended to name all three promotions (D-393/D-394/D-395) and state
  the PR #891 scope freeze; the generic "`JrError` bodies" residual bullet narrowed to exclude
  `disambiguate_user`'s now-covered messages.
- **New EC-16**, in two parts (16a `Ambiguous`-branch display-name sanitization; 16b
  `ExactMultiple`-branch email/account-id sanitization), with full character-by-character traces and
  the `partial_match`-classification verification cited above.
- **VP-SEC-001-001(c)** extended (not replaced) with (a) the non-interactive end-to-end check across
  all four `disambiguate_user` callers using EC-16a, (b) a `None`-branch `all_names` check, and (c) a
  NEW unit-level check of a factored-out label-building helper against EC-16b.
- **`**Trace**`** gains a new, LIVE (backticked, not pending-merge) citation:
  `src/cli/issue/helpers.rs::disambiguate_user`, naming all four unmodified call sites and noting
  the sanitizer wiring itself is not yet implemented.
- **Version history** gains row `1.3.0` recording the D-395 provenance, the new EC/VP/Trace changes,
  and the PR #891 scope freeze.
- Frontmatter `trace:` gains a new dated history bullet; `total_bcs`/`definitional_count` unchanged
  (98/54) — no new BC, no new VP ID.

### 10.4 Bookkeeping performed in this amendment

- `.factory/specs/prd/bc-7-output-render.md`: all changes in §10.3 above.
- `.factory/specs/prd/BC-INDEX.md`: BC-7.1.006's title-column row updated to match the enriched H1
  (per the BC H1 Title Authority policy) and gains the `disambiguate_user` source citation; no count
  change, so no frontmatter/section-header edits were needed.
- `.factory/specs/prd/CANONICAL-COUNTS.md`: **not touched** — no count change (BC/VP counts both
  unchanged).
- `.factory/spec-changelog.md`: new `## [2.5.4] - 2026-09-30` entry (PATCH) prepended above the
  existing `## [2.5.3]` entry, following the established template.
- Re-ran `scripts/check-spec-counts.sh`, `scripts/check-bc-cumulative-counts.sh`,
  `scripts/check-bc-citation-symbols.sh --bc-dir .factory/specs/prd`, and
  `scripts/check-bc-no-numeric-test-counts.sh` — see the orchestrating burst's report for exit
  codes.

### 10.5 Explicitly NOT touched in this amendment

Per task scope: `src/` (no implementation — `disambiguate_user`'s sanitizer wiring is a pending
F6/follow-up-PR obligation, not done in this spec-only burst), `STATE.md`, `STORY-INDEX.md`
(state-manager's responsibility), and no git commit was created.

### 10.6 Hand-off

- **Implementation follow-up on PR #891 (or a successor PR)** must: (1) sanitize each
  `User.display_name`/`email_address` value via `output::sanitize_terminal_text` at its point of
  embedding inside `disambiguate_user`'s `MatchResult::ExactMultiple`/`Ambiguous` non-interactive
  message construction and `dialoguer::Select` `labels`/`items` construction; (2) sanitize the
  `MatchResult::None` branch's `all_names` entries before handing the list to `none_msg_fn`;
  (3) factor the interactive-label-construction logic out into a small pure helper so it is
  unit-testable without `dialoguer::Select::interact()`'s blocking TTY call; (4) add the EC-16
  (16a/16b) pinned tests; (5) add the VP-SEC-001-001(c) end-to-end checks across all four callers
  plus the `None`-branch check plus the new unit-level label-helper check; (6) leave `--output
  json`'s error envelope construction in `src/main.rs` untouched (it already sanitizes correctly
  once the message itself is sanitized at its source, per this amendment's `--output json` decision
  — no separate JSON-specific change needed).
- **This closes the PR #891 security-review scope-expansion cycle.** D-395 freezes PR #891's scope:
  the OTHER known, non-exhaustive residuals (`project.rs`, `workflow.rs`'s transition prompts/
  move-status/bulk-move text, `links.rs`, `sprint.rs`, `component.rs`, `board.rs`, `init.rs`,
  `field.rs`, other `JrError` bodies) remain tracked under `NONTABLE-SERVER-TEXT-SANITIZE`, pending a
  future human decision on whether/when to close them — none are fixed by this amendment, and none
  will trigger a further PR #891 amendment; any future fix for them starts a new PR.
- **No BC array / story propagation needed** — BC-7.1.006 is still not anchored to any story.
- **No VP-INDEX/architecture propagation needed** — same rationale as §8.6/§9.6 above; this project
  has no separate VP-INDEX or verification-architecture document.
