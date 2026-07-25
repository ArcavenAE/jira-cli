# PR #652 — Fresh-Eyes Review

**Branch:** `fix/f5-r11-dead-single-branch` → `develop`
**Scope:** Behavior-preserving refactor — remove unreachable single-mode branch from
`compute_default_output_path` (`src/cli/issue/attachments.rs`) + SEC-576-001 consolidation
guard note. FIX-F5-013 / F5-R11-001.
**Commit reviewed:** 22f9da50 (+11 / −15)

## Verdict: PASS — no blocking findings

Per DEC-173, this agent does not post an `--approve` verdict. Review is posted as a
`gh pr review --comment` (review event, not a `gh pr comment`) and the PASS assessment is
returned to the orchestrating agent for the human merge decision.

## Checklist evaluation

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence | PASS — all changes relate to removing the dead `is_batch=false` branch + rustdoc guard. No unrelated edits. |
| 2 | Description accuracy | PASS — PR body matches the actual +11/−15 diff. |
| 3 | Test coverage | PASS — 39/39 `attachment_download` integration tests + 94 lib attachment unit tests (incl. VP-576-001 proptest) pass. Pure dead-code removal needs no new test. |
| 4 | Demo evidence | N/A — internal refactor, no user-facing behavior change. |
| 5 | Commit quality | PASS — Conventional Commits `refactor(issue):`, carries FIX-F5-013 / F5-R11-001 IDs, clear body. |
| 6 | Diff size | PASS — 26 lines changed. |
| 7 | Missing changes | PASS — no spec-mandated change omitted. |
| 8 | Dependency status | N/A. |

## Findings

### 1. Behavior-preserving (correctness) — CONFIRMED
`git grep compute_default_output_path 22f9da50^` shows the only pre-change caller was
`handle_batch_download`, which always passed `is_batch=true`. No caller — production or
test — passed `false`. The removed `else { base_dir.join(sanitized) }` branch was
genuinely unreachable. The retained batch path (`<base_dir>/<sha1>_<sanitized>`) is
byte-for-byte identical to the old `is_batch=true` branch. `test_bc_2_7_stream_to_file_
failure_increments_fail_count` still recomputes and matches that shape.

### 2. Guard note accuracy (documentation) — CONFIRMED
The new `# Single-mode path is NOT owned here` rustdoc (lines 527–531) names the correct
owner: `handle_single_download` builds its path inline (lines 828–857), where the
SEC-576-001 Windows device-name escape lives (`is_windows_device_name_basename` →
`format!("_{sanitized}")`). The note correctly cites SEC-576-001 / F5-R11-001 and warns
against consolidation without moving the escape. Closes the latent regression vector the
old "both modes managed here" rustdoc invited.

### 3. No stale references (coherence) — CONFIRMED
`grep` across `src/` + `tests/` shows one live call site (line 1027); all other mentions
are comments. The `is_batch=true` comment in `tests/attachment_download.rs:2600` is updated
to "(batch-only)". No orphaned `is_batch` token remains.

### 4. Quality gates — CONFIRMED
`cargo clippy --all-targets -- -D warnings` clean (removed param leaves no
unused-variable/dead-code warning). `cargo build` clean.

## Optional observation (NIT — no action recommended)
Function name `compute_default_output_path` no longer signals the now batch-only contract;
`compute_batch_output_path` would be marginally clearer. NOT recommended for this PR — the
rustdoc first line already states "batch ... only", and a rename would widen an otherwise
minimal behavior-preserving diff for no correctness gain.
