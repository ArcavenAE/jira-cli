---
document_type: f2-architecture-delta
phase: phase-f2-spec-evolution
feature: dead-citation-ci-guard
bundle: DEAD-CITATION-CI
created: 2026-06-19
status: complete
traces_to:
  - ".factory/phase-f1-delta-analysis/DEAD-CITATION-CI-delta-analysis.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-DEAD-CITATION-CI.md"
---

# F2 Architecture Delta — DEAD-CITATION-CI

## 1. Finding: No Structural Architecture Change

This bundle requires **no changes to any module in `src/`**, no new external
dependencies, and no modification to the existing architecture documents in
`.factory/architecture/`. The `jr` binary's module decomposition, its CLI
surface, its Jira/JSM/Assets API integration, its authentication flow, its
cache layout, and its output shapes are all entirely unchanged.

The bundle introduces one new test file (`tests/claude_md_citations.rs`) and
one documentation note in `CLAUDE.md`. Both are in the test and documentation
layers — outside the `src/` module graph that the architecture documents
describe.

## 2. Purity Boundary — Pure/Effectful Split

This feature introduces two logical components that live entirely in
`tests/claude_md_citations.rs`. Their purity classification is explicit:

### Pure: `extract_path_citations(doc: &str) -> Vec<String>`

This function is **deterministic and side-effect-free**: it takes a string
(the CLAUDE.md text, already loaded at compile time via `include_str!`) and
returns a sorted, deduplicated `Vec<String>` of candidate file paths after
applying the canonical normalization/skip pipeline specified by BC-X.13.002
(steps applied in this exact order — SR-004):

**Two-step extraction (pre-pipeline, unnumbered — SR-001):**
1. Extract all inline single-backtick spans (`` `…` ``) from the CLAUDE.md text. Fenced
   triple-backtick code blocks are OUT OF SCOPE and never read (M-1).
2. Split each span interior on ASCII whitespace. Each whitespace-delimited token is a
   candidate citation.

**Canonical normalization/skip pipeline (a)–(e), merged-fixpoint revision F2-Iter5:**
(a) **Glob skip**: skip entirely if the token contains `*`, `{`, or `}` anywhere
(b) **Normalize — single fixpoint**: repeat the following ordered sub-steps as ONE unit until a
    complete pass leaves the token unchanged — ONE termination condition (full-pass no-op):
    (1) strip a trailing `::…` symbol-form suffix (strip from first `::` onward);
    (2) strip a trailing `:~[0-9]+` or `:[0-9]+` line-ref suffix;
    (3) strip one leading `(` or `[`;
    (4) greedily trim trailing `.`, `,`, `;`, `:`;
    (5) trim one trailing `)` iff `count('(') < count(')')` whole-token;
    (6) trim one trailing `]` iff `count('[') < count(']')` whole-token.
    **Rationale for merge**: the former separated steps (b) symbol-strip, (c) line-ref-strip, (e)
    fixpoint-punct-trim ran in sequence without re-entering earlier steps. A token like
    `(src/config.rs:~42)` was a false-negative: the one-shot line-ref strip ran on the full token
    with its leading `(`, so `:~42$` didn't match; after punct-trim removed `(` and `)`, `:~42`
    was left unchecked. The merged single-fixpoint re-runs all sub-steps until stable, eliminating
    this ordering-class of bugs (F-PASS6-01).
(c) **Dir-prefix filter**: token must start with a develop-tracked directory prefix
    (`src/`, `tests/`, `docs/`, `.github/`, `scripts/`). ALL `.factory/` prefixes are EXCLUDED
    here — `.factory/` is NOT in the develop-tracked prefix set (it is git-ignored, lives in a
    separate orphan-branch worktree, and is ABSENT from the CI checkout).
    Section-ref tokens (`§N`-style) also lack a known directory prefix and are excluded here;
    whitespace tokenization has already separated them from preceding path tokens.
(d) **Extension filter**: token must end with a recognized file extension
    (`.md`, `.rs`, `.sh`, `.toml`, `.yml`, `.yaml`)
(e) **Path::exists() check**: only tokens surviving steps (a)–(d) reach this check

No I/O occurs. No global state is read or written. The function is
**suitable for inline `#[cfg(test)]` unit tests and proptest** — test
strategies can feed arbitrary doc strings and assert extraction behavior
without mocking any filesystem or network.

**VP-CITE-001 targets this function**: unit and property-based tests
cover the grammar completely in isolation.

### Effectful: `test_claude_md_citations_resolve_to_real_files`

This is the integration-level test function. It:

1. Loads `CLAUDE.md` at compile time via `include_str!("../CLAUDE.md")`
2. Calls `extract_path_citations` (pure — see above)
3. For each candidate path, calls `Path::new(env!("CARGO_MANIFEST_DIR")).join(&path).exists()`
   — this is a filesystem existence check (I/O)
4. On failure, panics with the CANONICAL failure message (CI-CITE-001, verbatim):
   ```
   CLAUDE.md cites file paths that do not exist on disk:
     <path> (line N)
   Fix the citation or restore the file.
   Note: .factory/, glob, and symbol-form tokens are auto-excluded.
   ```

There is NO `is_off_working_branch_allowlisted` function — `.factory/` exclusion
is handled entirely by the dir-prefix filter inside `extract_path_citations` (step (c)
above). The filesystem check (`Path::exists()`) is the **only effectful operation**
in this guard. It is deliberately placed at the outermost layer, keeping the grammar
logic (`extract_path_citations`) pure and independently testable.

**VP-CITE-002 targets this test**: the integration self-verification checks that the
guard is green on current develop HEAD and fails deterministically when a dead citation
is fed via a fixture string.

### Boundary Enforcement Note

The pure/effectful split is load-bearing for VP-CITE-001 testability:

- If path-extraction logic were merged into the integration test body,
  property-based tests would require mocking `Path::exists()` — impractical
  in Rust's standard test framework.
- By extracting `extract_path_citations` as a pure function (no `Path::exists`
  calls inside), proptest can exercise all glob-skip, symbol-form, line-ref,
  trailing-punct, dir-prefix, and extension-filter branches without any
  filesystem access.

This matches the purity convention established by `src/adf.rs` (ADF builder
is pure; I/O only at call sites in `cli/` handlers) and `src/partial_match.rs`
(matcher is pure; callers own the I/O context).

## 3. Test Family Classification

`tests/claude_md_citations.rs` belongs to the **`*_release_gate.rs` / doc-fallout
test family**. Existing members of this family include:

| Test file | Guard type |
|-----------|-----------|
| `tests/base_url_release_gate.rs` | Debug-only env-var gate (JR_BASE_URL) |
| `tests/config_dir_release_gate.rs` | Debug-only env-var gate (JR_CONFIG_DIR, JR_CACHE_DIR) |
| `tests/bulk_unknown_grace_release_gate.rs` | Debug-only env-var gate |
| `tests/bulk_await_timeout_release_gate.rs` | Debug-only env-var gate |
| `tests/ci_gate_completeness.rs` | CI workflow structural guard |
| `tests/ci_yml_windows_matrix.rs` | CI matrix structural guard |
| `tests/backfill_matrix_parity.rs` | CI matrix parity guard (S-FORK-OPS-BACKFILL-1) |
| `tests/claude_md_citations.rs` (NEW) | Doc-fallout citation-rot guard |

All members of this family are always-run (no `#[ignore]` gate, no env-var
required) and never make network calls. They are auto-collected by
`cargo test --all-features` — the same command that runs in the existing
`test` job in `ci.yml`. No change to `ci-gate.needs` is required.

## 4. CI Integration

The guard rides the existing `test` job in `ci-gate.needs`:

```
ci-gate.needs: [fmt, clippy, test, ...]
test job: cargo test --all-features (3-OS matrix: ubuntu, macos, windows)
```

`tests/claude_md_citations.rs` is compiled and collected automatically.
No new job, no new CI YAML entry, no `ci-gate.needs` modification is needed
or permitted (CLAUDE.md CI Gate convention — new required checks must join
`ci-gate.needs`, not bypass it; this guard joins via the existing `test` node).

`include_str!("../CLAUDE.md")` embeds `CLAUDE.md` at compile time, meaning:

- The guard catches dead citations in the SAME CI run that compiles the test binary
- No runtime file read is needed; `Path::exists()` is the only runtime I/O
- Windows path-separator handling is automatic via `Path::join` (not string concatenation)

## 5. DTU Assessment

**DTU_REQUIRED: false**

No new external service dependency is introduced. The guard is a pure test-time
structural check against the local filesystem. No HTTP, no Jira API calls, no OAuth
flows, no database, no message queue, no external auth provider.

The existing Jira Cloud API integrations catalogued in
`.factory/architecture/dtu-assessment.md` are entirely unaffected.

## 6. Gene Transfusion Assessment

**No gene transfusion candidates identified.**

The implementation is:
1. A regex/string parser for backtick content in Markdown — trivial (<50 LOC)
2. A whitespace tokenizer with extension and prefix filters
3. A `Path::exists()` filesystem check

None of these components have a reference implementation in another language
that would be worth translating. The implementation will be written from scratch
via standard TDD in F4.

## 7. Architecture Documents Status

| Document | Status |
|----------|--------|
| `.factory/architecture/system-overview.md` | UNCHANGED |
| `.factory/architecture/component-graph.md` | UNCHANGED |
| `.factory/architecture/cross-cutting.md` | UNCHANGED |
| `.factory/architecture/risk-register.md` | UNCHANGED |
| `.factory/architecture/dtu-assessment.md` | UNCHANGED |
| `.factory/architecture/adr/` (all ADRs) | UNCHANGED |
| `.factory/architecture/adr-index.md` | UNCHANGED |
| `.factory/architecture/state-machines.md` | UNCHANGED |

## 8. Scope Boundary

The `jr` binary's public API surface (CLI flags, JSON output shapes, exit codes),
its internal module decomposition, its crate dependency graph, its authentication
flow, its cache layout, and its Jira/JSM/Assets API integration are all entirely
unchanged.

F4 implementers should proceed directly from `prd-delta-DEAD-CITATION-CI.md`
and `verification-delta-DEAD-CITATION-CI.md` without any architecture pre-work.
The purity boundary documented in §2 is the critical design constraint for F4:
`extract_path_citations` must be a standalone pure function, not inlined into the
integration test body, to enable VP-CITE-001 proptest coverage.

There is NO `is_off_working_branch_allowlisted` function in the final
implementation. `.factory/` exclusion is achieved solely by the dir-prefix
filter inside `extract_path_citations` (step (c) in the canonical pipeline). Do
not implement or reference an allowlist function.
