---
document_type: story
story_id: "S-E2E-4"
title: "E2E M2: new regression coverage — read/discovery, write/behavioral, error paths"
wave: feature-followup
status: draft
intent: enhancement
feature_type: infrastructure
scope: non-trivial
severity: medium
trivial_scope: false
issue: TBD
points: 5
priority: P2
tdd_mode: strict
estimated_effort: medium
mode: feature
depends_on: [S-E2E-3]
bc_anchors: []
# BC delta: EMPTY — this story adds new gated test coverage for existing shipped contracts.
# No new product behavioral contracts are introduced.
# Every AC traces to an existing BC from BC-INDEX.md (confirmed in
# .factory/phase-f2-spec-evolution/prd-delta-e2e-enhancements.md §2).
# BC status: no BC authorship required.
# Status=draft: the spec-first gate (S-7.01) does not block dispatch for
# infrastructure-only stories with explicit justification above.
bcs:
  - BC-2.5.043
  - BC-2.5.044
  - BC-2.5.045
  - BC-2.5.046
  - BC-2.6.051
  - BC-3.1.003
  - BC-3.6.001
  - BC-3.6.004
  - BC-3.6.005
  - BC-7.3.006
  - BC-X.3.002
  - BC-X.6.004
verification_properties: []
holdout_anchors: []
nfr_anchors: [NFR-T-E2E-1]
adr_refs: []
sd_refs: [SD-002]
parent_phase: F3-story-decomposition
spec_source: "docs/specs/e2e-test-enhancements.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 14
created: "2026-05-30"
traceability_note: >
  BC delta is EMPTY (test-infrastructure enhancement; no new product behavioral contracts).
  ACs trace to existing BCs confirmed in prd-delta-e2e-enhancements.md §2.
  The source meta-guard test_every_ignored_test_has_gate_guard (always-run) enforces
  that every new gated test has e2e_enabled() before any live call; this guard runs
  in ci.yml and blocks any merge that omits it (HIGH regression risk for the gate,
  LOW for the new test behaviors themselves).
  Note: BC-2.6.051 appears in frontmatter as the canonical ID; the F1 delta analysis
  incorrectly listed BC-6.2.051 (transposition confirmed in prd-delta §2 CORRECTION row).
files_modified:
  - tests/e2e_live.rs   # MODIFIED — add 11 new gated test functions
breaking_change: false
assumption_validations: []
risk_mitigations: []
last_updated: "2026-05-30"
changelog:
  - date: "2026-05-30"
    phase: F3-story-decomposition
    author: story-writer
    summary: Initial story creation.
---

# S-E2E-4 — E2E M2: New Regression Coverage (Read/Discovery, Write/Behavioral, Error Paths)

## Source of Truth

Design spec: `/Users/zious/Documents/GITHUB/jira-cli/docs/specs/e2e-test-enhancements.md`
Sections: §6 (Milestone M2) — §6.1 Read/discovery, §6.2 Write/behavioral, §6.3 Error paths
PRD delta: `.factory/phase-f2-spec-evolution/prd-delta-e2e-enhancements.md` (BC delta = EMPTY)
Foundation: S-E2E-3 (provides `poll_jql`, `assert_key_format`, `assert_status_category`,
`assert_issue_shape`, `assert_array_of_objects_with_keys`, `is_transient_error`)

**No new BCs. Zero `src/` changes. Only `tests/e2e_live.rs` is modified.**

## Goal

Add new gated test functions covering high-value command families and error paths that have zero
live coverage after S-E2E-1/S-E2E-2. Every new test is `#[ignore]` + `e2e_enabled()` guard +
self-seeding (no inter-test dependency). Tests use the foundation helpers from S-E2E-3.

Organized into three groups: §6.1 read/discovery (7 new tests), §6.2 write/behavioral (4 new
tests), §6.3 error/exit-code paths (3 new tests; no mutation).

## Dependency Justification

**S-E2E-4 depends on S-E2E-3** because: `poll_jql` (used in §6.2 pagination dedup and bulk move
verification), `assert_key_format`, `assert_issue_shape`, `assert_array_of_objects_with_keys`,
and `assert_status_category` (used throughout §6.1 and §6.2) must be defined in `tests/e2e_live.rs`
before any test in this story can compile. S-E2E-3 builds the foundation; S-E2E-4 uses it.

## Traceability

| Traceability target | Type | Description |
|--------------------|------|-------------|
| BC-2.5.043 | Existing BC | `issue changelog` filter |
| BC-2.5.044 | Existing BC | `issue changelog` reverse |
| BC-2.5.045 | Existing BC | `issue changelog` field filter |
| BC-2.5.046 | Existing BC | `issue changelog` output shape |
| BC-2.6.051 | Existing BC | `search_issues` deduplicates results in-place (JRACLOUD-95368 mitigation) |
| BC-3.1.003 | Existing BC | `assign` resolves current user via `/myself` |
| BC-3.6.001 | Existing BC | `issue link` POSTs with default type 'Relates' |
| BC-3.6.004 | Existing BC | `issue unlink` DELETEs and accepts 204 |
| BC-3.6.005 | Existing BC | `issue link-types` returns link types |
| BC-7.3.006 | Existing BC | `JrError::exit_code()` mapping |
| BC-X.3.002 | Existing BC | 401 → exit 2, universal |
| BC-X.6.004 | Existing BC | `team list` cache-first (7d TTL) |
| NFR-T-E2E-1 | NFR (MEDIUM) | Obligation to keep the E2E suite runnable and wired into CI |
| Design spec §6.1 | M2 read | New read/discovery gated tests |
| Design spec §6.2 | M2 write | New behavioral gated tests |
| Design spec §6.3 | M2 error | Exit-code path gated tests |

## Behavioral Contracts

None new — all tests verify existing contracts. BC delta is EMPTY.

| BC | Title (from BC-INDEX) | AC |
|----|----------------------|----|
| BC-2.5.043 | `issue changelog` filter | AC-003 |
| BC-2.5.044 | `issue changelog` reverse | AC-003 |
| BC-2.5.045 | `issue changelog` field filter | AC-003 |
| BC-2.5.046 | `issue changelog` output shape | AC-003 |
| BC-2.6.051 | `search_issues` deduplicates in-place (JRACLOUD-95368) | AC-011 |
| BC-3.1.003 | `assign` resolves self via `/myself` | AC-007 |
| BC-3.6.001 | `issue link` default type 'Relates' | AC-008 |
| BC-3.6.004 | `issue unlink` DELETE 204 | AC-008 |
| BC-3.6.005 | `issue link-types` returns types | AC-006 |
| BC-7.3.006 | `JrError::exit_code()` mapping table | AC-012, AC-013, AC-014 |
| BC-X.3.002 | 401 → exit 2, universal | AC-014 |
| BC-X.6.004 | `team list` cache-first 7d TTL | AC-005 |

## Acceptance Criteria

> **Universal gate rule (applies to ALL acceptance criteria in this story):** Every new test
> function annotated `#[ignore]` MUST have `if !e2e_enabled() { return; }` as the FIRST
> executable statement before any live call, command construction, or data seeding. This is
> enforced automatically by `test_every_ignored_test_has_gate_guard`.

---

### § 6.1 — Read / Discovery Tests

### AC-001 — `issue transitions` shape (traces to BC-7.3.006; spec §6.1)

`test_e2e_issue_transitions_returns_array`: seeds one issue via the write flow; runs
`issue transitions <key> --output json`; asserts:

1. Exit 0.
2. Output is a JSON array (`v.is_array()`).
3. If non-empty: each element has `id` (string) and `name` (string).
4. If a `to` field is present on any element: `to` is an object with `statusCategory.key`
   in `{"new", "indeterminate", "done"}` (use `assert_status_category` on `element["to"]`).

**Critical constraint (C-2):** the `Transition` struct has NO `to_category` field. There is
no top-level `to_category`. The category is nested at `to.statusCategory.key`. Do NOT assert
`element["to_category"]`.

Spec reference: §6.1 — "each element has `id` + `name` (both `String`, guaranteed); treat
`to` as present-or-absent. For a portable category assertion use
`element["to"]["statusCategory"]["key"] ∈ {new, indeterminate, done}`."

### AC-002 — `issue comments` standalone shape (traces to BC-2.4.039; spec §6.1)

`test_e2e_issue_comments_returns_array` (standalone, beyond the M1 write-flow read-back):
seeds one issue with a comment; runs `issue comments <key> --output json`; asserts:

1. Exit 0.
2. Output is a JSON array.
3. At least one element is present (we seeded one comment).

This test is separate from the write-flow comment read-back (AC-013 in S-E2E-3) — it
exercises the standalone `issue comments` command path in a self-contained test.

Spec reference: §6.1 — "`issue comments <key>` → array shape (standalone, beyond the M1 write-flow read-back)."

### AC-003 — `issue changelog` shape (traces to BC-2.5.043–046; spec §6.1)

`test_e2e_issue_changelog_returns_object`: seeds one issue, edits its summary, runs
`issue changelog <key> --output json`; asserts:

1. Exit 0.
2. Output is a JSON object (`v.is_object()`).
3. `v["key"]` is present and is a string.
4. `v["entries"]` is present and is an array.

**Critical constraint (F-03):** the JSON shape is `ChangelogOutput { key, entries }` — it is
NOT a bare array and the array key is `entries`, NOT `histories`. Do NOT assert `v.is_array()`
or `v["histories"]`.

Spec reference: §6.1 — "`issue changelog <key>` → **object** shape `{key, entries}`; assert
`v.is_object()` and `v["entries"].is_array()` (F-03)."

### AC-004 — `board view` bare array (traces to BC-5.1.001; spec §6.1)

`test_e2e_board_view_returns_array`: gated on `JR_E2E_BOARD_ID` set and non-empty; runs
`board view --board <JR_E2E_BOARD_ID> --output json`; asserts:

1. If `JR_E2E_BOARD_ID` is unset or empty: clean-skip (return early, no assertion, no failure).
2. If the command exits non-zero and stderr contains `"No active sprint"`: clean-skip (the
   board has no active sprint — not a failure).
3. Otherwise: exit 0 + output is a JSON array.
4. If non-empty: `assert_issue_shape` on each element.

**Critical constraint (H-1):** `board view --output json` is a **bare JSON array of issue
objects**, NOT an object. `handle_view` serializes `Vec<Issue>`. `--board` is a **flag** (not a
positional argument). Do NOT assert `v.is_object()` or look for a `"board"` wrapper key.

Spec reference: §6.1 — "`board view --board <board_id>` → **bare JSON array of issue objects**.
`--board` is a **flag**."

### AC-005 — `team list` empty-org clean-skip (traces to BC-X.6.004; spec §6.1)

`test_e2e_team_list_returns_array_or_skips`: runs `team list --output json`; asserts:

1. Exit 0.
2. If stdout is empty (empty-org path — `handle_list` prints "No teams found." to stderr and
   exits 0 with empty stdout): clean-skip (do NOT call `serde_json::from_slice` on empty input;
   print an `eprintln!` skip notice).
3. If stdout is non-empty: parse as JSON array; if non-empty, verify shape with
   `assert_array_of_objects_with_keys` (what keys are guaranteed is instance-dependent; at
   minimum assert the array is parseable as JSON).

**Critical constraint:** empty stdout + exit 0 is a VALID outcome, NOT a test failure. Do NOT
`unwrap()` or `expect()` on a parse of empty stdout.

Spec reference: §6.1 — "when the org has no teams, `handle_list` prints `'No teams found.'` to
**stderr** and exits **0** with **empty stdout**. Clean-skip condition is **empty stdout + exit 0**."

### AC-006 — `issue link-types` shape (traces to BC-3.6.005; spec §6.1)

`test_e2e_issue_link_types_returns_array`: runs `issue link-types --output json`; asserts:

1. Exit 0.
2. Output is a JSON array.
3. If non-empty: each element has `name` present (string). Do NOT assert `id`, `inward`, or
   `outward` — those are `Option` in `IssueLinkType` and serialize as null; only `name` is
   guaranteed (F-06).

Spec reference: §6.1 — "assert only `name` present (F-06: `id`/`inward`/`outward` are `Option`
in `IssueLinkType` and serialize as null — only `name` is guaranteed)."

### AC-007 — `user view <accountId>` shape (traces to BC-3.1.003; spec §6.1)

`test_e2e_user_view_returns_object`: resolves self-accountId from `user search` seed output
(reads `accountId` from first non-empty result); runs `user view <accountId> --output json`;
asserts:

1. If self-resolution yields nothing (empty `user search` result): clean-skip (Browse Users
   permission may make `user search` return empty; no accountId available → skip, do NOT fail).
2. If accountId resolved: exit 0; output is a JSON object; `v["accountId"]` is present.

**`accountId` is a positional argument** to `user view`, not a flag. `account_id` is the Rust
field; the JSON key after serde rename is `accountId` (verify in `src/types/jira/users.rs`
per DI-E2E-F2-2 from S-E2E-3).

Spec reference: §6.1 — "`user view <accountId>` → object with `accountId`. Resolve self via the
`user search` seed — but **clean-skip if self-resolution yields nothing**."

---

### § 6.2 — Write / Behavioral Tests

### AC-008 — `issue link` / `issue unlink` round-trip (traces to BC-3.6.001, BC-3.6.004; spec §6.2)

`test_e2e_issue_link_and_unlink`: self-seeds by creating two issues (A and B); asserts:

1. `issue link A B --output json` (omit `--type` to use built-in default `Relates`): exit 0.
2. `poll_view(A)`: traverse `fields.issuelinks[]` and assert B's key appears under EITHER
   `inwardIssue.key` OR `outwardIssue.key` (F-09: the GET-render side that carries the partner
   key is not contractually fixed — check both). Assert link presence by key, NOT by
   `type.name` (avoids coupling to the link-type label).
3. `issue unlink A B --output json`: exit 0.
4. `poll_view(A)`: assert no `issuelinks` entry references B (check both `inwardIssue.key` and
   `outwardIssue.key`).

**Portability constraint:** omit `--type` entirely (default `Relates` is present on essentially
all Jira Cloud instances; picking the first `link-types` entry would depend on instance-specific
ordering).

Spec reference: §6.2 — "omit `--type` to use the built-in default `Relates` … assert the link
to B is present by traversing `fields.issuelinks[]` and matching B's key under **either**
`inwardIssue.key` **or** `outwardIssue.key`."

### AC-009 — `issue assign` self-assignment round-trip (traces to BC-3.1.003; spec §6.2)

`test_e2e_issue_assign_self`: self-seeds one issue; asserts:

1. `issue assign <key>` with the assignee **omitted** (no `--me` flag, no `--to` flag): exit 0.
   There is NO `--me` flag — `handle_assign` falls to the `client.get_myself()` branch when no
   assignee is given. Do NOT attempt `issue assign <key> --me`; that flag does not exist (F-01).
2. `poll_view(key)`: assert `v["fields"]["assignee"]["accountId"]` is a non-null string.

**Read accountId from `poll_view` body**, not from the assign command output. The assign
command's own JSON is flat `{key, assignee, assignee_account_id, changed}` — the accountId
is in the view body.

Spec reference: §6.2 — "`issue assign <key>` with the assignee **omitted** → self-assignment
(there is NO `--me` flag; F-01 — `handle_assign` falls to the `client.get_myself()` branch)."

### AC-010 — `issue edit --dry-run` no-mutation round-trip (traces to BC-2.2.028; spec §6.2)

`test_e2e_issue_edit_dry_run_no_mutation`: self-seeds one issue with a known summary S1;
asserts:

1. `issue edit <key> --summary <S2> --dry-run --output json`: exit 0.
2. Output is valid JSON.
3. `poll_view(key)`: assert `fields.summary` equals S1 (the original value — the dry-run
   MUST NOT have mutated it). This is the load-bearing assertion.

Do NOT hard-pin dry-run JSON key names beyond verifying it is valid JSON — the no-mutation
round-trip is the portable contract (spec: "do NOT hard-pin dry-run JSON key names the spec
hasn't verified"). No write must occur.

Spec reference: §6.2 — "assert (a) output is **valid JSON**, and (b) **no mutation** occurred —
a subsequent `poll_view` shows the summary **unchanged**."

### AC-011 — Pagination dedup (traces to BC-2.6.051; spec §6.2)

`test_e2e_pagination_dedup`: self-seeds 3 issues, each labeled with a per-test-unique nonce
label (format: `e2e-<run_id>-<run_attempt>-pgN` or equivalent using `run_label()` plus a
random or per-call nonce — NOT just `run_id` alone, which re-runs share); asserts:

1. All 3 issues created successfully (capture their keys).
2. `poll_jql("labels=<unique_label> ORDER BY key ASC", |v| v.as_array().map_or(false, |a| a.len() >= 3), FailOnShort(3))`:
   - If budget exhausted with 0 results: clean-skip (pure index lag — `poll_jql` SkipOnEmpty-equivalent
     behavior for the 0-result case in FailOnShort mode per AC-002 of S-E2E-3).
   - If budget exhausted with 1 or 2 results: **FAIL loudly** (some-but-not-all = regression).
   - On success (`>= 3` results): continue.
3. On success: assert returned keys are **duplicate-free** (use a `HashSet` check).
4. Assert the 3 created keys are a **superset of** the returned keys (NOT "exactly 3" — dedup
   contract is under test; an exact count adds a flake vector).

**Label uniqueness (M-2):** embed both `run_id` and a per-attempt discriminator (e.g.,
`GITHUB_RUN_ATTEMPT` env var, falling back to a random suffix for local runs). A bare `run_id`
is reused on workflow re-runs, inflating the label count across runs.

**JQL correctness:** `labels=<label>` (exact match) is valid JQL for the labels field. Do NOT
use `labels ~ "..."` (CONTAINS is not supported on labels).

Spec reference: §6.2 — "create 3 issues under one **per-test-unique** label … `labels=<unique-L>`
exact match … assert the returned keys are **duplicate-free** and are a **superset of** the 3
created keys (NOT 'exactly 3')."

---

### § 6.3 — Error / Exit-Code Paths

> **No-mutation rule:** all three error tests assert exit code and output shape only. None
> perform any write. None assert error message substrings (locale/wording-fragile per
> spec §6.3 and the JRACLOUD-95368 lesson).
>
> **No JSON error envelope (H-2):** `jr` does NOT emit a machine-readable JSON error object on
> these failure paths. `JrError` renders to stderr as a plain string. stdout is EMPTY on the
> error path. Do NOT call `serde_json::from_slice(stdout)` — it will fail on empty input.
> Assert: exit code in expected set + stdout is empty + "no panic" (process did not abort).

### AC-012 — 404 → exit ∈ {1, 64} (traces to BC-7.3.006; spec §6.3)

`test_e2e_issue_view_404_exits_nonzero`: runs `issue view E2E-99999999 --output json`; asserts:

1. Exit code is in `{1, 64}` (most likely 1 via `ApiError` catch-all; `issue view` may remap
   to `UserError` → 64; accept either; do NOT assert a single fixed code without reading the
   handler's specific remap branch).
2. Stdout is empty (no JSON error envelope).
3. Process did not panic (exit code is not 101 / `SIGABRT`).
4. Error text appears on stderr (do NOT assert its wording or any substring).

Spec reference: §6.3 — "`issue view E2E-99999999 --output json` → assert exit **∈ {1, 64}**.
Stdout empty; error text on stderr (do not assert its wording)."

### AC-013 — 400 malformed JQL → exit ∈ {1, 64} (traces to BC-7.3.006; spec §6.3)

`test_e2e_issue_list_bad_jql_exits_nonzero`: runs
`issue list --jql "this is not valid (" --output json`; asserts:

1. Exit code is in `{1, 64}` (`handle_list` may wrap the JQL 400 in `UserError` → 64 with a
   hint; raw → `ApiError` → 1; accept either).
2. Stdout is empty.
3. Process did not panic.
4. Error text appears on stderr (do NOT assert its wording).

Spec reference: §6.3 — "`issue list --jql "this is not valid ("` → assert exit **∈ {1, 64}**."

### AC-014 — 401 bad auth → exit 2 (traces to BC-X.3.002, BC-7.3.006; spec §6.3)

`test_e2e_bad_auth_exits_2`: constructs a well-formed but wrong `JR_AUTH_HEADER` (a syntactically
valid `Basic <base64(wrong:creds)>` string — NOT a malformed string, NOT the real credential);
runs `issue list --jql "project=<E2E>" --output json` using `e2e_cmd()` with the bad auth header
overriding `JR_AUTH_HEADER`; asserts:

1. Exit code equals exactly 2 (`JrError::NotAuthenticated`; BC-X.3.002).
2. Stdout is empty.
3. Process did not panic.

**Debug-build-only by construction (F-11):** `JR_AUTH_HEADER` is gated behind
`#[cfg(debug_assertions)]` (SD-002). The E2E harness runs the debug binary, so this is
consistent with the rest of the suite.

**Credential construction:** use `Basic <base64("wrong-email@example.com:wrong-token")>` — a
syntactically valid Basic auth header with credentials that will 401. Do NOT use a malformed
string (Atlassian may return a different error code for malformed headers).

Spec reference: §6.3 — "a well-formed `Basic <base64>` with wrong credentials, not a malformed
string → exit `2` (`JrError::NotAuthenticated`)."

---

### AC-015 — `test_every_ignored_test_has_gate_guard` still passes (traces to NFR-T-E2E-1; spec §9)

After all 11+ new `#[ignore]`-annotated test functions are added, the always-run source
meta-guard `test_every_ignored_test_has_gate_guard` in `tests/e2e_live.rs` continues to exit 0
in `cargo test --test e2e_live` (without `JR_RUN_E2E=1`). All new gated tests have
`e2e_enabled()` as the first statement. No new always-run tests are added in this story
(all new tests are gated) — the meta-guard is the only always-run gate check needed.

Verification: `cargo test --test e2e_live` (without env) exits 0.

## Out of Scope

- Foundation helpers (`poll_jql`, shape matchers, transient classifier) — those are S-E2E-3.
- CI workflow changes (`e2e-sweeper.yml`, `e2e.yml` failure classification) — those are S-E2E-5.
- Secret-leak guard and leak-detection log — S-E2E-5.
- JSM expansion (`requesttype fields`, `queue view`, `issue create --request-type`) — declared
  non-goal in spec §2.
- `issue edit --field` live test — non-goal in spec §2 (instance-specific screen dependency).
- `bulk move` test — listed in spec §6.2 but implementation complexity (async poll, transient
  `inaccessible` status handling) is significant; deferred to a follow-up if the M2 tests fit
  in the story budget. The story covers the high-value behavioral tests first.

  > **Note on bulk move deferral:** spec §6.2 includes a bulk move test. Implementation requires
  > polling the async task result and treating `inaccessible` as retryable. This is achievable
  > but adds ~30 LOC and a polling loop beyond the S-E2E-3 `poll_jql` primitives. If the
  > implementer has budget, implement it; if not, record as a follow-up item. The dedup test
  > (AC-011) is the higher-priority M2 item (directly pins JRACLOUD-95368 dedup contract).

## Implementation Strategy

**TDD order:**

1. **Gate test first.** Verify `test_every_ignored_test_has_gate_guard` is still green before
   adding any new tests. (It should be from S-E2E-3; confirm with `cargo test --test e2e_live`.)

2. **Read tests (AC-001–AC-007), one at a time.** Start with the simplest (AC-006, link-types;
   AC-005, team list) to establish the pattern, then progress to seeded tests (AC-001 transitions;
   AC-003 changelog; AC-002 comments; AC-004 board view; AC-007 user view). Compile-check after
   each.

3. **Write/behavioral tests (AC-008–AC-011).** These require more setup (creating seed issues).
   Order: AC-010 (dry-run, simplest — one seed issue); AC-009 (assign, one seed issue); AC-008
   (link/unlink, two seed issues); AC-011 (pagination dedup, three seed issues + `poll_jql`
   FailOnShort mode).

4. **Error tests (AC-012–AC-014).** No seeding needed. Start with AC-012 (404, no auth config
   needed), AC-013 (bad JQL), AC-014 (bad auth — requires constructing a wrong-creds header).

5. **Final verification (AC-015).** `cargo test --test e2e_live` exits 0.

**Branch:** `test/e2e-enhancements` (same feature branch as S-E2E-3).

**Commit message:**
```
test(e2e): M2 new coverage — transitions, changelog, assign, link, dry-run, dedup, error paths
```

**PR target:** `develop` (alongside S-E2E-3 and S-E2E-5 in the same feature branch PR, or as
separate PRs per implementer preference).

## Quality Gate Self-Check

| Criterion | AC | Notes |
|-----------|----|-------|
| `cargo test --test e2e_live` (no env) exits 0 | AC-015 | Meta-guard passes; no always-run regressions |
| `grep -c "#\[ignore\]" tests/e2e_live.rs` → ≥21 (existing 10+ plus 11+ new) | all | New gated tests added |
| `grep -n "e2e_enabled\(\)" tests/e2e_live.rs` count ≥ `grep -c "#\[ignore\]"` | AC-015 | Every `#[ignore]` test has gate guard |
| `grep -n "to_category" tests/e2e_live.rs` → 0 matches | AC-001 | No `to_category` field asserted |
| `grep -n "v\[.histories.\]" tests/e2e_live.rs` → 0 matches | AC-003 | No `histories` key asserted |
| `grep -n '\.is_array().*board view\|board view.*is_object()' tests/e2e_live.rs` → 0 wrong matches | AC-004 | `board view` asserts bare array |
| `grep -rn "from_slice.*stdout" tests/e2e_live.rs` — any call on stdout for error tests has empty-guard | AC-012–014 | No naked parse on empty stdout |
| `grep -n '"--me"' tests/e2e_live.rs` → 0 matches | AC-009 | No `--me` flag attempt |
| `cargo test` exits 0 | smoke | Full suite green |
| `cargo fmt --all -- --check` exits 0 | lint | No format drift |
| `cargo clippy --all-targets -- -D warnings` exits 0 | lint | Zero warnings |
| `bash scripts/check-spec-counts.sh` exits 0 | invariant | No BC frontmatter changed |
| `bash scripts/check-bc-cumulative-counts.sh` exits 0 | invariant | No count surfaces touched |
| `bash scripts/check-bc-no-numeric-test-counts.sh` exits 0 | invariant | No BC bodies with numeric counts |

## Token Budget Estimate

| Item | Tokens (approx) |
|------|----------------|
| This story file | ~7 k |
| Design spec §6.1 + §6.2 + §6.3 (M2) | ~5 k |
| S-E2E-3 story (foundation helpers to use) | ~7 k |
| `tests/e2e_live.rs` current state (post S-E2E-3; ~700 LOC to read + extend) | ~10 k |
| `src/types/jira/issue.rs` (Transition/Status/StatusCategory to verify C-2) | ~2 k |
| `src/types/jira/users.rs` (serde rename verification for AC-007) | ~1 k |
| `src/error.rs` (exit-code mapping verification for AC-012–014) | ~1 k |
| Tool outputs (`cargo test`, `cargo clippy`, grep verifications, script exits) | ~4 k |
| BC files: 0 (none loaded — BC delta empty) | 0 |
| **Total** | **~37 k** |

Well within a single-agent context window (~200 k). No split required.
LOC delta: `tests/e2e_live.rs` +~250 LOC (11+ new gated test functions). Zero `src/` LOC changes.

## Tasks

- [ ] Confirm branch `test/e2e-enhancements` has S-E2E-3 foundation helpers merged/available
- [ ] Read `tests/e2e_live.rs` in full — understand current state post-S-E2E-3
- [ ] Read `src/types/jira/issue.rs` — verify `Transition`/`Status`/`StatusCategory` struct fields; confirm no `to_category` field (C-2)
- [ ] Read `src/types/jira/users.rs` — confirm serde rename for `accountId` (DI-E2E-F2-2)
- [ ] Read `src/error.rs` — verify `JrError::exit_code()` mapping for `ApiError`, `NotAuthenticated`, `UserError` (for AC-012–014 exit code assertions)
- [ ] `cargo test --test e2e_live` — exits 0 (confirm foundation from S-E2E-3 is green)
- [ ] Add `test_e2e_issue_link_types_returns_array` (AC-006; `name` only, no `id`/`inward`/`outward` assertion)
- [ ] Add `test_e2e_team_list_returns_array_or_skips` (AC-005; empty-stdout clean-skip; no `from_slice` on empty)
- [ ] Add `test_e2e_issue_transitions_returns_array` (AC-001; seed issue; no `to_category`; `to.statusCategory.key`)
- [ ] Add `test_e2e_issue_changelog_returns_object` (AC-003; seed + edit; `{key, entries}` shape; no `histories`)
- [ ] Add `test_e2e_issue_comments_returns_array` (AC-002; seed + comment; standalone read)
- [ ] Add `test_e2e_board_view_returns_array` (AC-004; gated on `JR_E2E_BOARD_ID`; `--board` flag; bare array; no-sprint clean-skip)
- [ ] Add `test_e2e_user_view_returns_object` (AC-007; self-resolve accountId; clean-skip if empty)
- [ ] `cargo test --test e2e_live` — exits 0 (meta-guard passes; all read tests present and gated)
- [ ] Add `test_e2e_issue_edit_dry_run_no_mutation` (AC-010; seed one issue; dry-run; poll_view summary unchanged)
- [ ] Add `test_e2e_issue_assign_self` (AC-009; seed one issue; omit assignee; poll_view `assignee.accountId`)
- [ ] Add `test_e2e_issue_link_and_unlink` (AC-008; seed two issues; link; poll_view inward/outward; unlink; poll_view no link)
- [ ] Add `test_e2e_pagination_dedup` (AC-011; seed 3 issues with nonce label; `poll_jql` FailOnShort(3); duplicate-free + superset check)
- [ ] `cargo test --test e2e_live` — exits 0
- [ ] Add `test_e2e_issue_view_404_exits_nonzero` (AC-012; exit ∈ {1,64}; stdout empty; no panic)
- [ ] Add `test_e2e_issue_list_bad_jql_exits_nonzero` (AC-013; exit ∈ {1,64}; stdout empty; no panic)
- [ ] Add `test_e2e_bad_auth_exits_2` (AC-014; wrong-creds `Basic` header; exit 2; stdout empty)
- [ ] Verify `grep -n '"--me"' tests/e2e_live.rs` → 0 matches (AC-009)
- [ ] Verify `grep -n "to_category" tests/e2e_live.rs` → 0 matches (AC-001)
- [ ] `cargo test --test e2e_live` — exits 0 (meta-guard passes; all 11+ new gated tests present)
- [ ] `cargo test` — exits 0
- [ ] `cargo fmt --all -- --check` — exits 0
- [ ] `cargo clippy --all-targets -- -D warnings` — exits 0
- [ ] `bash scripts/check-spec-counts.sh && bash scripts/check-bc-cumulative-counts.sh && bash scripts/check-bc-no-numeric-test-counts.sh` — all exit 0
- [ ] Commit: `test(e2e): M2 new coverage — transitions, changelog, assign, link, dry-run, dedup, error paths`

## Previous Story Intelligence

**Direct predecessor: S-E2E-3** (builds the foundation helpers this story consumes). All new
tests in this story use `poll_jql`, `assert_key_format`, `assert_status_category`,
`assert_issue_shape`, and `assert_array_of_objects_with_keys` from S-E2E-3. Do not reimplement
them.

**Key lesson from S-E2E-1/S-E2E-2 gate pattern:** Every `#[ignore]`-annotated test MUST have
`e2e_enabled()` as the first statement. The meta-guard catches violations automatically in
`ci.yml`. This is not optional.

**Key lesson from spec §3 portability:** assert `statusCategory.key` strings (`"new"`,
`"indeterminate"`, `"done"`), never status `name` strings. Use `assert_status_category` from
S-E2E-3 — it encodes this constraint in a typed enum.

**Key lesson from spec §6.1 critical constraints:**
- `Transition` has NO `to_category` field (C-2). The category is at `to.statusCategory.key`.
- `issue changelog` shape is `{key, entries}`, NOT a bare array, NOT `{key, histories}` (F-03).
- `board view --output json` is a BARE ARRAY (H-1), NOT an object. `--board` is a FLAG.
- `team list` can return empty stdout + exit 0 (empty-org path) — guard before `from_slice`.
- `issue link-types`: only `name` is guaranteed; `id`/`inward`/`outward` are `Option` (F-06).

**Key lesson from spec §6.2 constraints:**
- `issue assign` has NO `--me` flag (F-01). Omit the assignee entirely.
- `issue link` inward/outward key is not contractually fixed — check both (F-09).
- Pagination dedup label MUST include both run_id AND a per-attempt discriminator (M-2).
- `labels=<label>` (exact match) is valid JQL; `labels ~ "..."` is not.

**Key lesson from spec §6.3 (H-2):** stdout is EMPTY on error paths. Do NOT parse stdout
as JSON for error-path tests. Assert: exit code + stdout empty + no panic.

## Architecture Compliance Rules

1. **Zero `src/` changes (hard boundary).** If any `src/` edit is needed, STOP and escalate.

2. **Every `#[ignore]`-annotated test MUST have `e2e_enabled()` before any live call.**
   `test_every_ignored_test_has_gate_guard` enforces this in `ci.yml`. Not negotiable.

3. **No assertion on `to_category` (does not exist).** The `Transition` struct has no such
   field. Asserting it produces always-true or always-false tests depending on JSON behavior.

4. **No assertion on `histories` (wrong key).** `ChangelogOutput` uses `entries`, not `histories`.

5. **`board view --output json` is a bare array.** Do NOT look for a wrapper object.

6. **Error-path tests assert exit code only.** No message substrings. No stdout JSON parse.
   stdout is empty on error paths — `from_slice("")` panics.

7. **Pagination dedup label uniqueness.** Include both `run_label()` and a per-attempt nonce.
   A bare `run_label()` (which is `e2e-<run_id>`) is reused on re-runs — collisions inflate
   the result count across runs, making the ≥3 assertion flaky.

8. **Self-seeded tests only.** No inter-test state sharing. Each test creates its own data,
   uses it, and leaves it for the sweeper (S-E2E-5). The single exception is the
   `test_e2e_user_view_returns_object` test, which reads self-accountId from a live `user search`
   call within the same test function.

## Library & Framework Requirements

No new `Cargo.toml` dependencies. All helpers and test infrastructure come from S-E2E-3 and
the existing crates.

| Crate | Already in Cargo.toml | Usage in this story |
|-------|----------------------|---------------------|
| `serde_json` | Yes (dev-dep) | JSON parsing and assertion in all new tests |
| `assert_cmd` | Yes (dev-dep) | Subprocess invocation (unchanged) |
| `tempfile` | Yes (dev-dep) | `TempDir` for isolated config/cache per test |
| `std::collections::HashSet` | stdlib | Duplicate-free check in AC-011 |
| `std::env` | stdlib | `GITHUB_RUN_ATTEMPT` / nonce for AC-011 label uniqueness |

## File Structure Requirements

| File | Action | Notes |
|------|--------|-------|
| `tests/e2e_live.rs` | MODIFY | Add ~11 new gated test functions (+~250 LOC) |

**Files NOT to create or touch:** All of `src/`, `Cargo.toml`, `deny.toml`,
`.github/workflows/ci.yml`, `.github/workflows/e2e.yml`, `CLAUDE.md`, `tests/common/`,
all snapshot files, all other `tests/*.rs` files, `STORY-INDEX.md`, all BC count surfaces.

## Branch / PR Plan

- Branch: `test/e2e-enhancements`
- Target: `develop`
- Commit: `test(e2e): M2 new coverage — transitions, changelog, assign, link, dry-run, dedup, error paths`
- PR body: reference this story (S-E2E-4), S-E2E-3, and design spec §6; note tests are
  no-ops until `JR_RUN_E2E=1` is set
- CHANGELOG entry: Add under `[Unreleased]` — "Added E2E M2 live coverage: `issue transitions`,
  `issue changelog`, `board view`, `team list`, `user view`, `issue link-types`, `issue assign`
  (self), `issue link`/`unlink`, `--dry-run` no-mutation, pagination dedup (BC-2.6.051), and
  error/exit-code paths (404, 400, 401)."
