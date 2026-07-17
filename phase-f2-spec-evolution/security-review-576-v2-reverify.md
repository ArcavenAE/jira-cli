---
document_type: security-review
level: ops
version: "3.0"
status: final
producer: security-reviewer
timestamp: 2026-07-17T00:00:00
feature: SOH-ATTACHMENTS-1
issues: "#576, #585"
phase: F2
authored: 2026-07-17
reviewer_role: security
verdict: APPROVE-WITH-NOTES
inputs:
  - ".factory/phase-f2-spec-evolution/security-review-576-v2.md"
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576.md"
baseline_review: "security-review-576-v2.md"
spec_version_reviewed: "1.3.80"
total_findings: 6
critical: 0
high: 0
medium: 0
low: 0
info: 2
prior_findings_verified: 4
prior_findings_status: all_resolved
new_findings: 2
severity_summary: >
  Baseline v2 (1.3.79, SPEC-CHANGES-REQUIRED): 1 MEDIUM (CWE-116 display sanitization),
  1 LOW (CWE-22 ?redirect=false prohibition body clause), 2 INFO (batch server-ID trust
  assumption, single-id overwrite-refuse EC gap). All four RESOLVED at v1.3.80. No new
  MEDIUM/HIGH/CRITICAL findings. Two new INFO observations (S1 table earliest-consumer
  ambiguity, Unicode residual scope unstated). Regression check: SEC-576-001..007 all
  intact, no regression detected.
traces_to: "F3 story decomposition gate — security sign-off required before stories can be written"
---

# Security Re-Verify v3: SOH-ATTACHMENTS-1 Attachment Read/Write (#576 + #585)

**Review scope**: Fresh-context re-verification of the four SEC-576-v2 findings applied in spec
version 1.3.80 (SEC-576-V2-ROUND, `prd-delta-576.md`). Baseline: `security-review-576-v2.md`
(SPEC-CHANGES-REQUIRED at v1.3.79). No implementation exists; this is a spec-only review.

Artifacts read in full:
- `security-review-576-v2.md` — prior findings with exact recommended wording
- `bc-2-issue-read.md` §2.7: BC-2.7.007 (lines 719–782), BC-2.7.008 (784–817), BC-2.7.010
  (846–891), BC-2.7.011 (893–934) and all Trace fields
- `bc-3-issue-write.md` §3.9: BC-3.9.015 (3650–3694), BC-3.9.017 (3744–3802) and Trace fields
- `prd-delta-576.md` SEC-576-V2-ROUND disposition table (lines 756–771)

---

## Executive Summary

All four findings from `security-review-576-v2.md` are **RESOLVED** at v1.3.80 with no
regression. The SEC-576-V2-ROUND applied the exact remediations recommended in the prior
review. Two INFO-level observations are raised from fresh-context reading; neither blocks
story decomposition.

**Verdict: APPROVE-WITH-NOTES**

F3 story decomposition may proceed. The notes (INFO only) are guidance for S1 and S2
story-writers and do not require spec changes before story authoring begins.

---

## Part 1: Prior Finding Re-Verification (SEC-576-008..011)

### SEC-576-011 — MEDIUM — CWE-116 — Display Sanitization for Terminal Output

**Status**: **RESOLVED**

**Primary clause verified (BC-2.7.011, last paragraph before Trace field)**:

The spec now contains a dedicated "Display sanitization for terminal output" section at
BC-2.7.011 with the following properties, each verified against the recommended wording:

1. **Control-char range correct**: "ALL ASCII control characters in the byte range 0x00–0x1F
   and 0x7F MUST be replaced with `?`". This range covers:
   - `\r` (0x0D, cursor-to-start overwrite): YES — fully neutralized.
   - ANSI escape sequences (ESC = 0x1B, within 0x00–0x1F): YES — the leading ESC byte is
     replaced with `?`, rendering `\x1b[31m` as `?[31m` in displayed output. The terminal
     emits printable characters only; no sequence interpretation occurs.
   - Other control characters (`\n` 0x0A, `\t` 0x09, `\x00` NUL, etc.): all covered.

2. **Applies to ALL TTY echo sites**: "confirmation prompts, collision-skip warnings,
   degenerate-name warnings, table cells, or any other human-readable stderr/stdout" — the
   scope is correctly broad and covers every human-readable display path.

3. **Display-only (RAW preserved for disk/JSON/API)**: "The sanitization is display-only:
   the RAW value continues to be used for disk writes (the `sanitize_attachment_filename`
   pipeline above), JSON output (`downloaded[].filename`, attachment list array), and all
   Jira API calls." Correct and complete.

4. **`--no-color` caveat**: "The `--no-color` flag controls only `jr`'s own ANSI output and
   does NOT strip attacker-injected control characters from displayed filenames." Correctly
   addresses the original finding's concern that `--no-color` was not a substitute mitigation.

5. **Implementation guidance**: `display_sanitize_filename(name: &str) -> String` helper
   pattern mandated at every call site that echoes server-supplied filenames in human mode.

6. **Taxonomy compliance**: correctly classified as applying to human mode only; JSON mode
   paths carry RAW values by spec; no new hint/error class — modifies the display channel of
   existing warnings.

**Cross-references verified at each recommended site**:

- **BC-2.7.008 Overwrite behavior (collision-skip warnings)**: "**Display-sanitization
  cross-reference (SEC-576-011)**: `<filename>` in any collision-skip warning is a
  server-supplied value and MUST be display-sanitized (all ASCII control characters 0x00–0x1F
  and 0x7F replaced with `?`) before writing to a TTY, per BC-2.7.011 display-sanitization
  requirement. RAW value retained in JSON mode." **PRESENT.** ✅

- **BC-2.7.010 degenerate-name warning**: "**Display-sanitization cross-reference
  (SEC-576-011)**: the `<raw>` value in the degenerate-name warning ... is a server-supplied
  attachment filename and MUST be display-sanitized (all ASCII control characters 0x00–0x1F
  and 0x7F replaced with `?`) before writing to a TTY, per BC-2.7.011 display-sanitization
  requirement. RAW value retained in JSON mode (this warning is a hint, suppressed in JSON
  mode — no exposure vector in that path)." **PRESENT.** ✅

- **BC-3.9.015 step 1 (delete confirmation prompt)**: "`<filename>` MUST be display-sanitized
  (all ASCII control characters 0x00–0x1F and 0x7F replaced with `?`) before writing to the
  TTY per BC-2.7.011 display-sanitization requirement (SEC-576-011 — CWE-116); this prevents
  terminal injection via crafted filenames embedded in the confirmation prompt." **PRESENT as
  inline clause in step 1 mechanics.** ✅

- **BC-3.9.017 step 2 (--replace-existing prompt)**: "**Display-sanitization cross-reference
  (SEC-576-011)**: all `<filenameN>` values enumerated in any gate prompt (the ≥1-match prompt
  and the combined prompt above) are server-supplied attachment filenames and MUST be
  display-sanitized (all ASCII control characters 0x00–0x1F and 0x7F replaced with `?`) per
  BC-2.7.011 display-sanitization requirement before writing to the TTY. This prevents
  terminal injection via crafted attachment names in the confirmation prompt. RAW values are
  not exposed in any output channel on the prompt path." **PRESENT.** ✅

**Assessment of neutralization completeness**:

- `\r`-based overwrite (the primary attack vector): fully neutralized. `\r` = 0x0D is within
  0x00–0x1F. A filename like `\rConfirm installation of trusted software? [y/N] ` becomes
  `?Confirm installation of trusted software? [y/N] ` — the cursor-return character is gone
  and the confirmation prompt is not overwritten.

- ANSI escape sequences: effectively neutralized. Standard 7-bit ANSI sequences start with
  ESC (0x1B), which is stripped by the 0x00–0x1F rule. The remaining bytes (`[31m...`) are
  printable and are not interpreted by any standard terminal emulator.

- Unicode bidirectional control characters (U+202E RIGHT-TO-LEFT OVERRIDE, U+200F RLM, etc.)
  and Unicode line separators (U+2028, U+2029): NOT covered by the 0x00–0x1F/0x7F range
  (these are multi-byte UTF-8 sequences with no byte in those ranges). This is an acceptable
  residual — see NEW-576-V3-002 (INFO) below for scope discussion.

**SEC-576-011 status: RESOLVED.**

---

### SEC-576-009 — LOW — CWE-22 — `?redirect=false` Prohibition

**Status**: **RESOLVED**

**Clause verified (BC-2.7.007 step 2)**:

The following text is now present inline in the step 2 wire-path description (not solely in
the Trace or in a "CRITICAL" parenthetical within the "Redirect following" paragraph):

> **`?redirect=false` is prohibited on this endpoint (JRACLOUD-97046, SEC-576-009)**: The
> content URL MUST be issued with no additional query parameters — appending `?redirect=false`
> changes the server's redirect behavior and invalidates the credential-stripping invariant
> established by EC-2.7.007-3. The download MUST follow Jira's CDN redirect via reqwest's
> default redirect policy; no custom redirect policy is permitted on this endpoint.

This satisfies the original requirement: the prohibition is **normative BC body text** in step
2 (the primary implementation reference), not only in the Trace field. The consequence of
violating the prohibition is explicitly stated ("invalidates the credential-stripping
invariant established by EC-2.7.007-3"), which is stronger than the recommended wording.

The "Redirect following" paragraph additionally retains a "CRITICAL: `?redirect=false` MUST
NOT be used" sentence — now redundant, but providing defense-in-depth reinforcement. No
conflict with the body clause.

**Credential-stripping invariant**: intact. EC-2.7.007-3 (distinct-host wiremock requirement)
is unchanged and correctly referenced from the prohibition clause.

**SEC-576-009 status: RESOLVED.**

---

### SEC-576-008 — INFO — CWE-22 — Batch Degenerate-ID Server-Trust Assumption

**Status**: **RESOLVED**

**Note verified (BC-2.7.010, "Trust assumption for server-supplied IDs in batch mode")**:

> **Trust assumption for server-supplied IDs in batch mode (SEC-576-008, INFO)**: the
> assertion that `fields.attachment[].id` values are numeric-only rests on the behavioral
> invariant of the legitimate Jira Cloud API. For single-`--id` mode the numeric invariant
> holds by construction — the user-supplied AID is validated against `^[0-9]+$` before any
> HTTP call (BC-2.7.007 AID validation, CWE-88). For batch mode (`--all`/`--newest N`) the
> IDs originate from server API responses and carry no client-side `^[0-9]+$` validation — the
> spec accepts this on the basis that a legitimate Jira server always returns numeric attachment
> IDs. A compromised or rogue server returning non-numeric IDs in batch responses is outside
> the stated threat model for this check. Implementers MAY apply `^[0-9]+$` validation to
> server-supplied batch IDs before using them in the degenerate-fallback naming path as
> additional defense-in-depth.

This note:
1. Correctly distinguishes single-id (user-supplied, validated by construction) from batch
   (server-supplied, no client-side validation).
2. Accurately scopes the threat model (rogue/compromised server is outside the stated model).
3. Preserves the CWE-88 single-id validation reference.
4. Includes the MAY defense-in-depth language for implementers.

**SEC-576-008 status: RESOLVED.**

---

### SEC-576-010 — INFO — Single-ID Overwrite-Refuse Pre-Flight Underspecified

**Status**: **RESOLVED**

**EC-2.7.007-12 verified (BC-2.7.007, after EC-2.7.007-11)**:

> **EC-2.7.007-12** (single-`--id` overwrite-refuse pre-flight — `--out <PATH>` targets an
> existing regular file without `--force` — SEC-576-010): When `--out <PATH>` is supplied and
> the resolved path already exists as a regular file and `--force` is absent, `jr` exits 64
> before any download: `"File already exists: <path>. Use --force to overwrite."` Checked
> pre-download in the same pre-flight family as EC-2.7.007-6 (parent-exists) and
> EC-2.7.007-11 (is-directory), firing before the step-1 metadata GET per P32-001 ordering
> (fail cheap/offline first). `--force` bypasses this check and overwrites the existing file
> silently upon download completion — mirrors the batch path `--force` semantics in
> BC-2.7.008. **Stderr-clause taxonomy (§2.7 taxonomy, P25/P30)**: this is an ERROR exit
> (exit 64), not a hint; JSON mode: this check fires pre-HTTP and exits 64 before any output
> is produced — no manifest envelope is emitted (consistent with EC-2.7.007-6 and
> EC-2.7.007-11 behavior).

This EC satisfies all four recommended elements:
1. **Exit code**: exit 64. ✅
2. **Error message**: `"File already exists: <path>. Use --force to overwrite."` ✅
3. **Scope**: applies when `--out <PATH>` targets an existing regular file without `--force`. ✅
4. **`--force` semantics**: silently overwrites, mirrors batch path. ✅

Additionally: P32-001 pre-HTTP ordering is correctly stated (fires before step-1 metadata GET
— this is the correct behavior when `--out` is supplied since the path is known before any
HTTP call); §2.7 taxonomy compliance is documented (ERROR, no JSON envelope pre-HTTP). These
additions exceed the original recommendation and are correctly specified.

**SEC-576-010 status: RESOLVED.**

---

## Part 2: Regression Check (SEC-576-001..007)

Spot-check of the seven baseline findings (v1.3.44, all verified resolved at v1.3.79).

| ID | Spot-check | v1.3.80 status |
|----|-----------|----------------|
| SEC-576-001 (CWE-22 Windows devices) | BC-2.7.011 Windows device-name caller note + test matrix (`CON`, `NUL`, `COM1`, `nul.txt`) still present verbatim | NO REGRESSION ✅ |
| SEC-576-002 (CWE-22 containment check) | BC-2.7.011 two-step `canonicalize(out_dir)` + `starts_with` procedure intact; "Do NOT call `canonicalize()` on the joined path" note present; `--out <PATH>` exclusion (pure does-not-apply) still correct | NO REGRESSION ✅ |
| SEC-576-003 (CWE-522 credential-stripping) | EC-2.7.007-3 (distinct-host wiremock) present verbatim; SEC-576-009 body clause added to step 2 explicitly references EC-2.7.007-3 as the invalidated invariant — reinforced, not weakened | NO REGRESSION ✅ |
| SEC-576-004 (CWE-93 multipart encoding) | BC-3.9.001 not modified by SEC-576-V2-ROUND; Trace for BC-3.9.001 does not include v1.3.80 entries, confirming no modification | NO REGRESSION ✅ |
| SEC-576-005 (CWE-352 X-Atlassian-Token) | Same — BC-3.9.001 and BC-3.9.003 Step 1 not modified | NO REGRESSION ✅ |
| SEC-576-006 (stale serviceDeskId) | BC-X.8.010 not modified by SEC-576-V2-ROUND; BC-3.9.003 Step 1 self-heal sentence confirmed unchanged | NO REGRESSION ✅ |
| SEC-576-007 (trailing dots/spaces) | BC-2.7.011 step 5.5 present verbatim | NO REGRESSION ✅ |

---

## Part 3: New Observations

### NEW-576-V3-001 — INFO — "Earliest consumer: S2" designation may understate BC-2.7.001 (S1) table obligation

**Severity**: INFO
**Affected BC**: BC-2.7.011 (display-sanitization clause, "Earliest consumer" note), BC-2.7.001
**Status**: DOES NOT BLOCK F3

**Observation**: The display-sanitization primary clause in BC-2.7.011 states:

> **Earliest consumer: S2** (Story 2 — first surface to write server-supplied filenames to
> human-readable output; S4 story-writers must allocate display-sanitization at confirmation
> prompt call sites per DEC-184 R3.13).

BC-2.7.001 (`attachment list <KEY>` table output, Story S1) also echoes server-supplied
`filename` values in a `comfy-table` rendered to stdout. comfy-table writes cell content
verbatim; a cell containing ANSI escape sequences (e.g., `\x1b[2J`) would be interpreted by
a standard terminal, clearing the screen during a `jr issue attachment list` invocation. The
"Earliest consumer: S2" language names S2 as the first story requiring the
`display_sanitize_filename` helper, but S1 ships the list table first.

**Mitigating factors**:
- The primary clause's scope includes "table cells" and "any other human-readable stderr/stdout"
  — S1's table is covered by the general wording.
- No cross-reference is missing per the original finding's recommended list (which covered
  BC-2.7.008/BC-2.7.010/BC-3.9.015/BC-3.9.017; BC-2.7.001 was only a parenthetical).
- An attacker injecting ANSI into a list table can cause cosmetic terminal disruption but
  cannot overwrite a prompt the user is about to respond to (the primary attack vector).

**Recommendation for S1 story-writer**: explicitly apply `display_sanitize_filename` (or
equivalent inline sanitization) to the `filename` cell value in BC-2.7.001 table rendering,
despite the "earliest consumer: S2" designation in BC-2.7.011. The spec text already mandates
it via "table cells" in the general clause; the story-level allocation simply should not rely
on "S2" to mean "S1 is exempt."

This is a documentation precision gap in the "Earliest consumer" note, not a security hole
in the spec.

---

### NEW-576-V3-002 — INFO — Unicode bidirectional control characters are an unstated residual

**Severity**: INFO
**Affected BC**: BC-2.7.011 (display-sanitization clause)
**Status**: ACCEPTABLE RESIDUAL — DOES NOT BLOCK F3

**Observation**: The display-sanitization clause covers "ALL ASCII control characters in the
byte range 0x00–0x1F and 0x7F." Unicode bidirectional control characters — in particular
U+202E (RIGHT-TO-LEFT OVERRIDE), U+200F (RIGHT-TO-LEFT MARK), U+2066–U+2069 (isolate
controls) — and Unicode line terminators (U+2028 LINE SEPARATOR, U+2029 PARAGRAPH SEPARATOR)
are not covered. They are multi-byte UTF-8 sequences with no individual byte falling in
0x00–0x1F or 0x7F.

**Impact assessment**: U+202E can cause visual reordering of the filename as displayed in
certain terminals (e.g., a filename stored as `gpj.esuflam` displayed as `mafluse.jpg` in
RTL context). This is a UI redress concern, but it differs fundamentally from the CR/ANSI
overwrite threat: the confirmation prompt prefix ("Delete attachment" / "Replace existing
attachment(s)") is not overwritten; only the filename portion is visually reordered. The user
still sees a prompt that begins with the expected destructive-operation label.

**Why this is acceptable**:
1. The original finding (SEC-576-011) scoped the requirement to ASCII control characters.
   The remediation matches that scope exactly. The approved spec change is correct as stated.
2. Exploiting U+202E requires a terminal rendering engine with bidirectional text support
   and a system font covering the relevant Unicode ranges. Standard terminal emulators (iTerm2
   on macOS with common fonts, GNOME Terminal, Windows Terminal) DO render bidi; the risk is
   real but the attack requires a more sophisticated filename crafting.
3. The primary attack vector — overwriting the prompt text to make the user believe they are
   confirming a different operation — is not achievable via bidi override alone. The worst case
   is a visually reordered filename within the prompt, which still contains the AID and the
   "Delete attachment" prefix.

**Recommendation**: The BC-2.7.011 display-sanitization clause should ideally add a sentence
explicitly stating that Unicode bidi controls (U+202E etc.) are accepted residuals outside
the current specification scope. This removes ambiguity about whether the helper function
needs Unicode stripping. This is a documentation quality improvement, not a security
requirement for F3.

---

## Summary Table

### v1.3.79 Findings (from security-review-576-v2.md) — all re-verified at v1.3.80

| ID | Severity | CWE | Affected BC(s) | v1.3.80 status |
|----|----------|-----|----------------|----------------|
| SEC-576-011 | MEDIUM | CWE-116 | BC-2.7.011 (primary), BC-2.7.008/010/BC-3.9.015/017 (cross-refs) | **RESOLVED** |
| SEC-576-009 | LOW | CWE-22 | BC-2.7.007 step 2 | **RESOLVED** |
| SEC-576-008 | INFO | CWE-22 | BC-2.7.010 | **RESOLVED** |
| SEC-576-010 | INFO | — | BC-2.7.007 (EC-2.7.007-12) | **RESOLVED** |

### New Observations (v1.3.80 fresh-context reading)

| ID | Severity | Affected BC | Status |
|----|----------|-------------|--------|
| NEW-576-V3-001 | INFO | BC-2.7.011, BC-2.7.001 | Guidance for S1 story-writer; no spec change required |
| NEW-576-V3-002 | INFO | BC-2.7.011 | Acceptable residual; no spec change required |

### Baseline regression check (SEC-576-001..007)

All seven baseline findings confirmed intact. No regression detected.

---

## Verdict: APPROVE-WITH-NOTES

All four findings from `security-review-576-v2.md` are **RESOLVED** at v1.3.80. The
SEC-576-V2-ROUND applied the recommended remediations correctly and in several cases with
greater precision than the recommended wording. No new MEDIUM, HIGH, or CRITICAL findings
are raised.

**F3 story decomposition may proceed.**

The two INFO-level notes do not require spec changes before story authoring:

- **NEW-576-V3-001**: S1 story-writer should apply `display_sanitize_filename` to BC-2.7.001
  table cells despite the "Earliest consumer: S2" designation. The spec text mandates this
  via "table cells" in the BC-2.7.011 general clause; no BC text change is required.
- **NEW-576-V3-002**: Unicode bidi controls (U+202E etc.) are not covered by the ASCII-only
  scope and are accepted residuals. A clarifying out-of-scope sentence in BC-2.7.011 would
  improve precision but is not required for implementation correctness.
