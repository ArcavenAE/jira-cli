## PR Re-review: #920 at head b16c4b9b (delta from 426f099d)

**Verdict: COMMENT. No blocking findings.** This is posted as a COMMENT review only. It is not an approval and not a code-owner sign-off. The merge decision stays with the human code owner.

### Prior findings

| # | Prior finding | Status | Evidence |
|---|---|---|---|
| 1 | The CHANGELOG claimed the truncation indicator changes from `...` to `…`, but that path can't be reached in jr | **Resolved** | The `### Changed` entry is removed from `[Unreleased]`. I checked the comfy-table 8.0.0 source: `truncation_indicator` is read only in `utils/formatting/content_format.rs`, inside the `if let Some(lines) = row.max_height` branch. Nothing under `src/` calls `max_height`, so the glyph change can't be seen in jr's output. Leaving it out of the CHANGELOG is correct for an internal bump with no visible change. |
| 2 | The `Cargo.toml` pin comment still described 7.2.2 | **Resolved** | The comment now describes 8.0.0. See the fact check below. |

### Fact check of the `Cargo.toml` comment

| Claim | Verified against | Result |
|---|---|---|
| comfy-table 8.0.0 declares edition 2024 | Registry manifest `comfy-table-8.0.0/Cargo.toml`: `edition = "2024"` | Correct |
| It has no `rust-version` manifest field | The same manifest has no `rust-version` key | Correct |
| It uses let-chains, which need Rust >=1.88 | `content_format.rs:103` uses an `if let ... &&` chain. Let-chains became stable in 1.88 on edition 2024 | Correct |
| jr's own rust-version is 1.88, which covers it | `Cargo.toml:7`: `rust-version = "1.88"` | Correct |
| The exact pin `=8.0.0` is kept as a review gate, matching saphyr-parser | The `comfy-table = "=8.0.0"` line is unchanged | Consistent |

### PR description

The body now matches the diff:
- The CHANGELOG entry is gone.
- It says no visible change is expected and gives the `max_height` reason.
- It mentions the pin-comment refresh.

The total diff against `develop` is 3 files and +12/-13 lines (`Cargo.toml`, `Cargo.lock`, `src/output.rs`), all on this one topic.

### Remaining non-blocking notes (carried over, unchanged)
- [SUGGESTION] CI is expected to stay red on `cargo deny check advisories` (rustls RUSTSEC-2026-0346..0349) until #919 merges. Re-run the gate on this PR after #919 lands and before merging. Branch protection uses `strict: false`, so an old green result here would not cover `develop` after #919.
- [NIT] Windows full-crate compilation was not checked locally. The CI Windows jobs are the first real check, so confirm they pass.

covered_sha: b16c4b9b220e90b986b4865e471b0408bb3e288d
