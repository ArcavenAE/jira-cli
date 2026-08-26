---
document_type: canonical-counts
product: jr (jira-cli)
generated: "2026-05-04"
last_verified: "2026-08-25 (bc-3-issue-write.md +8 BCs (BC-3.3.010..011 + BC-3.4.026..031) and cross-cutting.md +4 BCs (BC-X.14.001..004) added F2 spec evolution, Field DX bundle, issues #580/#578 — BC-3.8.012 REVERSED in place (DEC-188 --field guard removed, DEC-310 proposed — renumbered from the initially-proposed DEC-307, which was already cycle-001's); 719 total; prior: 2026-08-21 (bc-2-issue-read.md +8 BCs added F2 spec evolution, list-read-ergonomics bundle, issues #575/#584/#579/#588 — BC-2.1.023..025 + BC-2.2.033..034 + BC-2.3.041..042 + BC-2.6.052; BC-2.1.006/007 amended in place, no separate count; 707 total; prior: 2026-08-15 (bc-8-components.md NEW FILE added F2 spec evolution, component-management bundle, issues #604/#605/#606/#608 — jr component command group, 28 individually-bodied BCs; BC-2.1.018..022 + BC-2.3.040 added to bc-2-issue-read.md (--component filter + Component.id prerequisite; +6); BC-3.4.022..025 added to bc-3-issue-write.md (issue create/edit --component; +4); BC-2.1.006/007, BC-3.4.012/013/017/020/021, and cross-cutting.md BC-X.10.001 amended in place (no separate count); +38 total; 699 total; prior: 2026-08-13 (BC-1.2.047 added F2 spec evolution, bucket1-defects bundle, issue #663 — `auth switch --profile <X>` rejected exit 64; +1 individually-bodied BC; 661 total; BC-1.2.018 amended in place (auth switch carve-out, no count change); prior: BC-2.2.032 + BC-2.3.039 added F2 spec evolution issue #668 duedate feature — `issue list --duedate` opt-in column + `issue view` always-on Due Date row; +2 individually-bodied BCs; 660 total; BC-2.2.028 + BC-2.3.036 amended in place (16→17 field list, no count change); prior: BC-X.13.007 added FIX ROUND 12 S-626-1 issue #626 — `test` job runtime test-execution floor / POL-11; +1 individually-bodied BC; 658 total; prior: BC-3.9.015..020 added adversary pass-1 round B; +6 individually-bodied BCs; 657 total; prior: BC-2.7.001..012 + BC-3.9.001..014 + BC-X.8.010 added SOH-ATTACHMENTS-1 F2 DEC-179 issues #576 #585)"
---

# Canonical Counts — jr (jira-cli) L3 PRD

This file is the single source of truth for all count claims across PRD and
architecture files. Every count is backed by a shell command that can be
re-run to verify. Disputes go here first.

---

## BC Counts

### Per-file definitional counts (actual `#### BC-` headings)

| File | Actual `#### BC-` count | Frontmatter `definitional_count` | Match? |
|------|------------------------|----------------------------------|--------|
| bc-1-auth-identity.md | 47 | 47 | YES |
| bc-2-issue-read.md | 80 | 80 | YES |
| bc-3-issue-write.md | 123 | 123 | YES |
| bc-4-assets-cmdb.md | 22 | 22 | YES |
| bc-5-boards-sprints.md | 18 | 18 | YES |
| bc-6-config-cache.md | 33 | 33 | YES |
| bc-7-output-render.md | 49 | 49 | YES |
| bc-8-components.md | 28 | 28 | YES |
| cross-cutting.md | 89 | 89 | YES |
| **Total individually-bodied** | **489** | — | — |

Verification command:
```bash
for f in .factory/specs/prd/bc-*.md .factory/specs/prd/cross-cutting.md; do
  echo -n "$(basename $f): "; grep -c '^#### BC-' "$f"
done
```

### Per-file total_bcs (cumulative claim: individually-bodied + range-collapsed)

| File | Frontmatter `total_bcs` |
|------|------------------------|
| bc-1-auth-identity.md | 58 |
| bc-2-issue-read.md | 122 |
| bc-3-issue-write.md | 152 |
| bc-4-assets-cmdb.md | 32 |
| bc-5-boards-sprints.md | 36 |
| bc-6-config-cache.md | 43 |
| bc-7-output-render.md | 93 |
| bc-8-components.md | 28 |
| cross-cutting.md | 155 |
| **Sum** | **719** |

### Grand total

**Canonical grand total: 719** (+12 BC-3.3.010..011 + BC-3.4.026..031 + BC-X.14.001..004 added
2026-08-25 via F2 spec evolution, Field DX bundle, issues #580/#578 — `issue create --field`
extended to the non-JSM platform path via createmeta resolution (BC-3.3.010/011, reverses
DEC-188's `--field`-alone platform-path exit-64 guard, DEC-310 proposed); `--field
NAME:kind=VALUE` hint-syntax parser + `:option`/`:id`/`:name`/`:asset` semantics + malformed-hint
EC catalog (BC-3.4.026..031); new "Field Option Discovery" Cross-Cutting subsection for `jr field
options <field>` (BC-X.14.001..004, exactly-one-of-three context mechanisms: createmeta PRIMARY
platform, JSM requesttype-fields PRIMARY JSM, editmeta FALLBACK); BC-3.3.001, BC-3.4.014,
BC-3.4.015, BC-3.4.016, BC-3.4.017 (Gate B extended to hint-tagged `--field NAME:kind=VALUE`
pairs, new EC-3.4.017-16, adversary pass-13 F-1), BC-3.8.001, BC-3.8.008 amended in place, no
separate count; BC-3.8.012 REVERSED in place, no separate count; BC-3.8.013 amended in place
(body trigger-scope + dead combined-error cross-refs; guard behavior unchanged), no separate
count; was 707 before this
addition; prior note: 707 total after
+8 BC-2.1.023..025 + BC-2.2.033..034 + BC-2.3.041..042 + BC-2.6.052 added 2026-08-21 via F2 spec evolution, list-read-ergonomics bundle, issues #575/#584/#579/#588 — `--fields <CSV>` on `issue list`/`issue view` + additive client field-override methods (#575); raw ADF passthrough for `--fields comment`, confirmatory (#584); `--updated-recent <duration>` (#579); `--sort <field>:asc|desc` shorthand (#588); BC-2.1.006/007 amended in place, no count change; +28 bc-8-components.md NEW FILE added 2026-08-15 via F2 spec evolution, component-management bundle, issues #604/#605/#606/#608 — `jr component` command group (BC-8.1.001..008/BC-8.2.001..008/BC-8.3.001..007/BC-8.4.001..005); +6 BC-2.1.018..022 + BC-2.3.040 added 2026-08-15 via issue #606 F2 — `issue list --component` filter + shared `Component.id` prerequisite; BC-2.1.006/007 amended in place, no count change; +4 BC-3.4.022..025 added 2026-08-15 via issues #604/#605/#608 F2 — `issue create/edit --component`; BC-3.4.012/013/017/020/021 amended in place, no count change; cross-cutting.md BC-X.10.001 amended in place (resolve_component caller citation), no count change; +1 BC-1.2.047 added 2026-08-13 via F2 spec evolution, bucket1-defects bundle, issue #663 — `auth switch --profile <X>` rejected exit 64; BC-1.2.018 amended in place, no count change; +2 BC-2.2.032 + BC-2.3.039 added 2026-08-13 via F2 spec evolution issue #668 duedate feature — `issue list --duedate` opt-in column + `issue view` always-on Due Date row; BC-2.2.028 + BC-2.3.036 amended in place, no count change; +1 BC-X.13.007 added 2026-08-05 via FIX ROUND 12 S-626-1 issue #626 — `test` job runtime test-execution floor / POL-11; +33 (=+27 initial CREATE 2026-07-15 + 6 round-B BC-3.9.015..020) BC-2.7.001..012 + BC-3.9.001..014 + BC-X.8.010 added 2026-07-15 via SOH-ATTACHMENTS-1 F2 DEC-179 issues #576 #585; +4 BC-7.4.013-016 added 2026-05-08 via Fix-PR A `28b0f35`; +1 BC-2.6.050 added 2026-05-13 via issue #350; +1 BC-2.6.051 added 2026-05-14 via issue #365; +1 BC-3.4.009 added 2026-05-15 via issue #340 F2; +18 BC-3.8.001..010 + BC-X.12.001..008 added 2026-05-18 via issue #288 F2+F1d; +3 BC-3.8.011..013 added 2026-05-19 via issue #288 F1d + issue #383 F2; +4 BC-3.8.014..015 + BC-X.8.006..007 added 2026-05-19 via issue #384 F2; +2 BC-3.8.016..017 added 2026-05-20 via issue #385 F2; +2 BC-3.4.010..011 added 2026-05-20 via issue #388 F2; +3 BC-3.4.012..014 added 2026-05-21 via issue #398 F2; +3 BC-3.4.015..017 added 2026-05-22 via issue #396 F2; +2 BC-3.4.018..019 added 2026-06-01 via issue #331 F2; +1 BC-3.2.013 added 2026-06-03 via jsm-resolution-required F2; +1 BC-7.2.006 added 2026-06-08 via issue #470 listItem content-model conformance; +2 BC-X.8.008..009 added 2026-06-08 via S-QUEUE-BC-1 queue list/view document-as-is; +1 BC-3.2.014 added 2026-06-08 via fix-bulk-transition-schema bulkTransitionInputs wrapper; +2 BC-7.2.007..008 added 2026-06-08 via issue #474 markdown subsup + heading-attr; +1 BC-7.2.009 added 2026-06-09 via issue #483 GFM alerts → panel; +1 BC-7.2.010 added 2026-06-10 via issue #471 GFM task lists → taskList/taskItem; +3 BC-6.1.014 + BC-6.2.016..017 added 2026-06-12 via windows-build F2; +1 BC-7.2.011 added 2026-06-15 via issue #492 block-HTML hardBreak interior newlines; +1 BC-2.4.043 added 2026-06-17 via Bundle C CR-001 list_comments anti-stall guard; +3 BC-X.13.001..003 added 2026-06-19 via DEAD-CITATION-CI F2 CLAUDE.md citation guard; +1 BC-7.2.012 added 2026-06-24 via SEC-001 ADF recursion depth limit; +2 BC-7.2.013..014 promoted 2026-06-27 range-collapsed→individually-bodied via issues #472 #473 (definitional_count +2, total_bcs unchanged); +1 BC-6.2.018 added 2026-06-27 cache warm-hit no-HTTP invariant; +1 BC-7.3.010 added 2026-06-27 issue #526 json-render invariant + error channel; +3 BC-3.4.020..021 + BC-5.1.005 added 2026-06-30 via BC-subclause-pass F2; +3 BC-X.13.004..006 added 2026-07-05 via CITATION-GUARDS Story B Guard 1 S-BC-CITATION-GUARD-1 issue #102; +1 BC-7.2.015 added 2026-07-07 via ADF-CODE-MARK-EXCLUSIVITY F2 issue #571; +1 BC-X.1.011 added 2026-07-09 via SOH-BUGS-1 post-fix micro-BC DEC-165 -X/--method case-insensitive issues #590/#582 PR #597; +11 BC-3.5.002..BC-3.5.012 added 2026-07-09 via SOH-COMMENT-CRUD-1 F2 DEC-168 comment delete/edit/view + CLI subcommand group issue #577)

_Note: BC-INDEX.md `total_bcs` header was bumped to 651 in v1.3.43 via a sanctioned Python shell edit (TD-031 validate-stable-anchors hook bypassed per the established workaround). CANONICAL-COUNTS.md remains the primary source of truth; TD-031 line-cite violations are tracked separately for cleanup._

Breakdown:
- 719 = sum of per-file `total_bcs` values (canonical; see per-file table above)
- 489 of 719 are individually-bodied (have a `#### BC-` heading)
- 230 are range-collapsed (counted in cumulative claim, no individual heading; unchanged — the
  2026-08-25 Field DX addition is entirely individually-bodied, no range-collapsed entries)
- BC-X.4.009 (ADV-P1-029) is a `#### BC-` heading in cross-cutting.md; it is
  included in cross-cutting's `total_bcs: 155` and in the **719 sum**.
  It does NOT add +1 beyond the 656.
  _(Note updated 2026-08-25 F2 spec evolution, Field DX bundle, issues #580/#578: 719 total
  after +12 BCs (BC-3.3.010..011 + BC-3.4.026..031 added to bc-3-issue-write.md; BC-X.14.001..004
  added to cross-cutting.md as a new subsection; BC-3.3.001/BC-3.4.014/BC-3.4.015/BC-3.4.016/
  BC-3.4.017/BC-3.8.001/BC-3.8.008/BC-3.8.013 amended in place, BC-3.8.012 REVERSED in place,
  no separate count); was 707 before this
  addition; prior note: 707 total after +8 BCs (BC-2.1.023..025 + BC-2.2.033..034 +
  BC-2.3.041..042 + BC-2.6.052 added to bc-2-issue-read.md; BC-2.1.006/007 amended in
  #575/#584/#579/#588: 707 total after +8 BCs (BC-2.1.023..025 + BC-2.2.033..034 +
  BC-2.3.041..042 + BC-2.6.052 added to bc-2-issue-read.md; BC-2.1.006/007 amended in
  place, no separate count); was 699 before this addition; prior note: 699 total after
  +38 BCs (bc-8-components.md NEW FILE +28;
  BC-2.1.018..022 + BC-2.3.040 +6; BC-3.4.022..025 +4); was 661 before this addition;
  prior note: 661 total after +1 BC BC-1.2.047; was 660 before this addition; prior note: 660 total after +2 BCs
  BC-2.2.032 + BC-2.3.039 F2 spec evolution issue #668; was 658 before this addition; prior
  note: 658 total after +1 BC BC-X.13.007
  FIX ROUND 12 S-626-1 issue #626; was 657 before that addition; prior note: 657 total after
  +6 BCs BC-3.9.015..020 SOH-ATTACHMENTS-1 adversary pass-1 round B; was 651 before round B;
  was 149/624/623 before BC-X.8.010 — NEW-004 correction)_

_Historical note (archived; historical total was 566; current canonical: see Sum row above (624 — historical, now 658 — see per-file table above for current totals)): Passes 10-13 involved a 541/542 count confusion around BC-X.4.009. All 542 claims were corrected to 541 at Pass 13. Subsequent additions (BC-7.4.013-016, BC-2.6.050-051, BC-3.4.009, BC-3.8.001-010, BC-X.12.001-008) brought the total to 566. See git history for the full audit trail._

### L2 domain-spec bc_count vs L3 total_bcs alignment (ADV-P17-003)

L2 frontmatter `bc_count` values are now aligned to match L3 `total_bcs` values.
bc_count in L2 represents the same cumulative claim (individually-bodied + range-collapsed).

| L2 File | L2 bc_count (after P17 fix) | L3 File | L3 total_bcs | Aligned? |
|---------|----------------------------|---------|--------------|----------|
| bc-01-auth-identity.md | 57 | bc-1-auth-identity.md | 58 | PENDING (L2 not bumped by this pass; out of scope — F2 delta touched L3 only) |
| bc-02-issue-read.md | 108 | bc-2-issue-read.md | 122 | PENDING (L2 not bumped by the 2026-08-21 F2 list-read-ergonomics delta — F2 touched L3 only, same posture as bc-01; +8 BCs BC-2.1.023..025 + BC-2.2.033..034 + BC-2.3.041..042 + BC-2.6.052 added issues #575/#584/#579/#588; prior: PENDING since the 2026-08-15 F2 component-management delta; prior: YES, bumped 2026-08-13; +2 BCs BC-2.2.032 + BC-2.3.039 added F2 issue #668 duedate feature; prior: bumped 2026-07-15; +12 BCs BC-2.7.001..012 added SOH-ATTACHMENTS-1 F2 DEC-179) |
| bc-03-issue-write.md | 140 | bc-3-issue-write.md | 152 | PENDING (L2 not bumped by the 2026-08-25 F2 Field DX delta — F2 touched L3 only, same posture as bc-01; +8 BCs BC-3.3.010..011 + BC-3.4.026..031 added issues #580/#578; prior: PENDING since the 2026-08-15 F2 component-management delta; prior: YES, bumped 2026-07-15; +14 BCs BC-3.9.001..014 added SOH-ATTACHMENTS-1 F2 DEC-179; +6 BCs BC-3.9.015..020 added adversary pass-1 round B 2026-07-15) |
| bc-04-assets-cmdb.md | 32 | bc-4-assets-cmdb.md | 32 | YES (was 44) |
| bc-05-boards-sprints.md | 36 | bc-5-boards-sprints.md | 36 | YES (bumped 2026-06-30; +1 BC BC-5.1.005 added BC-subclause-pass F2) |
| bc-06-config-cache.md | 43 | bc-6-config-cache.md | 43 | YES (bumped 2026-06-27; +1 BC-6.2.018 added cache warm-hit no-HTTP invariant) |
| bc-07-output-render.md | 93 | bc-7-output-render.md | 93 | YES (bumped 2026-07-07; +1 BC-7.2.015 added issue #571 ADF code-mark exclusivity) |
| bc-08-components.md (not created) | — | bc-8-components.md | 28 | PENDING — same posture as prior L3-only F2 deltas; L2 not kept in sync per established convention |

Note: bc-01/04/05 aligned at Pass 17. bc-02/03/06/07 had PENDING drift; all four bumped 2026-06-17 (Maintenance Bundle B, SC-01).

---

## NFR Counts

**Canonical NFR total: 42**

Verification command:
```bash
grep -c '^| \*\*NFR-' .factory/specs/prd/nfr-catalog.md
```

Severity distribution per nfr-catalog.md routing table:
- CRITICAL: 1 (NFR-R-D)
- HIGH: 6 (NFR-R-A, NFR-R-B, NFR-R-E, NFR-S-B, NFR-S-E, NFR-S-F)
- MEDIUM: 17 (NFR-R-C, NFR-R-F, NFR-S-A, NFR-S-C, NFR-O-A, NFR-O-B, NFR-O-D, NFR-O-F, NFR-O-J, NFR-O-L, NFR-O-M, NFR-O-O, NFR-O-S, NFR-O-W, NFR-P-NEW-1, NFR-T-E2E-1, NFR-P-W1)
- LOW: 18 (remainder)
- **Total: 42** (confirmed by grep count above)

Note: NFR-O-K was merged into NFR-S-D at adversary Pass 7 (no net change). NFR-S-F added at ADV-P3-007 (+1). NFR-S-E severity promoted LOW→HIGH at ADV-P2-004 (no net count change). NFR-T-E2E-1 added F2 Feature Mode (live-Jira E2E CI obligation, 2026-05-29; +1 MEDIUM). NFR-P-W1 added windows-build F2 (supported platforms, 2026-06-12; +1 MEDIUM).

---

## Holdout Scenarios

**Canonical holdout total: 106**

Verification command:
```bash
grep -c '^### H-' .factory/specs/prd/holdout-scenarios.md
```

Expected: 106 (H-001..H-047 + H-NEW-MP-001 + H-NEW-VERBOSE-001 + H-NEW-VERBOSE-002 + H-NEW-AUTH-002 + H-NEW-JSM-RT-001..H-NEW-JSM-RT-007 + H-CITE-001..H-CITE-003 + H-NEW-ADF-001..H-NEW-ADF-008 + H-NEW-SEC-001..H-NEW-SEC-002 + H-NEW-ADF-009..H-NEW-ADF-010 + H-NEW-EDIT-FIELD-001..H-NEW-EDIT-FIELD-002 + H-NEW-EDIT-TYPE-001..H-NEW-EDIT-TYPE-002 + H-NEW-CHANGELOG-001 + H-NEW-WORKLOG-ADD-001 + H-NEW-LINK-001 + H-NEW-QUEUE-VIEW-001 + H-NEW-LABEL-FORK-001 + H-NEW-DRY-RUN-001 + H-NEW-BOARD-VIEW-001 + H-NEW-COMMENT-001..H-NEW-COMMENT-005 + H-NEW-ATTACHMENT-001..H-NEW-ATTACHMENT-012 + H-NEW-PREFLIGHT-001..H-NEW-PREFLIGHT-006)

Groups added since last reconciliation (57 → 106):
- Group 8b (CI Citation Guard, 2026-06-19): H-CITE-001..H-CITE-003 (BC-X.13.001..003; S-MAINT-DEAD-CITATION-CI) — +3 (retitled from "Group 8" to "Group 8b" to resolve duplicate heading; P18-005)
- Group 10 (ADF Markdown→ADF Feature Wave, D4 Burst 1 2026-06-26): H-NEW-ADF-001..H-NEW-ADF-008 (BC-7.2.009/010/011/003) — +8
- Group 11 (SEC-001 ADF Recursion-Depth Guard, D4 Burst 2 2026-06-26): H-NEW-SEC-001..H-NEW-SEC-002 (BC-7.2.012) — +2
- Group 12 (ADF Footnote Pruning + Code-Mark Exclusivity, 2026-06-27/2026-07-07): H-NEW-ADF-009 (BC-7.2.013) + H-NEW-ADF-010 (BC-7.2.015; extended with Call E JSM-path parity 2026-07-07) — +2
- Group 13 (Issue Edit / Changelog / Worklog / Links / Queue, F2 Burst 1 2026-06-30): H-NEW-EDIT-FIELD-001..H-NEW-EDIT-FIELD-002 + H-NEW-EDIT-TYPE-001..H-NEW-EDIT-TYPE-002 + H-NEW-CHANGELOG-001 + H-NEW-WORKLOG-ADD-001 + H-NEW-LINK-001 + H-NEW-QUEUE-VIEW-001 — +8
- Group 14 (Label Routing Fork / Dry-Run / Board View, F2 Burst 2 2026-06-30): H-NEW-LABEL-FORK-001 + H-NEW-DRY-RUN-001 + H-NEW-BOARD-VIEW-001 — +3
- Group 15 (Comment CRUD, SOH-COMMENT-CRUD-1 F2 2026-07-09/2026-07-10, DEC-168): H-NEW-COMMENT-001..H-NEW-COMMENT-005 (BC-3.5.005/008/004/010/003; issue #577) — +5
- Group 19 (Attachment Write, SOH-ATTACHMENTS-1 adversary pass-1 round B + P4-014 + P14-001 + P15-002 + P20-001 + P21-001, 2026-07-15/2026-07-16): H-NEW-ATTACHMENT-001..H-NEW-ATTACHMENT-012 (BC-2.7.001/007/008/010/011 + BC-3.9.001/003/004/005/015..020; P15-002/R3.12 adds H-NEW-ATTACHMENT-010; P20-001 adds H-NEW-ATTACHMENT-011 — BC-3.9.004 OQ-9 branch: --internal on non-JSM → silent platform POST, exit 0, zero servicedeskapi calls; P21-001 adds H-NEW-ATTACHMENT-012 — BC-3.9.010 EC-3.9.010-4: mid-batch bulk 404 benign-skip-continue, count=2, ids exclude 404'd AID, exit 0, 3 DELETEs issued; issues #576 #585) — +12
- Group 20 (Issue Create Pre-flight Guards, SOH-DX-1 F2 2026-07-29, #639, DEC-188; REWRITTEN 2026-08-25 issue #578 F2 adversary pass-2, DEC-310 reversal): H-NEW-PREFLIGHT-001..H-NEW-PREFLIGHT-006 (BC-3.8.012/013; originally authored against DEC-188's --field and --on-behalf-of exit-64 pre-flight guard on the platform path without --request-type). DEC-310 (2026-08-25) reversed BC-3.8.012's --field-alone guard, so H-NEW-PREFLIGHT-001/003/006 were REWRITTEN IN PLACE to the new contract: 001 — --field alone now resolves via createmeta (BC-3.3.010) and succeeds (exit 0), POST fires with the field merged in; 003 — --field AND --on-behalf-of together now fire only BC-3.8.013's standalone --on-behalf-of guard (exit 64; the combined guard is removed, --field's createmeta resolution never reached); 006 — --field alone with --output json now succeeds (exit 0) with a JSON success envelope on stdout, not an error envelope. H-NEW-PREFLIGHT-002 (--on-behalf-of alone, exit 64) and H-NEW-PREFLIGHT-004/005 (neither-flag regression pin; JSM non-mis-fire) are UNCHANGED by the reversal. No scenario IDs added or removed — +6

_Note: holdout-scenarios.md frontmatter `total_holdouts: 106` counts all holdout entries; the grep count of `^### H-` headings also returns 106. The frontmatter count (106) is authoritative. Last reconciled: 2026-08-25 (issue #578 F2 adversary pass-2, DEC-310 reversal of DEC-188 — H-NEW-PREFLIGHT-001/003/006 rewritten in place to the reversed --field contract per BC-3.8.012's 2026-08-25 amendment; H-NEW-PREFLIGHT-002/004/005 unchanged; no scenario IDs added or removed, count unaffected). Previously reconciled: 2026-07-29 (SOH-DX-1 F2 P-holdout authoring; +H-NEW-PREFLIGHT-001..006 — BC-3.8.012/013 pre-flight guards for --field and --on-behalf-of without --request-type; DEC-188, #639)._

---

## Risk Register

**Canonical risk total: 36**

Verification command:
```bash
grep -c '^| \*\*R-[CHML]' .factory/architecture/risk-register.md
```

Severity distribution (per risk-register.md §Risk Summary):
- CRITICAL: 1 (R-C1)
- HIGH: 7 (R-H1..R-H6 baseline + R-H288-1 from issue #288)
- MEDIUM: 11 (R-M0..R-M8 baseline + R-NEW-AR-1, R-NEW-AR-4 from S-3.03 + R-M288-1 from issue #288)
- LOW: 17 (R-L1..R-L13 baseline + R-NEW-AR-2, R-NEW-AR-3, R-NEW-AR-5 from S-3.03 + R-NEW-S307-1 from S-3.07)
- **Total: 36**

Note: R-M3 was merged into R-L11 at Pass 8 (net -1). R-L12 + R-L13 added at CV-003 gate prep. 5 auto-refresh risks added S-3.03 v2 (2 MEDIUM, 3 LOW). 1 search anti-loop risk added S-3.07 v2 (1 LOW). 2 risks added issue #288 (1 HIGH, 1 MEDIUM). risk-register.md §Risk Summary is authoritative.

Last reconciled: 2026-05-18 (post-#288 F2 delta; previous reconciliation pre-S-3.03)

---

## ADRs

**Canonical ADR count: 19** (ADR-0001..ADR-0019; all present, no gaps)

- ADR-0001..0016: reside in `docs/adr/` (index at `.factory/architecture/adr-index.md`; `.reference/jira-cli/docs/adr/` is a read-only vendored copy, not canonical; `.factory/architecture/adr/` was removed, DRIFT-S3-003 resolved 2026-06-25)
- ADR-0014: JSM request create dispatch fork (issue #288)
- ADR-0015: Proactive resolution enforcement on done-category transitions (jsm-resolution-required)
- ADR-0016: Windows Build Target (windows-build F2 2026-06-12)
- ADR-0017: First multipart/streaming HTTP surface — reqwest multipart+stream features + tokio-util direct dependency (SOH-ATTACHMENTS-1 F2 DEC-179, 2026-07-15)
- ADR-0018: Component resolution, caching, delete-safety, and mutation-wire-shape strategy (component-mgmt F2 gate, DEC-278/279/280; issues #604/#605/#606/#608, 2026-08-15)
- ADR-0019: Field DX: option-enumeration context strategy, hint-kind value-spec shape, and cascading-select delimiter (field-dx F2 gate; issues #580/#578, 2026-08-25)
- ADR-0002: Superseded by ADR-0006 (still counted — superseded is a valid status)
- ADR-0013: PKCE deferral for OAuth 2.0 authorization code flow (Phase 1→2 gate, 2026-05-04)

Location convention: ADR-0001..0016 reside in `docs/adr/` (with `.factory/architecture/adr-index.md` as their index); ADR-0017..0019 reside in `.factory/specs/architecture/decisions/` (per ARCH-INDEX.md and `adr-index.md` header note).

Verification: count rows in adr-index.md Summary Table (both `[ADR-NNNN]` link rows and plain `ADR-NNNN` rows).

---

## Security Decisions

**Canonical SD count: 3** (SD-001, SD-002, SD-003)

Location: `.factory/architecture/security-decisions/`

---

## Cache Types

**7 distinct cache files** (per cache.rs) [P6-004 correction: serviceDeskId reuses existing `project_meta.json` via `get_or_fetch_project_meta` — no new cache file family added; count reverted 8→7]:
1. team list
2. project meta (`project_meta.json` — also carries `service_desk_id` for JSM attachment upload via `get_or_fetch_project_meta`; added SOH-ATTACHMENTS-1 role noted; no new file)
3. workspace ID (hybrid: reads env + cache)
4. CMDB fields
5. object-type attributes
6. resolutions
7. fields list (`fields.json` — `FieldsCache`; added issue #396 F2 for `--field` name resolution; best-effort writer; 7-day TTL)

All use 7-day TTL. Root path (platform-conditional per BC-6.2.016): `~/.cache/jr/v1/<profile>/` (Unix/macOS) or `%LOCALAPPDATA%\jr\v1\<profile>\` (Windows).

---

## Other Counts

| Claim | Canonical Value | Source |
|-------|----------------|--------|
| Bounded contexts | 8 (bc-1..bc-8) + 1 cross-cutting | README.md Document Map |
| HTTP method types | 11 (Pass 2 R1 verified) | Pass 2 deep R1 §inventory |
| API resource files | 18 (`api/jira/*`, `api/jsm/*`, `api/assets/*`) | adr-index.md ADR-0001 harmonization |
| list.rs LOC (post-split) | 1,256 | `wc -l src/cli/issue/list.rs` |
| auth.rs LOC | 1,875 | `wc -l src/api/auth.rs` |

---

## How to Update This File

When a pass adds or removes BCs, NFRs, holdouts, risks, or ADRs:
1. Run the verification command for the affected category
2. Update the table in this file
3. Update the corresponding `total_bcs`/`definitional_count` frontmatter in the affected body file
4. Update BC-INDEX.md and README.md if BC grand total changes
5. Reference this file from any new count claim: "per CANONICAL-COUNTS.md"
6. For a new ADR: update the `## ADRs` section's canonical count, add a bullet naming the new ADR's subject, and verify it also has a row in `.factory/architecture/adr-index.md`'s Summary Table
