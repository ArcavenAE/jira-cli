## Fresh-Eyes Review — PR #622

**Verdict: APPROVED**

Docs-only change (+3 lines, 1 file: `README.md`). All three new README command-table rows were spot-checked against the actual CLI help output from the pre-built debug binary in the worktree (`target/debug/jr`). Every documented flag exists and the descriptions are accurate.

### Row spot-checks (all CONFIRMED)

| Row | Verified against `--help` | Result |
|-----|--------------------------|--------|
| `comment delete KEY --id ID` | `--id`, `--yes` present; help: "requires --yes or interactive confirmation" | Accurate |
| `comment edit KEY --id ID "msg"` | `--stdin`, `--file`, `--markdown`, `--internal`, `--public`, `--yes` all present | Accurate |
| `comment view KEY --id ID` | `--id` present; view handler renders `JSM internal:` + `Restricted:` fields (`interactions.rs` `format_restricted_field`/`format_jsm_internal_field`) | Accurate |

### Checklist

- **Diff coherence** — every line relates to #577; no unrelated changes.
- **Description accuracy** — PR body matches the diff.
- **Test coverage** — N/A (docs-only; no code changed).
- **Demo evidence** — N/A (docs-only README table addition).
- **Commit quality** — conventional format, story ID present.
- **Diff size** — 3 lines, well under threshold.
- **Missing changes** — none. `jr issue comment` exposes exactly four subcommands (add, delete, edit, view) plus the sibling `comments` list; all are now documented.
- **Placement** — new rows sit after `comment add`, before `comments`, in the same subcommand order clap reports (add → delete → edit → view).

### Findings

**NIT (non-blocking):** The `comment view` row says "shows JSM **visibility** and restriction fields", but the human-output field label is actually `JSM internal:` (alongside `Restricted:`). "Visibility" is a fair conceptual description and is consistent with the terminology used in the adjacent `comment add`/`comments` rows, so this is not worth blocking a docs fix. Optional: reword to "JSM internal and restriction fields" for label-exactness.

No blockers. Recommend merge.
