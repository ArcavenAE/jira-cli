---
document_type: wave-holdout-scenarios
phase: phase-f3-incremental-stories
cycle: cycle-003
feature: auth-profile-dx
wave: 4
status: draft
producer: story-writer
created: 2026-09-01
inputs:
  - ".factory/cycles/cycle-003/phase-f3-stories/S-cycle3-adr0011-newtype.md"
  - ".factory/cycles/cycle-003/phase-f3-stories/S-cycle3-oauth-default-creation.md"
  - ".factory/cycles/cycle-003/phase-f3-stories/wave-schedule.md"
  - ".factory/cycles/cycle-003/phase-f3-stories/wave-holdout-scenarios/wave-3-holdout-scenarios.md"
traces_to: "BC-6.2.015; BC-1.1.013; BC-1.1.014; BC-1.1.015; BC-1.1.016; BC-1.2.049; BC-1.2.050"
input-hash: "81a3f7a"
---

# Wave 4 Holdout Scenarios — `S-cycle3-adr0011-newtype` + `S-cycle3-oauth-default-creation`

Two-story wave sharing a wave boundary without a hard dependency edge between them (see
`wave-schedule.md` §3 for why they're merged into one wave, with a recommended intra-wave
delivery order: `adr0011-newtype` first, `oauth-default-creation` second). This is the
cycle's highest-scrutiny wave for the **DEC-313 non-interactive CI token-first
contract** — the single most safety-critical regression surface in the entire cycle,
since a defect here can hang a CI runner (an OAuth browser flow launched where none was
expected).

---

## 1. Cross-Story Integration Scenarios

### H-W4-INT-001 — `oauth-default-creation`'s new code is written against `adr0011-newtype`'s `&Profile` signatures (intra-wave delivery order check)

**Setup:** After BOTH stories land (in the recommended order), grep
`src/cli/auth/login.rs` and `src/cli/auth/refresh.rs` for any remaining bare `profile:
&str` parameter on a function this wave touches.

**Expectation:** Zero occurrences — `oauth-default-creation`'s new picker/guard/flag code
(BC-1.1.013-016, BC-1.2.049/050) is written directly against `Profile`-typed signatures,
not `&str`, confirming the intra-wave delivery order in `wave-schedule.md` §3 was actually
honored and didn't leave a rename-debt for a later story to clean up. If this scenario
fails (bare `&str` found), the delivery order was violated and `oauth-default-creation`'s
implementation needs a follow-up rename pass before this wave can close.

**MUST-PASS.**

### H-W4-INT-002 — `adr0011-newtype`'s mechanical sweep doesn't silently change `oauth-default-creation`'s runtime behavior

**Setup:** Run the FULL Wave 1-3 regression suite plus the pre-existing
`BC-6.2.009`/`BC-6.2.010` cross-profile isolation tests against the post-`adr0011-newtype`
branch, BEFORE `oauth-default-creation`'s feature code lands.

**Expectation:** 100% pass, zero behavioral difference from pre-`adr0011-newtype` — the
newtype is compile-time-checked and mechanical (per BC-6.2.015's own framing: "a pure
Rust type-level change... All risk is mechanical... not behavioral"). This isolates
`adr0011-newtype`'s risk surface (a correctly-typed-but-wrong-value substitution, per its
own Consequences note) from `oauth-default-creation`'s risk surface (new control flow) so
a wave-gate failure can be attributed to the right story.

**MUST-PASS.**

### H-W4-INT-003 — Re-declaration credential-clear reuses Wave 3's `clear_profile_creds` branches (EC-1.1.013-2/EC-1.1.014-4)

**Setup:** A profile `switcher` created as `api_token` (Wave 1's `store_api_token`). Run
`jr auth login switcher --oauth` (or the interactive picker's OAuth selection) to
re-declare it as OAuth.

**Expectation:** The re-declaration clears `switcher`'s OUTGOING (api-token) credentials
via the SAME per-kind clear branch `S-cycle3-remove-logout-semantics` (Wave 3) added to
`clear_profile_creds` (its BC-1.2.014 4th step) — not a duplicated, independently-written
clear implementation. This is the cross-wave dependency the manifest derived beyond
ADR-0020's literal Sequencing text (§ story 4/6 Notes) — confirmed here as a holdout
scenario specifically because it's a MUST (not SHOULD) requirement per the manifest.

**MUST-PASS.**

---

## 2. Regression Scenarios — Existing Auth Behavior Preserved (DEC-313 focus)

### H-W4-REG-001 — Non-interactive `auth login` with NO explicit mechanism flag defaults to api-token, NEVER launches OAuth (VP-AUTHDX-001 base case)

**Setup:** `jr auth login ci-fresh --url ... --no-input` with NO `--oauth`/`--api-token`
flag and no `--email`/`--token` supplied either (the exact "no explicit flag,
non-interactive" cell DEC-313 requires to silently substitute `api_token`, per
ADR-0020 § Decision 5).

**Expectation:** The command does NOT attempt to bind a callback listener or open a
browser. It either (a) prompts for the missing `--email`/`--token` values via a
non-interactive-safe path (exits 64 requesting them, since `--no-input` blocks
interactive prompts) or (b) whatever the finalized BC-1.1.014 contract specifies —
but under NO circumstance does it reach OAuth-flow code. **This is the single most
important scenario in the entire cycle** — the manifest's own text calls the guard
ordering "the single most safety-critical requirement in this story."

**MUST-PASS. MANDATORY, safety invariant (VP-AUTHDX-001 base case).**

### H-W4-REG-002 — Non-interactive `auth login --oauth` (explicit flag) is REJECTED before any network/listener/browser code (BC-1.1.016, closes I-1)

**Setup:** `jr auth login explicit-oauth-ci --url ... --oauth --no-input` — the
adversarially-hardened cell DEC-313 was extended to cover at F2 gate (previously the
ORIGINAL framing only covered the no-flag default case, leaving this explicit-flag case
able to hang a CI runner).

**Expectation:** Exits 64 (or the finalized BC-1.1.016 exit code) BEFORE any
network call, callback-listener bind, or browser-open attempt — this must be evaluated as
a PRECONDITION, not a timeout on an already-started flow. A CI runner invoking this
exact command must return promptly, never hang waiting for a browser callback that will
never come.

**MUST-PASS. MANDATORY, safety invariant — this is the adversarial-finding-I-1 closure
the manifest flags as making the guard "airtight for CI."**

### H-W4-REG-003 — Non-interactive `auth refresh` on an implicit OAuth-method profile is also guarded (BC-1.1.016's second covered trigger)

**Setup:** An existing OAuth-method profile `implicit-oauth`, refreshed non-interactively:
`jr auth refresh implicit-oauth --no-input` (no explicit `--oauth` flag needed — the
profile's OWN `auth_method` is already `oauth`, so a refresh attempt implicitly needs the
OAuth flow).

**Expectation:** Same precondition-guard behavior as H-W4-REG-002 — exits before any
network/listener/browser code, per ADR-0020 § Decision 8's explicit second covered
trigger ("the implicit-oauth-profile × non-interactive cell on `auth refresh`").

**MUST-PASS. MANDATORY, safety invariant.**

### H-W4-REG-004 — Runtime-default-unchanged regression pin (VP-AUTHDX-002): existing profiles' resolved mechanism doesn't silently flip

**Setup:** A pre-cycle-003-shaped profile with `auth_method: api_token` already set in
config (created before this cycle's picker existed). Run any command against it
(`jr issue list --profile <it>`).

**Expectation:** The profile continues to resolve and authenticate via `api_token` —
introducing the interactive OAuth-default PICKER for NEW profile creation does not
retroactively change the resolved mechanism for EXISTING profiles (BC-1.1.015). This is
a pure regression pin — the picker only affects the creation-time DEFAULT SELECTION, not
any already-materialized `auth_method` value.

**MUST-PASS. Regression-critical.**

### H-W4-REG-005 — `--oauth` deprecated-but-accepted alias still works (BC-1.2.049), doesn't silently change semantics for existing scripts

**Setup:** `jr auth login legacy-script-profile --url ... --oauth` (interactive terminal,
not `--no-input` — i.e. a genuinely interactive session using the pre-existing `--oauth`
flag the way scripts/docs have described it before this cycle).

**Expectation:** `--oauth` is still ACCEPTED (not a hard error) and still selects the
OAuth flow interactively — it becomes a deprecated-but-functional alias, not a removed
flag. A pre-existing script/doc reference to `--oauth` does not break outright; only a
deprecation NOTICE is new (where applicable per BC-1.2.049's finalized text). This
regression-pins backward compatibility for anyone who already scripted `--oauth`
explicitly before cycle-003.

**MUST-PASS.**

### H-W4-REG-006 — `S-384`'s `is_oauth_auth()`-gated JSM 401 hints still correctly detect OAuth vs api-token after the creation-time default flips

**Setup:** Two freshly-created profiles post-cycle-003: one that took the new interactive
OAuth default, one that used `--api-token` explicitly. Trigger a JSM 401 on each (per
`S-384`'s existing test shape).

**Expectation:** `client.is_oauth_auth()` (already-shipped, per `conflict-report.md` §3)
correctly reads each profile's actual resolved mechanism and produces the matching hint
text — OAuth-appropriate hint for the OAuth-default profile, api-token-appropriate hint
for the explicit `--api-token` profile. This confirms the manifest's own
sequence-awareness note ("making OAuth the default at creation shifts which profiles most
commonly hit that gate... No code coordination required, but sequence-awareness is worth
a mention") holds in practice — `S-384`'s already-shipped gating logic needs no changes
and correctly adapts to the new default.

**MUST-PASS.**

---

## 3. Summary

| ID | Type | Priority |
|---|---|---|
| H-W4-INT-001 | cross-story integration (delivery-order check) | MUST-PASS |
| H-W4-INT-002 | cross-story integration (risk-surface isolation) | MUST-PASS |
| H-W4-INT-003 | cross-story integration (Wave 3 clear-branch reuse) | MUST-PASS |
| H-W4-REG-001 | regression (non-interactive no-flag default, VP-AUTHDX-001 base case) | MUST-PASS, MANDATORY |
| H-W4-REG-002 | regression (explicit `--oauth` non-interactive guard, BC-1.1.016/I-1) | MUST-PASS, MANDATORY |
| H-W4-REG-003 | regression (implicit OAuth-profile `refresh` guard) | MUST-PASS, MANDATORY |
| H-W4-REG-004 | regression (runtime-default-unchanged, VP-AUTHDX-002) | MUST-PASS, regression-critical |
| H-W4-REG-005 | regression (`--oauth` alias backward compat) | MUST-PASS |
| H-W4-REG-006 | regression (S-384 JSM 401 hint gating still correct) | MUST-PASS |

9 scenarios — the highest scenario count of any wave, reflecting both its 26-point size
(the heaviest wave) and its DEC-313 CI-hang-prevention stakes. The three MANDATORY
scenarios (H-W4-REG-001/002/003) MUST run in CI itself, not just locally — a CI runner
that hangs on one of these is the exact failure mode DEC-313's hardening exists to
prevent, so these scenarios should be exercised with a hard timeout wrapper in the actual
CI job, not only asserted for correct exit code.
