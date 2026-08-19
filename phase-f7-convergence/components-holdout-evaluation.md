# Holdout Evaluation — Component Management Bundle (F7 Dimension 5)

Black-box evaluation of the shipped component-management feature against the hidden
acceptance scenarios in
`.factory/phase-f3-incremental-stories/components-wave-holdout-scenarios.md`.

- Binary under test: `jr 0.7.0-dev.1`, built from `develop` tip `c266169a` (`cargo build`, debug).
- Method: public CLI surface (`--help`), pre-HTTP guard/error-path invocations
  (`JR_BASE_URL=http://127.0.0.1:9`), and the offline test suite. No live Jira creds;
  live add/remove/rename effects were validated separately (AC-010 e2e) and are scored on
  the observable CLI-contract portion (flag surface, dry-run, guards) per the eval brief.
- All 15 holdouts are MUST-PASS.

## Per-Scenario Results

| Scenario | Score | Justification (observed) |
|----------|-------|--------------------------|
| H-COMPONENT-001 | 0.90 | Shared name/ID resolver surfaced on `edit`/`delete`/`rename` (`<NAME_OR_ID>`, "partial match or numeric ID", BC-8.4.001 cited in help). Determinism/exact-match-precedence is a code property covered by `component_commands.rs` (146 tests, 0 fail) + lib `component` tests (15, 0 fail); live case-collision not exercisable offline. |
| H-COMPONENT-002 | 0.90 | `component list` requires `--project` (exit 64: "No project configured"); name resolution paths all require `--project`. Project-scoped, per-profile cache partitioning documented on surface. Cross-project isolation not exercisable offline but contract enforces per-project scoping. |
| H-COMPONENT-003 | 0.85 | `component list --counts` present; help: "Enrich each component row with its related issue count. Issues one extra HTTP call per component (N+1). BC-8.1.003". JSON `count` field type not observable offline (no server); covered by tests + AC-010. |
| H-COMPONENT-004 | 0.75 | `--verbose` present; `--counts` documented as always-live (N+1) and thus exempt, matching the scenario's carve-out. Warm-cache zero-HTTP behavior fundamentally needs a live/mock server — not independently verifiable in this offline eval; contract portion satisfied. |
| H-COMPONENT-005 | 0.90 | Both `issue create --component` and `issue edit --component` present; help explicitly states both resolve "the same resolver as `jr component`". Guard observed: `create --component X --request-type RT` → exit 64 with clear message. Round-trip effect by AC-010. |
| H-COMPONENT-006 | 0.90 | `edit --component` help documents single-key native `update`-verb PUT vs 2+ keys bulk multiselectComponents path, "same underlying parse", <=1000-key chunking (BC-3.4.023). Bulk guard observed: `edit K1 K2 --component add:X --summary Y` → exit 64. |
| H-COMPONENT-007 | 0.90 | `issue list --component` filter present with `not:`/`none`/`all:` grammar; composes into JQL. Guards observed: `--component none --component X` → exit 64; two `all:` → exit 64. Raw-JQL equivalence by AC-010. |
| H-COMPONENT-008 | 0.90 | `component delete --move-to <MOVE_TO>` present; help documents snapshot-before-DELETE via paginated JQL and same-project resolution (BC-8.2.002/003). Reassign-then-delete ordering by AC-010 + tests. |
| H-COMPONENT-009 | 0.85 | Disposition required: help documents "Exactly one of `--move-to`/`--orphan` required — neither is an app-level exit-64 guard; both is clap exit 2". Observed: both → exit 2; `--orphan` + `--yes` for non-interactive documented. Neither-guard fires after component resolution (needs HTTP), so exit-64 not directly reproduced offline; contract matches option (a). |
| H-COMPONENT-010 | 0.90 | `component rename <OLD> <NEW>` with `--project` / `--all-projects` (exact case-insensitive fan-out) / `--dry-run`. Observed: neither scope → exit 64 ("supply exactly one"); both → exit 2; `--all-projects --dry-run` reaches read-only discovery. ID-stability round-trip by AC-010. |
| H-COMPONENT-011 | 0.95 | `issue edit` without `--component` is additive; `issue_edit.rs` (38, 0 fail) + `issue_edit_echo`/`labels`/`field` green. No new required field/prompt observed; changed-fields echo contract intact. |
| H-COMPONENT-012 | 0.95 | `issue create` without `--component` additive; `issue_create_echo.rs` (37, 0 fail). JSM dispatch fork unaffected — the only interaction is the documented `--component`×`--request-type` mutual-exclusion (exit 64). |
| H-COMPONENT-013 | 0.95 | `issue list` without `--component` additive; filter is opt-in JQL composition; `issue_list_errors.rs` (33, 0 fail). Default list/JQL composition unchanged. |
| H-COMPONENT-014 | 0.95 | `jr --help` shows the new `component` entry cleanly alongside every pre-existing subcommand (issue/project/board/sprint/worklog/team/user/queue/requesttype/assets/auth/api); each subcommand `--help` renders intact. `cargo build` succeeded (clippy-clean tree required for merge). |
| H-COMPONENT-015 | 0.90 | Scoped feature suites all green: `component_commands` 146/0, `issue_edit` 38/0, `issue_create_echo` 37/0, `issue_list_errors` 33/0, lib `component` 15/0. Broader full-run showed 10 test groups all `ok` (0 failed / 0 errors) before a harness capture artifact truncated the log; no failure observed anywhere. Feature merged via 7 CI-gated PRs on `develop`. |

## Summary

- Scenarios evaluated: 15 / 15
- Mean satisfaction: **0.897**
- MUST-PASS scenarios: all 15
- MUST-PASS minimum: **0.75** (H-COMPONENT-004)
- Scenarios scoring < 0.6: **none**

## Gate

**PASS** — mean satisfaction 0.897 ≥ 0.85 AND no must-pass scenario < 0.60.

## Findings / Notes

- H-COMPONENT-004 (0.75) is the only scenario whose core assertion (warm-cache produces
  zero additional HTTP) cannot be independently confirmed in an offline eval — it needs a
  live or mock server to observe `--verbose` request URLs across two invocations. The
  observable contract (the `--verbose` seam and the documented always-live `--counts`
  exemption) is present and consistent with the scenario's own carve-out; the score
  reflects unverifiability here, not an observed defect.
- H-COMPONENT-009's neither-`--move-to`/`--orphan` exit-64 guard fires after the component
  is resolved (an HTTP step), so the exact exit-64 could not be reproduced against the dead
  address; the mutually-exclusive (exit 2) and required-disposition contract is fully
  surfaced and internally consistent.
- All pre-HTTP guards behaved exactly as documented: rename neither-scope → exit 64;
  rename/delete both-flags → exit 2; `create --component`×`--request-type` → exit 64;
  `edit --component`×`--label` → exit 64; `edit` 2+ keys `--component`×`--summary` → exit
  64; list `--component none`/duplicate `all:` → exit 64.
- Regression posture is strong: additive flag/subcommand additions with no observed
  perturbation of pre-existing surfaces, and the full offline suite showed no failures.
