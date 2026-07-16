---
report_id: consistency-report-576-r18
round: 18
spec_version: 1.3.48
bc_count: 657
holdout_count: 96
verdict: GAPS-FOUND
gap_count: 4
gap_severity_breakdown: "LOW×2, INFO×2"
prior_round: consistency-report-576-r17.md
date: 2026-07-16
adversary_pass: 8 (post-remediation)
validator: cv-f2-576-r18 (fresh context, no prior round memory)
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 18

**Spec version:** 1.3.48 · **BCs:** 657 · **Holdouts:** 96 · **Verdict:** GAPS-FOUND (4 gaps: LOW×2, INFO×2)

---

## 1. Surface Coverage

All surfaces in the mandated surface set were read independently (fresh context):

| Surface | File | Status |
|---------|------|--------|
| BC-2.7 (Attachment Read) | `.factory/specs/prd/bc-2-issue-read.md` | Read |
| BC-3.9 (Attachment Write) | `.factory/specs/prd/bc-3-issue-write.md` (§3.9) | Read |
| BC-3.9.005 `--replace-existing` path note | `.factory/specs/prd/bc-3-issue-write.md` (EC-3.9.005-3) | Read |
| Holdout scenarios | `.factory/specs/prd/holdout-scenarios.md` | Read |
| BC-INDEX | `.factory/specs/prd/BC-INDEX.md` | Read |
| Impact boundary | `.factory/phase-f1-delta-analysis/impact-boundary-576.md` | Read |
| Spec changelog | `.factory/spec-changelog.md` | Read |
| PRD delta | `.factory/phase-f2-spec-evolution/prd-delta-576.md` | Read |

---

## 2. Mandated Quote Verifications

### P8-001: BC-2.7.011 caller contract reversal

**Claim**: MUST-skip text gone; correction marker present; H-007 sanitize→None fixture
asserts write not skip.

#### BC-2.7.011 caller contract (bc-2-issue-read.md line 869)

> **Caller contract** [P8-001 CORRECTION — prior "MUST skip" + skip-warning text reversed;
> R3.10 fallback writes the file, does not skip]: if `sanitize_attachment_filename` returns
> `None` or an empty string, the caller MUST apply the BC-2.7.010 R3.10 degenerate-name
> fallback: **single-`--id` mode** → write the file named with the raw attachment `id`
> string (bare, no prefix); **batch mode** → write the file named `<sha1-of-id>_<id>`. In
> both cases emit a per-file stderr informational note: `"warning: using id as filename for
> attachment <AID> — original name '<raw>' could not be sanitized."` The overall download
> operation continues for remaining attachments (fail-soft per-file).

**STATUS**: PASS. Correction marker present. "MUST skip" text absent; R3.10 fallback write
instruction in place. No stale "skip" language found.

#### H-007 sanitize→None fixture (holdout-scenarios.md lines 108–109)

> **Extended assertion (P8-001, sanitize→None — R3.10 fallback writes id-as-filename, never
> skips)**: On any batch download (`attachment download <KEY> --all`), a server-supplied
> attachment whose filename sanitizes to `None` (e.g., filename `".."` — stripped entirely by
> BC-2.7.011 step 1) MUST result in a file written inside `OUT_DIR` under the degenerate
> fallback name (`<sha1-of-id>_<id>` in batch mode, per BC-2.7.010 R3.10). Assert: `OUT_DIR`
> contains a file whose name matches `<sha1(id)>_<id>` (40-hex prefix + `_` + numeric id
> string); the attachment is NOT skipped (1 file written, not 0 files); stderr contains
> `"warning: using id as filename for attachment"`.

**STATUS**: PASS. Fixture present in H-007; batch fallback form `<sha1-of-id>_<id>`;
write (not skip) is the asserted behavior; warning substring correct.

---

### P8-002 keystone: BC-3.9.017 step 0 + GENERALIZED invariant + EC-3.9.005-3

#### BC-3.9.017 step 0 (bc-3-issue-write.md line 3707)

> 0. **Eligibility pre-flight (BEFORE any destructive call, BEFORE the gate, BEFORE the list
> GET)**: resolve all eligibility guards that can be determined from the issue key alone.
> Specifically: if `--public` is supplied, `jr` derives the project key from the issue key
> string prefix (e.g., `FOO-1` → `FOO`), calls `get_or_fetch_project_meta(client, config,
> "FOO")` (cached; no extra HTTP on subsequent calls), and checks `projectTypeKey`. If
> `projectTypeKey != "service_desk"` → exit 64; canonical message: `"--public is only
> supported on Jira Service Management (JSM) issues."`; **zero DELETEs issued; zero upload
> POST issued**. This is BC-3.9.005 invoked from the `--replace-existing` path. This step is
> a no-op when `--public` is absent.

**STATUS**: PASS. Step 0 present and numbered 0; fires BEFORE list GET, gate, and DELETEs;
zero DELETEs and zero upload POST guaranteed.

#### GENERALIZED invariant (bc-3-issue-write.md line 3713)

> **Invariant**: no destructive API call (DELETE or upload POST) may be issued while ANY
> confirmation gate OR eligibility guard remains unresolved. This prevents the data-loss
> footgun where a user sees a confirmation prompt — or hits an exit-64 eligibility guard —
> AFTER their existing attachments have already been deleted.

**STATUS**: PASS. "ANY confirmation gate OR eligibility guard" language present; generalized
beyond the pre-P8-002 gate-only formulation.

#### EC-3.9.005-3 (bc-3-issue-write.md line 3366)

> **EC-3.9.005-3** (`--public --replace-existing`, non-JSM, P8-002): pre-flight fires at
> BC-3.9.017 step 0; exit 64; canonical message; **zero DELETEs issued; zero upload POST**.
> The list GET (BC-3.9.017 step 1) is never reached.

**STATUS**: PASS. EC-3.9.005-3 present; step 0 reference correct; list GET confirmed
unreached.

---

### P8-004: BC-3.9.020 single-ID dry-run AID validation bullet

#### BC-3.9.020 single-ID path (bc-3-issue-write.md line 3819)

> - **AID validation (P7-001 uniformity, P8-004)**: the supplied `<AID>` is validated against
> `^[0-9]+$` BEFORE any output, hint, or gate. An invalid AID (non-numeric,
> path-traversal-shaped) → exit 64; stderr: `"invalid attachment id: '<VALUE>' (must be
> numeric)"`; zero HTTP calls issued; the `--dry-run` hint is NOT emitted.

**STATUS**: PASS. Bullet present; fires before hint; P8-004 attribution correct.

---

### P8-005: Both holdouts assert unconditional batch SHA-1 prefixing

#### H-NEW-ATTACHMENT-003 Expected (holdout-scenarios.md line 2165)

> ALL three files in `OUT_DIR` MUST carry SHA-1 prefix forms (40 hex characters + `_` +
> basename). Batch mode SHA-1-prefixes EVERY file unconditionally — including non-colliding
> files. ... An implementation that only SHA-1-prefixes on collision (leaving non-colliding
> files bare) MUST FAIL this assertion.

#### H-NEW-ATTACHMENT-007 Expected (holdout-scenarios.md line 2362)

> ALL files in `OUT_DIR` MUST carry SHA-1 prefix forms (40 hex characters + `_` + sanitized
> basename), since batch mode SHA-1-prefixes EVERY file unconditionally — not only colliding
> files. An implementation that only SHA-1-prefixes on collision MUST FAIL this assertion.

**STATUS**: PASS. Both holdouts assert EVERY-file unconditional prefixing with MUST FAIL
language for collision-only implementations. Wording is consistent across both.

---

## 3. Priority-Area Checks

### (a) Full --replace-existing step sequence (0 → 1 → 2 → 3 → 4)

| Text | Step 0 | Steps 1–4 | Status |
|------|--------|-----------|--------|
| BC-3.9.017 body (lines 3707–3711) | Eligibility pre-flight | List / Gate / Delete / Upload | ✓ |
| EC-3.9.003-5 (line 3317) | N/A | Step 2 = gate ✓; step 4 = upload ✓ | ✓ |
| EC-3.9.005-3 (line 3366) | Step 0 cited explicitly | Step 1 (list) confirmed unreached | ✓ |
| EC-3.9.017-8 (line 3730) | N/A | "gate cancelled in step 2" ✓ | ✓ |
| BC-3.9.018 body (line 3742) | N/A | "BC-3.9.017 step 1" = list ✓ | ✓ |
| BC-3.9.018 gate suppression (line 3748) | N/A | "BC-3.9.017 step 2" = gate ✓ | ✓ |
| EC-3.9.018-4 (line 3753) | N/A | "gate resolves at BC-3.9.017 step 2" ✓ | ✓ |

No stale step references found in primary spec files. Impact boundary R3.8b retro
annotation uses steps 1–4 without step 0 — that annotation predates P8-002 (annotated
2026-07-15) and is numerically consistent (its steps 1–4 still map to BC-3.9.017 steps
1–4). This is an omission in a historical design document (see GAP-R18-004), not a
numerical conflict.

### (b) Invariant phrasing consistency

**GAP-R18-001 found.** BC-3.9.018 line 3748 quotes the pre-P8-002 invariant wording:

> "no destructive API call may be issued while any applicable confirmation gate remains
> pending"

Canonical BC-3.9.017 invariant (line 3713):

> "no destructive API call (DELETE or upload POST) may be issued while ANY confirmation gate
> **OR eligibility guard** remains unresolved"

The "OR eligibility guard" generalization from P8-002 was not propagated into BC-3.9.018's
inline cite. All other invariant references (BC-3.9.017 body, EC-3.9.003-5, EC-3.9.018-4)
use the canonical form.

### (c) None-fallback story end-to-end

| Link | Content | Status |
|------|---------|--------|
| BC-2.7.010 R3.10 (bc-2 line 830) | Degenerate fallback: single-id = bare `<id>`; batch = `<sha1>_<id>`; warning string defined | ✓ |
| BC-2.7.011 caller contract P8-001 (bc-2 line 869) | Applies R3.10 fallback; same warning string | ✓ |
| H-007 P8-001 (holdout line 108) | Batch `<sha1(id)>_<id>`; checks `"warning: using id as filename for attachment"` substring | ✓ |
| Warning string consistency | BC-2.7.010/011 give full string; H-007 checks leading substring — intentional and not contradictory | ✓ |

The None-fallback story is coherent end-to-end.

### (d) [1.3.48] version marker presence

| Document | Marker | Status |
|----------|--------|--------|
| bc-3-issue-write.md frontmatter trace (line 90) | `v1.3.48 — P8 adversary fix round (2026-07-16...)` | ✓ |
| bc-3-issue-write.md `_Last updated` (line 3839) | `spec v1.3.48` | ✓ |
| spec-changelog.md (line 10) | `## [1.3.48] - 2026-07-16` | ✓ |
| prd-delta-576.md frontmatter | `spec_version_after: 1.3.48` | ✓ |
| bc-2-issue-read.md | `last_updated: 2026-07-16` (no explicit v1.3.48 trace entry) | INFO — see GAP-R18-003 |
| holdout-scenarios.md | `last_updated: 2026-07-10` (stale) | GAP — see GAP-R18-002 |

---

## 4. Gap Registry

### GAP-R18-001 (LOW) — BC-3.9.018 invariant quote is pre-P8-002 wording

**Where**: `bc-3-issue-write.md`, BC-3.9.018 gate-suppression paragraph (line 3748)

**Stale text** (inline quote inside BC-3.9.018):
> "no destructive API call may be issued while any applicable confirmation gate remains
> pending"

**Canonical text** (BC-3.9.017 invariant, line 3713):
> "no destructive API call (DELETE or upload POST) may be issued while ANY confirmation gate
> **OR eligibility guard** remains unresolved"

**Impact**: LOW. BC-3.9.017 carries the authoritative invariant; BC-3.9.018 quotes it
parenthetically as supporting rationale. An implementer reading only BC-3.9.018 could miss
that eligibility guards (not just confirmation gates) also block destructive calls. No BC
count change required.

**Fix**: Update BC-3.9.018's inline quote to match the canonical BC-3.9.017 invariant text.

---

### GAP-R18-002 (LOW) — holdout-scenarios.md `last_updated` stale

**Where**: `holdout-scenarios.md` frontmatter line 8

**Current**: `last_updated: 2026-07-10`

**Expected**: `2026-07-16` — spec-changelog [1.3.48] explicitly lists `holdout-scenarios.md`
as MODIFIED in this pass (P8-001 H-007 extension + P8-005 H-NEW-ATTACHMENT-003/007
unconditional SHA-1 assertion updates). The P8 changes are present in the file body; only
the frontmatter timestamp was not bumped.

**Fix**: Bump `last_updated: 2026-07-10` → `2026-07-16`.

---

### GAP-R18-003 (INFO) — bc-2-issue-read.md has no v1.3.48 trace entry in frontmatter

**Where**: `bc-2-issue-read.md` frontmatter `trace` block

**Observation**: bc-2 was modified in v1.3.48 (P8-001 BC-2.7.011 caller contract reversal)
per spec-changelog. The file has `last_updated: 2026-07-16` but no v1.3.48 line in its
`trace` block. bc-3 uses numbered `v1.3.x` trace entries; bc-2 does not (no prior numbered
version entries in bc-2 trace). The inconsistency is between the two files' conventions,
not between bc-2 and the spec-changelog.

**Impact**: INFO. bc-2's convention may be intentional. Not a behavioral gap.

---

### GAP-R18-004 (INFO) — Impact boundary R3.8b retro annotation omits step 0

**Where**: `impact-boundary-576.md`, R3.8b retro annotation (lines 726–732)

**Observation**: The retro annotation documents the "settled form" as steps 1→2→3→4 (list →
gate → delete → upload). Step 0 (eligibility pre-flight, P8-002) is absent. The step
numbers 1–4 in the annotation correctly map to BC-3.9.017 steps 1–4 today — no numerical
conflict. The annotation is dated 2026-07-15; P8-002 post-dates it.

**Impact**: INFO. BC-3.9.017 is the normative source and is correct. No behavioral spec gap.

---

## 5. Closure Table

| Verification | Claim | Quote source | Status |
|---|---|---|---|
| P8-001 BC-2.7.011 | Correction marker present; MUST-skip gone | bc-2 line 869: `[P8-001 CORRECTION — prior "MUST skip" + skip-warning text reversed; R3.10 fallback writes the file, does not skip]` | CLOSED |
| P8-001 H-007 | sanitize→None fixture: write `<sha1>_<id>`, not skip | holdout line 108: `"R3.10 fallback writes id-as-filename, never skips"` | CLOSED |
| P8-002 step 0 | Eligibility pre-flight before list GET/gate/DELETEs | bc-3 line 3707: `"0. Eligibility pre-flight (BEFORE any destructive call, BEFORE the gate, BEFORE the list GET)"` | CLOSED |
| P8-002 invariant | "ANY confirmation gate OR eligibility guard" | bc-3 line 3713: exact text confirmed | CLOSED |
| P8-002 EC-3.9.005-3 | Pre-flight at step 0; zero DELETEs; list GET unreached | bc-3 line 3366: exact text confirmed | CLOSED |
| P8-004 | Single-ID dry-run AID validation before hint | bc-3 line 3819: `"AID validation (P7-001 uniformity, P8-004)... BEFORE any output, hint, or gate"` | CLOSED |
| P8-005 H-NEW-ATTACHMENT-003 | Unconditional SHA-1 + MUST FAIL | holdout line 2165: `"MUST FAIL this assertion"` | CLOSED |
| P8-005 H-NEW-ATTACHMENT-007 | Unconditional SHA-1 + MUST FAIL | holdout line 2362: `"MUST FAIL this assertion"` | CLOSED |
| GAP-R18-001 | BC-3.9.018 invariant quote stale (omits OR eligibility guard) | bc-3 line 3748: old wording confirmed | OPEN (LOW) |
| GAP-R18-002 | holdout-scenarios.md `last_updated` stale | line 8: `2026-07-10` vs expected `2026-07-16` | OPEN (LOW) |
| GAP-R18-003 | bc-2 missing v1.3.48 trace entry | no numbered version entry in bc-2 frontmatter | OPEN (INFO) |
| GAP-R18-004 | Impact boundary R3.8b missing step 0 | retro annotation predates P8-002 | OPEN (INFO) |
