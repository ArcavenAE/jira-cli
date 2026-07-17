---
document_type: security-review
level: ops
version: "2.0"
status: final
producer: security-reviewer
timestamp: 2026-07-17T00:00:00
feature: SOH-ATTACHMENTS-1
issues: "#576, #585"
phase: F2
authored: 2026-07-17
reviewer_role: security
verdict: SPEC-CHANGES-REQUIRED
inputs:
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/cross-cutting.md"
  - ".factory/specs/prd/holdout-scenarios.md"
  - ".factory/specs/prd/error-taxonomy.md"
  - ".factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576.md"
  - ".factory/phase-f2-spec-evolution/security-review-576.md"
  - ".factory/research/issue-576-attachments-api-2026-07-15.md"
baseline_review: "security-review-576.md (APPROVE at v1.3.44)"
spec_version_reviewed: "1.3.79"
total_findings: 11
critical: 0
high: 0
medium: 2
low: 2
info: 2
prior_findings_verified: 7
prior_findings_status: all_resolved
new_findings: 4
severity_summary: >
  Baseline (v1.3.44, all resolved): 1 MEDIUM (CWE-22 canonicalize), 5 LOW (CWE-22 Windows devices,
  CWE-522 redirect test, CWE-93 multipart encoding, CWE-352 XSRF test, stale cache), 1 INFO.
  New (v1.3.44→v1.3.79): 1 MEDIUM (CWE-116 terminal escape injection in confirmation prompts — SPEC-CHANGES-REQUIRED);
  1 LOW (CWE-22 `?redirect=false` prohibition in Trace only, not in BC body — SPEC-CHANGES-REQUIRED);
  1 INFO (CWE-22 degenerate-fallback server-ID trust assumption); 1 INFO (overwrite-refuse pre-flight underspecified).
traces_to: "DEC-184 F2 gate — human-directed upgrade from scoped spot-check to full re-review"
---

# Security Re-Review v2: SOH-ATTACHMENTS-1 Attachment Read/Write (#576 + #585)

**Review scope**: Full spec-level security re-review of the SOH-ATTACHMENTS-1 package at
v1.3.79 (DEC-184). Baseline: prior review `security-review-576.md` (APPROVE at v1.3.44).
Focus on the post-v1.3.44 delta: fix rounds P14–P40, all six new delete BCs (BC-3.9.015..020),
and closing micro-rounds. No implementation exists; this is a spec-only review.

Artifacts read in full:
- `bc-2-issue-read.md §2.7` (BC-2.7.001..012, including all P14–P40 amendments)
- `bc-3-issue-write.md §3.9` (BC-3.9.001..020, including all P14–P40 amendments)
- `cross-cutting.md BC-X.8.010`
- `holdout-scenarios.md Group 19` (H-NEW-ATTACHMENT-001..012)
- `error-taxonomy.md §3` (attachment override rows)
- `ADR-0017` (multipart/streaming)
- Footer changelogs in both `bc-2` and `bc-3` files for amendment tracing

---

## Executive Summary

The seven findings from the baseline review (SEC-576-001..007) were correctly applied and are
all **RESOLVED** at v1.3.44 with no regression detected through v1.3.79.

Four new findings are raised from the post-v1.3.44 delta:

- **SEC-576-011** (MEDIUM, CWE-116): Server-supplied attachment filenames are displayed verbatim
  in interactive confirmation prompts (BC-3.9.015, BC-3.9.017) and other human-readable outputs
  without sanitization of terminal control characters. A Jira user who can upload attachments can
  craft a filename containing ANSI escape sequences or a `\r` carriage return that overwrites the
  visible prompt text, potentially misleading the operator into confirming a destructive deletion
  they did not intend. The spec mandates CWE-22 sanitization for disk writes (BC-2.7.011) but has
  no equivalent mandate for display output. **SPEC-CHANGES-REQUIRED.**

- **SEC-576-009** (LOW, CWE-22): The prohibition on appending `?redirect=false` to the
  attachment content URL (JRACLOUD-97046) is captured in BC-2.7.007's Trace field
  ("JRACLOUD-97046 §6 no-redirect-false") but not in any BC body clause. An implementer
  reading only the BC body text would not see this constraint; adding `?redirect=false` would
  change the download semantics and could potentially bypass the CDN redirect flow.
  **SPEC-CHANGES-REQUIRED.**

- **SEC-576-008** (INFO, CWE-22): BC-2.7.010's degenerate-name fallback asserts "the id string
  is always a safe filename (numeric-only, no path components)" and explicitly excludes the
  fallback from BC-2.7.011 sanitization. For single-`--id` mode this is validated (AID is
  `^[0-9]+$`-checked from user input). For batch mode, server-supplied IDs from
  `fields.attachment[]` carry no client-side validation. This is a deliberate trust assumption
  about Jira's API. Raising it as INFO for completeness; recommend an explicit note in the spec.

- **SEC-576-010** (INFO): BC-2.7.007 references "overwrite-refuse" as a named pre-flight check
  alongside EC-2.7.007-6 (parent-exists) and EC-2.7.007-11 (path-is-directory), but provides no
  dedicated EC defining its exit code or error message for the single-id path. BC-2.7.008 defines
  overwrite behavior for batch paths clearly. The single-id path is underspecified.

**Verdict: SPEC-CHANGES-REQUIRED** — two mandatory spec changes to resolve SEC-576-011
(MEDIUM) and SEC-576-009 (LOW) before Stories 2/4 implementation. All other positive defensive
measures are well-specified and no bypass vectors were found in the gate/guard model.

---

## Part 1: Baseline Finding Re-Verification (SEC-576-001..007)

All seven findings from `security-review-576.md` were verified independently against the
current v1.3.79 BC text. Status: **all resolved, no regression**.

### SEC-576-001 — LOW — CWE-22 — Windows device names

**Status**: RESOLVED (unchanged). BC-2.7.011 Windows device-name caller note present verbatim.
Unit test matrix explicitly enumerates `"CON"`, `"NUL"`, `"COM1"`, `"nul.txt"`. SHA-1 prefix
satisfies the batch path; single-id call site MUST apply `_`-prefix escape. PASS.

---

### SEC-576-002 — MEDIUM — CWE-22 — Containment check underspecified

**Status**: RESOLVED (unchanged). BC-2.7.011 two-step containment check procedure:
(1) `out_dir.canonicalize()?`, (2) `resolved_dir.join(&sha1_filename).starts_with(&resolved_dir)`.
Explicit "Do NOT call `canonicalize()` on the joined path" note present. `--out <PATH>` exclusion
correctly stated as "pure does-not-apply exclusion" (trusted operator input; P25-002). PASS.

---

### SEC-576-003 — LOW — CWE-522 — Credential-stripping wiremock

**Status**: RESOLVED (unchanged). BC-2.7.007 EC-2.7.007-3 present: wiremock MUST use DISTINCT
HOST STRINGS (not merely different ports) — the spec explicitly states "Using the same host at
different ports … makes the assertion vacuous: reqwest's cross-host check compares `host_str()`
output which IGNORES port numbers." This level of precision was added post-baseline review and
strengthens the coverage requirement. PASS.

---

### SEC-576-004 — LOW — CWE-93 — Multipart filename encoding

**Status**: RESOLVED (unchanged). BC-3.9.001 "Multipart filename encoding (SQ-6 resolution —
SEC-576-004 CWE-93)" block present. Test requirement with `;`, `"`, `\r\n` present. PASS.

---

### SEC-576-005 — LOW — CWE-352 — X-Atlassian-Token header

**Status**: RESOLVED (unchanged). BC-3.9.001 EC-3.9.001-5 present; BC-3.9.003 Step 1
parallel note present. Both call sites covered. PASS.

---

### SEC-576-006 — LOW — Stale serviceDeskId cache

**Status**: RESOLVED and correctly wired. BC-X.8.010 stale-ID self-healing clause correct.
BC-3.9.003 Step 1 self-heal sentence correctly added (P30-001). Per-status exit mapping
in BC-X.8.010 step 4 explicitly corrects "blanket exit 64 for all second-failure codes is
INCORRECT — 403 is a permission error (exit 1)". See also SEC-576-006 reassessment in
Focus Area 3 below. PASS.

---

### SEC-576-007 — INFO — Trailing dots/spaces on Windows

**Status**: RESOLVED (unchanged). BC-2.7.011 step 5.5 present. PASS.

---

## Part 2: Focus Area Analysis (Post-v1.3.44 Delta)

### Focus Area 1: Delete Surface (BC-3.9.015..020)

**Scope**: All six delete BCs are new since the baseline review. Assessed:
confirmation gates, multi-AID `--yes`, `--older-than` with `parse_age_duration`, `--dry-run`
paths, and AID `^[0-9]+$` validation.

#### AID validation (`^[0-9]+$`) — CWE-88 / CWE-22 dual mapping

BC-3.9.008 correctly documents: "**(CWE-88 here frames URL-path argument injection; the
traversal-shaped payload class also maps to CWE-22 — the `^[0-9]+$` mitigation covers both;
P40-I2)**" The validation fires before ALL HTTP calls on all delete paths:
- BC-3.9.008: before any DELETE request
- BC-3.9.015: before the pre-prompt metadata GET
- BC-3.9.016: before the bulk `--yes` check (multi-AID form)
- BC-3.9.020: before dry-run metadata fan-out and before the no-op hint

Coverage is comprehensive. For batch `--older-than`, AIDs originate from server responses
(no user-supplied AIDs), so the `^[0-9]+$` validation is not applicable there — the
correctness is addressed in SEC-576-008 below.

**Assessment: CWE-88/CWE-22 mitigation for user-supplied AIDs is complete.**

#### Confirmation gate mechanics (BC-3.9.015)

Three-way branch (a) y/yes → proceed, (b) empty/other → cancel exit 0, (c) EOF/IO-error →
exit 130. The distinction between `Ok(0)` (EOF) and `Ok(n)` with `n ≥ 1` (empty-Enter) is
correctly load-bearing. Metadata fetch failures exit before the gate is presented (all failure
paths enumerated: 404 → exit 64, 403 → exit 1, 401 → exit 2, 5xx/network → exit 1 per P16-005).
The gate is NEVER presented when the metadata fetch fails. Output channel invariant: gate prompts
to STDERR only; stdout clean.

**EC-3.9.015 `--yes` path clarification (P36-002)**: Step 3 correctly states that `--yes`
skips the pre-prompt metadata GET entirely (its sole purpose is the prompt filename) — DELETE
proceeds directly per BC-3.9.008. This is correct: the metadata GET is not security-critical
(it's only for UX display). Confirmed correct.

**Assessment: Gate mechanics are sound. No bypass vector found.**

#### Bulk `--yes` requirement (BC-3.9.016)

All bulk paths (multi-AID and `--older-than`) require `--yes`; no interactive prompt is offered.
`--dry-run` explicitly exempts bulk paths from the `--yes` gate (dry-run is read-only). The
clap mutual-exclusion rules (positional `<AID>` conflicts with `--issue`/`--older-than`) are
comprehensive: every invalid combination produces exit 2 from clap.

**`--older-than 0d` footgun**: acknowledged in BC-3.9.019 ("selects ALL attachments"). Not
blocked by the spec — user chose the duration. This is appropriate for a CLI tool with
explicit `--yes` + `--dry-run` safeguards. The spec recommends `--dry-run` preview, which is
the correct guidance.

**Assessment: Bulk gate model is sound.**

#### `parse_age_duration` input-parsing surface (BC-3.9.019)

Accepted suffixes: `m`, `h`, `d`, `w`. BC-3.9.019 explicitly prohibits reusing `src/duration.rs`
arithmetic (which carries 8-hour workday semantics) — `1d = 24 clock-hours` is pinned by a
required unit test (`parse_age_duration("1d") == chrono::Duration::hours(24)`). Malformed input →
exit 64 before any HTTP. The spec doesn't address integer overflow for very large values
(e.g., `9999999999d`) — however, `chrono::Duration` arithmetic uses checked operations and a
malformed-parse → exit 64 path is already specified for "unrecognized or malformed" strings.
An implementer using `chrono`'s API correctly will handle overflow via `Err` → exit 64.

**Assessment: Input-parsing surface is adequately specified.**

#### `--dry-run` paths (BC-3.9.020)

`--dry-run` suppresses BC-3.9.014 confirmation gates but NOT eligibility guards
(BC-3.9.005 non-JSM check, BC-3.9.017 step 0 validity). This distinction is correctly stated
in EC-3.9.020-7 and EC-3.9.020-8. The GATES vs ELIGIBILITY GUARDS separation was added in P23-002
and is now explicit in the spec. No path can reach a destructive call through a suppressed gate
while dry-run is active: no DELETE and no upload POST is issued on any dry-run path.

**`upload --dry-run` without `--replace-existing` → clap exit 2**: prevents silent no-op
confusion. Correct.

**Assessment: `--dry-run` gate/guard model is sound. No bypass vectors found.**

---

### Focus Area 2: `--replace-existing` TOCTOU / Race (BC-3.9.017)

The sequence is: step 0 (eligibility) → step 1 (list) → step 2 (gate) → step 3 (delete ALL) →
step 4 (upload). The spec explicitly states: "no destructive API call (DELETE or upload POST)
may be issued while ANY confirmation gate OR eligibility guard remains unresolved."

#### TOCTOU window assessment

The step 3 (delete ALL) → step 4 (upload) window is non-atomic. A concurrent upload between
these steps can create a new same-filename attachment. The spec documents this as an accepted
limitation and mandates: "MUST NOT add retry logic asserting post-upload uniqueness by filename."

**Race abuse potential**: An attacker with concurrent Jira access could trigger a concurrent
upload during the delete-upload window to cause a duplicate-attachment state. However:
- The attacker must already have Jira upload access (within the same issue)
- The worst outcome is a duplicate attachment — no privilege escalation, no data exfiltration
- The retry prohibition prevents the code from being fooled into an inconsistent loop

**Non-interactive path (EC-3.9.017-9)**: When `--no-input` or stdin is not a TTY, and ≥1
same-filename match exists, and `--yes` is absent → exit 64 before ANY DELETE. Zero DELETEs
and zero upload POSTs issued. This is the correct behavior.

**Partial-failure consequence**: If step 3 (delete) aborts mid-sequence, step 4 does NOT
proceed. The issue is left with fewer same-filename attachments than before — documented
accepted limitation.

**Gate precedence verified**: Step 0 eligibility check fires BEFORE step 1 list GET. If
`--public` on a non-JSM issue, exits 64 before any attachment is read or modified. The
"one gate per invocation, ever" invariant is correctly maintained across all three
BC-3.9.003/BC-3.9.017/BC-3.9.018 entry points.

**Assessment: TOCTOU mitigation posture is adequate. The non-atomic window is correctly
documented and constrained. No amplification path via retry exists.**

---

### Focus Area 3: SEC-576-006 Self-Heal (BC-X.8.010 + BC-3.9.003 step-1 wiring)

#### Self-heal retry amplification

The self-heal issues at most 2 additional HTTP calls (re-resolution: `GET /project/{key}` +
paginated `GET /servicedeskapi/servicedesk`) plus 1 retry of the original step-1 POST. Maximum
amplification factor: 3 extra calls per invocation. The retry is single-attempt: "it does not
loop." A persistent 403/404 on step 1 causes at most 3 extra calls regardless of retry count.

**Assessment: No DoS amplification path exists.**

#### Cache-poisoning concern

The self-heal invalidates the cache entry and re-fetches from the authoritative Jira server.
An attacker who can control the Jira API response could inject a different `serviceDeskId`,
causing uploads to target a different service desk. However:
1. This requires compromising the Jira API layer (server-side attack, outside the client threat model)
2. The worst outcome is a misdirected upload — no privilege escalation, no data exfiltration to the attacker
3. The self-heal REPLACES a bad cache entry with a server-fresh one — it's a self-healing mechanism,
   not a cache-poisoning amplifier

**Per-status exit mapping (BC-X.8.010 step 4)**: "The blanket exit 64 for all second-failure
codes is INCORRECT — 403 is a permission error (exit 1), not a user input error (exit 64)."
This self-correction is present and the correct exit-code mapping (404 → 64, 403 → 1, 401 → 2,
5xx/network → 1) is fully specified in both BC-X.8.010 and BC-3.9.003 Step 1.

**Assessment: Self-heal is correctly specified and not exploitable.**

---

### Focus Area 4: CWE-22 Pipeline Final Form (BC-2.7.011)

The 5.5-step algorithm (file_name, pseudo-name rejection, NUL rejection, char scrub, length cap,
trailing-dot/space strip), two-step containment check, and Windows device-name caller contract
are all unchanged from the baseline-resolved state. The P25-002 correction (containment
step-1 case (c) — `--out <PATH>` exclusion as "pure does-not-apply exclusion") is correctly
stated and justified: `--out` paths are trusted operator input, not server-supplied.

**214-byte cap boundary handling**: `41 + 214 = 255 = NAME_MAX`. Confirmed. UTF-8-safe
truncation (`floor_char_boundary`) is mandated. The H-NEW-ATTACHMENT-007 holdout test
(P27-002) asserts the on-disk basename after the SHA-1 prefix ≤ 214 bytes.

**Degenerate-name fallback and server-supplied IDs**: See SEC-576-008 (INFO) below.

**Assessment: CWE-22 pipeline is well-specified. No regression from baseline.**

---

### Focus Area 5: Download Hardening

#### Cross-host Authorization strip (GHSA-9857-6MW7-FQ2M)

BC-2.7.007 EC-2.7.007-3 is correctly specified: the two wiremock servers MUST use DISTINCT
HOST STRINGS. The spec adds the precise reasoning: "reqwest's cross-host check compares
`host_str()` output which IGNORES port numbers, so a same-host-different-port redirect would
NOT strip `Authorization` headers." This level of precision was added post-baseline and is
correct. ADR-0017 corroborates via GHSA-9857-6MW7-FQ2M.

**Assessment: Credential-stripping regression guard is adequately specified.**

#### `?redirect=false` prohibition

See SEC-576-009 (LOW) below.

#### Redirect handling (302/303)

BC-2.7.002 added `302/303-redirects` parity with BC-2.7.007 in the closing micro-round
(P38-I1). Redirect following uses reqwest's default policy (automatic). ADR-0017 explicitly
confirms this behavior. No explicit `ALLOW_REDIRECTS = false` or custom `RedirectPolicy`
is specified. **Assessment: Adequate.**

#### Write-to-temp + atomic-rename

BC-2.7.007: `tmp_<random>` → atomic rename. EC-2.7.007-4: temp file deleted on error.
EC-2.7.007-5 (Ctrl+C): best-effort cleanup within `tokio::signal::ctrl_c()` select! arm;
NOT via Drop guards (release profile uses `panic = abort`; `std::process::exit()` does
not invoke destructors). H-NEW-ATTACHMENT-002 tests the error-path proxy.

**P19-003 "downgrade" assessment**: The downgrade from guaranteed to best-effort SIGINT
cleanup is justified. Drop-based cleanup would be unreliable on the signal path. The
implementation note is correct. Not holdout-pinned due to signal timing non-determinism.

**Assessment: Temp-file handling and SIGINT cleanup are adequately specified.**

#### Overwrite-refuse + `--force`

The `--force` flag is listed in BC-2.7.007 CLI flags. BC-2.7.008 defines overwrite behavior
for batch paths: "without `--force`, per-file collision is handled fail-soft — the colliding
file is skipped with a per-file stderr warning." See SEC-576-010 (INFO) for the single-id
path underspecification.

---

### Focus Area 6: Gate/Guard Model — Bypass Vectors

**Can `--yes` bypass eligibility guards?** No. BC-3.9.003 EC-3.9.003-7 explicitly states:
"`--public` on a non-JSM issue guard MUST be evaluated before the non-interactive `--no-input`/
TTY gate and before any `--yes` bypass takes effect." A command like
`jr issue attachment upload PLATFORM-1 file.txt --public --yes` on a non-JSM issue exits 64.

**Can `--dry-run` bypass eligibility guards?** No. EC-3.9.020-7 explicitly separates
BC-3.9.014 confirmation gates (dry-run-suppressed) from eligibility guards (never suppressed).
EC-3.9.020-8 enumerates the eligibility guard on non-JSM `--public --dry-run` path: exit 64,
no preview emitted, no HTTP beyond the project-meta fetch.

**EOF (Ctrl+D) path**: exit 130, NOT exit 0, NOT proceeding. The `Ok(0)` EOF vs `Ok(n)`
empty-Enter distinction is load-bearing and correctly specified. H-NEW-ATTACHMENT-009 pins this.

**Can non-interactive mode bypass gates and proceed to destructive calls?** No.
- BC-3.9.015 non-interactive: exit 64 before any DELETE, no prompt.
- BC-3.9.017 non-interactive with ≥1 match: exit 64 before ANY DELETE or upload POST.
- BC-3.9.003 non-interactive: exit 64 before any servicedeskapi call.
All non-interactive-without-`--yes` paths on gated operations exit 64 before destruction.

**Assessment: No bypass vectors found in the gate/guard model. The model is correctly specified.**

---

### Focus Area 7: Output-Channel Taxonomy and Terminal Escape Injection

The hint-vs-error taxonomy for JSON mode is correctly specified across all EC family members.
Hints (collision-skip warnings, count summaries, zero-match messages) are suppressed in JSON
mode; errors (per-file failures) are always emitted. The `filename` semantics are consistently
specified as RAW Jira names in JSON output (pre-sanitization), with `path` carrying the
on-disk name.

**Terminal escape injection in displayed filenames**: See SEC-576-011 (MEDIUM, SPEC-CHANGES-REQUIRED).

**Information disclosure**: `downloaded[].filename` in JSON mode carries the RAW Jira filename
(pre-sanitization). This is correct for machine consumers and does not present a path-injection
risk via JSON (the consumer parses the JSON rather than interpreting it as a shell command).
The risk applies only to DISPLAY rendering in TTY output — see SEC-576-011.

---

### Focus Area 8: Multipart/Streaming (ADR-0017)

#### X-Atlassian-Token CSRF header

BC-3.9.001 EC-3.9.001-5: wiremock test required for platform POST. BC-3.9.003 Step 1: parallel
note requiring X-Atlassian-Token on JSM POST. Both call sites covered. ADR-0017 notes the header
as "load-bearing" and will be set at the call site in `src/api/jira/attachments.rs`.

**Assessment: Adequate.**

#### Retry-rebuild

BC-3.9.001: "MUST rebuild the entire multipart request from the file path on disk… MUST NOT
delegate retry to the generic `JiraClient` retry wrapper." BC-3.9.003 Step 1: same constraint.
ADR-0017 explains why: `RequestBuilder::try_clone()` returns `None` for streamed
`ReaderStream` bodies (non-rewindable). The constraint prevents partial-send corruption.

**Assessment: Adequate.**

#### No client-side size cap (graceful 413)

BC-3.9.001: no cap; 413 → exit 1 with message. ADR-0017: "Buffering the entire body in memory
(`bytes()`) before writing to disk is unsafe at those sizes; streaming is required." This is
the correct design for a CLI tool: the operator chooses the file size, and the server enforces
the instance-specific limit. The `--verbose-bodies` note correctly prohibits buffering the
streaming body for logging.

**Resource-exhaustion posture**: The streaming design bounds memory usage to one chunk at a time.
No server-imposed size cap is hard-coded. Graceful 413 handling prevents crash/panic on size
rejection. **Assessment: Adequate for a CLI tool context.**

---

## Part 3: New Findings

### SEC-576-011 — MEDIUM — CWE-116 — Terminal escape sequences in confirmation prompt filenames not sanitized for DISPLAY

**Severity**: MEDIUM
**CWE**: CWE-116 (Improper Encoding or Escaping of Output)
**OWASP**: A03:2021 Injection (Terminal Injection / UI Redress)
**Affected BCs**: BC-3.9.015, BC-3.9.017, BC-2.7.008, BC-2.7.010
**Status**: **SPEC-CHANGES-REQUIRED**

**Verbatim spec text (BC-3.9.015)**:
> write the prompt to stderr using `eprint!` (NOT `eprintln!`) with a trailing space and no
> newline: `"Delete attachment <filename> (<AID>)? [y/N] "`. Where `<filename>` is retrieved
> via `GET /rest/api/3/attachment/{id}` (one extra GET before the prompt to fetch display metadata).

**Verbatim spec text (BC-3.9.017)**:
> Prompt text (stderr, trailing space, `eprint!`): `"Replace existing attachment(s) on <KEY>:\n
>   <filename1> (id: <AID1>)\n  <filename2> (id: <AID2>)\nContinue? [y/N] "` (list all matching
> entries; no `"N items"` summary — exact count is meaningful for destructive ops).

The `<filename>` value in both cases comes directly from the Jira API response (`attachment.filename`),
which is set by whoever uploaded the attachment to Jira. Any Jira user with attachment upload
permission can set this value. The spec mandates BC-2.7.011 sanitization only for DISK WRITES —
there is no equivalent requirement for DISPLAY output.

**Attack scenario**: An attacker uploads an attachment to a Jira issue with a crafted filename
such as `\rConfirm installation of trusted software? [y/N] `. When an operator runs
`jr issue attachment delete <AID>`, the prompt renders as follows on most terminals:

```
Delete attachment                                (cursor is at column 0)
Confirm installation of trusted software? [y/N]  ← what operator sees
```

The `\r` returns the cursor to the start of the line, and the crafted text overwrites the
"Delete attachment" prefix. The operator types `y`, which is received by the real `y/N`
handler and proceeds to DELETE the attachment. The operator believed they were confirming
something else.

**Less severe but present**: ANSI color codes in filenames (e.g., `\x1b[31mevil\x1b[0m`)
can alter terminal rendering. `\x1b[2J` clears the terminal. These are lower-impact than
the `\r`-overwrite but still present. The `--no-color` global flag only suppresses `jr`'s
own ANSI output — it does not strip attacker-injected escape sequences in filename display.

**Affected display contexts (all requiring display sanitization)**:
1. BC-3.9.015 confirmation prompt: `"Delete attachment <filename> (<AID>)? [y/N] "`
2. BC-3.9.017 `--replace-existing` prompt: filename list in the prompt text
3. BC-2.7.008 collision-skip warning: `"Skipping <filename>: file already exists. Use --force to overwrite."`
4. BC-2.7.010 degenerate-name warning: `"...original name '<raw>' could not be sanitized."`
5. BC-2.7.001 attachment list table (table rendering may handle this but should be explicit)

**Scope note**: This concern exists whenever a server-supplied filename is echoed to a TTY.
It does NOT affect JSON output (machine consumers parse, not interpret), the disk-write path
(BC-2.7.011 governs), or non-TTY stderr pipes.

**Mitigating factors**:
- Requires the attacker to already have Jira attachment-upload permission on the target issue
- Jira performs some server-side validation on filenames (exact scope unclear from API docs)
- Most interactive `jr` operations require the operator to initiate the command — this is
  not a "background" attack vector

**SPEC-CHANGES-REQUIRED**: Add a new BC-2.7.011 note or a new subsection governing display
sanitization, AND reference it from all affected display contexts. Suggested wording:

> **Display sanitization for terminal output (SEC-576-011 — CWE-116)**: When any
> server-supplied attachment `filename` value is written to a TTY (confirmation prompts,
> warnings, table cells, any human-readable stderr/stdout) — distinct from the disk-write
> path governed by `sanitize_attachment_filename` — ALL ASCII control characters in the
> byte range 0x00–0x1F and 0x7F MUST be replaced with a visual placeholder (e.g., `?` or
> Unicode replacement character U+FFFD) before writing. This prevents terminal injection
> via `\r` (cursor-to-start overwrite of the prompt text), ANSI escape sequences, and other
> control characters in server-supplied filenames. The sanitization is display-only: the
> RAW value is still used for disk writes (BC-2.7.011 pipeline), JSON output
> (`downloaded[].filename`, `attachment_list` array), and the Jira API.

Cross-reference this requirement from BC-3.9.015, BC-3.9.017, BC-2.7.008, and BC-2.7.010.

---

### SEC-576-009 — LOW — CWE-22 — `?redirect=false` prohibition is in Trace field only, not in BC body

**Severity**: LOW
**CWE**: CWE-22 (Path Traversal — informational; changes content semantics, not path)
**OWASP**: A05:2021 Security Misconfiguration
**Affected BC**: BC-2.7.007
**Status**: **SPEC-CHANGES-REQUIRED**

**Verbatim Trace field (BC-2.7.007)**:
> JRACLOUD-97046 §6 no-redirect-false

The Trace field cites JRACLOUD-97046 with a "no-redirect-false" annotation, indicating the
research file documents this constraint. However, the BC-2.7.007 body text does not include
any clause explicitly prohibiting `?redirect=false` on the content URL.

**Risk**: An implementer reading only the BC body text (the primary implementation reference)
would not see this constraint. Adding `?redirect=false` to the content URL:
1. Changes the redirect behavior: instead of following the redirect to the CDN, Jira may
   return the media content directly or a different response shape
2. Defeats the credential-stripping test (EC-2.7.007-3) if the redirect is bypassed entirely,
   because the two-server wiremock test only asserts on the cross-host redirect path

**Exploitation path**: Low — an implementer would have to deliberately add `?redirect=false`
(not a natural implementation mistake). However, spec completeness requires the constraint
appear in the BC body where implementers look.

**SPEC-CHANGES-REQUIRED**: Add to BC-2.7.007 step 2 (or as a new EC):

> **`?redirect=false` is prohibited (JRACLOUD-97046)**: The content URL MUST be
> `GET /rest/api/3/attachment/content/{id}` with no additional query parameters.
> The `?redirect=false` parameter (JRACLOUD-97046) MUST NOT be appended — it changes
> the redirect behavior and would bypass the CDN redirect that EC-2.7.007-3's
> credential-stripping test validates. The download implementation MUST follow
> Jira's redirect to the pre-signed media URL using reqwest's default redirect policy.

---

### SEC-576-008 — INFO — CWE-22 — Degenerate-name fallback relies on implicit "always numeric" invariant for server-supplied IDs

**Severity**: INFO
**CWE**: CWE-22 (Path Traversal — informational; requires rogue server)
**Affected BCs**: BC-2.7.010, BC-2.7.011
**Status**: **resolved as deliberate design decision; recommend clarifying note**

**Verbatim spec text (BC-2.7.010)**:
> In both cases the id string is always a safe filename (numeric-only, no path components).
> The fallback is NOT subject to BC-2.7.011 (the id needs no sanitization).

For **single-`--id` mode**: the AID is user-supplied and validated as `^[0-9]+$` before any
HTTP call. The "always numeric" invariant holds by construction.

For **batch mode (`--all`/`--newest N`)**: the IDs come from `fields.attachment[]` in the
server API response. No `^[0-9]+$` validation is applied to server-supplied IDs. The spec's
assertion that these are "always a safe filename (numeric-only)" is an implicit trust
assumption about Jira's API — legitimate Jira always returns numeric attachment IDs, but
a rogue/compromised server is not bound by this.

**BC-2.7.011 exclusion**: The spec explicitly states the degenerate fallback is "NOT subject
to BC-2.7.011" and that the defense-in-depth containment check is not applied to the fallback
naming path. This is a deliberate design decision.

**Recommendation**: Add a note in BC-2.7.010 or BC-2.7.011 clarifying:

> **Trust assumption (SEC-576-008)**: The assertion that server-supplied attachment IDs are
> "always numeric" is an invariant of the legitimate Jira Cloud API. A compromised or rogue
> Jira instance could return non-numeric IDs, bypassing the degenerate-fallback safety
> assumption. This is considered outside the normal threat model (an attacker who controls
> the Jira server has broader access than this guard prevents). For defense-in-depth,
> implementers MAY apply `^[0-9]+$` validation to server-supplied IDs before using them
> in the degenerate fallback.

This is INFO; no change required for implementation correctness against the stated threat model.

---

### SEC-576-010 — INFO — Single-ID overwrite-refuse pre-flight lacks dedicated EC in BC-2.7.007

**Severity**: INFO
**Affected BC**: BC-2.7.007
**Status**: **clarification recommended**

**Verbatim spec text (BC-2.7.007 P32-001 note)**:
> local pre-flight checks (EC-2.7.007-6 parent-exists, EC-2.7.007-11 path-is-directory,
> overwrite-refuse) fire BEFORE step-1 metadata GET — fail cheap/offline first
> (AID-regex-before-HTTP precedent); double-fault → local check's message wins.

The other two pre-flights have dedicated ECs:
- EC-2.7.007-6: `"Output directory does not exist: <parent>"` → exit 64
- EC-2.7.007-11: `"output path is a directory: <PATH>"` → exit 64

The "overwrite-refuse" pre-flight is named in the P32-001 note but has no dedicated EC defining
its exit code, error message, or whether `--force` applies on the single-id path. BC-2.7.008
defines overwrite behavior clearly for batch paths: "without `--force`, per-file collision is
handled fail-soft — the colliding file is skipped with a per-file stderr warning...
With `--force`, existing files are overwritten silently." The `--force` flag is listed in
BC-2.7.007's CLI flags section.

**Recommendation**: Add an EC (e.g., EC-2.7.007-12) to BC-2.7.007 defining:
1. Exit code (suggest exit 64, consistent with the parent-exists and is-directory checks)
2. Error message (e.g., `"File already exists: <path>. Use --force to overwrite."`)
3. Scope: applies when `--out <PATH>` targets an existing regular file without `--force`
4. `--force` semantics: silently overwrites (mirrors BC-2.7.008 batch path)

This is an INFO-level completeness gap, not a security vulnerability.

---

## Part 4: Positive Findings — Defensive Measures Verified

All positive findings from the baseline review remain intact. Additional measures introduced
in the post-v1.3.44 delta are also verified:

- **AID `^[0-9]+$` validation scope**: fires before ALL HTTP calls, ALL gates, ALL bulk checks
  on every delete path. Comprehensive coverage across BC-3.9.008/013/015/016/020. PASS.
- **Delete gate invariant**: "no destructive API call may be issued while any confirmation
  gate OR eligibility guard remains unresolved" — explicitly stated in BC-3.9.017 and
  verified against all entry points. PASS.
- **Non-atomic window documentation**: JRACLOUD-96384/-78388 cited; no retry logic asserted;
  partial-failure consequences documented. PASS.
- **`parse_age_duration` semantic isolation**: no reuse of worklog-day (8h) semantics from
  `src/duration.rs`; `1d = 24h` unit test required. PASS.
- **Per-status exit code accuracy**: BC-X.8.010 step 4 correctly differentiates 404 → 64
  vs 403 → 1. The self-correction note ("blanket exit 64 is INCORRECT") is present.  PASS.
- **Gate consumer suppression in `--replace-existing` context**: "One gate per invocation,
  ever" invariant maintained across all three BC-3.9.003/BC-3.9.017/BC-3.9.018 entry points.
  BC-3.9.003 EC-3.9.003-5 and EC-3.9.003-7 correctly interlock. PASS.
- **`--dry-run` gate/guard distinction**: gates suppressed, eligibility guards not. EC-3.9.020-7
  and EC-3.9.020-8 correctly specify this. PASS.
- **EOF → exit 130 (not exit 0)**: correctly specified in BC-3.9.003/014/015 and pinned by
  H-NEW-ATTACHMENT-009. PASS.
- **Hint-vs-error taxonomy for JSON mode**: correctly specified across all EC family members
  in BC-2.7.007/008/009. PASS.
- **`--verbose-bodies` prohibition on streaming bodies**: correctly specified in BC-3.9.001
  and BC-2.7.007 — logging placeholder only, never file contents. PASS.
- **Per-profile cache isolation**: all cache access is keyed by `(profile, key)`. PASS.
- **JSM safe-default (BC-3.9.002)**: platform POST = internal by default on JSM; no
  accidental customer-visible upload. PASS.
- **`--public` non-JSM guard fires before `--yes` and before non-interactive gate**:
  EC-3.9.003-7 explicitly states this ordering. PASS.
- **Degenerate-name warning in JSON mode suppressed**: correctly classified as NON-ERROR
  hint per EC-2.7.007-7 and BC-2.7.010. PASS.

---

## Summary Table

### Prior Findings (v1.3.44 baseline — all verified resolved)

| ID | Severity | CWE | Affected BC | Status |
|----|----------|-----|-------------|--------|
| SEC-576-001 | LOW | CWE-22 | BC-2.7.011 | resolved |
| SEC-576-002 | MEDIUM | CWE-22 | BC-2.7.011 | resolved |
| SEC-576-003 | LOW | CWE-522 | BC-2.7.007 | resolved (strengthened: distinct-host wiremock) |
| SEC-576-004 | LOW | CWE-93 | BC-3.9.001 | resolved |
| SEC-576-005 | LOW | CWE-352 | BC-3.9.001, BC-3.9.003 | resolved |
| SEC-576-006 | LOW | (correctness) | BC-X.8.010, BC-3.9.003 | resolved (correctly wired P30-001) |
| SEC-576-007 | INFO | CWE-22 | BC-2.7.011 | resolved |

### New Findings (post-v1.3.44 delta, v1.3.79)

| ID | Severity | CWE | Affected BC | Status |
|----|----------|-----|-------------|--------|
| SEC-576-011 | **MEDIUM** | CWE-116 | BC-3.9.015, BC-3.9.017, BC-2.7.008, BC-2.7.010 | **SPEC-CHANGES-REQUIRED** |
| SEC-576-009 | **LOW** | CWE-22 | BC-2.7.007 | **SPEC-CHANGES-REQUIRED** |
| SEC-576-008 | INFO | CWE-22 | BC-2.7.010, BC-2.7.011 | deliberate design; recommend note |
| SEC-576-010 | INFO | — | BC-2.7.007 | clarification recommended |

---

## Recommendations Priority

### Before Story 2 (attachment download) implementation

**SEC-576-009** (LOW): Add explicit `?redirect=false` prohibition clause to BC-2.7.007 step 2.
This is a quick one-line addition that prevents an implementer from inadvertently undermining
the credential-stripping test. Required before Story 2 implementation begins.

**SEC-576-010** (INFO): Add EC-2.7.007-12 for overwrite-refuse (exit code, message, `--force`
semantics) to BC-2.7.007. Recommended before Story 2.

### Before Story 4 (attachment delete) implementation

**SEC-576-011** (MEDIUM): Add display-sanitization requirement for terminal output
(strip 0x00–0x1F, 0x7F before writing to TTY). This must be in the spec before Story 4
because the confirmation prompt is the primary attack surface. The sanitization requirement
must be cross-referenced from BC-3.9.015 and BC-3.9.017.

### Post-release (informational)

**SEC-576-008** (INFO): Add a clarifying note in BC-2.7.010 or BC-2.7.011 acknowledging
the "always numeric" invariant as a trust assumption about the Jira API rather than a
client-side-validated invariant.

---

## Verdict: SPEC-CHANGES-REQUIRED

Two mandatory spec changes are required before implementation:

1. **SEC-576-011 (MEDIUM)**: Display sanitization requirement for server-supplied filenames
   in TTY output — add to BC-2.7.011 (or new subsection) and cross-reference from BC-3.9.015,
   BC-3.9.017, BC-2.7.008, and BC-2.7.010. Required before Story 4 implementation.

2. **SEC-576-009 (LOW)**: `?redirect=false` prohibition must appear in BC-2.7.007 body text
   (not only in the Trace field). Required before Story 2 implementation.

All seven baseline findings (SEC-576-001..007) are confirmed resolved with no regression.
The gate/guard model is sound with no bypass vectors. The self-heal (SEC-576-006 wiring),
AID validation, TOCTOU documentation, and multipart/streaming posture are all correctly
specified. Story decomposition MAY proceed on Stories 1, 3, 5 (no blocking findings for
those stories). Story 2 is blocked on SEC-576-009 + SEC-576-010 (recommended). Story 4
is blocked on SEC-576-011 (mandatory).
