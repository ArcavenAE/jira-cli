# Add `--board` Flag to Sprint and Board Commands — Design Spec

**Issue:** #57

**Goal:** Allow users to specify a board ID from the CLI via `--board <ID>`, eliminating the requirement to configure `board_id` in `.jr.toml` before using sprint and board commands.

## Problem

`sprint list`, `sprint current`, and `board view` resolve `board_id` exclusively from `config.project.board_id` (`.jr.toml`). There is no CLI override. This forces a two-step config-editing workflow:

```
jr board list --project PROJ        # Shows boards with IDs
# manually edit .jr.toml to set board_id = 119
jr sprint list --project PROJ       # Now works
```

Meanwhile, `--project` already has a global CLI flag that overrides the config value. Board commands lack an equivalent.

## Solution

Add a `--board <ID>` flag scoped to the three subcommands that need a board ID. The flag overrides `board_id` from `.jr.toml`; config remains the fallback when `--board` is not specified.

**Target syntax:**

```
jr sprint list --board 119
jr sprint current --board 119
jr board view --board 382
```

`jr board list` is unaffected — it lists all boards and does not need a board ID.

## Approach: Shared `BoardArgs` Struct with Tuple Variants

Use a shared `clap::Args` struct to centralize the `--board` field definition, following clap 4's idiomatic `flatten`/tuple-variant pattern for args shared across multiple subcommands.

### Shared args struct

```rust
#[derive(Args)]
pub struct BoardArgs {
    /// Board ID (overrides board_id in .jr.toml)
    #[arg(long)]
    pub board: Option<u64>,
}
```

### Enum changes

**`SprintCommand`** — convert both unit variants to tuple variants:

```rust
#[derive(Subcommand)]
pub enum SprintCommand {
    /// List sprints
    List(BoardArgs),
    /// Show current sprint issues
    Current(BoardArgs),
}
```

**`BoardCommand`** — convert `View` to tuple variant; `List` stays unit:

```rust
#[derive(Subcommand)]
pub enum BoardCommand {
    /// List boards
    List,
    /// View current board issues
    View(BoardArgs),
}
```

### Config resolver

Add `Config::board_id()` mirroring the existing `project_key()` pattern:

```rust
pub fn board_id(&self, cli_override: Option<u64>) -> Option<u64> {
    cli_override.or(self.project.board_id)
}
```

### Handler changes

**`sprint.rs`:** Extract `board` from each tuple variant, pass to `config.board_id()`:

```rust
match command {
    SprintCommand::List(args) => {
        let board_id = resolve_board_id(config, args.board)?;
        // ...
    }
    SprintCommand::Current(args) => {
        let board_id = resolve_board_id(config, args.board)?;
        // ...
    }
}
```

The scrum-board guard (`get_board_config` + type check) remains unchanged — it still runs after board_id resolution.

**`board.rs`:** Extract `board` from `View` tuple variant:

```rust
match command {
    BoardCommand::List => handle_list(client, output_format).await,
    BoardCommand::View(args) => {
        handle_view(config, client, output_format, args.board).await
    }
}
```

### Error messages

Update all "No board_id configured" errors from:

```
No board_id configured. Set board_id in .jr.toml or run "jr init".
```

To:

```
No board configured. Use --board <ID> or set board_id in .jr.toml.
Run "jr board list" to see available boards.
```

## Files Changed

| File | Change |
|------|--------|
| `src/cli/mod.rs` | Add `BoardArgs` struct; convert 3 variants to tuple variants |
| `src/cli/sprint.rs` | Extract `args.board` from variants, use `config.board_id()` |
| `src/cli/board.rs` | Extract `args.board` from `View`, use `config.board_id()` |
| `src/config.rs` | Add `board_id()` method |
| `src/main.rs` | No change — dispatch already passes `config` |

## Testing

- Existing `compute_sprint_summary` unit tests: unaffected (no board_id involvement)
- New `Config::board_id()` unit test: CLI override wins over config, config is fallback, both `None` returns `None` (mirrors `test_project_key_cli_override`)
- No integration test changes: existing tests don't exercise board_id resolution

## Backward Compatibility

- `.jr.toml` `board_id` continues to work as before (fallback when `--board` not specified)
- `jr board list` unchanged
- No breaking changes to existing commands or config format
