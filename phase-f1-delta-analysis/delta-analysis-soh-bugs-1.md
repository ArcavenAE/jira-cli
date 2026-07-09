---
document_type: f1-delta-analysis
phase: phase-f1-delta-analysis
producer: architect
timestamp: 2026-07-09
bundle: SOH-BUGS-1
issues: [589, 590, 582]
status: awaiting-human-gate
intent: bug-fix
feature_type: backend
mode: BROWNFIELD
---

# F1 Delta Analysis — Bundle SOH-BUGS-1

Two validated external bug reports. Both confirmed by offline reproduction.

- **Issue #589:** `AllowedValue.id` required-string deserialization failure — user/group-picker
  fields (GDPR accountId migration) cause serde crash on any editmeta fetch
- **Issue #590 / #582:** `jr api -X DELETE` rejected — clap `ValueEnum` case-sensitivity
  diverges from `curl`/`gh api` convention

Research basis:
- `.factory/research/issue-589-editmeta-allowedvalue-id-2026-07-08.md`
- `.factory/research/issue-590-http-method-case-2026-07-08.md`

---

## Bug #589 — `AllowedValue.id` Required-String Deserialization Failure

### Problem

`src/types/jira/editmeta.rs::AllowedValue.id` is typed `String` (required). Jira's
`allowedValues` schema has no required properties; GDPR-era user/group picker fields
carry `accountId` instead of `id`. Serde must deserialize the entire editmeta
`HashMap<String, EditMetaField>` to produce any result. A single id-absent entry on
ANY field (not just the targeted one) causes a `"missing field 'id'"` serde error,
propagated as exit 1. `--dry-run` is equally blocked because the failure is
pre-mutation. Seven surveyed Jira client libraries all use loose typing for
`allowedValues`; the required-id constraint is an ecosystem outlier.

### Severity and Intent

**Severity: HIGH.** User/group picker fields lack `id` per GDPR accountId migration.
Any production instance with such a field on an issue's Edit screen crashes `jr issue
edit --field` entirely, regardless of which field the user targets. Workaround exists
(`jr api PUT` with raw JSON), so CRITICAL classification is not warranted.

**Intent: bug-fix.** The behavior is unambiguously broken per the Atlassian OpenAPI
schema; no design decision is being revised.

### Impact Assessment

| Dimension | Affected | Details |
|-----------|----------|---------|
| PRD Requirements (BCs) | BC-3.4.015 UNCHANGED; BC-3.4.016 MODIFIED | BC-3.4.015 governs the outer resolution algorithm, which is correct; failure is below its abstraction at deserialization. BC-3.4.016 gains EC-3.4.016-5: matched option entry with `id=None` → exit 64 with actionable message; id-bypass predicate excludes `id=None` entries silently |
| Architecture | INTERNAL-ONLY | Type field change in `src/types/jira/editmeta.rs`; no new modules, no CLI surface change, no API surface change |
| Stories | 1 story | Single story: `AllowedValue.id` → `Option<String>` + 7 Option-aware call sites + BC-3.4.016 EC-3.4.016-5 text + 2 new tests |
| Verification Properties | VP-396-008 extended; VP-396-002 clarified; NEW VP-589-001 | VP-396-008: dry-run succeeds despite id-absent allowedValues on non-targeted fields. VP-396-002: wire `{"id": ...}` emitted only when id is `Some`. VP-589-001 (new): id-absent entry on any non-targeted field → deserialization succeeds and targeted edit proceeds |
| Existing Tests | `tests/issue_edit_field.rs` (44 tests, ~3448 LOC) | Regression zone. All 44 existing tests supply `allowedValues` entries WITH `"id"` — none exercise the id-absent path (confirmed blind spot). All 44 remain valid regression guards on the happy path |

### av.id Use-Site Map (supersedes research file's ~4-site estimate)

The research document cited approximately 4 sites. Confirmed count is **7**
(all in `src/cli/issue/field_resolve.rs`). The discrepancy is resolved here:

| Line | Context | Option-Handling Strategy |
|------|---------|--------------------------|
| 491 | `av.id == value` — id-bypass predicate | `av.id.as_deref().map(\|id\| id == value).unwrap_or(false)` — `None` entries excluded from id-bypass silently (correct: no id means no numeric-id match) |
| 496 | `json!({"id": av.id})` — id-bypass wire emission | Exit 64 if `id` is `None` post-match (id-bypass found a match but the entry has no machine-readable id) |
| 514 | `json!({"id": av.id})` — exact-match wire emission | Exit 64 if `id` is `None` post-match |
| 521 | `format!("... (id: {})", av.id)` — ambiguity display (exact branch) | `.as_deref().unwrap_or("<no-id>")` |
| 545 | `av.value.clone().unwrap_or_else(\|\| av.id.clone())` — fallback label in not-found error | `.unwrap_or_else(\|\| "<no-id>".to_string())` |
| 560 | `av.id` — ambiguity display (substring branch) | `.as_deref().unwrap_or("<no-id>")` |
| 572 | `json!({"id": av.id})` — substring-match wire emission | Exit 64 if `id` is `None` post-match |

Exit-64 message text for id-absent wire-emission sites (EC-3.4.016-5, for BA confirmation):
> "Option value '{value}' has no machine-readable id and cannot be set via `--field`.
> This typically occurs with user/group picker fields. Use the Jira UI or the field's
> native picker to set this value."

### Affected BC Mapping

**BC-3.4.015** — UNCHANGED. The field-name resolution and editmeta-fetch algorithm
(Steps 1–6) are correct. The failure is at serde deserialization of `AllowedValue.id`,
below BC-3.4.015's abstraction boundary.

**BC-3.4.016** — MODIFIED. Add EC-3.4.016-5:

> EC-3.4.016-5: A matched `allowedValues` entry whose `id` field is absent (`None`)
> cannot produce a valid wire payload. The id-bypass predicate (`av.id == value`) must
> not match `id=None` entries. For the exact-match, id-bypass, and substring-match
> resolution paths: if the winning entry has `id=None`, exit 64 with the actionable
> message defined in EC-3.4.016-5. This covers fields where Jira omits `id` (e.g.
> GDPR-era user/group pickers, plugin-defined fields).

**Flag to BA:** EC-3.4.016-5 exit-64 message text is proposed above but requires BA
sign-off before story-writing. The implementer must not invent message text unilaterally.

### Trivial Scope Assessment

All four trivial-scope criteria evaluated:

- [x] Single module — FAILS: 2 source files (`editmeta.rs`, `field_resolve.rs`) + test file
- [ ] No new BCs needed — FAILS: BC-3.4.016 EC-3.4.016-5 is a new clause
- [x] No architecture change — PASSES: internal type change only
- [x] Low regression risk — PARTIALLY FAILS: MED risk (7 mechanical sites, recently-shipped feature #396, extensive existing test suite)

**Verdict: NOT TRIVIAL.** Standard bug-fix rigor applies: BC-3.4.016 EC amendment +
story + full per-story delivery. F2/F3 full spec ceremony is skipped per bug-fix intent,
but the EC amendment rides with the story (no story can be written without the EC text
being finalized by BA first).

### Holdout Scope

Scoped to `issue edit --field` subsystem. Holdout fixture: an editmeta response where
a non-targeted field has an `allowedValues` entry with no `"id"` key. Confirms: (1)
deserialization succeeds, (2) edit of the targeted (id-present) field proceeds
correctly, (3) targeting an id-absent option field produces the EC-3.4.016-5 exit-64
message, not a serde error.

### Files Changed

**Will be modified:**

| File | Nature of Change |
|------|-----------------|
| `src/types/jira/editmeta.rs` | `AllowedValue.id: String` → `Option<String>` |
| `src/cli/issue/field_resolve.rs` | 7 `av.id` sites made Option-aware (see table above) |
| `tests/issue_edit_field.rs` | New test: editmeta fixture with id-absent allowedValues entry; confirms graceful deserialization + exit 64 on targeted id-absent option; confirms no regression on id-present path |
| `.factory/specs/prd/bc-3-issue-write.md` | BC-3.4.016: add EC-3.4.016-5 (id-absent exit-64) |

**Regression baseline (explicitly NOT changed):**

| File | Reason unchanged |
|------|-----------------|
| `src/cli/issue/edit.rs` | Calls `resolve_edit_fields`; no change at call site |
| `src/api/jira/issues.rs` | `get_editmeta` return type unchanged |
| `src/types/jira/mod.rs` | Re-exports `AllowedValue`; no member access |
| All 44 existing `tests/issue_edit_field.rs` tests | Happy-path tests (id-present allowedValues) remain valid; no updates needed |
| `src/cli/issue/create.rs`, `jsm_create.rs`, `workflow.rs` | No `AllowedValue` usage |

---

## Bug #590/#582 — `jr api -X DELETE` Case-Sensitivity

### Problem

`jr api -X DELETE /path` fails with a clap parse error before any I/O occurs. Clap 4.x
`ValueEnum` matching is case-sensitive kebab-case by default; `HttpMethod` variants
derive as `get`/`post`/`put`/`patch`/`delete`. Uppercase inputs (`DELETE`, `GET`,
`POST`, `PUT`, `PATCH`) are rejected. Both `curl -X DELETE` and `gh api -X DELETE`
use uppercase by convention; the deviation surprises users who follow standard tooling
muscle memory. Issues #590 (bug form) and #582 (feature form) describe the same root
cause and close with the identical fix.

Offline reproduction confirmed byte-for-byte:
```
$ jr api -X DELETE /x
error: invalid value 'DELETE' for '--method <METHOD>'
  [possible values: get, post, put, patch, delete]
```

### Severity and Intent

**Severity: LOW.** Workaround is immediate: `-X delete` (lowercase) works. The bug
causes user friction but no data loss and no broken behavior on the lowercase path.

**Intent: bug-fix / conformance fix.** Deviation from the established `curl`/`gh api`
convention for the `-X` flag.

### Impact Assessment

| Dimension | Affected | Details |
|-----------|----------|---------|
| PRD Requirements (BCs) | No existing BC governs `-X` case-sensitivity; optional new micro-BC BC-X.1.011 recommended post-fix | BC-X.1.005/006/007/010 are all client-layer BCs unaffected by arg parsing. BC-X.1.011 (optional, post-fix): "`jr api -X / --method` accepts case-insensitive HTTP method values; DELETE, delete, Delete all parsed as `HttpMethod::Delete`" |
| Architecture | INTERNAL-ONLY | Single `#[arg]` annotation attribute addition; `HttpMethod` enum and `From<HttpMethod> for Method` impl unchanged |
| Stories | 1 story (quick-dev fast-path) | Single story: add `ignore_case = true` to the `--method` `#[arg]` annotation + 3 new parse tests |
| Verification Properties | NEW VP-590-001 | DELETE/delete/Delete all → `HttpMethod::Delete` → HTTP DELETE dispatched to server. Covers three input cases; also regression-pins lowercase `-X delete` (existing happy path) |
| Existing Tests | `tests/cli_handler.rs::test_handler_api_put_with_method_flag` (lowercase `-X put`) | Regression guard. The `ignore_case = true` attribute is purely additive — lowercase still parses. All existing api handler tests remain green |

### Other ValueEnum Scope Check

All `ValueEnum` usages in `src/cli/` were audited for similar case-sensitivity
candidates:

| Arg | ValueEnum | External convention? | Verdict |
|-----|-----------|---------------------|---------|
| `--method / -X` | `HttpMethod` | Yes — curl, gh api mandate uppercase | MODIFIED |
| `--output` | `OutputFormat { Table, Json }` | No external tool mandates uppercase `JSON`/`TABLE` | UNCHANGED |
| `shell` (completion) | `clap_complete::Shell` | External crate; handled by clap_complete | OUT OF SCOPE |

No scope expansion warranted. `--method` is the only arg where an external convention
mandates uppercase acceptance.

### BC Amendment Question

No existing BC governs `jr api --method` case-sensitivity. The fix is a pure clap
configuration conformance change; it does not require a pre-existing BC to proceed.
Recommended post-fix action: record micro-BC BC-X.1.011 in `cross-cutting.md` or the
api-passthrough section for spec completeness and future regression anchor. The
implementer may add `ignore_case = true` without BA pre-approval; BC-X.1.011 is
optional and rides as documentation alongside the story close.

CHANGELOG entry must reference both issue numbers: `#590` and `#582`.

### Trivial Scope Assessment

All four trivial-scope criteria evaluated:

- [x] Single module — PASSES: `src/cli/mod.rs` (one `#[arg]` annotation) + new test
- [x] No new BCs needed — PASSES: micro-BC is optional/post-fix, not blocking
- [x] No architecture change — PASSES: single attribute, no structural change
- [x] Low regression risk — PASSES: purely additive, existing tests unaffected

**Verdict: TRIVIAL. Quick-dev eligible.** All four criteria pass. Routing: single
story, F1 → F4 implementation → regression verification → F7-lite close. No full
F2/F3 ceremony.

### Holdout Scope

Scoped to `jr api` parser. Holdout fixture: wiremock server with `method("DELETE")`
mount; assert `jr api -X DELETE /path` returns the server's response (no clap error).
Three cases: uppercase, lowercase (regression guard), mixed-case.

### Files Changed

**Will be modified:**

| File | Nature of Change |
|------|-----------------|
| `src/cli/mod.rs` | Add `ignore_case = true` to `#[arg]` at line 127 (`--method` / `-X`) |
| `src/cli/api.rs` OR `tests/cli_handler.rs` | New parse tests: `-X DELETE` → `HttpMethod::Delete`; `-X delete` → `HttpMethod::Delete` (regression guard); `-X Delete` → `HttpMethod::Delete` (mixed-case) |

**Regression baseline (explicitly NOT changed):**

| File | Reason unchanged |
|------|-----------------|
| `src/cli/api.rs::HttpMethod` enum | `ignore_case` is on `#[arg]`, not the enum |
| `src/cli/api.rs::impl From<HttpMethod> for Method` | Enum variant unchanged |
| `tests/cli_handler.rs` — all existing api tests | Lowercase `-X put`/`post` still parse; additive change |
| `src/api/client.rs` | `send_raw`, `request` unaffected |

---

## Recommended Routing

### Issue #589 — Bug-Fix Route (Standard Rigor)

Severity HIGH; two source files; BC-3.4.016 EC amendment required; 7 Option-aware
sites; MED regression risk. Quick-dev is not appropriate.

Routing: bug-fix route with standard per-story delivery.

Pipeline:
1. BA finalizes EC-3.4.016-5 exit-64 message text (gate before story-writing)
2. BA amends BC-3.4.016 with EC-3.4.016-5 in `bc-3-issue-write.md`
3. Story-writer produces story with full AC tracing BC-3.4.016 EC-3.4.016-5 + VP-589-001
4. Per-story TDD delivery (implementer: type change + 7 sites + tests)
5. PR, review, merge
6. Holdout evaluation against id-absent allowedValues fixture

F2 spec-evolution ceremony and F3 full story-decomposition ceremony are skipped per
bug-fix intent. The EC amendment is not a new BC; it is a clarification clause on an
existing BC and rides with the single story.

### Issue #590/#582 — Quick-Dev Route (Trivial)

Severity LOW; single `#[arg]` attribute; no blocking BC needed; LOW regression risk.

Routing: quick-dev fast-path.

Pipeline:
1. Story: `ignore_case = true` on `--method` `#[arg]` + 3 parse tests
2. F4 implementation (no F2/F3 ceremony)
3. Regression verification (existing lowercase tests must stay green)
4. F7-lite close: CHANGELOG entry referencing both #590 and #582; optional
   micro-BC BC-X.1.011 recorded post-fix for spec completeness

---

## Cross-Bug Summary

| Dimension | #589 (AllowedValue.id) | #590/#582 (HttpMethod case) |
|-----------|----------------------|----------------------------|
| Source files changed | 2 | 1 |
| Call sites modified | 7 (mechanical, all in `field_resolve.rs`) | 1 attribute |
| BC change | BC-3.4.016 EC-3.4.016-5 (new clause) | None blocking; optional micro-BC post-fix |
| New VPs | VP-589-001 (new) + VP-396-008 extended + VP-396-002 clarified | VP-590-001 (new) |
| Architecture delta | Internal-only | Internal-only |
| Regression risk | MED | LOW |
| Trivial scope | No | Yes |
| Routing | Bug-fix, standard rigor | Quick-dev fast-path |
| Closes | #589 | #590, #582 |
