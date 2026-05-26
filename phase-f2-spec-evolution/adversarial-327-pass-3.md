---
document_type: adversarial-review
issue: "#327"
pass: 3
date: "2026-05-26"
phase: F5
verdict: CLEAN
findings_count: 0
findings_observations: 1
adversary_tool_profile: read-only (no Bash, no Write; captured tool outputs accepted as ground truth)
---

# Adversarial Review — Issue #327 F5, Pass 3

## Adversary scope honesty disclosure

Read-only profile. Accepted orchestrator's captured tool outputs as ground
truth. Read pass 1 and pass 2 only AFTER completing fresh analysis to
confirm no duplication/contradiction.

## API correctness (independently re-derived)

- `rand::TryRng` crate-root trait — correct import.
- `rand::rngs::SysRng` zero-sized struct, `TryRng<Error = SysError>` impl.
- `try_fill_bytes` signature preserved verbatim; `SysError: std::error::Error
  + Send + Sync + 'static` satisfies `anyhow::Context::context` bounds.
- No symbol or signature defect from the rename.

## Determinism test correctness (specifically re-audited)

`src/api/auth.rs:1212-1223` — `test_generate_state_is_not_deterministic` uses
`HashSet<String>` over 8 samples and asserts `samples.len() == 8`. Correctly
tests mutual distinctness, NOT against a hardcoded sentinel. Birthday-bound
collision probability ≈ 2⁻²⁵³; not a flake source.

## Hex encoding correctness (specifically re-audited)

32 bytes × 2 hex chars = 64. `{b:02x}` is lowercase, zero-padded, width 2.
`fmt::Write` for `String` is infallible. The discarded `Result` from
`write!(...)` is sound. Pinned by `test_generate_state_is_64_hex_chars`.

## Exhaustive residual-reference check

- `grep -rn 'OsRng\|TryRngCore'` across worktree (excl. `.factory/semport/`)
  → zero hits. AC-7 satisfied.
- `deny.toml` mentions `0.9.4`/`0.10.1` ONLY inside the explanatory comment
  block (lines 58-69), correctly attributing dual-presence to active feature
  graph excluding rand 0.9.

## CI gate coverage

`.github/workflows/ci.yml` deny job runs `EmbarkStudios/cargo-deny-action@v2`
which defaults to `cargo-deny check` (all categories). Captured live output
confirms exit 0 with no rand/rand_core notes among the 25 emitted.

## Lockfile + STORY-INDEX state

- `Cargo.lock` committed in `6b7e0ff`. Both `rand 0.9.4` and `rand 0.10.1`
  + paired `rand_core` entries — matches research expectations.
- STORY-INDEX.md S-327 row consistent with story spec, total 47→48.

## Bisect-window concern (specifically re-audited)

The window between `6b7e0ff` (Cargo.toml only) and `d115867` (auth.rs
renames) would fail to compile. CLAUDE.md §Conventions mandates Conventional
Commits format but does NOT mandate each commit be independently buildable.
Pass-1's F-327-P1-003 surfaced this as acceptable per project convention;
orchestrator may squash at F7. Not a novel pass-3 finding.

## Findings

- 0 CRITICAL
- 0 HIGH
- 0 MEDIUM

## Observations (non-blocking)

### OBS-327-P3-001 [process-gap] — Pass-1's two HIGH process-gap items (F-327-P1-002, F-327-P1-005) remain uncodified

**Severity:** LOW (Observation — process-gap, not artifact defect)
**Confidence:** HIGH
**Tag:** [process-gap]

Pass-1 raised two HIGH process-gap findings about F5 adversary tooling
(read-only profile cannot run cargo build/test/deny; input bundle should
embed cargo-deny verbose output). Both tagged for cycle-close codification.
Pass 2 did not surface them. Pass 3 notes them as structural observation:
this F5 sub-cycle (3 passes for a 3-line code change) is a clean test bed
for the captured-output-injection pattern — and it works. Forward-looking
codification is whether to embed cargo-deny verbose output in every F5
dispatch packet by default. Not blocking #327; suggested for cycle-close.

## Novelty assessment

**LOW (effectively zero novel artifact-level findings).** The diff carries
3 lines of code change, 13 lines of deny.toml comment, auto-resolved
Cargo.lock. No surface area for novel defects beyond what pass 1 (one
false-positive) and pass 2 (two LOW observations) already exhausted. The
single observation here is process-level (F5 tooling), explicitly distinct
from any artifact-level concern.

## Verdict

**CLEAN.** 2nd consecutive CLEAN pass toward the 3-consecutive-CLEAN F5
convergence target.
