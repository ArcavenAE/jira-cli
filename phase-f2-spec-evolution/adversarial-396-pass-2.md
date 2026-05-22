---
document_type: adversarial-report
issue: "#396"
pass: 2
date: "2026-05-22"
verdict: NOT-CLEAN
critical: 0
high: 2
medium: 5
observations_addressed: 2
total_findings: 7
resolution_status: resolved
---

# Adversarial Review — Issue #396 F2 Pass 2

**VERDICT: NOT-CLEAN** (0 CRITICAL, 2 HIGH, 5 MEDIUM, 2 Observations addressed)

All findings are new — no retreads of pass-1.

---

## HIGH Findings

### P2-001 (count-surface drift) — Footer still at pre-#396 values

`.factory/specs/prd/bc-3-issue-write.md:2067` end-of-file footer still read
"## Total BCs in this file: 71 individually-bodied (cumulative 100 ...)" —
pre-#396 values, contradicting the frontmatter/preamble/BC-INDEX/CANONICAL
surfaces now at 74/103. Additionally, this footer surface was not present in
prd-delta-396.md §11's Count Surfaces table.

**Resolution**: FIXED.
- Footer updated to "74 individually-bodied (cumulative 103 incl. range-collapsed; see BC-INDEX.md)".
- Footer surface row added to prd-delta-396.md §11 Count Surfaces table.

---

### P2-002 (process-gap) — Guard script blind spot for footer surface

`scripts/check-bc-cumulative-counts.sh` body-preamble check used `sed '/^## /q'`
which stops at the first `##` and never reaches the trailing "## Total BCs in this
file:" footer. That footer existed in bc-3 (and bc-2) by template → silent drift
could recur without detection.

**Resolution**: FIXED.
- `scripts/check-bc-cumulative-counts.sh` extended with **Surface H**: parses
  "## Total BCs in this file: N individually-bodied (cumulative M ...)" footer.
- Asserts N == `definitional_count` frontmatter AND M == `total_bcs` frontmatter.
- Check is **conditional**: only validates when footer is present AND uses the
  standard "individually-bodied (cumulative M ...)" format. Files without the footer
  (bc-1, bc-4..7, cross-cutting) are silently skipped. Files with a non-standard
  footer (e.g., bc-2's "N (representative set; ...)") are also skipped gracefully.
- Script header comment updated to document 9 surfaces (was 8).
- Summary output message updated to note Surface H.
- Both guard scripts exit 0 after P2-001 fix is applied.

---

## MEDIUM Findings

### P2-003 — BC-3.4.017 Edge Cases non-monotonic ordering

BC-3.4.017 Edge Cases list was non-monotonic: order was EC-...-8, -9, -12, -10, -11.
This is confusing for readers navigating to a specific EC by number.

**Resolution**: FIXED. Reordered to -8, -9, -10, -11, -12 (numeric sequence). No
behavioral change.

---

### P2-004 — VP-396-001 one-liner missing "number" coverage

VP-396-001's one-liner in the BC-3.4.015 body read "String `--field` value..." but the
verification-delta lines 28 and 459 said "String/number". VP-396-010 covers number
*wire serialization*, not the echo — the echo path for number fields is covered by
VP-396-001.

**Resolution**: FIXED. VP-396-001 one-liner restored to "String/number `--field` value
appears in `changed_fields` echo...". VP-396-010 remains as the wire-format pin.

---

### P2-005 — EC-3.4.015-9 false JSM parenthetical

EC-3.4.015-9 (bc-3-issue-write.md ~line 1120) contained a parenthetical claiming "The
`--field` argument on the JSM create path has the same behavior — the empty-key falls
to resolution, not to parse, unless a dedicated guard is added separately." BC-3.8.008
never specifies empty-NAME behavior (its only documented error is "Missing `=`").
Citing BC-3.8.008 as a guarantee it does not make is a false claim.

**Resolution**: FIXED. The parenthetical is dropped entirely. EC-3.4.015-9 now states
only the verified behavior for the edit path.

---

### P2-006 (implementation-blocking) — `resolve_edit_fields` signature missing `profile: &str`

The canonical `resolve_edit_fields` signature lacked `profile: &str`. The function
calls `read_fields_cache(profile)` and `write_fields_cache(profile, ...)` internally.
CLAUDE.md hard rule: every cache reader/writer takes `profile: &str`; cross-profile
leakage (sandbox vs prod custom-field IDs) is a correctness bug, not a UX issue.
Without `profile` in the signature the function cannot satisfy its own cache contract.

**Resolution**: FIXED.
- Canonical signature amended to:
  `resolve_edit_fields(client: &JiraClient, profile: &str, key: &str, field_pairs: &[(String, String)], fields: &mut Value, changed_fields: &mut BTreeMap<String, String>) -> Result<()>`
- `profile: &str` is the second argument (after `client`).
- Caller passes `&config.active_profile_name`.
- prd-delta-396.md §9 call site updated to:
  `resolve_edit_fields(client, &config.active_profile_name, key, &field_pairs, &mut fields, &mut changed_fields).await?`
- F1 divergent form (which also lacked `profile`) marked superseded.

---

### P2-007 — VP-396-007 missing stdout-unpolluted assertion

VP-396-007 (cache-write-failure) asserted the `warning:` line on stderr and
`changed_fields` correctness, but did not assert `--output json` STDOUT is unpolluted.
Profile-4 channel separation (stdout = structured data; stderr = diagnostics/warnings)
must be positively tested for the best-effort writer warning path.

**Resolution**: FIXED. VP-396-007 extended with a `--output json` stdout-unpolluted
sub-case:
- Assert stdout does NOT contain `"warning"` substring.
- Assert stderr contains `"warning: failed to write fields cache"`.
- Assert stdout is valid JSON.
- Mapping table row updated to note channel-separation pin.
- New suggested test name: `test_BC_3_4_015_cache_write_failure_warning_on_stderr_not_stdout`.

---

## Observations Addressed

### OBS-1 — `resolve_edit_fields` placement silently resolved F1 Q5

BC-3.4.015 Trace places `resolve_edit_fields` in `src/cli/issue/helpers.rs`, silently
resolving F1 open-question Q5 (which file owns the orchestration function). This
decision was not recorded in prd-delta-396.md §2 Locked Design Decisions.

**Resolution**: FIXED. New row added to prd-delta-396.md §2 table: "`resolve_edit_fields`
placement → `src/cli/issue/helpers.rs`; silently resolves F1 Q5; rationale: existing
helper module for `handle_edit`-related resolutions." Marked `[OBS-1]`.

---

### OBS-5 — EC-3.4.015-4 "non-numeric" is too loose

EC-3.4.015-4's "non-numeric VALUE → parse fails" wording was loose: `"inf".parse::<f64>()`
succeeds in Rust, so NaN/Inf is rejected at `serde_json::Number::from_f64` (EC-4a's path),
not at the parse step. The two failure modes were conflated.

**Resolution**: FIXED. EC-3.4.015-4 rewritten to:
- Document two distinct failure modes: (a) `f64` parse failure for non-numeric strings
  (e.g., `"abc"`) and (b) `serde_json::Number::from_f64` returning `None` for
  non-finite values (NaN, +Inf, -Inf) that parse successfully as `f64`.
- Wording tightened to "non-numeric or non-finite VALUE".
- Cross-reference to EC-3.4.015-4a added.

---

## Observations NOT Addressed

- **OBS-2, OBS-3, OBS-4**: No action required per adversary instructions.

---

## Post-Resolution State

- Total BCs: 583 (unchanged — adversary pass 2 does not add BCs)
- Total VPs for issue #396: 10 (VP-396-001 through VP-396-010; unchanged from pass 1)
- Guard scripts: both exit 0 after pass-2 amendments
- `check-bc-cumulative-counts.sh` now validates 9 surfaces (Surface H added)
