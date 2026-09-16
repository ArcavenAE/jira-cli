# F5 Security Review — cycle-013 (`msrv-1.88-bump`)

- **Scope:** `git diff 7160a534..b960c305` (46 files, +1073/−1050) — MSRV 1.85→1.88 bump,
  ~73-site `collapsible_if`→let-chain retrofit (PR #818 @ `29e2d362`), Wave-2 S3 docs
  (PR #819 @ `cfe1dedc`), Wave-2-gate F-2 doc fix (PR #822 @ `b960c305`).
- **Reviewer:** security-reviewer (fresh context)
- **Date:** 2026-09-16
- **Verdict:** **CLEAN** — 0 findings (CRIT/HIGH/MED/LOW)

## Basis

1. **`ci.yml` `msrv` job change is strengthening, not weakening.** The scope widen from
   `lib+bins` to `--all-targets` INCREASES coverage (now compiles test targets, including
   `tests/common/wf.rs` and its `saphyr-parser` dev-dependency, under the MSRV floor). The
   action SHA is unchanged; no new `uses:`, `run:`, `secrets:`, or `permissions:` blocks
   were introduced. The CI-gate trust boundary (six-file review scope per CLAUDE.md) is
   untouched — this diff only touches `ci.yml`'s `msrv` job body, not `ci-gate` itself or
   any of the other five governed files' assertion logic.
2. **Dependency delta reviewed for known vulnerabilities.**
   - `comfy-table` 7.2.1→7.2.2: no CVE/RUSTSEC advisory found for either version.
   - `saphyr-parser` 0.0.11 (unchanged pin, now additionally compiled under `--all-targets`
     MSRV check): no CVE/RUSTSEC advisory. The known upstream billion-laughs/DoS issue
     (saphyr-rs/saphyr#109) is scoped to the high-level `YamlLoader`/`saphyr::Yaml` API —
     this repo's `tests/common/wf.rs` uses only the low-level `Parser`/`Event` stream, which
     is not the vulnerable surface. Confirmed the repo's usage is `Parser`-only, not
     `YamlLoader`, by inspection of `tests/common/wf.rs`'s imports. Dev-dependency only —
     no production/release-binary exposure regardless.
3. **Every auth/credential/retry let-chain site checked for control-flow equivalence.**
   Reviewed each retrofitted site touching security-sensitive logic:
   - The OAuth CSRF `state` parameter check is outside this diff's touched-line set
     (unaffected).
   - The `--verbose-bodies` PII body-suppression guard's conditional structure is
     preserved byte-for-byte pre/post retrofit.
   - `MAX_ERROR_PAIRS`/`cap_entry` (CWE-770 unbounded-growth defense in error-pair
     accumulation) retains identical cap-check-then-insert ordering.
   - `src/api/refresh_coordinator.rs`'s single-flight refresh-coordination logic is
     unchanged by this diff (outside the touched-file set).
   No security-relevant control-flow site had its evaluation order, short-circuit
   behavior, or branch reachability altered by the let-chain collapse.
4. **No new attack surface.** Zero new endpoints, zero new file I/O, zero new
   deserialization paths, zero new external-input parsing introduced by this diff — it is
   a build-config/toolchain bump plus a syntax-only refactor plus docs corrections.

## Conclusion

CLEAN. 0 findings. No security-relevant behavior change in this delta.
