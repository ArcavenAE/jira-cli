## Summary

Story specs sometimes pin specific function signatures (parameter lists, types, return types) in acceptance criteria or architecture mapping sections. When a pinned signature has 8 or more parameters and the project enforces `clippy::too_many_arguments` (threshold: 7), the implementer is placed in a forced conflict: satisfy the story spec OR satisfy clippy. The conflict surfaces in-flight as an unexpected deviation, requiring human ratification.

## Trigger (jira-cli SOH-COMMENT-CRUD-1, F4 wave-A — PG-F4-3 / DEC-172 D1)

Story S-577-1 pinned the following signature in its architecture mapping section:

```rust
pub async fn handle_comment_add(
    client: &JiraClient,
    config: &Config,
    issue_key: &str,
    body: &str,
    visibility: Option<CommentVisibility>,
    internal: bool,
    no_input: bool,
    output: OutputFormat,
) -> Result<()>
```

This is an 8-parameter function. The project enforces `cargo clippy --all-targets -D warnings`, which includes `clippy::too_many_arguments` (threshold 7). The implementer encountered the lint error in-flight, could not satisfy both the pinned signature and the lint, and introduced a deviation (D1: enum-param form — wrapping the boolean flags into a `CommentOptions` struct) without reporting it before proceeding. The deviation was ratified retroactively by human decision DEC-172.

**Cost:** One in-flight deviation + retroactive ratification gate + story-sync commits for S-577-1/4/5.

## Root Cause

The story-writer derives function signatures from the spec's behavioral description and pins them as implementation targets. The lint threshold is not checked at story-authoring time. If the story-writer had noticed the 8-parameter count, they could have either: (a) included the enum-param form in the story from the start, or (b) flagged it as a known lint deviation requiring pre-approval.

## Proposed Fix

**Story-writer checklist addition for pinned function signatures:**

> For any pinned function signature in the story's architecture mapping or AC postconditions:
> 1. Count the parameters.
> 2. If parameter count ≥ 8 (or ≥ project lint threshold + 1), either:
>    (a) Revise the story to use an enum-param/options-struct form that satisfies the lint, OR
>    (b) Add an explicit note: "This signature has N parameters; implementer must obtain orchestrator approval for a lint-exemption deviation or refactor to a struct form before writing code."
> 3. Run `cargo clippy --all-targets -D warnings` mentally against the pinned signature. If it would fail, the story is incomplete.

**Note:** This check is only applicable to languages/projects that enforce parameter-count lints. For Rust projects with `clippy::too_many_arguments`, the threshold is 7. For other projects, the threshold varies.

## Severity

LOW process-gap. Each occurrence adds one in-flight deviation + retroactive ratification. Avoidable with a single count at story-authoring time.

## Source

jira-cli SOH-COMMENT-CRUD-1 session review 2026-07-15 (IP-577-11). Codified in `.factory/cycles/cycle-001/lessons.md` as PG-F4-3. Ratified as DEC-172 D1 in jira-cli STATE.md.
