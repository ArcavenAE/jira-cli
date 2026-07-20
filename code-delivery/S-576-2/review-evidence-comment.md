## PR #631 — Review Evidence & Merge-Ready Summary (S-576-2)

**Story:** S-576-2 — `jr issue attachment download` single/batch/newest + streaming + CWE-22 sanitization  
**Branch:** `feat/S-576-2-attachment-download` → `develop`  
**Head SHA at review:** `6d6ea1a9d4390fcbeaa366c7e83978e6fd1d0b09`  
**Review cycles:** 5 (including cycle 5 delta review)  
**covered_sha:** `6d6ea1a9d4390fcbeaa366c7e83978e6fd1d0b09` — FRESH (check-stale-verdict.sh exit 0)

---

### Review Convergence

| Cycle | Findings | Blocking | Fixed | Status |
|-------|----------|----------|-------|--------|
| 1 | 6 | 3 | 3 | FIXED |
| 2 | 0 | 0 | — | APPROVE (SHA 575e065d) |
| 3 | 1 (CI-triggered) | 0 | 1 (B4 CR filename) | APPROVE (SHA ffbd4e1f) |
| 4 | 1 (CI-triggered) | 0 | 1 (B5 BiDi filename) | APPROVE (SHA bc8ff260) |
| 5 (delta) | 1 NIT | 0 | — | APPROVE (SHA 6d6ea1a9) |

**All blocking findings fixed:**
- B1: `clippy::useless_borrows_in_formatting` at `tests/attachment_download.rs:725,797` — FIXED (575e065d)
- B2: Windows `Path::file_name()` strips `C:` drive prefix in `sanitize_attachment_filename` — FIXED (575e065d)
- B3: PR description claimed CI green when red — ADDRESSED
- B4: CR (`\r`, 0x0D) in test poison filename illegal on Windows NTFS — FIXED (ffbd4e1f)
- B5: U+202E (BiDi RLO) rejected by GitHub Actions Windows runner (OS error 123) — FIXED (bc8ff260, changed to U+007F DEL which is NOT in Windows forbidden range 1-31)

**Cycle 5 delta (test-only + ci-only — no production code changed):**
- a61367f5: ci.yml mutation timeout 120→240m (human-approved; mutation gate confirmed 94%)
- 3aabc92f: +17 mutation-kill tests (+4 integration +3 unit) — gate 79%→94%
- 6d6ea1a9: platform-gate pure-backslash sanitize unit test (Windows separator semantics)

**Accepted advisory findings (non-blocking):**
- SEC-001 (LOW): Batch fallback uses `att.id` without sanitization — accepted per spec SEC-576-008
- SEC-002 (LOW): Containment check vacuous — accepted with mutation exemption
- SEC-003 (LOW): `att.id` in batch warning not display-sanitized — deferred
- NIT-1: `sha1` redundant dev-dep (runtime dep already available) — advisory only

---

### Security Review Verdict: APPROVED_WITH_NOTES

- 0 CRITICAL, 0 HIGH, 0 MEDIUM findings
- 3 LOW findings — SEC-001/002 blocked by ENOENT in practice; SEC-003 IDs are always numeric
- GHSA-9857-6MW7-FQ2M: confirmed correct behavior (reqwest strips auth on CDN redirect)
- JRACLOUD-97046: no `?redirect=false` in URL construction
- deny.toml cpufeatures 0.2 skip: HUMAN-AUTHORIZED (AUDIT-576-004/DEC-185)

---

### CI Status: ALL CHECKS PASSING

**Run 29773933464 on SHA `6d6ea1a9d4390fcbeaa366c7e83978e6fd1d0b09`:**

| Job | Status |
|-----|--------|
| Clippy (ubuntu + windows) | pass |
| Test (ubuntu-latest) | pass |
| Test (macos-latest) | pass |
| Test (windows-latest) | pass |
| Coverage | pass |
| Deny | pass |
| Format | pass |
| MSRV (1.85.0) | pass |
| Secret Scan | pass |
| Spec Guards | pass |
| Signing Workflow Injection Guard | pass |
| Mutation testing | pass — 94% kill rate (79 caught / 4 missed documented-equivalent) |
| **CI Gate** | **pass** |

---

### Dependency Check

| Dependency | PR | Status |
|------------|-----|--------|
| S-576-1 attachment list | #630 | MERGED (2026-07-20T01:26:57Z, e33624c1) |

---

### Adversarial Review: STRICT CONVERGENCE

12 passes, 9 fix rounds, window p10/p11/p12 clean.

---

### Test Evidence

- 29 integration tests in `tests/attachment_download.rs`
- Property test: `prop_sanitize_attachment_filename_no_path_traversal` (VP-576-001, proptest 100 cases)
- BC coverage: BC-2.7.007..012 fully traced
- All tests passing on ubuntu, macos, windows

---

**Status: MERGE_READY**

All gates passed:
- Review converged: 5 cycles, cycle-5 APPROVE
- check-stale-verdict.sh: exit 0 (FRESH)
- CI Gate: PASS (run 29773933464)
- Dependency S-576-1: MERGED

DEC-128: human squash-merges. covered_sha: `6d6ea1a9d4390fcbeaa366c7e83978e6fd1d0b09`
