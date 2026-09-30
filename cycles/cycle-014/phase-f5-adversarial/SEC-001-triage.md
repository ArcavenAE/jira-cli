# SEC-001 Triage — `output::render_table` ANSI/Control-Character Sanitization

**Finding ID:** `SEC-001-RENDER-TABLE-ANSI-SANITIZE`
**Severity:** MEDIUM (CWE-150 improper neutralization of escape/control sequences; CWE-116
improper encoding or escaping of output)
**Surfaced:** cycle-014 F4-completion combined wave integration gate, security review step (d)
(`cycles/cycle-014/wave-integration-gate.md`); recorded as a standing item in
`cycles/OPEN-STANDING-ITEMS.md`.
**Disposition:** Human decision **D-392** (2026-09-30) — FIX inside cycle-014, during F5, rather
than defer. Tracked as fix task **FIX-P5-001**, routed via `fix-pr-delivery`. F5's first routed
finding.
**Reviewer:** security-reviewer (read-only triage — this document, no code/spec writes).
**Spec delta implementing this triage:** `BC-7.1.006` in
`.factory/specs/prd/bc-7-output-render.md`, inline `VP-SEC-001-001`. Spec version 2.4.0 → 2.5.0.
Full spec-delta note: `cycles/cycle-014/phase-f5-adversarial/FIX-P5-001-spec-delta.md`.

---

## 1. Problem

Table-rendered server strings passed through `output::render_table` are not ANSI-escape or
control-character sanitized before being written to the terminal. A malicious or compromised
Jira project (or a response tampered with before TLS termination) can embed raw ANSI CSI/OSC
sequences or control characters in any server-supplied field that reaches a table cell — an
issue summary, a field option label, a comment body fragment, a display name — and redraw the
user's terminal, rewrite the window title, or otherwise manipulate terminal state via a rendered
cell. This is **pre-existing and codebase-wide**, not introduced by any single command. Cycle-014
STORY-B (`#888`) slightly widened exposure by rendering more system-field `name` values through
this path (previously many of those cells rendered `null`/were absent).

## 2. Design Decision

**Sanitize inside `src/output.rs::render_table`.** It is the single comfy_table chokepoint with
9 production call sites (inventory in §4 below), so fixing it here covers every table-mode
command in one change rather than sweeping call sites individually. This mirrors the existing
`sanitize_env_display` precedent already used elsewhere in the codebase for a similar class of
untrusted-string display.

### New function: `output::sanitize_table_cell(&str) -> String`

Called on every header string and every cell string before either reaches
`comfy_table::Table::set_header`/`add_row`. Headers are sanitized too, for defense in depth, even
though every header in this codebase today is a `&'static str` literal with nothing to strip — a
no-op in practice, not a behavior change for any existing header.

Per-character policy, applied left to right over each cell/header string:

| Input | Treatment | Rationale |
|-------|-----------|-----------|
| `\n` (U+000A) | **Preserved verbatim** | Only mechanism by which a multi-line cell renders (issue view Description/Links, comment Body — see §4 multi-line sinks) |
| `\r` (U+000D) | **Stripped outright**, nothing substituted | `\r\n` collapses to `\n`; bare `\r` disappears with no trace |
| `\t` (U+0009) | **Replaced with a single space** | Deliberately differs from outright C0 stripping — dropping a tab entirely can merge flanking words into a materially different string (e.g. `"rm -rf /\thome"` → `"rm -rf /home"` if dropped, vs. the safe `"rm -rf / home"` if space-substituted) |
| Other C0 controls (`0x00`-`0x08`, `0x0B`-`0x1F`) and `0x7F` (DEL) | **Stripped outright** | Standard control-char removal |
| ANSI CSI (`ESC [ … <final 0x40-0x7E>`) / OSC (`ESC ] … <BEL or ST>`) | **Consumed and stripped wholesale**, reusing `strip_control_and_ansi`'s existing state machine verbatim | Same fail-closed behavior as the existing sanitizer: an unterminated sequence consumes through EOF — no raw `ESC` byte ever survives, at the cost of discarding legitimate trailing text after a malformed sequence |
| C1 controls `U+0080`-`U+009F` (incl. single-byte CSI introducer `U+009B`, OSC introducer `U+009D`) | **Stripped as a class** (single-code-point removal, not a second state machine) | **New relative to `strip_control_and_ansi`**, which has no C1 handling — a documented, pre-existing gap on that function (see §5 follow-ups). Bytes that would have continued a sequence started by a stripped C1 introducer are NOT consumed as part of a sequence — they survive as inert literal text |
| Bidi overrides `U+202A`-`U+202E`/`U+2066`-`U+2069`, plus `U+2028`/`U+2029`/`U+0085` | **Stripped** | Same Unicode terminal-injection code-point set `strip_control_and_ansi` already strips for `sanitize_env_display` |
| Everything else (printable, incl. non-ASCII: é, CJK, emoji) | **Unchanged, no length cap** | Unlike `sanitize_env_display`'s capped-and-marked behavior — ordinary long clean text passes through byte-for-byte |

**`--output json` is never sanitized.** `render_json`/`print_output`'s `OutputFormat::Json` arm
never calls `sanitize_table_cell` and continues to emit whatever the server sent, byte-for-byte.
Same channel asymmetry as `sanitize_env_display` and the issue #398 description-echo precedent
already codified in CLAUDE.md: the human channel optimizes for terminal safety/scannability, the
machine channel must stay lossless for programmatic consumers.

### `format_active` color relocation

`jr user list`/`jr user view`'s Active column (`src/cli/user.rs::format_active`, lines 164-165)
currently embeds ANSI color bytes directly into the returned `String` cell content via the
`colored` crate's `.to_string()` (green `"✓"`, red `"✗"`). Once `render_table` sanitizes every
cell, those embedded ANSI bytes would themselves be stripped by this same fix, silently breaking
jr's own intentional coloring. **Fix:** move the styling to structural `comfy_table::Cell`
attributes (`Cell::new("✓").fg(Color::Green)` / `Cell::new("✗").fg(Color::Red)`), with the plain
glyph still passing through `sanitize_table_cell` like any other cell content — never as ANSI
bytes baked into a `String`. This is the general rule going forward for any future jr-authored
styled cell content, not a one-off for this caller, since a server-supplied string can now never
itself produce a colored cell.

## 3. Out of Scope — Follow-ups Recorded, Not Fixed Here

- **Non-table server-text sinks** (same CWE class, no shared chokepoint — `NONTABLE-SERVER-TEXT-SANITIZE`):
  - `src/cli/project.rs` project name lists (printed outside the table-render path)
  - `src/cli/issue/workflow.rs` transition-name interactive prompts (`dialoguer::Select` option labels)
  - `src/cli/sprint.rs`'s summary hint line
  - `src/cli/component.rs`'s delete-confirmation description echo
  - `src/cli/field.rs::normalize_or_degrade`'s graceful-degrade hint (BC-X.14.004)
  - `JrError` bodies that echo raw server text into stderr error messages
- **`sanitize_env_display`'s own pre-existing C1 gap** (`SANITIZE-ENV-DISPLAY-C1-GAP`):
  `strip_control_and_ansi` strips no C1 controls (`U+0080`-`U+009F`), unlike this fix's
  `sanitize_table_cell`. Separate, narrower-audience function (a single profile `env` tag, not
  general table content) — not modified by this fix.
- **`CANONICAL-COUNTS.md`'s "L2 domain-spec bc_count alignment" table row for bc-7** (~L271):
  already stale before this delta (read `93`, should have read `97`); now further stale at `98`.
  Pre-existing drift, unrelated to this fix's substance, not covered by `check-bc-cumulative-counts.sh`
  (that guard validates Surfaces A-H only, not this narrative table). Tracked as
  `CANONICAL-COUNTS-L2-BC7-ALIGNMENT-STALE`.

All four items are recorded in `cycles/OPEN-STANDING-ITEMS.md`, targeted at a future maintenance
sweep.

## 4. Full Sink Inventory

### `render_table` production call sites (9 total — all covered by this fix)

| # | Site | Context |
|---|------|---------|
| 1 | `src/output.rs:35` | `print_output`'s `OutputFormat::Table` arm — the chokepoint itself |
| 2 | `src/cli/auth/list.rs:92` | `auth list` — NAME/URL/ENV/AUTH/STATUS table |
| 3 | `src/cli/issue/view.rs:322` | `issue view` — Field/Value detail table |
| 4 | `src/cli/issue/attachments.rs:255` | attachment command family (list path 1) |
| 5 | `src/cli/issue/attachments.rs:1242` | attachment command family (list path 2) |
| 6 | `src/cli/issue/attachments.rs:2104` | attachment command family — ID/Filename/Size/Created (human rows) |
| 7 | `src/cli/issue/attachments.rs:2227` | attachment command family — ID/Filename/Size/Created (table rows) |
| 8 | `src/cli/assets/schemas.rs:318` | `assets schemas` — Pos/Name/Type/Required/Editable table |
| 9 | `src/cli/assets/view.rs:53` | `assets view` — Field/Value detail table |
| 10 | `src/cli/assets/view.rs:84` | `assets view` — Attribute/Value table (nested attrs) |

(`src/output.rs:183` is a test-only call site inside `#[cfg(test)] mod tests` — not a production
sink, excluded from the count above and unaffected by any production-path change.)

### Non-`render_table` coloring sink (must migrate, not a `render_table` call site)

| Site | Context |
|------|---------|
| `src/cli/user.rs:164-165` (`format_active`) | Active column ✓/✗ ANSI-in-`String` coloring — must move to structural `Cell` attributes per §2 |

### Multi-line cell sinks (value the `\n`-preserve rule protects)

| Site | Context |
|------|---------|
| `src/cli/issue/view.rs:270-272` | Links cell — `.join("\n")` of multiple link descriptions |
| `src/cli/issue/view.rs:115-120` | issue view row assembly entering the Table arm |
| `src/cli/issue/format.rs:164-177` | `format_comment_row` — comment Body cell (multi-line comment text) |

### Existing table snapshot coverage

Only **one** table-mode `insta` snapshot exists on disk:
`src/cli/auth/tests/snapshots/jr__cli__auth__tests__list_table_snapshot.snap` (`auth list`). Its
fixture data contains no control/ANSI characters, so it is **unaffected** by this fix — no
snapshot update required as a direct consequence of `sanitize_table_cell`'s introduction.

## 5. Test Fixtures Table (EC-1..EC-12, from BC-7.1.006)

| EC | Fixture input | Expected `sanitize_table_cell` output |
|----|----------------|----------------------------------------|
| EC-1 | `"\x1b[31mRED\x1b[0m"` | `"RED"` |
| EC-2 | `"before\x1b]0;pwned\x07after"` | `"beforeafter"` |
| EC-3 | `"before\x1b[31;1;9"` (unterminated CSI) | `"before"` (sequence + trailing text dropped to EOF) |
| EC-4 | `"pre\u{202e}mid\u{202e}post"` | `"premidpost"` |
| EC-5 | `"pre\u{9b}31mFAKE\u{9b}0mpost"` | `"pre31mFAKE0mpost"` (C1 introducer removed singly; survivor bytes literal) |
| EC-6 | `"pre\u{0}post"` | `"prepost"` |
| EC-7 | `"pre\rpost"` | `"prepost"` |
| EC-8 | `"line1\r\nline2"` | `"line1\nline2"` |
| EC-9 | `"line1\nline2"` | `"line1\nline2"` (unchanged) |
| EC-10 | `"a\tb"` | `"a b"` |
| EC-11 | long clean printable string (incl. é, CJK, emoji) | unchanged, no truncation |
| EC-12 | any EC-1..EC-10 hostile payload, via `--output json` | raw/unsanitized in JSON stdout (never routed through `sanitize_table_cell`) |

End-to-end fixtures (VP-SEC-001-001(c)): `jr field options` against a fixture whose option label
carries a hostile ANSI/OSC payload, and `jr issue list` against a fixture whose issue summary
carries the same payload — both asserting no raw `ESC` byte / no C1 UTF-8 encoding reaches
`--output table` stdout, while the identical fixtures under `--output json` assert the raw
hostile payload IS present byte-for-byte.

## 6. Verification Properties

- **VP-SEC-001-001** (inline in BC-7.1.006): (a) property-based whole-string invariant over an
  arbitrary generated `String` — no C0 control other than `\n`, no C1 control, no raw `ESC`, no
  `\r`, no `\t`, none of the bidi/line/paragraph-separator code points; every `\n` survives in
  order; identity on printable-plus-`\n` input. (b) example-based pins, one per EC-1..EC-12
  (§5 table above). (c) end-to-end wiremock check across both output modes (§5).

## 7. Next Steps (not performed by this triage — read-only)

Implementation is an F6/F7 obligation of this cycle, tracked as `FIX-P5-001`:
1. Fix worktree `.worktrees/FIX-P5-001` on branch `fix/FIX-P5-001`.
2. Failing tests first (proptest + EC-1..EC-12 pins + `format_active` `Cell`-styling test + the
   end-to-end wiremock check), then implementation, then PR review + security review + demo + PR
   to merge-ready + human merge (per `fix-pr-delivery`).
3. After merge: resume the F5 delta adversarial loop over `204b1fb5..<new develop>` (adversary +
   code-reviewer + security-reviewer, 3 consecutive clean passes, 10-pass cap).
