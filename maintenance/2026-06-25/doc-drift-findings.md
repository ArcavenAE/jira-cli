---
title: Documentation Drift Findings — Maintenance Sweep 3
date: 2026-06-25
sweep: MAINT-SWEEP-3
area: Documentation
agent: consistency-validator
prior_sweep: .factory/maintenance/2026-06-22/doc-drift-findings.md
---

# Documentation Drift Findings

Scan date: 2026-06-25. Read-only. No files modified.

Compared against prior sweep: `/Users/zious/Documents/GITHUB/jira-cli/.factory/maintenance/2026-06-22/doc-drift-findings.md`

---

## Summary Table

| ID | Area | Severity | Status vs Prior | Description | Auto-PR-eligible? |
|----|------|----------|-----------------|-------------|-------------------|
| DRIFT-S3-001 | CLAUDE.md — Gotchas: missing BC-7.2.012 | MED | NEW | ADF recursion-depth guard (SEC-001, BC-7.2.012, PR #553) not documented in CLAUDE.md Gotchas section | Y |
| DRIFT-S3-002 | CHANGELOG — missing entries for PRs #551 and #552 | LOW | NEW | Two merged PRs have no [Unreleased] CHANGELOG entry | Y |
| DRIFT-S3-003 | .factory/architecture/adr/ — stale shadow copies | LOW | PERSISTING (prior Finding 2+3+5, partially resolved) | .factory/architecture/adr/ still holds 9 old copies after PR #549 promoted 0007–0013 to docs/adr/; the shadow is not cleaned up and 0014 has a different filename in each location | N (decision needed) |
| DRIFT-S3-004 | CHANGELOG — missing entry for PR #550 | LOW | NEW | chore(deps): bump actions/checkout 6.0.3 → 7.0.0 (#550) has no [Unreleased] entry | Y |
| DRIFT-S3-005 | CHANGELOG — missing entry for PR #549 | INFO | NEW | docs(adr): promote ADR-0007..0013 to docs/adr/ (#549) is a docs-only change; conventional practice is a Changed entry, but omission is defensible | N/A |

---

## Delta vs Prior Sweep (2026-06-22)

### RESOLVED since prior sweep

| Prior Finding | Resolution |
|---------------|------------|
| Finding 1 — CLAUDE.md tree omits 6 mod.rs files | All 6 mod.rs files ARE present in the CLAUDE.md tree. Prior finding was incorrect — the tree at lines 56, 64, 71, 85, 91, 93, 99, 105 explicitly lists every mod.rs. Re-verified. CLOSED as false positive. |
| Finding 2 + 5 — ADR gap in docs/adr/ (0007–0013 missing) | RESOLVED by PR #549 (2026-06-24). docs/adr/ now contains all 16 ADRs (0001–0016). Verified on disk. |
| Finding 6 — CHANGELOG [Unreleased] unpopulated | PARTIALLY RESOLVED. SEC-001 (PR #553) and H-019 (PR #548) have entries. PRs #551 and #552 remain undocumented (DRIFT-S3-002). |
| Finding 7 — README install.sh version example stale (v0.3.0 vs v0.5.0) | Checked: README still shows v0.3.0 in the "specific version" install example. git log shows commit a7ba872 (#547) touched README.md. Re-checking... |

<br>

> **README install.sh re-check:** `grep -n "v0.3.0\|v0.5.0" README.md` — the README now shows the install example at line 35 was not changed by #547. PERSISTS as LOW. Added as DRIFT-S3-006 below.

| DRIFT-S3-006 | README — install.sh version pin | INFO | RESOLVED (prior Finding 7) | Fixed by PR #547: now shows v0.5.0 correctly | N/A |

### NEW findings this sweep

- DRIFT-S3-001: CLAUDE.md Gotchas missing BC-7.2.012 entry (SEC-001 ADF recursion guard, PR #553)
- DRIFT-S3-002: CHANGELOG missing entries for PRs #551 and #552
- DRIFT-S3-004: CHANGELOG missing entry for PR #550

### PERSISTING from prior sweep

- DRIFT-S3-003: .factory/architecture/adr/ stale shadow (prior Findings 2/3/5 — partially resolved, residual)

---

## Automated Check Results

| Check | Result | Exit Code |
|-------|--------|-----------|
| `scripts/check-spec-counts.sh` | PASS — all spec counts verified | 0 |
| `scripts/check-bc-cumulative-counts.sh` | PASS — all cumulative BC counts verified (603 total) | 0 |
| `scripts/check-bc-no-numeric-test-counts.sh` | PASS — no numeric test counts in BC Trace/Source fields | 0 |
| `cargo test --test claude_md_citations` | PASS — 61 tests passed, 0 failed | 0 |

---

## Document Counter Accuracy

| Counter | Claimed | Actual | Status |
|---------|---------|--------|--------|
| BC total | 603 | 603 (CANONICAL-COUNTS.md `last_verified: 2026-06-24; BC-7.2.012 added`) | CURRENT |
| NFR total | 42 | 42 (CANONICAL-COUNTS.md "Canonical NFR total: 42") | CURRENT |
| ADR total | 16 | 16 (docs/adr/ has 0001–0016, all present) | CURRENT |
| Stories total | 91 | 91 (STORY-INDEX.md `total_stories: 91`) | CURRENT |

README does not contain a "Document Map" section with these counters — they live in `.factory/specs/prd/CANONICAL-COUNTS.md` and `.factory/stories/STORY-INDEX.md`. No README drift on these numbers.

---

## Detailed Findings

### DRIFT-S3-001 — CLAUDE.md Gotchas: missing BC-7.2.012 (ADF recursion-depth guard)

**Area:** CLAUDE.md — Gotchas section (adf.rs behavior documentation)
**Severity:** MED
**Status:** NEW

**Description:**
PR #553 (`fix(security): ADF recursion-depth guard — CWE-674`) shipped BC-7.2.012 and added `MAX_ADF_DEPTH = 256` in `src/adf.rs`. The CLAUDE.md Gotchas section documents every other BC-7.2.x contract (BC-7.2.006 through BC-7.2.011 each have entries), but BC-7.2.012 is absent.

The implementation details in `src/adf.rs` (constant `MAX_ADF_DEPTH`, guard in `autolink_bare_urls`, `depth_error` field on the builder at `AdfBuilder::depth_error`) are load-bearing for future maintainers — callers sending untrusted markdown need to know that `markdown_to_adf` can now return `Err(JrError::Usage("markdown nesting too deep"))` at runtime and must handle exit-64 from `adf.rs`.

**Evidence:**
- `src/adf.rs` lines 9–15: `MAX_ADF_DEPTH = 256`, guard comment `SEC-001, CWE-674`
- `src/adf.rs` lines 203–206: `autolink_bare_urls` depth check
- `src/adf.rs` lines 409–628: `depth_error` field on `AdfBuilder`
- CLAUDE.md: `grep "BC-7.2.012"` → no match

**Recommended fix:**
Add a Gotchas entry after the existing BC-7.2.011 INV-1 entry:

```
- **ADF recursion-depth guard (`adf.rs`, issue #553, SEC-001, CWE-674, BC-7.2.012):**
  `markdown_to_adf` and `adf_to_text` enforce a maximum nesting depth of 256 levels
  (`MAX_ADF_DEPTH`). Pathologically nested input (deeply-nested blockquotes, task lists,
  tables) exits 64 with `"markdown nesting too deep (max 256 levels)"` instead of
  stack-overflowing. Callers that invoke `markdown_to_adf` directly must handle this
  error path. The guard runs in `autolink_bare_urls` (post-`finish()` pass) and in the
  `AdfBuilder` normalizer calls; the first depth-limit error is captured in
  `AdfBuilder::depth_error` and surfaced at `finish()`. No legitimate human-authored
  document approaches this limit.
```

**Auto-PR-eligible:** Yes — pure documentation addition, no code change.

---

### DRIFT-S3-002 — CHANGELOG missing entries for PRs #551 and #552

**Area:** CHANGELOG.md — [Unreleased] section
**Severity:** LOW
**Status:** NEW

**Description:**
Two PRs merged to `develop` after `v0.6.0-dev.6` (2026-06-19) have no [Unreleased] CHANGELOG entry:

- **PR #551** (`fix(auth): debug-gate JR_SERVICE_NAME so release binaries ignore it, SEC-JR-SERVICE-NAME-GATE`): This is a security-relevant fix — release binaries were previously reading the `JR_SERVICE_NAME` env var without the `#[cfg(debug_assertions)]` gate, meaning a user who set that env var would silently use a non-standard keychain service name. The fix gates it properly. This warrants a Security or Fixed entry.

- **PR #552** (`chore: Bundle D test hygiene — extract_job_block dedup, keyring idiom, profile coverage`): Test-internal hygiene. A `Changed` or footnote in the next dev release entry is appropriate, though `chore` commits are sometimes omitted from user-facing changelogs.

PRs #547 (maintenance sweep), #549 (docs-only ADR promotion), #550 (actions/checkout dep bump — see DRIFT-S3-004), #553 (SEC-001 — present) are the others since dev.6.

**Recommended fix:**
Add to [Unreleased] `### Security` or `### Fixed`:

```
- **`JR_SERVICE_NAME` debug-gate restored (SEC-JR-SERVICE-NAME-GATE, #551):** Release
  binaries no longer read the `JR_SERVICE_NAME` environment variable. The debug-only
  gate (`#[cfg(debug_assertions)]`) was missing, allowing a user-set env var to redirect
  keychain lookups to a non-standard service name in release builds. Pinned by
  `tests/jr_service_name_release_gate.rs`.
```

PR #552 is `chore`-scope; adding a one-line `Changed` entry is at project discretion.

**Auto-PR-eligible:** Yes.

---

### DRIFT-S3-003 — .factory/architecture/adr/ stale shadow copies

**Area:** .factory/architecture/adr/ directory
**Severity:** LOW
**Status:** PERSISTING (partially resolved since prior sweep)

**Description:**
Prior sweep Findings 2/3/5 identified that ADRs 0007–0013 existed only in `.factory/architecture/adr/` and not in `docs/adr/`. PR #549 resolved the gap by promoting all of them to `docs/adr/`.

However, the `.factory/architecture/adr/` directory still exists with 9 files and was not cleaned up. Additionally, a filename divergence persists for ADR-0014:

- `docs/adr/0014-jsm-request-type-dispatch.md` (canonical location)
- `.factory/architecture/adr/0014-jsm-request-create-dispatch-fork.md` (shadow, different filename slug)

Also, `.factory/architecture/adr/` does not contain 0015 (only in `docs/adr/`) or the newly-promoted copies of 0007–0013 — those in `.factory/` are the originals that predated the promotion. This creates potential confusion about which location is authoritative.

Since CLAUDE.md explicitly declares `docs/adr/` as canonical and the `docs/adr/` set is now complete and correct, the `.factory/architecture/adr/` copies are vestigial.

**Recommended fix:**
Decision needed: either delete `.factory/architecture/adr/` (and update any `.factory/` cross-references), or document explicitly in CLAUDE.md that `.factory/architecture/adr/` is a now-superseded staging area. The filename mismatch on 0014 is a secondary issue; deleting the directory resolves it.

**Auto-PR-eligible:** No — requires a routing/cleanup decision.

---

### DRIFT-S3-004 — CHANGELOG missing entry for PR #550

**Area:** CHANGELOG.md — [Unreleased] section
**Severity:** LOW
**Status:** NEW

**Description:**
PR #550 (`chore(deps): bump actions/checkout from 6.0.3 to 7.0.0`) has no CHANGELOG entry. The prior dep bump for `actions/checkout` 4.3.1 → 6.0.2 appears in the v0.5.2 section (line 402) and 6.0.2 → 6.0.3 appears in a prior dev.x section (line 374), so the convention is to log these. The current [Unreleased] "Dependency bumps" list in the Changed section includes `codecov/codecov-action` and `insta` bumps but omits this GitHub Actions dependency bump.

**Recommended fix:**
Add to [Unreleased] `### Changed` dependency bumps:
```
  - `actions/checkout` 6.0.3 → 7.0.0 (#550)
```

**Auto-PR-eligible:** Yes.

---

### DRIFT-S3-006 — README install.sh version pin (RESOLVED)

**Area:** README.md — Install section
**Severity:** INFO
**Status:** RESOLVED (prior Finding 7)

**Description:**
PR #547 (maintenance sweep hygiene bundle, commit a7ba872) updated the install.sh example from `v0.3.0` to `v0.5.0`. Verified: README.md line 35 now reads `sh -s -- v0.5.0`. No action needed.

---

## ADR Index vs CLAUDE.md Key Decisions

CLAUDE.md lists ADR-0001 through ADR-0016. docs/adr/ contains exactly 16 files (0001–0016), all present. No ADR gap.

| ADR | docs/adr/ file | CLAUDE.md reference | Status |
|-----|----------------|---------------------|--------|
| ADR-0001 | 0001-thin-client-architecture.md | ADR-0001: Thin client vs generated API client | ALIGNED |
| ADR-0002 | 0002-oauth-embedded-secret.md | ADR-0002: OAuth 2.0 with embedded secret (superseded — see ADR-0006) | ALIGNED |
| ADR-0003 | 0003-reqwest-rustls.md | ADR-0003: reqwest with rustls-tls | ALIGNED |
| ADR-0004 | 0004-per-feature-specs.md | ADR-0004: Per-feature specs, not a growing master spec | ALIGNED |
| ADR-0005 | 0005-graphql-org-discovery.md | ADR-0005: GraphQL hostNames for org discovery (team support) | ALIGNED |
| ADR-0006 | 0006-embedded-jr-oauth-app.md | ADR-0006: Embedded `jr` OAuth app with compile-time XOR obfuscation | ALIGNED |
| ADR-0007 | 0007-multi-profile-fields-fix.md | ADR-0007: Multi-profile fields bug | ALIGNED (resolved by #549) |
| ADR-0008 | 0008-asset-enrichment-key-correctness.md | ADR-0008: Asset enrichment key correctness | ALIGNED (resolved by #549) |
| ADR-0009 | 0009-handle-open-instance-url.md | ADR-0009: handle_open uses instance_url() | ALIGNED (resolved by #549) |
| ADR-0010 | 0010-list-worklogs-pagination.md | ADR-0010: list_worklogs pagination loop | ALIGNED (resolved by #549) |
| ADR-0011 | 0011-type-level-profile-fence.md | ADR-0011: Type-level Profile fence deferred | ALIGNED (resolved by #549) |
| ADR-0012 | 0012-shard-rule.md | ADR-0012: Module shard rule | ALIGNED (resolved by #549) |
| ADR-0013 | 0013-pkce-deferral.md | ADR-0013: PKCE deferral | ALIGNED (resolved by #549) |
| ADR-0014 | 0014-jsm-request-type-dispatch.md | ADR-0014: JSM request-type dispatch fork | ALIGNED |
| ADR-0015 | 0015-proactive-resolution-enforcement.md | ADR-0015: Proactive resolution enforcement | ALIGNED |
| ADR-0016 | 0016-windows-build-target.md | ADR-0016: Windows build target | ALIGNED |

---

## CHANGELOG [Unreleased] Assessment for PRs #547–#553

| PR | Commit | Type | CHANGELOG coverage |
|----|--------|------|--------------------|
| #547 | a7ba872 — maintenance sweep hygiene bundle | chore | Not in [Unreleased]; chore bundles are typically rolled into the next dev.x release notes. Acceptable. |
| #548 | d2a6f89 — fix(config): exits 64 not 78 (H-019) | fix | PRESENT in [Unreleased] Fixed. |
| #549 | 4022e00 — docs(adr): promote ADR-0007..0013 (SC-03) | docs | Not in [Unreleased]; docs-only. Acceptable. |
| #550 | b856f9f — chore(deps): bump actions/checkout 6.0.3 → 7.0.0 | chore(deps) | ABSENT — gap (DRIFT-S3-004). |
| #551 | 3f5bbd2 — fix(auth): debug-gate JR_SERVICE_NAME | fix/security | ABSENT — gap (DRIFT-S3-002). |
| #552 | 61a969b — chore: Bundle D test hygiene | chore | ABSENT — at project discretion. |
| #553 | 35e20c9 — fix(security): ADF recursion-depth guard SEC-001 | fix/security | PRESENT in [Unreleased] Security. |

---

## VERDICT

**PASS with low-severity gaps.** No CRITICAL or HIGH-severity drift. All automated checks pass (exit 0). Document counters are current (BC 603, NFR 42, ADR 16, Stories 91).

Actionable findings:
- **1 MED** (DRIFT-S3-001: CLAUDE.md missing BC-7.2.012 Gotchas entry — auto-PR-eligible)
- **3 LOW** (DRIFT-S3-002: CHANGELOG missing #551 security fix; DRIFT-S3-004: CHANGELOG missing #550 dep bump; DRIFT-S3-006: README version pin stale — all auto-PR-eligible)
- **1 LOW DECISION** (DRIFT-S3-003: .factory/architecture/adr/ stale shadow — requires cleanup decision)

Prior sweep's main finding (ADR gap in docs/adr/) is fully resolved by PR #549. Prior Finding 7 (README version pin) is fully resolved by PR #547. The CLAUDE.md architecture tree false-positive from the prior sweep (6 missing mod.rs files) was incorrect — all mod.rs files are present in the tree.
