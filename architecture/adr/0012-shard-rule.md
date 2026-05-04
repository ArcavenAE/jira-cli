# ADR-0012: Module Shard Rule Codification

## Status
Accepted

## Context

The codebase has an implicit "shard at ~1000 LOC" rule that was applied once formally (via `docs/specs/list-rs-split.md`, which tracked the refactor of the monolithic `cli/issue/list.rs` into `list.rs` + `view.rs` + `comments.rs`). However, the rule was never codified explicitly, and three files now violate it:

| File | Current LOC | Shard status |
|------|----------:|--------------|
| `cli/auth.rs` | 1,998 | **Violated** — 2× the threshold |
| `cli/issue/list.rs` | 1,083 | **Violated** — just over threshold (even post-split) |
| `cli/assets.rs` | 1,055 | **Violated** — just over threshold |

The violation is documented in NFR-O-D (MEDIUM, DEFER).

**Why the rule exists (inferred from the `list-rs-split.md` precedent):**
- Files over ~1,000 LOC have higher branch density and more undocumented edge cases
- Large files are harder for AI agents to read within context budget (ADR-0004's token-economy rationale applies here too)
- Clippy's `too_many_arguments` lint and similar signals appear more often in large files
- Reviewing a PR touching a 2,000-line file is harder than reviewing one touching a 300-line file

**Why the rule has exceptions:**
- `adf.rs` (1,826 LOC) is a self-contained DSL translator with complex but coherent logic. Sharding it artificially would split coherent transformation functions across files without a natural boundary.
- `api/auth.rs` (1,397 LOC) contains a tightly coupled state machine (OAuth flow + keychain namespacing + legacy migration + refresh resolver). Sharding is possible (e.g., `auth/flow.rs`, `auth/keychain.rs`, `auth/migration.rs`) but not urgent — the cohesion is high.

## Decision

**Codify the shard rule as follows:**

1. **Threshold:** any source file in `src/cli/` that reaches or exceeds 1,000 LOC is a shard candidate.
2. **Trigger:** when a file hits 1,000 LOC, the contributor must either (a) create a feature spec in `docs/specs/` for the shard plan, or (b) document explicitly in the PR why deferral is appropriate.
3. **Exception list (current):** `src/adf.rs` (coherent DSL, no natural split boundary); `src/api/auth.rs` (tight state machine cohesion).
4. **Files targeted for Phase 3 sharding (per NFR-O-D):**
   - `src/cli/auth.rs` (1,998 LOC) → `src/cli/auth/{login,switch,list,status,refresh,logout,remove,helpers}.rs`
   - `src/cli/assets.rs` (1,055 LOC) → `src/cli/assets/{search,view,tickets,schemas,types,helpers}.rs`
5. **`src/cli/issue/list.rs` (1,083 LOC post-split):** no further sharding in Phase 3 — the content is the unified JQL composition + asset integration + all filter clauses. A natural boundary does not exist without artificial decomposition. Document in CLAUDE.md as a known exception.

## Rationale

- Making the rule explicit prevents the "shard once, then violate" pattern from repeating silently.
- The exception list is important — not all large files should be sharded. `adf.rs` is large because it translates a complex format; sharding it would create artificial dependencies.
- The Phase 3 shard targets (`cli/auth.rs`, `cli/assets.rs`) have natural split boundaries (one function per subcommand variant) and follow the precedent established by `cli/issue/` sharding.

## Consequences

- All future PRs that push a `src/cli/` file past 1,000 LOC must acknowledge the rule in the PR description.
- Phase 3 implementation must include the `cli/auth/` and `cli/assets/` shard as a first-class story (not an afterthought).
- The CLAUDE.md "Architecture" section must be updated to reflect the sharded module layout after each shard operation.
- `src/config.rs` (1,223 LOC) is in `src/` (not `src/cli/`) and is a single-concern module. It is outside the rule's scope but should be monitored.

## References

- NFR-O-D (nfr-catalog.md)
- Pass 5 R1 P5R1-AP-04 (shard-rule finding)
- `docs/specs/list-rs-split.md` (precedent)
- risk-register.md §R-M5, §R-M6
