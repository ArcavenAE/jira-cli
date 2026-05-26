---
document_type: adversarial-review
issue: "#327"
pass: 2
date: "2026-05-26"
phase: F5
verdict: CLEAN
findings_count: 0
findings_observations: 2
adversary_tool_profile: read-only (no Bash; analytic findings only — live tool outputs accepted as ground truth per task brief)
---

# Adversarial Review — Issue #327 F5, Pass 2

## Adversary scope honesty disclosure

Read-only profile — no Bash. Accepted the orchestrator's captured tool outputs
(`cargo deny check` exit 0, `cargo build/test/clippy/fmt` exit 0, 25 notes
none matching rand/rand_core) as ground truth. All other claims derived from
static inspection of worktree artifacts at `/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-327/`.

Did NOT load pass 1's findings before drafting. After completing analysis,
read pass 1 only to confirm no duplication of closed items. Observations
below derived from fresh re-reading.

## API correctness

Re-verified against the cited primary sources in `rand-0.10-migration-assessment.md`
§§1-6 and `rand-0.10-perplexity-verification.md` §§1-4:

- `rand::TryRng` — crate-root trait. `use rand::TryRng;` at `src/api/auth.rs:1094`
  is correct. Source: `docs.rs/rand/0.10.1/rand/trait.TryRng.html`.
- `rand::rngs::SysRng` — zero-sized struct constructable by name; implements
  `TryRng<Error = SysError>`. `rand::rngs::SysRng.try_fill_bytes(&mut bytes)`
  at `src/api/auth.rs:1096` is documented usage. Source:
  `docs.rs/rand/0.10.1/rand/rngs/struct.SysRng.html`.
- `try_fill_bytes` signature preserved verbatim from 0.9.
- `SysError: std::error::Error + Send + Sync + 'static` → `anyhow::Context`
  flow byte-identical to the 0.9 `OsError` path.

The rename compiles against rand 0.10.1's actual public API. No correctness
defect from the rename itself.

## Behavioral preservation

`generate_state` at `src/api/auth.rs:1093-1106` is structurally identical to
the 0.9 version. Same OS-CSPRNG backend, same 32-byte allocation, same hex
encoding. Three pinned tests exercise behavior, not type identity. Preserved.

## Convention adherence

- Branch name `chore/rand-0.10-migration` matches `type/short-description`.
- Conventional Commits format on all 3 commits.
- No new `#[allow]` attributes introduced (grep verified).
- No tests modified; all 4 `rand` occurrences in `tests/` are prose, not API
  symbols.

## deny.toml comment block accuracy

Lines 58-69. Empirical claim matches captured cargo-deny output. Explanatory
claim contains a factual gap — see OBS-327-P2-001 below. Not a defect; the
comment ends with a forward-looking trigger.

## Spec-source alignment

Verified across all 5 spec files + 2 architecture files touched by F2 PRD
delta. Zero stale `OsRng` references in `.factory/specs/` and
`.factory/architecture/`. BC H1 ↔ BC-INDEX title sync invariant holds.

## Risk-zone test inspection

Sampled S-1.06 (`tests/oauth_flow_holdouts.rs`) and S-3.04
(`tests/multi_cloudid_disambiguation.rs`). Only `rand` mentions are prose
comments ("random ephemeral port", "random u64"), no symbol references.
Test code is symbol-rename-agnostic.

## rustdoc accuracy

`src/api/auth.rs:1074-1106` read in full. All references to `SysRng` correct.
`rand::rng()` and `ThreadRng` mentions at line 1080 still valid in 0.10
(those names did not rename). Failure-mode prose at lines 1086-1092 correct
for `SysError`. Zero stale `OsRng` references in the file.

## Findings

- 0 CRITICAL
- 0 HIGH
- 0 MEDIUM

## Observations (non-blocking)

### OBS-327-P2-001 [adversarial-curiosity] — deny.toml comment under-attributes rand 0.9 transitive roots

**Severity:** LOW (Observation)
**Confidence:** HIGH

The comment at `deny.toml:58-66` says: "rand 0.9.4 is a Cargo
cross-platform/feature placeholder for proptest's transitive needs that
never enters the actual build." `Cargo.lock` shows TWO transitive roots:
proptest 1.11.0 (dev-dep) AND quinn-proto 0.11.14 (transitive via
reqwest → quinn). The comment omits quinn-proto.

Empirical observation still correct — quinn isn't pulled into the compiled
graph under our active feature set (reqwest with default-features = false,
features = ["json", "rustls"]). But the explanation could mislead a future
maintainer who runs `cargo tree -i rand@0.9.4` and discovers quinn-proto.

Suggested rephrase noted; optional refinement on a future polish pass. NOT
a defect; the existing comment is empirically correct and the diff passes
all gates.

### OBS-327-P2-002 — Pass 1 false-positive correctly resolved

**Severity:** LOW (Observation; affirmative)
**Confidence:** HIGH

Pass 1's HIGH finding F-327-P1-001 (missing deny.toml skip entries) was
reconciled as false-positive after orchestrator-side cargo-deny
re-execution and codified in commit `ae2c9ef` (the deny.toml comment block).
Pass 2 confirms: the comment block exists at lines 58-69 and explains the
empirical state. No regression of pass-1 reasoning.

## Novelty Assessment

LOW. No CRITICAL/HIGH/MEDIUM findings. Two observations are non-blocking
documentation precision items. Pass 1's blocking finding has been correctly
resolved and documented in the diff itself.

## Verdict

**CLEAN.** 1st CLEAN pass toward the 3-consecutive-CLEAN F5 convergence
target.
