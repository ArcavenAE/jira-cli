# Cycle Summary — Full-Text Frontmatter Status (extracted from STATE.md)

> Extracted from `.factory/STATE.md` frontmatter fields during the 2026-09-10
> `/compact-state` compaction (v4.03 -> v4.04). STATE.md's frontmatter now
> carries a one-line status + pointer to this file for each field below;
> the full verbatim text that used to live inline in STATE.md's frontmatter
> is preserved here, unedited.

## `phase_3_status` (pre-cycle-numbering era, SOH-ATTACHMENTS-1)

> SOH-ATTACHMENTS-1 F5 SCOPED ADVERSARIAL CONVERGED 2026-07-24 STRICT (14 rounds; window pass-12/pass-13/pass-14 CLEANx3; spec v1.3.99 to v1.3.106; BC-INDEX v6.38 to v6.44; develop @ db207b81) + F7 DELTA CONVERGENCE APPROVED 2026-07-25 (DEC-186; 5-dim PASS; MAXIMUM_VIABLE_REFINEMENT_REACHED) + CYCLE FULLY CLOSED 2026-07-25

## `cycle_001_status`

> list-read-ergonomics -- CLOSED (DEC-309), historical; see cycles/cycle-001/

## `cycle_002_status`

> field-dx -- CLOSED + RELEASED 2026-09-01 (DEC-311 close; v0.7.0-dev.3 tagged @ 87f17aff, release.yml run 33459579699 triggered). All 5 stories delivered/merged (F4); F5 CONVERGED (FIX-F5-001, PR #747); F6 COMPLETE (FIX-F6-001, PR #749); F7 COMPLETE (5-dim convergence PASS + full regression PASS 4660/0/106, FIX-F7-001, PR #750 @ 2000c455); RELEASED (version bump PR #751 @ 87f17aff, tag v0.7.0-dev.3 pushed, release.yml triggered). Pipeline SHIPPED.

## `cycle_003_status`

> auth-profile-dx -- CLOSED + RELEASED 2026-09-03 (v0.7.0-dev.4 @ 42e92b46, PR #767; release.yml run 33769389700 SUCCESS; GitHub prerelease published, 10 assets/5 targets). F1-F7 complete + released. Pipeline shipped.

## `cycle_004_status`

> windows-correctness -- CLOSED + RELEASED 2026-09-06 (DEC-343; v0.7.0-dev.5 @ 569d85a8, PR #777; release.yml run 34046676423 SUCCESS; GitHub prerelease published, 10 assets/5 targets). F1-F7 complete + released. Pipeline shipped.

## `cycle_005_status`

> adf-mentions -- CLOSED, NO RELEASE, 2026-09-09 (DEC-353; feature ships on develop @ cef4a021, tag deferred to a future release riding cycle-005 + cycle-006). F1 APPROVED (DEC-344); F2 APPROVED (DEC-345 tightening + DEC-346); F3 APPROVED (DEC-347, 2-wave decomposition, 174 stories). F4 (delta implementation) COMPLETE -- Wave 1 (S-cycle5-mention-pure-conversion) MERGED via the >120-mutant escape-hatch admin-bypass (DEC-352, PR #778 @ 708c8b32); Wave 2 (S-cycle5-mention-resolution-wiring) MERGED via a normal green merge (PR #794 @ 0eaf4268, cycle-006 sharded mutation gate ran to completion, no escape-hatch). Closes GitHub #674 in full. F5 (scoped adversarial refinement) CONVERGED -- 3 consecutive clean-tier passes; Pass-1's F-M1 [MED]/F-L1 [LOW] fixed via FIX-F5-001/PR #795 @ cef4a021. F6 (targeted hardening) COMPLETE/HARDENED -- VP-674-001..021 20/21 fully COVERED, VP-674-005 documented deferral (unreachable residual); mutation posture GREEN with zero escalation on PR #794/#795; Kani/cargo-fuzz JUSTIFIED-SKIP (0-GAP). F7 (delta convergence) reached a 5-dimensional PASS and was HUMAN-APPROVED at the gate (DEC-353), 2026-09-09, cycle CLOSED with NO release cut. S-7.02 cycle-closing checklist: human chose RECORD DEFERRALS ONLY -- see Drift/Standing Items (cycle-005 CLOSE consolidated set). Pipeline SHIPPED to develop, unreleased. Full detail: phase-f1-delta-analysis/cycle-005/ + phase-f2-spec-evolution/{prd,verification,architecture}-delta-674.md + cycles/cycle-005/phase-f3-stories/ + .factory/sprint-state.yaml cycle_005_adf_mentions + cycles/cycle-005/burst-log.md Bursts 1-13 + phase-f6-hardening/cycle-005/hardening-report.md.

## `cycle_006_status`

> mutants-ci-sharding -- CLOSED (DEC-348/349/350/351), NO RELEASE (CI-infrastructure-only; shipped binary byte-identical; next release rides cycle-005). F1 APPROVED 2026-09-07 (DEC-348); F2 APPROVED at the gate 2026-09-07 (DEC-349, 16-pass adversarial convergence); F3 APPROVED at the gate 2026-09-08 (DEC-350, story convergence 32/33/34); F4 (delta implementation) COMPLETE + MERGED 2026-09-09 -- PR #791 squash-merged to develop @ a9168212 (Step-4.5 3-consecutive-clean via 7 trios/21 passes/6 fix rounds; pr-reviewer APPROVE; security-reviewer near-clean; all 24 CI checks passed incl. the sharded pipeline's first live production run); F5 (scoped adversarial refinement) and F6 (targeted hardening) completed with no separate human gate (feature-mode convention -- results folded into F7's evidence); F7 (delta convergence, Burst 13) reached a 5-dimensional PASS and was human-APPROVED at the gate (DEC-351), 2026-09-09, cycle CLOSED with NO release cut. S-7.02 cycle-closing checklist executed: 6 items recorded as justified deferrals at close (STALE-RED-NARRATIVE-PATTERN, EXAMINE-GLOBS-SHRINK-RESIDUAL, BARE-JQ-TOKENIZER-RESIDUAL, GITHUB-OPS-WATCH-HANG, F-PC-MED-001, CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS); F-PE-MED-001 and R-F2 marked RESOLVED/CLOSED (not deferrals). CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS was itself subsequently RESOLVED 2026-09-09 by the standalone PR #793 (@ 5b00b31e) -- see Drift/Standing Items. This cycle's mutation-gate machinery (mutants-plan/8-shard-matrix/mutants-aggregate) has now been proven three times in real production PRs: once via the >120-mutant escape hatch (PR #778, DEC-352), once running to full completion with zero escalation (PR #794, cycle-005 Wave 2), and once again running to full completion with zero escalation on a small fix diff (PR #795, cycle-005 F5). Full detail: phase-f1-delta-analysis/cycle-006/ + phase-f2-spec-evolution/cycle-006/ + cycles/cycle-006/phase-f3-stories/ + cycles/cycle-006/blocking-issues-resolved.md + cycles/cycle-006/session-checkpoints.md + cycles/cycle-006/burst-log.md Bursts 1-13 + Decisions Log DEC-348/349/350/351.

## Convergence Status detail (extracted from STATE.md `## Convergence Status`)

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): historical.

`cycle-002` (`field-dx`) F2-F7 COMPLETE, human-authorized at the F7 gate (DEC-311). RELEASED 2026-09-01 as `v0.7.0-dev.3`. Historical.

`cycle-003` (`auth-profile-dx`) F1-F7 all COMPLETE, human-approved at every gate. RELEASED 2026-09-03 as `v0.7.0-dev.4` (DEC-333). cycle-003 is CLOSED -- SHIPPED, historical.

`cycle-004` (`windows-correctness`) F1-F7 COMPLETE, human-authorized at every gate (DEC-335 through DEC-343). RELEASED 2026-09-06 as `v0.7.0-dev.5`; CLOSED -- SHIPPED, historical. Full detail: `cycles/cycle-004/burst-log.md` Bursts 1-22.

`cycle-005` (`adf-mentions`, GitHub #674) F1-F7 all COMPLETE, human-approved at every gate (DEC-344, DEC-345/346, DEC-347, DEC-352 (Wave 1 admin-bypass merge), DEC-353 (F7 close)). Both waves merged to `develop` (Wave 1 PR #778 @ `708c8b32`; Wave 2 PR #794 @ `0eaf4268`); F5 CONVERGED (FIX-F5-001/PR #795 @ `cef4a021`); F6 COMPLETE/HARDENED (20/21 VPs, `phase-f6-hardening/cycle-005/hardening-report.md`); F7 reached a 5-dimensional PASS and was human-APPROVED at the gate, NO RELEASE CUT -- feature ships on `develop @ cef4a021` unreleased, tag deferred to a future release riding cycle-005 + cycle-006. cycle-005 is CLOSED -- SHIPPED-TO-DEVELOP-UNRELEASED, historical. Full detail: `cycles/cycle-005/phase-f3-stories/` + `.factory/sprint-state.yaml` `cycle_005_adf_mentions` + `cycles/cycle-005/burst-log.md` Bursts 1-13 + `phase-f6-hardening/cycle-005/hardening-report.md`.

`cycle-006` (`mutants-ci-sharding`) F1-F7 all COMPLETE, human-approved at every gate (DEC-348 through DEC-351). NO RELEASE CUT -- CI-infrastructure-only; the shipped `jr` binary is byte-identical; the next release rides cycle-005. cycle-006 is CLOSED -- historical. One of its 6 S-7.02 deferrals (`CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS`) was subsequently RESOLVED at cycle-005 Burst 6. Its mutation-gate machinery has now been proven three times in real production PRs (PR #778 via escape hatch; PR #794 and PR #795 each running to full completion with zero escalation). The 2026-09-10 MUTANTS-NIGHTLY-REBALANCE-2026-09-10 event separately hardened the CI-tooling's advisory nightly full-scope run (distinct from the sharded gate above) via PR #799 @ `78aeb86c`. Full detail: `cycles/cycle-006/burst-log.md` Bursts 1-13 + `cycles/cycle-006/blocking-issues-resolved.md`.

## Concurrent Cycles detail (extracted from STATE.md `## Concurrent Cycles`)

Six tracked cycles, ALL CLOSED as of 2026-09-10. `cycle-001` is CLOSED, historical. `cycle-002` (`field-dx`) is CLOSED + RELEASED (2026-09-01), historical. `cycle-003` (`auth-profile-dx`) is CLOSED + RELEASED (2026-09-03, DEC-333) as `v0.7.0-dev.4` @ `42e92b46`, historical. `cycle-004` (`windows-correctness`) is CLOSED + RELEASED (2026-09-06, DEC-343) as `v0.7.0-dev.5` @ `569d85a8`, historical. `cycle-006` (`mutants-ci-sharding`) is CLOSED, NO RELEASE (2026-09-09, DEC-348/349/350/351) -- F1-F7 all complete; PR #791 merged to `develop` @ `a9168212`; CI-infrastructure-only, shipped binary byte-identical, next release rides cycle-005; historical. `cycle-005` (`adf-mentions`, GitHub #674) is CLOSED, NO RELEASE (2026-09-09, DEC-344/345/346/347/352/353) -- Phase F1 APPROVED (DEC-344), Phase F2 APPROVED (DEC-345/DEC-346), Phase F3 APPROVED (DEC-347), Phase F4 (delta implementation) COMPLETE -- both waves merged to `develop` (Wave 1 PR #778 @ `708c8b32` via admin-bypass DEC-352; Wave 2 PR #794 @ `0eaf4268` via a normal green merge); Phase F5 CONVERGED (FIX-F5-001/PR #795 @ `cef4a021`); Phase F6 COMPLETE/HARDENED (20/21 VPs covered, mutation posture GREEN, `phase-f6-hardening/cycle-005/hardening-report.md`); Phase F7 (delta convergence) reached a 5-dimensional PASS and was HUMAN-APPROVED at the gate, cycle CLOSED with NO release cut -- the feature ships on `develop @ cef4a021` unreleased; the tag is deferred to a future release that will ride both cycle-005 and cycle-006. `develop`'s real tip is `78aeb86c` (PR #799 merged); `activation_head` frontmatter stays `a9168212` -- no release tag was cut. No OPEN cycle remains anywhere in the factory. Live-Jira E2E round-trip (`H-NEW-MENTION-009`, AC-017) remains DEFERRED, now a human-owned post-close standing follow-up.
