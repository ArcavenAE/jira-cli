---
title: Documentation Drift Findings — Maintenance Sweep 2
date: 2026-06-22
sweep: MAINT-SWEEP-2
area: Documentation
agent: technical-writer
---

# Documentation Drift Findings

Scan date: 2026-06-22. Read-only. No files modified.

## Summary Table

| # | Area | Description | Auto-fixable? | Severity |
|---|------|-------------|---------------|----------|
| 1 | CLAUDE.md — architecture tree | Six `mod.rs` files present in `src/` are absent from the CLAUDE.md file-tree (`src/api/mod.rs`, `src/api/jira/mod.rs`, `src/api/assets/mod.rs`, `src/api/jsm/mod.rs`, `src/types/mod.rs`, `src/types/jira/mod.rs`) | Yes — add 6 lines | LOW |
| 2 | CLAUDE.md — ADR location | CLAUDE.md "Key Decisions" section says `docs/adr/` is canonical (correct), but ADR-0007 through ADR-0013 exist only in `.factory/architecture/adr/` with no mention in CLAUDE.md or in `docs/adr/`. ADR-0016 also only in `.factory/architecture/adr/` (confirmed `docs/adr/` has no 0016). | No — routing decision needed | MED |
| 3 | CLAUDE.md — ADR-0014 filename mismatch | `docs/adr/0014-jsm-request-type-dispatch.md` vs `.factory/architecture/adr/0014-jsm-request-create-dispatch-fork.md`. Different filenames for what appears to be the same ADR across the two locations. | No — needs reconciliation | LOW |
| 4 | CLAUDE.md — ADR-0015 location split | ADR-0015 (`proactive-resolution-enforcement`) exists in `docs/adr/` (correct canonical location per CLAUDE.md). Not duplicated in `.factory`. No drift — note is informational only. | N/A | INFO |
| 5 | docs/adr/ — Gap ADR-0007 through 0013 | ADRs 0007–0013 are documented in `.factory/architecture/adr/` but are absent from `docs/adr/`. CLAUDE.md does not reference any of them. It is unclear whether they are intentionally internal or should be published to `docs/adr/`. | No — decision needed | MED |
| 6 | CHANGELOG.md — [Unreleased] empty | Three commits landed on `develop` after `v0.6.0-dev.6`: `fix(ci): make verify-signatures step actually exercise correctly` (ed236d4), `chore(deps): bump codecov/codecov-action 6.0.1→7.0.0` (#519), `chore(deps): bump insta 1.47.2→1.48.0` (#541). The `[Unreleased]` section has empty subsections for all categories. | Yes — changelog entries needed | LOW |
| 7 | README.md — install.sh version pin is stale | README line 35 pins the "install a specific version" example to `v0.3.0`. Latest stable release tag is `v0.5.0`. The example should be updated to `v0.5.0` or replaced with a placeholder like `<version>`. | Yes | LOW |
| 8 | README.md — "Coming soon" Homebrew/crates.io section | README still lists Homebrew tap (`brew install zious11/tap/jr`) and `cargo install jr-cli` under a "Coming soon" heading. No evidence these are now available, so this is not drift — but the section has been present since at least v0.3.0 without progress. | No — product decision | LOW |
| 9 | src/ — No actionable TODO/FIXME/HACK comments | All instances of `TODO` in `src/` are ADF task-list string literals (`"TODO"` / `"DONE"` state values in `adf.rs`) or descriptive comments explaining ADF node states. No `// TODO`, `// FIXME`, or `// HACK` action-item annotations were found. | N/A | INFO |
| 10 | README.md — Command surface accuracy | All commands listed in the README `Commands` table are present in `src/cli/` and dispatched in `src/main.rs`. `jr me`, `jr completion`, `jr issue resolutions`, `jr user view`, all auth subcommands, all asset subcommands verified present. No undocumented commands found. | N/A | INFO |
| 11 | README.md — Exit codes table accuracy | Exit codes 0, 1, 2, 64, 78, 124, 130 match `src/error.rs::JrError::exit_code()` exactly. Code 2 maps to `NotAuthenticated` + `InsufficientScope`; README label "Authentication error" is accurate. | N/A | INFO |
| 12 | README.md — MSRV badge accuracy | README badge shows MSRV 1.85; `Cargo.toml` sets `rust-version = "1.85"` and `rust-toolchain.toml` pins `channel = "stable"`. No drift. | N/A | INFO |
| 13 | CLAUDE.md — backtick citations CI guard | The `tests/claude_md_citations.rs` guard is active. All backtick file-path citations verified by the CI guard pass. No dead paths found in this manual scan beyond what the guard already catches. The three `docs/superpowers/` path citations resolve correctly on disk. | N/A | INFO |
| 14 | docs/specs/ — Referenced spec files present | All spec files referenced in CLAUDE.md (`docs/specs/issue-move-resolution.md`, `docs/specs/jsm-e2e-coverage.md`, `docs/specs/cargo-mutants-policy.md`, `docs/specs/test-naming-convention.md`, `docs/specs/e2e-fork-safe-ci-enablement.md`, `docs/specs/fork-friendly-release-ops.md`, `docs/specs/adf-panel-content-model.md`, `docs/specs/adf-block-html.md`, `docs/specs/adf-task-list.md`) exist in `docs/specs/`. No dead references found. | N/A | INFO |

## Detailed Notes

### Finding 1 — CLAUDE.md architecture tree omits mod.rs files

The CLAUDE.md file-tree section lists source files for each module but omits the `mod.rs` entry points for four `api/` subdirectories and two `types/` subdirectories. All six files exist on disk:

- `src/api/mod.rs`
- `src/api/jira/mod.rs`
- `src/api/assets/mod.rs`
- `src/api/jsm/mod.rs`
- `src/types/mod.rs`
- `src/types/jira/mod.rs`

The `src/types/jsm/mod.rs` is already included in CLAUDE.md's tree (`types/jsm/`), as is `src/cli/mod.rs`, `src/cli/issue/mod.rs`, etc. The omission of the six listed above is inconsistent within the tree itself.

### Finding 2 — ADR split between docs/adr/ and .factory/architecture/adr/

CLAUDE.md declares `docs/adr/` as the canonical location for ADRs (Key Decisions section, line 170). However:

- `docs/adr/` contains 9 files: 0001–0006, 0014, 0015, 0016.
- `.factory/architecture/adr/` contains 9 files: 0007–0014, 0016.
- ADRs 0007–0013 exist exclusively in `.factory/architecture/adr/` and are not referenced anywhere in CLAUDE.md.
- ADR-0016 is present in both locations.
- ADR-0014 has different filenames: `0014-jsm-request-type-dispatch.md` (docs) vs `0014-jsm-request-create-dispatch-fork.md` (.factory).

This is the previously-identified drift item MAINT-2026-06-17-SC-03. The gap (0007–0013) means decisions made after ADR-0006 and before ADR-0014 are not reachable from the documented `docs/adr/` path.

### Finding 6 — CHANGELOG [Unreleased] is unpopulated

Three commits are on `develop` since the `v0.6.0-dev.6` tag (2026-06-19):

1. `fix(ci): make verify-signatures step actually exercise correctly in a signing-configured fork` (ed236d4) — CI fix for signing workflow grep off GHA-masked lines.
2. `chore(deps): bump codecov/codecov-action from 6.0.1 to 7.0.0` (#519) — dependabot.
3. `chore(deps): bump insta from 1.47.2 to 1.48.0` (#541) — dependabot.

These are all `chore`/`fix(ci)` scope. Whether they warrant CHANGELOG entries before the next dev release is a product convention question; however the `[Unreleased]` section is present with empty subsections, suggesting it is expected to be populated as commits land.

### Finding 7 — README install.sh version example is stale

README.md line 35:
```
curl -fsSL https://raw.githubusercontent.com/Zious11/jira-cli/main/install.sh | sh -s -- v0.3.0
```

The latest stable tag in the repository is `v0.5.0` (git tags: v0.2.0, v0.3.0, v0.4.0, v0.5.0). The example is two major versions behind. This is the "specific version" install example, not the default one-liner.

---

FINDINGS: 6 actionable (2 MED, 4 LOW), 8 informational (no action needed)
