---
document_type: wave-holdout-scenarios
phase: phase-f3-incremental-stories
cycle: cycle-003
feature: auth-profile-dx
wave: 1
status: draft
producer: story-writer
created: 2026-09-01
inputs:
  - ".factory/cycles/cycle-003/phase-f3-stories/S-cycle3-env-tag.md"
  - ".factory/cycles/cycle-003/phase-f3-stories/S-cycle3-percred-storage.md"
  - ".factory/cycles/cycle-003/phase-f3-stories/wave-schedule.md"
traces_to: "BC-6.1.015; BC-1.6.046; BC-1.6.047; BC-1.4.031; BC-1.4.027; BC-1.1.009; BC-1.1.010; BC-1.2.017"
input-hash: "78a7d39"
---

# Wave 1 Holdout Scenarios — `S-cycle3-env-tag` + `S-cycle3-percred-storage`

Wave 1 runs `env-tag` and `percred-storage` in parallel on file-disjoint surfaces
(`src/config.rs`+`src/cli/auth/{list,status}.rs` vs. `src/api/auth.rs`+`src/cli/auth/login.rs`+
`src/api/client.rs`). Because the two stories are file-disjoint, this wave's cross-story
scenarios test that their outputs COMPOSE correctly when exercised together (a profile that
is both `env`-tagged AND freshly per-profile-credentialed), not that they race on shared code.

---

## 1. Cross-Story Integration Scenarios

### H-W1-INT-001 — `env`-tagged profile round-trips through per-profile credential storage

**Setup:** `jr auth login sandbox-a --url https://sandbox-a.atlassian.net --api-token
--email x@y.com --token secret1 --env sandbox` (assuming `--env` is wired per
`S-cycle3-env-tag`'s BC-6.1.015 schema addition; if the CLI surface for setting `env` at
login time isn't itself in scope for `S-cycle3-env-tag` — check the story's ACs before
writing this as a literal CLI invocation — substitute a direct `ProfileConfig.env` write
via test fixture and confirm the composed read path).

**Expectation:** `jr auth list --output json` shows BOTH the new `env: "sandbox"` field
(BC-1.6.047) AND a successful `AUTH`/`STATUS` read that resolves through
`load_api_token("sandbox-a")` — i.e., the namespaced per-profile credential
(`S-cycle3-percred-storage`, BC-1.4.031) — not the legacy flat pair. This proves the two
Wave-1 stories' outputs don't collide: `env` is a pure config-file field, credential
resolution is a pure keychain lookup, and `auth list`'s row assembles both without either
one masking the other.

**MUST-PASS.**

### H-W1-INT-002 — `auth status` on an `env`-tagged, freshly-per-profile-credentialed profile

**Setup:** Same profile as H-W1-INT-001. Run `jr auth status --profile sandbox-a`.

**Expectation:** Human-text output includes the sanitized `env` line (BC-1.6.047
EC-1.6.047-3) AND correctly reports the profile as authenticated (credential presence
confirmed via `load_api_token`, not the legacy `load_api_token()` no-arg reader — this
guards against a regression where `auth status` was accidentally left reading the OLD
flat-pair existence check while `auth login`/`auth list` already moved to the new
per-profile one, which would silently disagree with each other).

**MUST-PASS.**

---

## 2. Regression Scenarios — Existing Auth Behavior Preserved

### H-W1-REG-001 — Non-interactive CI token-first contract unaffected by `env` field (DEC-313 precursor check)

Wave 1 does not itself implement DEC-313's OAuth-default-at-creation picker (that's Wave
4), but it DOES touch `src/cli/auth/login.rs::login_token` (the api-token write path
`S-cycle3-percred-storage` switches to `store_api_token`). This regression scenario
confirms Wave 1 alone does not change today's non-interactive behavior ahead of Wave 4.

**Setup:** `jr auth login ci-profile --url ... --api-token --email x --token y --no-input`
(today's existing non-interactive api-token flow, unchanged by Wave 1).

**Expectation:** Exits 0, writes the credential via the new `store_api_token` (namespaced
keys), behaves identically from the CLI-surface/exit-code perspective to pre-cycle-003
`jr auth login --api-token --no-input` — the only change is WHERE the credential is
written (namespaced vs. flat), which is invisible to the CLI caller. No OAuth browser
flow is attempted (nothing in Wave 1 touches the picker/guard logic; this is a pure
regression pin that Wave 1's `login_token` change is additive-in-effect, not
behavior-changing at the CLI surface).

**MUST-PASS. Regression-critical** — a failure here would mean `S-cycle3-percred-storage`
broke the existing non-interactive api-token login path, which every CI script in the
existing E2E suite (`tests/e2e_live.rs`, `JR_RUN_E2E=1`) and countless external users
depend on.

### H-W1-REG-002 — Existing multi-profile cross-profile isolation unaffected

**Setup:** Two profiles, `alpha` (api-token) and `beta` (api-token), both created via
`jr auth login`. Run `jr issue list --profile alpha` then `jr issue list --profile beta`.

**Expectation:** Each command's outbound `Authorization` header resolves to that
profile's OWN namespaced credential (`load_api_token("alpha")` vs.
`load_api_token("beta")`) — no cross-profile leakage, mirroring the pre-existing
`BC-6.2.009`/`BC-6.2.010` cross-profile isolation tests this ADR's own text cites as the
regression safety net for the credential-storage change. This is the Wave-1-scoped slice
of VP-AUTHDX-004 (round-trip + cross-profile isolation).

**MUST-PASS.**

### H-W1-REG-003 — `auth list` JSON output stays parseable by existing consumers (additive-only column)

**Setup:** `jr auth list --output json` against a mixed fixture of 3 profiles, none of
which set `env`.

**Expectation:** The new `"env"` JSON key is present with value `null` for all 3
(BC-1.6.047's `Some("")` vs `None` distinction, EC-1.6.046-1) — existing keys (`name`,
`url`, `auth_method`, `status`) are byte-for-byte unchanged in name and value shape. A
`jq`-based consumer that doesn't know about `"env"` yet continues to work unmodified
(pure additive JSON schema evolution, per BC-1.6.047's channel-split invariant: JSON
stays verbatim/lossless).

**MUST-PASS.**

---

## 3. Summary

| ID | Type | Priority |
|---|---|---|
| H-W1-INT-001 | cross-story integration | MUST-PASS |
| H-W1-INT-002 | cross-story integration | MUST-PASS |
| H-W1-REG-001 | regression (CI token-first contract) | MUST-PASS, regression-critical |
| H-W1-REG-002 | regression (cross-profile isolation) | MUST-PASS |
| H-W1-REG-003 | regression (JSON schema additivity) | MUST-PASS |

5 scenarios, all MUST-PASS before Wave 2 opens per the wave-gate in `wave-schedule.md` §4.
