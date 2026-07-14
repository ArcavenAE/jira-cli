## Fresh-eyes review — S-577-1 comment subcommand refactor

Reviewed the diff only (source, tests, docs, mutants config) against the 13 acceptance criteria in the story spec. This is a clean, well-scoped breaking-change refactor. **Approving.**

### What I verified
- **Migration intercept (`src/main.rs`)** — correct. `InvalidSubcommand` is intercepted only when the `Usage` context contains `issue comment`; the `list`/`ls` case-insensitive branch emits the plural-form hint, everything else emits the `add`-form hint, and all non-intercepted errors (incl. `DisplayHelp`/`DisplayVersion`/`ArgumentConflict`) fall through to `err.exit()` — preserving byte-identical clap rendering (AC-011). The closure's `!`-returning exits type-check against the `Cli` return.
- **`handle_comment_add` relocation (`interactions.rs`)** — faithful byte-for-byte move from `workflow.rs`; text-source resolution, trim/empty guard, markdown-vs-plain ADF fork, and JSON/table output all unchanged. `workflow.rs` correctly drops the now-unused `use crate::adf;`.
- **Clap surface** — `CommentSubcommand::Edit` carries the full `conflicts_with_all` matrix on `text`/`file`/`stdin` plus `--internal`/`--public` mutual exclusion; `allow_hyphen_values` is on both `add.message` and `edit.text`. Matches AC-004/005/012.
- **Test coverage** — all 13 ACs map to concrete tests (VP-577-008/014/015/018/019/020, AC-012 ×4, AC-013 ±). Six `cli_smoke` + two `cli_handler` flat-form sites migrated; e2e_live sweep complete (verified 0 residual flat-form `["issue","comment",KEY]` call sites); surface guard replaces 1 row with 4.
- **Mutation gate** — `exclude_re = ["handle_comment_(delete|edit|view)"]` correctly excludes only the three `todo!()` stubs and leaves `handle_comment_add` mutated; the removal obligation is documented for S-577-3/4/6.
- **Docs** — README, CLAUDE.md, CHANGELOG (#577 breaking entry), json-output-shapes (4 rows), and new `comment-crud.md` all present. The `adf-recursion-depth.md` and `jsm-e2e-coverage.md` edits are legitimate citation fallout (`workflow.rs::handle_comment` → `interactions.rs::handle_comment_add`), not scope creep — good hygiene given the CLAUDE.md citation guard.

### Non-blocking observations (optional)

**[NIT] `src/main.rs` — `.contains("issue comment")` also matches `"issue comments"`.**
The `under_issue_comment` guard keys off `value.to_string().contains("issue comment")`, which is a substring of the plural `issue comments` command's usage string. This is harmless *today* because `comments` is a leaf command and cannot raise `InvalidSubcommand`. But it is a latent trap: if a future story ever turns `comments` into its own subcommand group, this intercept would silently misfire and emit the wrong migration hint. Consider tightening to a boundary-aware match (e.g. checking for `issue comment <` or `issue comment\n`) to make the scoping intent explicit.

**[NIT] Old flat form with a leading flag bypasses the hint.**
`jr issue comment KEY "text"` and `jr issue comment KEY "text" --markdown` both correctly trigger the migration hint (KEY → `InvalidSubcommand`). But `jr issue comment --markdown KEY "text"` (flag *before* the key) yields `UnknownArgument`, not `InvalidSubcommand`, so it falls through to a raw clap error with no migration hint. This is outside the AC scope and an unusual invocation, so no change is required — noting only for completeness.

Neither observation blocks merge. Nice work on the atomic compile-gate discipline and the thorough doc/test sweep.
