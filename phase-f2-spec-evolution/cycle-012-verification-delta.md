---
document_type: f2-verification-delta
phase: phase-f2-spec-evolution
producer: architect (formal-verifier role)
cycle: cycle-012-field-adf-autoconvert
feature: "field-adf-autoconvert"
status: complete
timestamp: 2026-09-13
project: jira-cli
mode: BROWNFIELD
intent: feature
inputs:
  - ".factory/phase-f1-delta-analysis/e2e-edit-field-adf-heuristic-delta-analysis-v4.md"
  - ".factory/research/createmeta-schema-probe-2026-09-12.md"
  - ".factory/research/jsm-requesttype-fields-adf-probe-2026-09-12.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - "src/cli/issue/field_resolve.rs"
  - "src/api/jsm/requests.rs"
  - "src/adf.rs"
  - "src/types/jira/editmeta.rs"
  - "src/types/jsm/request_type.rs"
vp_count_before: 82
vp_count_after: 86
vp_count_basis: >
  STATE.md tracks 82 VPs at the cycle-012 F1-gate burst (v4.21, 2026-09-12).
  This delta allocates 4 new VPs (VP-FIELD-ADF-001..004), taking the total to 86.
  The "before: 82 / after: 86" figures are stated on STATE's tracked basis for
  continuity; state-manager reconciles STATE.md's VP count to 86 at F2 close.
new_vps:
  - VP-FIELD-ADF-001
  - VP-FIELD-ADF-002
  - VP-FIELD-ADF-003
  - VP-FIELD-ADF-004
updated_vps: [VP-578-015]  # scope amended: narrowed to non-ADF-backed field_ids per §7 carve-out; not retired; count unchanged at 86
related_bcs:
  - BC-3.3.013
  - BC-3.3.014
  - BC-3.3.015
  - BC-3.4.033
  - BC-3.4.034
  - BC-3.4.035
  - BC-3.4.036
  - BC-3.4.037
  - BC-3.8.019
  - BC-3.8.020
  - BC-3.8.021
  - BC-3.8.022
related_adr: ADR-0024
input-hash: "3bf509f"
---

# Verification Delta — cycle-012 `field-adf-autoconvert`

Companion to the cycle-012 BCs in `.factory/specs/prd/bc-3-issue-write.md`
(BC-3.3.013..015, BC-3.4.033..037, BC-3.8.019..022). This is the F2 Step-4
(formal-verifier) output: it OWNS the final VP-id assignment for cycle-012 and
defines the proof strategy + test mechanism for each new VP.

The cycle adds 12 new BCs covering ADF auto-conversion for `--field` on
rich-text fields (`environment`, `description`-via-`--field`, `:textarea` custom
fields) across the platform edit path (Story 1), the platform create path (Story 1),
and the JSM create path (Story 2). Four verification properties pin the correctness
invariants that protect this feature against the two highest-severity regression
classes: predicate over/under-selectivity and the JRACLOUD-79318 empty-text-node 400.

---

## 1. VP-ID Allocation

**Namespace: `VP-FIELD-ADF-NNN`** — a fresh feature-scoped namespace for the
field-ADF-autoconvert cycle, following the established project convention
(per-feature VP namespaces; precedent: `VP-674-NNN`, `VP-AUTHDX-NNN`,
`VP-MUTANTS-SHARD-NNN`, `VP-COMPONENT-NNN`, etc.).

**IDs reserved by the BCs (already cited inline in the BC bodies by the product-owner):**
`VP-FIELD-ADF-001`, `VP-FIELD-ADF-002`, `VP-FIELD-ADF-003`, `VP-FIELD-ADF-004`.

**Collision check (grep-verified):** a repo-wide grep for `VP-FIELD-ADF-` finds
occurrences ONLY in the cycle-012 BC bodies (`bc-3-issue-write.md`) and this delta
document. No pre-existing `VP-FIELD-ADF-NNN` id exists anywhere else in the tree.
The `FIELD-ADF` scope prefix is the collision firewall.

| VP-ID | Subject | Technique | Story |
|-------|---------|-----------|-------|
| VP-FIELD-ADF-001 | ADF detection predicate is risk-symmetric (fires IFF allowlist match; never misses; never over-fires) | proptest + example-based `#[test]` | 1 (platform); shared predicate also pinned by Story-2 JSM BCs 3.8.019/020 |
| VP-FIELD-ADF-002 | Non-empty ADF field write produces a valid ADF doc (via `text_to_adf`); INV-1 (no raw newline in text nodes) holds — platform path only (+ dry-run JSON, dry-run TABLE, and live-echo axes, see §4) | proptest + example-based `#[test]` for core Properties 1–3 (pure `dispatch_field_value`/`text_to_adf` — no network); wiremock/CLI-level for the dry-run JSON, dry-run TABLE, and live-echo axes (full `issue edit`/`issue create` pipeline incl. the editmeta/createmeta HTTP fetch) | 1 (platform) |
| VP-FIELD-ADF-003 | Empty-value invariant: auto-wrap path NEVER emits an empty text node; edit → clear-doc; create (platform + JSM) → field omitted (+ dry-run JSON, dry-run TABLE, and live-echo axes, see §4) | unit `#[test]` for Axes A/B (pure no-network code — F4 extraction obligation; exact helper shape/count/signatures are F4's choice); unit `#[test]` for Axis C (JSM resolution layer, DQ-6-gated); unit `#[test]` for Axis D (pure no-network gate code — F4 extraction obligation; not DQ-6-gated); wiremock/CLI-level for Axes E/F (dry-run JSON, live-echo), Axis G (platform-create empty-omit POST-body — caller-level complement to Axis B; see §4 VP-003 and §5 item 16), and Axis H (dry-run TABLE sentinel from `field_markers` — see §4 VP-003 Axis H and §5 item 17) | 1 + 2 |
| VP-FIELD-ADF-004 | JSM resolution layer: `is_adf_field_value` detects ADF-backed fields from the inner `jiraSchema` block (no double-nesting); non-empty ADF field → ADF object in `requestFieldValues`; `isAdfRequest` accumulated; empty → omitted + flag not accumulated | unit `#[test]` (Axis a: `field_resolve.rs::tests`; Axes b–e: `jsm_create.rs` resolution layer, DQ-6-gated; Axis f: `jsm_create.rs` resolution layer — resolution-layer test, authorable once DQ-6 type/signature shape lands; assertion shape DQ-6-option-invariant, test harness is not; Axis g: pure `build()`, authorable NOW for `Value::String(Y)` sub-case; ADF-object pre-seed sub-case requires DQ-6 signature widening; currently RED) | 2 (JSM) |

**Note on VP-FIELD-ADF-004 (ALLOCATED this delta — adversarial PASS-1 C-1 resolution):**
The JSM BC bodies (BC-3.8.019, BC-3.8.020, BC-3.8.021, BC-3.8.022) cite
`VP-FIELD-ADF-004`. The prior draft deferred allocation; adversarial PASS-1 finding
C-1 identified this as a CRITICAL gap — the JSM RESOLUTION LAYER (`jsm_create.rs`)
implements ADF detection and conversion independently; the platform
`dispatch_field_value` path is not used on the JSM create path, so VP-FIELD-ADF-001
and VP-FIELD-ADF-002 (which target `dispatch_field_value`) do not exercise the
JSM-specific resolution-layer detection, conversion, or `isAdfRequest` accumulation
logic. VP-FIELD-ADF-004 is therefore FULLY ALLOCATED at F2 and covers four areas
(these are high-level coverage areas, not axis IDs; the authoritative axis IDs for
VP-FIELD-ADF-004 are labeled `(a)`–`(g)` plus sub-axes `(h1)`/`(h2)` in §4):

- Coverage area 1: the shared ADF-detection predicate (`is_adf_field_value` in `field_resolve.rs`)
  applied to the inner `jiraSchema` block directly (no phantom double-nesting — see
  §4 VP-FIELD-ADF-004 canonical contract);
- Coverage area 2: positive conversion of a non-empty plain value into an ADF object inside
  `requestFieldValues` via `text_to_adf` in the resolution layer (`jsm_create.rs`);
- Coverage area 3: `isAdfRequest: true` accumulation whenever ANY requestFieldValue is ADF-converted;
- Coverage area 4: empty ADF-backed JSM field → omitted + `isAdfRequest` NOT accumulated (this axis
  is shared with VP-FIELD-ADF-003 Axis C; the same test satisfies both VPs).

**Status (F2 complete):** JSM BCs BC-3.8.019/020/021/022 retain their
`VP-FIELD-ADF-004` citation (VP-004 is fully allocated at F2, not deferred to F6).
BC-3.8.019 and BC-3.8.020 also cite `VP-FIELD-ADF-001` for the shared
detection-predicate coverage. BC-3.8.021 does NOT cite `VP-FIELD-ADF-001` — its VP coverage is
VP-FIELD-ADF-004 (axes c/d) + VP-FIELD-ADF-003 (Axis C). BC-3.8.022 does NOT
cite `VP-FIELD-ADF-001` — its VP coverage is VP-FIELD-ADF-004 (axis c) only;
it does NOT cite VP-FIELD-ADF-003 (Axis C). The `(reserved, cycle-012 F6)`
annotations in the JSM BC bodies were dropped.

**VP total handoff to state-manager:** 82 (STATE baseline) → **86** (+4 new VPs,
VP-FIELD-ADF-001..004).
State-manager sets STATE.md's VP count to **86** at F2 close.

---

## 2. Registration Surface & Propagation

**This project has no `VP-INDEX.md` and no `verification-architecture/`
directory** — neither exists in the tree (`find` confirmed — the only
`ARCH-INDEX.md` is at `.factory/specs/architecture/ARCH-INDEX.md` and contains no
VP registry section). Per the standing Project Convention (documented in
`verification-delta-398.md §"Project Convention Note"`, reaffirmed in
`verification-delta-571.md`, `verification-delta-674.md §2`, and
`cycle-007-verification-delta.md §2`), VPs are registered **inline** as
`**Verification Properties**:` subsections within the BC bodies.

The product-owner already populated the BC bodies with the reserved VP citations
during F2 BC authoring:

| VP | BC bodies citing it |
|----|---------------------|
| VP-FIELD-ADF-001 | `bc-3-issue-write.md § BC-3.3.013`, `bc-3-issue-write.md § BC-3.3.014`, `bc-3-issue-write.md § BC-3.4.033`, `bc-3-issue-write.md § BC-3.4.034`, `bc-3-issue-write.md § BC-3.4.035`, `bc-3-issue-write.md § BC-3.4.037` (platform); `bc-3-issue-write.md § BC-3.8.019`, `bc-3-issue-write.md § BC-3.8.020` (JSM shared predicate). BC-3.8.021 does NOT cite VP-001 — its coverage is VP-FIELD-ADF-004 (axes c/d) + VP-FIELD-ADF-003 (Axis C). BC-3.8.022 does NOT cite VP-001 — its coverage is VP-FIELD-ADF-004 (axis c) only, NOT VP-FIELD-ADF-003 |
| VP-FIELD-ADF-002 | `bc-3-issue-write.md § BC-3.3.013`, `bc-3-issue-write.md § BC-3.3.014`, `bc-3-issue-write.md § BC-3.4.033`, `bc-3-issue-write.md § BC-3.4.034`, `bc-3-issue-write.md § BC-3.4.035`, `bc-3-issue-write.md § BC-3.4.037` (platform path only; JSM positive conversion is owned by VP-FIELD-ADF-004) |
| VP-FIELD-ADF-003 | `bc-3-issue-write.md § BC-3.3.014`, `bc-3-issue-write.md § BC-3.3.015`, `bc-3-issue-write.md § BC-3.4.035`, `bc-3-issue-write.md § BC-3.4.036`; Axis C also satisfies `BC-3.8.021` |
| VP-FIELD-ADF-004 | `bc-3-issue-write.md § BC-3.8.019`, `bc-3-issue-write.md § BC-3.8.020`, `bc-3-issue-write.md § BC-3.8.021`, `bc-3-issue-write.md § BC-3.8.022` |

VP-FIELD-ADF-001 and VP-FIELD-ADF-002 BC citation text was normalized to the
following canonical subjects during F2:

- **VP-FIELD-ADF-001 canonical subject:**
  `ADF detection predicate is risk-symmetric (fires IFF allowlist match; never misses; never over-fires)`
- **VP-FIELD-ADF-002 canonical subject:**
  `Non-empty ADF field write produces a valid ADF doc (via text_to_adf); INV-1 (no raw newline in text nodes) holds — platform path only`

VP-FIELD-ADF-001 is the full risk-symmetric predicate (both ADF and non-ADF, both
platform and JSM); VP-FIELD-ADF-002 is the platform conversion correctness property
(scoped to `dispatch_field_value`, NOT the JSM resolution-layer path — JSM positive
conversion is VP-FIELD-ADF-004). The platform BC citations remain accurate as a SUBSET
of each VP's full coverage.

**ARCH-INDEX.md — UPDATED.** ADR-0024 (`ADF Auto-Conversion for --field on
Rich-Text Fields`) has been added to the Architecture Decisions table at
`.factory/specs/architecture/ARCH-INDEX.md`. Subsystems affected: SS-02, SS-04,
SS-05, SS-08.

**Frontmatter count sweep — N/A.** No BC file frontmatter carries a `total_vps`
field (only `total_bcs`/`definitional_count` exist).
`scripts/check-spec-counts.sh` / `scripts/check-bc-cumulative-counts.sh` govern BC
counts, not VP counts.

---

## 3. Verification Toolchain In Scope (and the Kani/Fuzz Justified-Skip)

**In scope for this cycle:**

- **proptest** over `src/cli/issue/field_resolve.rs::tests` — the `is_adf_field`
  helper and `dispatch_field_value`'s ADF branch are pure, deterministic functions
  that take well-typed inputs. Proptest over `EditMetaField` generators directly
  captures the "for ALL inputs with property X, result has property Y" universal
  quantification that makes these VPs mutant-discriminating.
- **Example-based `#[test]`** for concrete cases: specific system field values
  (`"description"`, `"environment"`), specific plugin type suffixes (`:textarea` vs
  `:textfield`), the `customfield_NNNNN` literal-bypass form (M4 regression anchor),
  and the `serde_json::Value`-level JSM wrapper test.
- **Unit `#[test]`** for Axes A/B of VP-FIELD-ADF-003: these axes verify the
  empty-value decision logic (edit → clear-doc; create → omit) and are an
  **F4 extraction obligation** — F4 must factor this logic into pure, network-free
  code so Axes A/B are authorable as unit tests rather than requiring a MockServer.
  `resolve_against_editmeta` (~:707) issues `client.get_editmeta(key).await?`
  (mandatory HTTP) and `resolve_against_createmeta` (~:614/:632) issues two mandatory
  HTTP fetches; reaching the empty-value pre-check via these functions requires a mock
  server. The extracted pure code eliminates that coupling for Axes A/B — it receives
  the already-fetched schema and value, makes the pure decision, and is unit-testable
  with no wiremock. **The exact helper shape, count, and signatures are F4's choice.**
  For Axis C (JSM resolution layer in `src/cli/issue/jsm_create.rs`, DQ-6-gated):
  pure unit tests against the resolution-layer function once DQ-6 lands (the
  resolution layer receives pre-fetched metadata as a parameter, so it is itself
  network-free). For Axis D (bare-form guard, platform + JSM): pure unit tests
  verifying the `kind.is_none()` gate on the ADF empty pre-check — an **F4 extraction
  obligation**. `resolve_against_editmeta` (~:707) and `resolve_against_createmeta`
  (~:603-633) both gate the ADF empty pre-check behind `spec.kind.is_none()`, but
  BOTH also issue mandatory HTTP calls BEFORE the gate is reached; they cannot serve
  as unit-test targets for Axis D without a mock server. F4 must extract the
  `kind.is_none() && is_adf_schema(system, custom) && value.trim().is_empty()` gate
  condition into pure, network-free code — **the exact decomposition is F4's choice**
  — so both the platform and JSM Axis D sub-cases can be unit-tested without wiremock.
  Axes E (dry-run) and F (live-echo) require a wiremock mock server
  (`JiraClient::new_for_test` + `MockServer`) because they exercise the full CLI
  pipeline including the editmeta HTTP fetch — these are wiremock/CLI-level tests,
  NOT no-network unit tests. VP-FIELD-ADF-003 Axis G (platform-create empty-omit
  POST-body; see §4 VP-003 Axis G and §5 item 16) is also in this category: it
  drives `jr issue create --field <ADF-BACKED-FIELD>=` (empty) through
  `resolve_against_createmeta` with a wiremock createmeta stub and asserts the
  constructed POST `fields` map contains NO key for the ADF-backed field — a
  caller-level integration test, NOT a no-network unit test.
  VP-FIELD-ADF-003 Axis H (dry-run TABLE sentinel from `field_markers` — see §4 VP-003
  Axis H and §5 item 17) is also in this category: it drives `jr issue edit KEY --field
  <ADF-BACKED-FIELD>=` (empty) with `--dry-run` through the full CLI pipeline with a
  wiremock editmeta stub and asserts the dry-run table cell shows `(adf-clear)` (derived
  from `field_markers`, NOT by inspecting `planned_preview` content shape) — a
  wiremock/CLI-level test, NOT a no-network unit test.
- **Wiremock/CLI-level tests (VP-FIELD-ADF-002 dry-run and live-echo axes)** —
  VP-FIELD-ADF-002's dry-run JSON axis
  (`test_bc_3_4_033_dry_run_planned_preview_contains_adf_object_keyed_by_human_name`),
  dry-run TABLE axis (`test_bc_3_4_033_dry_run_table_shows_adf_marker`),
  and live-echo axes (`test_bc_3_4_033_live_edit_json_changed_fields_raw_input_not_adf_object`,
  `test_bc_3_4_033_live_edit_table_shows_adf_marker_not_raw_value`,
  `test_bc_3_3_013_create_table_shows_adf_marker`) exercise the full `issue edit`/`issue create`
  CLI pipeline including the editmeta/createmeta HTTP fetch. They require
  `JiraClient::new_for_test` + `MockServer` and are NOT covered by the proptest/example-based
  strategies above. These axes are NOT no-network unit tests — they are wiremock/CLI-level,
  the same class as VP-FIELD-ADF-003 Axes E/F, Axis G, and Axis H.
- **`cargo-mutants`** on the delta diff — the new `is_adf_field` helper and the
  ADF-conversion branch in `dispatch_field_value` must be added to
  `.cargo/mutants.toml`'s `examine_globs` at F4 (following the F4-obligation
  precedent from `verification-delta-674.md §3`). The `is_adf_field` predicate is
  a prime mutant target: a mutant removing any arm (e.g., dropping the
  `":textarea"` ends_with check, or removing the `"environment"` arm) must be
  killed by VP-FIELD-ADF-001's proptest invariant.

**Kani / cargo-fuzz — JUSTIFIED-SKIP (0-GAP).**

This project has never provisioned Kani or cargo-fuzz (confirmed: no `kani` crate
in `Cargo.toml`, no `fuzz/` directory, no `kani-verifier`). The established
precedent (cycles 002–007, all verification deltas from `verification-delta-398.md`
onward) is that proptest + example-based unit tests + cargo-mutants are the
substitution for formal verification on this codebase's pure-core helpers.

For VP-FIELD-ADF-001/002:
- The correctness claim is a universal quantification over `EditMetaField` inputs —
  exactly the kind of claim proptest's generators capture by generating arbitrary
  `schema.system` and `schema.custom` values and asserting the predicate output.
  A Kani bounded model check would provide no additional coverage: the predicate
  is a simple pattern match with no arithmetic overflow, no array indexing, and
  no unsafe code.
- There is no untrusted deserialization surface being fuzzed: `EditMetaFieldSchema`
  is already deserialized before `is_adf_field` is called.

For VP-FIELD-ADF-003:
- Axes A/B target the extracted pure empty-value decision logic (F4 extraction
  obligation): its sole inputs are a field schema and a value string — a
  deterministic, no-network function whose decision logic is a simple branch
  (empty-or-whitespace check, then edit-vs-create routing). Neither formal
  verification nor fuzzing adds coverage here: no arithmetic overflow, no unsafe
  code, no deserialization surface. **The exact decomposition is F4's choice.**
  The 0-GAP basis is that the empty-value decision logic is concentrated in pure,
  network-free code, not that the surrounding
  `resolve_against_editmeta`/`resolve_against_createmeta` call sites are themselves
  no-network. Axes E/F (dry-run JSON, live-echo), Axis G (platform-create POST-body
  empty-omit), and Axis H (dry-run TABLE sentinel) are wiremock-backed; that level of
  coverage is the project-wide baseline for integration-path claims, not a gap specific
  to VP-003.

**0-GAP statement**: skipping Kani and fuzz introduces NO coverage gap relative to
the BC set, because every correctness claim (BC-3.3.013..015, BC-3.4.033..037,
BC-3.8.019..022) is either (a) a universal property captured by proptest over the
ADF detection predicate, (b) a deterministic example-anchored regression, (c) a
route-specific empty-value unit test, or (d) a caller-level wiremock/CLI integration
test (VP-003 Axes E/F/G/H, VP-002 dry-run JSON + table and live-echo axes). This is a
documented substitution, not an omission.

---

## 4. Verification Properties — Full Definitions

### VP-FIELD-ADF-001 — ADF Detection Predicate: Risk-Symmetric (proptest + example)

**Technique:** proptest + example-based `#[test]`. Both platforms.
**Primary module:** `src/cli/issue/field_resolve.rs::is_adf_field` (typed entry point),
`src/cli/issue/field_resolve.rs::is_adf_schema` (named shared core — see below), and
`src/cli/issue/field_resolve.rs::dispatch_field_value` (ADF branch).
**JSM coverage:** `src/cli/issue/field_resolve.rs::is_adf_field_value` (Value-level
entry point — delegates to the same shared core `is_adf_schema`, not a duplication of
the allowlist). Co-locating `is_adf_field_value` with `is_adf_field` and `is_adf_schema`
in `field_resolve.rs` means `is_adf_schema` remains a module-private `fn` (no
`pub(crate)` needed — no caller outside `field_resolve.rs` calls `is_adf_schema`
directly). `is_adf_field_value`, however, IS called from `src/cli/issue/jsm_create.rs`
(a sibling file in the same module) and MUST be declared at least `pub(super)` or
`pub(crate)`; `is_adf_schema` and `is_adf_field` remain module-private (OBS-3).

**Pins:** BC-3.3.013 (`:textarea` detection on create), BC-3.3.014
(`schema.system` detection on create), BC-3.4.033 (`:textarea` detection on edit),
BC-3.4.034 (`environment` system field), BC-3.4.035 (`description` via `--field`
alone), BC-3.4.037 (`customfield_NNNNN` bypass), BC-3.8.019 (JSM `description`
via `--field`), BC-3.8.020 (JSM `:textarea`).

**Property (risk-symmetric):** A field is ADF-backed — as judged by `is_adf_field`
— IFF its schema satisfies:
- `schema.system.as_deref() == Some("description")`, OR
- `schema.system.as_deref() == Some("environment")`, OR
- `schema.custom.as_deref().map_or(false, |c| c.ends_with(":textarea"))`

The property is TWO-SIDED, covering both the POSITIVE (must fire) and NEGATIVE
(must NOT fire) cases:

**Positive assertions (must fire — any failure = missed ADF field = guaranteed 400):**
- A schema with `system == "description"` (and no `custom`) → `is_adf_field` returns `true`.
- A schema with `system == "environment"` (and no `custom`) → `is_adf_field` returns `true`.
- A schema with `custom == "com.atlassian.jira.plugin.system.customfieldtypes:textarea"` (and no `system`) → `is_adf_field` returns `true`.
- A schema with `custom` that ends with `:textarea` (other prefix) → `is_adf_field` returns `true`.

**Negative regression assertions (must NOT fire — any failure = plain-string field falsely converted to ADF = guaranteed 400):**
- A schema with `custom == "com.atlassian.jira.plugin.system.customfieldtypes:textfield"` → `is_adf_field` returns `false`.
- A schema with `system == "summary"` → `is_adf_field` returns `false`.
- A schema with `type == "string"` and no `system`, no `custom` (unknown string field) → `is_adf_field` returns `false`.
- A schema with `custom` that ends with `:textfield` (any prefix) → `is_adf_field` returns `false`.
- An empty schema (`system: None`, `custom: None`) → `is_adf_field` returns `false`.

**proptest shape:** Generate random `Option<String>` values for `system` and
`custom` fields of `EditMetaFieldSchema`. Assert:
- `prop_is_adf_field_fires_only_on_allowlist`: for any generated schema,
  `is_adf_field` returns `true` IFF the schema matches one of the three allowlist
  conditions above. Use `prop_oneof!` to generate both allowlist members and random
  non-members to get balanced positive/negative coverage.

**Example anchor matrix (one test per concrete case — kills the most common mutants):**

| Input | Expected | BC | Notes |
|-------|----------|-----|-------|
| `system=Some("description"), custom=None` | `true` | BC-3.4.035 | M3 load-bearing |
| `system=Some("environment"), custom=None` | `true` | BC-3.4.034 | O5 behavior flip |
| `custom=Some("…:textarea"), system=None` | `true` | BC-3.4.033 | M4 |
| `custom=Some("…:textfield"), system=None` | `false` | BC-3.4.033 | Regression pin |
| `system=Some("summary"), custom=None` | `false` | — | Regression pin |
| `system=None, custom=None` | `false` | — | Empty schema |

Suggested test names:
- `test_bc_3_4_033_is_adf_field_allowlist_positive_and_negative_anchors` (example matrix)
- `prop_bc_3_4_033_is_adf_field_fires_only_on_allowlist` (proptest)

**Named shared core — `is_adf_schema` (LOW fix — AC-008 single-point-of-truth):**
The three-arm allowlist must live in exactly one place. Define:

```rust
fn is_adf_schema(system: Option<&str>, custom: Option<&str>) -> bool
```

in `src/cli/issue/field_resolve.rs`. This function contains the allowlist exclusively:
`system == Some("description") || system == Some("environment") ||
custom.map_or(false, |c| c.ends_with(":textarea"))`.

`is_adf_field(&EditMetaFieldSchema)` extracts `schema.system.as_deref()` and
`schema.custom.as_deref()` from the typed struct and calls `is_adf_schema`.
`is_adf_field_value(&serde_json::Value)` extracts the equivalent strings via
`value["system"].as_str()` / `value["custom"].as_str()` and calls `is_adf_schema`.
Neither entry point contains the allowlist logic itself. This is not a "thin wrapper"
in the colloquial sense — it is a structured two-level extraction/delegation that
ensures the allowlist is never duplicated. A future allowlist extension is a
one-line change inside `is_adf_schema` only.

**Why `is_adf_field_value` cannot be a literal thin wrapper over `is_adf_field`:**
`is_adf_field` takes `&EditMetaFieldSchema`, whose `field_type` and `schema` are typed
Rust fields (non-Option Strings). The JSM `jira_schema` `serde_json::Value` has no
guaranteed `type` key — it may be absent, null, or any value. A direct delegation
`is_adf_field_value(v) → is_adf_field(deserialize(v))` would require a lossy
deserialization into `EditMetaFieldSchema` that would drop missing keys rather than
treating them as `None`. The named shared core `is_adf_schema(Option<&str>, Option<&str>)`
is the only shape that both entry points can delegate to faithfully. The proptest on
VP-FIELD-ADF-001 is transitively effective for both entry points because both call
`is_adf_schema` for the actual allowlist decision.

**JSM wrapper coverage (Story 2):** `is_adf_field_value(schema: &serde_json::Value)`
accepts the inner `jiraSchema` sub-object as an untyped `serde_json::Value` and
extracts `system`/`custom` before delegating to `is_adf_schema`. VP-FIELD-ADF-001's
proptest is therefore transitively effective for `is_adf_field_value` — both entry
points call the same `is_adf_schema` allowlist core, and any mutant breaking the
allowlist is killed by the proptest regardless of which entry point was called.
VP-FIELD-ADF-001 does NOT directly exercise the `serde_json::Value` extraction step
(`value["system"].as_str()` / `value["custom"].as_str()`) in `is_adf_field_value`
— that extraction path is covered by VP-FIELD-ADF-004 Axis (a)'s example test
(`test_bc_3_8_019_is_adf_field_value_inner_block_no_double_nesting`). See pass-14
L-4 and ADR-0024 Consequences §L-4 for the attribution rationale.

**Why this VP exists:** The primary regression risk for this feature is
OVER-selectivity of the predicate — a bug causing `is_adf_field` to return `true`
for a plain-string field (e.g., `:textfield`, `summary`) silently converts those
fields to ADF, producing a guaranteed 400. The NEGATIVE arm of this VP is
specifically designed to kill mutants that remove the allowlist discriminators
(e.g., a mutant that replaces `ends_with(":textarea")` with `contains("text")`,
which would also match `:textfield`).

**RED proof:**
- Against a mutant replacing `ends_with(":textarea")` with `contains("text")`:
  the `:textfield` negative case (expecting `false`) becomes `true` → the
  example anchor test FAILS RED. ✓
- Against a mutant removing the `system == "environment"` arm entirely:
  the `environment` positive case (expecting `true`) returns `false` → the
  example anchor test FAILS RED. ✓
- Against a mutant replacing the predicate with `return false` (no ADF):
  ALL positive cases fail RED. ✓

---

### VP-FIELD-ADF-002 — Conversion Correctness: Non-Empty Value Produces Valid ADF (proptest + example)

**Technique:** proptest + example-based `#[test]` for core Properties 1–3 (pure `dispatch_field_value`/`text_to_adf` — no network); wiremock/CLI-level for the dry-run and live-echo axes (full `issue edit`/`issue create` pipeline incl. the editmeta/createmeta HTTP fetch).
**Primary module:** `src/cli/issue/field_resolve.rs::dispatch_field_value` (ADF
branch), `src/adf.rs::text_to_adf` (called by the ADF branch).

**Pins:** BC-3.3.013 (`:textarea` conversion on create, non-empty), BC-3.3.014
(`description`/`environment` system field conversion on create), BC-3.4.033
(`:textarea` conversion on edit), BC-3.4.034 (`environment` conversion on edit),
BC-3.4.035 (`description` via `--field` conversion on edit), BC-3.4.037
(`customfield_NNNNN` bypass for `:textarea`).

**Scope clarification (adversarial PASS-1 H-4):** VP-FIELD-ADF-002 is platform-scoped.
BC-3.8.019 and BC-3.8.020 (JSM positive conversion) are owned by VP-FIELD-ADF-004,
because the JSM RESOLUTION LAYER (`jsm_create.rs`) handles ADF detection and
conversion independently — `dispatch_field_value` is not used on the JSM create path.
A mutant removing the ADF conversion branch from the JSM resolution layer would not be
caught by VP-FIELD-ADF-001/002; VP-FIELD-ADF-004 closes that gap.

**Property:** For any non-empty, non-whitespace input string `S`:

1. **Output type:** `dispatch_field_value` with an ADF-backed field and input `S`
   writes `outputs.fields[field_id]` as an OBJECT (not a `Value::String(S)`) — the
   auto-wrap produces an ADF document, never passes the string through unchanged.
2. **ADF structure (non-empty input):** `outputs.fields[field_id]` satisfies
   `value["type"] == "doc"` and `value["version"] == 1` and
   `value["content"].is_array()`. For any non-empty/non-whitespace input `S`,
   `outputs.fields[field_id]["content"]` is a NON-EMPTY array (length ≥ 1)
   containing ≥1 node of type `"paragraph"`, and that paragraph node contains ≥1
   node of type `"text"`. The empty ADF doc
   `{"type":"doc","version":1,"content":[]}` is NEVER written to
   `outputs.fields[field_id]` by `dispatch_field_value` for a non-empty input — that
   form is produced exclusively by the edit-clear pre-check in
   `resolve_against_editmeta` (BC-3.4.036). A mutant that writes the empty clear-doc
   for all ADF-backed inputs fails this clause: `content.len() == 0` violates the ≥1
   paragraph requirement.
   (PASS-7 strengthening — the old `is_array()` check alone was insufficient: an
   empty array IS an array, and INV-1 is vacuous over empty content.)
3. **INV-1 (no raw newline in text nodes, BC-7.2.011):** For any ADF object written
   to `outputs.fields[field_id]` by `dispatch_field_value` over any `S`, NO `text`
   node anywhere in the `content` tree contains a raw `\n` or `\r` character in its
   `text` attribute. Multi-line values produce `hardBreak` nodes between lines, not
   raw newlines in a single `text` node.

**proptest shape:**
- `prop_bc_3_4_033_dispatch_field_value_adf_backed_returns_adf_object`: for a
  generator producing non-empty strings `S` (arbitrary printable text, including
  multi-line) and a fixed ADF-backed `EditMetaField` (`:textarea` schema), assert
  properties 1, 2, and 3 above hold on `outputs.fields[field_id]`.
- Use a `Strategy` that generates both single-line and multi-line `S` values to
  exercise the `hardBreak` path.

**Example anchors:**
- Single-line: `S = "Hello world"` → value is an ADF doc with exactly one
  paragraph node, one text node, no hardBreak.
- Multi-line: `S = "Line one\nLine two"` → value is an ADF doc; the text nodes
  contain NO raw `\n`; a `hardBreak` node separates the lines. Verifies INV-1.
- `description` via `--field` alone: `S = "A description"`, field schema
  `system=Some("description")` → same ADF doc shape.
- `customfield_NNNNN` bypass (M4): literal-id field with `:textarea` schema →
  ADF doc returned. Regression pin for BC-3.4.037.

Suggested names:
- `test_bc_3_4_033_dispatch_field_value_produces_valid_adf_doc` (example matrix)
- `prop_bc_3_4_033_dispatch_field_value_adf_backed_no_raw_newlines_inv1` (proptest)

**Dry-run axis (obs-2 fold-in — authoritative VP definition for BC-3.4.033 dry-run postcondition):**
For `--dry-run` calls (platform edit path) with a non-empty ADF-backed field:
- `planned_preview[human_name]` (keyed by display name, NOT `field_id`) is the wire ADF
  `serde_json::Value` object (the value returned by `text_to_adf(S)`, i.e., a full ADF doc
  with `type: "doc"`, `version: 1`, and non-empty `content` array), NOT a simplified display
  string.
- The display-string insert lives in `dispatch_field_value`'s string/text arm; for ADF-backed
  fields, the ADF object is written to `planned_preview` in the ADF branch instead of a
  display string.
- RED contribution: against a mutant writing a display string to `planned_preview` instead
  of the ADF object, this axis fails RED — `planned_preview[human_name]` is a String, not
  the expected ADF doc object. ✓

Suggested name: `test_bc_3_4_033_dry_run_planned_preview_contains_adf_object_keyed_by_human_name`

**Dry-run table-mode axis (M-1 — FIRM F4 AC; `field_markers` side-channel is the authoritative sentinel source; see §5 item 17):**
For `--dry-run` calls (platform edit path) with a non-empty ADF-backed field, the
DRY-RUN TABLE rendering (the `planned_preview` row in the printed table) MUST show
`(adf)` as the cell value — NOT the raw user-supplied string and NOT the ADF object.
The marker is derived from `field_markers[human_name]` by the `edit.rs` dry-run
table-emit loop, NOT inferred from `planned_preview` content-shape (M-3 anti-pattern:
inspecting whether `planned_preview[human_name]["content"]` is non-empty to choose
the marker is REJECTED; a future ADF doc with an empty `content` array for
non-clear reasons would be misclassified).
This axis is a DISTINCT consult site from the dry-run JSON `planned_preview` axis
above — the JSON axis pins the `planned_preview[human_name]` VALUE (the ADF object);
this axis pins the TABLE CELL DISPLAY (the `(adf)` marker rendered from `field_markers`).
A mutant that removes `field_markers[human_name]` population in `dispatch_field_value`'s
ADF branch on the dry-run path, or that causes the dry-run table-emit loop to bypass
`field_markers` and display the ADF object directly, fails RED here but would NOT be
caught by the JSON dry-run axis alone.
- RED contribution: against a mutant that renders the raw ADF object (or the raw value) in
  the table cell during `--dry-run` instead of the `(adf)` sentinel from `field_markers`:
  the test asserts the cell text is `"(adf)"`, not any other string → FAILS RED. ✓
- Anti-pattern kill: against a mutant that derives the sentinel by inspecting
  `planned_preview[human_name]["content"].is_empty()` and rendering `(adf)` only when
  non-empty — such a mutant may appear to pass for the non-empty case but fails as soon as
  a non-clear ADF doc has an empty `content` array. This axis pins the mechanism
  (`field_markers`, not `planned_preview` inspection) as the authoritative source.

Suggested name: `test_bc_3_4_033_dry_run_table_shows_adf_marker`

**Live echo axis (PASS-9 F-1 addition — MUST F4 AC; mirrors VP-398-002 lossless-machine-channel discipline):**
For a LIVE (non-dry-run) `issue edit` call with a non-empty ADF-backed field:
- **JSON channel** (`--output json`): `changed_fields[human_name]` carries the **RAW user-supplied
  input string** (the `spec.value` as typed by the caller), NOT the serialized ADF object, NOT the
  `(adf)` marker. This is the issue #398 lossless-machine-channel invariant applied to `--field`
  ADF fields — the JSON channel must be lossless, enabling programmatic inspection of what was
  actually submitted.
- **Table/human channel**: the row for the field shows `(adf)` as the displayed value — NOT the
  ADF object, NOT the raw string. The marker communicates that the value was treated as ADF; the
  full content is intentionally omitted for scannability.
These two channels intentionally differ (same asymmetry as `description` via VP-398-002): do NOT
unify them. A future refactor that writes `(adf)` to `changed_fields` in JSON mode, or the raw
string to the table, is a defect that these tests must catch.

**Realizing mechanism (F-1 marker side-channel — REQUIRED F4 AC; see §5 item 9):**
The `(adf)` table marker is produced by a dedicated `field_markers: BTreeMap<String, &'static str>`
side-channel on `FieldResolutionOutputs`, keyed by `human_name`. `dispatch_field_value`'s ADF
branch populates `field_markers[human_name] = "(adf)"` for a non-empty bare ADF-backed field.
The `edit.rs` table-emit loop reads `field_markers[human_name]` first; if a marker is present it
renders the marker rather than the raw value from `changed_fields`. `changed_fields` is unchanged
(raw input, JSON channel lossless).
**F-2 note for product-owner (BC-3.4.035):** the emit loop MUST consult `field_markers` BEFORE
the legacy `if field == "description" { "(updated)" }` hard-code — `--field description=VALUE`
(ADF path via `field_markers`) renders `(adf)` in the table, NOT `(updated)`. The `(updated)`
hard-code fires ONLY for the dedicated `--description` FLAG path, which does not populate
`field_markers`. JSON channel carries the raw input in both cases (no BC change needed for the
JSON channel).

**Create-path `(adf)` table echo (BC-3.3.013/014 — no `changed_fields` key):** On `issue create`,
the table shows `(adf)` for a non-empty ADF-backed field (BC-3.3.013/014). Create has no
`changed_fields` key per the established project convention (analogous to `description` and all
other create-path fields). The table `(adf)` marker on the create path is pinned by the
create-path test below — the lossless-raw-input obligation applies only on the edit path
(where `changed_fields` exists).

Suggested test names:
- `test_bc_3_4_033_live_edit_json_changed_fields_raw_input_not_adf_object` (JSON channel — FIRM MUST F4 AC)
- `test_bc_3_4_033_live_edit_table_shows_adf_marker_not_raw_value` (table channel)
- `test_bc_3_3_013_create_table_shows_adf_marker` (create-path table `(adf)` marker)

**RED contribution (live echo axis):**
- Against a mutant writing the serialized ADF object (e.g., `"{\"type\":\"doc\",…}"`) as
  `changed_fields[human_name]` instead of the raw input string: the JSON-channel test asserts
  `changed_fields[human_name] == "Hello world"` but receives the ADF object string → FAILS RED. ✓
- Against a mutant writing the `(adf)` marker string to `changed_fields` in JSON mode:
  `changed_fields[human_name]` is `"(adf)"`, not the raw input → FAILS RED. ✓
- Against a mutant rendering the raw value in the table instead of the `(adf)` marker: the
  table-channel test asserts `(adf)` as the displayed cell, but sees the raw string → FAILS RED. ✓
- Against a mutant omitting the `(adf)` marker on the create-path table: the create-path test
  asserts the `(adf)` cell, finds it absent or replaced with the raw value → FAILS RED. ✓

**Why this VP exists:** This VP pins the POSITIVE conversion path — that calling
`dispatch_field_value` on an ADF-backed field with a non-empty value ACTUALLY
produces an ADF object and does not silently fall through to `Value::String`.
A mutant removing the `if is_adf_field(...)` branch in `dispatch_field_value` (so
the function always returns `Value::String(value)`) would pass the predicate tests
(VP-FIELD-ADF-001) but be caught here (the returned value is a `String`, failing
property 1). INV-1 (no raw newline) is pinned here because `text_to_adf` is the
one call that must produce `hardBreak` for multi-line values; if a future refactor
incorrectly uses a direct `Value::String` or a `text` node with embedded newlines,
this VP catches it.

**RED proof:**
- Against a mutant removing the ADF branch from `dispatch_field_value`:
  `outputs.fields[field_id]` is `Value::String("Hello world")`, failing property 1. ✓
- Against a mutant calling `text_to_adf` but ignoring INV-1 for multi-line (writing
  a `text` node with an embedded `\n` into `outputs.fields[field_id]`): the INV-1
  proptest assertion fails RED. ✓
- Against a mutant writing `json!({"type":"doc","version":1,"content":[]})` to
  `outputs.fields[field_id]` for all ADF-backed fields (empty doc regardless of
  content): Property 2's non-empty content clause fails — `content` has length 0,
  failing the ≥1 `paragraph` node requirement. (The old `is_array()` check alone
  would NOT catch this mutant: an empty array IS an array. INV-1 is also vacuous
  over empty content. The PASS-7-strengthened Property 2 is what kills this mutant
  class.) ✓

---

### VP-FIELD-ADF-003 — Empty-Value Invariant: No Empty Text Node; Path-Specific Semantics (unit tests)

**Technique:** unit `#[test]` for Axes A/B (pure no-network code — F4 extraction
obligation; exact helper shape/count/signatures are F4's choice — no network,
controlled structs); unit `#[test]` for Axis C (JSM resolution layer in
`jsm_create.rs`, DQ-6-gated — no network, controlled structs; the resolution layer
receives pre-fetched metadata as a parameter and is itself network-free); unit
`#[test]` for Axis D (pure no-network gate code — F4 extraction obligation — no
network, controlled structs; not DQ-6-gated); wiremock/CLI-level for Axes E/F
(dry-run JSON, live-echo — require `JiraClient::new_for_test` + `MockServer` because
they exercise the full editmeta HTTP fetch pipeline), Axis G (platform-create
POST-body empty-omit — require `JiraClient::new_for_test` + `MockServer`; see §4
VP-003 Axis G and §5 item 16), and Axis H (dry-run TABLE sentinel from `field_markers`
— require `JiraClient::new_for_test` + `MockServer`; see §4 VP-003 Axis H and §5
item 17).
**Primary modules:**
- Axes A/B (platform edit + create empty-value decision): pure, network-free code
  extracted from `src/cli/issue/field_resolve.rs` (specifically from
  `resolve_against_editmeta` and `resolve_against_createmeta`) — **F4 extraction
  obligation**. `resolve_against_editmeta` and `resolve_against_createmeta` both
  issue mandatory HTTP calls before reaching the empty-value branch; F4 must extract
  the post-fetch empty-value decision into pure code so Axes A/B can be unit-tested
  without a mock server. The extracted code receives the already-fetched schema and
  value, determines whether the field is ADF-backed and the value is
  empty/whitespace, and routes to the path-specific response (clear-doc for edit,
  omit for create). **The exact helper shape, count, and signatures are F4's choice.**
  (An illustrative, non-binding decomposition might factor this into a helper that
  takes a schema and value and returns a clear-doc/omit/convert signal —
  this is illustrative only; F4 chooses the actual decomposition.)
- Axis C (JSM create empty-value decision): resolution layer in
  `src/cli/issue/jsm_create.rs` (exact function TBD at F4, DQ-6-gated; the
  empty-field is omitted before `JsmRequestBuilder::build()` is called —
  it never reaches the pure assembler)
- Axis D (bare-form guard — `kind.is_none()` gate on the ADF empty pre-check):
  pure, network-free code extracted from `src/cli/issue/field_resolve.rs` —
  **F4 extraction obligation**. `resolve_against_editmeta` (~:707) and
  `resolve_against_createmeta` (~:603-633) both gate the ADF empty pre-check behind
  `spec.kind.is_none()`, but those functions also issue mandatory HTTP calls BEFORE
  the gate is reached. The Axes A/B extracted code (above) has no `kind` input and
  cannot test the `kind.is_none()` gate — F4 must separately extract the gate
  condition (`kind.is_none() && is_adf_schema(system, custom) &&
  value.trim().is_empty()`) into pure, network-free code. **The exact decomposition
  is F4's choice.** The JSM resolution layer in `jsm_create.rs` applies the same
  gate; F4 uses consistent pure gate code on both paths (e.g., by accepting
  `jira_schema["system"].as_str()` / `jira_schema["custom"].as_str()` extracts for
  the JSM call site). Both the platform and JSM Axis D sub-cases are **NOT
  DQ-6-gated** (the gate logic is pure; no resolution-layer test-harness
  infrastructure is required); authorable as soon as the gate code is extracted at
  F4 (independent of the DQ-6 type/signature decision).
- Axes E/F (dry-run JSON, live-echo): wiremock-backed integration tests; NOT
  no-network unit tests.
- Axes G/H (platform-create POST-body empty-omit and dry-run TABLE sentinel):
  wiremock-backed integration tests; NOT no-network unit tests.

**Pins:** BC-3.3.015 (create-path omit for empty ADF field), BC-3.4.036 (edit-path
clear-doc for empty ADF field), BC-3.8.021 (JSM create-path omit for empty ADF
field), BC-3.3.014 (referenced via BC-3.3.015 empty-guard dependency), BC-3.4.035
(referenced via BC-3.4.036 empty-guard dependency).

**Property — EIGHT test axes (one per path, plus bare-form guard, dry-run edit-clear JSON, dry-run edit-clear TABLE, live-echo edit-clear, and platform-create POST-body empty-omit):**

**Axis A — Platform edit, empty value → clear-doc (BC-3.4.036):**
- For an ADF-backed field (e.g. `system = Some("description")`) with an empty
  string input on the EDIT path: the extracted pure code resolves to the
  clear-doc `{"type":"doc","version":1,"content":[]}` — the field is NOT omitted
  and the value is NOT forwarded to `text_to_adf`.
- A whitespace-only value (e.g. `"   "`) is treated identically to empty — the
  same clear-doc result (regression pin: whitespace must trigger the guard, not
  reach `text_to_adf`).
- A non-empty value (e.g. `"hello"`) does NOT trigger the clear-doc path — it
  routes to the dispatch/convert variant instead (regression pin). `resolve_against_editmeta`
  is the ultimate caller that writes the clear-doc to `fields[field_id]`; those are
  its caller semantics and NOT the test target for Axis A (Axis A targets the
  extracted pure code, not `resolve_against_editmeta` itself).

**Axis B — Platform create, empty value → field omitted (BC-3.3.015):**
- For an ADF-backed field with an empty string input on the CREATE path: the
  extracted pure code resolves to OMIT — the field is excluded from the POST body
  entirely.
- A whitespace-only value (e.g. `"   "`) is treated identically to empty — same
  omit result (regression pin: whitespace must trigger the guard).
- A non-empty value (e.g. `"hello"`) does NOT trigger the omit path — it routes to
  the dispatch/convert variant instead (regression pin). `resolve_against_createmeta`
  is the ultimate caller that skips the `fields` insert on omit; those are its caller
  semantics and NOT the test target for Axis B.
- Asymmetry pin (edit/create discriminator): the SAME empty value on the EDIT path
  produces the clear-doc (Axis A), not omit — the path-specific distinction is
  encoded in the extracted pure code. A mutant that ignores the edit/create distinction
  and always routes to one behavior is caught by Axes A and B together.

**Axis C — JSM create, empty value → field omitted at resolution layer, `isAdfRequest` NOT accumulated (BC-3.8.021, DQ-6-gated):**
- The resolution layer in `jsm_create.rs` (exact function TBD per DQ-6) — given an
  ADF-backed extra field (`jira_schema.system == "description"`) and `spec.value = ""`
  — does NOT pass the field into `requestFieldValues`; the empty ADF-backed field is
  omitted BEFORE `JsmRequestBuilder::build()` is called.
- `isAdfRequest` is NOT accumulated for the omitted field.
- A non-empty ADF-backed extra field DOES pass the field through and DOES cause
  `isAdfRequest = true` accumulation (regression: BC-3.8.022 accumulation rule).
- **This axis is DQ-6-gated** — the test module and constructor shape depend on the F4
  layer decision. The test targets the resolution layer (`jsm_create.rs`), not
  `build()` directly.

**Axis D — Empty-guard fires ONLY for bare form (`kind.is_none()`); hinted-kind values bypass it — platform and JSM paths (Pins: BC-3.4.036, BC-3.3.015, BC-3.8.021; Context-only: BC-3.4.033, BC-3.8.019; H-3; M-2 option-ii ruling):**
*(M-2 option-ii ruling, adversarial pass 12: BC-3.4.033 and BC-3.8.019 are cited as
CONTEXT — their `kind.is_none()` precondition is the stated basis for this axis, but
these BCs are fully owned by VP-FIELD-ADF-001/002/004 and carry no VP-FIELD-ADF-003
bidirectional pin. The §2 registration table for VP-FIELD-ADF-003 is UNCHANGED; the
BCs themselves need no VP-003 citation added. No product-owner BC edit is required
for this ruling.)*

**What Axis D verifies (mechanism-level):** F4 must extract the
`kind.is_none() && is_adf_schema(system, custom) && value.trim().is_empty()` gate
condition into pure, network-free code so that Axis D is authorable as a unit test
rather than requiring a MockServer. **The exact decomposition is F4's choice.** The
tests must call into that extracted pure gate code directly (not through
`resolve_against_editmeta` or `resolve_against_createmeta`, which both issue
mandatory HTTP calls before the gate is reached). The Axes A/B extracted code has no
`kind` input and cannot test this gate — Axis D targets the gate condition separately.

**Assertions (targeting the extracted pure gate code directly):**
- ADF-backed field (e.g., `system = Some("description")`), bare form (`kind` absent/unset), empty value `""` → guard APPLIES (edit: clear-doc; create: omit)
- ADF-backed field, bare form, whitespace-only value → guard APPLIES (same as empty — regression pin)
- ADF-backed field, hinted form (e.g., an `:option` hint kind set), empty value `""` → guard does NOT apply; value routes to the hint-composer path instead
- ADF-backed field, hinted form with an `:id` hint kind, empty value `""` → guard does NOT apply
- ADF-backed field, bare form, non-empty value (e.g., `"hello"`) → guard does NOT apply; value routes to ADF conversion, not the empty pre-check
- Non-ADF field (e.g., `system = Some("summary")`), bare form, empty value → guard does NOT apply even when bare + empty (the `is_adf_schema` condition is false)
- ADF `:textarea` custom field (e.g., `custom = Some("com.atlassian.jira.plugin.system.customfieldtypes:textarea")`), bare form, empty value → guard APPLIES
- Non-ADF `:textfield` custom field, bare form, empty value → guard does NOT apply

**Asymmetry pin (interaction with empty-value decision):** When the gate applies (bare + ADF-backed + empty/whitespace), the path-specific pure code determines the edit/create outcome (clear-doc vs omit). Axis D tests ONLY the `kind.is_none()` gate; the clear-doc/omit distinction is covered by Axes A/B. A mutant that removes the `kind.is_none()` condition from the gate code causes hinted-kind empty values to be handled by the ADF guard instead of the hint composer — Axis D kills this mutant.

**JSM path sub-case (H-3 — added):** On the JSM create path, the ADF empty pre-check in the RESOLUTION LAYER is similarly gated by the bare-form condition (`kind.is_none()`). F4 must apply consistent pure gate code for JSM inputs as well (e.g., by accepting `jira_schema["system"].as_str()` / `jira_schema["custom"].as_str()` extracts from the JSM `serde_json::Value`). For a hinted extra field on the JSM path, the guard does NOT fire — the value routes to the hint-composer's string path instead. The JSM Axis D sub-case (`test_adf_empty_guard_fires_only_on_bare_form_not_hinted_jsm`) tests the extracted pure gate code directly with JSM-style inputs and is **NOT DQ-6-gated** (the gate logic is pure; no resolution-layer test-harness infrastructure is required).

Suggested test name additions:
- `test_adf_empty_guard_fires_only_on_bare_form_not_hinted_platform` (Axis D, platform sub-cases)
- `test_adf_empty_guard_fires_only_on_bare_form_not_hinted_jsm` (Axis D, JSM sub-case — new H-3 test)

**Axis E — Dry-run axis: edit-clear case written to `planned_preview` (obs-2 fold-in — authoritative VP definition for BC-3.4.036 dry-run postcondition):**
For `--dry-run` calls (platform edit path) with an empty/whitespace ADF-backed field:
- `planned_preview[human_name]` (keyed by display name, NOT `field_id`) is the clear-doc
  `{"type":"doc","version":1,"content":[]}`, NOT absent and NOT a display string.
- This axis pins BC-3.4.036's dry-run postcondition. The `planned_preview` entry confirms
  that the edit-clear behavior is observable in dry-run mode without issuing any HTTP call.
- RED contribution: against a mutant that does NOT write the clear-doc to `planned_preview`
  for the edit-clear case: `planned_preview[human_name]` is absent or is a display string,
  not the clear-doc object. Axis E fails RED — expected clear-doc object, got absent/wrong
  value. ✓

Suggested name: `test_bc_3_4_036_dry_run_planned_preview_contains_clear_doc_keyed_by_human_name`

**Axis F — Live echo axis: edit-clear path (PASS-9 F-1 addition; BC-3.4.036 live-echo postcondition — MUST F4 AC):**
For a LIVE (non-dry-run) `issue edit` call with an empty/whitespace ADF-backed field (the clear path):
- **JSON channel** (`--output json`): `changed_fields[human_name]` carries the **RAW user-supplied
  input string** (the empty or whitespace string as typed, e.g., `""` or `"   "`), NOT the
  serialized empty ADF doc (`{"type":"doc","version":1,"content":[]}`), NOT the `(adf-clear)`
  marker. The JSON channel is always lossless — it echoes what the user typed.
- **Table/human channel**: the row for the field shows `(adf-clear)` as the displayed value —
  NOT the ADF doc object, NOT the raw empty string. The marker communicates that a field-clear was
  performed without exposing a confusing empty-string cell.
This is the same issue #398 asymmetry applied to the ADF-clear path: machine channel is lossless
(raw empty input), human channel is scannable (marker). Do NOT unify.

**Realizing mechanism (F-1 marker side-channel — REQUIRED F4 AC; see §5 item 9):**
The `(adf-clear)` table marker is produced by the same `field_markers: BTreeMap<String, &'static str>`
side-channel on `FieldResolutionOutputs`, keyed by `human_name`. `resolve_against_editmeta`'s
empty-clear pre-check populates `field_markers[human_name] = "(adf-clear)"` for an
empty/whitespace bare ADF-backed field on the edit path. `changed_fields[human_name]` holds the
raw empty/whitespace input string (JSON channel lossless). The emit loop consults `field_markers`
before any legacy hard-codes; see §5 item 9 for the full priority rule.

Suggested name: `test_bc_3_4_036_live_edit_json_changed_fields_raw_empty_input_not_clear_doc`

**RED contribution (Axis F):**
- Against a mutant writing the serialized empty ADF doc to `changed_fields` (e.g., the JSON
  string `"{\"type\":\"doc\",…}"`) instead of the raw input: the JSON-channel test asserts
  `changed_fields[human_name] == ""` (or the whitespace string), but receives the ADF doc
  string → FAILS RED. ✓
- Against a mutant writing the `(adf-clear)` marker to `changed_fields` in JSON mode:
  `changed_fields[human_name]` is `"(adf-clear)"`, not the raw input → FAILS RED. ✓
- Against a mutant rendering the raw empty string in the table instead of the `(adf-clear)`
  marker: the table-channel test asserts `(adf-clear)` as the displayed cell, but sees `""` →
  FAILS RED. ✓

Suggested test names:
- `test_bc_3_4_036_edit_empty_adf_field_resolves_to_clear_doc` (Axis A — named for the verified behavior, not a helper symbol)
- `test_bc_3_3_015_create_empty_adf_field_omitted` (Axis B — named for the verified behavior)
- `test_bc_3_8_021_jsm_resolution_empty_adf_field_omitted_and_flag_not_accumulated` (Axis C)
- `test_adf_empty_guard_fires_only_on_bare_form_not_hinted_platform` (Axis D, platform sub-cases)
- `test_adf_empty_guard_fires_only_on_bare_form_not_hinted_jsm` (Axis D, JSM sub-case)
- `test_bc_3_4_036_dry_run_planned_preview_contains_clear_doc_keyed_by_human_name` (Axis E)
- `test_bc_3_4_036_live_edit_json_changed_fields_raw_empty_input_not_clear_doc` (Axis F)
- `test_bc_3_3_015_create_empty_adf_field_omitted_from_post_body` (Axis G — wiremock/CLI)
- `test_bc_3_4_036_dry_run_table_shows_adf_clear_sentinel_from_field_markers` (Axis H — dry-run table, `field_markers` source; see §5 item 17)

**Axis G — Platform create, empty value → field OMITTED from constructed POST `fields` map (wiremock/CLI-level; caller-level complement to Axis B; BC-3.3.015):**
- `resolve_against_createmeta` is driven with a wiremock-stubbed createmeta response
  containing an ADF-backed field (e.g. `system = "environment"` or a `:textarea` custom
  field), and `--field <NAME>=` (empty value). The caller-level `fields` map forwarded
  to `create_issue` MUST NOT contain any key for the ADF-backed field — the field is
  omitted from the POST body entirely.
- **Why Axis B alone is insufficient:** Axis B targets the extracted pure empty-value
  decision code, which returns an "omit" signal. Axis B explicitly disclaims
  `resolve_against_createmeta`'s caller-level `fields`-map omission as "NOT the test
  target." A mutant in `resolve_against_createmeta` that ignores the omit signal —
  e.g., inserts `Value::String("")` or `{"type":"doc","version":1,"content":[]}` for
  an empty ADF-backed field regardless of the omit signal — would pass Axis B (which
  never touches `resolve_against_createmeta`) but be caught here. This is the same
  regression class as JRACLOUD-79318 (empty text node → 400) on the create path.
- **Test mechanism:** `JiraClient::new_for_test` + `MockServer` — requires a wiremock
  stub for `GET .../createmeta/{proj}/issuetypes/{itid}` returning a field entry with
  an ADF-backed schema (`"schema": {"type":"string","system":"environment"}` or
  `"schema": {"type":"string","custom":"…:textarea"}`). Follows the same mock-server
  pattern as item 10's
  `test_bc_3_3_013_014_createmeta_adaptation_preserves_system_custom_for_adf_detection`.
  NOT a no-network unit test.
- **Asymmetry pin:** the SAME empty value on the EDIT path produces the clear-doc
  (Axes A/E), not omit — Axis G verifies the create-specific omit at the caller level.
  A mutant that unifies create-empty and edit-empty to always produce the clear-doc
  would be caught by both Axis B (at the pure decision level) and Axis G (at the
  caller level).
- **RED proof:** Against a mutant in `resolve_against_createmeta` that inserts
  `Value::String("")` instead of skipping the `fields` insert for an empty ADF-backed
  field: the wiremock test observes the intercepted POST body and finds
  `fields["<field_id>"] == Value::String("")`, not absent → FAILS RED. ✓ Against a
  mutant that inserts the clear-doc `{"type":"doc","version":1,"content":[]}` instead
  of omitting: `fields["<field_id>"]` is present and non-null → FAILS RED. ✓

**Axis H — Dry-run table-mode axis: edit-clear sentinel `(adf-clear)` rendered from `field_markers` (M-1 — FIRM F4 AC; BC-3.4.036 dry-run TABLE postcondition; see §5 item 17):**
For `--dry-run` calls (platform edit path) with an empty/whitespace ADF-backed field,
the DRY-RUN TABLE rendering MUST show `(adf-clear)` as the cell value — NOT the raw
empty/whitespace string and NOT the clear-doc ADF object. The marker is derived from
`field_markers[human_name]` (populated by `resolve_against_editmeta`'s empty-clear
pre-check: `field_markers.insert(human_name, "(adf-clear)")`), NOT inferred from
`planned_preview` content-shape (M-3 anti-pattern rejection: checking
`planned_preview[human_name]["content"].is_empty()` to decide between `(adf-clear)`
and `(adf)` is REJECTED — `field_markers` is the authoritative source; see §5 item 9).
This axis is a DISTINCT consult site from Axis E (dry-run JSON `planned_preview`):
Axis E pins the `planned_preview[human_name]` VALUE (the clear-doc
`{"type":"doc","version":1,"content":[]}`); Axis H pins the TABLE CELL DISPLAY (the
`(adf-clear)` marker rendered from `field_markers`).
A mutant that removes `field_markers[human_name]` population in
`resolve_against_editmeta`'s empty-clear pre-check on the dry-run path, or that causes
the dry-run table-emit loop to bypass `field_markers` and inspect `planned_preview`
content instead, fails RED here but would NOT be caught by Axis E alone.
- Mechanism (REQUIRED): `field_markers[human_name]` is populated by
  `resolve_against_editmeta`'s empty-clear pre-check on the dry-run path (the same
  platform resolution function executes during dry-run as on the live path). The
  `edit.rs` dry-run table-emit loop reads `field_markers[human_name]` before any
  legacy hard-code and renders the marker.
- RED contribution: against a mutant that inspects `planned_preview[human_name]["content"]`
  and renders `(adf-clear)` only when the array is empty (M-3 anti-pattern) instead of
  reading from `field_markers`: if the marker is populated in `field_markers` but a non-clear
  ADF doc happens to have an empty `content` array, the mutant yields the wrong marker.
  The test directly asserts `(adf-clear)` is shown for the empty-value edit-clear case. ✓
- RED contribution: against a mutant that skips `field_markers` population in
  `resolve_against_editmeta` on the dry-run path (treating dry-run as a non-populating
  path): `field_markers[human_name]` is absent; the dry-run table-emit loop falls through
  and renders the raw empty/whitespace string instead of `(adf-clear)`. Axis H fails RED. ✓

Suggested name: `test_bc_3_4_036_dry_run_table_shows_adf_clear_sentinel_from_field_markers`

**Why this VP exists (JRACLOUD-79318 landmine):** `text_to_adf("")` emits
`{"type":"text","text":""}` — Jira rejects this with a 400. The empty-value
pre-check MUST intercept before `text_to_adf` is called. Without this VP, a mutant
that removes the empty-value guard (or that moves the guard below the `text_to_adf`
call) would produce empty text nodes, which are invisible to VP-FIELD-ADF-001/002
(those only exercise the non-empty path). This VP additionally pins the edit-vs-create
ASYMMETRY (clear-doc vs omit) — a mutant that unifies both paths to either behavior
would be caught by the axis that should produce the other behavior.

**RED proof:**
- Against a mutant removing the empty check from the extracted pure code (so it
  always routes to the dispatch/convert path regardless of empty input): an empty
  bare ADF-backed field on the EDIT path does NOT produce the clear-doc — the empty
  value is forwarded to `text_to_adf`, which emits an empty text-node ADF structure
  (JRACLOUD-79318 400). Axis A fails RED. ✓
- Against a mutant that always produces the edit-path clear-doc outcome for BOTH
  edit and create on empty input (ignoring the edit/create distinction): an empty
  bare ADF-backed field on the CREATE path produces the clear-doc value instead of
  being omitted. Axis B fails RED (expected omit, got clear-doc). ✓
- Against a mutant that always produces the create-path omit outcome for BOTH
  edit and create on empty input (ignoring the edit/create distinction): an empty
  bare ADF-backed field on the EDIT path is omitted instead of getting the clear-doc.
  Axis A fails RED (expected clear-doc, got omit). ✓
- Against a mutant treating whitespace-only as non-empty in the extracted pure code:
  a whitespace-only bare ADF-backed field on the edit path routes to the
  dispatch/convert variant instead of the clear-doc. Axis A fails RED on the
  whitespace sub-case. ✓
- Against a mutant that sets `isAdfRequest = true` even for an omitted empty
  extra field: Axis C fails RED (expected flag NOT set, got `true`). ✓
- Against a mutant removing the `kind.is_none()` condition from the extracted gate
  code (so the guard fires even when a hint kind is set): a hinted empty ADF-backed
  field (e.g., using an `:option` hint) triggers the clear-doc/omit path instead of
  routing to the hint-composer path. Axis D (platform sub-case) fails RED —
  expected guard NOT applying for a hinted kind, got guard applying. ✓
- Against a mutant removing the `is_adf_schema` check from the extracted gate code
  (so the guard fires for ANY field when bare + empty): a bare empty non-ADF field
  (e.g., `system = Some("summary")`) triggers the clear-doc/omit path. The
  non-ADF-field regression pin fails RED. ✓
- Against a mutant removing the `value.trim().is_empty()` check from the extracted
  gate code (so it fires for non-empty bare values on ADF-backed fields): a bare
  non-empty ADF-backed field (e.g., value `"hello"`) triggers the clear-doc/omit
  path instead of routing to ADF conversion. The non-empty regression pin fails
  RED. ✓
- Against a mutant applying the JSM resolution-layer ADF empty check without the
  `kind.is_none()` gate: a hinted empty ADF-backed JSM extra field triggers the omit
  path instead of routing to the hint-composer's string path. Axis D JSM sub-case
  fails RED — expected guard NOT firing for a hinted kind, got guard firing. ✓
- Against a mutant that does NOT populate `field_markers[human_name]` for the
  edit-clear case on the dry-run path (or that populates it on the live path only):
  the dry-run table-emit loop finds no `field_markers` entry and falls through to the
  raw empty/whitespace value or the ADF object. Axis H fails RED — expected
  `"(adf-clear)"` table cell, got raw string or ADF object. ✓
- Against a mutant that infers the `(adf-clear)` sentinel by inspecting
  `planned_preview[human_name]["content"].is_empty()` instead of reading from
  `field_markers` (M-3 anti-pattern): the test directly asserts the cell is
  `"(adf-clear)"` regardless of inspection path; any implementation that skips
  `field_markers` and uses content-shape inspection fails when the content-shape
  heuristic misfires. Axis H kills the M-3 anti-pattern mutant. ✓

---

### VP-FIELD-ADF-004 — JSM Build-Path: Detection, Conversion, Flag Accumulation, and Empty-Omit (unit tests)

**Technique:** unit `#[test]` (no network, no wiremock). Axis (a) targets
`is_adf_field_value` directly with value-constructor inputs and can be authored now.
Axes (b)–(e) target the RESOLUTION LAYER (ADF detection, conversion, and the
metadata-unavailable `warning:` emission belong in the effectful layer that has
client/metadata access — not in the pure `build()` assembler); exact test module
and constructor shape are gated on the DQ-6 resolution (see DQ-6 gate below).
Axis (f) [resolution-layer, DQ-6-harness-gated] targets the unknown-`field_id`
pass-through path in the resolution layer (I-1 regression pin — field_id absent
from a successfully-fetched RT field list falls through verbatim with no warning
and no ADF conversion); it shares the same DQ-6 test-harness dependency as
Axes (b)–(e) and is therefore gated alongside them. Axis (g) [pure `build()`,
sub-case 1 authorable now / currently RED] targets `JsmRequestBuilder::build()`'s
EC-3.8.019-4 assembly-order constraint directly — no network, no `RequestTypeField`
metadata, authorable independently of the DQ-6 decision.
**Primary module:** `src/cli/issue/field_resolve.rs::is_adf_field_value` (shared
detection wrapper — Axis a); the RESOLUTION LAYER (`jsm_create.rs`, exact function
TBD per DQ-6 option a/b) for Axes (b)–(f). Axis (g) targets
`src/api/jsm/requests.rs::JsmRequestBuilder::build` directly — pure, no network,
authorable now. ADF detection, `text_to_adf` conversion, and the
metadata-unavailable `warning:` emission all belong in the resolution layer — the
effectful boundary that has client and metadata access. `build()` receives
already-resolved field values and emits no side effects (EXEMPT: the pre-existing
`self.description` ADF channel in `build()` per BC-3.8.006).

**Pins:** BC-3.8.019 (JSM `description` extra field detected as ADF-backed via `jira_schema.system == "description"` and converted to an ADF object in `requestFieldValues`), BC-3.8.020 (JSM `:textarea` extra field detected as ADF-backed via `jira_schema.custom` ends with `:textarea` and converted), BC-3.8.021 (empty ADF-backed JSM extra field omitted from `requestFieldValues`; `isAdfRequest` NOT accumulated for that field), BC-3.8.022 (`isAdfRequest: true` accumulated in the resolution layer and reflected in the POST body whenever ANY extra field is ADF-converted).

**Canonical jiraSchema contract (adversarial PASS-1 C-2 resolution):**
`RequestTypeField.jira_schema` is the Rust field deserialized from the JSON key
`jiraSchema` via `rename_all = "camelCase"`. Its value IS the inner schema block —
a `serde_json::Value` whose top-level keys are `type`, `system`, `custom`, `customId`,
`items`, etc. The shared detector `is_adf_field_value(schema: &serde_json::Value)`
receives `&rt_field.jira_schema` DIRECTLY. There is NO additional `schema["jiraSchema"]`
extraction step — that would be a phantom double-nesting that always yields
`Value::Null`. Concretely:
- CORRECT: `is_adf_field_value(&rt_field.jira_schema)` — the inner block is passed directly.
- CORRECT: `rt_field.jira_schema["custom"]` — accesses the `custom` key at the top level of `jira_schema`.
- WRONG: `is_adf_field_value(&rt_field.jira_schema["jiraSchema"])` — double-nesting; `jira_schema["jiraSchema"]` is always `Value::Null`.
- WRONG: `rt_field.jira_schema["jiraSchema"]["custom"]` — same phantom double-nesting.
This contract MUST be stated in the implementation's rustdoc on `is_adf_field_value`.

**DQ-6 gate — F4-AC obligation (LOW-4):** VP-FIELD-ADF-004 axes (b), (c), (d), (e),
and (f) cannot be authored as runnable tests until the DQ-6 type/signature decision
lands at F4. The DQ-6 LAYER QUESTION IS SETTLED: `isAdfRequest` (for the `--field`
extra-field contribution) is ALWAYS a pre-computed boolean produced in `jsm_create.rs`
(the resolution layer) and passed to `build()` as an explicit bool input. `build()`
NEVER receives `rt_fields: &[RequestTypeField]` and NEVER derives the flag by
inspecting value types. EXEMPT from this invariant: the pre-existing `self.description`
ADF conversion via `adf::text_to_adf`/`adf::markdown_to_adf_*` in
`src/api/jsm/requests.rs` (BC-3.8.006) remains in `build()` unchanged — cycle-012
does not touch that channel. The remaining DQ-6 F4 decision is ONLY the
TYPE/SIGNATURE shape for carrying the already-converted ADF `serde_json::Value` for
an extra field into `build()`'s `requestFieldValues`:
(a) widen `FieldValueSpec.value` from `String` to `serde_json::Value`; or
(b) a parallel resolved-ADF-values map alongside the existing spec vector.
This type/signature decision determines the test module, constructor shape, and
assertion target for axes (b)–(f). Axis (e)'s `warning:` assertion MUST target the
RESOLUTION LAYER — not `build()`, which is pure and has no stderr access. F4 Story
2's acceptance criteria MUST explicitly gate VP-FIELD-ADF-004 test authoring on the
DQ-6 resolution; this VP must not be silently skipped. The VP is fully allocated at
F2; gating is on execution, not definition.

**Property — SEVEN primary axes (a)–(g) plus Axis (h) with sub-axes (h1)/(h2) — nine axes total (VP count stays at 86 — axis extension within VP-FIELD-ADF-004, not a new VP):**

**Axis (a) — ADF detection delegates to inner block without double-nesting:**
- `is_adf_field_value(&json!({"system": "description"}))` → `true` (BC-3.8.019).
- `is_adf_field_value(&json!({"system": "environment"}))` → `true`.
- `is_adf_field_value(&json!({"custom": "com.atlassian.jira.plugin.system.customfieldtypes:textarea"}))` → `true` (BC-3.8.020).
- `is_adf_field_value(&json!({"custom": "com.atlassian.jira.plugin.system.customfieldtypes:textfield"}))` → `false` (negative regression pin).
- `is_adf_field_value(&json!({"system": "summary"}))` → `false` (negative regression pin).
- `is_adf_field_value(&json!({"jiraSchema": {"system": "description"}}))` → `false` (double-nesting guard: the phantom extra level yields `Value::Null` for `system`, so the predicate returns `false`).

Suggested name: `test_bc_3_8_019_is_adf_field_value_inner_block_no_double_nesting`

**Axis (b) — Non-empty ADF-backed extra field → ADF object inserted in `requestFieldValues`; INV-1 (H-2):**
- The resolution layer in `jsm_create.rs` (exact function TBD per DQ-6) — given an
  extra field where `rt_field.jira_schema == json!({"system": "description"})` and
  `spec.value = "Hello world"` (non-empty) — passes `requestFieldValues[field_id]` as
  an ADF doc object (NOT `Value::String`).
- The inserted value satisfies `value["type"] == "doc"` and `value["version"] == 1` and `value["content"].is_array()` (non-empty content array).
- **INV-1 (no raw newline in text nodes, BC-7.2.011) — JSM path:** For any non-empty
  multi-line value (e.g., `spec.value = "Line one\nLine two"`), the ADF object produced
  by the resolution layer via `text_to_adf` contains NO `text` node whose `text`
  attribute contains a raw `\n` or `\r` character. Multi-line JSM extra-field values
  produce `hardBreak` nodes between lines. This mirrors VP-FIELD-ADF-002's INV-1
  assertion for the platform path; it pins that the JSM resolution layer calls
  `text_to_adf` and does not substitute a `Value::String` with embedded newlines. A
  dedicated multi-line example (e.g., `"First line\nSecond line"`) MUST appear in the
  Axis (b) test to kill the INV-1 mutant class. This axis therefore covers both single-
  line and multi-line inputs; the multi-line sub-case additionally satisfies the
  JSM-INV-1 assertion introduced here.
- Conversion happens in the RESOLUTION LAYER via `text_to_adf`, NOT via
  `dispatch_field_value` and NOT directly in `build()`'s assembler loop (per the
  DQ-6 layer-boundary constraint). The resolved ADF object must be carried into
  the request body via a TYPE/SIGNATURE change — e.g., widening `FieldValueSpec.value`
  from `String` to `serde_json::Value`, or a parallel ADF-values map — the exact
  mechanism is part of the DQ-6 F4 decision; this VP does not prescribe it.

Suggested names:
- `test_bc_3_8_019_jsm_resolution_description_converts_to_adf_object_in_request_field_values` (BC-3.8.019 — `description` system field sub-case; covers the `jira_schema.system == "description"` detection and conversion path specifically, including the multi-line INV-1 assertion)
- `test_bc_3_8_020_jsm_resolution_adf_field_converts_to_adf_object_in_request_field_values` (BC-3.8.020 — `:textarea` custom field sub-case; these may be authored as sub-cases within one test function or as sibling functions; both sub-cases MUST individually assert the ADF object shape and INV-1)

**Axis (c) — `isAdfRequest: true` accumulated for any ADF-converted extra field (BC-3.8.022):**
- When at least one extra field is ADF-converted (non-empty ADF-backed), the built result has `"isAdfRequest": true`.
- When `self.description` is `None` AND at least one non-empty ADF-backed extra field IS present, `isAdfRequest` is `true` (the flag is not gated on `self.description`).
- When ALL extra fields are either plain-string or empty-ADF-omitted AND `self.description` is `None`: the `isAdfRequest` key is ABSENT from the POST body — NOT emitted as explicit `false` (regression: the key must be omitted entirely; a mutant inserting `"isAdfRequest": false` is killed by this axis; pass-14 M-1 narrowing from LOW-1 pass-13).
- **Discriminator precision (I-2 — regression axis):** The mechanism that determines
  whether `isAdfRequest` should be set MUST use the explicit accumulated boolean flag
  passed from the resolution layer to `build()` — NOT a post-hoc `is_object()` check
  on `requestFieldValues` entries. A naive `is_object()` check would falsely flag
  hinted `:id`/`:name` extra fields (which produce JSON objects) and `:asset` extra
  fields (which produce arrays), setting `isAdfRequest = true` for non-ADF writes.
  Regression axis: a test with a hinted `:id` or `:name` extra field (producing a JSON
  object) AND no ADF extra field must produce `"isAdfRequest"` ABSENT (key not emitted — NOT explicit `false`) in
  the POST body.

Suggested name: `test_bc_3_8_022_jsm_resolution_is_adf_request_accumulated_for_converted_extra_field`

**Axis (d) — Empty ADF-backed extra field → omitted, `isAdfRequest` NOT accumulated (BC-3.8.021):**
This axis is fully defined in VP-FIELD-ADF-003 Axis C
(`test_bc_3_8_021_jsm_resolution_empty_adf_field_omitted_and_flag_not_accumulated`).
That test satisfies both VP-FIELD-ADF-003 and VP-FIELD-ADF-004 simultaneously; no
separate test file is required. The test must assert: (1) `requestFieldValues` does
NOT contain an entry for the empty ADF-backed field; (2) `isAdfRequest` is NOT `true`
solely on account of the omitted field.

**Axis (e) — Metadata-unavailable fallback emits SINGLE GLOBAL stderr warning (F4-AC observability obligation — HIGH-2, PASS-7 F-1/F-3 resolution):**
The RESOLUTION LAYER (`jsm_create.rs` or equivalent per DQ-6) MUST NOT silently emit
`Value::String(value)` when the requesttype-fields FETCH ITSELF FAILED. ANY failure of
the RT-fields fetch — network error, cache-miss-with-no-network, or ANY non-200 response
including 401, 403, 404, and 500 — falls into the fail-open branch: fall back to
`Value::String` for all BARE (`kind.is_none()`) `--field` values and CONTINUE the create
(NEVER exit 64). Hinted values (`:option`, `:id`, `:name`, `:asset`) bypass ADF conversion
regardless of metadata availability — the fail-open fallback applies only to the bare-form
values that would otherwise be ADF-converted.
NOTE: a `--field NAME=VALUE` where NAME is simply ABSENT from a SUCCESSFULLY-fetched RT
field list is NOT a metadata-unavailable case — it falls through to BC-3.8.008 verbatim
behavior per the I-1 rule (field_id addressing only) with NO warning emitted. The warning
fires ONCE per create invocation when the fetch failed — not once per `--field` pair.
This warning is emitted by the effectful resolution layer — it MUST NOT be emitted from
the pure `build()` assembler, which has no stderr access by design.
- **Warning contract (GLOBAL, no field name — PASS-7 F-3 resolution):** The warning is
  a SINGLE GLOBAL once-per-invocation message with NO individual field name in the text.
  Canonical form: `warning: could not fetch request type fields — ADF-backed --field values will be sent as plain strings`
  A 401 MAY append a brief informational read-auth note to this same single line (e.g.,
  appending `(ensure your token has read access to this service desk's request type fields)`);
  this note is cosmetic context only — it does NOT make 401 a separate exit path. 403 and
  500 follow the same fail-open rule with no special casing. The warning is never emitted
  per `--field` pair: N pairs with a failed fetch yield exactly ONE warning line.
- Assertion: the resolution-layer fallback code path (fetch-failed trigger) produces EXACTLY
  ONE stderr line containing the global unavailability message, with NO field name in the
  text. Multiple `--field` pairs with a failed fetch must still produce exactly one warning.
- Regression pin: a call where the fetch SUCCEEDED (metadata IS available) must NOT
  produce any such warning line, confirming the warning fires only on the
  fetch-failed path.
- **Product-owner fix (F-3):** EC-3.8.019-2 and EC-3.8.020-5 must align their warning
  text to the canonical form above and scope their fallback description to "BARE
  (`kind.is_none()`) `--field` values" only — hinted values (`:option`, `:id`, `:name`,
  `:asset`) are unaffected by the fetch-failed fallback since they bypass ADF conversion
  regardless of metadata availability.
- **This axis is a FIRM F4-AC obligation.** A silent `Value::String` fallback on an
  ADF-backed field with available metadata produces a guaranteed 400 indistinguishable
  from a malformed value, providing no actionable error. Zero tolerance for silent
  fallback.
- **Sub-assertion: fail-open path + empty bare value → `Value::String("")` present (NOT omitted), `isAdfRequest` ABSENT (DQ-6-harness-gated — pass-21 M-1):** Under the EC-3.8.019-2/EC-3.8.020-5 fail-open fallback (RT-fields fetch itself failed) with a BARE (`kind.is_none()`) `--field NAME=` where VALUE is EMPTY (empty string or whitespace-only) and NAME targets an allowlist field_id: (1) `requestFieldValues[NAME] == Value::String("")` — the field IS present in the assembled POST body, NOT omitted. The empty-omit guard (BC-3.8.021 / VP-FIELD-ADF-003 Axis C) fires ONLY when the resolution layer HAS ADF metadata AND detects the field as ADF-backed; that guard's precondition requires metadata availability, which is false on the fail-open path (EC-3.8.021-3). Under fail-open, every bare `--field NAME=VALUE` including empty values is degraded uniformly to `Value::String(VALUE)` — the empty-omit logic is not reached. (2) `isAdfRequest` is ABSENT from the assembled POST body — the ADF conversion branch never executed on this field (the fail-open path emits `Value::String("")`, not an ADF object), so no `is_adf_request |= true` accumulation occurs for this field. Both sub-assertions belong in the same test function as the primary Axis (e) warning-line assertion — a single test that stubs the fetch-failed path, supplies a bare empty `--field NAME=` for an allowlist field_id, and asserts: (i) exactly one global warning line on stderr; (ii) `requestFieldValues[NAME] == Value::String("")` (present, not absent); (iii) `isAdfRequest` ABSENT (key not emitted). This sub-assertion is DQ-6-harness-gated (same test-infrastructure dependency as Axes (b)–(e)); it is included in the OBS-1 Axis (e) authoring scope (item 6 of the OBS-1 verbatim AC).

Suggested name: `test_jsm_adf_field_metadata_unavailable_emits_warning` (Axis e)

**Axis (f) — Fetch SUCCEEDED, NAME absent from RT field list → verbatim string-wrap, no warning, `isAdfRequest` unchanged (I-1 regression pin; resolution-layer test; authorable once DQ-6 type/signature shape lands; assertion shape DQ-6-option-invariant, test harness is not):**
This axis pins the I-1 rule: when the RT-fields fetch SUCCEEDED but the `--field NAME`
value does not match any `RequestTypeField.field_id` in the returned list, the resolution
layer falls through to BC-3.8.008 verbatim behavior — it is NOT the metadata-unavailable
case (Axis e) and must NOT emit the global `warning:` line.
**DQ-6 note:** Axis (f) targets the same `jsm_create.rs` resolution layer as Axes (b)–(e).
Its ASSERTION shape (string-wrap, no warning, `isAdfRequest` unchanged) does not depend on
whether DQ-6 option (a) or (b) is chosen. However, constructing the test harness — setting
up the resolution layer's execution with a successfully-fetched field list and calling into
the resolved function — requires the DQ-6 type/signature shape to be fixed (same test
infrastructure dependency as Axes (b)–(e)). Axis (f) is therefore authorable only AFTER the
DQ-6 resolution lands at F4. It is included in the OBS-1 AC obligation alongside (b)–(e).

- Given a successfully-fetched RT field list (non-error, non-empty response) and a `--field
  NAME=VALUE` whose `NAME` does not match any `field_id` in that list:
  `requestFieldValues[NAME] == Value::String(VALUE)` (verbatim, no ADF conversion).
- `is_adf_request` is NOT accumulated for this field (the ADF detection predicate never
  ran for it; the flag is unchanged from its value before this field was processed).
- ZERO `warning:` lines are emitted to stderr — the absence of `NAME` in a
  successfully-fetched list is not a metadata-unavailable condition; it is silent
  pass-through per BC-3.8.008.
- **Discriminator from Axis (e):** Axis (e) fires when the FETCH ITSELF failed
  (network error, non-200, cache-miss-with-no-network). Axis (f) fires when the fetch
  SUCCEEDED but NAME simply was not in the returned field list. These are distinct code
  paths; only Axis (e) emits a warning and triggers the global fallback. A mutant that
  conflates them would fire the Axis (e) warning on a merely-unknown field name, or
  suppress the Axis (e) warning on a genuine fetch failure — Axis (f) kills the first
  class of mutant, Axis (e) kills the second.

Suggested name: `test_jsm_adf_field_name_absent_from_fetched_list_falls_through_verbatim` (Axis f)

**Axis (g) — `build()` assembly order: `self.description` supersedes the extra-fields `description` entry (EC-3.8.019-4 assembly-order pin; pure `build()` unit test; currently RED; pass-14 M-2):**
- **Two sub-cases; ONLY the `Value::String(Y)` sub-case is authorable NOW:**
  - **Sub-case 1 (`Value::String(Y)` fail-open, authorable NOW):** Given `JsmRequestBuilder` with `self.description = Some("text X")` AND `extra_fields` containing `{"description": FieldValueSpec { value: "Y".into(), kind: None }}` (the EC-3.8.019-2 fail-open form — the `build()` assembler loop string-wraps the `kind: None` entry to `Value::String("Y")` in `requestFieldValues`), the call to `build()` produces a POST body where `requestFieldValues["description"]` equals the ADF object produced from `self.description` via `text_to_adf("text X")`, NOT `Value::String("Y")`. This sub-case is injectable via the current `JsmRequestBuilder` `extra_fields` API (`FieldValueSpec.value: String`, `kind: None`) without any DQ-6 type/signature change. **The test MUST include a regression assertion for BC-3.8.008 last-wins to guard against moving the whole dedicated-flag block instead of only the `description` insert:** given `JsmRequestBuilder` with a `summary` dedicated-flag value `"A"` AND `extra_fields` containing `{"summary": FieldValueSpec { value: "B".into(), kind: None }}`, the built `requestFieldValues["summary"]` MUST equal `Value::String("B")` — i.e., the `summary` dedicated-flag insert stays BEFORE the loop and is superseded by the extra-field entry (last-wins for `summary`, BC-3.8.008). ONLY the `description` insert (`rfv.insert("description", adf_body)`, the BC-3.8.006 channel) is relocated to after the loop; `summary`, `priority`, `labels`, and all other dedicated-flag inserts remain BEFORE the loop.
  - **Sub-case 2 (ADF-object pre-seed, requires DQ-6 widening):** Given `requestFieldValues` already containing a `"description"` entry as a pre-formed ADF `Value::Object(...)`, asserting that `build()` overwrites it with `self.description`'s ADF. This sub-case requires DQ-6 option (a) or (b) to land (the `FieldValueSpec.value` must be able to carry a `serde_json::Value`, not just a `String`). Authorable only AFTER DQ-6 type/signature shape lands.
- **Pure `build()` unit test:** targets `JsmRequestBuilder::build()` directly — no `RequestTypeField` metadata, no `jsm_create.rs` resolution layer, no network. Construct a `JsmRequestBuilder` with a known `description`, inject via `extra_fields["description"]` with `FieldValueSpec { value: "Y".into(), kind: None }` (the loop string-wraps it to `Value::String("Y")` in `requestFieldValues` for sub-case 1), call `build()`, assert the final body's `requestFieldValues["description"]`.
- **Sub-case 1 is NOT DQ-6-gated** (the assembly-order constraint is independent of how the extra-fields map is populated; the `Value::String(Y)` form is injectable now). Sub-case 2 requires DQ-6 signature widening.
- **Currently RED:** the `rfv.insert("description", adf_body)` in `JsmRequestBuilder::build`'s BC-3.8.006 description block (`src/api/jsm/requests.rs`) writes `self.description`'s ADF block BEFORE the `for (k, spec) in self.extra_fields` loop, so any `"description"` entry written by the loop OVERWRITES it. Axis (g) sub-case 1 immediately reveals this defect.
- Pins EC-3.8.019-4 assembly-order rule (pass-13 MEDIUM-3, ADR-0024 Consequences §MEDIUM-3; pass-14 M-2).

Suggested name: `test_bc_3_8_019_build_description_supersedes_extra_field_description_entry`

**Axis (h) — Uniform exit-64 for `--markdown + --field description=` on PLATFORM paths (F2-gate, 2026-09-13; VP count stays at 86 — axis extension within VP-FIELD-ADF-004, not a new VP):**
The JSM guard (BC-3.8.017) is already covered by the pre-existing test
`tests/issue_create_jsm.rs::test_jsm_create_markdown_field_description_conflict_exits_64`.
Axis (h) adds two platform-path sub-axes — both are F4 obligations and MUST be RED until
the guards are implemented (see ADR-0024 amended LOW-1 for guard ordering details):

**Axis (h1) — Platform create NET-NEW guard (EC-3.3.014-5; F4 obligation in `src/cli/issue/create.rs::handle_create`):**
- `jr issue create --project P --type T --summary S --field description=X --markdown` (no `--description`) → exit 64.
- `stderr.contains("cannot be combined with \`--markdown\`")` asserts true.
- stdout empty; zero HTTP mocks (guard fires at step 2c, before createmeta resolution).
- `src/cli/issue/create.rs::handle_create` currently lacks this guard entirely — it is a NET-NEW guard.
- Test name: `test_bc_3_3_014_5_markdown_field_description_conflict_exits_64_create`
- **Currently RED** — the guard does not exist; `create.rs` proceeds to createmeta resolution on this input.

**Axis (h2) — Platform edit guard extension (EC-3.4.035-3; F4 obligation in `src/cli/issue/edit.rs::handle_edit`):**
- `jr issue edit KEY --field description=X --markdown` (no `--description`) → exit 64.
- `stderr.contains("cannot be combined with \`--markdown\`")` asserts true (NOT the pre-existing "`--markdown requires --description or --description-stdin`" substring — the test MUST assert the message from the NEW guard, NOT the existing guard's message).
- stdout empty; zero HTTP mocks (guard fires before editmeta).
- `src/cli/issue/edit.rs::handle_edit` guard must be EXTENDED — the new guard fires BEFORE the existing `--markdown`-requires-description guard.
- Test name: `test_bc_3_4_035_3_markdown_field_description_conflict_exits_64_edit`
- **Currently RED** — `edit.rs` currently exits 64 with the wrong guard's message (`"--markdown requires --description or --description-stdin"`), not the required `` "cannot be combined with `--markdown`" `` substring.

**Mechanism for both (h1) and (h2):** CLI-level subprocess test:
`assert!(stderr.contains("cannot be combined with \`--markdown\`"))` +
`assert_eq!(exit_code, 64)` +
`assert!(stdout.trim().is_empty())`.
Zero HTTP mocks required — both guards fire before any HTTP call (h1 before createmeta; h2 before editmeta).

Suggested names: `test_bc_3_3_014_5_markdown_field_description_conflict_exits_64_create` (h1), `test_bc_3_4_035_3_markdown_field_description_conflict_exits_64_edit` (h2)

**RED proof:**
- Against a mutant that emits the global `warning:` line for an unknown field name
  (conflating "name not in list" with "fetch failed"): Axis (f) fails RED — one warning
  line is produced, but the test asserts ZERO warning lines. ✓
- Against a mutant that routes an unknown field name to `text_to_adf` (i.e., ADF-converts
  any field whose name is not recognized rather than passing it through verbatim): Axis (f)
  fails RED — `requestFieldValues[NAME]` is an ADF object, not `Value::String(VALUE)`. ✓
- Against a mutant that sets `is_adf_request |= true` for the unknown field: Axis (f)
  fails RED — `isAdfRequest` is accumulated when no ADF conversion occurred. ✓

**Why this VP exists (separation from VP-FIELD-ADF-001/002):** VP-FIELD-ADF-001 and
VP-FIELD-ADF-002 target the platform `dispatch_field_value` path. The JSM path does
NOT call `dispatch_field_value` — the JSM resolution layer implements its own ADF
detection (via `is_adf_field_value`), conversion, and `isAdfRequest` accumulation.
A mutant removing the ADF conversion branch from the JSM resolution layer would be
invisible to VP-FIELD-ADF-001/002. VP-FIELD-ADF-004 closes that gap by directly
targeting the JSM-specific resolution-layer code path.

**RED proof:**
- Against a mutant removing the ADF conversion branch from the JSM resolution layer: Axis (b) fails RED — `requestFieldValues[field_id]` is `Value::String("Hello world")`, not an ADF doc. ✓
- Against a mutant calling `is_adf_field_value(&rt_field.jira_schema["jiraSchema"])` instead of `&rt_field.jira_schema` (phantom double-nesting): Axis (a) fails RED — the call on `json!({"system":"description"})` returns `false` (the nested key is `Value::Null`); additionally the double-nesting guard assertion detects it. ✓
- Against a mutant removing `is_adf_request |= true` from the ADF-conversion branch in the resolution layer: Axis (c) fails RED — `isAdfRequest` is not set even when an extra ADF field was converted. ✓
- Against a mutant that accumulates `isAdfRequest` even for omitted (empty) ADF fields: the VP-FIELD-ADF-003 Axis C test (shared) fails RED. ✓
- Against a mutant inserting `"isAdfRequest": false` explicitly when no ADF value is present (instead of omitting the key entirely): Axis (c)'s ABSENT assertion fails RED — the key is present as `false` when the test requires it to be absent (pass-14 M-1). ✓
- Against the current code where `rfv.insert("description", adf_body)` in `JsmRequestBuilder::build`'s BC-3.8.006 description block (`src/api/jsm/requests.rs`) precedes the `for (k, spec) in self.extra_fields` loop: Axis (g) fails RED — `requestFieldValues["description"]` is the extra-field's last-written value, not `self.description`'s ADF object. After the fix (description written AFTER the loop), Axis (g) passes GREEN (pass-14 M-2). ✓
- Against a silent `Value::String` fallback when metadata is unavailable (no stderr warning emitted): Axis (e) fails RED — no stderr output produced, but the test asserts exactly one global warning line on stderr. ✓
- Against a per-field-warning mutant that emits one warning per `--field` pair instead of one global warning: Axis (e) fails RED — N warning lines produced, but the test asserts exactly one. ✓
- Against the current `src/cli/issue/create.rs` where the NET-NEW step 2c guard is absent: `jr issue create --field description=X --markdown` proceeds to createmeta resolution without rejecting → exit code is not 64, stderr does not contain the required substring → Axis (h1) FAILS RED. ✓
- Against a mutant in `src/cli/issue/edit.rs` that omits the NEW `--markdown + --field description=` guard (so only the pre-existing `--markdown`-requires-description guard runs): `--field description=X --markdown` (no `--description`) exits 64 with "`--markdown requires --description or --description-stdin`" NOT `` "cannot be combined with `--markdown`" `` → Axis (h2)'s `stderr.contains` assertion FAILS RED. ✓

---

## 5. F4 Obligations

The following items are REQUIRED at Story 1 / Story 2 F4 delivery and must
not be silently deferred:

1. **CONFIRM the new `is_adf_*` helpers and ADF/resolution-layer branches are covered
   by the existing whole-file `field_resolve.rs` and `jsm_create.rs` globs in
   `.cargo/mutants.toml`** — no scope edit is required (PASS-9 LOW-2 correction).
   Both `src/cli/issue/field_resolve.rs` and `src/cli/issue/jsm_create.rs` are already
   whole-file `examine_globs` entries (verified: `field_resolve.rs` at line 74,
   `jsm_create.rs` at line 21 of `.cargo/mutants.toml`). The new `is_adf_field`,
   `is_adf_schema`, `is_adf_field_value` helpers and the ADF conversion branches in
   `dispatch_field_value` and the JSM resolution layer are therefore already in mutants
   scope by the existing entries. No `.cargo/mutants.toml` edit is needed for this feature.
2. **`src/api/jsm/requests.rs::JsmRequestBuilder::build` is already in mutants scope**
   via its whole-file `examine_globs` entry (`.cargo/mutants.toml` line 26). `build()`'s
   ONLY ADF role in cycle-012 is REFLECTING the pre-computed `isAdfRequest` boolean it
   receives from the resolution layer — `build()` has NO extra-fields ADF branch of its own
   (ADF detection, `text_to_adf` conversion, empty-omit, and `warning:` emission all belong
   in `jsm_create.rs` per the DQ-6 layer constraint). No `.cargo/mutants.toml` scope edit
   is required for `requests.rs` (Story 2).
3. **Live E2E confirmation of `:textarea` on the create path (H2 residual, AC-13):**
   `test_e2e_issue_edit_custom_field` adaptive read-back assertion (Story 1). Clean-skip
   if no `:textarea` field on the E2E instance (per §M1 in the F1 delta analysis).
4. **JSM ADF E2E confirmation (JSM-AC-7):** extend
   `test_e2e_jsm_create_request_roundtrip` (or add a companion) to verify that
   `--field description=VALUE` via the generic path sends ADF and reads back as
   an ADF object. Gated on `JR_E2E_JSM_PROJECT`.
5. **DQ-6 type/signature decision (layer question SETTLED — type shape only):** The
   layer question is resolved: `isAdfRequest` for the `--field` extra-field
   contribution is ALWAYS a pre-computed boolean from `jsm_create.rs` (the resolution
   layer), passed to `build()` as an explicit bool input. `build()` NEVER receives
   `rt_fields: &[RequestTypeField]` and NEVER derives the flag by inspecting value
   types. EXEMPT: the pre-existing `self.description` ADF conversion in `build()`
   (BC-3.8.006) is unchanged. The SOLE remaining DQ-6 decision is the TYPE/SIGNATURE
   shape for carrying the already-converted ADF `serde_json::Value` for an extra field
   into `build()`'s `requestFieldValues`:
   (a) widen `FieldValueSpec.value` from `String` to `serde_json::Value`; or
   (b) a parallel resolved-ADF-values map alongside the existing spec vector.
   INVARIANT (scoped to the `--field` extra-field path): ADF detection, `text_to_adf`
   conversion, empty-omit, and `warning:` emission are ALWAYS `jsm_create.rs`
   responsibilities; `build()` is a pure assembler that, **for `--field` extra-field
   values**, must never call `is_adf_field_value`, `text_to_adf`, or `eprintln!`
   (the `self.description` ADF channel per BC-3.8.006 is EXEMPT and retains its
   `text_to_adf`/`markdown_to_adf_*` calls, as stated above). When `RequestTypeField`
   metadata IS available (the normal path), ADF conversion MUST fire for every
   ADF-backed extra field — sending `Value::String` to an ADF-backed field produces
   a guaranteed 400. The `Value::String` fallback applies ONLY when the
   requesttype-fields FETCH ITSELF FAILED (network error / non-200 including
   401/403/404/500 / cache-miss-with-no-network) AND MUST emit a SINGLE GLOBAL
   observable stderr `warning:` line ONCE per create invocation (not per `--field`
   pair) with NO field name in the text. A silent fallback is NOT acceptable.
   VP-FIELD-ADF-004 axes (b)–(e) are gated on this DQ-6 type/signature decision
   landing; see §4 VP-004 for the full gate.

   **MECHANICAL F4 AC OBLIGATION (OBS-1 — tracked to F4 by orchestrator):** F4 Story 2
   acceptance criteria MUST contain a named, numbered AC stating verbatim: "VP-FIELD-ADF-004
   axes (b)–(e) [DQ-6-gated] and (f) [resolution-layer, authorable once DQ-6 type/signature
   shape lands] are not yet authored. Before closing Story 2: (1) make the DQ-6 type/signature
   decision (option a or b); (2) author VP-FIELD-ADF-004 axes (b)–(e) unit tests targeting
   the decided shape; (3) author Axis (f) unit test (resolution-layer test — I-1 regression
   pin — which shares the same DQ-6 test-harness dependency as Axes (b)–(e)); (4) confirm all
   VP-FIELD-ADF-004 axes (a–g) pass GREEN (Axis (h1)/(h2) are platform-path guards tracked
   separately in §5 item 18 — NOT part of Story 2's OBS-1 gate); (5) author and confirm GREEN
   VP-FIELD-ADF-003 Axis D sub-cases — BOTH platform
   (`test_adf_empty_guard_fires_only_on_bare_form_not_hinted_platform`) AND JSM
   (`test_adf_empty_guard_fires_only_on_bare_form_not_hinted_jsm`) — these tests target the
   extracted pure gate code for the `kind.is_none()` ADF-guard condition (F4 extraction
   obligation) directly, NOT the `jsm_create.rs` resolution layer; the exact decomposition
   is F4's choice; they do NOT share the DQ-6 test-harness dependency; author them as soon
   as the pure gate code is extracted at F4 (independent of the DQ-6 type/signature decision
   — authorable before Story 2's DQ-6 axes); (6) confirm that the Axis (e) test (`test_jsm_adf_field_metadata_unavailable_emits_warning`) includes the pass-21 M-1 sub-assertion: for a bare empty `--field NAME=` targeting an allowlist field_id under the fail-open path, assert (i) `requestFieldValues[NAME] == Value::String("")` (present, NOT omitted), and (ii) `isAdfRequest` ABSENT (key not emitted)." This AC must
   appear in the story's AC section as a lettered or numbered item — not in a narrative note,
   footnote, or "notes" paragraph — so the orchestrator and gate reviewers can tick it off at
   F4. The VP is fully allocated at F2; the gate is on test execution, not definition.
   Skipping this AC at F4 means VP-FIELD-ADF-004 axes (b)–(f) are permanently unverified
   (VP-FIELD-ADF-003 Axis D platform and JSM sub-cases are independently authorable via the
   extracted pure gate code and MUST NOT be skipped even if DQ-6 is delayed); the F5
   adversarial review will flag any story that does not show all required axes passing GREEN.
   **NOTE on Axis (g):** Axis (g) (`build()` assembly-order, `Value::String(Y)` sub-case) is
   tracked separately in item 5a below and is authorable NOW — it does NOT require the DQ-6
   decision. Its GREEN status MUST be confirmed at F4 as part of the gate above.
   **NOTE on gate completeness (process-gap, pass-21):** OBS-1 item (4) requires all VP-FIELD-ADF-004 axes (a–g) to pass GREEN, which includes Axis (g). Axis (h1)/(h2) are tracked via §5 item 18 (Story 1/platform gate), not OBS-1. However, item 5a additionally requires a SOURCE CODE CHANGE (the `build()` assembly-order reorder in `src/api/jsm/requests.rs`) that is distinct from test-authoring. A gate reviewer who verifies only OBS-1's test-pass status without separately verifying that the `build()` reorder was applied may silently miss the code change. The F4 Story 2 gate MUST enumerate item 5a as a SEPARATE, explicitly named checkbox alongside OBS-1 — both must be ticked independently. See §5 item 5a for the explicit gate enumeration note.

5a. **VP-FIELD-ADF-004 Axis (g) — author test + apply `build()` assembly-order source reorder (FIRM F4 AC — authorable NOW, currently RED; independently trackable from OBS-1):**
   Axis (g) is a pure `build()` unit test that does NOT require the DQ-6 type/signature
   decision. It MUST be authored AND pass GREEN before F4 Story 2 closes — it is a
   prerequisite for the seven-axis GREEN gate in OBS-1.

   **What to do at F4 (sub-case 1, authorable NOW):**
   (1) **Author the test** `test_bc_3_8_019_build_description_supersedes_extra_field_description_entry`:
       - Construct a `JsmRequestBuilder` with `self.description = Some("text X")`.
       - Inject via `extra_fields["description"]` with `FieldValueSpec { value: "Y".into(), kind: None }` (the loop string-wraps it to `Value::String("Y")` in `requestFieldValues`; `kind: None` is required to reach the string-wrap branch).
       - Call `build()`.
       - Assert the returned body's `requestFieldValues["description"]` is an ADF doc
         (has `type == "doc"`) produced from `"text X"`, NOT `Value::String("Y")`.
       - This test is pure — no network, no `RequestTypeField` metadata required.
   (2) **Apply the `build()` assembly-order source reorder** in
       `src/api/jsm/requests.rs::JsmRequestBuilder::build`:
       - Move the `self.description` ADF write (`rfv.insert("description", adf_body)`,
         the BC-3.8.006 channel) to AFTER the `for (k, spec) in self.extra_fields` loop.
       - This is a pure implementation ordering change — no new logic, no new guard, no
         new diagnostic. It makes Axis (g) turn GREEN.
       - **Scope constraint:** ONLY the `description` insert (`rfv.insert("description", adf_body)`, the BC-3.8.006 channel) moves to after the loop — `summary`, `priority`, `labels`, and all other dedicated-flag inserts in `build()` stay BEFORE the extra-fields loop, preserving their last-wins behavior (BC-3.8.008). Moving the whole dedicated-flag block would invert last-wins for those keys; the Axis (g) regression assertion (`--request-type RT --summary A --field summary=B` → `requestFieldValues["summary"] == "B"`) detects this mistake.
       - **Audit-symmetry note (LOW-1):** The `description`-key assembly-order reversal also affects the `--description X` + `--field description=Y` combination — previously `--field description=Y` wins (last-written into the loop's output), after the reorder `--description X` wins (written after the loop). This is distinct from the `summary` last-wins case guarded by the Axis (g) regression assertion. This reversal was checked against existing JSM fixtures: no existing test pins the old `--description X --field description=Y → Value::String("Y")` outcome (the pre-cycle-012 behavior was a latent `isAdfRequest:true`+plain-string desync/400, so nothing pinned it); the reversal therefore introduces no active regression. The behavior change is already enumerated in BC-3.4.034 item 4(c) / pass-14 L-3 CHANGELOG.
       - **NOTE: DO NOT change source code here.** This is an F4 obligation recorded for
         the orchestrator. The implementer applies the reorder at F4 Story 2.
   (3) **Confirm Axis (g) sub-case 1 passes GREEN** after the reorder.

   **Why this item exists separately from OBS-1:** Axis (g) requires a SOURCE CODE CHANGE
   (`build()` assembly-order reorder) that the DQ-6 axes (b)–(f) do not. It is independently
   trackable so the orchestrator can close this obligation before the DQ-6 decision is finalized
   if Story 2 is split. The `build()` assembly-order reorder is REQUIRED regardless of which
   DQ-6 option is chosen.

   **F4 GATE ENUMERATION OBLIGATION (process-gap, pass-21):** The F4 Story 2 completion gate checklist MUST enumerate item 5a as a DISTINCT, SEPARATELY NAMED checkbox — NOT subsumed within OBS-1's "confirm all SEVEN VP-FIELD-ADF-004 axes (a–g) pass GREEN" clause. OBS-1 verifies test-pass status; item 5a additionally verifies a SOURCE CODE CHANGE. A gate reviewer who ticks only OBS-1 may confirm the Axis (g) test passes without separately verifying that the `build()` assembly-order reorder was applied in `src/api/jsm/requests.rs`. The gate checklist MUST include BOTH:
   - **Checkbox A (OBS-1):** VP-FIELD-ADF-004 axes (a)–(f) authored/GREEN (Axis (a) authorable now; (b)–(e) DQ-6-gated; (f) resolution-layer); VP-FIELD-ADF-003 Axis D platform + JSM sub-cases GREEN (both target pure gate code for the `kind.is_none()` ADF-guard condition — F4 extraction obligation — **NOT DQ-6-gated**; authorable as soon as gate code is extracted at F4, independent of DQ-6 type/signature decision); Axis (e) M-1 sub-assertion confirmed (all 6 items of the OBS-1 verbatim AC text). Axis (h1)/(h2) are platform-path guards tracked via §5 item 18 (Story 1/platform gate — NOT this Story 2 checkbox).
   - **Checkbox B (item 5a):** `test_bc_3_8_019_build_description_supersedes_extra_field_description_entry` authored AND the `build()` assembly-order source reorder applied in `src/api/jsm/requests.rs` (BC-3.8.006 description-channel write moved AFTER the extra-fields loop) AND Axis (g) sub-case 1 GREEN.
   Checkbox B is INDEPENDENTLY REQUIRED; it is not satisfied by Checkbox A alone.

6. **JSM `RequestTypeField` metadata acquisition when ≥1 BARE (`kind.is_none()`) `--field` pair is present (H-1
   — added):** The JSM create path (`src/cli/issue/jsm_create.rs::handle_jsm_create`)
   currently never calls `GET .../requesttype/{id}/field` — no `RequestTypeField`
   metadata exists in hand. The whole ADF feature on the JSM path, AND the
   fetch-failed fallback in VP-FIELD-ADF-004 Axis (e), both presuppose that this
   metadata is available for the resolution-layer ADF check. F4 Story 2 MUST add a
   metadata-acquisition step to `handle_jsm_create` when ≥1 BARE (`kind.is_none()`) `--field` pair is present
   (hinted-only invocations issue NO fields-fetch GET and NO warning):
   - Call `JiraClient::get_request_type_fields` (a `JiraClient` async method in
     `src/api/jsm/request_types.rs`, returns `RequestTypeFieldsResponse`). The
     resolution layer must unwrap `.request_type_fields: Vec<RequestTypeField>` from
     the response before passing fields to the ADF detection step.
     `JiraClient::get_request_type_fields` is cacheless — the caller in `jsm_create.rs`
     must wrap it with explicit cache free-function calls: `read_request_type_fields_cache`
     BEFORE the HTTP call when a warm entry exists, `write_request_type_fields_cache`
     AFTER a successful fetch, keyed on `(profile, sid, rtId)`, 7-day TTL.
     Warm-cache calls add no network latency.
   - **Failure taxonomy — FAIL-OPEN (PASS-7 F-1 resolution; consistent with the
     existing JSM create error surface):** ANY failure of the RT-fields fetch —
     network error, cache-miss-with-no-network, OR any non-200 response including
     401, 403, 404, AND 500 — results in the SAME single outcome: emit ONE global
     stderr `warning:` line ONCE per create invocation (not once per `--field` pair)
     with the unavailability reason (global, NO field name in the text), then fall
     back to `Value::String` for all BARE (`kind.is_none()`) `--field` values per
     EC-3.8.019-2 / EC-3.8.020-5 (hinted values bypass ADF conversion regardless of
     metadata availability), and CONTINUE the create (NEVER exit 64 on this path). The
     `write:servicedesk-request` write-scope hint is NOT appropriate here — the
     request-type fields endpoint is a READ endpoint (finding I-5). A 401 MAY append
     a brief informational read-auth note to the same single warning line (e.g.,
     `(ensure your token has read access to this service desk's request type fields)`)
     — this is cosmetic context ONLY, not a separate exit or additional warning. 403
     and 500 follow the same fail-open rule with no special casing. A 404 is treated
     identically to a network error — emit warning, fall back, never exit 64 (the
     create POST itself will surface the real error if the RT ID is truly invalid).
     This fail-open contract applies whether one or twenty `--field` pairs were
     supplied.
   - **JSM ADF matching rule (I-1 — field_id addressing only):** ADF auto-wrap on the
     JSM create path fires ONLY when the `--field NAME` value matches a
     `RequestTypeField.field_id` from the metadata response. The system `description`
     field has `field_id == "description"` (matching the literal string `description`
     in `--field description=VALUE`); `:textarea` custom fields have
     `field_id == "customfield_NNNNN"` (matched only by the exact `customfield_NNNNN`
     literal form). Display-name addressing (`--field "My Custom Field"=VALUE`) is NOT
     supported for JSM ADF detection — consistent with BC-3.8.008 (the NAME is used
     verbatim as the `requestFieldValues` key with no name→id resolution on the JSM
     create path). A `--field NAME=VALUE` where NAME does not match any `field_id` in
     a SUCCESSFULLY-fetched RT field list falls through to BC-3.8.008 verbatim behavior
     with NO warning — this is the I-1 "unknown field" case, not the Axis (e)
     fetch-failed case.
   - **JSM `environment` field (F-7 — intentional transitive coverage):** The JSM
     `environment` system field is covered by the shared `is_adf_schema` predicate
     (`system == "environment"`) transitively — no dedicated JSM ADF pin is added for
     it because the probe found no `environment` field in the test-instance JSM request
     types. Uniform allowlist treatment is intentional; if a JSM RT exposes
     `environment`, the same detection/conversion path fires automatically.
   - **Ordering pin (L-3):** The fields-fetch step is inserted AFTER project-key
     resolution → BC-3.8.017 `--markdown` guard → `require_service_desk` → request-type
     NAME-to-id resolution, and BEFORE the create POST. Concretely: resolve the RT id
     first, then call `get_request_type_fields` with that resolved id, then pass the
     metadata to the resolution layer, then issue the `POST /rest/servicedeskapi/request`.
     The fields-fetch and BC-3.8.018's pre-`build()` mention-resolution step (which resolves `@Name`/`[~accountid:X]` mentions in description text) are ORDER-INDEPENDENT — both run pre-`build()` and operate on disjoint inputs (RT field metadata vs description text); their relative order within `handle_jsm_create` is unconstrained.
   - The added round-trip is gated on **≥1 BARE (`kind.is_none()`) `--field` pair being present** (no extra HTTP call when no `--field` pairs are specified, or when ALL `--field` pairs carry an explicit hint kind). A no-`--field` JSM create is unchanged from the pre-F4 code path. A hinted-only invocation (e.g., `--field cf:id=5` with no bare pairs) likewise issues NO fields-fetch GET — hinted pairs opt out of ADF conversion entirely and therefore never trigger the metadata fetch. (M-2 gate correction, pass-19.)
   - This item is IN ADDITION to the DQ-6 type/signature resolution (item 5 above):
     item 5 decides how the resolved ADF object is carried into the assembler; this
     item decides how the metadata is acquired in the first place. Both must land
     together in F4 Story 2.
   - **Product-owner instruction (L-2 — EC-3.8.019-2 accepted-residual note, pass-21):** Add the following note to EC-3.8.019-2 in `bc-3-issue-write.md`, after the existing fail-open description (the paragraph that describes the warn-once + plain-string fallback + continue behavior):

     > **(Accepted residual — ADF-backed field absent from a successfully-fetched RT field list, out of scope this cycle):** When the RT-fields fetch SUCCEEDED (non-error `200` response, non-empty field list) but a bare `--field NAME=VALUE`'s `NAME` does not match any `RequestTypeField.field_id` in the returned list, the I-1 rule applies verbatim: `requestFieldValues[NAME] == Value::String(VALUE)` (string-wrap, no ADF conversion), `isAdfRequest` unchanged, ZERO `warning:` lines emitted (VP-FIELD-ADF-004 Axis (f)). If `NAME` is an ADF-backed field_id on the Jira instance but the RT's metadata response omits it (e.g., the RT renders that field differently or the metadata fetch returned a partial list), the plain-string write may yield a server `400` that is indistinguishable from an ordinary unknown-field `400` — with no `jr` diagnostic or warning. This is an accepted out-of-scope residual for cycle-012: the live probe confirmed `field_id == "description"` was present in the test-instance RT field list; a partially-returning metadata edge is low probability in practice. Low probability; documentation-only.

7. **Wiremock-backed F4 acceptance obligations for JSM metadata acquisition wiring
   (F-5 — MUST F4 AC):** VP-FIELD-ADF-004's unit tests operate on controlled structs
   with no network I/O; the following behaviors require a separate wiremock-backed
   integration test or explicit Story 2 wiremock AC:
   (a) the `GET /rest/servicedeskapi/servicedesk/{sdId}/requesttype/{rtId}/field`
       round-trip fires IFF **≥1 BARE (`kind.is_none()`) `--field` pair is present** on a JSM create call; a JSM create with NO `--field` pairs issues NO fields-fetch GET; a JSM create with ONLY hinted `--field` pairs (e.g., `--field cf:id=5`) ALSO issues NO fields-fetch GET — hinted pairs opt out of ADF conversion and therefore never trigger the metadata fetch; (M-2 gate correction, pass-19.)
   (b) a warm cache entry (populated by `write_request_type_fields_cache`) → NO HTTP
       for the fields-fetch GET on the next create call with the same `(profile, sid,
       rtId)` key;
   (c) a 401 on the fields-fetch GET MUST emit the mandatory global warning line (the
       same single `warning:` line that fires on ANY fetch failure — network error,
       404, 403, 500, and 401 alike): `warning: could not fetch request type fields —
       ADF-backed --field values will be sent as plain strings`. This is the
       FIRM MUST F4 AC and the ONLY load-bearing test pin for the 401 case — the
       wiremock test MUST assert that this exact warning text appears on stderr.
       IMPORTANT: a 401 MAY additionally append a brief informational read-auth note to
       the same single warning line (e.g., `(ensure your token has read access to this
       service desk's request type fields)`) — this appendage is OPTIONAL and cosmetic
       only, consistent with EC-3.8.019-2, EC-3.8.020-5, and VP-FIELD-ADF-004 Axis (e).
       The wiremock test for item 7(c) MUST NOT pin the appendage text as a required
       assertion; pinning the mandatory warning line prefix is sufficient. The test MUST
       also confirm the write-scope hint (`write:servicedesk-request`) does NOT appear —
       that hint is reserved for the create POST itself, not the read-only fields-fetch
       endpoint.
   These are FIRM MUST F4 ACs. None of (a), (b), or (c) is exercised by the VP-004
   unit tests.

8. **LIVE echo channels for ADF `--field` (PASS-9 F-1 — FIRM MUST F4 AC; mirrors VP-398-002
   discipline):** For both the edit path (live, non-dry-run) and the create path (live,
   non-dry-run), the following must be tested and passing before Story 1 / Story 2 can close.
   **MEDIUM-1 RETRACTED (H-1, adversarial pass 12) — JSM create is key-only, marker-free.**
   Ground truth (confirmed at `src/cli/issue/jsm_create.rs:415-417`): the JSM create path
   prints only `output::print_success("Created request <KEY>")` in table mode — there is NO
   per-field echo surface. The `field_markers` side-channel (item 9) is populated at exactly
   two sites, both PLATFORM-PATH functions in `field_resolve.rs` (`dispatch_field_value` ADF
   branch and `resolve_against_editmeta` empty-clear pre-check). Neither site is called on the
   JSM create code path — `jsm_create.rs`'s resolution layer does not invoke either function.
   Implementing `(adf)` parity on JSM create would require a net-new per-field echo surface
   not present in `jsm_create.rs` and outside F1-approved scope. The prior MEDIUM-1 ruling is
   UNIMPLEMENTABLE and is REVERSED. JSM create success output is unchanged from BC-3.8.001:
   `Created request <KEY>` (table) or `{"key":…}` (JSON) — no per-field marker. The F4 AC
   test `test_bc_3_8_019_jsm_create_table_shows_adf_marker` is RETRACTED; do not author it.
   The `(adf)` and `(adf-clear)` markers are PLATFORM PATHS ONLY: BC-3.3.013/BC-3.3.014
   (platform create) and BC-3.4.033/BC-3.4.035 (platform edit); BC-3.4.036 (`(adf-clear)`
   on platform edit). See §7 for the retraction notice and product-owner BC instruction.
   - **JSON channel (`--output json`, edit path only — create has no `changed_fields` key):**
     `changed_fields[human_name]` MUST carry the **raw user-supplied input string** for a
     non-empty ADF-backed field (VP-FIELD-ADF-002 live echo axis); for the edit-clear case
     (empty ADF-backed field on the edit path), `changed_fields[human_name]` MUST carry the raw
     empty/whitespace input string (VP-FIELD-ADF-003 Axis F). NOT the serialized ADF object,
     NOT the `(adf)` or `(adf-clear)` marker.
   - **Table/human channel (platform edit and platform create only — JSM create is key-only per BC-3.8.001):** the cell for a non-empty ADF-backed field on the PLATFORM path MUST show `(adf)` (not the ADF object, not the raw value — platform edit and platform create share this marker: BC-3.3.013/BC-3.4.033); the cell for an edit-cleared ADF-backed field (platform edit only) MUST show `(adf-clear)` (BC-3.4.036). The JSM create path emits no per-field row.
   Required tests: VP-FIELD-ADF-002 live echo axis (`test_bc_3_4_033_live_edit_json_changed_fields_raw_input_not_adf_object`,
   `test_bc_3_4_033_live_edit_table_shows_adf_marker_not_raw_value`,
   `test_bc_3_3_013_create_table_shows_adf_marker`,
   `test_bc_3_4_035_live_edit_field_description_shows_adf_not_updated`) and VP-FIELD-ADF-003
   Axis F (`test_bc_3_4_036_live_edit_json_changed_fields_raw_empty_input_not_clear_doc`).
   **`test_bc_3_4_035_live_edit_field_description_shows_adf_not_updated` (M-2 addition):**
   Drives `jr issue edit KEY --field description=VALUE` (bare form — no `--description` flag)
   through the full CLI pipeline with a wiremock editmeta stub where the `description` field
   has `schema.system == "description"`. Asserts: (a) the table cell for `description` shows
   `(adf)`, NOT `(updated)` — the emit loop MUST consult `field_markers` BEFORE the legacy
   `if field == "description" { "(updated)" }` hard-code; (b) `changed_fields["description"]`
   carries the raw user-supplied `VALUE` string, NOT the ADF object (JSON-channel lossless).
   **Why the existing tests do not cover this ordering:** `test_bc_3_4_033_live_edit_table_shows_adf_marker_not_raw_value`
   and `test_bc_3_3_013_create_table_shows_adf_marker` target a `:textarea` custom field
   (`field != "description"`), so the `description → (updated)` hard-code is never reached
   and the ordering mutant survives. This test targets `field == "description"` specifically,
   making the ordering a live discriminator.
   **RED-proof mutant (ordering):** A mutant that causes the emit loop to consult the
   `description → (updated)` hard-code BEFORE `field_markers` — so `(updated)` is emitted
   for `--field description=VALUE` instead of `(adf)` — causes this test to FAIL RED:
   the table cell is `(updated)`, not `(adf)`. ✓
   These mirror the VP-398-002 `test_bc_3_4_012_description_echo_is_updated_marker_not_content`
   and `test_bc_3_4_013_description_echo_is_raw_input_string_not_marker` discipline for the
   `description` dedicated flag — the exact same channel asymmetry must be pinned for `--field`
   ADF. Zero tolerance for a live edit that silently emits the ADF object in the JSON channel or
   the raw value in the table channel.

9. **Marker side-channel plumbing for live echo channels — REQUIRED F4 AC (F-1 + F-2
   resolution; parallel of DQ-6 for the platform path):** `FieldResolutionOutputs`
   (in `src/cli/issue/field_resolve.rs`) MUST gain a dedicated marker side-channel,
   e.g. `field_markers: BTreeMap<String, &'static str>` keyed by `human_name`
   (display name, NOT `field_id`). Populated at exactly two sites (PLATFORM PATHS
   ONLY — both population sites are in `field_resolve.rs`; neither is reachable from
   `jsm_create.rs` per H-1 pass-12 ruling; see item 8):
   - `dispatch_field_value`'s ADF branch: `field_markers.insert(human_name, "(adf)")` for
     a non-empty bare ADF-backed field.
   - `resolve_against_editmeta`'s empty-clear pre-check:
     `field_markers.insert(human_name, "(adf-clear)")` for an empty/whitespace bare
     ADF-backed field on the edit path.
   The `edit.rs` / `create.rs` table-emit loop reads `field_markers[human_name]` when
   present and renders the marker; `changed_fields` is NEVER written the marker — it holds
   the raw user-supplied input string (JSON channel lossless, #398 invariant unchanged).
   **M-3 ruling — `--dry-run` sentinel mechanism (adversarial pass 12):** Both
   `field_markers` population sites fire on the `--dry-run` code path (the same platform
   resolution functions — `dispatch_field_value` and `resolve_against_editmeta` — both
   execute during dry-run exactly as on the live path). The `edit.rs` dry-run table-emit
   loop ALSO consults `field_markers[human_name]` when rendering the planned-preview row,
   displaying `(adf)` for a non-empty ADF-backed field and `(adf-clear)` for the
   empty-clear case rather than the raw value or the ADF object from `planned_preview`.
   The authoritative source for the sentinel display on BOTH the live and dry-run paths
   is `field_markers`. An implementer MUST NOT use a `planned_preview`-inspection rule
   (e.g., inspect whether `planned_preview[human_name]["content"]` is an empty vs
   non-empty array to decide between `(adf-clear)` and `(adf)`) — that inspection rule
   is fragile: a future ADF doc with an empty `content` array for non-clear reasons
   would be misclassified, and it duplicates logic already captured in `field_markers`.
   The `field_markers` side-channel is the single source of truth for marker rendering.
   **Priority rule (F-2 resolution — BC-3.4.035 product-owner fix):** The emit loop MUST
   consult `field_markers` BEFORE the legacy `if field == "description" { "(updated)" }`
   hard-code. `--field description=VALUE` (ADF path via `field_markers`) renders `(adf)`
   in the table — NOT `(updated)`. The `(updated)` hard-code fires ONLY for the dedicated
   `--description` FLAG path, which does NOT touch `field_markers`. `--field description=`
   with an empty value (clear path) renders `(adf-clear)` from `field_markers`, not the raw
   empty string and not `(updated)`.
   **Product-owner fix (BC-3.4.035):** BC-3.4.035 must state that `--field description=VALUE`
   (used without the dedicated `--description` flag) shows `(adf)` (non-empty) or
   `(adf-clear)` (empty) in the table — NOT `(updated)`. The `(updated)` marker is reserved
   for the `--description` FLAG path only, and the two paths are mutually exclusive at
   execution time (Gate B in `handle_edit` blocks `--description` + `--field description=`
   together; `--field description=` alone is a reachable ADF path per M3).

10. **Createmeta → `EditMetaFieldSchema` adaptation fidelity — `system`/`custom` preserved
    (MEDIUM-3 — FIRM F4 AC; broadened by pass-13 MEDIUM-1a to cover BC-3.3.014 system-field
    path in addition to BC-3.3.013 `:textarea` path):** `resolve_against_createmeta` obtains
    field metadata from `get_createmeta_fields` (the `GET
    .../createmeta/{proj}/issuetypes/{itid}` endpoint). The `EditMetaFieldSchema` deserialized
    from the response MUST populate `system` and `custom` from the API's
    `schema.system`/`schema.custom` keys respectively. A lossy deserialization that replaces
    absent keys with empty strings (rather than `None`) or silently drops these fields causes
    `is_adf_field` to return `false` for ADF-backed fields. `schema.system` fidelity is even
    more critical than `schema.custom` fidelity: the system-field ADF detection path
    (`description`/`environment`) depends on `system` surviving as `Some(...)` not `""`.
    F4 Story 1 MUST include an example-based integration test that:
    (a) constructs a createmeta response containing BOTH a `:textarea` custom field
        (`"schema": {"type": "string", "custom": "…:textarea"}`) AND a `description` or
        `environment` system field (`"schema": {"type": "string", "system": "environment"}`);
    (b) calls `resolve_against_createmeta` with a non-empty bare `--field NAME=VALUE`
        targeting EACH of those fields (one `:textarea` sub-case and one system-field
        sub-case — both sub-cases must be individually asserted within the same test or
        as two named sub-tests);
    (c) asserts that `is_adf_field` fired for EACH (i.e., the output value is an ADF
        object, not `Value::String`) — both the `:textarea` custom-field adaptation path
        (BC-3.3.013 fidelity) AND the `schema.system`-based system-field adaptation path
        (BC-3.3.014 fidelity) must be individually confirmed.
    This test pins end-to-end adaptation fidelity for BOTH BC-3.3.013 (`:textarea` custom
    field) and BC-3.3.014 (system-field `description`/`environment`): API response →
    `EditMetaFieldSchema` → `is_adf_field` → ADF output. A mutant that changes the serde
    deserialization to use `""` instead of `None` for missing `system`/`custom` keys would
    cause (c) to fail for the affected path: `is_adf_field` returns `false`, the output is
    `Value::String`, not an ADF doc.
    Suggested name: `test_bc_3_3_013_014_createmeta_adaptation_preserves_system_custom_for_adf_detection`.
    (Pass-13 MEDIUM-1a change: the prior "and/or" in clause (a) allowed an implementer to
    verify only the `:textarea` sub-case and silently skip the system-field sub-case. Changed
    to "and" + explicit dual sub-case requirement so both BC-3.3.013 custom-field and
    BC-3.3.014 system-field adaptation paths are verified end-to-end. The test name is
    updated to reference both BCs. The previously referenced test name
    `test_bc_3_3_013_createmeta_adaptation_preserves_system_custom_for_adf_detection` is
    superseded by this broader name.)
    This AC is derived from the MEDIUM-3 ruling (ADR-0024 Decision section, added
    2026-09-13); the product-owner must add the "adapted schema" fidelity precondition to
    BOTH BC-3.3.013 preconditions (already done — see §7) AND BC-3.3.014 preconditions
    (pass-13 MEDIUM-1a addition — see pass-13 product-owner instructions in §7 for the
    required BC-3.3.014 precondition text).

11. **VP-578-015 carve-out verification — FIRM F4 AC (HIGH-1 follow-up):** Before
    merging Story 2, the F4 implementer MUST verify VP-578-015's regression fixtures:
    (a) inspect the VP-578-015 test(s) in `tests/issue_create_jsm.rs` and confirm that
        the bare `--field NAME=VALUE` assertions use field_ids that are NOT in the ADF
        allowlist (not `description`, not `environment`, not any `:textarea` custom field);
    (b) if any fixture does use an ADF-backed field_id via `--field`, update that fixture
        to assert ADF output (not string-wrap) and add a comment citing the cycle-012
        carve-out (§7 of this delta);
    (c) confirm that VP-578-015's non-ADF-backed fixture fields still produce byte-identical
        string-wrap output after cycle-012 lands, keeping the regression pin intact.
    VP-578-015 is NOT retired; its scope is narrowed to non-ADF-backed field_ids (see §7
    for the full carve-out ruling). This is a one-time F4 audit step, not an ongoing
    obligation.
    (d) **New-GET collision audit (M-3 — FIRM F4 AC):** Because VP-578-015's regression
        fixtures in `tests/issue_create_jsm.rs` exercise BARE `--field NAME=VALUE` JSM
        creates, the new `GET .../requesttype/{id}/field` fetch added by §5 item 6 WILL
        fire on those exact bare-form test paths. **Hinted-only fixtures do NOT trigger
        the GET** — per the M-2 gate correction (pass-19), the fields-fetch is gated on
        ≥1 BARE (`kind.is_none()`) pair; a hinted-only invocation (e.g., `--field cf:id=5`
        with no bare pairs) issues no fields-fetch GET and therefore creates no collision
        with this audit. Only fixtures that include at least one bare `--field NAME=VALUE`
        pair are in scope for sub-clauses (i)–(iii) below. Before merging Story 2, the F4
        implementer MUST:
        (i) confirm each VP-578-015 bare-form fixture either mocks the new
            `requesttype/{id}/field` GET endpoint (returning a suitable
            `RequestTypeFieldsResponse`) OR deliberately exercises the fail-open path
            (no mock registered → network failure → `warning:` on stderr, plain-string
            fallback) — whichever path the fixture is designed to exercise must be the
            path that actually runs;
        (ii) confirm no `.expect(N)`/exact-request-count assertion in those fixtures is
             invalidated by the injected GET (the new GET is an extra request that was
             not present in the original fixture setup);
        (iii) confirm no `stderr-clean` or "no warnings" assertion in those fixtures is
              invalidated by the fail-open `warning:` emitted when the new GET has no
              mock registered.
        If any VP-578-015 fixture is broken by (ii) or (iii), update the fixture to
        account for the new GET (add a wiremock stub for it, or relax the count/stderr
        assertion with a comment citing this clause) — do NOT silently weaken the
        fixture's ADF-output or JSON-key assertions.

12. **EC-3.8.019-4 rewrite — required before F3 story authoring (MEDIUM-2 — product-owner
    obligation):** The current EC-3.8.019-4 text claims the EC-3.8.019-2 fetch-failed
    warning mitigates the `--description` + `--field description=VALUE` overwrite
    interaction. This framing is incorrect: the warning fires only on fetch-failed paths;
    it does not prevent or specifically identify the overwrite. The product-owner MUST
    rewrite EC-3.8.019-4 to the following (or equivalent):

    > **(EC-3.8.019-4) `--description` + `--field description=VALUE` simultaneous use —
    > `self.description` deterministically supersedes (assembly-order), no guard (MEDIUM-2):** When both `--description X` and
    > `--field description=Y` are supplied on the same `jr issue create --request-type`
    > invocation, both target `requestFieldValues["description"]` in the POST body.
    > `JsmRequestBuilder::build()` unconditionally writes the ADF object for
    > `self.description` (BC-3.8.006 channel); the resolution layer in `jsm_create.rs`
    > also writes `requestFieldValues["description"]` from the `--field description=Y`
    > path (as ADF when metadata is available, or as `Value::String(Y)` under the
    > EC-3.8.019-2 fail-open fallback when the fetch failed). `self.description`
    > deterministically supersedes the `requestFieldValues["description"]` extra-field
    > entry per the assembly-order rule below (EC-3.8.019-4 assembly-order constraint,
    > pass-13 MEDIUM-3): `build()` writes `self.description`'s ADF AFTER ALL
    > resolution-layer writes to `requestFieldValues["description"]`, regardless of the
    > DQ-6 option chosen.
    > No JSM-side collision guard exists (deferred per ADR-0024 MEDIUM-2 ruling); no
    > dedicated diagnostic is emitted for this specific combination. The EC-3.8.019-2
    > fetch-failed warning is ORTHOGONAL — it fires only when the metadata fetch itself
    > failed, not specifically because both flags were supplied. To avoid ambiguity,
    > supply EITHER `--description X` OR `--field description=Y` on a single invocation,
    > not both.

    This rewrite is required at F2 (product-owner applies it to bc-3-issue-write.md
    before the F3 story-writer runs); the ADR-0024 MEDIUM-2 ruling (added 2026-09-13)
    is the authoritative design basis.

13. **BC-3.8.006 ABSENT-check strictness fix — FIRM F4 AC (VP-FIELD-ADF-004 Axis (c)
    enforcement; TWO sibling locations: `src/api/jsm/requests.rs` ~lines 335–338 proptest
    AND `tests/issue_create_jsm.rs` ~lines 823–831 integration test
    `test_jsm_create_plain_description_absent_when_no_description_flag`; these two are the
    complete set of existing-code ABSENT-enforcement targets):**
    Two pre-existing tests carry the lax `.unwrap_or(false)` form that treats BOTH a MISSING
    key AND an explicit `"isAdfRequest": false` value as passing the assertion. Neither kills
    a mutant inserting `"isAdfRequest": false` on the negative path — directly contradicting
    VP-FIELD-ADF-004 Axis (c)'s ABSENT canonical ruling (the key must be OMITTED entirely,
    NOT emitted as explicit `false`; see §4 Axis (c) and the pass-14 M-1 narrowing). Both
    are LIVE VP GAPS in the pre-existing test suite.

    **Location 1 — `src/api/jsm/requests.rs` ~lines 335–338 (proptest):**
    ```rust
    let is_adf = body.get("isAdfRequest").and_then(Value::as_bool).unwrap_or(false);
    prop_assert!(!is_adf, "... absent/false ...");
    ```

    **Location 2 — `tests/issue_create_jsm.rs` ~lines 823–831, integration test
    `test_jsm_create_plain_description_absent_when_no_description_flag`:**
    ```rust
    let is_adf = body.get("isAdfRequest").and_then(Value::as_bool).unwrap_or(false);
    assert!(!is_adf, "BC-3.8.006: isAdfRequest must be absent or false when --description not set; …");
    ```
    The `.unwrap_or(false)` + "absent or false" wording is stale relative to the canonical
    ABSENT ruling: a `Value::Bool(false)` mutant passes it unchanged.

    **F4 Story 2 MUST replace BOTH absence-checks in the SAME commit with the strict form:**

    Location 1 replacement (proptest in `src/api/jsm/requests.rs`):
    ```rust
    prop_assert!(
        body.get("isAdfRequest").is_none(),
        "isAdfRequest must be ABSENT (NOT explicit false) when no ADF value is present"
    );
    ```

    Location 2 replacement (integration test in `tests/issue_create_jsm.rs`):
    ```rust
    assert!(
        body.get("isAdfRequest").is_none(),
        "BC-3.8.006: isAdfRequest must be ABSENT (NOT explicit false) when --description not set; …"
    );
    ```

    In the same commit:
    - **Remove** the old `.unwrap_or(false)` form from BOTH locations entirely (this is a
      REPLACEMENT, not an addition alongside the old assertions).
    - **Fix** the stale comment/message text in BOTH locations from `"absent/false"` /
      `"absent or false"` to `"ABSENT (NOT explicit false)"` to match the canonical ruling.
    - These two locations are the **complete set** of existing-code ABSENT-enforcement
      targets; the sweep is provably complete once both are replaced.

    This is the enforcement teeth for the ABSENT ruling in existing code. Without this fix,
    a mutant inserting `"isAdfRequest": false` passes both pre-existing tests, bypasses
    Axis (c)'s kill requirement, and constitutes a live VP coverage gap that no other test
    closes. **Do NOT change source code as part of F2 spec work** — this item captures the
    obligation for F4. This item is a FIRM MUST F4 AC for Story 2 and MUST appear as a
    named, lettered, or numbered AC in the F3 story body so the orchestrator and gate
    reviewers can track it independently of the other VP-FIELD-ADF-004 axes.

14. **[APPLIED — product-owner updated Step 6 of the Canonical Guard Ordering block at F2 spec finalization; see `bc-3-issue-write.md` §BC-3.8.017 Canonical Guard Ordering block (pass-28 LOW-1)] Canonical Guard Ordering SSoT block — FIRM product-owner obligation for Story-2 spec
    finalization (MEDIUM-1 resolution):**
    The "Canonical Guard Ordering — `handle_jsm_create`" block in `bc-3-issue-write.md`
    declares itself the **SINGLE SOURCE OF TRUTH** for the complete guard/HTTP ordering in
    `handle_jsm_create` and mandates "When changing any step, update ONLY this block."
    Step 6 of that block previously ended `…→ parse_field_kv → POST` — it did not enumerate
    the new requesttype-fields fetch (§5 item 6) or the fail-open `warning:` step added by
    cycle-012. This item is APPLIED: the product-owner updated the Canonical Guard Ordering
    block in `bc-3-issue-write.md` during F2 spec finalization; the block now carries the
    verbatim fetch+warning update from the replacement text below. The F3 story-writer MUST
    NOT re-apply this update.

    **The product-owner COMPLETED updating step 6 of the Canonical Guard Ordering block in
    `bc-3-issue-write.md` as part of Story-2 spec finalization.** The verbatim replacement text for step 6 is:

    > **Step 6 (verbatim replacement):** Numeric-bypass check →
    > `resolve_jsm_request_type_id` (non-numeric input) → summary resolution, then
    > description resolution (both in `handle_jsm_create`, after request-type resolution;
    > BC-3.8.018 mention-resolution is order-independent with the fields-fetch below —
    > both are pre-`build()` with disjoint inputs) → `parse_field_kv` → [when ≥1 bare
    > (`kind.is_none()`) `--field` pair is present:
    > `read_request_type_fields_cache`/`write_request_type_fields_cache` +
    > `GET .../requesttype/{id}/field` (comes after request-type resolution, which is
    > after `require_service_desk` step 4); on fetch failure emit the single global
    > fail-open `warning:` (`warning: could not fetch request type fields — ADF-backed
    > --field values will be sent as plain strings`) and continue — fail-open, never
    > exits] → POST.

    The update MUST NOT alter any other step (0–5), the closing paragraph ("Guards 1 and 2
    fire after project-key resolution…"), or any other part of the SSoT block. The
    fields-fetch step is correctly positioned in step 6 AFTER `require_service_desk`
    (step 4) and AFTER request-type NAME-to-id resolution — consistent with §5 item 6's
    L-3 ordering pin. This is a **FIRM** Story-2 spec-finalization obligation; the SSoT
    block must be accurate before story authoring and before F4 implementation begin.

15. **EC-3.3.014-5 — platform create `--markdown` + `--field description=VALUE` — SUPERSEDED by F2-gate uniform-exit-64 decision (pass-28 MEDIUM-2 initial resolution → AMENDED by F2-gate human decision; APPLIED: `bc-3-issue-write.md` line ~1004 already reflects the current EC text):** The DQ-1 Option A "silently ignored / flagged for human confirmation at the F2 gate" framing recorded in the original pass-28 MEDIUM-2 resolution is **SUPERSEDED** by the F2-gate human design decision (ADR-0024 amended LOW-1, 2026-09-13). The current authoritative EC-3.3.014-5 text in `bc-3-issue-write.md` mandates **uniform exit-64**, consistent with EC-3.4.035-3 (platform edit) and BC-3.8.017 (JSM create):

    > **(EC-3.3.014-5) `--field description=VALUE --markdown` on platform create — uniform exit-64 (F2-gate human design decision, supersedes DQ-1 Option A framing):** `--markdown` combined with a `--field` token whose raw key (substring before the first `=`, no trimming, no case-folding) is EXACTLY `"description"` → exit 64 with a message containing the pinned substring `` "cannot be combined with `--markdown`" ``, followed by the remediation "Pass `--description` with `--markdown`, or omit `--markdown`." This is a **NET-NEW guard** for the platform create path (F4 implementation obligation in `src/cli/issue/create.rs::handle_create` — this guard does not currently exist; F4 Story 1 or a dedicated fix story MUST add it as step 2c, after the D2 collision guard and before step 4b createmeta resolution). Guard is zero-HTTP. The raw key detection is case-SENSITIVE, no-trim, identical to BC-3.8.017's mechanism; `--field Description=X` (key `Description`) does NOT trigger this guard. This is one of three uniform-exit-64 paths: EC-3.3.014-5 (platform create, NET-NEW), EC-3.4.035-3 (platform edit, guard extension), BC-3.8.017 (JSM create, pre-existing). All three paths share the `` "cannot be combined with `--markdown`" `` pinned substring. F4 test: VP-FIELD-ADF-004 Axis (h1).

    **No new BC, no new VP.** EC-3.3.014-5 is an EC (edge case), not a BC; the BC-769 count is unchanged. VP-FIELD-ADF-004 Axis (h1) is the F4 test obligation for this guard (§4 VP-004 Axis (h), §5 item 18). The product-owner reconciles any per-BC EC-count frontmatter; ADR-0024 amended LOW-1 is the authoritative design basis. **No residual "silently ignored" / "DQ-1 Option A" / "flagged for human confirmation at the F2 gate" language applies to the `--markdown`+`--field description=` combination on any of the three write paths after this amendment.**

16. **VP-FIELD-ADF-003 Axis G — platform-create empty-omit POST-body wiremock test —
    FIRM MUST F4 AC (M-2 pass-31 addition):** F4 Story 1 MUST include a wiremock/CLI-level
    integration test that drives `jr issue create --field <ADF-BACKED-FIELD>=` (empty value)
    through `resolve_against_createmeta` with a wiremock-stubbed createmeta response and
    asserts the constructed POST `fields` map contains NO key for the ADF-backed field.

    **Why this item is a separate F4 AC (not subsumed by Axis B or item 10):**
    Axis B (§4 VP-003) targets the extracted pure empty-value decision code and explicitly
    disclaims `resolve_against_createmeta`'s caller-level `fields`-map omission. Item 10
    (createmeta adaptation fidelity) asserts that ADF detection fires for NON-EMPTY values;
    it does not cover the empty-value omit path. A mutant in `resolve_against_createmeta`
    that ignores the omit signal — inserting `Value::String("")` or a clear-doc value for an
    empty ADF-backed field instead of skipping the `fields` insert — would pass both Axis B
    and item 10, reproduce the JRACLOUD-79318 400 in production on the create path, and go
    uncaught without this item. Axis C covers the JSM create-path omit; this item covers the
    symmetric platform create-path omit.

    **Required test:** `test_bc_3_3_015_create_empty_adf_field_omitted_from_post_body`
    - Wire up `JiraClient::new_for_test` + `MockServer`.
    - Register a wiremock stub for `GET .../createmeta/{proj}/issuetypes/{itid}` returning
      a field entry with an ADF-backed schema (e.g. `"schema":{"type":"string","system":"environment"}`
      or a `:textarea` custom field).
    - Run `jr issue create --project P --type T --summary S --field environment=` (empty value).
    - Intercept the `POST .../issue` request body and assert
      `body["fields"]["environment"]` is ABSENT (the key must not appear at all, not
      `null`, not `""`, not a clear-doc or empty-ADF object).
    - OPTIONAL but recommended: a parallel sub-assertion that `--field environment=hello`
      (non-empty) IS present in the POST body as an ADF doc (regression pin that the
      omit logic is conditional on empty, not unconditional).

    **Mechanism:** wiremock/CLI-level (NOT no-network unit test). Follows the
    `JiraClient::new_for_test` + `MockServer` pattern established by item 10's
    `test_bc_3_3_013_014_createmeta_adaptation_preserves_system_custom_for_adf_detection`
    and item 7's JSM metadata-acquisition wiremock tests.

    **Gate tracking:** This AC must appear as a named, numbered item in the F3 Story 1
    AC section so the orchestrator and gate reviewers can tick it off independently of
    item 10's adaptation-fidelity AC. Skipping it leaves a live mutant gap on the
    platform-create empty-omit path (parallel to the gap M-2 identified).

17. **Dry-run TABLE-mode sentinel axes — FIRM F4 AC (M-1 pass-32 addition; VP-FIELD-ADF-002
    dry-run table-mode axis + VP-FIELD-ADF-003 Axis H):** The `field_markers` side-channel
    (§5 item 9) is populated on BOTH the live and dry-run paths by the same platform
    resolution functions. The `edit.rs` dry-run table-emit loop ALSO consults
    `field_markers[human_name]` when rendering a planned-preview row. Two axes pin this
    sentinel behavior and kill the M-3 anti-pattern mutant class (content-shape inspection
    as a proxy for `field_markers`):

    **VP-FIELD-ADF-002 dry-run table-mode axis (`test_bc_3_4_033_dry_run_table_shows_adf_marker`):**
    For `--dry-run` on the platform edit path with a NON-EMPTY ADF-backed field:
    - The TABLE cell for the field MUST display `"(adf)"`.
    - The marker comes from `field_markers[human_name]` — NOT from inspecting the ADF
      object stored in `planned_preview[human_name]`.
    - The mechanism: `dispatch_field_value`'s ADF branch populates
      `field_markers.insert(human_name, "(adf)")` on the dry-run path (the same function
      executes during dry-run as live); the dry-run table-emit loop reads `field_markers`
      first.
    - A mutant that skips `field_markers` population on the dry-run path (treating dry-run
      as non-populating) or that renders the ADF object directly in the table FAILS RED.
    - A mutant that uses `planned_preview[human_name]["content"].is_empty() == false` to
      decide between `(adf)` and `(adf-clear)` (M-3 anti-pattern) is separately killed —
      the test asserts the mechanism, not just the outcome.
    - **Technique:** wiremock/CLI-level (same class as the existing dry-run JSON axis —
      requires a `JiraClient::new_for_test` + `MockServer` and the full `issue edit`
      pipeline including the editmeta HTTP fetch).
    - **Gate:** MUST pass GREEN before Story 1 closes at F4. The existing dry-run JSON
      axis (`test_bc_3_4_033_dry_run_planned_preview_contains_adf_object_keyed_by_human_name`)
      does NOT cover this TABLE rendering — it pins the `planned_preview` VALUE, not the
      table cell display.

    **VP-FIELD-ADF-003 Axis H (`test_bc_3_4_036_dry_run_table_shows_adf_clear_sentinel_from_field_markers`):**
    For `--dry-run` on the platform edit path with an EMPTY/WHITESPACE ADF-backed field:
    - The TABLE cell for the field MUST display `"(adf-clear)"`.
    - The marker comes from `field_markers[human_name]` (populated by
      `resolve_against_editmeta`'s empty-clear pre-check: `field_markers.insert(human_name,
      "(adf-clear)")`), NOT from `planned_preview` content-shape inspection (M-3
      anti-pattern rejection).
    - A mutant that skips `field_markers` population in `resolve_against_editmeta` on the
      dry-run path FAILS RED — the table-emit loop falls through and renders the raw
      empty/whitespace string.
    - A mutant that infers the sentinel by inspecting `planned_preview[human_name]["content"].is_empty()`
      instead of reading `field_markers` FAILS RED against a non-clear ADF doc with an
      empty content array for other reasons.
    - **Technique:** wiremock/CLI-level (same class as Axis E — requires a
      `JiraClient::new_for_test` + `MockServer` and the full `issue edit` pipeline).
    - **Gate:** MUST pass GREEN before Story 1 closes at F4. Axis E
      (`test_bc_3_4_036_dry_run_planned_preview_contains_clear_doc_keyed_by_human_name`)
      does NOT cover this TABLE rendering — it pins the `planned_preview` VALUE (the
      clear-doc object), not the table cell display.

    **Mutual reinforcement:** VP-002's table-mode axis + VP-003 Axis H are PAIRED. A
    mutant that causes the dry-run table-emit loop to display `(adf)` for the clear-doc
    case (by reading `field_markers` but misrouting) is caught by Axis H (expects
    `(adf-clear)` not `(adf)`). A mutant that skips `field_markers` for the non-empty
    case is caught by VP-002's table-mode axis.

    **Gate tracking:** Both tests MUST appear as named, numbered ACs in the F3 Story 1
    AC section so the orchestrator and gate reviewers can tick them off independently.
    Skipping either leaves the M-3 anti-pattern (content-shape inspection as a proxy for
    `field_markers`) unkilled on the dry-run table path.

18. **VP-FIELD-ADF-004 Axis (h1)/(h2) — uniform exit-64 for `--markdown + --field description=` on PLATFORM paths — FIRM F4 AC (F2-gate, 2026-09-13; VP count stays at 86 — axis extension within VP-FIELD-ADF-004, not a new VP):**
    Both platform guards are currently RED and are F4 implementation obligations:
    - **Axis (h1):** `src/cli/issue/create.rs::handle_create` step 2c (NET-NEW guard; EC-3.3.014-5).
    - **Axis (h2):** `src/cli/issue/edit.rs::handle_edit` (guard extension before existing `--markdown`-requires-description guard; EC-3.4.035-3).
    Both guards fire BEFORE any HTTP call (h1 before createmeta; h2 before editmeta). Test mechanism: CLI-level subprocess, `assert!(stderr.contains("cannot be combined with \`--markdown\`"))` + `assert_eq!(exit_code, 64)` + `assert!(stdout.trim().is_empty())`. See §4 VP-FIELD-ADF-004 Axis (h) for full assertions and RED-proof entries.

    **Test names:** `test_bc_3_3_014_5_markdown_field_description_conflict_exits_64_create` (h1); `test_bc_3_4_035_3_markdown_field_description_conflict_exits_64_edit` (h2).

    **ADR reference:** ADR-0024 amended LOW-1 (guard ordering for platform edit and create). EC-3.3.014-5 is the BC-side spec for h1; EC-3.4.035-3 for h2; BC-3.8.017 covers the pre-existing JSM guard (no change required there).

    **Gate tracking:** Both tests MUST appear as named, numbered ACs in the F3 Story 1 AC section (or a dedicated fix-story if the guards are extracted from Story 1) so the orchestrator and gate reviewers can tick them off independently of the VP-004 JSM axes tracked by OBS-1. These are PLATFORM-PATH guards (Story 1 scope), NOT Story 2 / JSM-path obligations. VP count remains 86.

---

## 6. Out-of-Scope Items (documented non-omissions)

- **`:markdown` HINT form for `--field`:** `text_to_adf` (plain text) is the
  only conversion mechanism this cycle. A per-field `:markdown` hint-syntax form
  (e.g. `--field description:markdown=…`) is explicitly deferred (DQ-1 closed as
  Option A). No VP covers this hint form — it does not exist. This is distinct from
  the `--markdown` FLAG combined with `--field description=…`, which is governed and
  exits 64 (EC-3.3.014-5 / EC-3.4.035-3 / BC-3.8.017).
- **Dry-run `planned_preview` shape for ADF `--field` values (O6, BC-3.4.033/036
  — F-4 fix — VP AXES FOLDED INTO §4, obs-2):** The dry-run behavior (ADF object in
  `planned_preview` for non-empty; `(adf-clear)` sentinel in table mode /
  `{"type":"doc","version":1,"content":[]}` for the edit-clear case in JSON mode) is
  NOT deterministic from VP-FIELD-ADF-002. VP-002 asserts the `outputs.fields[field_id]`
  write (the wire ADF object), not the `planned_preview` map entry. The bare-form path
  currently writes a SIMPLIFIED DISPLAY STRING to `planned_preview` via
  `src/cli/issue/field_resolve.rs::dispatch_field_value`'s string/text arm (the
  display-string insert lives in `dispatch_field_value`, NOT in `resolve_against_editmeta`;
  only the empty-clear pre-check belongs in `resolve_against_editmeta` /
  `resolve_against_createmeta`); ADF-backed fields require a NEW special case in
  `dispatch_field_value`'s ADF branch that writes the wire ADF object to
  `planned_preview` instead of a display string. VP axes for this behavior have been
  folded into §4 (obs-2):
  - **JSON channel `planned_preview` shape:** VP-FIELD-ADF-002 dry-run axis
    (`test_bc_3_4_033_dry_run_planned_preview_contains_adf_object_keyed_by_human_name`)
    pins the ADF object in `planned_preview[human_name]` for non-empty dry-run;
    VP-FIELD-ADF-003 Axis E
    (`test_bc_3_4_036_dry_run_planned_preview_contains_clear_doc_keyed_by_human_name`)
    pins the clear-doc object in `planned_preview[human_name]` for the edit-clear
    dry-run. These are JSON-channel axes — they pin the `planned_preview` VALUE, NOT the
    TABLE cell display.
  - **TABLE-mode sentinel display:** VP-FIELD-ADF-002 dry-run table-mode axis
    (`test_bc_3_4_033_dry_run_table_shows_adf_marker`) pins the `(adf)` TABLE cell
    display for non-empty dry-run; VP-FIELD-ADF-003 Axis H
    (`test_bc_3_4_036_dry_run_table_shows_adf_clear_sentinel_from_field_markers`) pins
    the `(adf-clear)` TABLE cell display for the edit-clear dry-run. These are DISTINCT
    consult sites per the M-3 ruling (§5 item 9): the TABLE sentinel is derived from
    `field_markers`, NOT from `planned_preview` content-shape inspection. The prior
    "obs-2 folded into §4" claim covered only the JSON-channel `planned_preview` axes;
    the TABLE-mode sentinel axes are added by the pass-32 M-1 resolution (§5 item 17).
  The authoritative definitions are in §4; the BC citations now resolve to those §4 VP
  axes.
  Key `planned_preview` key convention (F-2 — PASS-7 correction):
  - `planned_preview[human_name]` is the ADF `serde_json::Value` object for non-empty
    bare ADF inputs (not a simplified display string) — `planned_preview` is keyed by
    `human_name` (display name), NOT `field_id`;
  - `planned_preview[human_name]` is `{"type":"doc","version":1,"content":[]}` for the
    edit-clear case (empty ADF-backed field on the edit path, BC-3.4.036) — same key
    convention.
  **Product-owner fixes (F-2):** BC-3.4.033, BC-3.4.035, and BC-3.4.036 postconditions
  and dry-run sections that reference `planned_preview[field_id]` must be updated to
  `planned_preview[human_name]`. The F3 story AC and the F4 dry-run test must target
  `planned_preview` values for ADF fields specifically — not just the top-level
  dispatch return value.
- **`@mentions` in `--field` ADF values (O1):** `text_to_adf` does not resolve
  `@mentions`. A `--field environment="@Alice"` writes literal text. This is
  accepted behavior, not a gap.

---

## 7. VP-578-015 Reconciliation — cycle-012 Carve-Out (HIGH-1 resolution)

**Background.** VP-578-015 (cycle-002 / S-578-3) is a relative byte-identity claim:
"bare (unhinted) `--field NAME=VALUE` on the JSM create path produces BYTE-IDENTICAL
`requestFieldValues` wire output before and after the S-578-3 amendment." It was authored
to pin that adding hint-kind dispatch (`:id`/`:name`/`:asset`) did not alter the bare-form
string-wrap path for non-hinted fields. VP-578-015's regression tests live in
`tests/issue_create_jsm.rs` and assert the full `requestFieldValues` map shape for bare
`--field` calls (fix added in PR #742 commit 29300a3b per the B2 finding).

**Cycle-012 interaction.** Cycle-012 selectively changes bare-form behavior for ADF-backed
field_ids (`description`, `environment`, and any `customfield_NNNNN` whose
`jira_schema.custom` ends with `:textarea`). For these field_ids a bare
`--field FIELD_ID=VALUE` on the JSM create path now produces an ADF object in
`requestFieldValues` via the resolution layer in `jsm_create.rs` — NOT the former
string-wrap. This is a deliberate fix: the former string-wrap was the 400-producing bug.

**Fixture assessment.** VP-578-015's regression tests pin the wire shape of
`requestFieldValues` for bare `--field` extra fields. From the S-578-3 burst log:
"BC-3.8.005..007's `summary`/`description`/`priority`/`labels` keys, which sit in the
same `rfv` map, are UNTOUCHED by this amendment" — this parenthetical confirms those
keys come from the DEDICATED flags (`--description`, `--summary`, etc., set via
`JsmRequestBuilder.description` and so on), NOT from `--field` extra fields. VP-578-015's
fixture's bare `--field` assertion therefore most likely uses a non-ADF-backed field_id
(a generic custom field, not `description`/`environment`/`:textarea`). Assessment:
**no real regression conflict is expected**, but this MUST be confirmed at F4 (item 11
in §5).

**RULING — carve-out, not retirement.** VP-578-015 is amended in-scope to carve out
ADF-backed field_ids:

> **[AMENDED 2026-09-13 cycle-012 `field-adf-autoconvert`] ADF-backed field_id
> carve-out.** VP-578-015's byte-identity (string-wrap) claim applies to bare
> `--field NAME=VALUE` pairs on the JSM create path where NAME is NOT in the ADF
> allowlist — that is, NAME is NOT `description`, NOT `environment`, and NOT any
> `customfield_NNNNN` whose `jira_schema.custom` ends with `:textarea`. For
> ADF-backed field_ids, a bare `--field NAME=VALUE` now produces an ADF object in
> `requestFieldValues` after cycle-012 (BC-3.8.019, BC-3.8.020) — not a string-wrap.
> VP-578-015 remains valid and is NOT retired; its scope is narrowed to non-ADF-backed
> field_ids on the JSM bare-form path.

This carve-out language must also be added to BC-3.8.008 by the product-owner as a
dated amendment blockquote. **Required BC-3.8.008 amendment text** (product-owner
inserts this immediately after the existing S-578-3 amendment, mirroring the amendment
blockquote style at bc-3-issue-write.md §BC-3.8.008):

> **[AMENDED 2026-09-13 cycle-012 `field-adf-autoconvert`] ADF-backed field_id
> carve-out.** The bare-form unconditional string-wrap rule in this BC applies only
> to field_ids that are NOT in the ADF allowlist. When a bare `--field NAME=VALUE`
> pair targets an ADF-backed field_id — the literal string `description`, the literal
> string `environment`, or any `customfield_NNNNN` whose `jira_schema.custom` ends
> with `:textarea` (determined by `is_adf_field_value` / `is_adf_schema` in
> `src/cli/issue/field_resolve.rs`) — the resolution layer in
> `src/cli/issue/jsm_create.rs` intercepts BEFORE `build()` and converts the value to
> an ADF object via `text_to_adf` (non-empty) or omits the field (empty), consistent
> with BC-3.8.019 (`description` system field) and BC-3.8.020 (`:textarea` custom
> field). Field_ids NOT in the allowlist continue to receive the string-wrap unchanged.
> Under the EC-3.8.019-2/EC-3.8.020-5 fail-open fallback (requesttype-fields fetch
> itself failed), ALL bare `--field` values including ADF-backed ones fall through to
> the string-wrap as a degraded-mode fallback, with the observability warning.
> VP-578-015's byte-identity regression pin remains valid for non-ADF-backed field_ids;
> ADF-backed field_ids are explicitly carved out of VP-578-015's scope (see
> cycle-012 verification delta §7).

**~~BC-3.8.019/020 `(adf)` table-echo postcondition text~~ — MEDIUM-1 RETRACTED (H-1, adversarial pass 12).**

The MEDIUM-1 ruling that BC-3.8.019 and BC-3.8.020 should receive `(adf)` table-echo
postconditions is REVERSED. Ground truth: `src/cli/issue/jsm_create.rs:415-417` shows
`output::print_success("Created request {issue_key}")` is the ONLY table-mode output
on the JSM create path — there is no per-field echo surface. The `field_markers`
side-channel is populated only at PLATFORM-PATH sites in `field_resolve.rs` (§5 item 9),
neither of which is reachable from `jsm_create.rs`.

**Product-owner instruction (H-1):** REMOVE the "Table output (MEDIUM-1)" postconditions
from BC-3.8.019 AND BC-3.8.020 entirely. If useful, add one sentence to each BC noting
that JSM create success output is unchanged from BC-3.8.001 (`Created request <KEY>`
table / `{"key":…}` JSON) — no per-field marker. No new postcondition text is required
to replace the retracted MEDIUM-1 postconditions. The F4 AC test
`test_bc_3_8_019_jsm_create_table_shows_adf_marker` is RETRACTED — do not author it.

**BC-3.3.013 "adapted schema" precondition text** (product-owner adds, MEDIUM-3 ruling):
> **Precondition — adapted schema fidelity:** The `EditMetaFieldSchema` obtained from
> `get_createmeta_fields` for this field MUST have its `system` and `custom` keys
> populated from the createmeta response's `schema.system` and `schema.custom` sub-keys
> respectively. A `system` key absent from the API response maps to `system: None` (not
> an empty string); a `custom` key absent from the API response maps to `custom: None`.
> ADF detection via `is_adf_field` is correct only when this fidelity is maintained.
> Verified end-to-end by `test_bc_3_3_013_014_createmeta_adaptation_preserves_system_custom_for_adf_detection`
> (§5 item 10 of the cycle-012 verification delta).

**VP count impact.** No new VP added and no VP retired. VP-578-015 is amended in-scope
(scope narrowed, not retired). The cycle-012 VP count remains **86**.
