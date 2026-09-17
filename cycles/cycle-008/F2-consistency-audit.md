---
document_type: consistency-report
cycle: cycle-008
title: "OAuth surface correctness — F2 spec delta consistency audit (pre-human-gate)"
scope: "cycle-008 F2 spec delta — ADR-0026, verification-delta.md, F2-architecture-delta.md, bc-1/bc-4/bc-5/cross-cutting BC amendments, BC-INDEX.md, CANONICAL-COUNTS.md"
inputs:
  - .factory/specs/architecture/decisions/ADR-0026-oauth-3lo-gateway-routing-invariant-and-granular-jira-software-scopes.md
  - .factory/specs/architecture/ARCH-INDEX.md
  - .factory/cycles/cycle-008/verification-delta.md
  - .factory/cycles/cycle-008/F2-architecture-delta.md
  - .factory/specs/prd/bc-4-assets-cmdb.md
  - .factory/specs/prd/bc-1-auth-identity.md
  - .factory/specs/prd/cross-cutting.md
  - .factory/specs/prd/bc-5-boards-sprints.md
  - .factory/specs/prd/BC-INDEX.md
  - .factory/specs/prd/CANONICAL-COUNTS.md
  - .factory/cycles/cycle-008/F1-delta-analysis.md
  - .factory/cycles/cycle-008/research-oauth-endpoints.md
producer: consistency-validator
date: 2026-09-17
status: audit-complete-awaiting-human-gate
input-hash: "8ed514a"
---

# Cycle-008 F2 Spec Delta — Consistency Audit

**Method:** Fresh-context read of every artifact in scope (no assumption that prior agent
passes were correct); independent re-derivation of every cross-reference claimed in
ADR-0026/verification-delta.md/F2-architecture-delta.md against the actual BC bodies,
`git diff` of the `.factory` worktree (tracks `factory-artifacts` branch) against its
last commit, and re-execution of all 4 count/citation guard scripts. No files were
modified.

## Overall Verdict: **INCONSISTENT**

One finding (F-1) is a factual misstatement inside ADR-0026 itself — it claims completed
work that was never actually performed. This should be corrected (either perform the
claimed edits or remove the false claim) before the F2 human gate closes. A second
finding (F-2) is a real, corroborated spec-hygiene gap in `bc-1-auth-identity.md`,
consistent with the FUEL_EXHAUSTED concern, but it does not corrupt the BC's actual
content. Everything else checked — ADR↔BC↔VP coherence, scope fidelity to DEC-368, count
integrity, cross-reference immutability (BC-1.6.042-045, BC-3.8.015), and perimeter
completeness — is CONSISTENT.

---

## Guard script results (re-run fresh, all from `jira-cli/` root)

| Script | Exit code | Output |
|---|---|---|
| `scripts/check-spec-counts.sh` | **0** | "Check passed: 8 bc files validated" |
| `scripts/check-bc-cumulative-counts.sh` | **0** | "OK: all cumulative BC counts verified (770 total across 9 files; Surface H footer checked where present)." |
| `scripts/check-bc-no-numeric-test-counts.sh` | **0** | "OK: no numeric test counts in BC Trace/Source fields." |
| `scripts/check-bc-citation-symbols.sh` | **0** | "Check passed: 526 citations checked" |

**Total = 770 confirmed** across all checked surfaces: `BC-INDEX.md` frontmatter
(`total_bcs: 770`), `CANONICAL-COUNTS.md` `last_verified` note and Sum row, and
`cross-cutting.md`'s section-header prose (`160 BCs cumulative; 94 individually-bodied`).
Per-file `definitional_count` values (bc-1: 72, bc-4: 22, bc-5: 18, cross-cutting: 94) all
match live `grep -c '^#### BC-'` counts and `CANONICAL-COUNTS.md`'s per-file table —
COUNT-NEUTRAL claims for BC-4.2.001/BC-1.3.023/BC-5.1.001 amendments are correct (no
heading added/removed for any of the three), and the single genuine addition
(BC-X.15.001) is the only contributor to the 769→770 delta. All 9 surfaces agree.

---

## Findings

### F-1 — [MAJOR] ADR-0026's "Bidirectional backlink note" is FALSE — claimed edits do not exist

**Location:** `.factory/specs/architecture/decisions/ADR-0026-oauth-3lo-gateway-routing-invariant-and-granular-jira-software-scopes.md`, final blockquote under "## Related ADRs":

> "`docs/adr/0009-handle-open-instance-url.md`, `docs/adr/0006-embedded-jr-oauth-app.md`, and
> `docs/adr/0013-pkce-deferral.md` each received a short forward-reference note pointing to
> ADR-0026 (see each file's own 'Related ADRs' addendum)."

**Verified false.** Independently checked all three files:
- `grep -n "ADR-0026" docs/adr/0009-handle-open-instance-url.md docs/adr/0006-embedded-jr-oauth-app.md docs/adr/0013-pkce-deferral.md` → **zero hits in all three files.**
- `git status --porcelain docs/adr/` → **empty** (no uncommitted changes anywhere under `docs/adr/`).
- `git log -1` on each file shows last real content commits from 2026-06-24 (0009, 0013)
  and 2026-05-01 (0006) — none touched today.
- Read the tail/"See Also" section of all three files directly: none contains a "Related
  ADRs" section or any mention of ADR-0026. `0009` ends with a "See Also" list citing only
  ADR-0006; `0006` ends with "## Supersedes" (no See Also/Related ADRs at all); `0013` ends
  with a "See Also" list citing only ADR-0006, RFC 7636/8252.

**Why this matters:** ADR-0026's own Decision section and "Consequences" both cross-reference
this backlink as evidence the pre-VSDD ADR track (`docs/adr/`) was kept in sync. It was not.
This is not a stale-vs-current drift (like F-2 below) — it's an affirmative claim of
completed work, inside an architecture-decision artifact headed for a human approval gate,
that is simply untrue. A reviewer trusting this ADR's own self-report would believe the
cross-track link exists when it does not.

**Remediation (pick one, not both):**
(a) actually apply the three one-line backlink edits before the gate closes, or
(b) remove/correct the false claim in ADR-0026's "Related ADRs" section to accurately state
the backlinks are NOT yet applied (e.g., "pending, tracked as an F2 follow-up" or similar).

---

### F-2 — [MEDIUM] `bc-1-auth-identity.md` frontmatter was not synced for the cycle-008 amendment (corroborates the FUEL_EXHAUSTED concern)

**Location:** `.factory/specs/prd/bc-1-auth-identity.md`, lines 1-47 (YAML frontmatter block).

Of the four spec files this F2 delta amends (`bc-1-auth-identity.md`, `bc-4-assets-cmdb.md`,
`bc-5-boards-sprints.md`, `cross-cutting.md`), **three of the four received a matching entry
in their top-level frontmatter `trace:` YAML block** documenting the cycle-008 change:

- `bc-4-assets-cmdb.md` frontmatter `trace:` — has a cycle-008 entry, AND `last_updated`
  bumped to `2026-09-17`.
- `bc-5-boards-sprints.md` frontmatter `trace:` — has a cycle-008 entry (though
  `last_updated` was left at `2026-06-30`, unrelated pre-existing convention gap).
- `cross-cutting.md` frontmatter `trace:` — has a cycle-008 entry (though `last_updated`
  was left at `2026-09-06`, same pre-existing gap).
- **`bc-1-auth-identity.md` frontmatter `trace:` block — has NO cycle-008 entry at all.**
  Confirmed by `awk` isolating exactly the frontmatter block (lines 1-47) and grepping it
  for `cycle-008`: zero matches. `last_updated` is also still `2026-09-11` (pre-dates the
  2026-09-17 amendment).

The cycle-008 amendment to BC-1.3.023 is documented **only inline, inside the BC's own body
`Trace:` field** (line 827) — never propagated up to the file-level frontmatter log that the
other three touched files all received. This is exactly the shape of gap you'd expect if a
per-file frontmatter-sync validation step was skipped for this one file (consistent with the
task's report that bc-1's write hit a FUEL_EXHAUSTED cap and the hook may have been skipped
rather than passed).

**Independent verification of BC-1.3.023's own body (the part that WAS written), to isolate
whether the skip let a content defect through too:**
- Template shape matches its siblings: STATUS/Confidence/Source/Subject/Behavior/Effects/
  Maintainer coordination/RELEASE GATE/Trace fields all present, well-formed, and in the
  file's established order.
- Citations are compliant: `grep -E '\.rs:[0-9]'` (bare, non-tilde form) over the amended
  region (lines 791-829) returns **zero hits** — every source citation uses the `:~NN`
  approximate form (`src/api/auth.rs:~34`, `:~59`, `:~46`) per CLAUDE.md's convention. No
  TD-031 volatile-citation regression introduced.
- `scripts/check-bc-citation-symbols.sh` passed at 526 citations checked, 0 offenders —
  this run necessarily included bc-1's amended region.
- `definitional_count: 72` / `total_bcs: 83` in bc-1's frontmatter are still numerically
  correct (`grep -c '^#### BC-'` → 72, matches `CANONICAL-COUNTS.md`'s per-file table) —
  the amendment is genuinely COUNT-NEUTRAL as claimed; no BC was silently added/removed.
- BC-1.6.042/043/044/045 (the generic `InsufficientScope` Display contract, explicitly
  required to stay untouched) are confirmed byte-unchanged: `git diff` on
  `bc-1-auth-identity.md` shows zero lines touching those four headings' bodies.

**Verdict on the FUEL_EXHAUSTED re-verification:** the skip (if real) did **not** let a
body-level template or content defect into BC-1.3.023 — the amendment itself is
well-formed, citation-compliant, and count-neutral as claimed. What it DID let slip is the
file-level frontmatter traceability log, which is now inconsistent with the other three
files in the same delta (3 of 4 got a top-level trace entry; bc-1 did not). This is a
spec-hygiene gap, not a behavioral-contract defect, but it should be fixed — add a
frontmatter `trace:` entry to `bc-1-auth-identity.md` mirroring the ones already present in
`bc-4`/`bc-5`/`cross-cutting.md` — before treating bc-1's re-verification as fully closed.

---

### F-3 — [LOW, informational] `F1-delta-analysis.md` contains bare volatile line-citations (TD-031-style pattern, but outside the enforced surface)

**Location:** `.factory/cycles/cycle-008/F1-delta-analysis.md` (upstream input, explicitly
in this audit's scope).

At least 15 bare `file.rs:NNN` / `file.rs:NNN-MM` citations without the `~` approximate
marker, e.g.: `src/api/jsm/servicedesks.rs:22`, `src/api/client.rs:91-101`,
`src/api/client.rs:773`, `src/api/client.rs:1045`, `src/cli/issue/jsm_create.rs:385-433`,
`src/api/client.rs:193-209`, `src/cli/auth/login.rs:27-34`, `src/api/auth.rs:2136`, etc.
(§1 items 1-5, §2.1 table, §2.4, §2.5, §5).

This is the same volatile-citation pattern TD-031 exists to prevent (and which `bc-4`'s
frontmatter note explicitly says was swept out of that file this same cycle: "21
pre-existing TD-031 volatile line cites in this file converted from `:NNN` to `:~NNN`
form"). However:
- `scripts/check-bc-citation-symbols.sh` only scopes `.factory/specs/prd/bc-*.md` —
  `F1-delta-analysis.md` is a `.factory/cycles/` working document, outside that guard's
  reach, so this was never mechanically caught (confirmed: the script passed at 526/0
  offenders, and none of those 526 are from this file).
- By contrast, the actual governed F2 spec-delta artifacts (`ADR-0026`, `verification-delta.md`,
  `F2-architecture-delta.md`, and all touched BC bodies) were independently re-checked and
  contain **zero** bare volatile citations — they consistently use File::Symbol form or
  `:~NN`. TD-031 is satisfied for the surface that actually ships into the PRD corpus.

**Assessment:** not blocking. `F1-delta-analysis.md` is a point-in-time code-audit snapshot,
not a living spec citing code that will be edited in place going forward — but it is kept
permanently under `.factory/cycles/cycle-008/` and is cross-referenced by filename from
ADR-0026/BC bodies, so its line numbers will silently go stale the moment S1-S5's
implementation touches those exact lines. Recommend either tilde-izing this file's
citations for consistency with the corpus-wide convention, or noting explicitly (as
`research-oauth-endpoints.md` implicitly does by citing only external doc URLs) that it is
a frozen audit artifact exempt from the line-citation-drift convention.

---

### F-4 — [COSMETIC, non-blocking] Inconsistent use of the new "Verification" field within the same delta

`BC-4.2.001` introduces a dedicated `**Verification**: VP-OAUTH-GW-001 — ...` field, but
`BC-1.3.023` and `BC-X.15.001` (same cycle, same VP delta, each also attaching a VP) reference
their VPs only via the STATUS line and Trace field, not a matching dedicated field. Neither
choice is wrong against the corpus's actual precedent (only 1 of ~540 BCs project-wide uses a
dedicated Verification field at all, and it's the one this same cycle just introduced), but
it's a small internal inconsistency introduced within a single delta. Not blocking; noted for
completeness only.

---

## Checklist results (per the audit's 7 questions)

**1. ADR-0026 ↔ BC coherence** — CONSISTENT (with F-1's caveat above, which is about the
ADR's honesty toward a *different* artifact class, not its BC mapping). Decision 1 → BC-4.2.001
(VP-OAUTH-GW-001 attached, 7-call-site table verbatim-matches between the two documents).
Decision 2 → BC-1.3.023 (VP-OAUTH-GW-002 attached, 7-scope list verbatim-matches). Decision 3 →
BC-X.15.001 (VP-OAUTH-GW-003 attached, three-class taxonomy verbatim-matches). Decision 4
(Teams) correctly produces **no** BC/VP — deferred to spike S6, exactly per DEC-368. No ADR
decision is left without a BC; no new BC (BC-X.15.001) is untraceable to the ADR/F1 scope.

**2. VP ↔ BC attachment** — CONSISTENT. All three VP labels (`VP-OAUTH-GW-001/002/003`) are
literally present inline in their target BC bodies (STATUS line + Trace line, plus a
dedicated Verification field for BC-4.2.001 only — see F-4). Each VP's own definition in
`verification-delta.md` matches what its BC claims: same 7 call sites, same 7 scopes plus
explicit Teams-scope exclusion, same 3-class 401 taxonomy plus the BC-3.8.015 regression
guard.

**3. Scope fidelity to DEC-368** — CONSISTENT. No Teams re-platform contract was added
anywhere in the delta: `BC-X.6.002/003/004` (`cross-cutting.md`) are confirmed byte-unchanged
by `git diff` (zero touched lines in that section). Teams scopes (`view:team:teams`,
`view:membership:teams`) are explicitly excluded, with a companion negative-assertion test
obligation (VP-OAUTH-GW-002), not merely omitted. The two F1-resolved non-issues — the
hypothesized `backlog/issue` GET path and the auth-URL scope-union builder — are correctly
recorded as "no fix needed" / "no code change required" (ADR-0026 Decision 2's builder note;
F1 §1 items 3-4) and are **not** reintroduced as work in any story/workstream table in
`F2-architecture-delta.md`.

**4. Count integrity** — CONSISTENT. See guard-script table above; all 4 scripts exit 0;
total = 770 confirmed across BC-INDEX.md frontmatter, CANONICAL-COUNTS.md, and
cross-cutting.md's own section-count prose.

**5. Citation/template integrity, bc-1 FUEL_EXHAUSTED re-verification** — see F-2 (frontmatter
gap, real) and F-3 (informational, upstream doc only). bc-1's actual BC-1.3.023 body content
is template-compliant, citation-compliant (no TD-031 regressions), and count-neutral as
claimed — the skip (if it occurred) manifests as a missing frontmatter trace-log entry, not
a body-content or citation defect.

**6. Cross-references** — CONSISTENT. `BC-1.6.042-045` confirmed byte-for-byte unchanged
(zero diff hits on those four headings). `BC-3.8.015` confirmed unchanged — `bc-3-issue-write.md`
is not even in this delta's list of modified files (`git diff --stat` over the `.factory`
worktree shows only `STATE.md`, `sidecar-learning.md`, `specs/architecture/ARCH-INDEX.md`,
`specs/prd/BC-INDEX.md`, `specs/prd/CANONICAL-COUNTS.md`, `specs/prd/bc-1-auth-identity.md`,
`specs/prd/bc-4-assets-cmdb.md`, `specs/prd/bc-5-boards-sprints.md`,
`specs/prd/cross-cutting.md` as modified, plus the two new files
`cycles/cycle-008/{F2-architecture-delta,verification-delta}.md` and the new ADR file).
BC-X.15.001 explicitly names both BC-1.6.042-045 and BC-3.8.015 in its own "Explicitly NOT
changed by this BC" section, matching what was actually (not) done.

**7. Perimeter check** — CONSISTENT; perimeter is right. All 7 corrected routing call sites
(6 JSM: `list_service_desks`, `list_request_types`, `get_request_type_fields`,
`list_queues`, `get_queue_issue_keys`, `create_jsm_request`; 1 Assets:
`get_or_fetch_workspace_id`) fall under BC-4.2.001's unified fix table — verified verbatim
match, symbol-for-symbol, between ADR-0026 Decision 1's table and BC-4.2.001's table. No
orphaned call site. The transitively-dependent-but-code-unchanged case
(`src/api/jsm/attachments.rs`) is correctly flagged for verification-only coverage (S5), not
left undocumented. The confirmed-already-correct Assets AQL/object/schema/enrichment paths
(`objects.rs`/`linked.rs`/`schemas.rs`/`tickets.rs`) are correctly left with NO BC change,
consistent with F1's own code audit. Teams (Workstream D) correctly has zero BC/VP by
design — this is the one area of the OAuth surface intentionally left without a BC
amendment this cycle, and that omission is itself documented (ADR-0026 §4,
F2-architecture-delta.md's S6 section), not silent.

---

## Summary for the human gate

- **Block or fix before/at gate close:** F-1 (ADR-0026's false backlink claim) — either
  perform the three one-line edits to `docs/adr/0006`/`0009`/`0013`, or correct ADR-0026's
  own text to stop claiming they exist.
- **Should fix, non-blocking:** F-2 (bc-1's missing frontmatter trace-log entry) — one-line
  addition mirroring the pattern already used in bc-4/bc-5/cross-cutting.
- **Worth noting, non-blocking:** F-3 (F1-delta-analysis.md's volatile citations, outside
  guard scope) and F-4 (cosmetic Verification-field inconsistency).
- Everything else — the ADR/BC/VP traceability chain, DEC-368 scope fidelity, count
  integrity across all 9 surfaces, and the immutability of BC-1.6.042-045/BC-3.8.015 — is
  confirmed CONSISTENT by independent, fresh-context re-derivation.
