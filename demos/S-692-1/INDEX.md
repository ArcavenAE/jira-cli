# S-692-1 Demo Evidence

Story: `jr issue edit --dry-run` reads `--description-stdin`/`--description` and
renders the markdown → ADF preview locally (DEC-274, issue #692). Before this
story, `--dry-run` only echoed the raw description text — it never actually ran
the `markdown_to_adf` conversion, so a description that would be rejected by
Jira on write (e.g. the depth-guard case in AC-003) sailed through a dry-run
clean.

Branch: `feat/692-dry-run-adf-preview`
Head: `80529504`
Captured: 2026-08-13

## Recording method

All commands run against fake/isolated config — no real Jira instance, org ID,
or credentials are involved, and `issue edit --dry-run` short-circuits before
any HTTP call regardless:

- `JR_CONFIG_DIR` / `JR_CACHE_DIR` → scratch dirs (`/tmp/jr-demo-config`, `/tmp/jr-demo-cache`)
- `JR_BASE_URL=http://127.0.0.1:1/fake` → unroutable dummy instance URL
- `JR_AUTH_HEADER=Basic ZmFrZTpmYWtl` → dummy fake credential (base64 of `fake:fake`), which
  short-circuits keychain credential loading entirely — without it the debug binary blocks
  on an interactive keychain lookup even with `--no-input`

All three are documented `#[cfg(debug_assertions)]`-gated test seams (CLAUDE.md "AI
Agent Notes") — inert in release builds.

## Evidence

| AC | Video | Tape Source | Command | Exit Code | Result |
|----|-------|--------------|---------|-----------|--------|
| AC-001 | `AC-001-stdin-markdown-adf-preview.gif` / `.webm` | `AC-001-stdin-markdown-adf-preview.tape` | `printf '1. item one\n\n   \`\`\`\n   code\n   \`\`\`\n\n2. item two\n' \| jr issue edit DEMO-1 --description-stdin --markdown --dry-run --output json` | 0 | `plannedChanges.description` carries the raw piped input verbatim; `plannedChanges.descriptionAdf` carries the fully rendered ADF document (`orderedList` → `listItem` → `paragraph`/`codeBlock`) — the whole point of #692 |
| AC-002 | `AC-002-bare-description-renders-adf.gif` / `.webm` | `AC-002-bare-description-renders-adf.tape` | `jr issue edit DEMO-1 --description '**bold** text' --markdown --dry-run --output json` | 0 | The ADF preview isn't stdin-only — a bare `--description` flag renders through the same path and gets the same `plannedChanges.descriptionAdf` key (`strong` mark on "bold") |
| AC-003 | `AC-003-depth-guard-preflight-catch.gif` / `.webm` | `AC-003-depth-guard-preflight-catch.tape` | `cat deep.md \| jr issue edit DEMO-1 --description-stdin --markdown --dry-run` (`deep.md` = 300 nested blockquote levels) | **64** | The pre-flight ADF render trips the `MAX_ADF_DEPTH` guard (BC-7.2.012) *before* any write would have been attempted — `Error: markdown nesting too deep (max 256 levels)` on stderr, **stdout empty**. This proves dry-run now catches a would-be Jira-reject before any HTTP call, not after |
| AC-004 | `AC-004-table-mode-render-ok.gif` / `.webm` | `AC-004-table-mode-render-ok.tape` | `jr issue edit DEMO-1 --description '**bold** text' --markdown --dry-run` (table mode, no `--output json`) | 0 | Human mode doesn't dump raw ADF JSON — it prints `markdown rendering: enabled` followed by a `description (ADF): rendered OK` confirmation line, proving the same conversion succeeded without a wall of JSON |

## What is deliberately NOT covered here

This evidence set is scoped to the four headline behaviors of the story (raw+ADF
in JSON via stdin, raw+ADF in JSON via bare `--description`, the pre-flight depth
guard catch, and the table-mode confirmation line) — it does not attempt to
demonstrate every edge case in the full test suite (e.g. multi-key/`--jql`
interaction, non-markdown `text_to_adf` path, resolution errors for `--field`
inside dry-run). Those are covered by the story's automated tests, not by this
demo evidence.

## Regeneration

The `.tape` files use `Output` paths relative to `.factory/demos/S-692-1/…`,
which resolve correctly only when `vhs` is invoked from the directory that has
`.factory/` as an immediate child — i.e. the **top-level repo root**
(`/Users/zious/Documents/GITHUB/jira-cli`, where `.factory/` is its own worktree
on the `factory-artifacts` branch), not from inside `.worktrees/S-692-1/`. The
tapes themselves `cd` into the story worktree and run the binary from there via
a hidden setup block; AC-003's tape also generates its own `deep.md` fixture
in-line (`perl -e 'print(q(> ) x 300 . qq(deep\n))' > /tmp/jr-demo-deep.md`) so
no external fixture file is needed.

To regenerate against a different head:

```bash
cd /Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-692-1   # build first
cargo build
cd /Users/zious/Documents/GITHUB/jira-cli                       # then run vhs from repo root
for t in .factory/demos/S-692-1/*.tape; do
  vhs "$t"
done
```
