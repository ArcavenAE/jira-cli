---
document_type: wave-holdout-scenarios
phase: phase-f3-incremental-stories
cycle: cycle-007
feature: auth-correctness-dx
status: draft
producer: story-writer
created: 2026-09-10
inputs:
  - ".factory/cycles/cycle-007/phase-f3-stories/S-cycle7-credential-absence-fix.md"
  - ".factory/cycles/cycle-007/phase-f3-stories/S-cycle7-auth-state-derivation.md"
  - ".factory/cycles/cycle-007/phase-f3-stories/S-cycle7-auth-status-json.md"
  - ".factory/cycles/cycle-007/phase-f3-stories/wave-schedule.md"
traces_to: "BC-1.4.032/033/034; BC-1.6.048/049/050; BC-1.1.004; VP-AUTHDX-024..029"
input-hash: "f7d57aa"
---

# Wave Holdout Scenarios — `auth-correctness-dx` (cycle-007)

Per-wave cross-story integration scenarios and full-cycle regression scenarios
on existing auth behavior, per the F3 workflow's requirement for holdout
coverage beyond individual stories' own ACs.

---

## Wave 1 — Cross-Cutting Integration Scenarios

### H-W1-INT-001 — Credential-absence and truthful-STATUS fixes compose correctly for the same profile

**Setup:** A profile `sandbox` with `url: Some(...)`, `auth_method:
"api_token"`, and NO stored namespaced credential pair (both `sandbox:email`
and `sandbox:api-token` absent).

**Expectation:** `jr auth list` (B1) reports `sandbox`'s STATUS as
`no-credentials` (not `configured`). `jr <any command needing sandbox's
auth>` (e.g. `jr issue list --profile sandbox`) fails via `load_api_token`
(A) with `JrError::NotAuthenticated` (exit 2) and a message recommending `jr
auth login --profile sandbox` — a command that (per A's own AC-003) actually
parses. Running that exact suggested command succeeds and namespaces the
credential pair; a SUBSEQUENT `jr auth list` now reports `sandbox` as
`configured`. This is the single most important end-to-end proof this wave
delivers: the truthful-status signal (B1) and the actionable remediation (A)
form one coherent user journey, not two independently-correct but
disconnected fixes.

**MUST-PASS.**

### H-W1-INT-002 — `src/api/auth.rs`'s two concurrently-landing diffs (A + B1) do not collide

**Setup:** Both A's `load_api_token` error-branch edits and B1's
`derive_auth_state` addition are present in the same `develop` tip (per
`wave-schedule.md`'s recommended intra-wave merge order).

**Expectation:** `cargo build`/`cargo test` succeed with BOTH diffs applied;
`load_api_token`'s two error branches (A) and `derive_auth_state`'s
kind-specific-probe callers (B1, which itself CALLS `load_api_token`
indirectly via `auth_method == "api_token"`'s probe selection) do not
conflict, shadow, or accidentally invoke each other's changed code paths in
an unintended way. This is the direct regression guard for the file-overlap
risk `wave-schedule.md` §2 flags.

**MUST-PASS.**

### H-W1-INT-003 — The unknown-profile negative pin (A) and the truthful-STATUS positive path (B1) stay on separate tracks

**Setup:** Two DIFFERENT profile-name fixtures in one test session: (a) a
profile name NOT present in `global.profiles` at all; (b) a profile present
in config with `url: Some`, `auth_method: "oauth"`, and no stored OAuth pair.

**Expectation:** (a) `jr auth status --profile <a>` exits 64
(`UserError`, "unknown profile") — UNCHANGED by this cycle. (b) `jr auth
list` reports `<b>`'s STATUS as `no-credentials` (B1's truthful probe) and
`jr auth status --profile <b>` (text mode; JSON mode is Wave 2's own scope)
reports "Credentials: not found" — NEVER exit 64. A mutant that conflates
"unknown profile" handling with "no stored credentials" handling anywhere in
this wave's diff fails this scenario.

**MUST-PASS.**

### H-W1-INT-004 — The regenerated BC-1.6.046 insta snapshot reflects real probing, not a hand-edited placeholder

**Setup:** After B1 lands, run the full `auth list` snapshot test suite.

**Expectation:** The regenerated `.snap` fixture's STATUS column values are
DERIVED from the test's actual injected/mocked keychain state for each of the
3 fixture profiles — not simply re-typed to whatever the implementer expected
without re-running the real code path. (Practical check: temporarily flip one
fixture profile's injected credential state and confirm the snapshot test
FAILS before regenerating again — proving the snapshot is live-derived, not
a static string that happens to look plausible.)

**SHOULD-PASS** (a process-discipline check on HOW the snapshot was
regenerated, not a runtime behavioral proof in its own right — downgraded
from MUST-PASS since insta's own tooling makes accidental static-editing
unlikely, but still worth an explicit verification before this wave's gate
closes).

---

## Wave 1 — Regression Scenarios (Existing Auth Behavior Unchanged)

### H-W1-REG-001 — `auth switch`/`auth logout`/`auth remove`'s unrelated unknown-profile sites stay exit 64

**Setup:** Run the existing (pre-cycle-007, unmodified) test suites for `jr
auth switch <unknown>`, `jr auth logout --profile <unknown>`, `jr auth remove
<unknown>` against the post-cycle-007 binary.

**Expectation:** All three continue to exit 64 with `JrError::UserError` and
`unknown profile` in stderr — BC-1.1.003/005/006, none of which this cycle
touches, remain byte-for-byte unchanged. This is the direct regression guard
for the PRD delta's own scope-narrowing claim (§5.1): the #786
reclassification touches ONLY `src/api/auth.rs::load_api_token`'s two
branches, nothing else in the "profile not found" taxonomy family.

**MUST-PASS. Regression-critical.**

### H-W1-REG-002 — `load_api_token`'s both-credentials-present success path is untouched

**Setup:** Run the existing `load_api_token` success-path tests (both
namespaced keys present) against the post-cycle-007 binary.

**Expectation:** Unchanged — this story (A) touches ONLY the `(None, None)`
and exactly-one-present match arms; the `(Some, Some)` arm is not part of
either story's diff.

**MUST-PASS. Regression-critical.**

### H-W1-REG-003 — `load_api_token`'s backend-error propagation (EC-1.4.031-2) is untouched

**Setup:** Run the existing `load_api_token_propagates_backend_error_not_absent_message`
test (`src/api/auth.rs:~3434`) against the post-cycle-007 binary.

**Expectation:** PASSES unmodified — a genuine keychain backend error still
propagates via `?` and is never coerced into either of this cycle's two
"no credentials"/"incomplete credentials" messages. Neither story A nor B1
touches the `?`-propagation code paths above the two changed match arms.

**MUST-PASS. Regression-critical.**

### H-W1-REG-004 — `auth list`'s NAME/URL/ENV/AUTH columns are unaffected by the STATUS-derivation change

**Setup:** Run the existing `auth list` column-content tests (name, url, env,
auth method columns) against the post-cycle-007 binary.

**Expectation:** Unchanged — B1's diff touches ONLY the STATUS
column/`"status"` field's derivation; the other four columns/fields
(`name`/`url`/`env`/`auth_method`) and the `active` marker are untouched (per
BC-1.6.049 Postcondition 2's own "UNCHANGED... no schema field is added or
removed" guarantee).

**MUST-PASS. Regression-critical.**

### H-W1-REG-005 — `--oauth`'s functional behavior (mechanism selection, deprecation notice emission conditions) is unchanged

**Setup:** Run the existing `--oauth` flag tests (mechanism selection on
`login`, inert-with-notice on `refresh`, `--output json` notice-suppression)
against the post-cycle-007 binary.

**Expectation:** Unchanged — C's diff is a doc-comment-only edit; zero
`#[arg(...)]` attributes or runtime branches change.

**MUST-PASS. Regression-critical.**

### H-W1-REG-006 — README's already-remediated "shared credential model" claim stays remediated

**Setup:** Diff `README.md` before/after D's edit.

**Expectation:** The already-correct (pre-cycle-007) prose describing the
per-profile (not shared) credential model is NOT reverted, duplicated, or
contradicted by D's new bullet — D is a pure addition, not a rewrite of
existing correct content.

**SHOULD-PASS** (a documentation-consistency check, not a runtime behavioral
proof — downgraded from MUST-PASS accordingly, but still worth an explicit
pass/fail determination before this wave's gate closes).

---

## Wave 2 — Cross-Cutting Integration Scenarios

### H-W2-INT-001 — `auth list` STATUS and `auth status --output json`'s `"status"` field NEVER disagree (VP-AUTHDX-024, full end-to-end realization)

**Setup:** A matrix of profile fixtures spanning all 3 vocabulary states ×
both `auth_method` values × the mismatched-kind and both-kinds edge cases
(EC-1.6.048-2/4) — at least 6 distinct profile configurations in one test
session.

**Expectation:** For EVERY fixture, `jr auth list --output json`'s
per-profile `"status"` value and `jr auth status --output json --profile
<same profile>`'s `"status"` value are IDENTICAL. This is the full,
end-to-end realization of VP-AUTHDX-024 — B1 alone can only prove the
pure-function/call-site half; this scenario is what actually exercises BOTH
commands against the SAME real (mocked/injected) keychain state and confirms
they agree, which is the entire point of introducing the shared
`derive_auth_state` helper in the first place.

**MUST-PASS.**

### H-W2-INT-002 — The human-text `Credentials:` line's intentional divergence from the machine `"status"` field is confirmed, not accidentally "fixed"

**Setup:** The `url: None` + matching-kind-credential-present fixture
(EC-1.6.050-4, B2's own AC-008).

**Expectation:** `jr auth status`'s human-text `Credentials:` line reads
"stored in keychain" while BOTH `jr auth status --output json`'s `"status"`
field AND `jr auth list`'s STATUS column for the same profile read `"unset"`.
A reviewer or implementer who "fixes" this by making the text line
url-aware (contradicting BC-1.6.050 Postcondition 6's byte-for-byte-
unchanged guarantee) or by making the JSON channels ignore `url` (contradicting
BC-1.6.048 Postcondition 1) BREAKS this scenario — it exists specifically to
catch that over-eager "fix."

**MUST-PASS.**

### H-W2-INT-003 — `derive_auth_state`'s call sites in `list.rs` (B1) and `status.rs` (B2) are structurally the SAME function, not two copies

**Setup:** Static/structural check (not a runtime behavioral test): grep or
AST-level confirmation that both `src/cli/auth/list.rs` and `src/cli/auth/
status.rs` import and call the identical `derive_auth_state` symbol from
`src/api/auth.rs` — never a locally-redefined or copy-pasted equivalent.

**Expectation:** Exactly one definition of `derive_auth_state` exists in the
codebase; both call sites reference it. This is the mechanism-level guarantee
behind H-W2-INT-001's runtime parity — if a future refactor accidentally
forks the logic, this scenario catches it even before a differential runtime
test would notice (e.g. if the fork happens to produce identical output on
the specific fixtures tested).

**MUST-PASS.**

---

## Wave 2 — Regression Scenarios (Existing Auth Behavior Unchanged)

### H-W2-REG-001 — `auth status`'s human-text output is byte-for-byte identical, pre- vs. post-cycle-007, across the FULL profile-configuration matrix

**Setup:** Capture `jr auth status`'s human-text stdout for every fixture in
H-W2-INT-001's matrix (6+ profile configurations) against the PRE-cycle-007
binary (or a recorded golden baseline) and the POST-cycle-007 binary.

**Expectation:** Byte-for-byte IDENTICAL for every fixture — this is the
single most load-bearing regression guarantee in the whole cycle (BC-1.6.050
Postcondition 6, revised round 3/6 specifically to make this claim
unconditional). A single differing byte anywhere in this matrix is a
regression, not an acceptable "correction."

**MUST-PASS. Regression-critical.**

### H-W2-REG-002 — `auth status`'s existing exit-64 unknown-profile behavior is unaffected by the new `&OutputFormat` parameter

**Setup:** `jr auth status --profile <unknown>` in both table mode and
`--output json` mode, against the post-cycle-007 binary.

**Expectation:** Both modes exit 64 with `JrError::UserError`; `--output
json` mode emits the STANDARD `{"error": ..., "code": 64}` envelope (never
B2's new 6-key success schema). Threading `&OutputFormat` through `status()`
must not accidentally move the unknown-profile check to AFTER any new
output-format branching.

**MUST-PASS. Regression-critical.**

### H-W2-REG-003 — `auth status`'s fresh-install zero-profiles early-return is unaffected

**Setup:** Fresh install, zero profiles, `jr auth status --output json` (no
`--profile`).

**Expectation:** Unchanged — human-text-only stderr message, exit 0, no
stdout JSON (BC-1.6.050 EC-1.6.050-2, B2's own AC-010).

**MUST-PASS. Regression-critical.**

---

## Summary

| Scenario | Priority | Wave | Type |
|----------|----------|------|------|
| H-W1-INT-001 | MUST-PASS | 1 | Cross-cutting integration (A+B1 user journey) |
| H-W1-INT-002 | MUST-PASS | 1 | Cross-cutting integration (file-overlap compile/merge) |
| H-W1-INT-003 | MUST-PASS | 1 | Cross-cutting integration (negative pin vs. positive path) |
| H-W1-INT-004 | SHOULD-PASS | 1 | Cross-cutting integration (snapshot regen discipline) |
| H-W1-REG-001 | MUST-PASS | 1 | Regression (switch/logout/remove unknown-profile) |
| H-W1-REG-002 | MUST-PASS | 1 | Regression (load_api_token success path) |
| H-W1-REG-003 | MUST-PASS | 1 | Regression (backend-error propagation) |
| H-W1-REG-004 | MUST-PASS | 1 | Regression (auth list other columns) |
| H-W1-REG-005 | MUST-PASS | 1 | Regression (--oauth functional behavior) |
| H-W1-REG-006 | SHOULD-PASS | 1 | Regression (README consistency) |
| H-W2-INT-001 | MUST-PASS | 2 | Cross-cutting integration (VP-AUTHDX-024 full parity) |
| H-W2-INT-002 | MUST-PASS | 2 | Cross-cutting integration (intentional divergence confirmed) |
| H-W2-INT-003 | MUST-PASS | 2 | Cross-cutting integration (shared call-site structural proof) |
| H-W2-REG-001 | MUST-PASS | 2 | Regression (human-text byte-for-byte, full matrix) |
| H-W2-REG-002 | MUST-PASS | 2 | Regression (unknown-profile unaffected by OutputFormat threading) |
| H-W2-REG-003 | MUST-PASS | 2 | Regression (fresh-install early-return) |

**16 scenarios total (14 MUST-PASS, 2 SHOULD-PASS)** — Wave 1 has 4
integration scenarios (H-W1-INT-001..004) + 6 regression scenarios
(H-W1-REG-001..006) = 10 scenarios; Wave 2 has 3 integration scenarios
(H-W2-INT-001..003) + 3 regression scenarios (H-W2-REG-001..003) = 6
scenarios; 10 + 6 = 16 total, matching the table above. Neither wave's gate
may close with any MUST-PASS scenario failing; SHOULD-PASS failures must be
explicitly acknowledged (not silently skipped) before the respective gate
closes.
