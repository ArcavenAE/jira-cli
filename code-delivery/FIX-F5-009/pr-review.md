# PR Review — #648 (FIX-F5-009 / F5-R4-001)

**Verdict: APPROVE**

`docs(test): correct F5-R3-002 reachability narrative` — comment-only change (27+/24−). No code, test logic, or test assertions altered (confirmed). Only docstrings and inline comments in `src/cli/issue/attachments.rs` changed.

## What I verified

Checked the reworded narrative against the real call site (`handle_batch_download`) and helper (`batch_path_is_within_dir`), not just the diff:

1. **"`resolved_dir` is always `base_dir.canonicalize().unwrap_or(base_dir)`"** — ACCURATE. `attachments.rs:906-908` sets `resolved_dir = base_dir.canonicalize().unwrap_or_else(|_| base_dir.to_path_buf())`, functionally identical to the comment.
2. **"`final_path.parent()` is always `base_dir`"** — ACCURATE. `compute_default_output_path` returns `base_dir.join("{hash}_{sanitized}")` — a single non-traversing component — so the parent is always `base_dir`.
3. **"the `Ok(false)` mass-rejection scenario is UNREACHABLE via `handle_batch_download`"** — ACCURATE and warranted. `resolved_dir` is pre-canonicalized at the call site (idempotent under a second `canonicalize()`), so `canonical_parent` and `canonical_dir` always agree → `Ok(true)`. If the directory does not exist, `parent.canonicalize()` fails first → `Err` → fail-open. No path yields `Ok(false)` for a genuinely-contained file. The old "Downloaded 0 of N / exit 0 reachable defect" narrative was overstated; the rewrite is a genuine accuracy correction.

The three reworded blocks (helper comment, test docstring, inline body comment) are internally consistent with each other and with the code. No behavioral risk.

## Findings

| Severity | Category | Finding | Suggestion |
|----------|----------|---------|------------|
| NIT (cosmetic) | doc-accuracy | New docstring: "if either `canonicalize()` fails, the helper returns `Err` and the call site's **warn-and-skip** path fires (fail-open)." The `Err` branch (`attachments.rs:941-950`) warns and **proceeds** with the download — it does not skip the file. "Skip" applies to the `Ok(false)` branch. The original wording ("fail-open: the download proceeds with a warning logged") was clearer. | Reword to "warn-and-proceed" or restore the original parenthetical. `(fail-open)` already prevents real misreading — non-blocking. |

## Rationale

Every substantive claim in the reworded comments is factually correct and independently verified against source. The change correctly downgrades an overstated defect narrative to defense-in-depth / future-caller framing that matches the actual pre-canonicalized call site. The single nit is a loose "skip" verb on the fail-open branch — optional touch-up, not a merge blocker.
