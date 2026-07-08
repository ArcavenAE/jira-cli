# PR #594 Review — docs/571-changelog-code-mark-exclusivity

## Verdict: APPROVE

Doc-only PR. Single-file addition to `CHANGELOG.md`, one entry under
`[Unreleased] > Fixed` documenting the ADF code-mark exclusivity fix that
shipped in PR #593 (BC-7.2.015, closes #571).

## Scope

- **Files changed:** `CHANGELOG.md` (+9 lines, 0 removed)
- **Placement:** `[Unreleased] > Fixed`, correctly above `Changed`/existing
  `Fixed` blocks.
- **Code touched:** none.

## Factual verification (against `src/adf.rs::push_code`, lines 1281–1324)

- **"operates on a clone of `active_marks`"** — Verified. `self.active_marks.iter().filter(...).cloned().collect()` produces a new `Vec<Value>`; `self.active_marks` is not mutated.
- **Allowlist retains `link` and `annotation`** — Verified. `matches!` arm uses `Some("link")` OR `Some("annotation")`. Exact match to the CHANGELOG claim.
- **Strips `strong`, `em`, `strike`, `subsup`** — Verified. Implicit via allowlist exclusion. Correct.
- **"Defensive" `underline` / `textColor` / `backgroundColor`** — Verified. Also excluded by allowlist. Not currently emitted by `markdown_to_adf`, but stripped defensively per the same allowlist. Wording is accurate.
- **BC ref `BC-7.2.015`, issue `#571`** — Verified. Matches inline `// BC-7.2.015 (issue #571)` comment at line 1304.
- **`code_inline_node` schema forbids typographic marks** — Verified. Consistent with the pre-existing CLAUDE.md note under adf.rs §"Markdown minor constructs" and the `code` plus other-mark limitation there.
- **Failure patterns `` **`x`** `` and `` ^`x`^ ``** — Verified. Exact patterns previously called out as follow-ups in the CLAUDE.md subsup/heading-attrs entry.
- **"`adf_to_text` stays read-lenient by design"** — Verified. The reverse path is not modified in PR #593.
- **PR reference `(#593)`** — Verified. Matches provided context (code fix already merged).

## Format vs. precedent

Compared against `#522` (BC-7.2.011, lines 170–176) and `#492`
(BC-7.2.011, lines 177–182) entries:

- Bold lead phrase — matches.
- Parenthetical `(BC-<id>, #<issue>):` — matches.
- Prose body describing mechanism + failure symptom + Jira HTTP 400 — matches.
- Trailing `(#<pr>)` — matches.
- Line-wrap width — consistent with surrounding entries.

## Findings

None (blocking or non-blocking).

The entry is accurate, well-cited to the corresponding code, and
stylistically consistent with the immediately preceding ADF-mark-exclusivity
fix entries.
