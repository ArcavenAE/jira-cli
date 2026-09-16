# F5 Scoped Adversarial — Pass 3

- **Cycle:** cycle-013 (`msrv-1.88-bump`)
- **Phase:** F5 scoped adversarial review
- **Scope:** `git diff 7160a534..b960c305` (46 files, +1073/−1050), reviewed against the
  actual computed patch.
- **Reviewer:** adversary (fresh context, no prior review output visible, different model
  family from Passes 1 and 2)
- **Date:** 2026-09-16
- **Verdict:** **CLEAN** — 0 CRITICAL / 0 HIGH / 0 MEDIUM (3rd consecutive CLEAN pass —
  convergence threshold met)

## Basis

1. **MSRV-floor integrity, emphasized this pass.** All pins re-verified mutually
   consistent and load-bearing: `Cargo.toml` `rust-version = "1.88"`; `ci.yml` msrv job
   `toolchain: "1.88.0"` + `RUSTUP_TOOLCHAIN: "1.88.0"` (both required per the
   `rust-toolchain.toml` precedence gotcha — `rust-toolchain.toml` pins `channel =
   "stable"`, which outranks `rustup default` but is itself outranked by the
   `RUSTUP_TOOLCHAIN` env var); edition 2024 unaffected; no API used anywhere in the diff
   requires >1.88. `saphyr-parser =0.0.11` (dev-dependency) has MSRV 1.85.0, sitting below
   the 1.88 floor with headroom.
2. **CI-gate enforcement not weakened.** Re-checked `tests/common/wf.rs`'s
   `ScalarStyle::Plain` pins, the job/step key-set assertions (set-equality,
   default-deny), and the non-LF byte scan + node-property scan — none of these guards
   were touched or loosened by the msrv-job scope widen from lib+bins to `--all-targets`.
3. **Non-let-chain changes verified independently.** `src/cli/issue/create.rs`'s proptest
   let-binding lifetime fix (E0716 workaround, bind-to-let) is confirmed
   behavior-preserving — no semantic change, purely a temporary-lifetime satisfaction.
   `tests/team_column_parity.rs`'s S-626-1 doc-comment refresh (PR #819) is
   documentation-only; no test-logic change.
4. **Cross-PR interaction re-checked.** PR #818 (bump + retrofit), PR #819 (Wave-2 S3
   docs), and PR #822 (Wave-2-gate F-2 fix) were reviewed together as the full cycle-013
   delta, not independently — no interaction defect found (e.g., no case where PR #822's
   doc correction contradicts something PR #818 or #819 actually shipped).

## Findings

- **1 LOW:** `comfy-table =7.2.2` sits at exactly the 1.88 floor with zero MSRV headroom.
  This is fail-safe (a future comfy-table bump requiring ≥1.89 would fail the now-widened
  `--all-targets` `msrv` job loudly, not silently), and is human-gated by the repo's
  existing exact-pin-with-review convention (same pattern as `saphyr-parser`). Recorded as
  a new standing item (`CYCLE-013-COMFY-TABLE-ZERO-HEADROOM-MSRV`) rather than a fix —
  watch on the next comfy-table bump, not an action item now.
- **1 NIT:** (verified accurate, no correction needed) — a minor prose-redundancy
  observation in one of the reconciled doc passages that does not affect correctness.

## Conclusion

3 consecutive CLEAN passes (Pass 1, Pass 2, Pass 3) — zero CRIT/HIGH/MED across all three.
Adversarial convergence threshold met. Proceed to code-review and security-review.
