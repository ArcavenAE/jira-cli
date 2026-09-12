---
document_type: f2-verification-delta
phase: phase-f2-spec-evolution
producer: architect (formal-verifier role)
cycle: cycle-012-field-adf-autoconvert
feature: "field-adf-autoconvert"
status: complete
timestamp: 2026-09-12
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
updated_vps: []
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
input-hash: "1152574"
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
| VP-FIELD-ADF-001 | ADF detection predicate is risk-symmetric (fires IFF allowlist match; never misses; never over-fires) | proptest + example-based `#[test]` | 1 (platform) |
| VP-FIELD-ADF-002 | Non-empty ADF field write produces a valid ADF doc (via `text_to_adf`); INV-1 (no raw newline in text nodes) holds — platform path only | proptest + example-based `#[test]` | 1 (platform) |
| VP-FIELD-ADF-003 | Empty-value invariant: auto-wrap path NEVER emits an empty text node; edit → clear-doc; create (platform + JSM) → field omitted | unit `#[test]` (platform: `field_resolve.rs::tests`; JSM: jsm_create.rs resolution layer, DQ-6-gated) | 1 + 2 |
| VP-FIELD-ADF-004 | JSM resolution layer: `is_adf_field_value` detects ADF-backed fields from the inner `jiraSchema` block (no double-nesting); non-empty ADF field → ADF object in `requestFieldValues`; `isAdfRequest` accumulated; empty → omitted + flag not accumulated | unit `#[test]` (Axis a: `field_resolve.rs::tests`; Axes b–e: jsm_create.rs resolution layer, DQ-6-gated) | 2 (JSM) |

**Note on VP-FIELD-ADF-004 (ALLOCATED this delta — adversarial PASS-1 C-1 resolution):**
The JSM BC bodies (BC-3.8.019, BC-3.8.020, BC-3.8.021, BC-3.8.022) cite
`VP-FIELD-ADF-004`. The prior draft deferred allocation; adversarial PASS-1 finding
C-1 identified this as a CRITICAL gap — the JSM RESOLUTION LAYER (`jsm_create.rs`)
implements ADF detection and conversion independently; the platform
`dispatch_field_value` path is not used on the JSM create path, so VP-FIELD-ADF-001
and VP-FIELD-ADF-002 (which target `dispatch_field_value`) do not exercise the
JSM-specific resolution-layer detection, conversion, or `isAdfRequest` accumulation
logic. VP-FIELD-ADF-004 is therefore FULLY ALLOCATED at F2 and covers:
(a) the shared ADF-detection predicate (`is_adf_field_value` in `field_resolve.rs`)
    applied to the inner `jiraSchema` block directly (no phantom double-nesting — see
    §4 VP-FIELD-ADF-004 canonical contract);
(b) positive conversion of a non-empty plain value into an ADF object inside
    `requestFieldValues` via `text_to_adf` in the resolution layer (`jsm_create.rs`);
(c) `isAdfRequest: true` accumulation whenever ANY requestFieldValue is ADF-converted;
(d) empty ADF-backed JSM field → omitted + `isAdfRequest` NOT accumulated (this axis
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
- **Unit `#[test]`** for the empty-value pre-checks in `resolve_against_editmeta`,
  `resolve_against_createmeta`, and the JSM resolution layer in
  `src/cli/issue/jsm_create.rs` (DQ-6-gated — exact function TBD at F4) — these are
  effectful-side units but their inputs are controlled structs with no network I/O,
  so standard unit tests (not wiremock) are the correct mechanism.
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
- The correctness claim is a deterministic unit property on controlled structs.
  Neither formal verification nor fuzzing adds value here.

**0-GAP statement**: skipping Kani and fuzz introduces NO coverage gap relative to
the BC set, because every correctness claim (BC-3.3.013..015, BC-3.4.033..037,
BC-3.8.019..022) is either (a) a universal property captured by proptest over the
ADF detection predicate, (b) a deterministic example-anchored regression, or (c) a
route-specific empty-value unit test. This is a documented substitution, not an
omission.

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
extracts `system`/`custom` before delegating to `is_adf_schema`. An example test
constructs `json!({"system": "description"})` and `json!({"custom": "…:textfield"})`
and asserts the wrapper returns `true` and `false` respectively — confirming the
extraction and delegation path to the shared core.

Suggested name: `test_bc_3_8_019_is_adf_field_value_delegates_to_shared_predicate`

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

**Technique:** proptest + example-based `#[test]`.
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
   returns a `serde_json::Value` that is an OBJECT (not a `Value::String(S)`) — the
   auto-wrap produces an ADF document, never passes the string through unchanged.
2. **ADF structure (non-empty input):** The returned value satisfies `value["type"] == "doc"` and
   `value["version"] == 1` and `value["content"].is_array()`. For any non-empty/non-whitespace
   input `S`, `value["content"]` is a NON-EMPTY array (length ≥ 1) containing ≥1 node of type
   `"paragraph"`, and that paragraph node contains ≥1 node of type `"text"`. The empty ADF doc
   `{"type":"doc","version":1,"content":[]}` is NEVER the output of `dispatch_field_value` for a
   non-empty input — that form is produced exclusively by the edit-clear pre-check in
   `resolve_against_editmeta` (BC-3.4.036). A mutant returning the empty clear-doc for all
   ADF-backed inputs fails this clause: `content.len() == 0` violates the ≥1 paragraph requirement.
   (PASS-7 strengthening — the old `is_array()` check alone was insufficient: an empty array IS
   an array, and INV-1 is vacuous over empty content.)
3. **INV-1 (no raw newline in text nodes, BC-7.2.011):** For any ADF object
   produced by `dispatch_field_value` over any `S`, NO `text` node anywhere in the
   `content` tree contains a raw `\n` or `\r` character in its `text` attribute.
   Multi-line values produce `hardBreak` nodes between lines, not raw newlines in a
   single `text` node.

**proptest shape:**
- `prop_bc_3_4_033_dispatch_field_value_adf_backed_returns_adf_object`: for a
  generator producing non-empty strings `S` (arbitrary printable text, including
  multi-line) and a fixed ADF-backed `EditMetaField` (`:textarea` schema), assert
  properties 1, 2, and 3 above hold on the returned value.
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
  the returned value is `Value::String("Hello world")`, failing property 1. ✓
- Against a mutant calling `text_to_adf` but ignoring INV-1 for multi-line
  (returning a `text` node with an embedded `\n`): the INV-1 proptest assertion
  fails RED. ✓
- Against a mutant returning `json!({"type":"doc","version":1,"content":[]})` for
  all ADF-backed fields (empty doc regardless of content): Property 2's non-empty
  content clause fails — `content` has length 0, failing the ≥1 `paragraph` node
  requirement. (The old `is_array()` check alone would NOT catch this mutant: an
  empty array IS an array. INV-1 is also vacuous over empty content. The
  PASS-7-strengthened Property 2 is what kills this mutant class.) ✓

---

### VP-FIELD-ADF-003 — Empty-Value Invariant: No Empty Text Node; Path-Specific Semantics (unit tests)

**Technique:** unit `#[test]` (no network, no wiremock — all pre-checks operate on
controlled structs before any HTTP).
**Primary modules:**
- Platform edit: `src/cli/issue/field_resolve.rs::resolve_against_editmeta`
- Platform create: `src/cli/issue/field_resolve.rs::resolve_against_createmeta`
- JSM create: resolution layer in `src/cli/issue/jsm_create.rs` (exact function TBD
  at F4, DQ-6-gated; the empty-field is omitted before `JsmRequestBuilder::build()`
  is called — it never reaches the pure assembler)

**Pins:** BC-3.3.015 (create-path omit for empty ADF field), BC-3.4.036 (edit-path
clear-doc for empty ADF field), BC-3.8.021 (JSM create-path omit for empty ADF
field), BC-3.3.014 (referenced via BC-3.3.015 empty-guard dependency), BC-3.4.035
(referenced via BC-3.4.036 empty-guard dependency).

**Property — FOUR test axes (one per path, plus bare-form guard):**

**Axis A — Platform edit, empty value → clear-doc (BC-3.4.036):**
- `resolve_against_editmeta` with an ADF-backed field and `value = ""` (or
  `value = "   "` whitespace-only) sets `fields[field_id]` to the empty ADF doc
  `{"type":"doc","version":1,"content":[]}` and does NOT call `dispatch_field_value`.
- The `fields` map after the call contains exactly `field_id → empty_adf_doc`.
- `fields` does NOT contain any `text` node with `"text": ""` (the JRACLOUD-79318 landmine).
- The same field with a non-empty value goes through the normal dispatch path (regression).

**Axis B — Platform create, empty value → field omitted (BC-3.3.015):**
- `resolve_against_createmeta` with an ADF-backed field and `value = ""` (or
  whitespace-only) does NOT insert ANY entry for `field_id` in the `fields` map.
- The `fields` map after the call does NOT contain `field_id` at all.
- No `text` node with `"text": ""` is produced.
- Asymmetry pin: the SAME empty value sent to a plain-string (non-ADF) field IS
  inserted as `Value::String("")` — the omit logic is ADF-specific, not
  universal (regression pin for non-ADF fields).

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

**Axis D — Empty-guard fires ONLY for bare form (`kind.is_none()`); hinted-kind values bypass it — platform and JSM paths (BC-3.4.033, BC-3.4.036, BC-3.3.015, BC-3.8.019, BC-3.8.021; H-3):**
- `resolve_against_editmeta` with an ADF-backed field, `spec.kind = Some(...)` (any non-None hint kind), and `spec.value = ""` does NOT set the clear-doc and does NOT omit the field — it routes to the hint composer. Whether the composer errors or returns Ok on the empty value is the composer's responsibility; the ADF clear/omit guard does not fire.
- `resolve_against_createmeta` behaves identically: hinted empty values bypass the ADF empty pre-check and route to the hint composer.
- The ADF empty pre-check is gated by `spec.kind.is_none()` in addition to `is_adf_field()`. A hinted kind (`:option`, `:id`, `:name`, `:asset`) opts out of ADF conversion entirely, including the empty pre-check; an empty hinted value is the hint composer's responsibility, not the ADF guard's (BC-3.4.033 — hinted kinds opt out of ADF).
- **JSM path (H-3 — added):** On the JSM create path, the ADF empty pre-check in the
  RESOLUTION LAYER is similarly gated by `spec.kind.is_none()`. A hinted extra field
  (e.g., `customfield_12345:option=`) does NOT trigger the ADF-omit pre-check — the hinted
  value routes to the hint composer's string path regardless of `is_adf_field_value`
  on the `jira_schema`. Concretely: `spec.kind = Some(HintKind::Option)` and
  `spec.value = ""` on an ADF-backed JSM extra field must NOT set
  `requestFieldValues` to an empty ADF doc or omit the field silently — the ADF
  clear/omit guard does not fire; the value routes to the hint composer's return
  path (whether the composer itself errors or succeeds on the empty value is the
  composer's responsibility, independent of the ADF guard). This
  axis verifies that the `kind.is_none()` gate is applied consistently on the JSM
  resolution layer and that ADF detection does not short-circuit the hint path.

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
- `test_bc_3_4_036_resolve_editmeta_empty_adf_field_sets_clear_doc` (Axis A)
- `test_bc_3_3_015_resolve_createmeta_empty_adf_field_omitted` (Axis B)
- `test_bc_3_8_021_jsm_resolution_empty_adf_field_omitted_and_flag_not_accumulated` (Axis C)
- `test_adf_empty_guard_fires_only_on_bare_form_not_hinted` (Axis D)
- `test_bc_3_4_036_live_edit_json_changed_fields_raw_empty_input_not_clear_doc` (Axis F)

**Why this VP exists (JRACLOUD-79318 landmine):** `text_to_adf("")` emits
`{"type":"text","text":""}` — Jira rejects this with a 400. The empty-value
pre-check MUST intercept before `text_to_adf` is called. Without this VP, a mutant
that removes the empty-value guard (or that moves the guard below the `text_to_adf`
call) would produce empty text nodes, which are invisible to VP-FIELD-ADF-001/002
(those only exercise the non-empty path). This VP additionally pins the edit-vs-create
ASYMMETRY (clear-doc vs omit) — a mutant that unifies both paths to either behavior
would be caught by the axis that should produce the other behavior.

**RED proof:**
- Against a mutant removing the empty pre-check in `resolve_against_editmeta`:
  `fields[field_id]` is set by `dispatch_field_value` as an ADF doc with an empty
  `text` node, NOT the clear-doc. Axis A fails RED. ✓
- Against a mutant removing the empty pre-check in `resolve_against_createmeta`:
  `fields[field_id]` is set to some value (via dispatch), NOT absent. Axis B fails
  RED. ✓
- Against a mutant applying edit-path clear-doc to the create path:
  `fields[field_id]` is the empty ADF doc object (not absent). Axis B fails RED
  (expected absent, got a value). ✓
- Against a mutant applying create-path omit to the edit path:
  `fields[field_id]` is absent (not the clear-doc). Axis A fails RED. ✓
- Against a mutant that sets `isAdfRequest = true` even for an omitted empty
  extra field: Axis C fails RED (expected flag NOT set, got `true`). ✓
- Against a mutant removing the `kind.is_none()` guard from the ADF empty
  pre-check so ADF clear/omit fires on hinted-kind empty values too: a hinted
  empty value (e.g., `FIELD:option=`) would trigger ADF pre-check rather than
  routing to the hint composer. Axis D (platform) fails RED — expected
  hint-composer routing (guard not firing), got ADF pre-check routing instead. ✓
- Against a mutant removing the `kind.is_none()` gate on the JSM resolution-layer
  ADF pre-check: a hinted empty value (e.g., `customfield_12345:option=`) on an
  ADF-backed JSM extra field would be omitted (or converted) rather than routing
  to the hint composer. Axis D (JSM sub-case) fails RED — expected
  hint-composer routing (guard not firing), got ADF pre-check routing instead. ✓

---

### VP-FIELD-ADF-004 — JSM Build-Path: Detection, Conversion, Flag Accumulation, and Empty-Omit (unit tests)

**Technique:** unit `#[test]` (no network, no wiremock). Axis (a) targets
`is_adf_field_value` directly with value-constructor inputs and can be authored now.
Axes (b)–(e) target the RESOLUTION LAYER (ADF detection, conversion, and the
metadata-unavailable `warning:` emission belong in the effectful layer that has
client/metadata access — not in the pure `build()` assembler); exact test module
and constructor shape are gated on the DQ-6 resolution (see DQ-6 gate below).
**Primary module:** `src/cli/issue/field_resolve.rs::is_adf_field_value` (shared
detection wrapper — Axis a); the RESOLUTION LAYER (`jsm_create.rs`, exact function
TBD per DQ-6 option a/b) for Axes (b)–(e). ADF detection, `text_to_adf`
conversion, and the metadata-unavailable `warning:` emission all belong in the
resolution layer — the effectful boundary that has client and metadata access.
`build()` receives already-resolved field values and emits no side effects.

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

**DQ-6 gate — F4-AC obligation (LOW-4):** VP-FIELD-ADF-004 axes (b), (c), (d), and
(e) cannot be authored as runnable tests until the DQ-6 type/signature decision lands
at F4. The DQ-6 LAYER QUESTION IS SETTLED: `isAdfRequest` (for the `--field`
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
assertion target for axes (b)–(e). Axis (e)'s `warning:` assertion MUST target the
RESOLUTION LAYER — not `build()`, which is pure and has no stderr access. F4 Story
2's acceptance criteria MUST explicitly gate VP-FIELD-ADF-004 test authoring on the
DQ-6 resolution; this VP must not be silently skipped. The VP is fully allocated at
F2; gating is on execution, not definition.

**Property — FIVE axes:**

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

Suggested name: `test_bc_3_8_020_jsm_resolution_adf_field_converts_to_adf_object_in_request_field_values`

**Axis (c) — `isAdfRequest: true` accumulated for any ADF-converted extra field (BC-3.8.022):**
- When at least one extra field is ADF-converted (non-empty ADF-backed), the built result has `"isAdfRequest": true`.
- When `self.description` is `None` AND at least one non-empty ADF-backed extra field IS present, `isAdfRequest` is `true` (the flag is not gated on `self.description`).
- When ALL extra fields are either plain-string or empty-ADF-omitted AND `self.description` is `None`: `isAdfRequest` is NOT `true` (regression: accumulation must not fire for non-ADF or omitted fields).
- **Discriminator precision (I-2 — regression axis):** The mechanism that determines
  whether `isAdfRequest` should be set MUST use the explicit accumulated boolean flag
  passed from the resolution layer to `build()` — NOT a post-hoc `is_object()` check
  on `requestFieldValues` entries. A naive `is_object()` check would falsely flag
  hinted `:id`/`:name` extra fields (which produce JSON objects) and `:asset` extra
  fields (which produce arrays), setting `isAdfRequest = true` for non-ADF writes.
  Regression axis: a test with a hinted `:id` or `:name` extra field (producing a JSON
  object) AND no ADF extra field must produce `"isAdfRequest"` absent or `false` in
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

Suggested name: `test_jsm_adf_field_metadata_unavailable_emits_warning` (Axis e)

**Axis (f) — Fetch SUCCEEDED, NAME absent from RT field list → verbatim string-wrap, no warning, `isAdfRequest` unchanged (I-1 regression pin):**
This axis pins the I-1 rule: when the RT-fields fetch SUCCEEDED but the `--field NAME`
value does not match any `RequestTypeField.field_id` in the returned list, the resolution
layer falls through to BC-3.8.008 verbatim behavior — it is NOT the metadata-unavailable
case (Axis e) and must NOT emit the global `warning:` line.

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
- Against a silent `Value::String` fallback when metadata is unavailable (no stderr warning emitted): Axis (e) fails RED — no stderr output produced, but the test asserts exactly one global warning line on stderr. ✓
- Against a per-field-warning mutant that emits one warning per `--field` pair instead of one global warning: Axis (e) fails RED — N warning lines produced, but the test asserts exactly one. ✓

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
   responsibilities; `build()` is a pure assembler that must never call
   `is_adf_field_value`, `text_to_adf`, or `eprintln!`. When `RequestTypeField`
   metadata IS available (the normal path), ADF conversion MUST fire for every
   ADF-backed extra field — sending `Value::String` to an ADF-backed field produces
   a guaranteed 400. The `Value::String` fallback applies ONLY when the
   requesttype-fields FETCH ITSELF FAILED (network error / non-200 including
   401/403/404/500 / cache-miss-with-no-network) AND MUST emit a SINGLE GLOBAL
   observable stderr `warning:` line ONCE per create invocation (not per `--field`
   pair) with NO field name in the text. A silent fallback is NOT acceptable.
   VP-FIELD-ADF-004 axes (b)–(e) are gated on this DQ-6 type/signature decision
   landing; see §4 VP-004 for the full gate.

6. **JSM `RequestTypeField` metadata acquisition when `--field` pairs are present (H-1
   — added):** The JSM create path (`src/cli/issue/jsm_create.rs::handle_jsm_create`)
   currently never calls `GET .../requesttype/{id}/field` — no `RequestTypeField`
   metadata exists in hand. The whole ADF feature on the JSM path, AND the
   fetch-failed fallback in VP-FIELD-ADF-004 Axis (e), both presuppose that this
   metadata is available for the resolution-layer ADF check. F4 Story 2 MUST add a
   metadata-acquisition step to `handle_jsm_create` when `--field` pairs are present:
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
   - The added round-trip is gated on `--field` being present (no extra HTTP call when
     no `--field` pairs are specified). A no-`--field` JSM create is unchanged from the
     pre-F4 code path.
   - This item is IN ADDITION to the DQ-6 type/signature resolution (item 5 above):
     item 5 decides how the resolved ADF object is carried into the assembler; this
     item decides how the metadata is acquired in the first place. Both must land
     together in F4 Story 2.

7. **Wiremock-backed F4 acceptance obligations for JSM metadata acquisition wiring
   (F-5 — MUST F4 AC):** VP-FIELD-ADF-004's unit tests operate on controlled structs
   with no network I/O; the following behaviors require a separate wiremock-backed
   integration test or explicit Story 2 wiremock AC:
   (a) the `GET /rest/servicedeskapi/servicedesk/{sdId}/requesttype/{rtId}/field`
       round-trip fires IFF `--field` pairs are present on a JSM create call; a JSM
       create with NO `--field` pairs issues NO fields-fetch GET;
   (b) a warm cache entry (populated by `write_request_type_fields_cache`) → NO HTTP
       for the fields-fetch GET on the next create call with the same `(profile, sid,
       rtId)` key;
   (c) a 401 on the fields-fetch GET produces a stderr hint matching the
       READ-appropriate hint string (e.g., "ensure your token has read access to this
       service desk's request type fields") — NOT the `write:servicedesk-request`
       write-scope hint. The exact hint text is a load-bearing test pin: confirm and
       lock the precise wording at F4 implementation time.
   These are FIRM MUST F4 ACs. None of (a), (b), or (c) is exercised by the VP-004
   unit tests.

8. **LIVE echo channels for ADF `--field` (PASS-9 F-1 — FIRM MUST F4 AC; mirrors VP-398-002
   discipline):** For both the edit path (live, non-dry-run) and the create path (live,
   non-dry-run), the following must be tested and passing before Story 1 / Story 2 can close:
   - **JSON channel (`--output json`, edit path only — create has no `changed_fields` key):**
     `changed_fields[human_name]` MUST carry the **raw user-supplied input string** for a
     non-empty ADF-backed field (VP-FIELD-ADF-002 live echo axis); for the edit-clear case
     (empty ADF-backed field on the edit path), `changed_fields[human_name]` MUST carry the raw
     empty/whitespace input string (VP-FIELD-ADF-003 Axis F). NOT the serialized ADF object,
     NOT the `(adf)` or `(adf-clear)` marker.
   - **Table/human channel (both edit and create):** the cell for a non-empty ADF-backed field
     MUST show `(adf)` (not the ADF object, not the raw value — edit and create paths share this
     marker: BC-3.3.013/BC-3.4.033); the cell for an edit-cleared ADF-backed field MUST show
     `(adf-clear)` (BC-3.4.036).
   Required tests: VP-FIELD-ADF-002 live echo axis (`test_bc_3_4_033_live_edit_json_changed_fields_raw_input_not_adf_object`,
   `test_bc_3_4_033_live_edit_table_shows_adf_marker_not_raw_value`,
   `test_bc_3_3_013_create_table_shows_adf_marker`) and VP-FIELD-ADF-003 Axis F
   (`test_bc_3_4_036_live_edit_json_changed_fields_raw_empty_input_not_clear_doc`).
   These mirror the VP-398-002 `test_bc_3_4_012_description_echo_is_updated_marker_not_content`
   and `test_bc_3_4_013_description_echo_is_raw_input_string_not_marker` discipline for the
   `description` dedicated flag — the exact same channel asymmetry must be pinned for `--field`
   ADF. Zero tolerance for a live edit that silently emits the ADF object in the JSON channel or
   the raw value in the table channel.

9. **Marker side-channel plumbing for live echo channels — REQUIRED F4 AC (F-1 + F-2
   resolution; parallel of DQ-6 for the platform path):** `FieldResolutionOutputs`
   (in `src/cli/issue/field_resolve.rs`) MUST gain a dedicated marker side-channel,
   e.g. `field_markers: BTreeMap<String, &'static str>` keyed by `human_name`
   (display name, NOT `field_id`). Populated at exactly two sites:
   - `dispatch_field_value`'s ADF branch: `field_markers.insert(human_name, "(adf)")` for
     a non-empty bare ADF-backed field.
   - `resolve_against_editmeta`'s empty-clear pre-check:
     `field_markers.insert(human_name, "(adf-clear)")` for an empty/whitespace bare
     ADF-backed field on the edit path.
   The `edit.rs` / `create.rs` table-emit loop reads `field_markers[human_name]` when
   present and renders the marker; `changed_fields` is NEVER written the marker — it holds
   the raw user-supplied input string (JSON channel lossless, #398 invariant unchanged).
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

---

## 6. Out-of-Scope Items (documented non-omissions)

- **`--markdown` for `--field` ADF values:** `text_to_adf` (plain text) is the
  only conversion mechanism this cycle. A `:markdown` hint form for `--field` is
  explicitly deferred (DQ-1 closed as Option A). No VP covers markdown behavior on
  the `--field` path — it does not exist.
- **Dry-run `planned_preview` shape for ADF `--field` values (O6, BC-3.4.033/036
  — F-4 fix — VP AXES FOLDED INTO §4, obs-2):** The dry-run behavior (ADF object in
  `planned_preview` for non-empty; `(adf-clear)` sentinel in table mode /
  `{"type":"doc","version":1,"content":[]}` for the edit-clear case in JSON mode) is
  NOT deterministic from VP-FIELD-ADF-002. VP-002 asserts the dispatch RETURN value
  (the wire ADF object), not the `planned_preview` map entry. The bare-form path
  currently writes a SIMPLIFIED DISPLAY STRING to `planned_preview` via
  `src/cli/issue/field_resolve.rs::dispatch_field_value`'s string/text arm (the
  display-string insert lives in `dispatch_field_value`, NOT in `resolve_against_editmeta`;
  only the empty-clear pre-check belongs in `resolve_against_editmeta` /
  `resolve_against_createmeta`); ADF-backed fields require a NEW special case in
  `dispatch_field_value`'s ADF branch that writes the wire ADF object to
  `planned_preview` instead of a display string. VP axes for this behavior have been
  folded into §4 (obs-2): VP-FIELD-ADF-002 (dry-run axis for non-empty ADF) and
  VP-FIELD-ADF-003 (Axis E for edit-clear dry-run). The authoritative definitions are
  in §4; the BC citations now resolve to those §4 VP axes.
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
