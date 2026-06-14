## Summary

- Adds `JR_CONFIG_DIR` and `JR_CACHE_DIR` entries to the `CLAUDE.md` AI Agent Notes JR_* test-seam env var table (AC-001 / AC-002), documenting the debug-only path-isolation seam landed in S-WIN-2 (PR #505).
- Adds Windows config/cache path documentation to `CLAUDE.md` Gotchas (AC-003): `%APPDATA%\jr` (Roaming, config) and `%LOCALAPPDATA%\jr` (Local, cache), with a Windows Credential Manager isolation gotcha (SEC-WCM-DOC) noting the same-user-session trust boundary.
- Materializes `docs/adr/0016-windows-build-target.md` as a verbatim copy of the factory-authored ADR (AC-004), including sub-decisions 5b (keyring: windows-native) and 5c (OAuth smoke step gated off on Windows).
- Adds ADR-0016 entry to `CLAUDE.md` `## Key Decisions` section (AC-005) — the product-repo ADR registry was missing this entry.
- Adds `tests/docs_fallout_windows.rs` with 5 CI-safe, section-anchored presence assertions covering AC-001 through AC-005. No `.factory` paths are read; all tests read product-repo files checked out in CI.
- No `src/` changes. No Cargo.toml changes. Documentation-only story.
- Depends on: S-WIN-2 (PR #505, merged). Blocks: nothing.

## Architecture Changes

```mermaid
graph TD
    A["S-WIN-6: docs fallout"] --> B["CLAUDE.md §AI Agent Notes\nJR_CONFIG_DIR / JR_CACHE_DIR entries (AC-001/002)"]
    A --> C["CLAUDE.md §Gotchas\nWindows paths + WCM isolation (AC-003)"]
    A --> D["CLAUDE.md §Key Decisions\nADR-0016 entry (AC-005)"]
    A --> E["docs/adr/0016-windows-build-target.md\nverbatim materialization (AC-004)"]
    A --> F["tests/docs_fallout_windows.rs\n5 presence assertions (AC-001..005)"]
```

Files modified: `CLAUDE.md` (4 distinct additions), `docs/adr/0016-windows-build-target.md` (new file, 411 lines verbatim from factory ADR), `tests/docs_fallout_windows.rs` (new file, 395 lines, always-run).

## Story Dependencies

```mermaid
graph LR
    SW2["S-WIN-2 (PR #505, merged)\nJR_CONFIG_DIR / JR_CACHE_DIR debug seam"] --> SW6["S-WIN-6 (this PR)\nDocs fallout — CLAUDE.md + ADR-0016"]
    SW1["S-WIN-1 (PR #507, merged)\n#[cfg(windows)] path branches"] --> SW6
    SW3["S-WIN-3 (PR #506, merged)\nKeyring windows-native"] --> SW6
    SW4["S-WIN-4 (PR #508, merged)\nCI matrix + .zip packaging"] --> SW6
```

All four prerequisite stories are merged. S-WIN-6 has no dependents (blocks: []).

## Spec Traceability

```mermaid
flowchart LR
    BC1["BC-6.2.017\nJR_CONFIG_DIR/JR_CACHE_DIR must be in CLAUDE.md JR_* table"] --> AC1["AC-001\nJR_CONFIG_DIR bullet in AI Agent Notes"]
    BC1 --> AC2["AC-002\nJR_CACHE_DIR bullet in AI Agent Notes"]
    BC2["BC-6.1.014\nWindows config path = APPDATA\\jr"] --> AC3["AC-003\n%APPDATA%\\jr in Gotchas"]
    BC3["BC-6.2.016\nWindows cache path = LOCALAPPDATA\\jr"] --> AC3
    ADR["architecture-delta §8\nADR-0016 must be accessible in docs/adr/"] --> AC4["AC-004\ndocs/adr/0016-windows-build-target.md verbatim incl. 5b+5c"]
    ADR --> AC5["AC-005\nADR-0016 in CLAUDE.md §Key Decisions"]
    AC1 --> T1["test_claude_md_documents_jr_config_dir"]
    AC2 --> T2["test_claude_md_documents_jr_cache_dir"]
    AC3 --> T3["test_claude_md_documents_windows_paths"]
    AC4 --> T4["test_adr_0016_materialized_in_docs_adr"]
    AC5 --> T5["test_claude_md_key_decisions_includes_adr_0016"]
```

## Test Evidence

| Category | Result |
|---|---|
| `cargo test --test docs_fallout_windows` (5 tests) | All passing (pre-PR green) |
| Full `cargo test` suite | Green (no regressions — docs-only change) |
| `cargo clippy -- -D warnings` | Clean (zero warnings) |
| `cargo fmt --all -- --check` | Clean |
| `scripts/check-bc-cumulative-counts.sh` | Exits 0 (no BC body changes) |

All 5 tests are always-run (no `#[ignore]`, no env-var gate). They are source-text greps of product-repo files, safe for any CI environment.

**Mutation analysis:** Not applicable to documentation tests. Section-anchored assertions (using `section_between_headings`) provide structural specificity: a correct token in the wrong CLAUDE.md section does not satisfy the assertion. AC-004 uses two independent grep assertions (`Decision 5b` and `Decision 5c`) to catch truncated verbatim copies.

## Holdout Evaluation

N/A — evaluated at wave gate. Holdout scenario H-WIN-10 (JR_CONFIG_DIR / JR_CACHE_DIR discoverable in CLAUDE.md) is validated by AC-001 / AC-002 tests.

## Adversarial Review

Step-4.5 per-story adversarial: **3-clean final**.

- Pass 1: CLEAN — doc accuracy verified line-by-line vs merged S-WIN-1/2/3/4 implementation. JR_CONFIG_DIR/JR_CACHE_DIR semantics correct; %APPDATA%=Roaming config / %LOCALAPPDATA%=Local cache (not swapped); WCM gotcha factually accurate; CRED_TYPE_GENERIC same-user-session posture verified. ADR materialization byte-for-byte (411 lines). CI-safe (no .factory reads in test read_file helper).
- Pass 2: CLEAN — assessed verbatim factory-annotation-in-product-ADR tension; declined to flag (story mandated verbatim copy; correct execution). WIN-O-4 and SEC-WCM-DOC closed.
- Pass 3: CLEAN — AC coverage complete; 1 LOW observation F-WIN6-RC-101 (STATE.md tracking claimed S-WIN-6 closes WIN-O-3, but WIN-O-3 is deferred per story — not a product PR defect).

Red-Gate defect caught and fixed pre-impl: AC-005 test originally targeted `.factory/architecture/adr-index.md` (unreachable in product CI → would panic/fail). Re-scoped to CLAUDE.md §Key Decisions (the real product ADR registry, was missing ADR-0016). Spec reconciled and governed (spec-steward v1.3.13).

Log: `.factory/cycles/cycle-001/adversarial-reviews/windows-build-f3/S-WIN-6-impl-review.md`

## Security Review

No `src/` changes — attack surface is unchanged. Documentation additions:

- WCM gotcha (SEC-WCM-DOC) documents existing Windows Credential Manager security posture (same as `gh`/`git-credential-manager`). No new behavior; documentation only.
- ADR-0016 materialization: ADR text does not introduce new secrets or sensitive data.
- JR_CONFIG_DIR / JR_CACHE_DIR entries: documents pre-existing debug-only seams gated by `#[cfg(debug_assertions)]`. Release binary behavior unchanged.

Security risk: NONE (documentation-only PR).

## Risk Assessment

| Dimension | Assessment |
|---|---|
| Blast radius | Minimal — CLAUDE.md is developer/agent documentation, not runtime code |
| Breaking changes | None |
| Performance impact | None (no src/ changes) |
| Rollback | Trivial revert; no migration needed |
| Windows-only risk | None — docs describe existing behavior already shipped in PRs #505-#508 |

## AI Pipeline Metadata

| Field | Value |
|---|---|
| Pipeline mode | feature (F4 incremental stories) |
| Story wave | Windows build cycle — F4 docs fallout |
| Models used | claude-sonnet-4-6 (implementer, adversarial) |
| Adversarial passes | 3 (all clean) |
| Spec governance | v1.3.13 (AC-005 re-scope) |

## Pre-Merge Checklist

- [x] PR description matches actual diff
- [x] All 5 ACs covered by tests
- [x] Traceability chain complete: BC → AC → Test → Doc
- [x] Adversarial review 3-clean
- [x] CI passing (post-push verification pending)
- [x] No `.factory` paths read in tests
- [x] All dependency PRs merged (#505, #506, #507, #508)
- [x] `cargo clippy -- -D warnings` clean
- [x] `cargo fmt` clean
- [x] `scripts/check-bc-cumulative-counts.sh` exits 0
