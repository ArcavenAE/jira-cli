---
document_type: spec-delta
fix_id: FIX-P5-002
finding_id: F5-PASS1-BC-7.1.006-FINDINGS
severity: MEDIUM
cwe: ["CWE-150", "CWE-116"]
phase: F5
cycle: cycle-014
human_decision: D-396
decision_date: 2026-10-01
date: 2026-10-01
author: product-owner
new_bcs: []
amended_bcs:
  - BC-7.1.006
new_vps: []
amended_vps:
  - VP-SEC-001-001
related_files:
  - .factory/specs/prd/bc-7-output-render.md
  - .factory/specs/prd/BC-INDEX.md
  - .factory/spec-changelog.md
---

# Phase F5 Spec Delta — FIX-P5-002 (BC-7.1.006 / VP-SEC-001-001 pass-1 findings)

Companion to the cycle-014 F5 pass-1 adversarial review of `BC-7.1.006`/`VP-SEC-001-001`
(`.factory/specs/prd/bc-7-output-render.md`, spec v2.5.5 at the time of review). The review found
one real, unfixed gap in the shipped PR #891 code (CR-1: single-line sinks never neutralize an
embedded `\n`), one inaccurate premise about `render_table_with_styles`'s color-gating that this
delta corrects by stating the verified truth instead (CR-2), and five further findings (F-001
through F-006 as labeled in the human decision brief) — a caller-list error, a color-behavior
wording gap, a missing documented exception, a false claim about `Ambiguous`-branch
distinguishability, and test-alignment/cleanup items. **This is a distinct fix task from PR #891's
security-review scope expansion (D-393/D-394/D-395), which is explicitly frozen** — D-396 is a
separate human decision addressing a separate adversarial pass, not a further PR #891 amendment.

**Human decision D-396 (2026-10-01):** fix the spec now (this delta); implementation (the new
`output::sanitize_terminal_line` function, its call-site wiring at the sinks named below, AND the
new `output::render_table_with_styles` `SHOULD_COLORIZE` gate per CR-2 below — "move the
`--no-color` check into the styled-table API") is a pending FIX-P5-002 implementation obligation,
not done in this spec-only burst. Zero `src/` production files touched by this delta.

**Correction to this delta's own first draft (same burst, before any implementation started):**
CR-2 was initially written as a description of today's code (`render_table_with_styles` applies
`fg` unconditionally; only `active_cell` gates on `SHOULD_COLORIZE`) and left there as if that
were the final specification. It is not — D-396 is a REQUIRED BEHAVIOR CHANGE the human approved
("move the `--no-color` check into the styled-table API"), not merely a documentation fix about
current behavior. The description of today's code is accurate and is kept as the BEFORE state,
but the BC body, this delta, the spec-changelog entry, and BC-INDEX were all revised in this same
burst to specify the NEW required behavior instead. See the revised §1 table row below.

## 1. Summary of findings and dispositions

| # | Finding | Disposition |
|---|---|---|
| F-001 | Caller-list error: `jr issue edit --assignee` named in D-395's text does not exist as a flag; `jr issue list --reporter` was omitted. | **Spec correction.** Verified by grep against `src/cli/mod.rs` (`IssueCommand::Edit` has no assignee-setting flag of any kind) and `src/cli/issue/list.rs` (`resolve_user` is called for BOTH `--assignee` and `--reporter`). Corrected in H1, Behavior (`disambiguate_user` subsection), Out-of-scope lead, Trace, and VP(c). The four underlying callers are unchanged — only the flags naming them were wrong. |
| CR-1 | Single-line vs. multi-line sinks: `sanitize_table_cell`/`sanitize_terminal_text` preserve `\n`, which is correct for genuinely multi-line sinks but lets a hostile value with an embedded `\n` fabricate an extra line/field/picker item in a sink that is supposed to render exactly one line. | **New function.** `output::sanitize_terminal_line` (NOT YET IMPLEMENTED — F6/follow-up-PR target): identical policy to `sanitize_table_cell` except `\n`→single space (mirrors the existing `\t` substitution; consecutive `\n` → consecutive spaces, no collapsing, simplest option). Re-routes `handle_comment_view`'s six labeled fields, `handle_assign`'s two messages, and `disambiguate_user`'s non-interactive messages/interactive labels. `render_table`/`render_table_with_styles` cells and `handle_comment_view`'s ADF body block are UNCHANGED (genuinely multi-line). New **(EC-17)**, two parts, with before/after contrast against pre-D-396 behavior. Full sink→function mapping table added to the BC body. |
| CR-2 | Color gating: human decision D-396 — "move the `--no-color` check into the styled-table API." | **Required behavior change, NOT YET IMPLEMENTED.** `output::render_table_with_styles` MUST apply a `StyledCell`'s `fg` only when `colored::control::SHOULD_COLORIZE.should_colorize()` is true, making `--no-color`/`NO_COLOR` suppression structural for every `StyledCell` caller. `active_cell` keeps its own existing `SHOULD_COLORIZE` check, unchanged (harmless redundancy); `render_table_with_styles`'s gate is the new authoritative one. `comfy_table`'s own TTY-based `should_style()` gate is unchanged and still applies on top (ANDed). TODAY's code (verified against `src/output.rs`/`src/cli/user.rs`): `render_table_with_styles` applies `fg` unconditionally; `active_cell` is the only current gate — this is the BEFORE state the fix changes, not the final spec. Two new test targets: `test_bc_7_1_006_render_table_with_styles_suppresses_fg_when_colorize_disabled` and `test_bc_7_1_006_render_table_with_styles_applies_fg_when_colorize_enabled`. The Out-of-scope residual from this delta's first draft is RETRACTED — it is now a required fix, not an accepted gap. |
| F-006 | Active-column color-behavior wording. | **Precise wording added**, folded into the CR-2 subsection: color requires a TTY (comfy_table's gate, structural); suppressed by `--no-color`/`NO_COLOR` (via `active_cell`'s check, not structural); `CLICOLOR_FORCE` with piped stdout no longer colors it — verified via `colored` 3.1.1's `ShouldColorize::resolve_clicolor_force` (CLICOLOR_FORCE bypasses TTY in `should_colorize()`) crossed with `comfy-table` 7.2.2's `Table::should_style()`/`is_tty()` (TTY-only, no CLICOLOR_FORCE awareness) — a genuine, minor, documented behavior change from pre-#891's ANSI-bytes-in-`String` styling (which bypassed comfy_table's gate entirely). |
| F-004 | `jr api`'s raw passthrough — residual or exception? | **Documented exception, not a residual.** New sentence added: `src/cli/api.rs::handle_api` writes the raw response body via `std::io::stdout().write_all`, by design, `gh api`-parity; never sanitized, never will be. |
| F-005 | EC-16a's claim that the picker/message "still distinguishes the two accounts by their email/account-id fields" even when display names collide. | **Retracted — FALSE for the `Ambiguous` branch.** Verified against `disambiguate_user`'s `MatchResult::Ambiguous` arm: it carries `display_name` ONLY, never `email_address`/`account_id` (only `ExactMultiple` carries those). Recorded as a known limitation with a tracked follow-up (add email/accountId to `Ambiguous` labels) — new Out-of-scope residual item, not fixed by this BC. |
| F-002 | VP(c)/EC-16 alignment with the tests FIX-P5-002 will add; "one shared assertion helper" claim. | **Five new test targets named** (verified none exist yet, by grep against `tests/table_output_sanitization.rs` and `src/cli/issue/helpers.rs`): (a) `issue list --assignee` `Ambiguous`, (b) `@Name` mention `Ambiguous`, (c) `Ambiguous` `--output json` error-envelope case, (d) `ExactMultiple` with a hostile DISPLAY NAME (not just hostile email/account_id), (e) EC-17b's `disambiguation_labels` fixture. "One shared assertion helper" claim REMOVED — verified no such helper exists; each test is an independent function. |
| F-003 | Tracked residual: `create.rs`'s `--to` success echo. | **New Out-of-scope residual added.** `src/cli/issue/create.rs::handle_create`'s field-echo loop (~L448, `eprintln!("  {} → {}", field, value)`) echoes the raw, unsanitized `create_echo` assignee `display_name` (~L353) and `resolved_team_name` (~L328) — same exposure class as the now-covered `handle_assign` sink, found during this amendment's own trace. NOT fixed by this BC. |

## 2. Why this is a PATCH, not MINOR

No new BC, no new VP ID — `BC-7.1.006` and `VP-SEC-001-001` are both amended in place. Per
`.factory/spec-changelog.md`'s Type legend ("PATCH = amendments to existing bodies/ACs/ECs"), and
consistent with precedent (D-393/D-394/D-395 each added a new EC — EC-14/15/16 — under PATCH, not
MINOR, since none added a new BC/VP ID). Spec version 2.5.5 → **2.5.6**.

## 3. Verification method

Every claim in this delta was verified against the actual `develop`-branch code (commit
`769365ab`, PR #891's merge) before being pinned, per the task's explicit instruction, NOT assumed
from the human decision brief's wording:

- F-001: `grep -n "assignee" src/cli/mod.rs` — confirmed `IssueCommand::Edit` (`src/cli/mod.rs`
  line ~510) has no assignee-setting flag; `IssueCommand::Create` has `--to`/`--account-id`
  (line ~473); `resolve_assignee_by_project`'s sole call site is `src/cli/issue/create.rs:350`;
  `resolve_user` is called from `src/cli/issue/list.rs:302` (`--assignee`) AND `:307`
  (`--reporter`).
- CR-1: traced `"Eve\nRestricted: None"` and `"Mallory\nEve"` character-by-character through
  `sanitize_control_and_ansi_core` (`src/output.rs`) with the proposed `sanitize_terminal_line`
  policy — both produce the stated single-line outputs; confirmed via `src/output.rs::
  sanitize_terminal_text`'s current implementation (a bare alias of `sanitize_table_cell`, `\n`
  Keep) that the pre-D-396 code genuinely preserves the hazard.
- CR-2/F-006: read `src/output.rs::render_table_with_styles`/`StyledCell` to confirm TODAY's code
  has no `SHOULD_COLORIZE` check inside it, and `src/cli/user.rs::active_cell` (today's only
  gate, with its own rustdoc already stating this is caller-responsibility) — establishing the
  BEFORE state D-396's required change supersedes; `colored` 3.1.1's `src/control.rs`
  (`ShouldColorize::should_colorize`/`resolve_clicolor_force`), and `comfy-table` 7.2.2's
  `src/table.rs` (`Table::should_style`/`is_tty`, no CLICOLOR_FORCE awareness) confirm the F-006
  wording is unaffected by where the `SHOULD_COLORIZE` check lives.
- F-004: read `src/cli/api.rs::handle_api` (~L263-266, `std::io::stdout().write_all(&body_bytes)`).
- F-005: read `disambiguate_user`'s `MatchResult::Ambiguous` arm (`src/cli/issue/helpers.rs`
  ~L390-417) — confirmed no `email_address`/`account_id` access in that branch.
- F-002: `grep` against `tests/table_output_sanitization.rs` for `issue_list.*assignee`,
  `mention.*ambiguous`, `ambiguous.*json`, and against both that file and
  `src/cli/issue/helpers.rs` for a shared assertion helper — none found in either case.
- F-003: read `src/cli/issue/create.rs` ~L340-451 (`create_echo` population and the table-mode
  field-echo loop).

## 4. Bookkeeping performed in this amendment

- `.factory/specs/prd/bc-7-output-render.md`: all changes in §1 above; `last_updated` bumped to
  2026-10-01; new frontmatter `trace:` bullet; version-history table row `1.4.0` added.
- `.factory/specs/prd/BC-INDEX.md`: BC-7.1.006's title-column row updated to reflect the corrected
  caller list and the new `sanitize_terminal_line` function; Source column gains
  `src/output.rs::sanitize_terminal_line (proposed, FIX-P5-002, not yet implemented)`. No count
  change, so no frontmatter/section-header edits were needed.
- `.factory/specs/prd/CANONICAL-COUNTS.md`: **not touched** — no count change (BC/VP counts both
  unchanged).
- `.factory/spec-changelog.md`: new `## [2.5.6] - 2026-10-01` entry (PATCH) prepended above the
  existing `## [2.5.5]` entry.
- Ran `scripts/check-spec-counts.sh`, `scripts/check-bc-cumulative-counts.sh`,
  `scripts/check-bc-citation-symbols.sh --bc-dir .factory/specs/prd`, and
  `scripts/check-bc-no-numeric-test-counts.sh` — see the orchestrating burst's report for exit
  codes. `output::sanitize_terminal_line` is cited unbackticked throughout (NOT YET
  IMPLEMENTED/proposed), so the citation-symbols guard does not flag it stale.

## 5. Explicitly NOT touched in this amendment

Per task scope: `src/` (no implementation — `sanitize_terminal_line` and its call-site wiring are
a pending F6/follow-up-PR obligation), `STATE.md`, `STORY-INDEX.md` (state-manager's
responsibility), and no git commit was created.

## 6. Hand-off

- **Implementation follow-up (FIX-P5-002 or a successor PR)** must: (1) add
  `output::sanitize_terminal_line` to `src/output.rs` (identical policy to `sanitize_table_cell`,
  `\n`→`CharDisposition::Replace(' ')`); (2) re-route `handle_comment_view`'s six labeled fields
  (`src/cli/issue/interactions.rs`), `handle_assign`'s two messages
  (`src/cli/issue/workflow.rs`), and `disambiguate_user`'s non-interactive messages + interactive
  labels (`src/cli/issue/helpers.rs`, including `disambiguation_labels`) from
  `sanitize_terminal_text`/`sanitize_table_cell` to `sanitize_terminal_line`; (3) leave
  `handle_comment_view`'s ADF body block and all `render_table`/`render_table_with_styles` cells
  on `sanitize_table_cell`/`sanitize_terminal_text` (multi-line, unchanged); (4) add the five new
  test targets named in VP-SEC-001-001(c)'s D-396 addition, plus EC-17's two pinned tests; (5)
  add a `colored::control::SHOULD_COLORIZE.should_colorize()` check INSIDE
  `output::render_table_with_styles` itself, gating each `StyledCell`'s `fg` application on it
  (apply `fg` only when `true`; otherwise build the `Cell` as if `fg` were `None`) — this is a
  REAL, REQUIRED code change (D-396, CR-2), not a documentation-only item; `active_cell` itself
  is left UNCHANGED (keeps its own existing check; the resulting redundancy for this one caller
  is intentional and harmless); `comfy_table`'s own TTY-based `should_style()` gate is also left
  UNCHANGED, since it continues to apply independently on top; (6) add the two new CR-2 test
  targets (`test_bc_7_1_006_render_table_with_styles_suppresses_fg_when_colorize_disabled` and
  `test_bc_7_1_006_render_table_with_styles_applies_fg_when_colorize_enabled`) to `src/output.rs`'s
  `tests` module, each needing a test-accessible way to force comfy_table's own TTY-based styling
  gate ON (e.g. a test-only `enforce_styling()` call on the internally-built `Table`) so the new
  `SHOULD_COLORIZE` gate can be exercised in isolation from the ambient non-TTY test harness.
- **No BC array / story propagation needed** — BC-7.1.006 is still not anchored to any story.
- **No VP-INDEX/architecture propagation needed** — same rationale as FIX-P5-001's §8.6/§9.6/
  §10.6; this project has no separate VP-INDEX or verification-architecture document.
- **Does not reopen or extend PR #891's frozen scope.** D-396 is a new, separate fix task; the
  `sanitize_terminal_line` implementation should land as a NEW PR (or a new commit on a NEW
  branch), not a reopening of the merged PR #891.

## 7. Post-merge amendment (2026-10-01, spec v2.5.7, PATCH)

FIX-P5-002 (PR #894) merged to `develop` as `cc19c2f9`. Sections 1-6 above are the dated
pre-implementation record and are left as written (their "NOT YET IMPLEMENTED"/"pending" wording
described the state at that burst). Current state:

- `output::sanitize_terminal_line` is implemented (`src/output.rs::sanitize_terminal_line`) and
  wired at the CR-1 sinks.
- The CR-2 gate is implemented in `src/output.rs::render_table_with_styles_inner`; its two test
  targets exist as `src/output.rs::test_bc_7_1_006_render_table_with_styles_suppresses_fg_when_colorize_disabled`
  and `src/output.rs::test_bc_7_1_006_render_table_with_styles_applies_fg_when_colorize_enabled`.
- `BC-7.1.006` (frontmatter `trace:`, VP-SEC-001-001(c), version row `1.4.1`) and BC-INDEX were
  converted to present tense with live citations (closes pass-2 finding `P2-003`).

### 7.1 Out-of-scope code change shipped in PR #894 (hand-off note, no spec behavior impact)

PR #894 also carried one change unrelated to BC-7.1.006: a clippy fix in `tests/e2e_live.rs`
(commit "fix(ci): remove needless borrow in tests/e2e_live.rs (unrelated clippy toolchain-drift
fix, blocks PR #894's CI gate)").

- **Lint:** `clippy::needless_borrows_for_generic_args`, flagged by a newer `stable` clippy on
  code unchanged by this fix: `.map(&norm)` became `.map(norm)` at two call sites (the
  `node.get("text").and_then(Value::as_str).map(...)` comparison and a second `.map(...)` chain).
- **Cause:** toolchain drift. CI clippy runs under whatever `stable` GitHub Actions resolves that
  day (`rust-toolchain.toml` `channel = "stable"`, no pin); a newer release added/expanded the lint.
  Not caused by any FIX-P5-002 logic.
- **Why in this PR:** it blocked PR #894's `ci-gate`; fixed ad hoc rather than splitting a one-line
  unrelated PR.
- **Spec impact:** none. No BC/VP covers `tests/e2e_live.rs` borrow style; test behavior unchanged.
- **Follow-up:** the root cause (unpinned clippy toolchain) is tracked as standing item
  `CI-CLIPPY-TOOLCHAIN-PIN` in `.factory/cycles/OPEN-STANDING-ITEMS.md`. This note is the
  cross-reference; the fix itself (pinning) is not done here.
