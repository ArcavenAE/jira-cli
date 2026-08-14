**APPROVE** — no blocking findings.

Full review (all 3 changed files, 8-item checklist, 5 non-blocking findings:
2 suggestions on the CHANGELOG/coverage, 1 on doc registration, 2 nits) is in the
COMMENT-state review already posted on this PR.

Verified independently, not taken on report:
- `plannedChanges.description` still carries the raw input byte-identically (BC-3.4.013/#398 unaffected).
- `descriptionAdf` is nested inside `plannedChanges`; top-level key set remains exactly `{dryRun, issues, plannedChanges}`.
- No partial-stdout leak is possible before the exit-64 depth-guard return: there is no
  `println!` anywhere in `handle_edit` ahead of the dry-run `match`, and
  `field_resolve.rs::resolve_edit_fields` (the only step running before the pre-step)
  writes nothing to stdout.
- CHANGELOG `### Breaking Changes` entry is present, correctly placed, and accurate.
- Built the branch and ran `cargo test --test issue_edit`: 38 passed, 0 failed.

Merge should still wait on the remaining CI legs (Test matrix, Clippy (windows-latest),
Coverage, Mutation testing), which were pending at review time.
