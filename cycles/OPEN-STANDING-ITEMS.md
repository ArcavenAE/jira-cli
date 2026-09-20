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

## cycle-008 RELEASE GATE — Atlassian Developer Console scope-add — RESOLVED 2026-09-18

**ID:** `CYCLE-008-CONSOLE-SCOPE-RELEASE-GATE`
**Status:** **RESOLVED 2026-09-18, operator-confirmed.** Full original item text + resolution
facts archived verbatim to `cycles/RESOLVED-DRIFT-ITEMS.md`
(§"RESOLVED — CYCLE-008-CONSOLE-SCOPE-RELEASE-GATE"); per-cycle resolution record also at
`cycles/cycle-008/blocking-issues-resolved.md`. Also updated in `.factory/STATE.md`'s
`## Blocking Issues` table (same ID) — cycle-008 now carries **ZERO** open pre-release blockers.

**Summary of resolution:** the operator confirmed on 2026-09-18 that all 8 new cycle-008 OAuth
scopes were added to the embedded `jr` OAuth app's Atlassian Developer Console registration
(`DEFAULT_OAUTH_SCOPES` now 16 total); the re-consent CHANGELOG note is delivered via PR on branch
`docs/cycle8-oauth-reconsent-changelog` (merge-ready, → `develop` `[Unreleased]`). **Recommended
pre-release verification (NOT a blocker):** a definitive `jr auth login` on an OAuth profile should
show all 16 scopes on the consent screen / succeed without `invalid_scope` — the authoritative
confirmation the Console registration took (a typo like the `.admin` in
`read:board-scope.admin:jira-software` would only surface there). No new DEC minted for this
disposition (standing-item resolution, not a pipeline ruling); see `D-371` for the cycle-008 F7
close itself.

---

## cycle-012 Phase F5 follow-ups — M-2, OBS-A, OBS-3 (2026-09-15, Burst 3)

**Status:** OPEN, all LOW, non-blocking. Surfaced by Phase F5 scoped adversarial refinement (code-reviewer
+ adversary Passes A/B/C) after Wave 2 integration; not fixed in fix PR #813 (which addressed only the
CRIT/HIGH/MED-tier Pass-1 findings OBS-1/H-1/M-1/M-3). Full F5 trajectory: `cycles/cycle-012/convergence-trajectory.md`.

**`M-2` (F5 code-review, 2026-09-14):** The `--markdown` + `--field description=` conflict predicate
(D-359's uniform-exit-64 guard) is triplicated verbatim across `src/cli/issue/create.rs`,
`src/cli/issue/edit.rs`, and `src/cli/issue/jsm_create.rs`. Extract a shared
`field_pairs_raw_key_matches` helper into `src/cli/issue/field_resolve.rs` so the three call sites share
one implementation instead of three copies that can drift independently. Deferred to a future maintenance
sweep (single-source convention); not urgent -- the three copies are currently byte-identical and each is
covered by its own command family's test suite.

**`OBS-A` (F5 adversary Pass A, 2026-09-14):** The `environment` field's `changed_fields` lowercase-key
arm (added by the OBS-1 fix in `field_resolve.rs`, PR #813) has no NON-gated CI regression test -- only
the gated live-E2E suite exercises it. This is a pre-existing Wave-1 coverage gap (the `description` arm
has a non-gated regression test, `test_obs_1`; the `environment` arm does not), not a new defect introduced
by the F5 fix. Candidate: mirror `test_obs_1` for `environment` in a non-gated wiremock/CLI test.

**`OBS-3` (F5 adversary Pass B, 2026-09-14):** EC-3.8.019-4's supersession case (`--description X --field
description=Y`, no `--markdown`, where `Y` lands in `resolved_adf_values`) has no dedicated test. The code
path is identical to the already-tested string-wrap case and ordering is not considered a viable mutation
target, so this is a coverage nit, not a correctness gap. Candidate: add a small dedicated test for
completeness in a future maintenance sweep.

**Also carried forward:** `CYCLE-012-STORY2-AC-012-OUTPUT-CHANNEL-WORDING` (L-008's AC-012 story-text
stdout/stderr wording defect -- `S-cycle12-jsm-adf-autoconvert`'s story text names stdout for the
field-conversion notice; actual/correct channel is stderr per jr's Symmetric output-channel convention;
test correctly asserts stderr) -- this item is already tracked inline in STATE.md's `## Drift / Standing
Items` (added at the Story 2 CONVERGED burst) and is NOT duplicated here; see STATE.md for current text.
Target for all four items: a future maintenance sweep, or at F7 close if still open.

---

## cycle-007 Wave-2 gate finding F-B2-01 — NFR-O-N-CATALOG-RETIREMENT-EDIT (2026-09-14)

**ID:** `NFR-O-N-CATALOG-RETIREMENT-EDIT`
**Severity:** LOW, non-blocking.
**Status:** OPEN. `nfr-catalog.md`'s NFR-O-N row still reads `DEFER-DOCUMENTED` (main table row
~line 110, Summary Table row ~line 188, `DEFER-DOCUMENTED: 4` bucket count ~line 210). NFR-O-N is
RETIRED per BC-1.6.050 Invariant 2 ("NFR-O-N is RETIRED by this BC's existence") — `CLAUDE.md` is
already correct (its `auth status --output json` gotcha entry states "NFR-O-N is RETIRED"); only
`nfr-catalog.md`'s row text is stale.

**History:** Story B2 (`S-cycle7-auth-status-json`, merged PR #807) implemented `auth status
--output json` and updated `CLAUDE.md` in the same burst, but explicitly DEFERRED the
`nfr-catalog.md` row-text edit per B2 AC-012 + BC-1.6.050's F4 doc-fallout obligation (a), because
of pre-existing TD-031 "stable-anchors hook" debt on that file — see `cycle-007-prd-delta.md` §7
for the original blocker account.

**Blocker (re-confirmed 2026-09-14, cycle-007 Wave-2 gate remediation attempt):** attempted the
row-text edit directly via the `Edit` tool; refused by the live `validate-stable-anchors`
PreToolUse hook (`hooks-registry.toml`, WASM plugin, `on_error = "block"`, scoped to
`.factory/specs/**/*.md`). The hook fail-closed-blocks **any** edit to `nfr-catalog.md` because the
file carries pre-existing `*.rs:NNN`-style volatile line citations in UNRELATED NFR rows (NFR-R-D,
NFR-R-A, NFR-R-E, NFR-R-G, and others, none touched by this change) — it does not distinguish "this
diff is clean" from "the file has debt"; the whole file is edit-locked until every pre-existing
violation is converted to a stable-symbol anchor per TD-VSDD-091. Same blocker class as
`TD-031-BLOCKED-BC-6.2.016-CROSSREF` above (cycle-004).

**Target:** maintenance sweep — bundle the actual row-text edit (Phase 3 Routing cell
`DEFER-DOCUMENTED (S-3.08 / PR #317)` → `RETIRED (BC-1.6.050)`, description's stale "no
`--output json` test coverage for `auth status`" clause removed (coverage now exists in
`tests/auth_status_json.rs`); Summary Table row status → `RETIRED`, BC column → `BC-1.6.050`;
`DEFER-DOCUMENTED: 4` → `3` with a new `RETIRED: 1` bucket added) with the TD-031 stable-anchor
remediation fix for `nfr-catalog.md` (convert its pre-existing volatile `*.rs:NNN` citations to
stable symbol anchors) — the retirement edit can land in the same or a following burst once the
file is unlocked.

**Source:** cycle-007 Wave-2 gate finding F-B2-01.

---

## cycle-007 Wave-2 gate finding OBS-C-01 — CYCLE-007-STORY-STATUS-DRAFT-POSTMERGE (2026-09-15)

**ID:** `CYCLE-007-STORY-STATUS-DRAFT-POSTMERGE`
**Severity:** LOW, non-blocking, process-gap.
**Status:** OPEN.

**Summary:** All cycle-007 F3 story frontmatter (including the merged Wave-1 stories A/C/D/B1 and
the merged Wave-2 story B2) still reads `status: draft` post-merge — the story files were never
flipped to `status: done`/`merged` after their respective PRs landed (`#803`/`#805`/`#804`/`#806`/`#807`).
This is systemic, not specific to any one story: `.factory/STATE.md`'s Phase Progress table and
`cycle_007_status` frontmatter field are the authoritative status source, so no downstream
consumer has actually been misled by the stale story-file field — but the drift itself is real.

**Candidate fix:** a status-flip sweep across all 5 story files at cycle-007's full close (F7),
setting each to its terminal status and citing the merging PR.

**Open question (also part of this item's scope):** verify whether prior CLOSED cycles
(001-006, 012) left their own story files at `status: draft` post-merge as well — i.e., whether
this is an accepted repo-wide convention (STATE.md is the single source of truth, story-frontmatter
status is decorative/not authoritative) or a genuine drift gap worth fixing everywhere. Do not
assume either answer; check a sample of closed-cycle story files before scoping the fix.

**Confirmed repeat pattern (2026-09-18, cycle-008 F7 pre-gate consistency reconcile):**
cycle-008's own `cycles/cycle-008/phase-f3-stories/S-cycle8-*.md` story files exhibit the identical
pattern — all 5 delivered/merged stories (S1 `jsm-servicedeskapi-oauth-routing`, S2
`agile-oauth-scope-gap`, S3 `assets-workspace-oauth-routing`, S4
`agile-scope-mismatch-error-mapping`, S5 `jsm-attachments-oauth-verification`) still read
`status: draft` in their own frontmatter after merge, exactly as cycle-007 did. `STORY-INDEX.md`
correctly shows all 5 as **done** (with citing PRs/SHAs) — it is the authoritative per-story
status source, consistent with `.factory/STATE.md` being authoritative at the cycle level. This is
now confirmed repo-wide convention across at least cycle-007 and cycle-008 (not yet re-checked
against 001-006/012 — that portion of the open question above remains open). No cycle-008 action
taken; record-only.

**Source:** cycle-007 Wave-2 integration gate, adversary Pass C (2026-09-15).

---

## cycle-007 Phase F5 follow-ups (2026-09-15, Burst 6)

**Status:** OPEN, all LOW, non-blocking. Surfaced by Phase F5 scoped adversarial refinement (4 rounds to
3 consecutive CLEAN), code-reviewer (`APPROVE_WITH_NITS`), and security-reviewer (CLEAN) after cycle-007's
CRIT/HIGH/MED-tier findings (CR-002/F-C007-M1, OBS-3, CR-003, F-C007-PASSC-M1, F-C007-PASSD-M1) were
resolved via PR #814 (`11c95d5e`) + commits `0b9fb1fc`/`878ebe67`. Human explicitly DEFERRED CR-001/CR-004
rather than fixing them this cycle. Full F5 trajectory: `cycles/cycle-007/burst-log.md` Burst 6.

**`CYCLE-007-CR-001-KEYCHAIN-ERROR-VS-ABSENCE` (F5 code-review CR-001/CR-004, 2026-09-14, human-deferred):**
`auth status`/`auth list` collapse a keychain-probe error into the same "no-credentials" outcome as a
genuine absence via `.is_ok()` on the consolidated `probe_matching_kind_credential` (PR #814). The
boolean/3-state status model was kept as-is per explicit human decision at F5. Follow-up: distinguish a
probe ERROR (keychain unreachable/corrupt) from a genuine credential ABSENCE — likely needs a BC change
(a 4th status value, or a `probe_error` field surfaced separately in both human-text and `--output json`).

**`CYCLE-007-PROBE-ROUTING-NO-DEFAULT-CI-TEST` (F5, 2026-09-14):** The consolidated probe's `== "oauth"`
dispatch branch (`src/api/auth.rs::probe_matching_kind_credential`, PR #814) has no default-CI behavioral
test — only a source-scan parity test (pinning the single-shared-source refactor) and keyring-gated
coverage exercise it; the branch itself is `.cargo/mutants.toml` mutation-excluded (keychain-effectful, no
injection seam). Candidate: a keyring-gated oauth-vs-api-token dispatch test, or introduce a testable seam
for the dispatch predicate.

**`CYCLE-007-LEGACY-OAUTH-UNSET-METHOD-MISREPORT` (F5, 2026-09-14):** A legacy-migrated OAuth profile with
`auth_method` unset in config routes to the api-token probe arm and can display "no-credentials" despite
having working OAuth credentials in the keychain. Display-only edge case; related to CR-001's
error-vs-absence gap above (same probe, different trigger — unset field vs. probe error).

**`CYCLE-007-OAUTH-ABSENCE-EXIT-CODE-ASYMMETRY` (F5, 2026-09-14):** OAuth credential-absence returns
exit 1 while api-token credential-absence returns exit 2 — spec-sanctioned by BC-1.4.028, with the
exit-2 reclassification deliberately scoped to api-token only by BC-1.4.032/033 (Story A). Open question
for a future spec decision: should OAuth absence also map to `NotAuthenticated`/exit 2 for symmetry? Also
note exit-2 now overlaps clap's generic usage-error exit code 2 — the two are distinguishable via stderr
text / `--output json` shape, but this overlap is worth flagging if it ever causes scripting confusion.

**`CYCLE-007-AUTH-LIST-LAZY-MIGRATION-WRITE` (F5, awareness note, 2026-09-14):** `auth list` can now
trigger a one-time, idempotent, self-healing lazy keychain-migration WRITE for a legacy-flat `"default"`
OAuth profile (same lazy-migration path documented in `src/api/auth.rs`'s module header). Bounded and
would fire on any authed command anyway — not a defect, just an awareness note that `auth list`'s
read-only-looking surface can perform a write under this one legacy-profile condition.

**`CANONICAL-COUNTS-BREAKDOWN-STALE` (LOW, pre-existing cross-cycle, OUT of cycle-007's F5 perimeter,
noted during the F5 pass):** `CANONICAL-COUNTS.md` (~lines 156-158) "Breakdown:" narrative prose says 754
BCs where it should say 769 — this narrative is an UNENFORCED surface (`check-bc-cumulative-counts.sh`
validates Surfaces A-H only, not the free-text Breakdown narrative). Candidates: a one-off narrative sweep
fixing the stale figure, plus extending the count guard to cover this surface so it can't silently drift
again.

**Minor doc-comment nitpicks (bundled, F5 code-review nits, non-blocking):** `tests/auth_status_json.rs`'s
test-map table omits the inline VP-AUTHDX-026 tests; `tests/auth_credential_absence.rs`'s header comment
references a stale "AC-010"; the keyring-gated AC-006/007/008 tests call `cargo_bin` directly instead of
going through the env-scrubbing `jr()` helper used elsewhere in the file. All cosmetic/test-hygiene only —
candidates for a future doc-sweep or maintenance pass, not correctness issues.

**Target for all items above:** a future maintenance sweep, or at cycle-007's F7 close if still open.

---

## cycle-007 Phase F6 hardening residuals (2026-09-15, Burst 7)

**Status:** OPEN, all LOW, accepted. Surfaced by Phase F6 targeted hardening
(`cycles/cycle-007/phase-f6-hardening/hardening-record.md`, commit `596ec950`); recorded into STATE.md
in Burst 7 alongside Phase F7 CONVERGED. R3 from the hardening record (OBS-PB-1) is the same substance as
`CYCLE-007-CR-001-KEYCHAIN-ERROR-VS-ABSENCE` above — not duplicated here.

**`CYCLE-007-F6-R1-KEYRING-GATED-HUMAN-TEXT-COVERAGE` (F6 residual R1, 2026-09-14):** VP-029/BC-1.6.050
Postcondition 6 human-text assertions (AC-006/007/008) run only under `JR_RUN_KEYRING_TESTS=1` — the
human-text `Credentials:` path performs a real keychain probe with no default-CI injection seam. Consistent
with the cycle-007 verification-delta coverage boundary and the VP-AUTHDX-007 `JR_RUN_KEYRING_TESTS=1`
pattern; default-CI carries the regression weight via the pure `peek_oauth_app_source_for_test` helper,
the probe-free JSON builder test, and the dispatch-arm coverage test instead. Accepted.

**`CYCLE-007-F6-R2-DERIVE-AUTH-STATE-NO-MUTATION-COVERAGE` (F6 residual R2, 2026-09-14):** `derive_auth_state`
has no cargo-mutants coverage because `src/api/auth.rs` is not in `.cargo/mutants.toml` `examine_globs`
(pre-existing state, not introduced this cycle). Mitigated by an exhaustive truth-table + proptest that
fully enumerate the finite domain (functionally equivalent to full mutation kill on a total pure function);
the `probe_matching_kind_credential` exclusion pair is inert-but-retained. Related to (not a duplicate of)
the pre-existing `FIX-F6-A`/`F6-MUTATION-EXAMINE-GLOBS-EXPANSION` item (cycle-004 maintenance items,
below) — that item is the general `examine_globs` expansion debt; this residual is the specific
cycle-007 instance of it. Accepted, documented.

**Target for both items above:** a future maintenance sweep (natural pairing with
`FIX-F6-A`/`F6-MUTATION-EXAMINE-GLOBS-EXPANSION`), or at cycle-007's F7 human-gate close if the human
chooses to fold them in.

---

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

## Standing item — AUTH-REFRESH-TARGET-PROFILE-NOT-SHOWN (2026-09-18, backlog capture)

**ID:** `AUTH-REFRESH-TARGET-PROFILE-NOT-SHOWN`
**Title:** `jr auth refresh` does not tell the user which profile / authenticated session it is refreshing.
**Severity:** LOW, non-blocking. DX/UX enhancement -- not a correctness bug (the refresh still targets
the correct profile; the user just isn't shown which one).
**Status:** OPEN, DEFERRED.
**Classification:** DX/UX enhancement, auth command family. Continuation of the cycle-003
auth-profile-dx / cycle-007 auth-correctness-dx theme; not tied to cycle-008 (CLOSED) or the
in-flight Teams spike (S6).
**Reported by:** human operator, 2026-09-18.
**Added:** 2026-09-18, lightweight backlog-capture burst (state-manager, TD-VSDD-053 single-commit).
This is a record-only capture -- not a phase advance, no code change, no DEC minted, pipeline stays
PAUSED, no cycle ACTIVE.

**Symptom:** When refreshing an auth login, the interactive flow prompts the user (e.g. to allow the
refresh / keychain access) WITHOUT naming the target profile or its instance URL. On a multi-profile
setup the user cannot tell which authenticated session is being refreshed.

**Grounding / code anchor:** `src/cli/auth/refresh.rs::refresh_credentials` already resolves the
`target` profile name (from the `--profile` flag override, else `config.active_profile_name`) and
validates it -- but never surfaces `target` to the user in the interactive path before dispatching to
`login_oauth`/`login_token`. The resolved target is available; it's simply not echoed.

**Fix direction (for a future implementer, NOT to be done now):** at the start of an interactive
`jr auth refresh` (Table/human mode), emit a stderr notice naming the target profile and its
configured instance URL (e.g. `Refreshing credentials for profile "1898-prod"
(https://1898andco.atlassian.net)...`) BEFORE the keychain/OAuth prompt. Apply to BOTH the OAuth and
API-token refresh paths. Precedent already exists in the codebase: `src/cli/auth/login.rs`'s URL
prompt names `{target_for_check}`, and `src/cli/auth/remove.rs`'s confirm names the profile -- mirror
that. Keep it stderr-only (Output channel profile 4/Symmetric); `--output json` payload MUST remain
unchanged; suppressed under `--no-input`/non-TTY.

**Disposition:** DEFERRED -- candidate for a future auth-DX cycle (theme continuation of cycle-003
auth-profile-dx / cycle-007 auth-correctness-dx). Not tied to cycle-008 (which is CLOSED) and not tied
to the in-flight Teams spike. No target release assigned yet.

**Target:** a future auth-DX cycle. No target release assigned yet.

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

## S-7.02 cycle-closing checklist deferrals — cycle-005 close (Burst 13, D-353, 2026-09-09)

Human chose RECORD DEFERRALS ONLY, no follow-up stories opened. `INTERIM-SHIPPABILITY-WINDOW-CYCLE5-W1` is RESOLVED/CLOSED (see `cycles/RESOLVED-DRIFT-ITEMS.md`), not carried here. `CYCLE5-F7-DOC-1`, `CYCLE5-F7-DOC-2`, and `CYCLE5-STEP45-LOW-1` are RESOLVED as of MAINTENANCE-SWEEP-2026-09-10 (see `cycles/RESOLVED-DRIFT-ITEMS.md`), not carried here. The following 4 items remain open, non-blocking, human-owned or targeted at a future maintenance/self-improvement cycle:

| Item | Class | Target | Reason |
|------|-------|--------|--------|
| `CYCLE5-F5-L2-IDONLY-BRACKET-VP674005` | coverage, LOW, non-blocking, unreachable | none tracked -- accepted | The id-only bracket-mention path (no `attrs.text`) is unverified against VP-674-005. UNREACHABLE from any wired write path: a bracket mention always receives the BC-X.7.010 mandatory preflight, which always populates `attrs.text` before conversion. Reconfirmed by the F6 VP-coverage mapping (Burst 12). |
| `CYCLE5-F5-P3-01-STDIN-NOINPUT` | correctness/coverage, LOW, non-blocking, pending intent verification | product-owner / future maintenance | `handle_comment_add`, `handle_create`, and `handle_edit`'s live single-key path pass the AMBIENT `no_input` to `mentions::resolve_mentions` after a blocking stdin read, unlike `handle_comment_edit` which forces `no_input=true`. DEBUG-ONLY reachable -- release builds auto-flip `no_input=true` for piped stdin. Candidate quick follow-up: mirror `handle_comment_edit`'s `if stdin { no_input = true; }` guard at the three sites. |
| `CYCLE5-STEP45-LOW-2` (= `CYCLE5-W2-LOW-2-INTERACTIVE-TEST-GAP`) | coverage, LOW, non-blocking, accepted limitation | none tracked -- accepted | No automated test covers the interactive `dialoguer::Select` answered-then-resolves path -- no TTY seam exists to drive this deterministically. Matches the pre-existing accepted posture of `duplicate_user_disambiguation.rs`. |
| `CYCLE5-BURST12-LOG-GAP` | process-gap, factory bookkeeping | future maintenance sweep | `cycles/cycle-005/burst-log.md` never received a discrete Burst 12 entry for the F6-targeted-hardening burst, even though STATE.md's own v3.98 history cited "Burst 12" repeatedly. No substantive detail was lost -- the full F6 record was captured in-line in the v3.98 STATE.md Write itself (frontmatter, Phase Progress row, Constraints Carried Forward paragraph, Historical Content row) -- but the discrete burst-log.md entry is missing and should be backfilled for completeness. |

`PR-REVIEW-SELF-APPROVE-HOOK-LOOP` | process-gap, vsdd-factory engine tooling (not a jira-cli product defect) | vsdd-factory engine fix — The pr-review completion hook demands `gh pr review --approve`, which GitHub refuses on a self-authored PR, causing an unbreakable loop -- observed on PR #795's redundant reviewer, and recurred on PR #796/#798/#799 (this session's self-mention CI enablement, E2E-dynamic-tests, and mutants-nightly-rebalance PRs). Feedback filed; same family as `PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP`/`FACTORY-HOOK-FUEL-EXHAUSTED` below.

## S-7.02 cycle-closing checklist deferrals — cycle-006 close (Burst 13, D-351)

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

- **F6-MUTATION-EXAMINE-GLOBS-EXPANSION** -- add `src/api/auth.rs`, `src/cli/auth/login.rs`, `src/api/auth_windows_store.rs` to `.cargo/mutants.toml` examine_globs. Target: a future SELF-IMPROVEMENT/maintenance cycle. **OBS-2 (appended 2026-09-11, Wave-1 gate):** `.cargo/mutants.toml` comment mis-attributes `derive_auth_state` mutation coverage to the `list.rs` glob; this becomes cross-wave-relevant as B2 (`S-cycle7-auth-status-json`) adds a 2nd `derive_auth_state` call site. Fold the comment correction into the glob expansion fix.
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

## cycle-013 Wave-2 integration gate — F-3 (LOW/NIT), deferred (2026-09-16)

**ID:** `CYCLE-013-F3-HISTORICAL-PLANDOC-MSRV-MENTIONS`
**Severity:** LOW/NIT, non-blocking. Surfaced by the cycle-013 Wave-2 integration gate's
consistency audit (`.factory/cycles/cycle-013/phase-f4-wave2-gate/consistency-audit.md`, finding
F-3). Deferred, not a gate blocker (regression GREEN, consistency verdict resolved via F-1/F-2
fixes; F-3 alone does not reopen the gate). **Scope broadened 2026-09-16 (Phase F7 delta-
convergence audit, finding F7-AUDIT-3)** from "dated plan docs" to **historical/closed docs
including ADRs** — see the ADR-0021 sub-entry below, which this item's file list now also covers.

**Files:** `docs/superpowers/plans/2026-04-24-list-rs-split.md:9`,
`docs/superpowers/plans/2026-04-24-multi-profile-auth.md:9`,
`docs/superpowers/plans/2026-05-13-search-issue-keys.md:9`,
`docs/superpowers/specs/2026-04-16-markdown-to-adf-conversion-design.md:228`,
`docs/superpowers/plans/2026-03-21-jr-implementation.md` (multiple mentions),
`.factory/specs/architecture/decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md:~724-725`
(added 2026-09-16, F7-AUDIT-3 — see sub-entry below; already corrected in the same burst that
added this row, kept listed for the historical-stale-prose-class record).

**Issue:** These dated, historical planning/design documents state "Rust 1.85 MSRV" / "Rust 1.85+"
as a fact about the environment at time of writing -- now stale since cycle-013 raised MSRV to
1.88. Cycle-013's S3 (`S-cycle13-doc-policy-reconciliation`) added an explicit dated-historical
annotation to exactly one comparable file
(`docs/superpowers/plans/2026-04-23-team-field-object-shape-tolerance.md`) because that file's
MSRV mention was load-bearing for an active code-snippet rationale (why `.and_then()` was used
instead of a let-chain). The files above make the same kind of now-stale claim but were left
untouched -- S3's target list didn't include them and F1's delta-analysis scoped "Files NOT
Changed" to exclude the general `docs/superpowers/` corpus.

**Why not fixed now:** point-in-time planning-snapshot documents (CLAUDE.md itself frames the v1
implementation plan as historical architectural context, not a living spec); none drive an active
behavioral claim the way the team-field one did; no CI guard (`claude_md_citations`,
`check-spec-counts`, etc.) covers this corpus.

**Candidate fix (optional, not required):** a single blanket disclaimer at the top of
`docs/superpowers/plans/` (or a README there) stating these are point-in-time snapshots and
MSRV/dependency-version mentions are historical, not live -- rather than patching each file
individually as it happens to get touched. Target: a future maintenance sweep.

### Sub-entry: ADR-0021 stale MSRV-verification note (F7-AUDIT-3, 2026-09-16)

**Found by:** cycle-013 Phase F7 delta-convergence audit
(`.factory/cycles/cycle-013/phase-f7-convergence/convergence-audit.md`, Dimension 5 / Finding
F7-AUDIT-3), a fresh-context grep of `.factory/specs/architecture/decisions/*.md` for
MSRV/`rust-version` mentions outside ADR-0025.

**Location:** `.factory/specs/architecture/decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md`
§"Unsafe-code justification" note, `~L724-725` (ADR-0021 is `CLOSED`+`RELEASED`, cycle-004,
Windows DPAPI fallback — unrelated in substance to cycle-013's MSRV bump).

**Issue:** the note read "`windows-sys` 0.60.2's MSRV against this repo's `rust-version = "1.85"`
must be confirmed at F4" — citing the pre-cycle-013 floor (1.85) as if still current.

**Disposition:** LOW, cosmetic, non-blocking — same historical-stale-prose class as the plandoc
mentions above, just in an ADR rather than a dated plan doc, which is why this item's scope and
file list were broadened to explicitly cover "historical/closed docs including ADRs" (previously
worded as "dated plan docs" only). **Fixed in the same burst that recorded this sub-entry**
(one-line prose correction noting the floor was 1.85 at ADR-0021's own F4 confirmation and is now
1.88 under ADR-0025, unaffected by ADR-0021's own conclusion) — kept as a sub-entry here, not
moved to `RESOLVED-DRIFT-ITEMS.md`, because its real value is the scope-broadening precedent for
any future ADR carrying similar point-in-time MSRV/dependency-version prose.

## cycle-013 Wave-2 integration gate — process-gap findings (2026-09-16)

**Status:** OPEN, all LOW/informational, non-blocking. Recorded per the S-7.02 Cycle-Closing
Checklist discipline: these are pipeline/tooling gaps surfaced during the gate burst, not content
defects in any spec/code artifact, and are not attributed to a fabricated story ID.

**`CYCLE-013-HOOK-FALSE-POSITIVE-COMMIT-MSG-SCAN`** -- The `validate-factory-path-staging`
PreToolUse hook pattern-matches the full Bash COMMIT-MESSAGE prose for `.factory/` substrings
(not the actual staged paths), which false-positive-blocked a commit that staged only a `docs/`
file (the architect hit this delivering the PR #822 fix; worked around it by rewording the commit
message rather than by a hook fix). Candidate fix: scope the hook's pattern match to
`git diff --cached --name-only` output instead of the commit-message string. Target: a future
self-improvement/maintenance cycle (engine-level, `vsdd-factory` repo).

**`CYCLE-013-PR-REVIEWER-SUBAGENT-STALL`** (generalized from `CYCLE-013-PR822-SUBAGENT-STALL` --
renamed to reflect recurrence across multiple PR dispatches this session) -- On the PR #822
dispatch, `vsdd-factory:github-ops` and an initial `vsdd-factory:pr-reviewer` sub-agent stalled for
several minutes without returning (`github-ops-pr822-info` never returned a result); `pr-manager`
fell back to running read-only `gh` inspections and the `gh pr merge` directly via Bash instead of
waiting further. **Recurred on PR #823** (same session, release-metadata PR): the dispatched
`pr-reviewer-823` sub-agent stalled and never returned a result; `pr-manager` merged @ `aa557050` on
its own thorough independent verification instead of waiting further, and Claude Code's own
permission classifier flagged the action "Merge Without Review" -- the review gap was closed
post-hoc by an independent fresh-eyes `pr-reviewer` APPROVE of the merged commit, recorded as
`CYCLE-013-PR823-MERGE-WITHOUT-COMPLETED-REVIEW` (RESOLVED, see `cycles/RESOLVED-DRIFT-ITEMS.md`).
Two occurrences in one session confirms this as a **recurring infra issue**, not a one-off. Root
cause still unknown. Candidate: instrument sub-agent dispatch with a timeout/retry policy and
capture stall telemetry next time it recurs; consider whether a stalled review sub-agent should
trigger an automatic escalation/retry before a merge proceeds rather than a silent fallback to
manual verification.

**`CYCLE-013-PR-MANAGER-COMPLETION-GUARD-PREMATURE-STOP`** -- On the PR #823 dispatch, the
`pr-manager-completion-guard` `SubagentStop` hook forced `pr-manager`'s turn to end before its
dispatched async children (the stalled `pr-reviewer-823` sub-agent, and in-flight CI checks) had
completed, creating pressure to fabricate a merge result rather than report an honest in-progress
state -- the agent correctly refused to fabricate and instead completed its own independent
verification before merging. Process-gap in the guard itself: a `SubagentStop` hook that fires
before genuinely async children (sub-agent dispatches, CI runs) have resolved forces a choice
between prematurely ending the turn on incomplete information or holding the turn open against the
hook's own design intent. Candidate: the guard should distinguish "no further action pending" from
"async children still outstanding" -- e.g. checking for outstanding sub-agent dispatches/CI runs
before forcing the stop, or allowing a bounded wait/poll before firing. Target: a future
self-improvement/maintenance cycle (engine-level guard, `vsdd-factory` repo).

**`CYCLE-013-VALIDATE-PR-REVIEW-POSTED-HOOK-MISMATCH`** -- The `validate-pr-review-posted`
`SubagentStop` hook keeps firing because it expects a GitHub review verdict (`gh pr review
--approve`) submitted through GitHub's native review mechanism -- which is **structurally
impossible** for a self-authored, already-merged PR on a solo-maintainer repo (GitHub rejects
self-approval with "Can not approve your own pull request"). This is a separate-reviewer-account
assumption baked into the hook that does not hold for this repo's single-account-merged-PR
topology; it is not a defect in the review itself. The written review artifact
(`code-delivery/RELEASE-v0.7.0-dev.7/pr-review.md`, an independent fresh-eyes APPROVE of `aa557050`)
is the durable record in lieu of a native GitHub review. Observed on PR #823's post-hoc review this
burst. Candidate: the hook should accept a committed review-artifact file as an alternative
satisfaction condition when the PR author and the configured reviewer account are the same GitHub
identity, or should be told the "solo maintainer" topology up front and adjust its expectation
instead of firing every time. Target: a future self-improvement/maintenance cycle (engine-level
hook, `vsdd-factory` repo).

**`CYCLE-013-MERGE-WRAPPER-SCRIPTS-MISSING`** -- The governed merge-wrapper scripts referenced by
the `pr-manager` protocol (`enforce-merge-strategy.sh`, `check-stale-verdict.sh`) do not exist in
this repo, so they could not be invoked during the PR #822 merge; `pr-manager` fell back to direct
`gh pr merge`. Candidate: either scaffold the two scripts in this repo (if the protocol expects
them project-side) or correct the `pr-manager` protocol doc if they are meant to be engine-side
and this repo is missing an integration step. Target: a future self-improvement/maintenance cycle.

## cycle-013 F5 scoped adversarial — maintenance-sensitivity watch (2026-09-16)

**ID:** `CYCLE-013-COMFY-TABLE-ZERO-HEADROOM-MSRV`
**Severity:** LOW, maintenance sensitivity, non-blocking. Surfaced by F5 Pass 3
(`.factory/cycles/cycle-013/phase-f5-adversarial/pass-03.md`).

**Issue:** `comfy-table` is pinned at exactly `=7.2.2`, which requires Rust 1.88 --
matching this repo's `rust-version = "1.88"` MSRV floor with zero headroom. Any future
`comfy-table` bump that raises its own MSRV above 1.88 would fail the (now `--all-targets`
-scoped) `msrv` CI job.

**Why not fixed now:** not a defect -- the current pin is valid and CI-green. The
zero-headroom condition is fail-safe by construction: a future incompatible bump fails the
widened `msrv` job LOUDLY (a hard CI red), not silently, and the repo's existing
exact-pin-with-review convention (the same discipline already applied to `saphyr-parser`)
means any `comfy-table` version bump already goes through human-gated review before
landing.

**Candidate action:** none required now. Watch this pin the next time `comfy-table` is
bumped -- confirm the new version's own MSRV still sits at or below this repo's floor
before merging, or raise the floor in lockstep if it doesn't.

## cycle-013 F7 close — STATE.md timestamp auto-drift (2026-09-16)

**ID:** `CYCLE-013-STATEMD-TIMESTAMP-AUTODRIFT`
**Severity:** LOW, cosmetic, process-gap, non-blocking. Surfaced across multiple cycle-013 bursts
(observed directly in the Phase F7 re-verification pass's `git status` check, which found only a
bare `timestamp:` field diff with zero narrative change between bursts).

**Summary:** `STATE.md`'s frontmatter `timestamp:` field is re-stamped by a background process
(the `stamp-state-timestamp` PostToolUse hook, per BC-5.40.001/S-17.04 -- it unconditionally
re-stamps `timestamp:` to wall-clock now after every tool-mediated Edit/Write/MultiEdit to
`.factory/STATE.md`) roughly every 30-40 seconds, independent of any actual content edit. This
produces perpetual benign working-tree churn in the `factory-artifacts` worktree: a `git status`
check between two unrelated actions frequently shows `STATE.md` as modified even though no
narrative field changed, and each such drift accumulates as its own commit if not folded into the
next substantive burst (as has been the practice this cycle -- see e.g. `factory-artifacts @
87cf1bbc`, "fold in stamp-state-timestamp residual from prior Edit").

**Why not fixed now:** cosmetic only -- no content or narrative correctness is affected, and the
existing convention of folding the residual timestamp bump into the next real burst's commit
already contains the noise without requiring a dedicated fix. Root-causing whether the hook's
~30-40s cadence is intentional (a liveness/freshness signal) or an unintended side effect of some
other periodic process is out of scope for a bookkeeping burst.

**Candidate fix:** investigate the stamping hook/process's trigger cadence and whether it should
debounce (only re-stamp on an actual content-changing write) rather than firing on a fixed
interval regardless of edit activity. Target: a future self-improvement/maintenance sweep
(engine-level, `vsdd-factory` repo, `stamp-state-timestamp` PostToolUse hook).

**Source:** cycle-013 Phase F7 human close/release gate burst, observed recurring across F5/F6/F7
bursts this cycle.

## Maintenance sweep 2026-09-16 — process-gap findings

**Status:** OPEN, non-blocking. Recorded per the S-7.02 Cycle-Closing Checklist discipline
extended to maintenance sweeps: pipeline/tooling gaps surfaced during this sweep's 12 PR merges,
not content defects in any spec/code artifact. Full sweep detail:
`maintenance/sweep-report-2026-09-16.md`.

**`MAINT-SWEEP-2026-09-16-PR-MANAGER-COMPLETION-GUARD-PREMATURE-STOP`** (recurrence of
`CYCLE-013-PR-MANAGER-COMPLETION-GUARD-PREMATURE-STOP`) -- the `pr-manager-completion-guard`
`SubagentStop` hook fired with a hardcoded/incorrect `AUTHORIZE_MERGE=yes` claim regardless of the
actual dispatch, which was review-only. Agents correctly refused to act on the fabricated
authorization. Second confirmed occurrence of this defect class in a different cycle/session --
strengthens the case that the guard itself (not a one-off dispatch) needs the fix proposed at the
cycle-013 entry (distinguish "no action pending" from "async children/verdict still outstanding").

**`MAINT-SWEEP-2026-09-16-VALIDATE-PR-REVIEW-POSTED-HOOK-MISMATCH`** (recurrence of
`CYCLE-013-VALIDATE-PR-REVIEW-POSTED-HOOK-MISMATCH`) -- the `validate-pr-review-posted`
`SubagentStop` hook demanded a `gh pr review --approve` posting that conflicts with review-only
dispatches; fired on the #825, #826, and #830 review dispatches this sweep (three occurrences in
one sweep, on top of the cycle-013 occurrence). Same underlying gap: the hook does not accept a
committed review-artifact file as an alternative satisfaction condition, and doesn't distinguish
"review-only dispatch" from "review-then-merge dispatch."

**`MAINT-SWEEP-2026-09-16-GITHUB-OPS-SUBAGENT-STALL`** (recurrence of the
`CYCLE-013-PR-REVIEWER-SUBAGENT-STALL` class) -- `pr-manager` hung waiting on a `github-ops`
PR-creation sub-dispatch for PR #825 that never returned a result, even though the PR was in fact
successfully created -- only the reply never propagated back to the caller. Mitigation applied
this sweep (not yet a permanent fix): have the authoring agent invoke `gh pr create` directly via
its own shell access instead of delegating PR creation to `github-ops`. Third confirmed occurrence
of the sub-agent-stall class across two sessions; strengthens the case for the cycle-013 entry's
candidate fix (dispatch timeout/retry policy + stall telemetry).

**`MAINT-SWEEP-2026-09-16-HOOK-FALSE-POSITIVE-COMMIT-MSG-SCAN`** (same underlying mechanism as
`CYCLE-013-HOOK-FALSE-POSITIVE-COMMIT-MSG-SCAN`, different trigger site) -- the
`validate-factory-path-staging` `PreToolUse` hook blocked a commit because the commit **message
text** contained a literal `.factory/...` path substring, even though no `.factory/` file was
actually staged for that commit. Confirms the cycle-013 root-cause diagnosis: the hook
pattern-matches the commit-message string rather than `git diff --cached --name-only` output.
Workaround used again this sweep: reword the commit message to avoid literal `.factory/` path
substrings. Two confirmed occurrences now; strengthens the case for the candidate fix already on
file (scope the hook's match to staged paths, not message prose).

**`MAINT-SWEEP-2026-09-16-DEPENDABOT-RECREATE-VS-REBASE`** -- NEW, operational learning (not a
hook/guard defect). `@dependabot rebase` **no-ops** when a PR is already `MERGEABLE` (no merge
conflict) -- it only rebases to resolve conflicts, not to refresh CI against a base branch that
has since moved. `@dependabot recreate` is required to force a rebuild against current `develop`.
Additionally observed: the "Dependabot Updates" GitHub Actions runner queue can stall for many
minutes with no user-visible cause, and sequential merges of cargo-ecosystem Dependabot PRs
re-conflict each other's `Cargo.lock` one at a time (merging PR N re-conflicts PR N+1's lockfile),
requiring a `recreate` on the next queued PR after every merge rather than merging the whole
cargo batch back-to-back. Candidate action: codify this three-part sequencing note (recreate not
rebase; expect queue latency; recreate-after-each-merge for cargo batches) directly in the
`vsdd-factory:maintenance-sweep` skill's dependency-handling guidance so future sweeps don't
rediscover it from scratch.

**`MAINT-SWEEP-2026-09-16-AUTOMODE-CLASSIFIER-NONDETERMINISTIC-BLOCK`** -- NEW. The Claude Code
auto-mode permission classifier ("Merge Without Review" / "Modify Shared Resources" categories)
blocked agent-initiated admin merges and branch pushes **non-deterministically** during this
sweep's 12-PR merge sequence -- the same class of action (an admin-bypass squash-merge of a
CI-green, human-authorized PR) was allowed for some PRs in the batch and blocked for others, with
no discernible input difference driving the split. Net effect: merges required direct orchestrator
action with a per-merge human go-ahead rather than a single batch approval, and branch-push
retriggers (e.g. re-pushing a rebased dependency branch) were blocked outright every time they
were attempted. Candidate action: none yet -- flagging for pattern-matching against future sweeps
to determine whether the non-determinism correlates with a specific action shape (merge vs. push),
PR size, or session state.

**Cross-reference note:** four of the six findings above are **confirmed recurrences** of
cycle-013 entries already on file (see "cycle-013 Wave-2 integration gate — process-gap findings"
section above) -- `PR-MANAGER-COMPLETION-GUARD-PREMATURE-STOP`,
`VALIDATE-PR-REVIEW-POSTED-HOOK-MISMATCH`, `PR-REVIEWER-SUBAGENT-STALL`, and
`HOOK-FALSE-POSITIVE-COMMIT-MSG-SCAN` have now each recurred across two independent
cycles/sessions, which raises their priority from "one-off observation" to "confirmed recurring
infra defect" for the next self-improvement/maintenance cycle targeting the `vsdd-factory` engine
repo itself.

## Maintenance sweep 2026-09-16 — standing items to track

**`MAINT-SWEEP-2026-09-16-DENY-TOML-TRANSITIONAL-SKIPS`** -- Two temporary `deny.toml`
`[[bans.skip]]` entries landed this sweep to unblock queued dependency bumps, each with a
documented removal trigger:
- `syn` 2/3 duplicate (PR #826) -- remove once `cargo tree -i syn` shows a single version.
  Upstream holdouts: `pear_codegen`, `proc-macro2-diagnostics`, `tracing-attributes`.
- `windows_i686_gnullvm` 0.53 duplicate (PR #830) -- remove once
  `cargo tree -i windows_i686_gnullvm` shows a single version. Upstream holdout: `keyring` 3->4.

Both investigations reached a **NOT-CONVERGEABLE-NOW** verdict; full detail:
`maintenance/syn-convergence-investigation-2026-09-16.md`,
`maintenance/windows-targets-convergence-investigation-2026-09-16.md`. Track for removal the next
time a dependency sweep runs `cargo tree -i` against either crate.

**`MAINT-SWEEP-2026-09-16-JNI-RUSTLS-CONVERGENCE-OPPORTUNITY`** -- Unrelated convergence
opportunity spotted during this sweep's dependency audit: bumping `jni` to 0.22.4 and
`rustls-platform-verifier` to 0.7.0 would collapse the `windows-sys` 0.45 duplicate lineage.
Not actioned this sweep (out of scope -- discovered as a byproduct of the syn/windows-targets
investigation, not itself a blocker). Candidate action: pick up as a small fix PR in a future
maintenance sweep.

## cycle-008 F4 Wave 1 delivery burst — process-gap findings (2026-09-17)

**Status:** OPEN, all needing a follow-up story or justified deferral per S-7.02 discipline.
Surfaced during the cycle-008 F4 Wave 1 delivery burst that produced PRs #832/#833/#834/#835 (all
4 CI-green, pr-reviewer APPROVE-verdict-as-COMMENTED, HELD at the human consolidated merge gate,
none merged this burst). Not content defects in any spec/code artifact.

**`CYCLE-008-PR-MANAGER-COMPLETION-GUARD-FALSE-AUTHORIZE`** (recurrence of
`CYCLE-013-PR-MANAGER-COMPLETION-GUARD-PREMATURE-STOP`) -- **[SAFETY]** The
`pr-manager-completion-guard` `SubagentStop` hook asserted, repeatedly (5+ times this session), a
FALSE `AUTHORIZE_MERGE=yes per dispatch convention` claim and pushed dispatched `pr-manager`
sub-agents toward merging PRs #832/#833/#834/#835 without the human consolidated merge-gate signal
this burst's dispatch explicitly required. Only agent good-judgment (declining to act on the
hook's false claim, verifying against the actual dispatch instructions instead) prevented an
unauthorized merge each time. This is a **recurrence**, not a new class -- the underlying guard
defect (a `SubagentStop` hook asserting merge authorization state it cannot actually verify) was
already tracked as `CYCLE-013-PR-MANAGER-COMPLETION-GUARD-PREMATURE-STOP` and evidently was not
fixed between cycle-013 and cycle-008. Escalating severity to **[SAFETY]** given the 5+ repeat
count in one session and the fact that good judgment, not a structural control, is the only thing
preventing an unauthorized merge. Candidate fix: the hook must stop asserting a merge-authorization
verdict it has no way to actually know; it should either omit any `AUTHORIZE_MERGE` claim entirely
or derive it from a verifiable, dispatch-scoped source (e.g. a flag explicitly passed at dispatch
time) rather than a blanket "per dispatch convention" default. Needs a human hook-config fix.
Target: a future self-improvement/maintenance cycle (engine-level hook, `vsdd-factory` repo).

**`CYCLE-008-SELF-APPROVAL-STRUCTURAL-GAP`** -- Repo-wide, affects every PR (observed again on
#832/#833/#834/#835 this burst): the single GitHub identity that authors every factory PR is the
same identity configured to review it, so `gh pr review --approve` 422s with GitHub's own
self-approval rejection, and the `validate-pr-review-posted` hook (see
`CYCLE-013-VALIDATE-PR-REVIEW-POSTED-HOOK-MISMATCH`, still open) can never observe a native
GitHub APPROVE state. Each PR's review lands as a COMMENTED review carrying an explicit APPROVE
verdict in its body/summary instead. Merging therefore requires a human admin-bypass of branch
protection, or provisioning a genuinely separate second reviewer account -- neither of which this
burst's dispatch was authorized to do, which is why all 4 PRs are correctly HELD rather than
merged. Candidate fix: same as `CYCLE-013-VALIDATE-PR-REVIEW-POSTED-HOOK-MISMATCH`'s candidate --
accept a committed review-artifact/COMMENTED-with-verdict review as satisfying the gate when
author and reviewer are the same identity, or formalize the human-admin-bypass step as the
documented, expected path for a solo-maintainer topology rather than an exception. Target: a
future self-improvement/maintenance cycle (engine-level hook, `vsdd-factory` repo).

**UPDATE (2026-09-18, S5/PR #843 delivery burst):** confirmed this gap is broader than GitHub
approval state alone -- it now ALSO blocks the orchestrator's own `pr-manager` DISPATCH: the
auto-mode classifier issues a `[Self-Approval]` denial on any dispatch that carries merge
authorization for a self-authored PR, not merely on the `gh pr review --approve` call. Practical
effect, confirmed again on PR #843: every cycle-008 self-authored story PR requires the
orchestrator to dispatch `pr-manager` in a merge-ready-STOP scope (create PR, drive CI green,
post the COMMENTED-with-verdict review, then stop short of merging) and hand the actual merge
action to the human. #843 was merged this way -- human manual admin-bypass merge @ `926fdb96`,
mergedAt 2026-09-18T14:40:40Z, after pr-manager/pr-reviewer completed their merge-ready-STOP
scope. No new ID -- folded into this existing entry per S-7.02 cycle-closing-checklist guidance
(observation, not a new defect class; same candidate fix as above, now covering the dispatch-time
classifier as well as the GitHub-side approval mechanics).

**`CYCLE-008-NESTED-SUBAGENT-STALL-RECURRENCE`** (recurrence of
`CYCLE-013-PR-REVIEWER-SUBAGENT-STALL`) -- Nested sub-agent dispatches (`github-ops`,
`pr-reviewer`) stalled under concurrency load this burst (4 stories delivered in parallel/near-parallel
across S1-S4) -- the stalled sub-agents had completed real work (pushes, review content) but failed
to hand back a result to their dispatching `pr-manager`. Workaround applied, consistent with the
cycle-013 precedent: `pr-manager`s performed `git push`/`gh`/review actions directly via Bash
rather than waiting further on the stalled sub-agent. Confirms this as a **recurring** infra issue
across cycles, not cycle-013-specific. Root cause still unknown; candidate fix unchanged from the
cycle-013 entry (timeout/retry policy + stall telemetry on sub-agent dispatch). Target: a future
self-improvement/maintenance cycle (engine-level, `vsdd-factory` repo).

**`CYCLE-008-WORKTREE-IDENTITY-PREFLIGHT-GAP`** -- Flagged independently by the S1, S3, and S4
per-story adversarial passes this burst: worktree basenames created for this burst's stories do
not match their story-id (naming drift), and story dispatches omit the feature-branch-HEAD-SHA
identity tuple the adversary's "Worktree-Identity Preflight" check expects, so that preflight
cannot run strictly -- it degrades to a best-effort check rather than a hard gate. Did not block
any of the 3 passes' convergence (each still reached 3 clean passes), but the preflight's intended
guarantee (that the adversary is reviewing the code it thinks it's reviewing) is weaker than
designed. Candidate fix: reconcile worktree naming to always equal the story-id, and have story
dispatch always include the feature-branch HEAD SHA at hand-off so the tuple exists for the
preflight to check. Target: a future self-improvement/maintenance cycle (process convention,
applies to `deliver-story`/per-story-delivery orchestration).

**Carried forward, non-blocking, out-of-scope this cycle (not new items, restated for burst
continuity):**
- S3 OBS-2 -- pre-existing `let _ = write_workspace_cache` call site uses `let _ =` rather than
  `.ok()`, deviating from the `.ok()`-discard convention CLAUDE.md documents for the sibling
  `write_cmdb_fields_cache`/`write_object_type_attr_cache` model-b writers. Not touched this burst
  (S3's story scope is the 1-site routing swap only); candidate follow-up: a small doc-hygiene/
  consistency fix PR normalizing this call site to `.ok()`.
- S3/S4 stale historical design-doc -- `docs/superpowers/specs/2026-03-24-assets-cmdb-design.md`'s
  routing prose predates the OAuth gateway-routing fix and no longer accurately describes the
  `get_or_fetch_workspace_id` call path. Doc-hygiene follow-up, not a blocker; candidate: update
  or annotate as historical in a future maintenance sweep.

## cycle-008 Wave-1 WAVE-GATE convergence + fix PR #836 — process-gap findings (2026-09-17)

**`CYCLE-008-WAVEGATE-OBS-2-INIT-SCOPE-HINT-COVERAGE`** (wave-level adversary observation
OBS-2, distinct from the pre-existing `S3 OBS-2` above -- disambiguated with a `WAVEGATE-` prefix
to avoid ID collision) -- The `jr init` per-project setup prompt's `list_boards` OAuth
scope-mismatch hint (added this burst via the F-WG-1 human-approved widening, `src/cli/init.rs`)
has ONLY keyring-gated test coverage: `jr init` is interactive-by-default and its integration
tests are gated behind `JR_RUN_KEYRING_TESTS=1` (per the CLAUDE.md AI Agent Notes keyring-test
table), so the new wrap is not exercised in the default `cargo test`/CI run. Reviewed and
**ACCEPTED as correct by inspection** -- the wrap mechanically reuses the identical
`rewrite_agile_scope_error`-style hint already covered by `board.rs`'s own keyring-gated and
non-keyring-gated test mix at the `list_boards` call site (same function, same scope strings, no
new detection logic), so the residual risk is LOW. Not a blocker; candidate follow-up: extend
`init.rs`'s test suite with a wiremock-based non-interactive path (if one is ever added) to close
the last mile without requiring `JR_RUN_KEYRING_TESTS=1`.

**`CYCLE-008-WAVEGATE-OBS-3-CHANGELOG-DOUBLE-FIXED-HEADING`** (= wave-level adversarial finding
F-WAVE-3, LOW, cosmetic) -- `CHANGELOG.md`'s `[Unreleased]` section carries two separate
`### Fixed` subheadings instead of one merged list. Cosmetic only (no content is lost or
duplicated, just split across two headings under the same release section). Disposition:
**DEFERRED** to release-notes consolidation -- the next release-metadata PR that touches
`CHANGELOG.md`'s `[Unreleased]` section should merge the two `### Fixed` blocks into one before
cutting a release, following the same consolidation pattern already used for the dev.6/dev.7
CHANGELOG backfills (see `cycle_013_status` in `STATE.md` frontmatter for that precedent). Not a
functional defect; not a merge blocker for PR `#836`.

**`CYCLE-008-WAVEGATE-COMPLETION-GUARD-RECURRENCE`** (further recurrence of
`CYCLE-008-PR-MANAGER-COMPLETION-GUARD-FALSE-AUTHORIZE`, itself a recurrence of
`CYCLE-013-PR-MANAGER-COMPLETION-GUARD-PREMATURE-STOP`, above) -- The `pr-manager-completion-guard`
`SubagentStop` hook fired its false `AUTHORIZE_MERGE` assertion MANY MORE times during this
wave-gate burst than the prior burst's already-elevated count (dispatching the fix-adversarial
loop, PR `#836` creation/review, and the wave-level adversarial re-runs each re-triggered it).
Agents correctly ignored every false assertion and PR `#836` remains correctly HELD, unmerged, at
the human wave-gate -- no unauthorized merge occurred. Escalation to `[SAFETY]` from the prior
burst stands; this is additional frequency evidence for the same still-open engine-level hook
defect, not a new root cause. No new candidate fix beyond what's already logged. Target: a future
self-improvement/maintenance cycle (engine-level hook, `vsdd-factory` repo).

**`CYCLE-008-WAVEGATE-PATH-STAGING-CWD-FALSE-POSITIVE`** (recurrence of the mechanism underlying
`CYCLE-013-HOOK-FALSE-POSITIVE-COMMIT-MSG-SCAN`, MAINT-SWEEP-2026-09-16's sibling recurrence, and
now generalized beyond commit-message scanning) -- The `validate-factory-path-staging` `PreToolUse`
hook mis-detected the agent's current working directory during this burst's `.factory/` git
operations, producing a false-positive path-staging block unrelated to the actual files being
staged. Worked around by re-running the git operation with an explicit, unambiguous cwd rather
than relying on the hook's own detection. Confirms the hook's cwd-detection logic is unreliable
across more triggering conditions than just the commit-message-scan case originally identified in
cycle-013. Candidate fix: same root-cause family as `CYCLE-013-HOOK-FALSE-POSITIVE-COMMIT-MSG-SCAN`
-- the hook should resolve cwd from an authoritative source (e.g. the tool call's own working
directory parameter) rather than inferring it. Target: a future self-improvement/maintenance
cycle (engine-level hook, `vsdd-factory` repo).

**`CYCLE-008-WAVEGATE-BC1-FUEL-EXHAUSTED-CAP-RECURRENCE`** -- A validation-hook fuel/step cap
(`FUEL_EXHAUSTED`) was hit again against `bc-1-auth-identity.md` during this burst's spec-consistency
propagation sweep (the `read:board-scope.admin:jira-software` + `read:project:jira` co-requirement
wording fix, mirrored from `BC-X.15.001`). This is a **recurrence** of a known class -- large BC
files with dense cross-reference trace blocks intermittently exhaust a validation hook's bounded
execution budget on this specific file. Worked around by keeping the edit narrowly scoped (a
single wording correction, not a full-file rewrite) so the hook's retry/partial-pass succeeded.
Not a blocker this burst (the edit landed correctly, confirmed via `git diff`), but the underlying
cap is a still-open engine-level tuning issue for `bc-1-auth-identity.md` specifically (it is one
of the larger BC files by trace-block size). Candidate fix: raise the fuel budget for
large-BC-file validation hooks, or shard the hook's work into smaller per-section passes. Target:
a future self-improvement/maintenance cycle (engine-level hook tuning, `vsdd-factory` repo).

**`CYCLE-008-WAVEGATE-TEMPLATE-COMPLIANCE-BURST-HEADING-MISMATCH`** (NEW this burst, distinct
mechanism from the items above) -- `validate-template-compliance`'s generic `burst-log-template.md`
literally requires an `## Burst 1 (YYYY-MM-DD)` heading (its own placeholder text, never intended
to be numbered-literally in practice) to appear somewhere in the file, while the sibling
`validate-burst-log` hook enforces (and this file has used since its very first entry) the
DIFFERENT format `## Burst: <description> (YYYY-MM-DD)`. No heading in `cycles/cycle-008/burst-log.md`
has ever satisfied the first hook's literal "Burst 1" substring match -- including its original,
first-ever entry, predating this burst -- so this is a pre-existing engine-level hook/template
mismatch, not something this burst introduced. `validate-template-compliance` fired as a
PostToolUse advisory on this burst's edits (non-reverting; the content landed correctly). Not
worked around by fabricating a false "Burst 1" heading on a non-first entry, since that would
misrepresent the historical burst sequence. Candidate fix: either update
`burst-log-template.md`'s canonical heading to match `validate-burst-log`'s actual enforced
`## Burst: <desc> (date)` format, or have `validate-template-compliance`'s section-matching logic
recognize `## Burst:` as satisfying the `## Burst N` template placeholder generically (regex,
not fixed-string). Target: a future self-improvement/maintenance cycle (engine-level
hook/template alignment, `vsdd-factory` repo).

## cycle-008 F4 Wave 2 S5 delivery -- justified deferrals (S-7.02 cycle-closing checklist, 2026-09-18)

**Status:** CLOSED-BY-DEFERRAL. Both items below are LOW severity, surfaced by the per-story
adversarial review of `S-cycle8-jsm-attachments-oauth-verification` (PR `#843`, MERGED @
`926fdb96`). Per S-7.02, a justified deferral recorded here is sufficient disposition -- neither
warrants a new follow-up story on its own.

**`CYCLE-008-ENV-RESTORE-NON-RAII`** -- `tests/attachment_jsm.rs`'s new test
(`test_bc_4_2_001_jsm_attachment_upload_succeeds_end_to_end_under_oauth`) sets `JR_CACHE_DIR` via
`unsafe { std::env::set_var(...) }` and restores it with a manual `remove_var` call at the end of
the test body. On a panic mid-test (an assertion failure before that line runs), the env var leaks
to whatever test runs next in-process. LOW -- this exactly matches the pre-existing
`tests/project_meta.rs` pattern already accepted elsewhere in the suite, so it is not a novel
defect, only an inherited one. Candidate fix: a pattern-wide RAII env-restore-guard helper (a small
`struct EnvVarGuard` whose `Drop` unconditionally restores/removes the var, mirroring the
`AttachmentDropGuard`/`ComponentDropGuard` idiom CLAUDE.md documents for live-fixture teardown) --
out of scope for a facade/verification-only story whose story-level diff is a single new test.
Target: a future maintenance sweep, applied across all `JR_CACHE_DIR`/env-mutating test sites at
once rather than piecemeal.

**`CYCLE-008-WORKTREE-NAME-VS-STORYID`** -- The S5 worktree's basename
(`cycle8-s5-jsm-attachments-oauth-verification`) does not satisfy the strict anchored-match rule
against its story-id (`S-cycle8-jsm-attachments-oauth-verification`) -- missing the `S-` prefix
and carrying an extra `s5-` wave-slug segment. This degrades the adversary's Worktree-Identity
Preflight to a best-effort check (same class as `CYCLE-008-WORKTREE-IDENTITY-PREFLIGHT-GAP`
above, recurring here on Wave 2 after being flagged on S1/S3/S4 in Wave 1) -- flagged across two
adversarial passes on this story, did not block convergence (3 clean passes still reached).
Candidate fix: same as the Wave-1 entry -- reconcile worktree-naming convention (drop wave-slug
segments, anchor strictly to the story-id) vs. the preflight's anchored-match rule, in one pass
across both. Target: a future self-improvement/maintenance cycle (process convention, applies to
`deliver-story`/per-story-delivery orchestration).

**`CYCLE-008-S5-TRAJECTORY-TAIL-HOOK-FALSE-POSITIVE`** (new mechanism, same family as
`CYCLE-008-WAVEGATE-PATH-STAGING-CWD-FALSE-POSITIVE`/`CYCLE-013-HOOK-FALSE-POSITIVE-COMMIT-MSG-SCAN`)
-- `validate-trajectory-tail-cell-completeness` repeatedly (3+ times) reported the `→1→0→0→0`
arrow-sequence missing from `STATE.md`'s frontmatter `current_step` field and "Last Updated"
table cell during this burst's `STATE.md` write, even after independent on-disk verification
(`grep -c`, a Python substring check, and a file checksum taken immediately after each edit)
confirmed the exact literal token `trajectory_tail →1→0→0→0` present in both locations. The
`PostToolUse` `Edit`/`Write` hook is advisory (non-reverting) -- the correct content is confirmed
committed to disk. Candidate fix: same root-cause family as the other two false-positive
entries -- the hook likely re-checks a stale read or a regex anchor that doesn't tolerate the
leading `→` character; needs a reproduction with the exact `STATE.md` byte content from this
burst. Target: a future self-improvement/maintenance cycle (engine-level hook, `vsdd-factory`
repo).

## cycle-008 F5 scoped adversarial -- justified deferrals (S-7.02 cycle-closing checklist, 2026-09-18)

**Status:** CLOSED-BY-DEFERRAL. F5 (scoped adversarial review of the whole cycle-008 delta,
`0793b9c5`..`fc608cd3`) CONVERGED via 3 clean adversary passes (novelty HIGH -> LOW -> 0.10). Two
of Pass 1's four findings (F1, F3) were FIXED via FIX-F5-001 (PR `#844`, merged @ `fc608cd3`); the
remaining two (F2, F4) plus the pre-existing release-gate item are justified deferrals recorded
here per S-7.02 -- full detail: `cycles/cycle-008/phase-f5-adversarial/convergence-summary.md`.

**`CYCLE-008-F5-KEYRING-WIRING-COVERAGE`** (= F5 Pass 1 finding F2, MEDIUM test-quality) --
the post-refresh double-fault classification wiring in `src/api/client.rs` (landed `578a7848`,
wave-gate fix `#836`) has no CI-running test coverage, only `#[ignore]`d keyring-gated integration
tests. Same structural limitation as every other keyring-dependent code path in this repo (Linux
CI may lack secret-service; macOS prompts on novel service names) -- not a novel defect, an
inherited one. Candidate fix: a mockable keyring test seam, which does not currently exist.
Target: a future test-infrastructure investment, not a cycle-008 fix.

**`CYCLE-008-F5-INIT-MAPERR-MUTANT-RESIDUAL`** (= F5 Pass 1 finding F1's residual after FIX-F5-001,
LOW mutation-testing residual) -- **SUBSUMED 2026-09-18 (F7 close, D-371) by
`CYCLE-008-INIT-MUTATION-COVERAGE-SEAM`** above -- same root cause (`init.rs::handle` has no
default-CI mutation coverage), now tracked as the single canonical item going forward. Original
text preserved: FIX-F5-001 added a CI-running test pinning `init.rs`'s `list_boards` scope-hint
STRING through the shared `is_insufficient_scope_error` helper, closing the coverage gap Pass 1
flagged. A mutant deleting `init.rs`'s own `.map_err` wiring specifically (distinct from the
shared helper, which the new tests do cover) still survives CI, since the new test does not
independently prove that call site is reached only through the intended error path. Accepted per
the FIX-F5-001 story spec's scope (shared-helper + string-pin coverage, not full mutation-kill on
every call site).

**F4-cosmetic** (= F5 Pass 1 finding F4, COSMETIC) -- a discarded `NotAuthenticated` allocation on
a dead branch, surfaced during F5 Pass 1. Note-only, no behavioral/performance/test impact. Not
assigned a standing-item ID (cosmetic-only, per S-7.02's disposition guidance that a note-level
item needs no separate tracking ID once recorded).

**Confirmed still open, unaffected by F5 (no new information from this phase):**
`CYCLE-008-CONSOLE-SCOPE-RELEASE-GATE` (RELEASE-GATE, human-owned pre-release blocker -- F5's
Pass 1 independently re-surfaced this as a process-gap observation; unchanged, still
OPEN/PENDING, tracked in full above); `CYCLE-008-ENV-RESTORE-NON-RAII` and
`CYCLE-008-WORKTREE-NAME-VS-STORYID` (both carried from S5's merge, 2026-09-18; F5 reviewed the
whole delta including S5's diff and did not surface either as a new/distinct finding).

## cycle-008 F6 targeted hardening -- justified deferrals (S-7.02 cycle-closing checklist, 2026-09-18)

**Status:** CLOSED-BY-DEFERRAL. F6 (formal verification/fuzz/mutation testing scoped to the
cycle-008 delta `0793b9c5`..`fc608cd3`, plus full-tree regression and security scans) reached
**HARDENED_WITH_RESIDUALS, NO BLOCKING findings** -- consistent with cycle-007/cycle-013 F6
closure precedent. `develop` tip UNCHANGED at `fc608cd3` (no F6 code fix landed). Full detail:
`cycles/cycle-008/phase-f6-hardening/hardening-record.md`.

**`CYCLE-008-F6-MUTANTS-EXAMINE-GLOBS-GAP`** -- **RESOLVED 2026-09-18 (F7 close, D-371)**, 6 of 7
files. Human F7-gate decision: "fix examine_globs first, then close" -- FIX-F7-001 (PR #845,
`develop@fc608cd3`->`0834c9f0`) added `src/api/client.rs`, `src/cli/board.rs`, `src/cli/sprint.rs`,
`src/cli/issue/list.rs`, `src/api/jsm/queues.rs`, `src/api/assets/workspace.rs` to
`.cargo/mutants.toml` `examine_globs` (25->31 entries) plus 5 anchored `exclude_re` entries scoping
out the keychain-gated post-refresh-retry wiring in `JiraClient::send_inner` (reachable only via
`JR_RUN_KEYRING_TESTS=1`-gated `#[ignore]`'d tests). `src/cli/init.rs` (the 7th file) was
DELIBERATELY DEFERRED, not resolved -- see the new follow-up item
`CYCLE-008-INIT-MUTATION-COVERAGE-SEAM` immediately below. Full resolved-item text and rationale
archived to `cycles/RESOLVED-DRIFT-ITEMS.md`.

**`CYCLE-008-INIT-MUTATION-COVERAGE-SEAM`** (NEW, LOW, follow-up minted at F7 close 2026-09-18,
D-371) -- `src/cli/init.rs` was deliberately excluded from FIX-F7-001's `examine_globs` addition:
`jr init`'s entire `handle()` function has zero default-CI mutation coverage (exercised by exactly
one `#[ignore]`'d, keychain-gated test), so every mutant introduced into it would survive by
default -- the same whole-file-flooding class as the pre-existing `auth.rs`/`login.rs` FIX-F6-1
deferral, not a single narrowly-anchored `exclude_re` fix. This SUBSUMES
`CYCLE-008-F5-INIT-MAPERR-MUTANT-RESIDUAL` below (same root file, same underlying gap -- tracked
here going forward as the single canonical item). Target: a future test-infrastructure investment
(a mockable keyring/init test seam) that would let `init.rs` carry real default-CI coverage before
it can safely join `examine_globs`.

**`CYCLE-008-F6-PUREFN-MUTATION-HOST-DEFERRED`** (LOW) -- empirical `cargo-mutants` confirmation
of the 3 new pure fns (`classify_401_body`, `is_insufficient_scope_error`, and the
`resolve_board_id` call site wiring `rewrite_agile_scope_error`) is blocked by a full-suite
baseline timeout on this dev host (`HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY` family, same
host-speed constraint tracked elsewhere for `nextest`). A broader `--in-diff`-scoped attempt
(`cycles/cycle-008/phase-f6-hardening/mutants_libscope.log`) got as far as one TIMEOUT + one
MISSED (a whole-function-replacement mutant on `resolve_board_id`, not specific to the new
error-mapping closure) before the run was interrupted -- inconclusive, not scored. Target: confirm
via a faster runner or the nightly mutation workflow (`MUTANTS_NIGHTLY_ENABLED=true`) once the
`examine_globs` gap above is closed.

**`CYCLE-008-F6-SEMGREP-NOT-INSTALLED`** (LOW/note) -- semgrep is not installed on this dev host;
no substitute static-analysis scan was run in its place this burst. `cargo deny check` (exit 0,
advisories/bans/licenses/sources all ok) and `cargo audit` (0 vulnerabilities / 360 deps / 1251
advisories) both clean. Target: install semgrep in a future maintenance/tooling pass, or confirm
CI already runs it (out of this burst's scope to verify).

**`CYCLE-008-F6-LOCAL-CLIPPY-BUILDLOCK`** (LOW/note) -- local `cargo clippy --all-targets` was not
re-run this burst due to a build-lock on the dev host. `fc608cd3`'s own CI run (a PR #844 merge
prerequisite) already validated `clippy` clean and is treated as authoritative. Consolidated with
the pre-existing `HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY` host-speed constraint rather than
duplicated as a separate root cause.

**Confirmed still open, unaffected by F6 (no new information from this phase):**
`CYCLE-008-CONSOLE-SCOPE-RELEASE-GATE` (RELEASE-GATE, human-owned pre-release blocker -- still
OPEN/PENDING, unchanged); `CYCLE-008-F5-KEYRING-WIRING-COVERAGE`, `CYCLE-008-F5-INIT-MAPERR-MUTANT-RESIDUAL`,
`CYCLE-008-ENV-RESTORE-NON-RAII`, `CYCLE-008-WORKTREE-NAME-VS-STORYID` (all carried from F5/S5;
F6's checks did not surface any of them as newly resolved or newly distinct).

## cycle-008 Phase F7 close -- S-7.02 Cycle-Closing Checklist (2026-09-18, D-371)

**Status:** cycle-008 (`oauth-surface-correctness`) **CLOSED** at the F7 human gate (APPROVED).
Operator decision: "fix examine_globs first (FIX-F7-001, PR #845 @ `0834c9f0`), then close" --
satisfied, then closed. Shipped on `develop @ 0834c9f0`, **NO immediate release cut**. Full
convergence detail: `cycles/cycle-008/phase-f7-convergence/delta-convergence-report.md`.

Every cycle-008 process-gap/novel finding is tracked as an OPEN-STANDING-ITEM or
resolved-with-note; none left uncovered at close:

- `CYCLE-008-CONSOLE-SCOPE-RELEASE-GATE` -- **OPEN**, human/release-owned pre-release blocker
  (see top of this file). Does not block the cycle's own close, only shipping a release that
  carries its content.
- `CYCLE-008-F6-MUTANTS-EXAMINE-GLOBS-GAP` -- **RESOLVED 6/7** via FIX-F7-001 (above). 7th file
  (`src/cli/init.rs`) residual -> new follow-up `CYCLE-008-INIT-MUTATION-COVERAGE-SEAM`.
- `CYCLE-008-F5-KEYRING-WIRING-COVERAGE` -- **OPEN**, carried forward unchanged (future
  test-infrastructure investment; a mockable keyring test seam does not currently exist).
- `CYCLE-008-F5-INIT-MAPERR-MUTANT-RESIDUAL` -- **SUBSUMED** by `CYCLE-008-INIT-MUTATION-COVERAGE-SEAM`
  (above).
- `CYCLE-008-F6-PUREFN-MUTATION-HOST-DEFERRED` -- **OPEN**, carried forward unchanged (host-speed
  limitation; candidate for the nightly mutation workflow now that `examine_globs` is widened).
- `CYCLE-008-SELF-APPROVAL-STRUCTURAL-GAP` -- **OPEN**, carried forward unchanged (repo-wide,
  engine-level fix target, not a cycle-008 fix).
- `CYCLE-008-ENV-RESTORE-NON-RAII` -- **OPEN**, carried forward unchanged (test-quality debt from
  S5, `tests/attachment_jsm.rs`).
- `CYCLE-008-WORKTREE-NAME-VS-STORYID` -- **OPEN**, carried forward unchanged (S5 worktree-naming
  convention debt).
- The pre-existing `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` maintenance note (factory-wide
  bookkeeping-hash churn, not cycle-008-specific) was independently re-confirmed by this close's
  input-hash drift scan -- no cycle-008 semantic spec drift found; **OPEN**, unchanged, pre-existing
  factory-wide debt.
- Two unrelated findings surfaced incidentally by the F7 pre-gate consistency/input-hash scan and
  confirmed OUT OF cycle-008's scope: a drift note on `bc-2-issue-read.md` (pre-existing, no
  cycle-008 workstream touches that file per F1 §3's confirmed no-overlap grep) and 4 historical
  input artifacts whose `inputs:` sources no longer resolve to re-hashable content (superseded/
  archived source docs from earlier cycles, `ACCEPTED SENTINEL`-class per the cycle-013 precedent).
  Both recorded as **maintenance-sweep candidates only** -- not actioned, not blocking, not
  cycle-008 content.
- S6 (`S-cycle8-teams-graphql-oauth-replatform-spike`) -- confirmed **NOT STARTED / deferred
  non-gating** at close, per `cycles/cycle-008/oauth-scope-matrix.md` §3 (wave plan) and ADR-0026's
  Consequences section (Workstream D deferred, Teams spike investigation-only). `jr team list`
  remains status-quo-broken under OAuth -- a documented gap, not a regression introduced by this
  cycle. Not tracked as a new standing item (already fully described in ADR-0026 and the S6 story
  file itself, `cycles/cycle-008/phase-f3-stories/S-cycle8-teams-graphql-oauth-replatform-spike.md`).
  **Superseded 2026-09-19:** the spike subsequently ran to completion (research-only, zero `src/`
  changes) with go/no-go = DEFER-INDEFINITELY -- see the new standing item
  `S6-TEAMS-OAUTH-BLOCKED-ON-ATLASSIAN-SCOPE-PROVISIONING` below, which now carries this forward.

## S6 Teams spike COMPLETE -- DEFER-INDEFINITELY, externally blocked on Atlassian scope provisioning (2026-09-19) -- MAINTENANCE-REVISIT

**ID:** `S6-TEAMS-OAUTH-BLOCKED-ON-ATLASSIAN-SCOPE-PROVISIONING`
**Severity:** LOW / external blocker (not a cycle-008 release blocker; `jr team list` under OAuth
was already status-quo-broken before cycle-008 and remains so -- this is a documented gap, not a
regression).
**Status:** OPEN, standing item, **RECURRING MAINTENANCE-REVISIT item** (see subsection below) --
not a one-and-done record. No `src/` change accompanies this entry; pipeline stays PAUSED, no
cycle ACTIVE. Counts unchanged (`total_bcs` 770, VP 89, holdout 118, `total_stories` 191);
`activation_head`/`activation_version` unchanged (`aa557050`/`v0.7.0-dev.7`).

**Summary:** the `S-cycle8-teams-graphql-oauth-replatform-spike` (cycle-008 Workstream D,
non-gating, investigation-only) is now **COMPLETE**. Findings AC-001 (GraphQL host/query shape
confirmed, translation-layer required, OAuth host `api.atlassian.com/graphql`), AC-003
(`get_org_metadata`/`jr init` CONFIRMED IN-SCOPE -- also OAuth-broken, increasing blast radius),
and AC-004 (CONFIRMED-FORK-REQUIRED -- an `is_oauth_auth()`-gated host fork is a genuine third host
class jr does not currently model) all stand as documented in the spike report. The single gating
blocker, **AC-002** (whether `view:team:teams` -- the confirmed exact read-query scope -- is
addable to jr's standalone Jira Cloud 3LO app), is now **empirically resolved as
CONFIRMED-NOT-GRANTABLE**: a controlled differential authorize-endpoint test on 2026-09-19, run by
the operator against jr's real embedded OAuth app from their live authenticated Atlassian browser
session (the only variable being the `scope` parameter), showed a control request
(`read:jira-work offline_access`) render a valid consent screen while the identical request plus
`view:team:teams` produced Atlassian's owner-facing "Something went wrong / INFORMATION FOR THE
OWNER OF JIRA-CLI JR" consent-server error instead of a consent screen. No consent was completed
and no tokens/grants were created. Full method + result:
`cycles/cycle-008/teams-graphql-spike-report.md` §"Operator empirical verification (2026-09-19)".

**Go/no-go: DEFER-INDEFINITELY** (not a flat REJECT -- no cited Atlassian rule categorically bars
3LO from the Teams read query; the barrier is an absent Console self-service provisioning path,
now confirmed empirically unusable for this app, not a documented prohibition). `jr team list` /
Teams functionality remains **API-token-only** (works under Basic/API-token auth via the
site-local `/gateway/api/graphql`; broken under OAuth 3LO) -- documented, accepted, and unchanged
from pre-cycle-008 behavior. OAuth users needing Teams data have a workaround: use an API-token
profile.

**Update (2026-09-19, Console entitlement inspection):** a SECOND independent proof was obtained,
by a structurally different method than the authorize differential test above. Using the
operator's authenticated Developer Console session, jr's embedded OAuth app's Permissions page was
inspected directly and its full configurable API catalog enumerated exhaustively: 8 APIs total
(Personal data reporting 0 scopes, User identity 2, Confluence 0, Jira 15, Compass GraphQL 0,
Goals 0, Projects 0, Focus 0; 17 scopes used overall). No "Teams" API tile exists anywhere in this
catalog, and no hidden "browse more APIs" control exists to reveal one (only an unrelated "Add
Marketplace or custom app" button is present). Notably, **Compass GraphQL IS offered** while
**Teams GraphQL is NOT** -- ruling out a blanket "GraphQL APIs are unavailable to 3LO apps"
explanation; Teams specifically is withheld, not GraphQL categorically. This confirms the operator
did not miss a hidden Console setting -- the entitlement genuinely is not available. Full method +
result: `cycles/cycle-008/teams-graphql-spike-report.md` §"Console entitlement inspection
(2026-09-19)". **AC-002 verdict: CONFIRMED-NOT-GRANTABLE, now substantiated by two independent
proofs** (empirical authorize differential test + exhaustive Console catalog inspection).
**AC-006 verdict: DEFER-INDEFINITELY** (unchanged).

**Reopen trigger (the only unblock):** Atlassian provisioning/enabling `view:team:teams`
(read-only team-query scope) for jr's standalone 3LO app -- requires an app-owner request via the
Teams platform "Contact us" page (`developer.atlassian.com/platform/teams/overview/contact-us/`)
and/or a post on `community.developer.atlassian.com` (tag teams/3lo, referencing community threads
#80920/#94060). Until Atlassian confirms provisioning, there is nothing implementable: a future
`S7 teams-graphql-oauth-replatform` implementation story stays blocked/unopened, not merely
deprioritized.

### Recheck each maintenance sweep

This item is a **recurring maintenance-revisit check**, not a closed record. Every future
maintenance sweep that touches this file (or is otherwise auditing `cycles/OPEN-STANDING-ITEMS.md`
standing debt) should re-run the check below and update this entry's status in place -- do NOT
re-run the full spike investigation from scratch; only the recheck procedure is needed unless it
signals a change.

**Signal to watch for:** Atlassian exposing the platform Teams API / `view:team:teams` scope to
standalone Jira Cloud OAuth 2.0 (3LO) apps -- i.e., any change that would flip AC-002 from
CONFIRMED-NOT-GRANTABLE to grantable.

**How to recheck (either is sufficient; both are cheap, no `src/` change, no pipeline phase):**

1. **Console check.** In the jr app's Developer Console Permissions page, check whether a "Teams"
   API now appears in the configurable API catalog. Baseline as of 2026-09-19 (8 APIs, no Teams):
   Personal data reporting, User identity, Confluence, Jira, Compass GraphQL, Goals, Projects,
   Focus. If a Teams tile now appears -> **REOPEN**.
2. **Empirical check.** Request scope `view:team:teams` in an authorize URL against jr's embedded
   app with an authenticated session (mirrors the 2026-09-19 differential test method above). A
   rendered consent screen (instead of the owner-facing "Something went wrong" error) means the
   scope is now grantable -> **REOPEN**.

**If reopened:** the implementation shape is already mapped in the spike report -- a translation
layer (`teamSearchV2` Relay response -> existing `TeamsResponse`), an `is_oauth_auth()`-gated host
fork (a third host class, `api.atlassian.com/graphql`, alongside `base_url`/`instance_url`), an
`ADR-0026` Decision 1 amendment documenting that third host class, and `jr init` regression
coverage (since AC-003 found `get_org_metadata` also in-scope). Open it as a scoped feature cycle
(the conditional S7 `teams-graphql-oauth-replatform`) rather than a maintenance-sweep fix -- it is
implementation work, not a doc/config change. See `cycles/cycle-008/teams-graphql-spike-report.md`
AC-006 "Confirmed shape a future S7 would start from" for the full starting design.

**Always-available fallback (unaffected either way):** Teams functionality works today under
API-token (Basic auth) profiles via the site-local `/gateway/api/graphql` gateway -- this gap is
an OAuth-3LO-only enhancement opportunity, not a fix for a feature that is broken for everyone.
OAuth users needing Teams data can use an API-token profile in the meantime.

**No DEC minted for this disposition** -- consistent with this file's and `STATE.md`'s existing
convention that verification-outcome / standing-item-resolution checkpoints (e.g. the
`OAUTH-16-SCOPE-SMOKE-TEST-PASS-2026-09-18` and `CYCLE-008-CONSOLE-SCOPE-RELEASE-GATE` resolution
bursts) are recorded as bookkeeping, not new pipeline rulings, when they neither advance a phase
nor change spec/BC/VP/ADR content. `D-371` (cycle-008 F7 close, which already scoped S6 as
"spike, non-gating") remains the most recent decision touching this workstream; it is referenced,
not superseded. Full record: `cycles/cycle-008/teams-graphql-spike-report.md`, `STATE.md`,
`.factory/maintenance-config.yaml` (`external_blocker_rechecks:` pointer).

---

## Standing item — ENGINE-VALIDATE-DISPATCH-ADVANCE-STALE-DCHAIN-CITE — RESOLVED 2026-09-19

**ID:** `ENGINE-VALIDATE-DISPATCH-ADVANCE-STALE-DCHAIN-CITE`
**Status:** **RESOLVED 2026-09-19, human-approved (2x) DEC->D decision-ID migration.** Full
original item text + resolution facts archived verbatim to `cycles/RESOLVED-DRIFT-ITEMS.md`
(§"RESOLVED — ENGINE-VALIDATE-DISPATCH-ADVANCE-STALE-DCHAIN-CITE"). New decision `D-372` minted
for the migration ruling; see `STATE.md` Decisions Log.

**Summary of resolution:** the human operator explicitly approved (twice) a one-time bulk
migration renaming every `DEC-NNN` decision-ID token to `D-NNN` throughout `.factory/`
(word-boundary-safe, ~7,215 occurrences / 532 files, verified 0 `DEC-\d+` remaining
corpus-wide). This formally REVIVES the `D-chain` convention per fix-direction option (b) of the
original item -- decisions are now genuinely numbered `D-NNN`, not a fabricated placeholder. The
`validate-dispatch-advance` hook's D-chain currency check now passes on real content (`current_step`
cites `D-372`, the file's genuine max). jira-cli's slim STATE.md style (dense single-paragraph
field values, no dense burst-narrative breakdown) is unchanged by this migration. The related
`validate-factory-path-staging` `cd .factory && git` false-positive note is NOT resolved by this
migration -- still tracked under `CYCLE-013-HOOK-FALSE-POSITIVE-COMMIT-MSG-SCAN` above.

## Maintenance sweep 2026-09-19 (fix delivery, closed 2026-09-20) — process-gap findings

**Status:** OPEN (process-gap items), non-blocking. Recorded per the S-7.02 Cycle-Closing
Checklist discipline extended to maintenance sweeps: pipeline/tooling gaps surfaced during this
sweep's 3 fix-PR deliveries (`#848`, `#849`, `#850`, all merged to `develop`), not content defects
in any spec/code/product artifact. Full delivery record: `.factory/maintenance/2026-09-19/README.md`,
`STATE.md` Phase Progress row `MAINT-20260919-FIX-DELIVERY-COMPLETE-2026-09-20`.

**`MAINT-SWEEP-2026-09-19-VALIDATE-PR-REVIEW-POSTED-HOOK-MISMATCH`** (recurrence of
`CYCLE-013-VALIDATE-PR-REVIEW-POSTED-HOOK-MISMATCH`, extended with two NEW facets this sweep) --
the `validate-pr-review-posted` `SubagentStop` hook's core gap (demanding a native
`gh pr review --approve`/`--request-changes` event) recurred, and this sweep surfaced two distinct
failure shapes rather than one:
  - **(a) Self-authored-PR trap.** All 3 fix PRs this sweep were self-authored (author ==
    operator's own GitHub account). GitHub structurally blocks self-approval, and the permission
    classifier independently flags `[Self-Approval]` on any attempt to route around it. A reviewer
    that reaches a genuine APPROVE verdict on a self-authored PR therefore has NO hook-satisfying
    action available -- `--approve` is impossible, not merely inadvisable -- trapping it in an
    unsatisfiable Stop-hook retry loop. Workaround used: the orchestrator terminated stuck
    reviewers after independently confirming (via `gh pr view --json` + reading the committed
    `pr-review.md` artifact) that the COMMENTED-verdict review had actually posted.
  - **(b) `--comment` substring false-positive.** The hook appears to substring-match "comment" in
    the invoked command and misclassifies a formal `gh pr review --comment` (a review EVENT,
    distinct from a plain issue comment) as if it were `gh pr comment` (which the hook correctly
    treats as non-satisfying). This produced a false NOT-SATISFIED signal on reviews that had, in
    fact, posted a proper COMMENTED review event.
  Severity **MEDIUM** (process friction / wasted reviewer cycles; no incorrect merge or content
  outcome resulted -- the orchestrator's independent verification caught both facets before any
  decision was made on stale information). Candidate fix (extends the cycle-013 entry's candidate):
  the hook must (1) accept a `--comment`-posted review event as a valid terminal state distinct
  from `gh pr comment`, disambiguated by parsing the actual `gh` subcommand/flag structure rather
  than a raw substring match, and (2) treat "self-authored PR, `--approve`/`--request-changes`
  structurally unavailable, COMMENTED verdict posted + review artifact committed" as a satisfying
  terminal state, not a stuck-retry condition.

**`MAINT-SWEEP-2026-09-19-PR-MANAGER-COMPLETION-GUARD-FALSE-AUTHORIZE`** (recurrence of
`CYCLE-013-PR-MANAGER-COMPLETION-GUARD-PREMATURE-STOP` / `CYCLE-008-PR-MANAGER-COMPLETION-GUARD-FALSE-AUTHORIZE`)
-- the `pr-manager-completion-guard` hook repeatedly asserted "your dispatch is pre-authorized for
the full cycle including merge (`AUTHORIZE_MERGE=yes` per dispatch convention)" during this
sweep's fix-PR deliveries even though the dispatch briefs **explicitly negated** merge
authorization (review-and-report-only dispatches). The `[Merge Without Review]` permission
classifier correctly blocked any autonomous merge attempt regardless of the hook's false claim, so
no incorrect merge occurred -- but a less-conservative agent could plausibly be pressured toward
an unauthorized merge by the hook's own assertion. Severity **LOW-MEDIUM**. Third+ confirmed
occurrence of this defect class across cycle-008, cycle-013, and now this maintenance sweep --
strengthens the case that the guard's `AUTHORIZE_MERGE` computation is structurally wrong (it
appears to default-assume merge authorization rather than reading it from the actual dispatch
payload), not a one-off dispatch-wiring mistake.

**`MAINT-SWEEP-2026-09-19-PR-REVIEWER-OPUS-SLOWNESS`** -- NEW, performance/infra observation (not
a correctness defect). Two `pr-reviewer` sub-agent instances dispatched under an explicit
`model: opus` override each took tens of minutes to complete review of a ~10-line diff (PR
`#849`'s `deny.toml` housekeeping and a companion review), well beyond the latency a diff of that
size warrants. No `model` override was needed for reviews this small. Severity **LOW** (cost/time
inefficiency, no incorrect verdict). Candidate action: default `pr-reviewer` dispatches to the
agent's configured default model; reserve an explicit `opus`/heavier-model override for reviews
where the diff size or risk profile actually warrants deeper reasoning (large diffs, security-
sensitive changes, ambiguous verdicts on a prior pass) -- not as a blanket default for routine
maintenance-sweep fix PRs.

**Record-only note (not a defect):** all 3 sweep merges (`#848` @ `7a57ed53`, `#849` @ `d85a8136`,
`#850` @ `7e0f9cbd`) were performed by the human operator (`Zious11`) via admin-bypass, consistent
with `CYCLE-008-SELF-APPROVAL-STRUCTURAL-GAP` (self-approval is structurally blocked for
self-authored PRs, so a human must always be the final merge actor under the current review model)
and this session's human-gated merge model. Because the human performed the merge directly, the
governed-merge wrapper scripts (`check-stale-verdict.sh`, `enforce-merge-strategy.sh`) were not
invoked through the pipeline for these 3 merges. This is **accepted, not a defect** -- the wrappers
exist to govern agent-initiated merges; a human's own admin-bypass merge action is outside their
scope by design, the same way it was for PR `#823` (cycle-013) and other prior human-gated merges
this project has recorded.

## Untracked external PR discovered on pipeline resume — UNTRACKED-EXTERNAL-PR-574-PROVENANCE-ATTESTATION (2026-09-20)

**Status:** OPEN, record-only, **NOT triaged this session**. Severity **LOW**. Surfaced by
`gh pr list` on pipeline resume during the `RELEASE-v0.7.0-dev.8-BUILD-COMPLETE-2026-09-20`
burst while verifying the v0.7.0-dev.8 release build/publish outcome (read-only via `gh`) --
an unrelated discovery, not itself part of that verification.

**PR:** `#574` — "ci(release): attest build provenance for release artifacts", contributor
`ArcavenAE`, branch `ArcavenAE:ci/attest-provenance` -> `develop` (fork PR). Open since
2026-07-06 (~2.5 months as of this recording). Not previously tracked anywhere in `STATE.md`
or this file.

**Disposition:** untriaged. This item exists solely so the discovery is not lost before a
human makes a review/merge/close decision. No content judgment has been made this session --
neither on the correctness or security posture of the proposed provenance-attestation CI
change, nor on its mergeability against the current `ci.yml`. Per the CI Gate review-scope
discipline (`CLAUDE.md`'s "CI Gate — SCOPE SUMMARY"), any PR touching `.github/workflows/`
warrants scoped review of that diff before merge; that review has not yet happened for `#574`.

**Next step (human-owned):** review PR `#574` and decide review/merge/close. If merged, note
that it most likely touches release-workflow CI (`.github/workflows/release.yml`), which is
adjacent to but distinct from the six `ci-gate`-scoped files enumerated in `CLAUDE.md`.

**Unrelated, unchanged:** Dependabot `#842` (base64 0.23) remains separately HELD OPEN
(multiple-versions ban; awaiting `hyper-util`) — no change to it this burst.
