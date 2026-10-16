# comfy-table 8.0.0 → 8.0.1 delta research (MAINT-20261015-03)

**Date:** 2026-10-16
**Type:** general, a dependency patch-bump delta
**Verdict:** The bump is a **metadata-only release**. The tags differ by 4 commits. **No file under `src/` changed**, so there is no API, behavior, or rendering change, and nothing in 8.0.1 is reachable from jr. The only consumer-visible change is the new `rust-version = "1.88"` manifest field, which equals jr's own `rust-version = "1.88"` floor, so there is no headroom but also no break.

---

## 0. Premise check (important for the caller)

The main checkout is at `develop` @ `fb9d015c`. It is still pinned to **`comfy-table = "=7.2.2"`** (`Cargo.toml`, with the issue #626 / ADR-0025 comment block), and `Cargo.lock` resolves `comfy-table 7.2.2` (checksum `958c5d6e…`). `src/output.rs` still calls **`load_preset(UTF8_FULL_CONDENSED)`** in both `render_table` and `render_table_with_styles_inner`. It does not call `load_style`.

`load_preset` was **removed in 8.0.0**. See the 8.0.0 changelog and `.factory/maintenance/dependabot-pr-inventory-2026-10-15.md` Task 3, which records the E0599 `no method named load_preset` compile break on Dependabot PR #855.

Consequence: the "`=8.0.0` → `=8.0.1`" step only applies on a branch where the #855 / `load_style` migration has already landed. Applied to `develop` as it stands, the effective jump is 7.2.2 → 8.0.1, a **major** version bump. That jump requires the `load_preset` → `load_style` migration and inherits all of 8.0.0's behavior changes (section 2b). The soak research (`dependabot-soak-research-2026-10-15.md`) puts the 30-day major-soak date for 8.0.1 at **2026-10-25**.

## 1. Changelog items (8.0.1)

Source: https://raw.githubusercontent.com/Nukesor/comfy-table/main/CHANGELOG.md

```
## [8.0.2] - unreleased

## [8.0.1] - 2026-09-25

- Set MSRV to 1.88
```

That is the **only** changelog item. There is no `8.0.2` on crates.io, and the `[8.0.2]` section is empty.

**GitHub release notes:** none exist for v8.0.1. The releases API lists v8.0.0 as the latest GitHub Release, even though the `v8.0.1` tag exists. Source: https://api.github.com/repos/Nukesor/comfy-table/releases

## 2. Tag compare: API / behavior / rendering changes

The tags are `v8.0.0` (`cf91e018`) and `v8.0.1` (`b947cb6b`). Source: https://api.github.com/repos/Nukesor/comfy-table/tags
Compare: https://api.github.com/repos/Nukesor/comfy-table/compare/v8.0.0...v8.0.1 shows ahead_by 4, with 3 files changed.

| Commit | Message |
|---|---|
| f3c6d7e | build(deps): update rstest requirement from 0.26 to 0.27 |
| bbd884f | Merge PR #212 (dependabot rstest-0.27) |
| 283fed2 | chore: Set msrv to 1.88 |
| b947cb6 | chore: Release comfy-table version 8.0.1 |

| File | +/- |
|---|---|
| `.github/workflows/test.yml` | +1/-1 (upstream CI only) |
| `CHANGELOG.md` | +6/-2 |
| `Cargo.toml` | +3/-2: `version` 8.0.0→8.0.1; **added** `rust-version = "1.88"`; dev-dep `rstest` "0.26"→"0.27" |

**No `src/` changes, so there are no API, behavior, or rendering changes.** This rules out any change to `Table::load_style`, `set_header`, `add_row`, `Cell::fg`, `ContentArrangement` and width computation, ANSI styling, TTY detection (`is_tty` / `should_style` / `force_no_tty` / `enforce_styling`), or truncation (including the `…` indicator). Source code that compiles and behaves a given way on 8.0.0 compiles and behaves identically on 8.0.1.

### 2b. For reference: behavior changes 7.2.2 → 8.0.0, which apply only if the base is still 7.2.2

From the 8.0.0 changelog:
- The breaking API removals are `TableComponent`, `modifiers` / `apply_modifier`, `current_style_as_preset`, `set_style`, `style`, `remove_style`, and **`load_preset`**. Presets are now `TableStyle` consts loaded via `Table::load_style`.
- The default truncation indicator changed from `...` to `…`. jr does not set truncation or max-height, so this is likely unreachable unless `Dynamic` arrangement truncates. It only wraps by default.
- The UTF-8 layout fix ("less-than optimal layouting when UTF-8 characters were involved") may change wrap positions in `ContentArrangement::Dynamic` tables containing non-ASCII text. This could affect insta snapshots of tables with non-ASCII content.
- Other changes: performance work, no panic on `Row::max_height(0)`, and multi-width truncation indicators are no longer printed when wider than the column.

## 3. Dependencies / Cargo.lock

These figures come from the crates.io dependencies API for each version:
- https://crates.io/api/v1/crates/comfy-table/8.0.1/dependencies
- https://crates.io/api/v1/crates/comfy-table/8.0.0/dependencies

| Dep | 8.0.0 | 8.0.1 |
|---|---|---|
| unicode-segmentation (normal) | ^1 | ^1 |
| unicode-width (normal) | ^0.2 | ^0.2 |
| crossterm (optional, `tty`, default-features=false; `windows` feature on cfg(windows)) | ^0.29 | ^0.29 |
| ansi-str / console (optional, `custom_styling`) | ^0.9 / ^0.16 | ^0.9 / ^0.16 |
| rstest (**dev**) | ^0.26 | ^0.27 |
| criterion / pretty_assertions / proptest / rand (dev) | unchanged | unchanged |

The features are identical between versions: `default=["tty"]`, `tty=["dep:crossterm"]`, `custom_styling`, `reexport_crossterm`, `_debug`, and `_integration_test`.

**Cargo.lock impact going from 8.0.0 to 8.0.1:** only the `comfy-table` package entry changes, in its `version` and its `checksum` (`136c8c4c…` → `b96a46ad…`). No normal-dependency requirement changed. The only dependency change is the dev-dependency `rstest`, and dev-dependencies of a registry dependency never enter a downstream lockfile. I could not run `cargo update -p comfy-table --precise 8.0.1` because this research agent has no shell. That diff should be confirmed in the implementation step, where it is expected to touch only the comfy-table entry.

## 4. rust-version / edition

| Version | rust_version (crates.io) | edition | published |
|---|---|---|---|
| 7.2.2 | null | 2024 | 2026-01-13 |
| 8.0.0 | **null** (confirmed: the v8.0.1 Cargo.toml diff *adds* the `rust-version` line, so it was absent in 8.0.0) | 2024 | 2026-08-05T01:05:28Z |
| 8.0.1 | **1.88** (`rust-version = "1.88"`) | 2024 | 2026-09-25T15:21:37Z |

Source: https://crates.io/api/v1/crates/comfy-table/versions

jr declares `rust-version = "1.88"`, and its `msrv` CI job pins 1.88.0. 8.0.1's MSRV equals that floor, so it is compatible with zero headroom. The new field makes cargo's MSRV-aware resolver and `cargo check` enforce what 8.0.0 already required implicitly (let-chains need 1.88). This is a net improvement: it ends the "no MSRV enforcement" concern cited in jr's Cargo.toml comment. If jr ever lowers its MSRV below 1.88, cargo will now reject comfy-table 8.0.1 loudly. Under 8.0.0 it would have failed only at compile time.

## 5. Security advisories

- RustSec: https://rustsec.org/packages/comfy-table.html returns **404**, and https://api.github.com/repos/rustsec/advisory-db/contents/crates/comfy-table returns **404** (there is no advisory directory for the crate).
- A Perplexity sweep found no RustSec or GHSA advisory for comfy-table at any version, and none were identified for its direct dependencies. That sweep was inconclusive for crossterm 0.29, unicode-width 0.2, and unicode-segmentation 1, because it could not positively confirm their absence. jr's `cargo deny check` in CI is the authoritative gate for those.
- Conclusion: **no known advisory against 8.0.0 or 8.0.1** as of 2026-10-16.

## 6. Reachability from jr

jr's usage is confirmed by grepping `src/output.rs` and `src/cli/user.rs`:
- `Table::new`, `load_preset(UTF8_FULL_CONDENSED)` ×2 on develop (`load_style` after the #855 migration), `set_content_arrangement(ContentArrangement::Dynamic)` ×2, `set_header` ×2, and `add_row`.
- `Cell::new(..).fg(Color)` is used in `render_table_with_styles_inner`, and also directly in the `src/cli/user.rs` comfy-table behavior pin test.
- `force_no_tty().enforce_styling()` is used, but only as a test seam.
- `Table::to_string()` is used for rendering.

Since 8.0.1 has zero `src/` diff, **nothing in 8.0.1 is reachable from jr**. The insta snapshots and the comfy-table behavior pin test should pass byte-identically relative to an 8.0.0 build.

## Research Methods

| Tool | Queries | Purpose |
|---|---|---|
| Perplexity perplexity_research (PRIMARY) | 0 | Not used. This was a narrow delta question answered authoritatively by primary sources (registry API, git tag compare), so deep synthesis added nothing. |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 1 | RustSec/GHSA advisory sweep for comfy-table and its deps |
| Context7 | 0 | — |
| Tavily | 0 | — |
| WebFetch | 9 | crates.io versions and dependencies (8.0.0, 8.0.1); GitHub tags, releases, and compare v8.0.0...v8.0.1; upstream CHANGELOG.md; rustsec.org package page; rustsec advisory-db crate dir |
| WebSearch | 0 | — |
| Local Grep/Read | 6 | jr's Cargo.toml, Cargo.lock, src/output.rs, src/cli/user.rs, prior maintenance reports |
| Training data | 0 areas | All claims come from fetched primary sources |

**Total MCP tool calls:** 1
**Training data reliance:** low. Every fact is sourced from the crates.io API, the GitHub API, or the upstream CHANGELOG.
