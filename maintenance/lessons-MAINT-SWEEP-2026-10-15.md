# Lessons: MAINT-SWEEP-2026-10-15 (Dependabot-focused sweep)

Recorded 2026-10-16 by state-manager (candidates; not appended to a cycle `lessons.md`, which requires structured `D-NNN` Closes lines).

- (a) The orchestrator's 2026-10-15 inventory missed comfy-table 8.0.1 and wrongly called #855 superseded. Always query the registry's latest version, not just the Dependabot PR target, and re-query the live PR list (Dependabot re-targets after related merges).
- (b) A research agent read the stale local `develop` (`fb9d015c`) instead of `origin/develop`. Instruct agents to use `origin/develop` (fetch first).
- (c) The orchestrator mis-stated a UTC to CDT conversion (said Sunday 01:00 CDT; correct is Monday 01:00 CDT for Monday 06:00 UTC). Caught by pr-reviewer. Double-check timezone conversions in schedule changes.
- (d) Recurring process gap: the STATE.md size-budget banner line count mismatched the final file after rows moved out (each of the last two sweeps needed a second edit). state-manager must compute the banner from the final composed content before the single Write (done in v5.60: 209 = wc -l).
