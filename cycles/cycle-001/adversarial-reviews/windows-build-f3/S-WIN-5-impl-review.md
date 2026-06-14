# S-WIN-5 Implementation — Step 4.5 Per-Story Adversarial Convergence (BC-5.39.001) — FINAL Windows-build story

Date: 2026-06-14. Branch feat/win-5-ci-yml-windows-job off develop bc69c625. Commits: 8e6c5a2 (ci.yml windows test+clippy matrix), 7457de0 (37-file XDG→seam migration), 26c17d6 (F-WIN5-IMPL-101 multi_cloudid config half-migration + guard per-var), db4d98f (F-WIN5-C-101 worklog in-process half-migration + guard per-call-site count), cc1d9e3 (F-1 separator assertion), f40c310 (F-WIN5-01 CRLF yaml + F-WIN5-02 grep in-process).

Change: ci.yml adds windows-latest to test matrix + a SEPARATE windows clippy matrix (ADR-0016 Decision 3); .gitattributes (*.snap + *.yml + *.yaml eol=lf); 37-file XDG_CONFIG_HOME/XDG_CACHE_HOME → JR_CONFIG_DIR/JR_CACHE_DIR seam migration (value = XDG.join("jr") per BC-6.2.017); F-WIN2-C-101 scrub-list closed; AC-004 guard (per-var + per-call-site count). This CI job RUNS S-WIN-1/2's #[cfg(windows)] tests on a real Windows runner for the first time.

## Adversarial journey (Step-4.5) — 4 fix rounds, each caught a DISTINCT Windows-failure class

- Pass 1: F-WIN5-IMPL-101 (multi_cloudid config-seam half-migration, MEDIUM) + F-WIN5-IMPL-102 (stale comment). Guard was per-FILE || → masked half-migration. Fixed (26c17d6) + strengthened guard to per-var.
- Round (A/B/C): F-WIN5-C-101 (worklog_duration_holdouts IN-PROCESS cache-seam half-migration, MEDIUM) — per-file guard still blind to in-process sites. Fixed (db4d98f) + strengthened guard to per-CALL-SITE count.
- Round (1/2/3): F-1 (issue_create_jsm.rs separator assertion contains("/jr/v1/") → FAILS on Windows backslash, HIGH). Fixed (cc1d9e3) + Step-5b separator sweep (all other / usages SAFE: URLs/log prefixes).
- Round (final pass 1): F-WIN5-01 (CRITICAL — ci_yml_windows_matrix.rs extract_job_block ":\n" anchor fails on CRLF-checked-out ci.yml; .gitattributes only covered .snap not .yml) + F-WIN5-02 (grep subprocess MEDIUM). Fixed (f40c310): CRLF-normalize yaml reads + *.yml/*.yaml eol=lf + grep→in-process fs walk.
- Final 3 passes: ALL 3 CLEAN. Migration call-site-exact (delta = allowlisted e2e_live.rs only); CRLF/separator/grep classes swept; ci.yml correct; #[cfg(windows)] tests structural/resilient; ENV_MUTEX serialized + panic-safe restore. Residual: first-live-Windows-compile unknowable (flag-not-block by design — this story unblocks it).

## Verdict: CONVERGED (3-clean final). Full Unix suite 1793/0; cross-compile --tests zero Rust errors; clippy/fmt clean; actionlint/YAML valid. AC-005/AC-007 are integration gates satisfied by the windows-latest CI run in this story's PR.

## LESSON-WIN-CI-CHECKLIST (codify — the durable artifact from the 4-round journey)

Windows-CI-readiness checklist for future cross-platform CI matrix activations:

1. Every test setting an OS-specific isolation env var (XDG_*) MUST pair it with the cross-platform seam (JR_*) at EVERY call site; meta-test enforces per-CALL-SITE count parity (not file-level presence — file-level || or presence misses in-process half-migrations).
2. Every test reading a file for \n-sensitive/line-anchored matching MUST .replace("\r\n","\n") or use .lines(); pin *.snap/*.yml/*.yaml eol=lf in .gitattributes.
3. Runtime stderr/stdout path assertions MUST be separator-agnostic (assert filename/non-path-prefix or Path components, never contains("a/b") on a rendered PathBuf) — LESSON-PATH-SEP-ASSERT.
4. Seam/isolation env vars MUST scrub ambient values first (.env_remove before .env) to prevent dev-shell leakage (F-WIN2-C-101 class).
5. No un-#[cfg(unix)]-gated external-binary subprocess (grep/sh/sed/chmod/ln) — prefer in-process std::fs; gate Unix-only tests.
6. Cross-platform pure helpers for OS-branch logic, un-gated, so mutants die on the Unix runner too.
