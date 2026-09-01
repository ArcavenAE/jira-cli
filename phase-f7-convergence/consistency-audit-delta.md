# Phase F7 Pre-Gate Consistency Audit — field-dx bundle (cycle-002)

**Scope:** S-578-1, S-580-1, S-578-2, S-578-3, S-578-4 — all merged to `develop` @ `dd311e13`.
**Auditor:** consistency-validator (fresh-context, F7 pre-gate)
**Date:** 2026-08-31

## Guard script results

| Script | Result | Exit |
|---|---|---|
| `scripts/check-spec-counts.sh` | Check passed: 8 bc files validated | 0 |
| `scripts/check-bc-cumulative-counts.sh` | OK: all cumulative BC counts verified (719 total across 9 files) | 0 |
| `scripts/check-bc-citation-symbols.sh` | Check passed: 402 citations checked | 0 |
| `scripts/check-cargo-mutants-policy-citations.sh` | Check passed: 20 bullets parsed, 69 (file, fn) pairs validated | 0 |

All four automated guards pass. `.cargo/mutants.toml` includes `src/cli/field.rs` and
`src/cli/issue/field_resolve.rs`; `CREATE_D2_GOVERNED_KEYS` / `detect_flag_field_overlap` exist
in `field_resolve.rs` exactly as CHANGELOG/CLAUDE.md describe.

## Findings

1. **[HIGH] stale-narration — `CLAUDE.md` "Known Size Deviations" § `cli/issue/create.rs`**
   The entry reads "~530 LOC (re-measured 2026-08-25)" and describes the file as handling only
   "`issue create` platform path + JSM dispatch fork + `parse_field_kv`." Actual current size is
   **1,253 LOC** (`wc -l src/cli/issue/create.rs`) — 136% larger than documented, and it crossed
   ADR-0012's 1,000-LOC shard-candidate threshold without a corresponding deviation write-up.
   Traced via git history: create.rs was genuinely 530 LOC as of commit `f1ff9151` (2026-08-18,
   pre-field-dx); S-578-1 (`993de833`, merged 2026-08-26) grew it to 1,217 LOC by adding the
   `FieldValueSpec`/`FieldValueKind` hint parser directly into this file; S-578-4 (`ae8514b8`)
   grew it further to 1,253 LOC (createmeta resolution orchestration, D2 guard call sites,
   Platform-Path Guard Ordering SSOT). Neither growth was reflected in the CLAUDE.md entry. By
   contrast, the sibling `cli/issue/field_resolve.rs` entry in the same document *was* correctly
   updated ("re-measured 2026-08-30, S-578-4", ~1,635 documented vs. 1,650 actual — accurate
   within normal rounding) — confirming this is a specific omission for `create.rs`, not a
   systemic policy gap. **Remediation:** update the `create.rs` Known Size Deviations entry with
   the current LOC, cite S-578-1/S-578-4, and either justify staying unsharded (ADR-0012
   DOCUMENT-AS-IS, mirroring the file's siblings) or open a follow-up shard story.

2. **[MEDIUM] broken-ref — `verification-delta-field-dx.md` cites a nonexistent test file**
   `.factory/phase-f2-spec-evolution/verification-delta-field-dx.md` cites `tests/issue_create.rs`
   as the realization site for VP-578-001/002/003/004/017/018/019/020/021 (≈10 occurrences,
   including the §1.1 realization table and inline `new_properties`/`realizes_inline_vps`
   entries). No such file exists in `tests/`. The actual test file — confirmed by content
   (`createmeta_*` fixtures, `VP-578-017`/`018`/`019` doc-comments, `mount_createmeta_fields_*`
   helpers) — is **`tests/issue_create_field.rs`** (3,083 LOC, 37 tests). This is a citation-only
   defect (the VPs themselves are genuinely realized, in the right file, just misnamed in the
   spec artifact); does not affect BC-INDEX/CANONICAL-COUNTS guards since those don't parse this
   delta file. **Remediation:** one find-and-replace pass in `verification-delta-field-dx.md`
   swapping `tests/issue_create.rs` → `tests/issue_create_field.rs` at every citation site.

3. **[MEDIUM] stale-narration — `docs/specs/issue-create-preflight-guards.md` not updated for DEC-310**
   This spec doc's guard table and verbatim error-string sections still present the DEC-188
   contract (`--field` alone → exit 64, combined `--field`+`--on-behalf-of` → one combined
   error) as unqualified current behavior, with zero mention of `#578`, DEC-310, or the
   reversal anywhere in the file. Confirmed against shipped code
   (`src/cli/issue/create.rs`): only the `--on-behalf-of`-alone guard (BC-3.8.013) remains; the
   `--field`-alone guard and the combined-guard string are both gone. A reader who opens this
   file directly (rather than via CLAUDE.md) would be misled about current `--field` behavior.
   **Mitigating factor:** `CLAUDE.md` line ~269 already flags this doc inline as *"historical;
   describes the now-superseded combined-guard shape for `--field`"* — so the primary
   project-instructions surface is accurate and self-correcting; this is a spec-hygiene gap in
   the secondary doc, not a live misinformation risk for anyone following CLAUDE.md.
   **Remediation:** add a short superseded-banner at the top of the file pointing to
   BC-3.3.010/3.8.012 and DEC-310, consistent with how ADR-0014 itself was amended in place.

4. **[MEDIUM] coverage-gap — CHANGELOG.md under-documents 3 of 5 field-dx stories**
   `CHANGELOG.md`'s `[Unreleased]` section has dedicated entries for S-578-1 (parser, under
   *Breaking Changes*) and S-578-4 (platform-path reversal, under *Changed*), plus a CI-scope
   entry mentioning S-580-1 only in passing (mutants glob fix). There is **no dedicated
   Added/Changed entry** for S-580-1 (`jr field options <field>` — an entirely new top-level
   command), S-578-2 (`issue edit --field` real hint-kind dispatch: `:option`/`:id`/`:name`/
   `:asset`, cascading select, dry-run preview), or S-578-3 (JSM `--field` hint-kind parity).
   Since S-578-1 shipped only an interim-guarded parser (real dispatch explicitly deferred to
   S-578-2/3/4 per its own CHANGELOG text), the CHANGELOG currently describes the *setup* of the
   hint-syntax feature but not its functional payoff, and is entirely silent on the new `jr field
   options` command family. `README.md` also has zero mentions of `jr field`/`:kind=` (though
   this mirrors README's pre-existing silence on `--field` generally, predating field-dx — not a
   regression introduced by this delta). **Remediation:** add CHANGELOG `### Added` entries for
   `jr field options` (S-580-1) and `### Changed`/`### Added` entries for the `:option`/`:id`/
   `:name`/`:asset` dispatch on `issue edit`/JSM `issue create` (S-578-2/S-578-3) before the
   human release-notes gate, if these are meant to ship user-facing in this dev version.

5. **[LOW] convention — all 5 field-dx story files' frontmatter `status:` field stuck at `ready`**
   `S-578-1/2/3/4` and `S-580-1` all carry `status: ready` in frontmatter, while
   `STORY-INDEX.md`'s narrative rows correctly and consistently describe each as `status:
   completed (DELIVERED + MERGED …)`. Confirmed this is **not specific to the field-dx delta** —
   it is a widespread, pre-existing pattern across the story corpus (e.g. S-396, S-398, S-407,
   S-576-1..4 all show the same frontmatter/narrative mismatch), while a separate subset of
   stories (S-639-1, S-627-1, S-663-1, S-626-1, etc.) correctly update frontmatter `status:
   done`. `STORY-INDEX.md` — the authoritative source of truth per its own frontmatter
   (`status: complete`) — is accurate; only the per-file frontmatter lags. Not a field-dx-
   introduced defect; flagged for completeness since the prompt asked about story anchor
   consistency, but does not block this gate.

## Not found (explicitly checked, clean)

- BC coverage: BC-3.3.010/011, BC-3.4.014/015/016/026-031, BC-3.8.008/012/013, and BC-X.14.001-004
  all exist, are correctly amended/added in `bc-3-issue-write.md` and `cross-cutting.md`, and are
  reflected in `BC-INDEX.md`'s changelog preamble and X.14 subsection table (719 cumulative,
  guard-verified).
- VP coverage: all 24 VP-578-0xx (001-024) and 8 VP-580-0xx (005-012) referenced by the 5 stories'
  frontmatter are declared, reconciled (the retired parallel `-04x` band is explicitly mapped),
  and traced to owning BCs in `verification-delta-field-dx.md`; the file's own internal
  round-5 reconciliation states "ZERO pending BC-body back-fills remain."
- Symbol citations: `parse_field_kv`, `handle_create` (`create.rs`), `resolve_edit_fields`
  (`field_resolve.rs`), `JsmRequestBuilder::build` (`api/jsm/requests.rs`), `src/cli/field.rs`
  all exist and match story `traces_to`/`target_module` fields.
- ADR-0019: registered in `ARCH-INDEX.md` with matching subsystems (SS-02/SS-04/SS-05); story
  subsystem tags are all subsets of that set — no anchor drift.
- ADR-0014: correctly amended in place with a DEC-310 banner at the top and inline
  "DEC-188 amendment" callouts scoped precisely to `--on-behalf-of`; consistent with shipped
  code and with CLAUDE.md.
- DEC-310: consistently recorded across BC-3.8.012 body, BC-INDEX changelog, ADR-0019,
  ADR-0014, all 5 story files' STORY-INDEX narration, `holdout-scenarios.md`, and
  `CHANGELOG.md`'s Changed section.
- Holdouts: H-NEW-PREFLIGHT-001/003/006 rewritten in place exactly as expected (verified body
  text + changelog notes); H-NEW-PREFLIGHT-002/004/005 confirmed unchanged/untouched.
  `total_holdouts: 106` matches actual `### H-` header count (106).
- CLAUDE.md field-dx gotcha entries (lines ~269-270): accurate, current, and correctly flag the
  stale companion spec doc (finding 3 above).
- `field_resolve.rs` Known Size Deviations entry: accurate (~1,635 documented vs. 1,650 actual).
- EC-3.4.017-16, EC-3.4.027-7, EC-3.4.030-6 and their cross-BC references all resolve to real,
  consistent text across `bc-3-issue-write.md`.

## OVERALL VERDICT: **CONSISTENT**

No CRITICAL findings. One HIGH finding (finding 1, a stale doc-fallout entry in CLAUDE.md's
Known Size Deviations table) should be fixed before or immediately after the human gate — it is
a documentation-accuracy defect, not a spec/code/test contradiction, and does not indicate any
missing coverage, broken trace, or functional regression in the delta itself. The three MEDIUM
findings are all citation/documentation hygiene items (a wrong test filename in one spec
artifact, a companion doc not carrying its own supersession banner, and a CHANGELOG that lags
behind two of the five stories' user-facing surface) — none represents a broken BC→VP→test
chain, a count mismatch the guard scripts would have caught, or a functional gap. The field-dx
delta's core traceability (BC ↔ VP ↔ story ↔ test ↔ ADR ↔ DEC-310 ↔ holdout) is internally
coherent and ready for the human approval gate, contingent on triaging finding 1 (and ideally
2-4) as fast-follow documentation fixes.
