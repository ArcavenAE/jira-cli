# F5 Adversarial Finding Validation — Issue #396

**Subject:** `jr issue edit KEY --label add:foo --field NAME=VALUE` silently drops `--field`
**Date:** 2026-05-25
**Validator:** Research agent (local codebase inspection)
**Source codebase:** `/Users/zious/Documents/GITHUB/jira-cli` @ branch `develop`
**Authoritative reference:** `src/cli/issue/create.rs` (post-S-396 delivered code)

---

## Verdict

**CONFIRMED — HIGH severity.** The finding reproduces exactly as described.

The silent-drop is a real, exploitable correctness bug introduced by the
intersection of two pre-existing routing facts and one new flag:

1. `--label` short-circuits to `handle_edit_bulk_labels` at
   `src/cli/issue/create.rs:835-838` (a labels-only handler that does not
   accept `field_pairs`).
2. The `--label` mutual-exclusion block at `src/cli/issue/create.rs:445-489`
   explicitly exists to prevent silent data loss when `--label` is combined
   with another field flag — but its conflict list was written before `--field`
   existed and was not updated when S-396 shipped.
3. The C-1 guard at `src/cli/issue/create.rs:561-595` only fires when
   `effective_keys.len() > 1`, so single-key `--label add:foo --field X=Y`
   sails past every guard, executes `handle_edit_bulk_labels(keys, labels, ...)`,
   and returns `Ok(())` with `--field` never resolved, never PUT, never echoed.

The user gets exit 0, the label change is applied to Jira, and the `--field`
write is silently discarded.

---

## Step-by-step execution trace (verified)

| Step | Line(s) | Behavior |
|------|---------|----------|
| 1. Pre-HTTP "any change?" guard | `create.rs:376-396` | `has_any_field_change = true` because `!labels.is_empty()` is true. Passes. |
| 2. Gate B (flag-overlap) | `create.rs:405-435` | `--field NAME=VALUE` where NAME ∉ {summary, description, issuetype, priority} does not overlap; passes. |
| 3. `--label` conflict block | `create.rs:445-489` | Iterates: `summary`, `priority`, `issue_type`, `team`, `points`, `no_points`, `parent`, `no_parent`, `description`, `description_stdin`, `markdown`. **`field_pairs` is NOT in the list.** Conflicting Vec is empty. Passes. |
| 4. Resolve `effective_keys` | `create.rs:502-551` | Positional single key OR `--jql` resolving to exactly 1 issue → `effective_keys.len() == 1`. |
| 5. C-1 multi-key guard | `create.rs:561-595` | `effective_keys.len() > 1` is FALSE for single-key invocation. C-1 (which DOES include `--field` at line 584-586) never fires. |
| 6. Dry-run short-circuit | `create.rs:597-` | Skipped (not `--dry-run`). |
| 7. Bulk confirmation prompt | `create.rs:780-832` | Single-key → skipped. |
| 8. **Label routing fork** | `create.rs:834-838` | `if !labels.is_empty()` → `return handle_edit_bulk_labels(&effective_keys, labels, output_format, client, no_input).await;` |
| 9. Single-key `field_pairs` resolution | `create.rs:959-970` | **NEVER REACHED** — early return at step 8. |

**Result:** Exit 0, label PUT succeeds, `--field` silently ignored.
No echo, no warning, no error.

---

## Detailed evidence

### The label conflict block (`src/cli/issue/create.rs:445-489`)

The block enumerates 11 specific flags:

```rust
if !labels.is_empty() {
    let mut conflicting: Vec<&str> = Vec::new();
    if summary.is_some()        { conflicting.push("--summary"); }
    if priority.is_some()       { conflicting.push("--priority"); }
    if issue_type.is_some()     { conflicting.push("--type"); }
    if team.is_some()           { conflicting.push("--team"); }
    if points.is_some()         { conflicting.push("--points"); }
    if no_points                { conflicting.push("--no-points"); }
    if parent.is_some()         { conflicting.push("--parent"); }
    if no_parent                { conflicting.push("--no-parent"); }
    if description.is_some()    { conflicting.push("--description"); }
    if description_stdin        { conflicting.push("--description-stdin"); }
    if markdown                 { conflicting.push("--markdown"); }
    if !conflicting.is_empty() { return Err(JrError::UserError(...)); }
}
```

**Stated purpose** (`create.rs:437-444`, verbatim):

> `--label` is routed through a labels-only bulk path (`handle_edit_bulk_labels`) that
> does not honour concurrent `--summary`/`--priority`/`--type` flags. Combining them
> would silently drop the non-label fields (**exit 0, data loss**). Reject the
> combination HERE, before any HTTP call (including the JQL search), rather than
> silently discard the fields.
> Mixed label + field bulk edits require the schema-correct combined payload tracked
> at #331; until that lands, keep --label and field flags mutually exclusive.

This comment is the smoking gun: the block was explicitly designed to prevent the
exact failure mode the F5 finding describes. **`--field` is missing from the list
purely because it was added later (in S-396) and the block was not extended.**

### `handle_edit_bulk_labels` signature (`src/cli/issue/create.rs:1176-1182`)

```rust
async fn handle_edit_bulk_labels(
    keys: &[String],
    labels: Vec<String>,
    output_format: &OutputFormat,
    client: &JiraClient,
    _no_input: bool,
) -> Result<()> {
```

**`field_pairs: HashMap<String, String>` is not in the parameter list.** The
function builds a labels-only edited-fields payload (`build_labels_edited_fields`)
and POSTs to the Atlassian Bulk Fields API. Custom-field writes are not even
representable in this code path.

### The partition meta-test does NOT catch this (`src/cli/issue/create.rs:1521-1634`)

`test_343_every_edit_field_is_categorized` is a **static categorization invariant**:
it asserts every `IssueCommand::Edit` clap flag belongs to exactly one of
{`SELECTORS`, `BULK_SUPPORTED`, `REJECTED_IN_BULK`}, and that the three sets are
pairwise disjoint and exhaustive.

S-396 correctly added `"field"` to `REJECTED_IN_BULK` (line 1563):

```rust
let rejected_in_bulk: BTreeSet<&str> = [
    "parent", "no_parent", "team", "points", "no_points",
    "description", "description_stdin", "markdown",
    "field", // --field NAME=VALUE (S-396): single-key only (BC-3.4.017 Gate A)
].into_iter().collect();
```

The categorization is correct. The test passes. But the test never executes
`handle_edit` and cannot detect that the **runtime routing logic at line 835
short-circuits to a labels-only handler before any `REJECTED_IN_BULK` semantics
are honored**. The categorization is necessary but not sufficient — and S-396's
adversarial passes did not add a complementary runtime test for the
`--label` + `--field` interaction.

There is **no integration test in `tests/issue_edit_field.rs` or any sibling
test file that exercises `--label X --field Y` together** (`grep -ri 'label.*field\|field.*label'` across `tests/` returns no matching wiremock test).

---

## Spec cross-references

### BC-3.4.017 (Gate A + Gate B)

`.factory/specs/prd/bc-3-issue-write.md:1388-1542` defines BC-3.4.017 with two
explicit gates:

- **Gate A (C-1 multi-key/`--jql`-multi rejection):** Fires only when
  `effective_keys.len() > 1`. Does NOT cover single-key + `--label`.
- **Gate B (flag-overlap):** Fires only for `summary`, `description`,
  `issuetype`, `priority`. Explicitly scoped to "exactly four first-party system
  fields" (spec line 1428-1431). Does NOT cover `--label`.

**The spec is SILENT on `--field` + `--label`.** Searching the full BC-3.4.017
body, all 12 edge cases (EC-3.4.017-1 through -12), all invariants, and the
4 verification properties (VP-396-005, VP-396-008) — no mention of `--label`
combined with `--field`.

This is a spec gap. The F2 prd-delta-396.md and 9 adversarial passes never
analyzed the interaction with the pre-existing `--label` routing fork.

### BC-3.4.012 / BC-3.4.013 / BC-3.4.014 (issue #398 — silent-drop prevention precedent)

These three BCs (added 2026-05-21, four days before the F5 finding) established
the **echo-on-success contract**: every changed field MUST be reported in
table-mode stderr (`field → value`) or JSON `changed_fields` map. The intent
(per BC-3.4.013 invariant 6) was that machine-readable output is **lossless** —
a downstream tool can trust that what isn't echoed wasn't written, and what
WAS requested but isn't echoed indicates either a guard rejection (exit ≠ 0)
or a bug.

The F5 finding violates that contract directly: `--field Severity=Critical`
is requested, exit code is 0, but `changed_fields` does not contain `Severity`
(the labels-only path does not populate `changed_fields` at all). The downstream
contract pinned by `test_bc_3_4_013_description_echo_is_raw_input_string_not_marker`
(per the CLAUDE.md "issue edit description echo asymmetry" gotcha) is also
violated by parallel reasoning: the description channel is supposed to be
lossless, so by the same logic the `--field` channel must be lossless too.

The cycle precedent is clear: silent-drops were treated as **MUST-FIX
correctness bugs** during #398 and #110-part-2 work. This finding is the same
class of bug, on a flag introduced in a later sprint that didn't get the
same systematic guard-coverage analysis.

---

## Recommended fix

**Option A — add `--field` to the `--label` conflict block.** This is the
correct fix.

Concrete diff in `src/cli/issue/create.rs`, inside the existing block at
lines 445-489, after line 478 (after the `markdown` check):

```rust
    if markdown {
        conflicting.push("--markdown");
    }
    if !field_pairs.is_empty() {       // <-- new lines
        conflicting.push("--field");   // <-- new lines
    }                                  // <-- new lines
    if !conflicting.is_empty() {
        return Err(JrError::UserError(format!(
            "--label cannot be combined with {} in the same call. \
             Run separate `jr issue edit` commands, or open an issue to track \
             combined label + field bulk edits (see #331).",
            conflicting.join(", ")
        ))
        .into());
    }
```

### Why A, not B or C

- **Option B (extend `handle_edit_bulk_labels` to also process `field_pairs`)**
  violates single-responsibility, contradicts BC-3.4.017's design rationale
  ("Jira Cloud Bulk API does not support arbitrary custom field writes; adding
  bulk `--field` support would require a separate design pass" — spec line
  1433-1435), and re-opens the issue #331 schema-correctness question. It is
  larger than the F5 fix-PR budget.
- **Option C (unified handler)** is the long-term direction once #331 lands
  the canonical combined-payload schema, but it requires a separate design
  pass. Not appropriate for a hot-fix.
- **Option A** mirrors the existing pattern, matches the design intent of the
  conflict block, requires ~3 lines of code, and is regression-pinned trivially
  with one wiremock test that asserts exit 64 + the expected error message + no
  PUT/POST to `/rest/api/3/issue/*` or `/rest/api/3/bulk/issues/fields`.

### Required test additions (Option A)

1. **Unit/integration test in `tests/issue_edit_field.rs`** (new):
   `test_label_plus_field_rejected_with_exit_64_no_http`
   - Mounts wiremock that would 500 on any call (to catch unwanted HTTP).
   - Runs `jr issue edit FOO-1 --label add:foo --field Urgency=High`.
   - Asserts exit code 64.
   - Asserts stderr contains `"--label cannot be combined with --field"`.
   - Asserts wiremock recorded zero requests.
2. **Negative regression coverage**: at least one test confirming the existing
   conflict-block message still works for one of the previously-listed flags
   (e.g., `--label add:foo --summary "x"`) — there is currently no test for
   the conflict block at all (`grep "label cannot be combined" tests/` returns
   no matches). This is a pre-existing gap surfaced by the F5 investigation
   and should be filled in the same PR.

### Required spec amendments (Option A)

Append a new edge case to BC-3.4.017 in
`.factory/specs/prd/bc-3-issue-write.md:1480-1528`:

> - **EC-3.4.017-13:** `jr issue edit KEY --label add:foo --field Severity=Critical`
>   → label routing fork at `src/cli/issue/create.rs:835` would silently drop
>   `--field` (executes labels-only `handle_edit_bulk_labels` and returns
>   `Ok(())` with `field_pairs` never resolved or PUT). The dedicated
>   `--label` conflict block at `src/cli/issue/create.rs:445-489` rejects this
>   combination with exit 64 BEFORE the routing fork, mirroring the existing
>   pre-`--field` conflict pattern. Error message: `"--label cannot be combined
>   with --field in the same call. Run separate `jr issue edit` commands, or
>   open an issue to track combined label + field bulk edits (see #331)."`
>   No HTTP call is issued. Tracked at #331 for the long-term combined-payload
>   solution.

The CLAUDE.md gotcha under "`issue edit --field` constraints and JSM behavior
(issue #396)" should also be amended to note: "(6) `--field` cannot be combined
with `--label` in the same call — single-key + `--label` + `--field` is rejected
with exit 64 by the `--label` mutual-exclusion block (same block that rejects
`--label` + `--summary`/`--priority`/`--type`/etc.). Combined label + custom-field
bulk edits are tracked at #331."

---

## Impact on the F5 cycle

This **DOES become FIX-F5-001 PR** under the F5 "Fix PR Delivery (DF-025)"
protocol. Reasoning:

- **Severity HIGH:** Silent data loss is the worst class of CLI bug (the user
  trusts exit 0). The finding meets the bar that the #398 / #110-part-2 cycles
  set for the same class of bug (echo-asymmetry, description-stdin trailing
  newline, etc.) — those all got fix-PRs with regression tests.
- **Symmetry with established precedent:** The `--label` conflict block itself
  was added as a fix-PR for the exact same failure mode against a different
  flag. Not fixing this leaves an asymmetric guarantee (`--label` + `--summary`
  is rejected, `--label` + `--field` silently drops) — which the BC-3.4 series
  contracts implicitly forbid.
- **Cheap fix, cheap test:** ~3 lines of code, one wiremock test, one BC
  edge case. Well within fix-PR scope.
- **Not deferrable:** S-396 has already merged. Every subsequent user
  invocation of the unfortunate combination loses data silently. There is no
  feature flag, no workaround the user can discover from output (because there
  IS no error output). The only mitigation is documentation, which doesn't
  help anyone who learned `--label` and `--field` independently.
- **Not blocked on #331:** Issue #331 tracks the long-term combined-payload
  schema correctness, but the fix here is purely an additional rejection on
  the existing mutex pattern — it does not depend on #331 progressing. The
  conflict-block error message already directs users to #331 for the future
  combined path.

**Recommended action:**
1. Open `fix/issue-396-label-field-silent-drop` branch from `develop`.
2. Apply Option A diff to `src/cli/issue/create.rs:478` insertion site.
3. Add `test_label_plus_field_rejected_with_exit_64_no_http` to
   `tests/issue_edit_field.rs` + a negative regression test for an
   existing conflict flag (e.g., `--label` + `--summary`).
4. Append EC-3.4.017-13 to `.factory/specs/prd/bc-3-issue-write.md`.
5. Update CLAUDE.md gotcha entry under issue #396 with item (6).
6. Run `scripts/check-spec-counts.sh` (no count change expected — EC count
   inside a BC is body-only, not frontmatter).
7. Conventional Commit: `fix(S-396): reject --label combined with --field to prevent silent data loss`
8. PR to `develop` per the dev-release-workflow memory.

---

## Verification methodology

This validation used **local codebase inspection only** — no external research
was warranted because the question is about observable behavior of delivered
code, not unknown library semantics. Verification surfaces:

| Surface | File | Lines | Finding |
|---------|------|-------|---------|
| Execution-path read 1 | `src/cli/issue/create.rs` | 370-489 | Confirmed all four early guards do not catch single-key `--label`+`--field`. |
| Execution-path read 2 | `src/cli/issue/create.rs` | 561-595 | Confirmed C-1 includes `--field` but is `effective_keys.len() > 1` gated. |
| Execution-path read 3 | `src/cli/issue/create.rs` | 834-838 | Confirmed the `!labels.is_empty()` short-circuit at line 835. |
| Handler signature | `src/cli/issue/create.rs` | 1176-1182 | Confirmed `handle_edit_bulk_labels` does not take `field_pairs`. |
| Single-key `--field` resolution | `src/cli/issue/create.rs` | 959-970 | Confirmed `resolve_edit_fields` is the only path that wires `field_pairs` into the PUT body; only reached when label short-circuit does NOT fire. |
| Partition meta-test | `src/cli/issue/create.rs` | 1521-1634 | Confirmed static categorization invariant only; does not exercise runtime routing. |
| Spec BC-3.4.017 | `.factory/specs/prd/bc-3-issue-write.md` | 1388-1542 | Confirmed silent on `--field` + `--label`; Gate B scoped to four system fields only. |
| Test surface | `tests/issue_edit_field.rs` + sibling files | full | Confirmed no test combines `--label` and `--field`. |
| F2 adversarial passes | `.factory/phase-f2-spec-evolution/adversarial-396-pass-*.md` | full | Confirmed `--label` + `--field` interaction was never analyzed in any of the 9 passes. |
| Historical intent | `src/cli/issue/create.rs` | 437-444 | Confirmed the `--label` conflict block was explicitly added to prevent the exact failure mode the F5 finding describes — `--field` was simply not in scope when the block was written. |

**Confidence: HIGH.** All evidence converges. The bug is reproducible without
running the binary (the code path is short enough to verify by reading).
