## PR Review — S-578-3 (JSM `issue create --field` hint-kind dispatch)

---

## FINAL CONFIRMATION REVIEW (HEAD 29300a3b, 2026-08-27) — Verdict: APPROVE

Fresh-eyes re-review after fix commit `29300a3b9bee558227248ac0fa42275dc3cfaf17`. Both prior BLOCKING items are resolved:

- **B2 (byte-identity pin) — FIXED, verified.** `test_vp_578_015_bare_field_byte_identical_pre_post_amendment` (`tests/issue_create_jsm.rs`) now asserts the ENTIRE `requestFieldValues` object in a single `assert_eq!(rfv, &json!({...}))` against the full expected wire shape `{summary:"test", priority:{name:"High"}, labels:["alpha"], customfield_70000:"BareUnhintedValue"}`. This replaces the four per-key spot-checks: an added/removed/renamed key OR a wrong value on any key (including exact `labels` contents, not just length) now fails. Confirmed the asserted expected map matches the CLI invocation inputs exactly (`--summary test --priority High --label alpha --field customfield_70000=BareUnhintedValue`), so the expected object is complete, not itself understating the input. POST mock is `.expect(1)`. The "BYTE-IDENTICAL" name is now genuine.
- **B1 (PR body test-count wording) — being corrected separately** by the PR manager directly in the PR description (not a code change), per the task brief.

No new blocking issues introduced by `29300a3b`. The two other changes are pure test-strengthening: (1) AC-001 rename `test_bc_3_8_008_extra_fields_type_is_field_value_spec_map` → `test_bc_3_8_008_bare_field_flows_through_spec_typed_extra_fields` (addresses NITPICK 5); (2) `.expect(0)` added to the POST `/rest/servicedeskapi/request` mock in the four `:asset` cold-cache taxonomy tests, so a cold-cache failure asserts zero JSM POSTs — matching the malformed-`:asset` tests' pattern (addresses NITPICK 8). Diff touches only `tests/issue_create_jsm.rs` (+22/-23).

CI at HEAD: all green — Format, Clippy (ubuntu + windows), Test (ubuntu/macos/windows), MSRV 1.85.0, Deny, Coverage, dependency-review. `mergeable=MERGEABLE`, `state=OPEN`.

**Approved for merge. covered_sha: 29300a3b9bee558227248ac0fa42275dc3cfaf17**

---

### Original pass (superseded by the confirmation review above)

**Verdict: REQUEST_CHANGES** — 2 BLOCKING (both factual-accuracy, ~20 min of work), 4 NON-BLOCKING, 4 NITPICK.

> Posted as a COMMENT-state review only because GitHub rejects `--request-changes` on one's own PR (`Review Can not request changes on your own pull request`). The verdict above is the actual verdict — treat the two BLOCKING items as merge-gating.

The **implementation is correct** and the wire-shape/negative-path tests are genuinely strong. What I'm blocking on is evidence accuracy, not behavior. Verified locally: `cargo test --test issue_create_jsm` 107/107, `cargo clippy --all-targets -- -D warnings` clean, CI green (mutants pending).

---

### Claims verified against the code (not taken from the description)

1. **Kind-aware dispatch + layer isolation — CONFIRMED.** `requests.rs:130-142` dispatches `None|Some(Option)` → `Value::String`, `Id` → `{"id":V}`, `Name` → `{"name":V}`, `Asset` → pure array-wrap. `grep -n "assets\|workspace" src/api/jsm/requests.rs` yields **only doc-comment mentions** — zero calls into `api::assets` or `get_or_fetch_workspace_id`. ADR-0019 §2 holds.
2. **`:option` cascading is opaque — CONFIRMED.** No `'>'` split, `contains('>')`, `Parent`, or `cascad` anywhere in `requests.rs` or `jsm_create.rs`.
3. **`:asset` pre-flight validation — CONFIRMED, and rigorously tested.** All five malformed shapes assert exit 64 + exact message + `.expect(0)` on **both** the workspace GET and the POST mock (6154/6231/6306/6382/6467). Check precedence matches the doc: `:asset=:` hits EC-2c, never EC-2b.
4. **Dead helper — CONFIRMED.** `reject_unsupported_hint_kinds` has zero call sites codebase-wide; the 5 survivors are `//` narration in test files. Build+clippy clean would have caught a stale caller.
5. **VP-578-016 honesty — CONFIRMED.** Module header (5364-5376) states a green run "is NOT proof of live-JSM parity"; assertion messages carry "(by analogy, parity-PENDING)". Nothing overstates. *(One gap — see NITPICK 8.)*

**Scope is clean:** exactly the 5 permitted files. No `field_resolve.rs`, `edit.rs`, `api/jira/issues.rs`, `tests/jsm_request_api.rs`, or `.factory/specs/prd/` BC file touched. No pre-existing test was deleted — the one vanished name was *renamed in place* and gained assertions.

---

## BLOCKING

### B1 — PR evidence overstates the coverage delta by ~2.4x
`tests/issue_create_jsm.rs` went from **61 → 81 test functions (+20)**, not "59 → 107 (+48)". The 107 is the whole test *binary*: 81 from this file plus **26 from `common::wf::tests`**, pulled in via `mod common;` (line 16) — the S-CIGATE-3 YAML-parser module, entirely untouched by this story. Confirm with `cargo test --test issue_create_jsm -- --list | grep -c "common::"` → 26.

The PR body, the coverage table ("107/107", "up from 59 baseline"), and the badge all inherit this. Please correct them — the factory's convergence record depends on these numbers being real, and +20 well-targeted tests is a perfectly good result that doesn't need inflating.

### B2 — AC-008 claims byte-identity; the body is a partial match
`tests/issue_create_jsm.rs:6868-6873` (claim) vs `6944-6967` (body) — `test_vp_578_015_bare_field_byte_identical_pre_post_amendment`. The doc claims *"BYTE-IDENTICAL `requestFieldValues` wire output before and after the amendment."* The body asserts four keys individually and never asserts the **key set** (an added key is invisible), never asserts `labels[0] == "alpha"` (only `.map(Vec::len) == Some(1)`, 6963-6967), and compares against no captured baseline.

This is the regression pin protecting the highest-traffic path — `build()`'s loop is shared by `summary`/`description`/`priority`/`labels`. Fix is one line: `assert_eq!(rfv, &json!({ ...complete expected map... }))`. Or retitle it. Per this repo's own convention (`CLAUDE.md` § Test naming), *"a name asserting a guarantee its body doesn't check is a defect, not a style deviation."*

---

## NON-BLOCKING

### N1 — This PR introduces the only `api/` → `cli/` import in the codebase
`src/api/jsm/requests.rs:15`. `grep -rn "use crate::cli" src/api/` returns **exactly this one line**, and to enable it `src/cli/issue/mod.rs:5` widens `mod create;` → `pub(crate) mod create;`.

The ADR's "Alternatives Considered" weighs resolving inside `build()` (rejected: L4→L4 edge) and extending cascading (out of scope) — but never the third option: move `FieldValueSpec`/`FieldValueKind` to a neutral `src/types/` module that both L2 and L4 import. That avoids the L4→L4 edge *and* this L4→L2 one, and lets `mod create;` stay private. Both types are already `pub(crate)` with no other exports (only 3 items in that module), so the move is mechanical, zero behavior change.

I'm not blocking — it's disclosed and tracked. But an ADR that rejects an alternative *specifically* for creating a bad dependency edge, while creating an inverted one, should at minimum record why the neutral-module option was passed over. Worth doing before S-578-4 copies the pattern.

### N2 — `panic!` on a path that already returns `Result`
`src/api/jsm/requests.rs:216-222` — `compose_asset_wire` panics if `value` lacks a `:`. Not reachable today (verified: only `jsm_create.rs` builds non-empty `extra_fields`, every Asset spec routes through `resolve_asset_field_l2` first, and all four proptest builders pass empty maps). But `build()` already returns `Result<_, JrError>`, so an error return is nearly free, and `extra_fields` is `pub(crate)` — a future in-crate constructor makes it live. A panic exits 101 with no actionable message, against the repo's "always suggest what to do next" convention.

### N3 — "AT MOST ONCE" rustdoc is inaccurate
`src/cli/issue/jsm_create.rs:408-410` claims `get_or_fetch_workspace_id` is *"called AT MOST ONCE per invocation."* At the call-graph level that's false: the loop calls `resolve_asset_field_l2` once per `:asset` field, so `--field a:asset=1 --field b:asset=2` calls it twice. It's at most one *HTTP* round-trip only because the resolver reads a disk cache first — and `workspace.rs:55` is `let _ = cache::write_workspace_cache(...)`, swallowing write failures, so on an unwritable cache dir N bare `:asset` fields → N GETs. Reword to "at most one HTTP round-trip, via the workspace cache", or memoize per invocation.

### N4 — Stale test whose doc this PR rewrote without touching the body
`tests/issue_create_jsm.rs:1194-1250` — `test_jsm_create_field_bare_pair_unaffected_by_kind_hint_guard_s578_1`. Three defects at once: the new doc (1197-1199) claims *"hinted and unhinted pairs must never interfere with each other"* but the invocation (1234-1236) passes **one bare field and no hinted pair**; the only assertion is `output.status.success()` with no `.expect(1)` and no body inspection, so it passes even if `cf` were dropped from `requestFieldValues` entirely; and the failure message (1247) still cites *"the interim ':kind'-hint guard"* this PR deleted — it can no longer fail for its stated reason.

Either add a hinted field alongside the bare one and assert both wire values (making it the non-interference test the doc claims), or delete it — the bare-only case is already covered at 5470, 5685, and 6944.

---

## NITPICK

5. **AC-001 name asserts a type its body can't check.** `5407` — `test_bc_3_8_008_extra_fields_type_is_field_value_spec_map` sends one bare field and asserts the wire value is `"plain"`, which passes identically under the old `HashMap<String, String>`. Not tautological (it does pin a real wire value) and the doc admits both halves honestly — but same name/body class as B2. Suggest `test_bc_3_8_008_bare_field_flows_through_spec_typed_extra_fields`.
6. **Validation runs after the stdin read and after request-type HTTP.** `jsm_create.rs:275-297` — `--request-type "Password Reset" --field f:asset=bad --description-stdin` blocks on stdin and issues request-type GETs before rejecting. The tests' `.expect(0)` claims are scoped to the workspace GET and POST and are accurate; the PR body's broader *"zero HTTP GET"* is not. Compare DEC-188, which explicitly places the platform pre-flight *before* the stdin read. A pure client-free `validate_asset_value` hoisted to just after `parse_field_kv` fixes this and item 7 together.
7. **~40 lines of validation duplicated verbatim.** `jsm_create.rs:437-490` vs `field_resolve.rs:936-980` — same four checks, same precedence, same message strings, character for character. Tracked as debt already; since the copies are *currently* identical, extracting is the cheapest it will ever be.
8. **`:asset` assertion messages omit the parity caveat** (6032-6033, 6122-6123) — the only wire-shape messages that do, and `:asset` is the kind the story flags as most likely to diverge. Also: cold-cache tests (6564/6633/6702/6783) omit `.expect(0)` on the POST mock, unlike the malformed tests 200 lines earlier; and the 5xx sub-case at 6823-6863 uses `http://127.0.0.1:1`, which fails on the first HTTP call and never reaches hint dispatch (openly documented, contributes nothing to `:asset` coverage).

Minor: `jsm_create.rs:~470`'s `format!("{workspace_id}:{object_id}")` just reconstitutes `value`; `value.to_string()` is clearer. The workspace segment is only checked non-empty (`f:asset= ws:123` composes `" ws:123"`) — matches `field_resolve.rs` exactly, so parity holds. Numeric edges are handled correctly: `-5`, Unicode digits `١٢٣`, and surrounding whitespace are all rejected by `is_ascii_digit`, and oversized objectIds are never integer-parsed (no overflow surface). The four proptests still pass empty `extra_fields`, so the new dispatch loop has no property coverage.

---

## Summary

Correct implementation, real layer separation, unusually rigorous negative-path tests (exact `Value` equality on captured bodies, dual zero-HTTP proofs), and more intellectual honesty about VP-578-016 than most PRs manage. No correctness, security, or scope defects.

B1 and B2 are both cheap and both about the PR's own claims being accurate — B1 because the factory's record depends on it, B2 because it's the regression pin guarding the shared `build()` path. N1 and N4 are worth folding in while you're here.
