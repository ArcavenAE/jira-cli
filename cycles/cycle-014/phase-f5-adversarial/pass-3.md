# F5 Scoped Adversarial — Pass 3

- **Cycle:** cycle-014 (`issue-triage-quickfixes`)
- **Phase:** F5 scoped adversarial review (delta loop resumed after `FIX-P5-003`/PR #895 merged)
- **Scope:** `git diff 204b1fb5..8e843385` — the combined cycle-014 delta (STORY-A PR #886,
  STORY-C PR #887, STORY-B PR #888, `FIX-P5-001` PR #891, `FIX-P5-002` PR #894,
  `FIX-P5-003` PR #895), re-reviewed from fresh context.
- **`FIX-P5-003` merge:** PR #895 MERGED by the human 2026-10-01T20:53:49Z as squash commit
  `8e843385` (`develop` `cc19c2f9 -> 8e843385`); remote branch deleted, worktree removed, main
  checkout fast-forwarded. The PR picked up a follow-up commit `6f6cf104` (pr-reviewer `S-1`: the
  hostile-cell test is now pinned equal to a clean reference render; `N-1` wording). CI all green,
  including all 8 mutation shards and `ci-gate`.
- **Reviewers dispatched (3, fresh context):** adversary, code-reviewer, security-reviewer.
- **Date:** 2026-10-01
- **Convergence counter:** **0 of 3** (NOT CLEAN — counter does not advance). 3 of 10 passes used.
- **Pass verdict:** **NOT CLEAN — FINDINGS_PRESENT** (adversary). Code-reviewer and
  security-reviewer both returned APPROVE.

## Reviewer Verdicts

| Reviewer | Verdict | Findings |
|---|---|---|
| **adversary** | FINDINGS_PRESENT | `P3-001`..`P3-005` LOW (one a FALSE POSITIVE, one a process-gap), `P3-006`/`P3-007` NIT |
| **code-reviewer** | APPROVE | `CR3-001`/`CR3-002` SHOULD-FIX, `CR3-003`..`CR3-005` NIT |
| **security-reviewer** | APPROVE | `SEC3-001`/`SEC3-002` LOW, `SEC3-003`/`SEC3-004` INFO (no action) |

## Findings and Dispositions

### adversary findings

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `P3-001` | LOW | CHANGELOG carries a dangling reference to a `CLICOLOR_FORCE` note. | `FIX-P5-004` (`D-398`) |
| `P3-002` | LOW | CLAUDE.md `output.rs` LOC figure stale. | **FALSE POSITIVE** — verified by the orchestrator: CLAUDE.md already shows 1,718 / ~653 at `8e843385`; the reviewer read a stale copy. |
| `P3-003` | LOW | README `jr api` row lists a nonexistent `--body` flag and an ignored `--output json`. | `FIX-P5-004` |
| `P3-004` | LOW | Byte-exact stderr tests break under `CLICOLOR_FORCE=1`; the test harness is not color-hermetic. | `FIX-P5-004` |
| `P3-005` | LOW [process-gap] | `.cargo/mutants.toml` `exclude_re` anchored at `issues.rs:374:16`, now line 393; pre-dates cycle-014; no guard verifies `exclude_re` anchors. | Re-anchor now in `FIX-P5-004`; the GUARD is DEFERRED (human choice) — tracked as `MUTANTS-EXCLUDE-RE-ANCHOR-GUARD` (`cycles/OPEN-STANDING-ITEMS.md`) and process-gap `#50`. |
| `P3-006` | NIT | `sanitize_control_and_ansi_core` rustdoc says a bare ESC falls through to the policy; it is dropped unconditionally. | `FIX-P5-004` |
| `P3-007` | NIT | `print_output_with_styles` hostile-cell test asserts only `Ok`. | `FIX-P5-004` |

### code-reviewer findings (pass 3)

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `CR3-001` | SHOULD-FIX | Same stale-copy claim as `P3-002`. | **FALSE POSITIVE** (see `P3-002`). |
| `CR3-002` | SHOULD-FIX | `jr user list --project ""` passes through unvalidated; pinned by `EC-X.7.002-6`. | Recorded as a KNOWN LIMITATION in the spec; NO behavior change (`D-398`). |
| `CR3-003` | NIT | Invisible format characters survive the sanitizers (same as `SEC3-001`). | `FIX-P5-004` (merged with `SEC3-001`). |
| `CR3-004` | NIT | `hermetic.rs` inline tests rerun once per test crate. | `FIX-P5-004` |
| `CR3-005` | NIT | The `-q` error echoes the raw user argument. | Acknowledged, no change. |

### security-reviewer findings (pass 3)

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `SEC3-001` | LOW (CWE-451) | Invisible format characters (zero-width, ZWJ, etc.) survive the sanitizers. | `FIX-P5-004`: strip invisible format characters, ZWJ included, per `BC-7.1.006` v1.5.0 `EC-18`/`EC-19`/`EC-20`, `VP-SEC-001-002`. |
| `SEC3-002` | LOW | Known `SANITIZE-ENV-DISPLAY-C1-GAP`. | Already tracked; no new action. |
| `SEC3-003` / `SEC3-004` | INFO | — | No action. |

## `FIX-P5-004` Scope (DECIDED 2026-10-01, `D-398`)

Human decision `D-398`: `FIX-P5-004` covers all LOW and NIT findings, with no spec behavior
change for `CR3-002` (KNOWN LIMITATION): `P3-001`, `P3-003`, `P3-004`, `P3-005` (re-anchor
now), `P3-006`, `P3-007`, `SEC3-001`/`CR3-003` (strip invisible format chars incl. ZWJ),
`CR3-004`, `CR3-005` (acknowledged). `P3-002`/`CR3-001` dispositioned FALSE POSITIVE. The
`P3-005` guard is deferred per the human's choice. Spec delta (committed with this burst):
`FIX-P5-004-spec-delta.md`, `BC-7.1.006` v1.5.0, spec-changelog `[2.6.0]`, `EC-X.7.002-6`.
Delivery: worktree `.worktrees/FIX-P5-004`, branch `fix/fix-p5-004-pass3-findings`, base
`8e843385`, implementer dispatched. After merge: post-merge spec conversion (`EC-18`/`19`/`20`
to live citations), then Pass 4.

## Status

Pass 3 is **NOT CLEAN**. Clean-pass counter **0/3** (10-pass cap; 3 used).
