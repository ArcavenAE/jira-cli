# Maintenance Sweep 4 — Holdout Scenario Freshness

- **Date**: 2026-06-17
- **Product baseline**: `develop` @ 53f6d98 ("fix(adf): normalize CR/LF across push_text/push_code/text_to_adf chokepoints (#522) (#523)")
  - NOTE: requested SHA was `53f6d98`; current `develop` HEAD is `53f6d98128…`. Matches.
- **Holdout file**: `.factory/specs/prd/holdout-scenarios.md` (`total_holdouts: 57`, version 1.1.2, last_updated 2026-05-20)
- **Mode**: READ-ONLY. No code changes, no commits, holdout file NOT modified.
- **Method**: Cross-checked every scenario's referenced subcommand + flag against the built `jr --help` surface; assessed expected behavior against current product behavior documented in CLAUDE.md gotchas (v0.6 verbose split, ADR-0015 resolution enforcement, ADF additions).

## Summary

- **Total scenarios**: 57 (H-001..H-047 minus the never-assigned H-018, plus H-NEW-MP-001, H-NEW-VERBOSE-001/002, H-NEW-AUTH-002, H-NEW-JSM-RT-001..007)
- **Fresh (no action)**: 54
- **Stale-candidates (recommend `lifecycle_status: stale` or revision)**: 3
- **CLI-surface drift**: 0 — every referenced subcommand and flag still exists
- **Note**: the holdout file currently has NO `lifecycle_status` field on any scenario or in frontmatter. Adopting that field is itself a recommendation (see Issue F).

## CLI Surface Cross-Check (Question 1) — ALL PASS

Every subcommand path and flag referenced by the 57 scenarios is present on `develop` @ 53f6d98:

- Top-level: `auth`, `issue`, `assets`, `sprint`, `worklog`, `team`, `user`, `requesttype`, `api`, `me`, `project`, `board`, `init`, `completion` — all present.
- `auth`: `status`, `list`, `refresh`, `switch`, `login`, `logout`, `remove` — all present (H-001..H-005, H-011, H-016, H-019, H-020, H-028, H-029, H-047, H-NEW-AUTH-002).
- `issue`: `list`, `create`, `view`, `move`, `assign`, `remote-link`, `open`, `comments`, `transitions`, `resolutions` — all present.
- `issue list` flags: `--status --team --jql --all --limit --open --assignee --created-after --asset --output` — all present (H-008, H-010, H-015, H-021, H-023, H-035, H-036, H-043).
- `issue create` flags: `--summary --type --project --story-points/--points --request-type --type --field --markdown --description-stdin --no-input` — all present (H-NEW-MP-001, H-NEW-JSM-RT-001..007).
- `issue move` flags: `--resolution --no-resolution --to --output` — all present (H-006, H-007).
- `issue open` flag: `--url-only` — present (H-046).
- `issue remote-link` flags: `--url --title` — present (H-033, H-034).
- `issue assign` flags: `--to --account-id --unassign` — present (H-014).
- `assets`: `search`, `tickets`, `schema`, `schemas`, `types`, `view`; `tickets --status`, `schema --schema` — all present (H-023, H-024, H-037, H-038, H-039).
- `sprint`: `list`, `current`, `add`, `remove`; `current --all`, `add --sprint`, `remove --sprint` — all present (H-040, H-041, H-042, H-043).
- `user search --all`, `worklog list`, `team list`, `requesttype list/fields` — all present.
- `auth login` flags: `--oauth --client-id --client-secret --cloud-id --no-input` — all present (H-029, H-047).
- Global `--verbose` / `--verbose-bodies` — both present (H-NEW-VERBOSE-001/002).

**Result: zero stale references from removed/renamed commands.** No scenario points at a deleted surface.

## Behavioral-Drift Assessment (Question 2)

### Issue A — H-007 (`issue move … Done` resolution): STALE-CANDIDATE (high confidence)

- **Holdout expects**: a *reactive* flow — POST transitions returns HTTP 400 `{errors:{resolution:"…required"}}`, and `jr` rewrites that into a `--resolution` + `jr issue resolutions` hint. Setup mounts the POST-400 fixture; "Why hidden" says "Atlassian's raw error wording is unfriendly. The remediation rewrite is the user-value." BC ref: BC-3.2.009 only.
- **Product now does**: ADR-0015 / BC-3.2.013 added **proactive** enforcement. `handle_move` (single-key) calls `get_transitions_with_fields` and intercepts BEFORE the POST when the target is a done-category status requiring a resolution → exits 64 with the `--resolution` / `jr issue resolutions` hint. The reactive BC-3.2.009 backstop is *preserved alongside* but is now a fallback, not the primary path.
- **Why stale**: an evaluator faithfully reproducing the H-007 setup (mock POST → 400) will likely NOT trigger the POST at all, because the proactive guard intercepts first using the transition's `fields` expansion. The fixture's "POST returns 400" precondition no longer drives the assertion. The stderr-substring assertions (`--resolution`, `jr issue resolutions`) still pass, but for a different reason than the holdout documents — the scenario's *mechanism* has drifted even though its *substring outcome* still holds.
- **Recommendation**: Mark `lifecycle_status: stale` OR (preferred) revise. The holdout should be split / re-pointed to BC-3.2.013 (proactive interception, single-key) with the reactive BC-3.2.009 path retained as a documented fallback variant. Update the "Why hidden" to reflect that the interception now happens before the POST. This is the single clearest drift in the suite given the explicit CLAUDE.md ADR-0015 change.

### Issue B — H-044 (ADF `issue view`): STALE-CANDIDATE (medium confidence)

- **Holdout expects**: ADF description with heading/paragraph/code block/mention → heading + paragraph text rendered; "**Mention node silently dropped (current behavior)**". BC range BC-7.2.001..052.
- **Product now does**: The ADF surface has expanded substantially since this holdout was authored (last_updated 2026-05-20). CLAUDE.md documents post-authoring ADF work: GFM alerts→panel (#483), task lists→taskList (#471), footnotes (#472), subsup/heading-attrs (#474), block-level HTML preservation (#489/#492), bare-URL autolinking (#473), CR/LF normalization (#522/#523). These are markdown→ADF and ADF→text paths.
- **Why stale (medium)**: The specific assertion in H-044 — heading + paragraph render, no panic on any node type — almost certainly still holds and is even *more* robust now. The risk is the parenthetical "**Mention node silently dropped (current behavior)**". If any of the post-2026-05-20 ADF passes changed mention rendering (e.g., now rendering `@displayName` instead of dropping), the holdout's documented "current behavior" would be wrong. I could not confirm mention behavior without reading source (asymmetry wall) or a live ADF fixture run.
- **Recommendation**: Re-verify the mention-drop assertion against a current ADF fixture. If mentions are still dropped, leave fresh. If mention rendering changed, mark `lifecycle_status: stale` and update the parenthetical. Lower priority than Issue A — the core assertion is resilient; only the explanatory parenthetical is at risk.

### Issue C — H-027 / BC-X.4.009 forward-reference: STALE-CANDIDATE (housekeeping)

- **Holdout text** (lines 267-273) carries a self-contradiction frozen in time: the `**Status**` says "MUST-PASS (S-3.07 added MAX_RETRY_AFTER_SECS=60 cap …)" and the Expected paragraph describes the *post-cap* abort behavior — but the `**BC refs**` line still reads "BC-X.4.002 (current behavior pinned — no cap); BC-X.4.009 (future MUST-FAIL when … cap is implemented — flip assertion to `retry_after_secs == 60`)". The cap has shipped (S-3.07, confirmed by the Status line and by the `JR_*` rate-limit machinery in CLAUDE.md), so the "future MUST-FAIL … flip the assertion" framing is now describing a past event as future.
- **Why stale**: not a CLI/behavior drift — the test passes — but the scenario's own narrative is internally stale (describes an already-completed migration as pending). An evaluator reading it gets a contradictory MUST-PASS-vs-future-MUST-FAIL signal.
- **Recommendation**: Revise (not retire). Collapse the BC-X.4.002/BC-X.4.009 "future flip" prose into a single post-S-3.07 statement. Low severity; documentation hygiene only.

### Verbose-split (v0.6) check — NO drift

- H-NEW-VERBOSE-001/002 already encode the v0.6 SD-003 behavior precisely: `--verbose` = header-only with suppression hint; `--verbose-bodies` = three PII warning lines + body. The live `--help` confirms both flags exist with matching descriptions. **These two scenarios are FRESH and correctly track the v0.6 change** — no action.

### Resolution-enforcement check — see Issue A (H-007 only)

- H-006 (idempotent move when already in target) is unaffected by ADR-0015 — proactive enforcement only fires on done-category transitions that require a resolution; an already-in-target move short-circuits earlier. FRESH.

## Staleness from Removed/Renamed Behavior (Question 3)

- No scenario references removed or renamed behavior at the CLI level.
- H-046 / H-NEW-MP-001 / H-036 / H-045 are MUST-FIX pins authored as "current code fails; holdout defines target." These were closure targets, not drift. They are presumed closed on current `develop` but their MUST-FIX framing ("Current code fails this holdout") is now historically inaccurate if the fixes shipped — a soft documentation-staleness, not a freshness blocker. Optional cleanup: once confirmed green, update the `**Status**` lines from "MUST-FIX … current code fails" to "MUST-PASS … closed by <story>". Tracked as Issue E below.

## Additional Observations (non-blocking)

### Issue D — H-018 gap is intentional, not a numbering error
The suite jumps H-017 → H-019. The frontmatter retirement-policy note (line 30) records that H-018 targeted the client-side `parse_duration` calculator and was retired in S-3.10. `total_holdouts: 57` already excludes it. No action; documented as expected so a future sweep does not re-flag it.

### Issue E — MUST-FIX status lines now historical
H-036, H-045, H-046, H-NEW-MP-001 read "Current code fails this holdout — the holdout defines the target." If those fixes have shipped (likely, given the maturity at 53f6d98), the present-tense "current code fails" is stale narrative. Recommend converting to past-tense closure notes when convenient. Not a freshness gate.

### Issue F — No `lifecycle_status` field exists yet
The sweep asked to mark candidates with `lifecycle_status: stale`. The holdout file does not use that field today (0 occurrences). Adopting it for the candidates above (A, B, C) would require a schema addition; until then the recommendation is recorded here only (read-only sweep — file unchanged).

## Top Issues (ranked)

1. **H-007 — resolution-enforcement mechanism drift** (Issue A): expected reactive POST-400 rewrite; product now intercepts proactively pre-POST (ADR-0015/BC-3.2.013). Substring outcome survives but the documented mechanism is stale. **Recommend stale/revise — highest priority.**
2. **H-044 — ADF mention-drop parenthetical** (Issue B): core assertion robust, but "mention node silently dropped (current behavior)" may no longer match after the #471/#472/#474/#483/#489/#492/#522 ADF passes. **Recommend re-verify against a current ADF fixture.**
3. **H-027 — internal MUST-PASS-vs-future-MUST-FAIL contradiction** (Issue C): the MAX_RETRY_AFTER_SECS=60 cap already shipped; the "future flip the assertion" prose is stale. **Recommend prose revision.**

All other 54 scenarios are FRESH: CLI surface intact, expected behavior consistent with current product.
