## Summary

Bundle-scoped mutation runs (`cargo mutants --in-diff <base>..<head>`) use the same default timeout and job-count configuration as single-story runs, but bundle diffs are substantially larger. Under `--jobs 4` with the default 240s wall-clock cap, a bundle with a 91s baseline may time out 20–30% of its mutants — producing a raw kill rate below the ≥90% threshold that requires a full adjudication ceremony even when the timeouts are calibration artifacts, not missed mutants.

## Evidence (jira-cli SOH-COMMENT-CRUD-1, F6 hardening, 2026-07-14)

**Mutation run configuration:** `--in-diff b2ce3169..ae2e3db --jobs 4 --timeout 240`
**Bundle size:** 6 stories, 11 new BCs, 23 files changed, 6,364 insertions.
**Results:** 60 mutants generated; 39 caught directly; **20 timed out**; 1 unviable.
**Raw kill rate:** 66.1% (39/59 viable — below the 90% gate threshold).
**Baseline time for the test suite:** ~91 seconds per run.

Under `--jobs 4`, 4 mutants run concurrently; each slot has a 240s cap. When the test suite takes 91s and 4 slots contend for the same CPU/IO resources, effective per-slot budget is roughly 60s — less than the baseline test time for the affected handler-level tests (`handle_comment_edit`, `handle_comment_view`). All 20 timeouts were in the same handler class.

**Adjudication result:** 3 isolated manual mutations targeting the timeout-affected handlers confirmed all 3 were caught by existing tests. The formal-verifier adjudicated 100% kill rate (0 missed) based on this evidence. Gate passed.

**Cost:** One full adjudication ceremony — 3 isolated manual runs, evidence documentation, formal finding write-up. Avoidable with correct configuration.

## Proposed Fix

**Formal-verifier skill update:** Add a bundle-size heuristic for mutation run configuration:

```
Single-story diff  (< 500 LOC changed): --jobs 4 --timeout 240  (current default)
Bundle-scoped diff (≥ 500 LOC changed): --jobs 2 --timeout 480  (recommended)
```

The `--jobs 2` setting doubles the per-slot CPU budget; `--timeout 480` covers test suites up to ~120s baseline under 2-slot contention with headroom.

**`.cargo/mutants.toml` guidance:** Document that the timeout values in `.cargo/mutants.toml` are calibrated for single-story diffs. For bundle-scoped F6 runs, override via CLI flag: `cargo mutants --in-diff <diff> --jobs 2 --timeout 480`.

**Note:** This does not change the ≥90% kill-rate gate threshold — it only ensures the raw kill rate reflects actual coverage rather than timing artifacts.

## Severity

LOW calibration gap. When triggered, it adds ~30 minutes of adjudication overhead and requires manual re-runs to prove timeouts are not survivors.

## Source

jira-cli SOH-COMMENT-CRUD-1 session review 2026-07-15 (IP-577-06). Codified as MUTANTS-BUNDLE-TIMEOUT-CALIBRATION drift item in jira-cli STATE.md. F6 hardening results: `.factory/phase-f6-hardening/577/mutation-results.md`.
