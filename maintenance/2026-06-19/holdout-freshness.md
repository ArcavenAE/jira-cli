# Maintenance Sweep 4 — Holdout Scenario Freshness

- **Date**: 2026-06-19
- **Product baseline**: `develop` @ 71f33c6 ("chore(release): v0.6.0-dev.5"; == tag v0.6.0-dev.5, 0 commits ahead)
- **Holdout file**: `.factory/specs/prd/holdout-scenarios.md` (`total_holdouts: 57`, version 1.1.2, last_updated 2026-05-20)
- **Prior run**: `.factory/maintenance/2026-06-17/holdout-freshness.md` (baseline `develop` @ 53f6d98)
- **Mode**: READ-ONLY. No code changes, no commits, holdout file NOT modified. This is a **staleness sweep only** — NOT a Phase 4 holdout evaluation (Phase 4 has not started). No scenarios were executed against fixtures.
- **Method**: (1) cross-checked every scenario's referenced subcommand + flag against the freshly built `jr --help` surface (`./target/debug/jr`); (2) assessed expected behavior against current product behavior (ADR-0015 proactive resolution, v0.6 verbose split, post-2026-05-20 ADF passes, S-3.07 rate-limit cap); (3) confirmed MUST-FIX holdout closure via test-file presence on `develop`.

## Summary

- **Total scenarios**: 57
- **Fresh (no action)**: 53
- **Stale (recommend revision)**: 4
- **CLI-surface drift (functional breakage)**: 1 NEW — **H-NEW-MP-001** (`--story-points` flag removed; only `--points` parses)
- **Net change vs prior run**: prior run reported 3 stale-candidates (H-007, H-044, H-027). This run **DOWNGRADES H-044 to FRESH** (confirmed via source: mention-drop still current), **CONFIRMS H-007 + H-027 stale**, and **ADDS one NEW functional drift (H-NEW-MP-001)**.

## Prior-Run Findings: FIXED vs OPEN

| Prior Issue | Scenario | Prior status | This run |
|-------------|----------|--------------|----------|
| Issue A | H-007 | STALE-CANDIDATE (high) | **STILL OPEN** — mechanism stale, confirmed by `tests/issue_move_resolution_enforce.rs` + `docs/adr/0015-proactive-resolution-enforcement.md` |
| Issue B | H-044 | STALE-CANDIDATE (medium) | **DOWNGRADED → FRESH** — verified mention-drop is still current behavior (see Finding below) |
| Issue C | H-027 | STALE-CANDIDATE (housekeeping) | **STILL OPEN** — internal MUST-PASS-vs-future-MUST-FAIL contradiction unchanged |
| Issue D | H-018 gap | intentional, non-issue | Unchanged — documented retirement, no action |
| Issue E | H-036/H-045/H-046/H-NEW-MP-001 MUST-FIX narrative | historical-stale (soft) | **STILL OPEN (soft)** — all four shipped (test files confirmed); "current code fails" narrative now historically inaccurate. Plus H-NEW-MP-001 now has a HARD drift (see NEW below) |
| Issue F | no `lifecycle_status` field | schema recommendation | Unchanged — field still absent (0 occurrences); recommendation carries forward |

**None of the prior stale-candidates were fixed in the source file** (holdout file `last_updated` still 2026-05-20; develop advanced 53f6d98 → 71f33c6 via the FORK-OPS-BACKFILL release cycle, which touched CI/release-ops, not holdouts).

## Per-Scenario Results (drift-relevant + all stale)

| Scenario | Status | Reason | Recommended fix |
|----------|--------|--------|-----------------|
| H-NEW-MP-001 | **STALE (functional)** | Action line uses `jr issue create … --story-points 5`. Current CLI rejects `--story-points` at clap (`error: unexpected argument '--story-points' found`); only `--points` parses. An evaluator running the literal action fails on a parse error, not the multi-profile assertion. | Replace `--story-points 5` with `--points 5` on line 480. (Config-key refs `story_points_field_id` on lines 476/477/487 are UNAFFECTED — those are config keys, not CLI flags.) |
| H-007 | **STALE (mechanism)** | Setup mounts POST→400 `{errors:{resolution:…}}` expecting a *reactive* rewrite (BC-3.2.009). ADR-0015/BC-3.2.013 added *proactive* interception: `handle_move` (single-key) calls `get_transitions_with_fields` and intercepts BEFORE the POST → exit 64. The POST-400 fixture no longer drives the assertion; stderr substrings (`--resolution`, `jr issue resolutions`) still pass but via a different path. | Re-point to BC-3.2.013 (proactive, single-key, exit 64 pre-POST); retain BC-3.2.009 as a documented reactive-fallback variant. Update "Why hidden" to note interception precedes the POST. Tracks STATE.md `MAINT-HOLDOUT-H007-DRIFT`. |
| H-027 | **STALE (narrative)** | `**Status**` already says S-3.07 added the MAX_RETRY_AFTER_SECS=60 cap (shipped), but `**BC refs**` still frames BC-X.4.009 as a "future MUST-FAIL when … cap is implemented — flip assertion". The cap shipped; the "future flip" prose describes a past event as pending. Tests pass; only the narrative is self-contradictory. | Collapse BC-X.4.002/BC-X.4.009 "future flip" prose into a single post-S-3.07 statement (cap shipped, abort-signal honored). Prose-only; low severity. |
| H-044 | **FRESH** (was stale-candidate) | Verified `src/adf.rs:~2300-2318`: ADF inline `mention` falls through to `_` and is dropped silently (no `content` to recurse into); documented "Not implemented in v0.5; tracked under #202." Post-2026-05-20 ADF commits (#470/#471/#473/#474/#481/#487/#489/#492/#522) are all markdown→ADF / ADF→text additions — none changed mention rendering. The "Mention node silently dropped (current behavior)" parenthetical is **still accurate**. | No action. Core assertion (heading+paragraph render, no panic) more robust than ever. |

## CLI Surface Cross-Check (Question 1)

Every subcommand path referenced by the 57 scenarios is present on `develop` @ 71f33c6 (`auth`, `issue`, `assets`, `sprint`, `worklog`, `team`, `user`, `requesttype`, `api`, `me`, `project`, `board`, `init`, `queue`, `completion`). All per-group flags verified present EXCEPT one:

- **`issue create --story-points` is GONE** — replaced by `--points`. This is the single hard CLI-surface drift (H-NEW-MP-001 above). The prior run's surface table listed it as "`--story-points/--points`" but the `--story-points` long form no longer parses on the built binary. Confirmed by probe: `jr issue create … --story-points 5 …` → `error: unexpected argument '--story-points' found` (clap); `--points 5` reaches the field-config check.
- All other flags PASS: `issue move --resolution/--no-resolution/--to`, `issue open --url-only`, `issue remote-link --url/--title`, `issue create --request-type/--type/--field/--markdown/--description-stdin/--points`, `assets schema --schema`, `assets tickets --status/--open`, `sprint add/remove --sprint`, global `--verbose/--verbose-bodies`.

## Behavioral-Drift Assessment (Question 2)

- **ADR-0015 proactive resolution enforcement** → drives H-007 staleness (above). Confirmed shipped: `docs/adr/0015-proactive-resolution-enforcement.md` + `tests/issue_move_resolution_enforce.rs`. H-006 (idempotent already-in-target move) UNAFFECTED — proactive guard only fires on done-category transitions requiring a resolution; already-in-target short-circuits earlier. FRESH.
- **v0.6 verbose split (SD-003)** → H-NEW-VERBOSE-001/002 already encode header-only `--verbose` + PII-warning `--verbose-bodies`; live `--help` matches. FRESH, no action.
- **S-3.07 rate-limit cap** → drives H-027 narrative staleness (above); `tests/rate_limit_cap_tests.rs` + `tests/rate_limit_cap_ac003.rs` confirmed present.
- **post-2026-05-20 ADF passes** → do NOT affect H-044's mention assertion (confirmed FRESH).

## MUST-FIX Closure Status (Question 3 — narrative staleness)

All four MUST-FIX holdouts have SHIPPED on `develop` (test files confirmed):

| Holdout | Test evidence | Narrative status |
|---------|--------------|------------------|
| H-036 (multi-workspace composite key) | `tests/issue_list_assets.rs` (BC-4.3.001) | "Current code fails this holdout" now historically inaccurate |
| H-045 (worklog pagination) | `tests/worklog_commands.rs` | "Current code fails … returns 50" now historically inaccurate |
| H-046 (issue open instance-url) | `tests/issue_open.rs::test_bc_3_4_001_oauth_uses_instance_url` | "Current code fails … for OAuth profiles" now historically inaccurate |
| H-NEW-MP-001 (multi-profile fields) | `tests/multi_profile_fields.rs` | "Current code fails … reads config.global.fields" now historically inaccurate **PLUS hard `--story-points` flag drift (above)** |

**Recommendation**: convert the four MUST-FIX `**Status**` lines from present-tense "Current code fails" to past-tense closure notes when convenient (soft, not a freshness gate). For H-NEW-MP-001, fix the `--story-points`→`--points` flag in the SAME edit (hard fix).

## Additional Observations (non-blocking)

- **H-018 gap intentional** — suite jumps H-017→H-019; H-018 retired in S-3.10 (client-side `parse_duration` calculator). `total_holdouts: 57` already excludes it. No action (carry-forward from prior Issue D).
- **No `lifecycle_status` field** — holdout file has 0 occurrences; adopting it for stale candidates is itself a schema recommendation (carry-forward from prior Issue F). Until adopted, staleness is tracked here + in STATE.md only.

## Top Issues (ranked)

1. **H-NEW-MP-001 — `--story-points` flag removed (HARD functional drift, NEW this run).** Literal action no longer parses; evaluator fails on clap error not the assertion. **Highest priority — fix `--story-points`→`--points`.**
2. **H-007 — resolution-enforcement mechanism drift (ADR-0015).** Reactive POST-400 fixture superseded by proactive pre-POST interception. Substring outcome survives; mechanism stale. **Re-point to BC-3.2.013.** Tracks STATE.md `MAINT-HOLDOUT-H007-DRIFT`.
3. **H-027 — internal MUST-PASS-vs-future-MUST-FAIL contradiction.** MAX_RETRY_AFTER_SECS=60 cap shipped; "future flip" prose stale. **Prose revision.**
4. **H-036/H-045/H-046 + H-NEW-MP-001 — MUST-FIX narrative.** "Current code fails" now historical (all shipped). **Soft cleanup.**

**Batch recommendation**: H-007, H-027, and H-NEW-MP-001 are the three substantive items; bundle them (matches STATE.md "Batch with H-027/H-044" note — H-044 now downgraded to FRESH, so the batch is H-007 + H-027 + the NEW H-NEW-MP-001 flag fix). All other 53 scenarios are FRESH.
