---
document_type: consistency-check
phase: phase-f1-delta-analysis
producer: consistency-validator
issue: 327
status: complete
created: 2026-05-26
scope: f1-pre-human-approval-gate
---

# F1 Consistency Check — Issue #327 (`rand` 0.9.4 → 0.10.1)

**Audit date:** 2026-05-26
**Artifacts audited:**
- `.factory/phase-f1-delta-analysis/issue-327/delta-analysis.md`
- `.factory/phase-f1-delta-analysis/issue-327/business-analyst-input.md`
- `.factory/phase-f1-delta-analysis/affected-files-327.txt`

**Method:** Read-only cross-reference verification. No source artifacts modified.

---

## Summary Table

| # | Check | Result | Severity |
|---|-------|--------|----------|
| 1 | BC-1.5.035 existence and content | PASS | — |
| 2 | Adjacent BCs (1.5.040, 1.5.031, 1.5.039, 1.3.023) | PASS | — |
| 3 | 6 stories in regression zone | WARN | Advisory |
| 4 | Test references (3 unit tests, lines 1185-1224) | PASS | — |
| 5 | `generate_state` call site in `oauth_login` at line 577 | PASS | — |
| 6 | ADR-0006 existence and title | PASS | — |
| 7 | Migration assessment — `Verdict` + `SMALL-MIGRATION-NEEDED` | PASS | — |
| 8 | Frontmatter sanity (7 fields) | PASS | — |
| 9 | Random file path spot-check | PASS | — |

---

## Detailed Findings

---

### Check 1 — BC-1.5.035 existence and content

**Claim:** BC-1.5.035 exists at `.factory/specs/prd/bc-1-auth-identity.md` line 395 and contracts "32 bytes from OsRng encoded as 64 hex chars."

**Verification:** Read `bc-1-auth-identity.md` at lines 385-454.

**Finding:**

Line 395 reads exactly:

```
#### BC-1.5.035: `generate_state()` produces 32 bytes from OsRng encoded as 64 hex chars
```

The H4 heading, the BC ID, and the behavioral text all match the claim verbatim. The body immediately below (lines 397-401) confirms: Confidence HIGH, Source `src/api/auth.rs:882`, Subject Auth & Identity, Behavior describes CSRF state token generation.

**Result: PASS**

---

### Check 2 — Adjacent BCs (1.5.040, 1.5.031, 1.5.039, 1.3.023)

**Claim:** All four adjacent BC IDs exist somewhere in `.factory/specs/prd/bc-1-auth-identity.md`.

**Verification:** Grepped `bc-1-auth-identity.md` for each ID.

| BC ID | Line found | H4 heading text |
|-------|-----------|-----------------|
| BC-1.3.023 | 264 | `DEFAULT_OAUTH_SCOPES includes \`offline_access\`, CMDB scopes, \`write:jira-work\`, and \`write:servicedesk-request\`` |
| BC-1.5.031 | 355 | `Embedded OAuth callback URL is exactly \`http://127.0.0.1:53682/callback\`` |
| BC-1.5.039 | 435 | `OAuth token stored as \`<profile>:oauth-access-token\` and \`<profile>:oauth-refresh-token\` post-login` |
| BC-1.5.040 | 445 | `OAuth callback validates state (CSRF check) before token exchange` |

All four IDs resolve. Line numbers match the F1 claims within ±1.

**Result: PASS**

---

### Check 3 — 6 stories in regression zone

**Claim:** S-1.06, S-1.08, S-3.01, S-3.03, S-3.04, issue-288-pr4-dispatch all exist as story files.

**Verification:** Inspected `.factory/stories/wave-1/`, `wave-3/`, and `.factory/code-delivery/`.

| Story ID | BA-cited filename | Actual filename / location | Match? |
|----------|-------------------|---------------------------|--------|
| S-1.06 | `wave-1/S-1.06-oauth-flow-holdout-suite.md` | `wave-1/S-1.06-oauth-flow-holdout-suite.md` | Exact |
| S-1.08 | `wave-1/S-1.08-keychain-roundtrip-holdout.md` | `wave-1/S-1.08-keychain-roundtrip-holdout.md` | Exact |
| S-3.01 | `wave-3/S-3.01-refactor-auth-rs-shard-split.md` | `wave-3/S-3.01-refactor-auth-rs-shard-split.md` | Exact |
| S-3.03 | `wave-3/S-3.03-refresh-oauth-token-investigation.md` | `wave-3/S-3.03-auto-refresh-oauth-on-401-with-single-flight.md` | **NAME DRIFT** |
| S-3.04 | `wave-3/S-3.04-multi-cloudid-disambiguation.md` | `wave-3/S-3.04-multi-cloudid-disambiguation.md` | Exact |
| issue-288-pr4-dispatch | `code-delivery/issue-288-pr4-dispatch/story.md` | `code-delivery/issue-288-pr4-dispatch/story.md` | Exact |

**Finding — WARN (advisory):** S-3.03's filename is cited in the BA input as
`S-3.03-refresh-oauth-token-investigation.md` but the actual filename on disk is
`S-3.03-auto-refresh-oauth-on-401-with-single-flight.md`. The story itself exists and
is in the correct wave directory. The discrepancy is a slug mismatch in the BA input
only — the delta-analysis body does not repeat the filename, only the story ID and PR
number. The regression-zone table in the delta-analysis body uses only the story ID
`S-3.03` without a filename path, so the drift is contained to the BA document.

**Severity:** WARN — advisory. The story exists; only the cited filename slug is wrong
in the BA input. Does not block human approval; the implementer can locate the file by
its ID prefix. Recommend correcting the BA document during F2.

**Result: WARN** (story exists; filename citation in BA input has a slug mismatch)

---

### Check 4 — Test references (3 unit tests, lines 1185-1224)

**Claim:** `test_generate_state_is_hex`, `test_generate_state_is_64_hex_chars`, and
`test_generate_state_is_not_deterministic` exist at `src/api/auth.rs:1185-1224`.

**Verification:** Read `src/api/auth.rs` lines 1175-1224.

| Test name | Actual start line | Claim line | Match? |
|-----------|------------------|------------|--------|
| `test_generate_state_is_hex` | 1185 | 1185 | Exact |
| `test_generate_state_is_64_hex_chars` | 1196 | 1196 | Exact |
| `test_generate_state_is_not_deterministic` | 1212 | 1205 | Off by 7 |

**Finding on `test_generate_state_is_not_deterministic`:** The function definition `fn
test_generate_state_is_not_deterministic()` appears at line 1212, not line 1205 as cited.
Lines 1205-1211 contain a multi-line doc comment for the test. The BA table cites the
range "src/api/auth.rs:1205-1224" with the third test starting at 1205 — that is the
start of the doc comment block, not the `fn` line. This is a minor line-number
approximation, not a hallucination. All three test function names are confirmed present.

**Result: PASS** (all three test names confirmed; off-by-7 on third test start line is a
doc-comment vs fn-line distinction — within acceptable tolerance)

---

### Check 5 — `generate_state` call site in `oauth_login` at line 577

**Claim:** `generate_state` is called from `oauth_login` at line 577 of `src/api/auth.rs`.

**Verification:** Read `src/api/auth.rs` lines 570-584.

Line 577 reads:

```rust
    let state = generate_state()?;
```

This is inside the `oauth_login` function body (confirmed by surrounding context: the
lines before it show `strategy.bind()`, `redirect_uri`, `into_parts()` — all part of
the OAuth login flow setup).

**Result: PASS** (exact line 577, exact function name, exact caller)

---

### Check 6 — ADR-0006 existence and title

**Claim:** ADR-0006 covers "embedded `jr` OAuth app with compile-time XOR obfuscation."

**Verification:** Searched for `0006*` under `docs/adr/`.

File found: `/Users/zious/Documents/GITHUB/jira-cli/docs/adr/0006-embedded-jr-oauth-app.md`

H1 heading: `# ADR-0006: Embedded \`jr\` OAuth App with Compile-Time Obfuscation`

Body line 12 reads: "Ship official `jr` binaries with an embedded `client_id` and
`client_secret` for a dedicated `jr` Atlassian OAuth app. The secret is obfuscated via
a per-build random 32-byte XOR key to defeat automated secret scanners."

Title and XOR-obfuscation content match the claim. The CLAUDE.md shorthand "compile-time
XOR obfuscation" maps accurately to the ADR content.

**Note:** The CLAUDE.md entry for ADR-0006 says it "re-supersedes ADR-0002"; confirmed
by the file listing (ADR-0002 is `0002-oauth-embedded-secret.md`, which is the predecessor).

**Result: PASS**

---

### Check 7 — Migration assessment: `Verdict` section + `SMALL-MIGRATION-NEEDED`

**Claim:** `.factory/research/rand-0.10-migration-assessment.md` exists with a `Verdict`
section containing "SMALL-MIGRATION-NEEDED."

**Verification:** File confirmed present. Grep for `Verdict` and `SMALL-MIGRATION-NEEDED`:

- Line 10: `## Verdict`
- Line 12: `**SMALL-MIGRATION-NEEDED** — ≤30 LOC edited, no semantic shift, no behavioral change.`

Both conditions satisfied.

**Result: PASS**

---

### Check 8 — Frontmatter sanity (7 fields)

**Claim:** `delta-analysis.md` frontmatter has specific values for 7 fields.

**Verification:** Read `delta-analysis.md` lines 1-22 (YAML frontmatter block).

| Field | Claimed value | Actual value | Match? |
|-------|--------------|--------------|--------|
| `status` | `ready-for-human-review` | `ready-for-human-review` | Exact |
| `intent` | `enhancement` | `enhancement` | Exact |
| `producer` | `architect` | `architect` | Exact |
| `issue` | `327` | `327` | Exact |
| `mode` | `BROWNFIELD` | `BROWNFIELD` | Exact |
| `regression_risk` | `low` | `low` | Exact |
| `trivial_scope` | `true` | `true` | Exact |

All 7 fields match their claimed values exactly.

**Result: PASS**

---

### Check 9 — Random file path spot-check

**5 paths sampled from the delta-analysis body:**

| Path cited | Exists on disk? |
|-----------|----------------|
| `src/api/auth.rs` | YES |
| `Cargo.toml` (line 34: `rand = "0.9"`) | YES — line 34 confirmed: `rand = "0.9"` |
| `deny.toml` (`multiple-versions = "deny"` at line 21) | YES — rule at line 21 confirmed |
| `.factory/research/rand-0.10-migration-assessment.md` | YES |
| `docs/adr/0006-embedded-jr-oauth-app.md` | YES |

**Bonus verification — deny.toml line number drift:** The BA input cites
`bans.multiple-versions = "deny"` at line 20; the architect's delta-analysis cites
line 21. The actual content is on line 21 (`multiple-versions = "deny"` under `[bans]`).
The BA is off by one (line 20 is `[bans]`); the architect's line 21 is correct.
Minor line-number divergence between the two F1 documents, within tolerance.

**Result: PASS**

---

## Additional Observations (not blocking)

**OBS-1 — `generate_state` source citation in BC-1.5.035:** The BC body cites
`src/api/auth.rs:882` as the source. The actual `fn generate_state()` definition is at
line 1093. Line 882 is elsewhere in `auth.rs`. This is a BC-body source annotation issue
that pre-dates this F1 work — not introduced by the delta-analysis — and is out of scope
for this audit. It does not affect the behavioral claim or the F1 analysis accuracy.

**OBS-2 — S-3.03 filename slug mismatch (amplifying Check 3):** The BA input's story
file table cites `S-3.03-refresh-oauth-token-investigation.md`. This slug likely
reflects an earlier working title ("investigate + wire `refresh_oauth_token`" appears
in the delta-analysis regression-zone table's `Relevance` column). The actual file is
`S-3.03-auto-refresh-oauth-on-401-with-single-flight.md`. The title used in the
regression-zone table in `delta-analysis.md` (`"Investigate + wire refresh_oauth_token"`)
is also a mismatch with the actual file's subject (the file covers single-flight auto-
refresh on 401, per CLAUDE.md and PR #321). These are cosmetic slug drifts from the
story's final naming. Not a hallucinated story — the file is real.

**OBS-3 — `oauth_flow_holdouts.rs` confirmed:** The BA input cites
`tests/oauth_flow_holdouts.rs` as an integration test that exercises the `oauth_login`
path. File confirmed present at `tests/oauth_flow_holdouts.rs`. The BA's other cited
test files (`tests/oauth_embedded_login.rs`, `tests/oauth_refresh_integration.rs`,
`tests/auth_profiles.rs`) also confirmed present.

---

## Verdict

All blocking checks (1-2, 4-9) PASS. One advisory WARN on Check 3 (S-3.03 filename slug
mismatch in BA input — story exists, filename citation is wrong in the BA document).
No hallucinated BCs, stories, or file paths. Frontmatter is correct. Line number
references are accurate within acceptable tolerance (doc-comment vs fn-line distinction
on one test; ±1 on one deny.toml line number across two documents).

**READY-FOR-HUMAN-REVIEW**
