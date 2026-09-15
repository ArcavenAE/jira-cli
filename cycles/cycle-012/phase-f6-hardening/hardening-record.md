---
document_type: f6-hardening-record
phase: phase-f6-targeted-hardening
producer: formal-verifier
cycle: cycle-012-field-adf-autoconvert
feature: "field-adf-autoconvert"
mode: BROWNFIELD-FEATURE
status: complete
timestamp: 2026-09-14
project: jira-cli
scope: "cycle delta only (ADF auto-conversion, both waves) on develop @ 80bb4215"
baseref: "develop @ 80bb4215 (PR #813 merged; F5 scoped adversarial CONVERGED)"
new_vps: [VP-FIELD-ADF-001, VP-FIELD-ADF-002, VP-FIELD-ADF-003, VP-FIELD-ADF-004]
dtu_required: false
verdict: HARDENED
inputs:
  - ".factory/phase-f2-spec-evolution/cycle-012-verification-delta.md"
  - "src/cli/issue/field_resolve.rs"
  - "src/cli/issue/jsm_create.rs"
  - "src/api/jsm/requests.rs"
  - "src/adf.rs"
  - "tests/issue_edit_field_adf.rs"
  - "tests/issue_create_field_adf.rs"
  - "tests/issue_create_jsm.rs"
  - ".cargo/mutants.toml"
input-hash: "028ed43"
---

# F6 Targeted Hardening Record — cycle-012 `field-adf-autoconvert`

Scoped to the cycle-012 delta (ADF auto-conversion for `--field` on rich-text
fields; Story 1 platform path PRs #809/#811, Story 2 JSM path PR #812; F5
fix-burst PR #813). Verifies the four new verification properties
`VP-FIELD-ADF-001..004` defined in
`.factory/phase-f2-spec-evolution/cycle-012-verification-delta.md`.

Baseref: `develop @ 80bb4215`. No production code was modified during F6.

---

## 1. Per-VP Coverage Verdict

### VP-FIELD-ADF-001 — ADF detection predicate is risk-symmetric — **COVERED**

Shared allowlist core lives in exactly one place:
`src/cli/issue/field_resolve.rs::is_adf_schema` (:815), reached via two entry
points — `is_adf_field(&EditMetaFieldSchema)` (:842, platform) and
`is_adf_field_value(&serde_json::Value)` (:831, `pub(crate)`, JSM).

| Axis | Test | File:line | Kind |
|------|------|-----------|------|
| Universal predicate (fires IFF allowlist) | `prop_bc_3_4_033_is_adf_field_fires_only_on_allowlist` | field_resolve.rs:1829 | proptest |
| Positive + negative concrete anchors | `test_bc_3_4_033_is_adf_field_allowlist_positive_and_negative_anchors` | field_resolve.rs:1871 | example matrix |
| JSM `Value`-level entry delegates to core | `test_bc_3_4_033_is_adf_field_value_delegates_to_allowlist` | field_resolve.rs:1935 | example |
| JSM inner-block extraction (no double-nesting) | `test_bc_3_8_019_is_adf_field_value_receives_inner_schema_not_double_nested` | jsm_create.rs:1008 | example |

The proptest exercises both `system`/`custom` `Option<String>` axes and asserts
`true` IFF `system == "description" | "environment"` OR `custom.ends_with(":textarea")`,
covering the negative regression pins (`:textfield`, `summary`, empty schema).
The JSM `serde_json::Value` extraction path (`value["system"].as_str()` etc.) is
directly pinned by the two `is_adf_field_value` tests. **No uncovered axis.**

### VP-FIELD-ADF-002 — Non-empty ADF write produces valid ADF doc; INV-1 holds (platform) — **COVERED**

Primary module: `dispatch_field_value` ADF branch + `src/adf.rs::text_to_adf`.

| Axis | Test | File:line | Kind |
|------|------|-----------|------|
| Properties 1–3 (object, non-empty content, INV-1) over arbitrary input | `prop_bc_3_4_033_dispatch_field_value_adf_backed_returns_adf_object` | field_resolve.rs:2026 | proptest |
| Multi-line → `hardBreak`, no raw `\n` (INV-1) | `test_bc_3_4_033_dispatch_field_value_multiline_uses_hardbreak` | field_resolve.rs:2132 | example |
| `text_to_adf` INV-1 (arbitrary + HTML-char inputs) | `prop_text_to_adf_holds_inv1`, `prop_markdown_to_adf_html_chars_holds_inv1` | adf.rs:12051 / :12294 | proptest |
| Dry-run JSON `planned_preview` = ADF object keyed by human name | `test_bc_3_4_033_dry_run_planned_preview_contains_adf_object_keyed_by_human_name` | issue_edit_field_adf.rs:276 | wiremock/CLI |
| Dry-run TABLE `(adf)` marker from `field_markers` | `test_bc_3_4_033_dry_run_table_shows_adf_marker` | issue_edit_field_adf.rs:391 | wiremock/CLI |
| Live-edit JSON channel = RAW input (lossless, #398 discipline) | `test_bc_3_4_033_live_edit_json_changed_fields_raw_input_not_adf_object` | issue_edit_field_adf.rs:479 | wiremock/CLI |
| Live-edit TABLE `(adf)` marker not raw value | `test_bc_3_4_033_live_edit_table_shows_adf_marker_not_raw_value` | issue_edit_field_adf.rs:544 | wiremock/CLI |
| `--field description=` renders `(adf)` not `(updated)` | `test_bc_3_4_035_live_edit_field_description_shows_adf_not_updated` | issue_edit_field_adf.rs:737 | wiremock/CLI |
| Create-path TABLE `(adf)` marker | `test_bc_3_3_013_create_table_shows_adf_marker` | issue_create_field_adf.rs:422 | wiremock/CLI |
| Createmeta adaptation preserves system/custom for detection | `test_bc_3_3_013_014_createmeta_adaptation_preserves_system_custom_for_adf_detection` | issue_create_field_adf.rs:486 | wiremock/CLI |

VP-002 is platform-scoped by design (adversarial PASS-1 H-4); JSM positive
conversion is owned by VP-004. **No uncovered axis.**

### VP-FIELD-ADF-003 — Empty-value invariant: no empty text node; path-specific semantics — **COVERED**

Pure gate helper `is_bare_empty_adf_field` (field_resolve.rs:869,
`kind.is_none() && is_adf_field(schema) && value.trim().is_empty()`) is the
realized F4 extraction obligation for the bare-form gate.

| Axis | Test | File:line | Kind |
|------|------|-----------|------|
| A/B edit empty → clear-doc | `test_bc_3_4_036_edit_empty_adf_field_resolves_to_clear_doc` | issue_edit_field_adf.rs:910 | wiremock/CLI |
| A/B create empty → field omitted | `test_bc_3_3_015_create_empty_adf_field_omitted` | issue_create_field_adf.rs:587 | wiremock/CLI |
| C JSM empty → omitted + `isAdfRequest` NOT accumulated | `test_bc_3_8_021_jsm_empty_adf_field_omitted_isadfrequest_not_accumulated` | jsm_create.rs:1295 | unit (resolution layer) |
| D bare-form gate only (platform) | `test_adf_empty_guard_fires_only_on_bare_form_not_hinted_platform` | field_resolve.rs:2218 | unit (pure) |
| D bare-form gate only (JSM) | `test_adf_empty_guard_fires_only_on_bare_form_not_hinted_jsm` | jsm_create.rs:1045 | unit (pure) |
| E dry-run JSON = clear-doc keyed by human name | `test_bc_3_4_036_dry_run_planned_preview_contains_clear_doc_keyed_by_human_name` | issue_edit_field_adf.rs:329 | wiremock/CLI |
| F live-edit JSON = raw empty/whitespace input (not clear-doc) | `test_bc_3_4_036_live_edit_json_changed_fields_raw_empty_input_not_clear_doc`, `..._raw_whitespace_input_not_empty_string` | issue_edit_field_adf.rs:595 / :664 | wiremock/CLI |
| G platform-create POST-body empty-omit | `test_bc_3_3_015_create_empty_adf_field_omitted_from_post_body` | issue_create_field_adf.rs:361 | wiremock/CLI |
| H dry-run TABLE `(adf-clear)` sentinel from `field_markers` | `test_bc_3_4_036_dry_run_table_shows_adf_clear_sentinel_from_field_markers` | issue_edit_field_adf.rs:433 | wiremock/CLI |

All eight axes (A–H) covered. **No uncovered axis.**

### VP-FIELD-ADF-004 — JSM resolution layer: detect / convert / accumulate / omit — **COVERED**

Primary modules: `jsm_create.rs` resolution layer + `api/jsm/requests.rs::build`.

| Axis | Test | File:line | Kind |
|------|------|-----------|------|
| (a) inner `jiraSchema` detection, no double-nesting | `test_bc_3_8_019_is_adf_field_value_receives_inner_schema_not_double_nested` | jsm_create.rs:1008 | unit |
| (b) non-empty description → ADF object in `requestFieldValues` | `test_bc_3_8_019_jsm_description_extra_field_adf_converted` | jsm_create.rs:1075 | unit |
| (b) non-empty `:textarea` → ADF object | `test_bc_3_8_020_jsm_textarea_extra_field_adf_converted` | jsm_create.rs:1144 | unit |
| (c) `isAdfRequest: true` accumulated when any field ADF | `test_bc_3_8_022_is_adf_request_accumulated_for_adf_field` | jsm_create.rs:1194 | unit |
| (d) `isAdfRequest` absent when no ADF field | `test_bc_3_8_020_is_adf_request_absent_when_no_adf_field_present` | jsm_create.rs:1251 | unit |
| (f) empty → omit + flag not accumulated (shared w/ VP-003 Axis C) | `test_bc_3_8_021_jsm_empty_adf_field_omitted_isadfrequest_not_accumulated` | jsm_create.rs:1295 | unit |
| (g) `build()`-level ADF presence + description supersede + hinted-object no-flag | `prop_build_jsm_request_body_description_adf_presence`, `test_bc_3_8_019_build_description_supersedes_extra_field_description_entry`, `test_bc_3_8_022_is_adf_request_absent_with_hinted_object_field_no_adf` | requests.rs (proptest + :533 + :586) | proptest + unit |
| Integration (isAdfRequest true end-to-end, key-only output) | `test_jsm_create_description_is_adf_with_is_adf_request_true`, `test_bc_3_8_019_jsm_create_output_is_key_only_no_adf_marker` | issue_create_jsm.rs:668 / :7423 | wiremock/CLI |

All coverage areas 1–4 and axes (a)–(g) covered. **No uncovered axis.**

**Overall: all four VPs have real, passing verification coverage. No VP axis lacks coverage.**

---

## 2. Kani / cargo-fuzz Substitution — JUSTIFIED (0-GAP)

Confirmed repo reality (F6, this session): `grep -c kani Cargo.toml` = 0; no
`fuzz/` directory; no `kani-verifier`. Neither tool has ever been provisioned in
this repo.

**Substitution rationale (established precedent, HISTORY-SKIP-LOG.md cycles 002/003/004):**
proptest + example-based unit tests + cargo-mutants are the standing substitution
for formal verification on this codebase's pure-core helpers. The same rationale
applies here:

- **VP-001/002 (predicate + conversion):** the correctness claim is a universal
  quantification over `EditMetaFieldSchema` / non-empty input strings — exactly
  the shape proptest captures directly (`prop_bc_3_4_033_is_adf_field_fires_only_on_allowlist`,
  `prop_bc_3_4_033_dispatch_field_value_adf_backed_returns_adf_object`,
  `prop_text_to_adf_holds_inv1`). The predicate is a pure pattern match — no
  arithmetic overflow, no array indexing, no unsafe code — so a Kani bounded model
  check adds nothing. There is no untrusted deserialization surface to fuzz:
  `EditMetaFieldSchema` is deserialized before `is_adf_field` runs.
- **VP-003 (empty-value gate):** the extracted pure gate `is_bare_empty_adf_field`
  is a deterministic branch (whitespace check + kind gate) with no overflow /
  unsafe / deserialization surface. Fuzzing adds no coverage.
- **VP-004 (JSM resolution layer):** covered by unit tests over the network-free
  resolution function (pre-fetched metadata passed as a parameter) plus a `build()`
  proptest; deterministic and pure at the assertion boundary.

**0-GAP statement:** skipping Kani and cargo-fuzz introduces NO coverage gap
relative to the BC set (BC-3.3.013..015, BC-3.4.033..037, BC-3.8.019..022). Every
correctness claim is either (a) a universal property captured by proptest, (b) a
deterministic example-anchored regression, (c) a route-specific empty-value unit
test, or (d) a caller-level wiremock/CLI integration test. This is a documented
substitution, not an omission — identical in kind to the cycle-002/003/004 F6
skip-log entries.

---

## 3. Mutation Gate (cargo-mutants) — GREEN in CI (not re-run locally)

`.cargo/mutants.toml examine_globs` covers all changed delta files (confirmed
this session):
- `src/cli/issue/field_resolve.rs` — `is_adf_schema`/`is_adf_field`/`is_adf_field_value` predicate + `dispatch_field_value` ADF branch + `is_bare_empty_adf_field` gate
- `src/cli/issue/jsm_create.rs` — JSM resolution layer (detection, conversion, `isAdfRequest` accumulation, empty-omit)
- `src/api/jsm/requests.rs` — `build()` request-body assembly
- `src/adf.rs` — `text_to_adf`

The prime mutant targets identified in the F2 delta (removing an allowlist arm,
replacing `ends_with(":textarea")` with `contains("text")`, dropping the ADF
branch, writing the empty clear-doc for all inputs) are killed by the RED-proven
VP-001/002/003 tests above.

**CI status (observed this session, do NOT re-run — heavy, CI already covered per
cycle policy):**
- PR #812 (Story 2 JSM): `Mutation Testing (Aggregate)` **pass**, `CI Gate` **pass** — run 34905420465.
- PR #813 (F5 fix-burst): `Mutation Testing (Aggregate)` **pass**, `CI Gate` **pass** — run 34910142474.

The sharded mutation gate (8 shards + aggregate) ran green on both PRs that
introduced/adjusted the delta code.

---

## 4. Security Scan — CLEAN

F5 security-reviewer already produced CLEAN (STATE.md: "security review CLEAN").
Confirmed at the CI level this session on PR #813 (run 34910142474):
- `Deny (licenses + vulnerabilities)` — **pass**
- `Secret Scan (gitleaks)` — **pass**
- `Spec Guards (BC counts, numeric-count lint, citation checks, mutants policy scope)` — **pass**

No new attack surface: the feature is pure string→ADF transformation over
already-authenticated field values; no new I/O, no new deserialization of
untrusted input, no credential handling.

---

## 5. DTU / Accessibility — N/A

- **DTU:** `dtu_required: false`. The feature transforms field values before an
  already-covered Jira REST POST; it clones no third-party service. No DTU
  obligation.
- **Accessibility / visual:** `jr` is CLI-only; no UI surface. Same standing
  no-UI determination as prior cycles. N/A.

---

## 6. Local Proptest / Test Run Evidence (this session)

All run against `develop @ 80bb4215`, scoped to the delta (full workspace suite
NOT run, per instruction):

| Command | Result |
|---------|--------|
| `cargo test --lib field_resolve` | **26 passed / 0 failed** (incl. both `prop_bc_3_4_033_*` proptests) |
| `cargo test --lib jsm_create` | **7 passed / 0 failed** (5 `adf_resolution_tests` + 2 empty-guard) |
| `cargo test --lib api::jsm::requests` | **6 passed / 0 failed** (incl. 3 `build_jsm_request_body` proptests) |
| `cargo test --lib inv1` | **3 passed / 0 failed** (`prop_text_to_adf_holds_inv1`, `prop_markdown_to_adf_html_chars_holds_inv1`, + multiline) |
| `cargo test --test issue_edit_field_adf` | **39 passed / 0 failed** |
| `cargo test --test issue_create_field_adf` | **32 passed / 0 failed** |
| `cargo test --test issue_create_jsm adf` | **8 passed / 0 failed** |

Zero failures across all targeted runs.

---

## 7. Residual Gaps

**None at MEDIUM or above.**

LOW residuals (accepted, no action required this cycle):

- **L-1 (LOW, accepted):** VP-FIELD-ADF-004 axes for the JSM path are exercised
  primarily through unit tests at the resolution layer plus a `build()` proptest;
  the end-to-end JSM ADF round-trip against a live instance is covered by the
  `#[ignore]`-gated `test_e2e_jsm_create_adf_field_description_roundtrip`
  (e2e_live.rs:2999), which runs only in the nightly `e2e.yml` job. This mirrors
  the project-wide baseline for live-path claims (wiremock + gated E2E), not a
  gap specific to this cycle.
- **L-2 (LOW, informational):** Kani/cargo-fuzz remain unprovisioned repo-wide.
  Documented substitution per §2; would only warrant revisiting if a future
  feature introduced an untrusted-input parsing surface or arithmetic-heavy pure
  core. Not triggered by this delta.

---

## 8. Overall F6 Verdict

**HARDENED.**

All four new verification properties (VP-FIELD-ADF-001..004) have real, passing
coverage with no uncovered axis; the Kani/fuzz substitution is justified at 0-GAP
per established precedent; the cargo-mutants gate ran green in CI over the delta
files; the security scan (F5 + gitleaks + cargo-deny) is CLEAN; DTU and
accessibility are N/A. Only two LOW residuals remain, both accepted and consistent
with project-wide baselines. F6 targeted hardening is complete for cycle-012.
