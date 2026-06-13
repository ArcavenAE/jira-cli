# S-WIN-1 Implementation — Step 4.5 Per-Story Adversarial Convergence (BC-5.39.001)

Date: 2026-06-13. Branch feat/win-1-per-os-path-resolution off develop 2b13596. Commits: 40fa957 (impl: #[cfg(windows)] AppData branches in global_config_dir + cache_root + 6 #[cfg(windows)] tests), db175c6 (extract pure config_appdata_fallback/cache_localappdata_fallback helpers + un-gate fallback tests + seam-scrub).

Change: per-OS path resolution — on Windows, global_config_dir() → dirs::config_dir() (%APPDATA% Roaming) .join("jr"); cache_root() → dirs::cache_dir() (%LOCALAPPDATA% Local) .join("jr"); empty-env defensive fallback → ./jr. Seam (S-WIN-2 JR_CONFIG_DIR/JR_CACHE_DIR) stays first; Unix #[cfg(not(windows))] arm byte-identical; XDG ignored on Windows; cache_dir(profile) still v1/<profile>. BC-6.1.014 / BC-6.2.016 / BC-6.2.004.

Testability: #[cfg(windows)] behavioral tests run only on Windows CI (S-WIN-5); cross-compile type-check (cargo check --target x86_64-pc-windows-msvc --lib) = zero Rust type errors (aws-lc-sys C windows.h failure is expected macOS cross-limit). macOS full suite green (907).

## Adversarial journey

- Pass 1: CLEAN. Primary axis (dirs uses Known Folder API, not %APPDATA% env var) resolved cleanly — fallback is intentionally near-dead defensive code; BC-6.1.014 EC-1 honest about it. 1 observation: env-fallback tests tautological (spec-acknowledged).
- Round of 3 fresh passes: all CLEAN/near-clean but converged on the same LOW finding (F-WIN1-RB-101/RC-101): the 2 *_env_fallback tests re-typed the fallback expression instead of calling production code → mutant survives. Plus F-WIN1-RB-102 (xdg_ignored test didn't scrub JR_CONFIG_DIR → ambient seam could perturb on debug Windows runner).
- Fix (db175c6): extracted pure platform-agnostic config_appdata_fallback/cache_localappdata_fallback free fns called by the #[cfg(windows)] branches; rewrote the 2 fallback tests UN-GATED to call the production helper (now run on macOS, kill the empty-filter/default mutants on every platform); scrubbed JR_CONFIG_DIR/JR_CACHE_DIR in all #[cfg(windows)] tests under ENV_MUTEX.
- Final 3 fresh passes: ALL 3 CLEAN. Mutation analysis: all 5 mutation classes (drop empty-filter, change default, config/cache dirs swap, drop windows branch, move seam below branch) killed somewhere in the {macOS, Windows} matrix. Orchestrator independently confirmed macOS cargo test green.

## Verdict

CONVERGED (3-clean final). No spec reconciliation needed (impl matched spec). Accepted cfg-gated limitation: the .join("jr") on the windows branch + None→helper wiring only exercised on Windows CI (S-WIN-5) — inherent, spec-acknowledged. No new drift items.
