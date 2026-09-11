---
document_type: prd-delta
cycle: cycle-007-auth-correctness-dx
mode: brownfield-feature
phase: F2
producer: product-owner
timestamp: 2026-09-10
status: complete
spec_version_before: "2.2.0"
spec_version_after: "2.3.0"
bump_type: MINOR
inputs:
  - .factory/phase-f1-delta-analysis/cycle-007-auth-delta-analysis.md
  - .factory/phase-f1-delta-analysis/issue-triage-auth-cluster-2026-09-10.md
input-hash: "edce8e8"
---

# Phase F2 PRD Delta — cycle-007 `auth-correctness-dx`

**Scope confirmed at the human F1 gate:** 6 issues (#784, #786-narrowed, #787, #788, #790, #783).
**#785 (headless `JR_EMAIL`/`JR_API_TOKEN` credential resolution) is DEFERRED** per explicit human
decision — no BC, subdomain, or spec surface authored for it this cycle. No product code touched
by this F2 pass.

---

## 1. Architecture: UNCHANGED

Confirmed at F1: no structural/interface redesign. All changes are amendments to existing
`bc-1-auth-identity.md` §1.4/§1.6 contracts, plus 3 new BCs within the ALREADY-EXISTING §1.6
subdomain. No new module, no new ADR-mandated pattern shift, no new crate/module boundary. The one
genuine design-decision surface in the original 7-issue bundle (#785's env-var-precedence question,
F1 §5.2) is moot this cycle since #785 is deferred — no ADR addition was needed or made.

---

## 2. New Behavioral Contracts (3)

All three live in `bc-1-auth-identity.md` §1.6 "Auth Error Handling & 401 Dispatch" (continuing the
existing sequence: BC-1.6.042..047 already occupied; new contracts are BC-1.6.048/049/050 — no
gaps, no collisions).

### BC-1.6.048 — Shared `unset`/`no-credentials`/`configured` auth-state vocabulary

**Resolves:** F1 delta analysis §5.3 (open question) + the locked human decision "define once,
reference from both BCs" (issues #787+#788).

Defines ONE three-state vocabulary — `unset` (no URL configured), `no-credentials` (URL configured,
no usable credential of the KIND matching the profile's configured `auth_method` stored),
`configured` (URL configured AND an auth_method-matching credential is on file) — as the exclusive
source of truth for every command reporting a profile's auth state. **[REVISED 2026-09-10, same-day
F2 fix round, finding F2-H1]** Built on `probe_stored_credential_kind(profile) ->
Result<Option<&'static str>>` (`src/api/auth.rs:~908`, resolves WHICH credential kind, if any, is
stored) compared against the profile's configured `auth_method` — an AUTH_METHOD-AWARE derivation,
not the bare existence-only `profile_has_stored_credentials`. This mirrors the pattern already
shipped today in `src/cli/auth/status.rs::status`'s text path (`method == "oauth" =>
load_oauth_tokens(...).is_ok() else load_api_token(...).is_ok()`). The original draft's "no new
probe mechanism" framing directly contradicted EC-1.6.048-2 (a mismatched-credential-kind profile
must render `no-credentials`, not `configured`); the fix round resolved the contradiction in
EC-1.6.048-2's favor, since that is the locked truthful-status intent of issue #788. Fail-closed on
probe error (renders `no-credentials` + stderr warning, never silently `configured`). Purely a
display/reporting concept — no effect on which command actually authenticates. New safety-invariant
property **VP-AUTHDX-024** asserts `auth list` and `auth status` can never disagree on a profile's
state for the same keychain state (state space now explicitly includes the mismatched-kind case).

**[REVISED AGAIN 2026-09-10, same-day F2 fix round 2, adversary pass-2 finding H1]** The
round-1 revision immediately above is now itself SUPERSEDED: `probe_stored_credential_kind(profile)
== auth_method` was the WRONG comparison. `probe_stored_credential_kind` returns the FIRST-present
kind in a FIXED PRIORITY order (OAuth checked first, returns early) — for an `api_token`-method
profile that also holds an orphaned OAuth pair, it returns `Some("oauth")` (`!= "api_token"`),
falsely yielding `no-credentials` for a profile that IS fully usable via its api-token. Corrected to
a DIRECT kind-specific probe selected by `auth_method` — `oauth` → `load_oauth_tokens(profile)
.is_ok()`; `api_token`/unset/legacy → `load_api_token(profile).is_ok()` — fed into a PURE
`derive_auth_state(url, matching_kind_present: Result<bool>) -> AuthState`, with the CALLER
responsible for selecting/invoking the kind-specific probe. This form (not round 1's) actually
matches `status.rs`'s shipped text path byte-for-byte. See §15 below for the full record.

### BC-1.6.049 — `auth list` STATUS derives from an actual credential probe (issue #788)

`render_list_table`/`render_list_json` (`src/cli/auth/list.rs`) switch from `url.is_some()`-only to
BC-1.6.048's three-state vocabulary — closing a gap the shipped code's own doc comment already
flagged as provisional ("Status today is a coarse… check — credential-store probing comes in Task
13"). JSON `"status"` values become `"unset"`/`"no-credentials"`/`"configured"`; no other schema
field changes. Probing is per-profile and conditional (a `url: None` profile is never probed).
BC-1.6.046's 3-profile fixture ("All STATUS cells `configured`") is flagged via a non-normative
cross-reference note for F4 regeneration, since real probing may not report all three as
`configured`.

### BC-1.6.050 — `auth status --output json` full schema, retires NFR-O-N (issue #787)

`status()` (`src/cli/auth/status.rs`) gains an `&OutputFormat` parameter threaded from `main.rs`'s
dispatch call site. On `--output json`, emits one JSON object:

```json
{
  "profile": "<string>",
  "url": "<string>" | null,
  "env": "<string>" | null,
  "auth_method": "<string>" | null,
  "status": "unset" | "no-credentials" | "configured",
  "oauth_app": "<string>" | null
}
```

Modeled directly on `render_list_json`'s existing per-profile shape (F1 §5.3's explicit
recommendation) for field-name consistency: `url`/`env`/`auth_method`/`status` reuse `list`'s exact
keys; `"profile"` replaces `list`'s `name`+`active` pair (single-profile report, nothing to mark
active against). `"status"` uses BC-1.6.048's vocabulary via the SAME shared auth_method-aware
derivation helper (VP-AUTHDX-024) — never a bare `credentials: bool` (F1 §5.3 resolved this
explicitly in favor of the string-enum shape). `"env"` realizes BC-1.6.047's previously-contingent
Postcondition 2a verbatim/lossless contract. `"oauth_app"` key is always present, `null` when
`auth_method != "oauth"`. Routed through `output::render_json` (#526 invariant). **[REVISED
2026-09-10, same-day F2 fix round, finding F2-H2]** Human-text output is unchanged FOR
CORRECTLY-CONFIGURED PROFILES; for a mismatched-credential-kind profile (EC-1.6.048-2) it is
corrected to agree with the shared derivation, resolving a self-contradiction with BC-1.6.048
Postcondition 3's "no second computed value" guarantee — this correction requires no change to what
`status.rs` already prints today, since its existing `Credentials:` line already performs the
identical auth_method-matching check; the F4 work is routing that check through the shared helper,
not altering its output. **Retires NFR-O-N** (retirement RECORDED by this BC's existence; the
`nfr-catalog.md` row-text edit itself is DEFERRED at F2 — see §7 below and §14).

---

## 3. Amended Behavioral Contracts (3, all `[UPDATED 2026-09-10 issue #784/#786]`)

Per policy, each carries the UPDATED tag and the previous text preserved inline in the BC body
itself (see `bc-1-auth-identity.md`). Summarized here:

### BC-1.4.032 — Legacy shared flat-key detect-and-instruct (Postcondition 2)

| | Before | After |
|---|---|---|
| Remediation command | `jr auth login {profile}` (positional — does NOT parse: `AuthCommand::Login`'s `profile` field is `#[arg(long)]`-only) | `jr auth login --profile {profile}` |
| Error type / exit code | `JrError::UserError` / exit 64 | `JrError::NotAuthenticated` / exit 2 |

Invariant 6, EC-1.4.032-1/4, VP-AUTHDX-005/007's quoted oracle text updated in lockstep.

### BC-1.4.033 — Namespaced-pair partial-write recovery (Postcondition 2)

Identical two-part fix, same two lines in `load_api_token`, same burst (they are the SAME code
path's two error branches — splitting into two stories/two spec edits was explicitly rejected by
both the triage report and the F1 delta analysis as needless duplication). Invariant 2's
remediation-command example, VP-AUTHDX-008's quoted oracle text updated in lockstep.

### BC-1.4.034 — One-time re-login breaking-change contract

Quotes BC-1.4.032's message verbatim, so it drifts whenever that BC's text changes. H1 title
corrected `jr auth login <profile>` → `jr auth login --profile <profile>`; Postcondition 1's quoted
message and Postconditions 2/3's command syntax corrected to match. New **cycle-007 addendum**
added to its existing F4 doc-fallout obligation: the exit-code change (64→2) is itself an
observably breaking change for any script/CI wrapper that greps for exit 64 on this credential-
absence path — the F4 implementing story MUST add a CHANGELOG breaking-change entry styled after
the existing BC-1.2.051/DEC-321 precedent.

### 3.1 — Scope narrowing (§5.1, locked at the F1 gate — reverses part of #786's original framing)

**`src/cli/auth/status.rs`'s unknown-profile error is explicitly and deliberately NOT changed.** It
stays `JrError::UserError`/exit 64. **BC-1.1.004 is UNTOUCHED.** Rationale: "profile does not exist"
(a usage error — you asked for something never configured) is categorically distinct from "profile
exists but has no stored credentials" (an authentication error). The taxonomy's consistent
"profile not found → 64" convention already applies uniformly across `auth switch`/`auth logout`/
`auth remove` (BC-1.1.003/005/006) and `error-taxonomy.md`'s own Config/Profile section — reclassi-
fying `status.rs`'s site would have contradicted this established, tested, currently-passing
contract, not fixed a bug. This narrows #786 down to the two `src/api/auth.rs` credential-absence
sites it shares with #784 — the coupling the triage report already identified.

---

## 4. Contingency Resolution: BC-1.6.047 (`[UPDATED 2026-09-10 issue #787]`)

EC-1.6.047-2 previously stated `auth status --output json`'s `env`-field JSON obligation
(Postcondition 2a) was CONTINGENT on NFR-O-N's resolution. That contingency is now RESOLVED — BC-
1.6.050 realizes it. Postcondition 2a and EC-1.6.047-1 updated from contingent/hypothetical
phrasing to active/realized phrasing. No other text changes — the field's shape was already
correctly pre-specified; F2's job here was narrower than "design a new schema from scratch," per
F1's own finding.

---

## 5. Light-touch additions (not counted as "amended")

- **BC-1.6.046** gains a non-normative cross-reference note (Behavior section) flagging its
  3-profile fixture's "All STATUS cells `configured`" line for F4 regeneration once BC-1.6.049
  ships. No wire-shape or Postcondition change.
- **BC-1.2.049** gains **EC-1.2.049-3** (issue #790, non-blocking): documents that
  `check_noninteractive_oauth_guard`'s rejection already correctly suppresses the deprecation
  notice — the actual defect (per validated triage) was `src/cli/mod.rs`'s `--oauth` help string
  overclaiming unconditional emission, a doc-string-only fix outside this BC's Postconditions/
  Invariants.

---

## 6. Doc-deltas (no BC change)

### 6.1 — Issue #790 (`--oauth` help text)

No BC pins the literal CLI help-text wording (it's a doc comment, not a tested contract). Captured
as a doc-delta:

- **Primary defect:** `src/cli/mod.rs`'s `AuthCommand::Login`'s `--oauth` doc comment states
  "(requires your own OAuth app)" — factually wrong given jr's embedded OAuth app (ADR-0006,
  `embedded_oauth_app_present()`, resolver order flag→env→keychain→embedded→prompt). Corrected
  wording should state the embedded default and describe `--client-id`/`--client-secret`/
  `JR_OAUTH_CLIENT_ID`/`_SECRET` as an OPTIONAL override, not a requirement.
- **Secondary (a):** the same doc string overclaims the deprecation notice is printed
  unconditionally in human mode — runtime behavior is ALREADY correct (guard rejection precedes the
  notice, EC-1.2.049-3 §5 above); only the doc string needs to stop overclaiming.
- **Secondary (b), optional/declineable:** clap's default conflict-rendering echoes `--oauth` back
  in the usage line for the symmetric `conflicts_with`. This is clap default behavior, not a
  `jr`-authored string; fixing it means overriding usage rendering, not the `conflicts_with`
  declaration. Recommend NOT fixing this cycle (cosmetic, low value, higher implementation cost).

**F4 deliverable:** `src/cli/mod.rs` doc-comment edit only (no `#[arg(...)]` attribute change).

### 6.2 — Issue #783 (README migration note)

Doc-only, scoped to the migration-note gap only (the primary README claim — "shared credential
model" — was already remediated before this cycle, per the validated triage report). **F4
deliverable:** add to `README.md`'s existing migration section (near the `[instance]`→
`[profiles.default]` reshape note) a bullet covering: pre-cycle-003 api-token profiles must run
`jr auth login --profile <name>` once after upgrading (BC-1.4.034's breaking-change contract, now
with the corrected `--profile` syntax from this cycle), and the deliberate OAuth-vs-api-token
migration asymmetry (OAuth lazy-migrates flat→namespaced keys; api-token does NOT, per BC-1.4.032's
no-copy detect-and-instruct design). Recommend sequencing this edit AFTER the code change lands, so
the note can cite the corrected `--profile` syntax directly rather than needing its own follow-up
correction.

---

## 7. NFR-O-N Retirement

**Retired** in `nfr-catalog.md` (was `DEFER-DOCUMENTED`, LOW severity) — `auth status --output
json` is now specified by BC-1.6.050. Row RETAINED (not deleted) per the standing retirement
convention; `total_nfrs` unchanged at 42 (retiring a row is a status-field change, not a
row-count change — `scripts/check-spec-counts.sh` validates row count only, unaffected).

**Known limitation — nfr-catalog.md edit deferred, NOT applied this burst:** `nfr-catalog.md`
carries pre-existing TD-VSDD-091/TD-031 stable-anchor debt (≥14 `*.rs:NNN`-style volatile line
citations across unrelated NFR rows — NFR-R-D, NFR-R-A, NFR-R-E, NFR-R-F, NFR-R-G, and others,
none touched by this cycle's diff). The repo's `validate-stable-anchors` hook fail-closed-blocks
**any** edit to a file carrying such debt, regardless of whether the edit's own diff introduces a
new violation — confirmed by testing both `Edit` and `Write` against this file, both refused. This
is the SAME class of blocker `CANONICAL-COUNTS.md`'s own history already documents for
`bc-6-config-cache.md` in cycle-004 ("a planned BC-6.2.016 cross-reference amendment was deferred —
pre-existing TD-031 stable-anchor hygiene violation in that file blocks edits, unrelated to this
cycle's diff"). Consistent with that precedent, the `nfr-catalog.md` row-text edit is DEFERRED, not
silently dropped: NFR-O-N's retirement IS fully recorded and traceable via (a) BC-1.6.050's own
Invariant 2 ("NFR-O-N is RETIRED by this BC's existence"), (b) BC-1.6.047's amendment resolving the
contingency, (c) `spec-changelog.md`'s new `[2.3.0]` entry, and (d) this delta document. The actual
`nfr-catalog.md` row-text update (Phase 3 Routing cell → `RETIRED`, BC Anchor → `BC-1.6.050`,
Summary Table row, bucket-count reconciliation) is a **carried-forward F2b/maintenance-sweep task**
once the file's pre-existing TD-031 debt is separately remediated (out of this cycle's scope — the
debt predates and is unrelated to cycle-007's diff). `check-spec-counts.sh`'s NFR row-count
assertion is unaffected either way, since no row was added or removed.

**[REVISED 2026-09-10, same-day F2 fix round, finding F2-M2]** This same pending edit is now ALSO
tracked explicitly as BC-1.6.050's F4 doc-fallout obligation (a) — "F2b/maintenance-sweep task" and
"F4 doc-fallout obligation" name the identical deferred row-text edit via two different
obligation-tracking mechanisms already used elsewhere in this corpus; whichever burst first clears
the TD-031 blocker performs it. Prior to this fix round, BC-1.6.050's F4 doc-fallout clause (a) and
`spec-changelog.md`'s `[2.3.0]` entry both incorrectly stated the row edit was "already done at F2"
— both corrected to state DEFERRED, matching this section's (always-accurate) account.

---

## 8. Shared "configured"/auth-state vocabulary (locked decision, §787+§788)

Defined ONCE at **BC-1.6.048**, referenced (not re-derived) by both:
- **BC-1.6.049** (`auth list`'s `status` column/field)
- **BC-1.6.050** (`auth status --output json`'s `status` field)

**[REVISED 2026-09-10, same-day F2 fix round, finding F2-H1 — was existence-only, now
auth_method-aware]** Vocabulary: `unset` (`url.is_none()`) / `no-credentials` (`url.is_some()` AND
the stored credential kind, per `probe_stored_credential_kind(profile)`, does NOT match the
profile's configured `auth_method` — including the case where nothing at all is stored) /
`configured` (`url.is_some()` AND the stored credential kind MATCHES the profile's configured
`auth_method`). This is the same pattern `src/cli/auth/status.rs::status`'s text path already
ships today (`method == "oauth" => load_oauth_tokens(...).is_ok() else
load_api_token(...).is_ok()`) — the fix round formalizes it as the ONE shared derivation rather than
leaving `list`'s (new) vocabulary as a separately-computed, existence-only approximation that could
disagree with it on a mismatched-credential-kind profile (EC-1.6.048-2). Fail-closed on probe error
→ `no-credentials` + stderr warning. New property **VP-AUTHDX-024** is the mechanism that keeps this
guarantee regression-proof: it asserts both commands call the SAME shared derivation helper, not two
independently-maintained implementations that could silently drift apart again.

**[REVISED AGAIN 2026-09-10, same-day F2 fix round 2, adversary pass-2 finding H1 — the round-1
text immediately above is SUPERSEDED]** The round-1 comparison `probe_stored_credential_kind(profile)
== auth_method` was itself wrong, and the claim that it "is the same pattern `status.rs`'s text path
already ships" was FALSE. `probe_stored_credential_kind` returns the FIRST-present credential kind
in a FIXED PRIORITY order (OAuth checked first, returns early) — it cannot report "the kind matching
`auth_method`" once a profile holds credentials of BOTH kinds. Concretely: an `api_token`-method
profile that ALSO holds a stored (orphaned) OAuth pair has `probe_stored_credential_kind` return
`Some("oauth")` (`!= "api_token"`), so round 1's comparison rendered `no-credentials` for a profile
that IS fully usable via its api-token — a false negative, the opposite of #788's truthful-status
intent, on a real, actively-managed state (`probe_stored_credential_kind` exists specifically to
detect orphaned-pair states).

**Corrected vocabulary (round 2, locked design):** the credential-present predicate is "a stored
credential of the KIND MATCHING the profile's configured `auth_method` exists," probed DIRECTLY —
`auth_method == "oauth"` → `load_oauth_tokens(profile).is_ok()`; `auth_method == "api_token"` (or
unset/legacy) → `load_api_token(profile).is_ok()` — never via a comparison against
`probe_stored_credential_kind`'s output. Preferred shape: a PURE `derive_auth_state(url:
Option<Url>, matching_kind_present: Result<bool>) -> AuthState`, where the CALLER computes
`matching_kind_present` by invoking the kind-specific probe selected by `auth_method`. This form
DOES byte-for-byte match `status.rs`'s shipped text-path check — round 1's did not, despite claiming
to. `probe_stored_credential_kind` is NOT removed or deprecated — it remains valid for its own
distinct purpose (`login.rs`'s post-mechanism-switch orphaned-pair cleanup) — it is simply the wrong
primitive for this predicate. An `api_token`-method profile holding BOTH an api-token pair AND an
orphaned OAuth pair is `configured` (usable) under the corrected design — this is the concrete case
round 1 got wrong. Fail-closed on probe error is unchanged: an `Err` from the kind-specific probe
(the SAME probe Postcondition 2 uses — not a separately-named `profile_has_stored_credentials`
error, finding M3) renders `no-credentials`, never `configured`. Full record: §15 below.

---

## 9. New edge cases

Added to `.factory/specs/prd/edge-case-catalog.md` (§EC-AUTH):

- **EC-AUTH-010** — credential-absence remediation command must parse (#784).
- **EC-AUTH-011** — credential-absence exit code is `NotAuthenticated`/2, narrowly scoped, vs. the
  unrelated unknown-profile `UserError`/64 site (#786).
- **EC-AUTH-012** — `auth list`/`auth status` truthful-status vocabulary parity (#787+#788).

Also added inline to the amended BC bodies themselves (per this project's established convention
of edge cases living primarily inside BC files): EC-1.2.049-3 (#790), plus updates to
EC-1.4.032-1/4, EC-1.6.046 (cross-reference note), EC-1.6.047-1/2/3.

---

## 10. Error taxonomy updates

`.factory/specs/prd/error-taxonomy.md` §6 Auth Commands: two new rows for `load_api_token`'s
credential-absence sites (now exit 2), one row confirming `auth status --profile <unknown>` stays
exit 64, plus a new disambiguation note distinguishing the two failure classes (mirroring the
existing disambiguation-note pattern already used for the two invalid-profile-name mechanisms).
Section 1's `NotAuthenticated` variant description ("no token in keychain") already covered this
case with no wording change needed.

---

## 11. Spec version bump

**MINOR: 2.2.0 → 2.3.0** — 3 new BCs, 3 amended BCs (narrowly-scoped correctness fixes, not removed/
restructured behavior), 1 NFR retired (row-retained), 6 new VPs — VP-AUTHDX-024 (the `auth list`/
`auth status` vocabulary-parity SAFETY INVARIANT) plus VP-AUTHDX-025..029 — bringing the VP corpus
total to **82**, consistent with `cycle-007-verification-delta.md`. No breaking spec-shape change (the
underlying CODE change IS observably breaking for exit-64-grepping scripts — see BC-1.4.034's
cycle-007 addendum — but that is a PRODUCT-semver concern for the F4 implementing story's
CHANGELOG, not a SPEC-document-shape MAJOR bump; per this changelog's own Type-legend distinction,
"Type classifies the SPEC document delta... Product-semver impact is recorded in the Summary line,
independent of Type").

Changelog entry appended: `.factory/spec-changelog.md` `[2.3.0] - 2026-09-10`.

---

## 12. Count reconciliation (both guards verified green)

| Surface | Before | After |
|---|---|---|
| `bc-1-auth-identity.md` frontmatter `total_bcs` | 80 | 83 |
| `bc-1-auth-identity.md` frontmatter `definitional_count` | 69 | 72 |
| `bc-1-auth-identity.md` body preamble prose | "80 behavioral contracts" | "83 behavioral contracts" |
| `bc-1-auth-identity.md` Summary Stats §1.6 row | 6 | 9 |
| `bc-1-auth-identity.md` Summary Stats Total row | 69 (68 HIGH, 1 MEDIUM) | 72 (71 HIGH, 1 MEDIUM) |
| `BC-INDEX.md` frontmatter `total_bcs` | 754 | 757 |
| `BC-INDEX.md` frontmatter `sections:` bc-1 entry | 80 / 69 | 83 / 72 |
| `BC-INDEX.md` `## Section 1:` header | 80 cumulative / 69 individually-bodied | 83 / 72 |
| `BC-INDEX.md` `### 1.6` subdomain header | 6 BCs: BC-1.6.042..047 | 9 BCs: BC-1.6.042..050 |
| `BC-INDEX.md` `index_version` | v6.86 | v6.87 |
| `CANONICAL-COUNTS.md` per-file definitional (bc-1 row) | 69 | 72 |
| `CANONICAL-COUNTS.md` Total individually-bodied | 524 | 527 |
| `CANONICAL-COUNTS.md` per-file total_bcs (bc-1 row) | 80 | 83 |
| `CANONICAL-COUNTS.md` **Sum** row | 754 | 757 |
| `CANONICAL-COUNTS.md` grand-total prose | 754 | 757 |

**Guard results (both re-run after all edits, both green):**

```
$ bash scripts/check-spec-counts.sh
Check passed: 8 bc files validated

$ bash scripts/check-bc-cumulative-counts.sh
OK: all cumulative BC counts verified (757 total across 9 files; Surface H footer checked where present).
```

---

## 13. Files written/updated this burst (absolute paths)

**Written (new):**
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/phase-f2-spec-evolution/cycle-007-prd-delta.md` (this file)

**Updated:**
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/bc-1-auth-identity.md` (3 new BCs, 3 amended BCs, 2 light-touch additions, frontmatter/preamble/Summary-Stats count sync)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/BC-INDEX.md` (frontmatter, Section 1 header, §1.6 subdomain header, 3 row amendments, 3 new rows, index_version bump)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/CANONICAL-COUNTS.md` (per-file tables, Sum row, grand-total prose, L2-alignment row)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/edge-case-catalog.md` (3 new EC-AUTH entries, frontmatter trace)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/error-taxonomy.md` (2 new Auth Commands rows, 1 confirming row, disambiguation note, frontmatter trace)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/spec-changelog.md` (new `[2.3.0]` entry)

**NOT updated (deferred, pre-existing blocker, documented in §7 above):**
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/nfr-catalog.md` (NFR-O-N retirement recorded elsewhere; row-text edit blocked by pre-existing TD-031 debt unrelated to this cycle's diff)

**Not touched (per task scope — story bodies and product code):**
- No files under `.factory/stories/` or `src/` were read for editing or modified.

**Not committed** — per instruction, state-manager commits at F2 close. `STATE.md`'s own BC-count
references (currently 754/76/118/175 as of the F1-gate burst) will need reconciliation to 757 by
state-manager in the same close-out burst; this was flagged repeatedly by the
`validate-count-propagation` hook during this F2 pass (expected — `STATE.md` is exclusively
state-manager's surface, not touched here).

---

## 14. Adversary Fix Round — 3 findings, same day (2026-09-10, pre-commit)

A fresh-context adversarial pass over this delta before commit found 3 findings against
BC-1.6.048/049/050 as originally drafted above. All 3 are resolved in this document and in
`bc-1-auth-identity.md`; no `#### BC-` heading was added or removed (total_bcs stays 83,
definitional_count stays 72 — both guards re-verified green below).

### F2-H1 [HIGH] — shared probe was not auth_method-aware, contradicting EC-1.6.048-2

**Contradiction:** BC-1.6.048 Postcondition 2 (as originally drafted, §2/§8 above prior to this
round's edits) specified the vocabulary as built on the bare existence-only
`profile_has_stored_credentials` probe ("no new probe mechanism"). EC-1.6.048-2 required a
mismatched-credential-kind profile (e.g. an `oauth`-method profile holding only a stored api-token
pair) to render `no-credentials`. These are mutually unsatisfiable under an existence-only probe —
existence-only sees ANY stored pair as evidence of `configured`, regardless of kind.

**Resolution (locked direction — the truthful-status intent of #788):** the shared derivation is now
AUTH_METHOD-AWARE. It compares `probe_stored_credential_kind(profile)` (`src/api/auth.rs:~908`,
already-shipped) against the profile's configured `auth_method`; a profile reports `configured` only
when the stored kind matches. This is exactly the pattern `src/cli/auth/status.rs::status`'s text
path already implements today (`method == "oauth" => load_oauth_tokens(...).is_ok() else
load_api_token(...).is_ok()`) — the fix formalizes existing shipped behavior as the ONE shared
helper, rather than inventing new semantics. The "no new probe mechanism" phrasing is retired; a
small new shared helper (composing `probe_stored_credential_kind`) is explicitly permitted.

**Edits made:** `bc-1-auth-identity.md` BC-1.6.048 Postconditions 1-3 (auth_method-aware derivation,
Source field citations added), EC-1.6.048-2 (confirmed-consistent note), VP-AUTHDX-024 (state space
and probe description updated); BC-1.6.049 Source/Description/Postcondition 4/new EC-1.6.049-4
(append-only, does not renumber -1/-2/-3)/VP-AUTHDX-025/H1 title (enriched per
`bc_h1_is_title_source_of_truth`); BC-1.6.050 Postcondition 2 cross-reference. §2 and §8 above
revised to match. **Consistent across BC-1.6.048/049/050** — confirmed by re-reading all three BC
bodies after the edit: all three now describe the identical auth_method-aware derivation and cite
the same `probe_stored_credential_kind` primitive.

### F2-H2 [HIGH] — BC-1.6.048 P3 vs BC-1.6.050 P6 text-channel contradiction

**Contradiction:** BC-1.6.048 Postcondition 3 ("auth status text renders THIS vocabulary via THIS
derivation; no second computed value exists") contradicted BC-1.6.050 Postcondition 6's unconditional
"human-text output is BYTE-FOR-BYTE UNCHANGED" — the latter implied the text channel keeps its own,
separate, unshared logic, which is exactly what P3 forbids.

**Resolution:** BOTH `auth list` and `auth status` (text AND json) now derive from the ONE
auth_method-aware shared value (satisfying P3). BC-1.6.050 Postcondition 6 reworded from
unconditional to: unchanged for correctly-configured profiles; corrected for mismatched-kind
profiles per the shared derivation. Investigation of the shipped code
(`src/cli/auth/status.rs::status`, read in full during this fix round) confirms the `Credentials:`
line ALREADY performs the auth_method-matching check today — so this "correction" requires no change
to what the text path prints, only that F4 route the existing check through the shared helper rather
than reimplement it inline. P3 and P6 now agree; a mismatched-kind profile can no longer produce
disagreement between `auth list` STATUS and `auth status` text, because both read the same helper.

> **SUPERSEDED (2026-09-10, adversary pass-3, finding F6 — see §16 below):** the "corrected for
> mismatched-kind profiles per the shared derivation" wording immediately above was itself a
> misnomer, since (as this very Resolution paragraph already says) `status.rs`'s `Credentials:` line
> already performs the correct auth_method-matching check today — nothing about its OUTPUT changes
> for any profile, mismatched-kind included; only the INTERNAL DERIVATION is re-sourced through the
> shared `derive_auth_state` helper. Pass-3 finding F6 reworded BC-1.6.050 Postcondition 6 and
> VP-AUTHDX-026 point 6 to say output is byte-for-byte UNCHANGED IN ALL CASES (never a "correction"),
> which is the CURRENT, authoritative wording in `bc-1-auth-identity.md`. This paragraph is retained
> verbatim as the historical record of round 1's (superseded) framing — do not read it as the current
> design; see §16 for the full round-3 record.

**Edits made:** `bc-1-auth-identity.md` BC-1.6.050 Postcondition 6, VP-AUTHDX-026 point 6, and its
F4 test-criteria line. Formal-verifier's separate F2-M1 follow-on (a new VP for the text channel) can
now anchor to Postcondition 6's revised, non-contradictory wording.

### F2-M2 [MEDIUM] — NFR-O-N "already done at F2" was false

**Contradiction:** BC-1.6.050's F4 doc-fallout clause (a) and `spec-changelog.md`'s `[2.3.0]` entry
both stated the `nfr-catalog.md` row was "already done at F2 — see that file's updated row." The row
is still `DEFER-DOCUMENTED` — the edit was blocked by the file's pre-existing TD-031 stable-anchors
hook debt, correctly and fully documented in §7 above (which needed no correction — it already said
DEFERRED).

**Resolution:** both false-positive surfaces corrected to state DEFERRED, matching §7's
already-accurate account, and reframed as an explicit F4 doc-fallout obligation (not
already-applied). The `nfr-catalog.md` row-text edit itself was NOT attempted (TD-031 would block
it, as tested and documented in §7) — only the STATUS claims were corrected.

**Edits made:** `bc-1-auth-identity.md` BC-1.6.050 F4 doc-fallout obligation (a) and Trace field;
`.factory/spec-changelog.md` `[2.3.0]` entry (the "NFR-O-N RETIRED in `nfr-catalog.md`" line);
§7/§8 above cross-linked to this section.

### Guard re-verification (after fix-round edits)

```
$ bash scripts/check-spec-counts.sh
Check passed: 8 bc files validated

$ bash scripts/check-bc-cumulative-counts.sh
OK: all cumulative BC counts verified (757 total across 9 files; Surface H footer checked where present).
```

No count-affecting change was made — this round only revised Postcondition/EC/VP/Trace prose and
added one append-only edge case (EC-1.6.049-4), which is not a `#### BC-` heading and is not counted
by either guard.

### Files touched in this fix round (absolute paths)

- `/Users/zious/Documents/GITHUB/jira-cli/.factory/phase-f2-spec-evolution/cycle-007-prd-delta.md` (this file — §2, §7, §8, this §14)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/bc-1-auth-identity.md` (BC-1.6.048/049/050 bodies + frontmatter trace)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/spec-changelog.md` ([2.3.0] entry)

**Not touched:** story bodies (`.factory/stories/`), product code (`src/`), `BC-INDEX.md`,
`CANONICAL-COUNTS.md`, `nfr-catalog.md` — none of these needed a content change for these 3 findings
(no BC added/removed/retitled-without-precedent in a way that changes counts). **Flagged, not
fixed:** BC-1.6.049's H1 heading was enriched per `bc_h1_is_title_source_of_truth` (auth_method-aware
wording moved from body into the title); `BC-INDEX.md`'s title column for BC-1.6.049 is now stale
against that H1 and needs a follow-up sync — out of this fix round's explicit file scope, called out
here so it isn't silently lost. **Not committed** — same as the rest of this document.

---

## 15. Adversary Fix Round 2 — 2 findings, same day (2026-09-10, pre-commit)

A SECOND fresh-context adversarial pass ("adversary pass-2") over this delta and
`bc-1-auth-identity.md`, run after the §14 fix round above had already landed, found 2 NEW findings
against BC-1.6.048/049/050 as revised by §14. Both are resolved in this document and in
`bc-1-auth-identity.md`; no `#### BC-` heading was added or removed (total_bcs stays 83,
definitional_count stays 72 — both guards re-verified green below).

### H1 [HIGH] — §14's own F2-H1 fix used the wrong comparison primitive

**Defect:** §14's F2-H1 fix (immediately above) corrected the ORIGINAL existence-only defect, but in
doing so introduced a NEW, independent defect: it specified the auth_method-aware credential-present
predicate as `probe_stored_credential_kind(profile) == auth_method`, and claimed this "is the SAME…
pattern" as `status.rs`'s shipped text-path check. That claim is FALSE.
`probe_stored_credential_kind` (`src/api/auth.rs:~908`) returns the FIRST-present credential kind in
a FIXED PRIORITY order — it checks for a namespaced OAuth pair first and returns `Some("oauth")`
immediately if found, before ever checking for an api-token pair. It therefore cannot answer "does
THIS profile hold a credential of THIS SPECIFIC kind" — only "what is the highest-priority kind this
profile holds, if any."

**Concrete failure case:** an `api_token`-method profile that ALSO holds a stored (orphaned/unused)
OAuth pair — e.g. left behind by a prior mechanism switch that predates BC-1.4.039's cleanup fix, or
simply never cleared. `probe_stored_credential_kind` returns `Some("oauth")` for this profile
(OAuth checked first, found, returned immediately — the api-token pair is never even examined).
`"oauth" != "api_token"` (the profile's configured `auth_method`), so §14's comparison-based
derivation yields `no-credentials`. But the profile IS fully usable: `load_api_token(profile)
.is_ok()` succeeds, exactly as it did before this cycle's changes. This is a FALSE NEGATIVE — the
derivation reports a usable profile as unusable — the precise opposite of issue #788's truthful-status
intent, and worse than the pre-cycle-007 status quo for this specific profile shape (the OLD
`url.is_some()`-only check at least reported `configured`, correctly by accident, for this case; the
`probe_stored_credential_kind`-based "fix" made it WORSE). `probe_stored_credential_kind`'s own doc
comment (`src/api/auth.rs`) confirms it exists specifically to detect orphaned-pair states after a
mechanism switch — this both-kinds-stored case is a real, actively-managed state, not a theoretical
corner.

**Locked correct design (respecified consistently across every surface):** the credential-present
predicate is "a stored credential of the kind MATCHING the profile's configured `auth_method`
exists" — probed by the KIND-SPECIFIC check, i.e. equal to what the text path already does today:

- `auth_method == oauth` → OAuth pair present (`load_oauth_tokens(profile).is_ok()`)
- `auth_method == api_token` → api-token pair present (`load_api_token(profile).is_ok()`)

NOT `probe_stored_credential_kind(p) == auth_method`. Preferred structure: a PURE
`derive_auth_state(url: Option<Url>, matching_kind_present: Result<bool>) -> AuthState` (3-value
enum), where the CALLER computes `matching_kind_present` via the kind-specific probe selected by
`auth_method`. This keeps `derive_auth_state` pure/testable and puts auth_method-matching in the
caller — and it byte-for-byte matches the existing `status.rs` text-path check (round 1's
`probe_stored_credential_kind`-comparison form did not, despite claiming to).
`probe_stored_credential_kind` is NOT removed from the codebase or this spec corpus — it remains a
distinct, valid helper for a DIFFERENT purpose (`login.rs`'s post-mechanism-switch orphaned-pair
cleanup, FIX-F5-CYCLE4-1 LOW-1) — it is simply the wrong primitive for THIS predicate.

**Both-kinds case, explicitly stated:** an `api_token`-method profile holding BOTH a stored
api-token pair AND an orphaned OAuth pair is `configured` (usable) — the presence of an unused
credential of the non-matching kind must never suppress a profile's usable, matching-kind
credential. (The symmetric case — an `oauth`-method profile holding both pairs — was already
correct under round 1's design too, since `probe_stored_credential_kind`'s OAuth-first priority
happens to agree with what an `oauth`-method profile needs; it is specifically the
`api_token`-method-with-orphaned-OAuth-pair direction round 1 got wrong.)

**Every false certification removed:** every claim in `bc-1-auth-identity.md` and this document that
the round-1 `probe_stored_credential_kind`-comparison derivation "byte-for-byte reproduces" or "is
the same pattern as" / "mirrors" `status.rs`'s shipped text-path check has been corrected — those
claims were false (round 1's form and the text path's form disagree on the both-kinds case). The
corrected kind-specific-probe form is what actually matches, and every surface now says so
explicitly rather than asserting an unverified equivalence.

**Edits made:** `bc-1-auth-identity.md` — BC-1.6.048: new "STATUS: REVISED AGAIN" paragraph,
Postcondition 2 (full rewrite to the kind-specific-probe/pure-`derive_auth_state` design), EC-1.6.048-2
(annotated), new EC-1.6.048-4 (append-only, both-kinds worked example), VP-AUTHDX-024 (probe
citation + state-space corrected), Source field (probe citations corrected), Trace field (round-2
note appended). BC-1.6.049: Source, Description, EC-1.6.049-4 (cross-reference note), VP-AUTHDX-025,
Trace field. BC-1.6.050: Postcondition 2 (cross-reference note), Postcondition 6 (consistency note —
P6's own citation was already correct; it was P2 that disagreed with it), Trace field. This document
(`cycle-007-prd-delta.md`): §2 (BC-1.6.048 block, new paragraph), §8 (new paragraph superseding the
F2-H1 paragraph), this §15. Frontmatter `trace:` changelog in `bc-1-auth-identity.md` gains a new
round-2 entry (line 11).

**Consistency confirmed:** re-read all three BC bodies (BC-1.6.048/049/050) after the edit — all
three now describe the identical kind-specific-probe derivation and no longer cite
`probe_stored_credential_kind` as the comparison primitive anywhere (its remaining citations are
either (a) historical audit-trail text describing round 1's now-superseded design, explicitly marked
superseded, or (b) explanations of why it is the WRONG primitive here and what it is still used for
elsewhere).

### M3 [MEDIUM] — Postcondition 4 / EC-1.6.050-3 named a THIRD, different function as "the probe"

**Defect:** independent of H1, BC-1.6.048 Postcondition 4 (the fail-closed/probe-error path) and
BC-1.6.050 EC-1.6.050-3 (the JSON-channel analog) both named `profile_has_stored_credentials`
(`src/api/auth.rs:~873`) — the existence-only wrapper around `probe_stored_credential_kind` — as
"the probe" whose error triggers fail-closed rendering. This is a THIRD distinct function, different
from both Postcondition 2's (now-corrected) kind-specific probe AND round 1's (superseded)
`probe_stored_credential_kind`. Leaving P2 and P4 naming two different functions is a corpus
consistency defect in its own right — the reader cannot tell whether the "probe" P4 fails on is the
same one P2 succeeds on, which undermines the "no second, independently-computed value" guarantee
BC-1.6.048 Postcondition 3 claims.

**Resolution:** Postcondition 4 and EC-1.6.050-3 both reconciled to reference the SAME kind-specific
probe mechanism Postcondition 2 now uses (`load_oauth_tokens`/`load_api_token`, selected by
`auth_method`) — under the pure-`derive_auth_state` shape, an `Err` in the caller-computed
`matching_kind_present: Result<bool>` parameter (rather than a `profile_has_stored_credentials`-
specific error) is what triggers the fail-closed `no-credentials` rendering. This holds
unconditionally by construction (any `Err` maps to `no-credentials`, never `configured`) — no
special-casing required. A scope note was added acknowledging that `load_oauth_tokens`/
`load_api_token` conflate "genuine backend/keychain error" and "ordinary absence" into the same
`Err` variant (both are `Err` of the same `Result`); the F4 implementing story MAY inspect/downcast
the error for warning-precision, but Postcondition 4's BINDING guarantee (fail-closed, never
silently `configured`) does not depend on that distinction. `profile_has_stored_credentials` is no
longer cited as a probe mechanism anywhere in BC-1.6.048/049/050.

**Edits made:** `bc-1-auth-identity.md` — BC-1.6.048 Postcondition 4 (full rewrite, citation
corrected + scope note added), Trace field (round-2 note covers this too). BC-1.6.050 EC-1.6.050-3
(citation corrected), Trace field (round-2 note covers this too). This document
(`cycle-007-prd-delta.md`): §8 (new paragraph notes the fail-closed reconciliation), this §15.

### Guard re-verification (after fix-round-2 edits)

```
$ bash scripts/check-spec-counts.sh
Check passed: 8 bc files validated

$ bash scripts/check-bc-cumulative-counts.sh
OK: all cumulative BC counts verified (757 total across 9 files; Surface H footer checked where present).
```

No count-affecting change was made — this round only revised Postcondition/EC/VP/Source/Trace prose
and added one append-only edge case (EC-1.6.048-4), which is not a `#### BC-` heading and is not
counted by either guard. `total_bcs` stays 83; `definitional_count` stays 72.

### Files touched in this fix round (absolute paths)

- `/Users/zious/Documents/GITHUB/jira-cli/.factory/phase-f2-spec-evolution/cycle-007-prd-delta.md` (this file — §2, §8, this §15)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/bc-1-auth-identity.md` (frontmatter `trace:` changelog; BC-1.6.048/049/050 bodies)

**Not touched:** story bodies (`.factory/stories/`), product code (`src/`), `BC-INDEX.md`,
`CANONICAL-COUNTS.md`, `nfr-catalog.md`, `spec-changelog.md` — none of these needed a content change
for these 2 findings (prose-only correctness fix within already-existing BCs; no BC
added/removed/retitled, no count change, no NFR/error-taxonomy/interface change). Verification-delta
§3's signature description and VP-count reconciliation are the formal-verifier's separate, parallel
fix under the same locked design — not touched here (see task scope). **Not committed** — same as
the rest of this document; state-manager commits at F2 close.

---

## 16. Adversary Fix Round 3 — pass-3 finding F6 (2026-09-10, retroactively recorded here, adversary pass-4 finding F-1)

A THIRD fresh-context adversarial pass ("adversary pass-3") over `bc-1-auth-identity.md`, run after
the §15 fix round above had already landed, found 1 finding against BC-1.6.050 Postcondition 6 /
VP-AUTHDX-026 point 6 as revised by §14 (finding F2-H2). The fix was applied directly to
`bc-1-auth-identity.md` at the time, but this document was never updated with a corresponding
section — leaving the delta trail silently out of sync with the BC body (the exact defect adversary
pass-4 finding F-1 caught and this section retroactively closes). No `#### BC-` heading was added or
removed by this round; total_bcs stayed 83, definitional_count stayed 72.

### F6 [MEDIUM] — §14's F2-H2 fix mischaracterized the text-channel change as a "correction"

**Defect:** §14's F2-H2 fix (above) reworded BC-1.6.050 Postcondition 6 from an unconditional
"byte-for-byte unchanged" claim to "unchanged for correctly-configured profiles; corrected for
mismatched-kind profiles per the shared derivation." That same F2-H2 Resolution paragraph, in its own
very next sentence, already established that `status.rs`'s `Credentials:` line ALREADY performs the
auth_method-matching check today — i.e. there is NO observable output change for a mismatched-kind
profile either, only a re-sourcing of the INTERNAL DERIVATION through the shared `derive_auth_state`
helper. "Corrected for mismatched-kind profiles" was therefore a misnomer: it implied an output
change that does not occur, self-contradicting the surrounding prose within the same Postcondition.

**Resolution:** BC-1.6.050 Postcondition 6 and VP-AUTHDX-026 point 6 reworded to state the human-text
output is byte-for-byte UNCHANGED IN ALL CASES — for correctly-configured profiles AND for a
mismatched-credential-kind profile (EC-1.6.048-2) alike. Only the internal derivation is re-sourced
through the shared `derive_auth_state` helper (satisfying Postcondition 3's single-derivation
requirement); the F4 implementing story's job is to route the existing check through that helper, not
to reimplement or change its output. This restores the correct, unconditional "byte-for-byte
unchanged" guarantee that §14's F2-H2 wording had wrongly weakened into a claimed output
"correction."

**Edits made (at the time, not re-applied here):** `bc-1-auth-identity.md` BC-1.6.050 Postcondition 6
("FURTHER REVISED, cycle-007 F2 fix round 3, adversary pass-3 finding F6" annotation), VP-AUTHDX-026
point 6, and its F4 test-criteria line (line ~1727, "Postcondition 6, as revised round 3").
**Retroactive fix made HERE (adversary pass-4 finding F-1):** §14 above (the F2-H2 Resolution
paragraph) annotated with a "SUPERSEDED" blockquote pointing to this section, so a reader of §14 is
no longer left with the stale "corrected for mismatched-kind profiles" wording as the apparent
current design. This §16.

### Guard re-verification (retroactive — the underlying edit already landed prior to this section)

```
$ bash scripts/check-spec-counts.sh
Check passed: 8 bc files validated

$ bash scripts/check-bc-cumulative-counts.sh
OK: all cumulative BC counts verified (757 total across 9 files; Surface H footer checked where present).
```

No count-affecting change was made by pass-3/F6 — prose-only correctness fix within an
already-existing BC Postcondition/VP; no BC added/removed/retitled, no count change.

---

## 17. Adversary Fix Round 4 — 1 finding, same day (2026-09-10, adversary pass-4, finding F-2)

A FOURTH fresh-context adversarial pass ("adversary pass-4") over this delta and
`bc-1-auth-identity.md`, run after the §16 (pass-3/F6) fix above, found 1 finding (F-2, MEDIUM)
against BC-1.6.048/049/050's shared derivation signature as revised through round 2 (§15). Resolved
in `bc-1-auth-identity.md`; no `#### BC-` heading was added or removed (total_bcs stays 83,
definitional_count stays 72 — both guards re-verified green below). Findings F-1, F-3, and F-4 from
the same adversary pass-4 report are recorded in this document (§16, above) and in
`spec-changelog.md`/`BC-INDEX.md` respectively, not here — this section covers F-2 only, the one
finding whose fix touches `bc-1-auth-identity.md`'s normative BC bodies.

### F-2 [MEDIUM] — the shared derivation's `Result<bool>` parameter was unrealizable from the locked caller

**Defect:** round 2's (§15) `derive_auth_state(url: Option<Url>, matching_kind_present: Result<bool>)
-> AuthState` specified a three-way `{Ok(true), Ok(false), Err}` domain for `matching_kind_present`.
This is NOT realizable from the locked caller mechanism this BC itself specifies:
`load_oauth_tokens(profile).is_ok()` / `load_api_token(profile).is_ok()` always return a plain `bool`
in production (`.is_ok()` collapses any `Err` the underlying `load_*` call produces to `false` before
the caller ever sees it) — `derive_auth_state` can therefore never actually observe an `Err` at that
parameter position. Round 2's Postcondition 4 (fail-closed-on-`Err` + stderr-warning-SHOULD-be-emitted
branch) was consequently dead code, unreachable from any real call site. This also matches shipped
`status.rs::status`'s existing `Credentials:` check, which uses `.is_ok()` directly and prints "not
found" with no warning on any failure kind — the round-2 design had drifted from what the locked
caller and the shipped code both already do.

**Resolution (LOCKED):** simplify the signature to the realizable TWO-STATE form:
`derive_auth_state(url: Option<Url>, matching_kind_present: bool) -> AuthState`. The caller still
selects and invokes the kind-specific probe (`load_oauth_tokens`/`load_api_token`, chosen by
`auth_method` — unchanged from round 2) but passes its `.is_ok()` `bool` result directly, not a
`Result`. The input domain is now {url: None/Some} × {matching_kind_present: true/false} = 4 classes
(`url: None` always yields `unset` regardless of `matching_kind_present`, collapsing 2 of the 4
classes to one output), mapping onto the existing 3-value `AuthState` enum — no enum change.
Postcondition 4's fail-closed-on-`Err`/stderr-warning branch is REMOVED and replaced with an explicit
SCOPE note: distinguishing a genuine keychain BACKEND ERROR from ordinary credential-absence (and
warning on it) is OUT OF SCOPE for cycle-007 — it is the pre-existing tracked standing item
**OBS-PB-1** ("`auth status` credential probe `.is_ok()` swallows a genuine keyring backend error
into 'not found'"). cycle-007 PRESERVES shipped behavior: a backend error collapses to
`false`/not-configured, with no warning, exactly as `status.rs`'s existing `.is_ok()` check does
today.

**Edits made:** `bc-1-auth-identity.md` — BC-1.6.048: new "STATUS: REVISED A THIRD TIME" paragraph
(cites this as "cycle-007 F2 fix round 4" to avoid colliding with pass-3/F6's round-3 numbering, §16
above); Postcondition 1 (dropped the `Ok(...)`/"or the probe errors" phrasing); Postcondition 2's
"Preferred implementation shape" (signature simplified to `bool`); Postcondition 4 (fully rewritten,
dropping the dead fail-closed-on-`Err` branch, adding the OBS-PB-1 scope note); VP-AUTHDX-024's
Coverage boundary and VP-AUTHDX-029's Verification method (both reworded off `Result<bool>` to
`bool`); Trace field (round-4 entry appended); frontmatter `trace:` changelog (round-4 bullet
appended). BC-1.6.049: EC-1.6.049-2 (the probe-error/stderr-warning scenario retired as unrealizable,
replaced with an OBS-PB-1 scope note), Trace field. BC-1.6.050: EC-1.6.050-3 (revised identically),
Trace field. This document: §16 above added (retroactive pass-3/F6 record, per finding F-1); this
§17; `spec-changelog.md`'s `[2.3.0]` VP-count line corrected (finding F-3, see that file's own
`[CORRECTED]` annotation); `BC-INDEX.md` row 151's title cell claimed as "synced to BC-1.6.047's H1"
(finding F-4, `bc_h1_is_title_source_of_truth`) — **CORRECTED, adversary pass-5, finding F-2, see §18
below: this claim was FALSE as written.** The row 151 edit made in THIS round (fix round 4) only
touched the row's trailing `[...]` change-log bracket (the NFR-O-N/BC-1.6.050 annotation); the title
TEXT itself (before the bracket) was never actually edited and still read "`env` tag is surfaced
unconditionally in `auth list --output json` (every profile object carries the key, `null` when
unset) and `auth status` JSON/text output" — diverging from BC-1.6.047's H1 (which carries the
"— JSON channel verbatim/lossless, human/text channel sanitized" channel-split descriptor and no
"(every profile object carries the key...)" parenthetical). The actual full sync of row 151's title
cell to BC-1.6.047's H1 happened only at adversary pass-5 (§18 F2) — this §17 record is corrected
in place, immediately above, rather than left standing as a false claim.

**Consistency confirmed:** re-read all three BC bodies (BC-1.6.048/049/050) after the edit — none
retain a normative `Result<bool>`/`Err`/stderr-warning-on-probe-error clause; the only remaining
`Result<bool>` text is explanatory ("was X, now Y") STATUS/Trace prose describing the superseded round
2 design, or the frontmatter `trace:` changelog's immutable historical record of round 2 itself
(per this file's established "retain superseded rounds verbatim for audit trail" convention — see
§14/§15's own retained round-1 prose for precedent).

### Guard re-verification (after fix-round-4 edits)

```
$ bash scripts/check-spec-counts.sh
Check passed: 8 bc files validated

$ bash scripts/check-bc-cumulative-counts.sh
OK: all cumulative BC counts verified (757 total across 9 files; Surface H footer checked where present).
```

No count-affecting change was made — this round only revised Postcondition/EC/VP/Trace prose (no
`#### BC-` heading added or removed, no append-only edge case added). `total_bcs` stays 83;
`definitional_count` stays 72.

### Files touched in this fix round (absolute paths)

- `/Users/zious/Documents/GITHUB/jira-cli/.factory/phase-f2-spec-evolution/cycle-007-prd-delta.md` (this file — §14 SUPERSEDED annotation, this §16, this §17)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/bc-1-auth-identity.md` (frontmatter `trace:` changelog; BC-1.6.048/049/050 bodies)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/BC-INDEX.md` (row 151 title cell only — finding F-4)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/spec-changelog.md` (`[2.3.0]` VP-count line — finding F-3)

**Not touched:** story bodies (`.factory/stories/`), product code (`src/`), `CANONICAL-COUNTS.md`,
`nfr-catalog.md`, `cycle-007-verification-delta.md` (formal-verifier's separate, parallel surface —
out of this fix round's file scope per task instruction) — none of these needed a content change for
this round's findings (prose-only correctness fix within already-existing BCs/index rows; no BC
added/removed/retitled, no count change, no NFR/error-taxonomy/interface change). **Not committed** —
same as the rest of this document; state-manager commits at F2 close.

---

## 18. Adversary Fix Round 5 — 2 findings (F1, F2) + 1 LOW, same day (2026-09-10, adversary pass-5)

A FIFTH fresh-context adversarial pass ("adversary pass-5") over this delta and
`bc-1-auth-identity.md`/`BC-INDEX.md`, run after the §17 (pass-4/F-2) fix above, found 2 MEDIUM
findings (F1, F2) plus 1 LOW terminology nit. Resolved in `bc-1-auth-identity.md` and `BC-INDEX.md`;
no `#### BC-` heading was added or removed (total_bcs stays 83, definitional_count stays 72 — both
guards re-verified green below). A COMPLETENESS SWEEP was additionally run to close out the whole
propagation-nit class rather than leaving it to resurface piecemeal at a future pass — see §18.4/§18.5.

### F1 [MEDIUM] — stale rejected-primitive citation in BC-1.6.046's cross-reference note

**Defect:** BC-1.6.046's non-normative cross-reference note (added 2026-09-10, issue #788) still read
"STATUS derived from an actual `profile_has_stored_credentials` probe, per the shared vocabulary
BC-1.6.048 defines" — but BC-1.6.048's Postcondition 2 REJECTS that bare existence-only primitive
(rounds 1 and 2, findings F2-H1/H1) in favor of the auth_method-aware, kind-specific
`load_oauth_tokens`/`load_api_token` probe feeding the PURE `derive_auth_state` helper (round 4,
finding F-2). The cross-reference note had never been updated in lockstep with BC-1.6.048's own body,
leaving a stale forward-reference to a primitive that BC-1.6.048 itself explicitly rejected two rounds
earlier.

**Resolution:** `bc-1-auth-identity.md` BC-1.6.046's cross-reference note (~line 1540) — the phrase
"an actual `profile_has_stored_credentials` probe, per the shared vocabulary BC-1.6.048 defines" is
replaced with "the shared auth_method-aware `derive_auth_state` derivation (kind-specific
`load_oauth_tokens`/`load_api_token` probe, BC-1.6.048 Postcondition 2 as revised)" — matching the
locked round-4 design exactly, with no other change to the note (its non-normative, F4-attention-flag
purpose is unaffected).

### F2 [MEDIUM] — BC-1.6.047 H1 ↔ BC-INDEX row 151 title divergence + false §17 record

**Defect:** two compounding problems. (1) BC-1.6.047's H1 and BC-INDEX row 151's title cell had
diverged: the H1 carries the "— JSON channel verbatim/lossless, human/text channel sanitized"
channel-split descriptor (added at the H2-2 amendment) and no "(every profile object carries the key,
`null` when unset)" parenthetical, while row 151's title cell carried the opposite — the parenthetical
but not the channel-split descriptor — a genuine `bc_h1_is_title_source_of_truth` violation. (2) §17
above (round 4) claimed "`BC-INDEX.md` row 151's title cell synced to BC-1.6.047's H1 (finding F-4,
`bc_h1_is_title_source_of_truth`)" — but the round-4 edit only touched row 151's trailing `[...]`
change-log bracket (the NFR-O-N/BC-1.6.050 annotation); the title TEXT before the bracket was never
actually touched, so the "synced to H1" claim was FALSE as written, not merely stale.

**Resolution:** `BC-INDEX.md` row 151's title cell (text before the `[...]` bracket) fully synced,
verbatim, to BC-1.6.047's current H1 text — title text only, no row/id/count change, bracket
annotation left as-is (it is the row's own change-log convention, not part of the title). `§17` above
is corrected IN PLACE (not silently rewritten) with an explicit "**CORRECTED, adversary pass-5,
finding F-2**" annotation stating what the round-4 edit actually touched and pointing to this section
for the real fix — preserving §17's own historical-record status while not leaving a false claim
standing uncorrected.

### LOW — terminology: call-count conditionality attached to the wrong primitive

**Defect:** BC-1.6.049 Postcondition 4 (~line 1663) attached the "AT MOST N calls / never probed"
call-count conditionality to "the shared auth_method-aware derivation helper (BC-1.6.048 Postcondition
2)" — but per BC-1.6.048's own round-4 "Preferred implementation shape," post-round-4
`derive_auth_state` is a PURE function that performs NO probing/IO; it is the CALLER-invoked
kind-specific keychain probe (`load_oauth_tokens`/`load_api_token`) that is actually conditional and
actually issues the (at most N) keychain reads.

**Resolution:** BC-1.6.049 Postcondition 4 reworded: "issues AT MOST N calls to the shared
auth_method-aware derivation helper" → "issues AT MOST N calls to the kind-specific keychain probe
(`load_oauth_tokens`/`load_api_token`, selected via BC-1.6.048 Postcondition 2's auth_method-aware
selection rule — the PURE `derive_auth_state` helper itself performs no probing/IO, per BC-1.6.048's
round-4 'Preferred implementation shape')" — so the call-count conditionality now attaches to the
actual probe, not the pure derivation function. Invariant 1 (the "no wasted keychain read" sentence)
was reviewed and needed no change — it already refers to "keychain read," not "derivation helper."

### 18.4 Completeness sweep 1 — rejected-primitive citation sweep

Grepped `bc-1-auth-identity.md` and `BC-INDEX.md` in full for every occurrence of
`profile_has_stored_credentials` (9 hits in `bc-1-auth-identity.md`, 1 in `BC-INDEX.md`) and
`probe_stored_credential_kind` (17 hits, all in `bc-1-auth-identity.md`; 0 in `BC-INDEX.md`).
Classified every occurrence:

**`profile_has_stored_credentials`:**
- `bc-1-auth-identity.md` frontmatter `trace:` line 1 (original dated 2026-09-10 F2-pass entry) — (a)
  historical, immutable dated record (per this file's established "retain superseded rounds verbatim"
  convention) — LEFT AS-IS.
- `bc-1-auth-identity.md` frontmatter `trace:` "cycle-007 F2 fix round" entry (2 occurrences,
  describing the F2-H1 and M3 findings in past tense: "originally specified... probe" /
  "still named the existence-only ... wrapper... not a ... error") — (a) historical/explanatory —
  LEFT AS-IS.
- `bc-1-auth-identity.md` BC-1.6.046 cross-reference note (~line 1540) — (b) LIVE normative-reading
  citation — **FIXED (F1 above).**
- `bc-1-auth-identity.md` BC-1.6.048 STATUS banner ("originally specified... 'no new probe
  mechanism'") — (a) historical, correctly scoped as superseded-state description — LEFT AS-IS.
- `bc-1-auth-identity.md` BC-1.6.048 Trace field ("...rather than the existing-only wrapper") — (a)
  historical — LEFT AS-IS.
- `bc-1-auth-identity.md` BC-1.6.049 Description ("...REVISED cycle-007 F2 fix round, finding F2-H1 —
  not the bare existence-only `profile_has_stored_credentials`...") — (a) historical/explicitly
  negated within live prose ("not X") — LEFT AS-IS.
- `bc-1-auth-identity.md` BC-1.6.049 Trace field ("...rather than the bare existence-only...") — (a)
  historical — LEFT AS-IS.
- `bc-1-auth-identity.md` BC-1.6.050 Trace field ("...corrected from the existence-only ... to the
  same kind-specific probe...") — (a) historical — LEFT AS-IS.
- `BC-INDEX.md` frontmatter `last_updated` changelog comment (the dated 2026-09-10 cycle-007 entry,
  "...BC-1.6.049 (#788 — `auth list` STATUS column derives from an actual
  `profile_has_stored_credentials` probe, not `url.is_some()` alone)...") — (a) historical, immutable
  dated changelog record describing the state as of the original F2 pass, before the fix rounds
  corrected the wording (same class as the bc-1 frontmatter trace entry above) — LEFT AS-IS.

**`probe_stored_credential_kind`** (all 17 hits in `bc-1-auth-identity.md`): every occurrence is
either (a-i) the Source-field citation of this function as a genuinely distinct, valid-for-its-own-
purpose helper (e.g. `login.rs`'s post-mechanism-switch orphaned-pair cleanup) — explicitly NOT the
STATUS-derivation comparison primitive — or (a-ii) explicitly negated/contrastive historical prose
within STATUS banners, Postconditions, Edge Cases, VP text, and Trace fields ("NOT
`probe_stored_credential_kind`", "round 1's now-superseded `probe_stored_credential_kind`-comparison
form", "corrected from `probe_stored_credential_kind` to..."). No occurrence reads as a live,
unqualified citation of `probe_stored_credential_kind` AS the operative STATUS-derivation primitive.
**All 17 classified (a) — no fix needed beyond F1/LOW above.**

**Verdict:** the rejected-primitive class is fully closed as of this pass. Every remaining occurrence
of either name in both files is either an immutable dated historical record or prose that explicitly
negates/contrasts the name against the actually-locked primitive — none reads as a live, affirmative
citation of a rejected primitive.

### 18.5 Completeness sweep 2 — H1 ↔ BC-INDEX title sweep (cycle-007-touched BCs)

Byte-compared each cycle-007-touched BC's current H1 title (text after `#### BC-S.SS.NNN: `) against
its BC-INDEX row's title cell (text before the trailing `[...]` change-log bracket):

| BC | Match/Mismatch | Action |
|---|---|---|
| BC-1.4.032 | MATCH | none |
| BC-1.4.033 | **MISMATCH** — H1 uses `(legacy-partial branch removed)` (parenthetical); row 117 used `, legacy-partial branch removed` (comma clause) | **FIXED** — row 117 title synced verbatim to H1 |
| BC-1.4.034 | MATCH | none |
| BC-1.6.046 | MATCH | none |
| BC-1.6.047 | **MISMATCH** — see F2 above | **FIXED** (F2) |
| BC-1.6.048 | MATCH | none |
| BC-1.6.049 | MATCH | none |
| BC-1.6.050 | MATCH | none |
| BC-1.2.049 | **MISMATCH** — row 87 carried an extra `(never emitted in \`--output json\`)` parenthetical not present in the H1 | **FIXED** — row 87 title synced verbatim to H1 (parenthetical removed; the underlying behavioral fact is still fully documented inline in BC-1.2.049's own body, this was an index-title-only divergence) |

3 of 9 checked BCs had a title mismatch (BC-1.4.033, BC-1.6.047, BC-1.2.049); all 3 fixed by syncing
the BC-INDEX title cell to the BC's H1 verbatim, per `bc_h1_is_title_source_of_truth`. The other 6
already matched.

### Guard re-verification (after fix-round-5 edits)

```
$ bash scripts/check-spec-counts.sh
Check passed: 8 bc files validated

$ bash scripts/check-bc-cumulative-counts.sh
OK: all cumulative BC counts verified (757 total across 9 files; Surface H footer checked where present).
```

No count-affecting change was made — this round only revised cross-reference-note/Postcondition prose
and 3 BC-INDEX title cells (text-only, no row added/removed/reordered). `total_bcs` stays 83;
`definitional_count` stays 72.

### Files touched in this fix round (absolute paths)

- `/Users/zious/Documents/GITHUB/jira-cli/.factory/phase-f2-spec-evolution/cycle-007-prd-delta.md` (this file — §17 in-place correction annotation, this §18)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/bc-1-auth-identity.md` (BC-1.6.046 cross-reference note — F1; BC-1.6.049 Postcondition 4 — LOW)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/BC-INDEX.md` (row 151 title cell — F2; row 117 title cell — sweep 2; row 87 title cell — sweep 2)

**Not touched:** story bodies (`.factory/stories/`), product code (`src/`), `CANONICAL-COUNTS.md`,
`nfr-catalog.md`, `cycle-007-verification-delta.md` (formal-verifier's separate, parallel surface —
out of this fix round's file scope per task instruction), `spec-changelog.md` (no VP-count or
version-history claim was touched this round) — none of these needed a content change for this
round's findings (prose-only correctness fix + index-title sync within already-existing BCs/index
rows; no BC added/removed/retitled, no count change, no NFR/error-taxonomy/interface change).
**Not committed** — same as the rest of this document; state-manager commits at F2 close.

---

## 19. Adversary Fix Round 6 — 1 MEDIUM (M-1) + 2 LOW (L-1, L-2), same day (2026-09-10, adversary pass-6)

A SIXTH fresh-context adversarial pass ("adversary pass-6") over this delta and
`bc-1-auth-identity.md`, run after the §18 (pass-5) fix above, found 1 MEDIUM finding (M-1) and 2 LOW
findings (L-1, L-2). All three are BC/spec-side text corrections — no product code, no
`cycle-007-verification-delta.md` (formal-verifier's parallel surface, addressed separately). Resolved
in `bc-1-auth-identity.md` only; no `#### BC-` heading was added or removed (total_bcs stays 83,
definitional_count stays 72 — both guards re-verified green below).

### M-1 [MEDIUM] — the text `Credentials:` line is a 2-valued PROJECTION, not the 3-state auth-state (parity contradiction)

**Defect:** the shipped `auth status` human-text `Credentials:` line (`src/cli/auth/status.rs::status`)
is 2-valued and reads ONLY the kind-specific probe result (`matching_kind_present` — `creds_ok` in the
shipped code) — it does NOT read `profile.url`. But `derive_auth_state(url, matching_kind_present)` is
3-valued and returns `unset` whenever `url` is `None`, REGARDLESS of `matching_kind_present`. So for a
`(url: None, matching credential present)` profile, the two MACHINE channels (`auth list` STATUS,
`auth status --output json`'s `"status"` field) render `unset`, while the text `Credentials:` line
renders "stored in keychain" — a real, structural divergence the shipped text-rendering logic cannot
avoid (it never reads `url`). BC-1.6.048 Postcondition 3 claimed "all THREE channels render the same
underlying auth-state" (echoed by VP-AUTHDX-029's "ALL THREE channels render the same underlying
auth-state, never a two-of-three-agree-while-one-drifts split") — combined with BC-1.6.050 Postcondition
6's unconditional "text byte-for-byte unchanged in all cases," these two guarantees are jointly
unsatisfiable: Postcondition 6 forbids changing the text line's `url`-blind rendering logic, while
Postcondition 3 (as originally worded) demanded a 3-state result the `url`-blind logic structurally
cannot produce.

**Resolution (LOCKED, per task instruction):**
- BC-1.6.048 Postcondition 3 revised: the TWO MACHINE channels (`auth list` STATUS, `auth status
  --output json`) alone are guaranteed to share the full 3-state `derive_auth_state` OUTPUT and always
  agree with each other (VP-AUTHDX-024's scope, unaffected by this fix). The human-text `Credentials:`
  line is reclassified as a STRICT-SUBSET, 2-state PROJECTION of `matching_kind_present` (the
  derivation's INPUT, not its output) — it does not read `url` and so cannot express `unset` vs.
  `no-credentials` as distinct states; this is the pre-existing shipped behavior, unchanged by cycle-007.
- VP-AUTHDX-029 revised in lockstep: it now asserts the text `Credentials:` line agrees with the raw
  `matching_kind_present` BOOLEAN that also feeds the two machine channels' derivation — NOT with the
  3-state `"status"` value the machine channels render. The property explicitly documents that it does
  NOT flag the `url: None` ∧ credential-present divergence, since it never compares against `status`.
- New edge case EC-1.6.050-4 (append-only) added to BC-1.6.050 documenting the `url: None` ∧
  credential-present divergence as an intentional, non-defective worked example: machine channels render
  `unset`, text renders `"Credentials: stored in keychain"`. Confirms BC-1.6.050 Postcondition 6's
  "byte-for-byte unchanged in all cases" is fully preserved by this reframing — Postcondition 6 never
  claimed 3-state parity in the first place; only Postcondition 3's OWN wording overclaimed it, and that
  overclaim is what this fix corrects. A round-6 consistency note is appended directly to Postcondition 6
  confirming this.

**Files/sections touched:** `bc-1-auth-identity.md` BC-1.6.048 Postcondition 3 (revised), VP-AUTHDX-029
(revised), BC-1.6.048 Trace (round-6 entry added); BC-1.6.050 Postcondition 6 (round-6 consistency note
appended, no substantive change), new EC-1.6.050-4 (append-only), BC-1.6.050 Trace (round-6 entry added).

### L-1 [LOW] — VP-AUTHDX-024 property enumeration still listed the retired `probe-error` state

**Defect:** VP-AUTHDX-024's property-enumeration text ("for ANY profile configuration (URL
present/absent × credential present/absent/mismatched-kind/**probe-error**, across both `api_token` and
`oauth` auth methods)...") still listed the `probe-error` state four rounds after round 4 (finding F-2,
§17 above) retired it: the locked caller mechanism's `.is_ok()` collapse means `matching_kind_present`
is always a plain `bool`, never observably `Err`, so there is no fourth `probe-error` class in the
property's actual state space. The enumeration was stale round-2 wording that survived round 4's fix
unreconciled.

**Resolution:** `probe-error` removed from the enumeration (→ "credential present/absent/mismatched-kind"),
with an inline note explaining the staleness and pointing back to round 4/finding F-2 as the origin of
the retirement, so a future reader doesn't wonder why the enumeration looks "incomplete" relative to
earlier rounds' text.

### L-2 [LOW] — amended messages are the `hint` field, not the full Display output

**Defect:** `JrError::NotAuthenticated { hint }`'s Display impl (`src/error.rs::18`,
`#[error("Not authenticated. {hint}")]`) prepends `"Not authenticated. "` to whatever `hint` string is
supplied. BC-1.4.032 Postcondition 2, BC-1.4.032 EC-1.4.032-1, and BC-1.4.033 Postcondition 2 all quote
the user-facing message text WITHOUT this prefix (e.g. `"No credentials stored for profile
'{profile}'. This version of jr requires per-profile credentials — run \`jr auth login --profile
{profile}\` to set them up."`) — accurate as the `hint` FIELD VALUE, but a story-writer/implementer
reading only the quoted string in isolation could plausibly construct a `NotAuthenticated` variant that
either omits the "Not authenticated. " prefix entirely (bypassing the shared Display impl) or
double-prepends it.

**Resolution:** clarifying notes added to BC-1.4.032 Postcondition 2, BC-1.4.032 EC-1.4.032-1, and
BC-1.4.033 Postcondition 2, each stating explicitly that the quoted text is the `hint` field value, that
the Display impl prepends `"Not authenticated. "` at render time, and that the correct implementation
approach is to construct `JrError::NotAuthenticated { hint }` with this BC's quoted text as `hint` —
matching the existing construction pattern used at other call sites in the codebase (e.g.
`src/api/client.rs`, `src/api/refresh_coordinator.rs`, `src/api/jsm/attachments.rs`) — not to invent a
prefix-free variant or a raw `format!` string that bypasses the shared Display impl. VP-AUTHDX-027's
`contains`-style assertions (it checks substring presence, not full-string equality) are unaffected and
need no change — the formal-verifier will add an equivalent note to
`cycle-007-verification-delta.md` separately, per the task's stated division of labor. No behavior or
quoted-message TEXT change from this finding — construction-site clarification only.

**Files/sections touched:** `bc-1-auth-identity.md` BC-1.4.032 Postcondition 2, BC-1.4.032 EC-1.4.032-1,
BC-1.4.033 Postcondition 2 (all three: clarifying note appended, no quoted-text change); BC-1.4.032
Trace, BC-1.4.033 Trace (round-6 entries added).

### Guard re-verification (after fix-round-6 edits)

```
$ bash scripts/check-spec-counts.sh
Check passed: 8 bc files validated

$ bash scripts/check-bc-cumulative-counts.sh
OK: all cumulative BC counts verified (757 total across 9 files; Surface H footer checked where present).
```

No count-affecting change was made — this round only revised Postcondition/VP prose, appended
clarifying notes, and added one append-only edge case (EC-1.6.050-4) to an existing BC body. `total_bcs`
stays 83; `definitional_count` stays 72.

### Files touched in this fix round (absolute paths)

- `/Users/zious/Documents/GITHUB/jira-cli/.factory/phase-f2-spec-evolution/cycle-007-prd-delta.md` (this file — this §19)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/bc-1-auth-identity.md` (BC-1.6.048 Postcondition 3/Trace — M-1; VP-AUTHDX-029 — M-1; BC-1.6.050 Postcondition 6/new EC-1.6.050-4/Trace — M-1; VP-AUTHDX-024 — L-1; BC-1.4.032 Postcondition 2/EC-1.4.032-1/Trace — L-2; BC-1.4.033 Postcondition 2/Trace — L-2)

**Not touched:** `BC-INDEX.md` (no H1 title changed by this round), story bodies (`.factory/stories/`),
product code (`src/`), `CANONICAL-COUNTS.md`, `nfr-catalog.md`, `cycle-007-verification-delta.md`
(formal-verifier's separate, parallel surface — out of this fix round's file scope per task
instruction), `spec-changelog.md` (no VP-count or version-history claim was touched this round) — none
of these needed a content change for this round's findings (prose-only correctness fixes + one
append-only edge case within already-existing BCs; no BC added/removed/retitled, no count change, no
NFR/error-taxonomy/interface change).
**Not committed** — same as the rest of this document; state-manager commits at F2 close.
