# PR Review — #809 (feature/S-cycle12-platform-adf-autoconvert)

**Verdict: APPROVE** — no blocking findings.

Reviewed at `0161f7346c4f1c358f14534f305ed141cb461cb5`. All 10 changed files
reviewed against the 8-item checklist. This is not a rubber stamp — below is
exactly what I verified and what I read to verify it.

---

## What I verified

### 1. `is_adf_schema` three-arm allowlist — CORRECT

```rust
fn is_adf_schema(system: Option<&str>, custom: Option<&str>) -> bool {
    matches!(system, Some("description") | Some("environment"))
        || custom.map(|c| c.ends_with(":textarea")).unwrap_or(false)
}
```

- Exactly three arms, no fourth. `None`/`None` → `false`.
- `:textfield` correctly excluded (`ends_with(":textarea")` is a suffix match,
  not a substring match, so `…:textareafoo` also correctly returns `false`).
- Single-core discipline (ACR-1) holds: `is_adf_field_value` reads `system`/
  `custom` off a `serde_json::Value` and delegates; `is_adf_field` bridges the
  typed `EditMetaFieldSchema` through `is_adf_field_value`. Neither re-implements
  the allowlist, so the Wave-2 JSM entry point cannot drift from the platform
  predicate. `json!({"system": schema.system, "custom": schema.custom})` yields
  `null` for `None`, and `.as_str()` on `null` yields `None` — the bridge is
  decision-equivalent to calling `is_adf_schema` directly.
- Two-sided IFF proptest (`prop_bc_3_4_033_is_adf_field_fires_only_on_allowlist`,
  1000 cases) generates BOTH allowlist members and filtered non-members, and
  asserts equality against an independently-written expectation — not a
  one-sided "positives only" test. This is the right shape for mutation
  resistance on a predicate.

### 2. Empty-value semantics (edit = clear-doc, create = omit) — CORRECT and asymmetric by design

Both paths gate on the same pure helper:

```rust
fn is_bare_empty_adf_field(kind, schema, value) -> bool {
    kind.is_none() && is_adf_field(schema) && value.trim().is_empty()
}
```

- `kind.is_none()` correctly restricts the gate to the bare form — a hinted
  pair (`:option`/`:id`/`:name`/`:asset`) bypasses and routes to its composer,
  matching the established hinted-bypass precedence in `dispatch_field_value`.
- **Edit** (`resolve_against_editmeta`): writes
  `{"type":"doc","version":1,"content":[]}` into `fields[field_id]`, seeds
  `planned_preview` with the clear-doc, marks `(adf-clear)`, `continue`s.
  Correctly avoids the JRACLOUD-79318 empty-text-node 400.
- **Create** (`resolve_against_createmeta`): bare `continue` before
  `dispatch_field_value`, so the key never enters `fields` — genuinely omitted
  from the POST body, not sent as `null` or as a clear-doc.
- The asymmetry is deliberate and spec-anchored (BC-3.4.036 vs BC-3.3.015):
  clearing an existing value is meaningful on edit, meaningless on create.
- Extracting this as a network-free pure helper (rather than inlining the
  three-way condition at both call sites) is the right call — it makes the
  gate unit-testable without a MockServer and keeps the two call sites from
  drifting.

### 3. `--markdown` + `--field description` guard — PRESENT on both paths, uniform

- `create.rs` step 2c and `edit.rs` (pre-`--markdown`-modifier guard) both use
  the identical raw-token, case-sensitive predicate:
  `pair.find('=').is_some_and(|pos| &pair[..pos] == "description")`.
- Identical remediation message on both paths ("Pass `--description` with
  `--markdown`, or omit `--markdown`"), matching the JSM guard for uniform
  exit-64 behavior across all three write paths.
- Ordering verified as non-vacuous: in `create.rs` the guard sits AFTER
  project/type/summary resolution, so a missing `--project` still produces
  "Project key is required" rather than this guard — the discriminating
  invariant the inline comment claims is actually the code's behavior. It also
  sits BEFORE the blocking `--description-stdin` read, so the process does not
  block on a pipe only to then exit 64.
- Not dead code: `description` IS in `CREATE_D2_GOVERNED_KEYS`, but
  `detect_flag_field_overlap` only fires when the *dedicated* flag was actually
  supplied. `--markdown --field description=X` (no `--description`) passes
  step 2b and reaches step 2c, so BC-3.3.014 AC-006 is genuinely exercised.
- Double-write hazard checked and closed: `--description X --field description=Y`
  exits 64 on create via the step-2b D2 guard (case-insensitive static compare)
  and on edit via Gate B's five-member set, which includes `description`. There
  is no path where both write `fields["description"]` and one silently wins.
- Documented residual (capital-D `Description`) is benign, and I confirmed why:
  with `--description` present, the case-insensitive D2/Gate B compare catches
  it; without `--description`, there is no second writer to conflict with.

### 4. #398 invariant (JSON = raw, table = sentinel) — PRESERVED, and the
###    precedence ordering is the load-bearing detail

- **Machine channel lossless:** the non-empty ADF branch inserts the raw
  `value` into `changed_fields`, not the ADF object and not a marker. The
  empty-clear branch inserts `spec.value.clone()` — **untrimmed** — so a
  whitespace-only input like `"   "` round-trips as `"   "` rather than
  collapsing to `""`. That is the correct reading of #398, and it is the kind
  of detail that is easy to get wrong; the dedicated regression test
  (`test_bc_3_4_036_live_edit_json_changed_fields_raw_empty_input_not_clear_doc`)
  pins it.
- **Human channel:** the `field_markers.get(field)` check is placed BEFORE the
  legacy `field == "description"` check in `edit.rs`'s emit loop. This ordering
  is what makes `--field description=X` show `(adf)` while `--description X`
  still shows `(updated)` — swapping the two arms would silently regress
  AC-011, so the comment marking it as intentional is warranted.
- **Stream discipline:** live echoes use `eprintln!` (stderr, Symmetric
  profile) in both `edit.rs` and `create.rs`; dry-run preview uses `println!`
  (stdout). Consistent with the existing output-channel convention — the ADF
  branch does not introduce a stream mismatch, and the inline "Do NOT use
  println! here" comments guard the right invariant.
- `field_markers` is table-only and never reaches the JSON serializer, so
  `--output json` shape is unchanged.

### 5. Other correctness checks

- **No skipped post-match logic.** The ADF branch `return Ok(())`s early from
  inside the `"string" | "text"` arm. I read `dispatch_field_value`'s tail
  (Steps 5/6) and confirmed the branch replicates all three sinks
  (`planned_preview`, `fields[field_id]`, `changed_fields`) plus `field_markers`.
  Nothing downstream is bypassed. The hinted-bypass branch above uses the same
  early-return shape, so this is consistent with the existing structure rather
  than a new pattern.
- **`planned_preview` carries the ADF object, not a display string.** This
  deviates from the general bare-form rule ("preview is the simplified display
  string") but matches the hinted-bypass precedent and is required by AC-008.
  Deliberate and documented at the site.
- **Createmeta schema adaptation preserves ADF detection inputs.** `adapted.schema
  = meta_field.schema.clone()` carries `system`/`custom` through verbatim, so
  `is_adf_field` sees the same data on the create path as on the edit path. This
  is the linchpin for BC-3.3.013/014 and is pinned by AC-013's test.
- **`FieldResolutionOutputs` widening.** Growing the bundle to 4 sinks rather
  than adding a 7th positional parameter is the right response to
  `clippy::too_many_arguments` — it follows the project's "refactor, don't
  suppress" policy, and the struct is destructured at each entry point so the
  call sites stay readable.
- **`customfield_NNNNN` bypass regression (BC-3.4.037).** Detection is driven
  off `schema.system`/`schema.custom`, never off the `field_id` spelling, so
  a bypass-form pair targeting `environment` still ADF-converts. Anchored by an
  explicit example assertion.
- **`human_name` → `field_id` override for system fields.** Keys
  `changed_fields` as `"description"` (lowercase field id) rather than
  `"Description"` (display name) for all non-`customfield_` fields, matching
  the `--description` path convention required by AC-011. See Finding 1 below.
- **No `unsafe`, no new lint suppressions, no `todo!()`** in any changed file.
- **No let-chains** introduced (MSRV 1.85 constraint respected — the new guards
  use `&&` with `is_some_and`, not `if let … &&`).

### 6. Checklist items

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence | PASS — every change traces to the 8 BCs; no drive-by edits |
| 2 | Description accuracy | PASS — PR body matches the code; the ADR-0024 summary is accurate to what `field_resolve.rs` actually does |
| 3 | Test coverage | PASS — 19 new tests; proptests are two-sided; changed lines covered |
| 4 | Demo evidence | ACCEPTED — explicit human DEMO SKIP, backend-only write path with no UI surface, cycle-005/007 precedent cited |
| 5 | Commit quality | PASS — conventional format, story ID present |
| 6 | Diff size | NOTED — ~2,500 added lines, but ~1,800 are new test files; production delta is ~740 lines |
| 7 | Missing changes | PASS — all 15 ACs have a traced test; `pub(crate) is_adf_field_value` present as the Wave-2 start condition |
| 8 | Dependency status | PASS — Wave-1 lead story, `depends_on: none` |

---

## Non-blocking findings

### Finding 1 — SUGGESTION (coherence): `human_name` → `field_id` override is broader than the ADF scope

| Field | Value |
|-------|-------|
| Severity | suggestion |
| Category | coherence |
| Location | `src/cli/issue/field_resolve.rs` — `resolve_edit_fields`, the `human_name` rebind |

The override applies to **every** non-`customfield_` field resolved via
`--field`, not just ADF-backed ones. So `--field "Due Date"=2026-01-01` now
keys `changed_fields` as `"duedate"` instead of `"Due Date"` — a JSON-output
shape change for non-ADF system fields that is incidental to this story's
stated scope.

Why I am not blocking on it: the new keying is the *more* consistent behavior
(it matches what the dedicated flags already emit, which is what AC-011
requires), the full suite passes, and the CHANGELOG does disclose it ("System
fields resolved via `--field` use the field_id … as the JSON `changed_fields`
key"). It is a deliberate convergence on one convention, not an accident.

Suggestion: since this is an observable `--output json` key change for fields
outside the ADF allowlist, consider promoting the CHANGELOG sentence from the
tail of the ADF entry into its own bullet so a downstream `jq` consumer
scanning for breaking output changes does not miss it.

### Finding 2 — NIT (description): CHANGELOG BC list omits two BCs

| Field | Value |
|-------|-------|
| Severity | nit |
| Category | description |
| Location | `CHANGELOG.md` |

The entry cites `BC-3.4.033/035/036, BC-3.3.013/014/015` but the story also
delivers **BC-3.4.034** (`environment` system field edit) and **BC-3.4.037**
(`customfield_NNNNN` bypass regression pin). Both are implemented and tested;
only the CHANGELOG citation list is short. Add them for traceability.

### Finding 3 — NIT (coherence): `field_resolve.rs` size figure in CLAUDE.md is now stale

| Field | Value |
|-------|-------|
| Severity | nit |
| Category | coherence |
| Location | `CLAUDE.md` — Known Size Deviations |

CLAUDE.md documents `cli/issue/field_resolve.rs` at ~1,635 LOC (re-measured at
S-578-4). This PR adds ~629 lines to that file, putting it near ~2,250 LOC.
The DOCUMENT-AS-IS rationale still holds (the single shared
`dispatch_field_value` now backs a third detection concern rather than being
split), but the measured figure and the S-cycle12 attribution should be
refreshed the next time that section is touched. Not worth blocking a
correctness fix.

---

## Pre-merge note (not a finding)

At the time of this review the `ci-gate` checks on `0161f734` were still
**pending** (run 34863831506). The APPROVE verdict is on the code; the green
gate remains a merge precondition for whoever merges. Given CLAUDE.md's
`strict: false` note — a PR branch is not required to be up to date with
`develop` before merging — if `develop` has moved since the gate last ran on
this PR, re-check the gate's age rather than trusting an old green.

---

## Summary

| Severity | Count |
|----------|-------|
| BLOCKING | 0 |
| SUGGESTION | 1 |
| NIT | 2 |

The four highest-risk areas in this change — allowlist shape, the
edit/create empty-value asymmetry, guard reachability and ordering, and the
#398 dual-channel invariant — are each implemented correctly and, more
importantly, pinned by tests that would actually fail if the behavior
regressed. The two places where a subtle mistake would have been invisible
(untrimmed raw value in the empty-clear `changed_fields` insert, and the
`field_markers` check preceding the legacy `description` arm) are both right.

**APPROVED.**
