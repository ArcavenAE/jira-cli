# Rust Best Practices — Decomposing Very Large Functions (cycle-010 F1)

**Type:** general (technology / refactoring-pattern research)
**Date:** 2026-09-24
**Author:** research-agent (for the human's cycle-010 F1 decomposition-style decision)
**Status:** complete
**Confidence:** high on the pattern recommendation; medium on exact OSS line-level structure (some source bodies not retrievable through web tooling — flagged inline)

---

## 0. Scope & Concrete Context

Behavior-preserving refactor of two monolithic async command handlers in crate `jr`
(clap + tokio + reqwest Jira CLI):

| Handler | Location | Size | Shape |
|---|---|---|---|
| `handle_edit` | `src/cli/issue/edit.rs:45` | ~1,314 LOC | single-key + bulk paths; field/label/type/component branches; `--dry-run`; type-error enrichment |
| `handle_list` | `src/cli/issue/list.rs:152` | ~775 LOC | JQL composition; filter application (`--fields`/`--sort`/`--component`/`--updated-recent`); table + JSON rendering |

Both are `pub(super) async fn`. Both are flagged by `clippy::too_many_lines`. The **containing
files** are already documented-intentionally large (single command family, see CLAUDE.md "Known
Size Deviations"); the concern being decided here is the **single huge function**, not the file.

### Load-bearing observation from reading the actual source

Both handlers take only **5–6 formal parameters** (`command`, `output_format`, `config`, `client`,
`no_input`, plus `project_override` on list). They then immediately **destructure a ~20-field clap
enum variant** into locals:

```rust
// edit.rs:52 — ~20 fields
let IssueCommand::Edit { keys, jql, max, yes, dry_run, summary, issue_type, priority,
    label, component, team, points, no_points, parent, no_parent, description,
    description_stdin, markdown, field, no_mentions } = command else { unreachable!() };
```

```rust
// list.rs:160 — ~22 fields
let IssueCommand::List { jql, status, team, limit, all, assignee, reporter, recent,
    updated_recent, open, points, assets, duedate, asset, component, created_after,
    created_before, updated_after, updated_before, fields, sort } = command else { unreachable!() };
```

**Implication for the decision:** clap *already* provides the parameter-object at the entry
boundary (the `IssueCommand::Edit`/`::List` variant IS a parameter struct). So the primary lint
pressure is `clippy::too_many_lines` (huge body + branchy control flow), **not**
`clippy::too_many_arguments` on the entry point. The `too_many_arguments` risk is *downstream*:
naive extract-method into free functions would thread all ~20 destructured locals plus
`&client`/`&config`/flags into each helper — which is exactly the failure mode the parameter-object
pattern exists to prevent. This shapes the recommendation below.

---

## 1. The Five Decomposition Approaches — Comparison & Selection Criteria

Verdicts synthesized from web-grounded Perplexity reasoning over the Rust Book (managing growing
projects / module system) [1][2], the Rust Reference visibility rules [3], clippy lint
configuration/docs [4][5], Rust API/coding-guideline discussions [6][7], and real OSS CLI source
(§6).

| Approach | Best when | Advantages | Risks | Verdict for jr |
|---|---|---|---|---|
| **(a) Same-file private free functions** ("hoist into named private fns") | First extraction; small, pure, local helpers; narrow input/output | Lowest-risk; honest signatures; no artificial object lifetime; easy review; testable in-file | Long arg lists — repeated `&client`/`&config`/flags/intermediates make signatures noisy → invites `too_many_arguments` | **Use for pure transforms** (JQL build, filter apply, render, error-enrich). Not sufficient alone for the mutation-heavy edit branches. |
| **(b) New submodule directory** (`edit/`, `list/` with cohesive files) | A command with several hundred LOC after first extraction AND a real concept boundary (single/bulk/validate/execute/render) | Separates navigation & ownership; narrow visibility (`pub(super)`) encapsulates; per-concern tests | Module plumbing; careless `pub(crate)` over-exposes internals; parent can't see child privates by default [3] | **Endpoint for edit** once concepts have independent tests. Optional for list. |
| **(c) Context / parameter-object struct + `impl` methods** (thread `client`/`config`/flags as `&self`) | Many operations share **stable** dependencies | Removes repeated infra params; names operations; keeps call sites self-documenting; directly answers clippy `too_many_arguments` ("group parameters into a new type") [5] | Becomes a "god context" if you dump every local into it; `&self` does not make unrelated state related; methods STILL count toward `too_many_lines`/`too_many_arguments` [4][5] | **Use for the STABLE trio only** (`client`, `config`, resolved flags). Do NOT put evolving plan/response state in it. |
| **(d) Pipeline / stage decomposition** (parse → resolve → validate → execute → render) | Genuinely sequential phases with useful intermediate representations | Explicit phase boundaries; excellent testability; reduces nesting; makes `--dry-run` safe (render the plan without mutating) | Artificial for branch-heavy code; stages may need different state; must preserve exact side-effect ORDER | **Primary for `list`** (naturally ordered). **Selective for `edit`** (top-level phases only, not forced 5 stages per branch). |
| **(e) Typestate / builder / command objects** | State transitions carry real invariants (e.g. cannot execute before resolve+validate) | Encodes legal transitions in the type system | High abstraction cost; usually overengineering for one handler; can merely relocate complexity | **Avoid for line-count reduction.** Use small domain enums (`EditTarget`, `EditOperation`) + `EditInput → EditPlan → EditOutcome` structs instead of full typestate. |

**Where sources agree:** clippy `too_many_lines` documentation explicitly says "Consider splitting
the body of the function into multiple functions" [4][5], and `too_many_arguments` says "Consider
grouping some parameters into a new type" [4][5] — i.e. the tooling itself points at (a)/(b) for
length and (c) for argument count. The Rust Book's module chapter endorses moving related
functionality into modules/files and using visibility to encapsulate as programs grow [1][2].

**Where sources are nuanced / caution:** community threads [6][7] and the reasoning synthesis warn
that mechanically wrapping N arguments in one struct, or moving a 1,314-line body verbatim into one
`impl` method, "only hides the original design problem" — clippy counts methods the same as free
functions, so a 1,314-line method still trips `too_many_lines`. No source claims a single approach
is universally correct; all frame it as cohesion-driven.

---

## 2. Parameter-object + methods (c) vs. many free functions (a) — is (c) the idiomatic path?

**Answer: partially, and only for the STABLE shared dependencies — not as a blanket replacement for
free functions.** This is the most important nuance for the decision.

- clippy `too_many_arguments` (default threshold **7**) [4][5] literally recommends "grouping some
  parameters into a new type" — so for helpers that would otherwise take 8+ args, a context struct
  is the tool-endorsed idiom.
- BUT the community/idiomatic guidance [6][7] and the reasoning synthesis converge on a
  **distinction that must be preserved**:
  - **Context** = stable dependencies used by many operations (`client`, `config`, resolved flags) → good `&self`.
  - **Request** = data parsed from this invocation (`EditInput`) → a value type, passed in.
  - **Plan** = resolved+validated work (`EditPlan`) → a value type, returned by resolve.
  - **Outcome** = data needed for rendering (`EditOutcome`) → a value type, returned by execute.
  - **Local** = stays local unless multiple operations genuinely share it.
- A **free function with 3 meaningful params is better than a context method that secretly reads 10
  fields of `self`.** Rule of thumb from the synthesis: *"If the helper can be described without
  mentioning the command context, make it a free function. If it is an operation of the command
  workflow using stable dependencies, make it a method."*

**Concrete shape endorsed for `jr` (drops the ~20 destructured locals into typed groups):**

```rust
struct EditContext<'a> {
    client: &'a JiraClient,
    config: &'a Config,
    output: &'a OutputFormat,
    no_input: bool,
}

// domain enums replace loose booleans/optionals (makes illegal combos unrepresentable)
enum EditTarget { Single(IssueKey), Bulk(BulkSelection) }        // keys vs --jql/--max
enum EditOperation { Field{..}, Labels(..), IssueType(..), Components(..) }

impl EditContext<'_> {
    async fn resolve(&self, input: EditInput) -> Result<EditPlan> { .. }   // metadata lookups
    async fn execute(&self, plan: EditPlan) -> Result<EditOutcome> { .. }  // side effects
}
```

The handler collapses to an orchestration shell:

```rust
async fn handle_edit(command, output, config, client, no_input) -> Result<()> {
    let input  = EditInput::from_command(command)?;   // the destructure + validation lives here
    let ctx    = EditContext { client, config, output, no_input };
    let plan   = ctx.resolve(input).await?;
    let result = ctx.execute(plan).await?;            // --dry-run renders `plan` and stops here
    render_edit_result(output, result)
}
```

---

## 3. Same-file helpers vs. submodule directory — selection criteria

Synthesized from Rust Book module guidance [1][2] and the Reference's visibility-and-privacy rules
[3] (items private by default; child modules can access ancestor items; a parent CANNOT access a
child's privates automatically).

**Keep in the SAME file when:**
- It is the first extraction step of a behavior-preserving refactor (minimize churn).
- Only a few helpers; they are tightly coupled to local types.
- Moving would force broad visibility widening.
- The file stays navigable after extraction.

**Move to a `edit/` (or `list/`) SUBMODULE directory when:**
- The file still has several hundred LOC *after* the first extraction.
- There is a recognizable concept boundary (single-item / bulk / resolve / validate / execute / render).
- A group of helpers has its own types AND tests.
- Developers usually work on one concern without reading the others.

**Visibility discipline (from [3]):** private if used only within the module; `pub(super)` if a
child must expose an entry point to its parent; `pub(crate)` ONLY when multiple crate modules
genuinely need it. Note the privacy asymmetry: because a parent can't see a child's privates, the
cleanest layout is to **move the handler itself into the command submodule** (`edit/mod.rs` holds
the small entry point) so the module hierarchy matches the call hierarchy — rather than leaving
`handle_edit` in a parent that has to reach into `edit::single`/`edit::bulk` via `pub(super)` seams.

**Recommended target layout (endpoint, not step 1):**

```text
src/cli/issue/
├── edit/
│   ├── mod.rs        # small handle_edit entry point (orchestration shell)
│   ├── input.rs      # EditInput::from_command — the destructure + all pre-HTTP validation
│   ├── context.rs    # EditContext + resolve/execute
│   ├── single.rs     # single-key path
│   ├── bulk.rs       # handle_edit_bulk_{labels,components,fields} (already separate fns today!)
│   ├── enrich.rs     # type-error enrichment
│   └── render.rs      # dry-run + success rendering
└── list/
    ├── mod.rs        # small handle_list entry point
    ├── query.rs      # JQL composition + filter application (pure)
    ├── fetch.rs      # the async search call
    └── render.rs     # table + JSON rendering (pure)
```

Note `edit.rs` **already** has `handle_edit_bulk_labels` (`:1721`),
`handle_edit_bulk_components` (`:1885`), `handle_edit_bulk_fields` (`:2271`) as separate functions
— the file is partly decomposed already; the bulk seams exist and map cleanly onto `edit/bulk.rs`.

---

## 4. Behavior-preserving refactor mechanics (safe sequencing + Rust tooling)

Grounded in the Rust Book's testing chapter (unit tests can exercise private items; integration
tests exercise the public surface) [1] and standard refactoring discipline; the async/side-effect
ordering caveats are emphasized by the reasoning synthesis.

**Recommended sequence:**
1. **Characterization tests first.** Before touching structure, ensure the existing behavior is
   pinned — for `jr` this means the existing `insta` snapshots + wiremock integration tests +
   `--dry-run`/JSON-shape tests are green and cover the branches you'll move. Add tests for any
   under-covered branch BEFORE extracting it.
2. **One extraction at a time; keep the suite green after each.** Extract → `cargo test` →
   `cargo clippy -- -D warnings` → commit. Never batch multiple extractions into one unreviewable
   diff.
3. **Preserve side-effect ORDER exactly.** The single biggest behavior-preservation hazard here is
   the split of "resolve" (metadata lookups: createmeta, editmeta, field resolution) from "execute"
   (the mutating PUT/POST). If the current code does lookups lazily / in a specific order / only on
   certain branches, the refactor MUST reproduce that order and conditionality. Do not "tidy" the
   HTTP call sequence in the same PR.
4. **Split by behavior, not by line range.** Good names: `parse_edit_input`, `resolve_target`,
   `resolve_field`, `validate_operation`, `build_single_update`, `build_bulk_updates`,
   `execute_update`, `enrich_type_error`, `render_dry_run`. Bad: `process_edit_part_1`,
   `handle_remaining_fields`.
5. **Introduce domain enums before many methods** (`EditTarget`, `EditOperation`) so combinations of
   booleans/optionals become explicit alternatives — this shrinks the branchy control flow that is
   the actual source of the line count.

**Rust-specific tooling:**
- **rust-analyzer "Extract function" assist** — mechanically hoists a selection into a new fn,
  inferring parameters/returns and borrows. Ideal for step-2 incremental extraction with minimal
  transcription error. (Also has "Extract into variable/module" assists.)
- **`cargo clippy -- -D warnings`** (repo already enforces zero-warning policy) — re-run after each
  extraction; watch for `too_many_arguments` appearing on a newly-extracted free function as the
  signal to switch that helper to an `EditContext` method or bundle its inputs into a struct.
- **`cargo test` / `cargo test --lib` / insta** — the green-bar gate between extractions.
- Optional: **`cargo-mutants` in-diff** (repo already uses it) to confirm the extracted units are
  actually covered, not just present.

---

## 5. Testability — does the choice materially change unit-testing ease in Rust?

**Answer: the free-function-vs-method choice is NOT the main testability lever. The main levers are
(1) dependency size, (2) purity, (3) visibility.** [1]

- **Private free functions** — directly unit-testable via an in-file `#[cfg(test)] mod tests` using
  `use super::*;`. The Rust Book documents that unit tests *can* test private functions [1]. Best
  fit for pure logic: JQL composition, filter precedence/escaping, render, error enrichment,
  `EditInput` parsing.
- **Private methods on a context** — equally testable *if the context is cheap to construct*. The
  problem appears when the method needs a real `JiraClient`/network/filesystem — that's a smell that
  the method is doing too much or needs a narrower service abstraction. `jr` already has
  `JiraClient::new_for_test(base_url, auth_header)` + wiremock, so context methods testing request
  SHAPE/ordering are feasible, but pure logic should NOT be trapped inside a network-requiring
  method.
- **`pub(crate)` submodule items** — convenient for sibling-module/integration tests but they
  ENLARGE the internal API surface and add crate-wide coupling. Prefer private items + in-module
  tests; reach for `pub(crate)` only for a deliberate internal boundary.

**Testability-maximizing rule for `jr`:** push all pure logic (parse/validate/JQL/render/enrich)
into **private free functions kept in the relevant module**, unit-tested in-file; keep the network
in thin context methods, tested via wiremock at the request-shape level; keep end-to-end behavior
pinned by the existing insta/integration suite. This maximizes testability WITHOUT over-exposing
internals (no unnecessary `pub(crate)`).

---

## 6. How real Rust clap CLIs structure large command handlers

Verified against OSS source where retrievable; items I could not open directly are flagged.

| Codebase | Source (verified) | Pattern |
|---|---|---|
| **Cargo** | `src/bin/cargo/cli.rs`, `src/bin/cargo/commands/` [8] | **Submodule-per-command + shallow dispatcher.** `cli.rs` builds the clap command and dispatches via an `Exec::{Builtin,Manifest,External}` enum; per-command behavior lives in `commands/`, not inline in `cli.rs`. |
| **uv** (astral-sh) | `crates/uv-cli/src/lib.rs` (schema), `crates/uv/src/lib.rs::run` (dispatch), `crates/uv/src/commands/` [9] | **Clap schema separated from execution; command-family modules; staged pipeline** parse → resolve settings → async dispatch → `ExitStatus`. The large clap derive tree lives in `uv-cli`; handlers live in `uv/src/commands/{pip,project,python,tool,auth,...}`. Closest analogue to `jr`'s situation. |
| **jj / jujutsu** | `cli/src/commands/mod.rs`, `cli/src/commands/*.rs` [10] | **Submodule-per-command + shared context.** The `Command` enum + `run_command()` dispatch live in `commands/mod.rs`; each command in its own file; a `CommandHelper`/CLI utility layer carries repo/config/UI/arg context to handlers (≈ the context-object pattern). |
| **ripgrep** | `crates/core/main.rs`, `crates/core/flags/`, `crates/core/search/` [11] | **Decomposed FREE functions + a parsed-config object.** `run(ParseResult<HiArgs>)` dispatches by `Mode` to free functions (`search`, `search_parallel`, `files`, `types`, `generate`, `special`); `HiArgs` is a parsed-config object whose METHODS build matchers/printers/walkers, but the handlers are free functions. (Note: current ripgrep parses with `lexopt`, not clap — architecture example, not a clap example.) |
| **bat** (sharkdp) | `src/bin/bat/main.rs`, modules `app`/`clap_app`/`config`/`controller` [12] | **Free functions + an `App` parser/config object.** `main()` → `run()`; distinct free fns `run_cache_subcommand()`, `build_assets()`, `run_controller()`. `App` owns parsed matches/config; execution is split into free functions. |
| **alacritty** | `alacritty/src/cli.rs` [13] | **Typed clap arg/context structs with `&self`/`&mut self` methods** (`Options`, `WindowOptions`, `TerminalOptions`, …) holding transformation logic; execution proper is elsewhere. |
| **gitui** | `src/main.rs` (~364 lines, confirmed small) [14] | Entry file confirmed small, but **its body was NOT retrievable through the web tool** — could not verify whether the CLI path uses a derived struct/App/methods/free fns. Flagged INCONCLUSIVE. |
| **nushell** | `src/main.rs`, `command.rs`, `run.rs` [15] | **Pipeline-stage architecture** (engine build → config → env → plugins → input → mode dispatch: LSP/command/script/REPL). Not clap (uses `lexopt`); useful as a staged-startup example, not subcommand structure. |

**Cross-codebase takeaways (the recurring real-world pattern):**
1. Keep clap declarations SEPARATE from execution (Cargo, uv). `jr` already does this — the derive
   tree is in `cli/mod.rs`; handlers are separate.
2. Use ONE dispatcher, kept shallow (Cargo `Exec::exec`, jj `run_command`, uv `run`, ripgrep `run`).
3. Use a context object when handlers need SUBSTANTIAL shared state (jj CommandHelper, ripgrep
   `&HiArgs`, bat `App`, alacritty option structs).
4. Split by command family once the tree is large (Cargo, jj, uv).
5. Pipeline stages when startup/flow has many ordered concerns (nushell, uv).

**None of the surveyed large CLIs keeps a single 1,000+ line command handler** — the universal
practice is a shallow dispatcher/orchestration shell delegating to free functions and/or a
context object, organized by command family.

---

## 7. Clippy thresholds (verified) & the two lints in play

| Lint / config | Default | Official recommendation |
|---|---|---|
| `clippy::too_many_lines` / `too-many-lines-threshold` | **100 lines** [4][5] | "Consider splitting the body of the function into multiple functions." [4] |
| `clippy::too_many_arguments` / `too-many-arguments-threshold` | **7 arguments** [4][5] | "Consider grouping some parameters into a new type." [4][5] |

Both handlers vastly exceed 100 lines → `too_many_lines` is the binding constraint. The entry
points take 5–6 args (under the 7 threshold), so `too_many_arguments` does not fire *on them today*
— but it is the trap to avoid when extracting helpers via approach (a). This is precisely why the
recommendation pairs (a) with a context object (c).

---

## 8. Recommended Technical Decisions (decision-ready)

### For `handle_edit` (~1,314 LOC, mutation-heavy, branchy) — **(c) + (b) + selective (d)**

1. Reduce the handler to an **orchestration shell** (§2): `EditInput::from_command` (destructure +
   pre-HTTP validation) → `EditContext { client, config, output, no_input }` → `ctx.resolve` →
   `ctx.execute` → `render`.
2. Introduce **domain enums** (`EditTarget`, `EditOperation`) to collapse boolean/optional
   combinations — this attacks the branch count, which is the real driver of the line count.
3. Thread the stable trio via **`EditContext` methods** (approach c) — this prevents the
   `too_many_arguments` explosion that naive free-function extraction would cause given ~20 locals.
4. Keep **pure logic as private free functions** (enrichment, input parsing, dry-run rendering).
5. **Separate resolve (lookups) from execute (side effects)** — makes `--dry-run` render the plan
   and stop before any mutation, which is both cleaner and safer. Preserve exact HTTP ordering.
6. Land it in a **`edit/` submodule** (approach b) — the existing `handle_edit_bulk_*` functions
   already map onto `edit/bulk.rs`; the file is partly decomposed already.

### For `handle_list` (~775 LOC, naturally sequential, read-only) — **(d) + (a)** with a thin context

1. **Pipeline stages** (approach d): `build_query` (JQL + filter application, pure) → `fetch`
   (the one async search call, on a thin `ListContext { client, config }`) → `render_table` /
   `render_json` (pure).
2. Keep query-building and rendering as **private free functions** (approach a) — they are pure and
   maximally testable, giving strong unit coverage for JQL composition, filter precedence/escaping,
   and both output formats with zero network.
3. Move to a **`list/` submodule** only if the file stays large after this split (lower priority
   than the edit refactor).

### Cross-cutting

- **Do NOT** create a "god context" holding evolving plan/response state, and **do NOT** move the
  1,314-line body verbatim into one `impl` method (still trips `too_many_lines`, hides nothing).
- **Do NOT** introduce full typestate/builder machinery just to reduce lines — use plain
  `Input → Plan → Outcome` value structs + domain enums.
- Prefer **private items + in-module tests**; reach for `pub(crate)` only at a deliberate boundary.
- Sequence: characterization tests green first → one rust-analyzer extraction at a time →
  `cargo test` + `cargo clippy -D warnings` between each → preserve side-effect order.

---

## 9. Inconclusive / caveats

- **gitui** CLI-handler internal structure could not be verified (source body not retrievable).
- **ripgrep** and **nushell** use `lexopt`, not clap — cited as architecture examples, not clap
  examples. clap-specific structural exemplars are **Cargo, uv, jj, bat, alacritty**.
- Exact current line-level structure of Cargo/uv/jj handlers was verified at the module/dispatch
  level via deepwiki + GitHub source; individual handler LOC was not line-counted (not needed — the
  decision is about pattern, not size, and all confirm "shallow dispatcher, no giant handler").
- The clippy default thresholds (100 / 7) were verified against the official clippy configuration
  page [4] and corroborated by the clippy source/docs [5]; these are documented values, not
  inferred.
- No source contradicts the recommendation; the only tension in the literature is the community
  warning that a parameter-object/method refactor can *hide* rather than *solve* a design problem —
  addressed here by the Context/Request/Plan/Outcome/Local discipline in §2.

---

## 10. Deep-Research Completion Pass (2026-09-24, follow-up)

**Status of the deep tool:** `perplexity_research` (sonar-deep-research) was RETRIED and **timed out
again at 300 s** (Perplexity API non-response, second consecutive failure). Per instruction, this is
stated explicitly rather than left silent. The pass was completed via two additional web-grounded
`perplexity_reason` (sonar-reasoning-pro, `search_context_size: high`) calls targeting exactly the
gaps the coordinator flagged: dissenting views, the god-context anti-pattern + Rust borrow pain, the
plan/apply + dry-run pattern, characterization testing, and additional dry-run/bulk-mutation CLIs.

### Verdict: **CONFIRMED, with five refinements (none reverse the hybrid).**

The core recommendation — orchestration shell + narrow context for stable deps + pure free functions
+ resolve/execute (plan/apply) split, landed in submodules — is corroborated and strengthened. The
deep pass did NOT surface any source recommending a single giant handler, and did NOT find evidence
that a context struct is the wrong call *when kept narrow*. But it sharpened several points and
surfaced one genuinely contested area the human should weigh.

### New evidence & refinements

**R1 — Keep the context NARROW and LOCAL; do NOT store per-call flags as state.** The single most
important nuance. There is a real, citable conflict in Rust practice:
- **matklad's "Call-site Dependency Injection"** [16] argues for passing specific dependencies to the
  functions that need them, rather than storing broad configuration in shared state — to avoid
  coupling unrelated features and to keep different configurations usable for the same code.
- **rust-analyzer's own style guide** [17] EXPLICITLY endorses packing params "threaded unchanged
  through many calls" into a `struct Ctx` passed as `&self`, AND recommends a `Config` struct instead
  of many bool/optional params — but with the caveat to **NOT store that `Config` as persistent
  state; pass it explicitly** so callers keep flexibility.
- **Reconciliation for `jr`:** the `EditContext`/`ListContext` should carry only the STABLE trio
  (`client`, `config`, `output`) — module-local, not an application-wide bucket. Per-invocation flags
  and the parsed `EditInput`/`EditOperation` should be **passed as explicit parameters, not stored on
  the context**. This tightens (not reverses) §2's "stable trio" guidance. The forum "context struct
  pattern" thread [18] independently warns to restrict a context to one module/subsystem and flags
  the "tests must construct half the world" cost of broad contexts.

**R2 — Rust-specific borrow-checker rationale for keeping pure helpers as explicit-param free
functions.** A context owning many fields creates *partial-borrow friction*: a method taking `&self`
(or `&mut self`) borrows the WHOLE object, even if it logically touches one field. The Rustonomicon
documents that the compiler can split borrows of *directly-accessed disjoint struct fields* [19], but
that splitting does NOT extend through `&self`/`&mut self` helper-method calls — so
`fn execute(client: &Client, cache: &mut Cache, plan: &Plan)` compiles cleanly where
`ctx.execute(&plan)` needing `&self.client` + `&mut self.cache` can conflict. This is an additional,
concrete reason (beyond "hidden dependencies") to keep pure logic as free functions with explicit
narrow parameters and reserve `&self` methods for genuinely context-wide operations.

**R3 — plan/apply is an ESTABLISHED, NAMED pattern; elevate it to first-class and specify the plan
shape.** The resolve/execute split is not bespoke — it is **Terraform `plan`/`apply`** [20] and
**Kubernetes client-side vs server-side `--dry-run`** [21]. Two hardening specifics:
- The `EditPlan` should be an **ordered `Vec<EditOperation>`**, NOT a dedup'd map/set, if the existing
  code's operation ordering is observable (it is — per-key bulk 400s, error precedence). Terraform's
  saved-plan model (apply the exact reviewed artifact) is the strongest form.
- **Define "no writes" precisely for dry-run.** Kubernetes' caution is directly relevant: server-side
  dry-run is "no PERSIST," not "no side effects" — admission/webhooks can still act. For `jr` this
  means dry-run must suppress not only the mutating PUT/POST but also **any cache write whose update
  changes future behavior** (`jr` has 7-day-TTL caches for fields/components/createmeta). Decide and
  document whether read-path cache population is allowed during dry-run; do not let it drift silently.

**R4 — Characterization harness must capture an EVENT TRANSCRIPT, not just final output.** Feathers'
characterization tests [22] and golden-master/approval testing [23] are the right safety net, but the
deep pass is emphatic that for side-effecting code the baseline should be a *sanitized ordered
transcript* of reads / writes / request payloads / stdout+stderr / exit code / error precedence — not
merely the final JSON/table. This is because the eight concrete ordering hazards of a resolve/execute
split are the real behavior-preservation risk: (1) lazy lookups becoming eager, (2) conditional
lookups becoming unconditional, (3) interleaved read/write becoming all-reads-then-all-writes,
(4) error-precedence changes, (5) output-ordering changes, (6) new TOCTOU windows, (7) repeated reads
appearing/disappearing, (8) dry-run diverging from real-run. `jr` already has wiremock + insta, which
can pin request shape/order and rendered output respectively — extend them to assert HTTP call
*order/count* around the edit refactor before extracting.

**R5 — plan/apply and context-struct are INDEPENDENT decisions.** You can introduce an explicit
`EditPlan`, explicit `resolve(...)` parameters, and an explicit `execute(plan, deps)` boundary WITHOUT
introducing any context struct at all. If the context ever feels like it's growing to hold plan or
response state, drop it and pass explicit params — the plan/apply value does not depend on it.

### New real-CLI exemplars WITH dry-run / bulk-mutation (the coordinator's ask #5)

Source-verified, and closer analogues to `jr issue edit` (single + bulk + `--dry-run`) than the
read-only tools in §6:

| Tool | Verified source | Mutation/preview structure — analogue value |
|---|---|---|
| **cargo-edit** (`cargo upgrade --dry-run`) | `killercup/cargo-edit` README + CHANGELOG [24] | **compute candidate manifest upgrades → render/report → write only when not `--dry-run`.** Direct structural analogue: plan first, apply conditionally. |
| **Ruff** | `crates/ruff_linter/src/fix/edits.rs`; CLI `check`/`format` [25] | Rules generate structured `Fix`/`Edit` values; the OUTER layer chooses **apply (`--fix`) vs preview (`--diff`)** vs `--unsafe-fixes`. Excellent "produce edits, then choose apply-vs-preview" model — maps onto EditPlan + `--dry-run`. |
| **Biome** | `crates/biome_cli/src/commands/` (`check.rs` etc.) + `crates/biome_cli/src/execute/` + traverse layer [26] | **Central command enum → submodule-per-command → shared traversal/execution pipeline → optional write.** The CLI crate is a thin layer; real work is in `execute`/`traverse`. Strong precedent for the `edit/` submodule + shared execute boundary. |
| **Nushell** | `crates/nu-command/src/.../*.rs` implement `run(&self, engine_state, stack, call)` [27] | Command-per-module receiving an engine CONTEXT (`EngineState`, `Stack`, `Call`) — a real-world context-object-per-command design (validates approach c when kept per-command). |
| **rustup** | `src/cli/rustup_mode.rs`, `proxy_mode.rs`, `setup_mode.rs` [28] | Top-level dispatcher + submodule-per-mode; no giant business-logic handler. Confirms the shallow-dispatcher norm. |

**Inconclusive / not applicable (flagged):** gitui (TUI key/action handlers, no CLI mutation-preview
verified), zellij / atuin / gitoxide-gix / sccache / bottom / dua / rbw / git-cliff, and ripgrep —
either not source-verifiable at handler level from the retrieved pages, or not mutation-with-dry-run
CLIs. Do not use these as design models without inspecting current source directly.

### Dissent the human should weigh before deciding

1. **Context struct vs flat explicit params (genuine, live contest).** matklad/csdi [16] leans
   against shared-state config; rust-analyzer's style guide [17] endorses a local `Ctx` + `Config`
   struct. Both are authoritative Rust sources. **The refactor is safe under EITHER reading provided
   the context stays narrow and per-call options are passed, not stored** — which is exactly R1. If
   the team prefers the matklad end of the spectrum, do plan/apply with pure explicit-param functions
   and skip the context entirely (R5 makes this clean). This is a style preference to settle
   explicitly, not a correctness question.
2. **Incremental vs coherent-larger refactor.** Prevailing guidance (Fowler-style small steps kept
   green; Feathers seams + characterization) strongly favors many tiny extractions. A *qualified*
   minority view (floss vs "root-canal"/large-scale refactoring) [29] permits a larger coherent
   migration when tiny steps can't preserve a useful boundary or would create obviously-temporary
   abstractions — but **no source endorses big-bang WITHOUT a characterization harness**. Given
   `jr`'s existing insta+wiremock suite, incremental-with-characterization is clearly the lower-risk
   path here; a larger coherent move is only justified if the single/bulk/dry-run boundaries can't be
   introduced one-at-a-time (they can — the `handle_edit_bulk_*` seams already exist).

---

## Top 3 sources (for the decision brief)

1. **Clippy lint documentation & configuration** — `too_many_lines` ("split the body into multiple
   functions", default 100) and `too_many_arguments` ("group some parameters into a new type",
   default 7): the tool-endorsed direction that maps directly onto approaches (a)/(b) for length and
   (c) for argument count. [4][5]
2. **The Rust Programming Language — "Managing Growing Projects" (modules/visibility) + "Test
   Organization" chapters** — endorses splitting into modules/files with narrow visibility as
   programs grow, and documents that private items are unit-testable in-module. Basis for §3 and §5.
   [1][3]
3. **Real OSS clap CLIs — Cargo (`src/bin/cargo/cli.rs` + `commands/`) and uv
   (`uv-cli` schema vs `uv/src/commands/` execution)** — concrete proof that large production CLIs
   use a shallow dispatcher + command-family submodules and never a single 1,000+ line handler; uv's
   parse→resolve→dispatch pipeline is the closest analogue to the `jr` situation. [8][9]

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 2 (attempted) | Deep synthesis on decomposition approaches — **TIMED OUT at 300s on BOTH attempts** (initial pass + coordinator-requested retry; Perplexity API non-response each time). Fell back to four high-context `perplexity_reason` calls, which are also web-grounded (`sonar-reasoning-pro`) and returned full citation sets. Deviation from the perplexity_research default is therefore forced by tool unavailability, not choice. |
| Perplexity perplexity_reason | 4 | (1) Decomposition-approach comparison + selection criteria + param-object-vs-free-fn + same-file-vs-submodule + testability; (2) OSS clap-CLI handler structure + verified clippy thresholds; (3) DISSENT pass — arguments against context structs, god-context anti-pattern, Rust borrow-splitting pain, plan/apply + dry-run pattern, characterization/golden-master testing, big-bang-vs-incremental; (4) additional dry-run/bulk-mutation clap CLIs (cargo-edit/ruff/biome/nushell/rustup/gitui/zellij/atuin/gix/sccache/etc.). All `search_context_size: high`. |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | Not needed — question is about refactoring patterns + language/lint guidance, not a specific library's API (Context7's stated non-use case is "refactoring / general programming concepts"). |
| Tavily | 0 | — |
| WebFetch | 0 | — |
| WebSearch | 0 | — |
| Read / Grep (local source) | 4 | Read actual `handle_edit`/`handle_list` signatures + bodies to ground the recommendation (the ~20-field clap-variant destructure observation; existing `handle_edit_bulk_*` seams). |
| Training data | 1 area | rust-analyzer "Extract function" assist availability (tooling name); low-risk, widely documented editor feature. |

**Total MCP tool calls:** 6 (2 timed-out `perplexity_research` + 4 successful `perplexity_reason`).
**Training data reliance:** low — pattern verdicts, clippy thresholds, module/visibility rules, the
dissent sources (matklad/rust-analyzer/Rustonomicon), the plan/apply exemplars (Terraform/k8s), and
all OSS-CLI examples are web-sourced with citations; only the rust-analyzer "Extract function" assist
name is from model knowledge. The PRIMARY deep-research tool timed out on both the initial run and
the coordinator-requested retry; mitigated by four web-grounded reasoning calls at high context that
returned complete citation sets, plus direct reading of the target source.

### Citation key (§1–§9)
[1] The Rust Book — Managing Growing Projects / Test Organization (doc.rust-lang.org/book ch07, ch11)
[2] The Rust Book — Modules to control scope & privacy (ch07-02)
[3] The Rust Reference — Visibility and Privacy (doc.rust-lang.org/stable/reference/visibility-and-privacy.html)
[4] Clippy Lint Configuration — `too-many-lines-threshold` (100), `too-many-arguments-threshold` (7) + lint recommendations (doc.rust-lang.org/clippy/lint_configuration.html; /clippy/lints.html)
[5] Clippy source — `clippy_lints/src/functions/mod.rs` lint help text (codebrowser.dev)
[6] Rust users forum / idiomatic-rust — refactoring into subfunctions; context-struct pattern discussions (users.rust-lang.org threads; mre/idiomatic-rust)
[7] Google Comprehensive Rust / Rust coding guidelines — named-field structs for multi-arg functions
[8] Cargo source — `src/bin/cargo/cli.rs`, `src/bin/cargo/commands/` (github.com/rust-lang/cargo)
[9] uv source — `crates/uv-cli/src/lib.rs`, `crates/uv/src/lib.rs::run`, `crates/uv/src/commands/` (github.com/astral-sh/uv; deepwiki)
[10] jj source — `cli/src/commands/mod.rs`, per-command files (github.com/jj-vcs/jj; deepwiki CLI architecture)
[11] ripgrep source — `crates/core/main.rs`, `flags/`, `search/` (github.com/BurntSushi/ripgrep)
[12] bat source — `src/bin/bat/main.rs` (github.com/sharkdp/bat)
[13] alacritty source — `alacritty/src/cli.rs` (github.com/alacritty/alacritty)
[14] gitui — `src/main.rs` (github.com/extrawurst/gitui) — body not retrievable, structure INCONCLUSIVE
[15] nushell source — `src/main.rs`, `command.rs`, `run.rs` (github.com/nushell/nushell)

### Citation key (§10 Deep-Research Completion)
[16] matklad — "Call-site Dependency Injection" (matklad.github.io/2020/12/28/csdi.html) — argues for passing specific deps over broad shared-state config
[17] rust-analyzer style guide (rust-analyzer.github.io/book/contributing/style.html) — endorses local `Ctx` as `&self` + `Config` struct, but "do not store Config as persistent state"
[18] Rust users forum — "Discussion: context struct pattern" (users.rust-lang.org/t/discussion-context-struct-pattern/49473) — "construct half the world" testing cost; keep contexts module-local
[19] The Rustonomicon — Borrow Splitting (doc.rust-lang.org/nomicon/borrow-splitting.html) — field-disjoint borrows work directly, not through `&self` methods
[20] HashiCorp Terraform — plan/apply workflow + saved-plan artifact (developer.hashicorp.com/terraform/cli/run, /commands/plan)
[21] Kubernetes Enhancements — dry-run KEP, client vs server-side (github.com/kubernetes/enhancements .../576-dry-run)
[22] Michael Feathers — characterization tests / Working Effectively with Legacy Code (understandlegacycode.com; infoq podcast)
[23] ApprovalTests / golden-master testing (github.com/approvals; codurance.com golden-master)
[24] cargo-edit — `cargo upgrade --dry-run` (github.com/killercup/cargo-edit README + CHANGELOG)
[25] Ruff — `crates/ruff_linter/src/fix/edits.rs`, `--fix`/`--diff`/`--unsafe-fixes` (github.com/astral-sh/ruff)
[26] Biome — `crates/biome_cli/src/commands/`, `.../src/execute/`, traversal pipeline (github.com/biomejs/biome; deepwiki command-execution-flow)
[27] Nushell — command modules `run(&self, engine_state, stack, call)` (github.com/nushell/nushell crates/nu-command)
[28] rustup — `src/cli/rustup_mode.rs`, `proxy_mode.rs`, `setup_mode.rs` (github.com/rust-lang/rustup)
[29] Floss vs root-canal / large-scale refactoring — geepawhill.org/large-scale-refactoring; softwareengineering.stackexchange refactoring-large-parts threads
