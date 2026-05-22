---
document_type: adversarial-report
issue: "#396"
pass: 1
date: "2026-05-22"
verdict: NOT-CLEAN
critical: 0
high: 4
medium: 7
low: 5
total_findings: 16
resolution_status: resolved
---

# Adversarial Review — Issue #396 F2 Pass 1

**VERDICT: NOT-CLEAN** (0 CRITICAL, 4 HIGH, 7 MEDIUM, 5 LOW)

---

## HIGH Findings

### HIGH-001 — EC-3.4.015-9 empty NAME false claim

EC-3.4.015-9 (empty NAME) falsely claimed a `parse_field_kv` parse error. BC-3.8.008 says
`parse_field_kv` splits on the FIRST `=` and the ONLY error is "missing `=`". Input `=VALUE`
contains an `=` → `parse_field_kv` returns Ok with empty key. Fix EC-3.4.015-9: empty NAME
is NOT caught by `parse_field_kv`; it falls through to Step 2 name resolution and exits 64
via the zero-match path (EC-3.4.015-1). Drop the false "mirrors JSM create path" claim. (Or,
if a dedicated empty-NAME guard is intended, specify it lives in `resolve_edit_fields` before
Step 1 and add a VP.)

**Resolution**: FIXED. EC-3.4.015-9 rewritten — empty NAME falls through to zero-match exit
path (EC-3.4.015-1), not `parse_field_kv`. The false "mirrors JSM create path" claim dropped.

---

### HIGH-002 — `--dry-run` × `--field` unspecified

`--dry-run` × `--field` is unspecified across all 3 BCs. `issue edit` has a shipped
`--dry-run`; BC-3.4.012/013 explicitly carve it out. Add an edge case to BC-3.4.015
(referenced from 016/017) specifying: whether `get_editmeta`/`list_fields()` still run under
`--dry-run` (recommend YES — read-only, needed for an accurate preview), whether the preview
shows resolved labels, and that Gate A/Gate B still fire. Add at least one VP/EC pinning
`--field` + `--dry-run`. Mirror EC-3.4.012-9.

**Resolution**: FIXED. EC-3.4.015-18 added to BC-3.4.015 specifying dry-run behavior: Gates
fire first; read-only HTTP (cache/field-list, editmeta) executes; PUT not issued; preview
shows resolved `--field` entries. VP-396-008 added, cited in BC-3.4.015 and BC-3.4.017.

---

### HIGH-003 — VP tri-surface mismatch VP-396-006

VP tri-surface mismatch: mapping table maps VP-396-006 to "BC-3.4.015, BC-3.4.016" but
BC-3.4.016 §Verification Properties anchors only VP-396-002. Either add VP-396-006 to
BC-3.4.016's §Verification Properties (BC-3.4.016 prose says cache behavior "applies here
equally" — argues for this), or correct the mapping-table row to BC-3.4.015 only. Make
frontmatter `related_bcs`, mapping table, and BC body all agree.

**Resolution**: FIXED. VP-396-006 added to BC-3.4.016 §Verification Properties with
explanatory note. Mapping table and BC body now agree.

---

### HIGH-004 — EC-3.4.015-16 cache-write-failure has no VP

Cache-write-failure path EC-3.4.015-16 has no VP. Add a sub-case to VP-396-006 (or a new VP)
exercising EC-3.4.015-16: simulate a `write_fields_cache` I/O failure, assert the
`warning: failed to write fields cache` stderr line, assert exit 0, assert resolution + PUT
still succeed. (Best-effort swallow must be positively tested.)

**Resolution**: FIXED. VP-396-007 added covering EC-3.4.015-16 (cache-write failure →
warning stderr, exit 0, resolution + PUT succeed). Cited in BC-3.4.015 §Verification
Properties.

---

## MEDIUM Findings

### MED-001 — `resolve_edit_fields` signature contradictory

`resolve_edit_fields` signature contradictory: F1 line 141 says
`-> Result<(Value, Vec<(String,String)>)>`; F1 line 425 + prd-delta §9 say
`resolve_edit_fields(client, key, &field_pairs, &mut fields, &mut changed_fields).await?`.
Pick ONE, state it canonically in BC-3.4.015 body. Recommend the `&mut` form `-> Result<()>`;
note the divergent F1 form as superseded.

**Resolution**: FIXED. Canonical `resolve_edit_fields` signature documented in BC-3.4.015
body (`&mut` form, `-> Result<()>`). F1 line-141 form marked explicitly superseded with
rationale.

---

### MED-002 — Gate B gaps

Gate B gaps: (a) two `--field` pairs targeting the same system field WITHOUT the dedicated
flag (`--field summary=A --field summary=B`) is not Gate-B-caught — state intended behavior
(last-write-wins, or error). (b) Clarify `--field type=X` (clap flag name, not the `issuetype`
system key) is treated as an ordinary name lookup and NOT detected as an overlap with `--type`.
Add an EC to BC-3.4.017.

**Resolution**: FIXED. EC-3.4.017-10 added (two `--field` pairs same key → last-write-wins,
no Gate B error). EC-3.4.017-11 added (`--field type=X` ≠ `issuetype`, falls to resolution
not Gate B; rationale: Gate B checks canonical Jira system field keys, `type` is not one).

---

### MED-003 — `customfield_\d+` bypass regex case-sensitive, Gate B case-insensitive

`customfield_\d+` bypass regex is case-sensitive but Gate B comparison is case-insensitive.
`--field CUSTOMFIELD_10001=X` would fall to name resolution and exit 64 with a confusing
"unknown field name" message. Add EC-3.4.015-17 for a mis-cased `customfield_` literal; OR
make the bypass prefix case-insensitive (digits stay digits) + add a VP. At minimum document
the deliberate choice with rationale.

**Resolution**: FIXED. EC-3.4.015-17 added documenting deliberate case-sensitive bypass. The
bypass remains case-sensitive (Jira always uses lowercase `customfield_` in API responses;
accepting uppercase would mask typos). Actionable hint added for zero-match path.

---

### MED-004 — Gate A postcondition unsatisfiable for `--jql`-multi-issue

Gate A postcondition "No HTTP calls ... no JQL execution" is unsatisfiable for the
`--jql`-multi-issue branch — you cannot know `--jql` matched 2+ issues without executing the
JQL search. Split the postcondition: positional-multi-key sub-case = truly no HTTP; `--jql`-
multi-issue sub-case = JQL search IS executed, but no `list_fields()`/`editmeta`/PUT. Reword
the Gate A postcondition and EC-3.4.017-2. (VP-396-005's test already mounts the JQL mock —
only the BC prose is wrong.)

**Resolution**: FIXED. Gate A postcondition split into two sub-cases: positional (no HTTP
at all) and `--jql` (JQL executes to determine match count; no list_fields/editmeta/PUT).
EC-3.4.017-2 updated to match.

---

### MED-005 — Number-field wire format underspecified

Number-field wire format underspecified (`5`→`f64`→`5.0` render; `5e3` round-trip). Same
`f64::to_string()` hazard BC-3.4.012 invariant 4 pins for `--points`, but the `--field`
number path has no EC/VP/snapshot. Add an EC to BC-3.4.015 pinning number serialization, and
a VP sub-case sending a `number`-type `--field` asserting the exact wire body.

**Resolution**: FIXED. EC-3.4.015-4a added pinning integer preservation (`5` → `5` not
`5.0`; `5e3` → `5000`; NaN/Inf → exit 64). VP-396-010 added covering number wire
serialization. Cited in BC-3.4.015 §Verification Properties.

---

### MED-006 — Multi-`--field` partial-failure and PUT-failure have no VP

Multi-`--field` partial-failure (EC-3.4.015-12, all-or-nothing) and `changed_fields`
discard-on-PUT-failure (invariant 4) have no VP. Add a VP/sub-case: (a) `--field A=ok
--field B=bad` → exit 64, zero PUT; (b) valid `--field` with PUT mock → 400 → field not
echoed, exit reflects failure.

**Resolution**: FIXED. EC-3.4.015-12 updated with all-or-nothing note. EC-3.4.015-12a added
(PUT-failure discard). VP-396-009 added covering both sub-cases.

---

### MED-007 — BC-3.4.017 invariant 1 ordering ambiguous

BC-3.4.017 invariant 1 ambiguous: when a context is BOTH multi-key AND flag-overlap, is Gate
A skipped? Reword: "Gate B's error is emitted and Gate A is NOT evaluated — exactly one error
message reaches stderr." Add an EC + VP sub-case.

**Resolution**: FIXED. BC-3.4.017 invariant 1 rewritten with explicit ordering: Gate B fires
before Gate A; exactly one error message; rationale given (flag-overlap is actionable
regardless of key count). EC-3.4.017-12 added for simultaneous Gate A + Gate B scenario.
VP-396-008 covers Gate-behavior-under-dry-run; the Gate-ordering behavior is pinned via
EC-3.4.017-12 (test name `test_BC_3_4_017_gate_b_fires_before_gate_a`).

---

## LOW Findings

### LOW-001 — EC-3.4.017-9 references "EC-15-11"

bc-3-issue-write.md EC-3.4.017-9 references "EC-15-11"; correct id is "EC-3.4.015-11". Fix.

**Resolution**: FIXED. Corrected to `EC-3.4.015-11`.

---

### LOW-002 — Count surfaces

Count surfaces: PASS. No action required.

**Resolution**: PASS — no action.

---

### LOW-003 — BC-3.4.016 id-bypass numeric collision

BC-3.4.016 id-bypass numeric collision: if option ids and labels overlap numerically, id-bypass
wins. Add a one-line note to EC-3.4.016-4.

**Resolution**: FIXED. EC-3.4.016-4 updated with note: id-bypass wins when option id and label
are numerically identical; deliberate disambiguation rule documented.

---

### LOW-004 — Test naming

Test naming convention: grandfathered. No action required.

**Resolution**: GRANDFATHERED — no action.

---

### LOW-005 — BC-INDEX Coverage Statistics 9th unguarded surface

[Process-gap] BC-INDEX Coverage Statistics is a 9th count surface not validated by the
existing guard scripts. Track as process-gap follow-up.

**Resolution**: PROCESS-GAP follow-up — no action from product-owner. The surface is
maintained manually alongside all edits that touch BC-INDEX.

---

## Post-Resolution State

- Total BCs: 583 (unchanged — adversary pass 1 does not add BCs)
- Total VPs for issue #396: 10 (VP-396-001 through VP-396-010)
- New VPs added in this pass: 4 (VP-396-007, VP-396-008, VP-396-009, VP-396-010)
- Guard scripts: both exit 0 after pass-1 amendments
