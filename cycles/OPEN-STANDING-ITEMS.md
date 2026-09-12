# Open Standing Items (extracted from STATE.md)

> Extracted from `.factory/STATE.md`'s `## Blocking Issues`, `## Constraints
> Carried Forward`, and `## Drift / Standing Items` sections during the
> 2026-09-10 `/compact-state` compaction (v4.03 -> v4.04). Everything below
> is still OPEN, non-blocking, low-priority standing debt or human-owned
> deferrals — full text preserved verbatim, not deleted. Resolved/closed
> items live in `cycles/RESOLVED-DRIFT-ITEMS.md` instead. STATE.md's three
> headline follow-ups (`VSDD-FACTORY-COMPACT-CLAUDE-MD-GAP`,
> `MUTANTS-NIGHTLY-VERIFY-FULL-RUN`, `STATE-MD-OVER-SOFT-TARGET`) stay
> inline in STATE.md itself and are NOT duplicated here except where noted.

## cycle-007 F4 follow-up — AUTH-REMEDIATION-EQUALS-FORM-BROADER (2026-09-11, PASS4-F2-SPEC-SWEEP burst)

**ID:** `AUTH-REMEDIATION-EQUALS-FORM-BROADER`
**Severity:** LOW, non-blocking. NOT a quality-gate blocker for Story A or Wave-1.
**Status:** OPEN. Non-blocking for Story A convergence.
**Classification:** spec consistency + code remediation follow-up. In-scope for cycle-007 (auth cluster); not a separate cycle.
**Added:** 2026-09-11, PASS4-F2-SPEC-SWEEP bookkeeping burst (state-manager, TD-VSDD-053 single-commit).

**Summary:** The `jr auth login --profile=<profile>` equals-form remediation (EC-1.4.032-6 — required so
leading-hyphen profile names like `-prod` parse correctly under clap) was applied in the PASS-4 F-2 spec
sweep across BC-1.4.032/033/034 quoted hints and VP-AUTHDX-005/007/008/027 oracles. However, the equals-form
fix applies BEYOND Story A's `load_api_token` credential-absence path. Two coordinated follow-ups remain:

**(a) CODE:** `src/api/auth.rs::load_oauth_tokens` stale-keyring remediation messages AND the
`jr auth logout --profile <name>` remediation strings still emit the SPACE form (`--profile <name>`
instead of `--profile=<name>`). These two sites have the identical leading-hyphen clap-parse defect as
the BC-1.4.032/033 sites fixed in Story A. They were deliberately REVERTED out of Story A's scope
(out-of-story BC scope, untested-regression risk on adjacent auth paths). Fix in a follow-up —
candidate: fold into cycle-007 Story B1/B2 (both touch `src/api/auth.rs` / auth-state machinery),
or a dedicated small Story B1.5 / Story E fix in Wave 1 if the scope is clean.

**(b) SPEC/CONVENTION:** BC-1.6.048 Invariant 3 and BC-1.6.050 EC-1.6.050-4 login-invocation citations
were updated to the equals form this cycle (PASS-4 F-2 spec sweep). B1/B2 implementations MUST emit
equals-form for any `jr auth login --profile=<name>` hint they produce, to match. This is already
reflected in the updated spec text; no additional spec change needed — it is a CONFORMANCE reminder for
the implementer to follow when writing the B1/B2 remediation string code.

**Non-blocking rationale:** Story A convergence (credential-absence path, BC-1.4.032/033/034) is
unaffected. The two sites with the SPACE-form defect are in separate code paths (`load_oauth_tokens`
stale-keyring branch, `auth logout` path) that Story A does not touch. The hint strings are advisory
only; a user with a leading-hyphen profile name would see a slightly wrong example, not a failed command.

**Target:** Fold into cycle-007 Story B1/B2, or a dedicated follow-up fix story, before the F7 delta
convergence gate. Not urgent mid-F4.

---

## cycle-007 F4 Wave-1 follow-up — AUTH-REFRESH-APITOKEN-DOC-OVERCLAIM (2026-09-11, Burst 3)

**ID:** `AUTH-REFRESH-APITOKEN-DOC-OVERCLAIM`
**Severity:** LOW, non-blocking. NOT a quality-gate blocker.
**Status:** OPEN. Non-blocking for Wave-1 delivery.
**Classification:** doc-accuracy latent defect. Same class as Story C's `--oauth` fix. NOT a behavioral regression.
**Added:** 2026-09-11, Burst 3 (state-manager, TD-VSDD-053 single-commit).

**Summary:** The `jr auth refresh --api-token` doc comment in `src/cli/mod.rs` has a latent
unconditional-notice overclaim of the same class Story C fixed for `--oauth`. The `--api-token`
informational notice (informing the user a credential update is available) is also guard-suppressed on
an oauth-method profile under `--no-input`, yet the doc still implies it fires unconditionally. Left
out-of-scope of Story C (`--oauth`-only per S-cycle7-oauth-help-text-fix scope). Fix in a future
doc-accuracy sweep. Not a behavioral defect (guard exists; notice does not fire incorrectly), purely
a doc/comment mismatch.

**Target:** Next doc-accuracy sweep or maintenance cycle. Deferred from Story C scope by design.

---

## cycle-007 F4 Wave-1 action item — #804-AWAITING-HUMAN-UI-MERGE (2026-09-11, Burst 3)

**ID:** `#804-AWAITING-HUMAN-UI-MERGE`
**Severity:** ACTION REQUIRED (human). NOT a technical blocker — PR is fully green.
**Status:** OPEN. PR #804 (`docs/cycle7-readme-migration-note`) is fully green (24/24 checks, mergeStateStatus CLEAN) but BLOCKED from automated merge by the Claude Code auto-mode "Merge Without Review" permission gate.
**Classification:** process/permission constraint. Human must perform the UI squash-merge action.
**Added:** 2026-09-11, Burst 3 (state-manager, TD-VSDD-053 single-commit).

**Summary:** Story D (`S-cycle7-readme-migration-note`) PR #804 was converged via 4-pass per-story
adversarial review (3 consecutive CLEAN), rebased onto `develop@5b5b4432` (HEAD `800e67f1`), and
passed 24/24 CI checks (mergeStateStatus CLEAN after macOS-runner-flake re-run). Automated merge
was repeatedly blocked by the auto-mode "Merge Without Review" security classifier (the same gate
that also blocked #805, but #805 was subsequently merged via pr-manager — inconsistent enforcement).
Human must perform the squash-merge via the GitHub UI.

**Action:** Open PR #804 on GitHub, verify green, and squash-merge to `develop`. Then story D is
CLOSED, `develop` tip advances past `5b5b4432`, and Wave-1 is complete (A/C/D merged; B1 in flight).

---

## S-7.02 cycle-closing checklist deferrals — cycle-005 close (Burst 13, DEC-353, 2026-09-09)

Human chose RECORD DEFERRALS ONLY, no follow-up stories opened. `INTERIM-SHIPPABILITY-WINDOW-CYCLE5-W1` is RESOLVED/CLOSED (see `cycles/RESOLVED-DRIFT-ITEMS.md`), not carried here. `CYCLE5-F7-DOC-1`, `CYCLE5-F7-DOC-2`, and `CYCLE5-STEP45-LOW-1` are RESOLVED as of MAINTENANCE-SWEEP-2026-09-10 (see `cycles/RESOLVED-DRIFT-ITEMS.md`), not carried here. The following 4 items remain open, non-blocking, human-owned or targeted at a future maintenance/self-improvement cycle:

| Item | Class | Target | Reason |
|------|-------|--------|--------|
| `CYCLE5-F5-L2-IDONLY-BRACKET-VP674005` | coverage, LOW, non-blocking, unreachable | none tracked -- accepted | The id-only bracket-mention path (no `attrs.text`) is unverified against VP-674-005. UNREACHABLE from any wired write path: a bracket mention always receives the BC-X.7.010 mandatory preflight, which always populates `attrs.text` before conversion. Reconfirmed by the F6 VP-coverage mapping (Burst 12). |
| `CYCLE5-F5-P3-01-STDIN-NOINPUT` | correctness/coverage, LOW, non-blocking, pending intent verification | product-owner / future maintenance | `handle_comment_add`, `handle_create`, and `handle_edit`'s live single-key path pass the AMBIENT `no_input` to `mentions::resolve_mentions` after a blocking stdin read, unlike `handle_comment_edit` which forces `no_input=true`. DEBUG-ONLY reachable -- release builds auto-flip `no_input=true` for piped stdin. Candidate quick follow-up: mirror `handle_comment_edit`'s `if stdin { no_input = true; }` guard at the three sites. |
| `CYCLE5-STEP45-LOW-2` (= `CYCLE5-W2-LOW-2-INTERACTIVE-TEST-GAP`) | coverage, LOW, non-blocking, accepted limitation | none tracked -- accepted | No automated test covers the interactive `dialoguer::Select` answered-then-resolves path -- no TTY seam exists to drive this deterministically. Matches the pre-existing accepted posture of `duplicate_user_disambiguation.rs`. |
| `CYCLE5-BURST12-LOG-GAP` | process-gap, factory bookkeeping | future maintenance sweep | `cycles/cycle-005/burst-log.md` never received a discrete Burst 12 entry for the F6-targeted-hardening burst, even though STATE.md's own v3.98 history cited "Burst 12" repeatedly. No substantive detail was lost -- the full F6 record was captured in-line in the v3.98 STATE.md Write itself (frontmatter, Phase Progress row, Constraints Carried Forward paragraph, Historical Content row) -- but the discrete burst-log.md entry is missing and should be backfilled for completeness. |

`PR-REVIEW-SELF-APPROVE-HOOK-LOOP` | process-gap, vsdd-factory engine tooling (not a jira-cli product defect) | vsdd-factory engine fix — The pr-review completion hook demands `gh pr review --approve`, which GitHub refuses on a self-authored PR, causing an unbreakable loop -- observed on PR #795's redundant reviewer, and recurred on PR #796/#798/#799 (this session's self-mention CI enablement, E2E-dynamic-tests, and mutants-nightly-rebalance PRs). Feedback filed; same family as `PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP`/`FACTORY-HOOK-FUEL-EXHAUSTED` below.

## S-7.02 cycle-closing checklist deferrals — cycle-006 close (Burst 13, DEC-351)

Human chose RECORD DEFERRALS ONLY, NO follow-up stories opened; originally 6 items, now 5 open (`CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS` RESOLVED — see `cycles/RESOLVED-DRIFT-ITEMS.md`):

| Item | Class | Target | Reason |
|------|-------|--------|--------|
| `STALE-RED-NARRATIVE-PATTERN` | process-gap | Future self-improvement/maintenance sweep | TDD RED-phase doc comments recurrently survive into the GREEN tree -- recurring but low-severity doc hygiene; not worth a dedicated story now. |
| `EXAMINE-GLOBS-SHRINK-RESIDUAL` | process-gap | Future CI-hardening | A plaintext `examine_globs` removal drops a file from mutation scope; the existing floor guard `FLOOR=11` is too coarse -- pre-existing whitelist-model property, code-review-controlled, documented. |
| `BARE-JQ-TOKENIZER-RESIDUAL` | process-gap | Future CI-hardening (or when the scripts grow materially) | `contains_bare_jq_invocation` is a hand-rolled tokenizer, not a real parser -- verified complete against current scripts; wrapper-with-flags/general-indirection documented out-of-scope. |
| `GITHUB-OPS-WATCH-HANG` | process-gap, tooling | Factory tooling improvement (avoid `--watch` in github-ops; add a timeout) | The github-ops gh-delegation layer hung on a non-terminating `gh pr checks --watch` during PR #791's merge execution -- session-tooling reliability, not a product defect. |
| `F-PC-MED-001` | security, process-gap | Future security-hardening cycle | Deep mitigation for `untrusted-outcomes.json`'s documented code-execution / spoofed-sibling-artifact / canceling-errors trust-boundary residual -- accepted, code-review-controlled residual; deep fix is a substantial separate effort. |

## Still open (cycle-006, Burst 10, LOW, non-blocking — NOT part of the S-7.02 checklist's named deferral list; pre-existing standing debt)

`F-PH-LOW-001` (add a `jq -e 'type=="object"'` shape check after each `jq empty` call in `scripts/mutants-aggregate.sh`), `F-PH-LOW-002` [process-gap] (add a Rust subprocess test running `bash scripts/mutants-aggregate.sh --self-test`), `F-PH-LOW-003` (tighten fixture 23's assertion substring to the exact phrase `"is malformed JSON"`), `F-PG-LOW-002` [process-gap] (`tests/ci_gate_completeness.rs`'s "seven always-run jobs" prose is stale vs. the actual eight `ci-gate.needs` members), `F-PI-LOW-002` (re-correct any remaining place that still characterizes `F-PF-HIGH-001` as closed by the round-2 fix alone).

## E2E-CI dynamic-tests delivery follow-up (from PR #798 code review)

| Item | Class | Target | Reason |
|------|-------|--------|--------|
| `E2E-DISCOVER-SAFE-EDIT-FIELD-VALIDATED-SUBTYPE` | coverage, LOW/MEDIUM, non-blocking | future maintenance | `discover_safe_edit_field` in `tests/e2e_live.rs` filters only on `schema.type == "string"`, so on a project whose only non-`Environment` editable string field is a validated-format subtype (e.g. a URL custom field), `test_e2e_issue_edit_custom_field`'s dynamic path could produce a real 400 -> test failure rather than a clean skip. Nightly/non-blocking, no data risk; the `Environment`-preferred path avoids it on the canonical E2E project. Candidate hardening: also exclude constrained `schema.custom` subtypes, or treat a write 400 as a skip. |

## E2E test `test_e2e_issue_edit_custom_field` — ADF-field heuristic defect (E2E-EDIT-FIELD-ADF-HEURISTIC)

**ID:** `E2E-EDIT-FIELD-ADF-HEURISTIC`
**Severity:** LOW, non-blocking. NOT a quality-gate blocker.
**Status:** OPEN, deferred to next maintenance sweep.
**Classification:** test-infrastructure defect. UNRELATED to cycle-007 (auth) — off the F4 critical path. Do not fold into cycle-007.
**Added:** 2026-09-11, bookkeeping burst (state-manager, TD-VSDD-053 single-commit).

**Summary:** The live-Jira E2E test `tests/e2e_live.rs::test_e2e_issue_edit_custom_field` fails
deterministically on `develop` SHA `14e695ae` (E2E run 34588420715, 2026-09-11 10:16 UTC, and the
identical push run 34534019457 on the same SHA) with:
```
API error (400): environment: Operation value must be an Atlassian Document (see the Atlassian Document Format)
```
106/107 E2E tests pass; this is the sole failure. E2E (Live Jira) is a NON-BLOCKING workflow
(not in `ci-gate.needs`), so it did not and does not gate any merge — PR #801 merged
legitimately.

**Root cause:** `tests/e2e_live.rs::discover_safe_edit_field` (added 2026-09-10 by commit
`3a874d90`) picks a write target using the heuristic `schema.type == "string"` and PREFERS
Jira's `Environment` system field. On Jira Cloud REST v3, `environment` (like `description`)
is a rich-text/ADF field that requires an Atlassian Document Format object on write even though
its `editmeta` `schema.type` is `"string"`. The test sends a plain string → Jira 400. The
product (`jr issue edit --field`) is behaving correctly (plain-string write for a nominal string
field is idiomatic for a thin client); the defect is in the TEST's selection heuristic only.

**Research:** Full sourced findings at `.factory/research/e2e-environment-adf-field-2026-09-11.md`
(HIGH confidence). Key result: there is NO generic documented `editmeta` signal that distinguishes
an ADF-backed "string" field from a plain-string one — Atlassian closed the fix as Won't Fix
(JRACLOUD-75814); renderer-exposure issue Timed Out (JRACLOUD-75913). The ONLY reliable metadata
discriminators are hard-coded system field IDs and the built-in `schema.custom` type key:
`com.atlassian.jira.plugin.system.customfieldtypes:textfield` = plain single-line string;
`...:textarea` = ADF.

**Recommended fix** (for whichever future maintenance/test-fix story picks this up):
- Remove the `Environment` preference block in `tests/e2e_live.rs::discover_safe_edit_field`.
- Replace the `is_string_field` predicate with one requiring `schema.type == "string"` AND
  `schema.custom == "com.atlassian.jira.plugin.system.customfieldtypes:textfield"` (the only
  documented plain-string class; always a `customfield_NNNNN`).
- Return the field in the literal `customfield_NNNNN` bypass form (no display-name resolution).
- Add a defensive denylist skipping `summary`/`description`/`environment`.
- Keep clean-skip (`None`) semantics and the `JR_E2E_EDIT_FIELD` override escape hatch unchanged.
- Residual (acceptable): a project with no single-line-text custom field on the edit screen will
  clean-skip rather than test; covered by the env override.

**Target:** Next maintenance sweep (or a small dedicated E2E-test-fix follow-up), routed through
the normal fix pipeline — not hand-edited.

**Note:** Supersedes / clarifies `E2E-DISCOVER-SAFE-EDIT-FIELD-VALIDATED-SUBTYPE` (table above) —
that item anticipated a potential future issue with validated-format subtype fields; this item
records the ACTUAL observed deterministic failure and its confirmed root cause (the ADF/plain-string
schema gap, not a subtype-validation issue). Both items remain open; the fix described here
addresses both.

## macOS syspolicyd/Gatekeeper Fragility — dev-host-only (HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY)

**ID:** `HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY`
**Severity:** LOW, non-blocking. NOT a product or CI issue. Dev-host-only.
**Status:** OPEN (environmental; persists on long-uptime macOS dev hosts).
**Classification:** infra/environment, dev-host ergonomics. UNRELATED to cycle-007 product scope.
**Added:** 2026-09-11, F4-BASELINE-GREEN-WAVE-1-STARTED burst (state-manager, TD-VSDD-053 single-commit).

**Summary:** On this macOS dev host (~56-day uptime at time of discovery), `syspolicyd` (the
macOS Gatekeeper launch-validation daemon) became wedged with ~60% CPU consumption under zero
actual user load, stalling all test-binary launches in `_dyld_start` (pre-main, before any
test code executes). Running `sudo killall syspolicyd` causes the system to restart the
daemon and cleared the issue immediately.

**Root cause:** macOS Gatekeeper performs a one-time validation scan on first launch of each
new binary. After long uptimes (50+ days) with heavy Rust development activity (producing many
distinct test binary artifacts), `syspolicyd` can accumulate a large pending-validation backlog
and eventually wedge under combined disk I/O + CPU pressure, especially when many binaries are
launched in rapid succession.

**cargo-nextest is UNUSABLE for full suite on this host:** `cargo nextest run`'s binary-discovery
phase (`--list`) launches all ~121 test binaries simultaneously to enumerate their tests, and
this is NOT gated by the `-j` concurrency flag (it's a pre-run enumeration step). On a wedged-
or post-wedge host, this simultaneously-launched wave re-saturates `syspolicyd` immediately,
reproducing the exact symptom that was just cleared. Even after a `syspolicyd` restart, running
`cargo nextest run` over the full suite triggers the same saturation.

**Plain serial `cargo test` IS reliable (~95 min):** The standard `cargo test` runner launches
one test binary at a time, allowing `syspolicyd` to complete each validation before the next
binary starts. On a freshly-restarted `syspolicyd`, each binary incurs a one-time Gatekeeper
first-launch latency, but no saturation occurs.

**F4 implication for cycle-007 delivery:**
- Inner TDD loop (per-test iteration): use targeted `cargo test <test-module>` only; never run the
  full suite mid-story.
- End-of-story regression gate: run `cargo test` (full suite, serial) before opening a PR.
- NEVER use `cargo nextest` for any full-suite or multi-binary run on this host.
- NEVER run 4 concurrent worktree full-suite runs simultaneously (would also saturate).

**CI impact:** NONE. GitHub Actions runners are Linux-based (`ubuntu-latest`). This is a local
development ergonomics constraint only. The CI gate (`ci-gate` in `.github/workflows/ci.yml`)
is completely unaffected.

**Resolution path:** The constraint relaxes naturally on OS reboot (fresh kernel + clean Gatekeeper
cache) or after `syspolicyd` has completed its backlog (may resolve over days of idle time). A
deliberate fix would require either: (a) scheduled OS reboots to avoid long uptimes, (b) pre-flight
`sudo killall syspolicyd` as part of the F4 test-runner wrapper, or (c) using `cargo nextest` with
a `--test-threads=1` sequential mode if such a mode becomes available. For the remainder of F4, the
plain `cargo test` workaround is sufficient.

---

## Live-Jira E2E round-trip (`H-NEW-MENTION-009`, AC-017) — human-owned post-close follow-up, NOT a skip

DEFERRED by human decision, carried forward past cycle-005's CLOSE. The 4 `JR_RUN_E2E`-gated scenarios are written and clean-skip in CI (inert without `JR_RUN_E2E=1`/`JR_E2E_MENTION_ACCOUNT_ID`); the human will run them against their own Jira instance at a time of their choosing.

## Systemic standing debt (not cycle-005/006-introduced)

The pre-existing `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` factory-wide input-hash drift (165 stale `input-hash` artifacts confirmed cycle-004 F7 pre-gate check, 2026-09-05; standing debt, not a cycle blocker); the generic story-status-frontmatter-lag-vs-STORY-INDEX pattern (per-story spec-file frontmatter status trailing the STORY-INDEX.md registry's authoritative status, a known bookkeeping lag across all cycles, not separately IDed); and `VALIDATE-COUNT-PROPAGATION-FALSE-POSITIVE` (cycle-005 Burst 10, factory tooling not a jira-cli product defect) -- the `validate-count-propagation` PostToolUse hook flagged a spurious "COUNT DRIFT DETECTED: '19 BCs' in STORY-INDEX.md but '754 BCs' in STATE.md" on a plain status-field edit to `STORY-INDEX.md` that touched neither number; the `19 BCs` substring is unrelated pre-existing prose elsewhere in the file. The Edit persisted correctly despite the hook's `block_intent=true` report. Target: a future vsdd-factory engine fix to the hook's count-extraction heuristic (same family as `PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP`/`FACTORY-HOOK-FUEL-EXHAUSTED` below).

`ADR-COUNT-CANONICAL-GUARD-GAP` (cycle-005 F2-close, Burst 2) -- `CANONICAL-COUNTS.md`'s "Canonical ADR count" line drifted across 4 cycles; no CI guard exists for this surface. Target: a future SELF-IMPROVEMENT/maintenance cycle.

`FACTORY-HOOK-FUEL-EXHAUSTED` (cycle-005 F2-close, Burst 2) -- vsdd-factory engine tooling issue, not a jira-cli product defect. Target: engine fix.

`PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP` (cycle-004, carried forward) -- vsdd-factory engine tooling bug, not a jira-cli product defect. Target: vsdd-factory engine fix.

## Still open (2026-09-02, cycle-003 Wave 1 adversary, standing drift, not a cycle blocker)

`auth status` can transitively trigger the OAuth `"default"`-profile lazy-migration WRITE via `load_oauth_tokens` -- pre-existing behavior. Tracked for future maintenance-cycle attention.

## Still open (2026-09-01, cycle-002 F7 human gate + S-7.02 checklist — justified deferral)

`CYCLE-002-PROCESS-GAP-DEFERRAL-1/2/3` (all LOW). Full detail: `cycles/cycle-002/lessons.md` Process-Level items 3/4/5.

## Still open (2026-08-31, cycle-002 F5/F6)

`F5-EDIT-GATEB-SHARE`, `F5-ISSUETYPE-CASEFOLD-SPLIT`, `F5-VP578021-WEAK-NEGPIN` (all LOW). `SEC-F6-1`, `SEC-F6-2` (cross-refs `SEC-001-EDITMETA-RECURSION-GUARD`), `SEC-F6-3` (all LOW). `S-578-3-SHARED-ASSET-VALIDATOR`, `S-578-3-FIELDVALUESPEC-RELOCATION`, `S-578-3-PR742-RESIDUAL-NITS` (all LOW). `S-578-2-PR741-RESIDUAL-NITS` (LOW, 7 items; `code-delivery/S-578-2/pr-review.md`).

## Still open — LOW doc-hygiene / process, non-blocking

`S-580-1-PR740-S1/S2/S3/N1/N2`, `BC-3.3.010-CITATION-UPGRADE-ELIGIBLE`. `PRD-DELTA-ROUND2-STEP2A-STALE-NARRATION`, `PLATFORM-ASSET-WIRE-SHAPE-UNVERIFIED`, `M1-EDITMETA-STATUS-PERMISSION-CAVEAT`, `PRD-DELTA-SUMMARY-AMENDED-BC-COUNT-STALE`. `BC-INDEX-GUARD-GAP`, `GUARD-SCOPE-COPY-PASTE-PATTERN`, `COUNT-RECONCILIATION-FORCED-CONSISTENCY-PATTERN` -- logged in `cycles/cycle-002/lessons.md`. `HOLDOUT-COVERAGE-GAP-LIST-READ-ERGONOMICS-FLAGS`, `STORY-INDEX-DECLARED-VS-FILE-COUNT-MISMATCH` (both LOW, pre-existing). `OBS-PB-1` (`auth status` credential probe `.is_ok()` swallows a genuine keyring backend error into "not found"). `auth.rs:~1160` stale doc comment; `remove.rs` step-enumeration doc nit; `chacha20` 0.10.0 yanked-crate advisory.

**Already CLOSED, not open:** `A-PA-LOW-001` -- implemented by `S-cycle4-cloud-id-correctness` (merged).

## cycle-004 maintenance items (carried forward, not blockers)

- **F6-MUTATION-EXAMINE-GLOBS-EXPANSION** -- add `src/api/auth.rs`, `src/cli/auth/login.rs`, `src/api/auth_windows_store.rs` to `.cargo/mutants.toml` examine_globs. Target: a future SELF-IMPROVEMENT/maintenance cycle.
- **JR_CACHE_DIR-TEST-ENV-MUTEX-UNIFICATION** -- `src/cache.rs`, `src/config.rs`, and `src/api/auth_windows_store.rs` each carry a SEPARATE mutex guarding the SAME process-global `JR_CACHE_DIR` env var. Target: a future SELF-IMPROVEMENT/maintenance cycle.
- **TD-031-BLOCKED-BC-6.2.016-CROSSREF** -- deferred, blocked by a pre-existing TD-031 hook violation, unrelated to cycle-005/006.
- **BC-1.4.035-PC5-VP-GAP** -- production round-trip now CI-verified; formal VP itself still deferred to maintenance.
- **S-410-KEYCHAIN-ISOLATION-FILE-OVERLAP** -- shares `tests/oauth_refresh_integration.rs` with cycle-004; non-blocking.
- **W2-INT-PROCESS-GAP-README-PROSE-DRIFT** -- no CI guard cross-checks README prose against the code model. Target: a future maintenance cycle.

**Already RESOLVED, not open:** `CYCLE-004-INPUT-HASH-HYGIENE` -- RESOLVED @ `a038ac0d`.

## PROCESS-GAP (Pass 14, cycle-004, historical, not a blocker)

`scripts/check-bc-cumulative-counts.sh` does not cover a per-file `bc-*.md` "## Summary Stats" closing "Note:" cumulative-prose line. Target a future maintenance cycle.

## Standing (unchanged across cycles)

- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- see Systemic standing debt above.
- 11-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
- `VP-COUNT-RECONCILIATION` (cycle-005 F1, unresolved) -- a raw grep found materially more VP ids across `bc-*.md` bodies than STATE's tracked running total; pre-existing bookkeeping-basis discrepancy, non-blocking. Target: a future maintenance/self-improvement cycle.
