---
document_type: delta-analysis
cycle: cycle-007-auth-correctness-dx
mode: brownfield-feature
producer: architect (F1, combined with business-analyst-role BC mapping — no separate agent spawn this pass; see note in §0)
timestamp: 2026-09-10
status: complete
feature: auth-correctness-dx bundle (issues #784, #785, #786, #787, #788, #790, #783)
intent: mixed (bug-fix dominant, one enhancement facet, two docs-only)
feature_type: backend (CLI, no UI surface — UX/a11y/e2e-browser dimensions N/A)
scope: non-trivial (full F1-F7)
trivial: false
route: Full F1-F7, single wave-able bundle with 2-cluster internal sequencing
inputs:
  - .factory/phase-f1-delta-analysis/issue-triage-auth-cluster-2026-09-10.md
input-hash: "ee744a2"
---

# Phase F1 Delta Analysis: Auth Correctness & DX Bundle (#784, #785, #786, #787, #788, #790, #783)

**Validated against:** `develop @ 14e695aef0a553e01c63b45a95a4bef8b1b8f6bc` (same commit the
triage report validated against; re-confirmed live during this F1 pass — see §1 citations).

**Source validation:** `.factory/phase-f1-delta-analysis/issue-triage-auth-cluster-2026-09-10.md`
(all 7 issues VALID or PARTIALLY-VALID; no product code modified during triage or this F1 pass).
GitHub issue text was treated as untrusted data throughout — analysis is grounded in source
citations, never in issue-author claims taken at face value.

**§0 — Process note:** this report performs both the architect's impact-boundary role (Step 3)
and the business-analyst's BC-mapping/regression-risk role (Step 4) in one pass rather than two
separately-spawned agents, because the bundle is small enough (7 issues, ~6 touched files) that
splitting would duplicate the same source-reading work twice. Both roles' outputs are present
below (§2 architecture verdict, §3 BC mapping) and are separable if a future cycle wants to audit
them independently.

---

## 1. Feature Summary

| # | Issue | One-line description | Verdict (triage) | Disposition |
|---|---|---|---|---|
| 1 | #784 | Credential-absence error suggests `jr auth login <profile>` (positional) — doesn't parse | VALID, HIGH, S | **IN SCOPE — Cluster A** |
| 2 | #785 | `JR_EMAIL`/`JR_API_TOKEN` never consulted at command-resolution time — no headless auth path | VALID, HIGH, M | **IN SCOPE — standalone (largest design surface)** |
| 3 | #786 | Credential-absence uses exit 64 (UserError) instead of 2 (NotAuthenticated) | VALID, MED, S–M | **IN SCOPE, NARROWED — Cluster A + Cluster B (see §5 open question)** |
| 4 | #787 | `auth status` ignores `--output json` | VALID, MED, M | **IN SCOPE — Cluster B** |
| 5 | #788 | `auth list` STATUS derived from URL presence alone, not credential presence | VALID, MED, S | **IN SCOPE — Cluster B** |
| 6 | #790 | `--oauth` help text wrong (claims BYO OAuth app required) + 2 secondary defects | PARTIALLY-VALID→mostly VALID, LOW, S | **IN SCOPE — standalone, doc-only** |
| 7 | #783 | README migration note missing (primary claim already remediated) | PARTIALLY-VALID, LOW, S | **IN SCOPE — standalone, doc-only, scoped to migration note only** |

Intent: **mixed** — bug-fix (#784, #786, #787, #788), enhancement (#785 — new headless-auth
capability), docs (#783, #790). No single "route" label covers the bundle; §6 classifies each
issue individually.

Feature type: **backend** — `jr` is a CLI; UX/accessibility/e2e-browser convergence dimensions
are N/A, consistent with every prior `jr` feature cycle (see `delta-analysis-components.md` §1
disposition, same rationale).

---

## 2. Architecture Verdict (impact boundary, Step 3)

**No structural/interface redesign.** All changes are internal to existing modules — no new
subsystem, no new ADR-mandated pattern shift, no new crate/module boundary. The one item that
touches a genuine design decision (not merely code) is #785: where the env-var resolution branch
lives and what precedence it takes relative to the keychain is a design choice the architect
should record as a short ADR-style decision note at F2, not a structural change to the codebase's
shape. Recommend NOT a new ADR file — this is small enough to record as an addition to
`ADR-0020` (`§Decision 2`, the section that already owns `load_api_token`'s design) or a new
short `ADR-0023` if the F2 spec-evolution pass judges the precedence decision consequential
enough to warrant its own numbered decision (it touches credential-source trust ordering, which
is security-adjacent — lean toward a dedicated ADR).

### Impact table

| File | Class | Notes |
|---|---|---|
| `src/api/auth.rs` | **MODIFIED — HIGH regression risk** | `load_api_token` (~L777-819 in the current build): #784's positional-flag string fix, #786's error-type reclassification (credential-absence sites only), #785's new env-var branch. Core, security-critical, single most heavily-touched file in the bundle. See §4. |
| `src/cli/auth/keychain.rs` | MODIFIED | `ENV_EMAIL`/`ENV_API_TOKEN` constants (`pub(crate)`, L12-13) currently reachable only from `resolve_credential` (login-time). #785 needs these — or equivalents — visible to `load_api_token`'s command-time resolution path. Whether the constants move to `auth.rs` or `auth.rs` imports them from `keychain.rs` is an F2/F3 implementation detail, not an architecture decision. |
| `src/cli/auth/status.rs` | MODIFIED | #787: `status(profile_arg: Option<&str>)` (L73) gains an `&OutputFormat` parameter; builds a `serde_json::Value` and routes through `output::render_json` per the #526 JSON-render invariant (CLAUDE.md). #786's unknown-profile site (L113) is **NOT recommended for change** — see §5. |
| `src/cli/auth/list.rs` | MODIFIED | #788: both `render_list_table` and `render_list_json` currently derive `status` from `p.url.is_some()` alone (L33-37, L64). Fix calls the existing `profile_has_stored_credentials(profile) -> Result<bool>` helper (`src/api/auth.rs` L873-875) once per profile. |
| `src/main.rs` | MODIFIED | L279: `cli::auth::status(effective_profile.as_deref()).await` — the sole dispatch call site; needs the output-format value threaded through for #787. |
| `src/cli/mod.rs` | MODIFIED | #790 primary: `AuthCommand::Login`'s `--oauth` doc comment (L221-229) states "requires your own OAuth app" — factually wrong given the embedded app (ADR-0006). Doc-string-only change; no `#[arg(...)]` attribute changes. |
| `src/cli/auth/login.rs` | MODIFIED (optional) | #790 secondary (a): `emit_oauth_deprecation_notice` is called at L481, after `check_noninteractive_oauth_guard` at L473 — a guard-rejected invocation never reaches the notice. This is **already correct runtime behavior**; the defect is purely that the doc comment in `mod.rs` overclaims unconditional emission. No functional change needed here — only the doc string in `mod.rs` needs to stop overclaiming. |
| `src/error.rs` | DEPENDENT, no change | `exit_code()`'s mapping (`NotAuthenticated`/`InsufficientScope`→2, `ConfigError`→78, `UserError`→64, L107-116) is already correct per the triage report's own finding (a); the defect is exclusively *which variant* `auth.rs`/`status.rs` construct, not this mapping. Confirmed by direct read — no change recommended to this file. |
| `README.md` | MODIFIED | #783: add the upgrade/migration note + OAuth-vs-api-token asymmetry sentence near L425-431 (the existing migration section covers only the `[instance]`→`[profiles.default]` TOML reshape and OAuth lazy-migration — nothing about api-token re-login). Scoped addition, not a rewrite (primary README defect already fixed). |
| `CHANGELOG.md` | MODIFIED | #786's exit-code change (64→2 for credential absence) is observably breaking for any script/CI wrapper that greps for exit 64 specifically — needs a breaking-change entry in the same style as the existing BC-1.2.051/DEC-321 precedent CLAUDE.md cites. |

**Files explicitly NOT touched (regression baseline):** `src/api/auth_embedded.rs`,
`src/api/refresh_coordinator.rs`, `src/api/auth_windows_store.rs` (DPAPI fallback, cycle-004),
`src/api/client.rs`, `src/config.rs`, `src/cache.rs`, `src/cli/auth/{refresh,switch,remove,
logout}.rs`, `src/cli/init.rs`, and every non-auth command family (`issue`, `board`, `sprint`,
`worklog`, `team`, `user`, `project`, `component`, `queue`, `requesttype`, `assets`). Full list
with per-file notes: `.factory/phase-f1-delta-analysis/cycle-007-affected-files.txt`.

---

## 3. Affected Artifact Mapping (BC placement, Step 4)

All seven issues live inside the existing **BC-1 (Auth & Identity)** bounded context
(`.factory/specs/prd/bc-1-auth-identity.md`). Reading the actual BC text (not just the triage
report's file:line citations) surfaced two findings that change scope from what a naive reading
of the issue bundle would suggest — both are called out prominently in §5.

| Issue | BC disposition | Detail |
|---|---|---|
| **#784** | **AMENDS BC-1.4.032, BC-1.4.033, BC-1.4.034** | BC-1.4.032 Postcondition 2 and BC-1.4.033 Postcondition 2 **literally pin the broken message text** as normative contract language: `"…run \`jr auth login {profile}\` to set them up."` / `"…run \`jr auth login {profile}\` to fix this."`. BC-1.4.034 Postcondition 1 cites the same string verbatim. Fixing #784 is therefore a **spec amendment**, not a silent code fix — F2 must update all three BC bodies' literal quoted text to `--profile {profile}` in the same burst as the code change, or the spec becomes stale/self-contradicting the moment the code ships. |
| **#786** | **AMENDS BC-1.4.032, BC-1.4.033 — credential-absence sites ONLY** | Same two BCs' Postcondition 2 also pin the error TYPE: `JrError::UserError` (exit 64). Reclassifying to `NotAuthenticated` (exit 2) for the both-absent and namespaced-partial branches requires amending these two Postconditions' error-type clause alongside #784's text fix (same lines, same burst — #784 and #786 are inseparable at the code level per the triage report's own coupling note, and now confirmed inseparable at the spec level too). **The `status.rs` unknown-profile site is a different matter — see §5, NOT recommended for inclusion.** |
| **#785** | **NEW BC(s)** | No existing BC governs environment-variable consultation at command-resolution time. `BC-1.1.014` governs env vars only at `auth login` time via `keychain.rs::resolve_credential` — a distinct code path from `load_api_token`. Recommend a new subdomain, e.g. **"1.7 Non-Interactive Credential Resolution"**, sized for 2-4 new BCs covering: env-var branch precedence (flag/keychain vs. env — F2 design decision), pair-gating (both `JR_EMAIL`+`JR_API_TOKEN` must be present, mirroring `resolve_oauth_app_credentials`'s existing pair-gate convention at login time), and interaction with the per-profile model (does an env-sourced credential get namespaced/cached, or resolved fresh every invocation — recommend the latter, stateless, to avoid a new keychain-write side channel). |
| **#787** | **AMENDS BC-1.6.047 (resolves EC-1.6.047-2's stated contingency) + NEW BC(s)** | BC-1.6.047 already anticipates this exact gap: EC-1.6.047-2 says *"`auth status --output json` is NOT currently implemented at all per NFR-O-N… this BC's `status` JSON obligation (Postcondition 2a) is therefore contingent on that gap's resolution."* Implementing #787 **retires NFR-O-N and activates Postcondition 2a as written** — the `env` field's JSON shape (verbatim/lossless, `null` for unset) is already normatively specified; #787's F2 work is to author the NEW BC(s) covering the *rest* of the JSON schema (`profile`, `url`, `auth_method`, `credentials: bool`, conditional `oauth_app`) that BC-1.6.047 doesn't cover, in the "1.2 Profile Lifecycle Management" or a new "auth status" subdomain, modeled on `BC-1.6.046`'s sibling shape. |
| **#788** | **NEW BC** (+ minor amendment to BC-1.6.046's fixture note) | No existing BC pins "`STATUS` reflects config presence, not credential presence" as an intentional contract — `list.rs::render_list_table`'s own doc comment (L20-21) already flags this as provisional: *"Status today is a coarse… check — credential-store probing comes in Task 13."* This confirms #788 is closing a known, self-documented gap, not contradicting a deliberate BC. New BC needed for the truthful-status contract (vocabulary: `configured`/`no-credentials`/`unset`, or a separate `credentials: bool` field — F2 decides). **Minor knock-on:** BC-1.6.046's fixture description states *"All STATUS cells `configured`"* — if the fixture's 3 profiles don't all have real stored credentials post-fix, this line needs a one-sentence amendment, and the insta snapshot needs regeneration (already flagged as an F4 deliverable pattern in BC-1.6.046's own Source note). |
| **#790** | **No BC change required** (optional EC addition) | No BC pins the literal `--oauth` help-text wording — it's a doc-comment, not a tested contract. BC-1.2.049 (deprecation-notice gating) remains correct and unamended: its Postcondition 2 pins gating on *output format*, which is a different axis from #790 secondary (a)'s *guard-rejection-precedes-notice* ordering — the runtime behavior the issue describes is already correct (§2 above), only the help text overclaims. Optional: add an EC to BC-1.2.049 documenting the guard-rejection suppression path explicitly, for completeness — non-blocking. |
| **#783** | **No BC change required** | Doc-only; satisfies BC-1.4.034's own pre-existing "F4 doc-fallout obligation" clause (which already required a CHANGELOG/migration-notes entry for the breaking change — this issue is that obligation coming due for README specifically, not a new requirement). |

**Regression-risk-zone stories** (existing implementations that touch the files being modified,
flagged for full re-run per CLAUDE.md convention):
- `tests/auth_profiles.rs` — covers BC-1.1.003/004/005/006/007/008 (switch/status/logout/
  remove/precedence); `status.rs` and `list.rs` changes touch this file's fixtures directly.
- `src/api/auth.rs` inline `#[cfg(test)] mod tests` (~110 tests) — includes the exact tests the
  triage report named: `test_bc_1_4_032_absent_namespaced_keys_no_legacy_pair_returns_
  actionable_exit64`, `test_bc_1_4_032_absent_namespaced_keys_legacy_pair_present_returns_
  identical_actionable_exit64`, `test_bc_1_4_033_namespaced_partial_email_present_returns_
  incomplete_credentials_error`, `test_bc_1_4_033_namespaced_partial_token_present_returns_
  incomplete_credentials_error` — plus their shared helpers `expected_bc_1_4_032_absent_message`
  / `expected_bc_1_4_033_partial_message` (~L3687-3701), which currently return the broken string
  AND assert exit 64; both the helper and every consuming test must change in lockstep with
  #784/#786's fix, not as a follow-up.
- `tests/auth_output_json.rs` — existing `auth list --output json` JSON-shape precedent; #787's
  new tests should follow this file's established pattern.
- `src/cli/auth/tests/` (`mod.rs` + `snapshots/`) — `auth list` table insta snapshot
  (BC-1.6.046) needs regeneration if #788 changes the STATUS column vocabulary.
- `tests/auth_remove_logout_semantics.rs`, `tests/auth_chosen_flow_reconcile.rs`,
  `tests/auth_login_config_errors.rs`, `tests/auth_oauth_default_creation.rs`,
  `tests/auth_header_release_gate.rs`, `tests/oauth_refresh_integration.rs`,
  `tests/oauth_flow_holdouts.rs`, `tests/oauth_embedded_login.rs` — regression baseline, not
  directly touched by this bundle but share `auth.rs`'s neighborhood; must stay green byte-for-
  byte (same discipline CLAUDE.md documents for cycle-003's OAuth-path baseline).

**Verification Properties needing extension:** This project does not currently maintain a
separate `VP-INDEX.md`/`module-criticality.md` artifact (searched, not present under
`.factory/specs/` or elsewhere in `.factory/`) — VPs live inline inside each BC file's own
"Verification Properties" section. The directly relevant existing VPs are **VP-AUTHDX-005/006**
(`load_api_token`'s no-copy detect-and-instruct correctness, keyring-gated proptest) and
**VP-AUTHDX-008** (no-half-credential safety invariant) on BC-1.4.032/033 — these VPs assert the
*existence and shape* of the error, not its exact exit code or message text, so they likely
**do not need rewriting**, only re-running once the message/exit-code changes land (confirm at
F2). New BC(s) for #785/#787/#788 will need their own new VPs authored at F2 if any of them rise
to SAFETY-CRITICAL/property-test-worthy status — #785's env-var precedence logic is the strongest
candidate (a proptest over flag/env/keychain presence-combinations, mirroring
`resolve_oauth_app_credentials`'s existing pair-gate test pattern).

---

## 4. Regression Risk Assessment (Step 5)

| Module | Risk | Why |
|---|---|---|
| `src/api/auth.rs` | **HIGH** | Core, security-critical credential storage/resolution module; every credential read/write/clear path in the CLI funnels through it. **Not a fresh regression surface** — this exact file was rated HIGH regression risk by BOTH `cycle-003` (`auth-profile-dx`, which introduced BC-1.4.032/033/034 and the very error sites #784/#786 target) AND `cycle-004` (`windows-correctness`, DPAPI storage work) — confirmed by direct read of both cycles' F1 delta-analysis reports (`.factory/cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md` L128/190-191, `.factory/cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md` L350). This is the third consecutive cycle touching this file at overlapping lines; the OAuth-path functions (`oauth_login`, token refresh, DPAPI routing) are explicitly OUT of this cycle's scope and must be confirmed byte-for-byte unchanged as a regression gate, exactly as cycle-003 required for its own untouched neighbors. |
| `src/cli/auth/status.rs` | **MEDIUM** | Consumed by BC-1.1.002/003/004/008 and by scripts probing first-run state; the `--output json` threading (#787) is additive to an existing function signature, not a rewrite, but `status()` is also the site of the credential probe (`load_oauth_tokens`/`load_api_token` calls at L152-155) that #786's error-type reclassification indirectly touches if `.is_ok()` semantics interact with the new `NotAuthenticated` variant path (they shouldn't, since `.is_ok()` collapses any `Err` identically — worth an explicit regression test asserting this). |
| `src/cli/auth/list.rs` | **MEDIUM** | Both table and JSON renderers change simultaneously (#788); insta snapshot is a hard regression tripwire (good — it will fail loudly on any unintended STATUS-column drift) but must be deliberately regenerated, not blindly `cargo insta accept`-ed without reviewing the new values. |
| `src/cli/auth/keychain.rs` | **MEDIUM** | Currently a clean, small, single-purpose module (login-time-only resolution); #785 either grows it or extracts a shared helper `auth.rs` also calls — either way this is new coupling between a previously CLI-layer-only module and the API-layer `auth.rs`, worth an explicit architecture note at F2 on which module owns the env-var constants going forward. |
| `src/main.rs`, `src/cli/mod.rs`, `src/cli/auth/login.rs` | **LOW** | Additive/doc-only changes; Rust's exhaustiveness checking and the existing `#[arg(conflicts_with = …)]` clap wiring are the safety net. |
| `README.md`, `CHANGELOG.md` | **LOW** | Doc-only; no functional regression surface, but #786's CHANGELOG entry is a genuine deliverable, not optional polish (breaking exit-code change for scripts). |

---

## 5. Open Scope Questions for the Human F1 Gate

These are substantive findings from reading the actual BC text (not just the triage report),
and materially change what "implement #786/#787" means. **Flagging explicitly rather than
silently resolving them** — this is exactly the kind of decision an F1 gate exists to catch.

### 5.1 — `status.rs`'s unknown-profile exit code: recommend NOT changing it (contradicts #786's own framing)

The triage report's #786 analysis proposes reclassifying `src/cli/auth/status.rs:~113`
(unknown-profile error) from `UserError`/64 to `ConfigError`/78. Reading the actual specs shows
this would **contradict an existing, deliberate BC**: `BC-1.1.004` (`auth status --profile
<unknown> exits 64 with "unknown profile"`) explicitly pins `JrError::UserError` / exit 64 as the
correct, tested contract for this exact case. This is not an isolated pin — the same "unknown/
not-found profile → exit 64" convention is applied **consistently** across the whole auth
surface: `BC-1.1.003` (`auth switch <unknown>` → 64), `BC-1.1.005` (`auth logout --profile
<unknown>` → 64), `BC-1.1.006` (`auth remove <active>` → 64), and the error-taxonomy's own
"Config / Profile" section (`error-taxonomy.md` §Section 6), which independently documents
`"Profile '<name>' not found"` → 64 and `JR_PROFILE` pointing at a nonexistent profile → 64.

**Recommendation:** treat "profile does not exist" (a usage error — you asked for something
that was never configured) as categorically distinct from "credentials are absent for a profile
that DOES exist" (an authentication error — BC-1.4.032/033's actual target, where reclassifying
to `NotAuthenticated`/2 is well-grounded and uncontested by any existing BC). **Scope #786 down
to the two credential-absence sites in `auth.rs` only; leave `status.rs`'s unknown-profile site
at exit 64, matching BC-1.1.004 and the rest of the taxonomy.** This also resolves the coupling
note in the triage report cleanly — #786 no longer needs a third BC-1.1.004-touching site, only
the two `auth.rs` sites it shares with #784.

**Human decision needed:** confirm this narrowing, or explicitly override BC-1.1.004 (which would
itself need to be an F2 amendment with its own justification, since it's a tested, currently-
passing contract, not a bug).

### 5.2 — #785's env-var precedence is a real design decision, not an implementation detail

Flag → env → keychain, or env → keychain (env-first, so CI/agents never accidentally fall through
to a stale keychain entry), or an opt-in seam (`--no-keychain` / `JR_AUTH_FROM_ENV=1`) that keeps
today's keychain-first behavior as the unconditional default? The triage report flags this as
needing "a small design note, not just a code drop" — concur. Recommend the architect (or a
short F2 ADR addition to ADR-0020, or a new ADR-0023) resolve this explicitly before F3 story
authorship, since it changes the shape of the new BC(s) in §3.

### 5.3 — #787's `status --output json` schema shape needs a decision

`env` field shape is already pinned by BC-1.6.047 (§3). The remaining fields — does `credentials`
render as a bare `bool`, or does it mirror `list`'s coarser `status` string enum? Does the
OAuth-only `oauth_app` field appear as `null` for api-token profiles or be omitted entirely
(the #526 JSON-render invariant doesn't dictate this either way)? Recommend modeling directly on
`render_list_json`'s existing per-profile object shape (`name`/`url`/`env`/`auth_method`/
`status`/`active`) for consistency, with `status` here meaning the SAME truthful vocabulary #788
introduces to `list` — i.e., land #787 and #788 together so `status` and `list` never diverge on
what "configured" means (the triage report's own Cross-Issue Observations §"Truthful auth-state
signaling" cluster already recommends this pairing; concur).

---

## 6. Intent, Trivial-Scope, and Severity Classification (Steps 4b/4c/4d)

**Intent — per issue:**

| Issue | Intent | Signal |
|---|---|---|
| #784 | bug-fix | Broken remediation command, no design surface |
| #785 | enhancement | New capability (headless/non-interactive auth path); triage report calls it "the largest design surface... highest agent value" |
| #786 | bug-fix | Exit-code correctness against an existing, published taxonomy |
| #787 | bug-fix | Missing `--output json` support is a documented gap (NFR-O-N) being closed, not new capability |
| #788 | bug-fix | Truthful status against an existing (self-documented-as-provisional) shortcut |
| #790 | bug-fix (docs) | Factually wrong help text |
| #783 | bug-fix (docs) | Missing migration note |

**Overall bundle intent:** mixed, bug-fix dominant, with one enhancement facet (#785). This
matches the user's framing exactly.

**Trivial-scope assessment (Step 4c): NOT trivial for the bundle as a whole.**
- Impact boundary: spans 7+ files across `src/api/`, `src/cli/auth/`, `src/main.rs`,
  `src/cli/mod.rs` — not single-module/single-file.
- New BCs needed: YES (#785, #787, #788 each need new BC(s); #784/#786 amend existing BC literal
  text — see §3). Trivial-scope requires "no new BCs needed" — bundle fails this criterion outright.
- Architecture change: no structural change, but #785 carries a genuine design decision (§5.2)
  that quick-dev's "no design surface" implicit assumption doesn't fit.
- Regression risk: `src/api/auth.rs` is HIGH (§4), not LOW as trivial-scope requires.

**Individually, #783 and #790 WOULD independently qualify as quick-dev candidates** (doc-only,
no BC change, LOW regression risk) — but bundling them with the other five for one F1-F7 cycle is
efficient given the shared file (`src/api/auth.rs` touches #784/#785/#786; `README.md` touches
both #783 and any #790 README mirror) and shared reviewer context (all seven are one coherent
"auth correctness & DX" story arc). Recommend keeping the bundle together rather than splitting
#783/#790 into a separate quick-dev cycle — the coordination overhead of two parallel cycles
touching adjacent files (`auth.rs`, `README.md`) outweighs quick-dev's compression benefit here.

**Severity (Step 4d, bug-fix issues only):**

| Issue | Severity | Rationale |
|---|---|---|
| #784 | HIGH | Sole remediation path for a mandatory breaking change (BC-1.4.034) is itself broken — every upgraded api-token user hits a dead end. No workaround exists short of reading source. |
| #786 | MEDIUM | Wrappers/agents cannot distinguish "not authenticated" from "bad flags" — both land on 64. Real but non-corrupting; a workaround exists (parse stderr text instead of exit code). |
| #787 | MEDIUM | Scripting hole — `status` is the only command that reports credential presence and it isn't machine-readable. Workaround exists (parse human text, fragile). |
| #788 | MEDIUM | A health check reporting green for an unusable profile is a real agent-usability defect, same class as the exit-0-masking precedent CLAUDE.md documents elsewhere (issue #71 class). No data-loss/security-breach dimension. |
| #790 | LOW | Doc/UX only; the embedded-app path works correctly despite the wrong help text. |
| #783 | LOW | Doc-only; the underlying breaking behavior is intentional and already shipped. |

**No issue is CRITICAL.** Per the workflow's Step 4d criteria (production down / data loss /
security breach), none qualifies — the expedited flow does NOT apply. Standard F1-F7 severity
handling (demo baseline, full F5 adversarial, full F6 hardening, human-gated F7) applies
throughout.

**Security-sensitivity flag (separate from severity):** #785's new credential-resolution surface
is **security-sensitive** even though its bug-fix/enhancement severity is not CRITICAL — reading
live secret values from process environment at command-resolution time (not just login-time, as
today) is a new attack-surface consideration (env leakage via `/proc/<pid>/environ` on Linux,
child-process inheritance, CI log redaction gaps). Flag explicitly for `security-reviewer`
attention at F5/F6, per the user's own framing — concur fully with the validation report here.

---

## 7. Suggested Story Decomposition (for F3)

Two natural clusters plus two standalone stories, matching the triage report's own
Cross-Issue-Observations grouping, refined with the §5 corrections:

**Cluster A — "Fix the broken breaking-change remediation" (#784 + #786's `auth.rs` half).**
One story. Both issues are the SAME two lines in `load_api_token` (`~801`/`~812`) — the message
text (#784) and the error type (#786) change together in one edit to each branch, touch the same
inline test helpers, and amend the same two BCs (BC-1.4.032/BC-1.4.033). Splitting them into two
stories would mean two PRs touching identical lines sequentially for no isolation benefit — do
NOT split. Deliverable: `NotAuthenticated { hint }` (with the corrected `--profile {profile}`
text baked into the hint) replacing `UserError` on both branches; BC-1.4.032/033/034 amended;
4 named inline tests + their 2 shared helpers updated; CHANGELOG breaking-change entry.

**Standalone — #785 (headless/non-interactive auth path).** Its own story, gated on the §5.2
design decision landing first (either as part of this story's own design-note sub-step, or as a
short pre-story architecture note). Largest single deliverable in the bundle (M effort per
triage, new BC subdomain, new VP candidate for the precedence proptest). Do not fold into
Cluster A even though it touches the same function — the design-decision dependency and new-BC
authorship make it a distinct unit of review.

**Cluster B — "Truthful, scriptable auth-state signaling" (#787 + #788, sequenced together).**
Two issues, likely two stories but ONE wave/PR-adjacent pair — landing them together (per §5.3)
avoids `status` and `list` ever briefly disagreeing on what "configured" means. Recommend:
Story B1 (#788, `list.rs` truthful STATUS — smaller, S effort, lands first) establishes the
shared vocabulary/helper; Story B2 (#787, `status --output json`) reuses B1's vocabulary
decision. If capacity allows, B1 could land as its own PR before B2 starts, or both in one PR —
defer the exact split to F3 story-sizing, but keep the vocabulary decision shared.

**Standalone — #790** (`--oauth` help-text correction). Doc-string-only, self-contained (triage
report's own coupling note: "self-contained... one doc string"). Trivial-scope candidate on its
own; bundle into whichever wave has spare capacity, or land as the very first PR in the cycle
(lowest risk, fastest to review, good warm-up for the bundle).

**Standalone — #783** (README migration note). Doc-only, self-contained, but has a soft
dependency on Cluster A landing first if the migration note wants to describe the corrected
`--profile` remediation syntax rather than the current broken one — sequence it AFTER Cluster A,
or write the note in a syntax-neutral way ("run `jr auth login` for that profile") that doesn't
need to cite the exact broken/fixed flag form. Recommend sequencing after Cluster A to avoid a
doc correction needing its own correction later.

**Not proposed as stories (out of scope for this cycle):** none — all 7 issues are in scope,
unlike the `#607`/`#609` deferrals in the components-bundle precedent.

---

## 8. F2 Obligations (not resolved here)

1. Amend BC-1.4.032/BC-1.4.033's literal message text (#784) and error-type clause (#786,
   credential-absence sites only) in the same F2 burst.
2. Resolve §5.1 (status.rs unknown-profile exit code — recommend no change) and record the
   decision explicitly in the F2 spec-evolution artifact, since it reverses part of the triage
   report's original #786 framing.
3. Resolve §5.2 (env-var precedence for #785) — architect decision, likely a short ADR-0020
   addendum or new ADR-0023.
4. Author new BC subdomain "1.7 Non-Interactive Credential Resolution" (or fold into 1.4) for
   #785.
5. Author new BC(s) for #787's status-JSON schema (beyond the `env` field, already covered by
   amending BC-1.6.047 per §3) and #788's truthful-list-status contract, sharing one vocabulary
   decision per §5.3.
6. Retire NFR-O-N (`auth status --output json` deferred) in the NFR catalog once #787 lands.
7. Update `README.md`'s standing CLAUDE.md note about `auth status` having no `--output json`
   support (the "Gotchas"/NFR-O-N line in the project's own CLAUDE.md, not just the PRD NFR
   catalog) — this repo's CLAUDE.md is itself a spec-adjacent artifact per its own conventions
   and will go stale the moment #787 ships if not updated in the same burst.
8. CHANGELOG entry for #786's breaking exit-code change (64→2), styled after the existing
   BC-1.2.051/DEC-321 precedent.
9. `scripts/check-bc-cumulative-counts.sh` will need re-running once new BCs are added (same
   8-surface propagation discipline CLAUDE.md documents for every prior BC-count-changing cycle).

---

## Summary

Seven validated, in-scope auth-surface issues, no invalid or out-of-scope findings, no product
code touched by this F1 pass. `src/api/auth.rs` is the single highest-risk file, consistent with
its HIGH regression-risk rating in both of the two prior cycles (cycle-003, cycle-004) that
already touched these exact lines — this is a THIRD consecutive cycle in this neighborhood, not
a fresh risk. Two BC-mapping findings materially narrow/clarify the original issue-bundle
framing: (1) `status.rs`'s unknown-profile exit code should almost certainly stay at 64
(contradicts BC-1.1.004 + the taxonomy's consistent "profile not found → 64" convention) — scope
#786 down to the two `auth.rs` credential-absence sites only; (2) #787's `env`-field JSON shape
is already normatively pre-specified by BC-1.6.047's EC-1.6.047-2 contingency clause, so F2's
job there is narrower than "design a new schema from scratch." Full F1-F7 routing confirmed
(new BCs needed, HIGH regression-risk module, one security-sensitive design surface) — quick-dev
does not apply to the bundle as a whole, though #783 and #790 would individually qualify if ever
split out. No CRITICAL severity; #785 flagged for mandatory security-reviewer attention at
F5/F6 despite non-CRITICAL severity.

**Human F1 gate: PENDING** — awaiting explicit approval of scope, and a decision on §5.1
(recommend: do not change `status.rs`'s unknown-profile exit code) and §5.2 (env-var precedence
for #785).
