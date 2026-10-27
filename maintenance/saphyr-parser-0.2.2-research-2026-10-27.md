# saphyr-parser `=0.0.12` -> `=0.2.2` (Dependabot PR #941): deep review, 2026-10-27

**Type:** general (dependency review), read-only
**As of:** 2026-10-27 (UTC)
**Scope:** `[dev-dependencies]` only. The crate is used only by `tests/common/wf.rs` and consumed by `tests/ci_gate_completeness.rs` (plus `tests/backfill_matrix_parity.rs` and `tests/ci_yml_windows_matrix.rs`). `tests/common/wf.rs` is one of the six files in the CI-gate review scope.
**Policy:** `.factory/maintenance/dependabot-soak-research-2026-10-15.md`. A pre-1.0 minor bump counts as major, so the soak is **30 days** from the target version's publish date.
**Input handling:** The PR body and the upstream changelogs were treated as untrusted data. Nothing in them was followed as an instruction.

## 0. Verdict

**WAIT-SOAK until 2026-11-14.** No code changes are needed. Merge with the doc fallout in §5, after the base-state `Deny` failure is cleared.

| Question | Answer |
|---|---|
| 0.2.2 publish date | 2026-10-15T07:32:49Z |
| Elapsed / required | 12 / 30 days. **Soak: FAIL.** First eligible date is **2026-11-14**. |
| Yanked | No (none of 0.0.x, 0.1.x, 0.2.x or 0.3.x is yanked) |
| Advisories | None. The GHSA API returns `[]` for rust/saphyr-parser, and rustsec.org has no package page (404). There is no security exemption. |
| MSRV | 1.85.0 (unchanged since 0.0.9), below the repo floor of 1.88. The `MSRV (1.88.0)` CI job passed on the PR. |
| New transitive deps | **None.** The Cargo.lock diff is 4 lines (the saphyr-parser version and checksum only). Dependencies stay `arraydeque` and `thiserror 2.x`, already in the lock. There is no `deny.toml` license or ban impact. |
| Exact `=` pin kept | **Yes:** `saphyr-parser = "=0.2.2"`. |
| Comment / CLAUDE.md updated | **No** (see §5) |
| Code compiles and tests pass | **Yes.** Test (ubuntu, macos, windows), Clippy (both OSes), MSRV, Coverage and all 8 mutation shards plus the aggregate are green. |
| PR red checks | `Deny` and `CI Gate`. **This failure is not caused by this PR.** The same two jobs fail at the same step on Actions-only Dependabot PRs from the same batch (e.g. harden-runner 2.22.2, run 40478675697), and every CI run from the 2026-10-27 batch failed. The logs need sign-in, so I could not confirm the exact advisory ID. It fits the base-state Deny pattern recorded in `dependabot-pr-inventory-2026-10-15.md` (RUSTSEC-2026-0346..0349 on rustls). |

## 1. Release timeline (crates.io API, verified)

| Version | Published (UTC) | Changelog content (parser/CHANGELOG.md) |
|---|---|---|
| 0.0.12 (current) | 2026-08-18 | thiserror bumped to 2.0.20 |
| 0.1.0 | 2026-09-19 | **BREAKING (behavior):** empty nodes now emit `""` instead of `"~"` (+129) |
| 0.1.1 | 2026-10-12 | version bump, no functional change |
| 0.1.2 | 2026-10-12 | version bump, no functional change |
| 0.2.0 | 2026-10-12 | version bump, no functional change |
| 0.2.1 | 2026-10-12 | version bump, no functional change |
| **0.2.2 (target)** | **2026-10-15** | Raw NUL characters in the stream are now rejected (+135), via the scanner's `fetch_next_token` "found unprintable character" error |
| 0.3.0 | 2026-10-25 | An empty block scalar at EOF now yields `""` instead of `"\n"` (#143) |
| 0.3.1 | 2026-10-26 | Recursive-alias ("billion laughs") guard (#109/+120); compat pairs in flow mappings fixed (#139) |
| 0.3.2 | 2026-10-26 | version bump |
| 0.3.3 | 2026-10-27 | version bump. A newer series exists; Dependabot will likely supersede #941. Earliest soak date for 0.3.3 is 2026-11-26. |

0.1.x and 0.2.x are mostly workspace-version bumps aligning with the `saphyr` monorepo. Across the whole 0.0.12 -> 0.2.2 range there are **two real behavior changes and no public API change**.

## 2. Breaking-change audit vs. symbols used in `tests/common/wf.rs`

Symbols wf.rs actually uses:
- `Parser::new_from_str`, with the iterator item `Result<(Event, Span), ScanError>`
- `Event::{DocumentStart(..), MappingStart(anchor_id, tag), SequenceStart(anchor_id, tag), MappingEnd, SequenceEnd, Scalar(text, style, anchor_id, tag), Alias(_)}`
- `ScalarStyle` (re-exported; `ScalarStyle::Plain` is pinned in `ci_gate_completeness.rs`)
- `Tag { handle, suffix }`
- `Span { start, end }` and `Span::new`
- `Marker::{new(index, line, col), index(), line(), col()}`
- `ScanError` (Display only)

| Item | 0.0.12 | 0.2.2 | Touches wf.rs? |
|---|---|---|---|
| `Event` enum | 11 variants: Nothing, StreamStart, StreamEnd, DocumentStart(bool), DocumentEnd, Alias(usize), Scalar(Cow<str>, ScalarStyle, usize, Option<Cow<Tag>>), SequenceStart(usize, Option<Cow<Tag>>), SequenceEnd, MappingStart(usize, Option<Cow<Tag>>), MappingEnd | **Identical** (docs.rs, both versions) | No change |
| `ScalarStyle` | unchanged | unchanged | No change |
| `Tag` | `{ handle: String, suffix: String }` | same | No change |
| `Marker` API | `new(index, line, col)`, `index()`, `line()`, `col()`; rustdoc says index is "in bytes" | **Same signatures and same rustdoc** | No change |
| `Marker::index()` semantics | Character index (wf.rs module docs; verified at 0.0.11) | **Still a character index.** In the 0.2.2 `scanner.rs`, `skip_blank`/`skip_non_blank`/`skip_nl` do `index += 1` per char, and the block-scalar raw path does `index += line_buffer.chars().count()`. The field doc saying "in bytes" is still wrong. | **`char_byte_table` remains correct and required.** This was the main silent-breakage risk: a switch to real byte offsets would have mis-sliced `Job::span`/`Step::span` on the non-ASCII `ci.yml`. It did not happen. |
| `Marker::col()` base | 0-indexed in practice (doc says 1-indexed) | Still 0-indexed: `skip_nl` sets `col = 0`, while the field doc still says "1-indexed" | `line_start_char_idx` (`index - col`) is still correct |
| `Marker::line()` | 1-indexed | 1-indexed | `start_line`/`end_line` are unaffected |
| `Span` | `{ pub start, pub end }`, `new`, `empty`, `len`, `is_empty` | same | No change |
| `ScanError` | struct with `new`, `new_str`, `marker`, `info`; Display shows "... at byte X line Y column Z" | same public API (Error/Display now derived via thiserror) | wf.rs only formats it with `{e}` inside a panic message. No impact. |
| 0.1.0: empty node `"~"` -> `""` | `key:` (no value) gave `Scalar("~", Plain, ..)` | `Scalar("", Plain, ..)` | Only affects `Value::Scalar.text` for empty values. None of the ci-gate pins expects `"~"` (grep finds no `"~"` in wf.rs, yaml.rs or the ci_gate test files). Every pin compares against a non-empty literal, so either spelling fails closed. Tests are green. |
| 0.2.2: NUL rejected | NUL was accepted as stream end (`is_z`) | Returns `ScanError` "found unprintable character" | `WfDoc::parse` / `find_key_node_properties` now panic loudly on a NUL in a workflow file. This is **stricter, i.e. fail-closed: a hardening of the trust boundary, not a loosening.** No test feeds a NUL. |

### YAML 1.2 line-break handling (the independent non-LF byte scan)

`char_traits.rs` is **identical** at 0.0.12 and 0.2.2:
- `is_break(c) = c == '\n' || c == '\r'`
- `is_breakz` adds `'\0'`
- No function references U+0085, U+2028 or U+2029.

NEL, LS and PS are therefore still **not** line breaks to the parser, as YAML 1.2 requires. The repo's round-14 non-LF byte scan (the third layer documented in CLAUDE.md's CI Gate section) **is still not subsumed and must stay.** The CLAUDE.md rationale remains accurate.

**Conclusion:** none of the API or semantic changes in 0.0.12 -> 0.2.2 touches a wf.rs symbol in a way that needs a code change. The wf.rs module-doc claims about the crate's quirks (char index, 0-indexed col, no duplicate-key rejection, aliases unresolved, block scalars dedented) all still hold. The first two were re-verified in the 0.2.2 source; the last three were not re-tested beyond the green CI suite, which pins them.

## 3. The PR as-is

- **Diff:** 2 files.
  - `Cargo.toml`: `"=0.0.12"` -> `"=0.2.2"`. The exact pin is preserved. The comment block above it is unchanged context.
  - `Cargo.lock`: the version and checksum of the saphyr-parser entry only.
- **Checks** (head `67580319e93000b09afb1c8f242a8d1ec1ba8380`, CI run 40478567886):
  - **Green:** Format, Clippy (ubuntu, windows), Test (ubuntu, macos, windows), MSRV (1.88.0), Coverage, Spec Guards, Secret Scan, Mutation Test Plan, Mutation Shards 0-7, Mutation Aggregate, Signing Workflow Injection Guard, dependency-review.
  - **Red:** `Deny (licenses + vulnerabilities)`, which failed in the `cargo-deny-action` step, and `CI Gate`, which fails closed because `Deny` failed.
  - **Attribution:** not this PR. The identical failure shows on Actions-only PRs from the same batch, and the lockfile change adds no crates. The Deny log needs sign-in, so the exact advisory is **UNVERIFIED**. Run `gh run view 40478567886 --log-failed` to confirm.
- **Tooling note:** the GitHub MCP server failed to connect and this agent has no shell. The PR diff and checks were read through the public GitHub REST API and `patch-diff.githubusercontent.com` with WebFetch, which is equivalent to `gh pr diff 941` / `gh pr checks 941`.

## 4. Risk assessment (CI-gate trust boundary)

- **Low.**
  - The parser is dev-only and never ships in the `jr` binary.
  - The public API is byte-identical for every symbol used.
  - The two behavior changes both make the parser stricter or more spec-correct, so they can only add failures, never hide them.
  - The highest-consequence invariant, char-vs-byte `Marker::index`, is unchanged.
- **Residual risk:** a pre-1.0 crate with fast-moving releases (four 0.3.x versions in three days). That is exactly what the exact pin plus the 30-day soak are for.
- **Process requirement:** `tests/common/wf.rs` is in the six-file CI-gate scope. Merging any parser version change should come with a human review of the doc fallout in §5. The six files themselves need no code change.
- **Watch for the next bump (0.3.x):**
  - 0.3.0 changes the empty-block-scalar-at-EOF value (`"\n"` -> `""`). That is relevant to wf.rs's "trailing block scalar" handling for `sync-upstream.yml`, although wf.rs slices spans rather than reading the text.
  - 0.3.1 adds an alias-expansion guard and a flow-mapping fix.
  - Both need their own review when Dependabot retargets.

## 5. Doc fallout needed (not in the PR)

1. **`Cargo.toml` comment above `saphyr-parser`:**
   - "0.0.x carries no semver guarantee by convention, so a 0.0.x bump can be breaking" -> generalize to "pre-1.0 (0.x) — minor bumps may be breaking". The rationale for the exact pin still holds.
   - The MSRV text ("this crate's own MSRV sits at 1.85.0") is still accurate.
2. **`CLAUDE.md` CI Gate bullet ("Durable fix — LANDED"):** `saphyr-parser = "=0.0.12"` as of `ba522b2d` (#841, 2026-09-19) -> `"=0.2.2"` as of `<merge sha>` (#941, <date>). Keep the historical `=0.0.11` landing note. "the crate's own MSRV (1.85.0)" stays accurate.
3. **`tests/common/wf.rs` module doc**, "verified against a real `saphyr-parser` 0.0.11 build": add "re-verified against 0.2.2 source (Marker index still char-based, col still 0-based)", or bump the version reference. This is a comment-only edit, but it is in a six-file CI-gate scope file, so it needs review.
4. **`tests/ci_gate_completeness.rs`**, doc comments near the "`saphyr-parser` 0.0.11's event stream" references (~L7070, ~L7174): optional version refresh.
5. **No change:** `docs/specs/ci-gate-completeness.md` (historical S-CIGATE-3 landing record at `=0.0.11`) and `CHANGELOG.md:623` (historical).
6. **Optional:** add a CHANGELOG `[Unreleased]` chore line.

## Sources

- crates.io versions API: https://crates.io/api/v1/crates/saphyr-parser/versions
- Changelog: https://raw.githubusercontent.com/saphyr-rs/saphyr/master/parser/CHANGELOG.md
- docs.rs Event (0.2.2 / 0.0.12): https://docs.rs/saphyr-parser/0.2.2/saphyr_parser/enum.Event.html , https://docs.rs/saphyr-parser/0.0.12/saphyr_parser/enum.Event.html
- docs.rs Marker (0.2.2 / 0.0.12): https://docs.rs/saphyr-parser/0.2.2/saphyr_parser/struct.Marker.html , https://docs.rs/saphyr-parser/0.0.12/saphyr_parser/struct.Marker.html
- 0.2.2 scanner source: https://docs.rs/crate/saphyr-parser/0.2.2/source/src/scanner.rs
- char_traits source (0.2.2 / 0.0.12): https://docs.rs/crate/saphyr-parser/0.2.2/source/src/char_traits.rs , https://docs.rs/crate/saphyr-parser/0.0.12/source/src/char_traits.rs
- GHSA API: https://api.github.com/advisories?ecosystem=rust&affects=saphyr-parser (`[]`). RustSec: https://rustsec.org/packages/saphyr-parser.html (404, no advisories)
- PR: https://github.com/Zious11/jira-cli/pull/941 , diff via https://patch-diff.githubusercontent.com/raw/Zious11/jira-cli/pull/941.diff
- Checks: https://api.github.com/repos/Zious11/jira-cli/commits/67580319e93000b09afb1c8f242a8d1ec1ba8380/check-runs ; jobs https://api.github.com/repos/Zious11/jira-cli/actions/runs/40478567886/jobs and (control) .../runs/40478675697/jobs ; CI run list https://api.github.com/repos/Zious11/jira-cli/actions/workflows/ci.yml/runs
- Local: `tests/common/wf.rs`, `Cargo.toml`, `Cargo.lock`, `CLAUDE.md`, `docs/specs/ci-gate-completeness.md`

## Research Methods

| Tool | Queries | Purpose |
|---|---|---|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Changelog 0.0.6–0.2.2, Event/Marker/Span/Tag API audit, MSRV, dependencies, line-break handling |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | Not needed; docs.rs source was read directly |
| Tavily | 0 | Not available in this session |
| WebFetch | 18 | crates.io registry; upstream CHANGELOG; docs.rs Event/Marker (both versions); scanner.rs and char_traits.rs source (both versions); PR files and diff; check-runs, annotations and jobs APIs; CI run list; GHSA API; RustSec |
| WebSearch | 0 | — |
| Training data | 0 areas | Every version, date and API claim was verified against the registry, docs.rs or source |

**Total MCP tool calls:** 1. The GitHub MCP server failed to connect, so its job was done with WebFetch against public APIs.
**Training data reliance:** low. Perplexity's two uncertain points (whether the index is byte- or char-based, and whether NEL/LS/PS count as line breaks) were settled from primary source.
