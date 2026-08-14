---
story_id: S-MUTANTS-SCOPE-1
promoted_from: MUTANTS-SCOPE-GAP-QUEUE-MAIN
phase: F1
intent: enhancement
feature_type: infrastructure
trivial_scope: true
regression_risk: LOW (queue.rs) / MEDIUM (main.rs, scoped)
date: 2026-08-14
---

# Phase F1 Delta Analysis — S-MUTANTS-SCOPE-1

## 1. Summary

CI's in-diff `cargo-mutants` gate (`mutants` job, hard-required via `ci-gate.needs`,
per `docs/specs/cargo-mutants-policy.md`) silently reports "0 mutants — non-empty diff
produced no mutable lines in examine_globs files" for any PR touching only
`src/cli/queue.rs` or `src/main.rs`, because neither file is listed in
`.cargo/mutants.toml::examine_globs`. This is confirmed as a real, observed gap on
three merged PRs:

- **PR #696** (`c9218389`, "reject `--profile` on `auth switch`", breaking change) —
  touched `src/main.rs`. `mutants` job would have reported the false-green "0 mutants"
  path rather than exercising the new guard logic added to `run()`'s dispatch.
- **PR #698** (`c34f4db9`, "surface queue-declared custom fields in queue view JSON",
  #693) — touched `src/cli/queue.rs`. Same false-green.
- **PR #700** (`89164b8d`, "pin `collapse_and_truncate` 200-char boundary", F6 mutation
  survivor follow-up) — also touched `src/cli/queue.rs`; the fact that a *mutation
  survivor fix* landed for a file that isn't itself mutation-scoped is the clearest
  possible symptom of the gap: `collapse_and_truncate`'s mutants were presumably found
  by a manual/local `cargo-mutants` run, not by the CI gate.

By contrast, `src/cli/issue/edit.rs` **is** in `examine_globs` and correctly exercised
the gate at 4/4 kill rate on PR #697 (per drift-item note) — proving the gate mechanism
itself works correctly; this is purely a **scope-coverage gap**, not a defect in the
gate's decision logic.

## 2. Impact Boundary

### Files touched by the corrective (all CI-config/docs/guard-test layer — zero product `src/` runtime files)

| File | Change type | Nature |
|------|-------------|--------|
| `.cargo/mutants.toml` | MODIFIED | Add two `examine_globs` entries: `"src/cli/queue.rs"`, `"src/main.rs"` (see §5 for main.rs scoping recommendation — may end up as a targeted `#[mutants::skip]`-qualified full-file add, not a bare add) |
| `docs/specs/cargo-mutants-policy.md` | MODIFIED | §Scope bulleted list: two new entries with function-location citations (mirrors existing entries' format); `examine_globs` count line bump (currently states "16 entries" — will become 18) |
| `scripts/check-cargo-mutants-policy-citations.sh` | UNCHANGED (self-verifying) | No code change required — Guard 2 parses whatever §Scope currently contains and validates citations against `src/`; it is data-driven, not a fixed file list. New entries just need correct citation syntax in the policy doc. |
| `tests/mutants_glob_existence.rs` | UNCHANGED (self-verifying) | Guard 3's `test_resolve_all_examine_globs_entries_to_real_files` reads `.cargo/mutants.toml` via `include_str!` and glob-expands whatever is there — it will automatically validate the two new globs resolve to real files. `MUTANTS-GLOBS-COVERAGE-FLOOR` is pinned at `FLOOR: usize = 11`; going from 16→18 entries stays well above the floor, so **no PIN update needed** (floor only fires on *removal* below 11, never on addition — see the guard's own doc comment). |

**Confirmed: zero product `src/` runtime behavior changes.** `.cargo/mutants.toml` is
read only by the `cargo-mutants` binary (a dev/CI tool, not compiled into `jr`); it has
no `#[cfg]`/`build.rs` interaction with the shipped binary. This is a CI-scope +
documentation change exclusively.

### NEW vs MODIFIED vs DEPENDENT components (architect classification)

| Component | Classification | Rationale |
|-----------|-----------------|-----------|
| `.cargo/mutants.toml::examine_globs` array | MODIFIED | Existing list, two entries appended |
| `docs/specs/cargo-mutants-policy.md` §Scope | MODIFIED | Existing bulleted list, two entries appended; count/prose sync |
| `src/cli/queue.rs` (production code) | DEPENDENT | Not touched by this story — it becomes a mutation-testing *target*, not an edited file. Its behavior is unchanged; only its CI verification coverage changes. |
| `src/main.rs` (production code) | DEPENDENT | Same relationship — becomes a mutation target, code itself unchanged by this story. |
| `scripts/check-cargo-mutants-policy-citations.sh` | DEPENDENT | Consumes the modified policy doc; no edit needed because it's built to be data-driven (Guard 2 was explicitly designed this way per DEC-150). |
| `tests/mutants_glob_existence.rs` | DEPENDENT | Consumes the modified `.cargo/mutants.toml`; no edit needed for the same reason (Guard 3). |
| `.github/workflows/ci.yml` `mutants` job | DEPENDENT (unchanged) | Its invocation (`cargo mutants --in-diff … --jobs 4 --timeout 240`) is scope-agnostic — it reads whatever `examine_globs` says at run time. No CI YAML edit required. |

## 3. Affected Specs/BCs

Searched `.factory/specs/` and `docs/specs/cargo-mutants-policy.md` for a governing
behavioral contract on cargo-mutants scope:

- **No BC-S.SS.NNN governs `examine_globs` membership directly.** The only direct hit
  in `.factory/specs/prd/` is `bc-5-boards-sprints.md:230`, which explicitly documents
  a *different* pre-existing gap (a `"-"` mixed-set arm in `board.rs`/`list.rs`/
  `sprint.rs` "has no dedicated test fixture and is outside `examine_globs`") — i.e.
  the PRD already has precedent for citing `examine_globs` *exclusions* as accepted,
  documented gaps rather than governing them via a formal BC. This story does not
  need to create or amend a BC; it is process/tooling governance, consistent with how
  the existing 16-entry list was built up incrementally (S-345/S-346 baseline,
  S-288-pr4, S-576-1/-5, MAINT-MUTANTS-GLOBS-01) without per-addition BCs.
- `.factory/specs/prd/cross-cutting.md` (~lines 1574, 1759, 1769-1770) references the
  `mutants` CI job's `ci-gate.needs` membership and `S-MUTATION-CI-TIMEOUT-1`/
  `S-MUTANTS-SCOPE-GUARDS-1` as the stories that built the guard machinery
  (`check-cargo-mutants-policy-citations.sh` self-test idiom, `test_mutants_is_in_ci_gate_needs`).
  Neither references a fixed file enumeration that this story would contradict.
- **`docs/specs/cargo-mutants-policy.md` itself IS the governing artifact** for scope,
  and it explicitly disclaims prescriptiveness on membership: its own §Scope intro says
  "Configured in `.cargo/mutants.toml::examine_globs`" and treats the doc as a synced
  *citation* of whatever the TOML says, not the other way around — consistent with the
  MAINT-MUTANTS-GLOBS-01 "Sibling Candidates Considered and Deferred" table already in
  the doc, which is the established pattern for recording an inclusion/exclusion
  decision with rationale. This story's corrective should add a similar bulleted-list
  entry (not create a new document section).

### Version bump / INDEX touch assessment

- `docs/specs/cargo-mutants-policy.md` has no visible `version:` frontmatter field in
  the read content — it is versioned informally via dated section headers (e.g.
  "MUTATION-CI-TIMEOUT, 2026-06-28"). **Recommend**: add a dated subsection or amend
  the existing §Scope list in place, following the exact convention already used for
  the `issues.rs`/`cache.rs` MAINT-MUTANTS-GLOBS-01 addition (a citation line ending in
  `(added MAINT-MUTANTS-GLOBS-01)` for each new bullet, generalized here to
  `(added S-MUTANTS-SCOPE-1)`). No formal semver bump mechanism exists for this doc —
  none needed.
  - The "Current `examine_globs` count: 16 entries" line **MUST** be updated to 18 in
    the same edit — it is a self-admitted-drift-prone line ("verify against
    `.cargo/mutants.toml` before citing this number elsewhere — it has drifted before
    and will drift again"), and `check-cargo-mutants-policy-citations.sh` Guard 2
    parses the §Scope *bulleted list itself* (not this count line) for citation
    validation, so the count line is documentation-only prose, not guard input — but
    it should still be corrected for accuracy in the same commit (matches CLAUDE.md's
    "add a parallel line in the SAME commit" discipline pattern used elsewhere in this
    repo, e.g. the `JR_*` env var doc-fallout rule).
- **No INDEX files govern this doc.** Searched for a `CARGO-MUTANTS-INDEX.md` or
  similar — none exists. `docs/specs/cargo-mutants-policy.md` is a flat, standalone
  spec doc (matches the "Feature specs (post-v1)" convention in CLAUDE.md, one spec
  per feature, read before implementing — this doc *is* that feature spec for the
  mutation-testing feature, and it has no companion index).
- **CLAUDE.md itself** does not enumerate `examine_globs` membership (only references
  the tool and its config location at a high level: "Scope and config live in
  `.cargo/mutants.toml`; policy lives in `docs/specs/cargo-mutants-policy.md`") — no
  CLAUDE.md edit is required by this story.

## 4. Existing Guard Machinery — What Each Asserts Today, and Minimal Edits Needed

### `.cargo/mutants.toml`

Currently 16 `examine_globs` entries (verified by direct read — file content quoted in
research above), each a literal `src/...` path (no wildcard globs currently in use,
despite the "globs" name — every entry is a single-file exact path). Also sets
`additional_cargo_test_args = ["--all-features"]`. No `minimum_test_timeout` /
`timeout_multiplier` keys (deliberately removed per the MUTATION-CI-TIMEOUT
correction — `--timeout 240` lives on the CI command line instead).

**Minimal edit**: append two string entries to the `examine_globs` array, each with an
inline `#` comment explaining the addition (matching the file's existing convention of
a comment above/beside every non-obvious entry, e.g. the `# HIGH-value: …` comments
above `edit.rs`/`jsm_create.rs`/`interactions.rs`/`issues.rs`/`cache.rs`). See §5 for
whether `main.rs` should be a straight add or a more targeted one.

### `docs/specs/cargo-mutants-policy.md`

§Scope is a bulleted list, one bullet per `examine_globs` file, each bullet naming the
key functions covered and citing the story/decision that added it (`(added
MAINT-MUTANTS-GLOBS-01)`, `(added S-288-pr4)`, etc.) — this is exactly the format
`check-cargo-mutants-policy-citations.sh` Guard 2 parses (confirmed by reading the
script: it extracts the §Scope range via `awk '/^## Scope$/ {in_scope=1;…}'` bounded by
the next `^## ` or `^### Sibling Candidates` heading, then validates `(file, fn)` pairs
against real `src/` definitions via definition-anchored grep).

**Minimal edit**: two new bullets in the same format, e.g.:
```
- `src/cli/queue.rs` — `handle`, `handle_list`, `handle_view`, `resolve_queue_by_name`,
  `extra_fields_allow_list`, `is_customfield_token`, `reorder_by_queue_position`,
  `collapse_and_truncate` — JSM queue list/view dispatch, partial-match resolution,
  custom-field allow-list filtering, F6-hardened truncation boundary (added S-MUTANTS-SCOPE-1)
- `src/main.rs` — `init_tracing`, `run` (dispatch match, `--profile` validation,
  `InvalidSubcommand` intercept) — [scope caveat per §5 below] (added S-MUTANTS-SCOPE-1)
```
Plus the count-line correction (16 → 18) noted in §3.

### `scripts/check-cargo-mutants-policy-citations.sh`

Guard 2. **Fully data-driven — requires zero code change.** It parses whatever §Scope
currently contains at CI run time and validates each `(file, fn)` pair via
definition-anchored grep against `src/`. As long as the new bullets cite real,
currently-defined functions in `queue.rs`/`main.rs` (all of which exist today per the
direct file reads above — `handle`, `handle_list`, `handle_view`,
`resolve_queue_by_name`, `extra_fields_allow_list`, `is_customfield_token`,
`reorder_by_queue_position`, `collapse_and_truncate` in `queue.rs`; `init_tracing`,
`run` in `main.rs` — note `main()` itself is an unusual grep target since it's an
`async fn main()` under `#[tokio::main]`, worth citing `run` preferentially since that's
where the real dispatch logic lives), Guard 2 passes with no script edit. This mirrors
exactly how the `issues.rs`/`cache.rs` addition worked (MAINT-MUTANTS-GLOBS-01) — no
script change was needed then either.

**Risk to verify in F3/F4**: confirm the citation-grep pattern correctly resolves
`async fn run(cli: Cli) -> anyhow::Result<()>` and `fn init_tracing(cli: &Cli)` — both
are free functions at module scope, same shape as every other cited function in the
existing 16 entries, so this should be a non-issue, but it's worth a `--self-test`
dry run before merging (see `--self-test` flag documented in the script's own usage
comment).

### `tests/mutants_glob_existence.rs`

Guard 3. Also **fully data-driven, zero code change required**. It reads
`.cargo/mutants.toml` via `include_str!("../.cargo/mutants.toml")` at compile time,
extracts `examine_globs` via `extract_examine_globs_or_panic`, checks the coverage
floor (`assert_examine_globs_coverage_floor`, pinned `FLOOR: usize = 11`), and glob-
expands every entry via `validate_globs` (real `glob::glob()` expansion rooted at
`CARGO_MANIFEST_DIR`). `src/cli/queue.rs` and `src/main.rs` both exist as real files at
those exact paths, so `validate_globs` will resolve them with zero dead entries.

Going from 16 → 18 entries stays comfortably above `FLOOR = 11` — the floor guard only
fires on *removal* below 11 ("the floor is a lower bound; additions never fire it," per
the guard's own doc comment, confirmed by reading the two GREEN-boundary tests
`test_coverage_floor_does_not_panic_at_exact_threshold` (N=11) and
`_above_threshold` (N=12)). **No PIN update needed** in this test file.

### Summary: mutual-consistency edit set

| File | Edit required |
|------|----------------|
| `.cargo/mutants.toml` | YES — 2 new `examine_globs` entries |
| `docs/specs/cargo-mutants-policy.md` | YES — 2 new §Scope bullets + count-line correction (16→18) |
| `scripts/check-cargo-mutants-policy-citations.sh` | NO — data-driven, self-verifying |
| `tests/mutants_glob_existence.rs` | NO — data-driven, self-verifying |
| `.github/workflows/ci.yml` | NO — `mutants` job invocation is scope-agnostic |

This is a **narrow, two-file edit** with two self-verifying guard tests providing
automatic regression coverage of the edit's own correctness (glob resolution + citation
validity) — no new test-writing burden beyond what F4/F6 will already exercise by
running the guards.

## 5. CI-Duration Risk — Mutant Count Estimate and `main.rs` Scoping Recommendation

### Order-of-magnitude mutant count

Using the policy doc's own derivation model (`~140s avg per mutant / 4 jobs`) and the
existing scoped-file mutant counts as calibration points (e.g. `edit.rs` ~99 mutants at
~2,116 LOC post-split per DEC-149; `jsm_create.rs` ~9 mutants at a much smaller LOC —
these two data points alone show mutant density is **not** linear in raw LOC; it tracks
branch/conditional/comparison density, which varies enormously by function shape):

- **`src/cli/queue.rs`**: ~338 LOC of production code (592 total − ~254 inline test
  LOC). Structurally similar in density to other mid-sized CLI handler files already
  scoped (`interactions.rs`, `requesttype.rs`). Contains real branch/comparison surface:
  `match` arms in `QueueIdSource`, `partial_match` result handling (4-arm match in
  `resolve_queue_by_name`), the `is_customfield_token` regex-equivalent digit-scan
  guard, `collapse_and_truncate`'s boundary arithmetic (already known to have produced
  live mutation survivors per PR #700's title — direct evidence this file has real,
  killable-but-currently-unkilled mutants), and `reorder_by_queue_position`'s
  `HashMap`-based sort-key logic. **Estimate: ~15-30 mutants** — comparable to or
  somewhat above `jsm_create.rs`'s ~9, well below `edit.rs`'s ~99. Low CI-duration risk.

- **`src/main.rs`**: 422 LOC, no inline tests, but a large fraction of that is straight-
  line async dispatch wiring (the `match cli.command { … }` block in `run()`, ~lines
  164-412) — each arm is a single expression/await call with no internal branching
  cargo-mutants can meaningfully mutate beyond return-value/literal substitution (which
  the existing 74 assert_cmd-based subprocess integration tests across `tests/` already
  exercise per-command, since they invoke the compiled `jr` binary end-to-end). Real
  branch/conditional density is concentrated in a much smaller subset:
  - `init_tracing`'s 3-way level `if/else if/else` (~lines 24-30) — covered by
    `tests/verbose_bodies.rs`, `tests/observability.rs`.
  - The `InvalidSubcommand` intercept block (~lines 56-91, nested `if`s, `.eq_ignore_ascii_case`
    calls, `std::process::exit(2)` literals) — covered by `tests/cli_smoke.rs` (multiple
    named tests asserting exact stderr text and exit code 2).
  - `no_color`/`NO_COLOR` check (~line 94) — covered (grep-confirmed test file references).
  - The stdin-TTY auto-`no_input` flip (~lines 103-115), including the debug-only
    `JR_STDIN_IS_TTY` seam — covered by `tests/jr_stdin_is_tty_release_gate.rs` plus
    several interactive-flow tests that rely on it.
  - The post-`run()` error-mapping block in `main()` (~lines 124-148): exit-code
    resolution via `.chain().find_map(...)`, the JSON-vs-text `match output_format`
    branch — very likely covered indirectly by the large number of exit-code/JSON-error
    assertions across `tests/`, though this was not exhaustively verified per-line.
  - **The `tokio::select! { result = main_task => result, _ = tokio::signal::ctrl_c() => {…} }`
    fork at ~lines 415-421 — CONFIRMED ZERO existing test coverage** (grep for
    `ctrl_c`/`SIGINT`/`signal::` across `tests/` returned no hits). This is the one
    genuinely timeout/un-killable-prone region: mutating the `ctrl_c()` arm (e.g.
    changing `130` to another exit code, deleting the `eprintln!`, or altering the
    `select!` arm order) has **no test that can observe the difference**, because
    exercising it requires sending an actual OS signal to a running subprocess mid-async-
    task — a fundamentally different test shape (timing-sensitive, signal-based) than
    anything in the current suite. A cargo-mutants run against this block would likely
    produce **guaranteed survivors** here, not timeouts per se (the mutated code still
    compiles and runs fine under the existing test suite, which never triggers this
    branch at all) — so the practical risk is a **kill-rate hit**, not a CI-duration/
    timeout hit.

  **Estimate: ~10-20 mutants total for `main.rs`**, of which perhaps 3-6 fall inside or
  adjacent to the `ctrl_c` fork and are very likely **unkillable without new signal-
  based tests that don't currently exist and are out of scope for this story to write**.

### Recommendation: main.rs — full-file scope, WITH an explicit follow-up flag on the `ctrl_c` fork (do not silently accept degraded kill-rate)

Given the policy doc's own **Whitelist Convention** (§"Whitelist Convention" in
`docs/specs/cargo-mutants-policy.md`) explicitly **forbids** `#[mutants::skip]` for
reasons like "it's hard to test" ("Invalid justifications: … 'It's hard to test' — that
is a refactoring opportunity, not a reason to skip") and restricts valid justifications
to three narrow categories (defensive-unreachable-guard, performance-only-optimization,
debug-only-assertion) — **none of which cleanly cover a signal-handler async fork** —
this F1 analysis does **not** recommend a pre-emptive `#[mutants::skip]` on the
`ctrl_c` block as part of this story. Doing so would require a judgment call about
whether "async hang / untestable interrupt path" is a legitimate fourth category, which
the policy doc does not currently authorize and which should be a deliberate,
human-reviewed decision (the same "code review MUST reject any PR that adds a bare
whitelist attribute" discipline the doc already enforces for bare skips applies with
equal force to *justified-but-novel-category* skips).

**Recommended scope for F3/F4**: add `src/main.rs` to `examine_globs` **as a whole
file** (matching every existing entry's granularity — none of the 16 current entries
use function-level or line-range sub-scoping; cargo-mutants' `examine_globs` operates at
file granularity only, it has no sub-file targeting mechanism). Accept that the
`ctrl_c` fork will very likely produce a small number of surviving mutants on first
run, consistent with how the policy doc's own **Deferral Policy** (§"Deferral Policy")
already anticipates: *"The initial baseline PR (S-346) MUST NOT block on achieving 90%
kill-rate on first run… When the baseline reveals surviving mutants below 90%: 1.
Whitelist clearly-defensive mutants per the convention above with justification
comments."* — this is precisely the intended process for a first-run addition, not a
reason to pre-emptively exclude the file. F6 (targeted hardening) is the natural phase
to decide, with human input, whether the `ctrl_c` survivors get a policy-doc-amending
`#[mutants::skip]` justification (would require expanding the three valid categories)
or a small dedicated signal-based test (e.g. spawning the subprocess and sending
`SIGINT` via `nix::sys::signal` or similar, asserting exit code 130 and the
"\nInterrupted" stderr line) is written instead — the latter is more consistent with
"Tests don't cover this... is a gap to close, not a reason to skip."

**CI duration verdict**: combined `queue.rs` (~15-30) + `main.rs` (~10-20) ≈ **25-50
mutants total** for a PR touching both files — well within the "Typical adf.rs PR"
tier (~80 mutants / ~47 min) in the policy doc's own budget table, far below the
"oversized diff" 400+ threshold. **LOW CI-duration/timeout-flake risk.** The
`ctrl_c`-fork survivors, if any, will show up as a **kill-rate dip below 90%** on
whichever PR first touches `main.rs` post-scoping (not a timeout, not a job
cancellation) — this is a correctness/process risk to flag for F3/F4 planning, not a
CI-infrastructure risk.

## 6. Regression Risk Enumeration

| Risk | Likelihood | Severity | Rating | Rationale |
|------|-----------|----------|--------|-----------|
| CI job duration blowup / 240-min timeout-minutes ceiling breach | Very Low | Medium | **LOW** | ~25-50 estimated combined mutants is roughly half the "Typical adf.rs PR" (~80) tier; nowhere near the 400+ oversized-diff signal. |
| Per-mutant `--timeout 240` flakes (individual mutant timeout, not job timeout) | Low | Low | **LOW** | Neither file has async sleeps, real wall-clock waits, or wiremock-dependent long-poll logic (unlike `bulk.rs`, the documented root cause of the original MUTATION-CI-TIMEOUT incident). `queue.rs`'s HTTP calls go through the same `JiraClient` retry/backoff machinery already exercised safely in `issues.rs`'s existing mutation scope. |
| `check-cargo-mutants-policy-citations.sh` self-test regression | Very Low | Low | **LOW** | Guard 2 is purely data-driven off the doc text; adding two correctly-formatted, function-citing bullets cannot break its 12 self-test fixtures (`--self-test` fixtures are independent of real `src/`/doc content — confirmed by script's own `--self-test`/`--policy-doc` flag design intended for offline verification). Real-mode Guard 2 run against the *updated* doc is the actual regression surface — low risk given both new file's functions are grep-friendly free functions, same shape as all 16 existing entries. |
| `tests/mutants_glob_existence.rs` regression | Very Low | Low | **LOW** | Both new glob entries resolve to real, extant files (confirmed via direct `ls`/read); `FLOOR = 11` is not threatened by an 16→18 addition; Guard 3's own test suite (9 tests, all read-only against either real or inline-mock TOML) is unaffected by a real-config content change since only `test_resolve_all_examine_globs_entries_to_real_files` reads the real file, and it is designed to pass for any valid, resolvable glob list. |
| `main.rs` kill-rate dip below the CI-enforced 90% floor on first scoped PR | **Medium** | Medium | **MEDIUM** | As analyzed in §5 — the `ctrl_c`/SIGINT fork has zero existing coverage and no clean whitelist-convention category. This is a real, foreseeable risk that should be called out explicitly to the human at the F1 gate and revisited at F3 (decide: new signal test vs. policy-doc category expansion) rather than silently deferred. **This is the single highest-attention item in this delta analysis.** |
| Accidental widening beyond the two intended files (scope creep) | Low | Low | **LOW** | The corrective is narrowly specified (exactly two files); Guard 3's coverage floor and Guard 2's citation validation both act as automatic tripwires if unrelated entries are accidentally added or malformed. |
| Product `src/` runtime behavior regression | None | N/A | **N/A** | This story makes zero edits to `src/` production code. Confirmed in §2. |

## 7. Story Sizing

**Single small story — no epic, no sub-story decomposition needed.**

- Touches exactly 2 files with concrete edits (`.cargo/mutants.toml`,
  `docs/specs/cargo-mutants-policy.md`), both narrow, additive, well-precedented edits
  following an established pattern (MAINT-MUTANTS-GLOBS-01 is the direct template).
  Two additional files (`scripts/check-cargo-mutants-policy-citations.sh`,
  `tests/mutants_glob_existence.rs`) require zero code changes and serve purely as
  automatic verification of the edit's own correctness.
- Meets the **trivial-scope** criteria from `feature-mode-scoping-rules`: single-purpose
  config/doc change, no new BCs, no architecture change, no new external dependencies.
  The one caveat keeping this from being a rubber-stamp trivial change is the `main.rs`
  kill-rate risk in §5/§6 — **regression risk is LOW for the config/doc edit itself,
  but MEDIUM for the downstream first-mutation-run consequence on `main.rs`.** This
  nuance should be surfaced to the human at the F1 approval gate rather than silently
  waved through as pure quick-dev routing, even though the mechanical edit qualifies.

### Acceptance-criteria seeds for F3

1. `.cargo/mutants.toml::examine_globs` contains exactly `"src/cli/queue.rs"` and
   `"src/main.rs"` as new entries (18 total), each with an explanatory inline comment
   matching the file's existing convention.
2. `docs/specs/cargo-mutants-policy.md` §Scope contains two new bullets citing real,
   currently-defined functions in both files, and the "Current `examine_globs` count"
   line is corrected to 18.
3. `scripts/check-cargo-mutants-policy-citations.sh` (canonical, non-self-test mode)
   passes against the updated doc + `src/` tree with zero offenders.
4. `tests/mutants_glob_existence.rs::test_resolve_all_examine_globs_entries_to_real_files`
   passes (both new globs resolve, floor unaffected).
5. A local (or CI) `cargo-mutants --in-diff` dry run against a synthetic diff touching
   `queue.rs`/`main.rs` produces a non-"0 mutants" result, proving the false-green is
   closed.
6. **Explicit human decision recorded** (not silently defaulted) on how the `main.rs`
   `ctrl_c`/SIGINT fork's expected kill-rate gap is to be handled: (a) accept a below-
   90%-on-first-run baseline per the Deferral Policy and defer to a follow-up story, (b)
   write a new signal-based subprocess test in the same story, or (c) propose a policy-
   doc amendment adding a fourth valid `#[mutants::skip]` justification category for
   untestable-signal-handling code. This decision is explicitly OUT of this F1
   analysis's authority (F1 is analysis-only) and must be made at the F1 human-approval
   gate or deferred explicitly to F3/F6 planning.
7. No `src/` production files are modified by this story (regression baseline:
   the full existing test suite, unmodified, remains the safety net — this story adds
   *verification* coverage, it does not change *behavior*).

## 8. Files NOT Changed (Regression Baseline)

Every file in the repository other than `.cargo/mutants.toml` and
`docs/specs/cargo-mutants-policy.md`. In particular, explicitly confirmed unchanged:
`src/cli/queue.rs`, `src/main.rs` (production code — become mutation *targets*, not
edited files), `.github/workflows/ci.yml`, `scripts/check-cargo-mutants-policy-citations.sh`,
`tests/mutants_glob_existence.rs`, and all other 16 pre-existing `examine_globs`
entries and their citations.

## 9. Recommended Scope for Subsequent Phases

- **F2 (spec evolution)**: none required beyond the doc edit already scoped in §3/§4 —
  no BC/architecture/VP changes.
- **F3 (incremental stories)**: single story, no dependency-graph integration concerns
  (pure CI-config change, no code dependents). Must carry forward the open decision in
  Acceptance-criteria-seed #6 to the human.
- **F4 (delta implementation)**: two-file edit; full regression suite as safety net
  (already true for any PR — no special handling needed beyond the standard CI gate,
  which is precisely what this story is fixing the scope of).
- **F5 (scoped adversarial)**: review the two-file diff plus, if written, any new
  signal-based test for `ctrl_c` coverage.
- **F6 (targeted hardening)**: the natural home for resolving the `main.rs` kill-rate
  question from §5/§6/Acceptance-criteria-seed #6, and for reviewing the first real
  `queue.rs`/`main.rs` mutation run's actual kill rate against the 90% floor.
- **F7 (delta convergence)**: confirm the CI gate itself passes end-to-end on a real PR
  touching only `queue.rs` or only `main.rs`, proving the false-green is closed in
  production, not just in local `--self-test` runs.
