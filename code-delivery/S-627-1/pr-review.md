# PR Review — PR #682 (S-627-1 Phase 1)

**Verdict:** APPROVE (posted to GitHub as COMMENT state — see note below)
**Covered SHA:** `fc2019a9`
**Branch:** `fix/bc-numeric-count-guard-regex` → `develop`
**Scope:** `scripts/check-bc-no-numeric-test-counts.sh` only (1 file, +227/−41)

> **Posting-state note:** GitHub rejects a formal `--approve` / `--request-changes`
> review when the reviewer identity equals the PR author (self-authored PR). The
> review was therefore posted with `gh pr review --comment`, with the APPROVE
> verdict stated explicitly in the body. This is a formal review event (COMMENT
> state), not a plain `gh pr comment`.

## Checklist outcome

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence | PASS — all changes relate to the regex fix + self-test seam |
| 2 | Description accuracy | PASS — PR body matches the diff |
| 3 | Test coverage | PASS — 22 self-test fixtures; boundary + I/O paths exercised |
| 4 | Demo evidence | N/A — CI spec-guard script; behavior verified via self-test + manual runs |
| 5 | Commit quality | PASS |
| 6 | Diff size | PASS — 227 lines, single file, well under concern threshold for this change class |
| 7 | Missing changes | PASS — Phase 1 = script only; Phase 2 (BC reverts) deliberately deferred |
| 8 | Dependency status | PASS — no upstream deps (`depends_on: []`) |

## What was verified independently on the diff

**Regex boundary (AC-1 / AC-2).** Compared OLD vs NEW PATTERN against every NEG
fixture: NEG-1/4/6/7/9/10/11/12/13 match under OLD and stop matching under NEW —
genuinely discriminating regression guards. NEG-2/3/5/8 (`CWE-22`, `BC-3.8.012`,
`#639`, `v0.7.0`) are non-discriminating but honestly stand as the exact AC-2
tokens the story enumerates. True positives (`16 wiremock tests`, `1 subprocess
test`, compound form) still trigger. Adversarial mixed case
(`CWE-93 and 4 wiremock tests`) still correctly matches on the real count.
`(^|[^[:alnum:]._#-])` is POSIX-ERE / BSD-portable — verified on macOS BSD grep;
shellcheck exit 0.

**I/O-error exit-2 restructure (ADV-S627-P1-MED-001).** Reproduced with a
`chmod 000` bc file → genuine exit 2. The two separate command substitutions
(no `grep1 | grep2` pipe) correctly remove the pipefail-rightmost-status masking;
the comment accurately describes both the old subshell-`return` discard and the
pipefail mechanism. Fail-closed and propagating. `printf '%s' | grep` handles
empty-input and no-trailing-newline correctly.

**Seam + fixtures.** `--self-test` → 22/22; `EXPECTED_FIXTURES=22` pin present and
fails loud on omission; per-fixture assert prints label + expected/got on mismatch.
`--bc-dir` override works; unknown arg → exit 64; missing/empty dir → exit 2
(fail-closed). New script run against the real still-hyphenated BC dir → exit 0,
so Phase-1 merge does not break the spec-guard job before Phase 2 lands.

## Findings

| Severity | Category | File:Line | Finding | Suggestion |
|----------|----------|-----------|---------|------------|
| nit | coherence | scripts/check-bc-no-numeric-test-counts.sh (`--bc-dir` arg parse, `${2:?…}`) | `--bc-dir` with a missing value exits **1** via the `${2:?}` expansion rather than the **64** the header advertises for usage errors. | Optional: validate the value explicitly and `exit 64` for consistency with the unknown-argument path. Fails closed and loudly either way, so non-blocking. |

No blocking or suggestion-level findings. Regex correctness, fail-closed I/O
handling, fixture discrimination, count-pin integrity, and scope discipline all
hold.
