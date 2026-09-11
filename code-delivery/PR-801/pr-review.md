## Fresh-Eyes PR Review — #801

**Verdict: APPROVE** — no blocking findings. Two non-blocking suggestions below.

### Scope verified

`git diff --name-only origin/develop...origin/docs/maintenance-sync-2026-09-10` returns exactly
two files: `CLAUDE.md` (+14/−3) and `README.md` (+1/−0). No `src/`, no `Cargo.toml`/`Cargo.lock`,
no CI workflow, no test files. The "no product-code changes" claim in the description is accurate.
Diff size is 17 changed lines — well inside the size guideline.

### Claim-by-claim verification

| Claim | Result |
|---|---|
| 5 new tree entries reference real files | **Verified.** `src/cli/field.rs`, `src/cli/issue/mentions.rs`, `src/profile.rs`, `src/api/jira/tenant.rs`, `src/api/auth_windows_store.rs` all resolve on the branch; `profile` is a real `pub mod` in `src/lib.rs`. |
| ADR-0011 status correction | **Verified.** `docs/adr/0011-type-level-profile-fence.md` reads **Accepted** (amended 2026-09-01, DEC-317, originally Deferred) — the new bullet matches the source document. |
| "newtype + call-site sweep have landed (PR #758)" | **Verified.** PR #758 is MERGED, titled `refactor(config): Profile newtype type-fence (ADR-0011 accepted) — S-cycle3-adr0011-newtype`. All 26 per-profile functions in `src/cache.rs` now take `profile: &Profile`. |
| README `jr field options` row | **Verified** flag-for-flag against `FieldCommand::Options` in `src/cli/mod.rs` (~line 1219–1254): exactly-one-of `--type` / `--request-type` / `--issue`; `--project` companion role required-or-defaulted / optional / ignored per mode; `--value` case-insensitive substring filter. |
| docs/adr vs .factory ADR track note | **Verified.** `docs/adr/` contains 0001–0016 only; `.factory/specs/architecture/decisions/` contains ADR-0017 through ADR-0023, including 0019 / 0021 / 0022 / 0023 cited in the new tree lines. |

### Citation discipline

No dead paths introduced. Every backtick-quoted path in the added lines is either a real file or a
`.factory/`-prefixed path (auto-excluded by `extract_path_citations`). Consistent with the
reported 61/61 `claude_md_citations` guard pass. New citations use symbol/§ form, not line
numbers — compliant with the citation-form convention.

### Findings

| Field | Value |
|---|---|
| Severity | suggestion (trivial-fixable) |
| Category | coherence |
| File | `CLAUDE.md` (Gotchas — "Multi-profile boundary", ~line 240) |
| Finding | The Gotchas entry still reads "every cache reader/writer takes `profile: &str` as its first arg. Pass `&config.active_profile_name`…". The sweep this PR documents as landed changed all 26 `src/cache.rs` signatures to `profile: &Profile`. The file is now internally contradictory: the newly added `profile.rs` tree line asserts the type-level fence landed, while this entry describes the pre-fence `&str` contract. A reader following the Gotcha would write code that no longer compiles. |
| Suggestion | Update the entry to `profile: &Profile` and note the newtype (`src/profile.rs`, ADR-0011/DEC-317) as the fence. Natural fit for this same drift sweep. |

| Field | Value |
|---|---|
| Severity | nit |
| Category | coherence |
| File | `CLAUDE.md` (Known Size Deviations) |
| Finding | `src/cli/field.rs` is 1,901 LOC — roughly 90% over ADR-0012's 1,000-LOC `src/cli/` shard threshold — but is newly added to the architecture tree without a corresponding Known Size Deviations entry, unlike every other over-threshold `src/cli/` file (`component.rs`, `attachments.rs`, `edit.rs`, `field_resolve.rs`, …). (`src/api/auth_windows_store.rs` at 1,996 LOC is `src/api/`, outside that rule's scope — no entry needed.) |
| Suggestion | Add a one-line DOCUMENT-AS-IS entry for `cli/field.rs` (~1,901 LOC, single command family, three enumeration modes) alongside the existing deviations. |

### Pre-existing, not introduced by this diff

`cli/component.rs`'s tree comment says `~1066 LOC` while Known Size Deviations says `~1,800`
(actual: 1,796). Out of this diff's scope — noted only so it is not mistaken for new drift.

### What was verified rather than rubber-stamped

Both changed files read in full diff form; all five claimed `src/` paths resolved against the
branch tree via `git cat-file`; ADR-0011's own status header read directly; PR #758 state and
title confirmed via `gh`; the README flag table validated against the clap derive definition
rather than against the PR description; both ADR directories enumerated to confirm the
0001–0016 / 0017+ split the new note describes.
