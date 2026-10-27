# Lessons: MAINT-SWEEP-2026-10-15 (Dependabot-focused sweep)

Recorded 2026-10-16 by state-manager (candidates; not appended to a cycle `lessons.md`, which requires structured `D-NNN` Closes lines).

- (a) The orchestrator's 2026-10-15 inventory missed comfy-table 8.0.1 and wrongly called #855 superseded. Always query the registry's latest version, not just the Dependabot PR target, and re-query the live PR list (Dependabot re-targets after related merges).
- (b) A research agent read the stale local `develop` (`fb9d015c`) instead of `origin/develop`. Instruct agents to use `origin/develop` (fetch first).
- (c) The orchestrator mis-stated a UTC to CDT conversion (said Sunday 01:00 CDT; correct is Monday 01:00 CDT for Monday 06:00 UTC). Caught by pr-reviewer. Double-check timezone conversions in schedule changes.
- (d) Recurring process gap: the STATE.md size-budget banner line count mismatched the final file after rows moved out (each of the last two sweeps needed a second edit). state-manager must compute the banner from the final composed content before the single Write (done in v5.60: 209 = wc -l).
- (e) "Cargo.lock presence != resolved graph": several deny.toml skip reasons and a prior review claimed dependents (ring, quinn*) that are Cargo.lock-only or filtered by cargo-deny. Verify with `cargo tree --target=all -i <crate>` / `cargo deny --log-level debug` before writing a skip reason (found while doing MAINT-20261020-01, #935).
- (f) Text-matching manifest tests go vacuous when a comment matches first (two tests in `tests/keyring_windows_native_feature_present.rs` had passed vacuously since #838); parse the manifest structurally with a toml parser.
- (g) Targeted `cargo update -p A` followed by `-p B` can re-select unrelated windows-sys versions; reorder the commands rather than hand-editing Cargo.lock, and always diff the lock (MAINT-20261020-02, #936).
- (h) Agents without a shell, or that read the stale local `develop`, produce wrong conclusions (the research agent's "#923 pin mismatch"); repeat of lesson (b). Always cite `origin/develop` (fetch first). Correction note added to `pending-deps-2026-10-20-research.md`.

## Day 4 (2026-10-27) lessons

(i) Check the git identity (user.name/user.email) at session start: a stray repo-local `x <x@x>` identity leaked `Co-authored-by` trailers into 7 squash-merged develop commits and forced a history rewrite (D-414; `maintenance/develop-history-rewrite-2026-10-27.md`).
(j) A lockfile-only advisory fix should be hand-minimized: a plain `cargo update -p` under a newer cargo reshuffled windows-sys edges; #944 kept only the three needed bumps. tokio 1.54.0 is YANKED (RUSTSEC-2026-0384) -- never target it.
(k) The nightly E2E run did NOT keep the free Jira Cloud site warm (suspended for inactivity, 503 `suspendedInactivityPage`); see standing item `E2E-SITE-INACTIVITY-SUSPENSION`.
