# Impact Boundary Report — Issue #383
# Platform-path inverse warning symmetry: --field / --on-behalf-of silent-drop

**Issue**: #383 (follow-up of #382 / S-288-pr4)
**Date**: 2026-05-19
**Analyst**: architect (Phase F1 Step 3)

---

## 1. Inverse-Symmetry Claim Verification

The issue claims `field_pairs` and `on_behalf_of` are never referenced on the
`request_type.is_none()` branch of `handle_create`.

### Evidence from `src/cli/issue/create.rs`

Destructuring (lines 39–59):
```rust
let IssueCommand::Create {
    ...
    request_type,
    field: field_pairs,
    on_behalf_of,
} = command
```

Dispatch fork (lines 61–118): both variables are forwarded into `JsmCreateArgs`
exclusively when `request_type.is_some()`:
```rust
if request_type.is_some() {
    ...
    return handle_jsm_create(
        ...,
        JsmCreateArgs {
            ...
            on_behalf_of,
            field_pairs,
        },
    ).await;
}
```

Platform branch (lines 120–278): builds `fields` JSON using `project`, `issue_type`,
`summary`, `description`, `priority`, `labels`, `team`, `points`, `parent`,
`account_id`, `to`. Neither `field_pairs` nor `on_behalf_of` appears anywhere in
lines 120–278.

**Verdict: Claim CONFIRMED.** `field_pairs` and `on_behalf_of` are consumed only
inside the `request_type.is_some()` block. After the `if` block the variables are
moved (captured in `JsmCreateArgs`) so they cannot be referenced on the platform path
even accidentally. The inverse gap is real.

---

## 2. Clap Definitions

From `src/cli/mod.rs` lines 393–401:
```rust
/// Additional request field values as NAME=VALUE pairs (repeatable).
/// Applies to JSM requests only.
#[arg(long = "field", action = clap::ArgAction::Append)]
field: Vec<String>,
/// Raise the JSM request on behalf of this accountId (JSM requests only).
#[arg(long = "on-behalf-of")]
on_behalf_of: Option<String>,
```

No `requires("request_type")` attribute on either flag. Clap accepts these flags
regardless of whether `--request-type` is set. **No clap-layer change required** —
the fix is purely a runtime stderr emission before the platform path executes.

---

## 3. Component Classification Table

| Component | Classification | Rationale |
|-----------|---------------|-----------|
| `src/cli/issue/create.rs` lines 119–122 | MODIFIED | Insert 2 warning blocks immediately after `// Resolve project key` comment, before `let project_key = ...`. |
| `.factory/specs/prd/bc-3-issue-write.md` (BC-3.8.012) | NEW | New BC for `--field` ignored without `--request-type` warning. |
| `.factory/specs/prd/bc-3-issue-write.md` (BC-3.8.013) | NEW | New BC for `--on-behalf-of` ignored without `--request-type` warning. |
| `.factory/specs/prd/bc-3-issue-write.md` total-count footer | MODIFIED | Increment "59 individually-bodied" → 61; update "001..010" range ref → "001..013". |
| `tests/issue_create_jsm.rs` | MODIFIED | Add 2 new integration tests (one per flag) mirroring C-02 / BC-3.8.011 pattern. |
| `src/cli/mod.rs` | DEPENDENT | Read-only — confirms no `requires` attribute; no edit needed. |
| Existing BC-3.8.011 tests (lines 1587–1865) | DEPENDENT | Regression baseline — must remain passing unchanged. |
| `src/api/jsm/requests.rs` | DEPENDENT | Contains `on_behalf_of` in JSM builder — no changes needed; symbol scoping already correct. |

---

## 4. File-by-File Impact with Line Ranges

### `src/cli/issue/create.rs`

Insertion point: **after line 118** (`}).await;`) and **before line 120** (`// Resolve project key`). Two `if` blocks:

```
// proposed insertion at ~line 119:
if !field_pairs.is_empty() {
    eprintln!(
        "warning: --field is ignored without --request-type; \
         use --request-type to submit a JSM request with custom fields"
    );
}
if on_behalf_of.is_some() {
    eprintln!(
        "warning: --on-behalf-of is ignored without --request-type; \
         use --request-type to submit a JSM request on behalf of another user"
    );
}
```

Note: `field_pairs` is `Vec<String>`, check via `!field_pairs.is_empty()`.
`on_behalf_of` is `Option<String>`, check via `.is_some()`. Both variables are
still in scope at this point (not yet moved — they are only moved into
`JsmCreateArgs` inside the `if request_type.is_some()` block above, which has
already returned).

### `.factory/specs/prd/bc-3-issue-write.md`

- **After line 730** (end of BC-3.8.011): append BC-3.8.012 and BC-3.8.013 bodies.
- **Line 750**: update total count from 59 → 61.
- **Line 752**: update footer timestamp and range.

### `tests/issue_create_jsm.rs`

- **After line 1865** (end of `test_jsm_create_account_id_flag_emits_warning_with_request_type`): append two new tests:
  - `test_platform_create_field_flag_emits_warning_without_request_type`
  - `test_platform_create_on_behalf_of_flag_emits_warning_without_request_type`

Both tests will:
- Mount `POST /rest/api/3/issue` returning 201 (platform endpoint, not servicedeskapi).
- Pass the relevant flag without `--request-type`.
- Assert `output.status.success()` is true.
- Assert `stderr.contains(verbatim_warning_string)`.

Template from existing test at line 1381 (`test_platform_create_401_no_jsm_scope_hint`)
for the platform mock setup, combined with the warning-assertion pattern from line 1635.

---

## 5. Architecture Verdict

**Structural change required: NO.**

This is a pure addition of 2 `eprintln!` calls at a single insertion point in
`handle_create`, guarded by checks on already-bound local variables. No new modules,
no new types, no new API calls, no trait changes. The purity boundary, module
decomposition, and dependency graph are unaffected.

---

## 6. Regression Baseline

Files whose tested behavior must remain byte-for-byte identical after this change:

| File | What must not change |
|------|---------------------|
| `tests/issue_create_jsm.rs` lines 1587–1865 | All 5 BC-3.8.011 per-flag warning tests must still pass (JSM path warnings fire when `--request-type` IS set). |
| `tests/issue_create_jsm.rs` lines 1381–1433 | `test_platform_create_401_no_jsm_scope_hint` — platform 401 path still must not mention `write:servicedesk-request`. |
| `tests/issue_create_jsm.rs` lines 1242–1308 | `test_jsm_create_type_flag_ignored_with_warning` — BC-3.8.010 `--type` warning on JSM path unchanged. |
| `tests/issue_create_jsm.rs` lines 1441–1522 | `test_jsm_create_output_json_shape_matches_platform` — JSON output shape unchanged. |
| `src/cli/issue/create.rs` lines 120–278 | Platform branch field-building logic (project, issue_type, summary, ..., assignee) must be byte-for-byte unchanged after insertion. |
| `src/api/jsm/requests.rs` | JSM builder logic and `on_behalf_of` wiring unchanged. |

---

## 7. Warning String Candidates

Proposed verbatim strings (to be locked in BC-3.8.012 / BC-3.8.013):

- `--field`: `"warning: --field is ignored without --request-type; use --request-type to submit a JSM request with custom fields"`
- `--on-behalf-of`: `"warning: --on-behalf-of is ignored without --request-type; use --request-type to submit a JSM request on behalf of another user"`

These mirror the forward-direction pattern from BC-3.8.010/011:
`"warning: <flag> is ignored when --request-type is set; <rationale>"` →
inverse: `"warning: <flag> is ignored without --request-type; <rationale>"`.

The exact strings are a PO/BC decision; the implementation site is unambiguous.
