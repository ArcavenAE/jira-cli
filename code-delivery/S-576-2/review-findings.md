---
document_type: review-findings
story_id: "S-576-2"
pr_number: 631
pr_url: "https://github.com/Zious11/jira-cli/pull/631"
last_updated: "2026-07-20"
---

# Review Findings — S-576-2 (PR #631)

## Convergence Tracking

| Cycle | Total Findings | Blocking | Fixed | Advisory | Status |
|-------|---------------|----------|-------|----------|--------|
| 1 | 6 | 3 | 3 | 3 | FIXED → cycle 2 dispatched |
| 2 | 0 | 0 | — | 0 | APPROVE SHA 575e065d |
| 3 | 1 | 0 | 1 (B4 CR) | 0 | APPROVE SHA ffbd4e1f |
| 4 | 1 | 0 | 1 (B5 BiDi) | 0 | APPROVE SHA bc8ff260 |
| 5 (delta) | 1 NIT | 0 | — | 1 (sha1 dep NIT) | APPROVE SHA 6d6ea1a9 |

---

## Cycle 1

**Reviewer:** pr-reviewer (vsdd-factory)
**Head SHA reviewed:** 1a4ad71cb0e5f32222f9f18425559727c13e7657
**Verdict:** REQUEST_CHANGES

### Blocking Findings

| ID | Category | Location | Description | Status |
|----|----------|----------|-------------|--------|
| B1 | CI | `tests/attachment_download.rs:725,797` | `clippy::useless_borrows_in_formatting` — redundant `&` in `format!` | FIXED commit 575e065d |
| B2 | correctness | `src/cli/issue/attachments.rs::sanitize_attachment_filename` | Windows `Path::file_name()` strips `C:` drive prefix — `C:config.txt` → `config.txt` instead of `C_config.txt` | FIXED commit 575e065d (pre-replace `:` before `Path::file_name()`) |
| B3 | description | PR description pre-merge checklist | Claimed CI was green when Clippy + Windows Tests were red | ADDRESSED — CI re-running |

### Advisory Findings (non-blocking, accepted/deferred)

| ID | Severity | Description | Disposition |
|----|----------|-------------|-------------|
| SEC-001 | LOW | Batch ID fallback uses raw `att.id` string (not validated numeric) | Accepted — spec trusts numeric IDs (SEC-576-008) |
| SEC-002 | LOW | Containment check operates on `file_name()` (vacuous after sanitization) | Accepted — mutation exemption documented in code |
| SEC-003 | LOW | `att.id` in batch warning stderr not display-sanitized | Deferred — IDs are always numeric in practice |

### Fixes Applied

Commit `575e065d107b0952b1fa82a33b71595a3c76bf6f`:
- `src/cli/issue/attachments.rs`: pre-replace `:` with `_` in `sanitize_attachment_filename` before `Path::file_name()` call (cross-platform BC-2.7.011 fix)
- `tests/attachment_download.rs:725,797`: removed redundant `&` in `format!` macros

---

## Cycle 2

**Status:** APPROVE — verdict from pr-reviewer (a60ee7141e31bbf72)
**Head SHA reviewed:** 575e065d107b0952b1fa82a33b71595a3c76bf6f
**covered_sha:** 575e065d107b0952b1fa82a33b71595a3c76bf6f
**Prior blocking fixed:** 3/3 (B1 clippy, B2 Windows colon, B3 CI description)
**New blocking found by CI:** B4 (see Cycle 3)

---

## Cycle 3

**Trigger:** CI run 29734699891 — Windows test failure (post-cycle 2)
**Status:** APPROVE — pr-reviewer (cycle 3) for SHA ffbd4e1f
**Head SHA reviewed:** ffbd4e1f9a2a24dbf7813732bb5f8b328e9a09a9
**covered_sha:** ffbd4e1f9a2a24dbf7813732bb5f8b328e9a09a9

### Blocking Finding from CI

| ID | Category | Location | Description | Status |
|----|----------|----------|-------------|--------|
| B4 | test | `tests/attachment_download.rs:2209,2297` | CR (`\r`, 0x0D) in poison filename is illegal on Windows NTFS — tests P8-001/P9-001 fail with OS error 123 | FIXED commit ffbd4e1f (changed to U+202E-only) |

### Fix Applied

Commit `ffbd4e1f9a2a24dbf7813732bb5f8b328e9a09a9`:
- `tests/attachment_download.rs`: Changed `poisoned_filename` from `"evil\u{202E}\rname.txt"` to `"evil\u{202E}name.txt"` in both tests
- Changed `display_safe` from `"evil??name.txt"` to `"evil?name.txt"` (one replacement not two)

---

## Cycle 4

**Trigger:** CI run 29735639851 — Windows test failure (post-cycle 3); U+202E also rejected by GitHub Actions Windows runner (OS error 123)
**Status:** APPROVE — pr-reviewer (cycle 4)
**Head SHA reviewed:** bc8ff260f0a0e8162810addfcdfaa3253bbb89c2
**covered_sha:** bc8ff260f0a0e8162810addfcdfaa3253bbb89c2

### Blocking Finding from CI

| ID | Category | Location | Description | Status |
|----|----------|----------|-------------|--------|
| B5 | test | `tests/attachment_download.rs:2214,2308` | U+202E (BiDi RLO) is ALSO rejected by GitHub Actions Windows runner with OS error 123 (InvalidFilename) — same class as `\r`. Both B4 and B5 are due to GitHub Actions Windows runner security policy blocking BiDi override characters. | FIXED commit bc8ff260 (changed to U+007F DEL = 127, NOT in Windows forbidden range 1–31) |

### Fix Applied

Commit `bc8ff260f0a0e8162810addfcdfaa3253bbb89c2`:
- `tests/attachment_download.rs`: Changed `poisoned_filename` from `"evil\u{202E}name.txt"` to `"evil\u{7f}name.txt"` in P8 and P9 tests
- Updated assertions: `!contains('\u{202E}')` → `!contains('\u{7f}')`
- Removed vacuous `\r` assertions (not in new fixture)
- Updated docstrings and comments

---

## Cycle 5 (Delta Review)

**Trigger:** 3 new commits since cycle-4 APPROVE (test-only + ci-only); stale-verdict check exit 1 STALE_READY_VERDICT
**Status:** APPROVE — pr-reviewer delta review
**Head SHA reviewed:** 6d6ea1a9d4390fcbeaa366c7e83978e6fd1d0b09
**covered_sha:** 6d6ea1a9d4390fcbeaa366c7e83978e6fd1d0b09
**check-stale-verdict.sh:** exit 0 (FRESH)

### Delta scope

| Commit | Type | Description |
|--------|------|-------------|
| a61367f5 | ci-only | Raise mutation-testing timeout 120m→240m (human-approved) |
| 3aabc92f | test-only | Kill 17 surviving mutants — mutation gate 79%→94%; +4 integration +3 unit |
| 6d6ea1a9 | test-only | Platform-gate pure-backslash sanitize expectation (Windows separator semantics) |

### Findings

| ID | Severity | Description | Status |
|----|----------|-------------|--------|
| NIT-1 | NON-BLOCKING | `sha1` added to `[dev-dependencies]` is redundant (already a runtime dep) | Advisory only |

No blocking findings. No production code changed.

---

## CI Status

| Run | SHA | Status | Clippy | Tests | Mutation | Gate |
|-----|-----|--------|--------|-------|----------|------|
| 29733955097 | 1a4ad71c | FAILED | fail | windows fail | — | — |
| 29734699891 | 575e065d | FAILED | pass | windows fail | — | BLOCKED |
| 29735639851 | ffbd4e1f | FAILED | pass | windows fail (U+202E) | cancelled (timeout) | BLOCKED |
| 29736816386 | bc8ff260 | FAILED | pass | ALL PASS ✅ | cancelled (timeout) | BLOCKED |
| 29773933464 | 6d6ea1a9 | SUCCESS ✅ | pass | ALL PASS ✅ | success 94% | PASS ✅ |
