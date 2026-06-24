# SC-03 Triage: ADR Location Drift (0007–0013)

**Finding ID:** MAINT-2026-06-17-SC-03 (re-flagged 2026-06-22 sweep)
**Triage date:** 2026-06-23
**Severity:** MED
**Status:** DECIDED

---

## 1. Enumeration of ADRs in Each Location

### `docs/adr/` (canonical per CLAUDE.md)

| ADR | Filename | CLAUDE.md "Key Decisions" entry |
|-----|----------|---------------------------------|
| ADR-0001 | `0001-thin-client-architecture.md` | Yes |
| ADR-0002 | `0002-oauth-embedded-secret.md` | Yes (superseded) |
| ADR-0003 | `0003-reqwest-rustls.md` | Yes |
| ADR-0004 | `0004-per-feature-specs.md` | Yes |
| ADR-0005 | `0005-graphql-org-discovery.md` | Yes |
| ADR-0006 | `0006-embedded-jr-oauth-app.md` | Yes |
| ADR-0014 | `0014-jsm-request-type-dispatch.md` | Yes |
| ADR-0015 | `0015-proactive-resolution-enforcement.md` | Yes |
| ADR-0016 | `0016-windows-build-target.md` | Yes |

Gap: ADR-0007 through ADR-0013 are absent.

### `.factory/architecture/adr/` (factory artifact store)

| ADR | Filename | Title | Status |
|-----|----------|-------|--------|
| ADR-0007 | `0007-multi-profile-fields-fix.md` | Multi-Profile Fields Bug Fix Strategy | Accepted |
| ADR-0008 | `0008-asset-enrichment-key-correctness.md` | Asset Enrichment HashMap Key Correctness | Accepted |
| ADR-0009 | `0009-handle-open-instance-url.md` | handle_open Must Use instance_url(), Not base_url() | Accepted |
| ADR-0010 | `0010-list-worklogs-pagination.md` | list_worklogs Must Use Pagination Loop | Accepted |
| ADR-0011 | `0011-type-level-profile-fence.md` | Type-Level Profile Fence (Newtype) | Deferred |
| ADR-0012 | `0012-shard-rule.md` | Module Shard Rule Codification | Accepted |
| ADR-0013 | `0013-pkce-deferral.md` | PKCE Deferral for OAuth 2.0 Authorization Code Flow | Accepted |
| ADR-0014 | `0014-jsm-request-create-dispatch-fork.md` | JSM Request Creation Dispatch Fork | Accepted |
| ADR-0016 | `0016-windows-build-target.md` | Windows Build Target | Accepted |

ADR-0015 is NOT in `.factory/architecture/adr/` — it lives only in `docs/adr/` (correct, no drift).

---

## 2. Classification: PRODUCT-FACING vs FACTORY-INTERNAL

### ADR-0007: Multi-Profile Fields Bug Fix Strategy — PRODUCT-FACING

Records a CRITICAL correctness bug (14 handler sites reading the wrong profile's custom field IDs) and the chosen fix strategy (read from per-profile config, not global config). This directly affects observable product behavior: wrong data in `jr issue list`, `jr sprint current`, `jr board view` when using multiple profiles. It is NOT a pipeline-process decision; it is a codebase architecture decision about how field IDs are resolved. Belongs in `docs/adr/`.

### ADR-0008: Asset Enrichment HashMap Key Correctness — PRODUCT-FACING

Records a HIGH-severity correctness bug (workspace-qualifier dropped from enrichment HashMap key, causing cross-workspace asset name misattribution) and the fix (use `(workspace_id, object_id)` as key throughout all three passes). Observable product impact on multi-workspace Jira Cloud tenants. Pure codebase architecture decision. Belongs in `docs/adr/`.

### ADR-0009: handle_open Must Use instance_url(), Not base_url() — PRODUCT-FACING

Records a HIGH-severity UX bug (`jr issue open` sends the user to a 404 URL under OAuth authentication) and the fix (use `instance_url()` for human-facing URLs, `base_url()` for API calls). Directly affects observable CLI behavior. Belongs in `docs/adr/`.

### ADR-0010: list_worklogs Must Use Pagination Loop — PRODUCT-FACING

Records a HIGH-severity data-loss bug (worklogs silently truncated at page size for issues with >50 worklogs) and the fix (pagination loop, same pattern as `list_comments`). Directly affects correctness of `jr worklog list`. Belongs in `docs/adr/`.

### ADR-0011: Type-Level Profile Fence (Newtype) — BORDERLINE PRODUCT-FACING, DEFERRED

Records a considered-but-deferred refactoring decision: introducing a `Profile(String)` newtype to make profile-unaware cache calls a compile error. Status is Deferred (target v0.6.0 or later). The decision is about internal code safety, not observable product behavior. However it IS a codebase architecture decision that a future contributor would need to know about, especially when adding new cache functions. On balance, PRODUCT-FACING — a future contributor reading `docs/adr/` to understand the codebase's approach to profile safety would expect to find this.

### ADR-0012: Module Shard Rule Codification — BORDERLINE; PRODUCT-FACING

Records the explicit codification of the "shard at ~1,000 LOC" rule for `src/cli/` files, including the current exception list (`adf.rs`, `api/auth.rs`) and the Phase 3 shard targets. The CLAUDE.md "Known Size Deviations" section references this concept but without the ADR anchor. A contributor needing to understand why a PR touching a large file requires explicit justification, or why certain files are exempt, needs this ADR. PRODUCT-FACING.

### ADR-0013: PKCE Deferral for OAuth 2.0 Authorization Code Flow — PRODUCT-FACING

Records the explicit deferral of PKCE (RFC 7636) implementation, the threat model, the residual risk (R-M1 MEDIUM), the reactivation trigger, and the monitoring URLs. This is a security architecture decision about OAuth 2.0 for the `jr` binary — directly relevant to anyone reviewing the auth security posture or deciding when to implement PKCE. CLAUDE.md already references ADR-0006 (the related embedded-OAuth decision) in Key Decisions. PRODUCT-FACING.

---

## 3. ADR-0014 Filename Mismatch

**`docs/adr/0014-jsm-request-type-dispatch.md`** (179 lines, no frontmatter)
**`.factory/architecture/adr/0014-jsm-request-create-dispatch-fork.md`** (94 lines, with structured YAML frontmatter)

These are two different documents describing the same decision (JSM dispatch fork), written at different phases of the VSDD pipeline. The `.factory` version is the Phase 1 brownfield analysis draft; the `docs/adr/` version is the final, fuller developer-facing write-up (179 vs 94 lines — the `docs/adr/` version has more detail including the Option A/B evaluation and consequences).

**Canonical file:** `docs/adr/0014-jsm-request-type-dispatch.md` is canonical. It is the more complete document and is in the declared-canonical location. CLAUDE.md references it as `ADR-0014` in the Key Decisions section.

**Resolution for `.factory` version:** The `.factory/architecture/adr/0014-jsm-request-create-dispatch-fork.md` should be treated as the Phase 1 draft that was superseded by the `docs/adr/` version. The factory adr-index.md already links to the factory version for ADR-0014; this should be updated to point to the `docs/adr/` canonical. The factory draft file can be left in place (it is historical factory artifact) but should not be treated as authoritative.

The `adr-index.md` at `.factory/architecture/adr-index.md` currently shows:
```
| [ADR-0014](adr/0014-jsm-request-create-dispatch-fork.md) | ... | Accepted | ... |
```
This should be updated to:
```
| [ADR-0014](../../../docs/adr/0014-jsm-request-type-dispatch.md) | ... | Accepted | ... |
```
(following the same relative-path pattern used for ADR-0015 in that index).

---

## 4. ARCH-INDEX and CLAUDE.md Cross-Reference Impact

### CLAUDE.md "Key Decisions" section (lines 178–186)

Currently lists ADR-0001 through ADR-0006, then skips to ADR-0014, ADR-0015, ADR-0016. There is no mention of ADR-0007 through ADR-0013. After promotion, the following entries should be added:

```
- ADR-0007: Multi-profile fields bug — per-profile field IDs must be read from ProfileConfig, not global config
- ADR-0008: Asset enrichment key correctness — HashMap key must be (workspace_id, object_id), not object_id alone
- ADR-0009: handle_open uses instance_url(), not base_url() — base_url() is API-only; browser URLs must use instance_url()
- ADR-0010: list_worklogs pagination loop — single-page fetch silently truncates; must use offset pagination
- ADR-0011: Type-level Profile fence deferred — convention-based soft fence is sufficient for current team size (v0.5.x)
- ADR-0012: Module shard rule — src/cli/ files at ≥1,000 LOC are shard candidates; exceptions: adf.rs, api/auth.rs
- ADR-0013: PKCE deferral — Atlassian 3LO does not support public-client PKCE as of 2026-05; reactivation trigger defined
```

### `.factory/architecture/adr-index.md`

The factory ADR index is the internal cross-reference for VSDD artifacts. After promoting files to `docs/adr/`, the index rows for ADR-0007 through ADR-0013 should be updated to reflect that the canonical versions are now in `docs/adr/`, using relative paths like:
```
| [ADR-0007](../../../docs/adr/0007-multi-profile-fields-fix.md) | ... |
```
Or left pointing to the factory copies (which become secondary). The simplest approach is: promote copies to `docs/adr/`, update the factory index to cross-reference `docs/adr/` as canonical for 0007–0013, and treat the `.factory/` copies as the original drafts.

### ADR-0016

ADR-0016 exists in BOTH `docs/adr/` and `.factory/architecture/adr/`. This is not a problem — it is the same file. The factory copy should be treated as a mirror. No action needed beyond confirming CLAUDE.md already lists ADR-0016 in Key Decisions (confirmed: line 186).

---

## 5. RECOMMENDATION

**MIXED** — all seven ADRs (0007–0013) are PRODUCT-FACING and should be promoted to `docs/adr/`, but the approach is a copy (not a move) to preserve factory-internal cross-references. In parallel, CLAUDE.md Key Decisions must be extended and the factory adr-index.md must be updated to point to the canonical `docs/adr/` paths.

### Precise Changeset (develop branch)

**Files to create in `docs/adr/`** (copy from `.factory/architecture/adr/`, filename unchanged except stripping the factory draft title variant for ADR-0014 — which already has a better canonical in `docs/adr/`):

| Source | Destination | Action |
|--------|-------------|--------|
| `.factory/architecture/adr/0007-multi-profile-fields-fix.md` | `docs/adr/0007-multi-profile-fields-fix.md` | COPY |
| `.factory/architecture/adr/0008-asset-enrichment-key-correctness.md` | `docs/adr/0008-asset-enrichment-key-correctness.md` | COPY |
| `.factory/architecture/adr/0009-handle-open-instance-url.md` | `docs/adr/0009-handle-open-instance-url.md` | COPY |
| `.factory/architecture/adr/0010-list-worklogs-pagination.md` | `docs/adr/0010-list-worklogs-pagination.md` | COPY |
| `.factory/architecture/adr/0011-type-level-profile-fence.md` | `docs/adr/0011-type-level-profile-fence.md` | COPY |
| `.factory/architecture/adr/0012-shard-rule.md` | `docs/adr/0012-shard-rule.md` | COPY |
| `.factory/architecture/adr/0013-pkce-deferral.md` | `docs/adr/0013-pkce-deferral.md` | COPY |

ADR-0014: NO action on file content. The `.factory` draft (`0014-jsm-request-create-dispatch-fork.md`) is the Phase 1 stub; the `docs/adr/0014-jsm-request-type-dispatch.md` is already the canonical. Leave both in place.

**Files to update:**

| File | Change |
|------|--------|
| `CLAUDE.md` | Add ADR-0007 through ADR-0013 entries to the "Key Decisions" bullet list (after ADR-0006, before ADR-0014) |
| `.factory/architecture/adr-index.md` | Update rows for ADR-0007..0013 to point to `docs/adr/` paths; update ADR-0014 row to point to `docs/adr/0014-jsm-request-type-dispatch.md` (following ADR-0015 pattern) |

**Files to leave unchanged:**
- `.factory/architecture/adr/0007-0013` files remain as factory drafts (historical artifacts, referenced by factory internals)
- `.factory/architecture/adr/0014-jsm-request-create-dispatch-fork.md` remains as the Phase 1 draft
- `docs/adr/0014-jsm-request-type-dispatch.md` remains as-is (already canonical)

### ADR-0014 Filename Mismatch Resolution

The mismatch is a naming divergence between the Phase 1 factory draft and the final developer-facing ADR. **No rename is needed.** The two files have different titles because they were written at different phases. The canonical is `docs/adr/0014-jsm-request-type-dispatch.md`. CLAUDE.md already references this correctly. The factory adr-index.md should be updated to link to the `docs/adr/` canonical (see above).

---

## 6. Boundary Definition (for RECLASSIFY prevention)

To prevent this class of drift recurring, the following boundary should be documented in CLAUDE.md or a new `docs/adr/README.md`:

> **`docs/adr/`** — canonical for all architectural decisions about the `jr` product and codebase. Any ADR that a contributor or future maintainer needs to understand the current design belongs here.
>
> **`.factory/architecture/adr/`** — factory artifact store used during VSDD pipeline analysis. Phase 1 brownfield ADR drafts originate here and are promoted to `docs/adr/` as part of the Phase 1 closure. Post-promotion, `.factory/` copies remain as historical artifacts. Do NOT treat `.factory/architecture/adr/` as the canonical source for any ADR that describes a product-codebase decision.

---

## 7. Follow-Up

**Agent:** technical-writer (or implementer — it is a doc-only changeset with no code changes)
**Branch:** `docs/adr-0007-0013-promotion` (or `chore/promote-factory-adrs`)
**Sequence:**
1. Copy ADR-0007..0013 to `docs/adr/`
2. Update CLAUDE.md Key Decisions section
3. Update `.factory/architecture/adr-index.md` (ADR-0007..0014 rows)
4. Run `tests/claude_md_citations.rs` guard (no new backtick path citations being added, so this is a no-op check)
5. PR → develop, conventional commit: `docs(adr): promote ADR-0007..0013 from factory to docs/adr/`

**Blocking?** No — this is documentation drift, not a correctness issue. The decisions are already implemented in code; the gap is discoverability. Priority: LOW (same as sweep classification). Schedule after any open MED items (H-019-EXIT-DRIFT, S-PG-MERGE-AUTH-BYPASS).
