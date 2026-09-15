# PR Review — #812 (S-cycle12-jsm-adf-autoconvert)

- **PR:** https://github.com/Zious11/jira-cli/pull/812
- **Branch:** `feat/cycle12-jsm-adf-autoconvert` → `develop`
- **Reviewer:** pr-reviewer (fresh-eyes, cycle 1b)
- **Scope reviewed:** full diff (5 files, +1851/-46) — src/api/jsm/requests.rs, src/cli/issue/jsm_create.rs, tests/issue_create_jsm.rs, tests/e2e_live.rs, CHANGELOG.md; plus PR description.

## Verdict: APPROVE

Ready to merge. Zero CRITICAL/HIGH/MEDIUM findings. No blocking NITPICKs.

## Basis

1. **Assembly-order bug fix is correct.** `JsmRequestBuilder::build()` now inserts
   summary/priority/labels → `extra_fields` loop → `resolved_adf_values` merge → THEN
   `self.description`. This makes `--description`'s ADF deterministically supersede a
   `--field description=` string-wrap (AC-006 / EC-3.8.019-4), and makes
   `resolved_adf_values` supersede any same-key string-wrap. The asymmetry
   (description wins over extra_fields; priority/labels still lose to extra_fields per
   BC-3.8.008) is deliberate and documented in the code + CHANGELOG.

2. **isAdfRequest purity is sound (AC-013).** `build()` computes
   `description_is_adf || self.is_adf_request` — it never derives ADF-ness from value
   shapes. The regression test (hinted `:id` field → JSON object must NOT trip
   `isAdfRequest`) directly guards the exact mutant class. C.2 proptest correctly
   tightened from `.and_then(as_bool).unwrap_or(false)` to `.is_none()` (ABSENT, not
   explicit `false`).

3. **Fail-open contract is correct (AC-008 / EC-3.8.019-2).**
   `fetch_request_type_fields_cached` returns `None` on any error;
   `resolve_jsm_adf_extra_fields` is infallible (no `Result`), emits exactly one global
   stderr `warning:` line, degrades all bare values to plain strings (their untouched
   shape), never sets `is_adf_request`, and never exits 64.

4. **Empty-omit is correct (AC-007 / BC-3.8.021).** Empty/whitespace bare ADF-backed
   field is dropped from both `extra_fields` and `resolved_adf_values`, contributes no
   `is_adf_request` — distinct from the platform edit path's clear-doc semantics,
   documented.

5. **Backward compatibility intact.** All 6 pre-existing `requests.rs` call sites
   (proptests + build tests) and the test helper pass `resolved_adf_values:
   &BTreeMap::new()` / `is_adf_request: false`, preserving output byte-for-byte. Only
   production caller is `handle_jsm_create`.

6. **GET-gating correct (AC-015a).** `has_bare_field_pair` guard means hinted-only /
   no-field creates issue zero metadata GETs. Cache-first via the shared
   request_type_fields cache (7-day TTL).

7. **ADF detection contract correct (AC-002).** `is_adf_field_value` called with
   `rt_field.jira_schema` directly — no double-nesting; reuses the Story-1 shared
   predicate, not re-implemented.

## Test coverage

Thorough. Resolution-layer wiremock tests isolate `JR_CACHE_DIR`/`XDG_CACHE_HOME`
per-test under a mutex, driving the runtime outside the guard (no
`clippy::await_holding_lock`). Recursive INV-1 no-raw-newline assertions on ADF text
nodes, plus two pure `build()` regression tests for AC-006 and AC-013.

## Quality gates (per PR evidence)

- `cargo test --lib jsm` 31/0
- `cargo test --test issue_create_jsm` 113/0
- `cargo clippy -- -D warnings` clean
- `cargo fmt --all -- --check` clean
