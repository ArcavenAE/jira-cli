---
document_type: story
level: ops
story_id: "S-cycle14-api-query-param"
epic_id: "ISSUE-TRIAGE-QUICKFIXES-1"
title: "jr api --query-param/-q NAME=VALUE: percent-encoded query-string assembly and its error taxonomy"
wave: 2
status: draft
intent: bug-fix
feature_type: enhancement
mode: feature
scope: standard
severity: LOW
trivial_scope: false
producer: story-writer
timestamp: "2026-09-26T00:00:00"
phase: 3
inputs:
  - ".factory/cycles/cycle-014/phase-f2-spec-evolution/prd-delta.md"
  - ".factory/cycles/cycle-014/phase-f2-spec-evolution/verification-delta.md"
  - ".factory/specs/prd/cross-cutting.md"
  - "src/cli/mod.rs"
  - "src/main.rs"
  - "src/cli/api.rs"
  - "README.md"
input-hash: "76973f9"
traces_to: "BC-X.16.001, BC-X.16.002"
cycle: cycle-014-issue-triage-quickfixes
estimated_effort: medium
estimated_days: 2
target_module: "src/cli/api.rs, src/cli/mod.rs"
subsystems: ["SS-02"]
# SS-02 (CLI Layer, src/cli/) owns this story's scope because every modified
# file (src/cli/api.rs, src/cli/mod.rs) lives under src/cli/ per ARCH-INDEX's
# Subsystem Registry (SS-02 row: "CLI Layer | src/cli/"). No HTTP-client-core
# (SS-03) file is touched -- append_query_params/parse_query_param run
# strictly before client.request is built (BC-X.16.001 Invariants).
depends_on: ["S-cycle14-user-list-project-resolution"]
blocks: ["S-cycle14-field-options-name-label"]
# Depends on S-cycle14-user-list-project-resolution because both stories edit
# the SAME two files in the SAME numeric sequence: .cargo/mutants.toml's
# examine_globs array (STORY-A lands 32->33; this story's edit must start
# from that value to reach 33->34) and docs/specs/cargo-mutants-policy.md's
# single hard-coded "Current examine_globs count" line -- a real content
# dependency (sequential numeric edit), not mere file overlap. Both stories
# also touch src/cli/mod.rs and src/main.rs (different code regions: this
# story adds Command::Api's -q field and dispatch-arm wiring, STORY-A touches
# UserCommand::List and the User dispatch arm) and README.md (different
# rows). Blocks S-cycle14-field-options-name-label for the same reason in
# reverse: that story's own doc/mutants edits must land after this one.
# Serial order A -> C -> B is human decision D-381 (2026-09-25 F2 review).
behavioral_contracts:
  - BC-X.16.001
  - BC-X.16.002
bcs:
  - BC-X.16.001
  - BC-X.16.002
verification_properties:
  - VP-API-QP-001
  - VP-API-QP-002
  - VP-API-QP-003
  - VP-API-QP-004
  - VP-API-QP-005
  - VP-API-QP-006
holdout_anchors: ["H-CYCLE14-W2-INT-001", "H-CYCLE14-W2-REG-001"]
nfr_anchors: []
adr_refs: []
sd_refs: []
priority: P2
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-014/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: tdd
tdd_mode: strict
module_criticality: "N/A -- no .factory/specs/module-criticality.md exists in this repo"
points: 8
acceptance_criteria_count: 11
assumption_validations: []
risk_mitigations: []
created: "2026-09-26"
version: "1.0"
last_updated: "2026-09-26"
breaking_change: false
retroactive: false
origin: >
  cycle-014 issue-triage-quickfixes (GitHub issue #583), Wave 2 of 3, second
  story in the human-decided SERIAL delivery order A -> C -> B (D-381,
  2026-09-25 F2 review), rebased on STORY-A. F2 (prd-delta.md Item 3) added
  a wholly new BC family, BC-X.16.001/002, to cross-cutting.md -- no `jr api`
  BC existed before this cycle. This story implements that already-approved
  new BC family; the four design defaults (query merge, repeated names,
  encode-once, method-orthogonality) plus NAME/VALUE non-trimming,
  `--project ""` (STORY-A's own concern, not this one), and the `-q`
  no-override/no-dedup rule were all human-confirmed 2026-09-25 (D-380).
---

> **tdd_mode:** `strict` -- this story implements two new pure functions
> (`append_query_params`, `parse_query_param`) plus a new clap flag and
> handler wiring; the full TDD Iron Law applies.

> **Execute:** `/vsdd-factory:deliver-story S-cycle14-api-query-param`

# S-cycle14-api-query-param -- `jr api --query-param`/`-q` (#583)

## Narrative

- **As a** `jr api` user who needs to pass query-string parameters to an arbitrary Jira REST endpoint
- **I want to** supply repeatable `--query-param`/`-q NAME=VALUE` flags that are percent-encoded and merged onto the path
- **So that** I no longer have to hand-encode and hand-append a query string onto `<path>` myself, matching the ergonomics of `gh api -f`/HTTPie `name==value`/`curl -G --data-urlencode`

## Behavioral Contracts

| BC | Role | Clauses this story implements |
|----|------|-------------------------------|
| BC-X.16.001 | PRIMARY (new, cycle-014 F2) | The `-q`/`--query-param` clap flag, `append_query_params`'s full assembly algorithm (Behavior 1-5, Postconditions 1-5), all Edge Cases EC-X.16.001-1..14 |
| BC-X.16.002 | PRIMARY (new, cycle-014 F2) | `parse_query_param`'s malformed-value error taxonomy (M1/M2), pre-flight ordering (Postcondition 1), all-or-nothing (Postcondition 3), Edge Cases EC-X.16.002-1..11 |

**Anchor justification:** BC-X.16.001/002 are the sole BCs governing `jr api --query-param` in this spec corpus (`cross-cutting.md`, new `## BC-X.16` subsection). Both were newly authored at cycle-014 F2 specifically to close issue #583; this story is the F4-bound implementation of that already-approved new BC family.

## Acceptance Criteria

### AC-001 (traces to BC-X.16.001 Behavior 1, Postcondition 2, EC-X.16.001-4/5/8/9/14)
`src/cli/api.rs::append_query_params(path: &str, pairs: &[(String, String)]) -> String` (new pure function) assembles the query string per the separator algorithm, evaluated in this order: (a) no `?` in the pre-`#` part -> a fresh leading `?`, regardless of a trailing `&` (EC-X.16.001-14); (b) a `?` is present and the query component (text after the first `?`) is empty or ends in `&` -> new pairs appended with NO separator (EC-X.16.001-8); (c) otherwise -> `&`-joined, even when the query component itself ends in a literal `?` (EC-X.16.001-9). Detection scans ONLY the part of `<path>` before its first `#`; a trailing `#fragment` is re-appended unchanged after the assembled query (EC-X.16.001-5).
**Test:** VP-API-QP-001's `proptest!` separator oracle + pinned examples for every listed EC.

### AC-002 (traces to BC-X.16.001 Behavior 2, Postcondition 4, EC-X.16.001-12/13)
Repeated `--query-param NAME=...` occurrences are ALL sent, in flag order, with no deduplication or last/first-wins collapsing -- neither among themselves nor against a pre-existing same-NAME query pair (pre-existing pairs are kept verbatim and sent first). The `-q` clap field is a plain `Vec<String>` with NO `value_delimiter`, so a comma inside VALUE is never split into multiple pairs.
**Test:** VP-API-QP-002's `proptest!` oracle (`parse(out_query) == parse(in_query) ++ new_pairs`) + the `fields=summary,status` argv cell (EC-X.16.001-13) + the repeated-flags argv cell.

### AC-003 (traces to BC-X.16.001 Behavior 3, Postcondition 3, EC-X.16.001-3/10/11)
NAME and VALUE are percent-encoded EXACTLY ONCE via `urlencoding::encode` (never `url::form_urlencoded::byte_serialize`), applied separately; every encoded byte is RFC 3986 unreserved (`A-Za-z0-9-._~`) or an uppercase `%HH` triplet; space encodes to `%20`, never `+`. NAME/VALUE are used exactly as typed -- NEITHER is trimmed (D-380, settled 2026-09-25). The `--query-param`/`-q` help text contains the literal substring `"do not pre-encode"`.
**Test:** VP-API-QP-003's biased `proptest!` (round-trip, alphabet, encoder-identity, no-trim) + the `--help` integration cell.

### AC-004 (traces to BC-X.16.001 Behavior 4/5, Postconditions 1/5, EC-X.16.001-6/7)
The query assembly is identical regardless of `-X`/`--method` (GET/POST/PUT/PATCH/DELETE), and query-param content is never merged into, or sourced from, `-d`/`--data`'s request body. An invocation with zero `--query-param` flags produces a path byte-identical to `normalize_path`'s own output; `append_query_params(p, &[]) == p` for any `p` (identity function).
**Test:** VP-API-QP-004's structural check + table-driven hermetic wiremock over all five methods (with/without `-d`) + `proptest!` identity.

### AC-005 (traces to BC-X.16.002 Behavior, Postcondition 1, EC-X.16.002-1)
`src/cli/api.rs::parse_query_param(raw: &str) -> Result<(String, String)>` (new pure function, distinct from `append_query_params`) splits on the FIRST `=`; a raw value with no `=` at all (including the empty string, EC-X.16.002-9) exits 64 with the pinned message `"--query-param must be in NAME=VALUE format (got: {raw})"` (M1), zero HTTP calls.
**Test:** VP-API-QP-005's partition `proptest!` + pinned `parse_query_param("")` example + hermetic wiremock cell.

### AC-006 (traces to BC-X.16.002 Behavior, Postcondition 1, EC-X.16.002-2)
An empty NAME (nothing before the first `=`, e.g. `=v`) exits 64 with the pinned, DISTINCT message `"--query-param NAME cannot be empty (got: {raw}) — use NAME=VALUE, e.g. -q maxResults=50"` (M2). An empty VALUE (`k=`) is explicitly ALLOWED, not an error (BC-X.16.001 EC-X.16.001-1).
**Test:** VP-API-QP-005 (M2 partition) + hermetic wiremock cell; both messages verified distinguishable by substring (D1 present/absent, D2 present/absent).

### AC-007 (traces to BC-X.16.002 Postcondition 3, Invariants, EC-X.16.002-3)
A single invocation with multiple `--query-param` flags where any one is malformed fails the WHOLE invocation before any HTTP call, reporting the FIRST malformed value in flag order (mirrors `parse_header`'s existing `.collect::<Result<Vec<_>>>()` all-or-nothing pattern).
**Test:** VP-API-QP-006(i)/(ii).

### AC-008 (traces to BC-X.16.002 Postcondition 1, D-188 pre-flight convention, EC-X.16.002-4)
In `handle_api` (`src/cli/api.rs`), `--query-param` parsing is inserted immediately after the existing `normalize_path(&path)?` call and BEFORE `resolve_body(...)` (which can block reading stdin for `-d @-`) and BEFORE `-H`/`--header` parsing. A held-open stdin pipe with a malformed `-q` value must not hang -- the child process exits 64 within ~5s.
**Test:** VP-API-QP-006(iii), spawned via `std::process::Command` (not `assert_cmd`, which closes stdin before waiting) with a held-open `ChildStdin` handle, polling `try_wait()` against a ~5s deadline.

### AC-009 (traces to BC-X.16.002 Edge Cases EC-X.16.002-5..10)
Clap's own attached-form and missing-value parsing produces the documented `raw` values and outcomes: `-q=v` -> M1 `(got: v)`; `-q==v` and `--query-param==v` -> M2 `(got: =v)`; `-q -x=1` -> clap exit 2 (`unexpected argument`), not 64, neither D1 nor D2; `-q ""`/`-q=`/`--query-param=` -> M1 `(got: )` (EC-X.16.002-9); `-q` as the last argv token (no value at all) -> clap exit 2 (`a value is required for`), not 64. The `-q`/`--query-param` flag is NOT declared with `allow_hyphen_values`.
**Test:** VP-API-QP-005's attached-form argv cells.

### AC-010 (traces to BC-X.16.001 Trace, prd-delta.md F4 doc-delta obligation PASS-13/P13-003)
`README.md`'s `jr api <PATH>` row (~L332) is updated to document `-q`/`--query-param NAME=VALUE`. (The same row's pre-existing, unrelated `--body` naming mismatch -- the actual flag is `-d`/`--data` -- is drift item `README-JR-API-BODY-FLAG` and is explicitly NOT corrected by this story.)
**Test:** N/A (doc artifact); presence checked at PR review.

### AC-011 (traces to verification-delta.md §2 "examine_globs" table, D-382)
`.cargo/mutants.toml`'s `examine_globs` array gains `"src/cli/api.rs"` (33 -> 34 entries, verified by actual count against STORY-A's already-landed 33). `docs/specs/cargo-mutants-policy.md` gains a `` `src/cli/api.rs` — `append_query_params`, `parse_query_param` `` §Scope bullet, its "Current `examine_globs` count" line changes 33 -> 34, and a new newest-first row is added to the `## Changelog` table.
**Test:** N/A (config/doc); `tests/mutants_glob_existence.rs` passes automatically; `scripts/check-cargo-mutants-policy-citations.sh` passes since both functions are defined in the same PR.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `append_query_params` | `src/cli/api.rs` | Pure (no I/O, no `JiraClient`) |
| `parse_query_param` | `src/cli/api.rs` | Pure (no I/O) |
| `Command::Api`'s `-q`/`--query-param` field | `src/cli/mod.rs` | Pure (clap derive declaration) |
| `handle_api`'s pre-flight wiring | `src/cli/api.rs` | Effectful-shell (calls the pure functions before building the request) |

Reference: `architecture/module-decomposition.md`, `architecture/dependency-graph.md` (no module-boundary change; F1 confirmed no architecture delta).

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-X.16.001-1 | `k=` (empty VALUE) | Allowed, sent as-is |
| EC-X.16.001-2 | `jql=status=Done` (VALUE contains `=`) | Splits on FIRST `=` only |
| EC-X.16.001-3 | Non-ASCII VALUE (e.g. `café`) | UTF-8 bytes percent-encoded (`é` -> `%C3%A9`) |
| EC-X.16.001-4 | Path already ends `?existing=1` | `&`-joined, existing text unchanged |
| EC-X.16.001-5 | Path contains `#fragment` | Query inserted before `#`; fragment passed through verbatim, never transmitted (RFC 9112 §3.2) |
| EC-X.16.001-6 | Combined with `-X POST/PUT/DELETE/PATCH` | Identical assembly regardless of method |
| EC-X.16.001-7 | `--query-param` entirely absent | Byte-identical to `normalize_path`'s output |
| EC-X.16.001-8 | Path ends in bare `?` or `&` | No separator inserted |
| EC-X.16.001-9 | Query component ends in literal `?` (e.g. `?jql=why?`) | Still `&`-joined, never confused with EC-8 |
| EC-X.16.001-10 | NAME is whitespace-only (e.g. `" =v"`) | Allowed (not empty), percent-encoded |
| EC-X.16.001-11 | VALUE has leading/trailing whitespace | Not trimmed, percent-encoded as-is |
| EC-X.16.001-12 | `-q` NAME collides with existing query NAME | Neither deduped nor overridden; both sent, existing first (D-380) |
| EC-X.16.001-13 | `-q fields=summary,status` | ONE pair, comma is ordinary VALUE content |
| EC-X.16.001-14 | Path has no query, ends in `&` (e.g. `/x&`) | Fresh `?` introduced: `/x&?k=v` |
| EC-X.16.002-1 | `--query-param foo` (no `=`) | Exit 64, M1 |
| EC-X.16.002-2 | `--query-param =v` (empty NAME) | Exit 64, M2 |
| EC-X.16.002-3 | Second of two flags malformed | Whole invocation fails, first malformed value reported |
| EC-X.16.002-4 | `-d @- -q bad` with stdin held open | Exits 64 on M1 without ever blocking on stdin |
| EC-X.16.002-5..7 | `-q=v` / `-q==v` / `--query-param==v` | M1 `(got: v)` / M2 `(got: =v)` / M2 `(got: =v)` |
| EC-X.16.002-8 | `-q -x=1` (hyphen-leading token as value) | Clap exit 2 (`unexpected argument`), not this BC's taxonomy |
| EC-X.16.002-9 | `-q ""` / `-q=` / `--query-param=` | M1 `(got: )` |
| EC-X.16.002-10 | `-q` as the last argv token | Clap exit 2 (`a value is required for`) |
| EC-X.16.002-11 | Non-UTF-8 `-q` value | Clap exit 2 before `parse_query_param` runs (informational, no VP cell) |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `append_query_params` (`src/cli/api.rs`) | pure-core | No I/O, no `JiraClient`, string-in/string-out |
| `parse_query_param` (`src/cli/api.rs`) | pure-core | No I/O, `&str -> Result<(String, String)>` |
| `Command::Api` clap declaration (`src/cli/mod.rs`) | pure-core | Derive-macro declaration |
| `handle_api` (`src/cli/api.rs`) | effectful-shell | Builds and sends the HTTP request after the pure pre-flight steps |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~3,600 |
| Referenced code (`src/cli/api.rs` full file including `normalize_path`/`parse_header`/`resolve_body` precedent, `src/cli/mod.rs::Command::Api`, `src/main.rs`'s `Command::Api` arm) | ~2,800 |
| Test files (existing `jr api` integration tests, grep-scoped) | ~1,500 |
| Tool output overhead | ~1,200 |
| **Total** | **~9,100** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~5%** |

## Tasks

1. [ ] Write the `proptest!` separator oracle for `append_query_params` (AC-001) -- `test-writer`
2. [ ] Write the repeated-names `proptest!` oracle + argv cells (AC-002) -- `test-writer`
3. [ ] Write the encoding-exactly-once biased `proptest!` + `--help` cell (AC-003) -- `test-writer`
4. [ ] Write the method-orthogonality table-driven wiremock test + zero-flag identity `proptest!` (AC-004) -- `test-writer`
5. [ ] Write the `parse_query_param` partition `proptest!` + pinned examples (AC-005, AC-006) -- `test-writer`
6. [ ] Write the multi-flag first-malformed wiremock cell (AC-007) -- `test-writer`
7. [ ] Write the held-open-stdin `std::process::Command` test (AC-008) -- `test-writer`
8. [ ] Write the attached-form argv cells (AC-009) -- `test-writer`
9. [ ] Confirm Red Gate: all new tests fail against the current code
10. [ ] Implement `append_query_params` and `parse_query_param` in `src/cli/api.rs` (AC-001..003, AC-005..007) -- `implementer`
11. [ ] Add the `-q`/`--query-param` clap field to `Command::Api` (`src/cli/mod.rs`) with the pinned help text, no `value_delimiter`, no `allow_hyphen_values` (AC-003, AC-009) -- `implementer`
12. [ ] Wire `handle_api` to call `-q` parsing immediately after `normalize_path` and before `resolve_body`/`-H` parsing (AC-008) -- `implementer`
13. [ ] Confirm Green Gate: all tests pass
14. [ ] Update `README.md`'s `jr api <PATH>` row (~L332) (AC-010)
15. [ ] Add `src/cli/api.rs` to `.cargo/mutants.toml` `examine_globs`; add the §Scope bullet, bump the count line 33->34, and add a `## Changelog` row to `docs/specs/cargo-mutants-policy.md` (AC-011)
16. [ ] Add a CHANGELOG entry under `[Unreleased] > Added` describing the shipped behavior, before creating the PR
17. [ ] Run `cargo fmt --all -- --check`, `cargo clippy -- -D warnings`, `cargo test`, and the scoped `cargo mutants --in-diff`

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|-----------------|--------------------------|------------------------|
| S-cycle14-user-list-project-resolution (Wave 1, predecessor in the serial chain) | `.cargo/mutants.toml` `examine_globs` bumped 32->33; `docs/specs/cargo-mutants-policy.md`'s count line and §Scope table follow the same per-story pattern this story reuses (33->34) | Established the exact §Scope bullet form (`` `file` — `symbol` ``, not `file::symbol`) required by `scripts/check-cargo-mutants-policy-citations.sh` | The policy's hard-coded count line has no CI check comparing it against the real `.cargo/mutants.toml` count -- re-count the actual array entries before writing 34, don't trust the prior story's stated number blindly |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| `append_query_params` and `parse_query_param` MUST be pure -- no `JiraClient`, no network, no config parameter | BC-X.16.001 Invariants, BC-X.16.002 Source | AC-001..003, AC-005..007 tests need no wiremock for their proptest layers |
| `url::form_urlencoded::byte_serialize` MUST NOT be used for this assembly (space -> `+`, wrong semantics) | BC-X.16.001 Invariants | AC-003's encoder-identity assertion |
| `-q` validation MUST run strictly between `normalize_path` and `resolve_body`, before `-H` parsing | BC-X.16.002 Postcondition 1, D-188 | AC-008 |
| `-q`/`--query-param` MUST NOT be declared with `allow_hyphen_values` | BC-X.16.002 EC-X.16.002-8 | AC-009 |
| Query-param content MUST NEVER be merged into, or sourced from, `-d`/`--data` | BC-X.16.001 Behavior 4 | AC-004 |
| The two error messages MUST be pinned verbatim and mutually distinguishable by substring | BC-X.16.002 Pinned error messages, Invariants | AC-005, AC-006 |

## Library & Framework Requirements

No new dependency is added. `urlencoding = "2"` (existing pin, `Cargo.toml`; verified 2.1.3 behavior against source) is the PRODUCTION encoder. `url = "2"` (existing pin) provides `url::form_urlencoded::parse`, used ONLY as a test-oracle decoder in VP-API-QP-002/003's proptests -- never in production code. `url::form_urlencoded::byte_serialize` is explicitly forbidden for this story's production code.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/cli/mod.rs` | modify | New `-q`/`--query-param: Vec<String>` field on `Command::Api`, pinned help text (AC-001, AC-003) |
| `src/main.rs` | modify | `Command::Api` dispatch arm passes the new field through to `handle_api` |
| `src/cli/api.rs` | modify | New `append_query_params`, `parse_query_param`; `handle_api` pre-flight wiring (AC-001..009) |
| `README.md` | modify | `jr api <PATH>` row (~L332) documents `-q`/`--query-param` (AC-010) |
| `.cargo/mutants.toml` | modify | Add `src/cli/api.rs` to `examine_globs` (33->34) (AC-011) |
| `docs/specs/cargo-mutants-policy.md` | modify | §Scope bullet + count line 33->34 + `## Changelog` row (AC-011) |
| `CHANGELOG.md` | modify | `[Unreleased] > Added` entry |

## Definition of Done

- [ ] All 11 ACs pass their listed tests
- [ ] `cargo fmt --all -- --check` clean
- [ ] `cargo clippy -- -D warnings` clean
- [ ] `cargo test` green (full suite)
- [ ] Scoped `cargo mutants --in-diff` run against the PR diff, with `src/cli/api.rs` now in `examine_globs` scope
- [ ] `.cargo/mutants.toml` / `docs/specs/cargo-mutants-policy.md` edits verified against `scripts/check-cargo-mutants-policy-citations.sh` and `tests/mutants_glob_existence.rs`
- [ ] CHANGELOG entry present under `[Unreleased] > Added`
- [ ] Rebased onto STORY-A's merged `develop` tip before opening the PR (serial delivery, D-381)
- [ ] PR opened against `develop`, following commitizen branch/commit conventions

## Suggested Branch Name

`feat/api-query-param` (Conventional Commits, per CLAUDE.md's `type/short-description` convention; this adds a new capability, so `feat/`).
