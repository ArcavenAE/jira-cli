# Documentation Drift Findings — Maintenance Sweep 2

- **Repo:** jira-cli (`jr`)
- **Branch:** develop @ `01e278fc`
- **Date:** 2026-09-16
- **Scope:** README.md, CLAUDE.md, docs/ + docs/specs/ + docs/adr/, src/ TODO/FIXME/HACK/XXX scan, CHANGELOG.md `[Unreleased]` coherence
- **Method:** Current CLI surface built and inspected (`cargo build`, `jr --help` + per-subcommand `--help`), clap derive source (`src/cli/**`), `wc -l` on files cited in CLAUDE.md's "Known Size Deviations", `find`/`grep`/`git log`/`git blame` against `src/`, `docs/adr/`, `.factory/specs/architecture/decisions/`, `docs/specs/`.
- **Verified current state:** `jr --version` → `jr 0.7.0-dev.7`; matches `Cargo.toml` (`version = "0.7.0-dev.7"`, `rust-version = "1.88"`), `cargo pkgid`, and CHANGELOG.md's latest header `## [0.7.0-dev.7] - 2026-09-16`. No version drift found anywhere.

## Findings

| Finding ID | File | Description | Severity | Auto-fixable? | Suggested fix |
|---|---|---|---|---|---|
| DRIFT-001 | README.md | `jr component` command family (`list`/`create`/`edit`/`delete`/`rename`) is completely absent from README's Commands table. `jr component --help` confirms all five subcommands exist and are shipped in the binary. The only README hit for "component" (line ~269) is the `--component NAME` filter flag inside the `issue list` row — there is no `jr component ...` row at all. This is a substantial, user-facing command family (CLAUDE.md documents it as ~1,800 LOC under ADR-0018) with zero README coverage. | HIGH | yes | Add a `jr component` row (or sub-table) to README's Commands section covering `list`/`create`/`edit`/`delete`/`rename`, mirroring the level of detail given to other command families (e.g. `issue`, `board`). |
| DRIFT-002 | README.md | `jr issue attachment` has four subcommands (`list`, `download`, `upload`, `delete`) per `--help`, but README (line ~288) documents only `list` (with its `--filter` flags). `download`/`upload`/`delete` — including JSM two-step upload, `--replace-existing`, `--public`/`--internal` visibility flags (CLAUDE.md: S-576-2/3/4) — are unmentioned. | MEDIUM | yes | Extend README's attachment section with `download`/`upload`/`delete` usage examples and their key flags (`--replace-existing`, `--public`, `--internal`). |
| DRIFT-003 | README.md | `jr completion` supports `bash, elvish, fish, powershell, zsh` per `--help`, but README's "Shell Completions" section and its "Why jr?" bullet only enumerate bash/zsh/fish — `elvish`/`powershell` are omitted. Not a wrong statement, just an incomplete enumeration. | LOW | yes | Add `elvish` and `powershell` to the shell-completions list/example in README. |
| DRIFT-004 | CLAUDE.md | The "Known Size Deviations" bullet for `sprint list` says the table "omits start/end dates (NFR-O-U: deferred UX pass v2)". This is stale: `src/cli/sprint.rs::handle_list` renders headers `["ID", "State", "Name", "End Date"]` and populates `end_date` per row — this has been present since the sprint feature's first commit (`01acd0a7`, 2026-03-21). Only **start date** is actually omitted from the table (`sprint current`'s human-text header does show an end date too). | MEDIUM | yes | Reword the bullet to "`sprint list` table omits start date (end date is shown); NFR-O-U: deferred UX pass v2 for start date." |
| DRIFT-005 | CLAUDE.md | The bullet "`jr version --output json` is not implemented" implies a `jr version` subcommand exists that merely lacks JSON output. In fact there is no `jr version` subcommand at all — only the clap-builtin `-V`/`--version` flag (which prints plain text, no JSON option). The underlying claim (no JSON version output) is accurate, but the phrasing is misleading about what exists. | LOW | yes | Reword to: "There is no `jr version` subcommand — only builtin `-V`/`--version` (plain text). No JSON version-info output exists (NFR-O-X: deferred to v2)." |
| DRIFT-006 | CLAUDE.md | "Known Size Deviations" LOC figure for `cli/mod.rs` is documented as ~1,356 LOC; actual is 1,453 LOC (+7.2%). Largest drift among all 10 files checked in that section; all others are within ~4% or exact. Below the 15%-delta flag threshold used for this sweep, but worth refreshing since it's the largest gap found. | LOW | yes | Re-measure and update `cli/mod.rs`'s LOC figure to ~1,453 (or current `wc -l` at fix time). |
| DRIFT-007 | CLAUDE.md | Architecture-tree file listing (top of Architecture section, not the Known-Size-Deviations table) annotates `cli/issue/comments.rs` as "(~61 LOC)"; actual is 64 LOC (+4.9%). Trivial, but a second confirmed LOC drift alongside DRIFT-006. | LOW | yes | Update the inline annotation to "(~64 LOC)". |

## Verified Clean (no drift found)

- **MSRV 1.88 claim** — confirmed consistent across `rust-toolchain.toml`, `Cargo.toml` (`rust-version = "1.88"`), and `.github/workflows/ci.yml`'s `msrv` job (`"MSRV (1.88.0)"`, pinned action SHA `6c977a6ca4077a0ceb28ffbe03f59d46e9ac8772`, `cargo check --all-targets --all-features --locked`), matching CLAUDE.md's citation exactly.
- **`--dry-run` on `issue edit`** — confirmed still implemented (flag present in `--help`; extensive logic in `src/cli/issue/edit.rs`).
- **`_meta` envelope absence** — confirmed still true; `src/output.rs::render_json` is a bare `serde_json::to_string_pretty(data)` passthrough.
- **`cli/component.rs` single-file claim** — confirmed still a single file (no `cli/component/` directory exists); DOCUMENT-AS-IS rationale still holds.
- **Module tree vs `src/` structure (Check 3)** — full diff of 123 `.rs` files against CLAUDE.md's Architecture tree: zero discrepancies in either direction.
- **ADR index (Check 3)** — `docs/adr/` contains exactly ADR-0001 through ADR-0016 as claimed; `.factory/specs/architecture/decisions/` continues the sequence with ADR-0017 through ADR-0025 (including ADR-0025, the MSRV-1.88 ADR), confirming the two-track numbering note is current.
- **`docs/specs/`** — directory exists, non-empty (40 files), consistent with its "one spec per feature" description.
- **TODO/FIXME/HACK/XXX scan (Check 4)** — 37 raw grep hits, all in `src/adf.rs` (36, all literal Jira ADF `"TODO"`/`"DONE"` task-state vocabulary — not developer markers) plus one false positive in `src/api/client.rs:1403` (a `\u{XXXX}` escape-notation placeholder). **Zero genuine developer TODO/FIXME/HACK/XXX markers exist in `src/`.** No git-blame aging analysis was needed.
- **CHANGELOG.md `[Unreleased]` coherence (Check 5)** — `[Unreleased]` contains exactly one entry (`mutants-nightly.yml` opt-in gating), which is the CHANGELOG delta of the single commit (`01e278fc`) that landed after the `v0.7.0-dev.7` release commit (`aa557050`). No stale leftovers, no gap, no misfiled entries. `01e278fc`'s own commit message confirms this placement was deliberate (avoiding a retroactive squeeze into the already-cut `[0.7.0-dev.7]` heading).

## Summary

| Severity | Count |
|---|---|
| HIGH | 1 |
| MEDIUM | 2 |
| LOW | 4 |
| **Total findings** | **7** |

All 7 findings are auto-fixable (documentation-only text changes; no source/behavior changes required).

**Overall verdict: DRIFT FOUND.**

The most significant gap is DRIFT-001: an entire shipped command family (`jr component`) has no README documentation at all, plus DRIFT-002 (undocumented attachment subcommands). CLAUDE.md itself is largely accurate and well-maintained — architecture tree, ADR index, MSRV claim, and TODO/CHANGELOG hygiene all check out clean — with only two small stale/imprecise statements (sprint list dates, version-JSON wording) and two trivial LOC-figure drifts found on spot-check.
