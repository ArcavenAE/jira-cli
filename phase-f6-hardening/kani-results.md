---
phase: f6-targeted-hardening
dimension: formal-proofs-kani
bundle: S-FORK-OPS-BACKFILL
head_sha: 83a141ad
pre_bundle_base: 45ddf7a
verdict: N/A (justified skip)
date: 2026-06-19
---

# F6 — Formal Proofs (Kani)

## Verdict: N/A — no applicable proof target (justified skip)

## Independent delta confirmation

`git diff 45ddf7a..HEAD --name-only` yields exactly 4 files:

| File | Class |
|---|---|
| `.github/workflows/backfill-release.yml` | CI workflow YAML (not compiled Rust) |
| `tests/backfill_matrix_parity.rs` | Rust integration **test** (no production code) |
| `docs/specs/fork-friendly-release-ops.md` | documentation |
| `CLAUDE.md` | documentation |

`git diff 45ddf7a..HEAD --stat -- src/` is **empty** — zero changes under `src/`. Confirmed independently of any prior review conclusion.

## Justification for skip

Kani proves properties over **production Rust logic** (arithmetic over/underflow, OOB access, state-machine invariants, custom assertions). The delta introduces:

1. No new production Rust functions, types, or branches (no `src/` change).
2. No new verification properties (F2 verification-delta established none; consistent with the absence of new production logic).

A Kani harness requires a `#[kani::proof]` entry point exercising production code under symbolic inputs. There is no such code in this delta. The only Rust added is a test file (`tests/backfill_matrix_parity.rs`), which is itself verification machinery, not a proof subject.

**No Kani harness is applicable. Skip is justified.**
