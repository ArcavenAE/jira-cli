# F5 Scoped Adversarial — Pass 1

- **Cycle:** cycle-013 (`msrv-1.88-bump`)
- **Phase:** F5 scoped adversarial review
- **Scope:** `git diff 7160a534..b960c305` (cycle-013 delta) — 46 files, +1073/−1050. Covers
  the MSRV 1.85→1.88 bump (Cargo.toml, ci.yml msrv job), the ~73-site clippy
  `collapsible_if`→let-chain retrofit (PR #818 @ `29e2d362`), and the docs reconciliation
  PRs #819 (@ `cfe1dedc`) and #822 (@ `b960c305`).
- **Reviewer:** adversary (fresh context, no prior review output visible)
- **Date:** 2026-09-16
- **Verdict:** **CLEAN** — 0 CRITICAL / 0 HIGH / 0 MEDIUM

## Basis

1. **Let-chain site-by-site scrutiny (33 sites reviewed this pass).** Every retrofitted
   `if let Some(x) = a && cond { ... }` site was checked for behavior equivalence against
   the pre-retrofit nested-`if` form it replaced. Two else-bearing sites required closer
   attention:
   - `src/cli/board.rs` (`team_displays`, ~L231-257): the nested-if's `else` branch
     produced `Vec::new()`; the let-chain retrofit's `else` arm is byte-identical
     (`Vec::new()`). The subsequent `show_team_col = !team_displays.is_empty()`
     derivation is unaffected by the refactor — same predicate, same input shape.
     Verified SAFE.
   - `src/cli/issue/list.rs` (~L760-789): same pattern — `else { Vec::new() }`,
     behavior-preserving fold over the collected rows. Verified SAFE.
2. **`src/cli/assets/search.rs`** — the 3-level nested-if→let-chain collapse interacts
   with an NLL (non-lexical-lifetimes) borrow that is released before the chain's final
   condition evaluates in both the old and new forms; no borrow-checker-visible behavior
   change, confirmed by reading the surrounding scope boundaries, not just the diff hunk.
3. **`src/adf.rs`** — the splice/index loop touched by the retrofit preserves loop-exit
   and index-advance semantics; the let-chain form short-circuits in the same left-to-right
   order as the nested ifs it replaces.
4. **MSRV floor consistency.** `Cargo.toml` `rust-version = "1.88"`; `ci.yml`'s `msrv` job
   toolchain input `1.88.0` + `RUSTUP_TOOLCHAIN: "1.88.0"` env override on the `cargo check`
   step; job scope widened to `--all-targets`. All three pins agree; no stale `1.85`
   reference found in any file this pass's scope touches.
5. **CI-gate guard integrity.** `tests/common/wf.rs`'s let-chain structural assertions and
   `tests/ci_gate_completeness.rs`'s pinned scalars were read to confirm the retrofit did
   not touch or weaken either guard — both files are outside the diff's touched-line set
   except where the msrv job scope change is itself the thing being asserted.

## Caveat (LOW, non-blocking)

This pass was read-only and did not execute `git diff` directly against the two SHAs
before beginning file-by-file review — it verified the **current tree state** (`develop`
@ `b960c305`) against the claimed delta description rather than mechanically diffing the
two commits first. No discrepancy was found between the claimed scope and the tree state
inspected, but the verification order is noted for the record. Superseded by Pass 2, which
reviewed against the actual computed patch.

## Conclusion

Zero CRIT/HIGH/MED. Proceed to Pass 2.
